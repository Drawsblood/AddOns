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
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local oUF_Villain = SV.oUF

local assert = _G.assert;
assert(oUF_Villain, "SVUI was unable to locate oUF.")

local L = SV.L;
if(SV.class ~= "HUNTER") then return end 
local MOD = SV.SVUnit
if(not MOD) then return end 

SV.SpecialFX:Register("trap_fire", [[Spells\Fireshot_missile.m2]], -12, 12, 12, -12, 0.4, 0, 0.2)
SV.SpecialFX:Register("trap_ice", [[Spells\Frostshot_missile.m2]], -12, 12, 12, -12, 0.4, 0, 0.18)
SV.SpecialFX:Register("trap_frost", [[Spells\Blindingshot_missile.m2]], -12, 12, 12, -12, 0.4, -0.2, 0.3)
SV.SpecialFX:Register("trap_snake", [[Spells\Poisonshot_missile.m2]], -12, 12, 12, -12, 0.4, 0, -0.21)
local specEffects = { 
	[1] = "trap_fire", 
	[2] = "trap_ice", 
	[3] = "trap_frost"
};
local HAS_SNAKE_TRAP = false;
--[[ 
########################################################## 
POSITIONING
##########################################################
]]--
local Reposition = function(self)
	local db = SV.db.SVUnit.player
	local bar = self.HunterTraps;
	local max = self.MaxClassPower;
	local size = db.classbar.height + 10
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
		bar[i]:SetHeight(size)
		bar[i]:SetWidth(size)
		if i==1 then 
			bar[i]:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
		else 
			bar[i]:SetPointToScale("LEFT", bar[i - 1], "RIGHT", -1, 0) 
		end
	end 
end 
--[[ 
########################################################## 
MAGE CHARGES
##########################################################
]]--
local TrapUpdate = function(self, isReady)
	if(isReady) then
		if(not self.FX:IsShown()) then	
			self.FX:Show()
		end
		self.FX:UpdateEffect()
	else
		self.FX:Hide()
	end
end

local SnakeTrapUpdate = function(self, isReady, isSnake, bypass)
	if((isSnake ~= nil) and (isSnake ~= HAS_SNAKE_TRAP)) then
		if(isSnake == true) then
			specEffects[3] = "trap_snake"
		else
			specEffects[3] = "trap_frost"
		end
		HAS_SNAKE_TRAP = isSnake

		self.FX:SetEffect(specEffects[3])
	end

	if(not bypass) then
		if(isReady) then
			if(not self.FX:IsShown()) then	
				self.FX:Show()
			end
			self.FX:UpdateEffect()
		else
			self.FX:Hide()
		end
	end
end

function MOD:CreateClassBar(playerFrame)
	local max = 3
	local bar = CreateFrame("Frame",nil,playerFrame)
	bar:SetFrameLevel(playerFrame.TextGrip:GetFrameLevel() + 30)

	for i = 1, max do 
		bar[i] = CreateFrame("StatusBar", nil, bar)
		bar[i]:SetStatusBarTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\HUNTER-TRAP")
		bar[i]:GetStatusBarTexture():SetHorizTile(false)
		bar[i]:SetOrientation("VERTICAL")
		bar[i].noupdate = true;

		bar[i].bg = bar[i]:CreateTexture(nil, "BACKGROUND")
		bar[i].bg:SetAllPoints(bar[i])
		bar[i].bg:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\HUNTER-TRAP-BG");

		local effectName = specEffects[i]
		SV.SpecialFX:SetFXFrame(bar[i], effectName)
	end

	bar[1].Update = TrapUpdate
	bar[2].Update = TrapUpdate
	bar[3].Update = SnakeTrapUpdate

	local classBarHolder = CreateFrame("Frame", "Player_ClassBar", bar)
	classBarHolder:SetPointToScale("TOPLEFT", playerFrame, "BOTTOMLEFT", 0, -2)
	bar:SetPoint("TOPLEFT", classBarHolder, "TOPLEFT", 0, 0)
	bar.Holder = classBarHolder
	SV.Mentalo:Add(bar.Holder, L["Classbar"])

	playerFrame.MaxClassPower = max;
	playerFrame.ClassBarRefresh = Reposition;
	playerFrame.HunterTraps = bar
	return 'HunterTraps' 
end 