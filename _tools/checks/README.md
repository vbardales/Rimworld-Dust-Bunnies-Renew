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
