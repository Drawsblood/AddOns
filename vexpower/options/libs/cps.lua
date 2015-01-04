vexpower.options.cps.openTab = {
	["layout"] = false,
	["border"] = false,
	["background"] = false,
	["fadeout"] = false,
	["change"] = false,
	["sound"] = false,
	["classspec"] = false,
	["altPowerbar"] = false,
	}

vexpower.options.cps.configCPSetting = "6"
	
function vexpower.options.cps.toggleTab(tab)
	if vexpower.options.cps.openTab[tab] ~= nil then
		vexpower.options.cps.closeAllTabs()
		vexpower.options.cps.openTab[tab] = true
	end
end

function vexpower.options.cps.closeAllTabs()
	for key in pairs(vexpower.options.cps.openTab) do
		vexpower.options.cps.openTab[key] = false
	end
end

function vexpower.options.cps.getConfigString(namestring)
	if namestring == nil then
		namestring = vexpower.options.cps.configCPSetting
	end

	local prefix = ""
	if namestring == "6" then
		prefix = "s (General Setting)"
	elseif namestring ~= "1" then
		prefix = "s"
	end
	return namestring.." ComboPoint"..prefix
end

function vexpower.options.cps.getHiddenCP(number)
	if number > tonumber(vexpower.options.cps.configCPSetting) then
		return true
	else
		return false
	end
end

function vexpower.options.cps.getList()
	local returnvalue = {}
	for i=1, 10 do
		local prefix = ""
		if i~=1 then
			prefix = prefix.."s"
		end
		if i==6 then
			prefix = prefix.." ('general'-setting)"
		elseif vexpower.options.cps.getSize("change",tostring(i)) then
			prefix = prefix.." |CFF00FF00(overwrite active)|r"
		end
		returnvalue[tostring(i)] = i.." ComboPoint"..prefix
	end
	return returnvalue
end

function vexpower.options.cps.getSize(size, number)
	if number == nil then
		number = vexpower.options.cps.configCPSetting
	end
	if vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][number] ~= nil then
		if vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][number][size] ~= nil then
			return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][number][size]
		end
	end
end

function vexpower.options.cps.setSize(size, val)
	if vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][vexpower.options.cps.configCPSetting] ~= nil then
		if vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][vexpower.options.cps.configCPSetting][size] ~= nil then
			vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][vexpower.options.cps.configCPSetting][size] = val
		end
	end
end

function vexpower.options.cps.getPos(number, key)
	if vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][vexpower.options.cps.configCPSetting] ~= nil then
		if vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][vexpower.options.cps.configCPSetting][number] ~= nil then
			if vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][vexpower.options.cps.configCPSetting][number][key] ~= nil then
				return vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][vexpower.options.cps.configCPSetting][number][key]
			end
		end
	end
end

function vexpower.options.cps.setPos(number, key, val)
	if vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][vexpower.options.cps.configCPSetting] ~= nil then
		if vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][vexpower.options.cps.configCPSetting][number] ~= nil then
			if vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][vexpower.options.cps.configCPSetting][number][key] ~= nil then
				vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][vexpower.options.cps.configCPSetting][number][key] = val
			end
		end
	end
end














