# Local validation tools

These four checkers were copied from the former workspace scripts on 2026-09-12 so this
repository can validate independently. Check-DefRefs and Check-XmlClasses additionally
return exit code 1 for findings, allowing Test-Mod.ps1 to fail reliably.

Run `pwsh -NoProfile -File _tools/Test-Mod.ps1` from the repository root. A .NET SDK,
PowerShell 7 and a RimWorld 1.6 installation are required; -GameRoot overrides its path.
-SkipBuild validates the existing DLL and must not be reported as a fresh build.

The XML checkers approximate the game loader using reflection; they cannot certify gameplay.
No game data or reference DLLs are vendored here. Compiled hook verification uses the shipped
mod DLL; XML type discovery also consults local sources. Manually exercise the completed bill
in RimWorld even when all static checks pass.

## Check-Claims.ps1

Written for this repository, not copied from the workspace. It asserts the facts the public description and the
docs state, against the XML and the game's own data, and each has already been wrong once: both recipes offered at
the crafting spot only; `MakeDustBunny` declaring no `<products>`; wildness under `statBases` and nowhere in
`<race>`; dust the worst cold insulator of every material a garment can be made from, no more flammable as a stuff
than cloth and as flammable as wood; and the butchering yield, computed the way the game does it.

"A garment can be made from" is read from the game as the union of the `stuffCategories` of every apparel def.
Materials are resolved through `ParentName` before comparing, and a stuff that states no insulation counts as the
stat's default, 0. The yield is the base body size times the body size factor of the race's only life stage times
`LeatherAmount`, through the stat's `postProcessCurve`: about 5.6 for a body size of 0.04. Read off the def
instead, it says about 18, which is the figure the description once claimed.

Seen to fail on 2026-09-24, on a copy of `Mod/Defs` outside the repository, one mutation each: a second bench in
`recipeUsers`; `<products>` added to `MakeDustBunny`; `<wildness>` put back in `<race>`; `Wildness` removed from
`statBases`; dust's cold insulation set to 3; its flammability factor set to 1.3; its flammability set to 1.2; the
base body size set to 0.5; a second life stage. All nine exit 1 with the matching message, and the untouched mod
exits 0.
