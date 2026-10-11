param(
    [string]$GameRoot = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld',
    [switch]$SkipBuild
)
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$mod = Join-Path $root 'Mod'
$managed = Join-Path $GameRoot 'RimWorldWin64_Data/Managed'
$data = Join-Path $GameRoot 'Data'
# Shared checks live in the protocols repository (the folder above this mod); Check-Claims is this mod's own.
$shared = Join-Path (Split-Path $root -Parent) 'scripts'
function Run-Check([string]$Name, [string[]]$Arguments, [switch]$Local) {
    $dir = if ($Local) { Join-Path $PSScriptRoot 'checks' } else { $shared }
    & pwsh -NoProfile -File (Join-Path $dir "$Name.ps1") @Arguments
    if ($LASTEXITCODE -ne 0) { throw "$Name failed ($LASTEXITCODE)" }
}
if (-not $SkipBuild) {
    & dotnet build (Join-Path $root 'Source/DustBunnies.csproj') -c Release
    if ($LASTEXITCODE -ne 0) { throw 'Build failed' }
}
if (-not (Test-Path "$managed/Assembly-CSharp.dll")) { throw 'RimWorld installation required; pass -GameRoot.' }
# Generic checks (XML well formed, About.xml, ATTRIBUTION and LICENSE copies, Preview and ModIcon, PublishedFileId) and translations.
Run-Check 'Check-ModBasics' @('-ModRoot', $root, '-Unofficial', '-OriginalWorkshopId', '2659958183')
Run-Check 'Check-Translations' @('-ModRoot', $root)
[xml]$about = Get-Content "$mod/About/About.xml" -Raw
if ($about.ModMetaData.packageId -cne 'nelim.dustbunnies') { throw 'Unexpected packageId' }
if (-not $about.ModMetaData.description.Contains('https://github.com/vbardales/Rimworld-Dust-Bunnies-Renew')) { throw 'GitHub description link missing' }
$xmlFiles = @(Get-ChildItem $mod -Recurse -Filter *.xml)

Run-Check 'Check-XmlFields' -Local -Arguments @('-ModPath', $mod, '-Managed', $managed, '-ExtraAssemblies', "$mod/Assemblies/DustBunnies.dll")
Run-Check 'Check-DefRefs' @('-ModPath', $mod, '-Managed', $managed, '-GameData', $data, '-Brief')
Run-Check 'Check-DefInjected' @('-TransMod', $mod, '-Managed', $managed, '-GameData', $data)
Run-Check 'Check-Claims' @('-ModPath', $mod, '-GameData', $data) -Local

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
$typeList = Join-Path $root 'build/test-types.txt'
New-Item -ItemType Directory -Force (Split-Path $typeList) | Out-Null
$types.FullName | Set-Content $typeList
Run-Check 'Check-XmlClasses' -Local -Arguments @('-ModPath', $mod, '-TypeLists', $typeList, '-SourceDirs', "$root/Source")
Write-Host "PASS: $($xmlFiles.Count) XML files, fields, references, translations, the claims the description makes, XML classes and compiled recipe hook. In-game scenarios remain separate."
