
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")

local TEXT = Wardrobe.GetString;
local L = LibStub("AceLocale-3.0"):GetLocale("Wardrobe")

WardrobeAce.LDB = {}


function WardrobeAce.LDB_Init()

	WardrobeAce.LDB.dataobj = { type = "data source",
		             text = TEXT("TXT_NO_OUTFIT"),
		             icon = [[Interface\AddOns\Wardrobe\Images\Wardrobe]],
					 OnClick = WardrobeAce.LDB.OnClick,
--					 OnEnter = WardrobeAce.LDB.OnEnter,
--					 OnTooltipShow = WardrobeAce.LDB.OnTooltipShow
			       }
--		  		     label = L["Wardrobe-AL"],


	WardrobeAce.LDB.broker = ldb:NewDataObject("Wardrobe-AL", WardrobeAce.LDB.dataobj)

	if(WardrobeAce.db.char.mustClickUIButton) then
		WardrobeAce.LDB.broker.OnEnter = nil;
	    WardrobeAce.LDB.broker.OnTooltipShow = WardrobeAce.LDB.OnTooltipShow;
	else
	    WardrobeAce.LDB.broker.OnEnter = WardrobeAce.LDB.OnEnter;
		WardrobeAce.LDB.broker.OnTooltipShow = nil;
    end;


	WardrobeAce.LDB.MenuFrame = CreateFrame("Frame","WardrobeLDBMenuFrame", UIParent, "UIDropDownMenuTemplate");
	UIDropDownMenu_Initialize(WardrobeAce.LDB.MenuFrame, WardrobeAce.LDB.PopulateMenuFrame, "MENU");
	WardrobeAce.LDB.MenuFrame:SetScript("OnEvent", WardrobeAce.LDB.MenuFrame_OnEvent);

	WardrobeAce.LDB.MenuFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
	WardrobeAce.LDB.MenuFrame:RegisterEvent("UNIT_INVENTORY_CHANGED");
end

function WardrobeAce.LDB.MenuFrame_OnEvent(self, event, ...)
	if (event == "UNIT_INVENTORY_CHANGED") then
--		Chronos.scheduleByName("WardrobeLDBUpdate", .2, function() WardrobeAce.LDB.OnUpdateText(self) end);
		WardrobeAce:ScheduleTimer(function() WardrobeAce.LDB.OnUpdateText(self) end, .2);
	elseif (event == "PLAYER_ENTERING_WORLD") then
		Wardrobe.enteredWorld = true;
		Wardrobe.CheckForOurWardrobeID();
		WardrobeAce.LDB.OnUpdateText(self);
	end

end

function WardrobeAce.LDB.OnClick(self, button)
	Wardrobe.Debug("Wardrobe: WardrobeAce.LDB.OnClick() called");

	if(button == "RightButton") then
		WardrobeAce.LDB_RightClickOpenFunction[WardrobeAce.db.char.ldb.rightClickOpens].func()
--		if(WardrobeAce.db.char.ldb.rightClickOpens == 3) then
--			UIDropDownMenu_Refresh(WardrobeAce.LDB.MenuFrame);
--			ToggleDropDownMenu(1, nil, WardrobeAce.LDB.MenuFrame, "cursor", -15, 20, "TOPRIGHT");
--		end
	else
		WardrobeAce.LDB.ShowWardrobeMenu(self)
	end


end

function WardrobeAce.LDB.OnEnter(self)
	Wardrobe.Debug("Wardrobe: WardrobeAce.LDB.OnEnter called");

	if not WardrobeAce.db.char.mustClickUIButton then
		WardrobeAce.LDB.ShowWardrobeMenu(self)
	end


end

function WardrobeAce.LDB.ShowWardrobeMenu(self)
	Wardrobe.ShowUIMenu(self)
end


function WardrobeAce.LDB.OnTooltipShow(self)
	Wardrobe.Debug("Wardrobe: WardrobeAce.LDB.OnTooltipShow called");

	if WardrobeAce.db.char.mustClickUIButton then
		local menustring = WardrobeAce.LDB_RightClickOpenFunction[WardrobeAce.db.char.ldb.rightClickOpens].desc

		GameTooltip:AddLine("|cffffff00" .. L["Select your outfit or configure Wardrobe"])
		GameTooltip:AddLine("|cffffff00" .. L["Right-click|r to open "]..menustring)
	end
end

function WardrobeAce.LDB.OnUpdateText()
	-- get the list of outfits
	local outfitText = Wardrobe.GetActiveOutfitsTextList(Wardrobe.MaxBarTextLen)

	-- prepend the label
	if (WardrobeAce.db.char.ldb.showTextPrefix) then
		outfitText = L["Wardrobe: "]..outfitText
	end

	-- set the text
	WardrobeAce.LDB.dataobj.text = outfitText;
end

-- Menu table
local MenuOptsTable = {
		[1] = {
			type = "header",
			name = L["Wardrobe-AL"],
			order = 1,
		},
		[2] = AceConfigOptions.args.General.args.EditWardrobes,
		[3] = AceConfigOptions.args.General.args.ShowMinimapIcon,
		[4] = AceConfigOptions.args.General.args.LockButton,
		[5] = AceConfigOptions.args.General.args.ItemTooltips,
		[6] = AceConfigOptions.args.General.args.AutoSwap,
		[7] = AceConfigOptions.args.General.args.AutoSwapInBG,
		[8] = AceConfigOptions.args.General.args.AutoSwapInWG,
		[9] = AceConfigOptions.args.General.args.ldbShowTextPrefix,
		[10] = {
			type = "execute",
			name = L["Addon Settings"],
			desc = L["Addon Settings"],
			func = function() WardrobeAce.ToggleConfig() end,
		},
		[11] = {
			type = "description",
			name = "\n",
			desc = "\n",
		},
		[12] = {
			type = "execute",
			name = L["Close"],
			desc = L["Close"],
			func = function() ToggleDropDownMenu(1, nil, WardrobeAce.LDB.MenuFrame); end,
		}
}


function WardrobeAce.LDB.AddInfoItem(item)

	if((not item) or (item["type"] ~= "header" and item["type"] ~= "toggle" and item["type"] ~= "execute" and item["type"] ~= "description")) then
		return;
	end

--	Wardrobe.Debug("Wardrobe: Calling WardrobeAce.LDB.AddInfoItem() item=",item,"item.name=",item["name"],"item.type=",item["type"]);

	info            = {};
	info.text       = item.name;
--	info.value      = "OptionVariable";
	if(item["type"] ~= "description") then
		info.tooltipTitle = item.name;
		info.tooltipText = item.desc;
	else
		info.notClickable = 1;
	end
	if(item["type"] == "header") then
		info.isTitle = true;
	end
	if(item["type"] == "toggle") then
		info.checked = item.get;
		info.func = item.set;
	end
	if(item["type"] == "execute") then
		info.func = item.func;
	end
	local disable = nil;
	if(item.disabled and item.disabled() == true) then disable = true; end;
	info.disabled = disable;
	info.keepShownOnClick = 1;
	UIDropDownMenu_AddButton(info);
end

function WardrobeAce.LDB.PopulateMenuFrame()

--	Wardrobe.Debug("Wardrobe: Calling WardrobeAce.LDB.PopulateMenuFrame()");

	for index, value in ipairs(MenuOptsTable) do
--		Wardrobe.Debug("index=",index,"value=",value);
		WardrobeAce.LDB.AddInfoItem(value);
	end
end

