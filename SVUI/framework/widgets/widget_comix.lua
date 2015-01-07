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
local SV = select(2, ...)
local L = SV.L

SV.Comix = _G["SVUI_ComixFrame"];
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local animReady = true;

local COMIX_DATA = {
	{
		{0,0.25,0,0.25},
		{0.25,0.5,0,0.25},
		{0.5,0.75,0,0.25},
		{0.75,1,0,0.25},
		{0,0.25,0.25,0.5},
		{0.25,0.5,0.25,0.5},
		{0.5,0.75,0.25,0.5},
		{0.75,1,0.25,0.5},
		{0,0.25,0.5,0.75},
		{0.25,0.5,0.5,0.75},
		{0.5,0.75,0.5,0.75},
		{0.75,1,0.5,0.75},
		{0,0.25,0.75,1},
		{0.25,0.5,0.75,1},
		{0.5,0.75,0.75,1},
		{0.75,1,0.75,1}
	},
	{
		{220, 210, 50, -50, 220, 210, -1, 5},
	    {230, 210, 50, 5, 280, 210, -5, 1},
	    {280, 160, 1, 50, 280, 210, -1, 5},
	    {220, 210, 50, -50, 220, 210, -1, 5},
	    {210, 190, 50, 50, 220, 210, -1, 5},
	    {220, 210, 50, -50, 220, 210, -1, 5},
	    {230, 210, 50, 5, 280, 210, -5, 1},
	    {280, 160, 1, 50, 280, 210, -1, 5},
	    {220, 210, 50, -50, 220, 210, -1, 5},
	    {210, 190, 50, 50, 220, 210, -1, 5},
	    {220, 210, 50, -50, 220, 210, -1, 5},
	    {230, 210, 50, 5, 280, 210, -5, 1},
	    {280, 160, 1, 50, 280, 210, -1, 5},
	    {220, 210, 50, -50, 220, 210, -1, 5},
	    {210, 190, 50, 50, 220, 210, -1, 5},
	    {210, 190, 50, 50, 220, 210, -1, 5}
	}
};

local function ComixReadyState(state)
	if(state == nil) then return animReady end
	animReady = state
end

local Comix_OnUpdate = function() ComixReadyState(true) end
local Toasty_OnUpdate = function(self) ComixReadyState(true); self.parent:SetAlpha(0) end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function SV.Comix:LaunchPremiumPopup()
	ComixReadyState(false)

	local rng = random(1, 16);
	local coords = COMIX_DATA[1][rng];
	local offsets = COMIX_DATA[2][rng]

	self.Premium.tex:SetTexCoord(coords[1],coords[2],coords[3],coords[4])
	self.Premium.bg.tex:SetTexCoord(coords[1],coords[2],coords[3],coords[4])
	self.Premium.anim[1]:SetOffset(offsets[1],offsets[2])
	self.Premium.anim[2]:SetOffset(offsets[3],offsets[4])
	self.Premium.anim[3]:SetOffset(0,0)
	self.Premium.bg.anim[1]:SetOffset(offsets[5],offsets[6])
	self.Premium.bg.anim[2]:SetOffset(offsets[7],offsets[8])
	self.Premium.bg.anim[3]:SetOffset(0,0)
	self.Premium.anim:Play()
	self.Premium.bg.anim:Play() 
end

function SV.Comix:LaunchPopup()
	ComixReadyState(false)

	local coords, step1_x, step1_y, step2_x, step2_y, size;
	local rng = random(1, 32);

	if(rng > 16) then
		local key = rng - 16;
		coords = COMIX_DATA[1][key];
		step1_x = random(-150, 150);
		if(step1_x > -20 and step1_x < 20) then step1_x = step1_x * 3 end
		step1_y = random(50, 150);
		step2_x = step1_x * 0.5;
		step2_y = step1_y * 0.75;
		self.Deluxe.tex:SetTexCoord(coords[1],coords[2],coords[3],coords[4]);
		self.Deluxe.anim[1]:SetOffset(step1_x, step1_y);
		self.Deluxe.anim[2]:SetOffset(step2_x, step2_y);
		self.Deluxe.anim[3]:SetOffset(0,0);
		self.Deluxe.anim:Play();
	else
		coords = COMIX_DATA[1][rng];
		step1_x = random(-100, 100);
		step1_y = random(-50, 1);
		size = random(96,128);
		self.Basic:SetSizeToScale(size,size);
		self.Basic.tex:SetTexCoord(coords[1],coords[2],coords[3],coords[4]);
		self.Basic:ClearAllPoints();
		self.Basic:SetPointToScale("CENTER", SV.Screen, "CENTER", step1_x, step1_y);
		self.Basic.anim:Play();
	end
end 

local Comix_OnEvent = function(self, event, ...)
	local _, subEvent, _, guid = ...;
	if((subEvent == "PARTY_KILL" and guid == UnitGUID('player')) and ComixReadyState()) then
		self:LaunchPopup()
	end  
end

function SV.Comix:Toggle()
	if(not SV.db.general.comix) then 
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:SetScript("OnEvent", nil)
	else 
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:SetScript("OnEvent", Comix_OnEvent)
	end 
end 

function SV:ToastyKombat()
	ComixToastyPanelBG.anim[2]:SetOffset(256, -256)
	ComixToastyPanelBG.anim[2]:SetOffset(0, 0)
	ComixToastyPanelBG.anim:Play()
	PlaySoundFile([[Interface\AddOns\SVUI\assets\sounds\toasty.mp3]])
end 

function SV.Comix:Initialize()
	self.Basic = _G["SVUI_ComixPopup1"]
	self.Deluxe = _G["SVUI_ComixPopup2"]
	self.Premium = _G["SVUI_ComixPopup3"]

	self.Basic:SetParent(SV.Screen)
	self.Basic:SetSizeToScale(128,128)
	self.Basic.tex:SetTexCoord(0,0.25,0,0.25)
	SV.Animate:Kapow(self.Basic, true, true)
	self.Basic:SetAlpha(0)
	self.Basic.anim[2]:SetScript("OnFinished", Comix_OnUpdate)

	self.Deluxe:SetParent(SV.Screen)
	self.Deluxe:SetSizeToScale(128,128)
	self.Deluxe.tex:SetTexCoord(0,0.25,0,0.25)
	SV.Animate:RandomSlide(self.Deluxe, true)
	self.Deluxe:SetAlpha(0)
	self.Deluxe.anim[3]:SetScript("OnFinished", Comix_OnUpdate)

	self.Premium:SetParent(SV.Screen)
	self.Premium.tex:SetTexCoord(0,0.25,0,0.25)
	SV.Animate:RandomSlide(self.Premium, true)
	self.Premium:SetAlpha(0)
	self.Premium.anim[3]:SetScript("OnFinished", Comix_OnUpdate)

	self.Premium.bg.tex:SetTexCoord(0,0.25,0,0.25)
	SV.Animate:RandomSlide(self.Premium.bg, false)
	self.Premium.bg:SetAlpha(0)
	self.Premium.bg.anim[3]:SetScript("OnFinished", Comix_OnUpdate)

	--MOD
	local toasty = CreateFrame("Frame", "ComixToastyPanelBG", SV.Screen)
	toasty:SetSize(256, 256)
	toasty:SetFrameStrata("DIALOG")
	toasty:SetPointToScale("BOTTOMRIGHT", SV.Screen, "BOTTOMRIGHT", 0, 0)
	toasty.tex = toasty:CreateTexture(nil, "ARTWORK")
	toasty.tex:SetAllPointsIn(toasty)
	toasty.tex:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Doodads\TOASTY]])
	SV.Animate:Slide(toasty, 256, -256, true)
	toasty:SetAlpha(0)
	toasty.anim[4]:SetScript("OnFinished", Toasty_OnUpdate)

	ComixReadyState(true)

	self:Toggle()
end