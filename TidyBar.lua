--
--  User preferences
--
--    Yes, you're expected to edit TidyBar.lua every time you update it.  Sorry.
--
TidyBar_HideExperienceBar = false
TidyBar_HideGryphons = true
TidyBar_AutoHideSideBar = true
TidyBar_HideActionBarButtonsTexturedBackground = true
TidyBar_hide_macro_text = true


-- The size of all of the buttons.
--   1 is normal
--   Something like 0.8 is smaller
--   Something like 1.2 is larger
--   Note that anything over will risk having some buttons on the sidebar off of the bottom of your screen.
TidyBar_Scale = 1


-- The amount of vertical space between bars.
--   Note that the experience bar(if shown) and reputation bar are not separated.
TidyBar_bar_spacing = ( 4 * TidyBar_Scale )


-- The position of the middle buttons.
--   Default 500
--   On a 1920 x 1080 screen:
--       500 is the middle
--      1375 is the left side
--         1 is more to the right.
--         0 crosses the streams.
--         (I have no idea to right-align it, and I won't bother to code something)
TidyBar_main_area_positioning = 500


----------------------------------------------------------------------


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



function SetSidebarAlpha()
  local Alpha = 0
  if MouseInSidebar or ButtonGridIsShown or not TidyBar_AutoHideSideBar then Alpha = 1 end
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
    CharacterMicroButton:SetPoint( 'BOTTOMRIGHT', CornerMenuFrame.MicroButtons, 'BOTTOMRIGHT', -270, 0 )
    for i, name in pairs( MenuButtonFrames ) do name:SetParent( CornerMenuFrame.MicroButtons ) end
  end
end



local function ConfigureSideBars()
  if MultiBarRight:IsShown() then
    MultiBarRight:ClearAllPoints()
    MultiBarRight:SetPoint( 'TOPRIGHT', MinimapCluster, 'BOTTOMRIGHT', 0, -10 )
    SideMouseoverFrame:Show()
    MultiBarRight:EnableMouse()
    SideMouseoverFrame:SetPoint( 'BOTTOMRIGHT', MultiBarRight, 'BOTTOMRIGHT' )
    -- Right Bar 2
    -- Note that if MultiBarRight is not enabled, MultiBarLeft cannot be enabled.
    if MultiBarLeft:IsShown() then
      MultiBarLeft:ClearAllPoints()
      MultiBarLeft:SetPoint( 'TOPRIGHT', MultiBarRight, 'TOPLEFT' )
      MultiBarLeft:EnableMouse()
      SideMouseoverFrame:SetPoint( 'TOPLEFT', MultiBarLeft,  'TOPLEFT' )
    else
      SideMouseoverFrame:SetPoint( 'TOPLEFT', MultiBarRight, 'TOPLEFT' )
    end
  else
    SideMouseoverFrame:Hide()
  end

  if TidyBar_SideBarMouseoverFrame:IsShown() then
    -- Doing this somehow reduces the height of the objective tracker, showing only a few items.
    --_G[ 'ObjectiveTrackerFrame' ]:ClearAllPoints()
    _G[ 'ObjectiveTrackerFrame' ]:SetPoint( 'TOPRIGHT', TidyBar_SideBarMouseoverFrame, 'TOPLEFT' )
  else
    _G[ 'ObjectiveTrackerFrame' ]:SetPoint( 'TOPRIGHT', MinimapCluster, 'BOTTOMRIGHT', 0, -10 )
  end
end



local function TidyBar_refresh_reputation_bar()
  ReputationWatchBar:SetWidth( 500 )
  ReputationWatchBar:SetHeight( 8 )
  ReputationWatchBar:ClearAllPoints()
  if MainMenuExpBar:IsShown() then
    ReputationWatchBar:SetPoint( 'BOTTOMLEFT', 'MainMenuExpBar', 'TOPLEFT' )
  else
    ReputationWatchBar:SetPoint( 'BOTTOMLEFT', 'ActionButton1',  'TOPLEFT', TidyBar_bar_spacing )
  end

  ReputationWatchBar.StatusBar:SetWidth( 500 )
  ReputationWatchBar.StatusBar:SetHeight( 8 )
  ReputationWatchBar.StatusBar:ClearAllPoints()
  ReputationWatchBar.StatusBar:SetPoint( 'TOP', ReputationWatchBar )

  ReputationWatchBar.StatusBar.BarGlow:SetHeight( 8 )
  ReputationWatchBar.StatusBar.BarGlow:ClearAllPoints()
  ReputationWatchBar.StatusBar.BarGlow:SetPoint( 'TOP', ReputationWatchBar )

  ReputationWatchBar.OverlayFrame:SetHeight( 8 )
  ReputationWatchBar.OverlayFrame:ClearAllPoints()
  ReputationWatchBar.OverlayFrame:SetPoint( 'TOP', ReputationWatchBar )

  ReputationWatchBar.OverlayFrame.Text:SetHeight( 8 )
  ReputationWatchBar.OverlayFrame.Text:ClearAllPoints()
  ReputationWatchBar.OverlayFrame.Text:SetPoint( 'TOP', ReputationWatchBar )
end



local function TidyBar_refresh_main_area()
  -- The position of the middle buttons, from the left side.
  MainMenuBar:SetWidth( TidyBar_main_area_positioning )
  -- Scaling
  MainMenuBar:SetScale( TidyBar_Scale )


  if TidyBar_HideGryphons then
    MainMenuBarLeftEndCap:Hide()
    MainMenuBarRightEndCap:Hide()
  end

  if TidyBar_HideExperienceBar then
    MainMenuExpBar:Hide()
    MainMenuExpBar:SetHeight( .001 )
  else
    -- The 'bubbles' which hang off of the right.
    for i=1,19 do _G[ 'MainMenuXPBarDiv' .. i ]:SetTexture( Empty_Art ) end
  end

  -- Hide the fiddly bits on the main bar
  MainMenuBarPageNumber:Hide()
  ActionBarUpButton:Hide()
  ActionBarDownButton:Hide()

  -- The XP bar
  -- The 'bubbles'
  ReputationWatchBar.StatusBar.XPBarTexture0:SetAlpha( 0 )
  ReputationWatchBar.StatusBar.XPBarTexture1:SetAlpha( 0 )
  -- The 'bubbles' which hang off of the right.
  ReputationWatchBar.StatusBar.XPBarTexture2:SetAlpha( 0 )
  ReputationWatchBar.StatusBar.XPBarTexture3:SetAlpha( 0 )

  -- The reputation bar bubbles
  -- .. in the middle of the screen
  ReputationWatchBar.StatusBar.WatchBarTexture0:SetTexture( Empty_Art )
  ReputationWatchBar.StatusBar.WatchBarTexture1:SetTexture( Empty_Art )
  ReputationWatchBar.StatusBar.WatchBarTexture0:SetAlpha( 0 )
  ReputationWatchBar.StatusBar.WatchBarTexture1:SetAlpha( 0 )
  -- .. which would hang off the right
  ReputationWatchBar.StatusBar.WatchBarTexture2:SetTexture( Empty_Art )
  ReputationWatchBar.StatusBar.WatchBarTexture3:SetTexture( Empty_Art )
  ReputationWatchBar.StatusBar.WatchBarTexture2:SetAlpha( 0 )
  ReputationWatchBar.StatusBar.WatchBarTexture3:SetAlpha( 0 )
  -- Hiding the grey background
  --ReputationWatchBar.StatusBar.Background:Hide()

  -- The border around the XP bar
       MainMenuXPBarTextureMid:SetAlpha( 0 )
   MainMenuXPBarTextureLeftCap:SetAlpha( 0 )
  MainMenuXPBarTextureRightCap:SetAlpha( 0 )

  -- The rested state
  ExhaustionLevelFillBar:SetTexture( Empty_Art )
  ExhaustionTick:SetAlpha( 0 )

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

  MainMenuBarMaxLevelBar:Hide()
  MainMenuBarMaxLevelBar:SetAlpha( 0 )

  if TidyBar_HideActionBarButtonsTexturedBackground then
    MainMenuBarTexture0:SetAlpha( 0 )
    MainMenuBarTexture1:SetAlpha( 0 )
    MainMenuBarTexture0:Hide()
    MainMenuBarTexture1:Hide()
  else
    MainMenuBarTexture0:SetPoint( 'LEFT', MainMenuBar,         'LEFT'  )
    MainMenuBarTexture1:SetPoint( 'LEFT', MainMenuBarTexture0, 'RIGHT' )
  end


  local anchor = ActionButton1

  if MainMenuExpBar:IsShown() then
    MainMenuExpBar:SetWidth( 500 )
    MainMenuExpBar:SetHeight( 8 )
    MainMenuExpBar:ClearAllPoints()
    MainMenuExpBar:SetPoint( 'BOTTOMLEFT', anchor, 'TOPLEFT', 0, TidyBar_bar_spacing )

    MainMenuExpBar.SparkBurstMove:SetHeight( 8 )
    MainMenuExpBar.SparkBurstMove:ClearAllPoints()
    MainMenuExpBar.SparkBurstMove:SetPoint( 'TOP', MainMenuExpBar )

    anchor = MainMenuExpBar
  end

  if ReputationWatchBar:IsShown() then

    anchor = ReputationWatchBar
  end

  if MultiBarBottomLeft:IsShown() then
    MultiBarBottomLeft:ClearAllPoints()
    MultiBarBottomLeft:SetPoint( 'BOTTOMLEFT', anchor, 'TOPLEFT', 0, TidyBar_bar_spacing )
    anchor = MultiBarBottomLeft
  end

  if MultiBarBottomRight:IsShown() then
    MultiBarBottomRight:ClearAllPoints()
    MultiBarBottomRight:SetPoint( 'BOTTOMLEFT', anchor, 'TOPLEFT', 0, TidyBar_bar_spacing )
    anchor = MultiBarBottomRight
  end

  if StanceBarFrame:IsShown() then
    StanceButton1:ClearAllPoints()
    StanceButton1:SetPoint( 'BOTTOMLEFT', anchor, 'TOPLEFT', 0, TidyBar_bar_spacing )
    anchor = StanceButton1
  end

  if PetActionBarFrame:IsShown() then
    PetActionButton1:ClearAllPoints()
    PetActionButton1:SetPoint( 'BOTTOMLEFT', anchor, 'TOPLEFT', 0, TidyBar_bar_spacing )
    anchor = PetActionButton1
  end

  -- Is this sort of thing still needed?
  --if PossessBarFrame:IsShown() then
    --PossessBarFrame:ClearAllPoints()
    --PossessBarFrame:SetPoint( 'BOTTOMLEFT', anchor, 'TOPLEFT', 0, TidyBar_bar_spacing )
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
  CornerMenuFrame:SetPoint( 'BOTTOMRIGHT' )
  CornerMenuFrame:SetScale( TidyBar_Scale )

  CornerMenuFrame.Texture = CornerMenuFrame:CreateTexture( nil, 'BACKGROUND' )
  CornerMenuFrame.Texture:SetTexture( Corner_Artwork_Texture )
  CornerMenuFrame.Texture:SetPoint( 'BOTTOMRIGHT' )
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
  -- Setup the Side Action Bars
  SideMouseoverFrame:SetScript( 'OnEnter', function() MouseInSidebar = true; SetSidebarAlpha() end )
  SideMouseoverFrame:SetScript( 'OnLeave', function() MouseInSidebar = false;SetSidebarAlpha() end )
  SideMouseoverFrame:EnableMouse()
  HookFrame_SideBar( MultiBarRight )
  HookFrame_SideBar( MultiBarLeft )
  MultiBarRight:SetScale( TidyBar_Scale )
  MultiBarLeft:SetScale(  TidyBar_Scale )
  for i = 1, 12 do HookFrame_SideBar( _G[ 'MultiBarRightButton'..i ] ) end
  for i = 1, 12 do HookFrame_SideBar( _G[ 'MultiBarLeftButton' ..i ] ) end
end



local function TidyBar_corner_menu_setup()
  -- Keyring etc
  for i, name in pairs( BagButtonFrameList ) do
    name:SetParent( CornerMenuFrame.BagButtonFrame )
  end
  
  MainMenuBarBackpackButton:ClearAllPoints()
  MainMenuBarBackpackButton:SetPoint( 'BOTTOM' )
  MainMenuBarBackpackButton:SetPoint( 'RIGHT', -60, 0 )
  
  -- Setup the Corner Buttons
  for i, name in pairs( BagButtonFrameList ) do HookFrame_CornerBar(    name ) end
  for i, name in pairs( MenuButtonFrames   ) do HookFrame_Microbuttons( name ) end
  
  -- Setup the Corner Menu Artwork
  CornerMenuFrame:SetScale( TidyBar_Scale )
  CornerMenuFrame.MicroButtons:SetAllPoints( CornerMenuFrame )
  CornerMenuFrame.BagButtonFrame:SetPoint( 'TOPRIGHT', 2, -18 )
  CornerMenuFrame.BagButtonFrame:SetHeight( 64 )
  CornerMenuFrame.BagButtonFrame:SetWidth( 256 )
  CornerMenuFrame.BagButtonFrame:SetScale( 1.02 )
  
  -- Setup the Corner Menu Mouseover frame
  CornerMouseoverFrame:EnableMouse()
  CornerMouseoverFrame:SetFrameStrata( 'BACKGROUND' )
  
  CornerMouseoverFrame:SetPoint( 'TOP', MainMenuBarBackpackButton, 'TOP', 0, 10 )
  CornerMouseoverFrame:SetPoint( 'RIGHT',  UIParent, 'RIGHT' )
  CornerMouseoverFrame:SetPoint( 'BOTTOM', UIParent, 'BOTTOM' )
  CornerMouseoverFrame:SetWidth( 322 )
  
  CornerMouseoverFrame:SetScript( 'OnEnter', function() CornerMenuFrame:SetAlpha( 1 ) end )
  CornerMouseoverFrame:SetScript( 'OnLeave', function() CornerMenuFrame:SetAlpha( 0 ) end )
end



local function TidyBar_bars_setup()
  -- While `local TidyBar_HideExperienceBar = false`, when showing a reputation as an experience bar, disabling that reputation's experience bar will show the action bars "jump" before settling into their correct positions.
  -- It appears that Blizzard re-paints the reputation bar before deciding to hide it once and for all.
    -- TidyBar's `DelayEvent()` might be a solution, but I wasn't able to get it working.
    -- The following seems to be the fix.
  ReputationWatchBar:HookScript( 'OnUpdate', TidyBar_refresh_reputation_bar )
  MainMenuBar:HookScript( 'OnShow', function()
    --print( 'Showing' )
    TidyBar_RefreshPositions()
  end)

  if TidyBar_hide_macro_text then
    local r={
      'MultiBarBottomLeft',
      'MultiBarBottomRight',
      'Action',
      'MultiBarLeft',
      'MultiBarRight',
    }
    for b=1, #r do
      for i=1,12 do
        _G[ r[b] .. 'Button' .. i .. 'Name' ]:SetAlpha( 0 )
      end
    end
  end

end



local function TidyBar_OnLoad()
  TidyBar_event_handler_setup()
  TidyBar_corner_setup()
  TidyBar_corner_menu_setup()
  TidyBar_sidebar_setup()
  TidyBar_bars_setup()
  --  Not production-ready
  --TidyBar_create_options_pane()

  -- Start Tidy Bar
  TidyBar:SetScript( 'OnEvent', EventHandler )
  TidyBar:SetFrameStrata( 'TOOLTIP' )
  TidyBar:Show()

  SLASH_TIDYBAR1 = '/tidybar'
  SlashCmdList[ 'TIDYBAR' ] = TidyBar_RefreshPositions
end



TidyBar_OnLoad()
