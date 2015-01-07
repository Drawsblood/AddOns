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
local GetSpellInfo = _G.GetSpellInfo;
local collectgarbage = _G.collectgarbage;

ns.FilterOptionGroups['_NEW'] = function(filterType)
	return function(selectedSpell)
		local RESULT, FILTER
		if(SV.filters.Custom[filterType]) then 
			FILTER = SV.filters.Custom[filterType] 
		else
			FILTER = SV.filters[filterType]
		end

		if(FILTER) then
			RESULT = {
				type = "group",
				name = filterType,
				guiInline = true,
				order = 4,
				args = {
					addSpell = {
						order = 1,
						name = L["Add Spell"],
						desc = L["Add a spell to the filter."],
						type = "input",
						get = function(key) return "" end,
						set = function(key, value)
							if(not FILTER[value]) then 
								FILTER[value] = {
									["enable"] = true,
									["priority"] = 0
								}
							end 
							ns:SetFilterOptions(filterType)
							MOD:RefreshUnitFrames()
						end
					},
					removeSpell = {	
						order = 2,
						name = L["Remove Spell"],
						desc = L["Remove a spell from the filter."],
						type = "select",
						disabled = function() 
							local EMPTY = true;
							for g in pairs(FILTER) do
								EMPTY = false;
							end
							return EMPTY
						end,
						values = function()
							wipe(tempFilterTable)
							for g in pairs(FILTER) do
								tempFilterTable[g] = g
							end
							return tempFilterTable 
						end,
						get = function(key) return "" end,
						set = function(key, value)
							if(FILTER[value]) then
								if(FILTER[value].isDefault) then
									FILTER[value].enable = false;
									SV:AddonMessage(L["You may not remove a spell from a default filter that is not customly added. Setting spell to false instead."])
								else 
									FILTER[value] = nil 
								end
							end
							ns:SetFilterOptions(filterType)
							MOD:RefreshUnitFrames()
						end
					},
				}
			};
		end;

		return RESULT;
	end;
end;

ns.FilterSpellGroups['_NEW'] = function(filterType)
	return function()
		local RESULT, FILTER
		if(SV.filters.Custom[filterType]) then 
			FILTER = SV.filters.Custom[filterType] 
		else
			FILTER = SV.filters[filterType]
		end

		if(FILTER) then
			RESULT = {
				type = "group", 
				name = filterType .. " - " .. L["Spells"], 
				order = 5, 
				guiInline = true, 
				args = {}
			};

			for aura, filterData in pairs(FILTER) do
				RESULT.args[aura] = {
					name = aura, 
					type = "toggle", 
					get = function()
						return FILTER[aura].enable  
					end, 
					set = function(key, value)
						FILTER[aura].enable = value;
						MOD:RefreshUnitFrames()
						ns:SetFilterOptions()
					end
				};
			end
		end

		return RESULT;
	end;
end;