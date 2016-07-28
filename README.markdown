# TidyBar

https://github.com/spiralofhope/TidyBar \\
http://blog.spiralofhope.com/?p=19242

A fork of [danltiger](http://wow.curseforge.com/profiles/danltiger/)'s [TidyBar](http://wow.curseforge.com/addons/tidy-bar/)

- [2016-07-25 - 7.0.3](https://github.com/spiralofhope/TidyBar/archive/7.0.3.zip)
  -  Final Warlords of Draenor patch.  The "pre-patch" for Legion.


# Configuration / Usage

- There is no GUI configure tool.  Edit `TidyBar.lua` directly.  Easy things to do:
  -  Change TidyBar's scale (untested)
  -  Show/hide the experience bar
  -  Show/hide the Gryphons
- `/tidybar` will force an update.


# Known Bugs

- When the XP bar lights up, when getting XP, its bar is offset.
- Max XP and a reputation being tracked shows a too-tall reputation bar.
- `HideActionBarButtonsTexturedBackground = true` might still be mucked up while in combat.


# TODO

- Max level does not show an experience bar; move the upper bars down.
  -  What happens when xp is turned off?
- Test `TidyBarScale`
- Import existing documentation
  -  Beginning with the main description pages
- Import existing tickets
  -  Is there a way to import them from an existing project?  Can I also do old tickets?
- Create a hidden frame underneath the sidebar, and reference that for the mousein/mouseout, and not the buttons.
  -  Can I steal code from the corner frame?
  -  I hate having my mouse between buttons and not showing them.
