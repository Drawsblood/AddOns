function vexpower.options.strata.panel()
	local markers_text = " "
	if vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["strata"]["markers"] < vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["strata"]["powerbar"] then
		markers_text = "|CFFC41F3BWarning:|r The PowerBar is above the markers. Therefore the markers won't be shown !"
	end
	
	local textfields_text = " "
	if vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["strata"]["text"] < vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["strata"]["powerbar"] or vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["strata"]["text"] < vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["strata"]["cps"] then
		textfields_text = "|CFFC41F3BWarning:|r The PowerBar or/and the ComboPointBar are above the textfields. Therefore the textfields might not be shown !"
	end
	
	return {
		type = "group",
		order= 5,
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
					edit = {name ='\nAny changes will be saved in profile: "|CFF008000'..vexpower_SV_data["profile"]..'|r"', type = "description", order=5, width="normal"},
					},
				},
			spacetestmode = {name ="\n", type = "description", order=2},			
			grpstrata = {
				name = "FrameStrata",
				order=10, type ="group", dialogInline = true,
				args = {
					info = {name ="FrameStrata defines in which layer a frame is shown. By changing these values you can set a frame to be in front of other frames, similar to a priority system. Frames with a high value (e.g. 'DIALOG') will always be in front of other frames with a lower frameStata value (e.g. 'MEDIUM')\n", type = "description", order=2},
					
					powerbar = {
						name = "PowerBar",
						order=10, type = "select", style = "dropdown",
						values = vexpower.options.strata.getStrataValue(), width="double",
						set = function(self,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["strata"]["powerbar"] = val vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["strata"]["powerbar"] end,
						},
					space1 = {name =" ", type = "description", order=11},
					cps = {
						name = "ComboPointBar",
						order=20, type = "select", style = "dropdown",
						values = vexpower.options.strata.getStrataValue(), width="double",
						set = function(self,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["strata"]["cps"] = val vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["strata"]["cps"] end,
						},
					space2 = {name =" ", type = "description", order=21},
					markers = {
						name = "Markers",
						order=30, type = "select", style = "dropdown",
						values = vexpower.options.strata.getStrataValue(), width="double",
						set = function(self,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["strata"]["markers"] = val vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["strata"]["markers"] end,
						},
					space3 = {name = markers_text, type = "description", order=31},
					text = {
						name = "Textfields",
						order=40, type = "select", style = "dropdown",
						values = vexpower.options.strata.getStrataValue("textfields"), width="double",
						set = function(self,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["strata"]["text"] = val vexpower.initialize.core(true) end,
						get = function() return vexpower.options.strata.getTextfieldValue() end,
						},
					space4 = {name = textfields_text, type = "description", order=41},
					},
				},
			}
		}
end