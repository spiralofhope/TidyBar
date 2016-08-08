--  Defaults
TidyBar_options = {}
TidyBar_options.show_experience_bar = true
TidyBar_options.show_gryphons = false
TidyBar_options.hide_sidebar_on_mouseout = true
TidyBar_options.show_MainMenuBar_textured_background = false
TidyBar_options.show_macro_text = false
TidyBar_options.scale = 1
TidyBar_options.bar_spacing = ( 4 )
TidyBar_options.main_area_positioning = 500



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



local function TidyBar_refresh_reputation_bar()
  if MainMenuExpBar:IsShown() then
    ReputationWatchBar:SetPoint( 'BottomLeft', 'MainMenuExpBar', 'TopLeft' )
  else
    ReputationWatchBar:SetPoint( 'BottomLeft', 'ActionButton1',  'TopLeft', 0, TidyBar_options.bar_spacing )
  end
end



local function TidyBar_refresh_main_area()
  -- Note that the reputation bar is refreshed via an OnUpdate HookScript

  -- The position of the middle buttons, from the left side.
  MainMenuBar:SetWidth( TidyBar_options.main_area_positioning )
  -- Scaling
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
        _G[ bars[ button ] .. 'Button' .. i .. 'Name' ]:SetAlpha( alpha )
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
    MainMenuBarTexture0:SetAlpha( 1 )
    MainMenuBarTexture1:SetAlpha( 1 )
  else
    MainMenuBarTexture0:SetAlpha( 0 )
    MainMenuBarTexture1:SetAlpha( 0 )
  end


  if TidyBar_options.show_experience_bar then
    MainMenuExpBar:Show()
    MainMenuExpBar.SparkBurstMove:Show()
    MainMenuBarExpText:Show()
  else
    MainMenuExpBar:Hide()
    MainMenuExpBar.SparkBurstMove:Hide()
    MainMenuBarExpText:Hide()
  end



--------------------------------
--------------------------------
--------------------------------
--------------------------------


  local anchor = ActionButton1

  if MainMenuExpBar:IsShown() then
    MainMenuExpBar:SetHeight( 8 )
    MainMenuExpBar:ClearAllPoints()
    MainMenuExpBar:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, TidyBar_options.bar_spacing )

    MainMenuExpBar.SparkBurstMove:SetHeight( 8 )
    MainMenuExpBar.SparkBurstMove:ClearAllPoints()
    MainMenuExpBar.SparkBurstMove:SetPoint( 'Top', MainMenuExpBar )

    anchor = MainMenuExpBar
  end

  if ReputationWatchBar:IsShown() then
    anchor = ReputationWatchBar
  end

  if MultiBarBottomLeft:IsShown() then
    MultiBarBottomLeft:ClearAllPoints()
    if anchor == ActionButton1 then
      -- FIXME? - I'm not sure what's going on that would need this, but whatever.
      MultiBarBottomLeft:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, TidyBar_options.bar_spacing * 1.5 )
    else
      MultiBarBottomLeft:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, TidyBar_options.bar_spacing )
    end
    anchor = MultiBarBottomLeft
  end

  if MultiBarBottomRight:IsShown() then
    MultiBarBottomRight:ClearAllPoints()
    MultiBarBottomRight:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, TidyBar_options.bar_spacing )
    anchor = MultiBarBottomRight
  end

  if StanceBarFrame:IsShown() then
    StanceButton1:ClearAllPoints()
    StanceButton1:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, TidyBar_options.bar_spacing )
    anchor = StanceButton1
  end

  if PetActionBarFrame:IsShown() then
    PetActionButton1:ClearAllPoints()
    PetActionButton1:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, TidyBar_options.bar_spacing )
    anchor = PetActionButton1
  end

  if MainMenuBarVehicleLeaveButton:IsShown() then
    MainMenuBarVehicleLeaveButton:ClearAllPoints()
    MainMenuBarVehicleLeaveButton:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, TidyBar_options.bar_spacing )
    anchor = MainMenuBarVehicleLeaveButton
  end

    -- Is this sort of thing still needed?
  --if PossessBarFrame:IsShown() then
    --PossessBarFrame:ClearAllPoints()
    --PossessBarFrame:SetPoint( 'BottomLeft', anchor, 'TopLeft', 0, TidyBar_options.bar_spacing )
  --end

end



function TidyBar_RefreshPositions()
  if InCombatLockdown() then return end
  TidyBar_refresh_main_area()
  ConfigureCornerBars()
  ConfigureSideBars()
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
  events.ACTIONBAR_PAGE_CHANGED      = TidyBar_page_changing


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
  MultiBarRight:SetScale( TidyBar_options.scale )
  MultiBarLeft:SetScale(  TidyBar_options.scale )
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



local function TidyBar_bars_setup()
  -- This deals with positioning and permanent-hiding.
  -- This does not deal with showing / hiding features.

  local width = 500
  local height = 8

  -- MainMenuBar textured background
  MainMenuBarTexture0:SetPoint( 'Left', MainMenuBar,         'Left'  )
  MainMenuBarTexture1:SetPoint( 'Left', MainMenuBarTexture0, 'Right' )

  local function MainMenuExpBar_setup()
    MainMenuExpBar:SetWidth( width )
    MainMenuExpBar:SetHeight( height )
    MainMenuExpBar:ClearAllPoints()

    MainMenuBarExpText:SetWidth( width )
    MainMenuBarExpText:SetHeight( height )
    MainMenuBarExpText:ClearAllPoints()
    MainMenuBarExpText:SetPoint( 'Top', MainMenuExpBar )

    -- The XP bar
    -- The 'bubbles'
    ReputationWatchBar.StatusBar.XPBarTexture0:SetAlpha( 0 )
    ReputationWatchBar.StatusBar.XPBarTexture1:SetAlpha( 0 )
    -- The 'bubbles' which hang off of the Right.
    ReputationWatchBar.StatusBar.XPBarTexture2:SetAlpha( 0 )
    ReputationWatchBar.StatusBar.XPBarTexture3:SetAlpha( 0 )
    for i=1,19 do _G[ 'MainMenuXPBarDiv' .. i ]:SetAlpha( 0 ) end

    -- The border around the XP bar
         MainMenuXPBarTextureMid:SetAlpha( 0 )
     MainMenuXPBarTextureLeftCap:SetAlpha( 0 )
    MainMenuXPBarTextureRightCap:SetAlpha( 0 )

    -- The rested state
    ExhaustionLevelFillBar:SetTexture( Empty_Art )
    ExhaustionTick:SetAlpha( 0 )

    MainMenuBarMaxLevelBar:Hide()
    MainMenuBarMaxLevelBar:SetAlpha( 0 )
  end
  MainMenuExpBar_setup()

  local function ReputationWatchBar_setup()
    ReputationWatchBar:SetWidth( width )
    ReputationWatchBar:SetHeight( height )
    ReputationWatchBar:ClearAllPoints()

    ReputationWatchBar.StatusBar:SetWidth( width )
    ReputationWatchBar.StatusBar:SetHeight( height )
    ReputationWatchBar.StatusBar:ClearAllPoints()
    ReputationWatchBar.StatusBar:SetPoint( 'Top', ReputationWatchBar )

    ReputationWatchBar.StatusBar.BarGlow:SetHeight( height )
    ReputationWatchBar.StatusBar.BarGlow:ClearAllPoints()
    ReputationWatchBar.StatusBar.BarGlow:SetPoint( 'Top', ReputationWatchBar )

    ReputationWatchBar.OverlayFrame:SetHeight( height )
    ReputationWatchBar.OverlayFrame:ClearAllPoints()
    ReputationWatchBar.OverlayFrame:SetPoint( 'Top', ReputationWatchBar )

    ReputationWatchBar.OverlayFrame.Text:SetHeight( height )
    ReputationWatchBar.OverlayFrame.Text:ClearAllPoints()
    ReputationWatchBar.OverlayFrame.Text:SetPoint( 'Top', ReputationWatchBar )

    -- The reputation bar bubbles
    -- .. in the middle of the screen
    ReputationWatchBar.StatusBar.WatchBarTexture0:SetTexture( Empty_Art )
    ReputationWatchBar.StatusBar.WatchBarTexture1:SetTexture( Empty_Art )
    ReputationWatchBar.StatusBar.WatchBarTexture0:SetAlpha( 0 )
    ReputationWatchBar.StatusBar.WatchBarTexture1:SetAlpha( 0 )
    -- .. which would hang off the Right
    ReputationWatchBar.StatusBar.WatchBarTexture2:SetTexture( Empty_Art )
    ReputationWatchBar.StatusBar.WatchBarTexture3:SetTexture( Empty_Art )
    ReputationWatchBar.StatusBar.WatchBarTexture2:SetAlpha( 0 )
    ReputationWatchBar.StatusBar.WatchBarTexture3:SetAlpha( 0 )
  end
  ReputationWatchBar_setup()

  -- Hide the fiddly bits on the main bar
  MainMenuBarPageNumber:Hide()
  ActionBarUpButton:Hide()
  ActionBarDownButton:Hide()

  if StanceBarLeft:IsShown() then
    -- Hide the background behind the stance bar
    StanceBarLeft:SetAlpha( 0 )
    StanceBarRight:SetAlpha( 0 )
    StanceBarLeft:Hide()
    StanceBarRight:Hide()
    -- Hide the border around buttons
    for i=1,10 do
      _G[ 'StanceButton' .. i .. 'NormalTexture2' ]:Hide()
      _G[ 'StanceButton' .. i .. 'NormalTexture2' ]:SetAlpha( 0 )
    end
  end

  -- The nagging talent popup
  TalentMicroButtonAlert:Hide()
  TalentMicroButtonAlert:SetAlpha( 0 )

  -- Gryphons
  MainMenuBarLeftEndCap:ClearAllPoints()
  MainMenuBarRightEndCap:ClearAllPoints()
  MainMenuBarLeftEndCap:SetPoint( 'BottomRight', ActionButton1,  'BottomLeft', -4, 0 )
  MainMenuBarRightEndCap:SetPoint( 'BottomLeft', ActionButton12, 'BottomRight', 4, 0 )

  -- While `local TidyBar_options.show_experience_bar = false`, when showing a reputation as an experience bar, disabling that reputation's experience bar will show the action bars "jump" before settling into their correct positions.
  -- It appears that Blizzard re-paints the reputation bar before deciding to hide it once and for all.
    -- TidyBar's `DelayEvent()` might be a solution, but I wasn't able to get it working.
    -- The following seems to be the fix.
-- TODO - remove reliance on this!
  ReputationWatchBar:HookScript( 'OnUpdate', TidyBar_refresh_reputation_bar )
end



local function TidyBar_OnLoad()
  TidyBar_event_handler_setup()
  TidyBar_corner_setup()
  TidyBar_corner_menu_setup()
  TidyBar_sidebar_setup()
  TidyBar_bars_setup()
  --  Not production-ready
  TidyBar_create_options_pane()
  TidyBar_refresh_reputation_bar()

  -- Start Tidy Bar
  TidyBar:SetScript( 'OnEvent', EventHandler )
  TidyBar:SetFrameStrata( 'TOOLTIP' )
  TidyBar:Show()

  SLASH_TIDYBAR1 = '/tidybar'
  SlashCmdList[ 'TIDYBAR' ] = TidyBar_RefreshPositions
end
TidyBar:RegisterEvent( 'ADDON_LOADED' )
TidyBar:SetScript( 'OnEvent', TidyBar_OnLoad )
