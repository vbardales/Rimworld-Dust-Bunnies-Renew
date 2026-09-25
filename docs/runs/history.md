# Runs, one line each

Newest last. The evidence itself is never kept as folders: only the latest report that still proves something stays
on disk (`Tests/Pickle/Evidence/`, ignored by git), minified, each with a `steps.txt` of step outcomes. Times are the
game log's own. A run that needs more than a line gets a file next to this one.

- 2026-09-24 21:27, pass 1 English (request 20260924-165202-390-506b), tree of `8ebb42d` plus documentation: `exitReason: failed`, 10 discovered, 7 passed, 1 failed, 2 skipped by requirement (07, 08). The failure is "can be trained": no training tracker on an unowned spawned animal, a fault of the test. Startup logged `ToxicSensitivity`, a stat 1.6 no longer defines: a fault of the mod. Evidence kept: `2026-09-24-english`.
- 2026-09-24 21:32, pass 2 French (request 20260924-165202-869-d71d), same tree: `exitReason: failed`, 8 discovered, 5 passed, 1 failed (the same training scenario), 2 skipped. The French labels scenario passed. Evidence kept: `2026-09-24-french`.
- 2026-09-24 21:35, pass 3 original mod beside this one (request 20260924-165203-308-7a77): `exitReason: passed`, 1 of 1: the mod that loads last owns the defs, the original loads before it. `@allow-errors` was needed: the original's 1.3 assembly logs `<wildness>` and `ToxicSensitivity` errors of its own. Evidence kept: `2026-09-24-incompat`.
- 2026-09-24 22:02, pass 4 Animal Prosthetics 2 (request 20260924-165810-057-f694): `exitReason: failed`, 1 of 1 failed on its first line, `should load before`: the staging put ADS 2 before this mod. A fault of the harness order, not of the mod. Evidence deleted; the rerun below supersedes it.
- 2026-09-25 10:55, fix ticket `43b6`, `::the living dust bunny can be trained to guard and to attack`, English, tree of `8bc4401`: `exitReason: passed`, 1 of 1. Once the bunny joins the colony, `Obedience` and `Release` are accepted. Evidence kept: `2026-09-24-fix-training`.
- 2026-09-25 10:57, fix ticket `828c`, `::the living dust bunny has the size and the yield the description gives`, English, same tree: `exitReason: passed`, 1 of 1, `ToxicResistance` 0.99 to 1.01 on the living animal; `ToxicSensitivity` is gone from the startup log. Evidence kept: `2026-09-24-fix-toxic`.
- 2026-09-25 11:20, fix ticket `d50c`, `::the dust bunny is offered what a squirrel is, and less than a cat`, English, map `wsl-deps.avec-ads2.map` naming this mod above ADS 2, tree of `94e06a5`: `exitReason: passed`, 1 of 1: both loaded, loads before, offered what the Squirrel is and less than the Cat, no errors. Evidence kept: `2026-09-25-fix-ads2`.
