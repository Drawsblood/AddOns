local OVALE, Ovale = ...
local OvaleScripts = Ovale.OvaleScripts

do
	local name = "simulationcraft_shaman_elemental_t18m"
	local desc = "[6.2] SimulationCraft: Shaman_Elemental_T18M"
	local code = [[
# Based on SimulationCraft profile "Shaman_Elemental_T18M".
#	class=shaman
#	spec=elemental
#	talents=0001011
#	glyphs=chain_lightning

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_shaman_spells)

AddCheckBox(opt_interrupt L(interrupt) default specialization=elemental)
AddCheckBox(opt_potion_intellect ItemName(draenic_intellect_potion) default specialization=elemental)
AddCheckBox(opt_bloodlust SpellName(bloodlust) specialization=elemental)

AddFunction ElementalUsePotionIntellect
{
	if CheckBoxOn(opt_potion_intellect) and target.Classification(worldboss) Item(draenic_intellect_potion usable=1)
}

AddFunction ElementalUseItemActions
{
	Item(HandSlot usable=1)
	Item(Trinket0Slot usable=1)
	Item(Trinket1Slot usable=1)
}

AddFunction ElementalBloodlust
{
	if CheckBoxOn(opt_bloodlust) and DebuffExpires(burst_haste_debuff any=1)
	{
		Spell(bloodlust)
		Spell(heroism)
	}
}

AddFunction ElementalInterruptActions
{
	if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.IsInterruptible()
	{
		Spell(wind_shear)
		if not target.Classification(worldboss)
		{
			Spell(arcane_torrent_mana)
			if target.InRange(quaking_palm) Spell(quaking_palm)
			Spell(war_stomp)
		}
	}
}

### actions.default

AddFunction ElementalDefaultMainActions
{
	#call_action_list,name=aoe,if=spell_targets.chain_lightning>(2+t18_class_trinket)
	if Enemies() > 2 + HasTrinket(t18_class_trinket) ElementalAoeMainActions()
	#call_action_list,name=single
	ElementalSingleMainActions()
}

AddFunction ElementalDefaultShortCdActions
{
	#elemental_mastery,if=action.lava_burst.cast_time>=1.2
	if CastTime(lava_burst) >= 1.2 Spell(elemental_mastery)
	#ancestral_swiftness,if=!buff.ascendance.up
	if not BuffPresent(ascendance_caster_buff) Spell(ancestral_swiftness)
	#liquid_magma,if=pet.searing_totem.remains>=15|pet.fire_elemental_totem.remains>=15
	if TotemRemaining(searing_totem) >= 15 or TotemRemaining(fire_elemental_totem) >= 15 Spell(liquid_magma)
}

AddFunction ElementalDefaultCdActions
{
	#wind_shear
	ElementalInterruptActions()
	#bloodlust,if=target.health.pct<25|time>0.500
	if target.HealthPercent() < 25 or TimeInCombat() > 0.5 ElementalBloodlust()
	#use_item,name=nithramus_the_allseer
	ElementalUseItemActions()
	#potion,name=draenic_intellect,if=buff.ascendance.up|target.time_to_die<=30
	if BuffPresent(ascendance_caster_buff) or target.TimeToDie() <= 30 ElementalUsePotionIntellect()
	#berserking,if=!buff.bloodlust.up&!buff.elemental_mastery.up&(set_bonus.tier15_4pc_caster=1|(buff.ascendance.cooldown_remains=0&(dot.flame_shock.remains>buff.ascendance.duration|level<87)))
	if not BuffPresent(burst_haste_buff any=1) and not BuffPresent(elemental_mastery_buff) and { ArmorSetBonus(T15_caster 4) == 1 or not SpellCooldown(ascendance_caster) > 0 and { target.DebuffRemaining(flame_shock_debuff) > BaseDuration(ascendance_caster_buff) or Level() < 87 } } Spell(berserking)
	#blood_fury,if=buff.bloodlust.up|buff.ascendance.up|((cooldown.ascendance.remains>10|level<87)&cooldown.fire_elemental_totem.remains>10)
	if BuffPresent(burst_haste_buff any=1) or BuffPresent(ascendance_caster_buff) or { SpellCooldown(ascendance_caster) > 10 or Level() < 87 } and SpellCooldown(fire_elemental_totem) > 10 Spell(blood_fury_apsp)
	#arcane_torrent
	Spell(arcane_torrent_mana)
	#storm_elemental_totem
	Spell(storm_elemental_totem)
	#fire_elemental_totem,if=!active
	if not TotemPresent(fire_elemental_totem) Spell(fire_elemental_totem)
	#ascendance,if=spell_targets.chain_lightning>1|(dot.flame_shock.remains>buff.ascendance.duration&(target.time_to_die<20|buff.bloodlust.up|time>=60)&cooldown.lava_burst.remains>0)
	if { Enemies() > 1 or target.DebuffRemaining(flame_shock_debuff) > BaseDuration(ascendance_caster_buff) and { target.TimeToDie() < 20 or BuffPresent(burst_haste_buff any=1) or TimeInCombat() >= 60 } and SpellCooldown(lava_burst) > 0 } and BuffExpires(ascendance_caster_buff) Spell(ascendance_caster)

	unless { TotemRemaining(searing_totem) >= 15 or TotemRemaining(fire_elemental_totem) >= 15 } and Spell(liquid_magma)
	{
		unless Enemies() > 2 + HasTrinket(t18_class_trinket) and ElementalAoeCdPostConditions()
		{
			#call_action_list,name=single
			ElementalSingleCdActions()
		}
	}
}

### actions.aoe

AddFunction ElementalAoeMainActions
{
	#earthquake,cycle_targets=1,if=buff.enhanced_chain_lightning.up
	if BuffPresent(enhanced_chain_lightning_buff) Spell(earthquake)
	#lava_beam
	Spell(lava_beam)
	#earth_shock,if=buff.lightning_shield.react=buff.lightning_shield.max_stack
	if BuffStacks(lightning_shield_buff) == SpellData(lightning_shield_buff max_stacks) Spell(earth_shock)
	#searing_totem,if=(!talent.liquid_magma.enabled&!totem.fire.active)|(talent.liquid_magma.enabled&pet.searing_totem.remains<=20&!pet.fire_elemental_totem.active&!buff.liquid_magma.up)
	if not Talent(liquid_magma_talent) and not TotemPresent(fire) or Talent(liquid_magma_talent) and TotemRemaining(searing_totem) <= 20 and not TotemPresent(fire_elemental_totem) and not BuffPresent(liquid_magma_buff) Spell(searing_totem)
	#chain_lightning,if=spell_targets.chain_lightning>=2
	if Enemies() >= 2 Spell(chain_lightning)
	#lightning_bolt
	Spell(lightning_bolt)
}

AddFunction ElementalAoeCdPostConditions
{
	BuffPresent(enhanced_chain_lightning_buff) and Spell(earthquake) or Spell(lava_beam) or BuffStacks(lightning_shield_buff) == SpellData(lightning_shield_buff max_stacks) and Spell(earth_shock) or { not Talent(liquid_magma_talent) and not TotemPresent(fire) or Talent(liquid_magma_talent) and TotemRemaining(searing_totem) <= 20 and not TotemPresent(fire_elemental_totem) and not BuffPresent(liquid_magma_buff) } and Spell(searing_totem) or Enemies() >= 2 and Spell(chain_lightning) or Spell(lightning_bolt)
}

### actions.precombat

AddFunction ElementalPrecombatMainActions
{
	#flask,type=greater_draenic_intellect_flask
	#food,type=salty_squid_roll
	#lightning_shield,if=!buff.lightning_shield.up
	if not BuffPresent(lightning_shield_buff) Spell(lightning_shield)
}

AddFunction ElementalPrecombatShortCdPostConditions
{
	not BuffPresent(lightning_shield_buff) and Spell(lightning_shield)
}

AddFunction ElementalPrecombatCdActions
{
	unless not BuffPresent(lightning_shield_buff) and Spell(lightning_shield)
	{
		#snapshot_stats
		#potion,name=draenic_intellect
		ElementalUsePotionIntellect()
	}
}

AddFunction ElementalPrecombatCdPostConditions
{
	not BuffPresent(lightning_shield_buff) and Spell(lightning_shield)
}

### actions.single

AddFunction ElementalSingleMainActions
{
	#unleash_flame,moving=1
	if Speed() > 0 Spell(unleash_flame)
	#earth_shock,if=buff.lightning_shield.react=buff.lightning_shield.max_stack
	if BuffStacks(lightning_shield_buff) == SpellData(lightning_shield_buff max_stacks) Spell(earth_shock)
	#flame_shock,cycle_targets=1,if=(talent.elemental_fusion.enabled&buff.elemental_fusion.stack=2&buff.unleash_flame.up&dot.flame_shock.remains<(dot.flame_shock.duration*(0.3+t18_class_trinket*(0.48+talent.unleashed_fury.enabled*0.22))))
	if Talent(elemental_fusion_talent) and BuffStacks(elemental_fusion_buff) == 2 and BuffPresent(unleash_flame_buff) and target.DebuffRemaining(flame_shock_debuff) < target.DebuffDuration(flame_shock_debuff) * { 0.3 + HasTrinket(t18_class_trinket) * { 0.48 + TalentPoints(unleashed_fury_talent) * 0.22 } } Spell(flame_shock)
	#lava_burst,if=dot.flame_shock.remains>cast_time&(buff.ascendance.up|cooldown_react)
	if target.DebuffRemaining(flame_shock_debuff) > CastTime(lava_burst) and { BuffPresent(ascendance_caster_buff) or not SpellCooldown(lava_burst) > 0 } Spell(lava_burst)
	#earth_shock,if=(set_bonus.tier17_4pc&buff.lightning_shield.react>=12&!buff.lava_surge.up)|(!set_bonus.tier17_4pc&buff.lightning_shield.react>15)
	if ArmorSetBonus(T17 4) and BuffStacks(lightning_shield_buff) >= 12 and not BuffPresent(lava_surge_buff) or not ArmorSetBonus(T17 4) and BuffStacks(lightning_shield_buff) > 15 Spell(earth_shock)
	#flame_shock,cycle_targets=1,if=dot.flame_shock.remains<=(dot.flame_shock.duration*0.3)
	if target.DebuffRemaining(flame_shock_debuff) <= target.DebuffDuration(flame_shock_debuff) * 0.3 Spell(flame_shock)
	#elemental_blast
	Spell(elemental_blast)
	#flame_shock,if=time>60&remains<=buff.ascendance.duration&cooldown.ascendance.remains+buff.ascendance.duration<duration
	if TimeInCombat() > 60 and target.DebuffRemaining(flame_shock_debuff) <= BaseDuration(ascendance_caster_buff) and SpellCooldown(ascendance_caster) + BaseDuration(ascendance_caster_buff) < BaseDuration(flame_shock_debuff) Spell(flame_shock)
	#searing_totem,if=(!talent.liquid_magma.enabled&(!totem.fire.active|(pet.searing_totem.remains<=10&!pet.fire_elemental_totem.active&talent.unleashed_fury.enabled)))|(talent.liquid_magma.enabled&pet.searing_totem.remains<=20&!pet.fire_elemental_totem.active&!buff.liquid_magma.up)
	if not Talent(liquid_magma_talent) and { not TotemPresent(fire) or TotemRemaining(searing_totem) <= 10 and not TotemPresent(fire_elemental_totem) and Talent(unleashed_fury_talent) } or Talent(liquid_magma_talent) and TotemRemaining(searing_totem) <= 20 and not TotemPresent(fire_elemental_totem) and not BuffPresent(liquid_magma_buff) Spell(searing_totem)
	#unleash_flame,if=talent.unleashed_fury.enabled&!buff.ascendance.up|(talent.elemental_fusion.enabled&buff.elemental_fusion.stack=2&(dot.flame_shock.remains)<(dot.flame_shock.duration*(0.3+t18_class_trinket*(0.48+talent.unleashed_fury.enabled*0.22)))&cooldown.flame_shock.remains<gcd)
	if Talent(unleashed_fury_talent) and not BuffPresent(ascendance_caster_buff) or Talent(elemental_fusion_talent) and BuffStacks(elemental_fusion_buff) == 2 and target.DebuffRemaining(flame_shock_debuff) < target.DebuffDuration(flame_shock_debuff) * { 0.3 + HasTrinket(t18_class_trinket) * { 0.48 + TalentPoints(unleashed_fury_talent) * 0.22 } } and SpellCooldown(flame_shock) < GCD() Spell(unleash_flame)
	#earthquake,cycle_targets=1,if=buff.enhanced_chain_lightning.up
	if BuffPresent(enhanced_chain_lightning_buff) Spell(earthquake)
	#chain_lightning,if=spell_targets.chain_lightning>=2
	if Enemies() >= 2 Spell(chain_lightning)
	#lightning_bolt
	Spell(lightning_bolt)
}

AddFunction ElementalSingleCdActions
{
	unless Speed() > 0 and Spell(unleash_flame)
	{
		#spiritwalkers_grace,moving=1,if=buff.ascendance.up
		if Speed() > 0 and BuffPresent(ascendance_caster_buff) Spell(spiritwalkers_grace)

		unless BuffStacks(lightning_shield_buff) == SpellData(lightning_shield_buff max_stacks) and Spell(earth_shock) or Talent(elemental_fusion_talent) and BuffStacks(elemental_fusion_buff) == 2 and BuffPresent(unleash_flame_buff) and target.DebuffRemaining(flame_shock_debuff) < target.DebuffDuration(flame_shock_debuff) * { 0.3 + HasTrinket(t18_class_trinket) * { 0.48 + TalentPoints(unleashed_fury_talent) * 0.22 } } and Spell(flame_shock) or target.DebuffRemaining(flame_shock_debuff) > CastTime(lava_burst) and { BuffPresent(ascendance_caster_buff) or not SpellCooldown(lava_burst) > 0 } and Spell(lava_burst) or { ArmorSetBonus(T17 4) and BuffStacks(lightning_shield_buff) >= 12 and not BuffPresent(lava_surge_buff) or not ArmorSetBonus(T17 4) and BuffStacks(lightning_shield_buff) > 15 } and Spell(earth_shock) or target.DebuffRemaining(flame_shock_debuff) <= target.DebuffDuration(flame_shock_debuff) * 0.3 and Spell(flame_shock) or Spell(elemental_blast) or TimeInCombat() > 60 and target.DebuffRemaining(flame_shock_debuff) <= BaseDuration(ascendance_caster_buff) and SpellCooldown(ascendance_caster) + BaseDuration(ascendance_caster_buff) < BaseDuration(flame_shock_debuff) and Spell(flame_shock) or { not Talent(liquid_magma_talent) and { not TotemPresent(fire) or TotemRemaining(searing_totem) <= 10 and not TotemPresent(fire_elemental_totem) and Talent(unleashed_fury_talent) } or Talent(liquid_magma_talent) and TotemRemaining(searing_totem) <= 20 and not TotemPresent(fire_elemental_totem) and not BuffPresent(liquid_magma_buff) } and Spell(searing_totem) or { Talent(unleashed_fury_talent) and not BuffPresent(ascendance_caster_buff) or Talent(elemental_fusion_talent) and BuffStacks(elemental_fusion_buff) == 2 and target.DebuffRemaining(flame_shock_debuff) < target.DebuffDuration(flame_shock_debuff) * { 0.3 + HasTrinket(t18_class_trinket) * { 0.48 + TalentPoints(unleashed_fury_talent) * 0.22 } } and SpellCooldown(flame_shock) < GCD() } and Spell(unleash_flame)
		{
			#spiritwalkers_grace,moving=1,if=((talent.elemental_blast.enabled&cooldown.elemental_blast.remains=0)|(cooldown.lava_burst.remains=0&!buff.lava_surge.react))
			if Speed() > 0 and { Talent(elemental_blast_talent) and not SpellCooldown(elemental_blast) > 0 or not SpellCooldown(lava_burst) > 0 and not BuffPresent(lava_surge_buff) } Spell(spiritwalkers_grace)
		}
	}
}

### Elemental icons.

AddCheckBox(opt_shaman_elemental_aoe L(AOE) default specialization=elemental)

AddIcon checkbox=!opt_shaman_elemental_aoe enemies=1 help=shortcd specialization=elemental
{
	unless not InCombat() and ElementalPrecombatShortCdPostConditions()
	{
		ElementalDefaultShortCdActions()
	}
}

AddIcon checkbox=opt_shaman_elemental_aoe help=shortcd specialization=elemental
{
	unless not InCombat() and ElementalPrecombatShortCdPostConditions()
	{
		ElementalDefaultShortCdActions()
	}
}

AddIcon enemies=1 help=main specialization=elemental
{
	if not InCombat() ElementalPrecombatMainActions()
	ElementalDefaultMainActions()
}

AddIcon checkbox=opt_shaman_elemental_aoe help=aoe specialization=elemental
{
	if not InCombat() ElementalPrecombatMainActions()
	ElementalDefaultMainActions()
}

AddIcon checkbox=!opt_shaman_elemental_aoe enemies=1 help=cd specialization=elemental
{
	if not InCombat() ElementalPrecombatCdActions()
	unless not InCombat() and ElementalPrecombatCdPostConditions()
	{
		ElementalDefaultCdActions()
	}
}

AddIcon checkbox=opt_shaman_elemental_aoe help=cd specialization=elemental
{
	if not InCombat() ElementalPrecombatCdActions()
	unless not InCombat() and ElementalPrecombatCdPostConditions()
	{
		ElementalDefaultCdActions()
	}
}

### Required symbols
# ancestral_swiftness
# arcane_torrent_mana
# ascendance_caster
# ascendance_caster_buff
# berserking
# blood_fury_apsp
# bloodlust
# chain_lightning
# draenic_intellect_potion
# earth_shock
# earthquake
# elemental_blast
# elemental_blast_talent
# elemental_fusion_buff
# elemental_fusion_talent
# elemental_mastery
# elemental_mastery_buff
# enhanced_chain_lightning_buff
# fire_elemental_totem
# flame_shock
# flame_shock_debuff
# heroism
# lava_beam
# lava_burst
# lava_surge_buff
# lightning_bolt
# lightning_shield
# lightning_shield_buff
# liquid_magma
# liquid_magma_buff
# liquid_magma_talent
# quaking_palm
# searing_totem
# spiritwalkers_grace
# storm_elemental_totem
# t18_class_trinket
# unleash_flame
# unleash_flame_buff
# unleashed_fury_talent
# war_stomp
# wind_shear
]]
	OvaleScripts:RegisterScript("SHAMAN", "elemental", name, desc, code, "script")
end
