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
local unpack    = _G.unpack;
local select    = _G.select;
local pairs     = _G.pairs;
local ipairs    = _G.ipairs;
local type      = _G.type;
local error     = _G.error;
local pcall     = _G.pcall;
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local assert 	= _G.assert;
local math 		= _G.math;
--[[ MATH METHODS ]]--
local random = math.random;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local oUF_Villain = SV.oUF

assert(oUF_Villain, "SVUI was unable to locate oUF.")

local L = SV.L;
if(SV.class ~= "PALADIN") then return end 
local MOD = SV.SVUnit
if(not MOD) then return end 

--SV.SpecialFX:Register("holypower", [[Spells\Holy_missile_low.m2]], -12, 12, 12, -12, 1.5, 0, 0)
SV.SpecialFX:Register("holypower", [[Spells\Holylight_impact_head.m2]], -12, 12, 12, -12, 0.8, 0, -0.4)
--SV.SpecialFX:Register("holypower", [[Spells\Paladin_healinghands_state_01.m2]], -12, 12, 12, -12, 1.2, 0, 0)
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--

--[[ 
########################################################## 
POSITIONING
##########################################################
]]--
local Reposition = function(self)
	local db = SV.db.SVUnit.player
	local bar = self.HolyPower;
	local max = self.MaxClassPower;
	local size = db.classbar.height + 4;
	local width = size * max;
	bar.Holder:SetSizeToScale(width, size)
    if(not db.classbar.detachFromFrame) then
    	SV.Mentalo:Reset(L["Classbar"])
    end
    local holderUpdate = bar.Holder:GetScript('OnSizeChanged')
    if holderUpdate then
        holderUpdate(bar.Holder)
    end

    bar:ClearAllPoints()
    bar:SetAllPoints(bar.Holder)
	for i = 1, max do
		bar[i].holder:ClearAllPoints()
		bar[i].holder:SetHeight(size)
		bar[i].holder:SetWidth(size)
		bar[i]:GetStatusBarTexture():SetHorizTile(false)
		if i==1 then 
			bar[i].holder:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
		else 
			bar[i].holder:SetPointToScale("LEFT", bar[i - 1].holder, "RIGHT", -4, 0) 
		end
	end 
end 

local Update = function(self, event, unit, powerType)
	if self.unit ~= unit or (powerType and powerType ~= 'HOLY_POWER') then return end 
	local bar = self.HolyPower;
	local baseCount = UnitPower('player',SPELL_POWER_HOLY_POWER)
	local maxCount = UnitPowerMax('player',SPELL_POWER_HOLY_POWER)
	for i=1,maxCount do 
		if i <= baseCount then 
			bar[i]:SetAlpha(1)
			if(not bar[i].holder.FX:IsShown()) then
				bar[i].holder.FX:Show()
				bar[i].holder.FX:UpdateEffect()
			end
		else 
			bar[i]:SetAlpha(0)
			bar[i].holder.FX:Hide()
		end 
		if i > maxCount then 
			bar[i]:Hide()
		else 
			bar[i]:Show()
		end 
	end
	self.MaxClassPower = maxCount
end
--[[ 
########################################################## 
PALADIN
##########################################################
]]--
local ShowLink = function(self) self.holder:Show() end
local HideLink = function(self) self.holder:Hide() end

function MOD:CreateClassBar(playerFrame)
	local max = 5
	local bar = CreateFrame("Frame", nil, playerFrame)
	bar:SetFrameLevel(playerFrame.TextGrip:GetFrameLevel() + 30)

	for i = 1, max do
		local underlay = CreateFrame("Frame", nil, bar);
		SV.SpecialFX:SetFXFrame(underlay, "holypower", true)
		underlay.FX:SetFrameStrata("BACKGROUND")
		underlay.FX:SetFrameLevel(0)

		bar[i] = CreateFrame("StatusBar", nil, underlay)
		bar[i]:SetAllPoints(underlay)
		bar[i]:SetStatusBarTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\PALADIN-HAMMER-FG")
		bar[i]:GetStatusBarTexture():SetHorizTile(false)
		bar[i]:SetStatusBarColor(0.9,0.9,0.8)

		bar[i].bg = underlay:CreateTexture(nil,"BORDER")
		bar[i].bg:SetAllPoints(underlay)
		bar[i].bg:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\PALADIN-HAMMER-BG")
		bar[i].bg:SetVertexColor(0,0,0)

		bar[i].holder = underlay
		--bar[i]:SetScript("OnShow", ShowLink)
		--bar[i]:SetScript("OnHide", HideLink)
	end 
	bar.Override = Update;
	
	local classBarHolder = CreateFrame("Frame", "Player_ClassBar", bar)
	classBarHolder:SetPointToScale("TOPLEFT", playerFrame, "BOTTOMLEFT", 0, -2)
	bar:SetPoint("TOPLEFT", classBarHolder, "TOPLEFT", 0, 0)
	bar.Holder = classBarHolder
	SV.Mentalo:Add(bar.Holder, L["Classbar"])

	playerFrame.MaxClassPower = max;
	playerFrame.ClassBarRefresh = Reposition;
	playerFrame.HolyPower = bar
	return 'HolyPower'  
end 