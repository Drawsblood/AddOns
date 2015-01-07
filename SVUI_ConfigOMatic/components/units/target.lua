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
SV.Options.args.SVUnit.args.commonGroup.args.target={
	name = L['Target'],
	type = 'group',
	order = 6,
	childGroups = "select",
	get=function(l)return SV.db.SVUnit['target'][l[#l]]end,
	set=function(l,m)MOD:ChangeDBVar(m, l[#l], "target");MOD:SetUnitFrame('target')end,
	args={
		enable={type='toggle',order=1,name=L['Enable']},
		resetSettings={type='execute',order=2,name=L['Restore Defaults'],func=function(l,m)MOD:ResetUnitOptions('target')SV.Mentalo:Reset('Target Frame')end},
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
			type = 'group',
			name = L['General Settings'],
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
							func = function()local U = SVUI_Target;if U.forceShowAuras then U.forceShowAuras = nil else U.forceShowAuras = true end MOD:SetUnitFrame("target")end
						},
						gps = {
							order = 2, 
							name = "GPS Tracking", 
							desc = "Show an arrow giving the direction and distance to the frames unit.", 
							type = "toggle", 
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
							get = function(l)return SV.db.SVUnit["target"]["power"].hideonnpc end,
							set = function(l, m)SV.db.SVUnit["target"]["power"].hideonnpc = m;MOD:SetUnitFrame("target")end
						},
						threatEnabled = {
							type = "toggle",
							order = 5,
							name = L["Show Threat"]
						},
						middleClickFocus = {
							order = 6,
							name = L["Middle Click - Set Focus"],
							desc = L["Middle clicking the unit frame will cause your focus to match the unit."],
							type = "toggle",
							disabled = function()return IsAddOnLoaded("Clique")end
						},

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
							set = function(l, m)
								if SV.db.SVUnit["target"].castbar.width == SV.db.SVUnit["target"][l[#l]] then 
									SV.db.SVUnit["target"].castbar.width = m 
								end 
								MOD:ChangeDBVar(m, l[#l], "target");
								MOD:SetUnitFrame("target")
							end
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
				}
			}
		},
		combobar = {
			order = 800,
			type = "group",
			name = L["Combobar"],
			get = function(l)return SV.db.SVUnit["target"]["combobar"][l[#l]]end,
			set = function(l, m)MOD:ChangeDBVar(m, l[#l], "target", "combobar");MOD:SetUnitFrame("target")end,
			args = {
				enable = {
					type = "toggle",
					order = 1,
					name = L["Enable"]
				},
				smallIcons = {
					type = "toggle",
					name = L["Small Points"],
					order = 2
				},
				height = {
					type = "range",
					order = 3,
					name = L["Height"],
					min = 15,
					max = 45,
					step = 1
				},
				autoHide = {
					type = "toggle",
					name = L["Auto-Hide"],
					order = 4
				}
			}
		},
		misc = ns:SetMiscConfigGroup(false, MOD.SetUnitFrame, "target"),
		health = ns:SetHealthConfigGroup(false, MOD.SetUnitFrame, "target"), 
		power = ns:SetPowerConfigGroup(true, MOD.SetUnitFrame, "target"), 
		name = ns:SetNameConfigGroup(MOD.SetUnitFrame, "target"), 
		portrait = ns:SetPortraitConfigGroup(MOD.SetUnitFrame, "target"), 
		buffs = ns:SetAuraConfigGroup(false, "buffs", false, MOD.SetUnitFrame, "target"), 
		debuffs = ns:SetAuraConfigGroup(false, "debuffs", false, MOD.SetUnitFrame, "target"), 
		castbar = ns:SetCastbarConfigGroup(MOD.SetUnitFrame, "target"), 
		aurabar = ns:SetAurabarConfigGroup(false, MOD.SetUnitFrame, "target"), 
		icons = ns:SetIconConfigGroup(MOD.SetUnitFrame, "target")
	}
}
--[[
##################################################################################################
##################################################################################################
##################################################################################################
]]
SV.Options.args.SVUnit.args.commonGroup.args.targettarget={
	name=L['Target of Target'],
	type='group',
	order=7,
	childGroups="select",
	get=function(l)return SV.db.SVUnit['targettarget'][l[#l]]end,
	set=function(l,m)MOD:ChangeDBVar(m, l[#l], "targettarget");MOD:SetUnitFrame('targettarget')end,
	args={
		enable={type='toggle',order=1,name=L['Enable']},
		resetSettings={type='execute',order=2,name=L['Restore Defaults'],func=function(l,m)MOD:ResetUnitOptions('targettarget')SV.Mentalo:Reset('TargetTarget Frame')end},
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
			type = 'group',
			name = L['General Settings'],
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
							func = function()local U = SVUI_TargetTarget;if U.forceShowAuras then U.forceShowAuras = nil else U.forceShowAuras = true end MOD:SetUnitFrame("targettarget")end
						},
						spacer1 = {
							order = 2,
							type = "description", 
							name = "",
						},
						rangeCheck = {
							order = 3,
							name = L["Range Check"],
							desc = L["Check if you are in range to cast spells on this specific unit."],
							type = "toggle"
						},
						hideonnpc = {
							type = "toggle",
							order = 4,
							name = L["Text Toggle On NPC"],
							desc = L["Power text will be hidden on NPC targets, in addition the name text will be repositioned to the power texts anchor point."],
							get = function(l)return SV.db.SVUnit["target"]["power"].hideonnpc end,
							set = function(l, m)SV.db.SVUnit["target"]["power"].hideonnpc = m;MOD:SetUnitFrame("target")end
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
				}
			}
		},
		misc = ns:SetMiscConfigGroup(false, MOD.SetUnitFrame, "targettarget"),
		health = ns:SetHealthConfigGroup(false, MOD.SetUnitFrame, "targettarget"), 
		power = ns:SetPowerConfigGroup(nil, MOD.SetUnitFrame, "targettarget"), 
		name = ns:SetNameConfigGroup(MOD.SetUnitFrame, "targettarget"), 
		portrait = ns:SetPortraitConfigGroup(MOD.SetUnitFrame, "targettarget"), 
		buffs = ns:SetAuraConfigGroup(false, "buffs", false, MOD.SetUnitFrame, "targettarget"), 
		debuffs = ns:SetAuraConfigGroup(false, "debuffs", false, MOD.SetUnitFrame, "targettarget"), 
		icons = ns:SetIconConfigGroup(MOD.SetUnitFrame, "targettarget")
	}
}