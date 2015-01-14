local OVALE, Ovale = ...
local OvaleScripts = Ovale.OvaleScripts

do
	local name = "simulationcraft_mage_frost_t17m"
	local desc = "[6.0] SimulationCraft: Mage_Frost_T17M"
	local code = [[
# Based on SimulationCraft profile "Mage_Frost_T17M".
#	class=mage
#	spec=frost
#	talents=3003122
#	glyphs=icy_veins/splitting_ice/cone_of_cold

Include(ovale_common)
Include(ovale_mage_spells)

AddCheckBox(opt_interrupt L(interrupt) default)
AddCheckBox(opt_potion_intellect ItemName(draenic_intellect_potion) default)
AddCheckBox(opt_time_warp SpellName(time_warp) default)

AddFunction UsePotionIntellect
{
	if CheckBoxOn(opt_potion_intellect) and target.Classification(worldboss) Item(draenic_intellect_potion usable=1)
}

AddFunction InterruptActions
{
	if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.IsInterruptible()
	{
		Spell(counterspell)
		if not target.Classification(worldboss)
		{
			Spell(arcane_torrent_mana)
			if target.InRange(quaking_palm) Spell(quaking_palm)
		}
	}
}

### actions.default

AddFunction FrostDefaultMainActions
{
	#call_action_list,name=water_jet,if=prev.water_jet|debuff.water_jet.remains>0
	if PreviousSpell(pet_water_jet) or target.DebuffRemaining(pet_water_jet_debuff) > 0 FrostWaterJetMainActions()
	#call_action_list,name=crystal_sequence,if=talent.prismatic_crystal.enabled&(cooldown.prismatic_crystal.remains<=gcd.max|pet.prismatic_crystal.active)
	if Talent(prismatic_crystal_talent) and { SpellCooldown(prismatic_crystal) <= GCD() or TotemPresent(prismatic_crystal) } FrostCrystalSequenceMainActions()
	#call_action_list,name=aoe,if=active_enemies>=4
	if Enemies() >= 4 FrostAoeMainActions()
	#call_action_list,name=single_target
	FrostSingleTargetMainActions()
}

AddFunction FrostDefaultShortCdActions
{
	#blink,if=movement.distance>10
	if 0 > 10 Spell(blink)
	#blazing_speed,if=movement.remains>0
	if 0 > 0 Spell(blazing_speed)
	#water_elemental
	if not pet.Present() Spell(water_elemental)
	#call_action_list,name=water_jet,if=prev.water_jet|debuff.water_jet.remains>0
	if PreviousSpell(pet_water_jet) or target.DebuffRemaining(pet_water_jet_debuff) > 0 FrostWaterJetShortCdActions()
	#ice_floes,if=buff.ice_floes.down&(raid_event.movement.distance>0|raid_event.movement.in<action.frostbolt.cast_time)
	if BuffExpires(ice_floes_buff) and { 0 > 0 or 600 < CastTime(frostbolt) } Spell(ice_floes)
	#rune_of_power,if=buff.rune_of_power.remains<cast_time
	if TotemRemaining(rune_of_power) < CastTime(rune_of_power) Spell(rune_of_power)
	#rune_of_power,if=(cooldown.icy_veins.remains<gcd.max&buff.rune_of_power.remains<20)|(cooldown.prismatic_crystal.remains<gcd.max&buff.rune_of_power.remains<10)
	if SpellCooldown(icy_veins) < GCD() and TotemRemaining(rune_of_power) < 20 or SpellCooldown(prismatic_crystal) < GCD() and TotemRemaining(rune_of_power) < 10 Spell(rune_of_power)
	#water_jet,if=time<1&active_enemies<4&!(talent.ice_nova.enabled&talent.prismatic_crystal.enabled)
	if TimeInCombat() < 1 and Enemies() < 4 and not { Talent(ice_nova_talent) and Talent(prismatic_crystal_talent) } and pet.Present() Spell(pet_water_jet)
	#call_action_list,name=crystal_sequence,if=talent.prismatic_crystal.enabled&(cooldown.prismatic_crystal.remains<=gcd.max|pet.prismatic_crystal.active)
	if Talent(prismatic_crystal_talent) and { SpellCooldown(prismatic_crystal) <= GCD() or TotemPresent(prismatic_crystal) } FrostCrystalSequenceShortCdActions()
	#call_action_list,name=aoe,if=active_enemies>=4
	if Enemies() >= 4 FrostAoeShortCdActions()
	#call_action_list,name=single_target
	FrostSingleTargetShortCdActions()
}

AddFunction FrostDefaultCdActions
{
	#counterspell,if=target.debuff.casting.react
	if target.IsInterruptible() InterruptActions()

	unless 0 > 10 and Spell(blink) or not pet.Present() and Spell(water_elemental)
	{
		#time_warp,if=target.health.pct<25|time>5
		if { target.HealthPercent() < 25 or TimeInCombat() > 5 } and CheckBoxOn(opt_time_warp) and DebuffExpires(burst_haste_debuff any=1) Spell(time_warp)
		#call_action_list,name=water_jet,if=prev.water_jet|debuff.water_jet.remains>0
		if PreviousSpell(pet_water_jet) or target.DebuffRemaining(pet_water_jet_debuff) > 0 FrostWaterJetCdActions()
		#mirror_image
		Spell(mirror_image)

		unless BuffExpires(ice_floes_buff) and { 0 > 0 or 600 < CastTime(frostbolt) } and Spell(ice_floes) or TotemRemaining(rune_of_power) < CastTime(rune_of_power) and Spell(rune_of_power) or { SpellCooldown(icy_veins) < GCD() and TotemRemaining(rune_of_power) < 20 or SpellCooldown(prismatic_crystal) < GCD() and TotemRemaining(rune_of_power) < 10 } and Spell(rune_of_power)
		{
			#call_action_list,name=cooldowns,if=time_to_die<24
			if TimeToDie() < 24 FrostCooldownsCdActions()
			#call_action_list,name=crystal_sequence,if=talent.prismatic_crystal.enabled&(cooldown.prismatic_crystal.remains<=gcd.max|pet.prismatic_crystal.active)
			if Talent(prismatic_crystal_talent) and { SpellCooldown(prismatic_crystal) <= GCD() or TotemPresent(prismatic_crystal) } FrostCrystalSequenceCdActions()
			#call_action_list,name=aoe,if=active_enemies>=4
			if Enemies() >= 4 FrostAoeCdActions()
			#call_action_list,name=single_target
			FrostSingleTargetCdActions()
		}
	}
}

### actions.aoe

AddFunction FrostAoeMainActions
{
	#ice_lance,if=talent.frost_bomb.enabled&buff.fingers_of_frost.react&debuff.frost_bomb.up
	if Talent(frost_bomb_talent) and BuffPresent(fingers_of_frost_buff) and target.DebuffPresent(frost_bomb_debuff) Spell(ice_lance)
	#ice_nova
	Spell(ice_nova)
	#blizzard,interrupt_if=cooldown.frozen_orb.up|(talent.frost_bomb.enabled&buff.fingers_of_frost.react=2)
	Spell(blizzard)
}

AddFunction FrostAoeShortCdActions
{
	#frost_bomb,if=remains<action.ice_lance.travel_time&(cooldown.frozen_orb.remains<gcd.max|buff.fingers_of_frost.react=2)
	if target.DebuffRemaining(frost_bomb_debuff) < TravelTime(ice_lance) and { SpellCooldown(frozen_orb) < GCD() or BuffStacks(fingers_of_frost_buff) == 2 } Spell(frost_bomb)
	#frozen_orb
	Spell(frozen_orb)

	unless Talent(frost_bomb_talent) and BuffPresent(fingers_of_frost_buff) and target.DebuffPresent(frost_bomb_debuff) and Spell(ice_lance)
	{
		#comet_storm
		Spell(comet_storm)
	}
}

AddFunction FrostAoeCdActions
{
	#call_action_list,name=cooldowns
	FrostCooldownsCdActions()
}

### actions.cooldowns

AddFunction FrostCooldownsCdActions
{
	#icy_veins
	Spell(icy_veins)
	#blood_fury
	Spell(blood_fury_sp)
	#berserking
	Spell(berserking)
	#arcane_torrent
	Spell(arcane_torrent_mana)
	#potion,name=draenic_intellect,if=buff.bloodlust.up|buff.icy_veins.up
	if BuffPresent(burst_haste_buff any=1) or BuffPresent(icy_veins_buff) UsePotionIntellect()
}

### actions.crystal_sequence

AddFunction FrostCrystalSequenceMainActions
{
	#ice_lance,if=buff.fingers_of_frost.react=2|(buff.fingers_of_frost.react&active_dot.frozen_orb>=1)
	if BuffStacks(fingers_of_frost_buff) == 2 or BuffPresent(fingers_of_frost_buff) and DebuffCountOnAny(frozen_orb_debuff) >= 1 Spell(ice_lance)
	#ice_nova,if=charges=2
	if Charges(ice_nova) == 2 Spell(ice_nova)
	#frostfire_bolt,if=buff.brain_freeze.react
	if BuffPresent(brain_freeze_buff) Spell(frostfire_bolt)
	#ice_lance,if=buff.fingers_of_frost.react
	if BuffPresent(fingers_of_frost_buff) Spell(ice_lance)
	#ice_nova
	Spell(ice_nova)
	#blizzard,interrupt_if=cooldown.frozen_orb.up|(talent.frost_bomb.enabled&buff.fingers_of_frost.react=2),if=active_enemies>=5
	if Enemies() >= 5 Spell(blizzard)
	#frostbolt
	Spell(frostbolt)
}

AddFunction FrostCrystalSequenceShortCdActions
{
	#frost_bomb,if=active_enemies=1&current_target!=prismatic_crystal&remains<10
	if Enemies() == 1 and not target.Name(prismatic_crystal) and target.DebuffRemaining(frost_bomb_debuff) < 10 Spell(frost_bomb)
	#frozen_orb
	Spell(frozen_orb)
	#prismatic_crystal
	Spell(prismatic_crystal)
	#frost_bomb,if=talent.prismatic_crystal.enabled&current_target=prismatic_crystal&active_enemies>1&!ticking
	if Talent(prismatic_crystal_talent) and target.Name(prismatic_crystal) and Enemies() > 1 and not target.DebuffPresent(frost_bomb_debuff) Spell(frost_bomb)
}

AddFunction FrostCrystalSequenceCdActions
{
	unless Enemies() == 1 and not target.Name(prismatic_crystal) and target.DebuffRemaining(frost_bomb_debuff) < 10 and Spell(frost_bomb) or Spell(frozen_orb)
	{
		#call_action_list,name=cooldowns
		FrostCooldownsCdActions()
	}
}

### actions.init_water_jet

AddFunction FrostInitWaterJetMainActions
{
	#ice_lance,if=buff.fingers_of_frost.react&pet.water_elemental.cooldown.water_jet.up
	if BuffPresent(fingers_of_frost_buff) and not SpellCooldown(pet_water_jet) > 0 Spell(ice_lance)
	#frostbolt
	Spell(frostbolt)
}

AddFunction FrostInitWaterJetShortCdActions
{
	#frost_bomb,if=remains<3.6
	if target.DebuffRemaining(frost_bomb_debuff) < 3.6 Spell(frost_bomb)

	unless BuffPresent(fingers_of_frost_buff) and not SpellCooldown(pet_water_jet) > 0 and Spell(ice_lance)
	{
		#water_jet,if=prev_gcd.frostbolt
		if PreviousGCDSpell(frostbolt) and pet.Present() Spell(pet_water_jet)
	}
}

### actions.precombat

AddFunction FrostPrecombatMainActions
{
	#flask,type=greater_draenic_intellect_flask
	#food,type=calamari_crepes
	#arcane_brilliance
	if BuffExpires(critical_strike_buff any=1) or BuffExpires(spell_power_multiplier_buff any=1) Spell(arcane_brilliance)
	#frostbolt
	Spell(frostbolt)
}

AddFunction FrostPrecombatShortCdActions
{
	unless { BuffExpires(critical_strike_buff any=1) or BuffExpires(spell_power_multiplier_buff any=1) } and Spell(arcane_brilliance)
	{
		#water_elemental
		if not pet.Present() Spell(water_elemental)
		#snapshot_stats
		#rune_of_power,if=buff.rune_of_power.remains<150
		if TotemRemaining(rune_of_power) < 150 Spell(rune_of_power)
	}
}

AddFunction FrostPrecombatCdActions
{
	unless { BuffExpires(critical_strike_buff any=1) or BuffExpires(spell_power_multiplier_buff any=1) } and Spell(arcane_brilliance) or not pet.Present() and Spell(water_elemental) or TotemRemaining(rune_of_power) < 150 and Spell(rune_of_power)
	{
		#mirror_image
		Spell(mirror_image)
		#potion,name=draenic_intellect
		UsePotionIntellect()
	}
}

### actions.single_target

AddFunction FrostSingleTargetMainActions
{
	#ice_lance,if=buff.fingers_of_frost.react&buff.fingers_of_frost.remains<action.frostbolt.execute_time
	if BuffPresent(fingers_of_frost_buff) and BuffRemaining(fingers_of_frost_buff) < ExecuteTime(frostbolt) Spell(ice_lance)
	#frostfire_bolt,if=buff.brain_freeze.react&buff.brain_freeze.remains<action.frostbolt.execute_time
	if BuffPresent(brain_freeze_buff) and BuffRemaining(brain_freeze_buff) < ExecuteTime(frostbolt) Spell(frostfire_bolt)
	#ice_nova,if=time_to_die<10|(charges=2&(!talent.prismatic_crystal.enabled|!cooldown.prismatic_crystal.up))
	if TimeToDie() < 10 or Charges(ice_nova) == 2 and { not Talent(prismatic_crystal_talent) or not { not SpellCooldown(prismatic_crystal) > 0 } } Spell(ice_nova)
	#ice_lance,if=buff.fingers_of_frost.react=2|(buff.fingers_of_frost.react&dot.frozen_orb.ticking)
	if BuffStacks(fingers_of_frost_buff) == 2 or BuffPresent(fingers_of_frost_buff) and SpellCooldown(frozen_orb) > SpellCooldownDuration(frozen_orb) - 10 Spell(ice_lance)
	#ice_nova,if=(!talent.prismatic_crystal.enabled|(charges=1&cooldown.prismatic_crystal.remains>recharge_time&buff.incanters_flow.stack>3))&(buff.icy_veins.up|(charges=1&cooldown.icy_veins.remains>recharge_time))
	if { not Talent(prismatic_crystal_talent) or Charges(ice_nova) == 1 and SpellCooldown(prismatic_crystal) > SpellChargeCooldown(ice_nova) and BuffStacks(incanters_flow_buff) > 3 } and { BuffPresent(icy_veins_buff) or Charges(ice_nova) == 1 and SpellCooldown(icy_veins) > SpellChargeCooldown(ice_nova) } Spell(ice_nova)
	#frostfire_bolt,if=buff.brain_freeze.react
	if BuffPresent(brain_freeze_buff) Spell(frostfire_bolt)
	#ice_lance,if=set_bonus.tier17_4pc&talent.thermal_void.enabled&talent.mirror_image.enabled&dot.frozen_orb.ticking
	if ArmorSetBonus(T17 4) and Talent(thermal_void_talent) and Talent(mirror_image_talent) and SpellCooldown(frozen_orb) > SpellCooldownDuration(frozen_orb) - 10 Spell(ice_lance)
	#ice_lance,if=talent.frost_bomb.enabled&buff.fingers_of_frost.react&debuff.frost_bomb.remains>travel_time&(!talent.thermal_void.enabled|cooldown.icy_veins.remains>8)
	if Talent(frost_bomb_talent) and BuffPresent(fingers_of_frost_buff) and target.DebuffRemaining(frost_bomb_debuff) > TravelTime(ice_lance) and { not Talent(thermal_void_talent) or SpellCooldown(icy_veins) > 8 } Spell(ice_lance)
	#frostbolt,if=set_bonus.tier17_2pc&buff.ice_shard.up&!(talent.thermal_void.enabled&buff.icy_veins.up&buff.icy_veins.remains<10)
	if ArmorSetBonus(T17 2) and BuffPresent(ice_shard_buff) and not { Talent(thermal_void_talent) and BuffPresent(icy_veins_buff) and BuffRemaining(icy_veins_buff) < 10 } Spell(frostbolt)
	#ice_lance,if=!talent.frost_bomb.enabled&buff.fingers_of_frost.react&(!talent.thermal_void.enabled|cooldown.icy_veins.remains>8)
	if not Talent(frost_bomb_talent) and BuffPresent(fingers_of_frost_buff) and { not Talent(thermal_void_talent) or SpellCooldown(icy_veins) > 8 } Spell(ice_lance)
	#call_action_list,name=init_water_jet,if=pet.water_elemental.cooldown.water_jet.remains<=gcd.max*(buff.fingers_of_frost.react+talent.frost_bomb.enabled)&!dot.frozen_orb.ticking
	if SpellCooldown(pet_water_jet) <= GCD() * { BuffStacks(fingers_of_frost_buff) + TalentPoints(frost_bomb_talent) } and not SpellCooldown(frozen_orb) > SpellCooldownDuration(frozen_orb) - 10 FrostInitWaterJetMainActions()
	#frostbolt
	Spell(frostbolt)
	#ice_lance,moving=1
	if Speed() > 0 Spell(ice_lance)
}

AddFunction FrostSingleTargetShortCdActions
{
	unless BuffPresent(fingers_of_frost_buff) and BuffRemaining(fingers_of_frost_buff) < ExecuteTime(frostbolt) and Spell(ice_lance) or BuffPresent(brain_freeze_buff) and BuffRemaining(brain_freeze_buff) < ExecuteTime(frostbolt) and Spell(frostfire_bolt)
	{
		#frost_bomb,if=!talent.prismatic_crystal.enabled&cooldown.frozen_orb.remains<gcd.max&debuff.frost_bomb.remains<10
		if not Talent(prismatic_crystal_talent) and SpellCooldown(frozen_orb) < GCD() and target.DebuffRemaining(frost_bomb_debuff) < 10 Spell(frost_bomb)
		#frozen_orb,if=!talent.prismatic_crystal.enabled&buff.fingers_of_frost.stack<2&cooldown.icy_veins.remains>45
		if not Talent(prismatic_crystal_talent) and BuffStacks(fingers_of_frost_buff) < 2 and SpellCooldown(icy_veins) > 45 Spell(frozen_orb)
		#frost_bomb,if=remains<action.ice_lance.travel_time&(buff.fingers_of_frost.react=2|(buff.fingers_of_frost.react&(talent.thermal_void.enabled|buff.fingers_of_frost.remains<gcd.max*2)))
		if target.DebuffRemaining(frost_bomb_debuff) < TravelTime(ice_lance) and { BuffStacks(fingers_of_frost_buff) == 2 or BuffPresent(fingers_of_frost_buff) and { Talent(thermal_void_talent) or BuffRemaining(fingers_of_frost_buff) < GCD() * 2 } } Spell(frost_bomb)

		unless { TimeToDie() < 10 or Charges(ice_nova) == 2 and { not Talent(prismatic_crystal_talent) or not { not SpellCooldown(prismatic_crystal) > 0 } } } and Spell(ice_nova) or { BuffStacks(fingers_of_frost_buff) == 2 or BuffPresent(fingers_of_frost_buff) and SpellCooldown(frozen_orb) > SpellCooldownDuration(frozen_orb) - 10 } and Spell(ice_lance)
		{
			#comet_storm
			Spell(comet_storm)

			unless { not Talent(prismatic_crystal_talent) or Charges(ice_nova) == 1 and SpellCooldown(prismatic_crystal) > SpellChargeCooldown(ice_nova) and BuffStacks(incanters_flow_buff) > 3 } and { BuffPresent(icy_veins_buff) or Charges(ice_nova) == 1 and SpellCooldown(icy_veins) > SpellChargeCooldown(ice_nova) } and Spell(ice_nova) or BuffPresent(brain_freeze_buff) and Spell(frostfire_bolt) or ArmorSetBonus(T17 4) and Talent(thermal_void_talent) and Talent(mirror_image_talent) and SpellCooldown(frozen_orb) > SpellCooldownDuration(frozen_orb) - 10 and Spell(ice_lance) or Talent(frost_bomb_talent) and BuffPresent(fingers_of_frost_buff) and target.DebuffRemaining(frost_bomb_debuff) > TravelTime(ice_lance) and { not Talent(thermal_void_talent) or SpellCooldown(icy_veins) > 8 } and Spell(ice_lance) or ArmorSetBonus(T17 2) and BuffPresent(ice_shard_buff) and not { Talent(thermal_void_talent) and BuffPresent(icy_veins_buff) and BuffRemaining(icy_veins_buff) < 10 } and Spell(frostbolt) or not Talent(frost_bomb_talent) and BuffPresent(fingers_of_frost_buff) and { not Talent(thermal_void_talent) or SpellCooldown(icy_veins) > 8 } and Spell(ice_lance)
			{
				#call_action_list,name=init_water_jet,if=pet.water_elemental.cooldown.water_jet.remains<=gcd.max*(buff.fingers_of_frost.react+talent.frost_bomb.enabled)&!dot.frozen_orb.ticking
				if SpellCooldown(pet_water_jet) <= GCD() * { BuffStacks(fingers_of_frost_buff) + TalentPoints(frost_bomb_talent) } and not SpellCooldown(frozen_orb) > SpellCooldownDuration(frozen_orb) - 10 FrostInitWaterJetShortCdActions()
			}
		}
	}
}

AddFunction FrostSingleTargetCdActions
{
	#call_action_list,name=cooldowns,if=!talent.prismatic_crystal.enabled|cooldown.prismatic_crystal.remains>15
	if not Talent(prismatic_crystal_talent) or SpellCooldown(prismatic_crystal) > 15 FrostCooldownsCdActions()
}

### actions.water_jet

AddFunction FrostWaterJetMainActions
{
	#frostbolt,if=prev.water_jet
	if PreviousSpell(pet_water_jet) Spell(frostbolt)
	#ice_lance,if=buff.fingers_of_frost.react=2&action.frostbolt.in_flight
	if BuffStacks(fingers_of_frost_buff) == 2 and InFlightToTarget(frostbolt) Spell(ice_lance)
	#frostbolt,if=debuff.water_jet.remains>cast_time+travel_time
	if target.DebuffRemaining(pet_water_jet_debuff) > CastTime(frostbolt) + TravelTime(frostbolt) Spell(frostbolt)
	#call_action_list,name=single_target
	FrostSingleTargetMainActions()
}

AddFunction FrostWaterJetShortCdActions
{
	unless PreviousSpell(pet_water_jet) and Spell(frostbolt) or BuffStacks(fingers_of_frost_buff) == 2 and InFlightToTarget(frostbolt) and Spell(ice_lance) or target.DebuffRemaining(pet_water_jet_debuff) > CastTime(frostbolt) + TravelTime(frostbolt) and Spell(frostbolt)
	{
		#call_action_list,name=single_target
		FrostSingleTargetShortCdActions()
	}
}

AddFunction FrostWaterJetCdActions
{
	unless PreviousSpell(pet_water_jet) and Spell(frostbolt) or BuffStacks(fingers_of_frost_buff) == 2 and InFlightToTarget(frostbolt) and Spell(ice_lance) or target.DebuffRemaining(pet_water_jet_debuff) > CastTime(frostbolt) + TravelTime(frostbolt) and Spell(frostbolt)
	{
		#call_action_list,name=single_target
		FrostSingleTargetCdActions()
	}
}

### Frost icons.
AddCheckBox(opt_mage_frost_aoe L(AOE) specialization=frost default)

AddIcon specialization=frost help=shortcd enemies=1 checkbox=!opt_mage_frost_aoe
{
	if not InCombat() FrostPrecombatShortCdActions()
	FrostDefaultShortCdActions()
}

AddIcon specialization=frost help=shortcd checkbox=opt_mage_frost_aoe
{
	if not InCombat() FrostPrecombatShortCdActions()
	FrostDefaultShortCdActions()
}

AddIcon specialization=frost help=main enemies=1
{
	if not InCombat() FrostPrecombatMainActions()
	FrostDefaultMainActions()
}

AddIcon specialization=frost help=aoe checkbox=opt_mage_frost_aoe
{
	if not InCombat() FrostPrecombatMainActions()
	FrostDefaultMainActions()
}

AddIcon specialization=frost help=cd enemies=1 checkbox=!opt_mage_frost_aoe
{
	if not InCombat() FrostPrecombatCdActions()
	FrostDefaultCdActions()
}

AddIcon specialization=frost help=cd checkbox=opt_mage_frost_aoe
{
	if not InCombat() FrostPrecombatCdActions()
	FrostDefaultCdActions()
}

### Required symbols
# arcane_brilliance
# arcane_torrent_mana
# berserking
# blazing_speed
# blink
# blizzard
# blood_fury_sp
# brain_freeze_buff
# comet_storm
# counterspell
# draenic_intellect_potion
# fingers_of_frost_buff
# frost_bomb
# frost_bomb_debuff
# frost_bomb_talent
# frostbolt
# frostfire_bolt
# frozen_orb
# frozen_orb_debuff
# ice_floes
# ice_floes_buff
# ice_lance
# ice_nova
# ice_nova_talent
# ice_shard_buff
# icy_veins
# icy_veins_buff
# incanters_flow_buff
# mirror_image
# mirror_image_talent
# pet_water_jet
# pet_water_jet_debuff
# prismatic_crystal
# prismatic_crystal_talent
# quaking_palm
# rune_of_power
# thermal_void_talent
# time_warp
# water_elemental
]]
	OvaleScripts:RegisterScript("MAGE", name, desc, code, "reference")
end
