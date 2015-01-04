function vexpower.powerBar.alt.handler(number, newenergy)
	local hideIt = false
	if vexpower.CPBar.show then
		vexpower.powerBar.alt.frames.bar[number][1]:Show()
		if not(vexpower.powerBar.alt.frames.bar[number][2]:IsPlaying()) then
			if newenergy ~= nil then
				vexpower.powerBar.alt.currentPower[2][number] = vexpower.powerBar.alt.currentPower[1][number]
				vexpower.powerBar.alt.currentPower[1][number] = vexpower.powerBar.alt.currentPower[1][number] + newenergy
			else
				vexpower.powerBar.alt.setCurrentPower(number)
			end
				
			vexpower.powerBar.alt.setMaxPower(number)
			
			local maxenergy = vexpower.powerBar.alt.maxPower[1][number]
			
			if maxenergy == 0 then maxenergy = 1 end
			
			local barfactor_current = vexpower.powerBar.alt.currentPower[2][number]/maxenergy
			local barfactor_new = vexpower.powerBar.alt.currentPower[1][number]/maxenergy
			local barfactor = 0
			
			if barfactor_current ~= 0 then 
				barfactor = barfactor_new/barfactor_current
			end
			
			local newWidth = vexpower.powerBar.alt.getWidth(number, vexpower.powerBar.alt.currentPower[1][number])
			if newWidth == 0 then 
				newWidth = 1
				hideIt = true
			end
						
			--if barfactor < 1 and barfactor > 0 then
			if barfactor < 1 then
				local oldWidth = vexpower.powerBar.alt.getWidth(number, vexpower.powerBar.alt.currentPower[2][number])
				local difWidth = oldWidth - newWidth
				vexpower.powerBar.alt.frames.bar[number][3]:SetScale(barfactor, 1)
				
				if hideIt then
					vexpower.powerBar.alt.frames.bar[number][2]:SetScript("OnPlay", function () end)
					vexpower.powerBar.alt.frames.bar[number][2]:SetScript("onFinished",
						function ()
						vexpower.powerBar.alt.frames.bar[number][1]:SetWidth(newWidth)
						vexpower.powerBar.alt.frames.bar[number][1]:Hide()
						end)
				else
					vexpower.powerBar.alt.frames.bar[number][2]:SetScript("OnPlay", function () vexpower.powerBar.alt.frames.bar[number][1]:Show() end)
					vexpower.powerBar.alt.frames.bar[number][2]:SetScript("onFinished",
						function ()
						vexpower.powerBar.alt.frames.bar[number][1]:SetWidth(newWidth)
						end)
				end
				
				vexpower.powerBar.alt.frames.bar[number][2]:Play()
				
				if oldWidth<=vexpower.powerBar.alt.maxWidth[number] then
					vexpower.powerBar.alt.frames.barDif[number][1]:SetWidth(difWidth)
					vexpower.powerBar.alt.frames.barDif[number][1]:ClearAllPoints()
						
					vexpower.powerBar.alt.frames.barDif[number][1]:SetPoint("TOPLEFT", vexpower.powerBar.alt.frames.barBG[number], "TOPLEFT",
						vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["border"]["size"]+newWidth,
						-vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["border"]["size"])
					if vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["usedEffect"]["activate"] then
						vexpower.powerBar.alt.frames.barDif[number][2]:Play()
					else
						vexpower.powerBar.alt.frames.barDif[number][1]:Hide()
					end
				else
					vexpower.powerBar.alt.frames.barDif[number][1]:Hide()
				end
			else 
				vexpower.powerBar.alt.frames.bar[number][1]:SetWidth(newWidth)
			end
		end
	end
end

function vexpower.powerBar.alt.setMaxPower(number)
	local new = 0
	if vexpower.data.classString == "WARLOCK" and vexpower.data.specID == 266 then
		new = UnitPowerMax("player", 15)
	elseif vexpower.data.classString == "WARLOCK" and vexpower.data.specID == 267 then
		new = 10
	end
	
	if new ~= vexpower.powerBar.alt.maxPower[1][number] then
		vexpower.powerBar.alt.maxPower[2][number] = vexpower.powerBar.alt.maxPower[1][number]
		vexpower.powerBar.alt.maxPower[1][number] = new
	end
end

function vexpower.powerBar.alt.getCurrentPower(number)
	local returnvalue = 0
	if vexpower.data.classString == "WARLOCK" and vexpower.data.specID == 266 then
		returnvalue = UnitPower("player", 15)
	elseif vexpower.data.classString == "WARLOCK" and vexpower.data.specID == 267 then
		returnvalue = UnitPower("player", 14, true)
		returnvalue = returnvalue - ((number-1)*10)
		if returnvalue < 0 then
			returnvalue = 0
		elseif returnvalue > 10 then
			returnvalue = 10
		end
	end
	return returnvalue
end

function vexpower.powerBar.alt.setCurrentPower(number)	
	local new = vexpower.powerBar.alt.getCurrentPower(number)
	if new ~= vexpower.powerBar.alt.currentPower[1][number] then
		vexpower.powerBar.alt.currentPower[2][number] = vexpower.powerBar.alt.currentPower[1][number]
		vexpower.powerBar.alt.currentPower[1][number] = new
	end
end

function vexpower.powerBar.alt.getWidth(number, energy)
	local width = 0
	if vexpower.powerBar.alt.maxPower[1][number]~=0 then
		width = (energy / vexpower.powerBar.alt.maxPower[1][number]) * vexpower.powerBar.alt.maxWidth[number]
	end
	if width == 0 and vexpower.data.specID ~= 267 then width = 1 end
	return width
end

function vexpower_AltPower_setMaxWidth(number)
	vexpower.powerBar.alt.maxWidth[number] = (vexpower.powerBar.alt.frames.barBG[number]:GetWidth()-vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["size"])
end




function vexpower.powerBar.alt.setBarBG(number)
	vexpower.powerBar.alt.frames.barBG[number]:SetBackdrop({
		bgFile=vexpower.LSM:Fetch("background", vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["barBGTexture"]),
		edgeFile=vexpower.LSM:Fetch("border", vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["border"]["texture"]), tile=false,
		edgeSize=vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["border"]["size"]})
	vexpower.powerBar.alt.frames.barBG[number]:SetBackdropColor(
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["BarBGColor"]["r"],
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["BarBGColor"]["g"],
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["BarBGColor"]["b"],
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["BarBGColor"]["a"])
	vexpower.powerBar.alt.frames.barBG[number]:SetBackdropBorderColor(
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["border"]["color"]["r"],
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["border"]["color"]["g"],
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["border"]["color"]["b"],
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["border"]["color"]["a"])
	vexpower.powerBar.alt.frames.barBG[number]:SetWidth(vexpower.CPBar.frames[number]:GetWidth())
	vexpower.powerBar.alt.frames.barBG[number]:SetHeight(vexpower.CPBar.frames[number]:GetHeight())
	vexpower.powerBar.alt.frames.barBG[number]:ClearAllPoints()
	vexpower.powerBar.alt.frames.barBG[number]:SetPoint(vexpower.CPBar.frames[number]:GetPoint())
	vexpower.powerBar.alt.frames.barBG[number]:SetFrameStrata(vexpower.powerBar.frames.Bar:GetFrameStrata())
	vexpower.powerBar.alt.frames.barBG[number]:SetMovable(false)
	vexpower.powerBar.alt.frames.barBG[number]:EnableMouse(false)
end

function vexpower.powerBar.alt.setBar(number)

	if vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["barTexture"]["usePack"] == 1 then
		vexpower.powerBar.alt.frames.bar[number][1]:SetBackdrop({bgFile=vexpower.LSM:Fetch("background", vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["barTexture"]["pack1"]),
			tile=false,
			edgeFile="Interface\\Buttons\\WHITE8X8", edgeSize=1,
			insets = {
				left = vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["insets"]["left"],
				right = vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["insets"]["right"],
				top = vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["insets"]["top"],
				bottom = vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["insets"]["bottom"]
				}})
	else
		vexpower.powerBar.alt.frames.bar[number][1]:SetBackdrop({bgFile=vexpower.LSM:Fetch("background", vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["barTexture"]["pack2"]),
			tile=false,
			edgeFile="Interface\\Buttons\\WHITE8X8", edgeSize=1,
			insets = {
				left = vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["insets"]["left"],
				right = vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["insets"]["right"],
				top = vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["insets"]["top"],
				bottom = vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["insets"]["bottom"]
				}})
	end
		
		
		
	vexpower.powerBar.alt.frames.bar[number][1]:SetBackdropColor(
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"][tostring(number)]["r"],
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"][tostring(number)]["g"],
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"][tostring(number)]["b"],
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["colors"]["colors"][tostring(number)]["a"])
	vexpower.powerBar.alt.frames.bar[number][1]:SetBackdropBorderColor(1,1,1,0)
	vexpower.powerBar.alt.frames.bar[number][1]:SetWidth(1)
	vexpower.powerBar.alt.frames.bar[number][1]:SetHeight(vexpower.powerBar.alt.frames.barBG[number]:GetHeight()-(vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["border"]["size"]*2))
	vexpower.powerBar.alt.frames.bar[number][1]:ClearAllPoints()
	vexpower.powerBar.alt.frames.bar[number][1]:SetPoint("TOPLEFT", vexpower.powerBar.alt.frames.barBG[number], "TOPLEFT",
						vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["border"]["size"],
						-vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["border"]["size"])
						
	vexpower.powerBar.alt.frames.bar[number][2] = vexpower.powerBar.alt.frames.bar[number][1]:CreateAnimationGroup("vexpower.powerBar.alt.frames.bar["..number.."][2]")
	vexpower.powerBar.alt.frames.bar[number][2]:SetLooping("NONE")
	vexpower.powerBar.alt.frames.bar[number][3] = vexpower.powerBar.alt.frames.bar[number][2]:CreateAnimation("Scale")
	vexpower.powerBar.alt.frames.bar[number][3]:SetSmoothing("OUT")
	vexpower.powerBar.alt.frames.bar[number][3]:SetDuration(0.2)
	vexpower.powerBar.alt.frames.bar[number][3]:SetOrder(1)
	vexpower.powerBar.alt.frames.bar[number][3]:SetOrigin("TOPLEFT",0,0)
end

function vexpower.powerBar.alt.setBarDif(number)
	vexpower.powerBar.alt.frames.barDif[number][1]:SetBackdrop({
		bgFile="Interface\\Buttons\\WHITE8X8", tile=false, edgeSize=0,
		insets = {
			left = vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["insets"]["left"],
			right = vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["insets"]["right"],
			top = vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["insets"]["top"],
			bottom = vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["insets"]["bottom"]
			}})	
	vexpower.powerBar.alt.frames.barDif[number][1]:SetBackdropColor(
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["usedEffect"]["color"]["r"],
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["usedEffect"]["color"]["g"],
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["usedEffect"]["color"]["b"],
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["usedEffect"]["color"]["a"])
	vexpower.powerBar.alt.frames.barDif[number][1]:SetBackdropBorderColor(1,1,1,0)
	vexpower.powerBar.alt.frames.barDif[number][1]:SetWidth(20)
	vexpower.powerBar.alt.frames.barDif[number][1]:SetHeight(vexpower.powerBar.alt.frames.barBG[number]:GetHeight()-(vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["border"]["size"]*2))
	vexpower.powerBar.alt.frames.barDif[number][1]:ClearAllPoints()
	vexpower.powerBar.alt.frames.barDif[number][1]:SetPoint("TOPLEFT", vexpower.powerBar.alt.frames.barBG[number], "TOPLEFT",
						vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["border"]["size"],
						-vexpower_SV_profiles[vexpower_SV_data["profile"]]["altPowerbar"]["design"]["border"]["size"])
	
	vexpower.powerBar.alt.frames.barDif[number][2] = vexpower.powerBar.alt.frames.barDif[number][1]:CreateAnimationGroup("vexpower.powerBar.alt.frames.barDif["..number.."][2]")
	vexpower.powerBar.alt.frames.barDif[number][2]:SetLooping("NONE")
	vexpower.powerBar.alt.frames.barDif[number][2]:SetScript("OnPlay", function () vexpower.powerBar.alt.frames.barDif[number][1]:Show() end)
	vexpower.powerBar.alt.frames.barDif[number][2]:SetScript("OnFinished", function () vexpower.powerBar.alt.frames.barDif[number][1]:Hide() end)
	vexpower.powerBar.alt.frames.barDif[number][2]:SetScript("OnStop", function () vexpower.powerBar.alt.frames.barDif[number][1]:Hide() end)
	vexpower.powerBar.alt.frames.barDif[number][3] = vexpower.powerBar.alt.frames.barDif[number][2]:CreateAnimation("Alpha")
	vexpower.powerBar.alt.frames.barDif[number][3]:SetDuration(0.5)
	vexpower.powerBar.alt.frames.barDif[number][3]:SetOrder(1)
	vexpower.powerBar.alt.frames.barDif[number][3]:SetChange(-1)
end

function vexpower.powerBar.alt.createBars(number)
	vexpower.powerBar.alt.currentPower[1][number] = 100
	vexpower.powerBar.alt.currentPower[2][number] = 100
	vexpower.powerBar.alt.maxPower[1][number] = 100
	vexpower.powerBar.alt.maxPower[2][number] = 100
	vexpower.powerBar.alt.maxWidth[number] = 0
	vexpower.powerBar.alt.frames.barBG[number] = CreateFrame("Frame", nil, vexpower.CPBar.mainframe)
	vexpower.powerBar.alt.frames.bar[number] = {}
	vexpower.powerBar.alt.frames.bar[number][1] = CreateFrame("Frame", nil, vexpower.powerBar.alt.frames.barBG[number])
	vexpower.powerBar.alt.frames.barDif[number] = {}
	vexpower.powerBar.alt.frames.barDif[number][1] = CreateFrame("Frame", nil, vexpower.powerBar.alt.frames.barBG[number])
end


function vexpower.powerBar.alt.setBars()
	for i=1, vexpower.CPBar.maxCPs do
		if vexpower.powerBar.alt.frames.bar[i] ~= nil then
			vexpower.powerBar.alt.setBarBG(i)
			vexpower.powerBar.alt.setBar(i)
			vexpower.powerBar.alt.setBarDif(i)
			vexpower_AltPower_setMaxWidth(i)
		end
	end
end

function vexpower.powerBar.alt.deleteBars()
	local bardifs = #vexpower.powerBar.alt.frames.barDif
	if bardifs > 0 then
		for i=1,bardifs do
			if vexpower.powerBar.alt.frames.barDif[1][1] ~= nil then
				vexpower.powerBar.alt.frames.barDif[1][1]:Hide()
				table.remove(vexpower.powerBar.alt.frames.barDif, 1)
			end
		end
	end
	
	local bars = #vexpower.powerBar.alt.frames.bar
	if bars > 0 then
		for i=1,bars do
			if vexpower.powerBar.alt.frames.bar[1] ~= nil then
				vexpower.powerBar.alt.frames.bar[1][1]:Hide()
				table.remove(vexpower.powerBar.alt.frames.bar, 1)
			end
		end
	end

	local barbgs = #vexpower.powerBar.alt.frames.barBG
	if barbgs > 0 then
		for i=1,barbgs do
			if vexpower.powerBar.alt.frames.barBG[1] ~= nil then
				vexpower.powerBar.alt.frames.barBG[1]:Hide()
				table.remove(vexpower.powerBar.alt.frames.barBG, 1)
			end
		end
	end
end

function vexpower.powerBar.alt.builder()
	vexpower.powerBar.alt.deleteBars()
	if vexpower.data.classString == "WARLOCK" and (vexpower.data.specID == 266 or vexpower.data.specID == 267) then
		for i=1, vexpower.CPBar.maxCPs do
			vexpower.powerBar.alt.createBars(i)
		end
		vexpower.powerBar.alt.show = true
	else
		vexpower.powerBar.alt.show = false
	end
end