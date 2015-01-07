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
local GameMenuFrame = _G.GameMenuFrame
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...);

SV.GameMenu = _G["SVUI_GameMenuFrame"];

--[[
141 - kneel loop
138 - craft loop
120 - half-crouch loop
119 - stealth walk
111 - attack ready
55 - roar pose (paused)
40 - falling loop
203 - cannibalize
225 - cower loop

]]--
local Sequences = {
	--{65, 1000}, --shrug
	--{120, 1000}, --stealth
	--{74, 1000}, --roar
	--{203, 1000}, --cannibalize
	--{119, 1000}, --stealth walk
	--{125, 1000}, --spell2
	--{225, 1000}, --cower
	{26, 1000}, --attack
	{52, 1000}, --attack
	--{138, 1000}, --craft
	{111, 1000}, --attack ready
	--{4, 1000}, --walk
	--{5, 1000}, --run
	{69, 1000}, --dance
};

local function rng()
	return random(1, #Sequences)
end

local Activate = function(self)
	if(SV.db.general.gamemenu == 'NONE') then
		self:Toggle()
		return
	end

	local key = rng()
	local emote = Sequences[key][1]
	self:SetAlpha(1)
	self.ModelLeft:SetAnimation(emote)
	self.ModelRight:SetAnimation(69)
end

function SV.GameMenu:Initialize()
	self:SetFrameLevel(0)
	self:SetAllPoints(SV.Screen)

	self.ModelLeft:SetUnit("player")
	self.ModelLeft:SetRotation(1)
	self.ModelLeft:SetPortraitZoom(0.05)
	self.ModelLeft:SetPosition(0,0,-0.25)

	if(SV.db.general.gamemenu == '1') then
		self.ModelRight:SetDisplayInfo(49084)
		self.ModelRight:SetRotation(-1)
		self.ModelRight:SetCamDistanceScale(1.9)
		self.ModelRight:SetFacing(6)
		self.ModelRight:SetPosition(0,0,-0.3)
	elseif(SV.db.general.gamemenu == '2') then
		self.ModelRight:SetUnit("player")
		self.ModelRight:SetRotation(-1)
		self.ModelRight:SetCamDistanceScale(1.9)
		self.ModelRight:SetFacing(6)
		self.ModelRight:SetPosition(0,0,-0.3)
	end

	-- local effectFrame = CreateFrame("PlayerModel", nil, self.ModelRight)
	-- effectFrame:SetAllPoints(self.ModelRight)
	-- effectFrame:SetCamDistanceScale(1)
	-- effectFrame:SetPortraitZoom(0)
	-- effectFrame:SetModel([[Spells\Blackmagic_precast_base.m2]])

	-- local splash = self:CreateTexture(nil, "OVERLAY")
	-- splash:SetSize(600, 300)
	-- splash:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\SPLASH-BLACK")
	-- splash:SetBlendMode("ADD")
	-- splash:SetPoint("TOP", 0, 0)

	self:SetScript("OnShow", Activate)
end

function SV.GameMenu:Toggle()
	if(SV.db.general.gamemenu ~= 'NONE') then
		self:Show()
		self:SetScript("OnShow", Activate)
	else
		self:Hide()
		self:SetScript("OnShow", nil)
	end
end