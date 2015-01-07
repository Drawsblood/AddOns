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
local L = SV.L

local MOD = SV:NewPackage("SVTools", L["Docked Tools"]);

function MOD:PLAYER_REGEN_ENABLED()
	self:UnregisterEvent('PLAYER_REGEN_ENABLED')

	if(self.ProfessionNeedsUpdate) then
		self.ProfessionNeedsUpdate = nil;
		self:UpdateProfessionTools()
	end

	if(self.GarrisonNeedsUpdate) then
		self.GarrisonNeedsUpdate = nil;
		self:UpdateGarrisonTool()
	end

	if(self.RaidLeaderNeedsUpdate) then
		self.RaidLeaderNeedsUpdate = nil;
		self:UpdateRaidLeader()
	end
end

function MOD:ReLoad()
	self:UpdateProfessionTools()
	self:UpdateGarrisonTool()
	self:UpdateRaidLeader()
end 

function MOD:Load()
	--self:LoadQuestWatch()
	self:LoadProfessionTools()
	self:LoadGarrisonTool()
	self:LoadRaidLeaderTools()
end