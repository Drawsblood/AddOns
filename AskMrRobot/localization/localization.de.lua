--check locale
if GetLocale() ~= "deDE" then return end
local _, AskMrRobot = ...
local L = AskMrRobot.L;

-- stat strings for e.g. displaying gem/enchant abbreviations
L.AMR_STAT_SHORT_STRINGS = {
    ["Strength"] = "Stä",
    ["Agility"] = "Bew",
    ["Intellect"] = "Int",
    ["CriticalStrike"] = "Krit",
    ["Haste"] = "Tempo",
    ["Mastery"] = "Meisters",
    ["Multistrike"] = "Mehrfach",
    ["Versatility"] = "Viels",
    ["BonusArmor"] = "B-Rüstung",
    ["Spirit"] = "Wille",
    ["Dodge"] = "Ausw",
    ["Parry"] = "Parieren",
    ["MovementSpeed"] = "Geschw",
    ["Avoidance"] = "Verm",
    ["Stamina"] = "Ausd",
    ["Armor"] = "Rüstung",
    ["AttackPower"] = "AK",
    ["SpellPower"] = "ZM",
    ["PvpResilience"] = "PvP Abh",
    ["PvpPower"] = "PvP Macht",
}

-- AskMrRobot.lua
L.AMR_IMPORT_ERROR_EMPTY = "Der Importtext ist leer."
L.AMR_IMPORT_ERROR_FORMAT = "Der Importtext hat ein ungültiges Format."
L.AMR_IMPORT_ERROR_VERSION = "Der Importtext ist für eine alte Version des Addons. Bitte gehe auf die Webseite und generiere einen neuen."
L.AMR_IMPORT_ERROR_CHAR = "Der Importtext ist für %s, aber du bist %s!"
L.AMR_IMPORT_ERROR_RACE = "Es sieht so aus, als hätte sich deine Rasse geändert. Bitte gehe auf die Webseite und optimiere erneut."
L.AMR_IMPORT_ERROR_FACTION = "Es sieht so aus, als hätte sich deine Fraktion geändert. Bitte gehe auf die Webseite und optimiere erneut."
L.AMR_IMPORT_ERROR_LEVEL = "Es sieht so aus, als hätte sich dein Level geändert. Bitte gehe auf die Webseite und optimiere erneut."
L.AMR_IMPORT_ERROR_SPEC = "Bitte ändere deine Spezialisierung auf %s um diese Optimierung zu sehen."
L.AMR_IMPORT_ERROR_TALENT = "Es sieht so aus, als hätten sich deine Talente geändert. Bitte gehe auf die Webseite und optimiere erneut."
L.AMR_IMPORT_ERROR_GLYPH = "Es sieht so aus, als hätten sich deine Glyphen geändert. Bitte gehe auf die Webseite und optimiere erneut."
--SlashCmdList.AMR
L.AMR_SLASH_COMMAND_TEXT_1 = 'Verfügbare AskMrRobot Befehle:\n'
L.AMR_SLASH_COMMAND_TEXT_2 = '  /amr show   -- zeigt das Hauptfenster\n'
L.AMR_SLASH_COMMAND_TEXT_3 = '  /amr hide   -- versteckt das Hauptfenster\n'
L.AMR_SLASH_COMMAND_TEXT_4 = '  /amr toggle -- schaltet das Hauptfenster um\n'
L.AMR_SLASH_COMMAND_TEXT_5 = '  /amr wipe   -- markiert einen Kampf als Wipe. Wird benutzt, um Ereignisse danach zu ignorieren\n'
L.AMR_SLASH_COMMAND_TEXT_6 = '  /amr unwipe -- macht den letzten Wipe-Befehl rückgängig\n'
L.AMR_SLASH_COMMAND_TEXT_7 = '  /amr export -- exportiert Taschen- und Bankinhalt (öffnet das Exportieren-Fenster)'

--AskMrRobotUi.lua

--createMainMenu
L.AMR_UI_MENU_EXPORT = "Exportieren"
L.AMR_UI_MENU_GEAR = "Ausrüstung laden"
L.AMR_UI_MENU_COMBAT_LOG = "Kampflog"
L.AMR_UI_MENU_HELP = "Hilfe"

L.AMR_UI_BUTTON_IMPORT = "Import"
L.AMR_UI_BUTTON_SUMMARY = "Übersicht"
L.AMR_UI_BUTTON_GEMS = "Edelsteine"
L.AMR_UI_BUTTON_ENCHANTS = "Verzauberungen"
L.AMR_UI_BUTTON_SHOPPING_LIST = "Einkaufsliste"

--AskMrRobot.lua
L.AMR_ON_EVENT_TOOLTIP = "Linksklick öffnet das Ask Mr. Robot Fenster.\n\nUmschalt + Linksklick um deinen Taschen- und Bankinhalt zu exportieren.\n\nStrg + Linksklick um einen Kampf als Wipe zu markieren."

--config.lua
--frame:SetScript
L.AMR_CONFIG_EXIMPORT = "Mr. Robots Addon kann deine Gegenstandsinformationen auf seine Webseite exportieren, sowie die Optimierungen ins Spiel."
L.AMR_CONFIG_CHECKBOX_MINIMAP_LABEL = "Zeige Minimap-Icon"
L.AMR_CONFIG_CHECKBOX_MINIMAP_TOOLTIP_TITLE = "Minimap-Icon"
L.AMR_CONFIG_CHECKBOX_MINIMAP_DESCRIPTION = "Zeige das Ask Mr. Robot Minimap-Icon."
L.AMR_CONFIG_CHECKBOX_AUTOAH_LABEL = "Öffne Mr. Robots Einkaufsliste automatisch beim Auktionshaus"
L.AMR_CONFIG_CHECKBOX_AUTOAH_TOOLTIP_TITLE = "Automatisches Öffnen Einkaufsliste"
L.AMR_CONFIG_CHECKBOX_AUTOAH_DESCRIPTION = "Wenn auf deiner Einkaufsliste noch Posten offen sind, öffne Mr. Robots Einkaufsliste automatisch, wenn du das Auktionshaus besuchst."

--wait.lua
--wait
L.AMR_WAIT_BAD_ARGUMENTS = "Bad Arguments to amr__wait"
--dir ui
--ui/CombatLogTab.lua
L.AMR_COMBATLOGTAB_COMBAT_LOGGING = "Kampflog"
L.AMR_COMBATLOGTAB_START_LOGGING = "Starte Kampflog"
L.AMR_COMBATLOGTAB_CURRENTLY_LOGGING = "|c0000ff00Loggt derzeit|r"
L.AMR_COMBATLOGTAB_STOP_LOGGING = "Stoppe Kampflog"
L.AMR_COMBATLOGTAB_CHECKBOX_AUTOLOG_SOO_LABEL = "Schlacht um Orgrimmar automatisch protokollieren"
L.AMR_COMBATLOGTAB_CHECKBOX_AUTOLOG_SOO_TOOLTIP_TITLE = "Automatisch Schlacht um Orgrimmar protokollieren"
L.AMR_COMBATLOGTAB_CHECKBOX_AUTOLOG_SOO_DESCRIPTION = "Das Kampflog wird automatisch gestartet, sobald du die Schlacht um Orgrimmar betrittst, und gestoppt, wenn du sie verlässt.\n\nBeachte, dass du andere Addons mit ähnlichen Funktionen deaktivieren solltest, um Konflikte zu vermeiden."
L.AMR_COMBATLOGTAB_HEADLINE_OVER_BUTTON = "Charakterdaten"
L.AMR_COMBATLOGTAB_SAVE_CHARACTER = "Daten speichern"
L.AMR_COMBATLOGTAB_INSTRUCTIONS = "ANWEISUNGEN"
L.AMR_COMBATLOGTAB_INSTRUCTIONS_1 = "1. Benutze den Start/Stop-Button oder aktiviere 'Schlacht um Orgrimmar automatisch protokollieren'."
L.AMR_COMBATLOGTAB_INSTRUCTIONS_2 = "2. Wenn du bereit bist, deine Daten hochzuladen, drücke 'Daten speichern'. *"
L.AMR_COMBATLOGTAB_INSTRUCTIONS_3 = "3. Beende World of Warcraft. **"
L.AMR_COMBATLOGTAB_INSTRUCTIONS_4 = "4. Starte den Ask Mr. Robot Client und folge den Anweisungen. ***"
L.AMR_COMBATLOGTAB_INSTRUCTIONS_5 = "|c00999999* Dies wird dein UI neu laden um sicher zu stellen, dass alle gesammelten Daten auf deine Festplatte gespeichert wurden. Dieser Schritt ist nicht notwendig, wenn du dich vor dem Hochladen ausloggst.|r"
L.AMR_COMBATLOGTAB_INSTRUCTIONS_6 = "|c00999999** WoW zu beenden bevor du hochlädst ist optional, aber sehr zu empfehlen. Dies verhindert, dass das Kampflog übertrieben groß wird und damit den Vorgang verlangsamt.|r"
L.AMR_COMBATLOGTAB_INSTRUCTIONS_7 = "|c00999999*** Du kannst das Programm hier herunterladen: |r |c003333ffhttp://www.askmrrobot.com/wow/combatlog/upload|r|c00999999.|r"
L.AMR_COMBATLOGTAB_IS_LOGGING = "Du schreibst nun ein Kampflog und Mr. Robot speichert die Charakterdaten für den Raid."
L.AMR_COMBATLOGTAB_STOPPED_LOGGING = "Kampflog wurde gestoppt."
L.AMR_COMBATLOGTAB_INFIGHT = "Optionen im Kampf"
L.AMR_COMBATLOGTAB_WIPE_1 = "|c00aaaaaaDeklariere einen Wipe |r|c00ffffffbevor|r|c00aaaaaa du absichtlich stirbst.|r"
L.AMR_COMBATLOGTAB_WIPE_2 = "|c00aaaaaaDies wird absichtliche Tode und Schaden ignorieren.|r"
L.AMR_COMBATLOGTAB_WIPE_3 = "|c00999999Diese Funktion muss von der Person benutzt werden, die das Kampflog aufzeichnet.|r"
L.AMR_COMBATLOGTAB_SAVE_CHARACTER_INFO = "Während das Kampflog aufgezeichnet wird, werden Charakter- und Ausrüstungsdaten für alle Mitglieder des Raids, die dieses Addon installiert haben, aufgezeichnet. Nach dem Raid muss die Person, die das Kampflog aufgezeichnet hat, den Button drücken oder ausloggen, um die Daten zu speichern, damit sie hochgeladen werden können."
L.AMR_COMBATLOGTAB_LASTWIPE = '|c00ff0000Letzter Wipe am %s um %s.|r'
L.AMR_COMBATLOGTAB_WIPE_CHAT = "Es ist ein Wipe, sterbt!"
L.AMR_COMBATLOGTAB_WIPE_MSG = "[AskMrRobot] Manueller Wipe ausgerufen um %s"
L.AMR_COMBATLOGTAB_NOWIPES = '[AskMrRobot] Es gibt keinen manuellen Wipe zu entfernen'
L.AMR_COMBATLOGTAB_UNWIPE_MSG = "[AskMrRobot] Manueller Wipe um %s wurde entfernt"
--ui/EnchantTab.lua
L.AMR_ENCHANTTAB_ENCHANTS = "Verzauberungen"
L.AMR_ENCHANTTAB_100_OPTIMAL = "Deine Verzauberungen sind 100% optimal!"
L.AMR_ENCHANTTAB_SLOT = "Platz"
L.AMR_ENCHANTTAB_CURRENT = "Aktuell"
L.AMR_ENCHANTTAB_OPTIMIZED = "Optimiert"
L.AMR_ENCHANTTAB_TESTSLOT = "TestSlot"
--ui/ExportTab.lua
L.AMR_EXPORTTAB_EXPORT_TITLE = "Exportiere deinen Character für AskMrRobot.com"
L.AMR_EXPORTTAB_COPY_PASTE_EXPORT_1 = "1. Öffne deine Bank"
L.AMR_EXPORTTAB_COPY_PASTE_EXPORT_2 = "2. Kopiere den Text unterhalb mit Strg + C (oder Cmd + C auf einem Mac)"
L.AMR_EXPORTTAB_COPY_PASTE_EXPORT_3 = "3. Gehe auf |c00ffd100AskMrRobot.com|r und klicke auf den grünen '|c0000ff00Import from Addon|r' Button über deinem Charakternamen. Füge den Text in das Fenster ein, das sich öffnet."
L.AMR_EXPORTTAB_COPY_PASTE_EXPORT_NOTE = "Hinweis: Falls du etwas änderst, während dieses Fenster offen ist, dann klicke auf den Aktualisieren-Button unten, um einen neuen Export-Text zu erzeugen."
L.AMR_EXPORTTAB_UPDATE = "Aktualisieren"


--ui/GemTab.lua
--popup autogem finished
L.AMR_GEMTAB_FINISHED = "Mr. Robot ist fertig mit dem automatischen Sockeln. \rFalls Gegenstände nicht gesockelt wurden, hattest du vielleicht nicht genug Edelsteine. \rSollte dein Gürtel nicht gesockelt sein, fehlt eventuell die Gürtelschnalle."
L.AMR_GEMTAB_BUTTON_OK = "Ok"
--popup autogem once
L.AMR_GEMTAB_AUTOGEMMING_IN_PROGRESS = "Automatisches Sockeln läuft bereits."
--constructor
L.AMR_GEMTAB_GEMS = "Edelsteine"
L.AMR_GEMTAB_OPTIMAL = "Deine Edelsteine sind 100% optimal! Du bist nun wirklich, wirklich herausragend."
L.AMR_GEMTAB_X_OPTIMIZE = "Du hast X Edelsteine zu optimieren"
L.AMR_GEMTAB_AUTOGEM_BUTTON = "Auto Sockeln! (BETA)"
L.AMR_GEMTAB_PREFER_PERFECT = "Bevorzuge Perfekte"
L.AMR_GEMTAB_SLOT = "Platz"
L.AMR_GEMTAB_CURRENT = "Aktuell"
L.AMR_GEMTAB_OPTIMIZED = "Optimiert"
--Update
L.AMR_GEMTAB_TO_OPTIMIZE = "Du hast %d \1244Edelstein:Edelsteine; zu optimieren"
--ui/HelpTab.lua
L.AMR_HELPTAB_TITLE = "Hilfe"
L.AMR_HELPTAB_LINK = "Besuche |c003333ffhttp://blog.askmrrobot.com/addon/|r für eine komplette Anleitung und um Fragen zu stellen.\r"
L.AMR_HELPTAB_Q1 = "|c00999999Q:|r Das Arsenal aktualisiert meinen Charakter auf deiner Webseite nicht. Gibt es einen Workaround?"
L.AMR_HELPTAB_A1 = "|c0066dd66A:|r Ja. Gehe in die |c00ffd100Exportieren|r Sektion dieses Addons. Kopiere den Text in der Box. Dann gehe auf unsere |c00ffd100Website|r, lade deinen Charakter und klicke auf den grünen '|c0000ff00Import (from addon)|r' Button über deinem Charakternamen. Füge den Text dort ein. Dieser Prozess bringt deinen derzeitigen ingame Charakter auf die Webseite!"
L.AMR_HELPTAB_Q2 = "|c00999999Q:|r Muss ich zum Optimieren jedesmal einen neuen Text generieren?"
L.AMR_HELPTAB_A2 = "|c0066dd66A:|r Ja. Gehe auf die |c00ffd100Website|r und klicke auf den grünen '|c0000ff00Update from Armory|r' Button über deinem Charakternamen, damit immer die aktuellsten Daten vorliegen. Optimiere deine Ausrüstung und klicke dann auf den blauen '|c0018C0F7Export to Addon|r' Button in der '|c00BF28D6Now What?|r' Sektion rechts, um deinen neuen Text zu bekommen. Kehre zu diesem |c00ffd100Addon|r zurück, gehe in den '|c00ffd100Ausrüstung laden|r' Tab und füge den Text in die Box ein."
L.AMR_HELPTAB_Q3 = "|c00999999Q:|r Kann ich meine Einkaufsliste an einen anderen meiner Charaktere schicken?"
L.AMR_HELPTAB_A3 = '|c0066dd66A:|r Ja, gehe in den Reiter Einkaufsliste und wähle "Post" als Option im Menü. Du kannst die Liste dann per Post verschicken.'
L.AMR_HELPTAB_Q4 = "|c00999999Q:|r Ich bin gerade im Raid und habe einen Gegenstand bekommen. Kann ich diesen schnell optimieren?"
L.AMR_HELPTAB_A4 = "|c0066dd66A:|r Ja! Schaue in diese Anleitung hier: |c003333ffhttp://blog.askmrrobot.com/addon#raid|r"
L.AMR_HELPTAB_Q5 = "|c00999999Q:|r Wo ist das automatische Sockeln?"
L.AMR_HELPTAB_A5 = "|c0066dd66A:|r Wir haben es vorrübergehend entfernt. Wir planen, es in WoD zurück zu bringen."
L.AMR_HELPTAB_Q6 = "|c00999999Q:|r Ist Mr. Robot am aktuellen Stand?"
L.AMR_HELPTAB_A6 = "|c0066dd66A:|r Ja! Für weitere Informationen, gehe auf \r|c003333ffhttp://blog.askmrrobot.com/2014/10/what-to-do-for-6-0-2/|r"
--ui/ImportTab.lua
--new
L.AMR_IMPORTTAB_BUTTON = "Importieren"
L.AMR_IMPORTTAB_TITLE = "Ein Ausrüstungsset von der Webseite laden"
L.AMR_IMPORTTAB_INSTRUCTIONS_1 = "1. Klicke auf den blauen '|c0018C0F7Export to Addon|r' Button auf unserer |c00BF28D6Website|r. Er befindet sich rechts in der '|c33ffffffNow What?|r' Sektion. Kopiere den Text im Textfeld, das sich öffnet.\n|c00999999Zum Kopieren, drücke Strg + C (oder Cmd + C auf einem Mac)|r"
L.AMR_IMPORTTAB_INSTRUCTIONS_2 = "2. Kehre dann zu diesem Fenster im |c00ffd100Addon|r zurück. Füge den Text in die Box unten ein und klicke auf den 'Importieren' Button.\n|c00999999Zum Einfügen, drücke Strg + V (oder Cmd + V auf einem Mac)|r"

--ui/ShoppingListTab
--popup mail
L.AMR_SHOPPINGLISTTAB_OPEN_MAIL = "Du muss das Postfenster öffnen, damit dies funktioniert."
L.AMR_SHOPPINGLISTTAB_BUTTON_OK = "Ok"
--new
L.AMR_SHOPPINGLISTTAB_TITLE = "Einkaufsliste"
L.AMR_SHOPPINGLISTTAB_BUTTON_SEND = "Abschicken!"
L.AMR_SHOPPINGLISTTAB_ENCHANT_MATERIALS = "Verzauberungsmaterialien"
L.AMR_SHOPPINGLISTTAB_ENCHANTS = "Verzauberungen"
L.AMR_SHOPPINGLISTTAB_GEMS = "Edelsteine"
L.AMR_SHOPPINGLISTTAB_INCLUDE = "Einfügen:"
L.AMR_SHOPPINGLISTTAB_SEND_LIST_TO = "Sende Liste an"
L.AMR_SHOPPINGLISTTAB_WHISPER_CHANNEL = "Flüstern oder an einen Kanal wie /raid oder /gilde senden."
L.AMR_SHOPPINGLISTTAB_SEND_JEWELCRAFT_ENCHANTER = "An einen Juwelier oder Verzauberer senden"
L.AMR_SHOPPINGLISTTAB_TOTAL = "Total"
L.AMR_SHOPPINGLISTTAB_DONE = "EINKAUF ERLEDIGT!"
L.AMR_SHOPPINGLISTTAB_A_ROBOTS_WISHLIST = "Es sei denn, du willst mir ein Geburtstagsgeschenk kaufen! Ich mag Titan Bolzen und Roboter Hunde... Oder war es Titan Hunde und Roboter Bolzen..."
L.AMR_SHOPPINGLISTTAB_DROPDOWN_FRIEND = "Flüstern"
L.AMR_SHOPPINGLISTTAB_DROPDOWN_PARTY = "Gruppe"
L.AMR_SHOPPINGLISTTAB_DROPDOWN_RAID = "Raid"
L.AMR_SHOPPINGLISTTAB_DROPDOWN_GUILD = "Gilde"
L.AMR_SHOPPINGLISTTAB_DROPDOWN_CHANNEL = "Kanal"
L.AMR_SHOPPINGLISTTAB_DROPDOWN_MAIL = "Post"
L.AMR_SHOPPINGLISTTAB_MAIL_ROBOT_MESSAGE = "Mr. Robot sagt, ich brauche folgendes, um meine Ausrüstung zu optimieren:\n"
L.AMR_SHOPPINGLISTTAB_MAIL_SUBJECT_GE = 'Anfrage für Edelsteine und Verzauberungen'
L.AMR_SHOPPINGLISTTAB_MAIL_SUBJECT_G = 'Anfrage für Edelsteine'
L.AMR_SHOPPINGLISTTAB_MAIL_SUBJECT_E = 'Anfrage für Verzauberungen'
L.AMR_SHOPPINGLISTTAB_CHAT_ROBOT_MESSAGE = "Mr. Robot sagt ich brauche"
--ui/SummaryTab.lua
L.AMR_SUMMARYTAB_TITLE = "Übersicht"
L.AMR_SUMMARYTAB_NO_IMPORT = "Du hast keine Optimierungen importiert."
L.AMR_SUMMARYTAB_GET_STARTED = 'Wechsel in den "Import"-Reiter um zu beginnen.'
L.AMR_SUMMARYTAB_GO_UPGRADE = "Bitte werte die folgenden Gegenstände auf:"
L.AMR_SUMMARYTAB_SLOT = "Platz"
L.AMR_SUMMARYTAB_ITEM_NAME = "Gegenstandsname"
L.AMR_SUMMARYTAB_OPTIMAL = "Glückwunsch! Du bist 100% optimal"
L.AMR_SUMMARYTAB_LAST_IMPORT = "Letzter Import: ?\rDiese Optimierungen sind für ?"
L.AMR_SUMMARYTAB_OPTIMIZATIONS_TO_GO = "Du hast ? Optimierungen durchzuführen:"
L.AMR_SUMMARYTAB_GEMS_TO_GO = "? Edelsteine"
L.AMR_SUMMARYTAB_ENCHANTS_TO_GO = "? Verzauberungen"
L.AMR_SUMMARYTAB_VIEW_TABS = "Schaue in die Edelsteine und Verzauberungen Reiter, um die vorgeschlagenen Optimierungen zu sehen."
L.AMR_SUMMARYTAB_GEMCOUNT = "%d \1244Edelstein:Edelsteine;"
L.AMR_SUMMARYTAB_ENCHANTCOUNT = "%d \1244Verzauberung:Verzauberungen;"
L.AMR_SUMMARYTAB_OPTIMIZATIONCOUNT = "Du hast %d \1244Optimierung:Optimierungen; zu machen:"
L.AMR_SUMMARYTAB_LAST_IMPORT_1 = "Letzer Import: %s\rDiese Optimierungen sind für %s"
L.AMR_SUMMARYTAB_LAST_IMPORT_2 = "Letzter Import: %s\rDiese Optimierungen sind für %s's..."
L.AMR_SUMMARYTAB_LAST_IMPORT_PSPEC = "Primäre Spez.: %s"
L.AMR_SUMMARYTAB_LAST_IMPORT_SSPEC = "Sekundäre Spez.: %s"
L.AMR_SUMMARYTAB_DIFF_REALM = "einen anderen Server: %s"
L.AMR_SUMMARYTAB_DIFF_TALENT = "andere Talente"
L.AMR_SUMMARYTAB_DIFF_GLYPHS = "andere Glyphen"
L.AMR_SUMMARYTAB_DIFF_GEAR = "Mr. Robot hat eine andere Ausrüstungszusammenstellung optimiert"
L.AMR_SUMMARYTAB_DIFF_AND = "und"
L.AMR_SUMMARYTAB_DIFF_PLEASE_EQ = ". Bitte rüste die folgenden Gegenstände aus, bevor du fortfährst."
L.AMR_SUMMARYTAB_DIFF_CHECK_CHAR = "WARNUNG: Bitte überprüfe deinen Charackter, bevor du fortfährst:"
L.AMR_SUMMARYTAB_DIFF_OPTIMIZED_FOR = "Mr. Robot optimierte für "
--showImportError
L.AMR_SUMMARYTAB_IMPORT_NOT_WORK = 'Fehler! Dein Import ist fehlgeschlagen:\n\n%s'
--ui/RobotStamp.lua
L.AMR_ROBOTSTAMP_TEXT = "MR. ROBOT PRÜFSIEGEL"
L.AMR_ROBOTSTAMP_GEMS = "Deine Edelsteine sind 100% optimal! Du bist nun wirklich, wirklich herausragend."