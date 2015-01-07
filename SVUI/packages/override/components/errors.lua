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
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...);
local MOD = SV.SVOverride;
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local UIErrorsFrame = _G.UIErrorsFrame;
local ERR_FILTERS = {};
--[[ 
########################################################## 
EVENTS
##########################################################
]]--
function MOD:UI_ERROR_MESSAGE(event, msg)
	if((not msg) or ERR_FILTERS[msg]) then return end
	UIErrorsFrame:AddMessage(msg, 1.0, 0.1, 0.1, 1.0);
end

local ErrorFrameHandler = function(self, event)
	if(event == 'PLAYER_REGEN_DISABLED') then
		MOD:UnregisterEvent('UI_ERROR_MESSAGE')
	else
		MOD:RegisterEvent('UI_ERROR_MESSAGE')
	end
end

function MOD:CacheFilters()
	for k, v in pairs(SV.db.SVOverride.errorFilters) do
		ERR_FILTERS[k] = v
	end
	if(ERR_FILTERS[INTERRUPTED]) then
		ERR_FILTERS[SPELL_FAILED_INTERRUPTED] = true
		ERR_FILTERS[SPELL_FAILED_INTERRUPTED_COMBAT] = true
	end
end

function MOD:UpdateErrorFilters()
	if(SV.db.SVOverride.filterErrors) then
		self:CacheFilters()
		UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
		self:RegisterEvent('UI_ERROR_MESSAGE')
		if(SV.db.SVOverride.hideErrorFrame) then
			self:RegisterEvent('PLAYER_REGEN_DISABLED', ErrorFrameHandler)
			self:RegisterEvent('PLAYER_REGEN_ENABLED', ErrorFrameHandler)
		end
	else
		UIErrorsFrame:RegisterEvent('UI_ERROR_MESSAGE')
		self:UnregisterEvent('UI_ERROR_MESSAGE')
		self:UnregisterEvent('PLAYER_REGEN_DISABLED')
		self:UnregisterEvent('PLAYER_REGEN_ENABLED')
	end
end
--[[ 
########################################################## 
PACKAGE CALL
##########################################################
]]--
function MOD:SetErrorFilters()
	if(SV.db.SVOverride.filterErrors) then
		self:CacheFilters()
		UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
		self:RegisterEvent('UI_ERROR_MESSAGE')
		if(SV.db.SVOverride.hideErrorFrame) then
			self:RegisterEvent('PLAYER_REGEN_DISABLED', ErrorFrameHandler)
			self:RegisterEvent('PLAYER_REGEN_ENABLED', ErrorFrameHandler)
		end
	end
end