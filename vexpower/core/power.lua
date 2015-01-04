function vexpower.powerBar.handler(energyTypeChanged, newenergy)
	if vexpower.powerBar.show or vexpower.testmode.activated then
		if energyTypeChanged then
			if vexpower_energybarDif_anigrp:IsPlaying() then
				vexpower_energybarDif_anigrp:Stop()
			end
			if vexpower_energybar_anigrp:IsPlaying() then
				vexpower_energybar_anigrp:Stop()
			end
			vexpower.powerBar.frames.Bar:SetWidth(vexpower.powerBar.maxWidth)
			vexpower.powerBar.handler()
		else
			if not(vexpower_energybar_anigrp:IsPlaying()) then
				if newenergy ~= nil then
					-- vexpower.powerBar.currentPower[2] = vexpower.powerBar.currentPower[1]
					vexpower.powerBar.currentPower[1] = vexpower.powerBar.currentPower[1] + newenergy
				else
					vexpower.powerBar.setCurrentPower()
				end
				vexpower.powerBar.setMaxPower()
				local maxenergy = vexpower.powerBar.maxPower
				if maxenergy == 0 then maxenergy = 1 end
				local barfactor_current = vexpower.powerBar.currentPower[2]/maxenergy
				local barfactor_new = vexpower.powerBar.currentPower[1]/maxenergy
				local barfactor = 0
				
				if barfactor_current ~= 0 then 
					barfactor = barfactor_new/barfactor_current
				end
				
				local newWidth = vexpower.powerBar.getWidth(vexpower.powerBar.currentPower[1])
								
				if barfactor < 1 and barfactor > 0 then
					local oldWidth = vexpower.powerBar.getWidth(vexpower.powerBar.currentPower[2])
					local difWidth = oldWidth - newWidth
					vexpower_energybar_ani:SetScale(barfactor, 1)
					if vexpower.powerBar.powerType == "RAGE" or vexpower.powerBar.powerType == "RUNIC_POWER" or vexpower.powerBar.powerType == "FUEL" then
						vexpower_energybar_anigrp:SetScript("onFinished", function () vexpower.powerBar.frames.Bar:SetWidth(newWidth) end)
					end
					vexpower_energybar_anigrp:Play()
					
					if oldWidth<=vexpower.powerBar.maxWidth then
						vexpower.powerBar.frames.BarDif:SetWidth(difWidth)
						vexpower.powerBar.frames.BarDif:ClearAllPoints()
						vexpower.powerBar.frames.BarDif:SetPoint("TOPLEFT", vexpower.powerBar.frames.barBG, "TOPLEFT",
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["size"]+newWidth,
									-vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["size"])
						if vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["usedEffect"]["activate"] then
							vexpower_energybarDif_anigrp:Play()
						else
							vexpower.powerBar.frames.BarDif:Hide()
						end
					else
						vexpower.powerBar.frames.BarDif:Hide()
					end
				else 
					vexpower.powerBar.frames.Bar:SetWidth(newWidth)
				end
				vexpower.powerBar.setBarColor()
			end
		end
	end
end

function vexpower.powerBar.setCurrentPower()
	local new = vexpower.powerBar.getCurrentPower()
	if new ~= vexpower.powerBar.currentPower[1] then
		vexpower.powerBar.currentPower[2] = vexpower.powerBar.currentPower[1]
		vexpower.powerBar.currentPower[1] = new
	end
end

function vexpower.powerBar.getCurrentPower()
	local unitID = ""
	if vexpower.vehicle.power and vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["vehicleEnergy"] then
		unitID = "vehicle"
	else
		unitID = "player"
	end
	return UnitPower(unitID)
end

function vexpower.powerBar.setMaxPower()
	if vexpower.powerBar.getMaxPower() ~= vexpower.powerBar.maxPower then
		vexpower.maxenergy_prev = vexpower.powerBar.maxPower
		vexpower.powerBar.maxPower = vexpower.powerBar.getMaxPower()
		vexpower.markers.handler()
	end
end

function vexpower.powerBar.getMaxPower()
	local unitID = ""
	if vexpower.vehicle.power and vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["vehicleEnergy"] then
		unitID = "vehicle"
	else
		unitID = "player"
	end
	return UnitPowerMax(unitID)
end

function vexpower.powerBar.getWidth(energy)
	local width = 0
	if vexpower.powerBar.maxPower~=0 then
		if not(string.find(energy, "%%")) then
			width = (energy / vexpower.powerBar.maxPower) * vexpower.powerBar.maxWidth
		else
			local energypercentage = string.gsub(energy, "%%", "")
			energypercentage = energypercentage/100
			width = energypercentage * vexpower.powerBar.maxWidth
		end
	end
	if width == 0 then width = 1 end
	return width
end

function vexpower.powerBar.setMaxWidth()
	local newwidth = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["size"]["width"]-(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["size"]*2)
	if vexpower.powerBar.maxWidth ~= newwidth then
		vexpower.powerBar.maxWidth = newwidth
		vexpower.markers.handler()
	end
end

function vexpower.powerBar.setPowertype(force)
	-- vexpower.powerBar.powerTypePrev = vexpower.powerBar.powerType
	if vexpower.data.inVehicle and vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["vehicleEnergy"] then
		vexpower.powerBar.powerType = "FUEL"
		vexpower.powerBar.setBarColor()
	else
		vexpower.powerBar.powerType = select(2, UnitPowerType("player"))
		if vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["show"]["powertypes"][vexpower.powerBar.powerType] then
			vexpower.powerBar.setBarColor()
		end
	end
end

function vexpower.powerBar.setBarColor()
	local coloring = {}
	coloring = vexpower.powerBar.getBarColor()
		
	if coloring[1] == "standard" then
		if coloring[2] and PowerBarColor[vexpower.powerBar.powerType] ~= nil then
			vexpower.powerBar.frames.Bar:SetBackdropColor(	PowerBarColor[vexpower.powerBar.powerType].r,
													PowerBarColor[vexpower.powerBar.powerType].g,
													PowerBarColor[vexpower.powerBar.powerType].b,
													vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["a"])
		elseif coloring[3] and RAID_CLASS_COLORS[vexpower.data.classString] ~= nil then
			vexpower.powerBar.frames.Bar:SetBackdropColor(	RAID_CLASS_COLORS[vexpower.data.classString].r,
													RAID_CLASS_COLORS[vexpower.data.classString].g,
													RAID_CLASS_COLORS[vexpower.data.classString].b,
													vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["a"])
		else
			vexpower.powerBar.frames.Bar:SetBackdropColor(	vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["r"],
													vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["g"],
													vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["b"],
													vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["a"])
		end
	else
		if coloring[2] and PowerBarColor[vexpower.powerBar.powerType] ~= nil then
			vexpower.powerBar.frames.Bar:SetBackdropColor(	PowerBarColor[vexpower.powerBar.powerType].r,
													PowerBarColor[vexpower.powerBar.powerType].g,
													PowerBarColor[vexpower.powerBar.powerType].b,
													vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"][coloring[1]]["a"])
		elseif coloring[3] and RAID_CLASS_COLORS[vexpower.data.classString] ~= nil then
			vexpower.powerBar.frames.Bar:SetBackdropColor(	RAID_CLASS_COLORS[vexpower.data.classString].r,
													RAID_CLASS_COLORS[vexpower.data.classString].g,
													RAID_CLASS_COLORS[vexpower.data.classString].b,
													vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"][coloring[1]]["a"])
		else
			vexpower.powerBar.frames.Bar:SetBackdropColor(	vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"][coloring[1]]["r"],
													vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"][coloring[1]]["g"],
													vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"][coloring[1]]["b"],
													vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"][coloring[1]]["a"])
		end
	end
end

function vexpower.powerBar.checkForRecolor(situation)
	local amount = tonumber(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"][situation])
	
	local compare = 0.5
	if amount <= 1 then
		if vexpower.powerBar.maxPower ~= 0 then
			compare = vexpower.powerBar.currentPower[1] / vexpower.powerBar.maxPower
		end
	else
		compare = vexpower.powerBar.currentPower[1]
	end
	
	if compare > amount and situation == "full" then
		return true
	elseif compare < amount and situation == "empty" then
		return true
	elseif compare == amount then
		if vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"][situation.."Inc"] then
			return true
		else
			return false
		end
	else
		return false
	end
end

function vexpower.powerBar.getBarColor()
	local situation = 0
	
	local returnvalue = {}
	returnvalue[1] = "standard"
	returnvalue[2] = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["colorByPowertype"]
	returnvalue[3] = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["colorByClass"]

	
	if vexpower.data.inFight.delayed then	
		if vexpower.powerBar.checkForRecolor("empty") then
			situation = 1
		elseif vexpower.powerBar.checkForRecolor("full") then
			situation = 3
		else
			situation = 2
		end
	else
		if vexpower.powerBar.checkForRecolor("empty") then
			situation = 4
		elseif vexpower.powerBar.checkForRecolor("full") then
			situation = 6
		else
			situation = 5
		end
	end
	
	if vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["use"][situation] then
		returnvalue[1] = tostring(situation)
		returnvalue[2] = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByPowertype"][situation]
		returnvalue[3] = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"]["colorByClass"][situation]
	end
	
	return returnvalue
end

function vexpower.powerBar.setBarBG()
	vexpower.powerBar.frames.barBG:SetBackdrop({
		bgFile=vexpower.LSM:Fetch("background", vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["barBGTexture"]),
		edgeFile=vexpower.LSM:Fetch("border", vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["texture"]), tile=false,
		edgeSize=vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["size"]})
	vexpower.powerBar.frames.barBG:SetBackdropColor(
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarBGColor"]["r"],
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarBGColor"]["g"],
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarBGColor"]["b"],
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarBGColor"]["a"])
	vexpower.powerBar.frames.barBG:SetBackdropBorderColor(
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["color"]["r"],
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["color"]["g"],
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["color"]["b"],
		vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["color"]["a"])
	vexpower.powerBar.frames.barBG:SetWidth(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["size"]["width"])
	vexpower.powerBar.frames.barBG:SetHeight(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["size"]["height"])
	vexpower.powerBar.frames.barBG:ClearAllPoints()
	vexpower.powerBar.frames.barBG:SetPoint("CENTER", vexpower_MainFrame, "CENTER", 0, 0)
	vexpower.powerBar.frames.barBG:SetFrameStrata(vexpower.options.strata.convertValues(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["strata"]["powerbar"]))
	vexpower.powerBar.frames.barBG:RegisterForDrag("LeftButton")
	vexpower.powerBar.frames.barBG:SetScript("OnDragStart", function () vexpower_MainFrame:StartMoving() end)
	vexpower.powerBar.frames.barBG:SetScript("OnDragStop", function () vexpower_MainFrame:StopMovingOrSizing() vexpower.mainframe.savePositon() end)
	vexpower.powerBar.frames.barBG:SetMovable(vexpower.testmode.activated)
	vexpower.powerBar.frames.barBG:EnableMouse(vexpower.testmode.activated)
end

function vexpower.powerBar.setBar()
	if vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["barTexture"]["usePack"] == 1 then
		vexpower.powerBar.frames.Bar:SetBackdrop({bgFile=vexpower.LSM:Fetch("background", vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["barTexture"]["pack1"]),
			tile=false,
			edgeFile="Interface\\Buttons\\WHITE8X8", edgeSize=1,
			insets = {
				left = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["insets"]["left"],
				right = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["insets"]["right"],
				top = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["insets"]["top"],
				bottom = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["insets"]["bottom"]
				}})
	else
		vexpower.powerBar.frames.Bar:SetBackdrop({bgFile=vexpower.LSM:Fetch("statusbar", vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["barTexture"]["pack2"]),
			tile=false,
			edgeFile="Interface\\Buttons\\WHITE8X8", edgeSize=1,
			insets = {
				left = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["insets"]["left"],
				right = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["insets"]["right"],
				top = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["insets"]["top"],
				bottom = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["insets"]["bottom"]
				}})
	end
	vexpower.powerBar.setBarColor()
	vexpower.powerBar.frames.Bar:SetBackdropBorderColor(1,1,1,0)
	
	if not(vexpower.testmode.activated) then
		if vexpower.data.classString == "WARRIOR" or vexpower.data.classString == "DEATHKNIGHT" then
			vexpower.powerBar.frames.Bar:SetWidth(1)
		else vexpower.powerBar.frames.Bar:SetWidth(vexpower.powerBar.maxWidth) end
			vexpower.powerBar.frames.Bar:Show()
	end
	vexpower.powerBar.frames.Bar:SetHeight(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["size"]["height"]-(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["size"]*2))
	vexpower.powerBar.frames.Bar:ClearAllPoints()
	vexpower.powerBar.frames.Bar:SetPoint("TOPLEFT", vexpower.powerBar.frames.barBG, "TOPLEFT",
						vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["size"],
						-vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["size"])
	vexpower_energybar_anigrp = vexpower.powerBar.frames.Bar:CreateAnimationGroup("vexpower_energybar_anigrp")
	vexpower_energybar_anigrp:SetLooping("NONE")
	vexpower_energybar_ani = vexpower_energybar_anigrp:CreateAnimation("Scale")
	vexpower_energybar_ani:SetSmoothing("OUT")
	vexpower_energybar_ani:SetDuration(0.2)
	vexpower_energybar_ani:SetOrder(1)
	vexpower_energybar_ani:SetOrigin("TOPLEFT",0,0)
end

function vexpower.powerBar.getBarDifColor(c)	
	c = c * 0.3						--shade
	c = c + (0.25 * (1 - c))		--tint
	return c
end

function vexpower.powerBar.setBarDif()
	vexpower.powerBar.frames.BarDif:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8", tile=false, edgeSize=0,
				insets = {
					left = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["insets"]["left"],
					right = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["insets"]["right"],
					top = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["insets"]["top"],
					bottom = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["insets"]["bottom"]
					}})	
	
	
	
	
	--test
	if vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["usedEffect"]["dynamicColoring"] then
		local color = vexpower.powerBar.getBarColors()
		vexpower.powerBar.frames.BarDif:SetBackdropColor(	vexpower.powerBar.getBarDifColor(color[1]),
											vexpower.powerBar.getBarDifColor(color[2]),
											vexpower.powerBar.getBarDifColor(color[3]),
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["usedEffect"]["color"]["a"])
	else			
		vexpower.powerBar.frames.BarDif:SetBackdropColor(	vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["usedEffect"]["color"]["r"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["usedEffect"]["color"]["g"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["usedEffect"]["color"]["b"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["usedEffect"]["color"]["a"])
	end
	
	
	
	vexpower.powerBar.frames.BarDif:SetBackdropBorderColor(1,1,1,0)
	if not(vexpower.testmode.activated) then
		vexpower.powerBar.frames.BarDif:SetWidth(0)
		vexpower.powerBar.frames.BarDif:Hide()
	end
	vexpower.powerBar.frames.BarDif:SetHeight(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["size"]["height"]-(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["size"]*2))
	vexpower.powerBar.frames.BarDif:ClearAllPoints()
	vexpower.powerBar.frames.BarDif:SetPoint("TOPLEFT", vexpower.powerBar.frames.barBG, "TOPLEFT",
						vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["size"],
						-vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["size"])
	vexpower_energybarDif_anigrp = vexpower.powerBar.frames.BarDif:CreateAnimationGroup("vexpower_energybarDif_anigrp")
	vexpower_energybarDif_anigrp:SetLooping("NONE")
	vexpower_energybarDif_anigrp:SetScript("OnPlay", function () vexpower.powerBar.frames.BarDif:Show() end)
	vexpower_energybarDif_anigrp:SetScript("OnFinished", function () vexpower.powerBar.frames.BarDif:Hide() end)
	vexpower_energybarDif_anigrp:SetScript("OnStop", function () vexpower.powerBar.frames.BarDif:Hide() end)
	vexpower_energybarDif_ani = vexpower_energybarDif_anigrp:CreateAnimation("Alpha")
	vexpower_energybarDif_ani:SetDuration(0.5)
	vexpower_energybarDif_ani:SetOrder(1)
	vexpower_energybarDif_ani:SetChange(-1)
end

function vexpower.powerBar.getBarColors()
	local coloring = {}
	coloring = vexpower.powerBar.getBarColor()
	local r = 0
	local g = 0
	local b = 0
	local a = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["a"]
	
	if coloring[1] == "standard" then
		if coloring[2] and PowerBarColor[vexpower.powerBar.powerType] ~= nil then
			r = PowerBarColor[vexpower.powerBar.powerType].r
			g = PowerBarColor[vexpower.powerBar.powerType].g
			b = PowerBarColor[vexpower.powerBar.powerType].b
			a = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["a"]
		elseif coloring[3] and RAID_CLASS_COLORS[vexpower.data.classString] ~= nil then
			r = RAID_CLASS_COLORS[vexpower.data.classString].r
			g =	RAID_CLASS_COLORS[vexpower.data.classString].g
			b = RAID_CLASS_COLORS[vexpower.data.classString].b
			a = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["a"]
		else
			r = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["r"]
			g = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["g"]
			b = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["b"]
			a = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["a"]
		end
	else
		if coloring[2] and PowerBarColor[vexpower.powerBar.powerType] ~= nil then
			r = PowerBarColor[vexpower.powerBar.powerType].r
			g = PowerBarColor[vexpower.powerBar.powerType].g
			b = PowerBarColor[vexpower.powerBar.powerType].b
			a = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"][coloring[1]]["a"]
		elseif coloring[3] and RAID_CLASS_COLORS[vexpower.data.classString] ~= nil then
			r = RAID_CLASS_COLORS[vexpower.data.classString].r
			g = RAID_CLASS_COLORS[vexpower.data.classString].g
			b = RAID_CLASS_COLORS[vexpower.data.classString].b
			a = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"][coloring[1]]["a"]
		else
			r = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"][coloring[1]]["r"]
			g = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"][coloring[1]]["g"]
			b = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"][coloring[1]]["b"]
			a = vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["sitRecoloring"][coloring[1]]["a"]
		end
	end
	return {r,g,b,a}
end