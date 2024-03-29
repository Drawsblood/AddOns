local addonName, vars = ...
local core = vars.core
local L = vars.L
local addon = vars
vars.config = core:NewModule("Config")
local module = vars.config

local Config = LibStub("AceConfig-3.0")

local db

addon.svnrev["config.lua"] = tonumber(("$Revision: 473 $"):match("%d+"))

addon.diff_strings = {
	D1 = DUNGEON_DIFFICULTY1, -- 5 man
	D2 = DUNGEON_DIFFICULTY2, -- 5 man (Heroic)
	D3 = DUNGEON_DIFFICULTY1.." ("..GetDifficultyInfo(23)..")", -- 5 man (Mythic)
	R0 = EXPANSION_NAME0 .. " " .. LFG_TYPE_RAID,
	R1 = RAID_DIFFICULTY1, -- "10 man"
	R2 = RAID_DIFFICULTY2, -- "25 man"
	R3 = RAID_DIFFICULTY3, -- "10 man (Heroic)"
	R4 = RAID_DIFFICULTY4, -- "25 man (Heroic)"
	R5 = GetDifficultyInfo(7), -- "Looking for Raid"
	R6 = GetDifficultyInfo(14), -- "Normal raid"
	R7 = GetDifficultyInfo(15), -- "Heroic raid"
	R8 = GetDifficultyInfo(16), -- "Mythic raid"
}
local FONTEND = FONT_COLOR_CODE_CLOSE
local GOLDFONT = NORMAL_FONT_COLOR_CODE

-- config global functions

function module:OnInitialize()
	db = vars.db
	module:SetupOptions()
	addon:SetupVersion()
end

BINDING_NAME_SAVEDINSTANCES = L["Show/Hide the SavedInstances tooltip"]
BINDING_HEADER_SAVEDINSTANCES = "SavedInstances"


-- general helper functions

function addon:idtext(instance,diff,info)
  if instance.WorldBoss then
    return L["World Boss"]
  elseif info.ID < 0 then 
    return "" -- ticket 144: could be RAID_FINDER or FLEX_RAID, but this is already shown in the instance name so it's redundant anyhow
  elseif not instance.Raid then
    if diff == 23 then
      return addon.diff_strings["D3"]
    else
      return addon.diff_strings["D"..diff]
    end
  elseif instance.Expansion == 0 then -- classic Raid
    return addon.diff_strings.R0
  elseif instance.Raid and diff >= 3 and diff <= 7 then -- pre-WoD raids
    return addon.diff_strings["R"..(diff-2)]
  elseif diff >= 14 and diff <= 16 then -- WoD raids
    return addon.diff_strings["R"..(diff-8)]
  else
    return ""
  end
end

local function TableLen(table)
	local i = 0
	for _, _ in pairs(table) do
		i = i + 1
	end
	return i
end

local function IndicatorOptions()
	local args = {
		Instructions = {
			order = 1,
			type = "description",
			name = L["You can combine icons and text in a single indicator if you wish. Simply choose an icon, and insert the word ICON into the text field. Anywhere the word ICON is found, the icon you chose will be substituted in."].." "..L["Similarly, the words KILLED and TOTAL will be substituted with the number of bosses killed and total in the lockout."],
		},
	}
	for diffname, diffstr in pairs(addon.diff_strings) do
		local dorder = (tonumber(diffname:match("%d+")) or 0) + 10
		if diffname:find("^R") then dorder = dorder + 10 end
		args[diffname] = {
			type = "group",
			name = diffstr,
			order = dorder,
			args = {
				[diffname.."Indicator"] = { 
					order = 1, 
					type = "select", 
					width = "half", 
					name = EMBLEM_SYMBOL, 
					values = vars.Indicators 
				},
				[diffname.."Text"] = { 
					order = 2, 
					type = "input", 
					name = L["Text"], 
					multiline = false 
				},
				[diffname.."Color"] = { 
					order = 3, 
					type = "color", 
					width = "half", 
					hasAlpha = false, 
					name = COLOR,
					disabled = function()
						return db.Indicators[diffname .. "ClassColor"]
					end,
					get = function(info)
		        			db.Indicators[info[#info]] = db.Indicators[info[#info]] or vars.defaultDB.Indicators[info[#info]]
						local r = db.Indicators[info[#info]][1]
						local g = db.Indicators[info[#info]][2]
						local b = db.Indicators[info[#info]][3]
						return r, g, b, nil
					end,
					set = function(info, r, g, b, ...)
						db.Indicators[info[#info]][1] = r
						db.Indicators[info[#info]][2] = g
						db.Indicators[info[#info]][3] = b
					end,
				},
				[diffname.."ClassColor"] = { 
					order = 4, 
					type = "toggle", 
					name = L["Use class color"] 
				},
			},
		}
	end
	return args
end

local function GroupListGUI(order, name, list)
	local total = TableLen(list)
	local group = {
		type = "group",
		inline = true,
		name = name,
		order = order,
		args = {
			item1 = {
				type = "description",
				name = L["List is empty"],
			},
		},
	}
	for i = 1, total do
		group.args["item" .. i] = {
			type = "description",
			name = list[i],
			order = i,
		}
	end
	return group
end

-- options table below
function module:BuildOptions() 
  local valueslist = { ["always"] = GREEN_FONT_COLOR_CODE..L["Always show"]..FONTEND,
 		       ["saved"] = L["Show when saved"],
      		       ["never"] = RED_FONT_COLOR_CODE..L["Never show"]..FONTEND,
     		      }
  local opts = {
	type = "group",
	name = "SavedInstances",
	handler = SavedInstances,
	args = {
		debug = { 
			name = "debug",
			cmdHidden = true,
			guiHidden = true,
			type = "execute",
			func = function() db.dbg = not db.dbg; addon.debug("Debug set to: "..(db.dbg and "true" or "false")) end,
		},
		config = { 
			name = L["Open config"],
			guiHidden = true,
			type = "execute",
			func = function() module:ShowConfig() end,
		},
		time = { 
			name = L["Dump time debugging information"],
			guiHidden = true,
			type = "execute",
			func = function() addon:timedebug() end,
		},
		show = { 
			name = L["Show/Hide the SavedInstances tooltip"],
			guiHidden = true,
			type = "execute",
			func = function() addon:ToggleDetached() end,
		},
		General = {
			order = 1,
			type = "group",
			name = L["General settings"],
			get = function(info)
					return db.Tooltip[info[#info]]
			end,
			set = function(info, value)
					addon.debug(info[#info].." set to: "..tostring(value))
					db.Tooltip[info[#info]] = value
					wipe(addon.scaleCache)
					wipe(addon.oi_cache)
					addon.oc_cache = nil
			end,
			args = {
				ver = {
					order = 0.5,
					type = "description",
					name = function() return "Version: SavedInstances "..addon.version end,
				},
				intro = {
					order = 1,
					type = "description",
					name = L["Track the instance IDs saved against your characters"],
				},
				GeneralHeader = {
					order = 2, 
					type = "header",
					name = L["General settings"],
				},
				MinimapIcon = {
					type = "toggle",
					name = L["Show minimap button"],
					desc = L["Show the SavedInstances minimap button"],
					order = 3,
					hidden = function() return not vars.icon end,
					get = function(info) return not db.MinimapIcon.hide end,
					set = function(info, value)
						db.MinimapIcon.hide = not value
						vars.icon:Refresh(addonName)
					end,
				},
				DisableMouseover = {
					type = "toggle",
					name = L["Disable mouseover"],
					desc = L["Disable tooltip display on icon mouseover"],
					order = 3.5,
				},
				ShowHints = {
					type = "toggle",
					name = L["Show tooltip hints"],
					order = 4,
				},
				ReportResets = {
					type = "toggle",
					name = L["Report instance resets to group"],
					order = 4.5,
				},
				LimitWarn = {
					type = "toggle",
					name = L["Warn about instance limit"],
					order = 4.7,
				},
				HistoryText = {
					type = "toggle",
					name = L["Instance limit in broker"],
					order = 4.8,
				},

				CharactersHeader = {
					order = 4.9, 
					type = "header",
					name = L["Characters"],
				},
				ShowServer = {
					type = "toggle",
					name = L["Show server name"],
					order = 5,
				},
				ServerSort = {
					type = "toggle",
					name = L["Sort by server"],
					order = 6,
				},
				ServerOnly = {
					type = "toggle",
					name = L["Show only current server"],
					order = 6.25,
				},
				SelfAlways = {
					type = "toggle",
					name = L["Show self always"],
					order = 6.5,
				},
				SelfFirst = {
					type = "toggle",
					name = L["Show self first"],
					order = 7,
				},
				
				CategoriesHeader = {
					order = 11, 
					type = "header",
					name = L["Categories"],
				},
				ShowCategories = {
					type = "toggle",
					name = L["Show category names"],
					desc = L["Show category names in the tooltip"],
					order = 12,
				},
				ShowSoloCategory = {
					type = "toggle",
					name = L["Single category name"],
					desc = L["Show name for a category when all displayed instances belong only to that category"],
					order = 13,
					disabled = function()
						return not db.Tooltip.ShowCategories
					end,
				},
				CategorySpaces = {
					type = "toggle",
					name = L["Space between categories"],
					desc = L["Display instances with space inserted between categories"],
					order = 14,
				},
				CategorySort = {
					order = 15,
					type = "select",
				--	style = "radio",
					name = L["Sort categories by"],
					values = {
						["EXPANSION"] = L["Expansion"],
						["TYPE"] = L["Type"],
					},
				},
				NewFirst = {
					type = "toggle",
					name = L["Most recent first"],
					desc = L["List categories from the current expansion pack first"],
					order = 16,
				},
				RaidsFirst = {
					type = "toggle",
					name = L["Raids before dungeons"],
					desc = L["List raid categories before dungeon categories"],
					order = 17,
				},
				FitToScreen = {
					type = "toggle",
					name = L["Fit to screen"],
					desc = L["Automatically shrink the tooltip to fit on the screen"],
					order = 4.81,
				},
			        Scale = {
					type = "range",
					name = L["Tooltip Scale"],
					order = 4.82,
					min = 0.1,
					max = 5,
					bigStep = 0.05,
				},
			        RowHighlight = {
					type = "range",
					name = L["Row Highlight"],
					desc = L["Opacity of the tooltip row highlighting"],
					order = 4.83,
					min = 0,
					max = 0.5,
					bigStep = 0.1,
					isPercent = true,
				},
				
				InstancesHeader = {
					order = 20, 
					type = "header",
					name = L["Instances"],
				},
				ReverseInstances = {
					type = "toggle",
					name = L["Reverse ordering"],
					desc = L["Display instances in order of recommended level from lowest to highest"],
					order = 23,
				},
				ShowExpired = {
					type = "toggle",
					name = L["Show Expired"],
					desc = L["Show expired instance lockouts"],
					order = 23.5,
				},
				ShowHoliday = {
					type = "toggle",
					name = L["Show Holiday"],
					desc = L["Show holiday boss rewards"],
					order = 23.65,
				},
				ShowRandom = {
					type = "toggle",
					name = L["Show Random"],
					desc = L["Show random dungeon bonus reward"],
					order = 23.75,
				},
				CombineWorldBosses = {
					type = "toggle",
					name = L["Combine World Bosses"],
					desc = L["Combine World Bosses"],
					order = 23.85,
				},
				CombineLFR = {
					type = "toggle",
					name = L["Combine LFR"],
					desc = L["Combine LFR"],
					order = 23.95,
				},
				MiscHeader = {
					order = 30, 
					type = "header",
					name = L["Miscellaneous"],
				},
				TrackDailyQuests = {
					type = "toggle",
					order = 33,
					name = L["Track Daily Quests"],
				},
				TrackWeeklyQuests = {
					type = "toggle",
					order = 33.5,
					name = L["Track Weekly Quests"],
				},
				RemindCharms = {
					type = "toggle",
					order = 33.6,
					width = "double",
					name = L["Remind about weekly charm quest"],
				},
				TrackSkills = {
					type = "toggle",
					order = 33.75,
					width = "double",
					name = L["Track trade skill cooldowns"],
				},
				TrackFarm = {
					type = "toggle",
					order = 33.80,
					width = "double",
					name = L["Track farm crops"],
				},
				TrackBonus = {
					type = "toggle",
					order = 33.85,
					width = "double",
					name = L["Track bonus loot rolls"],
				},
				AugmentBonus = {
					type = "toggle",
					order = 33.95,
					width = "double",
					name = L["Augment bonus loot frame"],
				},
				TrackLFG = {
					type = "toggle",
					order = 34,
					width = "double",
					name = L["Track LFG dungeon cooldown"],
					desc = L["Show cooldown for characters to use LFG dungeon system"],
				},
				TrackDeserter = {
					type = "toggle",
					order = 35,
					width = "double",
					name = L["Track Battleground Deserter cooldown"],
					desc = L["Show cooldown for characters to use battleground system"],
				},
				CurrencyHeader = {
					order = 50, 
					type = "header",
					name = CURRENCY,
				},
				CurrencyMax = {
					type = "toggle",
					order = 50.2,
					name = L["Show currency max"]
				},
				CurrencyEarned = {
					type = "toggle",
					order = 50.4,
					name = L["Show currency earned"]
				},
				CurrencyValueColor = {
					type = "toggle",
					order = 50.5,
					name = L["Color currency by cap"]
				},
				ToonHeader = {
					order = 31, 
					type = "header",
					name = L["Characters"],
					hidden = true,
				},
				ColumnStyle = {
					order = 32,
					type = "select",
					width = "double",
					style = "radio",
					hidden = true,
					disabled = true,
					name = L["Character column style"],
					values = {
						["ALTERNATING"] = L["Alternating columns are colored differently"],
						["CLASS"] = L["Columns are colored according to the characters class"],
						["NORMAL"] = L["Columns are the same color as the whole tooltip"],
					},
				},
				AltColumnColor = { 
					order = 33,
					type = "color",
					width = "half",
					hasAlpha = true,
					name = COLOR,
					hidden = true,
--					hidden = function()
--						return not (db.Tooltip.ColumnStyle == "ALTERNATING")
--					end,
					disabled = true,
--					disabled = function()
--						return not (db.Tooltip.ColumnStyle == "ALTERNATING")
--					end,
					get = function(info)
						local r = db.Tooltip[info[#info]][1]
						local g = db.Tooltip[info[#info]][2]
						local b = db.Tooltip[info[#info]][3]
						local a = db.Tooltip[info[#info]][4]
						return r, g, b, a
					end,
					set = function(info, r, g, b, a)
						db.Tooltip[info[#info]][1] = r
						db.Tooltip[info[#info]][2] = g
						db.Tooltip[info[#info]][3] = b
						db.Tooltip[info[#info]][4] = a
					end,
				},

				BindHeader = {
					order = -0.6, 
					type = "header",
					name = "",
					cmdHidden = true,
				},
			  	
                                ToggleBind = {
      					desc = L["Bind a key to toggle the SavedInstances tooltip"],
     	 				type = "keybinding",
      					name = L["Show/Hide the SavedInstances tooltip"],
					width = "double",
      					cmdHidden = true,
      					order = -0.5,
      					set = function(info,val)
         					local b1, b2 = GetBindingKey("SAVEDINSTANCES")
         					if b1 then SetBinding(b1) end
         					if b2 then SetBinding(b2) end
         					SetBinding(val, "SAVEDINSTANCES")
         					SaveBindings(GetCurrentBindingSet())
      					end,
      					get = function(info) return GetBindingKey("SAVEDINSTANCES") end
    				},
			},
		},
		Indicators = {
			order = 2,
			type = "group",
			name = L["Indicators"],
			get = function(info)
			   if db.Indicators[info[#info]] ~= nil then -- tri-state boolean logic
			     return db.Indicators[info[#info]]
			   else
			     return vars.defaultDB.Indicators[info[#info]]
			   end
			end,
			set = function(info, value)
					addon.debug("Config set: "..info[#info].." = "..(value and "true" or "false"))
					db.Indicators[info[#info]] = value
			end,
			args = IndicatorOptions(),
		},
		Instances = {
			order = 4,
			type = "group",
			name = L["Instance options"],
			childGroups = "select",
			width = "double",
			args = (function()
			  local ret = {}
			  for i,cat in ipairs(vars.OrderedCategories()) do
			    ret[cat] = {
			        order = i,
				type = "group",
				name = vars.Categories[cat],
				childGroups = "tree",
				args = (function()
				  local iret = {}
				  for j, inst in ipairs(addon:OrderedInstances(cat)) do
					iret[inst] = {
					  order = j,
					  name = inst,
				  	        type = "select",
						-- style = "radio",
				  		values = valueslist,
				  		get = function(info)
						        local val = db.Instances[inst].Show
				    			return (val and valueslist[val] and val) or "saved"
				  		end,
				  		set = function(info, value)
				   		 	db.Instances[inst].Show = value
				  		end,
				        }
				  end 
				  return iret
                                 end)(),
				} 
			  end
			  return ret
			end)(),
		},
		Characters = {
			order = 4,
			type = "group",
			name = L["Characters"],
			childGroups = "select",
			width = "double",
			args = (function ()
			  local toons = {} 
			  for toon, _ in pairs(db.Toons) do
			    local tn, ts = toon:match('^(.*) [-] (.*)$')
			    toons[ts] = toons[ts] or {}
			    toons[ts][tn] = toon
			  end
			  local ret = {}
			  ret.reset = {
			    order = 0.1,
			    name = L["Reset Characters"],
			    type = "execute",
			    func = function()
			    	StaticPopup_Show("SAVEDINSTANCES_RESET")
			    end
			  }
			  ret.recover = {
			    order = 0.2,
			    name = L["Recover Dailies"],
			    desc = L["Attempt to recover completed daily quests for this character. Note this may recover some additional, linked daily quests that were not actually completed today."],
			    type = "execute", 
			    func = function()
			        core:Refresh(true)
			    end
			  }
			  local scnt = 0;
			  for server, stoons in pairs(toons) do
			    scnt = scnt + 1;
			    ret[server] = {
			      order = (server == GetRealmName() and 0.5 or scnt),
			      type = "group",
			      name = server,
		  	      childGroups = "tree",
			      args = (function()
				local tret = {}
			        for tn, toon in pairs(stoons) do
				  tret[toon] = {
			            name = tn,
				    type = "select",
				    values = valueslist,
				    get = function(info)
				      return db.Toons[toon].Show or "saved"
				    end,
				    set = function(info, value)
				      db.Toons[toon].Show = value
				    end,
				  }
				end
				return tret
		              end)(),
			    }
			  end
			  return ret
			end)()
		},
		--[[
		Lockouts = {
			order = 5,
			type = "group",
			childGroups = "tab",
			name = L["Lockouts"],
			disabled = function()
				return module.selectedLockout == nil
			end,
			args = {
				SelectedToon = {
					order = 1,
					type = "select",
					width = "double",
					name = L["Selected lockout"],
					disabled = function()
						return TableLen(db.Lockouts) == 0
					end,
					get = function(info)
						return module.selectedLockout
					end,
					set = function(info, value)
						module.selectedLockout = value
					end,
					values = function()
						local table = { }
						for lockout, l in pairs(db.Lockouts) do
							table[lockout] = lockout .. " " .. l.Name
						end
						return table
					end,
				},
				LockoutNote = {
					order = 2,
					type = "input",
					width = "double",
					name = L["Note"],
					get = function()
						if not module.selectedLockout then return end
						return db.Lockouts[module.selectedLockout].Note
					end,
					set = function(info, value)
						db.Lockouts[module.selectedLockout].Note = value
					end,
				},
			},
		},
		--]]
	},
}
  core.Options = core.Options or {} -- allow option table rebuild
  for k,v in pairs(opts) do
    core.Options[k] = v
  end
  for i, curr in ipairs(addon.currency) do
    local name,_,tex = GetCurrencyInfo(curr)
    tex = "\124T"..tex..":0\124t "
    core.Options.args.General.args["Currency"..curr] = { 
	type = "toggle",
	order = 50+i,
	name = tex..name,
    }
  end
end

-- global functions

local lockoutgroup
--function module:ShowLockoutWindow(lockout)
--	print(tostring(lockout))
--	module.selectedLockout = arg
--	InterfaceOptionsFrame_OpenToCategory(lockoutgroup)
--end

function module:table_clone(t)
  if not t then return nil end
  local r = {}
  for k,v in pairs(t) do
    local nk,nv = k,v
    if type(k) == "table" then
      nk = module:table_clone(k)
    end
    if type(v) == "table" then
      nv = module:table_clone(v)
    end
    r[nk] = nv
  end
  return r
end

local firstoptiongroup, lastoptiongroup
function module:ReopenConfigDisplay(f)
   if InterfaceOptionsFrame:IsShown() then
      InterfaceOptionsFrame:Hide();
      InterfaceOptionsFrame_OpenToCategory(lastoptiongroup)
      InterfaceOptionsFrame_OpenToCategory(firstoptiongroup)
      InterfaceOptionsFrame_OpenToCategory(f)
   end
end

function module:SetupOptions()
	local ACD = LibStub("AceConfigDialog-3.0")
	local namespace = "SavedInstances"
	module:BuildOptions()
	LibStub("AceConfig-3.0"):RegisterOptionsTable(namespace, core.Options, { "si", "savedinstances" })
        local fgen = ACD:AddToBlizOptions(namespace, nil, nil, "General")
	firstoptiongroup = fgen
        fgen.default = function() 
                       addon.debug("RESET: General")
                       db.Tooltip = module:table_clone(vars.defaultDB.Tooltip) 
                       db.MinimapIcon = module:table_clone(vars.defaultDB.MinimapIcon) 
                       module:ReopenConfigDisplay(fgen)
                    end
	local find = ACD:AddToBlizOptions(namespace, L["Indicators"], namespace, "Indicators")
        find.default = function() 
                       addon.debug("RESET: Indicators")
                       db.Indicators = module:table_clone(vars.defaultDB.Indicators) 
                       module:ReopenConfigDisplay(find)
                    end
	local finst = ACD:AddToBlizOptions(namespace, L["Instances"], namespace, "Instances")
        finst.default = function() 
                       addon.debug("RESET: Instances")
                       for _,i in pairs(db.Instances) do
                          i.Show = "saved"
                       end
                       module:ReopenConfigDisplay(finst)
                    end
	--ACD:AddToBlizOptions(namespace, L["Lockouts"], namespace, "Lockouts")
	local ftoon = ACD:AddToBlizOptions(namespace, L["Characters"], namespace, "Characters")
	lastoptiongroup = ftoon
	module.ftoon = ftoon
        ftoon.default = function() 
                       addon.debug("RESET: Toons")
                       for _,i in pairs(db.Toons) do
                          i.Show = "saved"
                       end
                       module:ReopenConfigDisplay(ftoon)
                    end
end

function module:ShowConfig()
   if InterfaceOptionsFrame:IsShown() then
        InterfaceOptionsFrame:Hide()
   else
	InterfaceOptionsFrame_OpenToCategory(lastoptiongroup)
	InterfaceOptionsFrame_OpenToCategory(firstoptiongroup)
   end
end

