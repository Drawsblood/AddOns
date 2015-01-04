function vexpower.options.show.panel()
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
			
			grpallow = {
				name = "General Settings",
				order=10, type ="group", dialogInline = true,
				args = {
					activateenergy = {
						name = "Enable Powerbar",
						order=3, type = "toggle", width="full",
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"]),
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["show"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["show"] end,
						},
					activatecps = {
						name = "Enable Combopoints",
						order=4, type = "toggle", width="full",
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"]),
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["show"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["show"] end,
						},
					},
				},
			space1 = {name =" ", type = "description", order=11},
				
			grpblizz = {
				name = "Blizzard's Frames",
				order=20, type ="group", dialogInline = true,
				args = {
					disableAltPower = {
						name = "Disable Blizzard's Chi Bar",
						order=1, type = "toggle", width="full",
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"]),
						set = function(self,key)
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["blizzhide"]["chi"]=key
							if key then
								vexpower.initialize.core(true)
							else
								ReloadUI()
							end
							end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["blizzhide"]["chi"] end,
						confirm = vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["blizzhide"]["chi"],
						confirmText = "Re-enabling Blizzard's frames needs a UI reload in order to work. Do you want to continue?"
						},
					disableHolyPower = {
						name = "Disable Blizzard's Holy Power Bar",
						order=1, type = "toggle", width="full",
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"]),
						set = function(self,key)
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["blizzhide"]["holypower"]=key
							if key then
								vexpower.initialize.core(true)
							else
								ReloadUI()
							end
							end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["blizzhide"]["holypower"] end,
						confirm = vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["blizzhide"]["holypower"],
						confirmText = "Re-enabling Blizzard's frames needs a UI reload in order to work. Do you want to continue?"
						},
					disableCPs = {
						name = "Disable Blizzard's ComboPoint Bar",
						order=2, type = "toggle", width="full",
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"]),
						set = function(self,key)
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["blizzhide"]["cps"]=key
							if key then
								vexpower.initialize.core(true)
							else
								ReloadUI()
							end
							end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["blizzhide"]["cps"] end,
						confirm = vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["blizzhide"]["cps"],
						confirmText = "Re-enabling Blizzard's frames needs a UI reload in order to work. Do you want to continue?"
						},
					disableLockShards = {
						name = "Disable Blizzard's Soul Shard Bar",
						order=3, type = "toggle", width="full",
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"]),
						set = function(self,key)
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["blizzhide"]["lockShards"]=key
							if key then
								vexpower.initialize.core(true)
							else
								ReloadUI()
							end
							end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["blizzhide"]["lockShards"] end,
						confirm = vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["blizzhide"]["lockShards"],
						confirmText = "Re-enabling Blizzard's frames needs a UI reload in order to work. Do you want to continue?"
						},
					},
				},
			space2 = {name =" ", type = "description", order=21, hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),},
			
			grpooc = {
				name = "'Out of Combat' Settings",
				order=30, type ="group", dialogInline = true, hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),
				args = {
					infightonly = {
						name = "When 'Out of Combat': Hide the Powerbar",
						order=1, type = "toggle", width="full",
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"]),
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["hideOOC"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["hideOOC"] end,
						},
					stealth = {
						name = "Still show stealthed",
						order=2, type = "toggle",
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["hideOOC"]) or not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"]),
						desc = "Shows the energy bar when stealthed even when the 'out of combat'-setting is enabled and you are out of combat",
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["inStealth"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["inStealth"] end,
						},
					targetSet = {
						name = "Still show when targeting a unit",
						order=3, type = "toggle", width="double",
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["hideOOC"]) or not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"]),
						desc = "Shows the energy bar when targeting a unit even when the 'out of combat'-setting is enabled and you are out of combat",
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["whenTargeting"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["whenTargeting"] end,
						},
					space1 = {name =" ", type = "description", order=4},
					infightonlyCP = {
						name = "When 'Out of Combat': Hide the ComboPoints",
						order=10, type = "toggle", width="full",
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"]),
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["hideOOC"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["hideOOC"] end,
						},
					stealthCP = {
						name = "Still show stealthed",
						order=11, type = "toggle",
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["hideOOC"]) or not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"]),
						desc = "Shows the combopoints when stealthed even when the 'out of combat'-setting is enabled and you are out of combat",
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["inStealth"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["inStealth"] end,
						},
					targetSetCP = {
						name = "Still show when targeting a unit",
						order=12, type = "toggle", width="double",
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["hideOOC"]) or not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"]),
						desc = "Shows the combopoints when targeting a unit even when the 'out of combat'-setting is enabled and you are out of combat",
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["whenTargeting"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["whenTargeting"] end,
						},
					frame_subspace2 = {name =" ", type = "description", order=20, hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),},
					infightdelay = {
						name = "'Out of Combat' delay timer (seconds)", hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),
						order=21, type = "range", width="double",
						desc = "Sets the time the recoloring (optionpanel 'powerbar') and the fade out effects are delayed when leaving combat",
						step = 1, min = 0, max = 30,
						set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["infightdelay"]=val vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["infightdelay"] end
						},
					},
				},
			space3 = {name =" ", type = "description", order=31, hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),},
			grpPetBattle = {
				name = "'Pet Battle' Settings",
				order=35, type ="group", dialogInline = true, hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),
				args = {
					notInPetBattleEnergy = {
						name = "When in a pet battle: Hide the Powerbar",
						order=1, type = "toggle", width="full",
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"]),
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["hideInPetBattle"]	=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["hideInPetBattle"]	 end,
						},
					space1 = {name =" ", type = "description", order=4},
					notInPetBattleCP = {
						name = "When in a pet battle: Hide the ComboPoints",
						order=10, type = "toggle", width="full",
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"]),
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["hideInPetBattle"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["hideInPetBattle"] end,
						},
					},
				},
			space_petBattle = {name =" ", type = "description", order=36, hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),},
			
			grppowertypes = {
				name = "Powertype settings",
				order=40, type ="group", dialogInline = true, hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),
				args = {
					powerbar = {
						name = "Show PowerBar when powertype is",
						order=1, type ="group", dialogInline = true,
						args = {
							marker_new_powertype_rage = {
								name = "|CFF"..vexpower.data.lib.getColor.powertypeHex("RAGE").."Rage|r",
								order=1, type = "toggle", width="half",
								set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["powertypes"]["RAGE"] = key vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["powertypes"]["RAGE"] end,
								},
							marker_new_powertype_mana = {
								name = "|CFF"..vexpower.data.lib.getColor.powertypeHex("MANA").."Mana|r",
								order=2, type = "toggle", width="half",
								set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["powertypes"]["MANA"] = key vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["powertypes"]["MANA"] end,
								},
							marker_new_powertype_focus = {
								name = "|CFF"..vexpower.data.lib.getColor.powertypeHex("FOCUS").."Focus|r",
								order=3, type = "toggle", width="half",
								set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["powertypes"]["FOCUS"] = key vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["powertypes"]["FOCUS"] end,
								},
							marker_new_powertype_energy = {
								name = "|CFF"..vexpower.data.lib.getColor.powertypeHex("ENERGY").."Energy|r",
								order=4, type = "toggle", width="half",
								set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["powertypes"]["ENERGY"] = key vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["powertypes"]["ENERGY"] end,
								},
							marker_new_powertype_rp = {
								name = "|CFF"..vexpower.data.lib.getColor.powertypeHex("RUNIC_POWER").."Runic Power|r",
								order=5, type = "toggle",
								set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["powertypes"]["RUNIC_POWER"] = key vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["powertypes"]["RUNIC_POWER"] end,
								},
							},
						},
					space = {name ="\n", type = "description", order=2},
					combopoints = {
						name = "Show ComboPointBar when powertype is",
						order=3, type ="group", dialogInline = true,
						args = {
							marker_new_powertype_rage = {
								name = "|CFF"..vexpower.data.lib.getColor.powertypeHex("RAGE").."Rage|r",
								order=1, type = "toggle", width="half",
								set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["powertypes"]["RAGE"] = key vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["powertypes"]["RAGE"] end,
								},
							marker_new_powertype_mana = {
								name = "|CFF"..vexpower.data.lib.getColor.powertypeHex("MANA").."Mana|r",
								order=2, type = "toggle", width="half",
								set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["powertypes"]["MANA"] = key vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["powertypes"]["MANA"] end,
								},
							marker_new_powertype_focus = {
								name = "|CFF"..vexpower.data.lib.getColor.powertypeHex("FOCUS").."Focus|r",
								order=3, type = "toggle", width="half",
								set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["powertypes"]["FOCUS"] = key vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["powertypes"]["FOCUS"] end,
								},
							marker_new_powertype_energy = {
								name = "|CFF"..vexpower.data.lib.getColor.powertypeHex("ENERGY").."Energy|r",
								order=4, type = "toggle", width="half",
								set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["powertypes"]["ENERGY"] = key vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["powertypes"]["ENERGY"] end,
								},
							marker_new_powertype_rp = {
								name = "|CFF"..vexpower.data.lib.getColor.powertypeHex("RUNIC_POWER").."Runic Power|r",
								order=5, type = "toggle",
								set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["powertypes"]["RUNIC_POWER"] = key vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["powertypes"]["RUNIC_POWER"] end,
								},
							},
						},
					},
				},
			space4 = {name =" ", type = "description", order=41, hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),},
			
			grpvehicle = {
				name = "Vehicle settings",
				order=50, type ="group", dialogInline = true, hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),
				args = {
					vehiclehidePower = {
						name = "When in a vehicle: Show the Powerbar",
						order=1, type = "toggle", width="double",
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"]),
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["hideInVehicle"]=not(key) vexpower.initialize.core(true) end,
						get = function() return not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["hideInVehicle"]) end,
						},
					vehicleEnergy= {
						name = "Show vehicle-power",
						order=2, type = "toggle",
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"]) or vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["hideInVehicle"],
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["vehicleEnergy"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["vehicleEnergy"] end,
						},
					vehiclehideCPs = {
						name = "When in a vehicle: Show the ComboPoints",
						order=10, type = "toggle", width="double",
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"]),
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["hideInVehicle"]=not(key) vexpower.initialize.core(true) end,
						get = function() return not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["hideInVehicle"]) end,
						},
					vehicleCPs= {
						name = "Show vehicle-CPs",
						order=11, type = "toggle",
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"]) or vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["hideInVehicle"],
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["vehicleCPs"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["show"]["vehicleCPs"] end,
						},
					info = {name = "Showing vehicle-CPs is experimentel, activating it may cause errors in vehicles", type = "description", order=20},
					},
				},
			space5 = {name =" ", type = "description", order=51, hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),},
			
			grpeffect = {
				name = "'FadeOut'-Effect",
				order=60, type ="group", dialogInline = true, hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),
				args = {
					info = {name = "When a frame shall become hidden it fades out, instead of instantly disappearing.\n", type = "description", order=1},
					fadeout= {
						name = "Activate",
						order=10, type = "toggle", width="full",
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"]),
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["fadeoutEffect"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["fadeoutEffect"] end,
						},
					space = {name = " ", type = "description", order=20},
					fadeoutTime = {
						name = "Duration (seconds)",
						order=30, type = "range", width="double",
						desc = "Sets the time the fade out effects last",
						step = 0.1, min = 0.1, max = 5,
						set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["fadeOutTime"]=val vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["fadeOutTime"] end
						},
					},
				},
			}
		}
end