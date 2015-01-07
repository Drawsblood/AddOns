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
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local PLUGIN = select(2, ...)
local Schema = PLUGIN.Schema;
local SV = _G["SVUI"]
local L = SV.L
--[[ 
########################################################## 
EVENTS
##########################################################
]]--
function PLUGIN:CHAT_MSG_WHISPER(event, ...)
	if(SV.db.SVChat.enable and self.db.general.saveChats) then
		self:SAVE_CHAT_HISTORY(event, ...)
	end
	if(self.db.general.service) then
		self:AUTO_MSG_WHISPER(event, ...)
	end
end

function PLUGIN:CHAT_MSG_BN_WHISPER(event, ...)
	if(SV.db.SVChat.enable and self.db.general.saveChats) then
		self:SAVE_CHAT_HISTORY(event, ...)
	end
	if(self.db.general.service and self.ServiceEnabled) then
		self:AUTO_MSG_BN_WHISPER(event, ...)
	end
end
--[[ 
########################################################## 
LOAD AND CONSTRUCT
##########################################################
]]--
function PLUGIN:Load()
	if(SV.db.SVChat.enable and self.db.general.saveChats) then
		self:EnableChatHistory()
	end

	if(self.db.general.service) then
		self:EnableAnsweringService()
	end
	
	self:RegisterEvent("CHAT_MSG_WHISPER")
	self:RegisterEvent("CHAT_MSG_BN_WHISPER")
end