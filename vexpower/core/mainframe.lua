function vexpower.mainframe.setMovable(movable)
	if movable == nil then
		movable = not(vexpower_MainFrame:IsMovable())
		if movable then
			print("|CFFFF7D0AVex Power|r - Frame is now movable")
		else
			print("|CFFFF7D0AVex Power|r - Frame is not movable anymore")
		end
	end
	vexpower_MainFrame:SetMovable(movable)
	vexpower.powerBar.frames.barBG:EnableMouse(movable)
end

function vexpower.mainframe.savePositon()	
	vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["position"]["anchor"] = select(3, vexpower_MainFrame:GetPoint())
	vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["position"]["anchorFrame"] = select(1, vexpower_MainFrame:GetPoint())
	vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["position"]["x"] = select(4, vexpower_MainFrame:GetPoint())
	vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["position"]["y"] = select(5, vexpower_MainFrame:GetPoint())
end

function vexpower.mainframe.setFrame()
	vexpower_MainFrame:SetWidth(1)
	vexpower_MainFrame:SetHeight(1)
	vexpower_MainFrame:ClearAllPoints()
	vexpower_MainFrame:SetPoint(vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["position"]["anchorFrame"],
									UIParent,
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["position"]["anchor"],
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["position"]["x"],
									vexpower_SV_profiles[vexpower_SV_data["profile"]]["powerbar"]["design"]["position"]["y"])
end