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

STATS:Extend EXAMPLE USAGE: Dock:NewDataType(newStat,eventList,onEvents,update,click,focus,blur,load)

########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack 	= _G.unpack;
local select 	= _G.select;
local string 	= _G.string;
--[[ STRING METHODS ]]--
local match, sub, join = string.match, string.sub, string.join;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L
local Dock = SV.Dock;
--[[ 
########################################################## 
CALL TO ARMS STATS
##########################################################
]]--
local StatEvents = {'PLAYER_ENTERING_WORLD', 'COMBAT_LOG_EVENT_UNFILTERED', "PLAYER_LEAVE_COMBAT", 'PLAYER_REGEN_DISABLED', 'UNIT_PET'};

local PlayerEvents = {["SWING_DAMAGE"] = true, ["RANGE_DAMAGE"] = true, ["SPELL_DAMAGE"] = true, ["SPELL_PERIODIC_DAMAGE"] = true, ["DAMAGE_SHIELD"] = true, ["DAMAGE_SPLIT"] = true, ["SPELL_EXTRA_ATTACKS"] = true}
local playerID = UnitGUID('player')
local petID
local DMGTotal, lastDMGAmount = 0, 0
local combatTime = 0
local timeStamp = 0
local lastSegment = 0
local lastPanel
local hexColor = "FFFFFF"
local displayString = "|cff%s%.1f|r";
local dpsString = "%s |cff00CCFF%s|r";

local function Reset()
	timeStamp = 0
	combatTime = 0
	DMGTotal = 0
	lastDMGAmount = 0
end	

local function GetDPS(self)
	if DMGTotal == 0 or combatTime == 0 then
		self.text:SetText(dpsString:format(L["DPS"], "..PAUSED"))
		self.TText = "No Damage Done"
		self.TText2 = "Go smack something so \nthat I can do the maths!"
	else
		local DPS = (DMGTotal) / (combatTime)
		self.text:SetFormattedText(displayString, hexColor, DPS)
		self.TText = "DPS:"
		self.TText2 = DPS
	end
end

local function DPS_OnClick(self)
	Reset()
	GetDPS(self)
end

local function DPS_OnEnter(self)
	Dock:SetDataTip(self)
	Dock.DataTooltip:AddDoubleLine("Damage Total:", DMGTotal, 1, 1, 1)
	Dock.DataTooltip:AddLine(" ", 1, 1, 1)
	Dock.DataTooltip:AddDoubleLine(self.TText, self.TText2, 1, 1, 1)
	Dock.DataTooltip:AddLine(" ", 1, 1, 1)
	Dock.DataTooltip:AddDoubleLine("[Click]", "Clear DPS", 0,1,0, 0.5,1,0.5)
	Dock:ShowDataTip(true)
end

local function DPS_OnEvent(self, event, ...)
	lastPanel = self
	if event == "PLAYER_ENTERING_WORLD" then
		playerID = UnitGUID('player')
	elseif event == 'PLAYER_REGEN_DISABLED' or event == "PLAYER_LEAVE_COMBAT" then
		local now = time()
		if now - lastSegment > 20 then --time since the last segment
			Reset()
		end
		lastSegment = now
	elseif event == 'COMBAT_LOG_EVENT_UNFILTERED' then
		local newTime, event, _, srcGUID, srcName, srcFlags, sourceRaidFlags, dstGUID, dstName, dstFlags, destRaidFlags, lastDMGAmount, spellName = ...
		if not PlayerEvents[event] then return end
		if(srcGUID == playerID or srcGUID == petID) then
			if timeStamp == 0 then timeStamp = newTime end
			lastSegment = timeStamp
			combatTime = newTime - timeStamp
			if event ~= "SWING_DAMAGE" then
				lastDMGAmount = select(15, ...)
			end
			DMGTotal = DMGTotal + lastDMGAmount
		end
	elseif event == UNIT_PET then
		petID = UnitGUID("pet")
	end
	
	GetDPS(self)
end

local DPSColorUpdate = function()
	hexColor = SV:HexColor("highlight")
	if lastPanel ~= nil then
		DPS_OnEvent(lastPanel)
	end
end

SV.Events:On("SVUI_COLORS_UPDATED", "DPSColorUpdates", DPSColorUpdate)
Dock:NewDataType('DPS', StatEvents, DPS_OnEvent, nil, DPS_OnClick, DPS_OnEnter)