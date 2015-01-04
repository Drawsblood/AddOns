function vexpower.options.tagWindow.toggle()
	local text = "Current Power:\n|CFFFF7D0A[PowerCurrent]|r: Shows '19218' (current power)\n|CFFFFCC00[PowerAltCurrent]|r: Shows '19218' (current alternative power)\n|CFFFF7D0A[PowerCurrentShort]|r: Shows '19' instead of '19218' (current power)\n|CFFFF7D0A[PowerCurrentSmart]|r: Shows '19.2' instead of '19218' (current power)\n\nMaximum Power:\n|CFFFF7D0A[PowerMax]|r: Shows '19218' (maximum power)\n|CFFFFCC00[PowerAltMax]|r: Shows '19218' (maximum alternative power)\n|CFFFF7D0A[PowerMaxShort]|r: Shows '19' instead of '19218' (maximum power)\n|CFFFF7D0A[PowerMaxSmart]|r: Shows '19.2' instead of '19218' (maximum power)\n\nMissing Power:\n|CFFFF7D0A[PowerMissing]|r: Shows '19218' (missing power)\n|CFFFF7D0A[PowerMissingShort]|r: Shows '19' instead of '19218' (missing power)\n|CFFFF7D0A[PowerMissingSmart]|r: Shows '19.2' instead of '19218' (missing power)\n\nPercentage Power:\n|CFFFF7D0A[PowerPerc]|r: Shows '18' for 18.3%\n|CFFFF7D0A[PowerPercSmart]|r: Shows '18.3' for 18.3%\n\nComboPoints:\n|CFFFF7D0A[CPsCurrent]|r: Shows your current ComboPoints/HolyPower/etc\n|CFFFF7D0A[CPsMax]|r: Shows your maximum ComboPoints/HolyPower/etc\n|CFFFF7D0A[CPsMissing]|r: Shows your missing ComboPoints/HolyPower/etc\n\nTime:\nThese Tags are only available when Buffs/Debuffs, Chi or Holy Power are tracked\n|CFFFF7D0A[TimeLeft]|r: Shows the time left ('18.2')\n|CFFFF7D0A[TimeLeftShort]|r: Shows the time left ('18')\n|CFFFF7D0A[TimeTotal]|r: Shows the total duration\n\n|CFFFFCC00[PowerAlt...]|r are only available for warlocks to show the number of\nember shards or their demonic fury"
	if not(vexpower.options.tagWindow.active) then
		--Frame
		if vexpower.options.tagWindow.window == nil then
			vexpower.options.tagWindow.window = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
		
			vexpower.options.tagWindow.window:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8", edgeFile="Interface\\Buttons\\WHITE8X8", tile=true, edgeSize=2})
			vexpower.options.tagWindow.window:SetBackdropColor(0.3, 0.3, 0.3, 0.8)
			vexpower.options.tagWindow.window:SetBackdropBorderColor(0,0,0,1)
			vexpower.options.tagWindow.window:SetFrameStrata("TOOLTIP")
			
			vexpower.options.tagWindow.window:RegisterForDrag("LeftButton")
			vexpower.options.tagWindow.window:SetScript("OnDragStart", function ()
				vexpower.options.tagWindow.window:StartMoving()
				end)
			vexpower.options.tagWindow.window:SetScript("OnDragStop", function (self)
				self:StopMovingOrSizing()
				end)
			vexpower.options.tagWindow.window:EnableMouse(true)
			vexpower.options.tagWindow.window:SetMovable(true)
			
			
			--FontString
			vexpower.options.tagWindow.fontString = vexpower.options.tagWindow.window:CreateFontString("vexpower.options.tagWindow.fontString", "OVERLAY", "GameFontNormal")
			vexpower.options.tagWindow.fontString:ClearAllPoints()
			vexpower.options.tagWindow.fontString:SetPoint("TOPLEFT", vexpower.options.tagWindow.window, "TOPLEFT", 5, -5)
			vexpower.options.tagWindow.fontString:SetTextColor(1, 1, 1, 1)
			vexpower.options.tagWindow.fontString:SetFont(vexpower.LSM:Fetch("font", "Friz Quadrata TT"), 10)
			vexpower.options.tagWindow.fontString:SetJustifyH("LEFT")
			vexpower.options.tagWindow.fontString:SetText(text)
			
			--CloseButton
			vexpower.options.tagWindow.Button = CreateFrame("Button", "vexpower.options.tagWindow.Button", vexpower.options.tagWindow.window, "UIPanelButtonTemplate")
			vexpower.options.tagWindow.Button:SetWidth(50)
			vexpower.options.tagWindow.Button:SetHeight(20)
			vexpower.options.tagWindow.Button:SetScale(0.7)
			vexpower.options.tagWindow.Button:SetPoint("TOPRIGHT", vexpower.options.tagWindow.window, "TOPRIGHT", -6, -5)
			vexpower.options.tagWindow.Button:SetText("Close")
			vexpower.options.tagWindow.Button:SetScript("OnClick", function () vexpower.options.tagWindow.toggle() end)
			
			
			vexpower.options.tagWindow.window:SetWidth(vexpower.options.tagWindow.fontString:GetWidth()+10)
			vexpower.options.tagWindow.window:SetHeight(vexpower.options.tagWindow.fontString:GetHeight()+10)
		end
		
		vexpower.options.tagWindow.window:ClearAllPoints()
		vexpower.options.tagWindow.window:SetPoint("TOPLEFT", InterfaceOptionsFramePanelContainer, "TOPRIGHT", 0, 0)
		vexpower.options.tagWindow.window:Show()
		vexpower.options.tagWindow.active = true
	else
		vexpower.options.tagWindow.window:Hide()
		vexpower.options.tagWindow.active = false
	end
end