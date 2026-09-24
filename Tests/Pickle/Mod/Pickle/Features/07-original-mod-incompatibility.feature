# A pass of its own: this file plays only when the original mod (Workshop 2659958183, package
# BlockHen.Animal.DustBunnies) is staged, with
#
#   Run-PickleWsl.ps1 -Mod DustBunniesRenew -DepMap wsl-deps.incompat-original.map -Filter '07-original-mod-incompatibility'
#
# and is skipped by requirement in every other pass, where it counts as skipped and not as passed.
#
# About.xml declares the two incompatible because they define the same defNames. RimWorld does not refuse two
# mods that do. DefDatabase.AddAllInMods removes the earlier def of a name and adds the later one, so the game
# keeps ONE copy and the mod that loads last owns it. That is the symptom this scenario asserts, and it is
# asserted as an ownership and not as a log line: whether the game also logs something is not what a player is
# harmed by, and it is not asserted either way.
#
# It stays green while the incompatibility is still true. If the original stops defining these names, or stops
# loading on 1.6, the scenario goes red, and that is the day the incompatibleWith line can be reconsidered.
#
# It starts from the main menu, not from a save: the clash is settled while the defs load. The tag below stops
# an error from the original's own assembly, which was built for 1.3 and is not this mod's to answer for, from
# failing the scenario on its own account.
@requires:BlockHen.Animal.DustBunnies @allow-errors
Feature: the declared incompatibility with the original mod is still true

  Scenario: with both loaded, the mod that loads last owns the defs
    Then mod "BlockHen.Animal.DustBunnies" is loaded
    And mod "nelim.dustbunniesrenew" is loaded
    And mod "nelim.dustbunniesrenew" loads after "BlockHen.Animal.DustBunnies"
    And def "MakeDustBunny" is defined by mod "nelim.dustbunniesrenew"
    And def "GatherDust" is defined by mod "nelim.dustbunniesrenew"
    And def "Dust" is defined by mod "nelim.dustbunniesrenew"
