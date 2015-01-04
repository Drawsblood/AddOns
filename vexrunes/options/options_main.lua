function vexrunes.panel_main()
	return { 
		type = "group",
		args = {
			title={name="|CFFFF7D0AVersion: |r"..GetAddOnMetadata("vexrunes", "Version").."\n", type="description", order=1, fontSize="large"},
			author={name="|CFFFF7D0AAuthor: |rVexar Aegwynn-EU\n", type="description", order=2, fontSize="large"},
			slashcmds={name="\n\nSlash Cmds:\n/vexrunes\n/vexr", type="description", order=3, fontSize="large"},
			space={name="\n\n\n\n", type="description", order=4, fontSize="large"},
			
			defaults = {
				name = "reset to defaults",
				order=5, type = "execute",
				func = function(info,val) vexrunes_loaddefaults(true) end,
				},
			}
		}
end