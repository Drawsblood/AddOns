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
local string 	= _G.string;
local table     = _G.table;
local format = string.format;
local tcopy = table.copy;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local SVLib = LibSuperVillain("Registry");
local L = SV.L;
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local CURRENT_PAGE, MAX_PAGE, XOFF = 0, 9, (GetScreenWidth() * 0.025)
local okToResetMOVE = false
local mungs = false;
local user_music_vol = GetCVar("Sound_MusicVolume") or 0;
local musicIsPlaying;
local PageData, OnClickData
local CUSTOM_CLASS_COLORS = _G.CUSTOM_CLASS_COLORS
local RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS
local scc = CUSTOM_CLASS_COLORS[SV.class];
local rcc = RAID_CLASS_COLORS[SV.class];
local r2 = .1 + (rcc.r * .1)
local g2 = .1 + (rcc.g * .1)
local b2 = .1 + (rcc.b * .1)
local SetCVar = _G.SetCVar;
local ToggleChatColorNamesByClassGroup = _G.ToggleChatColorNamesByClassGroup;
local ChatFrame_AddMessageGroup = _G.ChatFrame_AddMessageGroup;
--[[ 
########################################################## 
SETUP CLASS OBJECT
##########################################################
]]--
SV.Setup = {};
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function PlayThemeSong()
	if(not musicIsPlaying) then
		SetCVar("Sound_MusicVolume", 100)
		SetCVar("Sound_EnableMusic", 1)
		StopMusic()
		PlayMusic([[Interface\AddOns\SVUI\assets\sounds\SuperVillain.mp3]])
		musicIsPlaying = true
	end
end 

local function SetInstallButton(button)
    if(not button) then return end 
    button.Left:SetAlpha(0)
    button.Middle:SetAlpha(0)
    button.Right:SetAlpha(0)
    button:SetNormalTexture("")
    button:SetPushedTexture("")
    button:SetPushedTexture("")
    button:SetDisabledTexture("")
    button:RemoveTextures()
    button:SetFrameLevel(button:GetFrameLevel() + 1)
end 

local function forceCVars()
	SetCVar("alternateResourceText",1)
	SetCVar("statusTextDisplay","BOTH")
	SetCVar("ShowClassColorInNameplate",1)
	SetCVar("screenshotQuality",10)
	SetCVar("chatMouseScroll",1)
	SetCVar("chatStyle","classic")
	SetCVar("WholeChatWindowClickable",0)
	SetCVar("ConversationMode","inline")
	SetCVar("showTutorials",0)
	SetCVar("UberTooltips",1)
	SetCVar("threatWarning",3)
	SetCVar('alwaysShowActionBars',1)
	SetCVar('lockActionBars',1)
	SetCVar('SpamFilter',0)
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:SetValue('SHIFT')
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:RefreshValue()
end

local function ShowLayout(show)
	if(not _G["SVUI_Raid"] or (show and _G["SVUI_Raid"].forceShow == true)) then return end
	if(not show and _G["SVUI_Raid"].forceShow ~= true) then return end
	SV.SVUnit:ViewGroupFrames(_G["SVUI_Raid"], show)
end

local function ShowAuras(show)
	if(not _G["SVUI_Player"] or (show and _G["SVUI_Player"].forceShowAuras)) then return end
	if(not show and not _G["SVUI_Player"].forceShowAuras) then return end
	_G["SVUI_Player"].forceShowAuras = show
	SV.SVUnit:SetUnitFrame("player")
end

local function BarShuffle()
	local bar2 = SV.db.SVBar.Bar2.enable;
	local base = 30;
	local bS = SV.db.SVBar.Bar1.buttonspacing;
	local tH = SV.db.SVBar.Bar1.buttonsize  +  (base - bS);
	local b2h = bar2 and tH or base;
	local sph = (400 - b2h);
	local anchors = SV.cache.Anchors
	if not anchors then anchors = {} end
	anchors.SVUI_SpecialAbility_MOVE = "BOTTOMSVUIParentBOTTOM0"..sph;
	anchors.SVUI_ActionBar2_MOVE = "BOTTOMSVUI_ActionBar1TOP0"..(-bS);
	anchors.SVUI_ActionBar3_MOVE = "BOTTOMLEFTSVUI_ActionBar1BOTTOMRIGHT40";
	anchors.SVUI_ActionBar5_MOVE = "BOTTOMRIGHTSVUI_ActionBar1BOTTOMLEFT-40";
	if bar2 then
		anchors.SVUI_PetActionBar_MOVE = "BOTTOMLEFTSVUI_ActionBar2TOPLEFT04"
		anchors.SVUI_StanceBar_MOVE = "BOTTOMRIGHTSVUI_ActionBar2TOPRIGHT04";
	else
		anchors.SVUI_PetActionBar_MOVE = "BOTTOMLEFTSVUI_ActionBar1TOPLEFT04"
		anchors.SVUI_StanceBar_MOVE = "BOTTOMRIGHTSVUI_ActionBar1TOPRIGHT04";
	end
end 

local function UFMoveBottomQuadrant(toggle)
	local anchors = SV.cache.Anchors
	if not toggle then
		anchors.SVUI_Player_MOVE = "BOTTOMSVUIParentBOTTOM-278182"
		anchors.SVUI_PlayerCastbar_MOVE = "BOTTOMSVUIParentBOTTOM-278122"
		anchors.SVUI_Target_MOVE = "BOTTOMSVUIParentBOTTOM278182"
		anchors.SVUI_TargetCastbar_MOVE = "BOTTOMSVUIParentBOTTOM278122"
		--anchors.SVUI_Pet_MOVE = "BOTTOMSVUIParentBOTTOM0181"
		anchors.SVUI_TargetTarget_MOVE = "BOTTOMSVUIParentBOTTOM0182"
		anchors.SVUI_Focus_MOVE = "BOTTOMSVUIParentBOTTOM310432"
		anchors.SVUI_ThreatBar_MOVE = "BOTTOMRIGHTSVUIParentBOTTOMRIGHT-495182"
	elseif toggle == "shift" then
		anchors.SVUI_Player_MOVE = "BOTTOMSVUIParentBOTTOM-278210"
		anchors.SVUI_PlayerCastbar_MOVE = "BOTTOMSVUIParentBOTTOM-278150"
		anchors.SVUI_Target_MOVE = "BOTTOMSVUIParentBOTTOM278210"
		anchors.SVUI_TargetCastbar_MOVE = "BOTTOMSVUIParentBOTTOM278150"
		--anchors.SVUI_Pet_MOVE = "BOTTOMSVUIParentBOTTOM0209"
		anchors.SVUI_TargetTarget_MOVE = "BOTTOMSVUIParentBOTTOM0210"
		anchors.SVUI_Focus_MOVE = "BOTTOMSVUIParentBOTTOM310432"
		anchors.SVUI_ThreatBar_MOVE = "BOTTOMRIGHTSVUIParentBOTTOMRIGHT-495210"
	elseif toggle == "minimal" then
		anchors.SVUI_Player_MOVE = "BOTTOMSVUIParentBOTTOM-278182"
		anchors.SVUI_PlayerCastbar_MOVE = "BOTTOMSVUIParentBOTTOM-278122"
		anchors.SVUI_Target_MOVE = "BOTTOMSVUIParentBOTTOM278182"
		anchors.SVUI_TargetCastbar_MOVE = "BOTTOMSVUIParentBOTTOM278122"
		--anchors.SVUI_Pet_MOVE = "BOTTOMSVUIParentBOTTOM0181"
		anchors.SVUI_TargetTarget_MOVE = "BOTTOMSVUIParentBOTTOM0182"
		anchors.SVUI_Focus_MOVE = "BOTTOMSVUIParentBOTTOM310432"
		anchors.SVUI_ThreatBar_MOVE = "BOTTOMRIGHTSVUIParentBOTTOMRIGHT-495182"
	else
		local c = 136;
		local d = 135;
		local e = 80;
		anchors.SVUI_Player_MOVE = "BOTTOMSVUIParentBOTTOM"..-c..""..d;
		anchors.SVUI_PlayerCastbar_MOVE = "BOTTOMSVUIParentBOTTOM"..-c..""..(d-60);
		anchors.SVUI_Target_MOVE = "BOTTOMSVUIParentBOTTOM"..c..""..d;
		anchors.SVUI_TargetCastbar_MOVE = "BOTTOMSVUIParentBOTTOM"..c..""..(d-60);
		--anchors.SVUI_Pet_MOVE = "BOTTOMSVUIParentBOTTOM"..-c..""..e;
		anchors.SVUI_TargetTarget_MOVE = "BOTTOMSVUIParentBOTTOM"..c..""..e;
		anchors.SVUI_Focus_MOVE = "BOTTOMSVUIParentBOTTOM"..c..""..(d + 150);
		anchors.SVUI_ThreatBar_MOVE = "BOTTOMRIGHTSVUIParentBOTTOMRIGHT-495"..d;
	end
end 

local function UFMoveLeftQuadrant(toggle)
	local anchors = SV.cache.Anchors
	if not toggle then
		anchors.SVUI_Assist_MOVE = "TOPLEFTSVUIParentTOPLEFT"..XOFF.."-250"
		anchors.SVUI_Tank_MOVE = "TOPLEFTSVUIParentTOPLEFT"..XOFF.."-175"
		anchors.SVUI_Raidpet_MOVE = "TOPLEFTSVUIParentTOPLEFT"..XOFF.."-325"
		anchors.SVUI_Party_MOVE = "BOTTOMLEFTSVUIParentBOTTOMLEFT"..XOFF.."400"
		anchors.SVUI_Raid10_MOVE = "BOTTOMLEFTSVUIParentBOTTOMLEFT"..XOFF.."400"
		anchors.SVUI_Raid25_MOVE = "BOTTOMLEFTSVUIParentBOTTOMLEFT"..XOFF.."400"
		anchors.SVUI_Raid40_MOVE = "BOTTOMLEFTSVUIParentBOTTOMLEFT"..XOFF.."400"
	else
		anchors.SVUI_Assist_MOVE = "TOPLEFTSVUIParentTOPLEFT4-250"
		anchors.SVUI_Tank_MOVE = "TOPLEFTSVUIParentTOPLEFT4-175"
		anchors.SVUI_Raidpet_MOVE = "TOPLEFTSVUIParentTOPLEFT4-325"
		anchors.SVUI_Party_MOVE = "BOTTOMLEFTSVUIParentBOTTOMLEFT4300"
		anchors.SVUI_Raid40_MOVE = "BOTTOMLEFTSVUIParentBOTTOMLEFT4300"
		anchors.SVUI_Raid10_MOVE = "BOTTOMLEFTSVUIParentBOTTOMLEFT4300"
		anchors.SVUI_Raid25_MOVE = "BOTTOMLEFTSVUIParentBOTTOMLEFT4300"
	end
end 

local function UFMoveTopQuadrant(toggle)
	local anchors = SV.cache.Anchors
	if not toggle then
		anchors.GM_MOVE = "TOPLEFTSVUIParentTOPLEFT250-25"
		anchors.SVUI_LootFrame_MOVE = "BOTTOMSVUIParentBOTTOM0350"
		anchors.SVUI_AltPowerBar_MOVE = "TOPSVUIParentTOP0-40"
		anchors.LoC_MOVE = "BOTTOMSVUIParentBOTTOM0350"
		anchors.BattleNetToasts_MOVE = "TOPRIGHTSVUIParentTOPRIGHT-4-250"
	else
		anchors.GM_MOVE = "TOPLEFTSVUIParentTOPLEFT344-25"
		anchors.SVUI_LootFrame_MOVE = "BOTTOMSVUIParentBOTTOM0254"
		anchors.SVUI_AltPowerBar_MOVE = "TOPSVUIParentTOP0-39"
		anchors.LoC_MOVE = "BOTTOMSVUIParentBOTTOM0443"
		anchors.BattleNetToasts_MOVE = "TOPRIGHTSVUIParentTOPRIGHT-4-248"
	end
end 

local function UFMoveRightQuadrant(toggle)
	local anchors = SV.cache.Anchors
	local dH = SV.db.Dock.dockRightHeight  +  60
	if not toggle or toggle == "high" then
		anchors.SVUI_BossHolder_MOVE = "RIGHTSVUIParentRIGHT-1050"
		anchors.SVUI_ArenaHolder_MOVE = "RIGHTSVUIParentRIGHT-1050"
		anchors.Tooltip_MOVE = "BOTTOMRIGHTSVUIParentBOTTOMRIGHT-284"..dH;
	else
		anchors.SVUI_BossHolder_MOVE = "RIGHTSVUIParentRIGHT-1050"
		anchors.SVUI_ArenaHolder_MOVE = "RIGHTSVUIParentRIGHT-1050"
		anchors.Tooltip_MOVE = "BOTTOMRIGHTSVUIParentBOTTOMRIGHT-284"..dH;
	end
end  
--[[ 
########################################################## 
GLOBAL/MODULE FUNCTIONS
##########################################################
]]--
function SV.Setup:UserScreen(rez, preserve)
	if not preserve then
		if okToResetMOVE then 
			SV.Mentalo:Reset("")
			okToResetMOVE = false;
		end
		SV:ResetData("SVUnit")
	end

	if rez == "low" then 
		if not preserve then 
			SV.db.Dock.dockLeftWidth = 350;
			SV.db.Dock.dockLeftHeight = 180;
			SV.db.Dock.dockRightWidth = 350;
			SV.db.Dock.dockRightHeight = 180;
			SV.db.SVAura.wrapAfter = 10
			SV.db.SVUnit.fontSize = 10;
			SV.db.SVUnit.player.width = 200;
			SV.db.SVUnit.player.castbar.width = 200;
			SV.db.SVUnit.player.classbar.fill = "fill"
			SV.db.SVUnit.player.health.tags = "[health:color][health:current]"
			SV.db.SVUnit.target.width = 200;
			SV.db.SVUnit.target.castbar.width = 200;
			SV.db.SVUnit.target.health.tags = "[health:color][health:current]"
			SV.db.SVUnit.pet.power.enable = false;
			SV.db.SVUnit.pet.width = 200;
			SV.db.SVUnit.pet.height = 26;
			SV.db.SVUnit.targettarget.debuffs.enable = false;
			SV.db.SVUnit.targettarget.power.enable = false;
			SV.db.SVUnit.targettarget.width = 200;
			SV.db.SVUnit.targettarget.height = 26;
			SV.db.SVUnit.boss.width = 200;
			SV.db.SVUnit.boss.castbar.width = 200;
			SV.db.SVUnit.arena.width = 200;
			SV.db.SVUnit.arena.castbar.width = 200 
		end 
		if not mungs then
			UFMoveBottomQuadrant(true)
			UFMoveLeftQuadrant(true)
			UFMoveTopQuadrant(true)
			UFMoveRightQuadrant(true)
		end
		SV.LowRez = true 
	else
		SV:ResetData("Dock")
		SV:ResetData("SVAura")
		if not mungs then
			UFMoveBottomQuadrant()
			UFMoveLeftQuadrant()
			UFMoveTopQuadrant()
			UFMoveRightQuadrant()
		end
		SV.LowRez = nil 
	end 

	if(not preserve and not mungs) then
		BarShuffle()
    	SV.Mentalo:SetPositions()
		SVLib:RefreshModule('Dock')
		SVLib:RefreshModule('SVAura')
		SVLib:RefreshModule('SVBar')
		SVLib:RefreshModule('SVUnit')
		SV:SavedPopup()
	end
end

function SV.Setup:ChatConfigs(mungs)
	forceCVars()

	local ChatFrame1 = _G.ChatFrame1;
	FCF_ResetChatWindows()
	FCF_SetLocked(ChatFrame1, 1)

	local ChatFrame2 = _G.ChatFrame2;
	FCF_DockFrame(ChatFrame2)
	FCF_SetLocked(ChatFrame2, 2)

	FCF_OpenNewWindow(LOOT)

	local ChatFrame3 = _G.ChatFrame3;
	FCF_DockFrame(ChatFrame3)
	FCF_SetLocked(ChatFrame3, 3)

	for i = 1, NUM_CHAT_WINDOWS do
		local chat = _G["ChatFrame"..i]
		local chatID = chat:GetID()
		if i == 1 then 
			chat:ClearAllPoints()
			chat:SetAllPoints(SV.SVChat.Dock);
		end 
		FCF_SavePositionAndDimensions(chat)
		FCF_StopDragging(chat)
		FCF_SetChatWindowFontSize(nil, chat, 12)
		if i == 1 then 
			FCF_SetWindowName(chat, GENERAL)
		elseif i == 2 then 
			FCF_SetWindowName(chat, GUILD_EVENT_LOG)
		elseif i == 3 then 
			FCF_SetWindowName(chat, LOOT)
		end 
	end 
	ChatFrame_RemoveAllMessageGroups(ChatFrame1)
	ChatFrame_AddMessageGroup(ChatFrame1, "SAY")
	ChatFrame_AddMessageGroup(ChatFrame1, "EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1, "YELL")
	ChatFrame_AddMessageGroup(ChatFrame1, "GUILD")
	ChatFrame_AddMessageGroup(ChatFrame1, "OFFICER")
	ChatFrame_AddMessageGroup(ChatFrame1, "GUILD_ACHIEVEMENT")
	ChatFrame_AddMessageGroup(ChatFrame1, "WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_SAY")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_YELL")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_BOSS_EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1, "PARTY")
	ChatFrame_AddMessageGroup(ChatFrame1, "PARTY_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID_WARNING")
	ChatFrame_AddMessageGroup(ChatFrame1, "INSTANCE_CHAT")
	ChatFrame_AddMessageGroup(ChatFrame1, "INSTANCE_CHAT_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "BATTLEGROUND")
	ChatFrame_AddMessageGroup(ChatFrame1, "BATTLEGROUND_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_HORDE")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_ALLIANCE")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_NEUTRAL")
	ChatFrame_AddMessageGroup(ChatFrame1, "SYSTEM")
	ChatFrame_AddMessageGroup(ChatFrame1, "ERRORS")
	ChatFrame_AddMessageGroup(ChatFrame1, "AFK")
	ChatFrame_AddMessageGroup(ChatFrame1, "DND")
	ChatFrame_AddMessageGroup(ChatFrame1, "IGNORED")
	ChatFrame_AddMessageGroup(ChatFrame1, "ACHIEVEMENT")
	ChatFrame_AddMessageGroup(ChatFrame1, "BN_WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame1, "BN_CONVERSATION")
	ChatFrame_AddMessageGroup(ChatFrame1, "BN_INLINE_TOAST_ALERT")
	ChatFrame_AddMessageGroup(ChatFrame1, "COMBAT_FACTION_CHANGE")
	ChatFrame_AddMessageGroup(ChatFrame1, "SKILL")
	ChatFrame_AddMessageGroup(ChatFrame1, "LOOT")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONEY")
	ChatFrame_AddMessageGroup(ChatFrame1, "COMBAT_XP_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame1, "COMBAT_HONOR_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame1, "COMBAT_GUILD_XP_GAIN")
	
	ChatFrame_RemoveAllMessageGroups(ChatFrame3)
	ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_FACTION_CHANGE")
	ChatFrame_AddMessageGroup(ChatFrame3, "SKILL")
	ChatFrame_AddMessageGroup(ChatFrame3, "LOOT")
	ChatFrame_AddMessageGroup(ChatFrame3, "MONEY")
	ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_XP_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_HONOR_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_GUILD_XP_GAIN")

	ChatFrame_AddChannel(ChatFrame1, GENERAL)

	ToggleChatColorNamesByClassGroup(true, "SAY")
	ToggleChatColorNamesByClassGroup(true, "EMOTE")
	ToggleChatColorNamesByClassGroup(true, "YELL")
	ToggleChatColorNamesByClassGroup(true, "GUILD")
	ToggleChatColorNamesByClassGroup(true, "OFFICER")
	ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "WHISPER")
	ToggleChatColorNamesByClassGroup(true, "PARTY")
	ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID")
	ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")
	ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT")
	ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT_LEADER")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL6")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL7")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL8")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL9")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL10")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL11")

	ChangeChatColor("CHANNEL1", 195 / 255, 230 / 255, 232 / 255)
	ChangeChatColor("CHANNEL2", 232 / 255, 158 / 255, 121 / 255)
	ChangeChatColor("CHANNEL3", 232 / 255, 228 / 255, 121 / 255)

	if not mungs then
		if SV.Chat then 
			SV.Chat:ReLoad(true)
			if SV.Dock.Cache.IsFaded == true then HideSuperDocks() end 
		end
		SV:SavedPopup()
	end
end

function SV.Setup:ColorTheme(style, preserve)
	style = style or "default";

	if not preserve then
		SV:ResetData("media")
	end

	self:CopyPreset("media", style)
	--print(table.dump(SV.db))
	SV.db.LAYOUT.mediastyle = style;

	if(style == "default") then 
		SV.db.SVUnit.healthclass = true;
	else
		SV.db.SVUnit.healthclass = false;
	end 
	
	if(not mungs) then
		SV:MediaUpdate()
		SVLib:RefreshModule('Dock')
		SVLib:RefreshModule('SVUnit')
		if(not preserve) then
			SV:SavedPopup()
		end
	end
end 

function SV.Setup:UnitframeLayout(style, preserve)
	style = style or "default";

	if not preserve then
		SV:ResetData("SVUnit")
		SV:ResetData("Dock")
		if okToResetMOVE then
			SV.Mentalo:Reset('')
			okToResetMOVE = false
		end
	end

	self:CopyPreset("units", style)
	SV.db.LAYOUT.unitstyle = style

	if(SV.db.LAYOUT.mediastyle == "default") then 
		SV.db.SVUnit.healthclass = true;
	end 

	if(not mungs) then
		if(not preserve) then
			if SV.db.LAYOUT.barstyle and (SV.db.LAYOUT.barstyle == "twosmall" or SV.db.LAYOUT.barstyle == "twobig") then 
				UFMoveBottomQuadrant("shift")
			else
				UFMoveBottomQuadrant()
			end
			SV.Mentalo:SetPositions()
		end
		SVLib:RefreshModule('Dock')
		SVLib:RefreshModule('SVUnit')
		if(not preserve) then
			SV:SavedPopup()
		end
	end
end 

function SV.Setup:GroupframeLayout(style, preserve)
	style = style or "default";

	self:CopyPreset("layouts", style)
	SV.db.LAYOUT.groupstyle = style

	if(not mungs) then
		SVLib:RefreshModule('SVUnit')
		if(not preserve) then
			SV:SavedPopup()
		end
	end
end 

function SV.Setup:BarLayout(style, preserve)
	style = style or "default";

	if not preserve then 
		SV:ResetData("SVBar")
		if okToResetMOVE then
			SV.Mentalo:Reset('')
			okToResetMOVE=false
		end
	end 

	self:CopyPreset("bars", style)
	SV.db.LAYOUT.barstyle = style;

	if(not mungs) then
		if(not preserve) then
			if(style == 'twosmall' or style == 'twobig') then 
				UFMoveBottomQuadrant("shift")
			else
				UFMoveBottomQuadrant()
			end
		end
		if(not preserve) then
			BarShuffle()
			SV.Mentalo:SetPositions()
		end
		SVLib:RefreshModule('Dock')
		SVLib:RefreshModule('SVBar')
		if(not preserve) then
			SV:SavedPopup()
		end
	end
end 

function SV.Setup:Auralayout(style, preserve)
	style = style or "default";
	self:CopyPreset("auras", style)

	SV.db.LAYOUT.aurastyle = style;

	if(not mungs) then
		SVLib:RefreshModule('Dock')
		SVLib:RefreshModule('SVAura')
		SVLib:RefreshModule('SVUnit')
		if(not preserve) then
			SV:SavedPopup()
		end
	end
end

function SV.Setup:CustomLayout(style)
	if((not style) or (not SV.CustomLayouts)) then return end;
	if(self:CopyCustom(style)) then
		SV.db.LAYOUT.custom = style
		SVLib:RefreshModule('SVBar')
		SVLib:RefreshModule('SVAura')
		SVLib:RefreshModule('SVUnit')
	end
end

function SV.Setup:EZDefault()
	mungs = true;
	okToResetMOVE = false;

	self:SetAllDefaults()

	self:ChatConfigs(true);
	self:UserScreen()
	self:ColorTheme("default", true);
	self:UnitframeLayout("default", true);
	self:GroupframeLayout("default", true);
	self:BarLayout("default", true);
	self:Auralayout("default", true);

	SV.db.general.comix = true;
	SV.db.general.gamemenu = true;
	SV.db.general.afk = true;
	SV.db.general.woot = true;

	SV.db.general.arenadrink = true;
	SV.db.general.stupidhat = true;
	SV.db.SVAura.hyperBuffs.enable = true;
	SV.db.SVBag.bagTools = true;
	SV.db.Dock.leftDockBackdrop = true;
	SV.db.Dock.rightDockBackdrop = true;
	SV.db.Dock.dataBackdrop = true;

	SV.db.SVGear.enable = true;
	SV.db.SVMap.customIcons = true;
	SV.db.SVMap.bordersize = 6;
	SV.db.SVMap.locationText = "";
	SV.db.SVMap.playercoords = "";
	SV.db.SVPlate.comicStyle = true;
	SV.db.SVTip.comicStyle = true;
	SV.db.SVTools.enable = true;
	SV.db.SVUnit.comicStyle = true;

	SVLib:SaveSafeData("install_version", SV.Version)
	StopMusic()
	SetCVar("Sound_MusicVolume", user_music_vol or 0)
	ReloadUI()
end

function SV.Setup:Minimalist()
	mungs = true;
	okToResetMOVE = false;
	self:SetAllDefaults()
	self:ChatConfigs(true);
	self:UserScreen()
	self:ColorTheme("classy", true);
	self:UnitframeLayout("compact", true);
	self:GroupframeLayout("grid", true);
	self:BarLayout("default", true);
	self:Auralayout("default", true);

	SV.db.general.comix = false;
	SV.db.general.gamemenu = false;
	SV.db.general.afk = false;
	SV.db.general.woot = false;

	SV.db.general.arenadrink = false;
	SV.db.general.stupidhat = false;
	SV.db.SVAura.hyperBuffs.enable = false;
	SV.db.SVBag.bagTools = false;
	--SV.db.Dock.leftDockBackdrop = false;
	--SV.db.Dock.rightDockBackdrop = false;
	SV.db.Dock.dataBackdrop = false;

	SV.db.SVGear.enable = false;
	SV.db.SVMap.customIcons = false;
	SV.db.SVMap.bordersize = 2;
	SV.db.SVMap.bordercolor = "dark";
	SV.db.SVMap.locationText = "HIDE";
	SV.db.SVMap.playercoords = "HIDE";
	SV.db.SVPlate.comicStyle = false;
	SV.db.SVTip.comicStyle = false;
	--SV.db.SVTools.enable = false;
	SV.db.SVUnit.comicStyle = false;

	SV.db.SVUnit.player.height = 22;
	SV.db.SVUnit.player.power.height = 6;

	SV.db.SVUnit.target.height = 22;
	SV.db.SVUnit.target.power.height = 6;
	SV.db.SVUnit.targettarget.height = 22;
	SV.db.SVUnit.targettarget.power.height = 6;
	SV.db.SVUnit.pet.height = 22;
	SV.db.SVUnit.pet.power.height = 6;
	SV.db.SVUnit.focus.height = 22;
	SV.db.SVUnit.focus.power.height = 6;
	SV.db.SVUnit.boss.height = 22;
	SV.db.SVUnit.boss.power.height = 6;

	UFMoveBottomQuadrant("minimal")

	SVLib:SaveSafeData("install_version", SV.Version)
	StopMusic()
	SetCVar("Sound_MusicVolume", user_music_vol or 0)
	ReloadUI()
end

function SV.Setup:Complete()
	SVLib:SaveSafeData("install_version", SV.Version)
	StopMusic()
	SetCVar("Sound_MusicVolume", user_music_vol or 0)
	okToResetMOVE = false;
	ReloadUI()
end

local OptionButton_OnClick = function(self)
	local fn = self.FuncName
	if(self.ClickIndex) then
		for option, text in pairs(self.ClickIndex) do
			SVUI_InstallerFrame[option]:SetText(text)
		end
	end
	if(SV.Setup[fn] and type(SV.Setup[fn]) == "function") then
		SV.Setup[fn](SV.Setup, self.Arg)
	end
end

local InstallerFrame_PreparePage = function(self)
	self.Option01:Hide()
	self.Option01:SetScript("OnClick",nil)
	self.Option01:SetText("")
	self.Option01.FuncName = nil
	self.Option01.Arg = nil
	self.Option01.ClickIndex = nil
	self.Option01:SetWidth(160)
	self.Option01.texture:SetSizeToScale(160, 160)
	self.Option01.texture:SetPoint("CENTER", self.Option01, "BOTTOM", 0, -(160 * 0.09))
	self.Option01:ClearAllPoints()
	self.Option01:SetPoint("BOTTOM", 0, 15)

	self.Option02:Hide()
	self.Option02:SetScript("OnClick",nil)
	self.Option02:SetText("")
	self.Option02.FuncName = nil
	self.Option02.Arg = nil
	self.Option02.ClickIndex = nil
	self.Option02:ClearAllPoints()
	self.Option02:SetPoint("BOTTOMLEFT", self, "BOTTOM", 4, 15)

	self.Option03:Hide()
	self.Option03:SetScript("OnClick",nil)
	self.Option03:SetText("")
	self.Option03.FuncName = nil
	self.Option03.Arg = nil
	self.Option03.ClickIndex = nil

	self.Option1:Hide()
	self.Option1:SetScript("OnClick",nil)
	self.Option1:SetText("")
	self.Option1.FuncName = nil
	self.Option1.Arg = nil
	self.Option1.ClickIndex = nil
	self.Option1:SetWidth(160)
	self.Option1.texture:SetSizeToScale(160, 160)
	self.Option1.texture:SetPoint("CENTER", self.Option1, "BOTTOM", 0, -(160 * 0.09))
	self.Option1:ClearAllPoints()
	self.Option1:SetPoint("BOTTOM", 0, 15)

	self.Option2:Hide()
	self.Option2:SetScript('OnClick',nil)
	self.Option2:SetText('')
	self.Option2.FuncName = nil
	self.Option2.Arg = nil
	self.Option2.ClickIndex = nil
	self.Option2:SetWidth(120)
	self.Option2.texture:SetSizeToScale(120, 120)
	self.Option2.texture:SetPoint("CENTER", self.Option2, "BOTTOM", 0, -(120 * 0.09))
	self.Option2:ClearAllPoints()
	self.Option2:SetPoint("BOTTOMLEFT", self, "BOTTOM", 4, 15)

	self.Option3:Hide()
	self.Option3:SetScript('OnClick',nil)
	self.Option3:SetText('')
	self.Option3.FuncName = nil
	self.Option3.Arg = nil
	self.Option3.ClickIndex = nil
	self.Option3:SetWidth(120)
	self.Option3.texture:SetSizeToScale(120, 120)
	self.Option3.texture:SetPoint("CENTER", self.Option3, "BOTTOM", 0, -(120 * 0.09))
	self.Option3:ClearAllPoints()
	self.Option3:SetPoint("LEFT", self.Option2, "RIGHT", 4, 0)

	self.Option4:Hide()
	self.Option4:SetScript('OnClick',nil)
	self.Option4:SetText('')
	self.Option4.FuncName = nil
	self.Option4.Arg = nil
	self.Option4.ClickIndex = nil
	self.Option4:SetWidth(110)
	self.Option4.texture:SetSizeToScale(110, 110)
	self.Option4.texture:SetPoint("CENTER", self.Option4, "BOTTOM", 0, -(110 * 0.09))
	self.Option4:ClearAllPoints()
	self.Option4:SetPoint("LEFT", self.Option3, "RIGHT", 4, 0)

	self.SubTitle:SetText("")
	self.Desc1:SetText("")
	self.Desc2:SetText("")
	self.Desc3:SetText("")

	if CURRENT_PAGE == 1 then
		self.Prev:Disable()
		self.Prev:Hide()
	else
		self.Prev:Enable()
		self.Prev:Show()
	end 

	if CURRENT_PAGE == MAX_PAGE then
		self.Next:Disable()
		self.Next:Hide()
		self:SetSizeToScale(550, 350)
	else
		self.Next:Enable()
		self.Next:Show()
		self:SetSizeToScale(550,400)
	end
end

local InstallerFrame_SetPage = function(self, newPage)
	PageData, MAX_PAGE = SV.Setup:CopyPage(newPage)
	CURRENT_PAGE = newPage;
	local willShowLayout = CURRENT_PAGE == 5 or CURRENT_PAGE == 6;
	local willShowAuras = CURRENT_PAGE == 8;

	self:PreparePage()
	self.Status:SetText(CURRENT_PAGE.."  /  "..MAX_PAGE)

	ShowLayout(willShowLayout)
	ShowAuras(willShowAuras)

	for option, data in pairs(PageData) do
		if(type(data) == "table" and data[1] and data[2]) then
			if(data[4] and not data[4]()) then return end;
			self[option]:Show()
			self[option]:SetText(data[1])
			self[option].FuncName = data[2]
			self[option].Arg = data[3]
			local postclickIndex = ("%d_%s"):format(newPage, option)
			self[option].ClickIndex = SV.Setup:CopyOnClick(postclickIndex)
			self[option]:SetScript("OnClick", OptionButton_OnClick)
		elseif(type(data) == "function") then
			local optionText = data()
			self[option]:SetText(optionText)
		else
			self[option]:SetText(data)
		end
	end
end 

local NextPage_OnClick = function(self)
	if CURRENT_PAGE ~= MAX_PAGE then 
		CURRENT_PAGE = CURRENT_PAGE + 1;
		self.parent:SetPage(CURRENT_PAGE)
	end
end 

local PreviousPage_OnClick = function(self)
	if CURRENT_PAGE ~= 1 then 
		CURRENT_PAGE = CURRENT_PAGE - 1;
		self.parent:SetPage(CURRENT_PAGE)
	end 
end

function SV.Setup:Reset()
	mungs = true;
	okToResetMOVE = false;
	self:ChatConfigs(true);
	SVLib:WipeDatabase()
	self:UserScreen()

	if SV.db.LAYOUT.mediastyle then
        self:ColorTheme(SV.db.LAYOUT.mediastyle)
    else
    	SV.db.LAYOUT.mediastyle = nil;
    	self:ColorTheme()
    end

    if SV.db.LAYOUT.unitstyle then 
        self:UnitframeLayout(SV.db.LAYOUT.unitstyle)
    else
    	SV.db.LAYOUT.unitstyle = nil;
    	self:UnitframeLayout()
    end

    if SV.db.LAYOUT.barstyle then 
        self:BarLayout(SV.db.LAYOUT.barstyle)
    else
    	SV.db.LAYOUT.barstyle = nil;
    	self:BarLayout()
    end

    if SV.db.LAYOUT.aurastyle then 
        self:Auralayout(SV.db.LAYOUT.aurastyle)
    else
    	SV.db.LAYOUT.aurastyle = nil;
    	self:Auralayout()
    end

    SVLib:WipeCache()
	SVLib:SaveSafeData("install_version", SV.Version);
	ReloadUI()
end 

function SV.Setup:Install(autoLoaded)
	local old = SVLib:GetSafeData()
    local media = old.mediastyle or ""
    local bars = old.barstyle or ""
    local units = old.unitstyle or ""
    local groups = old.groupstyle or ""
    local auras = old.aurastyle or ""

    SV.db.LAYOUT = {
        mediastyle = media,
        barstyle = bars,
        unitstyle = units,
        groupstyle = groups, 
        aurastyle = auras
    }
	
	if not SVUI_InstallerFrame then 
		local frame = CreateFrame("Button", "SVUI_InstallerFrame", UIParent)
		frame:SetSizeToScale(550, 400)
		frame:SetStylePanel("Default", "Action")
		frame:SetPoint("TOP", SV.Screen, "TOP", 0, -150)
		frame:SetFrameStrata("TOOLTIP")

		frame.SetPage = InstallerFrame_SetPage;
		frame.PreparePage = InstallerFrame_PreparePage;

		--[[ NEXT PAGE BUTTON ]]--

		frame.Next = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
		frame.Next:RemoveTextures()
		frame.Next:SetSizeToScale(110, 25)
		frame.Next:SetPoint("BOTTOMRIGHT", 50, 5)
		SetInstallButton(frame.Next)
		frame.Next.texture = frame.Next:CreateTexture(nil, "BORDER")
		frame.Next.texture:SetSizeToScale(110, 75)
		frame.Next.texture:SetPoint("RIGHT")
		frame.Next.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION-ARROW")
		frame.Next.texture:SetVertexColor(1, 0.5, 0)
		frame.Next.text = frame.Next:CreateFontString(nil, "OVERLAY")
		frame.Next.text:SetFont(SV.Media.font.flash, 18, "OUTLINE")
		frame.Next.text:SetPoint("CENTER")
		frame.Next.text:SetText(CONTINUE)
		frame.Next:Disable()
		frame.Next.parent = frame
		frame.Next:SetScript("OnClick", NextPage_OnClick)
		frame.Next:SetScript("OnEnter", function(this)
			this.texture:SetVertexColor(1, 1, 0)
		end)
		frame.Next:SetScript("OnLeave", function(this)
			this.texture:SetVertexColor(1, 0.5, 0)
		end)

		--[[ PREVIOUS PAGE BUTTON ]]--

		frame.Prev = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
		frame.Prev:RemoveTextures()
		frame.Prev:SetSizeToScale(110, 25)
		frame.Prev:SetPoint("BOTTOMLEFT", -50, 5)
		SetInstallButton(frame.Prev)
		frame.Prev.texture = frame.Prev:CreateTexture(nil, "BORDER")
		frame.Prev.texture:SetSizeToScale(110, 75)
		frame.Prev.texture:SetPoint("LEFT")
		frame.Prev.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION-ARROW")
		frame.Prev.texture:SetTexCoord(1, 0, 1, 1, 0, 0, 0, 1)
		frame.Prev.texture:SetVertexColor(1, 0.5, 0)
		frame.Prev.text = frame.Prev:CreateFontString(nil, "OVERLAY")
		frame.Prev.text:SetFont(SV.Media.font.flash, 18, "OUTLINE")
		frame.Prev.text:SetPoint("CENTER")
		frame.Prev.text:SetText(PREVIOUS)
		frame.Prev:Disable()
		frame.Prev.parent = frame
		frame.Prev:SetScript("OnClick", PreviousPage_OnClick)
		frame.Prev:SetScript("OnEnter", function(this)
			this.texture:SetVertexColor(1, 1, 0)
		end)
		frame.Prev:SetScript("OnLeave", function(this)
			this.texture:SetVertexColor(1, 0.5, 0)
		end)

		--[[ OPTION 01 ]]--

		frame.Option01 = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
		frame.Option01:RemoveTextures()
		frame.Option01:SetSizeToScale(160, 30)
		frame.Option01:SetPoint("BOTTOM", 0, 15)
		frame.Option01:SetText("")
		SetInstallButton(frame.Option01)
		frame.Option01.texture = frame.Option01:CreateTexture(nil, "BORDER")
		frame.Option01.texture:SetSizeToScale(160, 160)
		frame.Option01.texture:SetPoint("CENTER", frame.Option01, "BOTTOM", 0, -15)
		frame.Option01.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION")
		frame.Option01.texture:SetGradient("VERTICAL", 0, 0.3, 0, 0, 0.7, 0)
		frame.Option01:SetScript("OnEnter", function(this)
			this.texture:SetVertexColor(0.5, 1, 0.4)
		end)
		frame.Option01:SetScript("OnLeave", function(this)
			this.texture:SetGradient("VERTICAL", 0, 0.3, 0, 0, 0.7, 0)
		end)
		frame.Option01:SetFrameLevel(frame.Option01:GetFrameLevel() + 10)
		frame.Option01:Hide()

		--[[ OPTION 02 ]]--

		frame.Option02 = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
		frame.Option02:RemoveTextures()
		frame.Option02:SetSizeToScale(130, 30)
		frame.Option02:SetPoint("BOTTOMLEFT", frame, "BOTTOM", 4, 15)
		frame.Option02:SetText("")
		SetInstallButton(frame.Option02)
		frame.Option02.texture = frame.Option02:CreateTexture(nil, "BORDER")
		frame.Option02.texture:SetSizeToScale(130, 110)
		frame.Option02.texture:SetPoint("CENTER", frame.Option02, "BOTTOM", 0, -15)
		frame.Option02.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION")
		frame.Option02.texture:SetGradient("VERTICAL", 0, 0.1, 0.3, 0, 0.5, 0.7)
		frame.Option02:SetScript("OnEnter", function(this)
			this.texture:SetVertexColor(0.5, 1, 0.4)
		end)
		frame.Option02:SetScript("OnLeave", function(this)
			this.texture:SetGradient("VERTICAL", 0, 0.1, 0.3, 0, 0.5, 0.7)
		end)
		frame.Option02:SetScript("OnShow", function()
			if(not frame.Option03:IsShown()) then
				frame.Option01:SetWidth(130)
				frame.Option01.texture:SetSizeToScale(130, 130)
				frame.Option01.texture:SetPoint("CENTER", frame.Option01, "BOTTOM", 0, -(130 * 0.09))
				frame.Option01:ClearAllPoints()
				frame.Option01:SetPoint("BOTTOMRIGHT", frame, "BOTTOM", -4, 15)
			end
		end)
		frame.Option02:SetFrameLevel(frame.Option01:GetFrameLevel() + 10)
		frame.Option02:Hide()

		--[[ OPTION 03 ]]--

		frame.Option03 = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
		frame.Option03:RemoveTextures()
		frame.Option03:SetSizeToScale(130, 30)
		frame.Option03:SetPoint("BOTTOM", frame, "BOTTOM", 0, 15)
		frame.Option03:SetText("")
		SetInstallButton(frame.Option03)
		frame.Option03.texture = frame.Option03:CreateTexture(nil, "BORDER")
		frame.Option03.texture:SetSizeToScale(130, 110)
		frame.Option03.texture:SetPoint("CENTER", frame.Option03, "BOTTOM", 0, -15)
		frame.Option03.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION")
		frame.Option03.texture:SetGradient("VERTICAL", 0.3, 0, 0, 0.7, 0, 0)
		frame.Option03:SetScript("OnEnter", function(this)
			this.texture:SetVertexColor(0.2, 0.5, 1)
		end)
		frame.Option03:SetScript("OnLeave", function(this)
			this.texture:SetGradient("VERTICAL", 0.3, 0, 0, 0.7, 0, 0)
		end)
		frame.Option03:SetScript("OnShow", function(this)
			this:SetWidth(130)
			this.texture:SetSizeToScale(130, 130)
			this.texture:SetPoint("CENTER", this, "BOTTOM", 0, -(130 * 0.09))

			frame.Option01:SetWidth(130)
			frame.Option01.texture:SetSizeToScale(130, 130)
			frame.Option01.texture:SetPoint("CENTER", frame.Option01, "BOTTOM", 0, -(130 * 0.09))
			frame.Option01:ClearAllPoints()
			frame.Option01:SetPoint("RIGHT", this, "LEFT", -8, 0)

			frame.Option02:SetWidth(130)
			frame.Option02.texture:SetSizeToScale(130, 130)
			frame.Option02.texture:SetPoint("CENTER", frame.Option02, "BOTTOM", 0, -(130 * 0.09))
			frame.Option02:ClearAllPoints()
			frame.Option02:SetPoint("LEFT", this, "RIGHT", 8, 0)
		end)
		frame.Option03:SetFrameLevel(frame.Option01:GetFrameLevel() + 10)
		frame.Option03:Hide()

		--[[ OPTION 1 ]]--

		frame.Option1 = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
		frame.Option1:RemoveTextures()
		frame.Option1:SetSizeToScale(160, 30)
		frame.Option1:SetPoint("BOTTOM", 0, 15)
		frame.Option1:SetText("")
		SetInstallButton(frame.Option1)
		frame.Option1.texture = frame.Option1:CreateTexture(nil, "BORDER")
		frame.Option1.texture:SetSizeToScale(160, 160)
		frame.Option1.texture:SetPoint("CENTER", frame.Option1, "BOTTOM", 0, -15)
		frame.Option1.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION")
		frame.Option1.texture:SetGradient("VERTICAL", 0.3, 0.3, 0.3, 0.7, 0.7, 0.7)
		frame.Option1:SetScript("OnEnter", function(this)
			this.texture:SetVertexColor(0.5, 1, 0.4)
		end)
		frame.Option1:SetScript("OnLeave", function(this)
			this.texture:SetGradient("VERTICAL", 0.3, 0.3, 0.3, 0.7, 0.7, 0.7)
		end)
		frame.Option1:SetFrameLevel(frame.Option1:GetFrameLevel() + 10)
		frame.Option1:Hide()

		--[[ OPTION 2 ]]--
		
		frame.Option2 = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
		frame.Option2:RemoveTextures()
		frame.Option2:SetSizeToScale(120, 30)
		frame.Option2:SetPoint("BOTTOMLEFT", frame, "BOTTOM", 4, 15)
		frame.Option2:SetText("")
		SetInstallButton(frame.Option2)
		frame.Option2.texture = frame.Option2:CreateTexture(nil, "BORDER")
		frame.Option2.texture:SetSizeToScale(120, 110)
		frame.Option2.texture:SetPoint("CENTER", frame.Option2, "BOTTOM", 0, -15)
		frame.Option2.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION")
		frame.Option2.texture:SetGradient("VERTICAL", 0.3, 0.3, 0.3, 0.7, 0.7, 0.7)
		frame.Option2:SetScript("OnEnter", function(this)
			this.texture:SetVertexColor(0.5, 1, 0.4)
		end)
		frame.Option2:SetScript("OnLeave", function(this)
			this.texture:SetGradient("VERTICAL", 0.3, 0.3, 0.3, 0.7, 0.7, 0.7)
		end)
		frame.Option2:SetScript("OnShow", function()
			if(not frame.Option3:IsShown() and (not frame.Option4:IsShown())) then
				frame.Option1:SetWidth(120)
				frame.Option1.texture:SetSizeToScale(120, 120)
				frame.Option1.texture:SetPoint("CENTER", frame.Option1, "BOTTOM", 0, -(120 * 0.09))
				frame.Option1:ClearAllPoints()
				frame.Option1:SetPoint("BOTTOMRIGHT", frame, "BOTTOM", -4, 15)
			end
		end)
		frame.Option2:SetFrameLevel(frame.Option1:GetFrameLevel() + 10)
		frame.Option2:Hide()

		--[[ OPTION 3 ]]--

		frame.Option3 = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
		frame.Option3:RemoveTextures()
		frame.Option3:SetSizeToScale(110, 30)
		frame.Option3:SetPoint("LEFT", frame.Option2, "RIGHT", 4, 0)
		frame.Option3:SetText("")
		SetInstallButton(frame.Option3)
		frame.Option3.texture = frame.Option3:CreateTexture(nil, "BORDER")
		frame.Option3.texture:SetSizeToScale(110, 100)
		frame.Option3.texture:SetPoint("CENTER", frame.Option3, "BOTTOM", 0, -9)
		frame.Option3.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION")
		frame.Option3.texture:SetGradient("VERTICAL", 0.3, 0.3, 0.3, 0.7, 0.7, 0.7)
		frame.Option3:SetScript("OnEnter", function(this)
			this.texture:SetVertexColor(0.5, 1, 0.4)
		end)
		frame.Option3:SetScript("OnLeave", function(this)
			this.texture:SetGradient("VERTICAL", 0.3, 0.3, 0.3, 0.7, 0.7, 0.7)
		end)
		frame.Option3:SetScript("OnShow", function(this)
			if(not frame.Option4:IsShown()) then
				frame.Option2:SetWidth(110)
				frame.Option2.texture:SetSizeToScale(110, 110)
				frame.Option2.texture:SetPoint("CENTER", frame.Option2, "BOTTOM", 0, -(110 * 0.09))
				frame.Option2:ClearAllPoints()
				frame.Option2:SetPoint("BOTTOM", frame, "BOTTOM", 0, 15)

				frame.Option1:SetWidth(110)
				frame.Option1.texture:SetSizeToScale(110, 110)
				frame.Option1.texture:SetPoint("CENTER", frame.Option1, "BOTTOM", 0, -(110 * 0.09))
				frame.Option1:ClearAllPoints()
				frame.Option1:SetPoint("RIGHT", frame.Option2, "LEFT", -4, 0)

				this:SetWidth(110)
				this.texture:SetSizeToScale(110, 110)
				this.texture:SetPoint("CENTER", this, "BOTTOM", 0, -(110 * 0.09))
				this:ClearAllPoints()
				this:SetPoint("LEFT", frame.Option2, "RIGHT", 4, 0)
			end
		end)
		frame.Option3:SetFrameLevel(frame.Option1:GetFrameLevel() + 10)
		frame.Option3:Hide()

		--[[ OPTION 4 ]]--

		frame.Option4 = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
		frame.Option4:RemoveTextures()
		frame.Option4:SetSizeToScale(110, 30)
		frame.Option4:SetPoint("LEFT", frame.Option3, "RIGHT", 4, 0)
		frame.Option4:SetText("")
		SetInstallButton(frame.Option4)
		frame.Option4.texture = frame.Option4:CreateTexture(nil, "BORDER")
		frame.Option4.texture:SetSizeToScale(110, 100)
		frame.Option4.texture:SetPoint("CENTER", frame.Option4, "BOTTOM", 0, -9)
		frame.Option4.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION")
		frame.Option4.texture:SetGradient("VERTICAL", 0.3, 0.3, 0.3, 0.7, 0.7, 0.7)
		frame.Option4:SetScript("OnEnter", function(this)
			this.texture:SetVertexColor(0.5, 1, 0.4)
		end)
		frame.Option4:SetScript("OnLeave", function(this)
			this.texture:SetGradient("VERTICAL", 0.3, 0.3, 0.3, 0.7, 0.7, 0.7)
		end)
		frame.Option4:SetScript("OnShow", function()
			
			frame.Option2:SetWidthToScale(110)
			frame.Option2.texture:SetSizeToScale(110, 110)
			frame.Option2.texture:SetPoint("CENTER", frame.Option2, "BOTTOM", 0, -(110 * 0.09))
			frame.Option2:ClearAllPoints()
			frame.Option2:SetPoint("BOTTOMRIGHT", frame, "BOTTOM", -4, 15)

			frame.Option1:SetWidthToScale(110)
			frame.Option1.texture:SetSizeToScale(110, 110)
			frame.Option1.texture:SetPoint("CENTER", frame.Option1, "BOTTOM", 0, -(110 * 0.09))
			frame.Option1:ClearAllPoints()
			frame.Option1:SetPoint("RIGHT", frame.Option2, "LEFT", -4, 0)

			frame.Option3:SetWidth(110)
			frame.Option3.texture:SetSizeToScale(110, 110)
			frame.Option3.texture:SetPoint("CENTER", frame.Option3, "BOTTOM", 0, -(110 * 0.09))
			frame.Option3:ClearAllPoints()
			frame.Option3:SetPoint("LEFT", frame.Option2, "RIGHT", 4, 0)
		end)

		frame.Option4:SetFrameLevel(frame.Option1:GetFrameLevel() + 10)
		frame.Option4:Hide()

		--[[ TEXT HOLDERS ]]--

		local statusHolder = CreateFrame("Frame", nil, frame)
		statusHolder:SetFrameLevel(statusHolder:GetFrameLevel() + 2)
		statusHolder:SetSizeToScale(150, 30)
		statusHolder:SetPointToScale("BOTTOM", frame, "TOP", 0, 2)

		frame.Status = statusHolder:CreateFontString(nil, "OVERLAY")
		frame.Status:SetFont(SV.Media.font.numbers, 22, "OUTLINE")
		frame.Status:SetPoint("CENTER")
		frame.Status:SetText(CURRENT_PAGE.."  /  "..MAX_PAGE)

		local titleHolder = frame:CreateFontString(nil, "OVERLAY")
		titleHolder:SetFont(SV.Media.font.dialog, 22, "OUTLINE")
		titleHolder:SetPointToScale("TOP", 0, -5)
		titleHolder:SetText(L["Supervillain UI Installation"])

		frame.SubTitle = frame:CreateFontString(nil, "OVERLAY")
		frame.SubTitle:SetFont(SV.Media.font.alert, 16, "OUTLINE")
		frame.SubTitle:SetPointToScale("TOP", 0, -40)

		frame.Desc1 = frame:CreateFontString(nil, "OVERLAY")
		frame.Desc1:SetFont(SV.Media.font.default, 14, "OUTLINE")
		frame.Desc1:SetPointToScale("TOPLEFT", 20, -75)
		frame.Desc1:SetWidthToScale(frame:GetWidth()-40)

		frame.Desc2 = frame:CreateFontString(nil, "OVERLAY")
		frame.Desc2:SetFont(SV.Media.font.default, 14, "OUTLINE")
		frame.Desc2:SetPointToScale("TOPLEFT", 20, -125)
		frame.Desc2:SetWidthToScale(frame:GetWidth()-40)

		frame.Desc3 = frame:CreateFontString(nil, "OVERLAY")
		frame.Desc3:SetFont(SV.Media.font.default, 14, "OUTLINE")
		frame.Desc3:SetPointToScale("TOPLEFT", 20, -175)
		frame.Desc3:SetWidthToScale(frame:GetWidth()-40)

		--[[ MISC ]]--

		local closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
		closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
		closeButton:SetScript("OnClick", function() frame:Hide() end)

		local tutorialImage = frame:CreateTexture(nil, "OVERLAY")
		tutorialImage:SetSizeToScale(256, 128)
		tutorialImage:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\SPLASH")
		tutorialImage:SetPointToScale("BOTTOM", 0, 70)
	end 

	SVUI_InstallerFrame:SetScript("OnHide", function()
		StopMusic()
		SetCVar("Sound_MusicVolume", user_music_vol or 0)
		musicIsPlaying = nil;
		ShowLayout()
		ShowAuras()
	end)
	
	SVUI_InstallerFrame:Show()
	SVUI_InstallerFrame:SetPage(1)
	if(not autoLoaded) then
		PlayThemeSong()
	else
		SV.Timers:ExecuteTimer(PlayThemeSong, 5)
	end
end