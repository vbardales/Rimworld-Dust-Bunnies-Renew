# Protocols read, and in which version

Written 2026-09-25 by Claude Sonnet 5, after the context of the session was compacted. It says what was read, at which
version, what came out of it for this mod, and which documents were of no use, so that a document that has not moved
is not read twice. The version is the last commit that touched the file (`git log -1`), and `clean` means
`git status --short` shows nothing for it. Reread a document when its commit differs from the one below.

The collection root and each sibling repository are separate Git repositories. Times are local.

## Read, and useful

| Document | Version | What it gave this mod |
|---|---|---|
| `AGENTS.md` | root `90d51374`, 2026-09-25 15:25, clean | Evidence rules (latest report per scenario for the current revision, list before deleting, never delete what `STATUS.md` points to, one line per run in `docs/runs/`); publication goes through the CI, no session approves a `publish`. Applied: the evidence folders were minified and the failed ADS 2 run deleted. |
| `AUDIT.md` | root `90d51374`, 2026-09-25 15:25, clean | The chain, and the criteria of `done` and `tested`. `tested` needs the `@review` captures actually opened, no `@wip`, every `@requires` pass played with its own map and its report read (`setName`, suite and scenario names), no manual test left. The pass with a declared-incompatible mod asserts the documented symptom and stays green. A pass map is played in order and the mod under test comes last unless the map names it. Tickets: small, one pass per request, a fix ticket plays the minimum. |
| `Rimworld-Ticket-Dispatcher/docs/WELCOME.md` | `79668cc`, 2026-09-25 17:16, clean | How to file, what to expect (`START`, `END`, `RUN_DONE`), no watcher. **A request carries no SHA: put it in `-Label`.** The tickets filed so far did not record it in their labels: `docs/runs/history.md` names the tree of each run instead. Evidence: `report.html` and `messages.ndjson` of a superseded build are not kept. Read again after each compaction, with this file. |
| `Rimworld-Ticket-Dispatcher/docs/SUBMIT.md` | `79668cc`, 2026-09-25 17:16, clean | Every option of `Submit-PickleRun.ps1`. `-DepMap` takes a file name, never a relative path. Exit codes. `-Extra '-pickle-scenario-timeout=N'` if a wait ever trips the watchdog. |
| `PUBLISHING.md` | root `90d51374`, 2026-09-25 15:25, clean | Needed for `prepublished`: the description ends with `[url=...]Source code on GitHub[/url]`; **every integration studied or exercised is thanked by name, and every named mod with its own page is linked** (ADS 2 is neither yet, see below); the distributed `ATTRIBUTION.md` must equal the root one (compared, identical, hash `a272e510`); everything is in English; the Steam description is sent once, so it is fixed by hand afterwards. Not applicable here: the parts on the shared index, `--amend` and `subtree`, which concern the monorepo, since this mod is its own repository. |
| `TRANSLATIONS.md` | root `90d51374` (last edited 2026-09-13), clean | `localization`, `translation_en`, `translation_fr` are `complete` and unchanged. The runtime check (raw keys, fallback, clipping, in French and English) is what scenario 16 and the French pass are for. |
| `PickleTools/README.md` | PickleTools `2b7b6d0`, 2026-09-25 17:22, clean | The catalogue of shared tools. For this mod: **NewColony** (a new colony from the main menu), **KeyedClick**, **ScreenshotMode**, **ClearScreen**, **ClickDiagnostics**, **HoverSteps**, **ExpansionSteps**. A tool is staged by one line of a pass map, `nelim.pickletools.<tool> path:PickleTools/<Tool>/Mod`. |
| `PickleTools/docs/steps.md` | PickleTools `d6d8db1`, 2026-09-25 17:44, clean (the folder is `docs/`, the earlier read was of Pickle's own catalogue) | Where to look before writing a step. The steps for the two remaining `tested` criteria exist: `the new colony's ... is`, `a new colony is started`, `I click button keyed {string}`, `screenshot mode is enabled around the open windows`. |
| `PickleTools/Headless/README.md` | PickleTools `b2712fc`, 2026-09-25 15:03, clean | Filter terms, passes and maps (the map order is the activation order, `path:` and `!<dlc>` lines), exit codes, `-Then`, evidence. Most of the rest (lock, sleep, orphans) concerns the machine and the dispatcher, not a mod session. |
| `Rimworld-Release-Admin/docs/OPERATIONS.md` | `d403592`, 2026-09-25 16:33, clean | For a later `prepublished` and `published`: a dry-run of the exact SHA first, `publish` with the full SHA, only Virginie approves. A documented-mode release reads the `### <version>` block of `PUBLICATION.md` and the `## [<version>]` section of `CHANGELOG.md`, so **`PUBLICATION.md` has to exist**. The gallery is manual. Nothing to do yet. |

## Read, not useful now

| Document | Version | Why not, and when to read it again |
|---|---|---|
| `STYLE_RIMWORLD.md` | root `90d51374`, 2026-09-25 15:25, clean | Generating and engraving the preview and the icon, which the owner alone generates. Both exist and are checked. Read it again only if the preview is regenerated or its 32 px readability is questioned. |
| `scripts/SEARCHING.md` | root `90d51374`, 2026-09-17 mtime, clean | Searching the corpus of installed mods. The defName collision check was done at the start of the port. Read it again only for a new "who else declares this" question. |

## Named in the request and not present

`PUBLICATION.md`, `BACKLOG.md`, `NOTES.md`, `BUGS.md` do not exist in this repository. `BACKLOG.md` would not be the
monorepo's in any case. `PUBLICATION.md` is required before `prepublished` (AUDIT.md, step 10): the order of the gallery
images, the thank-you comments, the dependency answer, the adult-content answer, and the `### <version>` change note.
It is not started; see `remaining` in `STATUS.md`.

## The mod's own files

`STATUS.md` `897c601` (2026-09-25 13:25), `README.md` `fb9a19a` (2026-09-24 16:51), `CHANGELOG.md` `8bc4401`
(2026-09-24 23:41), `ATTRIBUTION.md` and `Mod/ATTRIBUTION.md` modified, not committed at the time of writing (see the
commit that adds this file), `LICENSE` `1b63e37` (2026-09-19, identical to `Mod/LICENSE`), `TESTING.md` `897c601`,
`Mod/About/About.xml` `fb9a19a`, `docs/runs/history.md` `897c601`, `Tests/Pickle/` `1e27f7c` and after.

## What reading them changed

- `ATTRIBUTION.md` said "no patch" and "every stat unchanged". Both were false after the ADS 2 patch and the toxic stat.
  It now describes both, credits ADS 2 and its author, and names the AI tools and Pickle. Its copy under `Mod/` is
  identical.
- Still open, and not started, for `prepublished`: the Steam description needs the sections AUDIT.md lists (`IF I GO
  QUIET`, `AI-GENERATED`, `THANKS`, the ATTRIBUTION and licence line) and Workshop links on the mod names it cites
  (ADS 2 and the original, which is a raw URL today); `About.xml` still says "In-game validation of this port is
  pending"; and `PUBLICATION.md` does not exist. None of it blocks `tested`. The live Steam description is frozen
  and can only be corrected by hand.
- Tickets to come carry the tested SHA in their `-Label`.
