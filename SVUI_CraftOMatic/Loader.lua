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
--GLOBAL NAMESPACE
local _G = _G;
--LUA
local unpack        = _G.unpack;
local select        = _G.select;
local assert        = _G.assert;

local AddonName, AddonObject = ...

assert(LibSuperVillain, AddonName .. " requires LibSuperVillain")

AddonObject.defaults = {
	["general"] = {
		["fontSize"] = 12, 
		["farming"] = {
			["buttonsize"] = 35, 
			["buttonspacing"] = 3, 
			["onlyactive"] = false, 
			["droptools"] = true, 
			["toolbardirection"] = "HORIZONTAL", 
		}, 
		["fishing"] = {
			["autoequip"] = true, 
		}, 
		["cooking"] = {
			["autoequip"] = true, 
		},
	} 
}

local PLUGIN = LibSuperVillain("Registry"):NewPlugin(AddonName, AddonObject, "CraftOMatic_Profile", nil, "CraftOMatic_Cache")
local Schema = PLUGIN.Schema;
local SV = _G["SVUI"];
local L = SV.L
--[[ 
########################################################## 
CONFIG OPTIONS
##########################################################
]]--
SV.Options.args.plugins.args.pluginOptions.args[Schema].args["fontSize"] = {
    order = 2,
	name = L["Font Size"],
	desc = L["Set the font size of the log window."],
	type = "range",
	min = 6,
	max = 22,
	step = 1,
    get = function(key) return PLUGIN.db.general[key[#key]] end,
    set = function(key,value) PLUGIN:ChangeDBVar(value, key[#key]); PLUGIN:UpdateLogWindow() end
}

SV.Options.args.plugins.args.pluginOptions.args[Schema].args["fishing"] = {
    order = 3, 
	type = "group", 
	name = L["Fishing Mode Settings"], 
	guiInline = true, 
	args = {
		autoequip = {
			type = "toggle", 
			order = 1, 
			name = L['AutoEquip'], 
			desc = L['Enable/Disable automatically equipping fishing gear.'], 
			get = function(key)return PLUGIN.db.general.fishing[key[#key]] end,
			set = function(key, value)PLUGIN:ChangeDBVar(value, key[#key], "fishing") end
		}
	}
}

SV.Options.args.plugins.args.pluginOptions.args[Schema].args["cooking"] = {
    order = 4, 
	type = "group", 
	name = L["Cooking Mode Settings"], 
	guiInline = true, 
	args = {
		autoequip = {
			type = "toggle", 
			order = 1, 
			name = L['AutoEquip'], 
			desc = L['Enable/Disable automatically equipping cooking gear.'], 
			get = function(key)return PLUGIN.db.general.cooking[key[#key]]end,
			set = function(key, value)PLUGIN:ChangeDBVar(value, key[#key], "cooking")end
		}
	}
}

SV.Options.args.plugins.args.pluginOptions.args[Schema].args["farming"] = {
    order = 5, 
	type = "group", 
	name = L["Farming Mode Settings"], 
	guiInline = true, 
	get = function(key)return PLUGIN.db.general.farming[key[#key]]end, 
	set = function(key, value)PLUGIN.db.general.farming[key[#key]] = value end, 
	args = {
		buttonsize = {
			type = 'range', 
			name = L['Button Size'], 
			desc = L['The size of the action buttons.'], 
			min = 15, 
			max = 60, 
			step = 1, 
			order = 1, 
			set = function(key, value)
				PLUGIN:ChangeDBVar(value, key[#key], "farming");
				PLUGIN:RefreshFarmingTools()
			end,
		},
		buttonspacing = {
			type = 'range', 
			name = L['Button Spacing'], 
			desc = L['The spacing between buttons.'], 
			min = 1, 
			max = 10, 
			step = 1, 
			order = 2, 
			set = function(key, value)
				PLUGIN:ChangeDBVar(value, key[#key], "farming");
				PLUGIN:RefreshFarmingTools()
			end,
		},
		onlyactive = {
			order = 3, 
			type = 'toggle', 
			name = L['Only active buttons'], 
			desc = L['Only show the buttons for the seeds, portals, tools you have in your bags.'], 
			set = function(key, value)
				PLUGIN:ChangeDBVar(value, key[#key], "farming");
				PLUGIN:RefreshFarmingTools()
			end,
		},
		droptools = {
			order = 4, 
			type = 'toggle', 
			name = L['Drop '], 
			desc = L['Automatically drop tools from your bags when leaving the farming area.'],
		},
		toolbardirection = {
			order = 5, 
			type = 'select', 
			name = L['Bar Direction'], 
			desc = L['The direction of the bar buttons (Horizontal or Vertical).'], 
			set = function(key, value)PLUGIN:ChangeDBVar(value, key[#key],"farming"); PLUGIN:RefreshFarmingTools() end,
			values = {
					['VERTICAL'] = L['Vertical'], ['HORIZONTAL'] = L['Horizontal']
			}
		}
	}
}