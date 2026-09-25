# Backlog

Work that is decided or proposed and not done. Nothing here is in the published mod. Newest first.

## 1. Nocturnal Animals (Continued) — feasible, one decision needed

[XND] Nocturnal Animals (Continued), `Mlie.XNDNocturnalAnimals`, Workshop 2269731409 (continuation of XeoNovaDan's
2004368312). Read on 2026-09-25 from the installed copy, which declares 1.6.

**How it works.** An animal opts in with a mod extension on its `ThingDef`, and without one it is diurnal, the vanilla
behaviour. The mod's own patches are of this form:

```xml
<li Class="NocturnalAnimals.ExtendedRaceProperties"><bodyClock>Nocturnal</bodyClock></li>
```

`bodyClock` is `Diurnal`, `Nocturnal`, `Crepuscular` or `Cathemeral`. The information card shows it.

**What it would take here.** One line under `modExtensions` of the dust bunny's `ThingDef`, carrying
`MayRequire="Mlie.XNDNocturnalAnimals"` so that nothing is read, and no error logged, without the mod. That is not a
dependency and needs no `loadBefore`. **Not verified:** that 1.6 honours `MayRequire` on a `modExtensions` list item, as
it does on other list items; a patch guarded by `PatchOperationFindMod` (which takes the mod's name, not its packageId)
is the fallback, and `MayRequire` on an `Operation` is read by nothing.

**Decision needed from Virginie: which clock?** It changes nothing until the mod is loaded, then it changes when a
dust bunny sleeps. `Nocturnal` suits the animal (they come out when nobody is looking) but is a choice of taste, not a
fix. `Cathemeral` is the neutral one, and leaving it out keeps it diurnal.

**Tests it needs.** A pass map naming the mod (Workshop 2269731409) and a scenario that reads the extension's
`bodyClock` on the dust bunny, plus the offline check that the extension carries `MayRequire`. The pass without the mod
must stay silent (`no errors were logged`). Credit: the author (XeoNovaDan, and Mlie for the continuation) goes in
`THANKS`, with a Workshop link, and the mod is added to the register of thank-you comments (PUBLISHING.md).

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
