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
GET ADDON DATA
##########################################################
]]--
if(select(2, UnitClass("player")) ~= 'PALADIN') then return end;

local SV = select(2, ...)

--[[ PALADIN FILTERS ]]--

SV.filterdefaults["BuffWatch"] = {
    {-- Beacon of Light
        ["enabled"] = true, 
        ["id"] = 53563, 
        ["point"] = "TOPRIGHT", 
        ["color"] = {["r"] = 0.7, ["g"] = 0.3, ["b"] = 0.7}, 
        ["anyUnit"] = false, 
        ["onlyShowMissing"] = false, 
        ['style'] = 'coloredIcon', 
        ['displayText'] = false, 
        ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
        ['textThreshold'] = -1, 
        ['xOffset'] = 0, 
        ['yOffset'] = 0
    },
    {-- Hand of Protection
        ["enabled"] = true, 
        ["id"] = 1022, 
        ["point"] = "BOTTOMRIGHT", 
        ["color"] = {["r"] = 0.2, ["g"] = 0.2, ["b"] = 1}, 
        ["anyUnit"] = true, 
        ["onlyShowMissing"] = false, 
        ['style'] = 'coloredIcon', 
        ['displayText'] = false, 
        ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
        ['textThreshold'] = -1, 
        ['xOffset'] = 0, 
        ['yOffset'] = 0
    },
    {-- Hand of Freedom
        ["enabled"] = true, 
        ["id"] = 1044, 
        ["point"] = "BOTTOMRIGHT", 
        ["color"] = {["r"] = 0.89, ["g"] = 0.45, ["b"] = 0}, 
        ["anyUnit"] = true, 
        ["onlyShowMissing"] = false, 
        ['style'] = 'coloredIcon', 
        ['displayText'] = false, 
        ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
        ['textThreshold'] = -1, 
        ['xOffset'] = 0, 
        ['yOffset'] = 0
    },
    {-- Hand of Salvation
        ["enabled"] = true, 
        ["id"] = 1038, 
        ["point"] = "BOTTOMRIGHT", 
        ["color"] = {["r"] = 0.93, ["g"] = 0.75, ["b"] = 0}, 
        ["anyUnit"] = true, 
        ["onlyShowMissing"] = false, 
        ['style'] = 'coloredIcon', 
        ['displayText'] = false, 
        ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
        ['textThreshold'] = -1, 
        ['xOffset'] = 0, 
        ['yOffset'] = 0
    },
    {-- Hand of Sacrifice
        ["enabled"] = true, 
        ["id"] = 6940, 
        ["point"] = "BOTTOMRIGHT", 
        ["color"] = {["r"] = 0.89, ["g"] = 0.1, ["b"] = 0.1}, 
        ["anyUnit"] = true, 
        ["onlyShowMissing"] = false, 
        ['style'] = 'coloredIcon', 
        ['displayText'] = false, 
        ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
        ['textThreshold'] = -1, 
        ['xOffset'] = 0, 
        ['yOffset'] = 0
    },
    {-- Hand of Purity
        ["enabled"] = true, 
        ["id"] = 114039, 
        ["point"] = "BOTTOMRIGHT", 
        ["color"] = {["r"] = 0.64, ["g"] = 0.41, ["b"] = 0.72}, 
        ["anyUnit"] = false, 
        ["onlyShowMissing"] = false, 
        ['style'] = 'coloredIcon', 
        ['displayText'] = false, 
        ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
        ['textThreshold'] = -1, 
        ['xOffset'] = 0, 
        ['yOffset'] = 0
    },
    {-- Sacred Shield
        ["enabled"] = true, 
        ["id"] = 20925, 
        ["point"] = "TOPLEFT", 
        ["color"] = {["r"] = 0.93, ["g"] = 0.75, ["b"] = 0},
        ["anyUnit"] = false, 
        ["onlyShowMissing"] = false, 
        ['style'] = 'coloredIcon', 
        ['displayText'] = false, 
        ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
        ['textThreshold'] = -1, 
        ['xOffset'] = 0, 
        ['yOffset'] = 0
    },
    {-- Eternal Flame
        ["enabled"] = true, 
        ["id"] = 114163, 
        ["point"] = "BOTTOMLEFT", 
        ["color"] = {["r"] = 0.87, ["g"] = 0.7, ["b"] = 0.03}, 
        ["anyUnit"] = false, 
        ["onlyShowMissing"] = false, 
        ['style'] = 'coloredIcon', 
        ['displayText'] = false, 
        ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
        ['textThreshold'] = -1, 
        ['xOffset'] = 0, 
        ['yOffset'] = 0
    },
};