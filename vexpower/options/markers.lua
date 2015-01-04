function vexpower.options.markers.panel()		
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
			spacetestmode = {name ="\n", type = "description", order=3},
			
			grpoptiontabs = {
				name = "Toggle Option Tabs",
				order=5, type ="group", dialogInline = true,
				args = {
					Add = {
						name = "Create",
						order=1, type = "execute", width="half",
						func = function(info,val) vexpower.options.markers.toggleTab("add") vexpower.initialize.core(true) end,
						},
					Update = {
						name = "Update/Delete",
						order=2, type = "execute",
						func = function(info,val) vexpower.options.markers.toggleTab("delete") vexpower.initialize.core(true) end,
						},
					Appearance = {
						name = "Color & Size",
						order=3, type = "execute",
						func = function(info,val) vexpower.options.markers.toggleTab("appearance") vexpower.initialize.core(true) end,
						},
					Information = {
						name = "HELP",
						order=4, type = "execute", width="half",
						func = function(info,val) vexpower.options.markers.toggleTab("information") vexpower.initialize.core(true) end,
						},
					--space = {name =" ", type = "description", order=3, width="half"},
					},
				},
			spaceoptiontabs = {name =" ", type = "description", order=6},
			
			grpex = {
				name = "Information",
				order=10, type = "group", dialogInline = true, hidden = not(vexpower.options.markers.openTab["information"]),
				args = {
					infopic={name = "", type="description", order=1, image="Interface\\AddOns\\vexpower\\images\\options_markers.tga",
						imageWidth=512, imageHeight=64},	
					info1={name = "Examples for markers are in the red circles\n", type="description", order=2,},	
					info2={name = "Markers are marks at absolute or at relative positions on your energybar.", type="description", order=3},	
					info3={name = "'50' will be placed on the energybar that represents exact 50 points of your power (absolute)", type="description", order=4},	
					info4={name = "'50%' will be placed on the energybar that represents 50% of your power (relative)", type="description", order=5},	
					info5={name = "You can create markers that are only shown with specific powertypes and specific specs.", type="description", order=6},
					info6={name = "By adjusting the powertype settings of a marker druids can use markers for specific forms. By setting a marker that is only shown with energy, the marker will only be shown when they are in their cat-form.", type="description", order=7},
					info7={name = "By adjusting the spec settings of a marker a rogue can place a marker for each of their primary attack spells", type="description", order=8},
					},
				},
			
			grpadd = {
				name = "Add/Overwrite marker",
				order=20, type ="group", dialogInline = true, hidden = not(vexpower.options.markers.openTab["add"]),
				args = {
					marker_new = {
						name = "Location",
						desc = "Enter a location where to put the new marker",
						order=1, type = "input", multiline = false,
						validate = function (info, val)
							if vexpower.options.markers.check(val) then return true
							else print("ERROR - "..val.." is not a valid position") return false end
							end,
						set = function(info,val) vexpower.options.markers.newLocation=val end,
						get = function() return vexpower.options.markers.newLocation end,
						},
					marker_new_spec = {
						name = "Visible for",
						order=2, type = "select", style = "dropdown",
						values = {[""]="Both Specs", ["a"]="Primary Spec", ["b"]="Secondary Spec"},
						set = function(self,key) vexpower.options.markers.newSpec = key end,
						get = function() return vexpower.options.markers.newSpec end,
						},
					powertypes = {
						name = "Visible with the following powertypes",
						order=3, type ="group", dialogInline = true,
						args = {
							marker_new_powertype_rage = {
								name = "|CFF"..vexpower.data.lib.getColor.powertypeHex("RAGE").."(R)age|r",
								order=1, type = "toggle", width="half",
								set = function(self,key) vexpower.options.markers.newPowertypes["RAGE"] = key vexpower.initialize.core(true) end,
								get = function() return vexpower.options.markers.newPowertypes["RAGE"] end,
								},
							marker_new_powertype_mana = {
								name = "|CFF"..vexpower.data.lib.getColor.powertypeHex("MANA").."(M)ana|r",
								order=2, type = "toggle", width="half",
								set = function(self,key) vexpower.options.markers.newPowertypes["MANA"] = key vexpower.initialize.core(true) end,
								get = function() return vexpower.options.markers.newPowertypes["MANA"] end,
								},
							marker_new_powertype_focus = {
								name = "|CFF"..vexpower.data.lib.getColor.powertypeHex("FOCUS").."(F)ocus|r",
								order=3, type = "toggle", width="half",
								set = function(self,key) vexpower.options.markers.newPowertypes["FOCUS"] = key vexpower.initialize.core(true) end,
								get = function() return vexpower.options.markers.newPowertypes["FOCUS"] end,
								},
							marker_new_powertype_energy = {
								name = "|CFF"..vexpower.data.lib.getColor.powertypeHex("ENERGY").."(E)nergy|r",
								order=4, type = "toggle", width="half",
								set = function(self,key) vexpower.options.markers.newPowertypes["ENERGY"] = key vexpower.initialize.core(true) end,
								get = function() return vexpower.options.markers.newPowertypes["ENERGY"] end,
								},
							marker_new_powertype_rp = {
								name = "|CFF"..vexpower.data.lib.getColor.powertypeHex("RUNIC_POWER").."(R)unic (P)ower|r",
								order=5, type = "toggle",
								set = function(self,key) vexpower.options.markers.newPowertypes["RUNIC_POWER"] = key vexpower.initialize.core(true) end,
								get = function() return vexpower.options.markers.newPowertypes["RUNIC_POWER"] end,
								},
							},
						},
					marker_new_add = {
						name = "add",
						order=4, type = "execute",
						func = function(info,val) vexpower.options.markers.add() vexpower.initialize.core(true) end,
						confirm = vexpower.options.markers.checkForExist(),
						confirmText = "A Marker allready exists at that location and for that spec. Do you want to overwrite this marker?"
						},
					marker_new_info = {name = vexpower.options.markers.statusMsgCreated, type = "description", order=20},
					},
				},
			
			grpdelete = {
				name = "Update / Delete marker",
				order=30, type ="group", dialogInline = true, hidden = not(vexpower.options.markers.openTab["delete"]),
				args = {
					marker_delete = {
						name = "Select from both specs",
						order=1, type = "select", style = "dropdown",
						values = vexpower.options.markers.getList("both"),
						set = function(self,key) vexpower.options.markers.loadToEdit(key, "") vexpower.initialize.core(true) end,
						get = function() return "" end,
						},
					marker_delete_a = {
						name = "Select from primary Spec",
						order=2, type = "select", style = "dropdown",
						values = vexpower.options.markers.getList("spec a"),
						set = function(self,key) vexpower.options.markers.loadToEdit(key, "a") vexpower.initialize.core(true) end,
						get = function() return "" end,
						},
					marker_delete_b = {
						name = "Select from secondary Spec",
						order=3, type = "select", style = "dropdown",
						values = vexpower.options.markers.getList("spec b"),
						set = function(self,key) vexpower.options.markers.loadToEdit(key, "b") vexpower.initialize.core(true) end,
						get = function() return "" end,
						},
					grpedit = {
						name = "Selected Marker",
						order=20, type ="group", dialogInline = true,
						args = {
							marker_edit = {
								name = "Location",
								order=20, type = "input", multiline = false, disabled=true,
								set = function(info,val) end,
								get = function() return vexpower.options.markers.editLocation end,
								},
							marker_new_spec = {
								name = "Visible for",
								order=21, type = "select", style = "dropdown", disabled = vexpower.options.markers.editLocation == "",
								values = {[""]="Both Specs", ["a"]="Primary Spec", ["b"]="Secondary Spec"},
								set = function(self,key) vexpower.options.markers.editSpec = key end,
								get = function() return vexpower.options.markers.editSpec end,
								},
							powertypes = {
								name = "Visible with the following powertypes",
								order=30, type ="group", dialogInline = true, disabled = vexpower.options.markers.editLocation == "",
								args = {
									marker_new_powertype_rage = {
										name = "|CFF"..vexpower.data.lib.getColor.powertypeHex("RAGE").."(R)age|r",
										order=1, type = "toggle", width="half",
										set = function(self,key) vexpower.options.markers.editPowertypes["RAGE"] = key vexpower.initialize.core(true) end,
										get = function() return vexpower.options.markers.editPowertypes["RAGE"] end,
										},
									marker_new_powertype_mana = {
										name = "|CFF"..vexpower.data.lib.getColor.powertypeHex("MANA").."(M)ana|r",
										order=2, type = "toggle", width="half",
										set = function(self,key) vexpower.options.markers.editPowertypes["MANA"] = key vexpower.initialize.core(true) end,
										get = function() return vexpower.options.markers.editPowertypes["MANA"] end,
										},
									marker_new_powertype_focus = {
										name = "|CFF"..vexpower.data.lib.getColor.powertypeHex("FOCUS").."(F)ocus|r",
										order=3, type = "toggle", width="half",
										set = function(self,key) vexpower.options.markers.editPowertypes["FOCUS"] = key vexpower.initialize.core(true) end,
										get = function() return vexpower.options.markers.editPowertypes["FOCUS"] end,
										},
									marker_new_powertype_energy = {
										name = "|CFF"..vexpower.data.lib.getColor.powertypeHex("ENERGY").."(E)nergy|r",
										order=4, type = "toggle", width="half",
										set = function(self,key) vexpower.options.markers.editPowertypes["ENERGY"] = key vexpower.initialize.core(true) end,
										get = function() return vexpower.options.markers.editPowertypes["ENERGY"] end,
										},
									marker_new_powertype_rp = {
										name = "|CFF"..vexpower.data.lib.getColor.powertypeHex("RUNIC_POWER").."(R)unic (P)ower|r",
										order=5, type = "toggle",
										set = function(self,key) vexpower.options.markers.editPowertypes["RUNIC_POWER"] = key vexpower.initialize.core(true) end,
										get = function() return vexpower.options.markers.editPowertypes["RUNIC_POWER"] end,
										},
									},
								},
							update = {
								name = "update", width="half",
								order=40, type = "execute", disabled = vexpower.options.markers.editLocation == "",
								func = function(info,val) vexpower.options.markers.update() vexpower.initialize.core(true) end,
								},
							delete = {
								name = "delete", width="half",
								order=41, type = "execute", disabled = vexpower.options.markers.editLocation == "",
								func = function(info,val) vexpower.options.markers.delete() vexpower.initialize.core(true) end,
								confirm = true,
								confirmText = "Are you sure you want to delete this marker?"
								},
							marker_deleted_info= {name = vexpower.options.markers.statusMsgDeleted, type = "description", order=100},
							},
						},
					},
				},
			
			grpapp = {
				name = "Color & Size",
				order=40, type = "group", dialogInline = true, hidden = not(vexpower.options.markers.openTab["appearance"]),
				args = {
					width = {
						name = "Size",
						order=1, type = "range",
						desc = "Sets the width of the marker",
						step = 1, min = 1, max = 10,
						set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["width"]=val vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["width"] end,
						},
					borderwidth = {
						name = "Border Size",
						order=2, type = "range",
						desc = "Sets the width of the border",
						step = 1, min = 1, max = 10,
						set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["border"]["size"]=val vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["border"]["size"] end,
						},
					space1 = {name =" ", type = "description", order=3},
					
					bgcolor = {
						name = "Background Color",
						order=10, type = "color", hasAlpha=false,
						desc = "Set the marker's background color",
						disabled = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["colorLikeBG"],
						set = function(info,r,g,b,a)
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["color"]["r"]=r
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["color"]["g"]=g
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["color"]["b"]=b
							vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["color"]["r"],
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["color"]["g"],
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["color"]["b"] end,
						},
					bgcolor_likebar = {
						name = "Use powerbar's color",
						order=11, type = "toggle",
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["colorLikeBG"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["colorLikeBG"] end,
						},
					bgopacity = {
						name = "Opacity %",
						order=12, type = "range",
						desc = "Sets the opacity",
						step = 5, min = 0, max = 100,
						set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["color"]["a"]=val/100 vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["color"]["a"]*100 end
						},	
					space2 = {name =" ", type = "description", order=13},
					
					borderborder = {
						name = "Border Color",
						order=20, type = "color", hasAlpha=false,
						desc = "Set the marker's border color",
						disabled = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["border"]["colorLikeBG"],
						set = function(info,r,g,b,a)
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["border"]["color"]["r"]=r
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["border"]["color"]["g"]=g
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["border"]["color"]["b"]=b
							vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["border"]["color"]["r"],
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["border"]["color"]["g"],
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["border"]["color"]["b"] end,
						},
					bordercolor_likebar = {
						name = "Use powerbar's color",
						order=21, type = "toggle",
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["border"]["colorLikeBG"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["border"]["colorLikeBG"] end,
						},
					borderopacity = {
						name = "Opacity %",
						order=22, type = "range",
						desc = "Sets the opacity",
						step = 5, min = 0, max = 100,
						set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["border"]["color"]["a"]=val/100 vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["border"]["color"]["a"]*100 end
						},
					},
				},
			}
		}
end
