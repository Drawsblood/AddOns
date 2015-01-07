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
--LUA
local unpack        = unpack;
local select        = select;
local pairs         = pairs;
local type          = type;
local rawset        = rawset;
local rawget        = rawget;
local tostring      = tostring;
local error         = error;
local next          = next;
local pcall         = pcall;
local getmetatable  = getmetatable;
local setmetatable  = setmetatable;
local assert        = assert;
--BLIZZARD
local _G            = _G;
local tinsert       = _G.tinsert;
local tremove       = _G.tremove;
local twipe         = _G.wipe;
--STRING
local string        = string;
local upper         = string.upper;
local format        = string.format;
local find          = string.find;
local match         = string.match;
local gsub          = string.gsub;
--MATH
local math          = math;
local floor         = math.floor
local ceil         	= math.ceil
--TABLE
local table         = table;
local tsort         = table.sort;
local tremove       = table.remove;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local oUF_Villain = SV.oUF

assert(oUF_Villain, "SVUI was unable to locate oUF.");

local L = SV.L;
local LSM = LibStub("LibSharedMedia-3.0")
local MOD = SV.SVUnit

if(not MOD) then return end 

local AURA_FONT = [[Interface\AddOns\SVUI\assets\fonts\Numbers.ttf]];
local AURA_FONTSIZE = 11;
local AURA_OUTLINE = "OUTLINE";
local BASIC_TEXTURE = [[Interface\AddOns\SVUI\assets\artwork\Bars\DEFAULT]];
local shadowTex = [[Interface\AddOns\SVUI\assets\artwork\Template\GLOW]];
local counterOffsets = {
	["TOPLEFT"] = {6, 1}, 
	["TOPRIGHT"] = {-6, 1}, 
	["BOTTOMLEFT"] = {6, 1}, 
	["BOTTOMRIGHT"] = {-6, 1}, 
	["LEFT"] = {6, 1}, 
	["RIGHT"] = {-6, 1}, 
	["TOP"] = {0, 0}, 
	["BOTTOM"] = {0, 0}, 
}
local textCounterOffsets = {
	["TOPLEFT"] = {"LEFT", "RIGHT", -2, 0}, 
	["TOPRIGHT"] = {"RIGHT", "LEFT", 2, 0}, 
	["BOTTOMLEFT"] = {"LEFT", "RIGHT", -2, 0}, 
	["BOTTOMRIGHT"] = {"RIGHT", "LEFT", 2, 0}, 
	["LEFT"] = {"LEFT", "RIGHT", -2, 0}, 
	["RIGHT"] = {"RIGHT", "LEFT", 2, 0}, 
	["TOP"] = {"RIGHT", "LEFT", 2, 0}, 
	["BOTTOM"] = {"RIGHT", "LEFT", 2, 0}, 
}

local CanSteal = (SV.class == "MAGE");
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local AuraIcon_OnClick = function(self)
	if not IsShiftKeyDown() then return end 
	local name = self.name;
	if name then 
		SV:AddonMessage((L["The spell '%s' has been added to the BlackList unitframe aura filter."]):format(name))
		SV.filters["BlackList"][name] = {["enable"] = true}
		MOD:RefreshUnitFrames()
	end
end

local AuraIcon_OnEnter = function(self)
	if(not self:IsVisible()) then return end

	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
	self:UpdateTooltip()
end

local AuraIcon_OnLeave = function()
	GameTooltip:Hide()
end

local Aura_UpdateTooltip = function(self)
	GameTooltip:SetUnitAura(self.parent.__owner.unit, self:GetID(), self.filter)
end

local _hook_AuraBGBorderColor = function(self, ...) self.bg:SetBackdropBorderColor(...) end

local CreateAuraIcon = function(icons, index)
	local baseSize = icons.size or 16
	local aura = CreateFrame("Button", nil, icons)
	aura:RemoveTextures()
	aura:EnableMouse(true)
	aura:RegisterForClicks('RightButtonUp')

	aura:SetWidth(baseSize)
	aura:SetHeight(baseSize)

	aura:SetBackdrop({
    	bgFile = [[Interface\BUTTONS\WHITE8X8]], 
		tile = false, 
		tileSize = 0, 
		edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
        edgeSize = 1, 
        insets = {
            left = 0, 
            right = 0, 
            top = 0, 
            bottom = 0
        }
    })
    aura:SetBackdropColor(0, 0, 0, 0)
    aura:SetBackdropBorderColor(0, 0, 0)

    local bg = CreateFrame("Frame", nil, aura)
    bg:SetFrameStrata("BACKGROUND")
    bg:SetFrameLevel(0)
    bg:SetAllPointsOut(aura, 2, 2)
    bg:SetBackdrop({
    	bgFile = [[Interface\BUTTONS\WHITE8X8]], 
		tile = false, 
		tileSize = 0, 
		edgeFile = [[Interface\AddOns\SVUI\assets\artwork\Template\GLOW]], 
        edgeSize = 1, 
        insets = {
            left = 1, 
            right = 1, 
            top = 1, 
            bottom = 1
        }
    })
    bg:SetBackdropColor(0, 0, 0, 0)
    bg:SetBackdropBorderColor(0, 0, 0, 0)
    aura.bg = bg;

    --hooksecurefunc(aura, "SetBackdropBorderColor", _hook_AuraBGBorderColor)

    local fontgroup = "unitauralarge";
    if(baseSize < 18) then
    	fontgroup = "unitaurasmall";
    elseif(baseSize < 24) then
    	fontgroup = "unitauramedium";
    end
    --print(baseSize)
    --print(fontgroup)

	local cd = CreateFrame("Cooldown", nil, aura, "CooldownFrameTemplate");
	cd:SetAllPointsIn(aura, 1, 1);
	cd.noOCC = true;
	cd.noCooldownCount = true;
	cd:SetReverse(true);
	cd:SetHideCountdownNumbers(true);

	local fg = CreateFrame("Frame", nil, aura)
    fg:SetAllPointsOut(aura, 2, 2)

	local text = fg:CreateFontString(nil, 'OVERLAY');
	text:FontManager(fontgroup);
	text:SetPoint('CENTER', aura, 'CENTER', 1, 1);
	text:SetJustifyH('CENTER');

	local count = fg:CreateFontString(nil, "OVERLAY");
	count:FontManager(fontgroup);
	count:SetPoint("CENTER", aura, "BOTTOMRIGHT", -3, 3);

	local icon = aura:CreateTexture(nil, "BACKGROUND");
	icon:SetAllPoints(aura);
	icon:SetAllPointsIn(aura, 1, 1);
    icon:SetTexCoord(0.1, 0.9, 0.1, 0.9);

	local overlay = aura:CreateTexture(nil, "OVERLAY");
	overlay:SetAllPointsIn(aura, 1, 1);
	overlay:SetTexture(BASIC_TEXTURE);
	overlay:SetVertexColor(0, 0, 0);
	overlay:Hide();

	-- local stealable = aura:CreateTexture(nil, 'OVERLAY')
	-- stealable:SetTexture(0,0,0,0)
	-- stealable:SetPoint('TOPLEFT', -3, 3)
	-- stealable:SetPoint('BOTTOMRIGHT', 3, -3)
	-- aura.stealable = stealable

	aura.UpdateTooltip = Aura_UpdateTooltip;
	aura:SetScript("OnEnter", AuraIcon_OnEnter);
	aura:SetScript("OnLeave", AuraIcon_OnLeave);
	aura:SetScript("OnClick", AuraIcon_OnClick);

	tinsert(icons, aura);

	aura.parent = icons;
	aura.cd = cd;
	aura.text = text;
	aura.icon = icon;
	aura.count = count;
	aura.overlay = overlay;

	return aura
end

local UpdateAuraTimer = function(self, elapsed)
	self.expiration = self.expiration - elapsed;

	if(self.nextUpdate > 0) then 
		self.nextUpdate = self.nextUpdate - elapsed;
		return;
	end

	if(self.expiration <= 0) then 
		self:SetScript("OnUpdate", nil)
		self.text:SetText('')
		return;
	end

	local expires = self.expiration;
	local calc, timeLeft = 0, 0;
	local timeFormat;
	if expires < 60 then 
		if expires >= 4 then
			timeLeft = floor(expires)
			timeFormat = "|cffffff00%d|r"
			self.nextUpdate = 0.51
		else
			timeLeft = expires
			timeFormat = "|cffff0000%.1f|r"
			self.nextUpdate = 0.051
		end 
	elseif expires < 3600 then
		timeFormat = "|cffffffff%d|r|cffCC8811m|r"
		timeLeft = ceil(expires / 60);
		calc = floor((expires / 60) + 0.5);
		self.nextUpdate = calc > 1 and ((expires - calc) * 29.5) or (expires - 59.5);
	elseif expires < 86400 then
		timeFormat = "|cff66ffff%d|r|cffAA5511h|r"
		timeLeft = ceil(expires / 3600);
		calc = floor((expires / 3600) + 0.5);
		self.nextUpdate = calc > 1 and ((expires - calc) * 1799.5) or (expires - 3570);
	else
		timeFormat = "|cff6666ff%d|r|cff991100d|r"
		timeLeft = ceil(expires / 86400);
		calc = floor((expires / 86400) + 0.5);
		self.nextUpdate = calc > 1 and ((expires - calc) * 43199.5) or (expires - 86400);
	end

	self.text:SetFormattedText(timeFormat, timeLeft)
end 

local PostUpdateAuraIcon = function(self, unit, button, index, offset)
	local name, _, _, _, dtype, duration, expiration, _, isStealable = UnitAura(unit, index, button.filter)
	local isFriend = (UnitIsFriend('player', unit) == 1) and true or false
	if button.isDebuff then
		if(not isFriend and button.owner and button.owner ~= "player" and button.owner ~= "vehicle") then
			button:SetBackdropBorderColor(0.9, 0.1, 0.1, 1)
			button.bg:SetBackdropColor(1, 0, 0, 1)
			button.bg:SetBackdropBorderColor(0, 0, 0, 1)
			button.icon:SetDesaturated((unit and not unit:find('arena%d')) and true or false)
		else
			local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
			if (name == "Unstable Affliction" or name == "Vampiric Touch") and SV.class ~= "WARLOCK" then
				button:SetBackdropBorderColor(0.05, 0.85, 0.94, 1)
				button.bg:SetBackdropColor(0, 0.9, 1, 1)
				button.bg:SetBackdropBorderColor(0, 0, 0, 1)
			else
				button:SetBackdropBorderColor(color.r * 0.6, color.g * 0.6, color.b * 0.6, 1)
				button.bg:SetBackdropColor(color.r, color.g, color.b, 1)
				button.bg:SetBackdropBorderColor(0, 0, 0, 1)
			end
			button.icon:SetDesaturated(false)
		end
	else
		if (isStealable) and not isFriend then
			button:SetBackdropBorderColor(0.92, 0.91, 0.55, 1)
			button.bg:SetBackdropColor(1, 1, 0.5, 1)
			button.bg:SetBackdropBorderColor(0, 0, 0, 1)
		else
			button:SetBackdropBorderColor(0, 0, 0, 1)
			button.bg:SetBackdropColor(0, 0, 0, 0)
			button.bg:SetBackdropBorderColor(0, 0, 0, 0)		
		end	
	end

	local size = button:GetParent().size
	if size then
		button:SetSizeToScale(size)
	end
	
	button.spell = name
	button.isStealable = isStealable
	if(expiration and duration ~= 0) then
		if(not button:GetScript('OnUpdate')) then
			button.expirationTime = expiration
			button.expiration = expiration - GetTime()
			button.nextUpdate = -1
			button:SetScript('OnUpdate', UpdateAuraTimer)
		elseif(button.expirationTime ~= expiration) then
			button.expirationTime = expiration
			button.expiration = expiration - GetTime()
			button.nextUpdate = -1
		end
	end	
	if((duration == 0) or (expiration == 0)) then
		button:SetScript('OnUpdate', nil)
		button.text:SetText('')
	end
end


--[[ AURABAR HANDLERS ]]--

local AuraBar_OnClick = function(self)
	if not IsShiftKeyDown() then return end 
	local name = self:GetParent().aura.name
	if name then 
		SV:AddonMessage((L["The spell '%s' has been added to the BlackList unitframe aura filter."]):format(name))
		SV.filters["BlackList"][name] = {["enable"] = true}
		MOD:RefreshUnitFrames()
	end 
end

local PostCreateAuraBars = function(self)
	self.spelltime = self:CreateFontString(nil, 'ARTWORK')
	self.spelltime:FontManager("unitauramedium")
	self.spelltime:SetTextColor(1 ,1, 1)
	self.spelltime:SetShadowOffset(1, -1)
  	self.spelltime:SetShadowColor(0, 0, 0)
	self.spelltime:SetJustifyH'RIGHT'
	self.spelltime:SetJustifyV'CENTER'
	self.spelltime:SetPoint'RIGHT'

	self.spellname = self:CreateFontString(nil, 'ARTWORK')
	self.spellname:FontManager("unitaurabar")
	self.spellname:SetTextColor(1, 1, 1)
	self.spellname:SetShadowOffset(1, -1)
  	self.spellname:SetShadowColor(0, 0, 0)
	self.spellname:SetJustifyH'LEFT'
	self.spellname:SetJustifyV'CENTER'
	self.spellname:SetPoint'LEFT'
	self.spellname:SetPoint('RIGHT', self.spelltime, 'LEFT')
	self.iconHolder:RegisterForClicks("RightButtonUp")
	self.iconHolder:SetScript("OnClick", AuraBar_OnClick)
end 

local ColorizeAuraBars = function(self)
	local bars = self.bars;
	for i = 1, #bars do 
		local auraBar = bars[i]
		if not auraBar:IsVisible()then break end 
		local color
		local spellName = auraBar.statusBar.aura.name;
		local spellID = auraBar.statusBar.aura.spellID;
		if(SV.filters["Defense"][spellName]) then 
			color = oUF_Villain.colors.shield_bars
		elseif(SV.db.media.unitframes.spellcolor[spellName]) then
			color = SV.db.media.unitframes.spellcolor[spellName]
		end 
		if color then 
			auraBar.statusBar:SetStatusBarColor(unpack(color))
			auraBar:SetBackdropColor(color[1] * 0.25, color[2] * 0.25, color[3] * 0.25, 0.5)
		else
			local r, g, b = auraBar.statusBar:GetStatusBarColor()
			auraBar:SetBackdropColor(r * 0.25, g * 0.25, b * 0.25, 0.5)
		end 
	end 
end

--[[ AURA FILTERING ]]--

local CommonAuraFilter = function(self, unit, icon, auraName, _, _, _, debuffType, duration, _, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossAura)
	local db = SV.db.SVUnit[self.___key]
	local auraType = self.type;
	if(not auraType) then return true end 
	if((not db) or (db and not db[auraType])) then 
		return false;
	end
	local auraDB = db[auraType];
	local isPlayer = caster == "player" or caster == "vehicle";
	local isEnemy = UnitIsEnemy("player", unit);

	icon.isPlayer = isPlayer;
	icon.priority = 0;
	icon.owner = caster;
	icon.name = auraName;

	if(auraDB.filterWhiteList and (not SV.filters.WhiteList[auraName])) then
		return false;
	elseif(SV.filters.BlackList[auraName] and SV.filters.BlackList[auraName].enable) then
		return false;
	else
		if(auraDB.filterPlayer and (not isPlayer)) then
			return false
		end

		if(auraDB.filterDispellable and (debuffType and not MOD.Dispellable[debuffType])) then 
			return false
		end

		if(auraDB.filterRaid and shouldConsolidate) then 
			return false 
		end

		if(auraDB.filterInfinite and ((not duration) or (duration and duration == 0))) then 
			return false 
		end

		local active = auraDB.useFilter
		if(active and SV.filters[active]) then
			local spellDB = SV.filters[active];
			if(spellDB[auraName] and spellDB[auraName].enable) then
				return false
			end  
		end
	end
  	return true
end

local CommonBarFilter = function(self, unit, auraName, _, _, _, debuffType, duration, _, caster, isStealable, shouldConsolidate, spellID)
	local db = SV.db.SVUnit[self.___key]
	if((not db) or (db and not db.aurabar)) then 
		return false;
	end
	local auraDB = db.aurabar;
	local isPlayer = caster == "player" or caster == "vehicle";
	local isEnemy = UnitIsEnemy("player", unit);

	if(auraDB.filterWhiteList and (not SV.filters.WhiteList[auraName])) then
		return false;
	elseif(SV.filters.BlackList[auraName] and SV.filters.BlackList[auraName].enable) then
		return false
	else
		if(auraDB.filterPlayer and (not isPlayer)) then
			return false
		end

		if(auraDB.filterDispellable and (debuffType and not MOD.Dispellable[debuffType])) then 
			return false
		end

		if(auraDB.filterRaid and shouldConsolidate) then 
			return false 
		end

		if(auraDB.filterInfinite and ((not duration) or (duration and duration == 0))) then 
			return false 
		end

		local active = auraDB.useFilter
		if(active and SV.filters[active]) then
			local spellDB = SV.filters[active];
			if(spellDB[auraName] and spellDB[auraName].enable) then
				return false
			end  
		end
	end
  	return true
end

--[[ DETAILED AURA FILTERING ]]--

local function filter_test(setting, isEnemy)
	if((not setting) or (setting and type(setting) ~= "table")) then 
		return false;
	end
	if((setting.enemy and isEnemy) or (setting.friendly and (not isEnemy))) then 
	  return true;
	end
  	return false 
end

local DetailedAuraFilter = function(self, unit, icon, auraName, _, _, _, debuffType, duration, _, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossAura)
	local db = SV.db.SVUnit[self.___key]
	local auraType = self.type;
	if(not auraType) then return true end 
	if((not db) or (db and not db[auraType])) then 
		return false;
	end
	local auraDB = db[auraType]
	local isPlayer = caster == "player" or caster == "vehicle"
	local isEnemy = UnitIsEnemy("player", unit);

	icon.isPlayer = isPlayer;
	icon.priority = 0;
	icon.owner = caster;
	icon.name = auraName;

	if(filter_test(auraDB.filterAll, isEnemy)) then
		return false
	elseif(filter_test(auraDB.filterWhiteList, isEnemy) and (not SV.filters.WhiteList[auraName])) then
		return false;
	elseif(SV.filters.BlackList[auraName] and SV.filters.BlackList[auraName].enable) then
		return false
	else
		if(filter_test(auraDB.filterPlayer, isEnemy) and (not isPlayer)) then
			return false
		end
		if(filter_test(auraDB.filterDispellable, isEnemy)) then
			if((CanSteal and (auraType == 'buffs' and isStealable)) or (debuffType and (not MOD.Dispellable[debuffType])) or (not debuffType)) then
				return false
			end
		end
		if(filter_test(auraDB.filterRaid, isEnemy) and shouldConsolidate) then 
			return false 
		end
		if(filter_test(auraDB.filterInfinite, isEnemy) and ((not duration) or (duration and duration == 0))) then 
			return false 
		end
		local active = auraDB.useFilter
		if(active and SV.filters[active]) then
			local spellDB = SV.filters[active];
			if(spellDB[auraName] and spellDB[auraName].enable) then
				return false
			end  
		end
	end
  	return true 
end

local DetailedBarFilter = function(self, unit, auraName, _, _, _, debuffType, duration, _, caster, isStealable, shouldConsolidate, spellID)
	local db = SV.db.SVUnit[self.___key]
	if((not db) or (db and not db.aurabar)) then 
		return false;
	end
	local auraDB = db.aurabar;
	local isPlayer = caster == "player" or caster == "vehicle";
	local isEnemy = UnitIsEnemy("player", unit);

	if(filter_test(auraDB.filterAll, isEnemy)) then
		return false
	elseif(filter_test(auraDB.filterWhiteList, isEnemy) and (not SV.filters.WhiteList[auraName])) then
		return false;
	elseif(SV.filters.BlackList[auraName] and SV.filters.BlackList[auraName].enable) then
		return false
	else
		if(filter_test(auraDB.filterPlayer, isEnemy) and (not isPlayer)) then
			return false
		end
		if(filter_test(auraDB.filterDispellable, isEnemy) and (debuffType and not MOD.Dispellable[debuffType])) then 
			return false
		end
		if(filter_test(auraDB.filterRaid, isEnemy) and shouldConsolidate) then 
			return false 
		end
		if(filter_test(auraDB.filterInfinite, isEnemy) and ((not duration) or (duration and duration == 0))) then 
			return false 
		end
		local active = auraDB.useFilter
		if(active and SV.filters[active]) then
			local spellDB = SV.filters[active];
			if(spellDB[auraName] and spellDB[auraName].enable) then
				return false
			end  
		end
	end
  	return true 
end

--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
local BoolFilters = {
	['player'] = true,
	['pet'] = true,
	['boss'] = true,
	['arena'] = true,
	['party'] = true,
	['raid'] = true,
	['raidpet'] = true,	
};

function MOD:CreateBuffs(frame, unit)
	local aura = CreateFrame("Frame", nil, frame)
	aura.___key = unit
	aura.spacing = 2;
	aura.CreateIcon = CreateAuraIcon;
	aura.PostUpdateIcon = PostUpdateAuraIcon;
	if(BoolFilters[unit]) then
		aura.CustomFilter = CommonAuraFilter;
	else
		aura.CustomFilter = DetailedAuraFilter;
	end
	aura:SetFrameLevel(10)
	aura.type = "buffs"
	return aura 
end 

function MOD:CreateDebuffs(frame, unit)
	local aura = CreateFrame("Frame", nil, frame)
	aura.___key = unit
	aura.spacing = 2;
	aura.CreateIcon = CreateAuraIcon;
	aura.PostUpdateIcon = PostUpdateAuraIcon;
	if(BoolFilters[unit]) then
		aura.CustomFilter = CommonAuraFilter;
	else
		aura.CustomFilter = DetailedAuraFilter;
	end
	aura.type = "debuffs"
	aura:SetFrameLevel(10)
	return aura 
end 

function MOD:CreateAuraWatch(frame, unit)
	local aWatch = CreateFrame("Frame", nil, frame)
	aWatch:SetFrameLevel(frame:GetFrameLevel()  +  25)
	aWatch:SetAllPoints(frame)
	aWatch.presentAlpha = 1;
	aWatch.missingAlpha = 0;
	aWatch.strictMatching = true;
	aWatch.icons = {}
	return aWatch
end

function MOD:CreateAuraBarHeader(frame, unit)
	local auraBarParent = CreateFrame("Frame", nil, frame)
	auraBarParent.parent = frame;
	auraBarParent.PostCreateBar = PostCreateAuraBars;
	auraBarParent.gap = 2;
	auraBarParent.spacing = 1;
	auraBarParent.spark = true;
	if(unit == "player") then
		auraBarParent.filter = CommonBarFilter;
	else
		auraBarParent.filter = DetailedBarFilter;
	end
	auraBarParent.PostUpdate = ColorizeAuraBars;
	auraBarParent.barTexture = LSM:Fetch("statusbar", SV.db.SVUnit.auraBarStatusbar)
	return auraBarParent 
end 
--[[ 
########################################################## 
UPDATE
##########################################################
]]--
function MOD:UpdateAuraWatch(frame, key, override)
	local AW = frame.AuraWatch
	if not SV.db.SVUnit[key] then return end 
	local db = SV.db.SVUnit[key].auraWatch
	if not db then return end 

	if not db.enable then 
		AW:Hide()
		return 
	else
		AW:Show()
	end

	local WATCH_CACHE

	if key == "pet" and not override then 
		local petBW = SV.filters["PetBuffWatch"]
		if(petBW) then
			WATCH_CACHE = {}
			for _, buff in pairs(petBW)do 
				if(buff.style == "text") then 
					buff.style = "NONE"
				end 
				tinsert(WATCH_CACHE, buff)
			end
		end
	else 
		local unitBW = SV.filters["BuffWatch"]
		if(unitBW) then
			WATCH_CACHE = {}
			for _, buff in pairs(unitBW)do 
				if(buff.style == "text") then 
					buff.style = "NONE"
				end 
				tinsert(WATCH_CACHE, buff)
			end
		end
	end  

	if WATCH_CACHE then
		if AW.icons then 
			for i = 1, #AW.icons do 
				local iconTest = false;
				for j = 1, #WATCH_CACHE do 
					if(#WATCH_CACHE[j].id and #WATCH_CACHE[j].id == AW.icons[i]) then 
						iconTest = true;
						break 
					end 
				end 
				if not iconTest then 
					AW.icons[i]:Hide()
					AW.icons[i] = nil 
				end 
			end 
		end

		for i = 1, #WATCH_CACHE do 
			if WATCH_CACHE[i].id then 
				local buffName, _, buffTexture = GetSpellInfo(WATCH_CACHE[i].id)
				if buffName then 
					local watchedAura;
					if not AW.icons[WATCH_CACHE[i].id]then 
						watchedAura = CreateFrame("Frame", nil, AW)
					else 
						watchedAura = AW.icons[WATCH_CACHE[i].id]
					end 
					watchedAura.name = buffName;
					watchedAura.image = buffTexture;
					watchedAura.spellID = WATCH_CACHE[i].id;
					watchedAura.anyUnit = WATCH_CACHE[i].anyUnit;
					watchedAura.style = WATCH_CACHE[i].style;
					watchedAura.onlyShowMissing = WATCH_CACHE[i].onlyShowMissing;
					watchedAura.presentAlpha = watchedAura.onlyShowMissing and 0 or 1;
					watchedAura.missingAlpha = watchedAura.onlyShowMissing and 1 or 0;
					watchedAura.textThreshold = WATCH_CACHE[i].textThreshold or -1;
					watchedAura.displayText = WATCH_CACHE[i].displayText;
					watchedAura:SetWidthToScale(db.size)
					watchedAura:SetHeightToScale(db.size)
					watchedAura:ClearAllPoints()

					watchedAura:SetPoint(WATCH_CACHE[i].point, frame.Health, WATCH_CACHE[i].point, WATCH_CACHE[i].xOffset, WATCH_CACHE[i].yOffset)
					if not watchedAura.icon then 
						watchedAura.icon = watchedAura:CreateTexture(nil, "BORDER")
						watchedAura.icon:SetAllPoints(watchedAura)
					end 
					if not watchedAura.text then 
						local awText = CreateFrame("Frame", nil, watchedAura)
						awText:SetFrameLevel(watchedAura:GetFrameLevel() + 50)
						watchedAura.text = awText:CreateFontString(nil, "BORDER")
					end 
					if not watchedAura.border then 
						watchedAura.border = watchedAura:CreateTexture(nil, "BACKGROUND")
						watchedAura.border:SetPointToScale("TOPLEFT", -1, 1)
						watchedAura.border:SetPointToScale("BOTTOMRIGHT", 1, -1)
						watchedAura.border:SetTexture([[Interface\BUTTONS\WHITE8X8]])
						watchedAura.border:SetVertexColor(0, 0, 0)
					end 
					if not watchedAura.cd then 
						watchedAura.cd = CreateFrame("Cooldown", nil, watchedAura, "CooldownFrameTemplate")
						watchedAura.cd:SetAllPoints(watchedAura)
						watchedAura.cd:SetReverse(true)
						watchedAura.cd:SetHideCountdownNumbers(true)
						watchedAura.cd:SetFrameLevel(watchedAura:GetFrameLevel())
					end 
					if watchedAura.style == "coloredIcon"then 
						watchedAura.icon:SetTexture([[Interface\BUTTONS\WHITE8X8]])
						if WATCH_CACHE[i]["color"]then 
							watchedAura.icon:SetVertexColor(WATCH_CACHE[i]["color"].r, WATCH_CACHE[i]["color"].g, WATCH_CACHE[i]["color"].b)
						else 
							watchedAura.icon:SetVertexColor(0.8, 0.8, 0.8)
						end 
						watchedAura.icon:Show()
						watchedAura.border:Show()
						watchedAura.cd:SetAlpha(1)
					elseif watchedAura.style == "texturedIcon" then 
						watchedAura.icon:SetVertexColor(1, 1, 1)
						watchedAura.icon:SetTexCoord(.18, .82, .18, .82)
						watchedAura.icon:SetTexture(watchedAura.image)
						watchedAura.icon:Show()
						watchedAura.border:Show()
						watchedAura.cd:SetAlpha(1)
					else 
						watchedAura.border:Hide()
						watchedAura.icon:Hide()
						watchedAura.cd:SetAlpha(0)
					end 
					if watchedAura.displayText then 
						watchedAura.text:Show()
						local r, g, b = 1, 1, 1;
						if WATCH_CACHE[i].textColor then 
							r, g, b = WATCH_CACHE[i].textColor.r, WATCH_CACHE[i].textColor.g, WATCH_CACHE[i].textColor.b 
						end 
						watchedAura.text:SetTextColor(r, g, b)
					else 
						watchedAura.text:Hide()
					end 
					if not watchedAura.count then 
						watchedAura.count = watchedAura:CreateFontString(nil, "OVERLAY")
					end 
					watchedAura.count:ClearAllPoints()
					if watchedAura.displayText then 
						local anchor, relative, x, y = unpack(textCounterOffsets[WATCH_CACHE[i].point])
						watchedAura.count:SetPoint(anchor, watchedAura.text, relative, x, y)
					else 
						watchedAura.count:SetPoint("CENTER", unpack(counterOffsets[WATCH_CACHE[i].point]))
					end

					watchedAura.count:FontManager("unitaurasmall");
					watchedAura.text:FontManager("unitaurasmall");

					watchedAura.text:ClearAllPoints();
					
					watchedAura.text:SetPoint(WATCH_CACHE[i].point, watchedAura, WATCH_CACHE[i].point)
					if WATCH_CACHE[i].enabled then 
						AW.icons[WATCH_CACHE[i].id] = watchedAura;
						if AW.watched then 
							AW.watched[WATCH_CACHE[i].id] = watchedAura 
						end 
					else
						AW.icons[WATCH_CACHE[i].id] = nil;
						if AW.watched then 
							AW.watched[WATCH_CACHE[i].id] = nil 
						end 
						watchedAura:Hide()
						watchedAura = nil 
					end 
				end 
			end 
		end
		
		WATCH_CACHE = nil
	end
	if frame.AuraWatch.Update then 
		frame.AuraWatch.Update(frame)
	end 
end

function MOD:UpdateGroupAuraWatch(header, override)
	assert(self.Headers[header], "Invalid group specified.")
	local group = self.Headers[header]
	for i = 1, group:GetNumChildren() do 
		local frame = select(i, group:GetChildren())
		if frame and frame.Health then self:UpdateAuraWatch(frame, header, override) end 
	end 
end  