function vexrunes.panel_cds()
	return { 
		type = "group",
		args = {
			grpgen = {
				name = "General Settings",
				order=1, type ="group", dialogInline = true,
				args = {
					showtext = {
						name = "Show cooldown-text",
						order=1, type = "toggle", width="full",
						set = function(self,key) vexrunes_parameters["layout"]["text"]["show"]=key vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["text"]["show"] end,
						},
					},
				},
			frame_space1 = {name ="\n", type = "description", order=2},
				
			grpformat = {
				name = "Format",
				order=3, type ="group", dialogInline = true,
				args = {
					textfont = {
						name = "Font",
						order=2, type = "select",
						dialogControl = "LSM30_Font",
						desc = "Sets the font for the text",
						values = vexrunes.LSM:HashTable("font"),
						set = function(self,key) vexrunes_parameters["layout"]["text"]["font"]=key vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["text"]["font"] end,
						},
					textsize = {
						name = "Text size",
						order=106, type = "range",
						desc = "Sets the font size",
						step = 1, min = 6, max = 20,
						set = function(info,val) vexrunes_parameters["layout"]["text"]["size"]=val vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["text"]["size"] end,
						},
					textalign = {
						name = "Text align",
						order=107, type = "select", style = "dropdown",
						values = {["LEFT"]="Left", ["CENTER"]="Center", ["RIGHT"]="Right"},
						set = function(self,key) vexrunes_parameters["layout"]["text"]["align"]=key vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["text"]["align"] end,
						},
					textcolor = {
						name = "Color",
						order=108, type = "color", width="full",
						desc = "Text color",
						set = function(info,r,g,b,a)
							vexrunes_parameters["layout"]["text"]["color"]["r"]=r
							vexrunes_parameters["layout"]["text"]["color"]["g"]=g
							vexrunes_parameters["layout"]["text"]["color"]["b"]=b
							vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["text"]["color"]["r"],
							vexrunes_parameters["layout"]["text"]["color"]["g"],
							vexrunes_parameters["layout"]["text"]["color"]["b"] end,
						},
					texteffect = {
						name = "Text effect",
						order=109, type = "select", style = "dropdown",
						values = {["MONOCHROME"]="Monochrome", ["OUTLINE"]="Outline", [""]="None", ["THICKOUTLINE"]="Thickoutline"},
						set = function(self,key) vexrunes_parameters["layout"]["text"]["effect"]=key vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["text"]["effect"] end,
						},
					},
				},
			frame_space2 = {name ="\n", type = "description", order=4},
			
			grppos = {
				name = "Position",
				order=5, type ="group", dialogInline = true,
				args = {
					textx = {
						name = "X Position",
						order=109, type = "range",
						desc = "Sets the x position",
						step = 1, min = -100, max = 100,
						set = function(info,val) vexrunes_parameters["layout"]["text"]["x"]=val vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["text"]["x"] end,
						},
					texty = {
						name = "Y Position",
						order=110, type = "range",
						desc = "Sets the y position",
						step = 1, min = -100, max = 100,
						set = function(info,val) vexrunes_parameters["layout"]["text"]["y"]=val vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["text"]["y"] end,
						},
					},
				},
			}
		}
end
