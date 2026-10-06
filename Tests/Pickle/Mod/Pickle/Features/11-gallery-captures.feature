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
@requires:nelim.pickletools.camerazoom
@requires:nelim.pickletools.stagedecor
Feature: the Workshop gallery images

  # THE SERIES (owner's rules, PUBLISHING.md, 2026-10-02 and 2026-10-06: every capture is a staged photograph except the
# menus; one story for the series; the photographer chooses place, moment and composition).
#
# The story: spring cleaning in the Sanctuary. Nelim sweeps the dust off her floor, piles a hundred of it on the crafting
# spot and, a short while later, the dust gets up and walks: a dust bunny, tame the moment it exists. The series runs in
# the order of the scenarios of this file.
#
# SHOOTING PLAN, one line per image (place; moment; subject; composition; the living thing; what the image says):
#   1  sleeping-nook (Nelim's bed on the white rug, the Sanctuary's hearth hall); midday, hour 12, a minute of set-up;
#      the live dust bunny, at the foot of the bed; low and close (zoom 6), the animal in the lower middle, Nelim
#      standing two cells away and looking at it, the royal bed and the drapes behind; Nelim herself, in teal and plum
#      against the white rug and the warm wood, the one grey thing in the frame being the bunny; "it is alive, and it is
#      tiny": the scale, and the reward of the whole recipe.
#   2  the bill dialog of "Make a dust bunny" (a menu, a plain screenshot of the dialog on the test colony): the
#      hundred dust it asks for, the work amount, the crafting spot.
#   3  the information card of the dust bunny (a menu): what it is, what it never needs, how it trains.
#   4  the information card of the dust (a menu): the material the bunny comes from and goes back to.
# The cumulative-time recipe of PUBLISHING.md is not needed here: image 1 is the only image of the map, the others show
# windows, so no scenario has anything to age. The living thing is placed after the set-up wait, so it has not left.
#
# This is a review scenario, like 10-french-dialogs: it asserts that each capture was taken, not what is on the picture.
# Its green proves the journey ran; each capture has to be OPENED AND LOOKED AT before it goes on the Workshop page
# (AUDIT.md, tested -> prepublished, "Ordre des captures").
#
# Needs PickleTools' ScreenshotStudio (the Sanctuary fixture, its framing and presentation steps), ColonistRace (Nelim's
# clothes), CameraZoom (zoom 6, after the Sanctuary framing lifts the game's clamp) and ScreenshotMode (for the dialogs), staged only in the pass whose map names them:
#
#   -Language English -DepMap wsl-deps.gallery.map -Filter '11-gallery-captures'
#
# English only: the gallery is the same page's first, most demonstrative image and its dialogs, and About.xml's
# description is English (PUBLISHING.md, "Écrire en anglais").
@requires:nelim.pickletools.screenshotstudio
@requires:nelim.pickletools.screenshotmode
@requires:nelim.pickletools.colonistrace
Feature: the Workshop gallery images

  @review
  Scenario: image 1, the live dust bunny at the foot of Nelim's bed, showing scale
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And I set the hour to 12
    And I set the weather to "Clear"
    And Nelim's Pickle Tools: the animals are removed from the sanctuary "sleeping-nook"
    And Nelim's Pickle Tools: I am at the sanctuary "sleeping-nook"
    And Nelim's Pickle Tools: the camera root size is set to 6
    And Nelim's Pickle Tools: the camera root size is 6
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_BasicShirt" dyed rgb (22, 110, 120)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Pants" dyed rgb (92, 38, 84)
    And Nelim's Pickle Tools: "Nelim" stands at (176, 120) facing East
    And I wait 60 ticks
    When Dust Bunnies Renew: a dust bunny is spawned at (178, 120)
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I take a screenshot "image 1, the dust bunny at the foot of the bed, scale"
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
