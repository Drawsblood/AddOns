function vexpower.text.change()
	for key in pairs(vexpower_SV_textfields[vexpower_SV_data["profile"]]) do
		if vexpower.testmode.activated then
			if vexpower_energytext_TestFramesText ~= nil then
				if vexpower_energytext_TestFramesText[key] ~= nil then
					vexpower_energytext_TestFramesText[key]:SetText(vexpower.text.parseTagInfo(vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["text"]))
				end
			end
		else
			if vexpower_text[key] ~= nil then
				vexpower_text[key]:SetText(vexpower.text.parseTagInfo(vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["text"]))
			end
		end
	end
end

function vexpower.text.parseTagInfo(text)
	local percenergy = vexpower.text.getPercEnergy()
	local missingEnergy = vexpower.powerBar.maxPower-vexpower.powerBar.currentPower[1]
	local missingCPs = vexpower.CPBar.maxCPs - vexpower.CPBar.currentCP[1]
	local PowerAltCurrent,PowerAltMax = vexpower.text.getAltPower()
	local time_total, time_left, time_leftShort = vexpower.text.getTimeData()
	
	text = string.gsub(text, "%[PowerCurrent%]", vexpower.powerBar.currentPower[1])
	text = string.gsub(text, "%[PowerCurrentSmart%]", vexpower.text.convertEnergyShort(vexpower.powerBar.currentPower[1], true, vexpower.powerBar.maxPower))
	text = string.gsub(text, "%[PowerCurrentShort%]", vexpower.text.convertEnergyShort(vexpower.powerBar.currentPower[1], false, vexpower.powerBar.maxPower))
	
	text = string.gsub(text, "%[PowerMax%]", vexpower.powerBar.maxPower)
	text = string.gsub(text, "%[PowerMaxSmart%]", vexpower.text.convertEnergyShort(vexpower.powerBar.maxPower, true, vexpower.powerBar.maxPower))
	text = string.gsub(text, "%[PowerMaxShort%]", vexpower.text.convertEnergyShort(vexpower.powerBar.maxPower, false, vexpower.powerBar.maxPower))
	
	text = string.gsub(text, "%[PowerMissing%]", missingEnergy)
	text = string.gsub(text, "%[PowerMissingSmart%]", vexpower.text.convertEnergyShort(missingEnergy, true, vexpower.powerBar.maxPower))
	text = string.gsub(text, "%[PowerMissingShort%]", vexpower.text.convertEnergyShort(missingEnergy, false, vexpower.powerBar.maxPower))
	
	text = string.gsub(text, "%[PowerPerc%]", vexpower.text.convertEnergyShort(percenergy, false, 100))
	text = string.gsub(text, "%[PowerPercSmart%]", vexpower.text.convertEnergyShort(percenergy, true, 100))
	
	text = string.gsub(text, "%[TimeTotal%]", time_total)
	text = string.gsub(text, "%[TimeLeft%]", time_left)
	text = string.gsub(text, "%[TimeLeftShort%]", time_leftShort)
		
	text = string.gsub(text, "%[PowerAltCurrent%]", vexpower.text.deleteZero(PowerAltCurrent))
	text = string.gsub(text, "%[PowerAltMax%]", vexpower.text.deleteZero(PowerAltMax))
	
	text = string.gsub(text, "%[CPsCurrent%]", vexpower.text.getCurrentCPs())
	text = string.gsub(text, "%[CPsMax%]", tostring(vexpower.CPBar.maxCPs))
	text = string.gsub(text, "%[CPsMissing%]", tostring(missingCPs))
	return text
end

function vexpower.text.getTimeData()
	local time_total, time_left, time_leftShort
	
	if vexpower.data.classString == "MAGE" and vexpower.data.specID == 62 then
		time_total = vexpower.text.getTimeDebuff("total")
		time_left = vexpower.text.getTimeDebuff("left")
	elseif vexpower.data.classString == "PALADIN" or vexpower.data.classString == "MONK" then
		time_total = 10
		if GetTime()-vexpower.data.inFight.timestamp >= time_total or vexpower.data.inFight.undelayed or vexpower.CPBar.currentCP[1]==0 then
			time_left = 0
		else
			time_left = time_total-GetTime()+vexpower.data.inFight.timestamp
			if time_left >= 10 then
				time_left = string.sub(time_left, 1,4)
			elseif time_left < 10 and time_left > 0 then
				time_left = string.sub(time_left, 1,3)
			end
		end
	else
		time_total = vexpower.text.getTimeBuff("total")
		time_left = vexpower.text.getTimeBuff("left")
	end
	
	time_total = vexpower.text.deleteZero(time_total)
	time_left = vexpower.text.deleteZero(time_left)
	time_leftShort = vexpower.text.convertTimeShort(vexpower.text.convertTimeShort(time_left))
	
	return time_total, time_left, time_leftShort
end

function vexpower.text.convertTimeShort(amount)
	if string.find(amount, "%.") ~= nil then
		amount = string.gsub(amount, "%.%d+$", "")
		amount = tonumber(amount)+1
		return tostring(amount)
	else
		return amount
	end
end

function vexpower.text.getTimeDebuff(type)
	local returnvalue = ""
	local auraid = vexpower.CPBar.getSpecAuraID()
	
	if auraid ~= 0 and not(vexpower.testmode.activated) then
		local buffname = select(1, GetSpellInfo(auraid))
		if UnitDebuff("player", buffname) ~= nil then
			if type == "total" then
					returnvalue = tostring(select(6, UnitDebuff("player", buffname)))
			elseif type == "left" then
				local expire = select(7, UnitDebuff("player", buffname))
				local left = expire-GetTime()
				if left >= 10 then
					left = string.sub(left, 1,4)
					returnvalue = tostring(left)
				elseif left < 10 and left > 0 then
					left = string.sub(left, 1,3)
					returnvalue = tostring(left)
				end
			end
		end
	end
	
	return returnvalue
end

function vexpower.text.getTimeBuff(type)
	local returnvalue = ""
	local auraid = vexpower.CPBar.getSpecAuraID()
	
	if auraid ~= 0 and not(vexpower.testmode.activated) then
		local buffname = select(1, GetSpellInfo(auraid))
		if UnitBuff("player", buffname) ~= nil then
			if type == "total" then
					returnvalue = tostring(select(6, UnitBuff("player", buffname)))
			elseif type == "left" then
				local expire = select(7, UnitBuff("player", buffname))
				local left = expire-GetTime()
				if left >= 10 then
					left = string.sub(left, 1,4)
					returnvalue = tostring(left)
				elseif left < 10 and left > 0 then
					left = string.sub(left, 1,3)
					returnvalue = tostring(left)
				end
			end
		end
	end
	
	return returnvalue
end

function vexpower.text.getPercEnergy()
	local percenergy = 0
	if vexpower.powerBar.maxPower ~= 0 then
		percenergy = (vexpower.powerBar.currentPower[1]/vexpower.powerBar.maxPower)*100
	end
	return percenergy
end

function vexpower.text.getCurrentCPs()	
	if vexpower.data.classString == "WARLOCK" and vexpower.data.specID == 267 then
		local count = 0
		for i in ipairs(vexpower.powerBar.alt.frames.bar) do
			if vexpower.powerBar.alt.currentPower[1][i] == vexpower.powerBar.alt.maxPower[1][i] then
				count = count + 1
			end
		end
		return count
	elseif vexpower.data.classString == "WARLOCK" and vexpower.data.specID == 266 then
		return ""
	else
		return tostring(vexpower.CPBar.currentCP[1])
	end
end

function vexpower.text.getAltPower()
	local PowerAltCurrent = ""
	local PowerAltMax = ""
	
	if vexpower.data.classString == "WARLOCK" and vexpower.data.specID == 267 then
		PowerAltCurrent = 0
		for i in ipairs(vexpower.powerBar.alt.frames.bar) do
			if vexpower.powerBar.alt.currentPower[1][i] ~= nil then
				
				PowerAltCurrent = PowerAltCurrent + vexpower.powerBar.alt.currentPower[1][i]
			end
		end
		if PowerAltCurrent ~= 0 then
			PowerAltMax = vexpower.powerBar.alt.maxPower[1][1]
			local temp = tostring(tonumber(PowerAltCurrent)/tonumber(PowerAltMax))
			if temp == "0" then
				PowerAltCurrent = "0"
			elseif string.find(temp, "%.") == nil then
				PowerAltCurrent = PowerAltMax
			else
				PowerAltCurrent = string.gsub(temp, "^%d+%.", "")
			end
		end
	elseif vexpower.data.classString == "WARLOCK" and vexpower.data.specID == 266 then
		PowerAltMax = vexpower.powerBar.alt.maxPower[1][1]
		PowerAltCurrent = vexpower.powerBar.alt.currentPower[1][1]
	end
	return PowerAltCurrent, PowerAltMax
end

function vexpower.text.deleteZero(text)
	if text == 0 or text == "0" then
		return ""
	else
		return tostring(text)
	end
end

function vexpower.text.convertEnergyShort(amount, smart, maximum)
	local returnvalue = ""
	if maximum < 1000 then
		amount = amount*1000
	end
	if smart then
		amount = tonumber(amount)/100
		amount = vexpower.text.ceilNumber(tonumber(amount))
		amount = tostring(amount / 10)
		if string.find(amount, "%.") == nil then
			amount = amount..".0"
		end
		returnvalue = amount
	else
		amount = tonumber(amount)/1000
		amount = vexpower.text.ceilNumber(tonumber(amount))
		returnvalue = tostring(amount)
	end
	return returnvalue
end

function vexpower.text.ceilNumber(amount)
	local returnvalue = ""
	amount = tostring(amount)
	if string.find(amount, "%.") ~= nil then
		local amount_l = string.gsub(amount, "%.%d+$", "")
		local amount_r = string.gsub(amount, "^%d+%.", "0.")
		amount_l = tonumber(amount_l)
		amount_r = tonumber(amount_r)
		if amount_r >= 0.5 then
			amount_l = amount_l+1
		end
		returnvalue = amount_l
	else
		returnvalue = tonumber(amount)
	end
	return returnvalue
end

function vexpower.text.setPowerTextbar()
	vexpower.powerBar.frames.textbars:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8", edgeFile="Interface\\Buttons\\WHITE8X8", tile=false, edgeFile="Interface\\Buttons\\WHITE8X8", edgeSize=1})
	vexpower.powerBar.frames.textbars:SetBackdropColor(0, 0, 0, 0)
	vexpower.powerBar.frames.textbars:SetBackdropBorderColor(1,1,1,0)
	vexpower.powerBar.frames.textbars:SetWidth(vexpower.powerBar.maxWidth)
	vexpower.powerBar.frames.textbars:SetFrameStrata(vexpower.options.strata.convertValues(vexpower.options.strata.getTextfieldValue()))
	vexpower.powerBar.frames.textbars:SetHeight(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["size"]["height"]-(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["size"]*2))
	vexpower.powerBar.frames.textbars:ClearAllPoints()
	vexpower.powerBar.frames.textbars:SetPoint("TOPLEFT", vexpower.powerBar.frames.barBG, "TOPLEFT",
						vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["size"],
						-vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["size"])
end

function vexpower.text.setCPTextbar()
	vexpower_CPsTextbar:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8", edgeFile="Interface\\Buttons\\WHITE8X8", tile=false, edgeFile="Interface\\Buttons\\WHITE8X8", edgeSize=1})
	vexpower_CPsTextbar:SetBackdropColor(0, 0, 0, 0)
	vexpower_CPsTextbar:SetBackdropBorderColor(1,1,1,0)
	vexpower_CPsTextbar:SetWidth(vexpower.powerBar.maxWidth)
	vexpower_CPsTextbar:SetFrameStrata(vexpower.options.strata.convertValues(vexpower.options.strata.getTextfieldValue()))
	vexpower_CPsTextbar:SetHeight(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["size"]["height"]-(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["size"]*2))
	vexpower_CPsTextbar:ClearAllPoints()
	vexpower_CPsTextbar:SetPoint("TOPLEFT", vexpower.powerBar.frames.barBG, "TOPLEFT",
						vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["size"],
						-vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["size"])
end

function vexpower.text.setFontstrings()
	for key in pairs(vexpower_text) do
		if vexpower_text[key] ~= nil then
			vexpower_text[key]:Hide()
		end
	end
	for key in pairs(vexpower_SV_textfields[vexpower_SV_data["profile"]]) do
		if vexpower_text[key] ~= nil then
			vexpower_text[key]:Show()
			vexpower_text[key]:ClearAllPoints()
			vexpower_text[key]:SetPoint(
				vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["anchor"],
				"vexpower.powerBar.frames.textbars",
				vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["anchor2"],
				vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["x"],
				vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["y"])
			vexpower_text[key]:SetTextColor(vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["color"]["r"],
													vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["color"]["g"],
													vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["color"]["b"],
													vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["color"]["a"])
			vexpower_text[key]:SetFont(vexpower.LSM:Fetch("font", vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["font"]),
											vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["size"],
											vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["effect"])	
			vexpower_text[key]:SetWidth(vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["width"])	
			vexpower_text[key]:SetJustifyH(vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["align"])
			if vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["shadow"]["allow"] then	
				vexpower_text[key]:SetShadowColor(vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["shadow"]["color"]["r"],
													vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["shadow"]["color"]["g"],
													vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["shadow"]["color"]["b"],
													vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["shadow"]["color"]["a"])
				vexpower_text[key]:SetShadowOffset(vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["shadow"]["offset"]["x"],
													vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["shadow"]["offset"]["y"])
			else
				vexpower_text[key]:SetShadowColor(0, 0, 0, 0)
				vexpower_text[key]:SetShadowOffset(0, 0)
			end
		end
	end	
end	

function vexpower.text.createFontstrings()
	if vexpower_text == nil then
		vexpower_text = {}
	end
	for key in pairs(vexpower_SV_textfields[vexpower_SV_data["profile"]]) do
		if vexpower_text[key] == nil then
			if vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["cptext"] == nil then
				vexdebugs.print('vexpower_SV_textfields['..vexpower_SV_data["profile"]..']['..key..']',vexpower_SV_textfields[vexpower_SV_data["profile"]][key])
			end
			if vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["cptext"] then 
				vexpower_text[key] = vexpower_CPsTextbar:CreateFontString("vexpower_text["..key.."]", "OVERLAY", "GameFontNormal")
			else
				vexpower_text[key] = vexpower.powerBar.frames.textbars:CreateFontString("vexpower_text["..key.."]", "OVERLAY", "GameFontNormal")
			end
		end
	end
end