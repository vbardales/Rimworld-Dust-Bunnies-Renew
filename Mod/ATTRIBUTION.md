# Dust Bunnies — attribution

A 1.6 port of **Dust Bunnies**, by **2blockdude** and **HendraGradeWood**
([2659958183](https://steamcommunity.com/sharedfiles/filedetails/?id=2659958183)).

## Status: public

The source mod is **dead** — it declares 1.1, 1.2 and 1.3 and nothing further, and its repository
was last pushed on 2021-11-21 — and **no licence is declared anywhere**, checked at the four
places one could be:

- no `LICENSE` file in the mod;
- nothing in `About.xml`, neither a field nor a sentence in the body of the description;
- nothing in the body of the description on its Steam page;
- and, because this mod does declare a `<url>`, the linked repository too —
  [blockdude/csharp-rimworld-dust-bunnies](https://github.com/blockdude/csharp-rimworld-dust-bunnies)
  reports `"license": null` and its `README.md` is four lines with no terms in them.

That fourth check is the one that gets skipped. It was skipped once on たたら製鉄, whose ban on
redistribution turned out to be a sentence in its description and nowhere else.

This is the usual convention for ports on the RimWorld Workshop: republished with **credit by
name** and **removal on request, without argument**. The `<author>` field reads
`2blockdude, HendraGradeWood - 1.6 adapted by Nelim`, and the removal clause is in the description.

## Explicit licence and visibility recheck — 2026-09-12

Decision: **mod licence classification `silent`; mod visibility classification `public`**,
under the project's PUBLISHING.md rule for abandoned sources without permission or a recorded
prohibition. The (unofficial) suffix and notice remain necessary under that rule.
This classification does not turn silence into author consent.

Evidence checked directly during this audit:

- Original installed Workshop item `2659958183`: recursive file listing has no licence file;
  its About.xml description contains only a short feature statement, with no reuse terms.
  Text searches of the installed XML/text files found no permission or prohibition.
- [Original Steam page](https://steamcommunity.com/sharedfiles/filedetails/?id=2659958183):
  the live description and all nine comments were read, including both author replies.
  They discuss gameplay and training; none grants or prohibits redistribution or continuation.
  The listed last update is November 21, 2021.
- [Original GitHub repository](https://github.com/blockdude/csharp-rimworld-dust-bunnies):
  recursive main-branch tree has no licence file; README provides author/date and a short
  feature description, with no reuse terms. The API reports `license: null` and
  `pushed_at: 2021-11-21T20:16:42Z`.
- [Port repository](https://github.com/vbardales/Rimworld-Dust-Bunnies-Renew): API confirms
  `private: false`, `visibility: public`. This is repository visibility, not a rights grant
  for the inherited mod or evidence of a published continuation on Steam.
- Local LICENSE and Mod/LICENSE are identical. Their MIT grant explicitly covers only
  the port additions, excluding the inherited original content.

Consequently, the whole mod is not `open` and not `original`. No explicit refusal was found
that would justify `forbidden`. The absence of mod updates since 2021 supports `silent`
rather than `alive`; it does not establish the authors' personal availability. No author
was contacted, no permission was obtained, and no publication or visibility change was made.

## What was carried over

Everything the mod defined — seven defs, four distinct images and one C# class. The original had no
dependency, no DLC, no research and no patch; the port adds one optional patch of its own, described
under "What changed in the port".

| def | type | what it is |
|---|---|---|
| `Dust` | `ThingDef` | the resource, on `ResourceBase`; a `Fabric` stuff |
| `GatherDust` | `RecipeDef` | 250 work at a crafting spot, no ingredients, makes 10 dust |
| `MakeDustBunny` | `RecipeDef` | 800 work, eats 100 dust, produces **no item** |
| `BaseDustBunny` | abstract `ThingDef` | the mod's own base, on `AnimalThingBase` |
| `DustBunnyBase` | abstract `PawnKindDef` | on `AnimalKindBase` |
| `DustBunny` | `ThingDef` | the animal |
| `DustBunny` | `PawnKindDef` | its spawn entry |

Its stats, tools, litter curve, life stage, sounds, trade tags and draw sizes are 2blockdude's and
HendraGradeWood's, unchanged. So are the textures, byte for byte.

**The mod ships five texture files but only four distinct images.**
`Textures/DustBunny/Bunny/Dust_Bunny_east.png` and
`Textures/DustBunny/Bunny/Dessicated_Dust_Bunny.png` are the same 256×256 file, identical by MD5.
The dessicated corpse of a dust bunny is therefore drawn exactly like a live one — which, for a
creature that is a clump of dust, is arguably correct and is in any case theirs to decide. It is
recorded rather than fixed: repainting it would be making art, not porting a mod.

**Neither image under `About/` is theirs,** and the reason belongs in this file rather than a
style note.

An icon was once cut from their own sprite — the opaque 91×83 squared around its centre and scaled
to 128 px. It was withdrawn on 2026-09-11, and two rules reach it. The first is the one that
matters here: **an icon cut from the source mod is the source authors' art standing in for the
identity of the port**, and the identity is the one thing a port should carry itself. Everything
else in this folder is honestly theirs and says so; the icon was the single place where their work
would have been doing the port's own talking. The second is that the repository's icons are all one
mascot, a round winking head, and a detoured grey bunny is not that.

`About/Preview.png` had the same defect and was slower to show it. What shipped in 2021 was not a
showcase at all: it was the bunny sprite itself, the same 256×256 file as
`Dust_Bunny_east.png` down to the MD5, sitting transparent in a square. Keeping it would have been
the icon's mistake a second time, at four times the size.

Both were replaced on 2026-09-11 by images made for this port, and **neither is derived from the
original art** — no pixel of the bunny sprite is in either one. The mascot is the repository's own,
recoloured grey for this mod; the showcase is a workshop floor drawn from scratch. The
full-resolution originals are under `Art/`, and the engraving page that lays the title over the
showcase is `_tools/preview.html`.

`Art/Make-ModIcon.ps1`, which performed the withdrawn crop, is deleted with them. It was kept only
as a fallback for as long as the mascot did not exist.

## The C# was rewritten, not copied

The original assembly holds exactly one type, `DustBunnies.Recipe_SpawnDustBunny`, and it is the
whole mod: a `RecipeWorker` that spawns a pawn instead of producing an item. `Source/` is a
reimplementation of that behaviour against the 1.6 API, not a decompilation dropped in — the
assembly was decompiled to find out what it called, and every call was then checked against 1.6 by
reflection before a line was written.

This mattered more than it usually does. **A `RecipeWorker` whose signature moved does not fail at
load.** Nothing references it until a colonist finishes the bill, so a blind recompile against 1.6
references would have produced a mod that starts, shows both recipes, lets you queue them, and
then throws the first time somebody actually makes a dust bunny.

What the check found: nothing moved.

| call | 1.6 |
|---|---|
| `RecipeWorker.Notify_IterationCompleted(Pawn, List<Thing>)` | unchanged |
| `PawnGenerator.GeneratePawn(PawnKindDef, Faction)` | gained an optional third parameter, `PlanetTile? tile` |
| `GenSpawn.Spawn(Thing, IntVec3, Map, Rot4, …)` | gained an optional seventh parameter, `forbidLeavings` |

Both additions are optional, so both call sites compile and behave as before. The original passed
`WipeMode.Vanish` and `respawningAfterLoad: false` explicitly; those are the defaults, and they are
now left implicit.

The call site was verified too, not just the signature. `Toils_Recipe.FinishRecipeAndStartStoringProduct`
still calls `curJob.bill.Notify_IterationCompleted(actor, ingredients)`, and `Bill_Production`
still forwards it to `recipe.Worker` — after the ingredients are consumed, before the job ends,
with the doer standing on the crafting spot.

## What changed in the port

**Wildness.** `<wildness>0.1</wildness>` sat inside `<race>`. Wildness stopped being a field of
`RaceProperties` and became a `StatDef`; that element now matches no field, and RimWorld does not
stop for an element that matches no field — it logs one line and carries on with the field unset.
The `Wildness` stat's `defaultBaseValue` is `-1` (Core's own comment: *"so we can catch missing
wildness stats on animals"*), `minValue` is `0`, and `StatWorker` clamps, so a dust bunny left in
the old form would have come out perfectly tame instead of very slightly wild. Small in effect
here — 0.1 is nearly nothing — but it also erases the line from the animal's information card,
since `Wildness` declares `showIfUndefined` false. It is now `<Wildness>0.1</Wildness>` under
`statBases`, written the way vanilla's own animals write it.

**The static field initialiser.** The original held its target pawn kind like this:

```csharp
public static PawnKindDef Pawn_DustBunny = DefDatabase<PawnKindDef>.GetNamed("DustBunny", true);
```

An inline static field initialiser runs when the CLR first touches the type, which is a moment the
mod does not choose. In practice it worked — `RecipeDef.Worker` is lazy, and by the time a bill
runs the database is long since built — but a failure there surfaces as a
`TypeInitializationException` with the real cause two levels down, and the field never rebinds if
the database is reloaded. It is a `[DefOf]` class now: `DefOfHelper.RebindAllDefOfs` binds it once
the database is complete, and again after any reload.

**A stat that no longer exists.** The original wrote `<ToxicSensitivity>0.0</ToxicSensitivity>` under
`statBases`. `ToxicSensitivity` is not a `StatDef` in 1.6: the loader logged `No RimWorld.StatDef named
ToxicSensitivity` at every start and dropped the value, so the animal was not immune to toxic buildup,
which the original's zero sensitivity meant it to be. `ToxicResistance` is the stat that replaced it, one
meaning immune, and the port writes `<ToxicResistance>1.0</ToxicResistance>`. This is a port decision
made to keep the original's intent, and the one place where a stat differs; the first in-game test run
found it (2026-09-24).

**An optional enrolment in A Dog Said... Animal Prosthetics 2.** With
[A Dog Said... Animal Prosthetics 2](https://steamcommunity.com/sharedfiles/filedetails/?id=3238353862)
(`SamBucher.ADogSaidAnimalProsthetics2`, by SamBucher, source at
[SamuelBucher/A-Dog-Said-Animal-Prosthetics-2](https://github.com/SamuelBucher/A-Dog-Said-Animal-Prosthetics-2))
loaded, the dust bunny is offered the surgeries of its first category, small critters, the one the
Squirrel and the Rat are in. The mod's own patch, `Mod/Patches/ADogSaidAnimalProsthetics2.xml`, adds
`DustBunny` to the `recipeUsers` of its abstract `ADS_Cat1` recipes, behind a condition that finds nothing
when ADS 2 is absent. ADS 2 copies its three category lists once, in its last patch, so `About.xml` says
`loadBefore` for it. Nothing of ADS 2 is copied into this mod: its source and a downloaded copy of version
1.3.7 were read to see how it files animals, and it is neither a dependency nor required. The choice of the
first category is the port's and has not been confirmed by its author, who was not contacted.

**Two null guards.** `Notify_IterationCompleted` now returns early if the bill doer is null or
unspawned. Nothing in vanilla calls it that way; the reason to guard is that the alternative is a
null `Map` handed straight to `GenSpawn`.

**Two English jobStrings.** `Gathering Dust.` → `Gathering dust.`, and `Making Dust Bunny.` →
`Making a dust bunny.` Vanilla writes jobStrings as ordinary sentences, and English is the fallback
every other language falls back to.

**Dead code dropped.** The recipe file carried a commented-out `VG_DigSoil_Bulk` recipe referring
to `VG_PileofDirt` and `VG_DiggingSpot`, defs from another mod entirely — the template this file
was started from. The concrete `DustBunny` `ThingDef` also carried an empty `<race>` element whose
only content was a commented-out `<useMeatFrom>Hare</useMeatFrom>`.

**French was added**: 12 keys. The animal is a *mouton de poussière*, which is what the thing is
called in French and which keeps the joke — a *mouton* is both the dust under the bed and the
animal in the field, so *"fait de mouton"* lands the way *"made from bunny"* does. jobStrings are
third person present, the way vanilla writes them (*"Extrait le moût du houblon."*), not the
infinitive the English uses. The dust needs no `stuffProps.stuffAdjective`:
`ThingDef.LabelAsStuff` falls back to the label when the adjective is empty, and both are
*poussière*.

## What did not change

Every stat but the toxic one above, every tool, the litter curve, the single life stage, the sounds, the
trade tags, the draw sizes, the recipe costs and work amounts, and the four images. The balance was not
touched anywhere else — including the parts that look like mistakes and are not the port's to decide:
`baseHungerRate` 0 (it never eats), `lifeExpectancy` 1 (it lives a year), `mateMtbHours` 0 with a
`litterSizeCurve` and a `gestationPeriodDays` that consequently never come into play, and
`ecoSystemWeight` on an animal that is in no biome and can only be crafted.

**The `defName`s were kept, and checked rather than assumed.** `Dust` in particular carries no
author prefix and is exactly the kind of name that collides:

- **Core and every DLC** — nothing defines `Dust`, `DustBunny`, `GatherDust` or `MakeDustBunny`,
  and nothing declares `BaseDustBunny` or `DustBunnyBase` as an abstract `Name`.
- **Every subscribed Workshop mod**, 10 352 of them. One hit, and it is not a collision:
  *Allergies* (`phil42.allergies`) declares a `P42_Allergies.AllergyDef` named `Dust`. RimWorld's
  `DefDatabase` is generic per def type, so an `AllergyDef` and a `ThingDef` may share a name.
  Every other hit is the source mod's own three version folders.
- **Every other mod in this repository** — nothing.

No collision, so no rename. That is the right way round to decide it: a rename is permanent in a
way a port is not.

## What was dropped from the published folder

`About/PublishedFileId.txt`, for the obvious reason: it names 2blockdude's and HendraGradeWood's
Workshop item.

The `1.1/` and `1.2/` version folders. The mod declared its content in per-version directories
with no `LoadFolders.xml`, so RimWorld was loading whichever matched. The three folders held
**byte-identical** XML — only the assembly differed, being recompiled per version — so the port
keeps one copy of the defs at the root and one assembly built against 1.6.

## AI assistance and test tools

The port, its tests and its documentation were written with **Claude** (Anthropic) and **Codex** (OpenAI),
under human direction and review. The tests run in the game with **Pickle** and **RimLogging**, by RimWorks,
which are development tools only and never a dependency of the distributed mod.

## Adoption

If I do not answer within a reasonable time after being contacted, anyone may freely update this
or any other of my mods, including publishing a continuation of it. All credit must be preserved.
