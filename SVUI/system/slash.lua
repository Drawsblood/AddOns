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
--]]
--[[ GLOBALS ]]--
local _G = _G;
local select  		= _G.select;
local unpack  		= _G.unpack;
local pairs   		= _G.pairs;
local ipairs  		= _G.ipairs;
local type    		= _G.type;
local tostring      = _G.tostring;
local tonumber      = _G.tonumber;
local print         = _G.print;
local string  		= _G.string;
local math    		= _G.math;
local table   		= _G.table;
local GetTime 		= _G.GetTime;
--[[ STRING METHODS ]]--
local format = string.format;
local lower, trim = string.lower, string.trim
--[[ MATH METHODS ]]--
local floor, modf = math.floor, math.modf;
--[[ TABLE METHODS ]]--
local twipe, tsort = table.wipe, table.sort;
--BLIZZARD API
local ReloadUI              = _G.ReloadUI;
local UnitName   			= _G.UnitName;
local IsInGroup             = _G.IsInGroup;
local CreateFrame           = _G.CreateFrame;
local IsInRaid         		= _G.IsInRaid;
local UnitIsGroupLeader     = _G.UnitIsGroupLeader;
local GetAddOnInfo          = _G.GetAddOnInfo;
local UnitIsGroupAssistant  = _G.UnitIsGroupAssistant;
local EnableAddOn           = _G.EnableAddOn;
local DisableAddOn          = _G.DisableAddOn;
local IsEveryoneAssistant   = _G.IsEveryoneAssistant;
local GetAddOnMetadata      = _G.GetAddOnMetadata;
local SendChatMessage   	= _G.SendChatMessage;
local PlaySoundFile   		= _G.PlaySoundFile;

local LE_PARTY_CATEGORY_HOME = _G.LE_PARTY_CATEGORY_HOME;
local LE_PARTY_CATEGORY_INSTANCE = _G.LE_PARTY_CATEGORY_INSTANCE;

local SV = select(2, ...)
local L = SV.L;
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local MsgTest = function(warning)
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		return "INSTANCE_CHAT"
	elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
		if warning and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant()) then
			return "RAID_WARNING"
		else
			return "RAID"
		end
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		return "PARTY"
	end
	return "SAY"
end
--[[ 
########################################################## 
LOCAL SLASH FUNCTIONS
##########################################################
]]--
local function SVUIMasterCommand(msg)
	if msg then
		msg = lower(trim(msg))
		if (msg == "install") then
			SV.Setup:Install()
		elseif (msg == "move" or msg == "mentalo") then
			SV.Mentalo:Toggle()
		elseif (msg == "kb" or msg == "bind") and SV.db.SVBar.enable then
			SV.SVBar:ToggleKeyBindingMode()
		elseif (msg == "reset" or msg == "resetui") then
			SV:ResetAllUI()
		elseif (msg == "bg" or msg == "pvp") then
			local MOD = SV.Dock
			MOD.ForceHideBGStats = nil;
			MOD:UpdateDataSlots()
			SV:AddonMessage(L['Battleground statistics will now show again if you are inside a battleground.'])
		else
			SV:ToggleConfig()
		end
	else
		SV:ToggleConfig()
	end
end

local function EnableAddon(addon)
	local _, _, _, _, _, reason, _ = GetAddOnInfo(addon)
	if reason ~= "MISSING" then 
		EnableAddOn(addon) 
		ReloadUI() 
	else 
		print("|cffff0000Error, Addon '"..addon.."' not found.|r") 
	end	
end

local function DisableAddon(addon)
	local _, _, _, _, _, reason, _ = GetAddOnInfo(addon)
	if reason ~= "MISSING" then 
		DisableAddOn(addon) 
		ReloadUI() 
	else 
		print("|cffff0000Error, Addon '"..addon.."' not found.|r") 
	end
end
--[[ 
########################################################## 
LEEEEEROY
##########################################################
]]--
do
	local PullCountdown = CreateFrame("Frame", "PullCountdown")
	local PullCountdownHandler = CreateFrame("Frame")
	local firstdone, delay, target
	local interval = 1.5
	local lastupdate = 0

	local function reset()
		PullCountdownHandler:SetScript("OnUpdate", nil)
		firstdone, delay, target = nil, nil, nil
		lastupdate = 0
	end

	local function pull(self, elapsed)
		local tname = UnitName("target")
		if tname then
			target = tname
		else
			target = ""
		end
		if not firstdone then
			SendChatMessage((L["Pulling %s in %s.."]):format(target, tostring(delay)), MsgTest(true))
			firstdone = true
			delay = delay - 1
		end
		lastupdate = lastupdate + elapsed
		if lastupdate >= interval then
			lastupdate = 0
			if delay > 0 then
				SendChatMessage(tostring(delay).."..", MsgTest(true))
				delay = delay - 1
			else
				SendChatMessage(L["Leeeeeroy!"], MsgTest(true))
				reset()
			end
		end
	end

	function PullCountdown.Pull(timer)
		delay = timer or 3
		if PullCountdownHandler:GetScript("OnUpdate") then
			reset()
			SendChatMessage(L["Pull ABORTED!"], MsgTest(true))
		else
			PullCountdownHandler:SetScript("OnUpdate", pull)
		end
	end
	
	_G.SLASH_PULLCOUNTDOWN1 = "/jenkins"
	_G.SlashCmdList["PULLCOUNTDOWN"] = function(msg)
		if(tonumber(msg) ~= nil) then
			PullCountdown.Pull(msg)
		else
			PullCountdown.Pull()
		end
	end
end
--[[ 
########################################################## 
LOAD ALL SLASH FUNCTIONS
##########################################################
]]--
_G.SlashCmdList["SVUISV"] = SVUIMasterCommand;
_G.SLASH_SVUISV1="/sv"

_G.SlashCmdList["SVUISVUI"] = SVUIMasterCommand;
_G.SLASH_SVUISVUI1="/svui"

_G.SlashCmdList["SVUIENABLE"] = EnableAddon;
_G.SLASH_SVUIENABLE1="/enable"

_G.SlashCmdList["SVUIDISABLE"] = DisableAddon;
_G.SLASH_SVUIDISABLE1="/disable"

_G.SlashCmdList["KOMBAT"] = function(msg)
	SV:ToastyKombat()
end
_G.SLASH_KOMBAT1 = "/kombat"

_G.SlashCmdList["LOLWUT"] = function(msg)
	PlaySoundFile("Sound\\Character\\Human\\HumanVocalFemale\\HumanFemalePissed04.wav")
end
_G.SLASH_LOLWUT1 = "/lolwut"