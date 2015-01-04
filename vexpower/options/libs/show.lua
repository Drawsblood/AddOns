vexpower.options.show.openTab = {
	["general"] = false,
	["blizz"] = false,
	["ooc"] = false,
	["powertypes"] = false,
	["vehicle"] = false,
	["fadeout"] = false,
	}

function vexpower.options.show.toggleTab(tab)
	if vexpower.options.show.openTab[tab] ~= nil then
		vexpower.options.show.closeAllTabs()
		vexpower.options.show.openTab[tab] = true
	end
end
	
function vexpower.options.show.closeAllTabs()
	for key in pairs(vexpower.options.show.openTab) do
		vexpower.options.show.openTab[key] = false
	end
end