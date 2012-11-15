-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_WoWuction - AddOn by Sapu94							 	  	  --
--  				 http://www.curse.com/addons/wow/tradeskillmaster_wowuction				     --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --


-- register this file with Ace Libraries
local TSM = select(2, ...)
TSM = LibStub("AceAddon-3.0"):NewAddon(TSM, "TradeSkillMaster_WoWuction", "AceConsole-3.0")
local AceGUI = LibStub("AceGUI-3.0") -- load the AceGUI libraries

TSM.version = GetAddOnMetadata("TradeSkillMaster_WoWuction","X-Curse-Packaged-Version") or GetAddOnMetadata("TradeSkillMaster_WoWuction", "Version") -- current version of the addon
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_WoWuction") -- loads the localization table

local savedDBDefaults = {
	factionrealm = {},
	profile = {
		tooltip = true,
	},
}

-- Called once the player has loaded WOW.
function TSM:OnInitialize()
	-- load the savedDB into TSM.db
	TSM.db = LibStub:GetLibrary("AceDB-3.0"):New("TradeSkillMaster_WoWuctionDB", savedDBDefaults, true)

	TSMAPI:RegisterReleasedModule("TradeSkillMaster_WoWuction", TSM.version, GetAddOnMetadata("TradeSkillMaster_WoWuction", "Author"), GetAddOnMetadata("TradeSkillMaster_WoWuction", "Notes"))
	TSMAPI:RegisterData("wowuctionLastScan", TSM.GetLastCompleteScan)
	TSMAPI:RegisterData("wowuctionLastScanTime", TSM.GetLastScanTime)
	
	TSMAPI:AddPriceSource("wowuctionMarket", L["WoWuction Realm Market Value"], function(itemLink) return TSM:GetData(itemLink, "marketValue") end)
	TSMAPI:AddPriceSource("wowuctionMedian", L["WoWuction Realm Median Price"], function(itemLink) return TSM:GetData(itemLink, "medianPrice")  end)
	TSMAPI:AddPriceSource("wowuctionRegionMarket", L["WoWuction Region Market Value"], function(itemLink) return TSM:GetData(itemLink, "regionMarketValue") end)
	TSMAPI:AddPriceSource("wowuctionRegionMedian", L["WoWuction Region Median Price"], function(itemLink) return TSM:GetData(itemLink, "regionMedianPrice")  end)

	if TSM.db.profile.tooltip then
		TSMAPI:RegisterTooltip("TradeSkillMaster_WoWuction", function(...) return TSM:LoadTooltip(...) end)
	end

	TSMAPI:RegisterSlashCommand("wowuction", TSM.OnSlashCommand, L["Toggles TSM_WoWuction Tooltips"], true)
end

function TSM:OnEnable()
	local realms = {GetRealmName(), "region"}
	local faction = strlower(UnitFactionGroup("player"))
	local extractedData = {}
	local hasData = false
	
	if TSM.data then
		for _, realm in ipairs(realms) do
			if TSM.data[realm] and TSM.data[realm][faction] then
				extractedData.lastUpdate = extractedData.lastUpdate or TSM.data[realm].lastUpdate
				if #TSM.data[realm][faction] > 0 then
					for _, itemData in ipairs(TSM.data[realm][faction]) do
						local itemID = itemData[1] -- itemID always in the first slot
						extractedData[itemID] = extractedData[itemID] or {}
						for i=2, #itemData do
							local key = TSM.data[realm].fields[i]
							if key == "regionAvgDailyQuantityX100" then
								key = "regionAvgDailyQuantity"
								itemData[i] = itemData[i] / 100
							end
							extractedData[itemID][key] = itemData[i]
						end
						hasData = true
					end
				else
					extractedData = CopyTable(TSM.data[realm][faction])
				end
			end
		end
		wipe(TSM.data)
	end
	if not hasData then
		TSM:Print(L["No wowuction data found. Go to the \"Data Export\" page for your realm on wowuction.com to download data."])
	end
	
	TSM.data = extractedData
end

function TSM:LoadTooltip(itemID, quantity)
	local data = TSM:GetData(itemID)

	local text = {}
	if not data then return text end
	if data.marketValue and data.marketValue > 0 then
		tinsert(text, "  "..L["Realm Market Value:"].." "..TSMAPI:FormatTextMoney(data.marketValue, "|cffffffff").." (+/-"..TSMAPI:FormatTextMoney(data.marketValueErr, "|cffffffff")..")")
	end
	if data.medianPrice and data.medianPrice > 0 then
		tinsert(text, "  "..L["Realm Median Price:"].." "..TSMAPI:FormatTextMoney(data.medianPrice, "|cffffffff").." (+/-"..TSMAPI:FormatTextMoney(data.medianPriceErr, "|cffffffff")..")")
	end
	if data.regionMarketValue and data.regionMarketValue > 0 then
		tinsert(text, "  "..L["Region Market Value:"].." "..TSMAPI:FormatTextMoney(data.regionMarketValue, "|cffffffff").." (+/-"..TSMAPI:FormatTextMoney(data.regionMarketValueErr, "|cffffffff")..")")
	end
	if data.regionMedianPrice and data.regionMedianPrice > 0 then
		tinsert(text, "  "..L["Region Median Price:"].." "..TSMAPI:FormatTextMoney(data.regionMedianPrice, "|cffffffff").." (+/-"..TSMAPI:FormatTextMoney(data.regionMedianPriceErr, "|cffffffff")..")")
	end
	if data.regionAvgDailyQuantity and data.regionAvgDailyQuantity > 0 then
		tinsert(text, "  "..L["Region Avg Daily Quantity:"].." |cffffffff"..(data.regionAvgDailyQuantity))
	end
	
	if #text > 0 then
		tinsert(text, 1, "WoWuction Prices:")
	end

	return text
end

function TSM:OnSlashCommand()
	TSM.db.profile.tooltip = not TSM.db.profile.tooltip
	if TSM.db.profile.tooltip then
		TSMAPI:RegisterTooltip("TradeSkillMaster_WoWuction", function(...) return TSM:LoadTooltip(...) end)
		TSM:Print(L["Tooltips are now enabled."])
	else
		TSMAPI:UnregisterTooltip("TradeSkillMaster_WoWuction")
		TSM:Print(L["Tooltips are now disabled."])
	end
end

function TSM:GetData(itemID, key)
	if type(itemID) ~= "number" then itemID = TSMAPI:GetItemID(itemID) end

	local data
	if not (TSM.data and TSM.data[itemID] and (not key or TSM.data[itemID][key])) then return end
	
	data = TSM.data[itemID]
	
	if key then
		return data[key] > 0 and data[key]
	else
		return data
	end
end

function TSM:GetLastCompleteScan()
	if not TSM.data then return end
	
	local lastScan = {}
	for itemID, data in pairs(TSM.data) do
		if data.marketValue and data.minBuyout then
			lastScan[itemID] = {marketValue=data.marketValue, minBuyout=data.minBuyout}
		end
	end
	
	return lastScan
end

function TSM:GetLastScanTime()
	return TSM.data and TSM.data.lastUpdate
end