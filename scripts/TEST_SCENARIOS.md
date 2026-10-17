# Functional scenarios, to be played in game

No in-game run of this port recorded. All 18 scenarios below **NOT RUN**.
After each run record date, RimWorld version, active DLC/mods, scenario ID, PASS/FAIL, observations, Player.log location; update STATUS.md with outcome.

Automated suite: `pwsh -NoProfile -File _tools/Test-Mod.ps1`. Checks XML and compiled API hook, cannot prove completing bill spawns pawn. Scenario 4 therefore first functional priority after loading. Expected results below = hypotheses to verify in RimWorld, not evidence tests passed.

Where each scenario planned to go - Pickle feature, offline assertion, or not applicable with reason - see [`../TESTING.md`](../TESTING.md).

**Setup for everything below.** Development mode on. Small colony with **crafting spot** and one colonist with Crafting enabled, not disabled by trait. Time controls 3x for slow ones. Most scenarios read either bill dialog on crafting spot or animal information card, the `i` tab, where wildness, comfortable temperature, leather amount sit.

Every quantity below = value in def, so mismatch is finding either way: game no longer reads that field, or def changed and this file not. Exception: anything depending on animal life stage, which def does not have: see scenario 11.

---

## 0. It loads, and the worker class resolved

**Do.** Start game with mod active. Load any save. Open bill dialog on crafting spot.

**Expect.** No red text at startup. Both recipes present.

**Watch for in `Player.log`.** Three lines, each different failure, and one silence:

- `Could not find type named` naming `DustBunnies.Recipe_SpawnDustBunny` - assembly did not load, or namespace moved. Dangerous one, because `workerClass` that fails to resolve does **not** kill def: field left null, recipe works in every visible way except the one that matters. See scenario 4, only place it shows.
- `Failed to find PawnKindDef named DustBunny. There are` - `[DefOf]` did not bind. Race file did not load, or defName changed on one side only.
- `Tried to use an uninitialized DefOf of type` - something touched `DustBunniesDefOf` before database complete. Port exists partly to make this impossible; if it returns, static initialiser crept back in.
- **No line at all** is what original mod loaded alongside this one looks like, so not a line to watch for. `DefDatabase.AddAllInMods` removes earlier def of a name and adds later one without saying so; `Adding duplicate` error in `Add` sits on path that call never takes, only clash inside one mod reported. `About.xml` declares `<incompatibleWith>BlockHen.Animal.DustBunnies`; see scenario 17.

**If it fails here, stop.** Everything below assumes recipes and def live.

---

## 1. The two recipes are on the crafting spot, and nowhere else

**Do.** Open bill dialog on crafting spot. Then on tailoring bench, smithy, fuelled stove.

**Expect.** *Gather dust* and *Make a dust bunny* on crafting spot only. Nothing added elsewhere.

**Why it matters.** Both declare `recipeUsers` rather than attached through bench's own recipe list. Recipe turning up on every bench means something else in load order is merging lists.

## 2. Gathering dust costs nothing but time

**Do.** Queue *Gather dust* with no dust and no other resource anywhere on map. Watch it run.

**Expect.** Runs. 250 ticks work, 10 dust drop on spot. No ingredient consumed, recipe declares none: dust comes off floor.

**Then.** Watch colonist's Crafting experience over five iterations.

**Expect.** Almost nothing. `workSkillLearnFactor` is 0.001, guard against infinite free bill being infinite free skill.

## 3. Dust is a real stuff, and a uselessly bad one

**Do.** Gather 200 dust. Open build menu, place wall, then tailoring bill for parka.

**Expect.** Dust appears in material list for both, under **Fabric**. Parka comes out **pale blue**, not grey - `stuffProps` sets colour to (174, 219, 228), the one place this mod's art and numbers disagree, and it is theirs.

**Then.** Read parka's stats, next to same parka in cloth. Every one worse, most by order of magnitude:

| | Dust | Cloth | Vanilla floor |
|---|---|---|---|
| Cold insulation | 0.9 | 18 | 2.5 |
| Heat insulation | 0 | 18 | - |
| Sharp armour | 0.002 | 0.36 | - |
| Hit points factor | 0.03 | 1 | - |

**Dust is worst insulator of any material a garment can be made from**, by factor of nearly three under lowest vanilla one. Only six stone-block stuffs state no cold insulation at all, and they are Stony, which no garment accepts. Parka of dust is not a parka. Almost certainly the joke rather than oversight - stuff swept off floor and costs nothing - and theirs either way.

**Also the one claim `About.xml` used to get wrong.** Description called dust *warm* until 2026-09-12, which these numbers say plainly it is not.

**Then.** Leave 100 dust outdoors for a day, separately drop one incendiary near pile.

**Expect.** Burns readily - `Flammability` 1.0, same as wood. But deteriorates **half as fast as cloth**, not faster: `DeteriorationRate` 2 against cloth's 4. Dust outdoors outlasts clothing outdoors, funnier than useful.

---

## 4. The bill that makes an animal

**Scenario the mod exists for.** Everything above would pass with worker class broken.

**Do.** With 100 dust in stockpile, queue *Make a dust bunny* on crafting spot. Watch colonist through whole bill.

**Expect.** 100 dust consumed. 800 ticks work. When bill completes, **live dust bunny appears on crafting spot itself**, at colonist's own position, facing random direction. No item drops, recipe declares no products.

**How it fails.** Dust consumed, work done, job ends, nothing appears. That is null `workerClass` of scenario 0, only place visible.

**Why it matters.** `Notify_IterationCompleted` called from `Toils_Recipe.FinishRecipeAndStartStoringProduct`, through `Bill_Production`, after ingredients gone and before job ends. Colonist standing on spot at that instant gives bunny its position and faction. If bunny appears elsewhere on map, that call site moved.

## 5. It is tame the moment it exists

**Do.** Click new bunny immediately, without saving or reloading.

**Expect.** Belongs to colony. Has name-less "dust bunny" label with colony's colour, can be renamed, appears in Animals tab. Never wild, never tamed: it is made, so takes faction of whoever made it.

**How it fails.** Bunny spawning wild means `billDoer.Faction` came through null - happens if bill done by pawn with no faction.

**Then.** Save, quit to main menu, reload. Confirm bunny still belongs to colony, dust stacks and queued bills persist, no new mod errors in Player.log.

## 6. Wildness reads 10%, not 0%

**Do.** Open bunny's information card.

**Expect.** **Wildness 10%.**

**Why it matters.** Port's first correction, only one with visible number. Wildness stopped being field of `RaceProperties`, became `StatDef`; old element matched no field, and RimWorld does not stop for element matching nothing - logs one line, carries on with value unset. Stat default −1, clamped to 0. Bunny left in old form would read **0%** here, or show nothing, `Wildness` declaring `showIfUndefined` false. 0% not small error: perfectly tame animal where slightly wild one intended, changes how fast training decays.

## 7. "Do until you have" is refused, with a message

**Do.** On *Make a dust bunny* bill, try set repeat mode to **Do until you have X**.

**Expect.** Refused, message is
*(This recipe cannot have a target count because it has multiple or unpredictable products.)*

**Why it matters.** Recipe has no `products`, legal handled consequence: `RecipeWorkerCounter.CanCountProducts` returns false, so `BillRepeatModeUtility` says so instead of indexing product list that does not exist. *Do X times* and *Do forever* must both still work.

---

## 8. It never eats

**Do.** Leave bunny alone three game days with no food anywhere reachable.

**Expect.** No **Food** bar on needs, at any point, no starvation. `baseHungerRate` is 0.

**Why it matters.** Deliberate in original, reason animal not liability. If Food bar appears, need created from food type rather than hunger rate, colony of these would starve.

## 9. It trains, up to Advanced

**Do.** Open bunny's **Training** tab.

**Expect.** Guard (`Obedience`) and attack (`Release`) can be assigned. `trainability` is Advanced.

**Haul and rescue shown and refused, not defect.** Carry `minBodySize` 0.40 and 0.65, game reads body size of living pawn, 0.04, so tab says animal too small. Too small at base 0.2 as well: original never offered them either.

**Watch for.** Absent or empty tab. Most likely reason is life stage: race declares exactly one, `AnimalBaby` at minimum age 0, so dust bunny **permanently baby**, never becomes adult. How mod shipped, not port's to change, but first thing to check if training, breeding, hauling behave unlike any other animal.

## 10. It survives a winter outdoors

**Do.** Put bunny outside in cold biome, or use development mode to drop temperature. Read information card.

**Expect.** **Comfortable temperature minimum −55 °C**, no hypothermia above it. Concrete def overriding abstract base's −30.

## 11. Butchering it gives dust back, and no meat

**Do.** Kill bunny, butcher corpse at butcher table.

**Expect.** Dust, nothing else. `MeatAmount` 0, `leatherDef` Dust.

**Expect about 6 dust, not 50 and not 18.** Def sets `LeatherAmount` 50, but that is stat's base value not yield. `StatPart_BodySize` scales it by body size of living animal, 0.2 times life stage factor 0.2, so 0.04. Makes 2, and stat's `postProcessCurve` lifts it to about 5.6 before difficulty and carefully-slaughtered factor touch it. Butchered amount is that value rounded at random, so 5 or 6.

**Two cards, two numbers.** Information card of *def*, opened before any bunny exists, has no life stage, uses base body size 0.2, says about 18. Card of living bunny says about 6. Check yield against living one, never def's card, never the 50.

**Why it matters.** Sets exchange rate of whole mod. 100 dust in, one bunny, about sixteenth back out - loop loses heavily, colony cannot farm dust through bunnies. `About.xml` claimed flat 50 until 2026-09-12 and about 18 until 2026-09-24. Both ignored life stage, second read off def's card.

## 12. It never arrives angry, and never turns up wild

**Do.** Play, or force manhunter-pack events in development mode, for several seasons.

**Expect.** Never a dust bunny among them - `canArriveManhunter` false. Never one on map at world generation or in wildlife wave, race belongs to no biome, whatever `ecoSystemWeight` says.

## 13. It never breeds

**Do.** Keep two bunnies together for a season.

**Expect.** No pregnancy, ever. `mateMtbHours` is 0, so `litterSizeCurve` and `gestationPeriodDays` beside it never apply. Dead settings, left as found.

**Also.** No gender on either - `hasGenders` false.

## 14. It dies of old age in about a year

**Do.** Use development mode to age bunny past one year, or keep one full year.

**Expect.** Information card reports life expectancy 1 year. Record aging effects over time; value not guaranteed death timer at first birthday.

**Then.** Look at corpse.

**Expect.** Dessicated corpse drawn **exactly like living bunny**. Not bug in port: `Dessicated_Dust_Bunny.png` and `Dust_Bunny_east.png` same file, identical by MD5, and for creature that is clump of dust arguably right. Recorded, not repainted.

## 15. The sprite is always rotated

**Do.** Watch bunny walk north, then east, then south.

**Expect.** Looks turned rather than facing where it goes, identically in every direction.

**Why it matters.** Only `_east` face ships. `Graphic_Multi` does not fail on that: with no `_north` takes east texture, sets `drawRotatedExtraAngleOffset` to −90°, derives rest. So mod looked like this since 2021, and bunny drawn correctly from four angles would mean something else supplying textures.

---

## 16. English and French translation gate

**Do.** Run first in English, then switch to French and restart. Look at animal and dust information cards, both recipe descriptions and bill labels, colonist's job text while each recipe runs. Inspect head and bite attack wording, dust-made garment's material name, dust bunny corpse. Try target-count rejection from scenario 7 in each language.

**Expect.** *mouton de poussière* for animal, *poussière* for resource, both recipe labels, descriptions, job strings in French. Head tool reads *tête*.
In English, expect *dust bunny*, *dust*, *head*, English recipe text.
12 owned text paths inventoried in STATUS.md; generated material, corpse, rejection text must also use selected language without raw keys, accidental English fallback, broken grammar, formatting errors, clipping.

Record separate English and French PASS/FAIL results, game version, active mods, date, log path. Static resource checks do not count as running this scenario.

**Watch for in `Player.log`.** `Duplicate def-injected translation key` or def-injection report naming this mod. Either means key misspelled or aimed at def that no longer exists.

## 17. The original must not load alongside

**Do.** Enable both this mod and 2blockdude's original (Workshop 2659958183), if still subscribed.

**Expect.** RimWorld reports incompatibility in mod list, because `About.xml` names `BlockHen.Animal.DustBunnies` in `<incompatibleWith>`. Report is engine's, not what is tested.

**Then, in test colony only,** load both anyway. **Expect silence:** no error names clash. Game removes earlier def of a name, adds later one, so whichever of two loads last owns `DustBunny`, `Dust`, `GatherDust`, `MakeDustBunny`, other's version gone. Owner is mod last in mod list, nothing in log or game says so.

**Why it matters.** Every `defName` unchanged - `DustBunny`, `Dust`, `GatherDust`, `MakeDustBunny` and rest - so declaration only thing between player and def changing under them without a word. Whether still true worth looking at. Never run colony you care about with both enabled.

---

## What is still not covered

- **Null-doer guard.** `if (billDoer == null || !billDoer.Spawned) return;` cannot be reached from play: nothing in vanilla completes bill with unspawned doer. There because cost of being wrong is null map handed straight to `GenSpawn`, not because seen to happen.
- **`Rot4.Random`.** Scenario 4 says "a random direction", and with rotated-looking sprite in every direction nothing to observe. Take it on code's word.
- **Archonexus count and reward minimum.** `allowedArchonexusCount` 80 and `minRewardCount` 100 need very particular quest or map transfer to show. Left alone.