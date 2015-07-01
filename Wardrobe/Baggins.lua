

WardrobeAce.Baggins = {}

function WardrobeAce.Baggins.Matches(bag,slot,rule)

	local link = GetContainerItemLink(bag, slot)
	if(not link) then return false; end

	local itemInfo = WearMe.GetItemInfoFromLink(link);

	local result = false;

	if(itemInfo.itemEquipLoc ~= "" and itemInfo.itemEquipLoc ~= "INVTYPE_BAG" and itemInfo.itemEquipLoc ~= "INVTYPE_AMMO") then
		local outfits = Wardrobe.GetOutfitsWithItem(itemInfo.itemString)
		if(outfits and (#(outfits) > 0)) then
			if(outfits[1] == "None") then
				result = true;
			end;
		end;
	end

--	Wardrobe.Print("Wardrobe ",link,"=",result);
	return result;
end

function WardrobeAce.Baggins.GetName(rule)
	return "Wardrobe-AL:NotDefinedInOutfit";
end

function WardrobeAce.Baggins.CleanRule(rule)

end

function WardrobeAce.Baggins.Enable()
	if(IsAddOnLoaded("Baggins")) then

		Baggins:AddCustomRule("Wardrobe-AL", {
			DisplayName = "Wardrobe-AL",
			Description = "Filter if item is not defined in a Wardrobe-AL outfit",
			Matches = WardrobeAce.Baggins.Matches,
			GetName = WardrobeAce.Baggins.GetName,
		});
	end
end

function WardrobeAce.Baggins.Refresh()
	if(IsAddOnLoaded("Baggins")) then
		Baggins:ForceFullUpdate();
	end
end

