# TidyBar

A 
[World of Warcraft](http://blog.spiralofhope.com/?p=2987) 
[addon](http://blog.spiralofhope.com/?p=17845) 
which simplifies the game buttons, giving much more screen space.  A fork of 
[danltiger](http://wow.curseforge.com/profiles/danltiger/)
's 
[TidyBar](http://wow.curseforge.com/addons/tidy-bar/)
.

[source code](https://github.com/spiralofhope/TidyBar)
 · [home page](http://blog.spiralofhope.com/?p=19242)
 · [releases](https://github.com/spiralofhope/TidyBar/releases)
 · [latest beta](https://github.com/spiralofhope/TidyBar/archive/master.zip)


# Configuration / Usage

- There is no GUI configure tool.  Edit `TidyBar.lua` directly.  Easy things to do:
  -  Change TidyBar's scale (untested)
  -  Show/hide the experience bar
  -  Show/hide the Gryphons
  -  Show/hide the texture behind the main buttons.
- `/tidybar` will force an update.


# Known Bugs

([bugs list](https://github.com/spiralofhope/TidyBar/issues))

*These are things I investigated but simply don't know how to fix.*

- `HideActionBarButtonsTexturedBackground = true` doesn't have a proper grey background behind the main actionbar buttons.


# TODO

([todo list](https://github.com/spiralofhope/TidyBar/issues))

*These are things I doubt I can do.*

- Create a hidden frame underneath the sidebar, and reference that for the mousein/mouseout, and not the buttons.
  -  Can I steal code from the corner frame?
  -  I hate having my mouse between buttons and not showing them.
