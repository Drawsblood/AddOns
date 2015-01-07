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
local SuperButton = _G["SVUI_SuperButtonFrame"];
SuperButton.RegisteredButtons = {};
SuperButton.ActionBlackList = {};
SuperButton.SpellBlackList = {};
SuperButton.ItemBlackList = {};
local ORDERED_LIST = {};
local NO_ART = [[Interface\AddOns\SVUI\assets\artwork\Template\EMPTY]];
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local UpdateActionCooldown = function(self)
	if(self:IsShown() and self.action) then
		local start, duration, enable = GetActionCooldown(self.action)
		if((start and start > 0) and (duration and duration > 0)) then
			self.Cooldown:SetCooldown(start, duration)
			self.Cooldown:Show()
		else
			self.Cooldown:Hide()
		end
	end
end

local UpdateSpellCooldown = function(self)
	if(self:IsShown() and self.spellName) then
		local start, duration, enable = GetSpellCooldown(self.spellName)
		if((start and start > 0) and (duration and duration > 0)) then
			self.Cooldown:SetCooldown(start, duration)
			self.Cooldown:Show()
		else
			self.Cooldown:Hide()
		end
	end
end

local UpdateItemCooldown = function(self)
	if(self:IsShown() and self.itemID) then
		local start, duration, enable = GetItemCooldown(self.itemID)
		if((start and start > 0) and (duration and duration > 0)) then
			self.Cooldown:SetCooldown(start, duration)
			self.Cooldown:Show()
		else
			self.Cooldown:Hide()
		end
	end
end
--[[ 
########################################################## 
SCRIPT HANDLERS
##########################################################
]]--
local SuperActionButton_OnEnter = function(self)
	if(self.action) then
		GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
		GameTooltip:SetAction(self.action)
	end
end

local SuperSpellButton_OnEnter = function(self)
	if(self.spellID) then
		GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
		GameTooltip:SetSpellByID(self.spellID)
	end
end

local SuperItemButton_OnEnter = function(self)
	if(self.itemID) then
		GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
		GameTooltip:SetHyperlink(self.itemLink)
	end
end

local SuperButton_OnShow = function(self)
	self:FadeIn()
	if(self.Artwork) then
		self.Artwork:SetTexture(self.ArtFile or [[Interface\ExtraButton\Smash]]);
		self.Artwork:FadeIn()
	end
end

local SuperButton_OnHide = function(self)
	if(self.Artwork) then
		self.Artwork:FadeOut()
		self.Artwork:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\EMPTY]]);
	end
end

local GetSetPositions = function(self)
	local highestIndex = 0;
	local lastFrame = SuperButton;
	for name, frame in pairs(SuperButton.RegisteredButtons) do
		if((frame ~= self) and frame:IsShown() and (frame.___posIndex > highestIndex)) then
			highestIndex = frame.___posIndex;
			lastFrame = name;
		end
	end

	self.___posIndex = highestIndex + 1;
	--print(self:GetName() .. " = " .. self.___posIndex)
	return lastFrame;
end

local GetResetPositions = function(self)
	self.___posIndex = 0;
	for name, frame in pairs(SuperButton.RegisteredButtons) do
		if((frame ~= self) and frame:IsShown() and (frame.___posIndex == 1)) then
			tinsert(ORDERED_LIST, name)
		end
	end
	for name, frame in pairs(SuperButton.RegisteredButtons) do
		if((frame ~= self) and frame:IsShown() and (frame.___posIndex > 1)) then
			tinsert(ORDERED_LIST, name)
		end
	end
	return ORDERED_LIST;
end

local UpdateGeneric = function(self)
	return true;
end

local SuperButtonAction_OnEvent = function(self, event)
	if(event == 'PLAYER_REGEN_ENABLED') then
		self:SetAttribute('action', self.attribute)
		self:UnregisterEvent(event)
		self:UpdateCooldown()
	elseif(event == 'UPDATE_BINDINGS') then
		if(self:IsShown()) then
			self:SetAbility()
			self:SetAttribute('binding', GetTime())
		end
	else
		self:Update()
	end
end

local SuperButtonSpell_OnEvent = function(self, event)
	if(event == 'PLAYER_REGEN_ENABLED') then
		self:SetAttribute('spell', self.attribute)
		self:UnregisterEvent(event)
		self:UpdateCooldown()
	elseif(event == 'UPDATE_BINDINGS') then
		if(self:IsShown()) then
			self:SetAbility()
			self:SetAttribute('binding', GetTime())
		end
	else
		self:Update()
	end
end

local SuperButtonItem_OnEvent = function(self, event)
	if(event == 'BAG_UPDATE_COOLDOWN') then
		self:UpdateCooldown()
	elseif(event == 'PLAYER_REGEN_ENABLED') then
		self:SetAttribute('item', self.attribute)
		self:UnregisterEvent(event)
		self:UpdateCooldown()
	elseif(event == 'UPDATE_BINDINGS') then
		if(self:IsShown()) then
			self:SetAbility()
			self:SetAttribute('binding', GetTime())
		end
	else
		self:Update()
	end
end
--[[ 
########################################################## 
ACTION BUTTON INTERNALS
##########################################################
]]--
local SetSuperButtonAction = function(self, action)
	if(action) then
		if(action == self.action and self:IsShown()) then
			return false
		end
		self.action = action

		if(SuperButton.ActionBlackList[self.action]) then
			return false
		end
	end

	local HotKey = self.HotKey
	local key = GetBindingKey(self.___binding)
	if(key) then
		HotKey:SetText(GetBindingText(key, 1))
		HotKey:Show()
	elseif(ActionHasRange(self.action)) then
		HotKey:SetText(RANGE_INDICATOR)
		HotKey:Show()
	else
		HotKey:Hide()
	end

	if(InCombatLockdown()) then
		self.attribute = self.action
		self:RegisterEvent('PLAYER_REGEN_ENABLED')
	else
		self:SetAttribute('action', self.action)
		self:UpdateCooldown()
	end

	return true
end

local RemoveSuperButtonAction = function(self)
	self:FadeOut()
	if(InCombatLockdown()) then
		self.attribute = nil;
		self:RegisterEvent('PLAYER_REGEN_ENABLED')
	else
		self:SetAttribute('action', nil)
	end
end

local SuperActionButton_OnUpdate = function(self, elapsed)
	if(not self.action) then return end
	if(self.rangeTimer > 0.2) then
		local HotKey = self.HotKey
		local inRange = IsActionInRange(self.action, 'target')
		if(HotKey:GetText() == RANGE_INDICATOR) then
			if(inRange == false) then
				HotKey:SetTextColor(1, 0.1, 0.1)
				HotKey:Show()
			elseif(inRange) then
				HotKey:SetTextColor(1, 1, 1)
				HotKey:Show()
			else
				HotKey:Hide()
			end
		else
			if(inRange == false) then
				HotKey:SetTextColor(1, 0.1, 0.1)
			else
				HotKey:SetTextColor(1, 1, 1)
			end
		end

		self.rangeTimer = 0
	else
		self.rangeTimer = self.rangeTimer + elapsed
	end

	if(self.updateTimer > 5) then
		self:Update()
		self.updateTimer = 0
	else
		self.updateTimer = self.updateTimer + elapsed
	end
end
--[[ 
########################################################## 
SPELL BUTTON INTERNALS
##########################################################
]]--
local SetSuperButtonSpell = function(self, spellID, spellName, texture)
	if(spellID and spellName) then
		if(spellID == self.spellID and self:IsShown()) then
			return false
		end

		self.Icon:SetTexture(texture)
		self.spellID = spellID
		self.spellName = spellName

		if(SuperButton.SpellBlackList[self.spellID]) then
			return false
		end
	end

	local HotKey = self.HotKey
	local key = GetBindingKey(self.___binding)
	if(key) then
		HotKey:SetText(GetBindingText(key, 1))
		HotKey:Show()
	elseif(SpellHasRange(self.spellName)) then
		HotKey:SetText(RANGE_INDICATOR)
		HotKey:Show()
	else
		HotKey:Hide()
	end

	if(InCombatLockdown()) then
		self.attribute = self.spellName
		self:RegisterEvent('PLAYER_REGEN_ENABLED')
	else
		self:SetAttribute('spell', self.spellName)
		self:UpdateCooldown()
	end

	return true
end

local RemoveSuperButtonSpell = function(self)
	self:FadeOut()
	if(InCombatLockdown()) then
		self.attribute = nil;
		self:RegisterEvent('PLAYER_REGEN_ENABLED');
	else
		self:SetAttribute('spell', nil);
	end
end

local SuperSpellButton_OnUpdate = function(self, elapsed)
	if(not self.spellName) then return end
	if(self.rangeTimer > 0.2) then
		local HotKey = self.HotKey
		local inRange = IsSpellInRange(self.spellName, 'target')
		if(HotKey:GetText() == RANGE_INDICATOR) then
			if(inRange == false) then
				HotKey:SetTextColor(1, 0.1, 0.1)
				HotKey:Show()
			elseif(inRange) then
				HotKey:SetTextColor(1, 1, 1)
				HotKey:Show()
			else
				HotKey:Hide()
			end
		else
			if(inRange == false) then
				HotKey:SetTextColor(1, 0.1, 0.1)
			else
				HotKey:SetTextColor(1, 1, 1)
			end
		end

		self.rangeTimer = 0
	else
		self.rangeTimer = self.rangeTimer + elapsed
	end

	if(self.updateTimer > 5) then
		self:Update()
		self.updateTimer = 0
	else
		self.updateTimer = self.updateTimer + elapsed
	end
end
--[[ 
########################################################## 
ITEM BUTTON INTERNALS
##########################################################
]]--
local SetSuperButtonItem = function(self, itemLink, texture)
	if(itemLink) then
		if(itemLink == self.itemLink and self:IsShown()) then
			return false
		end

		self.Icon:SetTexture(texture)
		self.itemID, self.itemName = string.match(itemLink, '|Hitem:(.-):.-|h%[(.+)%]|h')
		self.itemLink = itemLink

		if(SuperButton.ItemBlackList[self.itemID]) then
			return false
		end
	end

	local HotKey = self.HotKey
	local key = GetBindingKey(self.___binding)
	if(key) then
		HotKey:SetText(GetBindingText(key, 1))
		HotKey:Show()
	elseif(ItemHasRange(self.itemLink)) then
		HotKey:SetText(RANGE_INDICATOR)
		HotKey:Show()
	else
		HotKey:Hide()
	end

	if(InCombatLockdown()) then
		self.attribute = self.itemName
		self:RegisterEvent('PLAYER_REGEN_ENABLED')
	else
		self:SetAttribute('item', self.itemName)
		self:UpdateCooldown()
	end

	return true
end

local RemoveSuperButtonItem = function(self)
	self:FadeOut()
	if(InCombatLockdown()) then
		self.attribute = nil;
		self:RegisterEvent('PLAYER_REGEN_ENABLED');
	else
		self:SetAttribute('item', nil)
	end
end

local SuperItemButton_OnUpdate = function(self, elapsed)
	if(not self.itemID) then return end
	if(self.rangeTimer > 0.2) then
		local HotKey = self.HotKey
		local inRange = IsItemInRange(self.itemID, 'target')
		if(HotKey:GetText() == RANGE_INDICATOR) then
			if(inRange == false) then
				HotKey:SetTextColor(1, 0.1, 0.1)
				HotKey:Show()
			elseif(inRange) then
				HotKey:SetTextColor(1, 1, 1)
				HotKey:Show()
			else
				HotKey:Hide()
			end
		else
			if(inRange == false) then
				HotKey:SetTextColor(1, 0.1, 0.1)
			else
				HotKey:SetTextColor(1, 1, 1)
			end
		end

		self.rangeTimer = 0
	else
		self.rangeTimer = self.rangeTimer + elapsed
	end

	if(self.updateTimer > 5) then
		self:Update()
		self.updateTimer = 0
	else
		self.updateTimer = self.updateTimer + elapsed
	end
end
--[[ 
########################################################## 
CONSTRUCTS
##########################################################
]]--
function SuperButton:SetFrameReferences()
	local listing = self.RegisteredButtons;
	for buttonName, button in pairs(listing) do
		button:SetFrameRef("SVUI_SuperButtonFrame", SVUI_SuperButtonFrame);
		for name, frame in pairs(listing) do
			if(frame ~= button) then
				button:SetFrameRef(name, frame);
			end
		end
	end
end

function SuperButton:AddAction(buttonName, updateFunc, eventFunc, bindingKey)
	local special = CreateFrame('Button', buttonName, UIParent, 'SecureActionButtonTemplate, SecureHandlerStateTemplate, SecureHandlerAttributeTemplate');
	special:SetSizeToScale(50,50);
	special:SetPointToScale("CENTER", self, "CENTER", 0, 0);
	special:SetAlpha(0);
	special:SetStylePanel("Icon");
	special:SetScript('OnEnter', SuperActionButton_OnEnter);
	special:SetScript('OnLeave', GameTooltip_Hide);
	special:SetScript('OnShow', SuperButton_OnShow);
	special:SetScript('OnHide', SuperButton_OnHide);

	special.___posIndex = 1;
	special.___binding = bindingKey;
	special.updateTimer = 0;
	special.rangeTimer = 0;

	special.GetPositionRef = GetSetPositions;
	special.GetResetRefList = GetResetPositions;
	special.SetAbility = SetSuperButtonAction;
	special.RemoveAbility = RemoveSuperButtonAction;
	special.UpdateCooldown = UpdateActionCooldown;
	if(updateFunc and type(updateFunc) == 'function') then
		special.Update = updateFunc;
	else
		special.Update = UpdateGeneric;
	end
	if(eventFunc and type(eventFunc) == 'function') then
		special:SetScript('OnEvent', eventFunc)
	else
		special:SetScript('OnEvent', SuperButtonAction_OnEvent)
	end

	local Artwork = special.Panel:CreateTexture('$parentArtwork', 'BACKGROUND')
	Artwork:SetPoint('CENTER', -2, 2)
	Artwork:SetSizeToScale(256, 128)
	Artwork:SetTexture(NO_ART)
	Artwork:SetAlpha(0)
	special.Artwork = Artwork

	local Icon = special:CreateTexture('$parentIcon', 'BACKGROUND')
	Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	Icon:SetAllPoints()
	special.Icon = Icon

	local HotKey = special:CreateFontString('$parentHotKey', nil, 'NumberFontNormal')
	HotKey:SetPoint('BOTTOMRIGHT', -5, 5)
	special.HotKey = HotKey

	local Cooldown = CreateFrame('Cooldown', '$parentCooldown', special, 'CooldownFrameTemplate')
	Cooldown:ClearAllPoints()
	Cooldown:SetPoint('TOPRIGHT', -2, -3)
	Cooldown:SetPoint('BOTTOMLEFT', 2, 1)
	Cooldown:Hide()
	special.Cooldown = Cooldown

	local Count = Cooldown:CreateFontString(nil, 'OVERLAY', 'NumberFontNormal')
	Count:SetPoint('BOTTOMLEFT', 5, 5)
	special.Count = Count

	special:SetScript('OnUpdate', SuperActionButton_OnUpdate)
	special:RegisterEvent('UPDATE_BINDINGS')



	special:SetAttribute('type', 'action');
	special:SetAttribute('_onattributechanged', [[
		if(name == 'action') then
			if(value and not self:IsShown()) then
				local refName = self:CallMethod('GetPositionRef');
				local lastFrame = self:GetFrameRef(refName);
				if(lastFrame) then
					self:ClearAllPoints()
					self:SetPoint("BOTTOM", lastFrame, "TOP", 0, 8)		
				end
				self:Show()
			elseif(not value) then
				local refList = self:CallMethod('GetResetRefList');
				local lastFrame, nextFrame;
				if(refList) then
					for _,refName in ipairs(refList) do
						nextFrame = self:GetFrameRef(refName);
						if(nextFrame) then
							nextFrame:ClearAllPoints()
							if(not lastFrame) then
								lastFrame = self:GetFrameRef("SVUI_SuperButtonFrame");
								nextFrame:SetPoint("CENTER", lastFrame, "CENTER", 0, 0);
							else
								nextFrame:SetPoint("BOTTOM", lastFrame, "TOP", 0, 8);
							end	
						end
					end
				end
				self:Hide()
				self:ClearBindings()
			end
		end
		if(self:IsShown() and (self.___binding ~= nil) and (name == 'action' or name == 'binding')) then
			self:ClearBindings()
			local key = GetBindingKey(self.___binding)
			if(key) then
				self:SetBindingClick(1, key, self, 'LeftButton')
			end
		end
	]]);

	self.RegisteredButtons[buttonName] = special;

	self:SetFrameReferences()

	--special:Hide()

	return special
end

function SuperButton:AddSpell(buttonName, updateFunc, eventFunc, bindingKey)
	local special = CreateFrame('Button', buttonName, UIParent, 'SecureActionButtonTemplate, SecureHandlerStateTemplate, SecureHandlerAttributeTemplate');
	special:SetSizeToScale(50,50);
	special:SetPointToScale("CENTER", self, "CENTER", 0, 0);
	special:SetAlpha(0);
	special:SetStylePanel("Icon");
	special:SetScript('OnEnter', SuperSpellButton_OnEnter);
	special:SetScript('OnLeave', GameTooltip_Hide);
	special:SetScript('OnShow', SuperButton_OnShow);
	special:SetScript('OnHide', SuperButton_OnHide);

	special.___posIndex = 1;
	special.___binding = bindingKey;
	special.updateTimer = 0;
	special.rangeTimer = 0;

	special.GetPositionRef = GetSetPositions;
	special.GetResetRefList = GetResetPositions;
	special.SetAbility = SetSuperButtonSpell;
	special.RemoveAbility = RemoveSuperButtonSpell;
	special.UpdateCooldown = UpdateSpellCooldown;

	if(updateFunc and type(updateFunc) == 'function') then
		special.Update = updateFunc
	else
		special.Update = UpdateGeneric
	end
	if(eventFunc and type(eventFunc) == 'function') then
		special:SetScript('OnEvent', eventFunc)
	else
		special:SetScript('OnEvent', SuperButtonSpell_OnEvent)
	end

	local Artwork = special.Panel:CreateTexture('$parentArtwork', 'BACKGROUND')
	Artwork:SetPoint('CENTER', -2, 2)
	Artwork:SetSizeToScale(256, 128)
	Artwork:SetTexture(NO_ART)
	Artwork:SetAlpha(0)
	special.Artwork = Artwork

	local Icon = special:CreateTexture('$parentIcon', 'BACKGROUND')
	Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	Icon:SetAllPoints()
	special.Icon = Icon

	local HotKey = special:CreateFontString('$parentHotKey', nil, 'NumberFontNormal')
	HotKey:SetPoint('BOTTOMRIGHT', -5, 5)
	special.HotKey = HotKey

	local Cooldown = CreateFrame('Cooldown', '$parentCooldown', special, 'CooldownFrameTemplate')
	Cooldown:ClearAllPoints()
	Cooldown:SetPoint('TOPRIGHT', -2, -3)
	Cooldown:SetPoint('BOTTOMLEFT', 2, 1)
	Cooldown:Hide()
	special.Cooldown = Cooldown

	special:SetScript('OnUpdate', SuperSpellButton_OnUpdate)
	special:RegisterEvent('UPDATE_BINDINGS')

	special:SetAttribute('type', 'spell');
	special:SetAttribute('_onattributechanged', [[
		if(name == 'spell') then
			if(value and not self:IsShown()) then
				local refName = self:CallMethod('GetPositionRef');
				local lastFrame = self:GetFrameRef(refName);
				if(lastFrame) then
					self:ClearAllPoints()
					self:SetPoint("BOTTOM", lastFrame, "TOP", 0, 8)		
				end
				self:Show()
			elseif(not value) then
				local refList = self:CallMethod('GetResetRefList');
				local lastFrame, nextFrame;
				if(refList) then
					for _,refName in ipairs(refList) do
						nextFrame = self:GetFrameRef(refName);
						if(nextFrame) then
							nextFrame:ClearAllPoints()
							if(not lastFrame) then
								lastFrame = self:GetFrameRef("SVUI_SuperButtonFrame");
								nextFrame:SetPoint("CENTER", lastFrame, "CENTER", 0, 0);
							else
								nextFrame:SetPoint("BOTTOM", lastFrame, "TOP", 0, 8);
							end	
						end
					end
				end
				self:Hide()
				self:ClearBindings()
			end
		end
		if(self:IsShown() and (self.___binding ~= nil) and (name == 'spell' or name == 'binding')) then
			self:ClearBindings()
			local key = GetBindingKey(self.___binding)
			if(key) then
				self:SetBindingClick(1, key, self, 'LeftButton')
			end
		end
	]]);

	self.RegisteredButtons[buttonName] = special;

	self:SetFrameReferences()

	--special:Hide()

	return special
end

function SuperButton:AddItem(buttonName, updateFunc, eventFunc, bindingKey)
	local special = CreateFrame('Button', buttonName, UIParent, 'SecureActionButtonTemplate, SecureHandlerStateTemplate, SecureHandlerAttributeTemplate');
	special:SetSizeToScale(50,50);
	special:SetPointToScale("CENTER", self, "CENTER", 0, 0);
	special:SetAlpha(0);
	special:SetStylePanel("Icon");
	special:SetScript('OnEnter', SuperItemButton_OnEnter);
	special:SetScript('OnLeave', GameTooltip_Hide);
	special:SetScript('OnShow', SuperButton_OnShow);
	special:SetScript('OnHide', SuperButton_OnHide);

	special.___posIndex = 1;
	special.___binding = bindingKey;
	special.updateTimer = 0;
	special.rangeTimer = 0;

	special.GetPositionRef = GetSetPositions;
	special.GetResetRefList = GetResetPositions;
	special.SetAbility = SetSuperButtonItem;
	special.RemoveAbility = RemoveSuperButtonItem;
	special.UpdateCooldown = UpdateItemCooldown;

	if(updateFunc and type(updateFunc) == 'function') then
		special.Update = updateFunc
	else
		special.Update = UpdateGeneric
	end
	if(eventFunc and type(eventFunc) == 'function') then
		special:SetScript('OnEvent', eventFunc)
	else
		special:SetScript('OnEvent', SuperButtonItem_OnEvent)
	end

	local Artwork = special.Panel:CreateTexture('$parentArtwork', 'BACKGROUND')
	Artwork:SetPoint('CENTER', -2, 2)
	Artwork:SetSizeToScale(256, 128)
	Artwork:SetTexture(NO_ART)
	Artwork:SetAlpha(0)
	special.Artwork = Artwork

	local Icon = special:CreateTexture('$parentIcon', 'BACKGROUND')
	Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	Icon:SetAllPoints()
	special.Icon = Icon

	local HotKey = special:CreateFontString('$parentHotKey', nil, 'NumberFontNormal')
	HotKey:SetPoint('BOTTOMRIGHT', -5, 5)
	special.HotKey = HotKey

	local Cooldown = CreateFrame('Cooldown', '$parentCooldown', special, 'CooldownFrameTemplate')
	Cooldown:ClearAllPoints()
	Cooldown:SetPoint('TOPRIGHT', -2, -3)
	Cooldown:SetPoint('BOTTOMLEFT', 2, 1)
	Cooldown:Hide()
	special.Cooldown = Cooldown

	special:RegisterEvent('UPDATE_BINDINGS')

	special:SetAttribute('type', 'item');
	special:SetAttribute('_onattributechanged', [[
		if(name == 'item') then
			if(value and not self:IsShown()) then
				local refName = self:CallMethod('GetPositionRef');
				local lastFrame = self:GetFrameRef(refName);
				if(lastFrame) then
					self:ClearAllPoints()
					self:SetPoint("BOTTOM", lastFrame, "TOP", 0, 8)		
				end
				self:Show()
			elseif(not value) then
				local refList = self:CallMethod('GetResetRefList');
				local lastFrame, nextFrame;
				if(refList) then
					for _,refName in ipairs(refList) do
						nextFrame = self:GetFrameRef(refName);
						if(nextFrame) then
							nextFrame:ClearAllPoints()
							if(not lastFrame) then
								lastFrame = self:GetFrameRef("SVUI_SuperButtonFrame");
								nextFrame:SetPoint("CENTER", lastFrame, "CENTER", 0, 0);
							else
								nextFrame:SetPoint("BOTTOM", lastFrame, "TOP", 0, 8);
							end	
						end
					end
				end
				self:Hide()
				self:ClearBindings()
			end
		end
		if(self:IsShown() and (self.___binding ~= nil) and (name == 'item' or name == 'binding')) then
			self:ClearBindings()
			local key = GetBindingKey(self.___binding)
			if(key) then
				self:SetBindingClick(1, key, self, 'LeftButton')
			end
		end
	]]);

	self.RegisteredButtons[buttonName] = special;

	self:SetFrameReferences()

	--special:Hide()

	return special
end
--[[ 
########################################################## 
PACKAGE CALL
##########################################################
]]--
function SuperButton:Initialize()
	self:SetParent(SV.Screen)
	self:SetPointToScale("BOTTOM", SV.Screen, "BOTTOM", 0, 325)
	self:SetSizeToScale(50,50)

	SV.Mentalo:Add(self, L["Special Ability Button"])
end

SV.SuperButton = SuperButton;