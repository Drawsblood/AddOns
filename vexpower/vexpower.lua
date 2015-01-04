vexpower = {}
vexpower.addonLoaded = false

vexpower.data = {}
vexpower.data.classString = ""
vexpower.data.specTabID = 1
vexpower.data.specID = 0
vexpower.data.inStealth = false
vexpower.data.inVehicle = false
vexpower.data.inPetBattleFight = false
vexpower.data.inFight = {}
vexpower.data.inFight.delayed = false
vexpower.data.inFight.undelayed = false
vexpower.data.inFight.timestamp = 0
vexpower.data.inFight.ani = {}
vexpower.data.monkChiTimer = {}
vexpower.data.isTargetSet = false
vexpower.vehicle = {}
vexpower.vehicle.power = false
vexpower.vehicle.CP = false
vexpower.data.lib = {}
vexpower.data.lib.getColor = {}

vexpower.options = {}
vexpower.options.tagWindow = {}
vexpower.options.tagWindow.active = false
vexpower.options.colorpresets = {}
vexpower.options.cps = {}
vexpower.options.globalProfile = {}
vexpower.options.altPowerbar = {}
vexpower.options.main = {}
vexpower.options.power = {}
vexpower.options.profiles = {}
vexpower.options.show = {}
vexpower.options.markers = {}
vexpower.options.strata = {}
vexpower.options.text = {}
vexpower.options.specProfiles = {}

vexpower.defaults = {}
vexpower.lib = {}
vexpower.initialize = {}
vexpower.show = {}
vexpower.mainframe = {}
vexpower.text = {}

vexpower.markers = {}
vexpower.markers.created = {}

vexpower.testmode = {}
vexpower.testmode.activated = false
vexpower.testmode.delayedStartTimer = {}
vexpower.testmode.window = {}

vexpower.powerBar = {}
vexpower.powerBar.maxWidth = 0
vexpower.powerBar.powerType = "MANA"
-- vexpower.powerBar.powerTypePrev = "MANA"
vexpower.powerBar.maxPower = 100
-- vexpower.maxenergy_prev = 100
vexpower.powerBar.currentPower = {100, 100}	-- current, prev
vexpower.powerBar.show = true
vexpower.powerBar.frames = {}

vexpower.powerBar.alt = {}
vexpower.powerBar.alt.show = false
vexpower.powerBar.alt.maxWidth = {}
vexpower.powerBar.alt.maxPower = {{},{}}	-- current, prev
vexpower.powerBar.alt.currentPower = {{},{}}-- current, prev
vexpower.powerBar.alt.frames = {}
vexpower.powerBar.alt.frames.bar = {}
vexpower.powerBar.alt.frames.barBG = {}
vexpower.powerBar.alt.frames.barDif = {}

vexpower.CPBar = {}
vexpower.CPBar.currentCP = {0, 0}			-- current, prev
vexpower.CPBar.maxCPs = 5
vexpower.CPBar.show = true
vexpower.CPBar.frames = {}
vexpower.CPBar.aniGrps = {}
vexpower.CPBar.anis = {}



vexpower.AceConfigDialog = LibStub("AceConfigDialog-3.0", true)
vexpower.AceConfig = LibStub("AceConfig-3.0", true)
vexpower.AceConsole= LibStub("AceConsole-3.0", true)
vexpower.LSM = LibStub("LibSharedMedia-3.0", true)
vexpower.LSMWidgets = LibStub("AceGUI-3.0-SharedMediaWidgets", true)

function vexpower_onEvent(self, event, arg1, arg2, ...)
	if event == "PLAYER_LOGIN" then
		vexpower.initialize.core(false)
		vexpower.addonLoaded = true
	elseif vexpower.addonLoaded and event == "PLAYER_TARGET_CHANGED" then
		vexpower.data.isTargetSet = UnitName("target")~=nil
		vexpower.show.handler()
		-- vexdebugs.print(vexpower.data.isTargetSet,'vexpower.data.isTargetSet')
		-- vexdebugs.print(event,"event")
		-- vexdebugs.print(arg1,"arg1")
		-- vexdebugs.print(arg2,"arg2")
		-- for i=1,20 do
			-- if select(i, ...) ~= nil then
				-- vexdebugs.print(select(i,...),"select("..i..",...)")
			-- end
		-- end
	elseif vexpower.addonLoaded and event == "PLAYER_REGEN_DISABLED" then
		if vexpower.data.inFight.ani[1] ~= nil then
			if vexpower.data.inFight.ani[1]:IsPlaying() then
				vexpower.data.inFight.ani[1]:Stop()
			end
		end
		
		vexpower.data.inFight.delayed = true
		vexpower.data.inFight.undelayed = true
		vexpower.show.handler()
		vexpower.powerBar.setBarColor()
	elseif vexpower.addonLoaded and event == "PLAYER_REGEN_ENABLED" then
		vexpower.data.inFight.undelayed = false
		vexpower.data.inFight.timestamp = GetTime()
		
		vexpower.data.inFight.timerHandler()
		vexpower.data.lib.setMonkChiTimer()
	elseif vexpower.addonLoaded and event == "UPDATE_STEALTH" then
		vexpower.data.inStealth=IsStealthed()
		vexpower.show.handler()
	elseif vexpower.addonLoaded and event == "PET_BATTLE_OPENING_START" then
		vexpower.data.inPetBattleFight=true
		vexpower.show.handler()
	elseif vexpower.addonLoaded and event == "PET_BATTLE_CLOSE" then
		vexpower.data.inPetBattleFight=false
		vexpower.show.handler()
	elseif vexpower.addonLoaded and event == "LOADING_SCREEN_DISABLED" then
		vexpower.powerBar.setPowertype()
		vexpower.show.handler()
	elseif vexpower.addonLoaded and event == "UNIT_DISPLAYPOWER" then
		vexpower.powerBar.setPowertype()
		vexpower.show.handler()
		vexpower.powerBar.handler(true)
		vexpower.text.change()
	elseif vexpower.addonLoaded and (event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_SPECIALIZATION_CHANGED") then	
		-- vexpower.initialize.loadSpecProf()
		
		if vexpower.testmode.activated then
			vexpower.testmode.activated = false
			vexpower.testmode.delayedStartTimer = vexpower.lib.getTimer(
				"vexpower.testmode.delayedStartTimer", 0.5,
				function ()
					vexpower.testmode.activated = true
					vexpower.testmode.aniHandler()
					vexpower.testmode.aniStarter()
				end)
		end
		vexpower.lib.setSpecID()
		vexpower.initialize.core(true)
		
		-- vexpower.markers.handler()
		-- vexpower.powerBar.alt.builder()
	elseif event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE" then
		vexpower.lib.vehicleHandler(arg1 == "player")
	end
end

function vexpower_onUpdate()
	if vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"] and not(vexpower.testmode.activated) then
		if vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["show"] then
			if vexpower.powerBar.getCurrentPower() ~= vexpower.powerBar.currentPower[1] then
				vexpower.powerBar.handler()
			end
		end
		
		if vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["show"] then
			if vexpower.CPBar.getMax() ~= vexpower.CPBar.maxCPs then
				vexpower.initialize.core(true)
			end
			
			if vexpower.CPBar.getCurrent() ~= vexpower.CPBar.currentCP[1] then
				vexpower.CPBar.handler()
			end
			
			if vexpower.powerBar.alt.show then
				for i=1, vexpower.CPBar.maxCPs do
					if vexpower.powerBar.alt.getCurrentPower(i) ~= vexpower.powerBar.alt.currentPower[1][i] then
						if vexpower.powerBar.alt.frames.bar[1][2]~=nil then
							vexpower.powerBar.alt.handler(i)
						else
							vexpower.powerBar.alt.builder()
							vexpower.powerBar.alt.setBars()
						end
					end
				end
			end
		end
		vexpower.text.change()
	elseif vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"] then
		vexpower.text.change()
	end
end

