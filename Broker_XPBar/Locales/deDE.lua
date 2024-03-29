﻿--[[ *******************************************************************
Project                 : Broker_XPBar
Description             : German translation file (deDE)
Author                  : tritium
Translator              : tritium
Revision                : $Rev: 1 $
********************************************************************* ]]

local ADDON = ...

local L = LibStub:GetLibrary("AceLocale-3.0"):NewLocale(ADDON, "deDE")
if not L then return end

L["%s/%s (%3.0f%%) %d to go (%3.0f%% rested)"] = "%s/%s (%3.0f%%) %d übrig (%3.0f%% gerastet)"
L["%s: %s/%s (%3.2f%%) Currently %s with %d to go"] = "%s:%s/%s (%3.2f%%) Aktuell %s mit %d übrig"
L["/brokerxpbar arg"] = "/brokerxpbar arg"
L["/bxp arg"] = "/bxp arg"
L["_S_thousand_separator"] = "."
L["_S_decimal_separator"] = ","
L["Abbrev_billion"] = "mrd"
L["Abbrev_Faction"] = "F"
L["Abbrev_kilo"] = "k"
L["Abbrev_Kills to Level"] = "GBL"
L["Abbrev_Kills to Standing"] = "GBR"
L["Abbrev_million"] = "mio"
L["Abbrev_Quest Complete"] = "EQ"
L["Abbrev_Quest Incomplete"] = "OQ"
L["Abbrev_Rested"] = "R"
L["Abbrev_Standing"] = "R"
L["Abbrev_Time to Level"] = "ZBS"
L["Abbrev_Time to Standing"] = "ZBR"
L["Abbreviations"] = "Abkürzungen"
L["Args:"] = "Argumente:"
L["Attach bars to the inside of the frame."] = "Leisten an der Frame-Innenseite anheften."
L["Attach to Side"] = "Anheften an Seite"
L["Auto-switch watched faction on reputation gain."] = "Automatischer Wechsel der beobachteten Fraktion bei Rufgewinn."
L["Auto-switch watched faction on reputation gains/losses."] = "Beobachtete Fraktion folgt automatisch Rufänderungen."
L["Auto-switch watched faction on reputation loss."] = "Automatischer Wechsel der beobachteten Fraktion bei Rufverlust."
L["Bar Properties"] = "Leisteneigenschaften"
L["Bar Text"] = "Leistenbeschriftung"
L["Bar Texture"] = "Textur"
L["Blizzard Bars"] = "Blizzard-Leisten"
L["Blizzard Reputation Colors"] = "Blizzard-Ruffarben"
L["Bottom"] = "Unten"
L["Broker Label"] = "Broker Text"
L["Click"] = "Klick"
L["Click to activate the frame selector. (Left-Click to select frame, Right-Click do deactivate selector)"] = "Klicken um Frame-Auswahl zu aktivieren. (Links-Klick zum Frame wählen, Rechts-Klick für Abbruch)"
L["Code"] = "Code"
L["Colors"] = "Farben"
L["Completed quest Rep"] = "Ruf erfüllter Quests"
L["Completed Quest Reputation"] = "Ruf erfüllter Quests"
L["Completed quest XP"] = "XP erfüllter Quests"
L["Completed Quest XP"] = "XP erfüllter Quests"
L["Copy"] = "Kopieren"
L["Copy fixed template to selected custom text."] = "Kopiere Vorlage in ausgewählten Freitext."
L["Current reputation"] = "Aktueller Ruf"
L["Current XP"] = "Aktuelle XP"
L["Currently no faction tracked."] = "Derzeit keine Fraktion gewählt."
L["Custom code instructions"] = [[|cffffd100Anleitung zur Programmierung des Freitextes:|r
Der Code muss mit einer return-Anweisung enden, die eine Zeichenkette zurückliefert.

|cffffd100Funktionen:|r
|cffe54100GetValue|r(|cff04adcbid|r [, |cff04adcbmaxLength|r]) - Hole Wert der spezifizierten |cff04adcbid|r. Nur wenn |cff04adcbid|r |cff00ff00"Faction"|r ist, spezifiziert |cff04adcbmaxLength|r ab welcher Länge der in den Optionen gespeicherte Kurzname verwendet werden soll.
|cffe54100Check|r(|cff04adcbid|r) - Liefert |cffeda55fvalid|r, |cffeda55ftext|r. Boolsches |cffeda55fvalid|r ist falsch (false), wenn Test fehlschlägt. Der |cffeda55ftext|r repräsentiert eine passende Nachricht, wenn |cffeda55fvalid|r falsch ist. Nur |cff00ff00"XP"|r (falsch auf max. Level) und |cff00ff00"Reputation"|r (falsch bei max. Ruf oder wenn keine Fraktion beobachtet) sind gültige |cff04adcbid|r.
|cffe54100FormatNumber|r(|cff04adcbvalue|r, |cff04adcbuseAbbrev|r) - Liefert formatierte Zeichenkette von |cff04adcbvalue|r unter Verwendung der Einstellungen für Zahlen. Setze |cff04adcbuseAbbrev|r für abgekürzte Zahlendarstellung.
|cffe54100Percentage|r(|cff04adcbvalue|r, |cff04adcbminValue|r, |cff04adcbmaxValue|r) - Konvertiert |cff04adcbvalue|r zu ganzahligem Prozentwert im Wertebereich |cff04adcbminValue|r..|cff04adcbmaxValue|r.
|cffe54100GetColor|r(|cff04adcbvalue|r, |cff04adcbfrom|r, |cff04adcbto|r) - Liefert Farbe für |cff04adcbvalue|r im Bereich |cff04adcbfrom|r (rot)..|cff04adcbto|r (grün).
|cffe54100GetColorById|r(|cff04adcbid|r) - Liefert Farbe, die dem Fortschritt des Wertes |cff04adcbid|r entspricht.
|cffe54100Colorize|r(|cff04adcbcolor|r, |cff04adcbtext|r) - Färbt |cff04adcbtext|r mit |cff04adcbcolor|r. Die Farbe ist als Hex-Wert ('ffffff') oder RGB ({r=1, g=1, b=1}) anzugeben.
|cffe54100GetDescription|r(|cff04adcbid|r, |cff04adcbshort|r) - Liefert lokalisierte Beschreibung der spezifizierten |cff04adcbid|r. Wenn |cff04adcbshort|r gesetzt ist, wird eine Kurzform geliefert.
|cffe54100HasWatchedFaction|r() - Liefert wahr (true), wenn gegenwärtig eine Fraktion beobachtet wird.
|cffe54100AtMax|r(|cff04adcbid|r) - Liefert wahr, wenn |cff04adcbid|r den max. Wert erreicht hat. Nur sinnvoll für |cff04adcbid|r: |cff00ff00"XP"|r, |cff00ff00"Rested"|r, |cff00ff00"Level"|r, |cff00ff00"Reputation"|r, |cff00ff00"Standing"|r

|cffffd100IDs und ihre Rückgabwewerte für|r |cffe54100GetValue|r(|cff04adcbid|r)|cffffd100:|r
|cff00ff00"XP"|r - (Zahl) - Aktuelle Erfahrungspunkte.
|cff00ff00"MaxXP"|r - (Zahl) - Maximale Erfahrungspunkte auf aktuellem Level.
|cff00ff00"QuestCompleteXP"|r - (Zahl) - Erfahrung in abgeschlossenen Quests.
|cff00ff00"QuestIncompleteXP"|r - (Zahl) - Erfahrung in offenen Quests.
|cff00ff00"TimeToLevel"|r - (Zeichenkette) - Zeit bis Level-Aufstieg.
|cff00ff00"KillsToLevel"|r - (Zahl) - Anzahl besiegter Gegner bis Level-Aufstieg.
|cff00ff00"XPPerHour"|r - (Zahl) - Erfahrungspunkte pro Stunde.
|cff00ff00"KillsPerHour"|r - (Zahl) - Besiegte Gegner pro Stunde.
|cff00ff00"Rested"|r - (Zahl) - Ruhebonus.
|cff00ff00"Level"|r - (Zahl) - Aktuelles Spieler-Level.
|cff00ff00"Reputation"|r - (Zahl) - Ruf mit aktueller Fraktion.
|cff00ff00"MaxReputation"|r - (Zahl) - Maximaler Ruf mit aktueller Fraktion.
|cff00ff00"QuestCompleteRep"|r - (Zahl) - Ruf in abgeschlossenen Quests.
|cff00ff00"QuestIncompleteRep"|r - (Zahl) - Ruf in offenen Quests.
|cff00ff00"Standing"|r - (Zeichenkette) - Lokalisierte Zeichenkette der aktuellen Rufstufe (z.B. 'Freundlich').
|cff00ff00"Faction"|r - (Zeichenkette) - Lokalisierter Name der aktuell beobachteten Fraktion oder '', wenn keine.
|cff00ff00"TimeToStanding"|r - (Zahl) - Zeit bis zum Erreichen der nächsten Rufstufe.
|cff00ff00"KillsToStanding"|r - (Zahl) - Anzahl zu besiegender Gegener bis zum Erreichen der nächsten Rufstufe.
|cff00ff00"ReputationPerHour"|r - (Zahl) - Ruf pro Stunde.
]]
L["Custom code to modify."] = "Modifizierbarer Programm-Code für Freitext."
L["Custom Text"] = "Freitext"
L["Custom text for configuration."] = "Zu konfigurierender Freitext."
L["Custom Texts"] = "Freitexte"
L["Decimal Places"] = "Dezimalstellen"
L["Don't show the reputation bar at maximum reputation."] = "Rufleiste bei maximalem Ruf verbergen."
L["Don't show the reputation label text at maximum reputation."] = "Broker-Text für Ruf bei max. Ruf verbergen."
L["Don't show the XP bar at maximum level."] = "XP-Leiste auf maximaler Stufe verbergen."
L["Don't show the XP label text at maximum level."] = "Broker-Text für XP auf max. Stufe verbergen."
L["Don't use any texture but use opaque colors for bars."] = "Keine Textur für Leisten verwenden, sondern nur Farben."
L["Experience"] = "Erfahrung"
L["Experience per Hour"] = "Erfahrung pro Stunde"
L["Faction"] = "Fraktion"
L["Faction to set a short name for."] = "Fraktion für die ein Kurzname gesetzt werden soll."
L["Faction Tracking"] = "Fraktion verfolgen"
L["Factions"] = "Fraktionen"
L["Font"] = "Schriftart"
L["Font Size"] = "Schriftgröße"
L["Frame"] = "Frame"
L["Frame to attach to"] = "Anbringen an Frame"
L["General settings for number formatting."] = "Einstellungen zur Formatierung von Zahlen."
L["Hand in completed quests to level up!"] = "Stufenaufstieg bei Abgabe erfüllter Quests!"
L["Hand in completed quests to level up faction!"] = "Rufaufstieg bei Abgabe erfüllter Quests!"
L["help - display this help"] = "help - diese Hilfe anzeigen"
L["Hide Hint"] = "Hinweis verbergen"
L["Hide the usage hint in the tooltip."] = "Bedienhinweise im Tooltip verbergen."
L["If you want more fonts, you should install the addon 'SharedMedia'."] = "Für mehr Schriftarten installiere das Addon 'SharedMedia'"
L["If you want more textures, you should install the addon 'SharedMedia'."] = "Für eine größere Auswahl an Texturen installiere das Addon 'SharedMedia'."
L["Incomplete quest Rep"] = "Ruf offener Quests"
L["Incomplete Quest Reputation"] = "Ruf offener Quests"
L["Incomplete quest XP"] = "XP offener Quests"
L["Incomplete Quest XP"] = "XP offener Quests"
L["Inside"] = "Innen"
L["Inverse Order"] = "Inverse Anordnung"
L["Jostle"] = "Verschieben"
L["Kills per hour"] = "Gegner pro Stunde"
L["Kills per Hour"] = "Gegner pro Stunde"
L["Kills to level"] = "Gegner bis Stufenaufstieg"
L["Kills to Level"] = "Gegner bis Stufenaufstieg"
L["Kills to next Standing"] = "Gegner bis Rufaufstieg"
L["Kills/h"] = "Gegner/h"
L["Left"] = "Links" 
L["Length"] = "Länge"
L["Level"] = "Stufe"
L["Level up!"] = "Stufenaufstieg!"
L["Leveling"] = "Leveln"
L["Lvl"] = "Stufe"
L["Max. Level"] = "Max. Stufe"
L["Max. Rep"] = "Max. Ruf"
L["Max. XP"] = "Max. XP"
L["Max. XP/Rep"] = "Max. XP/Ruf"
L["Maximum Experience"] = "Maximale Erfahrung"
L["Maximum level reached."] = "Maximale Stufe erreicht."
L["Maximum Reputation"] = "Maximaler Ruf"
L["menu - display options menu"] = "menu - Optionsmenü anzeigen"
L["Minimap Button"] = "Minimap Button"
L["Mock Values"] = "Testdaten"
L["Mouse-Over"] = "Mouse-Over"
L["Move Blizzard-frames to avoid overlapping with the bars."] = "Verschiebung der Blizzard-Frames, um Überlappungen mit Leisten zu vermeiden."
L["No custom text selected."] = "Kein Freitext gewählt."
L["No Reputation"] = "Ohne Ruf"
L["No Reputation Bar"] = "Keine Rufleiste"
L["No Reputation Label"] = "Kein Ruftext"
L["No XP"] = "Ohne XP"
L["No XP Bar"] = "Keine XP-Leiste"
L["No XP Label"] = "Kein XP-Text"
L["No template selected."] = "Keine Vorlage gewählt."
L["No Texture"] = "Keine Textur"
L["No watched faction"] = "Keine beobachte Fraktion"
L["None"] = "Nichts"
L["Notification"] = "Benachrichtigung"
L["Notifications"] = "Benachrichtigungen"
L["Numbers"] = "Zahlen"
L["Open option menu."] = "Öffne Optionsmenü"
L["Other Texture"] = "Andere Textur"
L["per Tick"] = "je Markierung"
L["Place the reputation bar before the XP bar."] = "Rufleiste vor XP-Leiste platzieren."
L["Preview"] = "Voransicht"
L["Preview custom text using dummy data."] = "Voransicht des Freitextes mit Testdaten."
L["Quest Complete"] = "Erfüllte Quest(s)"
L["Quest Incomplete"] = "Offene Quest(s)"
L["Refresh"] = "Auffrischen"
L["Refresh bar position."] = "Auffrischen der Anzeige."
L["Rep"] = "Ruf"
L["Rep over XP"] = "Ruf vor XP"
L["Rep per hour"] = "Ruf pro Stunde"
L["Rep/h"] = "Ruf/h"
L["Rep: Custom Bar"] = "Ruf: Freitext (Leiste)"
L["Rep: Custom Label"] = "Ruf: Freitext (Broker)"
L["Rep: Full"] = "Ruf: Voll"
L["Rep: Full (No Color)"] = "Ruf: Voll (Weiß)"
L["Rep: Kills Per Hour"] = "Ruf: Gegner pro Stunde"
L["Rep: Kills To Level"] = "Ruf: Gegner bis Stufe"
L["Rep: Long"] = "Ruf: Lang"
L["Rep: Long (No Color)"] = "Ruf: Lang (Weiß)"
L["Rep: Rep Per Hour"] = "Ruf: Ruf pro Stunde"
L["Rep: Time To Level"] = "Ruf: Zeit bis Stufe"
L["Rep: To Go (Percent)"] = "Ruf: Bis Stufe (Prozent)"
L["Rep: Value (Percent)"] = "Ruf: Wert (Prozent)"
L["Rep: Value/Max"] = "Ruf: Wert/Max"
L["Rep: Value/Max (Percent)"] = "Ruf: Wert/Max (Prozent)"
L["Reputation"] = "Ruf"
L["Reputation Bar Colors"] = "Farben für Rufleiste"
L["Reputation per Hour"] = "Ruf pro Stunde"
L["Rested"] = "Ruhe"
L["Rested XP"] = "Ruhe-XP"
L["Right"] = "Rechts"
L["Right-Click"] = "Rechts-Klick"
L["Select by Mouse"] = "Auswahl per Maus"
L["Select Label Text"] = "Wähle Beschriftung"
L["Select Reputation Text"] = "Wähle Text für Ruf"
L["Select the faction to track."] = "Wähle Fraktion zum beobachten."
L["Select the font of the bar text."] = "Wähle Schriftart für Text auf Leiste."
L["Select the font size of the text."] = "Wähle Schriftgröße für Text auf Leiste."
L["Select the label text for the Broker display."] = [[Wähle Beschriftung für Broker-Anzeige:
|cffffff00None|r - Kein text.
|cffffff00Reputation|r - Zeige gewählten Text für Ruf.
|cffffff00XP|r - Zeige gewählten Text für Erfahrung.
|cffffff00Rep over XP|r - Zeige Text für Ruf. Wenn keine Fraktion beobachtet zeige XP-Text.
|cffffff00XP over Rep|r - Zeige Text für XP. Wenn auf max. Stufe zeige Text für Ruf.]]
L["Select the reputation text for Broker display."] = "Wähle Ruftext für die Broker-Anzeige."
L["Select the side to attach the bars to."] = "Wähle Seite zum Anbringen der Leisten."
L["Select the strata of the bars."] = "Wähle Anzeigeschicht der Leisten."
L["Select the text for reputation bar."] = "Wähle Text für die Rufleiste."
L["Select the text for XP bar."] = "Wähle Text für die Erfahrungsleiste."
L["Select the XP text for Broker display."] = "Wähle XP-Text für die Broker-Anzeige."
L["Select XP Text"] = "Wähle Text für XP"
L["Send current reputation to an open editbox."] = "Fügt aktuellen Ruf in offenes Chat-Eingabefeld ein."
L["Send current XP to an open editbox."] = "Fügt aktuelle XP in offenes Chat-Eingabefeld ein."
L["Separator used between XP and reputation texts."] = "Trennzeichen zwischen XP- und Ruftext, wenn Texte benachbart angezeigt werden."
L["Separators"] = "Trennzeichen"
L["Session kills"] = "Gegner in Sitzung"
L["Session rep"] = "Ruf in Sitzung"
L["Session XP"] = "XP in Sitzung"
L["Set the bar colors."] = "Setzen der Leistenfarben."
L["Set the bar properties."] = "Setzen der Leisteneigenschaften."
L["Set the bar text properties."] = "Setzen der Eigenschaften der Leistentexte."
L["Set the brightness level of the spark."] = "Setzt Helligkeit der Halo."
L["Set the Broker label properties."] = "Setzen der Eigenschaften Broker-Anzeige."
L["Set the color of the completed quest reputation bar."] = "Setzt Farbe für Ruf abgeschlossener Quests."
L["Set the color of the completed quest XP bar."] = "Setzt Farbe für Erfahrung abgeschlossener Quests."
L["Set the color of the incomplete quest reputation bar."] = "Setzt Farbe für Ruf offener Quests."
L["Set the color of the incomplete quest XP bar."] = "Setzt Farbe für Erfahrung offener Quests."
L["Set the color of the reputation bar."] = "Setzt Farbe der Rufleiste."
L["Set the color of the rested bar."] = "Setzt Farbe der Ruheleiste."
L["Set the color of the XP bar."] = "Setzt Farbe der XP-Leiste."
L["Set the display behaviour at maximum level/reputation."] = "Setzen des Anzeigeverhaltens bei max. Stufe/Ruf."
L["Set the empty color of the reputation bar."] = "Setzt Leerfarbe der Rufleiste."
L["Set the empty color of the XP bar."] = "Setzt Leerfarbe der XP-Leiste."
L["Set the frame attachment properties."] = "Konfiguration für die Anbringung der Leisten."
L["Set the length of the bars. If zero bar will adjust to the dimension of the frame it attaches to."] = "Setzt die Länge der Leiste. Wenn null, wird die Länge an Frame angepasst."
L["Set the level up notifications when completed quests allow you to gain a level."] = "Konfiguration von Benachrichtigungen für möglichen Stufenaufstieg durch abgeschlossene Quests."
L["Set the leveling properties."] = "Konfiguration von Einstellungen während des Levelns."
L["Set the number of decimal places when using abbreviations."] = "Setzt Anzahl von Nachkommastellen bei der Verwendung von Abkürzungen."
L["Set the number of ticks shown on the bar."] = "Setzt Anzahl von Markierungen auf der Leiste."
L["Set the thickness of the bars."] = "Setzt die Dicke der XP-Leiste."
L["Set the time frame for dynamic TTL calculation."] = "Setzt Zeitrahmen für Berechnung der Zeit bis Stufenaufstieg."
L["Set the tooltip properties."] = "Konfiguration der Tooltip-Eigenschaften."
L["Set the weight of the time frame vs. the session average for dynamic TTL calculation."] = "Setzt Wichtung von Zeitrahmen zu Session-Durchschnitt für dynamische Berechnung der Zeit bis Stufe."
L["Set the x-Offset of the bars."] = "Setzt den x-Versatz der Leisten."
L["Set the y-Offset of the bars."] = "Setzt den y-Versatz der Leisten."
L["Setup custom texts for bars and label."] = "Konfiguration der Freitexte für Leisten und Broker-Anzeige."
L["Shadow"] = "Schatten"
L["Shift-Click"] = "Umschalt-Klick"
L["Short Name"] = "Kurzname"
L["Short name for selected faction."] = "Kurzname für gewählte Fraktion."
L["Show a notification with configurable output target."] = "Zeige Benachrichtigung mit konfigurierbarem Ausgabeziel."
L["Show a test notification."] = "Zeige Testbenachrichtigung."
L["Show a test Toast notification."] = "Zeige Testbenachrichtigung für Toast."
L["Show a Toast notification."] = "Zeige Toast-Benachrichtigung."
L["Show Bar Text"] = "Zeige Beschriftung"
L["Show Completed Quest Reputation"] = "Zeige Ruf abgeschlossener Quests"
L["Show Completed Quest XP"] = "Zeige XP abgeschlossener Quests"
L["Show Incomplete Quest Reputation"] = "Zeige Ruf offener Quests"
L["Show Incomplete Quest XP"] = "Zeige XP offener Quests"
L["Show Reputation Bar"] = "Zeige Rufleiste"
L["Show reputation of completed quests on the bar."] = "Zeige Ruf abgeschlossener Quests auf Leiste."
L["Show reputation of incomplete quests the bar."] = "Zeige Ruf offener Quests auf Leiste."
L["Show selected text on bar."] = "Zeige ausgewählten Text auf Leiste."
L["Show text only on mouse over bar."] = "Zeige Text nur, wenn sich die Maus über der Leiste befindet."
L["Show the default Blizzard bars."] = "Zeige normale Blizzard-Leisten"
L["Show the minimap button."] = "Zeige den Minimap-Button."
L["Show the reputation bar."] = "Zeige die Rufleiste."
L["Show the XP bar."]  = "Zeige die XP-Leiste."
L["Show XP Bar"] = "Zeige XP-Leiste"
L["Show XP of completed quests on the bar."] = "Zeige XP abgeschlossener Quests auf Leiste."
L["Show XP of incomplete quests on the bar."] = "Zeige XP offener Quests auf Leiste."
L["Side by Side Text"] = "Texte Nebeneinander"
L["Side by Side Separator"] = "Trennzeichen"
L["Spark Intensity"] = "Halointensität"
L["Standing"] = "Rang"
L["Strata"] = "Anzeigeschicht"
L["Switch on Reputation Gain"] = "Wechsel bei Rufgewinn"
L["Switch on Reputation Loss"] = "Wechsel bei Rufverlust"
L["Template Text"] = "Vorlagetext"
L["Test Notification"] = "Teste Benachrichtigung"
L["Test Toast"] = "Teste Toast"
L["Text for both bars is shown in single line centered over both bars."] = "Texte beider Leisten werden nebeneinander und zentriert über beide Leisten angezeigt."
L["Texts to be used as templates for custom texts."] = "Texte, die als Vorlage für Freitexte dienen können."
L["Texture of the bars."] = "Textur der Leisten"
L["The exact name of the frame to attach to."] = "Der exakte Name des Frames an dem die Leisten angehangen werden."
L["Thickness"] = "Dicke"
L["This frame has no global name and cannot be used!"] = "Dieser Frame hat keinen globalen Namen und kann nicht verwendet werden!"
L["Ticks"] = "Markierungen"
L["Time Frame"] = "Zeitrahmen"
L["Time to level"] = "Zeit bis Stufenaufstieg"
L["Time to Level"] = "Zeit bis Stufenaufstieg"
L["Time to Level Rep"] = "Zeit bis Aufstieg Ruf"
L["Time to next Standing"] = "Zeit bis Aufstieg Ruf"
L["To next level"] = "Bis nächste Stufe"
L["To next standing"] = "Bis nächste Rufstufe"
L["Toast Notification"] = "Toast-Benachrichtigung"
L["Toggle shadow display for bars."] = "Aktiviert den Schattenwurf für Leisten."
L["Toggle the use of Blizzard reputation colors."] = "Umschalten auf Blizzard-Ruffarben."
L["Tooltip"] = "Tooltip"
L["Top"] = "Oben" 
L["Usage:"] = "Verwendung:"
L["Use abbreviations to shorten numbers."] = "Abkürzungen für kürzere Nummern verwenden."
L["Use external texture for bar instead of the one provided with the addon."] = "Externe Textur verwenden, anstelle der im Addon enthaltenen."
L["Use mock values for preview."] = "Verwende Testdaten für Voransicht."
L["Use separators for numbers to improve readability."] = "Trennzeichen für verbesserte Lesbarkeit verwenden."
L["Version"] = "Version"
L["version - display version information"] = "version - Versionsinformation anzeigen"
L["Weight"] = "Wichtung"
L["X-Offset"] = "X-Versatz"
L["XP"] = "XP"
L["XP Bar Colors"] = "Farben für Erfahrungsleiste"
L["XP over Rep"] = "XP vor Ruf"
L["XP per hour"] = "XP pro Stunde"
L["XP: Custom Bar"] = "XP: Freitext (Leiste)"
L["XP: Custom Label"] = "XP: Freitext (Broker)"
L["XP: Full"] = "XP: Voll"
L["XP: Full (No Color)"] = "XP: Voll (Weiß)"
L["XP: Kills Per Hour"] = "XP: Gegner pro Stunde"
L["XP: Kills To Level"] = "XP: Gegner bis Stufe"
L["XP: Long"] = "XP: Lang"
L["XP: Long (No Color)"] = "XP: Lang (Weiß)"
L["XP: Time To Level"] = "XP: Zeit bis Stufe"
L["XP: To Go (Percent)"] = "XP: Bis Stufe (Prozent)"
L["XP: Value (Percent)"] = "XP: Wert (Prozent)"
L["XP: Value/Max"] = "XP: Wert/Max"
L["XP: Value/Max (Percent)"] = "XP: Wert/Max (Prozent)"
L["XP: XP Per Hour"] = "XP: XP pro Stunde"
L["XP/h"] = "XP/h"
L["Y-Offset"] = "Y-Versatz"
