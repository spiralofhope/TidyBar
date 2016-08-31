# Changelog

`git log` is another good way to peer into the innards of this repository.


## 7.0.3 series

### 7.0.3.18

- Fixed ArtifactWatchBar on characters with no legendary weapon.

### 7.0.3.17

- ArtifactWatchBar support.

### 7.0.3.16

- Implemented a reasonable simplification of the vehicle UI.
- Hid the overly-loud spark that appears when experience is gained.

### 7.0.3.15

- Fixed the sidebar scaling.
- Fixed the mainbar texture, when `TidyBar_options.show_MainMenuBar_textured_background = true`

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
