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
  - "unverified: [prepublished gate] Gallery: `Art/Gallery` holds `0-preview.png` and images 1 to 4 (image 1 the staged photograph in the Sanctuary, played and read 2026-10-06; images 2 to 4 cropped English dialogs, read 2026-10-02). Virginie has yet to look at the series as a whole and confirm its order (PUBLICATION.md, `Gallery order`)."
  - "unverified: [prepublished gate] CHANGELOG.md needs a dated `## [1.0.0]` section before the publish: the CI dry-run does not catch its absence (template check piped into head, no pipefail), and the release job then fails after the Steam upload."
  - "defect: The Workshop page of item 3806760430 still carries the description frozen at creation, which says butchering gives about 18 dust and that dust is the worst insulator in the game. It is about 6, and the worst of any material a garment can be made from. Virginie will correct it by hand on the Steam page at the MEP (2026-09-25); About.xml and the docs are already right."
code_review_sha: 856fad3e1d0c1510c483df2662baef7fb4030591
updated:      2026-10-10
protocols_read_sha: b4bb8a9157ee29ba1541b90a7e3ed4215b6574ac
---

# Dust Bunnies Renew — status

## Audit — 2026-10-10 (Claude Sonnet 5, against AUDIT.md of 2026-10-10; audited at `e1748ad`, working tree clean)

`tested` (old vocabulary) -> `shootGallery[1.0.0]`, the correspondence table's answer. `stage` removed, `code_review_sha` added.
- Transitions 1 to 8 hold (details in `docs/runs/status-journal-2026-10-10.md`): eight features played green, no `@wip`, no manual test left, code review `84e8c57..856fad3` done, no finding; no `Source/` or `Mod/` code change after `856fad3` (`e1748ad` touches `Art/Gallery` only).
- 9 `shootGallery` open: `Art/Gallery` holds `0-preview.png`, `1-bunny-at-the-bed.png`, `1-candidate-bunny-smile.png` (ticket 51e9; replaces image 1 if accepted), `2-bill-dialog.png`, `3-dust-bunny-card.png`, `4-dust-card.png`. The candidate is played and committed, **not yet opened and accepted by Virginie**, so the order (9.c) is not settled.
- Not run: no game (rule absolue); `Test-Mod.ps1` not rerun, nothing under `Mod/` changed since its PASS of 2026-10-06.
- Protocols read: AUDIT.md (whole), WELCOME.md, AGENTS.md and GALLERY.md diffs. The PUBLISHING.md, PICKLE.md, STYLE_RIMWORLD.md and TRANSLATIONS.md rewrites since `5a975b5` were only skimmed: `protocols_read_sha` records HEAD, reread those four before `mountPreview`.
- Registered with the Ticket Manager (REGISTER sent 2026-10-10, owner `local_02284246-6ece-4f7f-a760-17233cba0048`).

## Current state

`Mod/` unchanged since `077502e`. Workshop item 3806760430 stays private until Virginie switches it. CHANGELOG still needs the dated `## [1.0.0]` section, made in the commit sent to the dry-run (AUDIT.md 12.e). Earlier sections (French review, Sanctuary move to SanctuaryBacklot, dust seam fix, Nocturnal and ADS integrations, upstream PR #1): see the journal.
