if(select(2, UnitClass('player')) ~= 'WARRIOR') then return end
--GLOBAL NAMESPACE
local _G = _G;
--LUA
local unpack        = _G.unpack;
local select        = _G.select;
local assert        = _G.assert;
--BLIZZARD API
local UnitDebuff      	= _G.UnitDebuff;

local parent, ns = ...
local oUF = ns.oUF

local RAGE_AURAS = {}

local function getRageAmount()
	for i = 1, 40 do
		local _, _, _, _, _, _, _, _, _, _, spellID, _, _, _, amount = 
			UnitDebuff("player", i)
		if RAGE_AURAS[spellID] then
			return amount
		end
	end
	return 0
end

local OnUpdate = function(self, elapsed)
	local duration = self.duration + elapsed
	if(duration >= self.max) then
		return self:SetScript("OnUpdate", nil)
	else
		self.duration = duration
		return self:SetValue(duration)
	end
end

local Update = function(self, event, unit)
	if(unit and unit ~= self.unit) then return end
	local bar = self.Conqueror
	if(bar.PreUpdate) then bar:PreUpdate(event) end

	local value = getRageAmount()

	if(value) then
		bar:SetMinMaxValues(0, 100)
		bar:SetValue(value)
		bar:Update()
	end
	
	if(bar.PostUpdate) then
		return bar:PostUpdate(event)
	end
end

local Path = function(self, ...)
	return (self.Conqueror.Override or Update)(self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate')
end

local Enable = function(self)
	local bar = self.Conqueror

	if(bar) then
		bar.__owner = self
		bar.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_AURA', Path, true)

		if(bar:IsObjectType'Texture' and not bar:GetTexture()) then
			bar:SetTexture[[Interface\TargetingFrame\UI-StatusBar]]
		end

		return true
	end
end

local Disable = function(self)
	local bar = self.Conqueror

	if (bar) then
		self:UnregisterEvent('UNIT_AURA', Path)
	end
end

oUF:AddElement('Conqueror', Path, Enable, Disable)
