--  Technically adjustable, but I don't want to support that without a request.
local Empty_Art              = 'Interface/Addons/TidyBar/empty'

--  Learn if TidyBar is running on classic or retail.
if     ( WOW_PROJECT_ID == WOW_PROJECT_CLASSIC )
  then release_type = 'classic'
  else release_type = 'retail'
end

local MenuButtonFrames = {}
if release_type == 'retail' then
  MenuButtonFrames = {
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
elseif release_type == 'classic' then
  MenuButtonFrames = {
    CharacterMicroButton,     -- Character Info
    SpellbookMicroButton,     -- Spellbook & Abilities
    QuestLogMicroButton,      -- Quest Log
    SocialsMicroButton,       -- Social - Friends, Who, Guild, Raid
    WorldMapMicroButton,      -- Map
    MainMenuMicroButton,      -- Game Menu
    HelpMicroButton,          -- Customer Support
  }
end


local BagButtonFrameList = {
  MainMenuBarBackpackButton,  --  The big backpack
  CharacterBag0Slot,
  CharacterBag1Slot,
  CharacterBag2Slot,
  CharacterBag3Slot,
}



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
  local __

  --  If out of combat:
  if not InCombatLockdown() then
    local anchor

    --do  --  Positioning
      --TidyBar_main_frame:SetPoint( 'Bottom', nil, 'Bottom', TidyBar_options.main_area_positioning_x, TidyBar_options.main_area_positioning_y )
    --end


    if release_type == 'retail' then
      do  --  StatusTrackingBarManager
        --  NOTE - No matter what I do, StatusTrackingBarManager is stuck to the bottom of MainMenuBar.
        local __ = StatusTrackingBarManager
        if TidyBar_options.show_StatusTrackingBarManager == false then
          __:Hide()
        else
          __:Show()
          --  Hide the main bar bubbles
          StatusTrackingBarManager.SingleBarLarge:Hide()
          -- issue #67 - Implement StatusTrackingBarManager functionality
          --   I am unable to move or reduce the width of StatusTrackingBarManager.  It's tied to MainMenuBar.
          --   .. In combat, when the ActionBarPage is changed, MainMenuBar will reset.  This is why I completely detached from using MainMenuBar and don't even try to manipulate StatusTrackingBarManager.
          --__:ClearAllPoints()
          --__:SetWidth( 500 )
          --__:SetParent( TidyBar_main_frame )
          --__:SetPoint( 'BottomLeft', UIParent, 'BottomLeft' )
          --anchor = StatusTrackingBarManager
        end
      end
    end


    --  PetActionBarFrame
    if release_type == 'retail' then
      local __ = PetActionBarFrame
      PetActionBarFrame:SetPoint( 'BottomLeft', UIParent, 'BottomLeft' )
    end


    --  This is Blizzard's choice
    --  FIXME - Height seems somewhat wrong compared to the width.
    --          I bet it's different because the screen height is different.
    local number_of_buttons = 12
    local space_between_buttons = 6

    local height_offset = space_between_buttons


    do  --  everything
      if release_type == 'retail' then
        --  Hide the bubbles on the status bar (xp etc)
        StatusTrackingBarManager.SingleBarLarge:Hide()

        -- This does nothing anyway
        MainMenuBarArtFrameBackground:Hide()
      end

      -- Because everything is attached to the MainMenuBar, this is the only way to usually-resize StatusTrackingBarManager.
      if TidyBar_options.show_StatusTrackingBarManager == false then
        -- This solves a problem with it being too far to the left, making it impossible to mouseover or click items in the chat box.
        MainMenuBar:SetWidth( 1 )
      else
        -- It's terrible, but this is better than nothing..
        -- This may still have the too-left problem.
        --   .. offhand, I can see that  `StatusBar.BarTrailGlow`  and  `StatusBar.SparkBurstMove`  are too-left.
        MainMenuBar:SetWidth( ( ActionButton1:GetWidth() * number_of_buttons ) + ( space_between_buttons * ( number_of_buttons - 1 ) ) )
      end
    end

    do  --  bottom row
      if TidyBar_options.show_StatusTrackingBarManager == true then
        -- For some reason, StatusTrackingBarManager doesn't have a proper height.. so I'll add 2.
        height_offset = StatusTrackingBarManager:GetHeight() + space_between_buttons + 2
      end
      -- Note that StatusTrackingBarManager has an untrustworthy position.
      ActionButton1:SetPoint( 'BottomLeft', UIParent, 'BottomLeft', TidyBar_options.main_area_positioning_x, TidyBar_options.main_area_positioning_y )

      anchor = ActionButton1
    end

    -- XP bar (Classic)
      if release_type == 'classic' then
      MainMenuExpBar:SetWidth( ( ActionButton1:GetWidth() * number_of_buttons ) + ( space_between_buttons * ( number_of_buttons - 1 ) ) )
      MainMenuExpBar:SetHeight( space_between_buttons )
      ExhaustionLevelFillBar:SetHeight( space_between_buttons )
      MainMenuExpBar:ClearAllPoints()
      MainMenuExpBar:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, space_between_buttons )
      anchor = MainMenuExpBar
    end

    do  --  Middle row
      if MultiBarBottomLeft:IsShown() then
        -- MultiBarBottomLeftButton1 is already somewhat attached, but let's be more specific.
        MultiBarBottomLeftButton1:ClearAllPoints()
        MultiBarBottomLeftButton1:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, space_between_buttons )
        anchor = MultiBarBottomLeftButton1
      end
    end

    do  --  Top row
      if MultiBarBottomRight:IsShown() then
        MultiBarBottomRightButton1:ClearAllPoints()
        MultiBarBottomRightButton1:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, space_between_buttons )
        --  It's not used for anything, but may as well move it.
        MultiBarBottomRight:ClearAllPoints()
        MultiBarBottomRight:SetPoint( 'BottomLeft', MultiBarBottomRightButton1, 'BottomLeft', 0, 0 )
        --  Buttons 7-12 are a separate block from 1-6, so move them.
        MultiBarBottomRightButton7:ClearAllPoints()
        MultiBarBottomRightButton7:SetPoint( 'BottomLeft', MultiBarBottomRightButton6, 'BottomRight', space_between_buttons, 0 )
        anchor = MultiBarBottomRightButton1
      end
    end

    do  --  StanceBar
      if StanceBarFrame:IsShown() then
        --  The background texture
        StanceBarMiddle:Hide()
        StanceButton1:ClearAllPoints()
        StanceButton1:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, space_between_buttons )
        -- Hide its background
        hide( StanceBarLeft,  'StanceBarLeft'  )
        hide( StanceBarRight, 'StanceBarRight' )
        anchor = StanceButton1
      end
    end

    do  --  Pet bar
      if PetActionButton1:IsShown() then
        --  The background texture
        PetActionButton1:ClearAllPoints()
        PetActionButton1:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, space_between_buttons )
        anchor = PetActionButton1
      end
    end

    do  --  MainMenuBarVehicleLeaveButton
      if MainMenuBarVehicleLeaveButton:IsShown() then
        MainMenuBarVehicleLeaveButton:ClearAllPoints()
        MainMenuBarVehicleLeaveButton:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, space_between_buttons )
        anchor = MainMenuBarVehicleLeaveButton
      end
    end

    do  --  FramerateText (fps meter)
      if FramerateText:IsShown() then
        FramerateLabel:ClearAllPoints()
        FramerateLabel:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, space_between_buttons )
        anchor = FramerateText
      end
    end

    if release_type == 'retail' then
      do  --  ExtraActionButton1 (the big button)
        if ExtraActionButton1:IsShown() then
          ExtraActionButton1:ClearAllPoints()
          ExtraActionButton1:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, space_between_buttons )
          anchor = ExtraActionButton1
        end
      end
    end

  end  --  if not InCombatLockdown()
  --  If either in or out of combat...

  do  -- Hide the fiddly bits on the main bar
    if     release_type == 'retail' then
      -- Implement main bar texture
      --   https://github.com/spiralofhope/TidyBar/issues/68
      if TidyBar_options.show_textured_background_main == true
        then  MainMenuBarArtFrameBackground:Show()
        else  MainMenuBarArtFrameBackground:Hide()
      end
      hide( MainMenuBarArtFrame.PageNumber, 'MainMenuBarArtFrame.PageNumber' )
    elseif release_type == 'classic' then
      hide( ExhaustionTick,        'ExhaustionTick' )
      hide( ExhaustionTickNormal,  'ExhaustionTickNormal' )
      --hide( ExhaustionTickHilight, 'ExhaustionTickHilight' )
      hide( MainMenuBarPerformanceBar, 'MainMenuBarPerformanceBar' )
      for i = 0, 3 do
        __=_G[ 'MainMenuBarTexture'   .. i ] ; hide( __, __.tostring )
        __=_G[ 'MainMenuXPBarTexture' .. i ] ; hide( __, __.tostring )
      end
      hide( MainMenuBarPageNumber, 'MainMenuBarPageNumber' )
    end
    hide( ActionBarUpButton, 'ActionBarUpButton' )
    hide( ActionBarDownButton, 'ActionBarDownButton' )
  end

  --  Hide the gryphons
  --  See issue #70 - Re-implement gryphon functionality
  if    release_type == 'retail' then
    hide( MainMenuBarArtFrame.LeftEndCap,  'MainMenuBarArtFrame.LeftEndCap' )
    hide( MainMenuBarArtFrame.RightEndCap, 'MainMenuBarArtFrame.RightEndCap' )
  else  -- classic
    hide( MainMenuBarLeftEndCap,  'MainMenuBarLeftEndCap' )
    hide( MainMenuBarRightEndCap, 'MainMenuBarRightEndCap' )
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


  if release_type == 'retail' then
    do  --  Power bar
      --  See issue #76 - Beautify alternate power bar
      --PlayerPowerBarAltFill:Hide()
      --  The background
      PlayerPowerBarAlt.frame:Hide()
      --  This would remove the background texture:
      --PlayerPowerBarAlt.background:Hide()
    end


    --  Hide the background/side styling of the ExtraActionButton
    ExtraActionButton1.style:Hide()
  end

end



local function TidyBar_refresh_side( is_mouse_inside_side )

  do  --  debugging
    if is_mouse_inside_side == true then
      debug( ' mouse entered the side' )
    else
      debug( ' mouse exited the side' )
    end
    if release_type == 'retail' then
      debug( ' SpellFlyout:IsShown( ' .. tostring( SpellFlyout:IsShown() ) .. ' )' )
    end
  end


  if not InCombatLockdown() then
--[[  issue #30 - Hide global cooldowns in sidebar, when hidden-on-mouseout
      -- nothing works.
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
  if    TidyBar_options.always_show_side == true
    or  is_mouse_inside_side
    or  ( release_type == 'retail' and SpellFlyout:IsShown() )
  then  --  Show
    alpha = 1
  else  --  Hide
    alpha = 0
  end

  for i = 1, 12 do
    if MultiBarRight:IsShown() then _G[ 'MultiBarRightButton' .. i ]:SetAlpha( alpha ) end
    if MultiBarLeft:IsShown()  then _G[ 'MultiBarLeftButton'  .. i ]:SetAlpha( alpha ) end
  end
  --Make the region around the sidebar slightly wider.  This lets the mouse reveal the side buttons more easily.
  local __ = 10
  if MultiBarRight:IsShown() then __ = __ + MultiBarRightButton1:GetWidth() end
  if MultiBarLeft:IsShown()  then __ = __ + MultiBarLeftButton1:GetWidth()  end
  if not InCombatLockdown() then VerticalMultiBarsContainer:SetWidth( __ ) end
  --VerticalMultiBarsContainer:SetWidth( VerticalMultiBarsContainer:GetWidth() + 10 )


--[[  issue #30 - Hide global cooldowns in sidebar, when hidden-on-mouseout
    --  Attempting to more thorougly solve it, but nothing works.
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
    do  -- The corner frame for the buttons and bags
      local __ = MicroButtonAndBagsBar
      --  parent frame size
      --  TODO - get the first entry in the MenuButtonFrames array
      local MicroButtonAndBagsBar_width = 0
      for _, name in pairs( MenuButtonFrames ) do
        MicroButtonAndBagsBar_width = ( MicroButtonAndBagsBar_width + name:GetWidth() )
      end
      --print( MicroButtonAndBagsBar_width )
      --[[  TODO - issue #61 - Implement movable bags
                   Blindly changing these values will mess up the positioning and scale of the side bars.
      local y = 300
      --]]
      --  It's intentionally shifted away from the edges.
      --  .. in case there's something the user stuffed into that corner.
      local x = 3
      local y = 3
      __:ClearAllPoints()
      --print( __:GetWidth() )
      __:SetWidth( MicroButtonAndBagsBar_width + 10 )
      __:SetHeight( CharacterMicroButton:GetHeight() + MainMenuBarBackpackButton:GetHeight() + 10 )
      __:SetPoint( 'BottomRight', WorldFrame, 'BottomRight', x, y )
    end


    if release_type == 'retail' then
      do  --  The corner background art
        --[[
            --  TODO - I have to make a custom background, or figure out how to manipuluate the existing one.
            if TidyBar_options.show_textured_background_corner == true then
              MicroButtonAndBagsBar.MicroBagBar:Show()
            else
              MicroButtonAndBagsBar.MicroBagBar:Hide()
            end
          end
        --]]
        MicroButtonAndBagsBar.MicroBagBar:Hide()
      end
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
      --  Maybe I could fix it by using my own custom frame and not relying on MicroButtonAndBagsBar.
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
      if     release_type == 'retail' then
        MainMenuBarBackpackButton:SetPoint( 'BottomLeft', CharacterMicroButton, 'TopLeft', 0, separation )
      elseif release_type == 'classic' then
        -- I don't know why I have to push it up by 10..
        MainMenuBarBackpackButton:SetPoint( 'BottomLeft', MicroButtonPortrait, 'TopLeft', -3, 10 )
      end
    end
  end  --  not InCombatLockdown() then


  local alpha
  if  is_mouse_inside_corner
  or  TidyBar_options.always_show_corner  ==  true
  then
    alpha = 1
  else
    alpha = 0
  end
  MicroButtonAndBagsBar:SetAlpha( alpha )

end



if release_type == 'classic' then
  local function TidyBar_refresh_petbattle()
    -- Positioning
    PetBattleFrame.BottomFrame:ClearAllPoints()
    -- See issue #71 - Fix PetBattleFrame.BottomFrame positioning
    --   This isn't working for some reason:
    PetBattleFrame.BottomFrame:SetPoint( 'Bottom', WorldFrame, 'Bottom', TidyBar_options.main_area_positioning_x, TidyBar_options.main_area_positioning_y )

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
end



function TidyBar_refresh_everything()
  if MainMenuBar:IsVisible() == false then return end
  debug( 'TidyBar_refresh_everything() - ' .. GetTime() )
  TidyBar_refresh_main_area()
  TidyBar_refresh_corner( false )
  TidyBar_refresh_side( false )
  if ( release_type == 'retail' and PetBattleFrame:IsShown() ) then TidyBar_refresh_petbattle() end
end



TidyBar = CreateFrame( 'Frame', 'TidyBar', WorldFrame )
TidyBar:SetFrameStrata( 'BACKGROUND' )
TidyBar:RegisterEvent( 'PLAYER_LOGIN' )
--TidyBar:RegisterEvent( 'ADDON_LOADED' )
TidyBar:SetScript( 'OnEvent', function( self )
  if release_type == 'classic' then
    TidyBar = CreateFrame( 'Frame', 'MicroButtonAndBagsBar', WorldFrame )
    MicroButtonAndBagsBar:SetFrameStrata( 'BACKGROUND' )
  end

  self:Show()
  --print( 'TidyBar version ' .. tostring( GetAddOnMetadata( 'TidyBar', 'Version' ) ) .. ' loaded.' )
  debug( 'TidyBar version ' .. tostring( GetAddOnMetadata( 'TidyBar', 'Version' ) ) .. ' loaded.  Debugging mode enabled.' )

  do  --  Set up the main area
    --[[  The MainMenuBar is insane, and repositions mid-combat when the ActionBarPage is changed, so I'm forced to set up my own frame.
    local __
    __ = TidyBar_main_frame
    __ = CreateFrame( 'Frame', 'TidyBar_main_frame', nil )
    __:SetFrameStrata( 'BACKGROUND' )
    __:SetWidth( 1 )
    __:SetHeight( 1 )
    __:EnableMouse( true )
    __:SetPoint( 'Bottom', nil, 'Bottom' )
    --]]
  end


  do  --  Set up the side

    do  --  Frame
      -- I'm not setting up a TidyBar frame just for the side, since I can use VerticalMultiBarsContainer
      frame_debug_overlay( VerticalMultiBarsContainer, 'frame_debug_overlay( TidyBar_frame_side )' )

      --[[  The side bars can be positioned like so:
      local x = 0  --  Setting this does nothing.  I don't understand.
      local y = 30
      VerticalMultiBarsContainer:SetPoint( 'BottomRight', UIParent, 'BottomRight', x, y )
      --]]
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
      -- In retail, I'm not setting up a TidyBar frame just for the corner, since I can use MicroButtonAndBagsBar
      -- In classic, a separate frame is created and called "MicroButtonAndBagsBar" for compatibility
      MicroButtonAndBagsBar:EnableMouse()
      frame_debug_overlay( MicroButtonAndBagsBar, 'frame_debug_overlay( MicroButtonAndBagsBar )' )
    end


    do  --  Scripting
      local function TidyBar_frame_corner_scripting( frame, parameter )
        if frame == nil then print( 'TidyBar TidyBar_frame_corner_scripting() error using ' .. parameter .. ' attempting to continue..' ); return end
        if     release_type == 'retail' then
          frame:SetScript( 'OnEnter',  function() if not PetBattleFrame:IsShown() then TidyBar_refresh_corner( true  ) end end )
          frame:SetScript( 'OnLeave',  function() if not PetBattleFrame:IsShown() then TidyBar_refresh_corner( false ) end end )
        elseif release_type == 'classic' then
          frame:SetScript( 'OnEnter',  function()                                      TidyBar_refresh_corner( true  )     end )
          frame:SetScript( 'OnLeave',  function()                                      TidyBar_refresh_corner( false )     end )
        end
      end

      TidyBar_frame_corner_scripting( MicroButtonAndBagsBar, 'TidyBar_frame_corner_scripting( MicroButtonAndBagsBar )' )
      --MicroButtonAndBagsBar:SetScript( 'OnEnter',  function() print( 'it enters' ) ; TidyBar_refresh_corner( true  ) end )
      --MicroButtonAndBagsBar:SetScript( 'OnLeave',  function() print( 'it exits'  ) ; TidyBar_refresh_corner( false ) end )

      for i, name in pairs( MenuButtonFrames ) do
        --name:SetParent( MicroButtonAndBagsBar )
        TidyBar_frame_corner_scripting( name, 'TidyBar_frame_corner: ' .. tostring( name ) )
      end
      for i, name in pairs( BagButtonFrameList ) do
        --name:SetParent( MicroButtonAndBagsBar )
        if release_type == 'classic' then
          name:SetParent( MicroButtonAndBagsBar )
        end
        TidyBar_frame_corner_scripting( name, 'TidyBar_frame_corner: ' .. tostring( name ) )
      end
    end



  end


  if release_type == 'retail' then
    do  --  Pet Battle scripting
      TidyBar_PetBattle = CreateFrame( 'Frame', 'TidyBar_PetBattle', WorldFrame )
      TidyBar_PetBattle:SetFrameStrata( 'BACKGROUND' )
      TidyBar_PetBattle:RegisterEvent( 'PET_BATTLE_OPENING_START' )
      TidyBar_PetBattle:SetScript( 'OnEvent', function( self )
        self:Show()
        TidyBar_refresh_petbattle()
      end )
    end
  end

  --TidyBar_refresh_everything()
  TidyBar_setup_options_pane()

--[[   issue #36 - Fix the corner partially reappearing when hiding/showing the UI
  TidyBar_Frame_refresh_everything = CreateFrame( 'Frame', 'TidyBar_Frame_refresh_everything', WorldFrame )
  TidyBar_Frame_refresh_everything:SetFrameStrata( 'BACKGROUND' )
  -- If I can find a trigger that fires after the UI is shown (alt-z twice), then I can force-refresh..
  --TidyBar_Frame_refresh_everything:RegisterEvent( 'ACTIONBAR_SHOWGRID' )
  TidyBar_Frame_refresh_everything:RegisterEvent( 'ACTIONBAR_PAGE_CHANGED' )
  TidyBar_Frame_refresh_everything:SetScript( 'OnEvent', function( self )
    self:Show()
    print( 'refresh 02 ' .. GetTime() )
    TidyBar_refresh_everything()
  end )
--]]

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


--[[  issue #65 - Investigate Vehicle UI for 8.x
--UNIT_ENTERED_VEHICLE
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
