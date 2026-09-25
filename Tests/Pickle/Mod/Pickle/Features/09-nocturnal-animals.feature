# A pass of its own: this file plays only when [XND] Nocturnal Animals (Continued) (Workshop 2269731409, package
# Mlie.XNDNocturnalAnimals) is staged, with
#
#   -DepMap wsl-deps.avec-nocturnal.map -Filter '09-nocturnal-animals'
#
# and is skipped by requirement in every other pass, where it counts as skipped and not as passed.
#
# Nocturnal Animals gives an animal a body clock through a mod extension on its ThingDef, and an animal without one is
# diurnal. The dust bunny carries the extension with MayRequire, so that the item is skipped, and nothing is logged,
# when the mod is absent: which is what every other pass shows, by its startup log. Here the extension has to
# have arrived, on the dust bunny's ThingDef, with the clock Virginie chose, Nocturnal (2026-09-25).
#
# It needs no save: the extension is read off the def, which is built before a game exists.
@requires:Mlie.XNDNocturnalAnimals
Feature: the dust bunny is nocturnal when Nocturnal Animals is loaded

  Scenario: the dust bunny keeps a nocturnal body clock
    Then mod "Mlie.XNDNocturnalAnimals" is loaded
    And mod "nelim.dustbunniesrenew" is loaded
    And Dust Bunnies Renew: the dust bunny body clock is "Nocturnal"
    And no errors were logged
