do  --  Default options
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

--  It'll be checked-for later on.
local can_display_artifact_bar = nil
local bar_width  = 500


local function hide( thing )
  thing:SetHeight( 0.001 )
  thing:SetAlpha( 0 )
  thing:Hide()
end

local function hide_more( thing )
  hide( thing )
  thing:SetTexture( Empty_Art )
end

local function frame_debug_overlay( frame )
  if not TidyBar_options.debug then return end
  local frame = frame:CreateTexture( nil, 'BACKGROUND' )
        frame:SetAllPoints()
        frame:SetColorTexture( 1, 1, 1, 0.2 )
end

local function debug( text )
  if not TidyBar_options.debug then return end
  if not text then text = '' end
  print( 'TidyBar - ' .. GetTime() .. ' - ' .. text )
end



local function TidyBar_refresh_side( mouse_inside )
  if not MultiBarRight:IsShown() then
    -- if MultiBarRight isn't there, then neither is MultiBarLeft.  May as well hide TidyBar_frame_side. 
    TidyBar_frame_side:Hide()
    _G[ 'ObjectiveTrackerFrame' ]:SetPoint( 'TopRight', MinimapCluster, 'BottomRight', 0, -10 )
    return
  end

  debug( ' TidyBar_refresh_side() ' .. tostring( mouse_inside ) .. ' ' .. tostring( TidyBar_options.always_show_side ) .. ' ' .. tostring( SpellFlyout:IsShown() ) )
  -- Oh god, all the verbosities:
  --debug( ' TidyBar_refresh_side()' )
  --debug( '  mouse_inside  -  '                     .. tostring( mouse_inside ) )
  --debug( '  TidyBar_options.always_show_side  -  ' .. tostring( TidyBar_options.always_show_side ) )
  --debug( '  SpellFlyout:IsShown()  -  '            .. tostring( SpellFlyout:IsShown() ) )

  TidyBar_frame_side:Show()

  MultiBarRight:ClearAllPoints()
  MultiBarRight:SetPoint( 'TopRight', MinimapCluster, 'BottomRight', 0, -10 )

  TidyBar_frame_side:SetPoint( 'BottomRight', MultiBarRight, 'BottomRight' )

  if MultiBarLeft:IsShown() then
    TidyBar_frame_side:SetPoint( 'TopLeft', MultiBarLeft,  'TopLeft' )
  else
    TidyBar_frame_side:SetPoint( 'TopLeft', MultiBarRight, 'TopLeft' )
  end

  -- Doing this somehow reduces the height of the objective tracker, showing only a few items:
  --_G[ 'ObjectiveTrackerFrame' ]:ClearAllPoints()
  -- Yes, this shifts the objectives tracker over, leaving space on the right.  I am not happy about this.
  --   However, this is what is needed, because the user needs to click the right of the tracker for any quest-actions.  Hovering the mouse over those items would then shift the objectives tracker, making it impossible to click them!
  _G[ 'ObjectiveTrackerFrame' ]:SetPoint( 'TopRight', TidyBar_frame_side, 'TopLeft' )

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

local function TidyBar_setup_side()
  debug()
  debug( ' TidyBar_setup_side()' )
  debug()

  do  --  mouse in/out
    local function TidyBar_SetScript_frame_side( frame )
      -- Spammy
      --debug( GetTime() .. ' TidyBar_SetScript_frame_side( ' .. tostring( frame ) .. ' )' )
      frame:SetScript( 'OnEnter', function() TidyBar_refresh_side( true  ) end )
      frame:SetScript( 'OnLeave', function() TidyBar_refresh_side( false ) end )
    end
    local function TidyBar_HookScript_frame_side( frame )
      -- Spammy
      --debug( GetTime() .. ' TidyBar_SetScript_frame_side( ' .. tostring( frame ) .. ' )' )
      frame:HookScript( 'OnEnter', function() TidyBar_refresh_side( true  ) end )
      frame:HookScript( 'OnLeave', function() TidyBar_refresh_side( false ) end )
    end

    TidyBar_SetScript_frame_side( TidyBar_frame_side )
    TidyBar_HookScript_frame_side( MultiBarRight )
    TidyBar_HookScript_frame_side( MultiBarLeft )
    for i = 1, 12 do TidyBar_HookScript_frame_side( _G[ 'MultiBarRightButton' .. i ] ) end
    for i = 1, 12 do TidyBar_HookScript_frame_side( _G[ 'MultiBarLeftButton'  .. i ] ) end
  end
end



local function TidyBar_refresh_corner()
  debug( ' TidyBar_refresh_corner()' )
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

  hide_more( MainMenuBarTexture2 )
  hide_more( MainMenuBarTexture3 )

  CharacterMicroButton:ClearAllPoints()
  CharacterMicroButton:SetPoint( 'BottomRight', TidyBar_frame_corner.MicroButtons, 'BottomRight', -270, 0 )
  for i, name in pairs( MenuButtonFrames ) do
    name:SetParent( TidyBar_frame_corner.MicroButtons )
  end
end

local function TidyBar_setup_corner()
  debug()
  debug( ' TidyBar_setup_corner()' )
  debug()

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
    -- Spammy
    --debug( ' TidyBar_SetScript_frame_corner( ' .. tostring( frameTarget ) .. ' )'  )
    frameTarget:HookScript( 'OnEnter', function() TidyBar_frame_corner:SetAlpha( 1 ) end )
    frameTarget:HookScript( 'OnLeave', function() TidyBar_frame_corner:SetAlpha( 0 ) end )
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



local function TidyBar_refresh_main_area()
  -- This would be nice, but it won't work unless/until I code the main area setup differently:
  --if PetBattleFrame.BottomFrame:IsShown() then return end
  debug( ' TidyBar_refresh_main_area()' )
  -- I seem to need to force this..
  OverrideActionBar:SetWidth( bar_width )
  OverrideActionBar:SetPoint( 'Left', ChatFrame1, 'BottomRight', 4, 18 )

  -- MainMenuBar textured background
  -- Has to be repositioned and nudged to the left since ActionButton1 was moved.  =/
  MainMenuBarTexture0:ClearAllPoints()
  MainMenuBarTexture1:ClearAllPoints()
  MainMenuBarTexture0:SetPoint( 'Left', MainMenuBar,         'Left', -8, -5 )
  MainMenuBarTexture1:SetPoint( 'Left', MainMenuBarTexture0, 'Right' )

  ActionButton1:ClearAllPoints()
  ActionButton1:SetPoint( 'BottomLeft', MainMenuBarOverlayFrame, 'BottomLeft' )

  -- The nagging talent popup
  hide( TalentMicroButtonAlert )

  local function set_bar_dimensions( bar )
    --print( bar )
    bar:ClearAllPoints()
    bar:SetWidth( bar_width )
    bar:SetHeight( TidyBar_options.bar_height )
  end

  do  --  MainMenuExpBar
    if      TidyBar_options.show_experience_bar
    and     UnitXPMax( 'player' ) > 0
    and not IsXPUserDisabled()
    and not TidyBar_character_is_max_level
    then
      set_bar_dimensions( MainMenuExpBar )
      set_bar_dimensions( MainMenuBarExpText )
      -- The XP 'bubbles'
      for i=1, 19 do hide( _G[ 'MainMenuXPBarDiv' .. i ] ) end
      do  -- Hide the "zomg I killed a wolf" animation.
        hide( MainMenuExpBar.BarTrailGlow )
        hide( MainMenuExpBar.SparkBurstMove )
      end

      do  -- The border around the XP bar
        hide( MainMenuXPBarTextureMid )
        hide( MainMenuXPBarTextureLeftCap )
        hide( MainMenuXPBarTextureRightCap )
      end

      do  -- The rested state
        hide_more( ExhaustionLevelFillBar )
        -- Re-shows itself, but OnUpdate code elsewhere takes care of this:
        hide( ExhaustionTick )
        hide( ExhaustionTickNormal )
        hide( ExhaustionTickHighlight )
      end
    end
  end

  do  --  ArtifactWatchBar
    -- If Legion
    if  GetExpansionLevel() > 5
    and UnitLevel( 'player' ) > 99
    and C_ArtifactUI.GetEquippedArtifactInfo()
    then
      can_display_artifact_bar = true
      set_bar_dimensions( ArtifactWatchBar )
      set_bar_dimensions( ArtifactWatchBar.StatusBar )
      set_bar_dimensions( ArtifactWatchBar.OverlayFrame )
      set_bar_dimensions( ArtifactWatchBar.OverlayFrame.Text )
      set_bar_dimensions( ArtifactWatchBar.StatusBar.Background )

      do  --  ArtifactWatchBar animations
        hide( ArtifactWatchBar.StatusBar.BarGlow )
        hide( ArtifactWatchBar.StatusBar.BarTrailGlow )
        hide( ArtifactWatchBar.StatusBar.SparkBurstMove )
        hide( ArtifactWatchBar.Tick )
      end

      do  --  hide ArtifactWatchBar.StatusBar.WatchBarTexture*
        hide_more( ArtifactWatchBar.StatusBar.WatchBarTexture0 )
        hide_more( ArtifactWatchBar.StatusBar.WatchBarTexture1 )
        hide_more( ArtifactWatchBar.StatusBar.WatchBarTexture2 )
        hide_more( ArtifactWatchBar.StatusBar.WatchBarTexture3 )
      end

      do  --  hide ArtifactWatchBar.StatusBar.XPBarTexture*
        hide_more( ArtifactWatchBar.StatusBar.XPBarTexture0 )
        hide_more( ArtifactWatchBar.StatusBar.XPBarTexture1 )
        hide_more( ArtifactWatchBar.StatusBar.XPBarTexture2 )
        hide_more( ArtifactWatchBar.StatusBar.XPBarTexture3 )
      end
    end  --  can_display_artifact_bar
  end

  do  --  HonorWatchBar
    set_bar_dimensions( HonorWatchBar )
    set_bar_dimensions( HonorWatchBar.StatusBar )
    set_bar_dimensions( HonorWatchBar.StatusBar.Background )
  end

  do  --  ReputationWatchBar
    set_bar_dimensions( ReputationWatchBar )
    set_bar_dimensions( ReputationWatchBar.StatusBar )
    set_bar_dimensions( ReputationWatchBar.OverlayFrame )
    set_bar_dimensions( ReputationWatchBar.OverlayFrame.Text )
    hide( ReputationWatchBar.StatusBar.BarGlow )
    do  --  hide ReputationWatchBar.StatusBar.WatchBarTexture*
      hide_more( ReputationWatchBar.StatusBar.WatchBarTexture0 )
      hide_more( ReputationWatchBar.StatusBar.WatchBarTexture1 )
      hide_more( ReputationWatchBar.StatusBar.WatchBarTexture2 )
      hide_more( ReputationWatchBar.StatusBar.WatchBarTexture3 )
    end
  end

  do  -- Hide the fiddly bits on the main bar
    hide( MainMenuBarPageNumber )
    hide( ActionBarUpButton )
    hide( ActionBarDownButton )
  end

  MultiBarBottomRight:ClearAllPoints()
  PetActionButton1:ClearAllPoints()
  StanceButton1:ClearAllPoints()

  do -- Hide the background behind the stance bar
    hide( StanceBarLeft )
    hide( StanceBarRight )
  end

  -- Hide the border around buttons
  for i=1,10 do
    hide( _G[ 'StanceButton' .. i .. 'NormalTexture2' ] )
  end

  do  --  Gryphons
    if TidyBar_options.show_gryphons then
      MainMenuBarLeftEndCap:Show()
      MainMenuBarRightEndCap:Show()
      MainMenuBarLeftEndCap:ClearAllPoints()
      MainMenuBarRightEndCap:ClearAllPoints()
      MainMenuBarLeftEndCap:SetPoint( 'BottomRight', MainMenuBar,  'BottomLeft', -4, 0 )
      MainMenuBarRightEndCap:SetPoint( 'BottomLeft', ActionButton12, 'BottomRight', 4, 0 )
    else
      MainMenuBarLeftEndCap:Hide()
      MainMenuBarRightEndCap:Hide()
    end
  end

----------------------------------------------------------------------


  hide( MainMenuBarMaxLevelBar )


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
      for i=1, 12 do
        if TidyBar_options.show_macro_text then
          _G[ bars[ button ] .. 'Button' .. i .. 'Name' ]:Show()
        else
          _G[ bars[ button ] .. 'Button' .. i .. 'Name' ]:Hide()
        end
      end
    end
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
  and     UnitXPMax( 'player' ) > 0
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
    hide( ArtifactWatchBar.StatusBar.Underlay )

    if TidyBar_character_is_max_level then
      -- For reasons unknown, this doesn't stick at max level:
      ArtifactWatchBar.StatusBar:SetHeight( TidyBar_options.bar_height )
      hide_more( ArtifactWatchBar.StatusBar.WatchBarTexture2 )
      hide_more( ArtifactWatchBar.StatusBar.WatchBarTexture3 )
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

    hide_more( HonorWatchBar.StatusBar.WatchBarTexture0 )
    hide_more( HonorWatchBar.StatusBar.WatchBarTexture1 )
    hide_more( HonorWatchBar.StatusBar.WatchBarTexture2 )
    hide_more( HonorWatchBar.StatusBar.WatchBarTexture3 )

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
    MainMenuBarVehicleLeaveButton:ClearAllPoints()
    MainMenuBarVehicleLeaveButton:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, TidyBar_options.bar_spacing )
    anchor = MainMenuBarVehicleLeaveButton
  end

  if FramerateText:IsShown() then  --  FPS text
    --FramerateLabel:ClearAllPoints()
    --FramerateText:ClearAllPoints()
    --FramerateLabel:SetPoint( 'Bottom', anchor,        'Top',  0, TidyBar_options.bar_spacing )
    --FramerateText:SetPoint(  'Left',  FramerateText, 'Right', 0, 0 )
    --anchor = FramerateText


    FramerateText:ClearAllPoints()
    FramerateText:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, TidyBar_options.bar_spacing )
    FramerateLabel:Hide()
    anchor = FramerateText
  end
end

local function TidyBar_setup_main_area()
  debug( ' TidyBar_setup_main_area()' )

  -- Fixes #54 reputation bar jumping.
  -- Though throttled, oh god is this a harsh solution.
  local TidyBar_TimeSinceLastUpdate = 0
  local percentage_of_fps = 100
  if TidyBar_character_is_max_level then
    WorldFrame:HookScript( 'OnUpdate', function()
      -- TESTING - I wonder if this is needed.
      --if InCombatLockdown() then return end
      local __, relativeTo, __, __, __ = ReputationWatchBar:GetPoint()
      if not relativeTo == MainMenuBar then return end
      TidyBar_TimeSinceLastUpdate = TidyBar_TimeSinceLastUpdate + percentage_of_fps + 1
      if ( TidyBar_TimeSinceLastUpdate > 100 ) then
        --print( GetTime() )
        TidyBar_refresh_main_area()
        TidyBar_TimeSinceLastUpdate = 0
      end
    end ) -- HookScript
  end -- if TidyBar_character_is_max_level
end



function TidyBar_refresh_everything()
  debug( ' TidyBar_refresh_everything()' )
  TidyBar_refresh_main_area()
  -- FIXME - I want to remove this, it's bad code.
  -- However, this is needed to make the sidebar area (between buttons) keep the area open.  INVESTIGATE.
  -- :
  --TidyBar_setup_side()

  TidyBar_refresh_corner()
  TidyBar_refresh_side( false )

  -- FIXME - the overlay is missing without this.
  --TidyBar_setup_side()
end



TidyBar = CreateFrame( 'Frame', 'TidyBar', WorldFrame )
TidyBar:SetFrameStrata( 'BACKGROUND' )
TidyBar:RegisterEvent( 'PLAYER_LOGIN' )
--TidyBar:RegisterEvent( 'ADDON_LOADED' )
TidyBar:SetScript( 'OnEvent', function( self )
  self:Show()
  --print( 'TidyBar version ' .. tostring( GetAddOnMetadata( 'TidyBar', 'Version' ) ) .. ' loaded.' )
  debug( 'TidyBar version ' .. tostring( GetAddOnMetadata( 'TidyBar', 'Version' ) ) .. ' loaded.  Debugging mode enabled.' )

  do  --  learn if max level
    local level_player    = UnitLevel( 'player' )
    local level_expansion = MAX_PLAYER_LEVEL_TABLE[ GetExpansionLevel() ]
    if level_player == level_expansion then
      TidyBar_character_is_max_level = true
      debug( 'TidyBar:  Character level ' .. level_player .. ' (max)' )
    else
      TidyBar_character_is_max_level = false
      debug( 'TidyBar:  Character level ' .. level_player .. '/' .. level_expansion )
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

    frame_debug_overlay( TidyBar_frame_side )
    frame_debug_overlay( TidyBar_frame_corner )
    frame_debug_overlay( TidyBar_frame_corner.MicroButtons )
    frame_debug_overlay( TidyBar_frame_corner.BagButtonFrame )
  end

  do  --  Set up the various components of TidyBar.
    TidyBar_setup_corner()
    TidyBar_setup_side()
    TidyBar_setup_options_pane()
    TidyBar_setup_main_area()
  end

  -- Call Update Function when the default UI makes changes
  -- FIXME - Isn't this a terrible, terrible, idea?
  hooksecurefunc( 'UIParent_ManageFramePositions', TidyBar_refresh_everything )

  -- Slash commands are added bulk.
  -- Shift-up/down will do the same thing.
  --SLASH_TIDYBAR1 = '/tidybar'
  --SlashCmdList[ 'TIDYBAR' ] = TidyBar_refresh_everything
end )



function TidyBar_PetSetup()
  debug( 'TidyBar_PetSetup()' )
  -- Re-use the micro buttons from the regular game world.
  CharacterMicroButton:ClearAllPoints()
  CharacterMicroButton:SetPoint( 'BottomRight', TidyBar_frame_corner.MicroButtons, 'BottomRight', -270, 0 )
  for i, name in pairs( MenuButtonFrames ) do
    name:SetParent( TidyBar_frame_corner.MicroButtons )
  end
  TidyBar_frame_corner:SetAlpha( 0 )
  -- Hide the micro buttons from the pet battle UI
  PetBattleFrame.BottomFrame.MicroButtonFrame:Hide()
  -- Hide art
  hide( PetBattleFrame.BottomFrame.Background )
  hide( PetBattleFrame.BottomFrame.LeftEndCap )
  hide( PetBattleFrame.BottomFrame.RightEndCap )
  -- Shift the UI
  PetBattleFrame.BottomFrame:ClearAllPoints()
  PetBattleFrame.BottomFrame:SetPoint( 'BottomLeft', WorldFrame, 'BottomLeft', TidyBar_options.main_area_positioning, 0 )
  PetBattleFrame.BottomFrame.TurnTimer:ClearAllPoints()
  PetBattleFrame.BottomFrame.TurnTimer:SetPoint( 'BottomLeft', PetBattleFrame.BottomFrame, 'TopLeft' )
end
TidyBar:RegisterEvent( 'PET_BATTLE_OPENING_START' )
TidyBar:HookScript( 'OnEvent', TidyBar_PetSetup )



local function TidyBar_VehicleSetup()
  if not UnitHasVehicleUI( 'player' ) then return nil end
  debug( ' TidyBar_VehicleSetup()' )

  do  --  hide stuff
    hide( OverrideActionBarEndCapL )
    hide( OverrideActionBarEndCapR )

    hide( OverrideActionBarBG )
    hide( OverrideActionBarMicroBGL )
    hide( OverrideActionBarMicroBGMid )
    hide( OverrideActionBarMicroBGR )

    -- The box around the buttons
    hide( OverrideActionBarButtonBGL )
    hide( OverrideActionBarButtonBGMid )
    hide( OverrideActionBarButtonBGR )

    hide( OverrideActionBarDivider2 )
    hide( OverrideActionBarBorder )
    hide( OverrideActionBarLeaveFrameDivider3 )
    hide( OverrideActionBarLeaveFrameExitBG )

    hide( OverrideActionBarExpBarXpL )
    hide( OverrideActionBarExpBarXpMid )
    hide( OverrideActionBarExpBarXpR )
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
    hide( OverrideActionBarHealthBarBackground )
    hide( OverrideActionBarPowerBarBackground )
  end

  do  --  experience bar
    -- FIXME? - The width doesn't seem to work.  I can't even force it during a refresh.  This doesn't seem to matter though.
    OverrideActionBarExpBar:SetWidth( bar_width )
    OverrideActionBarExpBar:SetHeight( TidyBar_options.bar_height )
    OverrideActionBarExpBar:ClearAllPoints()
    OverrideActionBarExpBar:SetPoint( 'BottomLeft', OverrideActionBarButton1, 'TopLeft', 0, 4  )
    -- The vehicle XP 'bubbles'.
    for i=1,19 do
      hide( _G[ 'OverrideActionBarXpDiv' .. i ] )
    end
  end

  OverrideActionBarLeaveFrameLeaveButton:ClearAllPoints()
  OverrideActionBarLeaveFrameLeaveButton:SetPoint( 'BottomRight', OverrideActionBar, 'BottomRight', 0, 16 )

  OverrideActionBarButton1:ClearAllPoints()
  OverrideActionBarButton1:SetPoint( 'BottomLeft', OverrideActionBar, 'BottomLeft', 24, 16 )
end
TidyBar:RegisterEvent( 'UNIT_ENTERED_VEHICLE' )
-- FIXME - this will keep re-hooking, which is a bad idea, right?
TidyBar:HookScript( 'OnEvent', TidyBar_VehicleSetup )
