local LushGearOptions_ZoneHeightMax = 245;
local LushGearOptions_ZoneHeightMin = 200;

function LushGear_options_CreateCheckBox(ParentFrame, ButtonText, ButtonName)
	local FrameRet =  CreateFrame("CheckButton", ButtonName, ParentFrame, "OptionsCheckButtonTemplate");
	FrameRet:SetWidth("25")
	FrameRet:SetHeight("25")
	FrameRet:SetPoint("CENTER")
	getglobal(FrameRet:GetName().."Text"):SetText(ButtonText);
	FrameRet:Show()
	return FrameRet
end

function LushGear_Options_OnLoad()
	local y = -125;
	for ZoneName, SubZoneTable in pairs(LushGearSwap_ZoneSwapLocaitons) do
		if (ZoneName:sub(0, LGS_DAILIES_OPTION:len()) == LGS_DAILIES_OPTION) then
			local ChkBox = LushGear_options_CreateCheckBox(LushGear_OptionsFrame, ZoneName, "LushGearOptions_CheckBox" .. ZoneName);
			ChkBox:SetPoint("TOPLEFT", LushGear_OptionsFrame, "TOPLEFT", 20, y);

			y = y - ChkBox:GetHeight();
		end
	end

	for ZoneName, SubZoneTable in pairs(LushGearSwap_ZoneSwapLocaitons) do
		if (ZoneName:sub(0, LGS_DAILIES_OPTION:len()) ~= LGS_DAILIES_OPTION) then
			local ChkBox = LushGear_options_CreateCheckBox(LushGear_OptionsFrame, ZoneName, "LushGearOptions_CheckBox" .. ZoneName);
			ChkBox:SetPoint("TOPLEFT", LushGear_OptionsFrame, "TOPLEFT", 20, y);

			y = y - ChkBox:GetHeight();
		end
	end

	LushGearOptions_ZoneHeightMax = LushGearOptions_ZoneHeightMax - y - 165;
	LushGearOptions_ZoneHeightMin = LushGearOptions_ZoneHeightMin - y - 165;

	-- Now move all the frames under the above.
	LushGear_OptionsFrameZoneSwap:SetPoint("TOPLEFT", LushGear_OptionsFrame, "TOPLEFT", 20, y);
end

function LushGear_Options_Show()
	if LushGearSwapFrame.CurrentSet then
		LushGear_OptionsFrameTitle:SetText(LushGearSwapFrame.CurrentSet)
		LushGear_OptionsFrame:Show()
		GearManagerDialogPopup:Hide();
	else
		LushGear_Options_Hide()
	end
	
	local setName = LushGear_OptionsFrameTitle:GetText();
	
	if LushGear_OptionsFrame:IsVisible() then
		if (not LushGearSwap_Options[setName]) then
			LushGearSwap_Options[setName] = {};
		end

		-- Show helm options
		local showHelmOption = LushGearSwap_Options[setName].ShowHelm;
		LushGear_OptionsFrameHelmShowOption:SetChecked(showHelmOption == true)
		LushGear_OptionsFrameHelmHideOption:SetChecked(showHelmOption == false)
		LushGear_OptionsFrameHelmIgnoreOption:SetChecked(showHelmOption == nil)
		
		-- Show Cloak Options
		local showCloakOption = LushGearSwap_Options[setName].ShowCloak;
		LushGear_OptionsFrameCloakShowOption:SetChecked(showCloakOption == true)
		LushGear_OptionsFrameCloakHideOption:SetChecked(showCloakOption == false)
		LushGear_OptionsFrameCloakIgnoreOption:SetChecked(showCloakOption == nil)
		
		-- Zoneing Options
		for ZoneName, SubZoneTable in pairs(LushGearSwap_ZoneSwapLocaitons) do
			local ChkBox = getglobal("LushGearOptions_CheckBox" .. ZoneName);
			if ChkBox then
				if LushGearSwap_Options[setName].MajorZoneSwaps and LushGearSwap_Options[setName].MajorZoneSwaps[ZoneName] then
					ChkBox:SetChecked(true);
				else
					ChkBox:SetChecked(false);
				end
			end
		end

		-- User Zone.
		if LushGearSwap_Options[setName].ZoneSwap then
			LushGear_OptionsFrameZoneEditBox:SetText(LushGearSwap_Options[setName].ZoneSwap);
			LushGear_OptionsFrameZoneSwap:SetChecked(true);
		else
			LushGear_OptionsFrameZoneSwap:SetChecked(false);
			LushGear_OptionsFrameZoneEditBox:SetText("");
		end
	
		-- Interface emulate. ** just resizes and stuff **
		LushGear_Options_ZoneChange_OnClick(LushGear_OptionsFrameZoneSwap);
	end
end

function LushGear_Options_Hide()
	LushGear_OptionsFrame:Hide();
end

function LushGear_Options_Save()
	local setName = LushGear_OptionsFrameTitle:GetText();
	LushGearSwap_Options[setName].ShowHelm = nil;
	LushGearSwap_Options[setName].ShowCloak = nil;
	LushGearSwap_Options[setName].Title = nil;
	LushGearSwap_Options[setName].ZoneSwap = nil;
	LushGearSwap_Options[setName].MajorZoneSwaps = {};
	
	if LushGear_OptionsFrameHelmShowOption:GetChecked() then
		LushGearSwap_Options[setName].ShowHelm = true;
	elseif LushGear_OptionsFrameHelmHideOption:GetChecked() then
		LushGearSwap_Options[setName].ShowHelm = false;
	end
	
	if LushGear_OptionsFrameCloakShowOption:GetChecked() then
		LushGearSwap_Options[setName].ShowCloak = true;
	elseif LushGear_OptionsFrameCloakHideOption:GetChecked() then
		LushGearSwap_Options[setName].ShowCloak = false;
	end
	
	if LushGear_OptionsFrameZoneSwap:GetChecked() then
		local ZoneText = LushGear_OptionsFrameZoneEditBox:GetText();
		if ZoneText and string.len(ZoneText) > 0 then
			LushGearSwap_Options[setName].ZoneSwap = ZoneText;
		end
	end

	for ZoneName, SubZoneTable in pairs(LushGearSwap_ZoneSwapLocaitons) do
		local ChkBox = getglobal("LushGearOptions_CheckBox" .. ZoneName);
		if ChkBox and ChkBox:GetChecked() then
			LushGearSwap_Options[setName].MajorZoneSwaps[ZoneName] = 1;
		end
	end
	
	LushGear_Options_Hide();
	LushGearSwap_OptionsUpdated();
end

function LushGear_Options_TitleDropDown_OnClick(self)
	UIDropDownMenu_SetSelectedValue(LushGear_OptionsFrameTitleDropDown, self.value);
end

function LushGear_Options_SetTitle_OnClick(self)
	if not self:GetChecked() then
		LushGear_OptionsFrameTitleDropDown:Hide();
	else
		LushGear_OptionsFrameTitleDropDown:Show();
	end
end

function LushGear_Options_TitleDropDown_OnShow()
	if (LushGearSwap_Options[LushGear_OptionsFrameTitle:GetText()]) then
		if LushGearSwap_Options[LushGear_OptionsFrameTitle:GetText()].Title ~= nil then
			UIDropDownMenu_SetSelectedValue(LushGear_OptionsFrameTitleDropDown, LushGearSwap_Options[LushGear_OptionsFrameTitle:GetText()].Title);
			UIDropDownMenu_SetText(LushGear_OptionsFrameTitleDropDown, GetTitleName(LushGearSwap_Options[LushGear_OptionsFrameTitle:GetText()].Title));
		else
			UIDropDownMenu_SetSelectedValue(LushGear_OptionsFrameTitleDropDown, GetCurrentTitle());
		end
	end
end

function LushGear_Options_HelmOption_OnClick(self)
	LushGear_OptionsFrameHelmShowOption:SetChecked(false)
	LushGear_OptionsFrameHelmHideOption:SetChecked(false)
	LushGear_OptionsFrameHelmIgnoreOption:SetChecked(false)
	self:SetChecked(true);
end

function LushGear_Options_CloakOption_OnClick(self)
	LushGear_OptionsFrameCloakShowOption:SetChecked(false)
	LushGear_OptionsFrameCloakHideOption:SetChecked(false)
	LushGear_OptionsFrameCloakIgnoreOption:SetChecked(false)
	self:SetChecked(true);
end

function LushGear_Options_ZoneChange_OnClick(self)
	if self:GetChecked() then
		LushGear_OptionsFrameZoneEditBox:Show();
		LushGear_OptionsFrameMinimapHelpTitle:Show();
		LushGear_OptionsFrame:SetHeight(LushGearOptions_ZoneHeightMax);
		
		if (not LushGearSwap_Options[LushGear_OptionsFrameTitle:GetText()].ZoneSwap) then
			LushGear_OptionsFrameZoneEditBox:SetText(GetMinimapZoneText());
		end
		
		LushGear_OptionsFrameZoneEditBox:HighlightText();
		LushGear_OptionsFrameZoneEditBox:SetFocus();
	else
		LushGear_OptionsFrameZoneEditBox:Hide();
		LushGear_OptionsFrameMinimapHelpTitle:Hide();
		LushGear_OptionsFrame:SetHeight(LushGearOptions_ZoneHeightMin);
	end
end

function LushGear_Options_TitleDropDown_Initialize()
	local titleCount = 0;
	-- Setup buttons
	local info = UIDropDownMenu_CreateInfo();
	local titleName;
	for i=1, GetNumTitles() do
		-- Changed to base 0 for simplicity, change when the opportunity arises.
		if ( IsTitleKnown(i) ~= 0 ) then
			titleCount = titleCount + 1;
			titleName = GetTitleName(i);
			info.text = titleName;
			info.func = LushGear_Options_TitleDropDown_OnClick;
			info.value = i;
			info.checked = false;
			UIDropDownMenu_AddButton(info);
		end
	end
end