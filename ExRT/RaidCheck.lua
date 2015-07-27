local GlobalAddonName, ExRT = ...

local IsEncounterInProgress, GetTime = IsEncounterInProgress, GetTime

local VExRT = nil

local module = ExRT.mod:New("RaidCheck",ExRT.L.raidcheck,nil,true)
module.db.isEncounter = nil
module.db.tableFood = {
--Stamina,	Spirit,		Int,		Agi,		Str 		Crit		Haste		Mastery		MS		Versatility	Armor
[160600]=50,	[160778]=50,							[160724]=50,	[160726]=50,	[160793]=50,	[160832]=50,	[160839]=50,	[160722]=50,
[160600]=75,	[160895]=75,							[160889]=75,	[160893]=75,	[160897]=75,	[160900]=75,	[160902]=75,	[160885]=75,	
[175784]=75,									[174062]=75,	[174079]=75,	[174077]=75,	[174080]=75,	[174078]=75,			--Blue food
										[175785]=75,
[160883]=100,									[175218]=100,	[175219]=100,	[175220]=100,	[175222]=100,	[175223]=100,
[165802]=100,
[180747]=125,									[180745]=125,	[180748]=125,	[180750]=125,	[180749]=125,	[180746]=125,

[188534]=125, --new food
}
module.db.StaminaFood = {[160600]=true,[175784]=true,[160883]=true,[165802]=true,[180747]=true}

module.db.tableFood_headers = {0,50,75,100,125}
module.db.tableFlask = {
	--Stamina,	Spirit,		Int,		Agi,		Str 
	[156077]=200,			[156070]=200,	[156073]=200,	[156071]=200,
	[156084]=250,			[156079]=250,	[156064]=250,	[156080]=250,
}
module.db.tableFlask_headers = {0,200,250}
module.db.tablePotion = {
	[105702]=true,	[156426]=true,	--Int
	[105697]=true,	[156423]=true,	--Agi	
	[105706]=true,	[156428]=true,	--Str
	[105709]=true,	[156436]=true,	--Mana 3k, 17k
	[105701]=true,	[156432]=true,	--Mana 4.5k, 25.5k
	[105707]=true,			--Run haste
	[105698]=true,	[156430]=true,	--Armor
	--[105708]=true,[156438]=true,	--Health
	[105704]=true,	[156455]=true,	--Health + Mana [alchim]	
	[125282]=true,			--Kafa Boost
}
module.db.hsSpells = {
	[6262] = true,
	[105708] = true,
	[156438] = true,
}
module.db.potionList = {}
module.db.hsList = {}
module.db.tableFoodInProgress = nil
module.db.RaidCheckReadyCheckHide = nil
module.db.RaidCheckReadyCheckTime = nil
module.db.RaidCheckReadyCheckTable = {}
module.db.RaidCheckReadyPPLNum = 0
module.db.RaidCheckReadyCheckHideSchedule = nil

module.db.tableRunes = {
	[175456]=true,	--Agi
	[175457]=true,	--Int
	[175439]=true,	--Str
}

module.db.buffsList = {"STAMINA","STATS","MASTERY","CRIT","HASTE","MS","VERSA","SPD","AP"}
module.db.buffsNames = {
	STAMINA = RAID_BUFF_2 or "Stamina",
	STATS = RAID_BUFF_1 or "Stats",
	MASTERY = RAID_BUFF_7 or "Mastery",
	CRIT = RAID_BUFF_6 or "Crit",
	HASTE = RAID_BUFF_4 or "Haste",
	MS = RAID_BUFF_8 or "Ms",
	VERSA = RAID_BUFF_9 or "Versatility",
	SPD = RAID_BUFF_5 or "SPD",
	AP = RAID_BUFF_3 or "AP",
}

do
	local function SpellName(spellID)
		local name = GetSpellInfo(spellID)
		return name or "UNK BUFF NAME"
	end
	module.db.buffsSpells = {
		STAMINA={
			SpellName(21562),	-- Power Word: Fortitude
			SpellName(166928),	-- Blood Pact
			SpellName(469), 	-- Commanding Shout
			SpellName(90364),	-- Silithid, Qiraji Fortitude
			SpellName(50256),	-- Bear, Invigorating Roar
			SpellName(160014),	-- Goat, Sturdiness
			SpellName(160199),	-- Hunter, level 100
		},
		STATS={
			SpellName(20217),	-- Blessing of Kings
			SpellName(1126),	-- Mark of the Wild
			SpellName(116781),	-- Legacy of the White Tiger
			SpellName(115921),	-- Legacy of the Emperor
			SpellName(90363),	-- Shale Spider, Embrace of the Shale Spider
			SpellName(159988),	-- Dog, Bark of the Wild
			SpellName(160017),	-- Gorilla, Blessing of Kongs
			SpellName(160077),	-- Worm, Strength of the Earth
			SpellName(160206),	-- Hunter, level 100
		},
		MASTERY={
			SpellName(19740),	-- Blessing of Might
			SpellName(155522),	-- Power of the Grave
			SpellName(116956),	-- Grace of Air
			SpellName(24907),	-- Moonkin Aura
			SpellName(93435),	-- Cat, Roar of Courage
			SpellName(128997),	-- Spirit Beast, Spirit Beast Blessing
			SpellName(160073),	-- Tallstrider, Plainswalking
			SpellName(160039),	-- Hydra, Keen Senses
			SpellName(160198),	-- Hunter, level 100
		},
		CRIT={
			SpellName(116781),	-- Legacy of the White Tiger
			SpellName(17007),	-- Leader of the Pack
			SpellName(1459),	-- Arcane Brilliance
			SpellName(61316),	-- Dalaran Brilliance
			SpellName(24604),	-- Wolf, Furious Howl
			SpellName(90309),	-- Devilsaur, Terrifying Roar
			SpellName(126373),	-- Quilen, Fearless Roar
			SpellName(126309),	-- Water Strider, Still Water
			SpellName(90363),	-- Shale Spider, Embrace of the Shale Spider
			SpellName(160052),	-- Raptor, Strength of the Pack
			SpellName(160200),	-- Hunter, level 100
		},
		HASTE={
			SpellName(55610),	-- Unholy Aura
			SpellName(116956),	-- Grace of Air
			SpellName(49868),	-- Mind Quickening
			SpellName(113742),	-- Swiftblade's Cunning
			SpellName(135678),	-- Sporebat, Energizing Spores
			SpellName(128432),	-- Hyena, Cackling Howl
			SpellName(160074),	-- Wasp, Speed of the Swarm
			SpellName(160203),	-- Hunter, level 100
		},
		MS={
			SpellName(166916),	-- Windflurry
			SpellName(49868),	-- Mind Quickening
			SpellName(113742),	-- Swiftblade's Cunning
			SpellName(109773),	-- Dark Intent
			SpellName(50519),	-- Bat, Sonic Focus
			SpellName(159736), 	-- Chimaera, Duality
			SpellName(57386),	-- Clefthoof, Wild Strength
			SpellName(58604),	-- Core Hound, Double Bite
			SpellName(34889),	-- Dragonhawk, Spry Attacks
			SpellName(24844),	-- Wind Serpent, Breath of the Winds
			SpellName(172968),	-- Hunter, level 100
		},
		VERSA={
			SpellName(167187),	-- Sanctity Aura
			SpellName(167188),	-- Inspiring Presence
			SpellName(55610),	-- Unholy Aura
			SpellName(1126),	-- Mark of the Wild
			SpellName(159735),	-- Bird of Prey, Tenacity
			SpellName(35290),	-- Boar, Indomitable
			SpellName(57386),	-- Clefthoof, Wild Strength
			SpellName(160045),	-- Porcupine, Defensive Quills
			SpellName(50518),	-- Ravager, Chitinous Armor
			SpellName(160077),	-- Worm, Strength of the Earth
			SpellName(172967),	-- Hunter, level 100
		},
		SPD={
			SpellName(1459),	-- Arcane Brilliance
			SpellName(61316),	-- Dalaran Brilliance
			SpellName(109773),	-- Dark Intent
			SpellName(126309),	-- Water Strider, Still Water
			SpellName(90364),	-- Silithid, Qiraji Fortitude
			SpellName(128433),	-- Serpent, Serpent's Cunning
			SpellName(160205),	-- Hunter, level 100
		},
		AP={
			SpellName(19506),	-- Trueshot Aura
			SpellName(6673),	-- Battle Shout
			SpellName(57330),	-- Horn of Winter
		},
	}
end

local IsSendFoodByMe,IsSendFlaskByMe,IsSendRunesByMe,IsSendBuffsByMe = nil

local function GetPotion(arg1)
	local h = ExRT.L.raidcheckPotion
	local t = {}
	for key,val in pairs(module.db.potionList) do
		t[#t+1] = {key,val}
	end

	local function toChat(h)
		local chat_type = ExRT.mds.chatType(true)
		if arg1 == 2 then print(h) end
		if arg1 == 1 then SendChatMessage(h,chat_type) end  
	end

	table.sort(t,function(a,b) return a[2]>b[2] end)
	for i=1,#t do
		h = h .. format("%s %d%s",t[i][1],t[i][2],i<#t and ", " or "")
		if #h > 230 then
			toChat(h)
			h = ""
		end
	end
	toChat(h)
end

local function GetHs(arg1)
	local h = ExRT.L.raidcheckHS
	local t = {}
	for key,val in pairs(module.db.hsList) do
		t[#t+1] = {key,val}
	end

	local function toChat(h)
		local chat_type = ExRT.mds.chatType(true)
		if arg1 == 2 then print(h) end
		if arg1 == 1 then SendChatMessage(h,chat_type) end
	end

	table.sort(t,function(a,b) return a[2]>b[2] end)
	for i=1,#t do
		h = h .. format("%s %d%s",t[i][1],t[i][2],i<#t and ", " or "")
		if #h > 230 then
			toChat(h)
			h = ""
		end
	end
	toChat(h)
end

--[[
	Check Types:
	
	1 - to chat
	2 - ready check
	3 - ready check (self)
	nil - self
]]

local function PublicResults(msg,chat_type)
	if msg == "" or not msg then
		return
	elseif chat_type then
		msg = msg:gsub("|c........","")
		msg = msg:gsub("|r","")
	
		chat_type = ExRT.mds.chatType(true)
		SendChatMessage(msg,chat_type)
	else
		print(msg)
	end
end


local function GetRunes(checkType)
	local f = {[0]={},[50]={}}
	local gMax = ExRT.mds.GetRaidDiffMaxGroup()
	for j=1,40 do
		local name,_,subgroup = GetRaidRosterInfo(j)
		if name and subgroup <= gMax then
			local isAnyBuff = nil
			for i=1,40 do
				local spellId = select(11,UnitAura(name, i,"HELPFUL"))
				if not spellId then
					break
				else
					local isRune = module.db.tableRunes[spellId]
					if isRune then
						f[50][ #f[50]+1 ] = name
						isAnyBuff = true
					end
				end
			end
			if not isAnyBuff then
				f[0][ #f[0]+1 ] = name
			end
		end
	end
	
	if not checkType or checkType == 1 then
		for _,stats in ipairs({0,50}) do
			local result = format("|cff00ff00%d (%d):|r ",stats,#f[stats])
			for i=1,#f[stats] do
				result = result .. f[stats][i]
				if #result > 230 then
					PublicResults(result,checkType)
					result = ""
				elseif i ~= #f[stats] then
					result = result .. ", "
				end
			end
			PublicResults(result,checkType)
		end
	elseif checkType == 2 or checkType == 3 then
		if checkType == 3 then
			checkType = nil
		end
		local result = format("|cff00ff00%s (%d):|r ",ExRT.L.RaidCheckNoRunes,#f[0])
		for i=1,#f[0] do
			result = result .. f[0][i]
			if #result > 230 then
				PublicResults(result,checkType)
				result = ""
			elseif i ~= #f[0] then
				result = result .. ", "
			end
		end
		PublicResults(result,checkType)
	end
end

local function GetFood(checkType)
	local f = {[0]={}}
	local gMax = ExRT.mds.GetRaidDiffMaxGroup()
	for j=1,40 do
		local name,_,subgroup = GetRaidRosterInfo(j)
		if name and subgroup <= gMax then
			local isAnyBuff = nil
			for i=1,40 do
				local spellId,_,_,_,stats = select(11,UnitAura(name, i,"HELPFUL"))
				if not spellId then
					break
				else
					local foodType = module.db.tableFood[spellId]
					if foodType then
						local _,unitRace = UnitRace(name)
						
						if unitRace == "Pandaren" and stats then
							stats = stats / 2
						end
						if module.db.StaminaFood[spellId] and stats then
							stats = ceil( stats / 1.5 )
						end
						stats = stats or foodType
						if spellId == 188534 then stats = 125 end
					
						f[stats] = f[stats] or {}
						f[stats][ #f[stats]+1 ] = name
						if ExRT.mds.table_find(module.db.tableFood_headers,stats) then
							isAnyBuff = true
						end
					end
				end
			end
			if not isAnyBuff then
				f[0][ #f[0]+1 ] = name
			end
		end
	end
	
	if not checkType or checkType == 1 then
		for _,foodType in ipairs(module.db.tableFood_headers) do
			f[foodType] = f[foodType] or {}
			local result = format("|cff00ff00%d (%d):|r ",foodType,#f[foodType])
			for j=1,#f[foodType] do
				result = result .. f[foodType][j] .. (j < #f[foodType] and ", " or "")
				if #result > 230 then
					PublicResults(result,checkType)
					result = ""
				end
			end
			PublicResults(result,checkType)
		end
	elseif checkType == 2 or checkType == 3 then
		if checkType == 3 then
			checkType = nil
		end
		local counter,counterResult = 0,0
		local badStats = {}
		for statsNum,data in pairs(f) do
			if ((VExRT.RaidCheck.FoodMinLevel and statsNum < VExRT.RaidCheck.FoodMinLevel) or (not VExRT.RaidCheck.FoodMinLevel and statsNum == 0)) and #data > 0 then
				badStats[#badStats + 1] = statsNum
				counter = counter + #data
			end
		end
		sort(badStats)
		local result = format("|cff00ff00%s (%d):|r ",ExRT.L.raidchecknofood,counter)
		for i=1,#badStats do
			local statsNum = badStats[i]
			for j=1,#f[statsNum] do
				counterResult = counterResult + 1
				result = result .. f[statsNum][j].. (statsNum ~= 0 and "("..statsNum..")" or "") .. (counterResult < counter and ", " or "")
				if #result > 220 then
					PublicResults(result,checkType)
					result = ""
				end
			end
		end
		PublicResults(result,checkType)
	end
end

local function GetFlask(checkType)
	local f = {[0]={}}
	local gMax = ExRT.mds.GetRaidDiffMaxGroup()
	local _time = GetTime()
	for j=1,40 do
		local name,_,subgroup = GetRaidRosterInfo(j)
		if name and subgroup <= gMax then
			local isAnyBuff = nil
			for i=1,40 do
				local expires,_,_,_,spellId = select(7,UnitAura(name, i,"HELPFUL"))
				if not spellId then
					break
				else
					local flaskType = module.db.tableFlask[spellId]
					if flaskType then
						f[flaskType] = f[flaskType] or {}
						expires = expires or -1
						local lost = expires-_time
						if expires == 0 or lost < 0 then
							lost = 901
						end
						f[flaskType][ #f[flaskType]+1 ] = {name,lost}
						if ExRT.mds.table_find(module.db.tableFlask_headers,flaskType) then
							isAnyBuff = true
						end
					end
				end
			end
			if not isAnyBuff then
				f[0][ #f[0]+1 ] = {name,901}
			end
		end
	end
	for flaskType,typeData in pairs(f) do
		table.sort(typeData,function(a,b) return a[2]<b[2] end)
	end
	
	local showExpFlasks_seconds = VExRT.RaidCheck.FlaskExp == 1 and 300 or VExRT.RaidCheck.FlaskExp == 2 and 600 or -1
	
	if not checkType or checkType == 1 then
		for i=1,#module.db.tableFlask_headers do
			local flaskStats = module.db.tableFlask_headers[i]
			f[ flaskStats ] = f[ flaskStats ] or {}
			local result = format("|cff00ff00%d (%d):|r ",flaskStats,#f[ flaskStats ])
			for j=1,#f[ flaskStats ] do
				result = result .. format("%s%s",f[ flaskStats ][j][1] or "?", j < #f[ flaskStats ] and ", " or "")
				if #result > 230 then
					PublicResults(result,checkType)
					result = ""
				end
			end
			PublicResults(result,checkType)
		end
	elseif checkType == 2 or checkType == 3 then
		if checkType == 3 then
			checkType = nil
		end
		f[0] = f[0] or {}
		local result = format("|cff00ff00%s (%d):|r ",ExRT.L.raidchecknoflask,#f[0])
		for j=1,#f[0] do
			result = result .. format("%s%s",f[0][j][1] or "?",j < #f[0] and ", " or "")
			if #result > 230 then
				PublicResults(result,checkType)
				result = ""
			end
		end
		local strings_list = {}
		for i=1,#module.db.tableFlask_headers do
			local flaskStats = module.db.tableFlask_headers[i]
			if flaskStats ~= 0 then
				f[ flaskStats ] = f[ flaskStats ] or {}
				for j=1,#f[ flaskStats ] do
					if f[ flaskStats ][j][2] <= showExpFlasks_seconds and f[ flaskStats ][j][2] >= 0 then
						local mins = floor( f[ flaskStats ][j][2] / 60 )
						strings_list[#strings_list + 1] = format("%s%s",f[ flaskStats ][j][1] or "?", "("..(mins == 0 and "<1" or tostring(mins))..")")
					end
				end
			end
		end
		local strings_list_len = #strings_list
		if strings_list_len > 0 then
			result = result .. ( #f[0] > 0 and result ~= "" and ", " or "" )
		end
		for i=1,strings_list_len do
			result = result .. strings_list[i] .. (i < strings_list_len and ", " or "")
			if #result > 230 then
				PublicResults(result,checkType)
				result = ""
			end
		end
		PublicResults(result,checkType)
	end
end

local function GetRaidBuffs(checkType)
	local f = {}
	for i=1,#module.db.buffsList do f[i]={} end
	local gMax = ExRT.mds.GetRaidDiffMaxGroup()
	for i=1,40 do
		local name,_,subgroup,_,_,_,_,online,isDead = GetRaidRosterInfo(i)
		if name and subgroup <= gMax and online and not isDead then
			for j=1,#module.db.buffsList do
				local isAnyBuff = nil
				local buffTable = module.db.buffsSpells[  module.db.buffsList[j]  ]
				for k=1,#buffTable do
					local auraExists = UnitAura(name, buffTable[k])
					if auraExists then
						isAnyBuff = true
						break
					end
				end
				if not isAnyBuff then
					f[j][ #f[j]+1 ] = name
				end
			end
		end
	end

	if not checkType or checkType == 1 then
		for i=1,#f do
			local result = format("|cff00ff00%s (%d):|r ",module.db.buffsNames[ module.db.buffsList[i] ],#f[i])
			for j=1,#f[i] do
				result = result .. format("%s%s",f[i][j] or "?", j < #f[i] and ", " or "")
				if #result > 230 then
					PublicResults(result,checkType)
					result = ""
				end
			end
			PublicResults(result,checkType)
		end
	elseif checkType == 2 or checkType == 3 then
		if checkType == 3 then
			checkType = nil
		end
		local missingCount = 0
		for i=1,#f do
			if #f[i] > 0 then
				missingCount = missingCount + 1
			end
		end
		local result = format("|cff00ff00%s (%d):|r ",ExRT.L.RaidCheckNoBuffs,missingCount)
		local missingNow = 0
		for i=1,#f do
			if #f[i] > 0 then
				missingNow = missingNow + 1
				result = result .. module.db.buffsNames[ module.db.buffsList[i] ] .. (missingNow < missingCount and ", " or "")
				if #result > 230 then
					PublicResults(result,checkType)
					result = ""
				end
			end
		end
		PublicResults(result,checkType)
	end
end


function module.options:Load()
	self:CreateTilte()

	self.food = ExRT.lib.CreateButton(self,230,20,nil,5,-30,ExRT.L.raidcheckfood,nil,nil,"ExRTButtonModernTemplate")       
	self.food:SetScript("OnClick",function()
		GetFood()
	end)
	self.food.txt = ExRT.lib.CreateText(self,100,20,nil,0,0,nil,nil,nil,11,"/rt food")
	self.food.txt:SetNewPoint("LEFT",self.food,"RIGHT",5,0)
	
	self.foodToChat = ExRT.lib.CreateButton(self,230,20,nil,0,0,ExRT.L.raidcheckfoodchat,nil,nil,"ExRTButtonModernTemplate")       
	self.foodToChat:SetScript("OnClick",function()
		GetFood(1)
	end)
	self.foodToChat:SetNewPoint("LEFT",self.food,"RIGHT",71,0)
	self.foodToChat.txt = ExRT.lib.CreateText(self,100,20,nil,0,0,nil,nil,nil,11,"/rt foodchat")
	self.foodToChat.txt:SetNewPoint("LEFT",self.foodToChat,"RIGHT",5,0)
	
	self.flask = ExRT.lib.CreateButton(self,230,20,nil,5,-55,ExRT.L.raidcheckflask,nil,nil,"ExRTButtonModernTemplate")       
	self.flask:SetScript("OnClick",function()
		GetFlask()
	end)  
	self.flask.txt = ExRT.lib.CreateText(self,100,20,nil,0,0,nil,nil,nil,11,"/rt flask")
	self.flask.txt:SetNewPoint("LEFT",self.flask,"RIGHT",5,0)
	
	self.flaskToChat = ExRT.lib.CreateButton(self,230,20,nil,0,0,ExRT.L.raidcheckflaskchat,nil,nil,"ExRTButtonModernTemplate")       
	self.flaskToChat:SetScript("OnClick",function()
		GetFlask(1)
	end)
	self.flaskToChat:SetNewPoint("LEFT",self.flask,"RIGHT",71,0)
	self.flaskToChat.txt = ExRT.lib.CreateText(self,100,20,nil,0,0,nil,nil,nil,11,"/rt flaskchat")
	self.flaskToChat.txt:SetNewPoint("LEFT",self.flaskToChat,"RIGHT",5,0)	
	
	self.runes = ExRT.lib.CreateButton(self,230,20,nil,5,-80,ExRT.L.RaidCheckRunesCheck,nil,nil,"ExRTButtonModernTemplate")       
	self.runes:SetScript("OnClick",function()
		GetRunes()
	end)
	self.runes.txt = ExRT.lib.CreateText(self,60,22,nil,0,0,nil,nil,nil,11,"/rt check runes")
	self.runes.txt:SetNewPoint("LEFT",self.runes,"RIGHT",5,0)
	
	self.runesToChat = ExRT.lib.CreateButton(self,230,20,nil,0,0,ExRT.L.RaidCheckRunesChat,nil,nil,"ExRTButtonModernTemplate")       
	self.runesToChat:SetScript("OnClick",function()
		GetRunes(1)
	end)
	self.runesToChat:SetNewPoint("LEFT",self.runes,"RIGHT",71,0)
	self.runesToChat.txt = ExRT.lib.CreateText(self,100,22,nil,0,0,nil,nil,nil,11,"/rt check runeschat")
	self.runesToChat.txt:SetNewPoint("LEFT",self.runesToChat,"RIGHT",5,0)
	
	
	self.buffs = ExRT.lib.CreateButton(self,230,20,nil,5,-105,ExRT.L.RaidCheckBuffs,nil,nil,"ExRTButtonModernTemplate")       
	self.buffs:SetScript("OnClick",function()
		GetRaidBuffs()
	end)
	self.buffs.txt = ExRT.lib.CreateText(self,60,22,nil,0,0,nil,nil,nil,11,"/rt check buffs")
	self.buffs.txt:SetNewPoint("LEFT",self.buffs,"RIGHT",5,0)
	
	self.buffsToChat = ExRT.lib.CreateButton(self,230,20,nil,0,0,ExRT.L.RaidCheckBuffsToChat,nil,nil,"ExRTButtonModernTemplate")       
	self.buffsToChat:SetScript("OnClick",function()
		GetRaidBuffs(1)
	end)
	self.buffsToChat:SetNewPoint("LEFT",self.buffs,"RIGHT",71,0)
	self.buffsToChat.txt = ExRT.lib.CreateText(self,100,22,nil,0,0,nil,nil,nil,11,"/rt check buffschat")
	self.buffsToChat.txt:SetNewPoint("LEFT",self.buffsToChat,"RIGHT",5,0)

	
	self.chkSlak = ExRT.lib.CreateCheckBox(self,nil,7,-130,ExRT.L.raidcheckslak,VExRT.RaidCheck.ReadyCheck,nil,nil,"ExRTCheckButtonModernTemplate")
	self.chkSlak:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.RaidCheck.ReadyCheck = true
			module:RegisterEvents('READY_CHECK')
		else
			VExRT.RaidCheck.ReadyCheck = nil
			if not VExRT.RaidCheck.ReadyCheckFrame then
				module:UnregisterEvents('READY_CHECK')
			end
		end
	end)
	
	self.chkOnAttack = ExRT.lib.CreateCheckBox(self,nil,0,0,ExRT.L.RaidCheckOnAttack,VExRT.RaidCheck.OnAttack,nil,nil,"ExRTCheckButtonModernTemplate")
	self.chkOnAttack:SetNewPoint("TOPLEFT",self.chkSlak,"TOPLEFT",25,-25)
	self.chkOnAttack:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.RaidCheck.OnAttack = true
		else
			VExRT.RaidCheck.OnAttack = nil
		end
	end)
	
	self.chkSendSelf = ExRT.lib.CreateCheckBox(self,nil,0,0,ExRT.L.RaidCheckSendSelf,VExRT.RaidCheck.SendSelf,nil,nil,"ExRTCheckButtonModernTemplate")
	self.chkSendSelf:SetNewPoint("TOPLEFT",self.chkOnAttack,"TOPLEFT",0,-25)
	self.chkSendSelf:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.RaidCheck.SendSelf = true
		else
			VExRT.RaidCheck.SendSelf = nil
		end
	end)
	
	self.disableLFR = ExRT.lib.CreateCheckBox(self,nil,0,0,ExRT.L.RaidCheckDisableInLFR,VExRT.RaidCheck.disableLFR,nil,nil,"ExRTCheckButtonModernTemplate")
	self.disableLFR:SetNewPoint("TOPLEFT",self.chkSendSelf,"TOPLEFT",0,-25)
	self.disableLFR:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.RaidCheck.disableLFR = true
		else
			VExRT.RaidCheck.disableLFR = nil
		end
	end)
	
	self.chkRunes = ExRT.lib.CreateCheckBox(self,nil,7,-230,ExRT.L.RaidCheckRunesEnable,VExRT.RaidCheck.RunesCheck,nil,nil,"ExRTCheckButtonModernTemplate")
	self.chkRunes:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.RaidCheck.RunesCheck = true
		else
			VExRT.RaidCheck.RunesCheck = nil
		end
	end)
	
	self.chkBuffs = ExRT.lib.CreateCheckBox(self,nil,7,-255,ExRT.L.RaidCheckBuffsEnable,VExRT.RaidCheck.BuffsCheck,nil,nil,"ExRTCheckButtonModernTemplate")
	self.chkBuffs:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.RaidCheck.BuffsCheck = true
		else
			VExRT.RaidCheck.BuffsCheck = nil
		end
	end)
	
	self.minFoodLevelText = ExRT.lib.CreateText(self,0,25,nil,0,0,nil,nil,nil,11,ExRT.L.RaidCheckMinFoodLevel)
	self.minFoodLevelText:SetNewPoint("TOPLEFT",self.chkBuffs,"TOPLEFT",3,-23)

	self.minFoodLevelAny = ExRT.lib.CreateRadioButton(self,nil,0,0,ExRT.L.RaidCheckMinFoodLevelAny,nil,true)
	self.minFoodLevelAny:SetNewPoint("LEFT",self.minFoodLevelText,"RIGHT", 15, 0)
	self.minFoodLevelAny:SetScript("OnClick", function(self,event) 
		self:SetChecked(true)
		module.options.minFoodLevel100:SetChecked(false)
		module.options.minFoodLevel125:SetChecked(false)
		VExRT.RaidCheck.FoodMinLevel = nil
	end)
	self.minFoodLevelAny:SetChecked(not VExRT.RaidCheck.FoodMinLevel)

	
	self.minFoodLevel100 = ExRT.lib.CreateRadioButton(self,nil,0,0,"100",nil,true)
	self.minFoodLevel100:SetNewPoint("LEFT",self.minFoodLevelAny,"RIGHT", 75, 0)
	self.minFoodLevel100:SetScript("OnClick", function(self,event) 
		self:SetChecked(true)
		module.options.minFoodLevelAny:SetChecked(false)
		module.options.minFoodLevel125:SetChecked(false)
		VExRT.RaidCheck.FoodMinLevel = 100
	end)
	self.minFoodLevel100:SetChecked(VExRT.RaidCheck.FoodMinLevel == 100)
	
	self.minFoodLevel125 = ExRT.lib.CreateRadioButton(self,nil,0,0,"125",nil,true)
	self.minFoodLevel125:SetNewPoint("LEFT",self.minFoodLevel100,"RIGHT", 75, 0)
	self.minFoodLevel125:SetScript("OnClick", function(self,event) 
		self:SetChecked(true)
		module.options.minFoodLevelAny:SetChecked(false)
		module.options.minFoodLevel100:SetChecked(false)
		VExRT.RaidCheck.FoodMinLevel = 125
	end)
	self.minFoodLevel125:SetChecked(VExRT.RaidCheck.FoodMinLevel == 125)
	
	
	self.minFlaskExpText = ExRT.lib.CreateText(self,0,25,nil,0,0,nil,nil,nil,11,ExRT.L.RaidCheckMinFlaskExp)
	self.minFlaskExpText:SetNewPoint("TOPLEFT",self.minFoodLevelText,"TOPLEFT",0,-22)
	
	self.minFlaskExpNo = ExRT.lib.CreateRadioButton(self,nil,0,0,ExRT.L.RaidCheckMinFlaskExpNo,nil,true)
	self.minFlaskExpNo:SetNewPoint("LEFT",self.minFlaskExpText,"RIGHT", 15, 0)
	self.minFlaskExpNo:SetScript("OnClick", function(self,event) 
		self:SetChecked(true)
		module.options.minFlaskExp5min:SetChecked(false)
		module.options.minFlaskExp10min:SetChecked(false)
		VExRT.RaidCheck.FlaskExp = 0
	end)
	self.minFlaskExpNo:SetChecked(VExRT.RaidCheck.FlaskExp == 0)
	
	self.minFlaskExp5min = ExRT.lib.CreateRadioButton(self,nil,0,0,"5 "..ExRT.L.RaidCheckMinFlaskExpMin,nil,true)
	self.minFlaskExp5min:SetNewPoint("LEFT",self.minFlaskExpNo,"RIGHT", 75, 0)
	self.minFlaskExp5min:SetScript("OnClick", function(self,event) 
		self:SetChecked(true)
		module.options.minFlaskExpNo:SetChecked(false)
		module.options.minFlaskExp10min:SetChecked(false)
		VExRT.RaidCheck.FlaskExp = 1
	end)
	self.minFlaskExp5min:SetChecked(VExRT.RaidCheck.FlaskExp == 1)

	self.minFlaskExp10min = ExRT.lib.CreateRadioButton(self,nil,0,0,"10 "..ExRT.L.RaidCheckMinFlaskExpMin,nil,true)
	self.minFlaskExp10min:SetNewPoint("LEFT",self.minFlaskExp5min,"RIGHT", 75, 0)
	self.minFlaskExp10min:SetScript("OnClick", function(self,event) 
		self:SetChecked(true)
		module.options.minFlaskExpNo:SetChecked(false)
		module.options.minFlaskExp5min:SetChecked(false)
		VExRT.RaidCheck.FlaskExp = 2
	end)
	self.minFlaskExp10min:SetChecked(VExRT.RaidCheck.FlaskExp == 2)

	
	self.chkPotion = ExRT.lib.CreateCheckBox(self,nil,7,-325,ExRT.L.raidcheckPotionCheck,VExRT.RaidCheck.PotionCheck,nil,nil,"ExRTCheckButtonModernTemplate")
	self.chkPotion:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.RaidCheck.PotionCheck = true
			module.options.potionToChat:Enable()
			module.options.potion:Enable()
			module.options.hs:Enable()
			module.options.hsToChat:Enable()
		else
			VExRT.RaidCheck.PotionCheck = nil
			module.options.potionToChat:Disable()
			module.options.potion:Disable()
			module.options.hs:Disable()
			module.options.hsToChat:Disable()
		end
	end)

	self.potion = ExRT.lib.CreateButton(self,230,20,nil,0,0,ExRT.L.raidcheckPotionLastPull,not VExRT.RaidCheck.PotionCheck,nil,"ExRTButtonModernTemplate")  
	self.potion:SetNewPoint("TOPLEFT",self.chkPotion,"TOPLEFT",-2,-30)     
	self.potion:SetScript("OnClick",function()
		GetPotion(2)
	end)  
	self.potion.txt = ExRT.lib.CreateText(self,100,20,nil,0,0,nil,nil,nil,11,"/rt potion")
	self.potion.txt:SetNewPoint("LEFT",self.potion,"RIGHT",5,0)
	
	self.potionToChat = ExRT.lib.CreateButton(self,230,20,nil,0,0,ExRT.L.raidcheckPotionLastPullToChat,not VExRT.RaidCheck.PotionCheck,nil,"ExRTButtonModernTemplate")       
	self.potionToChat:SetScript("OnClick",function()
		GetPotion(1)
	end)
	self.potionToChat:SetNewPoint("LEFT",self.potion,"RIGHT",71,0)
	self.potionToChat.txt = ExRT.lib.CreateText(self,100,20,nil,0,0,nil,nil,nil,11,"/rt potionchat")
	self.potionToChat.txt:SetNewPoint("LEFT",self.potionToChat,"RIGHT",5,0)
	
	self.hs = ExRT.lib.CreateButton(self,230,20,nil,5,-355,ExRT.L.raidcheckHSLastPull,not VExRT.RaidCheck.PotionCheck,nil,"ExRTButtonModernTemplate")       
	self.hs:SetNewPoint("TOPLEFT",self.potion,"TOPLEFT",0,-25)     
	self.hs:SetScript("OnClick",function()
		GetHs(2)
	end)  
	
	self.hsToChat = ExRT.lib.CreateButton(self,230,20,nil,0,0,ExRT.L.raidcheckHSLastPullToChat,not VExRT.RaidCheck.PotionCheck,nil,"ExRTButtonModernTemplate")       
	self.hsToChat:SetScript("OnClick",function()
		GetHs(1)
	end)  
	self.hsToChat:SetNewPoint("LEFT",self.hs,"RIGHT",71,0)


	self.optReadyCheckFrame = CreateFrame("Frame",nil,self)
	self.optReadyCheckFrame:SetSize(650,125)
	self.optReadyCheckFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.mds.defBorder,tile = false,edgeSize = 8})
	self.optReadyCheckFrame:SetBackdropColor(0,0,0,0.3)
	self.optReadyCheckFrame:SetBackdropBorderColor(.24,.25,.30,1)
	self.optReadyCheckFrame:SetPoint("TOP",0,-425)

	self.optReadyCheckFrameHeader = ExRT.lib.CreateText(self.optReadyCheckFrame,550,20,nil,0,0,nil,"BOTTOM",nil,nil,ExRT.L.raidcheckReadyCheck)
	self.optReadyCheckFrameHeader:SetNewPoint("BOTTOMLEFT",self.optReadyCheckFrame,"TOPLEFT",10,1)

	self.chkReadyCheckFrameEnable = ExRT.lib.CreateCheckBox(self.optReadyCheckFrame,nil,15,-10,ExRT.L.senable,VExRT.RaidCheck.ReadyCheckFrame,nil,nil,"ExRTCheckButtonModernTemplate")
	self.chkReadyCheckFrameEnable:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			module:RegisterEvents('READY_CHECK','READY_CHECK_FINISHED','READY_CHECK_CONFIRM')
			VExRT.RaidCheck.ReadyCheckFrame = true
		else
			module:UnregisterEvents('READY_CHECK_FINISHED','READY_CHECK_CONFIRM')
			if not VExRT.RaidCheck.ReadyCheck then
				module:UnregisterEvents('READY_CHECK')
			end
			VExRT.RaidCheck.ReadyCheckFrame = nil
		end
	end)

	self.chkReadyCheckFrameSliderScale = ExRT.lib.CreateSlider(self.optReadyCheckFrame,250,15,25,-50,5,200,ExRT.L.raidcheckReadyCheckScale,VExRT.RaidCheck.ReadyCheckFrameScale or 100,nil,nil,true)
	self.chkReadyCheckFrameSliderScale:SetScript("OnValueChanged", function(self,event) 
		event = event - event%1
		VExRT.RaidCheck.ReadyCheckFrameScale = event
		ExRT.mds.SetScaleFix(module.frame,event/100)
		self.tooltipText = event
		self:tooltipReload(self)
	end)

	self.chkReadyCheckFrameButTest = ExRT.lib.CreateButton(self.optReadyCheckFrame,280,22,nil,310,-10,ExRT.L.raidcheckReadyCheckTest,nil,nil,"ExRTButtonModernTemplate")
	self.chkReadyCheckFrameButTest:SetScript("OnClick", function(self) 
		module.main:READY_CHECK("raid1",35,"TEST")
		for i=2,25 do
			local y = math.random(1,30000)
			local r = math.random(1,2)
			ExRT.mds.ScheduleTimer(function() module.main:READY_CHECK_CONFIRM("raid"..i,r==1,"TEST") end, y/1000)
		end
	end)

	self.chkReadyCheckFrameHtmlTimer = ExRT.lib.CreateText(self.optReadyCheckFrame,200,24,nil,310,-50,nil,nil,nil,11,ExRT.L.raidcheckReadyCheckTimerTooltip)

	self.chkReadyCheckFrameEditBoxTimer = ExRT.lib.CreateEditBox(self.optReadyCheckFrame,50,20,nil,515,-50,nil,6,true,"ExRTInputBoxModernTemplate",VExRT.RaidCheck.ReadyCheckFrameTimerFade or "4")
	self.chkReadyCheckFrameEditBoxTimer:SetScript("OnTextChanged",function(self)
		VExRT.RaidCheck.ReadyCheckFrameTimerFade = tonumber(self:GetText()) or 4
		if VExRT.RaidCheck.ReadyCheckFrameTimerFade < 2.5 then VExRT.RaidCheck.ReadyCheckFrameTimerFade = 2.5 end
	end) 
	
	self.htmlReadyCheck1 = ExRT.lib.CreateText(self.optReadyCheckFrame,583,100,nil,10,-90,nil,"TOP",nil,12,ExRT.L.RaidCheckReadyCheckHelp)

	self:SetScript("OnShow",nil)
end

local function CheckPotionsOnPull()
	table.wipe(module.db.potionList)
	local gMax = ExRT.mds.GetRaidDiffMaxGroup()
	for j=1,40 do
		local name,_,subgroup = GetRaidRosterInfo(j)
		if name and subgroup <= gMax then
			local b = nil
			for i=1,40 do
				local _,_,_,_,_,_,_,_,_,_,spellId = UnitAura(name, i,"HELPFUL")
				if not spellId then
					break
				elseif module.db.tablePotion[spellId] then
					module.db.potionList[name] = 1
					b = true
				end
			end
			if not b then
				module.db.potionList[name] = 0
			end
		end
	end
end

function module:timer(elapsed)
	if VExRT.RaidCheck.PotionCheck then
		if not module.db.isEncounter and IsEncounterInProgress() then
			module.db.isEncounter = true

			ExRT.mds.ScheduleTimer(CheckPotionsOnPull,1.5)
			
			table.wipe(module.db.hsList)
			local gMax = ExRT.mds.GetRaidDiffMaxGroup()
			for j=1,40 do
				local name,_,subgroup = GetRaidRosterInfo(j)
				if name and subgroup <= gMax then
					module.db.hsList[name] = 0
				end
			end
			
			module:RegisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
		elseif module.db.isEncounter and not IsEncounterInProgress() then
			module.db.isEncounter = nil
			
			module:UnregisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
		end
	end
	if VExRT.RaidCheck.ReadyCheckFrame and module.db.RaidCheckReadyCheckHide then
		module.db.RaidCheckReadyCheckHide = module.db.RaidCheckReadyCheckHide - elapsed
		if module.db.RaidCheckReadyCheckHide < 2 and not module.frame.anim:IsPlaying() then
			module.frame.anim:Play()
		end
		if module.db.RaidCheckReadyCheckHide < 0 then
			module.db.RaidCheckReadyCheckHide = nil
		end
	end
	if VExRT.RaidCheck.ReadyCheckFrame and module.frame:IsShown() then
		local h = ""
		local ctime_ = module.db.RaidCheckReadyCheckTime - GetTime()
		if ctime_ > 0 then 
			h = format(" (%d %s)",ctime_+1,ExRT.L.raidcheckReadyCheckSec) 
		end
		module.frame.headText:SetText(ExRT.L.raidcheckReadyCheck..h)
	end
end

function module:slash(arg)
	if arg == "food" then
		GetFood()
	elseif arg == "flask" then
		GetFlask()
	elseif arg == "foodchat" then
		GetFood(1)
	elseif arg == "flaskchat" then
		GetFlask(1)
	elseif arg == "potion" and VExRT.RaidCheck.PotionCheck then
		GetPotion(2)
	elseif arg == "potionchat" and VExRT.RaidCheck.PotionCheck then
		GetPotion(1)
	elseif arg == "check runes" then
		GetRunes()
	elseif arg == "check runeschat" then
		GetRunes(1)
	elseif arg == "check buffs" then
		GetRaidBuffs()
	elseif arg == "check buffschat" then
		GetRaidBuffs(1)
	end
end

module.frame = CreateFrame("FRAME",nil,UIParent,"ExRTDialogModernTemplate")
module.frame:SetSize(140*2+20,18*13+40)
module.frame:SetPoint("CENTER",UIParent,"CENTER",0,0)
module.frame:SetFrameStrata("TOOLTIP")
module.frame:EnableMouse(true)
module.frame:SetMovable(true)
module.frame:RegisterForDrag("LeftButton")
module.frame:SetScript("OnDragStart", function(self) 
	self:StartMoving()
end)
module.frame:SetScript("OnDragStop", function(self) 
	self:StopMovingOrSizing()
	VExRT.RaidCheck.ReadyCheckLeft = self:GetLeft()
	VExRT.RaidCheck.ReadyCheckTop = self:GetTop()
end)
module.frame:Hide()
--module.frame.headText = ExRT.lib.CreateText(module.frame,290,18,nil,15,-7,nil,nil,ExRT.mds.defFont,14,ExRT.L.raidcheckReadyCheck,nil,1,1,1,1)
module.frame.border = ExRT.lib.CreateShadow(module.frame,20)
module.frame.headText = module.frame.title

module.frame.anim = module.frame:CreateAnimationGroup()
module.frame.timer = module.frame.anim:CreateAnimation()
module.frame.timer:SetScript("OnFinished", function() 
	module.frame.anim:Stop() 
	module.frame:Hide() 
end)
module.frame.timer:SetDuration(2)
module.frame.timer:SetScript("OnUpdate", function(self,elapsed) 
	module.frame:SetAlpha(1-self:GetProgress())
end)
module.frame:SetScript("OnHide", function(self) 
	module.frame.anim:Stop()
end)

module.frame.u = {}
for i=1,40 do
	module.frame.u[i] = CreateFrame("FRAME",nil,module.frame)
	module.frame.u[i]:SetPoint("TOPLEFT", ((i-1)%2)*140+10, -floor((i-1)/2)*18-25)
	module.frame.u[i]:SetSize(140,18)

	module.frame.u[i].t = ExRT.lib.CreateText(module.frame.u[i],120,18,nil,20,0,nil,nil,ExRT.mds.defFont,12,"raid"..i,nil,1,1,1,1)

	module.frame.u[i].icon = ExRT.lib.CreateIcon(module.frame.u[i],18,nil,0,0,"Interface\\RaidFrame\\ReadyCheck-Waiting",nil)
end

local function RaidCheckReadyCheckReset(starter,isTest)
	table.wipe(module.db.RaidCheckReadyCheckTable)
	local j = 0
	local gMax = ExRT.mds.GetRaidDiffMaxGroup()
	module.db.RaidCheckReadyPPLNum = 0
	module.frame:SetHeight(18*ceil(gMax*5/2)+30)
	for i=1,40 do
		local name,_,subgroup = GetRaidRosterInfo(i)
		if isTest then
			name = format("%s%d","raid",i)
			subgroup = i / 5
		end
		if name and subgroup <= gMax then 
			j = j + 1
			if j > 40 then break end
			module.frame.u[j].t:SetText(name)
			module.frame.u[j].t:SetTextColor(1,1,1,1)
			module.frame.u[j].icon.texture:SetTexture("Interface\\RaidFrame\\ReadyCheck-Waiting")
			module.frame.u[j]:Show()

			module.db.RaidCheckReadyPPLNum = module.db.RaidCheckReadyPPLNum + 1
			module.db.RaidCheckReadyCheckTable[ExRT.mds.delUnitNameServer(name)] = j
		end
	end
	for i=(j+1),40 do
		module.frame.u[i]:Hide()
	end
	module.frame.anim:Stop()
	module.frame:SetAlpha(1)
	module.frame:Show()
end

function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.RaidCheck = VExRT.RaidCheck or {}
	
	VExRT.RaidCheck.FlaskExp = VExRT.RaidCheck.FlaskExp or 1

	if VExRT.RaidCheck.ReadyCheckLeft and VExRT.RaidCheck.ReadyCheckTop then
		module.frame:ClearAllPoints()
		module.frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.RaidCheck.ReadyCheckLeft,VExRT.RaidCheck.ReadyCheckTop) 
	end
	if VExRT.RaidCheck.ReadyCheckFrameScale then
		module.frame:SetScale(VExRT.RaidCheck.ReadyCheckFrameScale/100)
	end
	VExRT.RaidCheck.ReadyCheckFrameTimerFade = VExRT.RaidCheck.ReadyCheckFrameTimerFade or 4
	
	module.db.tableFoodInProgress = GetSpellInfo(104934)
	
	if VExRT.RaidCheck.ReadyCheckFrame then
		module:RegisterEvents('READY_CHECK_FINISHED','READY_CHECK_CONFIRM')
	end
	if VExRT.RaidCheck.ReadyCheck or VExRT.RaidCheck.ReadyCheckFrame then
		module:RegisterEvents('READY_CHECK')	
	end
	if VExRT.RaidCheck.PotionCheck then
		--module:RegisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
	end
	
	module:RegisterSlash()
	module:RegisterTimer()
	module:RegisterAddonMessage()
end

local function SendDataToChat()
	if IsSendFoodByMe then
		GetFood(2)
	end
	if IsSendFlaskByMe then
		GetFlask(2)
	end
	if IsSendRunesByMe then
		GetRunes(2)
	end
	if IsSendBuffsByMe then
		GetRaidBuffs(2)
	end
	IsSendFoodByMe = nil
	IsSendFlaskByMe = nil
	IsSendRunesByMe = nil
	IsSendBuffsByMe = nil
end

local function PrepareDataToChat(toSelf)
	if toSelf then
		GetFood(3)
		GetFlask(3)
		if VExRT.RaidCheck.RunesCheck then
			GetRunes(3)
		end
		if VExRT.RaidCheck.BuffsCheck then
			GetRaidBuffs(3)
		end
	else
		if VExRT.RaidCheck.disableLFR then
			local _,_,difficulty = GetInstanceInfo()
			if difficulty == 7 or difficulty == 17 then
				return
			end
		end
		IsSendFoodByMe = true
		ExRT.F.ScheduleTimer(ExRT.F.SendExMsg, 0.1, "raidcheck","FOOD")
		IsSendFlaskByMe = true
		ExRT.F.ScheduleTimer(ExRT.F.SendExMsg, 0.1, "raidcheck","FLASK")
		IsSendRunesByMe = nil
		if VExRT.RaidCheck.RunesCheck then
			IsSendRunesByMe = true
			ExRT.F.ScheduleTimer(ExRT.F.SendExMsg, 0.1, "raidcheck","RUNES")
		end
		IsSendBuffsByMe = nil
		if VExRT.RaidCheck.BuffsCheck then
			IsSendBuffsByMe = true
			ExRT.F.ScheduleTimer(ExRT.F.SendExMsg, 0.1, "raidcheck","BUFFS")
		end
		ExRT.F.ScheduleTimer(SendDataToChat, 1)
	end
end

do
	local function ScheduledReadyCheckFinish()
		module.main:READY_CHECK_FINISHED()
	end
	function module.main:READY_CHECK(starter,timer,isTest)
		if not (isTest == "TEST") then isTest = nil end
		if VExRT.RaidCheck.ReadyCheck and not isTest then
			--[[
			local plus = VExRT.RaidCheck.SendSelf and 1 or 0
			GetFood(2+plus)
			GetFlask(2+plus)
			if VExRT.RaidCheck.RunesCheck then
				GetRunes(2+plus)
			end
			if VExRT.RaidCheck.BuffsCheck then
				GetRaidBuffs(2+plus)
			end
			]]
			PrepareDataToChat(VExRT.RaidCheck.SendSelf)
		end
		if VExRT.RaidCheck.ReadyCheckFrame then
			module.db.RaidCheckReadyCheckHide = nil
			module.db.RaidCheckReadyCheckTime = GetTime() + (timer or 35)
			ExRT.mds.CancelTimer(module.db.RaidCheckReadyCheckHideSchedule)
			module.db.RaidCheckReadyCheckHideSchedule = ExRT.mds.ScheduleTimer(ScheduledReadyCheckFinish, timer or 35)
			RaidCheckReadyCheckReset(starter,isTest)
			module.main:READY_CHECK_CONFIRM(ExRT.mds.delUnitNameServer(starter),true,isTest)
		end
	end
end

function module.main:READY_CHECK_FINISHED()
	if not module.db.RaidCheckReadyCheckHide then
		module.db.RaidCheckReadyCheckHide = VExRT.RaidCheck.ReadyCheckFrameTimerFade
	end
end

function module.main:READY_CHECK_CONFIRM(unit,response,isTest)
	if not (isTest == "TEST") then unit = UnitName(unit) isTest = nil end
	if unit and module.db.RaidCheckReadyCheckTable[unit] then
		local foodBuff = nil
		local flaskBuff = nil
		for i=1,40 do
			local name,_,_,_,_,_,_,_,_,_,spellId = UnitAura(unit, i,"HELPFUL")
			if not spellId then
				break
			elseif module.db.tableFood[spellId] then
				foodBuff = true
			elseif module.db.tableFlask[spellId] then
				flaskBuff = true
			elseif name and module.db.tableFoodInProgress == name then
				foodBuff = true
			end
		end
		if isTest then
			if math.random(1,2) == 1 then foodBuff = nil flaskBuff = nil else foodBuff = true flaskBuff = true end
		end
		if not foodBuff or not flaskBuff then
			module.frame.u[module.db.RaidCheckReadyCheckTable[unit]].t:SetTextColor(1,0.5,0.5,1)
		end
		if response == true then
			module.frame.u[module.db.RaidCheckReadyCheckTable[unit]].icon.texture:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
		else
			module.frame.u[module.db.RaidCheckReadyCheckTable[unit]].icon.texture:SetTexture("Interface\\RaidFrame\\ReadyCheck-NotReady")
		end
		if foodBuff and flaskBuff and response then
			module.frame.u[module.db.RaidCheckReadyCheckTable[unit]]:Hide()
		end

		module.db.RaidCheckReadyPPLNum = module.db.RaidCheckReadyPPLNum - 1
		if module.db.RaidCheckReadyPPLNum <= 0 then
			module.db.RaidCheckReadyCheckHide = VExRT.RaidCheck.ReadyCheckFrameTimerFade
		end
		module.db.RaidCheckReadyCheckTable[unit] = nil
	end
end

do
	local _db = module.db
	function module.main:COMBAT_LOG_EVENT_UNFILTERED(_,event,_,_,sourceName,_,_,_,_,_,_,spellId)
		if event == "SPELL_CAST_SUCCESS" and sourceName then
			if _db.hsSpells[spellId] then
				_db.hsList[sourceName] = _db.hsList[sourceName] and _db.hsList[sourceName] + 1 or 1
			elseif _db.tablePotion[spellId] then
				_db.potionList[sourceName] = _db.potionList[sourceName] and _db.potionList[sourceName] + 1 or 1
			end
		end
	end
end

function module:addonMessage(sender, prefix, ...)
	if prefix == "raidcheck" then
		if sender then
			if ExRT.F.IsPlayerRLorOfficer(ExRT.SDB.charName) == 2 then
				return
			end
			if sender < ExRT.SDB.charName or ExRT.F.IsPlayerRLorOfficer(sender) == 2 then
				local type = ...
				if type == "FOOD" then
					IsSendFoodByMe = nil
				elseif type == "FLASK" then
					IsSendFlaskByMe = nil
				elseif type == "RUNES" then
					IsSendRunesByMe = nil
				elseif type == "BUFFS" then
					IsSendBuffsByMe = nil
				end
			end
		end
	end
end

local addonMsgFrame = CreateFrame'Frame'
local addonMsgAttack_AntiSpam = 0
addonMsgFrame:SetScript("OnEvent",function (self, event, ...)
	local prefix, message, channel, sender = ...
	if message and ((prefix == "BigWigs" and message:find("^T:BWPull")) or (prefix == "D4" and message:find("^PT"))) then
		if VExRT.RaidCheck.OnAttack then
			local _time = GetTime()
			if (_time - addonMsgAttack_AntiSpam) < 2 then
				return
			end
			addonMsgAttack_AntiSpam = _time
		
			PrepareDataToChat(VExRT.RaidCheck.SendSelf)
		end
	end
end)
addonMsgFrame:RegisterEvent("CHAT_MSG_ADDON")