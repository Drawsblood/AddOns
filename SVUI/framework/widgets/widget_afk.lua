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
local unpack 	= _G.unpack;
local select 	= _G.select;
local math 		= _G.math;
--[[ MATH METHODS ]]--
local random = math.random;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...);

SV.AFK = _G["SVUI_AFKFrame"];

local AFK_SEQUENCES = {
	[1] = 120,
	[2] = 141,
	[3] = 119,
	[4] = 5,
};

function SV.AFK:Activate(enabled)
	if(InCombatLockdown()) then return end
	if(enabled) then
		local sequence = random(1, 4);
		if(not SV.db.general.afkNoMove) then
			MoveViewLeftStart(0.05);
		end
		self:Show();
		UIParent:Hide();
		self:SetAlpha(1);
		self.Model:SetAnimation(AFK_SEQUENCES[sequence])
		DoEmote("READ")
	else
		UIParent:Show();
		self:SetAlpha(0);
		self:Hide();
		if(not SV.db.general.afkNoMove) then
			MoveViewLeftStop();
		end
	end
end

local AFK_OnEvent = function(self, event)
	if(event == "PLAYER_REGEN_DISABLED") then
		self:RegisterEvent("PLAYER_REGEN_ENABLED", "OnEvent")
		self:Activate(false)
	else
		if(UnitIsAFK("player")) then
			self:Activate(true)
		else
			self:Activate(false)
		end
	end
end

function SV.AFK:Initialize()
	local classToken = select(2,UnitClass("player"))
	local color = CUSTOM_CLASS_COLORS[classToken]
	self.BG:SetVertexColor(color.r, color.g, color.b)
	self.BG:ClearAllPoints()
	self.BG:SetSizeToScale(500,600)
	self.BG:SetPointToScale("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)

	self:SetFrameLevel(0)
	self:SetAllPoints(SV.Screen)

	local narr = self.Model:CreateTexture(nil, "OVERLAY")
	narr:SetSizeToScale(300, 150)
	narr:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\AFK-NARRATIVE")
	narr:SetPointToScale("TOPLEFT", SV.Screen, "TOPLEFT", 15, -15)

	self.Model:ClearAllPoints()
	self.Model:SetSizeToScale(600,600)
	self.Model:SetPointToScale("BOTTOMRIGHT", self, "BOTTOMRIGHT", 64, -64)
	self.Model:SetUnit("player")
	self.Model:SetCamDistanceScale(1.15)
	self.Model:SetFacing(6)

	local splash = self.Model:CreateTexture(nil, "OVERLAY")
	splash:SetSizeToScale(350, 175)
	splash:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\PLAYER-AFK")
	splash:SetPointToScale("BOTTOMRIGHT", self.Model, "CENTER", -75, 75)

	self:Hide()
	if(SV.db.general.afk) then
		self:RegisterEvent("PLAYER_FLAGS_CHANGED")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		self:SetScript("OnEvent", AFK_OnEvent)
	end
end

function SV.AFK:Toggle()
	if(SV.db.general.afk) then
		self:RegisterEvent("PLAYER_FLAGS_CHANGED")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		self:SetScript("OnEvent", AFK_OnEvent)
	else
		self:UnregisterEvent("PLAYER_FLAGS_CHANGED")
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		self:SetScript("OnEvent", nil)
	end
end