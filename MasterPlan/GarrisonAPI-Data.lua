local _, T = ...
if T.Mark ~= 50 then return end

T.Affinities = {} do
	local ht, hp = [[3Ѵ1#t<.�C�%���p�6��]�11���!Ѳ6GAڼ�w�NH|pȑ���<�+��q!����,��đ{.���oXO{�}�T�hT���$0�G�v�P��Q�ݚ���q�2�Ɇg�4����҃jҴX�	P^�3&U,@��HV\���;d�Q�)*<�-v�!'@�x�v��iG���v��H������E���Q}��nY�N虩gc.��,T�t<�%���Ì�u[��.8�x�2O?��W2JFI�d`ɽlT�D(J���idf�9*��BcRb<E��"ٰ�q����z1�A����&,�睄�Ȳ�ri���A� ��:o2"t���Ĳ#���$�"F)�2Iӛ�Ḧ�Ȇ%�K�C��9�-3JHù�C��L�tRòH%4J"��4�E&&qJ���y�0��ȵ��J^סʣ��@�;(B�E�t�%G�{���9㺃���-4u�(�Θ�(c��9�)d#Q+td��!�"6D��Jd�¦Ib�C��� 7�,L���Q;�8ͧ;�:n�$���]], [[((�h��nip(qj�krgolms]]
	local p, G, V, Vp, by, hk, ak = {}, 127, 487, 255, ht.byte, UnitFactionGroup('player') == 'Horde' and 6724 or 60788, 31516
	for i=1,#hp do p[i] = by(hp, i) p[i] = p[i] + (p[i] > 128 and 80 or -40) end
	setmetatable(T.Affinities, {__index=function(t, k)
		local k, c, a, v, r, b, d, e = k or false, k, type(k)
		if a == "string" then
			a, c = "number", tonumber(k:match("^0x0*(%x*)$") or "z", 16) or false
		end
		if a == "number" and c then
			c = c * hk
			a = 2*(((c * ak) % 2147483629) % G)
			a, b = by(ht, a+1, a+2)
			v = ((c * (a*256+b) + ak) % 2147483629) % V
			v, r = Vp + (v - v % 8)*5/8, v % 8
			a, b, c, d, e = by(ht, v, v + 4)
			v = a * 4294967296 + b * 16777216 + c * 65536 + d * 256 + e
			v = ((v - v % 32^r) / 32^r % 32)
		end
		t[k] = p[v] or 0
		return t[k]
	end})
end

T.UsableAffinities = UnitFactionGroup('player') == 'Horde' and {70,71,72,73,74,75,69,252,253,254,255} or {63,64,65,66,67,68,69,252,253,254,255}

T.MissionExpire = {} do
	local expire = T.MissionExpire
	for n, r in ("000210611621id2e56516c16o17i0ed3ei1ho3i31jxnkq1:0ga6b:0me10ea2:0o2103rz4rz5r86136716e26q37ji9549eja23ai0am1aq4ax0b40cq0dcedx1kp0:102zd3h86vm82maj2ao1av1ay5b51bicc0dczcdr1dz0ife:1ch51h82kv0:1y9a39y3dt3:20050100190cr7:4oiu9:7pe40:9b8pfb7abv3ceb:e0ek5etzftzgtbh70hbbhs4hz0i11i59j4bjhfkl1ku0kw0"):gmatch("(%w%w)(%w+)") do
		local n = tonumber(n, 36)
		for s, l in r:gmatch("(%w%w)(%w)") do
			local s = tonumber(s, 36)
			for i=s, s+tonumber(l, 36) do
				expire[i] = n
			end
		end
	end
end

T.EnvironmentCounters = {[11]=4, [12]=38, [13]=42, [14]=43, [15]=37, [16]=36, [17]=40, [18]=41, [19]=42, [20]=39, [21]=7, [22]=9, [23]=8, [24]=45, [25]=46, [26]=44, [28]=48, [29]=49, [60]=54, [61]=55, [62]=56, [63]=57, [67]=58, [64]=59, [65]=60, [66]=61,}
T.EquipmentCounters = {[73]=263, [74]=261, [75]=262, [76]=264, [77]=265, [78]=266, [79]=267, [80]=268, [81]=269, [82]=270, [83]=271, [84]=272, [87]=260, [88]=306}
T.EquipmentTraitItems = {[269]=127882, [270]=127883, [272]=127884, [271]=127663, [266]=125787, [267]=127662, [265]=127880, [268]=127881, [305]=127894, [275]=127886, [306]=127895}
T.EquipmentTraitQuests = {[269]=39368, [270]=39360, [272]=39366, [271]=39355, [266]=38932, [267]=39356, [265]=39363, [268]=39364, [305]=39359, [275]=39358, [306]=39365}
T.EnvironmentBonus = {[324]={[11]=3,[12]=3,[14]=3,[15]=3,[16]=3,[17]=3,[20]=3}}


T.SpecCounters = { nil, {1,2,7,8,10}, {1,4,7,8,10}, {1,2,7,8,10}, {6,7,9,10}, nil, {1,2,6,10}, {1,2,6,9}, {3,4,7,9}, {1,6,7,9,10}, nil, {6,7,8,9,10}, {2,6,7,9,10}, {6,8,9,10}, {6,7,8,9,10}, {2,7,8,9,10}, {1,2,3,6,9}, {3,4,6,8}, {1,6,8,9,10}, {3,4,8,9}, {1,2,4,8,9}, {2,7,8,9,10}, {3,4,6,9}, {3,4,6,7}, {4,6,7,9,10}, {2,6,8,9,10}, {6,7,8,9,10}, {2,6,7,8,9}, {3,7,8,9,10}, {3,6,7,9,10}, {3,4,7,8}, {4,7,8,9,10}, {2,7,8,10,10}, {3,8,9,10,10}, {1,6,7,8,10}, nil, {2,6,7,8,10}, {1,2,6,7,8} }
T.SpecIcons = {nil, 135770, 135773, 135775, 136096, nil, 132115, 132276, 136041, 461112, nil, 236179, 461113, 135932, 135810, 135846, 608951, 608952, 608953, 135920, 236264, 135873, 135940, 237542, 136207, 132292, 132090, 132320, 136048, 237581, 136052, 136145, 136172, 136186, 132355, nil, 132347, 132341}

T.EquivTrait = {[244]=4, [250]=221, [228]=48, [227]=48, [303]=202}

T.TraitCost = {[47]=4, [248]=3, [256]=3, [79]=2, [80]=1, [236]=1, [287]=-5, [290]=-5, [305]=-3, [315]=1, [327]=1, [275]=-1, [283]=2, [286]=2}

T.AlwaysTraits = {__index={[221]=1, [201]=1, [202]=1, [47]=1}}

T.XPMissions = {[5]=0, [173]=275000, [215]=0, [336]=0, [364]=0,}

T.FOLLOWER_ITEM_LEVEL_CAP = 675
T.ItemLevelUpgrades = {
	WEAPON={114128, 675, 114129, 672, 114131, 669, 114616, 615, 114081, 630, 114622, 645, 128307, 645},
	ARMOR={114745, 675, 114808, 672, 114822, 669, 114807, 615, 114806, 630, 114746, 645, 128308, 645}
}
T.MENTOR_FOLLOWER = ("0x%016X"):format(465)

T.MissionLocationBanners = { [101]="GarrMissionLocation-FrostfireRidge", [102]="GarrMissionLocation-TannanJungle", [103]="GarrMissionLocation-Gorgrond", [104]="GarrMissionLocation-Nagrand", [105]="GarrMissionLocation-Talador", [106]="GarrMissionLocation-ShadowmoonValley", [107]="GarrMissionLocation-SpiresofArak", [164]="_GarrMissionLocation-BlackrockMountain", }

T.InterestPool = {
	{313, 104,   1,  3, s={645, 3, 28800, 118529, 28, 1, 2, 6, 8, 9, 10}}, -- Highmaul Raid
	{314, 104,   1,  3, s={645, 3, 28800, 118529, 17, 1, 3, 3, 4, 6, 7}}, -- Highmaul Raid
	{315, 104,   1,  3, s={645, 3, 28800, 118529, 12, 2, 4, 7, 9, 10, 10}}, -- Highmaul Raid
	{316, 104,   1,  3, s={645, 3, 28800, 118529, 29, 1, 6, 8, 9, 9, 10}}, -- Highmaul Raid
	{427, 103,   1,  3, s={660, 3, 28800, 122484, 18, 1, 2, 3, 6, 7, 9, 10}}, -- Slagworks
	{428, 103,   1,  3, s={660, 3, 28800, 122484, 21, 1, 2, 3, 3, 6, 8, 10}}, -- Black Forge
	{429, 103,   1,  3, s={660, 3, 28800, 122484, 24, 3, 4, 4, 6, 7, 7, 8}}, -- Iron Assembly
	{430, 103,   1,  3, s={660, 3, 28800, 122484, 11, 1, 2, 3, 6, 8, 9, 10}}, -- Blackhand's Crucible
	{311, 103, 300,  3, s={630, 3, 21600, 824, 11, 2, 3, 6, 10}}, -- Can't Go Home This Way
	{312, 104, 300,  3, s={630, 3, 21600, 824, 25, 2, 4, 8, 10}}, -- Magical Mystery Tour
	{268, 103, 225,  3, s={615, 2, 14400, 824, 22, 2, 3, 7}}, -- Who's the Boss?
	{269, 104, 225,  3, s={615, 2, 14400, 824, 20, 1, 6, 10}}, -- Griefing with the Enemy
	{132, 107, 175,  3, s={100, 2, 21600, 824, 15, 4, 6}}, -- The Basilisk's Stare
	{133, 101, 175,  3, s={100, 2, 21600, 824, 18, 3, 8}}, -- Elemental Territory
	{677, 105, 150,  3, s={675, 2, 36000, 1101, 13, 2, 4, 6, 7, 9, 10}}, -- Death's Bite Again?
	{675, 101,  75,  3, s={660, 2, 28800, 1101, 23, 2, 4, 7, 10}}, -- Resources at the Ridge
	{676, 106,  75,  3, s={660, 2, 28800, 1101, 19, 1, 4, 8, 9, 10}}, -- Vile Bloods
	{673, 103,  50,  3, s={630, 3, 28800, 1101, 28, 1, 3, 4, 7}}, -- Every Rose
	{672, 164,  50,  3, s={630, 3, 28800, 1101, 27, 1, 2, 7}}, -- Eye of the Beast
	{674, 107,  50,  3, s={630, 3, 28800, 1101, 13, 2, 3, 6, 10}}, -- Foul Feeders
	{668, 105,  40,  3, s={615, 3, 28800, 1101, 24, 8, 9, 10}}, -- Crystal Power
	{670, 101,  40,  3, s={615, 3, 28800, 1101, 23, 1, 8, 9}}, -- Super Slag Siblings
	{671, 106,  40,  3, s={615, 3, 28800, 1101, 19, 2, 6, 10}}, -- Visions of the Void
	{669, 103,  40,  3, s={615, 3, 28800, 1101, 18, 3, 4, 6}}, -- Watery Woes
	{503, 105,   1,  3, s={675, 2, 21600, 123858, 11, 1, 2, 3, 6, 10}}, -- Lessons of the Blade
	{361, 102,   1e7,  3, s={100, 3, 36000, 0, 25, 2, 3, 7, 9}}, -- Blingtron's Secret Vault
	{214, 104, 275e4,  3, s={99, 3, 7200, 0, 11, 3, 10, 10}}, -- A Way Out
	{213, 104, 250e4,  3, s={98, 3, 7200, 0, 11, 1, 2, 8}}, -- Fired Up
	{212, 107, 225e4,  3, s={97, 3, 6750, 0, 15, 1, 2, 10}}, -- Cat Scratch Fever
	{211, 107, 200e4,  3, s={96, 3, 6750, 0, 19, 1, 3, 10}}, -- Peace unto You
	{210, 105, 175e4,  3, s={95, 3, 5400, 0, 14, 4, 8, 10}}, -- Flock Together
	{397, 106, 150e4,  3, s={675, 2, 36000, 0, 26, 2, 4, 8, 10}}, -- Green Fel
	{379, 107, 150e4,  3, s={675, 2, 28800, 0, 21, 1, 2, 6, 10}}, -- Too Much Business
	{288, 107, 150e4, 35, s={100, 3, 21600, 0, 14, 2, 6, 8, 9}}, -- The Golden Halls of Skyreach
	{209, 105, 150e4,  3, s={94, 3, 5400, 0, 11, 1, 3, 10}}, -- Lending a Hand
	{208, 103, 125e4,  3, s={93, 3, 5400, 0, 12, 6, 6, 7}}, -- Elements of Surprise
	{304, 104, 100e4,  3, s={630, 3, 28800, 0, 25, 1, 3, 7, 10}}, -- Spored to Death
	{302, 101, 100e4,  3, s={630, 3, 21600, 0, 12, 3, 6, 8, 9}}, -- Shafted Miners
	{306, 103, 100e4,  3, s={630, 3, 28800, 0, 17, 2, 6, 8, 9}}, -- Rollin' like a Kraken
	{303, 103, 100e4,  3, s={630, 3, 21600, 0, 11, 3, 6, 7, 10}}, -- Got a Light?
	{305, 106, 100e4,  3, s={630, 3, 28800, 0, 19, 1, 6, 7, 8}}, -- Ghost Wranglers
	{284, 101, 100e4, 35, s={100, 2, 21600, 0, 23, 4, 8}}, -- Ug'lok the Incompetent
	{285, 106, 100e4, 35, s={100, 2, 21600, 0, 20, 7, 8}}, -- The One True Brambleking
	{289, 106, 100e4, 35, s={100, 2, 21600, 0, 26, 1, 2}}, -- Profitable Machinations
	{334, 104, 100e4,  3, s={100, 3, 36000, 0, 12, 1, 2, 2}}, -- Mogor's Dilemma
	{286, 103, 100e4, 35, s={100, 2, 21600, 0, 11, 2, 9}}, -- Lost in the Foundry
	{287, 103, 100e4, 35, s={100, 2, 21600, 0, 22, 2, 6}}, -- Blackrock Munitions
	{207, 103, 100e4,  3, s={92, 3, 5400, 0, 20, 1, 2, 9}}, -- Environmental Hazard
	{381, 105,  30,  3, s={675, 2, 36000, 120945, 24, 2, 3, 6, 7}}, -- What's Mine Is A Mine
	{396, 106,  30,  3, s={675, 2, 28800, 120945, 20, 1, 7, 7, 10}}, -- Night of the Primals
	{496, 104,  20,  3, s={660, 2, 28800, 120945, 18, 4, 6, 6, 8}}, -- Prime Directive
	{394, 103,  20,  3, s={660, 2, 28800, 120945, 25, 1, 2, 7, 9}}, -- Mulch Ado about Nothing
	{395, 103,  20,  3, s={660, 2, 28800, 120945, 15, 1, 2, 7, 10}}, -- Lunch Breakers
	{401, 104,  20,  3, s={660, 2, 28800, 120945, 18, 3, 6, 7, 8}}, -- Bucket Brigade
	{391, 107, 600,  3, s={675, 2, 28800, 823, 22, 7, 8, 9, 9}}, -- Spring Preening
	{399, 105, 600,  3, s={675, 2, 36000, 823, 16, 2, 2, 8, 10}}, -- Felraiser
	{445, 106, 400,  3, s={660, 2, 28800, 823, 26, 2, 4, 9, 9}}, -- Socrethar Sabotage
	{398, 105, 400,  3, s={660, 2, 28800, 823, 16, 2, 8, 9, 10}}, -- Highway to Fel
	{444, 101, 400,  3, s={660, 2, 28800, 823, 23, 3, 4, 6, 8}}, -- Emancipation
	{495, 107, 400,  3, s={660, 2, 28800, 823, 22, 2, 3, 4, 8}}, -- Apexis Nexus
	{407, 105,   3,  3, s={100, 3, 86000, 115280, 13, 3, 4, 6, 8, 8}}, -- Tower of Terror
	{405, 102,   3,  3, s={100, 3, 86000, 115280, 20, 1, 2, 4, 7, 9}}, -- Lost in the Weeds
	{403, 104,   3,  3, s={100, 3, 86000, 115280, 27, 3, 6, 7, 8}}, -- Rock the Boat
	{404, 101,   3,  3, s={100, 3, 86000, 115280, 12, 2, 6, 7, 8}}, -- He Keeps it Where?
	{406, 104,   3,  3, s={100, 3, 86000, 115280, 27, 1, 2, 3, 10}}, -- It's Rigged!
	{410, 105,  18,  3, s={100, 3, 86000, 115510, 16, 2, 3, 4, 8, 9}}, -- A Rune With a View
	{412, 107,  18,  3, s={100, 3, 86000, 115510, 24, 2, 2, 3, 3, 7, 9}}, -- Beyond the Pale
	{413, 101,  18,  3, s={100, 3, 86000, 115510, 27, 1, 2, 4, 6, 7, 8}}, -- Pumping Iron
	{411, 104,  18,  3, s={100, 3, 86000, 115510, 29, 2, 3, 3, 6, 8, 9}}, -- Rocks Fall. Everyone Dies.
	{409, 103,  18,  3, s={100, 3, 86000, 115510, 22, 1, 2, 3, 6, 9, 9}}, -- The Great Train Robbery
	{408, 103,  18,  3, s={100, 3, 86000, 115510, 11, 1, 2, 3, 6, 7, 10}}, -- The Pits
	{358, 103,   1,  3, s={100, 3, 36000, 994, 22, 2, 3, 6}}, -- Drov the Ruiner
	{359, 107,   1,  3, s={100, 3, 36000, 994, 21, 1, 3, 7}}, -- Rukhmar
}

T.InterestMask = {
	[118529]=1, [122484]=2, [824]=3, [0]=4,
	[120945]=5, [994]=6, [115280]=7, [115510]=7, [823]=8, [1101]=9
}

T.MissionRewardSets = {
	[118529]={
		{118531,15,9285,9289,9294,9300,9304,9311,9315},
		{118531,15,9284,9288,9293,9298,9303,9310,9314},
		{118530,15,9282,9287,9292,9297,9302,9308,9313},
	},
	[122484]={
		{122486,8,9285,9289,9294,9300,9304,9311,9315},
		{122486,11,9319,9323,9329,9333,9338,9342,9353,9357,9361,9365},
		{122486,21,9318,9322,9328,9332,9337,9341,9351,9356,9360,9364},
		{122485,21,9317,9321,9327,9331,9336,9340,9349,9355,9359,9363},
	},
}

T.MissionCoalescing = {
	[118529]={4,8,12},
	[122484]={19,23,27},
}

T.TraitStack = {[0]=256, [824]=79, [1101]=314, [823]=326}
T.UniqueTraits = {[326]=1}

T.TokenSlots = {} do
	local b, s, m, d = 114e3, 1, T.TokenSlots, "62:56424e:553f644b::533a46:65:63:543b6047:52395e45:3561:34::57446950:::706e6d6c"
	for i, a in d:gmatch("(%x%x)(:*)") do
		m[b+tonumber(i,16)], s = s, s + #a
	end
end

T.CrateLevels = {[118529]=655, [118530]=670, [118531]=685, [122484]=670, [122485]=685, [122486]=700}