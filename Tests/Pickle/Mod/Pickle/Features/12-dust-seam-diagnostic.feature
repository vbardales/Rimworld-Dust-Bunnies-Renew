# DIAGNOSTIC, not part of the gallery or of the regression set: where do the one-pixel vertical lines of the gallery
# captures come from? Ticket ed2e and 7f68 (11-gallery-captures, image 1) showed thin vertical lines along the edges of
# the placed Dust items (drawSize 3), one more line for each item, and none in the same scene without the items.
# NPT (2026-10-07): StageDecor draws nothing; suspected texture edge bleed of a quad larger than its cell.
#
# Same place, same camera, same nine cells as image 1, with the presentation mode OFF, with Silver (a small vanilla item)
# and then with the mod's Dust. Lines with Dust only: the graphic of the mod. Lines with both: NPT's side.
#
#   -Language English -DepMap wsl-deps.gallery.map -Filter '12-dust-seam-diagnostic'
@requires:nelim.pickletools.screenshotstudio
@requires:nelim.pickletools.camerazoom
@requires:nelim.pickletools.stagedecor
Feature: the one-pixel lines around placed dust

  @review
  Scenario: nine Silver items on the rug, no presentation mode
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And I set the hour to 12
    And I set the weather to "Clear"
    And Nelim's Pickle Tools: the animals are removed from the sanctuary "sleeping-nook"
    And Nelim's Pickle Tools: I am at the sanctuary "sleeping-nook"
    And Nelim's Pickle Tools: the camera root size is set to 4
    When Nelim's Pickle Tools: I place the decor "Silver" at (177, 120)
    And Nelim's Pickle Tools: I place the decor "Silver" at (179, 120)
    And Nelim's Pickle Tools: I place the decor "Silver" at (180, 120)
    And Nelim's Pickle Tools: I place the decor "Silver" at (176, 119)
    And Nelim's Pickle Tools: I place the decor "Silver" at (177, 119)
    And Nelim's Pickle Tools: I place the decor "Silver" at (178, 119)
    And Nelim's Pickle Tools: I place the decor "Silver" at (179, 119)
    And Nelim's Pickle Tools: I place the decor "Silver" at (179, 121)
    And Nelim's Pickle Tools: I place the decor "Silver" at (180, 121)
    And I take a screenshot "seam diagnostic, silver, no presentation"
    And Nelim's Pickle Tools: the decor is removed
    Then no errors were logged

  @review
  Scenario: nine Dust items on the rug, no presentation mode
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And I set the hour to 12
    And I set the weather to "Clear"
    And Nelim's Pickle Tools: the animals are removed from the sanctuary "sleeping-nook"
    And Nelim's Pickle Tools: I am at the sanctuary "sleeping-nook"
    And Nelim's Pickle Tools: the camera root size is set to 4
    When Nelim's Pickle Tools: I place the decor "Dust" at (177, 120)
    And Nelim's Pickle Tools: I place the decor "Dust" at (179, 120)
    And Nelim's Pickle Tools: I place the decor "Dust" at (180, 120)
    And Nelim's Pickle Tools: I place the decor "Dust" at (176, 119)
    And Nelim's Pickle Tools: I place the decor "Dust" at (177, 119)
    And Nelim's Pickle Tools: I place the decor "Dust" at (178, 119)
    And Nelim's Pickle Tools: I place the decor "Dust" at (179, 119)
    And Nelim's Pickle Tools: I place the decor "Dust" at (179, 121)
    And Nelim's Pickle Tools: I place the decor "Dust" at (180, 121)
    And I take a screenshot "seam diagnostic, dust, no presentation"
    And Nelim's Pickle Tools: the decor is removed
    Then no errors were logged
