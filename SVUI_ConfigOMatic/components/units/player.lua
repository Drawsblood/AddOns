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
SV.Options.args.SVUnit.args.commonGroup.args.player = {
	name = L['Player'],
	type = 'group',
	order = 3,
	childGroups = "select",
	get = function(l)return SV.db.SVUnit['player'][l[#l]]end,
	set = function(l,m)MOD:ChangeDBVar(m, l[#l], "player");MOD:SetUnitFrame('player')end,
	args = {
		enable = {
			type = 'toggle',
			order = 1,
			name = L['Enable']
		},
		resetSettings = {
			type = 'execute',
			order = 2,
			name = L['Restore Defaults'],
			func = function(l,m)
				MOD:ResetUnitOptions('player')
				SV.Mentalo:Reset('Player Frame')
			end
		},
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
						combatfade = {
							order = 1,
							name = L["Combat Fade"],
							desc = L["Fade the unitframe when out of combat, not casting, no target exists."],
							type = "toggle",
							set = function(l, m)
								MOD:ChangeDBVar(m, l[#l], "player");
								MOD:SetUnitFrame("player")
								if m == true then 
									SVUI_Pet:SetParent(SVUI_Player)
								else 
									SVUI_Pet:SetParent(SVUI_UnitFrameParent)
								end 
							end
						},
						predict = {
							order = 2,
							name = L["Heal Prediction"],
							desc = L["Show a incomming heal prediction bar on the unitframe. Also display a slightly different colored bar for incoming overheals."],
							type = "toggle"
						},
						threatEnabled = {
							type = "toggle",
							order = 3,
							name = L["Show Threat"]
						},
						playerExpBar = {
							order = 4,
							name = "Playerframe Experience Bar",
							desc = "Show player experience on power bar mouseover",
							type = "toggle",
							set = function(l, m)MOD:ChangeDBVar(m, l[#l], "player");SV:StaticPopup_Show("RL_CLIENT")end
						},
						playerRepBar = {
							order = 5,
							name = "Playerframe Reputation Bar",
							desc = "Show player reputations on power bar mouseover",
							type = "toggle",
							set = function(l, m)MOD:ChangeDBVar(m, l[#l], "player");SV:StaticPopup_Show("RL_CLIENT")end
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
							set = function(l, m)
								if SV.db.SVUnit["player"].castbar.width == SV.db.SVUnit["player"][l[#l]] then 
									SV.db.SVUnit["player"].castbar.width = m 
								end 
								MOD:ChangeDBVar(m, l[#l], "player");
								MOD:SetUnitFrame("player")
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
				},
				pvpGroup = {
					order = 3,
					type = "group",
					guiInline = true,
					name = PVP,
					get = function(l)return SV.db.SVUnit["player"]["pvp"][l[#l]]end,
					set = function(l, m)MOD:ChangeDBVar(m, l[#l], "player", "pvp");MOD:SetUnitFrame("player")end,
					args = {
						position = {
							type = "select",
							order = 2,
							name = L["Position"],
							values = {
								TOPLEFT = "TOPLEFT",
								LEFT = "LEFT",
								BOTTOMLEFT = "BOTTOMLEFT",
								RIGHT = "RIGHT",
								TOPRIGHT = "TOPRIGHT",
								BOTTOMRIGHT = "BOTTOMRIGHT",
								CENTER = "CENTER",
								TOP = "TOP",
								BOTTOM = "BOTTOM"
							}
						},
						tags = {
							order = 100,
							name = L["Text Format"],
							type = "input",
							width = "full",
							desc = L["TEXT_FORMAT_DESC"]
						}
					}
				}
			}
		},
		misc = ns:SetMiscConfigGroup(false, MOD.SetUnitFrame, "player"),
		health = ns:SetHealthConfigGroup(false, MOD.SetUnitFrame, "player"), 
		power = ns:SetPowerConfigGroup(true, MOD.SetUnitFrame, "player"), 
		name = ns:SetNameConfigGroup(MOD.SetUnitFrame, "player"), 
		portrait = ns:SetPortraitConfigGroup(MOD.SetUnitFrame, "player"), 
		buffs = ns:SetAuraConfigGroup(true, "buffs", false, MOD.SetUnitFrame, "player"), 
		debuffs = ns:SetAuraConfigGroup(true, "debuffs", false, MOD.SetUnitFrame, "player"), 
		castbar = ns:SetCastbarConfigGroup(MOD.SetUnitFrame, "player"), 
		aurabar = ns:SetAurabarConfigGroup(true, MOD.SetUnitFrame, "player"), 
		icons = ns:SetIconConfigGroup(MOD.SetUnitFrame, "player"), 
		classbar = {
			order = 1000,
			type = "group",
			name = L["Classbar"],
			get = function(l)return SV.db.SVUnit["player"]["classbar"][l[#l]]end,
			set = function(l, m)MOD:ChangeDBVar(m, l[#l], "player", "classbar");MOD:SetUnitFrame("player")end,
			args = {
				enable = {
					type = "toggle",
					order = 1,
					name = L["Classbar Enabled"]
				},
				detachFromFrame = {
					type = "toggle",
					order = 2,
					name = L["Detach From Frame"]
				},
				height = {
					type = "range",
					order = 4,
					name = L["Classbar Height (Size)"],
					min = 15,
					max = 45,
					step = 1
				},
			}
		}
	}
}

if(SV.class == "MONK") then
	SV.Options.args.SVUnit.args.commonGroup.args.player.args.classbar.args.stagger = {
		type = "toggle",
		order = 3,
		name = L["Stagger Bar"],
		get = function(l)return SV.db.SVUnit["player"]["stagger"].enable end,
		set = function(l, m)MOD:ChangeDBVar(m, "enable", "player", "stagger");MOD:SetUnitFrame("player")end,
	}
end
if(SV.class == "DRUID") then
	SV.Options.args.SVUnit.args.commonGroup.args.player.args.classbar.args.druidMana = {
		type = "toggle", 
		order = 3, 
		name = L["Druid Mana"], 
		desc = L["Display druid mana bar when in cat or bear form and when mana is not 100%."],
		get = function(key) 
			return SV.db.SVUnit["player"]["power"].druidMana 
		end, 
		set = function(key, value)
			MOD:ChangeDBVar(value, "druidMana", "player", "power");
			MOD:SetUnitFrame("player")
		end,
	}
end