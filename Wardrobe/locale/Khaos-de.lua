--[[
--------------------------------------------------
	File: localization.de.lua
	Addon: Wardrobe
	Language: German
	Translation by : Gillion, StarDust
	Last Update : 01/03/2007
--------------------------------------------------
]]--

if (not WardrobeText) then
	WardrobeText = {};
end

--Localization.RegisterGlobalAddonStrings("deDE", "Wardrobe", {
if (GetLocale() == "deDE") then

	-- Binding Configuration
	BINDING_HEADER_WARDROBE_HEADER	= "Garderobe";
	BINDING_NAME_WARDROBE_AUTO_SWAP_BINDING = "Automatisches Umziehen ein-/ausschalten";
	BINDING_NAME_WARDROBE1_BINDING	= "Ausstattung 1";
	BINDING_NAME_WARDROBE2_BINDING	= "Ausstattung 2";
	BINDING_NAME_WARDROBE3_BINDING	= "Ausstattung 3";
	BINDING_NAME_WARDROBE4_BINDING	= "Ausstattung 4";
	BINDING_NAME_WARDROBE5_BINDING	= "Ausstattung 5";
	BINDING_NAME_WARDROBE6_BINDING	= "Ausstattung 6";
	BINDING_NAME_WARDROBE7_BINDING	= "Ausstattung 7";
	BINDING_NAME_WARDROBE8_BINDING	= "Ausstattung 8";
	BINDING_NAME_WARDROBE9_BINDING	= "Ausstattung 9";
	BINDING_NAME_WARDROBE10_BINDING = "Ausstattung 10";
	BINDING_NAME_WARDROBE11_BINDING = "Ausstattung 11";
	BINDING_NAME_WARDROBE12_BINDING = "Ausstattung 12";
	BINDING_NAME_WARDROBE13_BINDING = "Ausstattung 13";
	BINDING_NAME_WARDROBE14_BINDING = "Ausstattung 14";
	BINDING_NAME_WARDROBE15_BINDING = "Ausstattung 15";
	BINDING_NAME_WARDROBE16_BINDING = "Ausstattung 16";
	BINDING_NAME_WARDROBE17_BINDING = "Ausstattung 17";
	BINDING_NAME_WARDROBE18_BINDING = "Ausstattung 18";
	BINDING_NAME_WARDROBE19_BINDING = "Ausstattung 19";
	BINDING_NAME_WARDROBE20_BINDING = "Ausstattung 20";

end
--})

--Localization.RegisterAddonStrings("deDE", "Wardrobe",
WardrobeText["deDE"] = {

	-- ------------------------
	-- Deutsche Sonderzeichen !
	-- ä = \195\164
	-- Ä = \195\132
	-- ü = \195\188
	-- Ü = \195\156
	-- ö = \195\182
	-- Ö = \195\150
	-- ß = \195\159
	-- ------------------------

	-- Configuration
	CONFIG_HEADER		= "Garderobe";
	CONFIG_HEADER_INFO	= "Garderobe erm\195\182glicht das Erstellen und den Wechsel von bis zu 20 Ausr\195\188stungsprofilen.";

	CONFIG_ENABLED		= "Garderobe aktivieren";
	CONFIG_ENABLED_INFO	= "Anklicken um Garderobe zu aktivieren.";

	CONFIG_RESET_BUTTON	= "R\195\188cksetzen";
	CONFIG_RESET		= "Daten von Garderobe zur\195\188cksetzen";
	CONFIG_RESET_INFO	= "Alle Ausstattungen l\195\182schen!";
	CONFIG_RESET_FEEDBACK	= "Alle Ausstattungen wurden gel\195\182scht.";

	CONFIG_KEY_HEADER	= "Farblegende der Ausstattungen";

	CONFIG_OPTIONS_HEADER	= "Einstellungen";

	CONFIG_WEAROUTFIT	= "Ausstattung anlegen";
	CONFIG_WEAROUTFIT_INFO	= "Die gew\195\164hlte Ausstattung anlegen.";
	CONFIG_WEAROUTFIT_FEEDBACK = "Du hast \"%s\" angelegt.";

	CONFIG_EDIT_BUTTON	= "Bearbeiten";
	CONFIG_EDIT		= "Ausstattungen bearbeiten";
	CONFIG_EDIT_INFO	= "Das Einstellungsfenster der Ausstattung \195\182ffnen.";
	CONFIG_EDIT_FEEDBACK	= "\195\150ffne das Einstellungsfenster der Ausstattung.";

	CONFIG_AUTOSWAP		= "Automatischer Wechsel";
	CONFIG_AUTOSWAP_INFO	= "Erlaubt es bestimmte Ausstattungen automatisch zu wechseln.";

	CONFIG_REQCLICK		= "Men\195\188 der Ausstattungen nur bei Klick anzeigen";
	CONFIG_REQCLICK_INFO	= "Das Men\195\188 der Ausstattungen am Minimap-Button nur anzeigen, wenn jener angeklicket wird.";

	CONFIG_LOCKBUTTON	= "Position des Minimap-Buttons festsetzen";
	CONFIG_LOCKBUTTON_INFO	= "Verhindert, dass der Minimap-Button weiter verschoben werden kann.";

	CONFIG_DROPDOWNSCALE		= "Skalierung Dropdown-Men\195\188";
	CONFIG_DROPDOWNSCALE_INFO	= "Legt die Skalierung des Dropdown-Men\195\188s fest.";
	CONFIG_DROPDOWNSCALE_FEEDBACK	= "Skalierung des Dropdown-Men\195\188s auf %s%% festgelegt.";

	CHAT_COMMAND_INFO	= "";

	TEXT_MENU_TITLE		= " Ausstattungen";
	TEXT_MENU_OPEN		= "[MEN\195\156]";
	NAME_LABEL		= "Name der momentanen Ausstattungen";

	PLAGUEBUTTON_TIP1	= "Diese Ausstattung anlegen sobald die Pestl\195\164nder betreten werden.";
	MOUNTBUTTON_TIP1	= "Diese Ausstattung beim Reiten anlegen.";
	MOUNTBUTTON_TIP2	= "Das automatische Anlegen der Ausstattung ben\195\182tigt das IsMounted AddOn.";
	EATDRINKBUTTON_TIP1	= "Diese Ausstattung beim Essen oder Trinken anlegen.";
	SWIMBUTTON_TIP1		= "Diese Ausstattung beim Schwimmen anlegen.";
	COLORBUTTON_TIP1	= "Farbe f\195\188r die momentanen Ausstattungen ausw\195\164hlen.";
	EDITBUTTON_TIP1		= "Bearbeiten der ausgew\195\164hlten Ausstattung.";
	UPDATEBUTTON_TIP1	= "Aktualisieren der ausgew\195\164hlten Ausstattung mit der momentan angelegten.";
	DELETEBUTTON_TIP1	= "L\195\182schen der ausgew\195\164hlten Ausstattung.";
	DOWNBUTTON_TIP1		= "Ausgew\195\164hlte Ausstattung in der Liste nach oben bewegen.";
	UPBUTTON_TIP1		= "Ausgew\195\164hlte Ausstattung in der Liste nach unten bewegen.";

	CMD_RESET      = "reset";
	CMD_LIST       = "liste";
	CMD_WEAR       = "anlegen";
	CMD_WEAR2      = "wechseln";
	CMD_WEAR3      = "verwenden";
	CMD_AUTO       = "auto";
	CMD_ON         = "ein";
	CMD_OFF        = "aus";
	CMD_LOCK       = "lock";
	CMD_UNLOCK     = "unlock";
	CMD_CLICK      = "klick";
	CMD_MOUSEOVER  = "mouse\195\188ber";
	CMD_SCALE      = "skalierung";
	CMD_VERSION    = "version";
	CMD_HELP       = "hilfe";

	TXT_ACCEPT		= "Best\195\164tigen";
	TXT_CANCEL		= "Abbrechen";
	TXT_TOGGLE		= "Wechseln";
	TXT_UPDATE              = "Aktualisieren";
	TXT_COLOR		= "Farbe";
	TXT_EDITOUTFITS		= "Ausstattung bearbeiten";
	TXT_NEW			= "Neu";
	TXT_SETTINGS = "Einstellungen";
	TXT_CLOSE		= "Schlie\195\159en";
	TXT_SELECTCOLOR		= "Farbe ausw\195\164hlen";
	TXT_OK			= "OK";
	TXT_WPLAGUELANDS	= "Westliche Pestl\195\164nder";
	TXT_EPLAGUELANDS	= "\195\150stliche Pestl\195\164nder";
	TXT_STRATHOLME		= "Stratholme";
	TXT_SCHOLOMANCE		= "Scholomance";
	TXT_NAXX                = "Naxxramas";
	TXT_WARDROBEVERSION	= "Garderoben Version";
	TXT_OUTFITNAMEEXISTS	= "Es gibt bereits eine Ausstattung mit diesem Namen! Bitte gebe einen anderen ein.";
	TXT_USEDUPALL		= "Sie haben alle Ausstattungen verbraucht";
	TXT_OFYOUROUTFITS	= "auf diesem Charakter. L\195\182schen Sie bitte eine vor Erstellung von einem anderen.";
	TXT_OUTFIT		= "Ausstattung";
	TXT_PLEASEENTERNAME	= "Bitte Ausstattungsnamen eingeben zum aktualisieren mit den momentan angelegten Gegenst\195\164nden.";
	TXT_OUTFITNOTEXIST	= "Dieser Ausstattungsname existiert nicht! Bitte einen existierenden Ausstattungsnamen eingeben.";
	TXT_NOTEXISTERROR	= "Ausstattungsname existiert nicht!";
	TXT_UPDATED		= "aktualisiert";
	TXT_DELETED		= "gel\195\182scht.";
	TXT_UNABLETOFIND	= "Ausstattungsname nicht auffindbar";
	TXT_UNABLEFINDERROR	= "Ausstattung nicht auffindbar!";
	TXT_ALLOUTFITSDELETED	= "Alle Ausstattungen wurden gel\195\182scht!";
	TXT_YOURCURRENTARE	= "Die momentanen Ausstattungen sind:";
	TXT_NOOUTFITSFOUND	= "Keine Ausstattung gefunden!";
	TXT_SPECIFYOUTFITTOWEAR = "Bitte Ausstattung w\195\164hlen, die angelegt werde soll.";
	TXT_UNABLEFIND		= "Nicht Auffindbar";
	TXT_INYOURLISTOFOUTFITS = "in der Ausstattungsliste!";
	TXT_SWITCHINGTOOUTFIT	= "Wechsel zu Ausstattung";
	TXT_WARNINGUNABLETOFIND = "ACHTUNG: Gegenstand nicht gefunden";
	TXT_INYOURBAGS		= "in den Taschen!";
	TXT_SWITCHEDTOOUTFIT	= "Garderobe: Wechsel zu Ausstattung";
	TXT_PROBLEMSCHANGING	= "Garderobe: Problem beim Ausstattungswechsel. Taschen k\195\182nnten voll sein.";
	TXT_OUTFITRENAMEDERROR	= "Ausstattung umbenannt.";
	TXT_OUTFITRENAMEDTO	= "Ausstattung umbenannt";
	TXT_TOWORDONLY		= "zu";
	TXT_UNABLETOFINDOUTFIT	= "Ausstattung nicht auffindbar";
	TXT_WILLBEWORNWHENMOUNTED = "wird angelegt beim reiten.";
	TXT_BUTTONLOCKED	= "Wardrobe button locked. To reposition, use /wardrobe unlock";
	TXT_BUTTONUNLOCKED	= "Wardrobe button unlocked. You may reposition the wardrobe button. To lock the button in place, use /wardrobe lock";
	TXT_BUTTONONCLICK       = "Wardrobe menu shown on click.";
	TXT_BUTTONONMOUSEOVER   = "Wardrobe menu shown on mouseover.";
	TXT_MOUNTEDNOTEXIST	= "Diese Ausstattung existiert nicht. Bitte eine exsistierende Ausstattung angeben.";
	TXT_ERRORINCONFIG	= "Fehler in ShowWardrobeConfigurationScreen: Config.DefaultCheckboxState hat einen unbekannten Wert ";
	TXT_CHANGECANCELED	= "Garderobenwechsel abgebrochen!";
	TXT_NEWOUTFITNAME	= "Neuer Ausstattungsname";
	TXT_NOLONGERWORNMOUNTERR= "wird nicht mehr beim reiten angelegt.";
	TXT_WORNWHENMOUNTERR	= "wird nun beim reiten angelegt.";
	TXT_NOLONGERWORNPLAGUEERR = "wird nicht mehr in den Pestl\195\164ndern angelegt.";
	TXT_WORNPLAGUEERR	= "wird nun in den Pestl\195\164ndern angelegt.";
	TXT_NOLONGERWORNEATERR	= "wird nicht mehr beim Essen / Trinken angelegt.";
	TXT_WORNEATERR		= "wird nun beim Essen / Trinken angelegt.";
	TXT_WORNSWIMR		= "wird nun beim Schwimmen angelegt.";
	TXT_NOLONGERWORNSWIMR	= "wird nicht mehr beim Schwimmen angelegt.";
	TXT_REALLYDELETEOUTFIT	= "Ausstattung wirklich l\195\182schen?";
	TXT_PLEASESELECTDELETE	= "Ausstattung zum L\195\182schen ausw\195\164hlen!";
	TXT_WARDROBENAME	= "Garderobe";
	TXT_WARDROBEBUTTON	= "Garderobe Button";
	TXT_ENABLED		= "Garderobe aktiviert.";
	TXT_DISABLED		= "Garderobe deaktiviert.";
	TXT_NO_OUTFIT		= "<kein Ausstattung>";
	TXT_AUTO_ENABLED	= "Automatischer Wechsel aktiviert.";
	TXT_AUTO_DISABLED	= "Automatischer Wechsel deaktiviert.";

	HELP_1		= "Die Garderobe, ein AddOn von AnduinLothar, Miravlix und Cragganmore. Version ";
	HELP_2		= "Die Garderobe erlaubt es dir bis zu 20 verschiedene Ausstattungen zu speichern.";
	HELP_3		= "Das Hauptmen\195\188 kann standardm\195\164\195\159ig \195\188ber das Garderobe-Icon";
	HELP_4		= "neben der Minimap aufgerufen werden. Du kannst aber auch folgende Chatbefehle verwenden:";
	HELP_5		= "Benutzung: /wardrobe <anlegen/liste/reset/lock/unlock/klick/mouse\195\188ber/skalierung>";
	HELP_6		= "   anlegen [Ausstattung] - Die angegebene Ausstattung anlegen.";
	HELP_7		= "   liste - Auflistung aller Ausstattungen.";
	HELP_8		= "   reset - Alle Ausstattungen der Garderobe l\195\182schen.";
	HELP_9		= "   lock/unlock- Minimap-Button festsetzen oder wieder verschiebbar machen.";
	HELP_10		= "   klick/mouse\195\188ber - Das Men\195\188 der Garderobe beim Anklichen / Maus\195\188ber anzeigen.";
	HELP_11		= "   skalierung [0.5 - 1.0] - Die Skalierung des Dropdown-Men\195\188s festlegen.";
	HELP_12		= "Im UI werden Ausstattungen nach folgendem Schema eingef\195\164rbt:";
	HELP_13		= "   Leuchtend: Die monmentan angelegte Ausstattung.";
	HELP_14		= "   Matt: Eine Ausstattung, wo zumindest ein Gegenstand momentan nicht angelegt ist.";
	HELP_15		= "   Grau: Eine Ausstattung, wo sich zumindest ein Gegenstand momentan nicht in den Taschen befindet.";
	HELP_16		= "   Grau markierte Ausstattungen k\195\182nnen trotzdem angelegt werden. Die fehlene Gegenst\195\164nde werden einfach nicht angelegt.";

}--)