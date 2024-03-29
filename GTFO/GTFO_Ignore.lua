--------------------------------------------------------------------------
-- GTFO_Ignore.lua 
--------------------------------------------------------------------------
--[[
GTFO Ignore List
Author: Zensunim of Malygos

Change Log:
	v4.12
		- Implemented ignore list system
	
]]--

GTFO.IgnoreSpellCategory["HagaraWateryEntrenchment"] = {
	-- mobID = 55689; -- Hagara the Stormbinder
	spellID = 110317,
	desc = "Watery Entrenchment"
}

GTFO.IgnoreSpellCategory["Fatigue"] = {
	spellID = 3271, -- Not really the spell, but a good placeholder
	desc = "Fatigue",
	tooltip = "Alert when entering a fatigue area",
	override = true
}

GTFO.IgnoreSpellCategory["GarroshDesecrated"] = {
	-- Garrosh Hellscream
	spellID = 144762,
	desc = "Desecrated Axe (Garrosh Phase 1 & 2)",
	tooltip = "Alert from the Desecrated Axe from Garrosh Hellscream (Phase 1 & 2)",
	override = true
}

-- Scanner ignore list
GTFO.IgnoreScan["124255"] = true; -- Monk's Stagger
GTFO.IgnoreScan["124275"] = true; -- Monk's Light Stagger
GTFO.IgnoreScan["34650"] = true; -- Mana Leech
GTFO.IgnoreScan["123051"] = true; -- Mana Leech
GTFO.IgnoreScan["134821"] = true; -- Discharged Energy
GTFO.IgnoreScan["114216"] = true; -- Angelic Bulwark
GTFO.IgnoreScan["6788"] = true; -- Weakened Soul
GTFO.IgnoreScan["136193"] = true; -- Arcing Lightning
GTFO.IgnoreScan["139107"] = true; -- Mind Daggers
GTFO.IgnoreScan["156152"] = true; -- Gushing Wounds
GTFO.IgnoreScan["162510"] = true; -- Tectonic Upheavel
GTFO.IgnoreScan["98021"] = true; -- Spirit Link (Shaman)
GTFO.IgnoreScan["148760"] = true; -- Pheromone Cloud
GTFO.IgnoreScan["175982"] = true; -- Rain of Slag
GTFO.IgnoreScan["158519"] = true; -- Quake
GTFO.IgnoreScan["104330"] = true; -- Demonic Synergy




