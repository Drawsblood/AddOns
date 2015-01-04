function vexpower.options.text.panel()
	if vexpower.options.text.currentTextfield == "" then
		vexpower.options.text.currentTextfield = vexpower.options.text.getFirst()
	end
	local tagvalues = {
		["PowerCurrent"] = "|CFFFF7D0APowerCurrent|r",
		["PowerCurrentShort"] = "|CFFFF7D0APowerCurrentShort|r",
		["PowerCurrentSmart"] = "|CFFFF7D0APowerCurrentSmart|r",
		
		["PowerMax"] = "|CFFFF7D0APowerMax|r",
		["PowerMaxShort"] = "|CFFFF7D0APowerMaxShort|r",
		["PowerMaxSmart"] = "|CFFFF7D0APowerMaxSmart|r",
		
		["PowerMissing"] = "|CFFFF7D0APowerMissing|r",
		["PowerMissingShort"] = "|CFFFF7D0APowerMissingShort|r",
		["PowerMissingSmart"] = "|CFFFF7D0APowerMissingSmart|r",
		
		["PowerPerc"] = "|CFFFF7D0APowerPerc|r",
		["PowerPercSmart"] = "|CFFFF7D0APowerPercSmart|r",
		
		["TimeTotal"] = "|CFFFF7D0ATimeTotal|r",
		["TimeLeft"] = "|CFFFF7D0ATimeLeft|r",
		["TimeLeftShort"] = "|CFFFF7D0ATimeLeftShort|r",
		
		["CPsCurrent"] = "|CFFFF7D0ACPsCurrent|r",
		["CPsMax"] = "|CFFFF7D0ACPsMax|r",
		["CPsMissing"] = "|CFFFF7D0ACPsMissing|r",
		
		["PowerAltCurrent"] = "|CFFFFCC00PowerAltCurrent|r",
		["PowerAltMax"] = "|CFFFFCC00PowerAltMax|r",
		}

	return {
		type = "group",
		order= 3,
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
			
			edit = {
				name = "Textfield",
				order=5, type ="group", dialogInline = true,
				args = {
					profile = {
						name = "Textfields",
						order=1, type = "select", style = "dropdown", width="half",
						values = vexpower.options.text.getList(),
						set = function(self,val) vexpower.options.text.currentTextfield = val vexpower.initialize.core(true) end,
						get = function() return vexpower.options.text.currentTextfield end,
						},
					new = {
						name = "create new",
						order=2, type = "execute", width="normal",
						func = function(info,val) vexpower.options.text.create() vexpower.initialize.core(true) end,
						},
					clone = {
						name = "create clone",
						order=3, type = "execute", width="normal",
						func = function(info,val) vexpower.options.text.clone() vexpower.initialize.core(true) end,
						},
					delete = {
						name = "delete",
						order=4, type = "execute", width="half",
						func = function(info,val) vexpower.options.text.delete() vexpower.initialize.core(true) end,
						confirm = true,
						confirmText = "Are you sure you want to delete the textfield?"
						},
					status = {name = vexpower.options.text.statusMsg.."\n", type = "description", order=5},
					
					grpoptiontabs = {
						name = "Toggle Option Tabs",
						order=6, type ="group", dialogInline = true,
						args = {
							button_position = {
								name = "Position & Size",
								order=1, type = "execute", width="normal",
								func = function(info,val) vexpower.options.text.toggleTab("position") vexpower.initialize.core(true) end,
								},
							button_content = {
								name = "Content",
								order=2, type = "execute", width="half",
								func = function(info,val) vexpower.options.text.toggleTab("content") vexpower.initialize.core(true) end,
								},
							button_Format = {
								name = "Format",
								order=3, type = "execute", width="half",
								func = function(info,val) vexpower.options.text.toggleTab("format") vexpower.initialize.core(true) end,
								},
							button_shadow = {
								name = "Shadow",
								order=5, type = "execute", width="half", hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),
								func = function(info,val) vexpower.options.text.toggleTab("shadow") vexpower.initialize.core(true) end,
								},
							spaceoptiontabs = {name =" ", type = "description", order=7},
										
							content = {
								name = "Content",
								order=10, type ="group", dialogInline = true, hidden = not(vexpower.options.text.openTab["content"]),
								args = {
									framelefttextcontent = {
										name = "Text",
										desc = "Text that is shown left", width="full",
										order=1, type = "input", multiline = false,
										disabled = vexpower.options.text.getDisabled(),
										set = function(info,val) vexpower.options.text.setdataDirect("text", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.text.getdataDirect("text") end
										},
									frameleftinserttag = {
										name = "Insert Tag",
										order=2, type = "select", style = "dropdown",
										values = tagvalues,
										disabled = vexpower.options.text.getDisabled(),
										set = function(self,val) vexpower.options.text.insertTag("left", val) vexpower.initialize.core(true) end,
										get = function() return "" end,
										},
									help = {
										name = "tag info",
										order=3, type = "execute",
										func = function(info,val) vexpower.options.tagWindow.toggle() end,
										},
									space = {name = " ", type="description", width="full", order=10},
									partof = {
										name = "Bar Relation",
										order=11, type = "select", style = "dropdown",
										values = {["POWERBAR"]="PowerBar",
													["CPSBAR"]="ComboPointBar"},
										disabled = vexpower.options.text.getDisabled(),
										set = function(self,val) vexpower.options.text.setdataDirect("cptext", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.text.getdataDirect("cptext") end,
										},
									info = {name = "The bar relation is important for the show and hide effects. When a bar becomes hidden all textfields related to that bar become hidden, too.", type="description", width="full", order=12},
									},
								},
										
							Format = {
								name = "Format",
								order=20, type ="group", dialogInline = true, hidden = not(vexpower.options.text.openTab["format"]),
								args = {
									font = {
										name = "Font",
										order=100, type = "select",
										dialogControl = "LSM30_Font",
										disabled = vexpower.options.text.getDisabled(),
										values = vexpower.LSM:HashTable("font"),
										set = function(self,val) vexpower.options.text.setdataDirect("font", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.text.getdataDirect("font") end,
										},
									size = {
										name = "Size",
										order=101, type = "range",
										step = 1, min = 6, max = 20,
										disabled = vexpower.options.text.getDisabled(),
										set = function(info,val) vexpower.options.text.setdataDirect("size", val) vexpower.initialize.core(true) vexpower.testmode.textHandler() end,
										get = function() return vexpower.options.text.getdataDirect("size") end,
										},
									color = {
										name = "color",
										order=102, type = "color", hasAlpha=true,
										desc = "Sets the text color",
										disabled = vexpower.options.text.getDisabled(),
										set = function(info,r,g,b,a)
											vexpower.options.text.setDataColor("r", r)
											vexpower.options.text.setDataColor("g", g)
											vexpower.options.text.setDataColor("b", b)
											vexpower.options.text.setDataColor("a", a)
											vexpower.initialize.core(true) end,
										get = function() return
											vexpower.options.text.getDataColor("r"),
											vexpower.options.text.getDataColor("g"),
											vexpower.options.text.getDataColor("b"),
											vexpower.options.text.getDataColor("a") end,
										},
									align = {
										name = "Text align",
										order=103, type = "select", style = "dropdown",
										desc = "Sets the text align",
										disabled = vexpower.options.text.getDisabled(),
										values = {["LEFT"]="Left", ["CENTER"]="Center", ["RIGHT"]="Right"},
										set = function(self,val) vexpower.options.text.setdataDirect("align", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.text.getdataDirect("align") end,
										},
									effect = {
										name = "effect",
										order=104, type = "select", style = "dropdown", hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),
										values = {["MONOCHROME"]="Monochrome",
													["OUTLINE"]="Outline",
													[""]="None",
													["THICKOUTLINE"]="Thickoutline"},
										disabled = vexpower.options.text.getDisabled(),
										set = function(self,val) vexpower.options.text.setdataDirect("effect", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.text.getdataDirect("effect") end,
										},
									},
								},
										
							poistion = {
								name = "Position & Size",
								order=30, type ="group", dialogInline = true, hidden = not(vexpower.options.text.openTab["position"]),
								args = {
									x = {
										name = "X Position",
										order=1, type = "range",
										step = 1, min = -300, max = 300,
										disabled = vexpower.options.text.getDisabled(),
										set = function(info,val) vexpower.options.text.setdataDirect("x", val) vexpower.initialize.core(true) vexpower.testmode.textHandler() end,
										get = function() return vexpower.options.text.getdataDirect("x") end
										},
									y = {
										name = "Y Position",
										order=2, type = "range",
										step = 1, min = -300, max = 300,
										disabled = vexpower.options.text.getDisabled(),
										set = function(info,val) vexpower.options.text.setdataDirect("y", val) vexpower.initialize.core(true) vexpower.testmode.textHandler() end,
										get = function() return vexpower.options.text.getdataDirect("y") end
										},
									space1 = {name = " ", type="description", order=10},
									anchor = {
										name = "Anchor Textfield",
										order=11, type = "select", style = "dropdown", hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),
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
										disabled = vexpower.options.text.getDisabled(),
										set = function(self,val) vexpower.options.text.setdataDirect("anchor", val) vexpower.initialize.core(true) vexpower.testmode.textHandler() end,
										get = function() return vexpower.options.text.getdataDirect("anchor") end,
										},
									anchor2 = {
										name = "Anchor Powerbar",
										order=12, type = "select", style = "dropdown", hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),
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
										disabled = vexpower.options.text.getDisabled(),
										set = function(self,val) vexpower.options.text.setdataDirect("anchor2", val) vexpower.initialize.core(true) vexpower.testmode.textHandler() end,
										get = function() return vexpower.options.text.getdataDirect("anchor2") end,
										},
									space2 = {name = " ", type="description", order=13},
									width = {
										name = "Width",
										order=14, type = "range",
										step = 1, min = 1, max = 400, hidden=not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["advancedOptions"]),
										disabled = vexpower.options.text.getDisabled(),
										set = function(info,val) vexpower.options.text.setdataDirect("width", val) vexpower.initialize.core(true) vexpower.testmode.textHandler() end,
										get = function() return vexpower.options.text.getdataDirect("width") end
										},
									},
								},
										
							shadow = {
								name = "Shadow-Effect",
								order=40, type ="group", dialogInline = true, hidden = not(vexpower.options.text.openTab["shadow"]),
								args = {
									allow = {
										name = "Activate shadow effect",
										order=1, type = "toggle", width="full",
										desc = "",
										disabled = vexpower.options.text.getDisabled(),
										set = function(self,val) vexpower.options.text.setDataShadow(false, "allow", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.text.getDataShadow(false, "allow") end,
										},
									color = {
										name = "color",
										disabled = not(vexpower.options.text.getDataShadow(false, "allow")) or vexpower.options.text.getDisabled(),
										order=2, type = "color", hasAlpha=true, width="double",
										set = function(info,r,g,b,a)
											vexpower.options.text.setDataShadow("color", "r", r)
											vexpower.options.text.setDataShadow("color", "g", g)
											vexpower.options.text.setDataShadow("color", "b", b)
											vexpower.options.text.setDataShadow("color", "a", a)
											vexpower.initialize.core(true) end,
										get = function() return
											vexpower.options.text.getDataShadow("color", "r"),
											vexpower.options.text.getDataShadow("color", "g"),
											vexpower.options.text.getDataShadow("color", "b"),
											vexpower.options.text.getDataShadow("color", "a") end,
										},
									opacity = {
										name = "Opacity %",
										order=3, type = "range",
										step = 5, min = 0, max = 100,
										disabled = not(vexpower.options.text.getDataShadow(false, "allow")) or vexpower.options.text.getDisabled(),
										set = function(info,val) vexpower.options.text.setDataShadow("color", "a", val/100) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.text.getDataShadow("color", "a") end
										},
									x = {
										name = "X Position",
										order=4, type = "range",
										step = 1, min = -50, max = 50,
										disabled = not(vexpower.options.text.getDataShadow(false, "allow")) or vexpower.options.text.getDisabled(),
										set = function(info,val) vexpower.options.text.setDataShadow("offset", "x", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.text.getDataShadow("offset", "x") end
										},
									y = {
										name = "Y Position",
										order=5, type = "range",
										step = 1, min = -50, max = 50,
										disabled = not(vexpower.options.text.getDataShadow(false, "allow")) or vexpower.options.text.getDisabled(),
										set = function(info,val) vexpower.options.text.setDataShadow("offset", "y", val) vexpower.initialize.core(true) end,
										get = function() return vexpower.options.text.getDataShadow("offset", "y") end
										},
									},
								},
							},
						},
					}
				}
			}
		}
end