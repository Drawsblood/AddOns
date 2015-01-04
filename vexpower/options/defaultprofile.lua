function vexpower.options.globalProfile.panel()
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
				name = "Default Profile",
				order=10, type ="group", dialogInline = true,
				args = {
					frame_space3 = {name = "Loads a specific profile instead of addon defaults for new chars.\n", type = "description", order=1},
					activate = {
						name = "Activate",
						order=10, type = "toggle", width="full",
						set = function(self,key) vexpower_SV_globalData["activate"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_globalData["activate"] end,
						},
					profile = {
						name = "Profile",
						order=20, type = "select", style = "dropdown", width="double",
						values = vexpower.options.profiles.getList(),
						set = function(self,key) vexpower_SV_globalData["profile"] = key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_globalData["profile"] end,
						},
					},
				},
			}
		}
end