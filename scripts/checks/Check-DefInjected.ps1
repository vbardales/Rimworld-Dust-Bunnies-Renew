<#
.SYNOPSIS
  Checks that every DefInjected key of a translation resolves to something the game
  can actually inject into.

.DESCRIPTION
  A DefInjected key that resolves to nothing is silent. RimWorld logs a load error only
  for a few shapes; a key that walks off the def tree simply never replaces anything and
  the English text stays on screen. So the key has to be checked against the same rules
  the game itself applies, which is what this does.

  The reference is Verse.DefInjectionPackage.SetDefFieldAtPath and
  Verse.TranslationHandleUtility, both read out of Assembly-CSharp.dll. A path is walked
  segment by segment against a live object graph; this script walks it against the def's
  XML and the reflected 1.6 classes instead, and applies the same three rules:

    - a numeric segment is a LIST INDEX, always - int.TryParse is tried before anything else
    - a segment naming a field of the current type is a FIELD
    - otherwise, on a list, it is a HANDLE, optionally suffixed -<n>

  A handle is NOT "the label". It is the value of the highest-priority field carrying
  [TranslationHandle] on the element's own class, and there are 27 such fields in 1.6.
  Hence Beer.tools.bottle.label (Tool.untranslatedLabel), but
  Human.hediffGivers.TraumaSavant.letter (HediffGiver.hediff, a def reference) and
  ThingDef comps keyed by the COMP class, not the properties class:
  ...comps.CompRefuelable.label, never comps.CompProperties_Refuelable.label.

  Where an element has no usable handle at all - a LifeStageAge has no [TranslationHandle]
  field, a stage whose label is entirely CJK normalises to nothing - the game falls back to
  the index, and Alpaca.lifeStages.0.label is then the only correct form. Everywhere else a
  numeric segment is a mistake, and is reported as one.

  What this replaces: the previous version only recognised handles under `stages`, and only
  checked field existence for paths of exactly three segments. Rotmeth shipped four broken
  keys past a clean report - Rotmeth.tools.0.label (four segments, not stages) and
  Rotmeth.ingestCommandString (two segments, and the field lives on <ingestible>).

  Core and the installed DLCs are always indexed, so a mod that translates or patches a
  vanilla def needs no -Targets at all. Name a target only for a THIRD-PARTY mod's defs.

  A THIRD-PARTY TARGET IS NEVER RESOLVED FOR YOU, and a bare run says so rather than hiding
  it. Nothing here reads About.xml: a mod whose defs sit behind another mod's - or behind a
  PatchOperationConditional gated on one - reports those keys UNVERIFIED naming what it could
  not see, until that mod is passed. JoyPreservation is the worked example: run bare it gives
  45 keys, 0 errors and 6 UNVERIFIED, because its three pipes are gated on Mlie's
  HeldMusicalInstrumentBase; pass workshop 2274558815 and the same 45 keys come back with
  none. Both runs are correct and they are not the same claim, so a sweep that resolves each
  mod's declared modDependencies AND loadAfter will legitimately report fewer UNVERIFIED than
  a bare run over the same mod.

  CAPTURING THE OUTPUT. Findings are written with Write-Host, which goes to the information
  stream. Dot-sourced or called with & from a wrapper script, `... 2>&1 | Out-String` catches
  the summary and silently drops every finding above it - a sweep then looks clean because it
  is deaf, not because the mods are. Use `*>&1` in-process, or run it as a child process
  (`powershell -File ... | Set-Content`), where Write-Host lands on stdout and redirection
  works as expected.

.EXAMPLE
  pwsh -File Check-DefInjected.ps1 -TransMod ...\Rotmeth\Mod

.EXAMPLE
  A translation aimed at other mods has to be given them as targets, or every key comes
  back as an unknown def:

  pwsh -File Check-DefInjected.ps1 -TransMod ...\RimScentExtended\Mod -Targets `
    '...\workshop\content\294100\3645569466','...\RimScentExtended\Mod'
#>
param(
  [Parameter(Mandatory=$true)][string]$TransMod,
  # Mods whose defs the translation aims at. Defaults to the translation mod itself, which
  # is the usual case: a mod translating its own content.
  [string[]]$Targets = @(),
  [string]$Managed = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\RimWorldWin64_Data\Managed',
  # Core and the DLCs, always indexed alongside $Targets. A translation that touches one
  # vanilla def - NeckAccessory patches Disfigured, DandelionsPatched patches Plant_Dandelion -
  # would otherwise have to name them by hand, and be accused of a dead key when it did not.
  # Nothing is checkable against a game that is not there, so there is no reason to make this
  # opt-in. Set it to an empty string to check against the targets alone.
  [string]$GameData = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\Data',
  # Assemblies that define def types or comp classes the targets use, in load order.
  [string[]]$ExtraAssemblies = @(),
  # Report every def the targets expose that this translation does not cover.
  [switch]$ShowMissing
)

$ErrorActionPreference = 'Stop'
if (-not $Targets -or $Targets.Count -eq 0) { $Targets = @($TransMod) }
if ($GameData -and (Test-Path $GameData)) {
  # Every folder there that actually holds defs: Core plus whichever expansions are installed.
  $Targets += Get-ChildItem $GameData -Directory -ErrorAction SilentlyContinue |
              Where-Object { Test-Path (Join-Path $_.FullName 'Defs') } | ForEach-Object { $_.FullName }
}
# A folder indexed twice would give every def a second candidate and double the work.
$Targets = @($Targets | Select-Object -Unique)

# --- reflection over the 1.6 classes ---------------------------------------
# A framework assembly references Assembly-CSharp and the Unity modules by name and .NET
# only looks for them next to this script. Point it at the folders they came from, and
# remember what has been tried: an unresolvable name asked for twice recurses to a stack
# overflow rather than to an error.
$probeDirs = @($Managed) + @($ExtraAssemblies | ForEach-Object { Split-Path -Parent $_ }) | Select-Object -Unique
$script:probed = @{}
# Kept in a variable so it can be unregistered at the end. It is registered on the *process*
# AppDomain, which outlives this script: PowerShell goes on resolving assemblies while it tears
# the session down, and by then this script's scope - $probed, $probeDirs - is gone. Leaving it
# behind turned every one of those late calls into a null-reference error, so a run reporting
# zero errors still ended in a wall of red and a non-zero exit code.
$script:asmResolver = [System.ResolveEventHandler]{
    param($sender, $e)
    # Belt and braces for the path the unregister below cannot cover: if the script throws
    # first, the handler survives, and a late call must be inert rather than noisy.
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
# loadable outside the game. The exception still carries every type it did resolve, which
# is all of them but a handful. PowerShell wraps it, so both shapes have to be caught.
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

# Indexed by short name AND by full name: a Class="..." attribute may be written either way.
$byName = @{}
foreach ($t in $allTypes) {
    if (-not $byName.ContainsKey($t.Name))                      { $byName[$t.Name] = $t }
    if ($t.FullName -and -not $byName.ContainsKey($t.FullName)) { $byName[$t.FullName] = $t }
}
$defType = $asm.GetType('Verse.Def')
$stringListType = [System.Collections.Generic.List[string]]

$BF = [System.Reflection.BindingFlags]'Public,NonPublic,Instance,Static,DeclaredOnly'

# GetFields on a derived type does not return private fields of its base types, and RimWorld
# has plenty. Walk the chain by hand. A renamed field keeps its old XML name when it carries
# [LoadAlias("oldName")]; DefInjectionPackage.GetFieldNamed looks aliases up too, so index
# them as well. Lookups are case-insensitive, as the game's BindingFlags.IgnoreCase is.
$fieldCache = @{}
function Get-FieldsRecursive([Type]$t) {
    if ($null -eq $t) { return @{} }
    if ($fieldCache.ContainsKey($t)) { return $fieldCache[$t] }
    $d = New-Object 'System.Collections.Hashtable' ([System.StringComparer]::OrdinalIgnoreCase)
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

function Has-Attr([System.Reflection.FieldInfo]$f, [string]$name) {
    foreach ($a in $f.CustomAttributes) { if ($a.AttributeType.Name -eq $name) { return $true } }
    return $false
}

# The [TranslationHandle] fields of a type, best first. Priority ties keep declaration order,
# which is what GetBestHandleWithIndexForListElement does (it only replaces on strictly
# greater priority).
$handleFieldCache = @{}
function Get-HandleFields([Type]$t) {
    if ($null -eq $t) { return @() }
    if ($handleFieldCache.ContainsKey($t)) { return $handleFieldCache[$t] }
    $res = @()
    $cur = $t
    while ($cur -and $cur.FullName -ne 'System.Object') {
        foreach ($f in $cur.GetFields($BF)) {
            foreach ($a in $f.CustomAttributes) {
                if ($a.AttributeType.Name -ne 'TranslationHandleAttribute') { continue }
                $prio = 0
                foreach ($ca in $a.ConstructorArguments) { $prio = [int]$ca.Value }
                foreach ($na in $a.NamedArguments) { if ($na.MemberName -eq 'Priority') { $prio = [int]$na.TypedValue.Value } }
                $res += [pscustomobject]@{ Name = $f.Name; Field = $f; Priority = $prio }
            }
        }
        $cur = $cur.BaseType
    }
    $res = @($res | Sort-Object -Property @{Expression='Priority';Descending=$true})
    $handleFieldCache[$t] = $res
    return $res
}

# Verse.TranslationHandleUtility.NormalizedHandle, in order. The '-' is in the whitelist,
# but it is stripped one step earlier: a hyphen in the source label never survives, it only
# ever appears in a path as the separator of the -N suffix. The vanilla label
# 'sky-high expectations' is addressed as skyhigh_expectations.
function Normalize([string]$h) {
  if ([string]::IsNullOrEmpty($h)) { return $h }
  $h = $h.Trim().Replace(' ','_').Replace("`n",'_').Replace("`r",'').Replace("`t",'_').Replace('.','').Replace('-','')
  $h = [regex]::Replace($h, '\{.*?\}', '')                       # string format symbols
  $h = -join ($h.ToCharArray() | Where-Object { 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890-_'.IndexOf($_) -ge 0 })
  $h = [regex]::Replace($h, '_+', '_')                           # runs of underscores folded
  $h = $h.Trim('_')                                              # leading and trailing underscores
  if ($h -and $h -match '^[0-9]+$') { $h = "_$h" }               # an all-digit handle
  return $h
}

# --- def index, with inheritance resolved ----------------------------------
# A def written as <ThingDef ParentName="X"> carries none of X's nodes in its own XML, so a
# path through an inherited <ingestible> or <comps> would read as absent. Merge the chain
# the way XmlInheritance does: the child's element of a given name wins, and a list is
# replaced wholesale rather than merged element by element.
# The game does this in three steps and the order is load-bearing: every mod's XML is
# combined into ONE document rooted at <Defs>, patches are applied to that, and only then is
# ParentName inheritance resolved. A checker that skips the patch step calls correct keys
# wrong - NeckAccessory adds a stage to the vanilla Disfigured thought by PatchOperationAdd,
# and its translation of that stage is right even though no XML file spells it out.
$unified = New-Object System.Xml.XmlDocument
$unifiedRoot = $unified.CreateElement('Defs')
[void]$unified.AppendChild($unifiedRoot)
$patchOps = @()

foreach ($t in $Targets) {
  Get-ChildItem $t -Filter *.xml -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch '[\\/]Languages[\\/]' } | ForEach-Object {
      try { [xml]$x = Get-Content -LiteralPath $_.FullName -Raw -Encoding UTF8 } catch { return }
      $root = $x.DocumentElement
      if ($null -eq $root) { return }
      if ($root.LocalName -eq 'Defs') {
        foreach ($d in $root.ChildNodes) {
          if ($d.NodeType -ne 'Element') { continue }
          [void]$unifiedRoot.AppendChild($unified.ImportNode($d, $true))
        }
      }
      elseif ($root.LocalName -eq 'Patch') {
        foreach ($op in $root.ChildNodes) { if ($op.NodeType -eq 'Element') { $patchOps += $unified.ImportNode($op, $true) } }
      }
    }
}

# The operations that move nodes about, which is all that matters for reading a def's shape.
# The rest - AttributeSet, SetName, Test and the like - leave the tree walkable either way.
function Apply-Patch([System.Xml.XmlNode]$op) {
  $cls = $op.GetAttribute('Class')
  if (-not $cls) { $cls = $op.LocalName }
  $cls = $cls.Split('.')[-1]
  switch ($cls) {
    'PatchOperationSequence' {
      $ops = $op.SelectSingleNode('operations')
      if ($ops) { foreach ($c in $ops.ChildNodes) { if ($c.NodeType -eq 'Element') { Apply-Patch $c } } }
      return
    }
    { $_ -in 'PatchOperationConditional','PatchOperationFindMod' } {
      # match and nomatch are ONE PatchOperation each, not a list: the <match Class="..."> node
      # IS the operation, and its children are that operation's own xpath and value. Recursing
      # into those children instead - which this did until 2026-09-05 - silently applies
      # nothing, and every def the branch would have created reads as missing.
      # For a conditional, take the branch its xpath actually selects, as the game does with
      # SelectSingleNode. For FindMod there is no active mod list to consult here, so assume
      # the named mod is present: a translation ships alongside what it translates.
      $branch = 'match'; $gate = $null
      if ($cls -eq 'PatchOperationConditional') {
        $xp = $op.SelectSingleNode('xpath')
        if ($xp) { try { if ($null -eq $unified.SelectSingleNode($xp.InnerText)) { $branch = 'nomatch'; $gate = $xp.InnerText } } catch { return } }
      }
      # A gate that does not match is usually correct - the mod is deliberately not patching
      # something absent. But when the branch skipped would have CREATED defs, and the gate
      # failed only because its target was never passed as a target of this run, those defs
      # are missing from the analysis and not from the game. Remember what they were called so
      # the report can name the gate instead of accusing the translation.
      if ($branch -eq 'nomatch' -and $gate) {
        $m = $op.SelectSingleNode('match')
        if ($m) { foreach ($dn in $m.SelectNodes('.//defName')) { $script:gatedDefs[$dn.InnerText.Trim()] = $gate } }
      }
      $b = $op.SelectSingleNode($branch)
      if ($b) { Apply-Patch $b }
      return
    }
    # Built-ins that move no nodes about, so they cannot make a def appear or vanish.
    { $_ -in 'PatchOperationTest','PatchOperationSetName','PatchOperationAttributeSet',
              'PatchOperationAttributeAdd','PatchOperationAttributeRemove' } { return }
  }
  # Anything else is a patch operation class this script does not implement - almost always a
  # framework's own, carrying arbitrary C#. Some of them CREATE defs, so a def missing from a
  # mod that runs one may simply be one this script cannot see. Remember the class so the
  # report can say so instead of calling those keys dead.
  if ($cls -notin 'PatchOperationAdd','PatchOperationInsert','PatchOperationReplace','PatchOperationRemove') {
    $script:unimplementedOps[$cls] = $true
    return
  }
  $xpNode = $op.SelectSingleNode('xpath')
  if ($null -eq $xpNode) { return }
  try { $hits = @($unified.SelectNodes($xpNode.InnerText)) } catch { return }
  if ($hits.Count -eq 0) { return }
  $valueNode = $op.SelectSingleNode('value')
  $order = $op.SelectSingleNode('order')
  $prepend = ($order -and $order.InnerText -eq 'Prepend')
  foreach ($h in $hits) {
    switch ($cls) {
      'PatchOperationAdd' {
        if ($null -eq $valueNode) { continue }
        foreach ($v in $valueNode.ChildNodes) {
          if ($v.NodeType -ne 'Element') { continue }
          $n = $unified.ImportNode($v, $true)
          if ($prepend -and $h.FirstChild) { [void]$h.InsertBefore($n, $h.FirstChild) } else { [void]$h.AppendChild($n) }
        }
      }
      'PatchOperationInsert' {
        if ($null -eq $valueNode -or $null -eq $h.ParentNode) { continue }
        foreach ($v in $valueNode.ChildNodes) {
          if ($v.NodeType -ne 'Element') { continue }
          $n = $unified.ImportNode($v, $true)
          if ($prepend -or $null -eq $order) { [void]$h.ParentNode.InsertBefore($n, $h) } else { [void]$h.ParentNode.InsertAfter($n, $h) }
        }
      }
      'PatchOperationReplace' {
        if ($null -eq $valueNode -or $null -eq $h.ParentNode) { continue }
        $anchor = $h
        foreach ($v in $valueNode.ChildNodes) {
          if ($v.NodeType -ne 'Element') { continue }
          $n = $unified.ImportNode($v, $true)
          [void]$anchor.ParentNode.InsertBefore($n, $anchor)
        }
        [void]$h.ParentNode.RemoveChild($h)
      }
      'PatchOperationRemove' {
        if ($h.ParentNode) { [void]$h.ParentNode.RemoveChild($h) }
      }
    }
  }
}
$script:unimplementedOps = @{}
$script:gatedDefs = New-Object 'System.Collections.Hashtable' ([System.StringComparer]::Ordinal)
foreach ($op in $patchOps) { try { Apply-Patch $op } catch { } }
if (@($script:gatedDefs.Keys).Count) {
  Write-Host "Conditional patches skipped, so $(@($script:gatedDefs.Keys).Count) def(s) were not created: pass the mod their gate names as a target to check them" -ForegroundColor DarkYellow
}
if (@($script:unimplementedOps.Keys).Count) {
  Write-Host "Patch operations not implemented here: $((@($script:unimplementedOps.Keys) | Sort-Object) -join ', ') - a def one of them creates is invisible to this script" -ForegroundColor DarkYellow
}
Write-Host "Patch operations applied: $($patchOps.Count)" -ForegroundColor DarkGray

$abstracts = @{}   # Name= -> node
$concrete  = @()   # nodes carrying a defName
foreach ($d in $unifiedRoot.ChildNodes) {
  if ($d.NodeType -ne 'Element') { continue }
  $nm = $d.GetAttribute('Name')
  if ($nm) { $abstracts[$nm] = $d }
  if ($d.SelectSingleNode('defName')) { $concrete += $d }
}

# Verse.XmlInheritance.RecursiveNodeCopyOverwriteElements, applied onto a copy of the parent.
# The rule that matters here is the one a plain "child wins" merge gets wrong: a <li> is
# APPENDED, so an inherited list is the parent's elements followed by the child's, and the
# handles of the child's own elements are not at the indices the child's XML suggests.
# Vanilla proves it - Burn declares one comp, its parent BurnBase two, and the shipped
# translation addresses Burn.comps.HediffComp_TendDuration, which only BurnBase declares.
function Merge-Inherited([System.Xml.XmlElement]$child, [System.Xml.XmlElement]$current) {
  if ($child.GetAttribute('Inherit') -eq 'false') { return $child.CloneNode($true) }

  $childElems = @(); $childText = $null
  foreach ($c in $child.ChildNodes) {
    if     ($c.NodeType -eq 'Element') { $childElems += $c }
    elseif ($c.NodeType -eq 'Text' -or $c.NodeType -eq 'CDATA') { $childText = $c }
  }
  # A text body replaces whatever the parent had.
  if ($null -ne $childText) { return $child.CloneNode($true) }
  # No elements and no text: the parent's content stands.
  if ($childElems.Count -eq 0) { return $current.CloneNode($true) }

  $merged = $current.CloneNode($true)
  $doc = $merged.OwnerDocument
  $merged.Attributes.RemoveAll()
  foreach ($a in $child.Attributes) { [void]$merged.Attributes.Append($doc.ImportNode($a, $true)) }
  foreach ($ce in $childElems) {
    if ($ce.LocalName -eq 'li') { [void]$merged.AppendChild($doc.ImportNode($ce, $true)); continue }
    $own = $null
    foreach ($mc in $merged.ChildNodes) {
      if ($mc.NodeType -eq 'Element' -and $mc.LocalName -eq $ce.LocalName) { $own = $mc; break }
    }
    if ($null -eq $own) { [void]$merged.AppendChild($doc.ImportNode($ce, $true)) }
    # The recursive call builds its result in whichever document it cloned from, and a node
    # may only be inserted into the document that owns it.
    else { [void]$merged.ReplaceChild($doc.ImportNode((Merge-Inherited $ce $own), $true), $own) }
  }
  return $merged
}

function Resolve-Def([System.Xml.XmlElement]$node, [int]$depth = 0) {
  if ($depth -gt 12) { return $node }                       # a ParentName cycle
  $pn = $node.GetAttribute('ParentName')
  if (-not $pn -or -not $abstracts.ContainsKey($pn)) { return $node }
  $parent = Resolve-Def $abstracts[$pn] ($depth + 1)
  return Merge-Inherited $node $parent
}

# A same defName can exist under several types (DrinkDandelionTea is both a HediffDef and a
# JoyGiverDef): keep every candidate, or the last one indexed hides the others and the
# folder check lies.
#
# ORDINAL, not a plain @{}. A PowerShell hashtable ignores case; the game does not.
# Verse.DefDatabase<T>.defsByName is a Dictionary<string, T> built with no comparer, so it
# compares ordinally, and a key naming Panda_Leather finds nothing when the def is
# PanDa_Leather. Left case-insensitive, this script answers "clean" to exactly the kind of
# key it exists to catch. Fields are the opposite case and are handled the opposite way:
# DefInjectionPackage.GetFieldNamed passes BindingFlags.IgnoreCase, so the field cache is
# OrdinalIgnoreCase on purpose.
$defs = New-Object 'System.Collections.Hashtable' ([System.StringComparer]::Ordinal)
# A node carrying TKey="X" is addressable as <defName>.X, whatever its real path
# (Verse.TKeySystem). Vanilla uses 112 of them, all under TipSetDef and QuestScriptDef.
# Its own table is a Dictionary<string,string>, ordinal like the rest.
$tkeys = New-Object 'System.Collections.Hashtable' ([System.StringComparer]::Ordinal)
foreach ($d in $concrete) {
  $key = [string]$d.SelectSingleNode('defName').InnerText
  $resolved = Resolve-Def $d
  if (-not $defs.ContainsKey($key)) { $defs[$key] = @() }
  $defs[$key] += [pscustomobject]@{
    Type       = $d.LocalName
    Node       = $resolved
    MayRequire = $d.GetAttribute('MayRequire')
  }
  foreach ($tk in $resolved.SelectNodes('.//*[@TKey]')) { $tkeys["$key.$($tk.GetAttribute('TKey'))"] = $true }
}
# @($defs.Keys).Count, not $defs.Count: a defName shadows the hashtable's own properties, and
# RoyalTitleDef ships one called Count.
Write-Host "Defs indexed: $(@($defs.Keys).Count)" -ForegroundColor DarkGray

# Defs the game builds in C# rather than reading from XML - a corpse and a meat for every
# race, a frame and a blueprint for every building, a Make_ recipe for every recipeMaker,
# a key binding per architect tab. They are translated like any other def but no XML file
# holds them, so they can be recognised but never checked. The base name has to be an
# indexed def, or a plain typo would hide here.
$impliedPrefixes = @('Corpse','Meat','Leather','Milk','Wool','Frame','Blueprint','Make','Architect',
                     'MainTab','Trainable','Administer','Remove','Install','Uninstall',
                     'EggFertilized','EggUnfertilized')
# Terrain cut from a stone ThingDef, and the bulk twin of a recipe's product.
$impliedSuffixes = @('Rough','RoughHewn','Smooth','Bulk')
function Is-ImpliedDef([string]$name) {
  foreach ($s in $impliedSuffixes) {
    if ($name.EndsWith("_$s") -and $defs.ContainsKey($name.Substring(0, $name.Length - $s.Length - 1))) { return $true }
  }
  foreach ($p in $impliedPrefixes) {
    if (-not $name.StartsWith("${p}_")) { continue }
    $rest = $name.Substring($p.Length + 1)
    if ($defs.ContainsKey($rest)) { return $true }
    # These stack: Blueprint_Install_Bed, Frame_Wall, Make_PemmicanBulk.
    if (Is-ImpliedDef $rest) { return $true }
  }
  return $false
}

# --- handles of one list node ----------------------------------------------
# Instantiating an element class is the only way to read a [TranslationHandle] field that
# the XML leaves at its C# default - CompProperties_Refuelable sets compClass to
# CompRefuelable in its constructor, and the XML never says so. Constructors of these
# property classes are plain assignments, but some are not, hence the guard: a type that
# will not instantiate yields no default and its element is reported as unverifiable
# rather than as wrong.
$ctorCache = @{}
function Get-DefaultInstance([Type]$t) {
  if ($ctorCache.ContainsKey($t)) { return $ctorCache[$t] }
  $inst = $null
  try { if (-not $t.IsAbstract -and $t.GetConstructor([Type]::EmptyTypes)) { $inst = [Activator]::CreateInstance($t) } } catch { $inst = $null }
  $ctorCache[$t] = $inst
  return $inst
}

# The XML name a [TranslationHandle] field is fed from. The eight string handles are all
# 'untranslatedX', copied from 'x' at load; the others - def references and Type fields -
# are read from the element under their own name.
function Handle-XmlName([string]$fieldName) {
  if ($fieldName -like 'untranslated*') {
    $rest = $fieldName.Substring('untranslated'.Length)
    if (-not $rest) { return $fieldName }
    return $rest.Substring(0,1).ToLowerInvariant() + $rest.Substring(1)
  }
  return $fieldName
}

function Get-ElementType($li, [Type]$declared) {
  $cls = $li.GetAttribute('Class')
  if ($cls) {
    if ($byName.ContainsKey($cls)) { return $byName[$cls] }
    $short = $cls.Split('.')[-1]
    if ($byName.ContainsKey($short)) { return $byName[$short] }
  }
  return $declared
}

# Every handle an element answers to, best first. A Type-valued field contributes the type's
# Name (HandlesMatch also accepts FullName, but the exporter writes Name).
function Get-ElementHandles($li, [Type]$declared) {
  $t = Get-ElementType $li $declared
  $out = @()
  foreach ($hf in (Get-HandleFields $t)) {
    $xmlName = Handle-XmlName $hf.Name
    $raw = $null
    foreach ($c in $li.ChildNodes) {
      if ($c.NodeType -eq 'Element' -and $c.LocalName -ieq $xmlName) { $raw = $c.InnerText; break }
    }
    if ([string]::IsNullOrWhiteSpace($raw) -and $hf.Field.FieldType -eq [Type]) {
      $inst = Get-DefaultInstance $t
      if ($inst) { try { $v = $hf.Field.GetValue($inst); if ($v) { $raw = ([Type]$v).Name } } catch { } }
    }
    if ([string]::IsNullOrWhiteSpace($raw)) { continue }
    $n = Normalize $raw
    if ([string]::IsNullOrWhiteSpace($n)) { continue }
    $out += [pscustomobject]@{ Field = $hf.Name; Handle = $n }
  }
  return $out
}

# The path segment the game's own exporter would write for each element of a list: the best
# handle, suffixed -<rank among the elements sharing that same field value> when more than
# one shares it, and the bare index when the element answers to no handle at all.
function Get-ListHandleMap($listNode, [Type]$declared) {
  $elems = @()
  foreach ($c in $listNode.ChildNodes) {
    if ($c.NodeType -ne 'Element' -or $c.LocalName -ne 'li') { continue }
    $elems += $c
  }
  $best = @()
  $all  = @()
  foreach ($e in $elems) {
    $h = @(Get-ElementHandles $e $declared)
    $all  += ,$h
    if ($h.Count -gt 0) { $best += $h[0] } else { $best += $null }
  }
  $segments = @()
  for ($i = 0; $i -lt $elems.Count; $i++) {
    if ($null -eq $best[$i]) { $segments += "$i"; continue }
    $mine = $best[$i]
    # Count and rank against the SAME field on the other elements, not against their own
    # best handle: that is what GetBestHandleWithIndexForListElement compares.
    $same = 0; $rank = 0
    for ($j = 0; $j -lt $elems.Count; $j++) {
      $hit = $false
      foreach ($h in $all[$j]) { if ($h.Field -eq $mine.Field -and $h.Handle -eq $mine.Handle) { $hit = $true; break } }
      if (-not $hit) { continue }
      if ($j -eq $i) { $rank = $same }
      $same++
    }
    if ($same -le 1) { $segments += $mine.Handle } else { $segments += "$($mine.Handle)-$rank" }
  }
  # Valid is wider than suggested: GetElementIndexByHandle matches any [TranslationHandle]
  # field of any element, not just the best one, so a lower-priority handle resolves too.
  # Ordinal again: HandlesMatch compares two normalised handles with C# ==, which is ordinal.
  $valid = New-Object 'System.Collections.Hashtable' ([System.StringComparer]::Ordinal)
  for ($i = 0; $i -lt $elems.Count; $i++) {
    foreach ($h in $all[$i]) { $valid[$h.Handle] = $true; $valid["$($h.Handle)-0"] = $true }
  }
  foreach ($s in $segments) { $valid[$s] = $true }
  return [pscustomobject]@{ Elements = $elems; Suggested = $segments; Valid = $valid; HasHandle = $best }
}

# --- key checking ----------------------------------------------------------
$errors = 0; $checked = 0; $warned = @{}
function Fail([string]$msg, [string]$rel) {
  Write-Host "$msg  ($rel)" -ForegroundColor Red
  $script:errors++
}

Get-ChildItem $TransMod -Filter *.xml -Recurse -File |
  # A mod folder holds git worktrees of the whole repo under .claude; they are copies of
  # other mods, and checking them reports every finding once per worktree.
  Where-Object { $_.FullName -match 'DefInjected' -and $_.FullName -notmatch '[\\/]\.claude[\\/]' } | ForEach-Object {
    $folderType = Split-Path (Split-Path $_.FullName -Parent) -Leaf
    $rel = $_.FullName.Substring($TransMod.Length + 1)
    try { [xml]$x = Get-Content -LiteralPath $_.FullName -Raw -Encoding UTF8 }
    catch { Fail "MALFORMED XML  $($_.Exception.Message)" $rel; return }
    foreach ($n in $x.LanguageData.ChildNodes) {
      if ($n.NodeType -ne 'Element') { continue }
      $script:checked++
      $key   = $n.LocalName
      $parts = $key.Split('.')
      $defName = $parts[0]
      # A TKey alias stands in for a whole path, and the key may carry further segments past
      # it (OpportunitySite_BanditCamp.LetterLabelQuestExpired.slateRef). TKeySystem resolves
      # the pair against its own table, so there is nothing here to walk.
      if ($parts.Length -ge 2 -and $tkeys.ContainsKey("$($parts[0]).$($parts[1])")) { continue }
      if (-not $defs.ContainsKey($defName)) {
        if (Is-ImpliedDef $defName) {
          Write-Host "UNVERIFIED     $key - $defName is generated in C#, it has no XML to check against  ($rel)" -ForegroundColor DarkGray
        }
        elseif ($script:gatedDefs.ContainsKey($defName)) {
          Write-Host "UNVERIFIED     $key - $defName is created by a conditional patch whose gate '$($script:gatedDefs[$defName])' is not in the analysed scope  ($rel)" -ForegroundColor DarkYellow
        }
        elseif (@($script:unimplementedOps.Keys).Count) {
          # A def-creating patch operation ran that this script cannot execute, so absence
          # here is not proof of absence in game. Said plainly rather than counted as a fault:
          # Adaptive Storage Neolithic builds one storage building per stone this way, and the
          # string "Granite" appears in none of its files.
          Write-Host "UNVERIFIED     $key - $defName is in no XML, but $((@($script:unimplementedOps.Keys) | Sort-Object) -join '/') runs here and may create it  ($rel)" -ForegroundColor DarkYellow
        }
        else {
          Fail "MISSING DEF    $defName" $rel
        }
        continue
      }
      $cands = @($defs[$defName])
      # Case-insensitive, unlike the defName and handle lookups above, and Core is the proof:
      # Jobs_Misc.xml declares TriggerObject under a lowercase <jobDef>, and every language
      # pack shipped with the game translates it from DefInjected/JobDef/. The element name
      # resolves to the type regardless of case, so comparing ordinally here reports the
      # game's own translation as filed in the wrong folder.
      $d = $cands | Where-Object { $_.Type -eq $folderType } | Select-Object -First 1
      if ($null -eq $d) {
        Fail "WRONG FOLDER   $defName is a $(($cands.Type | Sort-Object -Unique) -join ' / '), filed under $folderType" $rel; continue
      }
      # A def carrying MayRequire does not exist when the mod it names is absent, so its
      # translation has to live in a folder gated on that same mod or it aims at nothing.
      # The gate itself is not checkable here; flag it.
      if ($d.MayRequire -and -not $script:warned[$defName]) {
        $script:warned[$defName] = $true
        Write-Host "MayRequire     $defName depends on '$($d.MayRequire)' - its translation must sit in a folder gated on the same mod  ($rel)" -ForegroundColor Yellow
      }
      if (-not $byName.ContainsKey($folderType)) {
        Write-Host "UNKNOWN TYPE   folder $folderType names no class - $key not checked past its defName  ($rel)" -ForegroundColor Yellow
        continue
      }

      # Walk the remaining segments the way SetDefFieldAtPath does.
      $curType = $byName[$folderType]
      $curNode = $d.Node          # XML for the current object, $null once it is not in the XML
      $curList = $null            # set when the previous segment named a List<T>
      $ok = $true
      for ($i = 1; $i -lt $parts.Length -and $ok; $i++) {
        $seg  = $parts[$i]
        $last = ($i -eq $parts.Length - 1)

        if ($null -ne $curList) {
          # This segment addresses into the list named by the previous one.
          $map = $curList.Map
          $idx = -1
          if ($seg -match '^[0-9]+$') {
            $idx = [int]$seg
            if ($null -eq $map) {
              Write-Host "UNVERIFIED     $key - list <$($curList.Name)> is not in the target XML  ($rel)" -ForegroundColor Yellow
              $ok = $false; continue
            }
            if ($idx -ge $map.Elements.Count) {
              Fail "INDEX OUT OF RANGE $key - <$($curList.Name)> holds $($map.Elements.Count) element(s)" $rel; $ok = $false; continue
            }
            if ($null -ne $map.HasHandle[$idx]) {
              Fail "INDEX FOR A HANDLE $key - element $idx of <$($curList.Name)> is addressed as '$($map.Suggested[$idx])'" $rel; $ok = $false; continue
            }
          }
          else {
            if ($null -eq $map) {
              Write-Host "UNVERIFIED     $key - list <$($curList.Name)> is not in the target XML  ($rel)" -ForegroundColor Yellow
              $ok = $false; continue
            }
            if (-not $map.Valid.ContainsKey($seg)) {
              $real = ($map.Suggested -join ', ')
              Fail "UNKNOWN HANDLE $key -> real handles of <$($curList.Name)>: $real" $rel; $ok = $false; continue
            }
            # A bare handle shared by several elements resolves to the first of them - the
            # game clamps the absent index to 0 - so the others keep their English text with
            # nothing said. Vanilla always spells the suffix out.
            if ($seg -notmatch '-\d+$' -and @($map.Suggested | Where-Object { $_ -like "$seg-*" }).Count -gt 1) {
              $dups = ($map.Suggested | Where-Object { $_ -like "$seg-*" }) -join ', '
              Write-Host "AMBIGUOUS      $key - <$($curList.Name)> has several '$seg'; this reaches only the first. Write one of: $dups  ($rel)" -ForegroundColor Yellow
            }
            $idx = [array]::IndexOf($map.Suggested, $seg)
            if ($idx -lt 0) {
              # A valid but non-preferred handle: find the element that answers to it.
              for ($j = 0; $j -lt $map.Elements.Count -and $idx -lt 0; $j++) {
                foreach ($h in (Get-ElementHandles $map.Elements[$j] $curList.ElemType)) {
                  if ($h.Handle -eq $seg -or "$($h.Handle)-0" -eq $seg) { $idx = $j; break }
                }
              }
            }
          }
          if ($idx -lt 0) { $ok = $false; continue }
          if ($last) {
            # A path may end on the element itself when the list holds strings - that is the
            # only way to reach one, since a string carries no [TranslationHandle] field.
            # Vanilla French does it 35 times, as Quest_X.rulePack.rulesStrings.<n>.
            if ($curList.ElemType -ne [string]) {
              Fail "PATH ENDS ON A LIST ELEMENT $key - <$($curList.Name)> holds $($curList.ElemType.Name), a translatable field has to follow" $rel; $ok = $false
            }
            continue
          }
          $curNode = $map.Elements[$idx]
          $curType = Get-ElementType $curNode $curList.ElemType
          $curList = $null
          continue
        }

        # Otherwise the segment names a field of the current type.
        $fields = Get-FieldsRecursive $curType
        if (-not $fields.ContainsKey($seg)) {
          Fail "NO FIELD       $key -> '$seg' is not a field of $($curType.Name)" $rel; $ok = $false; continue
        }
        $f  = $fields[$seg]
        $ft = $f.FieldType
        if (Has-Attr $f 'NoTranslateAttribute') {
          Fail "UNTRANSLATABLE $key -> $($f.Name) is [NoTranslate]" $rel; $ok = $false; continue
        }
        if (Has-Attr $f 'UnsavedAttribute') {
          Fail "UNTRANSLATABLE $key -> $($f.Name) is [Unsaved]" $rel; $ok = $false; continue
        }
        # The XML node for this field, if the target actually writes it.
        $childNode = $null
        if ($null -ne $curNode) {
          foreach ($c in $curNode.ChildNodes) {
            if ($c.NodeType -eq 'Element' -and $c.LocalName -ieq $seg) { $childNode = $c; break }
          }
        }

        if ($last) {
          # DefInjectionPackage accepts a string, or a List<string> carrying
          # [TranslationCanChangeCount] when the key is written as a list of <li>.
          $isListInjection = $false
          foreach ($c in $n.ChildNodes) { if ($c.NodeType -eq 'Element' -and $c.LocalName -eq 'li') { $isListInjection = $true; break } }
          if ($isListInjection) {
            if ($ft -ne $stringListType) {
              Fail "WRONG TYPE     $key -> $($f.Name) is $($ft.Name), a list injection needs List<string>" $rel; $ok = $false
            }
            elseif (-not (Has-Attr $f 'TranslationCanChangeCountAttribute')) {
              Fail "NOT A LIST INJECTION $key -> $($f.Name) has no [TranslationCanChangeCount]" $rel; $ok = $false
            }
          }
          elseif ($ft -ne [string]) {
            Fail "WRONG TYPE     $key -> $($f.Name) is $($ft.Name), not a string" $rel; $ok = $false
          }
          continue
        }

        if ($ft.IsGenericType -and $ft.GetGenericTypeDefinition() -eq [System.Collections.Generic.List`1]) {
          $elem = $ft.GetGenericArguments()[0]
          $map  = $null
          if ($null -ne $childNode) { $map = Get-ListHandleMap $childNode $elem }
          $curList = [pscustomobject]@{ Name = $f.Name; ElemType = $elem; Map = $map }
          continue
        }
        if ($ft.IsPrimitive -or $ft -eq [string] -or $ft.IsEnum -or $defType.IsAssignableFrom($ft)) {
          Fail "PATH TOO LONG  $key -> $($f.Name) is $($ft.Name) and cannot be descended into" $rel; $ok = $false; continue
        }
        # A sub-object. Class="..." on the node narrows its type.
        $sub = $ft
        if ($null -ne $childNode) {
          $cls = $childNode.GetAttribute('Class')
          if ($cls) {
            $short = $cls.Split('.')[-1]
            if ($byName.ContainsKey($cls))   { $sub = $byName[$cls] }
            elseif ($byName.ContainsKey($short)) { $sub = $byName[$short] }
          }
        }
        $curType = $sub
        $curNode = $childNode
      }
    }
  }

# Every assembly this needed is loaded by now: the field walks that trigger the last loads are
# all behind us. Taking the handler back off the AppDomain is what actually stops the late
# calls - the guard inside it is only the fallback for an early throw.
[System.AppDomain]::CurrentDomain.remove_AssemblyResolve($script:asmResolver)

Write-Host "`nKeys checked: $checked - errors: $errors" -ForegroundColor $(if ($errors) {'Red'} else {'Green'})
if ($errors) { exit 1 }
