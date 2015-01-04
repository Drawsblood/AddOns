function vexpower.initialize.core(refresh)
	vexpower.lib.setClassString()
	vexpower.initialize.loadSV()
	if not(refresh) then
		vexpower.powerBar.frames.barBG = CreateFrame("Frame", "vexpower.powerBar.frames.barBG", vexpower_MainFrame)
		vexpower.powerBar.frames.Bar = CreateFrame("Frame", "vexpower.powerBar.frames.Bar", vexpower.powerBar.frames.barBG)
		vexpower.powerBar.frames.BarDif = CreateFrame("Frame", "vexpower.powerBar.frames.BarDif", vexpower.powerBar.frames.barBG)
		vexpower.powerBar.frames.textbars = CreateFrame("Frame", "vexpower.powerBar.frames.textbars", vexpower.powerBar.frames.barBG)
		vexpower.powerBar.frames.markers = CreateFrame("Frame", "vexpower.powerBar.frames.markers", vexpower.powerBar.frames.barBG)
		
		vexpower.CPBar.mainframe = CreateFrame("Frame", "vexpower.CPBar.mainframe", vexpower_MainFrame)
		vexpower_CPsTextbar = CreateFrame("Frame", "vexpower.powerBar.frames.textbars", vexpower.CPBar.mainframe)
	end
	vexpower.text.createFontstrings()
	
	vexpower.mainframe.setFrame()
	vexpower.CPBar.setMainframe()
	
	vexpower.lib.setSpecID()
	vexpower.powerBar.setMaxWidth()
	if not(vexpower.testmode.activated) then
		vexpower.CPBar.setMax()
		vexpower.CPBar.setCurrent()
		vexpower.powerBar.setCurrentPower()
		vexpower.powerBar.setMaxPower()
		vexpower.powerBar.setPowertype(true)
	else
		vexpower.testmode.toggleCPBGs()
		vexpower.testmode.window.toggle()
	end
	
	vexpower.data.lib.setBlizzFrames()
	
	vexpower.powerBar.setBarBG()
	vexpower.powerBar.setBar()
	vexpower.powerBar.setBarDif()
	
	vexpower.text.setPowerTextbar()
	vexpower.text.setCPTextbar()
	vexpower.text.setFontstrings()
	vexpower.text.change()
	
	vexpower.CPBar.setBars()
	vexpower.powerBar.alt.builder()
	vexpower.powerBar.alt.setBars()
	
	vexpower.show.handler()
	vexpower.markers.handler()
	
	if not(vexpower.testmode.activated) then
		vexpower.powerBar.handler()
	end
	
	vexpower.mainframe.setMovable(false)
	
	if not(refresh) then
		vexpower.options.main.optionpanel = vexpower.AceConfigDialog:AddToBlizOptions("Vex Power", "Vex Power")
		vexpower.options.power.optionpanel = vexpower.AceConfigDialog:AddToBlizOptions("Vex Power Powerbar", "Powerbar", "Vex Power")
		vexpower.options.cps.optionpanel = vexpower.AceConfigDialog:AddToBlizOptions("Vex Power ComboPoints", "ComboPoints", "Vex Power")
		vexpower.options.colorpresets.optionpanel = vexpower.AceConfigDialog:AddToBlizOptions("Vex Power ComboPoint Color Sets", "ComboPoint Color Sets", "Vex Power")
		vexpower.options.colorpresets.optionpanel = vexpower.AceConfigDialog:AddToBlizOptions("Vex Power Alternative Powerbar", "Alternative Powerbar", "Vex Power")
		vexpower.options.text.optionpanel = vexpower.AceConfigDialog:AddToBlizOptions("Vex Power Textfields", "Textfields", "Vex Power")
		vexpower.options.markers.optionpanel = vexpower.AceConfigDialog:AddToBlizOptions("Vex Power Markers", "Markers", "Vex Power")
		vexpower.options.show.optionpanel = vexpower.AceConfigDialog:AddToBlizOptions("Vex Power Show", "Show", "Vex Power")
		vexpower.options.strata.optionpanel = vexpower.AceConfigDialog:AddToBlizOptions("Vex Power Strata", "FrameStrata", "Vex Power")
		vexpower.options.profiles.optionpanel = vexpower.AceConfigDialog:AddToBlizOptions("Vex Power Profiles", "Profiles", "Vex Power")
		vexpower.options.specProfiles.optionpanel = vexpower.AceConfigDialog:AddToBlizOptions("Vex Power Spec-Profiles", "SpecProfiles", "Vex Power")
		vexpower.options.globalProfile.optionpanel = vexpower.AceConfigDialog:AddToBlizOptions("Vex Power Global Defaults", "Global Defaults", "Vex Power")
	end
	vexpower.AceConfig:RegisterOptionsTable("Vex Power", vexpower.options.main.panel(), {})
	vexpower.AceConfig:RegisterOptionsTable("Vex Power Powerbar", vexpower.options.power.panel(), {})
	vexpower.AceConfig:RegisterOptionsTable("Vex Power ComboPoints", vexpower.options.cps.panel(), {})
	vexpower.AceConfig:RegisterOptionsTable("Vex Power ComboPoint Color Sets", vexpower.options.colorpresets.panel(), {})
	vexpower.AceConfig:RegisterOptionsTable("Vex Power Alternative Powerbar", vexpower.options.altPowerbar.panel(), {})
	vexpower.AceConfig:RegisterOptionsTable("Vex Power Textfields", vexpower.options.text.panel(), {})
	vexpower.AceConfig:RegisterOptionsTable("Vex Power Markers", vexpower.options.markers.panel(), {})
	vexpower.AceConfig:RegisterOptionsTable("Vex Power Show", vexpower.options.show.panel(), {})
	vexpower.AceConfig:RegisterOptionsTable("Vex Power Strata", vexpower.options.strata.panel(), {})
	vexpower.AceConfig:RegisterOptionsTable("Vex Power Profiles", vexpower.options.profiles.panel(), {})
	vexpower.AceConfig:RegisterOptionsTable("Vex Power Spec-Profiles", vexpower.options.specProfiles.panel(), {})
	vexpower.AceConfig:RegisterOptionsTable("Vex Power Global Defaults", vexpower.options.globalProfile.panel(), {})
end

function vexpower.initialize.loadSV(force)
	local newChar = vexpower_SV_data == nil
	local newAccount = vexpower_SV_profiles == nil and vexpower_SV_globalData == nil
	
	vexpower_SV_globalData =  vexpower.initialize.checkTableContent(vexpower.defaults.globalProfiles, vexpower_SV_globalData, force)
	
	if newAccount then
		vexpower_SV_colorsets = vexpower.data.lib.copyTable(vexpower.defaults.colorPresets)
	end
	
	--CHECK vexpower_SV_colorsets
	for key in pairs(vexpower_SV_colorsets) do
		vexpower_SV_colorsets[key] =  vexpower.initialize.checkTableContent(vexpower.defaults.singleColorPreset, vexpower_SV_colorsets[key], force)
	end
	
	local loadDefaultProfile = vexpower.initialize.loadGlobalProfile(newChar, newAccount)
	vexpower.initialize.loadGlobalClassPreset(newAccount)
		
	--CHECK vexpower_SV_data
	vexpower_SV_data =  vexpower.initialize.checkTableContent(vexpower.defaults.parameter, vexpower_SV_data)
	
	--CHECK vexpower_SV_profiles
	if vexpower_SV_profiles == nil									then  vexpower_SV_profiles = { } 	end
	if vexpower_SV_profiles[vexpower_SV_data["profile"]] == nil		then  vexpower_SV_profiles[vexpower_SV_data["profile"]] = { } 	end
	vexpower_SV_profiles[vexpower_SV_data["profile"]] =  vexpower.initialize.checkTableContent(vexpower.defaults.singleProfile, vexpower_SV_profiles[vexpower_SV_data["profile"]], force)
	
	if newChar and not(loadDefaultProfile) then
		vexpower_SV_data["profile"] = GetRealmName().."-"..select(1, UnitName("player"))
		
		vexpower_SV_profiles[vexpower_SV_data["profile"]] =  vexpower.data.lib.copyTable(vexpower.defaults.singleProfile)
		-- if vexpower_SV_globalData["classpresets"][vexpower.data.classString][1] or newAccount then
			-- vexpower.options.colorpresets.editName = vexpower_SV_globalData["classpresets"][vexpower.data.classString][2]
			-- vexpower.options.colorpresets.load()
		-- end
		
		if vexpower_SV_textfields == nil 	then  vexpower_SV_textfields = { } end
		vexpower_SV_textfields[vexpower_SV_data["profile"]] =  vexpower.data.lib.copyTable(vexpower.defaults.createdTextfields)
	elseif newChar and loadDefaultProfile then
		-- if vexpower_SV_globalData["classpresets"][vexpower.data.classString][1] or newAccount then
			-- vexpower.options.colorpresets.editName = vexpower_SV_globalData["classpresets"][vexpower.data.classString][2]
			-- vexpower.options.colorpresets.load()
		-- end
		vexpower_SV_data["profile"] = vexpower_SV_globalData["profile"]
	else
		if vexpower_SV_data["specProfile"]["activate"] then
			local activeSpec = GetActiveSpecGroup(false, false)
			local profile = ""
			if activeSpec == 1 then
				profile = vexpower_SV_data["specProfile"]["specAProfile"]
			else
				profile = vexpower_SV_data["specProfile"]["specBProfile"]
			end
			
			if vexpower_SV_profiles[profile] ~= nil then
				vexpower_SV_data["profile"] = profile
			else
				print("|CFFFF7D0AVex Power|r ERROR: Could not load spec-profile. Spec-profile '"..profile.."' doesn't exist.")
			end
		end
	end
	
	--LOAD CLASS PRESET
	if vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"] then
		local old = vexpower.options.colorpresets.editName
		vexpower.options.colorpresets.editName = vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["classPresets"][vexpower.data.classString]
		vexpower.options.colorpresets.load()
		vexpower.options.colorpresets.editName = old
	end
	
	
	--CHECK vexpower_SV_profiles
	if vexpower_SV_profiles == nil then 		
		vexpower_SV_profiles = { }
		for key in pairs(vexpower_SV_profiles) do
			vexpower_SV_profiles[key] =  vexpower.initialize.checkTableContent(vexpower.defaults.singleProfile, vexpower_SV_profiles[key])
		end
	end
	
	--CHECK vexpower_SV_markers_specBoth
	if vexpower_SV_markers_specBoth == nil 									then  	vexpower_SV_markers_specBoth = { } 									end
	if vexpower_SV_markers_specBoth[vexpower_SV_data["profile"]] == nil 	then  	vexpower_SV_markers_specBoth[vexpower_SV_data["profile"]] = { } 	end
	for key in pairs(vexpower_SV_markers_specBoth[vexpower_SV_data["profile"]]) do
		vexpower_SV_markers_specBoth[vexpower_SV_data["profile"]][key] =  vexpower.initialize.checkTableContent(vexpower.defaults.singleMarker, vexpower_SV_markers_specBoth[vexpower_SV_data["profile"]][key])
	end
	
	--CHECK vexpower_SV_markers_specA
	if vexpower_SV_markers_specA == nil 									then  	vexpower_SV_markers_specA = { } 									end
	if vexpower_SV_markers_specA[vexpower_SV_data["profile"]] == nil 	then  	vexpower_SV_markers_specA[vexpower_SV_data["profile"]] = { } 	end
	for key in pairs(vexpower_SV_markers_specA[vexpower_SV_data["profile"]]) do
		vexpower_SV_markers_specA[vexpower_SV_data["profile"]][key] =  vexpower.initialize.checkTableContent(vexpower.defaults.singleMarker, vexpower_SV_markers_specA[vexpower_SV_data["profile"]][key])
	end
	
	--CHECK vexpower_SV_markers_specB
	if vexpower_SV_markers_specB == nil 									then  	vexpower_SV_markers_specB = { } 									end
	if vexpower_SV_markers_specB[vexpower_SV_data["profile"]] == nil 	then  	vexpower_SV_markers_specB[vexpower_SV_data["profile"]] = { } 	end
	for key in pairs(vexpower_SV_markers_specB[vexpower_SV_data["profile"]]) do
		vexpower_SV_markers_specB[vexpower_SV_data["profile"]][key] =  vexpower.initialize.checkTableContent(vexpower.defaults.singleMarker, vexpower_SV_markers_specB[vexpower_SV_data["profile"]][key])
	end
	
	--CHECK vexpower_SV_textfields
	if vexpower_SV_textfields == nil 									then  	vexpower_SV_textfields = { } 									print("damn") end
	if vexpower_SV_textfields[vexpower_SV_data["profile"]] == nil 	then  	vexpower_SV_textfields[vexpower_SV_data["profile"]] = { } 	print("damn2") end
	
	for key in pairs(vexpower_SV_textfields[vexpower_SV_data["profile"]]) do
		vexpower_SV_textfields[vexpower_SV_data["profile"]][key] =  vexpower.initialize.checkTableContent(vexpower.defaults.singleTextfield, vexpower_SV_textfields[vexpower_SV_data["profile"]][key])
	end
	
	vexpower.options.colorpresets.gatherData()
	
	if force then vexpower.initialize.core(true) end
end

function vexpower.initialize.checkTableContent(defaults, saved, force, noadding)
	local temp = {}
	if force or type(saved) ~= "table" then temp=defaults
	else
		for key,val in pairs(defaults) do
			if type(val) == "table" then
				temp[key] = {}
				if saved[key] == nil then
					temp[key] = val
				else
					temp[key] = vexpower.initialize.checkTableContent(defaults[key], saved[key], force, noadding)
				end
			else
				if saved[key] == nil then
					temp[key] = val
				else
					temp[key] = saved[key]
				end
			end
		end
	end
	return temp
end

function vexpower.initialize.loadGlobalProfile(newChar, newAccount)
	local returnvalue = false
	if newChar and not(newAccount) then
		if vexpower_SV_profiles[vexpower_SV_globalData["profile"]] ~= nil and vexpower_SV_profiles ~= nil and vexpower_SV_globalData ~= nil then
			if vexpower_SV_globalData["activate"] then
				if vexpower_SV_profiles[vexpower_SV_globalData["profile"]] ~= nil then
					returnvalue = true
				else
					print("|CFFFF7D0AVex Power|r ERROR: Could not load default profile. Default profile '"..vexpower_SV_globalData["profile"].."' doesn't exist.")
					print("|CFFFF7D0AVex Power|r ERROR: Default addon settings will loaded instead. You can still load another profile manually in the options")
				end
			end
		end
	end
	return returnvalue
end

function vexpower.initialize.loadGlobalClassPreset(newAccount)
	if newAccount then
		vexpower.defaults.singleProfile["CPBar"]["design"]["colors"]["classPresets"]["activate"] = true
	end
end