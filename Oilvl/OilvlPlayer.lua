local cfg;
local L = OILVL_L

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

local InspectItems = {
  InspectHeadSlot = 1,
  InspectNeckSlot = 2,
  InspectShoulderSlot = 3,
  InspectBackSlot = 15,
  InspectChestSlot = 5,
  InspectWristSlot = 9,
  InspectHandsSlot = 10,
  InspectWaistSlot = 6,
  InspectLegsSlot = 7,
  InspectFeetSlot = 8,
  InspectFinger0Slot = 11,
  InspectFinger1Slot = 12,
  InspectTrinket0Slot = 13,
  InspectTrinket1Slot = 14,
  InspectMainHandSlot = 16,
  InspectSecondaryHandSlot = 17,
  InspectRangedSlot = 18,
  InspectAmmoSlot = 0
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

local function RGBToHex(r, g, b)
	r = r <= 255 and r >= 0 and r or 0
	g = g <= 255 and g >= 0 and g or 0
	b = b <= 255 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r, g, b)
end

local GemEnchant = CreateFrame('GameTooltip', 'oilvlgetooltip', UIParent, 'GameTooltipTemplate');
local GemEnchant2 = CreateFrame('GameTooltip', 'oilvlgetooltip2', UIParent, 'GameTooltipTemplate');
local enchantID = {5275,5276,5383,5310,5311,5312,5313,5314,5317,5318,5319,5320,5321,5324,5325,5326,5327,5328,5330,5334,5335,5336,5337,5384,3366,3367,3368,3370,3847,3595}

function OiLvlPlayer_Update()
	if cfg ~= nil and cfg.oilvlcharilvl and cfg.oilvlcharilvl ~= nil then
		local n = 0 -- total equipped gear
		local ailvl = 0 -- average item level
		local n2 = 0 -- total upgradable gear
		local aun = 0 -- total fully upgraded gear
		for Key, Value in pairs(Items) do
			local ItemLink = GetInventoryItemLink("player", Value)
			local Slot = getglobal(Key.."Stock");
    
			if Slot then
				Slot:Hide();
				-- add upgrade level fontstring
				if not _G[Key.."un" ] then
					local un = _G[Key]:CreateFontString(Key.."un","ARTWORK") 
					un:SetFontObject(Slot:GetFontObject())
					un:SetTextColor(1,1,0) 
					if IsAddOnLoaded("ElvUI") then
						un:SetPoint("TOPRIGHT",2,-2) 
					else
						un:SetPoint("TOPRIGHT",0,-2) 
					end
				else
					_G[Key.."un" ]:SetText("")
				end
				-- add gem and enchant fontstring
				if not _G[Key.."ge" ] then
					local ge = _G[Key]:CreateFontString(Key.."ge","OVERLAY") 
					ge:SetFontObject("GameFontNormalSmall")
					ge:SetTextColor(1,1,0)
					if Value == 1 or Value == 2 or Value == 3 or Value == 5 or Value == 9 or Value == 15 or Value == 17 then
						ge:SetPoint("BOTTOMLEFT",Key,"BOTTOMRIGHT",7,0) 
						ge:SetJustifyH("LEFT")
					else
						ge:SetPoint("BOTTOMRIGHT",Key,"BOTTOMLEFT",-7,0) 
						ge:SetJustifyH("RIGHT")
					end
					ge:SetWidth(100)
					ge:SetWordWrap(true) 
					ge:SetNonSpaceWrap(false)
					if cfg.oilvlge then
						ge:Show()
					else
						ge:Hide()
					end
				else
					_G[Key.."ge" ]:SetText("")
				end
				
				if ItemLink then
					n = n + 1
					Slot:ClearAllPoints();
					Slot:SetPoint("CENTER",0,-10);
					
					-- check item level
					local totalilvl;
					local xupgrade;
					if OItemAnalysis_CheckILVLGear(ItemLink) ~= 0 then
						totalilvl, xupgrade = OItemAnalysis_CheckILVLGear(ItemLink)
					end
					if xupgrade and cfg.oilvlun then
						_G[Key.."un"]:SetText(xupgrade);
						_G[Key.."un"]:SetShadowColor(1,1,1,1);
						n2 = n2 + 1
						aun = aun + xupgrade/2
					else
						_G[Key.."un" ]:SetText("");
					end
					Slot:SetText(totalilvl);
					Slot:SetShadowColor(1,1,1,1);
					Slot:Show();
					ailvl = ailvl + (totalilvl or 0)
					
					-- check gem and enchant
					local enchant = ItemLink:match("item:%d+:(%d+):%d+:%d+:%d+:%d+");
					GemEnchant:SetOwner(UIParent, 'ANCHOR_NONE');
					GemEnchant:ClearLines();
					GemEnchant:SetHyperlink(ItemLink);
					for m = 1, GemEnchant:NumLines() do
						local enchant = _G["oilvlgetooltipTextLeft"..m]:GetText():match(ENCHANTED_TOOLTIP_LINE:gsub("%%s", "(.+)"))
						if enchant then 
							_G[Key.."ge"]:SetText("|cff00ff00"..enchant);
						end
					end
					-- check low enchant
					if (Value == 2 or Value == 15 or Value == 11 or Value == 12 or Value == 16) and enchant ~= "0" then
						local function CheckLowEnchant(eID)
							for mm = 1, #enchantID do 
								if tonumber(eID) == enchantID[mm] then return false end 
							end
							return true
						end
						if CheckLowEnchant(enchant) and _G[Key.."ge"]:GetText() then
							_G[Key.."ge"]:SetText(_G[Key.."ge"]:GetText()..(" (|TInterface\\MINIMAP\\TRACKING\\OBJECTICONS:0:0:0:0:256:64:43:53:34:61|t" or "")..L["Low level enchanted"]..")");
						end
					end
					-- check no enchant
					if (Value == 2 or Value == 15 or Value == 11 or Value == 12 or Value == 16) and enchant == "0" then
						_G[Key.."ge"]:SetText(("|TInterface\\MINIMAP\\TRACKING\\OBJECTICONS:0:0:0:0:256:64:43:53:34:61|t" or "")..L["Not enchanted"]);
					end
					-- check no gem
					if OItemAnalysis_CountEmptySockets(ItemLink) > 0 and _G[Key.."ge"]:GetText() then
						_G[Key.."ge"]:SetText((_G[Key.."ge"]:GetText() or "").."\n"..("|TInterface\\MINIMAP\\TRACKING\\OBJECTICONS:0:0:0:0:256:64:107:117:34:61|t" or "")..L["Not socketed"]);
					end
					-- check gem
					local _, gemlink = GetItemGem(ItemLink,1)
					if gemlink then
						GemEnchant2:SetOwner(UIParent, 'ANCHOR_NONE');
						GemEnchant2:ClearLines();
						GemEnchant2:SetHyperlink(gemlink);
						for i = 2, GemEnchant2:NumLines() do
							if _G["oilvlgetooltip2TextLeft"..i]:GetText():find("+") then
								_G[Key.."ge"]:SetText((_G[Key.."ge"]:GetText() or "").."\n|cffffffff".._G["oilvlgetooltip2TextLeft"..i]:GetText());
								break
							end
						end
					end
					-- check low gem
					if gemlink and OItemAnalysisLowGem(ItemLink) > 0 and _G[Key.."ge"]:GetText() then
						_G[Key.."ge"]:SetText((_G[Key.."ge"]:GetText() or "")..("(|TInterface\\MINIMAP\\TRACKING\\OBJECTICONS:0:0:0:0:256:64:107:117:34:61|t" or "")..L["Low level socketed"]..")");
					end
				end
			end
		end
		if not CharacterFrameAverageItemLevel then
			local ifal = CharacterFrame:CreateFontString("CharacterFrameAverageItemLevel","ARTWORK") 
			ifal:SetFontObject(CharacterLevelText:GetFontObject())
			ifal:SetTextColor(1,1,0) 
			ifal:SetPoint("CENTER",CharacterLevelText,0,-13)
		end
		CharacterFrameAverageItemLevel:SetText("")
		if n ~= 0 then
			ailvl = tonumber(string.format("%." .. (cfg.oilvldp or 0) .. "f", ailvl/n))
			local ilt = ailvl
			if n2 ~= 0 then
				ilt = ilt.." ("..aun.."/"..n2..")"
			end
			CharacterFrameAverageItemLevel:SetText(ilt)
		end	
		-- add Show Gem / Enchant button
		if not oilvlGemEnchantButton then
			local button = CreateFrame("Button", "oilvlGemEnchantButton", CharacterFrame, "SecureActionButtonTemplate")
			button:SetPoint("BOTTOMLEFT", CharacterHeadSlot, "TOPLEFT",50,3)
			button:SetSize(16,16)
			button:SetText("\\")
			button:SetNormalFontObject("GameFontNormal")
	
			local ntex = button:CreateTexture()
			ntex:SetTexture("Interface\\Icons\\Trade_Engraving")
			ntex:SetAllPoints()	
			button:SetNormalTexture(ntex)
			
			button:RegisterForClicks("LeftButtonDown", "RightButtonDown");
			button:SetScript("PostClick", function(self, button, down)
				for Key, Value in pairs(Items) do
					if _G[Key.."ge"] then
						if _G[Key.."ge"]:IsShown() then 
							_G[Key.."ge"]:Hide()
							cfg.oilvlge = false
						else
							_G[Key.."ge"]:Show()
							cfg.oilvlge = true
						end
					end
				end
				for Key, Value in pairs(InspectItems) do
					if _G[Key.."ge2"] then
						if _G[Key.."ge2"]:IsShown() then 
							_G[Key.."ge2"]:Hide() 
							cfg.oilvlge = false
						else
							_G[Key.."ge2"]:Show()
							cfg.oilvlge = true
						end
					end
				end
			end)
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

function OiLvLInspect_Update()
	if InspectFrame and not InspectFrame:IsShown() then return -1 end
	if cfg ~= nil and cfg.oilvlcharilvl and cfg.oilvlcharilvl ~= nil then
		local n = 0 -- total equipped gear
		local ailvl = 0 -- average item level
		local n2 = 0 -- total upgradable gear
		local aun = 0 -- total fully upgraded gear
		for Key, Value in pairs(InspectItems) do
			local ItemLink = GetInventoryItemLink(InspectFrame.unit, Value)
			local Slot = getglobal(Key.."Stock");
    
			if Slot then
				Slot:Hide();
				-- add upgrade level fontstring
				if not _G[Key.."un2" ] then
					local un2 = _G[Key]:CreateFontString(Key.."un2","ARTWORK") 
					un2:SetFontObject(Slot:GetFontObject())
					un2:SetTextColor(1,1,0) 
					if IsAddOnLoaded("ElvUI") then
						un2:SetPoint("TOPRIGHT",2,-2) 
					else
						un2:SetPoint("TOPRIGHT",0,-2) 
					end
				else
					_G[Key.."un2" ]:SetText("")
				end
				-- add gem and enchant fontstring
				if not _G[Key.."ge2" ] then
					local ge = _G[Key]:CreateFontString(Key.."ge2","OVERLAY") 
					ge:SetFontObject("GameFontNormalSmall")
					ge:SetTextColor(1,1,0)
					if Value == 1 or Value == 2 or Value == 3 or Value == 5 or Value == 9 or Value == 15 or Value == 17 then
						ge:SetPoint("BOTTOMLEFT",Key,"BOTTOMRIGHT",7,0) 
						ge:SetJustifyH("LEFT")
					else
						ge:SetPoint("BOTTOMRIGHT",Key,"BOTTOMLEFT",-7,0) 
						ge:SetJustifyH("RIGHT")
					end
					ge:SetWidth(100)
					ge:SetWordWrap(true) 
					ge:SetNonSpaceWrap(false)
					if cfg.oilvlge then
						ge:Show()
					else
						ge:Hide()
					end
				else
					_G[Key.."ge2" ]:SetText("")
				end
				if ItemLink then
					n = n + 1
					Slot:ClearAllPoints();
					Slot:SetPoint("CENTER",0,-10);
						
					-- check item level
					local totalilvl;
					local xupgrade;
					if OItemAnalysis_CheckILVLGear(ItemLink) ~= 0 then
						totalilvl, xupgrade = OItemAnalysis_CheckILVLGear(ItemLink)
					end
					if xupgrade and cfg.oilvlun then
						_G[Key.."un2"]:SetText(xupgrade);
						_G[Key.."un2"]:SetShadowColor(1,1,1,1);
						n2 = n2 + 1
						aun = aun + xupgrade/2
					else
						_G[Key.."un2" ]:SetText("");
					end
					Slot:SetText(totalilvl);
					Slot:SetShadowColor(1,1,1,1);
					Slot:Show();
					ailvl = ailvl + (totalilvl or 0)
					
					-- check gem and enchant
					local enchant = ItemLink:match("item:%d+:(%d+):%d+:%d+:%d+:%d+");
					GemEnchant:SetOwner(UIParent, 'ANCHOR_NONE');
					GemEnchant:ClearLines();
					GemEnchant:SetHyperlink(ItemLink);
					for m = 1, GemEnchant:NumLines() do
						local enchant = _G["oilvlgetooltipTextLeft"..m]:GetText():match(ENCHANTED_TOOLTIP_LINE:gsub("%%s", "(.+)"))
						if enchant then 
							_G[Key.."ge2"]:SetText("|cff00ff00"..enchant);
						end
					end
					-- check low enchant
					if (Value == 2 or Value == 15 or Value == 11 or Value == 12 or Value == 16) and enchant ~= "0" then
						local function CheckLowEnchant(eID)
							for mm = 1, #enchantID do 
								if tonumber(eID) == enchantID[mm] then return false end 
							end
							return true
						end
						if CheckLowEnchant(enchant) and _G[Key.."ge2"]:GetText() then
							_G[Key.."ge2"]:SetText(_G[Key.."ge2"]:GetText()..("(|TInterface\\MINIMAP\\TRACKING\\OBJECTICONS:0:0:0:0:256:64:43:53:34:61|t" or "")..L["Low level enchanted"]..")");
						end
					end
					-- check no enchant
					if (Value == 2 or Value == 15 or Value == 11 or Value == 12 or Value == 16) and enchant == "0" then
						_G[Key.."ge2"]:SetText(("|TInterface\\MINIMAP\\TRACKING\\OBJECTICONS:0:0:0:0:256:64:43:53:34:61|t" or "")..L["Not enchanted"]);
					end
					-- check no gem
					if OItemAnalysis_CountEmptySockets(ItemLink) > 0 and _G[Key.."ge2"]:GetText() then
						_G[Key.."ge2"]:SetText((_G[Key.."ge2"]:GetText() or "").."\n"..("|TInterface\\MINIMAP\\TRACKING\\OBJECTICONS:0:0:0:0:256:64:107:117:34:61|t" or "")..L["Not socketed"]);
					end
					-- check gem
					local _, gemlink = GetItemGem(ItemLink,1)
					if gemlink then
						GemEnchant2:SetOwner(UIParent, 'ANCHOR_NONE');
						GemEnchant2:ClearLines();
						GemEnchant2:SetHyperlink(gemlink);
						for i = 2, GemEnchant2:NumLines() do
							if _G["oilvlgetooltip2TextLeft"..i]:GetText():find("+") then
								_G[Key.."ge2"]:SetText((_G[Key.."ge2"]:GetText() or "").."\n|cffffffff".._G["oilvlgetooltip2TextLeft"..i]:GetText());
								break
							end
						end
					end
					-- check low gem
					if gemlink and OItemAnalysisLowGem(ItemLink) > 0 and _G[Key.."ge2"]:GetText() then
						_G[Key.."ge2"]:SetText((_G[Key.."ge2"]:GetText() or "")..("(|TInterface\\MINIMAP\\TRACKING\\OBJECTICONS:0:0:0:0:256:64:107:117:34:61|t" or "")..L["Low level socketed"]..")");
					end					
				end
			end
		end
		if not InspectFrameAverageItemLevel then
			local ifal = InspectFrame:CreateFontString("InspectFrameAverageItemLevel","ARTWORK") 
			ifal:SetFontObject(InspectLevelText:GetFontObject())
			ifal:SetTextColor(1,1,0) 
			ifal:SetPoint("CENTER",InspectLevelText,0,-13)
		end
		InspectFrameAverageItemLevel:SetText("")
		if n ~= 0 then
			ailvl = tonumber(string.format("%." .. (cfg.oilvldp or 0) .. "f", ailvl/n))
			local ilt = ailvl
			if n2 ~= 0 then
				ilt = ilt.." ("..aun.."/"..n2..")"
			end
			InspectFrameAverageItemLevel:SetText(ilt)
		end
		-- add Show Gem / Enchant button
		if not oilvlGemEnchantButton2 then
			local button = CreateFrame("Button", "oilvlGemEnchantButton2", InspectFrame, "SecureActionButtonTemplate")
			button:SetPoint("BOTTOMLEFT", InspectHeadSlot, "TOPLEFT",50,3)
			button:SetSize(16,16)
			button:SetText("\\")
			button:SetNormalFontObject("GameFontNormal")
	
			local ntex = button:CreateTexture()
			ntex:SetTexture("Interface\\Icons\\Trade_Engraving")
			ntex:SetAllPoints()	
			button:SetNormalTexture(ntex)
			
			button:RegisterForClicks("LeftButtonDown", "RightButtonDown");
			button:SetScript("PostClick", function(self, button, down) 
				for Key, Value in pairs(Items) do
					if _G[Key.."ge"] then
						if _G[Key.."ge"]:IsShown() then 
							_G[Key.."ge"]:Hide()
							cfg.oilvlge = false
						else
							_G[Key.."ge"]:Show()
							cfg.oilvlge = true
						end
					end
				end
				for Key, Value in pairs(InspectItems) do
					if _G[Key.."ge2"] then
						if _G[Key.."ge2"]:IsShown() then 
							_G[Key.."ge2"]:Hide() 
							cfg.oilvlge = false
						else
							_G[Key.."ge2"]:Show()
							cfg.oilvlge = true
						end
					end
				end
			end)
		end
	else
		for Key, Value in pairs(Items) do
			local ItemLink = GetInventoryItemLink(InspectFrame.unit, Value)
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

local OiLvLInspect_Updatehooksw = false

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
		if cfg.oilvlun == nil then cfg.oilvlun = true end
		if cfg.oilvlge == nil then cfg.oilvlge = true end
	end
  
	if event == "UNIT_PORTRAIT_UPDATE" or event == "PLAYER_EQUIPMENT_CHANGED" or event == "ITEM_UPGRADE_MASTER_UPDATE" then
		OiLvlPlayer_Update();
	end
  
	if event == "INSPECT_READY"  and InspectFrame then
		if not OiLvLInspect_Updatehooksw then 
			InspectFrame:HookScript("OnShow", OiLvLInspect_Update)
			OiLvLInspect_Updatehooksw = true
		end
		OiLvlPlayer.frame:UnregisterEvent("INSPECT_READY");
	end
end)

OiLvlPlayer.frame:RegisterEvent("PLAYER_ENTERING_WORLD");
OiLvlPlayer.frame:RegisterEvent("VARIABLES_LOADED");
OiLvlPlayer.frame:RegisterEvent("INSPECT_READY");