<#
.SYNOPSIS
  Checks that every step line of this suite's features resolves to exactly one step definition, and
  that every pattern this suite declares compiles. No game, a few seconds.

.DESCRIPTION
  A step that does not exist costs a whole run on a machine shared by every session, and an invalid
  pattern costs more: Pickle builds its step table before it plays anything, so one bad pattern makes
  the run play zero scenarios and report infrastructure-error. This is the check that finds both
  before the ticket is taken.

  It does three things, all against Pickle's own expression engine and not against a guess:

    1. Every pattern declared under Source\ COMPILES with the registry the game uses. In a Cucumber
       Expression parentheses mean OPTIONAL TEXT, so "at ({int}, {int})" is illegal and a cell is
       written "at \({int}, {int}\)", which is "\\(" in a C# literal.
    2. No pattern is declared twice, and none is AMBIGUOUS: Pickle loads every suite's steps into one
       namespace and matches on the text alone, so two expressions that both match a line make it an
       "Ambiguous step" and fail a healthy scenario.
    3. Every Given/When/Then/And/But line of every feature MATCHES exactly one expression among
       Pickle's own vocabulary (read from the installed assemblies), the shared PickleTools this
       suite stages (read from the pass map) and this suite's own.

  A local pattern no feature uses is reported as weight, not as an error: delete it.

  Static, so it proves the text of a step exists, not that the step does what the scenario hopes.

.EXAMPLE
  powershell.exe -ExecutionPolicy Bypass -File Tests/Pickle/Check-Steps.ps1
#>
param(
    [string]$PickleAssemblies = 'C:\Program Files (x86)\Steam\steamapps\workshop\content\294100\3791648678\Assemblies',
    [string]$Cecil = "$env:USERPROFILE\.nuget\packages\mono.cecil\0.11.5\lib\net40\Mono.Cecil.dll"
)
$ErrorActionPreference = 'Stop'
$suite = $PSScriptRoot                                   # ...\Tests\Pickle
$repo = Split-Path (Split-Path (Split-Path $suite -Parent) -Parent) -Parent   # the collection root

foreach ($dll in 'CucumberExpressions.dll', 'RimWorks.Pickle.Core.dll') {
    $path = Join-Path $PickleAssemblies $dll
    if (-not (Test-Path $path)) { throw "$dll not found under $PickleAssemblies. Pass -PickleAssemblies with the installed Pickle mod's Assemblies folder." }
    [Reflection.Assembly]::LoadFrom($path) | Out-Null
}
if (-not (Test-Path $Cecil)) { throw "Mono.Cecil not found at $Cecil. Pass -Cecil, or restore it: it reads Pickle's step attributes without loading its game types." }
Add-Type -Path $Cecil

$core = [AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GetName().Name -eq 'RimWorks.Pickle.Core' }
$registryType = $core.GetType('RimWorks.Pickle.Core.Steps.PickleParameterTypeRegistry')
if (-not $registryType) { throw 'PickleParameterTypeRegistry no longer exists: Pickle renamed it, update this script.' }
$registry = [Activator]::CreateInstance($registryType)

function New-Expr($pattern) { New-Object CucumberExpressions.CucumberExpression($pattern, $registry) }

# The attribute argument is a C# literal: undo its escaping to get the pattern Pickle sees. The optional
# TimeoutSeconds argument after the pattern is allowed for.
$attr = '\[(?:Given|When|Then)\("((?:[^"\\]|\\.)*)"[^\]]*\]'
function Read-Patterns($dir, $source) {
    foreach ($f in Get-ChildItem -LiteralPath $dir -Filter *.cs -ErrorAction SilentlyContinue) {
        $text = [IO.File]::ReadAllText($f.FullName)
        foreach ($m in [regex]::Matches($text, $attr)) {
            [pscustomobject]@{ Source = $source; File = $f.Name; Pattern = ($m.Groups[1].Value -replace '\\\\', '\' -replace '\\"', '"') }
        }
    }
}

$bad = 0

# --- 1 and 2. this suite's own patterns ----------------------------------------------------------

$mine = @(Read-Patterns (Join-Path $suite 'Source') 'suite')
if ($mine.Count -eq 0) { throw "no step patterns found under $suite\Source: the attribute shape this script looks for has changed." }

foreach ($g in ($mine | Group-Object Pattern | Where-Object { $_.Count -gt 1 })) {
    Write-Host "DUPLICATE  $($g.Name)  (declared $($g.Count) times)" -ForegroundColor Red; $bad++
}

$myExprs = @()
foreach ($d in $mine) {
    try { $myExprs += [pscustomobject]@{ Source = 'suite'; Pattern = $d.Pattern; Regex = (New-Expr $d.Pattern).Regex; Used = $false } }
    catch {
        $e = $_.Exception; while ($e.InnerException) { $e = $e.InnerException }
        Write-Host "INVALID  $($d.File): $($d.Pattern)" -ForegroundColor Red
        foreach ($line in ($e.Message -split "`n")) { if ($line.Trim()) { Write-Host "         $($line.TrimEnd())" -ForegroundColor DarkRed } }
        $bad++
    }
}

# --- everything else that shares the namespace ---------------------------------------------------

$others = @()

# Pickle's own vocabulary. Two assemblies carry steps: Vanilla, and the runner itself (the save steps).
foreach ($name in 'RimWorks.Pickle.Vanilla.dll', 'RimWorks.Pickle.dll') {
    $asm = [Mono.Cecil.AssemblyDefinition]::ReadAssembly((Join-Path $PickleAssemblies $name))
    foreach ($t in $asm.MainModule.GetTypes()) {
        foreach ($m in $t.Methods) {
            foreach ($a in $m.CustomAttributes | Where-Object { $_.AttributeType.Name -in 'GivenAttribute', 'WhenAttribute', 'ThenAttribute' }) {
                $others += [pscustomobject]@{ Source = 'pickle'; Pattern = [string]$a.ConstructorArguments[0].Value }
            }
        }
    }
}
# Handled by the runner without an attribute the extraction sees. Not derived from the assembly: the evidence
# is that Pickle's own Features\save-reload.feature uses each of them verbatim, and that other suites' passes
# ran to their end on them. Add one here only on the same evidence.
foreach ($p in 'the save {string} is loaded', 'I save and reload', 'I save and reload as {string}', 'the save round trips') {
    $others += [pscustomobject]@{ Source = 'pickle-engine'; Pattern = $p }
}

# The shared tools this suite stages: every line of every pass map naming a path under PickleTools/.
$staged = @()
foreach ($map in Get-ChildItem -LiteralPath $suite -Filter 'wsl-deps*.map') {
    foreach ($line in [IO.File]::ReadAllLines($map.FullName)) {
        if ($line -match '^\s*(\S+)\s+path:PickleTools/([^/\s]+)/') { $staged += $Matches[2] }
    }
}
foreach ($tool in $staged | Sort-Object -Unique) {
    $src = Join-Path $repo "PickleTools\$tool\Source"
    if (-not (Test-Path -LiteralPath $src)) { Write-Host "MISSING  the pass map stages PickleTools/$tool and $src does not exist" -ForegroundColor Red; $bad++; continue }
    foreach ($p in Read-Patterns $src ('tool:' + $tool)) { $others += $p }
}

$otherExprs = @()
foreach ($o in $others) {
    try { $otherExprs += [pscustomobject]@{ Source = $o.Source; Pattern = $o.Pattern; Regex = (New-Expr $o.Pattern).Regex } } catch { }
}

# Ambiguity is not only between a feature line and two expressions: a local pattern that a Pickle or a
# tool pattern also matches is an ambiguity waiting for the first line that reads that way.
$all = @($myExprs) + @($otherExprs)

# --- 3. every feature line resolves to exactly one expression ------------------------------------

$lines = 0
$undefined = @(); $ambiguous = @()
foreach ($file in Get-ChildItem -LiteralPath (Join-Path $suite 'Mod\Pickle\Features') -Filter *.feature) {
    foreach ($raw in [IO.File]::ReadAllLines($file.FullName)) {
        $line = $raw.Trim()
        if ($line -notmatch '^(Given|When|Then|And|But)\s+(.+)$') { continue }
        $step = $Matches[2].Trim()
        $lines++
        $hits = @($all | Where-Object { $_.Regex.IsMatch($step) })
        if ($hits.Count -eq 0) { $undefined += "$($file.Name): $step"; continue }
        if ($hits.Count -gt 1) { $ambiguous += [pscustomobject]@{ Where = "$($file.Name): $step"; Hits = ($hits | ForEach-Object { "[$($_.Source)] $($_.Pattern)" }) } }
        foreach ($h in $hits | Where-Object { $_.Source -eq 'suite' }) { $h.Used = $true }
    }
}

$unused = @($myExprs | Where-Object { -not $_.Used })

# --- report --------------------------------------------------------------------------------------

Write-Host ''
Write-Host "$($mine.Count) local patterns, $($otherExprs.Count) others in the namespace (Pickle and $(@($staged | Sort-Object -Unique).Count) shared tool(s)), $lines step lines across the features."

foreach ($u in $undefined | Sort-Object -Unique) { Write-Host "UNDEFINED  $u" -ForegroundColor Red; $bad++ }
foreach ($a in $ambiguous) {
    Write-Host "AMBIGUOUS  $($a.Where)" -ForegroundColor Red
    foreach ($h in $a.Hits) { Write-Host "           $h" -ForegroundColor DarkRed }
    $bad++
}
if ($unused.Count -gt 0) {
    Write-Host ''
    Write-Host "$($unused.Count) local pattern(s) no feature uses - weight, not coverage:" -ForegroundColor Yellow
    foreach ($u in $unused) { Write-Host "  $($u.Pattern)" -ForegroundColor Yellow }
}

Write-Host ''
if ($bad -gt 0) {
    Write-Host "$bad PROBLEM(S). An undefined step fails its scenario; an invalid or duplicated pattern fails the whole run." -ForegroundColor Red
    exit 1
}
Write-Host 'EVERY STEP LINE RESOLVES TO EXACTLY ONE STEP; EVERY LOCAL PATTERN COMPILES' -ForegroundColor Green
exit 0
