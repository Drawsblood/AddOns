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

SV.Options.args.SVUnit.args.commonGroup.args.party = {
	name = L['Party'],
	type = 'group',
	order = 11,
	childGroups = "select",
	get = function(l) return SV.db.SVUnit['party'][l[#l]] end,
	set = function(l, m) MOD:ChangeDBVar(m, l[#l], "party"); MOD:SetGroupFrame('party') end,
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
			func = function()
				MOD:ViewGroupFrames(SVUI_Party, SVUI_Party.forceShow ~= true or nil)
			end,
		},
		resetSettings = {
			type = 'execute',
			order = 3,
			name = L['Restore Defaults'],
			func = function(l, m)MOD:ResetUnitOptions('party')SV.Mentalo:Reset('Party Frames')end,
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
					set = function(key, value) MOD:ChangeDBVar(value, key[#key], "party"); MOD:SetGroupFrame("party", true) end, 
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
									get = function(key) return SV.db.SVUnit["party"].grid.enable end,
									set = function(key, value) 
										MOD:ChangeDBVar(value, key[#key], "party", "grid"); 
										MOD:SetGroupFrame("party", true);
										SV.Options.args.SVUnit.args.commonGroup.args.party.args.general.args.layoutGroup.args.sizing = ns:SetSizeConfigGroup(value, "party");
									end,
								},
								invertGroupingOrder = {
									order = 2,
									type = "toggle",
									name = L["Invert Grouping Order"], 
									desc = L["Enabling this inverts the grouping order."], 
									disabled = function() return not SV.db.SVUnit["party"].customSorting end,  
								},
							}
						},
						sizing = ns:SetSizeConfigGroup(SV.db.SVUnit.party.grid.enable, "party"),
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
										MOD:ChangeDBVar(value, key[#key], "party");
										MOD:SetGroupFrame("party")
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
		auraWatch = {
			order = 600,
			type = 'group',
			name = L['Aura Watch'],
			get = function(l)return
			SV.db.SVUnit['party']['auraWatch'][l[#l]]end,
			set = function(l, m) MOD:ChangeDBVar(m, l[#l], "party", "auraWatch"); MOD:SetGroupFrame('party')end,
			args = {
				enable = {
					type = 'toggle',
					name = L['Enable'],
					order = 1,
				},
				size = {
					type = 'range',
					name = L['Size'],
					desc = L['Size of the indicator icon.'],
					order = 2,
					min = 4,
					max = 15,
					step = 1,
				},
				configureButton = {
					type = 'execute',
					name = L['Configure Auras'],
					func = function()ns:SetToFilterConfig('BuffWatch')end,
					order = 3,
				},

			},
		},
		misc = ns:SetMiscConfigGroup(true, MOD.SetGroupFrame, 'party'),
		health = ns:SetHealthConfigGroup(true, MOD.SetGroupFrame, 'party'),
		power = ns:SetPowerConfigGroup(false, MOD.SetGroupFrame, 'party'),
		name = ns:SetNameConfigGroup(MOD.SetGroupFrame, 'party'),
		portrait = ns:SetPortraitConfigGroup(MOD.SetGroupFrame, 'party'),
		buffs = ns:SetAuraConfigGroup(true, 'buffs', true, MOD.SetGroupFrame, 'party'),
		debuffs = ns:SetAuraConfigGroup(true, 'debuffs', true, MOD.SetGroupFrame, 'party'),
		petsGroup = {
			order = 800,
			type = 'group',
			name = L['Party Pets'],
			get = function(l)return SV.db.SVUnit['party']['petsGroup'][l[#l]]end,
			set = function(l, m)MOD:ChangeDBVar(m, l[#l], "party", "petsGroup");MOD:SetGroupFrame('party')end,
			args = {
				enable = {
					type = 'toggle',
					name = L['Enable'],
					order = 1,
				},
				width = {
					order = 3,
					name = L['Width'],
					type = 'range',
					min = 10,
					max = 500,
					step = 1,
				},
				height = {
					order = 4,
					name = L['Height'],
					type = 'range',
					min = 10,
					max = 250,
					step = 1,
				},
				anchorPoint = {
					type = 'select',
					order = 5,
					name = L['Anchor Point'],
					desc = L['What point to anchor to the frame you set to attach to.'],
					values = {TOPLEFT='TOPLEFT',LEFT='LEFT',BOTTOMLEFT='BOTTOMLEFT',RIGHT='RIGHT',TOPRIGHT='TOPRIGHT',BOTTOMRIGHT='BOTTOMRIGHT',CENTER='CENTER',TOP='TOP',BOTTOM='BOTTOM'},
				},
				xOffset = {
					order = 6,
					type = 'range',
					name = L['xOffset'],
					desc = L['An X offset (in pixels) to be used when anchoring new frames.'],
					min =  - 500,
					max = 500,
					step = 1,
				},
				yOffset = {
					order = 7,
					type = 'range',
					name = L['yOffset'],
					desc = L['An Y offset (in pixels) to be used when anchoring new frames.'],
					min =  - 500,
					max = 500,
					step = 1,
				},
				name_length = {
					order = 8, 
					name = L["Name Length"],
					desc = L["TEXT_FORMAT_DESC"], 
					type = "range", 
					width = "full", 
					min = 1, 
					max = 30, 
					step = 1,
					set = function(key, value)
						MOD:ChangeDBVar(value, key[#key], "party", "petsGroup");
						local tag = "[name:" .. value .. "]";
						MOD:ChangeDBVar(tag, "tags", "party", "petsGroup");
					end,
				}
			},
		},
		targetsGroup = {
			order = 900,
			type = 'group',
			name = L['Party Targets'],
			get = function(l)return
			SV.db.SVUnit['party']['targetsGroup'][l[#l]]end,
			set = function(l, m) MOD:ChangeDBVar(m, l[#l], "party", "targetsGroup"); MOD:SetGroupFrame('party') end,
			args = {
				enable = {
					type = 'toggle',
					name = L['Enable'],
					order = 1,
				},
				width = {
					order = 3,
					name = L['Width'],
					type = 'range',
					min = 10,
					max = 500,
					step = 1,
				},
				height = {
					order = 4,
					name = L['Height'],
					type = 'range',
					min = 10,
					max = 250,
					step = 1,
				},
				anchorPoint = {
					type = 'select',
					order = 5,
					name = L['Anchor Point'],
					desc = L['What point to anchor to the frame you set to attach to.'],
					values = {TOPLEFT='TOPLEFT',LEFT='LEFT',BOTTOMLEFT='BOTTOMLEFT',RIGHT='RIGHT',TOPRIGHT='TOPRIGHT',BOTTOMRIGHT='BOTTOMRIGHT',CENTER='CENTER',TOP='TOP',BOTTOM='BOTTOM'},
				},
				xOffset = {
					order = 6,
					type = 'range',
					name = L['xOffset'],
					desc = L['An X offset (in pixels) to be used when anchoring new frames.'],
					min =  - 500,
					max = 500,
					step = 1,
				},
				yOffset = {
					order = 7,
					type = 'range',
					name = L['yOffset'],
					desc = L['An Y offset (in pixels) to be used when anchoring new frames.'],
					min =  - 500,
					max = 500,
					step = 1,
				},
				name_length = {
					order = 8, 
					name = L["Name Length"],
					desc = L["TEXT_FORMAT_DESC"], 
					type = "range", 
					width = "full", 
					min = 1, 
					max = 30, 
					step = 1,
					set = function(key, value)
						MOD:ChangeDBVar(value, key[#key], "party", "targetsGroup");
						local tag = "[name:" .. value .. "]";
						MOD:ChangeDBVar(tag, "tags", "party", "targetsGroup");
					end,
				}
			},
		},
		icons = ns:SetIconConfigGroup(MOD.SetGroupFrame, 'party')
	},
}