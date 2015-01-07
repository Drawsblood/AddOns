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
local ipairs 	= _G.ipairs;
local type 		= _G.type;
local tinsert 	= _G.tinsert;
local math 		= _G.math;
local cos, deg, rad, sin = math.cos, math.deg, math.rad, math.sin;

local hooksecurefunc = _G.hooksecurefunc;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L
local toonclass = select(2, UnitClass('player'))
--[[ 
########################################################## 
TAINT FIX HACKS
##########################################################
]]--
LFRParentFrame:SetScript("OnHide", nil)
--[[ 
########################################################## 
MERCHANT MAX STACK
##########################################################
]]--
local BuyMaxStack = function(self, ...)
	if ( IsAltKeyDown() ) then
		local itemLink = GetMerchantItemLink(self:GetID())
		if not itemLink then return end
		local maxStack = select(8, GetItemInfo(itemLink))
		if ( maxStack and maxStack > 1 ) then
			BuyMerchantItem(self:GetID(), GetMerchantItemMaxStack(self:GetID()))
		end
	end
end

local MaxStackTooltip = function(self)
	wipe(GameTooltip.InjectedDouble)
	local itemLink = GetMerchantItemLink(self:GetID())
	if not itemLink then return end
	local maxStack = select(8, GetItemInfo(itemLink))
	if(not (maxStack > 1)) then return end
    GameTooltip.InjectedDouble[1] = "[Alt + Click]"
    GameTooltip.InjectedDouble[2] = "Buy a full stack."
    GameTooltip.InjectedDouble[3] = 0
    GameTooltip.InjectedDouble[4] = 0.5
    GameTooltip.InjectedDouble[5] = 1
    GameTooltip.InjectedDouble[6] = 0.5
    GameTooltip.InjectedDouble[7] = 1
    GameTooltip.InjectedDouble[8] = 0.5
end

-- hooksecurefunc(GameTooltip, "SetMerchantItem", MaxStackTooltip);
hooksecurefunc("MerchantItemButton_OnEnter", MaxStackTooltip);
hooksecurefunc("MerchantItemButton_OnModifiedClick", BuyMaxStack);
--[[ 
########################################################## 
CHAT BUBBLES
##########################################################
]]--
-- local function LoadStyledChatBubbles()
-- 	if(SV.db.general.bubbles == true) then
-- 		local ChatBubbleHandler = CreateFrame("Frame", nil, UIParent)
-- 		local total = 0
-- 		local numKids = 0
-- 		local function styleBubble(frame)
-- 			local needsUpdate = true;
-- 			for i = 1, frame:GetNumRegions() do
-- 				local region = select(i, frame:GetRegions())
-- 				if region:GetObjectType() == "Texture" then
-- 					if(region:GetTexture() == [[Interface\Tooltips\ChatBubble-Background]]) then 
-- 						region:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Chat\CHATBUBBLE-BG]])
-- 						needsUpdate = false 
-- 					elseif(region:GetTexture() == [[Interface\Tooltips\ChatBubble-Backdrop]]) then
-- 						region:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Chat\CHATBUBBLE-BACKDROP]])
-- 						needsUpdate = false 
-- 					elseif(region:GetTexture() == [[Interface\Tooltips\ChatBubble-Tail]]) then
-- 						region:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Chat\CHATBUBBLE-TAIL]])
-- 						needsUpdate = false 
-- 					else 
-- 						region:SetTexture(0,0,0,0)
-- 					end
-- 				elseif(region:GetObjectType() == "FontString" and not frame.text) then
-- 					frame.text = region 
-- 				end
-- 			end
-- 			if needsUpdate then 
-- 				frame:SetBackdrop(nil);
-- 				frame:SetClampedToScreen(false)
-- 				frame:SetFrameStrata("BACKGROUND")
-- 			end
-- 			if(frame.text) then
-- 				frame.text:SetFont(SV.Media.font.narrator, 10, "NONE")
-- 				frame.text:SetShadowColor(0,0,0,1)
-- 				frame.text:SetShadowOffset(1,-1)
-- 			end
-- 		end

-- 		ChatBubbleHandler:SetScript("OnUpdate", function(self, elapsed)
-- 			total = total + elapsed
-- 			if total > 0.1 then
-- 				total = 0
-- 				local newNumKids = WorldFrame:GetNumChildren()
-- 				if newNumKids ~= numKids then
-- 					for i = numKids + 1, newNumKids do
-- 						local frame = select(i, WorldFrame:GetChildren())
-- 						local b = frame:GetBackdrop()
-- 						if(b and b.bgFile == [[Interface\Tooltips\ChatBubble-Background]]) then
-- 							styleBubble(frame)
-- 						end
-- 					end
-- 					numKids = newNumKids
-- 				end
-- 			end
-- 		end)
-- 	end
-- end

-- SV:NewScript(LoadStyledChatBubbles)
--[[ 
########################################################## 
DRESSUP HELPERS by: Leatrix
##########################################################
]]--
local helmet, cloak;
local htimer = 0
local hshow, cshow, hchek, cchek


local function LockItem(item,lock)
	if lock then
		item:Disable()
		item:SetAlpha(0.3)
	else
		item:Enable()
		item:SetAlpha(1.0)
	end
end

local function SetVanityPlacement()
	helmet:ClearAllPoints();
	helmet:SetPoint("TOPLEFT", 166, -326)
	helmet:SetHitRectInsets(0, -10, 0, 0);
	helmet.text:SetText("H");
	cloak:ClearAllPoints();
	cloak:SetPoint("TOPLEFT", 206, -326)
	cloak:SetHitRectInsets(0, -10, 0, 0);
	cloak.text:SetText("C");
	helmet:SetAlpha(0.7);
	cloak:SetAlpha(0.7);
end

local MouseEventHandler = function(self, btn)
	if btn == "RightButton" and IsShiftKeyDown() then
		SetVanityPlacement();
	end
end

local DressUpdateHandler = function(self, elapsed)
	htimer = htimer + elapsed;
	while (htimer > 0.05) do
		if UnitIsDeadOrGhost("player") then
			LockItem(helmet,true)
			LockItem(cloak,true)
			return
		else
			LockItem(helmet,false)
			LockItem(cloak,false)
		end
		hshow, cshow, hchek, cchek = ShowingHelm(), ShowingCloak(), helmet:GetChecked(), cloak:GetChecked()
		if hchek ~= hshow then
			if helmet:IsEnabled() then
				helmet:Disable()
			end
		else
			if not helmet:IsEnabled() then
				helmet:Enable()
			end
		end
		if cchek ~= cshow then
			if cloak:IsEnabled() then
				cloak:Disable()
			end
		else
			if not cloak:IsEnabled() then
				cloak:Enable()
			end
		end
		helmet:SetChecked(hshow);
		cloak:SetChecked(cshow);
		htimer = 0;
	end
end

local DressUp_OnEnter = function(self)
	if InCombatLockdown() then return end
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 4)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(self.TText, 1, 1, 1)
	GameTooltip:Show()
end

local DressUp_OnLeave = function(self)
	if InCombatLockdown() then return end
	if(GameTooltip:IsShown()) then GameTooltip:Hide() end
end

local function LoadDressupHelper()
	if IsAddOnLoaded("DressingRoomFunctions") then return end
	--[[ PAPER DOLL ENHANCEMENT ]]--
	local tabard1 = SV:CreateButton(DressUpFrame, "Tabard", "BOTTOMLEFT", 12, 12, 80, 22, "")
	tabard1:SetScript("OnClick", function()
		DressUpModel:UndressSlot(19)
	end)

	local nude1 = SV:CreateButton(DressUpFrame, "Nude", "BOTTOMLEFT", 104, 12, 80, 22, "")
	nude1:SetScript("OnClick", function()
		DressUpFrameResetButton:Click()
		for i = 1, 19 do
			DressUpModel:UndressSlot(i)
		end
	end)

	local BtnStrata, BtnLevel = SideDressUpModelResetButton:GetFrameStrata(), SideDressUpModelResetButton:GetFrameLevel()

	-- frame, label, anchor, x, y, width, height, tooltip

	local tabard2 = SV:CreateButton(SideDressUpFrame, "Tabard", "BOTTOMLEFT", 14, 20, 60, 22, "")
	tabard2:SetFrameStrata(BtnStrata);
	tabard2:SetFrameLevel(BtnLevel);
	tabard2:SetScript("OnClick", function()
		SideDressUpModel:UndressSlot(19)
	end)

	local nude2 = SV:CreateButton(SideDressUpFrame, "Nude", "BOTTOMRIGHT", -18, 20, 60, 22, "")
	nude2:SetFrameStrata(BtnStrata);
	nude2:SetFrameLevel(BtnLevel);
	nude2:SetScript("OnClick", function()
		SideDressUpModelResetButton:Click()
		for i = 1, 19 do
			SideDressUpModel:UndressSlot(i)
		end
	end)

	--[[ CLOAK AND HELMET TOGGLES ]]--
	helmet = CreateFrame('CheckButton', nil, CharacterModelFrame, "OptionsCheckButtonTemplate")
	helmet:SetSize(16, 16)
	--helmet:RemoveTextures()
	--helmet:SetStylePanel("Checkbox")
	helmet.text = helmet:CreateFontString(nil, 'OVERLAY', "GameFontNormal")
	helmet.text:SetPoint("LEFT", 24, 0)
	helmet.TText = "Show/Hide Helmet"
	helmet:SetScript('OnEnter', DressUp_OnEnter)
	helmet:SetScript('OnLeave', DressUp_OnLeave)
	helmet:SetScript('OnUpdate', DressUpdateHandler)

	cloak = CreateFrame('CheckButton', nil, CharacterModelFrame, "OptionsCheckButtonTemplate")
	cloak:SetSize(16, 16)
	--cloak:RemoveTextures()
	--cloak:SetStylePanel("Checkbox")
	cloak.text = cloak:CreateFontString(nil, 'OVERLAY', "GameFontNormal")
	cloak.text:SetPoint("LEFT", 24, 0)
	cloak.TText = "Show/Hide Cloak"
	cloak:SetScript('OnEnter', DressUp_OnEnter)
	cloak:SetScript('OnLeave', DressUp_OnLeave)

	helmet:SetScript('OnClick', function(self, btn)
		ShowHelm(helmet:GetChecked())
	end)
	cloak:SetScript('OnClick', function(self, btn)
		ShowCloak(cloak:GetChecked())
	end)

	helmet:SetScript('OnMouseDown', MouseEventHandler)
	cloak:SetScript('OnMouseDown', MouseEventHandler)
	CharacterModelFrame:HookScript("OnShow", SetVanityPlacement)
end

SV:NewScript(LoadDressupHelper)
--[[ 
########################################################## 
RAIDMARKERS
##########################################################
]]--
local ButtonIsDown;
local RaidMarkFrame=CreateFrame("Frame", "SVUI_RaidMarkFrame", UIParent)
RaidMarkFrame:EnableMouse(true)
RaidMarkFrame:SetSize(100, 100)
RaidMarkFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
RaidMarkFrame:SetFrameStrata("DIALOG")

local RaidMarkButton_OnEnter = function(self)
	self.Texture:ClearAllPoints()
	self.Texture:SetPointToScale("TOPLEFT",-10,10)
	self.Texture:SetPointToScale("BOTTOMRIGHT",10,-10)
end 

local RaidMarkButton_OnLeave = function(self)
	self.Texture:SetAllPoints()
end 

local RaidMarkButton_OnClick = function(self, button)
	PlaySound("UChatScrollButton")
	SetRaidTarget("target",button ~= "RightButton" and self:GetID() or 0)
	self:GetParent():Hide()
end 

for i=1,8 do 
	local raidMark = CreateFrame("Button", "RaidMarkIconButton"..i, RaidMarkFrame)
	raidMark:SetSize(40, 40)
	raidMark:SetID(i)
	raidMark.Texture = raidMark:CreateTexture(raidMark:GetName().."NormalTexture","ARTWORK")
	raidMark.Texture:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
	raidMark.Texture:SetAllPoints()
	SetRaidTargetIconTexture(raidMark.Texture,i)
	raidMark:RegisterForClicks("LeftbuttonUp","RightbuttonUp")
	raidMark:SetScript("OnClick",RaidMarkButton_OnClick)
	raidMark:SetScript("OnEnter",RaidMarkButton_OnEnter)
	raidMark:SetScript("OnLeave",RaidMarkButton_OnLeave)
	if(i == 8) then 
		raidMark:SetPoint("CENTER")
	else 
		local radian = 360 / 7 * i;
		raidMark:SetPoint("CENTER", sin(radian) * 60, cos(radian) * 60)
	end 
end 

RaidMarkFrame:Hide()

local function RaidMarkAllowed()
	if not RaidMarkFrame then
		return false 
	end 
	if GetNumGroupMembers()>0 then
		if UnitIsGroupLeader('player') or UnitIsGroupAssistant("player") then 
			return true 
		elseif IsInGroup() and not IsInRaid() then 
			return true 
		else
			UIErrorsFrame:AddMessage(L["You don't have permission to mark targets."], 1.0, 0.1, 0.1, 1.0, UIERRORS_HOLD_TIME)
			return false 
		end 
	else
		return true 
	end 
end 

local function RaidMarkShowIcons()
	if not UnitExists("target") or UnitIsDead("target") then return end 
	local x,y = GetCursorPosition()
	local scale = SV.Screen:GetEffectiveScale()
	RaidMarkFrame:SetPoint("CENTER", SV.Screen, "BOTTOMLEFT", (x / scale), (y / scale))
	RaidMarkFrame:Show()
end

_G.RaidMark_HotkeyPressed = function(button)
	ButtonIsDown = button == "down" and RaidMarkAllowed()
	if(RaidMarkFrame) then
		if ButtonIsDown then 
			RaidMarkShowIcons()
		else
			RaidMarkFrame:Hide()
		end
	end
end

RaidMarkFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
RaidMarkFrame:SetScript("OnEvent", function(self, event)
	if ButtonIsDown then 
		RaidMarkShowIcons()
	end 
end)
--[[ 
########################################################## 
TOTEMS
##########################################################
]]--
local Totems = CreateFrame("Frame");
local TotemBar;
local priorities = STANDARD_TOTEM_PRIORITIES
if(toonclass == "SHAMAN") then
	priorities = SHAMAN_TOTEM_PRIORITIES
end

local Totems_OnEvent = function(self, event)
	if not TotemBar then return end 
	local displayedTotems = 0;
	for i = 1, MAX_TOTEMS do
		if TotemBar[i] then
			local haveTotem, name, start, duration, icon = GetTotemInfo(i)
			if(haveTotem and icon and icon ~= "") then 
				TotemBar[i]:Show()
				TotemBar[i].Icon:SetTexture(icon)
				displayedTotems = displayedTotems + 1;
				CooldownFrame_SetTimer(TotemBar[i].CD, start, duration, 1)

				local id = TotemBar[i]:GetID()
				local blizztotem = _G["TotemFrameTotem"..id]
				if(blizztotem) then 
					blizztotem:ClearAllPoints()
					blizztotem:SetParent(TotemBar[i].Anchor)
					blizztotem:SetAllPoints(TotemBar[i].Anchor)
				end 
			else 
				TotemBar[i]:Hide()
			end
		end
	end
end

function SV:UpdateTotems()
	local totemSize = self.db.totems.size;
	local totemSpace = self.db.totems.spacing;
	local totemGrowth = self.db.totems.showBy;
	local totemSort = self.db.totems.sortDirection;

	for i = 1, MAX_TOTEMS do 
		local button = TotemBar[i]
		local lastButton = TotemBar[i - 1]
		button:SetSizeToScale(totemSize)
		button:ClearAllPoints()
		if(totemGrowth == "HORIZONTAL" and totemSort == "ASCENDING") then 
			if(i == 1) then 
				button:SetPoint("LEFT", TotemBar, "LEFT", totemSpace, 0)
			elseif lastButton then 
				button:SetPoint("LEFT", lastButton, "RIGHT", totemSpace, 0)
			end 
		elseif(totemGrowth == "VERTICAL" and totemSort == "ASCENDING") then
			if(i == 1) then 
				button:SetPoint("TOP", TotemBar, "TOP", 0, -totemSpace)
			elseif lastButton then 
				button:SetPoint("TOP", lastButton, "BOTTOM", 0, -totemSpace)
			end 
		elseif(totemGrowth == "HORIZONTAL" and totemSort == "DESCENDING") then 
			if(i == 1) then 
				button:SetPoint("RIGHT", TotemBar, "RIGHT", -totemSpace, 0)
			elseif lastButton then 
				button:SetPoint("RIGHT", lastButton, "LEFT", -totemSpace, 0)
			end 
		else 
			if(i == 1) then 
				button:SetPoint("BOTTOM", TotemBar, "BOTTOM", 0, totemSpace)
			elseif lastButton then 
				button:SetPoint("BOTTOM", lastButton, "TOP", 0, totemSpace)
			end 
		end 
	end 
	local tS1 = ((totemSize * MAX_TOTEMS) + (totemSpace * MAX_TOTEMS) + totemSpace);
	local tS2 = (totemSize + (totemSpace * 2));
	local tW = (totemGrowth == "HORIZONTAL" and tS1 or tS2);
	local tH = (totemGrowth == "HORIZONTAL" and tS2 or tS1);
	TotemBar:SetSizeToScale(tW, tH);
	Totems_OnEvent()
end

local Totem_OnEnter = function(self)
	if(not self:IsVisible()) then return end
	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
	GameTooltip:SetTotem(self:GetID())
end

local Totem_OnLeave = function()
	GameTooltip:Hide()
end

local function CreateTotemBar()
	if(not SV.db.totems.enable) then return; end
	local xOffset = SV.db.Dock.dockLeftWidth + 12
	TotemBar = CreateFrame("Frame", "SVUI_TotemBar", UIParent)
	TotemBar:SetPoint("BOTTOMLEFT", SV.Screen, "BOTTOMLEFT", xOffset, 40)
	for i = 1, MAX_TOTEMS do
		local id = priorities[i]
		local totem = CreateFrame("Button", "TotemBarTotem"..id, TotemBar)
		totem:SetID(id)
		totem:Hide()
		
		totem.Icon = totem:CreateTexture(nil, "ARTWORK")
		totem.Icon:SetAllPointsIn()
		totem.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		totem.CD = CreateFrame("Cooldown", "TotemBarTotem"..id.."Cooldown", totem, "CooldownFrameTemplate")
		totem.CD:SetReverse(true)

		totem.Anchor = CreateFrame("Frame", nil, totem)
		totem.Anchor:SetAllPoints()

		totem:SetStylePanel("Button")

		totem:EnableMouse(true)
		totem:SetScript('OnEnter', Totem_OnEnter)
		totem:SetScript('OnLeave', Totem_OnLeave)

		local blizztotem = _G["TotemFrameTotem"..id]
		if(blizztotem) then
			blizztotem:ClearAllPoints()
			blizztotem:SetParent(totem.Anchor)
			blizztotem:SetAllPoints(totem.Anchor)
			blizztotem:SetFrameLevel(totem.Anchor:GetFrameLevel() + 1)
			blizztotem:SetFrameStrata(totem.Anchor:GetFrameStrata())
			blizztotem:SetAlpha(0)
		end

		TotemBar[i] = totem 
	end 

	hooksecurefunc("TotemFrame_Update", function()
		for i=1, MAX_TOTEMS do
			local id = priorities[i]
			local blizztotem = _G["TotemFrameTotem"..id]
			local slot = blizztotem.slot

			if slot and slot > 0 then
				blizztotem:ClearAllPoints()
				blizztotem:SetAllPoints(_G["TotemBarTotem"..id])
			end
		end
	end)

	TotemBar:Show()
	Totems:RegisterEvent("PLAYER_TOTEM_UPDATE")
	Totems:RegisterEvent("PLAYER_ENTERING_WORLD")
	Totems:SetScript("OnEvent", Totems_OnEvent)
	Totems_OnEvent()
	SV:UpdateTotems()
	local frame_name;
	if toonclass == "DEATHKNIGHT" then
		frame_name = L["Ghoul Bar"]
	elseif toonclass == "DRUID" then
		frame_name = L["Mushroom Bar"]
	else
		frame_name = L["Totem Bar"]
	end
	SV.Mentalo:Add(TotemBar, frame_name)
end 

SV:NewScript(CreateTotemBar)
--[[ 
########################################################## 
THREAT THERMOMETER
##########################################################
]]--
local twipe = table.wipe;
local CurrentThreats = {};
local BARFILE = [[Interface\AddOns\SVUI\assets\artwork\Doodads\THREAT-BAR-ELEMENTS]]
local function UMadBro(scaledPercent)
	local highestThreat,unitWithHighestThreat = 0,nil;
	for unit,threat in pairs(CurrentThreats)do 
		if threat > highestThreat then 
			highestThreat = threat;
			unitWithHighestThreat = unit 
		end 
	end 
	return (scaledPercent - highestThreat),unitWithHighestThreat 
end 

local function GetThreatBarColor(unitWithHighestThreat)
	local react = UnitReaction(unitWithHighestThreat,'player')
	local _,unitClass = UnitClass(unitWithHighestThreat)
	if UnitIsPlayer(unitWithHighestThreat)then 
		local colors = RAID_CLASS_COLORS[unitClass]
		if not colors then return 15,15,15 end 
		return colors.r*255, colors.g*255, colors.b*255 
	elseif(react and SV.oUF) then 
		local reaction = SV.oUF['colors'].reaction[react]
		return reaction[1]*255, reaction[2]*255, reaction[3]*255 
	else 
		return 15,15,15 
	end 
end 

local function ThreatBar_OnEvent(self, event)
	local isTanking, status, scaledPercent = UnitDetailedThreatSituation('player','target')
	if scaledPercent and scaledPercent > 0 then 
		self:Show()
		if scaledPercent==100 then 
			if(UnitExists('pet')) then 
				CurrentThreats['pet']=select(3,UnitDetailedThreatSituation('pet','target'))
			end 
			if(IsInRaid()) then 
				for i=1,40 do 
					if UnitExists('raid'..i) and not UnitIsUnit('raid'..i,'player') then 
						CurrentThreats['raid'..i]=select(3,UnitDetailedThreatSituation('raid'..i,'target'))
					end 
				end 
			else 
				for i=1,4 do 
					if UnitExists('party'..i) then 
						CurrentThreats['party'..i]=select(3,UnitDetailedThreatSituation('party'..i,'target'))
					end 
				end 
			end 
			local highestThreat,unitWithHighestThreat = UMadBro(scaledPercent)
			if highestThreat > 0 and unitWithHighestThreat ~= nil then 
				local r,g,b = GetThreatBarColor(unitWithHighestThreat)
				if SV.ClassRole == 'T' then 
					self:SetStatusBarColor(0,0.839,0)
					self:SetValue(highestThreat)
				else 
					self:SetStatusBarColor(GetThreatStatusColor(status))
					self:SetValue(scaledPercent)
				end 
			else 
				self:SetStatusBarColor(GetThreatStatusColor(status))
				self:SetValue(scaledPercent)
			end 
		else 
			self:SetStatusBarColor(0.3,1,0.3)
			self:SetValue(scaledPercent)
		end 
		self.text:SetFormattedText('%.0f%%',scaledPercent)
	else 
		self:Hide()
	end 
	twipe(CurrentThreats);
end 

local function LoadThreatBar()
	if(SV.db.general.threatbar == true) then
		local anchor = _G.SVUI_Target
		local ThreatBar = CreateFrame('StatusBar', 'SVUI_ThreatBar', UIParent);
		ThreatBar:SetStatusBarTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Doodads\\THREAT-BAR")
		ThreatBar:SetSize(50, 100)
		ThreatBar:SetFrameStrata('MEDIUM')
		ThreatBar:SetOrientation("VERTICAL")
		ThreatBar:SetMinMaxValues(0, 100)
		if(anchor) then
			ThreatBar:SetPointToScale('LEFT', _G.SVUI_Target, 'RIGHT', 0, 10)
		else
			ThreatBar:SetPointToScale('LEFT', UIParent, 'CENTER', 50, -50)
		end
		ThreatBar.backdrop = ThreatBar:CreateTexture(nil,"BACKGROUND")
		ThreatBar.backdrop:SetAllPoints(ThreatBar)
		ThreatBar.backdrop:SetTexture(BARFILE)
		ThreatBar.backdrop:SetTexCoord(0.5,0.75,0,0.5)
		ThreatBar.backdrop:SetBlendMode("ADD")
		ThreatBar.overlay = ThreatBar:CreateTexture(nil,"OVERLAY",nil,1)
		ThreatBar.overlay:SetAllPoints(ThreatBar)
		ThreatBar.overlay:SetTexture(BARFILE)
		ThreatBar.overlay:SetTexCoord(0.75,1,0,0.5)
		ThreatBar.text = ThreatBar:CreateFontString(nil,'OVERLAY')
		ThreatBar.text:SetFont(SV.Media.font.numbers, 10, "OUTLINE")
		ThreatBar.text:SetPoint('TOP',ThreatBar,'BOTTOM',0,0)
		ThreatBar:RegisterEvent('PLAYER_TARGET_CHANGED');
		ThreatBar:RegisterEvent('UNIT_THREAT_LIST_UPDATE')
		ThreatBar:RegisterEvent('GROUP_ROSTER_UPDATE')
		ThreatBar:RegisterEvent('UNIT_PET')
		ThreatBar:SetScript("OnEvent", ThreatBar_OnEvent)
		SV.Mentalo:Add(ThreatBar, "Threat Bar");
	end
end

SV:NewScript(LoadThreatBar);