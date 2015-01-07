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
local unpack        = _G.unpack;
local select        = _G.select;
local assert        = _G.assert;
local type          = _G.type;
local error         = _G.error;
local pcall         = _G.pcall;
local print         = _G.print;
local ipairs        = _G.ipairs;
local pairs         = _G.pairs;
local next          = _G.next;
local rawset        = _G.rawset;
local rawget        = _G.rawget;
local tostring      = _G.tostring;
local tonumber      = _G.tonumber;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
--[[ STRING METHODS ]]--
local find, format, len, split = string.find, string.format, string.len, string.split;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round, max = math.abs, math.ceil, math.floor, math.round, math.max;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L
local LSM = LibStub("LibSharedMedia-3.0")
local MOD = SV:NewPackage("SVOverride", "Overrides");
MOD.RollFrames = {};
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local NewHook = hooksecurefunc;
local BAILOUT_ICON = [[Interface\AddOns\SVUI\assets\artwork\Icons\EXIT]];

local SVUI_WorldStateHolder = CreateFrame("Frame", "SVUI_WorldStateHolder", UIParent)
SVUI_WorldStateHolder:SetPoint("TOP", SVUI_DockTopCenter, "BOTTOM", 0, -10)
SVUI_WorldStateHolder:SetSize(200, 45)

local SVUI_AltPowerBar = CreateFrame("Frame", "SVUI_AltPowerBar", UIParent)
SVUI_AltPowerBar:SetPoint("TOP", SVUI_DockTopCenter, "BOTTOM", 0, -60)
SVUI_AltPowerBar:SetSize(128, 50)

local SVUI_BailOut = CreateFrame("Button", "SVUI_BailOut", UIParent)
SVUI_BailOut:SetSize(30, 30)
SVUI_BailOut:SetPoint("TOP", SVUI_DockTopCenter, "BOTTOM", 0, -10)
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
local PVPRaidNoticeHandler = function(self, event, msg)
	local _, instanceType = IsInInstance()
	if((instanceType == 'pvp') or (instanceType == 'arena')) then
		RaidNotice_AddMessage(RaidBossEmoteFrame, msg, ChatTypeInfo["RAID_BOSS_EMOTE"]);
	end 
end 

local CaptureBarHandler = function()
	if(NUM_EXTENDED_UI_FRAMES) then
		local lastFrame = SVUI_WorldStateHolder
		local offset = 0;
		for i=1, NUM_EXTENDED_UI_FRAMES do
			local captureBar = _G["WorldStateCaptureBar"..i]
			if(captureBar and captureBar:IsVisible()) then
				captureBar:ClearAllPoints()
				captureBar:SetPointToScale("TOP", lastFrame, "TOP", 0, offset)
				lastFrame = captureBar
				offset = (-45 * i);
			end	
		end	
	end
end

local Vehicle_OnSetPoint = function(self, _, parent)
	if(parent == "MinimapCluster" or parent == _G["MinimapCluster"]) then 
		VehicleSeatIndicator:ClearAllPoints()
		if _G.VehicleSeatIndicator_MOVE then
			VehicleSeatIndicator:SetPointToScale("BOTTOM", VehicleSeatIndicator_MOVE, "BOTTOM", 0, 0)
		else
			VehicleSeatIndicator:SetPointToScale("TOPLEFT", SV.Dock.TopLeft, "TOPLEFT", 0, 0)
			SV.Mentalo:Add(VehicleSeatIndicator, L["Vehicle Seat Frame"])
		end 
		VehicleSeatIndicator:SetScale(0.8)
	end 
end

local Dura_OnSetPoint = function(self, _, parent)
	if((parent == "MinimapCluster") or (parent == _G["MinimapCluster"])) then
		self:ClearAllPoints()
		self:SetPointToScale("RIGHT", Minimap, "RIGHT")
		self:SetScale(0.6)
	end 
end

local BailOut_OnEvent = function(self, event, ...)
	if((event == "UNIT_ENTERED_VEHICLE" and CanExitVehicle()) or UnitControllingVehicle("player") or UnitInVehicle("player")) then
 		self:Show()
 	else
 		self:Hide()
 	end
end
--[[ 
########################################################## 
LOAD / UPDATE
##########################################################
]]--
function MOD:Load()
	CompanionsMicroButtonAlert:Die()
	
	DurabilityFrame:SetFrameStrata("HIGH")
	NewHook(DurabilityFrame, "SetPoint", Dura_OnSetPoint)
	
	TicketStatusFrame:ClearAllPoints()
	TicketStatusFrame:SetPoint("TOPRIGHT", SV.Dock.TopLeft, "TOPRIGHT", 0, 0)
	SV.Mentalo:Add(TicketStatusFrame, L["GM Ticket Frame"], nil, nil, "GM")

	HelpPlate:Die()
	HelpPlateTooltip:Die()
	HelpOpenTicketButtonTutorial:Die()
	HelpOpenTicketButton:SetParent(Minimap)
	HelpOpenTicketButton:ClearAllPoints()
	HelpOpenTicketButton:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT")

	NewHook(VehicleSeatIndicator, "SetPoint", Vehicle_OnSetPoint)
	VehicleSeatIndicator:SetPoint("TOPLEFT", MinimapCluster, "TOPLEFT", 2, 2)
	
	SVUI_WorldStateHolder:SetSizeToScale(200, 45)
	SV.Mentalo:Add(SVUI_WorldStateHolder, L["Capture Bars"])
	NewHook("UIParent_ManageFramePositions", CaptureBarHandler)

	SVUI_AltPowerBar:SetSizeToScale(128, 50)
	PlayerPowerBarAlt:SetParent(SVUI_AltPowerBar)
	PlayerPowerBarAlt:ClearAllPoints()
	PlayerPowerBarAlt:SetPoint("CENTER", SVUI_AltPowerBar, "CENTER", 0, 0)
	PlayerPowerBarAlt.ignoreFramePositionManager = true;
	SV.Mentalo:Add(SVUI_AltPowerBar, L["Alternative Power"])

	SVUI_BailOut:SetSizeToScale(30, 30)
	SVUI_BailOut:SetNormalTexture(BAILOUT_ICON)
	SVUI_BailOut:SetPushedTexture(BAILOUT_ICON)
	SVUI_BailOut:SetHighlightTexture(BAILOUT_ICON)
	SVUI_BailOut:SetStylePanel("Fixed", "Transparent")
	SVUI_BailOut:RegisterForClicks("AnyUp")
	SVUI_BailOut:SetScript("OnClick", VehicleExit)
	SVUI_BailOut:RegisterEvent("UNIT_ENTERED_VEHICLE")
 	SVUI_BailOut:RegisterEvent("UNIT_EXITED_VEHICLE")
 	SVUI_BailOut:RegisterEvent("VEHICLE_UPDATE")
 	SVUI_BailOut:RegisterEvent("PLAYER_ENTERING_WORLD")
 	SVUI_BailOut:SetScript("OnEvent", BailOut_OnEvent)
	SV.Mentalo:Add(SVUI_BailOut, L["Bail Out"])
	SVUI_BailOut:Hide()

	LossOfControlFrame:ClearAllPoints()
	LossOfControlFrame:SetPointToScale("CENTER", SV.Screen, "CENTER", 0, 50)
	SV.Mentalo:Add(LossOfControlFrame, L["Loss Control Icon"], nil, nil, "LoC")

	self:RegisterEvent("CHAT_MSG_BG_SYSTEM_HORDE", PVPRaidNoticeHandler)
	self:RegisterEvent("CHAT_MSG_BG_SYSTEM_ALLIANCE", PVPRaidNoticeHandler)
	self:RegisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL", PVPRaidNoticeHandler)

	self:SetAlerts()
	self:SetMirrorBars()
	self:SetLootFrames()
	self:SetErrorFilters()
end