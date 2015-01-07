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

STATS:Extend EXAMPLE USAGE: Dock:NewDataType(newStat,eventList,onEvents,update,click,focus,blur)

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
local error 	= _G.error;
local pcall 	= _G.pcall;
local assert 	= _G.assert;
local tostring 	= _G.tostring;
local tonumber 	= _G.tonumber;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local lower, upper = string.lower, string.upper;
local find, format, len, split = string.find, string.format, string.len, string.split;
local match, sub, join = string.match, string.sub, string.join;
local gmatch, gsub = string.gmatch, string.gsub;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round, mod = math.abs, math.ceil, math.floor, math.round, math.fmod;  -- Basic
--[[ TABLE METHODS ]]--
local twipe, tsort = table.wipe, table.sort;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L;
local Dock = SV.Dock;
--[[ 
########################################################## 
GOLD STATS
##########################################################
]]--
local playerName = UnitName("player");
local playerRealm = GetRealmName();

local StatEvents = {'PLAYER_ENTERING_WORLD','PLAYER_MONEY','SEND_MAIL_MONEY_CHANGED','SEND_MAIL_COD_CHANGED','PLAYER_TRADE_MONEY','TRADE_MONEY_CHANGED'};
local gains = 0;
local loss = 0;
local recorded = 0;
local copperFormat = "%d" .. L.copperabbrev
local silverFormat = "%d" .. L.silverabbrev .. " %.2d" .. L.copperabbrev
local goldFormat = "%s" .. L.goldabbrev .. " %.2d" .. L.silverabbrev .. " %.2d" .. L.copperabbrev

local silverShortFormat = "%d" .. L.silverabbrev
local goldShortFormat = "%s" .. L["goldabbrev"]

local tiptext = join("","|cffaaaaaa",L["Reset Data: Hold Left Ctrl + Shift then Click"],"|r")
local serverGold = {};

local function FormatCurrency(amount, short)
	if not amount then return end 
	local gold, silver, copper = floor(abs(amount/10000)), abs(mod(amount/100,100)), abs(mod(amount,100))
	if(short) then
		if gold ~= 0 then
			gold = BreakUpLargeNumbers(gold)
			return goldShortFormat:format(gold)
		elseif silver ~= 0 then 
			return silverShortFormat:format(silver)
		else 
			return copperFormat:format(copper)
		end
	else
		if gold ~= 0 then
			gold = BreakUpLargeNumbers(gold)
			return goldFormat:format(gold, silver, copper)
		elseif silver ~= 0 then 
			return silverFormat:format(silver, copper)
		else 
			return copperFormat:format(copper)
		end
	end
end 

local function Gold_OnEvent(self, event,...)
	if not IsLoggedIn() then return end 
	local current = GetMoney()
	recorded = Dock.Accountant["gold"][playerName] or GetMoney();
	local adjusted = current - recorded;
	if recorded > current then 
		loss = loss - adjusted 
	else 
		gains = gains + adjusted 
	end 
	self.text:SetText(FormatCurrency(current, SV.db.Dock.shortGold))
	Dock.Accountant["gold"][playerName] = GetMoney()
end 

local function Gold_OnClick(self, button)
	if IsLeftControlKeyDown() and IsShiftKeyDown() then
		Dock.Accountant["gold"] = {};
		Dock.Accountant["gold"][playerName] = GetMoney();
		Gold_OnEvent(self)
		Dock.DataTooltip:Hide()
	else 
		ToggleAllBags()
	end 
end 

local function Gold_OnEnter(self)
	Dock:SetDataTip(self)
	Dock.DataTooltip:AddLine(L['Session:'])
	Dock.DataTooltip:AddDoubleLine(L["Earned:"],FormatCurrency(gains),1,1,1,1,1,1)
	Dock.DataTooltip:AddDoubleLine(L["Spent:"],FormatCurrency(loss),1,1,1,1,1,1)
	if gains < loss then 
		Dock.DataTooltip:AddDoubleLine(L["Deficit:"],FormatCurrency(gains - loss),1,0,0,1,1,1)
	elseif (gains - loss) > 0 then 
		Dock.DataTooltip:AddDoubleLine(L["Profit:"],FormatCurrency(gains - loss),0,1,0,1,1,1)
	end 
	Dock.DataTooltip:AddLine(" ")
	local cash = Dock.Accountant["gold"][playerName];
	Dock.DataTooltip:AddLine(L[playerName..": "])
	Dock.DataTooltip:AddDoubleLine(L["Total: "], FormatCurrency(cash), 1,1,1,1,1,1)
	Dock.DataTooltip:AddLine(" ")

	Dock.DataTooltip:AddLine(L["Characters: "])
	for name,amount in pairs(serverGold)do
		if(name ~= playerName and name ~= 'total') then
			cash = cash + amount;
			Dock.DataTooltip:AddDoubleLine(name, FormatCurrency(amount), 1,1,1,1,1,1)
		end
	end 
	Dock.DataTooltip:AddLine(" ")
	Dock.DataTooltip:AddLine(L["Server: "])
	Dock.DataTooltip:AddDoubleLine(L["Total: "], FormatCurrency(cash), 1,1,1,1,1,1)
	Dock.DataTooltip:AddLine(" ")
	Dock.DataTooltip:AddLine(tiptext)
	Dock:ShowDataTip()
end

local function Gold_OnInit(self)
	Dock:SetAccountantData('gold', 'number', 0);

	local totalGold = 0;
	for name,amount in pairs(Dock.Accountant["gold"])do 
		if Dock.Accountant["gold"][name] then 
			serverGold[name] = amount;
			totalGold = totalGold + amount
		end 
	end

	serverGold['total'] = totalGold;
end

Dock:NewDataType('Gold', StatEvents, Gold_OnEvent, nil, Gold_OnClick, Gold_OnEnter, nil, Gold_OnInit);