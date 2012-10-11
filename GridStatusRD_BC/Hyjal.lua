local zone = "Hyjal Summit"

--en_zone, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon

--Winterchill
GridStatusRaidDebuff:BossName(zone, 10, "Rage Winterchill")
GridStatusRaidDebuff:Debuff(zone, 31249, 11, 5, 5, true) --Ice Bolt

--Aneteron
GridStatusRaidDebuff:BossName(zone, 20, "Anetheron")
GridStatusRaidDebuff:Debuff(zone, 31306, 21, 5, 5) --Carrion Swarm
GridStatusRaidDebuff:Debuff(zone, 31298, 22, 5, 5, true) --Sleep

--Azgalor
GridStatusRaidDebuff:BossName(zone, 30, "Azgalor")
GridStatusRaidDebuff:Debuff(zone, 31347, 31, 5, 5, true) --Doom
GridStatusRaidDebuff:Debuff(zone, 31341, 32, 5, 5, true) --Unquenchable Flames
GridStatusRaidDebuff:Debuff(zone, 31344, 33, 5, 5, true) --Howl of Azgalor

--Achimonde
GridStatusRaidDebuff:BossName(zone, 40, "Archimonde")
GridStatusRaidDebuff:Debuff(zone, 31944, 41, 5, 5, true) --Doomfire
GridStatusRaidDebuff:Debuff(zone, 31972, 42, 5, 5) --Grip

