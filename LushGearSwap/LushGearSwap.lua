if not LushGearSwapIDS 		then LushGearSwapIDS = {}; 		end
if not LushGearSwap_Options then LushGearSwap_Options = {}; end
local LushGearSwap_SubOptionColor = "|c0000F0FF"

local LushGearSwapItemList = {};
local LushGearSwap_ZoneSwapList = {};
local LushGearSwap_InEqqZone = false;
local LushGearSwap_BankOpen = false;
local LushGearSwap_DropDownMenu = CreateFrame("Frame", "LushGearSwap_SpecDropDownMenu", UIParent, "UIDropDownMenuTemplate");

-- Lookup table for Item to Character UI
LushGearSwap_GearUILocations = {
	[1] = "CharacterHeadSlot",
	[2] = "CharacterNeckSlot",
	[3] = "CharacterShoulderSlot",
	[4] = "CharacterShirtSlot",
	[5] = "CharacterChestSlot",
	[6] = "CharacterWaistSlot",
	[7] = "CharacterLegsSlot",
	[8] = "CharacterFeetSlot",
	[9] = "CharacterWristSlot",
	[10] = "CharacterHandsSlot",
	[11] = "CharacterFinger0Slot",
	[12] = "CharacterFinger1Slot",
	[13] = "CharacterTrinket0Slot",
	[14] = "CharacterTrinket1Slot",
	[15] = "CharacterBackSlot",
	[16] = "CharacterMainHandSlot",
	[17] = "CharacterSecondaryHandSlot",
	[18] = "CharacterRangedSlot",
	[19] = "CharacterTabardSlot",
};

function LushGearSwap_Log(a_msg)
	DEFAULT_CHAT_FRAME:AddMessage("LGS: " .. a_msg)
end

-- Set event script.
LushGearSwapFrame:SetScript("OnEvent", function(self, event, ...)
	if self[event] then
		self[event](self, event, ...)
	end
	
	-- [[ Run Plugin Events ]] --
	if self.plugins then
		for pluginName, pluginClass in pairs(self.plugins) do
			if pluginClass.events then
				if pluginClass.events[event] then
					pluginClass.events[event](...);
				end
			end
		end
	end
end)

-- Regiger Events.
LushGearSwapFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
LushGearSwapFrame:RegisterEvent("EQUIPMENT_SWAP_FINISHED");
LushGearSwapFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
LushGearSwapFrame:RegisterEvent("ZONE_CHANGED");
LushGearSwapFrame:RegisterEvent("ZONE_CHANGED_INDOORS");
LushGearSwapFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
LushGearSwapFrame:RegisterEvent("BANKFRAME_OPENED")
LushGearSwapFrame:RegisterEvent("BANKFRAME_CLOSED")
LushGearSwapFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
LushGearSwapFrame:RegisterEvent("QUEST_LOG_UPDATE");
LushGearSwapFrame:RegisterEvent("ADDON_LOADED");

function LushGearSwap_AddPlugin(a_pluginName, a_initFunc, a_playerEnteringWorldFunc)
	if LushGearSwapFrame.plugins == nil then
		LushGearSwapFrame.plugins = {};
	end
	
	LushGearSwapFrame.plugins[a_pluginName] = {};
	LushGearSwapFrame.plugins[a_pluginName].Init = a_initFunc;
	LushGearSwapFrame.plugins[a_pluginName].playerEnteringWorld = a_playerEnteringWorldFunc;
end

function LushGearSwap_Plugin_RegisterEvent(a_pluginName, a_event, a_eventFunc)
	if LushGearSwapFrame.plugins then
		if LushGearSwapFrame.plugins[a_pluginName] then
			if not LushGearSwapFrame.plugins[a_pluginName].events then
				LushGearSwapFrame.plugins[a_pluginName].events = {};
			end
			
			LushGearSwapFrame.plugins[a_pluginName].events[a_event] = a_eventFunc;
			LushGearSwapFrame:RegisterEvent(a_event);
		end
	end
end

function LushGearSwap_RebuildReleventData()
	LushGearSwap_ZoneSwapList = {};
	
	for i=1, GetNumEquipmentSets() do
		local name, icon, lessIndex = GetEquipmentSetInfo(i)

		if (LushGearSwap_Options[name]) then		
			if (LushGearSwap_Options[name].ZoneSwap) then
				LushGearSwap_ZoneSwapList[LushGearSwap_Options[name].ZoneSwap] = name;
			end

			if (LushGearSwap_Options[name].MajorZoneSwaps) then
				for ZoneName, _ in pairs(LushGearSwap_Options[name].MajorZoneSwaps) do
					if (LushGearSwap_ZoneSwapLocaitons[ZoneName]) then
						for SubZoneName, QuestNameList in pairs(LushGearSwap_ZoneSwapLocaitons[ZoneName]) do
							for i = 1, #QuestNameList do
								if (LushGearSwap_AmIOnQuest(QuestNameList[i])) then
									LushGearSwap_ZoneSwapList[SubZoneName] = name;
								end
							end							
						end
					else
						LushGearSwap_Options[name].MajorZoneSwaps[ZoneName] = nil;
					end
				end
			end
		end
	end	
end

function LushGearSwapFrame.ADDON_LOADED(self, event, addonName)
	if addonName == "LushGearSwap" then		
		-- [[ Hook the gear manager OnShow ]] --
		PaperDollEquipmentManagerPane:HookScript("OnShow", function(a_self)
			LushGearSwap_RegisterForClickHook(1, MAX_EQUIPMENT_SETS_PER_PLAYER);
		end);
		
		-- [[ Hook the PaperDollEquipmentManagerPane OnHide ]] --
		PaperDollEquipmentManagerPane:HookScript("OnHide", function(a_self)
			LushGearSwap_DropDownMenu:Hide();
		end);
		
		-- [[ Hook the PaperDollFrame OnHide ]] --
		PaperDollFrame:HookScript("OnHide", function(a_self)
			LushGearSwap_DropDownMenu:Hide();
			LushGear_Options_Hide();
		end);
		
		-- [[ Hook the GearManagerDialogPopup OnHide ]] --
		GearManagerDialogPopup:HookScript("OnHide", function(a_self)
			LushGearSwap_DropDownMenu:Hide();
		end);
		
		-- [[ Hook the GearManagerDialogPopup OnShow ]] --
		GearManagerDialogPopup:HookScript("OnShow", function(a_self)
			LushGearSwap_DropDownMenu:Hide();
			LushGear_Options_Hide();
		end);
		
		-- [[ Load Plugins ]] --
		if self.plugins then
			for pluginName, pluginClass in pairs(self.plugins) do
				pluginClass.Init(self);
			end
		end
	end
end

function LushGearSwapFrame.QUEST_LOG_UPDATE(self, event, ...)
	LushGearSwap_RebuildReleventData();
end

function LushGearSwap_HasTalent(TallentName)
	for t=1, GetNumTalentTabs() do
		for i=0, GetNumTalents(t) do
			local name, iconPath, tier, column, currentRank, maxRank, isExceptional, meetsPrereq = GetTalentInfo(t, i);
			if (name == TallentName) then
				return true;
			end
		end
	end
	return false;
end

function LushGearSwap_IsTwoHandedWeapon(WeaponSubtype)
	return	WeaponSubtype == LGS_ITEM_SUBCLASS_2HSWORDS or
			WeaponSubtype == LGS_ITEM_SUBCLASS_2HMACE or
			WeaponSubtype == LGS_ITEM_SUBCLASS_2HAXE or
			WeaponSubtype == LGS_ITEM_SUBCLASS_STAVES or
			WeaponSubtype == LGS_ITEM_SUBCLASS_POLEARMS;
end

function LushGearSwapFrame.ACTIVE_TALENT_GROUP_CHANGED()

	local SetToUse = LushGearSwapIDS[GetActiveSpecGroup()];
	if (SetToUse) then

		-- WARRIOR SUPPORT! - Take off your offhand before swapping sets. a problem with warrior specs containing titans grip talent
		local localizedClass, englishClass = UnitClass("unit");
		if (englishClass == "WARRIOR" and LushGearSwap_HasTalent(LGS_SPELL_TITANS_GRIP) == false) then
			local offhandlink = GetInventoryItemLink("player", GetInventorySlotInfo("SecondaryHandSlot"))
			if ( offhandlink ~= nil ) then
				local sName, sLink, iRarity, iLevel, iMinLevel, iType, iSubType, iStackCount = GetItemInfo( offhandlink );
				if (iType == LGS_ITEM_CLASS_WEAPON and LushGearSwap_IsTwoHandedWeapon( iSubType )) then
					for bagID = 0, 4 do
						local numberoffreeslots, bagtype = GetContainerNumFreeSlots(bagID);
						if (numberoffreeslots > 0 and bagtype == 0) then
							bagwithspace = bagID
						end
					end

					if (bagwithspace == 0) then
						PickupInventoryItem(GetInventorySlotInfo("SecondaryHandSlot"))
						PutItemInBackpack()

					elseif (bagwithspace > 0 and bagwithspace <= NUM_BAG_SLOTS) then
						bagwithspace = bagwithspace + 19
						PickupInventoryItem(GetInventorySlotInfo("SecondaryHandSlot"))
						PutItemInBag(bagwithspace)
					end
				end
			end
		end
		-- End warrior support

		-- Doing this so if there is any locked items, it will wait untill they are unlocked before changing gear.
		LushGearSwapFrame.PendingSetChange = SetToUse;
		LushGearSwapFrame:SetScript("OnUpdate", function ()
			for i = 0, 19 do
				if (IsInventoryItemLocked(i)) then
					return;
				end
			end

			UseEquipmentSet(LushGearSwapFrame.PendingSetChange)
			LushGearSwapFrame.PendingSetChange = nil;
			LushGearSwapFrame:SetScript("OnUpdate", nil);
		end);
	end
end

function LushGearSwapFrame.ZONE_CHANGED(self, event, ...)	
	if LushGearSwap_ZoneSwapList[GetMinimapZoneText()] then
		UseEquipmentSet( LushGearSwap_ZoneSwapList[GetMinimapZoneText()] )
		LushGearSwap_InEqqZone = true;

	elseif LushGearSwap_ZoneSwapList[GetSubZoneText()] then
		UseEquipmentSet( LushGearSwap_ZoneSwapList[GetSubZoneText()] )
		LushGearSwap_InEqqZone = true;

	elseif LushGearSwap_ZoneSwapList[GetRealZoneText()] then
		UseEquipmentSet( LushGearSwap_ZoneSwapList[GetRealZoneText()] )
		LushGearSwap_InEqqZone = true;

	elseif LushGearSwap_InEqqZone == true then
		LushGearSwap_InEqqZone = false;
		local CurrentTallentSpec = GetActiveSpecGroup();

		if (LushGearSwapIDS[CurrentTallentSpec]) then
			UseEquipmentSet( LushGearSwapIDS[CurrentTallentSpec] );
		end
	end
end
LushGearSwapFrame.ZONE_CHANGED_INDOORS 	= LushGearSwapFrame.ZONE_CHANGED;
LushGearSwapFrame.ZONE_CHANGED_NEW_AREA = LushGearSwapFrame.ZONE_CHANGED;

function LushGearSwapFrame.PLAYER_ENTERING_WORLD(self, event, ...)
	-- [[ Load Plugins ]] --
	if self.plugins then
		for pluginName, pluginClass in pairs(self.plugins) do
			if pluginClass.playerEnteringWorld then
				pluginClass.playerEnteringWorld();
			end
		end
	end
	-- [[ PvP Battleground localization has to be done here as ]] --
	-- [[ the Battleground infomation is not avaliable when    ]] --
	-- [[ the other localiztion is loaded. :(                  ]] --
	
	-- normal battlegrounds
	for index = 1, GetNumBattlegroundTypes() do
		local localizedName = GetBattlegroundInfo(index)
		if localizedName then
			LushGearSwap_ZoneSwapLocaitons["Battlegrounds"][localizedName] = { 1, }
		end
	end

	-- world pvp areas (Wintergraps, Tol Borad)
	for index = 1, GetNumWorldPVPAreas() do
		local _, localizedName = GetWorldPVPAreaInfo(index)	
		LushGearSwap_ZoneSwapLocaitons["Battlegrounds"][localizedName] = { 1, }
	end
end

function LushGearSwapFrame.BANKFRAME_OPENED(self, event, ...)
	LushGearSwap_BankOpen = true;
end

function LushGearSwapFrame.BANKFRAME_CLOSED(self, event, ...)
	LushGearSwap_BankOpen = false;

	if (LushGearSwap_DropDownMenu and LushGearSwap_DropDownMenu:IsVisible()) then
		LushGearSwap_DropDownMenu:Hide();
	end
end

function LushGearSwap_IsBankOpen()
	return LushGearSwap_BankOpen;
end

function LushGearSwap_SetPrimarySet(SetName)
	if (SetName) then
		if (LushGearSwapIDS[1] == SetName) then
			LushGearSwapIDS[1] = nil;
		else
			LushGearSwapIDS[1] = SetName;
		end
	end
end

function LushGearSwap_SetAltSet(SetName)
	if (SetName) then
		if (LushGearSwapIDS[2] == SetName) then
			LushGearSwapIDS[2] = nil;
		else
			LushGearSwapIDS[2] = SetName;
		end
	end
end

function LushGearSwap_ResetSets()
	LushGearSwapIDS[1] = nil;
	LushGearSwapIDS[2] = nil;
end

function LushGearSwap_OverwriteCurrentSet()
	-- This could be better
	-- Find icon to use, and save your set.
	local icon = GetEquipmentSetInfoByName(LushGearSwapFrame.CurrentSet)
	icon = "Interface\\Icons\\" .. icon;
	local indexToUse = 1;
	
	-- Search for your icon
	for i=1, GetNumMacroIcons() do
		local texture, index = GetEquipmentSetIconInfo(i);
		if (texture == icon) then
			indexToUse = index;
			break;
		end
	end

	SaveEquipmentSet(LushGearSwapFrame.CurrentSet, indexToUse);
end

function LushGearSwap_SpecDropDownMenu_CreateNewInfo(text, checkable, isTitle, isDisabled)
	local info = UIDropDownMenu_CreateInfo()
	info.isNotRadio = true;
	info.text = text
	info.notCheckable = not checkable
	info.disabled = not text or isTitle or isDisabled
	info.isTitle = isTitle;
	return info
end

function LushGearSwap_SpecDropDownMenu_init()
	if not LushGearSwapFrame.CurrentSet then
		return;
	end
	
	local info = LushGearSwap_SpecDropDownMenu_CreateNewInfo(LushGearSwapFrame.CurrentSet, false, true);
	UIDropDownMenu_AddButton(info);
	
	if GetNumSpecGroups() >= 2 then
		info = LushGearSwap_SpecDropDownMenu_CreateNewInfo(LushGearSwap_SubOptionColor .. LGS_DUALSPEC_OPTION, false, true)
		UIDropDownMenu_AddButton(info);
		
		info = LushGearSwap_SpecDropDownMenu_CreateNewInfo(LGS_PRIMSPEC_OPTION, true);	
		info.owner = LushGearSwap_DropDownMenu:GetParent();
		info.checked = LushGearSwapIDS[1] == LushGearSwapFrame.CurrentSet;
		info.func = function() LushGearSwap_SetPrimarySet( LushGearSwapFrame.CurrentSet ) end;
		UIDropDownMenu_AddButton(info);

		--"|TInterface\Common\UI-SliderBar-Background:0:1.5:0:0:8:8|t"
		info = LushGearSwap_SpecDropDownMenu_CreateNewInfo(LGS_ALTSPEC_OPTION, true);
		info.disabled = GetNumSpecGroups() == 1;
		info.checked = LushGearSwapIDS[2] == LushGearSwapFrame.CurrentSet;
		info.func = function() LushGearSwap_SetAltSet( LushGearSwapFrame.CurrentSet ) end;
		UIDropDownMenu_AddButton(info);
		
		info = LushGearSwap_SpecDropDownMenu_CreateNewInfo(LGS_DONTSWAP_OPTION, true);
		info.func = function() LushGearSwap_ResetSets() end;
		info.checked = not LushGearSwapIDS[2] and not LushGearSwapIDS[1]
		UIDropDownMenu_AddButton(info);

		info = LushGearSwap_SpecDropDownMenu_CreateNewInfo();
		UIDropDownMenu_AddButton(info);
	end

	info = LushGearSwap_SpecDropDownMenu_CreateNewInfo(LushGearSwap_SubOptionColor .. LGS_BANK_OPTION, false, true)
	UIDropDownMenu_AddButton(info);
	--if (LushGearSwap_IsBankOpen()) then		
		info = LushGearSwap_SpecDropDownMenu_CreateNewInfo(LGS_DEPOSITBANK_OPTION, false, false, not LushGearSwap_IsBankOpen());
		if (not LushGearSwap_Options[LushGearSwapFrame.CurrentSet].NeverDeposit) then
			info.func = function()
				LushGearSwap_AllinOneDepositSetsFunc( 	{ [LushGearSwapFrame.CurrentSet] = 1 } , 
								
									function(NumSetsItemusedIn, bFoundInSetList, bInSetsNoDeposit)
										return bFoundInSetList and bInSetsNoDeposit == false;
									end);
			end;
			UIDropDownMenu_AddButton(info);

			info = LushGearSwap_SpecDropDownMenu_CreateNewInfo(LGS_DEPOSITBANKUNIQUE_OPTION, false, false, not LushGearSwap_IsBankOpen());
			info.func = function()
				LushGearSwap_AllinOneDepositSetsFunc( 	{ [LushGearSwapFrame.CurrentSet] = 1 } , 
							
									function(NumSetsItemusedIn, bFoundInSetList, bInSetsNoDeposit)
										return NumSetsItemusedIn == 1 and bFoundInSetList and bInSetsNoDeposit == false;
									end);
			end;
			UIDropDownMenu_AddButton(info);
		end

		info = LushGearSwap_SpecDropDownMenu_CreateNewInfo(LGS_DEPOSITBALLALLOTHER_OPTION, false, false, not LushGearSwap_IsBankOpen());
		info.func = function()
			-- make Set list.

			local DepoList = {};
			for i=1, GetNumEquipmentSets() do
				local Setname, Seticon, SetlessIndex = GetEquipmentSetInfo(i);
				if Setname then
					if (not LushGearSwap_Options[Setname]) then
						LushGearSwap_Options[Setname] = {};
					end
					if (Setname ~= LushGearSwapFrame.CurrentSet and not LushGearSwap_Options[Setname].NeverDeposit) then
						DepoList[Setname] = 1;
					end
				end
			end

			LushGearSwap_AllinOneDepositSetsFunc( 	{ [LushGearSwapFrame.CurrentSet] = 1 } , 
							
								function(NumSetsItemusedIn, bFoundInSetList, bInSetsNoDeposit)
									return NumSetsItemusedIn > 0 and bFoundInSetList == false and bInSetsNoDeposit == false;
								end);
		end;
		UIDropDownMenu_AddButton(info);

		info = LushGearSwap_SpecDropDownMenu_CreateNewInfo(LGS_WITHDRAWBANK_OPTION, false, false, not LushGearSwap_IsBankOpen());
		info.func = function() LushGearSwap_WithdrawCurrentSetFromBank(); end;
		UIDropDownMenu_AddButton(info);
	--end

	info = LushGearSwap_SpecDropDownMenu_CreateNewInfo(LGS_NEVERDEPOSIT_OPTION, true);
	info.checked = LushGearSwap_Options[LushGearSwapFrame.CurrentSet].NeverDeposit;
	info.func = function()
		if (LushGearSwap_Options[LushGearSwapFrame.CurrentSet].NeverDeposit) then
			LushGearSwap_Options[LushGearSwapFrame.CurrentSet].NeverDeposit = nil;
		else
			LushGearSwap_Options[LushGearSwapFrame.CurrentSet].NeverDeposit = true;
		end
	end;
	UIDropDownMenu_AddButton(info);
	
	info = LushGearSwap_SpecDropDownMenu_CreateNewInfo()
	UIDropDownMenu_AddButton(info);
	
	info = LushGearSwap_SpecDropDownMenu_CreateNewInfo(LushGearSwap_SubOptionColor .. LGS_GENERAL_OPTION, false, true)
	UIDropDownMenu_AddButton(info);
	
	info = LushGearSwap_SpecDropDownMenu_CreateNewInfo(LGS_UPDATECURRENT_OPTION);
	info.func = function()
		StaticPopupDialogs["LUSHGEARSWAP_UPDATESET"].OnAccept = LushGearSwap_OverwriteCurrentSet;
		StaticPopupDialogs["LUSHGEARSWAP_UPDATESET"].timeout = 0;
		StaticPopupDialogs["LUSHGEARSWAP_UPDATESET"].whileDead = true;
		StaticPopupDialogs["LUSHGEARSWAP_UPDATESET"].hideOnEscape = true;
		StaticPopup_Show("LUSHGEARSWAP_UPDATESET", LushGearSwapFrame.CurrentSet);
	end;
	UIDropDownMenu_AddButton(info);

	info = LushGearSwap_SpecDropDownMenu_CreateNewInfo();
	UIDropDownMenu_AddButton(info);

	info = LushGearSwap_SpecDropDownMenu_CreateNewInfo(LGS_SET_OPTION);
	info.func = function() LushGearSwap_DisplayOptions(); end;
	UIDropDownMenu_AddButton(info);
end

LushGearSwap_GearSetButton_OnClick = GearSetButton_OnClick;
function GearSetButton_OnClick(self, arg1)
	if arg1 == "LeftButton" then
		LushGearSwap_GearSetButton_OnClick(self, arg1);
		
	elseif arg1 == "MiddleButton" then
		if self.name then
			UseEquipmentSet(self.name);
		end
		
	elseif arg1 ~= nil then
		PaperDollEquipmentManagerPaneEquipSet:Disable();
		PaperDollEquipmentManagerPaneSaveSet:Disable();
		GearManagerDialogPopup:Hide();
		LushGear_Options_Hide();
		
		LushGearSwap_DropDownMenu:Show();
		LushGearSwap_DropDownMenu:SetParent(self);

		UIDropDownMenu_Initialize(LushGearSwap_DropDownMenu, LushGearSwap_SpecDropDownMenu_init, "MENU");
		ToggleDropDownMenu(1, nil, LushGearSwap_DropDownMenu, self, 170, 45);
	end
end

function LushGearSwap_RegisterForClickHook(startindex, endindex)
	for i = startindex, endindex do
		if getglobal("PaperDollEquipmentManagerPaneButton" .. i) then
			getglobal("PaperDollEquipmentManagerPaneButton" .. i):RegisterForClicks("RightButtonDown", "LeftButtonDown", "MiddleButtonDown");
			getglobal("PaperDollEquipmentManagerPaneButton" .. i):SetScript('OnClick', GearSetButton_OnClick );
		end
	end
end

-- Overload OnEnter to Read The tooltip info. for depositing the gear in and out of the bank.
local OldGearSetButton_OnEnter = GearSetButton_OnEnter;
function GearSetButton_OnEnter(self)
	OldGearSetButton_OnEnter(self);

	LushGearSwapItemList = {}
	LushGearSwapFrame.CurrentSet = self.name;

	if (LushGearSwapFrame.CurrentSet and not LushGearSwap_Options[LushGearSwapFrame.CurrentSet]) then
		LushGearSwap_Options[LushGearSwapFrame.CurrentSet] = {};
	end

	LushGearSwap_SpecDropDownMenu:Hide();
end

function LushGearSwap_GetFreeInvSlotContainerScreenshot(CheckBankSlots, CheckPlayerBags)
	local RetTable = {};
	local count = 0;
	for bag = -1, NUM_BAG_SLOTS+NUM_BANKBAGSLOTS do
		local IsBagBankBag = bag == -1 or bag >= NUM_BAG_SLOTS+1;
		-- (bag == -1 or bag >= NUM_BAG_SLOTS+1) ? CheckBankSlots : CheckPlayerBags
		if ( (IsBagBankBag and CheckBankSlots) or (not IsBagBankBag and CheckPlayerBags) ) then
			local numberoffreeslots, bagtype = GetContainerNumFreeSlots(bag);
			if numberoffreeslots > 0 then
				if bag > 0 then
					RetTable[ContainerIDToInventoryID(bag)] = numberoffreeslots;
					count = count + numberoffreeslots;
				else
					if bag == -1 then
						for InvBankSlot=40, 67 do
							if not IsInventoryItemLocked(InvBankSlot) then
								if GetInventoryItemLink("Player", InvBankSlot) == nil then
									RetTable[InvBankSlot] = 1;
									count = count + 1;
								end
							end
						end
					else -- bag = 0 or back pack.
						RetTable[0] = numberoffreeslots;
						count = count + 1;
					end
				end
			end
		end
	end

	if count > 0 then
		return RetTable;
	end

	return nil;
end

function LushGearSwap_DepositCursorItem(FreeInvSlotContainerScreenshot)
	if (FreeInvSlotContainerScreenshot) then
		for InvSlotID, NumSpaces in pairs( FreeInvSlotContainerScreenshot ) do
			if NumSpaces > 0 then
			
				FreeInvSlotContainerScreenshot[InvSlotID] = FreeInvSlotContainerScreenshot[InvSlotID] - 1;
				if FreeInvSlotContainerScreenshot[InvSlotID] == 0 then
					FreeInvSlotContainerScreenshot[InvSlotID] = nil;
				end
				
				if InvSlotID == 0 then
					PutItemInBackpack();	-- Special case :(
				else
					PutItemInBag(InvSlotID);
				end
				
				if CursorHasItem() then
					ClearCursor()
					return;
				end
				
				break;
			end
		end
	end

	if CursorHasItem() then
		ClearCursor()
	end
end

function LushGearSwap_AllinOneDepositSetsFunc(SetsToDepositList, ShouldDepositFunc)
	-- Calc free bag spaces.
	local BagTable = LushGearSwap_GetFreeInvSlotContainerScreenshot(true, false);

	-- Bags
	for bag = 0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do

			local bFoundInSetList = false;
			local NumFound = 0;
			local bInSetsNoDeposit = false;

			local name = GetContainerItemLink(bag, slot);
			if name then
				local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(name);
				if itemName then

					for i=1, GetNumEquipmentSets() do
						local set = GetEquipmentSetInfo(i);
						local itemArray = GetEquipmentSetItemIDs(set);
						if itemArray then
							for i=1, 19 do
								if (itemArray[i]) then
									local sName, sLink, iRarity, iLevel, iMinLevel, sType, sSubType, iStackCount = GetItemInfo(itemArray[i]);
									if (sName) then
										if sName == itemName then
											NumFound = NumFound + 1;
											if SetsToDepositList[set] then
												bFoundInSetList = true;
											end

											if LushGearSwap_Options[set] and LushGearSwap_Options[set].NeverDeposit then
												bInSetsNoDeposit = true;
											end
										end
									end
								end
							end
						end
					end
				end
			end

			-- Deposit the item.
			if ShouldDepositFunc(NumFound, bFoundInSetList, bInSetsNoDeposit) then
				PickupContainerItem(bag, slot);
				LushGearSwap_DepositCursorItem( BagTable );
			end
		end
	end

	-- Inventory
	for InvSlot=0, 19 do
		local bFoundInSetList = false;
		local NumFound = 0;
		local bInSetsNoDeposit = false;

		local iLink = GetInventoryItemLink("Player", InvSlot);
		if iLink then
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(iLink);
			if itemName then
				for i=1, GetNumEquipmentSets() do
					local set = GetEquipmentSetInfo(i);
					local itemArray = GetEquipmentSetItemIDs(set);
					if itemArray then
						for i=1, 19 do
							if (itemArray[i]) then
								local sName, sLink, iRarity, iLevel, iMinLevel, sType, sSubType, iStackCount = GetItemInfo(itemArray[i]);
								if (sName) then
									if sName == itemName then
										NumFound = NumFound + 1;
										if SetsToDepositList[set] then
											bFoundInSetList = true;
										end

										if LushGearSwap_Options[set] and LushGearSwap_Options[set].NeverDeposit then
											bInSetsNoDeposit = true;
										end
									end
								end
							end
						end
					end
				end
			end
		end

		-- Deposit the item.
		if ShouldDepositFunc(NumFound, bFoundInSetList, bInSetsNoDeposit) then
			PickupInventoryItem(InvSlot);
			LushGearSwap_DepositCursorItem( BagTable );
		end
	end
end

function LushGearSwap_WithdrawCurrentSetFromBank()
	for bag = -1, NUM_BAG_SLOTS+NUM_BANKBAGSLOTS do
		if (bag == -1 or bag >= NUM_BAG_SLOTS+1) then
			for slot = 1, GetContainerNumSlots(bag) do
				local name = GetContainerItemLink(bag, slot);
				if name then
					local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(name);
					if itemName then

						local itemArray = GetEquipmentSetItemIDs(LushGearSwapFrame.CurrentSet);

						-- Withdraw the item.
						for i=1, 19 do
							if (itemArray[i]) then
								local gitemName, _, _, _, _, _, _, _, _, _ = GetItemInfo(itemArray[i]);
								if gitemName == itemName then
									UseContainerItem(bag, slot);
								end
							end
						end
					end
				end
			end
		end
	end
end

function LushGearSwap_DisplayOptions()
	LushGear_Options_Show();
end

-- Overload the UseEquipmentSet to do my setting changes.
function LushGearSwapFrame.EQUIPMENT_SWAP_FINISHED(self, event, ...)
	local didSwap, setName = select(1, ...)
	
	if didSwap == false then
		return;
	end

	if (LushGearSwap_Options[setName]) then
		if (LushGearSwap_Options[setName].ShowHelm ~= nil) then
			ShowHelm(LushGearSwap_Options[setName].ShowHelm);
		end
	
		if (LushGearSwap_Options[setName].ShowCloak ~= nil) then
			ShowCloak(LushGearSwap_Options[setName].ShowCloak);
		end
	end
end

-- /script if LushGearSwap_AmIOnQuest("The Valiant's Challenge") then print("yes"); else print("no"); end
function LushGearSwap_AmIOnQuest(QuestNameOrID)
	if (QuestNameOrID == 1) then
		return true;
	end

	local int HeaderIndex = -1;
	local QuestIndex = 0;
	while 1 do
		QuestIndex = QuestIndex + 1;
		local questTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(QuestIndex);

		if not questTitle then
			break;
		end

		if isHeader then
			if HeaderIndex > 0 then
				CollapseQuestHeader(HeaderIndex);
				QuestIndex = HeaderIndex + 1;
				HeaderIndex = -1;
			else
				if isCollapsed then
					HeaderIndex = QuestIndex;
					ExpandQuestHeader(HeaderIndex);
				end
			end
		else

			if (questTitle == QuestNameOrID or questID == QuestNameOrID) then
				if HeaderIndex > 0 then
					CollapseQuestHeader(HeaderIndex);
				end
				return true;
			end
		end
	end

	if HeaderIndex > 0 then
		CollapseQuestHeader(HeaderIndex);
	end
	return false
end

function LushGearSwap_OptionsUpdated()
	LushGearSwap_RebuildReleventData();
	
	LushGearSwapFrame:ZONE_CHANGED();
end

function LushGearSwap_TooltipHook(this)
	-- [[ Blizzard implemented there own tooltip for sets, now we only have to add the client set names ]] -
	local ItemName = getglobal(this:GetName() .. "TextLeft1"):GetText();
	if (ItemName) then
		local SetList = GetEquipmentSetNames(ItemName, true);
		if (SetList:len() > 0) then
			for i=2, this:NumLines() do
				local mytext = getglobal(this:GetName() .. "TextLeft" .. i);
				if (mytext) then
					local text = mytext:GetText();
					if text then
						local blizzardSetList = text:match(LGS_UISTRINGPASSER_EQUIPMENT_SETS);
						if blizzardSetList then
							mytext:SetText( EQUIPMENT_SETS:format(blizzardSetList .. ", " .. SetList) );
						end
					end
				end
			end
		end
	end
end
--ItemRefTooltip:HookScript('OnTooltipSetItem', 	LushGearSwap_TooltipHook);
--GameTooltip:HookScript('OnTooltipSetItem',	LushGearSwap_TooltipHook);