function vexpower.testmode.handler()
	if vexpower.testmode.activated then
		vexpower.powerBar.frames.textbars:Hide()
		vexpower_CPsTextbar:Hide()
	else
		vexpower.powerBar.frames.textbars:Show()
		vexpower_CPsTextbar:Show()
	end
	vexpower.testmode.aniStarter()
	vexpower.testmode.textHandler()
	vexpower.CPBar.toggleBGColor()
	vexpower.mainframe.setMovable(vexpower.testmode.activated)
	vexpower.CPBar.setMovable(vexpower.testmode.activated)
	vexpower.testmode.toggleCPBGs()
	vexpower.testmode.window.toggle()
end

-- =======================
-- =====POWERBAR AND CPs==
-- =======================
function vexpower.testmode.aniStarter()
	if vexpower.testmode.activated then
		local anigrp, ani = vexpower.lib.getTimer("vexpower_Testmode_Auto_ani", 0.1, function () vexpower.testmode.aniHandler() vexpower.testmode.aniStarter() end)
	end
end

function vexpower.testmode.toggleCPBGs()
	if vexpower_Testmode_createdCPBGs == nil then
		vexpower_Testmode_createdCPBGs = {}
	end
	vexpower.testmode.nukeCPBGs()
	if vexpower.testmode.activated then
		vexpower.testmode.createCPBGs()
	end
end

function vexpower.testmode.nukeCPBGs()
	for i,val in ipairs(vexpower_Testmode_createdCPBGs) do
		if val ~= nil then
			if val[1]~= nil then
				val[1]:Hide()
				vexpower_Testmode_createdCPBGs[i] = nil
			end
		end
	end
end

function vexpower.testmode.saveCPPosition(key)
	local maxCPs = vexpower.options.cps.configCPSetting
	local i = tonumber(key)
	if vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][maxCPs] ~= nil then
		if vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][maxCPs][key] ~= nil then
			vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][maxCPs][key]["anchor"] = select(1, vexpower_Testmode_createdCPBGs[i][1]:GetPoint())
			vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][maxCPs][key]["anchorFrame"] = select(3, vexpower_Testmode_createdCPBGs[i][1]:GetPoint())
			vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][maxCPs][key]["x"] = select(4, vexpower_Testmode_createdCPBGs[i][1]:GetPoint())
			vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][maxCPs][key]["y"] = select(5, vexpower_Testmode_createdCPBGs[i][1]:GetPoint())
		end
	end
end

function vexpower.testmode.createCPBGs()
	local maxCPs = vexpower.options.cps.configCPSetting
	if not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["intMode"]["activate"]) then
		for i=1, tonumber(maxCPs) do
			--Frame
			local frame = CreateFrame("Frame", nil, vexpower.CPBar.mainframe)
			
			frame:SetBackdrop({
				bgFile="Interface\\Buttons\\WHITE8X8",
				edgeFile="Interface\\Buttons\\WHITE8X8", tile=false,
				edgeSize=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["border"]["size"]})
			local bg = {math.random(), math.random(), math.random()}
			local border = {bg[1] + 0.5, bg[2] + 0.5, bg[3] + 0.5}
			if border[1] > 1 then border[1] = border[1] - 1 end
			if border[2] > 1 then border[2] = border[2] - 1 end
			if border[3] > 1 then border[3] = border[3] - 1 end
			frame:SetBackdropColor(bg[1], bg[2], bg[3], 0.3)
			frame:SetBackdropBorderColor(border[1], border[2], border[3], 1)
			
			if vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][maxCPs] ~= nil then
				frame:SetHeight(vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][maxCPs]["height"])
				frame:SetWidth(vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][maxCPs]["width"])
				frame:ClearAllPoints()
				frame:SetPoint(
					vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][maxCPs][tostring(i)]["anchor"],
					vexpower.CPBar.mainframe,
					vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][maxCPs][tostring(i)]["anchorFrame"],
					vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][maxCPs][tostring(i)]["x"],
					vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["altPositioning"][maxCPs][tostring(i)]["y"])
				frame:Show()
			else
				frame:Hide()
			end
			
			frame:RegisterForDrag("LeftButton")
			frame:SetScript("OnDragStart", function ()
				frame:StartMoving()
				end)
			frame:SetScript("OnDragStop", function (self)
				self:StopMovingOrSizing()
				local x1, y1 = self:GetLeft(), self:GetTop()
				local x2, y2 = self:GetParent():GetLeft(), self:GetParent():GetTop()
				self:ClearAllPoints()
				self:SetPoint("TOPLEFT", self:GetParent(), "TOPLEFT", x1 - x2, y1 - y2)
				
				vexpower.testmode.saveCPPosition(tostring(i))
				vexpower.CPBar.setBars()
				end)
			frame:EnableMouse(true)
			frame:SetMovable(true)
			
			
			--FontString
			local fontstring = frame:CreateFontString("vexpower_Testmode_createCPBGsFontstrong["..i.."]", "OVERLAY", "GameFontNormal")
			fontstring:Show()
			fontstring:ClearAllPoints()
			fontstring:SetPoint("CENTER", frame, "CENTER", 0, 0)
			fontstring:SetTextColor(border[1], border[2], border[3], 1)
			fontstring:SetFont(vexpower.LSM:Fetch("font", "Friz Quadrata TT"),"14","OUTLINE")
			fontstring:SetText("- "..tostring(i).." -")
			vexpower_Testmode_createdCPBGs[i] = {}
			vexpower_Testmode_createdCPBGs[i][1] = frame
			vexpower_Testmode_createdCPBGs[i][2] = fontstring
		end
	end
end


function vexpower.testmode.aniHandler()
	if vexpower.testmode.activated then
		if vexpower.testmode.changePower() then
			vexpower.testmode.changeCPs()
			vexpower.testmode.changeAltPower()
		end
		vexpower.text.change()
	end
end

function vexpower.testmode.changeCPs()
	if vexpower.CPBar.maxCPs>0 then
		if not(vexpower.powerBar.alt.show) then
			if vexpower.CPBar.currentCP[1] >= vexpower.CPBar.maxCPs then
				vexpower.CPBar.handler(-vexpower.CPBar.maxCPs)
			else
				vexpower.CPBar.handler(1)
			end
		end
	end
end

function vexpower.testmode.changeAltPower()
	if vexpower.CPBar.maxCPs>0 then
		if vexpower.powerBar.alt.show then
			local gain = 0
			local loss = 0
			if vexpower.data.classString == "WARLOCK" and vexpower.data.specID == 266 then
				gain = 50
				loss = -250
			elseif vexpower.data.classString == "WARLOCK" and vexpower.data.specID == 267 then
				gain = 1
				loss = -10
			end
			for i in ipairs(vexpower.powerBar.alt.frames.bar) do
				if vexpower.powerBar.alt.currentPower[1][i] == vexpower.powerBar.alt.maxPower[1][i] then
					vexpower.powerBar.alt.handler(i, loss)
				elseif vexpower.powerBar.alt.currentPower[1][i]+gain > vexpower.powerBar.alt.maxPower[1][i] then
					vexpower.powerBar.alt.handler(i, vexpower.powerBar.alt.maxPower[1][i]-vexpower.powerBar.alt.currentPower[1][i])
				else
					vexpower.powerBar.alt.handler(i, gain)
				end
			end
		end
	end
end

function vexpower.testmode.changePower()
	local energychange = 0	
	local gained = false
	local gain = math.floor(vexpower.powerBar.maxPower/50)
	local loss = math.floor(-(4*vexpower.powerBar.maxPower)/10)
	
	if vexpower.powerBar.currentPower[1] == vexpower.powerBar.maxPower then
		vexpower.powerBar.handler(false, loss)
	elseif vexpower.powerBar.currentPower[1]+gain > vexpower.powerBar.maxPower then
		vexpower.powerBar.handler(false, vexpower.powerBar.maxPower-vexpower.powerBar.currentPower[1])
		gained = true
	else
		vexpower.powerBar.handler(false, gain)
		gained = true
	end
	
	return not(gained)
end





-- =======================
-- =====TEXT==============
-- =======================
function vexpower.testmode.textHandler()
	vexpower.testmode.nukeTextframes()
	
	if vexpower.testmode.activated then
		vexpower.testmode.createTextframes()
	end
end

function vexpower.testmode.createTextframes()
	for key in pairs(vexpower_SV_textfields[vexpower_SV_data["profile"]]) do
		if vexpower_SV_textfields[vexpower_SV_data["profile"]][key] ~= nil then
			if vexpower_energytext_TestFrames == nil then
				vexpower_energytext_TestFrames = {}
			end
			if vexpower_energytext_TestFramesText == nil then
				vexpower_energytext_TestFramesText = {}
			end
			
			--Frame
			vexpower_energytext_TestFrames[key] = CreateFrame("Frame", nil, vexpower.powerBar.frames.barBG)
			vexpower_energytext_TestFrames[key]:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8", tile=false, edgeFile="Interface\\Buttons\\WHITE8X8", edgeSize=1})
			local bg = {math.random(), math.random(), math.random()}
			local border = {bg[1] + 0.5, bg[2] + 0.5, bg[3] + 0.5}
			if border[1] > 1 then border[1] = border[1] - 1 end
			if border[2] > 1 then border[2] = border[2] - 1 end
			if border[3] > 1 then border[3] = border[3] - 1 end
			vexpower_energytext_TestFrames[key]:SetBackdropColor(bg[1], bg[2], bg[3], 1)
			vexpower_energytext_TestFrames[key]:SetBackdropBorderColor(border[1], border[2], border[3], 1)
			vexpower_energytext_TestFrames[key]:SetWidth(vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["width"])
			vexpower_energytext_TestFrames[key]:SetHeight(vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["size"])
			vexpower_energytext_TestFrames[key]:SetFrameStrata("DIALOG")
			vexpower_energytext_TestFrames[key]:ClearAllPoints()
			vexpower_energytext_TestFrames[key]:SetPoint(
				vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["anchor"],
				"vexpower.powerBar.frames.textbars",
				vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["anchor2"],
				vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["x"],
				vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["y"])
			
			vexpower_energytext_TestFrames[key]:RegisterForDrag("LeftButton")
			vexpower_energytext_TestFrames[key]:SetScript("OnDragStart", function ()
				vexpower_energytext_TestFrames[key]:StartMoving()
				end)
			vexpower_energytext_TestFrames[key]:SetScript("OnDragStop", function (self)
				self:StopMovingOrSizing()
				local x1, y1 = self:GetLeft(), self:GetTop()
				local x2, y2 = self:GetParent():GetLeft(), self:GetParent():GetTop()
				self:ClearAllPoints()
				self:SetPoint("TOPLEFT", self:GetParent(), "TOPLEFT", x1 - x2, y1 - y2)
				vexpower.testmode.saveTextPosition(key)
				vexpower.text.setFontstrings()
				end)
			vexpower_energytext_TestFrames[key]:EnableMouse(true)
			vexpower_energytext_TestFrames[key]:SetMovable(true)
			
			
			--FontString
			vexpower_energytext_TestFramesText[key] = vexpower_energytext_TestFrames[key]:CreateFontString("vexpower_energytext_TestFramesText["..key.."]", "OVERLAY", "GameFontNormal")
			vexpower_energytext_TestFramesText[key]:Show()
			vexpower_energytext_TestFramesText[key]:ClearAllPoints()
			vexpower_energytext_TestFramesText[key]:SetPoint("CENTER", vexpower_energytext_TestFrames[key], "CENTER", 0, 0)
			vexpower_energytext_TestFramesText[key]:SetTextColor(vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["color"]["r"],
													vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["color"]["g"],
													vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["color"]["b"],
													vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["color"]["a"])
			vexpower_energytext_TestFramesText[key]:SetFont(vexpower.LSM:Fetch("font", vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["font"]),
											vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["size"],
											vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["effect"])	
			vexpower_energytext_TestFramesText[key]:SetWidth(vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["width"])	
			vexpower_energytext_TestFramesText[key]:SetJustifyH(vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["align"])
			if vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["shadow"]["allow"] then	
				vexpower_energytext_TestFramesText[key]:SetShadowColor(vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["shadow"]["color"]["r"],
													vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["shadow"]["color"]["g"],
													vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["shadow"]["color"]["b"],
													vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["shadow"]["color"]["a"])
				vexpower_energytext_TestFramesText[key]:SetShadowOffset(vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["shadow"]["offset"]["x"],
													vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["shadow"]["offset"]["y"])
			else
				vexpower_energytext_TestFramesText[key]:SetShadowColor(0, 0, 0, 0)
				vexpower_energytext_TestFramesText[key]:SetShadowOffset(0, 0)
			end
			vexpower_energytext_TestFramesText[key]:SetText(vexpower.text.parseTagInfo(vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["text"]))
		end
	end
end

function vexpower.testmode.nukeTextframes()
	if vexpower_energytext_TestFrames~= nil then
		for key in pairs(vexpower_energytext_TestFrames) do
			if vexpower_energytext_TestFrames[key]~= nil then
				vexpower_energytext_TestFrames[key]:Hide()
				vexpower_energytext_TestFrames[key] = nil
			end
		end
	end
end

function vexpower.testmode.saveTextPosition(key)
	vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["anchor"] =  select(1, vexpower_energytext_TestFrames[key]:GetPoint())
	vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["anchor2"] =  select(3, vexpower_energytext_TestFrames[key]:GetPoint())
	vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["x"] =  select(4, vexpower_energytext_TestFrames[key]:GetPoint())-vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["size"]
	vexpower_SV_textfields[vexpower_SV_data["profile"]][key]["y"] =  select(5, vexpower_energytext_TestFrames[key]:GetPoint())+vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["size"]
end