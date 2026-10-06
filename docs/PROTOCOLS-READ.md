# Protocols read, and in which version

Rewritten 2026-10-06 by Claude Sonnet 5 for the AUDIT.md pass. It says what was read, at which version, what it gave this mod,
and which documents were of no use, so that a document that has not moved is not read twice. Reread a document when its
version differs from the one below. Times are local.

**How a version is read.** The protocol documents (`AGENTS.md`, `AUDIT.md`, `PUBLISHING.md`, `TRANSLATIONS.md`,
`STYLE_RIMWORLD.md`, `MOD_SETTINGS.md`, `WORKSHOP_COMMENTS.md`, `scripts/SEARCHING.md`) belong to the protocols repository, not
to the monorepo: `git log` from the monorepo returns the commit that *removed* them. From the collection root:
`git --git-dir=../rimworld-protocols.git --work-tree=. log -1 --format='%h %ci' -- <file>`; `M` in `status --short` means modified,
not committed. The tool repositories and this repository answer to plain `git log -1` in their own folder.

## Read, and useful

| Document | Version | What it gave this mod |
|---|---|---|
| `AGENTS.md` | `7fd7475`, 2026-09-29 | Evidence rules (latest report per scenario for the current revision, list before deleting, never delete what `STATUS.md` points to, one line per run in `docs/runs/`); publication through the CI only. Applied 2026-10-02. Unchanged since. |
| `AUDIT.md` | `5a975b5`, 2026-10-02 | Whole file read 2026-10-02, the diff to `5a975b5` read 2026-10-06. The chain and transition 9 (`tested`: no `@wip`, every `@requires` pass played, no manual test left, `@review` captures opened). New: **order of the passes** (new and red first, non-regression together at the end), **do not test what the mod does not modify**, **WSL cleanup** of the optional mods a mod's passes downloaded, once its last ticket is played. Session title `<packageId without nelim.> / <workflow_stage>`. |
| `PUBLISHING.md` | `d39bff2`, 2026-10-06 | Gallery rules read whole: every capture is a staged photograph except the menus; the photographer chooses place, moment, composition; one story for the series; a shooting plan in the feature header; a `Scenario:` is an image; images are opened and anomalies reported to NPT (through Ticket Manager if NPT is unreachable); full-screen windows on `exhibition-zone`; a living thing in the scene; the gallery folder starts at `0-` (a byte copy of the Preview); the Preview's ModIcon badge and the minimal set of Preview sources. Applied: image 1 rewritten, `Art/Gallery`. |
| `STYLE_RIMWORLD.md` | `97d2b35`, 2026-10-06 | Read: the Preview/ModIcon sections. **`Render-Preview.cjs` delivers `Mod/About/ModIcon.png` from the owner's `Art/ModIcon-source.png` when `Preview.config.json` has `"modIconSource"`** (applied), the minimal set of Preview sources and outputs, and **no `_`-prefixed folder at a mod's root** (`_tools/` moved to `scripts/`). |
| `PickleTools/docs/GALERIE.md`, `SANCTUAIRE-LIEUX.md`, `SANCTUAIRE-CASES.md` | PickleTools `2f81230` (the directory was read, not `git log`ged per file) | The Sanctuary fixture `Nelims-tribe`, its named places, the free cells of `sleeping-nook`, the step vocabulary; Nelim (Virginie) is the only colonist; no empty-place photographs were found on disk (`sanctuaire-places` is absent), so the place was chosen from the survey photograph of the house and the descriptions. |
| `Rimworld-Ticket-Dispatcher/docs/WELCOME.md` | `ada1ab1`, 2026-10-04 | Read whole 2026-10-02; unchanged in substance. A request carries no SHA (put it in `-Label`); a gallery pass must zoom enough. |
| `Rimworld-Ticket-Dispatcher/docs/SUBMIT.md` | `7d6c5b2`, 2026-10-04 | Options of `Submit-PickleRun.ps1`. A request can come back `invalid` with an empty owner and mod (ticket `021b`): check `-List` right after filing. |
| `TRANSLATIONS.md` | `af8427f`, 2026-10-02 | `FRENCH_REVIEW.md` and the shared generator. Unchanged since. |

## Not reread this session (moved or not), reread before use

| Document | Last read at | Note |
|---|---|---|
| `PickleTools/README.md` | `bb732f7` | Moved since 2026-09-29; reread before writing a scenario with a tool not listed here. |
| `PickleTools/docs/steps.md` | `2f81230` | Moved; steps were taken from the sources (`ScreenshotStudio/Source/*.cs`) for the gallery. |
| `PickleTools/Headless/README.md` | `ed4e73a` | Unchanged since 2026-09-26. |
| `Rimworld-Release-Admin/docs/OPERATIONS.md` | `657951b`, 2026-10-05 | Moved since 2026-09-26. Reread whole before any workflow, tag or `publish`. |
| `WORKSHOP_COMMENTS.md` | `a7e4a37`, 2026-10-06 | Moved; this mod's three rows were last read 2026-10-02 (all posted or not applicable). |
| `MOD_SETTINGS.md` | `b83933b` | Unchanged; `settings_audit: not_applicable` stands. |

## Read, not useful now

| Document | Version | Why not, and when to read it again |
|---|---|---|
| `scripts/SEARCHING.md` | `a840724`, 2026-10-06 | Searching the corpus of installed mods. The defName collision check was done at the port. Read again for a new "who else declares this" question. |

## Named in the request and not present

`NOTES.md` and `BUGS.md` do not exist in this repository and nothing calls for them. `BACKLOG.md` is the mod's own.

## The mod's own files

Edited 2026-10-06 (see the commit that adds this file): `STATUS.md`, `README.md`, `TESTING.md`, `PUBLICATION.md`, `BACKLOG.md`,
`ATTRIBUTION.md` and its copy in `Mod/`, `Tests/Pickle/`. Not edited: `CHANGELOG.md` (append-only), `LICENSE`, `Mod/About/About.xml`.
