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
local MOD = SV.SVUnit;
if(not MOD) then return end
local L = SV.L;
local _, ns = ...;
local tempFilterTable = {};
local NONE = _G.NONE;

ns.FilterOptionGroups['AuraBars'] = function(selectedSpell)
	local RESULT = {
		type = "group",
		name = 'AuraBars',
		guiInline = true,
		order = 10,
		args = {
			addSpell = {
				order = 1,
				name = L["Add Spell"],
				desc = L["Add a spell to the filter."],
				type = "input",
				guiInline = true,
				get = function(key) return "" end,
				set = function(key, value)
					if not SV.db.media.unitframes.spellcolor[value] then 
						SV.db.media.unitframes.spellcolor[value] = false 
					end 
					MOD:SetUnitFrame("player")
					MOD:SetUnitFrame("target")
					MOD:SetUnitFrame("focus")
					ns:SetFilterOptions('AuraBars', value)
				end
			},
			removeSpell = {
				order = 2,
				name = L["Remove Spell"],
				desc = L["Remove a spell from the filter."],
				type = "select",
				guiInline = true,
				disabled = function() 
					local EMPTY = true;
					for g in pairs(SV.db.media.unitframes.spellcolor) do
						EMPTY = false;
					end
					return EMPTY
				end,
				values = function()
					wipe(tempFilterTable)
					for g in pairs(SV.db.media.unitframes.spellcolor)do 
						tempFilterTable[g] = g 
					end 
					return tempFilterTable 
				end,
				get = function(key) return "" end,
				set = function(key, value)
					if SV.db.media.unitframes.spellcolor[value] then 
						SV.db.media.unitframes.spellcolor[value] = false;
						SV:AddonMessage(L["You may not remove a spell from a default filter that is not customly added. Setting spell to false instead."])
					else 
						SV.db.media.unitframes.spellcolor[value] = nil 
					end
					MOD:SetUnitFrame("player")
					MOD:SetUnitFrame("target")
					MOD:SetUnitFrame("focus")
					ns:SetFilterOptions('AuraBars')
				end
			},
			selectSpell = {
				name = L["Select Spell"],
				type = "select",
				order = 3,
				guiInline = true,
				get = function(key) return selectedSpell end,
				set = function(key, value)
					ns:SetFilterOptions('AuraBars', value)
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
	};

	return RESULT;
end;

ns.FilterSpellGroups['AuraBars'] = function(selectedSpell)
	local RESULT;

	if(selectedSpell and (SV.db.media.unitframes.spellcolor[selectedSpell] ~= nil)) then
		RESULT = {
			type = "group",
			name = selectedSpell,
			order = 15,
			guiInline = true,
			args = {
				color = {
					name = L["Color"],
					type = "color",
					order = 1,
					get = function(key)
						local abColor = SV.db.media.unitframes.spellcolor[selectedSpell]
						if type(abColor) == "boolean"then 
							return 0, 0, 0, 1 
						else 
							return abColor[1], abColor[2], abColor[3], abColor[4] 
						end 
					end,
					set = function(key, r, g, b)
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
					func = function(key, value)
						SV.db.media.unitframes.spellcolor[selectedSpell] = false;
						MOD:SetUnitFrame("player")
						MOD:SetUnitFrame("target")
						MOD:SetUnitFrame("focus")
					end
				}
			}
		};
	end

	return RESULT;
end;