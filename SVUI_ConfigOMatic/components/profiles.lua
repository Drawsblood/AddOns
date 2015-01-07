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

SV.Options.args.profiles = {
	order = 9999,
	type = "group", 
	name = L["Profiles"], 
	childGroups = "tab", 
	args = {}
}

local function RefreshProfileOptions()
	local hasProfile = true;
	local currentProfile = SVLib:CurrentProfile()
	if(not currentProfile) then
		hasProfile = false
		currentProfile = profileKey
	end

	SV.Options.args.profiles.args.desc = {
		order = 1,
		type = "description",
		name = L["intro"] .. "\n\n" .. " |cff66FF33" .. L["current"] .. currentProfile .. "|r",
		width = "full",
	}
	SV.Options.args.profiles.args.spacer1 = {
		order = 2,
		type = "description",
		name = "",
		width = "full",
	}
	SV.Options.args.profiles.args.importdesc = {
		order = 3,
		type = "description",
		name = "\n" .. L["import_desc"],
		width = "full"
	}

	SV.Options.args.profiles.args.spacer2 = {
		order = 4,
		type = "description",
		name = "",
		width = "full",
	}

	if(not hasProfile) then
		SV.Options.args.profiles.args.save = {
			order = 5,
			type = "execute",
			name = _G.SAVE .. " " .. L["current"] .. " |cffFFFF00" .. currentProfile .. "|r",
			width = "full",
			func = function() SVLib:ExportDatabase(currentProfile) SV:SavedPopup() RefreshProfileOptions() end,
		}
	else
		SV.Options.args.profiles.args.save = {
			order = 5,
			type = "execute",
			name = "Unlink from current profile: |cffFFFF00" .. currentProfile .. "|r",
			width = "full",
			func = function() SVLib:UnsetProfile() SV:SavedPopup() RefreshProfileOptions() end,
		}
	end

	SV.Options.args.profiles.args.export = {
		name = L["export"],
		desc = L["export_sub"],
		type = "input",
		order = 6,
		get = false,
		set = function(key, value) SVLib:ExportDatabase(value) SV:SavedPopup() end,
	}

	SV.Options.args.profiles.args.import = {
		name = L["import"],
		desc = L["import_sub"],
		type = "select",
		order = 7,
		get = function() return " SELECT ONE" end,
		set = function(key, value) SV:ImportProfile(value) RefreshProfileOptions() end,
		disabled = function() local t = SVLib:CheckProfiles() return (not t) end,
		values = SVLib:GetProfiles(),
	}
	SV.Options.args.profiles.args.spacer3 = {
		order = 8,
		type = "description",
		name = "",
		width = "full",
	}
	SV.Options.args.profiles.args.deldesc = {
		order = 9,
		type = "description",
		name = "\n" .. L["delete_desc"],
		width = "full",
	}
	SV.Options.args.profiles.args.delete = {
		order = 10,
		type = "select",
		name = L["delete"],
		desc = L["delete_sub"],
		get = function() return " SELECT ONE" end,
		set = function(key, value) SVLib:Remove(value) end,
		values = SVLib:GetProfiles(),
		disabled = function() local t = SVLib:CheckProfiles() return (not t) end,
		confirm = true,
		confirmText = L["delete_confirm"],
	}
	SV.Options.args.profiles.args.spacer4 = {
		order = 11,
		type = "description",
		name = "",
		width = "full",
	}
	SV.Options.args.profiles.args.descreset = {
		order = 12,
		type = "description",
		name = L["reset_desc"],
		width = "full",
	}
	SV.Options.args.profiles.args.reset = {
		order = 13,
		type = "execute",
		name = function() return L["reset"] .. " " .. " |cffFFFF00" .. currentProfile .. "|r" end,
		desc = L["reset_sub"],
		func = function() SV:StaticPopup_Show("RESET_PROFILE_PROMPT") end,
		width = "full",
	}
	SV.Options.args.profiles.args.spacer5 = {
		order = 14,
		type = "description",
		name = "",
		width = "full",
	}
	SV.Options.args.profiles.args.dualSpec = {
		order = 15,
		type = "toggle",
		name = "Dual-Spec Switching",
		get = function() return SVLib:CheckDualProfile() end,
		set = function(key, value) SVLib:ToggleDualProfile(value) end,
	}
end

RefreshProfileOptions()