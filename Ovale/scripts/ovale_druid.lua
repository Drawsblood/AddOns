local OVALE, Ovale = ...
local OvaleScripts = Ovale.OvaleScripts

do
	local name = "nerien_druid_restoration"
	local desc = "[6.0] Nerien: Restoration"
	local code = [[
###
### Nerien's restoration druid script.
###

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_druid_spells)

AddCheckBox(opt_interrupt L(interrupt) default specialization=restoration)

AddFunction RestorationInterruptActions
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

AddFunction RestorationPrecombatActions
{
	# Raid buffs.
	if not BuffPresent(str_agi_int_buff any=1) Spell(mark_of_the_wild)
	# Healing Touch to refresh Harmony buff.
	if BuffRemaining(harmony_buff) < 6 Spell(healing_touch)
}

AddFunction RestorationMainActions
{
	# Cast instant/mana-free Healing Touch or Regrowth.
	if BuffStacks(sage_mender_buff) == 5 Spell(healing_touch)
	if BuffPresent(omen_of_clarity_heal_buff) or BuffPresent(omen_of_clarity_moment_of_clarity_buff) Spell(regrowth)
	if BuffPresent(natures_swiftness_buff) Spell(healing_touch)

	# Maintain 100% uptime on Harmony mastery buff using Swiftmend.
	# Swiftmend requires either a Rejuvenation or Regrowth HoT to be on the target before
	# it is usable, but we want to show Swiftmend as usable as long as the cooldown is up.
	if BuffRemaining(harmony_buff) < 6 and { BuffCountOnAny(regrowth_buff) > 0 or BuffCountOnAny(rejuvenation_buff) > 0 or BuffCountOnAny(rejuvenation_germination_buff) > 0 } and not SpellCooldown(swiftmend) > 0 Texture(inv_relics_idolofrejuvenation help=Swiftmend)

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
		if BuffPresent(omen_of_clarity_heal_buff) or BuffPresent(omen_of_clarity_moment_of_clarity_buff) Spell(regrowth)
	}
	unless BuffPresent(tree_of_life_buff)
	{
		Spell(wild_growth)
		if BuffCountOnAny(rejuvenation_buff) > 4 or BuffCountOnAny(rejuvenation_germination_buff) > 4 Spell(genesis)
	}
}

AddFunction RestorationShortCdActions
{
	# Don't cap out on Force of Nature charges.
	if Talent(force_of_nature_talent) and Charges(force_of_nature_heal count=0) >= 3 Spell(force_of_nature_heal)
	# Maintain Efflorescence.
	if TotemExpires(wild_mushroom_heal) Spell(wild_mushroom_heal)
}

AddFunction RestorationCdActions
{
	RestorationInterruptActions()
	Spell(blood_fury_apsp)
	Spell(berserking)
	if ManaPercent() < 97 Spell(arcane_torrent_mana)
	Spell(incarnation_tree_of_life)
	Spell(heart_of_the_wild_heal)
	Spell(natures_vigil)
}

### Restoration icons.

AddCheckBox(opt_druid_restoration_aoe L(AOE) default specialization=restoration)

AddIcon help=shortcd specialization=restoration
{
	RestorationShortCdActions()
}

AddIcon help=main specialization=restoration
{
	if not InCombat() RestorationPrecombatActions()
	RestorationMainActions()
}

AddIcon checkbox=opt_druid_restoration_aoe help=aoe specialization=restoration
{
	RestorationAoeActions()
}

AddIcon help=cd specialization=restoration
{
	RestorationCdActions()
}
]]
	OvaleScripts:RegisterScript("DRUID", "restoration", name, desc, code, "script")
end

-- THE REST OF THIS FILE IS AUTOMATICALLY GENERATED.
-- ANY CHANGES MADE BELOW THIS POINT WILL BE LOST.

do
	local name = "simulationcraft_druid_balance_t18m"
	local desc = "[6.2] SimulationCraft: Druid_Balance_T18M"
	local code = [[
# Based on SimulationCraft profile "Druid_Balance_T18M".
#	class=druid
#	spec=balance
#	talents=0001001

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_druid_spells)

AddCheckBox(opt_potion_intellect ItemName(draenic_intellect_potion) default specialization=balance)

AddFunction BalanceUsePotionIntellect
{
	if CheckBoxOn(opt_potion_intellect) and target.Classification(worldboss) Item(draenic_intellect_potion usable=1)
}

AddFunction BalanceUseItemActions
{
	Item(HandSlot usable=1)
	Item(Trinket0Slot usable=1)
	Item(Trinket1Slot usable=1)
}

### actions.default

AddFunction BalanceDefaultMainActions
{
	#call_action_list,name=aoe,if=spell_targets.starfall_pulse>1
	if Enemies() > 1 BalanceAoeMainActions()
	#call_action_list,name=single_target
	BalanceSingleTargetMainActions()
}

AddFunction BalanceDefaultShortCdActions
{
	#force_of_nature,if=trinket.stat.intellect.up|charges=3|target.time_to_die<21
	if BuffPresent(trinket_stat_intellect_buff) or Charges(force_of_nature_caster) == 3 or target.TimeToDie() < 21 Spell(force_of_nature_caster)
}

AddFunction BalanceDefaultCdActions
{
	#potion,name=draenic_intellect,if=buff.celestial_alignment.up
	if BuffPresent(celestial_alignment_buff) BalanceUsePotionIntellect()
	#blood_fury,if=buff.celestial_alignment.up
	if BuffPresent(celestial_alignment_buff) Spell(blood_fury_apsp)
	#berserking,if=buff.celestial_alignment.up
	if BuffPresent(celestial_alignment_buff) Spell(berserking)
	#arcane_torrent,if=buff.celestial_alignment.up
	if BuffPresent(celestial_alignment_buff) Spell(arcane_torrent_energy)
	#use_item,slot=finger1
	BalanceUseItemActions()
	#call_action_list,name=aoe,if=spell_targets.starfall_pulse>1
	if Enemies() > 1 BalanceAoeCdActions()

	unless Enemies() > 1 and BalanceAoeCdPostConditions()
	{
		#call_action_list,name=single_target
		BalanceSingleTargetCdActions()
	}
}

### actions.aoe

AddFunction BalanceAoeMainActions
{
	#sunfire,cycle_targets=1,if=remains<8
	if target.DebuffRemaining(sunfire_debuff) < 8 Spell(sunfire)
	#starsurge,if=t18_class_trinket&buff.starfall.remains<3&spell_targets.starfall_pulse>1
	if HasTrinket(t18_class_trinket) and BuffRemaining(starfall_buff) < 3 and Enemies() > 1 Spell(starsurge)
	#starfall,if=!t18_class_trinket&buff.starfall.remains<3&spell_targets.starfall_pulse>2
	if not HasTrinket(t18_class_trinket) and BuffRemaining(starfall_buff) < 3 and Enemies() > 2 Spell(starfall)
	#starsurge,if=(charges=2&recharge_time<6)|charges=3
	if Charges(starsurge) == 2 and SpellChargeCooldown(starsurge) < 6 or Charges(starsurge) == 3 Spell(starsurge)
	#moonfire,cycle_targets=1,if=remains<12
	if target.DebuffRemaining(moonfire_debuff) < 12 Spell(moonfire)
	#stellar_flare,cycle_targets=1,if=remains<7
	if target.DebuffRemaining(stellar_flare_debuff) < 7 Spell(stellar_flare)
	#starsurge,if=buff.lunar_empowerment.down&eclipse_energy>20&spell_targets.starfall_pulse=2
	if BuffExpires(lunar_empowerment_buff) and EclipseEnergy() > 20 and Enemies() == 2 Spell(starsurge)
	#starsurge,if=buff.solar_empowerment.down&eclipse_energy<-40&spell_targets.starfall_pulse=2
	if BuffExpires(solar_empowerment_buff) and EclipseEnergy() < -40 and Enemies() == 2 Spell(starsurge)
	#wrath,if=(eclipse_energy<=0&eclipse_change>cast_time)|(eclipse_energy>0&cast_time>eclipse_change)
	if EclipseEnergy() <= 0 and TimeToEclipse() > CastTime(wrath) or EclipseEnergy() > 0 and CastTime(wrath) > TimeToEclipse() Spell(wrath)
	#starfire
	Spell(starfire)
}

AddFunction BalanceAoeCdActions
{
	#celestial_alignment,if=lunar_max<8|target.time_to_die<20
	if TimeToEclipse(lunar) < 8 or target.TimeToDie() < 20 Spell(celestial_alignment)
	#incarnation,if=buff.celestial_alignment.up
	if BuffPresent(celestial_alignment_buff) Spell(incarnation_chosen_of_elune)
}

AddFunction BalanceAoeCdPostConditions
{
	target.DebuffRemaining(sunfire_debuff) < 8 and Spell(sunfire) or HasTrinket(t18_class_trinket) and BuffRemaining(starfall_buff) < 3 and Enemies() > 1 and Spell(starsurge) or not HasTrinket(t18_class_trinket) and BuffRemaining(starfall_buff) < 3 and Enemies() > 2 and Spell(starfall) or { Charges(starsurge) == 2 and SpellChargeCooldown(starsurge) < 6 or Charges(starsurge) == 3 } and Spell(starsurge) or target.DebuffRemaining(moonfire_debuff) < 12 and Spell(moonfire) or target.DebuffRemaining(stellar_flare_debuff) < 7 and Spell(stellar_flare) or BuffExpires(lunar_empowerment_buff) and EclipseEnergy() > 20 and Enemies() == 2 and Spell(starsurge) or BuffExpires(solar_empowerment_buff) and EclipseEnergy() < -40 and Enemies() == 2 and Spell(starsurge) or { EclipseEnergy() <= 0 and TimeToEclipse() > CastTime(wrath) or EclipseEnergy() > 0 and CastTime(wrath) > TimeToEclipse() } and Spell(wrath) or Spell(starfire)
}

### actions.precombat

AddFunction BalancePrecombatMainActions
{
	#flask,type=greater_draenic_intellect_flask
	#food,type=sleeper_sushi
	#mark_of_the_wild,if=!aura.str_agi_int.up
	if not BuffPresent(str_agi_int_buff any=1) Spell(mark_of_the_wild)
	#moonkin_form
	Spell(moonkin_form)
	#starfire
	Spell(starfire)
}

AddFunction BalancePrecombatShortCdPostConditions
{
	not BuffPresent(str_agi_int_buff any=1) and Spell(mark_of_the_wild) or Spell(moonkin_form) or Spell(starfire)
}

AddFunction BalancePrecombatCdActions
{
	unless not BuffPresent(str_agi_int_buff any=1) and Spell(mark_of_the_wild) or Spell(moonkin_form)
	{
		#snapshot_stats
		#potion,name=draenic_intellect
		BalanceUsePotionIntellect()
		#incarnation
		Spell(incarnation_chosen_of_elune)
	}
}

AddFunction BalancePrecombatCdPostConditions
{
	not BuffPresent(str_agi_int_buff any=1) and Spell(mark_of_the_wild) or Spell(moonkin_form) or Spell(starfire)
}

### actions.single_target

AddFunction BalanceSingleTargetMainActions
{
	#starsurge,if=buff.lunar_empowerment.down&(eclipse_energy>20|buff.celestial_alignment.up)
	if BuffExpires(lunar_empowerment_buff) and { EclipseEnergy() > 20 or BuffPresent(celestial_alignment_buff) } Spell(starsurge)
	#starsurge,if=buff.solar_empowerment.down&eclipse_energy<-40
	if BuffExpires(solar_empowerment_buff) and EclipseEnergy() < -40 Spell(starsurge)
	#starsurge,if=(charges=2&recharge_time<6)|charges=3
	if Charges(starsurge) == 2 and SpellChargeCooldown(starsurge) < 6 or Charges(starsurge) == 3 Spell(starsurge)
	#sunfire,if=remains<7|(buff.solar_peak.up&buff.solar_peak.remains<action.wrath.cast_time&!talent.balance_of_power.enabled)
	if target.DebuffRemaining(sunfire_debuff) < 7 or BuffPresent(solar_peak_buff) and BuffRemaining(solar_peak_buff) < CastTime(wrath) and not Talent(balance_of_power_talent) Spell(sunfire)
	#stellar_flare,if=remains<7
	if target.DebuffRemaining(stellar_flare_debuff) < 7 Spell(stellar_flare)
	#moonfire,if=!talent.balance_of_power.enabled&(buff.lunar_peak.up&buff.lunar_peak.remains<action.starfire.cast_time&remains<eclipse_change+20|remains<4|(buff.celestial_alignment.up&buff.celestial_alignment.remains<=2&remains<eclipse_change+20))
	if not Talent(balance_of_power_talent) and { BuffPresent(lunar_peak_buff) and BuffRemaining(lunar_peak_buff) < CastTime(starfire) and target.DebuffRemaining(moonfire_debuff) < TimeToEclipse() + 20 or target.DebuffRemaining(moonfire_debuff) < 4 or BuffPresent(celestial_alignment_buff) and BuffRemaining(celestial_alignment_buff) <= 2 and target.DebuffRemaining(moonfire_debuff) < TimeToEclipse() + 20 } Spell(moonfire)
	#moonfire,if=talent.balance_of_power.enabled&(remains<4|(buff.celestial_alignment.up&buff.celestial_alignment.remains<=2&remains<eclipse_change+20))
	if Talent(balance_of_power_talent) and { target.DebuffRemaining(moonfire_debuff) < 4 or BuffPresent(celestial_alignment_buff) and BuffRemaining(celestial_alignment_buff) <= 2 and target.DebuffRemaining(moonfire_debuff) < TimeToEclipse() + 20 } Spell(moonfire)
	#wrath,if=(eclipse_energy<=0&eclipse_change>cast_time)|(eclipse_energy>0&cast_time>eclipse_change)
	if EclipseEnergy() <= 0 and TimeToEclipse() > CastTime(wrath) or EclipseEnergy() > 0 and CastTime(wrath) > TimeToEclipse() Spell(wrath)
	#starfire
	Spell(starfire)
}

AddFunction BalanceSingleTargetCdActions
{
	unless BuffExpires(lunar_empowerment_buff) and { EclipseEnergy() > 20 or BuffPresent(celestial_alignment_buff) } and Spell(starsurge) or BuffExpires(solar_empowerment_buff) and EclipseEnergy() < -40 and Spell(starsurge) or { Charges(starsurge) == 2 and SpellChargeCooldown(starsurge) < 6 or Charges(starsurge) == 3 } and Spell(starsurge)
	{
		#celestial_alignment,if=eclipse_energy>0
		if EclipseEnergy() > 0 Spell(celestial_alignment)
		#incarnation,if=eclipse_energy>0
		if EclipseEnergy() > 0 Spell(incarnation_chosen_of_elune)
	}
}

### Balance icons.

AddCheckBox(opt_druid_balance_aoe L(AOE) default specialization=balance)

AddIcon checkbox=!opt_druid_balance_aoe enemies=1 help=shortcd specialization=balance
{
	unless not InCombat() and BalancePrecombatShortCdPostConditions()
	{
		BalanceDefaultShortCdActions()
	}
}

AddIcon checkbox=opt_druid_balance_aoe help=shortcd specialization=balance
{
	unless not InCombat() and BalancePrecombatShortCdPostConditions()
	{
		BalanceDefaultShortCdActions()
	}
}

AddIcon enemies=1 help=main specialization=balance
{
	if not InCombat() BalancePrecombatMainActions()
	BalanceDefaultMainActions()
}

AddIcon checkbox=opt_druid_balance_aoe help=aoe specialization=balance
{
	if not InCombat() BalancePrecombatMainActions()
	BalanceDefaultMainActions()
}

AddIcon checkbox=!opt_druid_balance_aoe enemies=1 help=cd specialization=balance
{
	if not InCombat() BalancePrecombatCdActions()
	unless not InCombat() and BalancePrecombatCdPostConditions()
	{
		BalanceDefaultCdActions()
	}
}

AddIcon checkbox=opt_druid_balance_aoe help=cd specialization=balance
{
	if not InCombat() BalancePrecombatCdActions()
	unless not InCombat() and BalancePrecombatCdPostConditions()
	{
		BalanceDefaultCdActions()
	}
}

### Required symbols
# arcane_torrent_energy
# balance_of_power_talent
# berserking
# blood_fury_apsp
# celestial_alignment
# celestial_alignment_buff
# draenic_intellect_potion
# force_of_nature_caster
# incarnation_chosen_of_elune
# lunar_empowerment_buff
# lunar_peak_buff
# mark_of_the_wild
# moonfire
# moonfire_debuff
# moonkin_form
# solar_empowerment_buff
# solar_peak_buff
# starfall
# starfall_buff
# starfire
# starsurge
# stellar_flare
# stellar_flare_debuff
# sunfire
# sunfire_debuff
# t18_class_trinket
# wrath
]]
	OvaleScripts:RegisterScript("DRUID", "balance", name, desc, code, "script")
end

do
	local name = "simulationcraft_druid_feral_t18m"
	local desc = "[6.2] SimulationCraft: Druid_Feral_T18M"
	local code = [[
# Based on SimulationCraft profile "Druid_Feral_T18M".
#	class=druid
#	spec=feral
#	talents=3002002
#	glyphs=savage_roar

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_druid_spells)

AddCheckBox(opt_interrupt L(interrupt) default specialization=feral)
AddCheckBox(opt_melee_range L(not_in_melee_range) specialization=feral)
AddCheckBox(opt_potion_agility ItemName(draenic_agility_potion) default specialization=feral)

AddFunction FeralUsePotionAgility
{
	if CheckBoxOn(opt_potion_agility) and target.Classification(worldboss) Item(draenic_agility_potion usable=1)
}

AddFunction FeralUseItemActions
{
	Item(HandSlot usable=1)
	Item(Trinket0Slot usable=1)
	Item(Trinket1Slot usable=1)
}

AddFunction FeralGetInMeleeRange
{
	if CheckBoxOn(opt_melee_range) and Stance(druid_bear_form) and not target.InRange(mangle) or { Stance(druid_cat_form) or Stance(druid_claws_of_shirvallah) } and not target.InRange(shred)
	{
		if target.InRange(wild_charge) Spell(wild_charge)
		Texture(misc_arrowlup help=L(not_in_melee_range))
	}
}

AddFunction FeralInterruptActions
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

### actions.default

AddFunction FeralDefaultMainActions
{
	#cat_form
	Spell(cat_form)
	#rake,if=buff.prowl.up|buff.shadowmeld.up
	if BuffPresent(prowl_buff) or BuffPresent(shadowmeld_buff) Spell(rake)
	#ferocious_bite,cycle_targets=1,if=dot.rip.ticking&dot.rip.remains<3&target.health.pct<25
	if target.DebuffPresent(rip_debuff) and target.DebuffRemaining(rip_debuff) < 3 and target.HealthPercent() < 25 Spell(ferocious_bite)
	#healing_touch,if=talent.bloodtalons.enabled&buff.predatory_swiftness.up&((combo_points>=4&!set_bonus.tier18_4pc)|combo_points=5|buff.predatory_swiftness.remains<1.5)
	if Talent(bloodtalons_talent) and BuffPresent(predatory_swiftness_buff) and { ComboPoints() >= 4 and not ArmorSetBonus(T18 4) or ComboPoints() == 5 or BuffRemaining(predatory_swiftness_buff) < 1.5 } Spell(healing_touch)
	#savage_roar,if=buff.savage_roar.down
	if BuffExpires(savage_roar_buff) Spell(savage_roar)
	#thrash_cat,if=set_bonus.tier18_4pc&buff.omen_of_clarity.react&remains<4.5&combo_points+buff.bloodtalons.stack!=6
	if ArmorSetBonus(T18 4) and BuffPresent(omen_of_clarity_melee_buff) and target.DebuffRemaining(thrash_cat_debuff) < 4.5 and ComboPoints() + BuffStacks(bloodtalons_buff) != 6 Spell(thrash_cat)
	#pool_resource,for_next=1
	#thrash_cat,cycle_targets=1,if=remains<4.5&(spell_targets.thrash_cat>=2&set_bonus.tier17_2pc|spell_targets.thrash_cat>=4)
	if target.DebuffRemaining(thrash_cat_debuff) < 4.5 and { Enemies() >= 2 and ArmorSetBonus(T17 2) or Enemies() >= 4 } Spell(thrash_cat)
	unless target.DebuffRemaining(thrash_cat_debuff) < 4.5 and { Enemies() >= 2 and ArmorSetBonus(T17 2) or Enemies() >= 4 } and SpellUsable(thrash_cat) and SpellCooldown(thrash_cat) < TimeToEnergyFor(thrash_cat)
	{
		#call_action_list,name=finisher,if=combo_points=5
		if ComboPoints() == 5 FeralFinisherMainActions()
		#savage_roar,if=buff.savage_roar.remains<gcd
		if BuffRemaining(savage_roar_buff) < GCD() Spell(savage_roar)
		#call_action_list,name=maintain,if=combo_points<5
		if ComboPoints() < 5 FeralMaintainMainActions()
		#pool_resource,for_next=1
		#thrash_cat,cycle_targets=1,if=remains<4.5&spell_targets.thrash_cat>=2
		if target.DebuffRemaining(thrash_cat_debuff) < 4.5 and Enemies() >= 2 Spell(thrash_cat)
		unless target.DebuffRemaining(thrash_cat_debuff) < 4.5 and Enemies() >= 2 and SpellUsable(thrash_cat) and SpellCooldown(thrash_cat) < TimeToEnergyFor(thrash_cat)
		{
			#call_action_list,name=generator,if=combo_points<5
			if ComboPoints() < 5 FeralGeneratorMainActions()
		}
	}
}

AddFunction FeralDefaultShortCdActions
{
	unless Spell(cat_form)
	{
		#wild_charge
		FeralGetInMeleeRange()
		#displacer_beast,if=movement.distance>10
		if 0 > 10 Spell(displacer_beast)
		#dash,if=movement.distance&buff.displacer_beast.down&buff.wild_charge_movement.down
		if 0 and BuffExpires(displacer_beast_buff) and True(wild_charge_movement_down) Spell(dash)

		unless { BuffPresent(prowl_buff) or BuffPresent(shadowmeld_buff) } and Spell(rake)
		{
			#auto_attack
			FeralGetInMeleeRange()
			#force_of_nature,if=charges=3|trinket.proc.all.react|target.time_to_die<20
			if Charges(force_of_nature_melee) == 3 or BuffPresent(trinket_proc_any_buff) or target.TimeToDie() < 20 Spell(force_of_nature_melee)
			#tigers_fury,if=(!buff.omen_of_clarity.react&energy.deficit>=60)|energy.deficit>=80|(t18_class_trinket&buff.berserk.up&buff.tigers_fury.down)
			if not BuffPresent(omen_of_clarity_melee_buff) and EnergyDeficit() >= 60 or EnergyDeficit() >= 80 or HasTrinket(t18_class_trinket) and BuffPresent(berserk_cat_buff) and BuffExpires(tigers_fury_buff) Spell(tigers_fury)
		}
	}
}

AddFunction FeralDefaultCdActions
{
	unless Spell(cat_form) or 0 > 10 and Spell(displacer_beast) or 0 and BuffExpires(displacer_beast_buff) and True(wild_charge_movement_down) and Spell(dash) or { BuffPresent(prowl_buff) or BuffPresent(shadowmeld_buff) } and Spell(rake)
	{
		#skull_bash
		FeralInterruptActions()
		#berserk,if=buff.tigers_fury.up&(buff.incarnation.up|!talent.incarnation_king_of_the_jungle.enabled)
		if BuffPresent(tigers_fury_buff) and { BuffPresent(incarnation_king_of_the_jungle_buff) or not Talent(incarnation_king_of_the_jungle_talent) } Spell(berserk_cat)
		#use_item,slot=finger1
		FeralUseItemActions()
		#potion,name=draenic_agility,if=(buff.berserk.remains>10&(target.time_to_die<180|(trinket.proc.all.react&target.health.pct<25)))|target.time_to_die<=40
		if BuffRemaining(berserk_cat_buff) > 10 and { target.TimeToDie() < 180 or BuffPresent(trinket_proc_any_buff) and target.HealthPercent() < 25 } or target.TimeToDie() <= 40 FeralUsePotionAgility()
		#blood_fury,sync=tigers_fury
		if { not BuffPresent(omen_of_clarity_melee_buff) and EnergyDeficit() >= 60 or EnergyDeficit() >= 80 or HasTrinket(t18_class_trinket) and BuffPresent(berserk_cat_buff) and BuffExpires(tigers_fury_buff) } and Spell(tigers_fury) Spell(blood_fury_apsp)
		#berserking,sync=tigers_fury
		if { not BuffPresent(omen_of_clarity_melee_buff) and EnergyDeficit() >= 60 or EnergyDeficit() >= 80 or HasTrinket(t18_class_trinket) and BuffPresent(berserk_cat_buff) and BuffExpires(tigers_fury_buff) } and Spell(tigers_fury) Spell(berserking)
		#arcane_torrent,sync=tigers_fury
		if { not BuffPresent(omen_of_clarity_melee_buff) and EnergyDeficit() >= 60 or EnergyDeficit() >= 80 or HasTrinket(t18_class_trinket) and BuffPresent(berserk_cat_buff) and BuffExpires(tigers_fury_buff) } and Spell(tigers_fury) Spell(arcane_torrent_energy)
		#incarnation,if=cooldown.berserk.remains<10&energy.time_to_max>1
		if SpellCooldown(berserk_cat) < 10 and TimeToMaxEnergy() > 1 Spell(incarnation_king_of_the_jungle)
		#shadowmeld,if=dot.rake.remains<4.5&energy>=35&dot.rake.pmultiplier<2&(buff.bloodtalons.up|!talent.bloodtalons.enabled)&(!talent.incarnation.enabled|cooldown.incarnation.remains>15)&!buff.incarnation.up
		if target.DebuffRemaining(rake_debuff) < 4.5 and Energy() >= 35 and target.DebuffPersistentMultiplier(rake_debuff) < 2 and { BuffPresent(bloodtalons_buff) or not Talent(bloodtalons_talent) } and { not Talent(incarnation_talent) or SpellCooldown(incarnation_king_of_the_jungle) > 15 } and not BuffPresent(incarnation_king_of_the_jungle_buff) Spell(shadowmeld)
	}
}

### actions.finisher

AddFunction FeralFinisherMainActions
{
	#rip,cycle_targets=1,if=remains<2&target.time_to_die-remains>18&(target.health.pct>25|!dot.rip.ticking)
	if target.DebuffRemaining(rip_debuff) < 2 and target.TimeToDie() - target.DebuffRemaining(rip_debuff) > 18 and { target.HealthPercent() > 25 or not target.DebuffPresent(rip_debuff) } Spell(rip)
	#ferocious_bite,cycle_targets=1,max_energy=1,if=target.health.pct<25&dot.rip.ticking
	if Energy() >= EnergyCost(ferocious_bite max=1) and target.HealthPercent() < 25 and target.DebuffPresent(rip_debuff) Spell(ferocious_bite)
	#rip,cycle_targets=1,if=remains<7.2&persistent_multiplier>dot.rip.pmultiplier&target.time_to_die-remains>18
	if target.DebuffRemaining(rip_debuff) < 7.2 and PersistentMultiplier(rip_debuff) > target.DebuffPersistentMultiplier(rip_debuff) and target.TimeToDie() - target.DebuffRemaining(rip_debuff) > 18 Spell(rip)
	#rip,cycle_targets=1,if=remains<7.2&persistent_multiplier=dot.rip.pmultiplier&(energy.time_to_max<=1|(set_bonus.tier18_4pc&energy>50)|(set_bonus.tier18_2pc&buff.omen_of_clarity.react)|!talent.bloodtalons.enabled)&target.time_to_die-remains>18
	if target.DebuffRemaining(rip_debuff) < 7.2 and PersistentMultiplier(rip_debuff) == target.DebuffPersistentMultiplier(rip_debuff) and { TimeToMaxEnergy() <= 1 or ArmorSetBonus(T18 4) and Energy() > 50 or ArmorSetBonus(T18 2) and BuffPresent(omen_of_clarity_melee_buff) or not Talent(bloodtalons_talent) } and target.TimeToDie() - target.DebuffRemaining(rip_debuff) > 18 Spell(rip)
	#savage_roar,if=((set_bonus.tier18_4pc&energy>50)|(set_bonus.tier18_2pc&buff.omen_of_clarity.react)|energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3)&buff.savage_roar.remains<12.6
	if { ArmorSetBonus(T18 4) and Energy() > 50 or ArmorSetBonus(T18 2) and BuffPresent(omen_of_clarity_melee_buff) or TimeToMaxEnergy() <= 1 or BuffPresent(berserk_cat_buff) or SpellCooldown(tigers_fury) < 3 } and BuffRemaining(savage_roar_buff) < 12.6 Spell(savage_roar)
	#ferocious_bite,max_energy=1,if=(set_bonus.tier18_4pc&energy>50)|(set_bonus.tier18_2pc&buff.omen_of_clarity.react)|energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3
	if Energy() >= EnergyCost(ferocious_bite max=1) and { ArmorSetBonus(T18 4) and Energy() > 50 or ArmorSetBonus(T18 2) and BuffPresent(omen_of_clarity_melee_buff) or TimeToMaxEnergy() <= 1 or BuffPresent(berserk_cat_buff) or SpellCooldown(tigers_fury) < 3 } Spell(ferocious_bite)
}

### actions.generator

AddFunction FeralGeneratorMainActions
{
	#swipe,if=spell_targets.swipe>=4|(spell_targets.swipe>=3&buff.incarnation.down)
	if Enemies() >= 4 or Enemies() >= 3 and BuffExpires(incarnation_king_of_the_jungle_buff) Spell(swipe)
	#shred,if=spell_targets.swipe<3|(spell_targets.swipe=3&buff.incarnation.up)
	if Enemies() < 3 or Enemies() == 3 and BuffPresent(incarnation_king_of_the_jungle_buff) Spell(shred)
}

### actions.maintain

AddFunction FeralMaintainMainActions
{
	#rake,cycle_targets=1,if=remains<3&((target.time_to_die-remains>3&spell_targets.swipe<3)|target.time_to_die-remains>6)
	if target.DebuffRemaining(rake_debuff) < 3 and { target.TimeToDie() - target.DebuffRemaining(rake_debuff) > 3 and Enemies() < 3 or target.TimeToDie() - target.DebuffRemaining(rake_debuff) > 6 } Spell(rake)
	#rake,cycle_targets=1,if=remains<4.5&(persistent_multiplier>=dot.rake.pmultiplier|(talent.bloodtalons.enabled&(buff.bloodtalons.up|!buff.predatory_swiftness.up)))&((target.time_to_die-remains>3&spell_targets.swipe<3)|target.time_to_die-remains>6)
	if target.DebuffRemaining(rake_debuff) < 4.5 and { PersistentMultiplier(rake_debuff) >= target.DebuffPersistentMultiplier(rake_debuff) or Talent(bloodtalons_talent) and { BuffPresent(bloodtalons_buff) or not BuffPresent(predatory_swiftness_buff) } } and { target.TimeToDie() - target.DebuffRemaining(rake_debuff) > 3 and Enemies() < 3 or target.TimeToDie() - target.DebuffRemaining(rake_debuff) > 6 } Spell(rake)
	#moonfire_cat,cycle_targets=1,if=remains<4.2&spell_targets.swipe<=5&target.time_to_die-remains>tick_time*5
	if target.DebuffRemaining(moonfire_cat_debuff) < 4.2 and Enemies() <= 5 and target.TimeToDie() - target.DebuffRemaining(moonfire_cat_debuff) > target.TickTime(moonfire_cat_debuff) * 5 Spell(moonfire_cat)
	#rake,cycle_targets=1,if=persistent_multiplier>dot.rake.pmultiplier&spell_targets.swipe=1&((target.time_to_die-remains>3&spell_targets.swipe<3)|target.time_to_die-remains>6)
	if PersistentMultiplier(rake_debuff) > target.DebuffPersistentMultiplier(rake_debuff) and Enemies() == 1 and { target.TimeToDie() - target.DebuffRemaining(rake_debuff) > 3 and Enemies() < 3 or target.TimeToDie() - target.DebuffRemaining(rake_debuff) > 6 } Spell(rake)
}

### actions.precombat

AddFunction FeralPrecombatMainActions
{
	#flask,type=greater_draenic_agility_flask
	#food,type=pickled_eel
	#mark_of_the_wild,if=!aura.str_agi_int.up
	if not BuffPresent(str_agi_int_buff any=1) Spell(mark_of_the_wild)
	#healing_touch,if=talent.bloodtalons.enabled&buff.bloodtalons.remains<20
	if Talent(bloodtalons_talent) and BuffRemaining(bloodtalons_buff) < 20 Spell(healing_touch)
	#cat_form
	Spell(cat_form)
	#prowl
	Spell(prowl)
}

AddFunction FeralPrecombatShortCdPostConditions
{
	not BuffPresent(str_agi_int_buff any=1) and Spell(mark_of_the_wild) or Talent(bloodtalons_talent) and BuffRemaining(bloodtalons_buff) < 20 and Spell(healing_touch) or Spell(cat_form) or Spell(prowl)
}

AddFunction FeralPrecombatCdActions
{
	unless not BuffPresent(str_agi_int_buff any=1) and Spell(mark_of_the_wild) or Talent(bloodtalons_talent) and BuffRemaining(bloodtalons_buff) < 20 and Spell(healing_touch) or Spell(cat_form) or Spell(prowl)
	{
		#snapshot_stats
		#potion,name=draenic_agility
		FeralUsePotionAgility()
		#incarnation
		Spell(incarnation_king_of_the_jungle)
	}
}

AddFunction FeralPrecombatCdPostConditions
{
	not BuffPresent(str_agi_int_buff any=1) and Spell(mark_of_the_wild) or Talent(bloodtalons_talent) and BuffRemaining(bloodtalons_buff) < 20 and Spell(healing_touch) or Spell(cat_form) or Spell(prowl)
}

### Feral icons.

AddCheckBox(opt_druid_feral_aoe L(AOE) default specialization=feral)

AddIcon checkbox=!opt_druid_feral_aoe enemies=1 help=shortcd specialization=feral
{
	unless not InCombat() and FeralPrecombatShortCdPostConditions()
	{
		FeralDefaultShortCdActions()
	}
}

AddIcon checkbox=opt_druid_feral_aoe help=shortcd specialization=feral
{
	unless not InCombat() and FeralPrecombatShortCdPostConditions()
	{
		FeralDefaultShortCdActions()
	}
}

AddIcon enemies=1 help=main specialization=feral
{
	if not InCombat() FeralPrecombatMainActions()
	FeralDefaultMainActions()
}

AddIcon checkbox=opt_druid_feral_aoe help=aoe specialization=feral
{
	if not InCombat() FeralPrecombatMainActions()
	FeralDefaultMainActions()
}

AddIcon checkbox=!opt_druid_feral_aoe enemies=1 help=cd specialization=feral
{
	if not InCombat() FeralPrecombatCdActions()
	unless not InCombat() and FeralPrecombatCdPostConditions()
	{
		FeralDefaultCdActions()
	}
}

AddIcon checkbox=opt_druid_feral_aoe help=cd specialization=feral
{
	if not InCombat() FeralPrecombatCdActions()
	unless not InCombat() and FeralPrecombatCdPostConditions()
	{
		FeralDefaultCdActions()
	}
}

### Required symbols
# arcane_torrent_energy
# berserk_cat
# berserk_cat_buff
# berserking
# blood_fury_apsp
# bloodtalons_buff
# bloodtalons_talent
# cat_form
# dash
# displacer_beast
# displacer_beast_buff
# draenic_agility_potion
# ferocious_bite
# force_of_nature_melee
# healing_touch
# incarnation_king_of_the_jungle
# incarnation_king_of_the_jungle_buff
# incarnation_king_of_the_jungle_talent
# incarnation_talent
# maim
# mangle
# mark_of_the_wild
# mighty_bash
# moonfire_cat
# moonfire_cat_debuff
# omen_of_clarity_melee_buff
# predatory_swiftness_buff
# prowl
# prowl_buff
# rake
# rake_debuff
# rip
# rip_debuff
# savage_roar
# savage_roar_buff
# shadowmeld
# shadowmeld_buff
# shred
# skull_bash
# swipe
# t18_class_trinket
# thrash_cat
# thrash_cat_debuff
# tigers_fury
# tigers_fury_buff
# typhoon
# war_stomp
# wild_charge
# wild_charge_bear
# wild_charge_cat
]]
	OvaleScripts:RegisterScript("DRUID", "feral", name, desc, code, "script")
end

do
	local name = "simulationcraft_druid_guardian_t18m"
	local desc = "[6.2] SimulationCraft: Druid_Guardian_T18M"
	local code = [[
# Based on SimulationCraft profile "Druid_Guardian_T18M".
#	class=druid
#	spec=guardian
#	talents=0301022

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_druid_spells)

AddCheckBox(opt_interrupt L(interrupt) default specialization=guardian)
AddCheckBox(opt_melee_range L(not_in_melee_range) specialization=guardian)

AddFunction GuardianUseItemActions
{
	Item(HandSlot usable=1)
	Item(Trinket0Slot usable=1)
	Item(Trinket1Slot usable=1)
}

AddFunction GuardianGetInMeleeRange
{
	if CheckBoxOn(opt_melee_range) and Stance(druid_bear_form) and not target.InRange(mangle) or { Stance(druid_cat_form) or Stance(druid_claws_of_shirvallah) } and not target.InRange(shred)
	{
		if target.InRange(wild_charge) Spell(wild_charge)
		Texture(misc_arrowlup help=L(not_in_melee_range))
	}
}

AddFunction GuardianInterruptActions
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
	if BuffRemaining(pulverize_buff) <= 3.6 and target.DebuffGain(lacerate_debuff) <= BaseDuration(lacerate_debuff) Spell(pulverize)
	#mangle
	Spell(mangle)
	#lacerate,if=talent.pulverize.enabled&buff.pulverize.remains<=(3-dot.lacerate.stack)*gcd&buff.berserk.down
	if Talent(pulverize_talent) and BuffRemaining(pulverize_buff) <= { 3 - target.DebuffStacks(lacerate_debuff) } * GCD() and BuffExpires(berserk_bear_buff) Spell(lacerate)
	#lacerate,if=!ticking
	if not target.DebuffPresent(lacerate_debuff) Spell(lacerate)
	#thrash_bear,if=!ticking
	if not target.DebuffPresent(thrash_bear_debuff) Spell(thrash_bear)
	#thrash_bear,if=remains<=4.8
	if target.DebuffRemaining(thrash_bear_debuff) <= 4.8 Spell(thrash_bear)
	#lacerate
	Spell(lacerate)
}

AddFunction GuardianDefaultShortCdActions
{
	#auto_attack
	GuardianGetInMeleeRange()
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
	GuardianInterruptActions()
	#blood_fury
	Spell(blood_fury_apsp)
	#berserking
	Spell(berserking)
	#arcane_torrent
	Spell(arcane_torrent_energy)
	#use_item,slot=finger1
	GuardianUseItemActions()
	#barkskin,if=buff.bristling_fur.down
	if BuffExpires(bristling_fur_buff) Spell(barkskin)
	#bristling_fur,if=buff.barkskin.down&buff.savage_defense.down
	if BuffExpires(barkskin_buff) and BuffExpires(savage_defense_buff) Spell(bristling_fur)
	#berserk,if=(buff.pulverize.remains>10|!talent.pulverize.enabled)&buff.incarnation.down
	if { BuffRemaining(pulverize_buff) > 10 or not Talent(pulverize_talent) } and BuffExpires(incarnation_son_of_ursoc_buff) Spell(berserk_bear)

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

			unless BuffPresent(dream_of_cenarius_tank_buff) and HealthPercent() < 30 and Spell(healing_touch) or BuffRemaining(pulverize_buff) <= 3.6 and target.DebuffGain(lacerate_debuff) <= BaseDuration(lacerate_debuff) and Spell(pulverize) or Spell(mangle) or Talent(pulverize_talent) and BuffRemaining(pulverize_buff) <= { 3 - target.DebuffStacks(lacerate_debuff) } * GCD() and BuffExpires(berserk_bear_buff) and Spell(lacerate)
			{
				#incarnation,if=buff.berserk.down
				if BuffExpires(berserk_bear_buff) Spell(incarnation_son_of_ursoc)
			}
		}
	}
}

### actions.precombat

AddFunction GuardianPrecombatMainActions
{
	#flask,type=greater_draenic_agility_flask
	#food,type=sleeper_sushi
	#mark_of_the_wild,if=!aura.str_agi_int.up
	if not BuffPresent(str_agi_int_buff any=1) Spell(mark_of_the_wild)
	#bear_form
	Spell(bear_form)
	#snapshot_stats
	#cenarion_ward
	Spell(cenarion_ward)
}

AddFunction GuardianPrecombatShortCdPostConditions
{
	not BuffPresent(str_agi_int_buff any=1) and Spell(mark_of_the_wild) or Spell(bear_form) or Spell(cenarion_ward)
}

AddFunction GuardianPrecombatCdPostConditions
{
	not BuffPresent(str_agi_int_buff any=1) and Spell(mark_of_the_wild) or Spell(bear_form) or Spell(cenarion_ward)
}

### Guardian icons.

AddCheckBox(opt_druid_guardian_aoe L(AOE) default specialization=guardian)

AddIcon checkbox=!opt_druid_guardian_aoe enemies=1 help=shortcd specialization=guardian
{
	unless not InCombat() and GuardianPrecombatShortCdPostConditions()
	{
		GuardianDefaultShortCdActions()
	}
}

AddIcon checkbox=opt_druid_guardian_aoe help=shortcd specialization=guardian
{
	unless not InCombat() and GuardianPrecombatShortCdPostConditions()
	{
		GuardianDefaultShortCdActions()
	}
}

AddIcon enemies=1 help=main specialization=guardian
{
	if not InCombat() GuardianPrecombatMainActions()
	GuardianDefaultMainActions()
}

AddIcon checkbox=opt_druid_guardian_aoe help=aoe specialization=guardian
{
	if not InCombat() GuardianPrecombatMainActions()
	GuardianDefaultMainActions()
}

AddIcon checkbox=!opt_druid_guardian_aoe enemies=1 help=cd specialization=guardian
{
	unless not InCombat() and GuardianPrecombatCdPostConditions()
	{
		GuardianDefaultCdActions()
	}
}

AddIcon checkbox=opt_druid_guardian_aoe help=cd specialization=guardian
{
	unless not InCombat() and GuardianPrecombatCdPostConditions()
	{
		GuardianDefaultCdActions()
	}
}

### Required symbols
# arcane_torrent_energy
# barkskin
# barkskin_buff
# bear_form
# berserk_bear
# berserk_bear_buff
# berserking
# blood_fury_apsp
# bristling_fur
# bristling_fur_buff
# cenarion_ward
# dream_of_cenarius_tank_buff
# enhanced_rejuvenation
# frenzied_regeneration
# healing_touch
# heart_of_the_wild_tank
# heart_of_the_wild_tank_buff
# incarnation_son_of_ursoc
# incarnation_son_of_ursoc_buff
# lacerate
# lacerate_debuff
# maim
# mangle
# mark_of_the_wild
# maul
# mighty_bash
# natures_vigil
# pulverize
# pulverize_buff
# pulverize_talent
# rejuvenation
# rejuvenation_buff
# renewal
# savage_defense
# savage_defense_buff
# shred
# skull_bash
# thrash_bear
# thrash_bear_debuff
# tooth_and_claw_buff
# typhoon
# war_stomp
# wild_charge
# wild_charge_bear
# wild_charge_cat
]]
	OvaleScripts:RegisterScript("DRUID", "guardian", name, desc, code, "script")
end
