--  Defaults
TidyBar_options = {}
TidyBar_options.show_experience_bar = true
TidyBar_options.show_artifact_power_bar = true
TidyBar_options.show_honor_bar = true
TidyBar_options.show_gryphons = false
TidyBar_options.hide_sidebar_on_mouseout = true
TidyBar_options.show_MainMenuBar_textured_background = false
TidyBar_options.show_macro_text = false
TidyBar_options.scale = 1
TidyBar_options.bar_spacing = 4
TidyBar_options.main_area_positioning = 500


local can_display_artifact_bar = nil
local bar_width  = 500
--  Technically adjustable, but I don't want to support that without a request.
local bar_height = 8


if UnitLevel( 'player' ) == MAX_PLAYER_LEVEL_TABLE[ GetExpansionLevel() ] then
  character_is_max_level = true
else
  character_is_max_level = false
end


local MenuButtonFrames = {
  CharacterMicroButton,     -- Character Info
  SpellbookMicroButton,     -- Spellbook & Abilities
  TalentMicroButton,        -- Specialization & Talents
  AchievementMicroButton,   -- Achievements
  QuestLogMicroButton,      -- Quest Log
  GuildMicroButton,         -- Guild Finder
  LFDMicroButton,           -- Group Finder
  CollectionsMicroButton,   -- Collections
  EJMicroButton,            -- Dungeon Journal
  StoreMicroButton,         -- Shop
  MainMenuMicroButton,      -- Game Menu
}

local BagButtonFrameList = {
  MainMenuBarBackpackButton,
  CharacterBag0Slot,
  CharacterBag1Slot,
  CharacterBag2Slot,
  CharacterBag3Slot,
  KeyRingButton,
}

local ButtonGridIsShown = false
local Corner_Artwork_Texture = "Interface\\Addons\\TidyBar\\empty"
local Empty_Art              = "Interface\\Addons\\TidyBar\\empty"
local MouseInSidebar, MouseInCorner = false

local TidyBar              = CreateFrame( 'Frame', 'TidyBar', WorldFrame )
local CornerMenuFrame      = CreateFrame( 'Frame', 'TidyBar_CornerMenuFrame',         UIParent )
local SideMouseoverFrame   = CreateFrame( 'Frame', 'TidyBar_SideBarMouseoverFrame',   UIParent )
local CornerMouseoverFrame = CreateFrame( 'Frame', 'TidyBar_CornerBarMouseoverFrame', UIParent )

local SetSidebarAlpha


-- Event Delay
-- FIXME? - This doesn't seem to work..
local DelayedEventWatcher = CreateFrame( 'Frame' )
local DelayedEvents = {}
local function CheckDelayedEvent( self )
  local pendingEvents, currentTime = 0, GetTime()
  for functionToCall, timeToCall in pairs( DelayedEvents ) do
    if currentTime > timeToCall then
      DelayedEvents[ functionToCall ] = nil
      functionToCall()
    end
  end
  -- Check afterward to prevent missing a recall
  for functionToCall, timeToCall in pairs( DelayedEvents ) do pendingEvents = pendingEvents + 1 end
  if pendingEvents == 0 then DelayedEventWatcher:SetScript( 'OnUpdate', nil ) end
end
local function DelayEvent( functionToCall, timeToCall )
  DelayedEvents[ functionToCall ] = timeToCall
  DelayedEventWatcher:SetScript( 'OnUpdate', CheckDelayedEvent )
end
--/ Event Delay



local function SetSidebarAlpha()
  local Alpha = 0
  if MouseInSidebar or ButtonGridIsShown or not TidyBar_options.hide_sidebar_on_mouseout then Alpha = 1 end
  if SpellFlyout:IsShown() then
    DelayEvent( SetSidebarAlpha, GetTime() + 0.5 )
  else
    for i = 1, 12 do
      _G[ 'MultiBarRightButton'..i ]:SetAlpha( Alpha )
      _G[ 'MultiBarLeftButton' ..i ]:SetAlpha( Alpha )
    end
  end
end



local function HookFrame_Microbuttons( frameTarget )
  frameTarget:HookScript( 'OnEnter', function() if not UnitHasVehicleUI( 'player' ) then CornerMenuFrame:SetAlpha( 1 ) end end )
  frameTarget:HookScript( 'OnLeave', function()                                          CornerMenuFrame:SetAlpha( 0 ) end )
end



local function HookFrame_CornerBar( frameTarget )
  frameTarget:HookScript( 'OnEnter', function() CornerMenuFrame:SetAlpha( 1 ) end )
  frameTarget:HookScript( 'OnLeave', function() CornerMenuFrame:SetAlpha( 0 ) end )
end



local function HookFrame_SideBar( frameTarget )
  frameTarget:HookScript( 'OnEnter', function() MouseInSidebar = true;  SetSidebarAlpha() end )
  frameTarget:HookScript( 'OnLeave', function() MouseInSidebar = false; SetSidebarAlpha() end )
end



local function ConfigureCornerBars()
  MainMenuBarTexture2:SetTexture( Empty_Art )
  MainMenuBarTexture3:SetTexture( Empty_Art )
  MainMenuBarTexture2:Hide()
  MainMenuBarTexture3:Hide()

  -- The nagging talent popup
  TalentMicroButtonAlert:SetAlpha( 0 )
  TalentMicroButtonAlert:Hide()

  if not UnitHasVehicleUI( 'player' ) then
    CharacterMicroButton:ClearAllPoints()
    CharacterMicroButton:SetPoint( 'BottomRight', CornerMenuFrame.MicroButtons, 'BottomRight', -270, 0 )
    for i, name in pairs( MenuButtonFrames ) do name:SetParent( CornerMenuFrame.MicroButtons ) end
  end
end



local function ConfigureSideBars()
  if MultiBarRight:IsShown() then
    MultiBarRight:ClearAllPoints()
    MultiBarRight:SetPoint( 'TopRight', MinimapCluster, 'BottomRight', 0, -10 )
    SideMouseoverFrame:Show()
    MultiBarRight:EnableMouse()
    SideMouseoverFrame:SetPoint( 'BottomRight', MultiBarRight, 'BottomRight' )
    -- Right Bar 2
    -- Note that if MultiBarRight is not enabled, MultiBarLeft cannot be enabled.
    if MultiBarLeft:IsShown() then
      MultiBarLeft:ClearAllPoints()
      MultiBarLeft:SetPoint( 'TopRight', MultiBarRight, 'TopLeft' )
      MultiBarLeft:EnableMouse()
      SideMouseoverFrame:SetPoint( 'TopLeft', MultiBarLeft,  'TopLeft' )
    else
      SideMouseoverFrame:SetPoint( 'TopLeft', MultiBarRight, 'TopLeft' )
    end
  else
    SideMouseoverFrame:Hide()
  end


  if TidyBar_SideBarMouseoverFrame:IsShown() then
    -- Doing this somehow reduces the height of the objective tracker, showing only a few items.
    --_G[ 'ObjectiveTrackerFrame' ]:ClearAllPoints()
    _G[ 'ObjectiveTrackerFrame' ]:SetPoint( 'TopRight', TidyBar_SideBarMouseoverFrame, 'TopLeft' )
  else
    _G[ 'ObjectiveTrackerFrame' ]:SetPoint( 'TopRight', MinimapCluster, 'BottomRight', 0, -10 )
  end
end



local function TidyBar_refresh_main_area()
    MainMenuBarMaxLevelBar:SetAlpha( 0 )
    MainMenuBarMaxLevelBar:Hide()


  -- The position of the middle buttons, from the left side.
  MainMenuBar:SetWidth(      TidyBar_options.main_area_positioning )
  -- Scaling for everything.  Somehow.
  MainMenuBar:SetScale( TidyBar_options.scale )

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
  and not character_is_max_level
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
    ArtifactWatchBar:SetPoint(                   'BottomLeft', anchor, 'TopLeft', 0, bar_spacing )
    ArtifactWatchBar.StatusBar:SetPoint(         'BottomLeft', anchor, 'TopLeft', 0, bar_spacing )
    ArtifactWatchBar.OverlayFrame:SetPoint(      'BottomLeft', anchor, 'TopLeft', 0, bar_spacing )
    ArtifactWatchBar.OverlayFrame.Text:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, bar_spacing )

    -- The colour underneath the ArtifactWatchBar
    ArtifactWatchBar.StatusBar.Underlay:Hide()

    if character_is_max_level then
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
    ReputationWatchBar:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, ReputationWatchBar_bar_spacing )
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


    -- Is this sort of thing still needed?
  --if PossessBarFrame:IsShown() then
    --PossessBarFrame:ClearAllPoints()
    --PossessBarFrame:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, TidyBar_options.bar_spacing )
  --end

end



local function TidyBar_refresh_vehicle()
 
  if not UnitHasVehicleUI( 'player' ) then return nil end
  -- This works, but it's useless if I can't reposition them.
  --LFDMicroButton:ClearAllPoints()
  --LFDMicroButton:SetPoint( 'TopRight', GuildMicroButton, 'TopLeft' )

  -- Repositioning these here is a bad idea.
  -- I don't know how to store/retrieve their positions so that things are back to normal when eciting the vehicle UI.
  --MainMenuMicroButton:ClearAllPoints()
  --MainMenuMicroButton:SetPoint( 'BottomRight', TidyBar_CornerMenuFrame, 'BottomRight' )

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



function TidyBar_RefreshPositions()
  if InCombatLockdown() then return end
  TidyBar_refresh_main_area()
  ConfigureCornerBars()
  ConfigureSideBars()
  TidyBar_refresh_vehicle()
--TidyBar_corner_setup()
end



local function TidyBar_event_handler_setup()
  local events = {}

  function events:ACTIONBAR_SHOWGRID() ButtonGridIsShown = true;  SetSidebarAlpha() end
  function events:ACTIONBAR_HIDEGRID() ButtonGridIsShown = false; SetSidebarAlpha() end
  function events:UNIT_EXITED_VEHICLE()  TidyBar_RefreshPositions(); DelayEvent( ConfigureCornerBars, GetTime() + 1 ) end    -- Echos the event to verify positions
  events.PLAYER_ENTERING_WORLD       = TidyBar_RefreshPositions
  events.UPDATE_INSTANCE_INFO        = TidyBar_RefreshPositions
  events.PLAYER_TALENT_UPDATE        = TidyBar_RefreshPositions
  events.ACTIVE_TALENT_GROUP_CHANGED = TidyBar_RefreshPositions
  events.SPELL_UPDATE_USEABLE        = TidyBar_RefreshPositions
  events.PET_BAR_UPDATE              = TidyBar_RefreshPositions
  events.UNIT_ENTERED_VEHICLE        = TidyBar_RefreshPositions
  events.UPDATE_BONUS_ACTIONBAR      = TidyBar_RefreshPositions
  events.UPDATE_MULTI_CAST_ACTIONBAR = TidyBar_RefreshPositions
  events.PLAYER_LEVEL_UP             = TidyBar_RefreshPositions
  events.UPDATE_SHAPESHIFT_FORM      = TidyBar_RefreshPositions
  events.PLAYER_GAINS_VEHICLE_DATA   = TidyBar_RefreshPositions
  events.PLAYER_LOSES_VEHICLE_DATA   = TidyBar_RefreshPositions
  events.UPDATE_VEHICLE_ACTIONBAR    = TidyBar_RefreshPositions
  events.QUEST_WATCH_UPDATE          = TidyBar_RefreshPositions
  events.UNIT_AURA                   = TidyBar_RefreshPositions

  -- Possible battlegrounds fixes for issue 34:
  --events.UPDATE_WORLD_STATES         = TidyBar_RefreshPositions         --  Fired within Battlefields when certain things occur such as a flag being captured. Also seen in the outdoor world occasionlly, but it's not clear what triggers it.
  --events.WORLD_MAP_UPDATE            = TidyBar_RefreshPositions         --  Fired when the world map should be updated.  When entering a battleground, this event won't fire until the zone is changed (i.e. in WSG when you walk outside of Warsong Lumber Mill or Silverwing Hold


  local function EventHandler( frame, event )
    if events[ event ] then
      -- NOTE - The following line is to debug:
      --print( GetTime(), event )
      events[ event ]()
    end
  end

  -- Set Event Monitoring
  for eventname in pairs( events ) do
    TidyBar:RegisterEvent( eventname )
  end
end



local function TidyBar_corner_setup()
  CornerMenuFrame:SetFrameStrata( 'LOW' )
  CornerMenuFrame:SetWidth( 300 )
  CornerMenuFrame:SetHeight( 128 )
  CornerMenuFrame:SetPoint( 'BottomRight' )
  CornerMenuFrame:SetScale( TidyBar_options.scale )

  CornerMenuFrame.Texture = CornerMenuFrame:CreateTexture( nil, 'BACKGROUND' )
  CornerMenuFrame.Texture:SetTexture( Corner_Artwork_Texture )
  CornerMenuFrame.Texture:SetPoint( 'BottomRight' )
  CornerMenuFrame.Texture:SetWidth(  512 * 1.09 )
  CornerMenuFrame.Texture:SetHeight( 128 * 1.09 )

  CornerMenuFrame.MicroButtons   = CreateFrame( 'Frame', nil, CornerMenuFrame )
  CornerMenuFrame.BagButtonFrame = CreateFrame( 'Frame', nil, CornerMenuFrame )

  -- Call Update Function when the default UI makes changes
  hooksecurefunc( 'UIParent_ManageFramePositions', TidyBar_RefreshPositions )
  -- Required in order to move the frames around
  UIPARENT_MANAGED_FRAME_POSITIONS[ 'MultiBarBottomRight' ]     = nil
  UIPARENT_MANAGED_FRAME_POSITIONS[ 'PetActionBarFrame' ]       = nil
  UIPARENT_MANAGED_FRAME_POSITIONS[ 'ShapeshiftBarFrame' ]      = nil
  UIPARENT_MANAGED_FRAME_POSITIONS[ 'PossessBarFrame' ]         = nil
  UIPARENT_MANAGED_FRAME_POSITIONS[ 'MultiCastActionBarFrame' ] = nil

  -- Set Pet Bars
  PetActionBarFrame:SetAttribute( 'unit', 'pet' )
  RegisterUnitWatch( PetActionBarFrame )
  
  -- Set Mouseovers
  ConfigureSideBars()
  SetSidebarAlpha()
  ConfigureCornerBars()
  CornerMenuFrame:SetAlpha( 0 )
end



local function TidyBar_sidebar_setup()
  SideMouseoverFrame:EnableMouse()
  SideMouseoverFrame:SetScript( 'OnEnter', function() MouseInSidebar = true;  SetSidebarAlpha() end )
  SideMouseoverFrame:SetScript( 'OnLeave', function() MouseInSidebar = false; SetSidebarAlpha() end )
  HookFrame_SideBar( MultiBarRight )
  HookFrame_SideBar( MultiBarLeft )
  for i = 1, 12 do HookFrame_SideBar( _G[ 'MultiBarRightButton'..i ] ) end
  for i = 1, 12 do HookFrame_SideBar( _G[ 'MultiBarLeftButton' ..i ] ) end
end



local function TidyBar_corner_menu_setup()
  -- Keyring etc
  for i, name in pairs( BagButtonFrameList ) do
    name:SetParent( CornerMenuFrame.BagButtonFrame )
  end
  
  MainMenuBarBackpackButton:ClearAllPoints()
  MainMenuBarBackpackButton:SetPoint( 'Bottom' )
  MainMenuBarBackpackButton:SetPoint( 'Right', -60, 0 )
  
  -- Setup the Corner Buttons
  for i, name in pairs( BagButtonFrameList ) do HookFrame_CornerBar(    name ) end
  for i, name in pairs( MenuButtonFrames   ) do HookFrame_Microbuttons( name ) end
  
  -- Setup the Corner Menu Artwork
  CornerMenuFrame:SetScale( TidyBar_options.scale )
  CornerMenuFrame.MicroButtons:SetAllPoints( CornerMenuFrame )
  CornerMenuFrame.BagButtonFrame:SetPoint( 'TopRight', 2, -18 )
  CornerMenuFrame.BagButtonFrame:SetHeight( 64 )
  CornerMenuFrame.BagButtonFrame:SetWidth( 256 )
  CornerMenuFrame.BagButtonFrame:SetScale( 1.02 )
  
  -- Setup the Corner Menu Mouseover frame
  CornerMouseoverFrame:EnableMouse()
  CornerMouseoverFrame:SetFrameStrata( 'BACKGROUND' )
  
  CornerMouseoverFrame:SetPoint( 'Top', MainMenuBarBackpackButton, 'Top', 0, 10 )
  CornerMouseoverFrame:SetPoint( 'Right',  UIParent, 'Right' )
  CornerMouseoverFrame:SetPoint( 'Bottom', UIParent, 'Bottom' )
  CornerMouseoverFrame:SetWidth( 322 )
  
  CornerMouseoverFrame:SetScript( 'OnEnter', function() CornerMenuFrame:SetAlpha( 1 ) end )
  CornerMouseoverFrame:SetScript( 'OnLeave', function() CornerMenuFrame:SetAlpha( 0 ) end )
end



local function TidyBar_main_area_setup()
  -- This deals with positioning and permanent-hiding.
  -- This does not deal with showing / hiding features.

  ActionButton1:ClearAllPoints()
  ActionButton1:SetPoint( 'BottomLeft', MainMenuBarOverlayFrame, 'BottomLeft' )

  local width = 500
  local height = 8

  -- MainMenuBar textured background
  -- Has to be repositioned and nudged to the left since ActionButton1 was moved.  =/
  MainMenuBarTexture0:ClearAllPoints()
  MainMenuBarTexture1:ClearAllPoints()
  MainMenuBarTexture0:SetPoint( 'Left', MainMenuBar,         'Left', -8, -5 )
  MainMenuBarTexture1:SetPoint( 'Left', MainMenuBarTexture0, 'Right' )


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
    ArtifactWatchBar.StatusBar:SetHeight( bar_height )
    ArtifactWatchBar.StatusBar:ClearAllPoints()

    ArtifactWatchBar.OverlayFrame:SetWidth( bar_width )
    ArtifactWatchBar.OverlayFrame:SetHeight( bar_height )
    ArtifactWatchBar.OverlayFrame:ClearAllPoints()

    ArtifactWatchBar.OverlayFrame.Text:SetWidth( bar_width )
    ArtifactWatchBar.OverlayFrame.Text:SetHeight( bar_height )
    ArtifactWatchBar.OverlayFrame.Text:ClearAllPoints()

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

    ArtifactWatchBar.StatusBar.XPBarTexture0:SetTexture( Empty_Art )
    ArtifactWatchBar.StatusBar.XPBarTexture1:SetTexture( Empty_Art )
    ArtifactWatchBar.StatusBar.XPBarTexture2:SetTexture( Empty_Art )
    ArtifactWatchBar.StatusBar.XPBarTexture3:SetTexture( Empty_Art )

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
end



local function TidyBar_vehicle_setup()
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



local function TidyBar_OnLoad()
  TidyBar_event_handler_setup()
  TidyBar_corner_setup()
  TidyBar_corner_menu_setup()
  TidyBar_sidebar_setup()
  TidyBar_main_area_setup()
  TidyBar_create_options_pane()
  TidyBar_vehicle_setup()

  -- Start Tidy Bar
  TidyBar:SetScript( 'OnEvent', EventHandler )
  TidyBar:SetFrameStrata( 'TOOLTIP' )
  TidyBar:Show()

  SLASH_TIDYBAR1 = '/tidybar'
  SlashCmdList[ 'TIDYBAR' ] = TidyBar_RefreshPositions
end
TidyBar:RegisterEvent( 'ADDON_LOADED' )
TidyBar:SetScript( 'OnEvent', TidyBar_OnLoad )
