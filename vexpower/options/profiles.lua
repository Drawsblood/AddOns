function vexpower.options.profiles.panel()
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
			profileToEdit = {
				name = "Current Profile",
				order=10, type ="group", dialogInline = true,
				args = {
					edit = {name ='Current profile loaded: "|CFF008000'..vexpower_SV_data["profile"]..'|r"'.."\nChanges to this profile will be automatically saved, you don't need to overwrite the profile.", type = "description", order=1},
					},
				},
			frame_space1 = {name =" ", type = "description", order=11},
			grpadd = {
				name = "Save Current Settings",
				order=12, type ="group", dialogInline = true,
				args = {
					profile_new = {
						name = "Name",
						desc = "Enter a name for the new profile",
						order=1, type = "input", multiline = false, width = "double",
						validate = function (info, val)
							if vexpower.options.profiles.checkName(val) then return true
							else return "ERROR - "..val.." is not a valid name" end
							end,
						set = function(info,val) vexpower.options.profiles.currentProfile = val vexpower.initialize.core(true) end,
						get = function() return vexpower.options.profiles.currentProfile end,
						},
					profile_new_add = {
						name = "save", width="half",
						order=2, type = "execute",
						func = function(info,val) vexpower.options.profiles.add() vexpower.initialize.core(true) end,
						confirm = vexpower.options.profiles.checkForExist(),
						confirmText = "A profile allready exists with that name. Do you want to overwrite this profile?"
						},
					},
				},
			frame_space2 = {name =" ", type = "description", order=14},
			grpdelete = {
				-- name = "Load, update and delete",
				name = "Load and delete",
				order=15, type ="group", dialogInline = true,
				args = {
					profile = {
						name = "Existing profiles",
						order=1, type = "select", style = "dropdown", width="double",
						desc = "Delete an existing profile",
						values = vexpower.options.profiles.getList(true),
						set = function(self,key) vexpower.options.profiles.currentProfile = key end,
						get = function() return vexpower.options.profiles.currentProfile end,
						},
					status = {name = vexpower.options.profiles.statusMsg, type = "description", order=2},
					load = {
						name = "load and activate",
						order=10, type = "execute",
						func = function(info,val) vexpower_optionTab_Profiles_load() vexpower.initialize.core(true) end,
						},
					-- update = {
						-- name = "update",
						-- desc = "Update will overwrite the profile with the current adjustments",
						-- order=11, type = "execute",
						-- func = function(info,val) vexpower.options.profiles.update() vexpower.initialize.core(true) end,
						-- },
					delete = {
						name = "delete",
						order=12, type = "execute",
						func = function(info,val) vexpower.options.profiles.delete() vexpower.initialize.core(true) end,
						confirm = true,
						confirmText = "Are you sure you want to delete this profile?"
						},
					},
				},
			}
		}
end
