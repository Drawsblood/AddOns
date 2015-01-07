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
local _G = _G;
--LUA
local unpack        = _G.unpack;
local select        = _G.select;
local assert        = _G.assert;
local type          = _G.type;
local error         = _G.error;
local pcall         = _G.pcall;
local print         = _G.print;
local ipairs        = _G.ipairs;
local pairs         = _G.pairs;
local next          = _G.next;
local rawset        = _G.rawset;
local rawget        = _G.rawget;
local tostring      = _G.tostring;
local tonumber      = _G.tonumber;
local getmetatable  = _G.getmetatable;
local setmetatable  = _G.setmetatable;
--STRING
local string        = _G.string;
local upper         = string.upper;
local format        = string.format;
local find          = string.find;
local match         = string.match;
local gsub          = string.gsub;
--MATH
local math          = _G.math;
local random        = math.random;
local floor         = math.floor
local ceil         	= math.ceil
local max         	= math.max

local SV = select(2, ...)
local oUF_Villain = SV.oUF

assert(oUF_Villain, "SVUI was unable to locate oUF.");

local L = SV.L;
local MOD = SV.SVUnit

if(not MOD) then return end 
--[[ 
########################################################## 
LOCAL VARIABLES
##########################################################
]]--
local STATE_ICON_FILE = [[Interface\Addons\SVUI\assets\artwork\Unitframe\UNIT-PLAYER-STATE]]
local AURA_FONT = [[Interface\AddOns\SVUI\assets\fonts\Numbers.ttf]]
local AURA_FONTSIZE = 10
local AURA_OUTLINE = "OUTLINE"
local LML_ICON_FILE = [[Interface\Addons\SVUI\assets\artwork\Unitframe\UNIT-LML]]
local ROLE_ICON_FILE = [[Interface\Addons\SVUI\assets\artwork\Unitframe\UNIT-ROLES]]
local BUDDY_ICON = [[Interface\Addons\SVUI\assets\artwork\Unitframe\UNIT-FRIENDSHIP]]
local ROLE_ICON_DATA = {
	["TANK"] = {0,0.5,0,0.5, 0.5,0.75,0.5,0.75},
	["HEALER"] = {0,0.5,0.5,1, 0.5,0.75,0.75,1},
	["DAMAGER"] = {0.5,1,0,0.5, 0.75,1,0.5,0.75}
}

local function BasicBG(frame)
	frame:SetBackdrop({
    	bgFile = [[Interface\BUTTONS\WHITE8X8]], 
		tile = false, 
		tileSize = 0, 
		edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
        edgeSize = 2, 
        insets = {
            left = 0, 
            right = 0, 
            top = 0, 
            bottom = 0
        }
    })
    frame:SetBackdropColor(0, 0, 0, 0)
    frame:SetBackdropBorderColor(0, 0, 0)
end
--[[ 
########################################################## 
RAID DEBUFFS / DEBUFF HIGHLIGHT
##########################################################
]]--
function MOD:CreateRaidDebuffs(frame)
	local raidDebuff = CreateFrame("Frame", nil, frame)
	raidDebuff:SetStylePanel("Fixed", "Slot")
	raidDebuff.icon = raidDebuff:CreateTexture(nil, "OVERLAY")
	raidDebuff.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	raidDebuff.icon:SetAllPointsIn(raidDebuff)
	raidDebuff.count = raidDebuff:CreateFontString(nil, "OVERLAY")
	raidDebuff.count:FontManager("aura")
	raidDebuff.count:SetPoint("BOTTOMRIGHT", 0, 2)
	raidDebuff.count:SetTextColor(1, .9, 0)
	raidDebuff.time = raidDebuff:CreateFontString(nil, "OVERLAY")
	raidDebuff.time:FontManager("aura")
	raidDebuff.time:SetPoint("CENTER")
	raidDebuff.time:SetTextColor(1, .9, 0)
	raidDebuff:SetParent(frame.TextGrip)
	return raidDebuff
end 

function MOD:CreateAfflicted(frame)
	local holder = CreateFrame("Frame", nil, frame.Health)
	holder:SetFrameLevel(30)
	holder:SetAllPoints(frame.Health)
	local afflicted = holder:CreateTexture(nil, "OVERLAY", nil, 7)
	afflicted:SetAllPointsIn(holder)
	afflicted:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\UNIT-AFFLICTED")
	afflicted:SetVertexColor(0, 0, 0, 0)
	afflicted:SetBlendMode("ADD")
	frame.AfflictedFilter = true
	frame.AfflictedAlpha = 0.75
	
	return afflicted
end
--[[ 
########################################################## 
VARIOUS ICONS
##########################################################
]]--
function MOD:CreateResurectionIcon(frame)
	local rez = frame.TextGrip:CreateTexture(nil, "OVERLAY")
	rez:SetPointToScale("CENTER", frame.TextGrip.Health, "CENTER")
	rez:SetSizeToScale(30, 25)
	rez:SetDrawLayer("OVERLAY", 7)
	return rez 
end 

function MOD:CreateReadyCheckIcon(frame)
	local rdy = frame.TextGrip:CreateTexture(nil, "OVERLAY", nil, 7)
	rdy:SetSizeToScale(12)
	rdy:SetPointToScale("BOTTOM", frame.Health, "BOTTOM", 0, 2)
	return rdy 
end 

function MOD:CreateGladiator(frame)
	local pvp = CreateFrame("Frame", nil, frame)
	pvp:SetFrameLevel(pvp:GetFrameLevel() + 1)

	local trinket = CreateFrame("Frame", nil, pvp)
	BasicBG(trinket)
	trinket.Icon = trinket:CreateTexture(nil, "BORDER")
	trinket.Icon:SetAllPointsIn(trinket, 2, 2)
	trinket.Icon:SetTexture([[Interface\Icons\INV_MISC_QUESTIONMARK]])
	trinket.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	trinket.Unavailable = trinket:CreateTexture(nil, "OVERLAY")
	trinket.Unavailable:SetAllPoints(trinket)
	trinket.Unavailable:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	trinket.Unavailable:SetTexture([[Interface\BUTTONS\UI-GroupLoot-Pass-Up]])
	trinket.Unavailable:Hide()

	trinket.CD = CreateFrame("Cooldown", nil, trinket)
	trinket.CD:SetAllPoints(trinket)

	pvp.Trinket = trinket

	local badge = CreateFrame("Frame", nil, pvp)
	BasicBG(badge)
	badge.Icon = badge:CreateTexture(nil, "OVERLAY")
	badge.Icon:SetAllPointsIn(badge, 2, 2)
	badge.Icon:SetTexture([[Interface\Icons\INV_MISC_QUESTIONMARK]])
	badge.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	pvp.Badge = badge

	return pvp 
end

function MOD:CreateFriendshipBar(frame)
	local buddy = CreateFrame("StatusBar", nil, frame.Power)
    buddy:SetAllPoints(frame.Power)
    buddy:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Bars\DEFAULT]])
    buddy:SetStatusBarColor(1,0,0)
    local bg = buddy:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints(buddy)
	bg:SetTexture(0.2,0,0)
	local icon = buddy:CreateTexture(nil, "OVERLAY")
	icon:SetPoint("LEFT", buddy, "LEFT", -11, 0)
	icon:SetSize(22,22)
	icon:SetTexture(BUDDY_ICON)

	return buddy 
end
--[[ 
########################################################## 
CONFIGURABLE ICONS
##########################################################
]]--
function MOD:CreateRaidIcon(frame)
	local rIcon = frame.TextGrip:CreateTexture(nil, "OVERLAY", nil, 2)
	rIcon:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
	rIcon:SetSizeToScale(18)
	rIcon:SetPointToScale("CENTER", frame.TextGrip, "TOP", 0, 2)
	return rIcon 
end 

local UpdateRoleIcon = function(self)
	local key = self.___key
	local db = SV.db.SVUnit[key]
	if(not db or not db.icons or (db.icons and not db.icons.roleIcon)) then return end 
	local lfd = self.LFDRole
	if(not db.icons.roleIcon.enable) then lfd:Hide() return end 
	local unitRole = UnitGroupRolesAssigned(self.unit)
	if(self.isForced and unitRole == "NONE") then 
		local rng = random(1, 3)
		unitRole = rng == 1 and "TANK" or rng == 2 and "HEALER" or rng == 3 and "DAMAGER" 
	end 
	if(unitRole ~= "NONE" and (self.isForced or UnitIsConnected(self.unit))) then
		local coords = ROLE_ICON_DATA[unitRole]
		lfd:SetTexture(ROLE_ICON_FILE)
		if(lfd:GetHeight() <= 13) then
			lfd:SetTexCoord(coords[5], coords[6], coords[7], coords[8])
		else
			lfd:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
		end
		lfd:Show()
	else
		lfd:Hide()
	end 
end 

function MOD:CreateRoleIcon(frame)
	local parent = frame.TextGrip or frame;
	local rIconHolder = CreateFrame("Frame", nil, parent)
	rIconHolder:SetAllPoints()
	local rIcon = rIconHolder:CreateTexture(nil, "ARTWORK", nil, 2)
	rIcon:SetSizeToScale(14)
	rIcon:SetPointToScale("BOTTOMRIGHT", rIconHolder, "BOTTOMRIGHT")
	rIcon.Override = UpdateRoleIcon;
	frame:RegisterEvent("UNIT_CONNECTION", UpdateRoleIcon)
	return rIcon 
end 

function MOD:CreateRaidRoleFrames(frame)
	local parent = frame.TextGrip or frame;
	local raidRoles = CreateFrame("Frame", nil, frame)
	raidRoles:SetSizeToScale(24, 12)
	raidRoles:SetPointToScale("TOPLEFT", frame.ActionPanel, "TOPLEFT", -2, 4)
	raidRoles:SetFrameLevel(parent:GetFrameLevel() + 50)

	frame.Leader = raidRoles:CreateTexture(nil, "OVERLAY")
	frame.Leader:SetSizeToScale(12, 12)
	frame.Leader:SetTexture(LML_ICON_FILE)
	frame.Leader:SetTexCoord(0, 0.5, 0, 0.5)
	frame.Leader:SetVertexColor(1, 0.85, 0)
	frame.Leader:SetPointToScale("LEFT")

	frame.MasterLooter = raidRoles:CreateTexture(nil, "OVERLAY")
	frame.MasterLooter:SetSizeToScale(12, 12)
	frame.MasterLooter:SetTexture(LML_ICON_FILE)
	frame.MasterLooter:SetTexCoord(0.5, 1, 0, 0.5)
	frame.MasterLooter:SetVertexColor(1, 0.6, 0)
	frame.MasterLooter:SetPointToScale("RIGHT")

	frame.Leader.PostUpdate = MOD.RaidRoleUpdate;
	frame.MasterLooter.PostUpdate = MOD.RaidRoleUpdate;
	return raidRoles 
end 

function MOD:RaidRoleUpdate()
	local frame = self:GetParent()
	local leaderIcon = frame.Leader;
	local looterIcon = frame.MasterLooter;
	if not leaderIcon or not looterIcon then return end 
		local key = frame.___key;
		local db = SV.db.SVUnit[key];
		local leaderShown = leaderIcon:IsShown()
		local looterShown = looterIcon:IsShown()
		leaderIcon:ClearAllPoints()
		looterIcon:ClearAllPoints()
		if db and db.icons and db.icons.raidRoleIcons then
			local settings = db.icons.raidRoleIcons
			if leaderShown and settings.position == "TOPLEFT"then 
				leaderIcon:SetPointToScale("LEFT", frame, "LEFT")
				looterIcon:SetPointToScale("RIGHT", frame, "RIGHT")
			elseif leaderShown and settings.position == "TOPRIGHT" then 
				leaderIcon:SetPointToScale("RIGHT", frame, "RIGHT")
				looterIcon:SetPointToScale("LEFT", frame, "LEFT")
			elseif looterShown and settings.position == "TOPLEFT" then 
				looterIcon:SetPointToScale("LEFT", frame, "LEFT")
			else 
			looterIcon:SetPointToScale("RIGHT", frame, "RIGHT")
		end 
	end 
end
--[[ 
########################################################## 
PLAYER ONLY COMPONENTS
##########################################################
]]--
function MOD:CreateRestingIndicator(frame)
	local resting = CreateFrame("Frame",nil,frame)
	resting:SetFrameStrata("MEDIUM")
	resting:SetFrameLevel(20)
	resting:SetSizeToScale(26,26)
	resting:SetPointToScale("TOPRIGHT",frame,3,3)
	resting.bg = resting:CreateTexture(nil,"OVERLAY",nil,1)
	resting.bg:SetAllPoints(resting)
	resting.bg:SetTexture(STATE_ICON_FILE)
	resting.bg:SetTexCoord(0.5,1,0,0.5)
	return resting 
end 

function MOD:CreateCombatIndicator(frame)
	local combat = CreateFrame("Frame",nil,frame)
	combat:SetFrameStrata("MEDIUM")
	combat:SetFrameLevel(30)
	combat:SetSizeToScale(26,26)
	combat:SetPointToScale("TOPRIGHT",frame,3,3)
	combat.bg = combat:CreateTexture(nil,"OVERLAY",nil,5)
	combat.bg:SetAllPoints(combat)
	combat.bg:SetTexture(STATE_ICON_FILE)
	combat.bg:SetTexCoord(0,0.5,0,0.5)
	SV.Animate:Pulse(combat)
	combat:SetScript("OnShow", function(this)
		if not this.anim:IsPlaying() then this.anim:Play() end 
	end)
	
	combat:Hide()
	return combat 
end 

local ExRep_OnEnter = function(self)if self:IsShown() then UIFrameFadeIn(self,.1,0,1) end end 
local ExRep_OnLeave = function(self)if self:IsShown() then UIFrameFadeOut(self,.2,1,0) end end 

function MOD:CreateExperienceRepBar(frame)
	local db = SV.db.SVUnit.player;
	
	if db.playerExpBar then 
		local xp = CreateFrame("StatusBar", "PlayerFrameExperienceBar", frame.Power)
		xp:SetAllPointsIn(frame.Power, 0, 0)
		xp:SetStylePanel("Default")
		xp:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
		xp:SetStatusBarColor(0, 0.1, 0.6)
		--xp:SetBackdropColor(1, 1, 1, 0.8)
		xp:SetFrameLevel(xp:GetFrameLevel() + 2)
		xp.Tooltip = true;
		xp.Rested = CreateFrame("StatusBar", nil, xp)
		xp.Rested:SetAllPoints(xp)
		xp.Rested:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
		xp.Rested:SetStatusBarColor(1, 0, 1, 0.6)
		xp.Value = xp:CreateFontString(nil, "TOOLTIP")
		xp.Value:SetAllPoints(xp)
		xp.Value:FontManager("default")
		xp.Value:SetTextColor(0.2, 0.75, 1)
		xp.Value:SetShadowColor(0, 0, 0, 0)
		xp.Value:SetShadowOffset(0, 0)
		frame:Tag(xp.Value, "[curxp] / [maxxp]")
		xp.Rested:SetBackdrop({bgFile = [[Interface\BUTTONS\WHITE8X8]]})
		xp.Rested:SetBackdropColor(unpack(SV.Media.color.default))
		xp:SetScript("OnEnter", ExRep_OnEnter)
		xp:SetScript("OnLeave", ExRep_OnLeave)
		xp:SetAlpha(0)
		frame.Experience = xp 
	end 

	if db.playerRepBar then 
		local rep = CreateFrame("StatusBar", "PlayerFrameReputationBar", frame.Power)
		rep:SetAllPointsIn(frame.Power, 0, 0)
		rep:SetStylePanel("Default")
		rep:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
		rep:SetStatusBarColor(0, 0.6, 0)
		--rep:SetBackdropColor(1, 1, 1, 0.8)
		rep:SetFrameLevel(rep:GetFrameLevel() + 2)
		rep.Tooltip = true;
		rep.Value = rep:CreateFontString(nil, "TOOLTIP")
		rep.Value:SetAllPoints(rep)
		rep.Value:FontManager("default")
		rep.Value:SetTextColor(0.1, 1, 0.2)
		rep.Value:SetShadowColor(0, 0, 0, 0)
		rep.Value:SetShadowOffset(0, 0)
		frame:Tag(rep.Value, "[standing]: [currep] / [maxrep]")
		rep:SetScript("OnEnter", ExRep_OnEnter)
		rep:SetScript("OnLeave", ExRep_OnLeave)
		rep:SetAlpha(0)
		frame.Reputation = rep 
	end 
end 
--[[ 
########################################################## 
TARGET ONLY COMPONENTS
##########################################################
]]--
function MOD:CreateXRay(frame)
	local xray = CreateFrame("Button", "SVUI_XRayFocus", frame, "SecureActionButtonTemplate")
	xray:EnableMouse(true)
	xray:RegisterForClicks("AnyUp")
	xray:SetAttribute("type", "macro")
	xray:SetAttribute("macrotext", "/focus")
	xray:SetSizeToScale(64,64)
	xray:SetFrameStrata("MEDIUM")
	xray.icon = xray:CreateTexture(nil,"ARTWORK")
	xray.icon:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\UNIT-XRAY")
	xray.icon:SetAllPoints(xray)
	xray.icon:SetAlpha(0)
	xray:SetScript("OnLeave", function(self) GameTooltip:Hide() self.icon:SetAlpha(0) end)
	xray:SetScript("OnEnter", function(self)
		self.icon:SetAlpha(1)
		local anchor1, anchor2 = SV:GetScreenXY(self) 
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint(anchor1, self, anchor2)
		GameTooltip:SetText(FOCUSTARGET)
	end)
	return xray 
end 

function MOD:CreateXRay_Closer(frame)
	local close = CreateFrame("Button", "SVUI_XRayFocusClear", frame, "SecureActionButtonTemplate")
	close:EnableMouse(true)
	close:RegisterForClicks("AnyUp")
	close:SetAttribute("type", "macro")
	close:SetAttribute("macrotext", "/clearfocus")
	close:SetSizeToScale(50,50)
	close:SetFrameStrata("MEDIUM")
	close.icon = close:CreateTexture(nil,"ARTWORK")
	close.icon:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\UNIT-XRAY-CLOSE")
	close.icon:SetAllPoints(close)
	close.icon:SetAlpha(0)
	close.icon:SetVertexColor(1,0.2,0.1)
	close:SetScript("OnLeave", function(self) GameTooltip:Hide() self.icon:SetAlpha(0) end)
	close:SetScript("OnEnter",function(self)
		self.icon:SetAlpha(1)
		local anchor1, anchor2 = SV:GetScreenXY(self) 
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint(anchor1, self, anchor2)
		GameTooltip:SetText(CLEAR_FOCUS)
	end)
	return close 
end
--[[ 
########################################################## 
HEAL PREDICTION
##########################################################
]]--
local OverrideUpdate = function(self, event, unit)
	if(self.unit ~= unit) or not unit then return end

	local hp = self.HealPrediction
	hp.parent = self
	local hbar = self.Health;
	local anchor, relative, relative2 = 'TOPLEFT', 'BOTTOMRIGHT', 'BOTTOMLEFT';
	local reversed = true
	hp.reversed = hbar.fillInverted or false
	if(hp.reversed == true) then
		anchor, relative, relative2 = 'TOPRIGHT', 'BOTTOMLEFT', 'BOTTOMRIGHT';
		reversed = false
	end

	local myIncomingHeal = UnitGetIncomingHeals(unit, 'player') or 0
	local allIncomingHeal = UnitGetIncomingHeals(unit) or 0
	local totalAbsorb = UnitGetTotalAbsorbs(unit) or 0
	local myCurrentHealAbsorb = UnitGetTotalHealAbsorbs(unit) or 0
	local health, maxHealth = UnitHealth(unit), UnitHealthMax(unit)

	local overHealAbsorb = false
	if(health < myCurrentHealAbsorb) then
		overHealAbsorb = true
		myCurrentHealAbsorb = health
	end

	if(health - myCurrentHealAbsorb + allIncomingHeal > maxHealth * hp.maxOverflow) then
		allIncomingHeal = maxHealth * hp.maxOverflow - health + myCurrentHealAbsorb
	end

	local otherIncomingHeal = 0
	if(allIncomingHeal < myIncomingHeal) then
		myIncomingHeal = allIncomingHeal
	else
		otherIncomingHeal = allIncomingHeal - myIncomingHeal
	end

	local overAbsorb = false
	if(health - myCurrentHealAbsorb + allIncomingHeal + totalAbsorb >= maxHealth or health + totalAbsorb >= maxHealth) then
		if(totalAbsorb > 0) then
			overAbsorb = true
		end

		if(allIncomingHeal > myCurrentHealAbsorb) then
			totalAbsorb = max(0, maxHealth - (health - myCurrentHealAbsorb + allIncomingHeal))
		else
			totalAbsorb = max(0, maxHealth - health)
		end
	end

	if(myCurrentHealAbsorb > allIncomingHeal) then
		myCurrentHealAbsorb = myCurrentHealAbsorb - allIncomingHeal
	else
		myCurrentHealAbsorb = 0
	end

	local barMin, barMax, barMod = 0, maxHealth, 1;

	local previous = hbar:GetStatusBarTexture()
	if(hp.myBar) then
		hp.myBar:SetMinMaxValues(barMin, barMax)
		if(not hp.otherBar) then
			hp.myBar:SetValue(allIncomingHeal)
		else
			hp.myBar:SetValue(myIncomingHeal)
		end
		hp.myBar:SetPoint(anchor, hbar, anchor, 0, 0)
		hp.myBar:SetPoint(relative, previous, relative, 0, 0)
		hp.myBar:SetReverseFill(reversed)
		previous = hp.myBar
		hp.myBar:Show()
	end

	if(hp.absorbBar) then
		hp.absorbBar:SetMinMaxValues(barMin, barMax)
		hp.absorbBar:SetValue(totalAbsorb)
		hp.absorbBar:SetAllPoints(hbar)
		hp.absorbBar:SetReverseFill(not reversed)
		hp.absorbBar:Show()
	end

	if(hp.healAbsorbBar) then
		hp.healAbsorbBar:SetMinMaxValues(barMin, barMax)
		hp.healAbsorbBar:SetValue(myCurrentHealAbsorb)
		hp.healAbsorbBar:SetPoint(anchor, hbar, anchor, 0, 0)
		hp.healAbsorbBar:SetPoint(relative, previous, relative, 0, 0)
		hp.healAbsorbBar:SetReverseFill(reversed)
		previous = hp.healAbsorbBar
		hp.healAbsorbBar:Show()
	end
end

function MOD:CreateHealPrediction(frame, fullSet)
	local health = frame.Health;
	local isReversed = false
	if(health.fillInverted and health.fillInverted == true) then
		isReversed = true
	end
	local hTex = health:GetStatusBarTexture()
	local myBar = CreateFrame('StatusBar', nil, health)
	myBar:SetFrameStrata("LOW")
	myBar:SetFrameLevel(6)
	myBar:SetStatusBarTexture([[Interface\BUTTONS\WHITE8X8]])
	myBar:SetStatusBarColor(0.15, 0.7, 0.05, 0.9)

	local absorbBar = CreateFrame('StatusBar', nil, health)
	absorbBar:SetFrameStrata("LOW")
	absorbBar:SetFrameLevel(7)
	absorbBar:SetStatusBarTexture(SV.Media.bar.gradient)
	absorbBar:SetStatusBarColor(1, 1, 0, 0.5)

	local healPrediction = {
		myBar = myBar,
		absorbBar = absorbBar,
		maxOverflow = 1,
		reversed = isReversed,
		Override = OverrideUpdate
	}

	if(fullSet) then
		local healAbsorbBar = CreateFrame('StatusBar', nil, health)
		healAbsorbBar:SetFrameStrata("LOW")
		healAbsorbBar:SetFrameLevel(9)
		healAbsorbBar:SetStatusBarTexture(SV.Media.bar.gradient)
		healAbsorbBar:SetStatusBarColor(0.5, 0.2, 1, 0.9)
		healPrediction["healAbsorbBar"] = healAbsorbBar;
	end

	return healPrediction
end 