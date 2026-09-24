# The text on the loaded defs, in a pass launched with `-Language English`. English is the Defs' own value, so
# this asserts nothing about the translation. It is the control: a pass that claims to be English really ran in
# English, exactly as the French feature is the control for French.
#
# It needs no save. The def database is built before a game exists.
@en-only
Feature: the labels the player reads, in English

  Scenario: the animal, the material and the two recipes read in English
    Then Dust Bunnies Renew: the dust bunny animal is labelled "dust bunny"
    And def "Dust" field "label" is "dust"
    And def "GatherDust" field "label" is "gather dust"
    And def "GatherDust" field "jobString" is "Gathering dust."
    And def "MakeDustBunny" field "label" is "make a dust bunny"
    And def "MakeDustBunny" field "jobString" is "Making a dust bunny."
