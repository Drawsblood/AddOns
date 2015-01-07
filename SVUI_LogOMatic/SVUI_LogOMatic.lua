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
local unpack 	= _G.unpack;
local select 	= _G.select;
local pairs 	= _G.pairs;
local type 		= _G.type;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ MATH METHODS ]]--
local floor = math.floor;
--[[ TABLE METHODS ]]--
local twipe,tcopy,tsort = table.wipe, table.copy, table.sort;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local PLUGIN = select(2, ...)
local Schema = PLUGIN.Schema;

local SV = _G["SVUI"];
local L = SV.L
local CHAT = SV.SVChat;

local NewHook = hooksecurefunc;
--[[ 
########################################################## 
LOCAL VARIABLES
##########################################################
]]--
local nameKey = UnitName("player");
local realmKey = GetRealmName();
local NewHook = hooksecurefunc;
--[[ 
########################################################## 
CORE DATA
##########################################################
]]--
PLUGIN.stash = {};
PLUGIN.myStash = {};
PLUGIN.BagItemCache = {};
PLUGIN.HasAltInventory = false;
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local RefreshLoggedSlots = function(self, bagID, save)
	local id = bagID or self:GetID()
	if(not id or (not self.SlotUpdate)) then return end
	local maxcount = GetContainerNumSlots(id)
	for slotID = 1, maxcount do
		self:SlotUpdate(slotID) 
		local itemLink = GetContainerItemLink(bagID, slotID);
		if(itemLink) then
			local key = GetItemInfo(itemLink)
			if(key) then
				local id = GetContainerItemID(bagID, slotID)
				if id ~= 6948 then PLUGIN.myStash[bagID][key] = GetItemCount(id,true) end
			end
		end
	end
end

local RefreshLoggedBags = function(self)
	for id,bag in pairs(self.Bags)do
		if PLUGIN.myStash[id] then
			twipe(PLUGIN.myStash[id])
		else
			PLUGIN.myStash[id] = {};
		end
		RefreshLoggedSlots(bag, id, true) 
	end
	for id,items in pairs(PLUGIN.myStash) do
		for id,amt in pairs(items) do
			PLUGIN.BagItemCache[id] = PLUGIN.BagItemCache[id] or {}
			PLUGIN.BagItemCache[id][nameKey] = amt
		end
	end
end 

local RefreshLoggedReagentSlots = function(self, bagID, save)
	local id = bagID or self:GetID()
	if(not id or (not self.SlotUpdate)) then return end
	local maxcount = self.numSlots
	for slotID = 1, maxcount do
		self:SlotUpdate(slotID) 
		local itemLink = GetContainerItemLink(bagID, slotID);
		if(itemLink) then
			local key = GetItemInfo(itemLink)
			if(key) then
				local id = GetContainerItemID(bagID, slotID)
				if id ~= 6948 then PLUGIN.myStash[bagID][key] = GetItemCount(id,true) end
			end
		end
	end
end

local RefreshLoggedReagentBags = function(self)
	for id,bag in pairs(self.Bags)do
		if PLUGIN.myStash[id] then
			twipe(PLUGIN.myStash[id])
		else
			PLUGIN.myStash[id] = {};
		end
		RefreshLoggedReagentSlots(bag, id, true) 
	end
	for id,items in pairs(PLUGIN.myStash) do
		for id,amt in pairs(items) do
			PLUGIN.BagItemCache[id] = PLUGIN.BagItemCache[id] or {}
			PLUGIN.BagItemCache[id][nameKey] = amt
		end
	end
end 

local GameTooltip_LogTooltipSetItem = function(self)
	local key,itemID = self:GetItem()
	if PLUGIN.BagItemCache[key] then
		self:AddLine(" ")
		self:AddDoubleLine("|cFFFFDD3C[Character]|r","|cFFFFDD3C[Count]|r")
		for alt,amt in pairs(PLUGIN.BagItemCache[key]) do
			local hexString = LogOMatic_Data[realmKey]["info"][alt] or "|cffCC1410"
			local name = ("%s%s|r"):format(hexString, alt)
			local result = ("%s%s|r"):format(hexString, amt)
			self:AddDoubleLine(name,result)
		end
		self:AddLine(" ")
	end
	self.itemLogged = true 
end 
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function PLUGIN:AppendBankFunctions()
	local BAGS = SV.SVBag;
	if(BAGS.BankFrame) then
		BAGS.BankFrame.RefreshBags = RefreshLoggedBags
	end
	if(BAGS.ReagentFrame) then
		BAGS.ReagentFrame.RefreshBags = RefreshLoggedReagentBags
	end
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
local function ResetAllLogs()
	if LogOMatic_Data[realmKey] then
		if LogOMatic_Data[realmKey]["bags"] and LogOMatic_Data[realmKey]["bags"][nameKey] then LogOMatic_Data[realmKey]["bags"][nameKey] = {} end 
		if LogOMatic_Data[realmKey]["gold"] and LogOMatic_Data[realmKey]["gold"][nameKey] then LogOMatic_Data[realmKey]["gold"][nameKey] = 0 end
	end 
end
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function PLUGIN:Load()
	if SVLOG_Data then SVLOG_Data = nil end
	if SVLOG_Cache then SVLOG_Cache = nil end
	if LogOMatic_Cache then LogOMatic_Cache = nil end
	
	local toonClass = select(2,UnitClass("player"));
	local r,g,b = RAID_CLASS_COLORS[toonClass].r, RAID_CLASS_COLORS[toonClass].g, RAID_CLASS_COLORS[toonClass].b
	local hexString = ("|cff%02x%02x%02x"):format(r * 255, g * 255, b * 255)
	LogOMatic_Data = LogOMatic_Data or {}
	LogOMatic_Data[realmKey] = LogOMatic_Data[realmKey] or {}
	LogOMatic_Data[realmKey]["bags"] = LogOMatic_Data[realmKey]["bags"] or {};
	LogOMatic_Data[realmKey]["info"] = LogOMatic_Data[realmKey]["info"] or {};
	LogOMatic_Data[realmKey]["info"][nameKey] = hexString;
	LogOMatic_Data[realmKey]["bags"][nameKey] = LogOMatic_Data[realmKey]["bags"][nameKey] or {};

	self.stash = LogOMatic_Data[realmKey]["bags"];
	self.myStash = LogOMatic_Data[realmKey]["bags"][nameKey];

	LogOMatic_Data[realmKey]["quests"] = LogOMatic_Data[realmKey]["quests"] or {};
	LogOMatic_Data[realmKey]["quests"][nameKey] = LogOMatic_Data[realmKey]["quests"][nameKey] or {};

	self.chronicle = LogOMatic_Data[realmKey]["quests"][nameKey];

	NewHook(SV, "ResetAllUI", ResetAllLogs);
	
	for alt,_ in pairs(LogOMatic_Data[realmKey]["bags"]) do
		for bag,items in pairs(LogOMatic_Data[realmKey]["bags"][alt]) do
			for id,amt in pairs(items) do
				self.BagItemCache[id] = self.BagItemCache[id] or {}
				self.BagItemCache[id][alt] = amt
			end
		end
	end

	--[[ OVERRIDE DEFAULT FUNCTIONS ]]--
	if SV.db.SVBag.enable then
		local BAGS = SV.SVBag;
		if BAGS.BagFrame then
			BAGS.BagFrame.RefreshBags = RefreshLoggedBags;
			NewHook(BAGS, "MakeBankOrReagent", self.AppendBankFunctions);
			RefreshLoggedBags(BAGS.BagFrame)
		end
	end
	if SV.db.SVTip.enable then
		GameTooltip:HookScript("OnTooltipSetItem", GameTooltip_LogTooltipSetItem)
	end
end