function vexpower.options.altPowerbar.panel()
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
				
			grpAltPowerbar = {
				name = "Alternative Powerbar",
				order=100, type ="group", dialogInline = true,
				args = {
					info =	{type="description", order=1, fontSize="medium", name="The alt. powerbar is currently only for demonology and destruction warlocks and shows burning ember and demonic fury. Due to the behaviour of said alt. powerbar being rather a bar than a Combopoint, but still being tracked similar to a ComboPoint these bars have some independent and some combined settings. Most settings like color and position however are still the same as the ones you pick for the traditional ComboPoints. All independent settings can be changed here."},
					grpbartexture = {
						name = "Bar",
						order=10, type ="group", dialogInline = true,
						args = {
							framebackdrop = {
								name = "Texture Pack 1",
								order=10, type = "select",
								dialogControl = "LSM30_Background",
								desc = "Sets the frame's background-texture",
								values = vexpower.LSM:HashTable("background"),
								set = function(self,key)
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["barTexture"]["pack1"]=key
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["barTexture"]["pack2"]=""
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["barTexture"]["usePack"]=1
									vexpower.initialize.core(true)
									end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["barTexture"]["pack1"] end,
								},
							framebackdrop2 = {
								name = "Texture Pack 2",
								order=11, type = "select",
								dialogControl = "LSM30_Statusbar",
								desc = "Sets the frame's background-texture",
								values = vexpower.LSM:HashTable("statusbar"),
								set = function(self,key)
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["barTexture"]["pack2"]=key
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["barTexture"]["pack1"]=""
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["barTexture"]["usePack"]=2
									vexpower.initialize.core(true)
									end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["barTexture"]["pack2"] end,
								},
							space =	{type="description", order=1, fontSize="medium", name=" "},
							grpinsets = {
								name = "Insets",
								order=20, type ="group", dialogInline = true, hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),
								args = {
									spaceTopS = {name =" ", type = "description", order=1, width="normal",},
									top = {
										name = "Top",
										desc = "Controls how far into the frame the background will be drawn",
										order=2, type = "range",
										step = 1, min = 0, max = 20,
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["insets"]["top"]=val vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["insets"]["top"] end
										},
									spaceTopE = {name =" ", type = "description", order=3, width="normal",},
									left = {
										name = "Left",
										desc = "Controls how far into the frame the background will be drawn",
										order=4, type = "range",
										step = 1, min = 0, max = 20,
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["insets"]["left"]=val vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["insets"]["left"] end
										},
									spaceLeftRight = {name =" ", type = "description", order=5, width="normal",},
									right = {
										name = "Right",
										desc = "Controls how far into the frame the background will be drawn",
										order=6, type = "range",
										step = 1, min = 0, max = 20,
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["insets"]["right"]=val vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["insets"]["right"] end
										},
									spaceBottomS = {name =" ", type = "description", order=7, width="normal",},
									bottom = {
										name = "Bottom",
										desc = "Controls how far into the frame the background will be drawn",
										order=8, type = "range",
										step = 1, min = 0, max = 20,
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["insets"]["bottom"]=val vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["insets"]["bottom"] end
										},
									},
								}
							},
						},
					space1 =	{type="description", order=11, fontSize="medium", name=" "},
					
					grpbackground = {
						name = "Background",
						order=20, type ="group", dialogInline = true,
						args = {
							framebackdropbg = {
								name = "Background Texture",
								order=1, type = "select",
								dialogControl = "LSM30_Background",
								values = vexpower.LSM:HashTable("background"),
								set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["barBGTexture"]=key vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["barBGTexture"] end,
								},
							frameenergybgcolor = {
								name = "Background Color",
								order=2, type = "color", hasAlpha=false,
								set = function(info,r,g,b,a)
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["BarBGColor"]["r"]=r
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["BarBGColor"]["g"]=g
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["BarBGColor"]["b"]=b
									vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["BarBGColor"]["r"],
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["BarBGColor"]["g"],
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["BarBGColor"]["b"] end,
								},
							opacitybg = {
								name = "Background Opacity %",
								order=3, type = "range",
								desc = "Sets the opacity",
								step = 5, min = 0, max = 100,
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["BarBGColor"]["a"]=val/100 vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["BarBGColor"]["a"]*100 end
								},
							},
						},
					space2 =	{type="description", order=21, fontSize="medium", name=" "},
					
					grpborder = {
						name = "Border",
						order=30, type ="group", dialogInline = true,
						args = {
							framebackdrop = {
								name = "Border Texture",
								order=5, type = "select",
								dialogControl = "LSM30_Border",
								values = vexpower.LSM:HashTable("border"),
								set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["border"]["texture"]=key vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["border"]["texture"] end,
								},
							frameenergybordercolor = {
								name = "Border Color",
								order=6, type = "color", hasAlpha=false,
								set = function(info,r,g,b,a)
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["border"]["color"]["r"]=r
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["border"]["color"]["g"]=g
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["border"]["color"]["b"]=b
									vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["border"]["color"]["r"],
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["border"]["color"]["g"],
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["border"]["color"]["b"] end,
								},
							opacityborder = {
								name = "Border Opacity %",
								order=7, type = "range",
								desc = "Sets the opacity",
								step = 5, min = 0, max = 100,
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["border"]["color"]["a"]=val/100 vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["border"]["color"]["a"]*100 end
								},
							frameenergybordersize = {
								name = "Border Size",
								order=8, type = "range",
								step = 1, min = 1, max = 15,
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["border"]["size"]=val vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["border"]["size"] end
								},
							},
						},
					space3 =	{type="description", order=31, fontSize="medium", name=" "},
					
					grpusedeffect = {
						name = "'Used'-Effect",
						order=40, type ="group", dialogInline = true,
						args = {
							info = {name = "Alt. power that has just been spent will be recolored and then fades out.\n", type = "description", order=1},
							frameenergyused = {
								name = "Activate",
								order=10, type = "toggle", width="full",
								desc = "",
								set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["usedEffect"]["activate"]=key vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["usedEffect"]["activate"] end,
								},
							frameenergyusedcolor = {
								name = "Color for 'used'-energy", width="double",
								order=11, type = "color", hasAlpha=false,
								desc = "Color of the energy that has just been used",
								disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["usedEffect"]["activate"]),
								set = function(info,r,g,b,a)
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["usedEffect"]["color"]["r"]=r
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["usedEffect"]["color"]["g"]=g
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["usedEffect"]["color"]["b"]=b
									vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["usedEffect"]["color"]["r"],
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["usedEffect"]["color"]["g"],
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["usedEffect"]["color"]["b"] end,
								},
							opacityused = {
								name = "Opacity %",
								order=12, type = "range",
								desc = "Sets the opacity",
								step = 5, min = 0, max = 100,
								disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["usedEffect"]["activate"]),
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["usedEffect"]["color"]["a"]=val/100 vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["usedEffect"]["color"]["a"]*100 end
								},
							},
						},
					},
				},
			}
		}
end





