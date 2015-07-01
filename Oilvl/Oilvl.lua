local cfg
local L = OILVL_L

local HELM, NECK, SHOULDER, SHIRT, CHEST, WAIST, LEGS, FEET, WRISTS, HANDS, RING1, RING2, TRINK1, TRINK2, BACK, WEP, OFFHAND = 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17;

local oenchantItem = {
	[0] = {0, INVTYPE_AMMO},
	[1] = {0, INVTYPE_HEAD},
	[2] = {1, INVTYPE_NECK},
	[3] = {0, INVTYPE_SHOULDER},
	[4] = {0, INVTYPE_BODY},
	[5] = {0, INVTYPE_CHEST},
	[6] = {0, INVTYPE_WAIST},
	[7] = {0, INVTYPE_LEGS},
	[8] = {0, INVTYPE_FEET},
	[9] = {0, INVTYPE_WRIST},
	[10] = {0, INVTYPE_HAND},
	[11] = {1, INVTYPE_FINGER.."1"},
	[12] = {1, INVTYPE_FINGER.."2"},
	[13] = {0, INVTYPE_TRINKET.."1"},
	[14] = {0, INVTYPE_TRINKET.."2"},
	[15] = {1, INVTYPE_CLOAK},
	[16] = {1, INVTYPE_WEAPON},
	[17] = {1, INVTYPE_SHIELD},
}

local gslot = {
	["INVTYPE_HEAD"] = 1,
	["INVTYPE_NECK"] = 2,
	["INVTYPE_SHOULDER"] = 3,
	["INVTYPE_BODY"] = 4,
	["INVTYPE_CHEST"] = 5,
	["INVTYPE_ROBE"] = 5,
	["INVTYPE_WAIST"] = 6,
	["INVTYPE_LEGS"] = 7,
	["INVTYPE_FEET"] = 8,
	["INVTYPE_WRIST"] = 9,
	["INVTYPE_HAND"] = 10,
	["INVTYPE_FINGER"] = 11,
	["INVTYPE_TRINKET"] = 13,
	["INVTYPE_CLOAK"] = 15,
	["INVTYPE_WEAPON"] = 16,17,
	["INVTYPE_SHIELD"] = 17,
	["INVTYPE_2HWEAPON"] = 16,
	["INVTYPE_WEAPONMAINHAND"] = 16,
	["INVTYPE_WEAPONOFFHAND"] = 17,
	["INVTYPE_HOLDABLE"] = 17,
}

local LibQTip = LibStub('LibQTip-1.0');
local otooltip; -- target raid progression detail tooltips
local otooltip2; -- OiLvL raid progression detail tooltips
local otooltip4; -- save roll item and player rolls + items
local otooltip5; -- player alts
local otooltip6; -- LDB.OnEnter
local otooltip7; -- cache
local otooltip6rpi;
local otooltip6sortMethod = "ID";
local oroll = {};
local orolln = 0;

local LDB = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("O Item Level",
{
	type	= "data source",
	icon	= "Interface/AddOns/Oilvl/config.tga",
	label	= "O Item Level",
	text	= "O Item Level"
})
local LDB_ANCHOR;

local ORole = {
	-- width = 64, height = 16
	-- left/width, right/width, top/height, bottom/height
	-- from x = 32 to 48,       from y = 0 to 16
	-- 32/64, 48/64, 0/16, 16/16
	["TANK"]   = {"Interface\\LFGFrame\\LFGRole", 0.5, 0.75, 0, 1}, 
	-- 48/64, 64/64, 0/16, 16/16
	["HEALER"] = {"Interface\\LFGFrame\\LFGRole", 0.75, 1, 0, 1}, 
	-- 16/64, 32/64, 0/16, 16/16
	["DAMAGER"] = {"Interface\\LFGFrame\\LFGRole", 0.25, 0.5, 0, 1}, 
	["NONE"] = {"",0,0,0,0}
}

local OPvP = {"Interface/PVPFrame/UI-CHARACTER-PVP-ELEMENTS",460/512,1,0,75/512}

local ORole2 = {
	["TANK"]   = "|TInterface\\LFGFrame\\LFGRole:0:0:0:0:64:16:32:48:0:16:255:255:255|t", 
	["HEALER"] = "|TInterface\\LFGFrame\\LFGRole:0:0:0:0:64:16:48:64:0:16:255:255:255|t",  
	["DAMAGER"] = "|TInterface\\LFGFrame\\LFGRole:0:0:0:0:64:16:16:32:0:16:255:255:255|t", 
	["NONE"] = ""
}

local ORank = {
	[0] = {""},
	[1] = {"Interface\\GROUPFRAME\\UI-GROUP-ASSISTANTICON"},
	[2] = {"Interface\\GROUPFRAME\\UI-Group-LeaderIcon"},
}
local ospec={};
local oispec;
for oispec = 62, 66 do
	local _, name, _, _, _, _, _ = GetSpecializationInfoByID(oispec)
	ospec[oispec] = name;
end
for oispec = 70, 73 do
	local _, name, _, _, _, _, _ = GetSpecializationInfoByID(oispec)
	ospec[oispec] = name;
end
for oispec = 102, 105 do
	local _, name, _, _, _, _, _ = GetSpecializationInfoByID(oispec)
	ospec[oispec] = name;
end
for oispec = 250, 270 do
	local _, name, _, _, _, _, _ = GetSpecializationInfoByID(oispec)
	ospec[oispec] = name;
end

local classcolor = {
	[6]= "|cFFC41F3B",
	[11]= "|cFFFF7D0A",
	[3]= "|cFFABD473",
	[8]= "|cFF69CCF0",
	[10]= "|cFF00FF96",
	[2]= "|cFFF58CBA",
	[5]= "|cFFFFFFFF",
	[4]= "|cFFFFF569",
	[7]= "|cFF0070DE",
	[9]= "|cFF9482C9",
	[1]= "|cFFC79C6E",
	[0]= "|cFFFFFF00",
}

local Oilvlrole = {};
local Oilvlrank = {};
local ItemUpgradeInfo = LibStub("LibItemUpgradeInfo-1.0")
local Oilvltimer = LibStub("AceAddon-3.0"):NewAddon("OilvlTimer", "AceTimer-3.0")

local OILVL = CreateFrame("Frame");
local oilvlframesw=false;
local oilvlframedata = {};
oilvlframedata.guid = {};

oilvlframedata.name = {};
oilvlframedata.spec = {}; -- specialization
oilvlframedata.role = {};
oilvlframedata.ilvl = {};

oilvlframedata.me = {}; -- miss enchant
oilvlframedata.mg = {}; -- miss gem
oilvlframedata.gear = {};

local OILVL_Unit="";
local OTilvl=0;
local OTmia=0;
local OTTop=0;	
local Omover=0;
local omover2=0;
local OTCurrent=""; -- current raid frame
local OTCurrent2=""; -- current unit id
local OTCurrent3=""; -- current raid frame number
local ountrack=true;
local ail=0; -- average item level
local ailtank=0;
local aildps=0;
local ailheal=0;
local NumRole = {};
NumRole["TANK"] = 0;
NumRole["DAMAGER"] = 0;
NumRole["HEALER"] = 0;
local miacount=0;
local miaunit={};
local rpunit="";
local rpsw=false;
local orollgear = "";
local elvlootslotSW = false;

local OgemFrame = CreateFrame('GameTooltip', 'OSocketTooltip', UIParent, 'GameTooltipTemplate');
function OItemAnalysis_CountEmptySockets(itemLink)
	local count = 0;

	for textureCount = 1, 10 do
		if _G["OSocketTooltipTexture"..textureCount] then
			_G["OSocketTooltipTexture"..textureCount]:SetTexture("");
		end
	end 
		
	OgemFrame:SetOwner(UIParent, 'ANCHOR_NONE');
	OgemFrame:ClearLines();
	OgemFrame:SetHyperlink(itemLink);
		
	for textureCount = 1, 10 do
		local temp = _G["OSocketTooltipTexture"..textureCount]:GetTexture();
		
		if temp and temp == "Interface\\ItemSocketingFrame\\UI-EmptySocket-Meta" then 
			count = count + 1;
		end
		if temp and temp == "Interface\\ItemSocketingFrame\\UI-EmptySocket-Red" then 
			count = count + 1;
		end
		if temp and temp == "Interface\\ItemSocketingFrame\\UI-EmptySocket-Yellow" then 
			count = count + 1;			
		end
		if temp and temp == "Interface\\ItemSocketingFrame\\UI-EmptySocket-Blue" then 
			count = count + 1;
		end
		if temp and temp == "Interface\\ItemSocketingFrame\\UI-EmptySocket-Prismatic" then 
			count = count + 1;
		end 
	end
	OgemFrame:Hide();
	return count;
end

local OPvPFrame = CreateFrame('GameTooltip', 'OPvPTooltip', UIParent, 'GameTooltipTemplate');
function OItemAnalysis_CheckPvPGear(itemLink)
	OPvPFrame:SetOwner(UIParent, 'ANCHOR_NONE');
	OPvPFrame:ClearLines();
	OPvPFrame:SetHyperlink(itemLink);
	
	for i = 1, 30 do
		if _G["OPvPTooltipTextLeft"..i]:GetText() then
			local pvpilvl = _G["OPvPTooltipTextLeft"..i]:GetText():match(PVP_ITEM_LEVEL_TOOLTIP:gsub("%%d","(%%d+)"));
			if  pvpilvl then
				OPvPFrame:Hide();
				return tonumber(pvpilvl);
			end
		else
			break
		end
	end
	OPvPFrame:Hide();
	return 0;
end

function oClassColor(unitid)
	local _, _, cclass = UnitClass(unitid);
	if classcolor[cclass] ~= nil then
		return classcolor[cclass];
	else
		return "|cFFFFFF00";
	end
end
-- OT Check Raid Item Level
function oilvl(unit)
	if not UnitAffectingCombat("player") then
		OILVL_Unit=unit;
		if CheckInteractDistance(OILVL_Unit, 1) and CanInspect(OILVL_Unit) then
			OILVL:RegisterEvent("INSPECT_READY");
			NotifyInspect(OILVL_Unit);
			local htex4 = _G[OTCurrent]:CreateTexture()
			htex4:SetTexture(0,1,1,0.5)
			htex4:SetTexCoord(0, 0.625, 0, 0.6875)
			htex4:SetAllPoints()
			_G[OTCurrent]:SetNormalTexture(htex4)
		else
			OILVL_Unit="";
			miacount=0;
			miaunit[1]="";miaunit[2]="";miaunit[3]="";miaunit[4]="";miaunit[5]="";miaunit[6]="";
			local ntex4 = _G[OTCurrent]:CreateTexture()
			ntex4:SetTexture(0.2,0.2,0.2,0.5)
			ntex4:SetTexCoord(0, 0.625, 0, 0.6875)
			ntex4:SetAllPoints()	
			_G[OTCurrent]:SetNormalTexture(ntex4)
			OTCurrent = "";
			OTCurrent2 = "";
			OTCurrent3 = "";
			ountrack=true;			
		end
	end
end
	
-- Get Raid Frame Item Level
function ORfbIlvl(ounit)
if not UnitAffectingCombat("player") and ounit ~= "" then
	local i=0;
	OTCurrent3 = tonumber(ounit);
	if IsInRaid() then
		OTCurrent = "OILVLRAIDFRAME"..ounit;		
		OTCurrent2 = "raid"..ounit;
		if _G[OTCurrent] == nil then return -1 end
		if GetUnitName(OTCurrent2,"") ~= nil then
			_G[OTCurrent]:SetText(oClassColor(OTCurrent2)..GetUnitName(OTCurrent2,""):gsub("%-.+", ""));
			oilvlframedata.name[tonumber(ounit)] = GetUnitName(OTCurrent2,""):gsub("%-.+", "");
			oilvl(OTCurrent2);
		end
	elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		if ounit == "1" or ounit == 1 then
			OTCurrent = "OILVLRAIDFRAME1";
			OTCurrent2 = "player";
			if _G[OTCurrent] == nil then return -1 end
			if GetUnitName(OTCurrent2,"") ~= nil then
				_G[OTCurrent]:SetText(oClassColor(OTCurrent2)..GetUnitName(OTCurrent2,""):gsub("%-.+", ""));
				oilvlframedata.name[1] = GetUnitName(OTCurrent2,""):gsub("%-.+", "");
				oilvl(OTCurrent2);
			end
		else
			OTCurrent = "OILVLRAIDFRAME"..ounit;
			OTCurrent2 = "party"..(tonumber(ounit)-1);
			if _G[OTCurrent] == nil then return -1 end
			if GetUnitName(OTCurrent2,"") ~= nil then
				_G[OTCurrent]:SetText(oClassColor(OTCurrent2)..GetUnitName(OTCurrent2,""):gsub("%-.+", ""));
				oilvlframedata.name[tonumber(ounit)] = GetUnitName(OTCurrent2,""):gsub("%-.+", "");
				oilvl(OTCurrent2);
			end
		end
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		if ounit == "1"  or ounit == 1 then
			OTCurrent = "OILVLRAIDFRAME1";
			OTCurrent2 = "player";
			if _G[OTCurrent] == nil then return -1 end
			if GetUnitName(OTCurrent2,"") ~= nil then
				_G[OTCurrent]:SetText(oClassColor(OTCurrent2)..GetUnitName(OTCurrent2,""):gsub("%-.+", ""));
				oilvlframedata.name[1] = GetUnitName(OTCurrent2,""):gsub("%-.+", "");
				oilvl(OTCurrent2);
			end
		else
			OTCurrent = "OILVLRAIDFRAME"..ounit;
			OTCurrent2 = "party"..(tonumber(ounit)-1);
			if _G[OTCurrent] == nil then return -1 end
			if GetUnitName(OTCurrent2,"") ~= nil then
				_G[OTCurrent]:SetText(oClassColor(OTCurrent2)..GetUnitName(OTCurrent2,""):gsub("%-.+", ""));
				oilvlframedata.name[tonumber(ounit)] = GetUnitName(OTCurrent2,""):gsub("%-.+", "");
				oilvl(OTCurrent2);
			end
		end
	else
		OTCurrent = "OILVLRAIDFRAME1";
		OTCurrent2 = "player";
		if _G[OTCurrent] == nil then return -1 end
		if GetUnitName(OTCurrent2,"") ~= nil then
			_G[OTCurrent]:SetText(oClassColor(OTCurrent2)..GetUnitName(OTCurrent2,""):gsub("%-.+", ""));
			oilvlframedata.name[1] = GetUnitName(OTCurrent2,""):gsub("%-.+", "");
			oilvl(OTCurrent2);
		end
	end
end
end

function OilvlSetRole(ounit, orole)
	Oilvlrole[ounit]:SetTexture(ORole[orole][1]);
	Oilvlrole[ounit]:SetTexCoord(ORole[orole][2],ORole[orole][3],ORole[orole][4],ORole[orole][5]);
	oilvlframedata.role[ounit] = orole;
	if orole ~= "NONE" then NumRole[orole] = NumRole[orole] + 1; end
end

function OilvlSetRank(ounit, orole)
	Oilvlrank[ounit]:SetTexture(ORank[orole][1]);
end

function OilvlSetMouseoverTooltips(oframe, ounit)
	oframe:SetAttribute("unit", ounit);
end

function OilvlRunMouseoverTooltips(oframe)
	local ounit = oframe:GetAttribute("unit") 
	if not LibQTip:IsAcquired("Oraidprog") then
		OilvlTooltip:SetOwner(oframe, "ANCHOR_BOTTOMRIGHT");
		OilvlTooltip:SetUnit(ounit)
		local i = tonumber(oframe:GetName():gsub("OILVLRAIDFRAME", "").."");
		if oilvlframedata.spec[i] ~= "" then
			OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
			OilvlTooltip:AddLine(SPECIALIZATION.." |cFF00FF00"..oilvlframedata.spec[i]);
		end
		if oilvlframedata.me[i][1] and oilvlframedata.me[i][1] ~= "" then
			OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
			OilvlTooltip:AddLine(ENSCRIBE..":\n|cFF00FF00"..oilvlframedata.me[i][1]);
		end
		if oilvlframedata.mg[i][1] and oilvlframedata.mg[i][1] ~= "" then
			OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
			OilvlTooltip:AddLine(L["Gem"]..":\n|cFF00FF00"..oilvlframedata.mg[i][1]);
		end
		if oilvlframedata.me[i][2] and oilvlframedata.me[i][2] ~= "" then
			OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
			OilvlTooltip:AddLine(LOW.." "..ENSCRIBE..":\n|cFF00FF00"..oilvlframedata.me[i][2]);
		end
		if oilvlframedata.mg[i][2] and oilvlframedata.mg[i][2] ~= "" then
			OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
			OilvlTooltip:AddLine(LOW.." "..L["Gem"]..":\n|cFF00FF00"..oilvlframedata.mg[i][2]);
		end
		OilvlTooltip:Show()
		if not rpsw and CheckInteractDistance(ounit, 1) and UnitExists(ounit) then
			Omover2=1;
			ClearAchievementComparisonUnit();
			--print("OilvlRunMouseoverTooltips ClearAchievementComparisonUnit")
			OILVL:RegisterEvent("INSPECT_ACHIEVEMENT_READY")			
			SetAchievementComparisonUnit(ounit);
			rpsw=true;
			rpunit=ounit;
		end
	end
end


function oilvlcheckunknown()
	if IsInRaid() then
		rnum = GetNumGroupMembers();
		for i = 1, rnum do
			if oilvlframedata.name[i] == "Unknown" then
				_G["OILVLRAIDFRAME"..i]:SetText(oClassColor("raid"..i)..GetUnitName("raid"..i,""):gsub("%-.+", ""));
				_G["OILVLRAIDFRAME"..i]:Show();
				oilvlframedata.guid[i] = UnitGUID("raid"..i);
				oilvlframedata.name[i] = GetUnitName("raid"..i,""):gsub("%-.+", "");
				oilvlframedata.ilvl[i] = "";
				oilvlframedata.me[i] = "";
				oilvlframedata.mg[i] = "";
				oilvlframedata.spec[i] = "";
				oilvlframedata.gear[i] = "";
			end
		end
	elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		rnum = GetNumGroupMembers(LE_PARTY_CATEGORY_INSTANCE)
		for i = 2, rnum do
			if oilvlframedata.name[i] == "Unknown" then
				_G["OILVLRAIDFRAME"..i]:SetText(oClassColor("party"..(i-1))..GetUnitName("party"..(i-1),""):gsub("%-.+", ""));
				_G["OILVLRAIDFRAME"..i]:Show();
				oilvlframedata.guid[i] = UnitGUID("party"..(i-1));
				oilvlframedata.name[i] = GetUnitName("party"..(i-1),""):gsub("%-.+", "")
				oilvlframedata.ilvl[i] = "";
				oilvlframedata.me[i] = "";
				oilvlframedata.mg[i] = "";
				oilvlframedata.spec[i] = "";
				oilvlframedata.gear[i] = "";
			end
		end
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		rnum = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
		for i = 2, rnum do
			if oilvlframedata.name[i] == "Unknown" then
				_G["OILVLRAIDFRAME"..i]:SetText(oClassColor("party"..(i-1))..GetUnitName("party"..(i-1),""):gsub("%-.+", ""));
				_G["OILVLRAIDFRAME"..i]:Show();
				oilvlframedata.guid[i] = UnitGUID("party"..(i-1));
				oilvlframedata.name[i] = GetUnitName("party"..(i-1),""):gsub("%-.+", "")
				oilvlframedata.ilvl[i] = "";
				oilvlframedata.me[i] = "";
				oilvlframedata.mg[i] = "";
				oilvlframedata.spec[i] = "";
				oilvlframedata.gear[i] = "";
			end
		end
	else
		return 0
	end
end

function OILVLCheckUpdate()
if not UnitAffectingCombat("player") and OILVL_Unit == "" and oilvlframesw then
	oilvlcheckunknown();
	ountrack=false;
	for i = 1, 40 do
		if not _G["OILVLRAIDFRAME"..i] then break; end
		if not _G["OILVLRAIDFRAME"..i]:IsShown() then
			break;
		end
		local msg = _G["OILVLRAIDFRAME"..i]:GetText();
		if msg == nil then
			break;
		end
		msg = msg:sub(11):gsub("\n|r|cFF00FF00",":"):gsub("\n|r|cFFFF0000",":");
		local ochar, ilvl = strsplit(":",msg,2)	
		if ilvl == nil or ilvl == "" then
			ountrack = true;
			if IsInRaid() then
				if CheckInteractDistance("raid"..i, 1) and CanInspect("raid"..i) then ORfbIlvl(i); return 0; end
			elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
				if i == 1 then
					ORfbIlvl(i); return 0;
				else
					if CheckInteractDistance("party"..(i-1), 1) and CanInspect("party"..(i-1)) then ORfbIlvl(i); return 0; end
				end
			elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
				if i == 1 then
					ORfbIlvl(i); return 0;
				else
					if CheckInteractDistance("party"..(i-1), 1) and CanInspect("party"..(i-1)) then ORfbIlvl(i); return 0; end
				end
			else
				ORfbIlvl(1); return 0;
			end
		end
	end	
end
end
	
function OVILRefresh()
if not UnitAffectingCombat("player") and oilvlframesw then
	local i=0;
	local rnum=0;
	ountrack=true;
	OTCurrent=""; -- current raid frame
	OTCurrent2=""; -- current unit id
	OTCurrent3=""; -- current raid frame number
	OILVL_Unit="";
	for i = 1, 40 do
		-- reset the color of all frames
		if not _G["OILVLRAIDFRAME"..i]  then break; end
		local ntex4 = _G["OILVLRAIDFRAME"..i]:CreateTexture()
		ntex4:SetTexture(0.2,0.2,0.2,0.5)
		ntex4:SetTexCoord(0, 0.625, 0, 0.6875)
		ntex4:SetAllPoints()	
		_G["OILVLRAIDFRAME"..i]:SetNormalTexture(ntex4)			
		
		-- reset data
		oilvlframedata.guid[i] = "";
		oilvlframedata.name[i] = "";
		oilvlframedata.ilvl[i] = "";
		oilvlframedata.me[i] = "";
		oilvlframedata.mg[i] = "";
		oilvlframedata.spec[i] = "";
		oilvlframedata.gear[i] = "";
	end
	if IsInRaid() then
		rnum = GetNumGroupMembers();
		if rnum < 16 then
			OIVLFRAME:SetWidth(400);
		end
		if rnum >= 16 and rnum <= 20 then
			OIVLFRAME:SetWidth(400);
		end
		if rnum >= 21 and rnum <= 25 then
			OIVLFRAME:SetWidth(430);
		end
		if rnum >= 26 and rnum <= 30 then
			OIVLFRAME:SetWidth(512);
		end
		if rnum >= 31 and rnum <= 35 then
			OIVLFRAME:SetWidth(594);
		end
		if rnum >= 36 and rnum <= 40 then
			OIVLFRAME:SetWidth(676);
		end
		for i = rnum+1, 40 do
			if not _G["OILVLRAIDFRAME"..i]  then break; end
			_G["OILVLRAIDFRAME"..i]:SetText("");
			_G["OILVLRAIDFRAME"..i]:Hide();
			oilvlframedata.guid[i] = "";
			oilvlframedata.name[i] = "";
			oilvlframedata.ilvl[i] = "";
			oilvlframedata.me[i] = "";
			oilvlframedata.mg[i] = "";
			oilvlframedata.spec[i] = "";
			oilvlframedata.gear[i] = "";
		end
		NumRole["TANK"] = 0;
		NumRole["DAMAGER"] = 0;
		NumRole["HEALER"] = 0;
		for i = 1, rnum do
			if not _G["OILVLRAIDFRAME"..i]  then break; end
			_G["OILVLRAIDFRAME"..i]:SetText(oClassColor("raid"..i)..GetUnitName("raid"..i,""):gsub("%-.+", ""));
			_G["OILVLRAIDFRAME"..i]:Show();
			OilvlSetRole(i, UnitGroupRolesAssigned("raid"..i,""));
			local _, rank, _, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(i)
			OilvlSetRank(i, rank);
			oilvlframedata.guid[i] = UnitGUID("raid"..i);
			oilvlframedata.name[i] = GetUnitName("raid"..i,""):gsub("%-.+", "");
			oilvlframedata.ilvl[i] = "";
			oilvlframedata.me[i] = "";
			oilvlframedata.mg[i] = "";
			oilvlframedata.spec[i] = "";
			oilvlframedata.gear[i] = "";
			OilvlSetMouseoverTooltips(_G["OILVLRAIDFRAME"..i], "raid"..i);
		end
	elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		rnum = GetNumGroupMembers(LE_PARTY_CATEGORY_INSTANCE)
		for i = rnum, 40 do
			if not _G["OILVLRAIDFRAME"..i]  then break; end
			_G["OILVLRAIDFRAME"..i]:SetText("");
			_G["OILVLRAIDFRAME"..i]:Hide();
			oilvlframedata.guid[i] = "";
			oilvlframedata.name[i] = "";
			oilvlframedata.ilvl[i] = "";
			oilvlframedata.me[i] = "";
			oilvlframedata.mg[i] = "";
			oilvlframedata.spec[i] = "";
			oilvlframedata.gear[i] = "";
		end
		NumRole["TANK"] = 0;
		NumRole["DAMAGER"] = 0;
		NumRole["HEALER"] = 0;
		OILVLRAIDFRAME1:Show();
		OILVLRAIDFRAME1:SetText(oClassColor("player")..GetUnitName("player",""):gsub("%-.+", ""));
		OilvlSetRole(1, UnitGroupRolesAssigned("player"));
		if UnitIsGroupLeader("player") then	OilvlSetRank(1, 2);	else OilvlSetRank(1, 0); end
		oilvlframedata.guid[1] = UnitGUID("player");
		oilvlframedata.name[1] = GetUnitName("player",""):gsub("%-.+", "");
		oilvlframedata.ilvl[1] = "";
		oilvlframedata.me[1] = "";
		oilvlframedata.mg[1] = "";
		oilvlframedata.spec[1] = "";
		oilvlframedata.gear[1] = "";
		OilvlSetMouseoverTooltips(OILVLRAIDFRAME1, "player");
		for i = 2, rnum do
			if not _G["OILVLRAIDFRAME"..i]  then break; end
			_G["OILVLRAIDFRAME"..i]:SetText(oClassColor("party"..(i-1))..GetUnitName("party"..(i-1),""):gsub("%-.+", ""));
			_G["OILVLRAIDFRAME"..i]:Show();
			OilvlSetRole(i, UnitGroupRolesAssigned("party"..(i-1),""));
			if UnitIsGroupLeader("party"..(i-1)) then OilvlSetRank(i, 2); else OilvlSetRank(i, 0); end
			oilvlframedata.guid[i] = UnitGUID("party"..(i-1));
			oilvlframedata.name[i] = GetUnitName("party"..(i-1),""):gsub("%-.+", "")
			oilvlframedata.ilvl[i] = "";
			oilvlframedata.me[i] = "";
			oilvlframedata.mg[i] = "";
			oilvlframedata.spec[i] = "";
			oilvlframedata.gear[i] = "";
			OilvlSetMouseoverTooltips(_G["OILVLRAIDFRAME"..i], "party"..(i-1));
		end
		OIVLFRAME:SetWidth(400);
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		rnum = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
		for i = rnum, 40 do
			if not _G["OILVLRAIDFRAME"..i]  then break; end
			_G["OILVLRAIDFRAME"..i]:SetText("");
			_G["OILVLRAIDFRAME"..i]:Hide();
			oilvlframedata.guid[i] = "";
			oilvlframedata.name[i] = "";
			oilvlframedata.ilvl[i] = "";
			oilvlframedata.me[i] = "";
			oilvlframedata.mg[i] = "";
			oilvlframedata.spec[i] = "";
			oilvlframedata.gear[i] = "";
		end
		NumRole["TANK"] = 0;
		NumRole["DAMAGER"] = 0;
		NumRole["HEALER"] = 0;
		OILVLRAIDFRAME1:Show();
		OILVLRAIDFRAME1:SetText(oClassColor("player")..GetUnitName("player",""):gsub("%-.+", ""));
		OilvlSetRole(1, UnitGroupRolesAssigned("player"));
		if UnitIsGroupLeader("player") then	OilvlSetRank(1, 2);	else OilvlSetRank(1, 0); end
		oilvlframedata.guid[1] = UnitGUID("player");
		oilvlframedata.name[1] = GetUnitName("player",""):gsub("%-.+", "");
		oilvlframedata.ilvl[1] = "";
		oilvlframedata.me[1] = "";
		oilvlframedata.mg[1] = "";
		oilvlframedata.spec[1] = "";
		oilvlframedata.gear[1] = "";
		OilvlSetMouseoverTooltips(OILVLRAIDFRAME1, "player");
		for i = 2, rnum do
			if not _G["OILVLRAIDFRAME"..i]  then break; end
			_G["OILVLRAIDFRAME"..i]:SetText(oClassColor("party"..(i-1))..GetUnitName("party"..(i-1),""):gsub("%-.+", ""));
			_G["OILVLRAIDFRAME"..i]:Show();
			OilvlSetRole(i, UnitGroupRolesAssigned("party"..(i-1),""));
			if UnitIsGroupLeader("party"..(i-1)) then OilvlSetRank(i, 2); else OilvlSetRank(i, 0); end
			oilvlframedata.guid[i] = UnitGUID("party"..(i-1));
			oilvlframedata.name[i] = GetUnitName("party"..(i-1),""):gsub("%-.+", "")
			oilvlframedata.ilvl[i] = "";
			oilvlframedata.me[i] = "";
			oilvlframedata.mg[i] = "";
			oilvlframedata.spec[i] = "";
			oilvlframedata.gear[i] = "";
			OilvlSetMouseoverTooltips(_G["OILVLRAIDFRAME"..i], "party"..(i-1));
		end
		OIVLFRAME:SetWidth(400);
	else
		for i = 2, 40 do
			if not _G["OILVLRAIDFRAME"..i]  then break; end
			_G["OILVLRAIDFRAME"..i]:SetText("");
			_G["OILVLRAIDFRAME"..i]:Hide();
			oilvlframedata.guid[i] = "";
			oilvlframedata.name[i] = "";
			oilvlframedata.ilvl[i] = "";
			oilvlframedata.me[i] = "";
			oilvlframedata.mg[i] = "";
			oilvlframedata.spec[i] = "";
			oilvlframedata.gear[i] = "";
		end
		NumRole["TANK"] = 0;
		NumRole["DAMAGER"] = 0;
		NumRole["HEALER"] = 0;
		OILVLRAIDFRAME1:SetText(oClassColor("player")..GetUnitName("player",""):gsub("%-.+", ""));
		OilvlSetRole(1, UnitGroupRolesAssigned("player"));
		OilvlSetRank(1, 0);
		OIVLFRAME:SetWidth(400);
		oilvlframedata.guid[1] = UnitGUID("player");
		oilvlframedata.name[1] = GetUnitName("player",""):gsub("%-.+", "");
		oilvlframedata.ilvl[1] = "";
		oilvlframedata.me[1] = "";
		oilvlframedata.mg[1] = "";
		oilvlframedata.spec[1] = "";
		oilvlframedata.gear[1] = "";
		OilvlSetMouseoverTooltips(OILVLRAIDFRAME1, "player");
	end
end
	ountrack=true;
	OTCurrent=""; -- current raid frame
	OTCurrent2=""; -- current unit id
	OTCurrent3=""; -- current raid frame number
end
-- Same as OVILRefresh(), but do not clear item level.
function OilvlCheckFrame()
if not UnitAffectingCombat("player") and oilvlframesw then
	local i=0;
	local j=0;
	local rnum=0;
	local td = {};
	td.guid = {};
	td.name = {};
	td.ilvl = {};
	td.me = {};
	td.mg = {};
	td.spec = {};
	td.gear = {};
	for i=1,40 do
		td.guid[i] = "";
		td.name[i] = "";
		td.ilvl[i] = "";
		td.me[i] = "";
		td.mg[i] = "";
		td.spec[i] = "";
		td.gear[i] = "";
	end
	ountrack=true;
	OTCurrent=""; -- current raid frame
	OTCurrent2=""; -- current unit id
	OTCurrent3=""; -- current raid frame number
	OILVL_Unit="";
	if IsInRaid() then
		rnum = GetNumGroupMembers();
		if rnum < 16 then
			OIVLFRAME:SetWidth(400);
		end		
		if rnum >= 16 and rnum <= 20 then
			OIVLFRAME:SetWidth(400);
		end
		if rnum >= 21 and rnum <= 25 then
			OIVLFRAME:SetWidth(430);
		end
		if rnum >= 26 and rnum <= 30 then
			OIVLFRAME:SetWidth(512);
		end
		if rnum >= 31 and rnum <= 35 then
			OIVLFRAME:SetWidth(594);
		end
		if rnum >= 36 and rnum <= 40 then
			OIVLFRAME:SetWidth(676);
		end

		for j=1, rnum do
			for i=1, 40 do
				if oilvlframedata.guid[i] == "" then break end
				if UnitGUID("raid"..j) == oilvlframedata.guid[i] then
					td.guid[j] = oilvlframedata.guid[i];
					td.name[j] = oilvlframedata.name[i];
					td.ilvl[j] = oilvlframedata.ilvl[i];
					td.me[j] = oilvlframedata.me[i];
					td.mg[j] = oilvlframedata.mg[i];
					td.spec[j] = oilvlframedata.spec[i];
					td.gear[j] = oilvlframedata.gear[i];
					break;
				end
			end
			if td.guid[j] == "" then
				td.guid[j] = UnitGUID("raid"..j);
				td.name[j] = GetUnitName("raid"..j,""):gsub("%-.+", "");
				td.ilvl[j] = "";
				td.me[j] = "";
				td.spec[j] = "";
				td.gear[j] = "";
			end
		end

		for i = rnum+1, 40 do
			if not _G["OILVLRAIDFRAME"..i]  then break; end
			_G["OILVLRAIDFRAME"..i]:SetText("");
			_G["OILVLRAIDFRAME"..i]:Hide();
			oilvlframedata.guid[i] = "";
			oilvlframedata.name[i] = "";
			oilvlframedata.ilvl[i] = "";
			oilvlframedata.me[i] = "";
			oilvlframedata.mg[i] = "";
			oilvlframedata.spec[i] = "";
			oilvlframedata.gear[i] = "";
		end
		NumRole["TANK"] = 0;
		NumRole["DAMAGER"] = 0;
		NumRole["HEALER"] = 0;
		for i = 1, rnum do
			if not _G["OILVLRAIDFRAME"..i]  then break; end
			_G["OILVLRAIDFRAME"..i]:SetText(oClassColor("raid"..i)..td.name[i].."\n|r|cFF00FF00"..td.ilvl[i]);
			_G["OILVLRAIDFRAME"..i]:Show();
			OilvlSetRole(i, UnitGroupRolesAssigned("raid"..i,""));
			local _, rank, _, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(i)
			OilvlSetRank(i, rank);
			oilvlframedata.guid[i] = td.guid[i];
			oilvlframedata.name[i] = td.name[i];
			oilvlframedata.ilvl[i] = td.ilvl[i];
			oilvlframedata.me[i] = td.me[i];
			oilvlframedata.mg[i] = td.mg[i];
			oilvlframedata.spec[i] = td.spec[i];
			oilvlframedata.gear[i] = td.gear[i];
			OilvlSetMouseoverTooltips(_G["OILVLRAIDFRAME"..i], "raid"..i);
		end
	elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		rnum = GetNumGroupMembers(LE_PARTY_CATEGORY_INSTANCE) - 1		
		if rnum > 0 then
			for j=1, rnum do
				for i=2, 5 do
					if oilvlframedata.guid[i] == "" then break end
					if UnitGUID("party"..j) == oilvlframedata.guid[i] then
						td.guid[j+1] = oilvlframedata.guid[i];
						td.name[j+1] = oilvlframedata.name[i];
						td.ilvl[j+1] = oilvlframedata.ilvl[i];
						td.me[j+1] = oilvlframedata.me[i];
						td.mg[j+1] = oilvlframedata.mg[i];
						td.spec[j+1] = oilvlframedata.spec[i];
						td.gear[j+1] = oilvlframedata.gear[i];
						break;
					end
				end
				if td.guid[j+1] == "" then
					td.guid[j+1] = UnitGUID("party"..j);
					td.name[j+1] = GetUnitName("party"..j,""):gsub("%-.+", "");
					td.ilvl[j+1] = "";
					td.me[j+1] = "";
					td.spec[j+1] = "";
					td.gear[j+1] = "";
				end
			end
			for i = rnum+1, 40 do
				if not _G["OILVLRAIDFRAME"..i]  then break; end
				_G["OILVLRAIDFRAME"..i]:SetText("");
				_G["OILVLRAIDFRAME"..i]:Hide();
				oilvlframedata.guid[i] = "";
				oilvlframedata.name[i] = "";
				oilvlframedata.ilvl[i] = "";
				oilvlframedata.me[i] = "";
				oilvlframedata.mg[i] = "";
				oilvlframedata.spec[i] = "";
				oilvlframedata.gear[i] = "";
			end
			NumRole["TANK"] = 0;
			NumRole["DAMAGER"] = 0;
			NumRole["HEALER"] = 0;
			OILVLRAIDFRAME1:Show();
			OilvlSetRole(1, UnitGroupRolesAssigned("player"));
			OilvlSetMouseoverTooltips(OILVLRAIDFRAME1, "player");
			if UnitIsGroupLeader("player") then	OilvlSetRank(1, 2);	else OilvlSetRank(1, 0); end
			for i = 2, (rnum+1) do
				if not _G["OILVLRAIDFRAME"..i]  then break; end
				_G["OILVLRAIDFRAME"..i]:SetText(oClassColor("party"..(i-1))..td.name[i].."\n|r|cFF00FF00"..td.ilvl[i]);
				_G["OILVLRAIDFRAME"..i]:Show();
				OilvlSetRole(i, UnitGroupRolesAssigned("party"..(i-1),""));
				if UnitIsGroupLeader("party"..(i-1)) then OilvlSetRank(i, 2); else OilvlSetRank(i, 0); end
				oilvlframedata.guid[i] = td.guid[i];
				oilvlframedata.name[i] = td.name[i];
				oilvlframedata.ilvl[i] = td.ilvl[i];
				oilvlframedata.me[i] = td.me[i];
				oilvlframedata.mg[i] = td.mg[i];
				oilvlframedata.spec[i] = td.spec[i];
				oilvlframedata.gear[i] = td.gear[i];
				OilvlSetMouseoverTooltips(_G["OILVLRAIDFRAME"..i], "party"..(i-1));
			end
			OIVLFRAME:SetWidth(400);
		end
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		rnum = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) - 1
		if rnum > 0 then
			for j=1, rnum do
				for i=2, 5 do
					if oilvlframedata.guid[i] == "" then break end
					if UnitGUID("party"..j) == oilvlframedata.guid[i] then
						td.guid[j+1] = oilvlframedata.guid[i];
						td.name[j+1] = oilvlframedata.name[i];
						td.ilvl[j+1] = oilvlframedata.ilvl[i];
						td.me[j+1] = oilvlframedata.me[i];
						td.mg[j+1] = oilvlframedata.mg[i];
						td.spec[j+1] = oilvlframedata.spec[i];
						td.gear[j+1] = oilvlframedata.gear[i];
						break;
					end
				end
				if td.guid[j+1] == "" then
					td.guid[j+1] = UnitGUID("party"..j);
					td.name[j+1] = GetUnitName("party"..j,""):gsub("%-.+", "");
					td.ilvl[j+1] = "";
					td.me[j+1] = "";
					td.spec[j+1] = "";
					td.gear[j+1] = "";
				end
			end
			for i = rnum+1, 40 do
				if not _G["OILVLRAIDFRAME"..i]  then break; end
				_G["OILVLRAIDFRAME"..i]:SetText("");
				_G["OILVLRAIDFRAME"..i]:Hide();
				oilvlframedata.guid[i] = "";
				oilvlframedata.name[i] = "";
				oilvlframedata.ilvl[i] = "";
				oilvlframedata.me[i] = "";
				oilvlframedata.mg[i] = "";
				oilvlframedata.spec[i] = "";
				oilvlframedata.gear[i] = "";
			end
			NumRole["TANK"] = 0;
			NumRole["DAMAGER"] = 0;
			NumRole["HEALER"] = 0;
			OILVLRAIDFRAME1:Show();
			OilvlSetRole(1, UnitGroupRolesAssigned("player"));
			OilvlSetMouseoverTooltips(OILVLRAIDFRAME1, "player");
			if UnitIsGroupLeader("player") then	OilvlSetRank(1, 2);	else OilvlSetRank(1, 0); end
			for i = 2, (rnum+1) do
				if not _G["OILVLRAIDFRAME"..i]  then break; end
				_G["OILVLRAIDFRAME"..i]:SetText(oClassColor("party"..(i-1))..td.name[i].."\n|r|cFF00FF00"..td.ilvl[i]);
				_G["OILVLRAIDFRAME"..i]:Show();
				OilvlSetRole(i, UnitGroupRolesAssigned("party"..(i-1),""));
				if UnitIsGroupLeader("party"..(i-1)) then OilvlSetRank(i, 2); else OilvlSetRank(i, 0); end
				oilvlframedata.guid[i] = td.guid[i];
				oilvlframedata.name[i] = td.name[i];
				oilvlframedata.ilvl[i] = td.ilvl[i];
				oilvlframedata.me[i] = td.me[i];
				oilvlframedata.mg[i] = td.mg[i];
				oilvlframedata.spec[i] = td.spec[i];
				oilvlframedata.gear[i] = td.gear[i];
				OilvlSetMouseoverTooltips(_G["OILVLRAIDFRAME"..i], "party"..(i-1));
			end
			OIVLFRAME:SetWidth(400);
		end
	else
		OIVLFRAME:SetWidth(400);
		for i = 2, 40 do
			if not _G["OILVLRAIDFRAME"..i]  then break; end
			_G["OILVLRAIDFRAME"..i]:SetText("");
			_G["OILVLRAIDFRAME"..i]:Hide();
			oilvlframedata.guid[i] = "";
			oilvlframedata.name[i] = "";
			oilvlframedata.ilvl[i] = "";
			oilvlframedata.me[i] = "";
			oilvlframedata.mg[i] = "";
			oilvlframedata.spec[i] = "";
			oilvlframedata.gear[i] = "";
		end
		NumRole["TANK"] = 0;
		NumRole["DAMAGER"] = 0;
		NumRole["HEALER"] = 0;
		OILVLRAIDFRAME1:SetText(oClassColor("player")..GetUnitName("player",""):gsub("%-.+", ""));
		OilvlSetRole(1, UnitGroupRolesAssigned("player"));
		OilvlSetRank(1, 0);
		OIVLFRAME:SetWidth(400);
		oilvlframedata.guid[1] = UnitGUID("player");
		oilvlframedata.name[1] = GetUnitName("player",""):gsub("%-.+", "");
		oilvlframedata.ilvl[1] = "";
		oilvlframedata.me[1] = "";
		oilvlframedata.mg[1] = "";
		oilvlframedata.spec[1] = "";
		oilvlframedata.gear[1] = "";
		OilvlSetMouseoverTooltips(OILVLRAIDFRAME1, "player");
	end
end
	ountrack=true; OTCurrent=""; OTCurrent2=""; OTCurrent3="";
end

local function round(number, digits)
    return tonumber(string.format("%." .. (digits or 0) .. "f", number))
end

function oilvlcheckrange()
if not UnitAffectingCombat("player") and oilvlframesw then
	local i=0;
	local rnum=0;
	local total=0;
	local n=0;
	local ntank=0;
	local totaltank=0;
	local ndps=0;
	local totaldps=0;
	local nheal=0;
	local totalheal=0;
	ail=0; ailtank=0; aildps=0; ailheal=0;	
	if IsInRaid() then
		rnum = GetNumGroupMembers();
		for i = 1, rnum do
			if not CheckInteractDistance("raid"..i, 1) then
				if OTCurrent2 == "raid"..i then
					miacount=0;	miaunit[1]="";miaunit[2]="";miaunit[3]="";miaunit[4]="";miaunit[5]="";miaunit[6]="";
					ountrack=true; OTCurrent=""; OTCurrent2=""; OTCurrent3=""; OILVL_Unit="";
				end
				local ntex4 = _G["OILVLRAIDFRAME"..i]:CreateTexture()
				ntex4:SetTexture(0,0,0,1)
				ntex4:SetTexCoord(0, 0.625, 0, 0.6875)
				ntex4:SetAllPoints()	
				_G["OILVLRAIDFRAME"..i]:SetNormalTexture(ntex4)
			else
				local ntex4 = _G["OILVLRAIDFRAME"..i]:CreateTexture()
				ntex4:SetTexture(0.2,0.2,0.2,0.5)
				ntex4:SetTexCoord(0, 0.625, 0, 0.6875)
				ntex4:SetAllPoints()	
				_G["OILVLRAIDFRAME"..i]:SetNormalTexture(ntex4)					
			end
			
			if oilvlframedata.ilvl[i] ~= "" then 
				n = n + 1;
				total = total + oilvlframedata.ilvl[i];
				if oilvlframedata.role[i] == "TANK" then
					ntank = ntank + 1;
					totaltank = totaltank + oilvlframedata.ilvl[i];
				end
				if oilvlframedata.role[i] == "DAMAGER" then
					ndps = ndps + 1;
					totaldps = totaldps + oilvlframedata.ilvl[i];
				end
				if oilvlframedata.role[i] == "HEALER" then
					nheal = nheal + 1;
					totalheal = totalheal + oilvlframedata.ilvl[i];
				end
			end
		end
	elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		rnum = GetNumGroupMembers(LE_PARTY_CATEGORY_INSTANCE) - 1
		for i = 1, rnum do
			if not CheckInteractDistance("party"..i, 1) then 
				if OTCurrent2 == "party"..i then
					miacount=0;	miaunit[1]="";miaunit[2]="";miaunit[3]="";miaunit[4]="";miaunit[5]="";miaunit[6]="";
					ountrack=true; OTCurrent=""; OTCurrent2=""; OTCurrent3=""; OILVL_Unit="";
				end
				local ntex4 = _G["OILVLRAIDFRAME"..(i+1)]:CreateTexture()
				ntex4:SetTexture(0,0,0,1)
				ntex4:SetTexCoord(0, 0.625, 0, 0.6875)
				ntex4:SetAllPoints()	
				_G["OILVLRAIDFRAME"..(i+1)]:SetNormalTexture(ntex4)	
			else
				local ntex4 = _G["OILVLRAIDFRAME"..(i+1)]:CreateTexture()
				ntex4:SetTexture(0.2,0.2,0.2,0.5)
				ntex4:SetTexCoord(0, 0.625, 0, 0.6875)
				ntex4:SetAllPoints()	
				_G["OILVLRAIDFRAME"..(i+1)]:SetNormalTexture(ntex4)	
			end
		end
		for i = 1, rnum + 1 do
			if oilvlframedata.ilvl[i] ~= "" then 
				n = n + 1;
				total = total + oilvlframedata.ilvl[i];
				if oilvlframedata.role[i] == "TANK" then
					ntank = ntank + 1;
					totaltank = totaltank + oilvlframedata.ilvl[i];
				end
				if oilvlframedata.role[i] == "DAMAGER" then
					ndps = ndps + 1;
					totaldps = totaldps + oilvlframedata.ilvl[i];
				end
				if oilvlframedata.role[i] == "HEALER" then
					nheal = nheal + 1;
					totalheal = totalheal + oilvlframedata.ilvl[i];
				end
			end			
		end
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then		
		rnum = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) - 1
		for i = 1, rnum do
			if not CheckInteractDistance("party"..i, 1) then 
				if OTCurrent2 == "party"..i then
					miacount=0;	miaunit[1]="";miaunit[2]="";miaunit[3]="";miaunit[4]="";miaunit[5]="";miaunit[6]="";
					ountrack=true; OTCurrent=""; OTCurrent2=""; OTCurrent3=""; OILVL_Unit="";
				end
				local ntex4 = _G["OILVLRAIDFRAME"..(i+1)]:CreateTexture()
				ntex4:SetTexture(0,0,0,1)
				ntex4:SetTexCoord(0, 0.625, 0, 0.6875)
				ntex4:SetAllPoints()	
				_G["OILVLRAIDFRAME"..(i+1)]:SetNormalTexture(ntex4)	
			else
				local ntex4 = _G["OILVLRAIDFRAME"..(i+1)]:CreateTexture()
				ntex4:SetTexture(0.2,0.2,0.2,0.5)
				ntex4:SetTexCoord(0, 0.625, 0, 0.6875)
				ntex4:SetAllPoints()	
				_G["OILVLRAIDFRAME"..(i+1)]:SetNormalTexture(ntex4)	
			end
		end
		for i = 1, rnum + 1 do
			if oilvlframedata.ilvl[i] ~= "" then 
				n = n + 1;
				total = total + oilvlframedata.ilvl[i];
				if oilvlframedata.role[i] == "TANK" then
					ntank = ntank + 1;
					totaltank = totaltank + oilvlframedata.ilvl[i];
				end
				if oilvlframedata.role[i] == "DAMAGER" then
					ndps = ndps + 1;
					totaldps = totaldps + oilvlframedata.ilvl[i];
				end
				if oilvlframedata.role[i] == "HEALER" then
					nheal = nheal + 1;
					totalheal = totalheal + oilvlframedata.ilvl[i];
				end
			end			
		end
	end
	if OTCurrent ~= "" then
		local htex4 = _G[OTCurrent]:CreateTexture()
		htex4:SetTexture(0,1,1,0.5)
		htex4:SetTexCoord(0, 0.625, 0, 0.6875)
		htex4:SetAllPoints()
		_G[OTCurrent]:SetNormalTexture(htex4)	
	end
	if ountrack and not UnitAffectingCombat("player") then
		Oilvltimer:ScheduleTimer(OILVLCheckUpdate,1);
	end
	if OILVL_Unit ~= "" then ORfbIlvl(OTCurrent3); end

	-- Calculate Average Item Level
	if IsInRaid() or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInGroup(LE_PARTY_CATEGORY_HOME) then
		ONumTank:Show(); ONumDPS:Show(); ONumHeal:Show();
		if(n ~= 0) then ail = round(total/n,1); end
		if(ntank ~= 0) then ailtank = round(totaltank/ntank,1); end
		if(ndps ~= 0) then aildps = round(totaldps/ndps,1); end
		if(nheal ~= 0) then ailheal = round(totalheal/nheal,1); end
		if ail then
			OilvlAIL:SetText(L["Average Item Level"]..": "..ail);
			LDB.text = ail
		else
			OilvlAIL:SetText(L["Average Item Level"]..": 0");
			LDB.text = ""
			ail = 0;
		end
		if ailtank then
			OilvlAIL_TANK:SetText(NumRole["TANK"].." ("..ailtank..")");
		else
			OilvlAIL_TANK:SetText(NumRole["TANK"]);
			ailtank = 0;
		end
		if aildps then
			OilvlAIL_DPS:SetText(NumRole["DAMAGER"].." ("..aildps..")");
		else
			OilvlAIL_DPS:SetText(NumRole["DAMAGER"]);
			aildps = 0;
		end
		if ailheal then
			OilvlAIL_HEAL:SetText(NumRole["HEALER"].." ("..ailheal..")");
		else
			OilvlAIL_HEAL:SetText(NumRole["HEALER"]);
			ailheal = 0;
		end
	else
		ONumTank:Hide(); ONumDPS:Hide(); ONumHeal:Hide();
		OilvlAIL:SetText(L["Average Item Level"]..": "..oilvlframedata.ilvl[1]);
		LDB.text = oilvlframedata.ilvl[1]
		ail = oilvlframedata.ilvl[1];
		OilvlAIL_TANK:SetText(""); OilvlAIL_DPS:SetText(""); OilvlAIL_HEAL:SetText("");
	end
end
end

function OCheckSendMark()
	for i = 1, 40 do
		if not _G["OILVLRAIDFRAME"..i]:IsShown() then
			break;
		end
		if _G["Oilvlmark"..i]:IsVisible() then
			return true;
		end
	end
	return false
end

function OResetSendMark()
	for i = 1, 40 do
		if _G["OILVLRAIDFRAME"..i] == nil then return -1 end
		_G["Oilvlmark"..i]:Hide();
	end
end

function OSendToTarget(button)
	local i=0;local q=0;
	if not UnitExists("target") then 
		return -1;
	end
	local comp = {};
	SendChatMessage(L["Item Level"]..":", "WHISPER", nil, UnitName("target"));
	if not OCheckSendMark() then
		for i = 1, 40 do
			if not _G["OILVLRAIDFRAME"..i]:IsShown() then
				break;
			end
			local msg = _G["OILVLRAIDFRAME"..i]:GetText();
			if msg == nil then
				break;
			end			
			msg = msg:sub(11);
			msg = msg:gsub("\n|r|cFF00FF00",": ");
			if cfg.oilvlme and oilvlframedata.me[i][1] and oilvlframedata.me[i][1] ~= "" then
				msg = msg.." ("..ENSCRIBE.." "..oilvlframedata.me[i][1]..")";
			end
			if cfg.oilvlme and oilvlframedata.mg[i][1] and oilvlframedata.mg[i][1] ~= "" then
				msg = msg.." ("..L["Gem"].." "..oilvlframedata.mg[i][1]..")";
			end
			if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.me[i][2] and oilvlframedata.me[i][2] ~= "" then
				msg = msg.." ("..LOW.." "..ENSCRIBE..": "..oilvlframedata.me[i][2]..")";
			end
			if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.mg[i][2] and oilvlframedata.mg[i][2] ~= "" then
				msg = msg.." ("..LOW.." "..L["Gem"]..": "..oilvlframedata.mg[i][2]..")";
			end
			if button == "MiddleButton" then
				if (msg:sub(1,1) == "!") or (msg:sub(1,1) == "~") then
					q = q + 1;
					comp[q] = {ilvl = oilvlframedata.ilvl[i], mmsg = msg}
				end
			else
				comp[i] = {ilvl = oilvlframedata.ilvl[i], mmsg = msg}
			end
		end
		sort(comp, function(a,b)
			if tonumber(a.ilvl) == nil then return false end
			if tonumber(b.ilvl) == nil and tonumber(a.ilvl) == nil then return false end
			if tonumber(b.ilvl) == nil and tonumber(a.ilvl) ~= nil then return true end
			return tonumber(a.ilvl) > tonumber(b.ilvl) 
		end)
		if button ~= "RightButton" then 
			for _, info in ipairs(comp) do  SendChatMessage(info.mmsg, "WHISPER", nil, UnitName("target")) end
		end
		if button ~= "MiddleButton" then
			SendChatMessage(L["Average Item Level"].."("..NumRole["TANK"].." "..TANK.."): "..ailtank, "WHISPER", nil, UnitName("target"));
			SendChatMessage(L["Average Item Level"].."("..NumRole["HEALER"].." "..HEALER.."): "..ailheal, "WHISPER", nil, UnitName("target"));
			SendChatMessage(L["Average Item Level"].."("..NumRole["DAMAGER"].." "..DAMAGER.."): "..aildps, "WHISPER", nil, UnitName("target"));
			SendChatMessage(L["Average Item Level"]..": "..ail, "WHISPER", nil, UnitName("target"));
		end
	else
		for i = 1, 40 do
			if not _G["OILVLRAIDFRAME"..i]:IsShown() then
				break;
			end
			if _G["Oilvlmark"..i]:IsVisible() then
				local msg = _G["OILVLRAIDFRAME"..i]:GetText();
				if msg == nil then
					break;
				end		
				msg = msg:sub(11);
				msg = msg:gsub("\n|r|cFF00FF00",": ");
				if cfg.oilvlme and oilvlframedata.me[i][1] and oilvlframedata.me[i][1] ~= "" then
					msg = msg.." ("..ENSCRIBE.." "..oilvlframedata.me[i][1]..")";
				end
				if cfg.oilvlme and oilvlframedata.mg[i][1] and oilvlframedata.mg[i][1] ~= "" then
					msg = msg.." ("..L["Gem"].." "..oilvlframedata.mg[i][1]..")";
				end
				if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.me[i][2] and oilvlframedata.me[i][2] ~= "" then
					msg = msg.." ("..LOW.." "..ENSCRIBE..": "..oilvlframedata.me[i][2]..")";
				end
				if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.mg[i][2] and oilvlframedata.mg[i][2] ~= "" then
					msg = msg.." ("..LOW.." "..L["Gem"]..": "..oilvlframedata.mg[i][2]..")";
				end
				SendChatMessage(msg, "WHISPER", nil, UnitName("target"));
			end
		end		
	end
end

function OSendToParty(button)
	local i=0;local q=0;
	local comp = {};
	SendChatMessage(L["Item Level"]..":", "PARTY");
	if not OCheckSendMark() then
		for i = 1, 40 do
			if not _G["OILVLRAIDFRAME"..i]:IsShown() then
				break;
			end
			local msg = _G["OILVLRAIDFRAME"..i]:GetText();
			if msg == nil then
				break;
			end		
			msg = msg:sub(11);
			msg = msg:gsub("\n|r|cFF00FF00",": ");
			if cfg.oilvlme and oilvlframedata.me[i][1] and oilvlframedata.me[i][1] ~= "" then
				msg = msg.." ("..ENSCRIBE.." "..oilvlframedata.me[i][1]..")";
			end
			if cfg.oilvlme and oilvlframedata.mg[i][1] and oilvlframedata.mg[i][1] ~= "" then
				msg = msg.." ("..L["Gem"].." "..oilvlframedata.mg[i][1]..")";
			end
			if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.me[i][2] and oilvlframedata.me[i][2] ~= "" then
				msg = msg.." ("..LOW.." "..ENSCRIBE..": "..oilvlframedata.me[i][2]..")";
			end
			if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.mg[i][2] and oilvlframedata.mg[i][2] ~= "" then
				msg = msg.." ("..LOW.." "..L["Gem"]..": "..oilvlframedata.mg[i][2]..")";
			end
			if button == "MiddleButton" then
				if (msg:sub(1,1) == "!") or (msg:sub(1,1) == "~") then
					q = q + 1;
					comp[q] = {ilvl = oilvlframedata.ilvl[i], mmsg = msg}
				end
			else
				comp[i] = {ilvl = oilvlframedata.ilvl[i], mmsg = msg}
			end
		end
		sort(comp, function(a,b)
			if tonumber(a.ilvl) == nil then return false end
			if tonumber(b.ilvl) == nil and tonumber(a.ilvl) == nil then return false end
			if tonumber(b.ilvl) == nil and tonumber(a.ilvl) ~= nil then return true end
			return tonumber(a.ilvl) > tonumber(b.ilvl) 
		end)
		if button ~= "RightButton" then 
			for _, info in ipairs(comp) do  SendChatMessage(info.mmsg, "PARTY") end
		end
		if button ~= "MiddleButton" then
			SendChatMessage(L["Average Item Level"].."("..NumRole["TANK"].." "..TANK.."): "..ailtank, "PARTY");
			SendChatMessage(L["Average Item Level"].."("..NumRole["HEALER"].." "..HEALER.."): "..ailheal, "PARTY");
			SendChatMessage(L["Average Item Level"].."("..NumRole["DAMAGER"].." "..DAMAGER.."): "..aildps, "PARTY");
			SendChatMessage(L["Average Item Level"]..": "..ail, "PARTY");
		end
	else
		for i = 1, 40 do
			if not _G["OILVLRAIDFRAME"..i]:IsShown() then
				break;
			end
			if _G["Oilvlmark"..i]:IsVisible() then
				local msg = _G["OILVLRAIDFRAME"..i]:GetText();
				if msg == nil then
					break;
				end		
				msg = msg:sub(11);
				msg = msg:gsub("\n|r|cFF00FF00",": ");
				if cfg.oilvlme and oilvlframedata.me[i][1] and oilvlframedata.me[i][1] ~= "" then
					msg = msg.." ("..ENSCRIBE.." "..oilvlframedata.me[i][1]..")";
				end
				if cfg.oilvlme and oilvlframedata.mg[i][1] and oilvlframedata.mg[i][1] ~= "" then
					msg = msg.." ("..L["Gem"].." "..oilvlframedata.mg[i][1]..")";
				end
				if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.me[i][2] and oilvlframedata.me[i][2] ~= "" then
					msg = msg.." ("..LOW.." "..ENSCRIBE..": "..oilvlframedata.me[i][2]..")";
				end
				if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.mg[i][2] and oilvlframedata.mg[i][2] ~= "" then
					msg = msg.." ("..LOW.." "..L["Gem"]..": "..oilvlframedata.mg[i][2]..")";
				end
				SendChatMessage(msg, "PARTY");
			end
		end		
	end
end

function OSendToInstance(button)
	local i=0;local q=0;
	local comp = {};
	SendChatMessage(L["Item Level"]..":", "INSTANCE_CHAT");
	if not OCheckSendMark() then
		for i = 1, 40 do
			if not _G["OILVLRAIDFRAME"..i]:IsShown() then
				break;
			end
			local msg = _G["OILVLRAIDFRAME"..i]:GetText();
			if msg == nil then
				break;
			end		
			msg = msg:sub(11);
			msg = msg:gsub("\n|r|cFF00FF00",": ");
			if cfg.oilvlme and oilvlframedata.me[i][1] and oilvlframedata.me[i][1] ~= "" then
				msg = msg.." ("..ENSCRIBE.." "..oilvlframedata.me[i][1]..")";
			end
			if cfg.oilvlme and oilvlframedata.mg[i][1] and oilvlframedata.mg[i][1] ~= "" then
				msg = msg.." ("..L["Gem"].." "..oilvlframedata.mg[i][1]..")";
			end
			if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.me[i][2] and oilvlframedata.me[i][2] ~= "" then
				msg = msg.." ("..LOW.." "..ENSCRIBE..": "..oilvlframedata.me[i][2]..")";
			end
			if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.mg[i][2] and oilvlframedata.mg[i][2] ~= "" then
				msg = msg.." ("..LOW.." "..L["Gem"]..": "..oilvlframedata.mg[i][2]..")";
			end
			if button == "MiddleButton" then
				if (msg:sub(1,1) == "!") or (msg:sub(1,1) == "~") then
					q = q + 1;
					comp[q] = {ilvl = oilvlframedata.ilvl[i], mmsg = msg}
				end
			else
				comp[i] = {ilvl = oilvlframedata.ilvl[i], mmsg = msg}
			end
		end
		sort(comp, function(a,b)
			if tonumber(a.ilvl) == nil then return false end
			if tonumber(b.ilvl) == nil and tonumber(a.ilvl) == nil then return false end
			if tonumber(b.ilvl) == nil and tonumber(a.ilvl) ~= nil then return true end
			return tonumber(a.ilvl) > tonumber(b.ilvl) 
		end)
		if button ~= "RightButton" then 
			for _, info in ipairs(comp) do  SendChatMessage(info.mmsg, "INSTANCE_CHAT") end
		end
		if button ~= "MiddleButton" then
			SendChatMessage(L["Average Item Level"].."("..NumRole["TANK"].." "..TANK.."): "..ailtank, "INSTANCE_CHAT");
			SendChatMessage(L["Average Item Level"].."("..NumRole["HEALER"].." "..HEALER.."): "..ailheal, "INSTANCE_CHAT");
			SendChatMessage(L["Average Item Level"].."("..NumRole["DAMAGER"].." "..DAMAGER.."): "..aildps, "INSTANCE_CHAT");
			SendChatMessage(L["Average Item Level"]..": "..ail, "INSTANCE_CHAT");
		end
	else
		for i = 1, 40 do
			if not _G["OILVLRAIDFRAME"..i]:IsShown() then
				break;
			end
			if _G["Oilvlmark"..i]:IsVisible() then
				local msg = _G["OILVLRAIDFRAME"..i]:GetText();
				if msg == nil then
					break;
				end		
				msg = msg:sub(11);
				msg = msg:gsub("\n|r|cFF00FF00",": ");
				if cfg.oilvlme and oilvlframedata.me[i][1] and oilvlframedata.me[i][1] ~= "" then
					msg = msg.." ("..ENSCRIBE.." "..oilvlframedata.me[i][1]..")";
				end
				if cfg.oilvlme and oilvlframedata.mg[i][1] and oilvlframedata.mg[i][1] ~= "" then
					msg = msg.." ("..L["Gem"].." "..oilvlframedata.mg[i][1]..")";
				end
				if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.me[i][2] and oilvlframedata.me[i][2] ~= "" then
					msg = msg.." ("..LOW.." "..ENSCRIBE..": "..oilvlframedata.me[i][2]..")";
				end
				if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.mg[i][2] and oilvlframedata.mg[i][2] ~= "" then
					msg = msg.." ("..LOW.." "..L["Gem"]..": "..oilvlframedata.mg[i][2]..")";
				end
				SendChatMessage(msg, "INSTANCE_CHAT");
			end
		end		
	end
end

function OSendToGuild(button)
	local i=0;local q=0;
	local comp = {};
	SendChatMessage(L["Item Level"]..":", "GUILD");
	if not OCheckSendMark() then
		for i = 1, 40 do
			if not _G["OILVLRAIDFRAME"..i]:IsShown() then
				break;
			end
			local msg = _G["OILVLRAIDFRAME"..i]:GetText();
			if msg == nil then
				break;
			end		
			msg = msg:sub(11);
			msg = msg:gsub("\n|r|cFF00FF00",": ");
			if cfg.oilvlme and oilvlframedata.me[i][1] and oilvlframedata.me[i][1] ~= "" then
				msg = msg.." ("..ENSCRIBE.." "..oilvlframedata.me[i][1]..")";
			end
			if cfg.oilvlme and oilvlframedata.mg[i][1] and oilvlframedata.mg[i][1] ~= "" then
				msg = msg.." ("..L["Gem"].." "..oilvlframedata.mg[i][1]..")";
			end
			if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.me[i][2] and oilvlframedata.me[i][2] ~= "" then
				msg = msg.." ("..LOW.." "..ENSCRIBE..": "..oilvlframedata.me[i][2]..")";
			end
			if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.mg[i][2] and oilvlframedata.mg[i][2] ~= "" then
				msg = msg.." ("..LOW.." "..L["Gem"]..": "..oilvlframedata.mg[i][2]..")";
			end
			if button == "MiddleButton" then
				if (msg:sub(1,1) == "!") or (msg:sub(1,1) == "~") then
					q = q + 1;
					comp[q] = {ilvl = oilvlframedata.ilvl[i], mmsg = msg}
				end
			else
				comp[i] = {ilvl = oilvlframedata.ilvl[i], mmsg = msg}
			end
		end
		sort(comp, function(a,b)
			if tonumber(a.ilvl) == nil then return false end
			if tonumber(b.ilvl) == nil and tonumber(a.ilvl) == nil then return false end
			if tonumber(b.ilvl) == nil and tonumber(a.ilvl) ~= nil then return true end
			return tonumber(a.ilvl) > tonumber(b.ilvl) 
		end)
		if button ~= "RightButton" then 
			for _, info in ipairs(comp) do  SendChatMessage(info.mmsg, "GUILD") end
		end
		if button ~= "MiddleButton" then
			SendChatMessage(L["Average Item Level"].."("..NumRole["TANK"].." "..TANK.."): "..ailtank, "GUILD");
			SendChatMessage(L["Average Item Level"].."("..NumRole["HEALER"].." "..HEALER.."): "..ailheal, "GUILD");
			SendChatMessage(L["Average Item Level"].."("..NumRole["DAMAGER"].." "..DAMAGER.."): "..aildps, "GUILD");
			SendChatMessage(L["Average Item Level"]..": "..ail, "GUILD");
		end
	else
		for i = 1, 40 do
			if not _G["OILVLRAIDFRAME"..i]:IsShown() then
				break;
			end
			if _G["Oilvlmark"..i]:IsVisible() then
				local msg = _G["OILVLRAIDFRAME"..i]:GetText();
				if msg == nil then
					break;
				end		
				msg = msg:sub(11);
				msg = msg:gsub("\n|r|cFF00FF00",": ");
				if cfg.oilvlme and oilvlframedata.me[i][1] and oilvlframedata.me[i][1] ~= "" then
					msg = msg.." ("..ENSCRIBE.." "..oilvlframedata.me[i][1]..")";
				end
				if cfg.oilvlme and oilvlframedata.mg[i][1] and oilvlframedata.mg[i][1] ~= "" then
					msg = msg.." ("..L["Gem"].." "..oilvlframedata.mg[i][1]..")";
				end
				if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.me[i][2] and oilvlframedata.me[i][2] ~= "" then
					msg = msg.." ("..LOW.." "..ENSCRIBE..": "..oilvlframedata.me[i][2]..")";
				end
				if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.mg[i][2] and oilvlframedata.mg[i][2] ~= "" then
					msg = msg.." ("..LOW.." "..L["Gem"]..": "..oilvlframedata.mg[i][2]..")";
				end
				SendChatMessage(msg, "GUILD");
			end
		end		
	end
end

function OSendToRaid(button)
	local i=0;local q=0;
	local comp = {};
	SendChatMessage(L["Item Level"]..":", "RAID");
	if not OCheckSendMark() then
		for i = 1, 40 do
			if not _G["OILVLRAIDFRAME"..i]:IsShown() then
				break;
			end
			local msg = _G["OILVLRAIDFRAME"..i]:GetText();
			if msg == nil then
				break;
			end		
			msg = msg:sub(11);
			msg = msg:gsub("\n|r|cFF00FF00",": ");
			if cfg.oilvlme and oilvlframedata.me[i][1] and oilvlframedata.me[i][1] ~= "" then
				msg = msg.." ("..ENSCRIBE.." "..oilvlframedata.me[i][1]..")";
			end
			if cfg.oilvlme and oilvlframedata.mg[i][1] and oilvlframedata.mg[i][1] ~= "" then
				msg = msg.." ("..L["Gem"].." "..oilvlframedata.mg[i][1]..")";
			end
			if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.me[i][2] and oilvlframedata.me[i][2] ~= "" then
				msg = msg.." ("..LOW.." "..ENSCRIBE..": "..oilvlframedata.me[i][2]..")";
			end
			if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.mg[i][2] and oilvlframedata.mg[i][2] ~= "" then
				msg = msg.." ("..LOW.." "..L["Gem"]..": "..oilvlframedata.mg[i][2]..")";
			end
			if button == "MiddleButton" then
				if (msg:sub(1,1) == "!") or (msg:sub(1,1) == "~") then
					q = q + 1;
					comp[q] = {ilvl = oilvlframedata.ilvl[i], mmsg = msg}
				end
			else
				comp[i] = {ilvl = oilvlframedata.ilvl[i], mmsg = msg}
			end
		end
		sort(comp, function(a,b)
			if tonumber(a.ilvl) == nil then return false end
			if tonumber(b.ilvl) == nil and tonumber(a.ilvl) == nil then return false end
			if tonumber(b.ilvl) == nil and tonumber(a.ilvl) ~= nil then return true end
			return tonumber(a.ilvl) > tonumber(b.ilvl) 
		end)
		if button ~= "RightButton" then 
			for _, info in ipairs(comp) do  SendChatMessage(info.mmsg, "RAID") end
		end
		if button ~= "MiddleButton" then
			SendChatMessage(L["Average Item Level"].."("..NumRole["TANK"].." "..TANK.."): "..ailtank, "RAID");
			SendChatMessage(L["Average Item Level"].."("..NumRole["HEALER"].." "..HEALER.."): "..ailheal, "RAID");
			SendChatMessage(L["Average Item Level"].."("..NumRole["DAMAGER"].." "..DAMAGER.."): "..aildps, "RAID");
			SendChatMessage(L["Average Item Level"]..": "..ail, "RAID");
		end
	else
		for i = 1, 40 do
			if not _G["OILVLRAIDFRAME"..i]:IsShown() then
				break;
			end
			if _G["Oilvlmark"..i]:IsVisible() then
				local msg = _G["OILVLRAIDFRAME"..i]:GetText();
				if msg == nil then
					break;
				end		
				msg = msg:sub(11);
				msg = msg:gsub("\n|r|cFF00FF00",": ");
				if cfg.oilvlme and oilvlframedata.me[i][1] and oilvlframedata.me[i][1] ~= "" then
					msg = msg.." ("..ENSCRIBE.." "..oilvlframedata.me[i][1]..")";
				end
				if cfg.oilvlme and oilvlframedata.mg[i][1] and oilvlframedata.mg[i][1] ~= "" then
					msg = msg.." ("..L["Gem"].." "..oilvlframedata.mg[i][1]..")";
				end
				if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.me[i][2] and oilvlframedata.me[i][2] ~= "" then
					msg = msg.." ("..LOW.." "..ENSCRIBE..": "..oilvlframedata.me[i][2]..")";
				end
				if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.mg[i][2] and oilvlframedata.mg[i][2] ~= "" then
					msg = msg.." ("..LOW.." "..L["Gem"]..": "..oilvlframedata.mg[i][2]..")";
				end
				SendChatMessage(msg, "RAID");
			end
		end		
	end
end

function OSendToOfficer(button)
	local i=0;local q=0;
	local comp = {};
	SendChatMessage(L["Item Level"]..":", "OFFICER");
	if not OCheckSendMark() then
		for i = 1, 40 do
			if not _G["OILVLRAIDFRAME"..i]:IsShown() then
				break;
			end
			local msg = _G["OILVLRAIDFRAME"..i]:GetText();
			if msg == nil then
				break;
			end		
			msg = msg:sub(11);
			msg = msg:gsub("\n|r|cFF00FF00",": ");
			if cfg.oilvlme and oilvlframedata.me[i][1] and oilvlframedata.me[i][1] ~= "" then
				msg = msg.." ("..ENSCRIBE.." "..oilvlframedata.me[i][1]..")";
			end
			if cfg.oilvlme and oilvlframedata.mg[i][1] and oilvlframedata.mg[i][1] ~= "" then
				msg = msg.." ("..L["Gem"].." "..oilvlframedata.mg[i][1]..")";
			end
			if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.me[i][2] and oilvlframedata.me[i][2] ~= "" then
				msg = msg.." ("..LOW.." "..ENSCRIBE..": "..oilvlframedata.me[i][2]..")";
			end
			if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.mg[i][2] and oilvlframedata.mg[i][2] ~= "" then
				msg = msg.." ("..LOW.." "..L["Gem"]..": "..oilvlframedata.mg[i][2]..")";
			end
			if button == "MiddleButton" then
				if (msg:sub(1,1) == "!") or (msg:sub(1,1) == "~") then
					q = q + 1;
					comp[q] = {ilvl = oilvlframedata.ilvl[i], mmsg = msg}
				end
			else
				comp[i] = {ilvl = oilvlframedata.ilvl[i], mmsg = msg}
			end
		end
		sort(comp, function(a,b)
			if tonumber(a.ilvl) == nil then return false end
			if tonumber(b.ilvl) == nil and tonumber(a.ilvl) == nil then return false end
			if tonumber(b.ilvl) == nil and tonumber(a.ilvl) ~= nil then return true end
			return tonumber(a.ilvl) > tonumber(b.ilvl) 
		end)
		if button ~= "RightButton" then 
			for _, info in ipairs(comp) do  SendChatMessage(info.mmsg, "OFFICER") end
		end
		if button ~= "MiddleButton" then
			SendChatMessage(L["Average Item Level"].."("..NumRole["TANK"].." "..TANK.."): "..ailtank, "OFFICER");
			SendChatMessage(L["Average Item Level"].."("..NumRole["HEALER"].." "..HEALER.."): "..ailheal, "OFFICER");
			SendChatMessage(L["Average Item Level"].."("..NumRole["DAMAGER"].." "..DAMAGER.."): "..aildps, "OFFICER");
			SendChatMessage(L["Average Item Level"]..": "..ail, "OFFICER");
		end
	else
		for i = 1, 40 do
			if not _G["OILVLRAIDFRAME"..i]:IsShown() then
				break;
			end
			if _G["Oilvlmark"..i]:IsVisible() then
				local msg = _G["OILVLRAIDFRAME"..i]:GetText();
				if msg == nil then
					break;
				end		
				msg = msg:sub(11);
				msg = msg:gsub("\n|r|cFF00FF00",": ");
				if cfg.oilvlme and oilvlframedata.me[i][1] and oilvlframedata.me[i][1] ~= "" then
					msg = msg.." ("..ENSCRIBE.." "..oilvlframedata.me[i][1]..")";
				end
				if cfg.oilvlme and oilvlframedata.mg[i][1] and oilvlframedata.mg[i][1] ~= "" then
					msg = msg.." ("..L["Gem"].." "..oilvlframedata.mg[i][1]..")";
				end
				if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.me[i][2] and oilvlframedata.me[i][2] ~= "" then
					msg = msg.." ("..LOW.." "..ENSCRIBE..": "..oilvlframedata.me[i][2]..")";
				end
				if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.mg[i][2] and oilvlframedata.mg[i][2] ~= "" then
					msg = msg.." ("..LOW.." "..L["Gem"]..": "..oilvlframedata.mg[i][2]..")";
				end
				SendChatMessage(msg, "OFFICER");
			end
		end		
	end
end

local function CopyEditBox(cname, cx, cy, cw, ch)
	local f = CreateFrame("ScrollFrame", cname.."Frame",UIParent,"UIPanelScrollFrameTemplate")
	f:SetPoint("CENTER", cx, cy)
	f:SetSize(cw+10,ch+10)
	f:SetFrameStrata("HIGH");
	f:SetMovable(true);
	f:EnableMouse(true);
	f:RegisterForDrag("LeftButton");
	f:SetScript("OnDragStart", f.StartMoving);
	f:SetScript("OnDragStop", function() f:StopMovingOrSizing();  end);
	
	local g = CreateFrame("EditBox", cname, f, InputBoxTemplate)
	g:SetAutoFocus(true)
	g:SetWidth(cw)
	g:SetHeight(20)	
	g:SetMultiLine(true)
	g:SetScript("OnEscapePressed", function(self) 
		_G[cname.."Frame"]:Hide();
		_G[cname.."_bodyBackground"]:Hide();
	end)
	g:SetFontObject("ChatFontNormal")
	f:SetScrollChild(g)
	g:SetCursorPosition(0);
	f:Hide();

	h = CreateFrame("Button", cname.."_bodyBackground", UIParent)
	h:SetPoint("BOTTOMLEFT", f, -10,-10)
	h:SetPoint("TOPRIGHT", f, 27,10)
	h:SetBackdrop({
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16
	})
	h:Hide();
	local gg = CreateFrame("Button", nil, g)
	gg:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up.blp")
	gg:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down.blp")
	gg:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight.blp")
	gg:SetWidth(30)
	gg:SetHeight(30)
	gg:SetPoint("TOPRIGHT", g, "TOPRIGHT", 15, 5)
	gg:SetScript("OnClick", function(self) OIlvlCopyEB_bodyBackground:Hide(); OIlvlCopyEBFrame:Hide() end)	
end
	
local function CopyEditBox2(cname, cx, cy, cw, ch, cbfunc)
	local f=CreateFrame("frame",cname,UIParent);
	f:SetWidth(cw+10); f:SetHeight(ch+10);
	f:SetPoint("CENTER",cx,cy);
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16
	})
	f:SetFrameStrata("HIGH");
	f:SetMovable(true);
	f:EnableMouse(true);
	f:RegisterForDrag("LeftButton");
	f:SetScript("OnDragStart", f.StartMoving);
	f:SetScript("OnDragStop", function() f:StopMovingOrSizing(); end);
	tinsert(UISpecialFrames,cname);
	f:Hide();
	
	local fsc = CreateFrame("ScrollingMessageFrame",cname.."Frame",f);
	fsc:SetWidth(cw); fsc:SetHeight(ch);
	fsc:SetPoint("TOPLEFT",f,10,-10);
	fsc:SetFontObject("ChatFontNormal")
	fsc:SetJustifyH("LEFT")
	fsc:SetFading(false)
	fsc:SetMaxLines(18)
	fsc:SetHyperlinksEnabled(true) 
	fsc:SetInsertMode("TOP")
	fsc:SetScript("OnHyperlinkEnter", function(self,linkData,link)
		OilvlInspectTooltip:SetOwner(f, "ANCHOR_NONE");
		OilvlInspectTooltip:SetPoint("TOPLEFT",f,"TOPRIGHT",0,0)
		OilvlInspectTooltip:ClearLines()
		OilvlInspectTooltip:SetHyperlink(link)
	end
	)
	fsc:SetScript("OnHyperlinkClick", function(self, linkData, link, button)
		if IsShiftKeyDown() then
			local chatWindow = ChatEdit_GetActiveWindow()
			if chatWindow then
				chatWindow:Insert(link)
			end
		end	
		if IsControlKeyDown() then
			DressUpItemLink(link)
		end
	end
	)
	fsc:SetScript("OnHyperlinkLeave", function(self,linkData,link) OilvlInspectTooltip:Hide() end)
	local g = CreateFrame("Button", nil, f)
	g:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up.blp")
	g:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down.blp")
	g:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight.blp")
	g:SetWidth(30)
	g:SetHeight(30)
	g:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)
	g:SetScript("OnClick", cbfunc)	
end

function oilvlminbutton(parent, mname, func, x,y)
	local g = CreateFrame("Button", mname, parent)
	g:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up.blp")
	g:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down.blp")
	g:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight.blp")
	g:SetWidth(30)
	g:SetHeight(30)
	g:SetPoint("TOPRIGHT", parent, "TOPRIGHT", x, y)
	g:SetScript("OnClick", func)	
end
	
CopyEditBox("OIlvlCopyEB", 0, 250, 500, 300)
CopyEditBox2("OIlvlInspect", 0, 250, 400, 250, function(self) OIlvlInspect:Hide() end)
CopyEditBox2("OIlvlInspect2", 0, -10, 400, 250, function(self) OIlvlInspect2:Hide() end)

local function obfbutton2(btnName, btnText, btnParent, btnTemplate, btnPoint, btnX, btnY, btnW, btnH, btnFunc)
	local button = CreateFrame("Button", btnName, btnParent, btnTemplate)
	button:SetPoint(btnPoint, btnX, btnY)
	button:SetWidth(btnW)
	button:SetHeight(btnH)
	
	button:SetText(btnText)
	button:SetNormalFontObject("GameFontNormal")
	
	local ntex = button:CreateTexture()
	ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
	ntex:SetTexCoord(0, 0.625, 0, 0.6875)
	ntex:SetAllPoints()	
	button:SetNormalTexture(ntex)
	
	local htex = button:CreateTexture()
	htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
	htex:SetTexCoord(0, 0.625, 0, 0.6875)
	htex:SetAllPoints()
	button:SetHighlightTexture(htex)

	button:RegisterForClicks("LeftButtonDown");
	button:SetScript("OnClick", btnFunc);
	button:SetFrameStrata("TOOLTIP")
end

function OSendToCopy(button)
	local i=0;local q=0;
	local comp = {};
	local ebmsg="";
	ebmsg = L["Item Level"]..":";
	for i = 1, 40 do
		if not _G["OILVLRAIDFRAME"..i]:IsShown() then
			break;
		end
		local msg = oilvlframedata.name[i]..":"..oilvlframedata.ilvl[i];
		if cfg.oilvlme and oilvlframedata.me[i][1] and oilvlframedata.me[i][1] ~= "" then
			msg = msg.." ("..ENSCRIBE.." "..oilvlframedata.me[i][1]..")";
		end
		if cfg.oilvlme and oilvlframedata.mg[i][1] and oilvlframedata.mg[i][1] ~= "" then
			msg = msg.." ("..L["Gem"].." "..oilvlframedata.mg[i][1]..")";
		end
		if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.me[i][2] and oilvlframedata.me[i][2] ~= "" then
			msg = msg.." ("..LOW.." "..ENSCRIBE..": "..oilvlframedata.me[i][2]..")";
		end
		if cfg.oilvlme and cfg.oilvlme2 and oilvlframedata.mg[i][2] and oilvlframedata.mg[i][2] ~= "" then
			msg = msg.." ("..LOW.." "..L["Gem"]..": "..oilvlframedata.mg[i][2]..")";
		end
		if button == "MiddleButton" then
			if (msg:sub(1,1) == "!") or (msg:sub(1,1) == "~") then
				q = q + 1;
				comp[q] = {ilvl = oilvlframedata.ilvl[i], mmsg = msg}
			end
		else
			comp[i] = {ilvl = oilvlframedata.ilvl[i], mmsg = msg}
		end
	end

	sort(comp, function(a,b)
		if tonumber(a.ilvl) == nil then return false end
		if tonumber(b.ilvl) == nil and tonumber(a.ilvl) == nil then return false end
		if tonumber(b.ilvl) == nil and tonumber(a.ilvl) ~= nil then return true end
		return tonumber(a.ilvl) > tonumber(b.ilvl) 
	end)
	if button ~= "RightButton" then 
		for _, info in ipairs(comp) do  ebmsg = ebmsg.."\n"..info.mmsg end
	end
	if button ~= "MiddleButton" then
		ebmsg = ebmsg.."\n"..L["Average Item Level"].."("..NumRole["TANK"].." "..TANK.."): "..ailtank;
		ebmsg = ebmsg.."\n"..L["Average Item Level"].."("..NumRole["HEALER"].." "..HEALER.."): "..ailheal;
		ebmsg = ebmsg.."\n"..L["Average Item Level"].."("..NumRole["DAMAGER"].." "..DAMAGER.."): "..aildps;
		ebmsg = ebmsg.."\n"..L["Average Item Level"]..": "..ail;
	end
	OIlvlCopyEB:SetText(ebmsg);
	OIlvlCopyEB:HighlightText(0)
	OIlvlCopyEBFrame:Show();
	OIlvlCopyEB_bodyBackground:Show();
	OIlvlCopyEBFrame:SetVerticalScroll(OIlvlCopyEBFrame:GetVerticalScrollRange())
end

function oilvlbutton(btnName, btnText, btnParent, btnTemplate, btnPoint, btnX, btnY, btnW, btnH, btnFunc)
	local button = CreateFrame("Button", btnName, btnParent, btnTemplate)
	button:SetPoint(btnPoint, btnX, btnY)
	button:SetWidth(btnW)
	button:SetHeight(btnH)
	
	button:SetText(btnText)
	button:SetNormalFontObject("GameFontNormal")
	
	local ntex = button:CreateTexture()
	ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
	ntex:SetTexCoord(0, 0.625, 0, 0.6875)
	ntex:SetAllPoints()	
	button:SetNormalTexture(ntex)
	
	local htex = button:CreateTexture()
	htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
	htex:SetTexCoord(0, 0.625, 0, 0.6875)
	htex:SetAllPoints()
	button:SetHighlightTexture(htex)
	
	local ptex = button:CreateTexture()
	ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
	ptex:SetTexCoord(0, 0.625, 0, 0.6875)
	ptex:SetAllPoints()
	button:SetPushedTexture(ptex)

	button:RegisterForClicks("LeftButtonDown","MiddleButtonDown","RightButtonDown");
	button:SetScript("OnClick", btnFunc);
end

function OPvPButton(btnParent)
	local button = CreateFrame("Button", "OPvPBtn", btnParent)
	button:SetPoint("TOPLEFT", 65, -38)
	button:SetWidth(20)
	button:SetHeight(20)
	
	local ntex = button:CreateTexture(nil, "BACKGROUND")
	ntex:SetSize(20,20);
	ntex:SetPoint("CENTER",-1,1);
	ntex:SetTexture(OPvP[1])
	ntex:SetTexCoord(OPvP[2],OPvP[3],OPvP[4],OPvP[5])
	
	local ptex = button:CreateTexture("OPvPSet", "BACKGROUND")
	ptex:SetSize(20,20);
	ptex:SetPoint("CENTER",-1,1);
	ptex:SetTexture(1,0,0,0.2)	
	ptex:Hide();

	local htex = button:CreateTexture()
	htex:SetSize(20,20);
	htex:SetPoint("CENTER",-1,1);
	htex:SetTexture(1,1,1,0.3)
	button:SetHighlightTexture(htex)
	
	button:RegisterForClicks("LeftButtonDown", "MiddleButtonDown", "RightButtonDown");
	button:SetScript("OnClick", function(self, button)
		if OPvPSet:IsVisible() then
			OPvPSet:Hide();
		else
			OPvPSet:Show();
		end
		for s = 1, 40 do
			if oilvlframedata.ilvl[s] ~= nil and oilvlframedata.ilvl[s] ~= "" then
				oilvlframedata.ilvl[s] = OTgathertilPvP(s);
			end
		end
		OilvlCheckFrame();
	end);
	button:SetScript("OnEnter", function(self) 
		OilvlPvPTooltip:SetOwner(button, "ANCHOR_CURSOR");
		OilvlPvPTooltip:AddLine(PVP);
		OilvlPvPTooltip:Show();
	end)
	button:SetScript("OnLeave", function(self) OilvlPvPTooltip:Hide(); end)
end

function oilvlcfgbutton(btnParent)
	local button = CreateFrame("Button", "oilvlcfgbutton", btnParent)
--	button:SetPoint("TOPLEFT", 39, 20)
	button:SetPoint("TOPLEFT", -10, 10)
	button:SetWidth(70)
	button:SetHeight(70)
	
--    local border = button:CreateTexture(nil, "BORDER");
--    border:SetSize(64,64);
--    border:SetPoint("CENTER", 12, -13);
--    border:SetTexture("Interface/Minimap/MiniMap-TrackingBorder");

	local ntex = button:CreateTexture(nil, "BACKGROUND")
--	ntex:SetSize(52,52);
	ntex:SetSize(120,120);
	ntex:SetPoint("CENTER",-1,1);
	ntex:SetTexture("Interface/AddOns/Oilvl/config.tga")
	
	local htex = button:CreateTexture()
--	htex:SetSize(40,40);
	htex:SetSize(70,70);
	htex:SetPoint("CENTER",-1,1);
	htex:SetTexture("Interface/Minimap/UI-Minimap-ZoomButton-Highlight")
	button:SetHighlightTexture(htex)
	
	button:RegisterForClicks("LeftButtonDown", "MiddleButtonDown", "RightButtonDown");
	button:SetScript("OnClick", function(self, button)
		if button == "MiddleButton" or button == "MiddleButtonDown" then
			otooltip5func()
		elseif button == "LeftButton" or button == "LeftButtonDown" then
			otooltip7func()
		else
			PlaySound("igMainMenuOption");
			InterfaceOptionsFrameTab2:Click();
			InterfaceOptionsFrame_OpenToCategory("O Item Level (OiLvL)")		
		end
	end);
	button:SetScript("OnEnter", function(self, button) LDB_ANCHOR=btnParent; otooltip6func() end);
end
	
function oilvlframe()
	local f = CreateFrame("Frame", "OIVLFRAME", UIParent, "ButtonFrameTemplate");
	f:SetWidth(676);
	f:SetHeight(350);
	f:SetFrameStrata("LOW");

-- set moveable and dragable	
	f:SetMovable(true);
	f:EnableMouse(true);
	f:RegisterForDrag("LeftButton");
	f:SetScript("OnDragStart", f.StartMoving);
	f:SetScript("OnDragStop", function() f:StopMovingOrSizing();  cfg.oilvlframeP, _, _, cfg.oilvlframeX, cfg.oilvlframeY = f:GetPoint() end);

-- Set Title
	f.text = f.text or f:CreateFontString(nil,"ARTWORK", "GameTooltipText");
	f.text:SetAllPoints(true);
	f.text:SetPoint("TOPLEFT",0,-6);
	f.text:SetJustifyH("CENTER");
	f.text:SetJustifyV("TOP");
	f.text:SetTextColor(1,1,1,1);
	f.text:SetText("O Item Level");	

--background texture
	local t = f:CreateTexture(nil,"BACKGROUND")
	t:SetTexture(0.1,0.1,0.1,0.5)
	t:SetAllPoints(f)
	f.texture = t
	f:SetPoint("TOPLEFT",15,-60);
	
 --icon
--    local icon = f:CreateTexture("$parentIcon", "OVERLAY", nil, -8);
--    icon:SetSize(60,60);
--    icon:SetPoint("TOPLEFT",-5,7);
--    icon:SetTexture("Interface/AddOns/Oilvl/config.tga");
--    icon:SetTexCoord(0,1,0,1);
--    f.icon = icon;

-- Average Item Level
	local adjustl = 5;
	local ail = f:CreateFontString("OilvlAIL","ARTWORK","GameFontHighlight")
	ail:SetPoint("BOTTOMLEFT",10,30)
	ail:SetText(L["Average Item Level"]..":");
	
	local ailtank = f:CreateFontString("OilvlAIL_TANK","ARTWORK","GameFontHighlight")
	ailtank:SetPoint("BOTTOMLEFT",28,50)
	ailtank:SetText(" ");
	local g = f:CreateTexture("ONumTank", "OVERLAY", nil, -8);
	g:SetSize(15,15);
	g:SetPoint("BOTTOMLEFT",10,50);
	g:SetTexture(ORole["TANK"][1]);	
	g:SetTexCoord(ORole["TANK"][2],ORole["TANK"][3],ORole["TANK"][4],ORole["TANK"][5]);

	local aildps = f:CreateFontString("OilvlAIL_DPS","ARTWORK","GameFontHighlight")
	aildps:SetPoint("BOTTOMLEFT",118+adjustl,50)
	aildps:SetText(" ");
	g = f:CreateTexture("ONumDPS", "OVERLAY", nil, -8);
	g:SetSize(15,15);
	g:SetPoint("BOTTOMLEFT",100+adjustl,50);
	g:SetTexture(ORole["DAMAGER"][1]);	
	g:SetTexCoord(ORole["DAMAGER"][2],ORole["DAMAGER"][3],ORole["DAMAGER"][4],ORole["DAMAGER"][5]);

	local ailheal = f:CreateFontString("OilvlAIL_HEAL","ARTWORK","GameFontHighlight")
	ailheal:SetPoint("BOTTOMLEFT",218+adjustl*2,50)
	ailheal:SetText(" ");
	g = f:CreateTexture("ONumHeal", "OVERLAY", nil, -8);
	g:SetSize(15,15);
	g:SetPoint("BOTTOMLEFT",200+adjustl*2,50);
	g:SetTexture(ORole["HEALER"][1]);	
	g:SetTexCoord(ORole["HEALER"][2],ORole["HEALER"][3],ORole["HEALER"][4],ORole["HEALER"][5]);
	
-- 	Enchantment Reminder
	local ercb = CreateFrame("CheckButton", "oilvlercb", f, "ChatConfigCheckButtonTemplate");
	ercb:SetPoint("BOTTOMRIGHT", -20,25);
	getglobal(ercb:GetName() .. 'Text'):SetText("ER");
	ercb.tooltip = L["Enable Sending Enchantment Reminder"];
	ercb:SetHitRectInsets(0,0,0,0);
	ercb:SetSize(25,25);
	ercb:SetScript("PostClick", function() 
		cfg.oilvlme = oilvlercb:GetChecked(); 
		oicb6:SetChecked(cfg.oilvlme) 
		if oicb6:GetChecked() then oicb8:Enable(); else	oicb8:Disable(); end
	end);
	ercb:SetChecked(cfg.oilvlme);

OPvPButton(f)
	
-- Config Button
	oilvlcfgbutton(f);
--Refresh button
	oilvlbutton("OILVLREFRESH", LFG_LIST_REFRESH, f, "OptionsButtonTemplate", "TOPRIGHT", -6, -35, 80, 22, function(self, button) OVILRefresh() end);
--Party button
	oilvlbutton("OILVLParty", PARTY, f, "OptionsButtonTemplate", "TOPRIGHT", -88, -35, 60, 22, function(self, button) OSendToParty(button) end);
--Target button
	oilvlbutton("OILVLTarget", STATUS_TEXT_TARGET, f, "OptionsButtonTemplate", "TOPRIGHT", -150, -35, 70, 22, function(self, button) OSendToTarget(button) end);
--Reset button
	oilvlbutton("OILVLReset", RESET, f, "OptionsButtonTemplate", "TOPRIGHT", -222, -35, 90, 22, function(self, button) OResetSendMark() end);
--Instance button
	oilvlbutton("OILVLINSTANCE", BATTLEGROUND_INSTANCE, f, "OptionsButtonTemplate", "BOTTOMLEFT", 3, 3, 80, 22, function(self, button) OSendToInstance(button) end);
-- Guild button
	if GetLocale() == "itIT" then
		oilvlbutton("OILVLGUILD", CHAT_MSG_GUILD, f, "OptionsButtonTemplate", "BOTTOMLEFT", 85, 3, 70, 22, function(self, button) OSendToGuild(button) end);
	else
		oilvlbutton("OILVLGUILD", CHAT_MSG_GUILD, f, "OptionsButtonTemplate", "BOTTOMLEFT", 85, 3, 100, 22, function(self, button) OSendToGuild(button) end);
	end
-- Raid button
	if GetLocale() == "deDE" then
		oilvlbutton("OILVLRAID", "Raid", f, "OptionsButtonTemplate", "BOTTOMLEFT", 187, 3, 60, 22, function(self, button) OSendToRaid(button)	end);
	elseif GetLocale() == "itIT" then
		oilvlbutton("OILVLRAID", CHAT_MSG_RAID, f, "OptionsButtonTemplate", "BOTTOMLEFT", 157, 3, 90, 22, function(self, button) OSendToRaid(button)	end);
	else
		oilvlbutton("OILVLRAID", CHAT_MSG_RAID, f, "OptionsButtonTemplate", "BOTTOMLEFT", 187, 3, 60, 22, function(self, button) OSendToRaid(button)	end);
	end
-- Officer button
	oilvlbutton("OILVLOfficer", GUILD_RANK1_DESC, f, "OptionsButtonTemplate", "BOTTOMLEFT", 250, 3, 70, 22, function(self, button) OSendToOfficer(button)	end);
--Copy button
	oilvlbutton("OILVLCopy", L["Export"], f, "OptionsButtonTemplate", "BOTTOMLEFT", 322, 3, 70, 22, function(self, button) OSendToCopy(button) end);
-- Party / Raid Frame
	local rfb=1; -- raid frame button
	local b4i=0;
	local b4j=0;
	for b4j = 1, 8 do
		for b4i = 1, 5 do
			local button4 = CreateFrame("Button", "OILVLRAIDFRAME"..rfb, f, "SecureActionButtonTemplate")
			button4:SetPoint("TOPLEFT", 10+(b4j-1)*82, -66-(b4i-1)*42)
			button4:SetSize(80,40)
			button4:SetText("")
			button4:SetNormalFontObject("GameFontNormalSmall")			
	
			local ntex4 = button4:CreateTexture()
			ntex4:SetTexture(0.2,0.2,0.2,0.5)
			ntex4:SetTexCoord(0, 0.625, 0, 0.6875)
			ntex4:SetAllPoints()	
			button4:SetNormalTexture(ntex4)
	
			local htex4 = button4:CreateTexture()
			htex4:SetTexture(0,0,1,0.5)
			htex4:SetTexCoord(0, 0.625, 0, 0.6875)
			htex4:SetAllPoints()
			button4:SetHighlightTexture(htex4)
	
			local ptex4 = button4:CreateTexture()
			ptex4:SetTexture(0,1,1,0.5)
			ptex4:SetTexCoord(0, 0.625, 0, 0.6875)
			ptex4:SetAllPoints()
			button4:SetPushedTexture(ptex4)
		
			-- Right Click
			button4:SetAttribute("type2", "target");
			button4:SetAttribute("target2", "mouseover");

			-- Ctrl Right Click
			button4:SetAttribute("ctrl-type2", "macro");
			button4:SetAttribute("ctrl-macrotext2", "/tar mouseover\n/inspect");

			-- Alt Right Click
			button4:SetAttribute("alt-type2", "macro");
			button4:SetAttribute("alt-macrotext2", "/tar mouseover\n/inspect");

			-- hide tooltips
			button4:SetScript("OnLeave", function(self) 
				OilvlTooltip:Hide()
				OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
				rpsw=false;
				rpunit="";
				Omover2=0;
			end)
			
			button4:SetScript("OnEnter", function(self)				
				if not LibQTip:IsAcquired("Oraidprog") then
					local ounit = self:GetAttribute("unit");
					OilvlTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT");
					OilvlTooltip:SetUnit(ounit)
					local i = tonumber(self:GetName():gsub("OILVLRAIDFRAME", "").."");
					if oilvlframedata.spec[i] ~= "" then
						OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
						OilvlTooltip:AddLine(SPECIALIZATION..": |cFF00FF00"..oilvlframedata.spec[i]);
					end
					if oilvlframedata.me[i][1] and oilvlframedata.me[i][1] ~= "" then
						OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
						OilvlTooltip:AddLine(ENSCRIBE..":\n|cFF00FF00"..oilvlframedata.me[i][1]);
					end
					if oilvlframedata.me[i][1] and oilvlframedata.mg[i][1] ~= "" then
						OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
						OilvlTooltip:AddLine(L["Gem"]..":\n|cFF00FF00"..oilvlframedata.mg[i][1]);
					end
					if oilvlframedata.me[i][2] and oilvlframedata.me[i][2] ~= "" then
						OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
						OilvlTooltip:AddLine(LOW.." "..ENSCRIBE..":\n|cFF00FF00"..oilvlframedata.me[i][2]);
					end
					if oilvlframedata.me[i][2] and oilvlframedata.mg[i][2] ~= "" then
						OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
						OilvlTooltip:AddLine(LOW.." "..L["Gem"]..":\n|cFF00FF00"..oilvlframedata.mg[i][2]);
					end
					OilvlTooltip:Show()					
					if not rpsw and CheckInteractDistance(ounit, 1) and UnitExists(ounit) and cfg.oilvlms then
						Omover2=1;						
						ClearAchievementComparisonUnit();
						--print("OnEnter ClearAchievementComparisonUnit")
						OILVL:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
						rpsw=true;
						rpunit=ounit;
						SetAchievementComparisonUnit(ounit);
					end
				end
			end)

			-- set role variable
			Oilvlrole[rfb] = button4:CreateTexture("Oilvlrole"..rfb, "OVERLAY", nil, -8);
			Oilvlrole[rfb]:SetSize(15,15);
			Oilvlrole[rfb]:SetPoint("BOTTOMRIGHT",0,0);
			Oilvlrole[rfb]:SetTexture(nil);
			Oilvlrole[rfb]:SetTexCoord(0,0,0,0);
			
			-- set rank variable
			Oilvlrank[rfb] = button4:CreateTexture("Oilvlrank"..rfb, "OVERLAY", nil, -8);
			Oilvlrank[rfb]:SetSize(15,15);
			Oilvlrank[rfb]:SetPoint("TOPLEFT",0,5);
			Oilvlrank[rfb]:SetTexture(nil);
--			Oilvlrank[rfb]:SetTexCoord(0,0,0,0);
			
			-- set mark for send 
			button4:CreateTexture("Oilvlmark"..rfb, "OVERLAY", nil, -8);
			_G["Oilvlmark"..rfb]:SetSize(15,15);
			_G["Oilvlmark"..rfb]:SetPoint("BOTTOMLEFT",0,0);
			_G["Oilvlmark"..rfb]:SetTexture("Interface/RAIDFRAME/ReadyCheck-Ready");
			_G["Oilvlmark"..rfb]:Hide();

			-- Left Click, Middle Click, Right Click
			button4:RegisterForClicks("LeftButtonDown", "RightButtonDown", "MiddleButtonDown");
			button4:SetScript("PostClick", function(self, button, down) 					
					if (button == "LeftButton" or button == "LeftButtonDown") and not IsControlKeyDown() and not IsAltKeyDown()then
						ORfbIlvl(self:GetName():gsub("OILVLRAIDFRAME", "").."") 
					end
					if button == "MiddleButton" or button == "MiddleButtonDown" then
						if _G["Oilvlmark"..self:GetName():gsub("OILVLRAIDFRAME","")]:IsVisible() then
							_G["Oilvlmark"..self:GetName():gsub("OILVLRAIDFRAME","")]:Hide();
						else
							_G["Oilvlmark"..self:GetName():gsub("OILVLRAIDFRAME","")]:Show();
						end
					end
					if (button == "LeftButton" or button == "LeftButtonDown") and IsAltKeyDown() then
						local nn = tonumber(self:GetName():gsub("OILVLRAIDFRAME","").."");
						if oilvlframedata.gear[nn] ~= "" then
							OIlvlInspectFrame:Clear();							
							for crg = 17,1,-1 do
								if oilvlframedata.gear[nn][crg] ~= nil then
									if OPvPSet:IsVisible() then
										if oilvlframedata.gear[nn][crg][7] ~= 0 then
											OIlvlInspectFrame:AddMessage(oilvlframedata.gear[nn][crg][7].." "..oilvlframedata.gear[nn][crg][2].."  ("..oenchantItem[crg][2]..")",oilvlframedata.gear[nn][crg][3]*oilvlframedata.gear[nn][crg][5],1,oilvlframedata.gear[nn][crg][4]*oilvlframedata.gear[nn][crg][6])
										else
											OIlvlInspectFrame:AddMessage(oilvlframedata.gear[nn][crg][1].." "..oilvlframedata.gear[nn][crg][2].."  ("..oenchantItem[crg][2]..")",oilvlframedata.gear[nn][crg][3]*oilvlframedata.gear[nn][crg][5],1,oilvlframedata.gear[nn][crg][4]*oilvlframedata.gear[nn][crg][6])
										end
									else
										OIlvlInspectFrame:AddMessage(oilvlframedata.gear[nn][crg][1].." "..oilvlframedata.gear[nn][crg][2].."  ("..oenchantItem[crg][2]..")",oilvlframedata.gear[nn][crg][3]*oilvlframedata.gear[nn][crg][5],1,oilvlframedata.gear[nn][crg][4]*oilvlframedata.gear[nn][crg][6]);
									end
								end
							end
							OIlvlInspectFrame:AddMessage(oilvlframedata.ilvl[nn].." "..oilvlframedata.name[nn])
							OIlvlInspect:Show();
						end
					end
					if (button == "LeftButton" or button == "LeftButtonDown") and IsControlKeyDown() then
						local nn = tonumber(self:GetName():gsub("OILVLRAIDFRAME","").."");
						if oilvlframedata.gear[nn] ~= "" then
							OIlvlInspect2Frame:Clear();							
							for crg = 17,1,-1 do
								if oilvlframedata.gear[nn][crg] ~= nil then
									if OPvPSet:IsVisible() then
										if oilvlframedata.gear[nn][crg][7] ~= 0 then
											OIlvlInspect2Frame:AddMessage(oilvlframedata.gear[nn][crg][7].." "..oilvlframedata.gear[nn][crg][2].."  ("..oenchantItem[crg][2]..")",oilvlframedata.gear[nn][crg][3]*oilvlframedata.gear[nn][crg][5],1,oilvlframedata.gear[nn][crg][4]*oilvlframedata.gear[nn][crg][6])
										else
											OIlvlInspect2Frame:AddMessage(oilvlframedata.gear[nn][crg][1].." "..oilvlframedata.gear[nn][crg][2].."  ("..oenchantItem[crg][2]..")",oilvlframedata.gear[nn][crg][3]*oilvlframedata.gear[nn][crg][5],1,oilvlframedata.gear[nn][crg][4]*oilvlframedata.gear[nn][crg][6])
										end
									else
										OIlvlInspect2Frame:AddMessage(oilvlframedata.gear[nn][crg][1].." "..oilvlframedata.gear[nn][crg][2].."  ("..oenchantItem[crg][2]..")",oilvlframedata.gear[nn][crg][3]*oilvlframedata.gear[nn][crg][5],1,oilvlframedata.gear[nn][crg][4]*oilvlframedata.gear[nn][crg][6]);
									end
								end
							end
							OIlvlInspect2Frame:AddMessage(oilvlframedata.ilvl[nn].." "..oilvlframedata.name[nn])
							OIlvlInspect2:Show();
						end
					end
			end);
			rfb = rfb + 1;
		end
	end	
	
-- Oilvl Game Tooltips
	CreateFrame("GameTooltip", "OilvlTooltip", nil, "GameTooltipTemplate" );

-- Oilvl Inspect Tooltips
	CreateFrame("GameTooltip", "OilvlInspectTooltip", nil, "GameTooltipTemplate" ); 
		
-- Oilvl Roll Tooltips
	CreateFrame("GameTooltip", "OilvlRollTooltip", nil, "GameTooltipTemplate" ); 
		
-- Oilvl PvP Tooltips
	CreateFrame("GameTooltip", "OilvlPvPTooltip", nil, "GameTooltipTemplate" ); 
	
-- Refresh
	oilvlframesw=true;
	OVILRefresh();
	f:SetScale(0.8);
	f:Hide();
--	tinsert(UISpecialFrames,"OIVLFRAME");
--	f:SetUserPlaced(true);
end
-- OCategory is the expansion title.
-- ORaidname is the raid title.
-- Oprint is to print out the result if true.
-- Example:
-- OilvlGetStatisticId("Warlords of Draenor", "Highmaul", OSTATHM, false)
-- OilvlGetStatisticId("Warlords of Draenor", "Blackrock Foundry", OSTATBF, false)
function OilvlGetStatisticId(OCategory, ORaidName, OTable, Oprint)
	local str = ""
	for _, CategoryId in pairs(GetStatisticsCategoryList()) do
		local Title, ParentCategoryId, Something
		Title, ParentCategoryId, Something = GetCategoryInfo(CategoryId)
		
		if Title == OCategory then
			local i
			local statisticCount = GetCategoryNumAchievements(CategoryId)
			local j=1; -- boss Count
			local k=1; -- difficulties Count
			for i = 1, statisticCount do
				local IDNumber, OOName, _, _, _, _, _, _, _, _, _ = GetAchievementInfo(CategoryId, i)
				if OOName:find(ORaidName) then
					if k == 1 then
						OTable[j] = {}
					end
					OTable[j][k] = IDNumber;
					if k < 4 then
						k = k + 1;
					else
						OTable[j][k+1] = OOName:gsub(" defeats ",""):gsub(" kills ",""):gsub(" destructions ",""):gsub("%(.*%)","").."";
						k = 1;
						j = j + 1;
					end
					if Oprint then
						print(OOName..":"..IDNumber)
					end
				end
			end
		end
	end
end
-- /dump EJ_GetInstanceByIndex(2, true)
local WoD, _, _ = EJ_GetTierInfo(6);
highmaulname, _, _, _, _, _, _ = EJ_GetInstanceInfo(477)
local OSTATHM = {}
OilvlGetStatisticId(WoD, highmaulname, OSTATHM, false)
-- /dump EJ_GetInstanceByIndex(3, true)
local bfname, _, _, _, _, _, _ = EJ_GetInstanceInfo(457)
local OSTATBF = {}
if GetLocale() == "ptBR" then
	bfname = "Fundição da Rocha Negra";
end
if GetLocale() == "itIT" then
	bfname = "Fonderia Roccianera";
end
OilvlGetStatisticId(WoD, bfname:sub(1,strlen(bfname)-2), OSTATBF, false)
--OilvlGetStatisticId(WoD, bfname, OSTATBF, false)
local hfcname, _, _, _, _, _, _ = EJ_GetInstanceInfo(669)
local OSTATHFC = {}
OilvlGetStatisticId(WoD, hfcname, OSTATHFC, false)
-------------------------------------------------------------------------------
-- Font definitions.
-------------------------------------------------------------------------------
-- Setup the Title Font. 14
local ssTitleFont = CreateFont("ssTitleFont")
ssTitleFont:SetTextColor(1,0.823529,0)
ssTitleFont:SetFont(GameTooltipText:GetFont(), 14)

-- Setup the Header Font. 12
local ssHeaderFont = CreateFont("ssHeaderFont")
ssHeaderFont:SetTextColor(1,0.823529,0)
ssHeaderFont:SetFont(GameTooltipHeaderText:GetFont(), 12)

-- Setup the Regular Font. 12
local ssRegFont = CreateFont("ssRegFont")
ssRegFont:SetTextColor(1,0.823529,0)
ssRegFont:SetFont(GameTooltipText:GetFont(), 12)

local orp={};
orp["LFR"]={};
orp["Normal"]={};
orp["Heroic"]={};
orp["Mythic"]={};

function OGetRaidProgression(RaidName, OSTAT, NumRaidBosses)
	local i=0;
	local omatch=false; -- check if some word repeat
	local twohighest=0;
	local progression="";
	local matchi=0; -- line that word repeat + 1
	wipe(orp);
	orp={};
	orp["LFR"]={};
	orp["Normal"]={};
	orp["Heroic"]={};
	orp["Mythic"]={};
	orp["unitname"], orp["unitid"] = GameTooltip:GetUnit();
	orp["oframe"] = GameTooltip:GetOwner();
	if rpunit == "" or not UnitExists("target") or not CheckInteractDistance("target", 1) or orp["oframe"] == nil then 
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		rpsw=false;
		rpunit="";
		Omover2=0;
		return -1; 
	end
	if orp["unitname"] == nil then 
		ClearAchievementComparisonUnit();
		OILVL:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
		SetAchievementComparisonUnit("target");
		rpunit = "target";
		rpsw=true;
		return -1; 
	end
	if orp["unitid"] == nil then 
		ClearAchievementComparisonUnit();
		OILVL:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
		SetAchievementComparisonUnit("target");
		rpunit = "target";
		rpsw=true;
		return -1; 
	end	
	if UnitGUID(rpunit) ~= UnitGUID(orp["unitid"]) then 
		ClearAchievementComparisonUnit();
		OILVL:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
		SetAchievementComparisonUnit("target");
		rpunit = "target";
		rpsw=true;
		return -1; 
	end
	for i = 2, GameTooltip:NumLines() do
		local msg = _G["GameTooltipTextLeft"..i]:GetText();
		if msg then
			msg = msg:find(RaidName);
		end
		if msg then
			omatch=true;
			matchi=i+1;
			break;
		end
	end	
	if not omatch then
		GameTooltip:SetHeight(GameTooltip:GetHeight()+15);
		GameTooltip:AddLine(RaidName);
	end
	local op=0;
	for i = 1, NumRaidBosses do	
		if GetComparisonStatistic(OSTAT[i][4]) ~= "--" then
			op = op + 1;
		end
		orp["Mythic"][i] = GetComparisonStatistic(OSTAT[i][4]);
	end	
	if op > 0 then
		progression=progression.."|cFF00FF00"..op.."/"..NumRaidBosses.." |r|cFFFFFFFF"..PLAYER_DIFFICULTY6.." ";
		twohighest = twohighest + 1
	end
	op=0;
	for i = 1, NumRaidBosses do
		if GetComparisonStatistic(OSTAT[i][3]) ~= "--" then
			op = op + 1;
		end
		orp["Heroic"][i] = GetComparisonStatistic(OSTAT[i][3]);
	end
	if op > 0 then
		progression=progression.."|cFF00FF00"..op.."/"..NumRaidBosses.." |r|cFFFFFFFF"..PLAYER_DIFFICULTY2.." ";
		twohighest = twohighest + 1
	end
	op=0;
	for i = 1, NumRaidBosses do
		if GetComparisonStatistic(OSTAT[i][2]) ~= "--" then
			op = op + 1;
		end
		orp["Normal"][i] = GetComparisonStatistic(OSTAT[i][2]);
	end
	if op > 0 and twohighest < 2 then
		progression=progression.."|cFF00FF00"..op.."/"..NumRaidBosses.." |r|cFFFFFFFF"..PLAYER_DIFFICULTY1.." ";
		twohighest = twohighest + 1
	end
	op=0;
	for i = 1, NumRaidBosses do
		if GetComparisonStatistic(OSTAT[i][1]) ~= "--" then
			op = op + 1;
		end
		orp["LFR"][i] = GetComparisonStatistic(OSTAT[i][1]);
	end
	if op > 0 and twohighest < 2 then
		progression=progression.."|cFF00FF00"..op.."/"..NumRaidBosses.." |r|cFFFFFFFF"..PLAYER_DIFFICULTY3.." ";
		twohighest = twohighest + 1
	end
	if twohighest == 0 then
		progression=progression.."|cFF00FF00 --";
	end
	if not omatch then
		if progression ~= "" then
			GameTooltip:SetHeight(GameTooltip:GetHeight()+15);
			GameTooltip:AddLine(progression);
		end
	else
		_G["GameTooltipTextLeft"..matchi]:SetText(progression);
	end
	OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
	rpsw=false;
	rpunit="";
	
	-- Show raid progression on tooltip:
	if cfg.oilvlrpdetails then
		if LibQTip:IsAcquired("Oraidprog") then
			otooltip:Clear()
		else
			otooltip = LibQTip:Acquire("Oraidprog", 5, "LEFT", "CENTER", "CENTER", "CENTER", "CENTER")
			otooltip:SetBackdropColor(0,0,0,1)
			otooltip:SetHeaderFont(ssHeaderFont)
			otooltip:SetFont(ssRegFont)
			otooltip:ClearAllPoints()
			otooltip:SetClampedToScreen(false)
			otooltip:SetPoint("TOPRIGHT", GameTooltip, "TOPLEFT")
		end
	
		local line = otooltip:AddLine()
		otooltip:SetCell(line, 1, "|cffffffff" ..RaidName.. "|r", "LEFT", 3)
		line = otooltip:AddHeader()
		line = otooltip:SetCell(line, 1, NAME)
		line = otooltip:SetCell(line, 2, PLAYER_DIFFICULTY3)
		line = otooltip:SetCell(line, 3, PLAYER_DIFFICULTY1)
		line = otooltip:SetCell(line, 4, PLAYER_DIFFICULTY2)
		line = otooltip:SetCell(line, 5, PLAYER_DIFFICULTY6)
		otooltip:AddSeparator()

		for m = 1, NumRaidBosses do
			line = otooltip:AddLine()
			line = otooltip:SetCell(line, 1, OSTAT[m][5])
			line = otooltip:SetCell(line, 2, orp["LFR"][m])
			line = otooltip:SetCell(line, 3, orp["Normal"][m])
			line = otooltip:SetCell(line, 4, orp["Heroic"][m])
			line = otooltip:SetCell(line, 5, orp["Mythic"][m])
		end
		otooltip:Show();
	end
end

function OGetRaidProgression2(RaidName, OSTAT, NumRaidBosses)
--	print("OGetRaidProgression2");
	local i=0;
	local omatch=false; -- check if some word repeat
	local twohighest=0;
	local progression="";
	local matchi=0; -- line that word repeat + 1
	wipe(orp);
	orp={};
	orp["LFR"]={};
	orp["Normal"]={};
	orp["Heroic"]={};
	orp["Mythic"]={};
	orp["unitname"], orp["unitid"] = OilvlTooltip:GetUnit();
	orp["oframe"] = OilvlTooltip:GetOwner();
	if orp["oframe"] == nil then 
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		rpsw=false;
		rpunit="";
		Omover2=0;
		return -1;
	end
	if rpunit == "" or rpunit == "target" or not UnitExists(rpunit) or not UnitExists(orp["unitid"]) or not CheckInteractDistance(rpunit, 1) or not CheckInteractDistance(orp["unitid"], 1) then 
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		rpsw=false;
		rpunit="";
		Omover2=0;
		return -1; 
	end
	if orp["oframe"]:GetName() ~= nil then
		if orp["oframe"]:GetName():gsub("%d","") ~= "OILVLRAIDFRAME" then
			OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
			rpsw=false;
			rpunit="";
			Omover2=0;
			return -1; 			
		end
	end
	if orp["oframe"]:GetName() == nil and orp["oframe"] ~= otooltip6 then
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		rpsw=false;
		rpunit="";
		Omover2=0;
		return -1; 			
	end
	if orp["unitname"] == nil then 
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		rpsw=false;
		rpunit="";
		Omover2=0;
		return -1;
	end
	if orp["unitid"] == nil then 
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		rpsw=false;
		rpunit="";
		Omover2=0;
		return -1;
	end
	if UnitGUID(rpunit) ~= UnitGUID(orp["unitid"]) then
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		rpsw=false;
		rpunit="";
		Omover2=0;
		return -1;
	end
	local gcs1197 = GetComparisonStatistic(1197)
	if gcs1197 == nil or tonumber(gcs1197) == nil then
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		rpsw=false;
		rpunit="";
		Omover2=0;
		return -1;
	end
	local nn = tonumber(orp["oframe"]:GetName():gsub("OILVLRAIDFRAME", "").."");
	orp["spec"] = oilvlframedata.spec[nn];
	orp["class"], _ =  UnitClass(orp["unitid"]);
	orp["ilvl"] = string.format("%d", oilvlframedata.ilvl[nn]);
	orp["raidname"]=RaidName;
	orp["progression"]="";
	for i = 2, OilvlTooltip:NumLines() do
		local msg = _G["OilvlTooltipTextLeft"..i]:GetText();
		if msg then
			msg = msg:find(RaidName);
		end
		if msg then
			omatch=true;
			matchi=i+1;
			break;
		end
	end	
	if not omatch and not cfg.oilvlrpdetails then
		OilvlTooltip:SetHeight(OilvlTooltip:GetHeight()+15);
		OilvlTooltip:AddLine(RaidName);
	end
	local op=0;
	for i = 1, NumRaidBosses do	
		if GetComparisonStatistic(OSTAT[i][4]) ~= "--" then
			op = op + 1;
		end
		orp["Mythic"][i] = GetComparisonStatistic(OSTAT[i][4]);
	end	
	if op > 0 then
		progression=progression.."|cFF00FF00"..op.."/"..NumRaidBosses.." |r|cFFFFFFFF"..PLAYER_DIFFICULTY6.." ";
		orp["progression"]=orp["progression"]..op.."/"..NumRaidBosses.."M ";
		twohighest = twohighest + 1
	end
	op=0;
	for i = 1, NumRaidBosses do
		if GetComparisonStatistic(OSTAT[i][3]) ~= "--" then
			op = op + 1;
		end
		orp["Heroic"][i] = GetComparisonStatistic(OSTAT[i][3]);
	end
	if op > 0 then
		progression=progression.."|cFF00FF00"..op.."/"..NumRaidBosses.." |r|cFFFFFFFF"..PLAYER_DIFFICULTY2.." ";
		orp["progression"]=orp["progression"]..op.."/"..NumRaidBosses.."H ";
		twohighest = twohighest + 1
	end
	op=0;
	for i = 1, NumRaidBosses do
		if GetComparisonStatistic(OSTAT[i][2]) ~= "--" then
			op = op + 1;
		end
		orp["Normal"][i] = GetComparisonStatistic(OSTAT[i][2]);
	end
	if op > 0 and twohighest < 2 then
		progression=progression.."|cFF00FF00"..op.."/"..NumRaidBosses.." |r|cFFFFFFFF"..PLAYER_DIFFICULTY1.." ";
		orp["progression"]=orp["progression"]..op.."/"..NumRaidBosses.."N ";
		twohighest = twohighest + 1
	end
	op=0;
	for i = 1, NumRaidBosses do
		if GetComparisonStatistic(OSTAT[i][1]) ~= "--" then
			op = op + 1;
		end
		orp["LFR"][i] = GetComparisonStatistic(OSTAT[i][1]);
	end
	if op > 0 and twohighest < 2 then
		progression=progression.."|cFF00FF00"..op.."/"..NumRaidBosses.." |r|cFFFFFFFF"..PLAYER_DIFFICULTY3.." ";
		orp["progression"]=orp["progression"]..op.."/"..NumRaidBosses.."L ";
		twohighest = twohighest + 1
	end
	if twohighest == 0 then
		progression=progression.."|cFF00FF00none";
		orp["progression"]="none";
	end
	if not omatch and not cfg.oilvlrpdetails then
		if progression ~= "" then
			OilvlTooltip:SetHeight(OilvlTooltip:GetHeight()+15);
			OilvlTooltip:AddLine(progression);
		end
	else
		if not cfg.oilvlrpdetails then
			_G["OilvlTooltipTextLeft"..matchi]:SetText(progression);
		end
	end
	OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
	rpsw=false;
	rpunit="";
	Omover2=0;
	
	-- Show raid progression on tooltip:	
	if cfg.oilvlrpdetails then
		if LibQTip:IsAcquired("Oraidprog") then
			otooltip2:Clear()
		else
			otooltip2 = LibQTip:Acquire("Oraidprog", 5, "LEFT", "CENTER", "CENTER", "CENTER", "CENTER")
			otooltip2:SetBackdropColor(0,0,0,1)
			otooltip2:SetHeaderFont(ssHeaderFont)
			otooltip2:SetFont(ssRegFont)
			otooltip2:ClearAllPoints()
			otooltip2:SetClampedToScreen(false)
			--[[if GetScreenWidth() - OilvlTooltip:GetRight() < 500 then
				-- show on left
				otooltip2:SetPoint("TOPRIGHT", OilvlTooltip, "TOPLEFT")
				otooltip2:SetAutoHideDelay(0.25, OilvlTooltip:GetOwner());
			else
				-- show on right
				otooltip2:SetPoint("TOPLEFT", OilvlTooltip, "TOPRIGHT")
				otooltip2:SetAutoHideDelay(0.25, OilvlTooltip:GetOwner());
			end]]--
			if GetScreenWidth() - OilvlTooltip:GetRight() < 500 then
				otooltip2:SetPoint("TOPRIGHT", OilvlTooltip:GetOwner(),"BOTTOMLEFT")
			else
				otooltip2:SetPoint("TOPLEFT", OilvlTooltip:GetOwner(),"BOTTOMRIGHT")
			end
			otooltip2:SetAutoHideDelay(0.25, OilvlTooltip:GetOwner(), function() 
				otooltip2:Clear()
				otooltip2:Hide()
				LibQTip:Release(otooltip2)
				otooltip2 = nil
				local oframe = GetMouseFocus();
				if oframe == nil then return -1 end
				if oframe:GetName() == nil then return -1 end
				if oframe:GetName():gsub("%d","").."" ~= "OILVLRAIDFRAME" then return -1; end
				OilvlRunMouseoverTooltips(oframe)
			end);			
			for i = 1, OilvlTooltip:NumLines() do
				if i > 1 and i < 5 then
					otooltip2:AddLine("|cffffffff".._G["OilvlTooltipTextLeft"..i]:GetText());
				else
					otooltip2:AddLine(_G["OilvlTooltipTextLeft"..i]:GetText());
				end
			end
			OilvlTooltip:Hide();
		end	
		local line = otooltip2:AddLine(" ")
		line = otooltip2:AddLine()
		otooltip2:SetCell(line, 1, "|cffffffff" ..orp["unitname"].."("..orp["ilvl"].." "..orp["spec"].." "..orp["class"]..") "..orp["progression"].." "..orp["raidname"].. "|r", "LEFT", 3)
		otooltip2:SetCellScript(line, 1, "OnMouseUp", function() 
			StaticPopupDialogs["COPY_ORP"] = {
				text="Press Ctrl+C to copy",
				button1 = OKAY,
				button2 = nil,
				timeout = 0,
				whileDead = 1,
				hideOnEscape = 1,
				whileDead = 1,
				hasEditBox = 1,
				preferredIndex = 3,
				exclusive = 1,
				maxLetters = 255,
				editBoxWidth = 350,
				OnShow = function (self, data)
					self.editBox:SetText(orp["unitname"].."("..orp["ilvl"].." "..orp["spec"].." "..orp["class"]..") "..orp["progression"].." "..orp["raidname"])
					self.editBox:HighlightText()
					self:SetHeight(16)
				end,
				EditBoxOnEnterPressed = function(self, data)
					StaticPopup_Hide ("COPY_ORP")
				end,
				EditBoxOnEscapePressed = function(self, data)
					StaticPopup_Hide ("COPY_ORP")
				end,				
			}
			StaticPopup_Show ("COPY_ORP")
		end)
		otooltip2:AddSeparator();
		line = otooltip2:AddHeader()
		line = otooltip2:SetCell(line, 1, NAME)
		line = otooltip2:SetCell(line, 2, PLAYER_DIFFICULTY3)
		line = otooltip2:SetCell(line, 3, PLAYER_DIFFICULTY1)
		line = otooltip2:SetCell(line, 4, PLAYER_DIFFICULTY2)
		line = otooltip2:SetCell(line, 5, PLAYER_DIFFICULTY6)
		otooltip2:AddSeparator()

		for m = 1, NumRaidBosses do
			line = otooltip2:AddLine()
			line = otooltip2:SetCell(line, 1, OSTAT[m][5])
			line = otooltip2:SetCell(line, 2, orp["LFR"][m])
			line = otooltip2:SetCell(line, 3, orp["Normal"][m])
			line = otooltip2:SetCell(line, 4, orp["Heroic"][m])
			line = otooltip2:SetCell(line, 5, orp["Mythic"][m])
		end	
		otooltip2:AddSeparator()
		line = otooltip2:AddLine()
		line = otooltip2:SetCell(line, 1, "|cffffffff"..SEND_LABEL)
		line = otooltip2:SetCell(line, 2, "|cffffffff"..CHAT_MSG_GUILD)
		line = otooltip2:SetCell(line, 3, "|cffffffff"..CHAT_MSG_RAID)
		line = otooltip2:SetCell(line, 4, "|cffffffff"..GUILD_RANK1_DESC)
		line = otooltip2:SetCell(line, 5, "|cffffffff"..STATUS_TEXT_TARGET)
		otooltip2:SetCellScript(line, 2, "OnMouseUp", function() 
			SendChatMessage(orp["unitname"].."("..orp["ilvl"].." "..orp["spec"].." "..orp["class"]..") "..orp["progression"].." "..orp["raidname"], "GUILD");
			--print(orp["unitname"]..":"..orp["raidname"].." "..orp["progression"]);
			for m = 1, NumRaidBosses do
				local orpd="";
				if orp["LFR"][m] ~= "--" then orpd=orpd..orp["LFR"][m].."L".." "; end
				if orp["Normal"][m] ~= "--" then orpd=orpd..orp["Normal"][m].."N".." "; end
				if orp["Heroic"][m] ~= "--" then orpd=orpd..orp["Heroic"][m].."H".." "; end
				if orp["Mythic"][m] ~= "--" then orpd=orpd..orp["Mythic"][m].."M".." "; end
				if orpd ~= "" then SendChatMessage(OSTAT[m][5]..":"..orpd, "GUILD"); end
				--if orpd ~= "" then print(OSTAT[m][5]..":"..orpd); end
			end			
		end)
		otooltip2:SetCellScript(line, 3, "OnMouseUp", function() 
			SendChatMessage(orp["unitname"].."("..orp["ilvl"].." "..orp["spec"].." "..orp["class"]..") "..orp["progression"].." "..orp["raidname"], "RAID");
			--print(orp["unitname"]..":"..orp["raidname"].." "..orp["progression"]);
			for m = 1, NumRaidBosses do
				local orpd="";
				if orp["LFR"][m] ~= "--" then orpd=orpd..orp["LFR"][m].."L".." "; end
				if orp["Normal"][m] ~= "--" then orpd=orpd..orp["Normal"][m].."N".." "; end
				if orp["Heroic"][m] ~= "--" then orpd=orpd..orp["Heroic"][m].."H".." "; end
				if orp["Mythic"][m] ~= "--" then orpd=orpd..orp["Mythic"][m].."M".." "; end
				if orpd ~= "" then SendChatMessage(OSTAT[m][5]..":"..orpd, "RAID"); end
				--if orpd ~= "" then print(OSTAT[m][5]..":"..orpd); end
			end			
		end)
		otooltip2:SetCellScript(line, 4, "OnMouseUp", function() 
			SendChatMessage(orp["unitname"].."("..orp["ilvl"].." "..orp["spec"].." "..orp["class"]..") "..orp["progression"].." "..orp["raidname"], "OFFICER");
			--print(orp["unitname"]..":"..orp["raidname"].." "..orp["progression"]);
			for m = 1, NumRaidBosses do
				local orpd="";
				if orp["LFR"][m] ~= "--" then orpd=orpd..orp["LFR"][m].."L".." "; end
				if orp["Normal"][m] ~= "--" then orpd=orpd..orp["Normal"][m].."N".." "; end
				if orp["Heroic"][m] ~= "--" then orpd=orpd..orp["Heroic"][m].."H".." "; end
				if orp["Mythic"][m] ~= "--" then orpd=orpd..orp["Mythic"][m].."M".." "; end
				if orpd ~= "" then SendChatMessage(OSTAT[m][5]..":"..orpd, "OFFICER"); end
				--if orpd ~= "" then print(OSTAT[m][5]..":"..orpd); end
			end			
		end)
		otooltip2:SetCellScript(line, 5, "OnMouseUp", function() 
			if not UnitExists("target") then return -1;	end
			SendChatMessage(orp["unitname"].."("..orp["ilvl"].." "..orp["spec"].." "..orp["class"]..") "..orp["progression"].." "..orp["raidname"], "WHISPER", nil, UnitName("target"));
			--print(orp["unitname"]..":"..orp["raidname"].." "..orp["progression"]);
			for m = 1, NumRaidBosses do
				local orpd="";
				if orp["LFR"][m] ~= "--" then orpd=orpd..orp["LFR"][m].."L".." "; end
				if orp["Normal"][m] ~= "--" then orpd=orpd..orp["Normal"][m].."N".." "; end
				if orp["Heroic"][m] ~= "--" then orpd=orpd..orp["Heroic"][m].."H".." "; end
				if orp["Mythic"][m] ~= "--" then orpd=orpd..orp["Mythic"][m].."M".." "; end
				if orpd ~= "" then SendChatMessage(OSTAT[m][5]..":"..orpd, "WHISPER", nil, UnitName("target")); end
				--if orpd ~= "" then print(OSTAT[m][5]..":"..orpd); end
			end			
		end)
		otooltip2:AddSeparator()
		otooltip2:Show();
--		print(otooltip2:GetWidth());
	end
end

local oicomp = {};

function otooltip4func()
	if otooltip4 ~= nil then
		if LibQTip:IsAcquired("OiLvLRoll") then otooltip4:Clear() end
		otooltip4:Hide()
		LibQTip:Release(otooltip4)
		otooltip4 = nil
	end
	otooltip4 = LibQTip:Acquire("OiLvLRoll", 5, "LEFT", "CENTER", "LEFT", "LEFT", "RIGHT")
	otooltip4:SetBackdropColor(0,0,0,1)
	otooltip4:SetHeaderFont(ssHeaderFont)
	otooltip4:SetFont(ssRegFont)
	otooltip4:ClearAllPoints()
	otooltip4:SetClampedToScreen(false)
	otooltip4:SetPoint("CENTER",UIParent,0,200)
	local line = otooltip4:AddLine("");
	otooltip4:SetCell(line, 1, oroll[1][1].." "..oroll[1][2].." "..ROLL.." "..oroll[1][3],"LEFT",4)
	otooltip4:SetCellScript(line, 1, "OnEnter", function()
		OilvlRollTooltip:SetOwner(otooltip4, "ANCHOR_NONE");
		OilvlRollTooltip:SetPoint("TOPLEFT",otooltip4,"TOPRIGHT",0,0)
		OilvlRollTooltip:ClearLines()
		OilvlRollTooltip:SetHyperlink(oroll[1][2])		
	end)
	otooltip4:SetCellScript(line, 1, "OnLeave", function() OilvlRollTooltip:Hide() end)
	otooltip4:SetCellScript(line, 1, "OnMouseUp", function()
		if IsShiftKeyDown() then
			local chatWindow = ChatEdit_GetActiveWindow()
			if chatWindow then
				chatWindow:Insert(oroll[1][2])
			end
		end	
		if IsControlKeyDown() then
			DressUpItemLink(oroll[1][2])
		end
	end)
	otooltip4:AddSeparator();
	line = otooltip4:AddHeader()
	otooltip4:SetCell(line, 1, "|cffffffff"..NAME)
	otooltip4:SetCell(line, 2, "|cffffffff"..ROLL)
	otooltip4:SetCell(line, 3, "|cffffffff"..ENCOUNTER_JOURNAL_ITEM.." 1")
	otooltip4:SetCell(line, 4, "|cffffffff"..ENCOUNTER_JOURNAL_ITEM.." 2")
	otooltip4:AddSeparator()
	local temporoll = {}
	for m = 2, orolln do
		temporoll[m-1] = {
			name = oroll[m][1], 
			roll = oroll[m][2], 
			ilvl1 = oroll[m][3], 
			item1 = oroll[m][4], 
			ilvl2 = oroll[m][5], 
			item2 = oroll[m][6]
		}
	end
	-- sort roll
	sort(temporoll, function(a,b) return a.roll > b.roll end);	
	for m = 1,  orolln - 1 do
		line = otooltip4:AddLine()
		otooltip4:SetCell(line, 1, temporoll[m].name)
		otooltip4:SetCell(line, 2, temporoll[m].roll)
		otooltip4:SetCell(line, 3, temporoll[m].ilvl1.." "..temporoll[m].item1)
		otooltip4:SetCellScript(line, 3, "OnEnter", function()
			if temporoll[m].item1 and temporoll[m].item1 ~= "" then
				OilvlRollTooltip:SetOwner(otooltip4, "ANCHOR_NONE");
				OilvlRollTooltip:SetPoint("TOPLEFT",otooltip4,"TOPRIGHT",0,0)
				OilvlRollTooltip:ClearLines()
				OilvlRollTooltip:SetHyperlink(temporoll[m].item1)
			end
		end)
		otooltip4:SetCellScript(line, 3, "OnLeave", function() OilvlRollTooltip:Hide() end)
		otooltip4:SetCellScript(line, 3, "OnMouseUp", function()
			if IsShiftKeyDown() and temporoll[m].item1 and temporoll[m].item1 ~= "" then
				local chatWindow = ChatEdit_GetActiveWindow()
				if chatWindow then
					chatWindow:Insert(temporoll[m].item1)
				end
			end	
			if IsControlKeyDown() and temporoll[m].item1 and temporoll[m].item1 ~= "" then
				DressUpItemLink(temporoll[m].item1)
			end
		end)
		otooltip4:SetCell(line, 4, temporoll[m].ilvl2.." "..temporoll[m].item2)
		otooltip4:SetCellScript(line, 4, "OnEnter", function()
			if temporoll[m].item2 and temporoll[m].item2 ~= "" then
				OilvlRollTooltip:SetOwner(otooltip4, "ANCHOR_NONE");
				OilvlRollTooltip:SetPoint("TOPLEFT",otooltip4,"TOPRIGHT",0,0)
				OilvlRollTooltip:ClearLines()
				OilvlRollTooltip:SetHyperlink(temporoll[m].item2)
			end
		end)
		otooltip4:SetCellScript(line, 4, "OnLeave", function() OilvlRollTooltip:Hide() end)
		otooltip4:SetCellScript(line, 4, "OnMouseUp", function()
			if IsShiftKeyDown() and temporoll[m].item2 and temporoll[m].item2 ~= "" then
				local chatWindow = ChatEdit_GetActiveWindow()
				if chatWindow then
					chatWindow:Insert(temporoll[m].item2)
				end
			end	
			if IsControlKeyDown() and temporoll[m].item2 and temporoll[m].item2 ~= "" then
				DressUpItemLink(temporoll[m].item2)
			end
		end)
	end	
	otooltip4:AddSeparator()
	line = otooltip4:AddLine()
	otooltip4:SetCell(line, 5, "|cffffffff"..HIDE)
	otooltip4:SetCellScript(line, 5, "OnMouseUp", function() 
		otooltip4:Hide() 
		if otooltip4 ~= nil then
			LibQTip:Release(otooltip4)
			otooltip4 = nil
		end
		orolln = 0;
		oroll = {};
		orollgear = "";
	end)
	otooltip4:AddSeparator();
	otooltip4:UpdateScrolling();
	otooltip4:Show();
end

function otooltip5func()
	if otooltip5 ~= nil then
		if LibQTip:IsAcquired("OiLvLAlt") then otooltip5:Clear() end
		otooltip5:Hide()
		LibQTip:Release(otooltip5)
		otooltip5 = nil
	end
	otooltip5 = LibQTip:Acquire("OiLvLAlt", 2, "LEFT", "CENTER")
	otooltip5:SetBackdropColor(0,0,0,1)
	otooltip5:SetHeaderFont(ssHeaderFont)
	otooltip5:SetFont(ssRegFont)
	otooltip5:ClearAllPoints()
	otooltip5:SetClampedToScreen(false)
	otooltip5:SetPoint("CENTER")
	otooltip5:AddSeparator();
	local line = otooltip5:AddHeader()
	otooltip5:SetCell(line, 1, "|cffffffff"..NAME)
	otooltip5:SetCell(line, 2, "|cffffffff"..L["Item Level"])
	otooltip5:AddSeparator()
	for m = 1,  #cfg.oilvlgears do
		line = otooltip5:AddLine()
		otooltip5:SetCell(line, 1, cfg.oilvlgears[m][1].."-"..cfg.oilvlgears[m][2])
		otooltip5:SetCellScript(line, 1, "OnMouseUp", function(self)
			if GetMouseButtonClicked() == "LeftButton" then
				local nn = self._line - 3;
				if cfg.oilvlgears[nn] and  cfg.oilvlgears[nn][1] and cfg.oilvlgears[nn][2] then
					OIlvlInspectFrame:Clear();					
					for crg = 17,1,-1 do
						if cfg.oilvlgears[nn][4][crg] ~= nil then
							OIlvlInspectFrame:AddMessage(cfg.oilvlgears[nn][4][crg][1].." "..cfg.oilvlgears[nn][4][crg][2].."  ("..oenchantItem[crg][2]..")",cfg.oilvlgears[nn][4][crg][3]*cfg.oilvlgears[nn][4][crg][5],1,cfg.oilvlgears[nn][4][crg][4]*cfg.oilvlgears[nn][4][crg][6]);
						end
					end
					OIlvlInspectFrame:AddMessage(cfg.oilvlgears[m][3].." "..cfg.oilvlgears[m][1].."-"..cfg.oilvlgears[m][2])
					OIlvlInspect:Show();
				end
			end
			if GetMouseButtonClicked() == "RightButton" then
				local nn = self._line - 3;
				if cfg.oilvlgears[nn] and  cfg.oilvlgears[nn][1] and cfg.oilvlgears[nn][2] then
					OIlvlInspect2Frame:Clear();
					for crg = 17,1,-1 do
						if cfg.oilvlgears[nn][4][crg] ~= nil then
							OIlvlInspect2Frame:AddMessage(cfg.oilvlgears[nn][4][crg][1].." "..cfg.oilvlgears[nn][4][crg][2].."  ("..oenchantItem[crg][2]..")",cfg.oilvlgears[nn][4][crg][3]*cfg.oilvlgears[nn][4][crg][5],1,cfg.oilvlgears[nn][4][crg][4]*cfg.oilvlgears[nn][4][crg][6]);
						end
					end
					OIlvlInspect2Frame:AddMessage(cfg.oilvlgears[m][3].." "..cfg.oilvlgears[m][1].."-"..cfg.oilvlgears[m][2])
					OIlvlInspect2:Show();
				end
			end
		end)
		otooltip5:SetCell(line, 2, cfg.oilvlgears[m][3])
	end	
	otooltip5:AddSeparator()
	line = otooltip5:AddLine()
	otooltip5:SetCell(line, 2, "|cffffffff"..HIDE)
	otooltip5:SetCellScript(line, 2, "OnMouseUp", function() 
		otooltip5:Hide() 
		if otooltip5 ~= nil then
			LibQTip:Release(otooltip5)
			otooltip5 = nil
		end
	end)
	otooltip5:AddSeparator();
	otooltip5:UpdateScrolling();
	otooltip5:Show();
end

local function otooltip6sort(method)
	otooltip6sortMethod = method;
	if method == "NAME" then
			sort(oicomp, function(a,b) return a.name < b.name end);
	elseif method == "NAME2" then			
			sort(oicomp, function(a,b) return a.name > b.name end);
	elseif method == "ROLE" then
			sort(oicomp, function(a,b) return a.role < b.role end);
	elseif method == "ROLE2" then
			sort(oicomp, function(a,b) return a.role > b.role end);
	elseif method == "ILVL" then
			sort(oicomp, function(a,b) return a.ilvl < b.ilvl end);
	elseif method == "ILVL2" then
			sort(oicomp, function(a,b) return a.ilvl > b.ilvl end);
	elseif method == "ID" then
			sort(oicomp, function(a,b) return a.id < b.id end);
	else
			sort(oicomp, function(a,b) return a.id > b.id end);
	end
end

oilvltestvar = {};

function otooltip6func()
	local self = LDB_ANCHOR;
	if otooltip6 ~= nil then
		if LibQTip:IsAcquired("OiLvLDB") then otooltip6:Clear() end
		otooltip6:Hide()
		LibQTip:Release(otooltip6)
		otooltip6 = nil
	end
	otooltip6 = LibQTip:Acquire("OiLvLDB", 4, "LEFT", "LEFT", "CENTER","RIGHT")
	otooltip6:SetBackdropColor(0,0,0,1)
	otooltip6:SetHeaderFont(ssHeaderFont)
	otooltip6:SetFont(ssRegFont)
	otooltip6:SmartAnchorTo(self)
	otooltip6:SetAutoHideDelay(0.25, self, function() 
		otooltip6:Hide() 
		if otooltip6 ~= nil then
			LibQTip:Release(otooltip6)
			otooltip6 = nil
		end
	end)
	local line;
	otooltip6:AddSeparator();
	line = otooltip6:AddHeader()
	otooltip6:SetCell(line, 1, "|cffffffffID")
	otooltip6:SetCellScript(line, 1, "OnMouseUp", function()
		if otooltip6sortMethod == "ID" then
			otooltip6sortMethod = "ID2"; otooltip6func(); 
		else
			otooltip6sortMethod = "ID"; otooltip6func(); 
		end
	end)
	otooltip6:SetCell(line, 2, "|cffffffff"..NAME)
	otooltip6:SetCellScript(line, 2, "OnMouseUp", function() 
		if otooltip6sortMethod == "NAME" then
			otooltip6sortMethod = "NAME2"; otooltip6func(); 
		else
			otooltip6sortMethod = "NAME"; otooltip6func(); 
		end
	end)
	otooltip6:SetCell(line, 3, "|cffffffff"..ROLE)
	otooltip6:SetCellScript(line, 3, "OnMouseUp", function()
		if otooltip6sortMethod == "ROLE" then
			otooltip6sortMethod = "ROLE2"; otooltip6func(); 
		else
			otooltip6sortMethod = "ROLE"; otooltip6func(); 
		end
	end)
	otooltip6:SetCell(line, 4, "|cffffffff"..L["Item Level"])
	otooltip6:SetCellScript(line, 4, "OnMouseUp", function()
		if otooltip6sortMethod == "ILVL" then
			otooltip6sortMethod = "ILVL2"; otooltip6func(); 
		else
			otooltip6sortMethod = "ILVL"; otooltip6func(); 
		end
	end)
	otooltip6:AddSeparator()
	oicomp = {};	
	local compi = 0;
	for m = 1, 40 do
		if tonumber(oilvlframedata.ilvl[m]) ~= nil and oilvlframedata.ilvl[m] ~= "" and oilvlframedata.ilvl[m] ~= nil then
			compi = compi + 1
			local ooname, _ = strsplit("\n",_G["OILVLRAIDFRAME"..m]:GetText(),2)
			oicomp[compi] = {id = m, name = ooname, role = oilvlframedata.role[m], ilvl = oilvlframedata.ilvl[m]}
		end
	end
	otooltip6sort(otooltip6sortMethod);
	for m = 1, #oicomp do
		line = otooltip6:AddLine()
		otooltip6:SetCell(line, 1, oicomp[m].id)
		otooltip6:SetCell(line, 2, oicomp[m].name)
		otooltip6:SetCell(line, 3, ORole2[oicomp[m].role],"CENTER")
		otooltip6:SetCell(line, 4, oicomp[m].ilvl)
		otooltip6:SetLineScript(line, "OnMouseUp", function(self)
			local nn = tonumber(self.cells[1].fontString:GetText())
			if GetMouseButtonClicked() == "LeftButton" then
				if oilvlframedata.gear[nn] ~= "" then
					OIlvlInspectFrame:Clear();							
					for crg = 17,1,-1 do
						if oilvlframedata.gear[nn][crg] ~= nil then
							if OPvPSet:IsVisible() then
							if oilvlframedata.gear[nn][crg][7] ~= 0 then
									OIlvlInspectFrame:AddMessage(oilvlframedata.gear[nn][crg][7].." "..oilvlframedata.gear[nn][crg][2].."  ("..oenchantItem[crg][2]..")",oilvlframedata.gear[nn][crg][3]*oilvlframedata.gear[nn][crg][5],1,oilvlframedata.gear[nn][crg][4]*oilvlframedata.gear[nn][crg][6])
								else
									OIlvlInspectFrame:AddMessage(oilvlframedata.gear[nn][crg][1].." "..oilvlframedata.gear[nn][crg][2].."  ("..oenchantItem[crg][2]..")",oilvlframedata.gear[nn][crg][3]*oilvlframedata.gear[nn][crg][5],1,oilvlframedata.gear[nn][crg][4]*oilvlframedata.gear[nn][crg][6])
								end
							else
								OIlvlInspectFrame:AddMessage(oilvlframedata.gear[nn][crg][1].." "..oilvlframedata.gear[nn][crg][2].."  ("..oenchantItem[crg][2]..")",oilvlframedata.gear[nn][crg][3]*oilvlframedata.gear[nn][crg][5],1,oilvlframedata.gear[nn][crg][4]*oilvlframedata.gear[nn][crg][6]);
							end
						end
					end
					OIlvlInspectFrame:AddMessage(oilvlframedata.ilvl[nn].." "..oilvlframedata.name[nn])
					OIlvlInspect:Show();
				end
			end
			if GetMouseButtonClicked() == "RightButton" then
				if oilvlframedata.gear[nn] ~= "" then
					OIlvlInspect2Frame:Clear();							
					for crg = 17,1,-1 do
						if oilvlframedata.gear[nn][crg] ~= nil then
							if OPvPSet:IsVisible() then
								if oilvlframedata.gear[nn][crg][7] ~= 0 then
									OIlvlInspect2Frame:AddMessage(oilvlframedata.gear[nn][crg][7].." "..oilvlframedata.gear[nn][crg][2].."  ("..oenchantItem[crg][2]..")",oilvlframedata.gear[nn][crg][3]*oilvlframedata.gear[nn][crg][5],1,oilvlframedata.gear[nn][crg][4]*oilvlframedata.gear[nn][crg][6])
								else
									OIlvlInspect2Frame:AddMessage(oilvlframedata.gear[nn][crg][1].." "..oilvlframedata.gear[nn][crg][2].."  ("..oenchantItem[crg][2]..")",oilvlframedata.gear[nn][crg][3]*oilvlframedata.gear[nn][crg][5],1,oilvlframedata.gear[nn][crg][4]*oilvlframedata.gear[nn][crg][6])
								end
							else
								OIlvlInspect2Frame:AddMessage(oilvlframedata.gear[nn][crg][1].." "..oilvlframedata.gear[nn][crg][2].."  ("..oenchantItem[crg][2]..")",oilvlframedata.gear[nn][crg][3]*oilvlframedata.gear[nn][crg][5],1,oilvlframedata.gear[nn][crg][4]*oilvlframedata.gear[nn][crg][6]);
							end
						end
					end
					OIlvlInspect2Frame:AddMessage(oilvlframedata.ilvl[nn].." "..oilvlframedata.name[nn])
					OIlvlInspect2:Show();
				end
			end
		end)
	end	
	otooltip6:AddSeparator()
	-- average item level for tank, healer and dps
	if IsInRaid() or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInGroup(LE_PARTY_CATEGORY_HOME) then
		line = otooltip6:AddLine()
		otooltip6:SetCell(line, 1, "|TInterface\\LFGFrame\\LFGRole:0:0:0:0:64:16:32:48:0:16:255:255:255|t","CENTER",2)	
		otooltip6:SetCell(line, 3, NumRole["TANK"])
		otooltip6:SetCell(line, 4, ailtank)
		line = otooltip6:AddLine()
		otooltip6:SetCell(line, 1, "|TInterface\\LFGFrame\\LFGRole:0:0:0:0:64:16:16:32:0:16:255:255:255|t","CENTER",2)
		otooltip6:SetCell(line, 3, NumRole["DAMAGER"])
		otooltip6:SetCell(line, 4, aildps)
		line = otooltip6:AddLine()
		otooltip6:SetCell(line, 1, "|TInterface\\LFGFrame\\LFGRole:0:0:0:0:64:16:48:64:0:16:255:255:255|t","CENTER",2)
		otooltip6:SetCell(line, 3, NumRole["HEALER"])
		otooltip6:SetCell(line, 4, ailheal)
		otooltip6:AddSeparator()
	end
	line = otooltip6:AddLine()
	otooltip6:SetCell(line, 2, "|cffffffff"..PARTY)
	otooltip6:SetCellScript(line, 2, "OnMouseUp", function() OSendToParty(GetMouseButtonClicked()) end)
	otooltip6:SetCell(line, 3, "|cffffffff"..STATUS_TEXT_TARGET)
	otooltip6:SetCellScript(line, 3, "OnMouseUp", function() OSendToTarget(GetMouseButtonClicked()) end)
	otooltip6:SetCell(line, 4, "|cffffffff"..BATTLEGROUND_INSTANCE)
	otooltip6:SetCellScript(line, 4, "OnMouseUp", function() OSendToInstance(GetMouseButtonClicked()) end)
	line = otooltip6:AddLine()
	otooltip6:SetCell(line, 2, "|cffffffff"..CHAT_MSG_GUILD)
	otooltip6:SetCellScript(line, 2, "OnMouseUp", function() OSendToGuild(GetMouseButtonClicked()) end)
	if GetLocale() == "deDE" then
		otooltip6:SetCell(line, 3, "|cffffffff".."Raid")
	else
		otooltip6:SetCell(line, 3, "|cffffffff"..CHAT_MSG_RAID)
	end
	otooltip6:SetCellScript(line, 3, "OnMouseUp", function() OSendToRaid(GetMouseButtonClicked()) end)
	otooltip6:SetCell(line, 4, "|cffffffff"..GUILD_RANK1_DESC)
	otooltip6:SetCellScript(line, 4, "OnMouseUp", function() OSendToOfficer(GetMouseButtonClicked()) end)
	
	otooltip6:AddSeparator()
	otooltip6:UpdateScrolling();
	otooltip6:Show();	
end

function LDB.OnEnter(self)	
	LDB_ANCHOR = self;
	otooltip6func();
end

function otooltip7func()
	if otooltip7 ~= nil then
		if LibQTip:IsAcquired("OiLvLCache") then otooltip7:Clear() end
		otooltip7:Hide()
		LibQTip:Release(otooltip7)
		otooltip7 = nil
	end
	otooltip7 = LibQTip:Acquire("OiLvLCache", 5, "RIGHT","LEFT", "CENTER", "CENTER", "CENTER")
	otooltip7:SetBackdropColor(0,0,0,1)
	otooltip7:SetHeaderFont(ssHeaderFont)
	otooltip7:SetFont(ssRegFont)
	otooltip7:ClearAllPoints()
	otooltip7:SetClampedToScreen(false)
	otooltip7:SetPoint("CENTER")
	otooltip7:AddSeparator();
	local line = otooltip7:AddHeader()
	otooltip7:SetCell(line, 1, "|cffffffff".."ID")
	otooltip7:SetCell(line, 2, "|cffffffff"..NAME)
	otooltip7:SetCellScript(line, 2, "OnMouseUp", function(self)
		if #cfg.oilvlcache > 1 then
			if  cfg.oilvlcache[1].oname > cfg.oilvlcache[#cfg.oilvlcache].oname then
				sort(cfg.oilvlcache, function(a,b) return a.oname < b.oname end)
			else
				sort(cfg.oilvlcache, function(a,b) return a.oname > b.oname end)
			end
		end
		otooltip7func()
	end)
	otooltip7:SetCell(line, 3, "|cffffffff"..FRIENDS_LIST_REALM:gsub(":",""))
	otooltip7:SetCellScript(line, 3, "OnMouseUp", function(self)
		if #cfg.oilvlcache > 1 then
			if  cfg.oilvlcache[1].orealm > cfg.oilvlcache[#cfg.oilvlcache].orealm then
				sort(cfg.oilvlcache, function(a,b) return a.orealm < b.orealm end)
			else
				sort(cfg.oilvlcache, function(a,b) return a.orealm > b.orealm end)
			end
		end
		otooltip7func()
	end)
	otooltip7:SetCell(line, 4, "|cffffffff"..CLASS)
	otooltip7:SetCellScript(line, 4, "OnMouseUp", function(self)
		if #cfg.oilvlcache > 1 then
			if  cfg.oilvlcache[1].oclass > cfg.oilvlcache[#cfg.oilvlcache].oclass then
				sort(cfg.oilvlcache, function(a,b) return a.oclass < b.oclass end)
			else
				sort(cfg.oilvlcache, function(a,b) return a.oclass > b.oclass end)
			end
		end
		otooltip7func()
	end)
	otooltip7:SetCell(line, 5, "|cffffffff"..L["Item Level"])
	otooltip7:SetCellScript(line, 5, "OnMouseUp", function(self)
		if #cfg.oilvlcache > 1 then
			if  cfg.oilvlcache[1].oilvl > cfg.oilvlcache[#cfg.oilvlcache].oilvl then
				sort(cfg.oilvlcache, function(a,b) return a.oilvl < b.oilvl end)
			else
				sort(cfg.oilvlcache, function(a,b) return a.oilvl > b.oilvl end)
			end
		end
		otooltip7func()
	end)
	otooltip7:AddSeparator()
	for m = 1,  #cfg.oilvlcache do
		line = otooltip7:AddLine()
		otooltip7:SetCell(line, 1, m)
		otooltip7:SetCell(line, 2, cfg.oilvlcache[m].oname)
		otooltip7:SetCellScript(line, 2, "OnMouseUp", function(self)
			if GetMouseButtonClicked() == "LeftButton" then
				local nn = self._line - 3;
				if cfg.oilvlcache[nn] and cfg.oilvlcache[nn].oname and cfg.oilvlcache[nn].orealm then
					OIlvlInspectFrame:Clear();					
					for crg = 17,1,-1 do
						if cfg.oilvlcache[nn].ogear[crg] ~= nil then
							if OPvPSet:IsVisible() then
								if cfg.oilvlcache[nn].ogear[crg][7] ~= 0 then
									OIlvlInspectFrame:AddMessage(cfg.oilvlcache[nn].ogear[crg][7].." "..cfg.oilvlcache[nn].ogear[crg][2].."  ("..oenchantItem[crg][2]..")",cfg.oilvlcache[nn].ogear[crg][3]*cfg.oilvlcache[nn].ogear[crg][5],1,cfg.oilvlcache[nn].ogear[crg][4]*cfg.oilvlcache[nn].ogear[crg][6])
								else
									OIlvlInspectFrame:AddMessage(cfg.oilvlcache[nn].ogear[crg][1].." "..cfg.oilvlcache[nn].ogear[crg][2].."  ("..oenchantItem[crg][2]..")",cfg.oilvlcache[nn].ogear[crg][3]*cfg.oilvlcache[nn].ogear[crg][5],1,cfg.oilvlcache[nn].ogear[crg][4]*cfg.oilvlcache[nn].ogear[crg][6])
								end
							else
								OIlvlInspectFrame:AddMessage(cfg.oilvlcache[nn].ogear[crg][1].." "..cfg.oilvlcache[nn].ogear[crg][2].."  ("..oenchantItem[crg][2]..")",cfg.oilvlcache[nn].ogear[crg][3]*cfg.oilvlcache[nn].ogear[crg][5],1,cfg.oilvlcache[nn].ogear[crg][4]*cfg.oilvlcache[nn].ogear[crg][6]);
							end
						end
					end
					OIlvlInspectFrame:AddMessage(cfg.oilvlcache[m].oilvl.." "..cfg.oilvlcache[m].oname.."-"..cfg.oilvlcache[m].orealm)
					OIlvlInspect:Show();
				end
			end
			if GetMouseButtonClicked() == "RightButton" then
				local nn = self._line - 3;
				if cfg.oilvlcache[nn] and cfg.oilvlcache[nn].oname and cfg.oilvlcache[nn].orealm then
					OIlvlInspect2Frame:Clear();
					for crg = 17,1,-1 do
						if cfg.oilvlcache[nn].ogear[crg] ~= nil then
							if OPvPSet:IsVisible() then
								if cfg.oilvlcache[nn].ogear[crg][7] ~= 0 then
									OIlvlInspect2Frame:AddMessage(cfg.oilvlcache[nn].ogear[crg][7].." "..cfg.oilvlcache[nn].ogear[crg][2].."  ("..oenchantItem[crg][2]..")",cfg.oilvlcache[nn].ogear[crg][3]*cfg.oilvlcache[nn].ogear[crg][5],1,cfg.oilvlcache[nn].ogear[crg][4]*cfg.oilvlcache[nn].ogear[crg][6])
								else
									OIlvlInspectFrame:AddMessage(cfg.oilvlcache[nn].ogear[crg][1].." "..cfg.oilvlcache[nn].ogear[crg][2].."  ("..oenchantItem[crg][2]..")",cfg.oilvlcache[nn].ogear[crg][3]*cfg.oilvlcache[nn].ogear[crg][5],1,cfg.oilvlcache[nn].ogear[crg][4]*cfg.oilvlcache[nn].ogear[crg][6])
								end
							else
								OIlvlInspect2Frame:AddMessage(cfg.oilvlcache[nn].ogear[crg][1].." "..cfg.oilvlcache[nn].ogear[crg][2].."  ("..oenchantItem[crg][2]..")",cfg.oilvlcache[nn].ogear[crg][3]*cfg.oilvlcache[nn].ogear[crg][5],1,cfg.oilvlcache[nn].ogear[crg][4]*cfg.oilvlcache[nn].ogear[crg][6]);
							end
						end
					end
					OIlvlInspect2Frame:AddMessage(cfg.oilvlcache[m].oilvl.." "..cfg.oilvlcache[m].oname.."-"..cfg.oilvlcache[m].orealm)
					OIlvlInspect2:Show();
				end
			end
		end)
		otooltip7:SetCell(line, 3, cfg.oilvlcache[m].orealm)
		otooltip7:SetCell(line, 4, cfg.oilvlcache[m].oclass)
		cfg.oilvlcache[m].oilvl = OTgathertilPvPCache(m)
		otooltip7:SetCell(line, 5, cfg.oilvlcache[m].oilvl)
	end	
	otooltip7:AddSeparator()
	line = otooltip7:AddLine()
	-- CLEAR_ALL
	otooltip7:SetCell(line, 4, "|cffffffff"..CLEAR_ALL)
	otooltip7:SetCellScript(line, 4, "OnMouseUp", function() 
		cfg.oilvlcache = {} 
		otooltip7func()
	end)
	-- HIDE
	otooltip7:SetCell(line, 5, "|cffffffff"..HIDE)
	otooltip7:SetCellScript(line, 5, "OnMouseUp", function() 
		otooltip7:Hide() 
		if otooltip7 ~= nil then
			LibQTip:Release(otooltip7)
			otooltip7 = nil
		end
	end)
	otooltip7:AddSeparator();
	otooltip7:UpdateScrolling(400);
	if otooltip7exit == nil then
		oilvlminbutton(otooltip7, "otooltip7exit", function() 
			otooltip7:Hide()
			otooltip7exit:Hide();
			if otooltip7 ~= nil then
				LibQTip:Release(otooltip7)
				otooltip7 = nil
			end	
		end, 10,10)
	else
		otooltip7exit:SetParent(otooltip7)
		otooltip7exit:SetPoint("TOPRIGHT",otooltip7,10,10)
	end
	otooltip7exit:Show();
	otooltip7:Show();
end

local enchantID = {5275,5276,5383,5310,5311,5312,5313,5314,5317,5318,5319,5320,5321,5324,5325,5326,5327,5328,5330,5334,5335,5336,5337,5384}
local gemTexture = {
	"Interface\\ICONS\\INV_jewelcrafting_49",
	"Interface\\ICONS\\INV_jewelcrafting_50",
	"Interface\\ICONS\\INV_jewelcrafting_51",
	"Interface\\ICONS\\INV_jewelcrafting_52",
	"Interface\\ICONS\\INV_jewelcrafting_53",
	"Interface\\ICONS\\INV_jewelcrafting_54"
}

function OItemAnalysisLowGem(itemLink)
	local count = 0;

	for textureCount = 1, 10 do
		if _G["OSocketTooltipTexture"..textureCount] then
			_G["OSocketTooltipTexture"..textureCount]:SetTexture("");
		end
	end 
		
	OgemFrame:SetOwner(UIParent, 'ANCHOR_NONE');
	OgemFrame:ClearLines();
	OgemFrame:SetHyperlink(itemLink);
	local function CheckLowGem(texture)
		for mm = 1, #gemTexture do
			if texture == gemTexture[mm] then return false end
		end
		return true;
	end
	for textureCount = 1, 10 do
		local temp = _G["OSocketTooltipTexture"..textureCount]:GetTexture();		
		if temp and CheckLowGem(temp) then count = count + 1 end 
	end
	OgemFrame:Hide();
	return count;
end

function OTgathertil(guid, unitid)
	local totalIlvl, avgIlvl = 0
	local iter_min, iter_max = 0
	local itemLevel = 0
	local equipType = 0
	local twoHander = nil
	local mia = 0;
	local count = 0
	local missenchant = "";
	local missgem = "";
	local missHenchant = "";
	local missHgem = "";
	local _,armorname,_ = GetAuctionItemClasses()
	oilvlframedata.gear[OTCurrent3] = {};
	for i = 1,17 do
		if(i ~= SHIRT) then
			local item = GetInventoryItemLink(unitid, i)
			if(item) then
				local upgradeID = ItemUpgradeInfo:GetUpgradeID(item)
				local upgrade = ItemUpgradeInfo:GetCurrentUpgrade(upgradeID)
				_,_,_,itemLevel,_,itemClass,_,_,equipType = GetItemInfo(item)
				

				if(itemLevel) then
					count = count + 1
					if(i == WEP) then
						if(equipType == "INVTYPE_2HWEAPON" or equipType == "INVTYPE_RANGED" or equipType == "INVTYPE_RANGEDRIGHT") then
							twoHander = 1
						end
					end

					-- check miss enchant
					local itemID,enchant,_,_,_,_,_ = item:match("item:(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)");
					local ogme=1; -- save for gear missing enchant
					if oenchantItem[i][1] == 1 and enchant == "0" then
						if i ~= 17 then
							if missenchant == "" then
								missenchant = missenchant..oenchantItem[i][2]; 
							else
								missenchant = missenchant..", "..oenchantItem[i][2]; 
							end
							ogme = 0;
						else
							if i == 17 and itemClass ~= armorname and  twoHander ~= 1 then
								if missenchant == "" then
									missenchant = missenchant..oenchantItem[i][2]; 
								else
									missenchant = missenchant..", "..oenchantItem[i][2]; 
								end
								ogme = 0;
							end
						end
					end
					-- check for better enchant
					local ogmHe=1; -- save for gear missing enchant
					local function CheckLowEnchant(eID)
						for mm = 1, #enchantID do 
							if tonumber(eID) == enchantID[mm] then return false end 
						end
						return true
					end
					if oenchantItem[i][1] == 1 and enchant ~= "0" and CheckLowEnchant(enchant) then
						if i ~= 17 then
							if missHenchant == "" then
								missHenchant = missHenchant..oenchantItem[i][2]; 
							else
								missHenchant = missHenchant..", "..oenchantItem[i][2]; 
							end
							ogmHe = 0;
						else
							if i == 17 and itemClass ~= armorname and  twoHander ~= 1 and enchant ~= "0" and CheckLowEnchant(enchant) then
								if missHenchant == "" then
									missHenchant = missHenchant..oenchantItem[i][2]; 
								else
									missHenchant = missHenchant..", "..oenchantItem[i][2]; 
								end
								ogmHe = 0;
							end
						end
					end
					
					-- check missing gems
					local ogmg=1; -- save for gear missing gem
					if OItemAnalysis_CountEmptySockets(item) ~= 0 then
						if missgem == "" then
							missgem = missgem..oenchantItem[i][2]; 
						else
							missgem = missgem..", "..oenchantItem[i][2]; 
						end
						ogmg = 0;
					end
					-- check for better gems
					local ogmHg=1; -- save for gear missing gem
					if OItemAnalysis_CountEmptySockets(item) == 0 and OItemAnalysisLowGem(item) ~= 0 then
						if missHgem == "" then
							missHgem = missHgem..oenchantItem[i][2]; 
						else
							missHgem = missHgem..", "..oenchantItem[i][2]; 
						end
						ogmHg = 0;
					end
					
					if(upgrade == 1) then 
						itemLevel = itemLevel + 4
					elseif(upgrade == 2) then
						itemLevel = itemLevel + 8
					elseif(upgrade == 3) then
						itemLevel = itemLevel + 12
					elseif(upgrade == 4) then
						itemLevel = itemLevel + 16
					end
					-- check HeirLoom
					local trueHilvl, isheirloom = ItemUpgradeInfo:GetHeirloomTrueLevel(item)
					if isheirloom then itemLevel = trueHilvl; end
					if OPvPSet:IsVisible() then
						if OItemAnalysis_CheckPvPGear(item) ~= 0 then
							totalIlvl = totalIlvl + OItemAnalysis_CheckPvPGear(item)
						else
							totalIlvl = totalIlvl + itemLevel
						end
					else
						totalIlvl = totalIlvl + itemLevel
					end
					if itemLevel == nil then itemLevel = "" end
					if item == nil then item = "" end
					oilvlframedata.gear[OTCurrent3][i] = {itemLevel, item, ogme, ogmg, ogmHe, ogmHg, OItemAnalysis_CheckPvPGear(item)}
				end
			end
		end
	end
	
	if count < 15 and twoHander then
		mia = 15-count;	
	end
	if count < 16 and not twoHander then
		mia = 16-count;
	end
	
	if((count == 15) and twoHander) then
		avgIlvl = round(totalIlvl / count,1)
	elseif((count == 16) and not twoHander) then
		avgIlvl = round(totalIlvl / count, 1)
	elseif((count == 16) and twoHander) then
		avgIlvl = round(totalIlvl / 16, 1)
	elseif((count == 15) and not twoHander) then
		avgIlvl = round(totalIlvl / 16, 1)
	else
		avgIlvl = round(totalIlvl / 15, 1)
	end
	-- save player gear to cfg.oilvlgears
	if cfg.oilvlgear ~= nil then cfg.oilvlgear = nil end
	local oname, orealm = UnitFullName("player")
	local oname2 = GetUnitName(unitid, true)
	local oname3, orealm3 = UnitFullName(unitid)
	local altsw = false
	if oname == oname2 and avgIlvl > 0 then
		for i = 1, #cfg.oilvlgears do
			if cfg.oilvlgears[i][1] == oname and cfg.oilvlgears[i][2] == orealm then
				cfg.oilvlgears[i] = {oname,orealm,avgIlvl,oilvlframedata.gear[OTCurrent3]}
				altsw = true
				break;
			end
		end
		if not altsw then
			local i = #cfg.oilvlgears + 1;
			cfg.oilvlgears[i] = {oname,orealm,avgIlvl,oilvlframedata.gear[OTCurrent3]}
		end
	end
	-- cache
	local cachesw = false
	if oname3 and not orealm3 then orealm3 = orealm end
	for i = 1, #cfg.oilvlcache do
		if cfg.oilvlcache[i].oname == oname3 and cfg.oilvlcache[i].orealm == orealm3 and avgIlvl > 0 then
			cfg.oilvlcache[i] = {
				oname = oname3,
				orealm = orealm3,
				oilvl = avgIlvl,
				ogear = oilvlframedata.gear[OTCurrent3],
				oclass = oClassColor(unitid)..UnitClass(unitid),
				otime = time()
			}
			sort(cfg.oilvlcache, function(a,b) return a.otime > b.otime end)
			if #cfg.oilvlcache > 100 then cfg.oilvlcache[#cfg.oilvlcache] = nil; end
			cachesw = true;
			break;
		end
	end
	if not cachesw and oname3 and orealm3 and avgIlvl > 0 then
		local i = #cfg.oilvlcache + 1;
		cfg.oilvlcache[i] = {
			oname = oname3,
			orealm = orealm3,
			oilvl = avgIlvl,
			ogear = oilvlframedata.gear[OTCurrent3],
			oclass = oClassColor(unitid)..UnitClass(unitid),
			otime = time()
		}
		sort(cfg.oilvlcache, function(a,b) return a.otime > b.otime end)
	end
	if #cfg.oilvlcache > 100 then cfg.oilvlcache[#cfg.oilvlcache] = nil; end
return avgIlvl, mia, missenchant, missgem, missHenchant, missHgem;
end

function OTgathertilPvP(r)
	if oilvlframedata.gear[r] == nil or oilvlframedata.gear[r] == "" or oilvlframedata.ilvl[r] == nil or oilvlframedata.ilvl[r] == "" then return nil end
	local totalIlvl, avgIlvl = 0
	local itemLevel = 0
	local twoHander = nil
	local count = 0;
	for i = 1,17 do
		if(i ~= SHIRT) and oilvlframedata.gear[r][i] and oilvlframedata.gear[r][i][1] then
			if OPvPSet:IsVisible() then
				if oilvlframedata.gear[r][i][7] == 0 then
					itemLevel = oilvlframedata.gear[r][i][1];
				else
					itemLevel = oilvlframedata.gear[r][i][7];
				end
			else
				itemLevel = oilvlframedata.gear[r][i][1];
			end
			totalIlvl = totalIlvl + itemLevel
			count = count + 1
			--print(i..":"..itemLevel)
		end
	end
	avgIlvl = round(totalIlvl / count, 1)
	return avgIlvl;
end

function OTgathertilPvPCache(r)
	if cfg.oilvlcache[r].ogear == nil or cfg.oilvlcache[r].ogear == "" or cfg.oilvlcache[r].oilvl == nil or cfg.oilvlcache[r].oilvl == "" then return nil end
	local totalIlvl, avgIlvl = 0
	local itemLevel = 0
	local twoHander = nil
	local count = 0;
	for i = 1,17 do
		if(i ~= SHIRT) and cfg.oilvlcache[r].ogear[i] and cfg.oilvlcache[r].ogear[i][1] then
			if OPvPSet:IsVisible() then
				if cfg.oilvlcache[r].ogear[i][7] == 0 then
					itemLevel = cfg.oilvlcache[r].ogear[i][1];
				else
					itemLevel = cfg.oilvlcache[r].ogear[i][7];
				end
			else
				itemLevel = cfg.oilvlcache[r].ogear[i][1];
			end
			totalIlvl = totalIlvl + itemLevel
			count = count + 1
			--print(i..":"..itemLevel)
		end
	end
	avgIlvl = round(totalIlvl / count, 1)
	return avgIlvl;
end

function oilvlUpdateLDBTooltip()
	if otooltip6 ~= nil then 
		if otooltip6:IsShown() then
			if LibQTip:IsAcquired("OiLvLDB") then otooltip6:Clear() end
			otooltip6:Hide()
			LibQTip:Release(otooltip6)
			otooltip6 = nil
			otooltip6func();
		end
	end						
end

function OTInspect(self,event, ...)
	if UnitAffectingCombat("player") == false and event ~= "PLAYER_LEAVING_WORLD" then
		if event == "INSPECT_READY" then
			if OILVL_Unit ~= "" then
				if CheckInteractDistance(OILVL_Unit, 1) then
					OTilvl, OTmia, missenchant, missgem,  missenchant2, missgem2 = OTgathertil(UnitGUID("OILVL_Unit"),OILVL_Unit)
					if (OTmia == 0) then
						miacount=0;	miaunit[1]="";miaunit[2]="";miaunit[3]="";miaunit[4]="";miaunit[5]="";miaunit[6]="";
						local ntex4 = _G[OTCurrent]:CreateTexture()
						ntex4:SetTexture(0.2,0.2,0.2,0.5)
						ntex4:SetTexCoord(0, 0.625, 0, 0.6875)
						ntex4:SetAllPoints()	
						_G[OTCurrent]:SetNormalTexture(ntex4)
						if missenchant ~= "" or missgem ~= "" then
							oilvlframedata.name[OTCurrent3] = oilvlframedata.name[OTCurrent3]:gsub("!","");
							oilvlframedata.name[OTCurrent3] = "! "..oilvlframedata.name[OTCurrent3]
							oilvlframedata.me[OTCurrent3] = {missenchant,missenchant2};
							oilvlframedata.mg[OTCurrent3] = {missgem,missgem2};
						elseif missenchant2 ~= "" or missgem2 ~= "" then
							oilvlframedata.name[OTCurrent3] = oilvlframedata.name[OTCurrent3]:gsub("~","");
							oilvlframedata.name[OTCurrent3] = "~ "..oilvlframedata.name[OTCurrent3]
							oilvlframedata.me[OTCurrent3] = {missenchant,missenchant2};
							oilvlframedata.mg[OTCurrent3] = {missgem,missgem2};
						else
							oilvlframedata.name[OTCurrent3] = oilvlframedata.name[OTCurrent3]:gsub("!",""):gsub("~","");
							oilvlframedata.me[OTCurrent3] = "";
							oilvlframedata.mg[OTCurrent3] = "";
							oilvlframedata.spec[OTCurrent3] = "";
						end
						if oilvlframedata.name[OTCurrent3] ~= "" then
							_G[OTCurrent]:SetText(oClassColor(OTCurrent2)..oilvlframedata.name[OTCurrent3].."\n|r|cFF00FF00"..OTilvl);
							oilvlframedata.ilvl[OTCurrent3] = OTilvl;
							local temp = ospec[GetInspectSpecialization(OILVL_Unit)];
							if temp ~= nil then oilvlframedata.spec[OTCurrent3] = temp;	else oilvlframedata.spec[OTCurrent3] = ""; end
						end
						oilvlUpdateLDBTooltip();
						OTCurrent = "";
						OTCurrent2 = "";
						OTCurrent3 = "";
						ountrack=true;
						OILVL_Unit="";						
					else
						if OTmia < 3 then
							miacount = miacount + 1
							miaunit[miacount] = UnitGUID("OILVL_Unit");
							if miaunit[1] == miaunit[2] and miaunit[2] == miaunit[3] and miaunit[3] == miaunit[4] and miaunit[4] == miaunit[5] and miaunit[5] == miaunit[6] then
								miacount=0;	miaunit[1]="";miaunit[2]="";miaunit[3]="";miaunit[4]="";miaunit[5]="";miaunit[6]="";
								OILVL_Unit="";
								local ntex4 = _G[OTCurrent]:CreateTexture()
								ntex4:SetTexture(0.2,0.2,0.2,0.5)
								ntex4:SetTexCoord(0, 0.625, 0, 0.6875)
								ntex4:SetAllPoints()	
								_G[OTCurrent]:SetNormalTexture(ntex4)
								if oilvlframedata.name[OTCurrent3] ~= "" then
									_G[OTCurrent]:SetText(oClassColor(OTCurrent2)..oilvlframedata.name[OTCurrent3].."\n|r|cFFFF0000"..OTilvl);
									oilvlframedata.ilvl[OTCurrent3] = OTilvl;
								end
								OTCurrent = "";
								OTCurrent2 = "";
								OTCurrent3 = "";
								ountrack=true;						
							end
						end
					end
				else
					OILVL_Unit="";
					if OTCurrent ~= "" then
						local ntex4 = _G[OTCurrent]:CreateTexture()
						ntex4:SetTexture(0.2,0.2,0.2,0.5)
						ntex4:SetTexCoord(0, 0.625, 0, 0.6875)
						ntex4:SetAllPoints()	
						_G[OTCurrent]:SetNormalTexture(ntex4)
					end
					OTCurrent = "";
					OTCurrent2 = "";
					OTCurrent3 = "";
					ountrack=true;
				end	
			end
			-- GameTooltip		
			if (Omover ==1) and cfg.oilvlms then
				Omover=0;
				if not UnitAffectingCombat("player") and cfg.oilvlms and UnitExists("target") and CheckInteractDistance("target", 1) then
					local oname, _ = GameTooltip:GetUnit();
					if oname ~= nil then oname = oname:gsub("%-.+", ""); else return -1; end
					if oname ~= GetUnitName("target",""):gsub("%-.+", "") then return -1; end
					local OTilvl2, OTmia2, missenchant, missgem = OTgathertil(UnitGUID("target"),"target")
					if (OTmia2 == 0) then
						local i=0;
						local omatch=false;
						local oospec = ospec[GetInspectSpecialization("target")];
						-- spec
						for i = 2, GameTooltip:NumLines() do
							local msg = _G["GameTooltipTextLeft"..i]:GetText();
							if msg then
								msg = msg:find(SPECIALIZATION..":");
							end
							if msg then
								_G["GameTooltipTextLeft"..i]:SetText(SPECIALIZATION..": |r|cFF00FF00"..oospec);
								omatch=true;
								break;
							end
						end	
						if not omatch then
							GameTooltip:SetHeight(GameTooltip:GetHeight()+15);
							GameTooltip:AddLine(SPECIALIZATION..": |r|cFF00FF00"..oospec);	
						end
						-- item level
						omatch=false;
						for i = 2, GameTooltip:NumLines() do
							local msg = _G["GameTooltipTextLeft"..i]:GetText();
							if msg then
								msg = msg:find(L["Item Level"]..":");
							end
							if msg then
								_G["GameTooltipTextLeft"..i]:SetText(L["Item Level"]..": |r|cFF00FF00"..OTilvl2);
								omatch=true;
								break;
							end
						end	
						if not omatch then
							GameTooltip:SetHeight(GameTooltip:GetHeight()+15);
							GameTooltip:AddLine(L["Item Level"]..": |r|cFF00FF00"..OTilvl2);	
						end
					else
						local i=0;
						local omatch=false;
						local oospec = ospec[GetInspectSpecialization("target")];
						-- spec
						for i = 2, GameTooltip:NumLines() do
							local msg = _G["GameTooltipTextLeft"..i]:GetText();
							if msg then
								msg = msg:find("Spec:");
							end
							if msg and oospec ~= nil then
								_G["GameTooltipTextLeft"..i]:SetText(L["Item Level"]..": |r|cFF00FF00"..oospec);
								omatch=true;
								break;
							end
						end	
						if not omatch and oospec ~= nil then
							GameTooltip:SetHeight(GameTooltip:GetHeight()+15);
							GameTooltip:AddLine(L["Item Level"]..":".."|r|cFF00FF00"..oospec);	
						end
						-- item level
						omatch=false;						
						for i = 2, GameTooltip:NumLines() do
							local msg = _G["GameTooltipTextLeft"..i]:GetText();
							if msg then
								msg = msg:find(L["Item Level"]..":");
							end						
							if msg then
								_G["GameTooltipTextLeft"..i]:SetText(L["Item Level"]..": |r|cFFFF0000"..OTilvl2);
								omatch=true;
								break;
							end
						end	
						if not omatch then
							GameTooltip:SetHeight(GameTooltip:GetHeight()+15);
							GameTooltip:AddLine(L["Item Level"]..": |r|cFFFF0000"..OTilvl2);	
						end
						Oilvltimer:ScheduleTimer(OMouseover,1);
					end
				end
			end
			OILVL:UnregisterEvent("INSPECT_READY")
			ClearInspectPlayer()
		end
		
		if event == "INSPECT_ACHIEVEMENT_READY" then
			if cfg.oilvlms then
				if Omover2 == 1 then
					if UnitExists(rpunit) and CheckInteractDistance(rpunit, 1) and rpsw then
						if cfg.oilvlhm then OGetRaidProgression2(highmaulname, OSTATHM, 7); end
						if cfg.oilvlbf then OGetRaidProgression2(bfname, OSTATBF, 10); end
						if cfg.oilvlhfc then OGetRaidProgression2(hfcname, OSTATHFC, 13); end
					else
						OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
						rpsw=false;
						rpunit="";
						Omover2=0;
					end
				else
					if UnitExists("target") and CheckInteractDistance("target", 1)  and rpsw then
						if cfg.oilvlhm then OGetRaidProgression(highmaulname, OSTATHM, 7); end
						if cfg.oilvlbf then OGetRaidProgression(bfname, OSTATBF, 10); end
						if cfg.oilvlhfc then OGetRaidProgression(hfcname, OSTATHFC, 13); end
					else
						OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
						rpsw=false;
						rpunit="";
						Omover2=0;
					end
				end
			end
			OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
			rpsw=false;
			rpunit="";
			Omover2=0;			
		end
		
		if event == "GROUP_ROSTER_UPDATE" then
			--OVILRefresh();
			if oilvlframesw then OResetSendMark(); OilvlCheckFrame(); end
			OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
			rpsw=false;
			rpunit="";
			Omover2=0;
			oilvlUpdateLDBTooltip()
		end
		
		if event == "RAID_ROSTER_UPDATE" then
			--OVILRefresh();
			if oilvlframesw then OResetSendMark(); OilvlCheckFrame(); end
			OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
			rpsw=false;
			rpunit="";
			Omover2=0;
			oilvlUpdateLDBTooltip()
		end
		
		if event == "PLAYER_EQUIPMENT_CHANGED" then
			if oilvlframesw then 
				if IsInRaid() then
					local rnum = GetNumGroupMembers();
					for i = 1, rnum do
						if UnitGUID("player") == oilvlframedata.guid[i] then
							ORfbIlvl(i);
							break;
						end
					end					
				else
					ORfbIlvl(1); 
				end
			end
			OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
			rpsw=false;
			rpunit="";
			Omover2=0;
			oilvlUpdateLDBTooltip()
		end
	end
	
	if event == "VARIABLES_LOADED" then
		cfg = Oilvl_Settings;
		if cfg.oilvlframeP == nil then cfg.oilvlframeP = "TOPLEFT"; end
		if cfg.oilvlframeX == nil then cfg.oilvlframeX = 15; end
		if cfg.oilvlframeY == nil then cfg.oilvlframeY = -60; end
		if cfg.oilvlscale  == nil then cfg.oilvlscale = 0.8; end
		if cfg.oilvlalpha  == nil then cfg.oilvlalpha = 1; end
		if cfg.oilvlhm == nil then cfg.oilvlhm = false; end
		if cfg.oilvlbf == nil then cfg.oilvlbf = false; end
		if cfg.oilvlhfc == nil then cfg.oilvlbf = true; end		
		if cfg.oilvlms == nil then cfg.oilvlms = true; end
		if cfg.oilvlme == nil then cfg.oilvlme = true; end
		if cfg.oilvlme2 == nil then cfg.oilvlme2 = false; end
		if cfg.oilvlcharilvl == nil then cfg.oilvlcharilvl = true; end
		if cfg.oilvlrpdetails == nil then cfg.oilvlrpdetails = true; end
		if cfg.oilvlgears == nil then cfg.oilvlgears = {}; end
		if cfg.oilvlcache == nil then cfg.oilvlcache = {}; end
		--cfg.oilvlcache = {}
	end
		
	if event == "PLAYER_LOGIN" then
		OilvlConfigFrame();
		oilvlframe();
		Oilvltimer:ScheduleTimer(OVILRefresh,2);
		Oilvltimer:ScheduleRepeatingTimer(oilvlcheckrange,2);
		print("O Item Level (|cFFFFFF00OiLvL|r|cFFFFFFFF) |r|cFF00FF00v"..GetAddOnMetadata("Oilvl","Version").." |r|cFFFFFFFF is loaded.")
		print("|cFF00FF00/oi|r|cFFFFFFFF to display |r|cFFFFFF00OiLvL|r|cFFFFFFFF's frame.");
		print("|cFF00FF00/oicfg|r|cFFFFFFFF to display |r|cFFFFFF00OiLvL|r|cFFFFFFFF's configuration frame.");
		ShowUIPanel(InterfaceOptionsFrame);
		InterfaceOptionsFrame.lastFrame = GameMenuFrame;
		InterfaceOptionsFrameTab2:Click();
		InterfaceOptionsFrameCancel:Click();
		HideUIPanel(GameMenuFrame);		
	end
		
	if event == "PLAYER_ENTERING_WORLD" then
		--OVILRefresh();
		if oilvlframesw then Oilvltimer:ScheduleTimer(OilvlCheckFrame,10); end
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		rpsw=false;
		rpunit="";
		Omover2 = 0;
	end
		
	if event == "PLAYER_REGEN_DISABLED" then
		if oilvlframesw then
			local nn=1;
			for nn=1, 40 do
				_G["OILVLRAIDFRAME"..nn]:Disable();
			end
			OILVLREFRESH:Hide();
		end
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		rpsw=false;
		rpunit="";
		Omover2 = 0;
		orollgear = ""
		oilvlUpdateLDBTooltip()
	end
	
	if event == "PLAYER_REGEN_ENABLED" then
		if oilvlframesw then
			local nn=1;
			for nn=1, 40 do
				if not _G["OILVLRAIDFRAME"..nn]  then break; end
				_G["OILVLRAIDFRAME"..nn]:Disable();
				_G["OILVLRAIDFRAME"..nn]:Enable();
			end
			OILVLREFRESH:Show();
			OilvlCheckFrame();
		end
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		rpsw=false;
		rpunit="";
		Omover2 = 0;
		orollgear = ""
		oilvlUpdateLDBTooltip()
	end	
	
	if event == "ROLE_CHANGED_INFORM" then
	local changedPlayer, _, oldrole, role = ...;
		if oilvlframesw then
			if IsInRaid() then
				local rnum = GetNumGroupMembers();
				local i = 1;
				for i = 1, rnum do
					if GetUnitName("raid"..i,true) == changedPlayer then
						OilvlSetRole(i, role);
						if oldrole ~= "NONE" then NumRole[oldrole] = NumRole[oldrole] - 1; end
					end
				end
			elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
				local rnum = GetNumGroupMembers(LE_PARTY_CATEGORY_INSTANCE)
				if GetUnitName("player",true) == changedPlayer then
					OilvlSetRole(1, role);
					if oldrole ~= "NONE" then NumRole[oldrole] = NumRole[oldrole] - 1; end
				end
				local i = 2;
				for i = 2, rnum do
					if GetUnitName("party"..(i-1),true) == changedPlayer then
						OilvlSetRole(i, role);
						if oldrole ~= "NONE" then NumRole[oldrole] = NumRole[oldrole] - 1; end
					end
				end
			elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
				local rnum = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
				if GetUnitName("player",true) == changedPlayer then
					OilvlSetRole(1, role);
					if oldrole ~= "NONE" then NumRole[oldrole] = NumRole[oldrole] - 1; end
				end
				local i = 2;
				for i = 2, rnum do
					if GetUnitName("party"..(i-1),true) == changedPlayer then
						OilvlSetRole(i, role);
						if oldrole ~= "NONE" then NumRole[oldrole] = NumRole[oldrole] - 1; end
					end
				end
			end	
		end
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		rpsw=false;
		rpunit="";
		Omover2=0;
		oilvlUpdateLDBTooltip()
	end
	
	if event =="LFG_ROLE_UPDATE" or event == "PLAYER_SPECIALIZATION_CHANGED" then
		if oilvlframesw then OilvlCheckFrame() end
		if not IsInRaid() and not IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and not IsInGroup(LE_PARTY_CATEGORY_HOME) then
			ORfbIlvl(1);
		end
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		rpsw=false;
		rpunit="";
		Omover2=0;
		oilvlUpdateLDBTooltip()
	end
	
	if event == "LOOT_OPENED" then
		if not elvlootslotSW then oilvlhookelvlootslot(); end
	end
end
	-- Set GameTooltip	
function OMouseover()
	if not UnitExists("target") or not CheckInteractDistance("target", 1) then
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		rpsw=false;
		rpunit="";
		Omover2 = 0;
		return -1;
	end
	if not UnitAffectingCombat("player") and cfg.oilvlms and oilvlframesw then
		if CheckInteractDistance("target", 1) and CanInspect("target") then
			OILVL:RegisterEvent("INSPECT_READY");
			NotifyInspect("target");
			Omover=1;
			if not rpsw then
				ClearAchievementComparisonUnit();
				OILVL:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
				SetAchievementComparisonUnit("target");
				rpunit = "target";
				rpsw=true;
			end
		end
	end
end

function OilvlConfigFrame()
	cfg.frame = CreateFrame("Frame", "OiLvLConfig",InterfaceOptionsFramePanelContainer)
	cfg.frame.name = "O Item Level (OiLvL)"
	InterfaceOptions_AddCategory(cfg.frame)

	local title = cfg.frame:CreateFontString(nil,"ARTWORK","GameFontNormalLarge")
	title:SetPoint("TOPLEFT",16,-16)
	title:SetText("O Item Level (OiLvL) v"..GetAddOnMetadata("Oilvl","Version")) -- can get version from GetAddOnMetadata
	
--  oilvl scale
	local oscale = CreateFrame("Slider", "Oilvlscale", cfg.frame, "OptionsSliderTemplate")
	oscale:SetWidth(200)
	oscale:SetHeight(20)
	oscale:SetOrientation('HORIZONTAL');
	oscale:SetPoint("TOPLEFT",16,-70);
	
	local scaletitle = oscale:CreateFontString(nil,"ARTWORK","GameFontNormal")
	scaletitle:SetPoint("LEFT",oscale,"LEFT",0,35)
	scaletitle:SetText("O Item Level Frame");

	getglobal(oscale:GetName() .. 'Low'):SetText('1'); --Sets the left-side slider text (default is "Low").
	getglobal(oscale:GetName() .. 'High'):SetText('100'); --Sets the right-side slider text (default is "High").
	getglobal(oscale:GetName() .. 'Text'):SetText(L["Scale"]); --Sets the "title" text (top-centre of slider).
	
	oscale:SetMinMaxValues(0, 1);
	oscale:SetValue(cfg.oilvlscale);
	oscale:RegisterForDrag("LeftButton");
	oscale:SetScript("OnDragStop", function(self, button) 
	local n=oscale:GetValue(); 
		if n > 0 then 
			OIVLFRAME:SetScale(n) 
			cfg.oilvlscale = n;
		end
	end);
	oscale:SetScript("OnMouseDown", function(self, button) 
	local n=oscale:GetValue(); 
		if n > 0 then 
			OIVLFRAME:SetScale(n) 
			cfg.oilvlscale = n;
		end
	end);
	
--  oilvl opacity
	local oalpha = CreateFrame("Slider", "Oilvlalpha", cfg.frame, "OptionsSliderTemplate")
	oalpha:SetWidth(200)
	oalpha:SetHeight(20)
	oalpha:SetOrientation('HORIZONTAL');
	oalpha:SetPoint("TOPLEFT",16,-120);
	
	getglobal(oalpha:GetName() .. 'Low'):SetText('0'); --Sets the left-side slider text (default is "Low").
	getglobal(oalpha:GetName() .. 'High'):SetText('1'); --Sets the right-side slider text (default is "High").
	getglobal(oalpha:GetName() .. 'Text'):SetText(OPACITY); --Sets the "title" text (top-centre of slider).
	
	oalpha:SetMinMaxValues(0, 1);
	oalpha:SetValue(cfg.oilvlalpha);
	oalpha:RegisterForDrag("LeftButton");	
	oalpha:SetScript("OnMouseDown", function(self, button) 
	local n=oalpha:GetValue(); 
		OIVLFRAME:SetAlpha(n) 
		cfg.oilvlalpha = n;
	end);
	oalpha:SetScript("OnDragStop", function(self) 
	local n=oalpha:GetValue(); 
		OIVLFRAME:SetAlpha(n) 
		cfg.oilvlalpha = n;
	end);
	
	-- Raid Progression Checkbutton
	local uniquealyzer = 0;
	function createCheckbutton(parent, x_loc, y_loc, displayname)
		uniquealyzer = uniquealyzer + 1;
	
		local checkbutton = CreateFrame("CheckButton", "oicb"..uniquealyzer, parent, "ChatConfigCheckButtonTemplate");
		checkbutton:SetPoint("TOPLEFT", parent, "TOPLEFT", x_loc, y_loc);
		getglobal(checkbutton:GetName() .. 'Text'):SetText(displayname);
		checkbutton:SetHitRectInsets(0,0,0,0);
		return checkbutton;
	end

	-- Tooltips option
	local mscb = createCheckbutton(cfg.frame, 16, -170, " "..L["Enable Showing item level / raid progression on tooltips"]);
	mscb:SetSize(30,30);
	mscb:SetScript("PostClick", function() 
		cfg.oilvlms = oicb1:GetChecked() 
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		rpsw=false;
		rpunit="";
		Omover=0
		Omover2 = 0;
		if oicb1:GetChecked() then
			oicb2:Enable();
			oicb3:Enable();
			oicb4:Enable();
			oicb5:Enable();
		else
			oicb2:Disable();
			oicb3:Disable();
			oicb4:Disable();
			oicb5:Disable();
		end
	end);
	if cfg.oilvlms then mscb:SetChecked(true) end
	
	-- Highmaul check button
	local hmcb = createCheckbutton(cfg.frame, 16+25, -200, " "..highmaulname);
	hmcb:SetSize(30,30);
	hmcb:SetScript("PostClick", function() 
		cfg.oilvlhm = oicb2:GetChecked() 
		if cfg.oilvlhm then 
			oicb3:SetChecked(false) 
			cfg.oilvlbf = false; 
			oicb4:SetChecked(false) 
			cfg.oilvlhfc = false; 
		end
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		rpsw=false;
		rpunit="";
		Omover=0
		Omover2 = 0;		
	end);
	if cfg.oilvlhm then hmcb:SetChecked(true) cfg.oilvlbf = false; cfg.oilvlhfc = false; end

	-- Blackrock Foundry check button
	local bfcb = createCheckbutton(cfg.frame, 120+100, -200, " "..bfname);
	bfcb:SetSize(30,30);
	bfcb:SetScript("PostClick", function() 
		cfg.oilvlbf = oicb3:GetChecked() 
		if cfg.oilvlbf then 
			oicb2:SetChecked(false) 
			cfg.oilvlhm = false; 
			oicb4:SetChecked(false) 
			cfg.oilvlhfc = false; 
		end 
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		rpsw=false;
		rpunit="";
		Omover=0
		Omover2 = 0;		
	end);	
	if cfg.oilvlbf then bfcb:SetChecked(true) cfg.oilvlhm = false; cfg.oilvlhfc = false; end

	-- Hellfire Citadel check button
	local hfccb = createCheckbutton(cfg.frame, 16+25, -230, " "..hfcname);
	hfccb:SetSize(30,30);
	hfccb:SetScript("PostClick", function() 
		cfg.oilvlhfc = oicb4:GetChecked() 
		if cfg.oilvlhfc then 
			oicb2:SetChecked(false) 
			cfg.oilvlhm = false; 
			oicb3:SetChecked(false) 
			cfg.oilvlbf = false; 
		end 
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		rpsw=false;
		rpunit="";
		Omover=0
		Omover2 = 0;		
	end);	
	if cfg.oilvlhfc then hfccb:SetChecked(true) cfg.oilvlhm = false; cfg.oilvlbf = false; end

	-- Raid Progression Details
	local rpdcb = createCheckbutton(cfg.frame, 16+25, -260, " "..L["Enable Showing Raid Progression Details on tooltips"]);
	rpdcb:SetSize(30,30);
	rpdcb:SetScript("PostClick", function() 
		cfg.oilvlrpdetails = oicb5:GetChecked() 
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		rpsw=false;
		rpunit="";
		Omover=0
		Omover2 = 0;	
	end);
	if cfg.oilvlrpdetails then rpdcb:SetChecked(true) end

	if oicb1:GetChecked() then
		oicb2:Enable();
		oicb3:Enable();
		oicb4:Enable();
		oicb5:Enable();
	else
		oicb2:Disable();
		oicb3:Disable();
		oicb4:Disable();
		oicb5:Disable();
	end
	
	-- miss enchant option
	local eercb = createCheckbutton(cfg.frame, 16, -290, " "..L["Enable Sending Enchantment Reminder"]);
	eercb:SetSize(30,30);
	eercb:SetScript("PostClick", function() 
		cfg.oilvlme = oicb6:GetChecked() 
		oilvlercb:SetChecked(cfg.oilvlme) 
		if oicb6:GetChecked() then oicb8:Enable(); else	oicb8:Disable(); end
	end);
	eercb:SetChecked(cfg.oilvlme);

	-- character frame item level option
	local cfilvlcb = createCheckbutton(cfg.frame, 16, -350, " "..L["Enable Showing Gear Item Level on Character Frame"]);
	cfilvlcb:SetSize(30,30);
	cfilvlcb:SetScript("PostClick", function() cfg.oilvlcharilvl = oicb7:GetChecked() OiLvlPlayer_Update() end);
	if cfg.oilvlcharilvl then cfilvlcb:SetChecked(true) end	
	
	-- best enchant option
	local eercb2 = createCheckbutton(cfg.frame, 16+25, -320, " "..BEST.." "..ENSCRIBE);
	eercb2:SetSize(30,30);
	eercb2:SetScript("PostClick", function() cfg.oilvlme2 = oicb8:GetChecked() end);
	eercb2:SetChecked(cfg.oilvlme2);
	if oicb6:GetChecked() then oicb8:Enable(); else	oicb8:Disable(); end
end

function LDB:OnClick(button)
	if button == "LeftButton" then
		if OIVLFRAME:IsShown() then
			OIVLFRAME:Hide();
		else
			OIVLFRAME:ClearAllPoints();
			OIVLFRAME:SetPoint(cfg.oilvlframeP, cfg.oilvlframeX, cfg.oilvlframeY);
			OIVLFRAME:SetScale(cfg.oilvlscale);
			OIVLFRAME:SetAlpha(cfg.oilvlalpha);
			OIVLFRAME:Show();
		end
	end
	if button == "RightButton" then
		PlaySound("igMainMenuOption");
		InterfaceOptionsFrameTab2:Click();
		InterfaceOptionsFrame_OpenToCategory("O Item Level (OiLvL)")
	end
	if button == "MiddleButton" or button == "MiddleButtonDown" then
		if otooltip5 ~= nil then
			if LibQTip:IsAcquired("OiLvLAlt") then otooltip5:Clear() end
			otooltip5:Hide()
			LibQTip:Release(otooltip5)
			otooltip5 = nil
		else
			otooltip5func()
		end
	end
end

--[[Fix for Lua errors with Blizzard_AchievementUI below]]--
local unregistered,reregistered
local function reregisterBlizz()
	if not reregistered then
		AchievementFrameComparison:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
		reregistered=true
	end
end
local function unregisterBlizz(name)
	if not unregistered then
		if not name or name=="Blizzard_AchievementUI" then
			AchievementFrameComparison:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")
			hooksecurefunc("InspectAchievements",reregisterBlizz)
			unregistered=true
		end
	end
end
if IsAddOnLoaded("Blizzard_AchievementUI") then
	unregisterBlizz()
else
	hooksecurefunc("LoadAddOn",unregisterBlizz)
end
------------------------------------------------------------------

GameTooltip:HookScript("OnTooltipSetUnit", function() 
--	print("OnTooltipSetUnit");
	if not UnitAffectingCombat("player") and cfg.oilvlms and UnitExists("target") then
		local oname, _ = GameTooltip:GetUnit()
		if oname ~= nil then oname = oname:gsub("%-.+", ""); else return -1; end
		if  oname == GetUnitName("target",""):gsub("%-.+", "") then
			OMouseover();
		end
	end 
end); 

for i = 1, LOOTFRAME_NUMBUTTONS do
	_G["LootButton"..i]:HookScript("OnClick", function(self, button)
		if IsAltKeyDown() then 
			local link = GetLootSlotLink(i);
			local scantip = CreateFrame("GameTooltip", "OiLvlRoll_Tooltip", nil, "GameTooltipTemplate")
			local silvl="";
			orollgear = link;
			scantip:SetOwner(UIParent, "ANCHOR_NONE")
			scantip:SetHyperlink(orollgear)
			for i = 2, scantip:NumLines() do
				local text = _G["OiLvlRoll_TooltipTextLeft"..i]:GetText()
				if text and text ~= "" then	silvl = text:match(ITEM_LEVEL:gsub("%%d","(%%d+)")) end
				if silvl ~= nil then break end
			end
			if silvl == nil then silvl = "" end
			if UnitIsGroupLeader("player") then 
				ChatFrame_OpenChat("/rw "..silvl.." "..link.." "..ROLL.." ")
			end
			if otooltip4 ~= nil then
				otooltip4:Hide() 
				LibQTip:Release(otooltip4)
				otooltip4 = nil
			end
			orolln = 0;
			oroll = {};
			orolln = orolln + 1;
			oroll[1] = {silvl,link,""}
			otooltip4func();
		else
			orollgear = "";			
		end
	end)
end

function oilvlhookelvlootslot()
for i = 1, 6 do
	if _G["ElvLootSlot"..i] then
		elvlootslotSW = true;
		_G["ElvLootSlot"..i]:HookScript("OnClick", function(button)
			if IsAltKeyDown() then
				local link = GetLootSlotLink(i)
				if IsAltKeyDown() then 
					local link = GetLootSlotLink(i);
					local scantip = CreateFrame("GameTooltip", "OiLvlRoll_Tooltip", nil, "GameTooltipTemplate")
					local silvl="";
					orollgear = link;
					scantip:SetOwner(UIParent, "ANCHOR_NONE")
					scantip:SetHyperlink(orollgear)
					for i = 2, scantip:NumLines() do
						local text = _G["OiLvlRoll_TooltipTextLeft"..i]:GetText()
						if text and text ~= "" then	silvl = text:match(ITEM_LEVEL:gsub("%%d","(%%d+)")) end
						if silvl ~= nil then break end
					end
					if silvl == nil then silvl = "" end
					if UnitIsGroupLeader("player") then 
						ChatFrame_OpenChat("/rw "..silvl.." "..link.." "..ROLL.." ")
					end
					if otooltip4 ~= nil then
						otooltip4:Hide() 
						LibQTip:Release(otooltip4)
						otooltip4 = nil
					end
					orolln = 0;
					oroll = {};
					orolln = orolln + 1;
					oroll[1] = {silvl,link,""}
					otooltip4func();
				else
					orollgear = "";			
				end
			end
		end)
	end
end
end

GameTooltip:HookScript("OnHide", function(self) 
	if otooltip ~= nil then
		LibQTip:Release(otooltip)
		otooltip = nil
	end
end)

SLASH_OILVL_OILVL1 = "/oilvl"
SLASH_OILVL_OILVL2 = "/oi"

SlashCmdList["OILVL_OILVL"] = function()
	OIVLFRAME:ClearAllPoints();
	OIVLFRAME:SetPoint(cfg.oilvlframeP, cfg.oilvlframeX, cfg.oilvlframeY);
	OIVLFRAME:SetScale(cfg.oilvlscale);
	OIVLFRAME:SetAlpha(cfg.oilvlalpha);
	OIVLFRAME:Show();
end

SLASH_OILVL_OICFG1 = "/oicfg"

SlashCmdList["OILVL_OICFG"] = function()
	InterfaceOptionsFrameTab2:Click();
	InterfaceOptionsFrame_OpenToCategory("O Item Level (OiLvL)")
end

SLASH_OILVL_OIROLL1 = "/oiroll"
SLASH_OILVL_OIROLL2 = "/oir"

SlashCmdList["OILVL_OIROLL"] = function(msg)
	if msg:match("|c.*|r") ~= nil then
		local scantip = CreateFrame("GameTooltip", "OiLvlRoll_Tooltip", nil, "GameTooltipTemplate")
		local silvl="";
		orollgear = msg:match("|c.*|r");
		scantip:SetOwner(UIParent, "ANCHOR_NONE")
		scantip:SetHyperlink(orollgear)
		for i = 2, scantip:NumLines() do
			local text = _G["OiLvlRoll_TooltipTextLeft"..i]:GetText()
			if text and text ~= "" then	silvl = text:match(ITEM_LEVEL:gsub("%%d","(%%d+)")) end
			if silvl ~= nil then break end
		end
		if silvl == nil then silvl = "" end
		if UnitIsGroupLeader("player") then 
			SendChatMessage(ROLL.." "..silvl.." "..msg:match("|c.*|r").." "..msg:gsub("|c.*|r","").."", "RAID_WARNING")
		end		
		if otooltip4 ~= nil then
			otooltip4:Hide()
			LibQTip:Release(otooltip4)
			otooltip4 = nil
		end
		orolln = 0;
		oroll = {};
		orolln = orolln + 1;
		oroll[1] = {silvl,msg:match("|c.*|r"),msg:gsub("|c.*|r","")}
		otooltip4func();
	else
		orollgear = "";
	end
end

SLASH_OILVL_OIALT1 = "/oialt"
SLASH_OILVL_OIALT2 = "/oia"
SlashCmdList["OILVL_OIALT"] = function(msg)  otooltip5func() end

SLASH_OILVL_OICACHE1 = "/oicache"
SLASH_OILVL_OICACHE2 = "/oic"
SlashCmdList["OILVL_OICACHE"] = function(msg)  otooltip7func() end


DEFAULT_CHAT_FRAME:HookScript("OnHyperlinkClick", function(self, linkData, link, button)
	if IsAltKeyDown() then
		local scantip = CreateFrame("GameTooltip", "OiLvlRoll_Tooltip", nil, "GameTooltipTemplate")
		local silvl="";
		orollgear = link;
		scantip:SetOwner(UIParent, "ANCHOR_NONE")
		scantip:SetHyperlink(orollgear)
		for i = 2, scantip:NumLines() do
			local text = _G["OiLvlRoll_TooltipTextLeft"..i]:GetText()
			if text and text ~= "" then	silvl = text:match(ITEM_LEVEL:gsub("%%d","(%%d+)")) end
			if silvl ~= nil then break end
		end
		if silvl == nil then silvl = "" end
		if UnitIsGroupLeader("player") then 
			SendChatMessage(ROLL.." "..silvl.." "..link, "RAID_WARNING")
		end
		if otooltip4 ~= nil then
			otooltip4:Hide() 
			LibQTip:Release(otooltip4)
			otooltip4 = nil
		end
		orolln = 0;
		oroll = {};
		orolln = orolln + 1;
		oroll[1] = {silvl,link,""}
		otooltip4func();
	else
		orollgear = "";
	end
end)

-- check who roll the gear
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(frame, event, message)
	-- Thank for eglohpri's help.
	if GetLocale() == 'deDE' then RANDOM_ROLL_RESULT = "%s w\195\188rfelt. Ergebnis: %d (%d-%d)" end
	local name, proll = message:match(RANDOM_ROLL_RESULT:gsub( "%%s", "(.+)" ):gsub( "%%d %(%%d%-%%d%)", "(%%d+).*" ))
	proll = tonumber(proll)
	local ochecksamename = false;
	for m = 1, #oroll do
		if oroll[m][1] == name then ochecksamename = true break end
	end
	if name and orollgear ~= "" and not ochecksamename then
		local _, _, _, _, _, _, _, _, equipSlot, _, _ = GetItemInfo(orollgear)
		for i = 1, 40 do
			if oilvlframedata.name[i] == nil then break end
			if oilvlframedata.name[i] == name or oilvlframedata.name[i] == "! "..name or oilvlframedata.name[i] == "~ "..name then
				if gslot[equipSlot] ~= nil then
					if oilvlframedata.gear[i][gslot[equipSlot]] == nil then 
						orolln = orolln + 1; oroll[orolln] = {name,proll,"","","",""} otooltip4func();
						break 
					end
					if oilvlframedata.gear[i][gslot[equipSlot]][1] == nil then 
						orolln = orolln + 1; oroll[orolln] = {name,proll,"","","",""} otooltip4func();
						break 
					end
					if oilvlframedata.gear[i][gslot[equipSlot]][1] ~= nil then
						if gslot[equipSlot] == 11 then
							orolln = orolln + 1;
							oroll[orolln] = {
								name,
								proll,
								oilvlframedata.gear[i][11][1],
								oilvlframedata.gear[i][11][2],
								oilvlframedata.gear[i][12][1],
								oilvlframedata.gear[i][12][2]
							}
							otooltip4func();
							break;
						elseif gslot[equipSlot] == 13 then
							orolln = orolln + 1;
							oroll[orolln] = {
								name,
								proll,
								oilvlframedata.gear[i][13][1],
								oilvlframedata.gear[i][13][2],
								oilvlframedata.gear[i][14][1],
								oilvlframedata.gear[i][14][2]
							}
							otooltip4func();
							break;
						else
							orolln = orolln + 1;
							oroll[orolln] = {
								name,
								proll,
								oilvlframedata.gear[i][gslot[equipSlot]][1],
								oilvlframedata.gear[i][gslot[equipSlot]][2],
								"",
								""
							}
							otooltip4func();
							break;
						end
					end
					break;
				else
					orolln = orolln + 1; oroll[orolln] = {name,proll,"","","",""} otooltip4func();break;
				end
			end
		end
	end
end)

-- fix No player named XYZ is currently playing error.
local function SystemSpamFilter(frame, event, message)
	if message:match(string.format(ERR_CHAT_PLAYER_NOT_FOUND_S, "(.+)")) then
		return true
	end	
    return false
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", SystemSpamFilter)
	
OILVL:SetScript("OnEvent", OTInspect)
OILVL:RegisterEvent("PLAYER_LEAVING_WORLD");
OILVL:RegisterEvent("GROUP_ROSTER_UPDATE");
OILVL:RegisterEvent("RAID_ROSTER_UPDATE");
OILVL:RegisterEvent("VARIABLES_LOADED");
OILVL:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
OILVL:RegisterEvent("PLAYER_LOGIN");
OILVL:RegisterEvent("PLAYER_ENTERING_WORLD");
OILVL:RegisterEvent("PLAYER_REGEN_DISABLED");
OILVL:RegisterEvent("PLAYER_REGEN_ENABLED");
OILVL:RegisterEvent("ROLE_CHANGED_INFORM");
OILVL:RegisterEvent("LFG_ROLE_UPDATE");
OILVL:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
OILVL:RegisterEvent("LOOT_OPENED");