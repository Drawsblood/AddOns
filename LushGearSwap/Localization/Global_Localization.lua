-- DO NOT CHANGE THIS FILE THIS LOCALIZATION WILL WORK ON ALL LANGUAGES --

LGS_ITEM_CLASS_WEAPON 		= select(1, GetAuctionItemClasses());

LGS_ITEM_SUBCLASS_2HAXE 	= select(2, GetAuctionItemSubClasses(1));
LGS_ITEM_SUBCLASS_2HMACE 	= select(6, GetAuctionItemSubClasses(1));
LGS_ITEM_SUBCLASS_POLEARMS 	= select(7, GetAuctionItemSubClasses(1));
LGS_ITEM_SUBCLASS_2HSWORDS 	= select(9, GetAuctionItemSubClasses(1));
LGS_ITEM_SUBCLASS_STAVES 	= select(10, GetAuctionItemSubClasses(1));

LGS_SPELL_TITANS_GRIP 		= select(1, GetSpellInfo(46917));

LGS_UISTRINGPASSER_EQUIPMENT_SETS = "^" .. EQUIPMENT_SETS:gsub("%%s", "(.+)") .. "$";

LushGearSwap_ZoneSwapLocaitons["Battlegrounds"] = {}

-- [[ Move once localization has been done. ]] --
StaticPopupDialogs["LUSHGEARSWAP_UPDATESET"] = {
	text = "Are you sure you want to update '%s'?",
	button1 = "Yes",
	button2 = "No",
}