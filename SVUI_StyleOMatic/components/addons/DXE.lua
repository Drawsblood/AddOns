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
local pairs 	= _G.pairs;
local string 	= _G.string;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = _G.SVUI;
local L = SV.L;
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
local playerName = UnitName("player");
local playerRealm = GetRealmName();
local playerKey = ("%s - %s"):format(playerName, playerRealm)
--[[ 
########################################################## 
DXE
##########################################################
]]--
local function StyleDXEBar(bar)
	bar:SetStylePanel("Fixed", "Transparent")
	bar.bg:SetTexture(0,0,0,0)
	bar.border.Show = SV.fubar
	bar.border:Hide()
	bar.statusbar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	bar.statusbar:ClearAllPoints()
	bar.statusbar:SetAllPointsIn()
	bar.righticon:SetStylePanel("Fixed", "Default")
	bar.righticon.border.Show = SV.fubar
	bar.righticon.border:Hide()
	bar.righticon:ClearAllPoints()
	bar.righticon:SetPoint("LEFT", bar, "RIGHT", 2, 0)
	bar.righticon.t:SetTexCoord(0.1,0.9,0.1,0.9)
	bar.righticon.t:ClearAllPoints()
	bar.righticon.t:SetAllPointsIn()
	bar.righticon.t:SetDrawLayer("ARTWORK")
	bar.lefticon:SetStylePanel("Fixed", "Default")
	bar.lefticon.border.Show = SV.fubar
	bar.lefticon.border:Hide()
	bar.lefticon:ClearAllPoints()
	bar.lefticon:SetPoint("RIGHT", bar, "LEFT", -2, 0)
	bar.lefticon.t:SetTexCoord(0.1,0.9,0.1,0.9)
	bar.lefticon.t:ClearAllPoints()
	bar.lefticon.t:SetAllPointsIn()
	bar.lefticon.t:SetDrawLayer("ARTWORK")
end

local function RefreshDXEBars(frame)
	if frame.refreshing then return end
	frame.refreshing = true
	local i = 1
	while _G["DXEAlertBar"..i] do
		local bar = _G["DXEAlertBar"..i]
		if not bar.styled then
			bar:SetScale(1)
			bar.SetScale = SV.fubar
			StyleDXEBar(bar)
			bar.styled = true
		end
		i = i + 1
	end
	frame.refreshing = false
end

LoadAddOn("DXE")

local function StyleDXE()
	assert(DXE, "AddOn Not Loaded")

	DXE.LayoutHealthWatchers_ = DXE.LayoutHealthWatchers
	DXE.LayoutHealthWatchers = function(frame)
		DXE:LayoutHealthWatchers_()
		for i,hw in ipairs(frame.HW) do
			if hw:IsShown() then
				hw:SetStylePanel("Fixed", "Transparent")
				hw.border.Show = SV.fubar
				hw.border:Hide()
				hw.healthbar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
			end
		end
	end

	local DXEAlerts = DXE:GetModule("Alerts")
	local frame = CreateFrame("Frame")
	
	frame.elapsed = 1
	frame:SetScript("OnUpdate", function(frame,elapsed)
		frame.elapsed = frame.elapsed + elapsed
		if(frame.elapsed >= 1) then
			RefreshDXEBars(DXEAlerts)
			frame.elapsed = 0
		end
	end)

	hooksecurefunc(DXEAlerts, "Simple", RefreshDXEBars)
	hooksecurefunc(DXEAlerts, "RefreshBars", RefreshDXEBars)
	DXE:LayoutHealthWatchers()
	DXE.Alerts:RefreshBars()

	if not DXEDB then DXEDB = {} end
	if not DXEDB["profiles"] then DXEDB["profiles"] = {} end
	if not DXEDB["profiles"][playerKey] then DXEDB["profiles"][playerKey] = {} end
	if not DXEDB["profiles"][playerKey]["Globals"] then DXEDB["profiles"][playerKey]["Globals"] = {} end

	DXEDB["profiles"][playerKey]["Globals"]["BackgroundTexture"] = [[Interface\BUTTONS\WHITE8X8]]
	DXEDB["profiles"][playerKey]["Globals"]["BarTexture"] = [[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]]
	DXEDB["profiles"][playerKey]["Globals"]["Border"] = "None"
	DXEDB["profiles"][playerKey]["Globals"]["Font"] = SV.Media.font.dialog
	DXEDB["profiles"][playerKey]["Globals"]["TimerFont"] = SV.Media.font.dialog
end
PLUGIN:SaveAddonStyle("DXE", StyleDXE)