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
--]]
--[[ GLOBALS ]]--

local _G = _G;
--LUA
local unpack        = _G.unpack;
local select        = _G.select;
local assert        = _G.assert;
local type          = _G.type;
local error         = _G.error;
local pcall         = _G.pcall;
local print         = _G.print;
local ipairs        = _G.ipairs;
local pairs         = _G.pairs;
local next          = _G.next;
local rawset        = _G.rawset;
local rawget        = _G.rawget;
local tostring      = _G.tostring;
local tonumber      = _G.tonumber;
local getmetatable  = _G.getmetatable;
local setmetatable  = _G.setmetatable;
--STRING
local string        = _G.string;
local upper         = string.upper;
local format        = string.format;
local find          = string.find;
local match         = string.match;
local gsub          = string.gsub;
--MATH
local math          = _G.math;
local floor         = math.floor;
local random        = math.random;
--TABLE
local table         = _G.table;
local tsort         = table.sort;
local tconcat       = table.concat;
local tinsert       = _G.tinsert;
local tremove       = _G.tremove;
local twipe         = _G.wipe;
--BLIZZARD API
local ReloadUI              = _G.ReloadUI;
local GetLocale             = _G.GetLocale;
local CreateFrame           = _G.CreateFrame;
local IsAddOnLoaded         = _G.IsAddOnLoaded;
local InCombatLockdown      = _G.InCombatLockdown;
local GetAddOnInfo          = _G.GetAddOnInfo;
local LoadAddOn             = _G.LoadAddOn;
local SendAddonMessage      = _G.SendAddonMessage;
local LibStub               = _G.LibStub;
local GetAddOnMetadata      = _G.GetAddOnMetadata;
local GetCVarBool           = _G.GetCVarBool;
local GameTooltip           = _G.GameTooltip;
local StaticPopup_Hide      = _G.StaticPopup_Hide;
local ERR_NOT_IN_COMBAT     = _G.ERR_NOT_IN_COMBAT;

local SV = select(2, ...)
local L = SV.L
local MOD = SV:NewPackage("SVHenchmen", L["Henchmen"]);
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local HenchmenFrame = CreateFrame("Frame", "HenchmenFrame", UIParent);
local STANDARD_TEXT_FONT = _G.STANDARD_TEXT_FONT
local OPTION_LEFT = [[Interface\Addons\SVUI\assets\artwork\Doodads\HENCHMEN-OPTION-LEFT]];
local OPTION_RIGHT = [[Interface\Addons\SVUI\assets\artwork\Doodads\HENCHMEN-OPTION-RIGHT]];
local OPTION_SUB = [[Interface\Addons\SVUI\assets\artwork\Doodads\HENCHMEN-SUBOPTION]];
local SWITCH = [[Interface\Addons\SVUI\assets\artwork\Doodads\HENCHMEN-MINION-SWITCH]];
local BUBBLE = [[Interface\Addons\SVUI\assets\artwork\Doodads\HENCHMEN-SPEECH]];
local SUBOPTIONS = {};
local HENCHMEN_DATA = {
	{
		{0,"Adjust My Colors!","Color Themes","Click here to change your current color theme to one of the default sets."},
		{20,"Adjust My Frames!","Frame Styles","Click here to change your current frame styles to one of the default sets."},
		{40,"Adjust My Bars!","Bar Layouts","Click here to change your current actionbar layout to one of the default sets."},
		{-40,"Adjust My Auras!","Aura Layouts","Click here to change your buff/debuff layout to one of the default sets."},
		{-20,"Show Me All Options!","Config Screen","Click here to access the entire SVUI configuration."}
	},
	{
		{0,"Accept Quests","Your minions will automatically accept quests for you", "autoquestaccept"},
		{20,"Complete Quests","Your minions will automatically complete quests for you", "autoquestcomplete"},
		{40,"Select Rewards","Your minions will automatically select quest rewards for you", "autoquestreward"},
		{-40,"Greed Roll","Your minions will automatically roll greed (or disenchant if available) on green quality items for you", "autoRoll"},
		{-20,"Watch Factions","Your minions will automatically change your tracked reputation to the last faction you were awarded points for", "autorepchange"}
	}
}

local takingOnlyCash,deletedelay,mailElapsed,childCount=false,0.5,0,-1;
local GetAllMail, GetAllMailCash, OpenMailItem, WaitForMail, StopOpeningMail, FancifyMoneys, lastopened, needsToWait, total_cash, baseInboxFrame_OnClick;
local incpat 	  = gsub(gsub(FACTION_STANDING_INCREASED, "(%%s)", "(.+)"), "(%%d)", "(.+)");
local changedpat  = gsub(gsub(FACTION_STANDING_CHANGED, "(%%s)", "(.+)"), "(%%d)", "(.+)");
local decpat	  = gsub(gsub(FACTION_STANDING_DECREASED, "(%%s)", "(.+)"), "(%%d)", "(.+)");
local standing    = ('%s:'):format(STANDING);
local reputation  = ('%s:'):format(REPUTATION);
local hideStatic = false;
local AutomatedEvents = {
	"CHAT_MSG_COMBAT_FACTION_CHANGE",
	"MERCHANT_SHOW",
	"QUEST_COMPLETE",
	"QUEST_GREETING",
	"GOSSIP_SHOW",
	"QUEST_DETAIL",
	"QUEST_ACCEPT_CONFIRM",
	"QUEST_PROGRESS"
}

MOD.YOUR_HENCHMEN = {
	{49084,67,113,69,70,73,75}, --Rascal Bot
	{29404,67,113,69,70,73,75}, --Macabre Marionette
	{45613,0,5,10,69,10,69}, 	--Bishibosh
	{34770,70,82,70,82,70,82}, 	--Gilgoblin
	{45562,69,69,69,69,69,69}, 	--Burgle
	{37339,60,60,60,60,60,60}, 	--Augh
	{2323,67,113,69,70,73,75}, 	--Defias Henchman
}
--[[ 
########################################################## 
SCRIPT HANDLERS
##########################################################
]]--
local ColorFunc = function(self) SV.Setup:ColorTheme(self.value, true); SV:ToggleHenchman() end 
local UnitFunc = function(self) SV.Setup:UnitframeLayout(self.value, true); SV:ToggleHenchman() end 
local BarFunc = function(self) SV.Setup:BarLayout(self.value, true); SV:ToggleHenchman() end 
local AuraFunc = function(self) SV.Setup:Auralayout(self.value, true); SV:ToggleHenchman() end 
local ConfigFunc = function() SV:ToggleConfig(); SV:ToggleHenchman() end 
local speechTimer;

local Tooltip_Show = function(self)
	GameTooltip:SetOwner(HenchmenFrame,"ANCHOR_TOP",0,12)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(self.ttText)
	GameTooltip:Show()
end 

local Tooltip_Hide = function(self)
	GameTooltip:Hide()
end 

local Minion_OnMouseUp = function(self) 
	if(not self.setting()) then
		self.indicator:SetTexCoord(0,1,0.5,1)
		self.setting(true)
	else
		self.indicator:SetTexCoord(0,1,0,0.5)
		self.setting(false)
	end
end 

local Option_OnMouseUp = function(self)
	if(type(self.callback) == "function") then
		self:callback()
	end
end 

local SubOption_OnMouseUp = function(self)
	if not InCombatLockdown()then 
		local name=self:GetName()
		for _,frame in pairs(SUBOPTIONS) do 
			frame.anim:Finish()
			frame:Hide()
		end 
		if not self.isopen then 
			for i=1, self.suboptions do 
				_G[name.."Sub"..i]:Show()
				_G[name.."Sub"..i].anim:Play()
				_G[name.."Sub"..i].anim:Finish()
			end 
			self.isopen=true 
		else
			self.isopen=false 
		end 
	end 
end
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function UpdateHenchmanModel(hide)
	if(not hide and not HenchmenFrameModel:IsShown()) then
		local models = MOD.YOUR_HENCHMEN
		local mod = random(1,#models)
		local emod = random(2,7)
		local id = models[mod][1]
		local emote = models[mod][emod]
		HenchmenFrameModel:ClearModel()
		HenchmenFrameModel:SetDisplayInfo(id)
		HenchmenFrameModel:SetAnimation(emote)
		HenchmenFrameModel:Show()
	else
		HenchmenFrameModel:Hide()
	end 
end

function GetAllMail()
	if(GetInboxNumItems() == 0) then return end 
	SVUI_GetMailButton:SetScript("OnClick",nil)
	SVUI_GetGoldButton:SetScript("OnClick",nil)
	baseInboxFrame_OnClick=InboxFrame_OnClick;
	InboxFrame_OnClick = SV.fubar
	SVUI_GetMailButton:RegisterEvent("UI_ERROR_MESSAGE")
	OpenMailItem(GetInboxNumItems())
end 

function GetAllMailCash()
	takingOnlyCash = true;
	GetAllMail()
end 

function OpenMailItem(mail)
	if not InboxFrame:IsVisible()then return StopOpeningMail("Mailbox Minion Needs a Mailbox!")end 
	if mail==0 then 
		MiniMapMailFrame:Hide()
		return StopOpeningMail("Finished getting your mail!")
	end 
	local _, _, _, _, money, CODAmount, _, itemCount = GetInboxHeaderInfo(mail)
	if not takingOnlyCash then 
		if money > 0 or itemCount and itemCount > 0 and CODAmount <= 0 then 
			AutoLootMailItem(mail)
			needsToWait=true 
		end 
	elseif money > 0 then 
		TakeInboxMoney(mail)
		needsToWait=true;
		if total_cash then total_cash = total_cash - money end 
	end 
	local numMail = GetInboxNumItems()
	if itemCount and itemCount > 0 or numMail > 1 and mail <= numMail then 
		lastopened = mail;
		SVUI_GetMailButton:SetScript("OnUpdate",WaitForMail)
	else 
		MiniMapMailFrame:Hide()
		StopOpeningMail()
	end 
end 

function WaitForMail(_, elapsed)
	mailElapsed = mailElapsed + elapsed;
	if not needsToWait or mailElapsed > deletedelay then
		if not InboxFrame:IsVisible() then return StopOpeningMail("The Mailbox Minion Needs a Mailbox!") end 
		mailElapsed = 0;
		needsToWait = false;
		SVUI_GetMailButton:SetScript("OnUpdate", nil)
		local _, _, _, _, money, CODAmount, _, itemCount = GetInboxHeaderInfo(lastopened)
		if money > 0 or not takingOnlyCash and CODAmount <= 0 and itemCount and itemCount > 0 then
			OpenMailItem(lastopened)
		else
			OpenMailItem(lastopened - 1)
		end 
	end 
end 

function StopOpeningMail(msg, ...)
	SVUI_GetMailButton:SetScript("OnUpdate", nil)
	SVUI_GetMailButton:SetScript("OnClick", GetAllMail)
	SVUI_GetGoldButton:SetScript("OnClick", GetAllMailCash)
	if baseInboxFrame_OnClick then
		InboxFrame_OnClick = baseInboxFrame_OnClick 
	end 
	SVUI_GetMailButton:UnregisterEvent("UI_ERROR_MESSAGE")
	takingOnlyCash = false;
	total_cash = nil;
	needsToWait = false;
	if msg then
		SV:AddonMessage(msg)
	end 
end 

function FancifyMoneys(cash)
	if cash > 10000 then
		return("%d|cffffd700g|r%d|cffc7c7cfs|r%d|cffeda55fc|r"):format((cash / 10000), ((cash / 100) % 100), (cash % 100))
	elseif cash > 100 then 
		return("%d|cffc7c7cfs|r%d|cffeda55fc|r"):format(((cash / 100) % 100), (cash % 100))
	else
		return("%d|cffeda55fc|r"):format(cash%100)
	end 
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
local function CreateMinionOptions(i)
	local lastIndex = i - 1;
	local options = HENCHMEN_DATA[2][i]
	local offsetX = options[1] * -1
	local option = CreateFrame("Frame", "MinionOptionButton"..i, HenchmenFrame)
	option:SetSize(148,50)

	if i==1 then 
		option:SetPointToScale("TOPRIGHT",HenchmenFrame,"TOPLEFT",-32,-32)
	else 
		option:SetPointToScale("TOP",_G["MinionOptionButton"..lastIndex],"BOTTOM",offsetX,-32)
	end 

	local setting = options[4];
	local dbSet = SV.db.SVHenchmen[setting];
	option.setting = function(toggle)
		if(toggle == nil) then
			return SV.db.SVHenchmen[setting]
		else
			SV.db.SVHenchmen[setting] = toggle;
		end
	end
	SV.Animate:Slide(option,-500,-500)
	option:SetFrameStrata("DIALOG")
	option:SetFrameLevel(24)
	option:EnableMouse(true)
	option.bg = option:CreateTexture(nil,"BORDER")
	option.bg:SetPoint("TOPLEFT",option,"TOPLEFT",-4,4)
	option.bg:SetPoint("BOTTOMRIGHT",option,"BOTTOMRIGHT",4,-24)
	option.bg:SetTexture(OPTION_LEFT)
	option.bg:SetVertexColor(1,1,1,0.6)
	option.txt = option:CreateFontString(nil,"DIALOG")
	option.txt:SetAllPointsIn(option)
	option.txt:SetFont(SV.Media.font.narrator,12,"NONE")
	option.txt:SetJustifyH("CENTER")
	option.txt:SetJustifyV("MIDDLE")
	option.txt:SetText(options[2])
	option.txt:SetTextColor(0,0,0)
	option.txthigh = option:CreateFontString(nil,"HIGHLIGHT")
	option.txthigh:SetAllPointsIn(option)
	option.txthigh:SetFont(SV.Media.font.narrator,12,"OUTLINE")
	option.txthigh:SetJustifyH("CENTER")
	option.txthigh:SetJustifyV("MIDDLE")
	option.txthigh:SetText(options[2])
	option.txthigh:SetTextColor(0,1,1)
	option.ttText = options[3]
	option.indicator = option:CreateTexture(nil,"OVERLAY")
	option.indicator:SetSize(100,32)
	option.indicator:SetPointToScale("RIGHT", option , "LEFT", -5, 0)
	option.indicator:SetTexture(SWITCH)
	if(not dbSet) then
		option.indicator:SetTexCoord(0,1,0,0.5)
	else
		option.indicator:SetTexCoord(0,1,0.5,1)
	end
	
	option:SetScript("OnEnter", Tooltip_Show)
	option:SetScript("OnLeave", Tooltip_Hide)
	option:SetScript("OnMouseUp", Minion_OnMouseUp)
end 

local function CreateHenchmenOptions(i)
	local lastIndex = i - 1;
	local options = HENCHMEN_DATA[1][i]
	local offsetX = options[1]
	local option = CreateFrame("Frame", "HenchmenOptionButton"..i, HenchmenFrame)
	option:SetSize(148,50)
	if i==1 then 
		option:SetPointToScale("TOPLEFT",HenchmenFrame,"TOPRIGHT",32,-32)
	else 
		option:SetPointToScale("TOP",_G["HenchmenOptionButton"..lastIndex],"BOTTOM",offsetX,-32)
	end 
	SV.Animate:Slide(option,500,-500)
	option:SetFrameStrata("DIALOG")
	option:SetFrameLevel(24)
	option:EnableMouse(true)
	option.bg = option:CreateTexture(nil,"BORDER")
	option.bg:SetPoint("TOPLEFT",option,"TOPLEFT",-4,4)
	option.bg:SetPoint("BOTTOMRIGHT",option,"BOTTOMRIGHT",4,-24)
	option.bg:SetTexture(OPTION_RIGHT)
	option.bg:SetVertexColor(1,1,1,0.6)
	option.txt = option:CreateFontString(nil,"DIALOG")
	option.txt:SetAllPointsIn(option)
	option.txt:SetFont(SV.Media.font.narrator,12,"NONE")
	option.txt:SetJustifyH("CENTER")
	option.txt:SetJustifyV("MIDDLE")
	option.txt:SetText(options[2])
	option.txt:SetTextColor(0,0,0)
	option.txthigh = option:CreateFontString(nil,"HIGHLIGHT")
	option.txthigh:SetAllPointsIn(option)
	option.txthigh:SetFont(SV.Media.font.narrator,12,"OUTLINE")
	option.txthigh:SetJustifyH("CENTER")
	option.txthigh:SetJustifyV("MIDDLE")
	option.txthigh:SetText(options[2])
	option.txthigh:SetTextColor(0,1,1)
	option.ttText = options[3]
	option:SetScript("OnEnter", Tooltip_Show)
	option:SetScript("OnLeave", Tooltip_Hide)
end 

local function CreateHenchmenSubOptions(buttonIndex,optionIndex)
	local parent = _G["HenchmenOptionButton"..buttonIndex]
	local name = format("HenchmenOptionButton%dSub%d", buttonIndex, optionIndex);
	local calc = 90 * optionIndex;
	local yOffset = 180 - calc;
	local frame = CreateFrame("Frame",name,HenchmenFrame)
	frame:SetSize(122,50)
	frame:SetPointToScale("BOTTOMLEFT", parent, "TOPRIGHT", 75, yOffset)
	frame:SetFrameStrata("DIALOG")
	frame:SetFrameLevel(24)
	frame:EnableMouse(true)
	frame.bg = frame:CreateTexture(nil,"BORDER")
	frame.bg:SetPoint("TOPLEFT",frame,"TOPLEFT",-12,12)
	frame.bg:SetPoint("BOTTOMRIGHT",frame,"BOTTOMRIGHT",12,-18)
	frame.bg:SetTexture(OPTION_SUB)
	frame.bg:SetVertexColor(1,1,1,0.6)
	frame.txt = frame:CreateFontString(nil,"DIALOG")
	frame.txt:SetAllPointsIn(frame)
	frame.txt:SetFont(STANDARD_TEXT_FONT,12,"OUTLINE")
	frame.txt:SetJustifyH("CENTER")
	frame.txt:SetJustifyV("MIDDLE")
	frame.txt:SetTextColor(1,1,1)
	frame.txthigh = frame:CreateFontString(nil,"HIGHLIGHT")
	frame.txthigh:SetAllPointsIn(frame)
	frame.txthigh:FontManager("default")
	frame.txthigh:SetTextColor(1,1,0)
	SV.Animate:Slide(frame,500,0)

	tinsert(SUBOPTIONS,frame)
end 

local function CreateHenchmenFrame()
	HenchmenFrame:SetParent(UIParent)
	HenchmenFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	HenchmenFrame:SetWidth(500)
	HenchmenFrame:SetHeight(500)
	HenchmenFrame:SetFrameStrata("DIALOG")
	HenchmenFrame:SetFrameLevel(24)
	SV.Animate:Slide(HenchmenFrame,0,-500)

	local model = CreateFrame("PlayerModel", "HenchmenFrameModel", HenchmenFrame)
	model:SetPoint("TOPLEFT",HenchmenFrame,25,-25)
	model:SetPoint("BOTTOMRIGHT",HenchmenFrame,-25,25)
	model:SetFrameStrata("DIALOG")
	model:SetPosition(0,0,0)
	model:Hide()

	HenchmenFrame:Hide()

	local HenchmenCalloutFrame = CreateFrame("Frame", "HenchmenCalloutFrame", UIParent)
	HenchmenCalloutFrame:SetPoint("BOTTOM",UIParent,"BOTTOM",100,150)
	HenchmenCalloutFrame:SetWidth(256)
	HenchmenCalloutFrame:SetHeight(128)
	HenchmenCalloutFrame:SetFrameStrata("DIALOG")
	HenchmenCalloutFrame:SetFrameLevel(24)
	SV.Animate:Slide(HenchmenCalloutFrame,-356,-278)
	local HenchmenCalloutFramePic = HenchmenCalloutFrame:CreateTexture("HenchmenCalloutFramePic","ARTWORK")
	HenchmenCalloutFramePic:SetTexture([[Interface\Addons\SVUI\assets\artwork\Doodads\HENCHMEN-CALLOUT]])
	HenchmenCalloutFramePic:SetAllPoints(HenchmenCalloutFrame)
	HenchmenCalloutFrame:Hide()

	local HenchmenFrameBG = CreateFrame("Frame", "HenchmenFrameBG", UIParent)
	HenchmenFrameBG:SetAllPoints(WorldFrame)
	HenchmenFrameBG:SetBackdrop({bgFile = [[Interface\BUTTONS\WHITE8X8]]})
	HenchmenFrameBG:SetBackdropColor(0,0,0,0.9)
	HenchmenFrameBG:SetFrameStrata("DIALOG")
	HenchmenFrameBG:SetFrameLevel(22)
	HenchmenFrameBG:Hide()
	HenchmenFrameBG:SetScript("OnMouseUp", SV.ToggleHenchman)

	for i=1, 5 do 
		CreateHenchmenOptions(i)
		CreateMinionOptions(i)
	end
	------------------------------------------------------------------------
	CreateHenchmenSubOptions(1,1)
	HenchmenOptionButton1Sub1.txt:SetText("KABOOM!")
	HenchmenOptionButton1Sub1.txthigh:SetText("KABOOM!")
	HenchmenOptionButton1Sub1.value = "kaboom"
	HenchmenOptionButton1Sub1.callback = ColorFunc
	HenchmenOptionButton1Sub1:SetScript("OnMouseUp", Option_OnMouseUp)

	CreateHenchmenSubOptions(1,2)
	HenchmenOptionButton1Sub2.txt:SetText("Darkness")
	HenchmenOptionButton1Sub2.txthigh:SetText("Darkness")
	HenchmenOptionButton1Sub2.value = "dark"
	HenchmenOptionButton1Sub2.callback = ColorFunc
	HenchmenOptionButton1Sub2:SetScript("OnMouseUp", Option_OnMouseUp)

	CreateHenchmenSubOptions(1,3)
	HenchmenOptionButton1Sub3.txt:SetText("Classy")
	HenchmenOptionButton1Sub3.txthigh:SetText("Classy")
	HenchmenOptionButton1Sub3.value = "classy"
	HenchmenOptionButton1Sub3.callback = ColorFunc
	HenchmenOptionButton1Sub3:SetScript("OnMouseUp", Option_OnMouseUp)

	CreateHenchmenSubOptions(1,4)
	HenchmenOptionButton1Sub4.txt:SetText("Vintage")
	HenchmenOptionButton1Sub4.txthigh:SetText("Vintage")
	HenchmenOptionButton1Sub4.value = "default"
	HenchmenOptionButton1Sub4.callback = ColorFunc
	HenchmenOptionButton1Sub4:SetScript("OnMouseUp", Option_OnMouseUp)

	HenchmenOptionButton1.suboptions = 4;
	HenchmenOptionButton1.isopen = false;
	HenchmenOptionButton1:SetScript("OnMouseUp",SubOption_OnMouseUp)
	------------------------------------------------------------------------
	CreateHenchmenSubOptions(2,1)
	HenchmenOptionButton2Sub1.txt:SetText("SUPER: Elaborate Frames")
	HenchmenOptionButton2Sub1.txthigh:SetText("SUPER: Elaborate Frames")
	HenchmenOptionButton2Sub1.value = "super"
	HenchmenOptionButton2Sub1.callback = UnitFunc
	HenchmenOptionButton2Sub1:SetScript("OnMouseUp", Option_OnMouseUp)

	CreateHenchmenSubOptions(2,2)
	HenchmenOptionButton2Sub2.txt:SetText("Simple: Basic Frames")
	HenchmenOptionButton2Sub2.txthigh:SetText("Simple: Basic Frames")
	HenchmenOptionButton2Sub2.value = "simple"
	HenchmenOptionButton2Sub2.callback = UnitFunc
	HenchmenOptionButton2Sub2:SetScript("OnMouseUp", Option_OnMouseUp)

	CreateHenchmenSubOptions(2,3)
	HenchmenOptionButton2Sub3.txt:SetText("Compact: Minimal Frames")
	HenchmenOptionButton2Sub3.txthigh:SetText("Compact: Minimal Frames")
	HenchmenOptionButton2Sub3.value = "compact"
	HenchmenOptionButton2Sub3.callback = UnitFunc
	HenchmenOptionButton2Sub3:SetScript("OnMouseUp", Option_OnMouseUp)

	HenchmenOptionButton2.suboptions = 3;
	HenchmenOptionButton2.isopen = false;
	HenchmenOptionButton2:SetScript("OnMouseUp",SubOption_OnMouseUp)
	------------------------------------------------------------------------
	CreateHenchmenSubOptions(3,1)
	HenchmenOptionButton3Sub1.txt:SetText("One Row: Small Buttons")
	HenchmenOptionButton3Sub1.txthigh:SetText("One Row: Small Buttons")
	HenchmenOptionButton3Sub1.value = "default"
	HenchmenOptionButton3Sub1.callback = BarFunc
	HenchmenOptionButton3Sub1:SetScript("OnMouseUp", Option_OnMouseUp)

	CreateHenchmenSubOptions(3,2)
	HenchmenOptionButton3Sub2.txt:SetText("Two Rows: Small Buttons")
	HenchmenOptionButton3Sub2.txthigh:SetText("Two Rows: Small Buttons")
	HenchmenOptionButton3Sub2.value = "twosmall"
	HenchmenOptionButton3Sub2.callback = BarFunc
	HenchmenOptionButton3Sub2:SetScript("OnMouseUp", Option_OnMouseUp)

	CreateHenchmenSubOptions(3,3)
	HenchmenOptionButton3Sub3.txt:SetText("One Row: Large Buttons")
	HenchmenOptionButton3Sub3.txthigh:SetText("One Row: Large Buttons")
	HenchmenOptionButton3Sub3.value = "onebig"
	HenchmenOptionButton3Sub3.callback = BarFunc
	HenchmenOptionButton3Sub3:SetScript("OnMouseUp", Option_OnMouseUp)

	CreateHenchmenSubOptions(3,4)
	HenchmenOptionButton3Sub4.txt:SetText("Two Rows: Large Buttons")
	HenchmenOptionButton3Sub4.txthigh:SetText("Two Rows: Large Buttons")
	HenchmenOptionButton3Sub4.value = "twobig"
	HenchmenOptionButton3Sub4.callback = BarFunc
	HenchmenOptionButton3Sub4:SetScript("OnMouseUp", Option_OnMouseUp)

	HenchmenOptionButton3.suboptions = 4;
	HenchmenOptionButton3.isopen = false;
	HenchmenOptionButton3:SetScript("OnMouseUp",SubOption_OnMouseUp)
	------------------------------------------------------------------------
	CreateHenchmenSubOptions(4,1)
	HenchmenOptionButton4Sub1.txt:SetText("Icons Only")
	HenchmenOptionButton4Sub1.txthigh:SetText("Icons Only")
	HenchmenOptionButton4Sub1.value = "icons"
	HenchmenOptionButton4Sub1.callback = AuraFunc
	HenchmenOptionButton4Sub1:SetScript("OnMouseUp", Option_OnMouseUp)

	CreateHenchmenSubOptions(4,2)
	HenchmenOptionButton4Sub2.txt:SetText("Bars Only")
	HenchmenOptionButton4Sub2.txthigh:SetText("Bars Only")
	HenchmenOptionButton4Sub2.value = "bars"
	HenchmenOptionButton4Sub2.callback = AuraFunc
	HenchmenOptionButton4Sub2:SetScript("OnMouseUp", Option_OnMouseUp)

	CreateHenchmenSubOptions(4,3)
	HenchmenOptionButton4Sub3.txt:SetText("The Works: Bars and Icons")
	HenchmenOptionButton4Sub3.txthigh:SetText("The Works: Bars and Icons")
	HenchmenOptionButton4Sub3.value = "theworks"
	HenchmenOptionButton4Sub3.callback = AuraFunc
	HenchmenOptionButton4Sub3:SetScript("OnMouseUp", Option_OnMouseUp)

	HenchmenOptionButton4.suboptions = 3;
	HenchmenOptionButton4.isopen = false;
	HenchmenOptionButton4:SetScript("OnMouseUp",SubOption_OnMouseUp)
	------------------------------------------------------------------------
	HenchmenOptionButton5:SetScript("OnMouseUp", ConfigFunc)
	------------------------------------------------------------------------
	for _,frame in pairs(SUBOPTIONS) do 
		frame.anim:Finish()
		frame:Hide()
	end

	MOD.PostLoaded = true
end

function SV:ToggleHenchman()
	if InCombatLockdown()then return end 
	if(not MOD.PostLoaded) then
		CreateHenchmenFrame()
	end
	if not HenchmenFrame:IsShown()then 
		HenchmenFrameBG:Show()

		UpdateHenchmanModel()

		HenchmenFrame.anim:Finish()
		HenchmenFrame:Show()
		HenchmenFrame.anim:Play()
		HenchmenCalloutFrame.anim:Finish()
		HenchmenCalloutFrame:Show()
		HenchmenCalloutFrame:SetAlpha(1)
		HenchmenCalloutFrame.anim:Play()
		UIFrameFadeOut(HenchmenCalloutFrame,5)
		for i=1,5 do 
			local option=_G["HenchmenOptionButton"..i]
			option.anim:Finish()
			option:Show()
			option.anim:Play()

			local minion=_G["MinionOptionButton"..i]
			minion.anim:Finish()
			minion:Show()
			minion.anim:Play()
		end 
		MOD.DockButton.Icon:SetGradient(unpack(SV.Media.gradient.green))
	else 
		UpdateHenchmanModel(true)
		for _,frame in pairs(SUBOPTIONS)do
			frame.anim:Finish()
			frame:Hide()
		end 
		HenchmenOptionButton1.isopen=false;
		HenchmenOptionButton2.isopen=false;
		HenchmenOptionButton3.isopen=false;
		HenchmenCalloutFrame.anim:Finish()
		HenchmenCalloutFrame:Hide()
		HenchmenFrame.anim:Finish()
		HenchmenFrame:Hide()
		HenchmenFrameBG:Hide()
		for i=1,5 do 
			local option=_G["HenchmenOptionButton"..i]
			option.anim:Finish()
			option:Hide()

			local minion=_G["MinionOptionButton"..i]
			minion.anim:Finish()
			minion:Hide()
		end 
		MOD.DockButton.Icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
	end 
end
--[[ 
########################################################## 
MAIL HELPER
##########################################################
]]--
function MOD:ToggleMailMinions()
	if not SV.db.SVHenchmen.mailOpener then 
		SVUI_MailMinion:Hide()
	else
		SVUI_MailMinion:Show()
	end 
end 

function MOD:LoadMailMinions()
	local SVUI_MailMinion = CreateFrame("Frame","SVUI_MailMinion",InboxFrame);
	SVUI_MailMinion:SetWidth(150)
	SVUI_MailMinion:SetHeight(25)
	SVUI_MailMinion:SetPoint("CENTER",InboxFrame,"TOP",-22,-400)

	local SVUI_GetMailButton=CreateFrame("Button","SVUI_GetMailButton",SVUI_MailMinion,"UIPanelButtonTemplate")
	SVUI_GetMailButton:SetWidth(70)
	SVUI_GetMailButton:SetHeight(25)
	SVUI_GetMailButton:SetStylePanel("Button")
	SVUI_GetMailButton:SetPoint("LEFT",SVUI_MailMinion,"LEFT",0,0)
	SVUI_GetMailButton:SetText("Get All")
	SVUI_GetMailButton:SetScript("OnClick",GetAllMail)
	SVUI_GetMailButton:SetScript("OnEnter",function()
		GameTooltip:SetOwner(SVUI_GetMailButton,"ANCHOR_RIGHT")
		GameTooltip:AddLine(string.format("%d messages",GetInboxNumItems()),1,1,1)
		GameTooltip:Show()
	end)
	SVUI_GetMailButton:SetScript("OnLeave",function()GameTooltip:Hide()end)
	SVUI_GetMailButton:SetScript("OnEvent",function(l,m,h,n,o,p)
		if m=="UI_ERROR_MESSAGE"then 
			if h==ERR_INV_FULL or h==ERR_ITEM_MAX_COUNT then 
				StopOpeningMail("Your bags are too full!")
			end 
		end 
	end)
	
	local SVUI_GetGoldButton=CreateFrame("Button","SVUI_GetGoldButton",SVUI_MailMinion,"UIPanelButtonTemplate")
	SVUI_GetGoldButton:SetWidth(70)
	SVUI_GetGoldButton:SetHeight(25)
	SVUI_GetGoldButton:SetStylePanel("Button")
	SVUI_GetGoldButton:SetPoint("RIGHT",SVUI_MailMinion,"RIGHT",0,0)
	SVUI_GetGoldButton:SetText("Get Gold")
	SVUI_GetGoldButton:SetScript("OnClick",GetAllMailCash)
	SVUI_GetGoldButton:SetScript("OnEnter",function()
		if not total_cash then 
			total_cash=0;
			for a=0,GetInboxNumItems()do 
				total_cash=total_cash + select(5,GetInboxHeaderInfo(a))
			end 
		end 
		GameTooltip:SetOwner(SVUI_GetGoldButton,"ANCHOR_RIGHT")
		GameTooltip:AddLine(FancifyMoneys(total_cash),1,1,1)
		GameTooltip:Show()
	end)
	SVUI_GetGoldButton:SetScript("OnLeave",function()GameTooltip:Hide()end)
end 
--[[ 
########################################################## 
INVITE AUTOMATONS
##########################################################
]]--
function MOD:PARTY_INVITE_REQUEST(event, invitedBy)
	if(not SV.db.SVHenchmen.autoAcceptInvite) then return; end

	if(QueueStatusMinimapButton:IsShown() or IsInGroup()) then return end
	if(GetNumFriends() > 0) then 
		ShowFriends() 
	end
	if(IsInGuild()) then 
		GuildRoster() 
	end

	hideStatic = true;
	local invited = false;

	for f = 1, GetNumFriends() do 
		local friend = gsub(GetFriendInfo(f), "-.*", "")
		if(friend == invitedBy) then 
			AcceptGroup()
			invited = true;
			SV:AddonMessage("Accepted an Invite From Your Friends!")
			break;
		end 
	end

	if(not invited) then 
		for b = 1, BNGetNumFriends() do 
			local _, _, _, _, friend = BNGetFriendInfo(b)
			invitedBy = invitedBy:match("(.+)%-.+") or invitedBy;
			if(friend == invitedBy) then 
				AcceptGroup()
				invited = true;
				SV:AddonMessage("Accepted an Invite From Your Friends!")
				break;
			end 
		end 
	end

	if(not invited) then 
		for g = 1, GetNumGuildMembers(true) do 
			local guildMate = gsub(GetGuildRosterInfo(g), "-.*", "")
			if(guildMate == invitedBy) then 
				AcceptGroup()
				invited = true;
				SV:AddonMessage("Accepted an Invite From Your Guild!")
				break;
			end 
		end 
	end

	if(invited) then
		local popup = StaticPopup_FindVisible("PARTY_INVITE")
		if(popup) then
			popup.inviteAccepted = 1
			StaticPopup_Hide("PARTY_INVITE")
		else
			popup = StaticPopup_FindVisible("PARTY_INVITE_XREALM")
			if(popup) then
				popup.inviteAccepted = 1
				StaticPopup_Hide("PARTY_INVITE_XREALM")
			end
		end
	end 
end
--[[ 
########################################################## 
REPAIR AUTOMATONS
##########################################################
]]--
function MOD:MERCHANT_SHOW()
	if SV.db.SVHenchmen.vendorGrays then SV.SVBag:VendorGrays(nil, true) end 
	local autoRepair = SV.db.SVHenchmen.autoRepair;
	if IsShiftKeyDown() or autoRepair == "NONE" or not CanMerchantRepair() then return end 
	local repairCost,canRepair=GetRepairAllCost()
	local loan = GetGuildBankWithdrawMoney()
	if autoRepair == "GUILD" and (not CanGuildBankRepair() or (repairCost > loan)) then autoRepair = "PLAYER" end 
	if repairCost > 0 then 
		if canRepair then 
			RepairAllItems(autoRepair=='GUILD')
			local x,y,z= repairCost % 100,floor((repairCost % 10000)/100), floor(repairCost / 10000)
			if autoRepair=='GUILD' then 
				SV:AddonMessage("Repairs Complete! ...Using Guild Money!\n"..GetCoinTextureString(repairCost,12))
			else 
				SV:AddonMessage("Repairs Complete!\n"..GetCoinTextureString(repairCost,12))
			end 
		else 
			SV:AddonMessage("The Minions Say You Are Too Broke To Repair! They Are Laughing..")
		end 
	end 
end
--[[ 
########################################################## 
REP AUTOMATONS
##########################################################
]]--
function MOD:CHAT_MSG_COMBAT_FACTION_CHANGE(event, msg)
	if not SV.db.SVHenchmen.autorepchange then return end 
	local _, _, faction, amount = msg:find(incpat)
	if not faction then 
		_, _, faction, amount = msg:find(changedpat) or msg:find(decpat) 
	end
	if faction and faction ~= GUILD_REPUTATION then
		local active = GetWatchedFactionInfo()
		for factionIndex = 1, GetNumFactions() do
			local name = GetFactionInfo(factionIndex)
			if name == faction and name ~= active then
				SetWatchedFactionIndex(factionIndex)
				local strMsg = ("Watching Faction: %s"):format(name)
				SV:AddonMessage(strMsg)
				break
			end
		end
	end
end
--[[ 
########################################################## 
QUEST AUTOMATONS
##########################################################
]]--
function MOD:AutoQuestProxy()
	if(IsShiftKeyDown()) then return false; end
    if((not QuestIsDaily() or not QuestIsWeekly()) and (SV.db.SVHenchmen.autodailyquests)) then return false; end
    if(QuestFlagsPVP() and (not SV.db.SVHenchmen.autopvpquests)) then return false; end
    return true
end

function MOD:QUEST_GREETING()
    if(SV.db.SVHenchmen.autoquestaccept == true and self:AutoQuestProxy()) then
        local active,available = GetNumActiveQuests(), GetNumAvailableQuests()
        if(active + available == 0) then return end
        if(available > 0) then
            SelectAvailableQuest(1)
        end
        if(active > 0) then
            SelectActiveQuest(1)
        end
    end
end

function MOD:GOSSIP_SHOW()
    if(SV.db.SVHenchmen.autoquestaccept == true and self:AutoQuestProxy()) then
        if GetGossipAvailableQuests() then
            SelectGossipAvailableQuest(1)
        elseif GetGossipActiveQuests() then
            SelectGossipActiveQuest(1)
        end
    end
end

function MOD:QUEST_DETAIL()
    if(SV.db.SVHenchmen.autoquestaccept == true and self:AutoQuestProxy()) then 
        if not QuestGetAutoAccept() then
			AcceptQuest()
		else
			CloseQuest()
		end
    end
end

function MOD:QUEST_ACCEPT_CONFIRM()
    if(SV.db.SVHenchmen.autoquestaccept == true and self:AutoQuestProxy()) then
        ConfirmAcceptQuest()
        StaticPopup_Hide("QUEST_ACCEPT_CONFIRM")
    end
end

function MOD:QUEST_PROGRESS()
	if(IsShiftKeyDown()) then return false; end
    if(SV.db.SVHenchmen.autoquestcomplete == true and IsQuestCompletable()) then
        CompleteQuest()
    end
end

function MOD:QUEST_COMPLETE()
	if(not SV.db.SVHenchmen.autoquestcomplete and (not SV.db.SVHenchmen.autoquestreward)) then return end 
	if(IsShiftKeyDown()) then return false; end
	local rewards = GetNumQuestChoices()
	local rewardsFrame = QuestInfoFrame.rewardsFrame;
	if(rewards > 1) then
		local auto_select = QuestFrameRewardPanel.itemChoice or QuestInfoFrame.itemChoice;
		local selection, value = 1, 0;
		
		for i = 1, rewards do 
			local iLink = GetQuestItemLink("choice", i)
			if iLink then 
				local iValue = select(11,GetItemInfo(iLink))
				if iValue and iValue > value then 
					value = iValue;
					selection = i 
				end 
			end 
		end

		local chosenItem = QuestInfo_GetRewardButton(rewardsFrame, selection)
		
		if chosenItem.type == "choice" then 
			QuestInfoItemHighlight:ClearAllPoints()
			QuestInfoItemHighlight:SetAllPoints(chosenItem)
			QuestInfoItemHighlight:Show()
			QuestInfoFrame.itemChoice = chosenItem:GetID()
			SV:AddonMessage("A Minion Has Chosen Your Reward!")
		end

		auto_select = selection

		if SV.db.SVHenchmen.autoquestreward == true then
			GetQuestReward(auto_select)
		end
	else
		if(SV.db.SVHenchmen.autoquestcomplete == true) then
			GetQuestReward(rewards)
		end
	end
end 
--[[ 
########################################################## 
BUILD FUNCTION / UPDATE
##########################################################
]]--
function MOD:Load()
	self.DockButton = SV.Dock:SetDockButton("BottomRight", "Call Henchman!", [[Interface\AddOns\SVUI\assets\artwork\Icons\DOCK-HENCHMAN]], SV.ToggleHenchman, "SVUI_Henchmen")

	if IsAddOnLoaded("Postal") then 
		SV.db.SVHenchmen.mailOpener = false
	else
		self:LoadMailMinions()
		self:ToggleMailMinions()
	end 

	self:RegisterEvent('PARTY_INVITE_REQUEST')

	for _,event in pairs(AutomatedEvents) do
		self:RegisterEvent(event)
	end

	if SV.db.SVHenchmen.pvpautorelease then 
		local autoReleaseHandler = CreateFrame("frame")
		autoReleaseHandler:RegisterEvent("PLAYER_DEAD")
		autoReleaseHandler:SetScript("OnEvent",function(self,event)
			local isInstance, instanceType = IsInInstance()
			if(isInstance and instanceType == "pvp") then 
				local spell = GetSpellInfo(20707)
				if(SV.class ~= "SHAMAN" and not(spell and UnitBuff("player",spell))) then 
					RepopMe()
				end 
			end 
			for i=1,GetNumWorldPVPAreas() do 
				local _,localizedName, isActive = GetWorldPVPAreaInfo(i)
				if(GetRealZoneText() == localizedName and isActive) then RepopMe() end 
			end 
		end)
	end 

	if(SV.db.SVHenchmen.skipcinematics) then
		local skippy = CreateFrame("Frame")
		skippy:RegisterEvent("CINEMATIC_START")
		skippy:SetScript("OnEvent", function(self, event)
			CinematicFrame_CancelCinematic()
		end)

		MovieFrame:SetScript("OnEvent", function() GameMovieFinished() end)
	end
end 