local portal = GetCVar( "Portal" )

local ConnectedRealms = { }
local tempData

if portal == "US" then
	ArkInventory.Output( "Loading Connected Realm (", portal, ") Data" )
	tempData = {
		{ ["Aegwynn"]=true, ["Bonechewer"]=true, ["Daggerspine"]=true, ["Gurubashi"]=true, ["Hakkar"]=true },
		{ ["Aerie Peak"]=true, ["Ulduar"]=true },
		{ ["Agamaggan"]=true, ["Archimonde"]=true, ["Burning Legion"]=true, ["Jaedenar"]=true, ["The Underbog"]=true },
		{ ["Aggramar"]=true, ["Fizzcrank"]=true },
		{ ["Akama"]=true, ["Dragonmaw"]=true, ["Mug'thol"]=true },
		{ ["Alleria"]=true, ["Khadgar"]=true },
		{ ["Alexstrasza"]=true, ["Terokkar"]=true },
		{ ["Altar of Storms"]=true, ["Anetheron"]=true, ["Magtheridon"]=true, ["Ysondre"]=true },
		{ ["Alterac Mountains"]=true, ["Balnazzar"]=true, ["Gorgonnash"]=true, ["The Forgotten Coast"]=true, ["Warsong"]=true },
		{ ["Andorhal"]=true, ["Scilla"]=true, ["Ursin"]=true, ["Zuluhed"]=true },
		{ ["Antonidas"]=true, ["Uldum"]=true },
		{ ["Anub'arak"]=true, ["Chromaggus"]=true, ["Chrushridge"]=true, ["Garithos"]=true, ["Nathrezim"]=true, ["Smolderthorn"]=true },
		{ ["Anvilmar"]=true, ["Undermine"]=true },
		{ ["Argent Dawn"]=true, ["The Scryers"]=true },
		{ ["Arygos"]=true, ["Llane"]=true },
		{ ["Auchindoun"]=true, ["Cho'gall"]=true, ["Laughing Skull"]=true },
		{ ["Azgalor"]=true, ["Azshara"]=true, ["Destromath"]=true, ["Thunderlord"]=true },
		{ ["Azjol-Nerub"]=true, ["Khaz Modan"]=true },
		{ ["Azuremyst"]=true, ["Staghelm"]=true },
		{ ["Black Dragonflight"]=true, ["Gul'dan"]=true, ["Skullcrusher"]=true },
		{ ["Blackhand"]=true, ["Galakrond"]=true },
		{ ["Blackwater Raiders"]=true, ["Shadow Council"]=true },
		{ ["Blackwing Lair"]=true, ["Dethecus"]=true, ["Detheroc"]=true, ["Haomarush"]=true, ["Lethon"]=true, ["Shadowmoon"]=true },
		{ ["Bladefist"]=true, ["Kul Tiras"]=true },
		{ ["Blade's Edge"]=true, ["Thunderhorn"]=true },
		{ ["Blood Furnace"]=true, ["Mannaroth"]=true, ["Nazjatar"]=true },
		{ ["Bloodscalp"]=true, ["Boulderfist"]=true, ["Dunemaul"]=true, ["Maiev"]=true, ["Stonemaul"]=true },
		{ ["Borean Tundra"]=true, ["Shadowsong"]=true },
		{ ["Bronzebeard"]=true, ["Shandris"]=true },
		{ ["Burning Blade"]=true, ["Lightning's Blade"]=true, ["Onyxia"]=true },
		{ ["Cairne"]=true, ["Perenolde"]=true },
		{ ["Coilfang"]=true, ["Dark Iron"]=true, ["Dalvengyr"]=true, ["Demon Soul"]=true, ["Shattered Hand"]=true },
		{ ["Dawnbringer"]=true, ["Madoran"]=true },
		{ ["Darrowmere"]=true, ["Windrunner"]=true },
		{ ["Dath'Remar"]=true, ["Khaz'goroth"]=true },
		{ ["Dentarg"]=true, ["Whisperwind"]=true },
		{ ["Draenor"]=true, ["Echo Isles"]=true },
		{ ["Draka"]=true, ["Suramar"]=true },
		{ ["Drak'Tharon"]=true, ["Firetree"]=true, ["Malorne"]=true, ["Rivendare"]=true, ["Spirestone"]=true, ["Stormscale"]=true },
		{ ["Drak'thul"]=true, ["Skywall"]=true },
		{ ["Dreadmaul"]=true, ["Thaurissan"]=true },
		{ ["Drenden"]=true, ["Arathor"]=true },
		{ ["Duskwood"]=true, ["Bloodhoof"]=true },
		{ ["Durotan"]=true, ["Ysera"]=true },
		{ ["Eitrigg"]=true, ["Shu'halo"]=true },
		{ ["Eldre'Thalas"]=true, ["Korialstrasz"]=true },
		{ ["Elune"]=true, ["Gilneas"]=true },
		{ ["Eonar"]=true, ["Velen"]=true },
		{ ["Eredar"]=true, ["Gorefiend"]=true, ["Spinebreaker"]=true, ["Wildhammer"]=true },
		{ ["Deathwing"]=true, ["Executus"]=true, ["Kalecgos"]=true, ["Shattered Halls"]=true },
		{ ["Exodar"]=true, ["Medivh"]=true },
		{ ["Farstriders"]=true, ["Silver Hand"]=true, ["Thorium Brotherhood"]=true },
		{ ["Fenris"]=true, ["Dragonblight"]=true },
		{ ["Frostmane"]=true, ["Ner'zhul"]=true, ["Tortheldrin"]=true },
		{ ["Frostwolf"]=true, ["Vashj"]=true },
		{ ["Ghostlands"]=true, ["Kael'thas"]=true },
		{ ["Gnomeregan"]=true, ["Moonrunner"]=true },
		{ ["Grizzly Hills"]=true, ["Lothar"]=true },
		{ ["Gundrak"]=true, ["Jubei'Thos"]=true },
		{ ["Hellscream"]=true, ["Zangarmarsh"]=true },
		{ ["Hydraxis"]=true, ["Terenas"]=true },
		{ ["Icecrown"]=true, ["Malygos"]=true },
		{ ["Kargath"]=true, ["Norgannon"]=true },
		{ ["Kilrogg"]=true, ["Winterhoof"]=true },
		{ ["Kirin Tor"]=true, ["Sentinels"]=true, ["Steamwheedle Cartel"]=true },
		{ ["Malfurion"]=true, ["Trollbane"]=true },
		{ ["Misha"]=true, ["Rexxar"]=true },
		{ ["Mok'Nathal"]=true, ["Silvermoon"]=true },
		{ ["Nagrand"]=true, ["Caelestrasz"]=true },
		{ ["Nazgrel"]=true, ["Nesingwary"]=true, ["Vek'nilash"]=true },
		{ ["Nordrassil"]=true, ["Muradin"]=true },
		{ ["Quel'dorei"]=true, ["Sen'jin"]=true },
		{ ["Runetotem"]=true, ["Uther"]=true },
		{ ["Scarlet Crusade"]=true, ["Feathermoon"]=true },
		{ ["Tanaris"]=true, ["Greymane"]=true },
		{ ["Uldaman"]=true, ["Ravencrest"]=true },
	}
end


if portal == "EU" then
	ArkInventory.Output( "Loading Connected Realm (", portal, ") Data" )
	tempData = {
		--ENGLISH
		{ ["Aggramar"]=true, ["Hellscream"]=true },
		{ ["Arathor"]=true, ["Hellfire"]=true },
		{ ["Bloodfeather"]=true, ["Burning Steppes"]=true, ["Executus"]=true, ["Kor'gall"]=true, ["Shattered Hand"]=true },
		{ ["Kilrogg"]=true, ["Nagrand"]=true, ["Runetotem"]=true },
		{ ["Thunderhorn"]=true, ["Wildhammer"]=true },
		{ ["Azjol-Nerub"]=true, ["Quel'Thalas"]=true },
		{ ["Dragonblight"]=true, ["Ghostlands"]=true },
		{ ["Darkspear"]=true, ["Terokkar"]=true },
		{ ["Aszune"]=true, ["Shadowsong"]=true },
		{ ["Shattered Halls"]=true, ["Balnazzar"]=true, ["Ahn'Qiraj"]=true, ["Trollbane"]=true, ["Talnivarr"]=true, ["Chromaggus"]=true, ["Boulderfist"]=true, ["Daggerspine"]=true, ["Laughing Skull"]=true, ["Sunstrider"]=true },
		{ ["Emeriss"]=true, ["Agamaggan"]=true, ["Hakkar"]=true, ["Crushridge"]=true, ["Bloodscalp"]=true },
		{ ["Grim Batol"]=true, ["Aggra"]=true },
		{ ["Karazhan"]=true, ["Lightning's Blade"]=true, ["Deathwing"]=true, ["The Maelstrom"]=true },
		{ ["Auchindoun"]=true, ["Dunemaul"]=true, ["Jaedenar"]=true },
		{ ["Dragonmaw"]=true, ["Spinebreaker"]=true, ["Haomarush"]=true, ["Vashj"]=true, ["Stormreaver"]=true },
		{ ["Zenedar"]=true, ["Bladefist"]=true, ["Frostwhisper"]=true },
		{ ["Xavius"]=true, ["Skullcrusher"]=true },
		{ ["Darksorrow"]=true, ["Genjuros"]=true, ["Neptulon"]=true },
		{ ["Drak'thul"]=true, ["Burning Blade"]=true },
		{ ["Moonglade"]=true, ["The Sha'tar"]=true },
		{ ["Darkmoon Faire"]=true, ["Earthen Ring"]=true },
		{ ["Scarshield Legion"]=true, ["Ravenholdt"]=true, ["The Venture Co"]=true, ["Sporeggar"]=true },
		-- FRENCH
		{ ["Cho'gall"]=true, ["Eldre'Thalas"]=true, ["Sinstralis"]=true },
		{ ["Dalaran"]=true, ["Marécage de Zangar"]=true },
		{ ["Elune"]=true, ["Varimathras"]=true },
		{ ["Eitrigg"]=true, ["Krasus"]=true },
		{ ["Medivh"]=true, ["Suramar"]=true },
		{ ["Arak-arahm"]=true, ["Throk'Feroth"]=true, ["Rashgarroth"]=true },
		{ ["Naxxramas"]=true, ["Arathi"]=true, ["Temple Noir"]=true, ["Illidan"]=true },
		{ ["Garona"]=true, ["Ner'zhul"]=true },
		{ ["Confrerie du Thorium"]=true, ["Les Clairvoyants"]=true },
		{ ["La Croisade écarlate"]=true, ["Culte de la Rive noire"]=true, ["Conseil des Ombres"]=true },
		-- GERMAN
		{ ["Alexstrasza"]=true, ["Nethersturm"]=true },
		{ ["Ambossar"]=true, ["Kargath"]=true },
		{ ["Anetheron"]=true, ["Festung der Stürme"]=true, ["Gul'dan"]=true, ["Rajaxx"]=true },
		{ ["Area 52"]=true, ["Sen'jin"]=true, ["Un'Goro"]=true },
		{ ["Arthas"]=true, ["Blutkessel"]=true, ["Vek'lor"]=true },
		{ ["Azshara"]=true, ["Krag'jin"]=true },
		{ ["Dalvengyr"]=true, ["Nazjatar"]=true },
		{ ["Das Syndikat"]=true, ["Die Arguswacht"]=true, ["Die Todeskrallen"]=true, ["Der Abyssische Rat"]=true },
		{ ["Dethecus"]=true, ["Mug'thol"]=true, ["Terrordar"]=true, ["Theradras"]=true },
		{ ["Echsenkessel"]=true, ["Mal'Ganis"]=true, ["Taerar"]=true },
		{ ["Garrosh"]=true, ["Nozdormu"]=true, ["Shattrath"]=true },
		{ ["Gilneas"]=true, ["Ulduar"]=true },
		{ ["Malfurion"]=true, ["Malygos"]=true },
		{ ["Malorne"]=true, ["Ysera"]=true },
		-- SPANISH
		{ ["Exodar"]=true, ["Minahonda"]=true },
		{ ["Colinas Pardas"]=true, ["Los Errantes"]=true, ["Tyrande"]=true },
		{ ["Sanguino"]=true, ["Shen'dralar"]=true, ["Uldum"]=true, ["Zul'jin"]=true },
		-- RUSSIAN
		{ ["Подземье"]=true, ["Разувий"]=true },
	}
end


function ArkInventory.IsConnectedRealm( a, b )
	if ConnectedRealms[a] then
		return ConnectedRealms[a][b]
	end
end

if tempData then
	
	for _, v in pairs( tempData ) do
		
		for x in pairs( v ) do
			
			if ConnectedRealms[x] then
				ArkInventory.OutputWarning( "duplicate connected realm (", portal, ") data found for ", x )
			else
				ConnectedRealms[x] = v
			end
			
		end
		
	end
	
	table.wipe( tempData )
	tempData = nil
	
end
