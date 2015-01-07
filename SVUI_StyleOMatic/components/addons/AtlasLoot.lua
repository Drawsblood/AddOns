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
ATLASLOOT
##########################################################
]]--
local timeLapse = 0;
local nineisthere = {"AtlasLootCompareFrameSortButton_7","AtlasLootCompareFrameSortButton_8","AtlasLootCompareFrameSortButton_9"}
local StripAllTextures = {"AtlasLootDefaultFrame","AtlasLootDefaultFrame_ScrollFrame","AtlasLootItemsFrame","AtlasLootPanel","AtlasLootCompareFrame","AtlasLootCompareFrame_ScrollFrameMainFilterScrollChildFrame","AtlasLootCompareFrame_ScrollFrameItemFrame","AtlasLootCompareFrame_ScrollFrameMainFilter","AtlasLootCompareFrameSortButton_Name","AtlasLootCompareFrameSortButton_Rarity","AtlasLootCompareFrameSortButton_1","AtlasLootCompareFrameSortButton_2","AtlasLootCompareFrameSortButton_3","AtlasLootCompareFrameSortButton_4","AtlasLootCompareFrameSortButton_5","AtlasLootCompareFrameSortButton_6"}

local SetTemplateDefault = {"AtlasLootCompareFrameSortButton_Name","AtlasLootCompareFrameSortButton_Rarity","AtlasLootCompareFrameSortButton_1","AtlasLootCompareFrameSortButton_2","AtlasLootCompareFrameSortButton_3","AtlasLootCompareFrameSortButton_4","AtlasLootCompareFrameSortButton_5","AtlasLootCompareFrameSortButton_6"}

local buttons = {"AtlasLoot_AtlasInfoFrame_ToggleALButton","AtlasLootPanelSearch_SearchButton","AtlasLootDefaultFrame_CompareFrame","AtlasLootPanelSearch_ClearButton","AtlasLootPanelSearch_LastResultButton","AtlasLoot10Man25ManSwitch","AtlasLootItemsFrame_BACK","AtlasLootCompareFrameSearch_ClearButton","AtlasLootCompareFrameSearch_SearchButton","AtlasLootCompareFrame_WishlistButton","AtlasLootCompareFrame_CloseButton2"}

local function AL_OnShow(self, event, ...)
	AtlasLootPanel:SetPointToScale("TOP", AtlasLootDefaultFrame, "BOTTOM", 0, -1)
	AtlasLootQuickLooksButton:SetPointToScale("BOTTOM", AtlasLootItemsFrame, "BOTTOM", 53, 33)
	AtlasLootPanelSearch_Box:ClearAllPoints()
	AtlasLootPanelSearch_Box:SetPointToScale("TOP", AtlasLoot_PanelButton_7, "BOTTOM", 80, -10)
	AtlasLootPanelSearch_SearchButton:SetPointToScale("LEFT", AtlasLootPanelSearch_Box, "RIGHT", 5, 0)
	AtlasLootPanelSearch_SelectModuel:SetPointToScale("LEFT", AtlasLootPanelSearch_SearchButton, "RIGHT", 5, 0)
	AtlasLootPanelSearch_ClearButton:SetPointToScale("LEFT", AtlasLootPanelSearch_SelectModuel, "RIGHT", 5, 0)
	AtlasLootPanelSearch_LastResultButton:SetPointToScale("LEFT", AtlasLootPanelSearch_ClearButton, "RIGHT", 5, 0)
	AtlasLoot10Man25ManSwitch:SetPointToScale("BOTTOM", AtlasLootItemsFrame, "BOTTOM", -130, 4)
	if AtlasLoot_PanelButton_2 then AtlasLoot_PanelButton_2:SetPointToScale("LEFT", AtlasLoot_PanelButton_1, "RIGHT", 1, 0) end
	if AtlasLoot_PanelButton_3 then AtlasLoot_PanelButton_3:SetPointToScale("LEFT", AtlasLoot_PanelButton_2, "RIGHT", 1, 0) end
	if AtlasLoot_PanelButton_4 then AtlasLoot_PanelButton_4:SetPointToScale("LEFT", AtlasLoot_PanelButton_3, "RIGHT", 1, 0) end
	if AtlasLoot_PanelButton_5 then AtlasLoot_PanelButton_5:SetPointToScale("LEFT", AtlasLoot_PanelButton_4, "RIGHT", 1, 0) end
	if AtlasLoot_PanelButton_6 then AtlasLoot_PanelButton_6:SetPointToScale("LEFT", AtlasLoot_PanelButton_5, "RIGHT", 1, 0) end
	if AtlasLoot_PanelButton_8 then AtlasLoot_PanelButton_8:SetPointToScale("LEFT", AtlasLoot_PanelButton_7, "RIGHT", 1, 0) end
	if AtlasLoot_PanelButton_9 then AtlasLoot_PanelButton_9:SetPointToScale("LEFT", AtlasLoot_PanelButton_8, "RIGHT", 1, 0) end
	if AtlasLoot_PanelButton_10 then AtlasLoot_PanelButton_10:SetPointToScale("LEFT", AtlasLoot_PanelButton_9, "RIGHT", 1, 0) end
	if AtlasLoot_PanelButton_11 then AtlasLoot_PanelButton_11:SetPointToScale("LEFT", AtlasLoot_PanelButton_10, "RIGHT", 1, 0) end
	if AtlasLoot_PanelButton_12 then AtlasLoot_PanelButton_12:SetPointToScale("LEFT", AtlasLoot_PanelButton_11, "RIGHT", 1, 0) end
	AtlasLootCompareFrameSortButton_Rarity:SetPointToScale("LEFT", AtlasLootCompareFrameSortButton_Name, "RIGHT", 1, 0)
	AtlasLootCompareFrameSortButton_Rarity:SetWidthToScale(80)
	AtlasLootCompareFrameSortButton_Name:SetWidthToScale(80)
	AtlasLootCompareFrameSortButton_1:SetPointToScale("LEFT", AtlasLootCompareFrameSortButton_Rarity, "RIGHT", 1, 0)
	AtlasLootCompareFrameSortButton_2:SetPointToScale("LEFT", AtlasLootCompareFrameSortButton_1, "RIGHT", 1, 0)
	AtlasLootCompareFrameSortButton_3:SetPointToScale("LEFT", AtlasLootCompareFrameSortButton_2, "RIGHT", 1, 0)
	AtlasLootCompareFrameSortButton_4:SetPointToScale("LEFT", AtlasLootCompareFrameSortButton_3, "RIGHT", 1, 0)
	AtlasLootCompareFrameSortButton_5:SetPointToScale("LEFT", AtlasLootCompareFrameSortButton_4, "RIGHT", 1, 0)
	AtlasLootCompareFrameSortButton_6:SetPointToScale("LEFT", AtlasLootCompareFrameSortButton_5, "RIGHT", 1, 0)
	AtlasLootCompareFrame_CloseButton2:SetPointToScale("BOTTOMRIGHT", AtlasLootCompareFrame, "BOTTOMRIGHT", -7, 10)
	AtlasLootCompareFrame_WishlistButton:SetPointToScale("RIGHT", AtlasLootCompareFrame_CloseButton2, "LEFT", -1, 0)
	AtlasLootCompareFrameSearch_SearchButton:SetPointToScale("LEFT", AtlasLootCompareFrameSearch_Box, "RIGHT", 5, 0)
	AtlasLootCompareFrameSearch_SelectModuel:SetPointToScale("LEFT", AtlasLootCompareFrameSearch_SearchButton, "RIGHT", 5, 0)
	AtlasLootDefaultFrame_CloseButton:ClearAllPoints()
	AtlasLootDefaultFrame_CloseButton:SetPoint("TOPRIGHT", AtlasLootDefaultFrame, "TOPRIGHT", -5 -2)
	AtlasLootDefaultFrame:SetFrameLevel(0)
	AtlasLootItemsFrame:SetFrameLevel(AtlasLootDefaultFrame:GetFrameLevel()+1)
	for i = 1, 30 do if _G["AtlasLootDefaultFrame_ScrollLine"..i] then _G["AtlasLootDefaultFrame_ScrollLine"..i]:SetFrameLevel(AtlasLootDefaultFrame:GetFrameLevel()+1)end end 

	if(AtlasLootDefaultFrame_PackageSelect) then
		AtlasLootDefaultFrame_PackageSelect:SetFrameLevel(AtlasLootDefaultFrame:GetFrameLevel()+1)
	end
	AtlasLootDefaultFrame_InstanceSelect:SetFrameLevel(AtlasLootDefaultFrame:GetFrameLevel()+1)
	AtlasLoot_AtlasInfoFrame_ToggleALButton:SetFrameLevel(AtlasLootDefaultFrame:GetFrameLevel()+1)
	AtlasLootDefaultFrame_CompareFrame:SetFrameLevel(AtlasLootDefaultFrame:GetFrameLevel()+1)
	AtlasLootPanelSearch_Box:SetHeight(16)
	AtlasLootPanel:SetWidth(921)
end

local function Nine_IsThere(self, elapsed)
	self.timeLapse = self.timeLapse + elapsed
	if(self.timeLapse < 2) then 
		return 
	else
		self.timeLapse = 0
	end
	for i = 1, 9 do local f = _G["AtlasLootCompareFrameSortButton_"..i]f:SetWidth(44.44)end 
	for _, object in pairs(nineisthere) do PLUGIN:ApplyFrameStyle(_G[object]) end 
	AtlasLootCompareFrameSortButton_7:SetPointToScale("LEFT", AtlasLootCompareFrameSortButton_6, "RIGHT", 1, 0)
	AtlasLootCompareFrameSortButton_8:SetPointToScale("LEFT", AtlasLootCompareFrameSortButton_7, "RIGHT", 1, 0)
	AtlasLootCompareFrameSortButton_9:SetPointToScale("LEFT", AtlasLootCompareFrameSortButton_8, "RIGHT", 1, 0)
end

local function Compare_OnShow(self, event, ...)
	for i = 1, 6 do _G["AtlasLootCompareFrameSortButton_"..i]:SetWidth(40)end 
	local Nine = AtlasLootCompareFrameSortButton_9
	if Nine ~= nil then
		Nine.timeLapse = 0
		Nine:SetScript("OnUpdate", Nine_IsThere)
	end 
end

local _hook_ALPanel = function(self,_,parent,_,_,_,breaker)
	if not breaker then 
		self:ClearAllPoints()
		self:SetPoint("TOP",parent,"BOTTOM",0,-1,true)
	end 
end

local _hook_OnUpdate = function(self, elapsed)
	self.timeLapse = self.timeLapse + elapsed
	if(self.timeLapse < 2) then 
		return 
	else
		self.timeLapse = 0
	end
	self:SetWidth(AtlasLootDefaultFrame:GetWidth()) 
end


local function StyleAtlasLoot(event, addon)
	assert(AtlasLootPanel, "AddOn Not Loaded")

	for _, object in pairs(StripAllTextures) do _G[object]:RemoveTextures()end 
	for _, object in pairs(SetTemplateDefault) do PLUGIN:ApplyFrameStyle(_G[object], "Default")end 
	for _, button in pairs(buttons) do _G[button]:SetStylePanel("Button")end 

	-- Manipulate the main frames
	PLUGIN:ApplyFrameStyle(_G["AtlasLootDefaultFrame"], "Action");
	PLUGIN:ApplyFixedFrameStyle(_G["AtlasLootItemsFrame"], "Inset");
	PLUGIN:ApplyFrameStyle(_G["AtlasLootPanel"], "Default");
	hooksecurefunc(_G["AtlasLootPanel"], "SetPoint", _hook_ALPanel);

	_G["AtlasLootPanel"]:SetPoint("TOP",_G["AtlasLootDefaultFrame"],"BOTTOM",0,-1);
	-- Back to the rest
	PLUGIN:ApplyFrameStyle(_G["AtlasLootCompareFrame"], "Transparent");
	if AtlasLoot_PanelButton_1 then AtlasLoot_PanelButton_1:SetStylePanel("Button") end
	if AtlasLoot_PanelButton_2 then AtlasLoot_PanelButton_2:SetStylePanel("Button") end
	if AtlasLoot_PanelButton_3 then AtlasLoot_PanelButton_3:SetStylePanel("Button") end
	if AtlasLoot_PanelButton_4 then AtlasLoot_PanelButton_4:SetStylePanel("Button") end
	if AtlasLoot_PanelButton_5 then AtlasLoot_PanelButton_5:SetStylePanel("Button") end
	if AtlasLoot_PanelButton_6 then AtlasLoot_PanelButton_6:SetStylePanel("Button") end
	if AtlasLoot_PanelButton_7 then AtlasLoot_PanelButton_7:SetStylePanel("Button") end
	if AtlasLoot_PanelButton_8 then AtlasLoot_PanelButton_8:SetStylePanel("Button") end
	if AtlasLoot_PanelButton_9 then AtlasLoot_PanelButton_9:SetStylePanel("Button") end
	if AtlasLoot_PanelButton_10 then AtlasLoot_PanelButton_10:SetStylePanel("Button") end
	if AtlasLoot_PanelButton_11 then AtlasLoot_PanelButton_11:SetStylePanel("Button") end
	if AtlasLoot_PanelButton_12 then AtlasLoot_PanelButton_12:SetStylePanel("Button") end

	for i = 1, 15 do local f = _G["AtlasLootCompareFrameMainFilterButton"..i]f:RemoveTextures() end 

	PLUGIN:ApplyCloseButtonStyle(AtlasLootDefaultFrame_CloseButton)
	PLUGIN:ApplyCloseButtonStyle(AtlasLootCompareFrame_CloseButton)
	PLUGIN:ApplyCloseButtonStyle(AtlasLootCompareFrame_CloseButton_Wishlist)
	PLUGIN:ApplyPaginationStyle(AtlasLootQuickLooksButton)
	PLUGIN:ApplyPaginationStyle(AtlasLootItemsFrame_NEXT)
	AtlasLootItemsFrame_NEXT:SetWidth(25)
	AtlasLootItemsFrame_NEXT:SetHeight(25)
	PLUGIN:ApplyPaginationStyle(AtlasLootItemsFrame_PREV)
	AtlasLootItemsFrame_PREV:SetWidth(25)
	AtlasLootItemsFrame_PREV:SetHeight(25)
	PLUGIN:ApplyPaginationStyle(AtlasLootPanelSearch_SelectModuel)	
	PLUGIN:ApplyPaginationStyle(AtlasLootCompareFrameSearch_SelectModuel)

	if(AtlasLootDefaultFrame_PackageSelect) then
		PLUGIN:ApplyDropdownStyle(AtlasLootDefaultFrame_PackageSelect)
		AtlasLootDefaultFrame_PackageSelect:SetWidth(240)
		AtlasLootDefaultFrame_PackageSelect:SetPoint("TOPLEFT", AtlasLootDefaultFrame, "TOPLEFT", 50, -50)
	end

	PLUGIN:ApplyDropdownStyle(AtlasLootDefaultFrame_ModuleSelect,240)
	PLUGIN:ApplyDropdownStyle(AtlasLootDefaultFrame_InstanceSelect,240)
	
	PLUGIN:ApplyDropdownStyle(AtlasLootCompareFrameSearch_StatsListDropDown)
	AtlasLootCompareFrameSearch_StatsListDropDown:SetWidth(240)
	PLUGIN:ApplyDropdownStyle(AtlasLootCompareFrame_WishlistDropDown)
	AtlasLootCompareFrame_WishlistDropDown:SetWidth(240)
	AtlasLootPanelSearch_Box:SetStylePanel("Editbox")
	AtlasLootCompareFrameSearch_Box:SetStylePanel("Editbox")

	if AtlasLootFilterCheck then 
		AtlasLootFilterCheck:SetStylePanel("Checkbox", true) 
	end
	if AtlasLootItemsFrame_Heroic then 
		AtlasLootItemsFrame_Heroic:SetStylePanel("Checkbox", true) 
	end
	if AtlasLootCompareFrameSearch_FilterCheck then AtlasLootCompareFrameSearch_FilterCheck:SetStylePanel("Checkbox", true)
	end
	if AtlasLootItemsFrame_RaidFinder then 
		AtlasLootItemsFrame_RaidFinder:SetStylePanel("Checkbox", true) 
	end
	if AtlasLootItemsFrame_Thunderforged then 
		AtlasLootItemsFrame_Thunderforged:SetStylePanel("Checkbox", true) 
	end

	AtlasLootPanel.Titel:SetTextColor(23/255, 132/255, 209/255)
	AtlasLootPanel.Titel:SetPoint("BOTTOM", AtlasLootPanel.TitelBg, "BOTTOM", 0, 40)
	PLUGIN:ApplyScrollFrameStyle(AtlasLootCompareFrame_ScrollFrameItemFrameScrollBar)
	PLUGIN:ApplyScrollFrameStyle(AtlasLootCompareFrame_WishlistScrollFrameScrollBar)
	AtlasLootDefaultFrame:HookScript("OnShow", AL_OnShow)
	AtlasLootCompareFrame:HookScript("OnShow", Compare_OnShow)
	AtlasLootPanel.timeLapse = 0;

	--AtlasLootPanel:HookScript("OnUpdate", _hook_OnUpdate)

	if(AtlasLootTooltip:GetName() ~= "GameTooltip") then 
		PLUGIN:ApplyTooltipStyle(AtlasLootTooltip)
	end
end
PLUGIN:SaveAddonStyle("AtlasLoot", StyleAtlasLoot, nil, true)