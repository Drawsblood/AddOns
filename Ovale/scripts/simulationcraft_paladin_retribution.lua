local OVALE, Ovale = ...
local OvaleScripts = Ovale.OvaleScripts

do
	local name = "simulationcraft_paladin_retribution_t18m"
	local desc = "[6.2] SimulationCraft: Paladin_Retribution_T18M"
	local code = [[
# Based on SimulationCraft profile "Paladin_Retribution_T18M".
#	class=paladin
#	spec=retribution
#	talents=2112232
#	glyphs=templars_verdict/mass_exorcism/glyph_of_double_jeopardy

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_paladin_spells)

AddCheckBox(opt_interrupt L(interrupt) default specialization=retribution)
AddCheckBox(opt_melee_range L(not_in_melee_range) specialization=retribution)
AddCheckBox(opt_potion_strength ItemName(draenic_strength_potion) default specialization=retribution)
AddCheckBox(opt_righteous_fury_check SpellName(righteous_fury) default specialization=retribution)

AddFunction RetributionUsePotionStrength
{
	if CheckBoxOn(opt_potion_strength) and target.Classification(worldboss) Item(draenic_strength_potion usable=1)
}

AddFunction RetributionUseItemActions
{
	Item(HandSlot usable=1)
	Item(Trinket0Slot usable=1)
	Item(Trinket1Slot usable=1)
}

AddFunction RetributionGetInMeleeRange
{
	if CheckBoxOn(opt_melee_range) and not target.InRange(rebuke) Texture(misc_arrowlup help=L(not_in_melee_range))
}

AddFunction RetributionInterruptActions
{
	if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.IsInterruptible()
	{
		if target.InRange(rebuke) Spell(rebuke)
		if not target.Classification(worldboss)
		{
			if target.InRange(fist_of_justice) Spell(fist_of_justice)
			if target.InRange(hammer_of_justice) Spell(hammer_of_justice)
			Spell(blinding_light)
			Spell(arcane_torrent_holy)
			if target.InRange(quaking_palm) Spell(quaking_palm)
			Spell(war_stomp)
		}
	}
}

### actions.default

AddFunction RetributionDefaultMainActions
{
	#judgment,if=talent.empowered_seals.enabled&time<2
	if Talent(empowered_seals_talent) and TimeInCombat() < 2 Spell(judgment)
	#wait,sec=cooldown.seraphim.remains,if=talent.seraphim.enabled&cooldown.seraphim.remains>0&cooldown.seraphim.remains<gcd.max&holy_power>=5
	unless Talent(seraphim_talent) and SpellCooldown(seraphim) > 0 and SpellCooldown(seraphim) < GCD() and HolyPower() >= 5 and SpellCooldown(seraphim) > 0
	{
		#call_action_list,name=cleave,if=spell_targets.divine_storm>=3
		if Enemies() >= 3 RetributionCleaveMainActions()
		#call_action_list,name=single
		RetributionSingleMainActions()
	}
}

AddFunction RetributionDefaultShortCdActions
{
	#auto_attack,target_if=dot.censure.remains<4
	RetributionGetInMeleeRange()
	#speed_of_light,if=movement.distance>5
	if 0 > 5 Spell(speed_of_light)

	unless Talent(empowered_seals_talent) and TimeInCombat() < 2 and Spell(judgment)
	{
		#execution_sentence,if=!talent.seraphim.enabled
		if not Talent(seraphim_talent) Spell(execution_sentence)
		#execution_sentence,sync=seraphim,if=talent.seraphim.enabled
		if Spell(seraphim) and Talent(seraphim_talent) Spell(execution_sentence)
		#lights_hammer,if=!talent.seraphim.enabled
		if not Talent(seraphim_talent) Spell(lights_hammer)
		#lights_hammer,sync=seraphim,if=talent.seraphim.enabled
		if Spell(seraphim) and Talent(seraphim_talent) Spell(lights_hammer)
		#seraphim
		Spell(seraphim)
	}
}

AddFunction RetributionDefaultCdActions
{
	#rebuke
	RetributionInterruptActions()
	#potion,name=draenic_strength,if=(buff.bloodlust.react|buff.avenging_wrath.up|target.time_to_die<=40)
	if BuffPresent(burst_haste_buff any=1) or BuffPresent(avenging_wrath_melee_buff) or target.TimeToDie() <= 40 RetributionUsePotionStrength()

	unless Talent(empowered_seals_talent) and TimeInCombat() < 2 and Spell(judgment) or not Talent(seraphim_talent) and Spell(execution_sentence) or Spell(seraphim) and Talent(seraphim_talent) and Spell(execution_sentence) or not Talent(seraphim_talent) and Spell(lights_hammer) or Spell(seraphim) and Talent(seraphim_talent) and Spell(lights_hammer)
	{
		#use_item,name=thorasus_the_stone_heart_of_draenor,if=buff.avenging_wrath.up
		if BuffPresent(avenging_wrath_melee_buff) RetributionUseItemActions()
		#avenging_wrath,sync=seraphim,if=talent.seraphim.enabled
		if Spell(seraphim) and Talent(seraphim_talent) Spell(avenging_wrath_melee)
		#avenging_wrath,if=!talent.seraphim.enabled&set_bonus.tier18_4pc=0
		if not Talent(seraphim_talent) and ArmorSetBonus(T18 4) == 0 Spell(avenging_wrath_melee)
		#avenging_wrath,if=!talent.seraphim.enabled&time<20&set_bonus.tier18_4pc=1
		if not Talent(seraphim_talent) and TimeInCombat() < 20 and ArmorSetBonus(T18 4) == 1 Spell(avenging_wrath_melee)
		#avenging_wrath,if=prev.execution_sentence&set_bonus.tier18_4pc=1&talent.execution_sentence.enabled&!talent.seraphim.enabled
		if PreviousSpell(execution_sentence) and ArmorSetBonus(T18 4) == 1 and Talent(execution_sentence_talent) and not Talent(seraphim_talent) Spell(avenging_wrath_melee)
		#avenging_wrath,if=prev.lights_hammer&set_bonus.tier18_4pc=1&talent.lights_hammer.enabled&!talent.seraphim.enabled
		if PreviousSpell(lights_hammer) and ArmorSetBonus(T18 4) == 1 and Talent(lights_hammer_talent) and not Talent(seraphim_talent) Spell(avenging_wrath_melee)
		#holy_avenger,sync=avenging_wrath,if=!talent.seraphim.enabled
		if Spell(seraphim) and Talent(seraphim_talent) and Spell(avenging_wrath_melee) and not Talent(seraphim_talent) Spell(holy_avenger)
		#holy_avenger,sync=seraphim,if=talent.seraphim.enabled
		if Spell(seraphim) and Talent(seraphim_talent) Spell(holy_avenger)
		#holy_avenger,if=holy_power<=2&!talent.seraphim.enabled
		if HolyPower() <= 2 and not Talent(seraphim_talent) Spell(holy_avenger)
		#blood_fury
		Spell(blood_fury_apsp)
		#berserking
		Spell(berserking)
		#arcane_torrent
		Spell(arcane_torrent_holy)
	}
}

### actions.cleave

AddFunction RetributionCleaveMainActions
{
	#final_verdict,if=buff.final_verdict.down&holy_power=5
	if BuffExpires(final_verdict_buff) and HolyPower() == 5 Spell(final_verdict)
	#divine_storm,if=buff.divine_crusader.react&holy_power=5&buff.final_verdict.up
	if BuffPresent(divine_crusader_buff) and HolyPower() == 5 and BuffPresent(final_verdict_buff) Spell(divine_storm)
	#divine_storm,if=holy_power=5&buff.final_verdict.up
	if HolyPower() == 5 and BuffPresent(final_verdict_buff) Spell(divine_storm)
	#divine_storm,if=buff.divine_crusader.react&holy_power=5&!talent.final_verdict.enabled
	if BuffPresent(divine_crusader_buff) and HolyPower() == 5 and not Talent(final_verdict_talent) Spell(divine_storm)
	#divine_storm,if=holy_power=5&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*4)&!talent.final_verdict.enabled
	if HolyPower() == 5 and { not Talent(seraphim_talent) or SpellCooldown(seraphim) > GCD() * 4 } and not Talent(final_verdict_talent) Spell(divine_storm)
	#hammer_of_wrath
	Spell(hammer_of_wrath)
	#hammer_of_the_righteous,if=t18_class_trinket=1&buff.focus_of_vengeance.remains<gcd.max*2
	if HasTrinket(t18_class_trinket) == 1 and BuffRemaining(focus_of_vengeance_buff) < GCD() * 2 Spell(hammer_of_the_righteous)
	#judgment,if=talent.empowered_seals.enabled&seal.righteousness&buff.liadrins_righteousness.remains<cooldown.judgment.duration
	if Talent(empowered_seals_talent) and Stance(paladin_seal_of_righteousness) and BuffRemaining(liadrins_righteousness_buff) < SpellCooldownDuration(judgment) Spell(judgment)
	#exorcism,if=buff.blazing_contempt.up&holy_power<=2&buff.holy_avenger.down
	if BuffPresent(blazing_contempt_buff) and HolyPower() <= 2 and BuffExpires(holy_avenger_buff) Spell(exorcism)
	#divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up&(buff.avenging_wrath.up|target.health.pct<35)
	if BuffPresent(divine_crusader_buff) and BuffPresent(final_verdict_buff) and { BuffPresent(avenging_wrath_melee_buff) or target.HealthPercent() < 35 } Spell(divine_storm)
	#divine_storm,if=buff.final_verdict.up&(buff.avenging_wrath.up|target.health.pct<35)
	if BuffPresent(final_verdict_buff) and { BuffPresent(avenging_wrath_melee_buff) or target.HealthPercent() < 35 } Spell(divine_storm)
	#final_verdict,if=buff.final_verdict.down&(buff.avenging_wrath.up|target.health.pct<35)
	if BuffExpires(final_verdict_buff) and { BuffPresent(avenging_wrath_melee_buff) or target.HealthPercent() < 35 } Spell(final_verdict)
	#divine_storm,if=buff.divine_crusader.react&(buff.avenging_wrath.up|target.health.pct<35)&!talent.final_verdict.enabled
	if BuffPresent(divine_crusader_buff) and { BuffPresent(avenging_wrath_melee_buff) or target.HealthPercent() < 35 } and not Talent(final_verdict_talent) Spell(divine_storm)
	#divine_storm,if=holy_power=5&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*3)&!talent.final_verdict.enabled
	if HolyPower() == 5 and { BuffPresent(avenging_wrath_melee_buff) or target.HealthPercent() < 35 } and { not Talent(seraphim_talent) or SpellCooldown(seraphim) > GCD() * 3 } and not Talent(final_verdict_talent) Spell(divine_storm)
	#divine_storm,if=holy_power=4&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*4)&!talent.final_verdict.enabled
	if HolyPower() == 4 and { BuffPresent(avenging_wrath_melee_buff) or target.HealthPercent() < 35 } and { not Talent(seraphim_talent) or SpellCooldown(seraphim) > GCD() * 4 } and not Talent(final_verdict_talent) Spell(divine_storm)
	#divine_storm,if=holy_power=3&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*5)&!talent.final_verdict.enabled
	if HolyPower() == 3 and { BuffPresent(avenging_wrath_melee_buff) or target.HealthPercent() < 35 } and { not Talent(seraphim_talent) or SpellCooldown(seraphim) > GCD() * 5 } and not Talent(final_verdict_talent) Spell(divine_storm)
	#hammer_of_the_righteous,if=spell_targets.hammer_of_the_righteous>=4&talent.seraphim.enabled
	if Enemies() >= 4 and Talent(seraphim_talent) Spell(hammer_of_the_righteous)
	#hammer_of_the_righteous,,if=spell_targets.hammer_of_the_righteous>=4&(holy_power<=3|(holy_power=4&target.health.pct>=35&buff.avenging_wrath.down))
	if Enemies() >= 4 and { HolyPower() <= 3 or HolyPower() == 4 and target.HealthPercent() >= 35 and BuffExpires(avenging_wrath_melee_buff) } Spell(hammer_of_the_righteous)
	#crusader_strike,if=talent.seraphim.enabled
	if Talent(seraphim_talent) Spell(crusader_strike)
	#crusader_strike,if=holy_power<=3|(holy_power=4&target.health.pct>=35&buff.avenging_wrath.down)
	if HolyPower() <= 3 or HolyPower() == 4 and target.HealthPercent() >= 35 and BuffExpires(avenging_wrath_melee_buff) Spell(crusader_strike)
	#exorcism,if=glyph.mass_exorcism.enabled&!set_bonus.tier17_4pc=1
	if Glyph(glyph_of_mass_exorcism) and not ArmorSetBonus(T17 4) == 1 Spell(exorcism)
	#judgment,cycle_targets=1,if=last_judgment_target!=target&talent.seraphim.enabled&glyph.double_jeopardy.enabled
	if BuffPresent(glyph_of_double_jeopardy_buff) and Talent(seraphim_talent) and Glyph(glyph_of_double_jeopardy) Spell(judgment text=double)
	#judgment,if=talent.seraphim.enabled
	if Talent(seraphim_talent) Spell(judgment)
	#judgment,cycle_targets=1,if=last_judgment_target!=target&glyph.double_jeopardy.enabled&(holy_power<=3|(holy_power=4&cooldown.crusader_strike.remains>=gcd*2&target.health.pct>35&buff.avenging_wrath.down))
	if BuffPresent(glyph_of_double_jeopardy_buff) and Glyph(glyph_of_double_jeopardy) and { HolyPower() <= 3 or HolyPower() == 4 and SpellCooldown(crusader_strike) >= GCD() * 2 and target.HealthPercent() > 35 and BuffExpires(avenging_wrath_melee_buff) } Spell(judgment text=double)
	#judgment,if=holy_power<=3|(holy_power=4&cooldown.crusader_strike.remains>=gcd*2&target.health.pct>35&buff.avenging_wrath.down)
	if HolyPower() <= 3 or HolyPower() == 4 and SpellCooldown(crusader_strike) >= GCD() * 2 and target.HealthPercent() > 35 and BuffExpires(avenging_wrath_melee_buff) Spell(judgment)
	#divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up
	if BuffPresent(divine_crusader_buff) and BuffPresent(final_verdict_buff) Spell(divine_storm)
	#divine_storm,if=buff.divine_purpose.react&buff.final_verdict.up
	if BuffPresent(divine_purpose_buff) and BuffPresent(final_verdict_buff) Spell(divine_storm)
	#divine_storm,if=holy_power>=4&buff.final_verdict.up
	if HolyPower() >= 4 and BuffPresent(final_verdict_buff) Spell(divine_storm)
	#final_verdict,if=buff.divine_purpose.react&buff.final_verdict.down
	if BuffPresent(divine_purpose_buff) and BuffExpires(final_verdict_buff) Spell(final_verdict)
	#final_verdict,if=holy_power>=4&buff.final_verdict.down
	if HolyPower() >= 4 and BuffExpires(final_verdict_buff) Spell(final_verdict)
	#divine_storm,if=buff.divine_crusader.react&!talent.final_verdict.enabled
	if BuffPresent(divine_crusader_buff) and not Talent(final_verdict_talent) Spell(divine_storm)
	#divine_storm,if=holy_power>=4&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*5)&!talent.final_verdict.enabled
	if HolyPower() >= 4 and { not Talent(seraphim_talent) or SpellCooldown(seraphim) > GCD() * 5 } and not Talent(final_verdict_talent) Spell(divine_storm)
	#exorcism,if=talent.seraphim.enabled
	if Talent(seraphim_talent) Spell(exorcism)
	#exorcism,if=holy_power<=3|(holy_power=4&(cooldown.judgment.remains>=gcd*2&cooldown.crusader_strike.remains>=gcd*2&target.health.pct>35&buff.avenging_wrath.down))
	if HolyPower() <= 3 or HolyPower() == 4 and SpellCooldown(judgment) >= GCD() * 2 and SpellCooldown(crusader_strike) >= GCD() * 2 and target.HealthPercent() > 35 and BuffExpires(avenging_wrath_melee_buff) Spell(exorcism)
	#divine_storm,if=holy_power>=3&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*6)&!talent.final_verdict.enabled
	if HolyPower() >= 3 and { not Talent(seraphim_talent) or SpellCooldown(seraphim) > GCD() * 6 } and not Talent(final_verdict_talent) Spell(divine_storm)
	#divine_storm,if=holy_power>=3&buff.final_verdict.up
	if HolyPower() >= 3 and BuffPresent(final_verdict_buff) Spell(divine_storm)
	#final_verdict,if=holy_power>=3&buff.final_verdict.down
	if HolyPower() >= 3 and BuffExpires(final_verdict_buff) Spell(final_verdict)
	#holy_prism,target=self
	Spell(holy_prism text=self)
}

### actions.precombat

AddFunction RetributionPrecombatMainActions
{
	#flask,type=greater_draenic_strength_flask
	#food,type=sleeper_sushi
	#blessing_of_kings,if=!aura.str_agi_int.up
	if not BuffPresent(str_agi_int_buff any=1) and BuffExpires(mastery_buff) Spell(blessing_of_kings)
	#blessing_of_might,if=!aura.mastery.up
	if not BuffPresent(mastery_buff any=1) Spell(blessing_of_might)
	#seal_of_truth,if=spell_targets.divine_storm<3
	if Enemies() < 3 Spell(seal_of_truth)
	#seal_of_righteousness,if=spell_targets.divine_storm>=3
	if Enemies() >= 3 Spell(seal_of_righteousness)
	#righteous_fury,if=buff.righteous_fury.up
	if BuffPresent(righteous_fury_buff) and CheckBoxOn(opt_righteous_fury_check) Spell(righteous_fury)
}

AddFunction RetributionPrecombatShortCdPostConditions
{
	not BuffPresent(str_agi_int_buff any=1) and BuffExpires(mastery_buff) and Spell(blessing_of_kings) or not BuffPresent(mastery_buff any=1) and Spell(blessing_of_might) or Enemies() < 3 and Spell(seal_of_truth) or Enemies() >= 3 and Spell(seal_of_righteousness) or BuffPresent(righteous_fury_buff) and CheckBoxOn(opt_righteous_fury_check) and Spell(righteous_fury)
}

AddFunction RetributionPrecombatCdActions
{
	unless not BuffPresent(str_agi_int_buff any=1) and BuffExpires(mastery_buff) and Spell(blessing_of_kings) or not BuffPresent(mastery_buff any=1) and Spell(blessing_of_might) or Enemies() < 3 and Spell(seal_of_truth) or Enemies() >= 3 and Spell(seal_of_righteousness) or BuffPresent(righteous_fury_buff) and CheckBoxOn(opt_righteous_fury_check) and Spell(righteous_fury)
	{
		#snapshot_stats
		#potion,name=draenic_strength
		RetributionUsePotionStrength()
	}
}

AddFunction RetributionPrecombatCdPostConditions
{
	not BuffPresent(str_agi_int_buff any=1) and BuffExpires(mastery_buff) and Spell(blessing_of_kings) or not BuffPresent(mastery_buff any=1) and Spell(blessing_of_might) or Enemies() < 3 and Spell(seal_of_truth) or Enemies() >= 3 and Spell(seal_of_righteousness) or BuffPresent(righteous_fury_buff) and CheckBoxOn(opt_righteous_fury_check) and Spell(righteous_fury)
}

### actions.single

AddFunction RetributionSingleMainActions
{
	#divine_storm,if=buff.divine_crusader.react&(holy_power=5|buff.holy_avenger.up&holy_power>=3)&buff.final_verdict.up
	if BuffPresent(divine_crusader_buff) and { HolyPower() == 5 or BuffPresent(holy_avenger_buff) and HolyPower() >= 3 } and BuffPresent(final_verdict_buff) Spell(divine_storm)
	#divine_storm,if=buff.divine_crusader.react&(holy_power=5|buff.holy_avenger.up&holy_power>=3)&spell_targets.divine_storm=2&!talent.final_verdict.enabled
	if BuffPresent(divine_crusader_buff) and { HolyPower() == 5 or BuffPresent(holy_avenger_buff) and HolyPower() >= 3 } and Enemies() == 2 and not Talent(final_verdict_talent) Spell(divine_storm)
	#divine_storm,if=(holy_power=5|buff.holy_avenger.up&holy_power>=3)&spell_targets.divine_storm=2&buff.final_verdict.up
	if { HolyPower() == 5 or BuffPresent(holy_avenger_buff) and HolyPower() >= 3 } and Enemies() == 2 and BuffPresent(final_verdict_buff) Spell(divine_storm)
	#divine_storm,if=buff.divine_crusader.react&(holy_power=5|buff.holy_avenger.up&holy_power>=3)&(talent.seraphim.enabled&cooldown.seraphim.remains<gcd*4)
	if BuffPresent(divine_crusader_buff) and { HolyPower() == 5 or BuffPresent(holy_avenger_buff) and HolyPower() >= 3 } and Talent(seraphim_talent) and SpellCooldown(seraphim) < GCD() * 4 Spell(divine_storm)
	#templars_verdict,if=(holy_power=5|buff.holy_avenger.up&holy_power>=3)&(buff.avenging_wrath.down|target.health.pct>35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*4)
	if { HolyPower() == 5 or BuffPresent(holy_avenger_buff) and HolyPower() >= 3 } and { BuffExpires(avenging_wrath_melee_buff) or target.HealthPercent() > 35 } and { not Talent(seraphim_talent) or SpellCooldown(seraphim) > GCD() * 4 } Spell(templars_verdict)
	#templars_verdict,if=buff.divine_purpose.react&buff.divine_purpose.remains<3
	if BuffPresent(divine_purpose_buff) and BuffRemaining(divine_purpose_buff) < 3 Spell(templars_verdict)
	#divine_storm,if=buff.divine_crusader.react&buff.divine_crusader.remains<3&buff.final_verdict.up
	if BuffPresent(divine_crusader_buff) and BuffRemaining(divine_crusader_buff) < 3 and BuffPresent(final_verdict_buff) Spell(divine_storm)
	#final_verdict,if=holy_power=5|buff.holy_avenger.up&holy_power>=3
	if HolyPower() == 5 or BuffPresent(holy_avenger_buff) and HolyPower() >= 3 Spell(final_verdict)
	#final_verdict,if=buff.divine_purpose.react&buff.divine_purpose.remains<3
	if BuffPresent(divine_purpose_buff) and BuffRemaining(divine_purpose_buff) < 3 Spell(final_verdict)
	#crusader_strike,if=t18_class_trinket=1&buff.focus_of_vengeance.remains<gcd.max*2
	if HasTrinket(t18_class_trinket) == 1 and BuffRemaining(focus_of_vengeance_buff) < GCD() * 2 Spell(crusader_strike)
	#hammer_of_wrath
	Spell(hammer_of_wrath)
	#exorcism,if=buff.blazing_contempt.up&holy_power<=2&buff.holy_avenger.down
	if BuffPresent(blazing_contempt_buff) and HolyPower() <= 2 and BuffExpires(holy_avenger_buff) Spell(exorcism)
	#divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up&(buff.avenging_wrath.up|target.health.pct<35)
	if BuffPresent(divine_crusader_buff) and BuffPresent(final_verdict_buff) and { BuffPresent(avenging_wrath_melee_buff) or target.HealthPercent() < 35 } Spell(divine_storm)
	#divine_storm,if=spell_targets.divine_storm=2&buff.final_verdict.up&(buff.avenging_wrath.up|target.health.pct<35)
	if Enemies() == 2 and BuffPresent(final_verdict_buff) and { BuffPresent(avenging_wrath_melee_buff) or target.HealthPercent() < 35 } Spell(divine_storm)
	#final_verdict,if=buff.avenging_wrath.up|target.health.pct<35
	if BuffPresent(avenging_wrath_melee_buff) or target.HealthPercent() < 35 Spell(final_verdict)
	#divine_storm,if=buff.divine_crusader.react&spell_targets.divine_storm=2&(buff.avenging_wrath.up|target.health.pct<35)&!talent.final_verdict.enabled
	if BuffPresent(divine_crusader_buff) and Enemies() == 2 and { BuffPresent(avenging_wrath_melee_buff) or target.HealthPercent() < 35 } and not Talent(final_verdict_talent) Spell(divine_storm)
	#templars_verdict,if=holy_power=5&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*3)
	if HolyPower() == 5 and { BuffPresent(avenging_wrath_melee_buff) or target.HealthPercent() < 35 } and { not Talent(seraphim_talent) or SpellCooldown(seraphim) > GCD() * 3 } Spell(templars_verdict)
	#templars_verdict,if=holy_power=4&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*4)
	if HolyPower() == 4 and { BuffPresent(avenging_wrath_melee_buff) or target.HealthPercent() < 35 } and { not Talent(seraphim_talent) or SpellCooldown(seraphim) > GCD() * 4 } Spell(templars_verdict)
	#templars_verdict,if=holy_power=3&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*5)
	if HolyPower() == 3 and { BuffPresent(avenging_wrath_melee_buff) or target.HealthPercent() < 35 } and { not Talent(seraphim_talent) or SpellCooldown(seraphim) > GCD() * 5 } Spell(templars_verdict)
	#judgment,if=talent.empowered_seals.enabled&seal.truth&buff.maraads_truth.remains<cooldown.judgment.duration*1.5
	if Talent(empowered_seals_talent) and Stance(paladin_seal_of_truth) and BuffRemaining(maraads_truth_buff) < SpellCooldownDuration(judgment) * 1.5 Spell(judgment)
	#judgment,if=talent.empowered_seals.enabled&seal.righteousness&buff.liadrins_righteousness.remains<cooldown.judgment.duration*1.5
	if Talent(empowered_seals_talent) and Stance(paladin_seal_of_righteousness) and BuffRemaining(liadrins_righteousness_buff) < SpellCooldownDuration(judgment) * 1.5 Spell(judgment)
	#seal_of_truth,if=talent.empowered_seals.enabled&buff.maraads_truth.remains<(cooldown.judgment.duration|buff.maraads_truth.down)&(buff.avenging_wrath.up|target.health.pct<35)&!buff.wings_of_liberty.up
	if Talent(empowered_seals_talent) and BuffRemaining(maraads_truth_buff) < { SpellCooldownDuration(judgment) or BuffExpires(maraads_truth_buff) } and { BuffPresent(avenging_wrath_melee_buff) or target.HealthPercent() < 35 } and not BuffPresent(wings_of_liberty_buff) Spell(seal_of_truth)
	#seal_of_righteousness,if=talent.empowered_seals.enabled&buff.liadrins_righteousness.remains<cooldown.judgment.duration&buff.maraads_truth.remains>cooldown.judgment.duration*1.5&target.health.pct<35&!buff.wings_of_liberty.up&!buff.bloodlust.up
	if Talent(empowered_seals_talent) and BuffRemaining(liadrins_righteousness_buff) < SpellCooldownDuration(judgment) and BuffRemaining(maraads_truth_buff) > SpellCooldownDuration(judgment) * 1.5 and target.HealthPercent() < 35 and not BuffPresent(wings_of_liberty_buff) and not BuffPresent(burst_haste_buff any=1) Spell(seal_of_righteousness)
	#crusader_strike,if=talent.seraphim.enabled
	if Talent(seraphim_talent) Spell(crusader_strike)
	#crusader_strike,if=holy_power<=3|(holy_power=4&target.health.pct>=35&buff.avenging_wrath.down)
	if HolyPower() <= 3 or HolyPower() == 4 and target.HealthPercent() >= 35 and BuffExpires(avenging_wrath_melee_buff) Spell(crusader_strike)
	#divine_storm,if=buff.divine_crusader.react&(buff.avenging_wrath.up|target.health.pct<35)&!talent.final_verdict.enabled
	if BuffPresent(divine_crusader_buff) and { BuffPresent(avenging_wrath_melee_buff) or target.HealthPercent() < 35 } and not Talent(final_verdict_talent) Spell(divine_storm)
	#exorcism,if=glyph.mass_exorcism.enabled&spell_targets.exorcism>=2&!glyph.double_jeopardy.enabled&!set_bonus.tier17_4pc=1
	if Glyph(glyph_of_mass_exorcism) and Enemies() >= 2 and not Glyph(glyph_of_double_jeopardy) and not ArmorSetBonus(T17 4) == 1 Spell(exorcism)
	#judgment,cycle_targets=1,if=last_judgment_target!=target&talent.seraphim.enabled&glyph.double_jeopardy.enabled
	if BuffPresent(glyph_of_double_jeopardy_buff) and Talent(seraphim_talent) and Glyph(glyph_of_double_jeopardy) Spell(judgment text=double)
	#judgment,if=talent.seraphim.enabled
	if Talent(seraphim_talent) Spell(judgment)
	#judgment,cycle_targets=1,if=last_judgment_target!=target&glyph.double_jeopardy.enabled&(holy_power<=3|(holy_power=4&cooldown.crusader_strike.remains>=gcd*2&target.health.pct>35&buff.avenging_wrath.down))
	if BuffPresent(glyph_of_double_jeopardy_buff) and Glyph(glyph_of_double_jeopardy) and { HolyPower() <= 3 or HolyPower() == 4 and SpellCooldown(crusader_strike) >= GCD() * 2 and target.HealthPercent() > 35 and BuffExpires(avenging_wrath_melee_buff) } Spell(judgment text=double)
	#judgment,if=holy_power<=3|(holy_power=4&cooldown.crusader_strike.remains>=gcd*2&target.health.pct>35&buff.avenging_wrath.down)
	if HolyPower() <= 3 or HolyPower() == 4 and SpellCooldown(crusader_strike) >= GCD() * 2 and target.HealthPercent() > 35 and BuffExpires(avenging_wrath_melee_buff) Spell(judgment)
	#divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up
	if BuffPresent(divine_crusader_buff) and BuffPresent(final_verdict_buff) Spell(divine_storm)
	#divine_storm,if=spell_targets.divine_storm=2&holy_power>=4&buff.final_verdict.up
	if Enemies() == 2 and HolyPower() >= 4 and BuffPresent(final_verdict_buff) Spell(divine_storm)
	#final_verdict,if=buff.divine_purpose.react
	if BuffPresent(divine_purpose_buff) Spell(final_verdict)
	#final_verdict,if=holy_power>=4
	if HolyPower() >= 4 Spell(final_verdict)
	#seal_of_truth,if=talent.empowered_seals.enabled&buff.maraads_truth.remains<cooldown.judgment.duration*1.5&buff.liadrins_righteousness.remains>cooldown.judgment.duration*1.5
	if Talent(empowered_seals_talent) and BuffRemaining(maraads_truth_buff) < SpellCooldownDuration(judgment) * 1.5 and BuffRemaining(liadrins_righteousness_buff) > SpellCooldownDuration(judgment) * 1.5 Spell(seal_of_truth)
	#seal_of_righteousness,if=talent.empowered_seals.enabled&buff.liadrins_righteousness.remains<cooldown.judgment.duration*1.5&buff.maraads_truth.remains>cooldown.judgment.duration*1.5&!buff.bloodlust.up
	if Talent(empowered_seals_talent) and BuffRemaining(liadrins_righteousness_buff) < SpellCooldownDuration(judgment) * 1.5 and BuffRemaining(maraads_truth_buff) > SpellCooldownDuration(judgment) * 1.5 and not BuffPresent(burst_haste_buff any=1) Spell(seal_of_righteousness)
	#divine_storm,if=buff.divine_crusader.react&spell_targets.divine_storm=2&holy_power>=4&!talent.final_verdict.enabled
	if BuffPresent(divine_crusader_buff) and Enemies() == 2 and HolyPower() >= 4 and not Talent(final_verdict_talent) Spell(divine_storm)
	#templars_verdict,if=buff.divine_purpose.react
	if BuffPresent(divine_purpose_buff) Spell(templars_verdict)
	#divine_storm,if=buff.divine_crusader.react&!talent.final_verdict.enabled
	if BuffPresent(divine_crusader_buff) and not Talent(final_verdict_talent) Spell(divine_storm)
	#templars_verdict,if=holy_power>=4&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*5)
	if HolyPower() >= 4 and { not Talent(seraphim_talent) or SpellCooldown(seraphim) > GCD() * 5 } Spell(templars_verdict)
	#exorcism,if=talent.seraphim.enabled
	if Talent(seraphim_talent) Spell(exorcism)
	#exorcism,if=holy_power<=3|(holy_power=4&(cooldown.judgment.remains>=gcd*2&cooldown.crusader_strike.remains>=gcd*2&target.health.pct>35&buff.avenging_wrath.down))
	if HolyPower() <= 3 or HolyPower() == 4 and SpellCooldown(judgment) >= GCD() * 2 and SpellCooldown(crusader_strike) >= GCD() * 2 and target.HealthPercent() > 35 and BuffExpires(avenging_wrath_melee_buff) Spell(exorcism)
	#divine_storm,if=spell_targets.divine_storm=2&holy_power>=3&buff.final_verdict.up
	if Enemies() == 2 and HolyPower() >= 3 and BuffPresent(final_verdict_buff) Spell(divine_storm)
	#final_verdict,if=holy_power>=3
	if HolyPower() >= 3 Spell(final_verdict)
	#templars_verdict,if=holy_power>=3&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*6)
	if HolyPower() >= 3 and { not Talent(seraphim_talent) or SpellCooldown(seraphim) > GCD() * 6 } Spell(templars_verdict)
	#holy_prism
	Spell(holy_prism)
}

### Retribution icons.

AddCheckBox(opt_paladin_retribution_aoe L(AOE) default specialization=retribution)

AddIcon checkbox=!opt_paladin_retribution_aoe enemies=1 help=shortcd specialization=retribution
{
	unless not InCombat() and RetributionPrecombatShortCdPostConditions()
	{
		RetributionDefaultShortCdActions()
	}
}

AddIcon checkbox=opt_paladin_retribution_aoe help=shortcd specialization=retribution
{
	unless not InCombat() and RetributionPrecombatShortCdPostConditions()
	{
		RetributionDefaultShortCdActions()
	}
}

AddIcon enemies=1 help=main specialization=retribution
{
	if not InCombat() RetributionPrecombatMainActions()
	RetributionDefaultMainActions()
}

AddIcon checkbox=opt_paladin_retribution_aoe help=aoe specialization=retribution
{
	if not InCombat() RetributionPrecombatMainActions()
	RetributionDefaultMainActions()
}

AddIcon checkbox=!opt_paladin_retribution_aoe enemies=1 help=cd specialization=retribution
{
	if not InCombat() RetributionPrecombatCdActions()
	unless not InCombat() and RetributionPrecombatCdPostConditions()
	{
		RetributionDefaultCdActions()
	}
}

AddIcon checkbox=opt_paladin_retribution_aoe help=cd specialization=retribution
{
	if not InCombat() RetributionPrecombatCdActions()
	unless not InCombat() and RetributionPrecombatCdPostConditions()
	{
		RetributionDefaultCdActions()
	}
}

### Required symbols
# arcane_torrent_holy
# avenging_wrath_melee
# avenging_wrath_melee_buff
# berserking
# blazing_contempt_buff
# blessing_of_kings
# blessing_of_might
# blinding_light
# blood_fury_apsp
# crusader_strike
# divine_crusader_buff
# divine_purpose_buff
# divine_storm
# draenic_strength_potion
# empowered_seals_talent
# execution_sentence
# execution_sentence_talent
# exorcism
# final_verdict
# final_verdict_buff
# final_verdict_talent
# fist_of_justice
# focus_of_vengeance_buff
# glyph_of_double_jeopardy
# glyph_of_double_jeopardy_buff
# glyph_of_mass_exorcism
# hammer_of_justice
# hammer_of_the_righteous
# hammer_of_wrath
# holy_avenger
# holy_avenger_buff
# holy_prism
# judgment
# liadrins_righteousness_buff
# lights_hammer
# lights_hammer_talent
# maraads_truth_buff
# quaking_palm
# rebuke
# righteous_fury
# righteous_fury_buff
# seal_of_righteousness
# seal_of_truth
# seraphim
# seraphim_talent
# speed_of_light
# t18_class_trinket
# templars_verdict
# war_stomp
# wings_of_liberty_buff
]]
	OvaleScripts:RegisterScript("PALADIN", "retribution", name, desc, code, "script")
end