do  --  Defaults
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
  TidyBar_options.bar_height = 8
end


local can_display_artifact_bar = nil
local bar_width  = 500


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
local Empty_Art              = 'Interface/Addons/TidyBar/empty'






local function TidyBar_refresh_side( mouse_inside )
  if TidyBar_options.debug then
    print( GetTime() .. ' TidyBar_refresh_side() ' .. tostring( mouse_inside ) .. ' ' .. tostring( TidyBar_options.always_show_side ) .. ' ' .. tostring( SpellFlyout:IsShown() ) )
    -- Oh god, all the verbosities:
    --print( GetTime() .. ' TidyBar_refresh_side()' )
    --print( '  mouse_inside  -  '                     .. tostring( mouse_inside ) )
    --print( '  TidyBar_options.always_show_side  -  ' .. tostring( TidyBar_options.always_show_side ) )
    --print( '  SpellFlyout:IsShown()  -  '            .. tostring( SpellFlyout:IsShown() ) )
  end
  local Alpha = 0
  if    mouse_inside
    or  TidyBar_options.always_show_side
        -- Some spells have an arrow, and clicking on them reveals a list of spells.  This is a "flyout".
        --   .. examples include Shaman Hex Variants and various Mage teleports and portals.
    or  SpellFlyout:IsShown()
  then
    Alpha = 1
  end
  for i = 1, 12 do
    _G[ 'MultiBarRightButton' .. i ]:SetAlpha( Alpha )
    _G[ 'MultiBarLeftButton'  .. i ]:SetAlpha( Alpha )
  end
end

-- FIXME - this is fired every time I mount!
local function TidyBar_SetScript_frame_side( frameTarget )
  -- Spammy
  if TidyBar_options.debug then
    print( GetTime() .. ' TidyBar_SetScript_frame_side( ' .. tostring( frameTarget ) .. ' )' )
  end
  frameTarget:SetScript( 'OnEnter', function() TidyBar_refresh_side( true ) end )
  frameTarget:SetScript( 'OnLeave', function() TidyBar_refresh_side( false ) end )
end

local function TidyBar_setup_side()
  if TidyBar_options.debug then
    print( GetTime() .. ' TidyBar_setup_side()' )
  end

  if MultiBarRight:IsShown() then
    MultiBarRight:ClearAllPoints()
    MultiBarRight:SetPoint( 'TopRight', MinimapCluster, 'BottomRight', 0, -10 )
    TidyBar_frame_side:Show()
    MultiBarRight:EnableMouse()
    TidyBar_frame_side:SetPoint( 'BottomRight', MultiBarRight, 'BottomRight' )
    -- Right Bar 2
    -- Note that if MultiBarRight is not enabled, MultiBarLeft cannot be enabled.
    if MultiBarLeft:IsShown() then
      MultiBarLeft:ClearAllPoints()
      MultiBarLeft:SetPoint( 'TopRight', MultiBarRight, 'TopLeft' )
      MultiBarLeft:EnableMouse()
      TidyBar_frame_side:SetPoint( 'TopLeft', MultiBarLeft,  'TopLeft' )
    else
      TidyBar_frame_side:SetPoint( 'TopLeft', MultiBarRight, 'TopLeft' )
    end
  else
    TidyBar_frame_side:Hide()
  end

  if TidyBar_frame_side:IsShown() then
    -- Doing this somehow reduces the height of the objective tracker, showing only a few items:
    --_G[ 'ObjectiveTrackerFrame' ]:ClearAllPoints()
    -- Yes, this shifts the objectives tracker over, leaving space on the right.  I am not happy about this.
    --   However, this is what is needed, because the user needs to click the right of the tracker for any quest-actions.  Hovering the mouse over those items would then shift the objectives tracker, making it impossible to click them!
    _G[ 'ObjectiveTrackerFrame' ]:SetPoint( 'TopRight', TidyBar_frame_side, 'TopLeft' )
  else
    _G[ 'ObjectiveTrackerFrame' ]:SetPoint( 'TopRight', MinimapCluster, 'BottomRight', 0, -10 )
  end

  TidyBar_frame_side:EnableMouse()
  TidyBar_frame_side:SetScript( 'OnEnter', function() TidyBar_refresh_side( true )  end )
  TidyBar_frame_side:SetScript( 'OnLeave', function() TidyBar_refresh_side( false ) end )
  TidyBar_SetScript_frame_side( MultiBarRight )
  TidyBar_SetScript_frame_side( MultiBarLeft )
  for i = 1, 12 do TidyBar_SetScript_frame_side( _G[ 'MultiBarRightButton' .. i ] ) end
  for i = 1, 12 do TidyBar_SetScript_frame_side( _G[ 'MultiBarLeftButton'  .. i ] ) end
end






local function TidyBar_refresh_corner()
  if TidyBar_options.debug then
    print( GetTime() .. ' TidyBar_refresh_corner()' )
  end
  TidyBar_frame_corner:SetFrameStrata( 'LOW' )
  TidyBar_frame_corner:SetWidth( 300 )
  TidyBar_frame_corner:SetHeight( 128 )
  TidyBar_frame_corner:SetPoint( 'BottomRight' )
  TidyBar_frame_corner:SetScale( TidyBar_options.scale )

  -- Required in order to move the frames around
  UIPARENT_MANAGED_FRAME_POSITIONS[ 'MultiBarBottomRight' ]     = nil
  UIPARENT_MANAGED_FRAME_POSITIONS[ 'PetActionBarFrame' ]       = nil
  UIPARENT_MANAGED_FRAME_POSITIONS[ 'ShapeshiftBarFrame' ]      = nil

  -- Set Pet Bars
  PetActionBarFrame:SetAttribute( 'unit', 'pet' )
  RegisterUnitWatch( PetActionBarFrame )
  
  TidyBar_frame_corner:SetAlpha( 0 )

  MainMenuBarTexture2:SetTexture( Empty_Art )
  MainMenuBarTexture3:SetTexture( Empty_Art )
  MainMenuBarTexture2:Hide()
  MainMenuBarTexture3:Hide()

  -- The nagging talent popup
  TalentMicroButtonAlert:SetAlpha( 0 )
  TalentMicroButtonAlert:Hide()

  if not UnitHasVehicleUI( 'player' ) then
    CharacterMicroButton:ClearAllPoints()
    CharacterMicroButton:SetPoint( 'BottomRight', TidyBar_frame_corner.MicroButtons, 'BottomRight', -270, 0 )
    for i, name in pairs( MenuButtonFrames ) do
      name:SetParent( TidyBar_frame_corner.MicroButtons )
    end
  end
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
    name:SetParent( TidyBar_frame_corner.BagButtonFrame )
  end
  
  MainMenuBarBackpackButton:ClearAllPoints()
  MainMenuBarBackpackButton:SetPoint( 'Bottom' )
  MainMenuBarBackpackButton:SetPoint( 'Right', -60, 0 )

  local function TidyBar_SetScript_frame_corner( frameTarget )
    if TidyBar_options.debug then
      print( GetTime() .. ' TidyBar_SetScript_frame_microbuttons( ' .. tostring( frameTarget ) .. ' )'  )
    end
    frameTarget:HookScript( 'OnEnter', function() if not UnitHasVehicleUI( 'player' ) then TidyBar_frame_corner:SetAlpha( 1 ) end end )
    frameTarget:HookScript( 'OnLeave', function()                                          TidyBar_frame_corner:SetAlpha( 0 ) end )
  end
  
  -- Setup the Corner Buttons
  for i, name in pairs( BagButtonFrameList ) do TidyBar_SetScript_frame_corner( name ) end
  for i, name in pairs( MenuButtonFrames   ) do TidyBar_SetScript_frame_corner( name ) end
  
  -- Setup the Corner Menu Artwork
  TidyBar_frame_corner:SetScale( TidyBar_options.scale )
  TidyBar_frame_corner.MicroButtons:SetAllPoints( TidyBar_frame_corner )
  TidyBar_frame_corner.BagButtonFrame:SetPoint( 'TopRight', 2, -18 )
  TidyBar_frame_corner.BagButtonFrame:SetHeight( 64 )
  TidyBar_frame_corner.BagButtonFrame:SetWidth( 256 )
  TidyBar_frame_corner.BagButtonFrame:SetScale( 1.02 )
  
  -- Setup the Corner Menu Mouseover frame
  TidyBar_frame_corner:SetPoint( 'BottomRight', WORLDFRAME, 'BottomRight' )
  TidyBar_frame_corner:SetScript( 'OnEnter', function() TidyBar_frame_corner:SetAlpha( 1 ) end )
  TidyBar_frame_corner:SetScript( 'OnLeave', function() TidyBar_frame_corner:SetAlpha( 0 ) end )
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
  --MainMenuMicroButton:SetPoint( 'BottomRight', TidyBar_frame_corner, 'BottomRight' )

  OverrideActionBar:SetWidth( bar_width )

  OverrideActionBarButton1:ClearAllPoints()
  OverrideActionBarButton1:SetPoint( 'BottomLeft', OverrideActionBar, 'BottomLeft' )

  OverrideActionBarHealthBar:ClearAllPoints()
  OverrideActionBarPowerBar:ClearAllPoints()
  OverrideActionBarHealthBar:SetPoint( 'BottomRight', OverrideActionBar, 'BottomLeft' )
  OverrideActionBarPowerBar:SetPoint( 'BottomRight', OverrideActionBarHealthBar, 'BottomLeft' )
  OverrideActionBarHealthBarText:SetWidth( 0.001 )
  OverrideActionBarPowerBarText:SetWidth( 0.001 )
  -- It just re-shows on mouseout.
  --OverrideActionBarHealthBarText:Hide()
  OverrideActionBarHealthBar:SetWidth( 8 )
  OverrideActionBarPowerBar:SetWidth( 8 )
  OverrideActionBarHealthBarOverlay:SetWidth( 8 )
  OverrideActionBarPowerBarOverlay:SetWidth( 8 )
  OverrideActionBarHealthBarBackground:Hide()
  OverrideActionBarPowerBarBackground:Hide()

  OverrideActionBarExpBar:ClearAllPoints()
  OverrideActionBarExpBar:SetHeight( TidyBar_options.bar_height )
  OverrideActionBarExpBar:SetWidth( bar_width )
  OverrideActionBarExpBar:SetPoint( 'BottomLeft', OverrideActionBarButton1, 'TopLeft', 0, 4  )
  --OverrideActionBarExpBarOverlayFrame:ClearAllPoints()
  --OverrideActionBarExpBarOverlayFrame:SetPoint( 'Top', OverrideActionBarExpBar )

  OverrideActionBarLeaveFrameLeaveButton:ClearAllPoints()
  OverrideActionBarLeaveFrameLeaveButton:SetPoint( 'BottomRight', OverrideActionBar, 'BottomRight' )
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
    MainMenuExpBar:SetHeight( TidyBar_options.bar_height )
    MainMenuExpBar:ClearAllPoints()

    MainMenuBarExpText:SetWidth( bar_width )
    MainMenuBarExpText:SetHeight( TidyBar_options.bar_height )
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
    ArtifactWatchBar:SetHeight( TidyBar_options.bar_height )
    ArtifactWatchBar:ClearAllPoints()

    ArtifactWatchBar.StatusBar:ClearAllPoints()
    ArtifactWatchBar.StatusBar:SetWidth( bar_width )
    -- For reasons unknown, this doesn't stick at max level:
    ArtifactWatchBar.StatusBar:SetHeight( TidyBar_options.bar_height )
    --do  --  experimentation
    ---- This doesn't seem to do anything, but I'm leaving it in for testing
    ----ArtifactWatchBar.StatusBar:HookScript( 'OnEvent', function() ArtifactWatchBar.StatusBar:SetHeight( TidyBar_options.bar_height ) end )
    ---- Attempting to force some other things..
    ----ArtifactWatchBar.StatusBar.BarGain:HookScript( 'OnEvent', function() ArtifactWatchBar.StatusBar.BarGain:SetHeight( TidyBar_options.bar_height ) end )
    ----ArtifactWatchBar.StatusBar.Overlay:HookScript( 'OnEvent', function() ArtifactWatchBar.StatusBar.Overlay:SetHeight( TidyBar_options.bar_height ) end )

    --ArtifactWatchBar.StatusBar.BarGain:SetHeight( TidyBar_options.bar_height )
    --ArtifactWatchBar.StatusBar.BarTexture:SetHeight( TidyBar_options.bar_height )
    --ArtifactWatchBar.StatusBar.Overlay:SetHeight( TidyBar_options.bar_height )
    --ArtifactWatchBar.StatusBar.Underlay:SetHeight( TidyBar_options.bar_height )

    --ArtifactWatchBar.StatusBar.BarTexture:SetTexture( Empty_Art )
    --end




    ArtifactWatchBar.OverlayFrame:SetWidth( bar_width )
    ArtifactWatchBar.OverlayFrame:SetHeight( TidyBar_options.bar_height )
    ArtifactWatchBar.OverlayFrame:ClearAllPoints()

    ArtifactWatchBar.OverlayFrame.Text:SetWidth( bar_width )
    ArtifactWatchBar.OverlayFrame.Text:SetHeight( TidyBar_options.bar_height )
    ArtifactWatchBar.OverlayFrame.Text:ClearAllPoints()

    ArtifactWatchBar.StatusBar.Background:SetHeight( TidyBar_options.bar_height )
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

    ArtifactWatchBar.StatusBar.XPBarTexture0:SetHeight( TidyBar_options.bar_height )
    ArtifactWatchBar.StatusBar.XPBarTexture1:SetHeight( TidyBar_options.bar_height )
    ArtifactWatchBar.StatusBar.XPBarTexture2:SetHeight( TidyBar_options.bar_height )
    ArtifactWatchBar.StatusBar.XPBarTexture3:SetHeight( TidyBar_options.bar_height )

    ArtifactWatchBar.StatusBar.XPBarTexture0:SetTexture( Empty_Art )
    ArtifactWatchBar.StatusBar.XPBarTexture1:SetTexture( Empty_Art )
    ArtifactWatchBar.StatusBar.XPBarTexture2:SetTexture( Empty_Art )
    ArtifactWatchBar.StatusBar.XPBarTexture3:SetTexture( Empty_Art )

    ArtifactWatchBar.StatusBar.XPBarTexture0:SetHeight( 0.001 )
    ArtifactWatchBar.StatusBar.XPBarTexture1:SetHeight( 0.001 )
    ArtifactWatchBar.StatusBar.XPBarTexture2:SetHeight( 0.001 )
    ArtifactWatchBar.StatusBar.XPBarTexture3:SetHeight( 0.001 )

    ArtifactWatchBar.StatusBar.XPBarTexture0:Hide()
    ArtifactWatchBar.StatusBar.XPBarTexture1:Hide()
    ArtifactWatchBar.StatusBar.XPBarTexture2:Hide()
    ArtifactWatchBar.StatusBar.XPBarTexture3:Hide()
  end


  do  --  HonorWatchBar
    HonorWatchBar:SetWidth( bar_width )
    HonorWatchBar:SetHeight( TidyBar_options.bar_height )
    HonorWatchBar:ClearAllPoints()

    HonorWatchBar.StatusBar:SetWidth( bar_width )
    HonorWatchBar.StatusBar:SetHeight( TidyBar_options.bar_height )
    HonorWatchBar.StatusBar:ClearAllPoints()

    HonorWatchBar.StatusBar.Background:SetWidth( bar_width )
    HonorWatchBar.StatusBar.Background:SetHeight( TidyBar_options.bar_height )
    HonorWatchBar.StatusBar.Background:ClearAllPoints()
  end


  do  --  ReputationWatchBar
    ReputationWatchBar:ClearAllPoints()

    ReputationWatchBar:SetWidth( bar_width )
    --ReputationWatchBar:SetHeight( TidyBar_options.bar_height )

    ReputationWatchBar.StatusBar:SetWidth( bar_width )
    ReputationWatchBar.StatusBar:SetHeight( TidyBar_options.bar_height )
    ReputationWatchBar.StatusBar:ClearAllPoints()

    ReputationWatchBar.StatusBar.BarGlow:SetHeight( TidyBar_options.bar_height )
    ReputationWatchBar.StatusBar.BarGlow:ClearAllPoints()

    ReputationWatchBar.OverlayFrame:SetHeight( TidyBar_options.bar_height )
    ReputationWatchBar.OverlayFrame:ClearAllPoints()

    ReputationWatchBar.OverlayFrame.Text:SetHeight( TidyBar_options.bar_height )
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

  do  --  TidyBar_options.show_macro_text
    local bars={
      'MultiBarBottomLeft',
      'MultiBarBottomRight',
      'Action',
      'MultiBarLeft',
      'MultiBarRight',
    }
    for button=1, #bars do
      for i=1,12 do
        if TidyBar_options.show_macro_text then
          _G[ bars[ button ] .. 'Button' .. i .. 'Name' ]:Show()
        else
          _G[ bars[ button ] .. 'Button' .. i .. 'Name' ]:Hide()
        end
      end
    end
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
      ArtifactWatchBar.StatusBar:SetHeight( TidyBar_options.bar_height )
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
    HonorWatchBar.StatusBar.BarGlow:SetHeight( TidyBar_options.bar_height )
    HonorWatchBar.StatusBar.BarGlow:ClearAllPoints()

    HonorWatchBar.OverlayFrame:SetHeight( TidyBar_options.bar_height )
    HonorWatchBar.OverlayFrame:ClearAllPoints()

    HonorWatchBar.OverlayFrame.Text:SetHeight( TidyBar_options.bar_height )
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

    ReputationWatchBar.StatusBar:SetHeight( TidyBar_options.bar_height )

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
    ReputationWatchBar.StatusBar:SetPoint(         'BottomLeft', ReputationWatchBar, 'BottomLeft' )
    ReputationWatchBar.StatusBar.BarGlow:SetPoint( 'BottomLeft', ReputationWatchBar, 'BottomLeft' )
    ReputationWatchBar.OverlayFrame:SetPoint(      'BottomLeft', ReputationWatchBar, 'BottomLeft' )
    ReputationWatchBar.OverlayFrame.Text:SetPoint( 'BottomLeft', ReputationWatchBar, 'BottomLeft' )

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

local function TidyBar_setup_main_area()
  if TidyBar_options.debug then
    print( GetTime() .. ' TidyBar_setup_main_area()' )
  end

  -- Fixes #54 reputation bar jumping.
  if TidyBar_character_is_max_level then
    ReputationWatchBar:HookScript( 'OnUpdate', function()
      if InCombatLockdown() then return end
      TidyBar_refresh_main_area()
    end )
  end


  -- It looks like this is no longer necessary.
  --if TidyBar_character_is_max_level then
    --ArtifactWatchBar.StatusBar:HookScript( 'OnUpdate', function()
      ---- Should solve the below occasional login error.
      --if InCombatLockdown() then return end
      ---- Occasionally throws an error (protected function) when entering combat while having recently logged-in.
      --ArtifactWatchBar.StatusBar:SetHeight( TidyBar_options.bar_height )
    --end )
  --end
end

--_G[ 'ObjectiveTrackerFrame' ]:SetPoint( 'TopRight', TidyBar_frame_side, 'TopLeft' )


function TidyBar_refresh_everything()
  if TidyBar_options.debug then
    print( GetTime() .. ' TidyBar_refresh_everything()' )
  end
  if InCombatLockdown() then
    if TidyBar_options.debug then
      print( 'TidyBar:  In combat, skipping.' )
    end
    return
  end
  TidyBar_refresh_main_area()
  -- FIXME - I want to remove this, it's bad code.
  -- However, this is needed to make the sidebar area (between buttons) keep the area open.  INVESTIGATE.
  TidyBar_setup_side()
  TidyBar_refresh_vehicle()
  TidyBar_refresh_corner()
  TidyBar_refresh_side( false )
end



TidyBar = CreateFrame( 'Frame', 'TidyBar', WorldFrame )
TidyBar:SetFrameStrata( 'TOOLTIP' )
TidyBar:RegisterEvent( 'PLAYER_LOGIN' )
TidyBar:SetScript( 'OnEvent', function( self )
 self:Show()
  if TidyBar_options.debug then
    print( 'TidyBar version ' .. tostring( GetAddOnMetadata( 'TidyBar', 'Version' ) ) .. ' loaded.  Debugging mode enabled.' )
  end
  if TidyBar_options.debug then
    print( GetTime() .. ' TidyBar_setup()' )
  end

  do  --  learn if max level
    local comparison = tostring( UnitLevel( 'player' ) ) .. '/' .. tostring( MAX_PLAYER_LEVEL_TABLE[ GetExpansionLevel() ] )
    if UnitLevel( 'player' ) == MAX_PLAYER_LEVEL_TABLE[ GetExpansionLevel() ] then
      TidyBar_character_is_max_level = true
      if TidyBar_options.debug then
        print( 'TidyBar:  Character level ' .. comparison .. ' (max)' )
      end
    else
      TidyBar_character_is_max_level = false
      if not TidyBar_options.debug then
        print( 'TidyBar:  Character level ' .. comparison )
      end
    end
  end

  do  --  Create and set up the secondary frames.
    TidyBar_frame_side                  = CreateFrame( 'Frame', 'TidyBar_frame_side',   UIParent )
    TidyBar_frame_corner                = CreateFrame( 'Frame', 'TidyBar_frame_corner', UIParent )
    TidyBar_frame_corner.MicroButtons   = CreateFrame( 'Frame', nil,                    TidyBar_frame_corner )
    TidyBar_frame_corner.BagButtonFrame = CreateFrame( 'Frame', nil,                    TidyBar_frame_corner )

    TidyBar_frame_side:EnableMouse()
    TidyBar_frame_corner:EnableMouse()

    TidyBar_frame_side:SetFrameStrata(   'BACKGROUND' )
    TidyBar_frame_corner:SetFrameStrata( 'BACKGROUND' )
  end

  do  --  Set up the various components of TidyBar.
    TidyBar_setup_corner()
    TidyBar_setup_side()
    TidyBar_setup_options_pane()
    TidyBar_setup_vehicle()
    TidyBar_setup_main_area()
  end
  -- I can't get this to work..
  --TidyBar_refresh_everything()


  -- This SetScript removes the jumpiness when un-checking a reputation's "Show as Experience Bar", but ends up reversing what the checkbox means.
  --ReputationWatchBar:SetScript( 'OnEvent', TidyBar_refresh_main_area )
  -- .. whereas HookScript is just a big mess:
  ReputationWatchBar:HookScript( 'OnEvent', TidyBar_refresh_main_area )



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
  hooksecurefunc( 'UIParent_ManageFramePositions', TidyBar_refresh_everything )



  -- Start Tidy Bar
  --TidyBar:Show()

  SLASH_TIDYBAR1 = '/tidybar'
  SlashCmdList[ 'TIDYBAR' ] = TidyBar_refresh_everything
end )
