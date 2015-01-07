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
CLIQUE
##########################################################
]]--
local CliqueFrames = {
	"CliqueDialog",
	"CliqueConfig",
	"CliqueConfigPage1",
	"CliqueConfigPage2",
	"CliqueClickGrabber",
	"CliqueScrollFrame"
}

local CliqueButtons = {
	"CliqueConfigPage1ButtonSpell",
	"CliqueConfigPage1ButtonOther",
	"CliqueConfigPage1ButtonOptions",
	"CliqueConfigPage2ButtonBinding",
	"CliqueDialogButtonAccept",
	"CliqueDialogButtonBinding",
	"CliqueConfigPage2ButtonSave",
	"CliqueConfigPage2ButtonCancel",
	"CliqueSpellTab",
}

local CliqueStripped = {
	"CliqueConfigPage1Column1",
	"CliqueConfigPage1Column2",
	"CliqueConfigPage1_VSlider",
	"CliqueSpellTab",
	"CliqueConfigPage1ButtonSpell",
	"CliqueConfigPage1ButtonOther",
	"CliqueConfigPage1ButtonOptions",
	"CliqueConfigPage2ButtonBinding",
	"CliqueDialogButtonAccept",
	"CliqueDialogButtonBinding",
	"CliqueConfigPage2ButtonSave",
	"CliqueConfigPage2ButtonCancel",
}

local CliqueConfigPage1_OnShow = function(self)
	for i = 1, 12 do
		if _G["CliqueRow"..i] then
			_G["CliqueRow"..i.."Icon"]:SetTexCoord(0.1,0.9,0.1,0.9);
			_G["CliqueRow"..i.."Bind"]:ClearAllPoints()
			if _G["CliqueRow"..i] == CliqueRow1 then
				_G["CliqueRow"..i.."Bind"]:SetPoint("RIGHT", _G["CliqueRow"..i], 8,0)
			else
				_G["CliqueRow"..i.."Bind"]:SetPoint("RIGHT", _G["CliqueRow"..i], -9,0)
			end
			_G["CliqueRow"..i]:GetHighlightTexture():SetDesaturated(true)
		end
	end
	CliqueRow1:ClearAllPoints()
	CliqueRow1:SetPoint("TOPLEFT",5,-(CliqueConfigPage1Column1:GetHeight() +3))
end

local function StyleClique()
	assert(CliqueDialog, "AddOn Not Loaded")

	for _, gName in pairs(CliqueFrames) do
		local frame = _G[gName]
		if(frame) then
			PLUGIN:ApplyFrameStyle(frame, "Transparent")
			if(gName == "CliqueConfig") then
				frame.Panel:SetPoint("TOPLEFT",0,0)
				frame.Panel:SetPoint("BOTTOMRIGHT",0,-5)
			elseif(gName == "CliqueClickGrabber" or gName == "CliqueScrollFrame") then
				frame.Panel:SetPoint("TOPLEFT",4,0)
				frame.Panel:SetPoint("BOTTOMRIGHT",-2,4)
			else
				frame.Panel:SetPoint("TOPLEFT",0,0)
				frame.Panel:SetPoint("BOTTOMRIGHT",2,0)
			end
		end
	end

	for _, gName in pairs(CliqueStripped) do
		local frame = _G[gName]
		if(frame) then
			frame:RemoveTextures(true)
		end
	end

	for _, gName in pairs(CliqueButtons) do
		local button = _G[gName]
		if(button) then
			button:SetStylePanel("Button")
		end
	end

	PLUGIN:ApplyCloseButtonStyle(CliqueDialog.CloseButton)

	CliqueConfigPage1:SetScript("OnShow", CliqueConfigPage1_OnShow)

	CliqueDialog:SetSize(CliqueDialog:GetWidth()-1, CliqueDialog:GetHeight()-1)

	CliqueConfigPage1ButtonSpell:ClearAllPoints()
	CliqueConfigPage1ButtonSpell:SetPoint("TOPLEFT", CliqueConfigPage1,"BOTTOMLEFT",0,-4)

	CliqueConfigPage1ButtonOptions:ClearAllPoints()
	CliqueConfigPage1ButtonOptions:SetPoint("TOPRIGHT", CliqueConfigPage1,"BOTTOMRIGHT",2,-4)

	CliqueConfigPage2ButtonSave:ClearAllPoints()
	CliqueConfigPage2ButtonSave:SetPoint("TOPLEFT", CliqueConfigPage2,"BOTTOMLEFT",0,-4)

	CliqueConfigPage2ButtonCancel:ClearAllPoints()
	CliqueConfigPage2ButtonCancel:SetPoint("TOPRIGHT", CliqueConfigPage2,"BOTTOMRIGHT",2,-4)

	CliqueSpellTab:GetRegions():SetSize(.1,.1)
	CliqueSpellTab:GetNormalTexture():SetTexCoord(0.1,0.9,0.1,0.9)
	CliqueSpellTab:GetNormalTexture():ClearAllPoints()
	CliqueSpellTab:GetNormalTexture():SetAllPointsIn()
end

PLUGIN:SaveAddonStyle("Clique", StyleClique)