--GLOBAL NAMESPACE
local _G = _G;
--LUA
local unpack        = _G.unpack;
local select        = _G.select;
local assert        = _G.assert;
local type         	= _G.type;
--BLIZZARD API
local GetTime       	= _G.GetTime;
local GetSpecialization = _G.GetSpecialization;
local UnitDebuff      	= _G.UnitDebuff;

if select(2, UnitClass('player')) ~= "MAGE" then return end

local _, ns = ...
local oUF = oUF or ns.oUF
if not oUF then return end

local function UpdateBar(self, elapsed)
	if not self.duration then return end
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed >= 0.5 then
		local timeLeft = (self.duration - GetTime())
		if timeLeft > 0 then
			self:SetValue(timeLeft)
		else
			self.start = nil
			self.duration = nil
			self:SetValue(0)
			self:Hide()
			self:SetScript("OnUpdate", nil)
		end
	end		
end

local Update = function(self, event, unit)
	if(self.unit ~= unit) then return end
	local bar = self.ArcaneChargeBar
	local spec = GetSpecialization()
	
	if(bar.PreUpdate) then bar:PreUpdate(spec) end
	
	local arcaneCharges, start, duration = 0;
	if bar:IsShown() then		
		for index=1, 30 do
			local count, _, spellID = 0;
			_, _, _, count, _, start, duration, _, _, _, spellID = UnitDebuff(unit, index)
			if spellID == 36032 then
				arcaneCharges = count or 0
				start = start
				duration = duration
				break
			end			
		end

		for i = 1, 4 do
			if start and duration then
				bar[i]:SetMinMaxValues(0, start)
				bar[i].start = start
				bar[i].duration = duration
			end

			if i <= arcaneCharges then
				bar[i]:Show()
				bar[i]:SetValue(start)
				bar[i]:SetScript('OnUpdate', UpdateBar)
			else
				bar[i]:SetValue(0)
				bar[i]:Hide()
			end
		end		
	end
	
	if(bar.PostUpdate) then
		return bar:PostUpdate(event, arcaneCharges, maxCharges)
	end
end


local Path = function(self, ...)
	return (self.ArcaneChargeBar.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self, unit)
	local bar = self.ArcaneChargeBar

	if(bar) then
		self:RegisterEvent("UNIT_AURA", Path)
		self:RegisterEvent("PLAYER_TALENT_UPDATE", Path)
		self:RegisterEvent("PLAYER_ENTERING_WORLD", Path)
		bar.__owner = self
		bar.ForceUpdate = ForceUpdate

		for i = 1, 4 do
			if not bar[i]:GetStatusBarTexture() then
				bar[i]:SetStatusBarTexture([=[Interface\TargetingFrame\UI-StatusBar]=])
			end

			bar[i]:SetFrameLevel(bar:GetFrameLevel() + 1)
			bar[i]:GetStatusBarTexture():SetHorizTile(false)
			
			if bar[i].bg then
				bar[i]:SetMinMaxValues(0, 1)
				bar[i]:SetValue(0)
				bar[i].bg:SetAlpha(0.4)
				bar[i].bg:SetAllPoints()
				bar[i]:Hide()
			end		
		end
		
		return true;
	end	
end

local function Disable(self,unit)
	local bar = self.ArcaneChargeBar

	if(bar) then
		self:UnregisterEvent("UNIT_AURA", Path)
		self:UnregisterEvent("PLAYER_TALENT_UPDATE", Path)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD", Path)
		bar:Hide()
	end
end
			
oUF:AddElement("ArcaneChargeBar",Path,Enable,Disable)