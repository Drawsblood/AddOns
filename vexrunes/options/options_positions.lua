function vexrunes.panel_positions()
	return { 
		type = "group",
		args = {
			grppresets = {
				name = "Presets",
				order=1, type ="group", dialogInline = true,
				args = {
					grppreset1 = {
						name = "Preset 1",
						order=1, type ="group", dialogInline = true,
						args = {
							presetimage1={name = "", type="description", image="Interface\\AddOns\\vexrunes\\images\\preset1.tga",
								imageWidth=365, imageHeight=56, imageCoords={0,0.713,0,1}, order=2},
							load1 = {
								name = "load preset 1",
								desc = "load preset",
								order=3, type = "execute",
								func = function(info,val) vexrunes_load_preset(1) vexrunes_initialize(true) end,
								},
							},
						},
					space1 = {name = "\n", type="description", order=2},
					
					grppreset2 = {
						name = "Preset 2",
						order=3, type ="group", dialogInline = true,
						args = {
							presetimage2={name = "", type="description", image="Interface\\AddOns\\vexrunes\\images\\preset2.tga",
								imageWidth=128, imageHeight=128, order=2},
							load2 = {
								name = "load preset 2",
								desc = "load preset",
								order=3, type = "execute",
								func = function(info,val) vexrunes_load_preset(2) vexrunes_initialize(true) end,
								},
							},
						},
					space2 = {name = "\n", type="description", order=4},
					
					grppreset3 = {
						name = "Preset 3",
						order=5, type ="group", dialogInline = true,
						args = {
							presetimage3={name = "", type="description", image="Interface\\AddOns\\vexrunes\\images\\preset3.tga",
								imageWidth=190, imageHeight=80, imageCoords={0,0.742,0,0.625}, order=2},
							load3 = {
								name = "load preset 3",
								desc = "load preset",
								order=3, type = "execute",
								func = function(info,val) vexrunes_load_preset(3) vexrunes_initialize(true) end,
								},
							},
						},
					space3 = {name = "\n", type="description", order=6},
					
					
					grppreset4 = {
						name = "Preset 4",
						order=7, type ="group", dialogInline = true,
						args = {
							presetimage4={name = "", type="description", image="Interface\\AddOns\\vexrunes\\images\\preset4.tga",
								imageWidth=180, imageHeight=100, imageCoords={0,0.7,0,0.78}, order=2},
							load4 = {
								name = "load preset 4",
								desc = "load preset",
								order=3, type = "execute",
								func = function(info,val) vexrunes_load_preset(4) vexrunes_initialize(true) end,
								},
							},
						},
					space4 = {name = "\n", type="description", order=8},
					
					grppreset5 = {
						name = "Preset 5",
						order=9, type ="group", dialogInline = true,
						args = {
							presetimage5={name = "", type="description", image="Interface\\AddOns\\vexrunes\\images\\preset5.tga",
								imageWidth=370, imageHeight=90, imageCoords={0,0.722,0,0.703}, order=2},
							load5 = {
								name = "load preset 5",
								desc = "load preset",
								order=3, type = "execute",
								func = function(info,val) vexrunes_load_preset(5) vexrunes_initialize(true) end,
								},
							},
						},
					space5 = {name = "\n", type="description", order=10},
					
					grppreset5 = {
						name = "Preset 6",
						order=11, type ="group", dialogInline = true,
						args = {
							presetimage6={name = "", type="description", image="Interface\\AddOns\\vexrunes\\images\\preset6.tga",
								imageWidth=256, imageHeight=128, order=2, imageCoords={0,1,0,1}},
							load6 = {
								name = "load preset 6",
								desc = "load preset",
								order=3, type = "execute",
								func = function(info,val) vexrunes_load_preset(6) vexrunes_initialize(true) end,
								},
							},
						},
					},
				},
			space6 = {name = "\n", type="description", order=2},
			
			grpruneorder = {
				name = "Rune Order",
				order=3, type ="group", dialogInline = true,
				args = {
					rune1 = {
						name = "Rune 1:",
						order=51, type = "select", style = "dropdown",
						desc = "Choose the rune",
						values = {["1"]="Blood 1", ["2"]="Blood 2", ["5"]="Frost 1", ["6"]="Frost 2", ["3"]="Unholy 1", ["4"]="Unholy 2"},
						set = function(self,key) vexrunes_setrune(1, key) end,
						get = function() return vexrunes_getrune(1) end,
						},
					rune2 = {
						name = "Rune 2:",
						order=51, type = "select", style = "dropdown",
						desc = "Choose the rune",
						values = {["1"]="Blood 1", ["2"]="Blood 2", ["5"]="Frost 1", ["6"]="Frost 2", ["3"]="Unholy 1", ["4"]="Unholy 2"},
						set = function(self,key) vexrunes_setrune(2, key) end,
						get = function() return vexrunes_getrune(2) end,
						},
					rune3 = {
						name = "Rune 3:",
						order=51, type = "select", style = "dropdown",
						desc = "Choose the rune",
						values = {["1"]="Blood 1", ["2"]="Blood 2", ["5"]="Frost 1", ["6"]="Frost 2", ["3"]="Unholy 1", ["4"]="Unholy 2"},
						set = function(self,key) vexrunes_setrune(3, key) end,
						get = function() return vexrunes_getrune(3) end,
						},
					rune4 = {
						name = "Rune 4:",
						order=51, type = "select", style = "dropdown",
						desc = "Choose the rune",
						values = {["1"]="Blood 1", ["2"]="Blood 2", ["5"]="Frost 1", ["6"]="Frost 2", ["3"]="Unholy 1", ["4"]="Unholy 2"},
						set = function(self,key) vexrunes_setrune(4, key) end,
						get = function() return vexrunes_getrune(4) end,
						},
					rune5 = {
						name = "Rune 5:",
						order=51, type = "select", style = "dropdown",
						desc = "Choose the rune",
						values = {["1"]="Blood 1", ["2"]="Blood 2", ["5"]="Frost 1", ["6"]="Frost 2", ["3"]="Unholy 1", ["4"]="Unholy 2"},
						set = function(self,key) vexrunes_setrune(5, key) end,
						get = function() return vexrunes_getrune(5) end,
						},
					rune6 = {
						name = "Rune 6:",
						order=51, type = "select", style = "dropdown",
						desc = "Choose the rune",
						values = {["1"]="Blood 1", ["2"]="Blood 2", ["5"]="Frost 1", ["6"]="Frost 2", ["3"]="Unholy 1", ["4"]="Unholy 2"},
						set = function(self,key) vexrunes_setrune(6, key) end,
						get = function() return vexrunes_getrune(6) end,
						},
					},
				},
			space7 = {name = "\n", type="description", order=4},
			
			grprunepos = {
				name = "Rune positions",
				order=5, type ="group", dialogInline = true,
				args = {
					posx1 = {
						name = "Rune 1: X Position",
						order=1130, type = "range",
						desc = "Sets the x position of the rune",
						step = 1, min = -300, max = 300,
						set = function(info,val) vexrunes_parameters["layout"]["runes"]["position"]["1"]["x"]=val vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["position"]["1"]["x"] end
						},
					posy1 = {
						name = "Rune 1: Y Position",
						order=1131, type = "range",
						desc = "Sets the y position of the rune",
						step = 1, min = -300, max = 300,
						set = function(info,val) vexrunes_parameters["layout"]["runes"]["position"]["1"]["y"]=val vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["position"]["1"]["y"] end
						},
					space1 = {name = " ", type="description", order=1132},
					posx2 = {
						name = "Rune 2: X Position",
						order=1140, type = "range",
						desc = "Sets the x position of the rune",
						step = 1, min = -300, max = 300,
						set = function(info,val) vexrunes_parameters["layout"]["runes"]["position"]["2"]["x"]=val vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["position"]["2"]["x"] end
						},
					posy2 = {
						name = "Rune 2: Y Position",
						order=1141, type = "range",
						desc = "Sets the y position of the rune",
						step = 1, min = -300, max = 300,
						set = function(info,val) vexrunes_parameters["layout"]["runes"]["position"]["2"]["y"]=val vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["position"]["2"]["y"] end
						},
					space2 = {name = " ", type="description", order=1142},
					posx3 = {
						name = "Rune 3: X Position",
						order=1150, type = "range",
						desc = "Sets the x position of the rune",
						step = 1, min = -300, max = 300,
						set = function(info,val) vexrunes_parameters["layout"]["runes"]["position"]["3"]["x"]=val vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["position"]["3"]["x"] end
						},
					posy3 = {
						name = "Rune 3: Y Position",
						order=1151, type = "range",
						desc = "Sets the y position of the rune",
						step = 1, min = -300, max = 300,
						set = function(info,val) vexrunes_parameters["layout"]["runes"]["position"]["3"]["y"]=val vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["position"]["3"]["y"] end
						},
					space3 = {name = " ", type="description", order=1152},
					posx4 = {
						name = "Rune 4: X Position",
						order=1160, type = "range",
						desc = "Sets the x position of the rune",
						step = 1, min = -300, max = 300,
						set = function(info,val) vexrunes_parameters["layout"]["runes"]["position"]["4"]["x"]=val vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["position"]["4"]["x"] end
						},
					posy4 = {
						name = "Rune 4: Y Position",
						order=1161, type = "range",
						desc = "Sets the y position of the rune",
						step = 1, min = -300, max = 300,
						set = function(info,val) vexrunes_parameters["layout"]["runes"]["position"]["4"]["y"]=val vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["position"]["4"]["y"] end
						},
					space4 = {name = " ", type="description", order=1162},
					posx5 = {
						name = "Rune 5: X Position",
						order=1170, type = "range",
						desc = "Sets the x position of the rune",
						step = 1, min = -300, max = 300,
						set = function(info,val) vexrunes_parameters["layout"]["runes"]["position"]["5"]["x"]=val vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["position"]["5"]["x"] end
						},
					posy5 = {
						name = "Rune 5: Y Position",
						order=1171, type = "range",
						desc = "Sets the y position of the rune",
						step = 1, min = -300, max = 300,
						set = function(info,val) vexrunes_parameters["layout"]["runes"]["position"]["5"]["y"]=val vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["position"]["5"]["y"] end
						},
					space5 = {name = " ", type="description", order=1172},
					posx6 = {
						name = "Rune 6: X Position",
						order=1180, type = "range",
						desc = "Sets the x position of the rune",
						step = 1, min = -300, max = 300,
						set = function(info,val) vexrunes_parameters["layout"]["runes"]["position"]["6"]["x"]=val vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["position"]["6"]["x"] end
						},
					posy6 = {
						name = "Rune 6: Y Position",
						order=1181, type = "range",
						desc = "Sets the y position of the rune",
						step = 1, min = -300, max = 300,
						set = function(info,val) vexrunes_parameters["layout"]["runes"]["position"]["6"]["y"]=val vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["position"]["6"]["y"] end
						},
					space6 = {name = " ", type="description", order=1182},
					},
				},
			}
		}
end

function vexrunes_load_preset(number)
	local width = vexrunes_parameters["layout"]["runes"]["size"]["width"]
	local height = vexrunes_parameters["layout"]["runes"]["size"]["height"]
	local bordersize = vexrunes_parameters["layout"]["runes"]["border"]["size"]
	local x={}
	local y={}
	local gap = width/5
	if number == 2 then
		x[1] = -(width/2)-(gap/2)
		x[2] = (width/2)+(gap/2)
		x[3] = -(width/2)-(gap/2)
		x[4] = (width/2)+(gap/2)
		x[5] = -(width/2)-(gap/2)
		x[6] = (width/2)+(gap/2)
		y[1] = height+gap
		y[2] = height+gap
		y[3] = 0
		y[4] = 0
		y[5] = -height-gap
		y[6] = -height-gap
	elseif number == 3 then
		x[1] = -width-gap
		x[2] = -width-gap
		x[3] = 0
		x[4] = 0
		x[5] = width+gap
		x[6] = width+gap
		y[1] = (height/2)+(gap/2)
		y[2] = -(height/2)-(gap/2)
		y[3] = (height/2)+(gap/2)
		y[4] = -(height/2)-(gap/2)
		y[5] = (height/2)+(gap/2)
		y[6] = -(height/2)-(gap/2)
	elseif number == 4 then
		x[1] = -width-gap
		x[2] = -width-gap
		x[3] = 0
		x[4] = 0
		x[5] = width+gap
		x[6] = width+gap
		y[1] = (height/2)+gap
		y[2] = -(height/2)
		y[3] = (height/2)
		y[4] = -(height/2)-gap
		y[5] = (height/2)+gap
		y[6] = -(height/2)
	elseif number == 5 then
		x[1] = -(2*width)-(2*gap)-(width/2)-(gap/2)
		x[2] = -(width)-(gap)-(width/2)-(gap/2)
		x[3] = -(width/2)-(gap/2)
		x[4] = (width/2)+(gap/2)
		x[5] = (width)+(gap)+(width/2)+(gap/2)
		x[6] = (2*width)+(2*gap)+(width/2)+(gap/2)
		y[1] = (height/2)+gap
		y[2] = 0
		y[3] = -(height/2)-gap
		y[4] = -(height/2)-gap
		y[5] = 0
		y[6] = (height/2)+gap
	elseif number == 6 then
		x[1] = -width-gap-(width/2)-(gap/2)
		x[2] = width+gap+(width/2)+(gap/2)
		x[3] = -(width/2)-(gap/2)
		x[4] = (width/2)+(gap/2)
		x[5] = -(width/2)-(gap/2)
		x[6] = (width/2)+(gap/2)
		y[1] = 0
		y[2] = 0
		y[3] = (height/2)+height+gap
		y[4] = (height/2)+height+gap
		y[5] = -(height/2)-height-gap
		y[6] = -(height/2)-height-gap
	else
		x[1] = -(2*width)-(2*gap)-(width/2)-(gap/2)
		x[2] = -(width)-(gap)-(width/2)-(gap/2)
		x[3] = -(width/2)-(gap/2)
		x[4] = (width/2)+(gap/2)
		x[5] = (width)+(gap)+(width/2)+(gap/2)
		x[6] = (2*width)+(2*gap)+(width/2)+(gap/2)
		y[1] = 0
		y[2] = 0
		y[3] = 0
		y[4] = 0
		y[5] = 0
		y[6] = 0
	end
	vexrunes_parameters["layout"]["runes"]["position"]["1"]["x"] = x[1]
	vexrunes_parameters["layout"]["runes"]["position"]["1"]["y"] = y[1]
	vexrunes_parameters["layout"]["runes"]["position"]["2"]["x"] = x[2]
	vexrunes_parameters["layout"]["runes"]["position"]["2"]["y"] = y[2]
	vexrunes_parameters["layout"]["runes"]["position"]["3"]["x"] = x[3]
	vexrunes_parameters["layout"]["runes"]["position"]["3"]["y"] = y[3]
	vexrunes_parameters["layout"]["runes"]["position"]["4"]["x"] = x[4]
	vexrunes_parameters["layout"]["runes"]["position"]["4"]["y"] = y[4]
	vexrunes_parameters["layout"]["runes"]["position"]["5"]["x"] = x[5]
	vexrunes_parameters["layout"]["runes"]["position"]["5"]["y"] = y[5]
	vexrunes_parameters["layout"]["runes"]["position"]["6"]["x"] = x[6]
	vexrunes_parameters["layout"]["runes"]["position"]["6"]["y"] = y[6]
end

function vexrunes_setrune(number, key)
	vexrunes_parameters["layout"]["runes"]["order"][tostring(number)] = tonumber(key)
	vexrunes_setBarRuneBG(number)
end

function vexrunes_getrune(number)
	return tostring(vexrunes_parameters["layout"]["runes"]["order"][tostring(number)])
end

