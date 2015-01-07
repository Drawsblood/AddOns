--[[
##############################################################################
_____/\\\\\\\\\\\____/\\\________/\\\__/\\\________/\\\__/\\\\\\\\\\\_       #
 ___/\\\/////////\\\_\/\\\_______\/\\\_\/\\\_______\/\\\_\/////\\\///__      #
  __\//\\\______\///__\//\\\______/\\\__\/\\\_______\/\\\_____\/\\\_____     #
   ___\////\\\__________\//\\\____/\\\___\/\\\_______\/\\\_____\/\\\_____    #
    ______\////\\\________\//\\\__/\\\____\/\\\_______\/\\\_____\/\\\_____   #
     _________\////\\\______\//\\\/\\\_____\/\\\_______\/\\\_____\/\\\_____  #
      __/\\\______\//\\\______\//\\\\\______\//\\\______/\\\______\/\\\_____ #
       _\///\\\\\\\\\\\/________\//\\\________\///\\\\\\\\\/____/\\\\\\\\\\\_#
        ___\///////////___________\///___________\/////////_____\///////////_#
##############################################################################
S U P E R - V I L L A I N - U I   By: Munglunch                              #
##############################################################################
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack 	 =  _G.unpack;
local pairs 	 =  _G.pairs;
local tinsert 	 =  _G.tinsert;
local table 	 =  _G.table;
--[[ TABLE METHODS ]]--
local tsort = table.sort;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = _G["SVUI"];
local L = SV.L;
local MOD = SV.SVUnit
if(not MOD) then return end 
local _, ns = ...

SV.Options.args.SVUnit.args.commonGroup.args["raid"] = {
	name = "Raid", 
	type = "group", 
	order = 12, 
	childGroups = "select", 
	get = function(l) return SV.db.SVUnit["raid"][l[#l]] end, 
	set = function(l, m) MOD:ChangeDBVar(m, l[#l], "raid"); MOD:SetGroupFrame("raid") end, 
	args = {
		enable = {
			type = "toggle", 
			order = 1, 
			name = L["Enable"], 
		}, 
		configureToggle = {
			order = 2, 
			type = "execute", 
			name = L["Display Frames"], 
			func = function() 
				local setForced = (_G["SVUI_Raid"].forceShow ~= true) or nil; 
				MOD:ViewGroupFrames(_G["SVUI_Raid"], setForced) 
			end, 
		}, 
		resetSettings = {
			type = "execute", 
			order = 3, 
			name = L["Restore Defaults"], 
			func = function(l, m)MOD:ResetUnitOptions("raid") SV.Mentalo:Reset("Raid Frames") end, 
		}, 
		spacer1 = {
			order = 4, 
			name = "", 
			type = "description", 
			width = "full", 
		},
		spacer2 = {
			order = 5, 
			name = "", 
			type = "description", 
			width = "full", 
		},
		general = {
			order = 6, 
			type = "group", 
			name = L["General Settings"], 
			args = {
				commonGroup = {
					order = 1, 
					name = L["Basic Options"], 
					type = "group", 
					guiInline = true,
					args = {
						rangeCheck = {
							order = 1,
							type = "toggle", 
							name = L["Range Check"], 
							desc = L["Check if you are in range to cast spells on this specific unit."],  
						},
						predict = {
							order = 2,
							type = "toggle", 
							name = L["Heal Prediction"], 
							desc = L["Show a incomming heal prediction bar on the unitframe. Also display a slightly different colored bar for incoming overheals."], 
						}, 
						threatEnabled = {
							order = 3,
							type = "toggle", 
							name = L["Show Threat"], 
						}, 
					}
				},
				layoutGroup = {
					order = 2, 
					name = L["Layout Options"], 
					type = "group", 
					guiInline = true, 
					set = function(key, value) MOD:ChangeDBVar(value, key[#key], "raid"); MOD:SetGroupFrame("raid", true) end, 
					args = {
						common = {
							order = 1, 
							name = L["General Layout"], 
							type = "group", 
							guiInline = true, 
							args = {
								enable = {
									order = 1, 
									name = L["Enable Grid Mode"], 
									desc = L["Converts frames into symmetrical squares. Ideal for healers."], 
									type = "toggle",
									get = function(key) return SV.db.SVUnit["raid"].grid.enable end,
									set = function(key, value) 
										MOD:ChangeDBVar(value, key[#key], "raid", "grid"); 
										MOD:SetGroupFrame("raid", true);
										SV.Options.args.SVUnit.args.commonGroup.args.raid.args.general.args.layoutGroup.args.sizing = ns:SetSizeConfigGroup(value, "raid");
									end,
								},
								showPlayer = {
									order = 2, 
									type = "toggle", 
									name = L["Display Player"], 
									desc = L["When true, always show player in raid frames."],
									get = function(l)return SV.db.SVUnit["raid"].showPlayer end, 
									set = function(l, m) MOD:ChangeDBVar(m, l[#l], "raid"); MOD:SetGroupFrame("raid", true) end, 
								},
								invertGroupingOrder = {
									order = 3,
									type = "toggle",
									name = L["Invert Grouping Order"], 
									desc = L["Enabling this inverts the grouping order when the raid is not full, this will reverse the direction it starts from."], 
									disabled = function() return not SV.db.SVUnit["raid"].customSorting end,  
								},
							}
						},
						sizing = ns:SetSizeConfigGroup(SV.db.SVUnit.raid.grid.enable, "raid"),
						sorting = {
							order = 3, 
							name = L["Sorting"], 
							type = "group", 
							guiInline = true, 
							args = {
								gRowCol = {
									order = 1, 
									type = "range", 
									name = L["Groups Per Row / Column"], 
									min = 1, 
									max = 8, 
									step = 1, 
									width = 'full',
									set = function(key, value)
										MOD:ChangeDBVar(value, key[#key], "raid");
										MOD:SetGroupFrame("raid")
										if(_G["SVUI_Raid"] and _G["SVUI_Raid"].isForced) then	
											MOD:ViewGroupFrames(_G["SVUI_Raid"])
											MOD:ViewGroupFrames(_G["SVUI_Raid"], true)
										end
									end, 
								},
								showBy = {
									order = 2, 
									name = L["Growth Direction"], 
									desc = L["Growth direction from the first unitframe."], 
									type = "select", 
									values = {
										DOWN_RIGHT = format(L["%s and then %s"], L["Down"], L["Right"]), 
										DOWN_LEFT = format(L["%s and then %s"], L["Down"], L["Left"]), 
										UP_RIGHT = format(L["%s and then %s"], L["Up"], L["Right"]), 
										UP_LEFT = format(L["%s and then %s"], L["Up"], L["Left"]), 
										RIGHT_DOWN = format(L["%s and then %s"], L["Right"], L["Down"]), 
										RIGHT_UP = format(L["%s and then %s"], L["Right"], L["Up"]), 
										LEFT_DOWN = format(L["%s and then %s"], L["Left"], L["Down"]), 
										LEFT_UP = format(L["%s and then %s"], L["Left"], L["Up"]), 
									}, 
								}, 
								sortMethod = {
									order = 3, 
									name = L["Group By"], 
									desc = L["Set the order that the group will sort."], 
									type = "select", 
									values = {
										["CLASS"] = CLASS, 
										["ROLE"] = ROLE.."(Tanks, Healers, DPS)", 
										["ROLE_TDH"] = ROLE.."(Tanks, DPS, Healers)", 
										["ROLE_HDT"] = ROLE.."(Healers, DPS, Tanks)", 
										["ROLE_HTD"] = ROLE.."(Healers, Tanks, DPS)", 
										["NAME"] = NAME, 
										["MTMA"] = L["Main Tanks  /  Main Assist"], 
										["GROUP"] = GROUP, 
									}, 
								}, 
								sortDir = {
									order = 4, 
									name = L["Sort Direction"], 
									desc = L["Defines the sort order of the selected sort method."], 
									type = "select", 
									values = {
										["ASC"] = L["Ascending"], 
										["DESC"] = L["Descending"], 
									}, 
								},
								spacer3 = {
									order = 5, 
									type = "description", 
									width = "full", 
									name = " ", 
								},
								allowedGroup = {
									order = 6, 
									name = L["Enabled Groups"], 
									type = "group", 
									guiInline = true, 
									args = {
										showGroupNumber = {
											type = "toggle", 
											order = 1, 
											name = L["Show Group Number Icons"],
											width = 'full',
										},
										one = {
											type = "toggle", 
											order = 2, 
											name = L["Group 1"],
											get = function(key) return SV.db.SVUnit["raid"]["allowedGroup"][1] end, 
											set = function(key, value) 
												SV.db.SVUnit["raid"]["allowedGroup"][1] = value; 
												MOD:SetGroupFrame("raid")
											end, 
										},
										two = {
											type = "toggle", 
											order = 3, 
											name = L["Group 2"],
											get = function(key) return SV.db.SVUnit["raid"]["allowedGroup"][2] end, 
											set = function(key, value) 
												SV.db.SVUnit["raid"]["allowedGroup"][2] = value; 
												MOD:SetGroupFrame("raid")
											end, 
										},
										three = {
											type = "toggle", 
											order = 4, 
											name = L["Group 3"],
											get = function(key) return SV.db.SVUnit["raid"]["allowedGroup"][3] end, 
											set = function(key, value) 
												SV.db.SVUnit["raid"]["allowedGroup"][3] = value; 
												MOD:SetGroupFrame("raid")
											end, 
										},
										four = {
											type = "toggle", 
											order = 5, 
											name = L["Group 4"],
											get = function(key) return SV.db.SVUnit["raid"]["allowedGroup"][4] end, 
											set = function(key, value) 
												SV.db.SVUnit["raid"]["allowedGroup"][4] = value; 
												MOD:SetGroupFrame("raid")
											end, 
										},
										five = {
											type = "toggle", 
											order = 6, 
											name = L["Group 5"],
											get = function(key) return SV.db.SVUnit["raid"]["allowedGroup"][5] end, 
											set = function(key, value) 
												SV.db.SVUnit["raid"]["allowedGroup"][5] = value; 
												MOD:SetGroupFrame("raid")
											end, 
										},
										six = {
											type = "toggle", 
											order = 7, 
											name = L["Group 6"],
											get = function(key) return SV.db.SVUnit["raid"]["allowedGroup"][6] end, 
											set = function(key, value) 
												SV.db.SVUnit["raid"]["allowedGroup"][6] = value; 
												MOD:SetGroupFrame("raid")
											end, 
										},
										seven = {
											type = "toggle", 
											order = 8, 
											name = L["Group 7"],
											get = function(key) return SV.db.SVUnit["raid"]["allowedGroup"][7] end, 
											set = function(key, value) 
												SV.db.SVUnit["raid"]["allowedGroup"][7] = value; 
												MOD:SetGroupFrame("raid")
											end, 
										},
										eight = {
											type = "toggle", 
											order = 9, 
											name = L["Group 8"],
											get = function(key) return SV.db.SVUnit["raid"]["allowedGroup"][8] end, 
											set = function(key, value) 
												SV.db.SVUnit["raid"]["allowedGroup"][8] = value; 
												MOD:SetGroupFrame("raid")
											end, 
										},
									}, 
								},
							}
						}
					}, 
				},
			}
		}, 
		misc = ns:SetMiscConfigGroup(true, MOD.SetGroupFrame, "raid"), 
		health = ns:SetHealthConfigGroup(true, MOD.SetGroupFrame, "raid"), 
		power = ns:SetPowerConfigGroup(false, MOD.SetGroupFrame, "raid"), 
		name = ns:SetNameConfigGroup(MOD.SetGroupFrame, "raid"), 
		buffs = ns:SetAuraConfigGroup(true, "buffs", true, MOD.SetGroupFrame, "raid"), 
		debuffs = ns:SetAuraConfigGroup(true, "debuffs", true, MOD.SetGroupFrame, "raid"), 
		auraWatch = {
			order = 600, 
			type = "group", 
			name = L["Aura Watch"], 
			args = {
				enable = {
					type = "toggle", 
					name = L["Enable"], 
					order = 1,
					get = function(l)return SV.db.SVUnit["raid"].auraWatch.enable end, 
					set = function(l, m)MOD:ChangeDBVar(m, "enable", "raid", "auraWatch");MOD:SetGroupFrame("raid")end, 
				}, 
				size = {
					type = "range", 
					name = L["Size"], 
					desc = L["Size of the indicator icon."], 
					order = 2, 
					min = 4, 
					max = 15, 
					step = 1,
					get = function(l)return SV.db.SVUnit["raid"].auraWatch.size end, 
					set = function(l, m)MOD:ChangeDBVar(m, "size", "raid", "auraWatch");MOD:SetGroupFrame("raid")end, 
				}, 
				configureButton = {
					type = "execute", 
					name = L["Configure Auras"], 
					func = function()ns:SetToFilterConfig("BuffWatch")end, 
					order = 3, 
				}, 

			}, 
		}, 
		rdebuffs = {
			order = 800, 
			type = "group", 
			name = L["RaidDebuff Indicator"], 
			get = function(l)return
			SV.db.SVUnit["raid"]["rdebuffs"][l[#l]]end, 
			set = function(l, m)MOD:ChangeDBVar(m, l[#l], "raid", "rdebuffs");MOD:SetGroupFrame("raid")end, 
			args = {
				enable = {
					type = "toggle", 
					name = L["Enable"], 
					order = 1, 
				}, 
				size = {
					type = "range", 
					name = L["Size"], 
					order = 2, 
					min = 8, 
					max = 35, 
					step = 1, 
				}, 
				fontSize = {
					type = "range", 
					name = L["Font Size"], 
					order = 3, 
					min = 7, 
					max = 22, 
					step = 1, 
				}, 
				xOffset = {
					order = 4, 
					type = "range", 
					name = L["xOffset"], 
					min =  - 300, 
					max = 300, 
					step = 1, 
				}, 
				yOffset = {
					order = 5, 
					type = "range", 
					name = L["yOffset"], 
					min =  - 300, 
					max = 300, 
					step = 1, 
				}, 
				configureButton = {
					type = "execute", 
					name = L["Configure Auras"], 
					func = function()ns:SetToFilterConfig("Raid")end, 
					order = 7, 
				}, 
			}, 
		}, 
		icons = ns:SetIconConfigGroup(MOD.SetGroupFrame, "raid"), 
	}, 
}

SV.Options.args.SVUnit.args.commonGroup.args.raidpet = {
	order = 13,
	type = 'group',
	name = L['Raid Pets'],
	childGroups = "select",
	get = function(l) return SV.db.SVUnit['raidpet'][l[#l]] end,
	set = function(l, m) MOD:ChangeDBVar(m, l[#l], "raidpet"); MOD:SetGroupFrame('raidpet'); end,
	args = {
		enable = {
			type = 'toggle',
			order = 1,
			name = L['Enable'],
		},
		configureToggle = {
			order = 2,
			type = 'execute',
			name = L['Display Frames'],
			func = function() MOD:ViewGroupFrames(SVUI_Raidpet, SVUI_Raidpet.forceShow ~= true or nil); end,
		},
		resetSettings = {
			type = 'execute',
			order = 3,
			name = L['Restore Defaults'],
			func = function(l, m) MOD:ResetUnitOptions('raidpet'); SV.Mentalo:Reset('Raid Pet Frames'); MOD:SetGroupFrame('raidpet', true); end,
		},
		spacer1 = {
			order = 4, 
			name = "", 
			type = "description", 
			width = "full", 
		},
		spacer2 = {
			order = 5, 
			name = "", 
			type = "description", 
			width = "full", 
		},
		general = {
			order = 6, 
			type = "group", 
			name = L["General Settings"], 
			args = {
				commonGroup = {
					order = 1, 
					name = L["Basic Options"], 
					type = "group", 
					guiInline = true,
					args = {
						rangeCheck = {
							order = 1,
							type = "toggle", 
							name = L["Range Check"], 
							desc = L["Check if you are in range to cast spells on this specific unit."],  
						},
						predict = {
							order = 2,
							type = "toggle", 
							name = L["Heal Prediction"], 
							desc = L["Show a incomming heal prediction bar on the unitframe. Also display a slightly different colored bar for incoming overheals."], 
						}, 
						threatEnabled = {
							order = 3,
							type = "toggle", 
							name = L["Show Threat"], 
						}, 
					}
				},
				layoutGroup = {
					order = 2, 
					name = L["Layout Options"], 
					type = "group", 
					guiInline = true, 
					set = function(key, value) MOD:ChangeDBVar(value, key[#key], "raidpet"); MOD:SetGroupFrame("raidpet", true) end, 
					args = {
						common = {
							order = 1, 
							name = L["General Layout"], 
							type = "group", 
							guiInline = true, 
							args = {
								enable = {
									order = 1, 
									name = L["Enable Grid Mode"], 
									desc = L["Converts frames into symmetrical squares. Ideal for healers."], 
									type = "toggle",
									get = function(key) return SV.db.SVUnit["raidpet"].grid.enable end,
									set = function(key, value) 
										MOD:ChangeDBVar(value, key[#key], "raidpet", "grid"); 
										MOD:SetGroupFrame("raidpet", true);
										SV.Options.args.SVUnit.args.commonGroup.args.raidpet.args.general.args.layoutGroup.args.sizing = ns:SetSizeConfigGroup(value, "raidpet");
									end,
								},
								invertGroupingOrder = {
									order = 2,
									type = "toggle",
									name = L["Invert Grouping Order"], 
									desc = L["Enabling this inverts the grouping order."], 
									disabled = function() return not SV.db.SVUnit["raidpet"].customSorting end,  
								},
							}
						},
						sizing = ns:SetSizeConfigGroup(SV.db.SVUnit.raidpet.grid.enable, "raidpet"),
						sorting = {
							order = 3, 
							name = L["Sorting"], 
							type = "group", 
							guiInline = true, 
							args = {
								gRowCol = {
									order = 1, 
									type = "range", 
									name = L["Groups Per Row / Column"], 
									min = 1, 
									max = 8, 
									step = 1, 
									width = 'full',
									set = function(key, value)
										MOD:ChangeDBVar(value, key[#key], "raidpet");
										MOD:SetGroupFrame("raidpet")
										if(_G["SVUI_Raid"] and _G["SVUI_Raid"].isForced) then	
											MOD:ViewGroupFrames(_G["SVUI_Raid"])
											MOD:ViewGroupFrames(_G["SVUI_Raid"], true)
										end
									end, 
								},
								showBy = {
									order = 2, 
									name = L["Growth Direction"], 
									desc = L["Growth direction from the first unitframe."], 
									type = "select", 
									values = {
										DOWN_RIGHT = format(L["%s and then %s"], L["Down"], L["Right"]), 
										DOWN_LEFT = format(L["%s and then %s"], L["Down"], L["Left"]), 
										UP_RIGHT = format(L["%s and then %s"], L["Up"], L["Right"]), 
										UP_LEFT = format(L["%s and then %s"], L["Up"], L["Left"]), 
										RIGHT_DOWN = format(L["%s and then %s"], L["Right"], L["Down"]), 
										RIGHT_UP = format(L["%s and then %s"], L["Right"], L["Up"]), 
										LEFT_DOWN = format(L["%s and then %s"], L["Left"], L["Down"]), 
										LEFT_UP = format(L["%s and then %s"], L["Left"], L["Up"]), 
									}, 
								}, 
								sortMethod = {
									order = 3, 
									name = L["Group By"], 
									desc = L["Set the order that the group will sort."], 
									type = "select", 
									values = {
										["CLASS"] = CLASS, 
										["ROLE"] = ROLE.."(Tanks, Healers, DPS)", 
										["ROLE_TDH"] = ROLE.."(Tanks, DPS, Healers)", 
										["ROLE_HDT"] = ROLE.."(Healers, DPS, Tanks)", 
										["ROLE_HTD"] = ROLE.."(Healers, Tanks, DPS)", 
										["NAME"] = NAME, 
										["MTMA"] = L["Main Tanks  /  Main Assist"], 
										["GROUP"] = GROUP, 
									}, 
								}, 
								sortDir = {
									order = 4, 
									name = L["Sort Direction"], 
									desc = L["Defines the sort order of the selected sort method."], 
									type = "select", 
									values = {
										["ASC"] = L["Ascending"], 
										["DESC"] = L["Descending"], 
									}, 
								},
							}
						}
					}, 
				},
			}
		},
		misc = ns:SetMiscConfigGroup(true, MOD.SetGroupFrame, 'raidpet'),
		health = ns:SetHealthConfigGroup(true, MOD.SetGroupFrame, 'raidpet'),
		name = ns:SetNameConfigGroup(MOD.SetGroupFrame, 'raidpet'),
		buffs = ns:SetAuraConfigGroup(true, 'buffs', true, MOD.SetGroupFrame, 'raidpet'),
		debuffs = ns:SetAuraConfigGroup(true, 'debuffs', true, MOD.SetGroupFrame, 'raidpet'),
		auraWatch = {
			order = 600,
			type = 'group',
			name = L['Aura Watch'],
			args = {
				enable = {
					type = "toggle", 
					name = L["Enable"], 
					order = 1,
					get = function(l)return SV.db.SVUnit["raidpet"].auraWatch.enable end, 
					set = function(l, m)MOD:ChangeDBVar(m, "enable", "raidpet", "auraWatch");MOD:SetGroupFrame('raidpet')end, 
				}, 
				size = {
					type = "range", 
					name = L["Size"], 
					desc = L["Size of the indicator icon."], 
					order = 2, 
					min = 4, 
					max = 15, 
					step = 1,
					get = function(l)return SV.db.SVUnit["raidpet"].auraWatch.size end, 
					set = function(l, m)MOD:ChangeDBVar(m, "size", "raidpet", "auraWatch");MOD:SetGroupFrame('raidpet')end, 
				}, 
				configureButton = {
					type = 'execute',
					name = L['Configure Auras'],
					func = function()ns:SetToFilterConfig('BuffWatch')end,
					order = 3,
				},
			},
		},
		rdebuffs = {
			order = 700,
			type = 'group',
			name = L['RaidDebuff Indicator'],
			get = function(l)return
			SV.db.SVUnit['raidpet']['rdebuffs'][l[#l]]end,
			set = function(l, m) MOD:ChangeDBVar(m, l[#l], "raidpet", "rdebuffs"); MOD:SetGroupFrame('raidpet')end,
			args = {
				enable = {
					type = 'toggle',
					name = L['Enable'],
					order = 1,
				},
				size = {
					type = 'range',
					name = L['Size'],
					order = 2,
					min = 8,
					max = 35,
					step = 1,
				},
				xOffset = {
					order = 3,
					type = 'range',
					name = L['xOffset'],
					min =  - 300,
					max = 300,
					step = 1,
				},
				yOffset = {
					order = 4,
					type = 'range',
					name = L['yOffset'],
					min =  - 300,
					max = 300,
					step = 1,
				},
				configureButton = {
					type = 'execute',
					name = L['Configure Auras'],
					func = function()ns:SetToFilterConfig('Raid')end,
					order = 5,
				},
			},
		},
		icons = ns:SetIconConfigGroup(MOD.SetGroupFrame, 'raidpet'),
	},
}