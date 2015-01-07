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
if(SV.class ~= "ROGUE") then return end 
local MOD = SV.SVUnit
if(not MOD) then return end 
--[[ 
########################################################## 
LOCALS
##########################################################
]]--
local TRACKER_FONT = [[Interface\AddOns\SVUI\assets\fonts\Combo.ttf]]
local ICON_FILE = [[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\ROGUE]];
local ICON_COORDS = {
	{0,0.5,0,0.5},
	{0.5,1,0,0.5},
	{0,0.5,0.5,1},
	{0.5,1,0.5,1},
};
local cpointColor = {
	{0.69,0.31,0.31},
	{0.69,0.31,0.31},
	{0.65,0.63,0.35},
	{0.65,0.63,0.35},
	{0.33,0.59,0.33}
};
--[[ 
########################################################## 
POSITIONING
##########################################################
]]--
local Reposition = function(self)
	local db = SV.db.SVUnit.player
	local bar = self.HyperCombo;
	if not db then return end
	local height = db.classbar.height
	local width = height * 3;
	local textwidth = height * 1.25;
	bar.Holder:SetSizeToScale(width, height)
    if(not db.classbar.detachFromFrame) then
    	SV.Mentalo:Reset(L["Classbar"])
    end
    local holderUpdate = bar.Holder:GetScript('OnSizeChanged')
    if holderUpdate then
        holderUpdate(bar.Holder)
    end

    bar:ClearAllPoints()
    bar:SetAllPoints(bar.Holder)

    local points = bar.Combo;
	local max = MAX_COMBO_POINTS;
	local size = height - 4
	points:ClearAllPoints()
	points:SetAllPoints(bar)
	for i = 1, max do
		points[i]:ClearAllPoints()
		points[i]:SetSizeToScale(size, size)
		points[i].Icon:ClearAllPoints()
		points[i].Icon:SetAllPoints(points[i])
		if i==1 then 
			points[i]:SetPoint("LEFT", points)
		else 
			points[i]:SetPointToScale("LEFT", points[i - 1], "RIGHT", -2, 0) 
		end
	end

	if(bar.Guile) then
		bar.Guile:ClearAllPoints()
		bar.Guile:SetHeight(size)
		bar.Guile:SetWidth(textwidth)
		bar.Guile:SetPoint("LEFT", points, "RIGHT", -2, 0)
		bar.Guile.Text:ClearAllPoints()
		bar.Guile.Text:SetAllPoints(bar.Guile)
		bar.Guile.Text:SetFont(TRACKER_FONT, size, 'OUTLINE')
	end
end
--[[ 
########################################################## 
ROGUE COMBO POINTS
##########################################################
]]--
local ShowPoint = function(self)
	self:SetAlpha(1)
end 

local HidePoint = function(self)
	local coords = ICON_COORDS[random(2,4)];
	self.Icon:SetTexCoord(coords[1],coords[2],coords[3],coords[4])
	self:SetAlpha(0)
end
--[[ 
########################################################## 
ROGUE COMBO TRACKER
##########################################################
]]--
function MOD:CreateClassBar(playerFrame)
	local max = 5
	local size = 30
	local coords

	local bar = CreateFrame("Frame", nil, playerFrame)
	bar:SetFrameStrata("DIALOG")

	bar.Combo = CreateFrame("Frame",nil,bar)
	for i = 1, max do 
		local cpoint = CreateFrame('Frame',nil,bar.Combo)
		cpoint:SetSizeToScale(size,size)

		local icon = cpoint:CreateTexture(nil,"OVERLAY",nil,1)
		icon:SetSizeToScale(size,size)
		icon:SetPoint("CENTER")
		icon:SetBlendMode("BLEND")
		icon:SetTexture(ICON_FILE)

		coords = ICON_COORDS[random(2,4)]
		icon:SetTexCoord(coords[1],coords[2],coords[3],coords[4])
		cpoint.Icon = icon

		bar.Combo[i] = cpoint 
	end 

	bar.PointShow = ShowPoint;
	bar.PointHide = HidePoint;

	local guile = CreateFrame('Frame',nil,bar)
	guile:SetFrameStrata("DIALOG")
	guile:SetSizeToScale(30,30)

	guile.Text = guile:CreateFontString(nil,'OVERLAY')
	guile.Text:SetAllPoints(guile)
	guile.Text:SetFont(TRACKER_FONT,30,'OUTLINE')
	guile.Text:SetTextColor(1,1,1)

	bar.Guile = guile;

	local classBarHolder = CreateFrame("Frame", "Player_ClassBar", bar)
	classBarHolder:SetPointToScale("TOPLEFT", playerFrame, "BOTTOMLEFT", 0, -2)
	bar:SetPoint("TOPLEFT", classBarHolder, "TOPLEFT", 0, 0)
	bar.Holder = classBarHolder
	SV.Mentalo:Add(bar.Holder, L["Classbar"])

	playerFrame.MaxClassPower = 5;
	playerFrame.ClassBarRefresh = Reposition;
	playerFrame.HyperCombo = bar
	return 'HyperCombo' 
end 