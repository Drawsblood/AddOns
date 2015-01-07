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
ALTOHOLIC
##########################################################
]]--
local function ColorAltoBorder(self)
	if self.border then
		local Backdrop = self.backdrop or self.Backdrop
		if not Backdrop then return end
		local r, g, b = self.border:GetVertexColor()
		Backdrop:SetBackdropBorderColor(r, g, b, 1)
	end
end

local function StyleAltoholic(event, addon)
	assert(AltoholicFrame, "AddOn Not Loaded")

	if event == "PLAYER_ENTERING_WORLD" then
		PLUGIN:ApplyTooltipStyle(AltoTooltip)

		AltoholicFramePortrait:Die()

		PLUGIN:ApplyFrameStyle(AltoholicFrame, "Action", false, true)
		PLUGIN:ApplyFrameStyle(AltoMsgBox)
		PLUGIN:ApplyButtonStyle(AltoMsgBoxYesButton)
		PLUGIN:ApplyButtonStyle(AltoMsgBoxNoButton)
		PLUGIN:ApplyCloseButtonStyle(AltoholicFrameCloseButton)
		PLUGIN:ApplyEditBoxStyle(AltoholicFrame_SearchEditBox, 175, 15)
		PLUGIN:ApplyButtonStyle(AltoholicFrame_ResetButton)
		PLUGIN:ApplyButtonStyle(AltoholicFrame_SearchButton)

		AltoholicFrameTab1:SetPointToScale("TOPLEFT", AltoholicFrame, "BOTTOMLEFT", -5, 2)
		AltoholicFrame_ResetButton:SetPointToScale("TOPLEFT", AltoholicFrame, "TOPLEFT", 25, -77)
		AltoholicFrame_SearchEditBox:SetPointToScale("TOPLEFT", AltoholicFrame, "TOPLEFT", 37, -56)
		AltoholicFrame_ResetButton:SetSizeToScale(85, 24)
		AltoholicFrame_SearchButton:SetSizeToScale(85, 24)
	end

	if addon == "Altoholic_Summary" then
		PLUGIN:ApplyFrameStyle(AltoholicFrameSummary)
		PLUGIN:ApplyFrameStyle(AltoholicFrameBagUsage)
		PLUGIN:ApplyFrameStyle(AltoholicFrameSkills)
		PLUGIN:ApplyFrameStyle(AltoholicFrameActivity)
		PLUGIN:ApplyScrollBarStyle(AltoholicFrameSummaryScrollFrameScrollBar)
		PLUGIN:ApplyScrollBarStyle(AltoholicFrameBagUsageScrollFrameScrollBar)
		PLUGIN:ApplyScrollBarStyle(AltoholicFrameSkillsScrollFrameScrollBar)
		PLUGIN:ApplyScrollBarStyle(AltoholicFrameActivityScrollFrameScrollBar)
		PLUGIN:ApplyDropdownStyle(AltoholicTabSummary_SelectLocation, 200)

		if(AltoholicFrameSummaryScrollFrame) then		
			AltoholicFrameSummaryScrollFrame:RemoveTextures(true)
		end

		if(AltoholicFrameBagUsageScrollFrame) then
			AltoholicFrameBagUsageScrollFrame:RemoveTextures(true)
		end

		if(AltoholicFrameSkillsScrollFrame) then
			AltoholicFrameSkillsScrollFrame:RemoveTextures(true)
		end

		if(AltoholicFrameActivityScrollFrame) then
			AltoholicFrameActivityScrollFrame:RemoveTextures(true)
		end

		PLUGIN:ApplyButtonStyle(AltoholicTabSummary_RequestSharing)
		PLUGIN:ApplyTextureStyle(AltoholicTabSummary_RequestSharingIconTexture)
		PLUGIN:ApplyButtonStyle(AltoholicTabSummary_Options)
		PLUGIN:ApplyTextureStyle(AltoholicTabSummary_OptionsIconTexture)
		PLUGIN:ApplyButtonStyle(AltoholicTabSummary_OptionsDataStore)
		PLUGIN:ApplyTextureStyle(AltoholicTabSummary_OptionsDataStoreIconTexture)

		for i = 1, 5 do
			PLUGIN:ApplyButtonStyle(_G["AltoholicTabSummaryMenuItem"..i], true)
		end
		for i = 1, 8 do
			PLUGIN:ApplyButtonStyle(_G["AltoholicTabSummary_Sort"..i], true)
		end
		for i = 1, 7 do
			PLUGIN:ApplyTabStyle(_G["AltoholicFrameTab"..i], true)
		end
	end
	
	if IsAddOnLoaded("Altoholic_Characters") or addon == "Altoholic_Characters" then
		PLUGIN:ApplyFrameStyle(AltoholicFrameContainers)
		PLUGIN:ApplyFrameStyle(AltoholicFrameRecipes)
		PLUGIN:ApplyFrameStyle(AltoholicFrameQuests)
		PLUGIN:ApplyFrameStyle(AltoholicFrameGlyphs)
		PLUGIN:ApplyFrameStyle(AltoholicFrameMail)
		PLUGIN:ApplyFrameStyle(AltoholicFrameSpellbook)
		PLUGIN:ApplyFrameStyle(AltoholicFramePets)
		PLUGIN:ApplyFrameStyle(AltoholicFrameAuctions)
		PLUGIN:ApplyScrollBarStyle(AltoholicFrameContainersScrollFrameScrollBar)
		PLUGIN:ApplyScrollBarStyle(AltoholicFrameQuestsScrollFrameScrollBar)
		PLUGIN:ApplyScrollBarStyle(AltoholicFrameRecipesScrollFrameScrollBar)
		PLUGIN:ApplyDropdownStyle(AltoholicFrameTalents_SelectMember)
		PLUGIN:ApplyDropdownStyle(AltoholicTabCharacters_SelectRealm)
		PLUGIN:ApplyPaginationStyle(AltoholicFrameSpellbookPrevPage)
		PLUGIN:ApplyPaginationStyle(AltoholicFrameSpellbookNextPage)
		PLUGIN:ApplyPaginationStyle(AltoholicFramePetsNormalPrevPage)
		PLUGIN:ApplyPaginationStyle(AltoholicFramePetsNormalNextPage)
		PLUGIN:ApplyRotateStyle(AltoholicFramePetsNormal_ModelFrameRotateLeftButton)
		PLUGIN:ApplyRotateStyle(AltoholicFramePetsNormal_ModelFrameRotateRightButton)
		PLUGIN:ApplyButtonStyle(AltoholicTabCharacters_Sort1)
		PLUGIN:ApplyButtonStyle(AltoholicTabCharacters_Sort2)
		PLUGIN:ApplyButtonStyle(AltoholicTabCharacters_Sort3)
		AltoholicFrameContainersScrollFrame:RemoveTextures(true)
		AltoholicFrameQuestsScrollFrame:RemoveTextures(true)
		AltoholicFrameRecipesScrollFrame:RemoveTextures(true)

		local Buttons = {
			'AltoholicTabCharacters_Characters',
			'AltoholicTabCharacters_CharactersIcon',
			'AltoholicTabCharacters_BagsIcon',
			'AltoholicTabCharacters_QuestsIcon',
			'AltoholicTabCharacters_TalentsIcon',
			'AltoholicTabCharacters_AuctionIcon',
			'AltoholicTabCharacters_MailIcon',
			'AltoholicTabCharacters_SpellbookIcon',
			'AltoholicTabCharacters_ProfessionsIcon',
		}

		for _, object in pairs(Buttons) do
			PLUGIN:ApplyTextureStyle(_G[object..'IconTexture'])
			PLUGIN:ApplyTextureStyle(_G[object])
		end

		for i = 1, 7 do
			for j = 1, 14 do
				PLUGIN:ApplyItemButtonStyle(_G["AltoholicFrameContainersEntry"..i.."Item"..j])
				_G["AltoholicFrameContainersEntry"..i.."Item"..j]:HookScript('OnShow', ColorAltoBorder)
			end
		end
	end

	if IsAddOnLoaded("Altoholic_Achievements") or addon == "Altoholic_Achievements" then
		PLUGIN:ApplyFixedFrameStyle(AltoholicFrameAchievements)
		AltoholicFrameAchievementsScrollFrame:RemoveTextures(true)
		AltoholicAchievementsMenuScrollFrame:RemoveTextures(true)
		PLUGIN:ApplyScrollBarStyle(AltoholicFrameAchievementsScrollFrameScrollBar)
		PLUGIN:ApplyScrollBarStyle(AltoholicAchievementsMenuScrollFrameScrollBar)
		PLUGIN:ApplyDropdownStyle(AltoholicTabAchievements_SelectRealm)
		AltoholicTabAchievements_SelectRealm:SetPointToScale("TOPLEFT", AltoholicFrame, "TOPLEFT", 205, -57)

		for i = 1, 15 do
			PLUGIN:ApplyButtonStyle(_G["AltoholicTabAchievementsMenuItem"..i], true)
		end

		for i = 1, 8 do
			for j = 1, 10 do
				PLUGIN:ApplyFixedFrameStyle(_G["AltoholicFrameAchievementsEntry"..i.."Item"..j])
				local Backdrop = _G["AltoholicFrameAchievementsEntry"..i.."Item"..j].backdrop or _G["AltoholicFrameAchievementsEntry"..i.."Item"..j].Backdrop
				PLUGIN:ApplyTextureStyle(_G["AltoholicFrameAchievementsEntry"..i.."Item"..j..'_Background'])
				_G["AltoholicFrameAchievementsEntry"..i.."Item"..j..'_Background']:SetInside(Backdrop)
			end
		end
	end

	if IsAddOnLoaded("Altoholic_Agenda") or addon == "Altoholic_Agenda" then
		PLUGIN:ApplyFrameStyle(AltoholicFrameCalendarScrollFrame)
		PLUGIN:ApplyFrameStyle(AltoholicTabAgendaMenuItem1)
		PLUGIN:ApplyScrollBarStyle(AltoholicFrameCalendarScrollFrameScrollBar)
		PLUGIN:ApplyPaginationStyle(AltoholicFrameCalendar_NextMonth)
		PLUGIN:ApplyPaginationStyle(AltoholicFrameCalendar_PrevMonth)
		PLUGIN:ApplyButtonStyle(AltoholicTabAgendaMenuItem1, true)

		for i = 1, 14 do
			PLUGIN:ApplyFrameStyle(_G["AltoholicFrameCalendarEntry"..i])
		end
	end

	if IsAddOnLoaded("Altoholic_Grids") or addon == "Altoholic_Grids" then
		AltoholicFrameGridsScrollFrame:RemoveTextures(true)
		PLUGIN:ApplyFixedFrameStyle(AltoholicFrameGrids)
		PLUGIN:ApplyScrollBarStyle(AltoholicFrameGridsScrollFrameScrollBar)
		PLUGIN:ApplyDropdownStyle(AltoholicTabGrids_SelectRealm)
		PLUGIN:ApplyDropdownStyle(AltoholicTabGrids_SelectView)

		for i = 1, 8 do
			for j = 1, 10 do
				PLUGIN:ApplyFixedFrameStyle(_G["AltoholicFrameGridsEntry"..i.."Item"..j], nil, nil, nil, true)
				_G["AltoholicFrameGridsEntry"..i.."Item"..j]:HookScript('OnShow', ColorAltoBorder)
			end
		end

		AltoholicFrameGrids:HookScript('OnUpdate', function()
			for i = 1, 10 do
				for j = 1, 10 do
					if _G["AltoholicFrameGridsEntry"..i.."Item"..j.."_Background"] then
						_G["AltoholicFrameGridsEntry"..i.."Item"..j.."_Background"]:SetTexCoord(.08, .92, .08, .82)
					end
				end
			end
		end)

	end

	if IsAddOnLoaded("Altoholic_Guild") or addon == "Altoholic_Guild" then
		PLUGIN:ApplyFrameStyle(AltoholicFrameGuildMembers)
		PLUGIN:ApplyFrameStyle(AltoholicFrameGuildBank)
		PLUGIN:ApplyScrollBarStyle(AltoholicFrameGuildMembersScrollFrameScrollBar)
		AltoholicFrameGuildMembersScrollFrame:RemoveTextures(true)

		for i = 1, 2 do
			PLUGIN:ApplyButtonStyle(_G["AltoholicTabGuildMenuItem"..i])
		end

		for i = 1, 7 do
			for j = 1, 14 do
				PLUGIN:ApplyItemButtonStyle(_G["AltoholicFrameGuildBankEntry"..i.."Item"..j])
			end
		end

		for i = 1, 19 do
			PLUGIN:ApplyItemButtonStyle(_G["AltoholicFrameGuildMembersItem"..i])
		end

		for i = 1, 5 do
			PLUGIN:ApplyButtonStyle(_G["AltoholicTabGuild_Sort"..i])
		end
	end

	if IsAddOnLoaded("Altoholic_Search") or addon == "Altoholic_Search" then
		PLUGIN:ApplyFixedFrameStyle(AltoholicFrameSearch, true)
		AltoholicFrameSearchScrollFrame:RemoveTextures(true)
		AltoholicSearchMenuScrollFrame:RemoveTextures(true)
		PLUGIN:ApplyScrollBarStyle(AltoholicFrameSearchScrollFrameScrollBar)
		PLUGIN:ApplyScrollBarStyle(AltoholicSearchMenuScrollFrameScrollBar)
		PLUGIN:ApplyDropdownStyle(AltoholicTabSearch_SelectRarity)
		PLUGIN:ApplyDropdownStyle(AltoholicTabSearch_SelectSlot)
		PLUGIN:ApplyDropdownStyle(AltoholicTabSearch_SelectLocation)
		AltoholicTabSearch_SelectRarity:SetSizeToScale(125, 32)
		AltoholicTabSearch_SelectSlot:SetSizeToScale(125, 32)
		AltoholicTabSearch_SelectLocation:SetSizeToScale(175, 32)
		PLUGIN:ApplyEditBoxStyle(_G["AltoholicTabSearch_MinLevel"])
		PLUGIN:ApplyEditBoxStyle(_G["AltoholicTabSearch_MaxLevel"])

		for i = 1, 15 do
			PLUGIN:ApplyButtonStyle(_G["AltoholicTabSearchMenuItem"..i])
		end

		for i = 1, 8 do
			PLUGIN:ApplyButtonStyle(_G["AltoholicTabSearch_Sort"..i])
		end
	end
end

PLUGIN:SaveAddonStyle("Altoholic", StyleAltoholic, nil, true)