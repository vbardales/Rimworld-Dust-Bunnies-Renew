<#
.SYNOPSIS
  Checks that every C# type referenced from a mod's XML actually exists.

.DESCRIPTION
  A type that does not resolve costs you the def, or costs it to you later. This
  paragraph used to say the opposite - that ClassTypeOf logs one line and falls back
  to the field's declared type, leaving the def loaded with that field unset - and
  that is no longer how defs are built. Corrected 2026-09-11 against the 1.6
  assembly; the route differs by shape.

    Class="..."           DirectXmlToObjectNew.ResolveTypeForNode builds an
                          ArgumentException and throws. In 1.6 a def whose type is
                          registered is built by that emitter, so the def is LOST,
                          not degraded. The forgiving path this file used to name,
                          DirectXmlToObject.ClassTypeOf, still exists and no longer
                          loads defs.

    <driverClass>X</...>  a plain Type field. ParseHelper.ParseType logs "Could not
                          find a type named X" and returns null, so the field is set
                          to null and the def LOADS. Nothing refuses it later either;
                          it fails when something tries to use the field. This is the
                          shape that hid the MechanoidFactory JobDef: that exact log
                          line was all Player.log had, and the pod's job simply did
                          nothing when ordered. Verified against 1.6 on 2026-09-11 -
                          this row was missing when the paragraph above was corrected,
                          and it is the shape $ClassTags exists to read.

    <li> in a List<Type>  ParseHelper.ParseType logs and returns null. The list is
                          not left unset: it keeps a null entry, which throws at
                          whatever reads it, because nothing on either side checks.
                          InspectTabManager.GetSharedInstance is reached from
                          ThingDef.ResolveReferences, which DefDatabase
                          .ResolveAllReferences catches per def - the def survives
                          load, abandoned part-resolved. BuildableDef.PlaceWorkers
                          calls Activator.CreateInstance lazily instead, so the
                          eighteenth <placeWorkers> entry below does not fail at
                          startup at all: it fails when the build menu asks for it.

  So the old wording understated it twice over, and it understated it most for the
  very case that prompted the 2026-09-10 change to this script.

  A type reaches the XML in four shapes, and this reads all four:

    Class="..."                     an attribute, on a comp, a patch operation, a li
    <driverClass>Namespace.X</...>  a tag holding one type   (see $ClassTags)
    <placeWorkers><li>X</li></...>  a tag holding a LIST of types (see $ListClassTags)
    <Namespace.SomeDef>             the element name itself, for a custom def type

  Each name found is then checked against the type lists supplied (RimWorld,
  dependency mods) and against the mod's own C# sources. A type that resolves by
  short name alone is accepted: RimWorld searches every loaded assembly.

  The last two shapes were blind spots until 2026-09-10 - see the notes on
  $ListClassTags and on the element-name check below.

.EXAMPLE
  pwsh -File Check-XmlClasses.ps1 -ModPath ...\StevesAnimals\1.6 -TypeLists a.txt,b.txt
#>
param(
    [Parameter(Mandatory=$true)][string]$ModPath,
    [Parameter(Mandatory=$true)][string[]]$TypeLists,
    # The mod's C# sources. Since Mod/ holds only what ships to the Workshop, Source/ lives
    # beside it: without this path the checker cannot see the mod's own classes and reports
    # every one of them as missing.
    [string[]]$SourceDirs = @(),
    [switch]$Brief   # show problems only
)

# Fields holding ONE type, written as the tag's own text.
#
# The first group is the real 1.6 set, taken from reflection on 2026-09-11: every field of
# type Type declared in Assembly-CSharp.dll or Assembly-CSharp-firstpass.dll. Regenerate by
# enumerating those fields. Two kinds are deliberately left out of it:
#
#   - 'type', 'targetType' and 'lordJob' are a Type on one class and something else entirely
#     on others - 'type' alone has fourteen other meanings, from GasType to LetterDef. This
#     script matches on element name with no knowledge of the owning class, so it cannot tell
#     them apart, and listing them would flag ordinary text as a missing type.
#   - eight names owned only by compiler-generated closures (creatingType, inspectTabType,
#     localGenStep, localQuestPartType, localSt, localType, lordJobType, neededFilter).
#     Those exist only in hoisted locals and can never be written in XML.
#
# The list was hand-grown until 2026-09-11 and held 25 names, of which 13 matched no real 1.6
# field at all. Those 13 are kept in the second group: they are older spellings, still worth
# reading on a mod written against 1.0 to 1.5, where a type named by a since-removed field is
# exactly the kind of thing worth reporting.
#
# The cost of a name that matches nothing is zero: it simply never fires.
$ClassTags = @(
    'abilityClass','allowWithComp','awardWorkerClass','baseType','blueprintClass',
    'comparerClass','compClass','conditionClass','defType','designatorType','disallowWithComp',
    'doerClass','drawStyleType','driverClass','enumType','eventClass','fleckSystemClass',
    'foundationClass','geneClass','giverClass','gizmoClass','graphicClass','hediffClass',
    'ingredientValueGetterClass','inheritanceWorkerOverrideClass','inspirationClass',
    'instructionClass','jobClass','languageWorkerClass','layerType','letterClass',
    'mentalStateGiverClass','menuClass','needClass','nodeClass','objType','openTabType',
    'overrideFieldType','pageClass','preceptClass','resourceGizmoType','roomContentsWorkerType',
    'royalTitleInheritanceWorkerClass','scenPartClass','stateClass','subEffecterClass',
    'tabWindowClass','taleClass','thingClass','thoughtClass','tileType','tmpDefType',
    'triggerClass','verbClass','workerClass','workerCounterClass','workerType','worldDrawLayer',
    'worldObjectClass','zoneTypeToPlace',
    # No field by these names exists in 1.6. Kept for older sources - see the note above.
    'designatorClass','effecterClass','gameComponentClass','listerClass','mapComponentClass',
    'pawnColumnWorkerClass','projectileClass','questPartClass','raceClass',
    'ritualBehaviorClass','stageClass','thinkClass','worldComponentClass'
)

# Fields holding a LIST of types. These are written as bare <li> text with no Class="..."
# to latch onto, so reading the tag's own text finds nothing and the entries go unchecked.
#
# The nine names come from reflection over 1.6: every field of type List<Type> declared in
# Assembly-CSharp.dll, minus the compiler backing field. Regenerate by enumerating fields
# whose FieldType is List<Type>. Type[] does not occur; RimWorld uses List<Type> throughout.
#
# Added 2026-09-10, after a half-finished namespace rename survived this check on
# MechanoidFactory: seventeen <placeWorkers> entries had been renamed and the eighteenth
# had not. The checker reported every type resolved while the game logged the miss.
$ListClassTags = @(
    'placeWorkers',                  # BuildableDef, TerrainDef, ThingDef
    'inspectorTabs',                 # ThingDef, WorldObjectDef
    'specialDesignatorClasses',      # DesignationCategoryDef
    'overlayClasses',                # WeatherDef
    'customMapComponents',           # MapGeneratorDef
    'subworkerClasses',              # PawnRenderNodeProperties and its subclasses
    'whitelistedFloatMenuProviders', # MutantDef
    'worldDrawLayers',               # PlanetLayerDef
    'worldTabs'                      # PlanetLayerDef
)

$known = [System.Collections.Generic.HashSet[string]]::new()
$shortNames = [System.Collections.Generic.HashSet[string]]::new()
foreach ($lst in $TypeLists) {
    foreach ($t in Get-Content $lst) {
        $t = $t.Trim(); if (-not $t) { continue }
        [void]$known.Add($t)
        [void]$shortNames.Add(($t -split '\.')[-1])
    }
}

# Types the mod defines itself: in the mod folder, and in its C# sources when those live
# elsewhere (the Mod/ + Source/ split).
$aScanner = @($ModPath) + $SourceDirs
foreach ($racine in $aScanner) {
    if (-not (Test-Path $racine)) { continue }
    foreach ($cs in Get-ChildItem $racine -Filter *.cs -Recurse -File) {
        $txt = Get-Content -LiteralPath $cs.FullName -Raw
        $ns = ([regex]::Match($txt, '(?m)^\s*namespace\s+([\w\.]+)')).Groups[1].Value
        foreach ($m in [regex]::Matches($txt, '(?m)^\s*(?:public|internal)\s+(?:static\s+|abstract\s+|sealed\s+)*(?:class|struct)\s+(\w+)')) {
            $n = $m.Groups[1].Value
            [void]$shortNames.Add($n)
            if ($ns) { [void]$known.Add("$ns.$n") }
        }
    }
}

$found = @{}
foreach ($f in Get-ChildItem $ModPath -Filter *.xml -Recurse -File) {
    $rel = $f.FullName.Substring($ModPath.Length).TrimStart('\')
    try { [xml]$x = Get-Content -LiteralPath $f.FullName -Raw -Encoding UTF8 } catch { continue }
    foreach ($el in $x.SelectNodes('//*')) {
        $vals = @()
        # A class behind MayRequire of another mod (not a DLC) is that mod's: it does not exist here, and the game skips the
        # element before it looks the class up. Check-Claims asserts what this mod writes for such an element.
        $c = $el.GetAttribute('Class'); $may = $el.GetAttribute('MayRequire')
        if ($c -and -not ($may -and $may -notmatch '^Ludeon.')) { $vals += $c }
        if ($ClassTags -contains $el.LocalName -and $el.ChildNodes.Count -eq 1 -and $el.FirstChild.NodeType -eq 'Text') {
            $vals += $el.InnerText.Trim()
        }
        # A list of types: every text-only <li> under the tag is one type name. Reached from
        # anywhere, so entries written inside a patch operation's value are read too.
        if ($ListClassTags -contains $el.LocalName) {
            foreach ($li in $el.SelectNodes('li')) {
                if ($li.ChildNodes.Count -eq 1 -and $li.FirstChild.NodeType -eq 'Text') {
                    $vals += $li.InnerText.Trim()
                }
            }
        }
        # A custom def type also appears as the ELEMENT NAME itself:
        # <VEF.Weapons.ExpandableProjectileDef> ... </...>. Without this check, a namespace
        # renamed by a dependency update slips through entirely.
        #
        # Two parents carry such an element: <Defs> in a def file, and <value> for a def that
        # a PatchOperationAdd or PatchOperationReplace injects. The <value> case was added
        # 2026-09-10; before that, a def declared inside a patch was never checked at all.
        # Keyed and DefInjected files also use dotted element names, but their parent is
        # <LanguageData>, so translation handles are correctly ignored here.
        if ($el.LocalName -match '\.' -and $el.ParentNode -and
            ($el.ParentNode.LocalName -eq 'Defs' -or $el.ParentNode.LocalName -eq 'value')) {
            $vals += $el.LocalName
        }
        foreach ($v in $vals) { if ($v) { $found["$v|$rel"] = $true } }
    }
}

$missing = @{}
foreach ($k in $found.Keys) {
    $p = $k -split '\|'
    $type = $p[0]
    if ($known.Contains($type)) { continue }
    if ($type -notmatch '\.' -and $shortNames.Contains($type)) { continue }   # short name resolved
    $short = ($type -split '\.')[-1]
    $hint = if ($shortNames.Contains($short)) {
        ($known | Where-Object { $_ -like "*.$short" } | Select-Object -First 3) -join ' | '
    } else { '(type inconnu partout)' }
    if (-not $missing.ContainsKey($type)) { $missing[$type] = [pscustomobject]@{ Hint = $hint; Files = @() } }
    $missing[$type].Files += $p[1]
}

Write-Host "=== $ModPath ===" -ForegroundColor Cyan
Write-Host ("types references depuis le XML : {0}" -f ($found.Keys | ForEach-Object { ($_ -split '\|')[0] } | Sort-Object -Unique).Count)
if ($missing.Count) {
    Write-Host "`n-- TYPES INTROUVABLES --" -ForegroundColor Red
    foreach ($t in ($missing.Keys | Sort-Object)) {
        Write-Host ("  {0}" -f $t) -ForegroundColor Yellow
        Write-Host ("      remplacant probable : {0}" -f $missing[$t].Hint)
        Write-Host ("      fichiers : {0}" -f (($missing[$t].Files | Sort-Object -Unique) -join ', '))
    }
} else {
    Write-Host "-- tous les types references sont resolus --" -ForegroundColor Green
}

if ($missing.Count) { exit 1 }
