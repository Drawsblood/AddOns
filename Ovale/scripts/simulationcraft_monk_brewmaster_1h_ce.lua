local OVALE, Ovale = ...
local OvaleScripts = Ovale.OvaleScripts

do
	local name = "simulationcraft_monk_brewmaster_1h_ce_t17m"
	local desc = "[6.0] SimulationCraft: Monk_Brewmaster_1h_CE_T17M"
	local code = [[
# Based on SimulationCraft profile "Monk_Brewmaster_1h_CE_T17M".
#	class=monk
#	spec=brewmaster
#	talents=2133112
#	glyphs=fortifying_brew,expel_harm,fortuitous_spheres

Include(ovale_common)
Include(ovale_monk_spells)

AddCheckBox(opt_interrupt L(interrupt) default)
AddCheckBox(opt_melee_range L(not_in_melee_range))
AddCheckBox(opt_potion_armor ItemName(draenic_armor_potion) default)
AddCheckBox(opt_chi_burst SpellName(chi_burst) default)

AddFunction UsePotionArmor
{
	if CheckBoxOn(opt_potion_armor) and target.Classification(worldboss) Item(draenic_armor_potion usable=1)
}

AddFunction GetInMeleeRange
{
	if CheckBoxOn(opt_melee_range) and not target.InRange(tiger_palm) Texture(misc_arrowlup help=L(not_in_melee_range))
}

AddFunction InterruptActions
{
	if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.IsInterruptible()
	{
		if target.InRange(spear_hand_strike) Spell(spear_hand_strike)
		if not target.Classification(worldboss)
		{
			if target.InRange(paralysis) Spell(paralysis)
			Spell(arcane_torrent_chi)
			if target.InRange(quaking_palm) Spell(quaking_palm)
			Spell(war_stomp)
		}
	}
}

### actions.default

AddFunction BrewmasterDefaultMainActions
{
	#chi_sphere,if=talent.power_strikes.enabled&buff.chi_sphere.react&chi<4
	#chi_brew,if=talent.chi_brew.enabled&chi.max-chi>=2&buff.elusive_brew_stacks.stack<=10&((charges=1&recharge_time<5)|charges=2|target.time_to_die<15)
	if Talent(chi_brew_talent) and MaxChi() - Chi() >= 2 and BuffStacks(elusive_brew_stacks_buff) <= 10 and { Charges(chi_brew) == 1 and SpellChargeCooldown(chi_brew) < 5 or Charges(chi_brew) == 2 or target.TimeToDie() < 15 } Spell(chi_brew)
	#chi_brew,if=(chi<1&stagger.heavy)|(chi<2&buff.shuffle.down)
	if Chi() < 1 and DebuffPresent(heavy_stagger_debuff) or Chi() < 2 and BuffExpires(shuffle_buff) Spell(chi_brew)
	#call_action_list,name=st,if=active_enemies<3
	if Enemies() < 3 BrewmasterStMainActions()
	#call_action_list,name=aoe,if=active_enemies>=3
	if Enemies() >= 3 BrewmasterAoeMainActions()
}

AddFunction BrewmasterDefaultShortCdActions
{
	#auto_attack
	GetInMeleeRange()
	#touch_of_death,if=target.health<health
	if target.Health() < Health() and BuffPresent(death_note_buff) Spell(touch_of_death)
	#elusive_brew,if=buff.elusive_brew_stacks.react>=9&(buff.dampen_harm.down|buff.diffuse_magic.down)&buff.elusive_brew_activated.down
	if BuffStacks(elusive_brew_stacks_buff) >= 9 and { BuffExpires(dampen_harm_buff) or BuffExpires(diffuse_magic_buff) } and BuffExpires(elusive_brew_activated_buff) Spell(elusive_brew)
	#serenity,if=talent.serenity.enabled&cooldown.keg_smash.remains>6
	if Talent(serenity_talent) and SpellCooldown(keg_smash) > 6 Spell(serenity)
	#call_action_list,name=st,if=active_enemies<3
	if Enemies() < 3 BrewmasterStShortCdActions()
	#call_action_list,name=aoe,if=active_enemies>=3
	if Enemies() >= 3 BrewmasterAoeShortCdActions()
}

AddFunction BrewmasterDefaultCdActions
{
	unless target.Health() < Health() and BuffPresent(death_note_buff) and Spell(touch_of_death)
	{
		#spear_hand_strike
		InterruptActions()
		#nimble_brew
		if IsFeared() or IsRooted() or IsStunned() Spell(nimble_brew)
		#blood_fury,if=energy<=40
		if Energy() <= 40 Spell(blood_fury_apsp)
		#berserking,if=energy<=40
		if Energy() <= 40 Spell(berserking)
		#arcane_torrent,if=energy<=40
		if Energy() <= 40 Spell(arcane_torrent_chi)
		#gift_of_the_ox,if=buff.gift_of_the_ox.react&incoming_damage_1500ms
		#diffuse_magic,if=incoming_damage_1500ms&buff.fortifying_brew.down
		if IncomingDamage(1.5) > 0 and BuffExpires(fortifying_brew_buff) Spell(diffuse_magic)
		#dampen_harm,if=incoming_damage_1500ms&buff.fortifying_brew.down&buff.elusive_brew_activated.down
		if IncomingDamage(1.5) > 0 and BuffExpires(fortifying_brew_buff) and BuffExpires(elusive_brew_activated_buff) Spell(dampen_harm)
		#fortifying_brew,if=incoming_damage_1500ms&(buff.dampen_harm.down|buff.diffuse_magic.down)&buff.elusive_brew_activated.down
		if IncomingDamage(1.5) > 0 and { BuffExpires(dampen_harm_buff) or BuffExpires(diffuse_magic_buff) } and BuffExpires(elusive_brew_activated_buff) Spell(fortifying_brew)
		#invoke_xuen,if=talent.invoke_xuen.enabled&target.time_to_die>15&buff.shuffle.remains>=3&buff.serenity.down
		if Talent(invoke_xuen_talent) and target.TimeToDie() > 15 and BuffRemaining(shuffle_buff) >= 3 and BuffExpires(serenity_buff) Spell(invoke_xuen)
		#potion,name=draenic_armor,if=(buff.fortifying_brew.down&(buff.dampen_harm.down|buff.diffuse_magic.down)&buff.elusive_brew_activated.down)
		if BuffExpires(fortifying_brew_buff) and { BuffExpires(dampen_harm_buff) or BuffExpires(diffuse_magic_buff) } and BuffExpires(elusive_brew_activated_buff) UsePotionArmor()
	}
}

### actions.aoe

AddFunction BrewmasterAoeMainActions
{
	#blackout_kick,if=buff.shuffle.down
	if BuffExpires(shuffle_buff) Spell(blackout_kick)
	#breath_of_fire,if=(chi>=3|buff.serenity.up)&buff.shuffle.remains>=6&dot.breath_of_fire.remains<=2.4&!talent.chi_explosion.enabled
	if { Chi() >= 3 or BuffPresent(serenity_buff) } and BuffRemaining(shuffle_buff) >= 6 and target.DebuffRemaining(breath_of_fire_debuff) <= 2.4 and not Talent(chi_explosion_talent) Spell(breath_of_fire)
	#keg_smash,if=chi.max-chi>=1&!buff.serenity.remains
	if MaxChi() - Chi() >= 1 and not BuffPresent(serenity_buff) Spell(keg_smash)
	#rushing_jade_wind,if=chi.max-chi>=1&!buff.serenity.remains&talent.rushing_jade_wind.enabled
	if MaxChi() - Chi() >= 1 and not BuffPresent(serenity_buff) and Talent(rushing_jade_wind_talent) Spell(rushing_jade_wind)
	#chi_wave,if=(energy+(energy.regen*gcd))<100
	if Energy() + EnergyRegenRate() * GCD() < 100 Spell(chi_wave)
	#zen_sphere,cycle_targets=1,if=talent.zen_sphere.enabled&!dot.zen_sphere.ticking&(energy+(energy.regen*gcd))<100
	if Talent(zen_sphere_talent) and not BuffPresent(zen_sphere_buff) and Energy() + EnergyRegenRate() * GCD() < 100 Spell(zen_sphere)
	#chi_explosion,if=chi>=4
	if Chi() >= 4 Spell(chi_explosion_tank)
	#blackout_kick,if=chi>=4
	if Chi() >= 4 Spell(blackout_kick)
	#blackout_kick,if=buff.shuffle.remains<=3&cooldown.keg_smash.remains>=gcd
	if BuffRemaining(shuffle_buff) <= 3 and SpellCooldown(keg_smash) >= GCD() Spell(blackout_kick)
	#blackout_kick,if=buff.serenity.up
	if BuffPresent(serenity_buff) Spell(blackout_kick)
	#expel_harm,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
	if MaxChi() - Chi() >= 1 and SpellCooldown(keg_smash) >= GCD() and Energy() + EnergyRegenRate() * SpellCooldown(keg_smash) >= 80 Spell(expel_harm)
	#jab,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&cooldown.expel_harm.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
	if MaxChi() - Chi() >= 1 and SpellCooldown(keg_smash) >= GCD() and SpellCooldown(expel_harm) >= GCD() and Energy() + EnergyRegenRate() * SpellCooldown(keg_smash) >= 80 Spell(jab)
	#tiger_palm
	Spell(tiger_palm)
}

AddFunction BrewmasterAoeShortCdActions
{
	#purifying_brew,if=stagger.heavy
	if DebuffPresent(heavy_stagger_debuff) Spell(purifying_brew)

	unless BuffExpires(shuffle_buff) and Spell(blackout_kick)
	{
		#purifying_brew,if=buff.serenity.up
		if BuffPresent(serenity_buff) Spell(purifying_brew)
		#purifying_brew,if=!talent.chi_explosion.enabled&stagger.moderate&buff.shuffle.remains>=6
		if not Talent(chi_explosion_talent) and DebuffPresent(moderate_stagger_debuff) and BuffRemaining(shuffle_buff) >= 6 Spell(purifying_brew)
		#guard,if=(charges=1&recharge_time<5)|charges=2|target.time_to_die<15
		if Charges(guard) == 1 and SpellChargeCooldown(guard) < 5 or Charges(guard) == 2 or target.TimeToDie() < 15 Spell(guard)
		#guard,if=incoming_damage_10s>=health.max*0.5
		if IncomingDamage(10) >= MaxHealth() * 0.5 Spell(guard)

		unless { Chi() >= 3 or BuffPresent(serenity_buff) } and BuffRemaining(shuffle_buff) >= 6 and target.DebuffRemaining(breath_of_fire_debuff) <= 2.4 and not Talent(chi_explosion_talent) and Spell(breath_of_fire) or MaxChi() - Chi() >= 1 and not BuffPresent(serenity_buff) and Spell(keg_smash) or MaxChi() - Chi() >= 1 and not BuffPresent(serenity_buff) and Talent(rushing_jade_wind_talent) and Spell(rushing_jade_wind)
		{
			#chi_burst,if=(energy+(energy.regen*gcd))<100
			if Energy() + EnergyRegenRate() * GCD() < 100 and CheckBoxOn(opt_chi_burst) Spell(chi_burst)
		}
	}
}

### actions.precombat

AddFunction BrewmasterPrecombatMainActions
{
	#flask,type=greater_draenic_stamina_flask
	#food,type=talador_surf_and_turf
	#legacy_of_the_white_tiger,if=!aura.str_agi_int.up
	if not BuffPresent(str_agi_int_buff any=1) Spell(legacy_of_the_white_tiger)
	#stance,choose=sturdy_ox
	Spell(stance_of_the_sturdy_ox)
}

AddFunction BrewmasterPrecombatCdActions
{
	unless not BuffPresent(str_agi_int_buff any=1) and Spell(legacy_of_the_white_tiger) or Spell(stance_of_the_sturdy_ox)
	{
		#snapshot_stats
		#potion,name=draenic_armor
		UsePotionArmor()
		#dampen_harm
		Spell(dampen_harm)
	}
}

### actions.st

AddFunction BrewmasterStMainActions
{
	#blackout_kick,if=buff.shuffle.down
	if BuffExpires(shuffle_buff) Spell(blackout_kick)
	#keg_smash,if=chi.max-chi>=1&!buff.serenity.remains
	if MaxChi() - Chi() >= 1 and not BuffPresent(serenity_buff) Spell(keg_smash)
	#chi_wave,if=(energy+(energy.regen*gcd))<100
	if Energy() + EnergyRegenRate() * GCD() < 100 Spell(chi_wave)
	#zen_sphere,cycle_targets=1,if=talent.zen_sphere.enabled&!dot.zen_sphere.ticking&(energy+(energy.regen*gcd))<100
	if Talent(zen_sphere_talent) and not BuffPresent(zen_sphere_buff) and Energy() + EnergyRegenRate() * GCD() < 100 Spell(zen_sphere)
	#chi_explosion,if=chi>=3
	if Chi() >= 3 Spell(chi_explosion_tank)
	#blackout_kick,if=chi>=4
	if Chi() >= 4 Spell(blackout_kick)
	#blackout_kick,if=buff.shuffle.remains<=3&cooldown.keg_smash.remains>=gcd
	if BuffRemaining(shuffle_buff) <= 3 and SpellCooldown(keg_smash) >= GCD() Spell(blackout_kick)
	#blackout_kick,if=buff.serenity.up
	if BuffPresent(serenity_buff) Spell(blackout_kick)
	#expel_harm,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
	if MaxChi() - Chi() >= 1 and SpellCooldown(keg_smash) >= GCD() and Energy() + EnergyRegenRate() * SpellCooldown(keg_smash) >= 80 Spell(expel_harm)
	#jab,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&cooldown.expel_harm.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
	if MaxChi() - Chi() >= 1 and SpellCooldown(keg_smash) >= GCD() and SpellCooldown(expel_harm) >= GCD() and Energy() + EnergyRegenRate() * SpellCooldown(keg_smash) >= 80 Spell(jab)
	#tiger_palm
	Spell(tiger_palm)
}

AddFunction BrewmasterStShortCdActions
{
	#purifying_brew,if=!talent.chi_explosion.enabled&stagger.heavy
	if not Talent(chi_explosion_talent) and DebuffPresent(heavy_stagger_debuff) Spell(purifying_brew)

	unless BuffExpires(shuffle_buff) and Spell(blackout_kick)
	{
		#purifying_brew,if=buff.serenity.up
		if BuffPresent(serenity_buff) Spell(purifying_brew)
		#purifying_brew,if=!talent.chi_explosion.enabled&stagger.moderate&buff.shuffle.remains>=6
		if not Talent(chi_explosion_talent) and DebuffPresent(moderate_stagger_debuff) and BuffRemaining(shuffle_buff) >= 6 Spell(purifying_brew)
		#guard,if=(charges=1&recharge_time<5)|charges=2|target.time_to_die<15
		if Charges(guard) == 1 and SpellChargeCooldown(guard) < 5 or Charges(guard) == 2 or target.TimeToDie() < 15 Spell(guard)
		#guard,if=incoming_damage_10s>=health.max*0.5
		if IncomingDamage(10) >= MaxHealth() * 0.5 Spell(guard)

		unless MaxChi() - Chi() >= 1 and not BuffPresent(serenity_buff) and Spell(keg_smash)
		{
			#chi_burst,if=(energy+(energy.regen*gcd))<100
			if Energy() + EnergyRegenRate() * GCD() < 100 and CheckBoxOn(opt_chi_burst) Spell(chi_burst)
		}
	}
}

### Brewmaster icons.
AddCheckBox(opt_monk_brewmaster_aoe L(AOE) specialization=brewmaster default)

AddIcon specialization=brewmaster help=shortcd enemies=1 checkbox=!opt_monk_brewmaster_aoe
{
	BrewmasterDefaultShortCdActions()
}

AddIcon specialization=brewmaster help=shortcd checkbox=opt_monk_brewmaster_aoe
{
	BrewmasterDefaultShortCdActions()
}

AddIcon specialization=brewmaster help=main enemies=1
{
	if not InCombat() BrewmasterPrecombatMainActions()
	BrewmasterDefaultMainActions()
}

AddIcon specialization=brewmaster help=aoe checkbox=opt_monk_brewmaster_aoe
{
	if not InCombat() BrewmasterPrecombatMainActions()
	BrewmasterDefaultMainActions()
}

AddIcon specialization=brewmaster help=cd enemies=1 checkbox=!opt_monk_brewmaster_aoe
{
	if not InCombat() BrewmasterPrecombatCdActions()
	BrewmasterDefaultCdActions()
}

AddIcon specialization=brewmaster help=cd checkbox=opt_monk_brewmaster_aoe
{
	if not InCombat() BrewmasterPrecombatCdActions()
	BrewmasterDefaultCdActions()
}

### Required symbols
# arcane_torrent_chi
# berserking
# blackout_kick
# blood_fury_apsp
# breath_of_fire
# breath_of_fire_debuff
# chi_brew
# chi_brew_talent
# chi_burst
# chi_explosion_talent
# chi_explosion_tank
# chi_wave
# dampen_harm
# dampen_harm_buff
# death_note_buff
# diffuse_magic
# diffuse_magic_buff
# draenic_armor_potion
# elusive_brew
# elusive_brew_activated_buff
# elusive_brew_stacks_buff
# expel_harm
# fortifying_brew
# fortifying_brew_buff
# guard
# heavy_stagger_debuff
# invoke_xuen
# invoke_xuen_talent
# jab
# keg_smash
# legacy_of_the_white_tiger
# moderate_stagger_debuff
# nimble_brew
# paralysis
# purifying_brew
# quaking_palm
# rushing_jade_wind
# rushing_jade_wind_talent
# serenity
# serenity_buff
# serenity_talent
# shuffle_buff
# spear_hand_strike
# stance_of_the_sturdy_ox
# tiger_palm
# touch_of_death
# war_stomp
# zen_sphere
# zen_sphere_buff
# zen_sphere_talent
]]
	OvaleScripts:RegisterScript("MONK", name, desc, code, "reference")
end
