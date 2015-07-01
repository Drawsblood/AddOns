--[[

WearMe
	Library for equipping, bagging and moving equipment using a dynamic cache.

By Karl Isenberg (AnduinLothar)

Maintained by Swizstera as part of Wardrobe-AL. 

Change Log:
v3.14 
- Fix for new gear items that have more than one of the new variables in the itemstring.  
   The upgrade bonuses are stored here I believe.  Added logic to handle up to 6 of them.
v3.13 
- Fix itemLinks parsing for new gear in 6.0.2.  
- Fix equipping of dual weapons.
v3.12
- Fix optional 13th itemLink position variable
v3.11
- Add new 12th itemLink positional variable
v3.10
- Fix for caged battlepets in bags causing nil
v3.9
- Add local _ declaration since it is used in other places/addons.
v3.8
- Updated ITEM_UNIQUE_IDS_FROM_LINK for 11th link item introduced in Wow 5.0
- Capture reforgeId and new item after it in itemLink by replacing the linkLevel with 0. 
v3.7
- Fine tune WARRIOR Titan's Grip detection
- Fix equiping of items with no itemString (from equipment manager)
v3.6
- Fix nill on WARRIOR Titan's Grip when another class is loaded.
v3.5
- Fix for Warriors Titan's Grip so it is detected properly.
v3.4
- Fixes when Cataclysm 4.0.1 broke the caching mechanism. 
v3.3
- Allow equiping of lances if 2H was being dual wielded.
v3.2
- Fix so it unequips the offhand if you try to equip a staff even if you can equip 2H weapons in both hands.  Staffs aren't included in that.
v3.1
- Fix bug swiching from two weapons to one 2H weapon when secondary slot is specified but empty.
v3.0
- Fix dual wield with identical weapons.
v2.9
- Use LibBabble-Inventory for inventory translations
- Add better support for Unique-Equipped items as well as gems.
v2.8
- Fix bug in itemsplit hook
v2.7
- Fixes to weapons, trinkets, and ring swapping
v2.6
- Fix to work with dual wield 2H weapons
v2.5
- Use locale strings for bagtypes
v2.4
- First swap any unique-equipped items with an item that doesn't have any unique-equipped gems before swapping the rest.
- Change "Bag" references to INVTYPE_BAG
v2.3
- Cleaned up use of VerifyCache() to try to eliminate unnecessary load on cpu
- Items with Unique-Equipped gems or prismatic gems are swapped first.
v2.2
- Maintained as embedded lib of Wardrobe addon
- Update to work with WotLK 3.0.2
- Add new function GetItemInfoFromLink
- Fix verify caching code
- Remove linker level from itemString
v2.1
- Fixed some swap bugs
v2.0.1
- Updated ITEM_UNIQUE_IDS_FROM_LINK to catch negatives in the last two item numbers
v2.0
- Completely rewrote the cursor, inventory and bag/bank caching to work with the required after hooks and to use GetCursorInfo()
- No Longer Requires SeaHooks
v1.9
- No longer taints PickupContainerItem or PickupInventoryItem
- Cache no longer breaks if non-weapons are erroniously swapped in combat
v1.8
- Now handles socketed items with '-' int he suffix itemid
v1.7
- Updated number of cached containers from 20 to 11
- TOC to 20003
v1.6
- Changed Backpack (0) and Bank (-1) to be of type "Bag"
- Keyring (-2) is now of type "Key"
v1.5
- Updated for SeaHooks v0.9
v1.4
- Increased number of bank bags to match 2.0
v1.3
- Updated for Lua 5.1
- Updated SeaHooks calls
v1.2
- Unequip now correctly clears the cursor when failing
- Added GetBagItemQuantity and GetBankItemQuantity
- Bagging functions now recognize the backpack who's subtype is "Miscellaneous"
- Added a SplitContainerItem hook for more thurough caching
v1.1
- Added BankCursorItem
- Added FindItem (inv/container/bank)
- Added ItemCanGoInBag (using stored itemIDs from Tekkub's PeriodicTable)
- Added GetItemIDFromItemString
- Added GetBagSubType (cached)
- Bank cache now updates on PLAYERBANKSLOTS_CHANGED
- Cursor Item cache now stores the correct bag slot
- FindXXXItem functions now fall back on name. FindXXXItemByID functions now do what the old versions did.
- BagCursorItem, BankCursorItem and ReBagContainerItem now take into account special bag types
- Recoded the Outfit code to only require a single pass for finding the items, storing the bag/slot information for use in WearOutfit.  This fixes a bug with equipping duplicate items in the same outfit.
v1.0
- Initial Release

	$Id: WearMe.lua 3705 2006-06-26 08:15:29Z karlkfi $
	$Rev: 3705 $
	$LastChangedBy: karlkfi $
	$Date: 2006-06-26 03:15:29 -0500 (Mon, 26 Jun 2006) $

--]]

local WEARME_NAME 			= "WearMe"
local WEARME_VERSION 		= 3.14
local WEARME_LAST_UPDATED	= "Oct 24, 2014"
local WEARME_AUTHOR 		= "AnduinLothar"
local WEARME_EMAIL			= "karlkfi@cosmosui.org"
local WEARME_WEBSITE		= "http://www.wowwiki.com/WearMe"

------------------------------------------------------------------------------
--[[ Embedded Sub-Library Load Algorithm ]]--
------------------------------------------------------------------------------
local lastVersionLoaded;
if (not WearMe) then
	WearMe = {};
	lastVersionLoaded = false;
else
	lastVersionLoaded = WearMe.version
end
local isBetterInstanceLoaded = ( WearMe.version and WearMe.version >= WEARME_VERSION );

local _;

if (not isBetterInstanceLoaded) then

	local L = LibStub("AceLocale-3.0"):GetLocale("WearMe")

	local BI = LibStub("LibBabble-Inventory-3.0"):GetUnstrictLookupTable()

	WearMe.version = WEARME_VERSION;

	------------------------------------------------------------------------------
	--[[ Globals ]]--
	------------------------------------------------------------------------------

	WearMe.DEBUG = false;


	local GT = LibStub:GetLibrary("LibGratuity-3.0")


	--GetContainerItemLink item name strfind syntax
	WearMe.ITEM_NAME_FROM_LINK = "|h%[(.-)%]|h";
	WearMe.ITEM_ID_FROM_STRING = "item:(%d-)";

  WearMe.ITEM_UNIQUE_IDS_FROM_LINK = "|H(item:(-?%d+):(-?%d+):(-?%d+):(-?%d+):(-?%d+):(-?%d+):(-?%d+):(-?%d+):(-?%d+):(-?%d+)):(-?%d+):(-?%d+):?(-?%d*):?(-?%d*):?(-?%d*):?(-?%d*):?(-?%d*):?(-?%d*):?(-?%d*)|h%[([^%]]*)%]|h"

	WearMe.DuelInventorySlots = {
		[11] = 12;
		[12] = 11;
		[13] = 14;
		[14] = 13;
		[16] = 17;
		[17] = 16;
	};

	WearMe.DuelInventoryLocations = {
		["INVTYPE_FINGER"] = 11;
		["INVTYPE_TRINKET"] = 13;
		["INVTYPE_WEAPON"] = 16;
	};

	WearMe.BankBags = { -1, 5, 6, 7, 8, 9, 10, 11 };

	WearMe.Containers = {
		[-5] = {};
		[-4] = {};
		[-3] = {};
		[KEYRING_CONTAINER] = {};
		[BANK_CONTAINER] = {};
		[BACKPACK_CONTAINER] = {};
		[1] = {};
		[2] = {};
		[3] = {};
		[4] = {};
		[5] = {};
		[6] = {};
		[7] = {};
		[8] = {};
		[9] = {};
		[10] = {};
		[11] = {};
	};

	WearMe.Inventory = {};
	
	WearMe.CursorItem = {};

	WearMe.InventoryContainers = {};
	for i=1, 11 do
		WearMe.InventoryContainers[ContainerIDToInventoryID(i)] = i;
	end

	WearMe.DualWield2H_Ignore = {
					  		       [BI["Staff"]] = true,
								   [BI["Staves"]] = true,
								   [BI["Fishing Poles"]] = true,
								   [BI["Fishing Pole"]] = true,
								   [BI["Polearm"]] = true,
								   [BI["Polearms"]] = true,
								   [BI["Miscellaneous"]] = true,
							    };

	WearMe.LanceWeapons = {[46069]=true,
	                       [46070]=true,
	                       [46106]=true,
					      }

    WearMe.DualWield2HTalents = nil;
    
--code to use to look at talent tree to find the tab,index of a talent
--using to find Titan's Grip, if I have it, set the tab and index for it.
--[[
	for t=1, GetNumTalentTabs() do
		for i=1, GetNumTalents(t) do
			local nameTalent, icon, tier, column, currRank, maxRank = GetTalentInfo(t,i);
--			DEFAULT_CHAT_FRAME:AddMessage("- "..nameTalent..": "..currRank.."/"..maxRank);
			if(nameTalent == "Titan's Grip") then
--				DEFAULT_CHAT_FRAME:AddMessage("WearMe: Found Titan's Grip at tab "..t..": index "..i);
				WearMe.DualWield2HTalents = {
									["WARRIOR"] =
										{{name="Titan's Grip",tab=t,index=i},}

								};
			end
		end
	end
]]--

	WearMe.MoveQueue = {};

	--[[ Inventory Slot Key:
	0 = ammo
	1 = head
	2 = neck
	3 = shoulder
	4 = shirt
	5 = chest
	6 = belt
	7 = legs
	8 = feet
	9 = wrist
	10 = gloves
	11 = finger 1
	12 = finger 2
	13 = trinket 1
	14 = trinket 2
	15 = back
	16 = main hand
	17 = off hand
	18 = ranged
	19 = tabard
	]]--

	-- Tables taken from PeriodicTable by Tekkub
	-- Keys are from the GetItemInfo itemSubType return value as seen: http://www.wowwiki.com/ItemType
	-- For normal bags the sub type is simply "Bag"
	WearMe.SpecialBags = {
		["Enchanting Bag"] = "20725 11083 16204 11137 11176 10940 11174 10938 11135 11175 16202 11134 16203 10998 11082 10939 11084 14343 11139 10978 11177 14344 11138 11178";
		["Herb Bag"] = "3358 8839 13466 4625 13467 3821 785 13465 13468 2450 2452 3818 3355 3357 8838 3369 3820 8153 8836 13463 8845 8846 13464 2447 2449 765 2453 3819 3356 8831";
		["Soul Bag"] = "6265";
		["Ammo Pouch"] = "2516 2519 3033 3465 4960 5568 8067 8068 8069 10512 10513 11284 11630 13377 15997 19317";
		["Quiver"] = "2512 2515 3030 3464 9399 11285 12654 18042 19316";
	};

	--WearMe.UniqueEquipGems = { 2891, 2912, 2913, 2914, 2916, 2945, 2946, 3103, 3208, 3210, 3211, 3212, 3217, 3220, 3221, 3268};

	WearMe.BagSubTypes = {};

	function WearMe.Print(...)
		local text = "";
		for i=1, select("#", ...) do
			text = text..(select(i, ...) or "(nil)")
		end
		DEFAULT_CHAT_FRAME:AddMessage(text)
	end


	------------------------------------------------------------------------------
	--[[ Inventory Bag Item ID to Container ID Conversion ]]--
	------------------------------------------------------------------------------

	function WearMe.InventoryIDToContainerID(invSlot)
		-- Only works for bags (20-23, 64-70)
		if (invSlot) then
			return WearMe.InventoryContainers[invSlot];
		end
	end

	------------------------------------------------------------------------------
	--[[ Get Funcs ]]--
	------------------------------------------------------------------------------

	-- local itemString, itemID, enchant, suffix, bonus, name, bag, slot = WearMe.GetCursorItemInfo();
--[[
	function WearMe.GetCursorItemInfo()
		local item = WearMe.CursorItem;
		if (not item) then
			return;
		end
		return item.itemString, item.itemID, item.enchant, item.suffix, item.bonus, item.name, item.bag, (item.bagSlot or item.invSlot);
	end
]]--
	function WearMe.GetInventoryItemName(invSlot, forceCache)
		local item = WearMe.Inventory[invSlot];
		if (not forceCache and item and item.cached and item.name) then
			return item.name;
		else
			local linktext = GetInventoryItemLink("player", invSlot);
			if (linktext) then
				local _, _, itemName = strfind(linktext, WearMe.ITEM_NAME_FROM_LINK);
				WearMe.CacheInventoryItemName(invSlot, itemName);
				return itemName;
			end
		end
	end

  function WearMe.ItemUniqueIdsFromLink(linktext)
        local _, _, itemString, itemID, permEnchant, jewelId1, jewelId2, jewelId3, jewelId4, suffix, uniqueId, linkLevel, reforgeId, _, _, variableData, variableData1, variableData2, variableData3, variableData4, variableData5, variableData6, itemName = strfind(linktext, WearMe.ITEM_UNIQUE_IDS_FROM_LINK);
        WearMe.Debug("WearMe.ItemUniqueIdsFromLink() Parsing",linktext," ==> ", gsub(linktext, "\124", "\124\124"));
        if (itemName == nil) then
          if (variableData6 ~= nil) then
            itemName = variableData6;
          elseif (variableData5 ~= nil) then
            itemName = variableData5;
          elseif (variableData4 ~= nil) then
            itemName = variableData4;
          elseif (variableData3 ~= nil) then
            itemName = variableData3;
          elseif (variableData2 ~= nil) then
            itemName = variableData2;
          elseif (variableData1 ~= nil) then
            itemName = variableData1;
          elseif (variableData ~= nil) then
            itemName = variableData;
          else 
            -- use fallback method to get name if none of the above work
              _, _, itemName = strfind(linktext, WearMe.ITEM_NAME_FROM_LINK);
          end
        end
        WearMe.Debug("WearMe.ItemUniqueIdsFromLink() Result: itemString=",itemString,"; itemID=",itemID,"; permEnchant=",permEnchant,"; jewelId1=",jewelId1,"jewelId2=",jewelId2,"jewelId3=",jewelId3,"; jewelId4=",jewelId4,"; suffix=",suffix,"; uniqueId=",uniqueId,"; linkLevel=",linkLevel,"; reforgeId=",reforgeId,"; variableData=",variableData,"; itemName=",itemName);
        return _, _, itemString, itemID, permEnchant, jewelId1, jewelId2, jewelId3, jewelId4, suffix, uniqueId, linkLevel, reforgeId, _, itemName;
  end

	function WearMe.GetItemInfoFromLink(linktext)
		if not linktext then return nil end;

--		WearMe.Debug("WearMe.GetItemInfoFromLink() linktext = ",gsub(linktext, "\124", "\124\124"));

		local itemInfo =
			  {
				  itemString,
				  itemId,
				  permEnchant,
				  suffix,
--				  extraItemInfo,
				  uniqueId,
				  linkLevel,
				  reforgeId,					  
				  itemName,
				  itemEquipLoc,
				  jewelId = {},
				  reforgeId,
				  hasUniqueEquipped = false
			  }
		local _, _, itemString, itemID, permEnchant, jewelId1, jewelId2, jewelId3, jewelId4, suffix, uniqueId, linkLevel, reforgeId, _, _, itemName = WearMe.ItemUniqueIdsFromLink(linktext);
		if not itemString then return nil end;
		local _, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(itemID);

		itemInfo.itemString = WearMe.replaceLevelInItemString(itemString);
		itemInfo.itemID = tonumber(itemID);
		itemInfo.permEnchant = tonumber(permEnchant);
		itemInfo.suffix = tonumber(suffix);
		itemInfo.uniqueId = tonumber(uniqueId);
		itemInfo.linkLevel = tonumber(linkLevel);
		itemInfo.reforgeId = tonumber(reforgeId);
--		itemInfo.extraItemInfo = tonumber(extraItemInfo);
		itemInfo.itemName = itemName;
		itemInfo.itemEquipLoc = itemEquipLoc;
		itemInfo.jewelId[1] = tonumber(jewelId1);
		itemInfo.jewelId[2] = tonumber(jewelId2);
		itemInfo.jewelId[3] = tonumber(jewelId3);
		itemInfo.jewelId[4] = tonumber(jewelId4);

		-- first see if the item itself is unique equippable only
		GT:SetHyperlink(linktext);
--		WearMe.Debug("WearMe: Searching for ", ITEM_UNIQUE_EQUIPPABLE, " tag in tooltip of ", linktext);
		for i = 1, GT:NumLines() do
			local tooltipLine = GT:GetLine(i);
--			WearMe.Debug(tooltipLine);
			if tooltipLine then
				if(tooltipLine == ITEM_UNIQUE_EQUIPPABLE) then
					itemInfo.hasUniqueEquipped = true;
					break;
				end
			end
		end
		if (itemInfo.hasUniqueEquipped) then
			WearMe.Debug("WearMe: Found ", ITEM_UNIQUE_EQUIPPABLE, " tag in tooltip of ", linktext," - marking as hasUniqueEquipped = true");
			-- if I find this, then I don't really care if any unique-eqipped gems are there too because this will get removed first anyways.
			itemInfo.hasUniqueEquipped = true;
		else

			-- check if this item has gems, and if so, see if any are unique-equipped
			for i=1, 4 do
				if(itemInfo.jewelId[i] and (itemInfo.jewelId[i] ~= 0)) then
					local gemName, gemLink = GetItemGem(linktext,i);
					if(gemLink) then
						--check if prismatic gem
						local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(gemLink);
--						WearMe.Debug("WearMe: Gem"..i," = ",gemLink, "itemInfo=", itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture);

						--check for unique-equipped tag
						GT:SetHyperlink(gemLink);

						local loc = GT:FindDeformat(ITEM_LIMIT_CATEGORY_MULTIPLE);
--						WearMe.Debug("WearMe: tooltipLine=",tooltipLine,"Searching for=",ITEM_LIMIT_CATEGORY_MULTIPLE,"loc=",loc);
	--					if(loc and loc == "Prismatic Gems") then  --need to make this locale friendly.
	--I shouldn't need to search for "prismatic gems", if I see the CATEGORY MULTIPLE tag, that should be enough
						if(loc) then
							itemInfo.hasUniqueEquipped = true;
						else
							for j = 1, GT:NumLines() do
								local tooltipLine = GT:GetLine(j);
								if tooltipLine then
									if(tooltipLine == ITEM_UNIQUE_EQUIPPABLE) then
										itemInfo.hasUniqueEquipped = true;
										break;
									end
								end
							end
						end
						WearMe.Debug("WearMe: Gem"..i," = ",gemName,gemLink," itemInfo.hasUniqueEquipped=", itemInfo.hasUniqueEquipped);
					end
				end
			end
		end


		return itemInfo;
	end

	function WearMe.replaceLevelInItemString(itemString)
		local newItemString = "item";
		local cnt = 1;
		for word in string.gmatch(itemString, "(-?%d+)") do
			if (cnt == 9) then
				newItemString = newItemString .. ":0"
			else 
				newItemString = newItemString .. ":" .. word
			end
			cnt = cnt + 1; 
		end
--		WearMe.Debug("WearMe.replaceLevelInItemString() itemString = ", itemString, " ; newItemString = ", newItemString); 	
		return newItemString;
	end
	
	function WearMe.GetInventoryItemInfo(invSlot, forceCache)
		local item = WearMe.Inventory[invSlot];
--    WearMe.Debug("WearMe.GetInventoryItemInfo() Item=",item,"; forceCache=", forceCache); --, "; item.cached=", item.cached, "; item.itemID=", item.itemID);
		if (not forceCache and item and item.cached and item.itemID) then
--      WearMe.Debug("WearMe.GetInventoryItemInfo() returning cached stuff:", "; item.itemString=",item.itemString, "; item.itemID=", item.itemID, "; item.enchant=",item.enchant, "; item.suffix=",item.suffix, "; item.reforgeId=", item.reforgeId, "; item.name=", item.name, "; item.itemLink=", item.itemLink);
			return item.itemString, item.itemID, item.enchant, item.suffix, item.reforgeId, item.name, item.itemLink;
		else
			local linktext = GetInventoryItemLink("player", invSlot);
			if (linktext) then
				
				local _, _, itemString, itemID, permEnchant, jewelId1, jewelId2, jewelId3, jewelId4, suffix, uniqueId, linkLevel, reforgeId, _, itemName = WearMe.ItemUniqueIdsFromLink(linktext);
				
				if itemString then
					itemString = WearMe.replaceLevelInItemString(itemString);
					itemID = tonumber(itemID);
					permEnchant = tonumber(permEnchant);
					suffix = tonumber(suffix);
					reforgeId = tonumber(reforgeId);
					WearMe.CacheInventoryItem(invSlot, itemString, itemID, permEnchant, suffix, reforgeId, itemName, linktext);
					return itemString, itemID, permEnchant, suffix, reforgeId, itemName, linktext;
				end
			end
		end
	end

	function WearMe.GetContainerItemName(bag, slot, forceCache)
		local item = WearMe.Containers[bag]
		if (item) then
			item = item[slot];
		end
		if (not forceCache and item and item.cached and item.name) then
			return item.name;
		else
			local linktext = GetContainerItemLink(bag, slot);
			if (linktext) then
				local _, _, itemName = strfind(linktext, WearMe.ITEM_NAME_FROM_LINK);
				WearMe.CacheContainerItemName(bag, slot, itemName);
				return itemName;
			end
		end
	end

	function WearMe.GetContainerItemInfo(bag, slot, forceCache)
--		WearMe.Debug("WearMe.GetContainerItemInfo() bag=",bag,"slot=",slot,"forceCache=",forceCache);

		local item = WearMe.Containers[bag]
		if (item) then
			item = item[slot];
		end
		if (not forceCache and item and item.cached and item.itemID) then
			return item.itemString, item.itemID, item.enchant, item.suffix, item.reforgeId, item.name, item.itemLink;
		else
			local linktext = GetContainerItemLink(bag, slot);

--			WearMe.Debug("WearMe.GetContainerItemInfo() linktext=",linktext);

			if (linktext) then

--				WearMe.Debug("WearMe.GetContainerItemInfo() linktext=",linktext,"debugLinkText=",gsub(linktext, "\124", "\124\124"));

				local _, _, itemString, itemID, permEnchant, jewelId1, jewelId2, jewelId3, jewelId4, suffix, uniqueId, linkLevel, reforgeId, _, itemName = WearMe.ItemUniqueIdsFromLink(linktext);
				if itemString then
					itemString = WearMe.replaceLevelInItemString(itemString);
					itemID = tonumber(itemID);
					permEnchant = tonumber(permEnchant);
					suffix = tonumber(suffix);
					reforgeId = tonumber(reforgeId);
					WearMe.CacheContainerItem(bag, slot, itemString, itemID, permEnchant, suffix, reforgeId, itemName, linktext);
					return itemString, itemID, permEnchant, suffix, reforgeId, itemName, linktext;
				end
			end
		end
	end

	function WearMe.GetBagSubType(bag)
		if (not WearMe.BagSubTypes or not WearMe.BagSubTypes.cached) then
			WearMe.CacheBagSubTypes();
		end
		return WearMe.BagSubTypes[bag];
	end

	function WearMe.GetItemIDFromItemString(itemString)
		local _, _, itemID = strfind(itemString, WearMe.ITEM_ID_FROM_STRING);
		if (itemID) then
			return itemID;
		end
	end

	------------------------------------------------------------------------------
	--[[ Cache Verification ]]--
	------------------------------------------------------------------------------

	function WearMe.VerifyCache()
		WearMe.Debug("WearMe.VerifyCache() called.");
		--recache bag subtypes
		WearMe.CacheBagSubTypes();

		--check all containers
		for bag, bagContents in ipairs(WearMe.Containers) do

		    --make sure number of slots in container still matches what's really there.
		    local bagSlots = GetContainerNumSlots(bag);

--		    WearMe.Debug("WearMe.VerifyCache: checking bag",bag,"bagSlots",bagSlots);


		    if (bagSlots ~= #(bagContents)) then
				WearMe.ClearContainerCache(bag)
			else

				if(bagContents) then
					for slot, slotContents in ipairs(bagContents) do
						local linktext = GetContainerItemLink(bag, slot);

--						WearMe.Debug("WearMe.VerifyCache: bag",bag,"slot",slot,"contains",linktext);

						if (linktext) then
							local _, _, itemString, itemID, permEnchant, jewelId1, jewelId2, jewelId3, jewelId4, suffix, uniqueId, linkLevel, reforgeId, _, itemName = WearMe.ItemUniqueIdsFromLink(linktext);
							if itemString then
								itemString = WearMe.replaceLevelInItemString(itemString);
								itemID = tonumber(itemID);
								permEnchant = tonumber(permEnchant);
								suffix = tonumber(suffix);
								reforgeId = tonumber(reforgeId);
	
--								WearMe.Debug("WearMe.VerifyCache: bag",bag,"slot",slot,"cached (",slotContents.cached,") item is",slotContents.name);
	
								-- check against cached value
--								if (slotContents.cached and (itemString ~= slotContents.itemString or itemID ~= slotContents.itemID or permEnchant ~= slotContents.enchant or suffix ~= slotContents.suffix or reforgeId ~= slotContents.reforgeId or itemName ~= slotContents.name)) then
								if (itemString ~= slotContents.itemString or itemID ~= slotContents.itemID or permEnchant ~= slotContents.enchant or suffix ~= slotContents.suffix or reforgeId ~= slotContents.reforgeId or itemName ~= slotContents.name) then
--									WearMe.Debug("WearMe.VerifyCache: Container Cache Mismatch, bag: ", bag, " slot: ", slot, " Cached Item: ", slotContents.name, " Actual Item:", itemName)
									-- update cache
									WearMe.CacheContainerItem(bag, slot, itemString, itemID, permEnchant, suffix, reforgeId, itemName);
								end
							else
								--if not link here, clear it from the cache
								WearMe.ClearBagCacheItem(bag,slot);
							end
						else
							--if not link here, clear it from the cache
							WearMe.ClearBagCacheItem(bag,slot);
						end
					end
				end
			end
		end

		WearMe.VerifyInventoryCache();

	end

	function WearMe.VerifyInventoryCache()

		--check character inventory
		for slot, slotContents in ipairs(WearMe.Inventory) do
			local linktext = GetInventoryItemLink("player", slot);

--			WearMe.Debug("WearMe.VerifyCache: Inventory item slot",slot,"contains",linktext);

			if (linktext) then
				local _, _, itemString, itemID, permEnchant, jewelId1, jewelId2, jewelId3, jewelId4, suffix, uniqueId, linkLevel, reforgeId, _, itemName = WearMe.ItemUniqueIdsFromLink(linktext);
				if itemString then
					itemString = WearMe.replaceLevelInItemString(itemString);
					itemID = tonumber(itemID);
					permEnchant = tonumber(permEnchant);
					suffix = tonumber(suffix);
					reforgeId = tonumber(reforgeId);
	
					-- check against cached value
					if (slotContents.cached and (itemString ~= slotContents.itemString or itemID ~= slotContents.itemID or permEnchant ~= slotContents.enchant or suffix ~= slotContents.suffix or reforgeId ~= slotContents.reforgeId or itemName ~= slotContents.name)) then
--						WearMe.Debug("WearMe.VerifyCache: Inventory Cache Mismatch, slot: ", slot, " Cached Item: ", slotContents.name, " Actual Item:", itemName)
						-- update cache
						WearMe.CacheInventoryItem(slot, itemString, itemID, permEnchant, suffix, reforgeId, itemName, linktext);
					end
				else
					--clear cache for this item if no item returned
					WearMe.ClearInventoryCacheItem(slot);
				end
			else
				--clear cache for this item if no item returned
				WearMe.ClearInventoryCacheItem(slot);
			end
		end
	end

	------------------------------------------------------------------------------
	--[[ Special Bag ]]--
	------------------------------------------------------------------------------

	-- Doesn't take into acount space, only bag type
	function WearMe.ItemCanGoInBag(itemID, bag)
		local bagType = WearMe.GetBagSubType(bag);
		if (not bagType) then
			return false;
		end
		if (bagType == L["Bag"] or bagType == BI["Bag"] or bagType == BI["Container"] ) then
			return true;
		end
		local bagItems = WearMe.SpecialBags[bagType];
		if (type(bagItems) == "string") then
			local tabledBagItems = {};
			-- Using string.find instead of string.gfind/gmatch to avoid garbage generation
			local mstart, mend, value = strfind(bagItems, " ");
		   	while (value) do
				tabledBagItems[value] = true;
				mstart = mend + 1;
				mstart, mend, value = strfind(bagItems, " ", mstart);
		   	end
		   	WearMe.SpecialBags[bagType] = tabledBagItems;
			bagItems = WearMe.SpecialBags[bagType];
		elseif (type(bagItems) ~= "table") then
			return false;
		end

		if (type(itemID) == "string") then
			itemID = WearMe.GetItemIDFromItemString(itemID)
		end
		return (bagItems[itemID] or false);
	end


	------------------------------------------------------------------------------
	--[[ Find By Name ]]--
	------------------------------------------------------------------------------

	function WearMe.FindInventoryItemByName(targetItemName, startSlot)
		-- Find the named item on the character's inventory (head slot, hand slot, etc -- not bags)
		if (not startSlot) then
			startSlot = 0;
		end

		for i = startSlot, 19 do
			if (targetItemName == WearMe.GetInventoryItemName(i)) then
				return i;
			end
		end
	end

	function WearMe.FindBagByName(targetBagName)
		-- For finding the bag item name, not the slot name
		-- Returns an Inventory ID, use InventoryIDToContainerID if you need the Container ID
		for i = 20, 23 do
			if (targetBagName == WearMe.GetInventoryItemName(i)) then
				return i;
			end
		end
	end

	function WearMe.FindBankBagByName(targetBagName)
		-- For finding the bag item name, not the slot name
		-- Only usable at the bank
		-- Returns an Inventory ID, use InventoryIDToContainerID if you need the Container ID
		for i = 64, 70 do
			if (targetBagName == WearMe.GetInventoryItemName(i)) then
				return i;
			end
		end
	end

	function WearMe.FindContainerItemByName(targetItemName, startBag, startSlot)
		if (not startBag) then
			startBag = 0;
		end

		if (not startSlot) then
			startSlot = 1;
		end

		for bag = startBag, 4 do
			for slot = startSlot, GetContainerNumSlots(bag) do
				if (targetItemName == WearMe.GetContainerItemName(bag, slot)) then
					return bag, slot;
				end
			end
			startSlot = 1;
		end
	end

	function WearMe.FindKeyByName(targetItemName)
		local bag = -2;
		for slot = 1, GetContainerNumSlots(bag) do
			if (targetItemName == WearMe.GetContainerItemName(bag, slot)) then
				return bag, slot;
			end
		end
	end

	function WearMe.FindBankItemByName(targetItemName, startBag, startSlot)
		-- Only usable at the bank
		if (startBag or startSlot) then
			for i, bag in ipairs(WearMe.BankBags) do
				if (startBag and startBag == bag) then
					startBag = nil;
				end
				if (not startBag) then
					for slot = (startSlot or 1), GetContainerNumSlots(bag) do
						if (targetItemName == WearMe.GetContainerItemName(bag, slot)) then
							return bag, slot;
						end
					end
					startSlot = 1;
				end
			end
		else
			for i, bag in ipairs(WearMe.BankBags) do
				for slot = 1, GetContainerNumSlots(bag) do
					if (targetItemName == WearMe.GetContainerItemName(bag, slot)) then
						return bag, slot;
					end
				end
			end
		end
	end


	------------------------------------------------------------------------------
	--[[ Find By ID ]]--
	-- itemID can be an itemID or "itemString" (ex: 12345 or "item:12345:0:0:0")
	------------------------------------------------------------------------------

	-- Find the named item on the character's inventory (head slot, hand slot, etc -- not bags)
	function WearMe.FindInventoryItemByID(targetItemID, startSlot)
		local itemString, itemID, permEnchant, suffix, reforgeId;
		if (not startSlot) then
			startSlot = 0;
		end

		for i = startSlot, 19 do
			itemString, itemID = WearMe.GetInventoryItemInfo(i);
			if (targetItemID == itemString or targetItemID == itemID) then
				return i;
			end
		end
	end

	function WearMe.FindBagByID(targetItemID)
		-- For finding the bag item name, not the slot name
		-- Returns an Inventory ID, use InventoryIDToContainerID if you need the Container ID
		local itemString, itemID, permEnchant, suffix, reforgeId;
		for i = 20, 23 do
			itemString, itemID = WearMe.GetInventoryItemInfo(i);
			if (targetItemID == itemString or targetItemID == itemID) then
				return i;
			end
		end
	end

	function WearMe.FindBankBagByID(targetItemID)
		-- For finding the bag item name, not the slot name
		-- Only usable at the bank
		-- Returns an Inventory ID, use InventoryIDToContainerID if you need the Container ID
		local itemString, itemID, permEnchant, suffix, reforgeId;
		for i = 64, 70 do
			itemString, itemID, permEnchant, suffix, reforgeId = WearMe.GetInventoryItemInfo(i);
			if (targetItemID == itemString or targetItemID == itemID) then
				return i;
			end
		end
	end

	function WearMe.FindContainerItemByID(targetItemID, startBag, startSlot)
		local itemString, itemID, permEnchant, suffix, reforgeId;
		if (not startBag) then
			startBag = 0;
		end

		if (not startSlot) then
			startSlot = 1;
		end

		for bag = startBag, 4 do
			for slot = startSlot, GetContainerNumSlots(bag) do
				itemString, itemID, permEnchant, suffix, reforgeId = WearMe.GetContainerItemInfo(bag, slot);
				if (targetItemID == itemString or targetItemID == itemID) then
					return bag, slot;
				end
			end
			startSlot = 1;
		end
	end

	function WearMe.FindKeyByID(targetItemID)
		local itemString, itemID, permEnchant, suffix, reforgeId;
		local bag = -2;
		for slot = 1, GetContainerNumSlots(bag) do
			itemString, itemID, permEnchant, suffix, reforgeId = WearMe.GetContainerItemInfo(bag, slot);
			if (targetItemID == itemString or targetItemID == itemID) then
				return bag, slot;
			end
		end
	end

	function WearMe.FindBankItemByID(targetItemID, startBag, startSlot)
		-- Only usable at the bank
		local itemString, itemID, permEnchant, suffix, reforgeId;
		if (startBag or startSlot) then
			for i, bag in ipairs(WearMe.BankBags) do
				if (startBag and startBag == bag) then
					startBag = nil;
				end
				if (not startBag) then
					for slot = (startSlot or 1), GetContainerNumSlots(bag) do
						itemString, itemID, permEnchant, suffix, reforgeId = WearMe.GetContainerItemInfo(bag, slot);
						if (targetItemID == itemString or targetItemID == itemID) then
							return bag, slot;
						end
					end
					startSlot = 1;
				end
			end
		else
			for i, bag in ipairs(WearMe.BankBags) do
				for slot = 1, GetContainerNumSlots(bag) do
					itemString, itemID, permEnchant, suffix, reforgeId = WearMe.GetContainerItemInfo(bag, slot);
					if (targetItemID == itemString or targetItemID == itemID) then
						return bag, slot;
					end
				end
			end
		end
	end


	------------------------------------------------------------------------------
	--[[ Find By ID or Name Anywhere ]]--
	------------------------------------------------------------------------------

	-- itemName is optional
	-- if (bag) then (Is  Bag/Bank Item) elseif (slot) (Is Inventroy Item) end
	function WearMe.FindItem(itemID, itemName)
		local bag, slot;
		slot = WearMe.FindInventoryItemByID(itemID);
		if (not slot) then
			bag, slot = WearMe.FindContainerItemByID(itemID);
			if (not bag) then
				bag, slot = WearMe.FindBankItemByID(itemID);
				if (not bag and itemName) then
					slot = WearMe.FindInventoryItemByName(itemName);
					if (not slot) then
						bag, slot = WearMe.FindContainerItemByName(itemName);
						if (not bag) then
							bag, slot = WearMe.FindBankItemByName(itemName)
							if (not bag) then
								return;
							end
						end
					end
				end
			end
		end
		return bag, slot;
	end

	function WearMe.FindContainerItem(itemID, itemName, startBag, startSlot)
		local bag, slot;
		bag, slot = WearMe.FindContainerItemByID(itemID, startBag, startSlot);
		if (itemName and not bag) then
			bag, slot = WearMe.FindContainerItemByName(itemName, startBag, startSlot);
		end
		return bag, slot;
	end

	function WearMe.FindBankItem(itemID, itemName, startBag, startSlot)
		local bag, slot;
		bag, slot = WearMe.FindBankItemByID(itemID, startBag, startSlot);
		if (itemName and not bag) then
			bag, slot = WearMe.FindBankItemByName(itemName, startBag, startSlot);
		end
		return bag, slot;
	end

	function WearMe.FindInventoryItem(itemID, itemName, startSlot)
		local slot;
		slot = WearMe.FindInventoryItemByID(itemID, startSlot);
		if (itemName and not slot) then
			slot = WearMe.FindInventoryItemByName(itemName, startSlot);
		end
		return slot;
	end


	------------------------------------------------------------------------------
	--[[ Find By ID or Name ]]--
	------------------------------------------------------------------------------

	-- Find the item on the character's inventory or bags
	function WearMe.PlayerHasItem(itemID, itemName, VerifyCache)
		local invSlot, bag;

		if(VerifyCache) then
			WearMe.VerifyCache();
		end

		if (itemID) then
			-- Check inventory
			invSlot = WearMe.FindInventoryItemByID(itemID);
			if (invSlot) then
				-- Item equipped
				return true;
			else
				-- Check bags
				bag = WearMe.FindContainerItemByID(itemID);
				if (bag) then
					-- Item in bag
					return true;
				end
			end
		end
		if (itemName) then
			-- Check inventory
			invSlot = WearMe.FindInventoryItemByName(itemName);
			if (invSlot) then
				-- Item equipped
				return true;
			else
				-- Check bag slots
				bag = WearMe.FindContainerItemByName(itemName);
				if (bag) then
					-- Item in bag
					return true;
				end
			end
		end
		--if I can't find it, verify the cache and try again.
		if(not VerifyCache) then
			return WearMe.PlayerHasItem(itemID, itemName, true);
		else
			return false;
		end
	end


	function WearMe.PlayerHasInventoryItem(itemID, itemName)
		local invSlot;
		if (itemID) then
			-- Check inventory
			invSlot = WearMe.FindInventoryItemByID(itemID);
			if (invSlot) then
				-- Item equipped
				return true;
			end
		end
		if (itemName) then
			-- Check inventory
			invSlot = WearMe.FindInventoryItemByName(itemName);
			if (invSlot) then
				-- Item equipped
				return true;
			end
		end
		return false;
	end


	function WearMe.PlayerHasContainerItem(itemID, itemName)
		local bag;
		if (itemID) then
			-- Check inventory
			bag = WearMe.FindContainerItemByID(itemID);
			if (bag) then
				-- Item equipped
				return true;
			end
		end
		if (itemName) then
			-- Check inventory
			bag = WearMe.FindContainerItemByName(itemName);
			if (bag) then
				-- Item equipped
				return true;
			end
		end
		return false;
	end

	---------------------------------------------------------------------------------
	-- Put the item on the cursor into a free bag slot
	---------------------------------------------------------------------------------

	--Ignores Special Bags
	function WearMe.BagCursorItem(backwards, specialBagType)

		WearMe.Debug("WearMe.BagCursorItem: CursorHasItem()=", CursorHasItem());
		WearMe.Debug("WearMe.BagCursorItem: specialBagType=", specialBagType);



		if (CursorHasItem()) then
			local bagSubType;
			local bags = {};

			if (backwards) then
				if (specialBagType) then
					for bag = NUM_BAG_FRAMES, 1, -1 do
						if (specialBagType == WearMe.GetBagSubType(bag)) then
							tinsert(bags, bag);
						end
					end
				end

--				WearMe.Debug("WearMe: BagCursorItem() NUM_BAG_FRAMES=",NUM_BAG_FRAMES);

				for bag = NUM_BAG_FRAMES, 0, -1 do
					bagSubType = WearMe.GetBagSubType(bag);

--					WearMe.Debug("WearMe: BagCursorItem() bag=", bag, "bagSubType=", bagSubType, "BI[Bag]=", BI["Bag"], "BI[Container]=", BI["Container"], "locale=",GetLocale(),"INVTYPE_BAG=",INVTYPE_BAG);

					if (bagSubType and (bagSubType == L["Bag"] or bagSubType == BI["Bag"] or bagSubType == BI["Container"])) then
	--					WearMe.Debug("WearMe: BagCursorItem() Can use bagType ",bagSubType);
						tinsert(bags, bag);
					else
--						WearMe.Debug("WearMe: BagCursorItem() Cannot use bagType ",bagSubType);
					end
				end
			else
				if (specialBagType) then
					for bag = 1, NUM_BAG_FRAMES do
						if (specialBagType == WearMe.GetBagSubType(bag)) then
							tinsert(bags, bag);
						end
					end
				end
				for bag = 0, NUM_BAG_FRAMES do
					bagSubType = WearMe.GetBagSubType(bag);
					if (bagSubType and (bagSubType == L["Bag"] or bagSubType == BI["Bag"] or bagSubType == BI["Container"])) then
						tinsert(bags, bag);
					end
				end
			end


			for i, bag in ipairs(bags) do


				for slot = (backwards and GetContainerNumSlots(bag) or 1), (backwards and 1 or GetContainerNumSlots(bag)), (backwards and -1 or 1) do

					WearMe.Debug("WearMe: BagCursorItem() Checking for empty slot in bag", bag, "slot", slot);

					if (not WearMe.ContainerSlotInUse(bag, slot)) then

						WearMe.Debug("WearMe: BagCursorItem() bag", bag, "slot", slot," NOT in use");

						PickupContainerItem(bag, slot);
						return bag, slot;
					end
				end
			end
		end
	end

	---------------------------------------------------------------------------------
	-- Put the item on the cursor into a free bank slot
	---------------------------------------------------------------------------------

	--Ignores Special Bags
	function WearMe.BankCursorItem(backwards, specialBagType)
		if (CursorHasItem()) then
			local bag, bagSubType;
			local bags = {};
			local numBags = getn(WearMe.BankBags);

			if (backwards) then
				if (specialBagType) then
					for bagIndex = numBags, 2, -1 do
						bag = WearMe.BankBags[bagIndex];
						if (specialBagType == WearMe.GetBagSubType(bag)) then
							tinsert(bags, bag);
						end
					end
				end
				for bagIndex = numBags, 1, -1 do
					bag = WearMe.BankBags[bagIndex];
					bagSubType = WearMe.GetBagSubType(bag);
					if (bagSubType and (bagSubType == L["Bag"] or bagSubType == BI["Bag"] or bagSubType == BI["Container"])) then
						tinsert(bags, bag);
					end
				end
			else
				if (specialBagType) then
					for bagIndex = 2, numBags do
						bag = WearMe.BankBags[bagIndex];
						if (specialBagType == WearMe.GetBagSubType(bag)) then
							tinsert(bags, bag);
						end
					end
				end
				for bagIndex = 1, numBags do
					bag = WearMe.BankBags[bagIndex];
					bagSubType = WearMe.GetBagSubType(bag);
					if (bagSubType and (bagSubType == L["Bag"] or bagSubType == BI["Bag"] or bagSubType == BI["Container"])) then
						tinsert(bags, bag);
					end
				end
			end

			for i, bag in ipairs(bags) do
				for slot = (backwards and GetContainerNumSlots(bag) or 1), (backwards and 1 or GetContainerNumSlots(bag)), (backwards and -1 or 1) do
					if (not WearMe.ContainerSlotInUse(bag, slot)) then
						PickupContainerItem(bag, slot);
						return bag, slot;
					end
				end
			end
		end
	end


	---------------------------------------------------------------------------------
	-- Move an item to the front most availible bag (or furthest back)
	---------------------------------------------------------------------------------

	function WearMe.ReBagContainerItem(itemBag, itemSlot, backwards, specialBagType)
		local bagSubType;
		local bags = {};

		if (backwards) then
			if (specialBagType) then
				for bag = NUM_BAG_FRAMES, itemBag+1, -1 do
					if (specialBagType == WearMe.GetBagSubType(bag)) then
						tinsert(bags, bag);
					end
				end
			end
			for bag = NUM_BAG_FRAMES, itemBag+1, -1 do
				bagSubType = WearMe.GetBagSubType(bag);
				if (bagSubType and (bagSubType == L["Bag"] or bagSubType == BI["Bag"] or bagSubType == BI["Container"])) then
					tinsert(bags, bag);
				end
			end
		else
			if (specialBagType) then
				for bag = (itemBag >= 1 and itemBag or 1), NUM_BAG_FRAMES do
					if (specialBagType == WearMe.GetBagSubType(bag)) then
						tinsert(bags, bag);
					end
				end
			end
			for bag = itemBag-1, NUM_BAG_FRAMES do
				bagSubType = WearMe.GetBagSubType(bag);
				if (bagSubType and (bagSubType == L["Bag"] or bagSubType == BI["Bag"] or bagSubType == BI["Container"])) then
					tinsert(bags, bag);
				end
			end
		end

		for i, bag in ipairs(bags) do
			for slot = (backwards and GetContainerNumSlots(bag) or 1), (backwards and 1 or GetContainerNumSlots(bag)), (backwards and -1 or 1) do
				if (not WearMe.ContainerSlotInUse(bag, slot)) then
					PickupContainerItem(itemBag, itemSlot);
					if (not CursorHasItem()) then
						return;
					end
					PickupContainerItem(bag, slot);
					return bag, slot;
				end
			end
		end
	end


	function WearMe.ReBagContainerItemByName(itemName, backwards)
		local bag, slot = WearMe.FindContainerItemByName(itemName);
		if (bag) then
			return WearMe.ReBagContainerItem(bag, slot, backwards);
		end
	end

	function WearMe.ReBagContainerItemByID(itemID, backwards)
		local bag, slot = WearMe.FindContainerItemByID(itemID);
		if (bag) then
			return WearMe.ReBagContainerItem(bag, slot, backwards);
		end
	end


	---------------------------------------------------------------------------------
	-- Equiping
	---------------------------------------------------------------------------------
	-- Event error if there's enough bag slots when equipping a 2h from 2 1h
	-- secondarySlot is ignored if it's not a 2 slotted item type
	-- Event error if you try to equip a main hand weapon to the secondarySlot

	--WearMe.CursorItem.itemString

	-- itemID can be an itemID or "itemString" (ex: 12345 or "item:12345:0:0:0")
	function WearMe.Equip(targetItemID, secondarySlot)
		-- if we're already holding something, bail
		if (CursorHasItem()) then
			return false;
		end

		local _, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(targetItemID);

		local invSlot = WearMe.DuelInventoryLocations[itemEquipLoc];
		if (invSlot) then
			local altSlot = invSlot + 1;
			-- Check if it's already equipped and possibly in an alternate spot
			local itemString, itemID = WearMe.GetInventoryItemInfo(invSlot);
			if (itemString) and (itemString == targetItemID or itemID == targetItemID) then
				if (not secondarySlot) then
					return true;
				else
					PickupInventoryItem(invSlot);
					EquipCursorItem(altSlot);
					return true;
				end
			end
			itemString, itemID = WearMe.GetInventoryItemInfo(altSlot);
			if (itemString) and (itemString == targetItemID or itemID == targetItemID) then
				if (secondarySlot) then
					return true;
				else
					PickupInventoryItem(altSlot);
					EquipCursorItem(invSlot);
					return true;
				end
			end
		end

		-- Check non-duplicate inventory slots (duplicate slots will never return possitive)
		invSlot = WearMe.FindInventoryItemByID(targetItemID);
		if (invSlot) then
			-- Item already equipped
			return true;
		else
			-- Check bag slots
			local bag, bagSlot = WearMe.FindContainerItemByID(targetItemID);
			if (not bag) then
				-- Item Name not found in inventory or bag
				return false;
			end
			local itemString = WearMe.GetContainerItemInfo(bag, bagSlot);
			PickupContainerItem(bag, bagSlot);
		end

		if (not CursorHasItem()) then
			return false;
		end

		if (secondarySlot) then
			if (itemEquipLoc == "INVTYPE_FINGER") then
				EquipCursorItem(12);
				return true;
			elseif (itemEquipLoc == "INVTYPE_TRINKET") then
				EquipCursorItem(14);
				return true;
			elseif (itemEquipLoc == "INVTYPE_WEAPON" or itemEquipLoc == "INVTYPE_SHIELD" or itemEquipLoc == "INVTYPE_WEAPONOFFHAND" or itemEquipLoc == "INVTYPE_HOLDABLE") then
				EquipCursorItem(17);
				return true;
			end
		end

		AutoEquipCursorItem();
		return true;
	end

	function WearMe.EquipByName(targetItemName, secondarySlot)
		-- if we're already holding something, bail
		if (CursorHasItem()) then
			return false;
		end

		-- Check if it's already equipped and possibly in an alternate spot
		local _, itemName;
		for invSlot, altSlot in pairs(WearMe.DuelInventorySlots) do
			itemName = WearMe.GetInventoryItemName(invSlot);
			if (itemName and itemName == targetItemName) then
				if (secondarySlot and altSlot < invSlot) or (not secondarySlot and altSlot > invSlot) then
					return true;
				else
					PickupInventoryItem(invSlot);
					EquipCursorItem(altSlot);
					return true;
				end
			end
		end

		-- Check non-duplicate inventory slots (duplicate slots have already been handled)
		local invSlot = WearMe.FindInventoryItemByName(targetItemName);
		if (invSlot) then
			-- Item already equipped
			return true;
		else
			-- Check bag slots
			local bag, bagSlot = WearMe.FindContainerItemByName(targetItemName);
			if (not bag) then
				-- Item Name not found in inventory or bag
				return false;
			end
			local _, _, locked = GetContainerItemInfo(bag, bagSlot);
			if (locked) then
				bag, bagSlot = WearMe.FindContainerItemByName(targetItemName);
				if (not bag) then
					-- Item Name was only found once in the bags, but it was locked (in transit)
					return false;
				end
			end
			PickupContainerItem(bag, bagSlot);
		end

		if (not CursorHasItem()) then
			return false;
		end

		if (secondarySlot) then
			local _, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(WearMe.CursorItem.itemString);
			if (itemEquipLoc == "INVTYPE_FINGER") then
				EquipCursorItem(12);
				return true;
			elseif (itemEquipLoc == "INVTYPE_TRINKET") then
				EquipCursorItem(14);
				return true;
			elseif (itemEquipLoc == "INVTYPE_WEAPON" or itemEquipLoc == "INVTYPE_SHIELD" or itemEquipLoc == "INVTYPE_WEAPONOFFHAND" or itemEquipLoc == "INVTYPE_HOLDABLE") then
				EquipCursorItem(17);
				return true;
			end
		end

		AutoEquipCursorItem();
		return true;
	end

	function WearMe.EquipContainerItem(fromBag, fromSlot, toSlot)
		-- if we're already holding something, bail
		if (CursorHasItem()) then
			return false;
		end
		
		if (InCombatLockdown()) then 
			local itemLink = GetContainerItemLink(fromBag, fromSlot);
			
			ChatFrame1:AddMessage("itemLink="..itemLink, 1.0, 1.0, 0.7);
			
			EquipItemByName(itemLink);
		else

			PickupContainerItem(fromBag, fromSlot);
			if (not CursorHasItem()) then
				return false;
			end

			EquipCursorItem(toSlot);
			
		end
		
		
		return true;
	end

	function WearMe.EquipInventoryItem(fromSlot, toSlot)
		WearMe.Debug("WearMe.EquipInventoryItem() fromSlot=",fromSlot," toSlot=",toSlot," CursorHasItem()=",CursorHasItem());

		-- if we're already holding something, bail
		if (CursorHasItem()) then
			return false;
		end

		-- Check if it's already equipped in the right place
		if (fromSlot == toSlot) then
			return true;
		end

		-- Equip it in the alternate slot
		local altSlot = WearMe.DuelInventorySlots[fromSlot];
		
		WearMe.Debug("WearMe.EquipInventoryItem() altSlot=",altSlot);
		
		if (altSlot and altSlot == toSlot) then
			PickupInventoryItem(fromSlot);

		WearMe.Debug("WearMe.EquipInventoryItem() CursorHasItem()=",CursorHasItem());

			if (not CursorHasItem()) then
				return false;
			end
			if (InCombatLockdown()) then 
				AutoEquipCursorItem();
			else
				EquipCursorItem(toSlot);
			end
			return true;
		end

		return false;
	end


	---------------------------------------------------------------------------------
	-- Unequiping
	---------------------------------------------------------------------------------

	function WearMe.Unequip(invSlot, backwards)
		local texture = GetInventoryItemTexture("player", invSlot);
		if (texture) then
			PickupInventoryItem(invSlot);
			if (not WearMe.BagCursorItem(backwards)) then
				ClearCursor();
				return false;
			end
		end
		return true;
	end


	---------------------------------------------------------------------------------
	-- Slot Use
	---------------------------------------------------------------------------------

	function WearMe.InventorySlotInUse(invSlot, forceCache)
		local item = WearMe.Inventory[invSlot];
		if (not forceCache and item and item.cached) then
			if (item.name) then
				return true;
			end
		else
			if (WearMe.GetInventoryItemInfo(invSlot, true)) then
				return true;
			end
		end
	end

	function WearMe.ContainerSlotInUse(bag, slot, forceCache)
		if (not WearMe.Containers[bag]) then
			WearMe.Containers[bag] = {};
		end
		local item = WearMe.Containers[bag][slot];

		if (not forceCache and item and item.cached) then
			WearMe.Debug("WearMe.ContainerSlotInUse: Found ",item.name," in bag ",bag," slot ",slot);

			if (item.name) then
				return true;
			else
				WearMe.Debug("Item Cached, but no name saved", bag, slot)
			end
		else
			if (WearMe.GetContainerItemInfo(bag, slot, true)) then
				return true;
			end
		end
	end

	---------------------------------------------------------------------------------
	-- Empty Slots
	---------------------------------------------------------------------------------

	function WearMe.GetNumEmptyContainerSlots(bag, forceCache)
		local bag, item;
		local numSlots = 0;
		for bagNum=0, NUM_BAG_FRAMES do
			bag = WearMe.Containers[bagNum];
			if (not bag) then
				WearMe.Containers[bagNum] = {};
				bag = WearMe.Containers[bagNum];
			end
			for bagSlot = 1, GetContainerNumSlots(bagNum) do
				item = bag[bagSlot];
				if (not forceCache and item and item.cached) then
					if (not item.name) then
						numSlots = numSlots + 1;
					end
				else
					if (not WearMe.GetContainerItemInfo(bagNum, bagSlot, true)) then
						numSlots = numSlots + 1;
					end
				end
			end
		end
		return numSlots;
	end

	---------------------------------------------------------------------------------
	-- Container Item Quantity
	---------------------------------------------------------------------------------

	function WearMe.GetBagItemQuantity(itemID, itemName)
		return WearMe.GetContainerItemQuantity(WearMe.FindContainerItem, itemID, itemName);
	end

	function WearMe.GetBankItemQuantity(itemID, itemName)
		return WearMe.GetContainerItemQuantity(WearMe.FindBankItem, itemID, itemName);
	end

	function WearMe.GetContainerItemQuantity(findFunc, itemID, itemName)
		if (not itemID and not itemName) then
			return;
		end
		local _, count
		local total = 0;
		local bag, slot = findFunc(itemID, itemName);
		while (bag) do
			_, count = GetContainerItemInfo(bag, slot);
			if (count) then
				total = total + count;
			end
			bag, slot = findFunc(itemID, itemName, bag, slot+1);
		end
		return total;
	end

	---------------------------------------------------------------------------------
	-- Combat Swapping Check
	---------------------------------------------------------------------------------

	function WearMe.IsChangableInCombat(invSlot)
		return (invSlot == 16 or invSlot == 17); -- or invSlot == 18  or invSlot == 0);
	end


	---------------------------------------------------------------------------------
	--[[ Optimized Outfit Swapping ]]--
	-- Only swaps what needs to be swapped.
	-- Swaps, even if it's in another slot.
	-- Moves unequipped offhands, trinkets and rings to the back most bag (if swapping in a two hand or moving an equipped item to its alternate slot).
	-- Checks for id first. If that id is not found it will check for the name. This lets you prefer items with enchants or suffixes.
	-- Allows you to specify in any order.
	-- Multiple registers for the same slot will use the most recent.
	-- Outfit is preserved until the next init, so you can WearOutfit later without reregistering.
	-- If there is not enough space in your bags or the item is not found, RegisterToEquip returns false.
	--[[
	EX:
	WearMe.InitOutfit();
	WearMe.RegisterToEquip(16, "item:18822:2646:0:0", "Obsidian Edged Blade");	-- Equip OEB w/ +25 agil (by itemString) or OEB (by name)
	WearMe.RegisterToEquip(11, 19325);		-- Equip Ring 1 by id
	WearMe.RegisterToEquip(12, 19898);		-- Equip Ring 2 by id
	WearMe.RegisterToEquip(19);				-- Unequip Tabard
	WearMe.WearOutfit();
	]]--
	---------------------------------------------------------------------------------

	WearMe.OutfitItems = {};
	for i=0, 19 do
		WearMe.OutfitItems[i] = {};
	end
	WearMe.OutfitItems.reqBagSlots = 0;


	function WearMe.InitOutfit()
		local item;
		for i=0, 19 do
			item = WearMe.OutfitItems[i];
			if (not item) then
				WearMe.OutfitItems[i] = {};
				item = WearMe.OutfitItems[i];
			end
			item.bag = nil;
			item.slot = nil;
			item.twohand = nil;
			item.itemType = nil;
			item.itemSubType = nil;
			item.specified = nil;
			item.unique_equipped = nil;
			item.link = nil;
			item.itemID = nil;
		end
		WearMe.OutfitItems.reqBagSlots = 0;
		WearMe.OutfitItems.hasUniqueEquipItem = false;

		--make sure cache is up to date since the outfit fields are set based on where these items are.
		WearMe.VerifyCache();

	end

	-- startInvSlot, startBag, startBagSlot are optional, mainly used for recursion
	-- You can provide targetItemID or targetItemName or both. Providing neither will unequip whatever's in the targetInvSlot.
	function WearMe.RegisterToEquip(targetInvSlot, targetItemID, targetItemName, startInvSlot, startBag, startBagSlot, VerifyCache)

		local item = WearMe.OutfitItems[targetInvSlot];
		local bag, slot;
		local itemString, itemID, permEnchant, suffix, reforgeId, itemName, itemLink;

--		WearMe.Print("WearMe.RegisterToEquip: NumEmptyContainerSlots=", WearMe.GetNumEmptyContainerSlots(), "reqBagSlots=", WearMe.OutfitItems.reqBagSlots);
 		WearMe.Debug("WearMe.RegisterToEquip() targetInvSlot=",targetInvSlot," targetItemID=",targetItemID," targetItemName=",targetItemName," VerifyCache=",VerifyCache);

	  	if (VerifyCache == true) then
			WearMe.VerifyCache();
		end

		--if this slot is to be empty.
		if (not targetItemID and not targetItemName) then
			-- Make sure there's enough room to unequip
			if (WearMe.InventorySlotInUse(targetInvSlot)) then
				if (WearMe.GetNumEmptyContainerSlots() <= WearMe.OutfitItems.reqBagSlots) then
					return false;
				end
				WearMe.OutfitItems.reqBagSlots = WearMe.OutfitItems.reqBagSlots + 1;
			end
			item.specified = true;
			return true;
		end

		if (targetItemID and not item.specified) then
			local invItemString, invItemID = WearMe.GetInventoryItemInfo(targetInvSlot);
			WearMe.Debug("WearMe.RegisterToEquip() invItemString=", invItemString, " invItemID=", targetItemID);
			if(invItemID == targetItemID) then
				--if this item is already equipped in the desired slot
				item.slot = targetInvSlot
				item.specified = true;
			else
				slot = WearMe.FindInventoryItemByID(targetItemID, startInvSlot);
				if (slot) then
					item.slot = slot
					item.specified = true;
				else
					bag, slot = WearMe.FindContainerItemByID(targetItemID, startBag, startBagSlot);
					if (bag) then
						item.bag = bag
						item.slot = slot
						item.specified = true;
					end
				end
			end
		end

		-- If both id and name were suplied, but the item was not found by that id, try by name
		if (targetItemName and not item.specified) then
			slot = WearMe.FindInventoryItemByName(targetItemName, startInvSlot)
			if (slot) then
				item.slot = slot
				item.specified = true;
			else
				bag, slot = WearMe.FindContainerItemByName(targetItemName, startBag, startBagSlot);
				if (bag) then
					item.bag = bag
					item.slot = slot
					item.specified = true;
				end
			end
		end

		if ((targetItemID or targetItemName) and not item.specified) then
			--if still can't find item, try to refresh the cache and try again.
			 if not VerifyCache then
				return WearMe.RegisterToEquip(targetInvSlot, targetItemID, targetItemName, startInvSlot, startBag, startBagSlot, true);
			 else
			 	return false;
			end
		end

		if((targetItemID or targetItemName) and not item.specified) then
			if (not bag and slot) then
				itemString, itemID, permEnchant, suffix, reforgeId, itemName, itemLink = WearMe.GetInventoryItemInfo(slot);
			elseif (bag and slot) then
				itemString, itemID, permEnchant, suffix, reforgeId, itemName, itemLink = WearMe.GetContainerItemInfo(bag, slot);
			end

			WearMe.Debug("WearMe.RegisterToEquip() bag=", bag, " slot=", slot, " item.bag=", item.bag, " item.slot=", item.slot, " itemString=", itemString, " itemID=",itemID, " itemLink=", itemLink);

			item.link = itemLink;

			-- check if this item has gems, and if so, see if any are unique-equipped
			local itemInfo = WearMe.GetItemInfoFromLink(itemLink);

			if(itemInfo) then
				item.itemID = itemInfo.itemID;
				item.unique_equipped = itemInfo.hasUniqueEquipped;
				if(item.unique_equipped == true) then
					WearMe.OutfitItems.hasUniqueEquipItem = true;
				end
			end

			--if the item is already in the right slot...
			if (not bag) then
				if(slot == targetInvSlot) then
					-- check if has unique-equip gems, because if it does, will need an extra bag slot to move them around.
					if(item.unique_equipped) then
						WearMe.OutfitItems.reqBagSlots = WearMe.OutfitItems.reqBagSlots + 1;
					end
--					return true;
				end
			end

			-- If you're trying to equip two of the same item make sure you actually have two
			local altSlot = WearMe.DuelInventorySlots[targetInvSlot];
			if (altSlot) then
				local altItem = WearMe.OutfitItems[altSlot];

				if(altItem) then
					WearMe.Debug("WearMe.RegisterToEquip() targetInvSlot=",targetInvSlot," altItem.specified=",altItem.specified," altItem.bag=",altItem.bag," altItem.slot=",altItem.slot);
				end

				if (altItem and altItem.specified) then
					--if the alternate slot item is referencing the same item this slot had found, try to find another one
					if (bag and altItem.bag == bag and slot and altItem.slot == slot) then
						item.bag = nil;
						item.slot = nil;
						item.link = nil;
						item.unique_equipped = nil;
						item.specified = nil;
						return WearMe.RegisterToEquip(targetInvSlot, targetItemID, targetItemName, nil, bag, slot+1);
					--if the alternate slot item is equiped and this one is referencing the same item, look for another one starting after that one.
					--(which will also search the bags)
					elseif (not bag and not altItem.bag and slot and altItem.slot == slot) then
						item.bag = nil;
						item.slot = nil;
						item.link = nil;
						item.unique_equipped = nil;
						item.specified = nil;
						return WearMe.RegisterToEquip(targetInvSlot, targetItemID, targetItemName, slot+1);
					end
				end
			end

			local _, _, _, _, _, itemType, itemSubType, _, equipLoc = GetItemInfo(itemString);

			item.itemType = itemType;
			item.itemSubType = itemSubType;

			if (targetInvSlot == 16 or targetInvSlot == 17) then	-- Main or Secondary Hand
				if (not bag and slot) then
					if (equipLoc == "INVTYPE_2HWEAPON") then
						item.twohand = true;
					end
				elseif (bag and slot) then
					if (equipLoc == "INVTYPE_2HWEAPON") then
						item.twohand = true;
					end
				end
			end
		end

		return true;
	end


	function WearMe.WearOutfit()

--		WearMe.VerifyInventoryCache();

		local outfit = WearMe.OutfitItems;


		-- Rings: 11, 12
		-- Trinkets: 13, 14
		-- Weapons: 16, 17
		local _, itemString, itemID, itemName, altItemString, altItemID, altItemName;
		for invSlot, altSlot in pairs(WearMe.DuelInventorySlots) do

      WearMe.Debug("WearMe: invSlot=",invSlot,"; altSlot=",altSlot);

			-- Ignore secondary slots (handle them together on the primary slot)
			if (invSlot < altSlot) then

--				WearMe.Debug("WearMe:",invSlot,"specified=",outfit[invSlot].specified,"bag=",outfit[invSlot].bag,"slot=",outfit[invSlot].slot);
--				WearMe.Debug("WearMe:",altSlot,"specified=",outfit[altSlot].specified,"bag=",outfit[altSlot].bag,"slot=",outfit[altSlot].slot);



--[[
				if (invSlot == 16 and outfit[invSlot].twohand) then
				    WearMe.Unequip(altSlot, true);  --remove offhand first
					WearMe.WearItem(outfit[invSlot], invSlot);
					altItemString, altItemID, _, _, _, altItemName = WearMe.GetInventoryItemInfo(altSlot);
					if (altItemString) then
						WearMe.QueueItemForMoving(altItemString);
					end
]]--

--				local clearCache = false;

				if(outfit[invSlot].specified) then
					itemString, itemID, _, _, _, itemName, linkText = WearMe.GetInventoryItemInfo(invSlot);

					--if either primary or alt item has unique equipped items, they need to be removed because you can't simply move them to the alternate inv location.
					if(linkText) then
						local itemInfo = WearMe.GetItemInfoFromLink(linkText);
						if(itemInfo.hasUniqueEquipped and not outfit[invSlot].slot == invSlot) then
							WearMe.Debug("WearMe: Unequipping",linkText,"first due to it being unique-equipped.");
							WearMe.Unequip(invSlot, true);
							WearMe.QueueItemForMoving(itemString);
--							clearCache = true;
						end
					end
				end

				if(outfit[altSlot].specified) then
					altItemString, altItemID, _, _, _, altItemName, altLinkText = WearMe.GetInventoryItemInfo(altSlot);
					if(altLinkText) then
						local altItemInfo = WearMe.GetItemInfoFromLink(altLinkText);
						if(altItemInfo.hasUniqueEquipped and not outfit[altSlot].slot == altSlot) then
							WearMe.Debug("WearMe: Unequipping",altLinkText,"first due to it being unique-equipped.");
							WearMe.Unequip(altSlot, true);
							WearMe.QueueItemForMoving(altItemString);
--							clearCache = true;
						end
					end
				end

				local isLanceWeapon = WearMe.LanceWeapons[outfit[invSlot].itemID];
				WearMe.Debug("WearMe.WearItem: isLanceWeapon=", isLanceWeapon, "outfit[invSlot].itemID=",outfit[invSlot].itemID);
				if(isLanceWeapon) then
					altItemString, altItemID, _, _, _, altItemName, altLinkText = WearMe.GetInventoryItemInfo(altSlot);
					if(altItemString) then
						WearMe.Debug("WearMe: Unequipping",altLinkText,"first because of problems equipping lance when an item is there.");
						WearMe.Unequip(altSlot, true);
					end
				end

--				if(clearCache) then
--					WearMe.VerifyInventoryCache();
--				end

				if (outfit[invSlot].specified and outfit[altSlot].specified) then -- and WearMe.InventorySlotInUse(invSlot) and WearMe.InventorySlotInUse(altSlot)) then

					-- first remove either of the items in either slot if that slot isn't to be used for this outfit.
--					if (not outfit[invSlot].specified) then
--						WearMe.Unequip(invSlot, true);
--						WearMe.WearItem(outfit[invSlot], invSlot);
--					end
--					if (not outfit[altSlot].specified) then
--						WearMe.Unequip(altSlot, true);
--						WearMe.WearItem(outfit[altSlot], altSlot);
--					end



--					if (not itemString or not altItemString) then
--						WearMe.WearItem(outfit[invSlot], invSlot);
--						WearMe.WearItem(outfit[altSlot], altSlot);

--          WearMe.Debug("outfit[invSlot].bag=",outfit[invSlot].bag,";outfit[altSlot].bag=",outfit[altSlot].bag,";outfit[invSlot].slot=",outfit[invSlot].slot,";outfit[altSlot].slot=",outfit[altSlot].slot);

					if (not outfit[altSlot].bag and not outfit[invSlot].bag and outfit[altSlot].slot == invSlot and outfit[invSlot].slot == altSlot) then
						-- Both equipped, just in the wrong slots
						PickupInventoryItem(invSlot);
						EquipCursorItem(altSlot);

					elseif (not outfit[altSlot].bag and outfit[altSlot].slot == invSlot) then
						-- Primary slot item needs to go into the secondary slot
						-- Put secondary slot item in bag
						WearMe.Unequip(altSlot, true);
						WearMe.QueueItemForMoving(altItemString);
						-- Equip primary slot item to secondary slot
						PickupInventoryItem(invSlot);
						EquipCursorItem(altSlot);
						-- Equip the desired item to the primary slot
						if ((outfit[invSlot].bag or outfit[invSlot].slot) and not outfit[invSlot].unique_equipped) then
							WearMe.WearItem(outfit[invSlot], invSlot);
						end
					elseif (not outfit[invSlot].bag and outfit[invSlot].slot == altSlot) then
						-- Secondary slot item needs to go into the primary slot
						-- Put primary slot item in bag
						WearMe.Unequip(invSlot, true);
						WearMe.QueueItemForMoving(itemString);
						-- Equip secondary slot item to primary slot
						PickupInventoryItem(altSlot);
						EquipCursorItem(invSlot);
						-- Equip the desired item to the secondary slot
						if ((outfit[altSlot].bag or outfit[altSlot].slot) and not outfit[altSlot].unique_equipped) then
							WearMe.WearItem(outfit[altSlot], altSlot);
						end
					else
						if (invSlot == 16 and outfit[invSlot].twohand and (not isDualWield2HCapable() or (outfit[invSlot].itemType == BI["Weapon"] and WearMe.DualWield2H_Ignore[outfit[invSlot].itemSubType]))) then
							WearMe.Unequip(altSlot, true);  --remove offhand first
						end
						if(not outfit[invSlot].unique_equipped) then
							WearMe.WearItem(outfit[invSlot], invSlot);
						end
						if(not outfit[altSlot].unique_equipped) then
							WearMe.WearItem(outfit[altSlot], altSlot);
						end
					end

				else
					--neither is specified, remove both slots.
					if (invSlot == 16 and outfit[invSlot].twohand and (not isDualWield2HCapable() or (outfit[invSlot].itemType == BI["Weapon"] and WearMe.DualWield2H_Ignore[outfit[invSlot].itemSubType]))) then
						WearMe.Unequip(altSlot, true);  --remove offhand first
					end

					if (outfit[invSlot].specified) then
						WearMe.WearItem(outfit[invSlot], invSlot);
					end
					if (outfit[altSlot].specified) then
						WearMe.WearItem(outfit[altSlot], altSlot);
					end

				end

			end


		end

		-- All Slots except the duplicates (previously handled as exceptions)

		-- if any of the items have unique-equipped gems, do a first pass to replace old inv items that may have them too
		-- first try to replace items in inv with unique-equipped with items that are not unique equipped and have no unique-equipped gems.
		for i=0, 19 do
			if(outfit[i].specified) then
				if (not WearMe.DuelInventorySlots[i]) then
					local itemString, itemID, permEnchant, suffix, reforgeId, itemName, linktext = WearMe.GetInventoryItemInfo(i);
					if(linktext) then
						local itemInfo = WearMe.GetItemInfoFromLink(linktext);
						if(itemInfo.hasUniqueEquipped and not outfit[i].unique_equipped) then
							WearMe.WearItem(outfit[i], i);
						end
					end
				end
			end
		end


		-- second try to replace remaining unique-equipped items
		for i=0, 19 do
			if(outfit[i].specified) then
				local itemString, itemID, permEnchant, suffix, reforgeId, itemName, linktext = WearMe.GetInventoryItemInfo(i);
				if(linktext) then
					local itemInfo = WearMe.GetItemInfoFromLink(linktext);
					if(itemInfo.hasUniqueEquipped) then
						WearMe.WearItem(outfit[i], i);
					end
				end
			end
		end

		-- now do final pass to equip anything that hasn't been.
--		WearMe.VerifyInventoryCache();

		for i=0, 19 do
			if(outfit[i].specified) then
				WearMe.WearItem(outfit[i], i);
			end
		end

	end

	function WearMe.WearItem(item, invSlot)

		WearMe.Debug("WearMe.WearItem: ", invSlot, item.specified, item.link, item.bag, item.slot)

		if (item.specified) then

			if (item.bag and item.slot) then
				WearMe.EquipContainerItem(item.bag, item.slot, invSlot);
			elseif (item.slot) then
				WearMe.EquipInventoryItem(item.slot, invSlot);
			else
				WearMe.Unequip(invSlot, true);
			end
		end
	end

	function isDualWield2HCapable()

		if (WearMe.DualWield2HTalents == nil) then
			WearMe.DualWield2HTalents = {};
			for t=1, GetNumTalentTabs() do
				for i=1, GetNumTalents(t) do
					local nameTalent, icon, tier, column, currRank, maxRank = GetTalentInfo(t,i);
		--			DEFAULT_CHAT_FRAME:AddMessage("- "..nameTalent..": "..currRank.."/"..maxRank);
					if(nameTalent == "Titan's Grip") then
		--				DEFAULT_CHAT_FRAME:AddMessage("WearMe: Found Titan's Grip at tab "..t..": index "..i);
						WearMe.DualWield2HTalents = {
											["WARRIOR"] =
												{{name="Titan's Grip",tab=t,index=i},}
										};
					end
				end
			end
		end
	
--code to use to look at talent tree to find the tab,index of a talent
--[[
	for t=1, GetNumTalentTabs() do
		for i=1, GetNumTalents(t) do
			nameTalent, icon, column, currRank, maxRank = GetTalentInfo(t,i);
			DEFAULT_CHAT_FRAME:AddMessage("- "..nameTalent..": "..currRank.."/"..maxRank);
			if(nameTalent == "Titan's Grip") then
				DEFAULT_CHAT_FRAME:AddMessage("- "..nameTalent..": "..currRank.."/"..maxRank.." "..t.." "..i);
			end
		end
	end
]]--
		local localizedClass, englishClass = UnitClass("player");

		myTalents = WearMe.DualWield2HTalents[englishClass];
		WearMe.Debug("WearMe: Looking up DualWield2H talents for a",englishClass,"myTalents=",myTalents);
		if(myTalents) then
			for i, talent in ipairs(myTalents) do
--				WearMe.Debug("WearMe: ",talent.name,talent.tab,talent,index);
				nameTalent, icon, tier, column, currRank, maxRank = GetTalentInfo(talent.tab, talent.index);
				WearMe.Debug("WearMe: Looking for DualWield2H Talent ",talent.name,"at tab",talent.tab,"index",talent.index," ..Found",nameTalent,"Rank=",currRank,"/",maxRank);
				if(currRank and currRank > 0) then
					return true;
				end
			end
		end

		return false;
	end


	---------------------------------------------------------------------------------
	--[[ Optimized Set Moving (Bags to Bank or Bank to Bags) ]]--
	--
	--
	--[[
	EX:
	WearMe.InitSet();
	WearMe.RegisterBagItemToMove("item:18822:2646:0:0", "Obsidian Edged Blade");
	WearMe.MoveSetToBank();

	or

	WearMe.InitSet();
	WearMe.RegisterBankItemToMove("item:18822:2646:0:0", "Obsidian Edged Blade");
	WearMe.MoveSetToBags();
	]]--
	---------------------------------------------------------------------------------

	WearMe.SetItems = {};
	WearMe.SetItems.reqBagSlots = 0;


	function WearMe.InitSet()
		WearMe.SetItems = {};
		WearMe.SetItems.reqBagSlots = 0;
	end

	function WearMe.RegisterBagItemToMove(itemID, itemName, itemCount)
		return WearMe.RegisterToMove(itemID, itemName, itemCount, WearMe.FindContainerItem);
	end

	function WearMe.RegisterBankItemToMove(itemID, itemName, itemCount)
		return WearMe.RegisterToMove(itemID, itemName, itemCount, WearMe.FindBankItem);
	end

	-- index, startBag, and startSlot are not for normal use. They are only used for recursion when finding more than one (stack) of an item.
	-- findFunc is used to designate finding in bags or bank
	function WearMe.RegisterToMove(itemID, itemName, itemCount, findFunc, index, startBag, startSlot)

		if (not itemCount) then
			itemCount = 1;
		end

		local item = {};

		local bag, slot = findFunc(itemID, itemName, startBag, startSlot);
		if (not bag) then
			return false;
		end

		local _, count, locked = GetContainerItemInfo(bag, slot);
		if (locked) then
			return WearMe.RegisterToMove(itemID, itemName, itemCount, findFunc, index, bag, slot+1);
		end
		--local texture, itemCount, locked, quality, readable = GetContainerItemInfo(bag, slot);
		local itemString = WearMe.GetContainerItemInfo(bag, slot);
		local _, _, _, _, _, _, _, stackSize = GetItemInfo(itemString);
		--local name, itemString, quality, itemLevel, minLevel, itemType, itemSubType, stackSize, equipLoc, texture = GetItemInfo(itemString);

		local item;
		if (index and WearMe.SetItems[index]) then
			item = WearMe.SetItems[index];
		else
			tinsert(WearMe.SetItems, {});
			index = getn(WearMe.SetItems);
			item = WearMe.SetItems[index];
			item.itemString = itemString;
			item.stackSize = stackSize;
			item.count = 0;
			item.where = {};
		end

		if (count > itemCount) then
			--  split stack
			item.count = item.count + itemCount;
			--WearMe.Print("Split stack: ", itemCount, " Total: ", item.count);
			tinsert( item.where, { bag = bag, slot = slot, count = itemCount } );
		elseif (count == itemCount) then
			-- pickup whole stack
			item.count = item.count + count;
			--WearMe.Print("Pickup whole stack: ", count, " Total: ", item.count);
			tinsert( item.where, { bag = bag, slot = slot } );
		else
			-- pickup whole stack
			item.count = item.count + count;
			--WearMe.Print("Pickup whole stack: ", count, " Total: ", item.count);
			tinsert( item.where, { bag = bag, slot = slot } );
			-- look for more
			return WearMe.RegisterToMove(itemID, itemName, itemCount-count, findFunc, index, bag, slot+1);
		end

		return true;
	end

	function WearMe.MoveSetToBags(backwards)
		return WearMe.MoveSet(backwards, WearMe.FindContainerItem, WearMe.BagCursorItem);
	end

	function WearMe.MoveSetToBank(backwards)
		return WearMe.MoveSet(backwards, WearMe.FindBankItem, WearMe.BankCursorItem);
	end

	function WearMe.MoveSet(backwards, findFunc, placeFunc)
		local increment = (backwards and -1 or 1);

		local bag, slot, finished, count, locked, _;
		for i, item in ipairs(WearMe.SetItems) do
			if (item.where) then
				if (item.stackSize and item.stackSize > 1) then

					finished = false;
					bag, slot = findFunc(item.itemString);
					while (bag and not finished) do
						-- Stack found in Bank
						_, count, locked = GetContainerItemInfo(bag, slot);
						if (locked or count == item.stackSize) then
							-- Full or locked stack, ignore it, look for another
							bag, slot = findFunc(item.itemString, bag, slot+increment);
						elseif (count + item.count <= item.stackSize) then
							-- Partial stack with enough space
							for i, currStack in ipairs(item.where) do
								if (currStack.count) then
									SplitContainerItem(currStack.bag, currStack.slot, currStack.count);
								else
									PickupContainerItem(currStack.bag, currStack.slot);
								end
								PickupContainerItem(bag, slot);
							end
							finished = true;
						else
							-- More than this stack can hold, check for more
							bag, slot = findFunc(item.itemString, bag, slot+increment);
						end
					end

					if (not finished) then
						-- More to transfer, no partial stacks availible
						for i, currStack in ipairs(item.where) do
							if (currStack.count) then
								WearMe.Debug("SplitContainerItem", currStack.bag, currStack.slot, currStack.count);
								SplitContainerItem(currStack.bag, currStack.slot, currStack.count);
							else
								WearMe.Debug("PickupContainerItem", currStack.bag, currStack.slot);
								PickupContainerItem(currStack.bag, currStack.slot);
							end
							WearMe.Debug("placeFunc");
							if (not placeFunc(backwards)) then
								ClearCursor();
								return false;
							end
						end
					end

				elseif (item.where[1]) then
					-- Move a single item
					PickupContainerItem(item.where[1].bag, item.where[1].slot);
					if (not placeFunc(backwards)) then
						ClearCursor();
						return false;
					end
				else
					return false;
				end
			end
		end

		return true;
	end


	------------------------------------------------------------------------------
	--[[ Move to back of bags queue ]]--
	------------------------------------------------------------------------------

	function WearMe.QueueItemForMoving(itemID)
		if (not WearMe.MoveQueue) then
			WearMe.MoveQueue = {};
		end
		tinsert(WearMe.MoveQueue, itemID);
	end

	function WearMe.CallMoveQueue()
		if (WearMe.MoveQueue and getn(WearMe.MoveQueue) > 0) then
			for i=getn(WearMe.MoveQueue), 1, -1 do
				if (WearMe.ReBagContainerItemByID(WearMe.MoveQueue[i], true)) then
					table.remove(WearMe.MoveQueue, i);
				end
			end
		end
	end


	------------------------------------------------------------------------------
	--[[ Item Cache ]]--
	------------------------------------------------------------------------------

	function WearMe.ClearInventoryCache()
		local item;
		for invSlot = 0, 19 do
			WearMe.ClearInventoryCacheItem(invSlot);
		end
	end

	function WearMe.ClearContainerCache(bag)
		local to, from;
		if (bag) then
			to = bag;
			from = bag;
		else
			to = 11;
			from = -5;
		end

--		WearMe.Debug("WearMe.ClearContainerCache from=",from," to=",to);

		local item;
		for bag = from, to do

--			WearMe.Debug("WearMe.ClearContainerCache bag=",bag," numSlots=",GetContainerNumSlots(bag));

			WearMe.Containers[bag] = {};

			for slot = 1, GetContainerNumSlots(bag) do

--				WearMe.Debug("WearMe.ClearContainerCache bag=",bag," slot=",slot);

				WearMe.ClearBagCacheItem(bag, slot);
			end
		end
	end

	function WearMe.ClearBagCacheItem(bag, slot)

--		WearMe.Debug("WearMe.ClearBagCacheItem: Clearing Cache for bag",bag,"slot",slot);

		if not bag or not slot then return end;

		item = WearMe.Containers[bag][slot];

		if (not item) then
			WearMe.Containers[bag][slot] = {};
		else
			item.itemString = nil;
			item.itemID = nil;
			item.enchant = nil;
			item.suffix = nil;
			item.reforgeId = nil;
--			item.bonus = nil;
			item.name = nil;
			item.cached = nil;
		end
	end

	function WearMe.ClearInventoryCacheItem(slot)

		WearMe.Debug("WearMe.ClearInventoryCacheItem: Clearing Cache for slot",slot);

		if not slot then return end;

		if (not WearMe.Inventory[slot]) then
			WearMe.Inventory[slot] = {};
		end;
		item = WearMe.Inventory[slot];

		item.itemString = nil;
		item.itemID = nil;
		item.enchant = nil;
		item.suffix = nil;
		item.reforgeId = nil;
--		item.bonus = nil;
		item.name = nil;
		item.cached = nil;
	end

	function WearMe.CacheInventoryItemName(invSlot, name)

    WearMe.Debug("WearMe.CacheInventoryItemName: Caching invSlot=", invSlot, "; name=", name);

		local item = WearMe.Inventory[invSlot];
		if (not item) then
			WearMe.Inventory[invSlot] = {};
			item = WearMe.Inventory[invSlot];
		end
		if (type(name) ~= "number") then
			if (name ~= item.name) then
				item.itemString = nil;
				item.itemID = nil;
				item.enchant = nil;
				item.suffix = nil;
				item.reforgeId = nil;
--				item.bonus = nil;
			end
			item.name = name;
			item.cached = true;
		end
	end

	function WearMe.CacheInventoryItem(invSlot, itemString, itemID, permEnchant, suffix, reforgeId, itemName, itemLink)

--		WearMe.Debug("WearMe.CacheInventoryItem:  Caching Inventory item in slot", invSlot, itemString, itemID, permEnchant, suffix, reforgeId, itemName);

		local item = WearMe.Inventory[invSlot];
		if (not item) then
			WearMe.Inventory[invSlot] = {};
			item = WearMe.Inventory[invSlot];
		end
		if (type(itemString) ~= "number") then
			item.itemString = itemString;
			item.itemID = itemID;
			item.enchant = permEnchant;
			item.suffix = suffix;
--			item.bonus = extraItemInfo;
--			item.uniqueId = uniqueId;
--			item.linkLevel = linkLevel;
			item.reforgeId = reforgeId;		
			item.name = itemName;
			item.itemLink = itemLink;
			item.cached = true;
		else
			WearMe.Debug("Wrong itemString: ", invSlot, itemString, itemID, permEnchant, suffix, reforgeId, itemName)
		end
	end

	function WearMe.CacheContainerItemName(bag, slot, name)
		if (not WearMe.Containers[bag]) then
			WearMe.Containers[bag] = {};
		end
		local item = WearMe.Containers[bag][slot];
		if (not item) then
			WearMe.Containers[bag][slot] = {};
			item = WearMe.Containers[bag][slot];
		end
		if (type(name) ~= "number") then
			if (name ~= item.name) then
				item.itemString = nil;
				item.itemID = nil;
				item.enchant = nil;
				item.suffix = nil;
				item.reforgeId = nil;
--				item.bonus = nil;
			end
			item.name = name;
			item.cached = true;
		end
	end

	function WearMe.CacheContainerItem(bag, slot, itemString, itemID, permEnchant, suffix, reforgeId, itemName, itemLink)
		if (not WearMe.Containers[bag]) then
			WearMe.Containers[bag] = {};
		end
		local item = WearMe.Containers[bag][slot];
		if (not item) then
			WearMe.Containers[bag][slot] = {};
			item = WearMe.Containers[bag][slot];
		end
		if (type(itemString) ~= "number") then
--			WearMe.Debug("CacheContainerItem: Caching bag", bag, "slot", slot, itemName);
			item.itemString = itemString;
			item.itemID = itemID;
			item.enchant = permEnchant;
			item.suffix = suffix;
--			item.bonus = extraItemInfo;
--			item.uniqueId = uniqueId;
--			item.linkLevel = linkLevel;
			item.reforgeId = reforgeId;		
			item.name = itemName;
			item.itemLink = itemLink;
			item.cached = true;
		end
	end

	function WearMe.CacheCursorItem(itemString, itemID, permEnchant, suffix, reforgeId, itemName, itemLink)
		local item = WearMe.CursorItem;
		if (not item) then
			WearMe.CursorItem = {};
			item = WearMe.CursorItem;
		end
		if (not item.prevItem) then
			item.prevItem = {};
		end
		if (item.name) then
			item.prevItem.itemString = item.itemString;
			item.prevItem.itemID = item.itemID;
			item.prevItem.enchant = item.enchant;
			item.prevItem.suffix = item.suffix;
--			item.prevItem.uniqueId = item.uniqueId;
--			item.prevItem.linkLevel = item.linkLevel;
			item.prevItem.reforgeId = item.reforgeId;			
--			item.prevItem.bonus = item.bonus;
			item.prevItem.name = item.name;

			item.prevItem.bag = item.bag;
			item.prevItem.bagSlot = item.bagSlot;
			item.prevItem.invSlot = item.invSlot;
			item.prevItem.split = item.split;
		end

		--WearMe.Print("CacheCursorItem: setting nextItem: ", itemName);
		item.itemString = itemString;
		item.itemID = itemID;
		item.enchant = permEnchant;
		item.suffix = suffix;
--		item.bonus = extraItemInfo;
--		item.uniqueId = uniqueId;
--		item.linkLevel = linkLevel;
		item.reforgeId = reforgeId;		
		item.name = itemName;
		item.itemLink = itemLink;

		item.bag = nil;
		item.bagSlot = nil;
		item.invSlot = nil;
		item.split = nil;
	end

	function WearMe.UpdateCursorCache()
		if (CursorHasItem()) then
			local itemName, itemID, itemLink = GetCursorInfo()
			if (itemLink) then
				if (type(itemLink) == "string") then
--					WearMe.Debug("WearMe - picked up item: ", gsub(itemLink, "\124", "\124\124"));
--					if(WearMe.DEBUG) then
--						local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(itemLink);
--						WearMe.Debug("WearMe - itemInfo=", itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture);
--					end

					local _, _, itemString, itemID, permEnchant, jewelId1, jewelId2, jewelId3, jewelId4, suffix, uniqueId, linkLevel, reforgeId, _, itemName = WearMe.ItemUniqueIdsFromLink(itemLink);
					if itemString then
						itemString = WearMe.replaceLevelInItemString(itemString);
						WearMe.CacheCursorItem(itemString, itemID, permEnchant, suffix, reforgeId, itemName, itemLink);
						return;
					end
				end
			end
		end
		WearMe.CacheCursorItem()
	end

	--[[
	function WearMe.UpdateCursorCache()
		local item = WearMe.CursorItem;
		if (not item) then
			WearMe.CursorItem = {};
			item = WearMe.CursorItem;
		end

		if (item.nextItem and item.nextItem.name) then
			--WearMe.Print("UpdateCursorCache: copy from nextItem");
			item.itemString = item.nextItem.itemString;
			item.itemID = item.nextItem.itemID;
			item.enchant = item.nextItem.enchant;
			item.suffix = item.nextItem.suffix;
			item.bonus = item.nextItem.bonus;
			item.name = item.nextItem.name;

			item.bag = item.nextItem.bag;
			item.bagSlot = item.nextItem.bagSlot;
			item.invSlot = item.nextItem.invSlot;

			item.split = item.nextItem.split;

			WearMe.ClearNextItemCursorCache();

		elseif (item.split) then
			item.split = nil;

		elseif (not CursorHasItem()) then
			--WearMe.Print("UpdateCursorCache: clearing cursor");
			item.itemString = nil;
			item.itemID = nil;
			item.enchant = nil;
			item.suffix = nil;
			item.bonus = nil;
			item.name = nil;

			item.bag = nil;
			item.bagSlot = nil;
			item.invSlot = nil;

			item.split = nil;

			WearMe.ClearNextItemCursorCache();

		end
	end

	function WearMe.ClearNextItemCursorCache()
		--WearMe.Print("ClearNextItemCursorCache");
		if (WearMe.CursorItem and WearMe.CursorItem.nextItem) then
			local item = WearMe.CursorItem.nextItem;
			item.itemString = nil;
			item.itemID = nil;
			item.enchant = nil;
			item.suffix = nil;
			item.bonus = nil;
			item.name = nil;

			item.bag = nil;
			item.bagSlot = nil;
			item.invSlot = nil;

			item.split = nil;
		end
	end
	]]--

	function WearMe.CacheBagSubTypes()
		if (not WearMe.BagSubTypes) then
			WearMe.BagSubTypes = {};
		end
		WearMe.Debug("WearMe.CacheBagSubTypes() called");

		WearMe.BagSubTypes[0] = L["Bag"];
		WearMe.BagSubTypes[-1] = L["Bag"];
		WearMe.BagSubTypes[-2] = BI["Key"];
		for bag = 1, 11 do
			invSlotID = ContainerIDToInventoryID(bag);

--			WearMe.Debug("WearMe.CacheBagSubTypes() invSlotID=",invSlotID);

			if (invSlotID > 0) then

				itemString = WearMe.GetInventoryItemInfo(invSlotID);

				if (itemString) then

--					WearMe.Debug("WearMe.CacheBagSubTypes() itemString=",itemString);

					_, _, _, _, _, _, itemSubType = GetItemInfo(itemString);

--					WearMe.Debug("WearMe.CacheBagSubTypes() itemSubType=",itemSubType);


					if (itemSubType) then
						WearMe.BagSubTypes[bag] = itemSubType;
					else
						WearMe.BagSubTypes[bag] = nil;
					end
				else
					WearMe.BagSubTypes[bag] = nil;
				end
			else
				WearMe.BagSubTypes[bag] = L["Bag"];
			end
		end
		WearMe.BagSubTypes.cached = true;
	end

	------------------------------------------------------------------------------
	--[[ Cache Hooks ]]--
	------------------------------------------------------------------------------

	function WearMe.PickupContainerItem_Hook(bag, slot)
	    WearMe.Debug("WearMe.PickupContainerItem_Hook() bag=",bag,"slot=",slot);
		local cursorItem = WearMe.CursorItem;
		if (cursorItem and cursorItem.itemID) then
			WearMe.Debug("WearMe.PickupContainerItem_Hook() cursorItem.itemID=",cursorItem.itemID);
			--Pick Up Item
			WearMe.CacheContainerItem(bag, slot);
			WearMe.Debug("Clear Bag Slot: ", bag, slot)
			cursorItem.invSlot = nil;
			cursorItem.bag = bag;
			cursorItem.bagSlot = slot;
		else
			cursorItem = cursorItem.prevItem
			if (cursorItem and cursorItem.itemID) then
				if (cursorItem.invSlot and InCombatLockdown() and not WearMe.IsChangableInCombat(cursorItem.invSlot)) then
					return;
				end
				--Move Item
				local itemString, itemID, permEnchant, suffix, reforgeId, itemName, itemLink = WearMe.GetContainerItemInfo(bag, slot);
				if (cursorItem.invSlot) then
					WearMe.CacheInventoryItem(cursorItem.invSlot, itemString, itemID, permEnchant, suffix, reforgeId, itemName, itemLink);
					WearMe.Debug("Put Into Inv: ", itemName, itemLink)
				elseif (cursorItem.bag and cursorItem.bagSlot) then
					WearMe.CacheContainerItem(cursorItem.bag, cursorItem.bagSlot, itemString, itemID, permEnchant, suffix, reforgeId, itemName, itemLink);
					WearMe.Debug("Put Into Bags: ", itemName, itemString, itemLink)
				end
				--Put Item Down
				WearMe.CacheContainerItem(bag, slot, cursorItem.itemString, cursorItem.itemID, cursorItem.enchant, cursorItem.suffix, cursorItem.reforgeId, cursorItem.name, itemLink);
				WearMe.Debug("Put Into Bags (Cursor Item): ", cursorItem.name, cursorItem.itemString)
			end
		end
	end

	if (not lastVersionLoaded or lastVersionLoaded < 1.9) then
		hooksecurefunc("PickupContainerItem", function(...) WearMe.PickupContainerItem_Hook(...) end)
	end
	--Sea.util.unhook("PickupContainerItem", "WearMe.PickupContainerItem_Hook", "before");
	--Sea.util.hook("PickupContainerItem", "WearMe.PickupContainerItem_Hook", "before");


	function WearMe.SplitContainerItem_Hook(bag, slot, count)
		local cursorItem = WearMe.CursorItem;
		if (cursorItem and cursorItem.itemID) then
			--Pick Up Item
			WearMe.CacheContainerItem(bag, slot);
			WearMe.Debug("WearMe.SplitContainerItem_Hook: Clear Bag Slot: ", bag, slot)
			cursorItem.invSlot = nil;
			cursorItem.bag = bag;
			cursorItem.bagSlot = slot;
			cursorItem.split = true;
		else
			cursorItem = cursorItem.prevItem
			if (cursorItem and cursorItem.itemID) then
				if (cursorItem.invSlot and InCombatLockdown() and not WearMe.IsChangableInCombat(cursorItem.invSlot)) then
					return;
				end
				--Move Item
				local itemString, itemID, permEnchant, suffix, reforgeId, itemName = WearMe.GetContainerItemInfo(bag, slot);
				if (cursorItem.invSlot) then
					WearMe.CacheInventoryItem(cursorItem.invSlot, itemString, itemID, permEnchant, suffix, reforgeId, itemName);
					WearMe.Debug("Put Into Inv: ", itemName)
				elseif (cursorItem.bag and cursorItem.bagSlot) then
					WearMe.CacheContainerItem(cursorItem.bag, cursorItem.bagSlot, itemString, itemID, permEnchant, suffix, reforgeId, itemName);
					WearMe.Debug("Put Into Bags: ", itemName)
				end
				--Put Item Down
				WearMe.CacheContainerItem(bag, slot, cursorItem.itemString, cursorItem.itemID, cursorItem.enchant, cursorItem.suffix, cursorItem.reforgeId, cursorItem.name);
				WearMe.Debug("Put Into Bags: ", cursorItem.name)
			end
		end
	end

	if (not lastVersionLoaded or lastVersionLoaded < 2.0) then
		hooksecurefunc("SplitContainerItem", function(...) WearMe.SplitContainerItem_Hook(...) end)
	end
	--Sea.util.unhook("SplitContainerItem", "WearMe.SplitContainerItem_Hook", "before");
	--Sea.util.hook("SplitContainerItem", "WearMe.SplitContainerItem_Hook", "before");

	function WearMe.PickupInventoryItem_Hook(invSlot)
				
--		WearMe.ClearInventoryCacheItem(invSlot);
		local cursorItem = WearMe.CursorItem;

		WearMe.Debug("WearMe.PickupInventoryItem_Hook() invSlot=", invSlot, ",cursorItem=", WearMe.asText(cursorItem), ",cursorItem.itemID=", cursorItem.itemID);
		
		if (cursorItem and cursorItem.itemID) then
			--Pick Up Item
			WearMe.CacheInventoryItem(invSlot);
			cursorItem.invSlot = invSlot;
			cursorItem.bag = nil;
			cursorItem.bagSlot = nil;
			WearMe.Debug("Clear Inv Slot: ", invSlot);
		else
			cursorItem = cursorItem.prevItem
			if (cursorItem and cursorItem.itemID) then
				if (InCombatLockdown() and not WearMe.IsChangableInCombat(invSlot)) then
					return;
				end
				--Move Item
				local itemString, itemID, permEnchant, suffix, reforgeId, itemName = WearMe.GetInventoryItemInfo(invSlot);
				if (cursorItem.invSlot) then
					WearMe.CacheInventoryItem(cursorItem.invSlot, itemString, itemID, permEnchant, suffix, reforgeId, itemName);
					WearMe.Debug("Put Into Inv: ", itemName);
				elseif (cursorItem.bag and cursorItem.bagSlot) then
					WearMe.CacheContainerItem(cursorItem.bag, cursorItem.bagSlot, itemString, itemID, permEnchant, suffix, reforgeId, itemName);
					WearMe.Debug("Put Into Bags: ", itemName);
				end
				--Put Item Down
				WearMe.CacheInventoryItem(invSlot, cursorItem.itemString, cursorItem.itemID, cursorItem.enchant, cursorItem.suffix, cursorItem.reforgeId, cursorItem.name);
				WearMe.Debug("Put Into Inv: ", cursorItem.name);
			end
		end
	end

	if (not lastVersionLoaded or lastVersionLoaded < 1.9) then
		hooksecurefunc("PickupInventoryItem", function(...) WearMe.PickupInventoryItem_Hook(...) end)
	end
	--Sea.util.unhook("PickupInventoryItem", "WearMe.PickupInventoryItem_Hook", "before");
	--Sea.util.hook("PickupInventoryItem", "WearMe.PickupInventoryItem_Hook", "before");

	function WearMe.EquipCursorItem_Hook(invSlot)
--		WearMe.ClearInventoryCacheItem(invSlot);
		local cursorItem = WearMe.CursorItem;
		if (cursorItem) then
			cursorItem = cursorItem.prevItem
			if (cursorItem and cursorItem.itemID) then
				if (InCombatLockdown() and not WearMe.IsChangableInCombat(invSlot)) then
					return;
				end
				--Move Item
				local itemString, itemID, permEnchant, suffix, reforgeId, itemName = WearMe.GetInventoryItemInfo(invSlot);
				if (cursorItem.invSlot) then
					WearMe.CacheInventoryItem(cursorItem.invSlot, itemString, itemID, permEnchant, suffix, reforgeId, itemName);
					--Sea.io.printComma("Put Into Inv: ", itemName)
				elseif (cursorItem.bag and cursorItem.bagSlot) then
					WearMe.CacheContainerItem(cursorItem.bag, cursorItem.bagSlot, itemString, itemID, permEnchant, suffix, reforgeId, itemName);
					--Sea.io.printComma("Put Into Bags: ", itemName)
				end
				--Put Item Down
				WearMe.CacheInventoryItem(invSlot, cursorItem.itemString, cursorItem.itemID, cursorItem.enchant, cursorItem.suffix, cursorItem.reforgeId, cursorItem.name);
				--Sea.io.printComma("Put Into Inv: ", cursorItem.name)
			end
		end
	end

	if (not lastVersionLoaded or lastVersionLoaded < 2.0) then
		hooksecurefunc("EquipCursorItem", function(...) WearMe.EquipCursorItem_Hook(...) end)
	end
	--Sea.util.unhook("EquipCursorItem", "WearMe.EquipCursorItem_Hook", "before");
	--Sea.util.hook("EquipCursorItem", "WearMe.EquipCursorItem_Hook", "before");

	function WearMe.ClearCursor_Hook()
		local cursorItem = WearMe.CursorItem;
		if (cursorItem and cursorItem.itemID) then
			--Put Item Down
			if (cursorItem.invSlot) then
				WearMe.CacheInventoryItem(cursorItem.invSlot, cursorItem.itemString, cursorItem.itemID, cursorItem.enchant, cursorItem.suffix, cursorItem.reforgeId, cursorItem.name);
				--Sea.io.printComma("Put Into Inv: ", cursorItem.name)
			elseif (cursorItem.bag and cursorItem.bagSlot) then
				WearMe.CacheContainerItem(cursorItem.bag, cursorItem.bagSlot, cursorItem.itemString, cursorItem.itemID, cursorItem.enchant, cursorItem.suffix, cursorItem.reforgeId, cursorItem.name);
				--Sea.io.printComma("Put Into Bags: ", cursorItem.name)
			end
			cursorItem.invSlot = nil;
			cursorItem.bag = nil;
			cursorItem.bagSlot = nil;
		end
	end

	if (not lastVersionLoaded or lastVersionLoaded < 2.0) then
		hooksecurefunc("ClearCursor", function(...) WearMe.ClearCursor_Hook(...) end)
	end

	------------------------------------------------------------------------------
	--[[ Event Handler ]]--
	------------------------------------------------------------------------------

	function WearMe.OnEvent(this, event, ...)

		local arg1 = ...;

--		WearMe.Debug("WearMe.OnEvent: Event=",event,"arg1=",arg1);

		if (event == "PLAYERBANKSLOTS_CHANGED") then
			WearMe.ClearContainerCache(BANK_CONTAINER);

		elseif (event == "BAG_UPDATE") then
--			WearMe.Debug("WearMe.OnEvent: BAG_UPDATE: ", arg1);
			-- arg1 = Container ID
			WearMe.ClearContainerCache(arg1);


		elseif (event == "UNIT_INVENTORY_CHANGED") then
			if (arg1 == "player") then
--				WearMe.Debug("WearMe.OnEvent: UNIT_INVENTORY_CHANGED: ", arg1);
				WearMe.ClearInventoryCache();
				WearMe.CallMoveQueue();
			end

		elseif (event == "CURSOR_UPDATE") then
--			WearMe.Debug("CURSOR_UPDATE: ", CursorHasItem());
			WearMe.UpdateCursorCache();
		end
		
	end

	------------------------------------------------------------------------------
	--[[ Event Driver ]]--
	------------------------------------------------------------------------------

	if (not WearMeFrame) then
		CreateFrame("Frame", "WearMeFrame");
	end
	WearMeFrame:Hide();
	--Frame Scripts
	WearMeFrame:SetScript("OnEvent", WearMe.OnEvent);
	WearMeFrame:RegisterEvent("PLAYERBANKSLOTS_CHANGED");
	WearMeFrame:RegisterEvent("BAG_UPDATE");
	WearMeFrame:RegisterEvent("UNIT_INVENTORY_CHANGED");
	WearMeFrame:RegisterEvent("CURSOR_UPDATE");

	function WearMe.Debug(...)
		if (WearMe.DEBUG) then
	--Private print does not need to concatenate strings, simply use commas to seperate arguments. Also handles printing functions, nils, and tables without throwing errors
	--private.Print = function(...)
			local output, part
			for i=1, select("#", ...) do
				part = select(i, ...)
				part = tostring(part):gsub("{{", "|cffddeeff"):gsub("}}", "|r")
				if (output) then output = output .. " " .. part
				else output = part end
			end
			ChatFrame1:AddMessage(output, 1.0, 1.0, 0.7);
		end
	end

-----------------------------------------------------------------------------------
-- Nifty little function to view any lua object as text
-----------------------------------------------------------------------------------
function WearMe.asText(obj)

  visitRef = {}
  visitRef.n = 0

  asTxRecur = function(obj, asIndex)
    if type(obj) == "table" then
      if visitRef[obj] then
        return "@"..visitRef[obj]
      end
      visitRef.n = visitRef.n +1
      visitRef[obj] = visitRef.n

      local begBrac, endBrac
      if asIndex then
        begBrac, endBrac = "[{", "}]"
      else
        begBrac, endBrac = "{", "}"
      end
      local t = begBrac
      local k, v = nil, nil
      repeat
        k, v = next(obj, k)
        if k ~= nil then
          if t > begBrac then
            t = t..", "
          end
          t = t..asTxRecur(k, 1).."="..asTxRecur(v)
        end
      until k == nil
      return t..endBrac
    else
      if asIndex then
        -- we're on the left side of an "="
        if type(obj) == "string" then
          return obj
        else
          return "["..obj.."]"
        end
      else
        -- we're on the right side of an "="
        if type(obj) == "string" then
          return '"'..obj..'"'
        else
          return tostring(obj)
        end
      end
    end
  end -- asTxRecur

  return asTxRecur(obj)
end -- asText



end
