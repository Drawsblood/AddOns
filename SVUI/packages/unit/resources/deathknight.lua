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
if(SV.class ~= "DEATHKNIGHT") then return end 
local MOD = SV.SVUnit
if(not MOD) then return end 
--[[ 
########################################################## 
LOCALS
##########################################################
]]--
SV.SpecialFX:Register("rune_blood", [[Spells\Monk_drunkenhaze_impact.m2]], 0, 0, 0, 0, 0.00001, 0, 0.3)
SV.SpecialFX:Register("rune_frost", [[Spells\Ice_cast_low_hand.m2]], 0, 0, 0, 0, 0.00001, -0.2, 0.4)
SV.SpecialFX:Register("rune_unholy", [[Spells\Poison_impactdot_med_chest.m2]], 0, 0, 0, 0, 0.13, -0.3, -0.2)
SV.SpecialFX:Register("rune_death", [[Spells\Shadow_strikes_state_hand.m2]], 0, 0, 0, 0, 0.001, 0, -0.35)
local specEffects = { 
	[1] = "rune_blood", 
	[2] = "rune_blood", 
	[3] = "rune_frost",
	[4] = "rune_frost", 
	[5] = "rune_unholy", 
	[6] = "rune_unholy",
};
local colors = {
	{0.75, 0, 0},   -- blood
	{0.1, 0.75, 0},  -- unholy
	{0, 0.5, 0.75},   -- frost
	{0.5, 0, 1}, -- death
}
--[[ 
########################################################## 
POSITIONING
##########################################################
]]--
local Reposition = function(self)
	local db = SV.db.SVUnit.player
	local bar = self.Necromancy;
	local max = self.MaxClassPower;
	local size = db.classbar.height
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
		bar[i]:ClearAllPoints()
		bar[i]:SetHeight(size+4)
		bar[i]:SetWidth(size)
		bar[i].bar:GetStatusBarTexture():SetHorizTile(false)
		if i==1 then 
			bar[i]:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 1)
		else 
			bar[i]:SetPointToScale("LEFT", bar[i - 1], "RIGHT", -3, 0) 
		end
	end

	if bar.UpdateAllRuneTypes then 
		bar.UpdateAllRuneTypes(self)
	end
end
--[[ 
########################################################## 
DEATHKNIGHT
##########################################################
]]--
local RuneChange = function(self, runeType)
	if(runeType and runeType == 4) then
		self.FX:SetEffect("rune_death")
	else
		self.FX:SetEffect(specEffects[self.effectIndex])
	end
end

function MOD:CreateClassBar(playerFrame)
	local max = 6
	local bar = CreateFrame("Frame", nil, playerFrame)
	bar:SetFrameLevel(playerFrame.TextGrip:GetFrameLevel() + 30)
	for i=1, max do
		local color = colors[i]
		local rune = CreateFrame("Frame", nil, bar)
		rune:SetFrameStrata("BACKGROUND")
		rune:SetFrameLevel(0)

		local bgFrame = CreateFrame("Frame", nil, rune)
		bgFrame:SetAllPointsIn(rune)

		local bgTexture = bgFrame:CreateTexture(nil, "BORDER")
		bgTexture:SetAllPoints(bgFrame)
		bgTexture:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Bars\DEFAULT]])
		bgTexture:SetGradientAlpha("VERTICAL",colors[1],colors[2],colors[3],0.75,0,0,0,0.25)

		local borderB = bgFrame:CreateTexture(nil,"OVERLAY")
	    borderB:SetTexture(0,0,0)
	    borderB:SetPoint("BOTTOMLEFT")
	    borderB:SetPoint("BOTTOMRIGHT")
	    borderB:SetHeight(2)

	    local borderT = bgFrame:CreateTexture(nil,"OVERLAY")
	    borderT:SetTexture(0,0,0)
	    borderT:SetPoint("TOPLEFT")
	    borderT:SetPoint("TOPRIGHT")
	    borderT:SetHeight(2)

	    local borderL = bgFrame:CreateTexture(nil,"OVERLAY")
	    borderL:SetTexture(0,0,0)
	    borderL:SetPoint("TOPLEFT")
	    borderL:SetPoint("BOTTOMLEFT")
	    borderL:SetWidth(2)

	    local borderR = bgFrame:CreateTexture(nil,"OVERLAY")
	    borderR:SetTexture(0,0,0)
	    borderR:SetPoint("TOPRIGHT")
	    borderR:SetPoint("BOTTOMRIGHT")
	    borderR:SetWidth(2)

	    rune.bar = CreateFrame("StatusBar", nil, bgFrame)
		rune.bar.noupdate = true;
		rune.bar:SetAllPointsIn(bgFrame)
		rune.bar:SetOrientation("HORIZONTAL")
		rune.bar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Bars\DEFAULT]])

		local effectName = specEffects[i]
		SV.SpecialFX:SetFXFrame(rune.bar, effectName)

		bar[i] = rune;
		bar[i].bar.effectIndex = i;
		bar[i].bar.Change = RuneChange;
		bar[i].bar:SetOrientation("VERTICAL");
	end 
	
	local classBarHolder = CreateFrame("Frame", "Player_ClassBar", bar)
	classBarHolder:SetPointToScale("TOPLEFT", playerFrame, "BOTTOMLEFT", 0, -2)
	bar:SetPoint("TOPLEFT", classBarHolder, "TOPLEFT", 0, 0)
	bar.Holder = classBarHolder
	SV.Mentalo:Add(bar.Holder, L["Classbar"])

	playerFrame.MaxClassPower = max;
	playerFrame.ClassBarRefresh = Reposition;
	playerFrame.Necromancy = bar
	return 'Necromancy' 
end 