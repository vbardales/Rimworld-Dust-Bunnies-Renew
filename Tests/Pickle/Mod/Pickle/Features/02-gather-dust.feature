# The first half of the chain: dust comes off the floor. The recipe declares no ingredient, so a bill at an empty
# bench must still run to its end, and the ten dust it makes must be the only dust on the map.
#
# The bench is a crafting spot, built at a cell other suites also use on this fixture. A colonist is made rather
# than borrowed, and asked whether Crafting is enabled before anything depends on it: a generated colonist can
# refuse the work, and a scenario that waits on a refusing colonist fails for a reason that is not the mod's.
#
# 1.7 (2026-10-30): the stock `I wait for bill ... to finish` ended this scenario after 168 s with no reason, well under
# the timeout, so the wait is PickleTools' step with explicit stop rules (ticks, seconds, count rose) that logs why it stopped.
# The pass stages ColonistRace: `wsl-deps.bills17.map`.
@slow @timeout:1200 @requires:nelim.pickletools.colonistrace
Feature: a colonist gathers dust from nothing

  Background:
    Given the save "test-colony" is loaded
    And a colonist "Sweeper" exists
    Then "Sweeper" can do "Crafting"
    When I set "Sweeper" priority "Crafting" to 1
    And a "CraftingSpot" is built at (146, 155)

  Scenario: a bill to gather dust makes ten dust and consumes nothing
    Given no "Dust" exists
    When I add bill "GatherDust" to the "CraftingSpot"
    And game speed is ultrafast
    And Nelim's Pickle Tools: I wait up to 6000 ticks or 900 seconds until more "Dust" exist
    Then 10 "Dust" exist
    And no errors were logged
