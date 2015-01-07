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
if(SV.class ~= "SHAMAN") then return end 
local MOD = SV.SVUnit
if(not MOD) then return end 
--[[ 
########################################################## 
LOCALS
##########################################################
]]--
local totemMax = MAX_TOTEMS
local totemPriorities = SHAMAN_TOTEM_PRIORITIES or {1, 2, 3, 4};
local totemTextures = {
	[EARTH_TOTEM_SLOT] 	= [[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\SHAMAN-EARTH]],
	[FIRE_TOTEM_SLOT] 	= [[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\SHAMAN-FIRE]],
	[WATER_TOTEM_SLOT] 	= [[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\SHAMAN-WATER]],
	[AIR_TOTEM_SLOT] 	= [[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\SHAMAN-AIR]],
};
--[[ 
########################################################## 
POSITIONING
##########################################################
]]--
local Reposition = function(self)
	local db = SV.db.SVUnit.player
	local bar = self.TotemBars
	local size = db.classbar.height
	local width = size * totemMax
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
	for i = 1, totemMax do
		bar[i]:ClearAllPoints()
		bar[i]:SetHeight(size)
		bar[i]:SetWidth(size)
		bar[i]:GetStatusBarTexture():SetHorizTile(false)
		if i==1 then 
			bar[i]:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
		else 
			bar[i]:SetPointToScale("LEFT", bar[i - 1], "RIGHT", -1, 0) 
		end
	end 
end 
--[[ 
########################################################## 
SHAMAN
##########################################################
]]--
function MOD:CreateClassBar(playerFrame)
	local bar = CreateFrame("Frame",nil,playerFrame)
	bar:SetFrameLevel(playerFrame.TextGrip:GetFrameLevel() + 30)
	for i=1, totemMax do
		local iconfile = totemTextures[totemPriorities[i]]
		bar[i] = CreateFrame("StatusBar",nil,bar)
		bar[i]:SetStatusBarTexture(iconfile)
		bar[i]:GetStatusBarTexture():SetHorizTile(false)
		bar[i]:SetOrientation("VERTICAL")
		bar[i].noupdate=true;
		bar[i].backdrop = bar[i]:CreateTexture(nil,"BACKGROUND")
		bar[i].backdrop:SetAllPoints(bar[i])
		bar[i].backdrop:SetTexture(iconfile)
		bar[i].backdrop:SetDesaturated(true)
		bar[i].backdrop:SetVertexColor(0.2,0.2,0.2,0.7)
	end 

	local classBarHolder = CreateFrame("Frame", "Player_ClassBar", bar)
	classBarHolder:SetPointToScale("TOPLEFT", playerFrame, "BOTTOMLEFT", 0, -2)
	bar:SetPoint("TOPLEFT", classBarHolder, "TOPLEFT", 0, 0)
	bar.Holder = classBarHolder
	SV.Mentalo:Add(bar.Holder, L["Classbar"])

	playerFrame.MaxClassPower = totemMax;
	playerFrame.ClassBarRefresh = Reposition;
	playerFrame.TotemBars = bar
	return 'TotemBars' 
end 