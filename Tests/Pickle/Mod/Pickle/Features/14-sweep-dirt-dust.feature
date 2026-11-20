# Sweeping a dirt filth leaves one Dust (DustBunnies.Filth_DirtDust, Patches/FilthDirtDust.xml), and only a sweep does.
#
# A colonist is made rather than borrowed and asked whether Cleaning is enabled first, as in 02. Dirt is spread on one cell next to
# the bench cell of 02; one swept cell gives exactly one Dust. The colonist's Cleaning priority is 1, so the cleaning work giver sweeps it
# on its own (the cells must be in the home area of the fixture: if the colonist never moves, that is the first thing to read).
# The wait is PickleTools' step with explicit stop rules: it ends when a Dust appears and logs why it stopped.
@slow @timeout:1200 @requires:nelim.pickletools.colonistrace
Feature: sweeping a dirt filth leaves dust

  Background:
    Given the save "test-colony" is loaded
    And a colonist "Sweeper" exists
    Then "Sweeper" can do "Cleaning"
    When I set "Sweeper" priority "Cleaning" to 1

  Scenario: a colonist sweeps dirt and dust appears
    Given no "Dust" exists
    And Nelim's Pickle Tools: the filth "Filth_Dirt" is spread from (141, 151) to (141, 151)
    When game speed is ultrafast
    And Nelim's Pickle Tools: I wait up to 6000 ticks or 900 seconds until more "Dust" exist
    Then 1 "Dust" exist
    And no errors were logged
