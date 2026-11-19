---
localization: complete
translation_en: complete
translation_fr: complete
translation_zh: complete
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
workflow_stage: shootGallery[1.1.0]
tested_1_7:   yes
licence:      silent
licence_at:   original files, About, Steam description and all 9 comments, GitHub tree and README checked 2026-09-12
upstream_mod_remotes:
  - https://github.com/blockdude/csharp-rimworld-dust-bunnies
upstream_pr:  https://github.com/blockdude/csharp-rimworld-dust-bunnies/pull/1 (opened 2026-09-28, 1.6 support + the wildness, ToxicSensitivity and DefOf fixes; unanswered)
port_licence: MIT, limited to port additions described in LICENSE
dependencies: none required; optional integrations with SamBucher.ADogSaidAnimalProsthetics2 (loadBefore) and Mlie.XNDNocturnalAnimals (MayRequire on an extension)
showcase:     complete
tested_on:    2026-11-07 pickle 55f7f90 (1.7, English: 02 and 03 green, c546 3/3); 2026-10-15 pickle 46b4758 (1.6, non-regression 2 to 7 green). Earlier: re-audited 2026-10-02 against AUDIT.md transition 9 (all criteria met, see the audit entry below); 2026-09-24 and 25, seven in-game Pickle runs: all eight features played and green in some run (07 in its pass, 08 in its own); three defects found and fixed, each re-run green; ADS category 1 confirmed and no new game needed (Virginie, 2026-09-25); French capture (ticket 8015) opened and read on 2026-09-26: no clipping, raw key or fallback
workshop:     3806760430
ecosystem_line: 1.1
upstream_synced: 2026-11-19 csharp-rimworld-dust-bunnies@012eff6
workshop_required_items: n/a, no mandatory Workshop dependency (About.xml has none)
remaining:
  - "before mountPreview: ATTRIBUTION.md has no \"Gallery set\" section: credit every third-party mod of Tests/Pickle/wsl-deps.gallery.map by name, author and Workshop id (GALLERY-PROPS.md rule 2026-11-20, Check-Status gallery-credits)"
  - "waits for Virginie: explicit oui to move to mountPreview (AGENTS.md rule 2026-11-19); gallery 1 to 7 ready, replay ledger 2026-11-19 reaches 10.a; Check-Textures ERROR on Dust_Bunny_north and _south (Audit: ship copies of _east in Mod/Textures, reopens code review and playTests, needs her decision)"
  - "open 10.a and 10.a bis: echo_review_sha stale (Art/Gallery images 1 to 4 changed since 8bd0da68); decide echo keep or redo, then Preview-source keep or redo (preview_source_decision), then re-render Preview (10.c) and check it (10.d)"
  - "open 10.e: root closed list (french-review-english.json and scripts/ deletions committed 2026-11-19; Docs/PROTOCOLS-READ.md and Docs/runs/status-journal-2026-10-10.md to delete by the AGENTS.md migration; TESTING.md still links the deleted scripts/TEST_SCENARIOS.md)"
  - "defect (script, for Audit): Check-Textures reports Dust_Bunny_north and _south missing for the DustBunny multi graphic (only _east shipped, the game falls back to it, every Pickle run green)"
  - "open 11.e: PUBLICATION.md Gallery order text for images 1 and 2 and its State paragraph still describe the old sweep and carry scenes (Nelim now stands still, Dust drawn x3.5)"
  - "unverified: sync-nsb-npt warns (NSB changed 2026-11-17, NPT steps 2026-11-19): run before any scenario replay"
  - "later, at publication: supportedVersions 1.7, version 1.1.0, CHANGELOG 1.1.0 section, Preview redo"
code_review_sha: 6beab6ac407beedc1718dd4d76e7fa6657b19304
publication_changelog_review_sha: 46b475822f7d1cbb1902422969e649ab93d81417
echo_review_sha: 8bd0da688ce2576d1d8e3e9ed60a95a57bb16300
social_preview_sha256: 2775d59be589ba7f19f9ea6af2919e05e98e6069686220e2ede1e28d0f757d4f
updated:      2026-11-19
protocols_read_sha: 46414c6b307fcc8fea18c448197a4ff0c1ca3bd9
---
# Dust Bunnies Renew — status

## Current state

Published 1.0.0 on 2026-10-14, public. Version 1.1.0 in preparation: Simplified Chinese added, 1.7 English green, gallery of 1.1.0 done (images 1 to 4 story scenes, 5 to 7 interface windows, subtitles burnt). Code review 2026-11-19 (8.m): diff d3b6b26..HEAD over Mod and Source holds only the four new Mod/Languages/ChineseSimplified/DefInjected files (display texts), Check-Translations and Check-DefInjected green: revue du diff : images et texte seuls, code_review_sha moved to HEAD. Workshop description synced by the 1.0.0 dispatch (CHANGELOG has the dated 1.0.0 section).

## Settings audit

settings_audit: not_applicable (verified 2026-11-19, first recorded in the audit of 2026-10-10). Inventory: no ModSettings, no Mod subclass, no settings page, no MainButtons entry; Source holds DustBunnies.csproj, DustBunniesDefOf.cs, Recipe_SpawnDustBunny.cs only. Decision: no useful setting (one recipe, one animal, fixed values from the original); no empty page and no shortcut exist.

## Translation audit

English source texts in Defs (11 keys), French and ChineseSimplified DefInjected (RecipeDef, PawnKindDef, ThingDef x2, 11 keys each), no Keyed. Check-Translations PASS (11 source texts) and Check-DefInjected 0 errors on 2026-11-19. French: no tu, no vous, no gender agreement needed (jobStrings third person). Review: ChatGPT page 1 of 1 on 2026-11-15, one applied (zh Dust.description), one rejected (French 'Fait de mouton', Docs/review-refusals.md); French and Chinese review validated by Virginie 2026-11-16 at revision f8dc154. Chinese written with Claude, not native-checked (stated in PUBLICATION.md Languages). In-game raw keys, fallback text and clipping checked by ticket 8015 (2026-09-26, French) and 6-labels-fr, 10-french-dialogs green.

## Gallery 1.1.0 (9.c, 9.e)

Order justified: 1 leads (the heap and Nelim sweeping: the one image that says what the mod does, readable at 268 px); 2 the price (a hundred dust); 3 the payoff (the bunny walks); 4 the night (Nocturnal Animals, it stays awake); 5 to 7 interface windows (cost, stats, dust). Subtitles burnt on 1 to 4.

| index | file | scene | opened 2026-11-19 |
|---|---|---|---|
| 0 | 0-preview.png | copy of Mod/About/Preview.png (cmp identical) | yes |
| 1 | 1-sweep.jpg | terrace 8 h, Nelim by two big dust piles | yes, candidate |
| 2 | 2-armful.jpg | terrace 11 h, Nelim by the pile, pot in frame | yes, candidate |
| 3 | 3-first-steps.jpg | terrace 18 h, the bunny walking | yes, candidate |
| 4 | 4-night-shift.jpg | sleeping-nook 23 h, Nelim asleep, bunny awake | yes, candidate |
| 5 | 5-bill-dialog.png | Make a dust bunny bill dialog, 1600 x 900 | yes |
| 6 | 6-dust-bunny-card.png | dust bunny info card, 1200 x 1080 | yes |
| 7 | 7-dust-card.png | Dust info card, 1200 x 1080 | yes |

Originals without subtitle in Art/Gallery-clean (1 to 4, jpg under 2 MB). Run proof: Tests/Pickle/Evidence/2026-11-18-gallery-final12-fullres.

## Public — 2026-10-14 (AUDIT.md 13.b, 13.c, 13.f)

Virginie switched item 3806760430 to public (her word, chat, 2026-10-14). Checked from outside: Steam `GetPublishedFileDetails` returns `visibility` 0 (public), not banned, tags `Mod` and `1.6`, description 4955 characters (text sent, with "No DLC or required dependencies" and "from which clothes can be made"), `time_updated` 2026-10-14T10:26Z; change-notes page shows `1.0.0` and "First public version: the port of Dust Bunnies to the latest RimWorld version...". Workshop page lists 6 distinct images (header plus gallery, uploaded by Virginie). Thank-you comments: nothing to post, every row of `WORKSHOP_COMMENTS.md` for this mod is `posted` (Harmony, Pickle, RimLogging, ADS 2, Nocturnal Animals) or `not_applicable` (original Nocturnal, PickleTools). Remaining at `followUp`: non-regression pass on published revision (AUDIT.md 14.a), cleanup before sleep (14.c, 14.d), upstream PR left for Virginie to decide.
1.7 result 2026-11-07: ticket `c546` (03 alone) 3/3 passed (`make-bunny` file: make a dust bunny, size and yield, train guard and attack), lane azure. With `2d06` (02 green) the English 1.7 set is green: `tested_1_7: yes` (French and gallery out on 1.7, no pack). Run minified into Evidence, Parked `2026-10-15-1.7-bills` released, Inbox empty. OptionalCompat declared (Audit 4.b/4.e): `Mod/About/OptionalCompat.xml` holds Mlie.XNDNocturnalAnimals (workshopId 2269731409, kind synergy), check OK, commit `9bed3e7`. ADS 2 is `loadBefore` plus a conditional patch: check reports no undeclared target. Resume 2026-11-07 (second): protocols read c27e9d4b. Not done: `supportedVersions` 1.7, version bump, CHANGELOG entry (publication gesture, with Preview redo); social preview upload (Virginie to say).
playTests closed 2026-11-07 (AUDIT 8.n): 8.a to 8.m met, 1.6 green and 1.7 English green. Stage shootGallery[1.1.0]: gallery of 1.0.0 stays (5 images accepted 2026-10-13); the 1.1.0 gallery pass is to decide there.

## NSB

Sync 2026-11-07 (sync-nsb). Places read: 2026-11-07 (lines of `sleeping-nook` and `window-backdrop-for-height` in SANCTUAIRE-LIEUX.md, EMBELLISSEMENT-LIEUX.md, VALIDE.md; not the whole files). Tribe read: 2026-11-07 (NELIM-PROFIL.md as diffs since 2026-10-13 and VALIDE.md lines for Nelim; ROSTER, APPARENCES-CANON, LOOKS-VALIDATION, CATALOGUE-ANIMAUX, AVANCEMENT not opened). NSB moved a lot since 2026-10-13 (places and animals validated by Virginie on 2026-11-07, decor batches 3 and 4, 20-place embellishment order), nothing that renames or removes what this gallery uses. Rules 1 to 5 of 2026-11-05 and 2026-11-07 stand.

| Place | Shots | Changes for the gallery | Last read |
|---|---|---|---|
| `sleeping-nook` (178, 121) | 1 | none; NSB lists it "à embellir" (lot 10, candles, vases, plush, painting, screen): the image changes when the decorated save replaces `Nelims-tribe` | 2026-11-07 |
| `window-backdrop-for-height` (90, 140) | 3, 4 | none; "zone libre", frame validated 2026-10-06, NSB prefers it for tall windows | 2026-11-07 |

| Colonist | Shots | Outfit per shot | Last read | Exceptions |
|---|---|---|---|---|
| Nelim | 1 | `Apparel_BasicShirt` dyed teal and `Apparel_Pants` dyed plum (free, rule 4: a chosen scene look, not her roster wardrobe) | 2026-11-07 (diffs only; 1.7 body hair `MortonFlameLowerBody` validated 2026-11-07, not visible in shot 1) | none |

| Animal | Shots | Outfit | Last read | Exceptions |
|---|---|---|---|---|
| dust bunny (the mod's own) | 1 | none | not in NSB catalogue, not needed | none: animal the mod adds, authorized by default (rule 2, 2026-11-07) |

| Animal the mod includes (rule 5) | Shots |
|---|---|
| dust bunny (`DustBunny` pawn kind, the only animal the mod adds) | 1 (live, with Nelim), 3 (information card) |

Not changed: shotlist and scenarios. 1.1.0 gallery decision (keep the 1.0.0 gallery or redo) still open with Virginie.

Sync 2026-11-08 (sync-nsb-npt, Places read: 2026-11-08, Tribe read: 2026-11-08, Steps read: 2026-11-08; lines and diffs only). NSB since 2026-11-07: `sleeping-nook` validated by Virginie 2026-11-08 (VALIDE.md; our shot 4 place stays as is), `terrace` unchanged (validated), enclosure/workshops/hearth-hall validated, right-bank and gravel-yard refused (not used here). NPT since 2026-11-07: new steps `the building X at (x, z) is put out` and `lies asleep in the bed` (already used in scene 4), StageDecor made-of placement; none needed by scenes 1 to 3. Tables above unchanged: places, Nelim outfit, dust bunny all as before; included animal rule 5: dust bunny shown in shots 3 and 4. Nothing outside NSB, no owner question.

Sync 2026-11-09 (sync-nsb-npt, Places read: 2026-11-09, Tribe read: 2026-11-09, Steps read: 2026-11-09; commit diffs only, our rows grepped). NSB since 2026-11-08: Quill roster/eyes, decor fixture `Nelims-tribe-decor-mods-z3.rws` copied (old `Nelims-tribe` kept, our scenarios stay on it), all places validated; nothing touches `sleeping-nook`, `window-backdrop-for-height`, Nelim or the terrace. NPT since 2026-11-08: new steps (carry item made of stuff, Beauty2 mouth offset, point framing, skip drawing/flecks, no flee); none needed by scenes 1 to 4 (Dust has no stuff). Tables above unchanged, no MISSING animal row, nothing outside NSB, no owner question.

## Shotlist 1.1.0 (write-shotlist, 2026-11-07; plan in the header of `Tests/Pickle/Mod/Pickle/Features/11-gallery-captures.feature`)

No capture yet for these scenes: rating the plan. Story: spring cleaning in the Sanctuary, one day (8, 11, 18, 23 h), Nelim in one outfit (teal `Apparel_BasicShirt`, plum `Apparel_Pants`, `Roo_HD_Hair_Highpony`, light smile written). Director pass (Opus): kept zoom changes for thumbnail legibility (j), the `Dust` thread (10, 100, crumb, bunny), `Dust` heap as foreground, dusk for scene 3 (Nocturnal Animals), LayDown for scene 4; dropped: `Dust` x30 on the Shelf (cell holds stacks), rhythm line rewritten to the real gaps.

| Scene | a time frame | b decor | c living | d pawns | e action | f composition | g subject | j mod |
|---|---|---|---|---|---|---|---|---|
| 1 workshop-1-sweep | terrace, 8 h, Clear, 120 ticks | Shelf, 2 TorchLamp (off), Stool, Campfire, Harpsichord, 6 Filth_Dirt, Dust x10, PlantPot + daylily | Nelim, daylily | teal shirt, plum pants, Highpony, smile | DoBill forced on CraftingSpot, bill half done | wide, zoom 3.2 (196, 121), dust heap foreground | the dust comes off the floor | Dust heap 47 px on thumbnail |
| 2 workshop-2-armful | terrace, 11 h, Clear, 25 ticks | same furniture, dirt (194,120) (199,121), heap Dust x10, pot + daylily | Nelim, daylily | same outfit (continuity) | carries 100 Dust, forced walk to spot | medium, zoom 3 (197, 120), Nelim right | a hundred dust is the price of one bunny | heap 50 px, carried stack |
| 3 workshop-3-first-steps | terrace, 18 h, Clear, 15 ticks | CraftingSpot, Shelf, lit TorchLamp, Dust x5, 2 Filth_Dirt, pot + daylily | bunny front-on, Nelim, daylily | same outfit, profile, smile | bunny walks South, Nelim walks toward it | close, zoom 1.8 (196, 121), bunny lower third | the heap became an animal | the bunny, the one grey thing |
| 4 workshop-4-night-shift | sleeping-nook, 23 h, Clear, 20 ticks | nook furniture, lit TorchLamp (179,119), pot + daylily | bunny front-on, Nelim asleep | same outfit, own hair, asleep (no smile owed) | LayDown on the RoyalBed (177,121), bunny circles | medium, zoom 2.8 (177, 121) | it never sleeps, it stays with her | the bunny awake, Nocturnal Animals |

Series k: ok (one story, episodes move on: morning, noon, dusk, night; wide 1, medium 2 and 4, close 3; opening sets the place, closing is the night). Plan score: 5 on each scene by the rule of `rate-gallery` (no criterion weak or missing as written, no step proven absent). Not verified: that `I place the decor "Dust"` accepts an item, that `carries 100 of the item "Dust"` fits the stack limit, that `LayDown` on the `Bed` takes a colonist: all three go to NPT before the first ticket (an absent step costs -1 on its scene). Windows 5 to 8 set aside; 8 (peg leg, A Dog Said Animal Prosthetics 2) is to ask NPT. Scenarios written 2026-11-07 (`11-gallery-captures`: 4 story scenes then the 2 window scenarios; a ticket over about 5 scenarios is killed, so file the story scenes and the windows as two tickets by filter). `Check-ShotlistVsScenario.ps1`: OK. Old image 1 deleted with its rewritten scene (`Art/Gallery/1-bunny-at-the-bed.png`, `git rm`, and its frame in `Evidence/2026-10-14-nonreg-gallery`); the three menu images stay until reindexed to 5 to 7. Subtitle lines in `PUBLICATION.md` ("Gallery subtitles"). Ticket held until NPT answers the three step questions (decor `Dust`, carry 100 `Dust`, forced `LayDown` on `RoyalBed`) and the existing-lamp `is lit` question.

## Ecosystem

Study by PiI 2026-11-13 (`docs/inventory/ecosystem-steam/DustBunniesRenew.md`, protocols commit d9c98a1; Chrome Workshop searches, nothing subscribed). No fork, no duplicate. Original Dust Bunnies 2659958183 (2blockdude, HendraGradeWood) is dead for 1.6 (versions 1.1 to 1.3). Name clash, not a duplicate: Crows' Dust Bunnies 3480725900 (`Crows.DustBunny`, 1.5 and 1.6) is a different mod, a living cleaning creature that eats filth, no crafting, no shared defName (local scan: 3 weak hits, none a fork). Its Chinese pack 3480771206 translates the Crows mod, not ours. Unrelated: Comfort Bunny 3836181293, Bunny Framework 3015333853 (name only). Open: check that both Dust Bunnies mods load together without a defName collision (none found by the scan, not played).
Dust search 2026-11-13 (Search-Workshop.sh, pattern `defName` containing Dust or `dust bunny` text or label dust, `*.xml`, Workshop plus local Mods, 5443 folders read, 2055 hits, results `%LOCALAPPDATA%\Temp\rimworld-search\dust-mods\hits.txt`). No other mod defines a `Dust` ThingDef or an item called dust: the other `defName` Dust are a WeatherDef (Seasonal Weather 2045114229) and an AllergyDef (Allergies 3356338154), other def types, no collision. Links found: Combat Extended 2890901044 patches Crows' bunny (`LoadFolders` `IfModActive Crows.DustBunny`, `ModPatches/Dust Bunnies`), nothing for `nelim.dustbunnies`; Dogs mate (Continued) 2441132298 patches `Bunnies_DustBunny` (a Dust Bunny of the mod BiomesTeam.Bunnies, not in the corpus hits); Nelim's Animals Naturally 3811381865 (ours) patches `Crows_DustBunny` in `Patches/Rythme.xml`, not ours; Cthulhu Anomaly Expansion 3740564738 only uses the words in a ritual text. Limits: XML only, installed mods only; synonyms of the mechanism (vacuum, filth to item, sweeping) not searched, an absence is not proof.
Combat Extended patch 2026-11-14 (Virginie: no pull request now; "soit RTI soit après publication de Dust Bunnies Renew"): draft written, not sent, not forked. Same values as CE's own patch for Crows' bunny (QuadrupedLow, MeleeDodgeChance 0.19, ToolCE bite 3 and head 1, `IfModActive nelim.dustbunnies`); tools patched on abstract `BaseDustBunny`. Draft kept only in the session scratchpad (`ce-patch/ModPatches/Dust Bunnies Renew/...`), to rewrite from CE's patch for Crows when the time comes. Not tested with CE loaded.
Stage 2026-11-14: back to localize[1.1.0] (Virginie): add Chinese. PiI found Crows' mod has a Chinese pack (3480771206); the original's languages not recorded. Gallery paused at shootGallery: images 1 and 2 REDO (54a5), decision open (still Nelim or new Dust art); evidence 2026-11-14-gallery-dust-gesture2 still in Inbox.
Localize 2026-11-14: Simplified Chinese added (Languages/ChineseSimplified, 4 DefInjected files, 11 keys, written with Claude, not native-checked). Check-Translations PASS, Check-DefInjected 24 keys 0 errors. PUBLICATION.md Languages paragraph with the AI sentence. TRANSLATION_REVIEW.md to regenerate and /review-translation to run (ChatGPT) before leaving localize. Crows pack 3480771206 not reused (other mod).
ChatGPT review 2026-11-15 (page 1 of 1, Chinese added): 1 applied (Dust.description zh smoother), 1 rejected (French 'Fait de mouton' to 'lapin': mouton is the deliberate pun, see the XML comment). No proper noun to decide. Chinese review landed, localize done pending Virginie. Gallery images 1 and 2 decision still open.
Translation review validated by Virginie 2026-11-16 (revision f8dc154, French and Simplified Chinese; ChatGPT pages applied or rejected, no proper noun open). Back to shootGallery[1.1.0]: images 1 and 2 decision still open (still Nelim or new Dust art).
Sync 2026-11-16 (sync-nsb-npt, Places read: 2026-11-16, Tribe read: 2026-11-16, Steps read: 2026-11-16; commit logs only). NSB docs: no commit since 2026-11-13. NPT docs/steps.md and ColonistRace catalogues: no commit since 2026-11-13; steps used for images 1 and 2 (the building has the bill, forced into the job on the building, forced to haul, the game is advanced by N ticks) already existed. Places terrace and sleeping-nook unchanged; Nelim, same outfit (teal shirt, plum trousers), no property change, no colonist or domestic animal outside NSB. Rule 5: the only animal the mod includes, DustBunny, is in images 3 and 4. Nothing to update.
Sync 2026-11-16 correction: NPT had 3 commits since 2026-11-13 outside docs/steps.md and the looks catalogues (Beauty2 mouth DY step for NSB and ACG, READMEs and regression feature of the steps of 2026-11-15, Simple Ivory catalogue); none serves our shots (Nelim keeps MouthLipsSmirk).
Decision 2026-11-16 (Virginie: 'choisis pour les images 1 et 2'): images 1 and 2 go back to the 44fc framing, Nelim still, camera 2.2, Dust x3.5. Chosen over new Dust art because the gesture steps (893a, 54a5) put carried Dust over her face. Malus on e accepted, understanding about 3.5/5 expected: these two are sent to Virginie as candidates with that said, no more REDO loop. Ticket 2c6b filed (evidence 2026-11-16-gallery-final12). Full /write-shotlist rewrite not run (no change of story, weekly quota at 100%); sync-nsb-npt done 2026-11-16.
Resume 2026-11-18 (DuB): protocols read 113f53ea, registered with TM. Ticket `2c6b` read (2/2 passed, 44fc framing, Nelim still, Dust x3.5): captures opened, both usable candidates as Virginie chose (heap readable, decor in frame, understanding about 3.5). But evidence was already minified to 1280 x 720 jpg (`Evidence/2026-11-16-gallery-final12`), no full-size original. Refiled same scenes as `20261118-181930-288-b70f` (`wsl-deps.gallery.map`, English, 1.6, evidence `Tests/Pickle/Inbox/2026-11-18-gallery-final12-fullres`) to get 1920 x 1080 originals. Keep `Mod/` and `Tests/` still until RUN_DONE. On RUN_DONE: copy the two PNGs to `Art/Gallery-clean/` under final names (`1-...`, `2-...`, no `candidate` prefix, GALLERY.md 2026-11-15), rename the two scene 3 and 4 candidates likewise (scene 4 under 2 MB), then ask Virginie to run `/mod-workflow:rate-gallery` (subtitles). Open warns: nsb-sync, npt-sync (run sync-nsb-npt), upstream-sync, STATUS.md 54 KB (journal to docs/runs/). Gallery change reopens mountPreview (AUDIT 10, 2026-11-18).
Ecosystem 2026-11-18 (PiI, protocols commit ae30fb0): `ecosystem-links` block added to `docs/inventory/ecosystem-steam/DustBunniesRenew.md`. Parent 2659958183 (Dust Bunnies, original), linked 3480725900 (Crows' Dust Bunnies). Translations of the original: none (registry empty, Steam searches of 2026-11-13 found none; not re-searched, Chrome extension offline). Nothing to integrate at `localize`; no patch or retexture row.
Resume 2026-11-19 (DuB): protocols read ea648c4c. Run `b70f` GREEN 2/2 (1920 x 1080 originals) read, captures opened: images 1 and 2 kept as candidates (Virginie's choice 2026-11-16, Nelim still, heap readable, decor in frame, understanding about 3.5), 3 and 4 candidates as before. Final names in `Art/Gallery-clean/` (`1-sweep`, `2-armful`, `3-first-steps`, `4-night-shift`, jpg, under 2 MB, same names in `Art/Gallery/` with the "Gallery subtitles" lines of `PUBLICATION.md` burnt by `Add-Subtitle.ps1`, image 1 opened: line readable, hides nothing); menu images reindexed to 5 (`5-bill-dialog.png`), 6 (`6-dust-bunny-card.png`), 7 (`7-dust-card.png`). Evidence `2026-11-18-gallery-final12-fullres` kept with `RELEASE.md`; superseded `2026-11-16-gallery-final12` and REDO `2026-11-14-gallery-dust-gesture2` deleted; Inbox empty. STATUS.md trimmed (old dated journal removed, git keeps it). Gallery done: next is mountPreview (stage change by replay-audit only).

## Gallery 1.1.0 (AUDIT 9.c, 9.d, 9.e; 2026-11-19, session)

| Index | File (clean original in `Art/Gallery-clean/` for 1 to 4) | Scene | Opened and judged 2026-11-19 |
|---|---|---|---|
| 0 | `0-preview.png` | copy of `Mod/About/Preview.png`, redone at mountPreview | not part of this pass |
| 1 | `1-sweep.jpg` | terrace 8 h: two heaps of Dust beside Nelim (run `b70f`) | candidate: heap reads at 268 px, decor in frame, Nelim still (Virginie's choice 2026-11-16) |
| 2 | `2-armful.jpg` | terrace 11 h: the hundred dust, Nelim walks toward it | candidate: heap whole, pot and piano in frame, same Nelim still |
| 3 | `3-first-steps.jpg` | terrace 18 h: the first bunny walking | candidate: bunny readable on the brick, clear of Nelim |
| 4 | `4-night-shift.jpg` | sleeping-nook 23 h: Nelim asleep, bunny awake | candidate: asleep Nelim, awake bunny |
| 5 | `5-bill-dialog.png` | bill dialog "Make a dust bunny" (interface, no subtitle) | kept (accepted 2026-10-13), recipe and 100x dust readable |
| 6 | `6-dust-bunny-card.png` | information card of the dust bunny (interface, no subtitle) | kept, stats readable |
| 7 | `7-dust-card.png` | information card of Dust (interface, no subtitle) | kept, stats readable |

Order (9.c): the story runs in the day's order (opening sets the place and the dust, closing is the night), so the most demonstrative image, the heap, opens on the Workshop page; the three interface windows close the series, as in 1.0.0. Contiguous 0 to 7, no hole, no duplicate. Subtitles of 1 to 4 burnt from `Art/Gallery-clean/` with the lines of `PUBLICATION.md` ("Gallery subtitles"); 5 to 7 carry none (interface). Known and accepted: images 1 and 2 show Nelim standing still (gesture steps put the carried Dust over her face, 2026-11-14); the information card of image 6 shows the raw stat "Leather amount 18" (the game's card, not the butchering yield of about 6 that the description computes).
