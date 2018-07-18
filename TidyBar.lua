-- RE-TEST - Refreshing is throttled.  Every tiny thing can help performance.
-- The scaling feature was removed; use the Blizzard feature.
-- TODO - create a custom tidybar frame and put all the middle bars into it.




-- KNOWN ISSUES
--  The bars remain during cutscenes!
--  The background texture is now one single bar.  I have to learn how to show only part of a texture.


-- TODO SOONER
--  Test combat pet bars
--  Test vehicles


-- TODO - investigate replacing the empty 30% tga with a backdrop:
--  https://wow.gamepedia.com/API_Frame_SetBackdrop
--  See the function frame_debug_overlay and apply it to the whole region
--  I cannot apply it to each icon space, because there's nothing there when it's empty.

-- However, if I keep my side frame, and then instead use the alpha code on VerticalMultiBarsContainer, then I might be able to completely resolve issue #30 (cooldown flash).  Investigate.

-- Style and move ExtraActionButton1



--  Technically adjustable, but I don't want to support that without a request.
local Empty_Art              = 'Interface/Addons/TidyBar/empty'

local MenuButtonFrames = {
  CharacterMicroButton,     -- Character Info
  SpellbookMicroButton,     -- Spellbook & Abilities
  TalentMicroButton,        -- Specialization & Talents
  AchievementMicroButton,   -- Achievements
  QuestLogMicroButton,      -- Quest Log
  GuildMicroButton,         -- Guild / Guild Finder
  LFDMicroButton,           -- Group Finder
  CollectionsMicroButton,   -- Collections
  EJMicroButton,            -- Adventure Guide
  StoreMicroButton,         -- Shop
  MainMenuMicroButton,      -- Game Menu
}

local BagButtonFrameList = {
  MainMenuBarBackpackButton,  --  The big backpack
  CharacterBag0Slot,
  CharacterBag1Slot,
  CharacterBag2Slot,
  CharacterBag3Slot,
}

local bar_width = 500




local function hide( thing, parameter )
  if thing == nil then print( 'TidyBar hide() error using ' .. parameter .. ' attempting to continue..' ); return end
  thing:SetHeight( 0.001 )
  thing:SetAlpha( 0 )
  thing:Hide()
end

local function hide_more( thing, parameter )
  if thing == nil then print( 'TidyBar hide_more() error using ' .. parameter .. ' attempting to continue..' ); return end
  hide( thing, 'thing' )
  thing:SetTexture( Empty_Art )
end

local function frame_debug_overlay( frame, parameter )
  if not parameter then print( 'TidyBar frame_debug_overlay() error using ' .. parameter .. ' attempting to continue..' ); return end
  if not TidyBar_options.debug then return end
  local frame = frame:CreateTexture( nil, 'BACKGROUND' )
  --local frame = frame:CreateTexture( nil, 'BORDER' )
  --local frame = frame:CreateTexture( nil, 'ARTWORK' )
  --local frame = frame:CreateTexture( nil, 'OVERLAY' )
  --local frame = frame:CreateTexture( nil, 'HIGHLIGHT' )
  frame:SetAllPoints()
  frame:SetColorTexture( 1, 1, 1, 0.1 )
end

local function debug( text )
  if not TidyBar_options.debug then return end
  print( 'TidyBar - ' .. GetTime() .. ' - ' .. tostring ( text ) )
end




local function TidyBar_refresh_main_area()
  debug( ' TidyBar_refresh_main_area()' )

  -- Textured background
  -- Has to be repositioned and nudged to the left since ActionButton1 gets moved.

  --  MainMenuBarArtFrameBackground is protected in combat.
  --MainMenuBarArtFrameBackground:ClearAllPoints()
  --MainMenuBarArtFrameBackground:SetPoint( 'Left', MainMenuBar, 'Left', -8, -5 )

  -- It does nothing anyway.
  MainMenuBarArtFrameBackground:Hide()


  do  --  The stack of bars
    local __

   --  What's this for?
    TimerTracker:Hide()

  if InCombatLockdown() == false then

    do  --  StatusTrackingBarManager
      --  No matter what I do, StatusTrackingBarManager is stuck to the bottom of MainMenuBar.
      __ = StatusTrackingBarManager
      if TidyBar_options.show_StatusTrackingBarManager == false then
        __:Hide()
      else
        __:Show()
      end
    end


    do  --  main area texture
      --  FIXME - If shown, show only the relevant part.
      if TidyBar_options.show_textured_background_main == true then
        MainMenuBarArtFrameBackground:Show()
      else
        MainMenuBarArtFrameBackground:Hide()
      end
    end


    -- BUGGED - Everything is tied to MainMenuBarArtFrame and then MainMenuBar, which automatically widen if the ActionBarPage is changed in combat, shifting everything.
--[[
    -- IDEA - Move everything's parent to MainMenuBar and hide MainMenuBarArtFrame.
    local bars={
      'MultiBarBottomLeft',
      'MultiBarBottomRight',
      'Action',
    }
    for button=1, #bars do
      for i=1, 12 do
        _G[ bars[ button ] .. 'Button' .. i .. 'Name' ]:SetParent( MainMenuBar )
      end
    end
    --MainMenuBarArtFrame:Hide()
    MainMenuBarArtFrame:Show()
]]


    --  Left-right placement
    MainMenuBar:SetWidth( bar_width )
    -- nil = the entire screen, but not WorldFrame, as that would keep it visible when the UI is hidden with alt-z
    if   StatusTrackingBarManager:IsShown() then
      MainMenuBar:SetPoint( 'Bottom', nil, 'Bottom', TidyBar_options.main_area_positioning, 2 + StatusTrackingBarManager:GetHeight() )
    else
      MainMenuBar:SetPoint( 'Bottom', nil, 'Bottom', TidyBar_options.main_area_positioning, 2 )
    end

    --  bottom row
    --  Shift them into place.
    ActionButton1:SetPoint( 'BottomLeft', MainMenuBar, 'BottomLeft', 2, 4 )


    -- New simple method.
    -- middle row
    MultiBarBottomLeftButton1:SetPoint( 'BottomLeft', MainMenuBar, 'TopLeft', 2, 2 )
    -- top row
    --  It's not used for anything, but may as well move it.
    MultiBarBottomRight:SetPoint( 'BottomLeft', MultiBarBottomLeft, 'TopLeft' )
    MultiBarBottomRightButton1:SetPoint( 'BottomLeft', MultiBarBottomLeftButton1, 'TopLeft', 2, 2 )
    -- Buttons 7-12 are a separate block from 1-6
    MultiBarBottomRightButton7:ClearAllPoints()
    MultiBarBottomRightButton7:SetPoint( 'BottomLeft', MultiBarBottomRightButton6, 'BottomRight', 6, 0 )


--[[
-- This is the old way, which works, but seems to be unnecessary.
    ----  I hotkey this row to shift
    --__ = MultiBarBottomLeft
    --if __:IsShown() then
      --__:SetParent( MainMenuBar )
      --__:ClearAllPoints()
      ---- It just gets reset in combat, because reasons.
      ----__:SetPoint( 'BottomLeft', MainMenuBar, 'TopLeft', 2, -3 )
      --__:SetPoint( 'BottomLeft', MainMenuBar, 'TopLeft', 2, 2 )
      -- Buttons 7-12 are a separate block from 1-6
      --MultiBarBottomRightButton7:ClearAllPoints()
      --MultiBarBottomRightButton7:SetPoint( 'BottomLeft', MultiBarBottomRightButton6, 'BottomRight', 6, 0 )
    --end


    ----  I hotkey this row to alt
    --__ = MultiBarBottomRightButton1
    --if __:IsShown() then
      --__:ClearAllPoints()
      --__:SetPoint( 'BottomLeft', MultiBarBottomLeftButton1, 'TopLeft', 0, 6 )
      ---- Buttons 7-12 are a separate block from 1-6
      --MultiBarBottomRightButton7:ClearAllPoints()
      --MultiBarBottomRightButton7:SetPoint( 'BottomLeft', MultiBarBottomRightButton6, 'BottomRight', 6, 0 )
    --end
--]]


    do  --  main area texture
      --  FIXME - If shown, show only the relevant part.
      if TidyBar_options.show_textured_background_main == true then
        MainMenuBarArtFrameBackground:Show()
      else
        MainMenuBarArtFrameBackground:Hide()
      end
    end


  end  --  if not InCombatLockdown()
  --  If either in or out of combat:


    --MainMenuBar:SetWidth( bar_width )





-- Does nothing
--__:SetPoint( 'BottomLeft', UIParent, 'BottomLeft', TidyBar_options.main_area_positioning, 2 )



--[[
    do  --  StatusTrackingBarManager
      --  No matter what I do, StatusTrackingBarManager is stuck to the bottom of MainMenuBar.
      __ = StatusTrackingBarManager
      --UIPARENT_MANAGED_FRAME_POSITIONS[ __ ] = nil
      if TidyBar_options.show_StatusTrackingBarManager == false then
        __:Hide()
      else
        __:Show()
        --__:ClearAllPoints()
        --  Does nothing
        --__:SetWidth( bar_width )
        __:SetScale( TidyBar_options.scale )
        --__:SetParent( anchor )
        --__:SetPoint( 'BottomLeft', anchor, 'TopLeft', TidyBar_options.main_area_positioning, 2 )
        --anchor = __
      end
    end

--]]






--anchor=MainMenuBarArtFrame
--__=ActionButton1
      --__ = MultiBarBottomRightButton1
      --if __:IsShown() then
        --__:ClearAllPoints()
        --__:SetParent( anchor )
        --__:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, 6 )
      --end


    --__ = MainMenuBar
    --__:ClearAllPoints()
    --__:SetWidth( bar_width )
    --__:SetScale( TidyBar_options.scale )
    --if TidyBar_options.show_StatusTrackingBarManager == true then
      ----  Because StatusTrackingBarManager is stuck to the bottom of MainMenuBar, I have to shift MainMenuBar up.
      --__:SetPoint( 'Bottom', WorldFrame, 'Bottom', TidyBar_options.main_area_positioning, StatusTrackingBarManager:GetHeight() + 2 )
    --else
      --__:SetPoint( 'Bottom', WorldFrame, 'Bottom', TidyBar_options.main_area_positioning, 4 )
    --end
    --anchor = __


--anchor = MainMenuBarArtFrame

    --do  --  StatusTrackingBarManager
      ----  No matter what I do, StatusTrackingBarManager is stuck to the bottom of MainMenuBar.
      --__ = StatusTrackingBarManager
      --UIPARENT_MANAGED_FRAME_POSITIONS[ __ ] = nil
      --if TidyBar_options.show_StatusTrackingBarManager == false then
        --__:Hide()
      --else
        --__:Show()
        --__:ClearAllPoints()
        --__:SetWidth( bar_width )
        --__:SetScale( TidyBar_options.scale )
        ----__:SetParent( anchor )
        --__:SetPoint( 'BottomLeft', anchor, 'TopLeft', TidyBar_options.main_area_positioning, 2 )
        --anchor = __
      --end
    --end

--StatusTrackingBarManager:ClearAllPoints()
--StatusTrackingBarManager:SetWidth( 500 )
--StatusTrackingBarManager:SetScale( TidyBar_options.scale )
--StatusTrackingBarManager:SetParent( MainMenuBar )
--StatusTrackingBarManager:SetPoint( 'BottomLeft', UIParent, 'TopLeft', TidyBar_options.main_area_positioning, 2 )


-- This is default above the MultiActionBar (1 to =)
-- Middle row (my hotkey:  shift)

    --do  --  MultiBarBottomLeft
      --__ = MultiBarBottomLeft
      --UIPARENT_MANAGED_FRAME_POSITIONS[ __ ] = nil
      --if __:IsShown() then
        --debug( '___ MultiBarBottomLeft repositioning' )
        --__:ClearAllPoints()
        --__:SetParent( anchor )
        ----  I don't know why MainMenuBar is so tall.  Nudge MultiBarBottomLeft down.
        --__:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, -19 )
        --anchor = __
      --end
    --end

--anchor=MultiBarBottomLeft

-- Top row (my hotkey: alt)

    --do  --  MultiBarBottomRight
      --__ = MultiBarBottomRight
      --UIPARENT_MANAGED_FRAME_POSITIONS[ __ ] = nil
      --if __:IsShown() then
        --debug( 'MultiBarBottomRight debugging' )
        --__:ClearAllPoints()
        --__:SetParent( anchor )
        --__:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, 4 )
        --anchor = __
        ---- I don't understand why buttons 7-12 are a separate block from 1-6, but this fixes that.
        ---- FIXME - MultiBarBottomRight moves around!
        --MultiBarBottomRightButton7:ClearAllPoints()
        --MultiBarBottomRightButton7:SetPoint( 'BottomLeft', MultiBarBottomRightButton6, 'BottomRight', 6, 0 )
      --end
    --end

--point, relativeTo, relativePoint, xOfs, yOfs = MultiBarBottomRight:GetPoint()
--print( point )
--print( relativeTo:GetName() )
--print( relativePoint )
--print( xOfs )
--print( yOfs )




--[[
    if StanceBarFrame:IsShown() then
      StanceButton1:ClearAllPoints()
      StanceButton1:SetPoint( 'BottomLeft', anchor, 'TopLeft' )
      anchor = StanceButton1
    end
--]]



--[[
    if MainMenuBarVehicleLeaveButton:IsShown() then
      MainMenuBarVehicleLeaveButton:ClearAllPoints()
      MainMenuBarVehicleLeaveButton:SetPoint( 'BottomLeft', anchor, 'TopLeft' )
      anchor = MainMenuBarVehicleLeaveButton
    end
--]]


--[[
    if FramerateText:IsShown() then  --  FPS text
      --FramerateLabel:ClearAllPoints()
      --FramerateText:ClearAllPoints()
      --FramerateLabel:SetPoint( 'Bottom', anchor,        'Top' )
      --FramerateText:SetPoint(  'Left',  FramerateText, 'Right', 0, 0 )
      --anchor = FramerateText


      FramerateText:ClearAllPoints()
      FramerateText:SetPoint( 'BottomLeft', anchor, 'TopLeft' )
      FramerateLabel:Hide()
      anchor = FramerateText
    end
--]]

  end  --  The stack of bars




  --  Hide the main bar bubbles
  StatusTrackingBarManager.SingleBarLarge:Hide()

  --  Hide the gryphons
  MainMenuBarArtFrame.LeftEndCap:Hide()
  MainMenuBarArtFrame.RightEndCap:Hide()



  do  -- Hide the fiddly bits on the main bar
    hide( MainMenuBarArtFrame.PageNumber, 'MainMenuBarArtFrame.PageNumber' )
    hide( ActionBarUpButton, 'ActionBarUpButton' )
    hide( ActionBarDownButton, 'ActionBarDownButton' )
  end


  do  -- Hide the background behind the stance bar
    hide( StanceBarLeft,  'StanceBarLeft' )
    hide( StanceBarRight, 'StanceBarRight' )
  end


  do  -- Hide the border around buttons
    for i=1,10 do
      hide( _G[ 'StanceButton' .. i .. 'NormalTexture2' ], "_G[ 'StanceButton' .. i .. 'NormalTexture2' ]" )
    end
  end


  do  --  TidyBar_options.show_macro_text
    local bars={
      'MultiBarBottomLeft',
      'MultiBarBottomRight',
      'Action',
      'MultiBarLeft',
      'MultiBarRight',
    }
    for button=1, #bars do
      for i=1, 12 do
        if TidyBar_options.show_macro_text then
          _G[ bars[ button ] .. 'Button' .. i .. 'Name' ]:Show()
        else
          _G[ bars[ button ] .. 'Button' .. i .. 'Name' ]:Hide()
        end
      end
    end
  end

end



local function TidyBar_refresh_side( is_mouse_inside_side )
  -- if MultiBarRight isn't there, then neither is MultiBarLeft; just exit.
  if MultiBarRight:IsShown() == false then
    ObjectiveTrackerFrame:SetPoint( 'TopRight', MinimapCluster, 'BottomRight', 0, -10 )
    return
  end

  do  --  debugging
    if is_mouse_inside_side == true then
      debug( ' mouse entered the side' )
    else
      debug( ' mouse exited the side' )
    end
    debug( ' SpellFlyout:IsShown( ' .. tostring( SpellFlyout:IsShown() ) .. ' )' )
  end


  -- Doing the following somehow reduces the height of the objective tracker, showing only a few items:
  -- Works in combat.
  ObjectiveTrackerFrame:ClearAllPoints()
  ObjectiveTrackerFrame:SetPoint( 'TopRight', VerticalMultiBarsContainer, 'TopLeft', -10, 0 )

  if not InCombatLockdown() then
    --  Attempting to more thorougly solve issue #30, but nothing works.
--[[
    for i = 1, 12 do
      local frame = 'MultiBarRightButton' .. i
      -- How much more aggressive could I be?
      _G[ frame ]:Hide()
      _G[ frame .. 'Shine' ]:Hide()
      _G[ frame .. 'Border' ]:Hide()
      _G[ frame .. 'Count' ]:Hide()
      _G[ frame .. 'Flash' ]:Hide()
      _G[ frame .. 'FlyoutArrow' ]:Hide()
      _G[ frame .. 'Name' ]:Hide()
      _G[ frame .. 'FlyoutBorder' ]:Hide()
      _G[ frame .. 'FlyoutBorderShadow' ]:Hide()
      _G[ frame .. 'NormalTexture' ]:Hide()
      _G[ frame .. 'Cooldown' ]:Hide()
      _G[ frame .. 'Icon' ]:Hide()
      _G[ frame .. 'FloatingBG' ]:Hide()

      --local frame = 'MultiBarLeftButton' .. i

      --_G[ frame ]:SetAlpha( alpha )
    end
--]]

    end



  local alpha
  if    TidyBar_options.hide_side_on_mouseout == false
    or  is_mouse_inside_side
    or  SpellFlyout:IsShown()
  then  --  Show
    alpha = 1
  else  --  Hide
    alpha = 0
  end
  VerticalMultiBarsContainer:SetAlpha( alpha )
  --for i = 1, 12 do
    --_G[ 'MultiBarRightButton' .. i ]:SetAlpha( alpha )
    --_G[ 'MultiBarLeftButton'  .. i ]:SetAlpha( alpha )
  --end

    --  Attempting to more thorougly solve issue #30, but nothing works.
--[[
    -- Don't work
    _G[ frame .. 'Shine' ]:SetAlpha( alpha )
    _G[ frame .. 'Border' ]:SetAlpha( alpha )
    _G[ frame .. 'Count' ]:SetAlpha( alpha )
    _G[ frame .. 'Flash' ]:SetAlpha( alpha )
    _G[ frame .. 'FlyoutArrow' ]:SetAlpha( alpha )
    _G[ frame .. 'Name' ]:SetAlpha( alpha )
    _G[ frame .. 'FlyoutBorder' ]:SetAlpha( alpha )
    _G[ frame .. 'FlyoutBorderShadow' ]:SetAlpha( alpha )
    _G[ frame .. 'NormalTexture' ]:SetAlpha( alpha )
    _G[ frame .. 'Cooldown' ]:SetAlpha( alpha )
    _G[ frame .. 'Icon' ]:SetAlpha( alpha )

    -- bugged:
    --_G[ frame .. 'AutoCastable' ]:SetAlpha( alpha )
    --_G[ frame .. 'NewActionTexture' ]:SetAlpha( alpha )
    --_G[ frame .. 'Hotkey' ]:SetAlpha( alpha )
    --_G[ frame .. 'SpellHighlightAnim' ]:SetAlpha( alpha )
    --_G[ frame .. 'SpellHighlightTexture' ]:SetAlpha( alpha )
--]]


end



local function TidyBar_refresh_corner( is_mouse_inside_corner )

  do  --  debugging
    if is_mouse_inside_corner == true then
      debug( ' mouse entered the corner' )
    else
      debug( ' mouse exited the corner' )
    end
  end

  if not InCombatLockdown() then
    local __ = MicroButtonAndBagsBar
    do  --  parent frame size
      --  TODO - get the first entry in the MenuButtonFrames array
      __:SetHeight( CharacterMicroButton:GetHeight() + MainMenuBarBackpackButton:GetHeight() + 20 )

      local MicroButtonAndBagsBar_width = 0
      for i, name in pairs( MenuButtonFrames ) do
        MicroButtonAndBagsBar_width = ( MicroButtonAndBagsBar_width + name:GetWidth() )
      end
      __:SetWidth( MicroButtonAndBagsBar_width + 10 )
    end

    MicroButtonAndBagsBar:ClearAllPoints()
    --  It's intentionally shifted away from the edges.
    --  .. in case there's something the user stuffed into that corner.
    MicroButtonAndBagsBar:SetPoint( 'BottomRight', WorldFrame, 'BottomRight', 3, 3 )

    do  --  The corner background art
      --[[
          --  TODO - I have to make a custom background, or figure out how to manipuluate the existing one.
          if TidyBar_options.show_textured_background_corner == true then
            MicroButtonAndBagsBar.MicroBagBar:Show()
          else
            MicroButtonAndBagsBar.MicroBagBar:Hide()
          end
        end
      ]]--
      MicroButtonAndBagsBar.MicroBagBar:Hide()
    end



    do  --  Bottom buttons repositioning
      local anchor = MicroButtonAndBagsBar
      for i, name in pairs( MenuButtonFrames ) do
        name:ClearAllPoints()
        name:SetPoint( 'BottomLeft', anchor, 'BottomRight' )
        anchor = name
        --frame_debug_overlay( name, 'frame_debug_overlay( ' .. tostring( name ) .. ' )' )
      end
      for i, name in pairs( MenuButtonFrames ) do
        name:SetParent( MicroButtonAndBagsBar )
      end
      --  BUG - when the UI is hidden/shown, this is out of place.
      CharacterMicroButton:SetPoint( 'BottomLeft', MicroButtonAndBagsBar, 'BottomLeft' )
    end


    do  --  Bags / backpack repositioning
      --  Chain the bags together, in reverse order.
      local separation = 4
      CharacterBag3Slot:ClearAllPoints() ; CharacterBag3Slot:SetPoint( 'BottomLeft', MainMenuBarBackpackButton, 'BottomRight', separation, 0 )
      CharacterBag2Slot:ClearAllPoints() ; CharacterBag2Slot:SetPoint( 'BottomLeft', CharacterBag3Slot,         'BottomRight', separation, 0 )
      CharacterBag1Slot:ClearAllPoints() ; CharacterBag1Slot:SetPoint( 'BottomLeft', CharacterBag2Slot,         'BottomRight', separation, 0 )
      CharacterBag0Slot:ClearAllPoints() ; CharacterBag0Slot:SetPoint( 'BottomLeft', CharacterBag1Slot,         'BottomRight', separation, 0 )

      --  Link them above the bottom buttons
      MainMenuBarBackpackButton:ClearAllPoints()
      MainMenuBarBackpackButton:SetPoint( 'BottomLeft', CharacterMicroButton, 'TopLeft', 0, 4 )
    end

  end  --  not InCombatLockdown() then



  local alpha
  if  is_mouse_inside_corner
  or  TidyBar_options.hide_corner_on_mouseout  ==  false
  then
    alpha = 1
  else
    alpha = 0
  end
  MicroButtonAndBagsBar:SetAlpha( alpha )

--[[  -- TODO - is this stuff still needed?
  -- Required in order to move the frames around
  UIPARENT_MANAGED_FRAME_POSITIONS[ 'PetActionBarFrame' ]       = nil
  UIPARENT_MANAGED_FRAME_POSITIONS[ 'ShapeshiftBarFrame' ]      = nil
  -- Set Pet Bars
  PetActionBarFrame:SetAttribute( 'unit', 'pet' )
  RegisterUnitWatch( PetActionBarFrame )
--]]
end



local function TidyBar_refresh_petbattle()
  if not PetBattleFrame:IsShown() then return end

  -- Positioning
  PetBattleFrame.BottomFrame:ClearAllPoints()
  PetBattleFrame.BottomFrame:SetPoint( 'Bottom', WorldFrame, 'Bottom', TidyBar_options.main_area_positioning, 0 )
  -- The background art
  if TidyBar_options.show_textured_background_petbattle == false then
    PetBattleFrame.TopVersus:Hide()
    PetBattleFrame.TopVersusText:Hide()
    PetBattleFrame.TopArtLeft:Hide()
    PetBattleFrame.TopArtRight:Hide()
    PetBattleFrame.BottomFrame.Background:Hide()
    PetBattleFrame.BottomFrame.LeftEndCap:Hide()
    PetBattleFrame.BottomFrame.RightEndCap:Hide()
    PetBattleFrame.BottomFrame.FlowFrame:Hide()
    PetBattleFrame.BottomFrame.Delimiter:Hide()
    --PetBattleFrame.BottomFrame.MicroButtonFrame:SetAlpha( 0 )
    --PetBattleFrame.BottomFrame.MicroButtonFrame:Hide()
    --  FIXME - this isn't hidden unless I shift-up to refresh.
    PetBattleFrame.BottomFrame.TurnTimer.ArtFrame2:Hide()
  else
    PetBattleFrame.TopVersus:Show()
    PetBattleFrame.TopVersusText:Show()
    PetBattleFrame.TopArtLeft:Show()
    PetBattleFrame.TopArtRight:Show()
    PetBattleFrame.BottomFrame.Background:Show()
    PetBattleFrame.BottomFrame.LeftEndCap:Show()
    PetBattleFrame.BottomFrame.RightEndCap:Show()
    PetBattleFrame.BottomFrame.FlowFrame:Show()
    PetBattleFrame.BottomFrame.Delimiter:Show()
    --PetBattleFrame.BottomFrame.MicroButtonFrame:Show()
    PetBattleFrame.BottomFrame.TurnTimer.ArtFrame2:Show()
  end

  if TidyBar_options.show_StatusTrackingBarManager == false then
    PetBattleFrameXPBar:Hide()
  else
    PetBattleFrameXPBar:Show()
  end

end



function TidyBar_refresh_everything()
  if not MainMenuBar:IsVisible() == true then return end
  debug( 'TidyBar_refresh_everything() - ' .. GetTime() )
  TidyBar_refresh_main_area()
  TidyBar_refresh_corner( false )
  TidyBar_refresh_side( false )
  TidyBar_refresh_petbattle()
end



TidyBar = CreateFrame( 'Frame', 'TidyBar', WorldFrame )
TidyBar:SetFrameStrata( 'BACKGROUND' )
TidyBar:RegisterEvent( 'PLAYER_LOGIN' )
--TidyBar:RegisterEvent( 'ADDON_LOADED' )
TidyBar:SetScript( 'OnEvent', function( self )
  self:Show()
  --print( 'TidyBar version ' .. tostring( GetAddOnMetadata( 'TidyBar', 'Version' ) ) .. ' loaded.' )
  debug( 'TidyBar version ' .. tostring( GetAddOnMetadata( 'TidyBar', 'Version' ) ) .. ' loaded.  Debugging mode enabled.' )

  do  --  Set up the side

    do  --  Frame
      --  Not setting up a TidyBar frame just for the side, since I can use VerticalMultiBarsContainer
      --  Not moving VerticalMultiBarsContainer, since I'm not really sure where it should go or if I should bother.
      frame_debug_overlay( VerticalMultiBarsContainer, 'frame_debug_overlay( TidyBar_frame_side )' )
      MultiBarRight:SetParent( VerticalMultiBarsContainer )
      MultiBarLeft:SetParent(  VerticalMultiBarsContainer )
      -- TODO? - Make it slightly wider.  Check the width of the buttons, if Shown(), and add to it.
    end


    do  --  Scripting
      local function VerticalMultiBarsContainer_scripting( frame, parameter )
        if frame == nil then print( 'VerticalMultiBarsContainer_scripting() error using ' .. parameter .. ' attempting to continue..' ); return end
        -- Spammy
        --debug( GetTime() .. ' VerticalMultiBarsContainer_scripting( ' .. tostring( frame ) .. ' )' )
        frame:SetScript( 'OnEnter',  function() TidyBar_refresh_side( true  ) end )
        frame:SetScript( 'OnLeave',  function() TidyBar_refresh_side( false ) end )
      end

      VerticalMultiBarsContainer_scripting( VerticalMultiBarsContainer, 'VerticalMultiBarsContainer_scripting( VerticalMultiBarsContainer )' )
      VerticalMultiBarsContainer_scripting( MultiBarRight,              'VerticalMultiBarsContainer_scripting( MultiBarRight )' )
      VerticalMultiBarsContainer_scripting( MultiBarLeft,               'VerticalMultiBarsContainer_scripting( MultiBarLeft )' )

      for i = 1, 12 do
        VerticalMultiBarsContainer_scripting( _G[ 'MultiBarRightButton' .. i ] )
        VerticalMultiBarsContainer_scripting( _G[ 'MultiBarLeftButton'  .. i ] )
      end
    end

  end


  do  --  Set up the corner

    do  --  frame
      -- Not setting up a TidyBar frame just for the corner, since I can use MicroButtonAndBagsBar
      MicroButtonAndBagsBar:EnableMouse()
      frame_debug_overlay( MicroButtonAndBagsBar, 'frame_debug_overlay( MicroButtonAndBagsBar )' )
    end


    do  --  Scripting
      local function TidyBar_frame_corner_scripting( frame, parameter )
        if frame == nil then print( 'TidyBar TidyBar_frame_corner_scripting() error using ' .. parameter .. ' attempting to continue..' ); return end
        frame:SetScript( 'OnEnter',  function() if not PetBattleFrame:IsShown() then TidyBar_refresh_corner( true  ) end end )
        frame:SetScript( 'OnLeave',  function() if not PetBattleFrame:IsShown() then TidyBar_refresh_corner( false ) end end )
      end

      TidyBar_frame_corner_scripting( MicroButtonAndBagsBar, 'TidyBar_frame_corner_scripting( MicroButtonAndBagsBar )' )
      --MicroButtonAndBagsBar:SetScript( 'OnEnter',  function() print( 'it enters' ) ; TidyBar_refresh_corner( true  ) end )
      --MicroButtonAndBagsBar:SetScript( 'OnLeave',  function() print( 'it exits'  ) ; TidyBar_refresh_corner( false ) end )

      --  LUA has no functionality to iterate over two tables simultaneously; they would have to be combined.
      for i, name in pairs( MenuButtonFrames ) do
        --name:SetParent( MicroButtonAndBagsBar )
        TidyBar_frame_corner_scripting( name, 'TidyBar_frame_corner: ' .. tostring( name ) )
      end
      for i, name in pairs( BagButtonFrameList ) do
        --name:SetParent( MicroButtonAndBagsBar )
        TidyBar_frame_corner_scripting( name, 'TidyBar_frame_corner: ' .. tostring( name ) )
      end
    end



  end


  do  --  Pet Battle scripting
    TidyBar_PetBattle = CreateFrame( 'Frame', 'TidyBar_PetBattle', WorldFrame )
    TidyBar_PetBattle:SetFrameStrata( 'BACKGROUND' )
    TidyBar_PetBattle:RegisterEvent( 'PET_BATTLE_OPENING_START' )
    TidyBar_PetBattle:SetScript( 'OnEvent', function( self )
      self:Show()
      TidyBar_refresh_petbattle()
    end )
  end


  TidyBar_setup_options_pane()
  --TidyBar_refresh_everything()


  --TidyBar_Frame_refresh_everything = CreateFrame( 'Frame', 'TidyBar_Frame_refresh_everything', WorldFrame )
  --TidyBar_Frame_refresh_everything:SetFrameStrata( 'BACKGROUND' )
  ---- If I can find a trigger that fires after the UI is shown (alt-z twice), then I can force-refresh..
  ----TidyBar_Frame_refresh_everything:RegisterEvent( 'ACTIONBAR_SHOWGRID' )
  --TidyBar_Frame_refresh_everything:RegisterEvent( 'ACTIONBAR_PAGE_CHANGED' )
  --TidyBar_Frame_refresh_everything:SetScript( 'OnEvent', function( self )
    --self:Show()
    --print( 'refresh 02 ' .. GetTime() )
    --TidyBar_refresh_everything()
  --end )


  -- Call Update Function when the default UI makes changes
  -- This isn't needed for the corner code, so maybe that's something to learn from.  That's really strange, since the corner code is based on the side code!
  -- I don't understand, but throttling just magically started happening while I was screwing around elsewhere.
  --local throttle = GetTime()
  hooksecurefunc( 'UIParent_ManageFramePositions', function( self )
    if throttle == GetTime() then
      debug( 'refresh from UIParent_ManageFramePositions - ' .. GetTime() )
      TidyBar_refresh_everything()
    end
    throttle = GetTime()
  end )

  --hooksecurefunc( 'BuffFrame_Update', function( self )
    --debug( 'refresh from BuffFrame_Update - ' .. GetTime() )
    --TidyBar_refresh_everything()
  --end )

end )


--UNIT_ENTERED_VEHICLE
--[[
local function TidyBar_VehicleSetup()
  if not UnitHasVehicleUI( 'player' ) then return nil end
  debug( ' TidyBar_VehicleSetup()' )

  do  --  hide stuff
    hide( OverrideActionBarEndCapL, 'OverrideActionBarEndCapL' )
    hide( OverrideActionBarEndCapR, 'OverrideActionBarEndCapR' )

    hide( OverrideActionBarBG, 'OverrideActionBarBG' )
    hide( OverrideActionBarMicroBGL, 'OverrideActionBarMicroBGL' )
    hide( OverrideActionBarMicroBGMid, 'OverrideActionBarMicroBGMid' )
    hide( OverrideActionBarMicroBGR, 'OverrideActionBarMicroBGR' )

    -- The box around the buttons
    hide( OverrideActionBarButtonBGL, 'OverrideActionBarButtonBGL' )
    hide( OverrideActionBarButtonBGMid, 'OverrideActionBarButtonBGMid' )
    hide( OverrideActionBarButtonBGR, 'OverrideActionBarButtonBGR' )

    hide( OverrideActionBarDivider2, 'OverrideActionBarDivider2' )
    hide( OverrideActionBarBorder, 'OverrideActionBarBorder' )
    hide( OverrideActionBarLeaveFrameDivider3, 'OverrideActionBarLeaveFrameDivider3' )
    hide( OverrideActionBarLeaveFrameExitBG, 'OverrideActionBarLeaveFrameExitBG' )

    hide( OverrideActionBarExpBarXpL, 'OverrideActionBarExpBarXpL' )
    hide( OverrideActionBarExpBarXpMid, 'OverrideActionBarExpBarXpMid' )
    hide( OverrideActionBarExpBarXpR, 'OverrideActionBarExpBarXpR' )
  end

  do  --  health/power bars
    OverrideActionBarHealthBar:ClearAllPoints()
    OverrideActionBarPowerBar:ClearAllPoints()
    OverrideActionBarHealthBar:SetPoint( 'BottomLeft', OverrideActionBar, 'BottomLeft', 4, 16 )
    -- FIXME - OverrideActionBarHealthBarOverlay is one pixel too wide, demonstrated here:
    --OverrideActionBarHealthBarOverlay:SetPoint( 'BottomLeft', OverrideActionBarHealthBar, 'BottomLeft', -1, 0 )
    OverrideActionBarPowerBar:SetPoint( 'BottomLeft', OverrideActionBarHealthBar, 'BottomRight' )
    OverrideActionBarHealthBarText:SetWidth( 0.001 )
    OverrideActionBarPowerBarText:SetWidth( 0.001 )
    OverrideActionBarHealthBar:SetWidth( 8 )
    OverrideActionBarPowerBar:SetWidth( 8 )
    OverrideActionBarHealthBarOverlay:SetWidth( 8 )
    OverrideActionBarPowerBarOverlay:SetWidth( 8 )
    hide( OverrideActionBarHealthBarBackground, 'OverrideActionBarHealthBarBackground' )
    hide( OverrideActionBarPowerBarBackground, 'OverrideActionBarPowerBarBackground' )
  end

  do  --  experience bar
    -- The vehicle XP 'bubbles'.
    for i=1,19 do
      hide( _G[ 'OverrideActionBarXpDiv' .. i ], "_G[ 'OverrideActionBarXpDiv' .. i ]" )
    end
  end

  OverrideActionBarLeaveFrameLeaveButton:ClearAllPoints()
  OverrideActionBarLeaveFrameLeaveButton:SetPoint( 'BottomRight', OverrideActionBar, 'BottomRight', 0, 16 )

  OverrideActionBarButton1:ClearAllPoints()
  OverrideActionBarButton1:SetPoint( 'BottomLeft', OverrideActionBar, 'BottomLeft', 24, 16 )
end
TidyBar:RegisterEvent( 'UNIT_ENTERED_VEHICLE' )
TidyBar:HookScript( 'OnEvent', TidyBar_VehicleSetup )
--]]













































