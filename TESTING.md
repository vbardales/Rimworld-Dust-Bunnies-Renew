# Test scenarios

Where each kind of check lives, what `tested` still needs, and which proofs to keep. The eighteen
scenarios themselves are in [`_tools/FUNCTIONAL-SCENARIOS.md`](_tools/FUNCTIONAL-SCENARIOS.md). No run of
any of them is recorded: this mod has never been loaded by RimWorld.

## Automated regression tests

From the repository root:

```powershell
pwsh -NoProfile -File _tools/Test-Mod.ps1
```

It needs a .NET SDK, PowerShell 7 and a RimWorld 1.6 installation (`-GameRoot` overrides the path), reads the
game's own assemblies and data, and exits non-zero on the first failure. `-SkipBuild` checks the existing DLL
and must not be reported as a fresh build. Its four checkers are copies under `_tools/checks/`, so nothing
outside this repository is needed.

Coverage: the Release build; all eight XML files parse; `packageId`, the `(unofficial)` suffix and the GitHub
link; every XML field against the game's own field list; every def reference, its type and every abstract
parent; the twelve French DefInjected keys; the two C# types the XML names; and, on the shipped DLL, that the
recipe worker derives from `RecipeWorker`, overrides the game's completion hook, and that the `DefOf` field is
a `PawnKindDef`. These are the XML tests and the automated tests of this mod: there is no separate suite.

They do not run pawn generation, and no isolated C# suite is claimed: the worker needs a map, a pawn and a
bill. That is what the scenarios below are for.

**Last run, 2026-09-24 at `1b63e37`: exit 0.** Build 0 warnings, 0 errors; 8 XML files; no unknown fields; no
missing reference; 12 keys, 0 errors; 2 types resolved. The shipped DLL is byte-identical before and after the
rebuild (SHA-256 `2D6203280D1B7985DFE2F2FBA6255B046A50BD75D63C90186A59E843A16F580B`). PowerShell 7 was not
installed on the machine, so the script ran under Windows PowerShell 5.1 through a temporary `pwsh` shim kept
outside the repository; the script calls `pwsh` by name and does not fall back.

## What `tested` requires

**`done` is not met.** The collection's workflow, transition 8, asks for the Pickle scenarios to be *written*,
with their scope justified; running them is left to `tested`. None exists: there is no `Tests/Pickle/` here. What only a
running game can show is exactly what this mod does, so the scope is not empty: a colonist finishes a bill and
a live animal appears. Stage is `preTest`.

Then transition 9 (`done` -> `tested`). Three checks, each measured against what exists.

| Check | Where this mod stands |
|---|---|
| No scenario left in `@wip`. A shelved scenario is repaired and replayed, or deleted with its reason. | There is no Gherkin, so none. It has to hold at the run, not only in the files, and `-IncludeWip` is never passed. |
| Every conditional scenario ran. Each `@requires` (optional mod, DLC, companion tool) had its own pass on a map that mounts it, and its report was read. | None is planned. The About declares no dependency and no `loadAfter` beyond Core, and the content needs no DLC. The declared incompatibility is a pass of its own, below, not a conditional scenario. |
| No manual test left to validate. What is still ticked by hand is either automated and green, or listed as not applicable with its reason. | **Not met: all eighteen are still manual.** The map below says where each one goes. |

### Where each manual check goes

Planned, and none of it written yet. `Pickle` means a feature a running game has to play; `offline` means an
assertion added to `Test-Mod.ps1`, because whatever can be proved outside the game has to be; `n/a` means the
scenario would test the engine and not the mod, which the workflow rules out: the mod answers for what it
declares, and that is read in the sources.

| # | Manual check | Planned disposition |
|---|---|---|
| 0 | Loads; the four log strings | Pickle: the startup feature, `no errors were logged`, and `Player.log` read from the launch |
| 1 | Both recipes on the crafting spot, nowhere else | offline: `recipeUsers` of both recipes is exactly `CraftingSpot` |
| 2 | *Gather dust* costs nothing but time | Pickle, first half of the chain: the bill completes and dust appears |
| 3 | Dust is the worst cold insulator and burns as wood | offline, computed from the game's `Data` on each run: its `StuffPower_Insulation_Cold` is below that of every vanilla stuff a garment can be made from (`Fabric`, `Leathery`, `Metallic` or `Woody`; the six stone blocks state none and are `Stony`, so they are excluded by category and not by luck), and its flammability factor below cloth's. The materials are resolved through `ParentName` before comparing, because most inherit the stat. These are claims in the public description, so they are guarded, not restated |
| 4 | The bill makes an animal | Pickle, and the reason this suite exists: 100 dust in, a live pawn on the colonist's cell |
| 5 | Tame the moment it exists | Pickle, same feature: the pawn's faction is the colony's |
| 6 | Wildness reads 10% | offline: `Wildness` sits under `statBases`, which is the port's first correction |
| 7 | "Do until you have X" is refused | offline: `MakeDustBunny` declares no `<products>`, the trigger. The refusal text is vanilla: n/a |
| 8 | Never eats | n/a: vanilla reads `baseHungerRate`, declared and unchanged since 2021 |
| 9 | Trains, up to Advanced | Pickle, tail of the feature in 4: the training tab offers it on an animal that never leaves the `AnimalBaby` stage. This is a suspicion in the scenario text, not a verified fact |
| 10 | Comfortable down to -55 °C | n/a: a declared stat, read by vanilla |
| 11 | Butchering returns dust, no meat | Pickle, if a stat-reading step exists: `LeatherAmount` on the spawned pawn, which is about 6: the body size of a living animal is 0.2 times its `AnimalBaby` factor of 0.2, so 0.04. The def's own card says about 18 because it has no life stage, so assert against the pawn and never against the def. Otherwise the claim comes out of the description |
| 12 | Never arrives manhunter | n/a: vanilla reads `canArriveManhunter`, declared |
| 13 | Never breeds | n/a: vanilla reads `mateMtbHours`, declared |
| 14 | Dies of old age; the corpse looks alive | n/a: vanilla reads `lifeExpectancy`; the identical corpse texture is recorded in `ATTRIBUTION.md` |
| 15 | The sprite is always rotated | n/a: `Graphic_Multi` with one face is engine behaviour, recorded in the README |
| 16 | English and French | Pickle, one pass per language (below); paths are already checked offline by `Check-DefInjected` |
| 17 | The original must not load alongside | Pickle, the incompatibility pass (below). The game removes the earlier def and logs nothing, so the scenario asserts who owns the def, not a log line. Whether the game *warns* is the engine's, and is not tested |

Nothing above was decided by running anything. It is the plan to confirm when the suite exists.

## Passes this mod needs

A mod whose TESTING.md does not say how many passes it needs is tried, not tested. This one needs three, one
mod set and one language each.

1. **English, without optional mods**: the minimal set the launcher mounts by default. There are no optional
   mods to add, since the About declares none, so no "with optionals" pass applies.
2. **French** (`-Language French`): the labels, job strings and generated text, including the material and
   corpse names the engine builds from the mod's Def values. The language is chosen at launch, never switched
   during a run.
3. **Incompatibility with the original mod** (`BlockHen.Animal.DustBunnies`, Workshop 2659958183, present on
   disk with its `1.1`, `1.2` and `1.3` folders): a named set, `wsl-deps.incompat-BlockHen.Animal.DustBunnies.map`.
   The question is whether the declaration is still true. The symptom is **silence**: both mods define the same
   `defName`s, and `DefDatabase.AddAllInMods` removes the earlier def and adds the later one without a log line,
   so a scenario that waits for a duplicate-def error waits for something the game never writes. It asserts
   that both mods are loaded, fixes their order, and asserts which mod owns `DustBunny`. The catalogue of steps
   available here has no step for the owner of a def; look in the Pickle repository's `Docs/steps.md` before
   writing one, since a companion step reading the def's content pack would be the missing piece. It is replayed
   when the original moves, not on every publication.

The machine is shared and a run takes a ticket in a queue. A session watches its own ticket with a read-only
poll of the launcher's status script, never with a cron and never by launching, stopping or reserving anything:
a heartbeat under Codex, the `Monitor` tool under Claude Code, which expires after 30 minutes at most, so a
long queue means re-arming it. No ticket exists for this mod today.

## Evidence to keep

Raw Pickle reports live on disk in `Tests/Pickle/Evidence/<date>-<pass>/`, which `.gitignore` excludes:
captures and `Player.log` grow without limit. Pass `-EvidenceDir` to the launcher so the report is copied
there before the lock is released, then check `exitReason` and the played and discovered counts in each copy.
The rules are the collection's, and are stated here in full so that nothing depends on a file outside this
repository.

| Keep, per pass | Why |
|---|---|
| `summary.json` and `summary.md` | The verdict: `exitReason`, counts, scenario names. Read `exitReason` first |
| `junit.xml` and `messages.ndjson` | The per-step outcome and the failure messages |
| `Player.log` | Startup, load order, errors outside the scenarios: only the newest one per pass |
| `evidence-complete.txt` or `no-report.txt` | Says the copy is whole, or that the launcher left no report |
| The `@review` captures, **minified to JPEG** | Human review outcome. Keep the original of a capture that has to be measured, not read |
| One line in `docs/runs/` | The history, one text line per run, never a folder. The folder does not exist yet |

Delete a report that a newer one supersedes for the same scenario and the same revision, unless it is the only
proof of a check the newer run did not repeat (a language, a pass). Delete the report of a failed or
infrastructure-error attempt once its line is written and its cause recorded in `STATUS.md`. Delete any report
on a superseded build: it proves nothing about the current one. Never keep a `screenshots/` folder copied whole
from the shared report folder, which carries every other mod's captures. List what goes and what stays before
deleting, and **never delete a report that `STATUS.md` or a tracked file points to: repoint it first.**

What is worth keeping for this mod, once it has runs:

- the **English pass**: its summary and `Player.log` (startup and the recipe completion), and **one** capture
  of the bunny standing on the crafting spot after the bill completes. That is the one image that shows the
  mod working, and the only one a person has to read;
- the **French pass**: its summary and `Player.log`, and nothing else. The labels are asserted, so their proof
  is the report;
- the **incompatibility pass**: its summary, and the step outcome that names which mod owned `DustBunny`. There is no log line to keep, because the symptom is silence. Keep it until the original mod is updated: it is the sole proof of that check.

Nothing else takes a capture. The two `Preview` and `ModIcon` images are the owner's and are not test evidence.

The script that minifies captures, `Minify-Evidence.ps1`, is not in this repository yet. Two sibling mods
of the same collection carry it under `Tests/Pickle/` (`ACertainSeriesCreaturesAndHairRenew` and
`FieldworkCompanions`); take it with the first Pickle scenario, not before.

## Manual validation

[`_tools/FUNCTIONAL-SCENARIOS.md`](_tools/FUNCTIONAL-SCENARIOS.md) stays the source of the eighteen scenarios:
setup, actions, expected results and the `Player.log` line that names each failure. Record date, RimWorld
version, active DLC and mods, scenario, PASS or FAIL and the log location after any run, and update
`STATUS.md` with the outcome.
