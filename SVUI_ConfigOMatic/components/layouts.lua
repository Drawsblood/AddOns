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
local unpack 	 =  _G.unpack;
local pairs 	 =  _G.pairs;
local tinsert 	 =  _G.tinsert;
local table 	 =  _G.table;
--[[ TABLE METHODS ]]--
local tsort = table.sort;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = _G["SVUI"];
local SVLib = LibSuperVillain("Registry");
local L = SV.L;

local playerRealm = GetRealmName()
local playerName = UnitName("player")
local profileKey = ("%s - %s"):format(playerName, playerRealm)

SV.Options.args.layouts = {
	order = 9998,
	type = "group", 
	name = L["Layouts"], 
	childGroups = "tab", 
	args = {
		desc = {
			order = 1,
			type = "description",
			name = L["intro"] .. "\n",
		},
		spacer1 = {
			order = 2,
			type = "description",
			name = "",
			width = "full",
		},
		save = {
			order = 3,
			name = SAVE,
			type = "input",
			desc = function() return _G.SAVE .. " current settings as a custom Layout" end,
			func = function(key, value) 
				SVLib:SaveLayoutData(value, 'SVBar')
				SVLib:SaveLayoutData(value, 'SVAura')
				SVLib:SaveLayoutData(value, 'SVUnit')
				SV:SavedPopup() 
			end,
		},
		delete = {
			order = 4,
			type = "select",
			name = L["delete"],
			desc = L["delete_sub"],
			get = function() return " SELECT ONE" end,
			set = function(key, value) SVLib:RemoveLayout(value) end,
			values = SVLib:GetLayoutList(),
			disabled = function() local t = SVLib:CheckLayoutData() return (not t) end,
			confirm = true,
			confirmText = L["delete_confirm"],
		},
	}
}