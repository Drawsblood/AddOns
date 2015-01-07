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
local MOD = SV.SVOverride;
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local POSITION, ANCHOR_POINT, YOFFSET = "TOP", "BOTTOM", -10
local FORCE_POSITION = false;
local NewHook = hooksecurefunc;

local SVUI_AlertFrame = CreateFrame("Frame", "SVUI_AlertFrame", UIParent);
SVUI_AlertFrame:SetPoint("TOP", SVUI_DockTopCenter, "BOTTOM", 0, -115);
SVUI_AlertFrame:SetSize(180, 20);
--[[ 
########################################################## 
ALERTS
##########################################################
]]--
local _hook_AlertFrame_SetLootAnchors = function(self)
	if MissingLootFrame:IsShown() then
		MissingLootFrame:ClearAllPoints()
		MissingLootFrame:SetPoint(POSITION, self, ANCHOR_POINT)
		if GroupLootContainer:IsShown() then
			GroupLootContainer:ClearAllPoints()
			GroupLootContainer:SetPoint(POSITION, MissingLootFrame, ANCHOR_POINT, 0, YOFFSET)
		end 
	elseif GroupLootContainer:IsShown() or FORCE_POSITION then 
		GroupLootContainer:ClearAllPoints()
		GroupLootContainer:SetPoint(POSITION, self, ANCHOR_POINT)
	end 
end 

local _hook_AlertFrame_SetLootWonAnchors = function(self)
	for i = 1, #LOOT_WON_ALERT_FRAMES do 
		local frame = LOOT_WON_ALERT_FRAMES[i]
		if(frame and frame:IsShown()) then
			frame:ClearAllPoints()
			frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
			self = frame 
		end 
	end 
end 

local _hook_AlertFrame_SetMoneyWonAnchors = function(self)
	for i = 1, #MONEY_WON_ALERT_FRAMES do 
		local frame = MONEY_WON_ALERT_FRAMES[i]
		if(frame and frame:IsShown()) then
			frame:ClearAllPoints()
			frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
			self = frame 
		end 
	end 
end 

local _hook_AlertFrame_SetAchievementAnchors = function(self)
	if AchievementAlertFrame1 then
		for i = 1, MAX_ACHIEVEMENT_ALERTS do 
			local frame = _G["AchievementAlertFrame"..i]
			if(frame and frame:IsShown()) then
				frame:ClearAllPoints()
				frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
				self = frame 
			end 
		end 
	end 
end 

local _hook_AlertFrame_SetCriteriaAnchors = function(self)
	if CriteriaAlertFrame1 then
		for i = 1, MAX_ACHIEVEMENT_ALERTS do 
			local frame = _G["CriteriaAlertFrame"..i]
			if(frame and frame:IsShown()) then
				frame:ClearAllPoints()
				frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
				self = frame 
			end 
		end 
	end 
end 

local _hook_AlertFrame_SetChallengeModeAnchors = function(self)
	local frame = ChallengeModeAlertFrame1;
	if(frame and frame:IsShown()) then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
	end 
end 

local _hook_AlertFrame_SetDungeonCompletionAnchors = function(self)
	local frame = DungeonCompletionAlertFrame1;
	if(frame and frame:IsShown()) then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
	end 
end 

local _hook_AlertFrame_SetStorePurchaseAnchors = function(self)
	local frame = StorePurchaseAlertFrame;
	if(frame and frame:IsShown()) then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
	end 
end 

local _hook_AlertFrame_SetScenarioAnchors = function(self)
	local frame = ScenarioAlertFrame1;
	if(frame and frame:IsShown()) then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
	end 
end 

local _hook_AlertFrame_SetGuildChallengeAnchors = function(self)
	local frame = GuildChallengeAlertFrame;
	if(frame and frame:IsShown()) then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
	end 
end 

local AlertFramePostMove_Hook = function(forced)
	local b, c = SVUI_AlertFrame_MOVE:GetCenter()
	local d = SV.Screen:GetTop()
	if(c > (d  /  2)) then
		POSITION = "TOP"
		ANCHOR_POINT = "BOTTOM"
		YOFFSET = -10;
		SVUI_AlertFrame_MOVE:SetText(SVUI_AlertFrame_MOVE.textString.." (Grow Down)")
	else
		POSITION = "BOTTOM"
		ANCHOR_POINT = "TOP"
		YOFFSET = 10;
		SVUI_AlertFrame_MOVE:SetText(SVUI_AlertFrame_MOVE.textString.." (Grow Up)")
	end 
	if(MOD.RollFrames[1]) then 
		local lastFrame = SVUI_AlertFrame;
		local newAnchor;
		for index, rollFrame in pairs(MOD.RollFrames) do
			rollFrame:ClearAllPoints()
			if(POSITION == "TOP") then 
				rollFrame:SetPointToScale("TOP", lastFrame, "BOTTOM", 0, -4)
			else
				rollFrame:SetPointToScale("BOTTOM", lastFrame, "TOP", 0, 4)
			end 
			lastFrame = rollFrame;
			if(rollFrame:IsShown()) then
				newAnchor = rollFrame 
			end 
		end 
		AlertFrame:ClearAllPoints()
		if(newAnchor) then
			AlertFrame:SetAllPoints(newAnchor)
		else
			AlertFrame:SetAllPoints(SVUI_AlertFrame)
		end 
	else
		AlertFrame:ClearAllPoints()
		AlertFrame:SetAllPoints(SVUI_AlertFrame)
	end 
	if(forced) then
		FORCE_POSITION = true;
		AlertFrame_FixAnchors()
		FORCE_POSITION = false 
	end 
end 
--[[ 
########################################################## 
PACKAGE CALL
##########################################################
]]--
function MOD:SetAlerts()
	SVUI_AlertFrame:SetSizeToScale(180, 20);
	SV.Mentalo:Add(SVUI_AlertFrame, L["Loot / Alert Frames"], nil, AlertFramePostMove_Hook)

	NewHook('AlertFrame_FixAnchors', AlertFramePostMove_Hook)
	NewHook('AlertFrame_SetLootAnchors', _hook_AlertFrame_SetLootAnchors)
	NewHook('AlertFrame_SetLootWonAnchors', _hook_AlertFrame_SetLootWonAnchors)
	NewHook('AlertFrame_SetMoneyWonAnchors', _hook_AlertFrame_SetMoneyWonAnchors)
	NewHook('AlertFrame_SetAchievementAnchors', _hook_AlertFrame_SetAchievementAnchors)
	NewHook('AlertFrame_SetCriteriaAnchors', _hook_AlertFrame_SetCriteriaAnchors)
	NewHook('AlertFrame_SetChallengeModeAnchors', _hook_AlertFrame_SetChallengeModeAnchors)
	NewHook('AlertFrame_SetDungeonCompletionAnchors', _hook_AlertFrame_SetDungeonCompletionAnchors)
	NewHook('AlertFrame_SetScenarioAnchors', _hook_AlertFrame_SetScenarioAnchors)
	NewHook('AlertFrame_SetGuildChallengeAnchors', _hook_AlertFrame_SetGuildChallengeAnchors)
	NewHook('AlertFrame_SetStorePurchaseAnchors', _hook_AlertFrame_SetStorePurchaseAnchors)
end