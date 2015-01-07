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
local random,floor = math.random, math.floor;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local oUF_Villain = SV.oUF

assert(oUF_Villain, "SVUI was unable to locate oUF.")

local L = SV.L;
local LSM = LibStub("LibSharedMedia-3.0")
if(SV.class ~= "DRUID") then return end 
local MOD = SV.SVUnit
if(not MOD) then return end 
--[[ 
########################################################## 
DRUID ALT MANA
##########################################################
]]--
local TRACKER_FONT = [[Interface\AddOns\SVUI\assets\fonts\Combo.ttf]];
local cpointColor = {
	[1]={0.69,0.31,0.31},
	[2]={0.69,0.31,0.31},
	[3]={0.65,0.63,0.35},
	[4]={0.65,0.63,0.35},
	[5]={0.33,0.59,0.33}
};

local comboTextures = {
	[1]=[[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\DRUID-CLAW-UP]],
	[2]=[[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\DRUID-CLAW-DOWN]],
	[3]=[[Interface\Addons\SVUI\assets\artwork\Unitframe\Class\DRUID-BITE]],
};

local ShowPoint = function(self)
	self:SetAlpha(1)
end 

local HidePoint = function(self)
	self.Icon:SetTexture(comboTextures[random(1,3)])
	self:SetAlpha(0)
end 

local UpdateAltPower = function(self, unit, arg1, arg2)
	local value = self:GetParent().TextGrip.Power;
	if(arg1 ~= arg2) then 
		local color = oUF_Villain.colors.power.MANA
		color = SV:HexColor(color[1],color[2],color[3])
		local altValue = floor(arg1 / arg2 * 100)
		local altStr = ""
		if(value:GetText()) then 
			if(select(4, value:GetPoint()) < 0) then
				altStr = ("|cff%s%d%%|r |cffD7BEA5- |r"):format(color, altValue)
			else
				altStr = ("|cffD7BEA5-|r|cff%s%d%%|r"):format(color, altValue)
			end 
		else
			altStr = ("|cff%s%d%%|r"):format(color, altValue)
		end
		self.Text:SetText(altStr)
	else 
		self.Text:SetText()
	end 
end 
--[[ 
########################################################## 
POSITIONING
##########################################################
]]--
local Reposition = function(self)
	local bar = self.Druidness
	local chicken = bar.Chicken;
	local db = SV.db.SVUnit.player
	if not bar or not db then print("Error") return end
	local height = db.classbar.height
	local offset = (height - 10)
	local adjustedBar = (height * 1.5)
	local adjustedAnim = (height * 1.25)
	local scaled = (height * 0.8)
	local width = db.width * 0.4;

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

    chicken:ClearAllPoints()
    chicken:SetAllPoints()
	
	chicken.LunarBar:SetSizeToScale(width, adjustedBar)
	chicken.LunarBar:SetMinMaxValues(0,0)
	chicken.LunarBar:SetStatusBarColor(.13,.32,1)

	chicken.Moon:SetSizeToScale(height, height)
	chicken.Moon[1]:SetSizeToScale(adjustedAnim, adjustedAnim)
	chicken.Moon[2]:SetSizeToScale(scaled, scaled)

	chicken.SolarBar:SetSizeToScale(width, adjustedBar)
	chicken.SolarBar:SetMinMaxValues(0,0)
	chicken.SolarBar:SetStatusBarColor(1,1,0.21)

	chicken.Sun:SetSizeToScale(height, height)
	chicken.Sun[1]:SetSizeToScale(adjustedAnim, adjustedAnim)
	chicken.Sun[2]:SetSizeToScale(scaled, scaled)

	chicken.Text:SetPoint("TOPLEFT", chicken, "TOPLEFT", 10, 0)
	chicken.Text:SetPoint("BOTTOMRIGHT", chicken, "BOTTOMRIGHT", -10, 0)
	chicken.Text:SetFont(TRACKER_FONT, scaled, 'OUTLINE')

	local max = MAX_COMBO_POINTS;
	local cat = bar.Cat;
	local size = (height - 4)
	for i = 1, max do
		cat[i]:ClearAllPoints()
		cat[i]:SetSizeToScale(size, size)
		cat[i].Icon:ClearAllPoints()
		cat[i].Icon:SetAllPoints(cat[i])
		if i==1 then 
			cat[i]:SetPoint("LEFT", cat)
		else 
			cat[i]:SetPointToScale("LEFT", cat[i - 1], "RIGHT", -2, 0) 
		end
	end
end 
--[[ 
########################################################## 
DRUID ECLIPSE BAR
##########################################################
]]--
function MOD:CreateClassBar(playerFrame)
	local bar = CreateFrame('Frame', nil, playerFrame)
	bar:SetFrameLevel(playerFrame.TextGrip:GetFrameLevel() + 30)
	bar:SetSizeToScale(100,40)

	local chicken = CreateFrame('Frame', nil, bar)
	chicken:SetAllPoints(bar)

	local moon = CreateFrame('Frame', nil, chicken)
	moon:SetFrameLevel(chicken:GetFrameLevel() + 2)
	moon:SetSizeToScale(40, 40)
	moon:SetPoint("TOPLEFT", chicken, "TOPLEFT", 0, 0)

	moon[1] = moon:CreateTexture(nil, "BACKGROUND", nil, 1)
	moon[1]:SetSizeToScale(40, 40)
	moon[1]:SetPoint("CENTER")
	moon[1]:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\VORTEX")
	moon[1]:SetBlendMode("ADD")
	moon[1]:SetVertexColor(0, 0.5, 1)
	SV.Animate:Orbit(moon[1], 10, false)

	moon[2] = moon:CreateTexture(nil, "OVERLAY", nil, 2)
	moon[2]:SetSizeToScale(30, 30)
	moon[2]:SetPoint("CENTER")
	moon[2]:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\DRUID-MOON")
	moon[1]:Hide()
	chicken.Moon = moon;

	local lunar = CreateFrame('StatusBar', nil, chicken)
	lunar:SetPoint("LEFT", moon, "RIGHT", -10, 0)
	lunar:SetSizeToScale(100,40)
	lunar:SetStatusBarTexture(SV.Media.bar.lazer)
	lunar.noupdate = true;
	chicken.LunarBar = lunar;

	local solar = CreateFrame('StatusBar', nil, chicken)
	solar:SetPoint('LEFT', lunar:GetStatusBarTexture(), 'RIGHT')
	solar:SetSizeToScale(100,40)
	solar:SetStatusBarTexture(SV.Media.bar.lazer)
	solar.noupdate = true;
	chicken.SolarBar = solar;

	local sun = CreateFrame('Frame', nil, chicken)
	sun:SetFrameLevel(chicken:GetFrameLevel() + 2)
	sun:SetSizeToScale(40, 40)
	sun:SetPoint("LEFT", lunar, "RIGHT", -10, 0)
	sun[1] = sun:CreateTexture(nil, "BACKGROUND", nil, 1)
	sun[1]:SetSizeToScale(40, 40)
	sun[1]:SetPoint("CENTER")
	sun[1]:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\VORTEX")
	sun[1]:SetBlendMode("ADD")
	sun[1]:SetVertexColor(1, 0.5, 0)
	SV.Animate:Orbit(sun[1], 10, false)

	sun[2] = sun:CreateTexture(nil, "OVERLAY", nil, 2)
	sun[2]:SetSizeToScale(30, 30)
	sun[2]:SetPoint("CENTER")
	sun[2]:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\Class\\DRUID-SUN")
	sun[1]:Hide()
	chicken.Sun = sun;

	chicken.Text = lunar:CreateFontString(nil, 'OVERLAY')
	chicken.Text:SetPoint("TOPLEFT", chicken, "TOPLEFT", 10, 0)
	chicken.Text:SetPoint("BOTTOMRIGHT", chicken, "BOTTOMRIGHT", -10, 0)
	chicken.Text:SetFont(SV.Media.font.default, 16, "NONE")
	chicken.Text:SetShadowOffset(0,0)

	chicken.PostDirectionChange = {
		["sun"] = function(this)
			this.Text:SetJustifyH("LEFT")
			this.Text:SetText(" >")
			this.Text:SetTextColor(0.2, 1, 1, 0.5)
			this.Sun[1]:Hide()
			this.Sun[1].anim:Finish()
			this.Moon[1]:Show()
			this.Moon[1].anim:Play()
		end,
		["moon"] = function(this)
			this.Text:SetJustifyH("RIGHT")
			this.Text:SetText("< ")
			this.Text:SetTextColor(1, 0.5, 0, 0.5)
			this.Moon[1]:Hide()
			this.Moon[1].anim:Finish()
			this.Sun[1]:Show()
			this.Sun[1].anim:Play()
		end,
		["none"] = function(this)
			this.Text:SetJustifyH("CENTER")
			this.Text:SetText()
			this.Sun[1]:Hide()
			this.Sun[1].anim:Finish()
			this.Moon[1]:Hide()
			this.Moon[1].anim:Finish()
		end
	}

	local cat = CreateFrame('Frame',nil,bar)
	cat:SetAllPoints(bar)
	local max = MAX_COMBO_POINTS;
	for i = 1, max do 
		local cpoint = CreateFrame('Frame',nil,cat)
		cpoint:SetSizeToScale(size,size)

		local icon = cpoint:CreateTexture(nil,"OVERLAY",nil,1)
		icon:SetSizeToScale(size,size)
		icon:SetPoint("CENTER")
		icon:SetBlendMode("BLEND")
		icon:SetTexture(comboTextures[random(1,3)])
		cpoint.Icon = icon

		cat[i] = cpoint 
	end
	cat.PointShow = ShowPoint;
	cat.PointHide = HidePoint;

	local mana = CreateFrame("Frame", nil, playerFrame)
	mana:SetFrameStrata("LOW")
	mana:SetAllPointsIn(bar, 2, 4)
	mana:SetStylePanel("Fixed", "Default")
	mana:SetFrameLevel(mana:GetFrameLevel() + 1)
	mana.colorPower = true;
	mana.PostUpdatePower = UpdateAltPower;
	mana.ManaBar = CreateFrame("StatusBar", nil, mana)
	mana.ManaBar.noupdate = true;
	mana.ManaBar:SetStatusBarTexture(SV.Media.bar.glow)
	mana.ManaBar:SetAllPointsIn(mana)
	mana.bg = mana:CreateTexture(nil, "BORDER")
	mana.bg:SetAllPoints(mana.ManaBar)
	mana.bg:SetTexture([[Interface\BUTTONS\WHITE8X8]])
	mana.bg.multiplier = 0.3;
	mana.Text = mana.ManaBar:CreateFontString(nil, "OVERLAY")
	mana.Text:SetAllPoints(mana.ManaBar)
	mana.Text:FontManager("unitprimary")

	bar.Cat = cat;
	bar.Chicken = chicken;
	bar.Mana = mana;
	
	local classBarHolder = CreateFrame("Frame", "Player_ClassBar", bar)
	classBarHolder:SetPointToScale("TOPLEFT", playerFrame, "BOTTOMLEFT", 0, -2)
	bar:SetPoint("TOPLEFT", classBarHolder, "TOPLEFT", 0, 0)
	bar.Holder = classBarHolder
	SV.Mentalo:Add(bar.Holder, L["Classbar"])
	
	playerFrame.ClassBarRefresh = Reposition;
	playerFrame.Druidness = bar
	return 'Druidness' 
end 