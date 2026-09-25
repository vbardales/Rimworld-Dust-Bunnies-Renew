# Backlog

Work that is decided or proposed and not done. Nothing here is in the published mod. Newest first.

## 1. Nocturnal Animals (Continued) — done in the tree on 2026-09-25, not yet played in the game

Decided by Virginie on 2026-09-25: **Nocturnal**. Written: the extension on the `DustBunny` `ThingDef` with
`MayRequire="Mlie.XNDNocturnalAnimals"` (`Mod/Defs/ThingDefs_Races/Races_DustBunny.xml`), an eighth section of
`Check-Claims` (seen to fail on three mutations), feature `09-nocturnal-animals` with its step and the pass map
`wsl-deps.avec-nocturnal.map`. Documented in `README.md`, `CHANGELOG.md`, `ATTRIBUTION.md`, `TESTING.md`.

**Still open:** the two tickets (feature `09` with the map, and the bare English pass to read the startup log for a class
error), and the answer to the one thing not verified, that 1.6 honours `MayRequire` on a `modExtensions` list item. If it
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
with PickleTools' NewColony companion. See `STATUS.md`, `remaining`.

## 4. Before `prepublished`

`PUBLICATION.md`; a description with the sections AUDIT.md lists and Workshop links on the cited mods; correct
`About.xml` ("In-game validation of this port is pending"). See `docs/PROTOCOLS-READ.md`.
