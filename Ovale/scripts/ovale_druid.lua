local OVALE, Ovale = ...
local OvaleScripts = Ovale.OvaleScripts

do
	local name = "ovale_druid"
	local desc = "[6.0] Ovale: Rotations (Feral, Guardian, Restoration)"
	local code = [[
# Druid rotation functions based on SimulationCraft.

Include(ovale_common)
Include(ovale_druid_spells)

AddCheckBox(opt_interrupt L(interrupt) default)
AddCheckBox(opt_melee_range L(not_in_melee_range))
AddCheckBox(opt_potion_agility ItemName(draenic_agility_potion) default specialization=feral)
AddCheckBox(opt_potion_intellect ItemName(draenic_intellect_potion) default specialization=balance)

AddFunction UsePotionAgility
{
	if CheckBoxOn(opt_potion_agility) and target.Classification(worldboss) Item(draenic_agility_potion usable=1)
}

AddFunction UsePotionIntellect
{
	if CheckBoxOn(opt_potion_intellect) and target.Classification(worldboss) Item(draenic_intellect_potion usable=1)
}

AddFunction UseItemActions
{
	Item(HandSlot usable=1)
	Item(Trinket0Slot usable=1)
	Item(Trinket1Slot usable=1)
}

AddFunction GetInMeleeRange
{
	if CheckBoxOn(opt_melee_range) and Stance(druid_bear_form) and not target.InRange(mangle) or { Stance(druid_cat_form) or Stance(druid_claws_of_shirvallah) } and not target.InRange(shred)
	{
		if target.InRange(wild_charge) Spell(wild_charge)
		Texture(misc_arrowlup help=L(not_in_melee_range))
	}
}

AddFunction InterruptActions
{
	if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.IsInterruptible()
	{
		if target.InRange(skull_bash) Spell(skull_bash)
		if not target.Classification(worldboss)
		{
			if target.InRange(mighty_bash) Spell(mighty_bash)
			Spell(typhoon)
			if target.InRange(maim) Spell(maim)
			Spell(war_stomp)
		}
	}
}

###
### Feral
###
# Based on SimulationCraft profile "Druid_Feral_T17M".
#	class=druid
#	spec=feral
#	talents=3002002
#	glyphs=savage_roar

### actions.default

AddFunction FeralDefaultMainActions
{
	#cat_form
	Spell(cat_form)
	#rake,if=buff.prowl.up|buff.shadowmeld.up
	if BuffPresent(prowl_buff) or BuffPresent(shadowmeld_buff) Spell(rake)
	#ferocious_bite,cycle_targets=1,if=dot.rip.ticking&dot.rip.remains<3&target.health.pct<25
	if target.DebuffPresent(rip_debuff) and target.DebuffRemaining(rip_debuff) < 3 and target.HealthPercent() < 25 Spell(ferocious_bite)
	#healing_touch,if=talent.bloodtalons.enabled&buff.predatory_swiftness.up&(combo_points>=4|buff.predatory_swiftness.remains<1.5)
	if Talent(bloodtalons_talent) and BuffPresent(predatory_swiftness_buff) and { ComboPoints() >= 4 or BuffRemaining(predatory_swiftness_buff) < 1.5 } Spell(healing_touch)
	#savage_roar,if=buff.savage_roar.remains<3
	if BuffRemaining(savage_roar_buff any=1) < 3 Spell(savage_roar)
	#thrash_cat,cycle_targets=1,if=buff.omen_of_clarity.react&remains<4.5&active_enemies>1
	if BuffPresent(omen_of_clarity_melee_buff) and target.DebuffRemaining(thrash_cat_debuff) < 4.5 and Enemies() > 1 Spell(thrash_cat)
	#thrash_cat,cycle_targets=1,if=!talent.bloodtalons.enabled&combo_points=5&remains<4.5&buff.omen_of_clarity.react
	if not Talent(bloodtalons_talent) and ComboPoints() == 5 and target.DebuffRemaining(thrash_cat_debuff) < 4.5 and BuffPresent(omen_of_clarity_melee_buff) Spell(thrash_cat)
	#pool_resource,for_next=1
	#thrash_cat,cycle_targets=1,if=remains<4.5&active_enemies>1
	if target.DebuffRemaining(thrash_cat_debuff) < 4.5 and Enemies() > 1 Spell(thrash_cat)
	unless target.DebuffRemaining(thrash_cat_debuff) < 4.5 and Enemies() > 1 and SpellUsable(thrash_cat) and SpellCooldown(thrash_cat) < TimeToEnergyFor(thrash_cat)
	{
		#call_action_list,name=finisher,if=combo_points=5
		if ComboPoints() == 5 FeralFinisherMainActions()
		#call_action_list,name=maintain
		FeralMaintainMainActions()
		#call_action_list,name=generator,if=combo_points<5
		if ComboPoints() < 5 FeralGeneratorMainActions()
	}
}

AddFunction FeralDefaultShortCdActions
{
	unless Spell(cat_form)
	{
		#wild_charge
		GetInMeleeRange()
		#displacer_beast,if=movement.distance>10
		if 0 > 10 Spell(displacer_beast)
		#dash,if=movement.distance&buff.displacer_beast.down&buff.wild_charge_movement.down
		if 0 and BuffExpires(displacer_beast_buff) and True(wild_charge_movement_down) Spell(dash)

		unless { BuffPresent(prowl_buff) or BuffPresent(shadowmeld_buff) } and Spell(rake)
		{
			#auto_attack
			GetInMeleeRange()
			#force_of_nature,if=charges=3|trinket.proc.all.react|target.time_to_die<20
			if Charges(force_of_nature_melee) == 3 or BuffPresent(trinket_proc_any_buff) or target.TimeToDie() < 20 Spell(force_of_nature_melee)
			#tigers_fury,if=(!buff.omen_of_clarity.react&energy.max-energy>=60)|energy.max-energy>=80
			if not BuffPresent(omen_of_clarity_melee_buff) and MaxEnergy() - Energy() >= 60 or MaxEnergy() - Energy() >= 80 Spell(tigers_fury)
		}
	}
}

AddFunction FeralDefaultCdActions
{
	unless Spell(cat_form) or 0 > 10 and Spell(displacer_beast) or 0 and BuffExpires(displacer_beast_buff) and True(wild_charge_movement_down) and Spell(dash) or { BuffPresent(prowl_buff) or BuffPresent(shadowmeld_buff) } and Spell(rake)
	{
		#skull_bash
		InterruptActions()
		#potion,name=draenic_agility,if=target.time_to_die<=40
		if target.TimeToDie() <= 40 UsePotionAgility()
		#use_item,slot=trinket1,sync=tigers_fury
		if { not BuffPresent(omen_of_clarity_melee_buff) and MaxEnergy() - Energy() >= 60 or MaxEnergy() - Energy() >= 80 } and Spell(tigers_fury) UseItemActions()
		#blood_fury,sync=tigers_fury
		if { not BuffPresent(omen_of_clarity_melee_buff) and MaxEnergy() - Energy() >= 60 or MaxEnergy() - Energy() >= 80 } and Spell(tigers_fury) Spell(blood_fury_apsp)
		#berserking,sync=tigers_fury
		if { not BuffPresent(omen_of_clarity_melee_buff) and MaxEnergy() - Energy() >= 60 or MaxEnergy() - Energy() >= 80 } and Spell(tigers_fury) Spell(berserking)
		#arcane_torrent,sync=tigers_fury
		if { not BuffPresent(omen_of_clarity_melee_buff) and MaxEnergy() - Energy() >= 60 or MaxEnergy() - Energy() >= 80 } and Spell(tigers_fury) Spell(arcane_torrent_energy)
		#incarnation,if=cooldown.berserk.remains<10&energy.time_to_max>1
		if SpellCooldown(berserk_cat) < 10 and TimeToMaxEnergy() > 1 Spell(incarnation_melee)
		#potion,name=draenic_agility,sync=berserk,if=target.health.pct<25
		if target.HealthPercent() < 25 and BuffPresent(tigers_fury_buff) and Spell(berserk_cat) UsePotionAgility()
		#berserk,if=buff.tigers_fury.up
		if BuffPresent(tigers_fury_buff) Spell(berserk_cat)
		#shadowmeld,if=dot.rake.remains<4.5&energy>=35&dot.rake.pmultiplier<2&(buff.bloodtalons.up|!talent.bloodtalons.enabled)&(!talent.incarnation.enabled|cooldown.incarnation.remains>15)&!buff.king_of_the_jungle.up
		if target.DebuffRemaining(rake_debuff) < 4.5 and Energy() >= 35 and target.DebuffPersistentMultiplier(rake_debuff) < 2 and { BuffPresent(bloodtalons_buff) or not Talent(bloodtalons_talent) } and { not Talent(incarnation_talent) or SpellCooldown(incarnation_melee) > 15 } and not BuffPresent(king_of_the_jungle_buff) Spell(shadowmeld)
	}
}

### actions.finisher

AddFunction FeralFinisherMainActions
{
	#ferocious_bite,cycle_targets=1,max_energy=1,if=target.health.pct<25&dot.rip.ticking
	if Energy() >= EnergyCost(ferocious_bite max=1) and target.HealthPercent() < 25 and target.DebuffPresent(rip_debuff) Spell(ferocious_bite)
	#rip,cycle_targets=1,if=remains<3&target.time_to_die-remains>18
	if target.DebuffRemaining(rip_debuff) < 3 and target.TimeToDie() - target.DebuffRemaining(rip_debuff) > 18 Spell(rip)
	#rip,cycle_targets=1,if=remains<7.2&persistent_multiplier>dot.rip.pmultiplier&target.time_to_die-remains>18
	if target.DebuffRemaining(rip_debuff) < 7.2 and PersistentMultiplier(rip_debuff) > target.DebuffPersistentMultiplier(rip_debuff) and target.TimeToDie() - target.DebuffRemaining(rip_debuff) > 18 Spell(rip)
	#savage_roar,if=(energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3)&buff.savage_roar.remains<12.6
	if { TimeToMaxEnergy() <= 1 or BuffPresent(berserk_cat_buff) or SpellCooldown(tigers_fury) < 3 } and BuffRemaining(savage_roar_buff any=1) < 12.6 Spell(savage_roar)
	#ferocious_bite,max_energy=1,if=(energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3)
	if Energy() >= EnergyCost(ferocious_bite max=1) and { TimeToMaxEnergy() <= 1 or BuffPresent(berserk_cat_buff) or SpellCooldown(tigers_fury) < 3 } Spell(ferocious_bite)
}

### actions.generator

AddFunction FeralGeneratorMainActions
{
	#swipe,if=active_enemies>=3
	if Enemies() >= 3 Spell(swipe)
	#shred,if=active_enemies<3
	if Enemies() < 3 Spell(shred)
}

### actions.maintain

AddFunction FeralMaintainMainActions
{
	#rake,cycle_targets=1,if=!talent.bloodtalons.enabled&remains<3&combo_points<5&((target.time_to_die-remains>3&active_enemies<3)|target.time_to_die-remains>6)
	if not Talent(bloodtalons_talent) and target.DebuffRemaining(rake_debuff) < 3 and ComboPoints() < 5 and { target.TimeToDie() - target.DebuffRemaining(rake_debuff) > 3 and Enemies() < 3 or target.TimeToDie() - target.DebuffRemaining(rake_debuff) > 6 } Spell(rake)
	#rake,cycle_targets=1,if=!talent.bloodtalons.enabled&remains<4.5&combo_points<5&persistent_multiplier>dot.rake.pmultiplier&((target.time_to_die-remains>3&active_enemies<3)|target.time_to_die-remains>6)
	if not Talent(bloodtalons_talent) and target.DebuffRemaining(rake_debuff) < 4.5 and ComboPoints() < 5 and PersistentMultiplier(rake_debuff) > target.DebuffPersistentMultiplier(rake_debuff) and { target.TimeToDie() - target.DebuffRemaining(rake_debuff) > 3 and Enemies() < 3 or target.TimeToDie() - target.DebuffRemaining(rake_debuff) > 6 } Spell(rake)
	#rake,cycle_targets=1,if=talent.bloodtalons.enabled&remains<4.5&combo_points<5&(!buff.predatory_swiftness.up|buff.bloodtalons.up|persistent_multiplier>dot.rake.pmultiplier)&((target.time_to_die-remains>3&active_enemies<3)|target.time_to_die-remains>6)
	if Talent(bloodtalons_talent) and target.DebuffRemaining(rake_debuff) < 4.5 and ComboPoints() < 5 and { not BuffPresent(predatory_swiftness_buff) or BuffPresent(bloodtalons_buff) or PersistentMultiplier(rake_debuff) > target.DebuffPersistentMultiplier(rake_debuff) } and { target.TimeToDie() - target.DebuffRemaining(rake_debuff) > 3 and Enemies() < 3 or target.TimeToDie() - target.DebuffRemaining(rake_debuff) > 6 } Spell(rake)
	#thrash_cat,cycle_targets=1,if=talent.bloodtalons.enabled&combo_points=5&remains<4.5&buff.omen_of_clarity.react
	if Talent(bloodtalons_talent) and ComboPoints() == 5 and target.DebuffRemaining(thrash_cat_debuff) < 4.5 and BuffPresent(omen_of_clarity_melee_buff) Spell(thrash_cat)
	#moonfire_cat,cycle_targets=1,if=combo_points<5&remains<4.2&active_enemies<6&target.time_to_die-remains>tick_time*5
	if ComboPoints() < 5 and target.DebuffRemaining(moonfire_cat_debuff) < 4.2 and Enemies() < 6 and target.TimeToDie() - target.DebuffRemaining(moonfire_cat_debuff) > target.TickTime(moonfire_cat_debuff) * 5 Spell(moonfire_cat)
	#rake,cycle_targets=1,if=persistent_multiplier>dot.rake.pmultiplier&combo_points<5&active_enemies=1
	if PersistentMultiplier(rake_debuff) > target.DebuffPersistentMultiplier(rake_debuff) and ComboPoints() < 5 and Enemies() == 1 Spell(rake)
}

### actions.precombat

AddFunction FeralPrecombatMainActions
{
	#flask,type=greater_draenic_agility_flask
	#food,type=blackrock_barbecue
	#mark_of_the_wild,if=!aura.str_agi_int.up
	if not BuffPresent(str_agi_int_buff any=1) Spell(mark_of_the_wild)
	#healing_touch,if=talent.bloodtalons.enabled&buff.bloodtalons.remains<20
	if Talent(bloodtalons_talent) and BuffRemaining(bloodtalons_buff) < 20 Spell(healing_touch)
	#cat_form
	Spell(cat_form)
	#prowl
	if BuffExpires(stealthed_buff any=1) Spell(prowl)
}

AddFunction FeralPrecombatCdActions
{
	unless not BuffPresent(str_agi_int_buff any=1) and Spell(mark_of_the_wild) or Talent(bloodtalons_talent) and BuffRemaining(bloodtalons_buff) < 20 and Spell(healing_touch) or Spell(cat_form) or BuffExpires(stealthed_buff any=1) and Spell(prowl)
	{
		#snapshot_stats
		#potion,name=draenic_agility
		UsePotionAgility()
	}
}

###
### Guardian
###
# Based on SimulationCraft profile "Druid_Guardian_T17M".
#	class=druid
#	spec=guardian
#	talents=0301022

### actions.default

AddFunction GuardianDefaultMainActions
{
	#cenarion_ward
	Spell(cenarion_ward)
	#rejuvenation,if=buff.heart_of_the_wild.up&remains<=3.6
	if BuffPresent(heart_of_the_wild_tank_buff) and BuffRemaining(rejuvenation_buff) <= 3.6 and SpellKnown(enhanced_rejuvenation) Spell(rejuvenation)
	#healing_touch,if=buff.dream_of_cenarius.react&health.pct<30
	if BuffPresent(dream_of_cenarius_tank_buff) and HealthPercent() < 30 Spell(healing_touch)
	#pulverize,if=buff.pulverize.remains<=3.6
	if BuffRemaining(pulverize_buff) <= 3.6 and target.DebuffStacks(lacerate_debuff) >= 3 Spell(pulverize)
	#lacerate,if=talent.pulverize.enabled&buff.pulverize.remains<=(3-dot.lacerate.stack)*gcd&buff.berserk.down
	if Talent(pulverize_talent) and BuffRemaining(pulverize_buff) <= { 3 - target.DebuffStacks(lacerate_debuff) } * GCD() and BuffExpires(berserk_bear_buff) Spell(lacerate)
	#lacerate,if=!ticking
	if not target.DebuffPresent(lacerate_debuff) Spell(lacerate)
	#thrash_bear,if=!ticking
	if not target.DebuffPresent(thrash_bear_debuff) Spell(thrash_bear)
	#mangle
	Spell(mangle)
	#thrash_bear,if=remains<=4.8
	if target.DebuffRemaining(thrash_bear_debuff) <= 4.8 Spell(thrash_bear)
	#lacerate
	Spell(lacerate)
}

AddFunction GuardianDefaultShortCdActions
{
	#auto_attack
	GetInMeleeRange()
	#savage_defense,if=buff.barkskin.down
	if BuffExpires(barkskin_buff) Spell(savage_defense)
	#maul,if=buff.tooth_and_claw.react&incoming_damage_1s
	if BuffPresent(tooth_and_claw_buff) and IncomingDamage(1) > 0 Spell(maul)
	#frenzied_regeneration,if=rage>=80
	if Rage() >= 80 Spell(frenzied_regeneration)
}

AddFunction GuardianDefaultCdActions
{
	#skull_bash
	InterruptActions()
	#blood_fury
	Spell(blood_fury_apsp)
	#berserking
	Spell(berserking)
	#arcane_torrent
	Spell(arcane_torrent_energy)
	#use_item,slot=trinket2
	UseItemActions()
	#barkskin,if=buff.bristling_fur.down
	if BuffExpires(bristling_fur_buff) Spell(barkskin)
	#bristling_fur,if=buff.barkskin.down&buff.savage_defense.down
	if BuffExpires(barkskin_buff) and BuffExpires(savage_defense_buff) Spell(bristling_fur)
	#berserk,if=buff.pulverize.remains>10
	if BuffRemaining(pulverize_buff) > 10 Spell(berserk_bear)

	unless Spell(cenarion_ward)
	{
		#renewal,if=health.pct<30
		if HealthPercent() < 30 Spell(renewal)
		#heart_of_the_wild
		Spell(heart_of_the_wild_tank)

		unless BuffPresent(heart_of_the_wild_tank_buff) and BuffRemaining(rejuvenation_buff) <= 3.6 and SpellKnown(enhanced_rejuvenation) and Spell(rejuvenation)
		{
			#natures_vigil
			Spell(natures_vigil)

			unless BuffPresent(dream_of_cenarius_tank_buff) and HealthPercent() < 30 and Spell(healing_touch) or BuffRemaining(pulverize_buff) <= 3.6 and target.DebuffStacks(lacerate_debuff) >= 3 and Spell(pulverize) or Talent(pulverize_talent) and BuffRemaining(pulverize_buff) <= { 3 - target.DebuffStacks(lacerate_debuff) } * GCD() and BuffExpires(berserk_bear_buff) and Spell(lacerate)
			{
				#incarnation
				Spell(incarnation_tank)
			}
		}
	}
}

### actions.precombat

AddFunction GuardianPrecombatMainActions
{
	#flask,type=greater_draenic_agility_flask
	#food,type=sleeper_surprise
	#mark_of_the_wild,if=!aura.str_agi_int.up
	if not BuffPresent(str_agi_int_buff any=1) Spell(mark_of_the_wild)
	#bear_form
	Spell(bear_form)
	#snapshot_stats
	#cenarion_ward
	Spell(cenarion_ward)
}

###
### Restoration
###

AddFunction RestorationPrecombatActions
{
	# Raid buffs.
	if not BuffPresent(str_agi_int any=1) Spell(mark_of_the_wild)
	# Healing Touch to refresh Harmony buff.
	if BuffRemaining(harmony_buff) < 6 Spell(healing_touch)
}

AddFunction RestorationMainActions
{
	# Cast instant/mana-free Healing Touch or Regrowth.
	if BuffStacks(sage_mender_buff) == 5 Spell(healing_touch)
	if BuffPresent(omen_of_clarity_heal_buff) Spell(regrowth)
	if BuffPresent(natures_swiftness_buff) Spell(healing_touch)

	# Maintain 100% uptime on Harmony mastery buff using Swiftmend.
	# Swiftmend requires either a Rejuvenation or Regrowth HoT to be on the target before
	# it is usable, but we want to show Swiftmend as usable as long as the cooldown is up.
	if BuffRemaining(harmony_buff) < 6 and { BuffCountOnAny(rejuvenation_buff) > 0 or BuffCountOnAny(regrowth_buff) > 0 } and not SpellCooldown(swiftmend) > 0 Texture(inv_relics_idolofrejuvenation help=Swiftmend)

	# Keep one Lifebloom up on the raid.
	if BuffRemainingOnAny(lifebloom_buff) < 4 Spell(lifebloom)

	# Cast Cenarion Ward on cooldown, usually on the tank.
	if Talent(cenarion_ward_talent) Spell(cenarion_ward)
}

AddFunction RestorationAoeActions
{
	if BuffPresent(tree_of_life_buff)
	{
		Spell(wild_growth)
		if BuffPresent(omen_of_clarity_heal_buff) Spell(regrowth)
	}
	unless BuffPresent(tree_of_life_buff)
	{
		Spell(wild_growth)
		if BuffCountOnAny(rejuvenation_buff) > 4 Spell(genesis)
	}
}

AddFunction RestorationShortCdActions
{
	# Maintain Efflorescence.
	if TotemExpires(mushroom) Spell(wild_mushroom_heal)
	# Don't cap out on Force of Nature charges.
	if Talent(force_of_nature_talent) and Charges(force_of_nature_heal count=0) >= 3 Spell(force_of_nature_heal)
}

AddFunction RestorationCdActions
{
	InterruptActions()
	Spell(blood_fury_apsp)
	Spell(berserking)
	if ManaPercent() < 97 Spell(arcane_torrent_energy)
	Spell(incarnation_heal)
	Spell(heart_of_the_wild_heal)
	Spell(natures_vigil)
}
]]
	OvaleScripts:RegisterScript("DRUID", name, desc, code, "include")
end

do
	local name = "Ovale"	-- The default script.
	local desc = "[6.0] Ovale: Feral, Guardian, Restoration"
	local code = [[
# Ovale druid script based on SimulationCraft.

# Druid rotation functions.
Include(ovale_druid)

### Feral icons.
AddCheckBox(opt_druid_feral_aoe L(AOE) specialization=feral default)

AddIcon specialization=feral help=shortcd enemies=1 checkbox=!opt_druid_feral_aoe
{
	FeralDefaultShortCdActions()
}

AddIcon specialization=feral help=shortcd checkbox=opt_druid_feral_aoe
{
	FeralDefaultShortCdActions()
}

AddIcon specialization=feral help=main enemies=1
{
	if not InCombat() FeralPrecombatMainActions()
	FeralDefaultMainActions()
}

AddIcon specialization=feral help=aoe checkbox=opt_druid_feral_aoe
{
	if not InCombat() FeralPrecombatMainActions()
	FeralDefaultMainActions()
}

AddIcon specialization=feral help=cd enemies=1 checkbox=!opt_druid_feral_aoe
{
	if not InCombat() FeralPrecombatCdActions()
	FeralDefaultCdActions()
}

AddIcon specialization=feral help=cd checkbox=opt_druid_feral_aoe
{
	if not InCombat() FeralPrecombatCdActions()
	FeralDefaultCdActions()
}

### Guardian icons.
AddCheckBox(opt_druid_guardian_aoe L(AOE) specialization=guardian default)

AddIcon specialization=guardian help=shortcd enemies=1 checkbox=!opt_druid_guardian_aoe
{
	GuardianDefaultShortCdActions()
}

AddIcon specialization=guardian help=shortcd checkbox=opt_druid_guardian_aoe
{
	GuardianDefaultShortCdActions()
}

AddIcon specialization=guardian help=main enemies=1
{
	if not InCombat() GuardianPrecombatMainActions()
	GuardianDefaultMainActions()
}

AddIcon specialization=guardian help=aoe checkbox=opt_druid_guardian_aoe
{
	if not InCombat() GuardianPrecombatMainActions()
	GuardianDefaultMainActions()
}

AddIcon specialization=guardian help=cd enemies=1 checkbox=!opt_druid_guardian_aoe
{
	GuardianDefaultCdActions()
}

AddIcon specialization=guardian help=cd checkbox=opt_druid_guardian_aoe
{
	GuardianDefaultCdActions()
}

### Restoration icons.
AddCheckBox(opt_druid_restoration_aoe L(AOE) specialization=restoration default)

AddIcon specialization=restoration help=shortcd
{
	RestorationShortCdActions()
}

AddIcon specialization=restoration help=main
{
	if not InCombat() RestorationPrecombatActions()
	RestorationMainActions()
}

AddIcon specialization=restoration help=aoe checkbox=opt_druid_restoration_aoe
{
	RestorationAoeActions()
}

AddIcon specialization=restoration help=cd
{
	RestorationCdActions()
}
]]
	OvaleScripts:RegisterScript("DRUID", name, desc, code, "script")
end
