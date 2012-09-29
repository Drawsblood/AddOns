local LGS_KeyBindWidgets = {};
local LGS_KeyBindModeActive = false
local LushGearSwap_OldButtonFuncs = {};
local LushGearSwap_KeybindTextMap = {};
local LushGearSwap_Keybinds = {};
local LushKeybind_FramePrefix = "LushGearSwap_Keybind_";
local LushGearSwap_HackyTimer = 0;

local LushGearSwap_KeyBinderIgnoreKeys =
{
	["BUTTON1"] = true,
	["BUTTON2"] = true,
	["UNKNOWN"] = true,
	["LSHIFT"] = true,
	["LCTRL"] = true,
	["LALT"] = true,
	["RSHIFT"] = true,
	["RCTRL"] = true,
	["RALT"] = true,
}

local LushGearSwap_KeyBinderAbrivations =
{
	["-"] = " + ",
	["NUMPAD"] = "NumPad",
	["ALT"] = "Alt",
	["CTRL"] = "Ctrl",
	["SHIFT"] = "Shift",
	["PLUS"] = "Plus",
	["MINUS"] = "Minus",
	["MULTIPLY"] = "Multiply",
	["DIVIDE"] = "Devide",
	["BACKSPACE"] = "Backspace",
	["CAPSLOCK"] = "Caps",
	["CLEAR"] = "Clear",
	["DELETE"] = "Del",
	["END"] = "End",
	["HOME"] = "Home",
	["INSERT"] = "Insert",
	["NUMLOCK"] = "NL",
	["PAGEDOWN"] = "PD",
	["PAGEUP"] = "PU",
	["SCROLLLOCK"] = "SL",
	["SPACEBAR"] = "' '",
	["TAB"] = "Tab",
	["DOWNARROW"] = "Down",
	["LEFTARROW"] = "Left",
	["RIGHTARROW"] = "Right",
	["UPARROW"] = "Up",
}

function LushGearSwap_UnbindButton(a_button)
	local setName = a_button.text:GetText();
	local cKeyBind = "CLICK " .. LushKeybind_FramePrefix .. setName .. ":MiddleButton";
	while (GetBindingKey(cKeyBind)) do
		SetBinding(GetBindingKey(cKeyBind), nil)
	end
end

function LushGearSwap_GetBindingText(a_button)
	local setName = a_button.text:GetText();
	if setName then
		if a_button.text:GetName() then
			local BAction = "CLICK " .. LushKeybind_FramePrefix .. setName .. ":MiddleButton";
			local BindingString = GetBindingKey(BAction);
			if BindingString then		
				for old, new in pairs(LushGearSwap_KeyBinderAbrivations) do
					BindingString = BindingString:gsub(old, new);
				end
			
				return BindingString;
			end
		end
	end
	
	return "";
end

function LushGearSwap_KeybindFrame_OnClick(a_self)
	local setName = a_self:GetName():gsub("LushGearSwap_Keybind_", "");
	if setName then
		UseEquipmentSet(setName)
	end
end

function LushGearSwap_GearButtonKeyBindMode_OnKeyDown(a_self, a_key)	
	local setName = a_self.text:GetText();
	local KeyBindString = "";
	if a_self.LushGearSwap_BindModeActive then
		if a_key == "ESCAPE" then
			KeyBindString = nil;
		else
			if not LushGearSwap_KeyBinderIgnoreKeys[a_key] then
				KeyBindString = a_key;
				if IsShiftKeyDown() then
					KeyBindString = "SHIFT-" .. KeyBindString
				end
				if IsControlKeyDown() then
					KeyBindString = "CTRL-" .. KeyBindString
				end
				if IsAltKeyDown() then
					KeyBindString = "ALT-" .. KeyBindString
				end
			end
		end
		
		LushGearSwap_UnbindButton(a_self);

		if KeyBindString then
			SetBindingClick(KeyBindString, LushKeybind_FramePrefix .. setName, "MiddleButton");	
		end
		SaveBindings(2) -- Save Character Bindings
		
		LushGearSwap_UpdateKeybinds();
	end
end

function LushGearSwap_GearButtonKeyBindMode_OnEnter(a_self)
	a_self.LushGearSwap_OldOnKeyDownScript = a_self:GetScript('OnKeyDown');
	a_self:SetScript('OnKeyDown', LushGearSwap_GearButtonKeyBindMode_OnKeyDown);
	a_self.LushGearSwap_BindModeActive = true;
	a_self:EnableKeyboard(true);
end

function LushGearSwap_GearButtonKeyBindMode_OnLeave(a_self)
	a_self:SetScript('OnKeyDown', a_self.LushGearSwap_OldOnKeyDownScript);
	a_self.LushGearSwap_OldOnKeyDownScript = nil;
	a_self.LushGearSwap_BindModeActive = nil;
	a_self:EnableKeyboard(false);
end

function LushGearSwap_GearButtonKeyBindMode_OnClick(a_self)
	a_self:SetChecked(false);
end

function LushGearSwap_RefreshScrollBar(a_showMsg)
	-- [[ base offset ]] --
	local offset = 26;
	
	-- [[ The offset for the keybinds button ]] --
	offset = offset + 25;
	
	-- [[ Offset for the message window ]] --
	if a_showMsg == true then
		offset = offset + 80;
		LGS_KeyBindWidgets["MessageBox"]:Show();
	else
		LGS_KeyBindWidgets["MessageBox"]:Hide();
	end
	
	-- [[ Reset ]] --
	PaperDollEquipmentManagerPaneButton1:SetPoint("TOPLEFT", PaperDollEquipmentManagerPaneButton1:GetParent(), "TOPLEFT", 2, -offset);
end

function LushGearSwap_RegisterKeybindDisplay(a_button)
	if a_button then
		if LushGearSwap_KeybindTextMap[a_button] == nil then
			-- [[ Move the normal display text ]] --
			a_button.text:SetJustifyH("LEFT");
			a_button.text:SetJustifyV("TOP");

			-- [[ Create key bind display ]] --
			LushGearSwap_KeybindTextMap[a_button] = a_button:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
			LushGearSwap_KeybindTextMap[a_button]:SetAllPoints(a_button.text);
			LushGearSwap_KeybindTextMap[a_button]:SetJustifyH("LEFT");
			LushGearSwap_KeybindTextMap[a_button]:SetJustifyV("BOTTOM");
			LushGearSwap_KeybindTextMap[a_button]:SetFont("Fonts\\FRIZQT__.TTF", 10)
			LushGearSwap_KeybindTextMap[a_button]:Show();
		end
	end
end

function LushGearSwap_EnableKeybindMode(a_enable)
	LushGearSwap_RefreshScrollBar(a_enable)
	
	local msgFrame = LGS_KeyBindWidgets["MessageBox"];
	local keybindBtn = LGS_KeyBindWidgets["KeybindButton"];
	
	if a_enable == true then
		keybindBtn:SetText("Stop Binding");
		
		LushGearSwap_UpdateKeybinds();
		
		-- [[ Overload all the buttons for keybind mode ]] --
		LushGearSwap_OldButtonFuncs = {}
		for i=1, GetNumEquipmentSets() do
			local gearButton = getglobal("PaperDollEquipmentManagerPaneButton" .. i);
			if not gearButton then
				break;
			end
			
			LushGearSwap_OldButtonFuncs[gearButton] = {}
			LushGearSwap_OldButtonFuncs[gearButton].OnEnter 	= gearButton:GetScript('OnEnter');
			LushGearSwap_OldButtonFuncs[gearButton].OnLeave 	= gearButton:GetScript('OnLeave');
			LushGearSwap_OldButtonFuncs[gearButton].OnClick 	= gearButton:GetScript('OnClick');
			
			gearButton:SetScript('OnEnter', LushGearSwap_GearButtonKeyBindMode_OnEnter);
			gearButton:SetScript('OnLeave', LushGearSwap_GearButtonKeyBindMode_OnLeave);
			gearButton:SetScript('OnClick', LushGearSwap_GearButtonKeyBindMode_OnClick);
		end
	else
		msgFrame.msgTxt:SetText(LGS_KEYBINDMODE_HEADER);
		keybindBtn:SetText(LGS_KEYBINDMODE_BUTTON);
		
		-- [[ Restore all the buttons form keybind mode ]] --
		for buttonFrame, funcTable in pairs(LushGearSwap_OldButtonFuncs) do			
			buttonFrame:SetScript('OnEnter', funcTable.OnEnter);
			buttonFrame:SetScript('OnLeave', funcTable.OnLeave);
			buttonFrame:SetScript('OnClick', funcTable.OnClick);
		end
	end
end

function LushGearSwap_KeyBindButton_OnClick(a_self)
	LGS_KeyBindModeActive = not LGS_KeyBindModeActive;
	LushGearSwap_EnableKeybindMode(LGS_KeyBindModeActive);
end

function LushGearSwap_UpdateKeybinds()	
	-- [[ Prep the current buttons for display ]] --
	for i=1, GetNumEquipmentSets() do
		LushGearSwap_RegisterKeybindDisplay(getglobal("PaperDollEquipmentManagerPaneButton" .. i));
		
		local name = GetEquipmentSetInfo(i)
		if name then
			local frameName = LushKeybind_FramePrefix .. name;
			if LushGearSwap_Keybinds[frameName] == nil then
				local newKeybindFrame = CreateFrame("button", frameName, UIParent);
				newKeybindFrame:SetScript("OnClick", LushGearSwap_KeybindFrame_OnClick);				
				LushGearSwap_Keybinds[frameName] = newKeybindFrame;
			end
		end
	end
	
	for i=1, GetNumEquipmentSets() do
		local gearButton = getglobal("PaperDollEquipmentManagerPaneButton" .. i);
		if gearButton then
			LushGearSwap_KeybindTextMap[gearButton]:SetText(LushGearSwap_GetBindingText(gearButton));
		end
	end
end

function LushGearSwap_Keybind_PlayerEnteringWorld()
	LushGearSwap_UpdateKeybinds();
end

function LushGearSwap_Keybind_Init()
	-- [[ Create the keybind mode button ]] --
	local keybinds = CreateFrame("Button", "LushGearSwap_AddMoreSets", PaperDollEquipmentManagerPaneEquipSet, "UIPanelButtonTemplate");
	keybinds:ClearAllPoints();
	keybinds:SetPoint("TOPLEFT", PaperDollEquipmentManagerPaneEquipSet, "BOTTOMLEFT", 0, 0);
	keybinds:SetPoint("TOPRIGHT", PaperDollEquipmentManagerPaneSaveSet, "BOTTOMRIGHT", 0, 0);
	keybinds:SetHeight(25);
	keybinds:SetText(LGS_KEYBINDMODE_BUTTON);
	keybinds:Show();
	keybinds:SetScript("OnClick", LushGearSwap_KeyBindButton_OnClick)
	
	-- Create the Moreinfo txt box.
	local msgBox = CreateFrame("Frame", "LushGearSwap_MessageFrame", PaperDollEquipmentManagerPane);
	msgBox:SetPoint("TOPLEFT", keybinds, "BOTTOMLEFT", 2, 0);
	msgBox:SetPoint("TOPRIGHT", keybinds, "BOTTOMRIGHT", -2, 0);
	msgBox:SetHeight(80)
	msgBox:EnableMouse();
	
	msgBox.backgroundTexture = msgBox:CreateTexture()
	msgBox.backgroundTexture:SetAllPoints(msgBox)
	msgBox.backgroundTexture:SetTexture(0.0, 0.0, 0.0)
	
	msgBox.msgTxt = msgBox:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
	msgBox.msgTxt:SetAllPoints(msgBox);
	msgBox.msgTxt:SetJustifyH("CENTER");
	msgBox.msgTxt:SetJustifyV("CENTER");
	msgBox.msgTxt:SetFont("Fonts\\FRIZQT__.TTF", 11)
	msgBox.msgTxt:Show();
	
	-- [[ DIRTY HACK - TODO FIX! ]] --
	PaperDollEquipmentManagerPaneScrollChild:HookScript("OnUpdate", function(a_self, a_dt)
		LushGearSwap_HackyTimer = LushGearSwap_HackyTimer + a_dt;
		if LushGearSwap_HackyTimer > 0.15 then
			LushGearSwap_UpdateKeybinds();
			LushGearSwap_HackyTimer = 0
		end
	end);
	-- [[ END DIRTY HACK ]] --
	
	-- [[ Update keybinds on show ]] --
	PaperDollEquipmentManagerPane:HookScript("OnShow", function(a_self)
		LushGearSwap_UpdateKeybinds();
	end);
	
	-- [[ Access Map ]] --
	LGS_KeyBindWidgets["KeybindButton"] = keybinds;
	LGS_KeyBindWidgets["MessageBox"] = msgBox;
	
	LushGearSwap_EnableKeybindMode(false);
end

function LushGearSwap_Keybind_Event_EQUIPMENT_SETS_CHANGED()
	LushGearSwap_UpdateKeybinds();
end

LushGearSwap_AddPlugin			 ("Keybind", LushGearSwap_Keybind_Init, LushGearSwap_Keybind_PlayerEnteringWorld);
LushGearSwap_Plugin_RegisterEvent("Keybind", "EQUIPMENT_SETS_CHANGED", LushGearSwap_Keybind_Event_EQUIPMENT_SETS_CHANGED);