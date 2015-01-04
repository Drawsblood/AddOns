vexpower.options.colorpresets.colorset = {
	["1"] = {["r"]=1, ["g"]=0.929, ["b"]=0.0156, ["a"]=1},
	["2"] = {["r"]=0.7725, ["g"]=1, ["b"]=0.043, ["a"]=1},
	["3"] = {["r"]=0.314, ["g"]=1, ["b"]=0.6666, ["a"]=1},
	["4"] = {["r"]=0, ["g"]=1, ["b"]=0.753, ["a"]=1},
	["5"] = {["r"]=0.0078, ["g"]=0.757, ["b"]=1, ["a"]=1},
	["6"] = {["r"]=0.0078, ["g"]=0.757, ["b"]=1, ["a"]=1},
	["7"] = {["r"]=0.0078, ["g"]=0.757, ["b"]=1, ["a"]=1},
	["8"] = {["r"]=0.314, ["g"]=1, ["b"]=0.6666, ["a"]=1},
	["9"] = {["r"]=0, ["g"]=1, ["b"]=0.753, ["a"]=1},
	["10"] = {["r"]=0.0078, ["g"]=0.757, ["b"]=1, ["a"]=1},
	["change"] = {["r"]=1, ["g"]=0, ["b"]=0, ["a"]=1},
	["used"] = {["r"]=1, ["g"]=0.6, ["b"]=0, ["a"]=1},
	}

vexpower.options.colorpresets.editName = ""
vexpower.options.colorpresets.statusMsg = " "
vexpower.options.colorpresets.saveName = ""
vexpower.options.colorpresets.saveNamePrev = ""

function vexpower.options.colorpresets.createNew()
	vexpower.options.colorpresets.saveName = "new"
	vexpower.options.colorpresets.editName = "-"
	vexpower.options.colorpresets.colorset = vexpower.data.lib.copyTable(vexpower.defaults.singleColorPreset)
end

function vexpower.options.colorpresets.checkForExist(name)
	if name == nil then
		name = vexpower.options.colorpresets.saveName
	end
	
	if vexpower_SV_colorsets[name] ~= nil then
		return true
	else
		return false
	end
end

function vexpower.options.colorpresets.save(update)
	local name = ""
	if update then
		name = vexpower.options.colorpresets.saveNamePrev
	else
		name = vexpower.options.colorpresets.saveName
	end
	
	if vexpower.options.profiles.checkName(name) then
		vexpower_SV_colorsets[name] = vexpower.data.lib.copyTable(vexpower.options.colorpresets.colorset)
		if vexpower.options.colorpresets.checkForExist(name) then
			vexpower.options.colorpresets.statusMsg = "|CFF00FF00Successfully updated ColorPreset '"..name.."'|r"
		else
			vexpower.options.colorpresets.statusMsg = "|CFF00FF00Successfully saved the new ColorPreset '"..name.."'|r"
		end
	else
		if name == "" then
			vexpower.options.colorpresets.statusMsg = "|CFFC41F3BCouldn't save ColorPreset.|r You need to set a name."
		else
			vexpower.options.colorpresets.statusMsg = "|CFFC41F3BCouldn't save ColorPreset '"..name.."'.|r Invalid symbols used."
		end
	end
end

function vexpower.options.colorpresets.delete()
	if vexpower.options.colorpresets.editName == "" then
		vexpower.options.colorpresets.statusMsg = "ERROR: Can't delete current settings"
	else
		if vexpower_SV_colorsets[vexpower.options.colorpresets.editName] ~= nil then
			vexpower_SV_colorsets[vexpower.options.colorpresets.editName] = nil
			vexpower.options.colorpresets.statusMsg = "|CFF00FF00Successfully deleted ColorPreset '"..vexpower.options.colorpresets.editName.."'|r"
			vexpower.options.colorpresets.editName = ""
			vexpower.options.colorpresets.saveName = ""
			vexpower.options.colorpresets.createNew()
		else
			vexpower.options.colorpresets.statusMsg = "|CFFC41F3BCouldn't delete ColorPreset '"..vexpower.options.colorpresets.editName.."'.|r Preset doesn't exist"
		end
	end
end

function vexpower.options.colorpresets.load()
	if vexpower_SV_colorsets[vexpower.options.colorpresets.editName] ~= nil then
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"] = vexpower.data.lib.copyTable(vexpower_SV_colorsets[vexpower.options.colorpresets.editName])
		vexpower.options.colorpresets.statusMsg = "|CFF00FF00Successfully loaded ColorPreset '"..vexpower.options.colorpresets.editName.."'|r"
	else
		vexpower.options.colorpresets.statusMsg = "|CFFC41F3BCouldn't load ColorPreset '"..vexpower.options.colorpresets.editName.."'.|r Preset doesn't exist"
	end
end

function vexpower.options.colorpresets.getList(default)
	local returnvalue = {}
	local timer = 0
	for key in pairs(vexpower_SV_colorsets) do
		if default then
			local isSet = false
			local presetFor = ""
			local count = 0
			for class,classdata in pairs(vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["classPresets"]) do
				if key == classdata and vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["classPresets"]["activate"] then
					if count ~= 0 then
						presetFor = presetFor..", "
					end
					presetFor= presetFor.."|CFF"..vexpower.data.lib.getColor.classHex(class)..class.."|r"
					count=count+1
				end
			end
			
			if count==0 then
				returnvalue[key]=key
			else
				returnvalue[key]=key.." ("..presetFor..")"
			end
		else
			returnvalue[key]=key
		end
		timer = timer + 1
	end
	
	if default then
		returnvalue[""]="current"
	elseif not(default) and timer == 0 then
		returnvalue[""] = "No color sets created"
	end
	
	return returnvalue
end

function vexpower.options.colorpresets.gatherData()
	if vexpower_SV_colorsets[vexpower.options.colorpresets.editName] ~= nil and vexpower.options.colorpresets.editName ~= "" then
		vexpower.options.colorpresets.colorset = vexpower.data.lib.copyTable(vexpower_SV_colorsets[vexpower.options.colorpresets.editName])
	else
		vexpower.options.colorpresets.colorset = vexpower.data.lib.copyTable(vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"])
	end
end