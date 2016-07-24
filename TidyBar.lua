--[[
Tidy Bar
for WoW 7.0.3 WoD final patch.
--]]


-- Tidy Bar
local TidyBarScale = 1
local HideMainButtonArt = false
local HideExperienceBar = false

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
local Corner_Artwork_Texture = "Interface\\Addons\\TidyBar\\Empty"
local Empty_Art              = "Interface\\Addons\\TidyBar\\Empty"
local MouseInSidebar, MouseInCorner = false

local TidyBar              = CreateFrame( 'Frame', 'TidyBar', WorldFrame )
local CornerMenuFrame      = CreateFrame( 'Frame', 'TidyBar_CornerMenuFrame',         UIParent )
local SideMouseoverFrame   = CreateFrame( 'Frame', 'TidyBar_SideBarMouseoverFrame',   UIParent )
local CornerMouseoverFrame = CreateFrame( 'Frame', 'TidyBar_CornerBarMouseoverFrame', UIParent )

local SetSidebarAlpha

CornerMenuFrame:SetFrameStrata( 'LOW' )
CornerMenuFrame:SetWidth(300)
CornerMenuFrame:SetHeight(128)
CornerMenuFrame:SetPoint( 'BOTTOMRIGHT' )
CornerMenuFrame:SetScale(TidyBarScale)

CornerMenuFrame.Texture = CornerMenuFrame:CreateTexture( nil, 'BACKGROUND' )
CornerMenuFrame.Texture:SetTexture(Corner_Artwork_Texture)
CornerMenuFrame.Texture:SetPoint( 'BOTTOMRIGHT' )
CornerMenuFrame.Texture:SetWidth(  512*1.09 )
CornerMenuFrame.Texture:SetHeight( 128*1.09 )

CornerMenuFrame.MicroButtons   = CreateFrame( 'Frame', nil, CornerMenuFrame )
CornerMenuFrame.BagButtonFrame = CreateFrame( 'Frame', nil, CornerMenuFrame )

-- Event Delay
local DelayedEventWatcher = CreateFrame( 'Frame' )
local DelayedEvents = {}
local function CheckDelayedEvent(self)
  local pendingEvents, currentTime = 0, GetTime()
  for functionToCall, timeToCall in pairs(DelayedEvents) do
    if currentTime > timeToCall then
      DelayedEvents[functionToCall] = nil
      functionToCall()
    end
  end
  -- Check afterward to prevent missing a recall
  for functionToCall, timeToCall in pairs(DelayedEvents) do pendingEvents = pendingEvents + 1 end
  if pendingEvents == 0 then DelayedEventWatcher:SetScript( 'OnUpdate', nil ) end
end
local function DelayEvent(functionToCall, timeToCall)
  DelayedEvents[functionToCall] = timeToCall
  DelayedEventWatcher:SetScript( 'OnUpdate', CheckDelayedEvent )
end
-- Event Delay

local function ForceTransparent(frame)
  frame:Hide()
  frame:SetAlpha(0)
end

local function RefreshMainActionBars()
  local anchor = ActionButton1
  local anchorOffset = 8
  local reputationBarOffset = 16
  local initialOffset = 32
  
  -- [[
  -- Hides Rep Bars
  if HideExperienceBar == true or HideMainButtonArt == true then
    print( 'XP Bar Hidden' )
    MainMenuXPBar:Hide()
    MainMenuXPBar:SetHeight(.001)
    ReputationWatchBar:Hide()
    ReputationWatchBar:SetHeight(.001)
  end
  --]]
  
  --HideExperienceBar
  
  if MainMenuXPBar:IsShown() then
    --reputationBarOffset = 9
    anchorOffset = 16
  end
  if ReputationWatchBar:IsShown() then
    --reputationBarOffset = reputationBarOffset + 9
    anchorOffset = 25
  end
  
  reputationBarOffset = anchorOffset
  
  if MultiBarBottomLeft:IsShown() then
    MultiBarBottomLeft:ClearAllPoints()
    MultiBarBottomLeft:SetPoint( 'BOTTOMLEFT', anchor, 'TOPLEFT', 0, anchorOffset )
    anchor = MultiBarBottomLeft
    anchorOffset = 4
  else
    anchor = ActionButton1
    anchorOffset = 8 + reputationBarOffset
  end
  
  if MultiBarBottomRight:IsShown() then
    --print( 'MultiBarBottomRight' )
    MultiBarBottomRight:ClearAllPoints()
    MultiBarBottomRight:SetPoint( 'BOTTOMLEFT', anchor, 'TOPLEFT', 0, anchorOffset )
    anchor = MultiBarBottomRight
    anchorOffset = 4
  end
  
  -- PetActionBarFrame, PetActionButton1
  if PetActionBarFrame:IsShown() then
    --print( 'PetActionBarFrame' )
    PetActionButton1:ClearAllPoints()
    PetActionButton1:SetPoint( 'BOTTOMLEFT', anchor, 'TOPLEFT',  initialOffset, anchorOffset )
    anchor = PetActionButton1
    anchorOffset = 4
  end
  
  -- [[ StanceBarFrame
  if StanceBarFrame:IsShown() then
    --print( 'StanceBarFrame' )
    StanceButton1:ClearAllPoints()
    StanceButton1:SetPoint( 'BOTTOMLEFT', anchor, 'TOPLEFT', 0, anchorOffset )
    anchor = StanceButton1
    anchorOffset = 4
  end
  --]]
  
  -- PossessBarFrame, PossessButton1
  PossessBarFrame:ClearAllPoints()
  PossessBarFrame:SetPoint( 'BOTTOMLEFT', anchor, 'TOPLEFT', 0, anchorOffset )
end


function SetSidebarAlpha()
  local Alpha = 0
  if MouseInSidebar or ButtonGridIsShown then Alpha = 1 end
  if SpellFlyout:IsShown() then
    DelayEvent(SetSidebarAlpha, GetTime()+.5)
  else
    for i = 1, 12 do
      _G['MultiBarRightButton'..i ]:SetAlpha( Alpha )
      _G['MultiBarLeftButton' ..i ]:SetAlpha( Alpha )
      -- Also hide the grey cooldown background.
      _G['MultiBarRightButton' .. i .. 'Cooldown']:Hide()
      _G['MultiBarLeftButton'  .. i .. 'Cooldown']:Hide()
    end
  end
  
end

local function HookFrame_Microbuttons(frameTarget)
  frameTarget:HookScript( 'OnEnter', function() if not UnitHasVehicleUI( 'player' ) then CornerMenuFrame:SetAlpha(1) end end )
  frameTarget:HookScript( 'OnLeave', function()                                          CornerMenuFrame:SetAlpha(0) end )
end

local function HookFrame_CornerBar(frameTarget)
  frameTarget:HookScript( 'OnEnter', function() CornerMenuFrame:SetAlpha(1) end )
  frameTarget:HookScript( 'OnLeave', function() CornerMenuFrame:SetAlpha(0) end )
end

local function HookFrame_SideBar(frameTarget)
  frameTarget:HookScript( 'OnEnter', function() MouseInSidebar = true;  SetSidebarAlpha() end )
  frameTarget:HookScript( 'OnLeave', function() MouseInSidebar = false; SetSidebarAlpha() end )
end

local function ConfigureCornerBars()
  if not UnitHasVehicleUI( 'player' ) then
    CharacterMicroButton:ClearAllPoints()
    CharacterMicroButton:SetPoint('BOTTOMRIGHT', CornerMenuFrame.MicroButtons, 'BOTTOMRIGHT', -270, 0)
    for i, name in pairs(MenuButtonFrames) do name:SetParent(CornerMenuFrame.MicroButtons) end
  end
end

local function ConfigureSideBars()
  local l=MultiBarLeft
  local r=MultiBarRight
  l:ClearAllPoints()
  r:ClearAllPoints()
  --r:SetPoint( 'BOTTOMRIGHT', WorldFrame, 'BOTTOMRIGHT' )
  r:SetPoint( 'BOTTOMRIGHT', TidyBar_CornerBarMouseoverFrame, 'TOPRIGHT', 0, -10 )
  l:SetPoint( 'BOTTOMRIGHT', r, 'BOTTOMLEFT' )
  -- Right Bar
  if MultiBarRight:IsShown() then
    _G[ 'ObjectiveTrackerFrame' ]:ClearAllPoints()
    _G[ 'ObjectiveTrackerFrame' ]:SetPoint( 'TOPRIGHT', TidyBar_SideBarMouseoverFrame, 'TOPLEFT' )
    SideMouseoverFrame:Show()
    MultiBarRight:EnableMouse()
    SideMouseoverFrame:SetPoint( 'BOTTOMRIGHT', MultiBarRight, 'BOTTOMRIGHT', 0,0 )
    -- Right Bar 2
    if MultiBarLeft:IsShown() then
      MultiBarLeft:EnableMouse()
         SideMouseoverFrame:SetPoint('TOPLEFT', MultiBarLeft,  'TOPLEFT', -6,0 )
    else SideMouseoverFrame:SetPoint('TOPLEFT', MultiBarRight, 'TOPLEFT', -6,0 ) end
  else
    SideMouseoverFrame:Hide()
    -- Move it to the right
    _G[ 'ObjectiveTrackerFrame' ]:ClearAllPoints()
    _G[ 'ObjectiveTrackerFrame' ]:SetPoint( 'TOPRIGHT', Minimap, 'BOTTOMRIGHT' )
    
    -- Also move the frame header minimize/maximize button .
    _G[ 'ObjectiveTrackerFrame' ].HeaderMenu.MinimizeButton:ClearAllPoints()
    _G[ 'ObjectiveTrackerFrame' ].HeaderMenu.MinimizeButton:SetPoint( 'TOPRIGHT', TidyBar_SideBarMouseoverFrame, 'TOPLEFT' )
  end
end


local function RefreshExperienceBars()
  
  -- Hide Unwanted Art
  MainMenuBarPageNumber:Hide()
  ActionBarUpButton:Hide()
  ActionBarDownButton:Hide()
  -- Experience Bar
  MainMenuBarTexture2:SetTexture( Empty_Art )
  MainMenuBarTexture3:SetTexture( Empty_Art )
  MainMenuBarTexture2:SetAlpha(0)
  MainMenuBarTexture3:SetAlpha(0)
  for i=1,19 do _G[ 'MainMenuXPBarDiv' .. i ]:SetTexture( Empty_Art ) end
  
  
  
  -- Hide Rested State
  ExhaustionLevelFillBar:SetTexture( Empty_Art )
  ExhaustionTick:SetAlpha(0)
  
  -- Max-level Rep Bar
  MainMenuMaxLevelBar0:SetAlpha(0)
  MainMenuMaxLevelBar1:SetAlpha(0)
  MainMenuMaxLevelBar2:SetAlpha(0)
  MainMenuMaxLevelBar3:SetAlpha(0)
  
  -- Rep Bar Bubbles (For the Rep Bar)
  --ReputationWatchBar.StatusBar.WatchBarTexture0:SetAlpha(0)
  ReputationWatchBar.StatusBar.WatchBarTexture1:SetAlpha(0)
  ReputationWatchBar.StatusBar.WatchBarTexture2:SetAlpha(0)
  --ReputationWatchBar.StatusBar.WatchBarTexture3:SetAlpha(0)
  
  -- Repositions the bubbles for the Rep Watch bar
  ReputationWatchBar.StatusBar.WatchBarTexture0:ClearAllPoints()
  ReputationWatchBar.StatusBar.WatchBarTexture0:SetPoint( 'LEFT', ReputationWatchBar, 'LEFT', 0, 2 )
  ReputationWatchBar.StatusBar.WatchBarTexture3:ClearAllPoints()
  ReputationWatchBar.StatusBar.WatchBarTexture3:SetPoint( 'LEFT', ReputationWatchBar.StatusBar.WatchBarTexture0, 'RIGHT' )
  
  -- Rep Bar Bubbles (for the XP bar?)
  MainMenuXPBarTextureMid:SetAlpha(0)
  
  --[[
    --local XPBarLeft = MainMenuXPBar:CreateTexture(nil, "OVERLAY")
    --local XPBarRight = MainMenuXPBar:CreateTexture(nil, "OVERLAY")

    local XPBarLeft = _G["MainMenuXPBarDiv1"]
    local XPBarRight = _G["MainMenuXPBarDiv2"]

    XPBarLeft:SetTexture("Interface\\PaperDollInfoFrame\\UI-ReputationWatchBar")
    XPBarLeft:SetSize(256, 10)
    XPBarLeft:SetPoint('TOPLEFT', MainMenuXPBar, 'TOPLEFT', 0, 100)

    XPBarRight:SetTexture(ReputationWatchBar.StatusBar.WatchBarTexture3:GetTexture())
    XPBarRight:SetSize(ReputationWatchBar.StatusBar.WatchBarTexture3:GetSize())
    XPBarRight:SetPoint( 'LEFT', XPBarLeft, 'RIGHT' )

    --]]
end

local function RefreshPositions()
  if InCombatLockdown() then return end
  -- Change the size of the central button and status bars
  MainMenuBar:SetWidth(512)
  MainMenuXPBar:SetWidth(512)
  ReputationWatchBar:SetWidth(512)
  MainMenuBarMaxLevelBar:SetWidth(512)
  ReputationWatchStatusBar:SetWidth(512)
  
  -- Hide backgrounds
  ForceTransparent(SlidingActionBarTexture0)
  ForceTransparent(SlidingActionBarTexture1)
  -- [[ Shapeshift, Aura, and Stance
  ForceTransparent(StanceBarLeft)
  ForceTransparent(StanceBarMiddle)
  ForceTransparent(StanceBarRight)
  
  if HideExperienceBar == true or HideMainButtonArt == true then
    
    ForceTransparent(MainMenuXPBarTextureLeftCap)
    ForceTransparent(MainMenuXPBarTextureRightCap)
    ForceTransparent(MainMenuXPBarTextureMid)
    
  end
  --]]
  ForceTransparent(PossessBackground1)
  ForceTransparent(PossessBackground2)
  
  ConfigureSideBars()
  RefreshMainActionBars()
  ConfigureCornerBars()
  RefreshExperienceBars()
end


-- Event Handlers
local events = {}

function events:ACTIONBAR_SHOWGRID() ButtonGridIsShown = true; SetSidebarAlpha() end
function events:ACTIONBAR_HIDEGRID() ButtonGridIsShown = false; SetSidebarAlpha() end
function events:UNIT_EXITED_VEHICLE()  RefreshPositions(); DelayEvent(ConfigureCornerBars, GetTime()+1) end    -- Echos the event to verify positions
events.PLAYER_ENTERING_WORLD = RefreshPositions
events.UPDATE_INSTANCE_INFO = RefreshPositions
events.PLAYER_TALENT_UPDATE = RefreshPositions
events.ACTIVE_TALENT_GROUP_CHANGED = RefreshPositions
events.SPELL_UPDATE_USEABLE = RefreshPositions
events.PET_BAR_UPDATE = RefreshPositions
events.UNIT_ENTERED_VEHICLE = RefreshPositions
events.UPDATE_BONUS_ACTIONBAR = RefreshPositions
events.UPDATE_MULTI_CAST_ACTIONBAR = RefreshPositions
events.CLOSE_WORLD_MAP = RefreshPositions
events.PLAYER_LEVEL_UP = RefreshPositions

events.UPDATE_SHAPESHIFT_FORM = RefreshPositions
events.PLAYER_GAINS_VEHICLE_DATA = RefreshPositions
events.PLAYER_LOSES_VEHICLE_DATA = RefreshPositions
events.UPDATE_VEHICLE_ACTIONBAR = RefreshPositions

events.QUEST_WATCH_UPDATE = RefreshPositions

--events.PLAYER_AURAS_CHANGED = RefreshPositions


local function EventHandler(frame, event)
  if events[event] then
    --print(GetTime(), event)
    events[event]()
  end
end

-- Set Event Monitoring
for eventname in pairs(events) do
  TidyBar:RegisterEvent(eventname)
end


-----------------------------------------------------------------------------
-- Menu Menu and Artwork
do
  -- Call Update Function when the default UI makes changes
  hooksecurefunc( 'UIParent_ManageFramePositions', RefreshPositions)
  -- Required in order to move the frames around
  UIPARENT_MANAGED_FRAME_POSITIONS[ 'MultiBarBottomRight' ]     = nil
  UIPARENT_MANAGED_FRAME_POSITIONS[ 'PetActionBarFrame' ]       = nil
  UIPARENT_MANAGED_FRAME_POSITIONS[ 'ShapeshiftBarFrame' ]      = nil
  UIPARENT_MANAGED_FRAME_POSITIONS[ 'PossessBarFrame' ]         = nil
  UIPARENT_MANAGED_FRAME_POSITIONS[ 'MultiCastActionBarFrame' ] = nil
  
  -- Scaling
  MainMenuBar:SetScale(TidyBarScale)
  MultiBarRight:SetScale(TidyBarScale)
  MultiBarLeft:SetScale(TidyBarScale)
  
  -- Adjust the fill and endcap artwork
     MainMenuBarTexture0:SetPoint( 'LEFT',  MainMenuBar, 'LEFT',    0, 0)
     MainMenuBarTexture1:SetPoint( 'RIGHT', MainMenuBar, 'RIGHT',   0, 0)
   MainMenuBarLeftEndCap:SetPoint( 'RIGHT', MainMenuBar, 'LEFT',   32, 0)
  MainMenuBarRightEndCap:SetPoint( 'LEFT',  MainMenuBar, 'RIGHT', -32, 0)
  
  -- Hide 'ring' around the stance/shapeshift buttons
  for i = 1, 10 do
    _G[ 'StanceButton'..i..'NormalTexture2' ]:SetTexture( Empty_Art )
  end
  
  RefreshExperienceBars()
  
  -- Set Pet Bars
  PetActionBarFrame:SetAttribute( 'unit', 'pet' )
  RegisterUnitWatch(PetActionBarFrame)
  
  -- Set Mouseovers
  ConfigureSideBars()
  SetSidebarAlpha()
  ConfigureCornerBars()
  CornerMenuFrame:SetAlpha(0)
  
  if HideMainButtonArt == true then
    -- Hide Standard Background Art
    MainMenuBarTexture0:Hide()
    MainMenuBarTexture1:Hide()
    MainMenuBarLeftEndCap:Hide()
    MainMenuBarRightEndCap:Hide()
  end
  
  MainMenuBar:HookScript("OnShow", function()
      --print("Showing")
      RefreshPositions()
  end)
end

-----------------------------------------------------------------------------
-- Side Action Bars
do
  -- Setup the Side Action Bars
  SideMouseoverFrame:SetScript( 'OnEnter', function() MouseInSidebar = true; SetSidebarAlpha() end )
  SideMouseoverFrame:SetScript( 'OnLeave', function() MouseInSidebar = false;SetSidebarAlpha() end )
  SideMouseoverFrame:EnableMouse()
  
  HookFrame_SideBar(MultiBarRight)
  HookFrame_SideBar(MultiBarLeft)
  for i = 1, 12 do HookFrame_SideBar( _G[ 'MultiBarRightButton'..i ] ) end
  for i = 1, 12 do HookFrame_SideBar( _G[ 'MultiBarLeftButton' ..i ] ) end
end

-----------------------------------------------------------------------------
-- Corner Menu
do
  -- Keyring etc
  for i, name in pairs(BagButtonFrameList) do
    name:SetParent(CornerMenuFrame.BagButtonFrame)
  end
  
  MainMenuBarBackpackButton:ClearAllPoints()
  MainMenuBarBackpackButton:SetPoint( 'BOTTOM' )
  MainMenuBarBackpackButton:SetPoint( 'RIGHT', -60, 0)
  --MainMenuBarBackpackButton:SetScale(.8)
  
  -- Setup the Corner Buttons
  for i, name in pairs( BagButtonFrameList ) do HookFrame_CornerBar(    name ) end
  for i, name in pairs( MenuButtonFrames   ) do HookFrame_Microbuttons( name ) end
  
  -- Setup the Corner Menu Artwork
  CornerMenuFrame:SetScale(TidyBarScale)
  CornerMenuFrame.MicroButtons:SetAllPoints(CornerMenuFrame)
  CornerMenuFrame.BagButtonFrame:SetPoint( 'TOPRIGHT', 2, -18 )
  CornerMenuFrame.BagButtonFrame:SetHeight( 64 )
  CornerMenuFrame.BagButtonFrame:SetWidth( 256 )
  CornerMenuFrame.BagButtonFrame:SetScale( 1.02 )
  
  -- Setup the Corner Menu Mouseover frame
  CornerMouseoverFrame:EnableMouse()
  CornerMouseoverFrame:SetFrameStrata( 'BACKGROUND' )
  
  CornerMouseoverFrame:SetPoint( 'TOP', MainMenuBarBackpackButton, 'TOP', 0,10 )
  CornerMouseoverFrame:SetPoint( 'RIGHT',  UIParent, 'RIGHT' )
  CornerMouseoverFrame:SetPoint( 'BOTTOM', UIParent, 'BOTTOM' )
  CornerMouseoverFrame:SetWidth( 322 )
  
  CornerMouseoverFrame:SetScript( 'OnEnter', function() CornerMenuFrame:SetAlpha(1) end )
  CornerMouseoverFrame:SetScript( 'OnLeave', function() CornerMenuFrame:SetAlpha(0) end )
end

-- Start Tidy Bar
TidyBar:SetScript( 'OnEvent', EventHandler)
TidyBar:SetFrameStrata( 'TOOLTIP' )
TidyBar:Show()

--[===[
-- TODO - this doesn't work.

SLASH_TIDYBAR1 = '/tidybar'
SlashCmdList['TIDYBAR'] = RefreshPositions;

function GetMouseoverFrame()
  local frame = EnumerateFrames(); -- Get the first frame
  while frame do
    if ( frame:IsVisible() and MouseIsOver(frame) ) then
      print(frame:GetName() or string.format("[Unnamed Frame: %s]", tostring(frame)), frame.this);
    end
    if frame and frame.GetObjectType then frame = EnumerateFrames(frame); -- Get the next frame
    else frame = nil end
  end
end;

SLASH_MFRAME1 = '/mframe'
SlashCmdList['mframe'] = GetMouseoverFrame
]===]
