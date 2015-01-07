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
MOGIT
##########################################################
]]--
local function StyleMogItPreview()
	for i = 1, 99 do
		local MogItGearSlots = {
			"HeadSlot",
			"ShoulderSlot",
			"BackSlot",
			"ChestSlot",
			"ShirtSlot",
			"TabardSlot",
			"WristSlot",
			"HandsSlot",
			"WaistSlot",
			"LegsSlot",
			"FeetSlot",
			"MainHandSlot",
			"SecondaryHandSlot",
		}
		for _, object in pairs(MogItGearSlots) do
			if _G["MogItPreview"..i..object] then
				PLUGIN:ApplyItemButtonStyle(_G["MogItPreview"..i..object])
				_G["MogItPreview"..i..object]:SetPushedTexture(nil)
				_G["MogItPreview"..i..object]:SetHighlightTexture(nil)
			end
		end
		if _G["MogItPreview"..i] then PLUGIN:ApplyFrameStyle(_G["MogItPreview"..i]) end
		if _G["MogItPreview"..i.."CloseButton"] then PLUGIN:ApplyCloseButtonStyle(_G["MogItPreview"..i.."CloseButton"]) end
		if _G["MogItPreview"..i.."Inset"] then _G["MogItPreview"..i.."Inset"]:RemoveTextures(true) end
		if _G["MogItPreview"..i.."Activate"] then _G["MogItPreview"..i.."Activate"]:SetStylePanel("Button") end
	end
end

local function StyleMogIt()
	assert(MogItFrame, "AddOn Not Loaded")
	
	PLUGIN:ApplyFrameStyle(MogItFrame)
	MogItFrameInset:RemoveTextures(true)
	PLUGIN:ApplyFrameStyle(MogItFilters)
	MogItFiltersInset:RemoveTextures(true)

	hooksecurefunc(MogIt, "CreatePreview", StyleMogItPreview)
	PLUGIN:ApplyTooltipStyle(MogItTooltip)
	PLUGIN:ApplyCloseButtonStyle(MogItFrameCloseButton)
	PLUGIN:ApplyCloseButtonStyle(MogItFiltersCloseButton)
	MogItFrameFiltersDefaults:RemoveTextures(true)
	MogItFrameFiltersDefaults:SetStylePanel("Button")
	PLUGIN:ApplyScrollFrameStyle(MogItScroll)
	PLUGIN:ApplyScrollFrameStyle(MogItFiltersScrollScrollBar)
end
PLUGIN:SaveAddonStyle("MogIt", StyleMogIt)