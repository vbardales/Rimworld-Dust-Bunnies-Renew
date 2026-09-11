# Changelog

All notable changes to this mod are documented here.

## [1.0.0] — 2026-09-05

First release. Port of 2blockdude's and HendraGradeWood's **Dust Bunnies** to RimWorld 1.6.

### Fixed

- `BaseDustBunny`: `<wildness>0.1</wildness>` under `<race>` replaced by `<Wildness>0.1</Wildness>`
  under `<statBases>`. Wildness stopped being a field of `RaceProperties` and became a `StatDef`;
  the old element matches no field, so the loader logs one line and carries on with it unset. The
  stat's `defaultBaseValue` is `-1`, its `minValue` is `0` and `StatWorker` clamps, so the animal
  would have come out perfectly tame instead of very slightly wild — and the line would have
  disappeared from its information card, `Wildness` declaring `showIfUndefined` false.
- `Recipe_SpawnDustBunny`: the target `PawnKindDef` moved out of an inline static field
  initialiser (`DefDatabase<PawnKindDef>.GetNamed("DustBunny", true)`) into a `[DefOf]` class. A
  static initialiser runs whenever the CLR first touches the type, at a moment the mod does not
  choose; a failure there arrives as a `TypeInitializationException` with the real cause two
  levels down, and the field never rebinds if the def database is reloaded. `DefOfHelper`
  rebinds a `[DefOf]` at the right time and again after any reload.
- `Recipe_SpawnDustBunny`: returns early when the bill doer is null or unspawned. Nothing in
  vanilla calls it that way, but the alternative is a null `Map` passed straight to `GenSpawn`.
- English: `Gathering Dust.` → `Gathering dust.` and `Making Dust Bunny.` → `Making a dust bunny.`
  Vanilla writes jobStrings as ordinary sentences, and English is what every other language falls
  back to.

### Verified against 1.6 rather than recompiled blind

A `RecipeWorker` whose signature has moved does not fail at load — nothing touches it until a
colonist finishes the bill — so the whole mod would have started, shown both recipes, and thrown
the first time anyone actually made a dust bunny. The 1.3 assembly was decompiled and every game
call it makes was checked by reflection before the C# was rewritten:

- `RecipeWorker.Notify_IterationCompleted(Pawn, List<Thing>)` — unchanged.
- `PawnGenerator.GeneratePawn(PawnKindDef, Faction)` — gained an optional `PlanetTile? tile`.
- `GenSpawn.Spawn(Thing, IntVec3, Map, Rot4, …)` — gained an optional `forbidLeavings`.
- `Toils_Recipe.FinishRecipeAndStartStoringProduct` still routes through
  `Bill_Production.Notify_IterationCompleted` to `recipe.Worker`, after the ingredients are
  consumed and before the job ends.

Nothing had to change. The explicit `WipeMode.Vanish` and `respawningAfterLoad: false` are now
left implicit, being the defaults.

`MakeDustBunny` declaring no `<products>` was checked too:
`RecipeWorkerCounter.CanCountProducts` returns false when `products` is null, so
`BillRepeatModeUtility` refuses "do until you have X" with a message instead of indexing
`products[0]`.

### Changed

- `packageId` changed from `BlockHen.Animal.DustBunnies` to `nelim.dustbunniesrenew`.
- `<supportedVersions>` set to 1.6.
- The `1.1/`, `1.2/` and `1.3/` version folders collapsed to one copy at the root. The mod
  declared its content in per-version directories with no `LoadFolders.xml`; the XML in all three
  was byte-identical, only the assembly differing.
- `About/PublishedFileId.txt` dropped: it names 2blockdude's and HendraGradeWood's Workshop item.

### Added

- `Languages/French/`, 12 keys. The animal is a *mouton de poussière* — the actual French term,
  and it keeps the joke, a *mouton* being both the dust under the bed and the animal in the field.
- `<incompatibleWith>BlockHen.Animal.DustBunnies</incompatibleWith>`: the `defName`s are
  unchanged, so the two cannot load together.
- `About/ModIcon.png` and `About/Preview.png`, both made for this port and neither derived from
  the original art. The icon is the repository's mascot, recoloured grey because the creature is:
  here the mascot's head *is* the dust bunny rather than holding it, since a second grey round mass
  beside the head would merge with it at the 32 pixels the icon is actually drawn at. The showcase
  is a workshop floor at 896×504 — the swept heaps in the cold half, the creature in the lantern
  pool, because grey on grey on brown has no colour left to separate it with and only light will
  do. Full-resolution originals under `Art/`, and the page that engraves the title in
  `_tools/preview.html`.

### Removed

- A commented-out `VG_DigSoil_Bulk` recipe in `Recipes_DustBunny.xml`, referring to
  `VG_PileofDirt` and `VG_DiggingSpot` — defs from another mod entirely, left over from the
  template the file was started from.
- An empty `<race>` element on the concrete `DustBunny` `ThingDef` whose only content was a
  commented-out `<useMeatFrom>Hare</useMeatFrom>`.
- `About/ModIcon.png`, which was the opaque 91×83 of the mod's own bunny sprite squared around its
  centre and scaled to 128 px, and `Art/Make-ModIcon.ps1`, the script that cut it. Two rules reach
  the crop, and either would be enough. An icon cut from the source mod is the source authors' art
  standing in for the identity of the port, and the identity is the one thing a port should carry
  itself. And the repository's icon style is a round winking mascot, which a detoured grey bunny is
  not. See **Added** for what ships instead.
- `About/Preview.png` as it shipped in 2021, which was not a showcase but the bunny sprite itself —
  the same 256×256 file as `Dust_Bunny_east.png`, down to the MD5, transparent inside a square.
  The Workshop page would have shown a 91-pixel bunny on whatever colour the reader's Steam client
  paints behind it.

### Unchanged

- Every stat, tool, litter curve, life stage, draw size, sound and trade tag; both recipes' costs
  and work amounts; the four texture images.
- The balance, including the parts that look like oversights and are not the port's to decide:
  `baseHungerRate` 0, `lifeExpectancy` 1, `mateMtbHours` 0 alongside a `litterSizeCurve` and a
  `gestationPeriodDays` that therefore never apply, and `ecoSystemWeight` on an animal that
  belongs to no biome.
- All six `defName`s. Checked against Core, every DLC, all 10 352 subscribed Workshop mods and
  this repository: the only hit is an `AllergyDef` named `Dust` in *Allergies*
  (`phil42.allergies`), which is a different def type and so a different `DefDatabase`.
- The five files under `Textures/`, 2blockdude's and HendraGradeWood's own — `Dust_Bunny_east.png`
  and `Dessicated_Dust_Bunny.png` byte-identical to each other, which is how the mod shipped. A
  dead dust bunny is drawn exactly like a live one, and for a clump of dust that is arguably right.
