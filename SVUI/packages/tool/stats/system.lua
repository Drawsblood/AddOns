--[[
##############################################################################
_____/\\\\\\\\\\\____/\\\________/\\\__/\\\________/\\\__/\\\\\\\\\\\_       #
 ___/\\\/////////\\\_\/\\\_______\/\\\_\/\\\_______\/\\\_\/////\\\///__      #
  __\//\\\______\///__\//\\\______/\\\__\/\\\_______\/\\\_____\/\\\_____     #
   ___\////\\\__________\//\\\____/\\\___\/\\\_______\/\\\_____\/\\\_____    #
    ______\////\\\________\//\\\__/\\\____\/\\\_______\/\\\_____\/\\\_____   #
     _________\////\\\______\//\\\/\\\_____\/\\\_______\/\\\_____\/\\\_____  #
      __/\\\______\//\\\______\//\\\\\______\//\\\______/\\\______\/\\\_____ #
       _\///\\\\\\\\\\\/________\//\\\________\///\\\\\\\\\/____/\\\\\\\\\\\_#
        ___\///////////___________\///___________\/////////_____\///////////_#
##############################################################################
S U P E R - V I L L A I N - U I   By: Munglunch                              #
##############################################################################

STATS:Extend EXAMPLE USAGE: Dock:NewDataType(newStat,eventList,onEvents,update,click,focus,blur)

########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack 	= _G.unpack;
local select 	= _G.select;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ MATH METHODS ]]--
local floor = math.floor
--[[ TABLE METHODS ]]--
local tsort = table.sort;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L;
local Dock = SV.Dock;
--[[ 
########################################################## 
SYSTEM STATS (Credit: Elv)
##########################################################
]]--
local int, int2 = 6, 5
local statusColors = {
	"|cff0CD809",
	"|cffE8DA0F",
	"|cffFF9000",
	"|cffD80909"
}

local enteredFrame = false;
local bandwidthString = "%.2f Mbps"
local percentageString = "%.2f%%"
local homeLatencyString = "%d ms"
local kiloByteString = "%d kb"
local megaByteString = "%.2f mb"
local totalMemory = 0
local bandwidth = 0

local function formatMem(memory)
	local mult = 10^1
	if memory > 999 then
		local mem = ((memory/1024) * mult) / mult
		return megaByteString:format(mem)
	else
		local mem = (memory * mult) / mult
		return kiloByteString:format(mem)
	end
end

local memoryTable = {}
local cpuTable = {}
--local eventTable = {"ZONE_CHANGED", "ZONE_CHANGED_NEW_AREA", "PLAYER_ENTERING_WORLD"}

local function RebuildAddonList()
	local addOnCount = GetNumAddOns()
	if (addOnCount == #memoryTable) then return end
	memoryTable = {}
	cpuTable = {}
	for i = 1, addOnCount do
		local addonName = select(2, GetAddOnInfo(i))
		memoryTable[i] = { i, addonName, 0, IsAddOnLoaded(i) }
		cpuTable[i] = { i, addonName, 0, IsAddOnLoaded(i) }
	end
end

local function UpdateMemory()
	-- Update the memory usages of the addons
	UpdateAddOnMemoryUsage()
	-- Load memory usage in table
	totalMemory = 0
	for i = 1, #memoryTable do
		memoryTable[i][3] = GetAddOnMemoryUsage(memoryTable[i][1])
		totalMemory = totalMemory + memoryTable[i][3]
	end
	-- Sort the table to put the largest addon on top
	tsort(memoryTable, function(a, b)
		if a and b then
			return a[3] > b[3]
		end
	end)
end

local function UpdateCPU()
	--Update the CPU usages of the addons
	UpdateAddOnCPUUsage()
	-- Load cpu usage in table
	local addonCPU = 0
	local totalCPU = 0
	for i = 1, #cpuTable do
		addonCPU = GetAddOnCPUUsage(cpuTable[i][1])
		cpuTable[i][3] = addonCPU
		totalCPU = totalCPU + addonCPU	
	end
	
	-- Sort the table to put the largest addon on top
	tsort(cpuTable, function(a, b)
		if a and b then
			return a[3] > b[3]
		end
	end)	
	
	return totalCPU
end

local function Click()
	collectgarbage("collect");
	ResetCPUUsage();
end

local function OnEnter(self)
	enteredFrame = true;
	local cpuProfiling = false --GetCVar("scriptProfile") == "1"
	Dock:SetDataTip(self)

	UpdateMemory()	
	bandwidth = GetAvailableBandwidth()
	
	Dock.DataTooltip:AddDoubleLine(L['Home Latency:'], homeLatencyString:format(select(3, GetNetStats())), 0.69, 0.31, 0.31,0.84, 0.75, 0.65)
	
	if bandwidth ~= 0 then
		local percent = GetDownloadedPercentage()
		percent = percent * 100
		Dock.DataTooltip:AddDoubleLine(L['Bandwidth'] , bandwidthString:format(bandwidth), 0.69, 0.31, 0.31,0.84, 0.75, 0.65)
		Dock.DataTooltip:AddDoubleLine(L['Download'] , percentageString:format(percent), 0.69, 0.31, 0.31, 0.84, 0.75, 0.65)
		Dock.DataTooltip:AddLine(" ")
	end
	
	local totalCPU = nil
	Dock.DataTooltip:AddDoubleLine(L['Total Memory:'], formatMem(totalMemory), 0.69, 0.31, 0.31,0.84, 0.75, 0.65)
	if cpuProfiling then
		totalCPU = UpdateCPU()
		Dock.DataTooltip:AddDoubleLine(L['Total CPU:'], homeLatencyString:format(totalCPU), 0.69, 0.31, 0.31,0.84, 0.75, 0.65)
	end
	
	local red, green
	if IsShiftKeyDown() or not cpuProfiling then
		Dock.DataTooltip:AddLine(" ")
		for i = 1, #memoryTable do
			if (memoryTable[i][4]) then
				red = memoryTable[i][3] / totalMemory
				green = 1 - red
				Dock.DataTooltip:AddDoubleLine(memoryTable[i][2], formatMem(memoryTable[i][3]), 1, 1, 1, red, green + .5, 0)
			end						
		end
	end
	
	if cpuProfiling and not IsShiftKeyDown() then
		Dock.DataTooltip:AddLine(" ")
		for i = 1, #cpuTable do
			if (cpuTable[i][4]) then
				red = cpuTable[i][3] / totalCPU
				green = 1 - red
				Dock.DataTooltip:AddDoubleLine(cpuTable[i][2], homeLatencyString:format(cpuTable[i][3]), 1, 1, 1, red, green + .5, 0)
			end						
		end

		-- if(Dock.DebugList) then
		-- 	Dock.DataTooltip:AddLine(" ")
		-- 	for _,schema in pairs(Dock.DebugList) do
		--         local obj = SV[schema]
		--         if obj and obj.___eventframe then
		--             local upTime, numEvents = GetFrameCPUUsage(obj.___eventframe)
		--             local eventString = ("%s:"):format(schema)
		-- 			local eventResults = ("Calls: |cffFFFF00%d|r @: |cffFFFF00%dms|r"):format(numEvents, upTime)
		-- 			Dock.DataTooltip:AddDoubleLine(eventString, eventResults, 1, 0.5, 0, 1, 1, 1)
		--         end
		--     end
		-- end

		-- Dock.DataTooltip:AddLine(" ")
		-- for i = 1, #eventTable do
		-- 	local upTime, numEvents = GetEventCPUUsage(eventTable[i])
		-- 	local eventString = ("%s:"):format(eventTable[i])
		-- 	local eventResults = ("Calls: |cffFFFF00%d|r @: |cffFFFF00%dms|r"):format(numEvents, upTime)
		-- 	Dock.DataTooltip:AddDoubleLine(eventString, eventResults, 1, 0.5, 0, 1, 1, 1)
		-- end


		Dock.DataTooltip:AddLine(" ")
		Dock.DataTooltip:AddLine(L['(Hold Shift) Memory Usage'])
	end
	
	Dock.DataTooltip:Show()
end

local function OnLeave(self)
	enteredFrame = false;
	Dock.DataTooltip:Hide()
end

local Update = function(self, t)
	int = int - t
	int2 = int2 - t
	
	if int < 0 then
		RebuildAddonList()
		int = 10
	end
	if int2 < 0 then
		local framerate = floor(GetFramerate())
		local latency = select(4, GetNetStats()) 
					
		self.text:SetFormattedText("FPS: %s%d|r MS: %s%d|r", 
			statusColors[framerate >= 30 and 1 or (framerate >= 20 and framerate < 30) and 2 or (framerate >= 10 and framerate < 20) and 3 or 4], 
			framerate, 
			statusColors[latency < 150 and 1 or (latency >= 150 and latency < 300) and 2 or (latency >= 300 and latency < 500) and 3 or 4], 
			latency)
		int2 = 1
		if enteredFrame then
			OnEnter(self)
		end		
	end
end
-- if(SV.DebugMode) then
-- 	Update = function(self, t)
-- 		int = int - t
-- 		if int < 0 then
-- 			UpdateAddOnMemoryUsage()
-- 			local svuiRAMout = formatMem(GetAddOnMemoryUsage("SVUI"))
-- 			self.text:SetFormattedText("RAM: %s%s|r", statusColors[1], svuiRAMout)
-- 			int = 1
-- 			if enteredFrame then
-- 				OnEnter(self)
-- 			end		
-- 		end
-- 	end
-- else
-- 	Update = function(self, t)
-- 		int = int - t
-- 		int2 = int2 - t
		
-- 		if int < 0 then
-- 			RebuildAddonList()
-- 			int = 10
-- 		end
-- 		if int2 < 0 then
-- 			local framerate = floor(GetFramerate())
-- 			local latency = select(4, GetNetStats()) 
						
-- 			self.text:SetFormattedText("FPS: %s%d|r MS: %s%d|r", 
-- 				statusColors[framerate >= 30 and 1 or (framerate >= 20 and framerate < 30) and 2 or (framerate >= 10 and framerate < 20) and 3 or 4], 
-- 				framerate, 
-- 				statusColors[latency < 150 and 1 or (latency >= 150 and latency < 300) and 2 or (latency >= 300 and latency < 500) and 3 or 4], 
-- 				latency)
-- 			int2 = 1
-- 			if enteredFrame then
-- 				OnEnter(self)
-- 			end		
-- 		end
-- 	end
-- end

Dock:NewDataType('System', nil, nil, Update, Click, OnEnter, OnLeave)

--[[
OTHER CHECKS

GetScriptCPUUsage()
print(debugstack())
local usage, calls = GetFunctionCPUUsage(function, includeSubroutines)
local usage, numEvents = GetEventCPUUsage(["event"])
]]--