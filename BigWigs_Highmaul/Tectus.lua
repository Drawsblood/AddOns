
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Tectus", 994, 1195)
if not mod then return end
mod:RegisterEnableMob(78948)
mod.engageId = 1722

--------------------------------------------------------------------------------
-- Locals
--

local marked = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.adds = CL.adds
	L.adds_desc = "Timers for when new adds enter the fight."

	L.custom_off_barrage_marker = "Crystalline Barrage marker"
	L.custom_off_barrage_marker_desc = "Marks targets of Crystalline Barrage with {rt1}{rt2}{rt3}{rt4}{rt5}, requires promoted or leader."
	L.custom_off_barrage_marker_icon = 1

	L.tectus = EJ_GetEncounterInfo(1195)
	L.shard = "Shard"
	L.motes = "Motes"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Night-Twisted Earthwarper ]]--
		{162894}, -- Gift of Earth
		{162892, "TANK"}, -- Petrification
		162968, -- Earthen Flechettes
		--[[ Night-Twisted Berserker ]]--
		163312, -- Raving Assault
		--[[ General ]]--
		{162288, "TANK"}, -- Accretion
		{162346, "FLASH", "SAY", "ME_ONLY"}, -- Crystalline Barrage
		"custom_off_barrage_marker",
		162475, -- Tectonic Upheaval
		"adds",
		"berserk",
		"bosskill",
	}, {
		[162894] = -10061, -- Night-Twisted Earthwarper
		[163312] = -10062, -- Night-Twisted Berserker
		[162288] = "general",
	}
end

function mod:OnBossEnable()
	--self:Log("SPELL_CAST_SUCCESS", "AddsSpawn", 181113) -- XXX 6.1
	--self:Log("SPELL_CAST_SUCCESS", "BossUnitKilled", 181089) -- XXX 6.1
	-- Tectus
	self:Log("SPELL_AURA_APPLIED_DOSE", "Accretion", 162288)
	self:Log("SPELL_AURA_APPLIED", "CrystallineBarrage", 162346)
	self:Log("SPELL_AURA_REMOVED", "CrystallineBarrageRemoved", 162346)
	self:Log("SPELL_PERIODIC_DAMAGE", "CrystallineBarrageDamage", 162370)
	self:Log("SPELL_PERIODIC_MISSED", "CrystallineBarrageDamage", 162370)
	self:Log("SPELL_CAST_START", "TectonicUpheaval", 162475)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "Split", "boss1", "boss2", "boss3")
	-- Earthwarper
	self:Log("SPELL_CAST_START", "GiftOfEarth", 162894)
	self:Log("SPELL_AURA_APPLIED", "Petrification", 162892)
	self:Log("SPELL_CAST_START", "EarthenFlechettes", 162968)
	self:Log("SPELL_DAMAGE", "EarthenFlechettesDamage", 162968)
	self:Log("SPELL_MISSED", "EarthenFlechettesDamage", 162968)
	-- Berserker
	self:Log("SPELL_CAST_START", "RavingAssault", 163312)
end

function mod:OnEngage()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL", "NewAdd")

	wipe(marked)
	--self:CDBar(162346, 6) -- Crystalline Barrage
	self:CDBar("adds", 14, -10061, "spell_shadow_raisedead") -- Earthwarper
	self:CDBar("adds", 24, -10062, "ability_warrior_endlessrage") -- Berserker

	if not self:LFR() then
		self:Berserk(self:Mythic() and 480 or 600)
	end
end

function mod:OnBossDisable()
	if self.db.profile.custom_off_barrage_marker then
		for _, player in next, marked do
			SetRaidTarget(player, 0)
		end
		wipe(marked)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Accretion(args)
	if self:MobId(args.sourceGUID) ~= 80557 and UnitGUID("target") == args.sourceGUID and args.amount > 3 then
		local raidIcon = CombatLog_String_GetIcon(args.sourceRaidFlags)
		self:Message(args.spellId, "Attention", nil, raidIcon..CL.count:format(args.spellName, args.amount))
	end
end

do
	local list, scheduled = mod:NewTargetList(), nil
	local function warn(self, spellId)
		self:TargetMessage(spellId, list, "Positive") -- ME_ONLY by default, too spammy
		scheduled = nil
	end
	function mod:CrystallineBarrage(args)
		--self:CDBar(args.spellId, 30.5)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId, 120361) -- 120361 = "Barrage"
			self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
		else
			list[#list+1] = args.destName
			if not scheduled then
				scheduled = self:ScheduleTimer(warn, 0.2, self, args.spellId)
			end
		end
		if self.db.profile.custom_off_barrage_marker then
			for i=1, 5 do
				if not marked[i] then
					SetRaidTarget(args.destName, i)
					marked[i] = args.destName
					break
				end
			end
		end
	end
end

function mod:CrystallineBarrageRemoved(args)
	if self.db.profile.custom_off_barrage_marker then
		SetRaidTarget(args.destName, 0)
		for i=1, 5 do
			if marked[i] == args.destName then
				marked[i] = nil
			end
		end
	end
end

do
	local prev = 0
	function mod:CrystallineBarrageDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1 then
			prev = t
			self:Message(162346, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

do
	local prev = 0
	local names = { [78948] = L.tectus, [80551] = L.shard, [80557] = L.motes }
	function mod:TectonicUpheaval(args)
		local t = GetTime()
		local id = self:MobId(args.sourceGUID)
		if id ~= 80557 or t-prev > 5 then -- not Mote or first Mote cast in 5s
			local raidIcon = CombatLog_String_GetIcon(args.sourceRaidFlags)
			self:Message(args.spellId, "Positive", "Long", CL.other:format(raidIcon .. names[id], args.spellName))
			if id == 80557 then prev = t end
		end
	end
end

function mod:Split(unit, spellName, _, _, spellId)
	if spellId == 140562 then -- Break Player Targetting (cast when Tectus/Shards die)
		if not self:Mythic() then
			self:StopBar(-10061) -- Earthwarper
			self:StopBar(-10062) -- Berserker
			self:UnregisterEvent("CHAT_MSG_MONSTER_YELL")
		end
		--self:CDBar(162346, 8) -- Crystalline Barrage 7-12s, then every ~20s, 2-5s staggered
	end
end

-- XXX for patch 6.1
-- Was probably not even worth adding this but warcraftlogs might be happier about it
--function mod:BossUnitKilled()
--	if not self:Mythic() then
--		self:StopBar(-10061) -- Earthwarper
--		self:StopBar(-10062) -- Berserker
--	end
--end


-- Adds

function mod:NewAdd(event, msg, unit)
	if unit == self:SpellName(-10061) then -- Night-Twisted Earthwarper
		self:Message("adds", "Attention", "Info", -10061, false)
		self:CDBar("adds", 41, -10061, "spell_shadow_raisedead")
		self:CDBar(162894, 10) -- Gift of Earth
		self:CDBar(162968, 15) -- Earthen Flechettes
	elseif unit == self:SpellName(-10062) then -- Night-Twisted Berserker
		self:Message("adds", "Attention", "Info", -10062, false)
		self:CDBar("adds", 41, -10062, "ability_warrior_endlessrage")
		self:CDBar(163312, 13) -- Raving Assault (~10s + 3s cast)
	end
end

-- XXX for patch 6.1
-- The CDs *might* need adapted due to the event being slightly earlier than the yell
--function mod:AddsSpawn(args)
--	if self:MobId(args.sourceGUID) == 80599 then -- Night-Twisted Earthwarper
--		self:Message("adds", "Attention", "Info", -10061, false)
--		self:CDBar("adds", 41, -10061, "spell_shadow_raisedead")
--		self:CDBar(162894, 10) -- Gift of Earth
--		self:CDBar(162968, 15) -- Earthen Flechettes
--	elseif self:MobId(args.sourceGUID) == 80822 then -- Night-Twisted Berserker
--		self:Message("adds", "Attention", "Info", -10062, false)
--		self:CDBar("adds", 41, -10062, "ability_warrior_endlessrage")
--		self:CDBar(163312, 13) -- Raving Assault (~10s + 3s cast)
--	end
--end

function mod:GiftOfEarth(args)
	self:Message(args.spellId, "Urgent", "Alert")
	self:CDBar(args.spellId, 11)
end

function mod:Petrification(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning")
end

function mod:EarthenFlechettes(args)
	self:Message(args.spellId, "Attention", self:Tank() and "Alert")
	self:CDBar(args.spellId, 15)
end

do
	local prev = 0
	function mod:EarthenFlechettesDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and not self:Tank() and t-prev > 1 then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

function mod:RavingAssault(args)
	self:Message(args.spellId, "Urgent")
end

