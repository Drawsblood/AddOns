--	23:37 27.07.2015

--[[
Bossmods: new bossmod: Archimonde Radar (to deal with "Wrought Chaos" ability)
Bossmods: new bossmod: Archimonde Infernals (marks and shows bars with hp of infernals on p3)
Raid cooldowns: fixed Legendary rings (dd)
Arrow: new function (can be used in weakaura for ex.) "GExRT.F.ArrowTextPlayer(unit)", where "unit" - name of player in your raid. Shows arrow to this player in text
Bossmods: new bossmod: Mannoroth (shows arrow to players with Mannoroth's Gaze debuffs)
Minor fixes

TODO:

]]

local GlobalAddonName, ExRT = ...

ExRT.V = 3481
ExRT.T = "R"
ExRT.BETA = false

ExRT.OnUpdate = {}		--> таймеры, OnUpdate функции
ExRT.Slash = {}			--> функции вызова из коммандной строки
ExRT.OnAddonMessage = {}	--> внутренние сообщения аддона
ExRT.Eggs = {}			--> скрытые функции
ExRT.MiniMapMenu = {}		--> изменение меню кнопки на миникарте
ExRT.Modules = {}		--> список всех модулей
ExRT.ModulesLoaded = {}		--> список загруженных модулей [для Dev & Advanced]
ExRT.CLEU = {}			--> лист CLEU функций, для обработки

ExRT.A = {}			--> ссылки на все модули

ExRT.msg_prefix = {
	["EXRTADD"] = true,
	["MHADD"] = true,	--> Malkorok Helper (Curse client)
}

ExRT.L = {}			--> локализация
ExRT.locale = GetLocale()

ExRT.clientUIinterface = select(4,GetBuildInfo())

ExRT.ModulesOptions = {}

---------------> Modules <---------------
ExRT.mod = {}
ExRT.mod.__index = ExRT.mod

do
	local function mod_LoadOptions(this)
		if not InCombatLockdown() or this.enableLoadInCombat then
			this:Load()
			this:SetScript("OnShow",nil)
			ExRT.mds.dprint(this.moduleName.."'s options loaded")
			this.isLoaded = true
		else
			print(ExRT.L.SetErrorInCombat)
		end
	end
	local function mod_Options_CreateTitle(self)
		self.title = ExRT.lib.CreateText(self,605,200,nil,5,-5,nil,"TOP",nil,16,self.name)
	end
	function ExRT.mod:New(moduleName,localizatedName,disableOptions,enableLoadInCombat)
		local self = {}
		setmetatable(self, ExRT.mod)
		
		if not disableOptions then
			self.options = ExRT.Options:Add(moduleName,localizatedName)

			self.options:Hide()
			self.options.moduleName = moduleName
			self.options.name = localizatedName or moduleName
			self.options:SetScript("OnShow",mod_LoadOptions)
			
			self.options.CreateTilte = mod_Options_CreateTitle
			
			if enableLoadInCombat then
				self.options.enableLoadInCombat = true
			end
			
			if not ExRT.BannedModules[moduleName] then
				ExRT.ModulesOptions[#ExRT.ModulesOptions + 1] = self.options
			end
			
		end
		
		self.main = CreateFrame("Frame", nil)
		self.main.events = {}
		self.main:SetScript("OnEvent",ExRT.mod.Event)
		
		if ExRT.T == "D" then
			self.main.eventsCounter = {}
			self.main:HookScript("OnEvent",ExRT.mod.HookEvent)
		end
		
		self.db = {}
		
		self.name = moduleName
		table.insert(ExRT.Modules,self)
		ExRT.A[moduleName] = self
		
		ExRT.mds.dprint("New module: "..moduleName)
		
		return self
	end
end

function ExRT.mod:Event(event,...)
	self[event](self,...)
end

function ExRT.mod:HookEvent(event)
	self.eventsCounter[event] = self.eventsCounter[event] and self.eventsCounter[event] + 1 or 1
end

do
	local CLEU_mirror = {}
	local function RestructCLEU()
		local module_Encounter = nil	--Fix Encounter module. Unregister CLEU during CLEU cicle cause error. Add this module to last pos in ExRT.CLEU
		for moduleName,func in pairs(CLEU_mirror) do
			if type(func)=="function" then
				if moduleName ~= "Encounter" then
					ExRT.CLEU[#ExRT.CLEU + 1] = func
				else
					module_Encounter = func
				end
			end
		end
		if module_Encounter then
			ExRT.CLEU[#ExRT.CLEU + 1] = module_Encounter
		end
	end
	
	function ExRT.mod:RegisterEvents(...)
		for i=1,select("#", ...) do
			local event = select(i,...)
			if event ~= "COMBAT_LOG_EVENT_UNFILTERED" then
				self.main:RegisterEvent(event)
			else
				wipe(ExRT.CLEU)
				CLEU_mirror[ self.name ] = self.main.COMBAT_LOG_EVENT_UNFILTERED
				RestructCLEU()
			end
			self.main.events[event] = true
			ExRT.mds.dprint(self.name,'RegisterEvent',event)
		end
	end
	
	function ExRT.mod:UnregisterEvents(...)
		for i=1,select("#", ...) do
			local event = select(i,...)
			if event ~= "COMBAT_LOG_EVENT_UNFILTERED" then
				self.main:UnregisterEvent(event)
			else
				wipe(ExRT.CLEU)
				CLEU_mirror[ self.name ] = nil
				RestructCLEU()
			end
			self.main.events[event] = nil
			ExRT.mds.dprint(self.name,'UnregisterEvent',event)
		end
	end
end

function ExRT.mod:RegisterUnitEvent(...)
	self.main:RegisterUnitEvent(...)
	local event = select(1,...)
	self.main.events[event] = true
	ExRT.mds.dprint(self.name,'RegisterUnitEvent',event)
end

do
	local Timers_modulesNames = {}
	function ExRT.mod:RegisterTimer()
		local pos = nil
		for i=1,#Timers_modulesNames do
			if Timers_modulesNames[i] == self.name then
				pos = i
				break
			end
		end
		if not pos then
			pos = #ExRT.OnUpdate + 1
			Timers_modulesNames[pos] = self.name
		end
		ExRT.OnUpdate[ pos ] = self
	end
	
	function ExRT.mod:UnregisterTimer()
		for i=1,#Timers_modulesNames do
			if Timers_modulesNames[i] == self.name then
				tremove(Timers_modulesNames,i)
				tremove(ExRT.OnUpdate,i)
				break
			end
		end
	end
end

function ExRT.mod:RegisterSlash()
	ExRT.Slash[self.name] = self
end

function ExRT.mod:UnregisterSlash()
	ExRT.Slash[self.name] = nil
end

function ExRT.mod:RegisterAddonMessage()
	ExRT.OnAddonMessage[self.name] = self
end

function ExRT.mod:UnregisterAddonMessage()
	ExRT.OnAddonMessage[self.name] = nil
end

function ExRT.mod:RegisterEgg()
	ExRT.Eggs[self.name] = self
end

function ExRT.mod:UnregisterEgg()
	ExRT.Eggs[self.name] = nil
end

function ExRT.mod:RegisterMiniMapMenu()
	ExRT.MiniMapMenu[self.name] = self
end

function ExRT.mod:UnregisterMiniMapMenu()
	ExRT.MiniMapMenu[self.name] = nil
end

do
	local hideOnPetBattle = {}
	local petBattleTracker = CreateFrame("Frame")
	petBattleTracker:SetScript("OnEvent",function (self, event)
		if event == "PET_BATTLE_OPENING_START" then
			for _,frame in pairs(hideOnPetBattle) do
				if frame:IsShown() then
					frame.petBattleHide = true
					frame:Hide()
				else
					frame.petBattleHide = nil
				end
			end
		else
			for _,frame in pairs(hideOnPetBattle) do
				if frame.petBattleHide then
					frame.petBattleHide = nil
					frame:Show()
				end
			end
		end
	end)
	petBattleTracker:RegisterEvent("PET_BATTLE_OPENING_START")
	petBattleTracker:RegisterEvent("PET_BATTLE_CLOSE")
	function ExRT.mod:RegisterHideOnPetBattle(frame)
		hideOnPetBattle[#hideOnPetBattle + 1] = frame
	end
end

-------------> smart DB <-------------

ExRT.SDB = {}

do
	local realmKey = GetRealmName() or ""
	local charName = UnitName'player' or ""
	realmKey = realmKey:gsub(" ","")
	ExRT.SDB.realmKey = realmKey
	ExRT.SDB.charKey = charName .. "-" .. realmKey
	ExRT.SDB.charName = charName
end

-------------> upvalues <-------------

local pcall, unpack, pairs = pcall, unpack, pairs
local GetTime, IsEncounterInProgress = GetTime, IsEncounterInProgress
local SendAddonMessage, strsplit = SendAddonMessage, strsplit
local C_Timer_NewTimer, C_Timer_NewTicker = C_Timer.NewTimer, C_Timer.NewTicker

if ExRT.T == "D" then
	pcall = function(func,...)
		func(...)
		return true
	end
end

ExRT.NULL = {}
ExRT.NULLfunc = function() end

---------------> Mods <---------------

ExRT.mds = {}
ExRT.F = ExRT.mds

-- Moved to Functions.lua

do
	local function TimerFunc(self)
		self.func(unpack(self.args))
	end
	function ExRT.mds.ScheduleTimer(func, delay, ...)
		local self = nil
		if delay > 0 then
			self = C_Timer_NewTimer(delay,TimerFunc)
		else
			self = C_Timer_NewTicker(-delay,TimerFunc)
		end
		self.args = {...}
		self.func = func
		
		return self
	end
	function ExRT.mds.CancelTimer(self)
		if self then
			self:Cancel()
		end
	end
	function ExRT.mds.ScheduleETimer(self, func, delay, ...)
		ExRT.mds.CancelTimer(self)
		return ExRT.mds.ScheduleTimer(func, delay, ...)
	end
	
	ExRT.mds.NewTimer = ExRT.mds.ScheduleTimer
end

ExRT.BannedModules = {}

---------------> Data <---------------

ExRT.mds.defFont = "Interface\\AddOns\\ExRT\\media\\skurri.ttf"
ExRT.mds.barImg = "Interface\\AddOns\\ExRT\\media\\bar17.tga"
ExRT.mds.defBorder = "Interface\\AddOns\\ExRT\\media\\border.tga"
ExRT.mds.textureList = {
	"Interface\\AddOns\\ExRT\\media\\bar1.tga",
	"Interface\\AddOns\\ExRT\\media\\bar2.tga",
	"Interface\\AddOns\\ExRT\\media\\bar3.tga",
	"Interface\\AddOns\\ExRT\\media\\bar4.tga",
	"Interface\\AddOns\\ExRT\\media\\bar5.tga",
	"Interface\\AddOns\\ExRT\\media\\bar6.tga",
	"Interface\\AddOns\\ExRT\\media\\bar7.tga",
	"Interface\\AddOns\\ExRT\\media\\bar8.tga",
	"Interface\\AddOns\\ExRT\\media\\bar9.tga",
	"Interface\\AddOns\\ExRT\\media\\bar10.tga",
	"Interface\\AddOns\\ExRT\\media\\bar11.tga",
	"Interface\\AddOns\\ExRT\\media\\bar12.tga",
	"Interface\\AddOns\\ExRT\\media\\bar13.tga",
	"Interface\\AddOns\\ExRT\\media\\bar14.tga",
	"Interface\\AddOns\\ExRT\\media\\bar15.tga",
	"Interface\\AddOns\\ExRT\\media\\bar16.tga",
	"Interface\\AddOns\\ExRT\\media\\bar17.tga",
	"Interface\\AddOns\\ExRT\\media\\bar18.tga",
	"Interface\\AddOns\\ExRT\\media\\bar19.tga",
	"Interface\\AddOns\\ExRT\\media\\bar20.tga",
	"Interface\\AddOns\\ExRT\\media\\bar21.tga",
	"Interface\\AddOns\\ExRT\\media\\bar22.tga",
	"Interface\\AddOns\\ExRT\\media\\bar23.tga",
	"Interface\\AddOns\\ExRT\\media\\bar24.tga",
	"Interface\\AddOns\\ExRT\\media\\bar24b.tga",
	"Interface\\AddOns\\ExRT\\media\\bar25.tga",
	"Interface\\AddOns\\ExRT\\media\\bar26.tga",
	"Interface\\AddOns\\ExRT\\media\\bar27.tga",
	"Interface\\AddOns\\ExRT\\media\\bar28.tga",
	"Interface\\AddOns\\ExRT\\media\\bar29.tga",
	"Interface\\AddOns\\ExRT\\media\\bar30.tga",
	"Interface\\AddOns\\ExRT\\media\\bar31.tga",
	"Interface\\AddOns\\ExRT\\media\\bar32.tga",
	"Interface\\AddOns\\ExRT\\media\\bar33.tga",
	"Interface\\AddOns\\ExRT\\media\\bar34.tga",
	"Interface\\AddOns\\ExRT\\media\\White.tga",
	[[Interface\TargetingFrame\UI-StatusBar]],
	[[Interface\PaperDollInfoFrame\UI-Character-Skills-Bar]],
	[[Interface\RaidFrame\Raid-Bar-Hp-Fill]],
}
ExRT.mds.fontList = {
	"Interface\\AddOns\\ExRT\\media\\skurri.ttf",
	"Fonts\\ARIALN.TTF",
	"Fonts\\FRIZQT__.TTF",
	"Fonts\\MORPHEUS.TTF",
	"Fonts\\NIM_____.ttf",
	"Fonts\\SKURRI.TTF",
	"Fonts\\FRIZQT___CYR.TTF",
	"Fonts\\ARHei.ttf",
	"Fonts\\ARKai_T.ttf",
	"Fonts\\2002.ttf",
	"Interface\\AddOns\\ExRT\\media\\TaurusNormal.ttf",
	"Interface\\AddOns\\ExRT\\media\\UbuntuMedium.ttf",
	"Interface\\AddOns\\ExRT\\media\\TelluralAlt.ttf",
	"Interface\\AddOns\\ExRT\\media\\Glametrix.otf",
	"Interface\\AddOns\\ExRT\\media\\FiraSansMedium.ttf",
	"Interface\\AddOns\\ExRT\\media\\alphapixels.ttf",
	"Interface\\AddOns\\ExRT\\media\\ariblk.ttf",
}

if ExRT.locale and ExRT.locale:find("^zh") then		--China & Taiwan fix
	ExRT.mds.defFont = "Fonts\\ARHei.ttf"
elseif ExRT.locale == "koKR" then			--Korea fix
	ExRT.mds.defFont = "Fonts\\2002.ttf"
end

----------> Version Checker <----------

local isVersionCheckCallback = nil
local function DisableVersionCheckCallback()
	isVersionCheckCallback = nil
end

---------------> Slash <---------------

SlashCmdList["exrtSlash"] = function (arg)
	local argL = strlower(arg)
	if argL == "icon" then
		VExRT.Addon.IconMiniMapHide = not VExRT.Addon.IconMiniMapHide
		if not VExRT.Addon.IconMiniMapHide then 
			ExRT.MiniMapIcon:Show()
		else
			ExRT.MiniMapIcon:Hide()
		end
	elseif argL == "getver" then
		ExRT.mds.SendExMsg("needversion","")
		isVersionCheckCallback = ExRT.mds.ScheduleETimer(isVersionCheckCallback, DisableVersionCheckCallback, 1.5)
	elseif argL == "getverg" then
		ExRT.mds.SendExMsg("needversiong","","GUILD")
		isVersionCheckCallback = ExRT.mds.ScheduleETimer(isVersionCheckCallback, DisableVersionCheckCallback, 1.5)
	elseif argL == "set" then
		ExRT.Options:Open()
	elseif argL == "quit" then
		for mod,data in pairs(ExRT.A) do
			data.main:UnregisterAllEvents()
		end
		ExRT.CLEUframe:UnregisterAllEvents()
		ExRT.frame:UnregisterAllEvents()
		ExRT.frame:SetScript("OnUpdate",nil)
		print("ExRT Disabled")
	elseif string.len(argL) == 0 then
		ExRT.Options:Open()
		return
	end
	for _,mod in pairs(ExRT.Slash) do
		mod:slash(argL,arg)
	end
end
SLASH_exrtSlash1 = "/exrt"
SLASH_exrtSlash2 = "/rt"
SLASH_exrtSlash3 = "/raidtools"
SLASH_exrtSlash4 = "/exorsusraidtools"
SLASH_exrtSlash5 = "/ert"

---------------> Global addon frame <---------------

local reloadTimer = 0.1

ExRT.frame = CreateFrame("Frame")

ExRT.frame:SetScript("OnEvent",function (self, event, ...)
	if event == "CHAT_MSG_ADDON" then
		local prefix, message, channel, sender = ...
		if prefix and ExRT.msg_prefix[prefix] and (channel=="RAID" or channel=="GUILD" or channel=="INSTANCE_CHAT" or channel=="PARTY" or (channel=="WHISPER" and (ExRT.mds.UnitInGuild(sender) or sender == ExRT.SDB.charName)) or (message and (message:find("^version") or message:find("^needversion")))) then
			ExRT.mds.GetExMsg(sender, strsplit("\t", message))
		end
	elseif event == "ADDON_LOADED" then
		local addonName = ...
		if addonName ~= GlobalAddonName then
			return
		end
		VExRT = VExRT or {}
		VExRT.Addon = VExRT.Addon or {}
		VExRT.Addon.Timer = VExRT.Addon.Timer or 0.1
		reloadTimer = VExRT.Addon.Timer

		if VExRT.Addon.IconMiniMapLeft and VExRT.Addon.IconMiniMapTop then
			ExRT.MiniMapIcon:ClearAllPoints()
			ExRT.MiniMapIcon:SetPoint("CENTER", VExRT.Addon.IconMiniMapLeft, VExRT.Addon.IconMiniMapTop)
		end
		
		if VExRT.Addon.IconMiniMapHide then 
			ExRT.MiniMapIcon:Hide() 
		end

		for prefix,_ in pairs(ExRT.msg_prefix) do
			RegisterAddonMessagePrefix(prefix)
		end
		
		VExRT.Addon.Version = tonumber(VExRT.Addon.Version or "0")
		VExRT.Addon.PreVersion = VExRT.Addon.Version
		
		if not ExRT.mds.FUNC_FILE_LOADED then
			print("|cffff0000Exorsus Raid Tools:|r after updating may work incorrectly, please restart your game client")
		end
		
		if ExRT.A.Profiles then
			ExRT.A.Profiles:ReselectProfileOnLoad()
		end
		
		ExRT.mds.dprint("ADDON_LOADED event")
		ExRT.mds.dprint("MODULES FIND",#ExRT.Modules)
		for i=1,#ExRT.Modules do
			local isSuccessful = pcall(ExRT.Modules[i].main.ADDON_LOADED,self) 	-- BE CARE ABOUT IT
			if not isSuccessful then
				ExRT.mds.dprint("|cffff0000Error loading",ExRT.Modules[i].name)
			end
			ExRT.ModulesLoaded[i] = true
			
			ExRT.mds.dprint("ADDON_LOADED",i,ExRT.Modules[i].name)
		end

		VExRT.Addon.Version = ExRT.V
		
		ExRT.mds.ScheduleTimer(function()
			ExRT.frame:SetScript("OnUpdate", ExRT.frame.OnUpdate)
			ExRT.CLEUframe:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		end,1)
		self:UnregisterEvent("ADDON_LOADED")

		return true	
	end
end)

ExRT.CLEUframe = CreateFrame("Frame")
do
	local CLEU = ExRT.CLEU
	ExRT.CLEUframe:SetScript("OnEvent",function (self, event, ...)
		for i=1,#CLEU do
			local func = CLEU[i]
			if func then
				func(self,...)
			end
		end
	end)
	
	if ExRT.T == "D" then
		ExRT.CLEUframe.eventsCounter = 0
		ExRT.CLEUframe:HookScript("OnEvent",function(self) self.eventsCounter = self.eventsCounter + 1 end)
	end
end

do
	local encounterTime,isEncounter = 0,nil
	local ExRT_OnUpdate = ExRT.OnUpdate
	local frameElapsed = 0
	function ExRT.frame:OnUpdate(elapsed)
		frameElapsed = frameElapsed + elapsed
		if frameElapsed > reloadTimer then
			if not isEncounter and IsEncounterInProgress() then
				isEncounter = true
				encounterTime = GetTime()
			elseif isEncounter and not IsEncounterInProgress() then
				isEncounter = nil
			end
			
			--[[
			for _,mod in pairs(ExRT_OnUpdate) do
				--pcall(mod.timer,self,self.tmr)	-- BE CARE ABOUT IT
				mod:timer(frameElapsed)
			end
			]]
			for i=1,#ExRT_OnUpdate do
				local mod = ExRT_OnUpdate[i]
				if mod then
					mod:timer(frameElapsed)
				end
			end
			frameElapsed = 0
		end
	end
	
	function ExRT.mds.RaidInCombat()
		return isEncounter
	end
	
	function ExRT.mds.GetEncounterTime()
		if isEncounter then
			return GetTime() - encounterTime
		end
	end
end

-- Заметка: сообщение в приват на другой сервер почему-то игнорируется

function ExRT.mds.SendExMsg(prefix, msg, tochat, touser, addonPrefix)
	addonPrefix = addonPrefix or "EXRTADD"
	msg = msg or ""
	if tochat and not touser then
		SendAddonMessage(addonPrefix, prefix .. "\t" .. msg, tochat)
	elseif tochat and touser then
		SendAddonMessage(addonPrefix, prefix .. "\t" .. msg, tochat,touser)
	else
		local chat_type, playerName = ExRT.mds.chatType()
		SendAddonMessage(addonPrefix, prefix .. "\t" .. msg, chat_type, playerName)
	end
end

function ExRT.mds.GetExMsg(sender, prefix, ...)
	if prefix == "needversion" then
		ExRT.mds.SendExMsg("version2", ExRT.V)
	elseif prefix == "needversiong" then
		ExRT.mds.SendExMsg("version2", ExRT.V, "WHISPER", sender)
	elseif prefix == "version" then
		local msgver = ...
		print(sender..": "..msgver)
	elseif prefix == "version2" then
		if isVersionCheckCallback then
			local msgver = ...
			print(sender..": "..msgver)
		end
	end
	for _,mod in pairs(ExRT.OnAddonMessage) do
		mod:addonMessage(sender, prefix, ...)
	end
end

_G["GExRT"] = ExRT
ExRT.frame:RegisterEvent("CHAT_MSG_ADDON")
ExRT.frame:RegisterEvent("ADDON_LOADED") 