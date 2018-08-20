-- RE-TEST - Refreshing is throttled.  Every tiny thing can help performance.


-- TODO SOONER
--  Test combat pet bars
--  Test vehicles


-- TODO - investigate replacing the empty 30% tga with a backdrop:
--  https://wow.gamepedia.com/API_Frame_SetBackdrop
--  See the function frame_debug_overlay and apply it to the whole region
--  I cannot apply it to each icon space, because there's nothing there when it's empty.

-- However, if I keep my side frame, and then instead use the alpha code on VerticalMultiBarsContainer, then I might be able to completely resolve issue #30 (cooldown flash).  Investigate.

-- Test ExtraActionButton1
  --  style it.
  --  I'd love to move it to the middle, above all the bars.. but I'm not sure how to pull that off, offhand.



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
  if InCombatLockdown() == false then
    local anchor

    do  --  Positioning
      TidyBar_main_frame:SetPoint( 'Bottom', nil, 'Bottom', TidyBar_options.main_area_positioning_x, TidyBar_options.main_area_positioning_y )
    end


    do  --  StatusTrackingBarManager
      --  NOTE - No matter what I do, StatusTrackingBarManager is stuck to the bottom of MainMenuBar.
      local __ = StatusTrackingBarManager
      if TidyBar_options.show_StatusTrackingBarManager == false then
        __:Hide()
      else
        __:Show()
        --  Hide the main bar bubbles
        StatusTrackingBarManager.SingleBarLarge:Hide()
        -- Implement StatusTrackingBarManager functionality
        --   https://github.com/spiralofhope/TidyBar/issues/67
        --   I am unable to move or reduce the width of StatusTrackingBarManager.  It's tied to MainMenuBar.
        --   .. In combat, when the ActionBarPage is changed, MainMenuBar will reset.  This is why I completely detached from using MainMenuBar and don't even try to manipulate StatusTrackingBarManager.
        --__:ClearAllPoints()
        --__:SetWidth( 500 )
        --__:SetParent( TidyBar_main_frame )
        --__:SetPoint( 'BottomLeft', UIParent, 'BottomLeft' )
        --anchor = StatusTrackingBarManager
      end

    end


    --  This is Blizzard's choice
    --  FIXME - Height seems somewhat wrong compared to the width.
    --          I bet it's different because the screen height is different.
    local space_between_buttons = 6
    local height_offset

    do  --  bottom row
      if TidyBar_options.show_StatusTrackingBarManager == true then
        -- For some reason, StatusTrackingBarManager doesn't have a proper height.. so I'll add 2.
        height_offset = StatusTrackingBarManager:GetHeight() + space_between_buttons + 2
      else
        height_offset = space_between_buttons
      end
      -- Note that StatusTrackingBarManager has an untrustworthy position.
      ActionButton1:SetPoint( 'BottomLeft', TidyBar_main_frame, 'BottomLeft', 0, height_offset )
      anchor = ActionButton1
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
        --FramerateLabel:ClearAllPoints()
        --FramerateText:ClearAllPoints()
        --FramerateLabel:SetPoint( 'Bottom', anchor,        'Top' )
        --FramerateText:SetPoint(  'Left',  FramerateText, 'Right', 0, 0 )
        FramerateLabel:ClearAllPoints()
        FramerateLabel:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, space_between_buttons )
        --FramerateLabel:Hide()
        anchor = FramerateText
      end
    end

    -- Untested
    do  --  ExtraActionButton1 (the big button)
      if ExtraActionButton1:IsShown() then
        ExtraActionButton1:ClearAllPoints()
        ExtraActionButton1:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, space_between_buttons )
        anchor = ExtraActionButton1
      end
    end

  end  --  if not InCombatLockdown()
  --  If either in or out of combat...

  do  --  main area texture
    -- Implement main bar texture
    --   https://github.com/spiralofhope/TidyBar/issues/68
    if TidyBar_options.show_textured_background_main == true then
      MainMenuBarArtFrameBackground:Show()
    else
      MainMenuBarArtFrameBackground:Hide()
    end
  end



  --  Hide the gryphons
  MainMenuBarArtFrame.LeftEndCap:Hide()
  MainMenuBarArtFrame.RightEndCap:Hide()



  do  -- Hide the fiddly bits on the main bar
    hide( MainMenuBarArtFrame.PageNumber, 'MainMenuBarArtFrame.PageNumber' )
    hide( ActionBarUpButton, 'ActionBarUpButton' )
    hide( ActionBarDownButton, 'ActionBarDownButton' )
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


  do  --  Power bar
    --  Reproducable by going to BfA > Kul Tiras > Stormstrong Valley > (The Brineworks), "Strain"
    --  This is some sort of left-side bar.  Even with the default UI this looks terrible.
    --PlayerPowerBarAltFill:Hide()
    --  The background
    PlayerPowerBarAlt.frame:Hide()
    --  This would remove the background texture.
    --PlayerPowerBarAlt.background:Hide()
  end


  --  Hide the bubbles on the status bar (xp etc)
  StatusTrackingBarManager.SingleBarLarge:Hide()

  -- It does nothing anyway.
  MainMenuBarArtFrameBackground:Hide()

end



local function TidyBar_refresh_side( is_mouse_inside_side )

  do  --  Quest tracker
    -- Code removed.  I can't figure out what elements to manipulate, and I don't want to make this code complex since it'll just break things anyway.
    if MultiBarRight:IsShown() == false then
      -- if MultiBarRight isn't there, then neither is MultiBarLeft, and TidyBar doesn't have anything to do.  Just exit.
      --ObjectiveTrackerFrame:ClearAllPoints()
      --ObjectiveTrackerFrame:SetPoint( 'TopRight', MinimapCluster, 'BottomRight', 0, -10 )
      return
    end
    --ObjectiveTrackerFrame:ClearAllPoints()
    --ObjectiveTrackerFrame:SetPoint( 'TopRight', VerticalMultiBarsContainer, 'TopLeft', -10, 0 )
  end

  do  --  debugging
    if is_mouse_inside_side == true then
      debug( ' mouse entered the side' )
    else
      debug( ' mouse exited the side' )
    end
    debug( ' SpellFlyout:IsShown( ' .. tostring( SpellFlyout:IsShown() ) .. ' )' )
  end


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
  if    TidyBar_options.always_show_side == true
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


  -- The nagging talent popup.
  TalentMicroButtonAlert:Hide()

  local alpha
  if  is_mouse_inside_corner
  or  TidyBar_options.always_show_corner  ==  true
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

  -- Positioning
  PetBattleFrame.BottomFrame:ClearAllPoints()
  -- FIXME - this isn't working for some reason.
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



function TidyBar_refresh_everything()
  -- FIXME/change?
  if MainMenuBar:IsVisible() == false then return end
  debug( 'TidyBar_refresh_everything() - ' .. GetTime() )
  -- There's a problem with it being too far to the left, making it impossible to mouseover or click items in the chat box.
  MainMenuBar:SetWidth( 1 )
  TidyBar_refresh_main_area()
  TidyBar_refresh_corner( false )
  TidyBar_refresh_side( false )
  if PetBattleFrame:IsShown() then TidyBar_refresh_petbattle() end
end



TidyBar = CreateFrame( 'Frame', 'TidyBar', WorldFrame )
TidyBar:SetFrameStrata( 'BACKGROUND' )
TidyBar:RegisterEvent( 'PLAYER_LOGIN' )
--TidyBar:RegisterEvent( 'ADDON_LOADED' )
TidyBar:SetScript( 'OnEvent', function( self )
  self:Show()
  --print( 'TidyBar version ' .. tostring( GetAddOnMetadata( 'TidyBar', 'Version' ) ) .. ' loaded.' )
  debug( 'TidyBar version ' .. tostring( GetAddOnMetadata( 'TidyBar', 'Version' ) ) .. ' loaded.  Debugging mode enabled.' )


  do  --  Set up the main area
    --  The MainMenuBar is insane, and repositions mid-combat when the ActionBarPage is changed, so I'm forced to set up my own frame.
    local __
    __ = TidyBar_main_frame
    __ = CreateFrame( 'Frame', 'TidyBar_main_frame', nil )
    __:SetFrameStrata( 'BACKGROUND' )
    __:SetWidth( 1 )
    __:SetHeight( 1 )
    __:EnableMouse( true )
    __:SetPoint( 'Bottom', nil, 'Bottom' )
  end


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

  --TidyBar_refresh_everything()
  TidyBar_setup_options_pane()


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














































