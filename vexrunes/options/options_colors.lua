function vexrunes.panel_colors()
	return { 
		type = "group",
		args = {
			grpbg = {
				name = "Background",
				order=1, type ="group", dialogInline = true,
				args = {
					background = {
						name = "Color",
						desc = "Color for the background that is shown when a rune is reloading",
						order=1, type = "color",
						set = function(info,r,g,b,a)
							vexrunes_parameters["layout"]["runes"]["bg"]["shadow"]["r"]=r
							vexrunes_parameters["layout"]["runes"]["bg"]["shadow"]["g"]=g
							vexrunes_parameters["layout"]["runes"]["bg"]["shadow"]["b"]=b
							vexrunes_initialize(true) end,
						get = function() return 
							vexrunes_parameters["layout"]["runes"]["bg"]["shadow"]["r"],
							vexrunes_parameters["layout"]["runes"]["bg"]["shadow"]["g"],
							vexrunes_parameters["layout"]["runes"]["bg"]["shadow"]["b"] end,
						},
					bgopacity = {
						name = "Opacity %",
						order=2, type = "range",
						desc = "Sets the opacity",
						step = 5, min = 0, max = 100,
						set = function(info,val) vexrunes_parameters["layout"]["runes"]["bg"]["shadow"]["a"]=val/100 vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["bg"]["shadow"]["a"]*100 end
						},
					shadowdefault = {
						name = "Set to default",
						order=3, type = "execute",
						func = function(info,val) vexrunes_load_color("shadow") vexrunes_initialize(true) end,
						},
					},
				},
			frame_space1 = {name ="\n", type = "description", order=2},
				
			grprunes = {
				name = "Runes",
				order=3, type ="group", dialogInline = true,
				args = {
					texture = {
						name = "Texture",
						order=1, type = "select",
						dialogControl = "LSM30_Background",
						desc = "Sets the frame's background",
						values = vexrunes.LSM:HashTable("background"),
						set = function(self,key) vexrunes_parameters["layout"]["runes"]["bg"]["texture"]=key vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["bg"]["texture"] end,
						},
					texturebreak = {name ="\n", type = "description", order=2},
					usedcolor = {
						name = "Blink color",
						order=10, type = "color",
						desc = "Color for the blink when a rune has been used",
						set = function(info,r,g,b,a)
							vexrunes_parameters["layout"]["runes"]["bg"]["used"]["r"]=r
							vexrunes_parameters["layout"]["runes"]["bg"]["used"]["g"]=g
							vexrunes_parameters["layout"]["runes"]["bg"]["used"]["b"]=b
							vexrunes_initialize(true) end,
						get = function() return 
							vexrunes_parameters["layout"]["runes"]["bg"]["used"]["r"],
							vexrunes_parameters["layout"]["runes"]["bg"]["used"]["g"],
							vexrunes_parameters["layout"]["runes"]["bg"]["used"]["b"] end,
						},
					usedopacity = {
						name = "Opacity %",
						order=11, type = "range",
						desc = "Sets the opacity",
						step = 5, min = 0, max = 100,
						set = function(info,val) vexrunes_parameters["layout"]["runes"]["bg"]["used"]["a"]=val/100 vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["bg"]["used"]["a"]*100 end
						},
					useddefault = {
						name = "Set to default",
						order=12, type = "execute",
						func = function(info,val) vexrunes_load_color("used") vexrunes_initialize(true) end,
						},
					blood = {
						name = "Blood Rune",
						order=21, type = "color",
						desc = "Color for the blood Rune",
						set = function(info,r,g,b,a)
							vexrunes_parameters["layout"]["runes"]["bg"]["blood"]["r"]=r
							vexrunes_parameters["layout"]["runes"]["bg"]["blood"]["g"]=g
							vexrunes_parameters["layout"]["runes"]["bg"]["blood"]["b"]=b
							vexrunes_initialize(true) end,
						get = function() return 
							vexrunes_parameters["layout"]["runes"]["bg"]["blood"]["r"],
							vexrunes_parameters["layout"]["runes"]["bg"]["blood"]["g"],
							vexrunes_parameters["layout"]["runes"]["bg"]["blood"]["b"] end,
						},
					bloodopacity = {
						name = "Opacity %",
						order=22, type = "range",
						desc = "Sets the opacity",
						step = 5, min = 0, max = 100,
						set = function(info,val) vexrunes_parameters["layout"]["runes"]["bg"]["blood"]["a"]=val/100 vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["bg"]["blood"]["a"]*100 end
						},
					blooddefault = {
						name = "Set to default",
						order=23, type = "execute",
						func = function(info,val) vexrunes_load_color("blood") vexrunes_initialize(true) end,
						},
					frost = {
						name = "Frost Rune",
						order=31, type = "color",
						desc = "Color for the frost Rune",
						set = function(info,r,g,b,a)
							vexrunes_parameters["layout"]["runes"]["bg"]["frost"]["r"]=r
							vexrunes_parameters["layout"]["runes"]["bg"]["frost"]["g"]=g
							vexrunes_parameters["layout"]["runes"]["bg"]["frost"]["b"]=b
							vexrunes_initialize(true) end,
						get = function() return 
							vexrunes_parameters["layout"]["runes"]["bg"]["frost"]["r"],
							vexrunes_parameters["layout"]["runes"]["bg"]["frost"]["g"],
							vexrunes_parameters["layout"]["runes"]["bg"]["frost"]["b"] end,
						},
					frostopacity = {
						name = "Opacity %",
						order=32, type = "range",
						desc = "Sets the opacity",
						step = 5, min = 0, max = 100,
						set = function(info,val) vexrunes_parameters["layout"]["runes"]["bg"]["frost"]["a"]=val/100 vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["bg"]["frost"]["a"]*100 end
						},
					frostdefault = {
						name = "Set to default",
						order=33, type = "execute",
						func = function(info,val) vexrunes_load_color("frost") vexrunes_initialize(true) end,
						},
					unholy = {
						name = "Unholy Rune",
						order=41, type = "color",
						desc = "Color for the unholy Rune",
						set = function(info,r,g,b,a)
							vexrunes_parameters["layout"]["runes"]["bg"]["unholy"]["r"]=r
							vexrunes_parameters["layout"]["runes"]["bg"]["unholy"]["g"]=g
							vexrunes_parameters["layout"]["runes"]["bg"]["unholy"]["b"]=b
							vexrunes_initialize(true) end,
						get = function() return 
							vexrunes_parameters["layout"]["runes"]["bg"]["unholy"]["r"],
							vexrunes_parameters["layout"]["runes"]["bg"]["unholy"]["g"],
							vexrunes_parameters["layout"]["runes"]["bg"]["unholy"]["b"] end,
						},
					unholytopacity = {
						name = "Opacity %",
						order=42, type = "range",
						desc = "Sets the opacity",
						step = 5, min = 0, max = 100,
						set = function(info,val) vexrunes_parameters["layout"]["runes"]["bg"]["unholy"]["a"]=val/100 vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["bg"]["unholy"]["a"]*100 end
						},
					unholydefault = {
						name = "Set to default",
						order=43, type = "execute",
						func = function(info,val) vexrunes_load_color("unholy") vexrunes_initialize(true) end,
						},
					death = {
						name = "Death Rune",
						order=51, type = "color",
						desc = "Color for the death Rune",
						set = function(info,r,g,b,a)
							vexrunes_parameters["layout"]["runes"]["bg"]["death"]["r"]=r
							vexrunes_parameters["layout"]["runes"]["bg"]["death"]["g"]=g
							vexrunes_parameters["layout"]["runes"]["bg"]["death"]["b"]=b
							vexrunes_initialize(true) end,
						get = function() return 
							vexrunes_parameters["layout"]["runes"]["bg"]["death"]["r"],
							vexrunes_parameters["layout"]["runes"]["bg"]["death"]["g"],
							vexrunes_parameters["layout"]["runes"]["bg"]["death"]["b"] end,
						},
					deathtopacity = {
						name = "Opacity %",
						order=52, type = "range",
						desc = "Sets the opacity",
						step = 5, min = 0, max = 100,
						set = function(info,val) vexrunes_parameters["layout"]["runes"]["bg"]["death"]["a"]=val/100 vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["bg"]["death"]["a"]*100 end
						},
					deathdefault = {
						name = "Set to default",
						order=53, type = "execute",
						func = function(info,val) vexrunes_load_color("death") vexrunes_initialize(true) end,
						},
					},
				},
			frame_space1 = {name ="\n", type = "description", order=4},
			
			grpborder = {
				name = "Border",
				order=5, type ="group", dialogInline = true,
				args = {
					color = {
						name = "Color",
						order=1, type = "color",
						set = function(info,r,g,b,a)
							vexrunes_parameters["layout"]["runes"]["border"]["color"]["r"]=r
							vexrunes_parameters["layout"]["runes"]["border"]["color"]["g"]=g
							vexrunes_parameters["layout"]["runes"]["border"]["color"]["b"]=b
							vexrunes_initialize(true) end,
						get = function() return 
							vexrunes_parameters["layout"]["runes"]["border"]["color"]["r"],
							vexrunes_parameters["layout"]["runes"]["border"]["color"]["g"],
							vexrunes_parameters["layout"]["runes"]["border"]["color"]["b"] end,
						},
					opacity = {
						name = "Opacity %",
						order=2, type = "range",
						desc = "Sets the opacity",
						step = 5, min = 0, max = 100,
						set = function(info,val) vexrunes_parameters["layout"]["runes"]["border"]["color"]["a"]=val/100 vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["border"]["color"]["a"]*100 end
						},
					hide = {
						name = "Color the borders like the runes",
						order=3, type = "toggle", width="full",
						set = function(self,key) vexrunes_parameters["layout"]["runes"]["border"]["likebg"]=key vexrunes_initialize(true) end,
						get = function() return vexrunes_parameters["layout"]["runes"]["border"]["likebg"] end,
						},
					},
				},
			}
		}
end

function vexrunes_load_color(color)
	vexrunes_parameters["layout"]["runes"]["bg"][color]["r"]=vexrunes_defaults["layout"]["runes"]["bg"][color]["r"]
	vexrunes_parameters["layout"]["runes"]["bg"][color]["g"]=vexrunes_defaults["layout"]["runes"]["bg"][color]["g"]
	vexrunes_parameters["layout"]["runes"]["bg"][color]["b"]=vexrunes_defaults["layout"]["runes"]["bg"][color]["b"]
	vexrunes_parameters["layout"]["runes"]["bg"][color]["a"]=vexrunes_defaults["layout"]["runes"]["bg"][color]["a"]
end


