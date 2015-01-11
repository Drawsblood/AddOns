--------------------------------------------------------
-- Blood Legion Cooldown - Cooldowns --
--------------------------------------------------------
if not BLCD then return end
local BLCD = BLCD

local index = 0
local function getIndex()
	index = index + 1
	return index
end

BLCD.cooldowns = {
-- Paladin
	[31821] = { -- Devotion Aura
		spellID = 31821,
		name = "PAL_DEAU",
		succ = "SPELL_CAST_SUCCESS",
		CD = 180,
		cast = 6,
		class = "PALADIN",
		spec = 65,
		index = getIndex(),
	},
	[6940] = { -- Hand of Sacrifice
		spellID = 6940,
		name = "PAL_HAOFSA",
		succ = "SPELL_CAST_SUCCESS",
		charges = 2,
		CD = 120,
		cast = 12,
		class = "PALADIN",
		index = getIndex(),
	},
	[1022] = { -- Hand of Protection
		spellID = 1022,
		name = "PAL_HAOFPR",
		succ = "SPELL_CAST_SUCCESS",
		charges = 2,
		CD = 300,
		cast = 10,
		class = "PALADIN",
		index = getIndex(),
	},
	[105809] = { -- Holy Avenger
		spellID = 105809,
		name = "PAL_HOAV",
		succ = "SEPLL_CAST_SUCCESS",
		CD = 120,
		cast = 18,
		class = "PALADIN",
		talent = 5,
		talentidx = 17597,
		index = getIndex(),
	},
	[1038] = { -- Hand of Salvation
		spellID = 1038,
		name = "PAL_HAOFSAL",
		succ = "SPELL_CAST_SUCCESS",
		charges = 2,
		CD = 120,
		cast = 10,
		class = "PALADIN",
		spec = 66,
		index = getIndex(),
	},
	[114039] = { -- Hand of Purity
		spellID = 114039,
		name = "PAL_HAOFPU",
		succ = "SPELL_CAST_SUCCESS",
		charges = 2,
		CD = 30,
		cast = 6,
		class = "PALADIN",
		talent = 4,
		talentidx = 17589,
		index = getIndex(),
	},
	[114158] = { -- Light's Hammer
		spellID = 114158,
		name = "PAL_LIHA",
		succ = "SPELL_CAST_SUCCESS",
		CD = 60,
		cast = 15,
		class = "PALADIN",
		talent = 6,
		talentidx = 17607,
		index = getIndex(),
	},
-- Priest
	[62618] = { -- Power Word: Barrier
		spellID = 62618,
		name = "PRI_POWOBA",
		succ = "SPELL_CAST_SUCCESS",
		CD = 180,
		cast = 10,
		class = "PRIEST",
		spec = 256,
		index = getIndex(),
	},
	[33206] = { -- Pain Suppression
		spellID = 33206,
		name = "PRI_PASU",
		succ = "SPELL_CAST_SUCCESS",
		CD = 180,
		cast = 8,
		class = "PRIEST",
		spec = 256,
		index = getIndex(),
	},
	[109964] = { -- Spirit Shell
		spellID = 109964,
		name = "PRI_SPSH",
		succ = "SPELL_CAST_SUCCESS",
		CD = 60,
		cast = 10,
		class = "PRIEST",
		talent = 5,
		talentidx = 21754,
		index = getIndex(),
	},
	[64843] = { -- Divine Hymn
		spellID = 64843,
		name = "PRI_DIHY",
		succ = "SPELL_CAST_SUCCESS",
		CD = 180,
		cast = 8,
		class = "PRIEST",
		spec = 257,
		index = getIndex(),
	},
	[47788] = { -- Guardian Spirit
		spellID = 47788,
		succ = "SPELL_CAST_SUCCESS",
		name = "PRI_GUSP",
		CD = 180,
		cast = 10,
		class = "PRIEST",
		spec = 257,
		index = getIndex(),
	},
	[15286] = { -- Vampiric Embrace
		spellID = 15286,
		succ = "SPELL_CAST_SUCCESS",
		name = "PRI_VAEM",
		CD = 180,
		cast = 15,
		class = "PRIEST",
		spec = 258,
		index = getIndex(),
	},
-- Druid
	[740] = { -- Tranquility
		spellID = 740,
		succ = "SPELL_CAST_SUCCESS",
		name = "DRU_TR",
		CD = 180,
		cast = 8,
		class = "DRUID",
		spec = 105,
		index = getIndex(),
	},
	[102342] = { -- Ironbark
		spellID = 102342,
		succ = "SPELL_CAST_SUCCESS",
		name = "DRU_IR",
		CD = 60,
		cast = 12,
		class = "DRUID",
		spec = 105,
		index = getIndex(),
	},
	[20484] = { -- Rebirth
		spellID = 20484,
		succ = "SPELL_RESURRECT",
		name = "DRU_RE",
		CD = 600,
		class = "DRUID",
		index = getIndex(),
	},
	[108291] = { -- Heart of the Wild
		spellID = 108291,
		succ = "SPELL_CAST_SUCCESS",
		name = "DRU_HEOFTHWI",
		CD = 360,
		cast = 45,
		class = "DRUID",
		talent = 6,
		--Special idx for all tiers, see code
		index = getIndex(),
	},
	[77761] = { -- Stampeding Roar
		spellID = 77761,
		succ = "SPELL_CAST_SUCCESS",
		name = "DRU_STRO",
		CD = 120,
		cast = 8,
		class = "DRUID",
		index = getIndex(),
	},
	[124974] = { -- Nature's Vigi
		spellID = 124974,
		succ = "SPELL_CAST_SUCCESS",
		name = "DRU_NAVI",
		CD = 90,
		cast = 30,
		class = "DRUID",
		talent = 5,
		talentidx = 18586,
		index = getIndex(),
	},
-- Shaman
	[98008] = { -- Spirit Link Totem
		spellID = 98008,
		succ = "SPELL_CAST_SUCCESS",
		name = "SHA_SPLITO",
		CD = 180,
		cast = 6,
		class = "SHAMAN",
		spec = 264,
		index = getIndex(),
	},
	[108280] = { -- Healing Tide Totem
		spellID = 108280,
		succ = "SPELL_CAST_SUCCESS",
		name = "SHA_HETITO",
		CD = 180,
		cast = 10,
		class = "SHAMAN",
		spec = 264,
		index = getIndex(),
	},
	[8143] = { -- Tremor Totem
		spellID = 8143,
		succ = "SPELL_CAST_SUCCESS",
		name = "SHA_TRTO",
		CD = 60,
		cast = 6,
		class = "SHAMAN",
		index = getIndex(),
	},
	[2825] = { -- Bloodlust
		spellID = 2825,
		succ = "SPELL_CAST_SUCCESS",
		name = "SHA_BL",
		CD = 300,
		cast = 40,
		class = "SHAMAN",
		index = getIndex(),
	},
	[32182] = { -- Heroism
		spellID = 32182,
		succ = "SPELL_CAST_SUCCESS",
		name = "SHA_HE",
		CD = 300,
		cast = 40,
		class = "SHAMAN",
		index = getIndex(),
	},
	--{ -- Reincarnation  -- Needs work, currently doesn't show in combatlog. Thanks blizz.
		--spellID = 20608,
		--succ = "SPELL_RESURRECT",
		--name = "SHA_RE",
		--CD = 1800,
		--class = "SHAMAN",
	--},
	[108281] = { -- Ancestral Guidance
		spellID = 108281,
		succ = "SPELL_CAST_SUCCESS",
		name = "SHA_ANGU",
		CD = 120,
		cast = 10,
		class = "SHAMAN",
		talent = 5,
		talentidx = 19269,
		index = getIndex(),
	},
 -- Monk
	[115176] = {	-- Zen Meditation
		spellID = 115176,
		succ = "SPELL_CAST_SUCCESS",
		name = "MON_ZEME",
		CD = 180,
		cast = 8,
		class = "MONK",
		notspec = 270,
		index = getIndex(),
	},
	[116849] = {	-- Life Cocoon
		spellID = 116849,
		succ = "SPELL_CAST_SUCCESS",
		name = "MON_LICO",
		CD = 120,
		cast = 12,
		class = "MONK",
		spec = 270,
		index = getIndex(),
	},
	[115310] = {	-- Revival
		spellID = 115310,
		succ = "SPELL_CAST_SUCCESS",
		name = "MON_RE",
		CD = 180,
		class = "MONK",
		spec = 270,
		index = getIndex(),
	},
-- Warlock
	[20707] = { -- Soulstone Resurrection
		spellID = 20707,
		succ = "SPELL_CAST_SUCCESS",
		name = "WARL_SORE",
		CD = 600,
		class = "WARLOCK",
		index = getIndex(),
	},
-- Death Knight
	[61999] = { -- Raise Ally
		spellID = 61999,
		succ = "SPELL_RESURRECT",
		name = "DEA_RAAL",
		CD = 600,
		class = "DEATHKNIGHT",
		index = getIndex(),
	},
	[51052] = { -- Anti-Magic Zone
		spellID = 51052,
		succ = "SPELL_CAST_SUCCESS",
		name = "DEA_ANMAZO",
		CD = 120,
		cast = 3,
		class = "DEATHKNIGHT",
		talent = 2,
		talentidx = 19219,
		index = getIndex(),
	},
-- Warrior
	[97462] = { -- Rallying Cry
		spellID = 97462,
		succ = "SPELL_CAST_SUCCESS",
		name = "WARR_RACR",
		CD = 180,
		cast = 10,
		class = "WARRIOR",
		index = getIndex(),
		notspec = 73,
	},
	[114030] = { -- Vigilance
		spellID = 114030,
		succ = "SPELL_CAST_SUCCESS",
		name = "WARR_VI",
		CD = 120,
		cast = 12,
		class = "WARRIOR",
		talent = 5,
		talentidx = 19676,
		index = getIndex(),
	},
	[3411] = { -- Intervene
		spellID = 3411,
		succ = "SPELL_CAST_SUCCESS",
		name = "WARR_IN",
		CD = 30,
		cast = 10,
		class = "WARRIOR",
		index = getIndex(),
	},
-- Mage
	[80353] = { -- Time Warp
		spellID = 80353,
		succ = "SPELL_CAST_SUCCESS",
		name = "MAG_TIWA",
		CD = 300,
		cast = 40,
		class = "MAGE",
		index = getIndex(),
	},
	[159916] = { -- Amplify Magic
		spellID = 159916,
		succ = "SPELL_CAST_SUCCESS",
		name = "MAG_AMMA",
		CD = 120,
		cast = 6,
		class = "MAGE",
		index = getIndex(),
	},
-- Rogue
	[76577] = { -- Smoke Bomb
		spellID = 76577,
		succ = "SPELL_CAST_SUCCESS",
		name = "ROG_SMBO",
		CD = 180,
		cast = 5,
		class = "ROGUE",
		index = getIndex(),
	},
-- Hunter
	[172106] = { -- Aspect of the Fox
		spellID = 172106,
		succ = "SPELL_CAST_SUCCESS",
		name = "HUN_ASOFTHFO",
		CD = 180,
		cast = 6,
		class = "HUNTER",
		index = getIndex(),
	},
}
--------------------------------------------------------