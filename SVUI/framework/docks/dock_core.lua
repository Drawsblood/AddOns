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
############################################################################## ]]-- 
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
local tostring      = _G.tostring;
local tonumber      = _G.tonumber;

--STRING
local string        = _G.string;
local upper         = string.upper;
local format        = string.format;
local find          = string.find;
local match         = string.match;
local gsub          = string.gsub;
--TABLE
local table 		= _G.table; 
local tinsert       = _G.tinsert;
local tremove       = _G.tremove;
local twipe 		= _G.wipe;
--MATH
local math      	= _G.math;
local random 		= math.random;
local min 			= math.min;
local floor         = math.floor
local ceil          = math.ceil
--BLIZZARD API
local GameTooltip          	= _G.GameTooltip;
local InCombatLockdown     	= _G.InCombatLockdown;
local CreateFrame          	= _G.CreateFrame;
local GetTime         		= _G.GetTime;
local GetItemCooldown       = _G.GetItemCooldown;
local GetItemCount         	= _G.GetItemCount;
local GetItemInfo          	= _G.GetItemInfo;
local GetSpellInfo         	= _G.GetSpellInfo;
local IsSpellKnown         	= _G.IsSpellKnown;
local GetProfessions       	= _G.GetProfessions;
local GetProfessionInfo    	= _G.GetProfessionInfo;
local hooksecurefunc     	= _G.hooksecurefunc;
--[[ 
########################################################## 
ADDON
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L;
--[[ 
########################################################## 
DOCKING
##########################################################
]]--
local ORDER_TEMP = {};
local ORDER_TEST = {};

local SPARK_ANIM = [[Interface\AddOns\SVUI\assets\artwork\Doodads\DOCK-SPARKS-]];

local DOCK_LOCATIONS = {
	["BottomLeft"] = {1, "LEFT", true, "ANCHOR_TOPLEFT"},
	["BottomRight"] = {-1, "RIGHT", true, "ANCHOR_TOPLEFT"},
	["TopLeft"] = {1, "LEFT", false, "ANCHOR_BOTTOMLEFT"},
	["TopRight"] = {-1, "RIGHT", false, "ANCHOR_BOTTOMLEFT"},
};

local Dock = SV:NewClass("Dock", L["Docks"]);

Dock.Border = {};
Dock.Registration = {};
Dock.Locations = {};

local DOCK_DROPDOWN_OPTIONS = {};

DOCK_DROPDOWN_OPTIONS["BottomLeft"] = { text = "To BottomLeft", func = function(button) Dock.BottomLeft.Bar:Add(button) end };
DOCK_DROPDOWN_OPTIONS["BottomRight"] = { text = "To BottomRight", func = function(button) Dock.BottomRight.Bar:Add(button) end };
DOCK_DROPDOWN_OPTIONS["TopLeft"] = { text = "To TopLeft", func = function(button) Dock.TopLeft.Bar:Add(button) end };
--DOCK_DROPDOWN_OPTIONS["TopRight"] = { text = "To TopRight", func = function(button) Dock.TopRight.Bar:Add(button) end };
--[[ 
########################################################## 
SOUND EFFECTS
##########################################################
]]--
local ButtonSound = SV.Sounds:Blend("DockButton", "Buttons", "Levers");
local ErrorSound = SV.Sounds:Blend("Malfunction", "Sparks", "Wired");
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
_G.HideSuperDocks = function(self, button)
	GameTooltip:Hide()
	if(button and IsAltKeyDown()) then
		SV:StaticPopup_Show('RESETDOCKS_CHECK')
	else
		if SV.cache.Docks.IsFaded then 
			SV.cache.Docks.IsFaded = nil;
			Dock.BottomLeft:FadeIn(0.2, Dock.BottomLeft:GetAlpha(), 1)
			Dock.BottomLeft.Bar:FadeIn(0.2, Dock.BottomLeft.Bar:GetAlpha(), 1)
			Dock.BottomRight:FadeIn(0.2, Dock.BottomRight:GetAlpha(), 1)
			Dock.BottomRight.Bar:FadeIn(0.2, Dock.BottomRight.Bar:GetAlpha(), 1)
			SV.Events:Trigger("DOCKS_FADE_IN");
			PlaySoundFile([[sound\doodad\be_scryingorb_explode.ogg]])
			--PlaySoundFile([[sound\interface\ui_etherealwindow_open.ogg]])
		else 
			SV.cache.Docks.IsFaded = true;
			Dock.BottomLeft:FadeOut(0.2, Dock.BottomLeft:GetAlpha(), 0)
			Dock.BottomLeft.Bar:FadeOut(0.2, Dock.BottomLeft.Bar:GetAlpha(), 0)
			Dock.BottomRight:FadeOut(0.2, Dock.BottomRight:GetAlpha(), 0)
			Dock.BottomRight.Bar:FadeOut(0.2, Dock.BottomRight.Bar:GetAlpha(), 0)
			SV.Events:Trigger("DOCKS_FADE_OUT");
			PlaySoundFile([[sound\doodad\be_scryingorb_explode.ogg]])
			--PlaySoundFile([[sound\interface\ui_etherealwindow_close.ogg]])
		end
	end
end

function Dock:EnterFade()
	if SV.cache.Docks.IsFaded then
		--self.BottomLeft:Show()
		self.BottomLeft:FadeIn(0.2, self.BottomLeft:GetAlpha(), 1)
		self.BottomLeft.Bar:FadeIn(0.2, self.BottomLeft.Bar:GetAlpha(), 1)
		--self.BottomRight:Show()
		self.BottomRight:FadeIn(0.2, self.BottomRight:GetAlpha(), 1)
		self.BottomRight.Bar:FadeIn(0.2, self.BottomRight.Bar:GetAlpha(), 1)
		SV.Events:Trigger("DOCKS_FADE_IN");
		--PlaySoundFile([[sound\doodad\be_scryingorb_explode.ogg]])
	end
end 

function Dock:ExitFade()
	if SV.cache.Docks.IsFaded then
		self.BottomLeft:FadeOut(2, self.BottomLeft:GetAlpha(), 0)
		self.BottomLeft.Bar:FadeOut(2, self.BottomLeft.Bar:GetAlpha(), 0)
		self.BottomRight:FadeOut(2, self.BottomRight:GetAlpha(), 0)
		self.BottomRight.Bar:FadeOut(2, self.BottomRight.Bar:GetAlpha(), 0)
		SV.Events:Trigger("DOCKS_FADE_OUT");
		--PlaySoundFile([[sound\doodad\be_scryingorb_explode.ogg]])
	end
end
--[[ 
########################################################## 
SET DOCKBAR FUNCTIONS
##########################################################
]]--
local RefreshDockWindows = function(self)
	--print('RefreshDockWindows')
	local dd = self.Data.Default
	local button = _G[dd]
	local default
	if(button) then
		default = button:GetAttribute("ownerFrame")
	end
	for name,window in pairs(self.Data.Windows) do
		if(window ~= default) then
			if(window.DockButton) then
				window.DockButton:Deactivate()
			end
		end
	end
end

local RefreshDockButtons = function(self)
	--print('RefreshDockButtons')
	for name,docklet in pairs(Dock.Registration) do
		if(docklet) then
			if(docklet.DockButton) then
				docklet.DockButton:Deactivate()
			end
			--docklet:FadeOut(0.1, 1, 0, true)
		end
	end
end

local GetDefault = function(self)
	--print('GetDefault')
	local default = self.Data.Default
	local button = _G[default]
	if(button) then
		local window = button:GetAttribute("ownerFrame")
		if window and _G[window] then
			self:Refresh()
			self.Parent.Window.FrameLink = _G[window]
			self.Parent.Window:FadeIn()
			_G[window]:Show()
			button:Activate()
		end
	end
end

local OldDefault = function(self)
	--print('OldDefault')
	local default = self.Data.OriginalDefault
	local button = _G[default]
	if(button) then
		local window = button:GetAttribute("ownerFrame")
		if window and _G[window] then
			self:Refresh()
			self.Parent.Window.FrameLink = _G[window]
			self.Parent.Window:FadeIn()
			_G[window]:Show()
			button:Activate()
		end
	end
end

local ToggleDockletWindow = function(self, button)
	--print('ToggleDockletWindow')
	local frame  = button.FrameLink
	if(frame) then
		self.Parent.Window.FrameLink = frame
		self.Parent.Window:FadeIn()
		self:Cycle()
		--frame:FadeIn()
		button:Activate()
	else
		button:Deactivate()
		self:GetDefault()
	end
end

local AlertActivate = function(self, child)
	local size = SV.db.Dock.buttonSize or 22;
	self:SetHeightToScale(size)
	self.backdrop:Show()
	child:ClearAllPoints()
	child:SetAllPoints(self)
end 

local AlertDeactivate = function(self)
	self.backdrop:Hide()
	self:SetHeightToScale(1)
end

local Docklet_OnShow = function(self)
	--print('Docklet_OnShow')
	if(self.FrameLink) then
		if(not InCombatLockdown()) then
			self.FrameLink:SetFrameLevel(10)
		end
		self.FrameLink:FadeIn()
	end 
end

local Docklet_OnHide = function(self)
	--print('Docklet_OnHide')
	if(self.FrameLink) then
		if(not InCombatLockdown()) then
			self.FrameLink:SetFrameLevel(0)
			self.FrameLink:Hide()
		else
			self.FrameLink:FadeOut(0.2, 1, 0, true)
		end
	end 
end

local DockButtonMakeDefault = function(self)
	self.Parent.Data.Default = self:GetName()
	self.Parent:GetDefault()
	if(not self.Parent.Data.OriginalDefault) then
		self.Parent.Data.OriginalDefault = self:GetName()
	end
end 

local DockButtonActivate = function(self)
	--print('DockButtonActivate')
	self:SetAttribute("isActive", true)
	self:SetPanelColor("green")
	self.Icon:SetGradient(unpack(SV.Media.gradient.green))
	if(self.FrameLink) then
		if(not InCombatLockdown()) then
			self.FrameLink:SetFrameLevel(10)
		end
		self.FrameLink:FadeIn()
	end
end 

local DockButtonDeactivate = function(self)
	--print('DockButtonDeactivate')
	if(self.FrameLink) then
		if(not InCombatLockdown()) then
			self.FrameLink:SetFrameLevel(0)
			self.FrameLink:Hide()
		else
			self.FrameLink:FadeOut(0.2, 1, 0, true)
		end
	end
	self:SetAttribute("isActive", false)
	self:SetPanelColor("default")
	self.Icon:SetGradient(unpack(SV.Media.gradient.icon))
end

local DockButton_OnEnter = function(self, ...)
	Dock:EnterFade()

	self:SetPanelColor("highlight")
	self.Icon:SetGradient(unpack(SV.Media.gradient.highlight))

	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 4)
	GameTooltip:ClearLines()
	local tipText = self:GetAttribute("tipText")
	GameTooltip:AddDoubleLine("[Left-Click]", tipText, 0, 1, 0, 1, 1, 1)
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine("[Alt + Click]", "Reset Dock Buttons", 0, 0.5, 1, 0.5, 1, 0.5)
	GameTooltip:Show()
end

local DockletButton_OnEnter = function(self, ...)
	Dock:EnterFade()

	self:SetPanelColor("highlight")
	self.Icon:SetGradient(unpack(SV.Media.gradient.highlight))

	local tipAnchor = self:GetAttribute("tipAnchor")
	GameTooltip:SetOwner(self, tipAnchor, 0, 4)
	GameTooltip:ClearLines()
	if(self.CustomTooltip) then
		self:CustomTooltip()
	else
		local tipText = self:GetAttribute("tipText")
		GameTooltip:AddDoubleLine("[Left-Click]", tipText, 0, 1, 0, 1, 1, 1)
	end
	if(self:GetAttribute("hasDropDown") and self.GetMenuList) then
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine("[Alt + Click]", "Docking Options", 0, 0.5, 1, 0.5, 1, 0.5)
	end
	GameTooltip:Show()
end 

local DockletButton_OnLeave = function(self, ...)
	Dock:ExitFade()

	if(self:GetAttribute("isActive")) then
		self:SetPanelColor("green")
		self.Icon:SetGradient(unpack(SV.Media.gradient.green))
	else
		self:SetPanelColor("default")
		self.Icon:SetGradient(unpack(SV.Media.gradient.icon))
	end

	GameTooltip:Hide()
end

local DockletButton_OnClick = function(self, button)
	--if InCombatLockdown() then return end
	self.Sparks:SetTexture(SPARK_ANIM .. random(1,3))
	self.Sparks.anim:Play()
	ButtonSound()
	if(IsAltKeyDown() and (not InCombatLockdown()) and self:GetAttribute("hasDropDown") and self.GetMenuList) then
		local list = self:GetMenuList();
		SV.Dropdown:Open(self, list);
	else
		if self.PostClickFunction then
			self:PostClickFunction()
		else
			self.Parent:Toggle(self)
		end
	end
end

local DockletButton_OnPostClick = function(self, button)
	if InCombatLockdown() then 
		ErrorSound()
		return 
	end
	ButtonSound()
	if(IsAltKeyDown() and self:GetAttribute("hasDropDown") and self.GetMenuList) then
		local list = self:GetMenuList();
		SV.Dropdown:Open(self, list);
	end
end

local DockletEnable = function(self)
	local dock = self.Parent;
	if(self.DockButton) then dock.Bar:Add(self.DockButton) end
end

local DockletDisable = function(self)
	local dock = self.Parent;
	if(self.DockButton) then dock.Bar:Remove(self.DockButton) end
end

local DockletButtonSize = function(self)
	local size = self.Bar.ToolBar:GetHeight() or 30;
	return size;
end

local DockletRelocate = function(self, location)
	local newParent = Dock[location];

	if(not newParent) then return end

	if(self.DockButton) then
		newParent.Bar:Add(self.DockButton) 
	end
	
	if(self.Bar) then 
		local height = newParent.Bar.ToolBar:GetHeight();
		local mod = newParent.Bar.Data[1];
		local barAnchor = newParent.Bar.Data[2];
		local barReverse = SV:GetReversePoint(barAnchor);
		local spacing = SV.db.Dock.buttonSpacing;

		self.Bar:ClearAllPoints();
		self.Bar:SetPointToScale(barAnchor, newParent.Bar.ToolBar, barReverse, (spacing * mod), 0)
	end
end

local GetDockablePositions = function(self)
	local button = self;
	local name = button:GetName();
	local currentLocation = Dock.Locations[name];
	local t;

	if(self.GetPreMenuList) then
		t = self:GetPreMenuList();
		tinsert(t, { title = "Move This", divider = true })
	else
		t = {{ title = "Move This", divider = true }};
	end

	for location,option in pairs(DOCK_DROPDOWN_OPTIONS) do
		if(currentLocation ~= location) then
		    tinsert(t, option);
		end
	end

	tinsert(t, { title = "Re-Order", divider = true });

	for i=1, #button.Parent.Data.Order do
		if(i ~= button.OrderIndex) then
			local positionText = ("Position #%d"):format(i);
		    tinsert(t, { text = positionText, func = function() button.Parent:ChangeOrder(button, i) end });
		end
	end

	return t;
end

local ChangeBarOrder = function(self, button, targetIndex)
	local targetName = button:GetName();
	local currentIndex = button.OrderIndex;
	wipe(ORDER_TEST);
	wipe(ORDER_TEMP);
	for i = 1, #self.Data.Order do
		local nextName = self.Data.Order[i];
		if(i == targetIndex) then
			if(currentIndex > targetIndex) then
				tinsert(ORDER_TEMP, targetName)
				tinsert(ORDER_TEMP, nextName)
			else
				tinsert(ORDER_TEMP, nextName)
				tinsert(ORDER_TEMP, targetName)
			end
		elseif(targetName ~= nextName) then
			tinsert(ORDER_TEMP, nextName)
		end
	end

	wipe(self.Data.Order);
	local safeIndex = 1;
	for i = 1, #ORDER_TEMP do
		local nextName = ORDER_TEMP[i];
		local nextButton = self.Data.Buttons[nextName];
		if(nextButton and (not ORDER_TEST[nextName])) then
			ORDER_TEST[nextName] = true
			tinsert(self.Data.Order, nextName);
			nextButton.OrderIndex = safeIndex;
			safeIndex = safeIndex + 1;
		end
	end

	self:Update()
end

local RefreshBarOrder = function(self)
	wipe(ORDER_TEST);
	wipe(ORDER_TEMP);
	for i = 1, #self.Data.Order do
		local nextName = self.Data.Order[i];
		tinsert(ORDER_TEMP, nextName)
	end
	wipe(self.Data.Order);
	local safeIndex = 1;
	for i = 1, #ORDER_TEMP do
		local nextName = ORDER_TEMP[i];
		local nextButton = self.Data.Buttons[nextName];
		if(nextButton and (not ORDER_TEST[nextName])) then
			ORDER_TEST[nextName] = true
			tinsert(self.Data.Order, nextName);
			nextButton.OrderIndex = safeIndex;
			safeIndex = safeIndex + 1;
		end
	end
end

local CheckBarOrder = function(self, targetName)
	local found = false;
	for i = 1, #self.Data.Order do
		if(self.Data.Order[i] == targetName) then
			found = true;
		end
	end
	if(not found) then
		tinsert(self.Data.Order, targetName);
		self:UpdateOrder();
	end
end

local RefreshBarLayout = function(self)
	local anchor = upper(self.Data.Location)
	local mod = self.Data.Modifier
	local size = self.ToolBar:GetHeight();
	local count = #self.Data.Order;
	local offset = 1;
	local safeIndex = 1;
	for i = 1, count do
		local nextName = self.Data.Order[i];
		local nextButton = self.Data.Buttons[nextName];
		if(nextButton) then
			offset = (safeIndex - 1) * (size + 6) + 6
			nextButton:ClearAllPoints();
			nextButton:SetSize(size, size);
			nextButton:SetPoint(anchor, self.ToolBar, anchor, (offset * mod), 0);
			if(not nextButton:IsShown()) then
				nextButton:Show();
			end
			nextButton.OrderIndex = safeIndex;
			safeIndex = safeIndex + 1;
		end
	end

	self.ToolBar:SetWidth(offset + size);

	if(SV.Dropdown:IsShown()) then
		ToggleFrame(SV.Dropdown)
	end
end

local AddToDock = function(self, button)
	if not button then return end
	local name = button:GetName();
	if(self.Data.Buttons[name]) then return end

	local registeredLocation = Dock.Locations[name]
	local currentLocation = self.Data.Location

	if(registeredLocation) then
		if(registeredLocation ~= currentLocation) then
			if(Dock[registeredLocation].Bar.Data.Buttons[name]) then
				Dock[registeredLocation].Bar:Remove(button);
			else
				Dock[registeredLocation].Bar:Add(button);
				return
			end
		end
	end

	self.Data.Buttons[name] = button;
	self:CheckOrder(name);
	
	Dock.Locations[name] = currentLocation;
	button.Parent = self;
	button:SetParent(self.ToolBar);

	if(button.FrameLink) then
		local frame = button.FrameLink
		local frameName = frame:GetName()
		self.Data.Windows[frameName] = frame;
		Dock.Locations[frameName] = currentLocation;
		frame:Show()
		frame:ClearAllPoints()
		frame:SetParent(self.Parent.Window)
		frame:SetAllPointsIn(self.Parent.Window)
		frame.Parent = self.Parent
	end

	-- self:UpdateOrder()
	self:Update()
end

local RemoveFromDock = function(self, button)
	if not button then return end 
	local name = button:GetName();
	local registeredLocation = Dock.Locations[name];
	local currentLocation = self.Data.Location

	if(registeredLocation and (registeredLocation == currentLocation)) then 
		Dock.Locations[name] = nil;
	end

	for i = 1, #self.Data.Order do
		local nextName = self.Data.Order[i];
		if(nextName == name) then
			tremove(self.Data.Order, i);
			break;
		end
	end

	if(not self.Data.Buttons[name]) then return end

	button:Hide()
	if(button.FrameLink) then
		local frameName = button.FrameLink:GetName()
		Dock.Locations[frameName] = nil;
		button.FrameLink:FadeOut(0.2, 1, 0, true)
		self.Data.Windows[frameName] = nil;
	end

	button.OrderIndex = 0;
	self.Data.Buttons[name] = nil;
	self:UpdateOrder()
	self:Update()
end

local ActivateDockletButton = function(self, button, clickFunction, tipFunction, isAction)
	button.Activate = DockButtonActivate
	button.Deactivate = DockButtonDeactivate
	button.MakeDefault = DockButtonMakeDefault
	button.GetMenuList = GetDockablePositions

	if(tipFunction and type(tipFunction) == "function") then
		button.CustomTooltip = tipFunction
	end

	button.Parent = self
	button:SetPanelColor("default")
	button.Icon:SetGradient(unpack(SV.Media.gradient.icon))
	button:SetScript("OnEnter", DockletButton_OnEnter)
	button:SetScript("OnLeave", DockletButton_OnLeave)
	if(not isAction) then
		button:SetScript("OnClick", DockletButton_OnClick)
	else
		button:SetScript("PostClick", DockletButton_OnPostClick)
	end

	if(clickFunction and type(clickFunction) == "function") then
		button.PostClickFunction = clickFunction
	end
end

local CreateBasicToolButton = function(self, displayName, texture, onclick, globalName, tipFunction, primaryTemplate)
	local dockIcon = texture or [[Interface\AddOns\SVUI\assets\artwork\Icons\SVUI-ICON]];
	local size = self.ToolBar:GetHeight();
	local template = "SVUI_DockletButtonTemplate"

	if(primaryTemplate) then
		template = primaryTemplate .. ", SVUI_DockletButtonTemplate"
	end

	local button = _G[globalName .. "DockletButton"] or CreateFrame("Button", globalName, self.ToolBar, template)

	button:ClearAllPoints()
	button:SetSize(size, size)
	button:SetStylePanel("Framed") 
	button.Icon:SetTexture(dockIcon)
	button:SetAttribute("tipText", displayName)
	button:SetAttribute("tipAnchor", self.Data.TipAnchor)
    button:SetAttribute("ownerFrame", globalName)

    button.OrderIndex = 0;

    local sparkSize = size * 5;
    local sparkOffset = size * 0.5;

    local sparks = button.__border:CreateTexture(nil, "OVERLAY", nil, 2)
	sparks:SetSizeToScale(sparkSize, sparkSize)
	sparks:SetPoint("CENTER", button, "BOTTOMRIGHT", -sparkOffset, 4)
	sparks:SetTexture(SPARK_ANIM .. 1)
	sparks:SetVertexColor(0.7, 0.6, 0.5)
	sparks:SetBlendMode("ADD")
	sparks:SetAlpha(0)

	SV.Animate:Sprite8(sparks, 0.08, 2, false, true)

	button.Sparks = sparks;

    self:Add(button)
	self:Initialize(button, onclick, tipFunction, primaryTemplate)
	
	return button
end
--[[ 
########################################################## 
DOCKS
##########################################################
]]--
for location, settings in pairs(DOCK_LOCATIONS) do
	Dock[location] = _G["SVUI_Dock" .. location];
	Dock[location].Bar = _G["SVUI_DockBar" .. location];

	Dock[location].Alert.Activate = AlertActivate;
	Dock[location].Alert.Deactivate = AlertDeactivate;

	Dock[location].Bar.Parent = Dock[location];
	Dock[location].Bar.Refresh = RefreshDockButtons;
	Dock[location].Bar.Cycle = RefreshDockWindows;
	Dock[location].Bar.GetDefault = GetDefault;
	Dock[location].Bar.UnsetDefault = OldDefault;
	Dock[location].Bar.Toggle = ToggleDockletWindow;
	Dock[location].Bar.Update = RefreshBarLayout;
	Dock[location].Bar.UpdateOrder = RefreshBarOrder;
	Dock[location].Bar.ChangeOrder = ChangeBarOrder;
	Dock[location].Bar.CheckOrder = CheckBarOrder;
	Dock[location].Bar.Add = AddToDock;
	Dock[location].Bar.Remove = RemoveFromDock;
	Dock[location].Bar.Initialize = ActivateDockletButton;
	Dock[location].Bar.Create = CreateBasicToolButton;
	Dock[location].Bar.Data = {
		Location = location,
		Anchor = settings[2],
		Modifier = settings[1],
		TipAnchor = settings[4],
		Default = "",
		Buttons = {},
		Windows = {},
		Order = {},
	};
end

function Dock:SetSuperDockStyle(dock, isBottom)
	if dock.backdrop then return end

	local backdrop = CreateFrame("Frame", nil, dock)
	backdrop:SetAllPoints(dock)
	backdrop:SetFrameStrata("BACKGROUND")

	backdrop.bg = backdrop:CreateTexture(nil, "BORDER")
	backdrop.bg:SetAllPointsIn(backdrop)
	backdrop.bg:SetTexture(1, 1, 1, 1)
	
	if(isBottom) then
		backdrop.bg:SetGradientAlpha("VERTICAL", 0, 0, 0, 0.8, 0, 0, 0, 0)
	else
		backdrop.bg:SetGradientAlpha("VERTICAL", 0, 0, 0, 0, 0, 0, 0, 0.8)
	end

	backdrop.left = backdrop:CreateTexture(nil, "OVERLAY")
	backdrop.left:SetTexture(1, 1, 1, 1)
	backdrop.left:SetPointToScale("TOPLEFT", 1, -1)
	backdrop.left:SetPointToScale("BOTTOMLEFT", -1, -1)
	backdrop.left:SetWidthToScale(4)
	if(isBottom) then
		backdrop.left:SetGradientAlpha("VERTICAL", 0, 0, 0, 1, 0, 0, 0, 0)
	else
		backdrop.left:SetGradientAlpha("VERTICAL", 0, 0, 0, 0, 0, 0, 0, 1)
	end

	backdrop.right = backdrop:CreateTexture(nil, "OVERLAY")
	backdrop.right:SetTexture(1, 1, 1, 1)
	backdrop.right:SetPointToScale("TOPRIGHT", -1, -1)
	backdrop.right:SetPointToScale("BOTTOMRIGHT", -1, -1)
	backdrop.right:SetWidthToScale(4)
	if(isBottom) then
		backdrop.right:SetGradientAlpha("VERTICAL", 0, 0, 0, 1, 0, 0, 0, 0)
	else
		backdrop.right:SetGradientAlpha("VERTICAL", 0, 0, 0, 0, 0, 0, 0, 1)
	end

	backdrop.bottom = backdrop:CreateTexture(nil, "OVERLAY")
	backdrop.bottom:SetPointToScale("BOTTOMLEFT", 1, -1)
	backdrop.bottom:SetPointToScale("BOTTOMRIGHT", -1, -1)
	if(isBottom) then
		backdrop.bottom:SetTexture(0, 0, 0, 1)
		backdrop.bottom:SetHeightToScale(4)
	else
		backdrop.bottom:SetTexture(0, 0, 0, 0)
		backdrop.bottom:SetAlpha(0)
		backdrop.bottom:SetHeightToScale(1)
	end

	backdrop.top = backdrop:CreateTexture(nil, "OVERLAY")
	backdrop.top:SetPointToScale("TOPLEFT", 1, -1)
	backdrop.top:SetPointToScale("TOPRIGHT", -1, 1)
	if(isBottom) then
		backdrop.top:SetTexture(0, 0, 0, 0)
		backdrop.top:SetAlpha(0)
		backdrop.top:SetHeightToScale(1)
	else
		backdrop.top:SetTexture(0, 0, 0, 1)
		backdrop.top:SetHeightToScale(4)
	end

	return backdrop 
end

local function InitDockButton(button)
	button:SetPanelColor("default")
	button.Icon:SetGradient(unpack(SV.Media.gradient.icon))
	button:SetScript("OnEnter", DockButton_OnEnter)
	button:SetScript("OnLeave", DockletButton_OnLeave)
	button:SetScript("OnClick", HideSuperDocks)
end

local function BorderColorUpdates()
	Dock.Border.Top:SetBackdropColor(unpack(SV.Media.color.specialdark))
	Dock.Border.Top:SetBackdropBorderColor(0,0,0,1)
	Dock.Border.Bottom:SetBackdropColor(unpack(SV.Media.color.default))
	Dock.Border.Bottom:SetBackdropBorderColor(0,0,0,1)
end

SV.Events:On("SVUI_COLORS_UPDATED", "BorderColorUpdates", BorderColorUpdates)
--[[ 
########################################################## 
EXTERNALLY ACCESSIBLE METHODS
##########################################################
]]--
function Dock:SetDockButton(location, displayName, texture, onclick, globalName, tipFunction, primaryTemplate)
	if(self.Locations[globalName]) then
		location = self.Locations[globalName];
	else
		self.Locations[globalName] = location;
	end
	local parent = self[location]
	return parent.Bar:Create(displayName, texture, onclick, globalName, tipFunction, primaryTemplate)
end

function Dock:GetDimensions(location)
	local width, height;

	if(location:find("Left")) then
		width = SV.db.Dock.dockLeftWidth;
		height = SV.db.Dock.dockLeftHeight;
	else
		width = SV.db.Dock.dockRightWidth;
		height = SV.db.Dock.dockRightHeight;
	end

	return width, height;
end

function Dock:NewDocklet(location, globalName, readableName, texture, onclick)
	if(self.Registration[globalName]) then return end;
	
	if(self.Locations[globalName]) then
		location = self.Locations[globalName];
	else
		self.Locations[globalName] = location;
	end

	local newParent = self[location];
	if(not newParent) then return end
	local frame = _G[globalName] or CreateFrame("Frame", globalName, UIParent, "SVUI_DockletWindowTemplate");
	frame:SetParent(newParent.Window);
	frame:SetSize(newParent.Window:GetSize());
	frame:SetAllPoints(newParent.Window);
	frame:SetFrameStrata("BACKGROUND");
	frame.Parent = newParent
	frame.Disable = DockletDisable;
	frame.Enable = DockletEnable;
	frame.Relocate = DockletRelocate;
	frame.GetButtonSize = DockletButtonSize;

	newParent.Bar.Data.Windows[globalName] = frame;

	local buttonName = ("%sButton"):format(globalName)
	frame.DockButton = newParent.Bar:Create(readableName, texture, onclick, buttonName);
	frame.DockButton.FrameLink = frame
	self.Registration[globalName] = frame;
	frame:SetAlpha(0)
	return frame
end

function Dock:NewAdvancedDocklet(location, globalName)
	if(self.Registration[globalName]) then return end;

	if(self.Locations[globalName]) then
		location = self.Locations[globalName];
	else
		self.Locations[globalName] = location;
	end

	local newParent = self[location];
	if(not newParent) then return end

	local frame = CreateFrame("Frame", globalName, UIParent, "SVUI_DockletWindowTemplate");
	frame:SetParent(newParent.Window);
	frame:SetSize(newParent.Window:GetSize());
	frame:SetAllPoints(newParent.Window);
	frame:SetFrameStrata("BACKGROUND");
	frame.Parent = newParent
	frame.Disable = DockletDisable;
	frame.Enable = DockletEnable;
	frame.Relocate = DockletRelocate;
	frame.GetButtonSize = DockletButtonSize;

	newParent.Bar.Data.Windows[globalName] = frame;

	local height = newParent.Bar.ToolBar:GetHeight();
	local mod = newParent.Bar.Data.Modifier;
	local barAnchor = newParent.Bar.Data.Anchor;
	local barReverse = SV:GetReversePoint(barAnchor);
	local spacing = SV.db.Dock.buttonSpacing;

	frame.Bar = CreateFrame("Frame", nil, newParent);
	frame.Bar:SetSize(1, height);
	frame.Bar:SetPointToScale(barAnchor, newParent.Bar.ToolBar, barReverse, (spacing * mod), 0)
	SV.Mentalo:Add(frame.Bar, globalName .. " Dock Bar");

	self.Registration[globalName] = frame;
	return frame
end
--[[ 
########################################################## 
BUILD/UPDATE
##########################################################
]]--
function Dock:UpdateDockBackdrops()
	if SV.db.Dock.rightDockBackdrop then
		Dock.BottomRight.backdrop:Show()
		Dock.BottomRight.backdrop:ClearAllPoints()
		Dock.BottomRight.backdrop:SetAllPointsOut(Dock.BottomRight.Window, 4, 4)

		Dock.BottomRight.Alert.backdrop:ClearAllPoints()
		Dock.BottomRight.Alert.backdrop:SetAllPointsOut(Dock.BottomRight.Alert, 4, 4)
	else
		Dock.BottomRight.backdrop:Hide()
	end
	if SV.db.Dock.leftDockBackdrop then
		Dock.BottomLeft.backdrop:Show()
		Dock.BottomLeft.backdrop:ClearAllPoints()
		Dock.BottomLeft.backdrop:SetAllPointsOut(Dock.BottomLeft.Window, 4, 4)

		Dock.BottomLeft.Alert.backdrop:ClearAllPoints()
		Dock.BottomLeft.Alert.backdrop:SetAllPointsOut(Dock.BottomLeft.Alert, 4, 4)
	else
		Dock.BottomLeft.backdrop:Hide()
	end
end 

function Dock:BottomBorderVisibility()
	if SV.db.Dock.bottomPanel then 
		self.Border.Bottom:Show()
	else 
		self.Border.Bottom:Hide()
	end 
end 

function Dock:TopBorderVisibility()
	if SV.db.Dock.topPanel then 
		self.Border.Top:Show()
	else 
		self.Border.Top:Hide()
	end 
end

function Dock:ResetAllButtons()
	wipe(SV.cache.Docks.Order)
	wipe(SV.cache.Docks.Locations)
	ReloadUI()
end

function Dock:UpdateAllDocks()
	for location, settings in pairs(DOCK_LOCATIONS) do
		local dock = self[location];
		dock.Bar:Cycle()
		dock.Bar:GetDefault()
	end
end

function Dock:Refresh()
	local buttonsize = SV.db.Dock.buttonSize;
	local spacing = SV.db.Dock.buttonSpacing;

	for location, settings in pairs(DOCK_LOCATIONS) do
		if(location ~= "TopRight") then
			local width, height = self:GetDimensions(location);
			local dock = self[location];

			dock.Bar:SetSize(width, buttonsize)
		    dock.Bar.ToolBar:SetHeight(buttonsize)
		    dock:SetSize(width, height)
		    dock.Alert:SetSize(width, 1)
		    dock.Window:SetSize(width, height)

		    if(dock.Bar.Button) then
		    	dock.Bar.Button:SetSize(buttonsize, buttonsize)
		    end

		    dock.Bar:Update()
		end
	end

	self:BottomBorderVisibility();
	self:TopBorderVisibility();
	self:UpdateDockBackdrops();

	self:RefreshStats();

	SV.Events:Trigger("DOCKS_UPDATED");
end 

function Dock:Initialize()
	SV.cache.Docks = SV.cache.Docks	or {}

	if(not SV.cache.Docks.IsFaded) then 
		SV.cache.Docks.IsFaded = false
	end

	if(not SV.cache.Docks.Order) then 
		SV.cache.Docks.Order = {}
	end

	if(not SV.cache.Docks.Locations) then 
		SV.cache.Docks.Locations = {}
	end

	self.Locations = SV.cache.Docks.Locations;

	local buttonsize = SV.db.Dock.buttonSize;
	local spacing = SV.db.Dock.buttonSpacing;
	local texture = [[Interface\AddOns\SVUI\assets\artwork\Template\BUTTON]];

	-- [[ TOP AND BOTTOM BORDERS ]] --

	self.Border.Top = CreateFrame("Frame", "SVUITopBorder", UIParent)
	self.Border.Top:SetPointToScale("TOPLEFT", SV.Screen, "TOPLEFT", -1, 1)
	self.Border.Top:SetPointToScale("TOPRIGHT", SV.Screen, "TOPRIGHT", 1, 1)
	self.Border.Top:SetHeightToScale(14)
	self.Border.Top:SetBackdrop({
		bgFile = texture, 
		edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
		tile = false, 
		tileSize = 0, 
		edgeSize = 1, 
		insets = {left = 0, right = 0, top = 0, bottom = 0}
	})
	self.Border.Top:SetBackdropColor(unpack(SV.Media.color.specialdark))
	self.Border.Top:SetBackdropBorderColor(0,0,0,1)
	self.Border.Top:SetFrameLevel(0)
	self.Border.Top:SetFrameStrata('BACKGROUND')
	self.Border.Top:SetScript("OnShow", function(this)
		this:SetFrameLevel(0)
		this:SetFrameStrata('BACKGROUND')
	end)
	self:TopBorderVisibility()

	self.Border.Bottom = CreateFrame("Frame", "SVUIBottomBorder", UIParent)
	self.Border.Bottom:SetPointToScale("BOTTOMLEFT", SV.Screen, "BOTTOMLEFT", -1, -1)
	self.Border.Bottom:SetPointToScale("BOTTOMRIGHT", SV.Screen, "BOTTOMRIGHT", 1, -1)
	self.Border.Bottom:SetHeightToScale(14)
	self.Border.Bottom:SetBackdrop({
		bgFile = texture, 
		edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
		tile = false, 
		tileSize = 0, 
		edgeSize = 1, 
		insets = {left = 0, right = 0, top = 0, bottom = 0}
	})
	self.Border.Bottom:SetBackdropColor(unpack(SV.Media.color.default))
	self.Border.Bottom:SetBackdropBorderColor(0,0,0,1)
	self.Border.Bottom:SetFrameLevel(0)
	self.Border.Bottom:SetFrameStrata('BACKGROUND')
	self.Border.Bottom:SetScript("OnShow", function(this)
		this:SetFrameLevel(0)
		this:SetFrameStrata('BACKGROUND')
	end)
	self:BottomBorderVisibility()

	for location, settings in pairs(DOCK_LOCATIONS) do
		local width, height = self:GetDimensions(location);
		local dock = self[location];
		local mod = settings[1];
		local anchor = upper(location);
		local reverse = SV:GetReversePoint(anchor);
		local barAnchor = settings[2];
		local barReverse = SV:GetReversePoint(barAnchor);
		local isBottom = settings[3];
		local vertMod = isBottom and 1 or -1

		dock.Bar:SetParent(SV.Screen)
		dock.Bar:ClearAllPoints()
		dock.Bar:SetSize(width, buttonsize)
		dock.Bar:SetPoint(anchor, SV.Screen, anchor, (2 * mod), (2 * vertMod))

		if(not SV.cache.Docks.Order[location]) then 
			SV.cache.Docks.Order[location] = {}
		end

		dock.Bar.Data.Order = SV.cache.Docks.Order[location];

		dock.Bar.ToolBar:ClearAllPoints()

		if(dock.Bar.Button) then
	    	dock.Bar.Button:SetSize(buttonsize, buttonsize)
	    	dock.Bar.Button:SetStylePanel("Framed") 
	    	dock.Bar.ToolBar:SetSize(1, buttonsize)
	    	dock.Bar.ToolBar:SetPointToScale(barAnchor, dock.Bar.Button, barReverse, (spacing * mod), 0)
	    	InitDockButton(dock.Bar.Button)
	    else
	    	dock.Bar.ToolBar:SetSize(1, buttonsize)
	    	dock.Bar.ToolBar:SetPointToScale(barAnchor, dock.Bar, barAnchor, 0, 0)
	    end

	    dock:SetParent(SV.Screen)
	    dock:ClearAllPoints()
	    dock:SetPoint(anchor, dock.Bar, reverse, 0, (12 * vertMod))
	    dock:SetSize(width, height)
	    dock:SetAttribute("buttonSize", buttonsize)
	    dock:SetAttribute("spacingSize", spacing)

	    dock.Alert:ClearAllPoints()
	    dock.Alert:SetSize(width, 1)
	    dock.Alert:SetPoint(anchor, dock, anchor, 0, 0)

	    dock.Window:ClearAllPoints()
	    dock.Window:SetSize(width, height)
	    dock.Window:SetPoint(anchor, dock.Alert, reverse, 0, (4 * vertMod))

	    SV.Mentalo:Add(dock.Bar, location .. " Dock ToolBar");

		if(isBottom) then
			dock.backdrop = self:SetSuperDockStyle(dock.Window, isBottom)
			dock.Alert.backdrop = self:SetSuperDockStyle(dock.Alert, isBottom)
			dock.Alert.backdrop:Hide()
		end
		
		SV.Mentalo:Add(dock, location .. " Dock Window")
	end

	if SV.cache.Docks.IsFaded then Dock.BottomLeft:Hide() Dock.BottomRight:Hide() end

	SV:AddToDisplayAudit(self.BottomRight.Window)
	SV:AddToDisplayAudit(self.TopLeft)
	SV:AddToDisplayAudit(self.TopRight)

	if not InCombatLockdown() then 
		self.BottomLeft.Bar:Refresh()
		self.BottomRight.Bar:Refresh()
		self.TopLeft.Bar:Refresh()
		self.TopRight.Bar:Refresh()
	end

	self:UpdateDockBackdrops()

	self:InitializeStats()
end