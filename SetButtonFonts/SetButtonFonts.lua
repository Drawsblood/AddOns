local frame = CreateFrame("FRAME", "SetButtonFonts");
frame:RegisterEvent("PLAYER_LOGIN");
local function eventHandler(self, event, ...)
  GameFontHighlightSmallOutline:SetFont("Interface\\AddOns\\Prat-3.0\\fonts\\DORISPP.ttf", 9, "OUTLINE")
  NumberFontNormalSmallGray:SetFont("Interface\\AddOns\\Prat-3.0\\fonts\\DORISPP.ttf", 10, "OUTLINE")
  NumberFontNormal:SetFont("Interface\\AddOns\\Prat-3.0\\fonts\\DORISPP.ttf", 10, "OUTLINE")
end
frame:SetScript("OnEvent", eventHandler);

