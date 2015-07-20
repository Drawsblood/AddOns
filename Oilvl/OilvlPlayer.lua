local cfg;

local OiLvlPlayer = {
  frame = CreateFrame("Frame"),
  set = 0  
}

local Items = {
  CharacterHeadSlot = 1,
  CharacterNeckSlot = 2,
  CharacterShoulderSlot = 3,
  CharacterBackSlot = 15,
  CharacterChestSlot = 5,
  CharacterWristSlot = 9,
  CharacterHandsSlot = 10,
  CharacterWaistSlot = 6,
  CharacterLegsSlot = 7,
  CharacterFeetSlot = 8,
  CharacterFinger0Slot = 11,
  CharacterFinger1Slot = 12,
  CharacterTrinket0Slot = 13,
  CharacterTrinket1Slot = 14,
  CharacterMainHandSlot = 16,
  CharacterSecondaryHandSlot = 17,
  CharacterRangedSlot = 18,
  CharacterAmmoSlot = 0
}

 local quality_color = {
	[0] = {127.5/255, 127.5/255, 127.5/255}, -- Poor (Gray)
	[1] = { 255/255, 255/255, 255/255}, -- Common (White)
	[2] = { 0/255, 255/255, 0/255}, -- Uncommon (Green)
	[3] = { 25/255, 127.5/255, 255/255}, -- Rare (Blue)
	[4] = { 255/255, 127/255, 243/255}, -- Epic (Purple)
	[5] = { 255/255, 165.75/255, 0/255}, -- Legendary (Orange)
	[6] = { 255/255, 204/255, 0/255}, -- Artifact (Light Gold)
	[7] = { 255/255, 255/255, 0/255}, -- Heirloom (Light Gold)
}

local GarroshBoA = {
	[3] = {105679,105673,105677,105672,105678,105671,105675,105670,105674,105680},
	[2] = {104405,104403,104406,104404,104401,104400,104402,104399,104409,104407},
	[1] = {105692,105686,105690,105685,105691,105684,105688,105683,105687,105693},
}

local GarroshBoAScaling = {
		  -- M,  H,  N
	[90] = {582,569,556},
	[91] = {586,574,562},
	[92] = {590,579,569},
	[93] = {593,584,575},
	[94] = {597,589,582},
	[95] = {601,595,588},
	[96] = {605,600,594},
	[97] = {609,605,601},
	[98] = {612,610,607},
	[99] = {616,615,614},
	[100] = {620,620,620},
}

function OiLvlPlayer_Update()
	if cfg ~= nil and cfg.oilvlcharilvl and cfg.oilvlcharilvl ~= nil then
		local tCount = 0;
		local tSlots = 0;
		local uLvl = 0;

		for Key, Value in pairs(Items) do
			local ItemLink = GetInventoryItemLink("player", Value)
			local Slot = getglobal(Key.."Stock");
    
			if Slot then
				Slot:Hide();
				if ItemLink then
					local _, _, quality, ItemLevel, _, oclass, _, StackCount = GetItemInfo(ItemLink)
					local cLvl, mLvl = OiLvlPlayer_ItemUpgradeLevel(ItemLink)
					uLvl = 0;
						if StackCount == 1 then
							if cLvl == nil then cLvl = 0 end
							if mLvl == nil then mLvl = 0 end
      
						uLvl = cLvl * 4
    					--if mLvl > 0 and mLvl == cLvl then uLvl = 8 end
						--if mLvl == 2 and cLvl == 1 then uLvl = 4 end
          
						tCount = tCount + ItemLevel + uLvl;
						tSlots = tSlots + 1;
						Slot:ClearAllPoints();
						Slot:SetPoint("CENTER",0,-10);
					local totalilvl = ItemLevel + uLvl;
					if Value == 16 or Value == 17 then
						local item = GetInventoryItemLink("player", Value)
						local itemID,_,_,_,_,_,_ = item:match("item:(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)");
						local m,n;
						local sw=false;
						for m = 1,3 do
							for n = 1, 10 do
								if GarroshBoA[m][n] == tonumber(itemID) then
									totalilvl = GarroshBoAScaling[UnitLevel("player")][m];
									sw=true;
									break;
								end
							end
							if sw then break end
						end						
					end
					-- check item level
					if OItemAnalysis_CheckILVLGear(ItemLink) ~= 0 then
						totalilvl = OItemAnalysis_CheckILVLGear(ItemLink)
					end
					
					Slot:SetText(totalilvl);
					Slot:SetShadowColor(1,1,1,1);
					Slot:Show();
					end
				end
			end
		end
	else
		for Key, Value in pairs(Items) do
			local ItemLink = GetInventoryItemLink("player", Value)
			local Slot = getglobal(Key.."Stock");
    
			if Slot then
				Slot:Hide();
			end
		end	
	end
end

local S_UPGRADE_LEVEL = "^" .. gsub(ITEM_UPGRADE_TOOLTIP_FORMAT, "%%d", "(%%d+)")

-- Create the tooltip:
local scantip = CreateFrame("GameTooltip", "OiLvlPlayer_Tooltip", nil, "GameTooltipTemplate")
scantip:SetOwner(UIParent, "ANCHOR_NONE")

function OiLvlPlayer_ItemUpgradeLevel(itemLink)
    -- Pass the item link to the tooltip:
    scantip:SetHyperlink(itemLink)

    -- Scan the tooltip:
    for i = 2, scantip:NumLines() do -- Line 1 is always the name so you can skip it.
      
        local text = _G["OiLvlPlayer_TooltipTextLeft"..i]:GetText()
        if text and text ~= "" then
            local currentUpgradeLevel, maxUpgradeLevel = strmatch(text, S_UPGRADE_LEVEL)
            if currentUpgradeLevel then
                return tonumber(currentUpgradeLevel), tonumber(maxUpgradeLevel)
            end
        end
    end
end


OiLvlPlayer.frame:SetScript("OnEvent", function(self, event, ...)
  if event == "PLAYER_ENTERING_WORLD" and OiLvlPlayer.set == 0 then
    OiLvlPlayer.set = 1;
    OiLvlPlayer.frame:RegisterEvent("UNIT_PORTRAIT_UPDATE");
    OiLvlPlayer.frame:RegisterEvent("ITEM_UPGRADE_MASTER_UPDATE");
	OiLvlPlayer.frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
  end
  
  if event == "VARIABLES_LOADED" then
	cfg = Oilvl_Settings;
	if cfg.oilvlcharilvl == nil then cfg.oilvlcharilvl = true; end	
  end
  
  if event == "UNIT_PORTRAIT_UPDATE" or event == "PLAYER_EQUIPMENT_CHANGED" or event == "ITEM_UPGRADE_MASTER_UPDATE" then
    OiLvlPlayer_Update();
  end
end)

OiLvlPlayer.frame:RegisterEvent("PLAYER_ENTERING_WORLD");
OiLvlPlayer.frame:RegisterEvent("VARIABLES_LOADED");