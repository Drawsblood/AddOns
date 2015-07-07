local Amr = LibStub("AceAddon-3.0"):GetAddon("AskMrRobot")
local L = LibStub("AceLocale-3.0"):GetLocale("AskMrRobot", true)

-- min import version that we will read from the website
Amr.MIN_IMPORT_VERSION = 21

-- min addon version that we will support for inter-addon communication for e.g. the team optimizer
--  last update to version 24 when item link format changed
Amr.MIN_ADDON_VERSION = 24

-- import some constants from the serializer for convenience
Amr.ChatPrefix = Amr.Serializer.ChatPrefix
Amr.RegionNames = Amr.Serializer.RegionNames
Amr.SlotIds = Amr.Serializer.SlotIds
Amr.SpecIds = Amr.Serializer.SpecIds
Amr.ClassIds = Amr.Serializer.ClassIds
Amr.ProfessionIds = Amr.Serializer.ProfessionIds
Amr.RaceIds = Amr.Serializer.RaceIds
Amr.FactionIds = Amr.Serializer.FactionIds
Amr.InstanceIds = Amr.Serializer.InstanceIds
Amr.SupportedInstanceIds = Amr.Serializer.SupportedInstanceIds
Amr.ParseItemLink = Amr.Serializer.ParseItemLink
Amr.IsSupportedInstanceId = Amr.Serializer.IsSupportedInstanceId
Amr.IsSupportedInstance = Amr.Serializer.IsSupportedInstance
Amr.SetTokenIds = Amr.Serializer.SetTokenIds

-- map of slot ID to display text
Amr.SlotDisplayText = {
    [1] = _G["HEADSLOT"],
    [2] = _G["NECKSLOT"],
    [3] = _G["SHOULDERSLOT"],
    [5] = _G["CHESTSLOT"],
    [6] = _G["WAISTSLOT"],
    [7] = _G["LEGSSLOT"],
    [8] = _G["FEETSLOT"],
    [9] = _G["WRISTSLOT"],
    [10] = _G["HANDSSLOT"],
    [11] = _G["FINGER0SLOT"] .. " 1",
    [12] = _G["FINGER1SLOT"] .. " 2",
    [13] = _G["TRINKET0SLOT"] .. " 1",
    [14] = _G["TRINKET1SLOT"] .. " 2",
    [15] = _G["BACKSLOT"],
    [16] = _G["MAINHANDSLOT"],
    [17] = _G["SECONDARYHANDSLOT"]
}

Amr.SlotEnumDisplayText = {
	Head = _G["HEADSLOT"],
    Neck = _G["NECKSLOT"],
    Shoulder = _G["SHOULDERSLOT"],
    Chest = _G["CHESTSLOT"],
    Waist = _G["WAISTSLOT"],
    Legs = _G["LEGSSLOT"],
    Feet = _G["FEETSLOT"],
    Wrist = _G["WRISTSLOT"],
    Hands = _G["HANDSSLOT"],
    Finger1 = _G["FINGER0SLOT"],
    Finger2 = _G["FINGER0SLOT"],
    Trinket1 = _G["TRINKET0SLOT"],
    Trinket2 = _G["TRINKET0SLOT"],
    Back = _G["BACKSLOT"],
    MainHand = _G["MAINHANDSLOT"],
    OffHand = _G["SECONDARYHANDSLOT"]
}

Amr.SpecIcons = {
    [1] = "spell_deathknight_bloodpresence", -- DeathKnightBlood
    [2] = "spell_deathknight_frostpresence", -- DeathKnightFrost
    [3] = "spell_deathknight_unholypresence", -- DeathKnightUnholy
    [4] = "spell_nature_starfall", -- DruidBalance
    [5] = "ability_druid_catform", -- DruidFeral
    [6] = "ability_racial_bearform", -- DruidGuardian
    [7] = "spell_nature_healingtouch", -- DruidRestoration
    [8] = "ability_hunter_bestialdiscipline", -- HunterBeastMastery
    [9] = "ability_hunter_focusedaim", -- HunterMarksmanship
    [10] = "ability_hunter_camouflage", -- HunterSurvival
    [11] = "spell_holy_magicalsentry", -- MageArcane
    [12] = "spell_fire_firebolt02", -- MageFire
    [13] = "spell_frost_frostbolt02", -- MageFrost
    [14] = "spell_monk_brewmaster_spec", -- MonkBrewmaster
    [15] = "spell_monk_mistweaver_spec", -- MonkMistweaver
    [16] = "spell_monk_windwalker_spec", -- MonkWindwalker
    [17] = "spell_holy_holybolt", -- PaladinHoly
    [18] = "ability_paladin_shieldofthetemplar", -- PaladinProtection
    [19] = "spell_holy_auraoflight", -- PaladinRetribution
    [20] = "spell_holy_powerwordshield", -- PriestDiscipline
    [21] = "spell_holy_guardianspirit", -- PriestHoly
    [22] = "spell_shadow_shadowwordpain", -- PriestShadow
    [23] = "ability_rogue_eviscerate", -- RogueAssassination
    [24] = "ability_backstab", -- RogueCombat
    [25] = "ability_stealth", -- RogueSubtlety
    [26] = "spell_nature_lightning", -- ShamanElemental
    [27] = "spell_nature_lightningshield", -- ShamanEnhancement
    [28] = "spell_nature_magicimmunity", -- ShamanRestoration
    [29] = "spell_shadow_deathcoil", -- WarlockAffliction
    [30] = "spell_shadow_metamorphosis", -- WarlockDemonology
    [31] = "spell_shadow_rainoffire", -- WarlockDestruction
    [32] = "ability_warrior_savageblow", -- WarriorArms
    [33] = "ability_warrior_innerrage", -- WarriorFury
    [34] = "ability_warrior_defensivestance", -- WarriorProtection
	[38] = "ability_warrior_defensivestance", -- WarriorProtection, used for special subspec handling
	[39] = "spell_warrior_gladiatorstance" -- WarriorProtectionGlad, used for special subspec handling
}

-- instance IDs ordered in preferred display order
Amr.InstanceIdsOrdered = { 1448, 1205, 1228 }

Amr.Difficulties = {
	Lfr = 17,
	Normal = 14,
	Heroic = 15,
	Mythic = 16
}

-- get the game's spec id from the AMR spec id
function Amr.GetGameSpecId(specId)
	for k, v in pairs(Amr.SpecIds) do
		if v == specId then return k end
	end
	return nil
end


------------------------------------------------------------------------------------------
-- Item Methods
------------------------------------------------------------------------------------------

-- item link format:  |cffa335ee|Hitem:itemID:enchant:gem1:gem2:gem3:gem4:suffixID:uniqueID:level:upgradeId:instanceDifficultyID:numBonusIDs:bonusID1:bonusID2...|h[item name]|h|r

function Amr.CreateItemLink(itemObj)

    if itemObj == nil or itemObj.id == nil or itemObj.id == 0 then return nil end
    
    local parts = {}
    table.insert(parts, "item")
    table.insert(parts, itemObj.id)
    table.insert(parts, itemObj.enchantId)
    table.insert(parts, itemObj.gemIds[1])
    table.insert(parts, itemObj.gemIds[2])
    table.insert(parts, itemObj.gemIds[3])
    table.insert(parts, itemObj.gemIds[4])
    
    if itemObj.suffixId == 0 then
        table.insert(parts, 0)
    else
        table.insert(parts, -math.abs(itemObj.suffixId))
    end
    
    table.insert(parts, 0) -- some unique id, doesn't seem to matter
    table.insert(parts, UnitLevel("player"))
	table.insert(parts, 0) -- unknown
    table.insert(parts, 0) -- unknown
    table.insert(parts, 0) -- difficulty id, doesn't matter
    
    if itemObj.bonusIds then
        table.insert(parts, #itemObj.bonusIds)
        for i,v in ipairs(itemObj.bonusIds) do
            table.insert(parts, v)
        end
	else
		table.insert(parts, 0) -- no bonus ids
    end
	
	-- upgrade id is tacked onto the end now it seems
	if (not itemObj.bonusIds or #itemObj.bonusIds == 0) and itemObj.upgradeId and itemObj.upgradeId ~= 0 then
		table.insert(parts, itemObj.upgradeId)
	end
    
    return table.concat(parts, ":")
end

-- a unique ID useful for determining if a player has an item equipped or not
function Amr.GetItemUniqueId(item, noUpgrade)
    if item == nil then return "" end
    local ret = item.id .. ""
    if item.bonusIds then
        for i = 1, #item.bonusIds do
            ret = ret .. "b" .. item.bonusIds[i]
        end
    end
    if item.suffixId ~= 0 then
        ret = ret .. "s" .. item.suffixId
    end
    if not noUpgrade and item.upgradeId ~= 0 then
        ret = ret .. "u" .. item.upgradeId
    end
    return ret
end

-- the server event for getting item info does not specify which item it just fetched... have to track manually
local _pendingItemIds = {}

-- helper for getting item information, which is not always guaranteed to be loaded into memory
function Amr.GetItemInfo(itemIdOrLinkOrName, callback, customArg)
	if not itemIdOrLinkOrName then
		callback(customArg)
		return
	end

	-- see if we can get the information immediately
	local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemIdOrLinkOrName)
	if name then
		callback(customArg, name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice)
		return
	end
	
	-- get the list of registered callbacks for this particular item
	local list = _pendingItemIds[itemIdOrLinkOrName]
	-- if there was a list, then just add the callback to the list
	if list then
		table.insert(list, { Callback = callback, Arg = customArg })
	else
		-- there wasn't a list, so make a new one with this callback
		_pendingItemIds[itemIdOrLinkOrName] = { { Callback = callback, Arg = customArg } }
	end
end

Amr:AddEventHandler("GET_ITEM_INFO_RECEIVED", function()
	-- go through all unresolved items since we don't know which one was just resolved
	for itemId, callbacks in pairs(_pendingItemIds) do
		-- attempt to get the item info again, remove from pending list if we find it
		local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemId)
		if name then
			_pendingItemIds[itemId] = nil

			-- call each callback
			for i = 1, #callbacks do
				callbacks[i].Callback(callbacks[i].Arg, name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice)
			end
		end
	end
end)
