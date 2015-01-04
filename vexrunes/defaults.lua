vexrunes_defaults = {
	["infightshow"] = false,
	["enable"] = true,
	["vehiclehide"] = false,
	["petBattleHide"] = true,
	["layout"] = {
		["runes"] = {
			["verticalfill"] = false,
			["fillbottom"] = false,
			["hideblizz"] = true,
			["order"] = {
				["1"]= 1, 
				["2"]= 2,
				["3"]= 5,
				["4"]= 6,
				["5"]= 3,
				["6"]= 4,
				},
			["size"] = {
				["width"] = 50,
				["height"] = 25,
				},
			["border"] =
				{
				["size"] = 1,
				["likebg"] = false,
				["color"] = {["r"]=0, ["g"]=0, ["b"]=0, ["a"]=1},
				},
			["bg"] = {
				["texture"] = "Solid",
				["blood"] = {["r"]=0.9, ["g"]=0.1, ["b"]=0.1, ["a"]=1},
				["frost"] = {["r"]=0, ["g"]=0.7, ["b"]=1, ["a"]=1},
				["unholy"] = {["r"]=0.6, ["g"]=0.9, ["b"]=0.1, ["a"]=1},
				["death"] = {["r"]=0.95, ["g"]=0.2, ["b"]=1, ["a"]=1},
				["used"] = {["r"]=1, ["g"]=0.6, ["b"]=0, ["a"]=1},
				["shadow"] = {["r"]=0, ["g"]=0, ["b"]=0, ["a"]=0.5},
				},
			["position"] = {
				["claptovexp"] = false,
				["main"] = {["x"]=0, ["y"]=0},
				["1"] = {["x"]=-150, ["y"]=0},
				["2"] = {["x"]=-90, ["y"]=0},
				["3"] = {["x"]=-30, ["y"]=0},
				["4"] = {["x"]=30, ["y"]=0},
				["5"] = {["x"]=90, ["y"]=0},
				["6"] = {["x"]=150, ["y"]=0},
				},
			},
		["text"] = {
			["show"] = true,
			["font"]="Friz Quadrata TT",
			["effect"]="OUTLINE",
			["size"]=14,
			["x"]=0, ["y"]=0,
			["align"]="CENTER",
			["color"]={["r"]=1, ["g"]=1, ["b"]=1, ["a"]=1},
			},
		},
	}

function vexrunes_loaddefaults(force)
	loadings = 0
	vexrunes_parameters =  vexrunes_check_tablecontent(vexrunes_defaults, vexrunes_parameters, force)
	if force then vexrunes_initialize(true) end
	
end

function vexrunes_check_tablecontent(defaults, saved, force)
	local temp = {}
	if force or type(saved) ~= "table" then temp=defaults
	else
		for key,val in pairs(defaults) do
			if type(val) == "table" then
				temp[key] = {}
				if saved[key] == nil then
					temp[key] = val
					loadings=loadings+1
				else
					temp[key] = vexrunes_check_tablecontent(defaults[key], saved[key], force)
				end
			else
				if saved[key] == nil then
					temp[key] = val
					loadings=loadings+1
				else
					temp[key] = saved[key]
				end
			end
		end		
	end
	return temp
end