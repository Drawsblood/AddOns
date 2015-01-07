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
local unpack        = _G.unpack;
local select        = _G.select;
local assert        = _G.assert;
local type          = _G.type;
local error         = _G.error;
local pcall         = _G.pcall;
local print         = _G.print;
local ipairs        = _G.ipairs;
local pairs         = _G.pairs;
local next          = _G.next;
local rawset        = _G.rawset;
local rawget        = _G.rawget;
local tostring      = _G.tostring;
local tonumber      = _G.tonumber;
local getmetatable  = _G.getmetatable;
local setmetatable  = _G.setmetatable;
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

local _, ns = ...;
local tempFilterTable = {};
local watchedBuffs = {}

local privateFilters = {
	["CC"] = "Crowd Control Auras",
	["Defense"] = "Defensive Auras",
	["Custom"] = "Custom Filtering",
}

local publicFilters = {
	["Player"] = "Player Only Auras",
	["BlackList"] = "BlackList Auras",
	["Allowed"] = "Allowed Auras",
	["Raid"] = "Raid Debuffs",
	["AuraBars"] = "AuraBar Auras",
	["BuffWatch"] = "(AuraWatch) Player Buffs",
	["PetBuffWatch"] = "(AuraWatch) Pet Buffs",
}

local NONE = _G.NONE;
local GetSpellInfo = _G.GetSpellInfo;
local collectgarbage = _G.collectgarbage;

local function generateFilterOptions(filterType, selectedSpell)

	local FILTER
	if(SV.filters.Custom[filterType]) then 
		FILTER = SV.filters.Custom[filterType] 
	else
		FILTER = SV.filters[filterType]
	end

	if((not filterType) or (filterType == "") or (not FILTER)) then
		SV.Options.args.filters.args.filterGroup = nil;
		SV.Options.args.filters.args.spellGroup = nil;
		return 
	end

	local PROTECTED = publicFilters[filterType];
	
	if(filterType == 'AuraBars') then 

		SV.Options.args.filters.args.filterGroup = {
			type = "group",
			name = filterType,
			guiInline = true,
			order = 10,
			args = {
				addSpell = {
					order = 1,
					name = L["Add Spell"],
					desc = L["Add a spell to the filter."],
					type = "input",
					guiInline = true,
					get = function(e)return""end,
					set = function(e, arg)
						if not SV.db.media.unitframes.spellcolor[arg] then 
							SV.db.media.unitframes.spellcolor[arg] = false 
						end 
						MOD:SetUnitFrame("player")
						MOD:SetUnitFrame("target")
						MOD:SetUnitFrame("focus")
						generateFilterOptions(filterType, arg)
					end
				},
				removeSpell = {
					order = 2,
					name = L["Remove Spell"],
					desc = L["Remove a spell from the filter."],
					type = "input",
					guiInline = true,
					get = function(e)return""end,
					set = function(e, arg)
						if SV.db.media.unitframes.spellcolor[arg]then 
							SV.db.media.unitframes.spellcolor[arg] = false;
							SV:AddonMessage(L["You may not remove a spell from a default filter that is not customly added. Setting spell to false instead."])
						else 
							SV.db.media.unitframes.spellcolor[arg] = nil 
						end
						MOD:SetUnitFrame("player")
						MOD:SetUnitFrame("target")
						MOD:SetUnitFrame("focus")
						generateFilterOptions(filterType)
					end
				},
				selectSpell = {
					name = L["Select Spell"],
					type = "select",
					order = 3,
					guiInline = true,
					get = function(e) return selectedSpell end,
					set = function(e, arg)
						generateFilterOptions(filterType, arg)
					end,
					values = function()
						wipe(tempFilterTable)
						tempFilterTable[""] = NONE;
						for g in pairs(SV.db.media.unitframes.spellcolor)do 
							tempFilterTable[g] = g 
						end 
						return tempFilterTable 
					end
				}
			}
		}

		if not selectedSpell or SV.db.media.unitframes.spellcolor[selectedSpell] == nil then 
			SV.Options.args.filters.args.spellGroup = nil; 
			return 
		end 

		SV.Options.args.filters.args.spellGroup = {
			type = "group",
			name = selectedSpell,
			order = 15,
			guiInline = true,
			args = {
				color = {
					name = L["Color"],
					type = "color",
					order = 1,
					get = function(e)
						local abColor = SV.db.media.unitframes.spellcolor[selectedSpell]
						if type(abColor) == "boolean"then 
							return 0, 0, 0, 1 
						else 
							return abColor[1], abColor[2], abColor[3], abColor[4] 
						end 
					end,
					set = function(e, r, g, b)
						if type(SV.db.media.unitframes.spellcolor[selectedSpell]) ~= "table"then 
							SV.db.media.unitframes.spellcolor[selectedSpell] = {}
						end 
						local abColor = {r, g, b}
						SV.db.media.unitframes.spellcolor[selectedSpell] = abColor
						MOD:SetUnitFrame("player")
						MOD:SetUnitFrame("target")
						MOD:SetUnitFrame("focus")
					end
				},
				removeColor = {
					type = "execute",
					order = 2,
					name = L["Restore Defaults"],
					func = function(e, arg)
						SV.db.media.unitframes.spellcolor[selectedSpell] = false;
						MOD:SetUnitFrame("player")
						MOD:SetUnitFrame("target")
						MOD:SetUnitFrame("focus")
					end
				}
			}
		}

	elseif(filterType == 'PetBuffWatch') then

		wipe(watchedBuffs)

		if not SV.filters.PetBuffWatch then 
			SV.filters.PetBuffWatch = {}
		end

		for o,f in pairs(SV.filters.PetBuffWatch)do 
			tinsert(watchedBuffs,f)
		end 

		SV.Options.args.filters.args.filterGroup = {
			type = "group", 
			name = filterType, 
			guiInline = true, 
			order = -10, 
			childGroups = "tab", 
			args = {
				addSpellID = {
					order = 1, 
					name = L["Add SpellID"], 
					desc = L["Add a spell to the filter."], 
					type = "input", 
					get = function(e)return""end, 
					set = function(e, arg)
						if not tonumber(arg) then 
							SV:AddonMessage(L["Value must be a number"])
						elseif not GetSpellInfo(arg)then 
							SV:AddonMessage(L["Not valid spell id"])
						else 
							tinsert(SV.filters.PetBuffWatch, {["enable"] = true, ["id"] = tonumber(arg), ["point"] = "TOPRIGHT", ["color"] = {["r"] = 1, ["g"] = 0, ["b"] = 0}, ["anyUnit"] = true})
							MOD:SetUnitFrame("pet")
							generateFilterOptions(filterType, selectedSpell)
						end 
					end
				}, 
				removeSpellID = {
					order = 2, 
					name = L["Remove SpellID"], 
					desc = L["Remove a spell from the filter."], 
					type = "input", 
					get = function(e)return""end, 
					set = function(e, arg)
						if not tonumber(arg)then 
							SV:AddonMessage(L["Value must be a number"])
						elseif not GetSpellInfo(arg)then 
							SV:AddonMessage(L["Not valid spell id"])
						else 
							local p;
							for q, r in pairs(SV.filters.PetBuffWatch)do 
								if r["id"] == tonumber(arg)then 
									p = r;
									if SV.filters.PetBuffWatch[q]then 
										SV.filters.PetBuffWatch[q].enable = false;
									else 
										SV.filters.PetBuffWatch[q] = nil 
									end 
								end 
							end 
							if p == nil then 
								SV:AddonMessage(L["Spell not found in list."])
							else 
								generateFilterOptions()
							end 
						end 
						MOD:SetUnitFrame("pet")
						generateFilterOptions(filterType, selectedSpell)
					end
				}, 
				selectSpell = {
					name = L["Select Spell"], 
					type = "select", 
					order = 3, 
					values = function()
						local v = {}
						wipe(watchedBuffs)
						for o, f in pairs(SV.filters.PetBuffWatch)do 
							tinsert(watchedBuffs, f)
						end 
						for o, l in pairs(watchedBuffs)do 
							if l.id then 
								local name = GetSpellInfo(l.id)
								v[l.id] = name 
							end 
						end 
						return v 
					end, 
					get = function(e)return selectedSpell end, 
					set = function(e, arg) generateFilterOptions(filterType, selectedSpell) end
				}
			}
		}

		local registeredSpell;

		for t,l in pairs(SV.filters.PetBuffWatch)do 
			if l.id == selectedSpell then 
				registeredSpell = t 
			end 
		end 

		if selectedSpell and registeredSpell then 
			local currentSpell = GetSpellInfo(selectedSpell)
			SV.Options.args.filters.args.filterGroup.args[currentSpell] = {
				name = currentSpell.." ("..selectedSpell..")", 
				type = "group", 
				get = function(e)return SV.filters.PetBuffWatch[registeredSpell][e[#e]] end, 
				set = function(e, arg)
					SV.filters.PetBuffWatch[registeredSpell][e[#e]] = arg;
					MOD:SetUnitFrame("pet")
				end, 
				order = -10, 
				args = {
					enable = {
						name = L["Enable"], 
						order = 0, 
						type = "toggle"
					}, 
					point = {
						name = L["Anchor Point"], 
						order = 1, 
						type = "select", 
						values = {
							["TOPLEFT"] = "TOPLEFT", 
							["TOPRIGHT"] = "TOPRIGHT", 
							["BOTTOMLEFT"] = "BOTTOMLEFT", 
							["BOTTOMRIGHT"] = "BOTTOMRIGHT", 
							["LEFT"] = "LEFT", 
							["RIGHT"] = "RIGHT", 
							["TOP"] = "TOP", 
							["BOTTOM"] = "BOTTOM"
						}
					}, 
					xOffset = {order = 2, type = "range", name = L["xOffset"], min = -75, max = 75, step = 1}, 
					yOffset = {order = 2, type = "range", name = L["yOffset"], min = -75, max = 75, step = 1}, 
					style = {
						name = L["Style"], 
						order = 3, 
						type = "select", 
						values = {["coloredIcon"] = L["Colored Icon"], ["texturedIcon"] = L["Textured Icon"], [""] = NONE}
					}, 
					color = {
						name = L["Color"], 
						type = "color", 
						order = 4, 
						get = function(e)
							local abColor = SV.filters.PetBuffWatch[registeredSpell][e[#e]]
							return abColor.r,  abColor.g,  abColor.b,  abColor.a 
						end, 
						set = function(e, i, j, k)
							local abColor = SV.filters.PetBuffWatch[registeredSpell][e[#e]]
							abColor.r,  abColor.g,  abColor.b = i, j, k;
							MOD:SetUnitFrame("pet")
						end
					}, 
					displayText = {
						name = L["Display Text"],
						type = "toggle",
						order = 5
					},
					textColor = {
						name = L["Text Color"],
						type = "color",
						order = 6,
						get = function(e)
							local abColor = SV.filters.PetBuffWatch[registeredSpell][e[#e]]
							if abColor then 
								return abColor.r,abColor.g,abColor.b,abColor.a 
							else 
								return 1,1,1,1 
							end 
						end,
						set = function(e,i,j,k)
							local abColor = SV.filters.PetBuffWatch[registeredSpell][e[#e]]
							abColor.r,abColor.g,abColor.b = i,j,k;
							MOD:SetUnitFrame("pet")
						end
					},
					textThreshold = {
						name = L["Text Threshold"],
						desc = L["At what point should the text be displayed. Set to -1 to disable."],
						type = "range",
						order = 6,
						min = -1,
						max = 60,
						step = 1
					},
					anyUnit = {
						name = L["Show Aura From Other Players"],
						order = 7,
						type = "toggle"
					},
					onlyShowMissing = {
						name = L["Show When Not Active"],
						order = 8,
						type = "toggle",
						disabled = function()return SV.filters.PetBuffWatch[registeredSpell].style == "text"end
					}
				}
			}
		end 

	elseif(filterType == 'BuffWatch') then

		if not SV.filters.BuffWatch then 
			SV.filters.BuffWatch = {}
		end 
		for o,f in pairs(SV.filters.BuffWatch) do 
			tinsert(watchedBuffs,f)
		end 

		SV.Options.args.filters.args.filterGroup = {
			type = "group", 
			name = filterType, 
			guiInline = true, 
			order = -10, 
			childGroups = "tab", 
			args = {
				addSpellID = {
					order = 1, 
					name = L["Add SpellID"], 
					desc = L["Add a spell to the filter."], 
					type = "input", 
					get = function(e)return""end, 
					set = function(e, arg)
						if(not tonumber(arg)) then 
							SV:AddonMessage(L["Value must be a number"])
						elseif(not GetSpellInfo(arg)) then 
							SV:AddonMessage(L["Not valid spell id"])
						else 
							tinsert(SV.filters.BuffWatch, {["enable"] = true, ["id"] = tonumber(arg), ["point"] = "TOPRIGHT", ["color"] = {["r"] = 1, ["g"] = 0, ["b"] = 0}, ["anyUnit"] = false})
							for t = 10, 40, 15 do 
								MOD:UpdateGroupAuraWatch("raid"..t)
							end 
							MOD:UpdateGroupAuraWatch("party")
							MOD:UpdateGroupAuraWatch("raidpet", true)
							generateFilterOptions(filterType)
						end 
					end
				}, 
				removeSpellID = {
					order = 2, 
					name = L["Remove SpellID"], 
					desc = L["Remove a spell from the filter."], 
					type = "input", 
					get = function(e)return""end, 
					set = function(e, arg)
						if not tonumber(arg)then 
							SV:AddonMessage(L["Value must be a number"])
						elseif not GetSpellInfo(arg)then 
							SV:AddonMessage(L["Not valid spell id"])
						else 
							local p;
							for q, r in pairs(SV.filters.BuffWatch)do 
								if r["id"] == tonumber(arg)then 
									p = r;
									if SV.filters.BuffWatch[q]then 
										SV.filters.BuffWatch[q].enable = false;
									else 
										SV.filters.BuffWatch[q] = nil 
									end 
								end 
							end 
							if p == nil then 
								SV:AddonMessage(L["Spell not found in list."])
							else 
								generateFilterOptions()
							end 
						end
						for t = 10, 40, 15 do 
							MOD:UpdateGroupAuraWatch("raid"..t)
						end 
						MOD:UpdateGroupAuraWatch("party")
						MOD:UpdateGroupAuraWatch("raidpet", true)
						generateFilterOptions(filterType)
					end
				}, 
				selectSpell = {
					name = L["Select Spell"], 
					type = "select", 
					order = 3, 
					values = function()
						local v = {}
						wipe(watchedBuffs)
						for o, f in pairs(SV.filters.BuffWatch)do 
							tinsert(watchedBuffs, f)
						end 
						for o, l in pairs(watchedBuffs)do 
							if l.id then 
								local name = GetSpellInfo(l.id)
								v[l.id] = name 
							end 
						end 
						return v 
					end, 
					get = function(e) return selectedSpell end, 
					set = function(e, arg) generateFilterOptions(filterType, selectedSpell) end
				}
			}
		}

		local registeredSpell;

		for t,l in pairs(SV.filters.BuffWatch)do if l.id==selectedSpell then registeredSpell=t end end 

		if selectedSpell and registeredSpell then 
			local currentSpell=GetSpellInfo(selectedSpell)
			SV.Options.args.filters.args.filterGroup.args[currentSpell] = {
				name = currentSpell.." ("..selectedSpell..")", 
				type = "group", 
				get = function(e)return SV.filters.BuffWatch[registeredSpell][e[#e]]end, 
				set = function(e, arg)
					SV.filters.BuffWatch[registeredSpell][e[#e]] = arg;
					for t = 10, 40, 15 do 
						MOD:UpdateGroupAuraWatch("raid"..t)
					end 
					MOD:UpdateGroupAuraWatch("party")
					MOD:UpdateGroupAuraWatch("raidpet", true)
				end, 
				order = -10, 
				args = {
					enable = {name = L["Enable"], order = 0, type = "toggle"}, 
					point = {
						name = L["Anchor Point"], 
						order = 1, 
						type = "select", 
						values = {
							["TOPLEFT"] = "TOPLEFT", 
							["TOPRIGHT"] = "TOPRIGHT", 
							["BOTTOMLEFT"] = "BOTTOMLEFT", 
							["BOTTOMRIGHT"] = "BOTTOMRIGHT", 
							["LEFT"] = "LEFT", 
							["RIGHT"] = "RIGHT", 
							["TOP"] = "TOP", 
							["BOTTOM"] = "BOTTOM"
						}
					}, 
					xOffset = {order = 2, type = "range", name = L["xOffset"], min = -75, max = 75, step = 1}, 
					yOffset = {order = 2, type = "range", name = L["yOffset"], min = -75, max = 75, step = 1}, 
					style = {name = L["Style"], order = 3, type = "select", values = {["coloredIcon"] = L["Colored Icon"], ["texturedIcon"] = L["Textured Icon"], [""] = NONE}}, 
					color = {
						name = L["Color"], 
						type = "color", 
						order = 4, 
						get = function(e)
							local abColor = SV.filters.BuffWatch[registeredSpell][e[#e]]
							return abColor.r,  abColor.g,  abColor.b,  abColor.a 
						end, 
						set = function(e, i, j, k)
							local abColor = SV.filters.BuffWatch[registeredSpell][e[#e]]
							abColor.r,  abColor.g,  abColor.b = i, j, k;
							for t = 10, 40, 15 do 
								MOD:UpdateGroupAuraWatch("raid"..t)
							end 
							MOD:UpdateGroupAuraWatch("party")
							MOD:UpdateGroupAuraWatch("raidpet", true)
						end
					}, 
					displayText = {
						name = L["Display Text"], 
						type = "toggle", 
						order = 5
					}, 
					textColor = {
						name = L["Text Color"], 
						type = "color", 
						order = 6, 
						get = function(e)
							local abColor = SV.filters.BuffWatch[registeredSpell][e[#e]]
							if abColor then 
								return abColor.r,  abColor.g,  abColor.b,  abColor.a 
							else 
								return 1, 1, 1, 1 
							end 
						end, 
						set = function(e, i, j, k)
							SV.filters.BuffWatch[registeredSpell][e[#e]] = SV.filters.BuffWatch[registeredSpell][e[#e]] or {}
							local abColor = SV.filters.BuffWatch[registeredSpell][e[#e]]
							abColor.r,  abColor.g,  abColor.b = i, j, k;
							for t = 10, 40, 15 do 
								MOD:UpdateGroupAuraWatch("raid"..t)
							end 
							MOD:UpdateGroupAuraWatch("party")
							MOD:UpdateGroupAuraWatch("raidpet", true)
						end
					}, 
					textThreshold = {
						name = L["Text Threshold"], 
						desc = L["At what point should the text be displayed. Set to -1 to disable."], 
						type = "range", 
						order = 6, 
						min = -1, 
						max = 60, 
						step = 1
					}, 
					anyUnit = {
						name = L["Show Aura From Other Players"], 
						order = 7, 
						type = "toggle"
					}, 
					onlyShowMissing = {
						name = L["Show When Not Active"], 
						order = 8, 
						type = "toggle", 
						disabled = function()return SV.filters.BuffWatch[registeredSpell].style == "text" end
					}
				}
			}
		end

		wipe(watchedBuffs)
	
	else  
		
		SV.Options.args.filters.args.filterGroup = {
			type = "group",
			name = filterType,
			guiInline = true,
			order = 10,
			args = {
				addSpell = {
					order = 1,
					name = L["Add Spell"],
					desc = L["Add a spell to the filter."],
					type = "input",
					get = function(e) return "" end,
					set = function(e, arg)
						if(not FILTER[arg]) then 
							FILTER[arg] = {
								["enable"] = true,
								["priority"] = 0
							}
						end 
						generateFilterOptions(filterType, arg)
						MOD:RefreshUnitFrames()
					end
				},
				removeSpell = {	
					order = 2,
					name = L["Remove Spell"],
					desc = L["Remove a spell from the filter."],
					type = "input",
					get = function(e)return "" end,
					set = function(e, arg)
						if(FILTER[arg]) then
							if(FILTER[arg].isDefault) then
								FILTER[arg].enable = false;
								SV:AddonMessage(L["You may not remove a spell from a default filter that is not customly added. Setting spell to false instead."])
							else 
								FILTER[arg] = nil 
							end
						end
						generateFilterOptions(filterType)
						MOD:RefreshUnitFrames()
					end
				},
				selectSpell = {	
					name = L["Select Spell"],
					type = "select",
					order = 3,
					guiInline = true,
					get = function(e) return selectedSpell end,
					set = function(e, arg) generateFilterOptions(filterType, arg) end,
					values = function()
						wipe(tempFilterTable)
						tempFilterTable[""] = NONE;
						for g in pairs(FILTER)do
							tempFilterTable[g] = g 
						end 
						return tempFilterTable 
					end
				}
			}
		}

		if not selectedSpell or not FILTER[selectedSpell] then 
			SV.Options.args.filters.args.spellGroup = nil;
			return 
		end 

		SV.Options.args.filters.args.spellGroup = {
			type = "group", 
			name = selectedSpell, 
			order = 15, 
			guiInline = true, 
			args = {
				enable = {
					name = L["Enable"], 
					type = "toggle", 
					get = function()
						if not selectedSpell then 
							return false 
						else 
							return FILTER[selectedSpell].enable 
						end 
					end, 
					set = function(e, arg)
						FILTER[selectedSpell].enable = arg;
						generateFilterOptions()
						MOD:RefreshUnitFrames()
					end
				}, 
				priority = {
					name = L["Priority"], 
					type = "range", 
					get = function()
						if not selectedSpell then 
							return 0 
						else 
							return FILTER[selectedSpell].priority 
						end 
					end, 
					set = function(e, arg)
						FILTER[selectedSpell].priority = arg;
						generateFilterOptions()
						MOD:RefreshUnitFrames()
					end, 
					min = 0, 
					max = 99, 
					step = 1, 
					desc = L["Set the priority order of the spell, please note that prioritys are only used for the raid debuff package, not the standard buff/debuff package. If you want to disable set to zero."]
				}
			}
		}
	end

	MOD:RefreshUnitFrames()

	collectgarbage("collect")
end

SV.Options.args.filters = {
	type = "group",
	name = L["Filters"],
	order = -10,
	args = {	
		createFilter = {	
			order = 1,
			name = L["Create Filter"],
			desc = L["Create a custom filter."],
			type = "input",
			get = function(e) return "" end,
			set = function(e, arg)
				SV.filters.Custom[arg] = {}
			end
		},
		deleteFilter = {
			type = "select",
			order = 2,
			name = L["Delete Filter"],
			desc = L["Delete a custom filter."],
			get = function(e) return "" end,
			set = function(e, arg)
				SV.filters.Custom[arg] = nil;
				SV.Options.args.filters.args.filterGroup = nil  
			end,
			values = function()
				wipe(tempFilterTable)
				tempFilterTable[""] = NONE;
				for g in pairs(SV.filters.Custom) do 
					tempFilterTable[g] = g
				end 
				return tempFilterTable 
			end
		},
		selectFilter = {
			order = 3,
			type = "select",
			name = L["Select Filter"],
			get = function(e) return filterType end,
			set = function(e, arg) generateFilterOptions(arg) end,
			values = function()
				wipe(tempFilterTable)
				tempFilterTable[""] = NONE;
				for g in pairs(SV.filters) do
					if(publicFilters[g]) then 
						tempFilterTable[g] = publicFilters[g]
					end
				end
				for g in pairs(SV.filters.Custom) do 
					tempFilterTable[g] = g
				end
				return tempFilterTable 
			end
		}
	}
}


function ns:SetToFilterConfig(newFilter)
	local filter = newFilter or "BuffWatch"
	generateFilterOptions(filter)
	_G.LibStub("AceConfigDialog-3.0"):SelectGroup(SV.NameID, "filters")
end