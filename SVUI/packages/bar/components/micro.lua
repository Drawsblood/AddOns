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
local math 		= _G.math;
--[[ STRING METHODS ]]--
local find, format, split = string.find, string.format, string.split;
local gsub = string.gsub;
--[[ MATH METHODS ]]--
local ceil = math.ceil;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L;
local MOD = SV.SVBar;
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local NewFrame = CreateFrame
local NewHook = hooksecurefunc
local ICON_FILE = [[Interface\AddOns\SVUI\assets\artwork\Icons\MICROMENU]]
local ICON_DATA = {
  {"CharacterMicroButton",0,0.25,0,0.25},     -- MICRO-CHARACTER
  {"SpellbookMicroButton",0.25,0.5,0,0.25},   -- MICRO-SPELLBOOK
  {"TalentMicroButton",0.5,0.75,0,0.25},      -- MICRO-TALENTS
  {"AchievementMicroButton",0.75,1,0,0.25},   -- MICRO-ACHIEVEMENTS
  {"QuestLogMicroButton",0,0.25,0.25,0.5},    -- MICRO-QUESTS
  {"GuildMicroButton",0.25,0.5,0.25,0.5},     -- MICRO-GUILD
  {"PVPMicroButton",0.5,0.75,0.25,0.5},       -- MICRO-PVP
  {"LFDMicroButton",0.75,1,0.25,0.5},         -- MICRO-LFD
  {"EJMicroButton",0,0.25,0.5,0.75},          -- MICRO-ENCOUNTER
  {"StoreMicroButton",0.25,0.5,0.5,0.75},     -- MICRO-STORE
  {"CompanionsMicroButton",0.5,0.75,0.5,0.75},-- MICRO-COMPANION
  {"MainMenuMicroButton",0.75,1,0.5,0.75},    -- MICRO-SYSTEM
  {"HelpMicroButton",0,0.25,0.75,1},          -- MICRO-HELP
}
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function RefreshMicrobar()
	if not SVUI_MicroBar then return end 
	local lastParent = SVUI_MicroBar;
	local buttonSize =  SV.db.SVBar.Micro.buttonsize or 30;
	local spacing =  SV.db.SVBar.Micro.buttonspacing or 1;
	local barWidth = (buttonSize + spacing) * 13;
	SVUI_MicroBar_MOVE:SetSizeToScale(barWidth, buttonSize)
	SVUI_MicroBar:SetAllPoints(SVUI_MicroBar_MOVE)
	for i=1,13 do
		local data = ICON_DATA[i]
		local button = _G[data[1]]
		if(button) then
			button:ClearAllPoints()
			button:SetSizeToScale(buttonSize, buttonSize + 28)
			button._fade = SV.db.SVBar.Micro.mouseover
			if lastParent == SVUI_MicroBar then 
				button:SetPoint("BOTTOMLEFT", lastParent, "BOTTOMLEFT", 0, 0)
			else 
				button:SetPoint("BOTTOMLEFT", lastParent, "BOTTOMRIGHT", spacing, 0)
			end 
			lastParent = button;
			button:Show()
		end
	end 
end

local SVUIMicroButton_SetNormal = function()
	local level = MainMenuMicroButton:GetFrameLevel()
	if(level > 0) then 
		MainMenuMicroButton:SetFrameLevel(level - 1)
	else 
		MainMenuMicroButton:SetFrameLevel(0)
	end
	MainMenuMicroButton:SetFrameStrata("BACKGROUND")
	MainMenuMicroButton.overlay:SetFrameLevel(level + 1)
	MainMenuMicroButton.overlay:SetFrameStrata("HIGH")
	MainMenuBarPerformanceBar:Hide()
	HelpMicroButton:Show()
end 

local SVUIMicroButtonsParent = function(self)
	if self ~= SVUI_MicroBar then 
		self = SVUI_MicroBar 
	end 
	for i=1,13 do
		local data = ICON_DATA[i]
		if(data) then
			local mButton = _G[data[1]]
			if(mButton) then mButton:SetParent(SVUI_MicroBar) end
		end
	end 
end 

local MicroButton_OnEnter = function(self)
	if(self._fade) then
		SVUI_MicroBar:FadeIn(0.2,SVUI_MicroBar:GetAlpha(),1)
	end
	if InCombatLockdown()then return end 
	self.overlay:SetPanelColor("highlight")
	self.overlay.icon:SetGradient("VERTICAL", 0.75, 0.75, 0.75, 1, 1, 1)
end

local MicroButton_OnLeave = function(self)
	if(self._fade) then
		SVUI_MicroBar:FadeOut(1,SVUI_MicroBar:GetAlpha(),0)
	end
	if InCombatLockdown()then return end 
	self.overlay:SetPanelColor("special")
	self.overlay.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
end
--[[ 
########################################################## 
BAR CREATION
##########################################################
]]--
function MOD:UpdateMicroButtons()
	if(not SV.db.SVBar.Micro.mouseover) then
		SVUI_MicroBar:SetAlpha(1)
	else
		SVUI_MicroBar:SetAlpha(0)
	end
	GuildMicroButtonTabard:ClearAllPoints();
	GuildMicroButtonTabard:Hide();
	RefreshMicrobar()
end

function MOD:InitializeMicroBar()
	local buttonSize = SV.db.SVBar.Micro.buttonsize or 30;
	local spacing =  SV.db.SVBar.Micro.buttonspacing or 1;
	local barWidth = (buttonSize + spacing) * 13;
	local barHeight = (buttonSize + 6);
	local microBar = NewFrame('Frame', 'SVUI_MicroBar', UIParent)
	microBar:SetSizeToScale(barWidth, barHeight)
	microBar:SetFrameStrata("HIGH")
	microBar:SetFrameLevel(0)
	microBar:SetPointToScale('BOTTOMLEFT', SV.Dock.TopLeft.Bar.ToolBar, 'BOTTOMRIGHT', 4, 0)
	SV:AddToDisplayAudit(microBar)

	for i=1,13 do
		local data = ICON_DATA[i]
		if(data) then
			local button = _G[data[1]]
			if(button) then
				button:SetParent(SVUI_MicroBar)
				button:SetSizeToScale(buttonSize, buttonSize + 28)
				button.Flash:SetTexture(0,0,0,0)
				if button.SetPushedTexture then 
					button:SetPushedTexture("")
				end 
				if button.SetNormalTexture then 
					button:SetNormalTexture("")
				end 
				if button.SetDisabledTexture then 
					button:SetDisabledTexture("")
				end 
				if button.SetHighlightTexture then 
					button:SetHighlightTexture("")
				end 
				button:RemoveTextures()

				local buttonMask = NewFrame("Frame",nil,button)
				buttonMask:SetPoint("TOPLEFT",button,"TOPLEFT",0,-28)
				buttonMask:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",0,0)
				buttonMask:SetStylePanel("Framed") 
				buttonMask:SetPanelColor()
				buttonMask.icon = buttonMask:CreateTexture(nil,"OVERLAY",nil,2)
				buttonMask.icon:SetAllPointsIn(buttonMask,2,2)
				buttonMask.icon:SetTexture(ICON_FILE)
				buttonMask.icon:SetTexCoord(data[2],data[3],data[4],data[5])
				buttonMask.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
				button.overlay = buttonMask;
				button._fade = SV.db.SVBar.Micro.mouseover
				button:HookScript('OnEnter', MicroButton_OnEnter)
				button:HookScript('OnLeave', MicroButton_OnLeave)
				button:Show()
			end
		end
	end 

	MicroButtonPortrait:ClearAllPoints()
	MicroButtonPortrait:Hide()
	MainMenuBarPerformanceBar:ClearAllPoints()
	MainMenuBarPerformanceBar:Hide()

	NewHook('MainMenuMicroButton_SetNormal', SVUIMicroButton_SetNormal)
	NewHook('UpdateMicroButtonsParent', SVUIMicroButtonsParent)
	NewHook('MoveMicroButtons', RefreshMicrobar)
	NewHook('UpdateMicroButtons', MOD.UpdateMicroButtons)

	SVUIMicroButtonsParent(microBar)
	SVUIMicroButton_SetNormal()

	SV.Mentalo:Add(microBar, L["Micro Bar"])

	RefreshMicrobar()
	SVUI_MicroBar:SetAlpha(0)
end