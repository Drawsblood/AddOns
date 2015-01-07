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
local HIGHLIGHT_TEXTURE = [[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]]
local DEFAULT_COLOR = {r = 0.25, g = 0.25, b = 0.25};
--[[ 
########################################################## 
STYLE
##########################################################
]]--
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

_G.ATLAS_HACKS["GarrMission_Rewards"] = function(self)
  local frame = self:GetParent()
  if(frame and (not frame.Panel)) then
    local size = frame:GetHeight() - 6
    frame:RemoveTextures()
    frame:SetStylePanel("Default", 'Icon', true, 2)
    hooksecurefunc(frame, "SetPoint", StyleRewardIcon)
  end
end

_G.ATLAS_HACKS["GarrMission_Buttons"] = function(self)
  local frame = self:GetParent()
  if(frame) then
    PLUGIN:ApplyItemButtonStyle(frame)
  end
end

_G.ATLAS_HACKS["GarrMission_PortraitsFromLevel"] = function(self)
	local parent = self:GetParent()
	if(parent.PortraitRing) then
  		parent.PortraitRing:SetTexture(RING_TEXTURE)
  	end
end

_G.ATLAS_HACKS["GarrMission_Highlights"] = function(self)
	local parent = self:GetParent()
	if(not parent.AtlasHighlight) then
  		local frame = parent:CreateTexture(nil, "HIGHLIGHT")
		frame:SetAllPointsIn(parent,1,1)
		frame:SetTexture(HIGHLIGHT_TEXTURE)
		frame:SetGradientAlpha("VERTICAL",0.1,0.82,0.95,0.1,0.1,0.82,0.95,0.68)
		parent.AtlasHighlight = frame
	end
	self:SetTexture("")
end

_G.ATLAS_HACKS["GarrMission_MaterialFrame"] = function(self)
  local frame = self:GetParent()
  frame:RemoveTextures()
  frame:SetStylePanel("Default", "Inset", true, 1, -5, -7)
end

--_G.ATLAS_THIEF["GarrMission_MissionParchment"] = "default";
--_G.ATLAS_THIEF["GarrMission_RareOverlay"] = "GarrMission_Buttons";

_G.ATLAS_THIEF["_GarrMission_MissionListTopHighlight"] = "GarrMission_Highlights";
_G.ATLAS_THIEF["_GarrMission_TopBorder-Highlight"] = "default";
_G.ATLAS_THIEF["GarrMission_ListGlow-Highlight"] = "default";
_G.ATLAS_THIEF["GarrMission_TopBorderCorner-Highlight"] = "default";

_G.ATLAS_THIEF["Garr_FollowerToast-Uncommon"] = "default";
_G.ATLAS_THIEF["Garr_FollowerToast-Epic"] = "default";
_G.ATLAS_THIEF["Garr_FollowerToast-Rare"] = "default";

_G.ATLAS_THIEF["GarrLanding-MinimapIcon-Horde-Up"] = "default";
_G.ATLAS_THIEF["GarrLanding-MinimapIcon-Horde-Down"] = "default";
_G.ATLAS_THIEF["GarrLanding-MinimapIcon-Alliance-Up"] = "default";
_G.ATLAS_THIEF["GarrLanding-MinimapIcon-Alliance-Down"] = "default";

_G.ATLAS_THIEF["Garr_InfoBox-BackgroundTile"] = "default";
_G.ATLAS_THIEF["_Garr_InfoBoxBorder-Top"] = "default";
_G.ATLAS_THIEF["!Garr_InfoBoxBorder-Left"] = "default";
_G.ATLAS_THIEF["!Garr_InfoBox-Left"] = "default";
_G.ATLAS_THIEF["_Garr_InfoBox-Top"] = "default";

_G.ATLAS_THIEF["Garr_InfoBoxBorder-Corner"] = "default";
_G.ATLAS_THIEF["Garr_InfoBox-CornerShadow"] = "default";
_G.ATLAS_THIEF["Garr_Mission_MaterialFrame"] = "GarrMission_MaterialFrame";

_G.ATLAS_THIEF["!GarrMission_Bg-Edge"] = "GarrMission_Buttons";
_G.ATLAS_THIEF["_GarrMission_Bg-BottomEdgeSmall"] = "default";
_G.ATLAS_THIEF["_GarrMission_TopBorder"] = "default";
_G.ATLAS_THIEF["GarrMission_TopBorderCorner"] = "default";
_G.ATLAS_THIEF["Garr_MissionList-IconBG"] = "default";

_G.ATLAS_THIEF["GarrMission_RewardsShadow"] = "GarrMission_Rewards";
_G.ATLAS_THIEF["GarrMission_PortraitRing_LevelBorder"] = "GarrMission_PortraitsFromLevel";
_G.ATLAS_THIEF["GarrMission_PortraitRing_iLvlBorder"] = "GarrMission_PortraitsFromLevel";