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

local MOD = SV.SVBag

local pointList = {
	["TOPLEFT"] = "TOPLEFT",
	["TOPRIGHT"] = "TOPRIGHT",
	["BOTTOMLEFT"] = "BOTTOMLEFT",
	["BOTTOMRIGHT"] = "BOTTOMRIGHT",
}

SV.Options.args.SVBag = {
	type = 'group',
	name = MOD.TitleID,
	childGroups = "tab",
	get = function(a)return SV.db.SVBag[a[#a]]end,
	set = function(a,b)MOD:ChangeDBVar(b,a[#a]) end,
	args = {
		intro = {
			order = 1, 
			type = "description", 
			name = L["BAGS_DESC"]
		},
		enable = {
			order = 2, 
			type = "toggle", 
			name = L["Enable"], 
			desc = L["Enable/Disable the all-in-one bag."],
			get = function(a)return SV.db.SVBag.enable end,
			set = function(a,b)SV.db.SVBag.enable = b;SV:StaticPopup_Show("RL_CLIENT")end
		},
		bagGroups={
			order = 3,
			type = 'group',
			name = L['Bag Options'],
			guiInline = true, 
			args = {
				common={
					order = 1, 
						type = "group",
						guiInline = true, 
						name = L["General"], 
						disabled = function()return not SV.db.SVBag.enable end, 
						args = {
						bagSize = {
							order = 1, 
							type = "range", 
							name = L["Button Size (Bag)"], 
							desc = L["The size of the individual buttons on the bag frame."], 
							min = 15, 
							max = 45, 
							step = 1, 
							set = function(a,b) MOD:ChangeDBVar(b,a[#a]) MOD:RefreshBagFrames("BagFrame") end,
							disabled = function()return SV.db.SVBag.alignToChat end
						},
						bankSize = {
							order = 2, 
							type = "range", 
							name = L["Button Size (Bank)"], 
							desc = L["The size of the individual buttons on the bank frame."], 
							min = 15, 
							max = 45, 
							step = 1, 
							set = function(a,b) MOD:ChangeDBVar(b,a[#a]) MOD:RefreshBagFrames("BankFrame") end,
							disabled = function()return SV.db.SVBag.alignToChat end
						},
						bagWidth = {
							order = 3, 
							type = "range", 
							name = L["Panel Width (Bags)"], 
							desc = L["Adjust the width of the bag frame."], 
							min = 150, 
							max = 700, 
							step = 1, 
							set = function(a,b) MOD:ChangeDBVar(b,a[#a]) MOD:RefreshBagFrames("BagFrame") end, 
							disabled = function()return SV.db.SVBag.alignToChat end
						},
						bankWidth = {
							order = 4, 
							type = "range", 
							name = L["Panel Width (Bank)"], 
							desc = L["Adjust the width of the bank frame."], 
							min = 150, 
							max = 700, 
							step = 1, 
							set = function(a,b) MOD:ChangeDBVar(b,a[#a]) MOD:RefreshBagFrames("BankFrame") end, 
							disabled = function() return SV.db.SVBag.alignToChat end
						},
						currencyFormat = {
							order = 5, 
							type = "select", 
							name = L["Currency Format"], 
							desc = L["The display format of the currency icons that get displayed below the main bag. (You have to be watching a currency for this to display)"], 
							values = {
								["ICON"] = L["Icons Only"], 
								["ICON_TEXT"] = L["Icons and Text"]
							},
							set = function(a,b)MOD:ChangeDBVar(b,a[#a]) MOD:RefreshTokens() end
						},
						sortInverted = {
							order = 6, 
							type = "toggle", 
							name = L["Sort Inverted"], 
							desc = L["Direction the bag sorting will use to allocate the items."]
						},
						bagTools = {
							order = 7, 
							type = "toggle", 
							name = L["Profession Tools"], 
							desc = L["Enable/Disable Prospecting, Disenchanting and Milling buttons on the bag frame."], 
							set = function(a,b)MOD:ChangeDBVar(b,a[#a])SV:StaticPopup_Show("RL_CLIENT")end
						},
					}
				},
				position = {
					order = 2, 
					type = "group", 
					guiInline = true, 
					name = L["Bag/Bank Positioning"], 
					disabled = function()return not SV.db.SVBag.enable end, 
					args = {
						alignToChat = {
							order = 1, 
							type = "toggle", 
							name = L["Align To Docks"], 
							desc = L["Align the width of the bag frame to fit inside dock windows."], 
							set = function(a,b)MOD:ChangeDBVar(b,a[#a]) MOD:RefreshBagFrames() end
						},
						bags = {
							order = 2, 
							type = "group", 
							name = L["Bag Position"],
							guiInline = true, 
							get = function(key) return SV.db.SVBag.bags[key[#key]] end,
							set = function(key, value) MOD:ChangeDBVar(value, key[#key], "bags"); MOD:ModifyBags() end,
							disabled = function() return not SV.db.SVBag.enable end, 
							args = {
								point = {
									order = 1, 
									name = L["Anchor Point"], 
									type = "select",
									values = pointList, 
								},
								xOffset = {
									order = 2, 
									type = "range", 
									name = L["X Offset"],
									min = -600, 
									max = 600, 
									step = 1,
								},
								yOffset = {
									order = 3, 
									type = "range", 
									name = L["Y Offset"],
									min = -600, 
									max = 600, 
									step = 1,
								},
							}
						},
						bank = {
							order = 3, 
							type = "group", 
							name = L["Bank Position"],
							guiInline = true, 
							get = function(key) return SV.db.SVBag.bank[key[#key]] end,
							set = function(key, value) MOD:ChangeDBVar(value, key[#key], "bank"); MOD:ModifyBags() end,
							disabled = function() return not SV.db.SVBag.enable end, 
							args = {
								point = {
									order = 1, 
									name = L["Anchor Point"], 
									type = "select",
									values = pointList, 
								},
								xOffset = {
									order = 2, 
									type = "range", 
									name = L["X Offset"],
									min = -600, 
									max = 600, 
									step = 1,
								},
								yOffset = {
									order = 3, 
									type = "range", 
									name = L["Y Offset"],
									min = -600, 
									max = 600, 
									step = 1,
								},
							}
						},	
					}
				},

				bagBar = {
					order = 4,
					type = "group",
					name = L["Bag-Bar"],
					guiInline = true, 
					get = function(key) return SV.db.SVBag.bagBar[key[#key]] end,
					set = function(key, value) MOD:ChangeDBVar(value, key[#key], "bagBar"); MOD:ModifyBagBar() end,
					args={
						enable = {
							order = 1,
							type = "toggle",
							name = L["Bags Bar Enabled"],
							desc = L["Enable/Disable the Bag-Bar."],
							get = function() return SV.db.SVBag.bagBar.enable end,
							set = function(key, value) MOD:ChangeDBVar(value, key[#key], "bagBar"); SV:StaticPopup_Show("RL_CLIENT")end
						},
						mouseover = {
							order = 2, 
							name = L["Mouse Over"], 
							desc = L["Hidden unless you mouse over the frame."], 
							type = "toggle"
						},
						showBackdrop = {
							order = 3, 
							name = L["Backdrop"], 
							desc = L["Show/Hide bag bar backdrop"], 
							type = "toggle"
						},
						spacer = {
							order = 4, 
							name = "", 
							type = "description", 
							width = "full", 
						},
						size = {
							order = 5, 
							type = "range", 
							name = L["Button Size"], 
							desc = L["Set the size of your bag buttons."], 
							min = 24, 
							max = 60, 
							step = 1
						},
						spacing = {
							order = 6, 
							type = "range", 
							name = L["Button Spacing"], 
							desc = L["The spacing between buttons."], 
							min = 1, 
							max = 10, 
							step = 1
						},
						sortDirection = {
							order = 7, 
							type = "select", 
							name = L["Sort Direction"], 
							desc = L["The direction that the bag frames will grow from the anchor."], 
							values = {
								["ASCENDING"] = L["Ascending"], 
								["DESCENDING"] = L["Descending"]
							}
						},
						showBy = {
							order = 8, 
							type = "select", 
							name = L["Bar Direction"], 
							desc = L["The direction that the bag frames be (Horizontal or Vertical)."], 
							values = {
								["VERTICAL"] = L["Vertical"], 
								["HORIZONTAL"] = L["Horizontal"]
							}
						}
					}
				}
			}
		}
	}
}