function ShortMacros_OnLoad()
	SlashCmdList["SM_DISABLE_ERRORS"] = ShortMacros_Disable_Errors
	SlashCmdList["SM_ENABLE_ERRORS"] = ShortMacros_Enable_Errors
	SlashCmdList["SM_RAIDTARGET_TARGET"] = ShortMacros_RaidTarget_Target
	SlashCmdList["SM_RAIDTARGET_MOUSEOVER"] = ShortMacros_RaidTarget_MouseOver
	SLASH_SM_DISABLE_ERRORS1 = "/disable_errors"
	SLASH_SM_DISABLE_ERRORS2 = "/de"
	SLASH_SM_ENABLE_ERRORS1 = "/enable_errors"
	SLASH_SM_ENABLE_ERRORS2 = "/ee"
	SLASH_SM_RAIDTARGET_TARGET1 = "/rtt"
	SLASH_SM_RAIDTARGET_MOUSEOVER1 = "/rtm"
end

function ShortMacros_Enable_Errors()
	UIErrorsFrame:Clear();
	UIErrorsFrame:Show();
	SetCVar("Sound_EnableSFX", 1);
end

function ShortMacros_Disable_Errors()
	UIErrorsFrame:Hide();
	SetCVar("Sound_EnableSFX", 0);
end

function ShortMacros_RaidTarget_Target(msg)
	SetRaidTarget("target", ParseRaidTarget(msg))
end

function ShortMacros_RaidTarget_MouseOver(msg)
	SetRaidTarget("mouseover", ParseRaidTarget(msg))
end

function ParseRaidTarget(msg)
	if msg == "clear" then return 0 end
	if msg == "star" then return 1 end
	if msg == "circle" then return 2 end 
	if msg == "diamond" then return 3 end 
	if msg == "triangle" then return 4 end 
	if msg == "moon" then return 5 end 
	if msg == "square" then return 6 end 
	if msg == "cross" then return 7 end 
	if msg == "skull" then return 8 end 

	-- didn't supply a word we recognise, so we'll just return whatever you typed
	return msg
end

ShortMacros_OnLoad()
