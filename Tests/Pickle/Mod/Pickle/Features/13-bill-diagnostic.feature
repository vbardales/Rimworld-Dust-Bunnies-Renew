# Diagnostic for the 1.7 pass (2026-10-17): `02` and `03` stay red on 1.7 although the animal's own scenarios pass.
# This feature plays no assertion about the product. It sets `02` up, then logs what stands between the colonist and
# the bill, at the start and after a little game time, so the log says whether she ever takes the job and which
# work giver refuses. Not part of the non-regression set.
@diagnostic @timeout:120
Feature: why a colonist does not take the gather dust bill

  Background:
    Given the save "test-colony" is loaded
    And a colonist "Sweeper" exists
    Then "Sweeper" can do "Crafting"
    When I set "Sweeper" priority "Crafting" to 1
    And a "CraftingSpot" is built at (146, 155)

  Scenario: the state of the colonist and of the bill, at once and after a while
    Given no "Dust" exists
    When I add bill "GatherDust" to the "CraftingSpot"
    And Dust Bunnies Renew: the work state of "Sweeper" is logged
    And game speed is ultrafast
    And I wait 600 ticks
    And Dust Bunnies Renew: the work state of "Sweeper" is logged
    And I wait 1200 ticks
    And Dust Bunnies Renew: the work state of "Sweeper" is logged
