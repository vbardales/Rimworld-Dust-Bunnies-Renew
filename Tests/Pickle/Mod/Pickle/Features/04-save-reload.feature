# What has to survive a save. `the save round trips` saves and reloads and fails on anything the error log took
# during the trip. The two scenarios are the two things this mod puts in a save that vanilla does not know about
# by name: a bill for a recipe whose worker is the mod's own class, and an animal with no life stage but the baby
# one. The fixture colony was saved without this mod, so every scenario here is also the mod added to an existing
# colony.
#
# A reload replaces every object in the game, so nothing is carried from before it: the steps look the animal up
# again each time.
Feature: a queued bill and a made animal survive a save

  Background:
    Given the save "test-colony" is loaded

  Scenario: a queued bill for the dust bunny recipe is still queued after a reload
    Given a "CraftingSpot" is built at (146, 155)
    And 100 "Dust" is spawned at the stockpile
    When I add bill "MakeDustBunny" to the "CraftingSpot"
    And the save round trips
    Then the "CraftingSpot" has 1 bills
    And no errors were logged

  Scenario: a dust bunny is still there, and still one, after a reload
    Given I spawn a "DustBunny" pawn at (140, 155)
    When I save and reload
    Then a "DustBunny" exists
    And Dust Bunnies Renew: the map holds 1 dust bunny
    And no errors were logged
