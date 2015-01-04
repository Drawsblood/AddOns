function vexrunes.panel_show()
	return { 
		type = "group",
		order= 5,
		args = {
			grpallow = {
				name = "General Settings",
				order=1, type ="group", dialogInline = true,
				args = {
					activate = {
						name = "Enable addon",
						order=10, type = "toggle", width="full",
						desc = "Show",
						set = function(self,key) vexrunes_parameters["enable"]=key vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["enable"] end,
						},
					},
				},
			frame_space1 = {name ="\n", type = "description", order=2},
			
			grpshow = {
				name = "Show Settings",
				order=3, type ="group", dialogInline = true,
				args = {	
					infightonly = {
						name = "Hide when 'out of combat'",
						order=30, type = "toggle", width="full",
						set = function(self,key) vexrunes_parameters["infightshow"]=key vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["infightshow"] end,
						},
					petBattleHide = {
						name = "Hide when in a pet battle",
						order=30, type = "toggle", width="full",
						set = function(self,key) vexrunes_parameters["petBattleHide"]=key vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["petBattleHide"] end,
						},
					},
				},
			}
		}
end