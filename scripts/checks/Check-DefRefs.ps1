<#
.SYNOPSIS
  Verifie qu'un mod RimWorld ne reference que des defs / parents existants en 1.6.
.DESCRIPTION
  Collecte les defName et les Name= (parents abstraits) de Core + DLC puis du mod,
  et signale toute reference (body, leatherDef, sons, ParentName, ...) non resolue.
  Signale aussi les XML mal formes et liste les Class= a verifier a la main.

  Which elements count as a reference is read from Assembly-CSharp by reflection: every field
  whose type is a Def, or a list of Defs, on a class the XML loader can reach. That is about
  1200 element names, against the 26 this script used to know. The list it knew was a list of
  the mistakes already made, and it had a hole the size of the one it was written for:
  RabbieGear shipped two CompProperties_Spawner pointing at a RefinedPlanetarium that exists
  in no def, the game logged the failure on every load, and this script called the mod clean
  because nobody had written `thingToSpawn` down.

  Two shapes carry a reference and only the first used to be read:
      <meatDef>Meat_Cow</meatDef>                        one text child
      <researchPrerequisites><li>Foo</li></...>          a list of <li>
  researchPrerequisites, recipeUsers and thingDefs had been in the tag list from the start and
  had never once been checked.

  Calibrated against the game's own data, which must resolve by definition: Core and the six
  DLCs, 11 586 defs, come back with nothing at all. Everything the widened list first reported
  there was a false positive of a known kind - quest-script variables, colours parsed as
  defNames, translation keys, and the defs RimWorld builds in code at startup - and each is
  handled where it arises rather than by narrowing the list back down.

  Type checking is deliberately NOT widened the same way: see the note at the reflection call.
.EXAMPLE
  pwsh -File Check-DefRefs.ps1 -ModPath C:\Users\nelim\Documents\rimworld\VilousWildlife
.EXAMPLE
  Calibration run - anything reported here is a bug in this script, not in RimWorld:

  pwsh -File Check-DefRefs.ps1 -Brief `
    -ModPath 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\Data'
#>
param(
    [Parameter(Mandatory=$true)][string]$ModPath,
    [string]$GameData = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\Data',
    # Dossiers de defs supplementaires : les dependances du mod, dont les defs sont legitimes
    # mais invisibles au controle. Sans elles, les arbres de pensee de VEF ressortent en faux
    # positifs alors qu'ils existent bel et bien.
    [string[]]$AlsoScan = @(),
    [string]$Managed = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\RimWorldWin64_Data\Managed',
    [switch]$Brief   # n afficher que les problemes
)

# The tags below are the hand-written core: every one has caught something real, and they stay
# even when reflection would drop them. `race` is the reason this list survives - the assembly
# has both PawnKindDef.race (a ThingDef) and ThingDef.race (a RaceProperties block), so a rule
# that only trusts unambiguous field names would throw away the check that caught Nem_Mantis.
$CoreRefTags = @(
    'body','leatherDef','woolDef','meatDef','def','race','thingDef','useMeatFrom',
    'soundWounded','soundDeath','soundCall','soundAngry',
    'soundMeleeHitPawn','soundMeleeHitBuilding','soundMeleeMiss',
    'linkedBodyPartsGroup','milkDef','eggUnfertilizedDef','eggFertilizedDef',
    'skillGains','researchPrerequisites','recipeUsers','thingDefs',
    'thinkTreeMain','thinkTreeConstant','researchPrerequisite',
    # Reflection finds this one on its own. It is written down anyway so that the fallback list,
    # the one used when the assembly will not load, still catches the bug this pass was opened
    # for.
    'thingToSpawn',
    # Same reasoning. A JoyGiverDef names the job it hands out, and Ancient Salvage shipped one
    # whose jobDef had been left behind in the mod it was extracted from - the joy giver and the
    # missing job even shared a defName, so the file read as if it resolved. Nothing failed at
    # load beyond one cross-reference line; the foosball table was simply never playable.
    'jobDef'
)

# Une reference peut pointer sur un nom qui existe... mais dans le mauvais type de def.
# Cas vecu : <race>Nem_Mantis</race> designait un BodyDef homonyme, la PawnKindDef etait
# donc cassee alors que le nom se resolvait. D'ou ce controle de type.
# These hand-written entries win over anything reflection derives for the same tag.
$CoreExpectedType = @{
    'race'                 = 'ThingDef'
    'body'                 = 'BodyDef'
    'leatherDef'           = 'ThingDef'
    'woolDef'              = 'ThingDef'
    'meatDef'              = 'ThingDef'
    'milkDef'              = 'ThingDef'
    'thingDef'             = 'ThingDef'
    'useMeatFrom'          = 'ThingDef'
    'eggUnfertilizedDef'   = 'ThingDef'
    'eggFertilizedDef'     = 'ThingDef'
    'thinkTreeMain'        = 'ThinkTreeDef'
    'thinkTreeConstant'    = 'ThinkTreeDef'
    'researchPrerequisite' = 'ResearchProjectDef'
    'linkedBodyPartsGroup' = 'BodyPartGroupDef'
    'soundWounded'         = 'SoundDef'
    'soundDeath'           = 'SoundDef'
    'soundCall'            = 'SoundDef'
    'soundAngry'           = 'SoundDef'
    'soundMeleeHitPawn'    = 'SoundDef'
    'soundMeleeHitBuilding'= 'SoundDef'
    'soundMeleeMiss'       = 'SoundDef'
    'thingToSpawn'         = 'ThingDef'
    # `jobDef` is deliberately absent, though the existence check above does read it. The name
    # is not one field but two, of unrelated types: JoyGiverDef.jobDef is a JobDef, while the
    # transport-ship quest nodes of Royalty write <jobDef>Unload</jobDef> for a ShipJobDef.
    # Demanding JobDef reports Core against itself; this table holds one type per tag, and no
    # single type is right here. So <jobDef>Steel</jobDef> still passes - the tag resolves, and
    # what it resolves to goes unchecked.
}

# ---------------------------------------------------------------------------------------------
# The rest of the tags come from the assembly. Every field whose type is a Def or a List/array
# of Def is an XML element carrying a cross-reference; there are about 1200 such names, against
# the 26 written above.
#
# Dictionary<SomeDef, V> fields are NOT collected: in
# `<skillGains><Shooting>4</Shooting></skillGains>` the reference is the child element's NAME,
# not its text, and this script reads text. Left in, they would be silently mis-parsed; left
# out, skillGains stays unchecked, which is what it already was. Check-XmlFields.ps1 is blind
# to it too - a skillGains written in the wrong shape aborts the whole def, so it is worth
# someone's time separately.
#
# Reflection is not a new dependency: this script already cannot run without the RimWorld
# install it reads Core and the DLCs from. If the assembly will not load, the core list above
# still works and the run says so rather than quietly checking less.
function Get-ReflectedRefFields {
    param([string]$ManagedDir)

    $asmPath = Join-Path $ManagedDir 'Assembly-CSharp.dll'
    if (-not (Test-Path $asmPath)) { return $null }

    $script:probed = @{}
    $resolver = [System.ResolveEventHandler]{
        param($sender, $e)
        if ($null -eq $script:probed) { return $null }
        $short = $e.Name.Split(',')[0]
        if ($script:probed.ContainsKey($short)) { return $null }
        $script:probed[$short] = $true
        $p = Join-Path $ManagedDir "$short.dll"
        if (Test-Path $p) { return [System.Reflection.Assembly]::LoadFrom($p) }
        return $null
    }
    [System.AppDomain]::CurrentDomain.add_AssemblyResolve($resolver)
    try {
        $asm = [System.Reflection.Assembly]::LoadFrom($asmPath)
        # GetTypes() always throws here - Assembly-CSharp references Unity assemblies that are
        # not loadable outside the game - but the exception carries every type it did resolve.
        try     { $types = $asm.GetTypes() }
        catch [System.Reflection.ReflectionTypeLoadException] { $types = $_.Exception.Types | Where-Object { $_ } }
        catch   { $types = $_.Exception.InnerException.Types | Where-Object { $_ } }

        $defType = $types | Where-Object { $_.FullName -eq 'Verse.Def' } | Select-Object -First 1
        if (-not $defType) { return $null }

        $flags = [System.Reflection.BindingFlags]'Public,NonPublic,Instance,DeclaredOnly'

        # Compiler-generated types - closures, iterator state machines - are never loaded from
        # XML. Counting their fields wrongly marked thingToSpawn, body and thingDefs ambiguous.
        $isGenerated = { param($t) $t.Name -match '[<>]' -or ($t.FullName -and $t.FullName -match '[<>]') }

        # Unwrap List<T> / T[] to T.
        $elementOf = {
            param($ft)
            if ($ft.IsArray) { return $ft.GetElementType() }
            if ($ft.IsGenericType) {
                $a = $ft.GetGenericArguments()
                if ($a.Count -eq 1) { return $a[0] }
            }
            return $ft
        }

        $ancestors = @{}  # def type name -> its ancestor type names, for the subclass test
        foreach ($t in $types) {
            if ($defType.IsAssignableFrom($t)) {
                $chain = @()
                $b = $t.BaseType
                while ($b -and $b.Name -ne 'Object') { $chain += $b.Name; $b = $b.BaseType }
                $ancestors[$t.Name] = $chain
            }
        }

        # Which classes can the XML loader actually populate? Start at the Defs and follow every
        # field whose type is another class of the game - CompProperties, VerbProperties,
        # GraphicData and the rest. Nothing else is ever written in a def file.
        #
        # This closure is what makes the ambiguity test mean anything. Asking merely "does any
        # class in the assembly use this name for a non-Def?" is far too broad: it disqualified
        # `thingToSpawn` over BuildingGroundSpawner.thingToSpawn, a live Thing held at runtime by
        # a class no XML ever touches - and that is the exact field this whole pass exists to
        # add. Restricted to the closure, the test keeps `thingToSpawn` and still throws out
        # `title`, `tags`, `category` and `key`, which really are plain strings on a Def.
        # A field declares List<CompProperties>, but the XML writes
        # <li Class="CompProperties_Spawner"> and the loader builds the subclass. Following
        # declared field types alone therefore reaches CompProperties and stops - which left
        # `thingToSpawn` out of the closure entirely, and with it most of what lives on a comp,
        # a PlaceWorker or an IngestionOutcomeDoer. Every descendant of a reachable type is
        # reachable too, so index the children once and walk them with the fields.
        $children = @{}
        foreach ($t in $types) {
            if (& $isGenerated $t) { continue }
            $b = $t.BaseType
            while ($b -and $b.Name -ne 'Object') {
                if ($b.FullName) {
                    if (-not $children.ContainsKey($b.FullName)) { $children[$b.FullName] = @() }
                    $children[$b.FullName] += $t
                }
                $b = $b.BaseType
            }
        }

        # Following subclasses is right for CompProperties and its kind, but it also opens the
        # door to the live game object graph: reach Verse.Thing once and every Building walks in
        # behind it, BuildingGroundSpawner among them - whose `thingToSpawn` holds a spawned
        # Thing at runtime and would disqualify the CompProperties_Spawner field of the same
        # name, which is the one field this pass exists to add. A def file never contains a live
        # object, so these roots and everything under them stay out.
        $runtimeRoots = @(
            'Verse.Thing','Verse.ThingComp','Verse.Hediff','Verse.HediffComp','Verse.AI.Job',
            'Verse.AI.JobDriver','Verse.AI.ThinkNode','Verse.Map','Verse.World',
            'RimWorld.Planet.WorldObject','RimWorld.Planet.WorldObjectComp','Verse.GameComponent',
            'Verse.WorldComponent','Verse.MapComponent','Verse.Window','Verse.Verb',
            'RimWorld.Ability','RimWorld.AbilityComp','RimWorld.Precept','RimWorld.LordJob',
            'Verse.AI.Group.LordToil','Verse.AI.Group.Trigger'
        ) | ForEach-Object { $n = $_; $types | Where-Object { $_.FullName -eq $n } } | Where-Object { $_ }

        $isRuntime = {
            param($t)
            foreach ($r in $runtimeRoots) { if ($r.IsAssignableFrom($t)) { return $true } }
            return $false
        }

        $loadable = [System.Collections.Generic.HashSet[string]]::new()
        $queue = [System.Collections.Generic.Queue[System.Type]]::new()
        $enqueue = {
            param($t)
            # FullName is null for a generic parameter type, and both the set and the child
            # index are keyed on it.
            if (-not $t -or -not $t.FullName -or (& $isGenerated $t)) { return }
            if (& $isRuntime $t) { return }
            if ($loadable.Add($t.FullName)) { $queue.Enqueue($t) }
        }
        foreach ($t in $types) {
            if ($defType.IsAssignableFrom($t)) { & $enqueue $t }
        }
        while ($queue.Count) {
            $t = $queue.Dequeue()
            if ($children.ContainsKey($t.FullName)) {
                foreach ($d in $children[$t.FullName]) { & $enqueue $d }
            }
            $fs = $null
            try { $fs = $t.GetFields($flags) } catch { continue }
            foreach ($f in $fs) {
                if ($f.IsStatic) { continue }
                $et = & $elementOf $f.FieldType
                if (-not $et -or $et.IsPrimitive -or $et.IsEnum -or $et.IsInterface) { continue }
                if ($et.FullName -eq 'System.String' -or $et.Namespace -notlike 'Verse*' -and $et.Namespace -notlike 'RimWorld*') { continue }
                if ($defType.IsAssignableFrom($et)) { continue }   # a reference, not a container
                & $enqueue $et
            }
        }

        $tags   = [System.Collections.Generic.HashSet[string]]::new()
        $types2 = @{}   # field name -> list of target def type names
        $nonDef = [System.Collections.Generic.HashSet[string]]::new()

        foreach ($t in $types) {
            if ($t.IsEnum -or $t.IsInterface) { continue }
            if (& $isGenerated $t) { continue }
            if (-not $loadable.Contains($t.FullName)) { continue }
            $fs = $null
            try { $fs = $t.GetFields($flags) } catch { continue }
            foreach ($f in $fs) {
                if ($f.IsStatic) { continue }
                $ft = $f.FieldType
                $target = $null
                if ($defType.IsAssignableFrom($ft)) { $target = $ft.Name }
                elseif ($ft.IsArray -and $defType.IsAssignableFrom($ft.GetElementType())) { $target = $ft.GetElementType().Name }
                elseif ($ft.IsGenericType) {
                    $a = $ft.GetGenericArguments()
                    if ($a.Count -eq 1 -and $defType.IsAssignableFrom($a[0])) { $target = $a[0].Name }
                    # Dictionary<SomeDef, V> deliberately skipped: see the note above.
                }
                if (-not $target) { [void]$nonDef.Add($f.Name); continue }
                [void]$tags.Add($f.Name)
                if (-not $types2.ContainsKey($f.Name)) { $types2[$f.Name] = @() }
                if ($types2[$f.Name] -notcontains $target) { $types2[$f.Name] += $target }
            }
        }

        # A name that also spells a non-Def field on some XML-loaded class is dropped: the
        # checker cannot tell the two apart from the element name alone.
        $tags.ExceptWith($nonDef)
        foreach ($n in @($types2.Keys)) { if ($nonDef.Contains($n)) { $types2.Remove($n) } }

        return [pscustomobject]@{ Tags = $tags; Types = $types2; Ancestors = $ancestors }
    }
    catch { Write-Host "Reflexion impossible : $($_.Exception.Message)" -ForegroundColor Yellow; return $null }
    finally { [System.AppDomain]::CurrentDomain.remove_AssemblyResolve($resolver) }
}

$reflected = Get-ReflectedRefFields -ManagedDir $Managed

$RefTags = [System.Collections.Generic.HashSet[string]]::new([string[]]$CoreRefTags)
$ExpectedType = @{}
foreach ($k in $CoreExpectedType.Keys) { $ExpectedType[$k] = $CoreExpectedType[$k] }
$DefAncestors = @{}

if ($reflected) {
    $RefTags.UnionWith($reflected.Tags)
    $DefAncestors = $reflected.Ancestors
    # Only the tag list is widened, never the type table. Deriving expected types from the
    # assembly as well was tried and reverted: it reports Core against itself. `treeDef` is a
    # ThingDef on one class and a ThinkTreeDef on another, `place` a PlaceDef and a TerrainDef,
    # `categoryDef` an IdeoPresetCategoryDef and a ThingCategoryDef - and reflection sees only
    # whichever the closure reached, so every other use of the name comes out as a wrong-type
    # error against a def the game loads happily. The presence check is what this pass is for;
    # the type check stays the short hand-written table above, where every entry is a case that
    # actually went wrong once.
    Write-Host ("Champs de reference lus dans l'assemblage : {0} balises ({1} ecrites a la main), {2} typees" -f `
        $RefTags.Count, $CoreRefTags.Count, $ExpectedType.Count) -ForegroundColor DarkGray
} else {
    Write-Host "ATTENTION : Assembly-CSharp.dll illisible ($Managed)." -ForegroundColor Yellow
    Write-Host "            Repli sur la liste ecrite a la main : $($RefTags.Count) balises seulement." -ForegroundColor Yellow
}

function Get-Defs {
    param([string]$Root)
    $names   = [System.Collections.Generic.HashSet[string]]::new()
    $parents = [System.Collections.Generic.HashSet[string]]::new()
    $types   = @{}   # defName -> types de def qui le declarent
    foreach ($f in Get-ChildItem -Path $Root -Filter *.xml -Recurse -File) {
        try { [xml]$x = Get-Content -LiteralPath $f.FullName -Raw -Encoding UTF8 } catch { continue }
        # Not just the children of <Defs>. A mod may declare a def inside a patch:
        #
        #   <Operation Class="PatchOperationConditional">
        #     <match Class="PatchOperationAdd"><xpath>Defs</xpath><value>
        #       <ThingDef><defName>FS_FireworkStand</defName>
        #
        # which is how a def guarded on another mod's presence has to be written. Reading only
        # the <Defs> root declared FireworkStand's own four defs missing from FireworkStand.
        # Any element with a defName child is a def declaration, wherever it sits.
        foreach ($d in $x.SelectNodes('//*[defName]')) {
            $dn = [string]$d.defName
            if (-not $dn) { continue }
            [void]$names.Add($dn)
            if (-not $types.ContainsKey($dn)) { $types[$dn] = @() }
            if ($types[$dn] -notcontains $d.LocalName) { $types[$dn] += $d.LocalName }
        }
        foreach ($d in $x.SelectNodes('//*[@Name]')) {
            $n = $d.GetAttribute('Name')
            if ($n) { [void]$parents.Add($n) }
        }
    }
    [pscustomobject]@{ Names = $names; Parents = $parents; Types = $types }
}

Write-Host "Lecture des defs du jeu ($GameData)..." -ForegroundColor DarkGray
$game = Get-Defs -Root $GameData
Write-Host "Lecture des defs du mod ($ModPath)..." -ForegroundColor DarkGray
$mod  = Get-Defs -Root $ModPath
foreach ($extra in $AlsoScan) {
    if (-not (Test-Path $extra)) { continue }
    Write-Host "Lecture des defs de dependance ($extra)..." -ForegroundColor DarkGray
    $e = Get-Defs -Root $extra
    $game.Names.UnionWith($e.Names); $game.Parents.UnionWith($e.Parents)
    foreach ($k in $e.Types.Keys) { if (-not $game.Types.ContainsKey($k)) { $game.Types[$k] = $e.Types[$k] } }
}

$known       = [System.Collections.Generic.HashSet[string]]::new($game.Names)
$known.UnionWith($mod.Names)
$knownParent = [System.Collections.Generic.HashSet[string]]::new($game.Parents)
$knownParent.UnionWith($mod.Parents)

# Table fusionnee nom -> types, pour le controle de type des references.
$knownTypes = @{}
foreach ($src in @($game.Types, $mod.Types)) {
    foreach ($k in $src.Keys) {
        if (-not $knownTypes.ContainsKey($k)) { $knownTypes[$k] = @() }
        foreach ($t in $src[$k]) { if ($knownTypes[$k] -notcontains $t) { $knownTypes[$k] += $t } }
    }
}

# RimWorld builds a slice of its defs in code at startup, from other defs, and no XML declares
# them. Checked against Core and the DLCs: Meat_Human, Corpse_Mech_Lancer, Neurotrainer_Shooting,
# CarpetGreen and Vacstone_Rough are in no def file in the game, yet the game's own defs point at
# them. A checker that only reads XML has to be told, or it calls vanilla broken.
#
# The three big families are derived from the corpus rather than listed, so a mod's own animals
# get the same treatment: reference Meat_MyDeer and it resolves, exactly as it will in game.
foreach ($n in @($known)) {
    if ($knownTypes[$n] -contains 'ThingDef') {
        [void]$known.Add("Meat_$n"); [void]$known.Add("Leather_$n"); [void]$known.Add("Corpse_$n")
        # TerrainDefGenerator_Stone, one set per stone type.
        [void]$known.Add("${n}_Rough"); [void]$known.Add("${n}_Smooth"); [void]$known.Add("${n}_RoughHewn")
    }
    if ($knownTypes[$n] -contains 'SkillDef') {
        [void]$known.Add("Neurotrainer_$n")
        # GeneDefGenerator, one aptitude gene per skill per level.
        foreach ($lvl in 'Terrible','Poor','Strong','Remarkable') { [void]$known.Add("Aptitude${lvl}_$n") }
    }
    if ($knownTypes[$n] -contains 'ChemicalDef') {
        [void]$known.Add("AddictionImmune_$n"); [void]$known.Add("ChemicalDependency_$n")
    }
}

# The rest have no stem to derive from. Kept as an explicit list rather than a loose prefix so
# it stays readable and so it can be re-checked when RimWorld next changes: each entry is a
# generator that exists in 1.6, and nothing here is excused beyond it.
$GeneratedPatterns = @(
    '^Carpet[A-Z]'              # TerrainDefGenerator_Carpet, one per carpet colour
    '^MechSerumNeurotrainer'    # ThingDefGenerator_Neurotrainer
    '^NamerLandmark'            # RulePackDefs built per landmark
    '^Ambient_MetalHell$'       # a SoundDef the Anomaly map generator makes
)

$missing = @{}
$wrongType = @{}
$badParents = @{}
$classes = @{}
$broken = @()

foreach ($f in Get-ChildItem -Path $ModPath -Filter *.xml -Recurse -File) {
    $rel = $f.FullName.Substring($ModPath.Length).TrimStart('\')
    # Languages/ holds keyed and injected translations, not defs. Their element names are
    # translation keys chosen by whoever wrote the mod, and with the tag list now a thousand
    # names wide they collide: Core's own Misc.xml has a <damage> key that is not a DamageDef.
    # Check-DefInjected.ps1 is what reads those files.
    if ($rel -match '(^|\\)Languages(\\|$)') { continue }
    try { [xml]$x = Get-Content -LiteralPath $f.FullName -Raw -Encoding UTF8 }
    catch { $broken += "$rel : $($_.Exception.Message)"; continue }
    foreach ($el in $x.SelectNodes('//*')) {
        $pn = $el.GetAttribute('ParentName')
        if ($pn -and -not $knownParent.Contains($pn)) { $badParents["$pn|$rel"] = $true }
        $cl = $el.GetAttribute('Class')
        if ($cl) { $classes["$cl|$rel"] = $true }
        if (-not $RefTags.Contains($el.LocalName)) { continue }

        # Two shapes carry a reference, and until now only the first was read:
        #   <meatDef>Meat_Cow</meatDef>                     one text child
        #   <researchPrerequisites><li>Foo</li></...>        a list of <li>
        # researchPrerequisites, recipeUsers and thingDefs were in the tag list from the start
        # and never checked once, because a list's first child is an element, not text. On a
        # fixture with four broken references the old condition caught one.
        # A <li> with a Class= attribute is a sub-object, not a reference; its own children are
        # visited on their own by the //* walk.
        $values = @()
        if ($el.GetAttribute('MayRequire') -or $el.GetAttribute('MayRequireAnyOf')) { continue }
        if ($el.ChildNodes.Count -eq 1 -and $el.FirstChild.NodeType -eq 'Text') {
            $values = @($el.InnerText -split ',')
        }
        else {
            foreach ($li in $el.ChildNodes) {
                if ($li.NodeType -ne 'Element' -or $li.LocalName -ne 'li') { continue }
                if ($li.GetAttribute('Class')) { continue }
                # <li MayRequire="nelim.rimscent.extended.incenseplus">... - the game drops the
                # entry when that mod is absent, so it is never a dangling reference. Reporting
                # it would punish exactly the mods that guard their optional content properly.
                if ($li.GetAttribute('MayRequire') -or $li.GetAttribute('MayRequireAnyOf')) { continue }
                if ($li.ChildNodes.Count -eq 1 -and $li.FirstChild.NodeType -eq 'Text') {
                    $values += $li.InnerText
                }
            }
        }

        foreach ($v in $values) {
            $v = $v.Trim()
            if (-not $v) { continue }
            # A QuestScriptDef writes <faction>$siteFaction</faction>: the value is a slot in the
            # quest's variable bag, filled at runtime, and is never a defName. Core and the DLCs
            # alone hold some 250 of them.
            if ($v.StartsWith('$')) { continue }
            # Some names are a def reference on one class and a struct on another: `color` is a
            # ColorDef on Plan and CompUniqueWeapon, and a Color on every GraphicData in the
            # game; `pattern` is a RitualPatternDef and also a vector. The tag has to stay - it
            # is the same reason `thingToSpawn` had to be included despite BuildingGroundSpawner
            # holding a runtime Thing under that name - so the value decides instead. A defName
            # is a bare identifier; "(0.4", "0.5" and "(0, -1)" are not, and a def named like
            # that could not be declared in the first place. This trades away typos written with
            # a space in them, which the game would not resolve either.
            if ($v -notmatch '^[A-Za-z_][A-Za-z0-9_.\-]*$') { continue }
            if (-not $known.Contains($v)) {
                $gen = $false
                foreach ($p in $GeneratedPatterns) { if ($v -match $p) { $gen = $true; break } }
                if (-not $gen) { $missing["$v|$rel|$($el.LocalName)"] = $true }
            }
            elseif ($ExpectedType.ContainsKey($el.LocalName)) {
                $want = $ExpectedType[$el.LocalName]
                $got  = $knownTypes[$v]
                # A def declared as a subclass satisfies a field typed on the base: a
                # <ThingDef> answers a field of type BuildableDef. Without this the broader
                # reflected table would report half of Core against itself.
                $ok = $false
                foreach ($g in $got) {
                    if ($g -eq $want) { $ok = $true; break }
                    if ($DefAncestors.ContainsKey($g) -and ($DefAncestors[$g] -contains $want)) { $ok = $true; break }
                }
                if ($got -and -not $ok) {
                    $wrongType["$v|$rel|$($el.LocalName)|$want|$($got -join ',')"] = $true
                }
            }
        }
    }
}

Write-Host ""
Write-Host "=== $ModPath ===" -ForegroundColor Cyan
Write-Host ("defs du mod : {0}   parents du mod : {1}" -f $mod.Names.Count, $mod.Parents.Count)

if ($broken) {
    Write-Host "`n-- XML MAL FORMES --" -ForegroundColor Red
    $broken | ForEach-Object { Write-Host "  $_" }
} else { Write-Host "-- tous les XML sont bien formes --" -ForegroundColor Green }

if ($missing.Count) {
    Write-Host "`n-- REFERENCES INTROUVABLES --" -ForegroundColor Red
    $missing.Keys | Sort-Object | ForEach-Object {
        $p = $_ -split '\|'; Write-Host ("  {0,-42} {1} <{2}>" -f $p[0], $p[1], $p[2])
    }
} else { Write-Host "-- aucune reference de def introuvable --" -ForegroundColor Green }

if ($wrongType.Count) {
    Write-Host "`n-- REFERENCES DE MAUVAIS TYPE --" -ForegroundColor Red
    Write-Host "   (le nom existe, mais il designe autre chose que ce que la balise attend)" -ForegroundColor DarkGray
    $wrongType.Keys | Sort-Object | ForEach-Object {
        $p = $_ -split '\|'
        Write-Host ("  {0,-32} <{1}> attend {2}, trouve {3}" -f $p[0], $p[2], $p[3], $p[4])
        Write-Host ("      {0}" -f $p[1]) -ForegroundColor DarkGray
    }
} else { Write-Host "-- toutes les references pointent sur le bon type de def --" -ForegroundColor Green }

if ($badParents.Count) {
    Write-Host "`n-- ParentName INTROUVABLES --" -ForegroundColor Red
    $badParents.Keys | Sort-Object | ForEach-Object {
        $p = $_ -split '\|'; Write-Host ("  {0,-42} {1}" -f $p[0], $p[1])
    }
} else { Write-Host "-- tous les ParentName sont resolus --" -ForegroundColor Green }

if ($classes.Count -and -not $Brief) {
    Write-Host "`n-- Class= utilisees (verifier a la main si elles viennent d'un mod) --" -ForegroundColor Yellow
    $classes.Keys | Sort-Object | ForEach-Object {
        $p = $_ -split '\|'; Write-Host ("  {0,-42} {1}" -f $p[0], $p[1])
    }
}

if ($broken.Count -or $missing.Count -or $wrongType.Count -or $badParents.Count) { exit 1 }
