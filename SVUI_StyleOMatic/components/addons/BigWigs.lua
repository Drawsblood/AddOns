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
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = _G["SVUI"];
local L = SV.L;
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
--[[ 
########################################################## 
BIGWIGS
##########################################################
]]--
local FreeBG
local BigWigsLoaded

local function freestyle(bar)
	if not FreeBG then FreeBG = {} end
	local bg = bar:Get("bigwigs:elvui:barbg")
	if bg then
		bg:ClearAllPoints()
		bg:SetParent(SVUI.Screen)
		bg:Hide()
		FreeBG[#FreeBG + 1] = bg
	end

	local ibg = bar:Get("bigwigs:elvui:iconbg")
	if ibg then
		ibg:ClearAllPoints()
		ibg:SetParent(SVUI.Screen)
		ibg:Hide()
		FreeBG[#FreeBG + 1] = ibg
	end
	bar.candyBarIconFrame.SetWidth = bar.candyBarIconFrame.OldSetWidth
	bar.candyBarBar.SetPoint = bar.candyBarBar.OldSetPoint
	bar.candyBarIconFrame:ClearAllPoints()
	bar.candyBarIconFrame:SetPoint("TOPLEFT")
	bar.candyBarIconFrame:SetPoint("BOTTOMLEFT")
	bar.candyBarIconFrame:SetTexCoord(0.1,0.9,0.1,0.9)
	bar.candyBarBar:ClearAllPoints()
	bar.candyBarBar:SetPoint("TOPRIGHT")
	bar.candyBarBar:SetPoint("BOTTOMRIGHT")
	bar.candyBarBackground:SetAllPoints()
	bar.candyBarDuration:ClearAllPoints()
	bar.candyBarDuration:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 0)
	bar.candyBarLabel:ClearAllPoints()
	bar.candyBarLabel:SetPoint("LEFT", bar.candyBarBar, "LEFT", 2, 0)
	bar.candyBarLabel:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 0)
end

local function applystyle(bar)
	if not FreeBG then FreeBG = {} end
	bar:SetHeightToScale(20)
	local bg = nil
	if #FreeBG > 0 then
		bg = tremove(FreeBG)
	else
		bg = CreateFrame("Frame")
	end
	bg:SetStylePanel("Fixed", 'Transparent', true)
	bg:SetParent(bar)
	bg:SetAllPointsOut(bar)
	bg:SetFrameLevel(bar:GetFrameLevel() - 1)
	bg:SetFrameStrata(bar:GetFrameStrata())
	bg:Show()
	bar:Set("bigwigs:elvui:barbg", bg)
	local ibg = nil
	if bar.candyBarIconFrame:GetTexture() then
		if #FreeBG > 0 then
			ibg = tremove(FreeBG)
		else
			ibg = CreateFrame("Frame")
		end
		ibg:SetParent(bar)
		ibg:SetStylePanel("Fixed", 'Transparent', true)
		ibg:SetBackdropColor(0, 0, 0, 0)
		ibg:SetAllPointsOut(bar.candyBarIconFrame)
		ibg:SetFrameLevel(bar:GetFrameLevel() - 1)
		ibg:SetFrameStrata(bar:GetFrameStrata())
		ibg:Show()
		bar:Set("bigwigs:elvui:iconbg", ibg)
	end
	bar.candyBarLabel:SetJustifyH("LEFT")
	bar.candyBarLabel:ClearAllPoints()
	bar.candyBarDuration:SetJustifyH("RIGHT")
	bar.candyBarDuration:ClearAllPoints()
	bar.candyBarLabel:SetPointToScale("LEFT", bar, "LEFT", 4, 0)
	bar.candyBarDuration:SetPointToScale("RIGHT", bar, "RIGHT", -4, 0)
	bar.candyBarBar:ClearAllPoints()
	bar.candyBarBar:SetAllPoints(bar)
	bar.candyBarBar.OldSetPoint = bar.candyBarBar.SetPoint
	bar.candyBarBar.SetPoint = SV.fubar
	bar.candyBarIconFrame.OldSetWidth = bar.candyBarIconFrame.SetWidth
	bar.candyBarIconFrame.SetWidth = SV.fubar
	bar.candyBarIconFrame:ClearAllPoints()
	bar.candyBarIconFrame:SetPointToScale("BOTTOMRIGHT", bar, "BOTTOMLEFT", -1, 0)
	bar.candyBarIconFrame:SetSize(20, 20)
	bar.candyBarIconFrame:SetTexCoord(0.1,0.9,0.1,0.9)
end

local function StyleBigWigs(event, addon)
	assert(BigWigs, "AddOn Not Loaded")
	if (IsAddOnLoaded('BigWigs_Plugins') or event == "ADDON_LOADED" and addon == 'BigWigs_Plugins') then
		local styleName = SV.NameID
		local BigWigsBars = BigWigs:GetPlugin('Bars')
		if BigWigsLoaded then return end
		BigWigsLoaded = true
		BigWigsBars:RegisterBarStyle(styleName, {
			apiVersion = 1,
			version = 1,
			GetSpacing = function(bar)
				return 4
			end,
			ApplyStyle = applystyle,
			BarStopped = freestyle,
			GetStyleName = function() return styleName end,
		})
		BigWigsBars:SetBarStyle(styleName)
		PLUGIN:SafeEventRemoval("BigWigs", "ADDON_LOADED")
		PLUGIN:SafeEventRemoval("BigWigs", "PLAYER_ENTERING_WORLD")
	end
end

PLUGIN:SaveAddonStyle("BigWigs", StyleBigWigs, nil, true)