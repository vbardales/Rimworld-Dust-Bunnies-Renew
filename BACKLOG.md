# Backlog

Work decided or proposed, not done. Nothing here in published mod. Newest first.

## 1. Nocturnal Animals (Continued) - done and played green on 2026-09-25

Virginie decided 2026-09-25: **Nocturnal**. Written: extension on `DustBunny` `ThingDef` with
`MayRequire="Mlie.XNDNocturnalAnimals"` (`Mod/Defs/ThingDefs_Races/Races_DustBunny.xml`), eighth section of
`Check-Claims` (seen fail on three mutations), feature `09-nocturnal-animals` with step and pass map
`wsl-deps.avec-nocturnal.map`. Documented in `README.md`, `CHANGELOG.md`, `ATTRIBUTION.md`, `TESTING.md`.

**Played 2026-09-25 on `52f756f`, both green:** `20260925-185222-363-3128` (feature `09` with map) and `20260925-185228-539-bc21` (one scenario of bare English pass, to read startup log for class
error). They answer the one unverified thing: does 1.6 honour `MayRequire` on `modExtensions` list item. If not,
fallback is patch guarded by `PatchOperationFindMod`, which takes mod name, not packageId.
`THANKS` in description; owner posted thank-you comment for XeoNovaDan and Mlie 2026-09-28.

Reference, read 2026-09-25 from installed copy (1.6): animal opts in with
`<li Class="NocturnalAnimals.ExtendedRaceProperties"><bodyClock>Nocturnal</bodyClock></li>`; `bodyClock` is `Diurnal`,
`Nocturnal`, `Crepuscular` or `Cathemeral`; unpatched animals diurnal.

## 2. Better Crossbreeding - decided 2026-10-11: nothing (Virginie)

Dust bunny stays genderless, never mates; breeding would also be design change (genders, mating interval, way round 100 dust). Reasoning kept below. Breeding could come as 1.1.0 if she asks.

### Reasoning (2026-09-25)

Better Crossbreeding, `DizzyEevee.BetterCrossbreeding`, Workshop 3520675842, 1.6 only. Builds on 1.6 crossbreeding (`canCrossBreedWith` in `<race>`), adds `DZY.Crossbreeding.Extension` on **mother's** `PawnKindDef`, with `outcomes` list saying which kind litter or egg becomes when given father fertilises her. No other mod named
"Crossbreeding" installed on this machine.

**Why nothing happens today, by design.** Dust bunny has `hasGenders` false and `mateMtbHours` 0: never mates. Made, not bred, and recipe loop loses about 94 dust in every 100 on purpose so nobody farms dust through
bunnies. Being father or mother in crossbreed would make it breedable, opposite.

**What could be done, each a decision.**
- *Nothing.* Mod ignores dust bunny, correct while it does not breed.
- *Let another animal's litter produce dust bunny* (outcome `DustBunny` on some mother's kind): only by
  patching that other animal, from this mod, behind `PatchOperationFindMod`; gives second, free dust bunny source and bypasses 100 dust.
- *Let dust bunny be fertilised or fertilise*: needs genders and mating interval, i.e. changing animal.

Recommendation: nothing, unless Virginie wants joke outcome. If so, say which mother and father, and loss of dust cost accepted knowingly.

## 3. Automated `tested` criteria still open

French `@review` capture of bill and information dialogs (scenario 16): done, ticket `8015` on `c2f4791`, pictures read 2026-09-26, nothing to correct. "New game" half of old criterion settled: no new game created, loading save made without mod enough (Virginie, 2026-09-25). See `TESTING.md` and `STATUS.md`, `remaining`.

## 4. Before `prepublished`

Updated 2026-10-02. Done: `PUBLICATION.md` exists, description as single Markdown source (CI
syncs `About.xml` from it), Workshop links on cited mods, thank-you comments (nothing left to post, owner
posted them from another mod 2026-09-28). Open, all listed in `STATUS.md` `remaining`: gallery image 1 (scale shot does not show bunny) and images 1 to 4 into `Art/Gallery`; dated `## [1.0.0]` section in
`CHANGELOG.md`; French review by Virginie; frozen Steam description, to correct by hand.

Upstream: pull request to 2blockdude's repository open, unanswered
(<https://github.com/blockdude/csharp-rimworld-dust-bunnies/pull/1>, checked 2026-10-02: no comment, no review).

## 5. Wording: "small critters" was my gloss, not ADS 2's - fixed on 2026-09-25

Category 1 itself confirmed by Virginie (2026-09-25), knowing contents: only wording changes.

Read 2026-09-25 from ADS 2's 1.6 source (`Defs/AnimalCategories/Animal_Categories.xml`, `Patches/z_Category_Patches.xml`).
ADS 2 labels categories **1: basic replacements**, **2: 1 + simple prosthetics**, **3: 2 + bionics**. Category 1 gives
`SurgeryInstallMedievalBodyPartAnimalBase` (wooden parts: `InstallPegLegAnimal`, `InstallWoodenPawAnimal`,
`InstallWoodenHoofAnimal`, `InstallWoodenHandAnimal`, wooden foot) and `InstallDentureAnimal`. It is **broadest** list,
114 animals (Squirrel, Rat, but also cows, chickens, elephants, cats), tiers above add simple
prosthetics then bionics. So "category 1, small critters" in `README.md`, `CHANGELOG.md`, `ATTRIBUTION.md`,
`About.xml`, `Mod/Patches/ADogSaidAnimalProsthetics2.xml` and message of `Check-Claims` section 6 says something ADS 2
does not: category 1 is smallest set of surgeries, not smallest animals. Reword to "its first category, basic
replacements: a peg leg or a wooden limb, and a denture". Touches `Mod/`, so waits until no ticket in flight.

## 6. One-pixel lines along placed Dust items (found 2026-10-07, FIXED 2026-10-08)

At camera root size 4, every `Dust` item on ground shows thin vertical lines along quad edges (`drawSize` 3.0, textures
`Dust_a/b/c.png`, 256 x 256, speck in middle, no opaque pixel within 2 px of edge). Vanilla `Silver` placed same way clean, so
not Pickle tools; five `.dds` game had written not cause either (lines persist with them removed). Source
mod has same def and textures. Not changed: alters how shipped item looks in game. Candidates for owner: smaller
`drawSize` with tighter canvas, or texture re-export. Evidence: `Tests/Pickle/Evidence/2026-10-07-dust-seam` and `-dust-seam-nodds`.