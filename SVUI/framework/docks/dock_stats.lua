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
local string    = _G.string;
local math      = _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local join, len = string.join, string.len;
--[[ MATH METHODS ]]--
local min = math.min;
--TABLE
local table         = _G.table;
local tsort         = table.sort;
local tconcat       = table.concat;
local tinsert       = _G.tinsert;
local tremove       = _G.tremove;
local twipe         = _G.wipe;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L
local LSM = LibStub("LibSharedMedia-3.0")
local LDB = LibStub("LibDataBroker-1.1", true)
local Dock = SV.Dock;

Dock.TopCenter = _G["SVUI_DockTopCenter"];
Dock.BottomCenter = _G["SVUI_DockBottomCenter"];

Dock.DataHolders = {};
Dock.DataTypes = {};
Dock.DataTooltip = CreateFrame("GameTooltip", "SVUI_DataTooltip", UIParent, "GameTooltipTemplate");

local PVP_STAT_ORDER = {"Honor", "Kills", "Assists", "Damage", "Healing", "Deaths"};
local PVP_STAT_LOOKUP = {
	["Name"] = {1, NAME}, 
	["Kills"] = {2, KILLS},
	["Assists"] = {3, PET_ASSIST},
	["Deaths"] = {4, DEATHS},
	["Honor"] = {5, HONOR},
	["Faction"] = {6, FACTION},
	["Race"] = {7, RACE},
	["Class"] = {8, CLASS},
	["Damage"] = {10, DAMAGE},
	["Healing"] = {11, SHOW_COMBAT_HEALING},
	["Rating"] = {12, BATTLEGROUND_RATING},
	["Changes"] = {13, RATING_CHANGE},
	["Spec"] = {16, SPECIALIZATION}
};
local DIRTY_LIST = true;
--[[ 
########################################################## 
LOCALIZED GLOBALS
##########################################################
]]--
local CUSTOM_CLASS_COLORS = _G.CUSTOM_CLASS_COLORS
local RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS
--[[ 
########################################################## 
LOCAL VARIABLES
##########################################################
]]--
local playerName = UnitName("player");
local playerRealm = GetRealmName();
local BGStatString = "%s: %s"
local myName = UnitName("player");
local myClass = select(2,UnitClass("player"));
local classColor = RAID_CLASS_COLORS[myClass];
local SCORE_CACHE = {};
local hexHighlight = "FFFFFF";
local StatMenuListing = {}
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local UpdateAnchor = function()
	local backdrops, width, height = SV.db.Dock.dataBackdrop
	for _, parent in pairs(Dock.DataHolders) do
		local point1, point2, x, y = "LEFT", "RIGHT", 4, 0;
		local slots = parent.Stats.Slots
		local numPoints = #slots
		if(parent.Stats.Orientation == "VERTICAL") then
			width = parent:GetWidth() - 4;
			height = parent:GetHeight() / numPoints - 4;

			point1, point2, x, y = "TOP", "BOTTOM", 0, -4
		else
			width = parent:GetWidth() / numPoints - 4;
			height = parent:GetHeight() - 4;
			if(backdrops) then
				height = height + 6
			end
		end

		for i = 1, numPoints do 
			slots[i]:SetWidthToScale(width)
			slots[i]:SetHeightToScale(height)
			if(i == 1) then 
				slots[i]:SetPointToScale(point1, parent, point1, x, y)
			else
				slots[i]:SetPointToScale(point1, slots[i - 1], point2, x, y)
			end
		end 
	end 
end

local _hook_TooltipOnShow = function(self)
	self:SetBackdrop({
		bgFile = [[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]], 
		edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
		tile = false, 
		edgeSize = 1
		})
	self:SetBackdropColor(0, 0, 0, 0.8)
	self:SetBackdropBorderColor(0, 0, 0)
end 

local function TruncateString(value)
	if value >= 1e9 then 
		return ("%.1fb"):format(value/1e9):gsub("%.?0+([kmb])$","%1")
	elseif value >= 1e6 then 
		return ("%.1fm"):format(value/1e6):gsub("%.?0+([kmb])$","%1")
	elseif value >= 1e3 or value <= -1e3 then 
		return ("%.1fk"):format(value/1e3):gsub("%.?0+([kmb])$","%1")
	else 
		return value 
	end 
end 
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function Dock:SetDataTip(stat)
	local parent = stat:GetParent()
	Dock.DataTooltip:Hide()
	Dock.DataTooltip:SetOwner(parent, parent.Stats.TooltipAnchor)
	Dock.DataTooltip:ClearLines()
	GameTooltip:Hide()
end

function Dock:SetBrokerTip(stat)
	local parent = stat:GetParent()
	Dock.DataTooltip:Hide()
	Dock.DataTooltip:SetOwner(parent, "ANCHOR_CURSOR")
	Dock.DataTooltip:ClearLines()
	GameTooltip:Hide()
end

function Dock:PrependDataTip()
	Dock.DataTooltip:AddDoubleLine("[Alt + Click]", "Swap Stats", 0, 1, 0, 0.5, 1, 0.5)
	Dock.DataTooltip:AddLine(" ")
end

function Dock:ShowDataTip(noSpace)
	if(not noSpace) then
		Dock.DataTooltip:AddLine(" ")
	end
	Dock.DataTooltip:AddDoubleLine("[Alt + Click]", "Swap Stats", 0, 1, 0, 0.5, 1, 0.5)
	Dock.DataTooltip:Show()
end

local function GetDataSlot(parent, index)
	if(not parent.Stats.Slots[index]) then
		local GlobalName = parent:GetName() .. 'StatSlot' .. index;

		local slot = CreateFrame("Button", GlobalName, parent);
		slot:RegisterForClicks("AnyUp")


		slot.barframe = CreateFrame("Frame", nil, slot)
		
		if(SV.db.Dock.dataBackdrop) then
			slot.barframe:SetPointToScale("TOPLEFT", slot, "TOPLEFT", 24, -2)
			slot.barframe:SetPointToScale("BOTTOMRIGHT", slot, "BOTTOMRIGHT", -2, 2)
			slot:SetStylePanel(parent.Stats.templateType, parent.Stats.templateName)
		else
			slot.barframe:SetPointToScale("TOPLEFT", slot, "TOPLEFT", 24, 2)
			slot.barframe:SetPointToScale("BOTTOMRIGHT", slot, "BOTTOMRIGHT", 2, -2)
			slot.barframe.bg = slot.barframe:CreateTexture(nil, "BORDER")
			slot.barframe.bg:SetAllPointsIn(slot.barframe, 2, 2)
			slot.barframe.bg:SetTexture([[Interface\BUTTONS\WHITE8X8]])
			slot.barframe.bg:SetGradient(unpack(SV.Media.gradient.dark))
		end

		slot.barframe:SetFrameLevel(slot:GetFrameLevel()-1)
		slot.barframe:SetBackdrop({
			bgFile = [[Interface\BUTTONS\WHITE8X8]], 
			edgeFile = [[Interface\AddOns\SVUI\assets\artwork\Template\GLOW]], 
			tile = false, 
			tileSize = 0, 
			edgeSize = 2, 
			insets = {left = 0, right = 0, top = 0, bottom = 0}
			})
		slot.barframe:SetBackdropColor(0, 0, 0, 0.5)
		slot.barframe:SetBackdropBorderColor(0, 0, 0, 0.8)

		slot.barframe.icon = CreateFrame("Frame", nil, slot.barframe)
		slot.barframe.icon:SetPointToScale("TOPLEFT", slot, "TOPLEFT", 0, 6)
		slot.barframe.icon:SetPointToScale("BOTTOMRIGHT", slot, "BOTTOMLEFT", 26, -6)
		slot.barframe.icon.texture = slot.barframe.icon:CreateTexture(nil, "OVERLAY")
		slot.barframe.icon.texture:SetAllPointsIn(slot.barframe.icon, 2, 2)
		slot.barframe.icon.texture:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Icons\\PLACEHOLDER")

		slot.barframe.bar = CreateFrame("StatusBar", nil, slot.barframe)
		slot.barframe.bar:SetAllPointsIn(slot.barframe, 2, 2)
		slot.barframe.bar:SetStatusBarTexture(SV.Media.bar.default)
			
		slot.barframe.bar.extra = CreateFrame("StatusBar", nil, slot.barframe.bar)
		slot.barframe.bar.extra:SetAllPoints()
		slot.barframe.bar.extra:SetStatusBarTexture(SV.Media.bar.default)
		slot.barframe.bar.extra:Hide()

		slot.barframe:Hide()

		slot.textframe = CreateFrame("Frame", nil, slot)
		slot.textframe:SetAllPoints(slot)
		slot.textframe:SetFrameStrata(parent.Stats.textStrata)

		slot.text = slot.textframe:CreateFontString(nil, "OVERLAY", nil, 7)
		slot.text:SetAllPoints()

		slot.text:FontManager("data")
		if(SV.db.Dock.dataBackdrop) then
			slot.text:SetShadowColor(0, 0, 0, 0.5)
			slot.text:SetShadowOffset(2, -4)
		end

		slot.SlotKey = i;
		slot.TokenKey = 738;
		slot.MenuList = {};
		slot.TokenList = {};

		parent.Stats.Slots[index] = slot;
		return slot;
	end

	return parent.Stats.Slots[index];
end 

function Dock:NewDataHolder(parent, maxCount, tipAnchor, isTop, customTemplate, isVertical, bgEnabled)
	DIRTY_LIST = true

	local parentName = parent:GetName();

	Dock.DataHolders[parentName] = parent;
	parent.Stats = {};
	parent.Stats.Slots = {};
	parent.Stats.Orientation = isVertical and "VERTICAL" or "HORIZONTAL";
	parent.Stats.TooltipAnchor = tipAnchor or "ANCHOR_CURSOR";
	parent.Stats.BGEnabled = bgEnabled or false;

	local point1, point2, x, y = "LEFT", "RIGHT", 4, 0;
	if(isVertical) then
		point1, point2, x, y = "TOP", "BOTTOM", 0, -4;
	end

	if(customTemplate) then
		parent.Stats.templateType = "Fixed"
		parent.Stats.templateName = customTemplate
		parent.Stats.textStrata = "LOW"
	else
		parent.Stats.templateType = "Framed"
		parent.Stats.templateName = isTop and "FramedTop" or "FramedBottom"
		parent.Stats.textStrata = "MEDIUM"
	end

	for i = 1, maxCount do
		local slot = GetDataSlot(parent, i)
		if(i == 1) then 
			parent.Stats.Slots[i]:SetPointToScale(point1, parent, point1, x, y)
		else
			parent.Stats.Slots[i]:SetPointToScale(point1, parent.Stats.Slots[i - 1], point2, x, y)
		end
	end

	parent:SetScript("OnSizeChanged", UpdateAnchor);

	UpdateAnchor(parent);
end 

function Dock:NewDataType(newStat, eventList, onEvents, update, click, focus, blur, init)
	if not newStat then return end 
	self.DataTypes[newStat] = {}
	tinsert(StatMenuListing, newStat)
	if type(eventList) == "table" then 
		self.DataTypes[newStat]["events"] = eventList;
		self.DataTypes[newStat]["event_handler"] = onEvents 
	end 
	if update and type(update) == "function" then 
		self.DataTypes[newStat]["update_handler"] = update 
	end 
	if click and type(click) == "function" then 
		self.DataTypes[newStat]["click_handler"] = click 
	end 
	if focus and type(focus) == "function" then 
		self.DataTypes[newStat]["focus_handler"] = focus 
	end 
	if blur and type(blur) == "function" then 
		self.DataTypes[newStat]["blur_handler"] = blur 
	end 
	if init and type(init) == "function" then 
		self.DataTypes[newStat]["init_handler"] = init 
	end 
end

do
	local Stat_OnLeave = function()
		Dock.DataTooltip:Hide()
	end

	local Parent_OnClick = function(self, button)
		if IsAltKeyDown() then
			SV.Dropdown:Open(self, self.MenuList);
		elseif(self.onClick) then
			self.onClick(self, button);
		end
	end

	local function _load(parent, name, config)
		parent.StatParent = name

		if config["init_handler"]then 
			config["init_handler"](parent)
		end

		if config["events"]then 
			for _, event in pairs(config["events"])do 
				parent:RegisterEvent(event)
			end 
		end 

		if config["event_handler"]then 
			parent:SetScript("OnEvent", config["event_handler"])
			config["event_handler"](parent, "SVUI_FORCE_RUN")
		end 

		if config["update_handler"]then 
			parent:SetScript("OnUpdate", config["update_handler"])
			config["update_handler"](parent, 20000)
		end 

		if config["click_handler"]then
			parent.onClick = config["click_handler"]
		end
		parent:SetScript("OnClick", Parent_OnClick)

		if config["focus_handler"]then 
			parent:SetScript("OnEnter", config["focus_handler"])
		end 

		if config["blur_handler"]then 
			parent:SetScript("OnLeave", config["blur_handler"])
		else 
			parent:SetScript("OnLeave", Stat_OnLeave)
		end

		parent:Show()
	end

	local BG_OnUpdate = function(self)
		local scoreString;
		local parentName = self:GetParent():GetName();
		local key = self.SlotKey
		local lookup = PVP_STAT_ORDER[key]
		local scoreindex = PVP_STAT_LOOKUP[lookup][1]
		local scoreType = PVP_STAT_LOOKUP[lookup][2]
		local scoreCount = GetNumBattlefieldScores()
		for i = 1, scoreCount do
			SCORE_CACHE = {GetBattlefieldScore(i)}
			if(SCORE_CACHE[1] and SCORE_CACHE[1] == myName and SCORE_CACHE[scoreindex]) then
				scoreString = TruncateString(SCORE_CACHE[scoreindex])
				self.text:SetFormattedText(BGStatString, scoreType, scoreString)
				break 
			end 
		end 
	end

	local BG_OnEnter = function(self)
		Dock:SetDataTip(self)
		local bgName;
		local mapToken = GetCurrentMapAreaID()
		local r, g, b;
		if(classColor) then
			r, g, b = classColor.r, classColor.g, classColor.b
		else
			r, g, b = 1, 1, 1
		end

		local scoreCount = GetNumBattlefieldScores()

		for i = 1, scoreCount do 
			bgName = GetBattlefieldScore(i)
			if(bgName and bgName == myName) then 
				Dock.DataTooltip:AddDoubleLine(L["Stats For:"], bgName, 1, 1, 1, r, g, b)
				Dock.DataTooltip:AddLine(" ")
				if(mapToken == 443 or mapToken == 626) then 
					Dock.DataTooltip:AddDoubleLine(L["Flags Captured"], GetBattlefieldStatData(i, 1), 1, 1, 1)
					Dock.DataTooltip:AddDoubleLine(L["Flags Returned"], GetBattlefieldStatData(i, 2), 1, 1, 1)
				elseif(mapToken == 482) then 
					Dock.DataTooltip:AddDoubleLine(L["Flags Captured"], GetBattlefieldStatData(i, 1), 1, 1, 1)
				elseif(mapToken == 401) then 
					Dock.DataTooltip:AddDoubleLine(L["Graveyards Assaulted"], GetBattlefieldStatData(i, 1), 1, 1, 1)
					Dock.DataTooltip:AddDoubleLine(L["Graveyards Defended"], GetBattlefieldStatData(i, 2), 1, 1, 1)
					Dock.DataTooltip:AddDoubleLine(L["Towers Assaulted"], GetBattlefieldStatData(i, 3), 1, 1, 1)
					Dock.DataTooltip:AddDoubleLine(L["Towers Defended"], GetBattlefieldStatData(i, 4), 1, 1, 1)
				elseif(mapToken == 512) then 
					Dock.DataTooltip:AddDoubleLine(L["Demolishers Destroyed"], GetBattlefieldStatData(i, 1), 1, 1, 1)
					Dock.DataTooltip:AddDoubleLine(L["Gates Destroyed"], GetBattlefieldStatData(i, 2), 1, 1, 1)
				elseif(mapToken == 540 or mapToken == 736 or mapToken == 461) then 
					Dock.DataTooltip:AddDoubleLine(L["Bases Assaulted"], GetBattlefieldStatData(i, 1), 1, 1, 1)
					Dock.DataTooltip:AddDoubleLine(L["Bases Defended"], GetBattlefieldStatData(i, 2), 1, 1, 1)
				elseif(mapToken == 856) then 
					Dock.DataTooltip:AddDoubleLine(L["Orb Possessions"], GetBattlefieldStatData(i, 1), 1, 1, 1)
					Dock.DataTooltip:AddDoubleLine(L["Victory Points"], GetBattlefieldStatData(i, 2), 1, 1, 1)
				elseif(mapToken == 860) then 
					Dock.DataTooltip:AddDoubleLine(L["Carts Controlled"], GetBattlefieldStatData(i, 1), 1, 1, 1)
				end 
				break 
			end 
		end 
		Dock:ShowDataTip()
	end

	local ForceHideBGStats;
	local BG_OnClick = function()
		ForceHideBGStats = true;
		Dock:UpdateDataSlots()
		SV:AddonMessage(L["Battleground statistics temporarily hidden, to show type \"/sv bg\" or \"/sv pvp\""])
	end

	local function setMenuLists()
		local anchorTable = Dock.DataHolders;
		local statMenu = StatMenuListing;

		tsort(statMenu)

		for place, parent in pairs(anchorTable) do
			local slots = parent.Stats.Slots;
			local numPoints = #slots;
			for i = 1, numPoints do 
				local subList = twipe(slots[i].MenuList)
				tinsert(subList,{text = NONE, func = function() Dock:ChangeDBVar("", i, "dataHolders", place); Dock:UpdateDataSlots() end});
				for _,name in pairs(statMenu) do
					tinsert(subList,{text = name, func = function() Dock:ChangeDBVar(name, i, "dataHolders", place); Dock:UpdateDataSlots() end});
				end
			end
		end

		DIRTY_LIST = false;
	end 

	function Dock:UpdateDataSlots()
		if(DIRTY_LIST) then setMenuLists() end
		
		local instance, groupType = IsInInstance()
		local anchorTable = self.DataHolders
		local statTable = self.DataTypes
		local db = SV.db.Dock
		local allowPvP = (db.battleground and not ForceHideBGStats) or false

		for place, parent in pairs(anchorTable) do
			local slots = parent.Stats.Slots;
			local numPoints = #slots;

			for i = 1, numPoints do
				local pvpTable = (allowPvP and parent.Stats.BGEnabled) and PVP_STAT_ORDER[i]
				local slot = slots[i];

				slot:UnregisterAllEvents()
				slot:SetScript("OnUpdate", nil)
				slot:SetScript("OnEnter", nil)
				slot:SetScript("OnLeave", nil)
				slot:SetScript("OnClick", nil)

				if(db.dataBackdrop) then
					slot.text:SetFont(LSM:Fetch("font", db.dataFont), db.dataFontSize, "NONE")
				else
					slot.text:SetFont(LSM:Fetch("font", db.dataFont), db.dataFontSize, db.dataFontOutline)
				end
				
				slot.text:SetText(nil)

				if slot.barframe then 
					slot.barframe:Hide()
				end 

				slot:Hide()

				if(pvpTable and ((instance and groupType == "pvp") or parent.lockedOpen)) then 
					slot:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
					slot:SetScript("OnEvent", BG_OnUpdate)
					slot:SetScript("OnEnter", BG_OnEnter)
					slot:SetScript("OnLeave", Stat_OnLeave)
					slot:SetScript("OnClick", BG_OnClick)

					BG_OnUpdate(slot)

					slot:Show()
				else 
					for name, config in pairs(statTable) do
						for panelName, panelData in pairs(db.dataHolders) do 
							if(panelData and type(panelData) == "table") then 
								if(panelName == place and panelData[i] and panelData[i] == name) then 
									_load(slot, name, config)
								end 
							elseif(panelData and type(panelData) == "string" and panelData == name) then 
								if(name == place) then 
									_load(slot, name, config)
								end 
							end 
						end
					end 
				end 
			end
		end

		if ForceHideBGStats then ForceHideBGStats = nil end
	end
end
--[[ 
########################################################## 
BUILD FUNCTION / UPDATE
##########################################################
]]--
function Dock:SetAccountantData(dataType, cacheType, defaultValue)
	self.Accountant[dataType] = self.Accountant[dataType] or {};
	local cache = self.Accountant[dataType];
	if(not cache[playerName] or type(cache[playerName]) ~= cacheType) then
		cache[playerName] = defaultValue;
	end
end

function Dock:RefreshStats()
	local centerWidth = SV.db.Dock.dockCenterWidth;
	local centerHeight = SV.db.Dock.dockCenterHeight;

	self.BottomCenter:SetSize(centerWidth, centerHeight);
	self.TopCenter:SetSize(centerWidth, centerHeight);

	self:UpdateDataSlots();
end 

function Dock:InitializeStats()
	local centerWidth = SV.db.Dock.dockCenterWidth;
	local centerHeight = SV.db.Dock.dockCenterHeight;

	hexHighlight = SV:HexColor("highlight") or "FFFFFF"
	local hexClass = classColor.colorStr
	BGStatString = "|cff" .. hexHighlight .. "%s: |c" .. hexClass .. "%s|r";

	local accountant = LibSuperVillain("Registry"):NewGlobal("Accountant")
	accountant[playerRealm] = accountant[playerRealm] or {};
	self.Accountant = accountant[playerRealm];

	--BOTTOM CENTER BAR
	self.BottomCenter:SetParent(SV.Screen)
	self.BottomCenter:ClearAllPoints()
	self.BottomCenter:SetSize(centerWidth, centerHeight)
	self.BottomCenter:SetPoint("BOTTOM", SV.Screen, "BOTTOM", 0, 0)
	SV.Mentalo:Add(self.BottomCenter, L["Bottom Data Dock"])
	self:NewDataHolder(self.BottomCenter, 6, "ANCHOR_CURSOR")
	--SV:AddToDisplayAudit(self.BottomCenter)

	--TOP CENTER BAR
	self.TopCenter:SetParent(SV.Screen)
	self.TopCenter:ClearAllPoints()
	self.TopCenter:SetSize(centerWidth, centerHeight)
	self.TopCenter:SetPoint("TOP", SV.Screen, "TOP", 0, 0)
	SV.Mentalo:Add(self.TopCenter, L["Top Data Dock"])
	self:NewDataHolder(self.TopCenter, 6, "ANCHOR_CURSOR")
	SV:AddToDisplayAudit(self.TopCenter)
	
	-- self.DataTooltip:SetParent(SV.Screen)
	self.DataTooltip:SetFrameStrata("DIALOG")
	self.DataTooltip:HookScript("OnShow", _hook_TooltipOnShow)

	if(LDB) then
	  	for dataName, dataObj in LDB:DataObjectIterator() do

		    local OnEnter, OnLeave, OnClick, lastObj;

		    if dataObj.OnTooltipShow then 
		      	function OnEnter(self)
					dataObj.OnTooltipShow(GameTooltip)
					-- GameTooltip:SetBackdropColor(0, 0, 0, 1)
					-- if(GameTooltip.SuperBorder) then
					-- 	GameTooltip.SuperBorder:SetBackdropColor(0, 0, 0, 0.8)
					-- end
				end
		    end

		    if dataObj.OnEnter then 
		      	function OnEnter(self)
					dataObj.OnEnter(self)
					-- GameTooltip:SetBackdropColor(0, 0, 0, 1)
					-- if(GameTooltip.SuperBorder) then
					-- 	GameTooltip.SuperBorder:SetBackdropColor(0, 0, 0, 0.8)
					-- end
				end
		    end

		    if dataObj.OnLeave then 
				function OnLeave(self)
					Dock.DataTooltip:Hide()
					dataObj.OnLeave(self)
				end 
		    end

		    if dataObj.OnClick then
		    	function OnClick(self, button)
			      	dataObj.OnClick(self, button)
			    end
			end

			local function textUpdate(event, name, key, value, dataobj)
				if value == nil or (len(value) > 5) or value == 'n/a' or name == value then
					lastObj.text:SetText(value ~= 'n/a' and value or name)
				else
					lastObj.text:SetText(name..': '.. '|cff' .. hexHighlight ..value..'|r')
				end
			end

		    local function OnEvent(self)
				lastObj = self;
				LDB:RegisterCallback("LibDataBroker_AttributeChanged_"..dataName.."_text", textUpdate)
				LDB:RegisterCallback("LibDataBroker_AttributeChanged_"..dataName.."_value", textUpdate)
				LDB.callbacks:Fire("LibDataBroker_AttributeChanged_"..dataName.."_text", dataName, nil, dataObj.text, dataObj)
		    end

		    Dock:NewDataType(dataName, {"PLAYER_ENTERING_WORLD"}, OnEvent, nil, OnClick, OnEnter, OnLeave)
	  	end
	end

	self:UpdateDataSlots()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "Generate");
end