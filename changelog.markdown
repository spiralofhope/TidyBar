# Changelog

`git log` is another good way to peer into the innards of this repository.


## 7.0.3 series

### 7.0.3.11 WORKING

- Fixed the reputation bar height.
  -  It's easy when focus is on code clarity.

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
