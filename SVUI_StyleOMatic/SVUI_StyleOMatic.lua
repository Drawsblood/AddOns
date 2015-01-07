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
local type 		= _G.type;
local tostring 	= _G.tostring;
local print 	= _G.print;
local pcall 	= _G.pcall;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local format,find = string.format, string.find;
--[[ MATH METHODS ]]--
local floor = math.floor;
--[[ TABLE METHODS ]]--
local twipe, tcopy = table.wipe, table.copy;
local IsAddOnLoaded = _G.IsAddOnLoaded;
local LoadAddOn = _G.LoadAddOn;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local PLUGIN = select(2, ...)
local Schema = PLUGIN.Schema;
local VERSION = PLUGIN.Version;

local SV = _G.SVUI
local L = SV.L
local NewHook = hooksecurefunc;
--[[ 
########################################################## 
CORE DATA
##########################################################
]]--
PLUGIN.AddOnQueue = {};
PLUGIN.AddOnEvents = {};
PLUGIN.CustomQueue = {};
PLUGIN.EventListeners = {};
PLUGIN.OnLoadAddons = {};
PLUGIN.StyledAddons = {};
PLUGIN.Debugging = false;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
local charming = {"Spiffy", "Pimped Out", "Fancy", "Awesome", "Bad Ass", "Sparkly", "Gorgeous", "Handsome", "Shiny"}
local errorMessage = '%s: |cffff0000There was an error in the|r |cff0affff%s|r |cffff0000skin|r. |cffFF0000[[|r%s|cffFF0000]]|r'
local styleMessage = '|cff00FF77%s|r Is Now %s!'

local function SendAddonMessage(msg, prefix)
	if(type(msg) == "table") then 
        msg = tostring(msg) 
    end

    if(not msg) then return end

    if(prefix) then
    	local outbound = ("%s %s"):format(prefix, msg);
    	print(outbound)
    else
    	print(msg)
    end
end

function PLUGIN:AddonMessage(msg) 
    local outbound = ("|cffFF2F00%s:|r"):format("Style-O-Matic")
    SendAddonMessage(msg, outbound) 
end

function PLUGIN:LoadAlert(MainText, Function)
	self.Alert.Text:SetText(MainText)
	self.Alert.Accept:SetScript('OnClick', Function)
	self.Alert:Show()
end

function PLUGIN:Style(style, fn, ...)
	local pass, catch = pcall(fn, ...)
	if(catch and self.Debugging) then
		SV:Debugger(errorMessage:format(VERSION, style, catch))
		return
	end
	if(pass and (not style:find("Blizzard")) and not self.StyledAddons[style]) then
		self.StyledAddons[style] = true
		if(SV.db.general.loginmessage) then
			local verb = charming[math.random(1,#charming)]
			self:AddonMessage(styleMessage:format(style, verb))
		end
		self.AddOnQueue[style] = nil
	end
	self.Debugging = false
end

function PLUGIN:IsAddonReady(addon, ...)
	if not self.db.addons then return end
	for i = 1, select('#', ...) do
		local a = select(i, ...)
		if not a then break end
		if not IsAddOnLoaded(a) then return false end
	end

	return self.db.addons[addon]
end

function PLUGIN:SaveAddonStyle(addon, fn, force, passive, ...)
	self:DefineEventFunction("PLAYER_ENTERING_WORLD", addon)
	if(passive) then
		self:DefineEventFunction("ADDON_LOADED", addon)
	end
	for i=1, select("#",...) do 
		local event = select(i,...)
		if(event) then
			self:DefineEventFunction(event, addon)
		end  
	end
	if(self.defaults.addons and self.defaults.addons[addon] == nil) then
		self.defaults.addons[addon] = true
	end

	if force then
		fn()
	else
		self.AddOnQueue[addon] = fn
	end
end 

function PLUGIN:SaveBlizzardStyle(addon, fn, force)
	if force then 
		if(not IsAddOnLoaded(addon)) then
			LoadAddOn(addon)
		end
		fn()
	else
		self.OnLoadAddons[addon] = fn
	end
end 

function PLUGIN:SaveCustomStyle(fn)
	tinsert(PLUGIN.CustomQueue, fn)
end 

function PLUGIN:DefineEventFunction(addonEvent, addon)
	if(not addon) then return end
	if(not self.EventListeners[addonEvent]) then
		self.EventListeners[addonEvent] = {}
	end
	self.EventListeners[addonEvent][addon] = true
	if(not self[addonEvent]) then
		self[addonEvent] = function(self, event, ...)
			for name,fn in pairs(self.AddOnQueue) do 
				if self:IsAddonReady(name) and self.EventListeners[event] and self.EventListeners[event][name] then
					self:Style(name, fn, event, ...)
				end 
			end 
		end 
		self:RegisterEvent(addonEvent);
	end
end

function PLUGIN:SafeEventRemoval(addon, event)
	if not self.EventListeners[event] then return end 
	if not self.EventListeners[event][addon] then return end 
	self.EventListeners[event][addon] = nil;
	local defined = false;
	for name,_ in pairs(self.EventListeners[event]) do 
		if name then
			defined = true;
			break 
		end 
	end 
	if not defined then 
		self:UnregisterEvent(event) 
	end 
end

function PLUGIN:PLAYER_ENTERING_WORLD(event, ...)
	for addonName,fn in pairs(self.OnLoadAddons) do
		if(self.db.blizzard[addonName] == nil) then
			self.db.blizzard[addonName] = true
		end
		if(IsAddOnLoaded(addonName) and (self.db.blizzard[addonName] or self.db.addons[addonName])) then 
			self:Style(addonName, fn, event, ...)
			self.OnLoadAddons[addonName] = nil
		end 
	end

	for _,fn in pairs(self.CustomQueue)do 
		fn(event, ...)
	end

	twipe(self.CustomQueue)

	local listener = self.EventListeners[event]
	for addonName,fn in pairs(self.AddOnQueue)do
		if(not SV.Options.args.plugins.args.pluginOptions.args[Schema].args["addons"].args[addonName]) then
			SV.Options.args.plugins.args.pluginOptions.args[Schema].args["addons"].args[addonName] = {
				type = "toggle",
				name = addonName,
				desc = L["Addon Styling"],
				get = function(key) return PLUGIN:IsAddonReady(key[#key]) end,
				set = function(key,value) PLUGIN:ChangeDBVar(value, key[#key], "addons"); SV:StaticPopup_Show("RL_CLIENT") end,
			}
		end
		if(self.db.addons[addonName] == nil) then
			self.db.addons[addonName] = true
		end
		if(listener[addonName] and self:IsAddonReady(addonName)) then
			self:Style(addonName, fn, event, ...)
		end 
	end
end

function PLUGIN:ADDON_LOADED(event, addon)
	--print(addon)
	for name, fn in pairs(self.OnLoadAddons) do
		if(addon:find(name)) then
			self:Style(name, fn, event, addon)
			self.OnLoadAddons[name] = nil
		end
	end

	local listener = self.EventListeners[event]
	if(listener) then
		for name, fn in pairs(self.AddOnQueue) do 
			if(listener[name] and self:IsAddonReady(name)) then
				self:Style(name, fn, event, addon)
			end 
		end
	end
end
--[[ 
########################################################## 
OPTIONS CREATION
##########################################################
]]--
function PLUGIN:FetchDocklets()
	local dock1 = self.cache.Docks[1] or "None";
	local dock2 = self.cache.Docks[2] or "None";
	local enabled1 = (dock1 ~= "None")
	local enabled2 = ((dock2 ~= "None") and (dock2 ~= dock1))
	return dock1, dock2, enabled1, enabled2
end

function PLUGIN:ValidateDocklet(addon)
	local dock1,dock2,enabled1,enabled2 = self:FetchDocklets();
	local valid = false;

	if(dock1:find(addon) or dock2:find(addon)) then
		valid = true 
	end

	return valid,enabled1,enabled2
end

function PLUGIN:DockletReady(addon, dock)
	if((not addon) or (not dock)) then return false end
	if(dock:find(addon) and IsAddOnLoaded(addon)) then
		return true 
	end
	return false
end

function PLUGIN:RegisterAddonDocklets()
	local dock1,dock2,enabled1,enabled2 = self:FetchDocklets();
  	local tipLeft, tipRight = "", "";
  	local active1, active2 = false, false;

  	self.Docklet.Dock1.FrameLink = nil;
  	self.Docklet.Dock2.FrameLink = nil;

  	if(enabled1) then
  		local width = self.Docklet:GetWidth();

		if(enabled2) then
			self.Docklet.Dock1:SetWidth(width * 0.5)
			self.Docklet.Dock2:SetWidth(width * 0.5)

			if(self:DockletReady("Skada", dock2)) then
				tipRight = " and Skada";
				self:Docklet_Skada()
				active2 = true
			elseif(self:DockletReady("Omen", dock2)) then
				tipRight = " and Omen";
				self:Docklet_Omen(self.Docklet.Dock2)
				active2 = true
			elseif(self:DockletReady("Recount", dock2)) then
				tipRight = " and Recount";
				self:Docklet_Recount(self.Docklet.Dock2)
				active2 = true
			elseif(self:DockletReady("TinyDPS", dock2)) then
				tipRight = " and TinyDPS";
				self:Docklet_TinyDPS(self.Docklet.Dock2)
				active2 = true
			elseif(self:DockletReady("alDamageMeter", dock2)) then
				tipRight = " and alDamageMeter";
				self:Docklet_alDamageMeter(self.Docklet.Dock2)
				active2 = true
			end
		end

		if(not active2) then
			self.Docklet.Dock1:SetWidth(width)
		end

		if(self:DockletReady("Skada", dock1)) then
			tipLeft = "Skada";
			self:Docklet_Skada()
			active1 = true
		elseif(self:DockletReady("Omen", dock1)) then
			tipLeft = "Omen";
			self:Docklet_Omen(self.Docklet.Dock1)
			active1 = true
		elseif(self:DockletReady("Recount", dock1)) then
			tipLeft = "Recount";
			self:Docklet_Recount(self.Docklet.Dock1)
			active1 = true
		elseif(self:DockletReady("TinyDPS", dock1)) then
			tipLeft = "TinyDPS";
			self:Docklet_TinyDPS(self.Docklet.Dock1) 
			active1 = true
		elseif(self:DockletReady("alDamageMeter", dock1)) then
			tipLeft = "alDamageMeter";
			self:Docklet_alDamageMeter(self.Docklet.Dock1)
			active1 = true
		end
	end

	if(active1) then
		self.Docklet:Enable();
		if(active2) then
			self.Docklet.Dock1:Show()
			self.Docklet.Dock2:Show()
		else
			self.Docklet.Dock1:Show()
			self.Docklet.Dock2:Hide()
		end

		self.Docklet.DockButton:SetAttribute("tipText", ("%s%s"):format(tipLeft, tipRight));
		self.Docklet.DockButton:MakeDefault();
	else
		self.Docklet.Dock1:Hide()
		self.Docklet.Dock2:Hide()
		self.Docklet:Disable()

		self.Docklet.Parent.Bar:UnsetDefault();
	end 
end

local DockableAddons = {
	["alDamageMeter"] = L["alDamageMeter"],
	["Skada"] = L["Skada"],
	["Recount"] = L["Recount"],
	["TinyDPS"] = L["TinyDPS"],
	["Omen"] = L["Omen"]
}

local function GetLiveDockletsA()
	local test = PLUGIN.cache.Docks[2];
	local t = {["None"] = L["None"]};
	for n,l in pairs(DockableAddons) do
		if (test ~= n) then
			if(n:find("Skada") and _G.Skada) then
				for index,window in pairs(_G.Skada:GetWindows()) do
				    local key = window.db.name
				    t["SkadaBarWindow"..key] = (key == "Skada") and "Skada - Main" or "Skada - "..key;
				end
			else
				if IsAddOnLoaded(n) or IsAddOnLoaded(l) then t[n] = l end
			end
		end
	end
	return t;
end

local function GetLiveDockletsB()
	local test = PLUGIN.cache.Docks[1];
	local t = {["None"] = L["None"]};
	for n,l in pairs(DockableAddons) do
		if (test ~= n) then
			if(n:find("Skada") and _G.Skada) then
				for index,window in pairs(_G.Skada:GetWindows()) do
				    local key = window.db.name
				    t["SkadaBarWindow"..key] = (key == "Skada") and "Skada - Main" or "Skada - "..key;
				end
			else
				if IsAddOnLoaded(n) or IsAddOnLoaded(l) then t[n] = l end
			end
		end
	end
	return t;
end

local function GetDockableAddons()
	local test = PLUGIN.cache.Docks[1];

	local t = {
		{ title = "Docked Addon", divider = true },
		{text = "Remove All", func = function() PLUGIN.cache.Docks[1] = "None"; PLUGIN:RegisterAddonDocklets() end}
	};

	for n,l in pairs(DockableAddons) do
		if (not test or (test and not test:find(n))) then
			if(n:find("Skada") and _G.Skada) then
				for index,window in pairs(_G.Skada:GetWindows()) do
					local keyName = window.db.name
				    local key = "SkadaBarWindow" .. keyName
				    local name = (keyName == "Skada") and "Skada - Main" or "Skada - " .. keyName;
				    tinsert(t,{text = name, func = function() PLUGIN.cache.Docks[1] = key; PLUGIN:RegisterAddonDocklets() end});
				end
			else
				if IsAddOnLoaded(n) or IsAddOnLoaded(l) then 
					tinsert(t,{text = n, func = function() PLUGIN.cache.Docks[1] = l; PLUGIN:RegisterAddonDocklets() end});
				end
			end
		end
	end
	return t;
end

local AddonDockletToggle = function(self)
	if(not InCombatLockdown()) then
		self.Parent:Refresh()

		if(not self.Parent.Parent.Window:IsShown()) then
			self.Parent.Parent.Window:Show()
		end
	end

	if(not PLUGIN.Docklet:IsShown()) then
		PLUGIN.Docklet:Show()
	end

	if(not PLUGIN.Docklet.Dock1:IsShown()) then
		PLUGIN.Docklet.Dock1:Show()
	end

	if(not PLUGIN.Docklet.Dock2:IsShown()) then
		PLUGIN.Docklet.Dock2:Show()
	end

	self:Activate()
end

local ShowSubDocklet = function(self)
	local frame  = self.FrameLink
	if(frame and frame.Show) then
		if(InCombatLockdown() and (frame.IsProtected and frame:IsProtected())) then return end
		if(not frame:IsShown()) then
			frame:Show()
		end
	end
end

local HideSubDocklet = function(self)
	local frame  = self.FrameLink
	if(frame and frame.Hide) then
		if(InCombatLockdown() and (frame.IsProtected and frame:IsProtected())) then return end
		if(frame:IsShown()) then
			frame:Hide()
		end
	end
end

local function DockFadeInDocklet()
	local active = PLUGIN.Docklet.DockButton:GetAttribute("isActive")
	if(active) then
		PLUGIN.Docklet.Dock1:Show()
		PLUGIN.Docklet.Dock2:Show()
	end
end
SV.Events:On("DOCKS_FADE_IN", "DockFadeInDocklet", DockFadeInDocklet);

local function DockFadeOutDocklet()
	local active = PLUGIN.Docklet.DockButton:GetAttribute("isActive")
	if(active) then
		PLUGIN.Docklet.Dock1:Hide()
		PLUGIN.Docklet.Dock2:Hide()
	end
end
SV.Events:On("DOCKS_FADE_OUT", "DockFadeOutDocklet", DockFadeOutDocklet);
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function PLUGIN:ReLoad()
	self:RegisterAddonDocklets()
end

function PLUGIN:Load()
	self.cache.Docks = self.cache.Docks or {"None", "None"}

	local alert = CreateFrame('Frame', nil, UIParent);
	alert:SetStylePanel("Fixed", 'Transparent');
	alert:SetSize(250, 70);
	alert:SetPoint('CENTER', UIParent, 'CENTER');
	alert:SetFrameStrata('DIALOG');
	alert.Text = alert:CreateFontString(nil, "OVERLAY");
	alert.Text:SetFont(SV.Media.font.dialog, 12);
	alert.Text:SetPoint('TOP', alert, 'TOP', 0, -10);
	alert.Accept = CreateFrame('Button', nil, alert);
	alert.Accept:SetSize(70, 25);
	alert.Accept:SetPoint('RIGHT', alert, 'BOTTOM', -10, 20);
	alert.Accept.Text = alert.Accept:CreateFontString(nil, "OVERLAY");
	alert.Accept.Text:SetFont(SV.Media.font.dialog, 10);
	alert.Accept.Text:SetPoint('CENTER');
	alert.Accept.Text:SetText(_G.YES);
	alert.Close = CreateFrame('Button', nil, alert);
	alert.Close:SetSize(70, 25);
	alert.Close:SetPoint('LEFT', alert, 'BOTTOM', 10, 20);
	alert.Close:SetScript('OnClick', function(this) this:GetParent():Hide() end);
	alert.Close.Text = alert.Close:CreateFontString(nil, "OVERLAY");
	alert.Close.Text:SetFont(SV.Media.font.dialog, 10);
	alert.Close.Text:SetPoint('CENTER');
	alert.Close.Text:SetText(_G.NO);
	alert.Accept:SetStylePanel("Button");
	alert.Close:SetStylePanel("Button");
	alert:Hide();

	self.Alert = alert;

	self.Docklet = SV.Dock:NewDocklet("BottomRight", "SVUI_StyleOMaticDock", self.TitleID, [[Interface\AddOns\SVUI\assets\artwork\Icons\DOCK-ADDON]], AddonDockletToggle);
	SV.Dock.BottomRight.Bar.Button.GetMenuList = GetDockableAddons;
	self.Docklet.DockButton.GetPreMenuList = GetDockableAddons;
	self.Docklet.DockButton:SetAttribute("hasDropDown", true);

	local dockWidth = self.Docklet:GetWidth()

	self.Docklet.Dock1 = CreateFrame("Frame", "SVUI_StyleOMaticDockAddon1", self.Docklet);
	self.Docklet.Dock1:SetPoint('TOPLEFT', self.Docklet, 'TOPLEFT', -4, 0);
	self.Docklet.Dock1:SetPoint('BOTTOMLEFT', self.Docklet, 'BOTTOMLEFT', -4, -4);
	self.Docklet.Dock1:SetWidth(dockWidth);
	self.Docklet.Dock1:SetScript('OnShow', ShowSubDocklet);
	self.Docklet.Dock1:SetScript('OnHide', HideSubDocklet);

	self.Docklet.Dock2 = CreateFrame("Frame", "SVUI_StyleOMaticDockAddon2", self.Docklet);
	self.Docklet.Dock2:SetPoint('TOPLEFT', self.Docklet.Dock1, 'TOPRIGHT', 0, 0);
	self.Docklet.Dock2:SetPoint('BOTTOMLEFT', self.Docklet.Dock1, 'BOTTOMRIGHT', 0, 0);
	self.Docklet.Dock2:SetWidth(dockWidth * 0.5);
	self.Docklet.Dock2:SetScript('OnShow', ShowSubDocklet);
	self.Docklet.Dock2:SetScript('OnHide', HideSubDocklet);

	self.Docklet:Hide()

	self:RegisterAddonDocklets()

	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("ADDON_LOADED");

	SV.Dock.CustomOptions = {
		DockletMain = {
			type = "select",
			order = 1,
			name = "Primary Docklet",
			desc = "Select an addon to occupy the primary docklet window",
			values = function() return GetLiveDockletsA() end,
			get = function() return PLUGIN.cache.Docks[1] end,
			set = function(a,value) PLUGIN.cache.Docks[1] = value; PLUGIN:RegisterAddonDocklets() end,
		},
		DockletSplit = {
			type = "select",
			order = 2,
			name = "Secondary Docklet",
			desc = "Select another addon",
			disabled = function() return (PLUGIN.cache.Docks[1] == "None") end, 
			values = function() return GetLiveDockletsB() end,
			get = function() return PLUGIN.cache.Docks[2] end,
			set = function(a,value) PLUGIN.cache.Docks[2] = value; PLUGIN:RegisterAddonDocklets() end,
		}
	}
end