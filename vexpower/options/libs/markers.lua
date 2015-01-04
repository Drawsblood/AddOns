vexpower.options.markers.openTab = {
	["information"] = false,
	["add"] = false,
	["delete"] = false,
	["appearance"] = false,
	}
	
function vexpower.options.markers.toggleTab(tab)
	if vexpower.options.markers.openTab[tab] ~= nil then
		vexpower.options.markers.closeAllTabs()
		vexpower.options.markers.openTab[tab] = true
	end
end
	
function vexpower.options.markers.closeAllTabs()
	for key in pairs(vexpower.options.markers.openTab) do
		vexpower.options.markers.openTab[key] = false
	end
end

vexpower.options.markers.newLocation = ""
vexpower.options.markers.newSpec = ""
vexpower.options.markers.editLocation = ""
vexpower.options.markers.editSpec = ""
vexpower.options.markers.editSpecPrev = ""

vexpower.options.markers.editPowertypes = {
	["FOCUS"] = true,
	["MANA"] = true,
	["RUNIC_POWER"] = true,
	["ENERGY"] = true,
	["RAGE"] = true,
	}

vexpower.options.markers.powertypesDefaults = {
	["FOCUS"] = true,
	["MANA"] = true,
	["RUNIC_POWER"] = true,
	["ENERGY"] = true,
	["RAGE"] = true,
	}
	
vexpower.options.markers.newPowertypes = {
	["FOCUS"] = true,
	["MANA"] = true,
	["RUNIC_POWER"] = true,
	["ENERGY"] = true,
	["RAGE"] = true,
	}
	
vexpower.options.markers.statusMsgCreated = " "
vexpower.options.markers.statusMsgDeleted = " "

function vexpower.options.markers.loadToEdit(key, spec)
	local markers = {}
	if spec == "a" then
		markers = vexpower_SV_markers_specA[vexpower_SV_data["profile"]]
	elseif spec == "b" then
		markers = vexpower_SV_markers_specB[vexpower_SV_data["profile"]]
	else
		markers = vexpower_SV_markers_specBoth[vexpower_SV_data["profile"]]
	end
	
	if markers[key] ~= nil then
		vexpower.options.markers.editLocation = key
		vexpower.options.markers.editSpec = spec
		vexpower.options.markers.editSpecPrev = spec
		vexpower.options.markers.editPowertypes = vexpower.data.lib.copyTable(markers[key])
	else
		vexpower.options.markers.statusMsgCreated = " "
		vexpower.options.markers.statusMsgDeleted = "|CFFC41F3BCouldn't load marker (location: "..pos..", visible for: "..specname..").|r Marker doesn't exist"
	end
end

function vexpower.options.markers.getList(val)
	local markers = {}
	if val == "spec a" then
		markers = vexpower_SV_markers_specA[vexpower_SV_data["profile"]]
	elseif val == "spec b" then
		markers = vexpower_SV_markers_specB[vexpower_SV_data["profile"]]
	else
		markers = vexpower_SV_markers_specBoth[vexpower_SV_data["profile"]]
	end
	
	local returnvalue = {}
	local timer = 0
	for key,val in pairs(markers) do
		local powertypes = ""
		local powertypeCount = 0
		for k,v in pairs(val) do
			if v then
				local text = ""
				if k == "FOCUS" then
					text = "|CFF"..vexpower.data.lib.getColor.powertypeHex(k).."F|r"
				elseif k == "MANA" then
					text = "|CFF"..vexpower.data.lib.getColor.powertypeHex(k).."M|r"
				elseif k == "RUNIC_POWER" then
					text = "|CFF"..vexpower.data.lib.getColor.powertypeHex(k).."RP|r"
				elseif k == "ENERGY" then
					text = "|CFF"..vexpower.data.lib.getColor.powertypeHex(k).."E|r"
				elseif k == "RAGE" then
					text = "|CFF"..vexpower.data.lib.getColor.powertypeHex(k).."R|r"
				end
				if text ~= "" then
					if powertypes ~= "" then
						powertypes = powertypes..", "
					end
					powertypes = powertypes..text
					powertypeCount = powertypeCount + 1
				end
			end
		end
		
		if powertypeCount == 5 then
			powertypes = "|CFF00FF00all powertypes|r"
		end
		
		returnvalue[key]=key.." ("..powertypes..")"
		timer = timer + 1
	end
	
	if timer == 0 then
		returnvalue[""] = "No markers created"
	end
	
	return returnvalue
end

function vexpower.options.markers.checkForExist()
	local pos = vexpower.options.markers.newLocation
	local spec = vexpower.options.markers.newSpec
	local overwrite = false
	if spec == "" 	then
		overwrite = vexpower_SV_markers_specBoth[vexpower_SV_data["profile"]][pos] ~= nil
	elseif spec == "a" then
		overwrite = vexpower_SV_markers_specA[vexpower_SV_data["profile"]][pos] ~= nil
	elseif spec == "b" then
		overwrite = vexpower_SV_markers_specB[vexpower_SV_data["profile"]][pos] ~= nil
	end
	
	return overwrite
end

function vexpower.options.markers.add()
	local pos = vexpower.options.markers.newLocation
	local spec = vexpower.options.markers.newSpec
	
	if vexpower.options.markers.check(pos) then
		local overwrite
		local specname = ""
		if spec == "" 	then
			specname = "Both Specs"
			overwrite = vexpower_SV_markers_specBoth[vexpower_SV_data["profile"]][pos] ~= nil
			vexpower_SV_markers_specBoth[vexpower_SV_data["profile"]][pos] = vexpower.data.lib.copyTable(vexpower.options.markers.newPowertypes)
		elseif spec == "a" then
			specname = "Primary Spec"
			overwrite = vexpower_SV_markers_specA[vexpower_SV_data["profile"]][pos] ~= nil
			vexpower_SV_markers_specA[vexpower_SV_data["profile"]][pos] = vexpower.data.lib.copyTable(vexpower.options.markers.newPowertypes)
		elseif spec == "b" then
			specname = "Secondary Spec"
			overwrite = vexpower_SV_markers_specB[vexpower_SV_data["profile"]][pos] ~= nil
			vexpower_SV_markers_specB[vexpower_SV_data["profile"]][pos] = vexpower.data.lib.copyTable(vexpower.options.markers.newPowertypes)
		end
		
		if overwrite then
			vexpower.options.markers.statusMsgCreated = "|CFF00FF00marker (location: "..pos..", visible for: "..specname..") has been overwritten|r"
			vexpower.options.markers.statusMsgDeleted = " "
			vexpower.options.markers.newLocation = ""
		else
			vexpower.options.markers.statusMsgCreated = "|CFF00FF00marker (location: "..pos..", visible for: "..specname..") successfully created|r"
			vexpower.options.markers.statusMsgDeleted = " "
			vexpower.options.markers.newLocation = ""
		end
	else
		vexpower.options.markers.statusMsgCreated = "|CFFC41F3B'"..pos.."' is not a valid marker|r"
		vexpower.options.markers.statusMsgDeleted = " "
	end
end

function vexpower.options.markers.update()
	local pos = vexpower.options.markers.editLocation
	local spec = vexpower.options.markers.editSpec
	
	if vexpower.options.markers.editSpecPrev == "" then
		if vexpower_SV_markers_specBoth[vexpower_SV_data["profile"]][pos] ~= nil then
			vexpower_SV_markers_specBoth[vexpower_SV_data["profile"]][pos] = nil
		end
	elseif vexpower.options.markers.editSpecPrev == "a" then
		if vexpower_SV_markers_specA[vexpower_SV_data["profile"]][pos] ~= nil then
			vexpower_SV_markers_specA[vexpower_SV_data["profile"]][pos] = nil
		end
	elseif vexpower.options.markers.editSpecPrev == "b" then
		if vexpower_SV_markers_specB[vexpower_SV_data["profile"]][pos] ~= nil then
			vexpower_SV_markers_specB[vexpower_SV_data["profile"]][pos] = nil
		end
	end
	
	if vexpower.options.markers.check(pos) then
		local specname = ""
		if spec == "" 	then
			specname = "Both Specs"
			vexpower_SV_markers_specBoth[vexpower_SV_data["profile"]][pos] = vexpower.data.lib.copyTable(vexpower.options.markers.editPowertypes)
		elseif spec == "a" then
			specname = "Primary Spec"
			vexpower_SV_markers_specA[vexpower_SV_data["profile"]][pos] = vexpower.data.lib.copyTable(vexpower.options.markers.editPowertypes)
		elseif spec == "b" then
			specname = "Secondary Spec"
			vexpower_SV_markers_specB[vexpower_SV_data["profile"]][pos] = vexpower.data.lib.copyTable(vexpower.options.markers.editPowertypes)
		end
		
		vexpower.options.markers.statusMsgDeleted = "|CFF00FF00marker (location: "..pos..", visible for: "..specname..") successfully updated|r"
		vexpower.options.markers.statusMsgCreated = " "
		vexpower.options.markers.editLocation = ""
		vexpower.options.markers.editSpec = ""
		vexpower.options.markers.editSpecPrev = ""
		vexpower.options.markers.editPowertypes = vexpower.data.lib.copyTable(vexpower.options.markers.powertypesDefaults)
	else
		vexpower.options.markers.statusMsgDeleted = "|CFFC41F3B'"..pos.."' is not a valid marker|r"
		vexpower.options.markers.statusMsgCreated = " "
	end
end

function vexpower.options.markers.check(val)
	local returnvalue = false
	
	if string.gsub(val, "^%d+%%?", "") == "" then
		returnvalue = true
	end
	
	if val == "" then
		returnvalue = false
	end
	
	return returnvalue
end

function vexpower.options.markers.delete()
	local pos = vexpower.options.markers.editLocation
	local spec = vexpower.options.markers.editSpec
	local exists = false
	local specname = ""
	
	if spec == "" then
		specname = "Both Specs"
		if vexpower_SV_markers_specBoth[vexpower_SV_data["profile"]][pos] ~= nil then
			vexpower_SV_markers_specBoth[vexpower_SV_data["profile"]][pos] = nil
			exists = true
		end
	elseif spec == "a" then
		specname = "Primary Spec"
		if vexpower_SV_markers_specA[vexpower_SV_data["profile"]][pos] ~= nil then
			vexpower_SV_markers_specA[vexpower_SV_data["profile"]][pos] = nil
			exists = true
		end
	elseif spec == "b" then
		specname = "Secondary Spec"
		if vexpower_SV_markers_specB[vexpower_SV_data["profile"]][pos] ~= nil then
			vexpower_SV_markers_specB[vexpower_SV_data["profile"]][pos] = nil
			exists = true
		end
	end
	if exists then
		vexpower.options.markers.statusMsgDeleted = "|CFF00FF00marker (location: "..pos..", visible for: "..specname..") successfully deleted|r"
		vexpower.options.markers.statusMsgCreated = " "
		vexpower.options.markers.editLocation = ""
		vexpower.options.markers.editSpec = ""
		vexpower.options.markers.editSpecPrev = ""
		vexpower.options.markers.editPowertypes = vexpower.data.lib.copyTable(vexpower.options.markers.powertypesDefaults)
	else
		vexpower.options.markers.statusMsgDeleted = "|CFFC41F3BCouldn't delete marker (location: "..pos..", visible for: "..specname..").|r Marker doesn't exist"
		vexpower.options.markers.statusMsgCreated = " "
		vexpower.options.markers.editLocation = ""
		vexpower.options.markers.editSpec = ""
		vexpower.options.markers.editSpecPrev = ""
		vexpower.options.markers.editPowertypes = vexpower.data.lib.copyTable(vexpower.options.markers.powertypesDefaults)
	end
end