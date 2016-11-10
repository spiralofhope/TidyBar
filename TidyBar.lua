﻿do  --  Defaults
  TidyBar_options = {}
  TidyBar_options.show_experience_bar = true
  TidyBar_options.show_artifact_power_bar = true
  TidyBar_options.show_honor_bar = true
  TidyBar_options.show_gryphons = false
  TidyBar_options.hide_side_on_mouseout = true
  TidyBar_options.show_MainMenuBar_textured_background = false
  TidyBar_options.show_macro_text = false
  TidyBar_options.scale = 1
  TidyBar_options.bar_spacing = 4
  TidyBar_options.main_area_positioning = 425
  TidyBar_options.debug = false
end



local can_display_artifact_bar = nil
local bar_width  = 500
--  Technically adjustable, but I don't want to support that without a request.
local bar_height = 8




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

--  Technically adjustable, but I don't want to support that without a request.
--local Corner_Artwork_Texture = 'Interface/Addons/TidyBar/empty'
--  Technically adjustable, but I don't want to support that without a request.
local Empty_Art              = 'Interface/Addons/TidyBar/empty'
local mouse_in_side, MouseInCorner = false


local TidyBar              = CreateFrame( 'Frame', 'TidyBar', WorldFrame )
local TidyBar_corner      = CreateFrame( 'Frame', 'TidyBar_corner',         UIParent )
local TidyBar_SideMouseoverFrame   = CreateFrame( 'Frame', 'TidyBar_side_frame',   UIParent )
      TidyBar_SideMouseoverFrame:SetFrameStrata( 'BACKGROUND' )

local TidyBar_refresh_side



local function TidyBar_refresh_side()
  if TidyBar_options.debug then
    print( GetTime() .. ' TidyBar_refresh_side()' )
  end
  local Alpha = 0
  if        mouse_in_side
    or not  TidyBar_options.hide_side_on_mouseout
            -- Some spells have an arrow, and clicking on them reveals a list of spells.  This is a "flyout".
            --   .. examples include Shaman Hex Variants and various Mage teleports and portals.
    or      SpellFlyout:IsShown()
  then
    Alpha = 1
  end
  for i = 1, 12 do
    _G[ 'MultiBarRightButton'..i ]:SetAlpha( Alpha )
    _G[ 'MultiBarLeftButton' ..i ]:SetAlpha( Alpha )
  end
end



local function HookFrame_Microbuttons( frameTarget )
  -- Spammy
  --if TidyBar_options.debug then
    --print( GetTime() .. ' HookFrame_Microbuttons()' )
  --end
  frameTarget:HookScript( 'OnEnter', function() if not UnitHasVehicleUI( 'player' ) then TidyBar_corner:SetAlpha( 1 ) end end )
  frameTarget:HookScript( 'OnLeave', function()                                          TidyBar_corner:SetAlpha( 0 ) end )
end



local function HookFrame_CornerBar( frameTarget )
  -- Spammy
  --if TidyBar_options.debug then
    --print( GetTime() .. ' HookFrame_CornerBar()' )
  --end
  frameTarget:HookScript( 'OnEnter', function() TidyBar_corner:SetAlpha( 1 ) end )
  frameTarget:HookScript( 'OnLeave', function() TidyBar_corner:SetAlpha( 0 ) end )
end



local function HookFrame_side( frameTarget )
  -- Spammy
  --if TidyBar_options.debug then
    --print( GetTime() .. ' HookFrame_side()' )
  --end
  frameTarget:HookScript( 'OnEnter', function() mouse_in_side = true;  TidyBar_refresh_side() end )
  frameTarget:HookScript( 'OnLeave', function() mouse_in_side = false; TidyBar_refresh_side() end )
end



local function ConfigureCornerBars()
  if TidyBar_options.debug then
    print( GetTime() .. ' ConfigureCornerBars()' )
  end

  MainMenuBarTexture2:SetTexture( Empty_Art )
  MainMenuBarTexture3:SetTexture( Empty_Art )
  MainMenuBarTexture2:Hide()
  MainMenuBarTexture3:Hide()

  -- The nagging talent popup
  TalentMicroButtonAlert:SetAlpha( 0 )
  TalentMicroButtonAlert:Hide()

  if not UnitHasVehicleUI( 'player' ) then
    CharacterMicroButton:ClearAllPoints()
    CharacterMicroButton:SetPoint( 'BottomRight', TidyBar_corner.MicroButtons, 'BottomRight', -270, 0 )
    for i, name in pairs( MenuButtonFrames ) do name:SetParent( TidyBar_corner.MicroButtons ) end
  end
end






local function TidyBar_setup_side()
  if TidyBar_options.debug then
    print( GetTime() .. ' TidyBar_setup_side()' )
  end

  if MultiBarRight:IsShown() then
    MultiBarRight:ClearAllPoints()
    MultiBarRight:SetPoint( 'TopRight', MinimapCluster, 'BottomRight', 0, -10 )
    TidyBar_SideMouseoverFrame:Show()
    MultiBarRight:EnableMouse()
    TidyBar_SideMouseoverFrame:SetPoint( 'BottomRight', MultiBarRight, 'BottomRight' )
    -- Right Bar 2
    -- Note that if MultiBarRight is not enabled, MultiBarLeft cannot be enabled.
    if MultiBarLeft:IsShown() then
      MultiBarLeft:ClearAllPoints()
      MultiBarLeft:SetPoint( 'TopRight', MultiBarRight, 'TopLeft' )
      MultiBarLeft:EnableMouse()
      TidyBar_SideMouseoverFrame:SetPoint( 'TopLeft', MultiBarLeft,  'TopLeft' )
    else
      TidyBar_SideMouseoverFrame:SetPoint( 'TopLeft', MultiBarRight, 'TopLeft' )
    end
  else
    TidyBar_SideMouseoverFrame:Hide()
  end

  if TidyBar_side_frame:IsShown() then
    -- Doing this somehow reduces the height of the objective tracker, showing only a few items.
    --_G[ 'ObjectiveTrackerFrame' ]:ClearAllPoints()
    _G[ 'ObjectiveTrackerFrame' ]:SetPoint( 'TopRight', TidyBar_side_frame, 'TopLeft' )
  else
    _G[ 'ObjectiveTrackerFrame' ]:SetPoint( 'TopRight', MinimapCluster, 'BottomRight', 0, -10 )
  end

  TidyBar_SideMouseoverFrame:EnableMouse()
  TidyBar_SideMouseoverFrame:SetScript( 'OnEnter', function() mouse_in_side = true;  TidyBar_refresh_side() end )
  TidyBar_SideMouseoverFrame:SetScript( 'OnLeave', function() mouse_in_side = false; TidyBar_refresh_side() end )
  HookFrame_side( MultiBarRight )
  HookFrame_side( MultiBarLeft )
  for i = 1, 12 do HookFrame_side( _G[ 'MultiBarRightButton'..i ] ) end
  for i = 1, 12 do HookFrame_side( _G[ 'MultiBarLeftButton' ..i ] ) end
end



local function TidyBar_setup_corner()
  if TidyBar_options.debug then
    print( GetTime() .. ' TidyBar_setup_corner()' )
  end
  local BagButtonFrameList = {
    MainMenuBarBackpackButton,
    CharacterBag0Slot,
    CharacterBag1Slot,
    CharacterBag2Slot,
    CharacterBag3Slot,
  }

  for i, name in pairs( BagButtonFrameList ) do
    name:SetParent( TidyBar_corner.BagButtonFrame )
  end
  
  MainMenuBarBackpackButton:ClearAllPoints()
  MainMenuBarBackpackButton:SetPoint( 'Bottom' )
  MainMenuBarBackpackButton:SetPoint( 'Right', -60, 0 )
  
  -- Setup the Corner Buttons
  for i, name in pairs( BagButtonFrameList ) do HookFrame_CornerBar(    name ) end
  for i, name in pairs( MenuButtonFrames   ) do HookFrame_Microbuttons( name ) end
  
  -- Setup the Corner Menu Artwork
  TidyBar_corner:SetScale( TidyBar_options.scale )
  TidyBar_corner.MicroButtons:SetAllPoints( TidyBar_corner )
  TidyBar_corner.BagButtonFrame:SetPoint( 'TopRight', 2, -18 )
  TidyBar_corner.BagButtonFrame:SetHeight( 64 )
  TidyBar_corner.BagButtonFrame:SetWidth( 256 )
  TidyBar_corner.BagButtonFrame:SetScale( 1.02 )
  
  -- Setup the Corner Menu Mouseover frame
  local TidyBar_corner_frame = CreateFrame( 'Frame', 'TidyBar_corner_frame', UIParent )
  TidyBar_corner_frame:EnableMouse()
  TidyBar_corner_frame:SetFrameStrata( 'BACKGROUND' )
  
  TidyBar_corner_frame:SetPoint( 'Top', MainMenuBarBackpackButton, 'Top', 0, 10 )
  TidyBar_corner_frame:SetPoint( 'Right',  UIParent, 'Right' )
  TidyBar_corner_frame:SetPoint( 'Bottom', UIParent, 'Bottom' )
  TidyBar_corner_frame:SetWidth( 322 )
  
  TidyBar_corner_frame:SetScript( 'OnEnter', function() TidyBar_corner:SetAlpha( 1 ) end )
  TidyBar_corner_frame:SetScript( 'OnLeave', function() TidyBar_corner:SetAlpha( 0 ) end )
end



local function TidyBar_setup_vehicle()
  if TidyBar_options.debug then
    print( GetTime() .. ' TidyBar_setup_vehicle()' )
  end
  OverrideActionBarEndCapL:Hide()
  OverrideActionBarEndCapR:Hide()

  OverrideActionBarBG:Hide()
  OverrideActionBarMicroBGL:Hide()
  OverrideActionBarMicroBGMid:Hide()
  OverrideActionBarMicroBGR:Hide()
  OverrideActionBarButtonBGL:Hide()
  OverrideActionBarButtonBGMid:Hide()
  OverrideActionBarButtonBGR:Hide()

  OverrideActionBarDivider2:Hide()
  OverrideActionBarBorder:Hide()
  OverrideActionBarLeaveFrameDivider3:Hide()
  OverrideActionBarLeaveFrameExitBG:Hide()

  OverrideActionBarExpBarXpL:Hide()
  OverrideActionBarExpBarXpMid:Hide()
  OverrideActionBarExpBarXpR:Hide()

  -- The vehicle XP 'bubbles'.
  for i=1,19 do
    _G[ 'OverrideActionBarXpDiv' .. i ]:Hide()
  end
end



local function TidyBar_setup_main_area()
  if TidyBar_options.debug then
    print( GetTime() .. ' TidyBar_setup_main_area()' )
  end
  if TidyBar_character_is_max_level then
    ArtifactWatchBar.StatusBar:HookScript( 'OnUpdate', function()
      -- Should solve the below occasional login error.
      if InCombatLockdown() then return end
      -- Occasionally throws an error (protected function) when entering combat while having recently logged-in.
      ArtifactWatchBar.StatusBar:SetHeight( 8 )
    end )
  end
end









local function TidyBar_refresh_main_area()
  if TidyBar_options.debug then
    print( GetTime() .. ' TidyBar_refresh_main_area()' )
  end
  -- MainMenuBar textured background
  -- Has to be repositioned and nudged to the left since ActionButton1 was moved.  =/
  MainMenuBarTexture0:ClearAllPoints()
  MainMenuBarTexture1:ClearAllPoints()
  MainMenuBarTexture0:SetPoint( 'Left', MainMenuBar,         'Left', -8, -5 )
  MainMenuBarTexture1:SetPoint( 'Left', MainMenuBarTexture0, 'Right' )

  ActionButton1:ClearAllPoints()
  ActionButton1:SetPoint( 'BottomLeft', MainMenuBarOverlayFrame, 'BottomLeft' )

  do  --  MainMenuExpBar
    MainMenuExpBar:SetWidth( bar_width )
    MainMenuExpBar:SetHeight( bar_height )
    MainMenuExpBar:ClearAllPoints()

    MainMenuBarExpText:SetWidth( bar_width )
    MainMenuBarExpText:SetHeight( bar_height )
    MainMenuBarExpText:ClearAllPoints()

    -- The "zomg I killed a wolf" animation.
    MainMenuExpBar.BarTrailGlow:Hide()
    MainMenuExpBar.SparkBurstMove:Hide()

    -- The 'bubbles'
    for i=1,19 do _G[ 'MainMenuXPBarDiv' .. i ]:Hide() end

    -- The border around the XP bar
    MainMenuXPBarTextureMid:Hide()
    MainMenuXPBarTextureLeftCap:Hide()
    MainMenuXPBarTextureRightCap:Hide()

    -- The rested state
    ExhaustionLevelFillBar:SetTexture( Empty_Art )
    -- Re-shows itself.
    --ExhaustionTick:Hide()
    ExhaustionTickNormal:Hide()
    ExhaustionTickHighlight:Hide()
  end


  do  --  ArtifactWatchBar
    -- If Legion
    if  GetExpansionLevel() > 5
    and UnitLevel( 'player' ) > 99
    then
      can_display_artifact_bar = true
    end

    ArtifactWatchBar:SetWidth( bar_width )
    ArtifactWatchBar:SetHeight( bar_height )
    ArtifactWatchBar:ClearAllPoints()

    ArtifactWatchBar.StatusBar:SetWidth( bar_width )
    -- For reasons unknown, this doesn't stick at max level:
    ArtifactWatchBar.StatusBar:SetHeight( bar_height )
    ArtifactWatchBar.StatusBar:ClearAllPoints()

    ArtifactWatchBar.OverlayFrame:SetWidth( bar_width )
    ArtifactWatchBar.OverlayFrame:SetHeight( bar_height )
    ArtifactWatchBar.OverlayFrame:ClearAllPoints()

    ArtifactWatchBar.OverlayFrame.Text:SetWidth( bar_width )
    ArtifactWatchBar.OverlayFrame.Text:SetHeight( bar_height )
    ArtifactWatchBar.OverlayFrame.Text:ClearAllPoints()

    ArtifactWatchBar.StatusBar.Background:SetHeight( bar_height )
    ArtifactWatchBar.StatusBar.Background:SetWidth( bar_width )
    ArtifactWatchBar.StatusBar.Background:ClearAllPoints()

    ArtifactWatchBar.StatusBar.BarGlow:Hide()
    ArtifactWatchBar.StatusBar.BarTrailGlow:Hide()
    ArtifactWatchBar.StatusBar.SparkBurstMove:Hide()

    ArtifactWatchBar.Tick:SetAlpha( 0 )
    ArtifactWatchBar.Tick:Hide()

    ArtifactWatchBar.StatusBar.WatchBarTexture0:SetTexture( Empty_Art )
    ArtifactWatchBar.StatusBar.WatchBarTexture1:SetTexture( Empty_Art )
    ArtifactWatchBar.StatusBar.WatchBarTexture2:SetTexture( Empty_Art )
    ArtifactWatchBar.StatusBar.WatchBarTexture3:SetTexture( Empty_Art )

    ArtifactWatchBar.StatusBar.WatchBarTexture0:Hide()
    ArtifactWatchBar.StatusBar.WatchBarTexture1:Hide()
    ArtifactWatchBar.StatusBar.WatchBarTexture2:Hide()
    ArtifactWatchBar.StatusBar.WatchBarTexture3:Hide()

    ArtifactWatchBar.StatusBar.XPBarTexture0:SetHeight( bar_height )
    ArtifactWatchBar.StatusBar.XPBarTexture1:SetHeight( bar_height )
    ArtifactWatchBar.StatusBar.XPBarTexture2:SetHeight( bar_height )
    ArtifactWatchBar.StatusBar.XPBarTexture3:SetHeight( bar_height )

    ArtifactWatchBar.StatusBar.XPBarTexture0:SetTexture( Empty_Art )
    ArtifactWatchBar.StatusBar.XPBarTexture1:SetTexture( Empty_Art )
    ArtifactWatchBar.StatusBar.XPBarTexture2:SetTexture( Empty_Art )
    ArtifactWatchBar.StatusBar.XPBarTexture3:SetTexture( Empty_Art )

    ArtifactWatchBar.StatusBar.XPBarTexture0:SetHeight( bar_height )
    ArtifactWatchBar.StatusBar.XPBarTexture1:SetHeight( bar_height )
    ArtifactWatchBar.StatusBar.XPBarTexture2:SetHeight( bar_height )
    ArtifactWatchBar.StatusBar.XPBarTexture3:SetHeight( bar_height )

    ArtifactWatchBar.StatusBar.XPBarTexture0:Hide()
    ArtifactWatchBar.StatusBar.XPBarTexture1:Hide()
    ArtifactWatchBar.StatusBar.XPBarTexture2:Hide()
    ArtifactWatchBar.StatusBar.XPBarTexture3:Hide()
  end


  do  --  HonorWatchBar
    HonorWatchBar:SetWidth( bar_width )
    HonorWatchBar:SetHeight( bar_height )
    HonorWatchBar:ClearAllPoints()

    HonorWatchBar.StatusBar:SetWidth( bar_width )
    HonorWatchBar.StatusBar:SetHeight( bar_height )
    HonorWatchBar.StatusBar:ClearAllPoints()

    HonorWatchBar.StatusBar.Background:SetWidth( bar_width )
    HonorWatchBar.StatusBar.Background:SetHeight( bar_height )
    HonorWatchBar.StatusBar.Background:ClearAllPoints()
  end


  do  --  ReputationWatchBar
    ReputationWatchBar:SetWidth( bar_width )
    ReputationWatchBar:SetHeight( bar_height )
    ReputationWatchBar:ClearAllPoints()

    ReputationWatchBar.StatusBar:SetWidth( bar_width )
    ReputationWatchBar.StatusBar:SetHeight( bar_height )
    ReputationWatchBar.StatusBar:ClearAllPoints()

    ReputationWatchBar.StatusBar.BarGlow:SetHeight( bar_height )
    ReputationWatchBar.StatusBar.BarGlow:ClearAllPoints()

    ReputationWatchBar.OverlayFrame:SetHeight( bar_height )
    ReputationWatchBar.OverlayFrame:ClearAllPoints()

    ReputationWatchBar.OverlayFrame.Text:SetHeight( bar_height )
    ReputationWatchBar.OverlayFrame.Text:ClearAllPoints()

    ReputationWatchBar.StatusBar.WatchBarTexture0:SetTexture( Empty_Art )
    ReputationWatchBar.StatusBar.WatchBarTexture1:SetTexture( Empty_Art )
    ReputationWatchBar.StatusBar.WatchBarTexture2:SetTexture( Empty_Art )
    ReputationWatchBar.StatusBar.WatchBarTexture3:SetTexture( Empty_Art )

    ReputationWatchBar.StatusBar.WatchBarTexture0:SetAlpha( 0 )
    ReputationWatchBar.StatusBar.WatchBarTexture1:SetAlpha( 0 )
    ReputationWatchBar.StatusBar.WatchBarTexture2:SetAlpha( 0 )
    ReputationWatchBar.StatusBar.WatchBarTexture3:SetAlpha( 0 )
  end



  -- Hide the fiddly bits on the main bar
  MainMenuBarPageNumber:Hide()
  ActionBarUpButton:Hide()
  ActionBarDownButton:Hide()

  MultiBarBottomRight:ClearAllPoints()
  PetActionButton1:ClearAllPoints()
  MainMenuBarVehicleLeaveButton:ClearAllPoints()
  StanceButton1:ClearAllPoints()

  -- Hide the background behind the stance bar
  StanceBarLeft:Hide()
  StanceBarRight:Hide()
  -- Hide the border around buttons
  for i=1,10 do
    _G[ 'StanceButton' .. i .. 'NormalTexture2' ]:Hide()
  end

  -- Gryphons
  MainMenuBarLeftEndCap:ClearAllPoints()
  MainMenuBarRightEndCap:ClearAllPoints()
  MainMenuBarLeftEndCap:SetPoint( 'BottomRight', ActionButton1,  'BottomLeft', -4, 0 )
  MainMenuBarRightEndCap:SetPoint( 'BottomLeft', ActionButton12, 'BottomRight', 4, 0 )


----------------------------------------------------------------------


  MainMenuBarMaxLevelBar:SetAlpha( 0 )
  MainMenuBarMaxLevelBar:Hide()


  MainMenuBar:SetWidth( bar_width )
  -- Scaling for everything.  Somehow.
  MainMenuBar:SetScale( TidyBar_options.scale )

  MainMenuBar:ClearAllPoints()
  MainMenuBar:SetPoint( 'BottomLeft', WorldFrame, 'BottomLeft', TidyBar_options.main_area_positioning, 0 )

  local function show_macro_text( alpha )
    local bars={
      'MultiBarBottomLeft',
      'MultiBarBottomRight',
      'Action',
      'MultiBarLeft',
      'MultiBarRight',
    }
    for button=1, #bars do
      for i=1,12 do
        _G[ bars[ button ] .. 'Button' .. i .. 'Name' ]:Hide()
      end
    end
  end
  if TidyBar_options.show_macro_text then
    show_macro_text( 1 )
  else
    show_macro_text( 0 )
  end


  if TidyBar_options.show_gryphons then
    MainMenuBarLeftEndCap:Show()
    MainMenuBarRightEndCap:Show()
  else
    MainMenuBarLeftEndCap:Hide()
    MainMenuBarRightEndCap:Hide()
  end


  if TidyBar_options.show_MainMenuBar_textured_background then
    MainMenuBarTexture0:Show()
    MainMenuBarTexture1:Show()
  else
    MainMenuBarTexture0:Hide()
    MainMenuBarTexture1:Hide()
  end


  local anchor = ActionButton1
  local the_first_bar = true
  local space_between_bottom_bar_and_buttons = 6


  if      TidyBar_options.show_experience_bar
  and     UnitXP( 'player' ) > 0
  and not IsXPUserDisabled()
  and not TidyBar_character_is_max_level
  then
    if the_first_bar then
      bar_spacing = space_between_bottom_bar_and_buttons
    else
      bar_spacing = 0
    end

    MainMenuExpBar:Show()
    MainMenuBarExpText:Show()

    MainMenuExpBar:SetPoint(          'BottomLeft', anchor, 'TopLeft', 0, bar_spacing )
    MainMenuBarExpText:SetPoint(      'BottomLeft', anchor, 'TopLeft', 0, bar_spacing )
    MainMenuXPBarTextureMid:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, bar_spacing )

    the_first_bar = false
    anchor = MainMenuExpBar
  else
    MainMenuExpBar:Hide()
    MainMenuBarExpText:Hide()
  end


  if  TidyBar_options.show_artifact_power_bar
  and can_display_artifact_bar
  then
    if the_first_bar then
      bar_spacing = space_between_bottom_bar_and_buttons
    else
      bar_spacing = 0
    end

    ArtifactWatchBar:Show()
    ArtifactWatchBar:SetPoint(                      'BottomLeft', anchor, 'TopLeft', 0, bar_spacing )
    ArtifactWatchBar.StatusBar:SetPoint(            'BottomLeft', anchor, 'TopLeft', 0, bar_spacing )
    ArtifactWatchBar.StatusBar.Overlay:SetPoint(    'BottomLeft', anchor, 'TopLeft', 0, bar_spacing )
    ArtifactWatchBar.OverlayFrame:SetPoint(         'BottomLeft', anchor, 'TopLeft', 0, bar_spacing )
    ArtifactWatchBar.OverlayFrame.Text:SetPoint(    'BottomLeft', anchor, 'TopLeft', 0, bar_spacing )
    ArtifactWatchBar.StatusBar.Background:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, bar_spacing )

    -- The colour underneath the ArtifactWatchBar
    ArtifactWatchBar.StatusBar.Underlay:Hide()

    if TidyBar_character_is_max_level then
      -- For reasons unknown, this doesn't stick at max level:
      ArtifactWatchBar.StatusBar:SetHeight( bar_height )
      ArtifactWatchBar.StatusBar.WatchBarTexture2:SetTexture( Empty_Art )
      ArtifactWatchBar.StatusBar.WatchBarTexture3:SetTexture( Empty_Art )
      ArtifactWatchBar.StatusBar.WatchBarTexture2:Hide()
      ArtifactWatchBar.StatusBar.WatchBarTexture3:Hide()
      ArtifactWatchBar.StatusBar.XPBarTexture2:Hide()
      ArtifactWatchBar.StatusBar.XPBarTexture3:Hide()
    end

    the_first_bar = false
    anchor = ArtifactWatchBar.StatusBar
  else
    ArtifactWatchBar:Hide()
  end


  if  TidyBar_options.show_honor_bar
  and HonorWatchBar:IsShown() 
  then
    if the_first_bar then
      bar_spacing = space_between_bottom_bar_and_buttons
    else
      bar_spacing = 0
    end

    HonorWatchBar:Show()
    HonorWatchBar:SetPoint(                      'BottomLeft', anchor, 'TopLeft', 0, bar_spacing )
    HonorWatchBar.StatusBar:SetPoint(            'BottomLeft', anchor, 'TopLeft', 0, bar_spacing )
    HonorWatchBar.StatusBar.Background:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, bar_spacing )
    HonorWatchBar.OverlayFrame:SetPoint(         'BottomLeft', anchor, 'TopLeft', 0, bar_spacing )

    -- This may not be a thing
    HonorWatchBar.StatusBar.BarGlow:SetHeight( bar_height )
    HonorWatchBar.StatusBar.BarGlow:ClearAllPoints()

    HonorWatchBar.OverlayFrame:SetHeight( bar_height )
    HonorWatchBar.OverlayFrame:ClearAllPoints()

    HonorWatchBar.OverlayFrame.Text:SetHeight( bar_height )
    HonorWatchBar.OverlayFrame.Text:ClearAllPoints()

    HonorWatchBar.StatusBar.WatchBarTexture0:SetTexture( Empty_Art )
    HonorWatchBar.StatusBar.WatchBarTexture1:SetTexture( Empty_Art )
    HonorWatchBar.StatusBar.WatchBarTexture2:SetTexture( Empty_Art )
    HonorWatchBar.StatusBar.WatchBarTexture3:SetTexture( Empty_Art )

    HonorWatchBar.StatusBar.WatchBarTexture0:Hide()
    HonorWatchBar.StatusBar.WatchBarTexture1:Hide()
    HonorWatchBar.StatusBar.WatchBarTexture2:Hide()
    HonorWatchBar.StatusBar.WatchBarTexture3:Hide()

    the_first_bar = false
    anchor = ArtifactWatchBar.StatusBar
  else
    HonorWatchBar:Hide()
  end


  if ReputationWatchBar:IsShown() then
    if the_first_bar then
      bar_spacing = space_between_bottom_bar_and_buttons
    else
      bar_spacing = 0
    end

    ReputationWatchBar.StatusBar:SetHeight( bar_height )

    if TidyBar_options.show_experience_bar then
      ReputationWatchBar_bar_spacing = 0
    else
      ReputationWatchBar_bar_spacing = bar_spacing
    end
    if can_display_artifact_bar then
      ReputationWatchBar:SetPoint( 'BottomLeft', ArtifactWatchBar, 'TopLeft', 0, ReputationWatchBar_bar_spacing )
    else
      ReputationWatchBar:SetPoint( 'BottomLeft', anchor,           'TopLeft', 0, ReputationWatchBar_bar_spacing )
    end
    ReputationWatchBar.StatusBar:SetPoint(         'Top', ReputationWatchBar )
    ReputationWatchBar.StatusBar.BarGlow:SetPoint( 'Top', ReputationWatchBar )
    ReputationWatchBar.OverlayFrame:SetPoint(      'Top', ReputationWatchBar )
    ReputationWatchBar.OverlayFrame.Text:SetPoint( 'Top', ReputationWatchBar )

    ReputationWatchBar.StatusBar.WatchBarTexture0:Hide()
    ReputationWatchBar.StatusBar.WatchBarTexture1:Hide()

-- FIXME
    ReputationWatchBar.StatusBar.WatchBarTexture2:Hide()
    ReputationWatchBar.StatusBar.WatchBarTexture3:Hide()

    the_first_bar = false
    anchor = ReputationWatchBar
  end


  if MultiBarBottomLeft:IsShown() then
    MultiBarBottomLeft:ClearAllPoints()
    MultiBarBottomLeft:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, TidyBar_options.bar_spacing )
    anchor = MultiBarBottomLeft
  end


  if MultiBarBottomRight:IsShown() then
    MultiBarBottomRight:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, TidyBar_options.bar_spacing )
    anchor = MultiBarBottomRight
  end


  if StanceBarFrame:IsShown() then
    StanceButton1:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, TidyBar_options.bar_spacing )
    anchor = StanceButton1
  end


  if PetActionBarFrame:IsShown() then
    PetActionButton1:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, TidyBar_options.bar_spacing )
    anchor = PetActionButton1
  end


  if MainMenuBarVehicleLeaveButton:IsShown() then
    MainMenuBarVehicleLeaveButton:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, TidyBar_options.bar_spacing )
    anchor = MainMenuBarVehicleLeaveButton
  end
end



local function TidyBar_refresh_vehicle()
  if TidyBar_options.debug then
    print( GetTime() .. ' TidyBar_refresh_vehicle()' )
  end
   if not UnitHasVehicleUI( 'player' ) then return nil end
  -- This works, but it's useless if I can't reposition them.
  --LFDMicroButton:ClearAllPoints()
  --LFDMicroButton:SetPoint( 'TopRight', GuildMicroButton, 'TopLeft' )

  -- Repositioning these here is a bad idea.
  -- I don't know how to store/retrieve their positions so that things are back to normal when exiting the vehicle UI.
  --MainMenuMicroButton:ClearAllPoints()
  --MainMenuMicroButton:SetPoint( 'BottomRight', TidyBar_corner, 'BottomRight' )

  OverrideActionBar:SetWidth( bar_width )

  OverrideActionBarButton1:ClearAllPoints()
  OverrideActionBarButton1:SetPoint( 'BottomLeft', OverrideActionBar, 'BottomLeft' )

  OverrideActionBarHealthBar:ClearAllPoints()
  OverrideActionBarHealthBar:SetPoint( 'BottomRight', OverrideActionBarPowerBar, 'BottomLeft', -4, 0 )

  OverrideActionBarPowerBar:ClearAllPoints()
  OverrideActionBarPowerBar:SetPoint( 'BottomRight', OverrideActionBarButton1, 'BottomLeft', -4, 0 )

  OverrideActionBarExpBar:ClearAllPoints()
  OverrideActionBarExpBar:SetHeight( bar_height )
  OverrideActionBarExpBar:SetWidth( bar_width )
  OverrideActionBarExpBar:SetPoint( 'BottomLeft', OverrideActionBarButton1, 'TopLeft', 0, 4  )
  --OverrideActionBarExpBarOverlayFrame:ClearAllPoints()
  --OverrideActionBarExpBarOverlayFrame:SetPoint( 'Top', OverrideActionBarExpBar )

  OverrideActionBarLeaveFrameLeaveButton:ClearAllPoints()
  OverrideActionBarLeaveFrameLeaveButton:SetPoint( 'BottomRight', OverrideActionBar, 'BottomRight' )

end



local function TidyBar_refresh_corner()
  if TidyBar_options.debug then
    print( GetTime() .. ' TidyBar_refresh_corner()' )
  end
  TidyBar_corner:SetFrameStrata( 'LOW' )
  TidyBar_corner:SetWidth( 300 )
  TidyBar_corner:SetHeight( 128 )
  TidyBar_corner:SetPoint( 'BottomRight' )
  TidyBar_corner:SetScale( TidyBar_options.scale )

  --TidyBar_corner.Texture = TidyBar_corner:CreateTexture( nil, 'BACKGROUND' )
  --TidyBar_corner.Texture:SetTexture( Corner_Artwork_Texture )
  --TidyBar_corner.Texture:SetPoint( 'BottomRight' )
  --TidyBar_corner.Texture:SetWidth(  512 * 1.09 )
  --TidyBar_corner.Texture:SetHeight( 128 * 1.09 )

  TidyBar_corner.MicroButtons   = CreateFrame( 'Frame', nil, TidyBar_corner )
  TidyBar_corner.BagButtonFrame = CreateFrame( 'Frame', nil, TidyBar_corner )

  -- Required in order to move the frames around
  UIPARENT_MANAGED_FRAME_POSITIONS[ 'MultiBarBottomRight' ]     = nil
  UIPARENT_MANAGED_FRAME_POSITIONS[ 'PetActionBarFrame' ]       = nil
  UIPARENT_MANAGED_FRAME_POSITIONS[ 'ShapeshiftBarFrame' ]      = nil

  -- Set Pet Bars
  PetActionBarFrame:SetAttribute( 'unit', 'pet' )
  RegisterUnitWatch( PetActionBarFrame )
  
  -- Set Mouseovers
  TidyBar_setup_side()
  TidyBar_refresh_side()
  ConfigureCornerBars()
  TidyBar_corner:SetAlpha( 0 )
end



function TidyBar_RefreshPositions()
  if TidyBar_options.debug then
    print( GetTime() .. ' TidyBar_RefreshPositions()' )
  end
  if InCombatLockdown() then
    if TidyBar_options.debug then
      print( 'TidyBar:  In combat, skipping.' )
    end
    return
  end
  TidyBar_refresh_main_area()
  ConfigureCornerBars()
  TidyBar_setup_side()
  TidyBar_refresh_vehicle()
  --TidyBar_refresh_corner()
end



local function TidyBar_setup()
  if TidyBar_options.debug then
    print( 'TidyBar version ' .. tostring( GetAddOnMetadata( 'TidyBar', 'Version' ) ) .. ' loaded.  Debugging mode enabled.' )
  end
  if TidyBar_options.debug then
    print( GetTime() .. ' TidyBar_setup()' )
  end
  if UnitLevel( 'player' ) == MAX_PLAYER_LEVEL_TABLE[ GetExpansionLevel() ] then
    local comparison = UnitLevel( 'player' ) .. '/' .. MAX_PLAYER_LEVEL_TABLE[ GetExpansionLevel() ]
    if TidyBar_options.debug then
      print( 'TidyBar:  Character level ' .. comparison .. ' (max)' )
    end
    TidyBar_character_is_max_level = true
  else
  print 'TidyBar:  Character is not max level'
    if not TidyBar_options.debug then
      print( 'TidyBar:  Character is level ' .. comparison )
    end
    TidyBar_character_is_max_level = false
  end


  TidyBar_refresh_corner()
  TidyBar_setup_corner()
  TidyBar_setup_side()
  TidyBar_setup_options_pane()
  TidyBar_setup_vehicle()
  TidyBar_setup_main_area()



  -- Removes the jumpiness when un-checking a reputation's "Show as Experience Bar", but reverses what the checkbox means.
  --ReputationWatchBar:SetScript( 'OnEvent', TidyBar_refresh_main_area )
  -- .. whereas this is just a big mess:
  --ReputationWatchBar:HookScript( 'OnEvent', TidyBar_refresh_main_area )



  ---- Testing
  --MainMenuBar:HookScript( 'OnEvent', TidyBar_refresh_main_area )
  --MainMenuBar:HookScript( 'OnEvent', function()
    --local point, relativeTo, relativePoint, xOfs, yOfs = MainMenuBar:GetPoint()
    --DEFAULT_CHAT_FRAME:AddMessage(point)
    --DEFAULT_CHAT_FRAME:AddMessage(relativeTo:GetName())
    --DEFAULT_CHAT_FRAME:AddMessage(relativePoint)
    --DEFAULT_CHAT_FRAME:AddMessage(xOfs)
    --DEFAULT_CHAT_FRAME:AddMessage(yOfs)
    ----if not xOfs == TidyBar_options.main_area_positioning then
      ----TidyBar_refresh_main_area()
    ----end
  --end end )

    --local point, relativeTo, relativePoint, xOfs, yOfs = MainMenuBar:GetPoint()
    --DEFAULT_CHAT_FRAME:AddMessage(point)
    --DEFAULT_CHAT_FRAME:AddMessage(relativeTo:GetName())
    --DEFAULT_CHAT_FRAME:AddMessage(relativePoint)
    --DEFAULT_CHAT_FRAME:AddMessage(xOfs)
    --DEFAULT_CHAT_FRAME:AddMessage(yOfs)

  --MainMenuBar:SetPoint( 'BottomLeft', WorldFrame, 'BottomLeft', TidyBar_options.main_area_positioning, 0 )

  -- Call Update Function when the default UI makes changes
  -- FIXME - Isn't this a terrible, terrible, idea?
  hooksecurefunc( 'UIParent_ManageFramePositions', TidyBar_RefreshPositions )







  -- Start Tidy Bar
  TidyBar:SetScript( 'OnEvent', EventHandler )
  TidyBar:SetFrameStrata( 'TOOLTIP' )
  TidyBar:Show()

  SLASH_TIDYBAR1 = '/tidybar'
  SlashCmdList[ 'TIDYBAR' ] = TidyBar_RefreshPositions
end
TidyBar:RegisterEvent( 'PLAYER_LOGIN' )
TidyBar:SetScript( 'OnEvent', TidyBar_setup )
