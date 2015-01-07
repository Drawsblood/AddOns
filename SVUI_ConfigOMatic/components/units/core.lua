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
local string     =  _G.string;
local find,gsub,upper = string.find, string.gsub, string.upper;
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
local ACD = LibStub("AceConfigDialog-3.0");
--[[ 
########################################################## 
LOCAL VARS/FUNCTIONS
##########################################################
]]--
local filterList = {};
local textStringFormats = {
	["none"] = "None",
	["current"] = "Current",
	["deficit"] = "Deficit",
	["percent"] = "Percent",
	["curpercent"] = "Current - Percent",
	["curmax"] = "Current - Maximum",
	["curmax-percent"] = "Current - Maximum | %",
}
local FRAME_MAP = {
	["player"] = "SVUI_Player", 
	["target"] = "SVUI_Target", 
	["targettarget"] = "SVUI_TargetTarget",
	["pet"] = "SVUI_Pet", 
	["pettarget"] = "SVUI_PetTarget",
	["focus"] = "SVUI_Focus",  
	["focustarget"] = "SVUI_FocusTarget",
	--["boss"] = "SVUI_Boss", 
	--["arena"] = "SVUI_Arena",
	--["party"] = "SVUI_Party",
	--["raid"] = "SVUI_Raid",
	--["raidpet"] = "SVUI_Raidpet",
	--["tank"] = "SVUI_Tank",
	--["assist"] = "SVUI_Assist",
};
--[[ 
########################################################## 
SET PACKAGE OPTIONS
##########################################################
]]--
function ns:SetSizeConfigGroup(gridMode, unitName)
	local sizeGroup = {
		order = 2, 
		guiInline = true, 
		type = "group", 
		name = L["Size Settings"],
		args = {}
	}

	if(gridMode) then
		sizeGroup.args = {
			size = {
				order = 1, 
				name = L["Grid Size"], 
				type = "range", 
				min = 10, 
				max = 100, 
				step = 1,
				width = 'full',
				get = function(key) return SV.db.SVUnit[unitName].grid[key[#key]] end,
				set = function(key, value) MOD:ChangeDBVar(value, key[#key], unitName, "grid"); MOD:SetGroupFrame(unitName) end,
			},
			spacer1 = {
				order = 2, 
				name = "", 
				type = "description", 
				width = "full", 
			},
			wrapXOffset = {
				order = 3, 
				type = "range", 
				name = L["Horizontal Spacing"], 
				min = 0, 
				max = 50, 
				step = 1,
				get = function(key) return SV.db.SVUnit[unitName][key[#key]] end,
				set = function(key, value) MOD:ChangeDBVar(value, key[#key], unitName); MOD:SetGroupFrame(unitName) end,
			}, 
			wrapYOffset = {
				order = 4, 
				type = "range", 
				name = L["Vertical Spacing"], 
				min = 0, 
				max = 50, 
				step = 1,
				get = function(key) return SV.db.SVUnit[unitName][key[#key]] end,
				set = function(key, value) MOD:ChangeDBVar(value, key[#key], unitName); MOD:SetGroupFrame(unitName) end,
			},
		}
	else
		sizeGroup.args = {
			width = {
				order = 1, 
				name = L["Width"], 
				type = "range", 
				min = 10, 
				max = 500, 
				step = 1,
				width = 'full',
				get = function(key) return SV.db.SVUnit[unitName][key[#key]] end,
				set = function(key, value) MOD:ChangeDBVar(value, key[#key], unitName); MOD:SetGroupFrame(unitName) end,
			}, 
			height = {
				order = 2, 
				name = L["Height"], 
				type = "range", 
				min = 10, 
				max = 500, 
				step = 1,
				width = 'full',
				get = function(key) return SV.db.SVUnit[unitName][key[#key]] end,
				set = function(key, value) MOD:ChangeDBVar(value, key[#key], unitName); MOD:SetGroupFrame(unitName) end,
			},
			spacer1 = {
				order = 3, 
				name = "", 
				type = "description", 
				width = "full", 
			},
			wrapXOffset = {
				order = 4, 
				type = "range", 
				name = L["Horizontal Spacing"], 
				min = 0, 
				max = 50, 
				step = 1,
				width = 'full',
				get = function(key) return SV.db.SVUnit[unitName][key[#key]] end,
				set = function(key, value) MOD:ChangeDBVar(value, key[#key], unitName); MOD:SetGroupFrame(unitName) end,
			}, 
			wrapYOffset = {
				order = 5, 
				type = "range", 
				name = L["Vertical Spacing"], 
				min = 0, 
				max = 50, 
				step = 1,
				width = 'full',
				get = function(key) return SV.db.SVUnit[unitName][key[#key]] end,
				set = function(key, value) MOD:ChangeDBVar(value, key[#key], unitName); MOD:SetGroupFrame(unitName) end,
			},
		}
	end

	return sizeGroup
end

function ns:SetCastbarConfigGroup(updateFunction, unitName, count)	
	local configTable = {
		order = 800, 
		type = "group", 
		name = L["Castbar"], 
		get = function(key)
			return SV.db.SVUnit[unitName]["castbar"][key[#key]]
		end,
		set = function(key, value)
			MOD:ChangeDBVar(value, key[#key], unitName, "castbar")
			updateFunction(MOD, unitName, count)
		end,
		args = {
			enable = {
				type = "toggle", 
				order = 1, 
				name = L["Enable"]
			},
			commonGroup = {
				order = 2, 
				guiInline = true, 
				type = "group", 
				name = L["Base Settings"], 
				args = {
					forceshow = {
						order = 1, 
						name = SHOW.." / "..HIDE,
						type = "execute",
						func = function()
							local v = unitName:gsub("(.)", upper, 1)
							v = "SVUI_"..v;
							v = v:gsub("t(arget)", "T%1")
							if count then 
								for w = 1, count do 
									local castbar = _G[v..w].Castbar;
									if not castbar.oldHide then 
										castbar.oldHide = castbar.Hide;
										castbar.Hide = castbar.Show;
										castbar:Show()
									else
										castbar.Hide = castbar.oldHide;
										castbar.oldHide = nil;
										castbar:Hide()
										castbar.lastUpdate = 0 
									end 
								end 
							else
								local castbar = _G[v].Castbar;
								if not castbar.oldHide then 
									castbar.oldHide = castbar.Hide;
									castbar.Hide = castbar.Show;
									castbar:Show()
								else
									castbar.Hide = castbar.oldHide;
									castbar.oldHide = nil;
									castbar:Hide()
									castbar.lastUpdate = 0 
								end 
							end 
						end,
					},
					icon = {
						order = 2, 
						name = L["Icon"], 
						type = "toggle"
					},
					latency = {
						order = 3, 
						name = L["Latency"], 
						type = "toggle"
					},
					spark = {
						order = 4, 
						type = "toggle", 
						name = L["Spark"]
					},
				}
			},
			sizeGroup = {
				order = 3, 
				guiInline = true, 
				type = "group", 
				name = L["Size Settings"], 
				args = {
					matchFrameWidth = {
						order = 1, 
						name = L["Auto Width"], 
						desc = "Force the castbar to ALWAYS match its unitframes width.",
						type = "toggle", 
					},
					matchsize = {
						order = 2, 
						type = "execute", 
						name = L["Match Frame Width"], 
						desc = "Set the castbar width to match its unitframe.",
						func = function()
							SV.db.SVUnit[unitName]["castbar"]["width"] = SV.db.SVUnit[unitName]["width"]
							updateFunction(MOD, unitName, count)
						end
					},
					width = {
						order = 3, 
						name = L["Width"], 
						type = "range", 
						width = "full",
						min = 50, 
						max = 600, 
						step = 1,
						disabled = function() return SV.db.SVUnit[unitName]["castbar"].matchFrameWidth end
					},
					height = {
						order = 4, 
						name = L["Height"], 
						type = "range",
						width = "full",
						min = 10, 
						max = 85, 
						step = 1
					},
				}
			},
			colorGroup = {
				order = 4, 
				type = "group", 
				guiInline = true, 
				name = L["Custom Coloring"],
				args = {
					useCustomColor = {
						type = "toggle", 
						order = 1, 
						name = L["Enable"]
					},
					castingColor = {
						order = 2, 
						name = L["Custom Bar Color"], 
						type = "color",
						get = function(key)
							local color = SV.db.SVUnit[unitName]["castbar"]["castingColor"]
							return color[1], color[2], color[3], color[4] 
						end, 
						set = function(key, rValue, gValue, bValue)
							SV.db.SVUnit[unitName]["castbar"]["castingColor"] = {rValue, gValue, bValue}
							MOD:RefreshUnitFrames()
						end,
						disabled = function() return not SV.db.SVUnit[unitName]["castbar"].useCustomColor end
					}, 
					sparkColor = {
						order = 3, 
						name = L["Custom Spark Color"],
						type = "color",
						get = function(key)
							local color = SV.db.SVUnit[unitName]["castbar"]["sparkColor"]
							return color[1], color[2], color[3], color[4] 
						end, 
						set = function(key, rValue, gValue, bValue)
							SV.db.SVUnit[unitName]["castbar"]["sparkColor"] = {rValue, gValue, bValue}
							MOD:RefreshUnitFrames()
						end,
						disabled = function() return not SV.db.SVUnit[unitName]["castbar"].useCustomColor end
					},
				}
			},
			formatGroup = {
				order = 4, 
				guiInline = true, 
				type = "group", 
				name = L["Text Settings"], 
				args = {
					format = {
						order = 1, 
						type = "select", 
						name = L["Format"], 
						values = { ["CURRENTMAX"] = L["Current / Max"], ["CURRENT"] = L["Current"], ["REMAINING"] = L["Remaining"] }
					},
				}
			}
		}
	}
	if(unitName == "player") then 
		configTable.args.commonGroup.args.ticks = {
			order = 6, 
			type = "toggle", 
			name = L["Ticks"], 
			desc = L["Display tick marks on the castbar."]
		}
		configTable.args.commonGroup.args.displayTarget = {
			order = 7, 
			type = "toggle", 
			name = L["Display Target"], 
			desc = L["Display the target of your current cast."]
		}
	end 
	return configTable 
end 

function ns:SetMiscConfigGroup(partyRaid, updateFunction, unitName, count)
	local miscGroup = {
		order = 99, 
		type = "group",  
		name = L["Misc Text"],
		set = function(key, value)
			MOD:ChangeDBVar(value, key[#key], unitName, "formatting");
			local tag = ""
			local pc = SV.db.SVUnit[unitName]["formatting"].threat and "[threat]" or "";
			tag = tag .. pc;
			local ap = SV.db.SVUnit[unitName]["formatting"].absorbs and "[absorbs]" or "";
			tag = tag .. ap;
			local cp = SV.db.SVUnit[unitName]["formatting"].incoming and "[incoming]" or "";
			tag = tag .. cp;

			MOD:ChangeDBVar(tag, "tags", unitName, "misc");
			updateFunction(MOD, unitName, count)
		end,
		args = {
			incoming = {
				order = 1, 
				name = L["Show Incoming Heals"], 
				type = "toggle", 
				get = function() return SV.db.SVUnit[unitName]["formatting"].incoming end,
			},
			absorbs = {
				order = 2, 
				name = L["Show Absorbs"], 
				type = "toggle", 
				get = function() return SV.db.SVUnit[unitName]["formatting"].absorbs end,
			},
			threat = {
				order = 3, 
				name = L["Show Threat"], 
				type = "toggle", 
				get = function() return SV.db.SVUnit[unitName]["formatting"].threat end,
			},
			xOffset = {
				order = 4, 
				type = "range", 
				width = "full", 
				name = L["Misc Text X Offset"], 
				desc = L["Offset position for text."], 
				min = -300, 
				max = 300, 
				step = 1,
				get = function() return SV.db.SVUnit[unitName]["formatting"].xOffset end,
				set = function(key, value) MOD:ChangeDBVar(value, key[#key], unitName, "formatting"); end,
			}, 
			yOffset = {
				order = 5, 
				type = "range", 
				width = "full", 
				name = L["Misc Text Y Offset"], 
				desc = L["Offset position for text."], 
				min = -300, 
				max = 300, 
				step = 1,
				get = function() return SV.db.SVUnit[unitName]["formatting"].yOffset end,
				set = function(key, value) MOD:ChangeDBVar(value, key[#key], unitName, "formatting"); end,
			}, 
		}
	}
	return miscGroup
end 

function ns:SetHealthConfigGroup(partyRaid, updateFunction, unitName, count)
	local healthOptions = {
		order = 100, 
		type = "group", 
		name = L["Health"], 
		get = function(key) 
			return SV.db.SVUnit[unitName]["health"][key[#key]] 
		end, 
		set = function(key, value)
			MOD:ChangeDBVar(value, key[#key], unitName, "health");
			updateFunction(MOD, unitName, count)
		end,
		args = {
			commonGroup = {
				order = 1, 
				type = "group", 
				guiInline = true, 
				name = L["Base Settings"],
				args = {
					position = {
						type = "select", 
						order = 1, 
						name = L["Text Position"], 
						desc = L["Set the anchor for this bars value text"], 
						values = SV.PointIndexes
					},
					xOffset = {
						order = 2, 
						type = "range", 
						name = L["Text xOffset"], 
						desc = L["Offset position for text."], 
						min = -300, 
						max = 300, 
						step = 1
					}, 
					yOffset = {
						order = 3, 
						type = "range", 
						name = L["Text yOffset"], 
						desc = L["Offset position for text."], 
						min = -300, 
						max = 300, 
						step = 1
					},
					spacer1 = {
						order = 4, 
						name = "", 
						type = "description", 
						width = "full", 
					},
					reversed = {
						type = "toggle", 
						order = 5, 
						name = L["Reverse Fill"], 
						desc = L["Invert this bars fill direction"]
					}, 
				}
			}, 
			formatGroup = {
				order = 2, 
				type = "group", 
				guiInline = true, 
				name = L["Text Settings"],
				set = function(key, value)
					MOD:ChangeDBVar(value, key[#key], unitName, "formatting");
					local tag = ""
					local pc = SV.db.SVUnit[unitName]["formatting"].health_colored and "[health:color]" or "";
					tag = tag .. pc;

					local pt = SV.db.SVUnit[unitName]["formatting"].health_type;
					if(pt and pt ~= "none") then
						tag = tag .. "[health:" .. pt .. "]"
					end

					MOD:ChangeDBVar(tag, "tags", unitName, "health");
					updateFunction(MOD, unitName, count)
				end,
				args = {
					health_colored = {
						order = 1, 
						name = L["Colored"], 
						type = "toggle", 
						get = function() return SV.db.SVUnit[unitName]["formatting"].health_colored end,
						desc = L["Use various name coloring methods"]
					},
					health_type = {
						order = 3, 
						name = L["Text Format"], 
						type = "select",
						get = function() return SV.db.SVUnit[unitName]["formatting"].health_type end,
						desc = L["TEXT_FORMAT_DESC"], 
						values = textStringFormats, 
					}
				}
			},
			colorGroup = {
				order = 3, 
				type = "group", 
				guiInline = true, 
				name = L["Color Settings"],
				args = {
					classColor = {
						order = 1, 
						type = "toggle", 
						name = L["Class Health"], 
						desc = L["Color health by classcolor or reaction."],
					}, 
					valueColor = {
						order = 2, 
						type = "toggle", 
						name = L["Health By Value"], 
						desc = L["Color health by amount remaining."],
					},
					classBackdrop = {
						order = 3, 
						type = "toggle", 
						name = L["Class Backdrop"], 
						desc = L["Color the health backdrop by class or reaction."],
					},
					configureButton = {
						order = 4, 
						name = L["Coloring"], 
						type = "execute", 
						width = 'full',
						func = function() ACD:SelectGroup(SV.NameID, "SVUnit", "common", "allColorsGroup", "healthGroup") end
					},
				} 
			}
		}
	}
	if partyRaid then 
		healthOptions.args.commonGroup.args.frequentUpdates = {
			type = "toggle", 
			order = 6, 
			name = L["Frequent Updates"], 
			desc = L["Rapidly update the health, uses more memory and cpu. Only recommended for healing."]
		}
		healthOptions.args.commonGroup.args.orientation = {
			type = "select", 
			order = 7, 
			name = L["Orientation"], 
			desc = L["Direction the health bar moves when gaining/losing health."], 
			values = {["HORIZONTAL"] = L["Horizontal"], ["VERTICAL"] = L["Vertical"]}
		}
	end 
	return healthOptions 
end 

function ns:SetPowerConfigGroup(playerTarget, updateFunction, unitName, count)
	local powerOptions = {
		order = 200, 
		type = "group", 
		name = L["Power"],
		get = function(key) 
			return SV.db.SVUnit[unitName]["power"][key[#key]] 
		end, 
		set = function(key, value)
			MOD:ChangeDBVar(value, key[#key], unitName, "power");
			updateFunction(MOD, unitName, count)
		end,
		args = {
			enable = {type = "toggle", order = 1, name = L["Power Bar Enabled"]}, 
			commonGroup = {
				order = 2, 
				type = "group", 
				guiInline = true, 
				name = L["Base Settings"],
				args = { 
					position = {
						type = "select", 
						order = 1, 
						name = L["Text Position"], 
						desc = L["Set the anchor for this bars value text"], 
						values = SV.PointIndexes
					},
					xOffset = {
						order = 2, 
						type = "range", 
						name = L["Text xOffset"], 
						desc = L["Offset position for text."], 
						min = -300, 
						max = 300, 
						step = 1
					}, 
					yOffset = {
						order = 3, 
						type = "range", 
						name = L["Text yOffset"], 
						desc = L["Offset position for text."], 
						min = -300, 
						max = 300, 
						step = 1
					},
					height = {
						type = "range", 
						name = L["Height"], 
						order = 4,  
						min = 3, 
						max = 50, 
						step = 1
					},
				}
			}, 
			formatGroup = {
				order = 3, 
				type = "group", 
				guiInline = true, 
				name = L["Text Settings"],
				set = function(key, value)
					MOD:ChangeDBVar(value, key[#key], unitName, "formatting");
					local tag = ""
					local cp = SV.db.SVUnit[unitName]["formatting"].power_class and "[classpower]" or "";
					tag = tag .. cp;
					local ap = SV.db.SVUnit[unitName]["formatting"].power_alt and "[altpower]" or "";
					tag = tag .. ap;
					local pc = SV.db.SVUnit[unitName]["formatting"].power_colored and "[power:color]" or "";
					tag = tag .. pc;

					local pt = SV.db.SVUnit[unitName]["formatting"].power_type;
					if(pt and pt ~= "none") then
						tag = tag .. "[power:" .. pt .. "]"
					end

					MOD:ChangeDBVar(tag, "tags", unitName, "power");
					updateFunction(MOD, unitName, count)
				end,
				args = {
					power_colored = {
						order = 1, 
						name = L["Colored"], 
						type = "toggle", 
						get = function() return SV.db.SVUnit[unitName]["formatting"].power_colored end,
						desc = L["Use various name coloring methods"]
					},
					power_class = {
						order = 1, 
						name = L["Show Class Power"], 
						type = "toggle", 
						get = function() return SV.db.SVUnit[unitName]["formatting"].power_class end,
					},
					power_alt = {
						order = 1, 
						name = L["Show Alt Power"], 
						type = "toggle", 
						get = function() return SV.db.SVUnit[unitName]["formatting"].power_alt end,
					},
					power_type = {
						order = 3, 
						name = L["Text Format"], 
						type = "select",
						get = function() return SV.db.SVUnit[unitName]["formatting"].power_type end,
						desc = L["TEXT_FORMAT_DESC"], 
						values = textStringFormats, 
					}
				}
			},
			colorGroup = {
				order = 4, 
				type = "group", 
				guiInline = true, 
				name = L["Color Settings"],
				args = {
					classColor = {
						order = 1, 
						type = "toggle", 
						name = L["Class Power"], 
						desc = L["Color power by classcolor or reaction."],
					},
					configureButton = {
						order = 2, 
						name = L["Coloring"], 
						type = "execute", 
						width = 'full',
						func = function() ACD:SelectGroup(SV.NameID, "SVUnit", "common", "allColorsGroup", "powerGroup") end
					},
				} 
			}
		}
	}

	return powerOptions 
end 

function ns:SetNameConfigGroup(updateFunction, unitName, count)
	local k = {
		order = 400, 
		type = "group", 
		name = L["Name"],
		get = function(key) 
			return SV.db.SVUnit[unitName]["name"][key[#key]] 
		end, 
		set = function(key, value)
			MOD:ChangeDBVar(value, key[#key], unitName, "name");
			updateFunction(MOD, unitName, count)
		end,
		args = {
			commonGroup = {
				order = 1, 
				type = "group", 
				guiInline = true, 
				name = L["Base Settings"], 
				args = {
					position = {
						type = "select", 
						order = 1, 
						name = L["Text Position"], 
						desc = L["Set the anchor for this units name text"], 
						values = SV.PointIndexes
					}, 
					xOffset = {
						order = 2, 
						type = "range", 
						name = L["Text xOffset"], 
						desc = L["Offset position for text."], 
						min = -300, 
						max = 300, 
						step = 1
					}, 
					yOffset = {
						order = 3, 
						type = "range",
						name = L["Text yOffset"], 
						desc = L["Offset position for text."], 
						min = -300, 
						max = 300, 
						step = 1
					}, 
				}
			}, 
			fontGroup = {
				order = 4, 
				type = "group", 
				guiInline = true, 
				name = L["Fonts"],
				set = function(key, value)
					MOD:ChangeDBVar(value, key[#key], unitName, "name");
					MOD:RefreshAllUnitMedia()
				end,
				args = {
					font = {
						type = "select", 
						dialogControl = "LSM30_Font", 
						order = 0, 
						name = L["Default Font"], 
						desc = L["The font used to show unit names."], 
						values = AceGUIWidgetLSMlists.font
					}, 
					fontOutline = {
						order = 1, 
						name = L["Font Outline"], 
						desc = L["Set the font outline."], 
						type = "select", 
						values = {["NONE"] = L["None"], ["OUTLINE"] = "OUTLINE", ["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE", ["THICKOUTLINE"] = "THICKOUTLINE"}
					}, 
					fontSize = {
						order = 2, 
						name = L["Font Size"], 
						desc = L["Set the font size."], 
						type = "range", 
						min = 6, 
						max = 22, 
						step = 1
					}
				}
			}, 
			formatGroup = {
				order = 100, 
				type = "group", 
				guiInline = true, 
				name = L["Text Settings"],
				set = function(key, value)
					MOD:ChangeDBVar(value, key[#key], unitName, "formatting");
					local tag = ""
					tag = SV.db.SVUnit[unitName]["formatting"].name_colored and "[name:color]" or "";
					
					local length = SV.db.SVUnit[unitName]["formatting"].name_length;
					tag = tag .. "[name:" .. length .. "]"
					local lvl = SV.db.SVUnit[unitName]["formatting"].smartlevel and "[smartlevel]" or "";
					tag = tag .. lvl

					MOD:ChangeDBVar(tag, "tags", unitName, "name");
					updateFunction(MOD, unitName, count)
				end,
				args = {
					name_colored = {
						order = 1, 
						name = L["Colored"], 
						type = "toggle", 
						get = function() return SV.db.SVUnit[unitName]["formatting"].name_colored end,
						desc = L["Use various name coloring methods"]
					},
					smartlevel = {
						order = 2, 
						name = L["Unit Level"], 
						type = "toggle", 
						get = function() return SV.db.SVUnit[unitName]["formatting"].smartlevel end,
						desc = L["Display the units level"]
					}, 
					name_length = {
						order = 3, 
						name = L["Name Length"],
						desc = L["TEXT_FORMAT_DESC"], 
						type = "range", 
						get = function() return SV.db.SVUnit[unitName]["formatting"].name_length end,
						min = 1, 
						max = 30, 
						step = 1
					}
				}
			}
		}
	}
	return k 
end 

local portraitStyles = {["2D"] = L["2D"], ["3D"] = L["3D"], ["3DOVERLAY"] = L["3D Overlay"]};

function ns:SetPortraitConfigGroup(updateFunction, unitName, count)
	local k = {
		order = 400, 
		type = "group", 
		name = L["Portrait"],
		get = function(key)
			return SV.db.SVUnit[unitName]["portrait"][key[#key]]
		end,
		set = function(key, value)
			MOD:ChangeDBVar(value, key[#key], unitName, "portrait")
			updateFunction(MOD, unitName, count)
		end,
		args = {
			enable = {
				type = "toggle", 
				order = 1, 
				name = L["Unit Portrait Enabled"]
			},
			styleGroup = {
				order = 2, 
				type = "group", 
				guiInline = true,
				name = L["Base Settings"], 
				args = {
					style = {
						order = 1,
						type = "select", 
						name = L["Style"], 
						desc = L["Select the display method of the portrait. NOTE: if overlay is set then only 3D will be available"], 
						values = portraitStyles
					},
					width = {
						order = 2, 
						type = "range", 
						name = L["Width"], 
						min = 15, 
						max = 150, 
						step = 1,
						disabled = function() return SV.db.SVUnit[unitName]["portrait"].style == "3DOVERLAY" end
					}
				}
			},
			modGroup = {
				order = 3, 
				type = "group", 
				guiInline = true,
				name = L["3D Settings"],
				disabled = function() return SV.db.SVUnit[unitName]["portrait"].style == "2D" end,
				args = {
					rotation = {
						order = 1, 
						type = "range", 
						name = L["Model Rotation"], 
						min = 0, 
						max = 360, 
						step = 1
					}, 
					camDistanceScale = {
						order = 2, 
						type = "range", 
						name = L["Camera Distance Scale"], 
						desc = L["How far away the portrait is from the camera."], 
						min = 0.01, 
						max = 4, 
						step = 0.01
					}, 
				}
			}
		}
	}
	return k 
end 

function ns:SetIconConfigGroup(updateFunction, unitName, count)
	local iconGroup = SV.db.SVUnit[unitName]["icons"]
	local grouporder = 1
	local k = {
		order = 5000, 
		type = "group", 
		name = L["Icons"], 
		get = function(key)
			return SV.db.SVUnit[unitName]["icons"][key[#key]]
		end,
		set = function(key, value)
			MOD:ChangeDBVar(value, key[#key], unitName, "icons")
			updateFunction(MOD, unitName, count)
		end,
		args = {}
	};

	if(iconGroup["classIcon"]) then
		k.args.classIcon = {
			order = grouporder, 
			type = "group",
			guiInline = true,
			name = L["Class Icons"],
			get = function(key)
				return SV.db.SVUnit[unitName]["icons"]["classIcon"][key[#key]]
			end,
			set = function(key, value)
				MOD:ChangeDBVar(value, key[#key], unitName, "icons", "classIcon")
				updateFunction(MOD, unitName, count)
			end,
			args = {
				enable = {type = "toggle", order = 1, name = L["Enable"]}, 
				attachTo = {type = "select", order = 2, name = L["Position"], values = SV.PointIndexes},
				spacer = { order = 3, name = "", type = "description", width = "full"},
				size = {type = "range", name = L["Size"], order = 3, min = 8, max = 60, step = 1}, 
				xOffset = {order = 4, type = "range", name = L["xOffset"], min = -300, max = 300, step = 1}, 
				yOffset = {order = 5, type = "range", name = L["yOffset"], min = -300, max = 300, step = 1}
			}
		}
		grouporder = grouporder + 1
	end

	if(iconGroup["raidicon"]) then
		k.args.raidicon = {
			order = grouporder, 
			type = "group",
			guiInline = true,
			name = L["Raid Marker"],
			get = function(key)
				return SV.db.SVUnit[unitName]["icons"]["raidicon"][key[#key]]
			end,
			set = function(key, value)
				MOD:ChangeDBVar(value, key[#key], unitName, "icons", "raidicon")
				updateFunction(MOD, unitName, count)
			end,
			args = {
				enable = {type = "toggle", order = 1, name = L["Enable"]}, 
				attachTo = {type = "select", order = 2, name = L["Position"], values = SV.PointIndexes},
				spacer = { order = 3, name = "", type = "description", width = "full"}, 
				size = {type = "range", name = L["Size"], order = 3, min = 8, max = 60, step = 1}, 
				xOffset = {order = 4, type = "range", name = L["xOffset"], min = -300, max = 300, step = 1}, 
				yOffset = {order = 5, type = "range", name = L["yOffset"], min = -300, max = 300, step = 1}
			}
		}
		grouporder = grouporder + 1
	end

	if(iconGroup["combatIcon"]) then
		k.args.combatIcon = {
			order = grouporder, 
			type = "group",
			guiInline = true,
			name = L["Combat"],
			get = function(key)
				return SV.db.SVUnit[unitName]["icons"]["combatIcon"][key[#key]]
			end,
			set = function(key, value)
				MOD:ChangeDBVar(value, key[#key], unitName, "icons", "combatIcon")
				updateFunction(MOD, unitName, count)
			end,
			args = {
				enable = {type = "toggle", order = 1, name = L["Enable"]}, 
				attachTo = {type = "select", order = 2, name = L["Position"], values = SV.PointIndexes},
				spacer = { order = 3, name = "", type = "description", width = "full"},
				size = {type = "range", name = L["Size"], order = 3, min = 8, max = 60, step = 1}, 
				xOffset = {order = 4, type = "range", name = L["xOffset"], min = -300, max = 300, step = 1}, 
				yOffset = {order = 5, type = "range", name = L["yOffset"], min = -300, max = 300, step = 1}
			}
		}
		grouporder = grouporder + 1
	end

	if(iconGroup["restIcon"]) then
		k.args.restIcon = {
			order = grouporder, 
			type = "group",
			guiInline = true,
			name = L["Resting"],
			get = function(key)
				return SV.db.SVUnit[unitName]["icons"]["restIcon"][key[#key]]
			end,
			set = function(key, value)
				MOD:ChangeDBVar(value, key[#key], unitName, "icons", "restIcon")
				updateFunction(MOD, unitName, count)
			end,
			args = {
				enable = {type = "toggle", order = 1, name = L["Enable"]}, 
				attachTo = {type = "select", order = 2, name = L["Position"], values = SV.PointIndexes},
				spacer = { order = 3, name = "", type = "description", width = "full"},
				size = {type = "range", name = L["Size"], order = 3, min = 8, max = 60, step = 1}, 
				xOffset = {order = 4, type = "range", name = L["xOffset"], min = -300, max = 300, step = 1}, 
				yOffset = {order = 5, type = "range", name = L["yOffset"], min = -300, max = 300, step = 1}
			}
		}
		grouporder = grouporder + 1
	end

	if(iconGroup["classicon"]) then
		k.args.classicon = {
			order = grouporder, 
			type = "group",
			guiInline = true,
			name = L["Class"],
			get = function(key)
				return SV.db.SVUnit[unitName]["icons"]["classicon"][key[#key]]
			end,
			set = function(key, value)
				MOD:ChangeDBVar(value, key[#key], unitName, "icons", "classicon")
				updateFunction(MOD, unitName, count)
			end,
			args = {
				enable = {type = "toggle", order = 1, name = L["Enable"]}, 
				attachTo = {type = "select", order = 2, name = L["Position"], values = SV.PointIndexes},
				spacer = { order = 3, name = "", type = "description", width = "full"},
				size = {type = "range", name = L["Size"], order = 3, min = 8, max = 60, step = 1}, 
				xOffset = {order = 4, type = "range", name = L["xOffset"], min = -300, max = 300, step = 1}, 
				yOffset = {order = 5, type = "range", name = L["yOffset"], min = -300, max = 300, step = 1}
			}
		}
		grouporder = grouporder + 1
	end

	if(iconGroup["eliteicon"]) then
		k.args.eliteicon = {
			order = grouporder, 
			type = "group",
			guiInline = true,
			name = L["Elite / Rare"],
			get = function(key)
				return SV.db.SVUnit[unitName]["icons"]["eliteicon"][key[#key]]
			end,
			set = function(key, value)
				MOD:ChangeDBVar(value, key[#key], unitName, "icons", "eliteicon")
				updateFunction(MOD, unitName, count)
			end,
			args = {
				enable = {type = "toggle", order = 1, name = L["Enable"]}, 
				attachTo = {type = "select", order = 2, name = L["Position"], values = SV.PointIndexes},
				spacer = { order = 3, name = "", type = "description", width = "full"},
				size = {type = "range", name = L["Size"], order = 3, min = 8, max = 60, step = 1}, 
				xOffset = {order = 4, type = "range", name = L["xOffset"], min = -300, max = 300, step = 1}, 
				yOffset = {order = 5, type = "range", name = L["yOffset"], min = -300, max = 300, step = 1}
			}
		}
		grouporder = grouporder + 1
	end

	if(iconGroup["roleIcon"]) then
		k.args.roleIcon = {
			order = grouporder, 
			type = "group",
			guiInline = true,
			name = L["Role"],
			get = function(key)
				return SV.db.SVUnit[unitName]["icons"]["roleIcon"][key[#key]]
			end,
			set = function(key, value)
				MOD:ChangeDBVar(value, key[#key], unitName, "icons", "roleIcon")
				updateFunction(MOD, unitName, count)
			end,
			args = {
				enable = {type = "toggle", order = 1, name = L["Enable"]}, 
				attachTo = {type = "select", order = 2, name = L["Position"], values = SV.PointIndexes},
				spacer = { order = 3, name = "", type = "description", width = "full"},
				size = {type = "range", name = L["Size"], order = 3, min = 8, max = 60, step = 1}, 
				xOffset = {order = 4, type = "range", name = L["xOffset"], min = -300, max = 300, step = 1}, 
				yOffset = {order = 5, type = "range", name = L["yOffset"], min = -300, max = 300, step = 1}
			}
		}
		grouporder = grouporder + 1
	end

	if(iconGroup["raidRoleIcons"]) then
		k.args.raidRoleIcons = {
			order = grouporder, 
			type = "group",
			guiInline = true,
			name = L["Leader / MasterLooter"],
			get = function(key)
				return SV.db.SVUnit[unitName]["icons"]["raidRoleIcons"][key[#key]]
			end,
			set = function(key, value)
				MOD:ChangeDBVar(value, key[#key], unitName, "icons", "raidRoleIcons")
				updateFunction(MOD, unitName, count)
			end,
			args = {
				enable = {type = "toggle", order = 1, name = L["Enable"]}, 
				attachTo = {type = "select", order = 2, name = L["Position"], values = SV.PointIndexes},
				spacer = { order = 3, name = "", type = "description", width = "full"},
				size = {type = "range", name = L["Size"], order = 3, min = 8, max = 60, step = 1}, 
				xOffset = {order = 4, type = "range", name = L["xOffset"], min = -300, max = 300, step = 1}, 
				yOffset = {order = 5, type = "range", name = L["yOffset"], min = -300, max = 300, step = 1}
			}
		}
		grouporder = grouporder + 1
	end

	return k 
end

local BoolFilters = {
	['player'] = true,
	['pet'] = true,
	['boss'] = true,
	['arena'] = true,
	['party'] = true,
	['raid'] = true,
	['raidpet'] = true,	
};

local function setAuraFilteringOptions(configTable, unitName, auraType, updateFunction, isPlayer)
	if BoolFilters[unitName] then
		configTable.filterGroup = {
			order = 18, 
			guiInline = true, 
			type = "group", 
			name = L["Aura filtering..."], 
			args = {
				filterWhiteList = {
					order = 1, 
					type = "toggle", 
					name = L["Only White Listed"], 
					desc = L["Only show auras that are on the whitelist."], 
					get = function(key)return SV.db.SVUnit[unitName][auraType].filterWhiteList end, 
					set = function(key, value)
						SV.db.SVUnit[unitName][auraType].filterWhiteList = value; 
						if(value) then
							SV.db.SVUnit[unitName][auraType].filterPlayer = false;
							SV.db.SVUnit[unitName][auraType].filterDispellable = false;
							SV.db.SVUnit[unitName][auraType].filterInfinite = false;
							SV.db.SVUnit[unitName][auraType].filterRaid = false;
						end
						updateFunction(MOD, unitName)
					end,
				},
				filterPlayer = {
					order = 2, 
					type = "toggle", 
					name = L["From You"], 
					desc = L["Only show auras that were cast by you."],
					get = function(key) return SV.db.SVUnit[unitName][auraType].filterPlayer end,
					set = function(key, value) SV.db.SVUnit[unitName][auraType].filterPlayer = value; updateFunction(MOD, unitName) end,
					disabled = function() return SV.db.SVUnit[unitName][auraType].filterWhiteList end,
				},
				filterDispellable = {
					order = 3, 
					type = "toggle", 
					name = L["You Can Remove"], 
					desc = L["Only show auras that can be removed by you. (example: Purge, Dispel)"],
					get = function(key) return SV.db.SVUnit[unitName][auraType].filterDispellable end,
					set = function(key, value) SV.db.SVUnit[unitName][auraType].filterDispellable = value; updateFunction(MOD, unitName) end,
					disabled = function() return SV.db.SVUnit[unitName][auraType].filterWhiteList end,
				},
				filterInfinite = {
					order = 4, 
					type = "toggle", 
					name = L["No Duration"], 
					desc = L["Don't display auras that have no duration."],
					get = function(key) return SV.db.SVUnit[unitName][auraType].filterInfinite end,
					set = function(key, value) SV.db.SVUnit[unitName][auraType].filterInfinite = value; updateFunction(MOD, unitName) end,
					disabled = function() return SV.db.SVUnit[unitName][auraType].filterWhiteList end,
				},
				filterRaid = {
					order = 5, 
					type = "toggle", 
					name = L["Consolidated Buffs"], 
					desc = L["Don't display consolidated buffs"],
					get = function(key) return SV.db.SVUnit[unitName][auraType].filterRaid end,
					set = function(key, value) SV.db.SVUnit[unitName][auraType].filterRaid = value; updateFunction(MOD, unitName) end,
					disabled = function() return SV.db.SVUnit[unitName][auraType].filterWhiteList end,
				},
			}
		}
	else
		configTable.friendlyGroup = {
			order = 18, 
			guiInline = true, 
			type = "group", 
			name = L["When the unit is friendly..."], 
			args = {
				filterAll = {
					order = 1, 
					type = "toggle", 
					name = L["Hide All"], 
					desc = L["Don't display any " .. auraType .. "."], 
					get = function(key) return SV.db.SVUnit[unitName][auraType].filterAll.friendly end,
					set = function(key, value)
						SV.db.SVUnit[unitName][auraType].filterAll.friendly = value;
						if(value) then
							SV.db.SVUnit[unitName][auraType].filterWhiteList.friendly = false;
							SV.db.SVUnit[unitName][auraType].filterPlayer.friendly = false;
							SV.db.SVUnit[unitName][auraType].filterDispellable.friendly = false;
							SV.db.SVUnit[unitName][auraType].filterInfinite.friendly = false;
							if(SV.db.SVUnit[unitName][auraType].filterRaid) then
								SV.db.SVUnit[unitName][auraType].filterRaid.friendly = false;
							end
						end
						updateFunction(MOD, unitName)
					end,
				},
				filterWhiteList = {
					order = 2, 
					type = "toggle", 
					name = L["Only White Listed"], 
					desc = L["Only show auras that are on the whitelist."], 
					get = function(key)return SV.db.SVUnit[unitName][auraType].filterWhiteList.friendly end, 
					set = function(key, value)SV.db.SVUnit[unitName][auraType].filterWhiteList.friendly = value; updateFunction(MOD, unitName) end,
					set = function(key, value)
						SV.db.SVUnit[unitName][auraType].filterWhiteList.friendly = value;
						if(value) then
							SV.db.SVUnit[unitName][auraType].filterPlayer.friendly = false;
							SV.db.SVUnit[unitName][auraType].filterDispellable.friendly = false;
							SV.db.SVUnit[unitName][auraType].filterInfinite.friendly = false;
							if(SV.db.SVUnit[unitName][auraType].filterRaid) then
								SV.db.SVUnit[unitName][auraType].filterRaid.friendly = false;
							end
						end
						updateFunction(MOD, unitName)
					end,
					disabled = function() 
						return SV.db.SVUnit[unitName][auraType].filterAll.friendly
					end,
				},
				filterPlayer = {
					order = 3, 
					type = "toggle", 
					name = L["From You"], 
					desc = L["Only show auras that were cast by you."], 
					get = function(key)return SV.db.SVUnit[unitName][auraType].filterPlayer.friendly end, 
					set = function(key, value)SV.db.SVUnit[unitName][auraType].filterPlayer.friendly = value; updateFunction(MOD, unitName) end,
					disabled = function() 
						return (SV.db.SVUnit[unitName][auraType].filterAll.friendly or SV.db.SVUnit[unitName][auraType].filterWhiteList.friendly)
					end,
				},
				filterDispellable = {
					order = 4, 
					type = "toggle", 
					name = L["You Can Remove"], 
					desc = L["Only show auras that can be removed by you. (example: Purge, Dispel)"], 
					get = function(key)return SV.db.SVUnit[unitName][auraType].filterDispellable.friendly end, 
					set = function(key, value)SV.db.SVUnit[unitName][auraType].filterDispellable.friendly = value; updateFunction(MOD, unitName) end,
					disabled = function() 
						return (SV.db.SVUnit[unitName][auraType].filterAll.friendly or SV.db.SVUnit[unitName][auraType].filterWhiteList.friendly)
					end,
				},
				filterInfinite = {
					order = 5, 
					type = "toggle", 
					name = L["No Duration"], 
					desc = L["Don't display auras that have no duration."], 
					get = function(key)return SV.db.SVUnit[unitName][auraType].filterInfinite.friendly end, 
					set = function(key, value)SV.db.SVUnit[unitName][auraType].filterInfinite.friendly = value; updateFunction(MOD, unitName) end,
					disabled = function() 
						return (SV.db.SVUnit[unitName][auraType].filterAll.friendly or SV.db.SVUnit[unitName][auraType].filterWhiteList.friendly)
					end,
				},
			},
		}
		configTable.enemyGroup = {
			order = 19, 
			guiInline = true, 
			type = "group", 
			name = L["When the unit is hostile..."], 
			args = {
				filterAll = {
					order = 1, 
					type = "toggle", 
					name = L["Hide All"], 
					desc = L["Don't display any " .. auraType .. "."], 
					get = function(key)return SV.db.SVUnit[unitName][auraType].filterAll.enemy end, 
					set = function(key, value)
						SV.db.SVUnit[unitName][auraType].filterAll.enemy = value;
						if(value) then
							SV.db.SVUnit[unitName][auraType].filterWhiteList.enemy = false;
							SV.db.SVUnit[unitName][auraType].filterPlayer.enemy = false;
							SV.db.SVUnit[unitName][auraType].filterDispellable.enemy = false;
							SV.db.SVUnit[unitName][auraType].filterInfinite.enemy = false;
							if(SV.db.SVUnit[unitName][auraType].filterRaid) then
								SV.db.SVUnit[unitName][auraType].filterRaid.enemy = false;
							end
						end
						updateFunction(MOD, unitName)
					end,
				},
				filterWhiteList = {
					order = 2, 
					type = "toggle", 
					name = L["Only White Listed"], 
					desc = L["Only show auras that are on the whitelist."], 
					get = function(key)return SV.db.SVUnit[unitName][auraType].filterPlayer.enemy end, 
					set = function(key, value)
						SV.db.SVUnit[unitName][auraType].filterWhiteList.enemy = value;
						if(value) then
							SV.db.SVUnit[unitName][auraType].filterPlayer.enemy = false;
							SV.db.SVUnit[unitName][auraType].filterDispellable.enemy = false;
							SV.db.SVUnit[unitName][auraType].filterInfinite.enemy = false;
							if(SV.db.SVUnit[unitName][auraType].filterRaid) then
								SV.db.SVUnit[unitName][auraType].filterRaid.enemy = false;
							end
						end
						updateFunction(MOD, unitName)
					end,
					disabled = function() 
						return SV.db.SVUnit[unitName][auraType].filterAll.enemy
					end,
				},
				filterPlayer = {
					order = 3, 
					type = "toggle", 
					name = L["From You"], 
					desc = L["Only show auras that were cast by you."], 
					get = function(key)return SV.db.SVUnit[unitName][auraType].filterPlayer.enemy end, 
					set = function(key, value)SV.db.SVUnit[unitName][auraType].filterPlayer.enemy = value; updateFunction(MOD, unitName) end,
					disabled = function() 
						return (SV.db.SVUnit[unitName][auraType].filterAll.enemy or SV.db.SVUnit[unitName][auraType].filterWhiteList.enemy)
					end,
				},
				filterDispellable = {
					order = 4, 
					type = "toggle", 
					name = L["You Can Remove"], 
					desc = L["Only show auras that can be removed by you. (example: Purge, Dispel)"], 
					get = function(key)return SV.db.SVUnit[unitName][auraType].filterDispellable.enemy end, 
					set = function(key, value)SV.db.SVUnit[unitName][auraType].filterDispellable.enemy = value; updateFunction(MOD, unitName) end,
					disabled = function() 
						return (SV.db.SVUnit[unitName][auraType].filterAll.enemy or SV.db.SVUnit[unitName][auraType].filterWhiteList.enemy)
					end,
				},
				filterInfinite = {
					order = 5, 
					type = "toggle", 
					name = L["No Duration"], 
					desc = L["Don't display auras that have no duration."], 
					get = function(key)return SV.db.SVUnit[unitName][auraType].filterInfinite.enemy end, 
					set = function(key, value)SV.db.SVUnit[unitName][auraType].filterInfinite.enemy = value; updateFunction(MOD, unitName) end,
					disabled = function() 
						return (SV.db.SVUnit[unitName][auraType].filterAll.enemy or SV.db.SVUnit[unitName][auraType].filterWhiteList.enemy)
					end,
				},
			},
		}

		if(SV.db.SVUnit[unitName][auraType].filterRaid) then
			configTable.friendlyGroup.args.filterRaid = {
				order = 6, 
				type = "toggle", 
				name = L["Consolidated Buffs"], 
				desc = L["Don't display consolidated buffs"],
				get = function(key)return SV.db.SVUnit[unitName][auraType].filterRaid.friendly end, 
				set = function(key, value)SV.db.SVUnit[unitName][auraType].filterRaid.friendly = value; updateFunction(MOD, unitName) end,
				disabled = function() 
					return (SV.db.SVUnit[unitName][auraType].filterAll.friendly or SV.db.SVUnit[unitName][auraType].filterWhiteList.friendly)
				end,
			};
			configTable.enemyGroup.args.filterRaid = {
				order = 6, 
				type = "toggle", 
				name = L["Consolidated Buffs"], 
				desc = L["Don't display consolidated buffs"],
				get = function(key)return SV.db.SVUnit[unitName][auraType].filterRaid.enemy end, 
				set = function(key, value)SV.db.SVUnit[unitName][auraType].filterRaid.enemy = value; updateFunction(MOD, unitName) end,
				disabled = function() 
					return (SV.db.SVUnit[unitName][auraType].filterAll.enemy or SV.db.SVUnit[unitName][auraType].filterWhiteList.enemy)
				end,
			};
		end
	end
end

function ns:SetAuraConfigGroup(isPlayer, auraType, unused, updateFunction, unitName, count)
	local groupOrder = auraType == "buffs" and 600 or 700
	local groupName = auraType == "buffs" and L["Buffs"] or L["Debuffs"]
	local attachToValue, attachToName;
	if auraType == "buffs"then 
		attachToValue = "DEBUFFS"
		attachToName = L["Debuffs"]
	else
		attachToValue = "BUFFS"
		attachToName = L["Buffs"]
	end

	local configTable = {
		order = groupOrder, 
		name = groupName,
		type = "group", 
		get = function(key)
			return SV.db.SVUnit[unitName][auraType][key[#key]]
		end,
		set = function(key, value)
			MOD:ChangeDBVar(value, key[#key], unitName, auraType)
			updateFunction(MOD, unitName, count)
		end,  
		args = {
			enable = {
				type = "toggle", 
				order = 2, 
				name = L["Enable "..groupName]
			},
			attachTo1 = {
				type = "toggle", 
				order = 3, 
				name = L["Attach To"] .. " " .. L["Frame"], 
				get = function(key)
					return SV.db.SVUnit[unitName][auraType]["attachTo"] == "FRAME"
				end,
				set = function(key, value)
					if(not value) then
						MOD:ChangeDBVar(attachToValue, "attachTo", unitName, auraType)
					else
						MOD:ChangeDBVar("FRAME", "attachTo", unitName, auraType)
					end
					updateFunction(MOD, unitName, count)
				end,
			},
			attachTo2 = {
				type = "toggle", 
				order = 4, 
				name = L["Attach To"] .. " " .. attachToName,  
				get = function(key)
					return SV.db.SVUnit[unitName][auraType]["attachTo"] == attachToValue
				end,
				set = function(key, value)
					if(not value) then
						MOD:ChangeDBVar("FRAME", "attachTo", unitName, auraType)
					else
						MOD:ChangeDBVar(attachToValue, "attachTo", unitName, auraType)
					end
					updateFunction(MOD, unitName, count)
				end,
			},
			spacer1 = {
				order = 5, 
				name = "", 
				type = "description", 
				width = "full", 
			},
			anchorPoint = {
				type = "select", 
				order = 6, 
				name = L["Anchor Point"], 
				desc = L["What point to anchor to the frame you set to attach to."], 
				values = SV.PointIndexes
			},
			verticalGrowth = {
				type = "select", 
				order = 7, 
				name = L["Vertical Growth"], 
				desc = L["The vertical direction that the auras will position themselves"], 
				values = {UP = "UP", DOWN = "DOWN"}
			},
			horizontalGrowth = {
				type = "select", 
				order = 8, 
				name = L["Horizontal Growth"], 
				desc = L["The horizontal direction that the auras will position themselves"], 
				values = {LEFT = "LEFT", RIGHT = "RIGHT"}
			},
			spacer2 = {
				order = 9, 
				name = "", 
				type = "description", 
				width = "full", 
			},
			perrow = {
				type = "range", 
				order = 10, 
				name = L["Per Row"], 
				min = 1, 
				max = 20, 
				step = 1
			}, 
			numrows = {
				type = "range", 
				order = 11, 
				name = L["Num Rows"], 
				min = 1, 
				max = 4, 
				step = 1
			},
			sizeOverride = {
				type = "range", 
				order = 12, 
				name = L["Size Override"], 
				desc = L["If not set to 0 then override the size of the aura icon to this."], 
				min = 0, 
				max = 60, 
				step = 1
			},
			spacer3 = {
				order = 13, 
				name = "", 
				type = "description", 
				width = "full", 
			},
			xOffset = {
				order = 14, 
				type = "range", 
				name = L["xOffset"], 
				min = -60, 
				max = 60, 
				step = 1
			}, 
			yOffset = {
				order = 15, 
				type = "range", 
				name = L["yOffset"], 
				width = "fill", 
				min = -60, 
				max = 60, 
				step = 1
			},
			useFilter = {
				order = 16, 
				type = "select", 
				name = L["Custom Filter"], 
				desc = L["Select a custom filter to include."], 
				values = function()
					filterList = {}
					filterList[""] = NONE;
					for n in pairs(SV.filters.Custom) do 
						filterList[n] = n 
					end 
					return filterList 
				end,
				get = function(key) return SV.db.SVUnit[unitName][auraType].useFilter end,
				set = function(key, value) SV.db.SVUnit[unitName][auraType].useFilter = value; updateFunction(MOD, unitName) end,
			},
			spacer4 = {
				order = 17, 
				name = "", 
				type = "description", 
				width = "full", 
			},
		}
	}

	local unitGlobalName = FRAME_MAP[unitName];
	if(unitGlobalName) then
		configTable.args.showAuras = {
			order = 0,
			type = "execute",
			name = L["Show Auras"],
			func = function()
				local unitframe = _G[unitGlobalName];
				if unitframe.forceShowAuras then 
					unitframe.forceShowAuras = nil 
				else 
					unitframe.forceShowAuras = true 
				end 
				updateFunction(MOD, unitName, count)
			end
		}
		configTable.args.showAurasSpacer = {
			order = 1, 
			name = "", 
			type = "description", 
			width = "full", 
		}
	end

	setAuraFilteringOptions(configTable.args, unitName, auraType, updateFunction, isPlayer)
 
	return configTable 
end 

function ns:SetAurabarConfigGroup(isPlayer, updateFunction, unitName)
	local configTable = {
		order = 1100, 
		type = "group", 
		name = L["Aura Bars"],
		get = function(key)
			return SV.db.SVUnit[unitName]["aurabar"][key[#key]]
		end,
		set = function(key, value)
			MOD:ChangeDBVar(value, key[#key], unitName, "aurabar")
			updateFunction(MOD, unitName, count)
			MOD:RefreshUnitFrames()
		end,
		args = {
			enable = {
				type = "toggle", 
				order = 1, 
				name = L["Aura Bars Enabled"]
			},
			commonGroup = {
				order = 2, 
				type = "group", 
				guiInline = true, 
				name = L["Base Settings"], 
				args = { 
					configureButton1 = {
						order = 1, 
						name = L["Coloring"], 
						type = "execute", func = function() ACD:SelectGroup(SV.NameID, "SVUnit", "common", "allColorsGroup", "auraBars") end
					}, 
					configureButton2 = {
						order = 2, 
						name = L["Coloring (Specific)"], 
						type = "execute", func = function() ns:SetToFilterConfig("AuraBars") end
					},
					spacer = {
						order = 3, 
						name = "", 
						type = "description", 
						width = "full", 
					},
					attachTo = {
						type = "select", 
						order = 4, 
						name = L["Attach To"], desc = L["The object you want to attach to."], 
						values = {["FRAME"] = L["Frame"], ["DEBUFFS"] = L["Debuffs"], ["BUFFS"] = L["Buffs"]}
					},
					anchorPoint = {
						type = "select", 
						order = 5, 
						name = L["Anchor Point"], desc = L["What point to anchor to the frame you set to attach to."], values = {["ABOVE"] = L["Above"], ["BELOW"] = L["Below"]}
					},  
					height = {
						type = "range", 
						order = 6, 
						name = L["Height"], min = 6, max = 40, step = 1
					},
				}
			},
			filterGroup = {
				order = 3, 
				type = "group", 
				guiInline = true, 
				name = L["Filtering and Sorting"], 
				args = {
					sort = {
						type = "select", 
						order = 1, 
						name = L["Sort Method"], 
						values = {["TIME_REMAINING"] = L["Time Remaining"], ["TIME_REMAINING_REVERSE"] = L["Time Remaining Reverse"], ["TIME_DURATION"] = L["Duration"], ["TIME_DURATION_REVERSE"] = L["Duration Reverse"], ["NAME"] = NAME, ["NONE"] = NONE}
					},
					friendlyAuraType = {
						type = "select", 
						order = 2, 
						name = L["Friendly Aura Type"], desc = L["Set the type of auras to show when a unit is friendly."], values = {["HARMFUL"] = L["Debuffs"], ["HELPFUL"] = L["Buffs"]}
					}, 
					enemyAuraType = {
						type = "select", 
						order = 3, 
						name = L["Enemy Aura Type"], desc = L["Set the type of auras to show when a unit is a foe."], values = {["HARMFUL"] = L["Debuffs"], ["HELPFUL"] = L["Buffs"]}
					}
				}
			}
		}
	};

	setAuraFilteringOptions(configTable.args.filterGroup.args, unitName, "aurabar", updateFunction, isPlayer)

	return configTable 
end 


SV.Options.args.SVUnit = {
	type = "group", 
	name = MOD.TitleID, 
	childGroups = "tab", 
	get = function(key)
		return SV.db.SVUnit[key[#key]]
	end, 
	set = function(key, value)
		MOD:ChangeDBVar(value, key[#key]);
		MOD:RefreshUnitFrames();
	end,
	args = {
		enable = {
			order = 1, 
			type = "toggle", 
			name = L["Enable SVUI UnitFrames"], 
			get = function(l)
				return SV.db.SVUnit.enable end, 
			set = function(l, m)
				SV.db.SVUnit.enable = m;
				SV:StaticPopup_Show("RL_CLIENT")
			end
		},
		spacer1 = {
			order = 2, 
			name = "", 
			type = "description", 
			width = "full", 
		},
		spacer2 = {
			order = 3, 
			name = "", 
			type = "description", 
			width = "full", 
		},
		commonGroup = {
			order = 4, 
			type = 'group', 
			name = '', 
			childGroups = "tree", 
			disabled = function() return not SV.db.SVUnit.enable end, 
			args = {
				baseGroup = {
					order = 1, 
					type = "group", 
					name = L["General"], 
					args = {
						commonGroup = {
							order = 1, 
							type = "group", 
							guiInline = true, 
							name = L["General"], 
							args = {
								disableBlizzard = {
									order = 1, 
									name = L["Disable Blizzard"], 
									desc = L["Disables the blizzard party/raid frames."], 
									type = "toggle", 
									get = function(key)
										return SV.db.SVUnit.disableBlizzard 
									end, 
									set = function(key, value)
										MOD:ChangeDBVar(value, "disableBlizzard");
										SV:StaticPopup_Show("RL_CLIENT")
									end
								}, 
								fastClickTarget = {
									order = 2, 
									name = L["Fast Clicks"], 
									desc = L["Immediate mouse-click-targeting"], 
									type = "toggle"
								}, 
								debuffHighlighting = {
									order = 3, 
									name = L["Debuff Highlight"], 
									desc = L["Color the unit if there is a debuff that can be dispelled by your class."], 
									type = "toggle"
								},
								xrayFocus = {
									order = 4, 
									name = L["X-Ray Specs"], 
									desc = L["Use handy graphics to focus the current target, or clear the current focus"], 
									type = "toggle"
								},
								OORAlpha = {
									order = 5, 
									name = L["Range Fading"], 
									desc = L["The transparency of units that are out of range."], 
									type = "range", 
									min = 0, 
									max = 1, 
									step = 0.01, 
									set = function(key, value)
										MOD:ChangeDBVar(value, key[#key]);
									end
								},
								groupOORAlpha = {
									order = 6, 
									name = L["Group Range Fading"], 
									desc = L["The transparency of group units that are out of range."], 
									type = "range", 
									min = 0, 
									max = 1, 
									step = 0.01, 
									set = function(key, value)
										MOD:ChangeDBVar(value, key[#key]);
									end
								},
							}
						}, 
						backgroundGroup = {
							order = 2, 
							type = "group", 
							guiInline = true, 
							name = "Unit Backgrounds (3D Portraits Only)", 
							get = function(key)
								return SV.db.media.textures[key[#key]]
							end,
							set = function(key, value)
								SV.db.media.textures[key[#key]] = value
								SV:RefreshEverything(true)
							end,
							args = {
								unitlarge = {
									type = "select", 
									dialogControl = "LSM30_Background", 
									order = 2, 
									name = "Unit Background", 
									values = AceGUIWidgetLSMlists.background,
								}, 
								unitsmall = {
									type = "select", 
									dialogControl = "LSM30_Background", 
									order = 3, 
									name = "Small Unit Background", 
									values = AceGUIWidgetLSMlists.background,
								}
							}
						}, 
						barGroup = {
							order = 3, 
							type = "group", 
							guiInline = true, 
							name = L["Bars"],
							get = function(key)
								return SV.db.SVUnit[key[#key]]
							end,
							set = function(key, value)
								MOD:ChangeDBVar(value, key[#key]);
								MOD:RefreshAllUnitMedia()
							end,
							args = {
								smoothbars = {
									type = "toggle", 
									order = 1, 
									name = L["Smooth Bars"], 
									desc = L["Bars will transition smoothly."]
								}, 
								statusbar = {
									type = "select", 
									dialogControl = "LSM30_Statusbar", 
									order = 2, 
									name = L["StatusBar Texture"], 
									desc = L["Main statusbar texture."], 
									values = AceGUIWidgetLSMlists.statusbar
								},
								auraBarStatusbar = {
									type = "select", 
									dialogControl = "LSM30_Statusbar", 
									order = 3, 
									name = L["AuraBar Texture"], 
									desc = L["Main statusbar texture."], 
									values = AceGUIWidgetLSMlists.statusbar
								},
							}
						},
						fontGroup = {
							order = 4, 
							type = "group", 
							guiInline = true, 
							name = L["Fonts"],
							args = {
								fontConfigButton = {
									order = 1, 
									name = L["Set UnitFrame Fonts"], 
									type = "execute", func = function() ns:SetToFontConfig("UnitFrame") end
								},
							}
						},
						allColorsGroup = {
							order = 5, 
							type = "group", 
							guiInline = true, 
							name = L["Colors"],
							args = {
								healthGroup = {
									order = 9, 
									type = "group", guiInline = true, 
									name = HEALTH, 
									args = { 
										forceHealthColor = {
											order = 1, 
											type = "toggle", 
											name = L["Overlay Health Color"], 
											desc = L["Allow custom health colors when using portrait overlays."], 
											get = function(key)
												return SV.db.SVUnit[key[#key]]
											end, 
											set = function(key, value)
												MOD:ChangeDBVar(value, key[#key]);
												MOD:RefreshUnitFrames()
											end
										},
										overlayAnimation = {
											order = 2, 
											type = "toggle", 
											name = L["Overlay Animations"], 
											desc = L["Toggle health animations on portrait overlays."], 
											get = function(key)
												return SV.db.SVUnit[key[#key]]
											end, 
											set = function(key, value)
												MOD:ChangeDBVar(value, key[#key]);
												MOD:RefreshUnitFrames()
											end
										},
										health = {
											order = 3, 
											type = "color", 
											name = L["Health"],
											get = function(key)
												local color = SV.db.media.unitframes.health
												return color[1],color[2],color[3] 
											end,
											set = function(key, rValue, gValue, bValue)
												SV.db.media.unitframes.health = {rValue, gValue, bValue}
												MOD:RefreshAllUnitMedia()
											end, 
										}, 
										tapped = {
											order = 4, 
											type = "color", 
											name = L["Tapped"],
											get = function(key)
												local color = SV.db.media.unitframes.tapped
												return color[1],color[2],color[3] 
											end,
											set = function(key, rValue, gValue, bValue)
												SV.db.media.unitframes.tapped = {rValue, gValue, bValue}
												MOD:RefreshAllUnitMedia()
											end,
										}, 
										disconnected = {
											order = 5, 
											type = "color", 
											name = L["Disconnected"],
											get = function(key)
												local color = SV.db.media.unitframes.disconnected
												return color[1],color[2],color[3] 
											end,
											set = function(key, rValue, gValue, bValue)
												SV.db.media.unitframes.disconnected = {rValue, gValue, bValue}
												MOD:RefreshAllUnitMedia()
											end,
										}
									}
								}, 
								powerGroup = {
									order = 10, 
									type = "group", 
									guiInline = true, 
									name = L["Powers"],
									args = {
										MANA = {
											order = 1, 
											name = MANA, 
											type = "color",
											get = function(key)
												local color = SV.db.media.unitframes.power["MANA"]
												return color[1],color[2],color[3] 
											end,
											set = function(key, rValue, gValue, bValue)
												SV.db.media.unitframes.power["MANA"] = {rValue, gValue, bValue}
												MOD:RefreshAllUnitMedia()
											end, 
										}, 
										RAGE = {
											order = 2, 
											name = RAGE, 
											type = "color",
											get = function(key)
												local color = SV.db.media.unitframes.power["RAGE"]
												return color[1],color[2],color[3] 
											end,
											set = function(key, rValue, gValue, bValue)
												SV.db.media.unitframes.power["RAGE"] = {rValue, gValue, bValue}
												MOD:RefreshAllUnitMedia()
											end,
										}, 
										FOCUS = {
											order = 3, 
											name = FOCUS, 
											type = "color",
											get = function(key)
												local color = SV.db.media.unitframes.power["FOCUS"]
												return color[1],color[2],color[3] 
											end,
											set = function(key, rValue, gValue, bValue)
												SV.db.media.unitframes.power["FOCUS"] = {rValue, gValue, bValue}
												MOD:RefreshAllUnitMedia()
											end,
										}, 
										ENERGY = {
											order = 4, 
											name = ENERGY, 
											type = "color",
											get = function(key)
												local color = SV.db.media.unitframes.power["ENERGY"]
												return color[1],color[2],color[3] 
											end,
											set = function(key, rValue, gValue, bValue)
												SV.db.media.unitframes.power["ENERGY"] = {rValue, gValue, bValue}
												MOD:RefreshAllUnitMedia()
											end,
										}, 
										RUNIC_POWER = {
											order = 5, 
											name = RUNIC_POWER, 
											type = "color",
											get = function(key)
												local color = SV.db.media.unitframes.power["RUNIC_POWER"]
												return color[1],color[2],color[3] 
											end,
											set = function(key, rValue, gValue, bValue)
												SV.db.media.unitframes.power["RUNIC_POWER"] = {rValue, gValue, bValue}
												MOD:RefreshAllUnitMedia()
											end,
										}
									}
								}, 
								castBars = {
									order = 11, 
									type = "group", 
									guiInline = true, 
									name = L["Castbar"],
									args = {
										castClassColor = {
											order = 0, 
											type = "toggle", 
											name = L["Class Castbars"], 
											desc = L["Color castbars by the class or reaction type of the unit."], 
											get = function(key)
												return SV.db.SVUnit[key[#key]]
											end, 
											set = function(key, value)
												MOD:ChangeDBVar(value, key[#key]);
												MOD:RefreshUnitFrames()
											end
										}, 
										casting = {
											order = 3, 
											name = L["Interruptable"], 
											type = "color",
											get = function(key)
												local color = SV.db.media.unitframes.casting
												return color[1],color[2],color[3] 
											end,
											set = function(key, rValue, gValue, bValue)
												SV.db.media.unitframes.casting = {rValue, gValue, bValue}
												MOD:RefreshAllUnitMedia()
											end,
										}, 
										spark = {
											order = 4, 
											name = "Spark Color", 
											type = "color",
											get = function(key)
												local color = SV.db.media.unitframes.spark
												return color[1],color[2],color[3] 
											end,
											set = function(key, rValue, gValue, bValue)
												SV.db.media.unitframes.spark = {rValue, gValue, bValue}
												MOD:RefreshAllUnitMedia()
											end,
										}, 
										interrupt = {
											order = 5, 
											name = L["Non-Interruptable"], 
											type = "color",
											get = function(key)
												local color = SV.db.media.unitframes.interrupt
												return color[1],color[2],color[3] 
											end,
											set = function(key, rValue, gValue, bValue)
												SV.db.media.unitframes.interrupt = {rValue, gValue, bValue}
												MOD:RefreshAllUnitMedia()
											end,
										}
									}
								}, 
								auraBars = {
									order = 11, 
									type = "group", 
									guiInline = true, 
									name = L["Aura Bars"], 
									args = {
										auraBarByType = {
											order = 1, 
											name = L["By Type"], 
											desc = L["Color aurabar debuffs by type."], 
											type = "toggle",
											get = function(key)
												return SV.db.SVUnit[key[#key]]
											end, 
											set = function(key, value)
												MOD:ChangeDBVar(value, key[#key]);
												MOD:RefreshUnitFrames()
											end
										}, 
										auraBarShield = {
											order = 2, 
											name = L["Color Shield Buffs"], 
											desc = L["Color all buffs that reduce incoming damage."], 
											type = "toggle",
											get = function(key)
												return SV.db.SVUnit[key[#key]]
											end, 
											set = function(key, value)
												MOD:ChangeDBVar(value, key[#key]);
												MOD:RefreshUnitFrames()
											end
										}, 
										buff_bars = {
											order = 10, 
											name = L["Buffs"], 
											type = "color",
											get = function(key)
												local color = SV.db.media.unitframes.buff_bars
												return color[1],color[2],color[3] 
											end,
											set = function(key, rValue, gValue, bValue)
												SV.db.media.unitframes.buff_bars = {rValue, gValue, bValue}
												MOD:RefreshAllUnitMedia()
											end,
										}, 
										debuff_bars = {
											order = 11, 
											name = L["Debuffs"], 
											type = "color",
											get = function(key)
												local color = SV.db.media.unitframes.debuff_bars
												return color[1],color[2],color[3] 
											end,
											set = function(key, rValue, gValue, bValue)
												SV.db.media.unitframes.debuff_bars = {rValue, gValue, bValue}
												MOD:RefreshAllUnitMedia()
											end,
										}, 
										shield_bars = {
											order = 12, 
											name = L["Shield Buffs Color"], 
											type = "color",
											get = function(key)
												local color = SV.db.media.unitframes.shield_bars
												return color[1],color[2],color[3] 
											end,
											set = function(key, rValue, gValue, bValue)
												SV.db.media.unitframes.shield_bars = {rValue, gValue, bValue}
												MOD:RefreshAllUnitMedia()
											end,
										}
									}
								}, 
								predict = {
									order = 12, 
									name = L["Heal Prediction"], 
									type = "group",
									args = {
										personal = {
											order = 1, 
											name = L["Personal"], 
											type = "color", 
											hasAlpha = true,
											get = function(key)
												local color = SV.db.media.unitframes.predict["personal"]
												return color[1],color[2],color[3] 
											end,
											set = function(key, rValue, gValue, bValue)
												SV.db.media.unitframes.predict["personal"] = {rValue, gValue, bValue}
												MOD:RefreshUnitFrames()
											end,
										}, 
										others = {
											order = 2, 
											name = L["Others"], 
											type = "color", 
											hasAlpha = true,
											get = function(key)
												local color = SV.db.media.unitframes.predict["others"]
												return color[1],color[2],color[3] 
											end,
											set = function(key, rValue, gValue, bValue)
												SV.db.media.unitframes.predict["others"] = {rValue, gValue, bValue}
												MOD:RefreshUnitFrames()
											end,
										}, 
										absorbs = {
											order = 2, 
											name = L["Absorbs"], 
											type = "color", 
											hasAlpha = true,
											get = function(key)
												local color = SV.db.media.unitframes.predict["absorbs"]
												return color[1],color[2],color[3] 
											end,
											set = function(key, rValue, gValue, bValue)
												SV.db.media.unitframes.predict["absorbs"] = {rValue, gValue, bValue}
												MOD:RefreshUnitFrames()
											end,
										}
									}
								}
							}
						}
					}
				},
			},
		}
	},
}