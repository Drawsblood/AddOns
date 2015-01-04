vexpower.options.power.openTab = {
	["position"] = false,
	["size"] = false,
	["powerpool"] = false,
	["background"] = false,
	["usedenergy"] = false,
	["change"] = false,
	}

vexpower.options.power.emptyFullStatus = " "

function vexpower.options.power.toggleTab(tab)
	if vexpower.options.power.openTab[tab] ~= nil then
		vexpower.options.power.closeAllTab()
		vexpower.options.power.openTab[tab] = true
	end
end
	
function vexpower.options.power.closeAllTab()
	for key in pairs(vexpower.options.power.openTab) do
		vexpower.options.power.openTab[key] = false
	end
end

function vexpower.options.power.checkPowerValue(val)
	local returnvalue = false
	
	if string.gsub(val, "^%d+%%?", "") == "" then
		if string.find(val, "%%") ~= nil then
			val = string.gsub(val, "%%", "")
			if tonumber(val) <= 100 then
				returnvalue = true
			end
		else
			returnvalue = true
		end
	end
	
	if val == "" then
		returnvalue = false
	end
	
	return returnvalue
end

function vexpower.options.power.setPower(situation, val)
	if vexpower.options.power.checkPowerValue(val) then
		if string.find(val, "%%") ~= nil then
			val = string.gsub(val, "%%", "")
			val = tonumber(val)
			val = val / 100
			val = tostring(val)
		end
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"][situation] = val
		vexpower.options.power.emptyFullStauts = " "
	else
		if val == "" then
			vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"][situation] = "0"
		end
		vexpower.options.power.emptyFullStauts = "|CFFC41F3BInvalid value entered|r"
	end
end
	
function vexpower.options.power.getPower(situation)
	local value = tonumber(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"][situation])
	if value <= 1 then
		return tostring(value*100).."%"
	else
		return tostring(value)
	end
end

function vexpower.options.power.setColoring(style, val)
	if style == "class" then
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["colorByClass"] = val
		if val then
			vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["colorByPowertype"] = false
		end
	elseif style == "type" then
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["colorByPowertype"] = val
		if val then
			vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["colorByClass"] = false
		end
	end
end

function vexpower.options.power.setRecoloring(bar, style, val)
	if style == "class" then
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByClass"][bar] = val
		if val then
			vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByPowertype"][bar] = false
		end
	elseif style == "type" then
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByPowertype"][bar] = val
		if val then
			vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByClass"][bar] = false
		end
	end
end