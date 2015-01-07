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
local SVLib = LibSuperVillain("Registry");
local L = SV.L;
local MOD = SV.SVBar;
--[[ 
########################################################## 
SET PACKAGE OPTIONS
##########################################################
]]--
local bar_configs;
local function BarConfigLoader()
	local b = {["TOPLEFT"] = "TOPLEFT", ["TOPRIGHT"] = "TOPRIGHT", ["BOTTOMLEFT"] = "BOTTOMLEFT", ["BOTTOMRIGHT"] = "BOTTOMRIGHT"}
	for d = 1, 6 do 
		local name = L["Bar "]..d;
		bar_configs["Bar"..d] = {
			order = d, 
			name = name, 
			type = "group", 
			order = (d  +  10), 
			guiInline = false, 
			disabled = function()return not SV.db.SVBar.enable end, 
			get = function(key) 
				return SV.db.SVBar["Bar"..d][key[#key]] 
			end, 
			set = function(key, value)
				MOD:ChangeDBVar(value, key[#key], "Bar"..d);
				MOD:RefreshBar("Bar"..d)
			end, 
			args = {
				enable = {
					order = 1, 
					type = "toggle", 
					name = L["Enable"], 
				}, 
				backdrop = {
					order = 2, 
					name = L["Background"], 
					type = "toggle", 
					disabled = function()return not SV.db.SVBar["Bar"..d].enable end, 
				}, 
				mouseover = {
					order = 3, 
					name = L["Mouse Over"], 
					desc = L["The frame is not shown unless you mouse over the frame."], 
					type = "toggle", 
					disabled = function()return not SV.db.SVBar["Bar"..d].enable end, 
				}, 
				restorePosition = {
					order = 4, 
					type = "execute", 
					name = L["Restore Bar"], 
					desc = L["Restore the actionbars default settings"], 
					func = function()
						SV:ResetData("SVBar", "Bar"..d)
						SV.Mentalo:Reset("Bar "..d)
						MOD:RefreshBar("Bar"..d)
					end, 
					disabled = function()return not SV.db.SVBar["Bar"..d].enable end, 
				}, 
				adjustGroup = {
					name = L["Bar Adjustments"], 
					type = "group", 
					order = 5, 
					guiInline = true, 
					disabled = function()return not SV.db.SVBar["Bar"..d].enable end, 
					args = {
						point = {
							order = 1, 
							type = "select", 
							name = L["Anchor Point"], 
							desc = L["The first button anchors itself to this point on the bar."], 
							values = b
						}, 
						buttons = {
							order = 2, 
							type = "range", 
							name = L["Buttons"], 
							desc = L["The amount of buttons to display."], 
							min = 1, 
							max = NUM_ACTIONBAR_BUTTONS, 
							step = 1
						}, 
						buttonsPerRow = {
							order = 3, 
							type = "range", 
							name = L["Buttons Per Row"], 
							desc = L["The amount of buttons to display per row."], 
							min = 1, 
							max = NUM_ACTIONBAR_BUTTONS, 
							step = 1
						}, 
						buttonsize = {
							type = "range", 
							name = L["Button Size"], 
							desc = L["The size of the action buttons."], 
							min = 15, 
							max = 60, 
							step = 1, 
							order = 4
						}, 
						buttonspacing = {
							type = "range", 
							name = L["Button Spacing"], 
							desc = L["The spacing between buttons."], 
							min = 1, 
							max = 10, 
							step = 1, 
							order = 5
						}, 
						alpha = {
							order = 6, 
							type = "range", 
							name = L["Alpha"], 
							isPercent = true, 
							min = 0, 
							max = 1, 
							step = 0.01
						}, 
					}
				}, 
				pagingGroup = {
					name = L["Bar Paging"], 
					type = "group", 
					order = 6, 
					guiInline = true, 
					disabled = function()return not SV.db.SVBar["Bar"..d].enable end, 
					args = {
						useCustomPaging = {
							order = 1, 
							type = "toggle", 
							name = L["Enable"], 
							desc = L["Allow the use of custom paging for this bar"], 
							get = function()return SV.db.SVBar["Bar"..d].useCustomPaging end, 
							set = function(e, f)
								SV.db.SVBar["Bar"..d].useCustomPaging = f;
								MOD:UpdateBarPagingDefaults();
								MOD:RefreshBar("Bar"..d)
							end
						}, 
						resetStates = {
							order = 2, 
							type = "execute", 
							name = L["Restore Defaults"], 
							desc = L["Restore default paging attributes for this bar"], 
							func = function()
								SV:ResetData("SVBar", "Bar"..d, "customPaging")
								MOD:UpdateBarPagingDefaults();
								MOD:RefreshBar("Bar"..d)
							end
						}, 
						customPaging = {
							order = 3, 
							type = "input", 
							width = "full", 
							name = L["Paging"], 
							desc = L["|cffFF0000ADVANCED:|r Set the paging attributes for this bar"], 
							get = function(e)return SV.db.SVBar["Bar"..d].customPaging[SV.class] end, 
							set = function(e, f)
								SV.db.SVBar["Bar"..d].customPaging[SV.class] = f;
								MOD:UpdateBarPagingDefaults();
								MOD:RefreshBar("Bar"..d)
							end, 
							disabled = function()return not SV.db.SVBar["Bar"..d].useCustomPaging end, 
						}, 
						useCustomVisibility = {
							order = 4, 
							type = "toggle", 
							name = L["Enable"], 
							desc = L["Allow the use of custom paging for this bar"], 
							get = function()return SV.db.SVBar["Bar"..d].useCustomVisibility end, 
							set = function(e, f)
								SV.db.SVBar["Bar"..d].useCustomVisibility = f;
								MOD:UpdateBarPagingDefaults();
								MOD:RefreshBar("Bar"..d)
							end
						}, 
						resetVisibility = {
							order = 5, 
							type = "execute", 
							name = L["Restore Defaults"], 
							desc = L["Restore default visibility attributes for this bar"], 
							func = function()
								SV:ResetData("SVBar", "Bar"..d, "customVisibility")
								MOD:UpdateBarPagingDefaults();
								MOD:RefreshBar("Bar"..d)
							end
						}, 
						customVisibility = {
							order = 6, 
							type = "input", 
							width = "full", 
							name = L["Visibility"], 
							desc = L["|cffFF0000ADVANCED:|r Set the visibility attributes for this bar"], 
							get = function(e)return SV.db.SVBar["Bar"..d].customVisibility end, 
							set = function(e, f)
								SV.db.SVBar["Bar"..d].customVisibility = f;
								MOD:UpdateBarPagingDefaults();
								MOD:RefreshBar("Bar"..d)
							end, 
							disabled = function()return not SV.db.SVBar["Bar"..d].useCustomVisibility end, 
						}, 

					}
				}
			}
		}
	end 

	bar_configs["Pet"] = {
		order = 7,
		name = L["Pet Bar"],
		type = "group",
		order = 200,
		guiInline = false,
		disabled = function()return not SV.db.SVBar.enable end,
		get = function(e)return SV.db.SVBar["Pet"][e[#e]]end,
		set = function(key, value)
			MOD:ChangeDBVar(value, key[#key], "Pet");
			MOD:RefreshBar("Pet")
		end,
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"]
			},
			backdrop = {
				order = 2,
				name = L["Background"],
				type = "toggle",
				disabled = function()return not SV.db.SVBar["Pet"].enable end,
			},
			mouseover = {
				order = 3,
				name = L["Mouse Over"],
				desc = L["The frame is not shown unless you mouse over the frame."],
				type = "toggle",
				disabled = function()return not SV.db.SVBar["Pet"].enable end,
			},
			restorePosition = {
				order = 4,
				type = "execute",
				name = L["Restore Bar"],
				desc = L["Restore the actionbars default settings"],
				func = function()
					SV:ResetData("SVBar", "Pet")
					SV.Mentalo:Reset("Pet Bar")
					MOD:RefreshBar("Pet")
				end,
				disabled = function()return not SV.db.SVBar["Pet"].enable end,
			},
			adjustGroup = {
				name = L["Bar Adjustments"],
				type = "group",
				order = 5,
				guiInline = true,
				disabled = function()return not SV.db.SVBar["Pet"].enable end,
				args = {	
					point = {
						order = 1,
						type = "select",
						name = L["Anchor Point"],
						desc = L["The first button anchors itself to this point on the bar."],
						values = b
					},
					buttons = {
						order = 2,
						type = "range",
						name = L["Buttons"],
						desc = L["The amount of buttons to display."],
						min = 1,
						max = NUM_PET_ACTION_SLOTS,
						step = 1
					},
					buttonsPerRow = {
						order = 3,
						type = "range",
						name = L["Buttons Per Row"],
						desc = L["The amount of buttons to display per row."],
						min = 1,
						max = NUM_PET_ACTION_SLOTS,
						step = 1
					},
					buttonsize = {
						order = 4,
						type = "range",
						name = L["Button Size"],
						desc = L["The size of the action buttons."],
						min = 15,
						max = 60,
						step = 1,
						disabled = function()return not SV.db.SVBar.enable end
					},
					buttonspacing = {
						order = 5,
						type = "range",
						name = L["Button Spacing"],
						desc = L["The spacing between buttons."],
						min = 1,
						max = 10,
						step = 1,
						disabled = function()return not SV.db.SVBar.enable end
					},
					alpha = {
						order = 6,
						type = "range",
						name = L["Alpha"],
						isPercent = true,
						min = 0,
						max = 1,
						step = 0.01
					},
				}
			},
			customGroup = {
				name = L["Visibility Options"],
				type = "group",
				order = 6,
				guiInline = true,
				args = {
					useCustomVisibility = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Allow the use of custom paging for this bar"],
						get = function()return SV.db.SVBar["Pet"].useCustomVisibility end,
						set = function(e,f)
							SV.db.SVBar["Pet"].useCustomVisibility = f;
							MOD:RefreshBar("Pet")
						end
					},
					resetVisibility = {
						order = 2,
						type = "execute",
						name = L["Restore Defaults"],
						desc = L["Restore default visibility attributes for this bar"],
						func = function()
							SV:ResetData("SVBar", "Pet", "customVisibility")
							MOD:RefreshBar("Pet")
						end
					},
					customVisibility = {
						order = 3,
						type = "input",
						width = "full",
						name = L["Visibility"],
						desc = L["|cffFF0000ADVANCED:|r Set the visibility attributes for this bar"],
						get = function(e)return SV.db.SVBar["Pet"].customVisibility end,
						set = function(e,f)
							SV.db.SVBar["Pet"].customVisibility = f;
							MOD:RefreshBar("Pet")
						end,
						disabled = function()return not SV.db.SVBar["Pet"].useCustomVisibility end,
					},
				}
			}
		}
	};

	bar_configs["Stance"] = {
		order = 8,
		name = L["Stance Bar"],
		type = "group",
		order = 300,
		guiInline = false,
		disabled = function()return not SV.db.SVBar.enable end,
		get = function(e)return SV.db.SVBar["Stance"][e[#e]]end,
		set = function(key, value)
			MOD:ChangeDBVar(value, key[#key], "Stance");
			MOD:RefreshBar("Stance")
		end,
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"]
			},
			backdrop = {
				order = 2,
				name = L["Background"],
				type = "toggle",
				disabled = function()return not SV.db.SVBar["Stance"].enable end,
			},
			mouseover = {
				order = 3,
				name = L["Mouse Over"],
				desc = L["The frame is not shown unless you mouse over the frame."],
				type = "toggle",
				disabled = function()return not SV.db.SVBar["Stance"].enable end,
			},
			restorePosition = {
				order = 4,
				type = "execute",
				name = L["Restore Bar"],
				desc = L["Restore the actionbars default settings"],
				func = function()
					SVLib:SetDefault("SVBar","Stance")
					SV.Mentalo:Reset("Stance Bar")
					MOD:RefreshBar("Stance")
				end,
				disabled = function()return not SV.db.SVBar["Stance"].enable end,
			},
			adjustGroup = {
				name = L["Bar Adjustments"],
				type = "group",
				order = 5,
				guiInline = true,
				disabled = function()return not SV.db.SVBar["Stance"].enable end,
				args = {
					point = {
						order = 1,
						type = "select",
						name = L["Anchor Point"],
						desc = L["The first button anchors itself to this point on the bar."],
						values = b
					},
					buttons = {
						order = 2,
						type = "range",
						name = L["Buttons"],
						desc = L["The amount of buttons to display."],
						min = 1,
						max = NUM_STANCE_SLOTS,
						step = 1
					},
					buttonsPerRow = {
						order = 3,
						type = "range",
						name = L["Buttons Per Row"],
						desc = L["The amount of buttons to display per row."],
						min = 1,
						max = NUM_STANCE_SLOTS,
						step = 1
					},
					buttonsize = {
						order = 4,
						type = "range",
						name = L["Button Size"],
						desc = L["The size of the action buttons."],
						min = 15,
						max = 60,
						step = 1
					},
					buttonspacing = {
						order = 5,
						type = "range",
						name = L["Button Spacing"],
						desc = L["The spacing between buttons."],
						min = 1,
						max = 10,
						step = 1
					},
					alpha = {
						order = 6,
						type = "range",
						name = L["Alpha"],
						isPercent = true,
						min = 0,
						max = 1,
						step = 0.01
					}, 
				}
			},
			customGroup = {
				name = L["Visibility Options"],
				type = "group",
				order = 6,
				guiInline = true,
				disabled = function()return not SV.db.SVBar["Stance"].enable end,
				args = {
					style = {
						order = 1,
						type = "select",
						name = L["Style"],
						desc = L["This setting will be updated upon changing stances."],
						values = {
							["darkenInactive"] = L["Darken Inactive"],
							["classic"] = L["Classic"]
						}
					},
					spacer1 = {
						order = 2,
						type = "description",
						name = "",
					},
					spacer2 = {
						order = 3,
						type = "description",
						name = "",
					},
					useCustomVisibility = {
						order = 4,
						type = "toggle",
						name = L["Enable"],
						desc = L["Allow the use of custom paging for this bar"],
						get = function()return SV.db.SVBar["Stance"].useCustomVisibility end,
						set = function(e,f)
							SV.db.SVBar["Stance"].useCustomVisibility = f;
							MOD:RefreshBar("Stance")
						end
					},
					resetVisibility = {
						order = 5,
						type = "execute",
						name = L["Restore Defaults"],
						desc = L["Restore default visibility attributes for this bar"],
						func = function()
							SV:ResetData("SVBar", "Stance", "customVisibility")
							MOD:RefreshBar("Stance")
						end
					},
					customVisibility = {
						order = 6,
						type = "input",
						width = "full",
						name = L["Visibility"],
						desc = L["|cffFF0000ADVANCED:|r Set the visibility attributes for this bar"],
						get = function(e)return SV.db.SVBar["Stance"].customVisibility end,
						set = function(e,f)
							SV.db.SVBar["Stance"].customVisibility = f;
							MOD:RefreshBar("Stance")
						end,
						disabled = function()return not SV.db.SVBar["Stance"].useCustomVisibility end,
					},
				}
			}
		}
	};

	bar_configs["Micro"] = {
		order = 9,
		name = L["Micro Menu"],
		type = "group",
		order = 100,
		guiInline = false,
		disabled = function()return not SV.db.SVBar.enable end,
		get = function(key) 
			return SV.db.SVBar["Micro"][key[#key]] 
		end, 
		set = function(key, value)
			MOD:ChangeDBVar(value, key[#key], "Micro");
			MOD:UpdateMicroButtons()
		end,
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"]
			},
			mouseover = {
				order = 2,
				name = L["Mouse Over"],
				desc = L["The frame is not shown unless you mouse over the frame."],
				disabled = function()return not SV.db.SVBar["Micro"].enable end,
				type = "toggle"
			},
			buttonsize = {
				order = 3,
				type = "range",
				name = L["Button Size"],
				desc = L["The size of the action buttons."],
				min = 15,
				max = 60,
				step = 1,
				disabled = function()return not SV.db.SVBar["Micro"].enable end,
			},
			buttonspacing = {
				order = 4,
				type = "range",
				name = L["Button Spacing"],
				desc = L["The spacing between buttons."],
				min = 1,
				max = 10,
				step = 1,
				disabled = function()return not SV.db.SVBar["Micro"].enable end,
			},
		}
	};
end 

SV.Options.args.SVBar = {
	type = "group", 
	name = MOD.TitleID, 
	childGroups = "tab", 
	get = function(key)
		return SV.db.SVBar[key[#key]]
	end, 
	set = function(key, value)
		MOD:ChangeDBVar(value, key[#key]);
		MOD:RefreshActionBars()
	end, 
	args = {
		enable = {
			order = 1, 
			type = "toggle", 
			name = L["Enable"], 
			get = function(e)return SV.db.SVBar[e[#e]]end, 
			set = function(e, f)SV.db.SVBar[e[#e]] = f;SV:StaticPopup_Show("RL_CLIENT")end
		}, 
		barGroup = {
			order = 2, 
			type = "group", 
			name = L["Bar Options"], 
			childGroups = "tree",
			disabled = function()return not SV.db.SVBar.enable end, 
			args = {
				commonGroup = {
					order = 1, 
					type = "group", 
					name = L["General Settings"], 
					args = {
						macrotext = {
							type = "toggle", 
							name = L["Macro Text"], 
							desc = L["Display macro names on action buttons."], 
							order = 2
						}, 
						hotkeytext = {
							type = "toggle", 
							name = L["Keybind Text"], 
							desc = L["Display bind names on action buttons."], 
							order = 3
						}, 
						keyDown = {
							type = "toggle", 
							name = L["Key Down"], 
							desc = OPTION_TOOLTIP_ACTION_BUTTON_USE_KEY_DOWN, 
							order = 4
						}, 
						showGrid = {
							type = "toggle", 
							name = ALWAYS_SHOW_MULTIBARS_TEXT, 
							desc = OPTION_TOOLTIP_ALWAYS_SHOW_MULTIBARS, 
							order = 5
						}, 
						unlock = {
							type = "select", 
							width = "full", 
							name = PICKUP_ACTION_KEY_TEXT, 
							desc = L["The button you must hold down in order to drag an ability to another action button."],
							order = 6, 
							values = {
								["SHIFT"] = SHIFT_KEY, 
								["ALT"] = ALT_KEY, 
								["CTRL"] = CTRL_KEY
							}
						}, 
						unc = {
							type = "color", 
							order = 7, 
							name = L["Out of Range"], 
							desc = L["Color of the actionbutton when out of range."], 
							hasAlpha = true, 
							get = function(key) return unpack(SV.db.SVBar[key[#key]]) end, 
							set = function(key, rValue, gValue, bValue, aValue)
								SV.db.SVBar[key[#key]][1] = rValue
								SV.db.SVBar[key[#key]][2] = gValue
								SV.db.SVBar[key[#key]][3] = bValue
								SV.db.SVBar[key[#key]][4] = aValue
								MOD:RefreshActionBars()
							end, 
						}, 
						unpc = {
							type = "color", 
							order = 8, 
							name = L["Out of Power"], 
							desc = L["Color of the actionbutton when out of power (Mana, Rage, Focus, Holy Power)."], 
							hasAlpha = true, 
							get = function(key) return unpack(SV.db.SVBar[key[#key]]) end, 
							set = function(key, rValue, gValue, bValue, aValue)
								SV.db.SVBar[key[#key]][1] = rValue
								SV.db.SVBar[key[#key]][2] = gValue
								SV.db.SVBar[key[#key]][3] = bValue
								SV.db.SVBar[key[#key]][4] = aValue
								MOD:RefreshActionBars()
							end, 
						}, 
						rightClickSelf = {
							type = "toggle", 
							name = L["Self Cast"], 
							desc = L["Right-click any action button to self cast"], 
							order = 9
						},
						cooldownSize = {
							order = 10, 
							width = "full", 
							name = L["Cooldown Font Size"], 
							type = "range", 
							min = 6, 
							max = 22, 
							step = 1
						},
					}
				},
			}
		}
	}
}
bar_configs = SV.Options.args.SVBar.args.barGroup.args
BarConfigLoader();