function vexpower.testmode.window.toggle()
	local vexpower_TestModeWindow_text = "|CFFFF7D0AVex Power|r Testmode is |CFFC41F3Bactive|r !\n\n"
	vexpower_TestModeWindow_text = vexpower_TestModeWindow_text.."- ComboPoint gain and loss are |CFF00FF00simulated|r\n"
	vexpower_TestModeWindow_text = vexpower_TestModeWindow_text.."- Textfields get a colored background and are |CFF00FF00moveable|r\n"
	vexpower_TestModeWindow_text = vexpower_TestModeWindow_text.."- Powerbar and ComboPointBar become |CFF00FF00movable|r\n\n"
	
	if not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["intMode"]["activate"]) then
		vexpower_TestModeWindow_text = vexpower_TestModeWindow_text.."|CFFC41F3BWARNING|r:\nYou deactivated the Intelligent-CP-Mode. Thus movable frames representing ComboPoints will be visible during the testmode. "
		vexpower_TestModeWindow_text = vexpower_TestModeWindow_text.."These Frames are movable and can be dragged to adjust the config which is currently active.\n\n"
		vexpower_TestModeWindow_text = vexpower_TestModeWindow_text.."Currently adjusting:\n"
		vexpower_TestModeWindow_text = vexpower_TestModeWindow_text.."|CFF00FF00"..vexpower.options.cps.getConfigString().."|r\n"
		vexpower_TestModeWindow_text = vexpower_TestModeWindow_text.."Due to your settings, your class and your spec the addon currently uses the following config for the simulation:\n"
		vexpower_TestModeWindow_text = vexpower_TestModeWindow_text.."|CFF00FF00"..vexpower.options.cps.getConfigString(vexpower.CPBar.getAltPos()).."|r\n\n"
		if vexpower.options.cps.getConfigString() == vexpower.options.cps.getConfigString(vexpower.CPBar.getAltPos()) then
			vexpower_TestModeWindow_text = vexpower_TestModeWindow_text.."Thus the additonal frames you see |CFF00FF00represent|r the ComboPoints that are simulated"
		else
			vexpower_TestModeWindow_text = vexpower_TestModeWindow_text.."Thus the additonal frames you see |CFFC41F3Bdon't represent|r the ComboPoints that are simulated. "
			vexpower_TestModeWindow_text = vexpower_TestModeWindow_text.."So moving a frame won't move the position of one of the ComboPoints!"
		end
	end
	
	if vexpower.testmode.activated then
		--Frame
		if vexpower.testmode.window.frame == nil then
			vexpower.testmode.window.frame = CreateFrame("Frame", nil, UIparent)
		
			vexpower.testmode.window.frame:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8", edgeFile="Interface\\Buttons\\WHITE8X8", tile=true, edgeSize=2})
			vexpower.testmode.window.frame:SetBackdropColor(0.3, 0.3, 0.3, 0.8)
			vexpower.testmode.window.frame:SetBackdropBorderColor(0,0,0,1)
			vexpower.testmode.window.frame:SetFrameStrata("TOOLTIP")
			vexpower.testmode.window.frame:SetWidth(270)
			vexpower.testmode.window.frame:SetHeight(200)
			
			vexpower.testmode.window.frame:RegisterForDrag("LeftButton")
			vexpower.testmode.window.frame:SetScript("OnDragStart", function ()
				vexpower.testmode.window.frame:StartMoving()
				end)
			vexpower.testmode.window.frame:SetScript("OnDragStop", function (self)
				self:StopMovingOrSizing()
				end)
			vexpower.testmode.window.frame:EnableMouse(true)
			vexpower.testmode.window.frame:SetMovable(true)
			
			
			--FontString
			vexpower.testmode.window.fontstring = vexpower.testmode.window.frame:CreateFontString("vexpower.testmode.window.fontstring", "OVERLAY", "GameFontNormal")
			vexpower.testmode.window.fontstring:ClearAllPoints()
			vexpower.testmode.window.fontstring:SetPoint("TOPLEFT", vexpower.testmode.window.frame, "TOPLEFT", 5, -5)
			vexpower.testmode.window.fontstring:SetTextColor(1, 1, 1, 1)
			vexpower.testmode.window.fontstring:SetFont(vexpower.LSM:Fetch("font", "Friz Quadrata TT"), 8)
			vexpower.testmode.window.fontstring:SetJustifyH("LEFT")
			vexpower.testmode.window.fontstring:SetJustifyV("TOP")
			vexpower.testmode.window.fontstring:SetText(vexpower_TestModeWindow_text)
			vexpower.testmode.window.fontstring:SetWidth(260)
			vexpower.testmode.window.fontstring:SetHeight(190)
			
			--CloseButton
			vexpower.testmode.window.button = CreateFrame("Button", "vexpower.testmode.window.button", vexpower.testmode.window.frame, "UIPanelButtonTemplate")
			vexpower.testmode.window.button:SetWidth(100)
			vexpower.testmode.window.button:SetHeight(20)
			vexpower.testmode.window.button:SetScale(0.7)
			vexpower.testmode.window.button:SetPoint("TOPRIGHT", vexpower.testmode.window.frame, "TOPRIGHT", -6, -5)
			vexpower.testmode.window.button:SetText("deactivate")
			vexpower.testmode.window.button:SetScript("OnClick", function () vexpower.testmode.activated=false vexpower.testmode.handler()  end)
		end
		
		if not(vexpower_SV_profiles[vexpower_SV_data["profile"]]["CPBar"]["design"]["intMode"]["activate"]) then
			if vexpower.options.cps.getConfigString() == vexpower.options.cps.getConfigString(vexpower.CPBar.getAltPos()) then
				vexpower.testmode.window.frame:SetHeight(175)
			else
				vexpower.testmode.window.frame:SetHeight(185)
			end
		else
			vexpower.testmode.window.frame:SetHeight(50)
		end
		
		vexpower.testmode.window.fontstring:SetText(vexpower_TestModeWindow_text)
		vexpower.testmode.window.frame:ClearAllPoints()
		vexpower.testmode.window.frame:SetPoint("TOPLEFT", UIparent, "TOPLEFT", 30, -30)
		vexpower.testmode.window.frame:Show()
	else
		vexpower.testmode.window.frame:Hide()
	end
end