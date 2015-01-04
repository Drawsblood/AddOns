function vexpower.options.cps.panel()
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
					position = {
						name = "Position & Size",
						order=1, type = "execute",
						func = function(info,val) vexpower.options.cps.toggleTab("layout") vexpower.initialize.core(true) end,
						},
					powerpool = {
						name = "Layout",
						order=2, type = "execute", width="half",
						func = function(info,val) vexpower.options.cps.toggleTab("background") vexpower.initialize.core(true) end,
						},
					background = {
						name = "Used",
						order=4, type = "execute", width="half",
						func = function(info,val) vexpower.options.cps.toggleTab("fadeout") vexpower.initialize.core(true) end,
						},
					usedenergy = {
						name = "Recolor",
						order=5, type = "execute", width="half",
						func = function(info,val) vexpower.options.cps.toggleTab("change") vexpower.initialize.core(true) end,
						},
					change = {
						name = "Sound",
						order=6, type = "execute", width="half",
						func = function(info,val) vexpower.options.cps.toggleTab("sound") vexpower.initialize.core(true) end,
						},
					classspec = {
						name = "Class-specifics",
						order=8, type = "execute", hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),
						func = function(info,val) vexpower.options.cps.toggleTab("classspec") vexpower.initialize.core(true) end,
						},
					},
				},
			spaceoptiontabs = {name =" ", type = "description", order=6},
			
			grpPosition = {
				name = "Position",
				order=10, type ="group", dialogInline = true, hidden = not(vexpower.options.cps.openTab["layout"]),
				args = {
					activate = {
						name = "Position the ComboPointBar relative to the PowerBar",
						order=1, type = "toggle", width="full",
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["position"]["clipToPower"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["position"]["clipToPower"] end,
						},
					info = {name = "The ComboPointbar contains all ComboPoints. This feature binds the two bars together. So whenever either one of them is moved, the other is moved also. Deactivating this feature lets you choose an absolute position for the ComboPointBar.", type ="description", order=2},
					space1 = {name = " ", type ="description", order=3, hidden=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["position"]["clipToPower"]},
					frameposx = {
						name = "X Position",
						order=6, type = "range",
						desc = "Sets the x position of the frame",
						step = 1, min = -2000, max = 2000,
						set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["position"]["x"]=val vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["position"]["x"] end
						},
					frameposy = {
						name = "Y Position",
						order=7, type = "range",
						desc = "Sets the y position of the frame",
						step = 1, min = -2000, max = 2000,
						set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["position"]["y"]=val vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["position"]["y"] end
						},
					space2 = {name =" ", type = "description", order=8, hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),},
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
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["position"]["anchorFrame"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["position"]["anchorFrame"] end,
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
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["position"]["anchor"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["position"]["anchor"] end,
						},
					},
				},
			grpModeSelection = {
				name = "Mode Selection",
				order=11, type ="group", dialogInline = true, hidden = (not(vexpower.options.cps.openTab["layout"]) or not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]) and vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["intMode"]["activate"]),
				args = {
					activate = {
						name = "Activate Intelligent-CP-Mode",
						order=1, type = "toggle", width="full",
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["intMode"]["activate"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["intMode"]["activate"] end,
						},
					info = {name = "The Intelligent-CP-Mode only needs little input to automatically calculate the position and the width of every single ComboPoint. Deactivating this feature lets you set all ComboPoints by yourself which needs plenty of input.\n", type ="description", order=2},
					},
				},
			grpAutoMode = {
				name = "Intelligent-CP-Mode",
				order=12, type ="group", dialogInline = true, hidden = not(vexpower.options.cps.openTab["layout"]) or not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["intMode"]["activate"]),
				args = {
					infopic={name = "", type="description", order=3, image="Interface\\AddOns\\vexpower\\images\\options_cps.tga",
						imageWidth=512, imageHeight=128},
					space1 = {name = "", type ="description", order=4},
					grp1stRow = {
						name = "1st row (standard row)",
						order=10, type ="group", dialogInline = true, hidden = not(vexpower.options.cps.openTab["layout"]) or not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["intMode"]["activate"]),
						args = {
							framex = {
								name = "X-Distance",
								order=10, type = "range",
								desc = "Sets the distance of the energybar to the combopoints",
								step = 1, min = -400, max = 400,
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["intMode"]["offset"]=val vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["intMode"]["offset"] end
								},
							frameheight = {
								name = "Height",
								order=16, type = "range",
								desc = "Height of the combopoints",
								step = 1, min = 1, max = 400,
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["intMode"]["height"]=val vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["intMode"]["height"] end
								},
							framegap = {
								name = "X-Gap",
								order=17, type = "range",
								desc = "Distance between the individual combopoints",
								step = 1, min = 1, max = 400,
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["intMode"]["gap"]=val vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["intMode"]["gap"] end
								},
							},
						},
					space3 = {name = " ", type ="description", order=11},
					grp2ndRow = {
						name = "2nd row",
						order=20, type ="group", dialogInline = true, hidden = not(vexpower.options.cps.openTab["layout"]) or not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["intMode"]["activate"]),
						args = {
							info = {name = "Rogues can have a 2nd row to display Anticipation-Stacks as additional ComboPoints. You can activate this at 'ComboPoints' --> 'Class specifics'. The following settings are for this additional combopoint-row.", type ="description", order=1},
							frameheight = {
								name = "Height",
								order=2, type = "range",
								desc = "Height of the combopoints",
								step = 1, min = 1, max = 400,
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["rogue"]["antiRowHeight"]=val vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["rogue"]["antiRowHeight"] end
								},
							frameYDistance = {
								name = "Y-Gap",
								order=2, type = "range",
								desc = "Height of the combopoints",
								step = 1, min = 1, max = 400,
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["rogue"]["antiRowYDistance"]=val vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["rogue"]["antiRowYDistance"] end
								},
							},
						},
					},
				},
			grpManualMode = {
				name = "Manual-Mode", 
				order=13, type ="group", dialogInline = true, hidden = not(vexpower.options.cps.openTab["layout"]) or vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["intMode"]["activate"],
				args = {
					info = {name = "You can set up a 'general'-setting for the ComboPoints. This setting contains the size and position of 6 ComboPoints and will be used as long as no other setting will overwrite it. Other Settings can be activated when you have another amount of maximum ComboPoints.\n", type ="description", order=1},
					
					profile = {
						name = "Config for:",
						order=10, type = "select", style = "dropdown", width="double",
						values = vexpower.options.cps.getList(),
						set = function(self,val) vexpower.options.cps.configCPSetting = val vexpower.initialize.core(true) end,
						get = function() return vexpower.options.cps.configCPSetting end,
						},
						
					config = {
						name = " ",
						order=20, type ="group", dialogInline = true,
						args = {
							use = {
								name = "Use these settings instead of the 'general'-setting when you have "..vexpower.options.cps.configCPSetting.." ComboPoints",
								order=1, type = "toggle", width="full", hidden = vexpower.options.cps.configCPSetting=="6",
								set = function(info,val) vexpower.options.cps.setSize("change",val) vexpower.initialize.core(true) end,
								get = function() return vexpower.options.cps.getSize("change") end,
								},
							space1 = {name =" ", type = "description", order=2, hidden = vexpower.options.cps.configCPSetting=="6"},
							
							framegap = {
								name = "Width",
								order=5, type = "range",
								step = 1, min = 1, max = 400,
								set = function(info,val) vexpower.options.cps.setSize("width", val) vexpower.initialize.core(true) end,
								get = function() return vexpower.options.cps.getSize("width") end
								},
							frameheight = {
								name = "Height",
								order=6, type = "range",
								step = 1, min = 1, max = 400,
								set = function(info,val) vexpower.options.cps.setSize("height", val) vexpower.initialize.core(true) end,
								get = function() return vexpower.options.cps.getSize("height") end
								},
							space2 = {name ="\n", type = "description", order=7},
							
							
							grp1 = {
								name = "|CFF00FF001st|r ComboPoint",
								order=100, type ="group", dialogInline = true, hidden = vexpower.options.cps.getHiddenCP(1),
								args = {
									frameposx = {
										name = "X Position",
										order=1, type = "range",
										desc = "Sets the x position of the frame",
										step = 1, min = -2000, max = 2000,
										set = function(info,val) vexpower.options.cps.setPos("1", "x", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("1", "x") end
										},
									frameposy = {
										name = "Y Position",
										order=2, type = "range",
										desc = "Sets the y position of the frame",
										step = 1, min = -2000, max = 2000,
										set = function(info,val) vexpower.options.cps.setPos("1", "y", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("1", "y") end
										},
									space1 = {name =" ", type = "description", order=13},
									frameanchorFrame = {
										name = "Frame Anchor",
										order=14, type = "select", style = "dropdown",
										desc = "Sets the achor of the frame",
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
										set = function(info,val) vexpower.options.cps.setPos("1", "anchor", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("1", "anchor") end
										},
									frameanchorScreen = {
										name = "Screen Anchor",
										order=15, type = "select", style = "dropdown",
										desc = "Sets the achor of the screen",
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
										set = function(info,val) vexpower.options.cps.setPos("1", "anchorFrame", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("1", "anchorFrame") end
										},
									},
								},
							space_1 = {name =" ", type = "description", order=101, hidden = vexpower.options.cps.getHiddenCP(1)},
							
							grp2 = {
								name = "|CFF00FF002nd|r ComboPoint",
								order=200, type ="group", dialogInline = true, hidden = vexpower.options.cps.getHiddenCP(2),
								args = {
									frameposx = {
										name = "X Position",
										order=1, type = "range",
										desc = "Sets the x position of the frame",
										step = 1, min = -2000, max = 2000,
										set = function(info,val) vexpower.options.cps.setPos("2", "x", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("2", "x") end
										},
									frameposy = {
										name = "Y Position",
										order=2, type = "range",
										desc = "Sets the y position of the frame",
										step = 1, min = -2000, max = 2000,
										set = function(info,val) vexpower.options.cps.setPos("2", "y", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("2", "y") end
										},
									space1 = {name =" ", type = "description", order=13},
									frameanchorFrame = {
										name = "Frame Anchor",
										order=14, type = "select", style = "dropdown",
										desc = "Sets the achor of the frame",
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
										set = function(info,val) vexpower.options.cps.setPos("2", "anchor", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("2", "anchor") end
										},
									frameanchorScreen = {
										name = "Screen Anchor",
										order=15, type = "select", style = "dropdown",
										desc = "Sets the achor of the screen",
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
										set = function(info,val) vexpower.options.cps.setPos("2", "anchorFrame", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("2", "anchorFrame") end
										},
									},
								},
							space_2 = {name =" ", type = "description", order=201, hidden = vexpower.options.cps.getHiddenCP(2)},
							grp3 = {
								name = "|CFF00FF003rd|r ComboPoint",
								order=300, type ="group", dialogInline = true, hidden = vexpower.options.cps.getHiddenCP(3),
								args = {
									frameposx = {
										name = "X Position",
										order=1, type = "range",
										desc = "Sets the x position of the frame",
										step = 1, min = -2000, max = 2000,
										set = function(info,val) vexpower.options.cps.setPos("3", "x", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("3", "x") end
										},
									frameposy = {
										name = "Y Position",
										order=2, type = "range",
										desc = "Sets the y position of the frame",
										step = 1, min = -2000, max = 2000,
										set = function(info,val) vexpower.options.cps.setPos("3", "y", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("3", "y") end
										},
									space1 = {name =" ", type = "description", order=13},
									frameanchorFrame = {
										name = "Frame Anchor",
										order=14, type = "select", style = "dropdown",
										desc = "Sets the achor of the frame",
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
										set = function(info,val) vexpower.options.cps.setPos("3", "anchor", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("3", "anchor") end
										},
									frameanchorScreen = {
										name = "Screen Anchor",
										order=15, type = "select", style = "dropdown",
										desc = "Sets the achor of the screen",
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
										set = function(info,val) vexpower.options.cps.setPos("3", "anchorFrame", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("3", "anchorFrame") end
										},
									},
								},
							space_3 = {name =" ", type = "description", order=301, hidden = vexpower.options.cps.getHiddenCP(3)},
							grp4 = {
								name = "|CFF00FF004th|r ComboPoint",
								order=400, type ="group", dialogInline = true, hidden = vexpower.options.cps.getHiddenCP(4),
								args = {
									frameposx = {
										name = "X Position",
										order=1, type = "range",
										desc = "Sets the x position of the frame",
										step = 1, min = -2000, max = 2000,
										set = function(info,val) vexpower.options.cps.setPos("4", "x", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("4", "x") end
										},
									frameposy = {
										name = "Y Position",
										order=2, type = "range",
										desc = "Sets the y position of the frame",
										step = 1, min = -2000, max = 2000,
										set = function(info,val) vexpower.options.cps.setPos("4", "y", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("4", "y") end
										},
									space1 = {name =" ", type = "description", order=13},
									frameanchorFrame = {
										name = "Frame Anchor",
										order=14, type = "select", style = "dropdown",
										desc = "Sets the achor of the frame",
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
										set = function(info,val) vexpower.options.cps.setPos("4", "anchor", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("4", "anchor") end
										},
									frameanchorScreen = {
										name = "Screen Anchor",
										order=15, type = "select", style = "dropdown",
										desc = "Sets the achor of the screen",
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
										set = function(info,val) vexpower.options.cps.setPos("4", "anchorFrame", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("4", "anchorFrame") end
										},
									},
								},
							space_4 = {name =" ", type = "description", order=401, hidden = vexpower.options.cps.getHiddenCP(4)},
							grp5 = {
								name = "|CFF00FF005th|r ComboPoint",
								order=500, type ="group", dialogInline = true, hidden = vexpower.options.cps.getHiddenCP(5),
								args = {
									frameposx = {
										name = "X Position",
										order=1, type = "range",
										desc = "Sets the x position of the frame",
										step = 1, min = -2000, max = 2000,
										set = function(info,val) vexpower.options.cps.setPos("5", "x", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("5", "x") end
										},
									frameposy = {
										name = "Y Position",
										order=2, type = "range",
										desc = "Sets the y position of the frame",
										step = 1, min = -2000, max = 2000,
										set = function(info,val) vexpower.options.cps.setPos("5", "y", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("5", "y") end
										},
									space1 = {name =" ", type = "description", order=13},
									frameanchorFrame = {
										name = "Frame Anchor",
										order=14, type = "select", style = "dropdown",
										desc = "Sets the achor of the frame",
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
										set = function(info,val) vexpower.options.cps.setPos("5", "anchor", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("5", "anchor") end
										},
									frameanchorScreen = {
										name = "Screen Anchor",
										order=15, type = "select", style = "dropdown",
										desc = "Sets the achor of the screen",
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
										set = function(info,val) vexpower.options.cps.setPos("5", "anchorFrame", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("5", "anchorFrame") end
										},
									},
								},
							space_5 = {name =" ", type = "description", order=501, hidden = vexpower.options.cps.getHiddenCP(5)},
							grp6 = {
								name = "|CFF00FF006th|r ComboPoint",
								order=600, type ="group", dialogInline = true, hidden = vexpower.options.cps.getHiddenCP(6),
								args = {
									frameposx = {
										name = "X Position",
										order=1, type = "range",
										desc = "Sets the x position of the frame",
										step = 1, min = -2000, max = 2000,
										set = function(info,val) vexpower.options.cps.setPos("6", "x", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("6", "x") end
										},
									frameposy = {
										name = "Y Position",
										order=2, type = "range",
										desc = "Sets the y position of the frame",
										step = 1, min = -2000, max = 2000,
										set = function(info,val) vexpower.options.cps.setPos("6", "y", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("6", "y") end
										},
									space1 = {name =" ", type = "description", order=13},
									frameanchorFrame = {
										name = "Frame Anchor",
										order=14, type = "select", style = "dropdown",
										desc = "Sets the achor of the frame",
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
										set = function(info,val) vexpower.options.cps.setPos("6", "anchor", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("6", "anchor") end
										},
									frameanchorScreen = {
										name = "Screen Anchor",
										order=15, type = "select", style = "dropdown",
										desc = "Sets the achor of the screen",
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
										set = function(info,val) vexpower.options.cps.setPos("6", "anchorFrame", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("6", "anchorFrame") end
										},
									},
								},
							space_6 = {name =" ", type = "description", order=601, hidden = vexpower.options.cps.getHiddenCP(6)},
							grp7 = {
								name = "|CFF00FF007th|r ComboPoint",
								order=700, type ="group", dialogInline = true, hidden = vexpower.options.cps.getHiddenCP(7),
								args = {
									frameposx = {
										name = "X Position",
										order=1, type = "range",
										desc = "Sets the x position of the frame",
										step = 1, min = -2000, max = 2000,
										set = function(info,val) vexpower.options.cps.setPos("7", "x", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("7", "x") end
										},
									frameposy = {
										name = "Y Position",
										order=2, type = "range",
										desc = "Sets the y position of the frame",
										step = 1, min = -2000, max = 2000,
										set = function(info,val) vexpower.options.cps.setPos("7", "y", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("7", "y") end
										},
									space1 = {name =" ", type = "description", order=13},
									frameanchorFrame = {
										name = "Frame Anchor",
										order=14, type = "select", style = "dropdown",
										desc = "Sets the achor of the frame",
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
										set = function(info,val) vexpower.options.cps.setPos("7", "anchor", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("7", "anchor") end
										},
									frameanchorScreen = {
										name = "Screen Anchor",
										order=15, type = "select", style = "dropdown",
										desc = "Sets the achor of the screen",
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
										set = function(info,val) vexpower.options.cps.setPos("7", "anchorFrame", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("7", "anchorFrame") end
										},
									},
								},
							space_7 = {name =" ", type = "description", order=701, hidden = vexpower.options.cps.getHiddenCP(7)},
							grp8 = {
								name = "|CFF00FF008th|r ComboPoint",
								order=800, type ="group", dialogInline = true, hidden = vexpower.options.cps.getHiddenCP(8),
								args = {
									frameposx = {
										name = "X Position",
										order=1, type = "range",
										desc = "Sets the x position of the frame",
										step = 1, min = -2000, max = 2000,
										set = function(info,val) vexpower.options.cps.setPos("8", "x", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("8", "x") end
										},
									frameposy = {
										name = "Y Position",
										order=2, type = "range",
										desc = "Sets the y position of the frame",
										step = 1, min = -2000, max = 2000,
										set = function(info,val) vexpower.options.cps.setPos("8", "y", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("8", "y") end
										},
									space1 = {name =" ", type = "description", order=13},
									frameanchorFrame = {
										name = "Frame Anchor",
										order=14, type = "select", style = "dropdown",
										desc = "Sets the achor of the frame",
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
										set = function(info,val) vexpower.options.cps.setPos("8", "anchor", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("8", "anchor") end
										},
									frameanchorScreen = {
										name = "Screen Anchor",
										order=15, type = "select", style = "dropdown",
										desc = "Sets the achor of the screen",
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
										set = function(info,val) vexpower.options.cps.setPos("8", "anchorFrame", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("8", "anchorFrame") end
										},
									},
								},
							space_8 = {name =" ", type = "description", order=801, hidden = vexpower.options.cps.getHiddenCP(8)},
							grp9 = {
								name = "|CFF00FF007th|r ComboPoint",
								order=900, type ="group", dialogInline = true, hidden = vexpower.options.cps.getHiddenCP(9),
								args = {
									frameposx = {
										name = "X Position",
										order=1, type = "range",
										desc = "Sets the x position of the frame",
										step = 1, min = -2000, max = 2000,
										set = function(info,val) vexpower.options.cps.setPos("9", "x", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("9", "x") end
										},
									frameposy = {
										name = "Y Position",
										order=2, type = "range",
										desc = "Sets the y position of the frame",
										step = 1, min = -2000, max = 2000,
										set = function(info,val) vexpower.options.cps.setPos("9", "y", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("9", "y") end
										},
									space1 = {name =" ", type = "description", order=13},
									frameanchorFrame = {
										name = "Frame Anchor",
										order=14, type = "select", style = "dropdown",
										desc = "Sets the achor of the frame",
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
										set = function(info,val) vexpower.options.cps.setPos("9", "anchor", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("9", "anchor") end
										},
									frameanchorScreen = {
										name = "Screen Anchor",
										order=15, type = "select", style = "dropdown",
										desc = "Sets the achor of the screen",
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
										set = function(info,val) vexpower.options.cps.setPos("9", "anchorFrame", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("9", "anchorFrame") end
										},
									},
								},
								
							space_9 = {name =" ", type = "description", order=901, hidden = vexpower.options.cps.getHiddenCP(9)},
							grp10 = {
								name = "|CFF00FF007th|r ComboPoint",
								order=1000, type ="group", dialogInline = true, hidden = vexpower.options.cps.getHiddenCP(10),
								args = {
									frameposx = {
										name = "X Position",
										order=1, type = "range",
										desc = "Sets the x position of the frame",
										step = 1, min = -2000, max = 2000,
										set = function(info,val) vexpower.options.cps.setPos("10", "x", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("10", "x") end
										},
									frameposy = {
										name = "Y Position",
										order=2, type = "range",
										desc = "Sets the y position of the frame",
										step = 1, min = -2000, max = 2000,
										set = function(info,val) vexpower.options.cps.setPos("10", "y", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("10", "y") end
										},
									space1 = {name =" ", type = "description", order=13},
									frameanchorFrame = {
										name = "Frame Anchor",
										order=14, type = "select", style = "dropdown",
										desc = "Sets the achor of the frame",
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
										set = function(info,val) vexpower.options.cps.setPos("10", "anchor", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("10", "anchor") end
										},
									frameanchorScreen = {
										name = "Screen Anchor",
										order=15, type = "select", style = "dropdown",
										desc = "Sets the achor of the screen",
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
										set = function(info,val) vexpower.options.cps.setPos("10", "anchorFrame", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.cps.getPos("10", "anchorFrame") end
										},
									},
								},
							},
						},
					},
				},
				
				
				
				
				
			grpcolors = {
				name = "Layout",
				order=30, type ="group", dialogInline = true, hidden = not(vexpower.options.cps.openTab["background"]),
				args = {
					grpcolors = {
						name = "ComboPoints",
						order=1, type ="group", dialogInline = true,
						args = {
							activatePresets = {
								name = "Load individual color sets for each class instead of one color set for all classes.",
								order=1, type = "toggle", width="full",
								set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"]=key vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"] end,
								},
							info = {name ='The class specific color sets can be setup in the option panel "ComboPoint Color Sets"', type = "description", order=50},
							
							set1 = {
								name = "Color set for all classes",
								order=10, type ="group", dialogInline = true, hidden=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"],
								args = {
									framecolors1 = {
										name = "Color of the 1st 'ComboPoint'", width="double",
										order=110, type = "color", hasAlpha=false, disabled=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"],
										set = function(info,r,g,b)
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["1"]["r"]=r
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["1"]["g"]=g
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["1"]["b"]=b
											vexpower.initialize.core(true) end,
										get = function() return
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["1"]["r"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["1"]["g"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["1"]["b"] end,
										},
									opacity1 = {
										name = "Opacity %",
										order=111, type = "range",
										desc = "Sets the opacity",
										step = 5, min = 0, max = 100, disabled=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"],
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["1"]["a"]=val/100 vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["1"]["a"]*100 end
										},
									framecolors2 = {
										name = "Color of the 2nd 'ComboPoint'", width="double",
										order=120, type = "color", hasAlpha=false, disabled=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"],
										set = function(info,r,g,b)
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["2"]["r"]=r
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["2"]["g"]=g
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["2"]["b"]=b
											vexpower.initialize.core(true) end,
										get = function() return
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["2"]["r"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["2"]["g"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["2"]["b"] end,
										},
									opacity2 = {
										name = "Opacity %",
										order=121, type = "range",
										desc = "Sets the opacity",
										step = 5, min = 0, max = 100, disabled=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"],
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["2"]["a"]=val/100 vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["2"]["a"]*100 end
										},
									framecolors3 = {
										name = "Color of the 3rd 'ComboPoint'", width="double",
										order=130, type = "color", hasAlpha=false, disabled=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"],
										set = function(info,r,g,b)
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["3"]["r"]=r
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["3"]["g"]=g
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["3"]["b"]=b
											vexpower.initialize.core(true) end,
										get = function() return
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["3"]["r"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["3"]["g"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["3"]["b"] end,
										},
									opacity3 = {
										name = "Opacity %",
										order=131, type = "range",
										desc = "Sets the opacity",
										step = 5, min = 0, max = 100, disabled=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"],
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["3"]["a"]=val/100 vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["3"]["a"]*100 end
										},
									framecolors4 = {
										name = "Color of the 4th 'ComboPoint'", width="double",
										order=140, type = "color", hasAlpha=false, disabled=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"],
										set = function(info,r,g,b)
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["4"]["r"]=r
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["4"]["g"]=g
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["4"]["b"]=b
											vexpower.initialize.core(true) end,
										get = function() return
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["4"]["r"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["4"]["g"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["4"]["b"] end,
										},
									opacity4 = {
										name = "Opacity %",
										order=141, type = "range",
										desc = "Sets the opacity",
										step = 5, min = 0, max = 100, disabled=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"],
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["4"]["a"]=val/100 vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["4"]["a"]*100 end
										},
									framecolors5 = {
										name = "Color of the 5th 'ComboPoint'", width="double",
										order=150, type = "color", hasAlpha=false, disabled=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"],
										set = function(info,r,g,b)
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["5"]["r"]=r
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["5"]["g"]=g
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["5"]["b"]=b
											vexpower.initialize.core(true) end,
										get = function() return
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["5"]["r"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["5"]["g"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["5"]["b"] end,
										},
									opacity5 = {
										name = "Opacity %",
										order=151, type = "range",
										desc = "Sets the opacity",
										step = 5, min = 0, max = 100, disabled=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"],
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["5"]["a"]=val/100 vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["5"]["a"]*100 end
										},
									framecolors6 = {
										name = "Color of the 6th 'ComboPoint'", width="double",
										order=160, type = "color", hasAlpha=false, disabled=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"],
										set = function(info,r,g,b)
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["6"]["r"]=r
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["6"]["g"]=g
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["6"]["b"]=b
											vexpower.initialize.core(true) end,
										get = function() return
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["6"]["r"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["6"]["g"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["6"]["b"] end,
										},
									opacity6 = {
										name = "Opacity %",
										order=161, type = "range",
										desc = "Sets the opacity",
										step = 5, min = 0, max = 100, disabled=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"],
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["6"]["a"]=val/100 vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["6"]["a"]*100 end
										},
									framecolors7 = {
										name = "Color of the 7th 'ComboPoint'", width="double",
										order=170, type = "color", hasAlpha=false, disabled=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"],
										set = function(info,r,g,b)
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["7"]["r"]=r
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["7"]["g"]=g
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["7"]["b"]=b
											vexpower.initialize.core(true) end,
										get = function() return
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["7"]["r"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["7"]["g"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["7"]["b"] end,
										},
									opacity7 = {
										name = "Opacity %",
										order=171, type = "range",
										desc = "Sets the opacity",
										step = 5, min = 0, max = 100, disabled=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"],
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["7"]["a"]=val/100 vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["7"]["a"]*100 end
										},
									framecolors8 = {
										name = "Color of the 8th 'ComboPoint'", width="double",
										order=180, type = "color", hasAlpha=false, disabled=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"],
										set = function(info,r,g,b)
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["8"]["r"]=r
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["8"]["g"]=g
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["8"]["b"]=b
											vexpower.initialize.core(true) end,
										get = function() return
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["8"]["r"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["8"]["g"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["8"]["b"] end,
										},
									opacity8 = {
										name = "Opacity %",
										order=181, type = "range",
										desc = "Sets the opacity",
										step = 5, min = 0, max = 100, disabled=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"],
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["8"]["a"]=val/100 vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["8"]["a"]*100 end
										},
									framecolors9 = {
										name = "Color of the 9th 'ComboPoint'", width="double",
										order=190, type = "color", hasAlpha=false, disabled=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"],
										set = function(info,r,g,b)
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["9"]["r"]=r
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["9"]["g"]=g
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["9"]["b"]=b
											vexpower.initialize.core(true) end,
										get = function() return
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["9"]["r"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["9"]["g"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["9"]["b"] end,
										},
									opacity9 = {
										name = "Opacity %",
										order=191, type = "range",
										desc = "Sets the opacity",
										step = 5, min = 0, max = 100, disabled=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"],
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["9"]["a"]=val/100 vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["9"]["a"]*100 end
										},
									framecolors10 = {
										name = "Color of the 10th 'ComboPoint'", width="double",
										order=200, type = "color", hasAlpha=false, disabled=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"],
										set = function(info,r,g,b)
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["10"]["r"]=r
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["10"]["g"]=g
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["10"]["b"]=b
											vexpower.initialize.core(true) end,
										get = function() return
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["10"]["r"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["10"]["g"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["10"]["b"] end,
										},
									opacity10 = {
										name = "Opacity %",
										order=201, type = "range",
										desc = "Sets the opacity",
										step = 5, min = 0, max = 100, disabled=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"],
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["10"]["a"]=val/100 vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["10"]["a"]*100 end
										},
									},
								},
								
							set2 = {
								name = "Color sets for individual classes",
								order=10, type ="group", dialogInline = true, hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"]),
								args = {
									
								PALADINprofile = {
									name = "|CFF"..vexpower.data.lib.getColor.classHex("PALADIN").."Paladin|r Color Set",
									order=21, type = "select", style = "dropdown", width="double",
									values = vexpower.options.colorpresets.getList(),
									set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["classPresets"]["PALADIN"] = key vexpower.initialize.core(true) end,
									get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["classPresets"]["PALADIN"] end,
									},
								DRUIDprofile = {
									name = "|CFF"..vexpower.data.lib.getColor.classHex("DRUID").."Druid|r Color Set",
									order=31, type = "select", style = "dropdown", width="double",
									values = vexpower.options.colorpresets.getList(),
									set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["classPresets"]["DRUID"] = key vexpower.initialize.core(true) end,
									get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["classPresets"]["DRUID"] end,
									},
								ROGUEprofile = {
									name = "|CFF"..vexpower.data.lib.getColor.classHex("ROGUE").."Rogue|r Color Set",
									order=41, type = "select", style = "dropdown", width="double",
									values = vexpower.options.colorpresets.getList(),
									set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["classPresets"]["ROGUE"] = key vexpower.initialize.core(true) end,
									get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["classPresets"]["ROGUE"] end,
									},
								MONKprofile = {
									name = "|CFF"..vexpower.data.lib.getColor.classHex("MONK").."Monk|r Color Set",
									order=51, type = "select", style = "dropdown", width="double",
									values = vexpower.options.colorpresets.getList(),
									set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["classPresets"]["MONK"] = key vexpower.initialize.core(true) end,
									get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["classPresets"]["MONK"] end,
									},
								HUNTERprofile = {
									name = "|CFF"..vexpower.data.lib.getColor.classHex("HUNTER").."Hunter|r Color Set",
									order=61, type = "select", style = "dropdown", width="double",
									values = vexpower.options.colorpresets.getList(),
									set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["classPresets"]["HUNTER"] = key vexpower.initialize.core(true) end,
									get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["classPresets"]["HUNTER"] end,
									},
									
								DEATHKNIGHTprofile = {
									name = "|CFF"..vexpower.data.lib.getColor.classHex("DEATHKNIGHT").."Death Knight|r Color Set",
									order=71, type = "select", style = "dropdown", width="double",
									values = {[""] = "runes have been outsorced to |CFFFF7D0AVex Runes|r",}, disabled=true,
									set = function(self,key)  vexpower.initialize.core(true) end,
									get = function() return "" end,
									},
								-- DEATHKNIGHTainfo = {name = "|CFF"..vexpower.data.lib.getColor.classHex("DEATHKNIGHT").."DeathKnight|r runes have been outsorced to |CFFFF7D0AVex Runes|r", type = "description", fontSize="medium", width="full", order=72},
									
								WARRIORprofile = {
									name = "|CFF"..vexpower.data.lib.getColor.classHex("WARRIOR").."Warrior|r Color Set",
									order=81, type = "select", style = "dropdown", width="double",
									values = vexpower.options.colorpresets.getList(),
									set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["classPresets"]["WARRIOR"] = key vexpower.initialize.core(true) end,
									get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["classPresets"]["WARRIOR"] end,
									},
								SHAMANprofile = {
									name = "|CFF"..vexpower.data.lib.getColor.classHex("SHAMAN").."Shaman|r Color Set",
									order=91, type = "select", style = "dropdown", width="double",
									values = vexpower.options.colorpresets.getList(),
									set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["classPresets"]["SHAMAN"] = key vexpower.initialize.core(true) end,
									get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["classPresets"]["SHAMAN"] end,
									},
								PRIESTprofile = {
									name = "|CFF"..vexpower.data.lib.getColor.classHex("PRIEST").."Priest|r Color Set",
									order=101, type = "select", style = "dropdown", width="double",
									values = vexpower.options.colorpresets.getList(),
									set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["classPresets"]["PRIEST"] = key vexpower.initialize.core(true) end,
									get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["classPresets"]["PRIEST"] end,
									},
								WARLOCKprofile = {
									name = "|CFF"..vexpower.data.lib.getColor.classHex("WARLOCK").."Warlock|r Color Set",
									order=111, type = "select", style = "dropdown", width="double",
									values = vexpower.options.colorpresets.getList(),
									set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["classPresets"]["WARLOCK"] = key vexpower.initialize.core(true) end,
									get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["classPresets"]["WARLOCK"] end,
									},
								MAGEprofile = {
									name = "|CFF"..vexpower.data.lib.getColor.classHex("MAGE").."Mage|r Color Set",
									order=121, type = "select", style = "dropdown", width="double",
									values = vexpower.options.colorpresets.getList(),
									set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["classPresets"]["MAGE"] = key vexpower.initialize.core(true) end,
									get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["classPresets"]["MAGE"] end,
									},
									},
								},
							},
						},
					space = {name =" ", type = "description", order=2},	
					grtexture = {
						name = "Texture",
						order=3, type ="group", dialogInline = true,
						args = {
							framebackdrop1 = {
								name = "Background Texture Pack 1",
								order=300, type = "select",
								dialogControl = "LSM30_Background",
								desc = "Sets the frame's background-texture",
								values = vexpower.LSM:HashTable("background"),
								set = function(self,key)
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["texture"]["pack1"]=key
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["texture"]["pack2"]=""
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["texture"]["usePack"]=1
									vexpower.initialize.core(true)
									end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["texture"]["pack1"] end,
								},
								
							framebackdrop2 = {
								name = "Background Texture Pack 2",
								order=300, type = "select",
								dialogControl = "LSM30_Background",
								desc = "Sets the frame's background-texture",
								values = vexpower.LSM:HashTable("statusbar"),
								set = function(self,key)
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["texture"]["pack1"]=""
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["texture"]["pack2"]=key
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["texture"]["usePack"]=2
									vexpower.initialize.core(true)
									end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["texture"]["pack2"] end,
								},
								
							insetsSpace = {name =" ", type = "description", order=1000, hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),},
							grpbackground = {
								name = "Insets",
								order=1001, type ="group", dialogInline = true, hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),
								args = {
									spaceTopS = {name =" ", type = "description", order=1, width="normal",},
									top = {
										name = "Top",
										desc = "Controls how far into the frame the background will be drawn",
										order=2, type = "range",
										step = 1, min = 0, max = 20,
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["insets"]["top"]=val vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["insets"]["top"] end
										},
									spaceTopE = {name =" ", type = "description", order=3, width="normal",},
									left = {
										name = "Left",
										desc = "Controls how far into the frame the background will be drawn",
										order=4, type = "range",
										step = 1, min = 0, max = 20,
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["insets"]["left"]=val vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["insets"]["left"] end
										},
									spaceLeftRight = {name =" ", type = "description", order=5, width="normal",},
									right = {
										name = "Right",
										desc = "Controls how far into the frame the background will be drawn",
										order=6, type = "range",
										step = 1, min = 0, max = 20,
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["insets"]["right"]=val vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["insets"]["right"] end
										},
									spaceBottomS = {name =" ", type = "description", order=7, width="normal",},
									bottom = {
										name = "Bottom",
										desc = "Controls how far into the frame the background will be drawn",
										order=8, type = "range",
										step = 1, min = 0, max = 20,
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["insets"]["bottom"]=val vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["insets"]["bottom"] end
										},
									}
								},
							},
						},
					space2 = {name =" ", type = "description", order=4},	
					grpborder = {
						name = "Border",
						order=5, type ="group", dialogInline = true,
						args = {
							framebackdrop = {
								name = "Border Texture",
								order=1, type = "select",
								dialogControl = "LSM30_Border",
								values = vexpower.LSM:HashTable("border"),
								set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["border"]["texture"]=key vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["border"]["texture"] end,
								},
							framebordercolor = {
								name = "Border color",
								order=2, type = "color", hasAlpha=false,
								set = function(info,r,g,b)
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["border"]["color"]["r"]=r
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["border"]["color"]["g"]=g
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["border"]["color"]["b"]=b
									vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["border"]["color"]["r"],
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["border"]["color"]["g"],
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["border"]["color"]["b"] end,
								},
							opacityborder = {
								name = "Border opacity %",
								order=3, type = "range",
								desc = "Sets the opacity",
								step = 5, min = 0, max = 100,
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["border"]["color"]["a"]=val/100 vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["border"]["color"]["a"]*100 end
								},
							framebordersize = {
								name = "Border size",
								order=4, type = "range",
								desc = "Sets the size of the border",
								step = 1, min = 1, max = 10,
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["border"]["size"]=val vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["border"]["size"] end
								},
							},
						},
					},
				},
				
			grpfadeout = {
				name = "'Used'-Effect",
				order=40, type ="group", dialogInline = true, hidden = not(vexpower.options.cps.openTab["fadeout"]),
				args = {
					info = {name = "ComboPoints that has just been spent will be recolored and then fade out.\n", type = "description", order=1},
					cpusedfadeout = {
						name = "Activate",
						order=200, type = "toggle", width="double",
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["usedEffect"]["activate"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["usedEffect"]["activate"] end,
						},
					framecolorsused = {
						name = "New Color", width="double",
						order=201, type = "color", hasAlpha=false,
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["usedEffect"]["activate"]) or vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"],
						set = function(info,r,g,b)
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["used"]["r"]=r
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["used"]["g"]=g
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["used"]["b"]=b
							vexdebugs.print("r",vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["used"]["r"])
							vexdebugs.print("g",vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["used"]["g"])
							vexdebugs.print("b",vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["used"]["b"])
							vexpower.initialize.core(true) end,
						get = function() return
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["used"]["r"],
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["used"]["g"],
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["used"]["b"] end,
						},
					opacityused = {
						name = "Opacity %",
						order=202, type = "range",
						desc = "Sets the opacity",
						step = 5, min = 0, max = 100,
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["usedEffect"]["activate"]) or vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"],
						set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["used"]["a"]=val/100 vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["used"]["a"]*100 end
						},
					disabledinfo = {name = "You can't change the color because the color is set up in a 'color set'. To change it go to: 'ComboPoints Color Sets'\nor disable the usage of 'color sets' at 'ComboPoints' --> 'Layout' --> 'Load individual color sets for each class instead of one color set for all classes.'.", type = "description", order=203, disabled=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"]},
					},
				},
				
			grpchangeCPsOnX = {
				name = "Recolor",
				order=50, type ="group", dialogInline = true, hidden = not(vexpower.options.cps.openTab["change"]),
				args = {
					changeOnXinfo = {name = "When a specific amount of ComboPoints is reached they get recolored.\n", type="description", order=1},
					activatechange = {
						name = "Activate",
						order=10, type = "toggle", width="normal",
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["activateRecoloring"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["activateRecoloring"] end,
						},
					changex = {
						name = "Threshold for recoloring",
						order=11, type = "range",
						step = 1, min = 1, max = 15,
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["activateRecoloring"]) or vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["changeOnMax"],
						set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["threshold"]=val vexpower.initialize.core(true) end,
						get = function() return tonumber(vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["threshold"]) end
						},
					space = {name = " ", type="description", order=12},
					maxCps = {
						name = "Recolor when ComboPoints are full, instead of when the threshold is reached",
						order=12, type = "toggle", width="full",
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["activateRecoloring"]),
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["changeOnMax"] = key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["changeOnMax"] end,
						},
					space3 = {name = " ", type="description", order=30},
					activatechangeall = {
						name = "Only recolor the ComboPoints needed to reach the threshold, instead of all",
						order=31, type = "toggle", width="full",
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["activateRecoloring"]) or vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["changeOnMax"],
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["changeThresholdOnly"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["changeThresholdOnly"] end,
						},
					framecolorschange = {
						name = "new color", width="double",
						order=40, type = "color", hasAlpha=false,
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["activateRecoloring"]) or vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"],
						set = function(info,r,g,b)
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["change"]["r"]=r
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["change"]["g"]=g
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["change"]["b"]=b
							vexpower.initialize.core(true) end,
						get = function() return
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["change"]["r"],
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["change"]["g"],
							vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["change"]["b"] end,
						},
					opacitychange = {
						name = "Opacity %",
						order=41, type = "range",
						desc = "Sets the opacity",
						step = 5, min = 0, max = 100,
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["activateRecoloring"]) or vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"],
						set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["change"]["a"]=val/100 vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"]["change"]["a"]*100 end
						},
					disabledinfo = {name = "You can't change the color because the color is set up in a 'color set'. To change it go to: 'ComboPoints Color Sets'\nor disable the usage of 'color sets' at 'ComboPoints' --> 'Layout' --> 'Load individual color sets for each class instead of one color set for all classes.'.", type = "description", order=42, disabled=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"]},
					},
				},
				
			grpSoundOnY = {
				name = "Sound Threshold",
				order=60, type ="group", dialogInline = true, hidden = not(vexpower.options.cps.openTab["sound"]),
				args = {
					changeOnXinfo = {name = "Play a sound when a specific amount of ComboPoints is reached.\n", type="description", order=1},
					activate = {
						name = "Activate",
						order=10, type = "toggle", width="full",
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["sound"]["activate"]=key vexpower.initialize.core(true) end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["sound"]["activate"] end,
						},
					space = {name = " ", type="description", order=11},
					changey = {
						name = "Threshold",
						order=20, type = "range",
						step = 1, min = 1, max = 15,
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["sound"]["activate"]),
						set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["sound"]["threshold"] = val end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["sound"]["threshold"] end
						},
					space2 = {name =" ", type = "description", order=21},
					file = {
						name = "Sound",
						order=30, type = "select",
						dialogControl = "LSM30_Sound",
						values = vexpower.LSM:HashTable("sound"),
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["sound"]["activate"]),
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["sound"]["file"] = key end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["sound"]["file"] end,
						},
					channel = {
						name = "Channel",
						order=31, type = "select", style = "dropdown",
						values = {["Master"]="Master", ["SFX"]="SFX", ["Ambience"]="Ambience", ["Music"]="Music"},
						disabled = not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["sound"]["activate"]),
						set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["sound"]["channel"] = key  end,
						get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["sound"]["channel"] end,
						},
					},
				},
				
			grpclassspec = {
				name = "Class-specifics",
				order=70, type ="group", dialogInline = true, hidden = not(vexpower.options.cps.openTab["classspec"]),
				args = {
					grppaladin = {
						name = "|CFF"..vexpower.data.lib.getColor.classHex("PALADIN").."Paladin|r",
						order=1, type ="group", dialogInline = true,
						args = {
							cps = {
								name = "Show HolyPower as ComboPoints",
								order=1, type = "toggle", width="full",
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["paladin"]["cps"]=val vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["paladin"]["cps"] end,
								},
							},
						},
					grpdruid = {
						name = "|CFF"..vexpower.data.lib.getColor.classHex("DRUID").."Druid|r",
						order=2, type ="group", dialogInline = true,
						args = {
							cps = {
								name = "Show ComboPoints",
								order=1, type = "toggle", width="full",
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["druid"]["cps"]=val vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["druid"]["cps"] end,
								},
							keepCPShown = {
								name = "Keep ComboPoints shown when no target is set",
								order=2, type = "toggle", width="full",
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["druid"]["keepCPShown"]=val vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["druid"]["keepCPShown"] end,
								},
							},
						},
					grprogue = {
						name = "|CFF"..vexpower.data.lib.getColor.classHex("ROGUE").."Rogue|r",
						order=3, type ="group", dialogInline = true,
						args = {
							cps = {
								name = "Show ComboPoints",
								order=1, type = "toggle", width="full",
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["rogue"]["cps"]=val vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["rogue"]["cps"] end,
								},
							keepCPShown = {
								name = "Keep ComboPoints shown when no target is set",
								order=2, type = "toggle", width="full",
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["rogue"]["keepCPShown"]=val vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["rogue"]["keepCPShown"] end,
								},
							grpanticipation = {
								name = "Anticipation",
								order=3, type ="group", dialogInline = true,
								args = {
									anticipation = {
										name = "Show Anticipation as additional ComboPoints",
										order=1, type = "toggle", width="full",
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["rogue"]["anticipation"]=val vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["rogue"]["anticipation"] end,
										},
									anticipationin2ndRow = {
										name = "Show in a 2nd row (only works with 'intelligent mode')",
										order=2, type = "toggle", width="full", disabled=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["rogue"]["anticipation"]),
										set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["rogue"]["anti2ndRow"]=val vexpower.initialize.core(true) end,
										get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["rogue"]["anti2ndRow"] end,
										},
									info = {name ="The 2nd row setup can be found at 'ComboPoints' --> 'Position & Size'", type = "description", order=3},
									}
								}
							},
						},
					grpmonk = {
						name = "|CFF"..vexpower.data.lib.getColor.classHex("MONK").."Monk|r",
						order=4, type ="group", dialogInline = true,
						args = {
							cps = {
								name = "Show Chi as ComboPoints",
								order=1, type = "toggle", width="full",
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["monk"]["cps"]=val vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["monk"]["cps"] end,
								},
							},
						},
					grphunter = {
						name = "|CFF"..vexpower.data.lib.getColor.classHex("HUNTER").."Hunter|r",
						order=5, type ="group", dialogInline = true,
						args = {
							-- mm = {
								-- name = "Marksman: Show 'Ready, Set, Aim ...'-Stacks and 'Fire!'-Buff as ComboPoints",
								-- order=1, type = "toggle", width="full",
								-- set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["hunter"]["mm"]=val vexpower.initialize.core(true) end,
								-- get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["hunter"]["mm"] end,
								-- },
							bm = {
								name = "Beastmaster: Show 'Frenzy'-Stacks as ComboPoints",
								order=2, type = "toggle", width="full",
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["hunter"]["bm"]=val vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["hunter"]["bm"] end,
								},
							},
						},
					grpwarrior = {
						name = "|CFF"..vexpower.data.lib.getColor.classHex("WARRIOR").."Warrior|r",
						order=6, type ="group", dialogInline = true,
						args = {
							cps = {
								name = "Fury: Show 'Raging Blow'-Stacks as ComboPoints",
								order=1, type = "toggle", width="full",
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["warrior"]["fury"]=val vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["warrior"]["fury"] end,
								},
							},
						},
					grpshaman = {
						name = "|CFF"..vexpower.data.lib.getColor.classHex("SHAMAN").."Shaman|r",
						order=7, type ="group", dialogInline = true,
						args = {
							cps = {
								name = "Enhancer: Show 'Maelstrom Weapon'-Stacks as ComboPoints",
								order=1, type = "toggle", width="full",
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["shaman"]["enhancer"]=val vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["shaman"]["enhancer"] end,
								},
							},
						},
					grppriest = {
						name = "|CFF"..vexpower.data.lib.getColor.classHex("PRIEST").."Priest|r ",
						order=8, type ="group", dialogInline = true,
						args = {
							shadow = {
								name = "Shadow: Show Shadow Orbs as ComboPoints",
								order=1, type = "toggle", width="full",
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["priest"]["shadow"]=val vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["priest"]["shadow"] end,
								},
							disci = {
								name = "Discipline: Show 'Evangelism'-Stacks as ComboPoints",
								order=2, type = "toggle", width="full",
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["priest"]["disci"]=val vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["priest"]["disci"] end,
								},
							},
						},
					grpwarlock = {
						name = "|CFF"..vexpower.data.lib.getColor.classHex("WARLOCK").."Warlock|r",
						order=9, type ="group", dialogInline = true,
						args = {
							affli = {
								name = "Affliction: Show Soul Shards as ComboPoints",
								order=1, type = "toggle", width="full",
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["warlock"]["affli"]=val vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["warlock"]["affli"] end,
								},
							demo = {
								name = "Demonology: Show Demonic Fury as ComboPoints",
								order=2, type = "toggle", width="full",
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["warlock"]["demo"]=val vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["warlock"]["demo"] end,
								},
							destro = {
								name = "Destruction: Show Burning Embers as ComboPoints",
								order=3, type = "toggle", width="full",
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["warlock"]["destro"]=val vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["warlock"]["destro"] end,
								},
							},
						},
					grpmage = {
						name = "|CFF"..vexpower.data.lib.getColor.classHex("MAGE").."Mage|r",
						order=10, type ="group", dialogInline = true,
						args = {
							cps = {
								name = "Arcane: Show 'Arcane Charge'-Stacks as ComboPoints",
								order=1, type = "toggle", width="full",
								set = function(info,val) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["mage"]["arcane"]=val vexpower.initialize.core(true) end,
								get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["mage"]["arcane"] end,
								},
							},
						},
					},
				},
			}
		}
end





