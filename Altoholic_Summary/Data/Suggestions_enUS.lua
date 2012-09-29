﻿local addonName = "Altoholic"
local addon = _G[addonName]

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local BI = LibStub("LibBabble-Inventory-3.0"):GetLookupTable()
local BZ = LibStub("LibBabble-Zone-3.0"):GetLookupTable()
local BF = LibStub("LibBabble-Faction-3.0"):GetLookupTable()

-- temporary test, until all locales are done for the suggestions, test the ones that are done in order to use them instead of enUS, this test will be replaced later on.
if (GetLocale() == "frFR") or
    (GetLocale() == "ruRU") or
	(GetLocale() == "deDE") or
	(GetLocale() == "zhCN") or
	(GetLocale() == "zhTW") then return end				-- exit to use zhCN, zhTW or frFR instead of enUS

local WHITE		= "|cFFFFFFFF"
local GREEN		= "|cFF00FF00"
local YELLOW	= "|cFFFFFF00"

-- This table contains a list of suggestions to get to the next level of reputation, craft or skill
addon.Suggestions = {

	-- source : http://forums.worldofwarcraft.com/thread.html?topicId=102789457&sid=1
	-- ** Primary professions **
	[BI["Tailoring"]] = {
		{ 50, "Up to 50: Bolt of Linen Cloth" },
		{ 70, "Up to 70: Linen Bag" },
		{ 75, "Up to 75: Reinforced Linen Cape" },
		{ 105, "Up to 105: Bolt of Woolen Cloth" },
		{ 110, "Up to 110: Gray Woolen Shirt"},
		{ 125, "Up to 125: Double-stitched Woolen Shoulders" },
		{ 145, "Up to 145: Bolt of Silk Cloth" },
		{ 160, "Up to 160: Azure Silk Hood" },
		{ 170, "Up to 170: Silk Headband" },
		{ 175, "Up to 175: Formal White Shirt" },
		{ 185, "Up to 185: Bolt of Mageweave" },
		{ 205, "Up to 205: Crimson Silk Vest" },
		{ 215, "Up to 215: Crimson Silk Pantaloons" },
		{ 220, "Up to 220: Black Mageweave Leggings\nor Black Mageweave Vest" },
		{ 230, "Up to 230: Black Mageweave Gloves" },
		{ 250, "Up to 250: Black Mageweave Headband\nor Black Mageweave Shoulders" },
		{ 260, "Up to 260: Bolt of Runecloth" },
		{ 275, "Up to 275: Runecloth Belt" },
		{ 280, "Up to 280: Runecloth Bag" },
		{ 300, "Up to 300: Runecloth Gloves" },
		{ 325, "Up to 325: Bolts of Netherweave\n|cFFFFD700Don't sell them, you'll need them later" },
		{ 340, "Up to 340: Bolts of Imbued Netherweave\n|cFFFFD700Don't sell them, you'll need them later" },
		{ 350, "Up to 350: Netherweave Boots\n|cFFFFD700Disenchant them for Arcane Dust" },
		{ 375, "Up to 375: Bolts of Frostweave" },
		{ 380, "Up to 380: Frostwoven Boots" },
		{ 395, "Up to 395: Frostwoven Cowl" },
		{ 405, "Up to 405: Duskweave Cowl" },
		{ 410, "Up to 410: Duskweave Wristwraps" },
		{ 415, "Up to 415: Duskweave Gloves" },
		{ 425, "Up to 425: Frostweave Bags" },
		{ 450, "Up to 450: Bolts of Ebonweave Silk" },
		{ 475, "Up to 475: Whatever earns a skill-up" },
		{ 500, "Up to 500: Master's Spellthread, and other low-mats recipes" },
		{ 515, "Up to 515: Swordguard Embroidary" },
		{ 525, "Up to 525: Dreams and whatever earns a skill-up." },
	},
	[BI["Leatherworking"]] = {
		{ 35, "Up to 35: Light Armour Kit" },
		{ 55, "Up to 55: Cured Light Hide" },
		{ 85, "Up to 85: Embossed Leather Gloves" },
		{ 100, "Up to 100: Fine Leather Belt" },
		{ 120, "Up to 120: Cured Medium Hide" },
		{ 125, "Up to 125: Fine Leather Belt" },
		{ 150, "Up to 150: Dark Leather Belt" },
		{ 160, "Up to 160: Cured Heavy Hide" },
		{ 170, "Up to 170: Heavy Armour Kit" },
		{ 180, "Up to 180: Dusky Leather Leggings\nor Guardian Pants" },
		{ 195, "Up to 195: Barbaric Shoulders" },
		{ 205, "Up to 205: Dusky Bracers" },
		{ 220, "Up to 220: Thick Armor Kit" },
		{ 225, "Up to 225: Nightscape Headband" },
		{ 250, "Up to 250: Depends on your specialization\nNightscape Headband/Tunic/Pants (Elemental)\nTough Scorpid Breastplate/Gloves (Dragonscale)\nTurtle Scale set (Tribal)" },
		{ 260, "Up to 260: Nightscape Boots" },
		{ 270, "Up to 270: Wicked Leather Gauntlets" },
		{ 285, "Up to 285: Wicked Leather Bracers" },
		{ 300, "Up to 300: Wicked Leather Headband" },
		{ 310, "Up to 310: Knothide Leather" },
		{ 320, "Up to 320: Wild Draenish Gloves" },
		{ 325, "Up to 325: Thick Draenic Boots" },
		{ 335, "Up to 335: Heavy Knothide Leather\n|cFFFFD700Don't sell them, you'll need them later" },
		{ 340, "Up to 340: Thick Draenic Vest" },
		{ 350, "Up to 350: Felscale Breastplate" },
		{ 375, "Up to 375: Borean Armor Kit" },
		{ 385, "Up to 385: Arctic Boots" },
		{ 395, "Up to 395: Arctic Belt" },
		{ 400, "Up to 400: Arctic Wristguards" },
		{ 405, "Up to 405: Nerubian Leg Armor" },
		{ 410, "Up to 410: Any Dark Chestpiece or Leggings" },
		{ 425, "Up to 425: Any Fur Lining\nTradeskill bags" },
		{ 450, "Up to 450: Whatever makes you earn a point,\ndepending on your needs" },
	},
	[BI["Engineering"]] = {
		{ 40, "Up to 40: Rough Blasting Powder" },
		{ 50, "Up to 50: Handful of Copper Bolt" },
		{ 51, "Craft one Arclight Spanner" },
		{ 65, "Up to 65: Copper Tubes" },
		{ 75, "Up to 75: Rough Boom Sticks" },
		{ 95, "Up to 95: Coarse Blasting Powder" },
		{ 105, "Up to 105: Silver Contacts" },
		{ 120, "Up to 120: Bronze Tubes" },
		{ 125, "Up to 125: Small Bronze Bombs" },
		{ 145, "Up to 145: Heavy Blasting Powder" },
		{ 150, "Up to 150: Big Bronze Bombs" },
		{ 175, "Up to 175: Blue, Green or Red Fireworks" },
		{ 176, "Craft one Gyromatic Micro-Adjustor" },
		{ 190, "Up to 190: Solid Blasting Powder" },
		{ 195, "Up to 195: Big Iron Bomb" },
		{ 205, "Up to 205: Mithril Tubes" },
		{ 210, "Up to 210: Unstable Triggers" },
		{ 225, "Up to 225: Hi-Impact Mithril Slugs" },
		{ 235, "Up to 235: Mithril Casings" },
		{ 245, "Up to 245: Hi-Explosive Bomb" },
		{ 250, "Up to 250: Mithril Gyro-Shot" },
		{ 260, "Up to 260: Dense Blasting Powder" },
		{ 290, "Up to 290: Thorium Widget" },
		{ 300, "Up to 300: Thorium Tubes\nor Thorium Shells (cheaper)" },
		{ 310, "Up to 310: Fel Iron Casing,\nHandful of Fel Iron Bolts,\n and Elemental Blasting Powder\nKeep them all for future crafts" },
		{ 320, "Up to 320: Fel Iron Bomb" },
		{ 335, "Up to 335: Fel Iron Musket" },
		{ 350, "Up to 350: White Smoke Flare" },
		{ 375, "Up to 375: Cobalt Frag Bomb" },
		{ 430, "Up to 430: Mana & Healing Injector Kit\nYou'll need them on the long run" },
		{ 435, "Up to 435: Mana Injector Kit" },
		{ 450, "Up to 450: Whatever makes you earn a point,\ndepending on your needs" },
	},
	[BI["Jewelcrafting"]] = {
		{ 20, "Up to 20: Delicate Copper Wire" },
		{ 30, "Up to 30: Rough Stone Statue" },
		{ 50, "Up to 50: Tigerseye Band" },
		{ 75, "Up to 75: Bronze Setting" },
		{ 80, "Up to 80: Solid Bronze Ring" },
		{ 90, "Up to 90: Elegant Silver Ring" },
		{ 110, "Up to 110: Ring of Silver Might" },
		{ 120, "Up to 120: Heavy Stone Statue" },
		{ 150, "Up to 150: Pendant of the Agate Shield\nor Golden Dragon Ring" },
		{ 180, "Up to 180: Mithril Filigree" },
		{ 200, "Up to 200: Engraved Truesilver Ring" },
		{ 210, "Up to 210: Citrine Ring of Rapid Healing" },
		{ 225, "Up to 225: Aquamarine Signet" },
		{ 250, "Up to 250: Thorium Setting" },
		{ 255, "Up to 255: Red Ring of Destruction" },
		{ 265, "Up to 265: Truesilver Healing Ring" },
		{ 275, "Up to 275: Simple Opal Ring" },
		{ 285, "Up to 285: Sapphire Signet" },
		{ 290, "Up to 290: Diamond Focus Ring" },
		{ 300, "Up to 300: Emerald Lion Ring" },
		{ 310, "Up to 310: Any green quality gem" },
		{ 315, "Up to 315: Fel Iron Blood Ring\nor any green quality gem" },
		{ 320, "Up to 320: Any green quality gem" },
		{ 325, "Up to 325: Azure Moonstone Ring" },
		{ 335, "Up to 335: Mercurial Adamantite (required later)\nor any green quality gem" },
		{ 350, "Up to 350: Heavy Adamantite Ring" },
		{ 355, "Up to 355: Any blue quality gem" },
		{ 360, "Up to 360: World drop recipes like:\nLiving Ruby Pendant\nor Thick Felsteel Necklace" },
		{ 365, "Up to 365: Ring of Arcane Shielding\nThe Sha'tar - Honored" },
		{ 375, "Up to 375: Transmute diamonds\nWorld drops (blue quality)\nRevered with Sha'tar, Honor Hold, Thrallmar" },
		{ 400, "Up to 400: Any green quality gem" },
		{ 420, "Up to 420: Shadowmight ring" },
		{ 450, "Up to 450: Icy Prisms" },
		{ 475, "Up to 475: Prospect Ore for Gems" },
		{ 525, "Up to 525: Recipes obtained from Jewelcrafter Dailies" },
	},
	[BI["Enchanting"]] = {
		{ 2, "Up to 2: Runed Copper Rod" },
		{ 75, "Up to 75: Enchant Bracer - Minor Health" },
		{ 85, "Up to 85: Enchant Bracer - Minor Deflection" },
		{ 100, "Up to 100: Enchant Bracer - Minor Stamina" },
		{ 101, "Craft one Runed Silver Rod" },
		{ 105, "Up to 105: Enchant Bracer - Minor Stamina" },
		{ 120, "Up to 120: Greater Magic Wand" },
		{ 130, "Up to 130: Enchant Shield - Minor Stamina" },
		{ 150, "Up to 150: Enchant Bracer - Lesser Stamina" },
		{ 151, "Craft one Runed Golden Rod" },
		{ 160, "Up to 160: Enchant Bracer - Lesser Stamina" },
		{ 165, "Up to 165: Enchant Shield - Lesser Stamina" },
		{ 180, "Up to 180: Enchant Bracer - Spirit" },
		{ 200, "Up to 200: Enchant Bracer - Strength" },
		{ 201, "Craft one Runed Truesilver Rod" },
		{ 205, "Up to 205: Enchant Bracer - Strength" },
		{ 225, "Up to 225: Enchant Cloak - Greater Defense" },
		{ 235, "Up to 235: Enchant Gloves - Agility" },
		{ 245, "Up to 245: Enchant Chest - Superior Health" },
		{ 250, "Up to 250: Enchant Bracer - Greater Strength" },
		{ 270, "Up to 270: Lesser Mana Oil\nRecipe is sold in Silithus" },
		{ 290, "Up to 290: Enchant Shield - Greater Stamina\nor Enchant Boots: Greater Stamina" },
		{ 291, "Craft one Runed Arcanite Rod" },
		{ 300, "Up to 300: Enchant Cloak - Superior Defense" },
		{ 301, "Craft one Runed Fel Iron Rod" },
		{ 305, "Up to 305: Enchant Cloak - Superior Defense" },
		{ 315, "Up to 315: Enchant Bracers - Assault" },
		{ 325, "Up to 325: Enchant Cloak - Major Armor\nor Enchant Gloves - Assault" },
		{ 335, "Up to 335: Enchant Chest - Major Spirit" },
		{ 340, "Up to 340: Enchant Shield - Major Stamina" },
		{ 345, "Up to 345: Superior Wizard Oil\nDo this up to 350 if you have the mats" },
		{ 350, "Up to 350: Enchant Gloves - Major Strength" },
		{ 351, "Craft one Runed Adamantite Rod" },
		{ 360, "Up to 360: Enchant Gloves - Major Strength" },
		{ 370, "Up to 370: Enchant Gloves - Spell Strike\nRequires Revered with Cenarion Expedition" },
		{ 375, "Up to 375: Enchant Ring - Healing Power\nRequires Revered with The Sha'tar" },
		{ 376, "Craft one Runed Eternium Rod" },
		{ 380, "Up to 380: Enchant Chest - Super Stats" },
		{ 390, "Up to 390: Enchant Weapon - Greater Potency" },
		{ 425, "Up to 425: Craft one Runed Titanium Rod" },
		{ 450, "Up to 450: Whatever earns a skill-up" },
		{ 475, "Up to 475: Disenenchant all greens" },
		{ 515, "Craft one Runed Elementium Rod" },
		{ 525, "Up to 525: Trade in Shards for Recipes" },
	},
	[BI["Blacksmithing"]] = {	
		{ 25, "Up to 25: Rough Sharpening Stones" },
		{ 45, "Up to 45: Rough Grinding Stones" },
		{ 75, "Up to 75: Copper Chain Belt" },
		{ 80, "Up to 80: Coarse Grinding Stones" },
		{ 100, "Up to 100: Runed Copper Belt" },
		{ 105, "Up to 105: Silver Rod" },
		{ 125, "Up to 125: Rough Bronze Leggings" },
		{ 150, "Up to 150: Heavy Grinding Stone" },
		{ 155, "Up to 155: Golden Rod" },
		{ 165, "Up to 165: Green Iron Leggings" },
		{ 185, "Up to 185: Green Iron Bracers" },
		{ 200, "Up to 200: Golden Scale Bracers" },
		{ 210, "Up to 210: Solid Grinding Stone" },
		{ 215, "Up to 215: Golden Scale Bracers" },
		{ 235, "Up to 235: Steel Plate Helm\nor Mithril Scale Bracers (cheaper)\nRecipe in Aerie Peak (A) or Stonard (H)" },
		{ 250, "Up to 250: Mithril Coif\nor Mithril Spurs (cheaper)" },
		{ 260, "Up to 260: Dense Sharpening Stones" },
		{ 270, "Up to 270: Thorium Belt or Bracers (cheaper)\nEarthforged Leggings (Armorsmith)\nLight Earthforged Blade (Swordsmith)\nLight Emberforged Hammer (Hammersmith)\nLight Skyforged Axe (Axesmith)" },
		{ 295, "Up to 295: Imperial Plate Bracers" },
		{ 300, "Up to 300: Imperial Plate Boots" },
		{ 305, "Up to 305: Fel Weightstone" },
		{ 320, "Up to 320: Fel Iron Plate Belt" },
		{ 325, "Up to 325: Fel Iron Plate Boots" },
		{ 330, "Up to 330: Lesser Rune of Warding" },
		{ 335, "Up to 335: Fel Iron Breastplate" },
		{ 340, "Up to 340: Adamantite Cleaver\nSold in Shattrah, Silvermoon, Exodar" },
		{ 345, "Up to 345: Lesser Rune of Shielding\nSold in Wildhammer Stronghold and Thrallmar" },
		{ 350, "Up to 350: Adamantite Cleaver" },
		{ 360, "Up to 360: Adamantite Weightstone\nRequires Cenarion Expedition - Honored" },
		{ 370, "Up to 370: Felsteel Gloves (Auchenai Crypts)\nFlamebane Gloves (Aldor - Honored)\nEnchanted Adamantite Belt (Scryer - Friendly)" },
		{ 375, "Up to 375: Felsteel Gloves (Auchenai Crypts)\nFlamebane Breastplate (Aldor - Revered)\nEnchanted Adamantite Belt (Scryer - Friendly)" },
		{ 385, "Up to 385: Cobalt Gauntlets" },
		{ 393, "Up to 393: Spiked Cobalt Shoulders\nor Chestpiece" },
		{ 395, "Up to 395: Spiked Cobalt Gauntlets" },
		{ 400, "Up to 400: Spiked Cobalt Belt" },
		{ 410, "Up to 410: Spiked Cobalt Bracers" },
		{ 415, "Up to 415: Tempered Saronite Shoulders" },
		{ 420, "Up to 420: Tempered Saronite Bracers" },
		{ 430, "Up to 430: Daunting Handguards" },
		{ 445, "Up to 445: Daunting Legplates" },
		{ 450, "Up to 450: Any Epic" },
		{ 500, "Up to 500: Any skill-up will do" },
		{ 525, "Up to 525: Farm Ore for Recipes in Twilight Highlands" },
	},
	[BI["Alchemy"]] = {	
		{ 60, "Up to 60: Minor Healing Potion" },
		{ 110, "Up to 110: Lesser Healing Potion" },
		{ 140, "Up to 140: Healing Potion" },
		{ 155, "Up to 155: Lesser Mana Potion" },
		{ 185, "Up to 185: Greater Healing Potion" },
		{ 210, "Up to 210: Elixir of Agility" },
		{ 215, "Up to 215: Elixir of Greater Defense" },
		{ 230, "Up to 230: Superior Healing Potion" },
		{ 250, "Up to 250: Elixir of Detect Undead" },
		{ 265, "Up to 265: Elixir of Greater Agility" },
		{ 285, "Up to 285: Superior Mana Potion" },
		{ 300, "Up to 300: Major Healing Potion" },
		{ 315, "Up to 315: Volatile Healing Potion\nor Major Mana Potion" },
		{ 350, "Up to 350: Mad Alchemists's Potion\nTurns yellow at 335, but cheap to make" },
		{ 375, "Up to 375: Major Dreamless Sleep Potion\nSold in Allerian Stronghold (A)\nor Thunderlord Stronghold (H)" },
	},
	[L["Mining"]] = {
		{ 65, "Up to 65: Mine Copper\nAvailable in all starting zones" },
		{ 125, "Up to 125: Mine Tin, Silver, Incendicite and Lesser Bloodstone\n\nMine Incendicite at Thelgen Rock (Wetlands)\nEasy leveling up to 125" },
		{ 175, "Up to 175: Mine Iron and Gold\nDesolace, Ashenvale, Badlands, Arathi Highlands,\nAlterac Mountains, Stranglethorn Vale, Swamp of Sorrows" },
		{ 250, "Up to 250: Mine Mithril and Truesilver\nBlasted Lands, Searing Gorge, Badlands, The Hinterlands,\nWestern Plaguelands, Azshara, Winterspring, Felwood, Stonetalon Mountains, Tanaris" },
		{ 300, "Up to 300: Mine Thorium \nUn’goro Crater, Azshara, Winterspring, Blasted Lands\nSearing Gorge, Burning Steppes, Eastern Plaguelands, Western Plaguelands" },
		{ 330, "Up to 330: Mine Fel Iron\nHellfire Peninsula, Zangarmarsh" },
		{ 375, "Up to 375: Mine Fel Iron and Adamantite\nTerrokar Forest, Nagrand\nBasically everywhere in Outland" },
		{ 400, "Up to 400: Mine Cobalt" },
		{ 425, "Up to 450: Mine Saronite" },
		{ 475, "Up to 475: Mine Obsidium" },
		{ 500, "Up to 500: Mine Elementium" },
		{ 525, "Up to 525: Smelt Hardened Elementium and Mine Pyrite" },
	},
	[L["Herbalism"]] = {
		{ 50, "Up to 50: Collect Silverleaf and Peacebloom\nAvailable in all starting zones" },
		{ 70, "Up to 70: Collect Mageroyal and Earthroot\nThe Barrens, Westfall, Silverpine Forest, Loch Modan" },
		{ 100, "Up to 100: Collect Briarthorn\nSilverpine Forest, Duskwood, Darkshore,\nLoch Modan, Redridge Mountains" },
		{ 115, "Up to 115: Collect Bruiseweed\nAshenvale, Stonetalon Mountains, Southern Barrens\nLoch Modan, Redridge Mountains" },
		{ 125, "Up to 125: Collect Wild Steelbloom\nStonetalon Mountains, Arathi Highlands, Stranglethorn Vale\nSouthern Barrens, Thousand Needles" },
		{ 160, "Up to 160: Collect Kingsblood\nAshenvale, Stonetalon Mountains, Wetlands,\nHillsbrad Foothills, Swamp of Sorrows" },
		{ 185, "Up to 185: Collect Fadeleaf\nSwamp of Sorrows" },
		{ 205, "Up to 205: Collect Khadgar's Whisker\nThe Hinterlands, Arathi Highlands, Swamp of Sorrows" },
		{ 230, "Up to 230: Collect Firebloom\nSearing Gorge, Blasted Lands, Tanaris" },
		{ 250, "Up to 250: Collect Sungrass\nFelwood, Feralas, Azshara\nThe Hinterlands" },
		{ 270, "Up to 270: Collect Gromsblood\nFelwood, Blasted Lands,\nMannoroc Coven in Desolace" },
		{ 285, "Up to 285: Collect Dreamfoil\nUn'goro Crater, Azshara" },
		{ 300, "Up to 300: Collect Plagueblooms\nEastern & Western Plaguelands, Felwood\nor Icecaps in Winterspring" },
		{ 330, "Up to 330: Collect Felweed\nHellfire Peninsula, Zangarmarsh" },
		{ 375, "Up to 375: Any flower available in Outland\nFocus on Zangarmarsh & Terrokar Forest" },
	},
	[L["Skinning"]] = {
		{ 525, "Up to 525: Divide your current skill level by 5,\nand skin mobs of that level" },
	},

	-- source: http://www.elsprofessions.com/inscription/leveling.html
	[L["Inscription"]] = {
		{ 18, "Up to 18: Ivory Ink" },
		{ 35, "Up to 35: Scroll of Intellect, Spirit or Stamina" },
		{ 50, "Up to 50: Moonglow Ink\nSave if for Minor Inscription Research" },
		{ 75, "Up to 75: Scroll of Recall, Armor Vellum" },
		{ 79, "Up to 79: Midnight Ink" },
		{ 80, "Up to 80: Minor Inscription Research" },
		{ 85, "Up to 85: Glyph of Backstab, Frost Nova\nRejuvenation, ..." },
		{ 87, "Up to 87: Hunter's Ink" },
		{ 90, "Up to 90: Glyph of Corruption, Flame Shock\nRapid Charge, Wrath" },
		{ 100, "Up to 100: Glyph of Ice Armor, Maul\nSerpent Sting" },
		{ 104, "Up to 104: Lion's Ink" },
		{ 105, "Up to 105: Glyph of Arcane Shot, Arcane Explosion" },
		{ 110, "Up to 110: Glyph of Eviscerate, Holy Light, Fade" },
		{ 115, "Up to 115: Glyph of Fire Nova Totem\nHealth Funel, Rending" },
		{ 120, "Up to 120: Glyph of Arcane Missiles, Healing Touch" },
		{ 125, "Up to 125: Glyph of Expose Armor\nFlash Heal, Judgment" },
		{ 130, "Up to 130: Dawnstar Ink" },
		{ 135, "Up to 135: Glyph of Blink\nImmolation, Moonfire" },
		{ 140, "Up to 140: Glyph of Lay on Hands\nGarrote, Inner Fire" },
		{ 142, "Up to 142: Glyph of Sunder Armor\nImp, Lightning Bolt" },
		{ 150, "Up to 150: Strange Tarot" },
		{ 155, "Up to 155: Jadefire Ink" },
		{ 160, "Up to 160: Scroll of Stamina III" },
		{ 165, "Up to 165: Glyph of Gouge, Renew" },
		{ 170, "Up to 170: Glyph of Shadow Bolt\nStrength of Earth Totem" },
		{ 175, "Up to 175: Glyph of Overpower" },
		{ 177, "Up to 177: Royal Ink" },
		{ 183, "Up to 183: Scroll of Agility III" },
		{ 185, "Up to 185: Glyph of Cleansing\nShadow Word: Pain" },
		{ 190, "Up to 190: Glyph of Insect Swarm\nFrost Shock, Sap" },
		{ 192, "Up to 192: Glyph of Revenge\nVoidwalker" },
		{ 200, "Up to 200: Arcane Tarot" },
		{ 204, "Up to 204: Celestial Ink" },
		{ 210, "Up to 210: Armor Vellum II" },
		{ 215, "Up to 215: Glyph of Smite, Sinister Strike" },
		{ 220, "Up to 220: Glyph of Searing Pain\nHealing Stream Totem" },
		{ 225, "Up to 225: Glyph of Starfire\nBarbaric Insults" },
		{ 227, "Up to 227: Fiery Ink" },
		{ 230, "Up to 230: Scroll of Agility IV" },
		{ 235, "Up to 235: Glyph of Dispel Magic" },
		{ 250, "Up to 250: Weapon Vellum II" },
		{ 255, "Up to 255: Scroll of Stamina V" },
		{ 260, "Up to 260: Scroll of Spirit V" },
		{ 265, "Up to 265: Glyph of Freezing Trap, Shred" },
		{ 270, "Up to 270: Glyph of Exorcism, Bone Shield" },
		{ 275, "Up to 275: Glyph of Fear Ward, Frost Strike" },
		{ 285, "Up to 285: Ink of the Sky" },
		{ 295, "Up to 295: Glyph of Execution\nSprint, Death Grip" },
		{ 300, "Up to 300: Scroll of Spirit VI" },
		{ 304, "Up to 304: Ethereal Ink" },
		{ 305, "Up to 305: Glyph of Plague Strike\nEarthliving Weapon, Flash of Light" },
		{ 310, "Up to 310: Glyph of Feint" },
		{ 315, "Up to 315: Glyph of Rake, Rune Tap" },
		{ 320, "Up to 320: Glyph of Holy Nova, Rapid Fire" },
		{ 325, "Up to 325: Glyph of Blood Strike, Sweeping Strikes" },
		{ 327, "Up to 327: Darkflame Ink" },
		{ 330, "Up to 330: Glyph of Mage Armor, Succubus" },
		{ 335, "Up to 335: Glyph of Scourge Strike, Windfury Weapon" },
		{ 340, "Up to 340: Glyph of Arcane Power, Seal of Command" },
		{ 345, "Up to 345: Glyph of Ambush, Death Strike" },
		{ 350, "Up to 350: Glyph of Whirlwind" },
		{ 360, "Up to 360: Glyph of Mind Flay, Banish" },
		{ 365, "Up to 365: Scroll of Intellect VII" },
		{ 370, "Up to 370: Scroll of Strength VII" },
		{ 375, "Up to 375: Scroll of Agility VII" },
		{ 380, "Up to 380: Glyph of Focus, Strangulate" },
		{ 400, "Up to 400: Northrend Inscription Research" },
		{ 450, "Up to 450: Rare Darkmoon Cards" },
	},

	[L["Lockpicking"]] = {
		{ 75, "Up to 75: Up to Level 15" },
		{ 125, "Up to 125: Up to Level 25" },
		{ 175, "Up to 175: Up to Level 35" },
		{ 200, "Up to 250: Up to Level 40" },
		{ 225, "Up to 225: Up to Level 45" },
		{ 275, "Up to 275: Up to Level 55" },
		{ 300, "Up to 300: Up to Level 60" },
		{ 325, "Up to 325: Up to Level 65" },
		{ 375, "Up to 375: Up to Level 70" },
		{ 400, "Up to 400: Up to Level 80" },
		{ 425, "Up to 425: Up to Level 85" },
	},
	
	-- ** Secondary professions **
	[BI["First Aid"]] = {
		{ 40, "Up to 40: Linen Bandages" },
		{ 80, "Up to 80: Heavy Linen Bandages\nBecome Journeyman at 50" },
		{ 115, "Up to 115: Wool Bandages" },
		{ 150, "Up to 150: Heavy Wool Bandages" },
		{ 180, "Up to 180: Silk Bandages" },
		{ 210, "Up to 210: Heavy Silk Bandages" },
		{ 240, "Up to 240: Mageweave Bandages" },
		{ 260, "Up to 260: Heavy Mageweave Bandages" },
		{ 290, "Up to 290: Runecloth Bandages" },
		{ 330, "Up to 330: Heavy Runecloth Bandages" },
		{ 360, "Up to 360: Netherweave Bandages" },
		{ 375, "Up to 375: Heavy Netherweave Bandages" },
		{ 400, "Up to 400: Frostweave Bandages" },
		{ 425, "Up to 425: Heavy Frostweave Bandages" },
		{ 475, "Up to 475: Embersilk Bandages" },
		{ 525, "Up to 525: Heavy Embersilk Bandages" },
	},
	[BI["Cooking"]] = {
		{ 40, "Up to 40: Spice Bread"	},
		{ 85, "Up to 85: Smoked Bear Meat, Crab Cake" },
		{ 100, "Up to 100: Cooked Crab Claw (A)\nDig Rat Stew (H)" },
		{ 125, "Up to 125: Dig Rat Stew (H)\nSeasoned Wolf Kabob (A)" },
		{ 175, "Up to 175: Curiously Tasty Omelet (A)\nHot Lion Chops (H)" },
		{ 200, "Up to 200: Roast Raptor" },
		{ 225, "Up to 225: Spider Sausage\n\n|cFFFFFFFFCooking quest:\n|cFFFFD70012 Giant Eggs,\n10 Zesty Clam Meat,\n20 Alterac Swiss " },
		{ 275, "Up to 275: Monster Omelet\nor Tender Wolf Steaks" },
		{ 285, "Up to 285: Runn Tum Tuber Surprise\nDire Maul (Pusillin)" },
		{ 300, "Up to 300: Smoked Desert Dumplings\nQuest in Silithus" },
		{ 325, "Up to 325: Ravager Dogs, Buzzard Bites" },
		{ 350, "Up to 350: Roasted Clefthoof\nWarp Burger, Talbuk Steak" },
		{ 375, "Up to 375: Crunchy Serpent\nMok'nathal Treats" },
		{ 400, "Up to 400: Any Trainer-learned Cooking Recipes" },
		{ 450, "Up to 450: Dalaran Cooking Dailies" },
		{ 525, "Up to 525: Stormwind & Orgrimmar Cooking Dailies" },
	},	
	-- source: http://www.wowguideonline.com/fishing.html
	[BI["Fishing"]] = {
		{ 50, "Up to 50: Any starting zone" },
		{ 75, "Up to 75:\nThe Canals in Stormwind\nThe Pond in Orgrimmar" },
		{ 150, "Up to 150: Hillsbrad Foothills' river" },
		{ 225, "Up to 225: Expert Fishing" },
		{ 250, "Up to 250: Hinterlands, Tanaris\n\n|cFFFFFFFFFishing quest in Dustwallow Marsh\n|cFFFFD700Savage Coast Blue Sailfin (Stranglethorn Vale)\nFeralas Ahi (Verdantis River, Feralas)\nSer'theris Striker (Northern Sartheris Strand, Desolace)\nMisty Reed Mahi Mahi (Swamp of Sorrows coastline)" },
		{ 260, "Up to 260: Felwood" },
		{ 300, "Up to 300: Azshara" },
		{ 330, "Up to 330: Eastern Zangarmarsh" },
		{ 345, "Up to 345: Western Zangarmarsh" },
		{ 360, "Up to 360: Terrokar Forest" },
		{ 375, "Up to 375: Terrokar Forest, in altitude\nFlying mount required" },
		{ 400, "Up to 400: Borean Tundra" },
		{ 450, "Up to 450: Dalaran Fishing Coins; Any Northrend Area" },
		{ 525, "Up to 525: Any Cataclysm Zone\nStormwind & Orgrimmar Fishing Dailies" },
	},

	[BI["Archaeology"]] = {
		{ 300, "Up to 300: Kalimdor\nEastern Kingdoms" },
		{ 375, "Up to 375: Outland" },
		{ 450, "Up to 450: Northrend" },
		{ 525, "Up to 525: MountHyjal\nUldum\nTwilight Highlands" },
	},
	
	-- suggested leveling zones, as defined by recommended quest levels, Updated for Cataclysm
	["Leveling"] = {
		{ 10, "Up to 10: Any starting zone" },
		{ 15, "Up to 15: "  .. BZ["Westfall"]},
		{ 16, "Up to 16: "  .. BZ["Ruins of Gilneas"]},
		{ 20, "Up to 20: "  .. BZ["Azshara"] .. "\n" .. BZ["Loch Modan"] .. "\n" .. BZ["Bloodmyst Isle"]
							.. "\n" .. BZ["Darkshore"] .. "\n" .. BZ["Silverpine Forest"] .. "\n" .. BZ["Northern Barrens"] 
							.. "\n" .. BZ["Ghostlands"] .. "\n" .. BZ["Redridge Mountains"]},
		{ 25, "Up to 25: " 	.. BZ["Duskwood"] .. "\n" .. BZ["Wetlands"] .. "\n" .. BZ["Ashenvale"] 
							.. "\n" .. BZ["Hillsbrad Foothills"]},
		{ 30, "Up to 30: " 	.. BZ["Arathi Highlands"] .. "\n" .. BZ["Northern Stranglethorn"] .. "\n" .. BZ["Stonetalon Mountains"]},
		{ 35, "Up to 35: " 	.. BZ["The Cape of Stranglethorn"] .. "\n" .. BZ["Desolace"] .. "\n" .. BZ["The Hinterlands"]
							.. "\n" .. BZ["Southern Barrens"]},
		{ 40, "Up to 40: " 	.. BZ["Dustwallow Marsh"] .. "\n" .. BZ["Feralas"] .. "\n" .. BZ["Western Plaguelands"]},
		{ 45, "Up to 45: " 	.. BZ["Eastern Plaguelands"] .. "\n" .. BZ["Thousand Needles"]},
		{ 48, "Up to 48: "  .. BZ["Badlands"]},
		{ 50, "Up to 50: " 	.. BZ["Tanaris"] .. "\n" .. BZ["Felwood"] .. "\n" .. BZ["Searing Gorge"]},
		{ 52, "Up to 52: "	.. BZ["Burning Steppes"]},
		{ 54, "Up to 54: " 	.. BZ["Swamp of Sorrows"]},
		{ 55, "Up to 55: " 	.. BZ["Un'Goro Crater"] .. "\n" .. BZ["Winterspring"]},
		{ 58, "Up to 58: " 	.. BZ["Blasted Lands"]},
		{ 60, "Up to 60: " 	.. BZ["Deadwind Pass"] .. "\n" .. BZ["Moonglade"] .. "\n" .. BZ["Silithus"]},
		{ 63, "Up to 63: " 	.. BZ["Hellfire Peninsula"]},
		{ 64, "Up to 64: " 	.. BZ["Zangarmarsh"]},
		{ 65, "Up to 65: " 	.. BZ["Terokkar Forest"]},
		{ 67, "Up to 67: " 	.. BZ["Nagrand"]},
		{ 68, "Up to 68: " 	.. BZ["Blade's Edge Mountains"]},
		{ 70, "Up to 70: " 	.. BZ["Netherstorm"] .. "\n" .. BZ["Shadowmoon Valley"] .. "\n" .. BZ["Isle of Quel'Danas"] 
							.. "\n" .. BZ["Deadwind Pass"]},
		{ 72, "Up to 72: " 	.. BZ["Howling Fjord"] .. "\n" .. BZ["Borean Tundra"]},
		{ 75, "Up to 75: " 	.. BZ["Dragonblight"] .. "\n" .. BZ["Grizzly Hills"]},
		{ 76, "Up to 76: " 	.. BZ["Zul'Drak"]},
		{ 78, "Up to 78: " 	.. BZ["Sholazar Basin"]},
		{ 80, "Up to 80: " 	.. BZ["Crystalsong Forest"] .. "\n" .. BZ["The Storm Peaks"] .. "\n" .. BZ["Icecrown"]},
		{ 82, "Up to 82: " 	.. BZ["Hyjal"] .. "\n" .. BZ["Vashj'ir"]},
		{ 83, "Up to 83: " 	.. BZ["Deepholm"]},
		{ 84, "Up to 84: "	.. BZ["Uldum"]},
		{ 85, "Up to 85: "  .. BZ["Twilight Highlands"]},
	
	},

}