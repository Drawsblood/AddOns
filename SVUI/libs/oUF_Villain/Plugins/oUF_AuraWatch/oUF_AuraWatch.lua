--GLOBAL NAMESPACE
local _G = _G;
--LUA
local unpack        = _G.unpack;
local select        = _G.select;
local assert        = _G.assert;
local error         = _G.error;
local print         = _G.print;
local pairs         = _G.pairs;
local next          = _G.next;
local tostring      = _G.tostring;
local setmetatable  = _G.setmetatable;
--STRING
local string        = _G.string;
local format        = string.format;
--MATH
local math          = _G.math;
local floor         = math.floor
local ceil          = math.ceil
--BLIZZARD API
local GetTime       	= _G.GetTime;
local CreateFrame       = _G.CreateFrame;
local UnitAura         	= _G.UnitAura;
local GetSpellInfo      = _G.GetSpellInfo;
local NumberFontNormal  = _G.NumberFontNormal;

local _, ns = ...
local oUF = oUF or ns.oUF
assert(oUF, "oUF_AuraWatch cannot find an instance of oUF. If your oUF is embedded into a layout, it may not be embedded properly.")

local UnitBuff, UnitDebuff, UnitGUID = UnitBuff, UnitDebuff, UnitGUID
local GUIDs = {}

local PLAYER_UNITS = {
	player = true,
	vehicle = true,
	pet = true,
}

local setupGUID
do 
	local cache = setmetatable({}, {__type = "k"})

	local frame = CreateFrame"Frame"
	frame:SetScript("OnEvent", function(self, event)
		for k,t in pairs(GUIDs) do
			GUIDs[k] = nil
			for a in pairs(t) do
				t[a] = nil
			end
			cache[t] = true
		end
	end)
	frame:RegisterEvent"PLAYER_REGEN_ENABLED"
	frame:RegisterEvent"PLAYER_ENTERING_WORLD"
	
	function setupGUID(guid)
		local t = next(cache)
		if t then
			cache[t] = nil
		else
			t = {}
		end
		GUIDs[guid] = t
	end
end

local day, hour, minute, second = 86400, 3600, 60, 1;

local function formatTime(s)
	if s >= day then
		return format("%dd", ceil(s / hour))
	elseif s >= hour then
		return format("%dh", ceil(s / hour))
	elseif s >= minute then
		return format("%dm", ceil(s / minute))
	elseif s >= 5 then
		return floor(s)
	end
	
	return format("%.1f", s)
end

local function updateText(self, elapsed)
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 and ((self.timeLeft <= self.textThreshold) or self.textThreshold == -1) then
				local time = formatTime(self.timeLeft)
				self.text:SetText(time)
			else
				self.text:SetText('')
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
	end
end


local function resetIcon(icon, frame, count, duration, remaining)
	if icon.onlyShowMissing then
		icon:Hide()
	else
		icon:Show()
		if icon.cd then
			if duration and duration > 0 and icon.style ~= 'NONE' then
				icon.cd:SetCooldown(remaining - duration, duration)
				icon.cd:Show()
			else
				icon.cd:Hide()
			end
		end

		if icon.displayText then
			icon.timeLeft = remaining
			icon.first = true;
			icon:SetScript('OnUpdate', updateText)
		end

		if icon.count then
			icon.count:SetText((count > 1 and count))
		end
		if icon.overlay then
			icon.overlay:Hide()
		end
		icon:SetAlpha(icon.presentAlpha)
	end
end

local function expireIcon(icon, frame)
	if icon.onlyShowPresent then
		icon:Hide()
	else
		if (icon.cd) then icon.cd:Hide() end
		if (icon.count) then icon.count:SetText() end
		icon:SetAlpha(icon.missingAlpha)
		if icon.overlay then
			icon.overlay:Show()
		end
		icon:Show()
	end
end

local found = {}
local function Update(frame, event, unit)
	if frame.unit ~= unit or not unit then return end 
	local watch = frame.AuraWatch
	local index, icons = 1, watch.watched
	local _, name, texture, count, duration, remaining, caster, key, icon, spellID
	local filter = "HELPFUL"
	local guid = UnitGUID(unit)
	if not guid then return end
	if not GUIDs[guid] then setupGUID(guid) end
	
	for key, icon in pairs(icons) do
		if not icon.onlyShowMissing then
			icon:Hide()
		end
	end
	
	while true do
		name, _, texture, count, _, duration, remaining, caster, _, _, spellID = UnitAura(unit, index, filter)
		if not name then 
			if filter == "HELPFUL" then
				filter = "HARMFUL"
				index = 1
			else
				break
			end
		else
			if watch.strictMatching then
				key = spellID
			else
				key = name..texture
			end
			icon = icons[key]

			if icon and (icon.anyUnit or (caster and icon.fromUnits and icon.fromUnits[caster])) then
				resetIcon(icon, watch, count, duration, remaining)
				GUIDs[guid][key] = true
				found[key] = true
			end
			index = index + 1
		end
	end
	
	for key in pairs(GUIDs[guid]) do
		if icons[key] and not found[key] then
			expireIcon(icons[key], watch)
		end
	end
	
	for k in pairs(found) do
		found[k] = nil
	end
end

local function setupIcons(self)

	local watch = self.AuraWatch
	local icons = watch.icons
	watch.watched = {}
	
	for _,icon in pairs(icons) do
	
		local name, _, image = GetSpellInfo(icon.spellID)

		if name then
			icon.name = name
		
			if not icon.cd and not (watch.hideCooldown or icon.hideCooldown) then
				local cd = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
				cd:SetAllPoints(icon)
				icon.cd = cd
			end

			if not icon.icon then
				local tex = icon:CreateTexture(nil, "BACKGROUND")
				tex:SetAllPoints(icon)
				tex:SetTexture(image)
				icon.icon = tex
				if not icon.overlay then
					local overlay = icon:CreateTexture(nil, "OVERLAY")
					overlay:SetTexture"Interface\\Buttons\\UI-Debuff-Overlays"
					overlay:SetAllPoints(icon)
					overlay:SetTexCoord(.296875, .5703125, 0, .515625)
					overlay:SetVertexColor(1, 0, 0)
					icon.overlay = overlay
				end
			end

			if not icon.count and not (watch.hideCount or icon.hideCount) then
				local count = icon:CreateFontString(nil, "OVERLAY")
				count:SetFontObject(NumberFontNormal)
				count:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -1, 0)
				icon.count = count
			end

			if icon.onlyShowMissing == nil then
				icon.onlyShowMissing = watch.onlyShowMissing
			end
			if icon.onlyShowPresent == nil then
				icon.onlyShowPresent = watch.onlyShowPresent
			end
			if icon.presentAlpha == nil then
				icon.presentAlpha = watch.presentAlpha
			end
			if icon.missingAlpha == nil then
				icon.missingAlpha = watch.missingAlpha
			end		
			if icon.fromUnits == nil then
				icon.fromUnits = watch.fromUnits or PLAYER_UNITS
			end
			if icon.anyUnit == nil then
				icon.anyUnit = watch.anyUnit
			end
			
			if watch.strictMatching then
				watch.watched[icon.spellID] = icon
			else
				watch.watched[name..image] = icon
			end

			if watch.PostCreateIcon then watch:PostCreateIcon(icon, icon.spellID, name, self) end
		else
			print("oUF_AuraWatch error: no spell with "..tostring(icon.spellID).." spell ID exists")
		end
	end
end

local function Enable(self)
	if self.AuraWatch then
		self.AuraWatch.Update = setupIcons
		self:RegisterEvent("UNIT_AURA", Update)
		setupIcons(self)
		return true
	else
		return false
	end
end

local function Disable(self)
	if self.AuraWatch then
		self:UnregisterEvent("UNIT_AURA", Update)
		for _,icon in pairs(self.AuraWatch.icons) do
			icon:Hide()
		end
	end
end
oUF:AddElement("AuraWatch", Update, Enable, Disable)
