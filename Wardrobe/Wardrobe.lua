--[[

	Wardrobe-AL

	By AnduinLothar karlkfi@yahoo.com

	Wardrobe lets you define equipment profiles
	(called "outfits") and lets you switch among them on the fly.
	For example, you can define a Normal Outfit that consists of
	your regular equipment, an Around Town Outfit that consists of
	what you'd like to wear when inside a city or roleplaying, a
	Stamina Outfit that consists of all your best +stam gear, etc.
	You can then switch amongst these outfits using a simple slash chat
	command (/wardrobe wear Around Town Outfit), or using a small
	interactive button docked beneath your radar.

]]--


WardrobeAce = LibStub("AceAddon-3.0"):NewAddon("Wardrobe", "AceConsole-3.0","AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Wardrobe")
local TipHooker = LibStub("LibTipHooker-1.1")
local BZ = LibStub("LibBabble-Zone-3.0"):GetUnstrictLookupTable()

local _;

--WardrobeAce.FuBarPlugin = {};
WardrobeAce.Wardrobe = {};
Wardrobe = WardrobeAce.Wardrobe;


---------------------------------------------------------------------------------
-- Info
---------------------------------------------------------------------------------

local WARDROBE_VERSION					= "3.42";

---------------------------------------------------------------------------------
-- Localization Registration
---------------------------------------------------------------------------------

--Localization.SetAddonDefault("Wardrobe", "enUS");
--Localization.AssignAddonGlobalStrings("Wardrobe");	--For Bindings
function Wardrobe.GetString(key)
	return WardrobeText[WARDROBE_LOCALE][key] or WardrobeText["enUS"][key]
end

local TEXT = Wardrobe.GetString;

Wardrobe.XMLTextAssignment = {
	Wardrobe_NamePopupText				= "POPUP_TITLE";
	Wardrobe_PopupConfirmText			= "POPUP_TITLE";
	Wardrobe_NamePopupAcceptButton		= "TXT_ACCEPT";
	Wardrobe_PopupConfirmAcceptButton	= "TXT_ACCEPT";
	Wardrobe_NamePopupCancelButton		= "TXT_CANCEL";
	Wardrobe_PopupConfirmCancelButton	= "TXT_CANCEL";
	Wardrobe_CheckboxToggle				= "TXT_UPDATE";
	Wardrobe_CheckboxAccept				= "TXT_ACCEPT";
	Wardrobe_CheckboxColorpick			= "TXT_COLOR";
	Wardrobe_MainMenuFrameTitle			= "TXT_EDITOUTFITS";
	Wardrobe_MainMenuFrameNewButton	 	 = "TXT_NEW";
	Wardrobe_MainMenuFrameSettingsButton = "TXT_SETTINGS";
	Wardrobe_MainMenuFrameCloseButton	= "TXT_CLOSE";
	Wardrobe_ColorPickFrameTitle		= "TXT_SELECTCOLOR";
	Wardrobe_ColorPickFrameOKButton		= "TXT_OK";
	Wardrobe_ColorPickFrameCancelButton	= "TXT_CANCEL";
}

function Wardrobe.UpdateXMLText()
	local frame;
	for frameName, key in pairs(Wardrobe.XMLTextAssignment) do
		frame = getglobal(frameName);
		if (frame) then
			frame:SetText(Wardrobe.GetString(key));
		else
			--print(frameName)
		end
	end
end

--Localization.RegisterCallback("WardrobeXML", Wardrobe.UpdateXMLText);

---------------------------------------------------------------------------------
-- Variables
---------------------------------------------------------------------------------

Wardrobe.DEBUG_MODE						= false;

WARDROBE_NUM_POPUP_FUNCTION_BUTTONS	= 1;

WARDROBE_TEMP_OUTFIT_NAME			= "#temp#";

WARDROBE_LOCALE = GetLocale();
if (WARDROBE_LOCALE ~= "enUS" and WARDROBE_LOCALE ~= "deDE" and WARDROBE_LOCALE ~= "frFR") then
	WARDROBE_LOCALE = "enUS";
end

local WARDROBE_UNMOUNT_OUTFIT_NAME			= "#unmount#";
local WARDROBE_UNPLAGUE_OUTFIT_NAME			= "#unplague#";
local WARDROBE_DONEEATING_OUTFIT_NAME		= "#uneating#";
local WARDROBE_DONESWIMMING_OUTFIT_NAME		= "#unswimming#";

Wardrobe.SpecialOutfitVirtualNames = {
	-- [specialID] -> virtualOutfitName
	["mount"] = WARDROBE_UNMOUNT_OUTFIT_NAME,
	["eat"] = WARDROBE_DONEEATING_OUTFIT_NAME,
	["plague"] = WARDROBE_UNPLAGUE_OUTFIT_NAME,
	["swim"] = WARDROBE_DONESWIMMING_OUTFIT_NAME
};

Wardrobe.SpecialOutfitVirtualIDs = {
	-- [virtualOutfitName] -> specialID
	[WARDROBE_UNMOUNT_OUTFIT_NAME] = "mount",
	[WARDROBE_DONEEATING_OUTFIT_NAME] = "eat",
	[WARDROBE_UNPLAGUE_OUTFIT_NAME] = "plague",
	[WARDROBE_DONESWIMMING_OUTFIT_NAME] = "swim"
};

Wardrobe.WaitingListVirtualNames = {
	-- [specialID] -> virtualOutfitName
	["mount"] = {id="mount",toggle=true, inherit=WARDROBE_UNPLAGUE_OUTFIT_NAME},
	["unmount"] = {id="mount",toggle= false, inherit=WARDROBE_UNPLAGUE_OUTFIT_NAME},
	["eat"] = {id="eat",toggle=true},
	["uneat"] = {id="eat",toggle=false},
	["plague"] = {id="plague",toggle=true,exception=function() return Wardrobe.IsMounted() end, inherit=WARDROBE_UNMOUNT_OUTFIT_NAME},
	["unplague"] = {id="plague",toggle=false,exception=function() return Wardrobe.IsMounted() end, inherit=WARDROBE_UNMOUNT_OUTFIT_NAME},
	["swim"] = {id="swim",toggle=true},
	["unswim"] = {id="swim",toggle= false}
};

WARDROBE_MAX_SCROLL_ENTRIES		 = 10;

WARDROBE_NOISY				= false;

function Wardrobe.GetPlagueZones()
	return {
		TEXT("TXT_WPLAGUELANDS");
		TEXT("TXT_EPLAGUELANDS");
		TEXT("TXT_STRATHOLME");
		TEXT("TXT_SCHOLOMANCE");
	}
end

Wardrobe.FishingItems = {
		[44050] = "MainHandSlot",
		[33820] = "HeadSlot",
		[25978] = "MainHandSlot",
		[19972] = "MainHandSlot",
		[6367] =  "MainHandSlot",
		[19970] = "MainHandSlot",
		[6366] =  "MainHandSlot",
		[6365] =  "MainHandSlot",
		[12225] = "MainHandSlot",
		[6256] =  "MainHandSlot",
		[45858] = "MainHandSlot"
}

WARDROBE_DEFAULT_BUTTON_COLOR = 11;  -- corresponds to the entry in WARDROBE_CONSTANTS_TEXTCOLORS (in this case, #11 is green)

Wardrobe.InventorySlots = {
	"HeadSlot",
	"NeckSlot",
	"ShoulderSlot",
	"BackSlot",
	"ChestSlot",
	"ShirtSlot",
	"TabardSlot",
	"WristSlot",
	"HandsSlot",
	"WaistSlot",
	"LegsSlot",
	"FeetSlot",
	"Finger0Slot",
	"Finger1Slot",
	"Trinket0Slot",
	"Trinket1Slot",
	"MainHandSlot",
	"SecondaryHandSlot"
--	"RangedSlot"
};

Wardrobe.InventorySlotIDs = {
	GetInventorySlotInfo("HeadSlot"),
	GetInventorySlotInfo("NeckSlot"),
	GetInventorySlotInfo("ShoulderSlot"),
	GetInventorySlotInfo("BackSlot"),
	GetInventorySlotInfo("ChestSlot"),
	GetInventorySlotInfo("ShirtSlot"),
	GetInventorySlotInfo("TabardSlot"),
	GetInventorySlotInfo("WristSlot"),
	GetInventorySlotInfo("HandsSlot"),
	GetInventorySlotInfo("WaistSlot"),
	GetInventorySlotInfo("LegsSlot"),
	GetInventorySlotInfo("FeetSlot"),
	GetInventorySlotInfo("Finger0Slot"),
	GetInventorySlotInfo("Finger1Slot"),
	GetInventorySlotInfo("Trinket0Slot"),
	GetInventorySlotInfo("Trinket1Slot"),
	GetInventorySlotInfo("MainHandSlot"),
	GetInventorySlotInfo("SecondaryHandSlot")
--	GetInventorySlotInfo("RangedSlot")
 };

Wardrobe.DisplayToggleableInventorySlots = {
	[GetInventorySlotInfo("HeadSlot")] = {name="HeadSlot",toggle=function(toMode) Wardrobe.ShowHelm(toMode) end,isShown=function() return (ShowingHelm()==true) end},
	[GetInventorySlotInfo("BackSlot")] = {name="BackSlot",toggle=function(toMode) Wardrobe.ShowCloak(toMode) end,isShown=function() return (ShowingCloak()==true) end}
};

function Wardrobe.ShowHelm(toMode)
 	if(toMode == 0 or toMode == false) then 
		ShowHelm(false);
 	else 
 		ShowHelm(true) 
 	end
end

function Wardrobe.ShowCloak(toMode)
 	if(toMode == 0 or toMode == false) then 
 		ShowCloak(false) 
 	else 
 		ShowCloak(true) 
 	end
 end

Wardrobe.InventorySlotsSize = #(Wardrobe.InventorySlots)

local CraftableItemIDs = {
-- These item id's will ignore suffix
	[1254]	= true;		--Lesser Firestone
	[13699]	= true;		--Firestone
	[13700]	= true;		--Greater Firestone
	[13701]	= true;		--Major Firestone

	[5522]	= true;		--Spellstone
	[13602]	= true;		--Greater Spellstone
	[13603]	= true;		--Major Spellstone
};

Wardrobe.Battlegrounds = {
	["Silverwing Hold"] = true,
	[BZ["Warsong Gulch"]] = true,
	[BZ["Arathi Basin"]] = true,
	[BZ["Alterac Valley"]] = true,
	[BZ["Eye of the Storm"]] = true,
	[BZ["Blade's Edge Arena"]] = true,
	[BZ["Nagrand Arena"]] = true,
	[BZ["Ruins of Lordaeron"]] = true,
	[BZ["Dalaran Sewers"]] = true,
	[BZ["The Ring of Valor"]] = true,
	[BZ["Strand of the Ancients"]] = true,
	[BZ["Dalaran Arena"]] = true,
	[BZ["Isle of Conquest"]] = true,
	[BZ["Twin Peaks"]] = true,
	[BZ["The Battle for Gilneas"]] = true,
};

Wardrobe.TravelStances = {
	["Travel Form"] = true,
	["Flight Form"] = true,
	["Swift Flight Form"] = true,
};


-- the variable that stores all the wardrobe info
-- and gets saved when you quit the game
Wardrobe_Config                         = {}
Wardrobe_Config.Enabled					= true;
--Wardrobe_Config.xOffset					= 10;
--Wardrobe_Config.yOffset					= 39;
--Wardrobe_Config.DefaultCheckboxState	= 1;        -- default state for the checkboxes when specifying what equipment slots make up an outfit on the character paperdoll screen
--Wardrobe_Config.MustClickUIButton		= false;   	-- true if we must click the wardrobe UI button to show the menu
--Wardrobe_Config.DragLock				= false;	-- true if we're not allowed to drag the wardrobe UI button
--Wardrobe_Config.Tooltips                = true;
--Wardrobe_Config.RightClickOpenFunction  = 2;
--Wardrobe_Config.DropDownScale           = UIParent:GetScale();
Wardrobe_Config.version					= WARDROBE_VERSION;

-- Wardrobe_Config_FuBar = {}

local db_Defaults = {
	char = {
		version = nil,
		enabled = true,
		defaultCheckboxState = nil,
		tooltips = true,
		mustClickUIButton = false,
		dropDownScale = UIParent:GetScale(),
		opacity = 1.0,
		AutoSwap = true,
		AutoSwapInBG = false,
		AutoSwapInWG = false,
		xOffset = nil,
		yOffset = nil,
		dragLock = false,
		showMiniMapIcon = true,
		miniMapRightClickOpens = 2;
		lastHelmDisplayState = nil;
		lastCloakDisplayState = nil;
		showHelmCloakFunctionEnabled = false;
		defaultHelmState = 1;
		defaultCloakState = 1;

		ldb = {
--			enabled = true,
			showTextPrefix = true,
			rightClickOpens = 3,
		},
	},
	profile = {
		version = nil,
		xOffset = 10,
		yOffset = 39,
		defaultCheckboxState = 1;
		SoundWhileSwapping = true,
		syncToEquipMgr = 0;
--[[
		fubar = {
			enabled = true,
			showTextPrefix = true,
			position = "RIGHT",
			rightClickOpens = 3,
			panelId = 1,
		},
]]--
		ldb = {
--			enabled = true,
			showTextPrefix = true,
			rightClickOpens = 3,
		},
		
	},
}

--local db = db_Defaults.profile
WardrobeAce.db = db_Defaults;

Wardrobe.MaxBarTextLen              = 20;       -- If FuBar or LDB text len is greater than this, shorten it and append "..."
Wardrobe.Current_Outfit				= 0;
Wardrobe.InventorySearchForward		= 1;
Wardrobe.AlreadySetCharactersWardrobeID = false;	-- set this to true once we've looked up this character's wardrobe info
Wardrobe.PopupFunction				= "";		-- tells the popup confirmation box what it's confirming (deleting an outfit, adding one, etc)
WARDROBE_CONSTANTS_POPUP_TITLE		= "";		-- the title of the popup confirmation box
Wardrobe.Rename_OldName				= "";		-- remembers original outfit name in case we cancel a rename
Wardrobe.BeingDragged				= false;	-- flag for dragging the wardrobe UI button
Wardrobe.InCombat					= false;	-- true if we're in combat
Wardrobe.RegenEnabled				= true;	 	-- true if we can't regen (usually means we're in combat)
Wardrobe.ShowingCharacterPanel		= false;	-- true if the character paperdoll frame is visible
Wardrobe.PressedAcceptButton		= false;	-- remembers if we pressed the accept button in case the character paperdoll frame closes via other means
Wardrobe.WaitingList 				= {};
Wardrobe.newChar                    = false;    -- if this was new character with no original profile, used to generate some default outfits for new players
Wardrobe.lastMount                  = nil;      -- state of last mount setting
Wardrobe.lastTravelForm             = nil;
Wardrobe.lastSpell                  = nil;      -- last spell being cast - used for autoswap logic
Wardrobe.IsInBGArena                = false;    -- true if we are in a Battleground or Arena Zone
Wardrobe.IsInWintergrasp            = false;    -- true if we are in Wintergrasp
Wardrobe.IsInTolBarad               = false;    -- true if we are in Tol Barad Peninsula
Wardrobe.LastCheckedTooltipItem     = {};       -- remember info in last item show in tooltip.
Wardrobe.EquipMgrSyncInProgress     = false;
Wardrobe.Loaded                     = false;    -- set to true when this is loaded and variables are definately in memory.


Wardrobe.RightClickOpenFunction = {
	[1] = {
		desc = L["Addon Settings"],
		func = function() WardrobeAce.ToggleConfig() end,
	},
	[2] = {
		desc = L["Edit Outfits"],
		func = function() Wardrobe.ToggleMainMenu() end,
	},
	[3] = {
		desc = L["Dewdrop menu"],
		func = function() end,
	}
}

WardrobeAce.LDB_RightClickOpenFunction = {
	[1] = {
		desc = L["Addon Settings"],
		func = function() WardrobeAce.ToggleConfig() end,
	},
	[2] = {
		desc = L["Edit Outfits"],
		func = function() Wardrobe.ToggleMainMenu() end,
	},
	[3] = {
		desc = L["DropDownMenu"],
		func = function()
				  UIDropDownMenu_Refresh(WardrobeAce.LDB.MenuFrame)
		 	 	  ToggleDropDownMenu(1, nil, WardrobeAce.LDB.MenuFrame, "cursor", -15, 20, "TOPRIGHT")
 			   end,
	}
}




--===

	AceConfigOptions = {
		type = "group",
		name = L["Wardrobe"],
		args = {
			General = {
				order = 2,
				type = "group",
				name = L["General Settings"],
				desc = L["General Settings"],
				args = {
					wardrobedesc = {
						type = "description",
						name = "Version "..WARDROBE_VERSION.."\n",
						width = "full",
						order = 0,
					},
					Enable = {
						name = L["Enable Wardrobe"],
						desc = L["Check to enable the plugin."],
						width = "full",
						type = "toggle",
						order = 5,
						get = function() return Wardrobe_Config.Enabled end,
						set = function(info, val)
						          if(val) then Wardrobe.Toggle(1, true)
						          else Wardrobe.Toggle(0, true)
						          end
						      end,
					},
					enablebreak = {
						type = "description",
						name = "\n",
						order = 6,
					},
					EditWardrobes = {
						type = "execute",
						name = L["Edit Outfits"],
						desc = L["Open Edit Outfits Dialog"],
						func = function()
							Wardrobe.ToggleMainMenu();
						end,
						order = 10,
						disabled = function() return not Wardrobe_Config.Enabled end,
					},
					AddDefaultOutfits = {
						type = "execute",
						name = L["Add Default Outfits"],
						desc = L["Add default outfits to list for current set,birthday suit, fishing."],
						func = function()
							Wardrobe.AddDefaultOutfits();
						end,
						order = 14,
						disabled = function() return not Wardrobe_Config.Enabled end,
					},
					minimapbreak = {
						type = "description",
						name = "\n",
						order = 15,
					},
					minimapheader = {
						type = "header",
						name = "Minimap Options",
						order = 16,
				    },
					ShowMinimapIcon = {
						name = L["Show Built-in Minimap Icon"],
						desc = L["Show or Hide the standard Wardrobe minimap icon"],
						type = "toggle",
						width = "full",
						order = 17,
						get = function() return (WardrobeAce.db.char.showMiniMapIcon) end,
						set = function()
									Wardrobe.Debug("Wardrobe: WardrobeAce.db.char.showMiniMapIcon=",WardrobeAce.db.char.showMiniMapIcon);
						          	if(WardrobeAce.db.char.showMiniMapIcon == true) then
						          		WardrobeAce.db.char.showMiniMapIcon = false;
										Wardrobe.ButtonUpdateVisibility();
										--Wardrobe_IconFrame:Hide();
						          	else
										WardrobeAce.db.char.showMiniMapIcon = true;
										Wardrobe.ButtonUpdateVisibility();
										--Wardrobe_IconFrame:Show();
						          	end

									--if titan is used, update it's setting for minimap
--									if IsAddOnLoaded("Titan") then
--										TitanSetVar(WARDROBE_TITAN_ID, "ShowMinimapIcon", WardrobeAce.db.char.showMiniMapIcon);
--										TitanPanelButton_UpdateButton(WARDROBE_TITAN_ID);
--									end
						      end,
						disabled = function() return not Wardrobe_Config.Enabled end,
					},
					LockButton = {
						name = L["Lock the Minimap Button Position"],
						desc = L["Do no allow minimap button to be dragged."],
						type = "toggle",
						width = "full",
						order = 18,
						get = function() return WardrobeAce.db.char.dragLock end,
						set = function()
							      WardrobeAce.db.char.dragLock = not WardrobeAce.db.char.dragLock
							  end,
						disabled = function() return not WardrobeAce.db.char.showMiniMapIcon or not Wardrobe_Config.Enabled end,
					},
					RightClick = {
						type = "select",
						name = L["Minimap Right Click Opens"],
						desc = L["Right clicking on minimap"],
						order = 19,
						values = {Wardrobe.RightClickOpenFunction[1].desc,
								  Wardrobe.RightClickOpenFunction[2].desc},
						get = function() return  WardrobeAce.db.char.miniMapRightClickOpens end,
						set = function(info, val) WardrobeAce.db.char.miniMapRightClickOpens = val end,
						disabled = function() return not WardrobeAce.db.char.showMiniMapIcon or not Wardrobe_Config.Enabled end,
					},
					ResetMiniMapIcon = {
						type = "execute",
						name = L["Reset Minimap Icon"],
						desc = L["Reset the Minimap icon to it's default location."],
						func = function()
						    Wardrobe_IconFrame:ClearAllPoints();
							Wardrobe_IconFrame:SetPoint("CENTER", "Minimap", "CENTER", "-37", "-74");
							local x,y = Wardrobe_IconFrame:GetCenter();
							local px,py = Wardrobe_IconFrame:GetParent():GetCenter();
							local ox = x-px;
							local oy = y-py;
							WardrobeAce.db.char.xOffset = ox;
							WardrobeAce.db.char.yOffset = oy;
						end,
						order = 20,
						disabled = function() return not WardrobeAce.db.char.showMiniMapIcon or not WardrobeAce.db.char.enabled end,
					},
					ldboptionsbreak = {
						type = "description",
						name = "\n",
						order = 23,
					},
					ldboptionsheader = {
						type = "header",
						name = "Data Broker Options",
						order = 24,
				    },
--[[
				    ldbEnable = {
						name = L["Enable LibDataBroker"],
						width = "full",
						desc = L["Enable LibDataBroker feed"],
						type = "toggle";
						get = function() return WardrobeAce.db.char.ldb.enabled end,
						set = function()
									WardrobeAce.db.char.ldb.enabled = not WardrobeAce.db.char.ldb.enabled
									if(WardrobeAce.db.char.ldb.enabled) then
										WardrobeAce.LDB.Enable();
									else
										WardrobeAce.LDB.Disable();
									end
							  end,
						order = 25,
					},
]]--
					ldbRightClick = {
						type = "select",
						name = L["Right Click Opens"],
						desc = L["Right clicking on LDB UI will launch"],
						order = 26,
						values = {WardrobeAce.LDB_RightClickOpenFunction[1].desc,
								  WardrobeAce.LDB_RightClickOpenFunction[2].desc,
								  WardrobeAce.LDB_RightClickOpenFunction[3].desc},
						get = function() return  WardrobeAce.db.char.ldb.rightClickOpens end,
						set = function(info, val)
							WardrobeAce.db.char.ldb.rightClickOpens = val;
						end,
						disabled = function() return not Wardrobe_Config.Enabled end,
					},
					ldbShowTextPrefix = {
						type = 'toggle',
						name = L["Show Text Prefix"],
						desc = L["Show or Hide the Wardrobe: prefix"],
						order = 27,
						get = function() return WardrobeAce.db.char.ldb.showTextPrefix end,
						set = function()
								  WardrobeAce.db.char.ldb.showTextPrefix = not WardrobeAce.db.char.ldb.showTextPrefix
  								  WardrobeAce.LDB.OnUpdateText();
--[[
								  if(FuBar2DB) then
									WardrobeAce.db.profile.fubar.showTextPrefix = WardrobeAce.db.char.ldb.showTextPrefix;
									WardrobeAce.FuBarPlugin:OnFuBarUpdateText()
								  end
]]--								  
							  end,
						disabled = function() return not Wardrobe_Config.Enabled end,
					},
					otheroptionsbreak = {
						type = "description",
						name = "\n",
						order = 30,
					},
					helmcloakheader = {
						type = "header",
						name = "Helm/Cloak Visibility Options",
						order = 31,
				    },
					ShowHelmCloak = {
						name = L["Enable Helm/Cloak Hiding"],
						desc = L["Turn on showing/hiding of helm and cloak per outfit."],
						type = "toggle",
						width = "full",
						order = 32,
						get = function() return WardrobeAce.db.char.showHelmCloakFunctionEnabled end,
						set = function()
						          WardrobeAce.db.char.showHelmCloakFunctionEnabled = not WardrobeAce.db.char.showHelmCloakFunctionEnabled
						      end,
						disabled = function() return not Wardrobe_Config.Enabled end,
					},
					DefaultHelmState = {
						type = "select",
						order = 33,
						name = L["Default Helm Hiding State"],
						desc = L["When the show helm checkbox is not checked, by default show or not show the helm"],
						values = {[0] = L["Hide"],
								  [1] = L["Show"]},
						get = function() return WardrobeAce.db.char.defaultHelmState end,
						set = function(info, val) WardrobeAce.db.char.defaultHelmState = val end,
						disabled = function() return not Wardrobe_Config.Enabled or not WardrobeAce.db.char.showHelmCloakFunctionEnabled end,					
					},
					DefaultCloakState = {
						type = "select",
						order = 34,
						name = L["Default Cloak Hiding State"],
						desc = L["When the show cloak checkbox is not checked, by default show or not show the cloak"],
						values = {[0] = L["Hide"],
								  [1] = L["Show"]},
						get = function() return WardrobeAce.db.char.defaultCloakState end,
						set = function(info, val) WardrobeAce.db.char.defaultCloakState = val end,
						disabled = function() return not Wardrobe_Config.Enabled or not WardrobeAce.db.char.showHelmCloakFunctionEnabled end,					
					},
					equipMgrHeader = {
						type = "header",
						name = "Equipment Manager Options",
						order = 35,
				    },
					SyncWithEquipMgr = {
						name = "Save to Equipment Manager",
						desc = "Store outfits to server stored Equipment Manager.",
						type = "toggle",
						width = "full",
						order = 36,
						get = function() return WardrobeAce.db.profile.syncToEquipMgr end,
						set = function()
							      WardrobeAce.db.profile.syncToEquipMgr = not WardrobeAce.db.profile.syncToEquipMgr
							  end,
						disabled = function() return not Wardrobe_Config.Enabled end,
					},
					otheroptionsheader = {
						type = "header",
						name = "General Options",
						order = 37,
				    },
					RequireClick = {
						name = L["Require Click"],
						desc = L["Show the outfit menu only when minimap or fubar is clicked."],
						type = "toggle",
						order = 38,
						get = function() return WardrobeAce.db.char.mustClickUIButton end,
						set = function()
						          WardrobeAce.db.char.mustClickUIButton = not WardrobeAce.db.char.mustClickUIButton
						          if(WardrobeAce.db.char.mustClickUIButton) then
						          	  WardrobeAce.LDB.broker.OnEnter = nil;
						          	  WardrobeAce.LDB.broker.OnTooltipShow = WardrobeAce.LDB.OnTooltipShow;
						          else
						          	  WardrobeAce.LDB.broker.OnEnter = WardrobeAce.LDB.OnEnter;
					 				  WardrobeAce.LDB.broker.OnTooltipShow = nil;
					 			  end;
						      end,
						disabled = function() return not Wardrobe_Config.Enabled end,
					},
					ItemTooltips = {
						name = L["Show Item Tooltips"],
						desc = L["Show which outfit an item belongs to."],
						type = "toggle",
						order = 39,
						get = function() return WardrobeAce.db.char.tooltips end,
						set = function()
							      WardrobeAce.db.char.tooltips = not WardrobeAce.db.char.tooltips
							  end,
						disabled = function() return not Wardrobe_Config.Enabled end,
					},
					AutoSwap = {
						name = L["Auto Swap"],
						desc = L["Allow special outfits to automatically swap."],
						type = "toggle",
						order = 40,
						get = function() return WardrobeAce.db.char.AutoSwap end;
						set = function()
							WardrobeAce.db.char.AutoSwap = not WardrobeAce.db.char.AutoSwap
							Wardrobe.ChangedZone();
						end,
						disabled = function() return not Wardrobe_Config.Enabled end,
					},
					DefaultCheckboxState = {
						type = "select",
						order = 41,
						name = L["Default Checkbox State"],
						desc = L["Default checkbox state in character panel"],
						values = {[0] = L["Unchecked"],
								  [1] = L["Checked"]},
						get = function() return WardrobeAce.db.char.defaultCheckboxState end,
						set = function(info, val) WardrobeAce.db.char.defaultCheckboxState = val end,
						disabled = function() return not Wardrobe_Config.Enabled end,
					},
					AutoSwapInBG = {
						name = L["Auto Swap In BG/Arena"],
						desc = L["Allow special outfits to automatically swap when in Arena and Battlegrounds."],
						type = "toggle",
						width = "full",
						order = 42,
						get = function() return WardrobeAce.db.char.AutoSwapInBG end;
						set = function()
							WardrobeAce.db.char.AutoSwapInBG = not WardrobeAce.db.char.AutoSwapInBG
							Wardrobe.ChangedZone();
						end,
						disabled = function() return not (Wardrobe_Config.Enabled and WardrobeAce.db.char.AutoSwap) end,
					},
					AutoSwapInWG = {
						name = L["Auto Swap In Wintergrasp/Tol Barad Peninsula"],
						desc = L["Allow special outfits to automatically swap when in Wintergrasp or Tol Barad Peninsula."],
						type = "toggle",
						width = "full",
						order = 43,
						get = function() return WardrobeAce.db.char.AutoSwapInWG end;
						set = function()
							WardrobeAce.db.char.AutoSwapInWG = not WardrobeAce.db.char.AutoSwapInWG
							Wardrobe.ChangedZone();
						end,
						disabled = function() return not (Wardrobe_Config.Enabled and WardrobeAce.db.char.AutoSwap) end,
					},
					Sound_EnableSFX = {
						name = L["Sound effects when swapping items"],
						desc = L["Enable/Disable playback of sound effects when swapping items."],
						type = "toggle",
						width = "full",
						order = 44,
						get = function() return WardrobeAce.db.profile.SoundWhileSwapping end;
						set = function()
							WardrobeAce.db.profile.SoundWhileSwapping = not WardrobeAce.db.profile.SoundWhileSwapping
						end,
						disabled = function() return not (Wardrobe_Config.Enabled) end,
					},
					DropDownScale = {
						name = L["Dropdown List Scale"],
						desc = L["Set scale of dropdown window"],
						type = "range",
						min = 0.5, max = 1, step = 0.1,
						isPercent = true,
						order = 50,
						get = function() return WardrobeAce.db.char.dropDownScale end,
						set = function(info, value)
							WardrobeAce.db.char.dropDownScale = value
							--Wardrobe.SetDropDownScale(value, true)
						end,
						disabled = function() return not Wardrobe_Config.Enabled end,
					},
					Opacity = {
						name = L["Dropdown Opacity"],
						desc = L["Set opacity of dropdown window"],
						type = "range",
						min = 0.5, max = 1, step = 0.01,
						isPercent = true,
						order = 51,
						get = function() return WardrobeAce.db.char.opacity end,
						set = function(info, value)
							WardrobeAce.db.char.opacity = value
						end,
						disabled = function() return not Wardrobe_Config.Enabled end,
					},
					resetdesc = {
						type = "description",
						name = "\n",
						order = 54,
				    },
					Reset = {
						name = L["Reset Wardrobe Data"],
						desc = L["Clear all outfits!"],
						order = 55,
						type = "execute",
						func = function()
									Wardrobe.EraseAllOutfits_OnClick()
								end;
						disabled = function() return not Wardrobe_Config.Enabled end,
					},
				},
			},
--[[			
			FuBar = {
				order = 3,
				type = "group",
				name = L["FuBar Options"],
				desc = L["FuBar Options"],
				hidden = false,
				args = {
					Enable = {
						type = 'toggle',
						name = L["Enable"],
						order = 5,
						desc = L["Show or Hide the Wardrobe FuBar Plugin"],
						get = function() return WardrobeAce.db.profile.fubar.enabled end,
						set = function() WardrobeAce:ToggleFuBarPlugin() end,
						disabled = function() return not Wardrobe_Config.Enabled end,
					},
					RightClick = {
						type = "select",
						name = L["FuBar Right Click Opens"],
						desc = L["Right clicking on FuBar"],
						order = 10,
						values = {Wardrobe.RightClickOpenFunction[1].desc,
								  Wardrobe.RightClickOpenFunction[2].desc,
								  Wardrobe.RightClickOpenFunction[3].desc},
						get = function() return  WardrobeAce.db.profile.fubar.rightClickOpens end,
						set = function(info, val)
							if (val == 3) then WardrobeAce.FuBarPlugin:SetFuBarOption("configType", "Dewdrop-2.0")
							else WardrobeAce.FuBarPlugin:SetFuBarOption("configType", "None")
							end
							WardrobeAce.db.profile.fubar.rightClickOpens = val
						end,
						disabled = function() return not WardrobeAce.db.profile.fubar.enabled or not Wardrobe_Config.Enabled end,
					},
					ShowTextPrefix = {
						type = 'toggle',
						name = L["Show Text Prefix"],
						desc = L["Show or Hide the Wardrobe: prefix"],
						order = 15,
						get = function() return WardrobeAce.db.profile.fubar.showTextPrefix end,
						set = function()
						          WardrobeAce.db.profile.fubar.showTextPrefix = not WardrobeAce.db.profile.fubar.showTextPrefix
						          if(FuBar2DB) then
						          	WardrobeAce.FuBarPlugin:OnFuBarUpdateText()
						          end
						          WardrobeAce.db.char.ldb.showTextPrefix = WardrobeAce.db.profile.fubar.showTextPrefix;
						          --if(WardrobeAce.db.char.ldb.enabled) then
						          	WardrobeAce.LDB.OnUpdateText();
						          --end
						      end,
						disabled = function() return not WardrobeAce.db.profile.fubar.enabled or not Wardrobe_Config.Enabled end,
					},
					panelId = {
						type = "select",
						name = L["Panel"],
						desc = L["FuBar Panel to attach to"],
						values = function()
						 	       panels = {}
							       for i = 1, FuBar:GetNumPanels() do
						           		panels[i] = i
						           end
						           return panels
						end,
						order = 20,
						get = function()
							if WardrobeAce.FuBarPlugin and WardrobeAce.FuBarPlugin:GetPanel() then
						    	WardrobeAce.db.profile.fubar.panelId = WardrobeAce.FuBarPlugin:GetPanel().id
						    end
						    return WardrobeAce.db.profile.fubar.panelId
						end,
						set = function(info, val)
							WardrobeAce.db.profile.fubar.panelId = val
							panel = FuBar:GetPanel(val)
							panel:AddPlugin(WardrobeAce.FuBarPlugin, nil, WardrobeAce.db.profile.fubar.position)
							WardrobeAce.FuBarPlugin:SetPanel(panel)
						end,
						disabled = function() return not ((FuBar:GetNumPanels() > 0) and WardrobeAce.db.profile.fubar.enabled and WardrobeAce.FuBarPlugin) or not Wardrobe_Config.Enabled end,
					},
					position = {
						type = "select",
						name = L["Position"],
						desc = L["Position"],
						values = {LEFT = L["Left"], CENTER = L["Center"], RIGHT = L["Right"]},
						order = 25,
						get = function() return WardrobeAce.db.profile.fubar.position end,
						set = function(info, val)
							WardrobeAce.db.profile.fubar.position = val
							if WardrobeAce.FuBarPlugin:GetPanel() and WardrobeAce.FuBarPlugin:GetPanel().SetPluginSide then
								WardrobeAce.FuBarPlugin:GetPanel():SetPluginSide(WardrobeAce.FuBarPlugin, val)
							end
						end,
						disabled = function() return not ((FuBar:GetNumPanels() > 0) and WardrobeAce.db.profile.fubar.enabled and WardrobeAce.FuBarPlugin) or not Wardrobe_Config.Enabled end,
					},
				},
			},
]]--
		},
	}



--============================================================================================--
--============================================================================================--
--																							--
--							  INITIALIZATION FUNCTIONS									  --
--																							--
--============================================================================================--
--============================================================================================--

function WardrobeAce:OnInitialize()

	WardrobeAce.db = LibStub("AceDB-3.0"):New("Wardrobe_Config_db", db_Defaults, "Default")

	LibStub("AceConfig-3.0"):RegisterOptionsTable(L["Wardrobe-AL"], AceConfigOptions)
	WardrobeAce.optionsFrames = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(L["Wardrobe-AL"], nil, nil, "General")

	PaperDollFrame:HookScript("OnShow", Wardrobe.MyPaperDollFrame_OnShow);
	PaperDollFrame:HookScript("OnHide", Wardrobe.MyPaperDollFrame_OnHide);
	
	if(Wardrobe_Config.Enabled) then
		Wardrobe.Toggle(1, false);
	else
		Wardrobe.Toggle(0, false);
	end
	
end

function WardrobeAce.ToggleConfig()
	if(InterfaceOptionsFrame:IsShown()) then
		InterfaceOptionsFrame:Hide()
	else		
		InterfaceOptionsFrame_OpenToCategory(WardrobeAce.optionsFrames)
	end
end

---------------------------------------------------------------------------------
-- Stuff done when the plugin first loads
---------------------------------------------------------------------------------
--function Wardrobe.RegisterEvents()
function Wardrobe.OnLoad(this)
	-- watch our bags and update our wardrobe availability
	this:RegisterEvent("ADDON_LOADED");
	--this:RegisterEvent("BAG_UPDATE");
	this:RegisterEvent("PLAYER_REGEN_DISABLED");
	this:RegisterEvent("PLAYER_REGEN_ENABLED");
	this:RegisterEvent("PLAYER_ENTER_COMBAT");
	this:RegisterEvent("PLAYER_LEAVE_COMBAT");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("PLAYER_AURAS_CHANGED");
	this:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	this:RegisterEvent("UPDATE_SHAPESHIFT_FORM");
--	this:RegisterEvent("CVAR_UPDATE");
	this:RegisterEvent("PLAYER_FLAGS_CHANGED");

	--this:RegisterEvent("MIRROR_TIMER_START");	--Swimming Currently Disabled

	Wardrobe.DropDown_OnLoad();
	Wardrobe.RegisterOptionConfigs();

end

---------------------------------------------------------------------------------
-- Register Option Configs
---------------------------------------------------------------------------------
function Wardrobe.RegisterOptionConfigs()

	if (Khaos) then
		Wardrobe.RegisterKhaos();
	end

	local WardrobeCommands = {"/wardrobe","/wd"};
	if (Satellite) then
		Satellite.registerSlashCommand(
			{
				id="Wardrobe";
				commands = WardrobeCommands;
				onExecute = Wardrobe.ChatCommandHandler;
				helpText = TEXT("CHAT_COMMAND_INFO");
			}
		);
	else
		SlashCmdList["WARDROBESLASH"] = Wardrobe.ChatCommandHandler;
		for i, slash in ipairs(WardrobeCommands) do
			setglobal("SLASH_WARDROBESLASH"..i, slash);
		end
	end
end

function Wardrobe.RegisterKhaos()
	local optionSet = {
		id="Wardrobe";
		text=function() return TEXT("CONFIG_HEADER") end;
		helptext=function() return TEXT("CONFIG_HEADER_INFO") end;
		callback=function(state) Wardrobe.Toggle(state and 1, true); end;
		feedback=function(state) return state and TEXT("TXT_ENABLED") or TEXT("TXT_DISABLED") end;
		difficulty=1;
		default={checked=true};
		options={
			{
				id = "Header";
				text = function() return TEXT("CONFIG_HEADER").." "..Wardrobe_Config.version end;
				helptext = function() return TEXT("CONFIG_HEADER_INFO") end;
				type = K_HEADER;
			};
			{
				id = "WearOutfit";
				text = function() return TEXT("CONFIG_WEAROUTFIT") end;
				helptext = function() return TEXT("CONFIG_WEAROUTFIT_INFO") end;
				feedback = function(state) return format(TEXT("CONFIG_WEAROUTFIT_FEEDBACK"), Wardrobe.CurrentConfig.Outfit[state.value].OutfitName) end;
				callback = function(state)
					if (state.value) then
						Wardrobe.WearOutfit(state.value);
					end
				end;
				setup = {
					options = Wardrobe.GetListOfOutfits;
					orderedOptions = true;
					multiSelect = false;
					noSelect = true;
				};
				default = {
					value = nil;
				};
				disabled = {
					value = nil;
				};
				type = K_PULLDOWN;
			};
			{
				id = "EditOutfits";
				text = function() return TEXT("CONFIG_EDIT") end;
				helptext = function() return TEXT("CONFIG_EDIT_INFO") end;
				feedback = function() return TEXT("CONFIG_EDIT_FEEDBACK") end;
				callback = Wardrobe.ShowMainMenu;
				type = K_BUTTON;
				setup = {
					buttonText = function() return TEXT("CONFIG_EDIT_BUTTON") end;
				};
			};
			{
				id = "OutfitKeyHeader";
				text = function() return TEXT("CONFIG_KEY_HEADER") end;
				helptext = function() return TEXT("CONFIG_KEY_HEADER") end;
				type = K_HEADER;
			};
			{
				id = "HelpText1";
				text = function() return TEXT("HELP_13") end;
				helptext = function() return TEXT("HELP_13") end;
				type = K_TEXT;
			};
			{
				id = "HelpText2";
				text = function() return TEXT("HELP_14") end;
				helptext = function() return TEXT("HELP_14") end;
				type = K_TEXT;
			};
			{
				id = "HelpText3";
				text = function() return TEXT("HELP_15") end;
				helptext = function() return TEXT("HELP_15") end;
				type = K_TEXT;
			};
			{
				id = "HelpText4";
				text = function() return TEXT("HELP_16") end;
				helptext = function() return TEXT("HELP_16") end;
				type = K_TEXT;
			};
			{
				id = "OptionsHeader";
				text = function() return TEXT("CONFIG_OPTIONS_HEADER") end;
				helptext = function() return TEXT("CONFIG_OPTIONS_HEADER") end;
				type = K_HEADER;
			};
			{
				id = "AutoSwap";
				text = function() return TEXT("CONFIG_AUTOSWAP") end;
				helptext = function() return TEXT("CONFIG_AUTOSWAP_INFO") end;
				feedback = function(state)
					if (state.checked) then
						return TEXT("TXT_AUTO_ENABLED");
					else
						return TEXT("TXT_AUTO_DISABLED");
					end
				end;
				callback = function(state) WardrobeAce.db.char.AutoSwap = (state.checked) end;
				check = true;
				type = K_CHECKBOX;
				default = {
					checked = true;
				};
				disabled = {
					checked = false;
				};
			};
			{
				id = "RequireClick";
				text = function() return TEXT("CONFIG_REQCLICK") end;
				helptext = function() return TEXT("CONFIG_REQCLICK_INFO") end;
				feedback = function(state)
					if (state.checked) then
						return TEXT("TXT_BUTTONONCLICK");
					else
						return TEXT("TXT_BUTTONONMOUSEOVER");
					end
				end;
				callback = function(state) WardrobeAce.db.char.mustClickUIButton = (state.checked) end;
				check = true;
				type = K_CHECKBOX;
				default = {
					checked = false;
				};
				disabled = {
					checked = false;
				};
			};
			{
				id = "LockButton";
				text = function() return TEXT("CONFIG_LOCKBUTTON") end;
				helptext = function() return TEXT("CONFIG_LOCKBUTTON_INFO") end;
				feedback = function(state)
					if (state.checked) then
						return TEXT("TXT_BUTTONLOCKED");
					else
						return TEXT("TXT_BUTTONUNLOCKED");
					end
				end;
				callback = function(state) WardrobeAce.db.char.dragLock = (state.checked) end;
				check = true;
				type = K_CHECKBOX;
				default = {
					checked = false;
				};
				disabled = {
					checked = false;
				};
			};
			{
				id = "DropDownScale";
				text = function() return TEXT("CONFIG_DROPDOWNSCALE") end;
				helptext = function() return TEXT("CONFIG_DROPDOWNSCALE_INFO") end;
				feedback = function(state)
					return format(TEXT("CONFIG_DROPDOWNSCALE_FEEDBACK"), state.slider*100);
				end;
				callback = function(state) Wardrobe.SetDropDownScale(state.slider, true) end;
				check = true;
				type = K_SLIDER;
				dependencies = {["DropDownScale"]={checked=true}};
				default = {
					checked = false;
					slider = UIParent:GetScale();
				};
				disabled = {
					checked = false;
					slider = UIParent:GetScale();
				};
				setup = {
					sliderMin = 0.5;
					sliderMax = 1.0;
					sliderStep = 0.1;
					sliderSignificantDigits = 1;
				};
			};
			{
				id = "Reset";
				text = function() return TEXT("CONFIG_RESET") end;
				helptext = function() return TEXT("CONFIG_RESET_INFO") end;
				feedback = function() return TEXT("CONFIG_RESET_FEEDBACK") end;
				callback = Wardrobe.EraseAllOutfits_OnClick;
				type = K_BUTTON;
				setup = {
					buttonText = function() return TEXT("CONFIG_RESET_BUTTON") end;
				};
			};
		};
	};
	Khaos.registerOptionSet(
		"inventory",
		optionSet
	);
end

---------------------------------------------------------------------------------
-- Event handler
---------------------------------------------------------------------------------

function Wardrobe.OnEvent(this, event, arg1, arg2, ...)

	if (Wardrobe_Config.Enabled) then
			
--		Wardrobe.Debug("OnEvent: this=",this," event=",event," arg1=",arg1, " arg2=",arg2);

		if (event == "CVAR_UPDATE") then
--			Wardrobe.Debug("CVAR_UPDATE detected. ShowingHelm=",ShowingHelm(),"ShowingCloak=",ShowingCloak());
		elseif (event == "PLAYER_FLAGS_CHANGED") then
--			Wardrobe.Debug("PLAYER_FLAGS_CHANGED detected. arg1=",arg1,"ShowingHelm=",ShowingHelm(),"ShowingCloak=",ShowingCloak());
			Wardrobe.UpdateGlobalVisibilitySettings();
		elseif (event == "PLAYER_REGEN_DISABLED") then
			--Sea.io.print("PLAYER_REGEN_DISABLED");
			Wardrobe.RegenEnabled = false;
		elseif (event == "PLAYER_REGEN_ENABLED") then
			Wardrobe.RegenEnabled = true;
			--Sea.io.print("PLAYER_REGEN_ENABLED ", Wardrobe.IsPlayerInCombat());
			if (not Wardrobe.IsPlayerInCombat()) then
				if (not Wardrobe.CheckWaitingList()) then
					if (not Wardrobe.CheckForMounted()) then
						Wardrobe.CheckForEatDrink();
					end
				end
			end
		elseif (event == "PLAYER_ENTER_COMBAT") then
			--Sea.io.print("PLAYER_ENTER_COMBAT");
			Wardrobe.InCombat = true;
		elseif (event == "PLAYER_LEAVE_COMBAT") then
			Wardrobe.InCombat = false;
			--Sea.io.print("PLAYER_LEAVE_COMBAT ", Wardrobe.IsPlayerInCombat());
			if (not Wardrobe.IsPlayerInCombat()) then
				--Wardrobe.CheckWaitingList();
			end
		elseif (event == "PLAYER_AURAS_CHANGED") then
			--if (not Wardrobe.IsPlayerInCombat()) then
				if (Chronos) then
					Chronos.scheduleByName("WardrobeAuraCheck", .2, Wardrobe.AuraCheck);
				else
					if (not Wardrobe.CheckForMounted()) then
						Wardrobe.CheckForEatDrink();
					end
				end
			--end
		elseif (event == "ZONE_CHANGED_NEW_AREA") then
			Wardrobe.ChangedZone();
		elseif (event == "MIRROR_TIMER_START") then
			Wardrobe.CheckForSwimming();
		elseif (event == "ADDON_LOADED") then
--			Wardrobe.Debug("Wardrobe ADDON_LOADED",arg1);
			if(arg1 == "Wardrobe") then
				Wardrobe.UpdateOldConfigVersions();
				Wardrobe.UpdateXMLText();
				Wardrobe.ChangedZone();

				WardrobeAce.LDB_Init();

				Wardrobe.ButtonUpdateVisibility();

--				Wardrobe.CheckForMounted();
--				Wardrobe.SetDropDownScale(WardrobeAce.db.char.dropDownScale, true);

--				if(FuBar2DB and WardrobeAce.db.profile.fubar.enabled) then
--					WardrobeAce:OnEnableFuBarPlugin()
--				end

				WardrobeAce.Baggins.Enable();
	
				-- verify the wearme cache at this point.
				WearMe.VerifyCache();	

				Wardrobe.Loaded = true;

			end
		elseif (event == "PLAYER_ENTERING_WORLD" and Wardrobe.Loaded) then
			Wardrobe.CheckForOurWardrobeID();
			if(Wardrobe.newChar) then
				--if this is a new character in wardrobe, give it the default outfits to start with.
				--only add the default outfits if they have none in the EquipmentManager too.
				if (GetNumEquipmentSets() == 0) then
					Wardrobe.AddDefaultOutfits();
				end
				Wardrobe.newChar = false;			
			end

			-- merge any equipment manager sets that are not in my list of outfits
			-- need to fix this.  it is broken bad
			Wardrobe.MergeEquipmentSets();

			Wardrobe.ChangedZone();
			Wardrobe.CheckForMounted();
			Wardrobe.SetDropDownScale(WardrobeAce.db.char.dropDownScale, true);

		elseif (event == "UPDATE_SHAPESHIFT_FORM") then

--			Wardrobe.CheckShapeshiftForm();
			if (not Wardrobe.IsPlayerInCombat()) then
				if (not Wardrobe.CheckWaitingList()) then
					if (not Wardrobe.CheckForMounted()) then
						Wardrobe.CheckForEatDrink();
					end
				end
			end

		end
	end
end

function Wardrobe.AuraCheck()
	if (not Wardrobe.ChangedZone()) then
		if (not Wardrobe.CheckForMounted()) then
			Wardrobe.CheckForEatDrink();
		end
	end
end

---------------------------------------------------------------------------------
-- OnUpdate handler
---------------------------------------------------------------------------------
function Wardrobe.OnUpdate(this,durr)

	-- 10x per second
	if (this.counter) then
		if (this.counter > .5) then
			this.counter = 0;
		else
			this.counter = this.counter + durr;
			return;
		end
	else
		this.counter = durr;
		return;
	end

--	Wardrobe.Debug("Wardrobe.ChangedZone: In Zone=",Wardrobe.CurrentZone);
--	Wardrobe.Debug("Wardrobe.ChangedZone: BZ[Wintergrasp]=", BZ["Wintergrasp"], "Wardrobe.IsInWintergrasp=", Wardrobe.IsInWintergrasp);

	if (WardrobeAce.db.char.AutoSwap and Wardrobe.ArenaBattlegroundCheck()) then
		if (not Wardrobe.IsPlayerInCombat()) then
			if (not Wardrobe.CheckWaitingList()) then

				local mnt = Wardrobe.IsMounted();
			    if(mnt ~= Wardrobe.lastMount) then
			     	Wardrobe.lastMount = mnt;
			     	return;
    			end

				local travelForm = Wardrobe.IsTravelForm();
				if(travelForm ~= Wardrobe.lastTravelForm) then
					Wardrobe.lastTravelForm = travelForm;
					return;
				end

				-- check to see if player is casting.  If player has been casting, then return so we don't process a outfit switch yet.
				local spell = UnitCastingInfo("player");
	         	if spell then
		            return
			    end
				if(spell ~= Wardrobe.lastSpell) then
			        Wardrobe.lastSpell = spell;
		            return;
         		end

--				if (not Wardrobe.CheckShapeshiftForm()) then
					if (not Wardrobe.CheckForMounted()) then
						Wardrobe.CheckForSwimming();
						--Wardrobe.CheckForEatDrink();
					end
--				end
			end
		end
	end
end


---------------------------------------------------------------------------------
-- Return true if we're in combat
---------------------------------------------------------------------------------
function Wardrobe.IsPlayerInCombat()
	if (Wardrobe.InCombat) or (not Wardrobe.RegenEnabled) then
		return true;
	else
		return false;
	end
end


---------------------------------------------------------------------------------
-- Return true if we're not in an Arena match, Battlegrounds or Wintergrasp
---------------------------------------------------------------------------------
function Wardrobe.ArenaBattlegroundCheck()

	if(WardrobeAce.db.char.AutoSwapInBG or WardrobeAce.db.char.AutoSwapInWG) then return true end;

	if(Wardrobe.IsInBGArena) then return false;	end;
	if(Wardrobe.IsInWintergrasp) then return false; end;
	if(Wardrobe.IsInTolBarad) then return false; end;
	return true;

end

---------------------------------------------------------------------------------
-- Update outdated config information
---------------------------------------------------------------------------------
function Wardrobe.UpdateOldConfigVersions()

	-- Clear out unused items
	Wardrobe.CheckForOurWardrobeID();

	-- look for any missing config items
	if (Wardrobe_Config.DefaultCheckboxState) then
		WardrobeAce.db.profile.defaultCheckboxState = Wardrobe_Config.DefaultCheckboxState;
		WardrobeAce.db.char.defaultCheckboxState = Wardrobe_Config.DefaultCheckboxState;
		Wardrobe_Config.DefaultCheckboxState = nil;
	end
	if (WardrobeAce.db.char.defaultCheckboxState == nil) then
		WardrobeAce.db.char.defaultCheckboxState = WardrobeAce.db.profile.defaultCheckboxState;
	end

	if (Wardrobe_Config.Tooltips) then
		WardrobeAce.db.char.tooltips = Wardrobe_Config.Tooltips;
		Wardrobe_Config.Tooltips = nil;
	end

	if (Wardrobe_Config.DragLock) then
		WardrobeAce.db.char.dragLock = Wardrobe_Config.DragLock;
		Wardrobe_Config.DragLock = nil;
	end

	if (Wardrobe_Config.RightClickOpenFunction) then
		WardrobeAce.db.char.miniMapRightClickOpens = Wardrobe_Config.RightClickOpenFunction;
		Wardrobe_Config.RightClickOpenFunction = nil;
	end

	if(Wardrobe_Config.xOffset) then
		WardrobeAce.db.profile.xOffset = Wardrobe_Config.xOffset;
		WardrobeAce.db.char.xOffset = Wardrobe_Config.xOffset;
		Wardrobe_Config.xOffset = nil;
	end
	if(not WardrobeAce.db.char.xOffset) then
		WardrobeAce.db.char.xOffset = WardrobeAce.db.profile.xOffset;
	end
	if(Wardrobe_Config.yOffset) then
		WardrobeAce.db.profile.yOffset = Wardrobe_Config.yOffset;
		WardrobeAce.db.char.yOffset = Wardrobe_Config.yOffset;
		Wardrobe_Config.yOffset = nil;
	end
	if(WardrobeAce.db.char.yOffset == nil) then
		WardrobeAce.db.char.yOffset = WardrobeAce.db.profile.yOffset;
	end

	if(Wardrobe_Config.MustClickUIButton) then
		WardrobeAce.db.char.mustClickUIButton = Wardrobe_Config.MustClickUIButton;
		Wardrobe_Config.MustClickUIButton = nil;
	end

	if(Wardrobe.CurrentConfig.MinimapButtonVisible) then
		WardrobeAce.db.char.showMiniMapIcon = (Wardrobe.CurrentConfig.MinimapButtonVisible == 1);
		Wardrobe.CurrentConfig.MinimapButtonVisible = nil;
	end


	if (not Wardrobe.CurrentConfig.VirtualOutfit) then
		Wardrobe.CurrentConfig.VirtualOutfit = {};
	end
	local item;
	for i, outfit in ipairs(Wardrobe.CurrentConfig.Outfit) do
		if (outfit.Selected ~= nil) then
			outfit.Selected = nil;
		end
		if(not WardrobeAce.db.char.version or tonumber(WardrobeAce.db.char.version) < 3.35) then
		
			-- move ranged weapons to main hand as ranged slot is gone in Wow 5.0
			local localizedClass, englishClass = UnitClass("player");
			if(englishClass == "HUNTER" or englishClass == "MAGE" or englishClass == "WARLOCK" or englishClass == "PRIEST") then
				if (outfit.Item[19]) then
					outfit.Item[17] = outfit.Item[19];
				end
			end 
			outfit.Item[19] = nil;  --clear ranged slot since it is no longer used.
		
			-- fix icon if it is malformed.
			if (outfit.Icon and outfit.Icon == "Interface\\Icons\\1") then
				outfit.Icon = nil;
			end
	
			for j = 1, Wardrobe.InventorySlotsSize do
				item = outfit.Item[j];
				if (item) then
					if (item.IsSlotUsed ~= 1) then
						outfit.Item[j] = nil;
					elseif (item.Name == "") then
						outfit.Item[j] = {IsSlotUsed = 1};
					end
					item = outfit.Item[j];
					if (not item) then item = {}; end;
					if (item.ItemID) then
						item.ItemID = tonumber(item.ItemID);
					end
					item.PermEnchant = nil;
					item.Suffix = nil;
					item.TempEnchant = nil;
					item.ReforgeId = nil;
					
					if (item.ItemString) then
						-- fix itemString by appending the two missing parameters introduced with the reforgeId fix.
						-- new 11th field from wow 5.0.x is not included since I don't know what it is for yet.
						item.ItemString = item.ItemString..":0:0";
					end
										
		
--[[					
					if (item.ItemString) then
						local _, _, itemID, permEnchant, suffix = strfind(item.ItemString, "^item:(%d-):(%d-):(%d-):(%d-)$");
						if (itemID) then
							item.ItemString = format("item:%s:%s:0:0:0:0:%s", itemID, permEnchant)
						end
					end
]]--
					--if version for this char profile is less than 3.19, remove all references to the helm/cloak display as there was a bug.
					if(not WardrobeAce.db.char.version or tonumber(WardrobeAce.db.char.version) < 3.19) then
						if(item.Display) then
							item.Display = nil;
						end
					end
				end
			end
			
		end

   -- repair item name if it is missing.
   for j = 1, Wardrobe.InventorySlotsSize do
      local item = outfit.Item[j];
      if (item and item.ItemString and not item.Name) then
          item.Name = GetItemInfo(item.ItemString);
      end
   end

-- 3.40 has a bug where 12 variables where in the itemstring instead of 11.  fix them
-- Also copy back in the item name because 3.40 broke that too.
    if(not WardrobeAce.db.char.version or tonumber(WardrobeAce.db.char.version) < 3.41) then
      for j = 1, Wardrobe.InventorySlotsSize do
        item = outfit.Item[j];
        if (item and item.ItemString) then
            Wardrobe.Debug("Wardrobe.UpdateOldConfigVersions() Old ItemString=",item.ItemString);
            local t = Wardrobe.split(item.ItemString, "\:");
--              Wardrobe.Debug("k=",k,"; v=",v);
              --t[k] = v
--            end
            if (table.getn(t) > 11) then
              local tempItemString = "";
              for k = 1, 11 do
                tempItemString = tempItemString..t[k];
                if (k < 11) then
                  tempItemString = tempItemString..":";
                end
              end
              Wardrobe.Debug("* Wardrobe.UpdateOldConfigVersions() tempItemString=",tempItemString);
              item.ItemString = tempItemString;   
              Wardrobe.Debug("* Wardrobe.UpdateOldConfigVersions() New ItemString=",item.ItemString);
            end
        end
      end
    end
		
		if (outfit.SortNumber ~= nil) then
			outfit.SortNumber = nil
		end
		if (outfit.Virtual) then
			outfit.Virtual = nil;
			tinsert(Wardrobe.CurrentConfig.VirtualOutfit, outfit);
			tremove(Wardrobe.CurrentConfig.Outfit, i);
		elseif (outfit.Virtual ~= nil) then
			outfit.Virtual = nil;
		end
		-- if a null named outfit got in the list, remove it.
		if(outfit.OutfitName == nil) then
			tremove(Wardrobe.CurrentConfig.Outfit, i);
		end
	end
	for i, outfit in ipairs(Wardrobe.CurrentConfig.VirtualOutfit) do
		if (outfit.SortNumber ~= nil) then
			outfit.SortNumber = nil
		end
		if (not Wardrobe.SpecialOutfitVirtualIDs[outfit.OutfitName]) then
			tinsert(Wardrobe.CurrentConfig.Outfit, outfit);
			tremove(Wardrobe.CurrentConfig.VirtualOutfit, i);
		end
	end
	

	Wardrobe_Config.version = WARDROBE_VERSION;
	WardrobeAce.db.profile.version = WARDROBE_VERSION;

	WardrobeAce.db.char.version = WARDROBE_VERSION;
end


function Wardrobe.split(pString, pPattern)
   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
          table.insert(Table,cap)
      end
      last_end = e+1
      s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
      cap = pString:sub(last_end)
      table.insert(Table, cap)
   end
   return Table
end

---------------------------------------------------------------------------------
-- Merge over any server EquipmentSets that don't exist in your Wardrobe lists.
---------------------------------------------------------------------------------
function Wardrobe.MergeEquipmentSets()

	 if (Wardrobe_Config.Enabled) then
	    -- merge with the equipment sets on the server
	    Wardrobe.Debug("Wardrobe: Num Server EquipmentSets="..GetNumEquipmentSets());
	    for i = 1, GetNumEquipmentSets() do
	    	local outfitName = GetEquipmentSetInfo(i);
			local serverEquipSetItemLocations = GetEquipmentSetLocations(outfitName);
			local serverEquipSetItems = GetEquipmentSetItemIDs(outfitName);
			-- if this server set doesn't exist in local cache, just copy it over
			if(not Wardrobe.FoundOutfitName(outfitName)) then
			    Wardrobe.Debug("Wardrobe: Server EquipmentSet",outfitName,"does not exist in Wardrobe, copying it over.");
				if(Wardrobe.ItemCheckState == nil) then Wardrobe.ItemCheckState =  {}; end;
			
				local outfitNum = Wardrobe.GetNextFreeOutfitSlot();
				local outfit = Wardrobe.CurrentConfig.Outfit[outfitNum];
				
				local icon = GetEquipmentSetInfoByName(outfitName);
				outfit.OutfitName = outfitName;
				if (icon) then
					outfit.Icon = "Interface\\Icons\\"..icon;
				end
				outfit.Item = {};
				Wardrobe.Debug(Wardrobe.asText(serverEquipSetItems));
				for j = 1, Wardrobe.InventorySlotsSize do
					outfit.Item[j] = {};
					if(serverEquipSetItemLocations[Wardrobe.InventorySlotIDs[j]] == 1) then
						Wardrobe.ItemCheckState[j] = 0;
					else
						Wardrobe.ItemCheckState[j] = 1;
					end
					
					if(serverEquipSetItems[Wardrobe.InventorySlotIDs[j]]) then
						local itemName, itemLink = GetItemInfo(serverEquipSetItems[Wardrobe.InventorySlotIDs[j]]);
						Wardrobe.Debug("Wardrobe: Processing",Wardrobe.InventorySlots[j],": ItemID=",serverEquipSetItems[Wardrobe.InventorySlotIDs[j]],":",itemLink);
						if(serverEquipSetItems[Wardrobe.InventorySlotIDs[j]] == EQUIPMENT_SET_IGNORED_SLOT) then
							outfit.Item[j].IsSlotUsed = 0;
						elseif(serverEquipSetItems[Wardrobe.InventorySlotIDs[j]] ~= EQUIPMENT_SET_EMPTY_SLOT) then
							outfit.Item[j].ItemID = serverEquipSetItems[Wardrobe.InventorySlotIDs[j]];
							outfit.Item[j].Name = itemName;
							outfit.Item[j].IsSlotUsed = 1;
						else
							outfit.Item[j].IsSlotUsed = 1;
						end
					else
						outfit.Item[j].IsSlotUsed = 0;
					end
				end
				Wardrobe.Debug("Wardrobe: Adding new server set",outfit.OutfitName,"with icon",outfit.Icon,"available=",outfit.Available);
			else
			-- if the server set already exists in local cache, do a iLevel comparison to make sure to use the most recent.
				local useServerOutfit = false;
				local avgLevelServerItems = 0;
				local numServerItems = 0;
				local avgLevelLocalItems = 0;
				local numLocalItems = 0;
				local outfitNum = Wardrobe.GetOutfitNum(outfitName);
				local outfit = Wardrobe.CurrentConfig.Outfit[outfitNum];
				for j = 1, Wardrobe.InventorySlotsSize do
					local serverItemID = serverEquipSetItems[Wardrobe.InventorySlotIDs[j]];
					local serverItemName = nil;
					if(serverItemID) then
						local itemLevel;
						serverItemName, _, _, itemLevel = GetItemInfo(serverItemID);
						if(itemLevel) then
							avgLevelServerItems = avgLevelServerItems + itemLevel;
							numServerItems = numServerItems + 1;
						else
							itemLevel = 0;
						end
						if(not serverItemName) then serverItemName = ""; end;
						if(serverItemID ~= 0) then
--							Wardrobe.Debug("Wardrobe: Getting itemLevel of server stored "..serverItemID.." "..serverItemName.." iLevel="..itemLevel);
						end
					end
					if(outfit.Item and outfit.Item[j] and outfit.Item[j].ItemID) then
						local _, _, _, itemLevel = GetItemInfo(outfit.Item[j].ItemID);
						if(itemLevel) then
							avgLevelLocalItems = avgLevelLocalItems + itemLevel;
							numLocalItems = numLocalItems + 1;
						else
							itemLevel = 0;
						end
--						Wardrobe.Debug("Wardrobe: Getting itemLevel of local item",outfit.Item[j].ItemID,outfit.Item[j].Name," iLevel="..itemLevel);
					end
				end
				if(numServerItems > 0) then
					avgLevelServerItems = avgLevelServerItems / numServerItems;
				end
				if(numLocalItems > 0) then
					avgLevelLocalItems = avgLevelLocalItems / numLocalItems;
				end
				if(avgLevelLocalItems >= avgLevelServerItems) then
					useServerOutfit = false;
					Wardrobe.Debug("Wardrobe: Detected server stored outfit "..outfitName..".  Using locally stored copy since it's average ItemLevel is "..avgLevelLocalItems.." and the server's is "..avgLevelServerItems);
				else
					useServerOutfit = true;
					Wardrobe.Debug("Wardrobe: Detected server stored outfit "..outfitName..".  Using server stored copy since it's average ItemLevel is "..avgLevelServerItems.." and the local copy's is "..avgLevelLocalItems);
				end
	
				if(useServerOutfit) then
					outfit.OutfitName = outfitName;
	
					if(not outfit.Item) then
						outfit.Item = {};
					end
	
					for j = 1, Wardrobe.InventorySlotsSize do
						Wardrobe.Debug("Wardrobe: Processing slot ",j," serverEquipSetItems[",j,"]=",serverEquipSetItems[Wardrobe.InventorySlotIDs[j]]);
						if(not outfit.Item[j]) then
							outfit.Item[j] = {};
						end
						if(serverEquipSetItemLocations[Wardrobe.InventorySlotIDs[j]] == 1) then
							outfit.Item[j].IsSlotUsed = 0;
						else
							outfit.Item[j].IsSlotUsed = 1;
						end
						if(serverEquipSetItems[Wardrobe.InventorySlotIDs[j]]) then
							if(serverEquipSetItems[Wardrobe.InventorySlotIDs[j]] ~= 0) then
								outfit.Item[j].ItemID = serverEquipSetItems[Wardrobe.InventorySlotIDs[j]];
								outfit.Item[j].Name = GetItemInfo(outfit.Item[j].ItemID);
							end
							if(outfit.Item[j].Name == nil) then
								outfit.Item[j] = nil;
							end
						else
							outfit.Item[j] = nil;
						end
					end
				end
			end
		end
	end
end

--============================================================================================--
--============================================================================================--
--																							--
--							  CHAT COMMAND FUNCTIONS										--
--																							--
--============================================================================================--
--============================================================================================--


---------------------------------------------------------------------------------
-- Break a chat command into its command and variable parts (i.e. "debug on"
-- will break into command = "debug" and variable = "on", or "add my spiffy wardrobe"
-- breaks into command = "add" and variable = "my spiffy wardrobe"
---------------------------------------------------------------------------------
function Wardrobe.ParseCommand(msg)
	firstSpace = string.find(msg, " ", 1, true);
	if (firstSpace) then
		local command = string.sub(msg, 1, firstSpace - 1);
		local var  = string.sub(msg, firstSpace + 1);
		return command, var
	else
		return msg, nil;
	end
end


---------------------------------------------------------------------------------
-- A simple chat command handler.  takes commands in the form "/wardrobe command var"
---------------------------------------------------------------------------------
function Wardrobe.ChatCommandHandler(msg)
	local command, var = Wardrobe.ParseCommand(msg);
	if ((not command) and msg) then
		command = msg;
	end
	if (command) then
		command = string.lower(command);
		if (command == TEXT("CMD_RESET")) then
			Wardrobe.EraseAllOutfits();
		elseif (command == TEXT("CMD_LIST")) then
			Wardrobe.ListOutfits(var);
		elseif (command == TEXT("CMD_WEAR") or command == TEXT("CMD_WEAR2") or command == TEXT("CMD_WEAR3")) then
			Wardrobe.WearOutfit(var);
		elseif (command == TEXT("CMD_AUTO")) then
			Wardrobe.ToggleAutoSwaps(var);
		elseif (command == TEXT("CMD_ON")) then
			Wardrobe.Toggle(1);
		elseif (command == TEXT("CMD_OFF")) then
			Wardrobe.Toggle(0);
		elseif (command == TEXT("CMD_LOCK")) then
			Wardrobe.ToggleLockButton(true);
		elseif (command == TEXT("CMD_UNLOCK")) then
			Wardrobe.ToggleLockButton(false);
		elseif (command == TEXT("CMD_CLICK")) then
			Wardrobe.ToggleClickButton(true);
		elseif (command == TEXT("CMD_MOUSEOVER")) then
			Wardrobe.ToggleClickButton(false);
		elseif (command == TEXT("CMD_TOOLTIPS")) then
			Wardrobe.ToggleTooltips(var);
		elseif (command == TEXT("CMD_SCALE")) then
			Wardrobe.SetDropDownScale(var);
		elseif (command == TEXT("CMD_VERSION")) then
			Wardrobe.Print(TEXT("TXT_WARDROBEVERSION").." "..WARDROBE_VERSION);
		elseif (command == "testcheck") then
			Wardrobe.ShowWardrobe_ConfigurationScreen();
		elseif (command == "testsort") then
			Wardrobe.ShowMainMenu();
		elseif (command == "debug") then
			Wardrobe.ToggleDebug();
		elseif (command == "report") then
			Wardrobe.DumpDebugReport();
		elseif (command == "itemlist") then
			Wardrobe.BuildItemList();
		elseif (command == "struct") then
			Wardrobe.DumpDebugStruct();
		else
			Wardrobe.ShowHelp();
		end
	end
end



--============================================================================================--
--============================================================================================--
--																							--
--							  WARDROBE MAIN FUNCTIONS									   --
--																							--
--============================================================================================--
--============================================================================================--

---------------------------------------------------------------------------------
-- Each character on an account has an ID assigned to it that specifies its wardrobes
-- This function returns the ID associated with this character
---------------------------------------------------------------------------------
function Wardrobe.GetThisCharactersWardrobeID()

--	Wardrobe.Debug("Looking up this character's wardrobe number...");

	-- upgrade old versions
	if ( Wardrobe_Config.version == nil ) then
		Wardrobe_Config = nil;
		Wardrobe_Config = { };
		Wardrobe_Config.Enabled				 = true;
--		Wardrobe_Config.xOffset				 = 10;
--		Wardrobe_Config.yOffset				 = 39;
--		Wardrobe_Config.DefaultCheckboxState	= 1;	   -- default state for the checkboxes when specifying what equipment slots make up an outfit on the character paperdoll screen
--		Wardrobe_Config.MustClickUIButton	   = false;   -- default state for the checkboxes when specifying what equipment slots make up an outfit on the character paperdoll screen
		Wardrobe_Config.version = WARDROBE_VERSION;
		Wardrobe.Print("Erasing old Wardrobe_Config because it don't support realm");
	elseif ( not Wardrobe_Config.version == WARDOBE_VERSION ) then
		Wardrobe_Config.version = WARDROBE_VERSION;
	end

	-- Look for this realm in the wardrobe table
	WD_RealmName = GetRealmName();
	WD_realmID = nil;

	for i = 1, #(Wardrobe_Config) do
		if ( Wardrobe_Config[i].RealmName == WD_RealmName ) then
			WD_realmID = i;
			break;
		end
	end

	-- if we didn't find this realm, add us to the wardrobe table
	if (not WD_realmID) then
		Wardrobe.AddThisRealmToWardrobeTable();
		WD_realmID = #(Wardrobe_Config);
	end


	-- look for this character in the wardrobe table
	WD_charID = nil;
	WD_PlayerName = UnitName("player")

	for i = 1, #(Wardrobe_Config[WD_realmID]) do
		if (Wardrobe_Config[WD_realmID][i].PlayerName == WD_PlayerName) then
			WD_charID = i;
			break;
		end
	end

	-- if we didn't find this character, add us to the wardrobe table
	if (not WD_charID) then
		Wardrobe.AddThisCharacterToWardrobeTable();
		WD_charID = #(Wardrobe_Config[WD_realmID]);
		Wardrobe.newChar = true
	end

	Wardrobe.CurrentConfig = Wardrobe_Config[WD_realmID][WD_charID];

	Wardrobe.Debug("This character's wardrobe number is: "..WD_charID);
	Wardrobe.Debug("This character's realm is: "..WD_realmID);
--	Wardrobe.Debug("Wardrobe.CurrentConfig: ", Wardrobe.CurrentConfig);


	-- flag that we've already found / created this character's wardrobe entry
	Wardrobe.AlreadySetCharactersWardrobeID = true;

end


---------------------------------------------------------------------------------
-- Checks to see if we've already looked up the number associated with this character
-- If not, grab the number
---------------------------------------------------------------------------------
function Wardrobe.CheckForOurWardrobeID()
	if (not Wardrobe.AlreadySetCharactersWardrobeID) then
		Wardrobe.GetThisCharactersWardrobeID();
	end
end


-- NOTES ABOUT DATASTRUCTURES:
--
-- For each character, the wardrobes are stored in a datastructure that looks like this
--
-- x = total number of outfits
-- y = total slots on a character (head, feet, hands, etc)
--
-- Outfit[x]		  -- the datastructure for a single outfit
--
--	 OutfitName	   -- the name of this outfit
--	 Available		-- true if all of the items in this outfit are in our bags or equiped
--	 Mounted		  -- true if this is the outfit to be worn when we mount
--	 Item[1]		  -- the data structure for all the items in this outfit
--		  Name		-- the name of the item
--		  IsSlotUsed  -- 1 if this outfit uses this slot, 0 if not (i.e. an outfit might not involve your trinkets, or might only consist of your rings)
--		.
--		.
--		.
--	 Item[y]
--
-- So, let's say you have two outfits in your wardrobe.  Wardrobe[1] represents outfit 1, and Wardrobe[2]
-- represents outfit 2.  for outfit 1, Wardrobe[1].OutfitName would be the name of this outfit (say, "In town outfit").
-- the item on your character slot 5 would be Wardrobe[1].Item[5].Name.  Since all these are stored per character, the
-- actual datastructure would look like:
--
-- Wardrobe_Config[WD_realmID][3].Wardrobe[1].Item[5].Name --> for character 3, outfit 1, item 5


---------------------------------------------------------------------------------
-- Add an entry for this realm to the main table of wardrobes
---------------------------------------------------------------------------------
function Wardrobe.AddThisRealmToWardrobeTable()

	Wardrobe.Debug("Didn't find a wardrobe ID for this realm.  Adding this realm to the table...");

	-- build the structure for this realm's wardrobe
	tempTable = { };
	tempTable.RealmName = WD_RealmName;

	-- stick this structure into the main table of wardrobes
	tinsert(Wardrobe_Config, tempTable);
end


---------------------------------------------------------------------------------
-- Add an entry for this character to the main table of wardrobes
---------------------------------------------------------------------------------
function Wardrobe.AddThisCharacterToWardrobeTable()

	Wardrobe.Debug("Didn't find a wardrobe ID for this character.  Adding this character to the table...");

	-- build the structure for this char's wardrobe
	tempTable = { };
	tempTable.PlayerName = WD_PlayerName
	tempTable.Outfit = { };

	-- stick this structure into the main table of wardrobes
	tinsert(Wardrobe_Config[WD_realmID], tempTable);
end


---------------------------------------------------------------------------------
-- Create and return a blank outfit structure
---------------------------------------------------------------------------------
function Wardrobe.CreateBlankOutfit()
	local tempTable2 = { };
	tempTable2.OutfitName = "";
	tempTable2.Available = false;
	tempTable2.ButtonColor = WARDROBE_DEFAULT_BUTTON_COLOR;
	tempTable2.Item = { };

	return tempTable2;
end


---------------------------------------------------------------------------------
-- Add the named outfit to our wardrobe
---------------------------------------------------------------------------------
function Wardrobe.AddNewOutfit(outfitName, buttonColor)

	 if (Wardrobe_Config.Enabled) then

		-- if we haven't already looked up our character's number
		Wardrobe.CheckForOurWardrobeID();

		if (not outfitName or outfitName == "") then
			return;
		end

		-- make sure we don't already have an outfit with the same name
		if (Wardrobe.FoundOutfitName(outfitName)) then
			Wardrobe.Print(TEXT("TXT_OUTFITNAMEEXISTS"));
			return;
		end

		Wardrobe.Debug("Trying to set this wardrobe as \""..outfitName.."\"");

		-- if we found a free outfit slot
		local outfitNum = Wardrobe.GetNextFreeOutfitSlot();
		-- store our current equipment in this outfit
		Wardrobe.StoreItemsInOutfit(outfitName, outfitNum, "added");
		Wardrobe.CurrentConfig.Outfit[outfitNum].ButtonColor = buttonColor;

		Wardrobe.UpdatePanel();

	end
end


---------------------------------------------------------------------------------
-- Create and return the index of the next free outfit slot
---------------------------------------------------------------------------------
function Wardrobe.GetNextFreeOutfitSlot()
	-- append an empty slot
	local outfits = Wardrobe.CurrentConfig.Outfit;
	tinsert(outfits, Wardrobe.CreateBlankOutfit());
	return #outfits;
end

function Wardrobe.GetNextFreeVirtualOutfitSlot(virtualOutfitName)
	-- append an empty slot
	local outfits = Wardrobe.CurrentConfig.VirtualOutfit;

	--Remove Duplicates
	for i, oufit in ipairs(outfits) do
		if (oufit.OutfitName == virtualOutfitName) then
			tremove(outfits, i);
		end
	end

	-- add another outfit to the list and return its index
	tinsert(outfits, Wardrobe.CreateBlankOutfit());
	return #outfits;
end

function Wardrobe.GetNumOutfits()
	return #Wardrobe.CurrentConfig.Outfit;
end


---------------------------------------------------------------------------------
-- Store our currently equipped items in the specified outfit name
---------------------------------------------------------------------------------
function Wardrobe.StoreItemsInOutfit(outfitName, outfitNum, printMessage, isVirtual)

	-- store the name of this outfit
	local outfit;
	if (isVirtual) then
		outfit = Wardrobe.CurrentConfig.VirtualOutfit[outfitNum];
	else
		outfit = Wardrobe.CurrentConfig.Outfit[outfitNum];
	end
	if (not outfit) then
		-- error?
		Wardrobe.Debug(outfitName, outfitNum, printMessage)
		return;
	end
	outfit.OutfitName = outfitName;
	outfit.Special = nil;

	-- for each slot on our character's person (hands, feet, etc)
	for i = 1, Wardrobe.InventorySlotsSize do
		if (Wardrobe.ItemCheckState[i] == 1) then
			if (not outfit.Item[i]) then
				outfit.Item[i] = {};
			end
			local item = outfit.Item[i];
			item.IsSlotUsed = 1
			local itemString, itemID, permEnchant, suffix, reforgeId, itemName = WearMe.GetInventoryItemInfo(Wardrobe.InventorySlotIDs[i]);
			item.ItemString = itemString;
			item.Name = itemName;
			item.ItemID = itemID;
			item.Suffix = suffix;
			item.PermEnchant = permEnchant;
			item.ReforgeId = reforgeId;
			if(Wardrobe.ItemDisplayingState) then
				item.Display = Wardrobe.ItemDisplayingState[i];
			end
			
			if (WardrobeAce.db.profile.syncToEquipMgr) then
  				EquipmentManagerUnignoreSlotForSave(Wardrobe.InventorySlotIDs[i]) -- removes the ignore flag from a slot when saving an equipment set.
  			end
--			Wardrobe.Debug("	Setting USED slot "..Wardrobe.InventorySlots[i].." = ["..tostring(itemString).."]");
		else
			outfit.Item[i] = nil;
			
			if (WardrobeAce.db.profile.syncToEquipMgr) then
				EquipmentManagerIgnoreSlotForSave(Wardrobe.InventorySlotIDs[i]) -- flags the slot to be ignored when saving an equipment set.
			end		
			
--			Wardrobe.Debug("	Setting unused slot "..Wardrobe.InventorySlots[i]);
		end
	end

	-- all the items in this outfit are currently available in the player's inventory
	outfit.Available = true;

	if (WardrobeAce.db.profile.syncToEquipMgr and not Wardrobe.EquipMgrSyncInProgress) then
		if(outfit.Icon == nil) then
			local icon = GetEquipmentSetInfoByName(outfitName);
			if(icon ~= nil and icon ~= "1")  then
				outfit.Icon = "Interface\\Icons\\"..icon;
			else
				outfit.Icon = "Interface\\Icons\\INV_MISC_QUESTIONMARK";
			end
		end
		local iconName = gsub( outfit.Icon, "Interface\\Icons\\", "");
		Wardrobe.Debug("About to save set to EquipmentManager: outfitName=",outfitName," icon=",iconName);
--		local iconIndex = 1;
--		if(icon ~= nil) then
--			iconIndex = Wardrobe.getEquipmentManagerIconIndex(outfit.Icon);
--		end
--		Wardrobe.Debug("About to save set to EquipmentManager(2): outfitName=",outfitName," icon=",icon," iconIndex=",iconIndex);
		Wardrobe.EquipMgrSyncInProgress = true;
		SaveEquipmentSet(outfitName, iconName);
		Wardrobe.EquipMgrSyncInProgress = false;
	else
		if(outfit.Icon == nil) then
			outfit.Icon = "Interface\\Icons\\INV_MISC_QUESTIONMARK";
		end
	end

	-- clear tooltip cache since the item outfit may have changed
	Wardrobe.LastCheckedTooltipItem = {};
	
	-- refresh Baggins if it is loaded
    WardrobeAce.Baggins.Refresh();
    
	if (printMessage) then
		Wardrobe.Print(TEXT("TXT_OUTFIT").." \""..outfitName.."\" "..printMessage..".");
	end
end

---------------------------------------------------------------------------------
-- get icon to use from equipment manager
---------------------------------------------------------------------------------
function Wardrobe.getEquipmentManagerIconIndex(icon)
	local EM_ICON_FILENAMES = {};
	EM_ICON_FILENAMES[1] = "INV_MISC_QUESTIONMARK";
	local index = 2;

	for i = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
		local itemTexture = GetInventoryItemTexture("player", i);
		if ( itemTexture ) then
			EM_ICON_FILENAMES[index] = gsub( strupper(itemTexture), "INTERFACE\\ICONS\\", "" );
			if(EM_ICON_FILENAMES[index]) then
				index = index + 1;
				--[[
				Currently checks all for duplicates, even though only rings, trinkets, and weapons may be duplicated. 
				This version is clean and maintainable.
				]]
				for j=INVSLOT_FIRST_EQUIPPED, (index-1) do
					if(EM_ICON_FILENAMES[index] == EM_ICON_FILENAMES[j]) then
						EM_ICON_FILENAMES[index] = nil;
						index = index - 1;
						break;
					end
				end
			end
		end
	end
	GetMacroItemIcons(EM_ICON_FILENAMES);
	GetMacroIcons(EM_ICON_FILENAMES);

--	return EM_ICON_FILENAMES[index];
	
	for i=1, #EM_ICON_FILENAMES do
		Wardrobe.Debug("Compare",icon,"to Interface\\Icons\\"..EM_ICON_FILENAMES[i]);
		if(icon == "Interface\\Icons\\"..EM_ICON_FILENAMES[i]) then
			return i;
		end
	end
	
	return 1;
	
end


---------------------------------------------------------------------------------
-- Update an outfit
---------------------------------------------------------------------------------
function Wardrobe.UpdateOutfit(outfitName, buttonColor)

	if (Wardrobe_Config.Enabled) then

		-- if we haven't already looked up our character's number
		Wardrobe.CheckForOurWardrobeID();

		-- check to see if the wardrobe doesn't exist
		if (outfitName == nil or outfitName == "") then
			Wardrobe.Print(TEXT("TXT_PLEASEENTERNAME"));
		elseif (not Wardrobe.FoundOutfitName(outfitName)) then
			Wardrobe.Print(TEXT("TXT_OUTFITNOTEXIST"));
			UIErrorsFrame:AddMessage(TEXT("TXT_NOTEXISTERROR"), 1.0, 0.0, 0.0, 1.0, UIERRORS_HOLD_TIME);
		else

			-- find the outfit to update
			for i, outfit in ipairs(Wardrobe.CurrentConfig.Outfit) do

				-- if we found the outfit, store our equipment
				if (outfit.OutfitName == outfitName) then
					Wardrobe.StoreItemsInOutfit(outfitName, i, TEXT("TXT_UPDATED"));
					outfit.ButtonColor = buttonColor;

					Wardrobe.UpdatePanel()

				end

			end
		end
	end
end

---------------------------------------------------------------------------------
-- add hook for modifying equipment sets from Equipment Manager
---------------------------------------------------------------------------------

function Wardrobe.New_ModifyEquipmentSet(oldName, outfitName, icon)
	Wardrobe.Debug("Detected ModifyEquipmentSet(oldName, name, iconIndex) call oldName=",oldName,"outfitName=",outfitName,"icon=",icon,"syncInProgress=",Wardrobe.EquipMgrSyncInProgress,"syncToEquipMgr=",WardrobeAce.db.profile.syncToEquipMgr);
	if(WardrobeAce.db.profile.syncToEquipMgr and not Wardrobe.EquipMgrSyncInProgress) then
--[[	
		if(Wardrobe.ItemCheckState == nil) then Wardrobe.ItemCheckState = {} end
		for i = 1, Wardrobe.InventorySlotsSize do
			if(not EquipmentManagerIsSlotIgnoredForSave(Wardrobe.InventorySlotIDs[i])) then
				Wardrobe.ItemCheckState[i] = 1;
			else
				Wardrobe.ItemCheckState[i] = 0;
			end
		end

		local outfitNum;
		local outfit;
		if(Wardrobe.FoundOutfitName(outfitName)) then
			outfitNum = Wardrobe.GetOutfitNum(outfitName);
			outfit = Wardrobe.CurrentConfig.Outfit[outfitNum];
			Wardrobe.StoreItemsInOutfit(outfitName, outfitNum);
		else
			Wardrobe.AddNewOutfit(outfitName, WARDROBE_DEFAULT_BUTTON_COLOR);
			outfitNum = Wardrobe.GetOutfitNum(outfitName);
			outfit = Wardrobe.CurrentConfig.Outfit[outfitNum];
		end
]]--
		if(Wardrobe.FoundOutfitName(oldName)) then
			if(oldName ~= outfitName) then
				Wardrobe.EquipMgrSyncInProgress = true;
				Wardrobe.RenameOutfit(oldName,outfitName);
				Wardrobe.EquipMgrSyncInProgress = false;
			end
			local outfitNum = Wardrobe.GetOutfitNum(outfitName);
			local outfit =  Wardrobe.CurrentConfig.Outfit[outfitNum];
--			local icon = GetEquipmentSetInfoByName(outfitName);
			if(icon ~= nil) then
				outfit.Icon = "Interface\\Icons\\"..icon;
			end;
		end		
		
		-- all the items in this outfit are currently available in the player's inventory
		--outfit.Available = true;
		
		Wardrobe.UpdatePanel();	
		if (Wardrobe_MainMenuFrame:IsVisible()) then
			Wardrobe.PopulateMainMenu();
		end

	end

end

hooksecurefunc("ModifyEquipmentSet", Wardrobe.New_ModifyEquipmentSet) 

---------------------------------------------------------------------------------
-- add hook for adding equipment sets from Equipment Manager
---------------------------------------------------------------------------------

function Wardrobe.New_SaveEquipmentSet(outfitName, icon)
	Wardrobe.Debug("Detected SaveEquipmentSet(name, iconIndex) call outfitName=",outfitName,"icon=",icon,"syncInProgress=",Wardrobe.EquipMgrSyncInProgress,"syncToEquipMgr=",WardrobeAce.db.profile.syncToEquipMgr);
	if(WardrobeAce.db.profile.syncToEquipMgr and not Wardrobe.EquipMgrSyncInProgress) then
		if(Wardrobe.ItemCheckState == nil) then Wardrobe.ItemCheckState = {} end
		for i = 1, Wardrobe.InventorySlotsSize do
			if(not EquipmentManagerIsSlotIgnoredForSave(Wardrobe.InventorySlotIDs[i])) then
				Wardrobe.ItemCheckState[i] = 1;
			else
				Wardrobe.ItemCheckState[i] = 0;
			end
		end

		Wardrobe.EquipMgrSyncInProgress = true;	
		
		local outfitNum;
		local outfit;
		if(Wardrobe.FoundOutfitName(outfitName)) then
			outfitNum = Wardrobe.GetOutfitNum(outfitName);
			outfit = Wardrobe.CurrentConfig.Outfit[outfitNum];
			Wardrobe.StoreItemsInOutfit(outfitName, outfitNum);
		else
			Wardrobe.AddNewOutfit(outfitName, WARDROBE_DEFAULT_BUTTON_COLOR);
			outfitNum = Wardrobe.GetOutfitNum(outfitName);
			outfit = Wardrobe.CurrentConfig.Outfit[outfitNum];
		end

        Wardrobe.EquipMgrSyncInProgress = false;
        
--		local icon = GetEquipmentSetInfoByName(outfitName);
		if(icon ~= nil) then
			outfit.Icon = "Interface\\Icons\\"..icon;
		end;
		
		-- all the items in this outfit are currently available in the player's inventory
		outfit.Available = true;
	
		Wardrobe.UpdatePanel();
		if (Wardrobe_MainMenuFrame:IsVisible()) then
			Wardrobe.PopulateMainMenu();
		end

	end

end

hooksecurefunc("SaveEquipmentSet", Wardrobe.New_SaveEquipmentSet) 

---------------------------------------------------------------------------------
-- add hook for deleting equipment sets from Equipment Manager
---------------------------------------------------------------------------------

function Wardrobe.New_DeleteEquipmentSet(outfitName)
	Wardrobe.Debug("Detected DeleteEquipmentSet(name) call outfitName=",outfitName);
	if(WardrobeAce.db.profile.syncToEquipMgr and not Wardrobe.EquipMgrSyncInProgress) then
		Wardrobe.EquipMgrSyncInProgress = true;
		if(Wardrobe.FoundOutfitName(outfitName)) then	
			Wardrobe.EraseOutfit(outfitName);
		end
		Wardrobe.EquipMgrSyncInProgress = false;
		Wardrobe.UpdatePanel();
		if (Wardrobe_MainMenuFrame:IsVisible()) then
			Wardrobe.PopulateMainMenu();
		end
	end
end

hooksecurefunc("DeleteEquipmentSet", Wardrobe.New_DeleteEquipmentSet)

 
---------------------------------------------------------------------------------
-- Check to see if the specified outfit name is already being used
---------------------------------------------------------------------------------
function Wardrobe.FoundOutfitName(outfitName)

	for i, outfit in ipairs(Wardrobe.CurrentConfig.Outfit) do
		if (outfit.OutfitName == outfitName) then
			return true;
		end
	end

	return false;
end

function Wardrobe.FoundVirtualOutfitName(outfitName)

	for i, outfit in ipairs(Wardrobe.CurrentConfig.VirtualOutfit) do
		if (outfit.OutfitName == outfitName) then
			return true;
		end
	end

	return false;
end

---------------------------------------------------------------------------------
-- Return the index of the specified outfitName
---------------------------------------------------------------------------------
function Wardrobe.GetOutfitNum(outfitName)

	for i, outfit in ipairs(Wardrobe.CurrentConfig.Outfit) do
		if (outfit.OutfitName == outfitName) then
			return i;
		end
	end
end

function Wardrobe.GetVirtualOutfitNum(outfitName)

	for i, outfit in ipairs(Wardrobe.CurrentConfig.VirtualOutfit) do
		if (outfit.OutfitName == outfitName) then
			return i;
		end
	end
end

---------------------------------------------------------------------------------
-- Add some default outfits to the list, one for what is currently being worn,
-- one for birthday suit, and fishing
---------------------------------------------------------------------------------
function Wardrobe.AddDefaultOutfits()

	-- if we haven't already looked up our character's number
	Wardrobe.CheckForOurWardrobeID();

	-- make sure we are using a fresh cache
	WearMe.VerifyCache();

	Wardrobe.CurrentOutfitButtonColor = WARDROBE_DEFAULT_BUTTON_COLOR;
	if(Wardrobe.ItemCheckState == nil) then Wardrobe.ItemCheckState = {} end

	-- add default
	if (not Wardrobe.FoundOutfitName("Default")) then
		--toggle all items on
		for i, slotName in pairs(Wardrobe.InventorySlots) do
			Wardrobe.ItemCheckState[i] = 1;
		end

		--add default outfit
		Wardrobe.AddNewOutfit("Default", Wardrobe.CurrentOutfitButtonColor);
	end

	local oldSyncSetting = WardrobeAce.db.profile.syncToEquipMgr;

	-- add birthday suit
	if (not Wardrobe.FoundOutfitName("Birthday Suit")) then
	
		WardrobeAce.db.profile.syncToEquipMgr = false;  -- do not add this one to the equipment manager..
		
		--toggle all items on
		for i, slotName in pairs(Wardrobe.InventorySlots) do
			Wardrobe.ItemCheckState[i] = 1;
		end

		--add default outfit
		Wardrobe.AddNewOutfit("Birthday Suit", Wardrobe.CurrentOutfitButtonColor);
		local outfitNum = Wardrobe.GetOutfitNum("Birthday Suit");
		local outfit = Wardrobe.CurrentConfig.Outfit[outfitNum];

		for i = 1, Wardrobe.InventorySlotsSize do
			local item = outfit.Item[i];
			if(not item) then item = {} end
			item.IsSlotUsed = 1
			item.ItemString = nil;
			item.Name = nil;
			item.ItemID = nil;
		end
	end

	-- add any fishing items to a fishing outfit
	if (not Wardrobe.FoundOutfitName("Fishing")) then
		local fishingPole = nil
		local fishingHat = nil
		
		WardrobeAce.db.profile.syncToEquipMgr = false;  -- do not add this one to the equipment manager..

		--look for any items in bags that are fishing items
		for itemId, slot in pairs(Wardrobe.FishingItems) do

			Wardrobe.Debug("Looking for",itemId,slot,"in bags/inventory");

			if (WearMe.PlayerHasItem(itemId)) then

				Wardrobe.Debug("Found",itemId);

				if(slot == "MainHandSlot" and not fishingPole) then fishingPole = itemId
				elseif(slot == "HeadSlot" and not fishingHat) then fishingHat = itemId
				end
			end
		end

		Wardrobe.Debug("FishingPole=",fishingPole);
		Wardrobe.Debug("FishingHat=",fishingHat);


		if(fishingPole or fishingHat) then
			--toggle all items off
			for i, slotName in pairs(Wardrobe.InventorySlots) do
				Wardrobe.ItemCheckState[i] = 0;
			end

			--add default outfit
			Wardrobe.AddNewOutfit("Fishing", Wardrobe.CurrentOutfitButtonColor);
			local outfitNum = Wardrobe.GetOutfitNum("Fishing");
			local outfit = Wardrobe.CurrentConfig.Outfit[outfitNum];
			local itemString
			local itemID
			local itemName

			--add any fishing items I found
			if fishingPole then
				local bag, slot = WearMe.FindContainerItemByID(fishingPole);
				if(bag and slot) then --found in bag
					itemString, itemID, _, _, _, itemName = WearMe.GetContainerItemInfo(bag, slot);

					Wardrobe.Debug("trying to add fishing pole", itemString,itemId,itemName,"to Fishing Outfit")

				else
					slotInv = WearMe.FindInventoryItemByID(fishingHat);
					if(slotInv) then
						itemString, itemID, _, _, _, itemName = WearMe.GetInventoryItemInfo(invSlot);
					end
				end

				if(itemString or itemName) then

					Wardrobe.Debug("Setting MainHandSlot=",itemID,itemName,itemString)

					local item = {}
					item.IsSlotUsed = 1
					item.ItemString = itemString;
					item.Name = itemName;
					item.ItemID = fishingPole
--					Wardrobe.ItemCheckState[16] = 1;
					outfit.Item[17] = item;
				end
			end

			--add any fishing head items I found
			if fishingHat then
				itemName = nil;
				itemString = nil;
				local bag, slot = WearMe.FindContainerItemByID(fishingHat);
				if(bag and slot) then --found in bag
					itemString, itemID, _, _, _, itemName = WearMe.GetContainerItemInfo(bag, slot);
				else
					slotInv = WearMe.FindInventoryItemByID(fishingHat);
					if(slotInv) then
						itemString, itemID, _, _, _, itemName = WearMe.GetInventoryItemInfo(invSlot);
					end
				end

				if(itemString or itemName) then

					Wardrobe.Debug("Setting HeadSlot=",itemID,itemName,itemString)

					local item = {};
					item.IsSlotUsed = 1
					item.ItemString = itemString;
					item.Name = itemName;
					item.ItemID = fishingHat
					outfit.Item[1] = item;
--					Wardrobe.ItemCheckState[1] = 1;
				end
			end

		end
	end
	
	WardrobeAce.db.profile.syncToEquipMgr = oldSyncSetting;

	Wardrobe.UpdatePanel()

end

---------------------------------------------------------------------------------
-- Erase the named outfit
---------------------------------------------------------------------------------
function Wardrobe.EraseOutfit(outfitName, silent, eraseAll, virtual)

	if (Wardrobe_Config.Enabled) then

		-- if we haven't already looked up our character's number
		Wardrobe.CheckForOurWardrobeID();

		Wardrobe.Debug("Trying to delete outfit \""..outfitName.."\"");

		local found = false;
		-- find the outfit to erase
		local outfits;
		if (virtual) then
			outfits = Wardrobe.CurrentConfig.VirtualOutfit;
		else
			outfits = Wardrobe.CurrentConfig.Outfit;
		end
		for i = 1, #(outfits) do
			-- if we found the outfit
			if (outfits[i]) and (outfits[i].OutfitName == outfitName) then
				-- remove the outfit
				tremove(outfits, i);
				found = true;
				if (not eraseAll) then
					break;
				else
					i = 1;
				end
			end
		end

		--try to remove from server too
		if (WardrobeAce.db.profile.syncToEquipMgr and not Wardrobe.EquipMgrSyncInProgress) then
			Wardrobe.EquipMgrSyncInProgress = true;
			DeleteEquipmentSet(outfitName);
			Wardrobe.EquipMgrSyncInProgress = false;
		end
		
		if (found) then
			if (not eraseAll) and (not silent) then
				Wardrobe.Print(TEXT("TXT_OUTFIT").." \""..outfitName.."\" "..TEXT("TXT_DELETED"));
				Wardrobe.ListOutfits();
				UIErrorsFrame:AddMessage(TEXT("TXT_OUTFIT").." \""..outfitName.."\" "..TEXT("TXT_DELETED"), 0.0, 1.0, 0.0, 1.0, UIERRORS_HOLD_TIME);
			end
		else
			Wardrobe.Print(TEXT("TXT_UNABLETOFIND").." \""..outfitName.."!\"");
			UIErrorsFrame:AddMessage(TEXT("TXT_UNABLEFINDERROR"), 1.0, 0.0, 0.0, 1.0, UIERRORS_HOLD_TIME);
		end
		return found;
	end
end


---------------------------------------------------------------------------------
-- Erase all our outfits
---------------------------------------------------------------------------------
function Wardrobe.EraseAllOutfits()

	if (Wardrobe_Config.Enabled) then

		-- if we haven't already looked up our character's number
		Wardrobe.CheckForOurWardrobeID();

		-- delete all the outfits
		Wardrobe.CurrentConfig.Outfit = { };

		-- hide the main menu
		Wardrobe.ToggleMainMenuFrameVisibility(false);

		Wardrobe.Print(TEXT("TXT_ALLOUTFITSDELETED"));
		UIErrorsFrame:AddMessage(TEXT("TXT_ALLOUTFITSDELETED"), 0.0, 1.0, 0.0, 1.0, UIERRORS_HOLD_TIME);
	end
end


---------------------------------------------------------------------------------
-- Print a list of our outfits
---------------------------------------------------------------------------------
function Wardrobe.ListOutfits(var)

	if (Wardrobe_Config.Enabled) then

		-- if we haven't already looked up our character's number
		Wardrobe.CheckForOurWardrobeID();

		local foundOutfits = false;
		Wardrobe.Print(TEXT("TXT_YOURCURRENTARE"));

		local outfitList = "";
		-- for each outfit
		for i, outfit in ipairs(Wardrobe.CurrentConfig.Outfit) do

			-- if it has a name and isn't virtual
			if (outfit.OutfitName ~= "") then
				local colorTable = WARDROBE_TEXTCOLORS[outfit.ButtonColor]
				local color = "|c"..format("FF%.2X%.2X%.2X", (colorTable[1] or 1) * 255, (colorTable[2] or 1) * 255, (colorTable[3] or 1) * 255);
				local str = color..(outfit.OutfitName).."|r, ";

				-- if we asked for a detailed printout, show all the items
				if (var == "items") then
					Wardrobe.Print(str);
					for j = 1, Wardrobe.InventorySlotsSize do
						local item = outfit.Item[j];
						if (item) and (item.Name) and (item.Name ~= "") then
							Wardrobe.Print("		["..Wardrobe.InventorySlots[j].." -> ".. item.Name.."]");
						end
					end

				else
					outfitList = outfitList..color..(outfit.OutfitName).."|r, ";
				end

				foundOutfits = true;
			end
		end

		if (foundOutfits) then
			if (var ~= "items") then
				Wardrobe.Print(strsub(outfitList, 0, strlen(outfitList)-2));
			end
		else
			Wardrobe.Print("  "..TEXT("TXT_NOOUTFITSFOUND"));
		end
	end
end

function Wardrobe.UpdateGlobalVisibilitySettings()

	--if character panel is showing, don't do anything.
	if(Wardrobe.ShowingCharacterPanel or Wardrobe.Current_Outfit == 0 or not WardrobeAce.db.char.showHelmCloakFunctionEnabled) then
		return;
	end

	 -- if we haven't already looked up our character's number
	Wardrobe.CheckForOurWardrobeID();

	local outfits = Wardrobe.CurrentConfig.Outfit;
	if(outfits) then
		local outfit = outfits[Wardrobe.Current_Outfit];
		if(outfit) then
			for i = 1, Wardrobe.InventorySlotsSize do
				local displayAction = Wardrobe.DisplayToggleableInventorySlots[Wardrobe.InventorySlotIDs[i]];
				if (displayAction ~= nil and outfit.Item[i] ~= nil) then
					if (outfit.Item[i].Display == nil) then
						--if this item is set to be ignored, update the global saved setting
--						outfit.Item[i].SaveSetting();
					end
				end
			end
		end
	end

end

function Wardrobe.WearOutfitCallback(caller, wardrobeName)

	Wardrobe.WearOutfit(wardrobeName)

end


---------------------------------------------------------------------------------
-- Wear an outfit
---------------------------------------------------------------------------------
function Wardrobe.WearOutfit(wardrobeName, silent, isVirtual)

	if (Wardrobe_Config.Enabled) then

		 -- if we haven't already looked up our character's number
		Wardrobe.CheckForOurWardrobeID();

		local outfits;
		if (isVirtual) then
			outfits = Wardrobe.CurrentConfig.VirtualOutfit;
		else
			outfits = Wardrobe.CurrentConfig.Outfit;
		end
		local outfit;

		-- if the user didn't specify a wardrobe to wear
		if (not wardrobeName) then

			Wardrobe.Print(TEXT("TXT_SPECIFYOUTFITTOWEAR"));
			return;

		-- else use the specified wardrobe
		elseif (type(wardrobeName) == "number") then
			local outfitNumber = wardrobeName;
			wardrobeName = outfits[outfitNumber].OutfitName;
			if (wardrobeName) then
				Wardrobe.Debug("Wardrobe.WearOutfit: Found outfit at #".. outfitNumber);
				outfit = outfits[outfitNumber];
			else
				Wardrobe.Print(TEXT("TXT_UNABLEFIND").." \""..wardrobeName.."\" "..TEXT("TXT_INYOURLISTOFOUTFITS"));
				return;
			end
		else
			local outfitNumber = 0;
			for i = 1, #outfits do
				local name = outfits[i].OutfitName
				if (name) then
					Wardrobe.Debug("In WearOutfit, Looking at outfit #"..i.."  name = [".. name.."]");
					if (name == wardrobeName) then
						outfitNumber = i;
						Wardrobe.Debug("Wardrobe.WearOutfit: Found outfit at #"..outfitNumber);
						break;
					end
				end
			end

			if (outfitNumber == 0) then
				Wardrobe.Print(TEXT("TXT_UNABLEFIND").." \""..wardrobeName.."\" "..TEXT("TXT_INYOURLISTOFOUTFITS"));
				return;
			end

			outfit = outfits[outfitNumber];
		end

		if(Wardrobe.InCombat) then
			Wardrobe.Print("Wardrobe: Cannot wear outfit \""..wardrobeName.."\" because you are in combat.");
			UseEquipmentSet(wardrobeName);
			return;
		end

		Wardrobe.Debug(TEXT("TXT_SWITCHINGTOOUTFIT").." \""..wardrobeName.."\"");

		-- this variable "freeBagSpacesUsed" lets us track which empty pack spaces we've
		-- already assigned an item to be put into.  we need to do this because when we remove
		-- items from our character and put them into our bags, the server takes time to actually
		-- move the item into the bag.  during this delay, we may be still removing items, and we
		-- may see a slot that LOOKS empty but really the server just hasn't gotten around to moving
		-- a previous item into the slot.  this variable lets us mark each empty slot once we've assigned
		-- an item to it so that we don't try to use the same empty slot for another item.
		local freeBagSpacesUsed = { };

		-- tracks how our switching is going.  if at any point we can't remove an item (bags are full, etc),
		-- this will get set to false
		local switchResult = true;
		local outfitItem;
		local updateEquipMgrFlag = false;
		-- for each slot on our character (hands, neck, head, feet, etc)
		WearMe.InitOutfit();
		
		if(not outfit.Virtual and not silent and WardrobeAce.db.profile.syncToEquipMgr) then
			local icon = GetEquipmentSetInfoByName(outfit.OutfitName);
			if(icon == nil) then
				updateEquipMgrFlag = true;
			end
		end

		for i = 1, Wardrobe.InventorySlotsSize do
			outfitItem = outfit.Item[i];
			if (outfitItem and outfitItem.IsSlotUsed) then

				--if we are in combat, verify the cache as this equipping will probably fail.
				--if(Wardrobe.IsPlayerInCombat()) then
					WearMe.VerifyCache();
				--end

				-- enable this item in equipment manager if I need to save this outfit there due to it not being there.
				if (updateEquipMgrFlag) then
					EquipmentManagerUnignoreSlotForSave(Wardrobe.InventorySlotIDs[i]) -- removes the ignore flag from a slot when saving an equipment set.
				end
				

				Wardrobe.Debug("Wardrobe: Equipping: Slot=", Wardrobe.InventorySlotIDs[i], "ItemString=", outfitItem.ItemString, "ItemID=", outfitItem.ItemID, "ItemName=", outfitItem.Name);
				if (outfitItem.ItemString) then
					if (not WearMe.RegisterToEquip(Wardrobe.InventorySlotIDs[i], outfitItem.ItemString, outfitItem.Name)) then
						if (outfitItem.Name) then
							Wardrobe.Print(TEXT("TXT_WARNINGUNABLETOFIND").." \""..outfitItem.Name.."\" "..TEXT("TXT_INYOURBAGS"));
						end
					end
				else
					-- Exception for old outfits, just use itemid and itemname
					if (not WearMe.RegisterToEquip(Wardrobe.InventorySlotIDs[i], outfitItem.ItemID, outfitItem.Name)) then
						if (outfitItem.Name) then
							Wardrobe.Print(TEXT("TXT_WARNINGUNABLETOFIND").." \""..outfitItem.Name.."\" "..TEXT("TXT_INYOURBAGS"));
						end
					end
				end
			else
				-- disable this item in equipment manager if I need to save this outfit there due to it not being there.
				if (updateEquipMgrFlag) then
  					EquipmentManagerIgnoreSlotForSave(Wardrobe.InventorySlotIDs[i]) -- flags the slot to be ignored when saving an equipment set.
				end
			end
		end

		local prevSFX = nil;
		if(not WardrobeAce.db.profile.SoundWhileSwapping) then
			prevSFX = GetCVar("Sound_EnableSFX");
			SetCVar("Sound_EnableSFX","0");
		end

		WearMe.WearOutfit();

		if(prevSFX ~= nil) then
			SetCVar("Sound_EnableSFX",prevSFX);
		end

		-- now that I have equipped the outfit, make sure it is all equipped and if so, make sure it is also
		-- saved in equipment manager if configured to do so.
		if(updateEquipMgrFlag) then
			Wardrobe.UpdateOutfitAvailability();
			if(outfit.Available) then
				icon = GetEquipmentSetInfoByName(outfit.OutfitName);
				local iconIndex = 1;
				if(icon ~= nil) then
					iconIndex = Wardrobe.getEquipmentManagerIconIndex(icon);
				end
				-- save the outfit in 1 sec so that it will capture the newly equipped items.
				WardrobeAce:ScheduleTimer(function() SaveEquipmentSet(outfit.OutfitName , iconIndex) end, 1);
			end
		end

		-- set helm/cloak visibility
		if(WardrobeAce.db.char.showHelmCloakFunctionEnabled) then
			--Show helm or cloak based on if set to.
			for i = 1, Wardrobe.InventorySlotsSize do
				local displayAction = Wardrobe.DisplayToggleableInventorySlots[Wardrobe.InventorySlotIDs[i]];
				if (displayAction ~= nil and outfit.Item[i] ~= nil) then
					if (outfit.Item[i].Display == nil) then  --if not set at all, set it to the default
						local displayState = false;
						if(displayAction.name == "HeadSlot") then 
							displayState = (WardrobeAce.db.char.defaultHelmState == 1);
						else 
							displayState = (WardrobeAce.db.char.defaultCloakState == 1);
						end;
						displayAction.toggle(displayState);					
					else
						displayAction.toggle(outfit.Item[i].Display);
					end
				end
			end
		end

		-- only errorcheck when dealing with non-virtual outfits
		if (not outfit.Virtual and not silent) then
			-- if everything went OK
			if (switchResult) then
				if ( WARDROBE_NOISY ) then
					Wardrobe.Print(TEXT("TXT_SWITCHEDTOOUTFIT").." \""..wardrobeName..".\"");
				end
				Wardrobe.Current_Outfit = outfitNumber;
			else
				Wardrobe.Print(TEXT("TXT_PROBLEMSCHANGING"));
			end
		end

		if (mrpOnMRPEvent) then
			--MyRolePlay support for swapping outfits
			mrpOnMRPEvent("CHANGE_OUTFIT", wardrobeName);
		end

	end
end


---------------------------------------------------------------------------------
-- Rename an outfit
---------------------------------------------------------------------------------
function Wardrobe.RenameOutfit(oldName, newName)

	if (Wardrobe_Config.Enabled) then

		-- check to see if the new name is already being used
		if (not Wardrobe.FoundOutfitName(newName) and newName ~= "") then
			for i = 1, #(Wardrobe.CurrentConfig.Outfit) do
				if (Wardrobe.CurrentConfig.Outfit[i].OutfitName == oldName) then
					Wardrobe.CurrentConfig.Outfit[i].OutfitName = newName;
					
					--rename in Equipment Manager too if configured to do so.
					if (WardrobeAce.db.profile.syncToEquipMgr) then
						Wardrobe.EquipMgrSyncInProgress = true;
						ModifyEquipmentSet(oldName, newName);
						Wardrobe.EquipMgrSyncInProgress = false;
					end
					
					break;
				end
			end
			UIErrorsFrame:AddMessage(TEXT("TXT_OUTFITRENAMEDERROR"), 0.0, 1.0, 0.0, 1.0, UIERRORS_HOLD_TIME);
			Wardrobe.Print(TEXT("TXT_OUTFITRENAMEDTO").." \""..oldName.."\" "..TEXT("TXT_TOWORDONLY").." \""..newName.."\"");
		end
	end
end

---------------------------------------------------------------------------------
-- Update the text on whatever panel is running
---------------------------------------------------------------------------------
function Wardrobe.UpdatePanel()

	WardrobeAce.LDB.OnUpdateText();
--[[
	if(FuBar2DB and WardrobeAce.db.profile.fubar.enabled) then
		WardrobeAce.FuBarPlugin:OnFuBarUpdateText();
	end
]]--

--	if IsAddOnLoaded("Titan") then
--		TitanPanelButton_UpdateButton(WARDROBE_TITAN_ID);
--	end

end

---------------------------------------------------------------------------------
-- return the index of the selected outfit, or nil if none
---------------------------------------------------------------------------------
function Wardrobe.FindSelectedOutfit()
	return Wardrobe.selectedOutfit;
end


---------------------------------------------------------------------------------
-- Tag this outfit to be worn when mounted
---------------------------------------------------------------------------------
function Wardrobe.SetMountedOutfit(outfitName)
	local outfitNumber;
	for i = 1, #(Wardrobe.CurrentConfig.Outfit) do
		Wardrobe.CurrentConfig.Outfit[i].Special = nil;
		if (Wardrobe.CurrentConfig.Outfit[i].OutfitName == outfitName) then
			outfitNumber = i;
		end
	end
	if (not outfitNumber) then
		Wardrobe.Print(TEXT("TXT_UNABLETOFINDOUTFIT").." \""..outfitName..".\"");
	else
		Wardrobe.CurrentConfig.Outfit[outfitNumber].Special = "mount";
		Wardrobe.Print(TEXT("TXT_OUTFIT").." \""..outfitName.."\" "..TEXT("TXT_WILLBEWORNWHENMOUNTED"));
	end
end

---------------------------------------------------------------------------------
-- Check shapeshift form to see if we should equip a special outfit for it
---------------------------------------------------------------------------------
function Wardrobe.IsTravelForm()
	local name = Wardrobe.GetShapeshiftForm();
	if(name) then
		return Wardrobe.TravelStances[name];
	else
		return false;
	end
end

function Wardrobe.IsMountCompanionSummoned()
	for i = 1, GetNumCompanions("MOUNT",1) do
		local _, _, _, _, issummoned = GetCompanionInfo("MOUNT",i);
--		Wardrobe.Debug("Wardrobe.IsMountCompanionSummoned() creatureName =",creatureName," issummoned =",issummoned);
		if (issummoned == 1) then
			return true;
		end
	end
	return false;
end

function Wardrobe.GetShapeshiftForm()
	local name = nil;
	local numForms = GetNumShapeshiftForms();
--	Wardrobe.Debug("Wardrobe.GetShapeshiftForm: NumShapeshiftForms=", numForms);
	if(numForms > 0) then
		local formId = GetShapeshiftForm(true);
--		Wardrobe.Debug("Wardrobe.GetShapeshiftForm: GetShapeshiftForm=", formId);
		if(formId > 0) then
			_, name= GetShapeshiftFormInfo(formId);
		end
--		Wardrobe.Debug("Wardrobe.GetShapeshiftForm: Form name=",name);
	end
--	if(name) then
--		Wardrobe.Debug("Wardrobe.GetShapeshiftForm: Form name=",name);
--	end
	return name;
end


---------------------------------------------------------------------------------
-- See if we're mounted
---------------------------------------------------------------------------------

function Wardrobe.IsMounted()
	if UnitOnTaxi("player") then
		return false;
	end

	if IsMounted() then
		return true;
	end

	if Wardrobe.IsTravelForm() then
	    return true;
	end

	if Wardrobe.IsMountCompanionSummoned() then
		return true;
	end

	return false;

--	Wardrobe.Debug("Wardrobe.IsMounted() =",mnt);
end

function Wardrobe.CheckForMounted()
	-- sanity check to make sure I'm not casting
	if(UnitCastingInfo("player")) then return end;

	if (WardrobeAce.db.char.AutoSwap and Wardrobe.ArenaBattlegroundCheck()) then
		local mounted = Wardrobe.IsMounted();
		return Wardrobe.EventTaskToggle(mounted, "MountState", "mount", "unmount");
	end
end


---------------------------------------------------------------------------------
-- See if we're eating/drinking
---------------------------------------------------------------------------------
function Wardrobe.PlayerIsEatingOrDrinking()
	-- check our buffs for an eat or drink buff
	for i = 1, 16 do
		local name, rank, texture = UnitBuff("player", i);
		if (texture) then
			if (string.find(texture,"INV_Misc_Fork") or string.find(texture,"INV_Drink")) then
				return 1;
			end
		end
	end
end

function Wardrobe.CheckForEatDrink()
	if (WardrobeAce.db.char.AutoSwap) then
		local eating = Wardrobe.PlayerIsEatingOrDrinking();
		return Wardrobe.EventTaskToggle(eating, "EatingState", "eat", "uneat");
	end
end

---------------------------------------------------------------------------------
-- See if we switched into or out of the plaguelands
---------------------------------------------------------------------------------
function Wardrobe.PlayerIsInPlagueZone()
	local plaguezones = Wardrobe.GetPlagueZones();
	for i = 1, #(plaguezones) do
		if (Wardrobe.CurrentZone == plaguezones[i]) then
			return true;
		end
	end
	return false;
end


---------------------------------------------------------------------------------
-- Called when we change zones
---------------------------------------------------------------------------------
function Wardrobe.ChangedZone()
	Wardrobe.CurrentZone = GetZoneText();

	Wardrobe.Debug("Wardrobe.ChangedZone: In Zone=",Wardrobe.CurrentZone);

	Wardrobe.IsInBGArena = Wardrobe.Battlegrounds[Wardrobe.CurrentZone];

	if(Wardrobe.CurrentZone == BZ["Wintergrasp"]) then
		Wardrobe.IsInWintergrasp = true;
	else
		Wardrobe.IsInWintergrasp = false;
	end

	if(Wardrobe.CurrentZone == BZ["Tol Barad Peninsula"]) then
		Wardrobe.IsInTolBarad = true;
	else
		Wardrobe.IsInTolBarad = false;
	end

	Wardrobe.Debug("Wardrobe.ChangedZone: BZ[Wintergrasp]=", BZ["Wintergrasp"], "Wardrobe.IsInWintergrasp=", Wardrobe.IsInWintergrasp);

	if(Wardrobe.IsInBGArena or Wardrobe.IsInWintergrasp or Wardrobe.IsInTolBarad) then return end;

	if (WardrobeAce.db.char.AutoSwap) then
		local inPlagueZone = Wardrobe.PlayerIsInPlagueZone();
		return Wardrobe.EventTaskToggle(inPlagueZone, nil, "plague", "unplague");
	end
end

---------------------------------------------------------------------------------
-- See if we're swimming, or at least if the breath bar is up.
---------------------------------------------------------------------------------
function Wardrobe.PlayerIsSwimming()
	local breathBar;
	for i=1,3 do
		breathBar = getglobal("MirrorTimer"..i.."Text");
		if (breathBar:IsVisible()) and (breathBar:GetText() == BREATH_LABEL) then
			return 1;
		end
	end
end

function Wardrobe.CheckForSwimming()
	if (WardrobeAce.db.char.AutoSwap) then
		local swimming = Wardrobe.PlayerIsSwimming();
		return Wardrobe.EventTaskToggle(swimming, nil, "swim", "unswim");
	end
end

---------------------------------------------------------------------------------
-- Wear the outfit specially tagged as indicated
---------------------------------------------------------------------------------
function Wardrobe.GetSpecialOutfitIndex(specialID)
	for i = 1, #(Wardrobe.CurrentConfig.Outfit) do
		if (Wardrobe.CurrentConfig.Outfit[i].Special == specialID) then
			return i;
		end
	end
end

function Wardrobe.WearSpecialOutfit(specialID, virtualOutfitName, wearIt)

	Wardrobe.CheckForOurWardrobeID();
	
	local outfitNumber = Wardrobe.GetSpecialOutfitIndex(specialID);

	if(specialID ~= "swim" and specialID ~= "eat") then
		Wardrobe.Debug("Wardrobe.WearSpecialOutfit()  specialID=",specialID," virtualOutfitName=",virtualOutfitName," wearIt=",wearIt);
	end
	

	if (outfitNumber) then
		Wardrobe.Debug("Wardrobe.WearSpecialOutfit()  specialID=",specialID," virtualOutfitName=",virtualOutfitName," wearIt=",wearIt," outfitNumber=",outfitNumber);
		if (wearIt) then
			local taskInfo = Wardrobe.WaitingListVirtualNames[specialID];
			if (taskInfo.inherit) then
				-- Inherit from a stored virtual outfit
				local inheritOutfitNumber = Wardrobe.GetSpecialOutfitIndex(Wardrobe.SpecialOutfitVirtualIDs[taskInfo.inherit]);
				local num = Wardrobe.GetVirtualOutfitNum(taskInfo.inherit);
				if(inheritOutfitNumber) then
					Wardrobe.Debug("Wardrobe.WearSpecialOutfit()  ",virtualOutfitName, " Inheriting from ", taskInfo.inherit, " ", num);
					Wardrobe.StoreVirtualOutfit(virtualOutfitName, outfitNumber, num );
				else
					Wardrobe.Debug("Wardrobe.WearSpecialOutfit()  Will not inherit from",taskInfo.inherit,"as there are no special outfits defined.");
					Wardrobe.StoreVirtualOutfit(virtualOutfitName, outfitNumber);
					if(num) then
						--clean up any virtual outfit bloat that might have been stored from before.
						Wardrobe.EraseOutfit(taskInfo.inherit, true, true, true);
					end
				end
			else
				-- remember what we're wearing before we put on the special outfit
				Wardrobe.StoreVirtualOutfit(virtualOutfitName, outfitNumber);
			end
			-- wear our special outfit
			Wardrobe.WearOutfit(outfitNumber, true);
		else
			-- re-equip the virtual outfit
			Wardrobe.CheckForEquipVirtualOutfit(virtualOutfitName);
		end
	end
end

---------------------------------------------------------------------------------
-- Trigger special outfits or add task to task list based on event trigger
---------------------------------------------------------------------------------

function Wardrobe.EventTaskToggle(value, variableName, trueTaskID, falseTaskID)

	local taskID;
	-- toggle the state and schedule wearing our tasked outfit
	if (variableName) then
--		Wardrobe.Debug("Value: ", value, " ", variableName, " ", Wardrobe[variableName]);
		if (value) and (not Wardrobe_Config[variableName]) then
			taskID = trueTaskID;
		elseif (not value) and (Wardrobe_Config[variableName]) then
			taskID = falseTaskID;
		end
	else
		if (value) then
			taskID = trueTaskID;
		else
			taskID = falseTaskID;
		end
	end

	if (taskID) then
		if(taskID ~= "unswim" and taskID ~= "uneat") then
			Wardrobe.Debug("Wardrobe.EventTaskToggle() Value: ", value, " variableName:", variableName, " trueTaskID:", trueTaskID, " falseTaskID:", falseTaskID, " taskID:", taskID);
		end
		local taskInfo = Wardrobe.WaitingListVirtualNames[taskID];
		if (variableName) then
			Wardrobe_Config[variableName] = taskInfo.toggle;
		end
		if (Wardrobe.IsPlayerInCombat()) or (taskInfo.exception and taskInfo.exception()) then
			if (not taskInfo.toggle) then
				-- Remove any toggle on that haven't happened yet
				Wardrobe.RemoveFromWaitingList(taskInfo.id)
			end
			if (taskInfo.id ~= "plague") then
				Wardrobe.AddToWaitingList(taskID);
			end
		else
			local eventID = taskInfo.id;
			Wardrobe.WearSpecialOutfit(eventID, Wardrobe.SpecialOutfitVirtualNames[eventID], taskInfo.toggle);
			if (variableName) then
				return true;
			end
		end
	end

end

---------------------------------------------------------------------------------
-- Waiting Task List Functions
---------------------------------------------------------------------------------

function Wardrobe.AddToWaitingList(theTask)
	Wardrobe.Debug("Adding "..theTask.." to waiting list!");
	tinsert(Wardrobe.WaitingList, 1, theTask);
end

function Wardrobe.RemoveFromWaitingList(theTask)
	Wardrobe.Debug("Removing "..theTask.." from waiting list!");
	for i, task in pairs(Wardrobe.WaitingList) do
		if (task == theTask) then
			tremove(Wardrobe.WaitingList, i);
			return;
		end
	end
end


function Wardrobe.CheckWaitingList()
--	Wardrobe.Debug("Checking Wardrobe.WaitingList: "..asText(Wardrobe.WaitingList));
	if (WardrobeAce.db.char.AutoSwap) then
		local index = 1;
		local swapping;
		for i = 1, #(Wardrobe.WaitingList) do
			local theTask = Wardrobe.WaitingList[index];
			local found;
			for taskName, taskInfo in pairs(Wardrobe.WaitingListVirtualNames) do
				if (theTask == taskName) then
					if (not taskInfo.exception) or (not taskInfo.exception()) then
						Wardrobe.Debug("Putting on ".. taskName.." from virtual outfits.");
						Wardrobe.WearSpecialOutfit(taskInfo.id, Wardrobe.SpecialOutfitVirtualNames[taskInfo.id], taskInfo.toggle);
						tremove(Wardrobe.WaitingList, index);
						Wardrobe.Debug("Popped "..theTask.." from waiting list!");
						swapping = true;
					else
						index = index + 1;
					end
					found = true;
					break;
				end
			end
			if (not found) then
				tremove(Wardrobe.WaitingList, index);
			end
		end
		return swapping;
	end
end


---------------------------------------------------------------------------------
-- Store what we're currently wearing in a virtual outfit
---------------------------------------------------------------------------------
function Wardrobe.StoreVirtualOutfit(virtualOutfitName, currentOutfitName, inheritOutfitName)

	local currentOutfitNum;
	if (type(currentOutfitName) == "number") then
		currentOutfitNum = currentOutfitName;
	else
		currentOutfitNum = Wardrobe.GetOutfitNum(currentOutfitName);
	end

	Wardrobe.ItemCheckState = { };
	local outfit = Wardrobe.CurrentConfig.Outfit[currentOutfitNum];
	for i = 1, Wardrobe.InventorySlotsSize do
		local item = outfit.Item[i];
		if (item) and (item.IsSlotUsed == 1) then
			Wardrobe.ItemCheckState[i] = 1;
		end
	end

	local newOutfitNum = Wardrobe.GetNextFreeVirtualOutfitSlot(virtualOutfitName);

	-- this new outfit will remember what we're about to remove in order to wear our special outfit
	Wardrobe.StoreItemsInOutfit(virtualOutfitName, newOutfitNum, nil, true);

	if (inheritOutfitName) then
		local inheritOutfitNum
		if (type(inheritOutfitName) == "number") then
			inheritOutfitNum = inheritOutfitName;
		else
			inheritOutfitNum = Wardrobe.GetVirtualOutfitNum(inheritOutfitName);
		end
		outfit = Wardrobe.CurrentConfig.VirtualOutfit[newOutfitNum];
		local inheritOutfit = Wardrobe.CurrentConfig.VirtualOutfit[inheritOutfitNum]
		for i, item in pairs(outfit.Item) do
			local inheritItem = inheritOutfit.Item[i];
			if (item.IsSlotUsed == 1) and (inheritItem) and (inheritItem.IsSlotUsed == 1) then
				outfit.Item[i] = inheritItem;
			end
		end
	end
end


---------------------------------------------------------------------------------
-- If we have a virtual outfit, wear it and delete it
---------------------------------------------------------------------------------
function Wardrobe.CheckForEquipVirtualOutfit(virtualOutfitName)

	if (not virtualOutfitName) then
		virtualOutfitName = WARDROBE_TEMP_OUTFIT_NAME;
	end

	if (Wardrobe.FoundVirtualOutfitName(virtualOutfitName)) then
		Wardrobe.WearOutfit(virtualOutfitName, true, true);
		Wardrobe.EraseOutfit(virtualOutfitName, true, true, true);
	end
end


---------------------------------------------------------------------------------
-- Update whether we have all the items for our outfits in our bags
---------------------------------------------------------------------------------
function Wardrobe.GetOutfitsWithItem(checkItemString)
	local outfits = {};
	outfits[1] = "None";
--	Wardrobe.Debug("Wardrobe: Looking for:", checkItemString);

	Wardrobe.CheckForOurWardrobeID();

	local cnt = 1;

	-- for each outfit
	for i, outfit in ipairs(Wardrobe.CurrentConfig.Outfit) do

--		Wardrobe.Debug("Wardrobe: Inspecting", outfit.OutfitName);

--		if (outfit.OutfitName == "") then
--			outfit.OutfitName = nil;
--		end

		-- if it has a name
		if (outfit.OutfitName or outfit.OutfitName ~= "") then
			-- for each item in the outfit
			for j, item in pairs(outfit.Item) do
--				Wardrobe.Debug("Wardrobe: comparing",checkItem," with ",item.Name);
				if(item.ItemString == checkItemString) then

--					Wardrobe.Debug("Wardrobe:",outfit.OutfitName," uses",checkItemString);
					outfits[cnt] = outfit.OutfitName;
					cnt = cnt+1;
--[[					if(outfits == "None") then
						outfits = outfit.OutfitName;
					else
						outfits = outfits..", "..outfit.OutfitName;
					end
]]--
				end
			end
		end
	end
	return outfits;
end

---------------------------------------------------------------------------------
-- Update whether we have all the items for our outfits in our bags
---------------------------------------------------------------------------------
function Wardrobe.UpdateOutfitAvailability()

	if (Wardrobe_Config.Enabled and not Wardrobe.InCombat) then

		-- if we haven't already looked up our character's number
		Wardrobe.CheckForOurWardrobeID();

		Wardrobe.Debug("Wardrobe Availability:");

		-- verify the cache of items first
--		WearMe.VerifyCache();

		-- for each outfit
		for i, outfit in ipairs(Wardrobe.CurrentConfig.Outfit) do

			if (outfit.OutfitName == "") then
				outfit.OutfitName = nil;
			end
			-- if it has a name
			if (outfit.OutfitName) then

				local foundAllItems = true;

				-- for each item in the outfit
				for j, item in pairs(outfit.Item) do

					-- if this slot is used in this outfit
					if (item) and (item.IsSlotUsed == 1) then

						if (item.Name == "") then
							item.Name = nil;
						end
						if (item.ItemString) then
							if (not WearMe.PlayerHasItem(item.ItemString, item.Name)) then
								foundAllItems = false;
							end
						elseif (item.Name) then
							-- Exception for old outfits, just use name
							if (not WearMe.PlayerHasItem(nil, item.Name)) then
								foundAllItems = false;
							end
						end

--						Wardrobe.Debug("  Checking for ", item.ItemString, item.Name, " RETURNED: ",foundAllItems);


					end
				end

				-- if we found all items in our inventory
				outfit.Available = foundAllItems;
				Wardrobe.Debug("   Outfit \"".. outfit.OutfitName.."\" -- found all items = "..tostring(founsdAllItems));
			end
		end
	end
end


---------------------------------------------------------------------------------
-- Determine which outfit we're currently wearing
---------------------------------------------------------------------------------
function Wardrobe.DetermineActiveOutfit()

	Wardrobe.Debug("Wardrobe.DetermineActiveOutfit: Updating Active Outfit");
	local ActiveOutfitList = { };
	local foundOutfit = false;

	local _, itemString, itemID, itemName;
	-- for each outfit
	for i, outfit in ipairs(Wardrobe.CurrentConfig.Outfit) do
		if (outfit.OutfitName) then
			Wardrobe.Debug("Wardrobe.DetermineActiveOutfit: Working on outfit "..i..": "..outfit.OutfitName);

			foundOutfit = true;

			-- for each slot on our character (hands, neck, head, feet, etc)
			for j = 1, Wardrobe.InventorySlotsSize do
				local item = outfit.Item[j];
				
				-- if this slot is used in this outfit
				if (item ~= nil and item.IsSlotUsed == 1) then
					local itemString, itemID, _, _, _, itemName, _ = WearMe.GetInventoryItemInfo(Wardrobe.InventorySlotIDs[j]);
					-- if this item is different from what we're already wearing
					Wardrobe.Debug("Wardrobe.DetermineActiveOutfit: Working on slot ->", Wardrobe.InventorySlots[j], itemString, itemID, itemName);
					-- item in inv slot
					Wardrobe.Debug("Wardrobe.DetermineActiveOutfit: Comparing to ->", item.ItemString, item.ItemID, item.Name);
					if (item.ItemString ~= nil) then
						if (itemString) then
							if (item.ItemString ~= itemString) then
								foundOutfit = false;
								break;
							elseif (item.Name ~= itemName) then
								foundOutfit = false;
								break;
							end

						else
							-- no item in inv slot
							foundOutfit = false;
							break;
						end
					else
						-- Exception for old outfits or outfits copied from server
						if (item.ItemID ~= itemID) then
							foundOutfit = false;
							break;
						elseif (item.Name ~= nil and item.Name ~= itemName) then
							foundOutfit = false;
							break;
						end
					end
				end
			end

			Wardrobe.Debug("Wardrobe.DetermineActiveOutfit() FOUND OUTFIT=",foundOutfit);

			if (foundOutfit) then
				tinsert(ActiveOutfitList, i);
			end
		end
	end

	return ActiveOutfitList;
end


function Wardrobe.GetActiveOutfitsTextList(max_len)
	local activeOutfitList = Wardrobe.DetermineActiveOutfit();
	local outfitText = "";
	local outfits = Wardrobe.CurrentConfig.Outfit;
	for i, outfitID in pairs(activeOutfitList) do
		-- don't match special outfits
		local buttonColorTable = WARDROBE_TEXTCOLORS[outfits[outfitID].ButtonColor];
		local name = outfits[outfitID].OutfitName;
		if (strsub(name, 1, 1) ~= "#") then
			outfitText = outfitText..", |c"..Wardrobe.colorToString(buttonColorTable)..name.."|r";

			if(max_len and string.len(outfitText)>(max_len + (string.len(Wardrobe.colorToString(buttonColorTable))+6)*i)) then
				outfitText = outfitText.."...";
				break;
			end
		end
	end
	if (outfitText == "") then
		return TEXT("TXT_NO_OUTFIT");
	else
		return strsub(outfitText, 3);
	end
end

function Wardrobe.GetListOfOutfits()
	Wardrobe.CheckForOurWardrobeID();
	Wardrobe.UpdateOutfitAvailability();
	local activeOutfits = Wardrobe.DetermineActiveOutfit();
	Wardrobe.ActiveOutfitList = activeOutfits;
	local outfitTable = {};
	for i, outfit in ipairs(Wardrobe.CurrentConfig.Outfit) do
		local outfitData = {};
		local nameString = outfit.OutfitName;
		local icon = outfit.Icon;
		if (strsub(nameString, 1, 1) ~= "#") then
			if ( Wardrobe.isInList(activeOutfits, i) ) then
				nameString = "|c"..Wardrobe.colorToString(WARDROBE_TEXTCOLORS[outfit.ButtonColor])..nameString.."|r";
			elseif ( outfit.Available ) then
				nameString = "|c"..Wardrobe.colorToString(WARDROBE_DRABCOLORS[outfit.ButtonColor])..nameString.."|r";
			else
				nameString = "|c"..Wardrobe.colorToString(WARDROBE_UNAVAILIBLECOLOR)..nameString.."|r";
			end
			
			outfitData.OutfitName = nameString;
			outfitData.Icon = icon;
			
			tinsert(outfitTable, outfitData);
		end
	end
	return outfitTable;
end

--============================================================================================--
--============================================================================================--
--																							--
--							  UTILITY FUNCTIONS											 --
--																							--
--============================================================================================--
--============================================================================================--


-----------------------------------------------------------------------------------
-- for in-line coloring (from Sea)
-----------------------------------------------------------------------------------
function Wardrobe.colorToString( color )
	if ( not color ) then
		return "FFFFFFFF";
	end
	return format( "%.2X%.2X%.2X%.2X", 255, color[1]*255, color[2]*255, color[3]*255 );
end

-----------------------------------------------------------------------------------
-- value comparison, returns key/index
-----------------------------------------------------------------------------------
function Wardrobe.isInList( list, value )
	if ( not list or not value ) then
		return;
	end
	for k, v in pairs(list) do
		if (v == value) then
			return k;
		end
	end
end

-----------------------------------------------------------------------------------
-- Our own print function
-----------------------------------------------------------------------------------
function Wardrobe.Print(msg, r, g, b)

	-- 0.50, 0.50, 1.00
	if (not r) then r = 0.50; end
	if (not g) then g = 0.50; end
	if (not b) then b = 1.00; end

	if (type(msg) == "table") then
		msg = Wardrobe.asText(msg);
	end

	if ( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b);
	else
		ChatFrame1:AddMessage(msg, r, g, b);
	end
end


-----------------------------------------------------------------------------------
-- Nifty little function to view any lua object as text
-----------------------------------------------------------------------------------
function Wardrobe.asText(obj)

	visitRef = {}
	visitRef.n = 0

	asTxRecur = function(obj, asIndex)
		if type(obj) == "table" then
			if visitRef[obj] then
				return "@"..visitRef[obj]
			end
			visitRef.n = visitRef.n +1
			visitRef[obj] = visitRef.n

			local begBrac, endBrac
			if asIndex then
				begBrac, endBrac = "[{", "}]"
			else
				begBrac, endBrac = "{", "}"
			end
			local t = begBrac
			local k, v = nil, nil
			repeat
				k, v = next(obj, k)
				if k ~= nil then
					if t > begBrac then
						t = t..", "
					end
					t = t..asTxRecur(k, 1).."="..asTxRecur(v)
				end
			until k == nil
			return t..endBrac
		else
			if asIndex then
				-- we're on the left side of an "="
				if type(obj) == "string" then
					return obj
				else
					return "["..obj.."]"
				end
			else
				-- we're on the right side of an "="
				if type(obj) == "string" then
					return '"'..obj..'"'
				else
					return tostring(obj)
				end
			end
		end
	end -- asTxRecur

	return asTxRecur(obj)
end -- asText


---------------------------------------------------------------------------------
-- Display the help text
---------------------------------------------------------------------------------
function Wardrobe.ShowHelp()
	Wardrobe.Print(TEXT("HELP_1")..WARDROBE_VERSION);
	Wardrobe.Print(TEXT("HELP_2"));
	Wardrobe.Print(TEXT("HELP_3"));
	Wardrobe.Print(TEXT("HELP_4"));
	Wardrobe.Print(TEXT("HELP_5"));
	Wardrobe.Print(TEXT("HELP_6"));
	Wardrobe.Print(TEXT("HELP_7"));
	Wardrobe.Print(TEXT("HELP_8"));
	Wardrobe.Print(TEXT("HELP_9"));
	Wardrobe.Print(TEXT("HELP_10"));
	Wardrobe.Print(TEXT("HELP_11"));
	Wardrobe.Print(TEXT("HELP_12"));
	Wardrobe.Print(TEXT("HELP_13"));
	Wardrobe.Print(TEXT("HELP_14"));
	Wardrobe.Print(TEXT("HELP_15"));
	Wardrobe.Print(TEXT("HELP_16"));
end



--============================================================================================--
--============================================================================================--
--																							--
--							  DEBUG FUNCTIONS											   --
--																							--
--============================================================================================--
--============================================================================================--


-----------------------------------------------------------------------------------
-- Print out a debug statement if the Wardrobe.DEBUG_MODE flag is set
-----------------------------------------------------------------------------------
function Wardrobe.Debug(...)
	if (Wardrobe.DEBUG_MODE) then
--Private print does not need to concatenate strings, simply use commas to seperate arguments. Also handles printing functions, nils, and tables without throwing errors
--private.Print = function(...)
		local output, part
		for i=1, select("#", ...) do
			part = select(i, ...)
			part = tostring(part):gsub("{{", "|cffddeeff"):gsub("}}", "|r")
			if (output) then output = output .. " " .. part
			else output = part end
		end
		ChatFrame1:AddMessage(output, 1.0, 1.0, 0.7);
	end
end


---------------------------------------------------------------------------------
-- Toggle debug output
---------------------------------------------------------------------------------
function Wardrobe.ToggleDebug()
	Wardrobe.DEBUG_MODE = not Wardrobe.DEBUG_MODE;
	WearMe.DEBUG = Wardrobe.DEBUG_MODE;
	if (Wardrobe.DEBUG_MODE) then
		Wardrobe.Print("Wardrobe: Debug ON",1.0,1.0,0.5);
	else
		Wardrobe.Print("Wardrobe: Debug OFF",1.0,1.0,0.5);
	end
end


---------------------------------------------------------------------------------
-- Debug routine to print the current state of the plugin
---------------------------------------------------------------------------------
function Wardrobe.DumpDebugReport()

	Wardrobe.CheckForOurWardrobeID();

	Wardrobe.Debug("Wardrobe.DumpDebugReport: Character's wardrobe database");
	for outfitNum, outfit in ipairs(Wardrobe.CurrentConfig.Outfit) do
		Wardrobe.Debug("Outfit: "..tostring(outfit.OutfitName));
		for i, item in pairs(outfit.Item) do
			if (item) then
				Wardrobe.Debug(Wardrobe.InventorySlots[i].." = "..tostring(item.Name));
			end
		end
	end
end



---------------------------------------------------------------------------------
-- Print a debug report
---------------------------------------------------------------------------------
function Wardrobe.DumpDebugStruct()
	for i = 1, #(Wardrobe.CurrentConfig.Outfit) do
		Print("Outfit #"..i..":");
		Print(Wardrobe.asText(Wardrobe.CurrentConfig.Outfit[i]));
		Print("--------------------");
	end
end


