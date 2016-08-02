--
--  User preferences
--
--    Yes, you're expected to edit TidyBar.lua every time you update it.  Sorry.
--
-- Set the following to either true or false
local HideExperienceBar = false
local HideGryphons = true
local AutoHideSideBar = true
local HideActionBarButtonsTexturedBackground = true


-- The size of all of the buttons.
--   1 is normal
--   Something like 0.8 is smaller
--   Something like 1.2 is larger
--   Note that anything over will risk having some buttons on the sidebar off of the bottom of your screen.
local TidyBarScale = 1


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

CornerMenuFrame:SetFrameStrata( 'LOW' )
CornerMenuFrame:SetWidth( 300 )
CornerMenuFrame:SetHeight( 128 )
CornerMenuFrame:SetPoint( 'BOTTOMRIGHT' )
CornerMenuFrame:SetScale( TidyBarScale )

CornerMenuFrame.Texture = CornerMenuFrame:CreateTexture( nil, 'BACKGROUND' )
CornerMenuFrame.Texture:SetTexture( Corner_Artwork_Texture )
CornerMenuFrame.Texture:SetPoint( 'BOTTOMRIGHT' )
CornerMenuFrame.Texture:SetWidth(  512 * 1.09 )
CornerMenuFrame.Texture:SetHeight( 128 * 1.09 )

CornerMenuFrame.MicroButtons   = CreateFrame( 'Frame', nil, CornerMenuFrame )
CornerMenuFrame.BagButtonFrame = CreateFrame( 'Frame', nil, CornerMenuFrame )

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

local function RefreshMainActionBars()
  local anchor = ActionButton1
  local anchorOffset = 14
  local initialOffset = 32

  if HideExperienceBar == true then
    MainMenuExpBar:Hide()
    MainMenuExpBar:SetHeight( .001 )
  end

  if MainMenuExpBar:IsShown() then
    MainMenuExpBar:ClearAllPoints()
    MainMenuExpBar:SetPoint( 'TOPLEFT', MainMenuBar, 6, 0 )
    MainMenuExpBar.SparkBurstMove:ClearAllPoints()
    MainMenuExpBar.SparkBurstMove:SetPoint( 'TOPLEFT', MainMenuExpBar, 0, 0 )
    MainMenuExpBar:SetHeight( 8 )
    anchorOffset = 8
    anchor = MainMenuExpBar
  end

  if ReputationWatchBar:IsShown() then
    ReputationWatchBar.StatusBar:ClearAllPoints()
    ReputationWatchBar.StatusBar:SetPoint( 'TOPLEFT', anchor, 0, anchorOffset )
    ReputationWatchBar:SetHeight( 8 )
    anchor = ReputationWatchBar
    anchorOffset = 6
  else
    anchorOffset = 4
    ReputationWatchBar:Hide()
    ReputationWatchBar:SetHeight( .001 )
  end

  if MultiBarBottomLeft:IsShown() then
    MultiBarBottomLeft:ClearAllPoints()
    if ReputationWatchBar:IsShown() then
      MultiBarBottomLeft:SetPoint( 'BOTTOMLEFT', anchor, 'TOPLEFT', 6, anchorOffset )
    else
      MultiBarBottomLeft:SetPoint( 'BOTTOMLEFT', anchor, 'TOPLEFT', 0, anchorOffset )
    end
    anchor = MultiBarBottomLeft
    anchorOffset = 4
  else
    anchor = ActionButton1
  end

  if MultiBarBottomRight:IsShown() then
    --print( 'MultiBarBottomRight' )
    MultiBarBottomRight:ClearAllPoints()
    MultiBarBottomRight:SetPoint( 'BOTTOMLEFT', anchor, 'TOPLEFT', 0, anchorOffset )
    anchor = MultiBarBottomRight
    anchorOffset = 4
  end

  if PetActionBarFrame:IsShown() then
    --print( 'PetActionBarFrame' )
    PetActionButton1:ClearAllPoints()
    PetActionButton1:SetPoint( 'BOTTOMLEFT', anchor, 'TOPLEFT',  initialOffset, anchorOffset )
    anchor = PetActionButton1
    anchorOffset = 4
  end

  if StanceBarFrame:IsShown() then
    StanceButton1:ClearAllPoints()
    StanceButton1:SetPoint( 'BOTTOMLEFT', anchor, 'TOPLEFT', 0, anchorOffset )
    anchor = StanceButton1
    anchorOffset = 4
  end

  PossessBarFrame:ClearAllPoints()
  PossessBarFrame:SetPoint( 'BOTTOMLEFT', anchor, 'TOPLEFT', 0, anchorOffset )
end


function SetSidebarAlpha()
  local Alpha = 0
  if MouseInSidebar or ButtonGridIsShown or not AutoHideSideBar then Alpha = 1 end
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
  if not UnitHasVehicleUI( 'player' ) then
    CharacterMicroButton:ClearAllPoints()
    CharacterMicroButton:SetPoint( 'BOTTOMRIGHT', CornerMenuFrame.MicroButtons, 'BOTTOMRIGHT', -270, 0 )
    for i, name in pairs( MenuButtonFrames ) do name:SetParent( CornerMenuFrame.MicroButtons ) end
  end
end

local function ConfigureSideBars()
  local l=MultiBarLeft
  local r=MultiBarRight
  l:ClearAllPoints()
  r:ClearAllPoints()
  --r:SetPoint( 'BOTTOMRIGHT', WorldFrame, 'BOTTOMRIGHT' )
  r:SetPoint( 'TOPRIGHT', MinimapCluster, 'BOTTOMRIGHT', 0, -10 )
  l:SetPoint( 'BOTTOMRIGHT', r, 'BOTTOMLEFT' )
  -- Right Bar
  if MultiBarRight:IsShown() then
    -- Doing this somehow reduces the height of the objective tracker, showing only a few items.
    --_G[ 'ObjectiveTrackerFrame' ]:ClearAllPoints()
    _G[ 'ObjectiveTrackerFrame' ]:SetPoint( 'TOPRIGHT', TidyBar_SideBarMouseoverFrame, 'TOPLEFT' )
    SideMouseoverFrame:Show()
    MultiBarRight:EnableMouse()
    SideMouseoverFrame:SetPoint( 'BOTTOMRIGHT', MultiBarRight, 'BOTTOMRIGHT', 0,0 )
    -- Right Bar 2
    if MultiBarLeft:IsShown() then
      MultiBarLeft:EnableMouse()
         SideMouseoverFrame:SetPoint( 'TOPLEFT', MultiBarLeft,  'TOPLEFT', -6,0 )
    else SideMouseoverFrame:SetPoint( 'TOPLEFT', MultiBarRight, 'TOPLEFT', -6,0 ) end
  else
    SideMouseoverFrame:Hide()
    -- Move it to the right
    _G[ 'ObjectiveTrackerFrame' ]:ClearAllPoints()
    _G[ 'ObjectiveTrackerFrame' ]:SetPoint( 'TOPRIGHT', Minimap, 'BOTTOMRIGHT' )
  end
end


local function RefreshExperienceBars()
  --
  --  Hiding bits
  --

  -- The fiddly bits on the main bar
  MainMenuBarPageNumber:Hide()
  ActionBarUpButton:Hide()
  ActionBarDownButton:Hide()

  if HideGryphons == true then
    MainMenuBarLeftEndCap:Hide()
    MainMenuBarRightEndCap:Hide()
  end
  
  -- The XP bar
  --MainMenuBarTexture1:SetTexture( Empty_Art )
  --MainMenuBarTexture0:SetTexture( Empty_Art )
  ReputationWatchBar.StatusBar.XPBarTexture0:SetAlpha( 0 )
  ReputationWatchBar.StatusBar.XPBarTexture1:SetAlpha( 0 )
  for i=1,19 do _G[ 'MainMenuXPBarDiv' .. i ]:SetTexture( Empty_Art ) end
  -- The experience bar 'bubbles' texture that hangs off of the right.
  MainMenuBarTexture2:SetTexture( Empty_Art )
  MainMenuBarTexture3:SetTexture( Empty_Art )
  ReputationWatchBar.StatusBar.XPBarTexture2:SetAlpha( 0 )
  ReputationWatchBar.StatusBar.XPBarTexture3:SetAlpha( 0 )
  -- Hiding the grey background
  --ReputationWatchBar.StatusBar.Background:Hide()

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

  -- The nagging talent popup
  TalentMicroButtonAlert:Hide()
  TalentMicroButtonAlert:SetAlpha( 0 )

  MainMenuBarMaxLevelBar:Hide()
  MainMenuBarMaxLevelBar:SetAlpha( 0 )

  if HideActionBarButtonsTexturedBackground == true then
    MainMenuBarTexture0:SetAlpha( 0 )
    MainMenuBarTexture1:SetAlpha( 0 )
    MainMenuBarTexture0:Hide()
    MainMenuBarTexture1:Hide()
    -- Show them initially
    --for i=1,12 do _G[ 'ActionButton' .. i ]:Show() end
    -- Keep them updated
    MainMenuBar:SetScript( 'OnUpdate', function() for i=1,12 do _G[ 'ActionButton' .. i ]:Show() end end )


-- FIXME - When the mouse enters an empty button, it is hidden.  I have no idea how to fix this..

--ActionButton3:SetTexture( Empty_Art )
--ActionButton3:SetTexture( MultiBarBottomLeftButton1FloatingBG:GetTexture() )

--function showthemall()
  --for i=1,12 do
    --_G[ 'ActionButton' .. i ]:Show()
  --end
--end
--MainMenuBar:SetScript( 'OnUpdate', showthemall )
--MainMenuBarOverlayFrame:SetScript( 'OnUpdate', showthemall )
--MainMenuBarArtFrame:SetScript( 'OnUpdate', showthemall )
--MainMenuBar:SetScript( 'OnEnter', showthemall )
--MainMenuBar:SetScript( 'OnLeave', showthemall )
--MainMenuBar:SetScript( 'OnShow', showthemall )
--MainMenuBar:SetScript( 'OnHide', showthemall )

--WorldFrame:SetScript( 'OnUpdate', function() for i=1,12 do _G[ 'ActionButton' .. i ]:Show() end end )

--OnChar (self,text)
--OnDragStart (self,button)
--OnDragStop (self)
--OnEnter (self, motion)
--OnEvent (self,event,...)
--OnHide (self)
--OnKeyDown (self,key)
--OnKeyUp (self,key)
--OnLeave (self, motion)
--OnLoad (self)
--OnMouseDown (self,button)
--OnMouseUp (self,button)
--OnMouseWheel (self,delta)
--OnReceiveDrag (self)
--OnShow (self)
--OnSizeChanged (self,w,h)
--OnUpdate (self,elapsed) 

--ActionButton3NormalTexture:SetScript( 'OnUpdate', showthemall )


  end


  --
  --  Other actions
  --

  -- Repositions the bubbles for the Rep Watch bar
  if ReputationWatchBar:IsShown() then
    ReputationWatchBar.StatusBar.WatchBarTexture0:ClearAllPoints()
    ReputationWatchBar.StatusBar.WatchBarTexture0:SetPoint( 'LEFT', ReputationWatchBar, 'LEFT', 0, 2 )
  end
end

local function RefreshPositions()
  if InCombatLockdown() then return end
  -- Change the size of the central button and status bars

  -- This is the right-hand side.
  if HideActionBarButtonsTexturedBackground == true then
    MainMenuExpBar:SetWidth( 500 )
    MainMenuBar:SetWidth( 500 )
    ReputationWatchBar:SetWidth( 500 )
    ReputationWatchBar.StatusBar:SetWidth( 500 )
  else
    -- Original code
    MainMenuExpBar:SetWidth( 512 )
    MainMenuBar:SetWidth( 512 )
    ReputationWatchBar:SetWidth( 512 )
    ReputationWatchBar.StatusBar:SetWidth( 512 )
  end

  ConfigureSideBars()
  RefreshMainActionBars()
  ConfigureCornerBars()
  RefreshExperienceBars()
end


-- Event Handlers
local events = {}

function events:ACTIONBAR_SHOWGRID() ButtonGridIsShown = true;  SetSidebarAlpha() end
function events:ACTIONBAR_HIDEGRID() ButtonGridIsShown = false; SetSidebarAlpha() end
function events:UNIT_EXITED_VEHICLE()  RefreshPositions(); DelayEvent( ConfigureCornerBars, GetTime() + 1 ) end    -- Echos the event to verify positions
events.PLAYER_ENTERING_WORLD       = RefreshPositions
events.UPDATE_INSTANCE_INFO        = RefreshPositions
events.PLAYER_TALENT_UPDATE        = RefreshPositions
events.ACTIVE_TALENT_GROUP_CHANGED = RefreshPositions
events.SPELL_UPDATE_USEABLE        = RefreshPositions
events.PET_BAR_UPDATE              = RefreshPositions
events.UNIT_ENTERED_VEHICLE        = RefreshPositions
events.UPDATE_BONUS_ACTIONBAR      = RefreshPositions
events.UPDATE_MULTI_CAST_ACTIONBAR = RefreshPositions
events.PLAYER_LEVEL_UP             = RefreshPositions
events.UPDATE_SHAPESHIFT_FORM      = RefreshPositions
events.PLAYER_GAINS_VEHICLE_DATA   = RefreshPositions
events.PLAYER_LOSES_VEHICLE_DATA   = RefreshPositions
events.UPDATE_VEHICLE_ACTIONBAR    = RefreshPositions
events.QUEST_WATCH_UPDATE          = RefreshPositions
events.UNIT_AURA                   = RefreshPositions


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


--
--  Menu Menu and Artwork
--
do
  -- Call Update Function when the default UI makes changes
  hooksecurefunc( 'UIParent_ManageFramePositions', RefreshPositions )
  -- Required in order to move the frames around
  UIPARENT_MANAGED_FRAME_POSITIONS[ 'MultiBarBottomRight' ]     = nil
  UIPARENT_MANAGED_FRAME_POSITIONS[ 'PetActionBarFrame' ]       = nil
  UIPARENT_MANAGED_FRAME_POSITIONS[ 'ShapeshiftBarFrame' ]      = nil
  UIPARENT_MANAGED_FRAME_POSITIONS[ 'PossessBarFrame' ]         = nil
  UIPARENT_MANAGED_FRAME_POSITIONS[ 'MultiCastActionBarFrame' ] = nil


  -- Scaling
    MainMenuBar:SetScale( TidyBarScale )
  MultiBarRight:SetScale( TidyBarScale )
   MultiBarLeft:SetScale( TidyBarScale )
  
  MainMenuBarTexture0:SetPoint( 'LEFT',  MainMenuBar, 'LEFT',    0, 0 )
  MainMenuBarTexture1:SetPoint( 'RIGHT', MainMenuBar, 'RIGHT',   0, 0 )

  RefreshExperienceBars()
  
  -- Set Pet Bars
  PetActionBarFrame:SetAttribute( 'unit', 'pet' )
  RegisterUnitWatch( PetActionBarFrame )
  
  -- Set Mouseovers
  ConfigureSideBars()
  SetSidebarAlpha()
  ConfigureCornerBars()
  CornerMenuFrame:SetAlpha( 0 )
  
  if HideMainButtonArt == true then
    MainMenuBarTexture0:Hide()
    MainMenuBarTexture1:Hide()
  end
  
  MainMenuBar:HookScript( 'OnShow', function()
    --print( 'Showing' )
    RefreshPositions()
  end)
end

--
--  Side Action Bars
--
do
  -- Setup the Side Action Bars
  SideMouseoverFrame:SetScript( 'OnEnter', function() MouseInSidebar = true; SetSidebarAlpha() end )
  SideMouseoverFrame:SetScript( 'OnLeave', function() MouseInSidebar = false;SetSidebarAlpha() end )
  SideMouseoverFrame:EnableMouse()
  HookFrame_SideBar( MultiBarRight )
  HookFrame_SideBar( MultiBarLeft )
  for i = 1, 12 do HookFrame_SideBar( _G[ 'MultiBarRightButton'..i ] ) end
  for i = 1, 12 do HookFrame_SideBar( _G[ 'MultiBarLeftButton' ..i ] ) end
end

--
--  Corner Menu
--
do
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
  CornerMenuFrame:SetScale( TidyBarScale )
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

-- Start Tidy Bar
TidyBar:SetScript( 'OnEvent', EventHandler )
TidyBar:SetFrameStrata( 'TOOLTIP' )
TidyBar:Show()

SLASH_TIDYBAR1 = '/tidybar'
SlashCmdList[ 'TIDYBAR' ] = RefreshPositions
