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
local unpack        = _G.unpack;
local select        = _G.select;
local assert        = _G.assert;
local type          = _G.type;
local error         = _G.error;
local pcall         = _G.pcall;
local print         = _G.print;
local ipairs        = _G.ipairs;
local pairs         = _G.pairs;
local next          = _G.next;
local rawset        = _G.rawset;
local rawget        = _G.rawget;
local tostring      = _G.tostring;
local tonumber      = _G.tonumber;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
--[[ STRING METHODS ]]--
local find, format, len, split = string.find, string.format, string.len, string.split;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round, max = math.abs, math.ceil, math.floor, math.round, math.max;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L
local LSM = LibStub("LibSharedMedia-3.0")
local MOD = SV.SVOverride;
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local POSITION, ANCHOR_POINT, YOFFSET = "TOP", "BOTTOM", -10
local FORCE_POSITION = false;
local NewHook = hooksecurefunc;
local lastQuality,lastID,lastName;
local dead_rollz = {}
local RollTypePresets = {
	[0] = {
		"Interface\\Buttons\\UI-GroupLoot-Pass-Up",
		"",
		"Interface\\Buttons\\UI-GroupLoot-Pass-Down",
		[[0]],
		[[2]]
	},
	[1] = {
		"Interface\\Buttons\\UI-GroupLoot-Dice-Up",
		"Interface\\Buttons\\UI-GroupLoot-Dice-Highlight",
		"Interface\\Buttons\\UI-GroupLoot-Dice-Down",
		[[5]],
		[[-1]]
	},
	[2] = {
		"Interface\\Buttons\\UI-GroupLoot-Coin-Up",
		"Interface\\Buttons\\UI-GroupLoot-Coin-Highlight",
		"Interface\\Buttons\\UI-GroupLoot-Coin-Down",
		[[0]],
		[[-1]]
	},
	[3] = {
		"Interface\\Buttons\\UI-GroupLoot-DE-Up",
		"Interface\\Buttons\\UI-GroupLoot-DE-Highlight",
		"Interface\\Buttons\\UI-GroupLoot-DE-Down",
		[[0]],
		[[-1]]
	}
};
local LootRollType = {[1] = "need", [2] = "greed", [3] = "disenchant", [0] = "pass"};
local LOOT_WIDTH, LOOT_HEIGHT = 328, 28;

local SVUI_LootFrameHolder = CreateFrame("Frame", "SVUI_LootFrameHolder", UIParent);
SVUI_LootFrameHolder:SetPoint("BOTTOMRIGHT", SVUI_DockTopLeft, "BOTTOMRIGHT", 0, 0);
SVUI_LootFrameHolder:SetSize(150, 22);

local SVUI_LootFrame = CreateFrame('Button', 'SVUI_LootFrame', SVUI_LootFrameHolder);
SVUI_LootFrame:SetClampedToScreen(true);
SVUI_LootFrame:SetPoint('TOPLEFT');
SVUI_LootFrame:SetSize(256, 64);
SVUI_LootFrame:SetFrameStrata("FULLSCREEN_DIALOG");
SVUI_LootFrame:SetToplevel(true);
SVUI_LootFrame.title = SVUI_LootFrame:CreateFontString(nil,'OVERLAY');
SVUI_LootFrame.title:SetPoint('BOTTOMLEFT',SVUI_LootFrame,'TOPLEFT',0,1);
SVUI_LootFrame.slots = {};
SVUI_LootFrame:SetScript("OnHide", Loot_OnHide);
--[[ 
########################################################## 
LOOTING
##########################################################
]]--
local function UpdateLootUpvalues()
	LOOT_WIDTH = SV.db.SVOverride.lootRollWidth
	LOOT_HEIGHT = SV.db.SVOverride.lootRollHeight
end

local DoDaRoll = function(self)
	RollOnLoot(self.parent.rollID, self.rolltype)
end 

local Loot_OnHide = function(self)
	SV:StaticPopup_Hide("CONFIRM_LOOT_DISTRIBUTION");
	CloseLoot()
end

local LootRoll_OnLeave = function(self)
	GameTooltip:Hide()
end 

local LootItem_OnLeave = function(self)
	GameTooltip:Hide()
	ResetCursor()
end 

local LootRoll_SetTooltip = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(self.tiptext)
	if self:IsEnabled() == 0 then
		GameTooltip:AddLine("|cffff3333"..L["Can't Roll"])
	end 
	for r, s in pairs(self.parent.rolls)do 
		if LootRollType[s] == LootRollType[self.rolltype] then
			GameTooltip:AddLine(r, 1, 1, 1)
		end 
	end 
	GameTooltip:Show()
end 

local LootItem_SetTooltip = function(self)
	if not self.link then
		return 
	end 
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
	GameTooltip:SetHyperlink(self.link)
	if IsShiftKeyDown() then
		GameTooltip_ShowCompareItem()
	end 
	if IsModifiedClick("DRESSUP") then
		ShowInspectCursor()
	else
		ResetCursor()
	end 
end 

local LootItem_OnUpdate = function(self)
	if IsShiftKeyDown() then
		GameTooltip_ShowCompareItem()
	end 
	CursorOnUpdate(self)
end 

local LootRoll_OnClick = function(self)
	if IsControlKeyDown() then
		DressUpItemLink(self.link)
	elseif IsShiftKeyDown() then 
		ChatEdit_InsertLink(self.link)
	end 
end 

local LootRoll_OnEvent = function(self, event, value)
	dead_rollz[value] = true;
	if self.rollID ~= value then
		return 
	end 
	self.rollID = nil;
	self.time = nil;
	self:Hide()
end 

local LootRoll_OnUpdate = function(self)
	if not self.parent.rollID then return end 
	local remaining = GetLootRollTimeLeft(self.parent.rollID)
	local mu = remaining / self.parent.time;
	self.spark:SetPointToScale("CENTER", self, "LEFT", mu * self:GetWidth(), 0)
	self:SetValue(remaining)
	if remaining > 1000000000 then
		self:GetParent():Hide()
	end 
end 

local LootSlot_OnEnter = function(self)
	local slotID = self:GetID()
	if LootSlotHasItem(slotID) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(slotID)
		CursorUpdate(self)
	end 
	self.drop:Show()
	self.drop:SetVertexColor(1, 1, 0)
end 

local LootSlot_OnLeave = function(self)
	if self.quality and self.quality > 1 then 
		local color = ITEM_QUALITY_COLORS[self.quality]
		self.drop:SetVertexColor(color.r, color.g, color.b)
	else
		self.drop:Hide()
	end 
	GameTooltip:Hide()
	ResetCursor()
end 

local LootSlot_OnClick = function(self)
	LootFrame.selectedQuality = self.quality;
	LootFrame.selectedItemName = self.name:GetText()
	LootFrame.selectedSlot = self:GetID()
	LootFrame.selectedLootButton = self:GetName()
	LootFrame.selectedTexture = self.icon:GetTexture()
	if IsModifiedClick() then
		HandleModifiedItemClick(GetLootSlotLink(self:GetID()))
	else
		StaticPopup_Hide("CONFIRM_LOOT_DISTRIBUTION")
		lastID = self:GetID()
		lastQuality = self.quality;
		lastName = self.name:GetText()
		LootSlot(lastID)
	end 
end 

local LootSlot_OnShow = function(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(self:GetID())
		CursorOnUpdate(self)
	end 
end 

local function HandleSlots(frame)
	local scale = 30;
	local counter = 0;
	for i = 1, #frame.slots do 
		local slot = frame.slots[i]
		if slot:IsShown() then
			counter = counter + 1;
			slot:SetPointToScale("TOP", SVUI_LootFrame, 4, (-8 + scale) - (counter * scale))
		end 
	end 
	frame:SetHeightToScale(max(counter * scale + 16, 20))
end 

local function MakeSlots(id)
	local size = LOOT_HEIGHT;
	local slot = CreateFrame("Button", "SVUI_LootSlot"..id, SVUI_LootFrame)
	slot:SetPointToScale("LEFT", 8, 0)
	slot:SetPointToScale("RIGHT", -8, 0)
	slot:SetHeightToScale(size)
	slot:SetID(id)
	slot:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	slot:SetScript("OnEnter", LootSlot_OnEnter)
	slot:SetScript("OnLeave", LootSlot_OnLeave)
	slot:SetScript("OnClick", LootSlot_OnClick)
	slot:SetScript("OnShow", LootSlot_OnShow)

	slot.iconFrame = CreateFrame("Frame", nil, slot)
	slot.iconFrame:SetHeightToScale(size)
	slot.iconFrame:SetWidthToScale(size)
	slot.iconFrame:SetPoint("RIGHT", slot)
	slot.iconFrame:SetStylePanel("Default", "Transparent")

	slot.icon = slot.iconFrame:CreateTexture(nil, "ARTWORK")
	slot.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	slot.icon:SetAllPointsIn()

	slot.count = slot.iconFrame:CreateFontString(nil, "OVERLAY")
	slot.count:SetJustifyH("RIGHT")
	slot.count:SetPointToScale("BOTTOMRIGHT", slot.iconFrame, -2, 2)
	slot.count:FontManager("lootnumber")
	slot.count:SetText(1)

	slot.name = slot:CreateFontString(nil, "OVERLAY")
	slot.name:SetJustifyH("LEFT")
	slot.name:SetPoint("LEFT", slot)
	slot.name:SetPoint("RIGHT", slot.icon, "LEFT")
	slot.name:SetNonSpaceWrap(true)
	slot.name:FontManager("lootdialog")

	slot.drop = slot:CreateTexture(nil, "ARTWORK")
	slot.drop:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
	slot.drop:SetPoint("LEFT", slot.icon, "RIGHT", 0, 0)
	slot.drop:SetPoint("RIGHT", slot)
	slot.drop:SetAllPoints(slot)
	slot.drop:SetAlpha(.3)

	slot.questTexture = slot.iconFrame:CreateTexture(nil, "OVERLAY")
	slot.questTexture:SetAllPointsIn()
	slot.questTexture:SetTexture(TEXTURE_ITEM_QUEST_BANG)
	slot.questTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	SVUI_LootFrame.slots[id] = slot;
	return slot 
end 

local function CreateRollButton(rollFrame, type, locale, anchor)
	local preset = RollTypePresets[type];
	local rollButton = CreateFrame("Button", nil, rollFrame)
	rollButton:SetPointToScale("LEFT", anchor, "RIGHT", tonumber(preset[4]), tonumber(preset[5]))
	rollButton:SetSizeToScale(LOOT_HEIGHT - 4)
	rollButton:SetNormalTexture(preset[1])
	if preset[2] and preset[2] ~= "" then
		rollButton:SetPushedTexture(preset[2])
	end 
	rollButton:SetHighlightTexture(preset[3])
	rollButton.rolltype = type;
	rollButton.parent = rollFrame;
	rollButton.tiptext = locale;
	rollButton:SetScript("OnEnter", LootRoll_SetTooltip)
	rollButton:SetScript("OnLeave", LootRoll_OnLeave)
	rollButton:SetScript("OnClick", DoDaRoll)
	rollButton:SetMotionScriptsWhileDisabled(true)
	local text = rollButton:CreateFontString(nil, nil)
	text:FontManager("rolldialog")
	text:SetPointToScale("CENTER", 0, ((type == 2 and 1) or (type == 0 and -1.2) or 0))
	return rollButton, text 
end 

local function CreateRollFrame()
	UpdateLootUpvalues()
	local rollFrame = CreateFrame("Frame", nil, UIParent)
	rollFrame:SetSizeToScale(LOOT_WIDTH,LOOT_HEIGHT)
	rollFrame:SetStylePanel("Fixed", 'Default')
	rollFrame:SetScript("OnEvent",LootRoll_OnEvent)
	rollFrame:RegisterEvent("CANCEL_LOOT_ROLL")
	rollFrame:Hide()
	rollFrame.button = CreateFrame("Button",nil,rollFrame)
	rollFrame.button:SetPointToScale("RIGHT",rollFrame,'LEFT',0,0)
	rollFrame.button:SetSizeToScale(LOOT_HEIGHT - 2)
	rollFrame.button:SetStylePanel("Default", 'Default')
	rollFrame.button:SetScript("OnEnter",LootItem_SetTooltip)
	rollFrame.button:SetScript("OnLeave",LootItem_OnLeave)
	rollFrame.button:SetScript("OnUpdate",LootItem_OnUpdate)
	rollFrame.button:SetScript("OnClick",LootRoll_OnClick)
	rollFrame.button.icon = rollFrame.button:CreateTexture(nil,'OVERLAY')
	rollFrame.button.icon:SetAllPoints()
	rollFrame.button.icon:SetTexCoord(0.1,0.9,0.1,0.9 )
	local border = rollFrame:CreateTexture(nil,"BORDER")
	border:SetPointToScale("TOPLEFT",rollFrame,"TOPLEFT",4,0)
	border:SetPointToScale("BOTTOMRIGHT",rollFrame,"BOTTOMRIGHT",-4,0)
	border:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	border:SetBlendMode("ADD")
	border:SetGradientAlpha("VERTICAL",.1,.1,.1,0,.1,.1,.1,0)
	rollFrame.status=CreateFrame("StatusBar",nil,rollFrame)
	rollFrame.status:SetAllPointsIn()
	rollFrame.status:SetScript("OnUpdate",LootRoll_OnUpdate)
	rollFrame.status:SetFrameLevel(rollFrame.status:GetFrameLevel() - 1)
	rollFrame.status:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	rollFrame.status:SetStatusBarColor(.8,.8,.8,.9)
	rollFrame.status.parent = rollFrame;
	rollFrame.status.bg = rollFrame.status:CreateTexture(nil,'BACKGROUND')
	rollFrame.status.bg:SetAlpha(0.1)
	rollFrame.status.bg:SetAllPoints()
	rollFrame.status.bg:SetDrawLayer('BACKGROUND',2)
	rollFrame.status.spark = rollFrame:CreateTexture(nil,"OVERLAY")
	rollFrame.status.spark:SetSizeToScale(LOOT_HEIGHT * 0.5, LOOT_HEIGHT)
	rollFrame.status.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	rollFrame.status.spark:SetBlendMode("ADD")

	local needButton,needText = CreateRollButton(rollFrame,1,NEED,rollFrame.button)
	local greedButton,greedText = CreateRollButton(rollFrame,2,GREED,needButton,"RIGHT")
	local deButton,deText = CreateRollButton(rollFrame,3,ROLL_DISENCHANT,greedButton)
	local passButton,passText = CreateRollButton(rollFrame,0,PASS,deButton or greedButton)
	rollFrame.NeedIt,rollFrame.WantIt,rollFrame.BreakIt = needButton,greedButton,deButton;
	rollFrame.need,rollFrame.greed,rollFrame.pass,rollFrame.disenchant = needText,greedText,passText,deText;
	rollFrame.bindText = rollFrame:CreateFontString()
	rollFrame.bindText:SetPointToScale("LEFT",passButton,"RIGHT",3,1)
	rollFrame.bindText:FontManager("rollnumber")
	rollFrame.lootText = rollFrame:CreateFontString(nil,"ARTWORK")
	rollFrame.lootText:FontManager("rollnumber")
	rollFrame.lootText:SetPointToScale("LEFT",rollFrame.bindText,"RIGHT",0,0)
	rollFrame.lootText:SetPointToScale("RIGHT",rollFrame,"RIGHT",-5,0)
	rollFrame.lootText:SetSizeToScale(200,10)
	rollFrame.lootText:SetJustifyH("LEFT")

	rollFrame.yourRoll = rollFrame:CreateFontString(nil,"ARTWORK")
	rollFrame.yourRoll:FontManager("rollnumber", "CENTER", 4)
	rollFrame.yourRoll:SetSizeToScale(22,22)
	rollFrame.yourRoll:SetPointToScale("LEFT",rollFrame,"RIGHT",5,0)
	rollFrame.yourRoll:SetJustifyH("CENTER")

	rollFrame.rolls = {}
	return rollFrame 
end

local function FetchRollFrame()
	for _,roll in ipairs(MOD.RollFrames)do 
		if not roll.rollID then
			return roll 
		end 
	end 
	local roll = CreateRollFrame()
	roll:SetPointToScale("TOP", next(MOD.RollFrames) and MOD.RollFrames[#MOD.RollFrames] or SVUI_AlertFrame, "BOTTOM", 0, -4);
	tinsert(MOD.RollFrames, roll)
	return roll 
end  
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
local AutoConfirmLoot = function(_, event, arg1, arg2, ...)
	if event == "CONFIRM_LOOT_ROLL" or event == "CONFIRM_DISENCHANT_ROLL" then
		ConfirmLootRoll(arg1, arg2)
		StaticPopup_Hide("CONFIRM_LOOT_ROLL")
		return
	elseif event == "LOOT_BIND_CONFIRM" then
		ConfirmLootSlot(arg1, arg2)
		StaticPopup_Hide("LOOT_BIND",...)
		return
	end
end

local LootSimpleEventsHandler = function(_, event, slot)
	if(event == 'LOOT_SLOT_CLEARED') then
		if not SVUI_LootFrame:IsShown() then return; end
		SVUI_LootFrame.slots[slot]:Hide()
		HandleSlots(SVUI_LootFrame)
	elseif(event == 'LOOT_CLOSED') then
		StaticPopup_Hide("LOOT_BIND")
		SVUI_LootFrame:Hide()
		for _,slot in pairs(SVUI_LootFrame.slots)do
			slot:Hide()
		end
	elseif(event == 'OPEN_MASTER_LOOT_LIST') then
		ToggleDropDownMenu(1, nil, GroupLootDropDown, SVUI_LootFrame.slots[lastID], 0, 0)
	elseif(event == 'UPDATE_MASTER_LOOT_LIST') then
		MasterLooterFrame_UpdatePlayers()
	end
end

local OpenedLootHandler = function(_, event, autoLoot)
	local drops = GetNumLootItems()
	if drops > 0 then
		SVUI_LootFrame:Show()
	else
		CloseLoot(autoLoot == 0)
	end

	if IsFishingLoot() then
		SVUI_LootFrame.title:SetText(L["Fishy Loot"])
	elseif not UnitIsFriend("player", "target") and UnitIsDead"target" then 
		SVUI_LootFrame.title:SetText(UnitName("target"))
	else
		SVUI_LootFrame.title:SetText(LOOT)
	end 

	if GetCVar("lootUnderMouse") == "1" then 
		local cursorX,cursorY = GetCursorPosition()
		cursorX = cursorX / SVUI_LootFrame:GetEffectiveScale()
		cursorY = (cursorY  /  (SVUI_LootFrame:GetEffectiveScale()));
		SVUI_LootFrame:ClearAllPoints()
		SVUI_LootFrame:SetPoint("TOPLEFT", nil, "BOTTOMLEFT", cursorX - 40, cursorY + 20)
		SVUI_LootFrame:GetCenter()
	else
		SVUI_LootFrame:ClearAllPoints()
		SVUI_LootFrame:SetPoint("TOPLEFT", SVUI_LootFrameHolder, "TOPLEFT")
	end

	SVUI_LootFrame:Raise()

	local iQuality, nameWidth, titleWidth = 0, 0, SVUI_LootFrame.title:GetStringWidth()
	UpdateLootUpvalues()
	if drops > 0 then
		for i = 1, drops do 
			local slot = SVUI_LootFrame.slots[i] or MakeSlots(i)
			local texture, item, quantity, quality, locked, isQuestItem, questId, isActive = GetLootSlotInfo(i)
			local color = ITEM_QUALITY_COLORS[quality]
			if texture and texture:find("INV_Misc_Coin") then
				item = item:gsub("\n", ", ")
			end 
			if quantity and quantity > 1 then
				slot.count:SetText(quantity)
				slot.count:Show()
			else
				slot.count:Hide()
			end 
			if quality and quality > 1 then
				slot.drop:SetVertexColor(color.r, color.g, color.b)
				slot.drop:Show()
			else
				slot.drop:Hide()
			end 
			slot.quality = quality;
			slot.name:SetText(item)
			if color then
				slot.name:SetTextColor(color.r, color.g, color.b)
			end 
			slot.icon:SetTexture(texture)
			if quality then
				iQuality = max(iQuality, quality)
			end 
			nameWidth = max(nameWidth, slot.name:GetStringWidth())
			local qTex = slot.questTexture;
			if questId and not isActive then
				qTex:Show()
				ActionButton_ShowOverlayGlow(slot.iconFrame)
			elseif questId or isQuestItem then 
				qTex:Hide()
				ActionButton_ShowOverlayGlow(slot.iconFrame)
			else
				qTex:Hide()
				ActionButton_HideOverlayGlow(slot.iconFrame)
			end 
			slot:Enable()
			slot:Show()
			ConfirmLootSlot(i)
		end 
	else
		local slot = SVUI_LootFrame.slots[1] or MakeSlots(1)
		local color = ITEM_QUALITY_COLORS[0]
		slot.name:SetText(L["Empty Slot"])
		if color then
			slot.name:SetTextColor(color.r, color.g, color.b)
		end 
		slot.icon:SetTexture[[Interface\Icons\INV_Misc_Herb_AncientLichen]]
		drops = 1;
		nameWidth = max(nameWidth, slot.name:GetStringWidth())
		slot.count:Hide()
		slot.drop:Hide()
		slot:Disable()
		slot:Show()
	end 

	HandleSlots(SVUI_LootFrame)
	nameWidth = nameWidth + 60;
	titleWidth = titleWidth + 5;
	local color = ITEM_QUALITY_COLORS[iQuality]
	SVUI_LootFrame:SetBackdropBorderColor(color.r, color.g, color.b, .8)
	SVUI_LootFrame:SetWidthToScale(max(nameWidth, titleWidth))
end 

local LootComplexEventsHandler = function(_, event, arg1, arg2)
	if(event == "START_LOOT_ROLL") then
		if dead_rollz[arg1] then return end 
		local texture,name,count,quality,bindOnPickUp,canNeed,canGreed,canBreak = GetLootRollItemInfo(arg1);
		local color = ITEM_QUALITY_COLORS[quality];
		local rollFrame = FetchRollFrame();
		rollFrame.rollID = arg1;
		rollFrame.time = arg2;
		for i in pairs(rollFrame.rolls)do 
			rollFrame.rolls[i] = nil 
		end 
		rollFrame.need:SetText(0)
		rollFrame.greed:SetText(0)
		rollFrame.pass:SetText(0)
		rollFrame.disenchant:SetText(0)
		rollFrame.button.icon:SetTexture(texture)
		rollFrame.button.link = GetLootRollItemLink(arg1)
		if canNeed then 
			rollFrame.NeedIt:Enable()
			rollFrame.NeedIt:SetAlpha(1)
		else
			rollFrame.NeedIt:SetAlpha(0.2)
			rollFrame.NeedIt:Disable()
		end 
		if canGreed then 
			rollFrame.WantIt:Enable()
			rollFrame.WantIt:SetAlpha(1)
		else
			rollFrame.WantIt:SetAlpha(0.2)
			rollFrame.WantIt:Disable()
		end 
		if canBreak then 
			rollFrame.BreakIt:Enable()
			rollFrame.BreakIt:SetAlpha(1)
		else
			rollFrame.BreakIt:SetAlpha(0.2)
			rollFrame.BreakIt:Disable()
		end 
		SetDesaturation(rollFrame.NeedIt:GetNormalTexture(),not canNeed)
		SetDesaturation(rollFrame.WantIt:GetNormalTexture(),not canGreed)
		SetDesaturation(rollFrame.BreakIt:GetNormalTexture(),not canBreak)
		rollFrame.bindText:SetText(bindOnPickUp and "BoP" or "BoE")
		rollFrame.bindText:SetVertexColor(bindOnPickUp and 1 or 0.3, bindOnPickUp and 0.3 or 1, bindOnPickUp and 0.1 or 0.3)
		rollFrame.lootText:SetText(name)
		rollFrame.yourRoll:SetText("")
		rollFrame.status:SetStatusBarColor(color.r,color.g,color.b,0.7)
		rollFrame.status.bg:SetTexture(color.r,color.g,color.b)
		rollFrame.status:SetMinMaxValues(0,arg2)
		rollFrame.status:SetValue(arg2)
		rollFrame:SetPoint("CENTER",WorldFrame,"CENTER")
		rollFrame:Show()
		AlertFrame_FixAnchors()
		if SV.db.SVHenchmen.autoRoll and UnitLevel('player') == MAX_PLAYER_LEVEL and quality == 2 and not bindOnPickUp then 
			if canBreak then 
				RollOnLoot(arg1,3)
			else 
				RollOnLoot(arg1,2)
			end 
		end
	elseif(event == "LOOT_HISTORY_ROLL_CHANGED") then
		local rollID,_,_,_,_,_ = C_LootHistory.GetItem(arg1);
		local name,_,rollType,rollResult,_ = C_LootHistory.GetPlayerInfo(arg1,arg2);
		if name and rollType then 
			for _,roll in ipairs(MOD.RollFrames)do 
				if roll.rollID == rollID then 
					roll.rolls[name] = rollType;
					roll[LootRollType[rollType]]:SetText(tonumber(roll[LootRollType[rollType]]:GetText()) + 1);
					return 
				end 
				if rollResult then
					roll.yourRoll:SetText(tostring(rollResult))
				end
			end
		end
	end
end 

_G.GroupLootDropDown_GiveLoot = function(self)
	if lastQuality >= MASTER_LOOT_THREHOLD then 
		local confirmed = SV:StaticPopup_Show("CONFIRM_LOOT_DISTRIBUTION",ITEM_QUALITY_COLORS[lastQuality].hex..lastName..FONT_COLOR_CODE_CLOSE,self:GetText());
		if confirmed then confirmed.data = self.value end 
	else 
		GiveMasterLoot(lastID, self.value)
	end 
	CloseDropDownMenus()
	SV.SystemAlert["CONFIRM_LOOT_DISTRIBUTION"].OnAccept = function(self,index) GiveMasterLoot(lastID,index) end 
end
--[[ 
########################################################## 
PACKAGE CALL
##########################################################
]]--
function MOD:SetLootFrames()
	if not SV.db.SVOverride.loot then return end
	UIPARENT_MANAGED_FRAME_POSITIONS["GroupLootContainer"] = nil;
	LootFrame:UnregisterAllEvents();

	SVUI_LootFrameHolder:SetSizeToScale(150, 22);
	SV.Mentalo:Add(SVUI_LootFrameHolder, L["Loot Frame"], nil, nil, "SVUI_LootFrame");
	
	SVUI_LootFrame:SetSizeToScale(256, 64);
	SVUI_LootFrame:SetStylePanel("Fixed", 'Transparent');
	SVUI_LootFrame.title:FontManager("header")
	SV:AddToDisplayAudit(SVUI_LootFrame);
	SVUI_LootFrame:Hide();

	UIParent:UnregisterEvent("LOOT_BIND_CONFIRM")
	UIParent:UnregisterEvent("CONFIRM_DISENCHANT_ROLL")
	UIParent:UnregisterEvent("CONFIRM_LOOT_ROLL")

	self:RegisterEvent("CONFIRM_DISENCHANT_ROLL", AutoConfirmLoot)
	self:RegisterEvent("CONFIRM_LOOT_ROLL", AutoConfirmLoot)
	self:RegisterEvent("LOOT_BIND_CONFIRM", AutoConfirmLoot)
	self:RegisterEvent("LOOT_READY", OpenedLootHandler)
	self:RegisterEvent("LOOT_SLOT_CLEARED", LootSimpleEventsHandler);
	self:RegisterEvent("LOOT_CLOSED", LootSimpleEventsHandler);
	self:RegisterEvent("OPEN_MASTER_LOOT_LIST", LootSimpleEventsHandler);
	self:RegisterEvent("UPDATE_MASTER_LOOT_LIST", LootSimpleEventsHandler);

	if SV.db.SVOverride.lootRoll then 
		self:RegisterEvent("LOOT_HISTORY_ROLL_CHANGED", LootComplexEventsHandler);
		self:RegisterEvent("START_LOOT_ROLL", LootComplexEventsHandler);
		UIParent:UnregisterEvent("START_LOOT_ROLL");
		UIParent:UnregisterEvent("CANCEL_LOOT_ROLL");
	end 
end