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
        ["size"] = 75, 
        ["fontSize"] = 12,
        ["groups"] = true,
        ["proximity"] = false, 
    }
}

local PLUGIN = LibSuperVillain("Registry"):NewPlugin(AddonName, AddonObject, "TrackOMatic_Profile", "TrackOMatic_Global")
local Schema = PLUGIN.Schema;
local SV = _G["SVUI"];
local L = SV.L
--[[ 
########################################################## 
CONFIG OPTIONS
##########################################################
]]--
SV.Options.args.plugins.args.pluginOptions.args[Schema].args["groups"] = {
    order = 3,
    name = L["GPS"],
    desc = L["Use group frame GPS elements"],
    type = "toggle",
    get = function(key) return PLUGIN.db.general.groups end,
    set = function(key,value) PLUGIN.db.general.groups = value; end
}

SV.Options.args.plugins.args.pluginOptions.args[Schema].args["proximity"] = {
    order = 4,
    name = L["GPS Proximity"],
    desc = L["Only point to closest low health unit (if one is in range)."],
    type = "toggle",
    get = function(key) return PLUGIN.db.general.proximity end,
    set = function(key,value) PLUGIN.db.general.proximity = value; end
}

SV.Options.args.plugins.args.pluginOptions.args[Schema].args["fontSize"] = {
    order = 5,
    name = L["Font Size"],
    desc = L["Set the font size of the range text"],
    type = "range",
    min = 6,
    max = 22,
    step = 1,
    get = function(key) return PLUGIN.db.general.fontSize end,
    set = function(key,value) PLUGIN.db.general.fontSize = value; end
}