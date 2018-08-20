# Changelog

`git log` is another good way to peer into the innards of this repository.



# 8.x - Battle for Azeroth (BfA)

## 8.0 series

### 8.0.1.6

- Styling the power bar area.


### 8.0.1.5

- Entirely removed objectives tracker code.
  -  I don't understand what parts to manipulate.


### 8.0.1.4

- Fixed the objectives tracker code, again.


### 8.0.1.3

- Fixed parts of the objectives tracker being constantly removed.
  -  This unintentionally fixed the positioning of the multi-seat vehicle UI (e.g. the Grand Expedition Yak).


### 8.0.1.2

- Stacked the pet bar.
- Shifted a hidden bar that was preventing mouseover and clicking in part of the chat area.


### 8.0.1.1

- Major rewrite
  -  Not just a rewrite for 8.x, but a general code audit and simplification.  TidyBar is now easier to maintain.  Probably.
- Hardening
  -  When WoW is updated, and as the API changes (and addons break), TidyBar will try to avoid "exploding with errors", and will offer suggestions for maintainers.
- Fixed the main area positioning code.
- Old experience, honor and artifact power code was removed.
  -  Blizzard made a combined bar, and it's stuck underneath the main buttons.  I don't understand it well enough to move it around.  It really does act different.
  -  As there was some hackery to fix a "wiggle" issue, related code removal slightly reduces some CPU load.
  -  Bar height functionality removed.  I don't use it, and that code wasn't very happy.
  -  Bar spacing removed.  It wasn't working all that well in the first place; I couldn't fix it properly, and I never even used it.
- Removed show/hide the main bar background.
  -  Blizzard has made this one large texture.  As I don't know how to deal with it, I'll revisit this in the future.
  -  See also #68 - Implement main bar texture
  -  See also #49 - Implement bars texture changing
- Partially-fixed #30 - Hide global cooldowns in sidebar, when hidden-on-mouseout
- Gryphons have been hidden
  -  See #70 - Re-implement gryphon functionality
- Mostly-implemented #60 - Main bar vertical positioning
  -  See also #69 - Implement a better maximum y position



# 7.x - Legion

## 7.3 series

## 7.3.2.0

- TOC bump


### 7.3.0.1

- TOC bump


## 7.2 series

### 7.2.5.1

- Fixed #58 - Move pet bar
  -  It's now positioned the same as the main bar.
  -  These could be made to be configured independently, but I'm not going to bother.
- The pet battle UI is now scaled the same as the main bar.
  -  These could be made to be configured independently, but I'm not going to bother.
- The pet battle UI now has its background textures shown/hidden the same as the main bar.
  -  These could be made to be configured independently, but I'm not going to bother.


### 7.2.0.5

- Hide the FPS text (FramerateText).

### 7.2.0.4

- Fixed #57 - Move FPS meter

### 7.2.0.3

- Vehicle support
  -  It's hardcoded, but seems to be a reasonable default for me.  People with a chat box on the right are screwed.  Same with the pet UI.

### 7.2.0.2

- Fixed the pet battle UI.

### 7.2.0.1

- Implemented #31 - Support the pet battle UI
- Fixed #56 - Fix tooltips on items in the side
- Fixed the right-gryphon not appearing properly when the option was toggled.
- `README.markdown` update.

### 7.2.0.0

- Fixed the addon release date.
- Tested against 7.2



## 7.1 series

### 7.1.5.1

- More aggressively remove the talent nag's transparent overlay.
- Code cleanup and style improvements.

### 7.1.0.3

- Fixed the experience bar appearing with a max-level character.

### 7.1.0.2

- Fixed #40 - Adjust bars when level 100 but not in possession of a legendary weapon
- Fixed #43 and #54 related to the bars resetting and repositioning under certain circumstances.
- Fixed the feature to show/hide macro text on buttons.
- Implemented bar height customization.
- Thinned-down the vehicle health and power bars.
- Fixed #50 - Fix jumping main area
- Fixed the side not toggling correctly when set/unset in the options panel.
- General code clarity improvements.
- For code clarity, references to "sidebar" have been renamed "side".
  -  Users who wish to once again hide the "sidebar" on mouseout will have to enable this renamed preference in the options panel.
- Style improvements to the options panel code.
  -  Yes, these things matter.
- Removed old code from the original author(s).
  -  I's been commented-out for some time now, to check if it would be missed.  That code is no longer, or was never, needed.  Probably.
- I think TidyBar may have been broken for users who were not max level.

### 7.1.0.1

- Fixed an unpredictable error message when first logging in.



## 7.0.3 series

### 7.0.3.23

- Fixed a probable bug with a global/local variable.
  -  Releasing with just this fix, since it's likely a bad issue for some people.

### 7.0.3.22

- Fixed #47 - Fix ArtifactWatchBar height resetting
- Fixed #43 - Fix artifact bar background resetting to dim yellow
- Implemented a debugging mode.
  -  Prints out various messages of interest to developers.
- Fixed #27 - Right-hand mainbar alignment.
- Hiding the grey locked-XP bar.
- Support HonorWatchBar.
  -  I have no way of testing this, as I do not and will never PvP or get in a circumstance where I can even be flagged.
- Implemented an option to show/hide the HonorWatchBar.

### 7.0.3.21

- Fixed #41 - Fix reputation bar when at max-xp
- Fixed #26 - Fix artifact experience bar backdrop

### 7.0.3.20

- Fixed #37 - Adjust artifact power bar 
  -  It was working well, but imperfectly and caused some jumpyness.
- Removed some misaligned sparklies when experience or artifact points are gained.
- Fixed the horizontal movement for the main area.

### 7.0.3.19

- Fixed the positioning of the ArtifactWatchBar.
- Fixed the text of the ArtifactWatchBar appearing at startup, until refreshed or the mouse is moved through it.
- Removed the reputation bar functionality.
  -  As of 22522, I've learned that the "reputation as experience bar" feature is gone, though the checkbox still exists in the UI.
  -  I don't know if the UI needs to be updated, or if the feature will return in some form.  I'm guessing the former.

### 7.0.3.18

- Fixed ArtifactWatchBar on characters with no legendary weapon.

### 7.0.3.17

- ArtifactWatchBar support.

### 7.0.3.16

- Implemented a reasonable simplification of the vehicle UI.
- Hid the overly-loud spark that appears when experience is gained.

### 7.0.3.15

- Fixed the sidebar scaling.
- Fixed the mainbar texture, when `TidyBar_options.show_textured_backgrounds = true`

### 7.0.3.14

- Implemented an option to force the reputation bar height, even when changing them.
  -  This uses 'OnUpdate', which I hate.

### 7.0.3.13

- Rework bar alignment for style and speed.
  -  Wrote `the reputation bar` with some notes on this.
- When `TidyBar_options.show_experience_bar = true`, keep the experience text hidden (when various character interfaces are shown).
- Fixed #21 - Fix reputation bar height when max experience
  -  Okay, so maybe it's not so easy to fix these things..
- Fixed #26 - Fix the sidebar scale after user-changes
- Fixed #28 - Immediately hide the sidebar when the option is enabled
- Fixed #29 - Improve sidebar mousein showing
- Fixed #22 - Reposition 'request stop' when on a taxi
- Fixed #25 - Reposition the gryphons

### 7.0.3.12

- Implemented #14 - Implement global configuration
  -  Implemented an options panel.
  -  No more editing `TidyBar.lua` !
- Fixed an issue with the gryphon hiding option.

### 7.0.3.11

- `TidyBar_HideActionBarButtonsTexturedBackground` renamed to `TidyBar_show_MainMenuBar_textured_background`
- `TidyBar_hide_macro_text` renamed to `TidyBar_show_macro_text`
- `TidyBar_HideGryphons` renamed to `TidyBar_ShowGryphons`
-  Fixed #20 - Fix the bar separation between the top two bars and the main bars, when no exp/rep displayed
- `TidyBar_HideExperienceBar` renamed to `TidyBar_ShowExperienceBar`
- Implemented `TidyBar_main_area_positioning` to move the main area around somewhat.
  -  Default 500.
- Fixed #21 - Fix reputation bar height when max experience
  -  It's easy to fix these sorts of things, when focus is on code clarity.

### 7.0.3.10

- Fixed alignment issues with the right bars.  Again.
- Corrections to the background when `TidyBar_HideActionBarButtonsTexturedBackground = false`
- Created an `extras` folder.
  -  Added notes and a solution regarding the missing hotkey text for empty mainbar buttons when `TidyBar_HideActionBarButtonsTexturedBackground = true`
- Implemented an option to hide macro text.
  -  Default `true`

### 7.0.3.9

- Fixed alignment issues with the right bars.
- Fixed the objective tracker placement with/without the right bars.

### 7.0.3.8

- Fixed the reputation/etc bars jumping around when entering/exiting rested (city), and world.
- Code style changes.

### 7.0.3.7

- Reworked the button/bar alignment, so they line up properly in all cases.
- Hide the button border around the stance buttons.
- Hide the background behind the stance buttons.
- Fixed objectives positioning when TidyBar scaling is used.
- Renamed `Empty.tga` to `empty.tga`.

### 7.0.3.6

- Fixed the height and separation of the experience and reputation bars.
- Fixed the objectives tracker only showing a few items.

### 7.0.3.5

- Implemented an option to remove the background texture of the main buttons.
  -  `TidyBar_HideActionBarButtonsTexturedBackground`
  -  Default `true`

### 7.0.3.4

- Fixed the reputation bar hanging off of the right-hand side.  Again.
- Fixed the experience bar hanging off of the right-hand side.

### 7.0.3.3

- Fixed the reputation bar hanging off of the right-hand side.
- Updated `TidyBar.toc`
  -  It lists the author as "Binny".  Curious.

### 7.0.3.2

- Implemented an option to automatically/always show the right sidebar.

### 7.0.3.1

- Implemented an option to show/hide the gryphons on either side the bars.

### 7.0.3

- 7.0.3 compatibility changes.
- A major code style rewrite.  Thanks, Cynbe.
- Removed old comments.



## Earlier

I had hacked on TidyBar here and there.



# Earlier authors' notes

The following notes were by the original author.

Note that these old releases may or may not be buried in this git repository.  I (spiralofhope) have kept those old archives if anyone is *that* interested.

## 5.2

- Added the Store button to the Tidy Bar container so it gets hidden properly

## 5.1

- TOC Bump

## 5.0

- Update to 5.x TOC
- Added HideMainButtonArt and HideExperienceBar variables to the head of TidyBar.lua; Setting the variable to 'true' will make the changes.



## 4.9

- Update to 4.3 TOC

## 4.8

- Update to 4.2 TOC
- Updated to 4.2 UI changes
