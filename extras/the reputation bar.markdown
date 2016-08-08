Accurate as of 2016-08-07 - `7.0.3 (22345) x64`

The reputation bar is an odd beast and required a workaround to avoid it 'jumping' when changing what's tracked.

- Open the reputation pane
- Track a reputation
- Track another reputation

The reputation bar will reposition as Blizzard pleases.

There is no event for me to hook on to.

The only solution was to pursue an `OnUpdate` script like so:

`ReputationWatchBar:HookScript( 'OnUpdate', TidyBar_refresh_reputation_bar )`

.. where `TidyBar_refresh_reputation_bar()` would constantly reposition the reputation bar to get it back in line with everything.

I really hate `OnUpdate`, as it's constantly firing.

So instead I moved the actionbutton to the left.  It would then be in left-alignment with where `ReputationWatchBar` was being automatically repositioned (probably `MainMenuBarOverlayFrame`)

`ActionButton1:SetPoint( 'BottomLeft', MainMenuBarOverlayFrame, 'BottomLeft' )`
