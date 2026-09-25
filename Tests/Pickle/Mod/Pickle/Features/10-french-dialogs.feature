# The dialogs a player reads, in French, for a person to look at: the bill dialog of the dust bunny recipe and the
# information cards of the animal and of the dust. TRANSLATIONS.md asks for raw keys, fallback text and clipping
# to be looked for in the game, in both languages, and no offline check can see clipping.
#
# This is a review scenario. It asserts that each dialog opened; it says nothing about what is on the picture. Its
# green proves the journey ran, and the three captures have to be OPENED AND LOOKED AT (AUDIT.md, done -> tested): a
# raw key or a letter with a stray accent in the middle of a French sentence is a text that missed its translation,
# because the runner's developer mode shows the game's fallback in that accented form; a clean English word in the
# middle of French never went through Translate. Developer mode is left on for that reason: a capture without it
# proves nothing about the keys.
#
# It needs PickleTools' ScreenshotMode staged, which hides the HUD and Pickle's own panels and keeps the dialog, so it
# runs only in the pass whose map names it:
#
#   -Language French -DepMap wsl-deps.captures-fr.map -Filter '10-french-dialogs'
#
# and is skipped by requirement everywhere else. It is French only: an English capture proves nothing more, the
# English text being the def's own.
@requires:nelim.pickletools.screenshotmode
@fr-only
Feature: the bill and information dialogs read in French

  @review
  Scenario: the bill dialog and the information cards of the dust bunny and of the dust, in French
    Given the save "test-colony" is loaded
    And a "CraftingSpot" is built at (146, 155)
    And I add bill "MakeDustBunny" to the "CraftingSpot"
    When Dust Bunnies Renew: the bill dialog for "MakeDustBunny" is open
    And Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "bill dialog of the dust bunny recipe, French"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And I close all dialogs
    When Dust Bunnies Renew: the information card of "DustBunny" is open
    And Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "information card of the dust bunny, French"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And I close all dialogs
    When Dust Bunnies Renew: the information card of "Dust" is open
    And Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "information card of the dust, French"
    And Nelim's Pickle Tools: screenshot mode is disabled
    Then no errors were logged
