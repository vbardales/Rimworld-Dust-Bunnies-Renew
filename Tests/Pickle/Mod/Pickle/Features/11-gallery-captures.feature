# STEP PREFIXES, to tell the two repositories apart: "Nelim's Sanctuary:" is the Sanctuary Backlot (the fixture and its named places:
# frame, empty, bare floor, animals removed or kept out, roof); "Nelim's Pickle Tools:" is PickleTools (ScreenshotStudio's presentation mode,
# ColonistRace's clothes, CameraZoom, StageDecor, ScreenshotMode); "Dust Bunnies Renew:" is this suite's own; the rest is Pickle's.
#
# THE SERIES, SHOTLIST OF 1.1.0 (written 2026-11-07, after the NSB sync of the same day; replaces the plan of 1.0.0).
# Every capture is a staged photograph except the menus; one story; the photographer chooses place, moment and composition.
#
# STORY. Spring cleaning in Nelim's Sanctuary, one day: Nelim (the protagonist) sweeps the dust off the veranda floor,
# heaps it, and carries it to the crafting spot; at dusk a dust bunny stands up and walks; at night it is still awake
# beside her bed (Nocturnal Animals). The thread is the grey Dust itself: ten of it in scene 1, a hundred in scene 2, a
# crumb in scene 3, then the bunny. Rhythm: morning, noon, dusk, night, one `I set the hour to N` per scenario (8, 11,
# 18, 23), Clear, room held at 20 degrees. Nelim keeps ONE outfit all day (continuity): `Apparel_BasicShirt` dyed rgb
# (22, 110, 120) teal and `Apparel_Pants` dyed rgb (92, 38, 84) plum (any outfit is free, NSB rule 4), her own face
# (`Nelim has her own face`: BrowNormal, MouthLipsSmirk, normal+blink: a light smile, written, no sweat), hair her own `Roo_HD_Hair_Highpony` (no hat), face kit
# "neutral" first. Order of play and of the page: 1 to 4 below, then the windows.
#
# Mods in the DepMap: the Sanctuary map, plus Mlie.XNDNocturnalAnimals (2269731409) for scene 4 (and, on dusk, scene 3).
# Steps confirmed by NPT on 2026-11-07 (from its step docs, not yet played with this mod): `I place the decor "Dust"` places ONE item
# of any ThingDef per cell (hence a loose heap on three cells); `carries 75 of the item "Dust"` (75 = the stack limit of ResourceBase);
# `the animal "Nelim" lies at (x, z) facing south` for the sleeper; `the decor "TorchLamp" at (x, z) is lit` works on an existing building.
#
#   REDO 2026-11-08 (capture rating of 7689: scenes 1 to 3 under 4/5): Dust renders as small specks, so the heap is carried by 4 adjacent cells, zoom 2 (tight) and Nelim FACING SOUTH toward the camera; scenes 1 and 2 no longer use `DoBill` (it turned her back to the camera: she works the bench from the south); scene 3 keeps Nelim still at (199, 121) so the bunny, walking South from (196, 120) to (196, 124), no longer overlaps her.
#   1. workshop-1-sweep (REDO: zoom 2 centred (196, 121), Nelim at (196, 120) facing South, Dust on (195, 121), (196, 121), (195, 122), (196, 122), no bill, 10 ticks). Place: veranda `terrace` (193-200, 118-124), 8h, Clear, paused after 120 ticks of work. WIDE (the whole veranda in frame):
#      zoom 3.2 centred (196, 121), Nelim left of the spot, dirt and the grey `Dust` heap (about 2 cells wide, 47 px on a 268 px thumbnail) in the foreground, Shelf (197, 118) behind. Subject: Nelim
#      works the "Gather dust" bill at a CraftingSpot (196, 120). Says: the dust comes off the floor, by hand. Decor: what the
#      place already holds (Shelf, TorchLamp (200, 119) and (195, 123), Stool (197, 122), Campfire (194, 121), Harpsichord
#      (199, 122)) plus, placed and removed after: `Filth_Dirt` at (195, 119), (197, 119), (195, 121), (198, 120), (194, 120),
#      (199, 121), `Dust` on three cells (195, 120), (194, 119), (196, 119) (the product beside the spot, a loose heap), `PlantPot` (200, 121) with `Plant_Daylily` fully
#      grown; the lamps are off (daylight). Living: Nelim, the daylily. Instant: one bill is done, she works the next, the
#      dirt still waits. Obtained: add the bill, `Nelim is forced into the job "DoBill" on the building "CraftingSpot" at (196,
#      120)`, `I let 120 ticks pass`, `game speed is paused`. Subtitle: "Nelim sweeps the veranda: the dust comes off the floor."
#   2. workshop-2-armful. Place: `terrace`, 11h, Clear. MEDIUM: zoom 2 centred (197, 121) (REDO: tight, Nelim FACING SOUTH walking toward the camera from (197, 119) to (197, 122), the loose `Dust` heap of scene 1 still on (195, 121), (196, 121), (195, 122), (196, 122)). Subject: Nelim carries a full stack of dust (75, the stack limit) to the crafting spot. Says: a hundred
#      dust is the price of one bunny. Decor: the same fixed furniture, `Filth_Dirt` left at (194, 120) and (199, 121),
#      `PlantPot` (200, 121) with `Plant_Daylily`, TorchLamp (200, 119) off; the floor around the spot is swept (time passed
#      since scene 1). Living: Nelim, the daylily. Instant: she has just lifted the heap, next she sets it on the spot.
#      Obtained: `Nelim carries 75 of the item "Dust"` (a full stack: Dust is a ResourceBase, stack limit 75), `Nelim stands at (197, 119)`, `Nelim is forced to walk to (197, 122)`,
#      pause after 25 ticks. Subtitle: "A hundred dust is a lot of sweeping."
#   3. workshop-3-first-steps. Place: `terrace`, 18h (dusk, so the bunny is up: Nocturnal Animals), Clear, paused after 15
#      ticks. CLOSE: zoom 2 centred (196, 121), the bunny in the lower third, front-on (walking South), Nelim in profile
#      at the right edge. Subject: the new dust bunny walks out of the crafting spot. Says: the heap became an animal and it
#      walks. Decor: CraftingSpot (196, 120), Shelf and TorchLamp (200, 119) lit (dusk light), one `Dust` crumb at (195, 120),
#      `Filth_Dirt` (195, 119), (197, 119), `PlantPot` (200, 121) with `Plant_Daylily`. Living: the dust bunny (front), Nelim,
#      the daylily. Instant: the last crumbs have just stood up, next it trots off. Obtained: `a dust bunny is spawned at
#      (196, 120)`, `the animal ... is forced to walk to (196, 123)`, `Nelim is forced to walk to (197, 121)` (turned toward
#      it), pause after 15 ticks. Subtitle: "At dusk the dust gets up and walks."
#   4. workshop-4-night-shift. Place: `sleeping-nook`, 23h, Clear, 20 degrees, paused after 20 ticks. MEDIUM:
#      zoom 2.8 centred (177, 121), the bunny in front of the bed, Nelim asleep on it. Subject: the bunny awake beside the
#      sleeping Nelim. Says: it never sleeps, and it stays with her. Decor: the bed and nook furniture, only the TorchLamp at
#      (179, 119) lit (a pool of light in the dark), `PlantPot` (177, 119) with `Plant_Daylily`. Living: the bunny (front),
#      Nelim (asleep). Instant: she has just fallen asleep, the bunny circles the bed. Obtained: `"Nelim" lies asleep in the bed "RoyalBed" at (177, 121)` (NPT, 2026-11-07: moves her onto the bed's sleeping slot, forced LayDown held until the scenario ends; not played yet),
#      `the animal ... is forced to walk to (176, 120)`, pause after 20
#      ticks. Subtitle: "By night it is still awake." The only colonist with a changed trait: none (asleep, eyes closed).
#   Windows, not rated (taken on `window-backdrop-for-height`, cropped, no subtitle): 5 the "Make a dust bunny" bill dialog;
#   6 the information card of the dust bunny; 7 the information card of the dust; 8 (to ask NPT: operations list of the
#   bunny with a peg leg of A Dog Said Animal Prosthetics 2; if NPT refuses, Virginie arbitrates).
#   The dust bunny is the only animal the mod adds: front-on in scenes 3 and 4, card in 6. Authorized by default (NSB rule 2).
#
# This is a review scenario, like 10-french-dialogs: it asserts that each capture was taken, not what is on the picture.
# Its green proves the journey ran; each capture has to be OPENED AND LOOKED AT before it goes on the Workshop page
# (AUDIT.md, tested -> prepublished, "Ordre des captures").
#
# Needs PickleTools' ScreenshotStudio (the Sanctuary fixture, its framing and presentation steps), ColonistRace (Nelim's
# clothes), StageDecor (nine patches of dirt around the bunny), CameraZoom (zoom 4, after the Sanctuary framing lifts the game's clamp) and ScreenshotMode (for the dialogs), staged only in the pass whose map names them:
#
#   -Language English -DepMap wsl-deps.gallery.map -Filter '11-gallery-captures'
#
# English only: the gallery is the same page's first, most demonstrative image and its dialogs, and About.xml's
# description is English (PUBLISHING.md, "Écrire en anglais").
@requires:nelim.sanctuarybacklot
@requires:nelim.pickletools.screenshotstudio
@requires:nelim.pickletools.screenshotmode
@requires:nelim.pickletools.colonistrace
@requires:nelim.pickletools.camerazoom
@requires:nelim.pickletools.stagedecor
Feature: the Workshop gallery images

  @review
  Scenario: image 1, Nelim stands over the heap of dust she swept
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And I set the hour to 8
    And I set the weather to "Clear"
    And Nelim's Pickle Tools: the temperature of the map is 20 degrees
    And Nelim's Sanctuary: the animals are removed from the sanctuary "terrace"
    And Nelim's Sanctuary: I am at the sanctuary "terrace"
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_BasicShirt" dyed rgb (22, 110, 120)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Pants" dyed rgb (92, 38, 84)
    And a "CraftingSpot" is built at (196, 120)
    And Nelim's Pickle Tools: "Nelim" stands at (196, 120) facing South
    When Nelim's Pickle Tools: I place the decor "Filth_Dirt" at (195, 119)
    And Nelim's Pickle Tools: I place the decor "Filth_Dirt" at (197, 119)
    And Nelim's Pickle Tools: I place the decor "Filth_Dirt" at (198, 120)
    And Nelim's Pickle Tools: I place the decor "Filth_Dirt" at (194, 120)
    And Nelim's Pickle Tools: I place the decor "Filth_Dirt" at (199, 121)
    And Nelim's Pickle Tools: I place the decor "Dust" at (195, 121)
    And Nelim's Pickle Tools: I place the decor "Dust" at (196, 121)
    And Nelim's Pickle Tools: I place the decor "Dust" at (195, 122)
    And Nelim's Pickle Tools: I place the decor "Dust" at (196, 122)
    And Nelim's Pickle Tools: I place the decor "PlantPot" holding "Plant_Daylily" fully grown at (200, 121)
    And game speed is ultrafast
    And Nelim's Pickle Tools: I let 10 ticks pass
    And game speed is paused
    And Nelim's Pickle Tools: I frame the cell (196, 121) at zoom 2
    And Nelim's Pickle Tools: the camera root size is 2
    And Nelim's Pickle Tools: "Nelim" face kit is "neutral"
    And Nelim's Sanctuary: Nelim has her own face
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I take a screenshot "image 1, Nelim has swept the dust into a heap"
    And Nelim's Pickle Tools: the decor is removed
    Then Nelim's Pickle Tools: "Nelim" mouth reads "MouthLipsSmirk"
    And no errors were logged

  @review
  Scenario: image 2, Nelim carries the hundred dust to the crafting spot
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And I set the hour to 11
    And I set the weather to "Clear"
    And Nelim's Pickle Tools: the temperature of the map is 20 degrees
    And Nelim's Sanctuary: the animals are removed from the sanctuary "terrace"
    And Nelim's Sanctuary: I am at the sanctuary "terrace"
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_BasicShirt" dyed rgb (22, 110, 120)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Pants" dyed rgb (92, 38, 84)
    And a "CraftingSpot" is built at (196, 120)
    And Nelim's Pickle Tools: "Nelim" stands at (197, 119) facing South
    When Nelim's Pickle Tools: I place the decor "Filth_Dirt" at (194, 120)
    And Nelim's Pickle Tools: I place the decor "Filth_Dirt" at (199, 121)
    And Nelim's Pickle Tools: I place the decor "Dust" at (195, 121)
    And Nelim's Pickle Tools: I place the decor "Dust" at (196, 121)
    And Nelim's Pickle Tools: I place the decor "Dust" at (195, 122)
    And Nelim's Pickle Tools: I place the decor "Dust" at (196, 122)
    And Nelim's Pickle Tools: I place the decor "PlantPot" holding "Plant_Daylily" fully grown at (200, 121)
    And Nelim's Pickle Tools: "Nelim" carries 75 of the item "Dust"
    And Nelim's Pickle Tools: "Nelim" is forced to walk to (197, 122)
    And game speed is ultrafast
    And Nelim's Pickle Tools: I let 25 ticks pass
    And game speed is paused
    And Nelim's Pickle Tools: I frame the cell (197, 121) at zoom 2
    And Nelim's Pickle Tools: the camera root size is 2
    And Nelim's Pickle Tools: "Nelim" face kit is "neutral"
    And Nelim's Sanctuary: Nelim has her own face
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I take a screenshot "image 2, Nelim carries a hundred dust to the crafting spot"
    And Nelim's Pickle Tools: the decor is removed
    Then Nelim's Pickle Tools: "Nelim" mouth reads "MouthLipsSmirk"
    And no errors were logged

  @review
  Scenario: image 3, at dusk the new dust bunny walks out of the crafting spot
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And I set the hour to 18
    And I set the weather to "Clear"
    And Nelim's Pickle Tools: the temperature of the map is 20 degrees
    And Nelim's Sanctuary: the animals are removed from the sanctuary "terrace"
    And Nelim's Sanctuary: I am at the sanctuary "terrace"
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_BasicShirt" dyed rgb (22, 110, 120)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Pants" dyed rgb (92, 38, 84)
    And a "CraftingSpot" is built at (196, 120)
    And Nelim's Pickle Tools: "Nelim" stands at (199, 121) facing West
    When Nelim's Pickle Tools: I place the decor "Filth_Dirt" at (195, 119)
    And Nelim's Pickle Tools: I place the decor "Filth_Dirt" at (197, 119)
    And Nelim's Pickle Tools: I place the decor "Dust" at (195, 120)
    And Nelim's Pickle Tools: I place the decor "PlantPot" holding "Plant_Daylily" fully grown at (200, 121)
    And Nelim's Pickle Tools: the decor "TorchLamp" at (200, 119) is lit
    And Nelim's Pickle Tools: an animal of kind "DustBunny" named "Bun" is spawned at (196, 120) at life stage 0
    And Nelim's Pickle Tools: "Bun" is forced to walk to (196, 124)
    And game speed is ultrafast
    And Nelim's Pickle Tools: I let 12 ticks pass
    And game speed is paused
    And Nelim's Pickle Tools: I frame the cell (197, 122) at zoom 2
    And Nelim's Pickle Tools: the camera root size is 2
    And Nelim's Pickle Tools: "Nelim" face kit is "neutral"
    And Nelim's Sanctuary: Nelim has her own face
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I take a screenshot "image 3, at dusk the dust gets up and walks"
    And Nelim's Pickle Tools: the decor is removed
    Then Nelim's Pickle Tools: "Nelim" mouth reads "MouthLipsSmirk"
    And no errors were logged

  @review
  Scenario: image 4, by night the dust bunny is still awake beside the sleeping Nelim
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And I set the hour to 23
    And I set the weather to "Clear"
    And Nelim's Pickle Tools: the temperature of the map is 20 degrees
    And Nelim's Sanctuary: the animals are removed from the sanctuary "sleeping-nook"
    And Nelim's Sanctuary: I am at the sanctuary "sleeping-nook"
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_BasicShirt" dyed rgb (22, 110, 120)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Pants" dyed rgb (92, 38, 84)
    When Nelim's Pickle Tools: I place the decor "PlantPot" holding "Plant_Daylily" fully grown at (177, 119)
    And Nelim's Pickle Tools: I place the decor "TorchLamp" at (179, 119)
    And Nelim's Pickle Tools: the decor "TorchLamp" at (179, 119) is lit
    And Nelim's Pickle Tools: an animal of kind "DustBunny" named "Bun" is spawned at (179, 120) at life stage 0
    And Nelim's Pickle Tools: "Nelim" lies asleep in the bed "RoyalBed" at (177, 121)
    And Nelim's Pickle Tools: "Bun" is forced to walk to (176, 120)
    And game speed is ultrafast
    And Nelim's Pickle Tools: I let 20 ticks pass
    And game speed is paused
    And Nelim's Pickle Tools: I frame the cell (177, 121) at zoom 2.8
    And Nelim's Pickle Tools: the camera root size is 2.8
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I take a screenshot "image 4, by night the dust bunny is still awake"
    And Nelim's Pickle Tools: the decor is removed
    Then no errors were logged

  @review
  Scenario: the bill dialog and the information cards of the dust bunny and of the dust, in English
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And I set the hour to 12
    And I set the weather to "Clear"
    And Nelim's Pickle Tools: the temperature of the map is 20 degrees
    And Nelim's Sanctuary: the animals are removed from the sanctuary "sleeping-nook"
    And Nelim's Sanctuary: I am at the sanctuary "sleeping-nook"
    And a "CraftingSpot" is built at (177, 119)
    And I add bill "MakeDustBunny" to the "CraftingSpot"
    And Dust Bunnies Renew: a dust bunny is spawned at (178, 120)
    And I wait 120 ticks
    When Dust Bunnies Renew: the bill dialog for "MakeDustBunny" is open
    And Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "bill dialog of the dust bunny recipe, English"
    And Nelim's Pickle Tools: screenshot mode is disabled
    Then no errors were logged

  @review
  Scenario: the information cards of the dust bunny and of the dust, on the tall-window backdrop
    Given the save "Nelims-tribe" is loaded
    And game speed is paused
    And I set the hour to 12
    And I set the weather to "Clear"
    And Nelim's Pickle Tools: the temperature of the map is 20 degrees
    And Nelim's Sanctuary: the animals are removed from the sanctuary "window-backdrop-for-height"
    And Nelim's Sanctuary: I am at the sanctuary "window-backdrop-for-height"
    And I wait 120 ticks
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
