---
localization: complete
translation_en: complete
translation_fr: complete
settings_audit: not_applicable
mod:          Dust Bunnies Renew (unofficial)
packageId:    nelim.dustbunnies
repo:         Rimworld-Dust-Bunnies-Renew
remote:       https://github.com/vbardales/Rimworld-Dust-Bunnies-Renew.git
visibility:   public
mod_visibility: public
visibility_at: Steam API GetPublishedFileDetails 2026-10-14 (visibility 0 = public) for item 3806760430; GitHub API verified 2026-09-24 (public, main)
local_path:   C:\Users\nelim\Documents\rimworld\DustBunniesRenew
detached:     yes
maintainer:   Codex and Claude Code sessions, whichever holds the mod; each audit entry below names its author
workflow_stage: playTests[1.1.0]
licence:      silent
licence_at:   original files, About, Steam description and all 9 comments, GitHub tree and README checked 2026-09-12
upstream_mod_remotes:
  - https://github.com/blockdude/csharp-rimworld-dust-bunnies
upstream_pr:  https://github.com/blockdude/csharp-rimworld-dust-bunnies/pull/1 (opened 2026-09-28, 1.6 support + the wildness, ToxicSensitivity and DefOf fixes; unanswered)
port_licence: MIT, limited to port additions described in LICENSE
dependencies: none required; optional integrations with SamBucher.ADogSaidAnimalProsthetics2 (loadBefore) and Mlie.XNDNocturnalAnimals (MayRequire on an extension)
showcase:     complete
tested_on:    re-audited 2026-10-02 against AUDIT.md transition 9 (all criteria met, see the audit entry below); 2026-09-24 and 25, seven in-game Pickle runs: all eight features played and green in some run (07 in its pass, 08 in its own); three defects found and fixed, each re-run green; ADS category 1 confirmed and no new game needed (Virginie, 2026-09-25); French capture (ticket 8015) opened and read on 2026-09-26: no clipping, raw key or fallback
workshop:     3806760430
remaining:
  - "unverified: [prepublished gate] CHANGELOG.md needs a dated `## [1.0.0]` section before the publish: the CI dry-run does not catch its absence (template check piped into head, no pipefail), and the release job then fails after the Steam upload."
  - "unverified: the Workshop page of item 3806760430 still carries the description frozen at creation (butchering about 18 dust, dust the worst insulator in the game; it is about 6, and the worst of any material a garment can be made from). `publish.config.json` makes `PUBLICATION.md` the description source: check that the 1.0.0 dispatch updates the description (update_description) and, after it, that the Steam page reads as `PUBLICATION.md`. No manual correction planned."
code_review_sha: 46b475822f7d1cbb1902422969e649ab93d81417
publication_changelog_review_sha: 46b475822f7d1cbb1902422969e649ab93d81417
echo_review_sha: 8bd0da688ce2576d1d8e3e9ed60a95a57bb16300
social_preview_sha256: f7fa401ed95fb5183ffc772f2ff36fee20f3fdfc8f70a4948eeb364e2c29e78e
updated:      2026-10-14
protocols_read_sha: c94c7bd9c6954f001038a6202ae288fd8c078915
---
# Dust Bunnies Renew — status

## Audit — 2026-10-10 (Claude Sonnet 5, against AUDIT.md of 2026-10-10; audited at `e1748ad`, working tree clean; full replay of 1 to 8)

`tested` (old vocabulary) -> `shootGallery[1.0.0]`. `stage` removed, `code_review_sha` added. Checked on artifacts, not on this file:
- 4 `declareDependencies`: About.xml no hard dependency, `loadBefore` ADS 2, `incompatibleWith` original (BlockHen.Animal.DustBunnies), no LoadFolders (single 1.6 folder). ADS 2 patch = one `PatchOperationConditional` on `ADS_Cat1`, no MayRequire on Operation; Nocturnal `MayRequire` on `<li>`. 4.f: ADS 2 and Nocturnal done and played; Dogs mate not applicable; Better Crossbreeding open (remaining).
- 5 `auditSettings`: no settings, no page, no C# options: `settings_audit: not_applicable` stands.
- 6 `localize`: 4 French DefInjected files read whole, 12 keys, none agrees with pawn (jobStrings third-person verbs): no gender switch needed. `FRENCH_REVIEW.md` regenerated (new header, revision `5e55d2a`); French reviewed, validated by Virginie 2026-10-02, texts unchanged since.
- 7 `writeTests`: `scripts/Test-Mod.ps1` **rerun 2026-10-10: PASS** ("EVERY CLAIM HOLDS", 9 XML files, 12 keys, 0 errors). Feature suites and pass maps exist (`Tests/Pickle/`: ads2, nocturnal, captures-fr, gallery, incompat-original). TESTING.md stale (remaining).
- Build folder renamed `.build/` to `build/` 2026-10-11 (owner said "renomme"): only `Source/` and `scripts/Test-Mod.ps1` path edits; `code_review_sha` moved to that commit after reviewing diff (four path substitutions); DLL SHA-256 byte-identical before and after (2D6203...F580B), `Test-Mod.ps1` PASS again.
- 8 `playTests`: eight features played green (`docs/runs/history.md`, not replayed: no game). `Mod/` last changed at `5e55d2a` (Dust textures 64 x 64, `drawSize` 0.75), played by ticket b8bb on that tree; code review `84e8c57..856fad3` covers it, no finding; `Source/` and `Mod/` untouched since.
- 9 `shootGallery` open: `Art/Gallery` holds only `0-preview.png` and `1-bunny-at-the-bed.png`. Images 2, 3, 4 (menus on test colony) refused, deleted 2026-10-12: retaken in Sanctuary by ticket `2107`, framed 1600 x 900 after. Image 1: candidate refused (monobrow), refiled with SanctuaryBacklot's own-face step (ticket `5726`). Order (9.c) not settled.
- Protocols read: AUDIT.md, WELCOME.md whole; AGENTS.md, GALLERY.md, TRANSLATIONS.md, PUBLISHING.md diffs; ANIMALS.md whole; PICKLE.md (teardown, publication captures), STYLE_RIMWORLD.md (root folders) read in parts concerning this state. STYLE_RIMWORLD.md Preview/echo sections read at `mountPreview`.
- 1 to 3 rechecked on artifacts (2026-10-11): README title, UNOFFICIAL paragraph, `ATTRIBUTION.md`, `LICENSE` identical to `Mod/` copies, `CHANGELOG.md` has `[Unreleased]` over `[0.1.0]`, `main` equals `origin/main`, GitHub repository PUBLIC, `PublishedFileId.txt` 3806760430, no `.dds`/`.ico`/`desktop.ini` tracked under `Mod/`, DLL rebuilt byte-identical. ModIcon 128 x 128 RGBA, 37 KB (above 20 to 30 KB range, owner's source); at 32 px bunny face stays legible. Preview 896 x 504, 572 KB, byte-identical to `Art/Gallery/0-preview.png`. `social_preview_sha256` not recorded in STATUS (upload done 2026-10-07): record at `mountPreview` (10.f).
- 7.d checked: TESTING.md declares seven passes in three families (without optional mods, one per optional integration, one for declared incompatibility), pass order, WSL cleanup. `Prune-Evidence.ps1` dry run: nothing to prune (15 kept, three superseded folders still named in `docs/runs/`). TESTING.md also claims `Mod/` unchanged since `077502e`: false, `5e55d2a` changed Dust textures and `drawSize`; no scenario reads Dust graphic except `12-dust-seam-diagnostic`, so non-regression set at `followUp` stands, now to be written as such.
- 4.f closed 2026-10-11: Better Crossbreeding not applicable. Virginie (chat, 2026-10-11) chose "rien": dust bunny stays genderless, never mates (`hasGenders` false, `mateMtbHours` 0, inherited from original); breeding would bypass 100-dust cost. Dogs mate not applicable same reason. Reasons in `BACKLOG.md`, item 2.
- Local scripts normalised 2026-10-11 (Audit via TM, AGENTS.md "Local scripts"): local copies of Check-DefInjected, Check-DefRefs, Check-XmlFields, Check-XmlClasses, Check-Steps, Minify-Evidence deleted (shared ones used); `scripts/Test-Mod.ps1` calls the shared checks, PASS. Kept in `scripts/LOCAL_SCRIPTS.md`: Check-Claims, Test-Mod.ps1. `FUNCTIONAL-SCENARIOS.md` renamed `TEST_SCENARIOS.md`.
- Registered with Ticket Manager (2026-10-10, confirmed; owner `local_02284246-6ece-4f7f-a760-17233cba0048`).

## Current state

Defs and source unchanged since `5e55d2a` (About.xml, ATTRIBUTION.md, Preview changed since, text and image only). Workshop item 3806760430 stays private until Virginie switches it. CHANGELOG still needs dated `## [1.0.0]` section, made in commit sent to dry-run (AUDIT.md 12.e). Earlier sections (Sanctuary move, dust seam fix, integrations, upstream PR #1): `docs/runs/status-journal-2026-10-10.md`.

## Cleanup — 2026-10-13 (Claude Sonnet 5.5)

TESTING.md rewritten against current state (12 features, `playTests` vocabulary, full-pass rule of 2026-10-13, Dust change at `5e55d2a` joins non-regression set). Root: `preview-workflow.md` deleted (stale, described withdrawn pipeline; `PUBLICATION.md` now points to `STYLE_RIMWORLD.md`), `desktop.

Code review reopened 2026-10-13 by two `Mod/` commits since `765ad84` (AUDIT.md 8.m): `Mod/About/About.xml` (description text: no RimWorld version), `Mod/ATTRIBUTION.md` (em dashes), `Mod/About/Preview.png` (re-rendered with echo source, byte-identical to `Art/Gallery/0-preview.png`). Diff `765ad84..d2f2fb968cdf7e866d66e29e800a9f17eb80d347` read whole: no `Source/` change, no Def, patch, texture change, so no code to review; DLL SHA-256 still `2D6203...F580B`. `code_review_sha` moved to d2f2fb968cdf7e866d66e29e800a9f17eb80d347.

## Gallery — 2026-10-13, accepted by Virginie (AUDIT.md 9, `shootGallery` -> `mountPreview`)

| Index | File | Shows | Frame |
|---|---|---|---|
| 0 | `0-preview.png` | byte copy of `Mod/About/Preview.png` | 896 x 504 |
| 1 | `1-bunny-at-the-bed.png` | the live dust bunny at the foot of Nelim's bed, Sanctuary `sleeping-nook`, midday | 1920 x 1080 |
| 2 | `2-bill-dialog.png` | the "Make a dust bunny" bill, 100x dust | 1600 x 900 |
| 3 | `3-dust-bunny-card.png` | the dust bunny's information card, on `window-backdrop-for-height` | 1200 x 1080 |
| 4 | `4-dust-card.png` | the dust's information card, same backdrop | 1200 x 1080 |

Order 1 to 4 confirmed (first image large on Steam: most demonstrative). Indexes contiguous, 4.1 MB total, no `candidate` left. Runs: tickets `82d4` (cards), Sanctuary run 2026-10-12 (images 1, 2), `docs/runs/history.md`. Next, `mountPreview`: echo review (`echo_review_sha`), GitHub social preview upload (`social_preview_sha256`).

## Echo review — 2026-10-14 (mountPreview, AUDIT.md 10.a)

`Art/echo-source.png` kept. Yellow line-art of in-game dust bunny (grey rabbit, long ears, round tail), same animal and pose family as gallery images 1 and 3, so Preview and gallery show one subject; mod's subject has not moved. In rendered Preview echo's nose touches closing parenthesis of "(unofficial)", ears pass behind end of title: placement matter in `Art/Preview.config.json`, not echo mismatch, Preview already accepted, so not reopened for taste. `echo_review_sha: 8bd0da688ce2576d1d8e3e9ed60a95a57bb16300`.

## Social preview — 2026-10-14 (mountPreview 10.f)

`Mod/About/Preview.png` uploaded as GitHub social preview by session, through Virginie's logged-in Chrome (Settings, Social preview, upload; her "fais-le"), 2026-10-14. After reload Social preview panel shows new Preview (echo against "(unofficial)", 1.6 badge). Sha256 is uploaded file's, not read back from GitHub (CORS blocks fetching served image): `social_preview_sha256: f7fa401ed95fb5183ffc772f2ff36fee20f3fdfc8f70a4948eeb364e2c29e78e`. `mountPreview` -> `writeDocs[1.0.0]`.

## writeDocs checks — 2026-10-14 (Claude Sonnet 5.5, at `e0853ea`; AUDIT.md 11)

- 11.a, 11.b: Steam description is one block under `## Steam description`, English: UNOFFICIAL paragraph, body, WHAT THE PORT FIXED, IF I GO QUIET with adoption clause word for word (grep against PUBLISHING.md), AI-GENERATED (Claude and Codex), THANKS (ADS 2 and Nocturnal Animals by authors, Harmony, Pickle, RimLogging, Pickle Tools as development tools only), ATTRIBUTION line, last `Source code on GitHub` to `vbardales/Rimworld-Dust-Bunnies-Renew`. Workshop links not opened remotely this session.
- 11.c: `sync-about-description.mjs` says `About.xml` description already plain text of `PUBLICATION.md`; `<url>` is repository.
- 11.d: Workshop link on every cited mod with a page (ADS 2, Nocturnal Animals, its original, Harmony, Pickle, RimLogging, Pickle Tools, original Dust Bunnies); original authors 2blockdude and HendraGradeWood credited.
- 11.e: gallery order, table aligned with this file (2026-10-13), dependencies and DLC, adult content answered.
- 11.f: `[Unreleased]` holds version's changes; becomes `## [1.0.0]` at dry-run (12.e).
- 11.g: no adult content; four gallery images and Preview all opened this week.
- 11.h: thank-you comments all `posted` or not applicable (registry); 11.i: 1.0.0 release note draft, first line `[b]1.0.0[/b]`, in `PUBLICATION.md`, reread when sent.
- 11.j done 2026-10-14: Virginie validated PUBLICATION.md and CHANGELOG.md in chat (line 1.0), reviewed commit `publication_changelog_review_sha`. `writeDocs` -> `prepareRelease[1.0.0]`.

Code review sha moved again 2026-10-14 to `092ead7433b132936fdc74ffaa402131e99211b0`: only `Mod/` change since previous move is two description phrases in `Mod/About/About.xml` ("No DLC or required dependencies", "from which clothes can be made"); no Source, Def, patch, texture change. Steam description changed, so Virginie's review of `PUBLICATION.md` (11.j) covers text after these edits.

## Dry-run — 2026-10-14 (AUDIT.md 12.e)

`CHANGELOG.md` dated (`## [1.0.0] - 2026-10-14`) in `46b475822f7d1cbb1902422969e649ab93d81417`, commit to publish. Dry-run run `38548161850` (`publish-tag.yml`, `mode=dry-run`, `update_preview=true`, `update_description=true`) green, log read: `Publishing 46b475822f7d1cbb1902422969e649ab93d81417 as version 1.0.0`; build reproduces tracked `Mod/` byte for byte (0 warnings, 0 errors); `About.xml` description is plain text of `PUBLICATION.md`; change note `[b]1.0.0[/b]` + 1.0.0 paragraph; preview to send `Mod/About/Preview.png` sha256 `f7fa401e...e78e` (same as `social_preview_sha256`); description 4955 characters converted from `PUBLICATION.md`, Markdown to BBCode, text as expected; public page not readable (item private), so no diff possible. Gallery (5 files) not sent by CI: upload by hand on Steam page. `code_review_sha` and `publication_changelog_review_sha` both moved to this commit: only change since reviewed text is dated CHANGELOG header, Virginie's validation of 2026-10-14 covers it (no Source, Def, patch, texture change). Rollback target: v0.1.0^{commit} (`v0.1.0`), with higher version.

## Publish dispatched — 2026-10-14

`steam-production` created by Virginie (`steam-secrets-codespace.sh`). `dispatch-publish.sh` accepted dry-run `38548161850`; publish run `38549198976` on `46b475822f7d1cbb1902422969e649ab93d81417`, version 1.0.0, `--preview --description`, waiting for Virginie's approval. After: commit `Mod/About/PublishedFileId.txt` if changed, check Steam page (description, change note, preview), upload five gallery images by hand, switch item to public (Virginie), then `followUp`.

## Published — 2026-10-14 (AUDIT.md 13.a, 13.b)

Run `38549198976` green (job `publish` 1m40s, then `tag-and-release`), approved by Virginie, on `46b475822f7d1cbb1902422969e649ab93d81417`: tag `v1.0.0` and GitHub release "Dust Bunnies Renew (unofficial) 1.0.0" created by CI; description and Preview sent with version. `Mod/About/PublishedFileId.txt` unchanged (3806760430), nothing to commit. Item still private, page not read from outside: check once public (description, change note `[b]1.0.0[/b]`, header image). Still for Virginie: upload five images of `Art/Gallery` on Steam page in order 0 to 4, test private page by subscription, switch item to public (13.c). Then `followUp[1.0.0]`: non-regression pass, thank-you comments (already posted), cleanup.
Upstream: PR https://github.com/blockdude/csharp-rimworld-dust-bunnies/pull/1 ("Add 1.6 support", opened 2026-09-28) still OPEN, no comment, no review. Its 1.6 folder carries same three fixes as this port (wildness under statBases, ToxicResistance, DefOf), without this repository's later work. Nothing posted there without Virginie's word.

## Public — 2026-10-14 (AUDIT.md 13.b, 13.c, 13.f)

Virginie switched item 3806760430 to public (her word, chat, 2026-10-14). Checked from outside: Steam `GetPublishedFileDetails` returns `visibility` 0 (public), not banned, tags `Mod` and `1.6`, description 4955 characters (text sent, with "No DLC or required dependencies" and "from which clothes can be made"), `time_updated` 2026-10-14T10:26Z; change-notes page shows `1.0.0` and "First public version: the port of Dust Bunnies to the latest RimWorld version...". Workshop page lists 6 distinct images (header plus gallery, uploaded by Virginie). Thank-you comments: nothing to post, every row of `WORKSHOP_COMMENTS.md` for this mod is `posted` (Harmony, Pickle, RimLogging, ADS 2, Nocturnal Animals) or `not_applicable` (original Nocturnal, PickleTools). Remaining at `followUp`: non-regression pass on published revision (AUDIT.md 14.a), cleanup before sleep (14.c, 14.d), upstream PR left for Virginie to decide.

Non-regression (14.a) filed 2026-10-14 on published tree (`46b4758` plus STATUS only), seven small tickets, one per pass of TESTING.md: `c68e` (1 English), `8b85` (2 French), `f564` (3 incompatibility, `07`), `d21f` (4 ADS 2, `08`), `8a09` (5 Nocturnal, `09`), `8058` (6 French dialogs, `10`), pass 7 (gallery `11` and `12`, refiled after `addf` cancelled for wrong filter syntax). Results go to `docs/runs/history.md`.

Upstream, 2026-10-14 (Virginie's word): comment posted on PR #1 (issuecomment-6166449631) pointing to published port; thank-you comment posted by Virginie on original Workshop page 2659958183 (register row `posted`). Nothing else owed upstream.

1.7 pass opened 2026-10-14 (Virginie's word: minor bump to 1.1.0 for RimWorld 1.7; AUDIT.md "Passe 1.7"). Stage `playTests[1.1.0]`: 1.0.0 followUp (non-regression tickets c68e, 8b85, f564, d21f, 8a09, 8058, 6af7 on 1.6, cleanup 14.c/14.d) stays open, resumes after. Mod has DLL (`net472`); first test as is on 1.7. Ticket `20261014-124426-086-5173` filed on `/home/nelim/rimworld17`, English only, features 01 to 05 (loads, gather dust, make a dust bunny, save and reload, English labels), run deleted (superseded by the parked repro). Held back on 1.7: 06 and 10 (French, no French pack on 1.7), 07 (original mod 1.6 only), 08 and 09 (optional mods, own 1.7 status unknown), 11 and 12 (gallery, Sanctuary). No `<li>1.7</li>`, no version bump, no CHANGELOG entry until run green (AUDIT.md "Quand"). `tested_1_7` absent until then.

Non-regression 2026-10-15: `8b85` (pass 2 French) filed without filter, so also ran `05-labels-en` in French and that failed, as it must: filing error, not defect (core and `06-labels-fr` passed). Refiled with `-Filter "01-loads,06-labels-fr"` as `20261015-085521-912-ed6e`, evidence `2026-10-14-nonreg-french-2`. Other tickets: check filter of each on arrival.

Non-regression result 2026-10-15 (AUDIT 14.a), published tree `46b4758`: passes 2 to 7 green (`ed6e` 2/2, `f564`, `d21f`, `8a09`, `8058` 1/1 each, `6af7` 5/5). Pass 1: `c68e` filed unfiltered, only failure is French label scenario in English run (filing error); 01 to 05 passed; clean refile filed. No defect in published version so far.

1.7 bill reds, state 2026-10-19: ticket `5173` 6 of 8 green; `02-gather-dust` and `03-make-a-dust-bunny` RED (colonist never makes the Crafting bill), red again on the 2026-10-15 repro (parked in `Tests/Pickle/Parked/2026-10-15-1.7-bills`, RELEASE.md: both green on 1.7). Repro `stdout.txt`: 1.6 fixture save on 1.7, `Could not find think node` warnings, `Dialog_MessageBox` open at entry. Diagnostic ticket `1d08` (feature `13-bill-diagnostic`, evidence `Tests/Pickle/Evidence/2026-10-17-1.7-bill-diagnostic`): Sweeper not blocked, all preconditions ok; `shouldDoNow=True` at snapshots 1-2, False at 3 (`JobOnThing=null`) while busy on `HaulToCell` Steel. Open: why `shouldDoNow` flips (bill repeat mode, dust count, Steel stock); The "exception" of the first read was only the log call stack trace, `LogWorkState` did not throw. Same Steel haul target for 1800 ticks while Sweeper walks (107,209 to 123,190), bench at (146,155). Diagnostic v2 (repeat mode, repeat count, Dust count, other colonists jobs) filed 2026-10-19 as `20261019-230516-846-42c2` on `/home/nelim/rimworld17`, evidence `Tests/Pickle/Inbox/2026-10-19-1.7-bill-diagnostic-2`. Then refile 02 and 03. Whether Pickle bill-steps suite is green on 1.7 unknown (TM has no reachable Pickle session). `tested_1_7` stays absent; no `<li>1.7</li>`.

Evidence sorted 2026-10-19 (AGENTS.md "Test evidence"): `Evidence/` 1.3 MB, 8 minified greens each with `RELEASE.md`; `Parked/` 1 entry; `Inbox/` empty.

1.7 bill diagnostic v2, read 2026-10-25: ticket `20261019-230516-846-42c2` DONE 2026-10-21, 1/1 passed (scenario is a log dump, green by design), evidence `Tests/Pickle/Inbox/2026-10-19-1.7-bill-diagnostic-2` (stdout.txt 227 KB, capped at 2000 lines, carries the three work-state snapshots; not yet read: reading it needs a text search, to ask Virginie). Next: read snapshots (repeat mode, repeat count, Dust count, other colonists' jobs), then refile 02 and 03. `tested_1_7` stays absent.
