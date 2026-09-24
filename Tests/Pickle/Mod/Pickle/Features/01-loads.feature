# Runtime checks only. _tools/Test-Mod.ps1 owns the XML contracts and the translation paths. What only
# a running game shows is what the game's own loader made of the defs, and whether the mod's one class bound.
#
# The failure this feature is here for leaves no line in a scenario's window: a `workerClass` the loader cannot
# resolve does not kill the RecipeDef, it leaves the field at the base class, so the recipe still lists, still
# takes its hundred dust and still finishes, and produces nothing. `Could not find type named` is logged once at
# startup, before any scenario starts, so `no errors were logged` cannot see it. Asserting the resolved class is
# what does.
Feature: Dust Bunnies Renew loads in the minimal set

  Scenario: the mod and its principal defs load, and the recipe worker resolved
    Then mod "nelim.dustbunniesrenew" is loaded
    And def "DustBunny" of type "ThingDef" exists
    And def "DustBunny" of type "PawnKindDef" exists
    And def "Dust" of type "ThingDef" exists
    And def "GatherDust" of type "RecipeDef" exists
    And def "MakeDustBunny" of type "RecipeDef" exists
    And def "MakeDustBunny" field "workerClass" is "DustBunnies.Recipe_SpawnDustBunny"
    And Dust Bunnies Renew: the DefOf class has bound the dust bunny
    And no warnings from mod "Dust Bunnies Renew (unofficial)"
    And no errors were logged
