local GlobalAddonName, ExRT = ...

local math_ceil, IsEncounterInProgress, abs, UnitHealth, UnitHealthMax, GetTime, format = math.ceil, IsEncounterInProgress, abs, UnitHealth, UnitHealthMax, GetTime, format

local VExRT = nil

local module = ExRT.mod:New("Timers",ExRT.L.timers,nil,true)
local ELib,L = ExRT.lib,ExRT.L

module.db.lasttimertopull = 0
module.db.timertopull = 0
module.db.firstmsg = false
module.db.segmentToKill = 1
module.db.maxSegments = 16	-- 0.5 sec every seg

local timeToKillEnabled = nil

local function ToRaid(msg)
	if IsInRaid() then
		SendChatMessage(msg, "raid_warning")
	else
		RaidWarningFrame_OnEvent(RaidWarningFrame,"CHAT_MSG_RAID_WARNING",msg)
		print(msg)
	end
end

local function CreateTimers(ctime,cname)
	local chat_type,playerName = ExRT.F.chatType()

	if cname == L.timerattack then
		SendAddonMessage("BigWigs", "T:BWPull "..ctime, chat_type,playerName)
		local _,_,_,_,_,_,_,mapID = GetInstanceInfo()
		SendAddonMessage("D4", ("PT\t%d\t%d"):format(ctime,mapID or -1), chat_type,playerName)
	else
		SendAddonMessage("BigWigs", "T:BWCustomBar "..ctime.." "..cname, chat_type,playerName)
		if ctime == 0 then
			ctime = 1
		end
		SendAddonMessage("D4", ("U\t%d\t%s"):format(ctime,cname), chat_type,playerName)
	end
end

function module:timer(elapsed)
	if module.db.timertopull > 0 then
		if math_ceil(module.db.timertopull) < math_ceil(module.db.lasttimertopull) then
			if module.db.firstmsg == true or math_ceil(module.db.timertopull) % 5 == 0 or math_ceil(module.db.timertopull) == 7 or math_ceil(module.db.timertopull) < 5 then
				ToRaid(L.timerattackt.." "..math_ceil(module.db.timertopull).." "..L.timersec)
				module.db.firstmsg = false
			end
			module.db.lasttimertopull = module.db.timertopull
		end
		module.db.timertopull = module.db.timertopull - elapsed
		if module.db.timertopull < 0 then
			module.db.timertopull = 0
			ToRaid(">>> "..L.timerattack.." <<<")
		end
	end
	if VExRT.Timers.enabled then
		if not module.frame.encounter and IsEncounterInProgress() then
			module.frame.encounter = true
			module.frame.total = 0
			
			if VExRT.Timers.OnlyInCombat then
				module.frame:Show()
			end
		elseif module.frame.encounter and not IsEncounterInProgress() then
			module.frame.encounter = nil
			
			if VExRT.Timers.OnlyInCombat and not module.frame.inCombat then
				module.frame:Hide()
			end
		end
	end
end

function ExRT.F:DoPull(inum)
	if module.db.timertopull > 0 then
		module.db.timertopull = 0
		ToRaid(">>> "..L.timerattackcancel.." <<<")
		CreateTimers(0,L.timerattack)
	else
		inum = tonumber(inum) or 10
		module.db.firstmsg = true
		module.db.lasttimertopull = inum + 1
		module.db.timertopull = inum
		CreateTimers(inum,L.timerattack)
	end
end

function module:slash(arg,msgDeformatted)
	if arg == "pull" then
		if module.db.timertopull > 0 then
			module.db.timertopull = 0
			ToRaid(">>> "..L.timerattackcancel.." <<<")
			CreateTimers(0,L.timerattack)
		else
			module.db.firstmsg = true
			module.db.lasttimertopull = 11
			module.db.timertopull = 10
			CreateTimers(10,L.timerattack)
		end
	elseif arg:find("^pull ") then
		if module.db.timertopull > 0 then
			module.db.timertopull = 0
			ToRaid(">>> "..L.timerattackcancel.." <<<")
			CreateTimers(0,L.timerattack)
		else
			local id = arg:match("%d+")
			if id then
				id = tonumber(id)
				module.db.firstmsg = true
				module.db.lasttimertopull = id + 1
				module.db.timertopull = id
				CreateTimers(id,L.timerattack)
			end
		end
	elseif arg:find("^afk ") then
		local id = arg:match("%d+")
		if id then
			id = tonumber(id)
			if id > 0 then
				CreateTimers(id*60,L.timerafk)
				ToRaid(L.timerafk.." "..math.ceil(id).." "..L.timermin)
			else
				CreateTimers(0,L.timerafk)
				ToRaid(L.timerafkcancel)
			end
		end
	elseif arg:find("^timer ") then
		local timerName,timerTime = msgDeformatted:match("^[Tt][Ii][Mm][Ee][Rr] (.-) ([0-9%.]+)")
		if not timerName or not timerTime then
			return
		end
		timerTime = tonumber(timerTime)
		if not timerTime then
			return
		end
		CreateTimers(timerTime,timerName)
	elseif VExRT.Timers.enabled and arg:find("^mytimer ") then
		local id = arg:match("%d+")
		if id then
			module.frame.total = -tonumber(id)
		end	
	end
end

function module.options:Load()
	self:CreateTilte()

	self.shtml1 = ELib:Text(self,L.timerstxt1,13):Size(650,200):Point(5,-30):Top()
	self.shtml2 = ELib:Text(self,L.timerstxt2,13):Size(550,200):Point(105,-30):Top():Color()
	
	self.chkEnable = ELib:Check(self,L.timerTimerFrame,VExRT.Timers.enabled):Point(5,-155):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Timers.enabled = true
			module.frame:Show()
			module.frame:SetScript("OnUpdate", module.frame.OnUpdateFunc)
			module:RegisterEvents('PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED')
			module.options.chkTimeToKill:SetEnabled(true)
		else
			VExRT.Timers.enabled = nil
			VExRT.Timers.timeToKill = nil
			module.frame:Hide() 
			module.frame:SetScript("OnUpdate", nil)
			module:UnregisterEvents('PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED')
			module.options.chkTimeToKill:SetEnabled(false)
			module.options.chkTimeToKill:SetChecked(nil)
		end
	end)
	
	self.chkOnlyInCombat = ELib:Check(self,L.TimerOnlyInCombat,VExRT.Timers.OnlyInCombat):Point(30,-180):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Timers.OnlyInCombat = true
			if not (module.frame.inCombat or module.frame.encounter) then
				module.frame:Hide()
			end
		else
			VExRT.Timers.OnlyInCombat = nil
			if VExRT.Timers.enabled then
				module.frame:Show()
			end
		end
	end)
	
	self.chkFixate = ELib:Check(self,L.cd2fix,VExRT.Timers.Lock):Point(5,-205):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Timers.Lock = true
			module.frame:SetMovable(false)
			module.frame:EnableMouse(false)
		else
			VExRT.Timers.Lock = nil
			module.frame:SetMovable(true)
			module.frame:EnableMouse(true)
		end
	end)
	
	self.chkTimeToKill = ELib:Check(self,L.TimerTimeToKill,VExRT.Timers.timeToKill):Point(5,-230):Tooltip(L.TimerTimeToKillHelp):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Timers.timeToKill = true
			timeToKillEnabled = true
		else
			VExRT.Timers.timeToKill = nil
			timeToKillEnabled = nil
			module.frame.killTime:SetText("")
		end
	end)
	
	self.ButtonToCenter = ELib:Button(self,L.TimerResetPos):Size(255,20):Point(5,-255):Tooltip(L.TimerResetPosTooltip):OnClick(function()
		VExRT.Timers.Left = nil
		VExRT.Timers.Top = nil

		module.frame:ClearAllPoints()
		module.frame:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
	end) 
	
	if not VExRT.Timers.enabled then
		self.chkTimeToKill:SetChecked(nil)
		self.chkTimeToKill:SetEnabled(false)
	end
end

function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.Timers = VExRT.Timers or {}

	if VExRT.Timers.Left and VExRT.Timers.Top then 
		module.frame:ClearAllPoints()
		module.frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.Timers.Left,VExRT.Timers.Top) 
	end

	if VExRT.Timers.enabled then
		if not VExRT.Timers.OnlyInCombat then
			module.frame:Show()
		end
		module.frame:SetScript("OnUpdate", module.frame.OnUpdateFunc)
		module:RegisterEvents('PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED')		
	end
	if VExRT.Timers.enabled and VExRT.Timers.timeToKill then 
		timeToKillEnabled = true
	end
	if VExRT.Timers.Lock then
		module.frame:SetMovable(false)
		module.frame:EnableMouse(false)
	end
	module:RegisterTimer()
	module:RegisterSlash()
end

function module.main:PLAYER_REGEN_DISABLED()
	if not module.frame.encounter then 
		module.frame.total = 0 
	end
	module.frame.inCombat = true
	
	if VExRT.Timers.OnlyInCombat then
		module.frame:Show()
	end
end

function module.main:PLAYER_REGEN_ENABLED()
	module.frame.inCombat = nil
	
	if VExRT.Timers.OnlyInCombat and not module.frame.encounter then
		module.frame:Hide()
	end
end

module.frame = CreateFrame("Frame",nil,UIParent)
module.frame:Hide()
module.frame:SetSize(77,27)
module.frame:SetPoint("CENTER", 0, 0)
module.frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 4})
module.frame:SetBackdropBorderColor(0.1,0.1,0.1,0.7)
module.frame:SetBackdropColor(0,0,0,0.7)
module.frame:EnableMouse(true)
module.frame:SetMovable(true)
module.frame:RegisterForDrag("LeftButton")
module.frame:SetScript("OnDragStart", function(self)
	self:StartMoving()
end)
module.frame:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
	VExRT.Timers.Left = self:GetLeft()
	VExRT.Timers.Top = self:GetTop()
end)
module.frame.total = 0
module.frame.tmr = 0
module.frame.killTmr = 0
module.frame.txt = ELib:Text(module.frame,"00:00.0"):Size(77,27):Point("LEFT",11,0):Left():Font(ExRT.F.defFont,16):Color():Shadow():Outline()
module.frame.killTime = ELib:Text(module.frame,""):Size(77,27):Point("TOP",module.frame,"BOTTOM",0,0):Top():Center():Font(ExRT.F.defFont,14):Color():Shadow():Outline()
module:RegisterHideOnPetBattle(module.frame)

module.frame:SetFrameStrata("HIGH")

module.db.TTK = {}

do
	local _db = module.db
	local function NumToTime(num)
		if num >= 600 or num < 0 then
			return ""
		elseif num >= 60 then
			return format("%d:%02d",floor(num/60),num % 60)
		else
			return format("%d",num)
		end
	end
	
	local targetsList = {"target","focus","focustarget"}
	for i=1,4 do targetsList[#targetsList + 1] = "party"..i.."target" end
	for i=1,40 do targetsList[#targetsList + 1] = "raid"..i.."target" end	
	for i=1,5 do targetsList[#targetsList + 1] = "boss"..i end
	
	local TTK = module.db.TTK
	local TTKupdateTimer,TTKclearTimer = 0,0
	
	function module.frame.OnUpdateFunc(self,elapsed)
		self.tmr = self.tmr + elapsed
		if self.tmr > 0.05 and (self.inCombat or self.encounter or self.total < 0) then
			self.total = self.total + self.tmr
			local txt = format("%2.2d:%2.2d\.%1.1d",abs(self.total)/60,abs(self.total)%60,(abs(self.total)*10)%10)
			if txt ~= self.ExTimerTxt then
				module.frame.txt:SetText(txt)
				self.ExTimerTxt = txt
			end
			self.tmr = 0
		elseif self.tmr > 0.05 then
			self.tmr = 0
		end
		
		if timeToKillEnabled then
			TTKupdateTimer = TTKupdateTimer + elapsed
			if TTKupdateTimer > 0.5 then
				TTKclearTimer = TTKclearTimer + TTKupdateTimer
				TTKupdateTimer = 0
				local _time = GetTime()
				for i=1,#targetsList do
					local unit = targetsList[i]
					local guid = UnitGUID(unit)
					if guid then
						local guidData = TTK[guid]
						if not guidData then
							guidData = {
								pos = 1,
								update = 0,
								conf = 0,
								hp = {},
								time = {},
							}
							TTK[guid] = guidData
						end
						local lastUpdate = guidData.update
						if lastUpdate < _time then
							local posNow = guidData.pos
							local maxHP = UnitHealthMax(unit)
							maxHP = maxHP == 0 and 1 or maxHP
							guidData.hp[ posNow ] = UnitHealth(unit) / maxHP
							guidData.time[ posNow ] = _time
							guidData.pos = guidData.pos + 1
							if guidData.pos > 16 then
								guidData.pos = 1
							end
							if (_time - lastUpdate) > 1 then
								guidData.conf = 0
							end
							guidData.conf = guidData.conf + 1
							if guidData.conf > 16 then
								guidData.conf = 16
							end
							guidData.update = _time
						end
					end
				end
				
				local playerTarget = UnitGUID("target")
				if playerTarget then
					local guidData = TTK[playerTarget]
					if guidData.conf > 15 then
						local posMax = guidData.pos
						local posMin = posMax - 1
						if posMin < 1 then
							posMin = 16
						end
						
						local perSec = (guidData.hp[posMax] - guidData.hp[posMin]) / (guidData.time[posMin] - guidData.time[posMax])
						if perSec == 0 then
							self.killTime:SetText("")
						else
							--print( guidData.hp[posMin], perSec )
							local diff = guidData.hp[posMin] / perSec
							self.killTime:SetText(NumToTime(diff))
						end
					else
						self.killTime:SetText("")
					end
				else
					self.killTime:SetText("")
				end
				
				if TTKclearTimer > 180 then
					local clearData = {}
					for mobGUID,mobData in pairs(TTK) do
						if (_time - mobData.update) > 300 then
							clearData[#clearData + 1] = mobGUID
						end
					end
					for i=1,#clearData do
						TTK[ clearData[i] ] = nil
					end
				end
			end
		end
	end
end