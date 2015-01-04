vexpower.options.profiles.currentProfile = GetRealmName().."-"..select(1, UnitName("player"))
vexpower.options.profiles.statusMsg = " "
vexpower.options.profiles.statusMsgAdd = " "

function vexpower.options.profiles.checkForExist()
	if vexpower_SV_profiles[vexpower.options.profiles.currentProfile] ~= nil then
		return true
	else
		return false
	end
end

function vexpower.options.profiles.add()
	local key = vexpower.options.profiles.currentProfile
	if vexpower.options.profiles.checkName(key) then
		local exists = false
		if vexpower_SV_profiles[key] ~= nil then
			exists = true
		end
		vexpower_SV_profiles[key] = vexpower.data.lib.copyTable(vexpower_SV_profiles[vexpower_SV_data["profile"]])
		vexpower_SV_markers_specBoth[key] = vexpower.data.lib.copyTable(vexpower_SV_markers_specBoth[vexpower_SV_data["profile"]])
		vexpower_SV_markers_specA[key] = vexpower.data.lib.copyTable(vexpower_SV_markers_specA[vexpower_SV_data["profile"]])
		vexpower_SV_markers_specB[key] = vexpower.data.lib.copyTable(vexpower_SV_markers_specB[vexpower_SV_data["profile"]])
		vexpower_SV_textfields[key] = vexpower.data.lib.copyTable(vexpower_SV_textfields[vexpower_SV_data["profile"]])
		
		vexpower_SV_data["profile"] = key
		if exists then
			vexpower.options.profiles.statusMsgAdd = "|CFF00FF00Successfully updated profile '"..key.."'|r"
			vexpower.options.profiles.statusMsg = " "
		else
			vexpower.options.profiles.statusMsgAdd = "|CFF00FF00Successfully saved profile '"..key.."'|r"
			vexpower.options.profiles.statusMsg = " "
		end
	else
		vexpower.options.profiles.statusMsgAdd = "|CFFC41F3BCouldn't save profile '"..key.."'.|r Profile name is invalid."
		vexpower.options.profiles.statusMsg = " "
	end
end

-- function vexpower.options.profiles.update()
	-- local key = vexpower.options.profiles.currentProfile
	-- if vexpower.options.profiles.checkName(key) then
		-- vexpower_SV_profiles[key] = vexpower.data.lib.copyTable(vexpower_SV_profiles[vexpower_SV_data["profile"]])
		-- vexpower.options.profiles.statusMsg = "|CFF00FF00Successfully updated profile '"..key.."'|r"
		-- vexpower.options.profiles.statusMsgAdd = " "
	-- else
		-- vexpower.options.profiles.statusMsg = "|CFFC41F3B\n\nCouldn't update profile '"..key.."'.|r Profile name is invalid."
		-- vexpower.options.profiles.statusMsgAdd = " "
	-- end
-- end

function vexpower.options.profiles.getList(default)
	local returnvalue = {}
	local timer = 0
	for key in pairs(vexpower_SV_profiles) do
		if key ~= "" then
			if key == vexpower_SV_globalData["profile"] and default then
				returnvalue[key]=key.." |CFF00FF00(Global default)|r"
			else
				returnvalue[key]=key
			end
			timer = timer + 1
		end
	end
	
	if timer == 0 then
		returnvalue[""] = "No profiles created"
	end
	
	return returnvalue
end

function vexpower.options.profiles.checkName(val)
	local returnvalue = false
	-- local val_edited = val
	-- local legal_symbols = {"%a", "%(", "%)", ":", "%.", ",", " ", "-"}
	-- for i,val in ipairs(legal_symbols) do
		-- val_edited = string.gsub(val_edited, val, "")
	-- end
	-- if val_edited == "" then
		-- returnvalue = true
	-- end
	if val == "" then
		returnvalue = false
	else
		returnvalue = true	-- XXX
	end
	return returnvalue
end

function vexpower.options.profiles.delete(key)
	local key = vexpower.options.profiles.currentProfile
	if vexpower_SV_globalData["profile"] == key then
		vexpower.options.profiles.statusMsg = "|CFFC41F3B\n\nCouldn't delete profile '"..key.."'.|r Global-Profiles can't be deleted."
		vexpower.options.profiles.statusMsgAdd = " "
	elseif vexpower_SV_data["profile"] == key then
		vexpower.options.profiles.statusMsg = "|CFFC41F3B\n\nCouldn't delete profile '"..key.."'.|r Can't delete currently used profile."
		vexpower.options.profiles.statusMsgAdd = " "
	elseif vexpower_SV_profiles[key] ~= nil then
		vexpower_SV_profiles[key] = nil
		vexpower_SV_markers_specBoth[key] = nil
		vexpower_SV_markers_specA[key] = nil
		vexpower_SV_markers_specB[key] = nil
		vexpower_SV_textfields[key] = nil
		vexpower.options.profiles.currentProfile = GetRealmName().." "..select(1, UnitName("player"))
		vexpower.options.profiles.statusMsg = "|CFF00FF00Successfully deleted profile '"..key.."'|r"
		vexpower.options.profiles.statusMsgAdd = " "
	else
		vexpower.options.profiles.statusMsg = "|CFFC41F3B\n\nCouldn't delete profile '"..key.."'.|r Profile doesn't exist."
		vexpower.options.profiles.statusMsgAdd = " "
	end
end

function vexpower_optionTab_Profiles_load()
	local key = vexpower.options.profiles.currentProfile
	if vexpower_SV_profiles[key] ~= nil then
		vexpower_SV_data["profile"] = key
		vexpower.options.profiles.statusMsg = "|CFF00FF00Successfully loaded profile '"..key.."'|r"
		if vexpower_SV_data["specProfile"]["activate"] then
			vexpower_SV_data["specProfile"]["activate"] = false
			vexpower.options.profiles.statusMsg = vexpower.options.profiles.statusMsg.." |CFFC41F3BWarning|r: Spec-Profiles deactivated!"
		end
		vexpower.options.profiles.statusMsgAdd = " "
	else
		vexpower.options.profiles.statusMsg = "|CFFC41F3B\n\nCouldn't load profile '"..key.."'.|r Profile doesn't exist."
		vexpower.options.profiles.statusMsgAdd = " "
	end
end