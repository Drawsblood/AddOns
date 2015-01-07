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
SV.Options.args.SVUnit.args.commonGroup.args.pet = {
	name = L["Pet"], 
	type = "group", 
	order = 4, 
	childGroups = "select", 
	get = function(l)return SV.db.SVUnit["pet"][l[#l]]end, 
	set = function(l, m)MOD:ChangeDBVar(m, l[#l], "pet");MOD:SetUnitFrame("pet")end, 
	args = {
		enable = {type = "toggle", order = 1, name = L["Enable"]}, 
		resetSettings = {type = "execute", order = 2, name = L["Restore Defaults"], func = function(l, m)MOD:ResetUnitOptions("pet")SV.Mentalo:Reset("Pet Frame")end}, 
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
				showAuras = {
					order = 1, 
					type = "execute", 
					name = L["Show Auras"], 
					func = function()local U = SVUI_Pet;if U.forceShowAuras then U.forceShowAuras = nil else U.forceShowAuras = true end MOD:SetUnitFrame("pet")end
				},
				miscGroup = {
					order = 2, 
					type = "group", 
					guiInline = true,
					name = L["Base Settings"], 
					args = {
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
							get = function(l)return SV.db.SVUnit["pet"]["power"].hideonnpc end, 
							set = function(l, m)SV.db.SVUnit["pet"]["power"].hideonnpc = m;MOD:SetUnitFrame("pet")end
						}, 
						threatEnabled = {
							type = "toggle", 
							order = 5, 
							name = L["Show Threat"]
						},
					}
				},
				scaleGroup = {
					order = 6, 
					type = "group", 
					guiInline = true,
					name = L["Frame Size"], 
					args = {
						width = {order = 1, name = L["Width"], width = "full", type = "range", min = 50, max = 500, step = 1}, 
						height = {order = 2, name = L["Height"], width = "full", type = "range", min = 10, max = 250, step = 1},
					}
				}, 
				watchGroup = {
					order = 8, 
					type = "group", 
					guiInline = true,
					name = L["Aura Watch"], 
					get = function(l)return SV.db.SVUnit["pet"]["auraWatch"][l[#l]]end, 
					set = function(l, m)MOD:ChangeDBVar(m, l[#l], "pet", "auraWatch");MOD:SetUnitFrame("pet")end, 
					args = {
						enable = {
							type = "toggle", 
							name = L["Enable"], 
							order = 1
						}, 
						size = {
							type = "range", 
							name = L["Size"], 
							desc = L["Size of the indicator icon."], 
							order = 2, 
							min = 4, 
							max = 15, 
							step = 1
						}
					}
				},  
			},
		},
		misc = ns:SetMiscConfigGroup(false, MOD.SetUnitFrame, "pet"),
		health = ns:SetHealthConfigGroup(false, MOD.SetUnitFrame, "pet"), 
		power = ns:SetPowerConfigGroup(false, MOD.SetUnitFrame, "pet"), 
		portrait = ns:SetPortraitConfigGroup(MOD.SetUnitFrame, "pet"), 
		name = ns:SetNameConfigGroup(MOD.SetUnitFrame, "pet"), 
		buffs = ns:SetAuraConfigGroup(true, "buffs", false, MOD.SetUnitFrame, "pet"), 
		debuffs = ns:SetAuraConfigGroup(true, "debuffs", false, MOD.SetUnitFrame, "pet")
	}
}
--[[
##################################################################################################
##################################################################################################
##################################################################################################
]]
SV.Options.args.SVUnit.args.commonGroup.args.pettarget = {
	name = L["Pet Target"], 
	type = "group", 
	order = 5, 
	childGroups = "select", 
	get = function(l)return SV.db.SVUnit["pettarget"][l[#l]]end, 
	set = function(l, m)MOD:ChangeDBVar(m, l[#l], "pettarget");MOD:SetUnitFrame("pettarget")end, 
	args = {
		enable = {type = "toggle", order = 1, name = L["Enable"]}, 
		resetSettings = {type = "execute", order = 2, name = L["Restore Defaults"], func = function(l, m)MOD:ResetUnitOptions("pettarget")SV.Mentalo:Reset("PetTarget Frame")end},
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
				showAuras = {
					order = 1, 
					type = "execute", 
					name = L["Show Auras"], 
					func = function()local U = SVUI_PetTarget;if U.forceShowAuras then U.forceShowAuras = nil else U.forceShowAuras = true end MOD:SetUnitFrame("pettarget")end
				}, 
				miscGroup = {
					order = 2, 
					type = "group", 
					guiInline = true,
					name = L["Base Settings"], 
					args = {
						rangeCheck = {
							order = 2, 
							name = L["Range Check"], 
							desc = L["Check if you are in range to cast spells on this specific unit."], 
							type = "toggle"
						},
						hideonnpc = {
							type = "toggle", 
							order = 4, 
							name = L["Text Toggle On NPC"], 
							desc = L["Power text will be hidden on NPC targets, in addition the name text will be repositioned to the power texts anchor point."], 
							get = function(l)return SV.db.SVUnit["pettarget"]["power"].hideonnpc end, 
							set = function(l, m)SV.db.SVUnit["pettarget"]["power"].hideonnpc = m;MOD:SetUnitFrame("pettarget")end
						}, 
						threatEnabled = {
							type = "toggle", 
							order = 5, 
							name = L["Show Threat"]
						},
					}
				},
				scaleGroup = {
					order = 3, 
					type = "group", 
					guiInline = true,
					name = L["Frame Size"], 
					args = {
						width = {order = 1, name = L["Width"], width = "full", type = "range", min = 50, max = 500, step = 1}, 
						height = {order = 2, name = L["Height"], width = "full", type = "range", min = 10, max = 250, step = 1},
					}
				}, 
			},
		},
		misc = ns:SetMiscConfigGroup(false, MOD.SetUnitFrame, "pettarget"),
		health = ns:SetHealthConfigGroup(false, MOD.SetUnitFrame, "pettarget"), 
		power = ns:SetPowerConfigGroup(false, MOD.SetUnitFrame, "pettarget"), 
		name = ns:SetNameConfigGroup(MOD.SetUnitFrame, "pettarget"), 
		buffs = ns:SetAuraConfigGroup(false, "buffs", false, MOD.SetUnitFrame, "pettarget"), 
		debuffs = ns:SetAuraConfigGroup(false, "debuffs", false, MOD.SetUnitFrame, "pettarget")
	}
}