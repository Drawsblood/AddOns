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
if(SV.class ~= "MAGE") then return end 
local MOD = SV.SVUnit
if(not MOD) then return end 

local specEffects = { [1] = "arcane", [2] = "none", [3] = "none" };
--[[ 
########################################################## 
POSITIONING
##########################################################
]]--
local Reposition = function(self)
	local db = SV.db.SVUnit.player
	local bar = self.ArcaneChargeBar;
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
		bar[i]:SetHeight(size)
		bar[i]:SetWidth(size)
		bar[i]:SetStatusBarColor(0.15, 0.65, 0.85)
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
local PreUpdate = function(self, spec)
	if(self.CurrentSpec ~= spec) then
		local effectName = specEffects[spec]
		if(effectName and effectName ~= 'none') then
			if(not self:IsShown()) then
				self:Show()
			end
			for i = 1, 4 do
				self[i].FX:SetEffect(effectName)
			end
		else
			self:Hide()
		end
		self.CurrentSpec = spec
	end
end

local ChargeUpdate = function(self)
	if not self.fg:IsShown() then self.fg:Show() end
	if not self.fg.anim:IsPlaying() then self.fg.anim:Play() end 
end

function MOD:CreateClassBar(playerFrame)
	local max = 4
	local bar = CreateFrame("Frame",nil,playerFrame)
	bar:SetFrameLevel(playerFrame.TextGrip:GetFrameLevel() + 30)

	for i = 1, max do 
		bar[i] = CreateFrame("StatusBar", nil, bar)
		bar[i]:SetStatusBarTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\ORB")
		bar[i]:GetStatusBarTexture():SetHorizTile(false)
		bar[i]:SetOrientation("VERTICAL")
		bar[i].noupdate = true;

		bar[i].bg = bar[i]:CreateTexture(nil, "BACKGROUND")
		bar[i].bg:SetAllPoints(bar[i])
		bar[i].bg:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\ORB-BG");

		bar[i].fg = bar[i]:CreateTexture(nil, "OVERLAY")
		bar[i].fg:SetAllPoints(bar[i])
		bar[i].fg:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\MAGE-BG-ANIMATION")
		bar[i].fg:SetBlendMode("ADD")
		bar[i].fg:SetVertexColor(0.5,0.6,0.6)
		bar[i].fg:SetTexCoord(0,0.25,0,1)

		--bar[i].Update = ChargeUpdate

		local spec = GetSpecialization()
		local effectName = specEffects[spec]
		SV.SpecialFX:SetFXFrame(bar[i], effectName)
	end 

	bar.PreUpdate = PreUpdate;
	local classBarHolder = CreateFrame("Frame", "Player_ClassBar", bar)
	classBarHolder:SetPointToScale("TOPLEFT", playerFrame, "BOTTOMLEFT", 0, -2)
	bar:SetPoint("TOPLEFT", classBarHolder, "TOPLEFT", 0, 0)
	bar.Holder = classBarHolder
	SV.Mentalo:Add(bar.Holder, L["Classbar"])

	playerFrame.MaxClassPower = max;
	playerFrame.ClassBarRefresh = Reposition;
	playerFrame.ArcaneChargeBar = bar
	return 'ArcaneChargeBar' 
end 