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
############################################################################## ]]-- 

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
local split         = string.split;
local upper         = string.upper;
local format        = string.format;
local find          = string.find;
local match         = string.match;
local gsub          = string.gsub;
--MATH
local math          = _G.math;
local floor         = math.floor
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
local LibStub               = _G.LibStub;
local GetAddOnMetadata      = _G.GetAddOnMetadata;
local GetCVarBool           = _G.GetCVarBool;
local GameTooltip           = _G.GameTooltip;
local StaticPopup_Hide      = _G.StaticPopup_Hide;
local ERR_NOT_IN_COMBAT     = _G.ERR_NOT_IN_COMBAT;

--[[  CONSTANTS ]]--

_G.BINDING_HEADER_SVUI = "Supervillain UI";
_G.BINDING_NAME_SVUI_MARKERS = "Raid Markers";
_G.BINDING_NAME_SVUI_DOCKS = "Toggle Docks";
_G.BINDING_NAME_SVUI_RIDE = "Let's Ride";

_G.SlashCmdList.RELOADUI = ReloadUI
_G.SLASH_RELOADUI1 = "/rl"
_G.SLASH_RELOADUI2 = "/reloadui"

--[[ GET THE REGISTRY LIB ]]--

local SVLib = LibSuperVillain("Registry");

--[[ 
#####################################################################################
  /$$$$$$  /$$    /$$ /$$   /$$ /$$$$$$        /$$$$$$   /$$$$$$  /$$$$$$$  /$$$$$$$$
 /$$__  $$| $$   | $$| $$  | $$|_  $$_/       /$$__  $$ /$$__  $$| $$__  $$| $$_____/
| $$  \__/| $$   | $$| $$  | $$  | $$        | $$  \__/| $$  \ $$| $$  \ $$| $$      
|  $$$$$$ |  $$ / $$/| $$  | $$  | $$        | $$      | $$  | $$| $$$$$$$/| $$$$$   
 \____  $$ \  $$ $$/ | $$  | $$  | $$        | $$      | $$  | $$| $$__  $$| $$__/   
 /$$  \ $$  \  $$$/  | $$  | $$  | $$        | $$    $$| $$  | $$| $$  \ $$| $$      
|  $$$$$$/   \  $/   |  $$$$$$/ /$$$$$$      |  $$$$$$/|  $$$$$$/| $$  | $$| $$$$$$$$
 \______/     \_/     \______/ |______/       \______/  \______/ |__/  |__/|________/
#####################################################################################
]]--

--[[ LOCALS ]]--

local callbacks = {};
local numCallbacks = 0;
local playerClass = select(2, UnitClass("player"));
local messagePattern = "|cffFF2F00%s:|r";
local debugPattern = "|cffFF2F00%s|r [|cff992FFF%s|r]|cffFF2F00:|r";
local errorPattern = "|cffff0000Error -- |r|cffff9900Required addon '|r|cffffff00%s|r|cffff9900' is %s.|r"

--[[ HELPERS ]]--

local function _removedeprecated()
    --[[ BEGIN DEPRECATED ]]--

    --[[ END DEPRECATED ]]--
end

local function _sendmessage(msg, prefix)
    if(type(msg) == "table") then 
         msg = tostring(msg) 
    end
    if(not msg) then return end
    if(prefix) then
        local outbound = ("%s %s"):format(prefix, msg);
        print(outbound)
    else
        print(msg)
    end
end


local function _needsupdate(value, lowest)
    local minimumVersion = 5;
    --print(table.dump(self.safedata))
    local version = value or '0.0';
    local vt = version:explode(".")
    local MAJOR,MINOR,PATCH = unpack(vt)
    if(MAJOR) then
        if(type(MAJOR) == "string") then
            MAJOR = tonumber(MAJOR)
        end
        if(type(MAJOR) == "number" and MAJOR < lowest) then
            return true
        else
            return false
        end
    else
        return true
    end
end

--[[ CLASS COLOR LOCALS ]]--

local function RegisterCallback(self, m, h)
    assert(type(m) == "string" or type(m) == "function", "Bad argument #1 to :RegisterCallback (string or function expected)")
    if type(m) == "string" then
        assert(type(h) == "table", "Bad argument #2 to :RegisterCallback (table expected)")
        assert(type(h[m]) == "function", "Bad argument #1 to :RegisterCallback (m \"" .. m .. "\" not found)")
        m = h[m]
    end
    callbacks[m] = h or true
    numCallbacks = numCallbacks + 1
end

local function UnregisterCallback(self, m, h)
    assert(type(m) == "string" or type(m) == "function", "Bad argument #1 to :UnregisterCallback (string or function expected)")
    if type(m) == "string" then
        assert(type(h) == "table", "Bad argument #2 to :UnregisterCallback (table expected)")
        assert(type(h[m]) == "function", "Bad argument #1 to :UnregisterCallback (m \"" .. m .. "\" not found)")
        m = h[m]
    end
    callbacks[m] = nil
    numCallbacks = numCallbacks + 1
end

local function DispatchCallbacks()
    if (numCallbacks < 1) then return end 
    for m, h in pairs(callbacks) do
        local ok, err = pcall(m, h ~= true and h or nil)
        if not ok then
            print("ERROR:", err)
        end
    end
end

--[[ BUILD CLASS COLOR GLOBAL, CAN BE OVERRIDDEN BY THE ADDON !ClassColors ]]--

local CUSTOM_CLASS_COLORS = _G.CUSTOM_CLASS_COLORS;

if(not CUSTOM_CLASS_COLORS) then
    local env = getfenv(0)
    env.CUSTOM_CLASS_COLORS = {}
    CUSTOM_CLASS_COLORS = env.CUSTOM_CLASS_COLORS

    local classes = {};
    local supercolors = {
        ["HUNTER"]        = { r = 0.454, g = 0.698, b = 0 },
        ["WARLOCK"]       = { r = 0.286, g = 0,     b = 0.788 },
        ["PRIEST"]        = { r = 0.976, g = 1,     b = 0.839 },
        ["PALADIN"]       = { r = 0.956, g = 0.207, b = 0.733 },
        ["MAGE"]          = { r = 0,     g = 0.796, b = 1 },
        ["ROGUE"]         = { r = 1,     g = 0.894, b = 0.117 },
        ["DRUID"]         = { r = 1,     g = 0.513, b = 0 },
        ["SHAMAN"]        = { r = 0,     g = 0.38,  b = 1 },
        ["WARRIOR"]       = { r = 0.698, g = 0.36,  b = 0.152 },
        ["DEATHKNIGHT"]   = { r = 0.847, g = 0.117, b = 0.074 },
        ["MONK"]          = { r = 0.015, g = 0.886, b = 0.38 },
    };
    for class in pairs(RAID_CLASS_COLORS) do
        tinsert(classes, class)
    end
    tsort(classes)
    setmetatable(CUSTOM_CLASS_COLORS,{
        __index = function(t, k)
            if k == "RegisterCallback" then return RegisterCallback end
            if k == "UnregisterCallback" then return UnregisterCallback end
            if k == "DispatchCallbacks" then return DispatchCallbacks end
        end
    });
    for i, class in ipairs(classes) do
        local color = supercolors[class]
        local r, g, b = color.r, color.g, color.b
        local hex = ("ff%02x%02x%02x"):format(r * 255, g * 255, b * 255)
        if not CUSTOM_CLASS_COLORS[class] or not CUSTOM_CLASS_COLORS[class].r or not CUSTOM_CLASS_COLORS[class].g or not CUSTOM_CLASS_COLORS[class].b then
            CUSTOM_CLASS_COLORS[class] = {
                r = r,
                g = g,
                b = b,
                colorStr = hex,
            }
        end
    end
    classes = nil
end

--[[ CORE ENGINE CONSTRUCT ]]--

-- We have to send the names of our three SavedVariables files since the WoW API
-- has no method for parsing them in LUA.
local SVUI = SVLib:NewCore("SVUI_Global", "SVUI_Errors", "SVUI_Profile", "SVUI_Cache", "SVUI_Filters", "SVUI_Layouts")

SVUI.ConfigID           = "SVUI_ConfigOMatic";
SVUI.class              = playerClass;
SVUI.ClassRole          = "";
SVUI.UnitRole           = "NONE";
SVUI.ConfigurationMode  = false;

--[[ EMBEDDED LIBS ]]--

SVUI.L          = LibSuperVillain("Linguist"):Lang();
SVUI.Events     = LibSuperVillain("Events");
SVUI.Animate    = LibSuperVillain("Animate");
SVUI.Timers     = LibSuperVillain("Timers");
SVUI.Sounds     = LibSuperVillain("Sounds");
SVUI.SpecialFX  = LibSuperVillain("SpecialFX");

SVUI.Screen = CreateFrame("Frame", "SVUIParent", UIParent);
SVUI.Screen:SetFrameLevel(UIParent:GetFrameLevel());
SVUI.Screen:SetPoint("CENTER", UIParent, "CENTER");
SVUI.Screen:SetSize(UIParent:GetSize());

SVUI.Hidden = CreateFrame("Frame", nil, UIParent);
SVUI.Hidden:Hide();

SVUI.Options = { 
    type = "group", 
    name = "|cff339fffConfig-O-Matic|r", 
    args = {
        plugins = {
            order = -2,
            type = "group",
            name = "Plugins",
            childGroups = "tab",
            args = {
                pluginheader = {
                    order = 1,
                    type = "header",
                    name = "Supervillain Plugins",
                },
                pluginOptions = {
                    order = 2,
                    type = "group",
                    name = "",
                    args = {
                        pluginlist = {
                            order = 1,
                            type = "group",
                            name = "Summary",
                            args = {
                                active = {
                                    order = 1,
                                    type = "description",
                                    name = function() return SVLib:GetPlugins() end
                                }
                            }
                        },
                    }
                }
            }
        }
    }
}

--[[ BUILD LOGIN MESSAGES ]]--

local commandments = {
    {
        "schemes diabolical",
        "henchmen in-line",
        "entrances grand",
        "battles glorious",
        "power absolute",
    },
    {
        "traps inescapable",
        "enemies overthrown",
        "monologues short",
        "victories infamous",
        "identity a mystery",
    }
};

function SVUI:SetLoginMessage()
    local first = commandments[1][random(1,5)]
    local second = commandments[2][random(1,5)]
    local logMsg1 = (self.L["LOGIN_MSG"]):format(first, second)
    local logMsg2 = (self.L["LOGIN_MSG2"]):format(self.Version)
    local outbound = (messagePattern):format(self.NameID)
    _sendmessage(logMsg1, outbound) 
    _sendmessage(logMsg2, outbound) 
end

--[[ CORE FUNCTIONS ]]--

function SVUI:fubar() return end

function SVUI:StaticPopup_Show(arg)
    if arg == "ADDON_ACTION_FORBIDDEN" then 
        StaticPopup_Hide(arg)
    end
end

function SVUI:Debugger(msg)
    if(not self.DebugMode) then return end
    local outbound = (debugPattern):format(self.NameID, "DEBUG")
    _sendmessage(msg, outbound) 
end

function SVUI:AddonMessage(msg)
    local outbound = (messagePattern):format(self.NameID)
    _sendmessage(msg, outbound) 
end

function SVUI:ResetAllUI(confirmed)
    if InCombatLockdown()then 
        self:AddonMessage(ERR_NOT_IN_COMBAT)
        return 
    end 
    if(not confirmed) then 
        self:StaticPopup_Show('RESET_UI_CHECK')
        return 
    end 
    self.Setup:Reset()
end 

function SVUI:ResetUI(confirmed)
    if InCombatLockdown()then 
        self:AddonMessage(ERR_NOT_IN_COMBAT)
        return 
    end 
    if(not confirmed) then 
        self:StaticPopup_Show('RESETMOVERS_CHECK')
        return 
    end 
    self.Mentalo:Reset()
end

function SVUI:ImportProfile(key)
    self.SystemAlert["COPY_PROFILE_PROMPT"].text = "Are you sure you want to copy the profile '" .. key .. "'?"
    self.SystemAlert["COPY_PROFILE_PROMPT"].OnAccept = function() SVLib:ImportDatabase(key) end
    self:StaticPopup_Show("COPY_PROFILE_PROMPT")
end

function SVUI:ToggleConfig()
    if InCombatLockdown() then 
        self:AddonMessage(ERR_NOT_IN_COMBAT) 
        self:RegisterEvent('PLAYER_REGEN_ENABLED')
        return 
    end 
    if not IsAddOnLoaded(self.ConfigID) then 
        local _,_,_,_,_,state = GetAddOnInfo(self.ConfigID)
        if state ~= "MISSING" and state ~= "DISABLED" then 
            LoadAddOn(self.ConfigID)
            local config_version = GetAddOnMetadata(self.ConfigID, "Version")
            if(_needsupdate(config_version, 5)) then 
                self:StaticPopup_Show("CLIENT_UPDATE_REQUEST")
            end 
        else
            local errorMessage = (errorPattern):format(self.ConfigID, state)
            self:AddonMessage(errorMessage)
            return 
        end 
    end 
    local aceConfig = LibStub("AceConfigDialog-3.0")
    local switch = not aceConfig.OpenFrames[self.NameID] and "Open" or "Close"
    aceConfig[switch](aceConfig, self.NameID)
    GameTooltip:Hide()
end 

function SVUI:VersionCheck()
    local version = self.safedata.install_version;
    if(_needsupdate(version, 5)) then
        self.Setup:Install(true)
    end
end

function SVUI:RefreshEverything(bypass)
    self:MediaUpdate();
    self.Mentalo:SetPositions();
    SVLib:RefreshAll();
    if not bypass then
        self:VersionCheck()
    end
end

--[[ EVENT HANDLERS ]]--

function SVUI:PLAYER_ENTERING_WORLD()
    if(not self.RoleIsSet) then
        self:PlayerInfoUpdate()
    end
    if(not self.MediaInitialized) then 
        self:RefreshAllSystemMedia() 
    end
    local _,instanceType = IsInInstance()
    if(instanceType == "pvp") then 
        self.BGTimer = self.Timers:ExecuteLoop(RequestBattlefieldScoreData, 5)
    elseif(self.BGTimer) then 
        self.Timers:RemoveLoop(self.BGTimer)
        self.BGTimer = nil 
    end
    if(not InCombatLockdown()) then
        collectgarbage("collect") 
    end
end

function SVUI:PET_BATTLE_CLOSE()
    self:PushDisplayAudit()
    SVLib:LiveUpdate()
end

function SVUI:PET_BATTLE_OPENING_START()
    self:FlushDisplayAudit()
end

function SVUI:PLAYER_REGEN_DISABLED()
    local forceClosed = false;

    if(IsAddOnLoaded(self.ConfigID)) then 
        local aceConfig=LibStub("AceConfigDialog-3.0")
        if aceConfig.OpenFrames[self.NameID] then 
            self:RegisterEvent("PLAYER_REGEN_ENABLED")
            aceConfig:Close(self.NameID)
            forceClosed = true 
        end 
    end 

    if(self.Mentalo.Frames) then 
        for frame,_ in pairs(self.Mentalo.Frames) do 
            if _G[frame] and _G[frame]:IsShown() then 
                forceClosed = true;
                _G[frame]:Hide()
            end 
        end 
    end 

    if(HenchmenFrameModel and HenchmenFrame and HenchmenFrame:IsShown()) then 
        HenchmenFrame:Hide()
        HenchmenFrameBG:Hide()
        forceClosed = true;
    end

    if forceClosed == true then 
        self:AddonMessage(ERR_NOT_IN_COMBAT)
    end

    if(self.NeedsFrameAudit) then
        self:PushDisplayAudit()
    end
end

function SVUI:PLAYER_REGEN_ENABLED()
    self:ToggleConfig()
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")
end

function SVUI:TaintHandler(event, taint, sourceName, sourceFunc)
    if GetCVarBool('scriptErrors') ~= 1 then return end
    local errorString = ("Error Captured: %s->%s->{%s}"):format(taint, sourceName or "Unknown", sourceFunc or "Unknown")
    self:AddonMessage(errorString)
end

--[[ LOAD FUNCTIONS ]]--

function SVUI:ReLoad()
    self.Timers:ClearAllTimers();
    self:RefreshAllSystemMedia();
    self.Mentalo:SetPositions();
    self:AddonMessage("All user settings reloaded");
end

function SVUI:PreLoad()
    self.Timers:ClearAllTimers()

    self:RegisterEvent('PLAYER_REGEN_DISABLED');
    self:RegisterEvent("PLAYER_ENTERING_WORLD");
    self:RegisterEvent("UI_SCALE_CHANGED");
    self:RegisterEvent("PET_BATTLE_CLOSE");
    self:RegisterEvent("PET_BATTLE_OPENING_START");
    self:RegisterEvent("ADDON_ACTION_BLOCKED", "TaintHandler");
    self:RegisterEvent("ADDON_ACTION_FORBIDDEN", "TaintHandler");
    self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", "PlayerInfoUpdate");
    self:RegisterEvent("PLAYER_TALENT_UPDATE", "PlayerInfoUpdate");
    self:RegisterEvent("CHARACTER_POINTS_CHANGED", "PlayerInfoUpdate");
    self:RegisterEvent("UNIT_INVENTORY_CHANGED", "PlayerInfoUpdate");
    self:RegisterEvent("UPDATE_BONUS_ACTIONBAR", "PlayerInfoUpdate");
end 

function SVUI:Initialize()
    SVLib:Initialize();

    self:UI_SCALE_CHANGED()
    self:LoadSystemAlerts();
    self.Timers:Initialize();
    self:LoadFramework();
    self.safedata = SVLib:GetSafeData();

    SVLib:Launch();

    self:UI_SCALE_CHANGED("PLAYER_LOGIN")
    self:PlayerInfoUpdate();
    self:VersionCheck()
    self:RefreshAllSystemMedia();
    hooksecurefunc("StaticPopup_Show", self.StaticPopup_Show)

    SVLib:RefreshModule("SVMap");

    self.Dock:UpdateAllDocks()

    collectgarbage("collect") 

    if self.db.general.loginmessage then
        self:SetLoginMessage()
    end
end
--[[ 
########################################################## 
THE CLEANING LADY
##########################################################
]]--
local LemonPledge = 0;
local Consuela = CreateFrame("Frame")
Consuela:RegisterAllEvents()
Consuela:SetScript("OnEvent", function(self, event)
    LemonPledge = LemonPledge  +  1
    if(InCombatLockdown()) then return end;
    if(LemonPledge > 10000) then
        collectgarbage("collect");
        LemonPledge = 0;
    end
end)