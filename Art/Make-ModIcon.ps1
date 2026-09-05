<#
.SYNOPSIS
  Cuts Mod/About/ModIcon.png out of the mod's own dust bunny sprite.

.DESCRIPTION
  The sprite lives on a 256x256 canvas and only occupies 91x83 of it, off centre - the rest is
  transparent padding the game does not care about but a 32-pixel mod-list thumbnail very much
  does. Handed the file as it stands, the icon would be a grey speck in an empty square.

  So: find the opaque bounding box, pad it to a square around its centre so the bunny is not
  stretched, and scale that to 128 px. 128 is already generous - the mod list draws the icon at
  roughly 32 - but it costs about 20 KB and survives a future UI that draws it larger.

  Kept in the repository so the crop can be redone rather than guessed at. It is not published:
  Art/ sits outside Mod/, which is the only directory the Workshop uploader ever sees.

.EXAMPLE
  powershell -File Art/Make-ModIcon.ps1
#>
param(
    [string]$Source = (Join-Path $PSScriptRoot '..\Mod\Textures\DustBunny\Bunny\Dust_Bunny_east.png'),
    [string]$Out    = (Join-Path $PSScriptRoot '..\Mod\About\ModIcon.png'),
    [int]$Size      = 128,
    # Breathing room around the sprite, as a fraction of the square side.
    [double]$Margin = 0.08
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$src = [System.Drawing.Bitmap]::FromFile((Resolve-Path $Source))

# Opaque bounding box. Alpha 8 rather than 0: the sprite has a soft edge, and a threshold of
# zero would drag in stray near-invisible pixels.
$minX = $src.Width; $minY = $src.Height; $maxX = -1; $maxY = -1
for ($y = 0; $y -lt $src.Height; $y++) {
    for ($x = 0; $x -lt $src.Width; $x++) {
        if ($src.GetPixel($x, $y).A -gt 8) {
            if ($x -lt $minX) { $minX = $x }
            if ($x -gt $maxX) { $maxX = $x }
            if ($y -lt $minY) { $minY = $y }
            if ($y -gt $maxY) { $maxY = $y }
        }
    }
}
if ($maxX -lt 0) { throw "No opaque pixel in $Source." }

$w = $maxX - $minX + 1
$h = $maxY - $minY + 1

# Square the box around the sprite's own centre, then add the margin. Cropping to the raw
# rectangle instead would squash a 91x83 bunny into a square icon.
$side = [Math]::Ceiling([Math]::Max($w, $h) * (1.0 + 2 * $Margin))
$cx   = $minX + $w / 2.0
$cy   = $minY + $h / 2.0
$left = [int][Math]::Round($cx - $side / 2.0)
$top  = [int][Math]::Round($cy - $side / 2.0)

Write-Host "sprite $($w)x$($h) at ($minX,$minY) -> square $side at ($left,$top) -> $($Size)px"

$dst = New-Object System.Drawing.Bitmap($Size, $Size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g   = [System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode  = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.PixelOffsetMode    = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$g.SmoothingMode      = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
$g.Clear([System.Drawing.Color]::Transparent)

$g.DrawImage($src,
    (New-Object System.Drawing.Rectangle(0, 0, $Size, $Size)),
    $left, $top, $side, $side,
    [System.Drawing.GraphicsUnit]::Pixel)

$g.Dispose()

$full = [System.IO.Path]::GetFullPath($Out)
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $full) | Out-Null
$dst.Save($full, [System.Drawing.Imaging.ImageFormat]::Png)
$dst.Dispose()
$src.Dispose()

Write-Host "wrote $full ($([Math]::Round((Get-Item $full).Length / 1KB, 1)) KB)"
