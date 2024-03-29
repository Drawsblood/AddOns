-- AskMrRobot-Serializer will serialize and communicate character data between users.
-- This is used primarily to associate character information to logs uploaded to askmrrobot.com.

local MAJOR, MINOR = "AskMrRobot-Serializer", 31
local Amr, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not Amr then return end -- already loaded by something else

-- event and comm used for player snapshotting on entering combat
LibStub("AceEvent-3.0"):Embed(Amr)
LibStub("AceComm-3.0"):Embed(Amr)

----------------------------------------------------------------------------------------
-- Constants
----------------------------------------------------------------------------------------

-- prefix used for communicating gear snapshots created by the AMR serializer
Amr.ChatPrefix = "_AMRS"

-- map of region ids to AMR region names
Amr.RegionNames = {
	[1] = "US",
	[2] = "KR",
	[3] = "EU",
	[4] = "TW",
	[5] = "CN"
}

-- map of the skillLine returned by profession API to the AMR profession name
Amr.ProfessionSkillLineToName = {
	[794] = "Archaeology",
	[171] = "Alchemy",
	[164] = "Blacksmithing",
	[185] = "Cooking",
	[333] = "Enchanting",
	[202] = "Engineering",
	[129] = "First Aid",
	[356] = "Fishing",
	[182] = "Herbalism",
	[773] = "Inscription",
	[755] = "Jewelcrafting",
	[165] = "Leatherworking",
	[186] = "Mining",
	[393] = "Skinning",
	[197] = "Tailoring"
}

-- all slot IDs that we care about, ordered in AMR standard display order
Amr.SlotIds = { 16, 17, 1, 2, 3, 15, 5, 9, 10, 6, 7, 8, 11, 12, 13, 14 }

Amr.SpecIds = {
    [250] = 1, -- DeathKnightBlood
    [251] = 2, -- DeathKnightFrost
    [252] = 3, -- DeathKnightUnholy
    [102] = 4, -- DruidBalance
    [103] = 5, -- DruidFeral
    [104] = 6, -- DruidGuardian
    [105] = 7, -- DruidRestoration
    [253] = 8, -- HunterBeastMastery
    [254] = 9, -- HunterMarksmanship
    [255] = 10, -- HunterSurvival
    [62] = 11, -- MageArcane
    [63] = 12, -- MageFire
    [64] = 13, -- MageFrost
    [268] = 14, -- MonkBrewmaster
    [270] = 15, -- MonkMistweaver
    [269] = 16, -- MonkWindwalker
    [65] = 17, -- PaladinHoly
    [66] = 18, -- PaladinProtection
    [70] = 19, -- PaladinRetribution
    [256] = 20, -- PriestDiscipline
    [257] = 21, -- PriestHoly
    [258] = 22, -- PriestShadow
    [259] = 23, -- RogueAssassination
    [260] = 24, -- RogueCombat
    [261] = 25, -- RogueSubtlety
    [262] = 26, -- ShamanElemental
    [263] = 27, -- ShamanEnhancement
    [264] = 28, -- ShamanRestoration
    [265] = 29, -- WarlockAffliction
    [266] = 30, -- WarlockDemonology
    [267] = 31, -- WarlockDestruction
    [71] = 32, -- WarriorArms
    [72] = 33, -- WarriorFury
    [73] = 34 -- WarriorProtection
}

Amr.ClassIds = {
    ["NONE"] = 0,
    ["DEATHKNIGHT"] = 1,
    ["DRUID"] = 2,
    ["HUNTER"] = 3,
    ["MAGE"] = 4,
    ["MONK"] = 5,
    ["PALADIN"] = 6,
    ["PRIEST"] = 7,
    ["ROGUE"] = 8,
    ["SHAMAN"] = 9,
    ["WARLOCK"] = 10,
    ["WARRIOR"] = 11,
}

Amr.ProfessionIds = {
    ["None"] = 0,
    ["Mining"] = 1,
    ["Skinning"] = 2,
    ["Herbalism"] = 3,
    ["Enchanting"] = 4,
    ["Jewelcrafting"] = 5,
    ["Engineering"] = 6,
    ["Blacksmithing"] = 7,
    ["Leatherworking"] = 8,
    ["Inscription"] = 9,
    ["Tailoring"] = 10,
    ["Alchemy"] = 11,
    ["Fishing"] = 12,
    ["Cooking"] = 13,
    ["First Aid"] = 14,
    ["Archaeology"] = 15
}

Amr.RaceIds = {
    ["None"] = 0,
    ["BloodElf"] = 1,
    ["Draenei"] = 2,
    ["Dwarf"] = 3,
    ["Gnome"] = 4,
    ["Human"] = 5,
    ["NightElf"] = 6,
    ["Orc"] = 7,
    ["Tauren"] = 8,
    ["Troll"] = 9,
    ["Scourge"] = 10,
    ["Undead"] = 10,
    ["Goblin"] = 11,
    ["Worgen"] = 12,
    ["Pandaren"] = 13
}

Amr.FactionIds = {
    ["None"] = 0,
    ["Alliance"] = 1,
    ["Horde"] = 2
}

Amr.InstanceIds = {
	Auchindoun = 1182,
	BloodmaulSlagMines = 1175,
	GrimrailDepot = 1208,
	IronDocks = 1195,
	ShadowmoonBurialGrounds = 1176,
	Skyreach = 1209,
	TheEverbloom = 1279,
	UpperBlackrockSpire = 1358,
	Highmaul = 1228,
	BlackrockFoundry = 1205,
	HellfireCitadel = 1448
}

-- instances that AskMrRobot currently supports logging for
Amr.SupportedInstanceIds = {
	--[1182] = true,
	--[1175] = true,
	--[1208] = true,
	--[1195] = true,
	--[1176] = true,
	--[1209] = true,
	--[1279] = true,
	--[1358] = true,
	[1228] = true,
	[1205] = true,
	[1448] = true
}

Amr.SPEC_WARRIORPROTECTION = 34
Amr.SUBSPEC_WARRIORPROTECTION = 38
Amr.SUBSPEC_WARRIORPROTECTIONGLAD = 39
Amr.SPELL_ID_GLADIATOR_STANCE = 156291
Amr.SPELL_ID_DEFENSIVE_STANCE = 71

-- IDs of set tokens that we would care about in a player's inventory
Amr.SetTokenIds = {
	[127970] = true,
	[127969] = true,
	[127968] = true,
	[127967] = true,
	[127966] = true,
	[127965] = true,
	[127964] = true,
	[127963] = true,
	[127962] = true,
	[127961] = true,
	[127960] = true,
	[127959] = true,
	[127958] = true,
	[127957] = true,
	[127956] = true,
	[127955] = true,
	[127954] = true,
	[127953] = true,
	[120285] = true,
	[120284] = true,
	[120283] = true,
	[120282] = true,
	[120281] = true,
	[120280] = true,
	[120279] = true,
	[120278] = true,
	[120277] = true,
	[120256] = true,
	[120255] = true,
	[120254] = true,
	[120253] = true,
	[120252] = true,
	[120251] = true,
	[120250] = true,
	[120249] = true,
	[120248] = true,
	[120247] = true,
	[120246] = true,
	[120245] = true,
	[120244] = true,
	[120243] = true,
	[120242] = true,
	[120241] = true,
	[120240] = true,
	[120239] = true,
	[120238] = true,
	[120237] = true,
	[120236] = true,
	[120235] = true,
	[120234] = true,
	[120233] = true,
	[120232] = true,
	[120231] = true,
	[120230] = true,
	[120229] = true,
	[120228] = true,
	[120227] = true,
	[120226] = true,
	[120225] = true,
	[120224] = true,
	[120223] = true,
	[120222] = true,
	[120221] = true,
	[120220] = true,
	[120219] = true,
	[120218] = true,
	[120217] = true,
	[120216] = true,
	[120215] = true,
	[120214] = true,
	[120213] = true,
	[120212] = true,
	[120211] = true,
	[120210] = true,
	[120209] = true,
	[120208] = true,
	[120207] = true,
	[120206] = true,
	[119323] = true,
	[119322] = true,
	[119321] = true,
	[119320] = true,
	[119319] = true,
	[119318] = true,
	[119316] = true,
	[119315] = true,
	[119314] = true,
	[119313] = true,
	[119312] = true,
	[119311] = true,
	[119310] = true,
	[119309] = true,
	[119308] = true,
	[119307] = true,
	[119306] = true,
	[119305] = true,
	[105868] = true,
	[105867] = true,
	[105866] = true,
	[105865] = true,
	[105864] = true,
	[105863] = true,
	[105862] = true,
	[105861] = true,
	[105860] = true,
	[105859] = true,
	[105858] = true,
	[105857] = true,
	[99756] = true,
	[99755] = true,
	[99754] = true,
	[99753] = true,
	[99752] = true,
	[99751] = true,
	[99750] = true,
	[99749] = true,
	[99748] = true,
	[99747] = true,
	[99746] = true,
	[99745] = true,
	[99744] = true,
	[99743] = true,
	[99742] = true,
	[99740] = true,
	[99739] = true,
	[99738] = true,
	[99737] = true,
	[99736] = true,
	[99735] = true,
	[99734] = true,
	[99733] = true,
	[99732] = true,
	[99731] = true,
	[99730] = true,
	[99729] = true,
	[99728] = true,
	[99727] = true,
	[99726] = true,
	[99725] = true,
	[99724] = true,
	[99723] = true,
	[99722] = true,
	[99721] = true,
	[99720] = true,
	[99719] = true,
	[99718] = true,
	[99717] = true,
	[99716] = true,
	[99715] = true,
	[99714] = true,
	[99713] = true,
	[99712] = true,
	[99711] = true,
	[99710] = true,
	[99709] = true,
	[99708] = true,
	[99707] = true,
	[99706] = true,
	[99705] = true,
	[99704] = true,
	[99703] = true,
	[99702] = true,
	[99701] = true,
	[99700] = true,
	[99699] = true,
	[99698] = true,
	[99697] = true,
	[99696] = true,
	[99695] = true,
	[99694] = true,
	[99693] = true,
	[99692] = true,
	[99691] = true,
	[99690] = true,
	[99689] = true,
	[99688] = true,
	[99687] = true,
	[99686] = true,
	[99685] = true,
	[99684] = true,
	[99683] = true,
	[99682] = true,
	[99681] = true,
	[99680] = true,
	[99679] = true,
	[99678] = true,
	[99677] = true,
	[99676] = true,
	[99675] = true,
	[99674] = true,
	[99673] = true,
	[99672] = true,
	[99671] = true,
	[99670] = true,
	[99669] = true,
	[99668] = true,
	[99667] = true,
	[96701] = true,
	[96700] = true,
	[96699] = true,
	[96633] = true,
	[96632] = true,
	[96631] = true,
	[96625] = true,
	[96624] = true,
	[96623] = true,
	[96601] = true,
	[96600] = true,
	[96599] = true,
	[96568] = true,
	[96567] = true,
	[96566] = true,
	[95957] = true,
	[95956] = true,
	[95955] = true,
	[95889] = true,
	[95888] = true,
	[95887] = true,
	[95881] = true,
	[95880] = true,
	[95879] = true,
	[95857] = true,
	[95856] = true,
	[95855] = true,
	[95824] = true,
	[95823] = true,
	[95822] = true,
	[95583] = true,
	[95582] = true,
	[95581] = true,
	[95580] = true,
	[95579] = true,
	[95578] = true,
	[95577] = true,
	[95576] = true,
	[95575] = true,
	[95574] = true,
	[95573] = true,
	[95572] = true,
	[95571] = true,
	[95570] = true,
	[95569] = true,
	[89278] = true,
	[89277] = true,
	[89276] = true,
	[89275] = true,
	[89274] = true,
	[89273] = true,
	[89272] = true,
	[89271] = true,
	[89270] = true,
	[89269] = true,
	[89268] = true,
	[89267] = true,
	[89266] = true,
	[89265] = true,
	[89264] = true,
	[89263] = true,
	[89262] = true,
	[89261] = true,
	[89260] = true,
	[89259] = true,
	[89258] = true,
	[89257] = true,
	[89256] = true,
	[89255] = true,
	[89254] = true,
	[89253] = true,
	[89252] = true,
	[89251] = true,
	[89250] = true,
	[89249] = true,
	[89248] = true,
	[89247] = true,
	[89246] = true,
	[89245] = true,
	[89244] = true,
	[89243] = true,
	[89242] = true,
	[89241] = true,
	[89240] = true,
	[89239] = true,
	[89238] = true,
	[89237] = true,
	[89236] = true,
	[89235] = true,
	[89234] = true,
	[78876] = true,
	[78875] = true,
	[78874] = true,
	[78873] = true,
	[78872] = true,
	[78871] = true,
	[78867] = true,
	[78866] = true,
	[78865] = true,
	[78864] = true,
	[78863] = true,
	[78862] = true,
	[78861] = true,
	[78860] = true,
	[78859] = true,
	[78858] = true,
	[78857] = true,
	[78856] = true,
	[78855] = true,
	[78854] = true,
	[78853] = true,
	[78849] = true,
	[78848] = true,
	[78847] = true,
	[78184] = true,
	[78183] = true,
	[78181] = true,
	[78180] = true,
	[78179] = true,
	[78178] = true,
	[78176] = true,
	[78175] = true,
	[78174] = true,
	[78173] = true,
	[78171] = true,
	[78170] = true,
	[71687] = true,
	[71686] = true,
	[71685] = true,
	[71683] = true,
	[71682] = true,
	[71680] = true,
	[71679] = true,
	[71678] = true,
	[71676] = true,
	[71675] = true,
	[71673] = true,
	[71672] = true,
	[71671] = true,
	[71669] = true,
	[71668] = true,
	[67431] = true,
	[67430] = true,
	[67429] = true,
	[67428] = true,
	[67427] = true,
	[67426] = true,
	[67425] = true,
	[67424] = true,
	[67423] = true,
	[66998] = true,
	[65089] = true,
	[65088] = true,
	[65087] = true,
	[63684] = true,
	[63683] = true,
	[63682] = true,
	[51320] = true,
	[45652] = true,
	[45651] = true,
	[45650] = true,
	[45649] = true,
	[45648] = true,
	[45647] = true,
	[45643] = true,
	[45642] = true,
	[45641] = true,
	[40630] = true,
	[40629] = true,
	[40628] = true,
	[40621] = true,
	[40620] = true,
	[40619] = true,
	[40618] = true,
	[40617] = true,
	[40616] = true,
	[34544] = true,
	[31100] = true,
	[31099] = true,
	[31098] = true,
	[31097] = true,
	[31096] = true,
	[31095] = true,
	[30247] = true,
	[30246] = true,
	[30245] = true,
	[30244] = true,
	[30243] = true,
	[30242] = true,
	[29767] = true,
	[29766] = true,
	[29765] = true,
	[29761] = true,
	[29760] = true,
	[29759] = true
}


----------------------------------------------------------------------------------------
-- Public Utility Methods
----------------------------------------------------------------------------------------

-- item link format:  |cffa335ee|Hitem:itemID:enchant:gem1:gem2:gem3:gem4:suffixID:uniqueID:level:unknown:unknown:instanceDifficultyID:numBonusIDs:bonusID1:bonusID2...|h[item name]|h|r
-- get an object with all of the parts of the item link format that we care about
function Amr.ParseItemLink(itemLink)
    if not itemLink then return nil end
    
    local str = string.match(itemLink, "|Hitem:([\-%d:]+)|")
    if not str then return nil end
    
    local parts = { strsplit(":", str) }
    
    local item = {}
    item.id = tonumber(parts[1])
    item.enchantId = tonumber(parts[2])
    item.gemIds = { tonumber(parts[3]), tonumber(parts[4]), tonumber(parts[5]), tonumber(parts[6]) }
    item.suffixId = math.abs(tonumber(parts[7])) -- convert suffix to positive number, that's what we use in our code
    --item.uniqueId = tonumber(parts[8])
    --item.level = tonumber(parts[9])
	-- part 10 is unknown atm
	-- part 11 is unknown atm
    --item.difficultyId = tonumber(parts[12])
    
    local numBonuses = tonumber(parts[13])
    if numBonuses and numBonuses > 0 then
        item.bonusIds = {}
        for i = 14, 13 + numBonuses do
            table.insert(item.bonusIds, tonumber(parts[i]))
        end
		table.sort(item.bonusIds)
    end
	
	-- if there is another part after bonus ids, that is the upgrade id	
	if numBonuses and #parts >= 14 + numBonuses then
		local upgradeId = tonumber(parts[14 + numBonuses])
		item.upgradeId = upgradeId and upgradeId or 0
	else
		item.upgradeId = 0
	end
    
    return item
end

-- returns true if this is an instance that AskMrRobot supports for logging
function Amr.IsSupportedInstanceId(instanceMapID)
	if Amr.SupportedInstanceIds[tonumber(instanceMapID)] then
		return true
	else
		return false
	end
end

-- returns true if currently in a supported instance for logging
function Amr.IsSupportedInstance()
	local zone, _, difficultyIndex, _, _, _, _, instanceMapID = GetInstanceInfo()
	return Amr.IsSupportedInstanceId(instanceMapID)
end


----------------------------------------------------------------------------------------
-- Character Reading
----------------------------------------------------------------------------------------

local function readProfessionInfo(prof, ret)
	if prof then
		local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier = GetProfessionInfo(prof);
		if Amr.ProfessionSkillLineToName[skillLine] ~= nil then
			ret.Professions[Amr.ProfessionSkillLineToName[skillLine]] = skillLevel;
		end
	end
end

local function getSpecId(specGroup)
	local spec = GetSpecialization(false, false, specGroup);
	return spec and GetSpecializationInfo(spec);
end

local function getTalents(specGroup)	
    local talentInfo = {}
    local maxTiers = 7
    for tier = 1, maxTiers do
        for col = 1, 3 do
            local id, name, texture, selected, available = GetTalentInfo(tier, col, specGroup)
            if selected then
                talentInfo[tier] = col
            end
        end
    end
    
    local str = ""
    for i = 1, maxTiers do
    	if talentInfo[i] then
    		str = str .. talentInfo[i]
    	else
    		str = str .. '0'
    	end
    end    	

	return str
end

local function getGlyphs(specGroup)
	local glyphs = {}
	for i = 1, NUM_GLYPH_SLOTS do
		local _, _, _, glyphSpellID, _, glyphID = GetGlyphSocketInfo(i, specGroup)
		if (glyphID) then
			table.insert(glyphs, glyphSpellID)
		end
	end
	return glyphs;
end

-- get specs, talents, and glyphs
local function readSpecs(ret, subspecs)

    for group = 1, GetNumSpecGroups() do
        -- spec, convert game spec id to one of our spec ids
        local specId = getSpecId(group)
        if specId then
            ret.Specs[group] = Amr.SpecIds[specId]
			
			-- if this is a protection warrior, use buffs to determine subspec
			if ret.Specs[group] == Amr.SPEC_WARRIORPROTECTION then
				local subspec = 0
				
				if ret.ActiveSpec ~= group then
					-- this spec isn't active, so we can't use current buffs to determine spec, see if any old data is compatible
					if subspecs and (subspecs[group] == Amr.SUBSPEC_WARRIORPROTECTION or subspecs[group] == Amr.SUBSPEC_WARRIORPROTECTIONGLAD) then
						subspec = subspecs[group]
					end
				else
					for i=1,40 do
						local name,_,_,_,_,_,_,_,_,_,spellId = UnitAura("player", i, "HELPFUL")
						if not name then break end
						
						if spellId == Amr.SPELL_ID_DEFENSIVE_STANCE then
							subspec = Amr.SUBSPEC_WARRIORPROTECTION
							break
						elseif spellId == Amr.SPELL_ID_GLADIATOR_STANCE then
							subspec = Amr.SUBSPEC_WARRIORPROTECTIONGLAD
							break
						end
					end
				end
				
				if subspec == 0 then
					ret.SubSpecs[group] = nil
				else
					ret.SubSpecs[group] = subspec
				end
			end
        else
            ret.Specs[group] = 0
        end
        
        ret.Talents[group] = getTalents(group)
        ret.Glyphs[group] = getGlyphs(group)
	end
end

-- get currently equipped items, store with currently active spec
local function readEquippedItems(ret)
    local equippedItems = {};
	for slotNum = 1, #Amr.SlotIds do
		local slotId = Amr.SlotIds[slotNum]
		local itemLink = GetInventoryItemLink("player", slotId)
		if itemLink then
			equippedItems[slotId] = itemLink
		end
	end
    
    -- store last-seen equipped gear for each spec
	ret.Equipped[GetActiveSpecGroup()] = equippedItems
end

-- Get all data about the player as an object, includes:
-- serializer version
-- region/realm/name
-- guild
-- race
-- faction
-- level
-- professions
-- spec/talent/glyphs for both specs
-- equipped gear for the current spec
--
function Amr:GetPlayerData(subspecs)

	local ret = {}
	
	ret.Region = Amr.RegionNames[GetCurrentRegion()]
    ret.Realm = GetRealmName()
    ret.Name = UnitName("player")
	ret.Guild = GetGuildInfo("player")
    ret.ActiveSpec = GetActiveSpecGroup()
    ret.Level = UnitLevel("player");
    
    local cls, clsEn = UnitClass("player")
    ret.Class = clsEn;
    
    local race, raceEn = UnitRace("player")
	ret.Race = raceEn;
	ret.Faction = UnitFactionGroup("player")
    
	ret.Professions = {};
    local prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions();
	readProfessionInfo(prof1, ret)
	readProfessionInfo(prof2, ret)
	readProfessionInfo(archaeology, ret)
	readProfessionInfo(fishing, ret)
	readProfessionInfo(cooking, ret)
	readProfessionInfo(firstAid, ret)
	
	ret.Specs = {}
	ret.SubSpecs = {} -- only filled in for ambiguous cases, right now just prot/glad warrior
    ret.Talents = {}
    ret.Glyphs = {}
	readSpecs(ret, subspecs)
	
	ret.Equipped = {}
	readEquippedItems(ret)
	
	return ret
end


----------------------------------------------------------------------------------------
-- Serialization
----------------------------------------------------------------------------------------

local function toCompressedNumberList(list)
    -- ensure the values are numbers, sorted from lowest to highest
    local nums = {}
    for i, v in ipairs(list) do
        table.insert(nums, tonumber(v))
    end
    table.sort(nums)
    
    local ret = {}
    local prev = 0
    for i, v in ipairs(nums) do
        local diff = v - prev
        table.insert(ret, diff)
        prev = v
    end
    
    return table.concat(ret, ",")
end

-- make this utility publicly available
function Amr:ToCompressedNumberList(list)
	return toCompressedNumberList(list)
end

-- appends a list of items to the export
local function appendItemsToExport(fields, itemObjects)

    -- sort by item id so we can compress it more easily
    table.sort(itemObjects, function(a, b) return a.id < b.id end)
    
    -- append to the export string
    local prevItemId = 0
    local prevGemId = 0
    local prevEnchantId = 0
    local prevUpgradeId = 0
    local prevBonusId = 0
    for i, itemData in ipairs(itemObjects) do
        local itemParts = {}
        
        table.insert(itemParts, itemData.id - prevItemId)
        prevItemId = itemData.id
        
        if itemData.slot ~= nil then table.insert(itemParts, "s" .. itemData.slot) end
        if itemData.suffixId ~= 0 then table.insert(itemParts, "f" .. itemData.suffixId) end
        if itemData.upgradeId ~= 0 then 
            table.insert(itemParts, "u" .. (itemData.upgradeId - prevUpgradeId))
            prevUpgradeId = itemData.upgradeId
        end
        if itemData.bonusIds then
            for bIndex, bValue in ipairs(itemData.bonusIds) do
                table.insert(itemParts, "b" .. (bValue - prevBonusId))
                prevBonusId = bValue
            end
        end        
        if itemData.gemIds[1] ~= 0 then 
            table.insert(itemParts, "x" .. (itemData.gemIds[1] - prevGemId))
            prevGemId = itemData.gemIds[1]
        end
        if itemData.gemIds[2] ~= 0 then 
            table.insert(itemParts, "y" .. (itemData.gemIds[2] - prevGemId))
            prevGemId = itemData.gemIds[2]
        end
        if itemData.gemIds[3] ~= 0 then 
            table.insert(itemParts, "z" .. (itemData.gemIds[3] - prevGemId))
            prevGemId = itemData.gemIds[3]
        end
        if itemData.enchantId ~= 0 then 
            table.insert(itemParts, "e" .. (itemData.enchantId - prevEnchantId))
            prevEnchantId = itemData.enchantId
        end
    
        table.insert(fields, table.concat(itemParts, ""))
    end
end

-- Serialize just the identity portion of a player (region/realm/name) in the same format used by the full serialization
function Amr:SerializePlayerIdentity(data)
	local fields = {}    
    table.insert(fields, MINOR)
	table.insert(fields, data.Region)
    table.insert(fields, data.Realm)
    table.insert(fields, data.Name)	
	return "$" .. table.concat(fields, ";") .. "$"
end

-- Serialize player data gathered by GetPlayerData.  This can be augmented with extra data if desired (augmenting used mainly by AskMrRobot addon).
-- Pass complete = true to do a complete export of this extra information, otherwise it is ignored.
-- Extra data can include:
-- equipped gear for the player's inactive spec, slot id to item link dictionary
-- Reputations
-- BagItems, BankItems, VoidItems, lists of item links
--
function Amr:SerializePlayerData(data, complete)

	local fields = {}
    
    -- compressed string uses a fixed order rather than inserting identifiers
    table.insert(fields, MINOR)
	table.insert(fields, data.Region)
    table.insert(fields, data.Realm)
    table.insert(fields, data.Name)

	-- guild name
	if data.Guild == nil then
		table.insert(fields, "")
	else
		table.insert(fields, data.Guild)
    end

    -- race, default to pandaren if we can't read it for some reason
    local raceval = Amr.RaceIds[data.Race]
    if raceval == nil then raceval = 13 end
    table.insert(fields, raceval)
    
    -- faction, default to alliance if we can't read it for some reason
    raceval = Amr.FactionIds[data.Faction]
    if raceval == nil then raceval = 1 end
    table.insert(fields, raceval)
    
    table.insert(fields, data.Level)
    
    local profs = {}
    local noprofs = true
    if data.Professions then
	    for k, v in pairs(data.Professions) do
	        local profval = Amr.ProfessionIds[k]
	        if profval ~= nil then
	            noprofs = false
	            table.insert(profs, profval .. ":" .. v)
	        end
	    end
	end
    
    if noprofs then
        table.insert(profs, "0:0")
    end
    
    table.insert(fields, table.concat(profs, ","))
    
    -- export specs
    table.insert(fields, data.ActiveSpec)
    for spec = 1, 2 do
        if data.Specs[spec] and (complete or spec == data.ActiveSpec) then
            table.insert(fields, ".s" .. spec) -- indicates the start of a spec block
			
			-- we use subspec for some ambiguous specs like prot/glad warrior
			if data.SubSpecs[spec] then
				table.insert(fields, string.format("s%s", data.SubSpecs[spec]))
			else
				table.insert(fields, data.Specs[spec])
			end
			
            table.insert(fields, data.Talents[spec])
            table.insert(fields, toCompressedNumberList(data.Glyphs[spec]))
        end
    end
    
    -- export equipped gear
    if data.Equipped then
        for spec = 1, 2 do
            if data.Equipped[spec] and (complete or spec == data.ActiveSpec) then
                table.insert(fields, ".q" .. spec) -- indicates the start of an equipped gear block
                
                local itemObjects = {}
                for k, v in pairs(data.Equipped[spec]) do
                    local itemData = Amr.ParseItemLink(v)
                    itemData.slot = k
                    table.insert(itemObjects, itemData)
                end
                
                appendItemsToExport(fields, itemObjects)
            end
        end
	end
    
    -- if doing a complete export, include reputations and bank/bag items too
    if complete then
    
        -- export reputations
        local reps = {}
        local noreps = true
        if data.Reputations then
            for k, v in pairs(data.Reputations) do
                noreps = false
                table.insert(reps, k .. ":" .. v)
            end
        end
        if noreps then
            table.insert(reps, "_")
        end
        
        table.insert(fields, ".r")
        table.insert(fields, table.concat(reps, ","))    
    
        -- export bag and bank
        local itemObjects = {}
    	if data.BagItems then
	        for i, v in ipairs(data.BagItems) do
				local itemData = Amr.ParseItemLink(v)
				if itemData ~= nil and (IsEquippableItem(v) or Amr.SetTokenIds[itemData.id]) then
					table.insert(itemObjects, itemData)
				end
	        end
	    end
	    if data.BankItems then
	        for i, v in ipairs(data.BankItems) do
	        	local itemData = Amr.ParseItemLink(v)
				if itemData ~= nil and (IsEquippableItem(v) or Amr.SetTokenIds[itemData.id]) then
					table.insert(itemObjects, itemData)
				end
	        end
	    end
	    if data.VoidItems then
	        for i, v in ipairs(data.VoidItems) do
	        	local itemData = Amr.ParseItemLink(v)
				if itemData ~= nil and (IsEquippableItem(v) or Amr.SetTokenIds[itemData.id]) then
					table.insert(itemObjects, itemData)
				end
		    end
	    end
        
        table.insert(fields, ".inv")
        appendItemsToExport(fields, itemObjects)
    end

    return "$" .. table.concat(fields, ";") .. "$"

end

-- Shortcut for the common use case: serialize the player's currently active setup with no extras.
function Amr:SerializePlayer()
	local data = self:GetPlayerData()
	return self:SerializePlayerData(data)
end


----------------------------------------------------------------------------------------------------------------------
-- Character Snapshots
-- This feature snapshots a player's gear/talents/glyphs when entering combat.  It is enabled by default.  Consumers
-- of this library can create a setting to enable/disable it as desired per a user setting.
--
-- You should register for the AMR_SNAPSHOT_STATE_CHANGED message (sent via AceEvent-3.0 messaging) to ensure that
-- your addon settings stay in sync with any other addon that may also be trying to control the enabled state.
--
-- Note that if a user has the main AMR addon installed, it will always enable snapshotting, and override any attempt
-- to disable it by immediately re-enabling it and thus re-triggering AMR_SNAPSHOT_STATE_CHANGED.
----------------------------------------------------------------------------------------------------------------------
Amr._snapshotEnabled = true

-- Enable snapshotting of character data when entering combat.  Sends this player's character data to anyone logging with the AskMrRobot addon.
function Amr:EnableSnapshots()
	self._snapshotEnabled = true
	self:SendMessage("AMR_SNAPSHOT_STATE_CHANGED", self._snapshotEnabled)
end

-- Disable snapshotting of character data when entering combat.
function Amr:DisableSnapshots()
	self._snapshotEnabled = false
	self:SendMessage("AMR_SNAPSHOT_STATE_CHANGED", self._snapshotEnabled)
end

function Amr:IsSnapshotEnabled()
	return self._snapshotEnabled
end


function Amr:PLAYER_REGEN_DISABLED()
--function Amr:GARRISON_MISSION_NPC_OPENED()

	-- send data about this character when a player enters combat in a supported zone
	if self._snapshotEnabled and Amr.IsSupportedInstance() then
		local t = time()
		local player = self:GetPlayerData()
		local msg = self:SerializePlayerData(player)
		msg = string.format("%s\r%s\n%s\n%s\n%s\n%s", MINOR, t, player.Region, player.Realm, player.Name, msg)
		
		self:SendCommMessage(Amr.ChatPrefix, msg, "RAID")
	end
end

Amr:RegisterEvent("PLAYER_REGEN_DISABLED")
--Amr:RegisterEvent("GARRISON_MISSION_NPC_OPENED") -- for debugging, fire this event when open mission table