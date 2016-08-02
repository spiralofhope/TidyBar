# TidyBar

https://github.com/spiralofhope/TidyBar  
http://blog.spiralofhope.com/?p=19242

A fork of [danltiger](http://wow.curseforge.com/profiles/danltiger/)'s [TidyBar](http://wow.curseforge.com/addons/tidy-bar/)

([releases](https://github.com/spiralofhope/TidyBar/releases) · [latest beta](https://github.com/spiralofhope/TidyBar/archive/master.zip))


# Configuration / Usage

- There is no GUI configure tool.  Edit `TidyBar.lua` directly.  Easy things to do:
  -  Change TidyBar's scale (untested)
  -  Show/hide the experience bar
  -  Show/hide the Gryphons
  -  Show/hide the texture behind the main buttons.
- `/tidybar` will force an update.


# Known Bugs

*These are things I investigated but simply don't know how to fix.*

- `HideActionBarButtonsTexturedBackground = true` is all manner of buggy.
  - It might be mucked up while in combat.  I can't really reproduce this, and it might have already been fixed without me realising it.
  - There isn't proper grey behind the main actionbar buttons.
  - Mouse over main buttons hides them for a moment.
  - As soon as a spell is dragged from anywhere, the bottom bar's button-border texture messes up.
- When dragging a spell from the spellbook to the right-side bar, it does not always become visible.
  -  I can't always reproduce this.
  -  Only from the spellbook.
  -  The tooltips for existing items appears.


# TODO

*These are things I doubt I can do.*

- Create a hidden frame underneath the sidebar, and reference that for the mousein/mouseout, and not the buttons.
  -  Can I steal code from the corner frame?
  -  I hate having my mouse between buttons and not showing them.
- Implement a account-wide options using the regular GUI.
  -  This is a waste of time to learn if it's not really easy.
