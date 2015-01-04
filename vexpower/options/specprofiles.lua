function vexpower.options.specProfiles.panel()
	local name = GetRealmName().."-"..select(1, UnitName("player"))
	
	return {
		type = "group",
		args = {
			grptestmode = {
				name = "Option Settings",
				order=1, type ="group", dialogInline = true,
				args = {
					testmode = {
						name = "activate Testmode",
						order=1, type = "toggle", width="double",
						set = function(info,val) vexpower.testmode.activated=val vexpower.testmode.handler() end,
						get = function() return vexpower.testmode.activated end,
						},
					advOptions = {
						name = "show advanced Options",
						order=2, type = "toggle", width="normal",
						set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]=val vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"] end,
						},
					info = {name ="- ComboPoint gain and loss are simulated\n- Textfields get a colored background and are moveable\n- Powerbar and ComboPointBar become movable\n'/vexp testmode' can be used to toggle the testmode", type = "description", order=3, width="double"},
					edit = {name ='\n', type = "description", order=5, width="normal"},
					},
				},
			spacetestmode = {name ="\n", type = "description", order=2},
			grpadd = {
				name = "Spec-Profiles",
				order=3, type ="group", dialogInline = true,
				args = {
					desc = {name = "Loads a specific profile depending on your active spec.\nThese settings won't be saved in profiles or global profiles and have to be set separately for every char!\n", type = "description", order=9},
					activate = {
						name = "Enable Spec-Profiles",
						order=10, type = "toggle", width="full",
						set = function(self,key) vexpower_SV_data["specProfile"]["activate"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_data["specProfile"]["activate"] end,
						},
					profileA = {
						name = "Profile to load when spec A is active",
						order=20, type = "select", style = "dropdown", width="double",
						desc = "Delete an existing profile",
						values = vexpower.options.profiles.getList(true), disabled=not(vexpower_SV_data["specProfile"]["activate"]),
						set = function(self,key) vexpower_SV_data["specProfile"]["specAProfile"]=key end,
						get = function() return vexpower_SV_data["specProfile"]["specAProfile"] end,
						},
					descSpecA = {name = vexpower.options.specProfiles.getSpecDesc("A").."\n", type = "description", order=21},
					profileB = {
						name = "Profile to load when spec B is active",
						order=30, type = "select", style = "dropdown", width="double",
						desc = "Delete an existing profile",
						values = vexpower.options.profiles.getList(true), disabled=not(vexpower_SV_data["specProfile"]["activate"]),
						set = function(self,key) vexpower_SV_data["specProfile"]["specBProfile"]=key end,
						get = function() return vexpower_SV_data["specProfile"]["specBProfile"] end,
						},
					descSpecB = {name = vexpower.options.specProfiles.getSpecDesc("B").."\n", type = "description", order=31},
					},
				},
			}
		}
end
