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
local MOD = SV.SVMap
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local textSelect = {
	['HIDE'] = L['Hide This'], 
	['CUSTOM'] = L['Use Custom Style'], 
	['SIMPLE'] = L['Use Simple Style']
};
local colorSelect = {
	['light'] = L['Light'], 
	['dark'] = L['Dark'], 
	['class'] = L['Class']
};
--[[ 
########################################################## 
OPTIONS TABLE
##########################################################
]]--
SV.Options.args.SVMap = {
	type = 'group',
	childGroups = "tree", 
	name = MOD.TitleID,
	get = function(a)return SV.db.SVMap[a[#a]]end,
	set = function(a,b)MOD:ChangeDBVar(b,a[#a]);MOD:ReLoad()end,
	args={
		intro={
			order = 1,
			type = 'description',
			name = L["Options for the Minimap"]
		},
		enable={
			type = "toggle",
			order = 2,
			name = L['Enable'],
			desc = L['Enable/Disable the Custom Minimap.'],
			get = function(a)return SV.db.SVMap.enable end,
			set = function(a,b)SV.db.SVMap.enable=b; SV:StaticPopup_Show("RL_CLIENT") end
		},
		common = {
			order = 3,
			type = "group", 
			name = MINIMAP_LABEL,
			desc = L['General display settings'],
			guiInline = true,
			disabled = function()return not SV.db.SVMap.enable end,
			args = {
				size = {
					order = 1,
					type = "range",
					name = L["Size"],
					desc = L['Adjust the size of the minimap.'],
					min = 120,
					max = 240,
					width = "full",
					step = 1
				},
				bordersize = {
					order = 2,
					type = "range",
					name = "Border Size",
					desc = "Adjust the size of the minimap's outer border",
					min = 0,
					max = 20,
					step = 1,
					width = "full"
				},
				bordercolor = {
					order = 3,
					type = 'select',
					name = "Border Color",
					desc = "Adjust the color of the minimap's outer border",
					values = colorSelect,
				},
				customshape = {
					order = 4,
					type = "toggle",
					name = "Custom Shape",
					desc = "Toggle the use of either rectangular or square minimap.",
				},
				customIcons = {
					order = 5,
					type = "toggle",
					name = "Custom Blip Icons",
					desc = "Toggle the use of special map blips.",
					set = function(a,b) MOD:ChangeDBVar(b,a[#a]); SV:StaticPopup_Show("RL_CLIENT") end
				}
			}
		},
		spacer1 = {
			order = 4,
			type = "group", 
			name = "",
			guiInline = true, 
			args = {} 
		},
		common2 = {
			order = 5,
			type = "group", 
			name = "Labels and Info",
			desc = L['Configure various minimap texts'],
			guiInline = true,
			disabled = function()return not SV.db.SVMap.enable end,
			args = {
				locationText = {
					order = 1,
					type = "select",
					name = L["Location Text"],
					values = textSelect,
					set = function(a,b)MOD:ChangeDBVar(b,a[#a])MOD:ReLoad()end
				},
				playercoords = {
					order = 2,
					type = "select",
					name = L["Player Coords"],
					values = textSelect,
					set = function(a,b)MOD:ChangeDBVar(b,a[#a])MOD:ReLoad()end
				}
			}
		},
		spacer2 = {
			order = 6,
			type = "group", 
			name = "",
			guiInline = true, 
			args = {}
		},
		mmButtons = {
			order = 7,
			type = "group",
			name = "Minimap Buttons",
			get = function(j)return SV.db.SVMap.minimapbar[j[#j]]end,
			guiInline = true,
			disabled = function()return not SV.db.SVMap.enable end,
			args = {
				enable = {
					order = 1,
					type = 'toggle',
					name = L['Buttons Styled'],
					desc = L['Style the minimap buttons.'],
					set = function(a,b)MOD:ChangeDBVar(b,a[#a],"minimapbar")SV:StaticPopup_Show("RL_CLIENT")end,
				},
				mouseover = {
					order = 2, 
					name = L["Mouse Over"], 
					desc = L["Hidden unless you mouse over the frame."], 
					type = "toggle",
					set = function(a,b)MOD:ChangeDBVar(b,a[#a],"minimapbar")MOD:UpdateMinimapButtonSettings()end,
				},
				styleType = {
					order = 3,
					type = 'select',
					name = L['Button Bar Layout'],
					desc = L['Change settings for how the minimap buttons are styled.'],
					set = function(a,b)MOD:ChangeDBVar(b,a[#a],"minimapbar")MOD:UpdateMinimapButtonSettings()end,
					disabled = function()return not SV.db.SVMap.minimapbar.enable end,
					values = {
						['NOANCHOR'] = L['No Anchor Bar'],
						['HORIZONTAL'] = L['Horizontal Anchor Bar'],
						['VERTICAL'] = L['Vertical Anchor Bar']
					}
				},
				buttonSize = {
					order = 4,
					type = 'range',
					name = L['Buttons Size'],
					desc = L['The size of the minimap buttons.'],
					min = 16,
					max = 40,
					step = 1,
					width = "full",
					set = function(a,b)MOD:ChangeDBVar(b,a[#a],"minimapbar")MOD:UpdateMinimapButtonSettings()end,
					disabled = function()return not SV.db.SVMap.minimapbar.enable or SV.db.SVMap.minimapbar.styleType == 'NOANCHOR'end
				},
			}
		},
		spacer3 = {
			order = 8,
			type = "group", 
			name = "",
			guiInline = true, 
			args = {}
		},
		worldMap = {
			order = 9,
			type = "group",
			name = "WorldMap",
			guiInline = true, 
			args = {
				tinyWorldMap = {
					order = 1,
					type = "toggle",
					name = L["Tiny Map"],
					desc = L["Don't scale the large world map to block out sides of the screen."],
					set = function(a,b)MOD:ChangeDBVar(b,a[#a])MOD:ReLoad()end
				},
			}
		},  
	}
}