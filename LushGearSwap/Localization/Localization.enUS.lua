if not LGS_LocalizationLoaded then
	LGS_DAILIES_OPTION = "Dailies: "
	
	LushGearSwap_ZoneSwapLocaitons = {
		["Arenas"] = {
			["Dalaran Arena"] 			= { 1, },
			["Nagrand Arena"] 			= { 1, },
			["The Ring of Valor"] 		= { 1, },
			["Ruins of Lordaeron"]		= { 1, },
			["Blade's Edge Arena"] 		= { 1, },
		},

		["Cities"] = {
			["Stormwind"] 				= { 1, },
			["Ironforge"] 				= { 1, },
			["Dalaran"] 				= { 1, },
			["The Exodar"] 				= { 1, },
			["Darnassus"] 				= { 1, },
			["Shattrath City"] 			= { 1, },
			["Orgrimmar"] 				= { 1, },
			["Thunder Bluff"] 			= { 1, },
			["Undercity"] 				= { 1, },
			["Silvermoon City"] 		= { 1, },
		},

		[LGS_DAILIES_OPTION .. "Argent Tournament"] = {
			["Argent Tournament Grounds"]	= { 1, },
			["The Alliance Valiants' Ring"] = { 1, },
			["The Horde Valiants' Ring"]	= { 1, },
			["The Ring of Champions"]		= { 1, },
			["The Argent Valiants' Ring"]	= { 1, },
			["The Aspirants' Ring"]			= { 1, },
			["The Court of Bones"] 			= { 13852, 13854, 13855, 13857, 13851, 13856, 13858, 13859, 13860, 	-- At The Enemy's Gates
												13863, 13862, 13861, 13864, }, 									-- Battle Before The Citadel
			["Icecrown Citadel"] 			= { 13852, 13854, 13855, 13857, 13851, 13856, 13858, 13859, 13860, 	-- At The Enemy's Gates
												13863, 13862, 13861, 13864, }, 									-- Battle Before The Citadel
		},

		[LGS_DAILIES_OPTION .. "Fishing"] = {
			-- New Fishing Dailys
			["Cantrips & Crows"] 			= { 13832, }, -- Jewel Of The Sewers
			["Wintergrasp"] 				= { 13834, }, -- Dangerously Delicious
			["Borean Tundra"] 				= { 13833, }, -- Blood Is Thicker
			["Death's Stand"] 				= { 13833, }, -- Blood Is Thicker
			["Unu'pe"] 						= { 13833, }, -- Blood Is Thicker
			["Kaskala"] 					= { 13833, }, -- Blood Is Thicker
			["The Frozen Sea"] 				= { 13836, }, -- Monsterbelly Appetite
			["River's Heart"]				= { 13830, }, -- The Ghostfish

			-- 70 Fishing Dailys
			["Terokkar Forest"]				= { 11666, }, 			-- Bait Bandits
			["Pools of Aggonar"]			= { 11669, }, 			-- Felblood Fillet
			["The Lagoon"]					= { 11668, }, 			-- Shrimpin' Ain't Easy
			["Stormwind"]					= { 11665, }, 			-- Crocolisks in the City
			["Skysong Lake"]				= { 11410, 11667, }, 	-- The One That Got Away
		},
	};
	
	LGS_DUALSPEC_OPTION						= "Dual Specialization"
	LGS_PRIMSPEC_OPTION						= "Primary Spec"
	LGS_ALTSPEC_OPTION						= "Alternate Spec"
	LGS_DONTSWAP_OPTION						= "Don't Swap Sets"
	LGS_BANK_OPTION							= "Bank Options"
	LGS_DEPOSITBANK_OPTION					= "Deposit items into bank"
	LGS_DEPOSITBANKUNIQUE_OPTION			= "Deposit unique items into bank"
	LGS_DEPOSITBALLALLOTHER_OPTION			= "Deposit all other sets"
	LGS_WITHDRAWBANK_OPTION					= "Withdraw items from bank"
	LGS_NEVERDEPOSIT_OPTION					= "Never deposit set"
	LGS_GENERAL_OPTION						= "General Options"
	LGS_UPDATECURRENT_OPTION				= "Update to current items"
	LGS_SET_OPTION							= "Set Options"
	
	LGS_SHOWHELM_OPTION						= "Show Helm"
	LGS_HIDEHELM_OPTION						= "Hide Helm"
	
	LGS_SHOWCLOAK_OPTION					= "Show Cloak"
	LGS_HIDECLOAK_OPTION					= "Hide Cloak"
	
	LGS_DONTCHANGE_OPTION					= "Don't Change"
	
	LGS_HELMOPTION_HEADER					= "Helm Options"
	LGS_CLOAKOPTION_HEADER					= "Cloak Options"
	LGS_SWAPONZONE_HEADER					= "Swap on zone change"
	LGS_MINIMAPHELP_HEADER					= "^ Type Minimap / Zone Info ^"
	LGS_NEWZONE_HEADER						= "'Somewhere Else'"
	
	LGS_KEYBINDMODE_BUTTON					= "Keybinds"
	LGS_KEYBINDMODE_HEADER					= "-:Keybinding Mode:-\n\nHover over a gear set button and press a Hotkey;\n\nTo remove a hotkey hover over and press 'Escape'"
	
	LGS_LocalizationLoaded 					= true
end