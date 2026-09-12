<#
.SYNOPSIS
  Checks that every XML element in a mod's defs still maps to a field on the 1.6 class.

.DESCRIPTION
  The sibling scripts check names: Check-DefRefs.ps1 verifies that referenced defs exist,
  Check-XmlClasses.ps1 that referenced C# types exist. Neither looks at the element names
  themselves - and that is where a mod written for an older RimWorld dies quietly, because
  RimWorld does not stop when it meets an element that matches no field. It logs one line
  and carries on with the field unset, so a ported animal loads, walks, and is simply wrong.

  This walks each def XML against the real class by reflection: the def type from the element
  name, then each child against that type's fields (public and non-public, own and inherited -
  RimWorld's loader reads both), descending into sub-objects and into List<T> elements, and
  following a Class="..." attribute where one narrows the type.

  Found this way, on a 1.0 mod ported to 1.6:
    <stuffProps><soundImpactStuff>  ->  soundImpactBullet
    <stuffProps><smeltable>         ->  gone from stuff; a ThingDef flag now
    <race><wildness>                ->  the Wildness stat  (see Fix-Wildness.ps1)

  Sixty-five types load themselves through LoadDataFromXmlCustom and are invisible to a field
  walk - SkillGain, StatModifier, ThingDefCountClass among them. Those are not descended into,
  but their shape is checked: an <li> carrying element children is the dictionary form, which
  no RimWorld version accepts and which aborts the WHOLE def, not just the field. That is what
  cost twelve of nineteen TraitDefs on 2026-09-08:

    <skillGains><li><key>Melee</key><value>4</value></li></skillGains>   throws
    <skillGains><Melee>4</Melee></skillGains>                            correct

  A Class= on the def's own root node is followed too, not just on nested nodes and <li>:
  <ThingDef Class="WA.FK_ThingDef_FiringKiln"> puts that def's own fields on the subclass, and
  reading only the element name reported all seven of them as missing. That resolves only when
  the mod's assembly is passed in -ExtraAssemblies - with WA.dll, Japanese Homestead goes from
  21 problems to none - so pass it whenever a mod ships one.

  It does not check values otherwise. Def references are left to Check-DefRefs.ps1 and class
  names to Check-XmlClasses.ps1; a clean run here means nothing was silently dropped.

  Calibrated against all six vanilla data folders: the shape check fires zero times there, and
  the type test it replaced a hardcoded field-name list with also cleared three long-standing
  false positives on PrefixCapturedVar in Royalty. The problems Core used to report on top of
  that, all of them SlateRef<T> and Nullable<T> walked as objects of their own, are gone since
  Resolve-Wrapper unwraps both the way DirectXmlToObject does.

.EXAMPLE
  pwsh -File Check-XmlFields.ps1 -ModPath C:\Users\nelim\Documents\rimworld\ACertainSeriesCreaturesAndHairRenew\Mod

.EXAMPLE
  A mod whose defs live on a framework's classes has to be checked against that framework's
  assemblies too, or every one of its defs comes back as an unknown type:

  pwsh -File Check-XmlFields.ps1 -ModPath ...\UnrulyDrifter\Mod -ExtraAssemblies `
    '...\3014915404\1.6\Assemblies\SmashTools.dll','...\3014915404\1.6\Assemblies\Vehicles.dll'
#>
param(
    [Parameter(Mandatory=$true)][string]$ModPath,
    [string]$Managed = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\RimWorldWin64_Data\Managed',
    # Assemblies whose types this needs indexed. Two distinct cases, both real:
    #   - the frameworks the mod builds on   (Vehicles.dll, SmashTools.dll, ...)
    #   - the mod's OWN assembly, whenever it declares its own Def subclasses or its defs carry
    #     Class= pointing into it. Without it those come back as "unknown def type" or as fields
    #     missing from the base class: APerfectMindInAPerfectBody and FoodCourt each declare a
    #     SourceModDef, and Japanese Homestead's kiln is a <ThingDef Class="WA.FK_ThingDef_...">.
    #     Passing the mod's dll takes all three from a nonzero count to none.
    # Pass it whenever the mod ships one; there is no cost when nothing needs it.
    [string[]]$ExtraAssemblies = @()
)

$ErrorActionPreference = 'Stop'

# A framework assembly references Assembly-CSharp and the Unity modules by name, and .NET only
# looks for them next to this script. Point it at the folders the DLLs actually came from, and
# remember what has been tried: an unresolvable name asked for twice recurses to a stack
# overflow rather than to an error. Check-DefInjected.ps1 learned that the hard way; this is the
# same handler and carries the same guard.
$probeDirs = @($Managed) + @($ExtraAssemblies | ForEach-Object { Split-Path -Parent $_ }) | Select-Object -Unique
$script:probed = @{}
# Kept in a variable so it can be unregistered at the end. It is registered on the *process*
# AppDomain, which outlives this script: PowerShell goes on resolving assemblies while it tears
# the session down, and by then this script's scope - $probed, $probeDirs - is gone. Holding
# state here without the null guard below turns every one of those late calls into a
# null-reference error, and a run reporting zero problems still ends in a wall of red and a
# non-zero exit code. That is exactly what this script's twin did until it was fixed.
$script:asmResolver = [System.ResolveEventHandler]{
    param($sender, $e)
    if ($null -eq $script:probed) { return $null }
    $short = $e.Name.Split(',')[0]
    if ($script:probed.ContainsKey($short)) { return $null }
    $script:probed[$short] = $true
    foreach ($d in $probeDirs) {
        $p = Join-Path $d "$short.dll"
        if (Test-Path $p) { return [System.Reflection.Assembly]::LoadFrom($p) }
    }
    return $null
}
[System.AppDomain]::CurrentDomain.add_AssemblyResolve($script:asmResolver)

# GetTypes() always throws here: Assembly-CSharp references Unity assemblies that are not
# loadable outside the game. The exception still carries every type it did resolve, which is
# all of them but a handful. PowerShell wraps it, so both shapes have to be caught.
function Get-AssemblyTypes([string]$path) {
    $a = [System.Reflection.Assembly]::LoadFrom($path)
    try     { return $a.GetTypes() }
    catch [System.Reflection.ReflectionTypeLoadException] { return $_.Exception.Types | Where-Object { $_ } }
    catch   { return $_.Exception.InnerException.Types | Where-Object { $_ } }
}

$asm = [System.Reflection.Assembly]::LoadFrom((Join-Path $Managed 'Assembly-CSharp.dll'))
$allTypes = @()
$allTypes += Get-AssemblyTypes (Join-Path $Managed 'Assembly-CSharp.dll')
foreach ($extra in $ExtraAssemblies) { $allTypes += Get-AssemblyTypes $extra }

# Indexed by short name AND by full name: a def class outside Verse/RimWorld is written out in
# full in the XML - <Vehicles.VehicleDef> - and would otherwise read as an unknown def type.
$byName = @{}
foreach ($t in $allTypes) {
    if (-not $byName.ContainsKey($t.Name))     { $byName[$t.Name] = $t }
    if ($t.FullName -and -not $byName.ContainsKey($t.FullName)) { $byName[$t.FullName] = $t }
}

$defType = $asm.GetType('Verse.Def')

$BF = [System.Reflection.BindingFlags]::Public    -bor `
      [System.Reflection.BindingFlags]::NonPublic -bor `
      [System.Reflection.BindingFlags]::Instance  -bor `
      [System.Reflection.BindingFlags]::DeclaredOnly

# GetFields on a derived type does not return private fields of its base types, and RimWorld
# has plenty - StyleItemDef.category among them. Walk the chain by hand.
#
# Element names are read with .LocalName, never .Name: PowerShell's XML adapter shadows .Name
# with a "Name" attribute where one exists, so every abstract <ThingDef Name="XBase"> came back
# as an unknown def type called XBase.
#
# A renamed field keeps its old XML name when it carries [LoadAlias("oldName")]: the loader
# looks the aliases up too, so such an element is honoured, not dropped. Index them under the
# alias as well, or the script cries wolf over every deliberate rename a framework has kept
# working - Vehicle Framework's vehicleType -> type and winterSpeedMultiplier -> winterCost
# among them.
$fieldCache = @{}
function Get-FieldsRecursive([Type]$t) {
    if ($fieldCache.ContainsKey($t)) { return $fieldCache[$t] }
    $d = @{}
    $cur = $t
    while ($cur -and $cur.FullName -ne 'System.Object') {
        foreach ($f in $cur.GetFields($BF)) {
            if (-not $d.ContainsKey($f.Name)) { $d[$f.Name] = $f }
            foreach ($a in $f.CustomAttributes) {
                if ($a.AttributeType.Name -ne 'LoadAliasAttribute') { continue }
                foreach ($arg in $a.ConstructorArguments) {
                    $alias = [string]$arg.Value
                    if ($alias -and -not $d.ContainsKey($alias)) { $d[$alias] = $f }
                }
            }
        }
        $cur = $cur.BaseType
    }
    $fieldCache[$t] = $d
    return $d
}

# A type that implements LoadDataFromXmlCustom is invisible to field reflection: RimWorld hands
# it the raw node and it reads whatever it likes. Sixty-five types do this in 1.6 - StatModifier,
# SkillGain, ThingDefCountClass, SkillRequirement, XenotypeChance among them - and they come in
# two shapes that a field walk must not try to tell apart:
#
#   <skillGains><Melee>4</Melee></skillGains>       the element NAME is the key   (SkillGain)
#   <hyperlinks><li>Gun_Revolver</li></hyperlinks>  the element TEXT is the value (DefHyperlink)
#
# What both have in common is that every child is a leaf. That is the only thing worth asserting
# here, and it is enough to catch the failure this was written for: skillGains written in the
# dictionary form <li><key>Melee</key><value>4</value></li>, which is not valid in any RimWorld
# version. SkillGain.LoadDataFromXmlCustom looks the element name up as a SkillDef and parses its
# text as the amount, so that form logs "No SkillDef named li" and then throws
# ArgumentNullException on the null text - and the throw aborts the WHOLE def, not just the
# skillGains block. Twelve TraitDefs out of nineteen vanished that way on 2026-09-08.
#
# This replaces a hardcoded list of field names. Naming them could not work: statFactors is a
# name/value block on a ThingDef and a plain List<StatDef> on a StatDef, and statOffsetsQuality
# is genuinely <li>-shaped in vanilla, so it was being skipped for nothing.
$customLoaderCache = @{}
function Test-CustomLoader([Type]$t) {
    if (-not $t) { return $false }
    if ($customLoaderCache.ContainsKey($t)) { return $customLoaderCache[$t] }
    $r = $null -ne $t.GetMethod('LoadDataFromXmlCustom', $BF -bxor [System.Reflection.BindingFlags]::DeclaredOnly)
    $customLoaderCache[$t] = $r
    return $r
}

# Two wrappers stand between a field and the type whose children the XML actually writes, and
# RimWorld's loader steps through both before it reads a node. DirectXmlToObject unwraps
# Nullable<T> - Core writes <dataNorth><flip>true</flip></dataNorth> into DrawData.dataNorth,
# which is a Nullable<DrawData.RotationalData> - and it resolves SlateRef<T> to T unless the
# text is a $variable. Walking the wrapper itself reports every child as a missing field: that
# was eleven lines on Ancient Chinese Beast's gene render nodes, and the eighteen this file
# used to say vanilla still produced.
function Resolve-Wrapper([Type]$t) {
    while ($t -and $t.IsGenericType) {
        $g = $t.GetGenericTypeDefinition()
        if ($g -eq [System.Nullable`1] -or $g.Name -eq 'SlateRef`1') { $t = $t.GetGenericArguments()[0] }
        else { break }
    }
    return $t
}

# $container is the field node - <skillGains>. The one thing that is wrong under EVERY custom
# loader is an <li> that carries element children. A bare <li> is fine - that is the DefHyperlink
# shape - and a named element with children is fine too, which is a third shape this had to learn
# from vanilla: <things><AncientBarrel><position>..</position></AncientBarrel></things> on
# PrefabThingData, and <connections><Surface><zoomMode>..</zoomMode></Surface></connections> on
# LayerConnection. Only <li> plus children is the dictionary form, and vanilla never writes it.
function Check-CustomLoaderShape($container, [string]$path, [Type]$elem) {
    foreach ($child in $container.ChildNodes) {
        if ($child.NodeType -ne 'Element') { continue }
        if ($child.LocalName -ne 'li') { continue }
        foreach ($grand in $child.ChildNodes) {
            if ($grand.NodeType -ne 'Element') { continue }
            [void]$problems.Add("$path/li/$($grand.LocalName)  -- $($elem.Name) is loaded by LoadDataFromXmlCustom; an <li> with children is the dictionary form, which RimWorld throws on")
            break
        }
    }
}

$problems = New-Object System.Collections.ArrayList

function Walk($node, [Type]$t, [string]$path) {
    if (-not $t) { return }
    $fields = Get-FieldsRecursive $t
    foreach ($child in $node.ChildNodes) {
        if ($child.NodeType -ne 'Element') { continue }
        $n = $child.LocalName
        if ($n -eq 'li') { continue }

        $f = $null
        if ($fields.ContainsKey($n)) { $f = $fields[$n] }
        else { foreach ($k in $fields.Keys) { if ($k -ieq $n) { $f = $fields[$k]; break } } }
        if (-not $f) { [void]$problems.Add("$path/$n  -- no field '$n' on $($t.Name)"); continue }

        $ft = Resolve-Wrapper $f.FieldType
        if ($ft.IsPrimitive -or $ft -eq [string] -or $ft.IsEnum) { continue }
        if ($defType.IsAssignableFrom($ft)) { continue }   # a def reference: the value is a defName

        if ($ft.IsGenericType -and $ft.GetGenericTypeDefinition() -eq [System.Collections.Generic.List`1]) {
            $elem = Resolve-Wrapper $ft.GetGenericArguments()[0]
            if ($elem.IsPrimitive -or $elem -eq [string] -or $elem.IsEnum -or $defType.IsAssignableFrom($elem)) { continue }
            if (Test-CustomLoader $elem) { Check-CustomLoaderShape $child "$path/$n" $elem; continue }
            foreach ($li in $child.ChildNodes) {
                if ($li.NodeType -ne 'Element') { continue }
                $lt = $elem
                $cls = $li.GetAttribute('Class')
                if ($cls) { $short = $cls.Split('.')[-1]; if ($byName.ContainsKey($short)) { $lt = $byName[$short] } }
                Walk $li $lt "$path/$n/li"
            }
            continue
        }

        if (Test-CustomLoader $ft) { Check-CustomLoaderShape $child "$path/$n" $ft; continue }

        $sub = $ft
        $cls = $child.GetAttribute('Class')
        if ($cls) { $short = $cls.Split('.')[-1]; if ($byName.ContainsKey($short)) { $sub = $byName[$short] } }
        Walk $child $sub "$path/$n"
    }
}

$files = Get-ChildItem -Path $ModPath -Recurse -Filter *.xml |
         Where-Object { $_.FullName -notmatch '\\Languages\\' }
foreach ($file in $files) {
    try { [xml]$doc = Get-Content $file.FullName -Raw -Encoding UTF8 }
    catch { [void]$problems.Add("$($file.Name): malformed XML - $($_.Exception.Message)"); continue }
    if (-not $doc.DocumentElement) { continue }
    if ($doc.DocumentElement.LocalName -ne 'Defs') { continue }   # patches are another matter

    foreach ($defNode in $doc.DocumentElement.ChildNodes) {
        if ($defNode.NodeType -ne 'Element') { continue }
        $tn = $defNode.LocalName
        # A def node may carry Class= too, not just the nested nodes and <li> that Walk already
        # follows: <ThingDef Class="WA.FK_ThingDef_FiringKiln"> is a ThingDef subclass, and its
        # own fields are on that subclass. Reading only the element name reported every one of
        # them as missing - seven FK_* fields on Japanese Homestead alone. Resolves only when the
        # mod assembly is passed in -ExtraAssemblies; without it, fall back to the element name
        # and behave as before rather than cry wolf about an unknown type.
        $dt = $null
        $dcls = $defNode.GetAttribute('Class')
        if ($dcls) {
            if ($byName.ContainsKey($dcls)) { $dt = $byName[$dcls] }
            else { $dshort = $dcls.Split('.')[-1]; if ($byName.ContainsKey($dshort)) { $dt = $byName[$dshort] } }
        }
        if (-not $dt -and $byName.ContainsKey($tn)) { $dt = $byName[$tn] }
        if (-not $dt) {
            # DirectXmlLoader.DefFromNode returns on the Abstract attribute BEFORE it looks the
            # element name up as a type, so an abstract node's name never has to resolve: it is a
            # template merged into its children by ParentName, and the children carry the real
            # name. Odyssey ships <StructureStructureLayoutDef Name="OrbitalPlatformBase"
            # Abstract="True"> and the game has never said a word about it. Reporting it would be
            # crying wolf; the fields under it are checked where they land, on the child.
            if ($defNode.GetAttribute('Abstract') -match '^(?i)true$') { continue }
            [void]$problems.Add("$($file.Name): unknown def type <$tn>"); continue
        }
        $dn = $defNode.SelectSingleNode('defName')
        $label = if ($dn) { $dn.InnerText } else { '(abstract)' }
        Walk $defNode $dt "$($file.Name):$tn/$label"
    }
}

# Every assembly this needed is loaded by now: the field walks that trigger the last loads are
# all behind us. Taking the handler back off the AppDomain is what actually stops the late
# calls - the guard inside it is only the fallback for an early throw.
[System.AppDomain]::CurrentDomain.remove_AssemblyResolve($script:asmResolver)

Write-Output "$($files.Count) files checked."
if ($problems.Count -eq 0) { Write-Output 'No unknown fields: every element maps to a 1.6 field.' }
else { $problems | Sort-Object -Unique | ForEach-Object { Write-Output $_ }; exit 1 }
