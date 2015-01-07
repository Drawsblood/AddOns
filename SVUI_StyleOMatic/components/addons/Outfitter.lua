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
OUTFITTER
##########################################################
]]--
local function StyleOutfitter()
	assert(OutfitterFrame, "AddOn Not Loaded")
	
	CharacterFrame:HookScript("OnShow", function(self) PaperDollSidebarTabs:SetPoint("BOTTOMRIGHT", CharacterFrameInsetRight, "TOPRIGHT", -14, 0) end)
	OutfitterFrame:HookScript("OnShow", function(self) 
		PLUGIN:ApplyFrameStyle(OutfitterFrame)
		OutfitterFrameTab1:SetSizeToScale(60, 25)
		OutfitterFrameTab2:SetSizeToScale(60, 25)
		OutfitterFrameTab3:SetSizeToScale(60, 25)
		OutfitterMainFrame:RemoveTextures(true)
		for i = 0, 13 do
			if _G["OutfitterItem"..i.."OutfitSelected"] then 
				_G["OutfitterItem"..i.."OutfitSelected"]:SetStylePanel("Button")
				_G["OutfitterItem"..i.."OutfitSelected"]:ClearAllPoints()
				_G["OutfitterItem"..i.."OutfitSelected"]:SetSizeToScale(16)
				_G["OutfitterItem"..i.."OutfitSelected"]:SetPointToScale("LEFT", _G["OutfitterItem"..i.."Outfit"], "LEFT", 8, 0)
			end
		end
	end)
	OutfitterMainFrameScrollbarTrench:RemoveTextures(true)
	OutfitterFrameTab1:ClearAllPoints()
	OutfitterFrameTab2:ClearAllPoints()
	OutfitterFrameTab3:ClearAllPoints()
	OutfitterFrameTab1:SetPointToScale("TOPLEFT", OutfitterFrame, "BOTTOMRIGHT", -65, -2)
	OutfitterFrameTab2:SetPointToScale("LEFT", OutfitterFrameTab1, "LEFT", -65, 0)
	OutfitterFrameTab3:SetPointToScale("LEFT", OutfitterFrameTab2, "LEFT", -65, 0)
	OutfitterFrameTab1:SetStylePanel("Button")
	OutfitterFrameTab2:SetStylePanel("Button")
	OutfitterFrameTab3:SetStylePanel("Button")
	PLUGIN:ApplyScrollFrameStyle(OutfitterMainFrameScrollFrameScrollBar)
	PLUGIN:ApplyCloseButtonStyle(OutfitterCloseButton)
	OutfitterNewButton:SetStylePanel("Button")
	OutfitterEnableNone:SetStylePanel("Button")
	OutfitterEnableAll:SetStylePanel("Button")
	OutfitterButton:ClearAllPoints()
	OutfitterButton:SetPoint("RIGHT", PaperDollSidebarTabs, "RIGHT", 26, -2)
	OutfitterButton:SetHighlightTexture(nil)
	OutfitterSlotEnables:SetFrameStrata("HIGH")
	OutfitterEnableHeadSlot:SetStylePanel("Checkbox", true)
	OutfitterEnableNeckSlot:SetStylePanel("Checkbox", true)
	OutfitterEnableShoulderSlot:SetStylePanel("Checkbox", true)
	OutfitterEnableBackSlot:SetStylePanel("Checkbox", true)
	OutfitterEnableChestSlot:SetStylePanel("Checkbox", true)
	OutfitterEnableShirtSlot:SetStylePanel("Checkbox", true)
	OutfitterEnableTabardSlot:SetStylePanel("Checkbox", true)
	OutfitterEnableWristSlot:SetStylePanel("Checkbox", true)
	OutfitterEnableMainHandSlot:SetStylePanel("Checkbox", true)
	OutfitterEnableSecondaryHandSlot:SetStylePanel("Checkbox", true)
	OutfitterEnableHandsSlot:SetStylePanel("Checkbox", true)
	OutfitterEnableWaistSlot:SetStylePanel("Checkbox", true)
	OutfitterEnableLegsSlot:SetStylePanel("Checkbox", true)
	OutfitterEnableFeetSlot:SetStylePanel("Checkbox", true)
	OutfitterEnableFinger0Slot:SetStylePanel("Checkbox", true)
	OutfitterEnableFinger1Slot:SetStylePanel("Checkbox", true)
	OutfitterEnableTrinket0Slot:SetStylePanel("Checkbox", true)
	OutfitterEnableTrinket1Slot:SetStylePanel("Checkbox", true)
	OutfitterItemComparisons:SetStylePanel("Button")
	OutfitterTooltipInfo:SetStylePanel("Button")
	OutfitterShowHotkeyMessages:SetStylePanel("Button")
	OutfitterShowMinimapButton:SetStylePanel("Button")
	OutfitterShowOutfitBar:SetStylePanel("Button")
	OutfitterAutoSwitch:SetStylePanel("Button")
	OutfitterItemComparisons:SetSizeToScale(20)
	OutfitterTooltipInfo:SetSizeToScale(20)
	OutfitterShowHotkeyMessages:SetSizeToScale(20)
	OutfitterShowMinimapButton:SetSizeToScale(20)
	OutfitterShowOutfitBar:SetSizeToScale(20)
	OutfitterAutoSwitch:SetSizeToScale(20)
	OutfitterShowOutfitBar:SetPointToScale("TOPLEFT", OutfitterAutoSwitch, "BOTTOMLEFT", 0, -5)
	OutfitterEditScriptDialogDoneButton:SetStylePanel("Button")
	OutfitterEditScriptDialogCancelButton:SetStylePanel("Button")
	PLUGIN:ApplyScrollFrameStyle(OutfitterEditScriptDialogSourceScriptScrollBar)
	PLUGIN:ApplyFrameStyle(OutfitterEditScriptDialogSourceScript,"Transparent")
	PLUGIN:ApplyFrameStyle(OutfitterEditScriptDialog)
	PLUGIN:ApplyCloseButtonStyle(OutfitterEditScriptDialog.CloseButton)
	PLUGIN:ApplyTabStyle(OutfitterEditScriptDialogTab1)
	PLUGIN:ApplyTabStyle(OutfitterEditScriptDialogTab2)
end
PLUGIN:SaveAddonStyle("Outfitter", StyleOutfitter)