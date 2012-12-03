-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Crafting - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_crafting.aspx    --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --

-- TradeSkillMaster_Crafting Locale - deDE
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_Crafting/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Crafting", "deDE")
if not L then return end

L["2H Weapon"] = "2H Waffe"
L["Add Crafted Items from this Group to Auctioning Groups"] = "Füge die produzierten Items aus dieser Gruppe zur Auctioning Gruppe hinzu"
L["Added %s crafted items to: %s."] = "%s produzierte Items zu \"%s\" hinzugefügt."
L["Added %s crafted items to %s individual groups."] = "%s produzierte Items zu %s exklusiven Gruppen hinzugefügt."
L["Add Item to New Group"] = "Gegenstand neuer Gruppe hinzufügen"
L["Add Item to Selected Group"] = "Gegenstand ausgewählter Gruppe hinzufügen"
L["Add Item to TSM_Auctioning"] = "Gegenstand TSM_Auctioning hinzufügen"
L["Additional Item Settings"] = "Weitere gegenstandsbezogene Einstellungen"
L["Addon to use for alt data:"] = "Addon, das die Alt-Daten zur Verfügung stellen soll:"
L["Adds all items in this Crafting group to Auctioning group(s) as per the above settings."] = "Fügt alle Items dieser Produktionsgruppe, wie oben eingestellt, der/den Auctioning Gruppe(n) hinzu."
-- L["AH/Bags/Bank/Mail/Alts"] = ""
L["All"] = "Alle"
L["All in Individual Groups"] = "Alle in exklusive Gruppen"
L["All in Same Group"] = "Alle in der gleichen Gruppe."
L["Allows you to override the minimum profit settings for this profession."] = "Diese Option gestattet Ihnen den Wert des minimalsten Profits für diesen Beruf aufzuheben."
L["Allows you to set a custom maximum queue quantity for this item."] = "Diese Option gestattet Ihnen einen eigenen Wert für die maximale Anzahl an Items der Produktionsmenge zu setzen."
L["Allows you to set a custom maximum queue quantity for this profession."] = "Diese Option gestattet Ihnen einen eigenen Wert für die maximale Anzahl an Items der Produktionsmenge in diesem Beruf zu setzen."
L["Allows you to set a custom minimum ilvl to queue."] = "Erlaubt dir eine benutzerdefiniertes mindest Itemlevel in die Warteschlange zu setzen. "
L["Allows you to set a custom minimum queue quantity for this item."] = "Erlaubt dir, eine eigene minimale Warteschlangenmenge für diesen Gegenstand zu setzen."
L["Allows you to set a custom minimum queue quantity for this profession."] = "Diese Option gestattet Ihnen einen eigenen Wert für die minimale Anzahl an Items der Produktionsmenge in diesem Beruf zu setzen."
-- L["All vendor items that cost more than this price will not be ignored by the on-hand queue."] = ""
L["Always queue this item."] = "Dieses Item immer der Warteschlange hinzufügen."
L["Are you sure you want to delete the selected profile?"] = "Bist du sicher, dass du das gewählte Profil löschen möchtest?"
L["Armor"] = "Rüstung"
L["Armor - Back"] = "Rüstung - Umhang"
L["Armor - Chest"] = "Rüstung - Brust"
L["Armor - Feet"] = "Rüstung - Füße"
L["Armor - Hands"] = "Rüstung - Hände"
L["Armor - Head"] = "Rüstung - Kopf"
L["Armor - Legs"] = "Rüstung - Beine"
L["Armor - Shield"] = "Rüstung - Schild"
L["Armor - Shoulders"] = "Rüstung - Schultern"
L["Armor - Waist"] = "Rüstung - Gürtel"
L["Armor - Wrists"] = "Rüstung - Handgelenke"
L["Auctioneer"] = "Auctioneer"
L["Auction House"] = "Auktionshaus"
L["Auction House Value"] = "Auktionshaus-Wert"
L["Bags"] = "Taschen"
L["Bars"] = "Balken"
L["Blackfallow Ink"] = "Schwarzfahltinte"
L["Blue Gems"] = "Blaue Edelsteine"
L["Boots"] = "Schuhe"
L["Bracers"] = "Armschienen"
L["Buy From Vendor"] = "Vendor Einkaufspreis"
L["Cannot delete currently active profile!"] = "Das aktuelle aktive Profil kann nicht gelöscht werden."
L["Can not set a max restock quantity below the minimum restock quantity of %d."] = "Die maximale Nachfüllmenge kann nicht geringer als die minimale Nachfüllmenge in Höhe von %d gesetzt werden."
-- L["Can not set a min restock quantity above the max restock quantity of %d."] = ""
-- L["Category to put groups into:"] = ""
L["Celestial Ink"] = "Firmamenttinte"
L["Character(s) (comma-separated if necessary):"] = "Charakter(e) (mit Komma getrennt, wenn nötig):" -- Needs review
L["Characters to include:"] = "Charaktere, die eingebunden werden sollen:"
-- L["Character to Send Crafting Costs to:"] = ""
L["Checking this box will allow you to set a custom, fixed price for this item."] = "Das Aktivieren dieser Option erlaubt Ihnen einen benutzerdefinierten Festpreis für diesen Gegenstand festzulegen."
L["Chest"] = "Brust"
L["Class"] = "Klasse"
L["Clear Queue"] = "Warteschlange leeren"
L["Clear Tradeskill Filters"] = "Herstellungsfähigkeiten-Filter zurücksetzen"
L["Cloak"] = "Umhang"
L["Close TradeSkillMaster_Crafting"] = "Schliesse TradeSkillMaster_Crafting"
L["Cloth"] = "Stoff"
L["Combine/Split Essences/Eternals"] = "Kombiniere/Teile Essenzen/Äonen"
L["Companions"] = "Begleiter"
-- L["Compressing and sending %s bytes of data to %s. This will take approximately %s seconds. Please wait..."] = ""
L["Consumables"] = "Verbrauchbar"
L["Copy From"] = "Kopiere von"
L["Copy the settings from one existing profile into the currently active profile."] = "Kopiere die Einstellungen von einem existierenden Profil in das aktuell aktive Profil"
L["Cost"] = "Kosten"
L["Cost to Craft"] = "Herstellungskosten"
L["Craft"] = "Beruf"
-- L["Crafting Cost"] = ""
L["Crafting Cost: %s (%s profit)"] = "Herstellungskosten: %s (%s Gewinn)"
-- L["Crafting Cost Synchronization"] = ""
L["Crafting Options"] = "Handwerksoptionen"
L["<Crafting Stage #%s>"] = "<Herstellungsphase #%s>"
L["Craft Item (x%s)"] = "Gegenstand herstellen (x%s)"
-- L["Craft Management Window Settings"] = ""
L["Craft Next"] = "Nächstes herstellen"
L["Crafts"] = "Berufe"
L["Create a new empty profile."] = "Erstelle ein neues, leeres Profil"
L["Create Auctioning Groups"] = "Auktionsgruppe erstellen"
L["Current Profile:"] = "Aktuelles Profil:"
L["Custom"] = "Eigene"
L["Custom Value"] = "Eigener Wert"
L["DataStore"] = "DataStore"
L["Default"] = "Standard"
L["Delete a Profile"] = "Lösche ein Profil"
L["Delete existing and unused profiles from the database to save space, and cleanup the SavedVariables file."] = "Lösche bestehende, unbenutzte Profile aus der Datenbank, um Platz zu sparen und räume die Datei SavedVariables auf."
L["Disable All Crafts"] = "Deaktiviere alle Berufe"
L["Don't queue this item."] = "Diesen Gegenstand nicht in die Warteschlange übernehmen."
L["Double Click Queue"] = "Warteschlange doppelklicken"
L["Edit Custom Value"] = "Eigenen Wert anpassen"
L["Elixir"] = "Elixier"
L["Enable All Crafts"] = "Aktiviere alle Berufe"
L["Enable / Disable showing this craft in the craft management window."] = "Aktiviere / Deaktiviere die Anzeige dieses Berufs im Herstellverwaltungsfenster."
L["Enable New TradeSkills"] = "Aktiviere neue Herstellungsfähigkeiten"
L["Enter a value that Crafting will use as the cost of this material."] = "Geben Sie einen Wert ein, den \"Crafting\" als Materialkosten benutzen soll."
L["Enter what you want to multiply the cost of the other item by to calculate the price of this mat."] = "Geben Sie einen Faktor ein mit dem Sie die Kosten des anderen Gegenstandes multiplizieren wollen, um die Kosten für dieses Material zu kalkulieren."
L["Estimated Total Mat Cost:"] = "Voraussichtliche Gesamtmaterialkosten "
L["Estimated Total Profit:"] = "Voraussichtlicher Gesamtgewinn:"
L["Ethereal Ink"] = "Astraltinte"
L["Existing Profiles"] = "Existierende Profile"
L["Explosives"] = "Sprengstoffe"
L["Export Crafts to TradeSkillMaster_Auctioning"] = "Exportiere Beruf nach TradeSkillMaster_Auctioning"
L["Filter out items with low seen count."] = "Filtere Gegenstände, die selten gesehen wurden."
L["Flask"] = "Fläschchen"
L["Force Rescan of Profession (Advanced)"] = "Neuscan für den Beruf forcieren (Fortgeschritten)"
L["Frame Scale"] = "Rahmenskalierung"
L["General Price Sources"] = "Allgemeine Preisquellen"
L["General Setting Overrides"] = "Ausnahmen der allgemeinen Einstellungen (aufgehobene Einstellungen)"
L["General Settings"] = "Allgemeine Einstellungen"
L["Get Craft Prices From:"] = "Beziehe die Herstellpreise von:"
L["Get Mat Prices From:"] = "Beziehe die Rohmaterialpreise von:"
L["Gloves"] = "Handschuhe"
L["Gold Amount"] = "Goldmenge"
-- L["Got invalid crafting cost data from %s."] = ""
L["Green Gems"] = "Grüne Edelsteine"
L["Group Inscription Crafts By:"] = "Gruppiere die Produkte der Inschriftenkunde nach:"
L["Group to Add Crafts to:"] = "Gruppe zum Beruf hinzufügen:"
L["Guilds to include:"] = "Gilden, die mit eingeschlossen werden sollen:"
L["Guns"] = "Gewehre"
L["Help"] = "Hilfe"
L["Here, you can override default restock queue settings."] = "Hier können Sie die Standard mäßigen Einstellungen der wiederauffüllenden Warteschlange außer Kraft setzen."
L["Here, you can override general settings."] = "Hier können Sie die allgemeinen Einstellungen außer Kraft setzen."
L["Here you can view and adjust how Crafting is calculating the price for this material."] = "Hier können Sie einsehen und anpassen wie \"Crafting\" die Preise für dieses Material kalkuliert."
L["How to add crafts to Auctioning:"] = "Wie Sie Berufe zu Auctioning hinzufügen:"
-- L["If a price source is selected, Crafting will use the secondary price source for mat/craft prices if the price source set above doesn't return a valid price."] = ""
-- L["If checked and a secondary price source is selected, Crafting will use the secondary price source if it's a lower price than the main price source for mats/crafts."] = ""
L["If checked, any crafts which are already in an Auctioning group will be removed from their current group and a new group will be created for them. If you want to maintain the groups you already have setup that include items in this group, leave this unchecked."] = "Wenn ausgewählt, dann wird jeder Beruf welcher bereits in einer Auctioning-Gruppe ist, aus seiner aktuellen Gruppe entfernt und eine neue Gruppe wird für sie erstellt. Wenn Sie Ihre bereits erstellten Gruppen mit den dazugehörigen Items behalten möchten, dann wählen Sie diese Option nicht aus."
-- L["If checked, Crafting will account for items you have on the AH."] = ""
L["If checked, Only crafts that are enabled (have the checkbox to the right of the item link checked) below will be added to Auctioning groups."] = "Wenn Sie dies auswählen, dann werden nur die produzierbaren Waren die aktiviert sind (Kontrollkästchen rechts vom Item Link ausgewählt) zu Auctioning Gruppen hinzugefügt."
-- L["If checked, only vendor items below a maximum price will be ignored by the on-hand queue."] = ""
L["If checked, the crafting cost of items will be shown in the tooltip for the item."] = "Wenn ausgewählt, werden die Herstellungskosten eines Gegenstandes im Tooltip angezeigt"
-- L["If checked, the on-hand queue will assume you have all vendor items when queuing crafts."] = ""
L["If checked, the profit percent (profit/sell price) will be shown next to the profit in the craft management window."] = "Wenn ausgewählt, wird der prozentuale Gewinn neben dem Gewinn im Berufsverwaltungsfenster angezeigt."
L["If checked, when Crafting scans a tradeskill for the first time (such as after you learn a new one), it will be enabled by default."] = "Wenn ausgewählt, und \"Crafting\" einen Beruf zum ersten Mal scannt (z.b. wenn Sie einen neuen Beruf erlernt haben), dann wird dieser standardmäßig aktiviert."
L["If checked, you can change the price source for this mat by clicking on one of the checkboxes below. This source will be used to determine the price of this mat until you remove the override or change the source manually. If this setting is not checked, Crafting will automatically pick the cheapest source."] = "Wenn ausgewählt, können Sie die Preisquelle für dieses Material durch Auswahl einer der nachfolgenden Checkboxen bestimmen. Diese Quelle wird verwendet um die Materialkosten zu bestimmen bis Sie die Überschreibung rückgängig machen oder die Quelle manuell anpassen. Wenn keine Checkbox ausgewählt wurde, benutzt \"Crafting\" automatisch die günstigste Quelle."
L["If enabled, any craft with a profit over this percent of the cost will be added to the craft queue when you use the \"Restock Queue\" button."] = "Falls aktiviert, wird jedes Produkt, das einen Profit höher als den angegebenen Prozentwert erzielt, beim Drücken von \"Herstellwarteschlange auffüllen\" der Warteschlange hinzugefügt."
L["If enabled, any craft with a profit over this value will be added to the craft queue when you use the \"Restock Queue\" button."] = "Falls aktiviert, wird jedes Produkt, das einen Profit höher als den angegebenen Wert erzielt, beim Drücken von \"Herstellwarteschlange auffüllen\" der Warteschlange hinzugefügt."
L["If enabled, any item with a seen count below this seen count filter value will not be added to the craft queue when using the \"Restock Queue\" button. You can overrride this filter for individual items in the \"Additional Item Settings\"."] = "Falls aktiviert, wird jedes Produkt, das seltener als wie angegeben gesehen wurde, nicht zur Herstellwarteschlange hinzugefügt, wenn \"Herstellwarteschlange auffüllen\" gedrückt wird. Diese Einstellung kann für Gegenstände individuell unter \"Weitere Gegenstandseinstellungen\" überschrieben werden."
-- L["If you use multiple accounts, you can use the steps below to synchronize your crafting costs between your accounts. This can be useful if you craft on one account and would like to post on another account using % of crafting cost as the threshold/fallback. Read the tooltips of the options below for instructions."] = ""
-- L["Ignored crafting cost data from %s since he is not on your list. You will only see this message once per session for this player."] = ""
L["Ignore Seen Count Filter"] = "Ignoriere \"Gesehen\" Filter"
-- L["Ignore Vendor Items"] = ""
L["In Bags"] = "In Taschen"
L["Include Crafts Already in a Group"] = "Schließe Berufe die sich bereits in einer Gruppe befinden ein"
-- L["Include Items on AH"] = ""
L["Ink"] = "Tinte"
-- L["Ink of Dreams"] = ""
L["Ink of the Sea"] = "Meerestinte"
L["Inks"] = "Tinten"
L["Inscription crafts can be grouped in TradeSkillMaster_Crafting either by class or by the ink required to make them."] = "Die Produkte der Inschriftenkunde können in TradeSkillMaster_Crafting entweder nach Klasse oder nach benötigter Tinte gruppiert werden."
L["Invalid item entered. You can either link the item into this box or type in the itemID from wowhead."] = "Ungültiger Gegenstand. Fügen Sie entweder den Gegenstandlink in das Feld ein oder geben Sie die Gegenstand-ID von Wowhead ein."
L["Invalid money format entered, should be \"#g#s#c\", \"25g4s50c\" is 25 gold, 4 silver, 50 copper."] = "Ungültiges Preisformat, verwenden Sie: \"#g#s#c\". \"25g4s50c\" entspricht 25 Gold, 4 Silber, 50 Kupfer"
L["Invalid Number"] = "Ungültige Anzahl"
-- L["Invalid target player \"%s\"."] = ""
L["Inventory Settings"] = "Inventareinstellungen"
L["Item Enhancements"] = "Item Verbesserungen"
L["Item Name"] = "Gegenstandsname"
L["Items will only be added to the queue if the number being added is greater than this number. This is useful if you don't want to bother with crafting singles for example."] = "Gegenstände werden nur zur Warteschlange hinzufügt, falls die hinzuzufügende Menge größer als diese Zahl ist. Dies ist beispielsweise praktisch, um die Herstellung einzelner Gegenstände zu vermeiden."
-- L["ItemTracker"] = ""
-- L["Item Value"] = ""
L["Jadefire Ink"] = "Jadefeuertinte"
L["Leather"] = "Leder"
-- L["Left-Click"] = ""
-- L["Left-Click|r on a row below to enable/disable a craft."] = ""
L["Level 1-35"] = "Level 1-35"
L["Level 36-70"] = "Level 36-70"
L["Level 71+"] = "Level 71+"
-- L["Limit Vendor Item Price"] = ""
L["Lion's Ink"] = "Löwentinte"
L["Manual Entry"] = "Manueller Eintrag"
L["Mark as Unknown (\"----\")"] = "Als unbekannt kennzeichnen (\"----\")"
L["Material Cost Options"] = "Materialkosten - Optionen"
L["Materials"] = "Materialien"
L["Mat Price"] = "Materialpreis"
-- L["Maximum Price Per Vendor Item"] = ""
L["Max Restock Quantity"] = "Maximale herzustellende Menge"
L["Meta Gems"] = "Meta Edelsteine"
L["Midnight Ink"] = "Mitternachtstinte"
L["Mill"] = "Mahle"
L["Milling"] = "Mahlen"
-- L["Min Craft ilvl"] = ""
-- L["Min ilvl to craft:"] = ""
L["Minimum Profit (in %)"] = "Mindestprofit (in %)"
L["Minimum Profit (in gold)"] = "Mindestprofit (in Gold)"
L["Minimum Profit Method"] = "Methode zur Ermittlung des minimalen Profits"
L["Min Restock Quantity"] = "Minimal herzustellende menge"
L["Misc Items"] = "Verschiedene Items"
L["Multiple of Other Item Cost"] = "Ein Vielfaches der Kosten anderer Gegenstände"
L["Name"] = "Name"
L["Name of New Group to Add Item to:"] = "Name der neuen Gruppe, der der Gegenstand hinzugefügt werden soll:"
L["Need"] = "Benötigt"
L["New"] = "Neu"
L["<New Group>"] = "<Neue Gruppe>"
L["<No Category>"] = "<Keine Kategorie>"
L["No crafts have been added for this profession. Crafts are automatically added when you click on the profession icon while logged onto a character which has that profession."] = "Es wurden für diesen Beruf noch keine Handwerksgegenstände hinzugefügt. Diese werden automatisch hinzugefügt wenn Sie auf das Berufe Icon clicken. Aber nur wenn ihr aktuell eingeloggter Charakter auch diesen Beruf beherrscht."
L["No Minimum"] = "Kein Minimum"
-- L["<None>"] = ""
L["Note: By default, Crafting will use the second cheapest value (herb or pigment cost) to calculate the cost of the pigment as this provides a slightly more accurate value."] = "Anmerkung: Standardmäßig benutzt \"Crafting\" den zweitgünstigsten Wert (Kräuter oder Pigment) um die Kosten für Pigmente zu kalkulieren,da diese Methode geringfügig genauere Ergebnisse liefert."
L["NOTE: Milling prices can be viewed / adjusted in the mat options for pigments. Click on the button below to go to the pigment options."] = "ANMERKUNG: Mahlpreise können in den Materialoptionen für Pigmente eingesehen/angepasst werden. Den nachfolgenden Button klicken um zu den Pigmentoptionen zu gelangen."
L["Number Owned"] = "Anzahl in Besitz"
L["OK"] = "OK"
L["On-Hand Queue"] = "Verfügbare Bestände Warteschlange"
L["Only Included Enabled Crafts"] = "Nur eingefügte aktivierte Güter"
-- L["On the account that will be receiving the crafting cost data (ie the account that doesn't have the profession), list the characters that will be sending the crafting cost data below (ie the characters with the profession)."] = ""
L["Open Mat Options for Pigment"] = "Öffne Materialoptionen für Pigment"
L["Open TradeSkillMaster_Crafting"] = "TradeSkillMaster_Crafting öffnen"
L["Options"] = "Einstellungen"
L["Orange Gems"] = "Orange Edelsteine"
L["Other"] = "Andere"
L["Other Consumable"] = "Andere Verbrauchsmaterialien"
L["Other Item"] = "Anderer Gegenstand"
L["Override Max Restock Quantity"] = "Setze die maximale Wiederauffüllungsmenge außer Kraft"
L["Override Minimum Profit"] = "Den minimalen Profit außer Kraft setzen"
L["Override Min Restock Quantity"] = "Setze die minimale Wiederauffüllungsmenge außer Kraft"
L["Override Price Source"] = "Preisquelle überschreiben"
L["Percent and Gold Amount"] = "Prozent und Goldmenge"
L["Percent of Cost"] = "Prozent der Kosten"
L["Percent to subtract from buyout when calculating profits (5% will compensate for AH cut)."] = "Vom Sofortkaufpreis abzuziehende % bei Berechnung des Profits (5% decken die AH Kosten)."
L["per pigment"] = "pro Pigment"
-- L["Place lower limit on ilvl to craft"] = ""
L["Potion"] = "Trank"
L["Price:"] = "Preis:"
-- L["Price / Inventory Settings"] = ""
L["Price Multiplier"] = "Preismultiplikator"
L["Price Settings"] = "Preiseinstellungen"
L["Price Source"] = "Preisquelle"
L["Prismatic Gems"] = "Prismatische Edelsteine"
L["Profession-Specific Settings"] = "Handwerksspezifische Einstellungen"
L["Profiles"] = "Profile"
L["Profit"] = "Profit"
L["Profit Deduction"] = "Profit abzug"
L["Purple Gems"] = "Purpurne Edelsteine"
L["# Queued:"] = "# Warteliste:"
-- L["Queue Settings"] = ""
L["Red Gems"] = "Rote Edelsteine"
L["Reset Profile"] = "Profil zurücksetzen"
L["Reset the current profile back to its default values, in case your configuration is broken, or you simply want to start over."] = "Sollte ihre Konfiguration Fehler aufweisen, dann setzen Sie das Profil zurück zu ihren default Werten (Ausgangswerten). Oder fangen Sie noch einmal von vorne an."
L["Restock Queue"] = "Nachfüllwarteschlange"
L["Restock Queue Overrides"] = "Wiederauffüllwarteschlange außer Kraft setzen"
L["Restock Queue Settings"] = "Nachfüllwarteschlangeneinstellungen"
-- L["Right-Click"] = ""
-- L["Right-Click|r on a row below to show additional settings for a craft."] = ""
L["Scopes"] = "Zielfernrohre"
L["Scrolls"] = "Schriftrollen"
-- L["Secondary Price Source"] = ""
L["Seen Count Filter"] = "Filter für die Anzahl der im Auktionshaus aufgefunden Items"
L["Seen Count Source"] = "Quelle für die im Auktionshaus aufgefunden Items"
L["Select an Auctioning group to add these crafts to."] = "Wählen SIe eine Auctioning Gruppe aus, zu der Sie diese herstellbaren Items hinzufügen möchten"
L["Select the crafts you would like to add to Auctioning and use the settings / buttons below to do so."] = "Wählen Sie die herstellbaren Items aus, die Sie zu Auctioning hinzufügen möchten und benutzen Sie dazu den Einstellungs-Kopf unterhalb."
-- L["Send Crafting Costs"] = ""
-- L["Sending data to %s complete!"] = ""
-- L["Set Crafted Item Cost to Auctioning Fallback"] = ""
L["Shield"] = "Schild"
L["Shimmering Ink"] = "Perlmutttinte"
L["Show Crafting Cost in Tooltip"] = "Zeige Herstellungskosten im Tooltip"
L["Show Craft Management Window"] = "Zeige Handwerks Management Fenster"
L["Show Profit Percentages"] = "Zeige Gewinn Prozentwerte"
L["%s not queued! Min restock of %s is higher than max restock of %s"] = "%s nicht in Warteschlange übernommen! Die minimale Produktionsmenge von %s ist höher als die maximale mit %s."
L["Staff"] = "Stab"
L["Status"] = "Status"
-- L["Step 2 (on Crafting Account):"] = ""
-- L["Successfully got %s bytes of crafting cost data from %s!"] = ""
-- L["The checkmarks next to each craft determine whether or not the craft will be shown in the Craft Management Window."] = ""
L["The item you want to base this mat's price on. You can either link the item into this box or type in the itemID from wowhead."] = "Der Gegenstand, der als Basis für die Materialkosten dient. Sie können entweder den Link in das Eingabefeld einfügen oder die GegenstandID von Wowhead eingeben."
-- L["These options control the \"Restock Queue\" button in the craft management window. These settings can be overriden by profession or by item in the profession pages of the main TSM window."] = ""
L["This is where TradeSkillMaster_Crafting will get material prices. AuctionDB is TradeSkillMaster's auction house data module. Alternatively, prices can be entered manually in the \"Materials\" pages."] = "Dort bezieht \"TradeSkillMaster_Crafting\" seine Materialpreise. \"AuctionDB\" ist das TSM Modul für Auktionshausdaten. Alternativ können die Preise manuell in der \"Material\" Übersicht angepasst werden."
L["This is where TradeSkillMaster_Crafting will get prices for crafted items. AuctionDB is TradeSkillMaster's auction house data module."] = "Dort bezieht \"TradeSkillMaster_Crafting\" seine Preise für hergestellte Gegenstände. \"AuctionDB\" ist das TSM Modul für Autionshausdaten."
L["This item is already in the \"%s\" Auctioning group."] = "Diese Item ist bereits in der \"%s\" Auktionsgruppe."
L["This item will always be queued (to the max restock quantity) regardless of price data."] = "Derzeit keine deutsche Übersetzung."
L["This item will not be queued by the \"Restock Queue\" ever."] = "Dieses Item wird nie in die \"Wiederauffüllen Warteschlange\" gesetzt."
L["This item will only be added to the queue if the number being added is greater than or equal to this number. This is useful if you don't want to bother with crafting singles for example."] = "Dieses Item wird nur dann der Warteschlange hinzugefügt, wenn deren Anzahl größer oder gleich zu dieser (Ihrer eingestellten) Nummer ist. Dies ist zum Beispiel dann nützlich, wenn Ihr nicht regelmäßig einzelne Items herstellen wollt."
L["This setting determines where seen count data is retreived from. The seen count data can be retreived from either Auctioneer or TradeSkillMaster's AuctionDB module."] = "Diese Option bestimmt von woher die Daten der gefundenen Items (im Auktionshaus) abgerufen werden. Diese Zahl kann entweder durch Auctioneer oder das TradeSkillMaster's AuctionDB Modul ermittelt werden."
L["This will allow you to base the price of this item on the price of some other item times a multiplier. Be careful not to create circular dependencies (ie Item A is based on the cost of Item B and Item B is based on the price of Item A)!"] = "Dies erlaubt Ihnen den Preis eines Gegenstandes auf dem Vielfachen des Preises eines anderen Gegenstandes basieren zu lassen. Seien Sie vorsichtig, dass Sie keine Kreisabhängigkeiten erzeugen (Bsp. Gegenstand A basiert auf den Kosten von Gegenstand B und Gegenstand B basiert auf den Kosten von Gegenstand A)!"
-- L["This will determine how items with unknown profit are dealt with in the Craft Management Window. If you have the Auctioning module installed and an item is in an Auctioning group, the fallback for the item can be used as the market value of the crafted item (will show in light blue in the Craft Management Window)."] = ""
L["This will set the scale of the craft management window. Everything inside the window will be scaled by this percentage."] = "Hiermit können sie die Größe des Herstellungsfensters einstellen. Alles innerhalb des Fensters wird diesem Prozentsatz angepasst."
L["Times Crafted"] = "Produktionsanzahl"
L["Total"] = "Summe"
L["TradeSkillMaster_AuctionDB"] = "TradeSkillMaster_AuctionDB"
-- L["TradeSkillMaster_Crafting can use TradeSkillMaster_ItemTracker or DataStore_Containers to provide data for a number of different places inside TradeSkillMaster_Crafting. Use the settings below to set this up."] = ""
L["TradeSkillMaster_Crafting - Scanning..."] = "TradeSkillMaster_Crafting - Lese Daten ein..."
L["Transmutes"] = "Transmutieren"
L["Trinkets"] = "Schmuckstücke"
L["TSM_Auctioning Group to Add Item to:"] = "TSM_Auctioning Gruppe der der Gegenstand hinzugefügt werden soll:"
-- L["TSM_Crafting - Buy Vendor Items"] = ""
-- L["Type in the name of the player you want to send your crafting cost data to and hit the \"Send\" button. Remember to do step 1 on the character you're trying to send to first!"] = ""
L["Unknown Profit Queuing"] = "Warteschlange mit Items von unbekannten Profit"
L["Use auction house data from the addon you have selected in the Crafting options for the value of this mat."] = "Benutze die Auktionshausdaten des Addons, dass Sie, in den Herstellungoptionen, für dieses Material gewählt haben."
-- L["Use Lower of Price Sources"] = ""
L["User-Defined Price"] = "Benutzerdefinierter Preis"
L["Use the links on the left to select which page to show."] = "Nutzen Sie die Verknüpfungen (Links) auf der linken Seite um auszuwählen welche Seite angezeigt werden soll."
L["Use the price of buying herbs to mill as the cost of this material."] = "Benutze den Kaufpreis für mahlbare Kräuter als Materialkosten."
L["Use the price that a vendor sells this item for as the cost of this material."] = "Benutze den Verkaufspreis der NPC-Händler als Materialkosten."
L["Vendor"] = "NPC-Händler"
L["Vendor Trade"] = "NPC-Händler Handel"
L["Vendor Trade (x%s)"] = "NPC-Händler Handel (x%s)"
L["Warning: The min restock quantity must be lower than the max restock quantity."] = "Warnung: Die minimale Wiederauffüllungsmenge muss kleiner sein als die maximale."
L[ [=[Warning: Your default minimum restock quantity is higher than your maximum restock quantity! Visit the "Craft Management Window" section of the Crafting options to fix this!

You will get error messages printed out to chat if you try and perform a restock queue without fixing this.]=] ] = "Warnung: Ihre minimale standard Wiederauffüllungsmenge ist größer als Ihre maximale Wiederauffüllungsmenge. Gehen Sie in die \"Craft Management Window\" Rubrik "
L["Weapon"] = "Waffe"
L["Weapon - Main Hand"] = "Waffe - Waffenhand"
L["Weapon - One Hand"] = "Waffe - Einhand"
L["Weapon - Thrown"] = "Waffe - Wurfwaffe"
L["Weapon - Two Hand"] = "Waffe - Zweihand"
L["When you click on the \"Restock Queue\" button enough of each craft will be queued so that you have this maximum number on hand. For example, if you have 2 of item X on hand and you set this to 4, 2 more will be added to the craft queue."] = "Wenn Sie oft genug auf den \"Restock Queue\" (Warteschlange aufstocken) Kopf drücken, wird jedes Teil in die Warteschlange gesetzt, sodass Sie die maximale (herstellbare) Anzahl vorrätig haben. Zum Beispiel: Wenn Sie 2 mal Item x vorrätig haben und Sie setzten den Wert auf 4, werden 2 weitere der Herstellungsliste hinzugefügt."
L["When you double click on a craft in the top-left portion (queuing portion) of the craft management window, it will increment/decrement this many times."] = "Wenn Sie oben links auf einen Gegenstand doppelklicken (Teile in der Warteschlange) undzwar innerhalb des \"Craft management window\" wird soviele male heruntergezählt / hochgezählt."
L["When you use the \"Restock Queue\" button, it will ignore any items with a seen count below the seen count filter below. The seen count data can be retreived from either Auctioneer or TradeSkillMaster's AuctionDB module."] = "Wenn Sie den Kopf \"Restock Queue\" (Warteschlange wiederauffüllen) benutzen, wird er jeden Artikel der in der gesamtanzahl der im Auktionshaus gesehenen Artikel, unterhalb des Filters liegt, ignorieren."
L["Which group in TSM_Auctioning to add this item to."] = "Welcher Gruppe in TSM_Auctioning soll der Gegenstand hinzugefügt werden."
L["Yellow Gems"] = "Gelbe Edelsteine"
L["You can change the active database profile, so you can have different settings for every character."] = "Sie können das aktuell aktive Datenbank Profil wechseln, damit Sie unterschiedliche Einstellungen für jeden ihrer Charakter haben."
L["You can choose to specify a minimum profit amount (in gold or by percent of cost) for what crafts should be added to the craft queue."] = "Hier können Sie einen bestimmten minimalen Profit Wert für die Güter festlegen (in Gold oder in prozentualen Kosten), welche in die Herstellungsliste übernommen werden sollen."
-- L["You can click on one of the rows of the scrolling table below to view or adjust how the price of a material is calculated."] = ""
L["You can either add every craft to one group or make individual groups for each craft."] = "Sie können entweder alle herstellbaren Items einer Gruppe hinzufügen oder eine eigene Gruppe für jedes Handwerks-Item erstellen."
L["You can either create a new profile by entering a name in the editbox, or choose one of the already exisiting profiles."] = "Sie können entweder ein neues Profil erstellen, indem Sie einen Namen in das Feld schreiben, oder Sie können ein bereits existierendes Profil auswählen."
L["You can select a category that group(s) will be added to or select \"<No Category>\" to not add the group(s) to a category."] = "Sie können eine Klasse auswählen zu der die Gruppe(n) hinzugefügt werden, oder Sie wählen <No Category> (keine Klasse) aus damit die Gruppe(n) keiner Klasse zugeordnet werden."
L["You must have your profession window open in order to use the craft queue. Click on the button below to open it."] = "Um die Herstellungsliste nutzen zu können, müssen Sie Ihr Berufe-Fenster geöffnet haben. Klicken Sie unten auf den Kopf um es zu öffnen."
