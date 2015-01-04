local _, AskMrRobot = ...
local L = AskMrRobot.L;

-- initialize the CombatLogTab class
AskMrRobot.SettingsTab = AskMrRobot.inheritsFrom(AskMrRobot.Frame)

-- helper to create text for this tab
local function CreateText(tab, font, relativeTo, xOffset, yOffset, text)
    local t = tab:CreateFontString(nil, "ARTWORK", font)
	t:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", xOffset, yOffset)
	t:SetPoint("RIGHT", tab, "RIGHT", -5, 0)
	t:SetWidth(t:GetWidth())
	t:SetJustifyH("LEFT")
	t:SetText(text)
    
    return t
end

local function newCheckbox(tab, label, tooltipTitle, description, onClick)
	local check = CreateFrame("CheckButton", "AmrCheck" .. label, tab, "InterfaceOptionsCheckButtonTemplate")
	check:SetScript("OnClick", function(self)
		PlaySound(self:GetChecked() and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
		onClick(self, self:GetChecked() and true or false)
	end)
	check.label = _G[check:GetName() .. "Text"]
	check.label:SetText(label)
	check.tooltipText = tooltipTitle
	check.tooltipRequirement = description
	return check
end

function AskMrRobot.SettingsTab:new(parent)

	local tab = AskMrRobot.Frame:new(nil, parent)
	setmetatable(tab, { __index = AskMrRobot.SettingsTab })
	tab:SetPoint("TOPLEFT")
	tab:SetPoint("BOTTOMRIGHT")
	tab:Hide()

	-- tab header
	local text = tab:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	text:SetPoint("TOPLEFT", 0, -5)
	text:SetText(L.AMR_SETTINGSTAB_SETTINGS)

	--scrollframe 
	tab.scrollframe = AskMrRobot.ScrollFrame:new(nil, tab)
	tab.scrollframe:SetPoint("TOPLEFT", tab, "TOPLEFT", 0, -30)
	tab.scrollframe:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", -30, 10)

	local content = tab.scrollframe.content
	content:SetHeight(730)
	
	local autoPopup = newCheckbox(content,
		L.AMR_CONFIG_CHECKBOX_MINIMAP_LABEL,
		L.AMR_CONFIG_CHECKBOX_MINIMAP_TOOLTIP_TITLE,
		L.AMR_CONFIG_CHECKBOX_MINIMAP_DESCRIPTION,
		function(self, value) 
			if AmrDb.Options.hideMapIcon then
				AmrDb.Options.hideMapIcon = false
			else
				AmrDb.Options.hideMapIcon = true
			end
			AskMrRobot.AmrUpdateMinimap();
		end
	)
	autoPopup:SetChecked(not AmrDb.Options.hideMapIcon)
	autoPopup:SetPoint("TOPLEFT", content, "TOPLEFT", 0, 0)	
	
	local autoAh = newCheckbox(content,
		L.AMR_CONFIG_CHECKBOX_AUTOAH_LABEL,
		L.AMR_CONFIG_CHECKBOX_AUTOAH_TOOLTIP_TITLE,
		L.AMR_CONFIG_CHECKBOX_AUTOAH_DESCRIPTION,
		function(self, value) 
			if AmrDb.Options.manualShowShop then
				AmrDb.Options.manualShowShop = false
			else
				AmrDb.Options.manualShowShop = true
			end
		end
	)
	autoAh:SetChecked(not AmrDb.Options.manualShowShop)
	autoAh:SetPoint("TOPLEFT", autoPopup, "BOTTOMLEFT", 0, -10)	

    return tab
end