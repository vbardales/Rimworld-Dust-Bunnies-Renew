<#
.SYNOPSIS
  The claims this mod makes about itself, checked against the XML and the game's own data.

.DESCRIPTION
  Not a check that the XML is well formed or that its references resolve: Check-XmlFields, Check-DefRefs and
  Check-DefInjected do that. This one asserts the few facts the public description and the docs state, and that
  have already been wrong once:

    1. Both recipes are offered at the crafting spot and nowhere else.
    2. MakeDustBunny declares no <products>. That is the trigger, not a detail: a recipe without products cannot be
       counted, so "do until you have X" is refused by the game with a message. The mod's part is having none.
    3. Wildness is a stat under statBases and no def of the mod still writes it as a field of <race>. The old form
       loads without a word and leaves the stat at its default of -1, clamped to 0.
    4. Dust is the worst cold insulator of every material a garment can be made from, and no more flammable as a
       stuff than cloth. "A garment can be made from" is READ from the game: the union of the stuffCategories of
       every apparel def, not a list copied here. Materials are resolved through ParentName before comparing,
       because most inherit the stat, and one that states none counts as the stat's default, 0.
    5. The butchering yield the description gives. It is computed the way the game does: the base body size times
       the body size factor of the ONLY life stage the race declares, times LeatherAmount, run through the stat's
       postProcessCurve. Read off the def instead, it comes out at 18 - the figure the description once claimed,
       and wrong by a factor of three, because a def has no life stage.

  Numbers are parsed with the invariant culture: on a French machine "2.5" is not a number to a default parse.

  Each claim was seen to fail: a copy of Mod/ outside the repository was mutated once per claim, and the check
  exited 1 on every one and 0 on the untouched mod. See the mutation list in _tools/checks/README.md.

.EXAMPLE
  pwsh -NoProfile -File _tools/checks/Check-Claims.ps1 -ModPath Mod -GameData "C:\...\RimWorld\Data"
#>
param(
    [Parameter(Mandatory)][string]$ModPath,
    [Parameter(Mandatory)][string]$GameData
)
$ErrorActionPreference = 'Stop'
$inv = [Globalization.CultureInfo]::InvariantCulture
$script:failures = 0

function Pass([string]$m) { Write-Host "ok    $m" }
function Fail([string]$m) { Write-Host "FAIL  $m" -ForegroundColor Red; $script:failures++ }
function Num([string]$s) { [double]::Parse($s.Trim(), $inv) }
function Load-Xml([string]$path) { $x = New-Object System.Xml.XmlDocument; $x.Load($path); $x }

# ------------------------------------------------------------------------------------------ the mod's defs

$modNodes = @()
foreach ($f in Get-ChildItem -LiteralPath (Join-Path $ModPath 'Defs') -Recurse -Filter *.xml) {
    $doc = Load-Xml $f.FullName
    foreach ($n in $doc.DocumentElement.ChildNodes) { if ($n.NodeType -eq 'Element') { $modNodes += $n } }
}
function Mod-Def([string]$type, [string]$defName) {
    $modNodes | Where-Object { $_.LocalName -eq $type -and $_.defName -ceq $defName } | Select-Object -First 1
}
$modNamed = @{}
foreach ($n in $modNodes) { $nm = $n.GetAttribute('Name'); if ($nm) { $modNamed[$nm] = $n } }

# A value read through ParentName, inside the mod only. Returns the text of the first match, or $null.
function Mod-Inherited($node, [string]$xpath) {
    $cur = $node; $guard = 0
    while ($cur -and $guard++ -lt 20) {
        $hit = $cur.SelectSingleNode($xpath)
        if ($hit) { return $hit.InnerText }
        $p = $cur.GetAttribute('ParentName')
        if ($p -and $modNamed.ContainsKey($p)) { $cur = $modNamed[$p] } else { break }
    }
    return $null
}

# ------------------------------------------------------------------------------------ 1 and 2: the recipes

foreach ($name in 'GatherDust', 'MakeDustBunny') {
    $r = Mod-Def 'RecipeDef' $name
    if (-not $r) { Fail "RecipeDef $name is not declared"; continue }
    $users = @($r.SelectNodes('recipeUsers/li') | ForEach-Object { $_.InnerText })
    if ($users.Count -eq 1 -and $users[0] -ceq 'CraftingSpot') { Pass "$name is offered at the crafting spot and nowhere else" }
    else { Fail "$name recipeUsers is [$($users -join ', ')], expected exactly CraftingSpot" }
}
$make = Mod-Def 'RecipeDef' 'MakeDustBunny'
if ($make) {
    if ($make.SelectSingleNode('products')) { Fail 'MakeDustBunny declares <products>: the game could then count it, and "do until you have X" would no longer be refused' }
    else { Pass 'MakeDustBunny declares no <products>' }
}

# --------------------------------------------------------------------------------------------- 3: wildness

$wild = $modNodes | Where-Object { $_.SelectSingleNode('race/wildness') }
if ($wild) { Fail "a <race><wildness> field is written by: $(($wild | ForEach-Object { $_.defName + $_.GetAttribute('Name') }) -join ', ')" }
else { Pass 'no def writes wildness as a field of <race>' }
$bunny = Mod-Def 'ThingDef' 'DustBunny'
$wildValue = if ($bunny) { Mod-Inherited $bunny 'statBases/Wildness' } else { $null }
if ($null -eq $wildValue) { Fail 'DustBunny has no Wildness under statBases, directly or through ParentName' }
elseif ((Num $wildValue) -eq 0.1) { Pass 'Wildness is 0.1 under statBases' }
else { Fail "Wildness under statBases is ${wildValue}, the description and the docs say 0.1" }

# --------------------------------------------------------------------------- the game's own data, resolved

$vanilla = @{}      # Name= -> node, for ParentName resolution
$stuffs = @()       # concrete ThingDefs
$apparelCategories = New-Object 'System.Collections.Generic.HashSet[string]'
$lifeStages = @{}
$statDefs = @{}
foreach ($pack in Get-ChildItem -LiteralPath $GameData -Directory) {
    $defsDir = Join-Path $pack.FullName 'Defs'
    if (-not (Test-Path -LiteralPath $defsDir)) { continue }
    foreach ($f in Get-ChildItem -LiteralPath $defsDir -Recurse -Filter *.xml) {
        # Only the files that can matter: reading all ~7000 is minutes, and these four words are the whole need.
        $text = [IO.File]::ReadAllText($f.FullName)
        if ($text -notmatch 'stuffProps|StuffPower_Insulation_Cold|<apparel>|LifeStageDef|<StatDef') { continue }
        $doc = Load-Xml $f.FullName
        foreach ($n in $doc.DocumentElement.ChildNodes) {
            if ($n.NodeType -ne 'Element') { continue }
            switch ($n.LocalName) {
                'ThingDef' {
                    $nm = $n.GetAttribute('Name'); if ($nm) { $vanilla[$nm] = $n }
                    if ($n.defName -and $n.GetAttribute('Abstract') -ne 'True') { $stuffs += $n }
                    if ($n.SelectSingleNode('apparel')) {
                        foreach ($li in $n.SelectNodes('stuffCategories/li')) { [void]$apparelCategories.Add($li.InnerText) }
                    }
                }
                'LifeStageDef' { if ($n.defName) { $lifeStages[$n.defName] = $n } }
                'StatDef' { if ($n.defName) { $statDefs[$n.defName] = $n } }
            }
        }
    }
}
function Vanilla-Inherited($node, [string]$xpath) {
    $cur = $node; $guard = 0
    while ($cur -and $guard++ -lt 20) {
        $hit = $cur.SelectSingleNode($xpath)
        if ($hit) { return $hit.InnerText }
        $p = $cur.GetAttribute('ParentName')
        if ($p -and $vanilla.ContainsKey($p)) { $cur = $vanilla[$p] } else { break }
    }
    return $null
}
function Vanilla-Categories($node) {
    $cur = $node; $guard = 0
    while ($cur -and $guard++ -lt 20) {
        $li = @($cur.SelectNodes('stuffProps/categories/li') | ForEach-Object { $_.InnerText })
        if ($li.Count) { return $li }
        $p = $cur.GetAttribute('ParentName')
        if ($p -and $vanilla.ContainsKey($p)) { $cur = $vanilla[$p] } else { break }
    }
    return @()
}

if ($apparelCategories.Count -eq 0) { Fail 'read no stuffCategories from any apparel def: the game data path is wrong or its layout changed' }

# ------------------------------------------------------------------------ 4: dust as a stuff, against the game

$dust = Mod-Def 'ThingDef' 'Dust'
if (-not $dust) { Fail 'ThingDef Dust is not declared' }
else {
    $dustCold = Mod-Inherited $dust 'statBases/StuffPower_Insulation_Cold'
    if ($null -eq $dustCold) { Fail 'Dust states no StuffPower_Insulation_Cold' }
    else {
        $dustColdN = Num $dustCold
        $worn = @()
        foreach ($s in $stuffs) {
            $cats = Vanilla-Categories $s
            if (-not ($cats | Where-Object { $apparelCategories.Contains($_) })) { continue }
            $v = Vanilla-Inherited $s 'statBases/StuffPower_Insulation_Cold'
            $worn += [pscustomobject]@{ Def = $s.defName; Cold = $(if ($null -eq $v) { 0.0 } else { Num $v }) }
        }
        if ($worn.Count -lt 10) { Fail "found only $($worn.Count) vanilla stuffs a garment can be made from: the data read is incomplete" }
        else {
            $lowest = $worn | Sort-Object Cold | Select-Object -First 1
            if ($dustColdN -lt $lowest.Cold) { Pass ("Dust's cold insulation {0} is below every one of {1} stuffs a garment can be made from; the lowest is {2} at {3}" -f $dustColdN.ToString($inv), $worn.Count, $lowest.Def, $lowest.Cold.ToString($inv)) }
            else { Fail ("Dust's cold insulation {0} is not below {1}, which has {2}: 'the worst insulator of any material a garment can be made from' is false" -f $dustColdN.ToString($inv), $lowest.Def, $lowest.Cold.ToString($inv)) }
        }
    }

    $cloth = $stuffs | Where-Object { $_.defName -ceq 'Cloth' } | Select-Object -First 1
    $wood = $stuffs | Where-Object { $_.defName -ceq 'WoodLog' } | Select-Object -First 1
    $dustFactor = $dust.SelectSingleNode('stuffProps/statFactors/Flammability')
    $clothFactor = if ($cloth) { $cloth.SelectSingleNode('stuffProps/statFactors/Flammability') } else { $null }
    if (-not $dustFactor -or -not $clothFactor) { Fail 'the Flammability stat factor of Dust or of Cloth could not be read' }
    elseif ((Num $dustFactor.InnerText) -lt (Num $clothFactor.InnerText)) { Pass "Dust's flammability factor $($dustFactor.InnerText) is below cloth's $($clothFactor.InnerText)" }
    else { Fail "Dust's flammability factor $($dustFactor.InnerText) is not below cloth's $($clothFactor.InnerText)" }

    $dustFlam = Mod-Inherited $dust 'statBases/Flammability'
    $woodFlam = if ($wood) { Vanilla-Inherited $wood 'statBases/Flammability' } else { $null }
    if ($null -eq $dustFlam -or $null -eq $woodFlam) { Fail 'the Flammability of Dust or of wood could not be read' }
    elseif ((Num $dustFlam) -eq (Num $woodFlam)) { Pass "Dust burns as wood does: Flammability $dustFlam" }
    else { Fail "Dust has Flammability ${dustFlam} and wood ${woodFlam}: 'as flammable as wood' is false" }
}

# ----------------------------------------------------- 5: the butchering yield, the way the game computes it

$race = if ($bunny) { $bunny } else { $null }
if ($race) {
    $stages = @($modNodes | Where-Object { $_.LocalName -eq 'ThingDef' -and $_.defName -ceq 'DustBunny' } | ForEach-Object {
        $v = Mod-Inherited $_ 'race/lifeStageAges/li/def'
        $count = 0; $cur = $_; $guard = 0
        while ($cur -and $guard++ -lt 20) { $c = $cur.SelectNodes('race/lifeStageAges/li').Count; if ($c) { $count = $c; break }; $p = $cur.GetAttribute('ParentName'); if ($p -and $modNamed.ContainsKey($p)) { $cur = $modNamed[$p] } else { break } }
        [pscustomobject]@{ First = $v; Count = $count } })
    $stage = $stages | Select-Object -First 1
    if (-not $stage -or $stage.Count -ne 1) { Fail "the race must declare exactly one life stage for the yield to be computed from it; it declares $($stage.Count)" }
    elseif (-not $lifeStages.ContainsKey($stage.First)) { Fail "life stage $($stage.First) was not found in the game's data" }
    else {
        $factor = Num ($lifeStages[$stage.First].SelectSingleNode('bodySizeFactor').InnerText)
        $base = Num (Mod-Inherited $bunny 'race/baseBodySize')
        $leather = Num (Mod-Inherited $bunny 'statBases/LeatherAmount')
        $size = $base * $factor
        $raw = $leather * $size
        $curveText = $statDefs['LeatherAmount'].SelectSingleNode('postProcessCurve/points')
        if (-not $curveText) { Fail 'the LeatherAmount stat has no postProcessCurve in the game data' }
        else {
            $pts = @()
            foreach ($li in $curveText.SelectNodes('li')) {
                if ($li.InnerText -match '\(\s*([\d.]+)\s*,\s*([\d.]+)\s*\)') { $pts += , @((Num $Matches[1]), (Num $Matches[2])) }
            }
            $yield = $null
            for ($i = 0; $i -lt $pts.Count - 1; $i++) {
                if ($raw -ge $pts[$i][0] -and $raw -le $pts[$i + 1][0]) {
                    $t = ($raw - $pts[$i][0]) / ($pts[$i + 1][0] - $pts[$i][0])
                    $yield = $pts[$i][1] + $t * ($pts[$i + 1][1] - $pts[$i][1]); break
                }
            }
            if ($null -eq $yield) { Fail "the raw yield $raw is outside the LeatherAmount curve" }
            else {
                $line = "body size {0} = base {1} x {2} ({3}); leather {4} x {0} = {5}; through the stat's curve {6}" -f `
                    $size.ToString('0.###', $inv), $base.ToString($inv), $factor.ToString($inv), $stage.First, $leather.ToString($inv), $raw.ToString('0.###', $inv), $yield.ToString('0.##', $inv)
                if ($size -ge 0.039 -and $size -le 0.041) { Pass "the living animal's body size is 0.04: $line" }
                else { Fail "the description says the animal is 0.04 in play: $line" }
                if ($yield -ge 5 -and $yield -le 6.5) { Pass "the butchering yield is about 6: $line" }
                else { Fail "the description says butchering gives about 6 dust: $line" }
            }
        }
    }
}

# ------------------------------------ 6: the enrolment in A Dog Said... Animal Prosthetics 2, as declared

$adsId = 'SamBucher.ADogSaidAnimalProsthetics2'
$adsPatch = Join-Path $ModPath 'Patches\ADogSaidAnimalProsthetics2.xml'
if (-not (Test-Path -LiteralPath $adsPatch)) { Fail "the ADS 2 enrolment patch is missing: $adsPatch" }
else {
    $ops = @((Load-Xml $adsPatch).SelectNodes('/Patch/Operation'))
    if ($ops.Count -ne 1) { Fail "the ADS 2 patch must hold exactly one Operation, it holds $($ops.Count)" }
    else {
        $op = $ops[0]
        $guard = $op.SelectSingleNode('xpath')
        $match = $op.SelectSingleNode('match')
        if ($op.GetAttribute('Class') -cne 'PatchOperationConditional') { Fail 'the ADS 2 patch is not a PatchOperationConditional: without ADS 2 an unguarded add would log an error' }
        elseif ($op.HasAttribute('MayRequire') -or $op.HasAttribute('MayRequireAnyOf')) { Fail 'MayRequire on an Operation is read by nothing: the patch would apply with or without ADS 2' }
        elseif ($op.SelectSingleNode('nomatch')) { Fail 'the ADS 2 patch declares a <nomatch>: without ADS 2 it would do something instead of nothing' }
        elseif (-not $guard -or $guard.InnerText.Trim() -cne '/Defs/RecipeDef[@Name="ADS_Cat1"]') { Fail 'the ADS 2 patch is not guarded on ADS_Cat1, the def that only exists when ADS 2 is loaded' }
        elseif (-not $match -or $match.GetAttribute('Class') -cne 'PatchOperationAdd') { Fail 'the ADS 2 patch does not add anything when it matches' }
        else {
            $target = $match.SelectSingleNode('xpath').InnerText
            $cats = @([regex]::Matches($target, '@Name="(ADS_Cat\d)"') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)
            $users = @($match.SelectNodes('value/li') | ForEach-Object { $_.InnerText.Trim() })
            if ($cats.Count -ne 1 -or $cats[0] -cne 'ADS_Cat1') { Fail "the dust bunny is enrolled in [$($cats -join ', ')], not in ADS_Cat1 only: it is a clump of lint: categories 2 and 3 add simple prosthetics and bionics, which are not the joke" }
            elseif ($users.Count -ne 1 -or $users[0] -cne 'DustBunny') { Fail "the ADS 2 patch enrols [$($users -join ', ')], expected exactly DustBunny" }
            elseif (-not (Mod-Def 'ThingDef' 'DustBunny')) { Fail 'the ADS 2 patch names DustBunny, which the mod does not define' }
            else { Pass 'the dust bunny is enrolled in ADS 2 category 1 only, behind a condition that does nothing without ADS 2' }
        }
    }
}
# ------------------------------------------ 7: every stat the mod's ThingDefs write is a stat the game defines

# A stat the game no longer defines is not refused at load: its value is dropped and one error is logged, before any
# scenario, where "no errors were logged" does not see it. ToxicSensitivity (gone in 1.6) went through this way.
$unknownStats = @()
foreach ($n in $modNodes) {
    if ($n.LocalName -ne 'ThingDef') { continue }
    foreach ($group in 'statBases', 'equippedStatOffsets') {
        foreach ($s in $n.SelectNodes("$group/*")) {
            if (-not $statDefs.ContainsKey($s.LocalName)) { $unknownStats += "$($n.defName)$($n.GetAttribute('Name')).$group.$($s.LocalName)" }
        }
    }
}
if ($statDefs.Count -eq 0) { Fail 'read no StatDef from the game data: the path is wrong or its layout changed' }
elseif ($unknownStats.Count) { Fail "stats the game does not define: $($unknownStats -join ', ')" }
else { Pass "every stat written under statBases exists in the game ($($statDefs.Count) defined)" }

$aboutXml = Load-Xml (Join-Path $ModPath 'About\About.xml')
$before = @($aboutXml.SelectNodes('/ModMetaData/loadBefore/li') | ForEach-Object { $_.InnerText.Trim() })
$hard = @($aboutXml.SelectNodes('/ModMetaData/modDependencies/li/packageId') | ForEach-Object { $_.InnerText.Trim() })
if ($before -notcontains $adsId) { Fail "About.xml does not say loadBefore ${adsId}: ADS 2 copies its category lists once, so a patch that loads after it lands in a list nobody reads" }
elseif ($hard -contains $adsId) { Fail "About.xml lists $adsId as a hard dependency: the integration is optional" }
else { Pass "About.xml puts this mod before $adsId, and does not require it" }

# ------------------------------------------ 8: the dust bunny is nocturnal with [XND] Nocturnal Animals, and only then

$nocId = 'Mlie.XNDNocturnalAnimals'
$nocBunny = Mod-Def 'ThingDef' 'DustBunny'
$nocExt = @(if ($nocBunny) { $nocBunny.SelectNodes('modExtensions/li[@Class="NocturnalAnimals.ExtendedRaceProperties"]') })
if ($nocExt.Count -ne 1) { Fail "the DustBunny ThingDef must carry exactly one NocturnalAnimals.ExtendedRaceProperties extension, it carries $($nocExt.Count)" }
elseif ($nocExt[0].GetAttribute('MayRequire') -cne $nocId) { Fail "the Nocturnal Animals extension must carry MayRequire=`"${nocId}`": without it the class is looked up when the mod is absent and an error is logged at every start" }
elseif ($nocExt[0].SelectSingleNode('bodyClock').InnerText.Trim() -cne 'Nocturnal') { Fail "the dust bunny's bodyClock is '$($nocExt[0].SelectSingleNode('bodyClock').InnerText.Trim())', Virginie chose Nocturnal (2026-09-25)" }
elseif ($hard -contains $nocId) { Fail "About.xml lists $nocId as a hard dependency: the integration is optional" }
else { Pass "the dust bunny is Nocturnal behind MayRequire $nocId, and About.xml does not require it" }

Write-Host ''
if ($script:failures -gt 0) { Write-Host "$($script:failures) CLAIM(S) DO NOT HOLD" -ForegroundColor Red; exit 1 }
Write-Host 'EVERY CLAIM HOLDS' -ForegroundColor Green
exit 0
