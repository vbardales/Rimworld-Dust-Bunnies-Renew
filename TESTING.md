# Test scenarios

Where each kind of check lives, what `tested` still needs, and which proofs to keep. The eighteen
scenarios themselves are in [`scripts/FUNCTIONAL-SCENARIOS.md`](scripts/FUNCTIONAL-SCENARIOS.md). No run of
any of them is recorded: this mod has never been loaded by RimWorld.

## Automated regression tests

From the repository root:

```powershell
pwsh -NoProfile -File scripts/Test-Mod.ps1
```

It needs a .NET SDK, PowerShell 7 and a RimWorld 1.6 installation (`-GameRoot` overrides the path), reads the
game's own assemblies and data, and exits non-zero on the first failure. `-SkipBuild` checks the existing DLL
and must not be reported as a fresh build. Its four checkers are copies under `scripts/checks/`, so nothing
outside this repository is needed.

Coverage: the Release build; all nine XML files parse; `packageId`, the `(unofficial)` suffix and the GitHub
link; every XML field against the game's own field list; every def reference, its type and every abstract
parent; the twelve French DefInjected keys; the two C# types the XML names; and, on the shipped DLL, that the
recipe worker derives from `RecipeWorker`, overrides the game's completion hook, and that the `DefOf` field is
a `PawnKindDef`; and the claims the description makes (`scripts/checks/Check-Claims.ps1`): both recipes at the crafting spot only, no `<products>` on `MakeDustBunny`, wildness under `statBases`, dust the worst cold insulator of every material a garment can be made from, no more flammable than cloth and as wood, and the butchering yield computed the way the game does it; and the enrolment in A Dog Said... Animal Prosthetics 2: one conditional operation on `ADS_Cat1` that enrols `DustBunny` in category 1 only, no `MayRequire` on the operation, no `<nomatch>`, `loadBefore` in the About and no hard dependency. These are the XML tests and the automated tests of this mod: there is no separate suite.

They do not run pawn generation, and no isolated C# suite is claimed: the worker needs a map, a pawn and a
bill. That is what the scenarios below are for.

**Last run, 2026-09-24 at `1b63e37`: exit 0.** Build 0 warnings, 0 errors; 8 XML files; no unknown fields; no
missing reference; 12 keys, 0 errors; 2 types resolved. The shipped DLL is byte-identical before and after the
rebuild (SHA-256 `2D6203280D1B7985DFE2F2FBA6255B046A50BD75D63C90186A59E843A16F580B`). PowerShell 7 was not
installed on the machine, so the script ran under Windows PowerShell 5.1 through a temporary `pwsh` shim kept
outside the repository; the script calls `pwsh` by name and does not fall back.

## What `tested` requires

**`done` is met**, as of 2026-09-24, and **`tested` is met** (re-checked against AUDIT.md transition 9 on 2026-10-02). `Tests/Pickle/`
holds 11 features and the local steps; `Tests/Pickle/Check-Steps.ps1` resolves every step line to exactly one step.
Transition 9, one check at a time, against what exists:

| Check | Where this mod stands |
|---|---|
| Scenarios run in game and green; `@review` captures opened; `exitReason` read first; played against discovered counted | Yes. Every feature `01` to `11` played green in some run (`docs/runs/history.md`, one line per run). The `@review` captures were opened: French dialogs (2026-09-26, nothing to correct), English dialogs of the gallery (2026-10-02, clean). |
| No scenario left in `@wip`. | None of the eleven features carries `@wip`, and `-IncludeWip` is never passed. |
| Every conditional scenario ran. Each `@requires` had its own pass on a map that mounts it, and its report was read. | Yes, five of them: `07` (`BlockHen.Animal.DustBunnies`, `wsl-deps.incompat-original.map`), `08` (`SamBucher.ADogSaidAnimalProsthetics2`, `wsl-deps.avec-ads2.map`), `09` (`Mlie.XNDNocturnalAnimals`, `wsl-deps.avec-nocturnal.map`), `10` (PickleTools ScreenshotMode, `wsl-deps.captures-fr.map`), `11` (Screenshot Studio and ScreenshotMode, `wsl-deps.gallery.map`). Each played in its own pass and was skipped elsewhere; `07`, `08`, `09` were replayed after the packageId rename (2026-09-28). |
| No manual test left to validate. | Met. Each of the eighteen is automated and green, offline (`Check-Claims.ps1`, rerun green 2026-10-02), or `n/a` with its reason, in the map below. French clipping: `10-french-dialogs`, read. A new game is not required (Virginie, 2026-09-25). |

The Workshop gallery (pass 7 below) is a `prepublished` gate, not a `tested` one.

### Where each manual check goes

`Pickle` names the feature in `Tests/Pickle/Mod/Pickle/Features/`
that covers the check; `offline` means an assertion for `Test-Mod.ps1`, because whatever can be proved outside
the game has to be, and they are written, in `scripts/checks/Check-Claims.ps1`; `n/a` means the scenario would test the engine
and not the mod, which the workflow rules out: the mod answers for what it declares, and that is read in the
sources. `Tests/Pickle/README.md` gives the reasoning per feature.

| # | Manual check | Disposition |
|---|---|---|
| 0 | Loads; the four log strings | Pickle `01-loads`: the recipe's worker class resolved, the `[DefOf]` bound, no error, no warning from the mod. `Player.log` is still read from the launch, because a startup error precedes every scenario |
| 1 | Both recipes on the crafting spot, nowhere else | offline, `Check-Claims.ps1`: `recipeUsers` of both recipes is exactly `CraftingSpot` |
| 2 | *Gather dust* costs nothing but time | Pickle `02-gather-dust`: a bill with no ingredient ends, and exactly ten dust appear |
| 3 | Dust is the worst cold insulator and burns as wood | offline, `Check-Claims.ps1`, computed from the game's `Data` on each run: its `StuffPower_Insulation_Cold` is below that of every vanilla stuff a garment can be made from (`Fabric`, `Leathery`, `Metallic` or `Woody`; the six stone blocks state none and are `Stony`, so they are excluded by category and not by luck), and its flammability factor below cloth's. The materials are resolved through `ParentName` before comparing, because most inherit the stat. These are claims in the public description, so they are guarded, not restated |
| 4 | The bill makes an animal | Pickle `03-make-a-dust-bunny`, first scenario, and the reason this suite exists: 100 dust consumed, exactly one live pawn, and a capture of it |
| 5 | Tame the moment it exists | Pickle `03`, same scenario: the animal belongs to the colony. `04-save-reload` saves and reloads a queued bill and an animal |
| 6 | Wildness reads 10% | offline, `Check-Claims.ps1`: `Wildness` sits under `statBases`, the port's first correction. `03` also reads the stat from the living animal |
| 7 | "Do until you have X" is refused | offline, `Check-Claims.ps1`: `MakeDustBunny` declares no `<products>`, the trigger. The refusal text is vanilla: n/a |
| 8 | Never eats | n/a: vanilla reads `baseHungerRate`, declared and unchanged since 2021 |
| 9 | Trains, up to Advanced | Pickle `03`, third scenario: guard and attack can be assigned to the living animal. Haul and rescue are refused as too small, which is vanilla arithmetic on `minBodySize` 0.40 and 0.65: n/a. Scenario 9 had wrongly expected them |
| 10 | Comfortable down to -55 °C | n/a: a declared stat, read by vanilla |
| 11 | Butchering returns dust, no meat | Pickle `03`, second scenario: the living animal's `LeatherAmount` is between 5 and 6.5, its body size 0.04. **Read from the pawn, not the def**: the def's card says about 18. `Check-Claims.ps1` also computes the yield offline from the game's data, the way the game does, so the description's figure is guarded without a game. Butchering rounds that stat at random and is vanilla: n/a |
| 12 | Never arrives manhunter | n/a: vanilla reads `canArriveManhunter`, declared |
| 13 | Never breeds | n/a: vanilla reads `mateMtbHours`, declared |
| 14 | Dies of old age; the corpse looks alive | n/a: vanilla reads `lifeExpectancy`; the identical corpse texture is recorded in `ATTRIBUTION.md` |
| 15 | The sprite is always rotated | n/a: `Graphic_Multi` with one face is engine behaviour, recorded in the README |
| 16 | English and French | Pickle `05-labels-en` and `06-labels-fr`, one pass per language, on the loaded defs. The corpse and material names the engine builds from those values are its templates: n/a. Clipping in the bill and information dialogs in French: `10-french-dialogs`, a `@review` capture of the bill dialog and of the information cards of the dust bunny and of the dust, in its own French pass (`wsl-deps.captures-fr.map`). **Run 2026-09-26 (ticket 8015) and the three pictures read: French throughout, no clipping, raw key or fallback** |
| 17 | The original must not load alongside | Pickle `07-original-mod-incompatibility`, the incompatibility pass (below). Whether the game *warns* is the engine's, and is not tested |
| 18 | ADS 2: the dust bunny is offered a peg leg and a denture, and nothing above category 1 | The enrolment is declared and guarded offline, in `Check-Claims.ps1`. That the surgeries really reach a dust bunny, and that the patch ran before ADS 2 copied its lists, is a running-game fact: Pickle `08-animal-prosthetics-2`, the fourth pass. It compares with a Squirrel (ADS 2 lists it in category 1 only) and with a Cat (all three), so it names no recipe: ADS 2 does define them, `InstallPegLegAnimal` and its siblings, but a comparison holds whatever they are called. ADS 2 is in the WSL cache since 2026-09-24 and the pass is filed |
| 5, tail | Save, quit, reload: the bunny, the dust and the queued bills persist | Pickle `04-save-reload`: a queued bill and an animal survive a round trip. The **made** animal's faction across a reload is not asserted: the animal there is spawned by kind, and faction persistence is vanilla's |

The Pickle rows were all played green (see above); the offline rows run on every `Test-Mod.ps1`.

## Passes this mod needs

A mod whose TESTING.md does not say how many passes it needs is tried, not tested. This one needs seven, one
mod set and one language each.

1. **English, without optional mods**: the minimal set the launcher mounts by default. The one optional
   integration, ADS 2, has its own pass below, so nothing else is added to this one.
2. **French** (`-Language French`): the labels, job strings and generated text, including the material and
   corpse names the engine builds from the mod's Def values. The language is chosen at launch, never switched
   during a run.
3. **Incompatibility with the original mod** (`BlockHen.Animal.DustBunnies`, Workshop 2659958183, present on
   disk with its `1.1`, `1.2` and `1.3` folders): `wsl-deps.incompat-original.map`. The question is whether the
   declaration is still true. The symptom is **silence**: both mods define the same `defName`s, and
   `DefDatabase.AddAllInMods` removes the earlier def and adds the later one without a log line, so a scenario
   that waits for a duplicate-def error waits for something the game never writes. `07` asserts that both mods
   are loaded, that this one loads after the original, and that this one owns `MakeDustBunny`, `GatherDust` and
   `Dust`, with Pickle's own `def ... is defined by mod ...` step. It is replayed when the original moves, not on
   every publication. The original is subscribed in the Windows Workshop, which the staging script reads first, so nothing has to be downloaded.
4. **With A Dog Said... Animal Prosthetics 2** (`SamBucher.ADogSaidAnimalProsthetics2`, Workshop 3238353862, source
   at `SamuelBucher/A-Dog-Said-Animal-Prosthetics-2`): the optional integration this mod declares, with
   `wsl-deps.avec-ads2.map`. It declares no hard dependency, so its line is the whole set. `08` asserts the load
   order first, this mod before ADS 2, because ADS 2 copies its category lists once; then that the dust bunny is
   offered what a Squirrel is and less than a Cat. It was played green. ADS 2 is
   not in the Windows Workshop; it was fetched into the WSL cache on 2026-09-24, at the owner's request, through
   the machine lock, and the staging script reads that cache as its second place.
5. **With [XND] Nocturnal Animals (Continued)** (`Mlie.XNDNocturnalAnimals`, Workshop 2269731409): the second optional
   integration, with `wsl-deps.avec-nocturnal.map`. It declares no hard dependency beyond Harmony, which every staging
   has. `09` reads the `NocturnalAnimals.ExtendedRaceProperties` extension off the dust bunny's `ThingDef` and asserts
   `bodyClock` is `Nocturnal`. That the extension is **absent and silent** without the mod is not a scenario: it is what
   the startup log of every other pass shows, and it is read there (the error that `no errors were logged` cannot see is
   raised before any scenario). It is a small ticket, since only this feature plays.
6. **The French review captures** (`wsl-deps.captures-fr.map`, `-Language French`): PickleTools' ScreenshotMode, a development
   tool that hides the HUD and Pickle's panels around an open dialog, is staged by `path:`; it is never a dependency of the
   mod. `10-french-dialogs` opens the bill dialog of `MakeDustBunny` and the information cards of the dust bunny and of the
   dust, and captures each. Developer mode stays on, so a missing key shows as the game's accented fallback. It asserts that
   each dialog opened and nothing about the picture: **the three captures must be opened and looked at** for raw keys,
   fallback text and clipping. One small ticket.

7. **The Workshop gallery captures** (`wsl-deps.gallery.map`, `-Language English`): the gallery is staged, not grabbed
   (owner's rules, PUBLISHING.md, 2026-10-02 and 2026-10-06): one story, the photographer's own choices of place, moment and
   composition, a shooting plan in the header of the feature. `11-gallery-captures` plays image 1 as a staged photograph in
   PickleTools' Sanctuary (`Nelims-tribe`, place `sleeping-nook`, midday, Nelim in teal and plum, the dust bunny at the foot of
   her bed, camera at zoom 4), and keeps the English bill dialog and the two information cards as plain menu screenshots on
   the test colony, the way `10-french-dialogs` does. It is `@review`: green proves the four captures were taken, not what is
   on them — **each is opened and looked at**; the order and what each shows is in `PUBLICATION.md`, "Gallery order". The
   three dialogs were played and read (2026-10-02, clean). Image 1 was rewritten on 2026-10-06 and played green at zoom 4 (`0412`), picture read.
   The zoom is PickleTools' own: `I am at the sanctuary` lifts the game's zoom clamp, then `the camera root size is set to 6`
   and `the camera root size is 6` (read-back); the mod no longer writes `CameraDriver` fields itself (NPT, 2026-10-06). `Check-Steps.ps1`
   now resolves the `Prefix + "..."` form of the shared tools, so every step line resolves (checked 2026-10-06).

## Order of the passes (AUDIT.md, 2026-10-02)

What has never run or is red is replayed alone, in small tickets; the non-regression passes are filed together, at the end, on
the final revision. Today: nothing is new or red any more; image 1 of `11-gallery-captures` (rewritten 2026-10-06) was the last new scenario and is green. **Non-regression**, every scenario
green on the logic still in the repository: `01` to `10` and the three dialogs of `11`; the `Mod/` has not changed since
`077502e` and the steps they use are unchanged. The final non-regression set is the seven passes above, filed once after the
last new ticket is green. When the last ticket is played, the optional mods this mod's passes downloaded into the WSL
(A Dog Said... Animal Prosthetics 2, [XND] Nocturnal Animals) are removed from the WSL install, under the machine lock, only
if no other mod's `wsl-deps` names them, with the list of what goes and what stays written first (AUDIT.md, 11).

**No new game is created** (Virginie, 2026-09-25). The `tested` criterion "a new game and an existing save" is met by the
existing save alone: loading a game saved **without** this mod, with the mod added, which is what the shared `test-colony`
fixture does in every scenario that loads it (`02` to `04`, and the training and size scenarios). A new colony is not
repeatable, and this mod adds content only: no game component, no world or map generation, no settings, and the dust bunny is in
no biome and is made, not generated, so a new game would exercise nothing a loaded one does not. PickleTools' NewColony
companion is therefore not staged by any pass of this suite.

**Fixtures: a save made with this mod may be kept** (Virginie, 2026-09-25). A saved game that has this mod in it, for example
one with a dust bunny in the colony and a bill queued, is a fixture like any other and can be committed with the suite, in
the companion's `Pickle/Fixtures/` where Pickle looks for a save. It is the repeatable way to cover "an existing save that
already carries the mod", where a new colony is not repeatable. Keep it small, since the disk is full, and say in this file
which mod version and which revision made it and what it holds. Today the suite has none of its own: `04` saves and reloads
within one run, and the shared `test-colony` was saved **without** the mod, which covers "the mod added to an existing save".

The machine is shared, so a run is a ticket. Tickets are filed with TicketDispatcher (documented in its
`WELCOME.md`, which is the owner's and lives outside this repository), and **it follows them**: this mod's session
sets up no watcher, no `Monitor` and no cron of its own. Tickets are small, three rather than one big one. An
**exploration or fix** ticket plays as few scenarios as possible; an **initial or final** ticket plays every
scenario of its pass. The four passes above are four initial tickets, filed on 2026-09-24; a request carries no revision, so the mod
stays untouched between filing and the last `RUN_DONE`.

## Evidence to keep

Raw Pickle reports live on disk in `Tests/Pickle/Evidence/<date>-<pass>/`, which `.gitignore` excludes:
captures and `Player.log` grow without limit. Pass `-EvidenceDir` to the launcher so the report is copied
there before the lock is released, then check `exitReason` and the played and discovered counts in each copy.
The rules are the collection's, and are stated here in full so that nothing depends on a file outside this
repository.

| Keep, per pass | Why |
|---|---|
| `summary.json` and `summary.md` | The verdict: `exitReason`, counts, scenario names. Read `exitReason` first |
| `junit.xml` and `steps.txt` | The per-scenario outcome and failure messages, and every step's outcome: `steps.txt` is extracted from `report.html` (`grep` on its JSON) before `Minify-Evidence.ps1` removes it, because `messages.ndjson` carries no step text |
| `Player.log` | Startup, load order, errors outside the scenarios: only the newest one per pass |
| `evidence-complete.txt` or `no-report.txt` | Says the copy is whole, or that the launcher left no report |
| The `@review` captures, **minified to JPEG** | Human review outcome. Keep the original of a capture that has to be measured, not read |
| One line in `docs/runs/history.md` | The history, one text line per run, never a folder |

Delete a report that a newer one supersedes for the same scenario and the same revision, unless it is the only
proof of a check the newer run did not repeat (a language, a pass). Delete the report of a failed or
infrastructure-error attempt once its line is written and its cause recorded in `STATUS.md`. Delete any report
on a superseded build: it proves nothing about the current one. Never keep a `screenshots/` folder copied whole
from the shared report folder, which carries every other mod's captures. List what goes and what stays before
deleting, and **never delete a report that `STATUS.md` or a tracked file points to: repoint it first.**

What is worth keeping for this mod (the folders under `Tests/Pickle/Evidence/`, disk only, as of 2026-10-02):

- the latest run of each scenario on the current code (the tree of `077502e`: the code has not changed since, only text and
  the Preview): `2026-09-28-rename-loads` (`01`), `-rename-incompat` (`07`, the sole proof of that check, keep it until the
  original mod moves), `-rename-ads2` (`08`), `-rename-nocturnal` (`09`), plus `2026-09-25-bare-startup` (the startup log
  with no error about the optional extension);
- the passes the rename runs did not repeat, still on unchanged defs: `2026-09-24-english` and `-french`
  (`02` to `06`, with `steps.txt`), `-fix-toxic` and `-fix-training` (the two scenarios that superseded their failing copies there);
- the French captures, minified to JPEG: `2026-09-25-captures-fr`;
- the gallery originals (the three dialogs are the only copy of their full frames; do not minify them): `2026-09-28-gallery`; and
  `2026-10-06-gallery-image1-zoom4`, the run of image 1 as it ships (summary, log and the 1920 x 1080 picture).

A new pass replaces the folder it supersedes: a rerun of `08` or `09` replaces its `-rename-` folder, it does not add one.

Nothing else takes a capture. The two `Preview` and `ModIcon` images are the owner's and are not test evidence.

`Tests/Pickle/Minify-Evidence.ps1` shrinks a copied report in place: screenshots become JPEG (quality 80, at most
1280 px), and `report.html` and `messages.ndjson` go.

## Manual validation

[`scripts/FUNCTIONAL-SCENARIOS.md`](scripts/FUNCTIONAL-SCENARIOS.md) stays the source of the eighteen scenarios:
setup, actions, expected results and the `Player.log` line that names each failure. Record date, RimWorld
version, active DLC and mods, scenario, PASS or FAIL and the log location after any run, and update
`STATUS.md` with the outcome.
