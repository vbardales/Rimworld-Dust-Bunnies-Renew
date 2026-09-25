# Backlog

Work that is decided or proposed and not done. Nothing here is in the published mod. Newest first.

## 1. Nocturnal Animals (Continued) — done in the tree on 2026-09-25, not yet played in the game

Decided by Virginie on 2026-09-25: **Nocturnal**. Written: the extension on the `DustBunny` `ThingDef` with
`MayRequire="Mlie.XNDNocturnalAnimals"` (`Mod/Defs/ThingDefs_Races/Races_DustBunny.xml`), an eighth section of
`Check-Claims` (seen to fail on three mutations), feature `09-nocturnal-animals` with its step and the pass map
`wsl-deps.avec-nocturnal.map`. Documented in `README.md`, `CHANGELOG.md`, `ATTRIBUTION.md`, `TESTING.md`.

**Filed on 2026-09-25 on `52f756f`:** `20260925-185222-363-3128` (feature `09` with the map) and `20260925-185228-539-bc21` (one scenario of the bare English pass, to read the startup log for a class
error). They answer the one thing not verified, that 1.6 honours `MayRequire` on a `modExtensions` list item. If it
does not, the fallback is a patch guarded by `PatchOperationFindMod`, which takes the mod's name, not its packageId.
`THANKS` and a thank-you comment for XeoNovaDan and Mlie are due at `prepublished` (PUBLISHING.md).

Reference, read on 2026-09-25 from the installed copy (1.6): an animal opts in with
`<li Class="NocturnalAnimals.ExtendedRaceProperties"><bodyClock>Nocturnal</bodyClock></li>`; `bodyClock` is `Diurnal`,
`Nocturnal`, `Crepuscular` or `Cathemeral`; unpatched animals are diurnal.

## 2. Better Crossbreeding — feasible, but it is a design change, not a compatibility

Better Crossbreeding, `DizzyEevee.BetterCrossbreeding`, Workshop 3520675842, 1.6 only. It builds on the crossbreeding of
1.6 (`canCrossBreedWith` in `<race>`) and adds a `DZY.Crossbreeding.Extension` on the **mother's** `PawnKindDef`, with an
`outcomes` list saying which kind a litter or egg becomes when a given father fertilises her. No other mod named
"Crossbreeding" is installed on this machine.

**Why nothing happens today, by design.** The dust bunny has `hasGenders` false and `mateMtbHours` 0: it never mates. It
is made, not bred, and the recipe loop loses about 94 dust in every 100 on purpose so that nobody farms dust through
bunnies. Being a father or a mother in a crossbreed would make it breedable, which is the opposite.

**What could be done, and each one is a decision.**
- *Nothing.* The mod ignores the dust bunny, which is correct while it does not breed.
- *Let another animal's litter produce a dust bunny* (an outcome `DustBunny` on some mother's kind): possible only by
  patching that other animal, from this mod, behind a `PatchOperationFindMod`; it gives a second, free source of dust
  bunnies and bypasses the 100 dust.
- *Let a dust bunny be fertilised or fertilise*: needs genders and a mating interval, that is, changing the animal.

Recommendation: nothing, unless Virginie wants a joke outcome. If she does, say which mother and which father, and the
loss of the dust cost is accepted knowingly.

## 3. Automated `tested` criteria still open

A French `@review` capture of the bill and information dialogs (scenario 16), and a new colony beside the existing save,
with PickleTools' NewColony companion. **A new colony is not repeatable, so it is used sparingly**: one scenario, in a pass of its own, played once on the revision to be tested (Virginie, 2026-09-25). See `TESTING.md` and `STATUS.md`, `remaining`.

## 4. Before `prepublished`

`PUBLICATION.md`; a description with the sections AUDIT.md lists and Workshop links on the cited mods; correct
`About.xml` ("In-game validation of this port is pending"). See `docs/PROTOCOLS-READ.md`.

## 5. Wording: "small critters" is my gloss, not ADS 2's — to fix after the two Nocturnal tickets return

Category 1 itself is confirmed by Virginie (2026-09-25), knowing what it contains: only the wording changes.

Read on 2026-09-25 from ADS 2's 1.6 source (`Defs/AnimalCategories/Animal_Categories.xml`, `Patches/z_Category_Patches.xml`).
ADS 2 labels its categories **1: basic replacements**, **2: 1 + simple prosthetics**, **3: 2 + bionics**. Category 1 gives
`SurgeryInstallMedievalBodyPartAnimalBase` (the wooden parts: `InstallPegLegAnimal`, `InstallWoodenPawAnimal`,
`InstallWoodenHoofAnimal`, `InstallWoodenHandAnimal`, a wooden foot) and `InstallDentureAnimal`. It is the **broadest** list,
114 animals in it (a Squirrel, a Rat, but also cows, chickens, elephants and cats), and the tiers above it add the simple
prosthetics and then the bionics. So "category 1, small critters" in `README.md`, `CHANGELOG.md`, `ATTRIBUTION.md`,
`About.xml`, `Mod/Patches/ADogSaidAnimalProsthetics2.xml` and the message of `Check-Claims` section 6 says something ADS 2
does not: category 1 is the smallest set of surgeries, not the smallest animals. Reword to "its first category, basic
replacements: a peg leg or a wooden limb, and a denture". Touches `Mod/`, so it waits until no ticket is in flight.
