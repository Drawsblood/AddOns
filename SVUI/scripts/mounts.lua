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
local unpack 		= _G.unpack;
local select 		= _G.select;
local pairs 		= _G.pairs;
local tonumber		= _G.tonumber;
local tinsert 		= _G.tinsert;
local table 		= _G.table;
local math 			= _G.math;
local bit 			= _G.bit;
local random 		= math.random; 
local twipe,band 	= table.wipe, bit.band;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L
--[[ 
########################################################## 
LOCAL VARIABLES
##########################################################
]]--
local ttSummary = "";
local NewHook = hooksecurefunc;
local CountMounts, MountInfo, RandomMount, MountUp, UnMount;

local MountListener = CreateFrame("Frame");
MountListener.favorites = false
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
function CountMounts()
	return C_MountJournal.GetNumMounts()
end
function MountInfo(index)
	return true, C_MountJournal.GetMountInfo(index)
end
function RandomMount()
	if(MountListener.favorites) then
		return 0
	end
	maxMounts = C_MountJournal.GetNumMounts()
	return random(1, maxMounts)
end
function MountUp(index)
	index = index or RandomMount()
	return C_MountJournal.Summon(index)
end
UnMount = C_MountJournal.Dismiss

local function UpdateMountCheckboxes(button, index)
	local _, creatureName = MountInfo(index);

	local n = button.MountBar
	local bar = _G[n]

	if(bar) then
		bar["GROUND"].index = index
		bar["GROUND"].name = creatureName
		bar["FLYING"].index = index
		bar["FLYING"].name = creatureName
		bar["SWIMMING"].index = index
		bar["SWIMMING"].name = creatureName
	    bar["SPECIAL"].index = index
	    bar["SPECIAL"].name = creatureName

		if(SV.cache.Mounts.names["GROUND"] == creatureName) then
			if(SV.cache.Mounts.types["GROUND"] ~= index) then
				SV.cache.Mounts.types["GROUND"] = index
			end
			bar["GROUND"]:SetChecked(true)
		else
			bar["GROUND"]:SetChecked(false)
		end

		if(SV.cache.Mounts.names["FLYING"] == creatureName) then
			if(SV.cache.Mounts.types["FLYING"] ~= index) then
				SV.cache.Mounts.types["FLYING"] = index
			end
			bar["FLYING"]:SetChecked(true)
		else
			bar["FLYING"]:SetChecked(false)
		end

		if(SV.cache.Mounts.names["SWIMMING"] == creatureName) then
			if(SV.cache.Mounts.types["SWIMMING"] ~= index) then
				SV.cache.Mounts.types["SWIMMING"] = index
			end
			bar["SWIMMING"]:SetChecked(true)
		else
			bar["SWIMMING"]:SetChecked(false)
		end

		if(SV.cache.Mounts.names["SPECIAL"] == creatureName) then
			if(SV.cache.Mounts.types["SPECIAL"] ~= index) then
				SV.cache.Mounts.types["SPECIAL"] = index
			end
			bar["SPECIAL"]:SetChecked(true)
		else
			bar["SPECIAL"]:SetChecked(false)
		end
	end
end

local function UpdateMountsCache()
	if(not MountJournal) then return end
	local num = CountMounts()
	MountListener.favorites = false

	for index = 1, num, 1 do
		local _, info, id, _, _, _, _, _, favorite = MountInfo(index)
		if(favorite == true) then
			MountListener.favorites = true
		end
		if(SV.cache.Mounts.names["GROUND"] == info) then
			if(SV.cache.Mounts.types["GROUND"] ~= index) then
				SV.cache.Mounts.types["GROUND"] = index
			end
		end
		if(SV.cache.Mounts.names["FLYING"] == info) then
			if(SV.cache.Mounts.types["FLYING"] ~= index) then
				SV.cache.Mounts.types["FLYING"] = index
			end
		end
		if(SV.cache.Mounts.names["SWIMMING"] == info) then
			if(SV.cache.Mounts.types["SWIMMING"] ~= index) then
				SV.cache.Mounts.types["SWIMMING"] = index
			end
		end
		if(SV.cache.Mounts.names["SPECIAL"] == info) then
			if(SV.cache.Mounts.types["SPECIAL"] ~= index) then
				SV.cache.Mounts.types["SPECIAL"] = index
			end
		end
	end
end

local function Update_MountCheckButtons()
	if(not MountJournal or (MountJournal and not MountJournal.cachedMounts)) then return end
	local count = #MountJournal.cachedMounts
	if(type(count) ~= "number") then return end 
	local scrollFrame = MountJournal.ListScrollFrame;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
    local buttons = scrollFrame.buttons;
	for i=1, #buttons do
        local button = buttons[i];
        local displayIndex = i + offset;
        if ( displayIndex <= count ) then
			local index = MountJournal.cachedMounts[displayIndex];
			UpdateMountCheckboxes(button, index)
		end
	end
end

local ProxyUpdate_Mounts = function(self, event, ...)
	if(event == "COMPANION_LEARNED" or event == "COMPANION_UNLEARNED") then
		UpdateMountsCache()
	end
	Update_MountCheckButtons()
end

local function UpdateCurrentMountSelection()
	ttSummary = ""
	local creatureName

	if(SV.cache.Mounts.types["FLYING"]) then
		creatureName = SV.cache.Mounts.names["FLYING"]
		if(creatureName) then
			ttSummary = ttSummary .. "\nFlying: " .. creatureName
		end
	end

	if(SV.cache.Mounts.types["SWIMMING"]) then
		creatureName = SV.cache.Mounts.names["SWIMMING"]
		if(creatureName) then
			ttSummary = ttSummary .. "\nSwimming: " .. creatureName
		end
	end

	if(SV.cache.Mounts.types["GROUND"]) then
		creatureName = SV.cache.Mounts.names["GROUND"]
		if(creatureName) then
			ttSummary = ttSummary .. "\nGround: " .. creatureName
		end
	end

	if(SV.cache.Mounts.types["SPECIAL"]) then
		creatureName = SV.cache.Mounts.names["SPECIAL"]
		if(creatureName) then
			ttSummary = ttSummary .. "\nSpecial: " .. creatureName
		end
	end
end

local CheckButton_OnClick = function(self)
	local index = self.index
	local name = self.name
	local key = self.key

	if(index) then
		if(self:GetChecked() == true) then
			SV.cache.Mounts.types[key] = index
			SV.cache.Mounts.names[key] = name
		else
			SV.cache.Mounts.types[key] = false
			SV.cache.Mounts.names[key] = ""
		end
		Update_MountCheckButtons()
		UpdateCurrentMountSelection()
	end
	GameTooltip:Hide()
end

local CheckButton_OnEnter = function(self)
	local index = self.name
	local key = self.key
	local r,g,b = self:GetBackdropColor()
	GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 0, 20)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(key,r,g,b)
	GameTooltip:AddLine("",1,1,0)
	GameTooltip:AddLine("Check this box to enable/disable \nthis mount for \nthe 'Lets Ride' key-binding",1,1,1)
	if(key == "SPECIAL") then
		GameTooltip:AddLine("",1,1,0)
		GameTooltip:AddLine("Hold |cff00FF00[SHIFT]|r or |cff00FF00[CTRL]|r while \nclicking to force this mount \nover all others.",1,1,1)
	end
	GameTooltip:AddLine(ttSummary,1,1,1)
	
	GameTooltip:Show()
end

local CheckButton_OnLeave = function(self)
	GameTooltip:Hide()
end
--[[ 
########################################################## 
ADDING CHECKBOXES TO JOURNAL
##########################################################
]]--
local function SetMountCheckButtons()
	LoadAddOn("Blizzard_PetJournal")
	SV.cache.Mounts = SV.cache.Mounts or {}

	if not SV.cache.Mounts.types then 
		SV.cache.Mounts.types = {
			["GROUND"] = false, 
			["FLYING"] = false, 
			["SWIMMING"] = false, 
			["SPECIAL"] = false
		}
	end
	if not SV.cache.Mounts.names then 
		SV.cache.Mounts.names = {
			["GROUND"] = "", 
			["FLYING"] = "", 
			["SWIMMING"] = "", 
			["SPECIAL"] = ""	
		} 
	end

	UpdateMountsCache()

	local scrollFrame = MountJournal.ListScrollFrame;
	local scrollBar = _G["MountJournalListScrollFrameScrollBar"]
    local buttons = scrollFrame.buttons;

	for i = 1, #buttons do
		local button = buttons[i]
		local barWidth = button:GetWidth()
		local width = (barWidth - 18) * 0.25
		local height = 7
		local barName = ("SVUI_MountSelectBar%d"):format(i)

		local buttonBar = CreateFrame("Frame", barName, button)
		buttonBar:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 0, 0)
		buttonBar:SetSize(barWidth, height + 8)

		--[[ CREATE CHECKBOXES ]]--
		buttonBar["GROUND"] = CreateFrame("CheckButton", ("%s_GROUND"):format(barName), buttonBar, "UICheckButtonTemplate")
		buttonBar["GROUND"]:SetSize(width,height)
		buttonBar["GROUND"]:SetPoint("BOTTOMLEFT", buttonBar, "BOTTOMLEFT", 6, 4)
		buttonBar["GROUND"]:RemoveTextures()
	    buttonBar["GROUND"]:SetStylePanel("Colored")
	    buttonBar["GROUND"]:SetPanelColor(0.2, 0.7, 0.1, 0.15)
	    buttonBar["GROUND"]:GetCheckedTexture():SetVertexColor(0.2, 0.7, 0.1, 1)
	    buttonBar["GROUND"].key = "GROUND"
		buttonBar["GROUND"]:SetChecked(false)
		buttonBar["GROUND"]:SetScript("OnClick", CheckButton_OnClick)
		buttonBar["GROUND"]:SetScript("OnEnter", CheckButton_OnEnter)
		buttonBar["GROUND"]:SetScript("OnLeave", CheckButton_OnLeave)

	    buttonBar["FLYING"] = CreateFrame("CheckButton", ("%s_FLYING"):format(barName), buttonBar, "UICheckButtonTemplate")
		buttonBar["FLYING"]:SetSize(width,height)
		buttonBar["FLYING"]:SetPoint("BOTTOMLEFT", buttonBar["GROUND"], "BOTTOMRIGHT", 2, 0)
		buttonBar["FLYING"]:RemoveTextures()
	    buttonBar["FLYING"]:SetStylePanel("Colored")
	    buttonBar["FLYING"]:SetPanelColor(1, 1, 0.2, 0.15)
	    buttonBar["FLYING"]:GetCheckedTexture():SetVertexColor(1, 1, 0.2, 1)
	    buttonBar["FLYING"].key = "FLYING"
		buttonBar["FLYING"]:SetChecked(false)
		buttonBar["FLYING"]:SetScript("OnClick", CheckButton_OnClick)
		buttonBar["FLYING"]:SetScript("OnEnter", CheckButton_OnEnter)
		buttonBar["FLYING"]:SetScript("OnLeave", CheckButton_OnLeave)

	    buttonBar["SWIMMING"] = CreateFrame("CheckButton", ("%s_SWIMMING"):format(barName), buttonBar, "UICheckButtonTemplate")
		buttonBar["SWIMMING"]:SetSize(width,height)
		buttonBar["SWIMMING"]:SetPoint("BOTTOMLEFT", buttonBar["FLYING"], "BOTTOMRIGHT", 2, 0)
		buttonBar["SWIMMING"]:RemoveTextures()
	    buttonBar["SWIMMING"]:SetStylePanel("Colored")
	    buttonBar["SWIMMING"]:SetPanelColor(0.2, 0.42, 0.76, 0.15)
	    buttonBar["SWIMMING"]:GetCheckedTexture():SetVertexColor(0.2, 0.42, 0.76, 1)
	    buttonBar["SWIMMING"].key = "SWIMMING"
		buttonBar["SWIMMING"]:SetChecked(false)
		buttonBar["SWIMMING"]:SetScript("OnClick", CheckButton_OnClick)
		buttonBar["SWIMMING"]:SetScript("OnEnter", CheckButton_OnEnter)
		buttonBar["SWIMMING"]:SetScript("OnLeave", CheckButton_OnLeave)

		buttonBar["SPECIAL"] = CreateFrame("CheckButton", ("%s_SPECIAL"):format(barName), buttonBar, "UICheckButtonTemplate")
		buttonBar["SPECIAL"]:SetSize(width,height)
		buttonBar["SPECIAL"]:SetPoint("BOTTOMLEFT", buttonBar["SWIMMING"], "BOTTOMRIGHT", 2, 0)
		buttonBar["SPECIAL"]:RemoveTextures()
	    buttonBar["SPECIAL"]:SetStylePanel("Colored")
	    buttonBar["SPECIAL"]:SetPanelColor(0.7, 0.1, 0.1, 0.15)
	    buttonBar["SPECIAL"]:GetCheckedTexture():SetVertexColor(0.7, 0.1, 0.1, 1)
	    buttonBar["SPECIAL"].key = "SPECIAL"	
		buttonBar["SPECIAL"]:SetChecked(false)
		buttonBar["SPECIAL"]:SetScript("OnClick", CheckButton_OnClick)
		buttonBar["SPECIAL"]:SetScript("OnEnter", CheckButton_OnEnter)
		buttonBar["SPECIAL"]:SetScript("OnLeave", CheckButton_OnLeave)

		button.MountBar = barName

		UpdateMountCheckboxes(button, i)
	end

	UpdateCurrentMountSelection()

	MountListener:RegisterEvent("MOUNT_JOURNAL_USABILITY_CHANGED")
	
	MountListener:RegisterEvent("COMPANION_LEARNED")
	MountListener:RegisterEvent("COMPANION_UNLEARNED")
	MountListener:RegisterEvent("COMPANION_UPDATE")
	MountListener:SetScript("OnEvent", ProxyUpdate_Mounts)

	scrollFrame:HookScript("OnMouseWheel", Update_MountCheckButtons)
	scrollBar:HookScript("OnValueChanged", Update_MountCheckButtons)
	NewHook("MountJournal_UpdateMountList", Update_MountCheckButtons)
end
--[[ 
########################################################## 
SLASH FUNCTION
##########################################################
]]--
_G.SVUILetsRide = function()
	local maxMounts = CountMounts()

	if(not maxMounts or IsMounted()) then
		UnMount()
		return
	end

	if(CanExitVehicle()) then
		VehicleExit()
		return
	end

	SV.cache.Mounts = SV.cache.Mounts or {}
	if not SV.cache.Mounts.types then 
		SV.cache.Mounts.types = {
			["GROUND"] = false, 
			["FLYING"] = false, 
			["SWIMMING"] = false, 
			["SPECIAL"] = false
		}
	end

	local continent = GetCurrentMapContinent()
	local checkList = SV.cache.Mounts.types
	local letsFly = (IsFlyableArea() and (continent ~= 962 and continent ~= 7))
	local letsSwim = IsSwimming()

	if(IsModifierKeyDown() and checkList["SPECIAL"]) then
		MountUp(checkList["SPECIAL"])
	else
		if(letsSwim) then
			if(checkList["SWIMMING"]) then
				MountUp(checkList["SWIMMING"])
			elseif(letsFly) then
				MountUp(checkList["FLYING"])
			else
				MountUp(checkList["GROUND"])
			end
		elseif(letsFly) then
			if(checkList["FLYING"]) then
				MountUp(checkList["FLYING"])
			else
				MountUp(checkList["GROUND"])
			end
		else
			MountUp(checkList["GROUND"])
		end
	end
end
--[[ 
########################################################## 
LOADER
##########################################################
]]--
SV:NewScript(SetMountCheckButtons);