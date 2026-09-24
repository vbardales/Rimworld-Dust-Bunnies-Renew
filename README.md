# Dust Bunnies Renew (unofficial)

UNOFFICIAL. This mod is published without the original author's explicit consent. If the original author contacts me to request its removal, I undertake to take it down promptly.

Port of **2blockdude's and HendraGradeWood's Dust Bunnies** to RimWorld 1.6.

**I am not the author of this mod.** The dust bunny, the artwork and the balance are theirs — all
I did was the work needed to make it run on 1.6, repair what the port turned up, and write the
French. Credit goes to them; mistakes in the port are mine.

Original mod: https://steamcommunity.com/sharedfiles/filedetails/?id=2659958183 — declares 1.1,
1.2 and 1.3 and nothing further. Its repository,
[blockdude/csharp-rimworld-dust-bunnies](https://github.com/blockdude/csharp-rimworld-dust-bunnies),
was last pushed on 2021-11-21. The page is still online; the mod is abandoned, not withdrawn.

## What the mod does

Sweep dust off the floor, pile up a hundred of it, and craft a live dust bunny. Two recipes at the
crafting spot, one resource, one animal — seven defs, four texture images, one C# class. No DLC, no
dependencies.

| recipe | work | in | out |
|---|---|---|---|
| gather dust | 250 | nothing | 10 dust |
| make a dust bunny | 800 | 100 dust | a live, tame dust bunny on the spot |

`MakeDustBunny` declares **no products**. That is the whole trick: a `RecipeWorker` spawns a pawn
when the iteration completes, instead of an item being dropped and hauled. It comes out tame
because it is made rather than caught — the recipe worker gives it the crafter's faction.

The animal:

| | |
|---|---|
| body size | 0.2 in the def, 0.04 in play: the only life stage is `AnimalBaby`, whose factor is 0.2 |
| move speed | 6.0 |
| market value | 10 |
| comfortable to | −55 °C |
| food | kibble, but `baseHungerRate` is 0 — it never eats |
| trainability | Advanced |
| wildness | 0.1 |
| life expectancy | 1 year |
| genders | none |
| leather | `Dust`, 50 in the def and about 6 in the hand — see below |

It never turns manhunter, on damage or on a failed taming. Traders carry it (`AnimalCommon`).

Dust is a **stuff**: `Fabric` category, `Flammability` 1.0 and 3 % of normal hit points. You can
build and tailor with it, and you should not. Its cold insulation is **0.9**, against cloth's 18
and a vanilla floor of 2.5 — the worst insulator of any material a garment can be made from, by a
factor of nearly three under the lowest one. Only the six stone-block stuffs state none, and they
are Stony, which no garment accepts. Its heat insulation is 0. It is very cheap, and it deteriorates half as
fast as cloth rather than faster (`DeteriorationRate` 2 against 4).

The 50 in the table above is the `LeatherAmount` stat base, not the yield. `StatPart_BodySize`
scales it by the body size of the living animal, and that is 0.2 times its life stage's factor of
0.2, so 0.04: 2 before the stat's `postProcessCurve`, about **6** after it, before difficulty and the
carefully-slaughtered factor. The information card of the *def* says about 18, because it has no
life stage and uses the base 0.2; the animal says about 6, and the animal is what is butchered. So
the loop does not close: a hundred dust makes one bunny, and the bunny gives about a sixteenth of it
back.

Available in English and French.

### A Dog Said... Animal Prosthetics 2

Optional and native: the mod enrols the dust bunny itself, so nobody needs a separate patch mod.
`Mod/Patches/ADogSaidAnimalProsthetics2.xml` adds `DustBunny` to the `recipeUsers` of `ADS_Cat1`, the abstract
recipe ADS 2 uses for **category 1, small critters**: a peg leg or a denture, nothing more. It is not in
categories 2 and 3 on purpose. It is trainable, but it is a clump of lint of body size 0.04 in play, and a
bionic arm on it would not be the joke.

Two things make it work, and both are in the files rather than in a note:

- **The patch is conditional.** It is a `PatchOperationConditional` on `ADS_Cat1`, a def that exists only when
  ADS 2 is loaded, with no `<nomatch>`: without ADS 2 it selects nothing and reports success without a line in
  the log. `MayRequire` on the operation would not do this, because nothing reads that attribute there.
- **The order is declared.** ADS 2 copies its category lists once, in its own last patch, so an `<li>` added
  after that lands in a list nobody reads any more. `About.xml` says `loadBefore`
  `SamBucher.ADogSaidAnimalProsthetics2`, which is not a dependency: nothing is required and nothing changes
  without it.

`_tools/checks/Check-Claims.ps1` asserts both, and was seen to fail on nine mutations of the patch and the About.
Whether the surgeries actually appear on a living dust bunny is a running-game fact, and is not yet tested: it
needs ADS 2 mounted, which is a pass of its own in `TESTING.md`.

Content mod: removing it mid-save destroys any dust bunny already in the colony.

## What changed in the 1.6 port

### The part that needed checking rather than compiling

The mod's whole assembly is one class, `DustBunnies.Recipe_SpawnDustBunny`: a `RecipeWorker`
overriding `Notify_IterationCompleted` to call `PawnGenerator.GeneratePawn` and `GenSpawn.Spawn`.

That is exactly the shape of thing that a blind recompile gets wrong quietly. **A `RecipeWorker`
whose signature has moved does not fail at load.** Nothing touches it until a colonist finishes
the bill, so the mod would start, list both recipes, let you queue them, and throw the first time
somebody actually made a dust bunny — hours into a colony.

So the 1.3 assembly was decompiled and every game call it makes was checked against 1.6 by
reflection before a line was written:

| call | 1.6 |
|---|---|
| `RecipeWorker.Notify_IterationCompleted(Pawn, List<Thing>)` | unchanged |
| `PawnGenerator.GeneratePawn(PawnKindDef, Faction)` | gained an optional third parameter, `PlanetTile? tile` |
| `GenSpawn.Spawn(Thing, IntVec3, Map, Rot4, …)` | gained an optional seventh, `forbidLeavings` |

Both additions are optional. The call site holds too:
`Toils_Recipe.FinishRecipeAndStartStoringProduct` still calls
`curJob.bill.Notify_IterationCompleted(actor, ingredients)`, and `Bill_Production` still forwards
that to `recipe.Worker` — after the ingredients are consumed, before the job ends, with the doer
standing on the crafting spot.

Nothing had to change. Worth saying plainly: the answer to the risky question was *no breakage*.

A productless recipe was checked as well, since it is unusual enough to be worth doubting.
`RecipeWorkerCounter.CanCountProducts` returns false when `products` is null, and
`BillRepeatModeUtility` refuses "do until you have X" with a message rather than indexing
`products[0]`. So the bill dialog cannot be talked into a null reference.

### Wildness became a stat

```xml
<race>
  <wildness>0.1</wildness>   <!-- 1.3 -->
</race>
```

Wildness is no longer a field of `RaceProperties`; it is the `Wildness` `StatDef`. RimWorld does
not stop for an XML element that matches no field — it logs one line and carries on with the field
unset. The stat's `defaultBaseValue` is `-1` (Core's comment: *"so we can catch missing wildness
stats on animals"*), its `minValue` is `0`, and `StatWorker` clamps, so a dust bunny left in the
old form would have come out at 0 — perfectly tame instead of very slightly wild — and the line
would have vanished from its information card, `Wildness` declaring `showIfUndefined` false.

It is now `<Wildness>0.1</Wildness>` under `statBases`.

### The def lookup left the static field initialiser

```csharp
public static PawnKindDef Pawn_DustBunny = DefDatabase<PawnKindDef>.GetNamed("DustBunny", true);
```

An inline static field initialiser runs when the CLR first touches the type, which is not a moment
the mod chooses. It happened to work — `RecipeDef.Worker` is lazy, and by the time a bill runs the
database is long since built — but a failure there arrives as a `TypeInitializationException` with
the real cause two levels down, and the field never rebinds if the database is reloaded. It is a
`[DefOf]` class now, which `DefOfHelper.RebindAllDefOfs` binds at the right time and again after
any reload.

### Housekeeping

- Two English jobStrings fixed: `Gathering Dust.` → `Gathering dust.`, `Making Dust Bunny.` →
  `Making a dust bunny.`
- A commented-out `VG_DigSoil_Bulk` recipe dropped from the recipe file — it names
  `VG_PileofDirt` and `VG_DiggingSpot`, defs from another mod entirely, left over from whatever
  template the file was started from.
- An empty `<race>` element dropped from the concrete `DustBunny`, its only content a
  commented-out `<useMeatFrom>Hare</useMeatFrom>`.
- The three version folders collapsed into one. The mod declared its content under `1.1/`, `1.2/`
  and `1.3/` with no `LoadFolders.xml`; the XML in all three is byte-identical, only the assembly
  differed.

### What did not change

Every stat, tool, litter curve, life stage, draw size, sound and trade tag; both recipes' costs
and work amounts; the four texture images. Including the parts that look like oversights and are not a
port's to decide: `baseHungerRate` 0, `lifeExpectancy` 1, a `litterSizeCurve` and a
`gestationPeriodDays` that never apply because `mateMtbHours` is 0, and an `ecoSystemWeight` on an
animal that belongs to no biome and can only be crafted.

## The defNames were kept

`Dust` carries no author prefix, which is exactly the kind of name that collides, so it was
checked rather than assumed:

- **Core and every DLC** — nothing defines `Dust`, `DustBunny`, `GatherDust` or `MakeDustBunny`,
  and nothing declares `BaseDustBunny` or `DustBunnyBase` as an abstract `Name`.
- **All 10 352 subscribed Workshop mods** — one hit, and it is not a collision. *Allergies*
  (`phil42.allergies`) declares a `P42_Allergies.AllergyDef` named `Dust`; `DefDatabase` is
  generic per def type, so an `AllergyDef` and a `ThingDef` may share a name freely. Every other
  hit is the source mod's own three version folders.
- **Other mods in the former monorepo (historical scan)** — nothing. This repository now contains only this mod.

No collision, so no rename. A rename is permanent in a way a port is not.

## Five files, four images

`Textures/DustBunny/Bunny/Dust_Bunny_east.png` and
`Textures/DustBunny/Bunny/Dessicated_Dust_Bunny.png` are the same 256×256 file, identical by MD5.
So a dead, dessicated dust bunny is drawn exactly like a living one — which for a clump of dust is
arguably right, and is in any case theirs to decide. Recorded, not repainted.

The bunny sprite also ships only its `_east` face. `Graphic_Multi` does not fail on that: with no
`_north` it takes the east texture and sets `drawRotatedExtraAngleOffset` to −90°, then derives
the remaining faces. So the bunny is drawn rotated rather than missing, which is how it has looked
since 2021.

## Repository layout

```
DustBunniesRenew/
  Mod/      <- what goes on the Workshop; the NTFS junction into RimWorld/Mods points here
  Source/   <- C#, never published
  Art/      <- originals, Preview HTML/palette/renderer and visual QA, never published
  _tools/   <- validation scripts and functional scenarios, never published
```

`Source/Directory.Build.props` sends build intermediates to `../.build/`. That is not
housekeeping: RimWorld's uploader calls `SteamUGC.SetItemContent` on the mod's root directory with
no filtering, so an `obj/` left inside `Mod/` would publish the publicised `Assembly-CSharp.dll` —
about 6 MB of the game's own code — to every subscriber.

## Building

```bash
dotnet build Source/DustBunnies.csproj -c Release
```

The assembly lands in `Mod/Assemblies/`. References come from NuGet (`Krafs.Rimworld.Ref`), so no
RimWorld installation is needed to compile. No Harmony: the mod patches nothing.

## Verification

Run the repository-local suite (PowerShell 7, .NET SDK and RimWorld 1.6 required):

```powershell
pwsh -NoProfile -File _tools/Test-Mod.ps1
# For another game installation:
pwsh -NoProfile -File _tools/Test-Mod.ps1 -GameRoot 'D:\Games\RimWorld'
```

It builds the DLL, parses all mod XML, checks fields and def references against the game,
checks French injection paths and XML class names, and verifies the compiled recipe override.
The checkers live in `_tools/checks/`; no monorepo or sibling scripts are required.
`-SkipBuild` checks the existing DLL only. These checks do not execute pawn spawning.

See [_tools/FUNCTIONAL-SCENARIOS.md](_tools/FUNCTIONAL-SCENARIOS.md) for the 18 manual
in-game scenarios, and [STATUS.md](STATUS.md) for the latest verified results and limitations.

## Credits

- **2blockdude** and **HendraGradeWood** — the dust bunny, the dust, the artwork, the balance, the
  original mod.

See [ATTRIBUTION.md](ATTRIBUTION.md) for the licence position and what exactly was carried over.

The port work was done with the help of an AI assistant (Claude, by Anthropic), under human direction. In-game validation of this port is pending.
