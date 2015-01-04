function vexrunes.panel_general()
	return { 
		type = "group",
		args = {
			grpblizz = {
				name = "Blizzard",
				order=1, type ="group", dialogInline = true,
				args = {
					hide = {
						name = "Hide Blizzard's rune frame",
						order=1, type = "toggle", width="full",
						set = function(self,key) vexrunes_parameters["layout"]["runes"]["hideblizz"]=key vexrunes_setBlizzRuneFrame() end,
						get = function() return vexrunes_parameters["layout"]["runes"]["hideblizz"] end,
						},
					hide_info = {name ="Enabling Blizzard's Rune Frame needs a UI reload in order to work\n\n", type = "description", order=2},
					vehiclehide = {
						name = "Hide in vehicle",
						order=3, type = "toggle", width="full",
						set = function(self,key) vexrunes_parameters["vehiclehide"]=key vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["vehiclehide"] end,
						},
					},
				},
			frame_spaceblizz = {name ="\n", type = "description", order=2},
			grpfill = {
				name = "Fill-Options",
				order=3, type ="group", dialogInline = true,
				args = {
					fill = {
						name = "Fill the runes vertical instead of horizontal",
						order=1, type = "toggle", width="full",
						set = function(self,key) vexrunes_parameters["layout"]["runes"]["verticalfill"]=key vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["verticalfill"] end,
						},
					fill2 = {
						name = "Invert filling",
						order=2, type = "toggle", width="full",
						set = function(self,key) vexrunes_parameters["layout"]["runes"]["fillbottom"]=key vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["fillbottom"] end,
						},
					},
				},
			frame_spacefill = {name ="\n", type = "description", order=4},
			grppos = {
				name = "General Position",
				order=5, type ="group", dialogInline = true,
				args = {
					grpfix = {
						name = "Vex Power",
						order=1, type ="group", dialogInline = true,
						args = {
							snaptovexp = {
								name = "Fix to 'Vex Power'-Addon ",
								order=1, type = "toggle", width="full",
								set = function(self,key) vexrunes_parameters["layout"]["runes"]["position"]["claptovexp"]=key vexrunes_initialize(true) end,
								get = function() return vexrunes_parameters["layout"]["runes"]["position"]["claptovexp"] end,
								},
							snaptovexpinfo = {name = "Fixing this Addon to the 'Vex Power'-Addon lets you set the position of this addon relative to the position of 'Vex Power'. This only works when you have the addon 'Vex Power' installed and active\n", type="description", order=2, fontSize="medium"},
						},
					},
					posx = {
						name = "X Position",
						order=3, type = "range",
						desc = "Sets the x position of the runebar",
						step = 1, min = -1000, max = 1000,
						set = function(info,val) vexrunes_parameters["layout"]["runes"]["position"]["main"]["x"]=val vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["position"]["main"]["x"] end
						},
					posy = {
						name = "Y Position",
						order=4, type = "range",
						desc = "Sets the y position of the runebar",
						step = 1, min = -1000, max = 1000,
						set = function(info,val) vexrunes_parameters["layout"]["runes"]["position"]["main"]["y"]=val vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["position"]["main"]["y"] end
						},
					},
				},
			frame_space1 = {name ="\n", type = "description", order=6},
			
			grpsize = {
				name = "Rune Size",
				order=7, type ="group", dialogInline = true,
				args = {
					width = {
						name = "Width",
						order=13, type = "range",
						desc = "Sets the width of the runes",
						step = 1, min = 1, max = 100,
						set = function(info,val) vexrunes_parameters["layout"]["runes"]["size"]["width"]=val vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["size"]["width"] end
						},
					height = {
						name = "Height",
						order=14, type = "range",
						desc = "Sets the height of the runes",
						step = 1, min = 1, max = 100,
						set = function(info,val) vexrunes_parameters["layout"]["runes"]["size"]["height"]=val vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["size"]["height"] end
						},
					},
				},
			}
		}
end

function vexrunes_setrune(number, key)
	vexrunes_parameters["layout"]["runes"]["order"][tostring(number)] = tonumber(key)
	vexrunes_setBarRuneBG(number)
end

function vexrunes_getrune(number)
	return tostring(vexrunes_parameters["layout"]["runes"]["order"][tostring(number)])
end

