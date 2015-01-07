--[[
##############################################################################
_____/\\\\\\\\\\\____/\\\________/\\\__/\\\________/\\\__/\\\\\\\\\\\_       #
 ___/\\\/////////\\\_\/\\\_______\/\\\_\/\\\_______\/\\\_\/////\\\///__      #
  __\//\\\______\///__\//\\\______/\\\__\/\\\_______\/\\\_____\/\\\_____     #
   ___\////\\\__________\//\\\____/\\\___\/\\\_______\/\\\_____\/\\\_____    #
    ______\////\\\________\//\\\__/\\\____\/\\\_______\/\\\_____\/\\\_____   #
     _________\////\\\______\//\\\/\\\_____\/\\\_______\/\\\_____\/\\\_____  #
      __/\\\______\//\\\______\//\\\\\______\//\\\______/\\\______\/\\\_____ #
       _\///\\\\\\\\\\\/________\//\\\________\///\\\\\\\\\/____/\\\\\\\\\\\_#
        ___\///////////___________\///___________\/////////_____\///////////_#
##############################################################################
S U P E R - V I L L A I N - U I   By: Munglunch                              #
##############################################################################
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack    = _G.unpack;
local select    = _G.select;
local pairs     = _G.pairs;
local type      = _G.type;
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local tinsert   = _G.tinsert;
local string    = _G.string;
local table     = _G.table;
local math 		= _G.math;
--[[ STRING METHODS ]]--
local lower = string.lower;
--[[ MATH METHODS ]]--
local random = math.random;
--[[ TABLE METHODS ]]--
local tremove, twipe = table.remove, table.wipe;
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = assert;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local SVLib = LibSuperVillain("Registry");
local L = SV.L;
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local BUFFER = {};
local function UpdateActionBarOptions()
	if InCombatLockdown() or not SV.db.SVBar.IsLoaded then return end 
	if (SV.db.SVBar.Bar2.enable ~= InterfaceOptionsActionBarsPanelBottomRight:GetChecked()) then 
		InterfaceOptionsActionBarsPanelBottomRight:Click()
	end 
	if (SV.db.SVBar.Bar3.enable ~= InterfaceOptionsActionBarsPanelRightTwo:GetChecked()) then 
		InterfaceOptionsActionBarsPanelRightTwo:Click()
	end 
	if (SV.db.SVBar.Bar4.enable ~= InterfaceOptionsActionBarsPanelRight:GetChecked()) then 
		InterfaceOptionsActionBarsPanelRight:Click()
	end 
	if (SV.db.SVBar.Bar5.enable ~= InterfaceOptionsActionBarsPanelBottomLeft:GetChecked()) then 
		InterfaceOptionsActionBarsPanelBottomLeft:Click()
	end 
  	SV.SVBar:RefreshBar("Bar1")
	SV.SVBar:RefreshBar("Bar6")
end 
--[[ 
########################################################## 
DEFINITIONS
##########################################################
]]--
SV.SystemAlert = {};

SV.ActiveAlerts = {};

SV.SystemAlert["CLIENT_UPDATE_REQUEST"] = {
	text = L["Detected that your SVUI Config addon is out of date. Update as soon as possible."], 
	button1 = OKAY, 
	OnAccept = SV.fubar, 
	state1 = 1
};

SV.SystemAlert["FAILED_UISCALE"] = {
	text = L["You have changed your UIScale, however you still have the AutoScale option enabled in SVUI. Press accept if you would like to disable the Auto Scale option."], 
	button1 = ACCEPT, 
	button2 = CANCEL, 
	OnAccept = function() SV.db.general.autoScale = false; ReloadUI(); end,
	OnCancel = function() ReloadUI() end,
	timeout = 0, 
	whileDead = 1, 	
	hideOnEscape = false, 
}
SV.SystemAlert["TAINT_RL"] = {
	text = L["SVUI has lost it's damned mind! I need to reload your UI to fix it."], 
	button1 = ACCEPT, 
	button2 = CANCEL, 
	OnAccept = function()ReloadUI()end, 
	timeout = 0, 
	whileDead = 1, 
	hideOnEscape = true
};
SV.SystemAlert["RL_CLIENT"] = {
	text = L["A setting you have changed requires that you reload your User Interface."], 
	button1 = ACCEPT, 
	button2 = CANCEL, 
	OnAccept = function()ReloadUI()end, 
	timeout = 0, 
	whileDead = 1, 
	hideOnEscape = false
};
SV.SystemAlert["KEYBIND_MODE"] = {
	text = L["Hover your mouse over any actionbutton or spellbook button to bind it. Press the escape key or right click to clear the current actionbutton's keybinding."], 
	button1 = L["Save"], 
	button2 = L["Discard"], 
	OnAccept = function()SV.SVBar:ToggleKeyBindingMode(true, true)end, 
	OnCancel = function()SV.SVBar:ToggleKeyBindingMode(true, false)end, 
	timeout = 0, 
	whileDead = 1, 
	hideOnEscape = false
};
SV.SystemAlert["DELETE_GRAYS"] = {
	text = L["Are you sure you want to delete all your gray items?"], 
	button1 = YES, 
	button2 = NO, 
	OnAccept = function()SV.SVBag:VendorGrays(true) end, 
	OnShow = function(self)MoneyFrame_Update(self.moneyFrame, SV.SystemAlert["DELETE_GRAYS"].Money)end, 
	timeout = 0, 
	whileDead = 1, 
	hideOnEscape = false, 
	hasMoneyFrame = 1
};
SV.SystemAlert["BUY_BANK_SLOT"] = {
	text = CONFIRM_BUY_BANK_SLOT, 
	button1 = YES, 
	button2 = NO, 
	OnAccept = function(self)PurchaseSlot()end, 
	OnShow = function(self)MoneyFrame_Update(self.moneyFrame, GetBankSlotCost())end, 
	hasMoneyFrame = 1, 
	timeout = 0, 
	hideOnEscape = 1
};
SV.SystemAlert["CONFIRM_BUY_REAGENTBANK_TAB"] = {
	text = L["Purchase Reagents Bank?"], 
	button1 = YES, 
	button2 = NO, 
	OnAccept = function(self)BuyReagentBank()end, 
	OnShow = function(self)
		MoneyFrame_Update(self.moneyFrame, GetReagentBankCost());
		if(_G["SVUI_ReagentContainerFrame"]) then
			_G["SVUI_ReagentContainerFrame"]:UpdateLayout()
			_G["SVUI_ReagentContainerFrame"]:Show()
			if(_G["SVUI_ReagentContainerFrame"].swapButton) then
				_G["SVUI_ReagentContainerFrame"].swapButton:SetNormalTexture([[Interface\AddOns\SVUI\assets\artwork\Icons\BAGS-REAGENTS]])
			end
		end
	end, 
	hasMoneyFrame = 1, 
	timeout = 0, 
	hideOnEscape = 1
};
SV.SystemAlert["CANNOT_BUY_BANK_SLOT"] = {
	text = L["Can't buy anymore slots!"], 
	button1 = ACCEPT, 
	timeout = 0, 
	whileDead = 1
};
SV.SystemAlert["NO_BANK_BAGS"] = {
	text = L["You must purchase a bank slot first!"], 
	button1 = ACCEPT, 
	timeout = 0, 
	whileDead = 1
};
SV.SystemAlert["DISBAND_RAID"] = {
	text = L["Are you sure you want to disband the group?"],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() SV:DisbandRaidGroup() end,
	timeout = 0,
	whileDead = 1,
};
SV.SystemAlert["RESETMOVERS_CHECK"] = {
	text = L["Are you sure you want to reset every mover back to it's default position?"], 
	button1 = ACCEPT, 
	button2 = CANCEL, 
	OnAccept = function(a)SV:ResetUI(true)end, 
	timeout = 0, 
	whileDead = 1
};
SV.SystemAlert["RESETMENTALO_CHECK"] = {
	text = L["Are you sure you want to all SVUI frames to their original positions?"], 
	button1 = ACCEPT, 
	button2 = CANCEL, 
	OnAccept = function(a)SV.Mentalo:Reset()end, 
	timeout = 0, 
	whileDead = 1
};
SV.SystemAlert["RESETBLIZZARD_CHECK"] = {
	text = L["Are you sure you want to all draggable Blizzard frames to their original positions? This will reload your UI."], 
	button1 = ACCEPT, 
	button2 = CANCEL, 
	OnAccept = function(a)SV.Dragger:Reset()end, 
	timeout = 0, 
	whileDead = 1
};
SV.SystemAlert["RESET_UI_CHECK"] = {
	text = L["I will attempt to preserve some of your basic settings but no promises. This will clean out everything else. Are you sure you want to reset everything?"], 
	button1 = ACCEPT, 
	button2 = CANCEL, 
	OnAccept = function(a)SV:ResetAllUI(true)end, 
	timeout = 0, 
	whileDead = 1
};
SV.SystemAlert["RESETDOCKS_CHECK"] = {
	text = L["Are you sure you want to reset every dock button back to it's default position?"], 
	button1 = ACCEPT, 
	button2 = CANCEL, 
	OnAccept = function(a)SV.Dock:ResetAllButtons()end, 
	timeout = 0, 
	whileDead = 1
};
SV.SystemAlert["CONFIRM_LOOT_DISTRIBUTION"] = {
	text = CONFIRM_LOOT_DISTRIBUTION, 
	button1 = YES, 
	button2 = NO, 
	timeout = 0, 
	hideOnEscape = 1
};
SV.SystemAlert["RESET_PROFILE_PROMPT"] = {
	text = L["Are you sure you want to reset all the settings on this profile?"], 
	button1 = YES, 
	button2 = NO, 
	timeout = 0, 
	hideOnEscape = 1, 
	OnAccept = function()
		SVLib:WipeDatabase()
		SVLib:WipeCache("Anchors")
		ReloadUI()
	end
};
SV.SystemAlert["COPY_PROFILE_PROMPT"] = {
	text = L["Are you sure you want to copy all settings from this profile?"], 
	button1 = YES, 
	button2 = NO, 
	timeout = 0, 
	hideOnEscape = 1, 
	OnAccept = SV.fubar
};
SV.SystemAlert["BAR6_CONFIRMATION"] = {
	text = L["Enabling / Disabling Bar #6 will toggle a paging option from your main actionbar to prevent duplicating bars, are you sure you want to do this?"], 
	button1 = YES, 
	button2 = NO, 
	OnAccept = function(a)
		if SV.db.SVBar["BAR6"].enable ~= true then 
			SV.db.SVBar.Bar6.enable = true;
			UpdateActionBarOptions()
		else 
			SV.db.SVBar.Bar6.enable = false;
			UpdateActionBarOptions()
		end 
	end, 
	OnCancel = SV.fubar, 
	timeout = 0, 
	whileDead = 1, 
	state1 = 1
};

SV.SystemAlert["CONFIRM_LOSE_BINDING_CHANGES"] = {
	text = CONFIRM_LOSE_BINDING_CHANGES, 
	button1 = OKAY, 
	button2 = CANCEL, 
	OnAccept = function(a)
		if SVUI_KeyBindPopupCheckButton:GetChecked() then 
			LoadBindings(2)
			SaveBindings(2)
		else 
			LoadBindings(1)
			SaveBindings(1)
		end
		SV.SVBar.bindingsChanged = nil 
	end, 
	OnCancel = function(a)
		if SVUI_KeyBindPopupCheckButton:GetChecked()then 
			SVUI_KeyBindPopupCheckButton:SetChecked(false)
		else 
			SVUI_KeyBindPopupCheckButton:SetChecked(true)
		end 
	end, 
	timeout = 0, 
	whileDead = 1, 
	state1 = 1
};
SV.SystemAlert["INCOMPATIBLE_ADDON"] = {
	text = L["INCOMPATIBLE_ADDON"], 
	OnAccept = function(a)DisableAddOn(SV.SystemAlert["INCOMPATIBLE_ADDON"].addon)ReloadUI()end, 
	OnCancel = function(a)SV[lower(SV.SystemAlert["INCOMPATIBLE_ADDON"].package)].db.enable = false; ReloadUI()end, 
	timeout = 0, 
	whileDead = 1, 
	hideOnEscape = false
};
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
local MAX_STATIC_POPUPS = 4
local SysPop_Event_Show = function(self)
	PlaySound("igMainMenuOpen");

	local dialog = SV.SystemAlert[self.which];
	local OnShow = dialog.OnShow;

	if ( OnShow ) then
		OnShow(self, self.data);
	end
	if ( dialog.hasMoneyInputFrame ) then
		_G[self:GetName().."MoneyInputFrameGold"]:SetFocus();
	end
	if ( dialog.enterClicksFirstButton ) then
		self:SetScript("OnKeyDown", SysPop_Event_KeyDown);
	end
end

local SysBox_Event_KeyEscape = function(self)
	local closed = nil;
	for _, frame in pairs(SV.ActiveAlerts) do
		if( frame:IsShown() and frame.hideOnEscape ) then
			local standardDialog = SV.SystemAlert[frame.which];
			if ( standardDialog ) then
				local OnCancel = standardDialog.OnCancel;
				local noCancelOnEscape = standardDialog.noCancelOnEscape;
				if ( OnCancel and not noCancelOnEscape) then
					OnCancel(frame, frame.data, "clicked");
				end
				frame:Hide();
			else
				SV:StaticPopupSpecial_Hide(frame);
			end
			closed = 1;
		end
	end
	return closed;
end

local SysPop_Close_Unique = function(self)
	SysPop_Close_Unique:Hide();
	SysPop_Close_Table();
end

local SysPop_Close_Table = function()
	local displayedFrames = SV.ActiveAlerts;
	local index = #displayedFrames;
	while ( ( index >= 1 ) and ( not displayedFrames[index]:IsShown() ) ) do
		tremove(displayedFrames, index);
		index = index - 1;
	end
end

local SysPop_Move = function(self)
	if ( not tContains(SV.ActiveAlerts, self) ) then
		local lastFrame = SV.ActiveAlerts[#SV.ActiveAlerts];
		if ( lastFrame ) then	
			self:SetPoint("TOP", lastFrame, "BOTTOM", 0, -4);
		else
			self:SetPoint("TOP", SV.Screen, "TOP", 0, -100);
		end
		tinsert(SV.ActiveAlerts, self);
	end
end

local SysPop_Event_KeyDown = function(self, key)
	if ( GetBindingFromClick(key) == "TOGGLEGAMEMENU" ) then
		return SysBox_Event_KeyEscape();
	elseif ( GetBindingFromClick(key) == "SCREENSHOT" ) then
		RunBinding("SCREENSHOT");
		return;
	end

	local dialog = SV.SystemAlert[self.which];
	if ( dialog ) then
		if ( key == "ENTER" and dialog.enterClicksFirstButton ) then
			local frameName = self:GetName();
			local button;
			local i = 1;
			while ( true ) do
				button = _G[frameName.."Button"..i];
				if ( button ) then
					if ( button:IsShown() ) then
						SysPop_Event_Click(self, i);
						return;
					end
					i = i + 1;
				else
					break;
				end
			end
		end
	end
end

local SysPop_Event_Click = function(self, index)
	if ( not self:IsShown() ) then
		return;
	end
	local which = self.which;
	local info = SV.SystemAlert[which];
	if ( not info ) then
		return nil;
	end
	local hide = true;
	if ( index == 1 ) then
		local OnAccept = info.OnAccept;
		if ( OnAccept ) then
			hide = not OnAccept(self, self.data, self.data2);
		end
	elseif ( index == 3 ) then
		local OnAlt = info.OnAlt;
		if ( OnAlt ) then
			OnAlt(self, self.data, "clicked");
		end
	else
		local OnCancel = info.OnCancel;
		if ( OnCancel ) then
			hide = not OnCancel(self, self.data, "clicked");
		end
	end

	if ( hide and (which == self.which) ) then
		self:Hide();
	end
end

local SysPop_Event_Hide = function(self)
	PlaySound("igMainMenuClose");

	SysPop_Close_Table();
	
	local dialog = SV.SystemAlert[self.which];
	local OnHide = dialog.OnHide;
	if ( OnHide ) then
		OnHide(self, self.data);
	end
	self.extraFrame:Hide();
	if ( dialog.enterClicksFirstButton ) then
		self:SetScript("OnKeyDown", nil);
	end
end

local SysPop_Event_Update = function(self, elapsed)
	if ( self.timeleft and self.timeleft > 0 ) then
		local which = self.which;
		local timeleft = self.timeleft - elapsed;
		if ( timeleft <= 0 ) then
			if ( not SV.SystemAlert[which].timeoutInformationalOnly ) then
				self.timeleft = 0;
				local OnCancel = SV.SystemAlert[which].OnCancel;
				if ( OnCancel ) then
					OnCancel(self, self.data, "timeout");
				end
				self:Hide();
			end
			return;
		end
		self.timeleft = timeleft;
	end
	
	if ( self.startDelay ) then
		local which = self.which;
		local timeleft = self.startDelay - elapsed;
		if ( timeleft <= 0 ) then
			self.startDelay = nil;
			local text = _G[self:GetName().."Text"];
			text:SetFormattedText(SV.SystemAlert[which].text, text.text_arg1, text.text_arg2);
			local button1 = _G[self:GetName().."Button1"];
			button1:Enable();
			StaticPopup_Resize(self, which);
			return;
		end
		self.startDelay = timeleft;
	end

	local onUpdate = SV.SystemAlert[self.which].OnUpdate;
	if ( onUpdate ) then
		onUpdate(self, elapsed);
	end
end

local SysBox_Event_KeyEnter = function(self)
	local EditBoxOnEnterPressed, which, dialog;
	local parent = self:GetParent();
	if ( parent.which ) then
		which = parent.which;
		dialog = parent;
	elseif ( parent:GetParent().which ) then
		-- This is needed if this is a money input frame since it's nested deeper than a normal edit box
		which = parent:GetParent().which;
		dialog = parent:GetParent();
	end
	if ( not self.autoCompleteParams or not AutoCompleteEditBox_OnEnterPressed(self) ) then
		EditBoxOnEnterPressed = SV.SystemAlert[which].EditBoxOnEnterPressed;
		if ( EditBoxOnEnterPressed ) then
			EditBoxOnEnterPressed(self, dialog.data);
		end
	end
end

local SysBox_Event_KeyEscape = function(self)
	local EditBoxOnEscapePressed = SV.SystemAlert[self:GetParent().which].EditBoxOnEscapePressed;
	if ( EditBoxOnEscapePressed ) then
		EditBoxOnEscapePressed(self, self:GetParent().data);
	end
end

local SysBox_Event_Change = function(self, userInput)
	if ( not self.autoCompleteParams or not AutoCompleteEditBox_OnTextChanged(self, userInput) ) then
		local EditBoxOnTextChanged = SV.SystemAlert[self:GetParent().which].EditBoxOnTextChanged;
		if ( EditBoxOnTextChanged ) then
			EditBoxOnTextChanged(self, self:GetParent().data);
		end
	end
end

local SysPop_Size = function(self, which)
	local info = SV.SystemAlert[which];
	if ( not info ) then
		return nil;
	end

	local text = _G[self:GetName().."Text"];
	local editBox = _G[self:GetName().."EditBox"];
	local button1 = _G[self:GetName().."Button1"];
	
	local maxHeightSoFar, maxWidthSoFar = (self.maxHeightSoFar or 0), (self.maxWidthSoFar or 0);
	local width = 320;
	
	if ( self.numButtons == 3 ) then
		width = 440;
	elseif (info.showAlert or info.showAlertGear or info.closeButton) then
		-- Widen
		width = 420;
	elseif ( info.editBoxWidth and info.editBoxWidth > 260 ) then
		width = width + (info.editBoxWidth - 260);
	end
	
	if ( width > maxWidthSoFar )  then
		self:SetWidth(width);
		self.maxWidthSoFar = width;
	end
	
	local height = 32 + text:GetHeight() + 8 + button1:GetHeight();
	if ( info.hasEditBox ) then
		height = height + 8 + editBox:GetHeight();
	elseif ( info.hasMoneyFrame ) then
		height = height + 16;
	elseif ( info.hasMoneyInputFrame ) then
		height = height + 22;
	end
	if ( info.hasItemFrame ) then
		height = height + 64;
	end

	if ( height > maxHeightSoFar ) then
		self:SetHeight(height);
		self.maxHeightSoFar = height;
	end
end

local SysPop_Event_Listener = function(self)
	self.maxHeightSoFar = 0;
	SysPop_Size(self, self.which);
end

local SysPop_Find = function(which, data)
	local info = SV.SystemAlert[which];
	if ( not info ) then
		return nil;
	end
	for index = 1, MAX_STATIC_POPUPS, 1 do
		local frame = _G["SVUI_SystemAlert"..index];
		if (frame and frame:IsShown() and (frame.which == which) and (not info.multiple or (frame.data == data)) ) then
			return frame;
		end
	end
	return nil;
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function SV:StaticPopupSpecial_Hide(frame)
	frame:Hide();
	SysPop_Close_Table();
end

function SV:StaticPopup_HideExclusive()
	for _, frame in pairs(self.ActiveAlerts) do
        if ( frame:IsShown() and frame.exclusive ) then
            local standardDialog = self.SystemAlert[frame.which];
            if ( standardDialog ) then
                frame:Hide();
                local OnCancel = standardDialog.OnCancel;
                if ( OnCancel ) then
                    OnCancel(frame, frame.data, "override");
                end
            else
                self:StaticPopupSpecial_Hide(frame);
            end
            break;
        end
    end
end

function SV:StaticPopupSpecial_Show(frame)
	if ( frame.exclusive ) then
		self:StaticPopup_HideExclusive();
	end
	SysPop_Move(frame);
	frame:Show();
end

function SV:StaticPopup_Show(which, text_arg1, text_arg2, data)
	local info = SV.SystemAlert[which];
	if ( not info ) then
		return nil;
	end
	if ( UnitIsDeadOrGhost("player") and not info.whileDead ) then
		if ( info.OnCancel ) then
			info.OnCancel();
		end
		return nil;
	end
	if ( InCinematic() and not info.interruptCinematic ) then
		if ( info.OnCancel ) then
			info.OnCancel();
		end
		return nil;
	end
	if ( info.cancels ) then
		for index = 1, MAX_STATIC_POPUPS, 1 do
			local frame = _G["SVUI_SystemAlert"..index];
			if ( frame:IsShown() and (frame.which == info.cancels) ) then
				frame:Hide();
				local OnCancel = SV.SystemAlert[frame.which].OnCancel;
				if ( OnCancel ) then
					OnCancel(frame, frame.data, "override");
				end
			end
		end
	end
	local dialog = nil;
	dialog = SysPop_Find(which, data);
	if ( dialog ) then
		if ( not info.noCancelOnReuse ) then
			local OnCancel = info.OnCancel;
			if ( OnCancel ) then
				OnCancel(dialog, dialog.data, "override");
			end
		end
		dialog:Hide();
	end
	if ( not dialog ) then
		local index = 1;
		if ( info.preferredIndex ) then
			index = info.preferredIndex;
		end
		for i = index, MAX_STATIC_POPUPS do
			local frame = _G["SVUI_SystemAlert"..i];
			if (frame and not frame:IsShown() ) then
				dialog = frame;
				break;
			end
		end
		if ( not dialog and info.preferredIndex ) then
			for i = 1, info.preferredIndex do
				local frame = _G["SVUI_SystemAlert"..i];
				if ( not frame:IsShown() ) then
					dialog = frame;
					break;
				end
			end
		end
	end
	if ( not dialog ) then
		if ( info.OnCancel ) then
			info.OnCancel();
		end
		return nil;
	end
	dialog.maxHeightSoFar, dialog.maxWidthSoFar = 0, 0;
	local text = _G[dialog:GetName().."Text"];
	text:SetFormattedText(info.text, text_arg1, text_arg2);
	if ( info.closeButton ) then
		local closeButton = _G[dialog:GetName().."CloseButton"];
		if ( info.closeButtonIsHide ) then
			closeButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-HideButton-Up");
			closeButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-HideButton-Down");
		else
			closeButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up");
			closeButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down");
		end
		closeButton:Show();
	else
		_G[dialog:GetName().."CloseButton"]:Hide();
	end
	local editBox = _G[dialog:GetName().."EditBox"];
	if ( info.hasEditBox ) then
		editBox:Show();
		if ( info.maxLetters ) then
			editBox:SetMaxLetters(info.maxLetters);
			editBox:SetCountInvisibleLetters(info.countInvisibleLetters);
		end
		if ( info.maxBytes ) then
			editBox:SetMaxBytes(info.maxBytes);
		end
		editBox:SetText("");
		if ( info.editBoxWidth ) then
			editBox:SetWidth(info.editBoxWidth);
		else
			editBox:SetWidth(130);
		end
	else
		editBox:Hide();
	end
	if ( info.hasMoneyFrame ) then
		_G[dialog:GetName().."MoneyFrame"]:Show();
		_G[dialog:GetName().."MoneyInputFrame"]:Hide();
	elseif ( info.hasMoneyInputFrame ) then
		local moneyInputFrame = _G[dialog:GetName().."MoneyInputFrame"];
		moneyInputFrame:Show();
		_G[dialog:GetName().."MoneyFrame"]:Hide();
		if ( info.EditBoxOnEnterPressed ) then
			moneyInputFrame.gold:SetScript("OnEnterPressed", SysBox_Event_KeyEnter);
			moneyInputFrame.silver:SetScript("OnEnterPressed", SysBox_Event_KeyEnter);
			moneyInputFrame.copper:SetScript("OnEnterPressed", SysBox_Event_KeyEnter);
		else
			moneyInputFrame.gold:SetScript("OnEnterPressed", nil);
			moneyInputFrame.silver:SetScript("OnEnterPressed", nil);
			moneyInputFrame.copper:SetScript("OnEnterPressed", nil);
		end
	else
		_G[dialog:GetName().."MoneyFrame"]:Hide();
		_G[dialog:GetName().."MoneyInputFrame"]:Hide();
	end
	if ( info.hasItemFrame ) then
		_G[dialog:GetName().."ItemFrame"]:Show();
		if ( data and type(data) == "table" ) then
			_G[dialog:GetName().."ItemFrame"].link = data.link
			_G[dialog:GetName().."ItemFrameIconTexture"]:SetTexture(data.texture);
			local nameText = _G[dialog:GetName().."ItemFrameText"];
			nameText:SetTextColor(unpack(data.color or {1, 1, 1, 1}));
			nameText:SetText(data.name);
			if ( data.count and data.count > 1 ) then
				_G[dialog:GetName().."ItemFrameCount"]:SetText(data.count);
				_G[dialog:GetName().."ItemFrameCount"]:Show();
			else
				_G[dialog:GetName().."ItemFrameCount"]:Hide();
			end
		end
	else
		_G[dialog:GetName().."ItemFrame"]:Hide();
	end
	dialog.which = which;
	dialog.timeleft = info.timeout;
	dialog.hideOnEscape = info.hideOnEscape;
	dialog.exclusive = info.exclusive;
	dialog.enterClicksFirstButton = info.enterClicksFirstButton;
	dialog.data = data;
	local button1 = _G[dialog:GetName().."Button1"];
	local button2 = _G[dialog:GetName().."Button2"];
	local button3 = _G[dialog:GetName().."Button3"];
	do
		assert(#BUFFER == 0);
		tinsert(BUFFER, button1);
		tinsert(BUFFER, button2);
		tinsert(BUFFER, button3);
		for i=#BUFFER, 1, -1 do
			BUFFER[i]:SetText(info["button"..i]);
			BUFFER[i]:Hide();
			BUFFER[i]:ClearAllPoints();
			if ( not (info["button"..i] and ( not info["DisplayButton"..i] or info["DisplayButton"..i](dialog))) ) then
				tremove(BUFFER, i);
			end
		end
		local numButtons = #BUFFER;
		dialog.numButtons = numButtons;
		if ( numButtons == 3 ) then
			BUFFER[1]:SetPoint("BOTTOMRIGHT", dialog, "BOTTOM", -72, 16);
		elseif ( numButtons == 2 ) then
			BUFFER[1]:SetPoint("BOTTOMRIGHT", dialog, "BOTTOM", -6, 16);
		elseif ( numButtons == 1 ) then
			BUFFER[1]:SetPoint("BOTTOM", dialog, "BOTTOM", 0, 16);
		end
		for i=1, numButtons do
			if ( i > 1 ) then
				BUFFER[i]:SetPoint("LEFT", BUFFER[i-1], "RIGHT", 13, 0);
			end
			local width = BUFFER[i]:GetTextWidth();
			if ( width > 110 ) then
				BUFFER[i]:SetWidth(width + 20);
			else
				BUFFER[i]:SetWidth(120);
			end
			BUFFER[i]:Enable();
			BUFFER[i]:Show();
		end
		table.wipe(BUFFER);
	end
	local alertIcon = _G[dialog:GetName().."AlertIcon"];
	if ( info.showAlert ) then
		alertIcon:SetTexture(STATICPOPUP_TEXTURE_ALERT);
		if ( button3:IsShown() )then
			alertIcon:SetPoint("LEFT", 24, 10);
		else
			alertIcon:SetPoint("LEFT", 24, 0);
		end
		alertIcon:Show();
	elseif ( info.showAlertGear ) then
		alertIcon:SetTexture(STATICPOPUP_TEXTURE_ALERTGEAR);
		if ( button3:IsShown() )then
			alertIcon:SetPoint("LEFT", 24, 0);
		else
			alertIcon:SetPoint("LEFT", 24, 0);
		end
		alertIcon:Show();
	else
		alertIcon:SetTexture();
		alertIcon:Hide();
	end
	if ( info.StartDelay ) then
		dialog.startDelay = info.StartDelay();
		button1:Disable();
	else
		dialog.startDelay = nil;
		button1:Enable();
	end
	editBox.autoCompleteParams = info.autoCompleteParams;
	editBox.autoCompleteRegex = info.autoCompleteRegex;
	editBox.autoCompleteFormatRegex = info.autoCompleteFormatRegex;
	editBox.addHighlightedText = true;
	SysPop_Move(dialog);
	dialog:Show();
	SysPop_Size(dialog, which);
	if (not dialog:IsShown() and info.sound) then
		PlaySound(info.sound);
	end
	return dialog;
end

function SV:StaticPopup_Hide(which, data)
	for index = 1, MAX_STATIC_POPUPS, 1 do
		local dialog = _G["SVUI_SystemAlert"..index];
		if (dialog and (dialog.which == which) and (not data or (data == dialog.data)) ) then
			dialog:Hide();
		end
	end
end

local function rng()
	local x,y = random(10,70), random(10,70)
	return x,y
end

local function SetConfigAlertAnim(f)
	local x = 50;
	local y = 150;
	f.trans = f:CreateAnimationGroup()
	f.trans[1] = f.trans:CreateAnimation("Translation")
	f.trans[1]:SetOrder(1)
	f.trans[1]:SetDuration(0.3)
	f.trans[1]:SetOffset(x,y)
	f.trans[1]:SetScript("OnPlay",function()f:SetScale(0.01)f:Show()end)
	f.trans[1]:SetScript("OnUpdate",function(self)f:SetScale(0.1+(1*f.trans[1]:GetProgress()))end)
	f.trans[2] = f.trans:CreateAnimation("Translation")
	f.trans[2]:SetOrder(2)
	f.trans[2]:SetDuration(0.7)
	f.trans[2]:SetOffset(x*.5,y*.5)
	f.trans[3] = f.trans:CreateAnimation("Translation")
	f.trans[3]:SetOrder(3)
	f.trans[3]:SetDuration(0.1)
	f.trans[3]:SetOffset(0,0)
	f.trans[3]:SetScript("OnStop",function()f:Hide()end)
	f.trans:SetScript("OnFinished",f.trans[3]:GetScript("OnStop"))
end

function SV:SavedPopup()
	if not _G["SVUI_ConfigAlert"] then return end 
	local alert = _G["SVUI_ConfigAlert"]
	local x,y = rng()
	if(alert:IsShown()) then
		alert:Hide()
	end
	alert:Show()
	alert.bg.anim:Play()
	alert.bg.trans[1]:SetOffset(x,y)
	alert.fg.trans[1]:SetOffset(x,y)
	alert.bg.trans[2]:SetOffset(x*.5,y*.5)
	alert.fg.trans[2]:SetOffset(x*.5,y*.5)
	alert.bg.trans:Play()
	alert.fg.trans:Play()
		
	PlaySoundFile("Sound\\Interface\\uCharacterSheetOpen.wav")
end

local AlertButton_OnClick = function(self)
	SysPop_Event_Click(self:GetParent(), self:GetID())
end

function SV:LoadSystemAlerts()
	if not _G["SVUI_ConfigAlert"] then 
		local configAlert = CreateFrame("Frame", "SVUI_ConfigAlert", UIParent)
		configAlert:SetFrameStrata("TOOLTIP")
		configAlert:SetFrameLevel(979)
		configAlert:SetSizeToScale(300, 300)
		configAlert:SetPointToScale("CENTER", 200, -150)
		configAlert:Hide()

		configAlert.bg = CreateFrame("Frame", nil, configAlert)
		configAlert.bg:SetSizeToScale(300, 300)
		configAlert.bg:SetPointToScale("CENTER")
		configAlert.bg:SetFrameStrata("TOOLTIP")
		configAlert.bg:SetFrameLevel(979)
		local bgtex = configAlert.bg:CreateTexture(nil, "BACKGROUND")
		bgtex:SetAllPoints()
		bgtex:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\SAVED-BG")
		SetConfigAlertAnim(configAlert.bg)

		configAlert.fg = CreateFrame("Frame", nil, configAlert)
		configAlert.fg:SetSizeToScale(300, 300)
		configAlert.fg:SetPointToScale("CENTER", bgtex, "CENTER")
		configAlert.fg:SetFrameStrata("TOOLTIP")
		configAlert.fg:SetFrameLevel(999)
		local fgtex = configAlert.fg:CreateTexture(nil, "ARTWORK")
		fgtex:SetAllPoints()
		fgtex:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\SAVED-FG")
		SetConfigAlertAnim(configAlert.fg)

		self.Animate:Orbit(configAlert.bg, 10, false, true)
	end 
	for i = 1, 4 do 
		local alert = CreateFrame("Frame", "SVUI_SystemAlert"..i, UIParent, "StaticPopupTemplate")
		alert:SetID(i)
		alert:SetScript("OnShow", SysPop_Event_Show)
		alert:SetScript("OnHide", SysPop_Event_Hide)
		alert:SetScript("OnUpdate", SysPop_Event_Update)
		alert:SetScript("OnEvent", SysPop_Event_Listener)
		alert.input = _G["SVUI_SystemAlert"..i.."EditBox"];
		alert.input:SetScript("OnEnterPressed", SysBox_Event_KeyEnter)
		alert.input:SetScript("OnEscapePressed", SysBox_Event_KeyEscape)
		alert.input:SetScript("OnTextChanged", SysBox_Event_Change)
		alert.gold = _G["SVUI_SystemAlert"..i.."MoneyInputFrameGold"];
		alert.silver = _G["SVUI_SystemAlert"..i.."MoneyInputFrameSilver"];
		alert.copper = _G["SVUI_SystemAlert"..i.."MoneyInputFrameCopper"];
		alert.buttons = {}
		for b = 1, 3 do
			local button = _G["SVUI_SystemAlert"..i.."Button"..b];
			button:SetScript("OnClick", AlertButton_OnClick)
			alert.buttons[b] = button
		end 
		_G["SVUI_SystemAlert"..i.."ItemFrameNameFrame"]:Die()
		_G["SVUI_SystemAlert"..i.."ItemFrame"]:GetNormalTexture():Die()
		_G["SVUI_SystemAlert"..i.."ItemFrame"]:SetStylePanel("Button")
		_G["SVUI_SystemAlert"..i.."ItemFrameIconTexture"]:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		_G["SVUI_SystemAlert"..i.."ItemFrameIconTexture"]:SetAllPointsIn()
	end 
end 