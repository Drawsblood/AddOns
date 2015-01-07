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
COOLINE
##########################################################
]]--
local function StyleCoolLine()
	assert(CoolLineDB, "AddOn Not Loaded")
	
	CoolLineDB.bgcolor = { r = 0, g = 0, b = 0, a = 0, }
	CoolLineDB.border = "None"
	CoolLine.updatelook()
	PLUGIN:ApplyFrameStyle(CoolLine,"Transparent")
	CoolLine.Panel:SetAllPoints(CoolLine)
	SV:AddToDisplayAudit(CoolLine)

	if PLUGIN:IsAddonReady("DockletCoolLine") then
		if not CoolLineDB.vertical then
			CoolLine:SetPoint('BOTTOMRIGHT', SVUI_ActionBar1, 'TOPRIGHT', 0, 4)
			CoolLine:SetPoint("BOTTOMLEFT", SVUI_ActionBar1, "TOPLEFT", 0, 4)
		end
	end
end
PLUGIN:SaveAddonStyle("CoolLine", StyleCoolLine)