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
`2blockdude, HendraGradeWood - 1.6 port: nelim`, and the removal clause is in the description.

## What was carried over

Everything the mod defined — seven defs, four distinct images and one C# class. No dependency, no
DLC, no research, no patch.

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
HendraGradeWood's, unchanged. So are the images, byte for byte, and `About/Preview.png`.

**The mod ships five texture files but only four distinct images.** `Preview.png`,
`Textures/DustBunny/Bunny/Dust_Bunny_east.png` and
`Textures/DustBunny/Bunny/Dessicated_Dust_Bunny.png` are the same 256×256 file, identical by MD5.
The dessicated corpse of a dust bunny is therefore drawn exactly like a live one — which, for a
creature that is a clump of dust, is arguably correct and is in any case theirs to decide. It is
recorded rather than fixed: repainting it would be making art, not porting a mod.

`About/ModIcon.png` is new, and is not new art: it is the opaque 91×83 of their own sprite,
squared around its centre with an 8 % margin and scaled to 128 px. The full file is 256×256 of
which the bunny occupies barely a ninth, off centre; handed over as it stands it would draw as a
grey speck at the ~32 px the mod list actually uses. `Art/Make-ModIcon.ps1` is the script that cut
it, kept so the crop can be redone rather than guessed at.

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

Every stat, every tool, the litter curve, the single life stage, the sounds, the trade tags, the
draw sizes, the recipe costs and work amounts, and the four images. The balance was not touched
anywhere — including the parts that look like mistakes and are not the port's to decide:
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

## Adoption

If I do not answer within a reasonable time after being contacted, anyone may freely update this
or any other of my mods, including publishing a continuation of it. All credit must be preserved.
