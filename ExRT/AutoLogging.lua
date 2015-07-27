local GlobalAddonName, ExRT = ...

local VExRT = nil

local module = ExRT.mod:New("AutoLogging",ExRT.L.Logging,nil,true)

module.db.raidIDs = {
	[988]=true,	--BF
	[994]=true,	--H
	[1026]=true,	--HC
}

function module.options:Load()
	self:CreateTilte()

	self.enableChk = ExRT.lib.CreateCheckBox(self,nil,5,-30,ExRT.L.LoggingEnable,VExRT.Logging.enabled,nil,nil,"ExRTCheckButtonModernTemplate")
	self.enableChk:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.Logging.enabled = true
			module:Enable()
		else
			VExRT.Logging.enabled = nil
			module:Disable()
		end
	end)
		
	self.shtml1 = ExRT.lib.CreateText(self,620,0,"TOP",0,-65,nil,"TOP",nil,12,"- "..ExRT.L.RaidLootT17Highmaul.."\n- "..ExRT.L.RaidLootT17BF.."\n -"..ExRT.L.RaidLootT18HC)

	self.shtml2 = ExRT.lib.CreateText(self,650,0,nil,0,0,nil,"TOP",nil,12,ExRT.L.LoggingHelp1)
	ExRT.lib.SetPoint(self.shtml2,"TOP",self.shtml1,"BOTTOM",0,-15)
	
	self.disableLFR = ExRT.lib.CreateCheckBox(self,nil,0,0,ExRT.L.RaidCheckDisableInLFR,VExRT.Logging.disableLFR,nil,nil,"ExRTCheckButtonModernTemplate")
	self.disableLFR:SetNewPoint("TOP",self.shtml2,"BOTTOM",0,-15)
	self.disableLFR:SetPoint("LEFT",self,5,0)
	self.disableLFR:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.Logging.disableLFR = true
		else
			VExRT.Logging.disableLFR = nil
		end
	end)
end


function module:Enable()
	module:RegisterEvents('ZONE_CHANGED_NEW_AREA')
	module.main:ZONE_CHANGED_NEW_AREA()
end
function module:Disable()
	module:UnregisterEvents('ZONE_CHANGED_NEW_AREA')
	module.main:ZONE_CHANGED_NEW_AREA()
end


function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.Logging = VExRT.Logging or {}

	if VExRT.Logging.enabled then
		module:Enable()
	end
end

local function GetCurrentMapAreaID_Fix()
	if VExRT.Logging.enabled then
		if VExRT.Logging.disableLFR then
			local _,_,difficulty = GetInstanceInfo()
			if difficulty == 7 or difficulty == 17 then
				return 0
			else
				return GetCurrentMapAreaID()
			end
		else
			return GetCurrentMapAreaID()
		end
	else
		return 0
	end
end

local prevZone = 0
local function ZoneNewFunction()
	local zoneID = GetCurrentMapAreaID_Fix()
	if module.db.raidIDs[zoneID] then
		LoggingCombat(true)
		print('==================')
		print(ExRT.L.LoggingStart)
		print('==================')
	else
		if module.db.raidIDs[prevZone] and LoggingCombat() then
			LoggingCombat(false)
			print('==================')
			print(ExRT.L.LoggingEnd)
			print('==================')
		end
	end
	prevZone = zoneID
end

function module.main:ZONE_CHANGED_NEW_AREA()
	ExRT.mds.ScheduleTimer(ZoneNewFunction, 2)
end
