# Functional scenarios, to be played in game

No in-game run of this port is recorded. All 18 scenarios below are **NOT RUN**.
Record date, RimWorld version, active DLC/mods, scenario ID, PASS/FAIL, observations and
Player.log location after each run; update STATUS.md with the outcome.

The automated suite is `pwsh -NoProfile -File _tools/Test-Mod.ps1`. It checks XML and the
compiled API hook, but cannot prove that completing a bill spawns a pawn. Scenario 4 is
therefore the first functional priority after loading. Expected results below are hypotheses
to verify in RimWorld, not evidence that the tests passed.

Where each scenario is planned to go — a Pickle feature, an offline assertion, or not applicable with
its reason — is in [`../TESTING.md`](../TESTING.md).

**Setup for everything below.** Development mode on. A small colony with a **crafting spot** and
one colonist whose Crafting is enabled and not disabled by a trait. Time controls at 3x for the
slow ones. Most scenarios read either the bill dialog on the crafting spot or the animal's
information card, the `i` tab, where wildness, comfortable temperature and leather amount all sit.

Every quantity below is the value in the def, so a mismatch is a finding either way: either the
game no longer reads that field, or the def was changed and this file was not. The exception is
anything that depends on the animal's life stage, which a def does not have: see scenario 11.

---

## 0. It loads, and the worker class resolved

**Do.** Start the game with the mod active. Load any save. Open the bill dialog on a crafting spot.

**Expect.** No red text at startup. Both recipes present.

**Watch for in `Player.log`.** Three lines, each a different failure, and one silence:

- `Could not find type named` naming `DustBunnies.Recipe_SpawnDustBunny` — the assembly did not
  load, or the namespace moved. This is the dangerous one, because a `workerClass` that fails to
  resolve does **not** kill the def: the field is left null and the recipe works in every visible
  way except the one that matters. See scenario 4, which is the only place it shows.
- `Failed to find PawnKindDef named DustBunny. There are` — the `[DefOf]` did not bind. The race
  file did not load, or the defName changed on one side only.
- `Tried to use an uninitialized DefOf of type` — something touched `DustBunniesDefOf` before the
  database was complete. The port exists partly to make this impossible; if it comes back, the
  static initialiser has crept back in.
- **No line at all** is what the original mod loaded alongside this one looks like, which is why it
  is not a line to watch for. `DefDatabase.AddAllInMods` removes the earlier def of a name and adds
  the later one without saying so; the `Adding duplicate` error in `Add` sits on a path that call
  never takes, and only a clash inside one mod is reported. `About.xml` declares
  `<incompatibleWith>BlockHen.Animal.DustBunnies`; see scenario 17.

**If it fails here, stop.** Everything below assumes the recipes and the def are live.

---

## 1. The two recipes are on the crafting spot, and nowhere else

**Do.** Open the bill dialog on a crafting spot. Then on a tailoring bench, a smithy and a
fuelled stove.

**Expect.** *Gather dust* and *Make a dust bunny* on the crafting spot only. Nothing added
anywhere else.

**Why it matters.** Both declare `recipeUsers` rather than being attached through the bench's own
recipe list. A recipe that turns up on every bench means something else in the load order is
merging lists.

## 2. Gathering dust costs nothing but time

**Do.** Queue *Gather dust* with no dust and no other resource anywhere on the map. Watch it run.

**Expect.** It runs. 250 ticks of work, and 10 dust drop on the spot. No ingredient was consumed,
because the recipe declares none: the dust comes off the floor.

**Then.** Watch the colonist's Crafting experience over five iterations.

**Expect.** Almost nothing. `workSkillLearnFactor` is 0.001, which is the guard against an
infinite free bill being an infinite free skill.

## 3. Dust is a real stuff, and a uselessly bad one

**Do.** Gather 200 dust. Open the build menu and place a wall, then a tailoring bill for a parka.

**Expect.** Dust appears in the material list for both, under **Fabric**. The parka comes out
**pale blue**, not grey — `stuffProps` sets the colour to (174, 219, 228), which is the one place
this mod's art and its numbers disagree, and it is theirs.

**Then.** Read the parka's stats, next to the same parka in cloth. Every one of these is worse,
and most of them are worse by an order of magnitude:

| | Dust | Cloth | Vanilla floor |
|---|---|---|---|
| Cold insulation | 0.9 | 18 | 2.5 |
| Heat insulation | 0 | 18 | — |
| Sharp armour | 0.002 | 0.36 | — |
| Hit points factor | 0.03 | 1 | — |

**Dust is the worst insulator of any material a garment can be made from**, by a factor of nearly
three under the lowest vanilla one. Only the six stone-block stuffs state no cold insulation at all,
and they are Stony, which no garment accepts. A parka made of dust is not a parka. That is almost certainly the joke rather than
an oversight — the stuff is swept off the floor and costs nothing — and it is theirs either way.

**It is also the one claim `About.xml` used to get wrong.** The description called dust *warm*
until 2026-09-12, which these numbers say plainly it is not.

**Then.** Leave 100 dust outdoors for a day, and separately drop one incendiary near a pile.

**Expect.** It burns readily — `Flammability` 1.0, the same as wood. But it deteriorates **half as
fast as cloth**, not faster: `DeteriorationRate` is 2 against cloth's 4. Dust outdoors outlasts
clothing outdoors, which is funnier than it is useful.

---

## 4. The bill that makes an animal

**This is the scenario the mod exists for.** Everything above would pass with the worker class
broken.

**Do.** With 100 dust in a stockpile, queue *Make a dust bunny* on the crafting spot. Watch the
colonist through the whole bill.

**Expect.** 100 dust consumed. 800 ticks of work. At the moment the bill completes, **a live dust
bunny appears on the crafting spot itself**, at the colonist's own position, facing a random
direction. No item drops, because the recipe declares no products.

**How it fails.** The dust is consumed, the work is done, the job ends, and nothing appears. That
is the null `workerClass` of scenario 0, and this is the only place it is visible.

**Why it matters.** `Notify_IterationCompleted` is called from
`Toils_Recipe.FinishRecipeAndStartStoringProduct`, through `Bill_Production`, after ingredients are
gone and before the job ends. The colonist standing on the spot at that instant is what gives the
bunny its position and its faction. If the bunny appears somewhere else on the map, that call site
has moved.

## 5. It is tame the moment it exists

**Do.** Click the new bunny immediately, without saving or reloading.

**Expect.** It belongs to the colony. It has a name-less "dust bunny" label with the colony's
colour, it can be renamed, and it appears in the Animals tab. It was never wild and was never
tamed: it is made, so it takes the faction of whoever made it.

**How it fails.** A bunny that spawns wild means `billDoer.Faction` came through null — which
happens if the bill was somehow done by a pawn with no faction.

**Then.** Save, quit to the main menu and reload. Confirm the bunny still belongs to the colony, dust stacks and queued bills persist, and no new mod errors appear in Player.log.

## 6. Wildness reads 10%, not 0%

**Do.** Open the bunny's information card.

**Expect.** **Wildness 10%.**

**Why it matters.** This is the port's first correction and the only one with a visible number.
Wildness stopped being a field of `RaceProperties` and became a `StatDef`; the old element matched
no field, and RimWorld does not stop for an element that matches nothing — it logs one line and
carries on with the value unset. The stat's default is −1, clamped to 0. So a bunny left in the
old form would read **0%** here, or show nothing at all, `Wildness` declaring `showIfUndefined`
false. 0% is not a small error: it is a perfectly tame animal where a slightly wild one was
intended, and it changes how fast training decays.

## 7. "Do until you have" is refused, with a message

**Do.** On the *Make a dust bunny* bill, try to set the repeat mode to **Do until you have X**.

**Expect.** It is refused, and the message is
*(This recipe cannot have a target count because it has multiple or unpredictable products.)*

**Why it matters.** The recipe has no `products`, and this is the legal, handled consequence:
`RecipeWorkerCounter.CanCountProducts` returns false, so `BillRepeatModeUtility` says so instead
of indexing a product list that does not exist. *Do X times* and *Do forever* must both still
work.

---

## 8. It never eats

**Do.** Leave a bunny alone for three game days with no food anywhere it can reach.

**Expect.** No **Food** bar on its needs, at any point, and no starvation. `baseHungerRate` is 0.

**Why it matters.** This is deliberate in the original and it is the reason the animal is not a
liability. If a Food bar appears, the need is being created from the food type rather than the
hunger rate, and a colony of these would starve.

## 9. It trains, up to Advanced

**Do.** Open the bunny's **Training** tab.

**Expect.** Obedience, Release, Rescue and Haul all offered. `trainability` is Advanced.

**Watch for.** An absent or empty tab. The most likely reason is the life stage: the race declares
exactly one, `AnimalBaby` at minimum age 0, so a dust bunny is **permanently a baby** and never
becomes an adult. That is how the mod shipped and it is not the port's to change, but it is the
first thing to check if training, breeding or hauling behave unlike any other animal.

## 10. It survives a winter outdoors

**Do.** Put a bunny outside in a cold biome, or use development mode to drop the temperature.
Read the information card.

**Expect.** **Comfortable temperature minimum −55 °C**, and no hypothermia above it. That is the
concrete def overriding the abstract base's −30.

## 11. Butchering it gives dust back, and no meat

**Do.** Kill a bunny and butcher the corpse at a butcher table.

**Expect.** Dust, and nothing else. `MeatAmount` is 0, `leatherDef` is Dust.

**Expect about 6 dust, not 50 and not 18.** The def sets `LeatherAmount` to 50, but that is the
stat's base value and not the yield. `StatPart_BodySize` scales it by the body size of the living
animal, which is 0.2 times its life stage's factor of 0.2, so 0.04. That makes 2, and the stat's
`postProcessCurve` lifts it to about 5.6 before difficulty and the carefully-slaughtered factor
touch it. The butchered amount is that value rounded at random, so 5 or 6.

**Two cards, two numbers.** The information card of the *def*, opened before any bunny exists, has
no life stage and uses the base body size of 0.2, so it says about 18. The card of a living bunny
says about 6. Check the yield against the living one, never against the def's card and never
against the 50.

**Why it matters.** It sets the exchange rate of the whole mod. 100 dust in, one bunny, and about a
sixteenth of it back out — so the loop loses heavily and a colony cannot farm dust through bunnies.
`About.xml` claimed a flat 50 until 2026-09-12 and about 18 until 2026-09-24. Both ignored the life
stage, and the second was read off the def's card.

## 12. It never arrives angry, and never turns up wild

**Do.** Play, or force manhunter-pack events in development mode, for several seasons.

**Expect.** Never a dust bunny among them — `canArriveManhunter` is false. And never one on the
map at world generation or in a wildlife wave, because the race belongs to no biome, whatever
`ecoSystemWeight` says.

## 13. It never breeds

**Do.** Keep two bunnies together for a season.

**Expect.** No pregnancy, ever. `mateMtbHours` is 0, so the `litterSizeCurve` and the
`gestationPeriodDays` beside it never apply. They are dead settings and were left as found.

**Also.** No gender on either — `hasGenders` is false.

## 14. It dies of old age in about a year

**Do.** Use development mode to age a bunny past one year, or keep one for a full year.

**Expect.** The information card reports a life expectancy of 1 year. Record aging effects over time; this value is not a guaranteed death timer at the first birthday.

**Then.** Look at the corpse.

**Expect.** The dessicated corpse is drawn **exactly like a living bunny**. That is not a bug in
the port: `Dessicated_Dust_Bunny.png` and `Dust_Bunny_east.png` are the same file, identical by
MD5, and for a creature that is a clump of dust it is arguably right. Recorded, not repainted.

## 15. The sprite is always rotated

**Do.** Watch a bunny walk north, then east, then south.

**Expect.** It looks turned rather than facing where it goes, and identically so in every
direction.

**Why it matters.** Only the `_east` face ships. `Graphic_Multi` does not fail on that: with no
`_north` it takes the east texture and sets `drawRotatedExtraAngleOffset` to −90°, then derives
the rest. So this is how the mod has looked since 2021, and a bunny drawn correctly from four
angles would mean something else is supplying textures.

---

## 16. English and French translation gate

**Do.** Run this scenario first in English, then switch to French and restart. Look at
the animal and dust information cards, both recipe descriptions and bill labels,
and the colonist's job text while each recipe runs. Inspect the head and bite attack
wording, a dust-made garment's material name, and a dust bunny corpse. Try the
target-count rejection from scenario 7 in each language.

**Expect.** *mouton de poussière* for the animal, *poussière* for the resource, and both recipe
labels, descriptions and job strings in French. The head tool reads *tête*.
In English, expect *dust bunny*, *dust*, *head* and English recipe text.
The 12 owned text paths are inventoried in STATUS.md; generated material, corpse
and rejection text must also use the selected language without raw keys, accidental
English fallback, broken grammar, formatting errors or clipping.

Record separate English and French PASS/FAIL results, game version, active mods,
date and log path. Static resource checks do not count as running this scenario.

**Watch for in `Player.log`.** `Duplicate def-injected translation key` or a def-injection report
naming this mod. Either means a key is misspelled or aimed at a def that no longer exists.

## 17. The original must not load alongside

**Do.** Enable both this mod and 2blockdude's original (Workshop 2659958183), if it is still
subscribed.

**Expect.** RimWorld reports the incompatibility in the mod list, because `About.xml`
names `BlockHen.Animal.DustBunnies` in `<incompatibleWith>`. That report is the engine's, and it is
not what is being tested.

**Then, in a test colony only,** load both anyway. **Expect silence:** no error names the clash. The
game removes the earlier def of a name and adds the later one, so whichever of the two loads last
owns `DustBunny`, `Dust`, `GatherDust` and `MakeDustBunny`, and the other's version is gone. The
owner is the mod that comes last in the mod list, and nothing in the log or the game says so.

**Why it matters.** Every `defName` is unchanged — `DustBunny`, `Dust`, `GatherDust`,
`MakeDustBunny` and the rest — so the declaration is the only thing between a player and a def that
changes under them without a word. Whether it is still true is worth looking at. Never run a colony
you care about with both enabled.

---

## What is still not covered

- **The null-doer guard.** `if (billDoer == null || !billDoer.Spawned) return;` cannot be reached
  from play: nothing in vanilla completes a bill with an unspawned doer. It is there because the
  cost of being wrong is a null map handed straight to `GenSpawn`, not because it was seen to
  happen.
- **`Rot4.Random`.** Scenario 4 says "a random direction", and with a rotated-looking sprite in
  every direction there is nothing to observe. Take it on the code's word.
- **The archonexus count and the reward minimum.** `allowedArchonexusCount` 80 and
  `minRewardCount` 100 need a very particular quest or a map transfer to show. Left alone.
