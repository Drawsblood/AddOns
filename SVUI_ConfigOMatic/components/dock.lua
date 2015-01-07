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
local MOD = SV.Dock
local CHAT = SV.SVChat
local BAG = SV.SVBag

SV.Options.args.Dock = {
  type = "group", 
  name = MOD.TitleID, 
  args = {}
}

SV.Options.args.Dock.args["intro"] = {
	order = 1, 
	type = "description", 
	name = "Configure the various frame docks around the screen"
};

SV.Options.args.Dock.args["common"] = {
	order = 2,
	type = "group",
	name = "General",
	guiInline = true,
	get = function(key)return SV.db.Dock[key[#key]];end, 
	set = function(key,value)
		MOD:ChangeDBVar(value,key[#key]);
		MOD:Refresh()
	end, 
	args = {
		bottomPanel = {
			order = 1,
			type = 'toggle',
			name = L['Bottom Panel'],
			desc = L['Display a border across the bottom of the screen.'],
			get = function(j)return SV.db.Dock.bottomPanel end,
			set = function(key,value)MOD:ChangeDBVar(value,key[#key]);MOD:BottomBorderVisibility()end
		},
		topPanel = {
			order = 2,
			type = 'toggle',
			name = L['Top Panel'],
			desc = L['Display a border across the top of the screen.'],
			get = function(j)return SV.db.Dock.topPanel end,
			set = function(key,value)MOD:ChangeDBVar(value,key[#key]);MOD:TopBorderVisibility()end
		},
		time24 = {
			order = 3, 
			type = "toggle", 
			name = L["24-Hour Time"], 
			desc = L["Toggle 24-hour mode for the time datatext."],
		}, 
		localtime = {
			order = 4, 
			type = "toggle", 
			name = L["Local Time"], 
			desc = L["If not set to true then the server time will be displayed instead."]
		}, 
		battleground = {
			order = 5, 
			type = "toggle", 
			name = L["Battleground Texts"], 
			desc = L["When inside a battleground display personal scoreboard information on the main datatext bars."]
		}, 
		dataBackdrop = {
			order = 6, 
			name = "Show Backgrounds", 
			desc = L["Display statistic background textures"], 
			type = "toggle",
			set = function(key, value) MOD:ChangeDBVar(value, key[#key]); SV:StaticPopup_Show("RL_CLIENT") end,
		},
		shortGold = {
			order = 7, 
			type = "toggle", 
			name = L["Shortened Gold Text"], 
		},
		spacer1 = {
			order = 9, 
			name = "", 
			type = "description", 
			width = "full", 
		},
		dockCenterWidth = {
			order = 10,
			type = 'range',
			name = L['Stat Panel Width'],
			desc = L["PANEL_DESC"], 
			min = 400, 
			max = 1800, 
			step = 1,
			width = "full",
			get = function()return SV.db.Dock.dockCenterWidth; end, 
			set = function(key,value)
				MOD:ChangeDBVar(value,key[#key]);
				MOD:Refresh()
			end, 
		},
		spacer2 = {
			order = 11, 
			name = "", 
			type = "description", 
			width = "full", 
		},
		buttonSize = {
			order = 12, 
			type = "range", 
			name = L["Dock Button Size"], 
			desc = L["PANEL_DESC"], 
			min = 20, 
			max = 80, 
			step = 1,
			width = "full",
			get = function()return SV.db.Dock.buttonSize;end, 
			set = function(key,value)
				MOD:ChangeDBVar(value,key[#key]);
				MOD:Refresh()
			end, 
		},
	}
};

SV.Options.args.Dock.args["leftDockGroup"] = {
	order = 3, 
	type = "group", 
	name = L["Left Dock"], 
	guiInline = true, 
	args = {
		leftDockBackdrop = {
			order = 1,
			type = 'toggle',
			name = L['Left Dock Backdrop'],
			desc = L['Display a backdrop behind the left-side dock.'],
			get = function(j)return SV.db.Dock.leftDockBackdrop end,
			set = function(key,value)
				MOD:ChangeDBVar(value,key[#key]);
				MOD:UpdateDockBackdrops()
			end
		},
		dockLeftHeight = {
			order = 2, 
			type = "range", 
			name = L["Left Dock Height"], 
			desc = L["PANEL_DESC"], 
			min = 150, 
			max = 600, 
			step = 1,
			width = "full",
			get = function()return SV.db.Dock.dockLeftHeight;end, 
			set = function(key,value)
				MOD:ChangeDBVar(value,key[#key]);
				MOD:Refresh()
				CHAT:UpdateLocals()
				CHAT:RefreshChatFrames(true)
			end, 
		},
		dockLeftWidth = {
			order = 3, 
			type = "range", 
			name = L["Left Dock Width"], 
			desc = L["PANEL_DESC"],  
			min = 150, 
			max = 700, 
			step = 1,
			width = "full",
			get = function()return SV.db.Dock.dockLeftWidth;end, 
			set = function(key,value)
				MOD:ChangeDBVar(value,key[#key]);
				MOD:Refresh()
				CHAT:UpdateLocals()
				CHAT:RefreshChatFrames(true)
			end,
		},
	}
};

SV.Options.args.Dock.args["rightDockGroup"] = {
	order = 4, 
	type = "group", 
	name = L["Right Dock"], 
	guiInline = true, 
	args = {
		rightDockBackdrop = {
			order = 1,
			type = 'toggle',
			name = L['Right Dock Backdrop'],
			desc = L['Display a backdrop behind the right-side dock.'],
			get = function(j)return SV.db.Dock.rightDockBackdrop end,
			set = function(key,value)
				MOD:ChangeDBVar(value, key[#key]);
				MOD:UpdateDockBackdrops()
			end
		},
		dockRightHeight = {
			order = 2, 
			type = "range", 
			name = L["Right Dock Height"], 
			desc = L["PANEL_DESC"], 
			min = 150, 
			max = 600, 
			step = 1,
			width = "full",
			get = function()return SV.db.Dock.dockRightHeight;end, 
			set = function(key,value)
				MOD:ChangeDBVar(value,key[#key]);
				MOD:Refresh()
				CHAT:UpdateLocals()
				CHAT:RefreshChatFrames(true)
			end, 
		},
		dockRightWidth = {
			order = 3, 
			type = "range", 
			name = L["Right Dock Width"], 
			desc = L["PANEL_DESC"],  
			min = 150, 
			max = 700, 
			step = 1,
			width = "full",
			get = function()return SV.db.Dock.dockRightWidth;end, 
			set = function(key,value)
				MOD:ChangeDBVar(value,key[#key]);
				MOD:Refresh()
				CHAT:UpdateLocals()
				CHAT:RefreshChatFrames(true)
				BAG.BagFrame:UpdateLayout()
				BAG.BankFrame:UpdateLayout()
			end,
		},
		-- quest = {
		-- 	order = 4, 
		-- 	type = "group", 
		-- 	name = L['Quest Watch Docklet'], 
		-- 	args = {
		-- 		enable = {
		-- 			order = 1,
		-- 			type = "toggle",
		-- 			name = L["Enable"],
		-- 			get = function()return SV.db.SVQuest.enable end,
		-- 		 	set = function(j, value) SV.db.SVQuest.enable = value; SV:StaticPopup_Show("RL_CLIENT") end
		-- 		}
		-- 	}
		-- },
		-- questHeaders = {
		-- 	order = 5, 
		-- 	type = "group", 
		-- 	name = L['Quest Header Styled'], 
		-- 	args = {
		-- 		enable = {
		-- 			order = 1,
		-- 			type = "toggle",
		-- 			name = L["Enable"],
		-- 			get = function()return SV.db.general.questHeaders end,
		-- 		 	set = function(j, value) SV.db.general.questHeaders = value; SV:StaticPopup_Show("RL_CLIENT") end,
		-- 		 	disabled = function()return (not SV.db.SVQuest.enable) end, 
		-- 		}
		-- 	}
		-- }
	}
};

SV.Options.args.Dock.args["SVUI_DockTopCenter"] = {
	order = 5,
	type = "group", 
	name = L["Top Dock"], 
	guiInline = true,  
	args = {}
};

SV.Options.args.Dock.args["SVUI_DockBottomCenter"] = {
	order = 6,
	type = "group", 
	name = L["Bottom Dock"], 
	guiInline = true, 
	args = {}
}


do
	local statValues = {[""] = "None"};
	local configTable = SV.db.Dock.dataHolders;

	for name, _ in pairs(MOD.DataTypes) do
		statValues[name] = name;
	end

	for panelName, panelPositions in pairs(configTable) do
		local optionTable = SV.Options.args.Dock.args; 
		if(not _G[panelName]) then 
			print(panelName)
			optionTable[panelName] = nil;
			return 
		end 
		if(type(panelPositions) == "table") then 
			for i = 1, #panelPositions do 
				local slotName = 'Slot' .. i;
				optionTable[panelName].args[slotName] = {
					order = i,
					type = 'select',
					name = 'Slot '..i,
					values = statValues,
					get = function(key) return SV.db.Dock.dataHolders[panelName][i] end,
					set = function(key, value) MOD:ChangeDBVar(value, i, "dataHolders", panelName); MOD:UpdateDataSlots() end
				}
			end 
		end 
	end 
end 

if(MOD.CustomOptions) then
	SV.Options.args.Dock.args["AddonDocklets"] = {
		order = 7,
		type = "group", 
		name = L["Docked Addons"], 
		guiInline = true,  
		args = MOD.CustomOptions
	};
end