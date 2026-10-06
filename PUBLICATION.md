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

Optional: with [A Dog Said... Animal Prosthetics 2](https://steamcommunity.com/sharedfiles/filedetails/?id=3238353862) the dust bunny is enrolled in its first category, basic replacements, so it can receive a peg leg or a denture. With [[XND] Nocturnal Animals (Continued)](https://steamcommunity.com/sharedfiles/filedetails/?id=2269731409) it is nocturnal. Nothing is required and nothing changes without them.

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

THANKS. [A Dog Said... Animal Prosthetics 2](https://steamcommunity.com/sharedfiles/filedetails/?id=3238353862) by SamBucher, and [[XND] Nocturnal Animals (Continued)](https://steamcommunity.com/sharedfiles/filedetails/?id=2269731409) by Mlie (update of XeoNovaDan's [original](https://steamcommunity.com/sharedfiles/filedetails/?id=2004368312)), for the two optional integrations above. [Harmony](https://steamcommunity.com/sharedfiles/filedetails/?id=2009463077), [Pickle](https://steamcommunity.com/sharedfiles/filedetails/?id=3791648678), [RimLogging](https://steamcommunity.com/sharedfiles/filedetails/?id=3733484696) and [Pickle Tools](https://steamcommunity.com/sharedfiles/filedetails/?id=3806142401) (a private item), development and testing tools only, never a dependency of the distributed mod.

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
each one still has to be opened and looked at before upload.

Gallery folder: `Art/Gallery` (`galleryDir` in `.github/publish.config.json`; the dry-run lists
it as a reminder, SteamCMD never sends it — the CI has one `previewfile` field, the gallery goes
up by hand on the Steam page). Order (owner's convention, 2026-09-29: the first image is
numbered 0, a byte-identical copy of `Preview.png`, recopied every time the Preview changes so
the two never drift):

0. `0-preview.png` — a copy of `Mod/About/Preview.png` itself: since 2026-09-29 it carries the
   the ModIcon badge in a corner (placement and veil in `Art/Preview.config.json`, rendered by the shared
   renderer, see `Art/preview-workflow.md`). Done; committed.
1. **The dust bunny at the foot of Nelim's bed** (staged photograph, `11-gallery-captures`): a dust bunny, tiny and grey, on the white rug
   of the Sanctuary's `sleeping-nook`, Nelim standing two cells away in teal and plum, midday light, the royal bed and the
   drapes behind. It says: it is alive, and it is tiny.
2. The bill dialog of "Make a dust bunny" (English), showing the 100-dust cost.
3. The dust bunny's information card, showing its stats (comfortable to -55 C, immune to toxic
   buildup, never eats).
4. The dust resource's information card (Fabric stuff, worst insulator).

**The story of the series** (owner's rule: one story, not a row of captures): spring cleaning in the Sanctuary. Nelim sweeps the
dust off her floor, piles a hundred of it on the crafting spot (image 2, the bill that asks for it), and the dust gets up and
walks (image 1). Images 3 and 4 are what the player reads next: the animal's card, the dust's card. The three menus are plain
screenshots of the windows, as the rule says, cropped to the window. The shooting plan is the header of
`Tests/Pickle/Mod/Pickle/Features/11-gallery-captures.feature`.

**State, 2026-10-06.** `Art/Gallery` holds `0-preview.png` (copy of the regenerated Preview), `1-bunny-at-the-bed.png` (the staged
photograph, ticket `0412`, zoom 4, read: Nelim awake in teal, the bunny about 70 px wide on the rug beside her, no tool overlay) and
images 2 to 4 (cropped to their dialogs, originals in `Tests/Pickle/Evidence/2026-09-28-gallery`; read, clean). Image 3 reads
"Leather amount 18", the def-level figure (the animal yields about 6, as the description says). Image 1 is the full 1920 x 1080
frame, 2 MB, not cropped: a photograph keeps its surroundings.

## Thank-you comments

Registry: `../WORKSHOP_COMMENTS.md` (read 2026-10-02). Nothing is left to post for this mod:

- Harmony, Pickle, RimLogging: `posted`, the `Covers` column lists Dust Bunnies Renew. PickleTools: not applicable (same author).
- A Dog Said... Animal Prosthetics 2 (item `3238353862`): `posted` by the owner on 2026-09-28, one message from A Certain
  Series that covers the other mods naming the page, this one included.
- [XND] Nocturnal Animals (Continued) (item `2269731409`): `posted` by the owner on 2026-09-28, crediting Mlie and
  XeoNovaDan together; the original's page (`2004368312`) is `not_applicable`.

This mod's own drafts for those three pages were deleted: they do not go out.

## Dependencies and DLC

No DLC, no hard dependency. Two optional integrations, both verified in the sources, not from
description alone: `SamBucher.ADogSaidAnimalProsthetics2` (`loadBefore`, the mod's own
conditional patch adds `DustBunny` to `ADS_Cat1`'s `recipeUsers`) and
`Mlie.XNDNocturnalAnimals` (`MayRequire` on a `DefModExtension`, no `loadAfter` needed since the
extension is read lazily). Neither forces a download for anyone who doesn't have it.

## Adult content

No adult content. Not applicable.

## Remaining before the first envoi

- Gallery image 1 (see "Gallery order"), then images 1 to 4 into `Art/Gallery`.
- `CHANGELOG.md` needs a dated `## [1.0.0]` section before the `publish` (the CI dry-run does not catch its absence).
- The release note of 1.0.0, first line `[b]1.0.0[/b]`, written when the version is sent.
