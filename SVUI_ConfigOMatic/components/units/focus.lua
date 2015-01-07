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
--[[
##################################################################################################
##################################################################################################
##################################################################################################
]]
SV.Options.args.SVUnit.args.commonGroup.args.focus = {
	name = L["Focus"], 
	type = "group", 
	order = 9, 
	childGroups = "select", 
	get = function(l)return SV.db.SVUnit["focus"][l[#l]]end, 
	set = function(l, m)MOD:ChangeDBVar(m, l[#l], "focus");MOD:SetUnitFrame("focus")end, 
	args = {
		enable = {type = "toggle", order = 1, name = L["Enable"]}, 
		resetSettings = {type = "execute", order = 2, name = L["Restore Defaults"], func = function(l, m)MOD:ResetUnitOptions("focus");SV.Mentalo:Reset("Focus Frame")end},
		spacer1 = {
			order = 3, 
			name = "", 
			type = "description", 
			width = "full", 
		},
		spacer2 = {
			order = 4, 
			name = "", 
			type = "description", 
			width = "full", 
		},
		commonGroup = {
			order = 5, 
			type = "group", 
			name = L["General Settings"], 
			args = {
				baseGroup = {
					order = 1, 
					type = "group", 
					guiInline = true, 
					name = L["Base Settings"],
					args = {
						showAuras = {
							order = 1, 
							type = "execute",
							name = L["Show Auras"], 
							func = function()local U = SVUI_Focus;if U.forceShowAuras then U.forceShowAuras = nil else U.forceShowAuras = true end MOD:SetUnitFrame("focus")end
						},
						rangeCheck = {
							order = 2, 
							name = L["Range Check"], 
							desc = L["Check if you are in range to cast spells on this specific unit."], 
							type = "toggle"
						}, 
						predict = {
							order = 3, 
							name = L["Heal Prediction"], 
							desc = L["Show a incomming heal prediction bar on the unitframe. Also display a slightly different colored bar for incoming overheals."], 
							type = "toggle"
						}, 
						hideonnpc = {
							type = "toggle", 
							order = 4, 
							name = L["Text Toggle On NPC"], 
							desc = L["Power text will be hidden on NPC targets, in addition the name text will be repositioned to the power texts anchor point."], 
							get = function(l)return SV.db.SVUnit["focus"]["power"].hideonnpc end, 
							set = function(l, m)SV.db.SVUnit["focus"]["power"].hideonnpc = m;MOD:SetUnitFrame("focus")end
						},  
						threatEnabled = {
							type = "toggle", 
							order = 5, 
							name = L["Show Threat"]
						}
					}
				},
				sizeGroup = {
					order = 2, 
					guiInline = true, 
					type = "group", 
					name = L["Size Settings"], 
					args = {
						width = {
							order = 1,
							name = L["Width"],
							type = "range",
							width = "full",
							min = 50,
							max = 500,
							step = 1,
						},
						height = {
							order = 2,
							name = L["Height"],
							type = "range",
							width = "full",
							min = 10,
							max = 250,
							step = 1
						},
					}
				},
			}
		}, 
		misc = ns:SetMiscConfigGroup(false, MOD.SetUnitFrame, "focus"),
		health = ns:SetHealthConfigGroup(false, MOD.SetUnitFrame, "focus"), 
		power = ns:SetPowerConfigGroup(nil, MOD.SetUnitFrame, "focus"), 
		name = ns:SetNameConfigGroup(MOD.SetUnitFrame, "focus"), 
		buffs = ns:SetAuraConfigGroup(false, "buffs", false, MOD.SetUnitFrame, "focus"), 
		debuffs = ns:SetAuraConfigGroup(false, "debuffs", false, MOD.SetUnitFrame, "focus"), 
		castbar = ns:SetCastbarConfigGroup(MOD.SetUnitFrame, "focus"), 
		aurabar = ns:SetAurabarConfigGroup(false, MOD.SetUnitFrame, "focus"), 
		icons = ns:SetIconConfigGroup(MOD.SetUnitFrame, "focus")
	}
}
--[[
##################################################################################################
##################################################################################################
##################################################################################################
]]
SV.Options.args.SVUnit.args.commonGroup.args.focustarget = {
	name = L["FocusTarget"], 
	type = "group", 
	order = 10, 
	childGroups = "select", 
	get = function(l)return SV.db.SVUnit["focustarget"][l[#l]]end, 
	set = function(l, m)MOD:ChangeDBVar(m, l[#l], "focustarget");MOD:SetUnitFrame("focustarget")end, 
	args = {
		enable = {type = "toggle", order = 1, name = L["Enable"]}, 
		resetSettings = {type = "execute", order = 2, name = L["Restore Defaults"], func = function(l, m)MOD:ResetUnitOptions("focustarget")SV.Mentalo:Reset("FocusTarget Frame")end}, 
		spacer1 = {
			order = 3, 
			name = "", 
			type = "description", 
			width = "full", 
		},
		spacer2 = {
			order = 4, 
			name = "", 
			type = "description", 
			width = "full", 
		},
		commonGroup = {
			order = 5, 
			type = "group", 
			name = L["General Settings"], 
			args = {
				baseGroup = {
					order = 1, 
					type = "group", 
					guiInline = true, 
					name = L["Base Settings"],
					args = {
						showAuras = {
							order = 1, 
							type = "execute", 
							name = L["Show Auras"], 
							func = function()
								if(SVUI_FocusTarget.forceShowAuras == true) then 
									SVUI_FocusTarget.forceShowAuras = nil 
								else 
									SVUI_FocusTarget.forceShowAuras = true 
								end 
								MOD:SetUnitFrame("focustarget")
							end
						}, 
						spacer1 = {
							order = 2,
							type = "description", 
							name = "",
						},
						rangeCheck = {order = 3, name = L["Range Check"], desc = L["Check if you are in range to cast spells on this specific unit."], type = "toggle"}, 
						hideonnpc = {type = "toggle", order = 4, name = L["Text Toggle On NPC"], desc = L["Power text will be hidden on NPC targets, in addition the name text will be repositioned to the power texts anchor point."], get = function(l)return SV.db.SVUnit["focustarget"]["power"].hideonnpc end, set = function(l, m)SV.db.SVUnit["focustarget"]["power"].hideonnpc = m;MOD:SetUnitFrame("focustarget")end}, 
						threatEnabled = {type = "toggle", order = 5, name = L["Show Threat"]}
					}
				},
				sizeGroup = {
					order = 2, 
					guiInline = true, 
					type = "group", 
					name = L["Size Settings"], 
					args = {
						width = {order = 1, width = "full", name = L["Width"], type = "range", min = 50, max = 500, step = 1}, 
						height = {order = 2, width = "full", name = L["Height"], type = "range", min = 10, max = 250, step = 1}, 
					}
				},
			}
		},
		misc = ns:SetMiscConfigGroup(false, MOD.SetUnitFrame, "focustarget"),
		health = ns:SetHealthConfigGroup(false, MOD.SetUnitFrame, "focustarget"), 
		power = ns:SetPowerConfigGroup(false, MOD.SetUnitFrame, "focustarget"), 
		name = ns:SetNameConfigGroup(MOD.SetUnitFrame, "focustarget"), 
		buffs = ns:SetAuraConfigGroup(false, "buffs", false, MOD.SetUnitFrame, "focustarget"), 
		debuffs = ns:SetAuraConfigGroup(false, "debuffs", false, MOD.SetUnitFrame, "focustarget"), 
		icons = ns:SetIconConfigGroup(MOD.SetUnitFrame, "focustarget")
	}
}