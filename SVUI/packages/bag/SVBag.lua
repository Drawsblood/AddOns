--[[
##############################################################################
_____/\\\\\\\\\\\____/\\\________/\\\__/\\\________/\\\__/\\\\\\\\\\\_    #
 ___/\\\/////////\\\_\/\\\_______\/\\\_\/\\\_______\/\\\_\/////\\\///__   #
 __\//\\\______\///__\//\\\______/\\\__\/\\\_______\/\\\_____\/\\\_____   #
  ___\////\\\__________\//\\\____/\\\___\/\\\_______\/\\\_____\/\\\_____  #
	______\////\\\________\//\\\__/\\\____\/\\\_______\/\\\_____\/\\\_____  #
	 _________\////\\\______\//\\\/\\\_____\/\\\_______\/\\\_____\/\\\_____ #
	 __/\\\______\//\\\______\//\\\\\______\//\\\______/\\\______\/\\\_____ #
	  _\///\\\\\\\\\\\/________\//\\\________\///\\\\\\\\\/____/\\\\\\\\\\\_#
		___\///////////___________\///___________\/////////_____\///////////_#
##############################################################################
S U P E R - V I L L A I N - U I  By: Munglunch               #
##############################################################################
credit: Elv.           original logic from ElvUI. Adapted to SVUI #
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
local ipairs 	= _G.ipairs;
local type 		= _G.type;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local find, format, len = string.find, string.format, string.len;
local sub, byte = string.sub, string.byte;
--[[ MATH METHODS ]]--
local floor, ceil, abs = math.floor, math.ceil, math.abs;
local twipe = table.wipe;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L
local MOD = SV:NewPackage("SVBag", L["Bags"]);
local TTIP = SV.SVTip;
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local CreateFrame = _G.CreateFrame;
local hooksecurefunc = _G.hooksecurefunc;
local BLANK_TEXTURE = [[Interface\BUTTONS\WHITE8X8]];
local BASIC_TEXTURE = [[Interface\AddOns\SVUI\assets\artwork\Bars\DEFAULT]];
local BORDER_TEXTURE = [[Interface\Addons\SVUI\assets\artwork\Template\ROUND]];
local ICON_BAGS = [[Interface\AddOns\SVUI\assets\artwork\Icons\BAGS-BAGS]];
local ICON_SORT = [[Interface\AddOns\SVUI\assets\artwork\Icons\BAGS-SORT]];
local ICON_STACK = [[Interface\AddOns\SVUI\assets\artwork\Icons\BAGS-STACK]];
local ICON_TRANSFER = [[Interface\AddOns\SVUI\assets\artwork\Icons\BAGS-TRANSFER]];
local ICON_PURCHASE = [[Interface\AddOns\SVUI\assets\artwork\Icons\BAGS-PURCHASE]];
local ICON_CLEANUP = [[Interface\AddOns\SVUI\assets\artwork\Icons\BAGS-CLEANUP]];
local ICON_DEPOSIT = [[Interface\AddOns\SVUI\assets\artwork\Icons\BAGS-DEPOSIT]];
local ICON_VENDOR = [[Interface\AddOns\SVUI\assets\artwork\Icons\BAGS-VENDOR]];
local ICON_REAGENTS = [[Interface\AddOns\SVUI\assets\artwork\Icons\BAGS-REAGENTS]];
local numBagFrame = NUM_BAG_FRAMES + 1;
local VendorQueue = {};
local GEAR_CACHE, GEARSET_LISTING = {}, {};
local internalTimer;
local RefProfessionColors = {
	[0x0008] = {224/255,187/255,74/255},
	[0x0010] = {74/255,77/255,224/255},
	[0x0020] = {18/255,181/255,32/255},
	[0x0040] = {160/255,3/255,168/255},
	[0x0080] = {232/255,118/255,46/255},
	[0x0200] = {8/255,180/255,207/255},
	[0x0400] = {105/255,79/255,7/255},
	[0x10000] = {222/255,13/255,65/255},
	[0x100000] = {18/255,224/255,180/255}
}
local BagFilters = CreateFrame("Frame", "SVUI_BagFilterMenu", UIParent);
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local goldFormat = "%s|TInterface\\MONEYFRAME\\UI-GoldIcon.blp:16:16|t"

local function FormatCurrency(amount)
	if not amount then return end 
	local gold = floor(abs(amount/10000))
	if gold ~= 0 then
		gold = BreakUpLargeNumbers(gold)
		return goldFormat:format(gold)
	end
end 

local function StyleBagToolButton(button, iconTex)
	if button.styled then return end 

	local outer = button:CreateTexture(nil, "OVERLAY")
	outer:SetAllPointsOut(button, 6, 6)
	outer:SetTexture(BORDER_TEXTURE)
	outer:SetGradient("VERTICAL", 0.4, 0.47, 0.5, 0.3, 0.33, 0.35)

	button:SetNormalTexture(iconTex)
	iconTex = button:GetNormalTexture()
	iconTex:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
	
	local icon = button:CreateTexture(nil, "OVERLAY")
	icon:SetAllPointsOut(button, 6, 6)
	SetPortraitToTexture(icon, iconTex)
	hooksecurefunc(icon, "SetTexture", SetPortraitToTexture)

	local hover = button:CreateTexture(nil, "HIGHLIGHT")
	hover:SetAllPointsOut(button, 6, 6)
	hover:SetTexture(BORDER_TEXTURE)
	hover:SetGradient(unpack(SV.Media.gradient.yellow))

	if button.SetPushedTexture then 
		local pushed = button:CreateTexture(nil, "BORDER")
		pushed:SetAllPointsOut(button, 6, 6)
		pushed:SetTexture(BORDER_TEXTURE)
		pushed:SetGradient(unpack(SV.Media.gradient.highlight))
		button:SetPushedTexture(pushed)
	end 

	if button.SetCheckedTexture then 
		local checked = button:CreateTexture(nil, "BORDER")
		checked:SetAllPointsOut(button, 6, 6)
		checked:SetTexture(BORDER_TEXTURE)
		checked:SetGradient(unpack(SV.Media.gradient.green))
		button:SetCheckedTexture(checked)
	end 

	if button.SetDisabledTexture then 
		local disabled = button:CreateTexture(nil, "BORDER")
		disabled:SetAllPointsOut(button, 6, 6)
		disabled:SetTexture(BORDER_TEXTURE)
		disabled:SetGradient(unpack(SV.Media.gradient.default))
		button:SetDisabledTexture(disabled)
	end 

	local cd = button:GetName() and _G[button:GetName().."Cooldown"]
	if cd then 
		cd:ClearAllPoints()
		cd:SetAllPointsIn()
	end 
	button.styled = true
end 

local function encodeSub(i, j, k)
	local l = j;
	while k>0 and l <= #i do
		local m = byte(i, l)
		if m>240 then
			l = l + 4;
		elseif m>225 then
			l = l + 3;
		elseif m>192 then
			l = l + 2;
		else
			l = l + 1;
		end 
		k = k-1;
	end 
	return i:sub(j, (l-1))
end 

local function SetGearLabel(level, font, saveTo)
	if level == 1 then
		font:SetFormattedText("|cffffffaa%s|r", encodeSub(saveTo[1], 1, 4))
	elseif level == 2 then
		font:SetFormattedText("|cffffffaa%s %s|r", encodeSub(saveTo[1], 1, 4), encodeSub(saveTo[2], 1, 4))
	elseif level == 3 then
		font:SetFormattedText("|cffffffaa%s %s %s|r", encodeSub(saveTo[1], 1, 4), encodeSub(saveTo[2], 1, 4), encodeSub(saveTo[3], 1, 4))
	else
		font:SetText()
	end
end 

local function BuildEquipmentMap()
	for key, gearData in pairs(GEARSET_LISTING) do
		twipe(gearData);
	end

	local set, player, bank, bags, slotIndex, bagIndex, loc, _;
	
	for i = 1, GetNumEquipmentSets() do
		set = GetEquipmentSetInfo(i);
		GEAR_CACHE = GetEquipmentSetLocations(set);
		if(GEAR_CACHE) then
			for key, location in pairs(GEAR_CACHE) do
				if(type(location) ~= "string") then
					player, bank, bags, _, slotIndex, bagIndex = EquipmentManager_UnpackLocation(location);
					if((bank or bags) and (slotIndex and bagIndex)) then
						loc = format("%d_%d", bagIndex, slotIndex);
						GEARSET_LISTING[loc] = (GEARSET_LISTING[loc] or {});
						tinsert(GEARSET_LISTING[loc], set);
					end
				end
			end
		end
	end
end

local DD_OnClick = function(self)
	SetBagSlotFlag(self.BagID, self.FilterID, not GetBagSlotFlag(self.BagID, self.FilterID))
	self:GetParent():Hide()
end

local DDClear_OnClick = function(self)
	for i = LE_BAG_FILTER_FLAG_EQUIPMENT, NUM_LE_BAG_FILTER_FLAGS do
		SetBagSlotFlag(self.BagID, i, false)
	end
	self:GetParent():Hide()
end

local DD_OnEnter = function(self)
	self.hoverTex:Show()
end

local DD_OnLeave = function(self)
	self.hoverTex:Hide()
end

local function SetFilterMenu(self)
	for i = LE_BAG_FILTER_FLAG_EQUIPMENT, NUM_LE_BAG_FILTER_FLAGS do
		if(GetBagSlotFlag(self.id, i)) then
			BagFilters.buttons[i].activeTex:Show()
		else
			BagFilters.buttons[i].activeTex:Hide()
		end
		BagFilters.buttons[i].BagID = self.id
	end

	BagFilters.buttons[NUM_LE_BAG_FILTER_FLAGS + 1].BagID = self.id

	local maxHeight = ((NUM_LE_BAG_FILTER_FLAGS) * 16) + 30
	local maxWidth = 135
	
	BagFilters:SetSize(maxWidth, maxHeight)    
	BagFilters:ClearAllPoints()
	BagFilters:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -8)
	ToggleFrame(BagFilters)
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:INVENTORY_SEARCH_UPDATE()
	for _, frame in pairs(self.BagFrames) do 
		for id, bag in ipairs(frame.Bags) do 
			for i = 1, GetContainerNumSlots(id) do 
				local _, _, _, _, _, _, _, isFiltered = GetContainerItemInfo(id, i)
				local item = bag[i]
				if(item and item:IsShown()) then 
					if isFiltered then 
						SetItemButtonDesaturated(item, 1)
						item:SetAlpha(0.4)
					else 
						SetItemButtonDesaturated(item)
						item:SetAlpha(1)
					end 
				end 
			end 
		end 
	end
	if(self.ReagentFrame) then
		for i = 1, self.ReagentFrame.numSlots do 
			local _, _, _, _, _, _, _, isFiltered = GetContainerItemInfo(REAGENTBANK_CONTAINER, i)
			local item = frame.Bags[REAGENTBANK_CONTAINER][i]
			if(item and item:IsShown()) then 
				if isFiltered then 
					SetItemButtonDesaturated(item, 1)
					item:SetAlpha(0.4)
				else 
					SetItemButtonDesaturated(item)
					item:SetAlpha(1)
				end 
			end 
		end
	end
end 

local SlotUpdate = function(self, slotID)
	if(not self[slotID]) then return end
	local bag = self:GetID();
	local slot = self[slotID];
	local bagType = self.bagFamily;

	slot:Show()

	local texture, count, locked = GetContainerItemInfo(bag, slotID);
	local start, duration, enable = GetContainerItemCooldown(bag, slotID);
	local isQuestItem, questId, isActiveQuest = GetContainerItemQuestInfo(bag, slotID);

	local itemID = GetContainerItemID(bag, slotID);
	if(itemID and VendorQueue[itemID]) then
		slot.JunkIcon:Show()
	else
		slot.JunkIcon:Hide()
	end

	local r,g,b = 0,0,0
	slot.HasQuestItem = nil
	if(questId and (not isActiveQuest)) then
		r,g,b = 1,0.3,0.3
		slot.questIcon:Show();
		slot.HasQuestItem = true;
	elseif(questId or isQuestItem) then
		r,g,b = 1,0.3,0.3
		slot.questIcon:Hide();
		slot.HasQuestItem = true;
	elseif(bagType) then
		r,g,b = bagType[1],bagType[2],bagType[3]
		slot.questIcon:Hide();
	else
		slot.questIcon:Hide();
		local itemLink = GetContainerItemLink(bag, slotID);
		if(itemLink) then
			local rarity = select(3, GetItemInfo(itemLink));
			if(rarity) then
				if(rarity > 1) then 
					r,g,b = GetItemQualityColor(rarity)
				elseif(rarity == 0) then
					slot.JunkIcon:Show()
				end
			end
		else
			if(GameTooltip:NumLines() ~= 0) then
				GameTooltip:Hide()
			end
		end
	end

	slot:SetBackdropColor(r,g,b,0.6)
	slot:SetBackdropBorderColor(r,g,b,1)

	CooldownFrame_SetTimer(slot.cooldown, start, duration, enable);

	if(duration > 0 and enable == 0) then 
		SetItemButtonTextureVertexColor(slot, 0.4, 0.4, 0.4)
	else 
		SetItemButtonTextureVertexColor(slot, 1, 1, 1)
	end

	if(C_NewItems.IsNewItem(bag, slotID)) then
		C_NewItems.RemoveNewItem(bag, slotID)
	end
	
	if(slot.NewItemTexture) then slot.NewItemTexture:Hide() end;
	if(slot.flashAnim) then slot.flashAnim:Stop() end;
    if(slot.newitemglowAnim) then slot.newitemglowAnim:Stop() end;

	SetItemButtonTexture(slot, texture)
	SetItemButtonCount(slot, count)
	SetItemButtonDesaturated(slot, locked, 0.5, 0.5, 0.5)

	if(slot.GearInfo) then
		local loc = format("%d_%d", bag, slotID)
		if(GEARSET_LISTING[loc]) then
			local level = #GEARSET_LISTING[loc] < 4 and #GEARSET_LISTING[loc] or 3;
			SetGearLabel(level, slot.GearInfo, GEARSET_LISTING[loc])
		else
			SetGearLabel(0, slot.GearInfo, nil)
		end
	end
end 

local RefreshSlots = function(self)
	local bagID = self:GetID()
	if(not bagID) then return end
	local maxcount = GetContainerNumSlots(bagID)
	for slotID = 1, maxcount do
		self:SlotUpdate(slotID) 
	end 
end

local RefreshReagentSlots = function(self)
	local bagID = self:GetID()
	if(not bagID or (not self.SlotUpdate)) then return end
	local maxcount = self.numSlots
	for slotID = 1, maxcount do 
		self:SlotUpdate(slotID) 
	end 
end

local BagMenu_OnEnter = function(self)
	local parent = self.parent
	if(not parent) then return end
	for bagID, bag in pairs(parent.Bags) do
		local numSlots = GetContainerNumSlots(bagID)
		for slotID = 1, numSlots do 
			if bag[slotID] then 
				if bagID == self.id then 
					bag[slotID]:SetAlpha(1)
				else 
					bag[slotID]:SetAlpha(0.1)
				end 
			end 
		end 
	end

	GameTooltip:AppendText(" |cff00FF11[SHIFT-CLICK] To Set Filters|r")
end 

local BagMenu_OnLeave = function(self)
	local parent = self.parent
	if(not parent) then return end
	for bagID, bag in pairs(parent.Bags) do 
		local numSlots = GetContainerNumSlots(bagID)
		for slotID = 1, numSlots do 
			if bag[slotID] then 
				bag[slotID]:SetAlpha(1)
			end 
		end 
	end
end

local BAG_FILTER_LABELS = _G.BAG_FILTER_LABELS;

local BagMenu_OnClick = function(self)
	if IsShiftKeyDown() then
		SetFilterMenu(self);
	elseif(BagFilters:IsShown()) then
		ToggleFrame(BagFilters)
	end
end

local ContainerFrame_UpdateCooldowns = function(self)
	if self.isReagent then return end
	for bagID, bag in pairs(self.Bags) do 
		for slotID = 1, GetContainerNumSlots(bagID)do 
			local start, duration, enable = GetContainerItemCooldown(bagID, slotID)
			if(bag[slotID]) then
				CooldownFrame_SetTimer(bag[slotID].cooldown, start, duration, enable)
				if duration > 0 and enable == 0 then 
					SetItemButtonTextureVertexColor(bag[slotID], 0.4, 0.4, 0.4)
				else 
					SetItemButtonTextureVertexColor(bag[slotID], 1, 1, 1)
				end
			end
		end 
	end 
end

local ContainerFrame_UpdateBags = function(self)
	for bagID, bag in pairs(self.Bags) do
		bag:RefreshSlots() 
	end
end

local ContainerFrame_UpdateLayout = function(self)
	if SV.db.SVBag.enable ~= true then return; end

	local isBank = self.isBank
	local containerName = self:GetName()
	local buttonSpacing = 8;
	local containerWidth, numContainerColumns, buttonSize

	local precount = 0;
	for i, bagID in ipairs(self.BagIDs) do
		local numSlots = GetContainerNumSlots(bagID);
		precount = precount + (numSlots or 0);
	end

	if(SV.db.SVBag.alignToChat) then
		containerWidth = (isBank and SV.db.Dock.dockLeftWidth or SV.db.Dock.dockRightWidth)
		local avg = 0.08;
		if(precount > 287) then
			avg = 0.12
		elseif(precount > 167) then
			avg = 0.11
		elseif(precount > 127) then
			avg = 0.1
		elseif(precount > 97) then
			avg = 0.09
		end

		numContainerColumns = avg * 100;

		local unitSize = floor(containerWidth / numContainerColumns)
		buttonSize = unitSize - buttonSpacing;
	else
		containerWidth = (isBank and SV.db.SVBag.bankWidth) or SV.db.SVBag.bagWidth
		buttonSize = isBank and SV.db.SVBag.bankSize or SV.db.SVBag.bagSize;
		numContainerColumns = floor(containerWidth / (buttonSize + buttonSpacing));
	end

	local numContainerRows = ceil(precount / numContainerColumns)
	local containerHeight = (((buttonSize + buttonSpacing) * numContainerRows) - buttonSpacing) + self.topOffset + self.bottomOffset
	local holderWidth = ((buttonSize + buttonSpacing) * numContainerColumns) - buttonSpacing;
	local bottomPadding = (containerWidth - holderWidth) * 0.5;
	local lastButton, lastRowButton, globalName;
	local numContainerSlots, fullContainerSlots = GetNumBankSlots();
	local totalSlots = 0;

	self.ButtonSize = buttonSize;
	self.holderFrame:SetWidthToScale(holderWidth);

	local menu = self.BagMenu

	for i, bagID in ipairs(self.BagIDs) do 
		if((not isBank and bagID <= 3) or (isBank and (bagID ~= -1 and numContainerSlots >= 1))) then
			menu:SetSizeToScale(((buttonSize + buttonSpacing) * (isBank and i - 1 or i)) + buttonSpacing, buttonSize + (buttonSpacing * 2))
			
			local bagSlot, globalName, bagTemplate;

			if isBank then
				globalName = ("SVUI_BankBag%d"):format(bagID - 4);
				bagTemplate = "BankItemButtonBagTemplate"
			else 
				globalName = ("SVUI_MainBag%dSlot"):format(bagID);
				bagTemplate = "BagSlotButtonTemplate"
			end

			if(not menu[i]) then
				bagSlot = CreateFrame("CheckButton", globalName, menu, bagTemplate)
				bagSlot.parent = self;

				bagSlot:SetNormalTexture("")
				bagSlot:SetCheckedTexture("")
				bagSlot:SetPushedTexture("")
				bagSlot:SetScript("OnClick", nil)
				bagSlot:RemoveTextures()
				bagSlot:SetStylePanel("Slot", true, 2, 0, 0, 0.5);

				if(not bagSlot.icon) then
					bagSlot.icon = bagSlot:CreateTexture(nil, "BORDER");
				end
				bagSlot.icon:SetAllPointsIn()
				bagSlot.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

				hooksecurefunc(bagSlot, "UpdateTooltip", BagMenu_OnEnter)
				bagSlot:HookScript("OnLeave", BagMenu_OnLeave)

				if(not bagSlot.tooltipText) then
					bagSlot.tooltipText = ""
				end

				if(isBank) then
					bagSlot:SetID(bagID - 4)
					bagSlot.id = bagID;
				else
					bagSlot:HookScript("OnClick", BagMenu_OnClick)
					bagSlot.id = (bagID + 1);
				end

				menu[i] = bagSlot;
			else
				bagSlot = menu[i]
			end

			bagSlot:SetSizeToScale(buttonSize) 
			bagSlot:ClearAllPoints()

			if(isBank) then
				if(i == 2) then 
					bagSlot:SetPoint("BOTTOMLEFT", menu, "BOTTOMLEFT", buttonSpacing, buttonSpacing)
				else 
					bagSlot:SetPoint("LEFT", menu[i - 1], "RIGHT", buttonSpacing, 0)
				end

				if(bagSlot.GetInventorySlot) then
					BankFrameItemButton_Update(bagSlot)
					BankFrameItemButton_UpdateLocked(bagSlot)
				end
			else
				if(i == 1) then 
					bagSlot:SetPoint("BOTTOMLEFT", menu, "BOTTOMLEFT", buttonSpacing, buttonSpacing)
				else 
					bagSlot:SetPoint("LEFT", menu[i - 1], "RIGHT", buttonSpacing, 0)
				end
			end
		end

		local numSlots = GetContainerNumSlots(bagID);

		local bagName = ("%sBag%d"):format(containerName, bagID)
		local template = (bagID == -1) and "BankItemButtonGenericTemplate" or "ContainerFrameItemButtonTemplate"
		local bag;

		if numSlots > 0 then
			if not self.Bags[bagID] then
				bag = CreateFrame("Frame", bagName, self); 
				bag:SetID(bagID);
				bag.SlotUpdate = SlotUpdate;
				bag.RefreshSlots = RefreshSlots;
				self.Bags[bagID] = bag
			else
				bag = self.Bags[bagID]
			end

			bag.numSlots = numSlots;
			bag.bagFamily = false;

			local btype = select(2, GetContainerNumFreeSlots(bagID));
			if RefProfessionColors[btype] then
				local r, g, b = unpack(RefProfessionColors[btype]);
				bag.bagFamily = {r, g, b};
			end

			for i = 1, MAX_CONTAINER_ITEMS do 
				if bag[i] then 
					bag[i]:Hide();
				end 
			end

			for slotID = 1, numSlots do
				local slot;
				totalSlots = totalSlots + 1;

				if not bag[slotID] then
					local slotName = ("%sSlot%d"):format(bagName, slotID)
					local iconName = ("%sIconTexture"):format(slotName)
					local cdName = ("%sCooldown"):format(slotName)
					local questIcon = ("%sIconQuestTexture"):format(slotName)

					slot = CreateFrame("CheckButton", slotName, bag, template);
					slot:SetNormalTexture("");
					slot:SetCheckedTexture("");
					slot:RemoveTextures()
					slot:SetStylePanel("Slot", true, 2, 0, 0, 0.45);
					slot.Panel.Shadow:SetAttribute("shadowAlpha", 0.9)
					
					if(not slot.NewItemTexture) then
						slot.NewItemTexture = slot:CreateTexture(nil, "OVERLAY", 1);
					end
					slot.NewItemTexture:SetAllPointsIn(slot);
					slot.NewItemTexture:SetTexture(0,0,0,0);
					slot.NewItemTexture:Hide()

					if(not slot.JunkIcon) then 
						slot.JunkIcon = slot:CreateTexture(nil, "OVERLAY");
						slot.JunkIcon:SetSizeToScale(16,16);
					end
					slot.JunkIcon:SetTexture([[Interface\BUTTONS\UI-GroupLoot-Coin-Up]]);
					slot.JunkIcon:SetPointToScale("TOPLEFT", slot, "TOPLEFT", -4, 4);

					if(not slot.icon) then
						slot.icon = slot:CreateTexture(nil, "BORDER");
					end
					slot.icon:SetAllPointsIn(slot);
					slot.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9);

					slot.questIcon = _G[questIcon] or slot:CreateTexture(nil, "OVERLAY")
					slot.questIcon:SetTexture(TEXTURE_ITEM_QUEST_BANG);
					slot.questIcon:SetAllPointsIn(slot);
					slot.questIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9);
					
					hooksecurefunc(slot, "SetBackdropColor", function(self, r, g, b, a) if(self.HasQuestItem and (r ~= 1)) then self:SetBackdropColor(1,0.3,0.3,a) end end)
					hooksecurefunc(slot, "SetBackdropBorderColor", function(self, r, g, b, a) if(self.HasQuestItem and (r ~= 1)) then self:SetBackdropBorderColor(1,0.3,0.3,a) end end)

					slot.cooldown = _G[cdName];

					bag[slotID] = slot
				else
					slot = bag[slotID]
				end

				if(SV.db.SVGear.misc.setoverlay and (not slot.GearInfo)) then 
					slot.GearInfo = slot:CreateFontString(nil,"OVERLAY")
					slot.GearInfo:FontManager("default")
					slot.GearInfo:SetAllPoints(slot)
					slot.GearInfo:SetWordWrap(true)
					slot.GearInfo:SetJustifyH('LEFT')
					slot.GearInfo:SetJustifyV('BOTTOM')
				end

				slot:SetID(slotID);
				slot:SetSizeToScale(buttonSize);

				if slot:GetPoint() then 
					slot:ClearAllPoints();
				end

				if lastButton then 
					if((totalSlots - 1) % numContainerColumns == 0) then 
						slot:SetPointToScale("TOP", lastRowButton, "BOTTOM", 0, -buttonSpacing);
						lastRowButton = slot;
					else 
						slot:SetPointToScale("LEFT", lastButton, "RIGHT", buttonSpacing, 0);
					end 
				else 
					slot:SetPointToScale("TOPLEFT", self.holderFrame, "TOPLEFT");
					lastRowButton = slot;
				end

				lastButton = slot;

				bag:SlotUpdate(slotID);
			end
		else
			if(menu[i] and menu[i].GetInventorySlot) then 
				BankFrameItemButton_Update(menu[i])
				BankFrameItemButton_UpdateLocked(menu[i])
			end
			if(self.Bags[bagID]) then
				self.Bags[bagID].numSlots = numSlots;
				
				for i = 1, MAX_CONTAINER_ITEMS do 
					if(self.Bags[bagID][i]) then 
						self.Bags[bagID][i]:Hide();
					end 
				end
			end 
		end
	end
	
	self:SetSizeToScale(containerWidth, containerHeight);
end 

local ReagentFrame_UpdateLayout = function(self)
	if SV.db.SVBag.enable ~= true or not _G.ReagentBankFrame then return; end

	local ReagentBankFrame = _G.ReagentBankFrame;

	local containerName = self:GetName()
	local buttonSpacing = 8;
	local preColumns = ReagentBankFrame.numColumn or 7
	local preSubColumns = ReagentBankFrame.numSubColumn or 2
	local numContainerColumns = preColumns * preSubColumns
	local numContainerRows = ReagentBankFrame.numRow or 7
	local buttonSize = SVUI_BankContainerFrame.ButtonSize
	local containerWidth = (buttonSize + buttonSpacing) * numContainerColumns + buttonSpacing
	local containerHeight = (((buttonSize + buttonSpacing) * numContainerRows) - buttonSpacing) + self.topOffset + self.bottomOffset
	local maxCount = numContainerColumns * numContainerRows
	local holderWidth = ((buttonSize + buttonSpacing) * numContainerColumns) - buttonSpacing;
	local lastButton, lastRowButton;
	local bagID = REAGENTBANK_CONTAINER;
	local totalSlots = 0;

	self.holderFrame:SetWidthToScale(holderWidth);
	self.BagID = bagID

	local bag;
	local bagName = ("%sBag%d"):format(containerName, bagID)

	if not self.Bags[bagID] then
		bag = CreateFrame("Frame", bagName, self); 
		bag:SetID(bagID);
		bag.SlotUpdate = SlotUpdate;
		bag.RefreshSlots = RefreshReagentSlots;
		self.Bags[bagID] = bag
	else
		bag = self.Bags[bagID]
	end

	self.numSlots = maxCount;
	bag.numSlots = maxCount;
	bag.bagFamily = false;

	for slotID = 1, maxCount do
		local slot;
		totalSlots = totalSlots + 1;

		if not bag[slotID] then
			local slotName = ("%sSlot%d"):format(bagName, slotID)
			local iconName = ("%sIconTexture"):format(slotName)
			local questIcon = ("%sIconQuestTexture"):format(slotName)
			local cdName = ("%sCooldown"):format(slotName)

			slot = CreateFrame("CheckButton", slotName, bag, "ReagentBankItemButtonGenericTemplate");
			slot:SetNormalTexture(nil);
			slot:SetCheckedTexture(nil);
			slot:RemoveTextures()
			slot:SetStylePanel("Slot", true, 2, 0, 0, 0.5);

			slot.NewItemTexture = slot:CreateTexture(nil, "OVERLAY", 1);
			slot.NewItemTexture:SetAllPointsIn(slot);
			slot.NewItemTexture:SetTexture(0,0,0,0);
			slot.NewItemTexture:Hide()

			slot.JunkIcon = slot:CreateTexture(nil, "OVERLAY");
			slot.JunkIcon:SetSizeToScale(16,16);
			slot.JunkIcon:SetTexture(0,0,0,0);
			slot.JunkIcon:SetPointToScale("TOPLEFT", slot, "TOPLEFT", -4, 4);

			slot.icon = _G[iconName] or slot:CreateTexture(nil, "BORDER");
			slot.icon:SetAllPointsIn(slot);
			slot.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9);

			slot.questIcon = _G[questIcon] or slot:CreateTexture(nil, "OVERLAY")
			slot.questIcon:SetTexture(TEXTURE_ITEM_QUEST_BANG);
			slot.questIcon:SetAllPointsIn(slot);
			slot.questIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9);

			slot.cooldown = _G[cdName];

			bag[slotID] = slot
		else
			slot = bag[slotID]
		end

		slot:SetID(slotID);
		slot:SetSizeToScale(buttonSize);

		if slot:GetPoint() then 
			slot:ClearAllPoints();
		end

		if lastButton then 
			if((totalSlots - 1) % numContainerColumns == 0) then 
				slot:SetPointToScale("TOP", lastRowButton, "BOTTOM", 0, -buttonSpacing);
				lastRowButton = slot;
			else 
				slot:SetPointToScale("LEFT", lastButton, "RIGHT", buttonSpacing, 0);
			end 
		else 
			slot:SetPointToScale("TOPLEFT", self.holderFrame, "TOPLEFT");
			lastRowButton = slot;
		end

		lastButton = slot;

		BankFrameItemButton_Update(slot);
		BankFrameItemButton_UpdateLocked(slot);

		bag:SlotUpdate(slotID);
	end

	self:SetSizeToScale(containerWidth, containerHeight);
end 

function MOD:RefreshBagFrames(frame)
	if(frame and self[frame]) then
		self[frame]:UpdateLayout()
		return
	else
		if(self.BagFrame) then 
			self.BagFrame:UpdateLayout()
		end 
		if self.BankFrame then 
			self.BankFrame:UpdateLayout()
		end
		if self.ReagentFrame then 
			self.ReagentFrame:UpdateLayout()
		end
	end
end 

function MOD:UpdateGoldText()
	self.BagFrame.goldText:SetText(GetCoinTextureString(GetMoney(), 12))
end 

function MOD:VendorGrays(destroy, silent, request)
	if((not MerchantFrame or not MerchantFrame:IsShown()) and (not destroy) and (not request)) then 
		SV:AddonMessage(L["You must be at a vendor."])
		return 
	end

	local totalValue = 0;
	local canDelete = 0;

	for bagID = 0, 4 do 
		for slot = 1, GetContainerNumSlots(bagID) do 
			local itemLink = GetContainerItemLink(bagID, slot)
			if(itemLink) then
				local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemLink)
				if(vendorPrice) then
					local itemCount = select(2, GetContainerItemInfo(bagID, slot))
					local sellPrice = vendorPrice * itemCount
					local itemID = GetContainerItemID(bagID, slot);
					if(destroy) then 
						if(find(itemLink, "ff9d9d9d")) then 
							if(not request) then 
								PickupContainerItem(bagID, slot)
								DeleteCursorItem()
							end 
							totalValue = totalValue + sellPrice;
							canDelete = canDelete + 1 
						elseif(itemID and VendorQueue[itemID]) then
							if(not request) then
								VendorQueue[itemID] = nil
								PickupContainerItem(bagID, slot)
								DeleteCursorItem()
							end 
							totalValue = totalValue + sellPrice;
							canDelete = canDelete + 1 
						end 
					elseif(sellPrice > 0) then
						if(quality == 0) then 
							if(not request) then 
								UseContainerItem(bagID, slot)
								PickupMerchantItem()
							end 
							totalValue = totalValue + sellPrice
						elseif(itemID and VendorQueue[itemID]) then
							if(not request) then
								VendorQueue[itemID] = nil
								UseContainerItem(bagID, slot)
								PickupMerchantItem()
							end 
							totalValue = totalValue + sellPrice
						end
					end
				end
			end 
		end 
	end

	if request then return totalValue end

	if(not silent) then
		if(totalValue > 0) then
			local prefix, strMsg
			local gold, silver, copper = floor(totalValue / 10000) or 0, floor(totalValue%10000 / 100) or 0, totalValue%100;

			if(not destroy) then
				strMsg = ("%s |cffffffff%s%s%s%s%s%s|r"):format(L["Vendored gray items for:"], gold, L["goldabbrev"], silver, L["silverabbrev"], copper, L["copperabbrev"])
				SV:AddonMessage(strMsg)
			else
				if(canDelete > 0) then
					prefix = ("|cffffffff%s%s%s%s%s%s|r"):format(gold, L["goldabbrev"], silver, L["silverabbrev"], copper, L["copperabbrev"])
					strMsg = (L["Deleted %d gray items. Total Worth: %s"]):format(canDelete, prefix)
					SV:AddonMessage(strMsg)
				else
					SV:AddonMessage(L["No gray items to delete."])
				end
			end
		else
			if(not destroy) then
				SV:AddonMessage(L["No gray items to sell."])
			else
				SV:AddonMessage(L["No gray items to delete."])
			end
		end
	end
end 

function MOD:ModifyBags()
	local docked = SV.db.SVBag.alignToChat
	local anchor, x, y
	if(docked) then
		if self.BagFrame then
			self.BagFrame:ClearAllPoints()
			self.BagFrame:SetPointToScale("BOTTOMRIGHT", SV.Dock.BottomRight, "BOTTOMRIGHT", 0, 0)
		end 
		if self.BankFrame then
			self.BankFrame:ClearAllPoints()
			self.BankFrame:SetPointToScale("BOTTOMLEFT", SV.Dock.BottomLeft, "BOTTOMLEFT", 0, 0)
		end
	else
		if self.BagFrame then
			local anchor, x, y = SV.db.SVBag.bags.point, SV.db.SVBag.bags.xOffset, SV.db.SVBag.bags.yOffset
			self.BagFrame:ClearAllPoints()
			self.BagFrame:SetPointToScale(anchor, SV.Screen, anchor, x, y)
		end 
		if self.BankFrame then
			local anchor, x, y = SV.db.SVBag.bank.point, SV.db.SVBag.bank.xOffset, SV.db.SVBag.bank.yOffset
			self.BankFrame:ClearAllPoints()
			self.BankFrame:SetPointToScale(anchor, SV.Screen, anchor, x, y)
		end
	end
end 

do
	local function Bags_OnEnter()
		if SV.db.SVBag.bagBar.mouseover ~= true then return end 
		SVUI_BagBar:FadeIn(0.2, SVUI_BagBar:GetAlpha(), 1)
	end

	local function Bags_OnLeave()
		if SV.db.SVBag.bagBar.mouseover ~= true then return end 
		SVUI_BagBar:FadeOut(0.2, SVUI_BagBar:GetAlpha(), 0)
	end

	local function AlterBagBar(bar)
		local icon = _G[bar:GetName().."IconTexture"]
		bar.oldTex = icon:GetTexture()
		bar:RemoveTextures()
		bar:SetStylePanel("Fixed", "Default")
		bar:SetStylePanel("Slot", false, 1, nil, nil, true)
		icon:SetTexture(bar.oldTex)
		icon:SetAllPointsIn()
		icon:SetTexCoord(0.1, 0.9, 0.1, 0.9 )
	end

	local function LoadBagBar()
		if MOD.BagBarLoaded then return end

		local bar = CreateFrame("Frame", "SVUI_BagBar", SV.Screen)
		bar:SetPoint("TOPRIGHT", SV.Dock.BottomRight, "TOPLEFT", -4, 0)
		bar.buttons = {}
		bar:EnableMouse(true)
		bar:SetScript("OnEnter", Bags_OnEnter)
		bar:SetScript("OnLeave", Bags_OnLeave)

		MainMenuBarBackpackButton:SetParent(bar)
		MainMenuBarBackpackButton.SetParent = SV.Hidden;
		MainMenuBarBackpackButton:ClearAllPoints()
		MainMenuBarBackpackButtonCount:FontManager("default")
		MainMenuBarBackpackButtonCount:ClearAllPoints()
		MainMenuBarBackpackButtonCount:SetPointToScale("BOTTOMRIGHT", MainMenuBarBackpackButton, "BOTTOMRIGHT", -1, 4)
		MainMenuBarBackpackButton:HookScript("OnEnter", Bags_OnEnter)
		MainMenuBarBackpackButton:HookScript("OnLeave", Bags_OnLeave)

		tinsert(bar.buttons, MainMenuBarBackpackButton)
		AlterBagBar(MainMenuBarBackpackButton)

		local count = #bar.buttons
		local frameCount = NUM_BAG_FRAMES - 1;

		for i = 0, frameCount do 
			local bagSlot = _G["CharacterBag"..i.."Slot"]
			bagSlot:SetParent(bar)
			bagSlot.SetParent = SV.Hidden;
			bagSlot:HookScript("OnEnter", Bags_OnEnter)
			bagSlot:HookScript("OnLeave", Bags_OnLeave)
			AlterBagBar(bagSlot)
			count = count + 1
			bar.buttons[count] = bagSlot
		end

		MOD.BagBarLoaded = true
	end

	function MOD:ModifyBagBar()
		if not SV.db.SVBag.bagBar.enable then return end

		if not self.BagBarLoaded then 
			LoadBagBar() 
		end 
		if SV.db.SVBag.bagBar.mouseover then 
			SVUI_BagBar:SetAlpha(0)
		else 
			SVUI_BagBar:SetAlpha(1)
		end 

		local showBy = SV.db.SVBag.bagBar.showBy
		local sortDir = SV.db.SVBag.bagBar.sortDirection
		local bagSize = SV.db.SVBag.bagBar.size
		local bagSpacing = SV.db.SVBag.bagBar.spacing

		for i = 1, #SVUI_BagBar.buttons do 
			local button = SVUI_BagBar.buttons[i]
			local lastButton = SVUI_BagBar.buttons[i - 1]

			button:SetSizeToScale(bagSize)
			button:ClearAllPoints()

			if(showBy == "HORIZONTAL" and sortDir == "ASCENDING") then 
				if i == 1 then 
					button:SetPoint("LEFT", SVUI_BagBar, "LEFT", bagSpacing, 0)
				elseif lastButton then 
					button:SetPoint("LEFT", lastButton, "RIGHT", bagSpacing, 0)
				end 
			elseif(showBy == "VERTICAL" and sortDir == "ASCENDING") then 
				if i == 1 then 
					button:SetPoint("TOP", SVUI_BagBar, "TOP", 0, -bagSpacing)
				elseif lastButton then 
					button:SetPoint("TOP", lastButton, "BOTTOM", 0, -bagSpacing)
				end 
			elseif(showBy == "HORIZONTAL" and sortDir == "DESCENDING") then 
				if i == 1 then 
					button:SetPoint("RIGHT", SVUI_BagBar, "RIGHT", -bagSpacing, 0)
				elseif lastButton then 
					button:SetPoint("RIGHT", lastButton, "LEFT", -bagSpacing, 0)
				end 
			else 
				if i == 1 then 
					button:SetPoint("BOTTOM", SVUI_BagBar, "BOTTOM", 0, bagSpacing)
				elseif lastButton then 
					button:SetPoint("BOTTOM", lastButton, "TOP", 0, bagSpacing)
				end 
			end 
		end 
		if showBy == "HORIZONTAL" then 
			SVUI_BagBar:SetWidthToScale((bagSize * numBagFrame) + (bagSpacing * numBagFrame) + bagSpacing)
			SVUI_BagBar:SetHeightToScale(bagSize + (bagSpacing * 2))
		else 
			SVUI_BagBar:SetHeightToScale((bagSize * numBagFrame) + (bagSpacing * numBagFrame) + bagSpacing)
			SVUI_BagBar:SetWidthToScale(bagSize + (bagSpacing * 2))
		end

	    if not SVUI_BagBar_MOVE then
	    	SVUI_BagBar:SetStylePanel("Default", "Default")
	        SV.Mentalo:Add(SVUI_BagBar, L["Bags Bar"])
	    end

	    if SV.db.SVBag.bagBar.showBackdrop then 
			SVUI_BagBar.Panel:Show()
		else 
			SVUI_BagBar.Panel:Hide()
		end
	end
end
--[[ 
########################################################## 
BAG EVENTS
##########################################################
]]--
local Container_OnEvent = function(self, event, ...)
	if(event == "ITEM_LOCK_CHANGED") then
		local bagID, slotID = ...
		if(bagID and slotID and self.Bags[bagID]) then
			self.Bags[bagID]:SlotUpdate(slotID)
		end
	elseif(event == "BAG_UPDATE" or event == "EQUIPMENT_SETS_CHANGED") then
		BuildEquipmentMap()
		for _, id in ipairs(self.BagIDs) do
			local numSlots = GetContainerNumSlots(id)
			if(not self.Bags[id] and numSlots ~= 0) or (self.Bags[id] and (numSlots ~= self.Bags[id].numSlots)) then
				self:UpdateLayout();
				return;
			end
		end
		local bagID = ...
		if(bagID and self.Bags[bagID]) then
			self.Bags[bagID]:RefreshSlots()
		end
	elseif(event == "BAG_UPDATE_COOLDOWN") then 
		self:RefreshCooldowns()
	elseif(event == "PLAYERBANKSLOTS_CHANGED") then
		self:RefreshBags()
	elseif(event == "PLAYERREAGENTBANKSLOTS_CHANGED") then 
		local slotID = ...
		local container = _G["SVUI_ReagentContainerFrame"]
		if(slotID and container) then
			local bagID = container.BagID
			container.Bags[bagID]:SlotUpdate(slotID)
		end
	end 
end 
--[[ 
########################################################## 
BAG CONTAINER CREATION
##########################################################
]]--
do 
	local Search_OnKeyPressed = function(self)
		self:GetParent().detail:Show()
		self:ClearFocus()
		SetItemSearch('')
	end 

	local Search_OnInput = function(self)
		local i = 3;
		local j = self:GetText()
		if len(j) > i then 
			local k=true;
			for h=1,i,1 do 
				if sub(j,0-h,0-h) ~= sub(j,-1-h,-1-h) then 
					k=false;
					break 
				end 
			end 
			if k then 
				Search_OnKeyPressed(self)
				return 
			end 
		end 
		SetItemSearch(j)
	end 

	local Search_OnClick = function(self, button)
		local container = self:GetParent()
		if button == "RightButton"then 
			container.detail:Hide()
			container.editBox:Show()
			container.editBox:SetText(SEARCH)
			container.editBox:HighlightText()
		else 
			if container.editBox:IsShown()then 
				container.editBox:Hide()
				container.editBox:ClearFocus()
				container.detail:Show()
				SetItemSearch('')
			else 
				container.detail:Hide()
				container.editBox:Show()
				container.editBox:SetText(SEARCH)
				container.editBox:HighlightText()
			end 
		end 
	end 

	local Vendor_OnClick = function(self)
		if IsShiftKeyDown()then 
			SV.SystemAlert["DELETE_GRAYS"].Money = MOD:VendorGrays(false,true,true)
			SV:StaticPopup_Show('DELETE_GRAYS')
		else 
			MOD:VendorGrays()
		end 
	end 

	local Token_OnEnter = function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetBackpackToken(self:GetID())
	end 

	local Token_OnLeave = function(self)
		GameTooltip:Hide() 
	end 

	local Token_OnClick = function(self)
		if IsModifiedClick("CHATLINK") then 
			HandleModifiedItemClick(GetCurrencyLink(self.currencyID))
		end 
	end 

	local Tooltip_Show = function(self)
		GameTooltip:SetOwner(self:GetParent(),"ANCHOR_TOP",0,4)
		GameTooltip:ClearLines()

		if(self.altText and IsShiftKeyDown()) then
			GameTooltip:AddLine(self.altText)
		else
			GameTooltip:AddLine(self.ttText)
		end

		if self.ttText2 then 
			GameTooltip:AddLine(' ')
			GameTooltip:AddDoubleLine(self.ttText2,self.ttText2desc,1,1,1)
		end

		self:GetNormalTexture():SetGradient(unpack(SV.Media.gradient.highlight))
		GameTooltip:Show()
	end 

	local Tooltip_Hide = function(self)
		self:GetNormalTexture():SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
		GameTooltip:Hide()
	end 

	local Container_OnDragStart = function(self)
		if IsShiftKeyDown()then self:StartMoving()end
	end 
	local Container_OnDragStop = function(self)
		self:StopMovingOrSizing()
	end 
	local Container_OnClick = function(self)
		if IsControlKeyDown() then MOD:ModifyBags() end
	end 
	local Container_OnEnter = function(self)
		GameTooltip:SetOwner(self,"ANCHOR_TOPLEFT",0,4)
		GameTooltip:ClearLines()
		GameTooltip:AddDoubleLine(L['Hold Shift + Drag:'],L['Temporary Move'],1,1,1)
		GameTooltip:AddDoubleLine(L['Hold Control + Right Click:'],L['Reset Position'],1,1,1)
		GameTooltip:Show()
	end

	function MOD:MakeBags()
		local bagName = "SVUI_ContainerFrame"
		local uisCount = #UISpecialFrames + 1;
		local bagsCount = #self.BagFrames + 1;
		local frame = CreateFrame("Button", "SVUI_ContainerFrame", UIParent)

		frame:SetStylePanel("Default", "Container")
		frame:SetFrameStrata("HIGH")
		frame.UpdateLayout = ContainerFrame_UpdateLayout;
		frame.RefreshBags = ContainerFrame_UpdateBags;
		frame.RefreshCooldowns = ContainerFrame_UpdateCooldowns;

		frame:RegisterEvent("ITEM_LOCK_CHANGED")
		frame:RegisterEvent("BAG_UPDATE_COOLDOWN")
		frame:RegisterEvent("BAG_UPDATE")
		frame:RegisterEvent("EQUIPMENT_SETS_CHANGED")
		frame:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
		frame:RegisterEvent("PLAYERREAGENTBANKSLOTS_CHANGED")

		frame:SetMovable(true)

		frame:RegisterForDrag("LeftButton", "RightButton")
		frame:RegisterForClicks("AnyUp")

		frame:SetScript("OnDragStart", Container_OnDragStart)
		frame:SetScript("OnDragStop", Container_OnDragStop)
		frame:SetScript("OnClick", Container_OnClick)
		frame:SetScript("OnEnter", Container_OnEnter)
		frame:SetScript("OnLeave", Token_OnLeave)
		frame:SetScript("OnEvent", Container_OnEvent)

		frame.isBank = false;
		frame.isReagent = false;
		frame:Hide()
		frame.bottomOffset = 32;
		frame.topOffset = 65;

		frame.BagIDs = {0, 1, 2, 3, 4}

		frame.Bags = {}
		frame.closeButton = CreateFrame("Button", "SVUI_ContainerFrameCloseButton", frame, "UIPanelCloseButton")
		frame.closeButton:SetPointToScale("TOPRIGHT", -4, -4)
		frame.closeButton:SetScript("PostClick", function() 
			if(not InCombatLockdown()) then CloseBag(0) end 
		end)

		frame.holderFrame = CreateFrame("Frame", nil, frame)
		frame.holderFrame:SetPointToScale("TOP", frame, "TOP", 0, -frame.topOffset)
		frame.holderFrame:SetPointToScale("BOTTOM", frame, "BOTTOM", 0, frame.bottomOffset)

		frame.Title = frame:CreateFontString()
		frame.Title:FontManager("header")
		frame.Title:SetText(INVENTORY_TOOLTIP)
		frame.Title:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
		frame.Title:SetTextColor(1,0.8,0)

		frame.BagMenu = CreateFrame("Button", "SVUI_ContainerFrameBagMenu", frame)
		frame.BagMenu:SetPointToScale("BOTTOMLEFT", frame, "TOPLEFT", 0, 1)
		frame.BagMenu:SetStylePanel("Fixed", "Transparent")
		frame.BagMenu:Hide()

		frame.goldText = frame:CreateFontString(nil, "OVERLAY")
		frame.goldText:FontManager("bagnumber")
		frame.goldText:SetPointToScale("BOTTOMRIGHT", frame.holderFrame, "TOPRIGHT", -2, 4)
		frame.goldText:SetJustifyH("RIGHT")

		frame.editBox = CreateFrame("EditBox", "SVUI_ContainerFrameEditBox", frame)
		frame.editBox:SetFrameLevel(frame.editBox:GetFrameLevel()+2)
		frame.editBox:SetStylePanel("Editbox")
		frame.editBox:SetHeightToScale(15)
		frame.editBox:Hide()
		frame.editBox:SetPointToScale("BOTTOMLEFT", frame.holderFrame, "TOPLEFT", 2, 4)
		frame.editBox:SetPointToScale("RIGHT", frame.goldText, "LEFT", -5, 0)
		frame.editBox:SetAutoFocus(true)
		frame.editBox:SetScript("OnEscapePressed", Search_OnKeyPressed)
		frame.editBox:SetScript("OnEnterPressed", Search_OnKeyPressed)
		frame.editBox:SetScript("OnEditFocusLost", frame.editBox.Hide)
		frame.editBox:SetScript("OnEditFocusGained", frame.editBox.HighlightText)
		frame.editBox:SetScript("OnTextChanged", Search_OnInput)
		frame.editBox:SetScript("OnChar", Search_OnInput)
		frame.editBox.SearchReset = Search_OnKeyPressed
		frame.editBox:SetText(SEARCH)
		frame.editBox:FontManager("bagdialog")

		local searchButton = CreateFrame("Button", nil, frame)
		searchButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		searchButton:SetSize(60, 18)
		searchButton:SetPoint("BOTTOMLEFT", frame.editBox, "BOTTOMLEFT", -2, 0)
		searchButton:SetStylePanel("Button")
		searchButton:SetScript("OnClick", Search_OnClick)
		local searchText = searchButton:CreateFontString(nil, "OVERLAY")
		searchText:FontManager("bagdialog", nil, 0, "NONE")
		searchText:SetAllPoints(searchButton)
		searchText:SetJustifyH("CENTER")
		searchText:SetText("|cff9999ff"..SEARCH.."|r")
		searchButton:SetFontString(searchText)
		frame.detail = searchButton

		frame.sortButton = CreateFrame("Button", nil, frame)
		frame.sortButton:SetPointToScale("TOP", frame, "TOP", 0, -10)
		frame.sortButton:SetSizeToScale(25, 25)
		StyleBagToolButton(frame.sortButton, ICON_CLEANUP)
		frame.sortButton.ttText = L["Sort Bags"]
		frame.sortButton.altText = L["Filtered Cleanup"]
		frame.sortButton:SetScript("OnEnter", Tooltip_Show)
		frame.sortButton:SetScript("OnLeave", Tooltip_Hide)
		local Sort_OnClick = MOD:RunSortingProcess(MOD.Sort, "bags", SortBags)
		frame.sortButton:SetScript("OnClick", Sort_OnClick)

		frame.stackButton = CreateFrame("Button", nil, frame)
		frame.stackButton:SetPointToScale("LEFT", frame.sortButton, "RIGHT", 10, 0)
		frame.stackButton:SetSizeToScale(25, 25)
		StyleBagToolButton(frame.stackButton, ICON_STACK)
		frame.stackButton.ttText = L["Stack Items"]
		frame.stackButton:SetScript("OnEnter", Tooltip_Show)
		frame.stackButton:SetScript("OnLeave", Tooltip_Hide)
		local Stack_OnClick = MOD:RunSortingProcess(MOD.Stack, "bags")
		frame.stackButton:SetScript("OnClick", Stack_OnClick)

		frame.vendorButton = CreateFrame("Button", nil, frame)
		frame.vendorButton:SetPointToScale("RIGHT", frame.sortButton, "LEFT", -10, 0)
		frame.vendorButton:SetSizeToScale(25, 25)
		StyleBagToolButton(frame.vendorButton, ICON_VENDOR)
		frame.vendorButton.ttText = L["Vendor Grays"]
		frame.vendorButton.ttText2 = L["Hold Shift:"]
		frame.vendorButton.ttText2desc = L["Delete Grays"]
		frame.vendorButton:SetScript("OnEnter", Tooltip_Show)
		frame.vendorButton:SetScript("OnLeave", Tooltip_Hide)
		frame.vendorButton:SetScript("OnClick", Vendor_OnClick)

		frame.bagsButton = CreateFrame("Button", nil, frame)
		frame.bagsButton:SetPointToScale("RIGHT", frame.vendorButton, "LEFT", -10, 0)
		frame.bagsButton:SetSizeToScale(25, 25)
		StyleBagToolButton(frame.bagsButton, ICON_BAGS)
		frame.bagsButton.ttText = L["Toggle Bags"]
		frame.bagsButton:SetScript("OnEnter", Tooltip_Show)
		frame.bagsButton:SetScript("OnLeave", Tooltip_Hide)
		local BagBtn_OnClick = function()
			PlaySound("igMainMenuOption");
			if(BagFilters:IsShown()) then
				ToggleFrame(BagFilters)
			end
			ToggleFrame(frame.BagMenu)
		end
		frame.bagsButton:SetScript("OnClick", BagBtn_OnClick)

		frame.transferButton = CreateFrame("Button", nil, frame)
		frame.transferButton:SetPointToScale("LEFT", frame.stackButton, "RIGHT", 10, 0)
		frame.transferButton:SetSizeToScale(25, 25)
		StyleBagToolButton(frame.transferButton, ICON_TRANSFER)
		frame.transferButton.ttText = L["Stack Bags to Bank"]
		frame.transferButton:SetScript("OnEnter", Tooltip_Show)
		frame.transferButton:SetScript("OnLeave", Tooltip_Hide)
		local Transfer_OnClick = MOD:RunSortingProcess(MOD.Transfer, "bags bank")
		frame.transferButton:SetScript("OnClick", Transfer_OnClick)

		frame.currencyButton = CreateFrame("Frame", nil, frame)
		frame.currencyButton:SetPointToScale("BOTTOMLEFT", frame, "BOTTOMLEFT", 4, 0)
		frame.currencyButton:SetPointToScale("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -4, 0)
		frame.currencyButton:SetHeightToScale(32)
		for h = 1, MAX_WATCHED_TOKENS do 
			frame.currencyButton[h] = CreateFrame("Button", nil, frame.currencyButton)
			frame.currencyButton[h]:SetSizeToScale(22)
			frame.currencyButton[h]:SetStylePanel("Fixed", "Default")
			frame.currencyButton[h]:SetID(h)
			frame.currencyButton[h].icon = frame.currencyButton[h]:CreateTexture(nil, "OVERLAY")
			frame.currencyButton[h].icon:SetAllPointsIn()
			frame.currencyButton[h].icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			frame.currencyButton[h].text = frame.currencyButton[h]:CreateFontString(nil, "OVERLAY")
			frame.currencyButton[h].text:SetPointToScale("LEFT", frame.currencyButton[h], "RIGHT", 2, 0)
			frame.currencyButton[h].text:FontManager("bagnumber")
			frame.currencyButton[h]:SetScript("OnEnter", Token_OnEnter)
			frame.currencyButton[h]:SetScript("OnLeave", Token_OnLeave)
			frame.currencyButton[h]:SetScript("OnClick", Token_OnClick)
			frame.currencyButton[h]:Hide()
		end

		frame:SetScript("OnHide", CloseAllBags)

		tinsert(UISpecialFrames, bagName)
		tinsert(self.BagFrames, frame)

		self.BagFrame = frame
	end

	function MOD:MakeBankOrReagent(isReagent)
		-- Reagent Slots: 1 - 98
		-- /script print(ReagentBankFrameItem1:GetInventorySlot())
		local bagName = isReagent and "SVUI_ReagentContainerFrame" or "SVUI_BankContainerFrame"
		local uisCount = #UISpecialFrames + 1;
		local bagsCount = #self.BagFrames + 1;

		local frame = CreateFrame("Button", bagName, isReagent and self.BankFrame or SV.Screen)
		frame:SetStylePanel("Default", isReagent and "Action" or "Container")
		frame:SetFrameStrata("HIGH")
		frame:SetFrameLevel(SVUI_ContainerFrame:GetFrameLevel() + 99)

		frame.UpdateLayout = isReagent and ReagentFrame_UpdateLayout or ContainerFrame_UpdateLayout;
		frame.RefreshBags = ContainerFrame_UpdateBags;
		frame.RefreshCooldowns = ContainerFrame_UpdateCooldowns;

		frame:RegisterEvent("ITEM_LOCK_CHANGED")
		frame:RegisterEvent("BAG_UPDATE_COOLDOWN")
		frame:RegisterEvent("BAG_UPDATE")
		frame:RegisterEvent("EQUIPMENT_SETS_CHANGED")
		frame:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
		frame:RegisterEvent("PLAYERREAGENTBANKSLOTS_CHANGED")

		frame:SetMovable(true)
		frame:RegisterForDrag("LeftButton", "RightButton")
		frame:RegisterForClicks("AnyUp")
		frame:SetScript("OnDragStart", Container_OnDragStart)
		frame:SetScript("OnDragStop", Container_OnDragStop)
		frame:SetScript("OnClick", Container_OnClick)
		frame:SetScript("OnEnter", Container_OnEnter)
		frame:SetScript("OnLeave", Token_OnLeave)
		frame:SetScript("OnEvent", Container_OnEvent)

		frame.isBank = true;
		frame.isReagent = isReagent;
		frame:Hide()
		frame.bottomOffset = 8;
		frame.topOffset = 60;

		if(isReagent) then
			frame.BagIDs = {REAGENTBANK_CONTAINER}
		else
			frame.BagIDs = {-1, 5, 6, 7, 8, 9, 10, 11}
		end

		frame.Bags = {}

		frame.closeButton = CreateFrame("Button", bagName.."CloseButton", frame, "UIPanelCloseButton")
		frame.closeButton:SetPointToScale("TOPRIGHT", -4, -4)
		frame.closeButton:SetScript("PostClick", function() 
			if(not InCombatLockdown()) then CloseBag(0) end 
		end)

		frame.holderFrame = CreateFrame("Frame", nil, frame)
		frame.holderFrame:SetPointToScale("TOP", frame, "TOP", 0, -frame.topOffset)
		frame.holderFrame:SetPointToScale("BOTTOM", frame, "BOTTOM", 0, frame.bottomOffset)

		frame.Title = frame:CreateFontString()
		frame.Title:FontManager("header")
		frame.Title:SetText(isReagent and REAGENT_BANK or BANK or "Bank")
		frame.Title:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
		frame.Title:SetTextColor(1,0.8,0)

		frame.sortButton = CreateFrame("Button", nil, frame)
		frame.sortButton:SetPointToScale("TOPRIGHT", frame, "TOP", 0, -10)
		frame.sortButton:SetSizeToScale(25, 25)
		StyleBagToolButton(frame.sortButton, ICON_CLEANUP)
		frame.sortButton.ttText = L["Sort Bank"]
		frame.sortButton.altText = L["Filtered Cleanup"]
		frame.sortButton:SetScript("OnEnter", Tooltip_Show)
		frame.sortButton:SetScript("OnLeave", Tooltip_Hide)

		frame.stackButton = CreateFrame("Button", nil, frame)
		frame.stackButton:SetPointToScale("LEFT", frame.sortButton, "RIGHT", 10, 0)
		frame.stackButton:SetSizeToScale(25, 25)
		StyleBagToolButton(frame.stackButton, ICON_STACK)
		frame.stackButton.ttText = L["Stack Items"]
		frame.stackButton:SetScript("OnEnter", Tooltip_Show)
		frame.stackButton:SetScript("OnLeave", Tooltip_Hide)

		if(not isReagent) then
			frame.BagMenu = CreateFrame("Button", bagName.."BagMenu", frame)
			frame.BagMenu:SetPointToScale("BOTTOMLEFT", frame, "TOPLEFT", 0, 1)
			frame.BagMenu:SetStylePanel("Fixed", "Transparent")
			frame.BagMenu:Hide()

			local Sort_OnClick = MOD:RunSortingProcess(MOD.Sort, "bank", SortBankBags)
			frame.sortButton:SetScript("OnClick", Sort_OnClick)
			local Stack_OnClick = MOD:RunSortingProcess(MOD.Stack, "bank")
			frame.stackButton:SetScript("OnClick", Stack_OnClick)

			frame.transferButton = CreateFrame("Button", nil, frame)
			frame.transferButton:SetPointToScale("LEFT", frame.stackButton, "RIGHT", 10, 0)
			frame.transferButton:SetSizeToScale(25, 25)
			StyleBagToolButton(frame.transferButton, ICON_TRANSFER)
			frame.transferButton.ttText = L["Stack Bank to Bags"]
			frame.transferButton:SetScript("OnEnter", Tooltip_Show)
			frame.transferButton:SetScript("OnLeave", Tooltip_Hide)
			local Transfer_OnClick = MOD:RunSortingProcess(MOD.Transfer, "bank bags")
			frame.transferButton:SetScript("OnClick", Transfer_OnClick)
			
			tinsert(UISpecialFrames, bagName)

			frame.bagsButton = CreateFrame("Button", nil, frame)
			frame.bagsButton:SetPointToScale("RIGHT", frame.sortButton, "LEFT", -10, 0)
			frame.bagsButton:SetSizeToScale(25, 25)
			StyleBagToolButton(frame.bagsButton, ICON_BAGS)
			frame.bagsButton.ttText = L["Toggle Bags"]
			frame.bagsButton:SetScript("OnEnter", Tooltip_Show)
			frame.bagsButton:SetScript("OnLeave", Tooltip_Hide)
			local BagBtn_OnClick = function()
				PlaySound("igMainMenuOption");
				if(BagFilters:IsShown()) then
					ToggleFrame(BagFilters)
				end
				local numSlots, _ = GetNumBankSlots()
				if numSlots  >= 1 then 
					ToggleFrame(frame.BagMenu)
				else 
					SV:StaticPopup_Show("NO_BANK_BAGS")
				end 
			end
			frame.bagsButton:SetScript("OnClick", BagBtn_OnClick)

			frame.purchaseBagButton = CreateFrame("Button", nil, frame)
			frame.purchaseBagButton:SetSizeToScale(25, 25)
			frame.purchaseBagButton:SetPointToScale("RIGHT", frame.bagsButton, "LEFT", -10, 0)
			frame.purchaseBagButton:SetFrameLevel(frame.purchaseBagButton:GetFrameLevel()+2)
			StyleBagToolButton(frame.purchaseBagButton, ICON_PURCHASE)
			frame.purchaseBagButton.ttText = L["Purchase"]
			frame.purchaseBagButton:SetScript("OnEnter", Tooltip_Show)
			frame.purchaseBagButton:SetScript("OnLeave", Tooltip_Hide)
			local PurchaseBtn_OnClick = function()
				PlaySound("igMainMenuOption");
				local _, full = GetNumBankSlots()
				if not full then 
					SV:StaticPopup_Show("BUY_BANK_SLOT")
				else 
					SV:StaticPopup_Show("CANNOT_BUY_BANK_SLOT")
				end 
			end
			frame.purchaseBagButton:SetScript("OnClick", PurchaseBtn_OnClick)

			local active_icon = IsReagentBankUnlocked() and ICON_REAGENTS or ICON_PURCHASE
			frame.swapButton = CreateFrame("Button", nil, frame)
			frame.swapButton:SetPointToScale("TOPRIGHT", frame, "TOPRIGHT", -40, -10)
			frame.swapButton:SetSizeToScale(25, 25)
			StyleBagToolButton(frame.swapButton, active_icon)
			frame.swapButton.ttText = L["Toggle Reagents Bank"]
			frame.swapButton:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self:GetParent(),"ANCHOR_TOP",0,4)
				GameTooltip:ClearLines()
				if(not IsReagentBankUnlocked()) then
					GameTooltip:AddDoubleLine("Purchase Reagents Bank", FormatCurrency(GetReagentBankCost()), 0.1,1,0.1, 1,1,1)
				else
					GameTooltip:AddLine(self.ttText)
				end
				self:GetNormalTexture():SetGradient(unpack(SV.Media.gradient.highlight))
				GameTooltip:Show()
			end)
			frame.swapButton:SetScript("OnLeave", Tooltip_Hide)
			frame.swapButton:SetScript("OnClick", function()
				if(not IsReagentBankUnlocked()) then 
					SV:StaticPopup_Show("CONFIRM_BUY_REAGENTBANK_TAB");
				else
					PlaySound("igMainMenuOption");
					if(_G["SVUI_ReagentContainerFrame"]:IsShown()) then
						_G["SVUI_ReagentContainerFrame"]:Hide()
					else
						_G["SVUI_ReagentContainerFrame"]:Show()
					end
				end
			end)
			frame:SetScript("OnHide", CloseBankFrame)
			self.BankFrame = frame
		else
			local Sort_OnClick = MOD:RunSortingProcess(MOD.Sort, "reagent", SortBankBags)
			frame.sortButton:SetScript("OnClick", Sort_OnClick)
			local Stack_OnClick = MOD:RunSortingProcess(MOD.Stack, "reagent")
			frame.stackButton:SetScript("OnClick", Stack_OnClick)

			frame.transferButton = CreateFrame("Button", nil, frame)
			frame.transferButton:SetPointToScale("LEFT", frame.stackButton, "RIGHT", 10, 0)
			frame.transferButton:SetSizeToScale(25, 25)
			StyleBagToolButton(frame.transferButton, ICON_DEPOSIT)
			frame.transferButton.ttText = L["Deposit All Reagents"]
			frame.transferButton:SetScript("OnEnter", Tooltip_Show)
			frame.transferButton:SetScript("OnLeave", Tooltip_Hide)
			frame.transferButton:SetScript("OnClick", DepositReagentBank)

			frame:SetPoint("BOTTOMLEFT", self.BankFrame, "BOTTOMRIGHT", 2, 0)
			self.ReagentFrame = frame
		end

		tinsert(self.BagFrames, frame)
	end
end

function MOD:RefreshTokens()
	local frame = MOD.BagFrame;
	local index = 0;

	for i=1,MAX_WATCHED_TOKENS do
		local name,count,icon,currencyID = GetBackpackCurrencyInfo(i)
		local set = frame.currencyButton[i]
		set:ClearAllPoints()
		if name then 
			set.icon:SetTexture(icon)
			if SV.db.SVBag.currencyFormat == 'ICON_TEXT' then 
				set.text:SetText(name..': '..count)
			elseif SV.db.SVBag.currencyFormat == 'ICON' then 
				set.text:SetText(count)
			end 
			set.currencyID = currencyID;
			set:Show()
			index = index + 1; 
		else 
			set:Hide()
		end 
	end

	if index == 0 then 
		frame.bottomOffset = 8;
		if frame.currencyButton:IsShown() then 
			frame.currencyButton:Hide()
			MOD.BagFrame:UpdateLayout()
		end 
		return 
	elseif not frame.currencyButton:IsShown() then 
		frame.bottomOffset = 28;
		frame.currencyButton:Show()
		MOD.BagFrame:UpdateLayout()
	end

	frame.bottomOffset = 28;
	local set = frame.currencyButton;
	if index == 1 then 
		set[1]:SetPointToScale("BOTTOM", set, "BOTTOM", -(set[1].text:GetWidth() / 2), 3)
	elseif index == 2 then 
		set[1]:SetPointToScale("BOTTOM", set, "BOTTOM", -set[1].text:GetWidth()-set[1]:GetWidth() / 2, 3)
		frame.currencyButton[2]:SetPointToScale("BOTTOMLEFT", set, "BOTTOM", set[2]:GetWidth() / 2, 3)
	else 
		set[1]:SetPointToScale("BOTTOMLEFT", set, "BOTTOMLEFT", 3, 3)
		set[2]:SetPointToScale("BOTTOM", set, "BOTTOM", -(set[2].text:GetWidth() / 3), 3)
		set[3]:SetPointToScale("BOTTOMRIGHT", set, "BOTTOMRIGHT", -set[3].text:GetWidth()-set[3]:GetWidth() / 2, 3)
	end 
end


local function _openBags()
	GameTooltip:Hide()
	MOD.BagFrame:Show()
	MOD.BagFrame:RefreshBags()
	TTIP.GameTooltip_SetDefaultAnchor(GameTooltip)
	MOD.BagFrame.editBox:SearchReset()
end

local function _closeBags()
	GameTooltip:Hide()
	MOD.BagFrame:Hide()
	if(MOD.BankFrame) then 
		MOD.BankFrame:Hide()
	end
	if(MOD.ReagentFrame) then 
		MOD.ReagentFrame:Hide()
	end
	if(BreakStuffHandler and BreakStuffButton and BreakStuffButton.icon) then
		BreakStuffHandler:MODIFIER_STATE_CHANGED()
		BreakStuffHandler.ReadyToSmash = false
		BreakStuffButton.ttText = "BreakStuff : OFF";
		BreakStuffButton.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
	end
	TTIP.GameTooltip_SetDefaultAnchor(GameTooltip)
	MOD.BagFrame.editBox:SearchReset()
end

local function _toggleBags(id)
	if(id and (GetContainerNumSlots(id) == 0)) then return end 
	if(MOD.BagFrame:IsShown()) then 
		_closeBags()
	else 
		_openBags()
	end 
end

local function _toggleBackpack()
	if IsOptionFrameOpen() then return end 
	if IsBagOpen(0) then 
		_openBags()
	else 
		_closeBags()
	end 
end

local _hook_OnModifiedClick = function(self, button)
	if(MerchantFrame and MerchantFrame:IsShown()) then return end;
    if(IsAltKeyDown() and (button == "RightButton")) then
    	local slotID = self:GetID()
    	local bagID = self:GetParent():GetID()
    	local itemID = GetContainerItemID(bagID, slotID);
    	if(itemID) then
    		if(VendorQueue[itemID]) then
    			if(self.JunkIcon) then self.JunkIcon:Hide() end
    			VendorQueue[itemID] = nil
	    	else
	    		if(self.JunkIcon) then self.JunkIcon:Show() end
	    		VendorQueue[itemID] = true
	    	end
    	end
    end
end

function MOD:BANKFRAME_OPENED()
	if(not self.BankFrame) then 
		self:MakeBankOrReagent()
	end
	self.BankFrame:UpdateLayout()

	if(not self.ReagentFrame) then 
		self:MakeBankOrReagent(true)
	end
	
	if(self.ReagentFrame) then 
		self.ReagentFrame:UpdateLayout()
	end

	self:ModifyBags()
	
	self.BankFrame:Show()
	self.BankFrame:RefreshBags()
	self.BagFrame:Show()
	self.BagFrame:RefreshBags()
	self.RefreshTokens()
end

function MOD:BANKFRAME_CLOSED()
	if(self.BankFrame and self.BankFrame:IsShown()) then 
		self.BankFrame:Hide()
	end
	if(self.ReagentFrame and self.ReagentFrame:IsShown()) then 
		self.ReagentFrame:Hide()
	end
end

function MOD:PLAYERBANKBAGSLOTS_CHANGED()
	if(self.BankFrame) then 
		self.BankFrame:UpdateLayout()
	end
	if(self.ReagentFrame) then 
		self.ReagentFrame:UpdateLayout()
	end
end 

function MOD:PLAYER_ENTERING_WORLD()
	self:UpdateGoldText()
	self.BagFrame:RefreshBags()
end 
--[[ 
########################################################## 
BUILD FUNCTION / UPDATE
##########################################################
]]--
function MOD:ReLoad()
	if not SV.db.SVBag.enable then return end
	self:RefreshBagFrames()
	self:ModifyBags();
	self:ModifyBagBar();
end 

function MOD:Load()
	if IsAddOnLoaded("AdiBags") then
		return 
	end
	if not SV.db.SVBag.enable then return end
	self:ModifyBagBar()
	self.BagFrames = {}
	self:MakeBags()
	self:ModifyBags()
	self.BagFrame:UpdateLayout()

	-- BagFilters:SetParent(SV.Screen)
	BagFilters:SetStylePanel("Default", "Default")
	BagFilters.buttons = {}
	BagFilters:SetFrameStrata("DIALOG")
	BagFilters:SetClampedToScreen(true)

	for i = LE_BAG_FILTER_FLAG_EQUIPMENT, NUM_LE_BAG_FILTER_FLAGS do 
		BagFilters.buttons[i] = CreateFrame("Button", nil, BagFilters)

		BagFilters.buttons[i].hoverTex = BagFilters.buttons[i]:CreateTexture(nil, 'OVERLAY')
		BagFilters.buttons[i].hoverTex:SetAllPoints()
		BagFilters.buttons[i].hoverTex:SetTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
		BagFilters.buttons[i].hoverTex:SetBlendMode("ADD")
		BagFilters.buttons[i].hoverTex:Hide()

		BagFilters.buttons[i].activeTex = BagFilters.buttons[i]:CreateTexture(nil, 'OVERLAY')
		BagFilters.buttons[i].activeTex:SetAllPoints()
		BagFilters.buttons[i].activeTex:SetTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
		BagFilters.buttons[i].activeTex:SetVertexColor(0,0.7,0)
		BagFilters.buttons[i].activeTex:SetBlendMode("ADD")
		BagFilters.buttons[i].activeTex:Hide()

		BagFilters.buttons[i].text = BagFilters.buttons[i]:CreateFontString(nil, 'BORDER')
		BagFilters.buttons[i].text:SetAllPoints()
		BagFilters.buttons[i].text:SetFont(SV.Media.font.default,12,"OUTLINE")
		BagFilters.buttons[i].text:SetJustifyH("LEFT")
		BagFilters.buttons[i].text:SetText(BAG_FILTER_LABELS[i])

		BagFilters.buttons[i]:SetScript("OnEnter", DD_OnEnter)
		BagFilters.buttons[i]:SetScript("OnLeave", DD_OnLeave)

		BagFilters.buttons[i]:SetHeight(16)
		BagFilters.buttons[i]:SetWidth(115)

		BagFilters.buttons[i].FilterID = i
		BagFilters.buttons[i]:SetScript("OnClick", DD_OnClick)

		if i == LE_BAG_FILTER_FLAG_EQUIPMENT then
			BagFilters.buttons[i]:SetPoint("TOPLEFT", BagFilters, "TOPLEFT", 10, -10)
		else
			BagFilters.buttons[i]:SetPoint("TOPLEFT", BagFilters.buttons[i - 1], "BOTTOMLEFT", 0, 0)
		end

		BagFilters.buttons[i]:Show()
	end

	local clearID = NUM_LE_BAG_FILTER_FLAGS + 1

	BagFilters.buttons[clearID] = CreateFrame("Button", nil, BagFilters)
	BagFilters.buttons[clearID].hoverTex = BagFilters.buttons[clearID]:CreateTexture(nil, 'OVERLAY')
	BagFilters.buttons[clearID].hoverTex:SetAllPoints()
	BagFilters.buttons[clearID].hoverTex:SetTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
	BagFilters.buttons[clearID].hoverTex:SetBlendMode("ADD")
	BagFilters.buttons[clearID].hoverTex:Hide()
	BagFilters.buttons[clearID].text = BagFilters.buttons[clearID]:CreateFontString(nil, 'BORDER')
	BagFilters.buttons[clearID].text:SetAllPoints()
	BagFilters.buttons[clearID].text:SetFont(SV.Media.font.default,12,"OUTLINE")
	BagFilters.buttons[clearID].text:SetJustifyH("LEFT")
	BagFilters.buttons[clearID].text:SetText(CLEAR_ALL .. " " .. FILTERS)
	BagFilters.buttons[clearID]:SetScript("OnEnter", DD_OnEnter)
	BagFilters.buttons[clearID]:SetScript("OnLeave", DD_OnLeave)
	BagFilters.buttons[clearID]:SetHeight(16)
	BagFilters.buttons[clearID]:SetWidth(115)
	BagFilters.buttons[clearID].FilterID = 0
	BagFilters.buttons[clearID]:SetScript("OnClick", DDClear_OnClick)
	BagFilters.buttons[clearID]:SetPoint("TOPLEFT", BagFilters.buttons[NUM_LE_BAG_FILTER_FLAGS], "BOTTOMLEFT", 0, -10)
	BagFilters.buttons[clearID]:Show()


	BagFilters:Hide()
	SV:AddToDisplayAudit(BagFilters)

	BankFrame:UnregisterAllEvents()
	for i = 1, NUM_CONTAINER_FRAMES do
		local frame = _G["ContainerFrame"..i]
		if(frame) then frame:Die() end
	end 

	SV.Timers:ExecuteTimer(self.BreakStuffLoader, 5)

	hooksecurefunc("OpenAllBags", _openBags)
	hooksecurefunc("CloseAllBags", _closeBags)
	hooksecurefunc("ToggleBag", _toggleBags)
	hooksecurefunc("ToggleAllBags", _toggleBackpack)
	hooksecurefunc("ToggleBackpack", _toggleBackpack)
	hooksecurefunc("BackpackTokenFrame_Update", self.RefreshTokens)
	hooksecurefunc("ContainerFrameItemButton_OnModifiedClick", _hook_OnModifiedClick)

	self:RegisterEvent("BANKFRAME_OPENED")
	self:RegisterEvent("BANKFRAME_CLOSED")
	self:RegisterEvent("INVENTORY_SEARCH_UPDATE")
	self:RegisterEvent("PLAYER_MONEY", "UpdateGoldText")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_TRADE_MONEY", "UpdateGoldText")
	self:RegisterEvent("TRADE_MONEY_CHANGED", "UpdateGoldText")
	self:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED")

	StackSplitFrame:SetFrameStrata("DIALOG")
end 