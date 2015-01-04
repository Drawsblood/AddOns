vexpower.options.globalProfile.openTab = {
	["profile"] = false,
	["colorsets"] = false,
	}

function vexpower.options.globalProfile.toggleTab(tab)
	if vexpower.options.globalProfile.openTab[tab] ~= nil then
		vexpower.options.globalProfile.closeAllTabs()
		vexpower.options.globalProfile.openTab[tab] = true
	end
end
	
function vexpower.options.globalProfile.closeAllTabs()
	for key in pairs(vexpower.options.globalProfile.openTab) do
		vexpower.options.globalProfile.openTab[key] = false
	end
end