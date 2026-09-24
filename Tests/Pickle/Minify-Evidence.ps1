<#
.SYNOPSIS
  Shrinks a Pickle report folder to what still proves something, in place. No game, a few seconds.

.DESCRIPTION
  A Pickle report is dominated by files nobody reads twice: report.html and messages.ndjson (tens of megabytes
  each, both derived from junit.xml and summary.json) and full-size PNG screenshots of 2 to 4 MB. The disk is
  shared and full, so after a run the report is reduced to:

    kept as is   junit.xml, summary.json, summary.md, Player.log, evidence-complete.txt, films (*.webm) and
                 their frames, any other small file
    re-encoded   every *.png becomes a JPEG (quality 80, at most 1280 px wide), the original removed. About 10 to
                 20 times smaller, still readable for a review capture
    removed      report.html, messages.ndjson

  Nothing is deleted before the re-encoded picture is written. Run it on the folder under Tests/Pickle/Evidence/
  that a completed run was copied to; the folder stays on disk and out of git (see TESTING.md, "Evidence to keep"), and a
  text summary of the run goes to docs/runs/.

  A screenshot is an evidence of what was on screen, not of pixels: this is fine for "is the button reachable"
  and not for "is the colour exactly that". Keep the original of a capture that has to be measured.

.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File Tests/Pickle/Minify-Evidence.ps1 -Folder Tests/Pickle/Evidence/2026-09-24-English
#>
param(
    [Parameter(Mandatory)][string]$Folder,
    [int]$MaxWidth = 1280,
    [int]$Quality = 80
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

if (-not (Test-Path -LiteralPath $Folder -PathType Container)) { throw "no such folder: $Folder" }
$Folder = (Resolve-Path -LiteralPath $Folder).Path

function Get-Size($path) {
    (Get-ChildItem -LiteralPath $path -Recurse -File | Measure-Object -Property Length -Sum).Sum
}

$before = Get-Size $Folder
$jpegCodec = [Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
$params = New-Object Drawing.Imaging.EncoderParameters 1
$params.Param[0] = New-Object Drawing.Imaging.EncoderParameter ([Drawing.Imaging.Encoder]::Quality), ([long]$Quality)

$converted = 0
foreach ($png in Get-ChildItem -LiteralPath $Folder -Recurse -File -Filter *.png) {
    $target = [IO.Path]::ChangeExtension($png.FullName, '.jpg')
    $src = [Drawing.Image]::FromFile($png.FullName)
    try {
        $w = [Math]::Min($src.Width, $MaxWidth)
        $h = [int]($src.Height * $w / $src.Width)
        $bmp = New-Object Drawing.Bitmap $w, $h
        try {
            $g = [Drawing.Graphics]::FromImage($bmp)
            $g.InterpolationMode = [Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
            $g.DrawImage($src, 0, 0, $w, $h)
            $g.Dispose()
            $bmp.Save($target, $jpegCodec, $params)
        } finally { $bmp.Dispose() }
    } finally { $src.Dispose() }

    if (-not (Test-Path -LiteralPath $target) -or (Get-Item -LiteralPath $target).Length -eq 0) {
        throw "the re-encoded picture of $($png.Name) was not written: the original is kept"
    }
    Remove-Item -LiteralPath $png.FullName -Force
    $converted++
}

$removed = @()
foreach ($name in 'report.html', 'messages.ndjson') {
    $p = Join-Path $Folder $name
    if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p -Force; $removed += $name }
}

$after = Get-Size $Folder
'{0}: {1:N1} MB -> {2:N1} MB; {3} picture(s) re-encoded; removed: {4}' -f `
    (Split-Path $Folder -Leaf), ($before / 1MB), ($after / 1MB), $converted, ($(if ($removed) { $removed -join ', ' } else { 'nothing' }))
