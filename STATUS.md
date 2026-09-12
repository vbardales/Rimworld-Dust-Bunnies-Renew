---
mod:          Dust Bunnies Renew (unofficial)
packageId:    nelim.dustbunniesrenew
repo:         Rimworld-Dust-Bunnies-Renew
remote:       https://github.com/vbardales/Rimworld-Dust-Bunnies-Renew.git
visibility:   public
mod_visibility: public
visibility_at: GitHub API verified 2026-09-12; Workshop publication not recorded
local_path:   C:\Users\nelim\Documents\rimworld\DustBunniesRenew
detached:     yes
maintainer:   Codex, responsible for this repository and STATUS.md
stage:        awaiting-manual-tests
licence:      silent
licence_at:   original files, About, Steam description and all 9 comments, GitHub tree and README checked 2026-09-12
port_licence: MIT, limited to port additions described in LICENSE
dependencies: none
showcase:     complete
tested_on:    automated checks against installed RimWorld 1.6; no recorded in-game run
workshop:
remaining:
  - Run and record manual scenarios 0-17, especially recipe completion and training.
  - Confirm Workshop publication status before filling workshop.
updated:      2026-09-13
---

# Dust Bunnies Renew — status

## Delivery checkpoint — 2026-09-13

The user approved the corrected Preview and requested commit/push of this session's changes.
Artwork and automated validation are complete; stage remains awaiting-manual-tests because
no RimWorld gameplay run has been recorded. All 18 manual scenarios remain to be executed,
especially completion of MakeDustBunny and training. Workshop publication is not confirmed.
The no-commit/no-push statements in the audit entries below describe those earlier checkpoints.
This Git delivery does not publish a Workshop item or change the licence classification.

## Ownership and repository identity

Codex maintains this file with changes, actual verification results and remaining work.
The scope is this single local repository, not the former monorepo. `git rev-parse
--show-toplevel` resolves to the local_path above; `.git` is a directory in this folder,
and `--show-superproject-working-tree` is empty. Fetch and push use the remote above.
GitHub reports `private: false`, `visibility: public`. No commit or push was made in this audit.

## Mod licence and visibility

**Mod: `silent` / `public`.** This is the project's publication classification, not a
licence grant for inherited content. The original mod is by 2blockdude and HendraGradeWood;
the explicit audit on 2026-09-12 checked the installed original files and About.xml,
the live Steam description and all nine comments (including the author's replies),
and the upstream GitHub recursive tree, README and API metadata. No licence file,
permission to redistribute or written refusal was found in those sources. GitHub reports
`license: null`, last push `2021-11-21T20:16:42Z`; Steam lists the last update in November 2021.
This supports the abandoned-source classification; it is not proof that the authors cannot
be contacted. Evidence and source links are recorded in ATTRIBUTION.md.

The mod's `public` classification follows PUBLISHING.md's rule for abandoned, silent sources
without a recorded prohibition. Separately, the port repository was checked live and is
public (`private: false`). Neither fact grants redistribution rights to inherited content.

- `silent`: retained because no permission or prohibition is documented in the source audit.
- `open`: does not describe the whole mod; MIT covers only the port additions listed in LICENSE.
- `forbidden`: no written refusal is recorded in the audit.
- `original`: not applicable; the mod retains original textures, definitions and balance.

Keep the **(unofficial)** suffix, original author credits and removal-on-request statement.
The suffix already existed and was preserved. GitHub now appears in the description text
as well as the About.xml URL field. Public GitHub visibility does not establish a Workshop
publication or original-author consent.

## Automated verification — passed 2026-09-12

Command: `pwsh -NoProfile -File _tools/Test-Mod.ps1` (PowerShell 7, .NET SDK, installed RimWorld 1.6).
For another installation, pass `-GameRoot`. Checks are versioned in `_tools/checks/` and
require no sibling monorepo scripts. The game assemblies/data are external prerequisites.

- Release build: successful, zero warnings and errors.
- All 8 mod XML files parse, including About and French translations.
- XML fields: no unknown fields against the game assembly.
- Def references and abstract parents: none missing, no wrong reference types reported.
- French DefInjected: 12 keys, zero errors.
- XML C# classes: 2 referenced types resolved.
- Shipped DLL: recipe worker derives from RecipeWorker and overrides the game's completion
  hook; the DefOf field is a PawnKindDef.

Negative controls: a deliberately unknown XML field and a missing ParentName were both rejected with exit code 1 in isolated .build fixtures.

These are static/integration checks, not an execution of pawn generation. No isolated C#
unit suite is claimed: the worker directly depends on the game map, pawn and bill runtime.

## Manual functional verification — not run

18 scenarios (0-17) exist in `_tools/FUNCTIONAL-SCENARIOS.md`, with setup, actions,
expected outcomes and log diagnostics. No actual gameplay result or Player.log is recorded.
Prior claims of in-game testing in About.xml and README were corrected.

First priorities: clean startup; complete the 100-dust recipe and observe a live colony pawn;
then verify training with the permanent AnimalBaby life stage, saving/reloading and French.
Record game version, active mods/DLC, date, scenario ID, PASS/FAIL, observations and log path.
Do not mark the mod functionally validated until this evidence exists.

## Preview overlay — recomposed 2026-09-12

- Delivered image: `Mod/About/Preview.png`, 896 x 504, 203807 bytes (under 900 KB).
- Text-free illustration: `Art/Preview.png`, copied byte-for-byte from the existing
  `Art/Preview-source.png`. No new illustration was generated; the original remains intact.
  The source is cropped with CSS background-size cover and centered at the final canvas size.
- Composition and parameters: `Art/preview.html`; colour authority: `Art/preview-palette.json`.
  `_tools/preview.html` now points to the maintained composition, avoiding an obsolete renderer.
- Renderer: `Art/render-preview.cjs` (Node, playwright, sharp, installed Chrome). Run
  `node Art/render-preview.cjs` with the packages available on NODE_PATH. An optional first
  argument selects another Chrome executable. It serves local files temporarily and publishes nothing.
- Kept the exact name and existing English summary. Renew is a direct 0.65em title span;
  (unofficial) occupies its own tag line. The version badge reads the highest stable
  supportedVersions entry from the delivered About.xml: currently 1.6.
- Palette rationale: the veil follows the dark brown plank flooring, the large representative
  surface. The secondary ink is a lightened warm wood brown, preserving the dominant ochre/brown
  family rather than averaging the image into grey. The nearly monochromatic illustration has
  no significant contrasting cool detail: the accent therefore draws on the golden lantern
  and the light outlining the bunny, with much higher saturation and lightness than the muted
  wood secondary. This makes the rule and badge visibly distinct within the same warm family.
  Final HEX values are recorded only in the palette JSON.
- The dark coloured veil holds opacity behind the text before fading toward the subject;
  the specified text shadow is applied to title, tag and summary, never the badge digits.
- Actual fonts verified through Chrome CSS.getPlatformFontsForNode after document.fonts.ready:
  Segoe UI Semibold for title and Renew, Segoe UI regular for tag/summary, Segoe UI Bold for
  badge. No fallback font was used.
- QA evidence: `Art/preview-qa/report.json`, `Art/preview-qa/background.png` (text and shadows
  hidden) and `Art/preview-qa/Preview-268.png`. Contrast checks scan every background pixel
  in each text rectangle, not only four corners. Minimum ratios: title 11.89:1, Renew 6.99:1,
  tag 6.62:1, summary 9.41:1, badge digits 11.40:1. All exceed 4.5:1.
- Visually inspected the delivered 896 x 504 image and the 268-pixel thumbnail: no clipping
  or overlap, bunny unobscured, title/version identifiable, reduced title word and tag visible,
  rule visible and accent distinguishable. The summary is intended for full-size reading.
- No publication, commit or push performed. Gameplay test status is unchanged.

### Repeat Preview brief — verified 2026-09-12

The resubmitted brief and current STYLE_RIMWORLD.md overlay rules were checked against
Art/preview.html. Re-rendered from the untouched Art/Preview.png and existing palette JSON;
no illustration replacement or text changes were needed. Re-inspected both final sizes.
The result remains 203807 bytes, with Segoe UI confirmed and a minimum text contrast of
6.62:1. The report and background/thumbnail QA artifacts were regenerated. No publication.

### Accent correction — 2026-09-13 (current Preview)

The user's visual review rejected the previous accent/secondary separation as too close.
The earlier readability checks were valid, but did not establish sufficient colour separation.
The accent in Art/preview-palette.json now shifts from amber to a more saturated, brighter
lantern yellow; the secondary retains its warm wood-brown family. This deliberately strengthens
the yellow component of the scene's light rather than introducing an unrelated cool colour.
The rule and badge now appear yellow against the beige-brown title suffix and tag.

Re-rendered Mod/About/Preview.png from Art/preview.html and the unchanged text-free source.
Current size: 896 x 504, 205118 bytes. Visually checked at full size and 268 pixels wide:
the yellow accent separates more clearly from the secondary, with no clipping or overlap.
Segoe UI is confirmed. Minimum text/background contrast remains 6.62:1; badge digits now
measure 14.20:1. The current measurements and thumbnail are in Art/preview-qa/.
No illustration replacement, publication, commit or push.