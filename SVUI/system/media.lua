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
local select  = _G.select;
local unpack  = _G.unpack;
local pairs   = _G.pairs;
local ipairs  = _G.ipairs;
local type    = _G.type;
local print   = _G.print;
local string  = _G.string;
local math    = _G.math;
local table   = _G.table;
local GetTime = _G.GetTime;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ MATH METHODS ]]--
local floor, modf = math.floor, math.modf;
--[[ TABLE METHODS ]]--
local twipe, tsort = table.wipe, table.sort;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local SVLib = LibSuperVillain("Registry")
local L = SV.L
local LSM = LibStub("LibSharedMedia-3.0")
--[[ 
########################################################## 
LOCALIZED GLOBALS
##########################################################
]]--
local NAMEPLATE_FONT      = _G.NAMEPLATE_FONT
local CHAT_FONT_HEIGHTS   = _G.CHAT_FONT_HEIGHTS
local STANDARD_TEXT_FONT  = _G.STANDARD_TEXT_FONT
local UNIT_NAME_FONT      = _G.UNIT_NAME_FONT
local DAMAGE_TEXT_FONT    = _G.DAMAGE_TEXT_FONT
local CUSTOM_CLASS_COLORS   = _G.CUSTOM_CLASS_COLORS
local RAID_CLASS_COLORS   = _G.RAID_CLASS_COLORS
local UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT  = _G.UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT
--[[ 
########################################################## 
DEFINE SOUND EFFECTS
##########################################################
]]--
local SOUND = SV.Sounds;

SOUND:Register("Buttons", [[sound\interface\uchatscrollbutton.ogg]])

SOUND:Register("Levers", [[sound\interface\ui_blizzardstore_buynow.ogg]])
SOUND:Register("Levers", [[sound\doodad\g_levermetalcustom0.ogg]])
SOUND:Register("Levers", [[sound\item\weapons\gun\gunload01.ogg]])
SOUND:Register("Levers", [[sound\item\weapons\gun\gunload02.ogg]])
SOUND:Register("Levers", [[sound\creature\gyrocopter\gyrocoptergearshift2.ogg]])

SOUND:Register("Gears", [[sound\creature\gyrocopter\gyrocoptergearshift3.ogg]])
SOUND:Register("Gears", [[sound\doodad\g_buttonbigredcustom0.ogg]])

SOUND:Register("Sparks", [[sound\doodad\fx_electricitysparkmedium_02.ogg]])
SOUND:Register("Sparks", [[sound\doodad\fx_electrical_zaps01.ogg]])
SOUND:Register("Sparks", [[sound\doodad\fx_electrical_zaps02.ogg]])
SOUND:Register("Sparks", [[sound\doodad\fx_electrical_zaps03.ogg]])
SOUND:Register("Sparks", [[sound\doodad\fx_electrical_zaps04.ogg]])
SOUND:Register("Sparks", [[sound\doodad\fx_electrical_zaps05.ogg]])

SOUND:Register("Static", [[sound\spells\uni_fx_radiostatic_01.ogg]])
SOUND:Register("Static", [[sound\spells\uni_fx_radiostatic_02.ogg]])
SOUND:Register("Static", [[sound\spells\uni_fx_radiostatic_03.ogg]])
SOUND:Register("Static", [[sound\spells\uni_fx_radiostatic_04.ogg]])
SOUND:Register("Static", [[sound\spells\uni_fx_radiostatic_05.ogg]])
SOUND:Register("Static", [[sound\spells\uni_fx_radiostatic_06.ogg]])
SOUND:Register("Static", [[sound\spells\uni_fx_radiostatic_07.ogg]])
SOUND:Register("Static", [[sound\spells\uni_fx_radiostatic_08.ogg]])

SOUND:Register("Wired", [[sound\doodad\goblin_christmaslight_green_01.ogg]])
SOUND:Register("Wired", [[sound\doodad\goblin_christmaslight_green_02.ogg]])
SOUND:Register("Wired", [[sound\doodad\goblin_christmaslight_green_03.ogg]])

SOUND:Register("Phase", [[sound\doodad\be_scryingorb_explode.ogg]])
--[[ 
########################################################## 
DEFINE SHARED MEDIA
##########################################################
]]--
local LSM = LibStub("LibSharedMedia-3.0")

LSM:Register("background","SVUI Backdrop 1",[[Interface\AddOns\SVUI\assets\artwork\Template\Background\PATTERN1]])
LSM:Register("background","SVUI Backdrop 2",[[Interface\AddOns\SVUI\assets\artwork\Template\Background\PATTERN2]])
LSM:Register("background","SVUI Backdrop 3",[[Interface\AddOns\SVUI\assets\artwork\Template\Background\PATTERN3]])
LSM:Register("background","SVUI Backdrop 4",[[Interface\AddOns\SVUI\assets\artwork\Template\Background\PATTERN4]])
LSM:Register("background","SVUI Backdrop 5",[[Interface\AddOns\SVUI\assets\artwork\Template\Background\PATTERN5]])
LSM:Register("background","SVUI Comic 1",[[Interface\AddOns\SVUI\assets\artwork\Template\Background\COMIC1]])
LSM:Register("background","SVUI Comic 2",[[Interface\AddOns\SVUI\assets\artwork\Template\Background\COMIC2]])
LSM:Register("background","SVUI Comic 3",[[Interface\AddOns\SVUI\assets\artwork\Template\Background\COMIC3]])
LSM:Register("background","SVUI Comic 4",[[Interface\AddOns\SVUI\assets\artwork\Template\Background\COMIC4]])
LSM:Register("background","SVUI Comic 5",[[Interface\AddOns\SVUI\assets\artwork\Template\Background\COMIC5]])
LSM:Register("background","SVUI Comic 6",[[Interface\AddOns\SVUI\assets\artwork\Template\Background\COMIC6]])
LSM:Register("background","SVUI Unit BG 1",[[Interface\AddOns\SVUI\assets\artwork\Unitframe\Background\UNIT-BG1]])
LSM:Register("background","SVUI Unit BG 2",[[Interface\AddOns\SVUI\assets\artwork\Unitframe\Background\UNIT-BG2]])
LSM:Register("background","SVUI Unit BG 3",[[Interface\AddOns\SVUI\assets\artwork\Unitframe\Background\UNIT-BG3]])
LSM:Register("background","SVUI Unit BG 4",[[Interface\AddOns\SVUI\assets\artwork\Unitframe\Background\UNIT-BG4]])
LSM:Register("background","SVUI Small BG 1",[[Interface\AddOns\SVUI\assets\artwork\Unitframe\Background\UNIT-SMALL-BG1]])
LSM:Register("background","SVUI Small BG 2",[[Interface\AddOns\SVUI\assets\artwork\Unitframe\Background\UNIT-SMALL-BG2]])
LSM:Register("background","SVUI Small BG 3",[[Interface\AddOns\SVUI\assets\artwork\Unitframe\Background\UNIT-SMALL-BG3]])
LSM:Register("background","SVUI Small BG 4",[[Interface\AddOns\SVUI\assets\artwork\Unitframe\Background\UNIT-SMALL-BG4]])

LSM:Register("statusbar","SVUI BasicBar",[[Interface\AddOns\SVUI\assets\artwork\Bars\DEFAULT]])
LSM:Register("statusbar","SVUI MultiColorBar",[[Interface\AddOns\SVUI\assets\artwork\Bars\GRADIENT]])
LSM:Register("statusbar","SVUI SmoothBar",[[Interface\AddOns\SVUI\assets\artwork\Bars\SMOOTH]])
LSM:Register("statusbar","SVUI PlainBar",[[Interface\AddOns\SVUI\assets\artwork\Bars\FLAT]])
LSM:Register("statusbar","SVUI FancyBar",[[Interface\AddOns\SVUI\assets\artwork\Bars\TEXTURED]])
LSM:Register("statusbar","SVUI GlossBar",[[Interface\AddOns\SVUI\assets\artwork\Bars\GLOSS]])
LSM:Register("statusbar","SVUI GlowBar",[[Interface\AddOns\SVUI\assets\artwork\Bars\GLOWING]])
LSM:Register("statusbar","SVUI LazerBar",[[Interface\AddOns\SVUI\assets\artwork\Bars\LAZER]])

LSM:Register("sound", "Whisper Alert", [[Interface\AddOns\SVUI\assets\sounds\whisper.mp3]])
LSM:Register("sound", "Toasty", [[Interface\AddOns\SVUI\assets\sounds\toasty.mp3]])

LSM:Register("font","SVUI Default Font",[[Interface\AddOns\SVUI\assets\fonts\Default.ttf]],LSM.LOCALE_BIT_ruRU+LSM.LOCALE_BIT_western)
LSM:Register("font","SVUI Pixel Font",[[Interface\AddOns\SVUI\assets\fonts\Pixel.ttf]],LSM.LOCALE_BIT_ruRU+LSM.LOCALE_BIT_western)
LSM:Register("font","SVUI Caps Font",[[Interface\AddOns\SVUI\assets\fonts\Caps.ttf]],LSM.LOCALE_BIT_ruRU+LSM.LOCALE_BIT_western)
LSM:Register("font","SVUI Classic Font",[[Interface\AddOns\SVUI\assets\fonts\Classic.ttf]])
LSM:Register("font","SVUI Combat Font",[[Interface\AddOns\SVUI\assets\fonts\Combat.ttf]])
LSM:Register("font","SVUI Dialog Font",[[Interface\AddOns\SVUI\assets\fonts\Dialog.ttf]])
LSM:Register("font","SVUI Number Font",[[Interface\AddOns\SVUI\assets\fonts\Numbers.ttf]])
LSM:Register("font","SVUI Zone Font",[[Interface\AddOns\SVUI\assets\fonts\Zone.ttf]])
LSM:Register("font","SVUI Flash Font",[[Interface\AddOns\SVUI\assets\fonts\Flash.ttf]])
LSM:Register("font","SVUI Alert Font",[[Interface\AddOns\SVUI\assets\fonts\Alert.ttf]])
LSM:Register("font","SVUI Narrator Font",[[Interface\AddOns\SVUI\assets\fonts\Narrative.ttf]])
--[[ 
########################################################## 
CREATE AND POPULATE MEDIA DATA
##########################################################
]]--

SV.Media = {}

do
  local myclass = select(2,UnitClass("player"))
  local cColor1 = CUSTOM_CLASS_COLORS[myclass]
  local cColor2 = RAID_CLASS_COLORS[myclass]
  local r1,g1,b1 = cColor1.r,cColor1.g,cColor1.b
  local r2,g2,b2 = cColor2.r*.25, cColor2.g*.25, cColor2.b*.25
  local ir1,ig1,ib1 = (1 - r1), (1 - g1), (1 - b1)
  local ir2,ig2,ib2 = (1 - cColor2.r)*.25, (1 - cColor2.g)*.25, (1 - cColor2.b)*.25
  local Shared = LSM

  local DIALOGUE_FONT;
  if(GetLocale() ~= "enUS") then
    DIALOGUE_FONT = Shared:Fetch("font", "SVUI Default Font")
  else
    DIALOGUE_FONT = Shared:Fetch("font", "SVUI Dialog Font")
  end
  
  SV.Media["color"] = {
    ["default"]     = {0.2, 0.2, 0.2, 1}, 
    ["special"]     = {.37, .32, .29, 1},
    ["specialdark"] = {.23, .22, .21, 1},
    ["unique"]      = {0.32, 0.258, 0.21, 1},  
    ["class"]       = {r1, g1, b1, 1},
    ["bizzaro"]     = {ir1, ig1, ib1, 1},
    ["dark"]        = {0, 0, 0, 1},
    ["darkest"]     = {0, 0, 0, 1},
    ["light"]       = {0.95, 0.95, 0.95, 1},
    ["lightgrey"]   = {0.32, 0.35, 0.38, 1},
    ["highlight"]   = {0.28, 0.75, 1, 1},
    ["green"]       = {0.25, 0.9, 0.08, 1},
    ["blue"]        = {0.08, 0.25, 0.82, 1},
    ["tan"]         = {0.4, 0.32, 0.23, 1},
    ["red"]         = {0.9, 0.08, 0.08, 1},
    ["yellow"]      = {1, 1, 0, 1},
    ["gold"]        = {1, 0.68, 0.1, 1},
    ["transparent"] = {0, 0, 0, 0.5},
    ["hinted"]      = {0, 0, 0, 0.35},
    ["invisible"]      = {0, 0, 0, 0},
    ["white"]       = {1, 1, 1, 1},
  }

  SV.Media["font"] = {
    ["default"]   = Shared:Fetch("font", "SVUI Default Font"),
    ["combat"]    = Shared:Fetch("font", "SVUI Combat Font"),
    ["narrator"]  = Shared:Fetch("font", "SVUI Narrator Font"),
    ["zones"]     = Shared:Fetch("font", "SVUI Zone Font"),
    ["alert"]     = Shared:Fetch("font", "SVUI Alert Font"),
    ["numbers"]   = Shared:Fetch("font", "SVUI Number Font"),
    ["pixel"]     = Shared:Fetch("font", "SVUI Pixel Font"),
    ["caps"]      = Shared:Fetch("font", "SVUI Caps Font"),
    ["flash"]     = Shared:Fetch("font", "SVUI Flash Font"),
    ["dialog"]    = DIALOGUE_FONT,
  }

  SV.Media["bar"] = { 
    ["default"]   = Shared:Fetch("statusbar", "SVUI BasicBar"), 
    ["gradient"]  = Shared:Fetch("statusbar", "SVUI MultiColorBar"), 
    ["smooth"]    = Shared:Fetch("statusbar", "SVUI SmoothBar"), 
    ["flat"]      = Shared:Fetch("statusbar", "SVUI PlainBar"), 
    ["textured"]  = Shared:Fetch("statusbar", "SVUI FancyBar"), 
    ["gloss"]     = Shared:Fetch("statusbar", "SVUI GlossBar"), 
    ["glow"]      = Shared:Fetch("statusbar", "SVUI GlowBar"),
    ["lazer"]     = Shared:Fetch("statusbar", "SVUI LazerBar"),
  }

  SV.Media["bg"] = {
    ["pattern"]     = Shared:Fetch("background", "SVUI Backdrop 1"),
    ["comic"]       = Shared:Fetch("background", "SVUI Comic 1"),
    ["unitlarge"]   = Shared:Fetch("background", "SVUI Unit BG 3"), 
    ["unitsmall"]   = Shared:Fetch("background", "SVUI Small BG 3")
  }

  SV.Media["gradient"]  = {
    ["default"]   = {"VERTICAL", 0.08, 0.08, 0.08, 0.22, 0.22, 0.22}, 
    ["special"]   = {"VERTICAL", 0.33, 0.25, 0.13, 0.47, 0.39, 0.27}, 
    ["class"]     = {"VERTICAL", r2, g2, b2, r1, g1, b1}, 
    ["bizzaro"]   = {"VERTICAL", ir2, ig2, ib2, ir1, ig1, ib1},
    ["dark"]      = {"VERTICAL", 0.02, 0.02, 0.02, 0.22, 0.22, 0.22},
    ["darkest"]   = {"VERTICAL", 0.15, 0.15, 0.15, 0, 0, 0},
    ["darkest2"]  = {"VERTICAL", 0, 0, 0, 0.12, 0.12, 0.12},
    ["light"]     = {"VERTICAL", 0.65, 0.65, 0.65, 0.95, 0.95, 0.95},
    ["highlight"] = {"VERTICAL", 0.3, 0.8, 1, 0.1, 0.9, 1},
    ["green"]     = {"VERTICAL", 0.08, 0.9, 0.25, 0.25, 0.9, 0.08}, 
    ["red"]       = {"VERTICAL", 0.5, 0, 0, 0.9, 0.08, 0.08}, 
    ["yellow"]    = {"VERTICAL", 1, 0.3, 0, 1, 1, 0},
    ["tan"]       = {"VERTICAL", 0.15, 0.08, 0, 0.37, 0.22, 0.1},
    ["inverse"]   = {"VERTICAL", 0.25, 0.25, 0.25, 0.12, 0.12, 0.12},
    ["icon"]      = {"VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1},
    ["white"]     = {"VERTICAL", 0.75, 0.75, 0.75, 1, 1, 1},
  }
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function SV:ColorGradient(perc, ...)
    if perc >= 1 then
        return select(select('#', ...) - 2, ...)
    elseif perc <= 0 then
        return ...
    end
    local num = select('#', ...) / 3
    local segment, relperc = modf(perc*(num-1))
    local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)
    return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end 

function SV:HexColor(arg1,arg2,arg3)
    local r,g,b;
    if arg1 and type(arg1) == "string" then
        local t
        if(self.Media or self.db.media) then
            t = self.Media.color[arg1] or self.db.media.unitframes[arg1]
        end
        if t then
            r,g,b = t[1],t[2],t[3]
        else
            r,g,b = 0,0,0
        end
    else
        r = type(arg1) == "number" and arg1 or 0;
        g = type(arg2) == "number" and arg2 or 0;
        b = type(arg3) == "number" and arg3 or 0;
    end
    r = (r < 0 or r > 1) and 0 or (r * 255)
    g = (g < 0 or g > 1) and 0 or (g * 255)
    b = (b < 0 or b > 1) and 0 or (b * 255)
    local hexString = ("%02x%02x%02x"):format(r,g,b)
    return hexString
end

local function UpdateChatFontSizes()
  _G.CHAT_FONT_HEIGHTS[1] = 8
  _G.CHAT_FONT_HEIGHTS[2] = 9
  _G.CHAT_FONT_HEIGHTS[3] = 10
  _G.CHAT_FONT_HEIGHTS[4] = 11
  _G.CHAT_FONT_HEIGHTS[5] = 12
  _G.CHAT_FONT_HEIGHTS[6] = 13
  _G.CHAT_FONT_HEIGHTS[7] = 14
  _G.CHAT_FONT_HEIGHTS[8] = 15
  _G.CHAT_FONT_HEIGHTS[9] = 16
  _G.CHAT_FONT_HEIGHTS[10] = 17
  _G.CHAT_FONT_HEIGHTS[11] = 18
  _G.CHAT_FONT_HEIGHTS[12] = 19
  _G.CHAT_FONT_HEIGHTS[13] = 20
end

hooksecurefunc("FCF_ResetChatWindows", UpdateChatFontSizes)

local function SetFont(globalName, template, sizeMod, styleOverride, cR, cG, cB)
  if(not template) then return end
  if(not _G[globalName]) then return end
  styleOverride = styleOverride or "NONE"
  SV.SetToFontManager(_G[globalName], template, "SYSTEM", sizeMod, styleOverride, cR, cG, cB);
end

function SV:SetGlobalFonts()
  local fontsize = self.db.font.default.size;
  STANDARD_TEXT_FONT = LSM:Fetch("font", self.db.font.default.file);
  UNIT_NAME_FONT = LSM:Fetch("font", self.db.font.caps.file);
  DAMAGE_TEXT_FONT = LSM:Fetch("font", self.db.font.combat.file);
  NAMEPLATE_FONT = STANDARD_TEXT_FONT
  UpdateChatFontSizes()
  UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = fontsize
end 

function SV:SetSystemFonts()
  --SetFont("GameFontNormal", "default", fontsize - 2)
  SetFont("GameFontWhite", "default", 0, 'OUTLINE', 1, 1, 1)
  SetFont("GameFontWhiteSmall", "default", 0, 'NONE', 1, 1, 1)
  SetFont("GameFontBlack", "default", 0, 'NONE', 0, 0, 0)
  SetFont("GameFontBlackSmall", "default", -1, 'NONE', 0, 0, 0)
  SetFont("GameFontNormalMed2", "default", 2)
  --SetFont("GameFontNormalMed1", "default", 0)
  SetFont("GameFontNormalLarge", "default")
  SetFont("GameFontHighlightSmall", "default")
  SetFont("GameFontHighlight", "default", 1)
  SetFont("GameFontHighlightLeft", "default", 1)
  SetFont("GameFontHighlightRight", "default", 1)
  SetFont("GameFontHighlightLarge2", "default", 2)
  SetFont("SystemFont_Med1", "default")
  SetFont("SystemFont_Med3", "default")
  SetFont("SystemFont_Outline_Small", "default", 0, "OUTLINE")
  SetFont("FriendsFont_Normal", "default")
  SetFont("FriendsFont_Small", "default")
  SetFont("FriendsFont_Large", "default", 3)
  SetFont("FriendsFont_UserText", "default", -1)
  SetFont("SystemFont_Small", "default", -1)
  SetFont("GameFontNormalSmall", "default", -1)
  SetFont("NumberFont_Shadow_Med", "default", -1, "OUTLINE")
  SetFont("NumberFont_Shadow_Small", "default", -1, "OUTLINE")
  SetFont("SystemFont_Tiny", "default", -1)
  SetFont("SystemFont_Shadow_Med1", "default")
  SetFont("SystemFont_Shadow_Med1_Outline", "default")
  SetFont("SystemFont_Shadow_Med2", "default")
  SetFont("SystemFont_Shadow_Med3", "default")
  SetFont("SystemFont_Large", "default")
  SetFont("SystemFont_Huge1", "default", 4)
  SetFont("SystemFont_Huge1_Outline", "default", 4)
  SetFont("SystemFont_Shadow_Small", "default")
  SetFont("SystemFont_Shadow_Large", "default", 3)

  SetFont("QuestFont", "dialog");
  SetFont("QuestFont_Enormous", "zone", 15, "OUTLINE");
  SetFont("SpellFont_Small", "dialog", 0, "OUTLINE", 1, 1, 1);
  SetFont("SystemFont_Shadow_Outline_Huge2", "dialog", 14, "OUTLINE");

  SetFont("GameFont_Gigantic", "alert", 0, "OUTLINE", 32)
  SetFont("SystemFont_Shadow_Huge1", "alert", 0, "OUTLINE")
  --SetFont("SystemFont_OutlineThick_Huge2", "alert", 0, "THICKOUTLINE")

  SetFont("SystemFont_Shadow_Huge3", "combat", 0, "OUTLINE")
  SetFont("CombatTextFont", "combat", 20, "OUTLINE")

  SetFont("SystemFont_OutlineThick_Huge4", "zone", 6, "OUTLINE");
  SetFont("SystemFont_OutlineThick_WTF", "zone", 9, "OUTLINE");
  SetFont("SystemFont_OutlineThick_WTF2", "zone", 15, "OUTLINE");
  SetFont("QuestFont_Large", "zone", -3);
  SetFont("QuestFont_Huge", "zone", -2);
  SetFont("QuestFont_Super_Huge", "zone");
  SetFont("SystemFont_OutlineThick_Huge2", "zone", 2, "OUTLINE");

  SetFont("Game18Font", "number", 1)
  SetFont("Game24Font", "number", 3)
  SetFont("Game27Font", "number", 5)
  SetFont("Game30Font", "number_big")
  SetFont("Game32Font", "number_big", 1)

  SetFont("NumberFont_OutlineThick_Mono_Small", "number", 0, "OUTLINE")
  SetFont("NumberFont_Outline_Huge", "number_big", 0, "OUTLINE")
  SetFont("NumberFont_Outline_Large", "number_big", 0, "OUTLINE")
  SetFont("NumberFont_Outline_Med", "number", 1, "OUTLINE")
  SetFont("NumberFontNormal", "number", 0, "OUTLINE")
  SetFont("NumberFont_GameNormal", "number", 0, "OUTLINE")
  SetFont("NumberFontNormalRight", "number", 0, "OUTLINE")
  SetFont("NumberFontNormalRightRed", "number", 0, "OUTLINE")
  SetFont("NumberFontNormalRightYellow", "number", 0, "OUTLINE")

  SetFont("GameTooltipHeader", "tipheader")
  SetFont("Tooltip_Med", "tipdialog")
  SetFont("Tooltip_Small", "tipdialog", -1)
end

function SV:MediaUpdate()
  self.Media.color.default      = self.db.media.colors.default
  self.Media.color.special      = self.db.media.colors.special
  self.Media.color.specialdark  = self.db.media.colors.specialdark
  self.Media.bg.pattern         = LSM:Fetch("background", self.db.media.textures.pattern)
  self.Media.bg.comic           = LSM:Fetch("background", self.db.media.textures.comic)
  self.Media.bg.unitlarge       = LSM:Fetch("background", self.db.media.textures.unitlarge)
  self.Media.bg.unitsmall       = LSM:Fetch("background", self.db.media.textures.unitsmall)

  local cColor1 = self.Media.color.special
  local cColor2 = self.Media.color.default
  local r1,g1,b1 = cColor1[1], cColor1[2], cColor1[3]
  local r2,g2,b2 = cColor2[1], cColor2[2], cColor2[3]

  self.Media.gradient.special = {"VERTICAL",r1,g1,b1,r2,g2,b2}

  self.Events:Trigger("SVUI_COLORS_UPDATED");
end

function SV:RefreshAllSystemMedia()
  self:SetGlobalFonts();
  self:MediaUpdate();
  self:SetSystemFonts();
  self.Events:Trigger("SVUI_ALLFONTS_UPDATED");
  self.MediaInitialized = true;
end
--[[ 
########################################################## 
INIT SOME COMBAT FONTS
##########################################################
]]--
do
  local fontFile = "Interface\\AddOns\\SVUI\\assets\\fonts\\Combat.ttf"

  _G.DAMAGE_TEXT_FONT = fontFile
  _G.NUM_COMBAT_TEXT_LINES = 20;
  _G.COMBAT_TEXT_SCROLLSPEED = 1.0;
  _G.COMBAT_TEXT_FADEOUT_TIME = 1.0;
  _G.COMBAT_TEXT_HEIGHT = 18;
  _G.COMBAT_TEXT_CRIT_MAXHEIGHT = 2.0;
  _G.COMBAT_TEXT_CRIT_MINHEIGHT = 1.2;
  _G.COMBAT_TEXT_CRIT_SCALE_TIME = 0.7;
  _G.COMBAT_TEXT_CRIT_SHRINKTIME = 0.2;
  _G.COMBAT_TEXT_TO_ANIMATE = {};
  _G.COMBAT_TEXT_STAGGER_RANGE = 20;
  _G.COMBAT_TEXT_SPACING = 7;
  _G.COMBAT_TEXT_MAX_OFFSET = 130;
  _G.COMBAT_TEXT_LOW_HEALTH_THRESHOLD = 0.2;
  _G.COMBAT_TEXT_LOW_MANA_THRESHOLD = 0.2;
  _G.COMBAT_TEXT_LOCATIONS = {};
  
  local fName, fHeight, fFlags = CombatTextFont:GetFont()
  
  CombatTextFont:SetFont(fontFile, fHeight, fFlags)
end