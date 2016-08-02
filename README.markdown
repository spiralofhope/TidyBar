# TidyBar

https://github.com/spiralofhope/TidyBar \
http://blog.spiralofhope.com/?p=19242

A fork of [danltiger](http://wow.curseforge.com/profiles/danltiger/)'s [TidyBar](http://wow.curseforge.com/addons/tidy-bar/)

- [2016-07-25 - 7.0.3](https://github.com/spiralofhope/TidyBar/archive/7.0.3.zip)
  -  Final Warlords of Draenor patch.  The "pre-patch" for Legion.


# Configuration / Usage

- There is no GUI configure tool.  Edit `TidyBar.lua` directly.  Easy things to do:
  -  Change TidyBar's scale (untested)
  -  Show/hide the experience bar
  -  Show/hide the Gryphons
  -  Show/hide the texture behind the main buttons.
- `/tidybar` will force an update.


# Known Bugs

- When the XP bar lights up, when getting XP, its bar is offset.
- Max XP and a reputation being tracked shows a too-tall reputation bar.
- `HideActionBarButtonsTexturedBackground = true` is a big buggy
  - It might be mucked up while in combat.  I can't really reproduce this, and it might have already been fixed without me realising it.
  - There isn't proper grey behind the main actionbar buttons.
  - Mouse over main buttons hides them for a moment.
  - As soon as a spell is dragged from anywhere, the bottom bar's button-border texture messes up.
- With xp but no reputation being tracked, there is too much empty space between the xp bar and upper button bars.
- When dragging a spell from the spellbook to the right-side bar, it does not always become visible.
  -  I can't always reproduce this.
  -  Only from the spellbook.
  -  The tooltips for existing items appears.


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
- Test with various bars enabled/disabled.
- The only internal functionality should be xp bar hiding.  The reputation bar hiding should be up to the user using the regular reputation list.
