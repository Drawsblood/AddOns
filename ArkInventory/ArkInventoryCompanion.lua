﻿local _G = _G
local select = _G.select
local pairs = _G.pairs
local ipairs = _G.ipairs
local string = _G.string
local type = _G.type
local error = _G.error
local table = _G.table

ArkInventory.Const.ItemCrossReference = {
--[[
	["class:xxxx"] = { "class:yyyy" = true }
]]--
}

local TempData = { -- temporary table for item to spell translations.
-- see ArkInventoryCompanion.xls (sourced from wowhead and user feedback)

-- [itemid] = {sid=ddddd,cid=ddddd,r={'aaaaa'}}
-- sid = spell id for mount
-- cid = critter id for battlepet
-- r = { restrictions }
-- only zone based restrictions are checked

[1132]={sid=580,mt=0x01}, -- Horn of the Timber Wolf
[2411]={sid=470,mt=0x01}, -- Black Stallion Bridle
[2414]={sid=472,mt=0x01}, -- Pinto Bridle
[5655]={sid=6648,mt=0x01}, -- Chestnut Mare Bridle
[5656]={sid=458,mt=0x01}, -- Brown Horse Bridle
[5665]={sid=6653,mt=0x01}, -- Horn of the Dire Wolf
[5668]={sid=6654,mt=0x01}, -- Horn of the Brown Wolf
[5864]={sid=6777,mt=0x01}, -- Gray Ram
[5872]={sid=6899,mt=0x01}, -- Brown Ram
[5873]={sid=6898,mt=0x01}, -- White Ram
[8563]={sid=10873,mt=0x01}, -- Red Mechanostrider
[8586]={sid=16084,mt=0x01}, -- Whistle of the Mottled Red Raptor
[8588]={sid=8395,mt=0x01}, -- Whistle of the Emerald Raptor
[8591]={sid=10796,mt=0x01}, -- Whistle of the Turquoise Raptor
[8592]={sid=10799,mt=0x01}, -- Whistle of the Violet Raptor
[8595]={sid=10969,mt=0x01}, -- Blue Mechanostrider
[8627]={sid=10787,mt=0x01}, -- Reins of the Nightsaber / Black Nightsaber
[8628]={sid=10792,mt=0x01}, -- Reins of the Spotted Nightsaber / Spotted Panther
[8629]={sid=10793,mt=0x01}, -- Reins of the Striped Nightsaber
[8631]={sid=8394,mt=0x01}, -- Reins of the Striped Frostsaber
[8632]={sid=10789,mt=0x01}, -- Reins of the Spotted Frostsaber
[12302]={sid=16056,mt=0x01}, -- Reins of the Ancient Frostsaber
[12303]={sid=16055,mt=0x01}, -- Reins of the Nightsaber / Black Nightsaber
[12330]={sid=16080,mt=0x01}, -- Horn of the Red Wolf
[12351]={sid=16081,mt=0x01}, -- Horn of the Arctic Wolf / Winter Wolf
[12353]={sid=16083,mt=0x01}, -- White Stallion Bridle
[12354]={sid=16082,mt=0x01}, -- Palomino Bridle
[13086]={sid=17229,mt=0x01}, -- Reins of the Winterspring Frostsaber
[13317]={sid=17450,mt=0x01}, -- Whistle of the Ivory Raptor
[13321]={sid=17453,mt=0x01}, -- Green Mechanostrider
[13322]={sid=17454,mt=0x01}, -- Unpainted Mechanostrider
[13326]={sid=15779,mt=0x01}, -- White Mechanostrider Mod B
[13327]={sid=17459,mt=0x01}, -- Icy Blue Mechanostrider Mod A
[13328]={sid=17461,mt=0x01}, -- Black Ram
[13329]={sid=17460,mt=0x01}, -- Frost Ram
[13331]={sid=17462,mt=0x01}, -- Red Skeletal Horse
[13332]={sid=17463,mt=0x01}, -- Blue Skeletal Horse
[13333]={sid=17464,mt=0x01}, -- Brown Skeletal Horse
[13334]={sid=17465,mt=0x01}, -- Green Skeletal Warhorse
[13335]={sid=17481,mt=0x01}, -- Deathcharger's Reins / Rivendare's Deathcharger
[15277]={sid=18989,mt=0x01}, -- Gray Kodo
[15290]={sid=18990,mt=0x01}, -- Brown Kodo
[15292]={sid=18991,mt=0x01}, -- Green Kodo
[15293]={sid=18992,mt=0x01}, -- Teal Kodo
[16339]={sid=16082,mt=0x01}, -- Commander's Steed / Palomino
[18766]={sid=23221,mt=0x01}, -- Reins of the Swift Frostsaber
[18767]={sid=23219,mt=0x01}, -- Reins of the Swift Mistsaber
[18772]={sid=23225,mt=0x01}, -- Swift Green Mechanostrider
[18773]={sid=23223,mt=0x01}, -- Swift White Mechanostrider
[18774]={sid=23222,mt=0x01}, -- Swift Yellow Mechanostrider
[18776]={sid=23227,mt=0x01}, -- Swift Palomino
[18777]={sid=23229,mt=0x01}, -- Swift Brown Steed
[18778]={sid=23228,mt=0x01}, -- Swift White Steed
[18785]={sid=23240,mt=0x01}, -- Swift White Ram
[18786]={sid=23238,mt=0x01}, -- Swift Brown Ram
[18787]={sid=23239,mt=0x01}, -- Swift Gray Ram
[18788]={sid=23241,mt=0x01}, -- Swift Blue Raptor
[18789]={sid=23242,mt=0x01}, -- Swift Olive Raptor
[18790]={sid=23243,mt=0x01}, -- Swift Orange Raptor
[18791]={sid=23246,mt=0x01}, -- Purple Skeletal Warhorse
[18793]={sid=23247,mt=0x01}, -- Great White Kodo
[18794]={sid=23249,mt=0x01}, -- Great Brown Kodo
[18795]={sid=23248,mt=0x01}, -- Great Gray Kodo
[18796]={sid=23250,mt=0x01}, -- Horn of the Swift Brown Wolf
[18797]={sid=23251,mt=0x01}, -- Horn of the Swift Timber Wolf
[18798]={sid=23252,mt=0x01}, -- Horn of the Swift Gray Wolf
[18902]={sid=23338,mt=0x01}, -- Reins of the Swift Stormsaber
[19029]={sid=23509,mt=0x01}, -- Horn of the Frostwolf Howler
[19030]={sid=23510,mt=0x01}, -- Stormpike Battle Charger
[19872]={sid=24242,mt=0x01}, -- Swift Razzashi Raptor
[19902]={sid=24252,mt=0x01}, -- Swift Zulian Tiger
[21176]={sid=26656,mt=0x01}, -- Black Qiraji Resonating Crystal / Black Qiraji Battle Tank
[21218]={sid=25953,mt=0x01,r={zone = "AHNQIRAJ,AHNQIRAJ_RUINS"}}, -- Blue Qiraji Resonating Crystal / Blue Qiraji Battle Tank
[21321]={sid=26054,mt=0x01,r={zone = "AHNQIRAJ,AHNQIRAJ_RUINS"}}, -- Red Qiraji Resonating Crystal / Red Qiraji Battle Tank
[21323]={sid=26056,mt=0x01,r={zone = "AHNQIRAJ,AHNQIRAJ_RUINS"}}, -- Green Qiraji Resonating Crystal / Green Qiraji Battle Tank
[21324]={sid=26055,mt=0x01,r={zone = "AHNQIRAJ,AHNQIRAJ_RUINS"}}, -- Yellow Qiraji Resonating Crystal / Yellow Qiraji Battle Tank
[23720]={sid=30174,mt=0x01}, -- Riding Turtle
[25470]={sid=32235,mt=0x02}, -- Golden Gryphon
[25471]={sid=32239,mt=0x02}, -- Ebon Gryphon
[25472]={sid=32240,mt=0x02}, -- Snowy Gryphon
[25473]={sid=32242,mt=0x02}, -- Swift Blue Gryphon
[25474]={sid=32243,mt=0x02}, -- Tawny Wind Rider
[25475]={sid=32244,mt=0x02}, -- Blue Wind Rider
[25476]={sid=32245,mt=0x02}, -- Green Wind Rider
[25477]={sid=32246,mt=0x02}, -- Swift Red Wind Rider
[25527]={sid=32289,mt=0x02}, -- Swift Red Gryphon
[25528]={sid=32290,mt=0x02}, -- Swift Green Gryphon
[25529]={sid=32292,mt=0x02}, -- Swift Purple Gryphon
[25531]={sid=32295,mt=0x02}, -- Swift Green Wind Rider
[25532]={sid=32296,mt=0x02}, -- Swift Yellow Wind Rider
[25533]={sid=32297,mt=0x02}, -- Swift Purple Wind Rider
[25596]={sid=32345,mt=0x02}, -- Peep's Whistle / Peep the Phoenix Mount
[28481]={sid=34406,mt=0x01}, -- Brown Elekk
[28915]={sid=39316,mt=0x01}, -- Reins of the Dark Riding Talbuk
[28927]={sid=34795,mt=0x01}, -- Red Hawkstrider
[28936]={sid=33660,mt=0x01}, -- Swift Pink Hawkstrider
[29102]={sid=34896,mt=0x01}, -- Reins of the Cobalt War Talbuk
[29103]={sid=34897,mt=0x01}, -- Reins of the White War Talbuk
[29104]={sid=34898,mt=0x01}, -- Reins of the Silver War Talbuk
[29105]={sid=34899,mt=0x01}, -- Reins of the Tan War Talbuk
[29220]={sid=35020,mt=0x01}, -- Blue Hawkstrider
[29221]={sid=35022,mt=0x01}, -- Black Hawkstrider
[29222]={sid=35018,mt=0x01}, -- Purple Hawkstrider
[29223]={sid=35025,mt=0x01}, -- Swift Green Hawkstrider
[29224]={sid=35027,mt=0x01}, -- Swift Purple Hawkstrider
[29227]={sid=34896,mt=0x01}, -- Reins of the Cobalt War Talbuk
[29228]={sid=34790,mt=0x01}, -- Reins of the Dark War Talbuk
[29229]={sid=34898,mt=0x01}, -- Reins of the Silver War Talbuk
[29230]={sid=34899,mt=0x01}, -- Reins of the Tan War Talbuk
[29231]={sid=34897,mt=0x01}, -- Reins of the White War Talbuk
[29465]={sid=22719,mt=0x01}, -- Black Battlestrider
[29466]={sid=22718,mt=0x01}, -- Black War Kodo
[29467]={sid=22720,mt=0x01}, -- Black War Ram
[29468]={sid=22717,mt=0x01}, -- Black War Steed Bridle
[29469]={sid=22724,mt=0x01}, -- Horn of the Black War Wolf
[29470]={sid=22722,mt=0x01}, -- Red Skeletal Warhorse
[29471]={sid=22723,mt=0x01}, -- Reins of the Black War Tiger
[29472]={sid=22721,mt=0x01}, -- Whistle of the Black War Raptor
[29743]={sid=35711,mt=0x01}, -- Purple Elekk
[29744]={sid=35710,mt=0x01}, -- Gray Elekk
[29745]={sid=35713,mt=0x01}, -- Great Blue Elekk
[29746]={sid=35712,mt=0x01}, -- Great Green Elekk
[29747]={sid=35714,mt=0x01}, -- Great Purple Elekk
[30480]={sid=36702,mt=0x01}, -- Fiery Warhorse's Reins
[30609]={sid=37015,mt=0x02}, -- Swift Nether Drake
[31829]={sid=39315,mt=0x01}, -- Reins of the Cobalt Riding Talbuk
[31830]={sid=39315,mt=0x01}, -- Reins of the Cobalt Riding Talbuk
[31831]={sid=39317,mt=0x01}, -- Reins of the Silver Riding Talbuk
[31832]={sid=39317,mt=0x01}, -- Reins of the Silver Riding Talbuk
[31833]={sid=39318,mt=0x01}, -- Reins of the Tan Riding Talbuk
[31834]={sid=39318,mt=0x01}, -- Reins of the Tan Riding Talbuk
[31835]={sid=39319,mt=0x01}, -- Reins of the White Riding Talbuk
[31836]={sid=39319,mt=0x01}, -- Reins of the White Riding Talbuk
[32314]={sid=39798,mt=0x02}, -- Green Riding Nether Ray
[32316]={sid=39801,mt=0x02}, -- Purple Riding Nether Ray
[32317]={sid=39800,mt=0x02}, -- Red Riding Nether Ray
[32318]={sid=39802,mt=0x02}, -- Silver Riding Nether Ray
[32319]={sid=39803,mt=0x02}, -- Blue Riding Nether Ray
[32458]={sid=40192,mt=0x02}, -- Ashes of Al'ar
[32768]={sid=41252,mt=0x01}, -- Reins of the Raven Lord
[32857]={sid=41513,mt=0x02}, -- Reins of the Onyx Netherwing Drake
[32858]={sid=41514,mt=0x02}, -- Reins of the Azure Netherwing Drake
[32859]={sid=41515,mt=0x02}, -- Reins of the Cobalt Netherwing Drake
[32860]={sid=41516,mt=0x02}, -- Reins of the Purple Netherwing Drake
[32861]={sid=41517,mt=0x02}, -- Reins of the Veridian Netherwing Drake
[32862]={sid=41518,mt=0x02}, -- Reins of the Violet Netherwing Drake
-- item 33176 Flying Broom
-- item 33182 Swift Flying Broom
-- item 33183 Old Magic Broom
-- item 33184 Swift Magic Broom
-- item 33189 Rickety Magic Broom
[33809]={sid=43688,mt=0x01}, -- Amani War Bear
[33976]={sid=43899,mt=0x01}, -- Brewfest Ram
[33977]={sid=43900,mt=0x01}, -- Swift Brewfest Ram
[33999]={sid=43927,mt=0x02}, -- Cenarion War Hippogryph
[34060]={sid=44153,mt=0x02}, -- Flying Machine Control
[34061]={sid=44151,mt=0x02}, -- Turbo-Charged Flying Machine Control
[34092]={sid=44744,mt=0x02}, -- Merciless Nether Drake
[34129]={sid=35028,mt=0x01}, -- Swift Warstrider
[35513]={sid=46628,mt=0x01}, -- Swift White Hawkstrider
[35906]={sid=48027,mt=0x01}, -- Reins of the Black War Elekk
-- item 37011 Magic Broom
[37012]={sid=48025,mt=0x02}, -- The Horseman's Reins / Headless Horseman's Mount
[37676]={sid=49193,mt=0x02}, -- Vengeful Nether Drake
[37719]={sid=49322,mt=0x01}, -- Swift Zhevra
[37827]={sid=50869,mt=0x01}, -- Brewfest Kodo
[37828]={sid=49379,mt=0x01}, -- Great Brewfest Kodo
[40775]={sid=54729,mt=0x02}, -- Winged Steed of the Ebon Blade / Death Knight
[41508]={sid=55531,mt=0x01}, -- Mechano-hog
[43516]={sid=58615,mt=0x02}, -- Brutal Nether Drake
[43599]={sid=58983,mt=0x01}, -- Big Blizzard Bear
[43951]={sid=59569,mt=0x02}, -- Reins of the Bronze Drake
[43952]={sid=59567,mt=0x02}, -- Reins of the Azure Drake
[43953]={sid=59568,mt=0x02}, -- Reins of the Blue Drake
[43954]={sid=59571,mt=0x02}, -- Reins of the Twilight Drake
[43955]={sid=59570,mt=0x02}, -- Reins of the Red Drake
[43956]={sid=59785,mt=0x01}, -- Reins of the Black War Mammoth
[43958]={sid=59799,mt=0x01}, -- Reins of the Ice Mammoth
[43959]={sid=61465,mt=0x01}, -- Reins of the Grand Black War Mammoth
[43961]={sid=61470,mt=0x01}, -- Reins of the Grand Ice Mammoth
[43962]={sid=54753,mt=0x01}, -- Reins of the White Polar Bear
[43986]={sid=59650,mt=0x02}, -- Reins of the Black Drake
[44077]={sid=59788,mt=0x01}, -- Reins of the Black War Mammoth
[44080]={sid=59797,mt=0x01}, -- Reins of the Ice Mammoth
[44083]={sid=61467,mt=0x01}, -- Reins of the Grand Black War Mammoth
[44086]={sid=61469,mt=0x01}, -- Reins of the Grand Ice Mammoth
[44151]={sid=59996,mt=0x02}, -- Reins of the Blue Proto-Drake
[44160]={sid=59961,mt=0x02}, -- Reins of the Red Proto-Drake
[44164]={sid=59976,mt=0x02}, -- Reins of the Black Proto-Drake
[44168]={sid=60002,mt=0x02}, -- Reins of the Time-Lost Proto-Drake
[44175]={sid=60021,mt=0x02}, -- Reins of the Plagued Proto-Drake
[44177]={sid=60024,mt=0x02}, -- Reins of the Violet Proto-Drake
[44178]={sid=60025,mt=0x02}, -- Reins of the Albino Drake
-- item 44221 Loaned Gryphon Reins
[44223]={sid=60118,mt=0x01}, -- Reins of the Black War Bear
[44224]={sid=60119,mt=0x01}, -- Reins of the Black War Bear
[44225]={sid=60114,mt=0x01}, -- Reins of the Armored Brown Bear
[44226]={sid=60116,mt=0x01}, -- Reins of the Armored Brown Bear
-- item 44229 Loaned Wind Rider Reins
[44230]={sid=59791,mt=0x01}, -- Reins of the Wooly Mammoth
[44231]={sid=59793,mt=0x01}, -- Reins of the Wooly Mammoth
[44234]={sid=61447,mt=0x01}, -- Reins of the Traveler's Tundra Mammoth
[44235]={sid=61425,mt=0x01}, -- Reins of the Traveler's Tundra Mammoth
[44413]={sid=60424,mt=0x02}, -- Mekgineer's Chopper
[44554]={sid=61451,mt=0x02}, -- Flying Carpet
[44558]={sid=61309,mt=0x02}, -- Magnificent Flying Carpet
[44689]={sid=61229,mt=0x02}, -- Armored Snowy Gryphon
[44690]={sid=61230,mt=0x02}, -- Armored Blue Wind Rider
[44707]={sid=61294,mt=0x02}, -- Reins of the Green Proto-Drake
[44842]={sid=61997,mt=0x02}, -- Red Dragonhawk Mount
[44843]={sid=61996,mt=0x02}, -- Blue Dragonhawk Mount
[45125]={sid=63232,mt=0x01}, -- Stormwind Steed
[45586]={sid=63636,mt=0x01}, -- Ironforge Ram
[45589]={sid=63638,mt=0x01}, -- Gnomeregan Mechanostrider
[45590]={sid=63639,mt=0x01}, -- Exodar Elekk
[45591]={sid=63637,mt=0x01}, -- Darnassian Nightsaber
[45592]={sid=63641,mt=0x01}, -- Thunder Bluff Kodo
[45593]={sid=63635,mt=0x01}, -- Darkspear Raptor
[45595]={sid=63640,mt=0x01}, -- Orgrimmar Wolf
[45596]={sid=63642,mt=0x01}, -- Silvermoon Hawkstrider
[45597]={sid=63643,mt=0x01}, -- Forsaken Warhorse
[45693]={sid=63796,mt=0x02}, -- Mimiron's Head
[45725]={sid=63844,mt=0x02}, -- Argent Hippogryph
[45801]={sid=63956,mt=0x02}, -- Reins of the Ironbound Proto-Drake
[45802]={sid=63963,mt=0x02}, -- Reins of the Rusted Proto-Drake
[46099]={sid=64658,mt=0x01}, -- Horn of the Black Wolf
[46100]={sid=64657,mt=0x01}, -- White Kodo
[46101]={sid=64656,mt=0x01}, -- Blue Skeletal Warhorse
[46102]={sid=64659,mt=0x01}, -- Whistle of the Venomhide Ravasaur
[46109]={sid=64731,mt=0x08}, -- Sea Turtle
[46171]={sid=65439,mt=0x02}, -- Furious Gladiator's Frost Wyrm
[46308]={sid=64977,mt=0x01}, -- Black Skeletal Horse
[46708]={sid=64927,mt=0x02}, -- Deadly Gladiator's Frost Wyrm
[46743]={sid=65644,mt=0x01}, -- Swift Purple Raptor
[46744]={sid=65638,mt=0x01}, -- Swift Moonsaber
[46745]={sid=65637,mt=0x01}, -- Great Red Elekk
[46746]={sid=65645,mt=0x01}, -- White Skeletal Warhorse
[46747]={sid=65642,mt=0x01}, -- Turbostrider
[46748]={sid=65643,mt=0x01}, -- Swift Violet Ram
[46749]={sid=65646,mt=0x01}, -- Swift Burgundy Wolf
[46750]={sid=65641,mt=0x01}, -- Great Golden Kodo
[46751]={sid=65639,mt=0x01}, -- Swift Red Hawkstrider
[46752]={sid=65640,mt=0x01}, -- Swift Gray Steed
[46813]={sid=66087,mt=0x02}, -- Silver Covenant Hippogryph
[46814]={sid=66088,mt=0x02}, -- Sunreaver Dragonhawk
[46815]={sid=66090,mt=0x01}, -- Quel'dorei Steed
[46816]={sid=66091,mt=0x01}, -- Sunreaver Hawkstrider
[47100]={sid=66847,mt=0x01}, -- Reins of the Striped Dawnsaber
[47101]={sid=66846,mt=0x01}, -- Ochre Skeletal Warhorse
[47179]={sid=66906,mt=0x01}, -- Argent Charger / Paladin
[47180]={sid=67466,mt=0x01}, -- Argent Warhorse
[47840]={sid=67336,mt=0x02}, -- Relentless Gladiator's Frost Wyrm
[49044]={sid=68057,mt=0x01}, -- Swift Alliance Steed
[49046]={sid=68056,mt=0x01}, -- Swift Horde Wolf
[49096]={sid=68187,mt=0x01}, -- Crusader's White Warhorse
[49098]={sid=68188,mt=0x01}, -- Crusader's Black Warhorse
[49282]={sid=51412,mt=0x01}, -- Big Battle Bear
[49283]={sid=42776,mt=0x01}, -- Reins of the Spectral Tiger
[49284]={sid=42777,mt=0x01}, -- Reins of the Swift Spectral Tiger
[49285]={sid=46197,mt=0x02}, -- X-51 Nether-Rocket
[49286]={sid=46199,mt=0x02}, -- X-51 Nether-Rocket X-TREME
-- item 49288 Little Ivory Raptor Whistle
-- item 49289 Little White Stallion Bridle
[49290]={sid=65917,mt=0x01}, -- Magic Rooster Egg / Magic Rooster
[49636]={sid=69395,mt=0x02}, -- Reins of the Onyxian Drake
[50250]={sid=71342,mt=0x02}, -- Big Love Rocket
[50435]={sid=71810,mt=0x02}, -- Wrathful Gladiator's Frost Wyrm
[50818]={sid=72286,mt=0x02}, -- Invincible's Reins
[51954]={sid=72808,mt=0x02}, -- Reins of the Bloodbathed Frostbrood Vanquisher
[51955]={sid=72807,mt=0x02}, -- Reins of the Icebound Frostbrood Vanquisher
[52200]={sid=73313,mt=0x01}, -- Reins of the Crimson Deathcharger
[54068]={sid=74918,mt=0x01}, -- Wooly White Rhino
[54069]={sid=74856,mt=0x02}, -- Blazing Hippogryph
[54465]={sid=75207,mt=0x08,r={zone = "VASHJIR,KELPTHAR_FOREST,SHIMMERING_EXPANSE,ABYSSAL_DEPTHS"}}, -- Abyssal Seahorse
[54797]={sid=75596,mt=0x02}, -- Frosty Flying Carpet
[54811]={sid=75614,mt=0x02}, -- Celestial Steed
[54860]={sid=75973,mt=0x02}, -- X-53 Touring Rocket
[60954]={sid=84751,mt=0x01}, -- Fossilized Raptor
[62298]={sid=90621,mt=0x01}, -- Reins of the Golden King
[62461]={sid=87090,mt=0x01}, -- Goblin Trike Key
[62462]={sid=87091,mt=0x01}, -- Goblin Turbo-Trike Key
[62900]={sid=88331,mt=0x02}, -- Reins of the Volcanic Stone Drake
[62901]={sid=88335,mt=0x02}, -- Reins of the Drake of the East Wind
[63039]={sid=88741,mt=0x02}, -- Reins of the Drake of the West Wind
[63040]={sid=88742,mt=0x02}, -- Reins of the Drake of the North Wind
[63041]={sid=88744,mt=0x02}, -- Reins of the Drake of the South Wind
[63042]={sid=88718,mt=0x02}, -- Reins of the Phosphorescent Stone Drake
[63043]={sid=88746,mt=0x02}, -- Reins of the Vitreous Stone Drake
[63044]={sid=88748,mt=0x01}, -- Reins of the Brown Riding Camel
[63045]={sid=88749,mt=0x01}, -- Reins of the Tan Riding Camel
[63046]={sid=88750,mt=0x01}, -- Reins of the Grey Riding Camel
[63125]={sid=88990,mt=0x02}, -- Reins of the Dark Phoenix
[64883]={sid=92155,mt=0x01}, -- Scepter of Azj'Aqir / Ultramarine Qiraji Battle Tank
[64998]={sid=92231,mt=0x01}, -- Reins of the Spectral Steed
[64999]={sid=92232,mt=0x01}, -- Reins of the Spectral Wolf
[65356]={sid=88741,mt=0x02}, -- Reins of the Drake of the West Wind
[65891]={sid=93326,mt=0x02}, -- Vial of the Sands / Sandstone Drake
[67107]={sid=93644,mt=0x01}, -- Reins of the Kron'Kar Annihilator
[67151]={sid=98718,mt=0x08}, -- Reins of Poseidus / Subdued Seahorse
[68008]={sid=93623,mt=0x02}, -- Mottled Drake
[68823]={sid=96491,mt=0x01}, -- Armored Razzashi Raptor
[68824]={sid=96499,mt=0x01}, -- Swift Zulian Panther
[68825]={sid=96503,mt=0x02}, -- Amani Dragonhawk
[69213]={sid=97359,mt=0x02}, -- Flameward Hippogryph
[69224]={sid=97493,mt=0x02}, -- Smoldering Egg of Millagazor / Pureblood Fire Hawk
[69226]={sid=97501,mt=0x02}, -- Green Fire Hawk Mount / Green Fire Hawk
[69228]={sid=97581,mt=0x01}, -- Savage Raptor
[69230]={sid=97560,mt=0x02}, -- Corrupted Egg of Millagazor / Corrupted Fire Hawk
[69747]={sid=98204,mt=0x01}, -- Amani Battle Bear
[69846]={sid=98727,mt=0x02}, -- Winged Guardian
[70909]={sid=100332,mt=0x01}, -- Vicious War Steed
[70910]={sid=100333,mt=0x01}, -- Vicious War Wolf
[71339]={sid=101282,mt=0x02}, -- Vicious Gladiator's Twilight Drake
[71665]={sid=101542,mt=0x02}, -- Flametalon of Alysrazor
[71718]={sid=101573,mt=0x01}, -- Swift Shorestrider
[71954]={sid=101821,mt=0x02}, -- Ruthless Gladiator's Twilight Drake
[72140]={sid=102346,mt=0x01}, -- Swift Forest Strider
[72146]={sid=102350,mt=0x01}, -- Swift Lovebird
[72575]={sid=102488,mt=0x01}, -- White Riding Camel
[72582]={sid=102514,mt=0x02}, -- Corrupted Hippogryph
[73766]={sid=103081,mt=0x01}, -- Darkmoon Dancing Bear
[73838]={sid=103195,mt=0x01}, -- Mountain Horse
[73839]={sid=103196,mt=0x01}, -- Swift Mountain Horse
[74269]={sid=74856,mt=0x02}, -- Blazing Hippogryph
[76755]={sid=107203,mt=0x02}, -- Tyrael's Charger
[76889]={sid=107516,mt=0x02}, -- Spectral Gryphon
[76902]={sid=107517,mt=0x02}, -- Spectral Wind Rider
[77067]={sid=107842,mt=0x02}, -- Reins of the Blazing Drake
[77068]={sid=107844,mt=0x02}, -- Reins of the Twilight Harbinger
[77069]={sid=107845,mt=0x02}, -- Life-Binder's Handmaiden
[78919]={sid=110039,mt=0x02}, -- Experiment 12-B
[78924]={sid=110051,mt=0x02}, -- Heart of the Aspects
[79771]={sid=113120,mt=0x02}, -- Feldrake
[79802]={sid=113199,mt=0x02}, -- Reins of the Jade Cloud Serpent
[81354]={sid=118089,mt=0x04}, -- Reins of the Azure Water Strider
[81559]={sid=118737,mt=0x02}, -- Pandaren Kite String
[82453]={sid=120043,mt=0x02}, -- Jeweled Onyx Panther
[82765]={sid=120395,mt=0x01}, -- Reins of the Green Dragon Turtle
[82811]={sid=120822,mt=0x01}, -- Reins of the Great Red Dragon Turtle
[83086]={sid=121820,mt=0x02}, -- Heart of the Nightwing / Obsidian Nightwing
[83087]={sid=121838,mt=0x02}, -- Ruby Panther
[83088]={sid=121837,mt=0x02}, -- Jade Panther
[83089]={sid=121839,mt=0x02}, -- Sunstone Panther
[83090]={sid=121836,mt=0x02}, -- Sapphire Panther
[84101]={sid=122708,mt=0x01}, -- Reins of the Grand Expedition Yak
[84728]={sid=123160,mt=0x01}, -- Reins of the Crimson Riding Crane
[84753]={sid=123182,mt=0x01}, -- Reins of the White Riding Yak
[85262]={sid=123886,mt=0x01}, -- Reins of the Amber Scorpion
[85429]={sid=123993,mt=0x02}, -- Reins of the Golden Cloud Serpent
[85430]={sid=123992,mt=0x02}, -- Reins of the Azure Cloud Serpent
[85666]={sid=124408,mt=0x02}, -- Reins of the Thundering Jade Cloud Serpent
[85785]={sid=124550,mt=0x02}, -- Cataclysmic Gladiator's Twilight Drake
[85870]={sid=124659,mt=0x02}, -- Imperial Quilen
[87250]={sid=126507,mt=0x02}, -- Depleted-Kyparium Rocket
[87251]={sid=126508,mt=0x02}, -- Geosynchronous World Spinner
[87768]={sid=127154,mt=0x02}, -- Reins of the Onyx Cloud Serpent
[87769]={sid=127156,mt=0x02}, -- Reins of the Crimson Cloud Serpent
[87771]={sid=127158,mt=0x02}, -- Reins of the Heavenly Onyx Cloud Serpent
[87773]={sid=127161,mt=0x02}, -- Reins of the Heavenly Crimson Cloud Serpent
[87774]={sid=127164,mt=0x02}, -- Reins of the Heavenly Golden Cloud Serpent
[87775]={sid=127165,mt=0x02}, -- Reins of the Heavenly Jade Cloud Serpent
[87776]={sid=127169,mt=0x02}, -- Reins of the Heavenly Azure Cloud Serpent
[87777]={sid=127170,mt=0x02}, -- Reins of the Astral Cloud Serpent
[87781]={sid=127174,mt=0x01}, -- Reins of the Azure Riding Crane
[87782]={sid=127176,mt=0x01}, -- Reins of the Golden Riding Crane
[87783]={sid=127177,mt=0x01}, -- Reins of the Regal Riding Crane
[87784]={sid=127178,mt=0x01}, -- Jungle Riding Crane
[87785]={sid=127180,mt=0x01}, -- Reins of the Albino Riding Crane
[87786]={sid=127209,mt=0x01}, -- Reins of the Black Riding Yak
[87787]={sid=127213,mt=0x01}, -- Reins of the Brown Riding Yak
[87788]={sid=127216,mt=0x01}, -- Reins of the Grey Riding Yak
[87789]={sid=127220,mt=0x01}, -- Reins of the Blonde Riding Yak
[87791]={sid=127271,mt=0x04}, -- Reins of the Crimson Water Strider
[87792]={sid=127272,mt=0x04}, -- Reins of the Orange Water Strider
[87793]={sid=127274,mt=0x04}, -- Reins of the Jade Water Strider
[87794]={sid=127278,mt=0x04}, -- Reins of the Golden Water Strider
[87795]={sid=127286,mt=0x01}, -- Reins of the Black Dragon Turtle
[87796]={sid=127287,mt=0x01}, -- Reins of the Blue Dragon Turtle
[87797]={sid=127288,mt=0x01}, -- Reins of the Brown Dragon Turtle
[87799]={sid=127289,mt=0x01}, -- Reins of the Purple Dragon Turtle
[87800]={sid=127290,mt=0x01}, -- Reins of the Red Dragon Turtle
[87801]={sid=127293,mt=0x01}, -- Reins of the Great Green Dragon Turtle
[87802]={sid=127295,mt=0x01}, -- Reins of the Great Black Dragon Turtle
[87803]={sid=127302,mt=0x01}, -- Reins of the Great Blue Dragon Turtle
[87804]={sid=127308,mt=0x01}, -- Reins of the Great Brown Dragon Turtle
[87805]={sid=127310,mt=0x01}, -- Reins of the Great Purple Dragon Turtle
[89154]={sid=129552,mt=0x02}, -- Reins of the Crimson Pandaren Phoenix
[89304]={sid=129918,mt=0x02}, -- Reins of the Thundering August Cloud Serpent
[89305]={sid=129932,mt=0x01}, -- Reins of the Green Shado-Pan Riding Tiger
[89306]={sid=129935,mt=0x01}, -- Reins of the Red Shado-Pan Riding Tiger
[89307]={sid=129934,mt=0x01}, -- Reins of the Blue Shado-Pan Riding Tiger
[89362]={sid=130086,mt=0x01}, -- Reins of the Brown Riding Goat
[89363]={sid=130092,mt=0x02}, -- Disc of the Red Flying Cloud
[89390]={sid=130137,mt=0x01}, -- Reins of the White Riding Goat
[89391]={sid=130138,mt=0x01}, -- Reins of the Black Riding Goat
[89783]={sid=130965,mt=0x01}, -- Son of Galleon's Saddle
[89785]={sid=130985,mt=0x02}, -- Pandaren Kite String
[90655]={sid=132036,mt=0x02}, -- Reins of the Thundering Ruby Cloud Serpent
[90710]={sid=132117,mt=0x02}, -- Reins of the Ashen Pandaren Phoenix
[90711]={sid=132118,mt=0x02}, -- Reins of the Emerald Pandaren Phoenix
[90712]={sid=132119,mt=0x02}, -- Reins of the Violet Pandaren Phoenix
[91004]={sid=120395,mt=0x01}, -- Reins of the Green Dragon Turtle
[91005]={sid=127288,mt=0x01}, -- Reins of the Brown Dragon Turtle
[91006]={sid=127289,mt=0x01}, -- Reins of the Purple Dragon Turtle
[91007]={sid=127290,mt=0x01}, -- Reins of the Red Dragon Turtle
[91008]={sid=127286,mt=0x01}, -- Reins of the Black Dragon Turtle
[91009]={sid=127287,mt=0x01}, -- Reins of the Blue Dragon Turtle
[91010]={sid=120822,mt=0x01}, -- Reins of the Great Red Dragon Turtle
[91011]={sid=127295,mt=0x01}, -- Reins of the Great Black Dragon Turtle
[91012]={sid=127293,mt=0x01}, -- Reins of the Great Green Dragon Turtle
[91013]={sid=127302,mt=0x01}, -- Reins of the Great Blue Dragon Turtle
[91014]={sid=127308,mt=0x01}, -- Reins of the Great Brown Dragon Turtle
[91015]={sid=127310,mt=0x01}, -- Reins of the Great Purple Dragon Turtle
[91016]={sid=120822,mt=0x01}, -- Reins of the Great Red Dragon Turtle
[108883]={sid=171844,mt=0x01}, -- Riding Harness / Dustmane Direwolf
[115363]={sid=169952,mt=0x02}, -- Creeping Carpet
[118676]={sid=175700,mt=0x02}, -- Reins of the Emerald Drake
[116788]={sid=171845,mt=0x01}, -- Warlord's Deathwheel

["S138424"]={sid=138424,mt=0x01}, -- Amber Primardial Direhorn
["S148428"]={sid=148428,mt=0x01}, -- Ashhide Mushan Beast
["S59572"]={sid=59572,mt=0x01}, -- Black Polar Bear
["S138642"]={sid=138642,mt=0x01}, -- Black Primal Raptor
["S138640"]={sid=138640,mt=0x01}, -- Bone-White Primal Raptor
["S138643"]={sid=138643,mt=0x01}, -- Green Primal Raptor
["S138641"]={sid=138641,mt=0x01}, -- Red Primal Raptor
["S142641"]={sid=142641,mt=0x01}, -- Brawler's Burly Mushan Beast
["S138423"]={sid=138423,mt=0x01}, -- Cobalt Primordial Direhorn
["S138425"]={sid=138425,mt=0x01}, -- Slate Primordial Direhorn
["S140250"]={sid=140250,mt=0x01}, -- Crimson Primordial Direhorn
["S138426"]={sid=138426,mt=0x01}, -- Jade Primordial Direhorn
["S102349"]={sid=102349,mt=0x01}, -- Swift Springstrider
["S136471"]={sid=136471,mt=0x01}, -- Spawn of Horridon
["S148417"]={sid=148417,mt=0x01}, -- Kor'kron Juggernaut
["S148396"]={sid=148396,mt=0x01}, -- Kor'kron War Wolf

["S142266"]={sid=142266,mt=0x02}, -- Armored Red Dragonhawk
["S136400"]={sid=136400,mt=0x02}, -- Armored Skyscreamer
["S139448"]={sid=139448,mt=0x02}, -- Clutch of Ji-Kun
["S136505"]={sid=136505,mt=0x02}, -- Ghastly Charger
["S135418"]={sid=135418,mt=0x02}, -- Grand Armored Wyvern
["S136164"]={sid=136164,mt=0x02}, -- Grand Wyvern
["S133023"]={sid=133023,mt=0x02}, -- Jade Pandaren Kite
["S139442"]={sid=139442,mt=0x02}, -- Thundering Cobalt Cloud Serpent
["S148476"]={sid=148476,mt=0x02}, -- Thundering Onyx Cloud Serpent
["S148392"]={sid=148392,mt=0x02}, -- Spawn of Galakras
["S134359"]={sid=134359,mt=0x02}, -- Sky Golem

[120968]={sid=179245,mt=0x01}, -- Chauffeured Chopper / Chauffeured Mekgineer's Chopper (Alliance)
[122703]={sid=179244,mt=0x01}, -- Chauffeured Chopper / Chauffeured Mechano-Hog (Horde)


["S5784"]={sid=5784,mt=0x01}, -- Felsteed
["S13819"]={sid=13819,mt=0x01}, -- Warhorse
["S23161"]={sid=23161,mt=0x01}, -- Dreadsteed
["S23214"]={sid=23214,mt=0x01}, -- Charger
["S33943"]={sid=33943,mt=0x01}, -- Flight Form
-- spell 34767 Summon Charger
-- spell 34769 Summon Warhorse
-- spell 40120 Swift Flight Form
-- spell 48778 Acherus Deathcharger
-- spell 69820 Sunwalker Kodo
-- spell 69826 Great Sunwalker Kodo
-- spell 73629 Exarch's Elekk
-- spell 73630 Great Exarch's Elekk
-- spell 89520 Goblin Mini Hotrod

-- pets (only the ones that come from items)
[4401]={cid=2671}, -- Mechanical Squirrel Box / Mechanical Squirrel
[8485]={cid=7385}, -- Cat Carrier (Bombay) / Bombay Cat
[8486]={cid=7384}, -- Cat Carrier (Cornish Rex) / Cornish Rex Cat
[8487]={cid=7382}, -- Cat Carrier (Orange Tabby) / Orange Tabby Cat
[8488]={cid=7381}, -- Cat Carrier (Silver Tabby) / Silver Tabby Cat
[8489]={cid=7386}, -- Cat Carrier (White Kitten) / White Kitten
[8490]={cid=7380}, -- Cat Carrier (Siamese) / Siamese Cat
[8491]={cid=7383}, -- Cat Carrier (Black Tabby) / Black Tabby Cat
[8492]={cid=7387}, -- Parrot Cage (Green Wing Macaw) / Green Wing Macaw
[8494]={cid=7391}, -- Parrot Cage (Hyacinth Macaw) / Hyacinth Macaw
[8495]={cid=7389}, -- Parrot Cage (Senegal) / Senegal
[8496]={cid=7390}, -- Parrot Cage (Cockatiel) / Cockatiel
[8497]={cid=7560}, -- Rabbit Crate (Snowshoe) / Snowshoe Rabbit
[8498]={cid=7545}, -- Tiny Emerald Whelpling / Emerald Whelpling
[8499]={cid=7544}, -- Tiny Crimson Whelpling / Crimson Whelpling
[8500]={cid=7553}, -- Great Horned Owl
[8501]={cid=7555}, -- Hawk Owl
[10360]={cid=7565}, -- Black Kingsnake
[10361]={cid=7562}, -- Brown Snake
[10392]={cid=7567}, -- Crimson Snake
[10393]={cid=7395}, -- Cockroach
[10394]={cid=14421}, -- Prairie Dog Whistle / Brown Prairie Dog
[10398]={cid=8376}, -- Mechanical Chicken
[10822]={cid=7543}, -- Dark Whelpling
[11023]={cid=7394}, -- Ancona Chicken
[11026]={cid=7549}, -- Tree Frog Box / Tree Frog
[11027]={cid=7550}, -- Wood Frog Box / Wood Frog
[11110]={cid=30379}, -- Chicken Egg / Westfall Chicken
[11474]={cid=9662}, -- Sprite Darter Egg / Sprite Darter Hatchling
[11825]={cid=9656}, -- Pet Bombling
[11826]={cid=9657}, -- Lil' Smoky
[12264]={cid=10259}, -- Worg Carrier / Worg Pup
[12529]={cid=10598}, -- Smolderweb Carrier / Smolderweb Hatchling
[13582]={cid=11327}, -- Zergling Leash
[13583]={cid=11325}, -- Panda Collar / Panda Cub
[13584]={cid=11326}, -- Diablo Stone / Mini Diablo
[15048]={cid=16548}, -- Piglet's Collar / Mr. Wiggles
[15996]={cid=12419}, -- Lifelike Mechanical Toad / Lifelike Toad
[18964]={cid=23429}, -- Turtle Egg (Loggerhead) / Loggerhead Snapjaw
[19054]={cid=14756}, -- Red Dragon Orb / Tiny Red Dragon
[19055]={cid=14755}, -- Green Dragon Orb / Tiny Green Dragon
[19450]={cid=14878}, -- A Jubling's Tiny Home / Jubling
[19462]={cid=14878}, -- Unhatched Jubling Egg
[20371]={cid=15186}, -- Blue Murloc Egg / Murky
[20769]={cid=15429}, -- Disgusting Oozeling
[21168]={cid=15661}, -- Baby Shark
[21277]={cid=15699}, -- Tranquil Mechanical Yeti
[21301]={cid=15698}, -- Green Helper Box / Father Winter's Helper
[21305]={cid=15705}, -- Red Helper Box / Winter's Little Helper
[21308]={cid=15706}, -- Jingling Bell / Winter Reindeer
[21309]={cid=15710}, -- Snowman Kit / Tiny Snowman
[22114]={cid=16069}, -- Pink Murloc Egg / Gurky
-- item 22200 Silver Shafted Arrow
[22235]={cid=16085}, -- Truesilver Shafted Arrow / Peddlefeet
[22781]={cid=16456}, -- Polar Bear Collar / Poley
[23002]={cid=16547}, -- Turtle Box / Speedy
[23015]={cid=16549}, -- Rat Cage / Whiskers the Rat
[23083]={cid=16701}, -- Captured Flame / Spirit of Summer
[23712]={cid=17254}, -- White Tiger Cub
[23713]={cid=17255}, -- Hippogryph Hatchling
[25535]={cid=18381}, -- Netherwhelp's Collar
[27445]={cid=18839}, -- Magical Crawdad Box
[29363]={cid=20408}, -- Mana Wyrmling
[29364]={cid=20472}, -- Brown Rabbit Crate
[29901]={cid=21010}, -- Blue Moth Egg
[29902]={cid=21009}, -- Red Moth Egg
[29903]={cid=21008}, -- Yellow Moth Egg
[29904]={cid=21018}, -- White Moth Egg
[29953]={cid=21055}, -- Golden Dragonhawk Hatchling
[29956]={cid=21064}, -- Red Dragonhawk Hatchling
[29957]={cid=21063}, -- Silver Dragonhawk Hatchling
[29958]={cid=21056}, -- Blue Dragonhawk Hatchling
[29960]={cid=21076}, -- Captured Firefly
[30360]={cid=15358}, -- Lurky's Egg
[31760]={cid=22445}, -- Miniwing
[32233]={cid=22943}, -- Wolpertinger's Tankard
[32498]={cid=23198}, -- Fortune Coin / Lucky
[32588]={cid=23234}, -- Banana Charm / Bananas
[32616]={cid=23258}, -- Egbert's Egg
[32617]={cid=23231}, -- Sleepy Willy
[32622]={cid=23266}, -- Elekk Training Collar / Peanut
[33154]={cid=23909}, -- Sinister Squashling
[33816]={cid=24388}, -- Toothy's Bucket
[33818]={cid=24389}, -- Muckbreath's Bucket
[33993]={cid=24480}, -- Mojo
[34425]={cid=24968}, -- Clockwork Rocket Bot
[34478]={cid=25062}, -- Tiny Sporebat
[34492]={cid=25109}, -- Rocket Chicken
[34493]={cid=25110}, -- Dragon Kite
[34518]={cid=25146}, -- Golden Pig Coin
[34519]={cid=25147}, -- Silver Pig Coin
[34535]={cid=7547}, -- Azure Whelpling
[34955]={cid=25706}, -- Scorched Stone / Scorchling
-- item 35227 Goblin Weather Machine - Prototype 01-B
[35349]={cid=26050}, -- Snarly's Bucket
[35350]={cid=26056}, -- Chuck's Bucket
[35504]={cid=26119}, -- Phoenix Hatchling
[37297]={cid=27217}, -- Gold Medallion / Spirit of Competition
[37298]={cid=27346}, -- Competitor's Souvenir / Essence of Competition
-- item 37460 Rope Pet Leash
[38050]={cid=27914}, -- Soul-Trader Beacon / Ethereal Soul-Trader
[38628]={cid=28470}, -- Nether Ray Fry
[38658]={cid=28513}, -- Vampiric Batling
[39286]={cid=28883}, -- Frosty's Collar
[39656]={cid=29089}, -- Tyrael's Hilt / Mini Tyrael
[39896]={cid=32589}, -- Tickbird Hatchling
[39898]={cid=32591}, -- Cobra Hatchling
[39899]={cid=32590}, -- White Tickbird Hatchling
[39973]={cid=29147}, -- Ghostly Skull
[40653]={cid=23274}, -- Reeking Pet Carrier / Stinker
[41133]={cid=29726}, -- Unhatched Mr. Chilly
[43698]={cid=31575}, -- Giant Sewer Rat
[44721]={cid=32592}, -- Proto-Drake Whelp
[44723]={cid=32595}, -- Nurtured Penguin Egg / Pengu
[44738]={cid=32643}, -- Kirin Tor Familiar
[44794]={cid=32791}, -- Spring Rabbit's Foot
[44810]={cid=32818}, -- Turkey Cage / Plump Turkey
[44819]={cid=32841}, -- Baby Blizzard Bear
-- item 44820 Red Ribbon Pet Leash
[44822]={cid=7561}, -- Albino Snake
[44841]={cid=32939}, -- Little Fawn's Salt Lick
[44965]={cid=33188}, -- Teldrassil Sproutling
[44970]={cid=33194}, -- Dun Morogh Cub
[44971]={cid=33197}, -- Tirisfal Batling
[44973]={cid=33198}, -- Durotar Scorpion
[44974]={cid=33200}, -- Elwynn Lamb
[44980]={cid=33219}, -- Mulgore Hatchling
[44982]={cid=33227}, -- Enchanted Broom
[44983]={cid=33226}, -- Strand Crawler
[44984]={cid=33205}, -- Ammen Vale Lashling
[44998]={cid=33238}, -- Argent Squire
[45002]={cid=33274}, -- Mechanopeep
[45022]={cid=33239}, -- Argent Gruntling
-- item 45057 Wind-Up Train Wrecker
[45180]={cid=33578}, -- Murkimus' Little Spear / Murkimus the Gladiator
[45606]={cid=33810}, -- Sen'jin Fetish
[45942]={cid=34031}, -- XS-001 Constructor Bot
[46325]={cid=34278}, -- Withers
-- item 46396 Wolvar Orphan Whistle
-- item 46397 Oracle Orphan Whistle
[46398]={cid=34364}, -- Calico Cat
[46544]={cid=33529}, -- Curious Wolvar Pup
[46545]={cid=33530}, -- Curious Oracle Hatchling
[46707]={cid=24753}, -- Pint-Sized Pink Pachyderm
[46767]={cid=34587}, -- Warbot Ignition Key
[46802]={cid=34694}, -- Heavy Murloc Egg / Grunty
[46820]={cid=34724}, -- Shimmering Wyrmling
[46821]={cid=34724}, -- Shimmering Wyrmling
-- item 46831 Macabre Marionette
[48112]={cid=35396}, -- Darting Hatchling
[48114]={cid=35395}, -- Deviate Hatchling
[48116]={cid=35400}, -- Gundrak Hatchling
[48118]={cid=35387}, -- Leaping Hatchling
[48120]={cid=35399}, -- Obsidian Hatchling
[48122]={cid=35397}, -- Ravasaur Hatchling
[48124]={cid=35398}, -- Razormaw Hatchling
[48126]={cid=35394}, -- Razzashi Hatchling
[49287]={cid=36482}, -- Tuskarr Kite
[49343]={cid=36511}, -- Spectral Tiger Cub
[49362]={cid=36607}, -- Onyxian Whelpling
[49646]={cid=36871}, -- Core Hound Pup
[49662]={cid=36908}, -- Gryphon Hatchling
[49663]={cid=36909}, -- Wind Rider Cub
[49665]={cid=36911}, -- Pandaren Monk
[49693]={cid=36979}, -- Lil' Phylactery / Lil' K.T.
[49912]={cid=37865}, -- Perky Pug
[50446]={cid=38374}, -- Toxic Wasteling
[53641]={cid=40198}, -- Ice Chip / Frigid Frostling
[54436]={cid=40295}, -- Blue Clockwork Rocket Bot
[54810]={cid=40624}, -- Celestial Dragon
[54847]={cid=40703}, -- Lil' XT
[56806]={cid=42078}, -- Mini Thor
[59597]={cid=43800}, -- Personal World Destroyer
[60216]={cid=43916}, -- De-Weaponized Mechanical Companion
[60847]={cid=45128}, -- Crawling Claw
[60869]={cid=45247}, -- Pebble
[60955]={cid=45340}, -- Fossilized Hatchling
[62540]={cid=46896}, -- Lil' Deathwing
[62769]={cid=47169}, -- Hardboiled Egg / Eat the Egg
[63138]={cid=47944}, -- Dark Phoenix Hatchling
[63355]={cid=48107}, -- Rustberg Gull / Rustberg Seagull
[63398]={cid=48242}, -- Armadillo Pup
[64372]={cid=48609}, -- Clockwork Gnome
[64403]={cid=48641}, -- Fox Kit
[64494]={cid=48982}, -- Tiny Shale Spider
[64996]={cid=48107}, -- Rustberg Gull / Rustberg Seagull
[65361]={cid=49586}, -- Guild Page
[65362]={cid=49588}, -- Guild Page
[65363]={cid=49587}, -- Guild Herald
[65364]={cid=49590}, -- Guild Herald
[65661]={cid=42177}, -- Blue Mini Jouster
[65662]={cid=42183}, -- Gold Mini Jouster
[66067]={cid=51090}, -- Brazie's Sunflower Seeds / Singing Sunflower
[66070]={cid=51636}, -- Lizzy
[66073]={cid=51635}, -- Little Snail
[66075]={cid=51634}, -- Bubbles
[66076]={cid=50586}, -- Mr. Grubbs
[66080]={cid=51632}, -- Tiny Flamefly
[67128]={cid=50468}, -- Landro's Lil' XT
[67274]={cid=46898}, -- Enchanted Lantern
[67275]={cid=50545}, -- Magic Lamp
[67282]={cid=50722}, -- Elementium Geode
[67418]={cid=51122}, -- Smoldering Murloc Egg / Deathy
-- item 67600 Lil' Alexstrasza
[67601]={cid=51600}, -- Lil' Ragnaros
-- item 68384 Moonkin Egg / Container
[68385]={cid=51600}, -- Lil' Ragnaros
[68618]={cid=51601}, -- Moonkin Hatchling
[68619]={cid=51649}, -- Moonkin Hatchling
[68833]={cid=52226}, -- Panther Cub
[68840]={cid=52343}, -- Landro's Lichling
[68841]={cid=52344}, -- Nightsaber Cub
[69239]={cid=52831}, -- Winterspring Cub
[69251]={cid=52894}, -- Lashtail Hatchling
[69648]={cid=53048}, -- Legs
[69821]={cid=53225}, -- Pterrordax Hatchling
[69824]={cid=53232}, -- Voodoo Figurine
[69847]={cid=53283}, -- Guardian Cub
[70099]={cid=53623}, -- Cenarion Hatchling
[70140]={cid=53658}, -- Hyjal Bear Cub
[70160]={cid=53661}, -- Crimson Lasher
[70908]={cid=53884}, -- Feline Familiar
[71033]={cid=54027}, -- Lil' Tarecgosa
[71076]={cid=54128}, -- The Creepy Crate
[71140]={cid=54227}, -- Nuts' Acorn
[71387]={cid=54374}, -- Brilliant Kaliri
[71624]={cid=54383}, -- Purple Puffer
[71726]={cid=54438}, -- Murkablo
[72042]={cid=54539}, -- Alliance Balloon
[72045]={cid=54541}, -- Horde Balloon
[72068]={cid=53283}, -- Guardian Cub
[72134]={cid=54730}, -- Grell Moss / Gregarious Grell
[72153]={cid=54745}, -- Sand Scarab
[73762]={cid=55187}, -- Darkmoon Balloon
[73764]={cid=54491}, -- Darkmoon Monkey
[73765]={cid=54487}, -- Darkmoon Turtle
[73797]={cid=55215}, -- Lump of Coal / Lumpy
[73903]={cid=55356}, -- Darkmoon Tonk
[73905]={cid=55367}, -- Darkmoon Zeppelin
[73905]={cid=55367}, -- Darkmoon Zeppelin
[73953]={cid=55386}, -- Sea Pony
[74610]={cid=55571}, -- Lunar Lantern
[74611]={cid=55574}, -- Festival Lantern
[74981]={cid=56031}, -- Darkmoon Cub
[75040]={cid=55187}, -- Flimsy Darkmoon Balloon / Darkmoon Balloon
[76062]={cid=56266}, -- Fetish Shaman's Spear / Fetish Shaman
[78916]={cid=58163}, -- Soul of the Aspects
[79744]={cid=59020}, -- Eye of the Legion
[80008]={cid=59358}, -- Darkmoon Rabbit
[82774]={cid=61877}, -- Jade Owl
[82775]={cid=61883}, -- Sapphire Cub
[84105]={cid=62829}, -- Fishy
[85220]={cid=63365}, -- Terrible Turnip
[85222]={cid=63370}, -- Red Cricket
[85447]={cid=63559}, -- Tiny Goldfish
[85513]={cid=65313}, -- Thundering Serpent Hatchling
[85578]={cid=63621}, -- Feral Vermling
[85871]={cid=63832}, -- Lucky Quilen Cub
[86562]={cid=64632}, -- Hopling
[86563]={cid=64633}, -- Hollow Reed / Aqua Strider
[86564]={cid=64634}, -- Imbued Jade Fragment / Grinder
[87526]={cid=64899}, -- Mechanical Pandaren Dragonling
[88147]={cid=64232}, -- Singing Cricket Cage
[88148]={cid=65314}, -- Jade Crane Chick
[89367]={cid=66105}, -- Yu'lon Kite
[89368]={cid=66104}, -- Chi-ji Kite
[89587]={cid=61086}, -- Porcupette
[89686]={cid=66450}, -- Jade Tentacle
[89736]={cid=66491}, -- Venus
[90173]={cid=66950}, -- Pandaren Water Spirit
[90177]={cid=66984}, -- Baneling
-- spell 66520 Jade Tiger
-- spell 75936 Murkimus the Gladiator
-- spell 89929 Rumbling Rockling
-- spell 89930 Swirling Stormling
-- spell 89931 Whirling Waveling
-- spell 93461 Landro's Lil' XT
-- spell 123212 Shore Crawler
-- spell 123214 Gilnean Raven
[90173]={cid=66950}, -- Pandaren Water Spirit
[90177]={cid=66984}, -- Baneling
[90897]={cid=48641}, -- Fox Kit
[90900]={cid=67230}, -- Imperial Moth
[90902]={cid=67233}, -- Imperial Silkworm
[90953]={cid=68502}, -- Spectral Cub
[91003]={cid=67319}, -- Darkmoon Hatchling
[91031]={cid=67329}, -- Darkmoon Glowfly
[91040]={cid=67332}, -- Darkmoon Eye
[92707]={cid=68267}, -- Cinder Kitten
[92798]={cid=68466}, -- Pandaren Fire Spirit
[92799]={cid=68467}, -- Pandaren Air Spirit
[92800]={cid=68468}, -- Pandaren Earth Spirit
[93025]={cid=68601}, -- Clock'em
[93029]={cid=68654}, -- Gluth's Bone / Stitched Pup
[93030]={cid=68656}, -- Dusty Clutch of Eggs / Giant Bone Spider
[93031]={cid=68655}, -- Mr. Bigglesworth
[93032]={cid=68657}, -- Blighted Spore / Fungal Abomination
[93033]={cid=68665}, -- Mark of Flame / Harbinger of Flame
[93034]={cid=68664}, -- Blazing Rune / Corefire Imp
[93035]={cid=68666}, -- Core of Hardened Ash / Ashstone Core
[93036]={cid=68661}, -- Unscathed Egg / Untamed Hatchling
[93037]={cid=68663}, -- Blackwing Banner / Death Talon Whelpguard
[93038]={cid=68662}, -- Whistle of Chromatic Bone / Chrominius
[93039]={cid=68660}, -- Viscidus Globule
[93040]={cid=68659}, -- Anubisath Idol
[93041]={cid=68658}, -- Jewel of Maddening Whispers / Mini Mindslayer
[93669]={cid=69208}, -- Gusting Grimoire
[94025]={cid=69649}, -- Red Panda
[94124]={cid=69778}, -- Sunreaver Micro-Sentry
[94125]={cid=69748}, -- Living Sandling
[94126]={cid=69796}, -- Zandalari Kneebiter
[94152]={cid=69820}, -- Son of Animus
[94190]={cid=69848}, -- Spectral Porcupette
[94208]={cid=69891}, -- Sunfur Panda
[94209]={cid=69893}, -- Snowy Panda
[94210]={cid=69892}, -- Mountain Panda
[94573]={cid=70154}, -- Direhorn Runt
[94574]={cid=70083}, -- Pygmy Direhorn
[94595]={cid=70098}, -- Spawn of G'nathus
[94835]={cid=70144}, -- Ji-Kun Hatchling
[94903]={cid=70082}, -- Pierre
[94932]={cid=70257}, -- Tiny Red Carp
[94933]={cid=70258}, -- Tiny Blue Carp
[94934]={cid=70259}, -- Tiny Green Carp
[94935]={cid=70260}, -- Tiny White Carp
[95422]={cid=70451}, -- Zandalari Anklerender
[95423]={cid=70452}, -- Zandalari Footslasher
[95424]={cid=70453}, -- Zandalari Toenibbler
[95621]={cid=34587}, -- Warbot Ignition Key / Warbot
[97548]={cid=71014}, -- Spiky Collar / Lil' Bad Wolf
[97549]={cid=71015}, -- Instant Arcane Sanctum Security Kit / Menagerie Custodian
[97550]={cid=71016}, -- Netherspace Portal-Stone / Netherspace Abyssal
[97551]={cid=71033}, -- Satyr Charm / Fiendish Imp
[97552]={cid=71017}, -- Shell of Tide-Calling / Tideskipper
[97553]={cid=71018}, -- Tainted Core / Tainted Waveling
[97554]={cid=71019}, -- Dripping Strider Egg / Coilfang Stalker
[97555]={cid=71020}, -- Tiny Fel Engine Key / Pocket Reaver
[97556]={cid=71021}, -- Crystal of the Void / Lesser Voidcaller
[97557]={cid=71022}, -- Brilliant Phoenix Hawk Feather / Phoenix Hawk Hatchling
[97558]={cid=71023}, -- Tito's Basket / Tito
[97821]={cid=71159}, -- Gahz'rooki's Summoning Stone / Gahz'rooki
[97959]={cid=71199}, -- Quivering Blob / Living Fluid
[97960]={cid=71200}, -- Dark Quivering Blob / Viscous Horror
[97961]={cid=71201}, -- Half-Empty Food Container / Filthling
[98550]={cid=71488}, -- Blossoming Ancient
[100905]={cid=71693}, -- Rascal-Bot
[104156]={cid=73533}, -- Ashleaf Spriteling
[104157]={cid=73534}, -- Azure Crane Chick
[104158]={cid=73352}, -- Blackfuse Bombling
[104202]={cid=73668}, -- Bonkers
[106240]={cid=74402}, -- Alterac Brandy / Alterac Brew-Pup
[116439]={cid=85872}, -- Blazing Cindercrawler
[117354]={cid=86420}, -- Ancient Nest Guardian
[118516]={cid=88807}, -- Argi
[118599]={cid=83584}, -- Autumnal Sproutling
[119148]={cid=85281}, -- Indentured Albino River Calf / Albino River Calf
[119434]={cid=77021}, -- Albino Chimaeraling
[119146]={cid=85014}, -- Bone Wasp
[116403]={cid=85846}, -- Frightened Bush Chicken / Bush Chicken
[102145]={cid=72462}, -- Chi-Chi, Hatchling of Chi-Ji
[110721]={cid=79039}, -- Crazy Carrot
[118106]={cid=86716}, -- Crimson Spore
[116801]={cid=86061}, -- Cursed Birman
[104160]={cid=73532}, -- Dandelion Frolicker
[104161]={cid=73364}, -- Death Adder Hatchling
[118709]={cid=88103}, -- Doom Bloom
[115282]={cid=84885}, -- Draenei Micro Defender
[119142]={cid=84885}, -- Draenei Micro Defender
[109014]={cid=77137}, -- Dread Hatchling
[104162]={cid=73350}, -- Droplet of Y'Shaarj
[113216]={cid=82464}, -- Elekk Plushie
[118921]={cid=88222}, -- Everbloom Peachick
[119170]={cid=88490}, -- Eye of Observation
[118578]={cid=87704}, -- Firewing
[119149]={cid=83583}, -- Captured Forest Sproutling
[117380]={cid=86422}, -- Frostwolf Ghostpup
[119141]={cid=87111}, -- Frostwolf Pup
[117564]={cid=85387}, -- Fruit Hunter
[113623]={cid=83817}, -- Spectral Bell / Ghastly Kid
[104163]={cid=73351}, -- Gooey Sha-ling
[118517]={cid=88805}, -- Grommloc
[104291]={cid=73730}, -- Swarmling of Gu'chi / Gu'chi Swarmling
[104169]={cid=73359}, -- Gulp Froglet
[104295]={cid=73732}, -- Harmonious Porcupette
[118574]={cid=87669}, -- Hatespark the Tiny
[119048]={cid=76873}, -- Hogs
[118207]={cid=86879}, -- Hydraling
[111660]={cid=77221}, -- Iron Starlette
[104307]={cid=73738}, -- Jadefire Spirit
[104164]={cid=73355}, -- Jademist Dancer
[120051]={cid=88574}, -- Kaliri Hatchling
[118597]={cid=83589}, -- Kelp Sproutling
[117404]={cid=86445}, -- Land Shark
[117528]={cid=86532}, -- Lanticore Spawnling
[112057]={cid=80329}, -- Lifelike Mechanical Frostboar
[103670]={cid=73011}, -- Lil' Bling
[110684]={cid=78895}, -- Leftovers / Lil' Leftovers
[116155]={cid=85710}, -- Lovebird Hatchling
[101570]={cid=72160}, -- Moon Moon
[101771]={cid=71942}, -- Xu-Fu, Cub of Xuen
[102146]={cid=72464}, -- Zao, Calfling of Niuzao
[102147]={cid=72463}, -- Yu'la, Broodling of Yu'lon
[103637]={cid=73688}, -- Vengeful Porcupette
[104159]={cid=73356}, -- Ruby Droplet
[104165]={cid=73354}, -- Kovok
[104166]={cid=73357}, -- Ominous Flame
[104167]={cid=73367}, -- Skunky Alemental
[104168]={cid=73366}, -- Spineclaw Crab
[104317]={cid=73741}, -- Rotten Helper Box / Rotten Little Helper
[104332]={cid=73809}, -- Sky Lantern
[104333]={cid=73809}, -- Sky Lantern
[106244]={cid=74405}, -- Murkalot's Flail / Murkalot
[106256]={cid=74413}, -- Treasure Goblin's Pack / Treasure Goblin
[111402]={cid=79410}, -- Mechanical Axebeak
[111866]={cid=80101}, -- Royal Peacock
[112699]={cid=81431}, -- Teroclaw Hatchling
[113554]={cid=83562}, -- Zomstrok
[113558]={cid=78421}, -- Weebomination
[114834]={cid=84330}, -- Meadowstomper Calf
[114919]={cid=84441}, -- Sea Calf
[115301]={cid=84915}, -- Molten Corgi
[115483]={cid=85284}, -- Sky-Bo
[116064]={cid=85527}, -- Syd the Squid
[116258]={cid=85773}, -- Mystical Spring Bouquet
[116402]={cid=85231}, -- Stonegrinder
[116756]={cid=85994}, -- Stout Alemental
[116804]={cid=86067}, -- Widget the Departed
[116815]={cid=86081}, -- Netherspawn, Spawn of Netherspawn
[118101]={cid=86715}, -- Zangar Spore
[118104]={cid=86717}, -- Umbrafen Spore
[118105]={cid=86718}, -- Seaborne Spore
[118518]={cid=88814}, -- ZZ02 / Unused
[118577]={cid=87705}, -- Stormwing
[118595]={cid=83594}, -- Nightshade Sproutling
[118596]={cid=83592}, -- Sassy Sproutling
[118598]={cid=83588}, -- Sun Sproutling
[118600]={cid=83583}, -- Forest Sproutling
[118919]={cid=85667}, -- Red Goren Egg / Ore Eater
[118923]={cid=88225}, -- Sentinel's Companion
[119112]={cid=88401}, -- Son of Sethe
[119143]={cid=88401}, -- Son of Sethe
[119150]={cid=88452}, -- Sky Fry
[119328]={cid=84853}, -- Soul of the Forge
[119431]={cid=88692}, -- Servant of Demidos
[119467]={cid=88300}, -- Puddle Terror
[119468]={cid=88367}, -- Sunfire Kaliri
[120050]={cid=88573}, -- Veilwatcher Hatchling
[120121]={cid=88830}, -- Trunks
[120309]={cid=87257}, -- Glass of Warm Milk / Pygmy Cow
[118675]={cid=7546}, -- Time-Locked Box / Bronze Whelpling
-- pets up to patch 6.0.2

[118106]={cid=86716}, -- Crimson Spore
[118104]={cid=86717}, -- Umbrafen Spore

}


-- build pets and mounts array

local function importCompanionCrossRefTable( )
	
	if not TempData then return end
	
	local key1, key2, speciesID
	local wipe = true
	
	for item, data in pairs( TempData ) do
		
		if ( type( item ) == "number" ) then
			
			key1 = string.format( "item:%s", item )
			-- item to alternative
			
			if ( data.cid ) and ( type( data.cid ) == "number" ) then
				
				speciesID = ArkInventory.PetJournal.GetSpeciesIDForCreatureID( data.cid )
				if speciesID then
					
					key2 = string.format( "battlepet:%s", speciesID )
					if not ArkInventory.Const.ItemCrossReference[key1] then
						ArkInventory.Const.ItemCrossReference[key1] = { }
					end
					ArkInventory.Const.ItemCrossReference[key1][key2] = true
					
					if not ArkInventory.Const.ItemCrossReference[key2] then
						ArkInventory.Const.ItemCrossReference[key2] = { }
					end
					ArkInventory.Const.ItemCrossReference[key2][key1] = true
					
					data.cid = nil
					
				else
					
					--ArkInventory.Output( "unknown critter id ", data.cid )
					wipe = false
					
				end
				
			end
			
			if ( data.sid ) and ( type( data.sid ) == "number" ) then
				
				key2 = string.format( "spell:%s", data.sid )
				
				if not ArkInventory.Const.ItemCrossReference[key1] then
					ArkInventory.Const.ItemCrossReference[key1] = { }
				end
				ArkInventory.Const.ItemCrossReference[key1][key2] = true
				
				if not ArkInventory.Const.ItemCrossReference[key2] then
					ArkInventory.Const.ItemCrossReference[key2] = { }
				end
				ArkInventory.Const.ItemCrossReference[key2][key1] = true
				
				if data.mt then
					-- store mount flag values
					ArkInventory.MountJournal.StoreMountType( data.sid, data.mt )
				end
				
				data.sid = nil
				
			end
			
		end
		
		
	end
	
	if wipe then
		table.wipe( TempData )
		TempData = nil
	end
	
end


function ArkInventory.CompanionDataUpdate( )
	
	importCompanionCrossRefTable( )
	
	ArkInventory.MountJournal.ApplyUserCorrections( )
	
end
