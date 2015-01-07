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
if(select(2, UnitClass("player")) ~= 'PRIEST') then return end;

local SV = select(2, ...)

--[[ PRIEST FILTERS ]]--

SV.filterdefaults["BuffWatch"] = {
    {-- Weakened Soul
        ["enabled"] = true, 
        ["id"] = 6788, 
        ["point"] = "TOPRIGHT", 
        ["color"] = {["r"] = 1, ["g"] = 0, ["b"] = 0}, 
        ["anyUnit"] = true, 
        ["onlyShowMissing"] = false, 
        ['style'] = 'coloredIcon', 
        ['displayText'] = false, 
        ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
        ['textThreshold'] = -1, 
        ['xOffset'] = 0, 
        ['yOffset'] = 0
    },
    {-- Prayer of Mending
        ["enabled"] = true, 
        ["id"] = 41635, 
        ["point"] = "BOTTOMRIGHT", 
        ["color"] = {["r"] = 0.2, ["g"] = 0.7, ["b"] = 0.2}, 
        ["anyUnit"] = false, 
        ["onlyShowMissing"] = false, 
        ['style'] = 'coloredIcon', 
        ['displayText'] = false, 
        ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
        ['textThreshold'] = -1, 
        ['xOffset'] = 0, 
        ['yOffset'] = 0
    },
    {-- Renew
        ["enabled"] = true, 
        ["id"] = 139, 
        ["point"] = "BOTTOMLEFT", 
        ["color"] = {["r"] = 0.4, ["g"] = 0.7, ["b"] = 0.2}, 
        ["anyUnit"] = false, 
        ["onlyShowMissing"] = false, 
        ['style'] = 'coloredIcon', 
        ['displayText'] = false, 
        ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
        ['textThreshold'] = -1, 
        ['xOffset'] = 0, 
        ['yOffset'] = 0
    },
    {-- Power Word: Shield
        ["enabled"] = true, 
        ["id"] = 17, 
        ["point"] = "TOPLEFT", 
        ["color"] = {["r"] = 0.81, ["g"] = 0.85, ["b"] = 0.1}, 
        ["anyUnit"] = true, 
        ["onlyShowMissing"] = false, 
        ['style'] = 'coloredIcon', 
        ['displayText'] = false, 
        ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
        ['textThreshold'] = -1, 
        ['xOffset'] = 0, 
        ['yOffset'] = 0
    },
    {-- Power Word: Shield Power Insight
        ["enabled"] = true, 
        ["id"] = 123258, 
        ["point"] = "TOPLEFT", 
        ["color"] = {["r"] = 0.81, ["g"] = 0.85, ["b"] = 0.1}, 
        ["anyUnit"] = true, 
        ["onlyShowMissing"] = false, 
        ['style'] = 'coloredIcon', 
        ['displayText'] = false, 
        ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
        ['textThreshold'] = -1, 
        ['xOffset'] = 0, 
        ['yOffset'] = 0
    },
    {-- Power Infusion
        ["enabled"] = true, 
        ["id"] = 10060, 
        ["point"] = "RIGHT", 
        ["color"] = {["r"] = 0.89, ["g"] = 0.09, ["b"] = 0.05}, 
        ["anyUnit"] = false, 
        ["onlyShowMissing"] = false, 
        ['style'] = 'coloredIcon', 
        ['displayText'] = false, 
        ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
        ['textThreshold'] = -1, 
        ['xOffset'] = 0, 
        ['yOffset'] = 0
    },
    {-- Guardian Spirit
        ["enabled"] = true, 
        ["id"] = 47788, 
        ["point"] = "LEFT", 
        ["color"] = {["r"] = 0.86, ["g"] = 0.44, ["b"] = 0}, 
        ["anyUnit"] = true, 
        ["onlyShowMissing"] = false, 
        ['style'] = 'coloredIcon', 
        ['displayText'] = false, 
        ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
        ['textThreshold'] = -1, 
        ['xOffset'] = 0, 
        ['yOffset'] = 0
    },
    {-- Pain Suppression
        ["enabled"] = true, 
        ["id"] = 33206, 
        ["point"] = "LEFT", 
        ["color"] = {["r"] = 0.89, ["g"] = 0.09, ["b"] = 0.05}, 
        ["anyUnit"] = true, 
        ["onlyShowMissing"] = false, 
        ['style'] = 'coloredIcon', 
        ['displayText'] = false, 
        ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
        ['textThreshold'] = -1, 
        ['xOffset'] = 0, 
        ['yOffset'] = 0
    },
};