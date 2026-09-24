# The reason this suite exists. The mod is one RecipeWorker method, and nothing calls it until a colonist finishes
# the bill: not loading, not queueing, not starting the work. So the only proof that it works is the bill ending
# and a live animal standing where the colonist did.
#
# A `MakeDustBunny` bill declares no products, so `I wait for bill ... to finish` has nothing to count and says
# so. The wait is on the animal itself: `I wait for a "DustBunny" to exist` counts things of a ThingDef on the map,
# which includes a pawn of that race.
#
# The last two scenarios are about the living animal, and spawn it by pawn kind instead of playing the recipe
# again. That is deliberate: they measure the animal, not the worker, and the worker has its own scenario. Every
# figure is read from the living pawn and never from its def. A def has no life stage, so its information card
# says the base body size of 0.2 and a leather amount near 18, while the animal, whose only life stage is
# AnimalBaby with a body size factor of 0.2, is 0.04 and yields about 6. The description once gave the def's
# figures.
Feature: making a dust bunny, and what the made animal is

  @slow @timeout:240 @review
  Scenario: a hundred dust become one dust bunny, and it is the colony's
    Given the save "test-colony" is loaded
    And a colonist "Maker" exists
    Then "Maker" can do "Crafting"
    When I set "Maker" priority "Crafting" to 1
    And a "CraftingSpot" is built at (146, 155)
    And no "DustBunny" exists
    And 100 "Dust" is spawned at the stockpile
    And I add bill "MakeDustBunny" to the "CraftingSpot"
    And game speed is ultrafast
    And I wait for a "DustBunny" to exist
    Then no "Dust" exists
    And Dust Bunnies Renew: the map holds 1 dust bunny
    And Dust Bunnies Renew: the dust bunny belongs to the colony
    When I zoom all the way in
    And I move the camera to (146, 155)
    And I take a screenshot "dust bunny made at the crafting spot"
    Then no errors were logged

  Scenario: the living dust bunny has the size and the yield the description gives
    Given the save "test-colony" is loaded
    And I spawn a "DustBunny" pawn at (140, 155)
    Then Dust Bunnies Renew: the dust bunny body size is between 0.039 and 0.041
    And Dust Bunnies Renew: the dust bunny stat "LeatherAmount" is between 5 and 6.5
    And Dust Bunnies Renew: the dust bunny stat "Wildness" is between 0.09 and 0.11
    And Dust Bunnies Renew: the dust bunny stat "ToxicResistance" is between 0.99 and 1.01
    And no errors were logged

  Scenario: the living dust bunny can be trained to guard and to attack
    Given the save "test-colony" is loaded
    And I spawn a "DustBunny" pawn at (140, 155)
    And Dust Bunnies Renew: the dust bunny joins the colony
    Then Dust Bunnies Renew: the dust bunny can be assigned training "Obedience"
    And Dust Bunnies Renew: the dust bunny can be assigned training "Release"
    And no errors were logged
