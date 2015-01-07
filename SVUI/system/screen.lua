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
local table     = _G.table;
local string     = _G.string;
local math      = _G.math;
--[[ MATH METHODS ]]--
local floor, abs, min, max = math.floor, math.abs, math.min, math.max;
local parsefloat, ceil = math.parsefloat, math.ceil;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)

SV.Screen = _G["SVUIParent"];
local BASE_MOD = 0.64;
local SCREEN_MOD = 1;
--[[ 
########################################################## 
UI SCALING
##########################################################
]]--
function SV:UI_SCALE_CHANGED(event)
    local evalwidth;
    local gxWidth, gxHeight, gxScale = self.Screen:Update();

    if(gxWidth < 1600) then
        self.LowRez = true;
    elseif(gxWidth >= 3840) then
        self.LowRez = nil
        if(self.db.general.multiMonitor) then
            if(gxWidth < 4080) then 
                evalwidth = 1224;
            elseif(gxWidth < 4320) then 
                evalwidth = 1360;
            elseif(gxWidth < 4800) then 
                evalwidth = 1440;
            elseif(gxWidth < 5760) then 
                if(gxHeight == 900) then evalwidth = 1600 else evalwidth = 1680 end 
            elseif(gxWidth < 7680) then 
                evalwidth = 1920;
            elseif(gxWidth < 9840) then 
                evalwidth = 2560;
            elseif(gxWidth > 9839) then 
                evalwidth = 3280; 
            end
        else
            if(gxWidth < 4080) then 
                evalwidth = 3840;
            elseif(gxWidth < 4320) then 
                evalwidth = 4080;
            elseif(gxWidth < 4800) then 
                evalwidth = 4320;
            elseif(gxWidth < 5040) then 
                evalwidth = 4800; 
            elseif(gxWidth < 5760) then 
                evalwidth = 5040; 
            elseif(gxWidth < 7680) then 
                evalwidth = 5760;
            elseif(gxWidth < 9840) then 
                evalwidth = 7680;
            elseif(gxWidth > 9839) then 
                evalwidth = 9840; 
            end
        end
    end

    local testScale1 = parsefloat(UIParent:GetScale(), 5)
    local testScale2 = parsefloat(gxScale, 5)

    if(event == "PLAYER_LOGIN" and (testScale1 ~= testScale2)) then 
        SetCVar("useUiScale", 1)
        SetCVar("uiScale", gxScale)
        WorldMapFrame.hasTaint = true;
    end

    if(event == 'PLAYER_LOGIN' or event == 'UI_SCALE_CHANGED') then
        self.Screen:ClearAllPoints()
        self.Screen:SetPoint("CENTER")

        if evalwidth then
            local width = evalwidth
            local height = gxHeight;
            if(not self.db.general.autoScale or height > 1200) then
                height = UIParent:GetHeight();
                local ratio = gxHeight / height;
                width = evalwidth / ratio;
            end
            self.Screen:SetSize(width, height);
        else
            self.Screen:SetSize(UIParent:GetSize());
        end

        if(event == 'UI_SCALE_CHANGED') then
            local change = abs((testScale1 * 100) - (testScale2 * 100))
            if(change > 1) then
                if(self.db.general.autoScale) then
                    self:StaticPopup_Show('FAILED_UISCALE')
                else
                    self:StaticPopup_Show('RL_CLIENT')
                end
            end
        end
    end
end

function SV:Scale(value)
    return SCREEN_MOD * floor(value / SCREEN_MOD + .5);
end

function SV.Screen:Update()
    local rez = GetCVar("gxResolution")
    local height = rez:match("%d+x(%d+)")
    local width = rez:match("(%d+)x%d+")
    local gxHeight = tonumber(height)
    local gxWidth = tonumber(width)
    local gxMod = (768 / gxHeight)

    if(IsMacClient()) then
        if(not self.MacDisplay) then
            self.MacDisplay = LibSuperVillain("Registry"):NewGlobal("Display");
            if(not self.MacDisplay.Y or (self.MacDisplay.Y and type(self.MacDisplay.Y) ~= "number")) then 
                self.MacDisplay.Y = gxHeight;
            end
            if(not self.MacDisplay.X or (self.MacDisplay.X and type(self.MacDisplay.X) ~= "number")) then 
                self.MacDisplay.X = gxWidth;
            end
        end
        if(self.MacDisplay and self.MacDisplay.Y and self.MacDisplay.X) then
            if(gxHeight ~= self.MacDisplay.Y or gxWidth ~= self.MacDisplay.X) then 
                gxHeight = self.MacDisplay.Y;
                gxWidth = self.MacDisplay.X; 
            end
        end
    end

    local gxScale;
    if(SV.db.general.scaleAdjust and type(SV.db.general.scaleAdjust) == "number") then
        BASE_MOD = SV.db.general.scaleAdjust;
    end
    if(SV.db.general.autoScale) then
        gxScale = max(BASE_MOD, min(1.15, gxMod));
    else
        gxScale = max(BASE_MOD, min(1.15, GetCVar("uiScale") or UIParent:GetScale() or gxMod));
    end

    SCREEN_MOD = (gxMod / gxScale);

    return gxWidth, gxHeight, gxScale
end