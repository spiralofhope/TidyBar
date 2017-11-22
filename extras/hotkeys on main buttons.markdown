Accurate as of 2016-08-04 - `7.0.3 (22345) x64`

When `TidyBar_HideActionBarButtonsTexturedBackground = true`

The hotkey buttons are missing.  This makes it look very different than the other action bars.


# Showing the hotkeys

This code solves that issue:

``` lua
MainMenuBar:SetScript( 'OnUpdate', function() for i=1,12 do _G[ 'ActionButton' .. i ]:Show() end end )
```

.. however, this is temporary.  When the mouse hovers over a button, the hotkey button text is permanently hidden.


# Showing the hotkeys on mouseover

It's possible to make the `Show()` permanent with:

``` lua
for i=1,12 do
  _G[ 'ActionButton' .. i ]:SetScript( 'OnEnter', function()
  -- do nothing
  end )
end
```

.. however, this removes tooltips for items on the main bar.


# Hook

I think it might be a solution to have a `Show()` attached via a [hook](http://wow.gamepedia.com/Hooking_functions), but I don't know how to do that.


# Transparent icon

One solution would be to create a 'blank' icon.

- `/macro` and make a macro.  Call it something like `blank`.  Give it the default questionmark icon.
- Exit the game
- Copy `hotkeys on main buttons - 30%.tga` to `\Interface\ICONS`  You will probably have to make that directory.
- Rename `hotkeys on main buttons - 30%.tga` to `INV_MISC_QUESTIONMARK.tga`
- Start the game.

Now all macros which use that questionmark icon will instead be mostly-transparent.  If you want 0% opacity, try TidyBar's `empty.tga`

It might be possible to do some extra work to make the buttons even more like the above ones, it's really not worth the work and run into all the same bugs as this 'missing hotkey buttons' caused.

As of `7.0.3 (22345) x64` it doesn't seem possible to just make a new icon in that icons list.  People are saying it worked before `7.0.3`
