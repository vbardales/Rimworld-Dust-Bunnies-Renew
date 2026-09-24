---
localization: complete
translation_en: complete
translation_fr: complete
settings_audit: not_applicable
mod:          Dust Bunnies Renew (unofficial)
packageId:    nelim.dustbunniesrenew
repo:         Rimworld-Dust-Bunnies-Renew
remote:       https://github.com/vbardales/Rimworld-Dust-Bunnies-Renew.git
visibility:   public
mod_visibility: public
visibility_at: GitHub API verified 2026-09-24 (public, main); Workshop item 3806760430 created by the 0.1.0 prepublication on 2026-09-23, which Steam creates private; the switch to public is not recorded
local_path:   C:\Users\nelim\Documents\rimworld\DustBunniesRenew
detached:     yes
maintainer:   Codex and Claude Code sessions, whichever holds the mod; each audit entry below names its author
stage:        done
licence:      silent
licence_at:   original files, About, Steam description and all 9 comments, GitHub tree and README checked 2026-09-12
port_licence: MIT, limited to port additions described in LICENSE
dependencies: none
showcase:     complete
tested_on:    no in-game run recorded; the automated suite last ran 2026-09-24 at 806686b, exit 0
workshop:     3806760430
remaining:
  - "unverified: [tested gate] The four offline assertions TESTING.md assigns to Test-Mod.ps1 (scenarios 1, 3, 6 and 7), the only cover for those four manual scenarios: not written."
  - "unverified: [tested gate] French clipping, raw keys and fallback in the bill and information dialogs (scenario 16): no capture scenario exists, so a person would have to read it by hand, which the gate does not allow. A @review capture in the French pass is the way."
  - "unverified: [tested gate] All seven Pickle features run, in three passes: English, French, and the original mod beside this one. exitReason read before the counts, scenarios played against discovered, 07 played in the third pass and skipped in the others, the @review capture opened and looked at, startup logs read."
  - "unverified: [tested gate] The nine assumptions at the end of Tests/Pickle/README.md, which the first run confirms or breaks."
  - "unverified: [tested gate] A new colony and an existing save. The fixture colony was saved without the mod, so 04 is the second; the first needs a new game."
  - "defect: The Workshop page of item 3806760430 still carries the description frozen at creation, which says butchering gives about 18 dust and that dust is the worst insulator in the game. It is about 6, and the worst of any material a garment can be made from. Only Virginie can correct it, by hand on the Steam page; About.xml and the docs are already right."
updated:      2026-09-24
---

# Dust Bunnies Renew — status

## Pickle features written â 2026-09-24 (Claude Sonnet 5)

**Decision: `preTest` -> `done`.** The one criterion that held `done` back was the Pickle scenarios, written with
their scope justified, and they now exist. Every other criterion of transition 8 was already established, and
running the scenarios is `done -> tested`'s, not this transition's. This entry supersedes the `preTest` decision of
the audit below; that entry stays as written, because what it found was true when it found it.

`Tests/Pickle/` holds seven features with 79 step lines and seven local steps in `Source/DustBunnySteps.cs`, and a
README that says what is in Gherkin, what deliberately is not, and why. The features: startup (the recipe's worker
class resolved, the `[DefOf]` bound), gathering dust, **making a dust bunny** (a hundred dust consumed, one live
pawn, the colony's, a capture; the living animal's body size, yield, wildness and training), save and reload, the
labels in English and in French on the loaded defs, and the incompatibility with the original mod.

Checked outside the game, and only that:

- the steps build against the installed 1.6 game and the installed Pickle, 0 warnings and 0 errors;
- `Tests/Pickle/Check-Steps.ps1` exits 0: every step line resolves to exactly one step, every local pattern compiles
  and every local step is used. It was seen to fail on a copy outside the repository with a step that does not
  exist, an unescaped parenthesis in a pattern and a pattern that collides with one of Pickle's: exit 1 each, and the
  untouched suite exit 0;
- `_tools/Test-Mod.ps1` exits 0 again and the shipped DLL is unchanged.

**Nothing was run in the game, and no scenario is claimed to pass.** The nine assumptions a first run settles are
listed at the end of `Tests/Pickle/README.md`. The original mod has not been downloaded to the WSL install, so the
third pass cannot stage yet.

**Found while writing them.** The animal cannot be trained to haul or to rescue: those carry `minBodySize` 0.40 and
0.65, the game reads the living pawn's 0.04, and it would be too small at its base 0.2 as well. Scenario 9 had
expected them and is corrected; the suite asserts guard and attack. Pickle's own `def ... is defined by mod ...` step
exists, so the incompatibility pass asserts who owns the defs and needs no step of ours; `TESTING.md` had said no such
step was known.

**Reserve, outside this mod.** The `Ancient Buildings` and `Ancient Chinese Beast` incompatibility features assert
that the game **logs** a duplicate. `DefDatabase.AddAllInMods` removes the earlier def before adding the later, so no
duplicate error is reached on that path. Neither feature has run. Worth one look by whoever holds them; nothing was
changed there.

**Next transition, `done -> tested`.** Write the four offline assertions, add a French capture for the dialogs'
clipping, download the original mod to the WSL install, then run the three passes through the shared queue and read
their reports and the capture. `TESTING.md` has the passes and the evidence to keep.

## Workflow audit — 2026-09-24 (Claude Sonnet 5)

**Decision: `done` -> `preTest`.** `stage` uses the workflow's own state names, so `preTest` is the chain's
`preTest`: every transition up to `l10n -> preTest` holds, and `preTest -> done` is not established. The
entries below are history and are kept as written; where they say `done`, this entry supersedes them.

Audited revision `1b63e375d313e1931a7be7e178a1275d633d040d`; `origin/main` was equal to HEAD. Local changes
at the start: the untracked `Mod/About/PublishedFileId.txt` (3806760430, written 2026-09-23 16:31) and five
untracked `.dds` beside the PNGs. Both were kept and then resolved by commits: `5b68897` the ID file alone,
`b96b391` the `.gitignore`, `a19f679` the CHANGELOG, then `TESTING.md` and this file. Nothing under `Mod/`,
`Source/`, the images or the DLL changed. No game was launched, no Pickle run queued, nothing published.

| Transition | Result | Evidence |
|---|---|---|
| dansMonoRepo -> horsMonoRepo | Validated | Own `.git`; `git ls-remote origin HEAD` equals local HEAD; `gh repo view`: PUBLIC, `main`. README, ATTRIBUTION, LICENSE, CHANGELOG in English; `Mod/LICENSE` and `Mod/ATTRIBUTION.md` byte-identical to the root copies (`cmp`). `nelim.dustbunniesrenew`, `Dust Bunnies Renew (unofficial)`, `Rimworld-Dust-Bunnies-Renew` and `DustBunniesRenew/` agree. `silent` / public rests on the 2026-09-12 source investigation below; not repeated today |
| -> ModIcon generated | Validated | `Test-Mod.ps1` rebuilds with 0 warnings and 0 errors and the shipped DLL is byte-identical before and after. Icon viewed: 128 x 128, 33,652 bytes, the mascot with the creature readable. Not generated, modified or replaced |
| -> Preview generated | Validated | Viewed: 896 x 504, 205,118 bytes, under 1 MB; no clipping or overlap, the bunny unobscured |
| -> preOptions | Validated | Viewed at full size: the yellow rule and `1.6` badge are clearly separate from the beige-brown `Renew` and `(unofficial)`. English description; ` Renew` and ` (unofficial)` as PUBLISHING.md prescribes for a public `silent` port |
| -> options | Justified not applicable | No match in `Source/` or `Defs/` for `ModSettings`, `SettingsCategory`, `DoSettingsWindowContents`, `MainButtonDef`, `MainTabWindow`, `Scribe` or a `Mod` subclass: no page and no shortcut. Inventory in the 2026-09-13 entry. No customization mod was tested, and none is claimed |
| -> l10n | Validated | `Mod/Defs`, `Mod/Languages` and `Source/` are unchanged since the 2026-09-13 audit (`git diff 21fbbbe HEAD -- Mod/Defs Mod/Languages Source` is empty; the whole-tree diff is not, since `About.xml` and both LICENSE files changed). `Check-DefInjected` today: 12 keys, 0 errors. English is the Defs' own value |
| -> preTest | Validated | The only reference is `Krafs.Rimworld.Ref`, at build time. About declares 1.6, `loadAfter` Core and `incompatibleWith BlockHen.Animal.DustBunnies`; no dependency, `LoadFolders` or conditional patch |
| preTest -> done | **Not established** | Scenarios written: 18. Automated and XML tests written, run and green at the delivered revision (below). **Pickle tests written, with their scope justified: none.** There is no `Tests/Pickle/` |
| done -> tested | Unverified | Nothing was run in game |

**Why `done` no longer holds.** The 2026-09-13 entry validated `preTest -> done` on the automated suite and the
written scenarios, and said pawn generation is "covered by manual scenarios". Transition 8 as the workflow
now states it, with the 2026-09-21 explicitation, asks for the Pickle scenarios to be *written* and their scope
justified, and the scope here is not empty: what a colonist finishing a bill does is exactly what only a running
game can show. Manual scenarios do not satisfy it, and transition 9 then asks for no manual test left. This is
a verification not yet established, not a defect of the mod.

**Commands and results**

- `_tools/Test-Mod.ps1`: **exit 0**. Release build 0 warnings, 0 errors; 8 XML files; no unknown field; no
  missing reference, wrong type or unresolved parent; 12 keys, 0 errors; 2 C# types resolved; the recipe worker
  derives from `RecipeWorker` and overrides the completion hook; the `DefOf` field is a `PawnKindDef`.
  PowerShell 7 is not installed on this machine and the script calls `pwsh` by name, so it ran under Windows
  PowerShell 5.1 through a temporary `pwsh` shim kept outside the repository.
- SHA-256 of `Mod/Assemblies/DustBunnies.dll` before and after the rebuild:
  `2D6203280D1B7985DFE2F2FBA6255B046A50BD75D63C90186A59E843A16F580B`, identical.
- `git ls-remote`, `gh repo view`, `cmp` on the two document copies, `grep` for the settings symbols above,
  and a direct look at both images.
- `scripts/Pickle-Status.ps1`, read-only: 22 tickets waiting and a WSL run in progress for another mod. **No
  ticket exists for this mod**, and nothing in `scripts/` or `PickleTools/` refers to it, so there was nothing
  to watch and no `Monitor` was armed.

**Settled by this audit.** The Workshop item exists (`workshop: 3806760430`), created private by the `0.1.0`
prepublication; the CHANGELOG opens with `0.1.0` and keeps the port's notes as `Unreleased`, which becomes
`1.0.0` with `published`. `.dds` files are ignored and were never tracked; `Tests/Pickle/Evidence/` and
`evidence/` are ignored ahead of any run. `TESTING.md` is new: the planned disposition of the eighteen manual
scenarios, the three passes this mod needs, and the proofs to keep.

**Next transition, `preTest -> done`.** Write the Pickle features the plan in `TESTING.md` assigns to a running
game (startup; gather then make, ending on a live colony pawn; the French pass; the incompatibility pass), state
their scope, and add the offline assertions for scenarios 1, 3, 6 and 7 to `Test-Mod.ps1`. Their execution is
`tested`'s. `tested` then needs the three checks below: no `@wip`; every conditional scenario run (none is
planned); no manual test left, each of the eighteen automated and green or listed not applicable with its reason.

**Reserves, optional.** The five `.dds` files were on disk two hours before the upload, so the `0.1.0` item may
carry them; that cannot be read back from here, and an upload from a tree without them leaves them out.
`Test-Mod.ps1` could fall back to `powershell.exe` when `pwsh` is missing.

**Corrections after a review, same day.** A review of the commits above found three figures of mine wrong and a
plan that could not work, and all are fixed. Verified against the game's own code and data, not from memory.

- **Butchering yields about 6 dust, not about 18.** `Pawn.BodySize` is the life stage's `bodySizeFactor` times
  the race's base size. The only life stage is `AnimalBaby`, factor 0.2, so the animal is 0.04 and not 0.2:
  `LeatherAmount` 50 becomes 2 and the stat's curve lifts it to about 5.6. The 18 was read off the *def's*
  information card, which has no life stage. The body size is 0.04 in play for the same reason.
- **Dust is the worst insulator of any material a garment can be made from, not "in the game".** Of 53 stuffs,
  the six stone blocks state no cold insulation and default to 0, but they are `Stony`, and the apparel files
  accept only `Fabric`, `Leathery`, `Metallic` and `Woody`. The lowest vanilla stuff that states one is 2.5.
- **The incompatibility pass cannot wait for a duplicate-def error.** `DefDatabase.AddAllInMods` removes the
  earlier def and adds the later one, so the game logs nothing. The pass now asserts who owns `DustBunny`, and
  says that no step for that is known to exist.
- Also fixed: the CHANGELOG said the ID-file commit was the only one after `1b63e37`; this file quoted a
  whole-tree diff that was only empty when path-limited; and `TESTING.md` linked to files outside the
  repository. `CHANGELOG.md`, `README.md`, `TESTING.md`, `_tools/FUNCTIONAL-SCENARIOS.md` and the description in
  `About.xml` now carry the corrected figures. This is a change under `Mod/` after `0.1.0`, so
  the sentence above that nothing under `Mod/` changed describes the audit, not the corrections.

The suite was rerun after the `About.xml` edit: exit 0, and the shipped DLL is byte-identical again.
## Publication-format correction — 2026-09-13

Fixed the publication-format finding from the audit below in the working tree
based on `21fbbbe81284694c43c3f26595b60eb12def7a4b`: removed the standalone raw
GitHub link near the beginning of Mod/About/About.xml and appended the prescribed
Steam-formatted `Source code on GitHub` link at the end of its description.
The target matches the metadata URL and the repository verified during the audit.

Validation: parsed all 8 distributed XML files; checked that the description ends
with exactly one prescribed link and contains no old `GitHub:` line;
`git diff --check` passed. No source, Def, translation or DLL changed, so existing
build and localization validations remain applicable. Stage stays `done`; gameplay
validation remains unverified. Historical findings below describe the pre-fix state.
No commit, push or Workshop publication was performed.

## Ordered workflow audit — 2026-09-13

**Decision: `awaiting-manual-tests` -> `done`.** Here `done` means ready for final
functional validation in RimWorld, exactly as defined in the supplied workflow;
it does not mean `tested`. The former code described the same pending gameplay
work but did not explicitly establish the settings gate. This audit establishes it.
The user's transition criteria take precedence over conflicting parent guidance,
particularly the rule allowing source verification for a mod without settings.

Scope: autonomous repository `C:\Users\nelim\Documents\rimworld\DustBunniesRenew`,
distributed root `Mod/`. Initial HEAD was `17565c2df433d6d4cad7df584c8990e99965b5e9`;
initial local changes were STATUS.md, the French ThingDef translation comments and
`_tools/FUNCTIONAL-SCENARIOS.md`. During the audit another operation committed those
changes as `21fbbbe81284694c43c3f26595b60eb12def7a4b`. Its diff was inspected: no
source, binary, image or translated value changed. The final audited revision is
that commit, plus this STATUS.md update. Existing work and historical results were
preserved. This audit made no commit, push, publication or image generation.

| Transition / resulting state | Result | Current evidence |
|---|---|---|
| dansMonoRepo -> horsMonoRepo | Validated | Own .git directory, top-level path above, no superproject; configured GitHub origin. Live GitHub API: public, private=false, main. Live `git ls-remote origin HEAD` returned initial HEAD 17565c2, proving an existing pushed commit. README, CHANGELOG, LICENSE and ATTRIBUTION exist in English; distributed LICENSE and ATTRIBUTION match root copies by SHA-256. Identity and Renew/unofficial naming are coherent. |
| horsMonoRepo -> ModIcon generated | Validated | Implementation present with no unfinished development identified; Release build passes and shipped DLL is byte-identical before/after. Directly inspected 128 x 128 PNG icon, 33,652 bytes, with mascot and subject visible. The approximate icon weight guidance is not a hard gate. |
| ModIcon generated -> Preview generated | Validated | Directly inspected delivered 896 x 504 PNG, 205,118 bytes; illustration source and composition remain in Art/. No concrete camera defect found. No historical generation report or recorded game-screenshot comparison is required. |
| Preview generated -> preOptions | Validated | English description; exact Renew and unofficial naming; reduced Renew suffix and separate tag; yellow rule/badge visibly distinct from beige-brown secondary ink at full size and 268 px. No linking words need special treatment. |
| preOptions -> options | Justified not applicable | Settings inventory below: no relevant configuration, no empty settings page and no MainButtons shortcut in sources/Defs. |
| options -> l10n | Validated | Reviewed all sources/Defs and four French resources against the existing 12-path inventory; nonempty English native Def values and French coverage, including inherited head tool. Check-DefInjected passes with 12 keys and zero errors. No owned code UI strings, parameters or unresolved translation placeholders. |
| l10n -> preTest | Validated | Source only uses RimWorld/Verse and system APIs; XML references and parents resolve. About declares 1.6, Core loadAfter and original-mod incompatibility. No required third-party runtime dependency, optional integration, LoadFolders, conditional patch or version directory. Krafs.Rimworld.Ref is a build reference, not a player dependency. |
| preTest -> done | Validated | Existing automated/XML tests executed successfully against installed RimWorld 1.6 and the shipped DLL. Eighteen written functional scenarios include shared setup, actions and expected results. Full pawn generation requires game runtime and is covered by manual scenarios rather than a claimed isolated unit suite. |
| done -> tested | Unverified | No executed gameplay scenarios or attributable Player.log supplied/produced. New-colony and existing-save runs, English/French UI and logs remain mandatory. |

### Settings audit

Inspected both C# files, project references and every delivered Def. The worker has
one fixed recipe completion action; the DefOf class only binds the pawn kind.
Recipe costs/work/yields, animal stats/training/diet/lifespan and material stats are
the inherited content balance, not a separate user configuration contract. Bills,
training and animal management use vanilla controls. No concrete unmet settings
need was identified; exposing these constants would invent a balance editor for
this small preservation port. No XML configuration file or inherited settings
integration exists. Searches for ModSettings, SettingsCategory,
DoSettingsWindowContents, MainButtonDef, MainTabWindow, Scribe and a Mod subclass
returned no matches, consistent with direct source review.

Thus page, shortcut, editable-value validation, application timing, settings reset
and settings persistence tests are **not applicable with justification**. RIMMSQOL
and other customization integrations were **not tested**, and none is claimed.
Animal/bill save persistence remains part of final gameplay validation, not a
mod-settings test. This finding establishes `settings_audit: not_applicable`.

### Commands and observed results

- Read parent AGENTS.md, PUBLISHING.md, STYLE_RIMWORLD.md, MOD_SETTINGS.md and
  TRANSLATIONS.md; inspected actual sources, metadata, docs, images and test scripts.
- `pwsh -NoProfile -File _tools/Test-Mod.ps1`: initial sandbox attempt could not
  read the local Microsoft SDK directory (MSB4184). Retried with approved SDK/game
  access: **exit 0**, Release build 0 warnings/0 errors; 8 XML files parse; no unknown
  fields, missing/wrong-type Def references or unresolved parents; 12 injection
  keys, 0 errors; 2 XML C# types resolve; compiled recipe override and DefOf type pass.
  The first attempt was an environment access failure, not a mod defect.
- Shipped DLL SHA-256 before and after build:
  `2D6203280D1B7985DFE2F2FBA6255B046A50BD75D63C90186A59E843A16F580B`.
- GitHub read checks initially lacked sandbox network/config access; approved
  read-only retry succeeded. No repository mutation was required.
- Direct image inspection covered both delivered images and the existing 268 px
  thumbnail. Art/preview.html uses Art/preview-palette.json; current QA report size
  matches the delivered Preview. Historical font/contrast measurements remain
  recorded below; they were not newly rendered or remeasured in this audit.
- Rights classification remains `silent` under the documented 2026-09-12 source
  investigation in ATTRIBUTION.md, not a newly obtained permission. MIT is expressly
  limited to port additions; inherited assets have no invented licence grant.
  The original Steam comments/upstream licence search was not repeated today.

### Findings outside the transition gates

**Observed publication-format defect:** About.xml has a raw GitHub URL near its
start and lacks the final `[url=...]Source code on GitHub[/url]` link specified by
PUBLISHING.md. Correct this before a publication action. The user's explicit
preOptions criteria require English description and naming, which pass; publication
itself is outside this supplied chain, so this does not downgrade `done`.

**Next transition:** execute and record scenarios 0-17, explicitly covering a new
colony and an existing save, save/reload, recipe completion, training, both languages
and logs. No custom settings/shortcut scenario is applicable. Failures, if any,
would require the corresponding correction and regression checks; missing gameplay
evidence alone is not an observed functional defect. Workshop publication remains
unconfirmed and is not required to reach `tested`. No optional visual correction
is recommended from this inspection.

## Translation audit — 2026-09-13

Applied the translation gate from the parent workspace's PUBLISHING.md and
TRANSLATIONS.md to revision `17565c2df433d6d4cad7df584c8990e99965b5e9`
and the current working files. All three fields certify static readiness only;
the existing stage is preserved and bilingual gameplay remains unverified.

Scope: all three XML files under `Mod/Defs`, all four French DefInjected files,
both C# source files and the published folder layout. There is no LoadFolders.xml,
version-specific content, conditional patch, optional integration, custom settings,
Keyed text or mod-owned grammar resource. The recipe worker only generates and
spawns a pawn; it adds no UI text, messages or dynamically constructed keys.

| Owned text source / injection path | English source | French coverage |
|---|---|---|
| ThingDef `DustBunny.label`, `.description` | Both concrete Def values | 2 entries |
| ThingDef `DustBunny.tools.head.label` | `head`, inherited from `BaseDustBunny` | 1 entry |
| PawnKindDef `DustBunny.label` | Concrete Def value | 1 entry |
| ThingDef `Dust.label`, `.description` | Both concrete Def values | 2 entries |
| RecipeDef `GatherDust.label`, `.description`, `.jobString` | All three Def values | 3 entries |
| RecipeDef `MakeDustBunny.label`, `.description`, `.jobString` | All three Def values | 3 entries |

Total: 12 owned text paths, each with nonempty English source and French translation.
English uses native Def fallback; an English DefInjected copy is unnecessary.
Reviewed the French meaning and terminology, including the dust-bunny wordplay and
third-person job strings. Owned texts have no format parameters, grammar tokens,
rich-text tags or intentional multiline formatting to synchronize.

Engine-generated text uses the localized Def values: dust as a material uses
`ThingDef.LabelAsStuff`, whose installed assembly getter falls back to `label` when
`stuffAdjective` is empty. The unlabeled bite references the vanilla `Teeth` body
part group; the explicitly named head tool is covered above. Core French includes
`Teeth.label` (`dents`) and `HeadAttackTool.label` (`tête`). Core owns the corpse
templates (`CorpseLabel`, `CorpseDesc`) and the productless-recipe rejection
(`RecipeCannotHaveTargetCount`); their English and French resources were checked
in installed Core English files and `French (Français).tar`. These resources are
not copied into the mod. Generated wording and grammar still require scenario 16.

Exclusions: identifiers, texture paths, sound/Def references, the developer-only
`devNote`, C# comments, About metadata, licences and repository documentation are
not player-facing translation resources. No localization defect was found.

Verification performed:

- `pwsh -NoProfile -File _tools/Test-Mod.ps1 -SkipBuild`: PASS; 8 XML files parse,
  fields/references/classes and the existing compiled recipe hook pass.
- Its local `Check-DefInjected.ps1`: 12 keys, 0 errors, no unverified targets.
  This validates paths; the source inventory above establishes coverage separately.
- XML resource inspection: 12 unique, nonempty French entries, no placeholders
  or rich-text markup. Manually compared the inventory with the English Def values.
- Installed assembly inspection with `ilspycmd` (`DOTNET_ROLL_FORWARD=Major`)
  confirmed the material-label fallback. No DLL rebuild was needed or claimed.

Repeat this audit after changes to text, UI code, Defs, patches or language resources;
reset affected status fields to `unchecked` until revalidated. Run scenario 16 in
both languages before claiming in-game translation validation.

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
