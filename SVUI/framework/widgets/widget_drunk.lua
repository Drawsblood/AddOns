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

SV.Drunk = _G["SVUI_BoozedUpFrame"];
local WORN_ITEMS = {};
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local DRUNK_EFFECT = [[Spells\Largebluegreenradiationfog.m2]];
local DRUNK_EFFECT2 = [[Spells\Monk_drunkenhaze_impact.m2]];
local TIPSY_FILTERS = {
	[DRUNK_MESSAGE_ITEM_SELF1] = true,
	[DRUNK_MESSAGE_ITEM_SELF2] = true,
	[DRUNK_MESSAGE_SELF1] = true,
	[DRUNK_MESSAGE_SELF2] = true,
};
local DRUNK_FILTERS = {
	[DRUNK_MESSAGE_ITEM_SELF3] = true,
	[DRUNK_MESSAGE_ITEM_SELF4] = true,
	[DRUNK_MESSAGE_SELF3] = true,
	[DRUNK_MESSAGE_SELF4] = true,
};
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
local function GetNekkid()
	for c = 1, 19 do
		if CursorHasItem() then 
			ClearCursor()
		end
		local item = GetInventoryItemID("player", c);
		WORN_ITEMS[c] = item;
		PickupInventoryItem(c);
		for b = 1, 4 do 
			if CursorHasItem() then
				PutItemInBag(b)
			end  
		end 
	end
end

local function GetDressed()
	for c, item in pairs(WORN_ITEMS) do 
		if(item) then
			EquipItemByName(item)
			WORN_ITEMS[c] = false
		end
	end
end

function SV.Drunk:PartysOver()
	SetCVar("Sound_MusicVolume", 0)
	SetCVar("Sound_EnableMusic", 0)
	StopMusic()
	SV.Drunk:Hide()
	SV.Drunk.PartyMode = nil
	SV:AddonMessage("Party's Over...")
	--GetDressed()
end

function SV.Drunk:LetsParty()
	--GetNekkid()
	self.PartyMode = true
	SetCVar("Sound_MusicVolume", 100)
	SetCVar("Sound_EnableMusic", 1)
	StopMusic()
	PlayMusic([[Interface\AddOns\SVUI\assets\sounds\beer30.mp3]])
	self:Show()
	self.ScreenEffect1:ClearModel()
	self.ScreenEffect1:SetModel(DRUNK_EFFECT)
	self.ScreenEffect2:ClearModel()
	self.ScreenEffect2:SetModel(DRUNK_EFFECT2)
	self.ScreenEffect3:ClearModel()
	self.ScreenEffect3:SetModel(DRUNK_EFFECT2)
	SV:AddonMessage("YEEEEEEEEE-HAW!!!")
	DoEmote("dance")
	-- SV.Timers:ExecuteTimer(PartysOver, 60)
end 

local DrunkAgain_OnEvent = function(self, event, message, ...)
	if(self.PartyMode) then
		for pattern,_ in pairs(TIPSY_FILTERS) do
			if(message:find(pattern)) then
				self:PartysOver()
				break
			end
		end
	else
		for pattern,_ in pairs(DRUNK_FILTERS) do
			if(message:find(pattern)) then
				self:LetsParty()
				break
			end
		end
	end 
end

function SV.Drunk:Toggle()
	if(not SV.db.general.drunk) then 
		self:UnregisterEvent("CHAT_MSG_SYSTEM")
		self:SetScript("OnEvent", nil)
	else 
		self:RegisterEvent("CHAT_MSG_SYSTEM")
		self:SetScript("OnEvent", DrunkAgain_OnEvent)
	end 
end

function SV.Drunk:Initialize()
	self:SetParent(SV.Screen)
	self:ClearAllPoints()
	self:SetAllPoints(SV.Screen)

	self.ScreenEffect1:SetParent(self)
	self.ScreenEffect1:SetAllPoints(SV.Screen)
	self.ScreenEffect1:SetModel(DRUNK_EFFECT)
	self.ScreenEffect1:SetCamDistanceScale(1)

	self.ScreenEffect2:SetParent(self)
	self.ScreenEffect2:SetPointToScale("BOTTOMLEFT", SV.Screen, "BOTTOMLEFT", 0, 0)
	self.ScreenEffect2:SetPointToScale("TOPRIGHT", SV.Screen, "TOP", 0, 0)
	--self.ScreenEffect2:SetSizeToScale(350, 600)
	self.ScreenEffect2:SetModel(DRUNK_EFFECT2)
	self.ScreenEffect2:SetCamDistanceScale(0.25)
	--self.ScreenEffect2:SetPosition(-0.21,-0.15,0)

	self.ScreenEffect3:SetParent(self)
	self.ScreenEffect3:SetPointToScale("BOTTOMRIGHT", SV.Screen, "BOTTOMRIGHT", 0, 0)
	self.ScreenEffect3:SetPointToScale("TOPLEFT", SV.Screen, "TOP", 0, 0)
	--self.ScreenEffect3:SetSizeToScale(350, 600)
	self.ScreenEffect3:SetModel(DRUNK_EFFECT2)
	self.ScreenEffect3:SetCamDistanceScale(0.25)
	--self.ScreenEffect3:SetPosition(-0.21,-0.15,0)

	self.YeeHaw = _G["SVUI_DrunkenYeeHaw"]
	self.YeeHaw:SetParent(self)
	self.YeeHaw:SetSizeToScale(512,350)
	self.YeeHaw:SetPointToScale("TOP", SV.Screen, "TOP", 0, -50);

	self:Hide()

	self:Toggle()
end