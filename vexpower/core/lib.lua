function vexpower.lib.getTimer(name, duration, func)
	local aniGRP = vexpower_MainFrame:CreateAnimationGroup(name)
	aniGRP:SetLooping("NONE")
	local ani = aniGRP:CreateAnimation("Scale")
	ani:SetOrder(1)
	ani:SetDuration(0)
	ani:SetScale(1,1)
	ani:SetEndDelay(duration)
	aniGRP:SetScript("OnFinished", function (self) func(self) end)
	aniGRP:Play()
	return {aniGRP, ani}
end

function vexpower.lib.vehicleHandler(player)
	if player then
		local val = UnitHasVehicleUI("player")
		vexpower.vehicle.power = val
		vexpower.vehicle.CP = val
		vexpower.data.inVehicle = val
	end
	
	if vexpower.addonLoaded then
		vexpower.show.handler()
		vexpower.powerBar.setPowertype()
		vexpower.markers.handler()
	end
end

function vexpower.data.inFight.timerHandler()		
	if vexpower.data.inFight.ani[1] ~= nil then
		if vexpower.data.inFight.ani[1]:IsPlaying() then
			vexpower.data.inFight.ani[1]:Stop()
		end
	end
	if vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["infightdelay"] > 0 then
		vexpower.data.inFight.ani = vexpower.lib.getTimer(
			"vexpower.data.inFight.ani",
			vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["infightdelay"],
			function ()
			vexpower.data.inFight.delayed = false
			vexpower.show.handler()
			vexpower.powerBar.setBarColor()
			end)
	else
		vexpower.data.inFight.delayed = false
		vexpower.show.handler()
		vexpower.powerBar.setBarColor()
	end
end

function vexpower.lib.setSpecID()
	vexpower.data.specTabID = GetActiveSpecGroup(false, false)
	
	local specType = 0
	if GetSpecialization() ~= nil then
		if GetSpecializationInfo(GetSpecialization()) ~= nil then
			specType = select(1, GetSpecializationInfo(GetSpecialization()))
		end
	end
	vexpower.data.specID = specType
end

function vexpower.lib.setClassString()
	vexpower.data.classString = select(2, UnitClass("player"))
end

function vexpower.data.lib.getColor.powertypeHex(powertype)
	return vexpower.data.lib.getColor.decToHex(PowerBarColor[powertype]["r"],PowerBarColor[powertype]["g"],PowerBarColor[powertype]["b"])
end

function vexpower.data.lib.getColor.classHex(class)
	return vexpower.data.lib.getColor.decToHex( RAID_CLASS_COLORS[class]["r"], RAID_CLASS_COLORS[class]["g"], RAID_CLASS_COLORS[class]["b"])
end

function vexpower.data.lib.getColor.decToHex(r,g,b)
	if r == nil then r = 0 end
	if g == nil then g = 0 end
	if b == nil then b = 0 end
    return string.format("%02x%02x%02x", r*250, g*250, b*250)
end

function vexpower.data.lib.copyTable(settings)
	local copy = {}
	if settings ~= nil then
		for k, v in pairs(settings) do
			if type(v) == "table" then  copy[k] = vexpower.data.lib.copyTable(v)
			else						copy[k] = v end
		end
	end
	return copy
end

function vexpower.data.lib.setBlizzFrames()		
	if vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["blizzhide"]["chi"] then
		MonkHarmonyBar.Show = function () end
		MonkHarmonyBar:SetScript("OnEvent", nil)
		MonkHarmonyBar:UnregisterAllEvents()
		MonkHarmonyBar:Hide()
	end	
	
	if vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["blizzhide"]["holypower"] then
		PaladinPowerBar.Show = function () end
		PaladinPowerBar:Hide()
		PaladinPowerBar:UnregisterAllEvents()
	end	
	
	if vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["blizzhide"]["lockShards"] then
		ShardBarFrame.Show = function () end
		ShardBarFrame:Hide()
		ShardBarFrame:UnregisterAllEvents()
	end
	
	if vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["blizzhide"]["cps"] then
		ComboFrame.Show = function () end
		ComboFrame:Hide()
		ComboFrame:UnregisterAllEvents()
	end
end

function vexpower.data.lib.setMonkChiTimer()
	if vexpower.data.classString == "MONK" and vexpower.CPBar.currentCP[1] ~= 0 then
		if vexpower.data.monkChiTimer[1] ~= nil then
			if vexpower.data.monkChiTimer[1]:IsPlaying() then
				vexpower.data.monkChiTimer[1]:Stop()
			end
		end
		vexpower.data.monkChiTimer = vexpower.lib.getTimer(
			"vexpower.data.monkChiTimer",
			10,
			function ()
			vexpower.data.inFight.timestamp = GetTime()
			vexpower.data.lib.setMonkChiTimer()
			end)
	end
end