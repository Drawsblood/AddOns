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
local tostring      = _G.tostring;
local tonumber      = _G.tonumber;

--STRING
local string        = _G.string;
local upper         = string.upper;
local format        = string.format;
local find          = string.find;
local match         = string.match;
local gsub          = string.gsub;
--TABLE
local table 		= _G.table; 
local tinsert       = _G.tinsert;
local tremove       = _G.tremove;
local twipe 		= _G.wipe;
--MATH
local math      	= _G.math;
local min 			= math.min;
local floor         = math.floor
local ceil          = math.ceil
--BLIZZARD API
local GameTooltip          	= _G.GameTooltip;
local InCombatLockdown     	= _G.InCombatLockdown;
local CreateFrame          	= _G.CreateFrame;
local GetTime         		= _G.GetTime;
local GetItemCooldown       = _G.GetItemCooldown;
local GetItemCount         	= _G.GetItemCount;
local GetItemInfo          	= _G.GetItemInfo;
local GetSpellInfo         	= _G.GetSpellInfo;
local IsSpellKnown         	= _G.IsSpellKnown;
local GetProfessions       	= _G.GetProfessions;
local GetProfessionInfo    	= _G.GetProfessionInfo;
local hooksecurefunc     	= _G.hooksecurefunc;
--[[ 
########################################################## 
ADDON
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L

local MOD = SV.SVTools;
--[[ 
########################################################## 
LOCALS
##########################################################
]]--
local ICON_SHEET = [[Interface\AddOns\SVUI\assets\artwork\Icons\PROFESSIONS]];
local HEARTH_ICON = [[Interface\AddOns\SVUI\assets\artwork\Icons\DOCK-HEARTH]];

local TOOL_DATA = {
	[171] 	= {0,0.25,0,0.25}, 				-- PRO-ALCHEMY
    [794] 	= {0.25,0.5,0,0.25,80451}, 		-- PRO-ARCHAELOGY
    [164] 	= {0.5,0.75,0,0.25}, 			-- PRO-BLACKSMITH
    [185] 	= {0.75,1,0,0.25,818,67097}, 	-- PRO-COOKING
    [333] 	= {0,0.25,0.25,0.5,13262}, 		-- PRO-ENCHANTING
    [202] 	= {0.25,0.5,0.25,0.5}, 			-- PRO-ENGINEERING
    [129] 	= {0.5,0.75,0.25,0.5}, 			-- PRO-FIRSTAID
    [773] 	= {0,0.25,0.5,0.75,51005}, 		-- PRO-INSCRIPTION
    [755] 	= {0.25,0.5,0.5,0.75,31252},	-- PRO-JEWELCRAFTING
    [165] 	= {0.5,0.75,0.5,0.75}, 			-- PRO-LEATHERWORKING
    [186] 	= {0.75,1,0.5,0.75}, 			-- PRO-MINING
    [197] 	= {0.25,0.5,0.75,1}, 			-- PRO-TAILORING
}
local HEARTH_SPELLS = {556,50977,18960,126892}
local LastAddedMacro;
local MacroCount = 0;

local function GetMacroCooldown(itemID)
	local start,duration = GetItemCooldown(itemID)
	local expires = duration - (GetTime() - start)
	if expires > 0.05 then 
		local timeLeft = 0;
		local calc = 0;
		if expires < 4 then
			return format("|cffff0000%.1f|r", expires)
		elseif expires < 60 then 
			return format("|cffffff00%d|r", floor(expires)) 
		elseif expires < 3600 then
			timeLeft = ceil(expires / 60);
			calc = floor((expires / 60) + .5);
			return format("|cffff9900%dm|r", timeLeft)
		elseif expires < 86400 then
			timeLeft = ceil(expires / 3600);
			calc = floor((expires / 3600) + .5);
			return format("|cff66ffff%dh|r", timeLeft)
		else
			timeLeft = ceil(expires / 86400);
			calc = floor((expires / 86400) + .5);
			return format("|cff6666ff%dd|r", timeLeft)
		end
	else 
		return "|cff6666ffReady|r"
	end 
end

local SetMacroTooltip = function(self)
	local text1 = self:GetAttribute("tipText")
	local text2 = self:GetAttribute("tipExtraText")
	GameTooltip:AddDoubleLine("[Left-Click]", text1, 0, 1, 0, 1, 1, 1)
	if(text2) then
		GameTooltip:AddDoubleLine("[Left-Click]", text1, 0, 1, 0, 1, 1, 1)
		GameTooltip:AddDoubleLine("[Right-Click]", "Use " .. text2, 0, 1, 0, 1, 1, 1)
		if InCombatLockdown() then return end
		if(self.ItemToUse) then
			GameTooltip:AddLine(" ", 1, 1, 1)
			local remaining = GetMacroCooldown(self.ItemToUse)
			GameTooltip:AddDoubleLine(text2, remaining, 1, 0.5, 0, 0, 1, 1)
		end
	end
end

local SetHearthTooltip = function(self)
	local text1 = self:GetAttribute("tipText")
	local text2 = self:GetAttribute("tipExtraText")
	GameTooltip:AddDoubleLine("[Left-Click]", text1, 0, 1, 0, 1, 1, 1)
	if InCombatLockdown() then return end
	local remaining = GetMacroCooldown(6948)
	GameTooltip:AddDoubleLine(L["Time Remaining"], remaining, 1, 1, 1, 0, 1, 1)
	if(text2) then
		GameTooltip:AddLine(" ", 1, 1, 1)
		GameTooltip:AddDoubleLine("[Right Click]", text2, 0, 1, 0, 1, 1, 1)
	end
end

local function CreateMacroToolButton(proName, proID, itemID) 
	local data = TOOL_DATA[proID]
	if(not data) then return end

	local globalName = ("SVUI_%s"):format(proName)
	local button = SV.Dock:SetDockButton("BottomRight", proName, ICON_SHEET, nil, globalName, SetMacroTooltip, "SecureActionButtonTemplate")

	button.Icon:SetTexCoord(data[1], data[2], data[3], data[4])

	if proID == 186 then proName = GetSpellInfo(2656) end

	--button:RegisterForClicks("AnyDown")
	button:SetAttribute("type1", "macro")
	button:SetAttribute("macrotext1", "/cast [nomod]" .. proName)

	if(data[5]) then
		local rightClick
		if(data[6] and GetItemCount(data[6], true) > 0) then
			rightClick = GetItemInfo(data[6])
			button.ItemToUse = data[6]
		else
			rightClick = GetSpellInfo(data[5])
		end
		button:SetAttribute("tipExtraText", rightClick)
		button:SetAttribute("type2", "macro")
		button:SetAttribute("macrotext2", "/cast [nomod] " .. rightClick)
	end
end

local function LoadToolBarProfessions()
	if((not SV.db.SVTools.professions) or MOD.ToolBarLoaded) then return end
	if(InCombatLockdown()) then 
		MOD.ProfessionNeedsUpdate = true; 
		MOD:RegisterEvent("PLAYER_REGEN_ENABLED"); 
		return 
	end

	-- HEARTH BUTTON
	local hearthStone = GetItemInfo(6948);
	if(hearthStone and type(hearthStone) == "string") then
		local hearth = SV.Dock:SetDockButton("BottomLeft", L["Hearthstone"], HEARTH_ICON, nil, "SVUI_Hearth", SetHearthTooltip, "SecureActionButtonTemplate")
		hearth.Icon:SetTexCoord(0,0.5,0,1)
		hearth:SetAttribute("type1", "macro")
		hearth:SetAttribute("macrotext1", "/use [nomod]" .. hearthStone)
		local hasRightClick = false;
		for i = 1, #HEARTH_SPELLS do
			if(IsSpellKnown(HEARTH_SPELLS[i])) then
				local rightClickSpell = GetSpellInfo(HEARTH_SPELLS[i])
				hearth:SetAttribute("tipExtraText", rightClickSpell)
				hearth:SetAttribute("type2", "macro")
				hearth:SetAttribute("macrotext2", "/use [nomod] " .. rightClickSpell)
				hasRightClick = true;
			end
		end
	end

	-- PROFESSION BUTTONS
	local proName, proID
	local prof1, prof2, archaeology, _, cooking, firstAid = GetProfessions()

	if(firstAid ~= nil) then 
		proName, _, _, _, _, _, proID = GetProfessionInfo(firstAid)
		CreateMacroToolButton(proName, proID, firstAid)
	end 

	if(archaeology ~= nil) then 
		proName, _, _, _, _, _, proID = GetProfessionInfo(archaeology)
		CreateMacroToolButton(proName, proID, archaeology)
	end 

	if(cooking ~= nil) then 
		proName, _, _, _, _, _, proID = GetProfessionInfo(cooking)
		CreateMacroToolButton(proName, proID, cooking)
	end 

	if(prof2 ~= nil) then 
		proName, _, _, _, _, _, proID = GetProfessionInfo(prof2)
		if(proID ~= 182 and proID ~= 393) then
			CreateMacroToolButton(proName, proID, prof2)
		end
	end 

	if(prof1 ~= nil) then 
		proName, _, _, _, _, _, proID = GetProfessionInfo(prof1)
		if(proID ~= 182 and proID ~= 393) then
			CreateMacroToolButton(proName, proID, prof1)
		end
	end

	MOD.ToolBarLoaded = true
end
--[[ 
########################################################## 
BUILD/UPDATE
##########################################################
]]--
function MOD:UpdateProfessionTools() 
	if((not SV.db.SVTools.professions) or self.ToolBarLoaded) then return end
	LoadToolBarProfessions()
end 

function MOD:LoadProfessionTools()
	if((not SV.db.SVTools.professions) or self.ToolBarLoaded) then return end
	SV.Timers:ExecuteTimer(LoadToolBarProfessions, 5)
end