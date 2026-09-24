# A pass of its own: this file plays only when A Dog Said... Animal Prosthetics 2 (Workshop 3238353862, package
# SamBucher.ADogSaidAnimalProsthetics2) is staged, with
#
#   Run-PickleWsl.ps1 -Mod DustBunniesRenew -DepMap wsl-deps.avec-ads2.map -Filter '08-animal-prosthetics-2'
#
# and is skipped by requirement in every other pass, where it counts as skipped and not as passed.
#
# The mod enrols the dust bunny in ADS 2's category 1 only, the smallest: a peg leg or a denture. ADS 2 copies its
# three category lists onto the surgery bases once, in its own last patch, so this mod's patch has to run BEFORE
# that copy, which is what `loadBefore` in About.xml is for. The offline check proves the patch and the declaration
# are what they should be. Only a running game shows that the surgeries reached the animal, and only loading the
# two mods in this order shows that the order held.
#
# No surgery is named. ADS 2 does not define its recipes in its own repository, and their names are not this mod's
# to know, so the scenario compares. The dust bunny must be offered what a Squirrel is offered: ADS 2 lists the
# Squirrel in category 1 and in no other. And a Cat, which it lists in all three, must be offered surgeries the
# dust bunny is not: the bionics. Both comparisons hold whatever the recipes are called, and both fail saying
# which surgeries differ.
#
# It needs no save. The def database is built before a game exists, and the recipes an animal is offered are
# settled by then.
@requires:SamBucher.ADogSaidAnimalProsthetics2
Feature: the dust bunny is enrolled in Animal Prosthetics 2, in its first category only

  Scenario: the dust bunny is offered what a squirrel is, and less than a cat
    Then mod "SamBucher.ADogSaidAnimalProsthetics2" is loaded
    And mod "nelim.dustbunniesrenew" is loaded
    And mod "nelim.dustbunniesrenew" loads before "SamBucher.ADogSaidAnimalProsthetics2"
    And Dust Bunnies Renew: the dust bunny is offered the same surgeries as the "Squirrel"
    And Dust Bunnies Renew: the "Cat" is offered surgeries the dust bunny is not
    And no errors were logged
