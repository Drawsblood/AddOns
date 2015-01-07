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
--]]
--[[ GLOBALS ]]--
local _G = _G;
local unpack  = _G.unpack;
local select  = _G.select;
local ipairs  = _G.ipairs;
local pairs   = _G.pairs;
--[[ ADDON ]]--
local SV = _G.SVUI;
local L = SV.L;
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local RING_TEXTURE = [[Interface\AddOns\SVUI\assets\artwork\Unitframe\FOLLOWER-RING]]
local LVL_TEXTURE = [[Interface\AddOns\SVUI\assets\artwork\Unitframe\FOLLOWER-LEVEL]]
local DEFAULT_COLOR = {r = 0.25, g = 0.25, b = 0.25};
--[[ 
########################################################## 
STYLE
##########################################################
]]--
_G.ATLAS_HACKS["MasterPlan_GarrPortraits"] = function(self, atlas)
  local parent = self:GetParent()
  self:ClearAllPoints()
  self:SetPoint("TOPLEFT", parent, "TOPLEFT", -3, 0)
  self:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 3, -6)
  self:SetTexture(RING_TEXTURE)
  self:SetVertexColor(1, 0.86, 0)
end

local StyleRewardIcon = function(self)
  local icon = self.Icon or self.icon
  if(icon) then
    local texture = icon:GetTexture()
    icon:SetTexture(texture)
    icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    icon:ClearAllPoints()
    icon:SetAllPointsIn(self, 1, 1)
    icon:SetDesaturated(false)
  end
end

local function StyleMasterPlan()
	assert(MasterPlan, "AddOn Not Loaded")

  _G.ATLAS_THIEF["Garr_FollowerPortrait_Ring"] = "MasterPlan_GarrPortraits";

	PLUGIN:ApplyTabStyle(GarrisonMissionFrameTab3)
	PLUGIN:ApplyTabStyle(GarrisonMissionFrameTab4)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveAddonStyle("MasterPlan", StyleMasterPlan, false, true)