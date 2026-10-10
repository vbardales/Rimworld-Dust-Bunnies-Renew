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
visibility_at: GitHub API verified 2026-09-24 (public, main); Workshop item 3806760430 created by the 0.1.0 prepublication on 2026-09-23, which Steam creates private; the switch to public is not recorded
local_path:   C:\Users\nelim\Documents\rimworld\DustBunniesRenew
detached:     yes
maintainer:   Codex and Claude Code sessions, whichever holds the mod; each audit entry below names its author
workflow_stage: shootGallery[1.0.0]
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
  - "defect: TESTING.md is stale: says the mod was never loaded by RimWorld, last run 2026-09-24 at 1b63e37 (8 XML files, now 9), still uses the old vocabulary (done, tested, prepublished) and 'eighteen scenarios / seven passes' without matching docs/runs/history.md. Rewrite against the current state."
  - "defect: root of the repository carries stray files (desktop.ini ignored, french-review-english.json kept on purpose, preview-workflow.md from the withdrawn pipeline); check each against STYLE_RIMWORLD.md root rule."
  - "unverified: [declareDependencies 4.f] Better Crossbreeding: BACKLOG.md item 2 recommends nothing (the bunny never mates, hasGenders false, mateMtbHours 0) but the decision is open; Dogs mate recorded not applicable. Virginie confirms or asks for a joke outcome."
  - "unverified: em dash (U+2014) rule of 2026-10-10 in README, PUBLICATION, ATTRIBUTION (root and Mod/), TESTING, BACKLOG, scripts/FUNCTIONAL-SCENARIOS.md; the Steam description and About.xml are clean. CHANGELOG is append-only."
  - "unverified: [prepublished gate] Gallery: `Art/Gallery` holds `0-preview.png` and images 1 to 4 (image 1 the staged photograph in the Sanctuary, played and read 2026-10-06; images 2 to 4 cropped English dialogs, read 2026-10-02). Virginie has yet to look at the series as a whole and confirm its order (PUBLICATION.md, `Gallery order`)."
  - "unverified: [prepublished gate] CHANGELOG.md needs a dated `## [1.0.0]` section before the publish: the CI dry-run does not catch its absence (template check piped into head, no pipefail), and the release job then fails after the Steam upload."
  - "defect: The Workshop page of item 3806760430 still carries the description frozen at creation, which says butchering gives about 18 dust and that dust is the worst insulator in the game. It is about 6, and the worst of any material a garment can be made from. Virginie will correct it by hand on the Steam page at the MEP (2026-09-25); About.xml and the docs are already right."
code_review_sha: 765ad84cc5f97c379ae03146516195f23869890a
updated:      2026-10-10
protocols_read_sha: a5c7cf48b349ae00e7d28fd643e852dc860dfaf2
---

# Dust Bunnies Renew — status

## Audit — 2026-10-10 (Claude Sonnet 5, against AUDIT.md of 2026-10-10; audited at `e1748ad`, working tree clean; full replay of 1 to 8)

`tested` (old vocabulary) -> `shootGallery[1.0.0]`. `stage` removed, `code_review_sha` added. Checked on artifacts, not on this file:
- 4 `declareDependencies`: About.xml has no hard dependency, `loadBefore` ADS 2, `incompatibleWith` the original (BlockHen.Animal.DustBunnies), no LoadFolders (single 1.6 folder). ADS 2 patch is one `PatchOperationConditional` on `ADS_Cat1`, no MayRequire on an Operation; Nocturnal is `MayRequire` on a `<li>`. 4.f: ADS 2 and Nocturnal done and played; Dogs mate not applicable; Better Crossbreeding open (remaining).
- 5 `auditSettings`: no settings, no page, no C# options: `settings_audit: not_applicable` stands.
- 6 `localize`: the 4 French DefInjected files read whole, 12 keys, none agrees with a pawn (jobStrings are third-person verbs): no gender switch needed. `FRENCH_REVIEW.md` regenerated (new header, revision `5e55d2a`); French reviewed and validated by Virginie 2026-10-02, texts unchanged since.
- 7 `writeTests`: `scripts/Test-Mod.ps1` **rerun 2026-10-10: PASS** ("EVERY CLAIM HOLDS", 9 XML files, 12 keys, 0 errors). Feature suites and pass maps exist (`Tests/Pickle/`: ads2, nocturnal, captures-fr, gallery, incompat-original). TESTING.md stale (remaining).
- Build folder renamed `.build/` to `build/` on 2026-10-11 (owner said "renomme"): `Source/` and `scripts/Test-Mod.ps1` path edits only; `code_review_sha` moved to that commit after reviewing its diff (four path substitutions); DLL SHA-256 byte-identical before and after (2D6203...F580B), `Test-Mod.ps1` PASS again.
- 8 `playTests`: eight features played green (`docs/runs/history.md`, not replayed: no game). `Mod/` last changed at `5e55d2a` (Dust textures 64 x 64, `drawSize` 0.75), played by ticket b8bb on that tree; code review `84e8c57..856fad3` covers it, no finding; `Source/` and `Mod/` untouched since.
- 9 `shootGallery` open: `Art/Gallery` holds `0-preview.png`, `1-bunny-at-the-bed.png`, `1-candidate-bunny-smile.png` (ticket 51e9, replaces image 1 if accepted), `2-bill-dialog.png`, `3-dust-bunny-card.png`, `4-dust-card.png`. Candidate not yet accepted by Virginie; order (9.c) not settled.
- Protocols read: AUDIT.md, WELCOME.md whole; AGENTS.md, GALLERY.md, TRANSLATIONS.md, PUBLISHING.md diffs; ANIMALS.md whole; PICKLE.md (teardown, publication captures) and STYLE_RIMWORLD.md (root folders) read in the parts that concern this state. STYLE_RIMWORLD.md Preview/echo sections are read at `mountPreview`.
- 1 to 3 rechecked on artifacts (2026-10-11): README title and UNOFFICIAL paragraph, `ATTRIBUTION.md` and `LICENSE` identical to their `Mod/` copies, `CHANGELOG.md` has `[Unreleased]` over `[0.1.0]`, `main` equals `origin/main`, GitHub repository PUBLIC, `PublishedFileId.txt` 3806760430, no `.dds`/`.ico`/`desktop.ini` tracked under `Mod/`, DLL rebuilt byte-identical. ModIcon 128 x 128 RGBA, 37 KB (above the 20 to 30 KB range, owner's source); read at 32 px: the bunny face stays legible. Preview 896 x 504, 572 KB, byte-identical to `Art/Gallery/0-preview.png`. `social_preview_sha256` is not recorded in STATUS (upload done 2026-10-07): to record at `mountPreview` (10.f).
- 7.d checked: TESTING.md declares seven passes in the three families (without optional mods, one per optional integration, one for the declared incompatibility), the order of the passes and the WSL cleanup. `Prune-Evidence.ps1` dry run: nothing to prune (15 kept, three superseded folders still named in `docs/runs/`). TESTING.md also claims `Mod/` unchanged since `077502e`: false, `5e55d2a` changed the Dust textures and `drawSize`; no scenario reads the Dust graphic except `12-dust-seam-diagnostic`, so the non-regression set at `followUp` stands, now to be written as such.
- Registered with the Ticket Manager (2026-10-10, confirmed; owner `local_02284246-6ece-4f7f-a760-17233cba0048`).

## Current state

`Mod/` unchanged since `5e55d2a`. Workshop item 3806760430 stays private until Virginie switches it. CHANGELOG still needs the dated `## [1.0.0]` section, made in the commit sent to the dry-run (AUDIT.md 12.e). Earlier sections (Sanctuary move, dust seam fix, integrations, upstream PR #1): `docs/runs/status-journal-2026-10-10.md`.
