param(
    [string]$GameRoot = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld',
    [switch]$SkipBuild
)
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$mod = Join-Path $root 'Mod'
$managed = Join-Path $GameRoot 'RimWorldWin64_Data/Managed'
$data = Join-Path $GameRoot 'Data'
function Run-Check([string]$Name, [string[]]$Arguments) {
    & pwsh -NoProfile -File (Join-Path $PSScriptRoot "checks/$Name.ps1") @Arguments
    if ($LASTEXITCODE -ne 0) { throw "$Name failed ($LASTEXITCODE)" }
}
if (-not $SkipBuild) {
    & dotnet build (Join-Path $root 'Source/DustBunnies.csproj') -c Release
    if ($LASTEXITCODE -ne 0) { throw 'Build failed' }
}
if (-not (Test-Path "$managed/Assembly-CSharp.dll")) { throw 'RimWorld installation required; pass -GameRoot.' }
# Parse metadata, definitions and translations, not just Defs/.
$xmlFiles = @(Get-ChildItem $mod -Recurse -Filter *.xml)
foreach ($file in $xmlFiles) { $null = [xml](Get-Content $file.FullName -Raw) }
[xml]$about = Get-Content "$mod/About/About.xml" -Raw
if ($about.ModMetaData.packageId -cne 'nelim.dustbunniesrenew') { throw 'Unexpected packageId' }
if (-not $about.ModMetaData.name.EndsWith('(unofficial)')) { throw 'Unofficial suffix missing' }
if (-not $about.ModMetaData.description.Contains('https://github.com/vbardales/Rimworld-Dust-Bunnies-Renew')) { throw 'GitHub description link missing' }

Run-Check 'Check-XmlFields' @('-ModPath', $mod, '-Managed', $managed, '-ExtraAssemblies', "$mod/Assemblies/DustBunnies.dll")
Run-Check 'Check-DefRefs' @('-ModPath', $mod, '-Managed', $managed, '-GameData', $data, '-Brief')
Run-Check 'Check-DefInjected' @('-TransMod', $mod, '-Managed', $managed, '-GameData', $data)

# Resolve the XML worker against the shipped DLL, not merely its source text.
Get-ChildItem "$managed/UnityEngine*.dll" | ForEach-Object { $null = [Reflection.Assembly]::LoadFrom($_.FullName) }
$game = [Reflection.Assembly]::LoadFrom("$managed/Assembly-CSharp.dll")
$assembly = [Reflection.Assembly]::LoadFrom("$mod/Assemblies/DustBunnies.dll")
[xml]$recipes = Get-Content "$mod/Defs/RecipeDefs/Recipes_DustBunny.xml" -Raw
$workerName = $recipes.SelectSingleNode('//workerClass').InnerText
$worker = $assembly.GetType($workerName, $true)
if (-not $game.GetType('Verse.RecipeWorker', $true).IsAssignableFrom($worker)) { throw 'Invalid recipe worker base class' }
$method = $worker.GetMethod('Notify_IterationCompleted')
if ($method.DeclaringType -ne $worker -or $method.GetBaseDefinition().DeclaringType -eq $worker) { throw 'Recipe completion does not override the game hook' }
$defOf = $assembly.GetType('DustBunnies.DustBunniesDefOf', $true).GetField('DustBunny')
if ($defOf.FieldType.FullName -ne 'Verse.PawnKindDef') { throw 'DefOf field has wrong type' }
try { $types = $game.GetTypes() } catch [Reflection.ReflectionTypeLoadException] { $types = $_.Exception.Types | Where-Object { $_ } }
if (-not $types) { throw 'Cannot read game types' }
$typeList = Join-Path $root '.build/test-types.txt'
New-Item -ItemType Directory -Force (Split-Path $typeList) | Out-Null
$types.FullName | Set-Content $typeList
Run-Check 'Check-XmlClasses' @('-ModPath', $mod, '-TypeLists', $typeList, '-SourceDirs', "$root/Source")
Write-Host "PASS: $($xmlFiles.Count) XML files, fields, references, translations, XML classes and compiled recipe hook. In-game scenarios remain separate."
