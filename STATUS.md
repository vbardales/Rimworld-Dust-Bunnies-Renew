---
mod:          Dust Bunnies Renew
packageId:    nelim.dustbunniesrenew
repo:         Rimworld-Dust-Bunnies-Renew
visibility:   public
detached:     yes
stage:        done
licence:      silent
licence_at:   four places; the linked repository reports license: null
dependencies: none
showcase:     complete
tested_on:
workshop:
remaining:
  - unverified: the recipe that makes the animal, the only place the mod's own code runs
  - unverified: training, the creature staying at the AnimalBaby life stage for life
  - unverified: the sixteen other scenarios in _tools/FUNCTIONAL-SCENARIOS.md
session:      local_49e74fa8-1876-4ba3-92c3-10edeb90216f
updated:      2026-09-12, the mod's own session
---

# Dust Bunnies Renew — status

Read by a sweep across every mod, rather than by asking each thread in turn. It lives at the
root, never inside `Mod/`, so Steam never receives it.

The fields read off the disk on 2026-09-12 were checked one by one and are right. The three the
sweep could not fill are settled here.

- **`stage`** — `done` confirmed, in the sense that the work is finished rather than that it is
  published: the port's two corrections, the rewritten C#, the French, the showcase and the
  scenarios are all in place, and nothing is outstanding in the repository. Twenty of the
  twenty-one mods marked `done` across the repositories have no Workshop item either, so the word
  already carries that meaning.
- **`tested_on`** — empty, and the line the sweep puts there by default is true for once:
  **RimWorld has never loaded this mod**, neither in its original form since 2021 nor in this
  port.
- **`dependencies`** — `none`, and it is the easy kind of none: the About declares no
  `modDependencies` and its only `loadAfter` is `Ludeon.RimWorld`, so there is no non-vanilla
  entry to go and check. The field matters because an undeclared dependency is not cosmetic — on
  2026-09-11 Reequilibrage animaux took 47 vanilla animals down with it, Muffalo included, because
  a class it injects belongs to a mod that was neither declared nor loaded.
- **`remaining`** — three lines of unverified, no line of broken. No known fault left unfixed:
  what looks unfinished in the defs — `mateMtbHours` 0 beside a `litterSizeCurve`, an
  `ecoSystemWeight` on an animal that belongs to no biome, a dessicated corpse drawn like a live
  one — was recorded, documented and left alone, because that is the original's balance and not
  the port's to decide.

**Why the first line comes before the others.** The whole mod is one `RecipeWorker` method, and
**nothing calls it until a colonist finishes the bill** — not loading, not queueing, not starting
the work. A `workerClass` that fails to resolve leaves the field null without killing the def, so
the recipe would consume the hundred dust, run its 800 ticks, end the job and produce nothing,
while every other observable behaviour of the mod stayed intact. Every call it makes was checked
against 1.6 by reflection before a line was written, which makes that failure unlikely, but
reflection proves a method still exists with that shape, not that the game still does the thing.

There is no out-of-game suite beside it, and that is deliberate: there is nothing to run without
a map, a colonist and a bill.

`_tools/FUNCTIONAL-SCENARIOS.md` is the source: eighteen scenarios, one thing to watch each, the
`Player.log` line that says which failure it was, and what they cannot cover. This card keeps only
the balance.

**Last figures checked, 2026-09-12.** Writing those scenarios turned up three false claims in the
port's own documentation — dust called warm when it is the worst insulator in the game, called
very flammable when its factor sits below cloth's, and butchering announced at 50 dust for a real
yield near 18. All three corrected in `About.xml`, the README and the CHANGELOG. The Workshop
description is sent only when the item is created, so the window for that kind of correction
closes at publication.

`licence` vocabulary: `open` an explicit licence, `silent` no licence and a dead source,
`alive` no licence but a living source, `forbidden` a written refusal, `original` owing nothing
to anyone — not a name, not an idea traceable to one mod, not a value derived from its assets.
