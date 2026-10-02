# The Workshop gallery, produced by a scenario instead of by hand (AUDIT.md, "Captures destinées à la
# publication"): reproducible after any interface change, and PUBLICATION.md's "Gallery order" names exactly
# these four images.
#
# This is a review scenario, like 10-french-dialogs: it asserts that each capture was taken, not what is on
# the picture. Its green proves the journey ran; the four captures still have to be OPENED AND LOOKED AT before
# they go on the Workshop page (AUDIT.md, tested -> prepublished, "Ordre des captures").
#
# Needs PickleTools' Zen Meadow Screenshot Studio (its own fixture, its native-capture presentation mode), ColonistRace
# (hair, body, dyed clothes), StageDecor (lamp, stool) and ScreenshotMode (for the dialogs), staged only in the pass whose map names them:
#
#   -Language English -DepMap wsl-deps.gallery.map -Filter '11-gallery-captures'
#
# English only: the gallery is the same page's first, most demonstrative image and its dialogs, and About.xml's
# description is English (PUBLISHING.md, "Écrire en anglais").
@requires:nelim.pickletools.screenshotstudio
@requires:nelim.pickletools.screenshotmode
@requires:nelim.pickletools.colonistrace
@requires:nelim.pickletools.stagedecor
Feature: the Workshop gallery images

  # A staged photograph, not a screen grab (owner's rule, 2026-10-02: every gallery capture is staged except the
  # menus). The story: Miel has just made her first dust bunny out of a hundred heaps of dust and crouches in the
  # glade to look at it. The scale is the point, so the animal sits two cells from her, the camera comes down to
  # it, and everything else is chosen to make a small grey animal stand out: a warm meadow behind it, a teal
  # shirt and deep plum trousers on Miel against the orange and red flowers, her hair a dark auburn, a lamp and a
  # stool for the set. The dust bunny is the only grey thing in the frame.
  @review
  Scenario: the live dust bunny next to a colonist, showing scale
    Given the save "nelim-zen-meadow-studio" is loaded
    And game speed is paused
    And Nelim's Pickle Tools: "Miel" body type is Female
    And Nelim's Pickle Tools: "Miel" hairstyle is "FancyBun"
    And Nelim's Pickle Tools: "Miel" hair colour is rgb (105, 52, 28)
    And Nelim's Pickle Tools: "Miel" wears "Apparel_BasicShirt" dyed rgb (22, 140, 150)
    And Nelim's Pickle Tools: "Miel" wears "Apparel_Pants" dyed rgb (92, 38, 84)
    When Nelim's Pickle Tools: I frame the studio "flowers"
    And Nelim's Pickle Tools: I place the decor "StandingLamp" at (153, 101)
    And Nelim's Pickle Tools: I place the decor "Stool" at (158, 101)
    And Dust Bunnies Renew: a dust bunny is spawned beside the colonist "Miel"
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And Dust Bunnies Renew: the camera is centred on the dust bunny at zoom 6
    And I take a screenshot "the dust bunny in the meadow, scale"
    And Nelim's Pickle Tools: the decor is removed
    Then no errors were logged

  @review
  Scenario: the bill dialog and the information cards of the dust bunny and of the dust, in English
    Given the save "test-colony" is loaded
    And a "CraftingSpot" is built at (146, 155)
    And I add bill "MakeDustBunny" to the "CraftingSpot"
    When Dust Bunnies Renew: the bill dialog for "MakeDustBunny" is open
    And Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "bill dialog of the dust bunny recipe, English"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And I close all dialogs
    When Dust Bunnies Renew: the information card of "DustBunny" is open
    And Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "information card of the dust bunny, English"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And I close all dialogs
    When Dust Bunnies Renew: the information card of "Dust" is open
    And Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "information card of the dust, English"
    And Nelim's Pickle Tools: screenshot mode is disabled
    Then no errors were logged
