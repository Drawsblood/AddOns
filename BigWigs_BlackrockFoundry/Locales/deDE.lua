local L = BigWigs:NewBossLocale("Gruul", "deDE")
if not L then return end
if L then
L["first_ability"] = "Überkopfschlag oder Versteinerndes Schmettern" -- Needs review

end

L = BigWigs:NewBossLocale("Oregorger", "deDE")
if L then
L["roll_message"] = "Rollen %d - %d Erz verbleibend!" -- Needs review

end

L = BigWigs:NewBossLocale("The Blast Furnace", "deDE")
if L then
L["bombs_dropped"] = "Bomben fallengelassen! (%d)" -- Needs review
L["bombs_dropped_p2"] = "Ingenieur getötet, Bomben fallengelassen!" -- Needs review
L["custom_off_firecaller_marker"] = "Feuerrufer markieren" -- Needs review
L["custom_off_firecaller_marker_desc"] = [=[Markiere Feuerrufer mit {rt7}{rt6}, benötigt Leiter oder Assistent.
|cFFFF0000Nur eine Person im Raid sollte diese Option aktiviert haben, um Markierungskonflikte zu verhindern.|r
|cFFADFF2FTIPP: Wenn der Raid sich dafür entschieden hat, dass du diese Option aktivierst ist der schnellste Weg mit der Maus über die Mobs zu fahren um sie zu markieren.|r]=] -- Needs review
L["custom_on_shieldsdown_marker"] = "durchbrochene Schilde markieren" -- Needs review
L["custom_on_shieldsdown_marker_desc"] = "Markiert eine verwundbare Urelementaristin mit {rt8}, benötigt Leiter- oder Assistentenrechte." -- Needs review
L["engineer"] = "Neue Schmelzofeningenieure" -- Needs review
L["engineer_desc"] = "Während Phase 1 spawnen wiederholt 2 Schmelzofeningenieure, einer auf jeder Seite des Raumes." -- Needs review
L["firecaller"] = "Neue Feuerrufer" -- Needs review
L["firecaller_desc"] = "Während Phase 2 kommen wiederholt 2 Feuerrufer hinzu, einer auf jeder Seite des Raumes." -- Needs review
L["guard"] = "Wachposten spawnt" -- Needs review
L["guard_desc"] = "Während Phase 1 kommen wiederholt 2 Wachposten, einer auf jeder Seite des Raumes hinzu. Während Phase 2 erscheint wiederholt ein Wachposten am Eingang des Raumes." -- Needs review
L["heat_increased_message"] = "Hitze erhöht! Flammenzunge alle %s Sek."
L["operator"] = "Neue Gebläsearbeiter" -- Needs review
L["operator_desc"] = "Während Phase 1 kommen wiederholt 2 Gebläsearbeiter hinzu, einer auf jeder Seite des Raumes." -- Needs review

end

L = BigWigs:NewBossLocale("Flamebender Ka'graz", "deDE")
if L then
L["custom_off_wolves_marker"] = "Glutwölfe markieren" -- Needs review
L["custom_off_wolves_marker_desc"] = "Markiert Glutwölfe mit {rt3}{rt4}{rt5}{rt6}, benötigt Leiter oder Assistent." -- Needs review
L["molten_torrent_self"] = "Geschmolzene Sturzflut auf Dir"
L["molten_torrent_self_bar"] = "Du explodierst!"
L["molten_torrent_self_desc"] = "Spezieller Countdown für die Geschmolzene Sturzflut auf Dir."

end

L = BigWigs:NewBossLocale("Kromog", "deDE")
if L then
L["custom_off_hands_marker"] = "Klammernde Erde der Tanks markieren" -- Needs review
L["custom_off_hands_marker_desc"] = "Markiere die klammernde Erde, die die Tanks greift, mit {rt7}{rt8}, benötigt Leiter oder Assistent." -- Needs review
L["destroy_pillars"] = "Säulen zerstören" -- Needs review
L["prox"] = "Näheanzeige für Tanks" -- Needs review
L["prox_desc"] = "Öffne eine Näheanzeige, die andere Tanks im Abstand von maximal 15 Metern anzeigt, die Anzeige hilft dir mit der Fäuste aus Stein Fähigkeit umzugehen." -- Needs review

end

L = BigWigs:NewBossLocale("Beastlord Darmac", "deDE")
if L then
L["custom_off_conflag_marker"] = "Großbrand markieren"
L["custom_off_conflag_marker_desc"] = [=[Markiert die Ziele von Großbrand mit {rt1}{rt2}{rt3}, benötigt Leiter oder Assistent.
|cFFFF0000Um Konflikte beim Markieren zu vermeiden, sollte lediglich 1 Person im Raid diese Option aktivieren.|r]=]
L["custom_off_pinned_marker"] = "Festnageln markieren"
L["custom_off_pinned_marker_desc"] = [=[Markiert die festnagelnden Speere mit {rt8}{rt7}{rt6}{rt5}{rt4}, benötigt Leiter oder Assistent.
|cFFFF0000Um Konflikte beim Markieren zu vermeiden, sollte lediglich 1 Person im Raid diese Option aktivieren.|r
|cFFADFF2FTIPP: Wenn Du diese Option aktivierst, ist die schnellste Methode zum Markieren das zügige Bewegen des Mauszeigers über die Speere.|r]=]
L["next_mount"] = "Aufsitzen bald!"

end

L = BigWigs:NewBossLocale("Operator Thogar", "deDE")
if L then
L["adds_train"] = "Zug mit Adds"
L["big_add_train"] = "Zug mit großem Add"
L["cannon_train"] = "Kanonen-Zug"
L["custom_on_firemender_marker"] = "Feuerheilerin der Grom'kar markieren" -- Needs review
L["custom_on_firemender_marker_desc"] = "Markiert Feuerheilerin der Grom'kar mit {rt7}, benötigt Leiter oder Assistent." -- Needs review
L["custom_on_manatarms_marker"] = "Waffenträger der Grom'kar markieren" -- Needs review
L["custom_on_manatarms_marker_desc"] = "Markiert Waffenträger der Grom'kar mit {rt8}, benötigt Leiter oder Assistent." -- Needs review
L["deforester"] = "Waldzerstörer" -- Needs review
L["lane"] = "Gleis %s: %s"
L["random"] = "Zufällige Züge"
L["train"] = "Zug"
L["trains"] = "Zugwarnungen"
L["trains_desc"] = "Zeigt Timer und Warnungen für die auf den Gleisen ankommenden Züge an. Die Gleise sind vom Boss zum Eingang folgendermaßen durchnummeriert: Boss 1 2 3 4 Eingang."
L["train_you"] = "Zug auf deinem Gleis! (%d)" -- Needs review

end

L = BigWigs:NewBossLocale("The Iron Maidens", "deDE")
if L then
L["custom_off_heartseeker_marker"] = "Bluttriefender Herzsucher markieren"
L["custom_off_heartseeker_marker_desc"] = "Markiert die Ziele von Bluttriefender Herzsucher mit {rt1}{rt2}{rt3}, benötigt Leiter oder Assistent."
L["power_message"] = "%d Eiserne Wut!"
L["ship"] = "Springe aufs Schiff"
L["ship_trigger"] = "bereitet sich darauf vor, die Hauptkanone des Schlachtschiffs zu bemannen!"

end

L = BigWigs:NewBossLocale("Blackhand", "deDE")
if L then
L["custom_off_markedfordeath_marker"] = "Todesurteil markieren"
L["custom_off_markedfordeath_marker_desc"] = "Markiert die Ziele von Todesurteil mit {rt1}{rt2}{rt3}, benötigt Leiter- oder Assistentenrechte." -- Needs review
L["custom_off_massivesmash_marker"] = "Massives vernichtendes Schmettern markieren" -- Needs review
L["custom_off_massivesmash_marker_desc"] = "Markiert den Tank, welcher von Massives vernichtendes Schmettern getroffen wird mit {rt6}, benötigt Leiter- oder Assistentenrechte." -- Needs review

end

L = BigWigs:NewBossLocale("Blackrock Foundry Trash", "deDE")
if L then
L["beasttender"] = "Bestienhüter der Donnerfürsten"
L["brute"] = "Schläger der Erzraffinerie"
L["earthbinder"] = "Eiserner Erdbinder" -- Needs review
L["enforcer"] = "Vollstrecker des Schwarzfelsklans"
L["furnace"] = "Schmelzofenabzug"
L["furnace_msg1"] = "Recht heiß, oder?" -- Needs review
L["furnace_msg2"] = "Zeit zum Grillen!" -- Needs review
L["furnace_msg3"] = "Das kann nicht gesund sein..." -- Needs review
L["gnasher"] = "Dunkelplattenknirscher"
L["gronnling"] = "Gronnlingarbeiter" -- Needs review
L["guardian"] = "Werkstattwächter"
L["hauler"] = "Ogronschlepper"
L["mistress"] = "Schmiedemeisterin Flammenhand"
L["taskmaster"] = "Eiserner Zuchtmeister"

end

