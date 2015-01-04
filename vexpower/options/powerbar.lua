function vexpower.options.power.panel()	
	poweremptyInfoText = "|CFFC41F3BPower empty|r: When the current power is below "
	if vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["emptyIncEqual"] then
		poweremptyInfoText = poweremptyInfoText.."|CFFCC9900or equal|r "
	else
		poweremptyInfoText = poweremptyInfoText.."|CFFCC9900but not equal|r "
	end
	poweremptyInfoText = poweremptyInfoText.."to '|CFFCC9900"..vexpower.options.power.getPower("empty").."|r'\n"
	
	powerfullInfoText = "|CFF00FF00Power full|r: When the current power is above "
	if vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["fullIncEqual"] then
		powerfullInfoText = powerfullInfoText.."|CFFCC9900or equal|r "
	else
		powerfullInfoText = powerfullInfoText.."|CFFCC9900but not equal|r "
	end
	powerfullInfoText = powerfullInfoText.."to '|CFFCC9900"..vexpower.options.power.getPower("full").."|r'"
	

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
					edit = {name ='\nAny changes will be saved in profile: "|CFF008000'..vexpower_SV_data["profile"]..'|r"', type = "description", order=5, width="normal"},
					},
				},
			spacetestmode = {name ="\n", type = "description", order=3},
			
			grpoptiontabs = {
				name = "Toggle Option Tabs",
				order=5, type ="group", dialogInline = true,
				args = {
					position = {
						name = "Position & Size",
						order=1, type = "execute", width="normal",
						func = function(info,val) vexpower.options.power.toggleTab("position") vexpower.initialize.core(true) end,
						},
					powerpool = {
						name = "Layout",
						order=3, type = "execute", width="half",
						func = function(info,val) vexpower.options.power.toggleTab("powerpool") vexpower.initialize.core(true) end,
						},
					usedenergy = {
						name = "Used",
						order=5, type = "execute", width="half",
						func = function(info,val) vexpower.options.power.toggleTab("usedenergy") vexpower.initialize.core(true) end,
						},
					change = {
						name = "Recolor",
						order=6, type = "execute", width="half", hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),
						func = function(info,val) vexpower.options.power.toggleTab("change") vexpower.initialize.core(true) end,
						},
					},
				},
			spaceoptiontabs = {name =" ", type = "description", order=6},
			
			grppos = {
				name = "Position & Size",
				order=10, type ="group", dialogInline = true, hidden = not(vexpower.options.power.openTab["position"]),
				args = {
					info = {name = "You can make the frame movable with the testmode", type = "description", order=5},
					frameposx = {
						name = "X Position",
						order=6, type = "range",
						desc = "Sets the x position of the frame",
						step = 0.1, min = -2000, max = 2000,
						set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["position"]["x"]=val vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["position"]["x"] end
						},
					frameposy = {
						name = "Y Position",
						order=7, type = "range",
						desc = "Sets the y position of the frame",
						step = 0.1, min = -2000, max = 2000,
						set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["position"]["y"]=val vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["position"]["y"] end
						},
					space1 = {name =" ", type = "description", order=8, hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),},
					frameanchorFrame = {
						name = "Frame Anchor",
						order=9, type = "select", style = "dropdown",
						desc = "Sets the achor of the frame", hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),
						values = {
							["CENTER"]="Center",
							["BOTTOM"]="Bottom",
							["TOP"]="Top",
							["LEFT"]="Left",
							["RIGHT"]="Right",
							["BOTTOMLEFT"]="Bottomleft",
							["BOTTOMRIGHT"]="Bottomright",
							["TOPLEFT"]="Topleft",
							["TOPRIGHT"]="Topright"},
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["position"]["anchorFrame"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["position"]["anchorFrame"] end,
						},
					frameanchorScreen = {
						name = "Screen Anchor",
						order=10, type = "select", style = "dropdown",
						desc = "Sets the achor of the screen", hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),
						values = {
							["CENTER"]="Center",
							["BOTTOM"]="Bottom",
							["TOP"]="Top",
							["LEFT"]="Left",
							["RIGHT"]="Right",
							["BOTTOMLEFT"]="Bottomleft",
							["BOTTOMRIGHT"]="Bottomright",
							["TOPLEFT"]="Topleft",
							["TOPRIGHT"]="Topright"},
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["position"]["anchor"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["position"]["anchor"] end,
						},
					space12 = {name =" ", type = "description", order=20},
					framewidth = {
						name = "Width",
						order=21, type = "range",
						desc = "Sets the width of the frame",
						step = 0.1, min = 0, max = 2000,
						set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["size"]["width"]=val vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["size"]["width"] end
						},
					frameheight = {
						name = "Height",
						order=22, type = "range",
						desc = "Sets the height of the frame",
						step = 0.1, min = 0, max = 2000,
						set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["size"]["height"]=val vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["size"]["height"] end
						},
					},
				},
			
			grppowerpool = {
				name = "Layout",
				order=31, type ="group", dialogInline = true, hidden = not(vexpower.options.power.openTab["powerpool"]),
				args = {
					grppos = {
						name = "PowerBar",
						order=1, type ="group", dialogInline = true,
						args = {
							frameenergycolor = {
								name = "Color",
								order=1, type = "color", hasAlpha=false,
								desc = "background color used when not using blizzard's preset colors",
								disabled = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["colorByPowertype"] or vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["colorByClass"],
								set = function(info,r,g,b,a)
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["r"]=r
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["g"]=g
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["b"]=b
									vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["r"],
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["g"],
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["b"] end,
								},
							frametypecolored = {
								name = "Use powertype color",
								order=2, type = "toggle",
								set = function(self,key) vexpower.options.power.setColoring("type", key) vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["colorByPowertype"] end,
								},
							frameclasscolored = {
								name = "Use classcolor",
								order=3, type = "toggle",
								set = function(self,key) vexpower.options.power.setColoring("class", key) vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["colorByClass"] end,
								},
							opacityframe = {
								name = "Opacity %",
								order=4, type = "range",
								desc = "Sets the opacity",
								step = 5, min = 0, max = 100,
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["a"]=val/100 vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["a"]*100 end
								},
							space = {name =" ", type = "description", order=5},
						
							framebackdrop = {
								name = "Texture Pack 1",
								order=10, type = "select",
								dialogControl = "LSM30_Background",
								desc = "Sets the frame's background-texture",
								values = vexpower.LSM:HashTable("background"),
								set = function(self,key)
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["barTexture"]["pack1"]=key
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["barTexture"]["pack2"]=""
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["barTexture"]["usePack"]=1
									vexpower.initialize.core(true)
									end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["barTexture"]["pack1"] end,
								},
							framebackdrop2 = {
								name = "Texture Pack 2",
								order=11, type = "select",
								dialogControl = "LSM30_Statusbar",
								desc = "Sets the frame's background-texture",
								values = vexpower.LSM:HashTable("statusbar"),
								set = function(self,key)
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["barTexture"]["pack2"]=key
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["barTexture"]["pack1"]=""
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["barTexture"]["usePack"]=2
									vexpower.initialize.core(true)
									end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["barTexture"]["pack2"] end,
								},
							space2 = {name =" ", type = "description", order=12, hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"])},
							grpbackground = {
								name = "Insets",
								order=20, type ="group", dialogInline = true, hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),
								args = {
									spaceTopS = {name =" ", type = "description", order=1, width="normal",},
									top = {
										name = "Top",
										desc = "Controls how far into the frame the background will be drawn",
										order=2, type = "range",
										step = 1, min = 0, max = 20,
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["insets"]["top"]=val vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["insets"]["top"] end
										},
									spaceTopE = {name =" ", type = "description", order=3, width="normal",},
									left = {
										name = "Left",
										desc = "Controls how far into the frame the background will be drawn",
										order=4, type = "range",
										step = 1, min = 0, max = 20,
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["insets"]["left"]=val vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["insets"]["left"] end
										},
									spaceLeftRight = {name =" ", type = "description", order=5, width="normal",},
									right = {
										name = "Right",
										desc = "Controls how far into the frame the background will be drawn",
										order=6, type = "range",
										step = 1, min = 0, max = 20,
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["insets"]["right"]=val vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["insets"]["right"] end
										},
									spaceBottomS = {name =" ", type = "description", order=7, width="normal",},
									bottom = {
										name = "Bottom",
										desc = "Controls how far into the frame the background will be drawn",
										order=8, type = "range",
										step = 1, min = 0, max = 20,
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["insets"]["bottom"]=val vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["insets"]["bottom"] end
										},
									}
								},
							},
						},
					space = {name =" ", type = "description", order=2},
					grpbackground = {
						name = "Background",
						order=3, type ="group", dialogInline = true,
						args = {
							framebackdropbg = {
								name = "Background Texture",
								order=1, type = "select",
								dialogControl = "LSM30_Background",
								values = vexpower.LSM:HashTable("background"),
								set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["barBGTexture"]=key vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["barBGTexture"] end,
								},
							frameenergybgcolor = {
								name = "Background Color",
								order=2, type = "color", hasAlpha=false,
								set = function(info,r,g,b,a)
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarBGColor"]["r"]=r
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarBGColor"]["g"]=g
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarBGColor"]["b"]=b
									vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarBGColor"]["r"],
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarBGColor"]["g"],
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarBGColor"]["b"] end,
								},
							opacitybg = {
								name = "Background Opacity %",
								order=3, type = "range",
								desc = "Sets the opacity",
								step = 5, min = 0, max = 100,
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarBGColor"]["a"]=val/100 vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarBGColor"]["a"]*100 end
								},
							framebgspace = {name ="\n", type = "description", order=4},
							framebackdrop = {
								name = "Border Texture",
								order=5, type = "select",
								dialogControl = "LSM30_Border",
								values = vexpower.LSM:HashTable("border"),
								set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["texture"]=key vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["texture"] end,
								},
							frameenergybordercolor = {
								name = "Border Color",
								order=6, type = "color", hasAlpha=false,
								set = function(info,r,g,b,a)
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["color"]["r"]=r
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["color"]["g"]=g
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["color"]["b"]=b
									vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["color"]["r"],
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["color"]["g"],
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["color"]["b"] end,
								},
							opacityborder = {
								name = "Border Opacity %",
								order=7, type = "range",
								desc = "Sets the opacity",
								step = 5, min = 0, max = 100,
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["color"]["a"]=val/100 vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["color"]["a"]*100 end
								},
							frameenergybordersize = {
								name = "Border Size",
								order=8, type = "range",
								step = 1, min = 1, max = 15,
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["size"]=val vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["size"] end
								},
							},
						},
					},
				},
				
			grpusedeffect = {
				name = "'Used'-Effect",
				order=51, type ="group", dialogInline = true, hidden = not(vexpower.options.power.openTab["usedenergy"]),
				args = {
					info = {name = "Power that has just been spent will be recolored and then fades out.\n", type = "description", order=1},
					frameenergyused = {
						name = "Activate",
						order=10, type = "toggle", width="double",
						desc = "",
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["usedEffect"]["activate"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["usedEffect"]["activate"] end,
						},
					frameenergyusedDynamic = {
						name = "Use dynamic coloring",
						order=11, type = "toggle", width="double",
						desc = "The color will be produced by an algorithm and is dependent of the powerbar-color.",
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["usedEffect"]["dynamicColoring"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["usedEffect"]["dynamicColoring"] end,
						},
					frameenergyusedcolor = {
						name = "Color for 'used'-energy", width="double",
						order=12, type = "color", hasAlpha=false,
						desc = "Color of the energy that has just been used",
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["usedEffect"]["activate"]) or vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["usedEffect"]["dynamicColoring"],
						set = function(info,r,g,b,a)
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["usedEffect"]["color"]["r"]=r
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["usedEffect"]["color"]["g"]=g
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["usedEffect"]["color"]["b"]=b
							vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["usedEffect"]["color"]["r"],
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["usedEffect"]["color"]["g"],
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["usedEffect"]["color"]["b"] end,
						},
					opacityused = {
						name = "Opacity %",
						order=13, type = "range",
						desc = "Sets the opacity",
						step = 5, min = 0, max = 100,
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["usedEffect"]["activate"]),
						set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["usedEffect"]["color"]["a"]=val/100 vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["usedEffect"]["color"]["a"]*100 end
						},
					},
				},
									
			grpchangecolor = {
				name = "Recolor",
				order=61, type ="group", dialogInline = true, hidden = not(vexpower.options.power.openTab["change"]),
				args = {
					info = {name = "Setup up to 6 situations which recolor the powerbar\n", type = "description", order=1},
					infightdelay = {
						name = "'Out of Combat' delay timer (seconds)",
						order=2, type = "range", width="double",
						desc = "Sets the time the recoloring and the fade out effects (optionpanel 'show') are delayed when leaving combat",
						step = 1, min = 0, max = 30,
						set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["infightdelay"]=val vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["infightdelay"] end
						},
					space1 = {name =" ", type = "description", order=3},
					grpValues = {
						name = "Values",
						order=10, type ="group", dialogInline = true,
						args = {
							info = {name = "You can set 'power empty' and 'power full' at relative positions (e.g. '95%','60%',...) or you can set them at absolute positions (e.g. '1200','23500',...)\n", type = "description", order=1},
							powerempty = {
								name = "Set value for '|CFFC41F3Bpower empty|r'",
								order=10, type = "input", multiline = false, width="normal",
								set = function(info,val) vexpower.options.power.setPower("empty", val) vexpower.initialize.core(true) end,
								get = function() return vexpower.options.power.getPower("empty") end
								},
							poweremptyOperator = {
								name = "Include equality",
								order=11, type = "toggle", width="double",
								set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["emptyIncEqual"]=key vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["emptyIncEqual"] end,
								},
							poweremptyInfo = {name = poweremptyInfoText, type = "description", order=12},
							powerfull = {
								name = "Set value for '|CFF00FF00power full|r'",
								order=20, type = "input", multiline = false, width="normal",
								set = function(info,val) vexpower.options.power.setPower("full", val) vexpower.initialize.core(true) end,
								get = function() return vexpower.options.power.getPower("full") end
								},
							powerfullOperator = {
								name = "Include equality",
								order=21, type = "toggle", width="double",
								set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["fullIncEqual"]=key vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["fullIncEqual"] end,
								},
							powerfullInfo = {name = powerfullInfoText, type = "description", order=22},
							warning = {name = vexpower.options.power.emptyFullStatus, type = "description", order=25},
							},
						},
					space2 = {name =" ", type = "description", order=31},
					grpic = {
						name = "'In combat'",
						order=40, type ="group", dialogInline = true,
						args = {
							grpchangecolor1 = {
								name = "|CFFC41F3Bpower empty|r",
								order=11, type ="group", dialogInline = true,
								args = {
									use = {
										name = "Change color",
										order=1, type = "toggle", width="full",
										desc = "",
										set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][1]=key vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][1] end,
										},
									frameenergycolor = {
										name = "New color",
										order=2, type = "color", hasAlpha=false,
										desc = "background color used when not using blizzard's preset colors",
										hidden = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][1]),
										disabled = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByPowertype"][1] or vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByClass"][1] or not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][1]),
										set = function(info,r,g,b,a)
											-- vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["1"]["r"]=r
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["1"]["g"]=g
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["1"]["b"]=b
											vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["1"]["r"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["1"]["g"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["1"]["b"] end,
										},
									frametypecolored = {
										name = "Use powertype color",
										order=3, type = "toggle",
										hidden = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][1]),
										disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][1]),
										set = function(self,key) vexpower.options.power.setRecoloring(1, "type", key) vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByPowertype"][1] end,
										},
									frameclasscolored = {
										name = "Use classcolor",
										order=4, type = "toggle",
										hidden = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][1]),
										disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][1]),
										set = function(self,key) vexpower.options.power.setRecoloring(1, "class", key) vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByClass"][1] end,
										},
									opacityframe = {
										name = "Opacity %",
										order=5, type = "range",
										desc = "Sets the opacity",
										step = 5, min = 0, max = 100,
										hidden = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][1]),
										disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][1]),
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["1"]["a"]=val/100 vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["1"]["a"]*100 end
										},
									},
								},
							grpchangecolor2 = {
								name = "|CFFCC9900power neither full nor empty|r",
								order=12, type ="group", dialogInline = true,
								args = {
									use = {
										name = "Change color",
										order=1, type = "toggle", width="full",
										desc = "",
										set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][2]=key vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][2] end,
										},
									frameenergycolor = {
										name = "New color",
										order=2, type = "color", hasAlpha=false,
										desc = "background color used when not using blizzard's preset colors",
										hidden = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][2]),
										disabled = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByPowertype"][2] or vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByClass"][2] or not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][2]),
										set = function(info,r,g,b,a)
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["2"]["r"]=r
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["2"]["g"]=g
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["2"]["b"]=b
											vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["2"]["r"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["2"]["g"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["2"]["b"] end,
										},
									frametypecolored = {
										name = "Use powertype color",
										order=3, type = "toggle",
										hidden = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][2]),
										disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][2]),
										set = function(self,key) vexpower.options.power.setRecoloring(2, "type", key) vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByPowertype"][2] end,
										},
									frameclasscolored = {
										name = "Use classcolor",
										order=4, type = "toggle",
										hidden = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][2]),
										disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][2]),
										set = function(self,key) vexpower.options.power.setRecoloring(2, "class", key) vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByClass"][2] end,
										},
									opacityframe = {
										name = "Opacity %",
										order=5, type = "range",
										desc = "Sets the opacity",
										step = 5, min = 0, max = 100,
										hidden = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][2]),
										disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][2]),
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["2"]["a"]=val/100 vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["2"]["a"]*100 end
										},
									},
								},
							grpchangecolor3 = {
								name = "|CFF00FF00power full|r",
								order=13, type ="group", dialogInline = true,
								args = {
									use = {
										name = "Change color",
										order=1, type = "toggle", width="full",
										desc = "",
										set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][3]=key vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][3] end,
										},
									frameenergycolor = {
										name = "New color",
										order=2, type = "color", hasAlpha=false,
										desc = "background color used when not using blizzard's preset colors",
										hidden = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][3]),
										disabled = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByPowertype"][3] or vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByClass"][3] or not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][3]),
										set = function(info,r,g,b,a)
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["3"]["r"]=r
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["3"]["g"]=g
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["3"]["b"]=b
											vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["3"]["r"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["3"]["g"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["3"]["b"] end,
										},
									frametypecolored = {
										name = "Use powertype color",
										order=3, type = "toggle",
										hidden = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][3]),
										disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][3]),
										set = function(self,key) vexpower.options.power.setRecoloring(3, "type", key) vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByPowertype"][3] end,
										},
									frameclasscolored = {
										name = "Use classcolor",
										order=4, type = "toggle",
										hidden = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][3]),
										disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][3]),
										set = function(self,key) vexpower.options.power.setRecoloring(3, "class", key) vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByClass"][3] end,
										},
									opacityframe = {
										name = "Opacity %",
										order=5, type = "range",
										desc = "Sets the opacity",
										step = 5, min = 0, max = 100,
										hidden = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][3]),
										disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][3]),
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["3"]["a"]=val/100 vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["3"]["a"]*100 end
										},
									},
								},
							},
						},
					grpooc = {
						name = "'Out of combat'",
						order=50, type ="group", dialogInline = true,
						args = {
							grpchangecolor4 = {
								name = "|CFFC41F3Bpower empty|r",
								order=14, type ="group", dialogInline = true,
								args = {
									use = {
										name = "Change color",
										order=1, type = "toggle", width="full",
										desc = "",
										set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][4]=key vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][4] end,
										},
									frameenergycolor = {
										name = "New color",
										order=2, type = "color", hasAlpha=false,
										desc = "background color used when not using blizzard's preset colors",
										hidden = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][4]),
										disabled = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByPowertype"][4] or vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByClass"][4] or not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][4]),
										set = function(info,r,g,b,a)
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["4"]["r"]=r
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["4"]["g"]=g
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["4"]["b"]=b
											vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["4"]["r"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["4"]["g"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["4"]["b"] end,
										},
									frametypecolored = {
										name = "Use powertype color",
										order=3, type = "toggle",
										hidden = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][4]),
										disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][4]),
										set = function(self,key) vexpower.options.power.setRecoloring(4, "type", key) vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByPowertype"][4] end,
										},
									frameclasscolored = {
										name = "Use classcolor",
										order=4, type = "toggle",
										hidden = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][4]),
										disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][4]),
										set = function(self,key) vexpower.options.power.setRecoloring(4, "class", key) vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByClass"][4] end,
										},
									opacityframe = {
										name = "Opacity %",
										order=5, type = "range",
										desc = "Sets the opacity",
										step = 5, min = 0, max = 100,
										hidden = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][4]),
										disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][4]),
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["4"]["a"]=val/100 vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["4"]["a"]*100 end
										},
									},
								},
							grpchangecolor5 = {
								name = "|CFFCC9900power neither full nor empty|r",
								order=15, type ="group", dialogInline = true,
								args = {
									use = {
										name = "Change color",
										order=1, type = "toggle", width="full",
										desc = "",
										set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][5]=key vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][5] end,
										},
									frameenergycolor = {
										name = "New color",
										order=2, type = "color", hasAlpha=false,
										desc = "background color used when not using blizzard's preset colors",
										hidden = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][5]),
										disabled = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByPowertype"][5] or vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByClass"][5] or not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][5]),
										set = function(info,r,g,b,a)
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["5"]["r"]=r
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["5"]["g"]=g
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["5"]["b"]=b
											vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["5"]["r"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["5"]["g"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["5"]["b"] end,
										},
									frametypecolored = {
										name = "Use powertype color",
										order=3, type = "toggle",
										hidden = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][5]),
										disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][5]),
										set = function(self,key) vexpower.options.power.setRecoloring(5, "type", key) vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByPowertype"][5] end,
										},
									frameclasscolored = {
										name = "Use classcolor",
										order=4, type = "toggle",
										hidden = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][5]),
										disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][5]),
										set = function(self,key) vexpower.options.power.setRecoloring(5, "class", key) vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByClass"][5] end,
										},
									opacityframe = {
										name = "Opacity %",
										order=5, type = "range",
										desc = "Sets the opacity",
										step = 5, min = 0, max = 100,
										hidden = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][5]),
										disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][5]),
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["5"]["a"]=val/100 vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["5"]["a"]*100 end
										},
									},
								},
							grpchangecolor6 = {
								name = "|CFF00FF00power full|r",
								order=16, type ="group", dialogInline = true,
								args = {
									use = {
										name = "Change color",
										order=1, type = "toggle", width="full",
										desc = "",
										set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][6]=key vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][6] end,
										},
									frameenergycolor = {
										name = "New color",
										order=2, type = "color", hasAlpha=false,
										desc = "background color used when not using blizzard's preset colors",
										hidden = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][6]),
										disabled = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByPowertype"][6] or vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByClass"][6] or not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][6]),
										set = function(info,r,g,b,a)
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["6"]["r"]=r
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["6"]["g"]=g
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["6"]["b"]=b
											vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["6"]["r"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["6"]["g"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["6"]["b"] end,
										},
									frametypecolored = {
										name = "Use powertype color",
										order=3, type = "toggle",
										hidden = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][6]),
										disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][6]),
										set = function(self,key) vexpower.options.power.setRecoloring(6, "type", key) vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByPowertype"][6] end,
										},
									frameclasscolored = {
										name = "Use classcolor",
										order=4, type = "toggle",
										hidden = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][6]),
										disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][6]),
										set = function(self,key) vexpower.options.power.setRecoloring(6, "class", key) vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByClass"][6] end,
										},
									opacityframe = {
										name = "Opacity %",
										order=5, type = "range",
										desc = "Sets the opacity",
										step = 5, min = 0, max = 100,
										hidden = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][6]),
										disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][6]),
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["6"]["a"]=val/100 vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["6"]["a"]*100 end
										},
									},
								},
							},
						},
					},
				},
			}
		}
end