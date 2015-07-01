--============================================================================================--
--============================================================================================--
--																							--
--							  INTERFACE FUNCTIONS											 --
--																							--
--============================================================================================--
--============================================================================================--

local TEXT = Wardrobe.GetString;
local L = LibStub("AceLocale-3.0"):GetLocale("Wardrobe")
local TipHooker = LibStub("LibTipHooker-1.1")

local _;

WARDROBE_TEXTCOLORS = {
	{1.00, 0.00, 0.00},	-- red
	{1.00, 0.50, 0.50},	-- light red
	{1.00, 0.50, 0.00},	-- orange
	{1.00, 0.75, 0.50},	-- light orange
	{1.00, 0.75, 0.00},	-- gold
	{1.00, 0.87, 0.50},	-- light gold

	{1.00, 1.00, 0.00},	-- yellow
	{1.00, 1.00, 0.50},	-- light yellow
	{0.50, 1.00, 0.00},	-- yellow-green
	{0.75, 1.00, 0.50},	-- light yellow-green
	{0.00, 1.00, 0.00},	-- green
	{0.50, 1.00, 0.50},	-- light green

	{0.00, 1.00, 0.50},	-- blue-green
	{0.50, 1.00, 0.75},	-- light blue-green
	{0.00, 1.00, 1.00},	-- cyan
	{0.50, 1.00, 1.00},	-- light cyan
	{0.00, 0.00, 1.00},	-- blue
	{0.50, 0.50, 1.00},	-- light blue

	{0.50, 0.00, 1.00},	-- blue-purple
	{0.75, 0.50, 1.00},	-- light blue-purple
	{1.00, 0.00, 1.00},	-- purple
	{1.00, 0.50, 1.00},	-- light purple
	{1.00, 0.00, 0.50},	-- pink-red
	{1.00, 0.50, 0.75}	 -- light pink-red
};

WARDROBE_DRABCOLORS = {
	{0.50, 0.00, 0.00},	-- red
	{0.50, 0.25, 0.25},	-- light red
	{0.50, 0.25, 0.00},	-- orange
	{0.50, 0.38, 0.25},	-- light orange
	{0.50, 0.38, 0.00},	-- gold
	{0.50, 0.43, 0.25},	-- light gold

	{0.50, 0.50, 0.00},	-- yellow
	{0.50, 0.50, 0.25},	-- light yellow
	{0.25, 0.50, 0.00},	-- yellow-green
	{0.38, 0.50, 0.25},	-- light yellow-green
	{0.00, 0.50, 0.00},	-- green
	{0.25, 0.50, 0.25},	-- light green

	{0.00, 0.50, 0.25},	-- blue-green
	{0.25, 0.50, 0.38},	-- light blue-green
	{0.00, 0.50, 0.50},	-- cyan
	{0.25, 0.50, 0.50},	-- light cyan
	{0.00, 0.00, 0.50},	-- blue
	{0.25, 0.25, 0.50},	-- light blue

	{0.25, 0.00, 0.50},	-- blue-purple
	{0.38, 0.25, 0.50},	-- light blue-purple
	{0.50, 0.00, 0.50},	-- purple
	{0.50, 0.25, 0.50},	-- light purple
	{0.50, 0.00, 0.25},	-- pink-red
	{0.50, 0.25, 0.38},	-- light pink-red
};

WARDROBE_UNAVAILIBLECOLOR = {0.70, 0.76, 0.65};

Wardrobe.DISPLAYON_TEXTURE="Interface\\AddOns\\Wardrobe\\Images\\DisplayOn";
Wardrobe.DISPLAYOFF_TEXTURE="Interface\\AddOns\\Wardrobe\\Images\\DisplayOff";

--===============================================================================
--
-- UI Menu and Button
--
--===============================================================================

---------------------------------------------------------------------------------
-- Start dragging the wardrobe button
---------------------------------------------------------------------------------
function Wardrobe.IconFrame_OnDragStart()
	Wardrobe.Debug("Wardrobe.IconFrame_OnDragStart()");
	if (not WardrobeAce.db.char.dragLock) then
		Wardrobe_IconFrame:StartMoving()
		Wardrobe.BeingDragged = true;
	end
end


---------------------------------------------------------------------------------
-- Stop dragging the wardrobe button
---------------------------------------------------------------------------------
function Wardrobe.IconFrame_OnDragStop()
	Wardrobe.Debug("Wardrobe.IconFrame_OnDragStop()");
	if (Wardrobe.BeingDragged) then
		Wardrobe_IconFrame:StopMovingOrSizing()
		Wardrobe.BeingDragged = false;
		local x,y = Wardrobe_IconFrame:GetCenter();
		local px,py = Wardrobe_IconFrame:GetParent():GetCenter();
		local ox = x-px;
		local oy = y-py;
		WardrobeAce.db.char.xOffset = ox;
		WardrobeAce.db.char.yOffset = oy;
	end
end

---------------------------------------------------------------------------------
-- Set the DropDownMenu Scale
---------------------------------------------------------------------------------
function Wardrobe.SetDropDownScale(scale, fromKhaos)
	scale = tonumber(scale);
	if (not scale) then
		scale = 1;
	end
	if (scale > 1 or scale < .5) then
		Wardrobe.ShowHelp();
		return;
	end
	WardrobeAce.db.char.dropDownScale = scale;
	DropDownList1:SetScale(scale);
	DropDownList2:SetScale(scale);
	DropDownList1:SetClampedToScreen(1)
	DropDownList2:SetClampedToScreen(1)
	if (Khaos and not fromKhaos) then
		Khaos.setSetKeyParameter("Wardrobe", "LockButton", "checked", true);
		Khaos.setSetKeyParameter("Wardrobe", "DropDownScale", "slider", WardrobeAce.db.char.dropDownScale);
	end
end

-----------------------------------------------------------------------------------
-- Toggle the addon on and off
-----------------------------------------------------------------------------------
function Wardrobe.Toggle(toggle, fromKhaos)
	if (toggle == 1) then
		if (not fromKhaos) then
			Wardrobe.Print(TEXT("TXT_ENABLED"));
		end
		Wardrobe_Config.Enabled = true;
		Wardrobe_CheckboxToggle:Show();
		if (PAPERDOLL_SIDEBARS[3] ~= nil) then
			Wardrobe.OldPaperDollSideBar = PAPERDOLL_SIDEBARS[3];
		end
		_G["PaperDollSidebarTab3"]:Hide();
--		PAPERDOLL_SIDEBARS[3] = nil;
--		PaperDollFrame_UpdateSidebarTabs();
--		GearManagerToggleButton:Hide();
	else
		if (not fromKhaos) then
			Wardrobe.Print(TEXT("TXT_DISABLED"));
		end
		Wardrobe_Config.Enabled = false;
		Wardrobe_CheckboxToggle:Hide();
		_G["PaperDollSidebarTab3"]:Show();
--		PAPERDOLL_SIDEBARS[3] = Wardrobe.OldPaperDollSideBar;	
--		GearManagerToggleButton:Show();
	end

	--disable fubar if it's available
--[[
	if(FuBar2DB) then
		if(toggle == 0) then
			WardrobeAce:OnDisableFuBarPlugin()
		elseif(WardrobeAce.db.profile.fubar.enabled) then
			WardrobeAce:OnEnableFuBarPlugin()
		end
	end
]]--
	
	--update the minimap button
	Wardrobe.ButtonUpdateVisibility();
end

---------------------------------------------------------------------------------
-- Toggle whether the wardrobes are shown in tooltips
---------------------------------------------------------------------------------
function Wardrobe.ToggleTooltips(toggle, fromUI)
	if(WardrobeAce.db.char.tooltips == toggle) then
		return;
	end

	WardrobeAce.db.char.tooltips = toggle;

	if (not fromUI) then
		if(WardrobeAce.db.char.tooltips) then
			Wardrobe.Print(TEXT("TXT_TOOLTIPS_ENABLED"));
		else
			Wardrobe.Print(TEXT("TXT_TOOLTIPS_DISABLED"));
		end
	end

	-- Hook item tooltips
	if(WardrobeAce.db.char.tooltips) then
		TipHooker:Hook(Wardrobe.ProcessTooltip, "item");
	else
		TipHooker:Unhook(Wardrobe.ProcessTooltip, "item");
	end
end

---------------------------------------------------------------------------------
-- Process text to show in item tooltip
---------------------------------------------------------------------------------
function Wardrobe.ProcessTooltip(tooltip, name, link)
	if (Wardrobe_Config.Enabled and WardrobeAce.db.char.tooltips) then
		local outfitsArray = nil;
		local outfits = nil;

		if((Wardrobe.LastCheckedTooltipItem.link) and Wardrobe.LastCheckedTooltipItem.link == link) then
			outfits = Wardrobe.LastCheckedTooltipItem.outfits;
		elseif((Wardrobe.LastCheckedTooltipItem.link2) and Wardrobe.LastCheckedTooltipItem.link2 == link) then
			outfits = Wardrobe.LastCheckedTooltipItem.outfits2;
		elseif((Wardrobe.LastCheckedTooltipItem.link3) and Wardrobe.LastCheckedTooltipItem.link3 == link) then
			outfits = Wardrobe.LastCheckedTooltipItem.outfits3;
		else
--[[		
			Wardrobe.Debug("Wardrobe.ProcessTooltip: link=",link,"Wardrobe.LastCheckedTooltipItem.link=",Wardrobe.LastCheckedTooltipItem.link);
			if(Wardrobe.DEBUG_MODE) then
				local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(link);
				Wardrobe.Debug("Wardrobe.ProcessTooltip: itemInfo:", "itemName=",itemName, "itemLink=",itemLink, "itemRarity=",itemRarity, "itemLevel=",itemLevel,
						       "itemMinLevel=",itemMinLevel);
				Wardrobe.Debug("Wardrobe.ProcessTooltip: itemInfo:", "itemName=",itemName, "itemLink=",itemLink, "itemType=",itemType, "itemSubType=",itemSubType, "itemStackCount=",itemStackCount, "itemEquipLoc=",itemEquipLoc,
						       "itemTexture=",itemTexture);
			end
]]--
			local itemInfo = WearMe.GetItemInfoFromLink(link);
			-- only if equipable
			if(itemInfo.itemEquipLoc ~= "" and itemInfo.itemEquipLoc ~= "INVTYPE_BAG" and itemInfo.itemEquipLoc ~= "INVTYPE_AMMO") then
				outfitsArray = Wardrobe.GetOutfitsWithItem(itemInfo.itemString);

				if(outfitsArray and (#(outfitsArray) > 0)) then
					local curLineLen = 13;
					for i = 1, #(outfitsArray) do
						if(outfits) then

							if((curLineLen + string.len(outfitsArray[i])) > 43 and curLineLen > 1) then
								outfits = outfits.."\n  "..outfitsArray[i];
								curLineLen = string.len(outfitsArray[i]) + 2;
							else
								outfits = outfits..", "..outfitsArray[i];
								curLineLen = curLineLen + string.len(outfitsArray[i]) + 2;
							end

						else
							outfits = outfitsArray[i];
							curLineLen = curLineLen + string.len(outfitsArray[i]);
						end
					end
				end

			end
			--save last 3 tooltips checked in case we are using item compare addons
			Wardrobe.LastCheckedTooltipItem.link3 = Wardrobe.LastCheckedTooltipItem.link2;
			Wardrobe.LastCheckedTooltipItem.link2 = Wardrobe.LastCheckedTooltipItem.link;
			Wardrobe.LastCheckedTooltipItem.link = link;
			Wardrobe.LastCheckedTooltipItem.outfits3 = Wardrobe.LastCheckedTooltipItem.outfits2;
			Wardrobe.LastCheckedTooltipItem.outfits2 = Wardrobe.LastCheckedTooltipItem.outfits;
			Wardrobe.LastCheckedTooltipItem.outfits = outfits;
		end
		if(not outfits) then
			return;
		end
		tooltip:AddLine(" ");
		tooltip:AddLine("|cffffffffWardrobe-AL: |r|cff20ff20 "..outfits.."|r")
		tooltip:Show();

	end
end

---------------------------------------------------------------------------------
-- Toggle whether the wardrobe button can be moved or not
---------------------------------------------------------------------------------
function Wardrobe.ToggleLockButton(toggle, fromKhaos)
	WardrobeAce.db.char.dragLock = toggle;
	if (not fromKhaos) then
		if (WardrobeAce.db.char.dragLock) then
			Wardrobe.Print(TEXT("TXT_BUTTONLOCKED"));
		else
			Wardrobe.Print(TEXT("TXT_BUTTONUNLOCKED"));
		end
		if (Khaos) then
			Khaos.setSetKeyParameter("Wardrobe", "LockButton", "checked", WardrobeAce.db.char.dragLock);
		end
	end
end

---------------------------------------------------------------------------------
-- Toggle whether the wardrobe menu requires a click of the button to show
---------------------------------------------------------------------------------
function Wardrobe.ToggleClickButton(toggle, fromKhaos)
	WardrobeAce.db.char.mustClickUIButton = toggle;
	if (not fromKhaos) then
		if (WardrobeAce.db.char.mustClickUIButton) then
			Wardrobe.Print(TEXT("TXT_BUTTONONCLICK"));
		else
			Wardrobe.Print(TEXT("TXT_BUTTONONMOUSEOVER"));
		end
		if (Khaos) then
			Khaos.setSetKeyParameter("Wardrobe", "RequireClick", "checked", WardrobeAce.db.char.mustClickUIButton);
		end
	end
end

-----------------------------------------------------------------------------------
-- Toggle whether to allow special outfit auto swapping
-----------------------------------------------------------------------------------
function Wardrobe.ToggleAutoSwaps(toggle, fromKhaos)
	if (toggle == 1 or toggle == "1" or toggle == true) or (toggle == nil and not WardrobeAce.db.char.AutoSwap) then
		if (not fromKhaos) then
			Wardrobe.Print(TEXT("TXT_AUTO_ENABLED"));
		end
		WardrobeAce.db.char.AutoSwap = true;
	else
		if (not fromKhaos) then
			Wardrobe.Print(TEXT("TXT_AUTO_DISABLED"));
		end
		WardrobeAce.db.char.AutoSwap = false;
	end
	if (Khaos and not fromKhaos) then
		Khaos.setSetKeyParameter("Wardrobe", "AutoSwap", "checked", WardrobeAce.db.char.AutoSwap);
	end
end


---------------------------------------------------------------------------------
-- Register the wardrobe button
---------------------------------------------------------------------------------
function Wardrobe.IconFrame_OnLoad()
	Wardrobe_IconFrame:RegisterForDrag("LeftButton");
	Wardrobe_IconFrame:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	if (MobileMinimapButtons_AddButton) then
		MobileMinimapButtons_AddButton("Wardrobe_IconFrame", TEXT("TXT_WARDROBEBUTTON"));
	end
end


---------------------------------------------------------------------------------
-- Update function for showing/hiding the wardrobe button
---------------------------------------------------------------------------------

function Wardrobe.ButtonUpdateVisibility()
	if WardrobeAce.db.char.showMiniMapIcon then   --and Wardrobe_Config.Enabled then
		Wardrobe.Debug("Wardrobe: Showing Wardrobe Icon");
    	Wardrobe_IconFrame:Show();
    else
		Wardrobe.Debug("Wardrobe: Hiding Wardrobe Icon");
        Wardrobe_IconFrame:Hide();
    end
end


---------------------------------------------------------------------------------
-- When the user clicks on the UI button (currently disabled)
---------------------------------------------------------------------------------
function Wardrobe.IconFrame_OnClick(this, button)
	if (button == "RightButton") then
		Wardrobe.Debug("WardrobeAce.db.char.miniMapRightClickOpens",WardrobeAce.db.char.miniMapRightClickOpens);

		Wardrobe.RightClickOpenFunction[WardrobeAce.db.char.miniMapRightClickOpens].func()

--		Wardrobe.ToggleMainMenu();
	elseif (WardrobeAce.db.char.mustClickUIButton == true) then
		Wardrobe.ShowUIMenu(Wardrobe_IconFrame);
	end
end


---------------------------------------------------------------------------------
-- When the user mouses over the UI button
---------------------------------------------------------------------------------
function Wardrobe.IconFrame_OnEnter()
	if (not WardrobeAce.db.char.mustClickUIButton == true) then
		Wardrobe.ShowUIMenu(Wardrobe_IconFrame);
	end
end


---------------------------------------------------------------------------------
-- When the user mouses off the UI button
---------------------------------------------------------------------------------
function Wardrobe.IconFrame_OnLeave()
	GameTooltip:Hide();
end


---------------------------------------------------------------------------------
-- Show the UI menu
---------------------------------------------------------------------------------
local dropDownBg = {
			bgFile = "Interface\\PaperDollInfoFrame\\UI-GearManager-Title-Background",
--			edgeFile = "Interface\\PaperDollInfoFrame\\UI-GearManager-Border",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
			tile = false,
			TileSize = 32,
			EdgeSize = 32,
			insets = {left=11, right=12, top=12, bottom=11},
}

local origDropDownBg = {
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
--			edgeFile = "Interface\\PaperDollInfoFrame\\UI-GearManager-Border",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
			tile = false,
			TileSize = 32,
			EdgeSize = 32,
			insets = {left=11, right=12, top=12, bottom=11},
}

function Wardrobe.ToggleDropDownMenu(level, ...)
	if not level then
		level = 1
	end
	local listFrame = getglobal("DropDownList"..level);
	if listFrame then
		local numButtons = listFrame.numButtons;
		if(numButtons > 0) then
--[[
			Wardrobe.Debug("Frame; name=",listFrame:GetName(),"alpha=",listFrame:GetAlpha(),"depth=",listFrame:GetDepth(),"NumRegions=",listFrame:GetNumRegions());

			local regions = { listFrame:GetRegions() };
			for _, region in ipairs(regions) do

				Wardrobe.Debug("Region; name=",region:GetName(),"alpha=",region:GetAlpha(),"depth=",region:GetDepth(),"NumRegions=",region:GetNumRegions());

			end
			local kids = { listFrame:GetChildren() };
			for _, child in ipairs(kids) do

				local highlightTexture = nil;
				if(child:GetObjectType() == "Button") then highlightTexture = child:GetNormalTexture(); end;

				Wardrobe.Debug("Child; type=",child:GetObjectType(),"name=",child:GetName(),"alpha=",child:GetAlpha(),"depth=",child:GetDepth(),"NumRegions=",child:GetNumRegions(),"highlightTexture=",highlightTexture);

				local regions = { child:GetRegions() };
				for _, region in ipairs(regions) do

					Wardrobe.Debug("childRegion; name=",region:GetName(),"alpha=",region:GetAlpha(),"drawLayer=",region:GetDrawLayer());

				end

			end
]]--


			--only do this if it's for my own dropdown menus.
			local button1 = getglobal("DropDownList"..level.."Button1");
			local listBg = getglobal("DropDownList1Backdrop");
			if(button1 and button1:GetText() == UnitName("player").."'s "..TEXT("TEXT_MENU_TITLE")) then
				local listBg = getglobal("DropDownList1Backdrop");
				listBg:SetBackdrop(dropDownBg);
				listBg:SetAlpha(WardrobeAce.db.char.opacity);
				listFrame:SetAlpha(WardrobeAce.db.char.opacity);
				listFrame:SetScale(WardrobeAce.db.char.dropDownScale);
				for i=1, numButtons do
					local button = getglobal("DropDownList"..level.."Button"..i);
					if(button) then
						local hightLightRegion = getglobal("DropDownList"..level.."Button"..i.."Highlight");
						hightLightRegion:SetDrawLayer("HIGHLIGHT");  --fix for problem with highlighting.
						button:SetAlpha(1);
					end;
				end
			else
				local listBg = getglobal("DropDownList1Backdrop");
				listBg:SetBackdrop(origDropDownBg);
				listFrame:SetAlpha(1);
				if(listBg) then listBg:SetAlpha(1); end;
				for i=1, UIDROPDOWNMENU_MAXBUTTONS do
					local button = getglobal("DropDownList"..level.."Button"..i);
					if(button) then
						local hightLightRegion = getglobal("DropDownList"..level.."Button"..i.."Highlight");
						hightLightRegion:SetDrawLayer("HIGHLIGHT");
						button:SetAlpha(1);
					end;
				end
			end
		else
			listFrame:SetAlpha(1);
		end
	end
end

hooksecurefunc("ToggleDropDownMenu", Wardrobe.ToggleDropDownMenu)


function Wardrobe.ShowUIMenu(this)
	ToggleDropDownMenu(1, nil, WardrobeEquipDropDown, this:GetName(), 0, 0, "TOPRIGHT");
--	local listBg = getglobal("DropDownList1Backdrop");
--	listBg:SetBackdrop(dropDownBg)
--	local listFrame = getglobal("DropDownList1");
--	listFrame:SetAlpha(WardrobeAce.db.char.opacity);
--	listFrame:SetScale(WardrobeAce.db.char.dropDownScale);
end

function Wardrobe.ShowUpdateMenu(this)
	ToggleDropDownMenu(1, nil, WardrobeUpdateDropDown, this:GetName(), 70, 25);
--	local listBg = getglobal("DropDownList1Backdrop");
--	listBg:SetBackdrop(dropDownBg);
--	local highlight = getglobal("DropDownList1Button");
--	highlight:SetHighlightTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight","ADD");
--	local listFrame = getglobal("DropDownList1");
--	listFrame:SetAlpha(WardrobeAce.db.char.opacity);
--	listFrame:SetScale(WardrobeAce.db.char.dropDownScale);
end

function Wardrobe.DropDown_OnLoad()
	-- Fake menu frame.... who says you need a frame, bah!
	WardrobeEquipDropDown = {
		initialize = Wardrobe.LoadEquipDropDownMenu;
		GetName = function() return "WardrobeEquipDropDown" end;
		SetHeight = function() end;
	}

	WardrobeUpdateDropDown = {
		initialize = Wardrobe.LoadUpdateDropDownMenu;
		GetName = function() return "WardrobeUpdateDropDown" end;
		SetHeight = function() end;
	}

	-- Hook item tooltips
	if(WardrobeAce.db.char.tooltips) then
			TipHooker:Hook(Wardrobe.ProcessTooltip, "item");
	end

end

function Wardrobe.UpdateButtonTexture()

--	local listFrame = getglobal("DropDownList1");
--	local numButtons = listFrame.numButtons;

--	local button = getglobal("DropDownList1Button"..numButtons);

--	Wardrobe.Print(button:GetName());

--	button:SetHighlightTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight");

end

function Wardrobe.LoadEquipDropDownMenu(frame, level, menuList)

	local outfitList = Wardrobe.GetListOfOutfits();

	--Title
	local info = UIDropDownMenu_CreateInfo();
	info.text = UnitName("player").."'s "..TEXT("TEXT_MENU_TITLE");
	info.owner = getglobal("PaperDollFrame");
	info.notClickable = 1;
	info.isTitle = 1;
	info.notCheckable = true;
	info.fontObject = GameFontHighlight;
	UIDropDownMenu_AddButton(info);
	Wardrobe.UpdateButtonTexture();

	for i, outfitData in pairs(outfitList) do
		info = UIDropDownMenu_CreateInfo();
		info.text = outfitData.OutfitName;
		if (outfitData.Icon ~= "Interface\\Icons\\INV_Misc_QuestionMark") then
			info.icon = outfitData.Icon;
		end
		info.arg1 = i;
		info.owner = getglobal("PaperDollFrame");
		info.notCheckable = true;
		info.justifyH = "CENTER";
		info.fontObject = GameFontHighlight;
		info.func = Wardrobe.WearOutfitCallback;

		Wardrobe.Debug("Adding",outfitData.OutfitName,"with arg1",i,"to drop down list, icon=",outfitData.Icon);

		UIDropDownMenu_AddButton(info);
		Wardrobe.UpdateButtonTexture();
	end

	--Add equipment manager link to menu
	info = UIDropDownMenu_CreateInfo();
	info.text = "|cffe6cc80 [EquipMgr]";
	info.icon = "Interface\\PaperDollInfoFrame\\UI-GearManager-Button";
	info.tooltip = "Open in-game Equipment Manager";
	info.notCheckable = true;
	info.fontObject = GameFontHighlight;
	info.justifyH = "CENTER";
	info.func = Wardrobe.OpenGameGearManager;
	UIDropDownMenu_AddButton(info);

	info = UIDropDownMenu_CreateInfo();
	info.text = TEXT("TEXT_MENU_OPEN");
	info.notCheckable = true;
	info.justifyH = "CENTER";
	info.fontObject = GameFontHighlight;
	info.func = Wardrobe.ShowMainMenu;
	info.owner = getglobal("PaperDollFrame");
	UIDropDownMenu_AddButton(info);
	Wardrobe.UpdateButtonTexture();

end

function Wardrobe.LoadUpdateDropDownMenu()

	local outfitList = Wardrobe.GetListOfOutfits();  --frame, level, menuList);
	local outfits = Wardrobe.CurrentConfig.Outfit;

	--Title
	local info = UIDropDownMenu_CreateInfo();
	info.text = UnitName("player").."'s "..TEXT("TEXT_MENU_TITLE");
	info.owner = UIParent;
	info.notClickable = 1;
	info.isTitle = 1;
	info.notCheckable = true;
	info.fontObject = GameFontHighlight;
	UIDropDownMenu_AddButton(info);
	Wardrobe.UpdateButtonTexture();

	for i, outfitData in ipairs(outfitList) do
		info = UIDropDownMenu_CreateInfo();
		info.text = outfitData.OutfitName;
		if (outfitData.Icon ~= "Interface\\Icons\\INV_Misc_QuestionMark") then
			info.icon = outfitData.Icon;
		end
		info.arg1 = i;
		info.notCheckable = true;
		info.justifyH = "CENTER";
		local outfitName = outfits[i].OutfitName
		info.func = function()
			--Quick update (Set the current items to an existing outfit)
			Wardrobe.NewWardrobeName = outfitName;
			Wardrobe.PopupFunction = "[Update]";
			Wardrobe.ShowWardrobe_ConfigurationScreen();
		end;
		info.fontObject = GameFontHighlight;
		UIDropDownMenu_AddButton(info);
		Wardrobe.UpdateButtonTexture();
	end

	--Add equipment manager link to menu
	info = UIDropDownMenu_CreateInfo();
	info.text = "|cffe6cc80 EquipMgr";
	info.icon = "Interface\\PaperDollInfoFrame\\UI-GearManager-Button";
	info.tooltip = "Open in-game Equipment Manager";
	info.notCheckable = true;
	info.fontObject = GameFontHighlight;
	info.justifyH = "CENTER";
	info.func = Wardrobe.OpenGameGearManager;
	UIDropDownMenu_AddButton(info);

	info = UIDropDownMenu_CreateInfo();
	info.text = TEXT("TXT_NEW");
	info.notCheckable = true;
	info.fontObject = GameFontHighlight;
	info.justifyH = "CENTER";
	info.func = Wardrobe.NewOutfitButtonClick;
	UIDropDownMenu_AddButton(info);
	Wardrobe.UpdateButtonTexture();
end


---------------------------------------------------------------------------------
-- Handle keybinding clicks
---------------------------------------------------------------------------------
function Wardrobe.Keybinding(outfitNum)
	if (outfitNum <= #(Wardrobe.CurrentConfig.Outfit)) then
		Wardrobe.WearOutfit(Wardrobe.CurrentConfig.Outfit[outfitNum].OutfitName);
	end
end


--===============================================================================
--
-- Confirmation windows
--
--===============================================================================

---------------------------------------------------------------------------------
-- Confirm a popup menu
---------------------------------------------------------------------------------
function Wardrobe.PopupConfirm_OnClick()

	Wardrobe.Debug("Wardrobe.PopupConfirm_OnClick() Wardrobe_NamePopupEditBox:GetText()=",Wardrobe_NamePopupEditBox:GetText());
	Wardrobe_NamePopup:Hide();
	Wardrobe_PopupConfirm:Hide();

	if (Wardrobe.PopupFunction == "[Add]") then
		Wardrobe.NewWardrobeName = Wardrobe_NamePopupEditBox:GetText();
		Wardrobe.ShowWardrobe_ConfigurationScreen();
	elseif (Wardrobe.PopupFunction == "[Delete]" or Wardrobe.PopupFunction == "DeleteFromSort") then
		Wardrobe.EraseOutfit(Wardrobe_NamePopupEditBox:GetText());
		if (Wardrobe.PopupFunction == "DeleteFromSort") then
			Wardrobe.PopulateMainMenu();
			Wardrobe.ToggleMainMenuFrameVisibility(true);
		end
		Wardrobe.PopupFunction = "";
	elseif (Wardrobe.PopupFunction == "[Edit]") then
		Wardrobe.NewWardrobeName = Wardrobe_NamePopupEditBox:GetText();
		Wardrobe.RenameOutfit(Wardrobe.Rename_OldName, Wardrobe.NewWardrobeName);
		Wardrobe.StoreVirtualOutfit(WARDROBE_TEMP_OUTFIT_NAME, Wardrobe.NewWardrobeName);
		Wardrobe.WearOutfit(Wardrobe.NewWardrobeName, true);
		Wardrobe.PopupFunction = "[Update]";
		Wardrobe.ShowWardrobe_ConfigurationScreen();
	elseif (Wardrobe.PopupFunction == "[Update]") then
		Wardrobe.NewWardrobeName = Wardrobe_NamePopupEditBox:GetText();
		Wardrobe.ShowWardrobe_ConfigurationScreen();
	elseif (Wardrobe.PopupFunction == "[Mounted]") then
		if (not Wardrobe.FoundOutfitName(Wardrobe_NamePopupEditBox:GetText()) or Wardrobe_NamePopupEditBox:GetText() == "") then
			Wardrobe.Print(TEXT("TXT_MOUNTEDNOTEXIST"));
			UIErrorsFrame:AddMessage(TEXT("TXT_NOTEXISTERROR"), 0.0, 1.0, 0.0, 1.0, UIERRORS_HOLD_TIME);
			Wardrobe.PopupFunction = "";
		else
			Wardrobe.SetMountedOutfit(Wardrobe_NamePopupEditBox:GetText());
			Wardrobe.PopupFunction = "";
		end
	elseif (Wardrobe.PopupFunction == "EraseAllOutfits") then
		Wardrobe.EraseAllOutfits()
	end

	Wardrobe.UpdatePanel()

end


---------------------------------------------------------------------------------
-- Cancel a popup menu
---------------------------------------------------------------------------------
function Wardrobe.PopupCancel_OnClick()
	Wardrobe_NamePopup:Hide();
	Wardrobe_PopupConfirm:Hide();
	if (Wardrobe.PopupFunction == "DeleteFromSort") then
		Wardrobe.ToggleMainMenuFrameVisibility(true);
	end
end



--===============================================================================
--
-- Paperdoll configuration windows
--
--===============================================================================

---------------------------------------------------------------------------------
-- Update the display helm/cloak checkboxes to the right image if clicked
---------------------------------------------------------------------------------
function Wardrobe.CharacterHeadSlotShowingWardrobeCheckBox_OnClick(self)
--	if(Wardrobe.LastHelmDisplayPreCycle == nil) then
--		Wardrobe.LastHelmDisplayPreCycle = (ShowingHelm() == 1);
--	end
	if(self:GetChecked()) then
		Wardrobe.LastHelmDisplayTexture = Wardrobe.DISPLAYON_TEXTURE;
		self:SetCheckedTexture(Wardrobe.DISPLAYON_TEXTURE);
		ShowHelm(true);
	else
		if(Wardrobe.LastHelmDisplayTexture == Wardrobe.DISPLAYON_TEXTURE) then
			Wardrobe.LastHelmDisplayTexture = Wardrobe.DISPLAYOFF_TEXTURE;
			self:SetCheckedTexture(Wardrobe.DISPLAYOFF_TEXTURE);
			self:SetChecked(true);
			ShowHelm(false);
		elseif(Wardrobe.LastHelmDisplayTexture == Wardrobe.DISPLAYOFF_TEXTURE) then
--			ShowHelm(Wardrobe.LastHelmDisplayPreCycle);
			ShowHelm(WardrobeAce.db.char.defaultHelmState == 1);
			Wardrobe.LastHelmDisplayTexture = nil;
		end
	end
end
function Wardrobe.CharacterBackSlotShowingWardrobeCheckBox_OnClick(self)
--	if(Wardrobe.LastCloakDisplayPreCycle == nil) then
--		Wardrobe.LastCloakDisplayPreCycle = (ShowingCloak() == 1);
--	end
	if(self:GetChecked()) then
		Wardrobe.LastCloakDisplayTexture = Wardrobe.DISPLAYON_TEXTURE;
		self:SetCheckedTexture(Wardrobe.DISPLAYON_TEXTURE);
		ShowCloak(true);
	else
		if(Wardrobe.LastCloakDisplayTexture == Wardrobe.DISPLAYON_TEXTURE) then
			Wardrobe.LastCloakDisplayTexture = Wardrobe.DISPLAYOFF_TEXTURE;
			self:SetCheckedTexture(Wardrobe.DISPLAYOFF_TEXTURE);
			self:SetChecked(true);
			ShowCloak(false);
		elseif(Wardrobe.LastCloakDisplayTexture == Wardrobe.DISPLAYOFF_TEXTURE) then
--			ShowCloak(Wardrobe.LastCloakDisplayPreCycle);
			ShowCloak(WardrobeAce.db.char.defaultCloakState == 1);
			Wardrobe.LastCloakDisplayTexture = nil;
		end
	end
end


---------------------------------------------------------------------------------
-- Show the screen that lets the user confirm his/her wardrobe selection (check off items, etc)
---------------------------------------------------------------------------------
function Wardrobe.ShowWardrobe_ConfigurationScreen()

	Wardrobe.CheckboxToggleState = WardrobeAce.db.char.defaultCheckboxState;
	Wardrobe.CurrentOutfitButtonColor = WARDROBE_DEFAULT_BUTTON_COLOR;

	Wardrobe_CheckboxToggle:SetText(TEXT("TXT_TOGGLE"));

	for i, slotName in pairs(Wardrobe.InventorySlots) do
		getglobal("Character"..slotName.."WardrobeCheckBox"):SetCheckedTexture("Interface\\AddOns\\Wardrobe\\Images\\Check");
		--getglobal("Character"..Wardrobe.InventorySlots[i].."WardrobeCheckBox"):SetDisabledCheckedTexture("Interface\\AddOns\\Wardrobe\\Images\\X");
	end

	for i, slot in pairs(Wardrobe.DisplayToggleableInventorySlots) do
		getglobal("Character"..slot.name.."ShowingWardrobeCheckBox"):SetChecked(false);
	end

	if (Wardrobe.PopupFunction == "[Add]") then
		if (WardrobeAce.db.char.defaultCheckboxState ~= 1 or WardrobeAce.db.char.defaultCheckboxState ~= 0) then
			WardrobeAce.db.char.defaultCheckboxState = 1;
--			Wardrobe.Print(TEXT("TXT_WARDROBENAME")..tostring(WardrobeAce.db.char.defaultCheckboxState));
		end
		for i, slotName in pairs(Wardrobe.InventorySlots) do
			getglobal("Character"..slotName.."WardrobeCheckBox"):SetChecked(WardrobeAce.db.char.defaultCheckboxState);

--default display check state is to ignore it... (unchecked)
			local displayAction = Wardrobe.DisplayToggleableInventorySlots[Wardrobe.InventorySlotIDs[i]];
			if(displayAction ~= nil) then
--				Wardrobe.Debug("Wardrobe: displayAction.name=",displayAction.name,"slotName=",slotName);
				getglobal("Character"..slotName.."ShowingWardrobeCheckBox"):SetChecked(false);
			end
		end

	elseif (Wardrobe.PopupFunction == "[Update]") then

		-- for each outfit
		for i, outfit in ipairs(Wardrobe.CurrentConfig.Outfit) do

			-- if it's the wardrobe we're updating
			if (outfit.OutfitName == Wardrobe.NewWardrobeName) then

				Wardrobe.CurrentOutfitButtonColor = outfit.ButtonColor;

				-- for each item in the outfit, set the checkbox
				for j=1, Wardrobe.InventorySlotsSize do
					local IsSlotUsed;
					if (not outfit.Item[j]) or (outfit.Item[j].IsSlotUsed ~= 1) then
						IsSlotUsed = 0;
					else
						IsSlotUsed = 1;
					end

					local IsSlotDisplaying = nil;
					if(Wardrobe.DisplayToggleableInventorySlots[Wardrobe.InventorySlotIDs[j]] ~= nil) then --if this is a displayable slot
						if (not outfit.Item[j]) then  --if this item is not selected, don't bother with it.
							IsSlotDisplaying = nil;
						elseif (outfit.Item[j].Display == nil) then  --if it's nil, set it to be ignored
							IsSlotDisplaying = nil;
							--IsSlotDisplaying = WardrobeAce.db.char.defaultDisplayState;
							--outfit.Item[j].Display = WardrobeAce.db.char.defaultDisplayState;
						elseif (outfit.Item[j].Display ~= 1) then
							IsSlotDisplaying = 0;
						else
							IsSlotDisplaying = 1;
						end
					end

					if (not outfit.Item[j]) then
						Wardrobe.Debug("Item "..j.." is not defined");
					elseif (outfit.Item[j].Display == nil) then
						Wardrobe.Debug("Item "..j.." display set to nil");
					else
						Wardrobe.Debug("Item "..j.." display set to "..outfit.Item[j].Display);
					end

					local checkBoxName = "Character"..Wardrobe.InventorySlots[j].."WardrobeCheckBox";
					getglobal(checkBoxName):SetChecked(IsSlotUsed);

					if (IsSlotDisplaying ~= nil) then
						checkBoxName = "Character"..Wardrobe.InventorySlots[j].."ShowingWardrobeCheckBox";
						--Wardrobe.Debug(IsSlotDisplaying.." "..checkBoxName);
						if(IsSlotDisplaying == 0) then
							getglobal(checkBoxName):SetCheckedTexture(Wardrobe.DISPLAYOFF_TEXTURE);
						else
							getglobal(checkBoxName):SetCheckedTexture(Wardrobe.DISPLAYON_TEXTURE);
						end
						getglobal(checkBoxName):SetChecked(true);
					end
				end
				break;
			end
		end
	end

	-- show the character paperdoll frame
	Wardrobe.ToggleCharacterPanel();

end

---------------------------------------------------------------------------------
-- Toggle the visibility of the gear manager panel
---------------------------------------------------------------------------------
function Wardrobe.OpenGameGearManager()

	if(not PaperDollFrame:IsVisible()) then
		ToggleCharacter("PaperDollFrame");
	end
	
--	SetCVar("characterFrameCollapsed", "0");	
 	CharacterFrame_Expand();
-- 	PaperDollEquipmentManagerPane.queuedUpdate = true;
	_G["PaperDollSidebarTab3"]:Show();
	PaperDollEquipmentManagerPane_Update(nil);
	PaperDollFrame_SetSidebar(PaperDollFrame, 3);

--	PaperDollEquipmentManagerPane_OnShow(PaperDollFrame);
	
--[[	
	if(Wardrobe.selectedOutfit and Wardrobe.selectedOutfit > 0) then 
		if (Wardrobe.CurrentConfig.Outfit[selectedOutfit] ~= nil and Wardrobe.CurrentConfig.Outfit[selectedOutfit].OutfitName.OutfitName ~= nil) then
			PaperDollEquipmentManagerPane.selectedSetName = Wardrobe.CurrentConfig.Outfit[selectedOutfit].OutfitName
		end
	end
]]--	
	Wardrobe_CheckboxToggle:Hide();	
end

function Wardrobe.UpdateEquipmentManagerToggleButton()
	--GearManagerToggleButton:Hide();
--	if (PAPERDOLL_SIDEBARS[3] ~= nil) then
--		Wardrobe.OldPaperDollSideBar = PAPERDOLL_SIDEBARS[3];
--	end
--	PAPERDOLL_SIDEBARS[3] = nil;
--	PaperDollFrame_UpdateSidebarTabs();
	if(Wardrobe_Config.Enabled) then
		Wardrobe_CheckboxToggle:Show();
		_G["PaperDollSidebarTab3"]:Hide();
	else
		Wardrobe_CheckboxToggle:Hide();
		_G["PaperDollSidebarTab3"]:Show();
	end
end

function Wardrobe.MyPaperDollFrame_OnShow (self)
	if (Wardrobe_Config.Enabled) then
		Wardrobe.Debug("Detected PaperDollFrame_OnShow(self)");
		Wardrobe.UpdateEquipmentManagerToggleButton();
	end
end

function Wardrobe.MyPaperDollFrame_OnHide (self)
	if (Wardrobe_Config.Enabled) then
		Wardrobe.Debug("Detected PaperDollFrame_OnHide(self)");
		local currentDropDownMenu = UIDropDownMenu_GetCurrentDropDown();
		if (WardrobeUpdateDropDown ~= nil and currentDropDownMenu ~= nil and currentDropDownMenu:GetName() ~= nil and currentDropDownMenu:GetName() == "WardrobeUpdateDropDown") then
			HideDropDownMenu(1);
		end
	end
end

---------------------------------------------------------------------------------
-- Toggle the visibility of the character panel
---------------------------------------------------------------------------------
function Wardrobe.ToggleCharacterPanel(dontToggleChar)
	if (not Wardrobe.InToggleCharacterPanel) then
		Wardrobe.InToggleCharacterPanel = true;
		if (Wardrobe.ShowingCharacterPanel == false) then
			if (not dontToggleChar and (not PaperDollFrame:IsVisible())) then
				ToggleCharacter("PaperDollFrame");
			end
			Wardrobe_CheckboxesFrame:Show();
			for i, slot in pairs(Wardrobe.DisplayToggleableInventorySlots) do
				if(WardrobeAce.db.char.showHelmCloakFunctionEnabled) then
					getglobal("Character"..slot.name.."ShowingWardrobeCheckBox"):Show();
				else
					getglobal("Character"..slot.name.."ShowingWardrobeCheckBox"):Hide();
				end
			end
			Wardrobe.CatchCharacterFrameHide = true;
			Wardrobe.RefreshCharacterPanel();
			Wardrobe.ShowingCharacterPanel = true;
		else
			Wardrobe_CheckboxesFrame:Hide();
			CharacterFrameTitleText:SetText(UnitPVPName("player"));
			CharacterFrameTitleText:SetTextColor(1,1,1);
			Wardrobe.ShowingCharacterPanel = false;
			if (not dontToggleChar) then
				ToggleCharacter("PaperDollFrame");
			end
		end

		Wardrobe.InToggleCharacterPanel = false;
	end
end


---------------------------------------------------------------------------------
-- Refresh the character panel
---------------------------------------------------------------------------------
function Wardrobe.RefreshCharacterPanel()
	CharacterFrameTitleText:SetText(Wardrobe.NewWardrobeName);
	CharacterFrameTitleText:SetTextColor(WARDROBE_TEXTCOLORS[Wardrobe.CurrentOutfitButtonColor][1],WARDROBE_TEXTCOLORS[Wardrobe.CurrentOutfitButtonColor][2],WARDROBE_TEXTCOLORS[Wardrobe.CurrentOutfitButtonColor][3]);
end


---------------------------------------------------------------------------------
-- Hook the HideUIPanel function so that we can trap when the user closes the character panel
---------------------------------------------------------------------------------
function Wardrobe.HideUIPanel(frame)

	--Wardrobe.Orig_HideUIPanel(frame);

	if (frame == getglobal("CharacterFrame")) then
		
		if (Wardrobe.CatchCharacterFrameHide) then 
			Wardrobe_CheckboxesFrame:Hide();
			Wardrobe.ToggleCharacterPanel(true);
			Wardrobe_CheckboxToggle:SetText(TEXT("TXT_UPDATE"));
			if (not Wardrobe.PressedAcceptButton) then
				UIErrorsFrame:AddMessage(TEXT("TXT_CHANGECANCELED"), 1.0, 0.0, 0.0, 1.0, UIERRORS_HOLD_TIME);
	
				if(WardrobeAce.db.char.showHelmCloakFunctionEnabled) then
					-- reset helm and cloak display
					ShowHelm(WardrobeAce.db.char.defaultHelmState == 1);
					ShowCloak(WardrobeAce.db.char.defaultCloakState == 1);
				end
	
			end
	
			-- check to see if we should re-equip our previous outfit
			Wardrobe.CheckForEquipVirtualOutfit(WARDROBE_TEMP_OUTFIT_NAME);
			Wardrobe.CatchCharacterFrameHide = false;
		end
	elseif (frame == getglobal("GearManagerDialog")) then
		Wardrobe.UpdateEquipmentManagerToggleButton();
	end

	Wardrobe.PressedAcceptButton = false;
end

hooksecurefunc("HideUIPanel", Wardrobe.HideUIPanel)

---------------------------------------------------------------------------------
-- Handle when the user clicks the button to toggle all the checkboxes
---------------------------------------------------------------------------------
function Wardrobe.ToggleCheckboxes()
	if (Wardrobe_CheckboxToggle:GetText() == TEXT("TXT_UPDATE")) then
		Wardrobe.ShowUpdateMenu(Wardrobe_CheckboxToggle);
	else
		if (Wardrobe.CheckboxToggleState == 1 or Wardrobe.CheckboxToggleState == true) then
			Wardrobe.CheckboxToggleState = false;
		else
			Wardrobe.CheckboxToggleState = true;
		end
		for i, slotName in pairs(Wardrobe.InventorySlots) do
			getglobal("Character"..slotName.."WardrobeCheckBox"):SetChecked(Wardrobe.CheckboxToggleState);
		end
	end
end


---------------------------------------------------------------------------------
-- When the user accepts the wardrobe confirmation screen
---------------------------------------------------------------------------------
function Wardrobe.ConfirmWardrobeConfigurationScreen()

	-- remember which items were checked and unchecked for this outfit
	Wardrobe.ItemCheckState = { };
	Wardrobe.ItemDisplayingState = { };
	for i, slotName in pairs(Wardrobe.InventorySlots) do
		if (getglobal("Character"..slotName.."WardrobeCheckBox"):GetChecked()) then
			Wardrobe.ItemCheckState[i] = 1;
		end

		local itemId = Wardrobe.InventorySlotIDs[i];
		if (Wardrobe.DisplayToggleableInventorySlots[itemId]) then
			local thisSlot = getglobal("Character"..slotName.."ShowingWardrobeCheckBox");
			if (thisSlot:GetChecked()) then
				Wardrobe.Print(thisSlot:GetCheckedTexture():GetTexture());
				if(thisSlot:GetCheckedTexture():GetTexture() == Wardrobe.DISPLAYON_TEXTURE) then
					Wardrobe.ItemDisplayingState[i] = 1;
				else
					Wardrobe.ItemDisplayingState[i] = 0;
				end
			else
				Wardrobe.ItemDisplayingState[i] = nil;
			end
		end
	end

--	if (CharacterMainHandSlotWardrobeCheckBox:GetChecked() == 1) and (CharacterSecondaryHandSlotWardrobeCheckBox:GetChecked() == 1) then
		--Check for 2h in Main slot and dissable offhand
--	end

	if (Wardrobe.PopupFunction == "[Add]") then
		Wardrobe.AddNewOutfit(Wardrobe.NewWardrobeName, Wardrobe.CurrentOutfitButtonColor);
		Wardrobe.PopupFunction = "";
	elseif (Wardrobe.PopupFunction == "[Update]") then
		Wardrobe.UpdateOutfit(Wardrobe.NewWardrobeName, Wardrobe.CurrentOutfitButtonColor);
		Wardrobe.PopupFunction = "";

		-- check to see if we should re-equip our previous outfit
		Wardrobe.CheckForEquipVirtualOutfit(WARDROBE_TEMP_OUTFIT_NAME);
	end

	Wardrobe.PressedAcceptButton = true;
	Wardrobe.ToggleCharacterPanel();
end


---------------------------------------------------------------------------------
-- When the user rejects the wardrobe confirmation screen
---------------------------------------------------------------------------------
function Wardrobe.CancelWardrobe_ConfigurationScreen()
	-- check to see if we should re-equip our previous outfit
	Wardrobe.CheckForEquipVirtualOutfit(WARDROBE_TEMP_OUTFIT_NAME);
end


--===============================================================================
--
-- Main menu
--
--===============================================================================

---------------------------------------------------------------------------------
-- Show the main menu
---------------------------------------------------------------------------------
function Wardrobe.ShowMainMenu()

	Wardrobe.CheckForOurWardrobeID();

	-- clear any selected outfits
	Wardrobe.selectedOutfit = nil;

	Wardrobe.ToggleMainMenuFrameVisibility(true);
	Wardrobe.PopulateMainMenu();
end

function Wardrobe.ToggleMainMenu()
	if (Wardrobe_MainMenuFrame:IsVisible()) then
		Wardrobe_MainMenuFrame:Hide();
	else
		Wardrobe.ShowMainMenu()
	end
end


---------------------------------------------------------------------------------
-- Toggle the main menu visibility and color cycling
---------------------------------------------------------------------------------
function Wardrobe.ToggleMainMenuFrameVisibility(toggle)
	if (toggle) then
		Wardrobe_MainMenuFrame:Show();
	else
		Wardrobe_MainMenuFrame:Hide();
	end
end


---------------------------------------------------------------------------------
-- Populate the main menu
---------------------------------------------------------------------------------
function Wardrobe.PopulateMainMenu()
	Wardrobe.Debug("PopulateMainMenu");

	Wardrobe.CheckForOurWardrobeID();

	local totalExistingEntries, totalEntriesShown;
	local rowCount = 1;
	local entryCount = 1;
	local offset = FauxScrollFrame_GetOffset(Wardrobe_MenuScrollFrame);
	Wardrobe.Debug("offset = "..offset);

	while rowCount <= WARDROBE_MAX_SCROLL_ENTRIES do

--		Wardrobe.Debug("rowCount = "..rowCount);
--		Wardrobe.Debug("entryCount = "..entryCount);
		local frame = getglobal("Wardrobe_MenuEntry"..rowCount);
		local frameText = frame.text;
		local frameIcon = frame.icon;
		local outfitNum = entryCount + offset;
		local outfit = Wardrobe.CurrentConfig.Outfit[outfitNum];
		if (not outfit) then
			frameText:SetText("");
			frameText.r = 0;
			frameText.g = 0;
			frameText.b = 0;
			frameIcon:Hide();
			rowCount = rowCount + 1;

		-- if this isn't a virtual outfit
		elseif (not outfit.Virtual) then
			Wardrobe.Debug("Wasn't Virtual.  Setting text to: "..outfit.OutfitName);
			frameText:SetText(outfit.OutfitName);
			local buttonColor = outfit.ButtonColor;
			frameText.r = WARDROBE_TEXTCOLORS[buttonColor][1];
			frameText.g = WARDROBE_TEXTCOLORS[buttonColor][2];
			frameText.b = WARDROBE_TEXTCOLORS[buttonColor][3];
			frameText:SetTextColor(frameText.r, frameText.g, frameText.b);

			-- check to see if we should show the mounted icon
			if (outfit.Special == "mount") then
				-- set the texture
				frameIcon:SetNormalTexture("Interface\\AddOns\\Wardrobe\\Images\\Paw");
				frameIcon:Show();

			-- check to see if we should show the plaguelands icon
			elseif (outfit.Special == "plague") then
				-- set the texture
				frameIcon:SetNormalTexture("Interface\\AddOns\\Wardrobe\\Images\\Sword");
				frameIcon:Show();

			-- check to see if we should show the while-eating icon
			elseif (outfit.Special == "eat") then
				-- set the texture
				frameIcon:SetNormalTexture("Interface\\AddOns\\Wardrobe\\Images\\Food");
				frameIcon:Show();

			-- check to see if we should show the while-eating icon
			elseif (outfit.Special == "swim") then
				-- set the texture
				frameIcon:SetNormalTexture("Interface\\AddOns\\Wardrobe\\Images\\Shark");
				frameIcon:Show();

			else
				frameIcon:Hide();
			end
			rowCount = rowCount + 1;
		else
			Wardrobe.Debug("Was Virtual");
			frameIcon:Hide();
		end

		--frameText.OutfitNum = outfitNum;
		frame:SetID(outfitNum)

		entryCount = entryCount + 1;
	end

	FauxScrollFrame_Update(Wardrobe_MenuScrollFrame, #(Wardrobe.CurrentConfig.Outfit), WARDROBE_MAX_SCROLL_ENTRIES, WARDROBE_MAX_SCROLL_ENTRIES);
	Wardrobe.UpdateScrollingMenuHighlight();

	return entryCount, rowCount;
end

function Wardrobe.UpdateScrollingMenuHighlight()
	local numEntries = min(#(Wardrobe.CurrentConfig.Outfit), WARDROBE_MAX_SCROLL_ENTRIES)
	if(Wardrobe.selectedOutfit and numEntries and (Wardrobe.selectedOutfit > numEntries)) then
		Wardrobe.selectedOutfit = nil;
	end
	local selectedID = Wardrobe.selectedOutfit;
	local highlightedID = Wardrobe.highlightedSet;
	local frame, id;
	for rowCount=1, numEntries do
		frame = getglobal("Wardrobe_MenuEntry"..rowCount);
		frame:Enable();
		id = frame:GetID();
		if ( id == highlightedID or id == selectedID ) then
			frame:LockHighlight();
		else
			frame:UnlockHighlight();
		end
	end
	for rowCount=numEntries+1, WARDROBE_MAX_SCROLL_ENTRIES do
		getglobal("Wardrobe_MenuEntry"..rowCount):Disable();
	end
end


---------------------------------------------------------------------------------
-- Menu Entry Scripts
---------------------------------------------------------------------------------

function Wardrobe.MenuEntry_OnLoad(this)
	this:RegisterForDrag("LeftButton");
	this.text = getglobal(this:GetName().."Text");
	this.icon = getglobal(this:GetName().."Icon");
end

function Wardrobe.MenuEntry_OnEnter(this)
	if (Wardrobe.isReordering) then
		if (this:IsEnabled() == 1) then
			Wardrobe.UpdateMenuSeparator(this);
		end
	else
		if (this:IsEnabled() == 1) then
			Wardrobe.highlightedSet = this:GetID();
		else
			Wardrobe.highlightedSet = nil;
		end
		Wardrobe.UpdateScrollingMenuHighlight();
	end
end

function Wardrobe.MenuEntry_OnLeave()
	if (not Wardrobe.isReordering) then
		Wardrobe.highlightedSet = nil;
		Wardrobe.UpdateScrollingMenuHighlight();
	end
end

function Wardrobe.MenuEntry_OnMouseDown(this)
	if (not Wardrobe.isReordering) then
		local x, y = GetCursorPosition();
		--[[
		local scale = UIParent:GetScale();
		this.xOffset = x/scale - this:GetLeft();
		this.yOffset = y/scale - this:GetBottom();
		]]--
		this.xOffset = x - this:GetLeft();
		this.yOffset = y - this:GetBottom();
	end
end

function Wardrobe.MenuEntry_OnDragStart(this)
	if (not Wardrobe.isReordering) then
		Wardrobe.UpdateDraggableMenuEntry(this);
	end
end

function Wardrobe.MenuEntry_OnClick(button)
	Wardrobe.selectedOutfit = button:GetID();
	Wardrobe.UpdateScrollingMenuHighlight();
end


---------------------------------------------------------------------------------
-- Menu Separator
---------------------------------------------------------------------------------

function Wardrobe.InitMenuSeparator(parent)
	local button = Wardrobe_MenuSeparator;
	button:SetWidth(parent:GetWidth());
	button:SetHeight(parent:GetHeight());
end

function Wardrobe.UpdateMenuSeparator(parent, top)
	local button = Wardrobe_MenuSeparator;

	--local width = parent:GetWidth();
	if (parent:IsEnabled() == 1) then
		local height = parent:GetHeight();
		local offset = height/2;


		if (top) then
			button:SetID(parent:GetID());
			button:SetPoint("CENTER", parent, "CENTER", 0, offset);
		else
			button:SetID(parent:GetID()+1);
			button:SetPoint("CENTER", parent, "CENTER", 0, -offset);
		end
		button:Show();
	else
		button:Hide();
	end
end

function Wardrobe.MenuSeparator_OnEnter(this)
	if (not Wardrobe.isReordering) then
		Wardrobe_MenuSeparator:Hide();
	end
end

function Wardrobe.MainMenuFrame_OnHide()
	Wardrobe.isReordering = nil;
	Wardrobe_DraggableMenuEntry:Hide();
	Wardrobe_MenuSeparator:Hide();
end

---------------------------------------------------------------------------------
-- Draggable Menu Entry
---------------------------------------------------------------------------------

function Wardrobe.UpdateDraggableMenuEntry(parent)
	local width = parent:GetWidth();
	local height = parent:GetHeight();
	local offset = height/2;
	local parentText = parent.text;

	local name = "Wardrobe_DraggableMenuEntry";
	local button = getglobal(name)
	local text = getglobal(name.."Text");

	text:SetText(parentText:GetText());
	text:SetTextColor(parentText:GetTextColor());
	button:SetID(parent:GetID());

	-- Attach to mouse
	local x, y = GetCursorPosition();
	button:ClearAllPoints();
	--local scale = UIParent:GetScale();
	if (parent.xOffset and parent.yOffset) then
		--button:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", x/scale-parent.xOffset, y/scale-parent.yOffset);
		button:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", x-parent.xOffset, y-parent.yOffset);
	else
		--button:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", x/scale-width/2, y/scale-height/2);
		button:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", x-width/2, y-height/2);
	end
	button:StartMoving();

	Wardrobe.isReordering = true;

	Wardrobe.highlightedSet = nil;
	Wardrobe.UpdateScrollingMenuHighlight();

	button:Show();

	return button;
end

function Wardrobe.DraggableMenuEntry_OnLoad(this)
	--this:RegisterForDrag("LeftButton"); -- This fubars dragging, only need it on the regular menu entries.
	this.text = getglobal(this:GetName().."Text");
	this.icon = getglobal(this:GetName().."Icon");
	this:SetBackdropBorderColor(0.1, 0.1, 0.1);
	this:SetBackdropColor(0.1, 0.1, 0.1, 0.75);
end

function Wardrobe.DraggableMenuEntry_OnMouseUp(this)
	if (Wardrobe.isReordering) then
		if (MouseIsOver(Wardrobe_MenuSeparator)) then
			local newID = Wardrobe_MenuSeparator:GetID();
			local oldID = this:GetID();
			Wardrobe.ReorderOutfit(oldID, newID);
		end
		Wardrobe_MenuSeparator:Hide();
		this:Hide();
		Wardrobe.isReordering = false;
	end
end

function Wardrobe.DraggableMenuEntry_OnUpdate(this)
--	if (not this.clock) then
--		this.clock = durr;
--	elseif (durr) then	
--		this.clock = this.clock + durr;
--	end

--	if (this.clock > 0.1) then
		--this.clock = 0;
		local overSep = MouseIsOver(Wardrobe_MenuSeparator);
		local overScrollFrame = MouseIsOver(Wardrobe_MenuScrollFrame);
		if (overScrollFrame or overSep) then
			local x, y = GetCursorPosition();
			--[[
			local scale = UIParent:GetScale();
			x = x/scale;
			y = y/scale;
			]]--
			local offset = -(y-Wardrobe_MenuScrollFrame:GetTop())/this:GetHeight();
			local i = ceil(offset); -- Frame # that the mouse is over;
			if (i <= 0 or i > WARDROBE_MAX_SCROLL_ENTRIES) then
				--Sea.io.print("Index: ", i, " offset: ", offset, " y: ", y, " Top: ", Wardrobe_MenuScrollFrame:GetTop(), " Height: ", this:GetHeight());
				Wardrobe_MenuSeparator:Hide();
				return;
			end
			local scrollOffset = FauxScrollFrame_GetOffset(Wardrobe_MenuScrollFrame);

			if (overSep and floor(offset) < 1 and scrollOffset > 0) then
				-- Scroll Up
				FauxScrollFrame_SetOffset(Wardrobe_MenuScrollFrame, scrollOffset-1);
				Wardrobe_MenuScrollFrameScrollBar:SetValue(ceil(scrollOffset-1.5)*WARDROBE_MAX_SCROLL_ENTRIES);
				Wardrobe.PopulateMainMenu();
				Wardrobe_MenuSeparator:Show();
				return;
			elseif (overSep and floor(offset + 0.5) >= WARDROBE_MAX_SCROLL_ENTRIES and scrollOffset+WARDROBE_MAX_SCROLL_ENTRIES < Wardrobe.GetNumOutfits()) then
				-- Scroll Down
				FauxScrollFrame_SetOffset(Wardrobe_MenuScrollFrame, scrollOffset+1);
				Wardrobe_MenuScrollFrameScrollBar:SetValue(ceil(scrollOffset+0.5)*WARDROBE_MAX_SCROLL_ENTRIES);
				Wardrobe.PopulateMainMenu();
				Wardrobe_MenuSeparator:Show();
				return;
			elseif (overScrollFrame) then
				local button = getglobal("Wardrobe_MenuEntry"..i);
				local onTop = (i - 0.5 > offset);
				Wardrobe.UpdateMenuSeparator(button, onTop);
			else
				Wardrobe_MenuSeparator:Hide();
			end
		else
			Wardrobe_MenuSeparator:Hide();
		end
--	end
end


--===============================================================================
--
-- Main menu buttons
--
--===============================================================================

---------------------------------------------------------------------------------
-- when clicking on the new outfit button
---------------------------------------------------------------------------------
function Wardrobe.NewOutfitButtonClick()
	Wardrobe_NamePopupText:SetText(TEXT("TXT_NEWOUTFITNAME"));
	Wardrobe.PopupFunction = "[Add]";
	Wardrobe.selectedOutfit = nil;
	Wardrobe.UpdateScrollingMenuHighlight();
	Wardrobe.ToggleMainMenuFrameVisibility(false);
	Wardrobe_NamePopup:Show();
end


---------------------------------------------------------------------------------
-- when clicking on the close button
---------------------------------------------------------------------------------
function Wardrobe.MainMenuCloseButton(this)
	this:GetParent():Hide();
end


---------------------------------------------------------------------------------
-- when clicking on the edit outfit button
---------------------------------------------------------------------------------
function Wardrobe.EditOutfitButtonClick()
	local selectedOutfit = Wardrobe.selectedOutfit;

	if (selectedOutfit) then
		Wardrobe.NewWardrobeName = Wardrobe.CurrentConfig.Outfit[selectedOutfit].OutfitName;
		Wardrobe.Rename_OldName = Wardrobe.NewWardrobeName;
		Wardrobe_NamePopupText:SetText("New Name");
		Wardrobe_NamePopupEditBox:SetText(Wardrobe.NewWardrobeName);
		Wardrobe.PopupFunction = "[Edit]";
		Wardrobe.ToggleMainMenuFrameVisibility(false);
		Wardrobe_NamePopup:Show();
	end
end


---------------------------------------------------------------------------------
-- when clicking on the update outfit button
---------------------------------------------------------------------------------
function Wardrobe.UpdateOutfitButtonClick()
	local selectedOutfit = Wardrobe.selectedOutfit;

	if (selectedOutfit) then
		Wardrobe.NewWardrobeName = Wardrobe.CurrentConfig.Outfit[selectedOutfit].OutfitName;
		Wardrobe.PopupFunction = "[Update]";
		Wardrobe.ShowWardrobe_ConfigurationScreen();
	end
end



---------------------------------------------------------------------------------
-- When clicking the special buttons
---------------------------------------------------------------------------------
local WARDROBE_TXT_NOLONGERWORN = {
	mount = function() return TEXT("TXT_NOLONGERWORNMOUNTERR") end;
	plague = function() return TEXT("TXT_NOLONGERWORNPLAGUEERR") end;
	eat = function() return TEXT("TXT_NOLONGERWORNEATERR") end;
	swim = function() return TEXT("TXT_NOLONGERWORNSWIMR") end;
};

local WARDROBE_TXT_WORNWHEN = {
	mount = function() return TEXT("TXT_WORNWHENMOUNTERR") end;
	plague = function() return TEXT("TXT_WORNPLAGUEERR") end;
	eat = function() return TEXT("TXT_WORNEATERR") end;
	swim = function() return TEXT("TXT_WORNSWIMR") end;
};

function Wardrobe.SpecialButtonClick(specialType)
	local outfitNum = Wardrobe.selectedOutfit;
	local alreadyUsingThisOutfitForSpecial = false;

	if (outfitNum) then
		local outfit = Wardrobe.CurrentConfig.Outfit[outfitNum];
		if (outfit.Special == specialType) then
			UIErrorsFrame:AddMessage(outfit.OutfitName.." "..WARDROBE_TXT_NOLONGERWORN[specialType](), 0.0, 1.0, 0.0, 1.0, UIERRORS_HOLD_TIME);
			alreadyUsingThisOutfitForSpecial = true;
		end

		-- Clear other special outfits of this type
		for i, outfitI in ipairs(Wardrobe.CurrentConfig.Outfit) do
			if (outfitI.Special == specialType) then
				outfitI.Special = nil;
			end
		end

		if (not alreadyUsingThisOutfitForSpecial) then
			outfit.Special = specialType;
			UIErrorsFrame:AddMessage(outfit.OutfitName.." "..WARDROBE_TXT_WORNWHEN[specialType](), 0.0, 1.0, 0.0, 1.0, UIERRORS_HOLD_TIME);
		end

		Wardrobe.PopulateMainMenu();
	end
end

function Wardrobe.MountButtonClick()
	Wardrobe.SpecialButtonClick("mount");
end

function Wardrobe.PlaguelandsButtonClick()
	Wardrobe.SpecialButtonClick("plague");
end

function Wardrobe.EatingButtonClick()
	Wardrobe.SpecialButtonClick("eat");
end

function Wardrobe.SwimButtonClick()
	Wardrobe.SpecialButtonClick("swim");
end


---------------------------------------------------------------------------------
-- When clicking the move up or move down buttons
---------------------------------------------------------------------------------
function Wardrobe.MoveOutfit_OnClick(direction)
	local outfitNum = Wardrobe.selectedOutfit;

	if (outfitNum) then
		Wardrobe.ReorderOutfit(outfitNum, outfitNum+direction)
	end
end

---------------------------------------------------------------------------------
-- Re-order an outfit in the list of outfits
---------------------------------------------------------------------------------
function Wardrobe.ReorderOutfit(outfitNum, newNum)
	if (newNum < 1) then
		return;
	end
	local outfits = Wardrobe.CurrentConfig.Outfit;
	local outfit = outfits[outfitNum];
	if (not outfit) then
		-- Doesn't exist
		return
	end
	if (newNum > #outfits+1) then
		return;
	end

	if (outfitNum < newNum-1) then
		Wardrobe.selectedOutfit = newNum-1;
		tremove(outfits, outfitNum, outfit);
		tinsert(outfits, newNum-1, outfit);
	elseif (outfitNum > newNum) then
		Wardrobe.selectedOutfit = newNum;
		tremove(outfits, outfitNum, outfit);
		tinsert(outfits, newNum, outfit);
	else
		-- No reorder necissary
		return;
	end

	if (Wardrobe_MainMenuFrame:IsVisible()) then
		Wardrobe.PopulateMainMenu();
	end
end


---------------------------------------------------------------------------------
-- When clicking the delete outfit button
---------------------------------------------------------------------------------
function Wardrobe.DeleteOutfit_OnClick()
	local selectedOutfit = Wardrobe.selectedOutfit;

	Wardrobe.Debug("Wardrobe.DeleteOutfit_OnClick() selectedOutfit =",selectedOutfit);

	if (selectedOutfit) then
		Wardrobe.PopupFunction = "DeleteFromSort";
		Wardrobe_NamePopupEditBox:SetText(Wardrobe.CurrentConfig.Outfit[selectedOutfit].OutfitName);
		Wardrobe_PopupConfirm:Show();
		Wardrobe.ToggleMainMenuFrameVisibility(false);
		Wardrobe_PopupConfirmText:SetText(TEXT("TXT_REALLYDELETEOUTFIT").."\n\n"..Wardrobe.CurrentConfig.Outfit[selectedOutfit].OutfitName);
	else
		UIErrorsFrame:AddMessage(TEXT("TXT_PLEASESELECTDELETE"), 1.0, 0.0, 0.0, 1.0, UIERRORS_HOLD_TIME);
	end
end


---------------------------------------------------------------------------------
-- When clicking to erase all outfits
---------------------------------------------------------------------------------

function Wardrobe.EraseAllOutfits_OnClick()
	Wardrobe.PopupFunction = "EraseAllOutfits";
--	Wardrobe_NamePopupEditBox:SetText(Wardrobe.CurrentConfig.Outfit[selectedOutfit].OutfitName);
	Wardrobe_PopupConfirmText:SetText(L["Really Purge ALL Outfits?\nThis is irreversible."]);
	Wardrobe_PopupConfirm:Show();
end


--===============================================================================
--
-- Color picker
--
--===============================================================================

---------------------------------------------------------------------------------
-- when clicking on a color in the color picker
---------------------------------------------------------------------------------
function Wardrobe.ColorPickFrameColor_OnClick(this)
	local selectedOutfit = Wardrobe.selectedOutfit;
	local buttonName = this:GetName();
	local x, y = string.find(buttonName, "%d+");
	Wardrobe_ColorPickFrame.buttonNum = tonumber(string.sub(buttonName, x, y));
	Wardrobe_ColorPickFrameExampleText:SetTextColor(WARDROBE_TEXTCOLORS[Wardrobe_ColorPickFrame.buttonNum][1],
												   WARDROBE_TEXTCOLORS[Wardrobe_ColorPickFrame.buttonNum][2],
												   WARDROBE_TEXTCOLORS[Wardrobe_ColorPickFrame.buttonNum][3]);

	if (Wardrobe.EnteredColorPickerFromPaperdollFrame) then
		Wardrobe.CurrentOutfitButtonColor = Wardrobe_ColorPickFrame.buttonNum;
	end
end


---------------------------------------------------------------------------------
-- Show the color selection menu
---------------------------------------------------------------------------------
function Wardrobe.ShowColorPickFrame()

	-- figure out where we were called from
	if (Wardrobe_MainMenuFrame:IsVisible()) then
		Wardrobe.EnteredColorPickerFromPaperdollFrame = false;
	else
		Wardrobe.EnteredColorPickerFromPaperdollFrame = true;
	end

	local selectedOutfit = Wardrobe.selectedOutfit;

	if (selectedOutfit or Wardrobe.EnteredColorPickerFromPaperdollFrame) then

		Wardrobe_ColorPickFrame:SetAlpha(1.0);
		Wardrobe_ColorPickFrame:Show();
		Wardrobe_ColorPickFrameGrid:SetFrameLevel(Wardrobe_ColorPickFrameGrid:GetFrameLevel() + 1);
		for i = 1, 24 do
			getglobal("Wardrobe_ColorPickFrameBox"..tostring(i).."Texture"):SetVertexColor(WARDROBE_TEXTCOLORS[i][1],WARDROBE_TEXTCOLORS[i][2],WARDROBE_TEXTCOLORS[i][3],1.0);
			getglobal("Wardrobe_ColorPickFrameBox"..tostring(i)):SetFrameLevel(Wardrobe_ColorPickFrameGrid:GetFrameLevel() - 1);
		end

		if (Wardrobe.EnteredColorPickerFromPaperdollFrame) then
			Wardrobe_ColorPickFrameExampleText:SetText(Wardrobe.NewWardrobeName);
			Wardrobe_ColorPickFrameExampleText:SetTextColor(WARDROBE_TEXTCOLORS[Wardrobe.CurrentOutfitButtonColor][1], WARDROBE_TEXTCOLORS[Wardrobe.CurrentOutfitButtonColor][2], WARDROBE_TEXTCOLORS[Wardrobe.CurrentOutfitButtonColor][3]);
		else
			Wardrobe_ColorPickFrameExampleText:SetText(Wardrobe.CurrentConfig.Outfit[selectedOutfit].OutfitName);
			local colorNum = Wardrobe.CurrentConfig.Outfit[selectedOutfit].ButtonColor;
			Wardrobe_ColorPickFrameExampleText:SetTextColor(WARDROBE_TEXTCOLORS[colorNum][1], WARDROBE_TEXTCOLORS[colorNum][2], WARDROBE_TEXTCOLORS[colorNum][3]);
		end

		if (not Wardrobe.EnteredColorPickerFromPaperdollFrame) then Wardrobe.ToggleMainMenuFrameVisibility(false); end

	end
end


---------------------------------------------------------------------------------
-- Accept the color selection menu
---------------------------------------------------------------------------------
function Wardrobe.AcceptColorPickFrame()
	if (Wardrobe.EnteredColorPickerFromPaperdollFrame) then
		Wardrobe.RefreshCharacterPanel();
	end
	if (Wardrobe_ColorPickFrame.buttonNum) then
		Wardrobe.SetSelectedOutfitColor(Wardrobe_ColorPickFrame.buttonNum);
		Wardrobe.PopulateMainMenu();
	end
	Wardrobe.HideColorPickFrame();
end


---------------------------------------------------------------------------------
-- set the color of the selected outfit based on which button was clicked in the color selector
---------------------------------------------------------------------------------
function Wardrobe.SetSelectedOutfitColor(num)
	local selectedOutfit = Wardrobe.selectedOutfit;

	if (selectedOutfit) then
		Wardrobe.CurrentConfig.Outfit[selectedOutfit].ButtonColor = num;
		Wardrobe.PopulateMainMenu();
	end
end

---------------------------------------------------------------------------------
-- Hide the color selection menu
---------------------------------------------------------------------------------
function Wardrobe.HideColorPickFrame()
	if (not Wardrobe.EnteredColorPickerFromPaperdollFrame) then
		Wardrobe.ToggleMainMenuFrameVisibility(true);
	end
	Wardrobe_ColorPickFrame.buttonNum = nil;
	Wardrobe_ColorPickFrame:Hide();
end


---------------------------------------------------------------------------------
-- Show the tooltip text
---------------------------------------------------------------------------------
function Wardrobe.ShowButtonTooltip(this, theText1, theText2, theText3, theText4, theText5)

	-- Set the anchor and text for the tooltip.
	GameTooltip:ClearLines();
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT");
	GameTooltip:SetText(theText1, 0.39, 0.77, 0.16);

	-- add description lines to the tooltip
	if (theText2) then
		GameTooltip:AddLine(theText2, 0.82, 0.24, 0.79);
	end
	if (theText3) then
		GameTooltip:AddLine(theText3, 0.82, 0.24, 0.79);
	end
	if (theText4) then
		GameTooltip:AddLine(theText4, 0.82, 0.24, 0.79);
	end
	if (theText5) then
		GameTooltip:AddLine(theText5, 0.82, 0.24, 0.79);
	end

	-- Adjust width and height to account for new lines and show the tooltip
	-- (the Show() command automatically adjusts the width/height)
	GameTooltip:Show();
end

---------------------------------------------------------------------------------
-- Makes additional menu entries (just not #1)
---------------------------------------------------------------------------------
function Wardrobe.MainMenuFrame_OnLoad()
	for i=2, WARDROBE_MAX_SCROLL_ENTRIES do
		Wardrobe.CreateMenuEntry(i);
	end

	tinsert(UISpecialFrames, "Wardrobe_MainMenuFrame");
end

function Wardrobe.CreateMenuEntry(i)
	local name = "Wardrobe_MenuEntry"..i;
	local button = getglobal(name)
	if (not button) then
		local button = CreateFrame("Button", name, Wardrobe_MainMenuFrame, "Wardrobe_MenuEntryTemplate");
		button:SetPoint("TOPLEFT", "Wardrobe_MenuEntry"..(i-1), "BOTTOMLEFT");
	end
end
