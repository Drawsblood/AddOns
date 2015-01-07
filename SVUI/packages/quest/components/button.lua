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

QUEST TRACKER BUTTON: 

Originally "ExtraQuestButton" by p3lim, 
modified/minimally re-written for SVUI by Munglunch

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
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;
--[[ TABLE METHODS ]]--
local tremove, twipe = table.remove, table.wipe;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L
local LSM = LibStub("LibSharedMedia-3.0")
local MOD = SV.SVQuest;
--[[ 
########################################################## 
LOCALS
##########################################################
]]--
local QuestInZone = {
	[14108] = 541,
	[13998] = 11,
	[25798] = 61,
	[25799] = 61,
	[25112] = 161,
	[25111] = 161,
	[24735] = 201,
};
--[[ 
########################################################## 
BUTTON INTERNALS
##########################################################
]]--
local UpdateButton = function(self)
	local shortestDistance = 62500;
	local currentAreaID = GetCurrentMapAreaID()
	local closestQuest, closestLink, closestTexture, closestLevel, closestCount, closestIndex, closestDuration, closestExpiration, closestID, closestComplete;

	for i = 1, GetNumQuestWatches() do
		local questID, _, questLogIndex, numObjectives, requiredMoney, isComplete, startEvent, isAutoComplete, failureTime, timeElapsed, questType, isTask, isStory, isOnMap, hasLocalPOI = GetQuestWatchInfo(i);
		if(questID and not isComplete) then
			local title, level, suggestedGroup = GetQuestLogTitle(questLogIndex)
			if(QuestHasPOIInfo(questID)) then
				local link, texture, _, showCompleted = GetQuestLogSpecialItemInfo(questLogIndex)
				local areaID = QuestInZone[questID]
				if(areaID and (areaID == currentAreaID)) then
					closestQuest = title
					closestID = questID
					closestLink = link
					closestTexture = texture
					closestLevel = level
					closestCount = numObjectives
					closestIndex = questLogIndex
					closestDuration = failureTime
					closestExpiration = timeElapsed
					closestComplete = isComplete
				elseif(onContinent and (distanceSq < shortestDistance)) then
					shortestDistance = distanceSq
					closestQuest = title
					closestID = questID
					closestLink = link
					closestTexture = texture
					closestLevel = level
					closestCount = numObjectives
					closestIndex = questLogIndex
					closestDuration = failureTime
					closestExpiration = timeElapsed
					closestComplete = isComplete
				end
			end
		end
	end

	if(closestLink) then
		self.CurrentQuest = closestIndex;
		self:SetAbility(closestLink, closestTexture, closestQuest, closestLevel, closestTexture, closestID, closestIndex, closestCount, closestDuration, closestExpiration, closestComplete);
		self.ArtFile = [[Interface\ExtraButton\Smash]];
	elseif(self:IsShown() and (self.CurrentQuest ~= MOD.CurrentQuest)) then
		self.CurrentQuest = 0;
		self:RemoveAbility();
	end
end
--[[ 
########################################################## 
PACKAGE CALL
##########################################################
]]--
function MOD:InitializeQuestItem()
	SV.SuperButton.ItemBlackList[113191] = true
	SV.SuperButton.ItemBlackList[110799] = true
	SV.SuperButton.ItemBlackList[109164] = true

	local Button = SV.SuperButton:AddItem("SVUI_QuestAutoButton", UpdateButton, nil, 'SVUI_QUESTITEM');
	Button:RegisterEvent('UPDATE_EXTRA_ACTIONBAR')
	Button:RegisterEvent('BAG_UPDATE_COOLDOWN')
	Button:RegisterEvent('BAG_UPDATE_DELAYED')
	Button:RegisterEvent('WORLD_MAP_UPDATE')
	Button:RegisterEvent('QUEST_LOG_UPDATE')
	Button:RegisterEvent('QUEST_POI_UPDATE')

	self.QuestItem = Button
end