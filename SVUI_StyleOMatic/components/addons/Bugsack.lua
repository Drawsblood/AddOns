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
BUGSACK
##########################################################
]]--
local function StyleBugSack(event, addon)
	assert(BugSack, "AddOn Not Loaded")
	hooksecurefunc(BugSack, "OpenSack", function()
		if BugSackFrame.Panel then return end
		BugSackFrame:RemoveTextures()
		BugSackFrame:SetStylePanel("Default", 'Transparent')
		PLUGIN:ApplyTabStyle(BugSackTabAll)
		BugSackTabAll:SetPoint("TOPLEFT", BugSackFrame, "BOTTOMLEFT", 0, 1)
		PLUGIN:ApplyTabStyle(BugSackTabSession)
		PLUGIN:ApplyTabStyle(BugSackTabLast)
		BugSackNextButton:SetStylePanel("Button")
		BugSackSendButton:SetStylePanel("Button")
		BugSackPrevButton:SetStylePanel("Button")
		PLUGIN:ApplyScrollBarStyle(BugSackScrollScrollBar)
	end)
end

PLUGIN:SaveAddonStyle("Bugsack", StyleBugSack)