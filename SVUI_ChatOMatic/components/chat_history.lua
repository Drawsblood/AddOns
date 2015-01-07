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
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
local time 		= _G.time;
--[[ STRING METHODS ]]--
local format, split = string.format, string.split;
--[[ MATH METHODS ]]--
local floor, random = math.floor, math.random;
--[[ TABLE METHODS ]]--
local twipe, tcopy, tsort = table.wipe, table.copy, table.sort;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local PLUGIN = select(2, ...)
local Schema = PLUGIN.Schema;

local SV = _G["SVUI"];
local L = SV.L;
--[[ 
########################################################## 
CHAT HISTORY
##########################################################
]]--
local function MessageTimeStamp()
	local timestamp, current;
	local actual = time();
	local estimate = GetTime()
	if(not estimate) then
		current = random(1, 999)
	else
		current = select(2, ("."):split(estimate, 2)) or 0
	end
	timestamp = ("%d.%d"):format(actual, current)
	return timestamp;
end

function PLUGIN:SAVE_CHAT_HISTORY(event, ...)
	local temp_cache = {}
	for i = 1, select('#', ...) do	
		temp_cache[i] = select(i, ...) or false
	end
	if(#temp_cache > 0) then
	  	temp_cache[20] = event
	  	local timestamp = MessageTimeStamp()
		local lineNum, lineID = 0

		self.cache.chat[timestamp] = temp_cache

		for id, data in pairs(self.cache.chat) do
			lineNum = lineNum + 1
			if((not lineID) or lineID > id) then
				lineID = id
			end
		end

		if(lineNum > 128) then
			self.cache.chat[lineID] = nil
		end
	end
	temp_cache = nil
end  

function PLUGIN:EnableChatHistory()
	if not self.cache["chat"] then self.cache["chat"] = {} end

	self:RegisterEvent("CHAT_MSG_CHANNEL", "SAVE_CHAT_HISTORY")
	self:RegisterEvent("CHAT_MSG_EMOTE", "SAVE_CHAT_HISTORY")
	self:RegisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT", "SAVE_CHAT_HISTORY")
	self:RegisterEvent("CHAT_MSG_RAID_WARNING", "SAVE_CHAT_HISTORY")
	self:RegisterEvent("CHAT_MSG_SAY", "SAVE_CHAT_HISTORY")
	self:RegisterEvent("CHAT_MSG_YELL", "SAVE_CHAT_HISTORY")
	self:RegisterEvent("CHAT_MSG_WHISPER_INFORM", "SAVE_CHAT_HISTORY")
	self:RegisterEvent("CHAT_MSG_GUILD", "SAVE_CHAT_HISTORY")
	self:RegisterEvent("CHAT_MSG_OFFICER", "SAVE_CHAT_HISTORY")
	self:RegisterEvent("CHAT_MSG_PARTY", "SAVE_CHAT_HISTORY")
	self:RegisterEvent("CHAT_MSG_PARTY_LEADER", "SAVE_CHAT_HISTORY")
	self:RegisterEvent("CHAT_MSG_RAID", "SAVE_CHAT_HISTORY")
	self:RegisterEvent("CHAT_MSG_RAID_LEADER", "SAVE_CHAT_HISTORY")
	self:RegisterEvent("CHAT_MSG_INSTANCE_CHAT", "SAVE_CHAT_HISTORY")
	self:RegisterEvent("CHAT_MSG_INSTANCE_CHAT_LEADER", "SAVE_CHAT_HISTORY")
	self:RegisterEvent("CHAT_MSG_BN_CONVERSATION", "SAVE_CHAT_HISTORY")
	self:RegisterEvent("CHAT_MSG_BN_WHISPER_INFORM", "SAVE_CHAT_HISTORY")
	
	local temp_cache, data_cache = {}
	for id, _ in pairs(self.cache.chat) do
		tinsert(temp_cache, tonumber(id))
	end
	tsort(temp_cache, function(a, b)
		return a < b
	end)
	for i = 1, #temp_cache do
		local lineID = tostring(temp_cache[i])
		data_cache = self.cache.chat[lineID]
		if(data_cache) then
			local GUID = data_cache[12]
			if((type(data_cache) == "table") and data_cache[20] ~= nil and (GUID and type(GUID) == "string")) then
				if(not GUID:find("Player-")) then
					self.cache.chat[lineID] = nil
				else
					ChatFrame_MessageEventHandler(DEFAULT_CHAT_FRAME, data_cache[20], unpack(data_cache))
				end
			end
		end
	end
	
	temp_cache = nil
	data_cache = nil
	wipe(self.cache.chat)
end

function PLUGIN:DisableChatHistory()
	self:UnregisterEvent("CHAT_MSG_CHANNEL")
	self:UnregisterEvent("CHAT_MSG_EMOTE")
	self:UnregisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT")
	self:UnregisterEvent("CHAT_MSG_RAID_WARNING")
	self:UnregisterEvent("CHAT_MSG_SAY")
	self:UnregisterEvent("CHAT_MSG_YELL")
	self:UnregisterEvent("CHAT_MSG_WHISPER_INFORM")
	self:UnregisterEvent("CHAT_MSG_GUILD")
	self:UnregisterEvent("CHAT_MSG_OFFICER")
	self:UnregisterEvent("CHAT_MSG_PARTY")
	self:UnregisterEvent("CHAT_MSG_PARTY_LEADER")
	self:UnregisterEvent("CHAT_MSG_RAID")
	self:UnregisterEvent("CHAT_MSG_RAID_LEADER")
	self:UnregisterEvent("CHAT_MSG_INSTANCE_CHAT")
	self:UnregisterEvent("CHAT_MSG_INSTANCE_CHAT_LEADER")
	self:UnregisterEvent("CHAT_MSG_BN_CONVERSATION")
	self:UnregisterEvent("CHAT_MSG_BN_WHISPER_INFORM")
end