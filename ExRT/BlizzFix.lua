local GlobalAddonName, ExRT = ...

-- RELOAD UI short command
SLASH_RELOADUI1 = "/rl"
SlashCmdList["RELOADUI"] = ReloadUI


-- Beta enUS & cyrillic fix
if ExRT.BETA and ExRT.locale:find("^en") and ExRT.EnableCyrillic then
	GameFontHighlightSmall:SetFont("Fonts\\FRIZQT___CYR.TTF",select(2,GameFontHighlightSmall:GetFont()))
	GameFontNormalSmall:SetFont("Fonts\\FRIZQT___CYR.TTF",select(2,GameFontNormalSmall:GetFont()))
	GameFontNormal:SetFont("Fonts\\FRIZQT___CYR.TTF",select(2,GameFontNormalSmall:GetFont()))
	ChatFontNormal:SetFont("Fonts\\FRIZQT___CYR.TTF",select(2,ChatFontNormal:GetFont()))
end