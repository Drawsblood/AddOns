--[[
##############################################################################
_____/\\\\\\\\\\\____/\\\________/\\\__/\\\________/\\\__/\\\\\\\\\\\_       #
 ___/\\\/////////\\\_\/\\\_______\/\\\_\/\\\_______\/\\\_\/////\\\///__      #
  __\//\\\______\///__\//\\\______/\\\__\/\\\_______\/\\\_____\/\\\_____     #
   ___\////\\\__________\//\\\____/\\\___\/\\\_______\/\\\_____\/\\\_____    #
    ______\////\\\________\//\\\__/\\\____\/\\\_______\/\\\_____\/\\\_____   #
     _________\////\\\______\//\\\/\\\_____\/\\\_______\/\\\_____\/\\\_____  #
      __/\\\______\//\\\______\//\\\\\______\//\\\______/\\\______\/\\\_____ #
       _\///\\\\\\\\\\\/________\//\\\________\///\\\\\\\\\/____/\\\\\\\\\\\_#
        ___\///////////___________\///___________\/////////_____\///////////_#
##############################################################################
S U P E R - V I L L A I N - U I   By: Munglunch                              #
##############################################################################
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack    = _G.unpack;
local select    = _G.select;
local pairs     = _G.pairs;
local ipairs    = _G.ipairs;
local type      = _G.type;
local error     = _G.error;
local pcall     = _G.pcall;
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local string 	= _G.string;
local math 		= _G.math;
--[[ STRING METHODS ]]--
local format, split = string.format, string.split;
--[[ MATH METHODS ]]--
local min, floor = math.min, math.floor;
local parsefloat = math.parsefloat;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L;

local Dragger = CreateFrame("Frame", nil);
Dragger.Frames = {};


local UIPanels = {};

UIPanels["AchievementFrame"] 				= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["AuctionFrame"] 					= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["ArchaeologyFrame"] 				= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["BattlefieldMinimap"] 				= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = true };
UIPanels["BarberShopFrame"] 				= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["BlackMarketFrame"] 				= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["CalendarFrame"] 					= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = true };
UIPanels["CharacterFrame"] 					= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["ClassTrainerFrame"] 				= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["DressUpFrame"] 					= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
--UIPanels["DraenorZoneAbilityFrame"] 		= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["EncounterJournal"] 				= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["FriendsFrame"] 					= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["GMSurveyFrame"] 					= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = true };
UIPanels["GossipFrame"] 					= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["GuildFrame"] 						= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["GuildBankFrame"] 					= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["GuildRegistrarFrame"] 			= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["GarrisonLandingPage"] 			= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = true };
UIPanels["GarrisonMissionFrame"] 			= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = true };
UIPanels["GarrisonBuildingFrame"] 			= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = true };
UIPanels["GarrisonCapacitiveDisplayFrame"]  = { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["HelpFrame"] 						= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = true };
UIPanels["InterfaceOptionsFrame"] 			= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = true };
UIPanels["ItemUpgradeFrame"]				= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["KeyBindingFrame"] 				= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = true };
UIPanels["LFGDungeonReadyPopup"] 			= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = true };
UIPanels["MacOptionsFrame"] 				= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = true };
UIPanels["MacroFrame"] 						= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["MailFrame"] 						= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["MerchantFrame"] 					= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["PlayerTalentFrame"] 				= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["PetJournalParent"] 				= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["PetStableFrame"] 					= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["PVEFrame"] 						= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["PVPFrame"] 						= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["QuestFrame"] 						= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["QuestLogFrame"] 					= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["RaidBrowserFrame"] 				= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["ReadyCheckFrame"] 				= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = true };
UIPanels["ReforgingFrame"] 					= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["ReportCheatingDialog"] 			= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["ReportPlayerNameDialog"] 			= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["RolePollPopup"] 					= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = true };
UIPanels["SpellBookFrame"] 					= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["TabardFrame"] 					= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["TaxiFrame"] 						= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["TimeManagerFrame"] 				= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["TradeSkillFrame"] 				= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["TradeFrame"] 						= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["TransmogrifyFrame"] 				= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
UIPanels["TutorialFrame"] 					= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = true };
UIPanels["VideoOptionsFrame"] 				= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = true };
UIPanels["VoidStorageFrame"] 				= { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };

UIPanels["ScrollOfResurrectionSelectionFrame"] = { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function SetDraggablePoint(frame, data)
	if((not frame) or (not data)) then return; end
	local frameName = frame:GetName()
	local point = Dragger.Frames[frameName];
	if(point and (type(point) == "string") and (point ~= 'TBD')) then
		local anchor1, parent, anchor2, x, y = split("\031", point);
		data.cansetpoint = true;
		data.snapped = false;
		frame:ClearAllPoints();
		frame:SetPoint(anchor1, parent, anchor2, x, y);
	end
end

local function SaveCurrentPosition(frame)
	if not frame then return end 
	local frameName = frame:GetName()
	local anchor1, parent, anchor2, x, y = frame:GetPoint()
	if((not anchor1) or (not anchor2) or (not x) or (not y)) then
		Dragger.Frames[frameName] = "TBD";
	else
		local parentName
		if(not parent or (parent and (not parent:GetName()))) then 
			parentName = "UIParent" 
		else
			parentName = parent:GetName()
		end
		Dragger.Frames[frameName] = ("%s\031%s\031%s\031%d\031%d"):format(anchor1, parentName, anchor2, parsefloat(x), parsefloat(y))
	end
end
--[[ 
########################################################## 
SCRIPT AND EVENT HANDLERS
##########################################################
]]--
local DraggerFrame_OnDragStart = function(self)
	if(not self:IsMovable()) then return; end 
	self:StartMoving();
	local data = UIPanels[self:GetName()];
	if(data) then
		data.moving = true;
		data.snapped = false;
		data.canupdate = false;
	end
end

local DraggerFrame_OnDragStop = function(self)
	if(not self:IsMovable()) then return; end
	self:StopMovingOrSizing();
	local data = UIPanels[self:GetName()];
	if(data) then
		data.moving = false;
		data.snapped = false;
		data.canupdate = true;
		SaveCurrentPosition(self);
	end
end

local _hook_DraggerFrame_OnShow = function(self)
	if(InCombatLockdown() or (not self:IsMovable())) then return; end
	local data = UIPanels[self:GetName()];
	if(data and (not data.snapped)) then
		SetDraggablePoint(self, data)
	end
end

local _hook_DraggerFrame_OnHide = function(self)
	if(InCombatLockdown() or (not self:IsMovable())) then return; end
	local data = UIPanels[self:GetName()];
	if(data) then
		data.moving = false;
		data.snapped = false;
		data.canupdate = true;
	end
end

local _hook_DraggerFrame_OnUpdate = function(self)
	if(InCombatLockdown()) then return; end
	local data = UIPanels[self:GetName()];
	if(data and (not data.moving) and (not data.snapped)) then
		SetDraggablePoint(self, data)
	end
end

local _hook_DraggerFrame_OnSetPoint = function(self)
	if(not self:IsMovable()) then return; end
	local data = UIPanels[self:GetName()];
	if(data and (not data.moving)) then
		if(not data.cansetpoint) then
			data.snapped = true;
			data.canupdate = false;
		end
	end
end

local _hook_UIParent_ManageFramePositions = function()
	for frameName, point in pairs(Dragger.Frames) do
		local data = UIPanels[frameName]
		if(data and (not data.snapped)) then
			SetDraggablePoint(_G[frameName], data)
		end
	end
end

local DraggerEventHandler = function(self, event, ...)
	if(InCombatLockdown()) then return end

	local noMoreChanges = true;
	local allCentered = SV.db.general.multiMonitor

	for frameName, data in pairs(UIPanels) do
		if(not self.Frames[frameName] or (self.Frames[frameName] and type(self.Frames[frameName]) ~= 'string')) then
			self.Frames[frameName] = 'TBD'
			noMoreChanges = false; 
		end
		if(not data.initialized) then 
			local frame = _G[frameName]
			if(frame) then
				frame:EnableMouse(true)

				if(frameName == "LFGDungeonReadyPopup") then 
					LFGDungeonReadyDialog:EnableMouse(false)
				end

				frame:SetMovable(true)
				frame:RegisterForDrag("LeftButton")
				frame:SetClampedToScreen(true)

				if(allCentered) then
					frame:ClearAllPoints()
					frame:SetPoint('TOP', SV.Screen, 'TOP', 0, -180)
					data.centered = true
				end

				if(self.Frames[frameName] == 'TBD') then
					SaveCurrentPosition(frame);
				end

				data.canupdate = true

				frame:SetScript("OnDragStart", DraggerFrame_OnDragStart)
				frame:SetScript("OnDragStop", DraggerFrame_OnDragStop)

				frame:HookScript("OnUpdate", _hook_DraggerFrame_OnUpdate)
				hooksecurefunc(frame, "SetPoint", _hook_DraggerFrame_OnSetPoint)

				if(SV.db.general.saveDraggable) then
					frame:HookScript("OnShow", _hook_DraggerFrame_OnShow)
					frame:HookScript("OnHide", _hook_DraggerFrame_OnHide)
				end

				data.initialized = true
			end
			noMoreChanges = false;
		end
	end

	if(noMoreChanges) then
		self.EventsActive = false;
		self:UnregisterEvent("ADDON_LOADED")
		self:UnregisterEvent("LFG_UPDATE")
		self:UnregisterEvent("ROLE_POLL_BEGIN")
		self:UnregisterEvent("READY_CHECK")
		self:UnregisterEvent("UPDATE_WORLD_STATES")
		self:UnregisterEvent("WORLD_STATE_TIMER_START")
		self:UnregisterEvent("WORLD_STATE_UI_TIMER_UPDATE")
		self:SetScript("OnEvent", nil)
	end
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function Dragger:New(frameName)
	if(not UIPanels[frameName]) then 
		UIPanels[frameName] = { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
		if(not self.EventsActive) then
			self:RegisterEvent("ADDON_LOADED")
			self:RegisterEvent("LFG_UPDATE")
			self:RegisterEvent("ROLE_POLL_BEGIN")
			self:RegisterEvent("READY_CHECK")
			self:RegisterEvent("UPDATE_WORLD_STATES")
			self:RegisterEvent("WORLD_STATE_TIMER_START")
			self:RegisterEvent("WORLD_STATE_UI_TIMER_UPDATE")
			self:SetScript("OnEvent", DraggerEventHandler)
			self.EventsActive = true;
		end
	end
end

function Dragger:SetPositions()
	for frameName, point in pairs(Dragger.Frames) do
		local data = UIPanels[frameName]
		if(data and (not data.snapped)) then
			SetDraggablePoint(_G[frameName], point, data)
		end
	end
end

function Dragger:Reset()
	if(SV.db.general.saveDraggable) then
		for frameName, data in pairs(UIPanels) do
			if(SV.cache.Draggables[frameName]) then
				SV.cache.Draggables[frameName] = nil
			end
			data.initialized = nil
		end
		self.Frames = SV.cache.Draggables
	else
		for frameName, data in pairs(UIPanels) do
			if(self.Frames[frameName]) then
				self.Frames[frameName] = nil
			end
			data.initialized = nil
		end
	end

	if(not self.EventsActive) then
		self:RegisterEvent("ADDON_LOADED")
		self:RegisterEvent("LFG_UPDATE")
		self:RegisterEvent("ROLE_POLL_BEGIN")
		self:RegisterEvent("READY_CHECK")
		self:RegisterEvent("UPDATE_WORLD_STATES")
		self:RegisterEvent("WORLD_STATE_TIMER_START")
		self:RegisterEvent("WORLD_STATE_UI_TIMER_UPDATE")
		self:SetScript("OnEvent", DraggerEventHandler)
		self.EventsActive = true;
	end

	ReloadUI() 
end
--[[ 
########################################################## 
INITIALIZE
##########################################################
]]--
function Dragger:Initialize()
	if(SV.db.general.saveDraggable) then
		SV.cache.Draggables = SV.cache.Draggables or {}
		self.Frames = SV.cache.Draggables
	else
		SV.cache.Draggables = {}
		self.Frames = {}
	end

	if(not SV.db.SVQuest.enable) then
		UIPanels["ObjectiveTrackerFrame"] = { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
	end
	-- if(SV.db.SVMap.tinyWorldMap) then
	-- 	UIPanels["WorldMapFrame"] = { moving = false, snapped = false, canupdate = false, cansetpoint = false, centered = false };
	-- 	WorldMapTitleButton:EnableMouse(false)
	-- end

	self.EventsActive = true

	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("LFG_UPDATE")
	self:RegisterEvent("ROLE_POLL_BEGIN")
	self:RegisterEvent("READY_CHECK")
	self:RegisterEvent("UPDATE_WORLD_STATES")
	self:RegisterEvent("WORLD_STATE_TIMER_START")
	self:RegisterEvent("WORLD_STATE_UI_TIMER_UPDATE")

	DraggerEventHandler(self)
	self:SetScript("OnEvent", DraggerEventHandler)

	if(SV.db.general.saveDraggable) then
		hooksecurefunc("UIParent_ManageFramePositions", _hook_UIParent_ManageFramePositions)
	end
end

SV.Dragger = Dragger;