--GLOBAL NAMESPACE
local _G = _G;
--LUA
local unpack        = _G.unpack;
local select        = _G.select;
local assert        = _G.assert;
--BLIZZARD API
local UnitPower     	= _G.UnitPower;
local UnitPowerMax 		= _G.UnitPowerMax;
local UnitHasVehicleUI 	= _G.UnitHasVehicleUI;

if select(2, UnitClass('player')) ~= "MONK" then return end

local _, ns = ...
local oUF = ns.oUF or oUF

local SPELL_POWER_CHI = SPELL_POWER_CHI

oUF.colors.MonkHarmony = { 
	[1] = {.57, .63, .35, 1},
	[2] = {.47, .63, .35, 1},
	[3] = {.37, .63, .35, 1},
	[4] = {.27, .63, .33, 1},
	[5] = {.17, .63, .33, 1},
	[6] = {0, .63, .33, 1},
}

local function Update(self, event, unit)
	local hb = self.MonkHarmony
	if(hb.PreUpdate) then hb:PreUpdate(event) end
	local light = UnitPower("player", SPELL_POWER_CHI)
	
	-- if max light changed, show/hide the 5th and update anchors
	local numPoints = UnitPowerMax("player", SPELL_POWER_CHI)

	for i = 1, numPoints do
		local orb = hb[i]
		if(orb) then
			if i <= light then
				orb:Show()
			else
				orb:Hide()
			end
		end
	end
	
	if UnitHasVehicleUI("player") then
		hb:Hide()
	else
		hb:Show()
	end
	
	if hb.numPoints ~= numPoints then
		if numPoints == 6 then
			hb[5]:Show()
			hb[6]:Show()
		elseif numPoints == 5 then
			hb[5]:Show()
			hb[6]:Hide()
		else
			hb[5]:Hide()
			hb[6]:Hide()
		end
	end
	
	hb.numPoints = numPoints
	
	if(hb.PostUpdate) then hb:PostUpdate(event) end
end

local function Enable(self, unit)
	if(unit ~= 'player') then return end
	local hb = self.MonkHarmony
	if hb then
		self:RegisterEvent("PLAYER_ENTERING_WORLD", Update)
		self:RegisterEvent("UNIT_POWER", Update)
		self:RegisterEvent("UNIT_DISPLAYPOWER", Update)
		self:RegisterEvent("PLAYER_LEVEL_UP", Update)
		
		for i = 1, 6 do
			if not hb[i]:GetStatusBarTexture() then
				hb[i]:SetStatusBarTexture([=[Interface\TargetingFrame\UI-StatusBar]=])
			end
			
			hb[i]:SetStatusBarColor(unpack(oUF.colors.MonkHarmony[i]))
			hb[i]:SetFrameLevel(hb:GetFrameLevel() + 1)
			hb[i]:GetStatusBarTexture():SetHorizTile(false)
		end
		
		hb.numPoints = 6
		
		return true
	end
end

local function Disable(self)
	if self.MonkHarmony then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD", Update)
		self:UnregisterEvent("UNIT_POWER", Update)
		self:UnregisterEvent("UNIT_DISPLAYPOWER", Update)
		self:UnregisterEvent("PLAYER_LEVEL_UP", Update)
	end
end

oUF:AddElement('MonkHarmony', Update, Enable, Disable)