# In-game scenarios, run by Pickle

This companion is development-only: it lives beside `Mod/`, never inside it, and Steam never receives it. It
turns the manual checks of `../../TESTING.md` that only a running game can settle into scenarios that set a
scene up and assert.

**Status: written, never run.** The steps compile against the installed 1.6 game and the installed Pickle, and
every step line of every feature resolves to exactly one step (`Check-Steps.ps1`), which was seen to fail on a
step that does not exist, on an invalid pattern and on an ambiguous one before being trusted. Whether each step
does what its scenario hopes is what the first run settles; the list at the end names the assumptions it will
confirm or break. Running the suite is the work of `done -> tested`, not of `done`.

## What is in Gherkin, and why it needs a game

`../../_tools/Test-Mod.ps1` already proves what a file can prove: the XML text, the references, the
translation paths and the compiled recipe hook. Nothing below repeats it. Each feature exists because the game
itself has to act on the defs, and the first one because the whole mod is a single method that nothing calls
until a colonist finishes a bill.

| Feature | What it shows | Why it cannot be an offline test |
|---|---|---|
| `01-loads` | The mod loaded; its principal defs survived the real loader; **the recipe's worker class resolved**; the `[DefOf]` bound; no error, no warning from the mod | A `workerClass` the loader cannot resolve does not kill the def: the field stays on the base class and the recipe still lists, still takes its dust and still finishes, producing nothing. The error is logged once at startup, before any scenario window |
| `02-gather-dust` (`@slow`) | A colonist walks to a crafting spot and finishes a bill with no ingredient: exactly ten dust appear | The bill, the work giver and the product are the game acting on the defs |
| `03-make-a-dust-bunny` (`@slow`, `@review`) | **A hundred dust are consumed and a live animal stands where the colonist worked, and it is the colony's.** The living animal is 0.04 in body size, yields about 6 in leather, has wildness 0.1 and can be trained to guard and to attack | The whole point of the mod. `Notify_IterationCompleted` is called from a toil, after the ingredients are gone and before the job ends. And every figure is the one a **living** pawn computes: a def has no life stage, which is how the description came to claim 18 for a yield of 6 |
| `04-save-reload` | A queued bill for the mod's recipe, and a made animal, survive a save and a reload | Scribe behaviour. The fixture colony was saved without this mod, so it is also the mod added to an existing colony |
| `05-labels-en`, `06-labels-fr` | The animal, the material and both recipes read as the language of the pass says, **on the loaded defs** | A language folder the game does not find is silent, above all on Linux. The English feature adds nothing about the English text, which is the XML itself: it is the control that a pass claiming English really ran in English, as the French one is for French |
| `07-original-mod-incompatibility` (`@requires`) | With the original mod staged beside it, the mod that loads last owns `MakeDustBunny`, `GatherDust` and `Dust` | The declared `incompatibleWith` is a claim about the other mod, and it ages. Only loading both says whether it is still true |
| `08-animal-prosthetics-2` (`@requires`) | With A Dog Said... Animal Prosthetics 2 staged, this mod loads before it, the dust bunny is offered the surgeries a Squirrel is (ADS 2's category 1 only), and a Cat is offered surgeries it is not | ADS 2 copies its category lists once, so the **order** is the whole integration, and only loading both in that order shows it held. No surgery is named on purpose. ADS 2 defines them (`InstallPegLegAnimal`, `InstallDentureAnimal`, `InstallWoodenPawAnimal` and the hoof, hand and foot ones, in its `HediffDefs/Prosthetics_*.xml`), but a comparison with a reference animal holds whatever the recipes are called, now or after an update |
| `09-nocturnal-animals` (`@requires`) | With [XND] Nocturnal Animals (Continued) staged, the dust bunny's `ThingDef` carries the extension it reads, with the clock `Nocturnal` | The extension is behind `MayRequire`, which only a game that parses the XML shows to work with the mod present; without it, the startup log of the other passes shows the item skipped and silent |

## What is deliberately not in Gherkin

A check the game does not need to run, or that only tests the game, does not belong here.

| Check | Where it went | Why |
|---|---|---|
| Both recipes offered at the crafting spot and nowhere else; dust worse than every stuff a garment can be made from; wildness under `statBases`; the recipe having no `<products>` | `../../_tools/checks/Check-Claims.ps1`, run by `Test-Mod.ps1` | Each is a fact about the XML and the game's own data, so it is read offline. Each was seen to fail on a mutated copy of the defs |
| Never eats, comfortable to -55 °C, never manhunter, never breeds, dies of old age, corpse looks alive, the sprite always turned | none | Each is a declared value that vanilla code reads: replaying it tests the game, not the mod. The declarations are read in the sources |
| Haul and rescue training refused | none | `TrainableDef.minBodySize` is 0.40 and 0.65, and the animal is 0.2 at its largest: vanilla arithmetic. `03` asserts what the animal **can** do, which is what a player will try |
| "Do until you have X" refused | none | The refusal is vanilla's `CanCountProducts` on a recipe with no products; the mod's part is having none, which is read offline |
| The mod list flagging the two mods as incompatible | none | The engine's, not the mod's |
| Butchering the corpse | `03` asserts the `LeatherAmount` stat the butchering reads | `ButcherProducts` rounds that stat at random. Playing the butchering would test the rounding |
| A pass with optional mods | none | The mod declares no optional mod and no `loadAfter` beyond Core |
| A pass without a DLC | none | The content needs no DLC |
| An upgrade from a previous revision | none | The only earlier upload, 0.1.0, held the same `Mod/` |

## The local steps

`Source/DustBunnySteps.cs`, 11 steps, all prefixed `Dust Bunnies Renew:` because Pickle matches on text alone
across every suite loaded. Each exists because no stock or shared step does it:

- **the `[DefOf]` bound**, by reflection so this companion needs no reference to the mod's assembly;
- **count the dust bunnies on the map**, exactly, so a double spawn is caught;
- **the animal is on the colony's side**: a made animal takes the bill doer's faction, and a null there leaves a
  wild animal standing beside the colonist;
- **body size and a stat, between two bounds**, read from the living pawn;
- **whether training is allowed**, with the game's own reason when it is refused;
- **the bunny joining the colony**, because the generic spawn step leaves a wild animal and only a colony animal has a training tracker;
- **the animal's label on both its defs**, since the player reads either;
- **the body clock Nocturnal Animals reads off the def**, by reflection, saying which half broke: its assembly, the extension, or the clock;
- **which surgeries an animal is offered, compared with a reference animal's**, and the reverse: a category-3
  animal is offered some the dust bunny is not. Two steps, and by design they name no recipe.

Build with `dotnet build Tests/Pickle/Source/DustBunniesRenew.PickleSteps.csproj -c Release`. The output is
`Mod/Pickle/Assemblies/`, which is tracked, and the intermediates go to `.build/`, which is not. Rebuild before
every run: Pickle loads step DLLs when the game starts.

## Passes

Five passes: the minimal set in English, the minimal set in French, the original mod beside this one, A Dog
Said... Animal Prosthetics 2 beside it, and Nocturnal Animals beside it (`wsl-deps.avec-nocturnal.map`). The mod declares no hard dependency and no `loadAfter` beyond Core, so the
minimal set needs no map: without `-DepMap` the launcher stages Core, the DLCs, Pickle, Harmony, RimLogging and the
mod. The two passes with another mod each have their own map, `wsl-deps.incompat-original.map` and
`wsl-deps.avec-ads2.map`. That map names this mod's own packageId with `path:` above the ADS 2 line: the staging activates a map's mods in its order and the mod under test last, so ADS 2 alone would load first, which the first run of the pass read (see the map).

Tags decide what runs where: `@en-only` and `@fr-only` follow the language of the labels they name, and `@slow`
(`02` and the first scenario of `03`) is played once, in English, because none of it depends on the language.
`07` carries `@requires:BlockHen.Animal.DustBunnies` and `08` carries `@requires:SamBucher.ADogSaidAnimalProsthetics2` and `09` carries `@requires:Mlie.XNDNocturnalAnimals`,
so each is skipped everywhere but its own pass, and a report has to show it skipped elsewhere and played there.

A run is a ticket, filed with TicketDispatcher, which follows it: this mod's session watches nothing itself, and
never starts the launcher by hand. A request carries **no revision**: the mod is staged from the working tree at the
moment its ticket plays, so the tree stays untouched between filing and the last `RUN_DONE`. Small tickets, one per
pass. An exploration or fix ticket plays as few scenarios as possible (`-Filter '::<scenario>'`); an initial or final
ticket plays every scenario of its pass, and the four below are four initial tickets. From the collection root:

```powershell
$submit = 'Rimworld-Ticket-Dispatcher\scripts\Submit-PickleRun.ps1'   # -Owner is this session's id, from get_session
powershell.exe -ExecutionPolicy Bypass -File $submit -Mod DustBunniesRenew -Owner local_<id> -Label '<what>' -Language English -Filter 'Dust Bunnies Renew - Pickle tests,!@fr-only' -EvidenceDir DustBunniesRenew/Tests/Pickle/Evidence/<date>-english
powershell.exe -ExecutionPolicy Bypass -File $submit -Mod DustBunniesRenew -Owner local_<id> -Label '<what>' -Language French -Filter 'Dust Bunnies Renew - Pickle tests,!@en-only,!@slow' -EvidenceDir DustBunniesRenew/Tests/Pickle/Evidence/<date>-french
powershell.exe -ExecutionPolicy Bypass -File $submit -Mod DustBunniesRenew -Owner local_<id> -Label '<what>' -Language English -DepMap wsl-deps.incompat-original.map -Filter '07-original-mod-incompatibility' -EvidenceDir DustBunniesRenew/Tests/Pickle/Evidence/<date>-incompat
powershell.exe -ExecutionPolicy Bypass -File $submit -Mod DustBunniesRenew -Owner local_<id> -Label '<what>' -Language English -DepMap wsl-deps.avec-ads2.map -Filter '08-animal-prosthetics-2' -EvidenceDir DustBunniesRenew/Tests/Pickle/Evidence/<date>-ads2
powershell.exe -ExecutionPolicy Bypass -File $submit -Mod DustBunniesRenew -Owner local_<id> -Label '<what> <sha>' -Language English -DepMap wsl-deps.avec-nocturnal.map -Filter '09-nocturnal-animals' -EvidenceDir DustBunniesRenew/Tests/Pickle/Evidence/<date>-nocturnal
```

Read `exitReason` before the counts, and compare the scenarios played with the scenarios discovered for the filter.

## Before queuing

```powershell
dotnet build Tests/Pickle/Source/DustBunniesRenew.PickleSteps.csproj -c Release
powershell -NoProfile -ExecutionPolicy Bypass -File Tests/Pickle/Check-Steps.ps1
pwsh -NoProfile -File _tools/Test-Mod.ps1
```

`Check-Steps.ps1` compiles every local pattern with Pickle's own expression engine, and matches every step line
of every feature against Pickle's vocabulary, the shared tools in the pass map and this suite's own. It fails on
an undefined step, an ambiguous one, an invalid pattern (an unescaped `(` makes the **whole run** play zero
scenarios) and a duplicate. It proves a step's text exists, not that it does what a scenario hopes. Checked on
2026-09-24 against three deliberate faults, one of each kind, on a copy outside the repository: all three exit 1,
and the untouched suite exits 0.

## Evidence

Raw reports go to `Evidence/` under this folder, which `.gitignore` excludes. What to keep and what to delete is
in `../../TESTING.md`, "Evidence to keep". `Minify-Evidence.ps1` shrinks a copied report in place: screenshots
become JPEG (quality 80, at most 1280 px), and `report.html` and `messages.ndjson` go.

## What the first run has to confirm

None of this was seen running. These are the assumptions a green first run confirms and a red one names.

1. A generated colonist can do Crafting. `02` and `03` ask before depending on it, so a refusal fails there, with
   its cause, and not as a bill that never finishes.
2. `a "CraftingSpot" is built at (146, 155)` builds instantly on ground that is open in `test-colony`. Other
   suites use the same cells and some have run.
3. `I wait for a "DustBunny" to exist` counts a **pawn** of that race among the things of its ThingDef. If it does
   not, `03`'s first scenario fails at the wait even though the recipe worked.
4. Two stacks of dust (the stack limit is 75) are fetched and the work of 800 is done inside the 30 seconds a
   wait step allows, at ultrafast speed. The launcher measured 500 to 700 ticks a second.
5. `I spawn a "DustBunny" pawn at (140, 155)` accepts a pawn kind's defName and the animal, unowned, has a
   training tracker.
6. The living animal reads a body size of 0.04, a `LeatherAmount` between 5 and 6.5 and a `Wildness` of 0.1. The
   first is read from `Pawn.BodySize`, whose source was checked; the others follow from it.
7. `-Language French` resolves the `French` language folder, and the two accented strings are compared exactly.
8. `wsl-deps.incompat-original.map` stages the original **before** the mod under test, and the original's
   1.3 folder loads under 1.6. It is subscribed in the Windows Workshop, which the staging script reads first; whether staging really places it before this mod is what the scenario's "loads after" line asserts.
9. `@allow-errors` is enough for whatever the original's assembly, built for 1.3, logs on its own account.
10. In `08`, the surgeries ADS 2 adds are in `ThingDef.AllRecipes` of the dust bunny at the main menu, and a
    recipe is a surgery by `RecipeDef.IsSurgery`. The staged ADS 2 lists a Squirrel in category 1 only and a Cat in
    all three: read on 2026-09-24 from version 1.3.7 of its source, and the staged build is the same version. The
    copy fetched into the WSL cache that day reports 1.3.7 too, and was checked: Squirrel and Rat appear only under
    `ADS_Cat1`, Cat under all three.
