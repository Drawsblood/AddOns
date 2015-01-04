vexpower.defaults.parameter = {
	["profile"] = "",
	["specProfile"] = {
		["activate"] = false,
		["specAProfile"] = "",
		["specBProfile"] = "",
		},
	}
	
vexpower.defaults.singleProfile = {
	["data"] = {
		["advancedOptions"] = false,
		["blizzhide"] = {
			["chi"] = true,
			["holypower"] = true,
			["cps"] = true,
			["lockShards"] = true,
			},
		["show"] = {
			["fadeOutTime"] = 1,
			["infightdelay"] = 0,
			["enableAddon"] = true, 
			["fadeoutEffect"] = true, 
			},
		["classSpec"] = {
			["rogue"] = {
				["cps"] = true,
				["anticipation"] = true,
				["anti2ndRow"] = true,
				["antiRowHeight"] = 15,
				["antiRowYDistance"] = 10,
				["keepCPShown"] = true,
				},
			["paladin"] = { ["cps"] = true, },
			["druid"] = {
				["cps"] = true, 
				["keepCPShown"] = true,
				},
			["monk"] = { ["cps"] = true, },
			["hunter"] = {
			--	["mm"] = true,
				["bm"] = true,
				},
			["warrior"] = { ["fury"] = true, },
			["shaman"] = { ["enhancer"] = true, },
			["priest"] = {
				["shadow"] = true,
				["disci"] = true,
				},
			["warlock"] = {
				["affli"] = true,
				["demo"] = true,
				["destro"] = true,
				},
			["mage"] = { ["arcane"] = true, },
			},
		["strata"] = {
			["cps"] = 3,
			["markers"] = 3,
			["powerbar"] = 3,
			["text"] = 3,
			},
		},
	["powerbar"] = {
		["show"] = {
			["show"] = true,
			["hideOOC"] = false,
			["inStealth"] = true,
			["whenTargeting"] = true,
			["hideInVehicle"] = false,
			["hideInPetBattle"] = true,
			["powertypes"] = {
				["FOCUS"] = true,
				["MANA"] = true,
				["RUNIC_POWER"] = true,
				["ENERGY"] = true,
				["RAGE"] = true,
				}, 
			["vehicleEnergy"] = true,
			},
		["design"] = {
			["size"] = {["width"]=400,  ["height"]=30},
			["position"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
			["colorByPowertype"]=true,
			["colorByClass"]=false,
			["BarBGColor"]={["r"]=0, ["g"]=0, ["b"]=0, ["a"]=0.5},
			["BarColor"]={["r"]=1, ["g"]=1, ["b"]=0, ["a"]=1},
			["usedEffect"] = {
				["activate"] = true, 
				["dynamicColoring"] = false, 
				["color"] = {["r"]=1, ["g"]=0.6, ["b"]=0, ["a"]=1},
				},
			["insets"] = {
				["left"] = 0,
				["right"] = 0,
				["top"] = 0,
				["bottom"] = 0,
				},
			["sitRecoloring"] = {
				["full"] = 0.95,
				["fullIncEqual"] = false,
				["empty"] = 0.05,
				["emptyIncEqual"] = false,
				["use"] = {false, false, false, false, false, false},
				["colorByPowertype"] = {false, false, false, false, false, false},
				["colorByClass"] = {false, false, false, false, false, false},
				["1"] = {["r"]=1, ["g"]=1, ["b"]=0, ["a"]=1},
				["2"] = {["r"]=1, ["g"]=1, ["b"]=0, ["a"]=1},
				["3"] = {["r"]=1, ["g"]=1, ["b"]=0, ["a"]=1},
				["4"] = {["r"]=1, ["g"]=1, ["b"]=0, ["a"]=1},
				["5"] = {["r"]=1, ["g"]=1, ["b"]=0, ["a"]=1},
				["6"] = {["r"]=1, ["g"]=1, ["b"]=0, ["a"]=1},
				["7"] = {["r"]=1, ["g"]=1, ["b"]=0, ["a"]=1},
				["8"] = {["r"]=1, ["g"]=1, ["b"]=0, ["a"]=1},
				["9"] = {["r"]=1, ["g"]=1, ["b"]=0, ["a"]=1},
				["10"] = {["r"]=1, ["g"]=1, ["b"]=0, ["a"]=1},
				},
			["border"] = {
				["texture"] = "Solid",
				["color"]={["r"]=0, ["g"]=0, ["b"]=0, ["a"]=1},
				["size"]=2,
				},
			["barTexture"] = {
				["usePack"] = 1,
				["pack1"]="Solid",
				["pack2"]="None",
				},
			["barBGTexture"]="Solid",
			},
		["markers"]={
			["width"] = 3,
			["color"] = {["r"]=0, ["g"]=0, ["b"]=0, ["a"]=1},
			["colorLikeBG"] = false,
			["border"] = {
				["color"] = {["r"]=0, ["g"]=0, ["b"]=0, ["a"]=1},
				["size"] = 1,
				["colorLikeBG"] = true,
				},
			},
		},
	["CPBar"] = {
		["sound"] = {
			["activate"] = false,
			["threshold"] = 3,
			["channel"] = "Master",
			["file"] = "",
			},
		["show"] = {
			["show"] = true,
			["hideOOC"] = false,
			["inStealth"] = true,
			["whenTargeting"] = true,
			["hideInVehicle"] = false,
			["hideInPetBattle"] = true,
			["powertypes"] = {
				["FOCUS"] = true,
				["MANA"] = true,
				["RUNIC_POWER"] = true,
				["ENERGY"] = true,
				["RAGE"] = true,
				},
			["vehicleCPs"] = true,
			},
		["design"] = {
			["usedEffect"] = {
				["activate"] = true,
				},
			["position"] = {
				["clipToPower"] = true,
				["x"]=0,
				["y"]=40,
				["anchor"]="CENTER",
				["anchorFrame"]="CENTER",
				},
			["insets"] = {
				["left"] = 0,
				["right"] = 0,
				["top"] = 0,
				["bottom"] = 0,
				},
			["intMode"] = {
				["activate"] = true,
				["gap"] = 10,
				["offset"] = 20,
				["height"] = 30,
				["y"] = 40,
				},
			["texture"] = {
				["usePack"] = 1,
				["pack1"]="Solid",
				["pack2"]="None",
				},
			["border"] = {
				["texture"] = "Solid",
				["size"] = 1,
				["color"] = {["r"]=0, ["g"]=0, ["b"]=0, ["a"]=1},
				},
			["colors"] = {
				["activateRecoloring"] = true,
				["classPresets"] = {
					["activate"] = true,
					["classPresets"] = {
						["PRIEST"] = "Preset Priest",
						["MONK"] = "Preset Monk",
						["MAGE"] = "Preset Mage",
						["DEATHKNIGHT"] = "",
						["WARRIOR"] = "Preset Warrior",
						["SHAMAN"] = "Preset Shaman",
						["HUNTER"] = "Preset Hunter",
						["PALADIN"] = "Preset Paladin",
						["ROGUE"] = "Preset Druid and Rogue",
						["DRUID"] = "Preset Druid and Rogue",
						["WARLOCK"] = "Preset Warlock",
						},
					},
				["threshold"] = "3",
				["changeOnMax"] = false,
				["changeThresholdOnly"] = false,
				["colors"] = {
					["1"] = {["r"]=1, ["g"]=0.929, ["b"]=0.0156, ["a"]=1},
					["2"] = {["r"]=0.7725, ["g"]=1, ["b"]=0.043, ["a"]=1},
					["3"] = {["r"]=0.314, ["g"]=1, ["b"]=0.6666, ["a"]=1},
					["4"] = {["r"]=0, ["g"]=1, ["b"]=0.753, ["a"]=1},
					["5"] = {["r"]=0.0078, ["g"]=0.757, ["b"]=1, ["a"]=1},
					["6"] = {["r"]=0.0078, ["g"]=0.757, ["b"]=1, ["a"]=1},
					["7"] = {["r"]=0.0078, ["g"]=0.757, ["b"]=1, ["a"]=1},
					["8"] = {["r"]=0.0078, ["g"]=0.757, ["b"]=1, ["a"]=1},
					["9"] = {["r"]=0.0078, ["g"]=0.757, ["b"]=1, ["a"]=1},
					["10"] = {["r"]=0.0078, ["g"]=0.757, ["b"]=1, ["a"]=1},
					["change"] = {["r"]=1, ["g"]=0, ["b"]=0, ["a"]=1},
					["used"] = {["r"]=1, ["g"]=0.6, ["b"]=0, ["a"]=1},
					},
				},
			["altPositioning"] = {
				["10"] = {
					["change"] = false,
					["width"] = 36,
					["height"] = 30,
					["10"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["9"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["8"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["7"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["6"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["5"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["4"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["3"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["2"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["1"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					},
				["9"] = {
					["change"] = false,
					["width"] = 40,
					["height"] = 30,
					["9"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["8"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["7"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["6"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["5"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["4"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["3"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["2"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["1"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					},
				["8"] = {
					["change"] = false,
					["width"] = 45,
					["height"] = 30,
					["8"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["7"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["6"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["5"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["4"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["3"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["2"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["1"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					},
				["7"] = {
					["change"] = false,
					["width"] = 50,
					["height"] = 30,
					["7"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["6"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["5"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["4"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["3"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["2"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["1"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					},
				["6"] = {
					["change"] = false,
					["width"] = 60,
					["height"] = 30,
					["6"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["5"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["4"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["3"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["2"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["1"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					},
				["5"] = {
					["change"] = false,
					["width"] = 72,
					["height"] = 30,
					["5"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["4"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["3"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["2"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["1"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					},
				["4"] = {
					["change"] = false,
					["width"] = 90,
					["height"] = 30,
					["4"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["3"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["2"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["1"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					},
				["3"] = {
					["change"] = false,
					["width"] = 120,
					["height"] = 30,
					["3"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["2"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["1"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					},
				["2"] = {
					["change"] = false,
					["width"] = 180,
					["height"] = 30,
					["2"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					["1"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					},
				["1"] = {
					["change"] = false,
					["width"] = 360,
					["height"] = 30,
					["1"] = {["x"]=0,  ["y"]=0, ["anchor"]="CENTER", ["anchorFrame"]="CENTER"},
					},
				},
			},
		},
	["altPowerbar"] = {
		["design"] = {
			["insets"] = {
				["left"] = 0,  --!!!
				["right"] = 0,  --!!!
				["top"] = 0,  --!!!
				["bottom"] = 0,  --!!!
				},
			["usedEffect"] = {
				["activate"] = true,  --!!!
				["color"] = {["r"]=1, ["g"]=0.6, ["b"]=0, ["a"]=1}, --!!!
				},
			["barTexture"] = {
				["usePack"] = 1,  --!!!
				["pack1"]="Solid",  --!!!
				["pack2"]="None",  --!!!
				},
			["border"] = {
				["texture"] = "Solid", --!!!
				["size"] = 1, --!!!
				["color"] = {["r"]=0, ["g"]=0, ["b"]=0, ["a"]=1}, --!!!
				},
			["barBGTexture"]="Solid", --!!!
			["BarBGColor"]={["r"]=0, ["g"]=0, ["b"]=0, ["a"]=0.5}, --!!!
			},
		},
	}

vexpower.defaults.createdTextfields = {
	["1"]={
		["text"]="[PowerCurrent]",
		["font"]="Friz Quadrata TT",
		["size"]=14,
		["align"]="LEFT",
		["x"]=5,
		["y"]=-7,
		["cptext"] = false,
		["anchor"]="TOPLEFT",
		["anchor2"]="TOPLEFT",
		["width"]=100,
		["color"]={["r"]=1, ["g"]=1, ["b"]=1, ["a"]=1},
		["effect"]="OUTLINE",
		["shadow"]={
			["allow"] = false,
			["offset"] = {["x"] = 5, ["y"] = 5},
			["color"] = {["r"]=0, ["g"]=0, ["b"]=0, ["a"]=1},
			}
		},
	["2"]={
		["text"]="[PowerMax]",
		["font"]="Friz Quadrata TT",
		["size"]=14,
		["align"]="RIGHT",
		["x"]=-5,
		["y"]=-7,
		["cptext"] = false,
		["anchor"]="TOPRIGHT",
		["anchor2"]="TOPRIGHT",
		["width"]=100,
		["color"]={["r"]=1, ["g"]=1, ["b"]=1, ["a"]=1},
		["effect"]="OUTLINE",
		["shadow"]={
			["allow"] = false,
			["offset"] = {["x"] = 5, ["y"] = 5},
			["color"] = {["r"]=0, ["g"]=0, ["b"]=0, ["a"]=1},
			}
		},
	["3"] = {
		["text"] = "[TimeLeft][PowerAltCurrent]",
		["font"] = "Friz Quadrata TT",
		["size"] = 14,
		["align"] = "LEFT",
		["x"] = 25,
		["y"] = 50,
		["cptext"] = true,
		["anchor"] = "TOPLEFT",
		["anchor2"] = "LEFT",
		["width"] = 100,
		["color"]={["r"]=1, ["g"]=1, ["b"]=1, ["a"]=1},
		["effect"] = "OUTLINE",
		["shadow"] = {
			["allow"] = false,
			["offset"] = {["x"] = 5, ["y"] = 5},
			["color"] = {["r"]=0, ["g"]=0, ["b"]=0, ["a"]=1},
			},
		},
	}

vexpower.defaults.singleTextfield = {
		["text"]="",
		["font"]="Friz Quadrata TT",
		["size"]=14,
		["align"]="LEFT",
		["x"]=25,
		["y"]=-7,
		["cptext"] = false,
		["anchor"]="TOPLEFT",
		["anchor2"]="TOPLEFT",
		["width"]=100,
		["color"]={["r"]=1, ["g"]=1, ["b"]=1, ["a"]=1},
		["effect"]="OUTLINE",
		["shadow"]={
			["allow"] = false,
			["offset"] = {["x"] = 5, ["y"] = 5},
			["color"] = {["r"]=0, ["g"]=0, ["b"]=0, ["a"]=1},
			}
	}
	
vexpower.defaults.singleMarker = {
	["FOCUS"] = true,
	["MANA"] = true,
	["RUNIC_POWER"] = true,
	["ENERGY"] = true,
	["RAGE"] = true,
	}