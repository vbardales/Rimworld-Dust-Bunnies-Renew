# The French text ON THE LOADED DEFS, in a pass launched with `-Language French`. The offline
# `Check-DefInjected` proves the injection paths resolve; only a running game shows that the game found the
# language folder and injected it. A folder it does not find is silent, above all on Linux.
#
# The language is chosen at launch and never switched during a run. This feature names the French text, so it
# belongs to the French pass and is excluded from the English one by its tag.
#
# It needs no save. The def database is built before a game exists.
@fr-only
Feature: the labels the player reads, in French

  Scenario: the animal, the material and the two recipes read in French
    Then Dust Bunnies Renew: the dust bunny animal is labelled "mouton de poussière"
    And def "Dust" field "label" is "poussière"
    And def "GatherDust" field "label" is "récolter de la poussière"
    And def "GatherDust" field "jobString" is "Récolte de la poussière."
    And def "MakeDustBunny" field "label" is "fabriquer un mouton de poussière"
    And def "MakeDustBunny" field "jobString" is "Fabrique un mouton de poussière."
