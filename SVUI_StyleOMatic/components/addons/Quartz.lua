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
local string 	= _G.string;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = _G.SVUI;
local L = SV.L;
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
--[[ 
########################################################## 
QUARTZ
##########################################################
]]--
local function StyleQuartz()
	local AceAddon = LibStub("AceAddon-3.0")
	if(not AceAddon) then return end
	local Quartz3 = AceAddon:GetAddon("Quartz3", true)
	
	assert(Quartz3, "AddOn Not Loaded")

	local GCD = Quartz3:GetModule("GCD")
	local CastBar = Quartz3.CastBarTemplate.template
	local function StyleQuartzBar(self)
		if not self.isStyled then
			self.IconBorder = CreateFrame("Frame", nil, self)
			PLUGIN:ApplyFrameStyle(self.IconBorder,"Transparent")
			self.IconBorder:SetFrameLevel(0)
			self.IconBorder:SetAllPointsOut(self.Icon)
			PLUGIN:ApplyFrameStyle(self.Bar,"Transparent",true)
			self.isStyled = true
		end
 		if self.config.hideicon then
 			self.IconBorder:Hide()
 		else
 			self.IconBorder:Show()
 		end
	end

	hooksecurefunc(CastBar, 'ApplySettings', StyleQuartzBar)
	hooksecurefunc(CastBar, 'UNIT_SPELLCAST_START', StyleQuartzBar)
	hooksecurefunc(CastBar, 'UNIT_SPELLCAST_CHANNEL_START', StyleQuartzBar)

	if GCD then
		hooksecurefunc(GCD, 'CheckGCD', function()
			if not Quartz3GCDBar.backdrop then
				PLUGIN:ApplyFrameStyle(Quartz3GCDBar,"Transparent",true)
			end
		end)
	end
end
PLUGIN:SaveAddonStyle("Quartz", StyleQuartz)