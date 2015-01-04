vexpower.options.text.currentTextfield = ""
vexpower.options.text.statusMsg = " "

vexpower.options.text.openTab = {
	["content"] = false,
	["format"] = false,
	["position"] = false,
	["misc"] = false,
	["shadow"] = false,
	}
	
function vexpower.options.text.toggleTab(tab)
	if vexpower.options.text.openTab[tab] ~= nil then
		vexpower.options.text.closeAllTabs()
		vexpower.options.text.openTab[tab] = true
	end
end
	
function vexpower.options.text.closeAllTabs()
	for key in pairs(vexpower.options.text.openTab) do
		vexpower.options.text.openTab[key] = false
	end
end

function vexpower.options.text.create()
	local newname = vexpower.options.text.getNewName()
	vexpower.defaults.singleTextfield["x"], vexpower.defaults.singleTextfield["y"] = vexpower.options.text.getNewPosition()
	vexpower_SV_textfields[vexpower_SV_data["profile"]][newname] = vexpower.data.lib.copyTable(vexpower.defaults.singleTextfield)
	vexpower.options.text.currentTextfield = newname
	vexpower.options.text.statusMsg = "|CFF00FF00New textfield '"..newname.."' created successfully|r"
	vexpower.testmode.textHandler()
end

function vexpower.options.text.getNewPosition()
	local x = 0
	local y = 0
	local x_new = 0
	local y_new = 0
	local x_current = vexpower.defaults.singleTextfield["x"]
	local y_current = vexpower.defaults.singleTextfield["y"]
	local found = false
	local timer = 0
	
	while not(found) do
		if not(vexpower.options.text.checkForExist(x_current+x, y_current+y)) then
			found = true
			x_new = x_current+x
			y_new = y_current+y
		end
		timer = timer + 1
		
		if timer == 1 then
			x = x + 100
		elseif timer == 2 then
			x = x - 200
			
			x = x - 100
		elseif timer == 3 then
			x = x + 200
			
			y = y + 20
		elseif timer == 4 then
			y = y - 20
			
			y = y - 20
		elseif timer == 5 then
			y = y + 20
			
			x = x + 100
			y = y + 20
			timer = 0
		end
	end
	
	return x_new,y_new
end

function vexpower.options.text.checkForExist(x, y)
	local returnvalue = false
	for key,val in pairs(vexpower_SV_textfields[vexpower_SV_data["profile"]]) do
		if val["x"] == x or val["y"] == y then
			returnvalue = true
		end
	end
	return returnvalue
end

function vexpower.options.text.clone()
	if vexpower_SV_textfields[vexpower_SV_data["profile"]][vexpower.options.text.currentTextfield] ~= nil then
		local newname = vexpower.options.text.getNewName()
		vexpower_SV_textfields[vexpower_SV_data["profile"]][newname] = vexpower.data.lib.copyTable(vexpower_SV_textfields[vexpower_SV_data["profile"]][vexpower.options.text.currentTextfield])
		vexpower.options.text.statusMsg = "|CFF00FF00New textfield '"..newname.."' created successfully (Clone of "..vexpower.options.text.currentTextfield..")|r"
		vexpower.options.text.currentTextfield = newname
	else
		vexpower.options.text.statusMsg = "|CFFC41F3BCouldn't clone textfield.|r Textfield '"..vexpower.options.text.currentTextfield.."' doesn't exist"
	end
	vexpower.testmode.textHandler()
end

function vexpower.options.text.delete()
	if vexpower_SV_textfields[vexpower_SV_data["profile"]][vexpower.options.text.currentTextfield] ~= nil then
		vexpower_SV_textfields[vexpower_SV_data["profile"]][vexpower.options.text.currentTextfield] = nil
		vexpower_text[vexpower.options.text.currentTextfield]:Hide()
		vexpower_text[vexpower.options.text.currentTextfield] = nil
		vexpower.options.text.statusMsg = "|CFF00FF00Textfield '"..vexpower.options.text.currentTextfield.."' deleted successfully|r"
		vexpower.options.text.currentTextfield = vexpower.options.text.getFirst()
	else
		vexpower.options.text.statusMsg = "|CFFC41F3BCouldn't delete textfield.|r Textfield '"..vexpower.options.text.currentTextfield.."' doesn't exist"
	end
	vexpower.testmode.textHandler()
end

function vexpower.options.text.getFirst()
	local number = 1
	local found = false
	local exist = false
	
	for key in pairs(vexpower_SV_textfields[vexpower_SV_data["profile"]]) do
		if vexpower_SV_textfields[vexpower_SV_data["profile"]][key] ~= nil then
			exist = true
		end
	end
	
	if exist then
		while not(found) do
			local name = tostring(number)
			if vexpower_SV_textfields[vexpower_SV_data["profile"]][name] ~= nil then
				found = true
			else
				number = number + 1
			end
		end
		return tostring(number)
	else
		return ""
	end
end

function vexpower.options.text.getNewName()
	local number = 1
	local found = false
	while not(found) do
		local name = tostring(number)
		if vexpower_SV_textfields[vexpower_SV_data["profile"]][name] == nil then
			found = true
		else
			number = number + 1
		end
	end
	return tostring(number)
end

function vexpower.options.text.getDisabled()
	if vexpower_SV_textfields[vexpower_SV_data["profile"]][vexpower.options.text.currentTextfield] ~= nil then
		return false
	else
		return true
	end
end

function vexpower.options.text.getList()
	local returnvalue = {}
	local timer = 0
	for key in pairs(vexpower_SV_textfields[vexpower_SV_data["profile"]]) do
		if key ~= "profilelist" then
			returnvalue[key]=key
			timer = timer + 1
		end
	end
	
	if timer == 0 then
		returnvalue[""] = "No textfields created"
	end
	
	return returnvalue
end

function vexpower.options.text.insertTag(text, tag)
	if vexpower_SV_textfields[vexpower_SV_data["profile"]][vexpower.options.text.currentTextfield] ~= nil then
		vexpower_SV_textfields[vexpower_SV_data["profile"]][vexpower.options.text.currentTextfield]["text"] = vexpower_SV_textfields[vexpower_SV_data["profile"]][vexpower.options.text.currentTextfield]["text"].."["..tag.."] "
	end
end

function vexpower.options.text.setdataDirect(data, key)
	if data == "cptext" then
		if key == "POWERBAR" then
			key = false
		else
			key = true
		end
	end
	
	if vexpower_SV_textfields[vexpower_SV_data["profile"]][vexpower.options.text.currentTextfield] ~= nil then
		vexpower_SV_textfields[vexpower_SV_data["profile"]][vexpower.options.text.currentTextfield][data] = key
	end
end

function vexpower.options.text.getdataDirect(data)
	if vexpower_SV_textfields[vexpower_SV_data["profile"]][vexpower.options.text.currentTextfield] ~= nil then
		local temp = vexpower_SV_textfields[vexpower_SV_data["profile"]][vexpower.options.text.currentTextfield][data]
		
		if data == "cptext" then
			if temp == false or temp == nil then
				temp = "POWERBAR"
			else
				temp = "CPSBAR"
			end
		end
		return temp
	end
end

function vexpower.options.text.getDataColor(data)
	if vexpower_SV_textfields[vexpower_SV_data["profile"]][vexpower.options.text.currentTextfield] ~= nil then
		return vexpower_SV_textfields[vexpower_SV_data["profile"]][vexpower.options.text.currentTextfield]["color"][data]
	end
end

function vexpower.options.text.setDataColor(data, key)
	if vexpower_SV_textfields[vexpower_SV_data["profile"]][vexpower.options.text.currentTextfield] ~= nil then
		vexpower_SV_textfields[vexpower_SV_data["profile"]][vexpower.options.text.currentTextfield]["color"][data] = key
	end
end

function vexpower.options.text.getDataShadow(folder, data)
	if vexpower_SV_textfields[vexpower_SV_data["profile"]][vexpower.options.text.currentTextfield] ~= nil then
		if folder == false then
			return vexpower_SV_textfields[vexpower_SV_data["profile"]][vexpower.options.text.currentTextfield]["shadow"][data]
		else
			if folder == "color" and data == "a" then
				return vexpower_SV_textfields[vexpower_SV_data["profile"]][vexpower.options.text.currentTextfield]["shadow"][folder][data]*100
			else
				return vexpower_SV_textfields[vexpower_SV_data["profile"]][vexpower.options.text.currentTextfield]["shadow"][folder][data]
			end
		end
	end
end

function vexpower.options.text.setDataShadow(folder, data, key)
	if vexpower_SV_textfields[vexpower_SV_data["profile"]][vexpower.options.text.currentTextfield] ~= nil then
		if folder == false then
			vexpower_SV_textfields[vexpower_SV_data["profile"]][vexpower.options.text.currentTextfield]["shadow"][data] = key
		else
			vexpower_SV_textfields[vexpower_SV_data["profile"]][vexpower.options.text.currentTextfield]["shadow"][folder][data] = key
		end
	end
end