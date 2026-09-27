# Dust Bunnies Renew — publication

Everything the Workshop page needs that the rest of the repository does not already say. Serves
the first envoi and whoever reopens this mod after.

## Steam description

Single source, per `PUBLISHING.md` ("Source unique de la description", 2026-09-25). The CI
turns this Markdown block into the Steam description (BBCode) and the `<description>` of
`About.xml` (plain text). Do not edit `About.xml`'s description by hand once the CI syncs it;
edit this block instead.

```markdown
UNOFFICIAL. This mod is published without the original author's explicit consent. If the original author contacts me to request its removal, I undertake to take it down promptly.

Sweep dust off the floor, pile up a hundred of it, and craft yourself a live dust bunny.

Two recipes at the crafting spot, one resource and one animal:

- Gather dust - 250 work, makes 10 dust. No ingredients: it comes off the floor.
- Make a dust bunny - 800 work, eats 100 dust, and a dust bunny walks off the spot. It is tame the moment it exists, because it is made rather than caught.

The bunny is a tiny grey thing, base body size 0.2 (0.04 in play, because it never leaves the baby life stage), trainable to Advanced, and it never eats - its hunger rate is zero. It lives about a year. It is comfortable down to -55 C, it never turns manhunter, and butchering one gives back about 6 dust, which is a stuff you can build and tailor with: fabric category, as flammable as wood, and the worst insulator of any material clothes can be made from. A dust parka is not a parka. The loop loses heavily on purpose - a hundred dust in, about six back out - so nobody farms dust through bunnies.

No DLC, no dependencies. Seven defs, four texture images and one class.

Optional: with [A Dog Said... Animal Prosthetics 2](https://steamcommunity.com/sharedfiles/filedetails/?id=3238353862) the dust bunny is enrolled in its first category, basic replacements, so it can receive a peg leg or a denture. With [XND Nocturnal Animals (Continued)](https://steamcommunity.com/sharedfiles/filedetails/?id=2269731409) it is nocturnal. Nothing is required and nothing changes without them.

I am not the author of this mod. The dust bunny, its artwork and its balance are 2blockdude's and HendraGradeWood's - all I did was bring it forward to 1.6, repair what the port turned up, and write the French. Credit goes to them; mistakes in the port are mine.

Original mod: https://steamcommunity.com/sharedfiles/filedetails/?id=2659958183 - declares 1.1, 1.2 and 1.3 and nothing further, untouched since November 2021.

WHAT THE PORT FIXED

Wildness stopped being a field of RaceProperties and became a StatDef. The old element matches nothing, and RimWorld does not stop for an element that matches nothing - it logs one line and carries on with the field unset. The stat's default is -1, clamped to 0, so a dust bunny left in the old form would have been perfectly tame instead of very slightly wild. It is now under statBases, where 1.6 wants it.

The recipe worker held its PawnKindDef in a static field initialised inline. That runs the first time anything touches the class, at a moment the mod does not control, and a failure there surfaces as a TypeInitializationException with the real cause two levels down. It is a [DefOf] now, bound by the game once the def database is complete.

Every game call the worker makes was checked against 1.6 by reflection before recompiling, because a RecipeWorker whose signature moved does not fail at load - it fails when the recipe runs, long after.

A third fix, found once the port ran in game: ToxicSensitivity is gone from RimWorld's StatDefs. The original wrote it at zero to make the animal immune to toxic buildup; the port writes ToxicResistance at 1.0 (immune) instead, to keep that intent.

REMOVAL

If 2blockdude or HendraGradeWood asks for this to be taken down, it comes down immediately and without discussion.

If I do not answer within a reasonable time after being contacted, anyone may freely update this or any other of my mods, including publishing a continuation of it. All credit must be preserved.

AI-GENERATED. The port, its tests and its documentation were written with Claude (Anthropic) and Codex (OpenAI), under human direction and review.

THANKS. [A Dog Said... Animal Prosthetics 2](https://steamcommunity.com/sharedfiles/filedetails/?id=3238353862) by SamBucher, and [XND Nocturnal Animals (Continued)](https://steamcommunity.com/sharedfiles/filedetails/?id=2269731409) by Mlie (update of XeoNovaDan's [original](https://steamcommunity.com/sharedfiles/filedetails/?id=2004368312)), for the two optional integrations above. [Harmony](https://steamcommunity.com/sharedfiles/filedetails/?id=2009463077), [Pickle](https://steamcommunity.com/sharedfiles/filedetails/?id=3791648678), [RimLogging](https://steamcommunity.com/sharedfiles/filedetails/?id=3733484696) and [Pickle Tools](https://steamcommunity.com/sharedfiles/filedetails/?id=3806142401) (a private item), development and testing tools only, never a dependency of the distributed mod.

See ATTRIBUTION.md for the full port history and the MIT licence, which covers only the port's own additions.

[Source code on GitHub](https://github.com/vbardales/Rimworld-Dust-Bunnies-Renew)
```

## Steam release notes (first envoi)

```
[b]0.1.0[/b]
First upload, to create the Workshop item. Private until tested by subscription.
```

## Gallery order

Steam shows the first image large: the most demonstrative goes there, not the prettiest.
Produced by a dedicated Pickle scenario rather than by hand, so it is reproducible after any
interface change (AUDIT.md, "Captures destinées à la publication"): `11-gallery-captures`,
`English -DepMap wsl-deps.gallery.map`, using PickleTools' Zen Meadow Screenshot Studio for the
scale shot and ScreenshotMode for the dialogs, as the French review pass (`10-french-dialogs`)
already does. It is `@review`: green proves the four captures were taken, not what is on them —
each one still has to be opened and looked at before upload. Order:

1. The live dust bunny on the floor, next to a colonist, showing scale.
2. The bill dialog of "Make a dust bunny" (English), showing the 100-dust cost.
3. The dust bunny's information card, showing its stats (comfortable to -55 C, immune to toxic
   buildup, never eats).
4. The dust resource's information card (Fabric stuff, worst insulator).

Each image opened and looked at before upload; none may show developer tools, another mod's
debug overlay, the Pickle launcher panel, or an empty inventory column.

## Thank-you comments

Registry: `../WORKSHOP_COMMENTS.md`. Two rows are `posted` and already list Dust Bunnies Renew
in their `Covers` column (added 2026-09-27): Harmony, Pickle, RimLogging — nothing to post for
them, they cover this mod's dev-tool credit already. Pickle Tools is `not_applicable` (same
author, no self-comment). Two integrations are still `drafted` elsewhere; check the registry
before posting either — if it is already `posted` by the time this mod goes public, post
nothing and just note it here.

**A Dog Said... Animal Prosthetics 2** (item `3238353862`), if the registry still shows
`drafted` when this item goes public:

```
Thanks for [url=https://steamcommunity.com/sharedfiles/filedetails/?id=3238353862]A Dog Said... Animal Prosthetics 2[/url] :) Dust Bunnies Renew enrolls the dust bunny in your first category, basic replacements — a little grey thing made of dust getting a peg leg made me laugh when I first saw it work. Thanks for keeping the categories simple enough that a small port could hook into just the first one.
```

**[XND] Nocturnal Animals (Continued)** (item `2269731409`, Mlie), if still `drafted`:

```
Thanks for [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2269731409]Nocturnal Animals[/url] :) It let Dust Bunnies Renew's little dust bunny keep sweeping at night instead of during the day, which suits a creature made of what accumulates while nobody's looking. One extension, one field, and it just worked.
```

**[XND] Nocturnal Animals (the original, XeoNovaDan)** (item `2004368312`), if still `drafted`
— check first whether the original page still accepts comments; if not, mark `not_applicable`
in the registry with that reason instead of posting:

```
Thanks for the original Nocturnal Animals :) Dust Bunnies Renew uses it (via Mlie's continuation) to give the dust bunny a nocturnal body clock — a small idea that still holds up.
```

## Dependencies and DLC

No DLC, no hard dependency. Two optional integrations, both verified in the sources, not from
description alone: `SamBucher.ADogSaidAnimalProsthetics2` (`loadBefore`, the mod's own
conditional patch adds `DustBunny` to `ADS_Cat1`'s `recipeUsers`) and
`Mlie.XNDNocturnalAnimals` (`MayRequire` on a `DefModExtension`, no `loadAfter` needed since the
extension is read lazily). Neither forces a download for anyone who doesn't have it.

## Adult content

No adult content. Not applicable.

## Remaining before the first envoi

- About.xml's description still says "In-game validation of this port is pending" — see
  `STATUS.md`; fix before or at the same time as adopting this file's Markdown block as the
  synced source (`sync-about-description.mjs` / `--sync-about`).
- `CHANGELOG.md` needs its `## [0.1.0]` entry once the item is created (AUDIT.md, §11).
