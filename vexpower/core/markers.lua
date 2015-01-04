function vexpower.markers.handler()
	--Clear Markers
	for i=1,#vexpower.markers.created do
		if vexpower.markers.created[i] ~= nil then
			vexpower.markers.created[i]:Hide()
		end
		vexpower.markers.created[i]=nil
	end
	vexpower.markers.created = {}
	
	--Set new markers
	local markers = vexpower_SV_markers_specBoth[vexpower_SV_data["profile"]]
	for key,val in pairs(markers) do
		if val[vexpower.powerBar.powerType] then
			vexpower.markers.create(vexpower.powerBar.getWidth(key))
		end
	end
	
	--Set new spec markers
	if vexpower.data.specTabID == 1 then 	markers = vexpower_SV_markers_specA[vexpower_SV_data["profile"]]
	else						markers = vexpower_SV_markers_specB[vexpower_SV_data["profile"]] end
	if markers ~=nil then
		for key,val in pairs(markers) do
			if val[vexpower.powerBar.powerType] then
				vexpower.markers.create(vexpower.powerBar.getWidth(key))
			end
		end
	end
end

function vexpower.markers.create(pos)
	if pos < vexpower.powerBar.maxWidth and vexpower.powerBar.maxPower ~= 0 then
		local temp = CreateFrame("Frame", nil, vexpower.powerBar.frames.markers)
		temp:SetBackdrop({
			bgFile="Interface\\Buttons\\WHITE8X8", tile=false,
			edgeFile="Interface\\Buttons\\WHITE8X8",
			edgeSize=vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["border"]["size"]})
							
		if vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["colorLikeBG"] then
			if vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["colorByPowertype"] and PowerBarColor[vexpower.powerBar.powerType] ~= nil then
				temp:SetBackdropColor(
					PowerBarColor[vexpower.powerBar.powerType].r,
					PowerBarColor[vexpower.powerBar.powerType].g,
					PowerBarColor[vexpower.powerBar.powerType].b,
					vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["color"]["a"])
			elseif vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["colorByClass"] and PowerBarColor[vexpower.data.classString] ~= nil then
				temp:SetBackdropColor(
					RAID_CLASS_COLORS[vexpower.data.classString].r,
					RAID_CLASS_COLORS[vexpower.data.classString].g,
					RAID_CLASS_COLORS[vexpower.data.classString].b,
					vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["color"]["a"])
			else
				temp:SetBackdropColor(
					vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["r"],
					vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["g"],
					vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["b"],
					vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["color"]["a"])
			end
		else
			temp:SetBackdropColor(
				vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["color"]["r"],
				vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["color"]["g"],
				vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["color"]["b"],
				vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["color"]["a"])
		end
		
		
		if vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["border"]["colorLikeBG"] then
			if vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["colorByPowertype"] then
				temp:SetBackdropBorderColor(	PowerBarColor[vexpower.powerBar.powerType].r,
										PowerBarColor[vexpower.powerBar.powerType].g,
										PowerBarColor[vexpower.powerBar.powerType].b,
										vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["a"])
			else
				temp:SetBackdropBorderColor(	vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["r"],
										vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["g"],
										vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["b"],
										vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["BarColor"]["a"])
			end
		else
			temp:SetBackdropBorderColor(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["border"]["color"]["r"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["border"]["color"]["g"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["border"]["color"]["b"],
											vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["border"]["color"]["a"])
		end
		
		temp:SetFrameStrata(vexpower.options.strata.convertValues(vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["strata"]["markers"]))
		temp:SetWidth(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["markers"]["width"])
		temp:SetHeight(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["size"]["height"]-(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["size"]*2)-4)
		
		temp:SetPoint("TOPLEFT", vexpower.powerBar.frames.barBG, "TOPLEFT", pos, -vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["border"]["size"]-2)
		temp:Show()
		table.insert(vexpower.markers.created,#vexpower.markers.created+1, temp)
	end
end