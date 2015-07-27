local GlobalAddonName, ExRT = ...

local UnitAura, UnitIsDeadOrGhost, UnitIsConnected, UnitPower, UnitGUID, UnitName, UnitPosition, UnitInRange = UnitAura, UnitIsDeadOrGhost, UnitIsConnected, UnitPower, UnitGUID, UnitName, UnitPosition, UnitInRange
local GetTime, tonumber, tostring, sort, wipe, PI, pairs = GetTime, tonumber, tostring, table.sort, table.wipe, PI, pairs
local cos, sin, sqrt, acos, abs, floor, min, max, GGetPlayerMapPosition, GetPlayerFacing, GetNumGroupMembers = math.cos, math.sin, math.sqrt, acos, math.abs, math.floor, math.min, math.max, GetPlayerMapPosition, GetPlayerFacing, GetNumGroupMembers
local ClassColorNum, SetMapToCurrentZone, GetCurrentMapAreaID, GetCurrentMapDungeonLevel, GetRaidRosterInfo = ExRT.mds.classColorNum, SetMapToCurrentZone, GetCurrentMapAreaID, GetCurrentMapDungeonLevel, GetRaidRosterInfo
local YES, NO = YES, NO --prevent rangom changes

local VExRT = nil

local module = ExRT.mod:New("Bossmods",ExRT.L.bossmods,nil,true)
-----------------------------------------
-- functions
-----------------------------------------

local function RaidRank()
	local n = UnitInRaid("player") or 0
	local name,rank = GetRaidRosterInfo(n)
	if name then
		return rank
	end
	return 0
end

local GetPlayerMapPosition = nil
do
	local currentMap = 0
	local currentMapLevel = 0
	function GetPlayerMapPosition(...)
		local nowMap = GetCurrentMapAreaID()
		local nowMapLevel = GetCurrentMapDungeonLevel()
		if currentMap ~= nowMap or currentMapLevel ~= nowMapLevel then
			SetMapToCurrentZone()
			currentMap = GetCurrentMapAreaID()
			currentMapLevel = GetCurrentMapDungeonLevel()
		end
		return GGetPlayerMapPosition(...)
	end
end

-----------------------------------------
-- Ра-ден
-----------------------------------------
local RaDen = {}
RaDen.mainframe = nil
RaDen.party = nil
RaDen.unstableVita_id1 = 138308
RaDen.unstableVita_id2 = 138297
RaDen.vitaSensitivity_id = 138372

function RaDen:RefreshAll()
	local n = GetNumGroupMembers() or 0
	if n > 0 then
		local grps = {0,0,0,0}
		for j=1,n do
			local name,_,subgroup = GetRaidRosterInfo(j)
			if name and subgroup == 2 then
				grps[1] = grps[1] + 1
				RaDen.party[1][grps[1]] = name
			elseif name and subgroup == 4 then
				grps[2] = grps[2] + 1
				RaDen.party[2][grps[2]] = name
			elseif name and subgroup == 3 then
				grps[3] = grps[3] + 1
				RaDen.party[3][grps[3]] = name
			elseif name and subgroup == 5 then
				grps[4] = grps[4] + 1
				RaDen.party[4][grps[4]] = name
			end
		end
		for i=1,4 do
			for j=(grps[i]+1),5 do
				RaDen.party[i][j] = ""
			end
			sort(RaDen.party[i])
			for j=1,5 do
				RaDen.mainframe.names[(i-1)*5+j].text:SetText(RaDen.party[i][j])
			end
		end
	end
end

function RaDen:timerfunc(elapsed)
	self.tmr = self.tmr + elapsed
	if self.tmr > 0.2 then
		self.tmr = 0
		for i=1,4 do
			for j=1,5 do
				if RaDen.party[i][j] and RaDen.party[i][j] ~= "" then
					local white = true
					for k=1,40 do
						local _,_,_,_,_,duration,expires,_,_,_,spellId = UnitAura(RaDen.party[i][j],k,"HARMFUL")
						if spellId == RaDen.unstableVita_id1 or spellId == RaDen.unstableVita_id2 then
							RaDen.mainframe.names[(i-1)*5+j].text:SetTextColor(0.5, 1, 0.5, 1)
							white = nil
						elseif spellId == RaDen.vitaSensitivity_id then
							RaDen.mainframe.names[(i-1)*5+j].text:SetTextColor(1, 0.5, 0.5, 1)
							white = nil
						elseif not spellId then 
							break
						end
					end
					if white then
						RaDen.mainframe.names[(i-1)*5+j].text:SetTextColor(1, 1, 1, 1)
					end
					if UnitIsDeadOrGhost(RaDen.party[i][j]) or not UnitIsConnected(RaDen.party[i][j]) then
						RaDen.mainframe.names[(i-1)*5+j].text:SetTextColor(1, 0.5, 0.5, 1)
					end
				else
					RaDen.mainframe.names[(i-1)*5+j].text:SetTextColor(0.1, 0.1, 0.1, 1)
				end
			end
		end
	end
end

function RaDen:EventHandler(event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _,event_n,_,_,_,_,_,_,_,_,_,spellId = ...
		if event_n == "SPELL_AURA_APPLIED" and (spellId == RaDen.unstableVita_id1 or spellId == RaDen.unstableVita_id2) then
			RaDen.mainframe.vitacooldown.cooldown:SetCooldown(GetTime(), 5)
		end
	elseif event == "GROUP_ROSTER_UPDATE" then
		RaDen:RefreshAll()
	end
end

function RaDen:Load()
	if not RaDen.mainframe then
		RaDen.mainframe = CreateFrame("Frame","ExRTBossmodsRaden",UIParent)
		RaDen.mainframe:SetHeight(130)
		RaDen.mainframe:SetWidth(160)
		if VExRT.Bossmods.RaDenLeft and VExRT.Bossmods.RaDenTop then
			RaDen.mainframe:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.Bossmods.RaDenLeft,VExRT.Bossmods.RaDenTop)
		else
			RaDen.mainframe:SetPoint("TOP",UIParent, "TOP", 0, 0)
		end
		RaDen.mainframe:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.mds.defBorder,tile = false,edgeSize = 8})
		RaDen.mainframe:SetBackdropColor(0.05,0.05,0.05,0.85)
		RaDen.mainframe:SetBackdropBorderColor(0.2,0.2,0.2,0.4)
		RaDen.mainframe:EnableMouse(true)
		RaDen.mainframe:SetMovable(true)
		RaDen.mainframe:RegisterForDrag("LeftButton")
		RaDen.mainframe:SetScript("OnDragStart", function(self)
			if self:IsMovable() then
				self:StartMoving()
			end
		end)
		RaDen.mainframe:SetScript("OnDragStop", function(self)
			self:StopMovingOrSizing()
			VExRT.Bossmods.RaDenLeft = self:GetLeft()
			VExRT.Bossmods.RaDenTop = self:GetTop()
		end)
		if VExRT.Bossmods.Alpha then RaDen.mainframe:SetAlpha(VExRT.Bossmods.Alpha/100) end
		if VExRT.Bossmods.Scale then RaDen.mainframe:SetScale(VExRT.Bossmods.Scale/100) end
		
		RaDen.mainframe.tmr = 0

		RaDen.mainframe.names = {}

		for i=1,20 do
			RaDen.mainframe.names[i]=CreateFrame("Frame",nil,RaDen.mainframe)
			RaDen.mainframe.names[i]:SetSize(80,12)
			RaDen.mainframe.names[i]:SetPoint("TOPLEFT", (math.floor((i-1)/10))*80, -(((i-1)%10)*12)-5)
			RaDen.mainframe.names[i].text = RaDen.mainframe.names[i]:CreateFontString(nil,"ARTWORK")
			RaDen.mainframe.names[i].text:SetJustifyH("CENTER")
			RaDen.mainframe.names[i].text:SetFont(ExRT.mds.defFont, 12,"OUTLINE")
			local b = GetNumGuildMembers()
			local a
			if b == 0 then 
				a = UnitName("player")
			else 
				a = GetGuildRosterInfo(math.random(1,b)) 
			end
			RaDen.mainframe.names[i].text:SetText(a)
			if i%3==0 then RaDen.mainframe.names[i].text:SetTextColor(1, 0.5, 0.5, 1) end
			if i%3==1 then RaDen.mainframe.names[i].text:SetTextColor(0.5, 1, 0.5, 1) end
			if i%3==2 then RaDen.mainframe.names[i].text:SetTextColor(1, 1, 1, 1) end
			RaDen.mainframe.names[i].text:SetAllPoints()
		end

		RaDen.mainframe.vitacooldown = CreateFrame("Frame",nil,RaDen.mainframe)
		RaDen.mainframe.vitacooldown:SetHeight(32)
		RaDen.mainframe.vitacooldown:SetWidth(32)
		RaDen.mainframe.vitacooldown:SetPoint("TOPLEFT", 0, -130)
		RaDen.mainframe.vitacooldown.tex = RaDen.mainframe.vitacooldown:CreateTexture(nil, "BACKGROUND")
		local tx = GetSpellTexture(RaDen.unstableVita_id2)
		RaDen.mainframe.vitacooldown.tex:SetTexture(tx)
		RaDen.mainframe.vitacooldown.tex:SetAllPoints()
		RaDen.mainframe.vitacooldown.cooldown = CreateFrame("Cooldown", nil, RaDen.mainframe.vitacooldown)
		RaDen.mainframe.vitacooldown.cooldown:SetAllPoints()

		RaDen.party = {}
		for i=1,4 do RaDen.party[i]={} end
		RaDen:RefreshAll()

		RaDen.mainframe:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") 
		RaDen.mainframe:RegisterEvent("GROUP_ROSTER_UPDATE")
		RaDen.mainframe:SetScript("OnUpdate", RaDen.timerfunc)
		RaDen.mainframe:SetScript("OnEvent", RaDen.EventHandler)

		print(ExRT.L.bossmodsradenhelp)
	end
end

-----------------------------------------
-- Sha of Pride
-----------------------------------------
local ShaOfPride = {}
ShaOfPride.mainframe = nil
ShaOfPride.raid = {}
ShaOfPride.norushen = nil

function ShaOfPride:SetTextColor(j,c_r,c_g,c_b,c_a)
	ShaOfPride.mainframe.names[j].text:SetTextColor(c_r, c_g, c_b, c_a)
	ShaOfPride.mainframe.names[j].textr:SetTextColor(c_r, c_g, c_b, c_a)
end

function ShaOfPride.sortFunc(a,b)
	if(a[2]==b[2]) then 
		return a[1] < b[1] 
	else 
		return a[2] > b[2] 
	end
end

function ShaOfPride:timerfunc(elapsed)
	self.tmr = self.tmr + elapsed
	if self.tmr > 0.3 then
		self.tmr = 0
		for j=1,#ShaOfPride.raid do
			ShaOfPride.raid[j][2] = UnitPower(ShaOfPride.raid[j][1],10) or 0
		end
		sort(ShaOfPride.raid,ShaOfPride.sortFunc)
		for j=1,#ShaOfPride.raid do
			ShaOfPride.mainframe.names[j].text:SetText(ShaOfPride.raid[j][1])
			ShaOfPride.mainframe.names[j].textr:SetText(ShaOfPride.raid[j][2])
			if ShaOfPride.norushen == 1 then
				if ShaOfPride.raid[j][2]>=100 then ShaOfPride:SetTextColor(j, 1, 0.3, 0.3, 1)
					elseif ShaOfPride.raid[j][2]>=75 then ShaOfPride:SetTextColor(j, 1, 1, 0.2, 1)
					else ShaOfPride:SetTextColor(j, 1, 1, 1, 1) end
				for i=1,40 do
					local _,_,_,_,_,_,_,_,_,_,spellId = UnitAura(ShaOfPride.raid[j][1], i,"HARMFUL")
					if spellId == 144851 or spellId == 144849 or spellId == 144850 then ShaOfPride:SetTextColor(j, 0.5, 1, 0.3, 1) break
						elseif not spellId then break end
				end
			elseif ShaOfPride.norushen == 2 then
				if ShaOfPride.raid[j][2]>=100 then ShaOfPride:SetTextColor(j, 0.8, 0.3, 0.8, 1)
					elseif ShaOfPride.raid[j][2]>=75 then ShaOfPride:SetTextColor(j, 0.5, 0.5, 1, 1)
					elseif ShaOfPride.raid[j][2]>=50 then ShaOfPride:SetTextColor(j, 1, 0.3, 0.3, 1)
					elseif ShaOfPride.raid[j][2]>=25 then ShaOfPride:SetTextColor(j, 1, 1, 0.2, 1)
					else ShaOfPride:SetTextColor(j, 1, 1, 1, 1) end
			else
				ShaOfPride:SetTextColor(j, 1, 1, 1, 1)
			end
		end
	end
end

function ShaOfPride:RefreshAll()
	local n = GetNumGroupMembers() or 0
	local gMax = ExRT.mds.GetRaidDiffMaxGroup()
	if n > 0 then
		wipe(ShaOfPride.raid)
		for j=1,n do
			local name,_,subgroup = GetRaidRosterInfo(j)
			if name and subgroup <= gMax then
				ShaOfPride.raid[#ShaOfPride.raid + 1] = {name,UnitPower(name,10)}
			end
		end
		sort(ShaOfPride.raid,ShaOfPride.sortFunc)
		for j=1,#ShaOfPride.raid do if j<=25 then
			ShaOfPride.mainframe.names[j].text:SetText(ShaOfPride.raid[j][1].." "..tostring(ShaOfPride.raid[j][2]))
		end end
		for j=(#ShaOfPride.raid+1),25 do
			ShaOfPride.mainframe.names[j].text:SetText("")
			ShaOfPride.mainframe.names[j].textr:SetText("")
		end
	else
		for j=1,gMax*5 do
			local b = GetNumGuildMembers()
			local a
			if b == 0 then 
				a = UnitName("player")
			else 
				a = GetGuildRosterInfo(math.random(1,b)) 
			end
			local c = math.random(0,20)*5
			local h = math.random(1,3)
			if h == 3 then a = a..a..a elseif h == 2 then a = a..a end
			ShaOfPride.mainframe.names[j].text:SetText(a)
			ShaOfPride.mainframe.names[j].text:SetTextColor(0.1, 0.1, 0.1, 1)

			ShaOfPride.mainframe.names[j].textr:SetText(tostring(c))
			ShaOfPride.mainframe.names[j].textr:SetTextColor(0.1, 0.1, 0.1, 1)
		end
	end
end

function ShaOfPride:EventHandler(event, ...)
	if event == "GROUP_ROSTER_UPDATE" then
		ShaOfPride:RefreshAll()
	elseif event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT" then
		local bossGUID = UnitGUID("boss1")
		if not bossGUID then 
			return 
		end
		local bossMobID = ExRT.mds.GUIDtoID(bossGUID)
		if bossMobID == 72276 then
			ShaOfPride.norushen = 1
		elseif bossMobID == 71734 then
			ShaOfPride.norushen = 2
		else
			ShaOfPride.norushen = nil
		end
	end
end

function ShaOfPride:Load()
	if ShaOfPride.mainframe then 
		return 
	end
	ShaOfPride.mainframe = CreateFrame("Frame","ExRTBossmodsShaOfPride",UIParent)
	local gMax = ExRT.mds.GetRaidDiffMaxGroup()
	ShaOfPride.mainframe:SetSize(100,gMax*5*12+8)
	if VExRT.Bossmods.ShaofprideLeft and VExRT.Bossmods.ShaofprideTop then
		ShaOfPride.mainframe:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.Bossmods.ShaofprideLeft,VExRT.Bossmods.ShaofprideTop)
	else
		ShaOfPride.mainframe:SetPoint("TOP",UIParent, "TOP", 0, 0)	
	end
	ShaOfPride.mainframe:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.mds.defBorder,tile = false,edgeSize = 8})
	ShaOfPride.mainframe:SetBackdropColor(0.05,0.05,0.05,0.85)
	ShaOfPride.mainframe:SetBackdropBorderColor(0.2,0.2,0.2,0.4)
	ShaOfPride.mainframe:EnableMouse(true)
	ShaOfPride.mainframe:SetMovable(true)
	ShaOfPride.mainframe:RegisterForDrag("LeftButton")
	ShaOfPride.mainframe:SetScript("OnDragStart", function(self)
		if self:IsMovable() then
			self:StartMoving()
		end
	end)
	ShaOfPride.mainframe:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		VExRT.Bossmods.ShaofprideLeft = self:GetLeft()
		VExRT.Bossmods.ShaofprideTop = self:GetTop()
	end)
	if VExRT.Bossmods.Alpha then ShaOfPride.mainframe:SetAlpha(VExRT.Bossmods.Alpha/100) end
	if VExRT.Bossmods.Scale then ShaOfPride.mainframe:SetScale(VExRT.Bossmods.Scale/100) end

	ShaOfPride.mainframe.tmr = 0

	ShaOfPride.mainframe.names = {}

	for i=1,25 do
		ShaOfPride.mainframe.names[i]=CreateFrame("Frame",nil,ShaOfPride.mainframe)
		ShaOfPride.mainframe.names[i]:SetSize(100,12)
		ShaOfPride.mainframe.names[i]:SetPoint("TOPLEFT", 0, -((i-1)*12)-4)
		ShaOfPride.mainframe.names[i].text = ExRT.lib.CreateText(ShaOfPride.mainframe.names[i],71,12,nil,4,0,nil,"TOP",ExRT.mds.defFont,12,nil,nil,1,1,1,nil,1)
		ShaOfPride.mainframe.names[i].textr = ExRT.lib.CreateText(ShaOfPride.mainframe.names[i],50,12,"TOPRIGHT",-4,0,"RIGHT","TOP",ExRT.mds.defFont,12,nil,nil,1,1,1,nil,1)
	end

	ShaOfPride:RefreshAll()
	ShaOfPride.mainframe:RegisterEvent("GROUP_ROSTER_UPDATE")
	ShaOfPride.mainframe:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	ShaOfPride.mainframe:SetScript("OnUpdate", ShaOfPride.timerfunc)
	ShaOfPride.mainframe:SetScript("OnEvent", ShaOfPride.EventHandler)
end

-----------------------------------------
-- Malkorok
-----------------------------------------
local Malkorok = {}
Malkorok.mainframe = nil
Malkorok.tmr = 0
Malkorok.main_coord_top_x = 0.36427
Malkorok.main_coord_top_y = 0.34581
Malkorok.main_coord_bot_x = 0.46707
Malkorok.main_coord_bot_y = 0.50000
Malkorok.unitid = 71454
Malkorok.spell = 142842
Malkorok.spell_baoe = 142861
Malkorok.baoe_num = 0
Malkorok.raid_marks_p = nil
Malkorok.raid_marks_e = nil
Malkorok.rotate = false
Malkorok.center = 90
Malkorok.pie_coord = {
	{{90,90},{90,-5},{0,36}},	--1
	{{90,90},{0,36},{-1,141}},	--2
	{{90,90},{-1,141},{90,185}},	--3
	{{90,90},{90,185},{182,144}},	--4
	{{90,90},{182,144},{185,38}},	--5
	{{90,90},{185,38},{90,-5}},	--6
}
Malkorok.pie_status = {0,0,0,0,0,0,0,0}
Malkorok.def_angle = (PI/180)*8
Malkorok.rotate_coords={tl={x=0,y=0},br={x=180/256,y=180/256}}
Malkorok.rotate_origin={x=90/256,y=90/256}
Malkorok.rotate_angle = 0
Malkorok.maps = {
	--[map]={topX,topY,botX,botY},
	[0]={0.36427,0.34581,0.46707,0.500},
	[807]={0.5157,0.4745,0.5207,0.4853},
	--[807]={0.5168,0.4767,0.5201,0.4844},
	[811]={0.4284,0.4285,0.4426,0.4478},
	[891]={0.4337,0.4589,0.4559,0.5276},
	[492]={0.7361,0.2098,0.7473,0.2264},
	[953]={0.36427,0.34581,0.46707,0.50000},
}
Malkorok.maps_t = {
	--[map]={link,topX,botX,topY,botY},
	--[map]={[MapDungeonLevel]={...},[MapDungeonLevel]={...}},
	--[807]={"Interface\\AddOns\\ExRT\\media\\Bossmods_807",0.22,0.8799,0.2037,0.9167},
	[807]={"Interface\\AddOns\\ExRT\\media\\Bossmods_807"},
	[953]={[8]={"Interface\\AddOns\\ExRT\\media\\Bossmods_953_8",0.293,0.6875,0.293,0.6875}},
}

Malkorok.maps_a = {}

function Malkorok:Danger(u)
	if u and not Malkorok.mainframe.Danger.shown then
		Malkorok.mainframe.Danger:Show() 
		Malkorok.mainframe.Danger.shown = true
		Malkorok.mainframe:SetBackdropColor(0.5,0,0,0.7)
		Malkorok.mainframe:SetBackdropBorderColor(1,0.2,0.2,0.9)
	elseif not u and Malkorok.mainframe.Danger.shown then
		Malkorok.mainframe.Danger:Hide() 
		Malkorok.mainframe.Danger.shown = nil
		Malkorok.mainframe:SetBackdropColor(0,0,0,0.5)
		Malkorok.mainframe:SetBackdropBorderColor(0.2,0.2,0.2,0.4)
	end
end

function Malkorok:PShow()
	if not Malkorok.mainframe then return end 

	Malkorok.raid_marks_e = not Malkorok.raid_marks_e
	Malkorok.raid_marks_p = UnitName("player")

	if not Malkorok.mainframe.raidMarks then
		Malkorok.mainframe.raidMarks = {}
		local mSize = 12
		for i=1,40 do
			Malkorok.mainframe.raidMarks[i] = CreateFrame("Frame",nil,Malkorok.mainframe.main)
			Malkorok.mainframe.raidMarks[i]:SetSize(mSize,mSize)
			Malkorok.mainframe.raidMarks[i]:SetPoint("TOPLEFT", 0, 0)
			Malkorok.mainframe.raidMarks[i]:SetBackdrop({bgFile = "Interface\\AddOns\\ExRT\\media\\blip.tga",tile = true,tileSize = mSize})
			Malkorok.mainframe.raidMarks[i]:SetBackdropColor(0,1,0,0.8)
			Malkorok.mainframe.raidMarks[i]:SetFrameStrata("HIGH")
			Malkorok.mainframe.raidMarks[i]:Hide()
		end
	end
	if not Malkorok.raid_marks_e then
		for i=1,40 do
			Malkorok.mainframe.raidMarks[i]:Hide()
		end
	end
end

function Malkorok:MapNow()
	if not Malkorok.mainframe then return end 
	local mapNow = GetCurrentMapAreaID()
	if not Malkorok.maps_t[mapNow] then return end 
	local mp = Malkorok.maps_t[mapNow]

	local mapNowLevel = GetCurrentMapDungeonLevel()
	if type(Malkorok.maps_t[mapNow][1]) ~= "string" then
		if not mapNowLevel or not Malkorok.maps_t[mapNow][mapNowLevel] then return end
		mp = nil
		mp = Malkorok.maps_t[mapNow][mapNowLevel]
	end

	if not Malkorok.mainframe.main.t then
		Malkorok.mainframe.main.t = Malkorok.mainframe.main:CreateTexture(nil, "BACKGROUND")
		Malkorok.mainframe.main.t:SetAllPoints()
	end

	Malkorok.mainframe.main.t:SetTexture(mp[1])
	Malkorok.mainframe.main.t.xT = mp[2] or 0
	Malkorok.mainframe.main.t.xB = mp[3] or 1
	Malkorok.mainframe.main.t.yT = mp[4] or 0
	Malkorok.mainframe.main.t.yB = mp[5] or 1
	Malkorok.mainframe.main.t.xC = (Malkorok.mainframe.main.t.xB - Malkorok.mainframe.main.t.xT) / 2 + Malkorok.mainframe.main.t.xT
	Malkorok.mainframe.main.t.yC = (Malkorok.mainframe.main.t.yB - Malkorok.mainframe.main.t.yT) / 2 + Malkorok.mainframe.main.t.yT
	Malkorok.mainframe.main.t.r = 1

	for i=1,6 do
		Malkorok.mainframe.pie[i]:Hide()
	end
	Malkorok.def_angle = 0
end

function Malkorok:Cursor()
	local x,y = GetCursorPosition()

	local x1 = Malkorok.mainframe.main:GetLeft()
	local y1 = Malkorok.mainframe.main:GetTop()

	Malkorok.mainframe_scale = Malkorok.mainframe:GetScale()
	local uiparent_scale = UIParent:GetScale()
	x1 = x1 * Malkorok.mainframe_scale*uiparent_scale
	y1 = y1 * Malkorok.mainframe_scale*uiparent_scale

	x = x - x1
	y = -(y - y1)

	x = x / (Malkorok.mainframe_scale * uiparent_scale)
	y = y / (Malkorok.mainframe_scale * uiparent_scale)

	return x,y
end

function Malkorok.RotateCoordPair(x,y,ox,oy,a,asp)
	y=y/asp
	oy=oy/asp
	return ox + (x-ox)*cos(a) - (y-oy)*sin(a),(oy + (y-oy)*cos(a) + (x-ox)*sin(a))*asp
end

function Malkorok.RotateTexture(self,angle,xT,yT,xB,yB,xC,yC,userAspect)
	local aspect = userAspect or (xT-xB)/(yT-yB)
	local g1,g2 = Malkorok.RotateCoordPair(xT,yT,xC,yC,angle,aspect)
	local g3,g4 = Malkorok.RotateCoordPair(xT,yB,xC,yC,angle,aspect)
	local g5,g6 = Malkorok.RotateCoordPair(xB,yT,xC,yC,angle,aspect)
	local g7,g8 = Malkorok.RotateCoordPair(xB,yB,xC,yC,angle,aspect)

	self:SetTexCoord(g1,g2,g3,g4,g5,g6,g7,g8)
end

do
	if Malkorok.def_angle~=0 then
		for i=1,6 do 
			for j=2,3 do
				Malkorok.pie_coord[i][j][1],Malkorok.pie_coord[i][j][2] = Malkorok.RotateCoordPair(Malkorok.pie_coord[i][j][1],Malkorok.pie_coord[i][j][2],Malkorok.pie_coord[i][1][1],Malkorok.pie_coord[i][1][2],-Malkorok.def_angle,1)
			end 
		end
	end
end

function Malkorok.def_angle_rotate()
	for i=1,6 do		
		Malkorok.RotateTexture(Malkorok.mainframe.pie[i].tex,Malkorok.def_angle,Malkorok.rotate_coords.tl.x,Malkorok.rotate_coords.tl.y,Malkorok.rotate_coords.br.x,Malkorok.rotate_coords.br.y,Malkorok.rotate_origin.x,Malkorok.rotate_origin.y)
	end
end

function Malkorok:findpie(x0,y0,pxy)
	for i=1,6 do
		local x1,y1 = Malkorok.pie_coord[i][1][1],Malkorok.pie_coord[i][1][2]
		local x2,y2 = Malkorok.pie_coord[i][2][1],Malkorok.pie_coord[i][2][2]
		local x3,y3 = Malkorok.pie_coord[i][3][1],Malkorok.pie_coord[i][3][2]
		if Malkorok.rotate and pxy == 1 then
			x2,y2= Malkorok.RotateCoordPair(x2,y2,Malkorok.center,Malkorok.center,-Malkorok.rotate_angle+Malkorok.def_angle,1)
			x3,y3= Malkorok.RotateCoordPair(x3,y3,Malkorok.center,Malkorok.center,-Malkorok.rotate_angle+Malkorok.def_angle,1)
		end

		local r1 = (x1 - x0) * (y2 - y1) - (x2 - x1) * (y1 - y0)
		local r2 = (x2 - x0) * (y3 - y2) - (x3 - x2) * (y2 - y0)
		local r3 = (x3 - x0) * (y1 - y3) - (x1 - x3) * (y3 - y0)

		if (r1>=0 and r2>=0 and r3>=0) or (r1<=0 and r2<=0 and r3<=0) then 
			return i 
		end
	end
	return 0
end

do
	local timerElapsed = 0
	function Malkorok:timerfunc(elapsed)
		timerElapsed = timerElapsed + elapsed
		if timerElapsed > 0.05 then
			timerElapsed = 0
			local px, py = GetPlayerMapPosition("player")
			if px == 0 and py == 0 and not Malkorok.raid_marks_e then return end
			if px >= Malkorok.main_coord_top_x and px<=Malkorok.main_coord_bot_x and py>=Malkorok.main_coord_top_y and py<=Malkorok.main_coord_bot_y then
				if not Malkorok.mainframe.Player.shown then 
					Malkorok.mainframe.Player.shown = 1 
					Malkorok.mainframe.Player:Show() 
				end
				local px1 = (px-Malkorok.main_coord_top_x)/(Malkorok.main_coord_bot_x-Malkorok.main_coord_top_x)*180
				local py1 = (py-Malkorok.main_coord_top_y)/(Malkorok.main_coord_bot_y-Malkorok.main_coord_top_y)*180
	
				local numpie = Malkorok:findpie(px1,py1)
				
				if not Malkorok.rotate then
					Malkorok.mainframe.Player:SetPoint("TOPLEFT", px1 / Malkorok.mainframe.Player.scale -15, -py1 / Malkorok.mainframe.Player.scale +20)
					Malkorok.RotateTexture(Malkorok.mainframe.Player.Texture,GetPlayerFacing(),0,0,1,1,15/32,20/32)
					if Malkorok.mainframe.main.t and Malkorok.mainframe.main.t.r then
						Malkorok.mainframe.main.t:SetTexCoord(Malkorok.mainframe.main.t.xT,Malkorok.mainframe.main.t.xB,Malkorok.mainframe.main.t.yT,Malkorok.mainframe.main.t.yB)
						Malkorok.mainframe.main.t.r = nil
					end
				else
					local h1,h2,h3 = sqrt( (Malkorok.center-px1)^2 + (180-py1)^2 ),sqrt( (Malkorok.center-Malkorok.center)^2 + (180-Malkorok.center)^2 ),sqrt( (Malkorok.center-px1)^2 + (Malkorok.center-py1)^2 )
					local h4 = (h2^2+h3^2-h1^2)/(2*h2*h3)
	
					h4 = acos(h4)
					if px1<Malkorok.center then h4=360-h4 end
					h4 = -h4
					Malkorok.rotate_angle=PI/180*h4 + Malkorok.def_angle
	
					Malkorok.RotateTexture(Malkorok.mainframe.Player.Texture,Malkorok.rotate_angle+GetPlayerFacing()-Malkorok.def_angle,0,0,1,1,15/32,20/32)
					Malkorok.mainframe.Player:SetPoint("TOPLEFT", Malkorok.center / Malkorok.mainframe.Player.scale - 15, (-Malkorok.center - h3)/ Malkorok.mainframe.Player.scale +20)
	
					for i=1,6 do	
						Malkorok.RotateTexture(Malkorok.mainframe.pie[i].tex,Malkorok.rotate_angle,Malkorok.rotate_coords.tl.x,Malkorok.rotate_coords.tl.y,Malkorok.rotate_coords.br.x,Malkorok.rotate_coords.br.y,Malkorok.rotate_origin.x,Malkorok.rotate_origin.y)
					end
	
					if Malkorok.mainframe.main.t then
						Malkorok.RotateTexture(Malkorok.mainframe.main.t,Malkorok.rotate_angle,Malkorok.mainframe.main.t.xT,Malkorok.mainframe.main.t.yT,Malkorok.mainframe.main.t.xB,Malkorok.mainframe.main.t.yB,Malkorok.mainframe.main.t.xC,Malkorok.mainframe.main.t.yC,1)
						Malkorok.mainframe.main.t.r = 1
					end
				end
	
				if not Malkorok.mainframe.main.t then
					if numpie>0 and Malkorok.pie_status[numpie] == 1 then 
						Malkorok:Danger(1)
					elseif numpie==0 or Malkorok.pie_status[numpie] == 0 then
						Malkorok:Danger()
					end
				else
					if Malkorok.maps_a[floor(py1)+1] and Malkorok.maps_a[floor(py1)+1][floor(px1)+1] == 1 then Malkorok:Danger(1) else Malkorok:Danger() end
				end
			else
				if Malkorok.mainframe.Player.shown then 
					Malkorok.mainframe.Player.shown = nil 
					Malkorok.mainframe.Player:Hide() 
				end
				if Malkorok.rotate then
					for i=1,6 do
						Malkorok.mainframe.pie[i].tex:SetTexCoord(0,180/256,0,180/256)
					end	
					Malkorok.rotate_angle = 0
					if Malkorok.def_angle~=0 then Malkorok.def_angle_rotate() end
				end
				Malkorok:Danger()		
			end
	
			local n = GetNumGroupMembers() or 0
			if n > 0 and Malkorok.raid_marks_e then
				for j=1,n do
					local name,_,subgroup,_,_,class = GetRaidRosterInfo(j)
					if name and subgroup <= 5 and not UnitIsDeadOrGhost(name) and UnitIsConnected(name) and name ~= Malkorok.raid_marks_p then
						local px, py = GetPlayerMapPosition(name)
	
						if px >= Malkorok.main_coord_top_x and px<=Malkorok.main_coord_bot_x and py>=Malkorok.main_coord_top_y and py<=Malkorok.main_coord_bot_y then
							local px1 = (px-Malkorok.main_coord_top_x)/(Malkorok.main_coord_bot_x-Malkorok.main_coord_top_x)*180
							local py1 = (py-Malkorok.main_coord_top_y)/(Malkorok.main_coord_bot_y-Malkorok.main_coord_top_y)*180
	
							if Malkorok.rotate then
								px1,py1 = Malkorok.RotateCoordPair(px1,py1,Malkorok.center,Malkorok.center,-Malkorok.rotate_angle+Malkorok.def_angle,1)
							end
				
							local cR,cG,cB = ClassColorNum(class)
							Malkorok.mainframe.raidMarks[j]:SetBackdropColor(cR,cG,cB,1)
							Malkorok.mainframe.raidMarks[j]:SetPoint("TOPLEFT", px1 - 8, -py1 + 8)
							Malkorok.mainframe.raidMarks[j]:Show()
						else
							Malkorok.mainframe.raidMarks[j]:Hide()
						end
					else
						if Malkorok.mainframe.raidMarks[j] then Malkorok.mainframe.raidMarks[j]:Hide() end
					end
				end
			end
		end
	end
end

function Malkorok:EventHandler(event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _,event_n,_,_,_,_,_,destGUID,_,_,_,spellId = ...
		if event_n == "SPELL_CAST_SUCCESS" then
			if not (spellId == Malkorok.spell) then
				return
			end
			for i=1,6 do  
				Malkorok.pie_status[i]=0
				Malkorok.mainframe.pie[i].tex:SetVertexColor(0,1,0,0.8)
			end
			if Malkorok.baoe_num == 0 then 
				Malkorok.mainframe.aoecd.cooldown:SetCooldown(GetTime(), 60)
				Malkorok.baoe_num = 1
			else
				Malkorok.baoe_num = 0
			end
		elseif event_n == "SPELL_CAST_SUCCESS" then
			if not (spellId == Malkorok.spell_baoe) then
				return
			end
			Malkorok.baoe_num = 0
			Malkorok.mainframe.aoecd.cooldown:SetCooldown(GetTime(), 64)
			for i=1,6 do  
				Malkorok.pie_status[i]=0
				Malkorok.mainframe.pie[i].tex:SetVertexColor(0,1,0,0.8)
			end
		end
	elseif event == "ZONE_CHANGED_NEW_AREA" then
		SetMapToCurrentZone()
		local cmap = GetCurrentMapAreaID()
		if not Malkorok.maps[cmap] then cmap = 0 end
		Malkorok.main_coord_top_x = Malkorok.maps[cmap][1]
		Malkorok.main_coord_top_y = Malkorok.maps[cmap][2]
		Malkorok.main_coord_bot_x = Malkorok.maps[cmap][3]
		Malkorok.main_coord_bot_y = Malkorok.maps[cmap][4]	
	end
end

function Malkorok:addonMessage(sender, prefix, ...)
	if not Malkorok.mainframe then return end 
	if prefix == "malkorok" then
		local pienum,piecol = ...
		if not tonumber(pienum) or tonumber(pienum) == 0 then return end 
		pienum = tonumber(pienum)
		if pienum > 6 then return end
		if Malkorok.pie_status[pienum] == 0 and piecol == "R" then
			Malkorok.pie_status[pienum]=1
			Malkorok.mainframe.pie[pienum].tex:SetVertexColor(1,0,0,0.8)
		elseif Malkorok.pie_status[pienum] == 1 and piecol == "G" then
			Malkorok.pie_status[pienum]=0
			Malkorok.mainframe.pie[pienum].tex:SetVertexColor(0,1,0,0.8)
		end
	end
end

function Malkorok:Load()
	if Malkorok.mainframe then return end
	Malkorok.mainframe = CreateFrame("Frame","ExRTBossmodsMalkorok",UIParent)
	Malkorok.mainframe:SetSize(200,200)
	if VExRT.Bossmods.MalkorokLeft and VExRT.Bossmods.MalkorokTop then
		Malkorok.mainframe:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.Bossmods.MalkorokLeft,VExRT.Bossmods.MalkorokTop)
	else
		Malkorok.mainframe:SetPoint("TOP",UIParent, "TOP", 0, 0)
	end
	Malkorok.mainframe:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.mds.defBorder,tile = false,edgeSize = 8})
	Malkorok.mainframe:SetBackdropColor(0,0,0,0.5)
	Malkorok.mainframe:SetBackdropBorderColor(0.2,0.2,0.2,0.4)
	Malkorok.mainframe:EnableMouse(true)
	Malkorok.mainframe:SetMovable(true)
	Malkorok.mainframe:RegisterForDrag("LeftButton")
	Malkorok.mainframe:SetScript("OnDragStart", function(self)
		if self:IsMovable() then
			self:StartMoving()
		end
	end)

	Malkorok.mainframe:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		VExRT.Bossmods.MalkorokLeft = self:GetLeft()
		VExRT.Bossmods.MalkorokTop = self:GetTop()
	end)
	if VExRT.Bossmods.Alpha then Malkorok.mainframe:SetAlpha(VExRT.Bossmods.Alpha/100) end
	if VExRT.Bossmods.Scale then Malkorok.mainframe:SetScale(VExRT.Bossmods.Scale/100) end

	Malkorok.mainframe.main = CreateFrame("Frame",nil,Malkorok.mainframe)
	Malkorok.mainframe.main:SetSize(180,180)
	Malkorok.mainframe.main:SetPoint("TOPLEFT",10, -10)

	Malkorok.mainframe.pie = {}
	for i=1,6 do 
		Malkorok.mainframe.pie[i] = CreateFrame("Frame",nil,Malkorok.mainframe.main)
		Malkorok.mainframe.pie[i]:SetSize(180,180)
		Malkorok.mainframe.pie[i]:SetPoint("TOPLEFT", 0, 0)

		Malkorok.mainframe.pie[i].tex = Malkorok.mainframe.pie[i]:CreateTexture(nil, "BACKGROUND")
		Malkorok.mainframe.pie[i].tex:SetTexture("Interface\\AddOns\\ExRT\\media\\Pie"..i)
		Malkorok.mainframe.pie[i].tex:SetAllPoints()
		Malkorok.mainframe.pie[i].tex:SetTexCoord(0,180/256,0,180/256)
		Malkorok.mainframe.pie[i].tex:SetVertexColor(0,1,0,0.8)
		Malkorok.pie_status[i]=0
	end

	Malkorok.mainframe:SetScript("OnMouseDown", function(self,button)
		local j1,j2 = Malkorok:Cursor()

		if j1 < 6 and j2 < 6 then
			if not VExRT.Bossmods.MalkorokLock then
				Malkorok.mainframe.Lock.texture:SetTexture("Interface\\AddOns\\ExRT\\media\\lock.tga")
				Malkorok.mainframe:SetMovable(false)
				VExRT.Bossmods.MalkorokLock = true
			else
				Malkorok.mainframe.Lock.texture:SetTexture("Interface\\AddOns\\ExRT\\media\\un_lock.tga")
				Malkorok.mainframe:SetMovable(true)
				VExRT.Bossmods.MalkorokLock = nil
			end
		elseif j1 < 22 and j2 < 6 then
			if Malkorok.rotate then
				VExRT.Bossmods.MalkorokRotate = nil
				Malkorok.rotate = nil
				for i=1,6 do
					Malkorok.mainframe.pie[i].tex:SetTexCoord(0,180/256,0,180/256)
				end
				Malkorok.rotate_angle = 0
				if Malkorok.def_angle~=0 then Malkorok.def_angle_rotate() end	
			else
				VExRT.Bossmods.MalkorokRotate = true
				Malkorok.rotate = true
			end
		elseif j1 < 8 and j2 > 170 then
			VExRT.Bossmods.MalkorokIconHide = not VExRT.Bossmods.MalkorokIconHide
			if VExRT.Bossmods.MalkorokIconHide then
				Malkorok.mainframe.aoecd:Hide()
			else
				Malkorok.mainframe.aoecd:Show()
			end
		end	

		local numpie = Malkorok:findpie(j1,j2,1)
		if numpie>0 then
			if button == "LeftButton" then
				Malkorok.pie_status[numpie]=1
				Malkorok.mainframe.pie[numpie].tex:SetVertexColor(1,0,0,0.8)
			elseif button == "RightButton" then
				Malkorok.pie_status[numpie]=0
				Malkorok.mainframe.pie[numpie].tex:SetVertexColor(0,1,0,0.8)
			end
			local col = "R"
			if button == "RightButton" then col = "G" end
			if RaidRank()>0 then 
				ExRT.mds.SendExMsg("malkorok",tostring(numpie).."\t"..col) 
				ExRT.mds.SendExMsg("malkorok",tostring(numpie).."\t"..col,nil,nil,"MHADD")
			end
		end
	end)
	
	Malkorok.mainframe.Player = CreateFrame("Frame",nil,Malkorok.mainframe.main)
	Malkorok.mainframe.Player:SetSize(32,32)
	Malkorok.mainframe.Player.Texture =Malkorok.mainframe.Player:CreateTexture(nil, "ARTWORK")
	Malkorok.mainframe.Player.Texture:SetSize(32,32)
	Malkorok.mainframe.Player.Texture:SetPoint("TOPLEFT",0,0)
	Malkorok.mainframe.Player.Texture:SetTexture("Interface\\MINIMAP\\MinimapArrow")
	Malkorok.mainframe.Player.scale = 1
	Malkorok.mainframe.Player:SetScale(Malkorok.mainframe.Player.scale)

	Malkorok.mainframe.Danger = ExRT.lib.CreateText(Malkorok.mainframe,200,18,"TOP",0,15,"CENTER","TOP",ExRT.mds.defFont,18,ExRT.L.bossmodsmalkorokdanger,nil,1,0.2,0.2,nil,1)
	Malkorok.mainframe.Danger:Hide()

	Malkorok.mainframe.Lock = ExRT.lib.CreateIcon(Malkorok.mainframe,14,nil,2,-1,"Interface\\AddOns\\ExRT\\media\\un_lock.tga")
	if VExRT.Bossmods.MalkorokLock then 
		Malkorok.mainframe.Lock.texture:SetTexture("Interface\\AddOns\\ExRT\\media\\lock.tga")
		Malkorok.mainframe:SetMovable(false)
	end

	Malkorok.mainframe.Rotate = ExRT.lib.CreateIcon(Malkorok.mainframe,14,nil,18,-1,"Interface\\AddOns\\ExRT\\media\\icon-config.tga")
	Malkorok.mainframe.Rotate.texture:SetVertexColor(0.6,0.6,0.6,0.8)
	if VExRT.Bossmods.MalkorokRotate then 
		Malkorok.rotate = true
	else
		if Malkorok.def_angle~=0 then Malkorok.def_angle_rotate() end
	end

	Malkorok.mainframe.aoecd = ExRT.lib.CreateIcon(Malkorok.mainframe,32,"BOTTOMLEFT",2,1,nil)
	Malkorok.mainframe.aoecd.texture:SetTexture("Interface\\Icons\\Spell_Shadow_Shadesofdarkness")
	Malkorok.mainframe.aoecd.cooldown = CreateFrame("Cooldown", nil, Malkorok.mainframe.aoecd)
	Malkorok.mainframe.aoecd.cooldown:SetAllPoints()
	if VExRT.Bossmods.MalkorokIconHide then
		Malkorok.mainframe.aoecd:Hide()
	end

	Malkorok.mainframe:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") 
	Malkorok.mainframe:RegisterEvent("ZONE_CHANGED_NEW_AREA") 
	Malkorok.mainframe:SetScript("OnUpdate", Malkorok.timerfunc)
	Malkorok.mainframe:SetScript("OnEvent", Malkorok.EventHandler)

	print(ExRT.L.bossmodsmalkorokhelp)

	SetMapToCurrentZone()
	local currentAreaID = GetCurrentMapAreaID()
	if Malkorok.maps[currentAreaID] then
		Malkorok.main_coord_top_x = Malkorok.maps[currentAreaID][1]
		Malkorok.main_coord_top_y = Malkorok.maps[currentAreaID][2]
		Malkorok.main_coord_bot_x = Malkorok.maps[currentAreaID][3]
		Malkorok.main_coord_bot_y = Malkorok.maps[currentAreaID][4]
	end
end

-----------------------------------------
-- Malkorok AI
-----------------------------------------
local MalkorokAI = {}
MalkorokAI.mainframe = nil
MalkorokAI.pie = {0,0,0,0,0,0}
MalkorokAI.pie_raid = {}
MalkorokAI.pie_yellow = 0
MalkorokAI.tmr = 0
MalkorokAI.tmr2 = 0
MalkorokAI.spell_aoe = 143805

function MalkorokAI:timerfunc2(elapsed)
	MalkorokAI.tmr2 = MalkorokAI.tmr2 + elapsed
	if MalkorokAI.tmr2 > 5 then
		for i=1,6 do 
			if MalkorokAI.pie[i] == 1 and Malkorok.pie_status[i]==1 then
				Malkorok.mainframe.pie[i].tex:SetVertexColor(1,0,0,0.8)
			end
			MalkorokAI.pie[i] = 0
		end
		MalkorokAI.mainframe:SetScript("OnUpdate", nil)
		MalkorokAI.tmr2 = 0
	end
end

function MalkorokAI:timerfunc(elapsed)
	MalkorokAI.tmr = MalkorokAI.tmr + elapsed
	if MalkorokAI.tmr > 0.5 then
		for i=1,6 do 
			if MalkorokAI.pie[i] == 1 then
				Malkorok.mainframe.pie[i].tex:SetVertexColor(1,0.8,0,0.8)
			end
		end
		MalkorokAI.mainframe:SetScript("OnUpdate", MalkorokAI.timerfunc2)
		MalkorokAI.tmr = 0
	end
end

MalkorokAI.mainframe_2 = nil
MalkorokAI.tmr_do = 0
function MalkorokAI:timerfunc_do(elapsed)
	MalkorokAI.tmr_do = MalkorokAI.tmr_do + elapsed
	if MalkorokAI.tmr_do > 4.5 then
		local n = GetNumGroupMembers() or 0
		if n > 0 then
			local gMax = ExRT.mds.GetRaidDiffMaxGroup()
			for i=1,6 do MalkorokAI.pie_raid[i]=0 end
			for j=1,n do
				local name, _,subgroup = GetRaidRosterInfo(j)
				if name and subgroup <= gMax and not UnitIsDeadOrGhost(name) then
					local px, py = GetPlayerMapPosition(name)
					if px >= Malkorok.main_coord_top_x and px<=Malkorok.main_coord_bot_x and py>=Malkorok.main_coord_top_y and py<=Malkorok.main_coord_bot_y then
						local px1 = (px-Malkorok.main_coord_top_x)/(Malkorok.main_coord_bot_x-Malkorok.main_coord_top_x)*180
						local py1 = (py-Malkorok.main_coord_top_y)/(Malkorok.main_coord_bot_y-Malkorok.main_coord_top_y)*180
				
						local numpie = Malkorok:findpie(px1,py1)

						for i_a=1,40 do
							local _,_,_,_,_,_,_,_,_,_,auraSpellId = UnitAura(name, i_a,"HELPFUL")
							if not auraSpellId then 
								break
							elseif auraSpellId == 19263 or	--Deterrence
								auraSpellId == 110696 or--Ice Block druid
								auraSpellId == 110700 or--Divine Shield druid
								auraSpellId == 45438 or	--Ice Block
								auraSpellId == 47585 or	--Dispersion
								auraSpellId == 113862 or--Greater Invisibility
								auraSpellId == 110960 or--Greater Invisibility
								auraSpellId == 1022 or	--Hand of Protection
								auraSpellId == 642 then	--Divine Shield
									numpie = 0
							end
						end
						if numpie > 0 then 
							MalkorokAI.pie_raid[numpie] = MalkorokAI.pie_raid[numpie] + 1
						end
					end
				end
			end
			local minpieam = 40
			for i=1,6 do 
				minpieam = min(minpieam,MalkorokAI.pie_raid[i])
			end
			for i=1,6 do 
				if MalkorokAI.pie_raid[i]==minpieam then
					if RaidRank()>0 then 
						ExRT.mds.SendExMsg("malkorok",tostring(i).."\tR")
						ExRT.mds.SendExMsg("malkorok",tostring(i).."\tR",nil,nil,"MHADD")
					end
					MalkorokAI.pie[i] = 1
					Malkorok.pie_status[i]=1
				end
			end
			MalkorokAI.mainframe:SetScript("OnUpdate", MalkorokAI.timerfunc)
		end
		MalkorokAI.tmr_do = 0
		self:SetScript("OnUpdate", nil)
	end
end

function MalkorokAI:EventHandler(event,_,event_n,_,_,_,_,_,_,_,_,_,spellId)
	if event_n == "SPELL_CAST_SUCCESS" and spellId == MalkorokAI.spell_aoe then
		for i=1,6 do MalkorokAI.pie[i]=0 end
		MalkorokAI.tmr_do = 0
		MalkorokAI.mainframe_2:SetScript("OnUpdate", MalkorokAI.timerfunc_do)
	end
end

function MalkorokAI:Load()
	if not Malkorok.mainframe then return end
	if MalkorokAI.mainframe then return end

	MalkorokAI.mainframe = CreateFrame("Frame","ExRTBossmodsMalkorokAI",nil)
	if not MalkorokAI.mainframe_2 then MalkorokAI.mainframe_2 = CreateFrame("Frame") end

	MalkorokAI.mainframe:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") 
	MalkorokAI.mainframe:SetScript("OnEvent", MalkorokAI.EventHandler)

	MalkorokAI.mainframe.text = CreateFrame("SimpleHTML", nil,Malkorok.mainframe)
	MalkorokAI.mainframe.text:SetText("AI")
	MalkorokAI.mainframe.text:SetFont(ExRT.mds.defFont, 16,"OUTLINE")
	MalkorokAI.mainframe.text:SetHeight(12)
	MalkorokAI.mainframe.text:SetWidth(12)
	MalkorokAI.mainframe.text:SetPoint("CENTER", Malkorok.mainframe,"BOTTOMRIGHT", -12,12)
	MalkorokAI.mainframe.text:SetTextColor(1, 1, 1, 1)

	print(ExRT.L.bossmodsmalkorokaihelp)
end

-----------------------------------------
-- Spoils of Pandaria
-----------------------------------------
local SpoilsOfPandaria = {}
SpoilsOfPandaria.mainframe = nil
SpoilsOfPandaria.side1 = nil
SpoilsOfPandaria.side2 = nil
SpoilsOfPandaria.tmr = 0

SpoilsOfPandaria.tmp_point_b_x = 0.4153
SpoilsOfPandaria.tmp_point_b_y = 0.4013
SpoilsOfPandaria.tmp_point_t_x = 0.6516
SpoilsOfPandaria.tmp_point_t_y = 0.1602
SpoilsOfPandaria.tmp_point_tg = abs(( SpoilsOfPandaria.tmp_point_t_y-SpoilsOfPandaria.tmp_point_b_y ) / ( SpoilsOfPandaria.tmp_point_b_x-SpoilsOfPandaria.tmp_point_t_x ))

function SpoilsOfPandaria.findroom(px,py)
	if px < SpoilsOfPandaria.tmp_point_b_x or px > SpoilsOfPandaria.tmp_point_t_x or py < SpoilsOfPandaria.tmp_point_t_y or py > SpoilsOfPandaria.tmp_point_b_y then return 0 end

	local tg_1 = abs( SpoilsOfPandaria.tmp_point_b_x-px )
	local tg_2 = SpoilsOfPandaria.tmp_point_tg * tg_1
	local tg_y = SpoilsOfPandaria.tmp_point_b_y - tg_2

	if tg_y > py then return 1 else return 2 end
end

SpoilsOfPandaria.point_subRoom_b_x = 0.5633
SpoilsOfPandaria.point_subRoom_b_y = 0.3701
SpoilsOfPandaria.point_subRoom_t_x = 0.4885
SpoilsOfPandaria.point_subRoom_t_y = 0.1993
function SpoilsOfPandaria.findroom2(x0,y0)
	local side = (SpoilsOfPandaria.tmp_point_b_x - x0) * (SpoilsOfPandaria.tmp_point_t_y - SpoilsOfPandaria.tmp_point_b_y) - (SpoilsOfPandaria.tmp_point_t_x - SpoilsOfPandaria.tmp_point_b_x) * (SpoilsOfPandaria.tmp_point_b_y - y0)
	if side < 0 then --TOP side
		side = -1
	else
		side = 1
	end
	local subRoom = (SpoilsOfPandaria.point_subRoom_b_x - x0) * (SpoilsOfPandaria.point_subRoom_t_y - SpoilsOfPandaria.point_subRoom_b_y) - (SpoilsOfPandaria.point_subRoom_t_x - SpoilsOfPandaria.point_subRoom_b_x) * (SpoilsOfPandaria.point_subRoom_b_y - y0)
	if subRoom < 0 then --LEFT room
		subRoom = 1
	else
		subRoom = 2
	end
	local room = side * subRoom
	if room < 0 then
		return room + 3
	else
		return room + 2
	end
	-- 1: TOP Mogu
	-- 2: TOP Klaxxi
	-- 3: BOTTOM: Klaxxi
	-- 4: BOTTOM: Mogu
end

function SpoilsOfPandaria:timerfunc(elapsed)
	SpoilsOfPandaria.tmr = SpoilsOfPandaria.tmr + elapsed
	if SpoilsOfPandaria.tmr > 1 then
		SpoilsOfPandaria.tmr = 0
		local o = {[1]=-1,[2]=-1,[0]=-1}
		local n = GetNumGroupMembers() or 0
		if n > 0 then
			for j=1,n do
				local name,_,subgroup = GetRaidRosterInfo(j)
				if name and subgroup <= 5 and UnitIsDeadOrGhost(name) ~= 1 and UnitIsConnected(name) then
					local px, py = GetPlayerMapPosition(name)
					local pr = SpoilsOfPandaria.findroom(px,py)
					if o[pr] < UnitPower(name,10) then
						o[pr] = UnitPower(name,10)
					end
				end
			end
			for j=1,2 do
				SpoilsOfPandaria.mainframe.side[j].pts = o[j]
				if o[j]==-1 then 
					SpoilsOfPandaria.mainframe.side[j].text:SetText("?") 
				else 
					SpoilsOfPandaria.mainframe.side[j].text:SetText(SpoilsOfPandaria.mainframe.side[j].pts) 
				end
			end
		else
			for j=1,2 do
				SpoilsOfPandaria.mainframe.side[j].text:SetText("?")
				SpoilsOfPandaria.mainframe.side[j].pts = 0
			end
		end
	end
end

SpoilsOfPandaria.roomNames = {
	ExRT.L.BossmodsSpoilsofPandariaMogu,
	ExRT.L.BossmodsSpoilsofPandariaKlaxxi,
	ExRT.L.BossmodsSpoilsofPandariaKlaxxi,
	ExRT.L.BossmodsSpoilsofPandariaMogu,
}
function SpoilsOfPandaria:onEvent(event,unitID,_,_,_,spellID)
  	if unitID:find("^raid%d+$") and spellID == 144229 then
		local name = ExRT.mds.UnitCombatlogname(unitID)	
		if name then
			local px, py = GetPlayerMapPosition(unitID)
			local room = SpoilsOfPandaria.findroom2(px, py)
			local color = ExRT.mds.classColorByGUID(UnitGUID(unitID))
			local ctime_ = ExRT.mds.GetEncounterTime() or 0
			print(format("%d:%02d",ctime_/60,ctime_%60).." |c"..color..name.."|r ".. ExRT.L.BossmodsSpoilsofPandariaOpensBox .." "..SpoilsOfPandaria.roomNames[room])
		end
	end
end

function SpoilsOfPandaria:Load()
	if SpoilsOfPandaria.mainframe then return end
	SpoilsOfPandaria.mainframe = CreateFrame("Frame","ExRTBossmodsSpoilsOfPandaria",UIParent)
	SpoilsOfPandaria.mainframe:SetSize(70,50)
	if VExRT.Bossmods.SpoilsofPandariaLeft and VExRT.Bossmods.SpoilsofPandariaTop then
		SpoilsOfPandaria.mainframe:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.Bossmods.SpoilsofPandariaLeft,VExRT.Bossmods.SpoilsofPandariaTop)
	else
		SpoilsOfPandaria.mainframe:SetPoint("TOP",UIParent, "TOP", 0, 0)
	end
	SpoilsOfPandaria.mainframe:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.mds.defBorder,tile = false,edgeSize = 8})
	SpoilsOfPandaria.mainframe:SetBackdropColor(0.05,0.05,0.05,0.85)
	SpoilsOfPandaria.mainframe:SetBackdropBorderColor(0.2,0.2,0.2,0.4)
	SpoilsOfPandaria.mainframe:EnableMouse(true)
	SpoilsOfPandaria.mainframe:SetMovable(true)
	SpoilsOfPandaria.mainframe:RegisterForDrag("LeftButton")
	SpoilsOfPandaria.mainframe:SetScript("OnDragStart", function(self)
		if self:IsMovable() then
			self:StartMoving()
		end
	end)
	SpoilsOfPandaria.mainframe:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		VExRT.Bossmods.SpoilsofPandariaLeft = self:GetLeft()
		VExRT.Bossmods.SpoilsofPandariaTop = self:GetTop()
	end)
	if VExRT.Bossmods.Alpha then SpoilsOfPandaria.mainframe:SetAlpha(VExRT.Bossmods.Alpha/100) end
	if VExRT.Bossmods.Scale then SpoilsOfPandaria.mainframe:SetScale(VExRT.Bossmods.Scale/100) end


	SpoilsOfPandaria.mainframe.side = {}
	for i=1,2 do
		SpoilsOfPandaria.mainframe.side[i] = CreateFrame("Frame",nil,SpoilsOfPandaria.mainframe)
		SpoilsOfPandaria.mainframe.side[i]:SetSize(70,20)
		SpoilsOfPandaria.mainframe.side[i].text = SpoilsOfPandaria.mainframe.side[i]:CreateFontString(nil,"ARTWORK")
		SpoilsOfPandaria.mainframe.side[i].text:SetJustifyH("CENTER")	
		SpoilsOfPandaria.mainframe.side[i].text:SetFont(ExRT.mds.defFont, 20,"OUTLINE")	
		SpoilsOfPandaria.mainframe.side[i].text:SetText("100")
		SpoilsOfPandaria.mainframe.side[i].text:SetTextColor(1, 1, 1, 1)
		SpoilsOfPandaria.mainframe.side[i].text:SetAllPoints()
		SpoilsOfPandaria.mainframe.side[i].pts = 0
	end
	SpoilsOfPandaria.mainframe.side[1]:SetPoint("TOPLEFT", 0, -5)
	SpoilsOfPandaria.mainframe.side[2]:SetPoint("TOPLEFT", 0, -25)

	SpoilsOfPandaria.mainframe:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED')
	SpoilsOfPandaria.mainframe:SetScript("OnUpdate", SpoilsOfPandaria.timerfunc)
	SpoilsOfPandaria.mainframe:SetScript("OnEvent", SpoilsOfPandaria.onEvent)
end

-----------------------------------------
-- Kromog
-----------------------------------------
local Kromog = {}
Kromog.runes = {
	{3673.47,329.81},
	{3669.83,320.84},
	{3667.69,309.80},
	{3663.56,334.03},
	{3661.87,325.15},
	{3660.95,315.54},
	{3659.29,303.60},
	{3652.30,324.41},
	{3650.33,315.57},
	{3649.88,332.94},
	{3649.72,306.76},
	{3642.71,324.18},
	{3641.32,315.93},
	{3640.92,308.55},
	{3636.36,331.65},
	{3633.00,304.03},
	{3632.95,317.41},
	{3631.94,310.38},
	{3630.81,325.00},
	{3624.18,317.63},
	{3623.51,306.16},
	{3623.30,330.92},
	{3617.37,312.64},
	{3615.52,323.41},
	{3612.18,306.78},
	{3611.77,333.36},
	{3605.63,318.56},
	{3604.92,328.65},
	{3603.65,308.19},
	{3597.34,336.12},
	{3596.64,325.87},
	{3594.69,315.58},
	{3594.69,306.78},--Добавлена вручную
	{3587.57,323.10},
	{3587.45,333.16},
}
Kromog.map = {3938.75,611.333,3001,-13.833}	--xT,yT,xB,yB
Kromog.image = {190/772,199/515,322/772,271/515}	-- KromogMap.tga 512х291
--Kromog.image = {0,0,1,1}
Kromog.width = 1024	--712
Kromog.image_avg = 291 / 512

Kromog.hidePlayers = true
function Kromog:UpdateSelectRoster()
	local setup = {}
	for i=1,#Kromog.runes do
		local name = VExRT.Bossmods.Kromog[i]
		if name then
			setup[name] = true
		end
	end
	local raidData = {{},{},{},{},{},{}}
	for i=1,40 do
		local name,_,subgroup,_,_,class = GetRaidRosterInfo(i)
		if name and subgroup <= 6 then
			raidData[subgroup][ #raidData[subgroup]+1 ] = {name,class}
		end
	end
	for i=1,6 do
		for j=1,5 do
			local pos = (i-1)*5+j
			local data = raidData[i][j]
			if Kromog.raidRoster.buttons[pos] and data then
				Kromog.raidRoster.buttons[pos]._name = data[1]
				if Kromog.hidePlayers then
					if setup[ data[1] ] then
						Kromog.raidRoster.buttons[pos]:SetAlpha(.2)
					else
						Kromog.raidRoster.buttons[pos]:SetAlpha(1)
					end
				else
					Kromog.raidRoster.buttons[pos]:SetAlpha(1)
				end
				Kromog.raidRoster.buttons[pos].name:SetText("|c"..ExRT.mds.classColor(data[2])..data[1])
				Kromog.raidRoster.buttons[pos]:Show()
			elseif Kromog.raidRoster.buttons[pos] then
				Kromog.raidRoster.buttons[pos]:Hide()
			end
		end
	end
end

function Kromog:ReRoster()
	local playerName = UnitName('player')
	for i=1,#Kromog.runes do
		local name = VExRT.Bossmods.Kromog[i]
		if name then
			local shortName = ExRT.mds.delUnitNameServer(name)
			local class = select(2,UnitClass(shortName))
			if class then
				class = "|c"..ExRT.mds.classColor(class)
			else
				class = ""
			end
			if shortName == playerName then
				Kromog.setupFrame.pings[i].icon:SetVertexColor(1,0.3,0.3,1)
			else
				Kromog.setupFrame.pings[i].icon:SetVertexColor(1,1,1,1)
			end
			Kromog.setupFrame.pings[i].name:SetText(class..name)
		else
			Kromog.setupFrame.pings[i].name:SetText("")
			Kromog.setupFrame.pings[i].icon:SetVertexColor(.3,1,.3,1)
		end
	end
end

function Kromog:Load()
	if Kromog.setupFrame then
		Kromog:ReRoster()
		Kromog.setupFrame:Show()
		if not VExRT.Bossmods.Kromog.DisableArrow then
			Kromog.setupFrame:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
		end
		if InterfaceOptionsFrame:IsShown() then
			InterfaceOptionsFrame:Hide()
		end
		if ExRT.Options.Frame:IsShown() then
			ExRT.Options.Frame:Hide()
		end
		Kromog.setupFrame.isEnabled = true
		return
	end
	Kromog.setupFrame = ExRT.lib.CreatePopupFrame(Kromog.width + 8,Kromog.image_avg * Kromog.width + 35,"Kromog")
	Kromog.setupFrame.map = Kromog.setupFrame:CreateTexture()
	Kromog.setupFrame.map:SetTexture("Interface\\AddOns\\ExRT\\media\\KromogMap.tga")
	Kromog.setupFrame.map:SetPoint("TOP",Kromog.setupFrame,"TOP",0,-30)
	Kromog.setupFrame.map:SetSize(Kromog.width,Kromog.image_avg * Kromog.width)
	Kromog.setupFrame.map:SetTexCoord(0,1,0,291 / 512)
	Kromog.setupFrame:SetFrameStrata("HIGH")
	
	Kromog.setupFrame.isEnabled = true
	
	local function DisableSync()
		VExRT.Bossmods.Kromog.sync = nil
		if VExRT.Bossmods.Kromog.name and VExRT.Bossmods.Kromog.time then
			Kromog.setupFrame.lastUpdate:SetText(ExRT.L.BossmodsKromogLastUpdate..": "..VExRT.Bossmods.Kromog.name.." ("..date("%H:%M:%S %d.%m.%Y",VExRT.Bossmods.Kromog.time)..")"..(not VExRT.Bossmods.Kromog.sync and " *" or ""))
		else
			Kromog.setupFrame.lastUpdate:SetText("")
		end
	end
	
	local function KromogFrameOnEvent(self,event,unitID,spell,_,lineID,spellID)
		if --(event == "UNIT_SPELLCAST_SUCCEEDED" and (spellID == 20473 or spellID == 774)) or 
		   (event == "CHAT_MSG_RAID_BOSS_EMOTE" and unitID:find("spell:157059")) then
			local playerName = UnitName('player')
			for i=1,#Kromog.runes do
				local name = VExRT.Bossmods.Kromog[i]
				if name and ExRT.mds.delUnitNameServer(name) == playerName then
					ExRT.mds.Arrow:ShowRunTo(Kromog.runes[i][1],Kromog.runes[i][2],2,10,true,true)
					return
				end
			end

		end
	end

	Kromog.setupFrame.pings = {}
	local function SetupFramePingsOnEnter(self)
		self.colors = {self.icon:GetVertexColor()}
		self.icon:SetVertexColor(1,.3,1,1)
	end
	local function SetupFramePingsOnLeave(self)
	  	self.icon:SetVertexColor(unpack(self.colors))
	end
	local function SetupFramePingsOnClick(self,button)
		if button == "RightButton" then
			self.colors = {.3,1,.3,1}
			VExRT.Bossmods.Kromog[self._i] = nil
			Kromog:ReRoster()
			
			DisableSync()
			return
		end
		Kromog.raidRoster.pos = self._i
		Kromog.raidRoster.title:SetText(ExRT.L.BossmodsKromogSelectPlayer..self._i)
		Kromog.raidRoster:Show()
	end
	for i=1,#Kromog.runes do
		local x = (abs(Kromog.runes[i][1]-Kromog.map[1])) / (abs(Kromog.map[3] - Kromog.map[1]))
		local y = (abs(Kromog.runes[i][2]-Kromog.map[2])) / (abs(Kromog.map[4] - Kromog.map[2]))
		Kromog.setupFrame.pings[i] = CreateFrame('Button',nil,Kromog.setupFrame)
		Kromog.setupFrame.pings[i]:SetSize(32,32)
		Kromog.setupFrame.pings[i].icon = Kromog.setupFrame.pings[i]:CreateTexture(nil,"ARTWORK")
		Kromog.setupFrame.pings[i].icon:SetAllPoints()
		Kromog.setupFrame.pings[i].icon:SetTexture("Interface\\AddOns\\ExRT\\media\\KromogRune.tga")
		Kromog.setupFrame.pings[i].num = ExRT.lib.CreateText(Kromog.setupFrame.pings[i],30,15,nil,0,0,"LEFT","TOP",nil,12,i,nil,1,1,1,nil,1)
		ExRT.lib.SetPoint(Kromog.setupFrame.pings[i].num,"TOPLEFT",Kromog.setupFrame.pings[i],"TOPLEFT",0,0)
		Kromog.setupFrame.pings[i].name = ExRT.lib.CreateText(Kromog.setupFrame.pings[i],75,15,nil,0,0,"LEFT","TOP",nil,11,"Player"..i,nil,1,1,1,nil,1)
		ExRT.lib.SetPoint(Kromog.setupFrame.pings[i].name,"TOPLEFT",Kromog.setupFrame.pings[i],"TOPLEFT",0,-12)
		
		Kromog.setupFrame.pings[i]:SetScript("OnEnter",SetupFramePingsOnEnter)
		Kromog.setupFrame.pings[i]:SetScript("OnLeave",SetupFramePingsOnLeave)
		Kromog.setupFrame.pings[i]:RegisterForClicks("RightButtonDown","LeftButtonDown")
		Kromog.setupFrame.pings[i]._i = i
		Kromog.setupFrame.pings[i]:SetScript("OnClick",SetupFramePingsOnClick)
		
		if x >= Kromog.image[1] and x <= Kromog.image[3] and y >= Kromog.image[2] and y <= Kromog.image[4] then
			Kromog.setupFrame.pings[i]:SetPoint("CENTER",Kromog.setupFrame.map,"TOPLEFT", (x - Kromog.image[1])/(Kromog.image[3]-Kromog.image[1])*Kromog.width,-(y - Kromog.image[2])/(Kromog.image[4]-Kromog.image[2])*(Kromog.image_avg * Kromog.width))
		end
	end
	
	local function KromogClearConfirm()
		for i=1,#Kromog.runes do
			VExRT.Bossmods.Kromog[i] = nil
		end
		Kromog:ReRoster()
		
		DisableSync()
	end
	
	Kromog.setupFrame.clearButton = ExRT.lib.CreateButton(Kromog.setupFrame,120,22,nil,0,0,ExRT.L.BossmodsKromogClear)
	ExRT.lib.SetPoint(Kromog.setupFrame.clearButton,"BOTTOMRIGHT",Kromog.setupFrame,"BOTTOMRIGHT",-15,10)
	Kromog.setupFrame.clearButton:SetScript("OnClick",function (self)
		StaticPopupDialogs["EXRT_BOSSMODS_KROMOG_CLEAR"] = {
			text = ExRT.L.BossmodsKromogClear,
			button1 = YES,
			button2 = NO,
			OnAccept = KromogClearConfirm,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("EXRT_BOSSMODS_KROMOG_CLEAR")
	end)
	
	Kromog.setupFrame.byName = ExRT.lib.CreateButton(Kromog.setupFrame,120,22,nil,0,0,ExRT.L.BossmodsKromogSort)
	ExRT.lib.SetPoint(Kromog.setupFrame.byName,"BOTTOMRIGHT",Kromog.setupFrame.clearButton,"TOPRIGHT",0,0)
	Kromog.setupFrame.byName:SetScript("OnClick",function (self)
		local raid = {}
		for i=1,30 do
			local name = GetRaidRosterInfo(i)
			if name then
				raid[#raid+1] = name
			end
		end
		sort(raid)
		for i=1,max(#raid,#Kromog.runes) do
			VExRT.Bossmods.Kromog[i] = raid[i]
		end
		for i=#raid+1,#Kromog.runes do
			VExRT.Bossmods.Kromog[i] = nil
		end
		Kromog:ReRoster()
		
		DisableSync()
	end)
	
	local function SetupsDropDown_Load(_,arg)
		for i=1,#Kromog.runes do
			VExRT.Bossmods.Kromog[i] = VExRT.Bossmods.KromogSetups[arg][i]
		end
		Kromog:ReRoster()
		DisableSync()
		CloseDropDownMenus()
	end
	local function SetupsDropDown_Clear(_,arg)
		for i=1,#Kromog.runes do
			VExRT.Bossmods.KromogSetups[arg][i] = nil
		end
		VExRT.Bossmods.KromogSetups[arg].date = nil
		CloseDropDownMenus()
	end
	local function SetupsDropDown_Save(_,arg)
		for i=1,#Kromog.runes do
			VExRT.Bossmods.KromogSetups[arg][i] = VExRT.Bossmods.Kromog[i]
		end
		VExRT.Bossmods.KromogSetups[arg].date = time()
		CloseDropDownMenus()
	end
	local function SetupsDropDown_Close()
		CloseDropDownMenus()
	end
	
	local setupsDropDown = CreateFrame("Frame", "ExRT_Kromog_SetupsDropDown", nil, "UIDropDownMenuTemplate")
	Kromog.setupFrame.setupsButton = ExRT.lib.CreateButton(Kromog.setupFrame,120,22,nil,0,0,ExRT.L.BossmodsKromogSetups)
	ExRT.lib.SetPoint(Kromog.setupFrame.setupsButton,"BOTTOMRIGHT",Kromog.setupFrame.byName,"TOPRIGHT",0,0)
	Kromog.setupFrame.setupsButton:SetScript("OnClick",function (self)
		VExRT.Bossmods.KromogSetups = VExRT.Bossmods.KromogSetups or {}
	
		local dropDown = {
			{ text = ExRT.L.BossmodsKromogSetups, isTitle = true, notCheckable = true, notClickable = true},
		}
		for i=1,5 do
			VExRT.Bossmods.KromogSetups[i] = VExRT.Bossmods.KromogSetups[i] or {}
		
			local subMenu = nil
			local saveMenu = { text = ExRT.L.BossmodsKromogSetupsSave, func = SetupsDropDown_Save, arg1 = i, notCheckable = true }
			local loadMenu = { text = ExRT.L.BossmodsKromogSetupsLoad, func = SetupsDropDown_Load, arg1 = i, notCheckable = true }
			local clearMenu = { text = ExRT.L.BossmodsKromogSetupsClear, func = SetupsDropDown_Clear, arg1 = i, notCheckable = true }
			
			local isExists = VExRT.Bossmods.KromogSetups[i].date
			local dateText = ""
			if isExists then
				subMenu = {loadMenu,saveMenu,clearMenu}
				dateText = ". "..date("%H:%M:%S %d.%m.%Y",isExists)
			else
				subMenu = {saveMenu}
			end
			
			dropDown[i+1] = {
				text = i..dateText, hasArrow = true, menuList = subMenu, notCheckable = true
			}
		end
		dropDown[7] = { text = ExRT.L.BossmodsKromogSetupsClose, func = SetupsDropDown_Close, notCheckable = true }
		EasyMenu(dropDown, setupsDropDown, "cursor", 10 , -15, "MENU")
	end)
		
	Kromog.setupFrame.sendButton = ExRT.lib.CreateButton(Kromog.setupFrame,120,22,nil,0,0,ExRT.L.BossmodsKromogSend)
	ExRT.lib.SetPoint(Kromog.setupFrame.sendButton,"BOTTOMRIGHT",Kromog.setupFrame.setupsButton,"TOPRIGHT",0,0)
	Kromog.setupFrame.sendButton:SetScript("OnClick",function (self)
		local line = ""
		for i=1,#Kromog.runes do
			line = line .. i.."\t"..(VExRT.Bossmods.Kromog[i] or "-").."\t"
			if i%3 == 0 then
				ExRT.mds.SendExMsg("kromog",line)
				line = ""
			end
		end
		if line ~= "" then
			ExRT.mds.SendExMsg("kromog",line)
		end
	end)
	
	Kromog.setupFrame.testButton = ExRT.lib.CreateButton(Kromog.setupFrame,120,22,nil,0,0,ExRT.L.BossmodsKromogTest)
	ExRT.lib.SetPoint(Kromog.setupFrame.testButton,"RIGHT",Kromog.setupFrame.clearButton,"LEFT",0,0)
	Kromog.setupFrame.testButton:SetScript("OnClick",function (self)
		KromogFrameOnEvent(Kromog.setupFrame,"CHAT_MSG_RAID_BOSS_EMOTE","spell:157059")
	end)
	
	Kromog.setupFrame.disableArrowChk = ExRT.lib.CreateCheckBox(Kromog.setupFrame,nil,0,0,ExRT.L.BossmodsKromogDisableArrow,VExRT.Bossmods.Kromog.DisableArrow)
	ExRT.lib.SetPoint(Kromog.setupFrame.disableArrowChk,"BOTTOMLEFT",Kromog.setupFrame.sendButton,"TOPLEFT",-3,0)
	Kromog.setupFrame.disableArrowChk:SetScale(0.9)
	Kromog.setupFrame.disableArrowChk:SetScript("OnClick",function (self)
		if self:GetChecked() then
			VExRT.Bossmods.Kromog.DisableArrow = true
			Kromog.setupFrame:UnregisterAllEvents()
		else
			VExRT.Bossmods.Kromog.DisableArrow = nil
			Kromog.setupFrame:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
		end
	end)
	
	Kromog.setupFrame.onlyTrustedChk = ExRT.lib.CreateCheckBox(Kromog.setupFrame,nil,0,0,ExRT.L.BossmodsKromogOnlyTrusted,not VExRT.Bossmods.Kromog.UpdatesFromAll,ExRT.L.BossmodsKromogOnlyTrustedTooltip)
	ExRT.lib.SetPoint(Kromog.setupFrame.onlyTrustedChk,"BOTTOMLEFT",Kromog.setupFrame.disableArrowChk,"TOPLEFT",0,-7)
	Kromog.setupFrame.onlyTrustedChk:SetScale(0.9)
	Kromog.setupFrame.onlyTrustedChk:SetScript("OnClick",function (self)
		if self:GetChecked() then
			VExRT.Bossmods.Kromog.UpdatesFromAll = nil
		else
			VExRT.Bossmods.Kromog.UpdatesFromAll = true
		end
	end)
	
	Kromog.setupFrame.lastUpdate = ExRT.lib.CreateText(Kromog.setupFrame,500,20,nil,0,0,"LEFT","BOTTOM",nil,12,"",nil,1,1,1,nil,1)
	ExRT.lib.SetPoint(Kromog.setupFrame.lastUpdate,"BOTTOMLEFT",Kromog.setupFrame,"BOTTOMLEFT",15,13)


	Kromog.raidRoster = ExRT.lib.CreatePopupFrame(80*6+25,113+14,ExRT.L.BossmodsKromogSelectPlayer)
	Kromog.raidRoster:SetScript("OnShow",function (self)
		Kromog:UpdateSelectRoster()
	end)
	Kromog.raidRoster.buttons = {}
	local function RaidRosterButtonOnEnter(self)
		self.hl:Show()
	end
	local function RaidRosterButtonOnLeave(self)
		self.hl:Hide()
	end
	local function RaidRosterButtonOnClick(self)
		for i=1,#Kromog.runes do
			if VExRT.Bossmods.Kromog[i] == self._name then
				VExRT.Bossmods.Kromog[i] = nil
			end
		end
		VExRT.Bossmods.Kromog[Kromog.raidRoster.pos] = self._name
		Kromog:ReRoster()
		Kromog.raidRoster:Hide()
		
		DisableSync()
	end
	for i=1,6 do
		for j=1,5 do
			local pos = (i-1)*5+j
			Kromog.raidRoster.buttons[pos] = CreateFrame('Button',nil,Kromog.raidRoster)
			Kromog.raidRoster.buttons[pos]:SetPoint("TOPLEFT",15+(i-1)*80,-30-(j-1)*14)
			Kromog.raidRoster.buttons[pos]:SetSize(80,14)
			ExRT.lib.CreateHoverHighlight(Kromog.raidRoster.buttons[pos])
			Kromog.raidRoster.buttons[pos]:SetScript("OnEnter",RaidRosterButtonOnEnter)
			Kromog.raidRoster.buttons[pos]:SetScript("OnLeave",RaidRosterButtonOnLeave)
			Kromog.raidRoster.buttons[pos].name = ExRT.lib.CreateText(Kromog.raidRoster.buttons[pos],80,14,nil,0,0,"LEFT","MIDDLE",nil,12,"",nil,1,1,1,1)
			Kromog.raidRoster.buttons[pos]._name = nil
			Kromog.raidRoster.buttons[pos]:SetScript("OnClick",RaidRosterButtonOnClick)
		end
	end
	Kromog.raidRoster.clearButton = CreateFrame('Button',nil,Kromog.raidRoster)
	Kromog.raidRoster.clearButton:SetPoint("BOTTOMRIGHT",Kromog.raidRoster,"BOTTOMRIGHT",-11,12)
	Kromog.raidRoster.clearButton:SetSize(80,14)
	ExRT.lib.CreateHoverHighlight(Kromog.raidRoster.clearButton)
	Kromog.raidRoster.clearButton:SetScript("OnEnter",function(self)
		self.hl:Show()
	end)
	Kromog.raidRoster.clearButton:SetScript("OnLeave",function(self)
		self.hl:Hide()
	end)
	Kromog.raidRoster.clearButton.name = ExRT.lib.CreateText(Kromog.raidRoster.clearButton,80,14,nil,0,0,"RIGHT","MIDDLE",nil,12,ExRT.L.BossmodsKromogClear,nil,1,1,1,1)
	Kromog.raidRoster.clearButton:SetScript("OnClick",function(self)
		VExRT.Bossmods.Kromog[Kromog.raidRoster.pos] = nil
		Kromog:ReRoster()
		Kromog.raidRoster:Hide()
		
		DisableSync()
	end)
	
	Kromog.raidRoster.hideChk = ExRT.lib.CreateCheckBox(Kromog.raidRoster,"BOTTOMLEFT",10,7,ExRT.L.BossmodsKromogHidePlayers,true)
	Kromog.raidRoster.hideChk:SetScale(0.8)
	Kromog.raidRoster.hideChk:SetScript("OnClick",function (self)
	  	Kromog.hidePlayers = self:GetChecked()
	  	Kromog:UpdateSelectRoster()
	end)
	
	if not VExRT.Bossmods.Kromog.DisableArrow then
		--Kromog.setupFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		Kromog.setupFrame:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	end
	Kromog.setupFrame:SetScript("OnEvent",KromogFrameOnEvent)
	Kromog.setupFrame:SetScript("OnShow",function (self)
		local isAlpha = false
		if IsInRaid() then
			if ExRT.mds.IsPlayerRLorOfficer(UnitName('player')) then
				isAlpha = false
			else
				isAlpha = true
			end
		end
		if isAlpha then
			self.clearButton:SetAlpha(.2)
			self.byName:SetAlpha(.2)
			self.sendButton:SetAlpha(.2)
			self.setupsButton:SetAlpha(.2)
		else
			self.clearButton:SetAlpha(1)
			self.byName:SetAlpha(1)
			self.sendButton:SetAlpha(1)
			self.setupsButton:SetAlpha(1)		
		end
	end)

	if not VExRT.Bossmods.Kromog.name or not VExRT.Bossmods.Kromog.time then
		Kromog.setupFrame.lastUpdate:SetText("")
	else
		Kromog.setupFrame.lastUpdate:SetText(ExRT.L.BossmodsKromogLastUpdate..": "..VExRT.Bossmods.Kromog.name.." ("..date("%H:%M:%S %d.%m.%Y",VExRT.Bossmods.Kromog.time)..")"..(not VExRT.Bossmods.Kromog.sync and " *" or ""))
	end
	Kromog:ReRoster()
	Kromog.setupFrame:Show()
	if InterfaceOptionsFrame:IsShown() then
		InterfaceOptionsFrame:Hide()
	end
	if ExRT.Options.Frame:IsShown() then
		ExRT.Options.Frame:Hide()
	end
end

function Kromog:addonMessage(sender, prefix, ...)
	if prefix == "kromog" then
		if IsInRaid() and not VExRT.Bossmods.Kromog.UpdatesFromAll and not ExRT.mds.IsPlayerRLorOfficer(sender) then
			return
		end
	
		local pos1,name1,pos2,name2,pos3,name3 = ...
		VExRT.Bossmods.Kromog.time = time()
		VExRT.Bossmods.Kromog.name = sender
		VExRT.Bossmods.Kromog.sync = true
		if pos1 and name1 then
			pos1 = tonumber(pos1)
			if name1 == "-" then
				name1 = nil
			end
			VExRT.Bossmods.Kromog[pos1] = name1
		end
		if pos2 and name2 then
			pos2 = tonumber(pos2)
			if name2 == "-" then
				name2 = nil
			end
			VExRT.Bossmods.Kromog[pos2] = name2
		end
		if pos3 and name3 then
			pos3 = tonumber(pos3)
			if name3 == "-" then
				name3 = nil
			end
			VExRT.Bossmods.Kromog[pos3] = name3
		end
		
		if Kromog.setupFrame then
			Kromog.setupFrame.lastUpdate:SetText(ExRT.L.BossmodsKromogLastUpdate..": "..VExRT.Bossmods.Kromog.name.." ("..date("%H:%M:%S %d.%m.%Y",VExRT.Bossmods.Kromog.time)..")")
			Kromog:ReRoster()
		end
	end
end

-----------------------------------------
-- Thogar
-----------------------------------------

local Thogar = {}
Thogar.data = {
	--{время с пула;колия;тип:1 - проезд,2-прибытие,3-отправка}	1 - самая дальняя от входа колия
	{18,4,1},
	{28,2,1},
	{33,1,2},
	{46,1,3},
	{48,3,1},
	{53,4,2},
	{78,4,3},
	{78,2,1},
	{85,3,2},
	{94,3,3},
	{108,1,1},
	{124,2,2},
	{124,3,2},
	{153,2,3},
	{153,3,3},
	{163,4,1},
	{163,1,1},
	{173,1,2},
	{183,2,1},
	{198,2,1},
	{198,4,2},
	{216,1,3},
	{219,3,1},
	{226,4,3},
	{228,2,1},
	{238,1,1},
	{254,2,2},
	{254,4,2},
	{265,2,3},
	{273,1,1},
	{278,3,1},
	{298,4,3},
	{308,4,2},
	{308,1,2},
	{318,2,1},
	{343,2,1},
	{373,2,2},
	{373,3,2},
	{393,3,3},
	{408,2,3},
	{408,1,1},
	{428,1,2},
	{428,4,2},
}
Thogar.statusText = {
	ExRT.L.BossmodsThogarTransit,
	ExRT.L.BossmodsThogarIn,
	ExRT.L.BossmodsThogarOut,
}
Thogar.marksIcons = {
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_6",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_4",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_3",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_7",
}

function Thogar:Load()
	if Thogar.mainframe then
		return
	end
	Thogar.mainframe = CreateFrame("Frame","ExRTBossmodsThogar",UIParent)
	Thogar.mainframe:SetSize(180,90)
	if VExRT.Bossmods.ThogarLeft and VExRT.Bossmods.ThogarTop then
		Thogar.mainframe:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.Bossmods.ThogarLeft,VExRT.Bossmods.ThogarTop)
	else
		Thogar.mainframe:SetPoint("TOP",UIParent, "TOP", 0, 0)
	end
	--Thogar.mainframe:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.mds.defBorder,tile = false,edgeSize = 8})
	Thogar.mainframe:SetBackdrop({edgeFile = ExRT.mds.defBorder,tile = false,edgeSize = 8})
	--Thogar.mainframe:SetBackdropColor(0.05,0.05,0.05,0.85)
	Thogar.mainframe:SetBackdropBorderColor(0.2,0.2,0.2,0.4)
	Thogar.mainframe:EnableMouse(true)
	Thogar.mainframe:SetMovable(true)
	Thogar.mainframe:RegisterForDrag("LeftButton")
	Thogar.mainframe:SetScript("OnDragStart", function(self)
		if self:IsMovable() then
			self:StartMoving()
		end
	end)
	Thogar.mainframe:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		VExRT.Bossmods.ThogarLeft = self:GetLeft()
		VExRT.Bossmods.ThogarTop = self:GetTop()
	end)
	if VExRT.Bossmods.Alpha then Thogar.mainframe:SetAlpha(VExRT.Bossmods.Alpha/100) end
	if VExRT.Bossmods.Scale then Thogar.mainframe:SetScale(VExRT.Bossmods.Scale/100) end

	Thogar.mainframe.Background = Thogar.mainframe:CreateTexture(nil, "BACKGROUND")
	--Thogar.mainframe.Background:SetTexture(.4,.4,.4,.7)
	Thogar.mainframe.Background:SetTexture(1,1,1,1)
	Thogar.mainframe.Background:SetAllPoints()
	Thogar.mainframe.Background:SetGradientAlpha("VERTICAL", 53/255, 53/255, 53/255, .8, 26/255, 26/255, 26/255, .8)
	--Thogar.mainframe.Background:SetGradientAlpha("VERTICAL", 0/255, 0/255, 0/255, .7, 63/255, 63/255, 63/255, .7)
	
	Thogar.mainframe.lines = {}
	for i=1,4 do
		Thogar.mainframe.lines[i] = CreateFrame("Frame",nil,Thogar.mainframe)
		Thogar.mainframe.lines[i]:SetPoint("TOPLEFT",0,-5-(i-1)*20)
		Thogar.mainframe.lines[i]:SetSize(180,20)
		Thogar.mainframe.lines[i].col = ExRT.lib.CreateText(Thogar.mainframe.lines[i],30,20,nil,10,0,"LEFT","MIDDLE","Interface\\AddOns\\ExRT\\media\\Glametrix.otf",18,i,nil,1,1,1,1)
		Thogar.mainframe.lines[i].status = ExRT.lib.CreateText(Thogar.mainframe.lines[i],100,20,nil,25,0,"LEFT","MIDDLE","Interface\\AddOns\\ExRT\\media\\Glametrix.otf",18,"",nil,1,1,1,1)
		Thogar.mainframe.lines[i].time = ExRT.lib.CreateText(Thogar.mainframe.lines[i],50,20,nil,135,0,"LEFT","MIDDLE","Interface\\AddOns\\ExRT\\media\\Glametrix.otf",18,"",nil,1,1,1,1)

		Thogar.mainframe.lines[i].g = Thogar.mainframe.lines[i]:CreateTexture(nil, "BACKGROUND")
		Thogar.mainframe.lines[i].g:SetTexture(1,1,1,1)
		Thogar.mainframe.lines[i].g:SetAllPoints()
		Thogar.mainframe.lines[i].g:SetGradientAlpha("HORIZONTAL", 255/255, 55/255, 55/255, .8, 255/255, 55/255, 55/255, 0)
		Thogar.mainframe.lines[i].g:Hide()
		
		Thogar.mainframe.lines[i].mark = Thogar.mainframe.lines[i]:CreateTexture(nil, "BACKGROUND")
		Thogar.mainframe.lines[i].mark:SetTexture(Thogar.marksIcons[i])
		Thogar.mainframe.lines[i].mark:SetSize(14,14)
		Thogar.mainframe.lines[i].mark:SetPoint("RIGHT",Thogar.mainframe.lines[i].time,"LEFT",-10,0)
	end
	
	local maxTime = 0
	for j,data in ipairs(Thogar.data) do
		maxTime = max(data[1],maxTime)
	end
	
	local tmr = 0
	local pullTime = 0
	local function ThogarUpdate(self,elapsed)
		tmr = tmr + elapsed
		if tmr > 0.05 then
			pullTime = pullTime + tmr
			--DInfo(pullTime)
			tmr = 0
			local nextTime = maxTime
			for i=1,4 do
				local line = self.lines[i]
				local isLineSet = false
				local isLineFull = false
				line.status:SetText("")
				line.time:SetText("")
				line.g:Hide()
				line.diffNow = nil
				for j,data in ipairs(Thogar.data) do
					if data[2] == i and pullTime > data[1] and data[3] == 1 and (pullTime - data[1]) < 3 then
						line.status:SetText(Thogar.statusText[ data[3] ])
						line.time:SetText("")
						line.diffNow = -1
						break
					elseif data[2] == i and data[1] > pullTime and not isLineSet then
						line.status:SetText(Thogar.statusText[ data[3] ])
						local diff = data[1] - pullTime
						local timeColor = ""
						line.time:SetText( date("%M:%S",diff) )
						
						--break
						isLineSet = true
						isLineFull = data[3] == 3
						if not isLineFull then
							line.diffNow = diff
						else
							line.diffNow = -1
						end
					end
				end
				if line.diffNow then
					if line.diffNow >= 0 then
						nextTime = min(nextTime,line.diffNow)
					end
					if line.diffNow <= 5 then
						line.g:SetGradientAlpha("HORIZONTAL", 255/255, 55/255, 55/255, .8, 255/255, 55/255, 55/255, 0)
						line.g:Show()
					elseif line.diffNow <= 10 then
						line.g:SetGradientAlpha("HORIZONTAL", 255/255, 255/255, 55/255, .65, 255/255, 255/255, 55/255, 0)
						line.g:Show()	
					end
				end
			end
			if nextTime > 10 then
				for i=1,4 do
					local line = self.lines[i]
					if line.diffNow and line.diffNow == nextTime then
						line.g:SetGradientAlpha("HORIZONTAL", 55/255, 255/255, 55/255, .5, 55/255, 255/255, 55/255, 0)
						line.g:Show()
					end
				end
			end
			if pullTime > maxTime then
				self:SetScript("OnUpdate",nil)
			end
		end
	end
	
	--Thogar.mainframe:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	Thogar.mainframe:RegisterEvent("ENCOUNTER_START")
	Thogar.mainframe:RegisterEvent("ENCOUNTER_END")
	Thogar.mainframe:SetScript("OnEvent",function (self,event,unitID,spell,_,lineID,spellID)
		if (event == "UNIT_SPELLCAST_SUCCEEDED" and (spellID == 20473 or spellID == 774)) then
			pullTime = 0
			self:SetScript("OnUpdate",ThogarUpdate)
		elseif event == "ENCOUNTER_START" and unitID == 1692 then
			pullTime = 0
			self:SetScript("OnUpdate",ThogarUpdate)
		elseif event == "ENCOUNTER_END" then
			self:SetScript("OnUpdate",nil)
		end		  
	end)
	
end

--ExRT.mds.ScheduleTimer(Thogar.Load, 2)

-----------------------------------------
-- Imperator Mar'gok
-----------------------------------------

local Margok = {}
Margok.spellIDs = {
	[156225]=true,	--Phase 1
	[164004]=true,	--Phase 2
	[164005]=true,	--Phase 3
	[164006]=true,	--Phase 4
}
Margok.mapData = {}
Margok.Roster = {}
Margok.lastRange = nil
Margok.Range = 200

do
	local tmr = 0
	function Margok:OnTimer(elapsed)
		tmr = tmr + elapsed
		if tmr > 0.3 then
			tmr = 0
			local mainY,mainX,mainY2,mainX2 = nil
			if not self.Debuff and not self.Debuff2 then
				return
			end
			if self.Debuff then
				mainY,mainX = UnitPosition(self.Debuff)
			end
			if self.Debuff2 then
				mainY2,mainX2 = UnitPosition(self.Debuff2)
			end
			local diff,diffName,diff2,diffName2 = nil
			for name,_ in pairs(Margok.Roster) do
				if not UnitIsDeadOrGhost(name) then
					local y,x = UnitPosition(name)
					
					if name ~= self.Debuff then
						local dX = (x - mainX)
						local dY = (y - mainY)
						local diffNow = sqrt(dX * dX + dY * dY)
						if not diff or diffNow < diff then
							diff = diffNow
							diffName = name
						end
					end
					if name ~= self.Debuff2 then
						local dX = (x - mainX)
						local dY = (y - mainY)
						local diffNow = sqrt(dX * dX + dY * dY)
						if not diff2 or diffNow < diff2 then
							diff2 = diffNow
							diffName2 = name
						end
					end
				end
			end
			
			if diffName and diff <= Margok.Range then
				self.name:SetText("|c"..ExRT.mds.classColor(select(2,UnitClass(diffName)))..diffName)
				if diffName ~= Margok.lastRange then
					--[[
					if GetRaidTargetIndex(diffName) ~= 7 then
						SetRaidTargetIcon(diffName, 7)
					end
					]]
					Margok.lastRange = diffName
				end
			else
				self.name:SetText("")
				Margok.lastRange = nil
			end
			if diffName2 and diff2 <= Margok.Range and diffName2 ~= diffName then
				if diffName2 ~= Margok.lastRange2 then
					--[[
					if GetRaidTargetIndex(diffName2) ~= 3 then
						SetRaidTargetIcon(diffName2, 3)
					end
					]]
					Margok.lastRange2 = diffName2
				end
			else
				Margok.lastRange2 = nil
			end
		end
	end
end
do
	local resetRange = nil
	local function ResetRange()
		resetRange = nil
		Margok.Range = 200
	end
	function Margok:OnEvent(_,_,event,_,_,_,_,_,destGUID,destName,_,_,spellID)
		if spellID and Margok.spellIDs[spellID] then
			if event == "SPELL_AURA_APPLIED" then
				if not self.Debuff then
					self.Debuff = destName
					--[[
					if GetRaidTargetIndex(destName) ~= 8 then
						SetRaidTargetIcon(destName, 8)
					end
					]]
					--ExRT.mds.CancelTimer(resetRange)
				else
					self.Debuff2 = destName
					--[[
					if GetRaidTargetIndex(destName) ~= 2 then
						SetRaidTargetIcon(destName, 2)
					end
					]]
				end
			elseif event == "SPELL_AURA_REMOVED" then
				if self.Debuff2 and self.Debuff2 == destName then
					self.Debuff2 = nil
					if Margok.lastRange2 then
						--SetRaidTargetIcon(Margok.lastRange2, 0)
						Margok.lastRange2 = nil
					end
				else
					self.Debuff = nil
					if Margok.lastRange then
						--SetRaidTargetIcon(Margok.lastRange, 0)
						Margok.lastRange = nil
					end
				end
				--[[
				if spellID == 164005 then
					Margok.Range = Margok.Range * 0.75
				else
					Margok.Range = Margok.Range * 0.5
				end
				resetRange = ExRT.mds.ScheduleTimer(ResetRange, 1.5)
				]]
			end
		end
	end
end
function Margok:OnRosterUpdate()
	wipe(Margok.Roster)
	local n = GetNumGroupMembers() or 0
	if n > 0 then
		local gMax = ExRT.mds.GetRaidDiffMaxGroup()
		for j=1,n do
			local name, _,subgroup = GetRaidRosterInfo(j)
			if name and subgroup <= gMax then
				Margok.Roster[ name ] = true
			end
		end
	end
end

function Margok:Load()
	if Margok.mainframe then
		return
	end
	Margok.mainframe = CreateFrame("Frame",nil,UIParent)
	Margok.mainframe:SetSize(80,30)

	if VExRT.Bossmods.MargokLeft and VExRT.Bossmods.MargokTop then
		Margok.mainframe:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.Bossmods.MargokLeft,VExRT.Bossmods.MargokTop)
	else
		Margok.mainframe:SetPoint("TOP",UIParent, "TOP", 0, 0)
	end
	Margok.mainframe:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.mds.defBorder,tile = false,edgeSize = 8})
	--Margok.mainframe:SetBackdrop({edgeFile = ExRT.mds.defBorder,tile = false,edgeSize = 8})
	Margok.mainframe:SetBackdropColor(0.05,0.05,0.05,0.85)
	Margok.mainframe:SetBackdropBorderColor(0.2,0.2,0.2,0.4)
	Margok.mainframe:EnableMouse(true)
	Margok.mainframe:SetMovable(true)
	Margok.mainframe:RegisterForDrag("LeftButton")
	Margok.mainframe:SetScript("OnDragStart", function(self)
		if self:IsMovable() then
			self:StartMoving()
		end
	end)
	Margok.mainframe:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		VExRT.Bossmods.MargokLeft = self:GetLeft()
		VExRT.Bossmods.MargokTop = self:GetTop()
	end)
	if VExRT.Bossmods.Alpha then Margok.mainframe:SetAlpha(VExRT.Bossmods.Alpha/100) end
	if VExRT.Bossmods.Scale then Margok.mainframe:SetScale(VExRT.Bossmods.Scale/100) end

	Margok.mainframe.name = ExRT.lib.CreateText(Margok.mainframe,75,30,"CENTER",0,0,"CENTER","MIDDLE",nil,nil,UnitName("player"),nil,1,1,1,1)
	
	Margok.mainframe:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	Margok.mainframe:SetScript("OnUpdate", Margok.OnTimer)
	Margok.mainframe:SetScript("OnEvent", Margok.OnEvent)
	
	Margok.rosterFrame = CreateFrame("Frame")
	Margok.rosterFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
	Margok.rosterFrame:SetScript("OnEvent", Margok.OnRosterUpdate)
	Margok:OnRosterUpdate()
end

-----------------------------------------
-- Ko'ragh
-----------------------------------------

local Koragh = {}

function Koragh:OnEvent(_,_,event,_,_,_,_,_,destGUID,destName,_,_,spellID)
	if event == "SPELL_AURA_APPLIED" and spellID == 172895 and Koragh.playerGUID == destGUID then
		local x,y = GetPlayerMapPosition("player")
		ExRT.mds.Arrow:ShowRunTo(x,y,1,12,false,true)
	end
end

function Koragh:Load()
	if Koragh.mainframe then
		return
	end
	Koragh.playerGUID = UnitGUID("player")
	
	Koragh.mainframe = CreateFrame('Frame')
	Koragh.mainframe:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	Koragh.mainframe:SetScript("OnEvent", Koragh.OnEvent)
end

-----------------------------------------
-- Shadow-Lord Iskar
-----------------------------------------

local Iskar = {}

function Iskar:Load()
	if Iskar.mainframe then
		return
	end
	if InCombatLockdown() then
		print("Combat error")
		return
	end
	
	local frame = CreateFrame('Frame',nil,UIParent)
	Iskar.mainframe = frame
	frame:SetSize(170,202)

	if VExRT.Bossmods.IskarLeft and VExRT.Bossmods.IskarTop then
		frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.Bossmods.IskarLeft,VExRT.Bossmods.IskarTop)
	else
		frame:SetPoint("TOP",UIParent, "TOP", 0, 0)
	end
	frame.back = frame:CreateTexture(nil, "BACKGROUND",nil,-7)
	frame.back:SetAllPoints()
	frame.back:SetTexture(0,0,0,.6)
	
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", function(self)
		if self:IsMovable() then
			self:StartMoving()
		end
	end)
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		VExRT.Bossmods.IskarLeft = self:GetLeft()
		VExRT.Bossmods.IskarTop = self:GetTop()
	end)
	if VExRT.Bossmods.Alpha then frame:SetAlpha(VExRT.Bossmods.Alpha/100) end
	if VExRT.Bossmods.Scale then frame:SetScale(VExRT.Bossmods.Scale/100) end
	
	local RosterUpdate = nil
	local IsFelBombActive = nil
	local IsShadowRiposte = nil
	local IsFelConduit = nil
	local IsPhantasmalCorruption = nil
	
	local debuffName_wind = GetSpellInfo(181957) or "unk" --Phantasmal Winds
	local debuffName_radiance = GetSpellInfo(185239) or "unk" --Radiance of Anzu
	local buffName_eyeOfAnzu = GetSpellInfo(179202) or "unk" --Eye Of Anzu
	local debuffName_darkBindings = GetSpellInfo(185510) or "unk" --Dark Bindings
	local castName_felConduit = GetSpellInfo(181827) or "unk" --Fel Conduit
	local castName_felChainLightning = GetSpellInfo(181832) or "unk" --Fel Chain Lightning
	local debuffName_corruption = GetSpellInfo(181824) or "unk" --Phantasmal Corruption
	
	local function OnAuraEvent(self,_,unit)
		local name = self.unitID
		if not name or UnitName(name) ~= UnitName(unit or "?") then
			return
		end
		local isRadiance,_,_,radianceCount = UnitAura(name,debuffName_radiance,nil,"HARMFUL")
		if isRadiance then
			self.stacks:SetText(radianceCount or 1)
		else
			self.stacks:SetText("")
		end
		if IsShadowRiposte then
			local eyeOfAnzu = UnitAura(name,buffName_eyeOfAnzu)
			if eyeOfAnzu then
				if self.state ~= 20 then
					self.back:SetTexture(.5,.1,.5,.9)
					self.state = 20
				end
				return
			end
			if self.state ~= 10 then
				self.back:SetTexture(.5,1,.5,.9)
				self.state = 10
			end
			return
		end
		if IsFelBombActive then
			local eyeOfAnzu = UnitAura(name,buffName_eyeOfAnzu)
			if eyeOfAnzu then
				if self.state ~= 20 then
					self.back:SetTexture(.5,.1,.5,.9)
					self.state = 20
				end
				return
			end
			if self.isHealer then
				if self.state ~= 10 then
					self.back:SetTexture(.5,1,.5,.9)
					self.state = 10
				end
			else
				if self.state ~= 0 then
					self.back:SetTexture(0,0,0,.5)
					self.state = 0
				end
			end
			return
		end		
		if IsFelConduit then
			local eyeOfAnzu = UnitAura(name,buffName_eyeOfAnzu)
			if eyeOfAnzu then
				if self.state ~= 20 then
					self.back:SetTexture(.5,.1,.5,.9)
					self.state = 20
				end
				return
			end
			if not self.isHealer then
				if self.state ~= 10 then
					self.back:SetTexture(.5,1,.5,.9)
					self.state = 10
				end
			else
				if self.state ~= 0 then
					self.back:SetTexture(0,0,0,.5)
					self.state = 0
				end
			end
			return
		end
		if IsPhantasmalCorruption then
			local eyeOfAnzu = UnitAura(name,buffName_eyeOfAnzu)
			if eyeOfAnzu then
				if self.state ~= 20 then
					self.back:SetTexture(.5,.1,.5,.9)
					self.state = 20
				end
				return
			end
			local isCorrupted = false
			for i=1,10 do
				local _,_,_,_,_,_,_,_,_,_,spellID = UnitAura(name,i,"HARMFUL")
				if spellID == 181824 then
					isCorrupted = true
					break
				elseif not spellID then
					break
				end
			end
			if isCorrupted then
				if self.state ~= 10 then
					self.back:SetTexture(.5,1,.5,.9)
					self.state = 10
				end
			else
				if self.state ~= 0 then
					self.back:SetTexture(0,0,0,.5)
					self.state = 0
				end
			end
			return
		end
		local isWindDebuff = UnitAura(name,debuffName_wind,nil,"HARMFUL")
		if isWindDebuff then
			if self.state ~= 10 then
				self.back:SetTexture(.5,1,.5,.9)
				self.state = 10
			end
			return
		end
		local eyeOfAnzu = UnitAura(name,buffName_eyeOfAnzu)
		if eyeOfAnzu then
			if self.state ~= 20 then
				self.back:SetTexture(.5,.1,.5,.9)
				self.state = 20
			end
			return
		end
		local darkBindings = UnitAura(name,debuffName_darkBindings,nil,"HARMFUL")
		if darkBindings then
			if self.state ~= 30 then
				self.back:SetTexture(1,1,.5,.9)
				self.state = 30
			end
			return
		end
		if self.state ~= 0 then
			self.back:SetTexture(0,0,0,.5)
			self.state = 0
		end
	end
	
	local function OnEnterEvent(self)
		if not self.unitID or not IsAltKeyDown() then
			return
		end
		GameTooltip_SetDefaultAnchor(GameTooltip, self)
		GameTooltip:SetUnit(self.unitID)
		self.UpdateTooltip = OnEnterEvent
	end
	local function OnLeaveEvent(self)
		self.UpdateTooltip = nil
		GameTooltip_Hide()
	end
	
	local classNames = {"WARRIOR","PALADIN","HUNTER","ROGUE","PRIEST","DEATHKNIGHT","SHAMAN","MAGE","WARLOCK","MONK","DRUID"}
	frame.units = {}
	for i=1,6 do
		for j=1,5 do
			local unitFrame = CreateFrame('Button',nil,frame,"SecureActionButtonTemplate")
			frame.units[(i-1)*5+j] = unitFrame
			unitFrame:SetSize(30,30)
			unitFrame:SetPoint("TOPLEFT",5+(j-1)*32,-5-(i-1)*32)
			
			unitFrame.ID = (i-1)*5+j
			
			unitFrame:RegisterForClicks("AnyDown")
			unitFrame:SetAttribute("type", "macro")
			--unitFrame:SetAttribute("macrotext", "/say test"..((i-1)*5+j))
			
			unitFrame:SetScript("OnEvent",OnAuraEvent)
			unitFrame:SetScript("OnEnter",OnEnterEvent)
			unitFrame:SetScript("OnLeave",OnLeaveEvent)
			
			local borderSize = 3
			
			unitFrame.bt = unitFrame:CreateTexture(nil, "BACKGROUND")
			unitFrame.bt:SetPoint("TOPLEFT",0,0)
			unitFrame.bt:SetPoint("BOTTOMRIGHT",unitFrame,"TOPRIGHT",0,-borderSize)

			unitFrame.bb = unitFrame:CreateTexture(nil, "BACKGROUND")
			unitFrame.bb:SetPoint("BOTTOMLEFT",0,0)
			unitFrame.bb:SetPoint("TOPRIGHT",unitFrame,"BOTTOMRIGHT",0,borderSize)

			unitFrame.bl = unitFrame:CreateTexture(nil, "BACKGROUND")
			unitFrame.bl:SetPoint("TOPLEFT",0,-borderSize)
			unitFrame.bl:SetPoint("BOTTOMRIGHT",unitFrame,"BOTTOMLEFT",borderSize,borderSize)

			unitFrame.br = unitFrame:CreateTexture(nil, "BACKGROUND")
			unitFrame.br:SetPoint("TOPRIGHT",0,-borderSize)
			unitFrame.br:SetPoint("BOTTOMLEFT",unitFrame,"BOTTOMRIGHT",-borderSize,borderSize)
			
			local cR,cG,cB = ExRT.mds.classColorNum(classNames[fastrandom(1,11)])
			unitFrame.bt:SetTexture(cR,cG,cB,.3)
			unitFrame.bl:SetTexture(cR,cG,cB,.3)
			unitFrame.bb:SetTexture(cR,cG,cB,.3)
			unitFrame.br:SetTexture(cR,cG,cB,.3)
			
			unitFrame.back = unitFrame:CreateTexture(nil, "BACKGROUND")
			unitFrame.back:SetPoint("TOPLEFT",borderSize,-borderSize)
			unitFrame.back:SetPoint("BOTTOMRIGHT",-borderSize,borderSize)
			unitFrame.back:SetTexture(0,0,0,.5)
			
			unitFrame.name = ExRT.lib.CreateText(unitFrame,27,27,"CENTER",-1,-2,"CENTER","MIDDLE",nil,10,"Аф",nil,1,1,1)
			
			unitFrame.stacks = ExRT.lib.CreateText(unitFrame,27,27,"TOPRIGHT",-3,-3,"RIGHT","TOP",nil,10,fastrandom(1,5),nil,1,1,1)
			
			if fastrandom(1,100) > 89 then
				unitFrame.back:SetTexture(.5,1,.5,.9)
			end
			
			if fastrandom(1,100) > 69 then
				unitFrame:SetAlpha(.2)
			end
		end
	end
	frame.units[fastrandom(1,30)].back:SetTexture(.5,.1,.5,.9)
	
	local function Lock(self,isLoad)
		local parent = self:GetParent()
		local var = VExRT.Bossmods.IskarLock
		if isLoad == 1 then
			var = not var
		end
		if var then
			VExRT.Bossmods.IskarLock = nil
			self.texture:SetTexture("Interface\\AddOns\\ExRT\\media\\un_lock.tga")
			parent:SetMovable(true)
			parent:EnableMouse(true)
			parent.back:SetTexture(0,0,0,.6)
		else
			VExRT.Bossmods.IskarLock = true
			self.texture:SetTexture("Interface\\AddOns\\ExRT\\media\\lock.tga")
			parent:SetMovable(false)
			parent:EnableMouse(false)
			parent.back:SetTexture(0,0,0,0)
		end
	end
	
	frame.lock = ExRT.lib.CreateIcon(frame,14,nil,2,14,"Interface\\AddOns\\ExRT\\media\\un_lock.tga",true)
	frame.lock:SetScript("OnClick",Lock)
	
	frame.optionsDropDown = CreateFrame("Frame", "ExRTBossmodsIskarOptionsDropDown", nil, "UIDropDownMenuTemplate")
	
	frame.options = ExRT.lib.CreateIcon(frame,14,"TOPRIGHT",-2,14,[[Interface\AddOns\ExRT\media\DiesalGUIcons16x256x128.tga]],true)
	--frame.options.texture:SetTexCoord(0.25,0.3125,0.5,0.625)
	frame.options.texture:SetTexCoord(0.26,0.3025,0.51,0.615)
	frame.options:SetScript("OnClick",function()
		if InCombatLockdown() then
			print("Error: Disabled in combat")
			return
		end
		EasyMenu({
			{
				text = ExRT.L.BossmodsIskarDisableClassColor,
				checked = VExRT.Bossmods.IskarDisableClassColors,
				func = function()
					VExRT.Bossmods.IskarDisableClassColors = not VExRT.Bossmods.IskarDisableClassColors
					RosterUpdate()
				end,
			},
			{
				text = ExRT.L.BossmodsIskarHideStacks,
				checked = VExRT.Bossmods.IskarHideStacks,
				func = function()
					VExRT.Bossmods.IskarHideStacks = not VExRT.Bossmods.IskarHideStacks
					RosterUpdate()
				end,
			},
			{
				text = ExRT.L.BossmodsIskarDisableRed,
				checked = VExRT.Bossmods.IskarDisableRedBackground,
				func = function()
					VExRT.Bossmods.IskarDisableRedBackground = not VExRT.Bossmods.IskarDisableRedBackground
				end,
			},
			--[[
			{
				text = "Disable Fel Bomb & Fel Conduit helper",
				checked = VExRT.Bossmods.IskarDisableFelBomb,
				func = function()
					VExRT.Bossmods.IskarDisableFelBomb = not VExRT.Bossmods.IskarDisableFelBomb
					if VExRT.Bossmods.IskarDisableFelBomb then
						frame:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
					end
				end,
			},
			]]
			{
				text = ExRT.L.BossmodsIskarShowNames,
				checked = VExRT.Bossmods.IskarShowNames,
				func = function()
					VExRT.Bossmods.IskarShowNames = not VExRT.Bossmods.IskarShowNames
					RosterUpdate()
				end,
			},
			{
				text = ExRT.L.bossmodsclose,
				notCheckable = true,
				func = function()
					ExRT.mds:ExBossmodsCloseAll()
					CloseDropDownMenus()
				end,
			},						
			{
				text = ExRT.L.BossWatcherSelectFightClose,
				notCheckable = true,
				func = function()
					CloseDropDownMenus()
				end,
			},
		}, frame.optionsDropDown, "cursor", 10 , -15, "MENU")
	end)
	--ExRT.lib.CreateBackTextureForDebug(frame.options)
	local function sortRoster(a,b) return a[1]<b[1]  end
	
	function RosterUpdate()
		if InCombatLockdown() then
			C_Timer.NewTimer(5,RosterUpdate)
			return
		end
	
		local n = GetNumGroupMembers()
		if n == 0 then
			for i=1,6 do
				for j=1,5 do
					local unitFrame = frame.units[(i-1)*5+j]
					
					local cR,cG,cB = ExRT.mds.classColorNum(classNames[fastrandom(1,11)])
					if VExRT.Bossmods.IskarDisableClassColors then
						cR,cG,cB = .1,.1,.1
					end
					unitFrame.bt:SetTexture(cR,cG,cB,.3)
					unitFrame.bl:SetTexture(cR,cG,cB,.3)
					unitFrame.bb:SetTexture(cR,cG,cB,.3)
					unitFrame.br:SetTexture(cR,cG,cB,.3)
					
					local stacks = fastrandom(0,5)
					unitFrame.stacks:SetText(stacks ~= 0 and stacks or "")
					
					unitFrame.back:SetTexture(0,0,0,.5)
					if fastrandom(1,100) > 89 then
						unitFrame.back:SetTexture(.5,1,.5,.9)
					end
					
					if fastrandom(1,100) > 69 then
						unitFrame:SetAlpha(.2)
					else
						unitFrame:SetAlpha(1)
					end
					
					if VExRT.Bossmods.IskarHideStacks then
						unitFrame.stacks:Hide()
					else
						unitFrame.stacks:Show()
					end
					
					if VExRT.Bossmods.IskarShowNames then
						unitFrame.name:SetText(ExRT.F:utf8sub(UnitName'player', 1, 2))
					else
						unitFrame.name:SetText("")
					end
					
					unitFrame.unitID = nil
					unitFrame:UnregisterAllEvents()
				end
			end
			frame.units[fastrandom(1,30)].back:SetTexture(.5,.1,.5,.9)
			return
		end
		local gMax = ExRT.mds.GetRaidDiffMaxGroup()
		local roster = {}
		for i=1,n do
			local name,_,subgroup,_,_,class,_,_,_,_,_,role = GetRaidRosterInfo(i)
			if name and subgroup <= gMax then
				roster[subgroup] = roster[subgroup] or {}
				roster[subgroup][ #roster[subgroup] + 1 ] = {name,class,role}
			end
		end
		for i=1,gMax do
			roster[i] = roster[i] or {}
			sort(roster[i],sortRoster)
			
			for j=1,5 do
				local name = roster[i][j]
				local unitFrame = frame.units[(i-1)*5+j]
				if unitFrame then
					if name then
						unitFrame.unitID = name[1]
						unitFrame:UnregisterAllEvents()
						unitFrame:RegisterEvent("UNIT_AURA")
						local cR,cG,cB = ExRT.mds.classColorNum(name[2])
						if VExRT.Bossmods.IskarDisableClassColors then
							cR,cG,cB = .1,.1,.1
						end
						unitFrame.bt:SetTexture(cR,cG,cB,.3)
						unitFrame.bl:SetTexture(cR,cG,cB,.3)
						unitFrame.bb:SetTexture(cR,cG,cB,.3)
						unitFrame.br:SetTexture(cR,cG,cB,.3)
						OnAuraEvent(unitFrame,nil,name[1])
						unitFrame:SetAttribute("macrotext", "/target "..ExRT.mds.delUnitNameServer(name[1]).."\n/click ExtraActionButton1\n/targetlasttarget")
						--unitFrame:SetAttribute("macrotext", "/target "..ExRT.mds.delUnitNameServer(name[1]).."\n/cast [@target] Восстановление\n/targetlasttarget")
						
						if VExRT.Bossmods.IskarHideStacks then
							unitFrame.stacks:Hide()
						else
							unitFrame.stacks:Show()
						end
						
						if VExRT.Bossmods.IskarShowNames then
							unitFrame.name:SetText(ExRT.F:utf8sub(name[1], 1, 2))
						else
							unitFrame.name:SetText("")
						end
						
						unitFrame.isHealer = name[3] == "HEALER"
						
						local inRange, checkedRange = UnitInRange(name[1])
						if inRange or not checkedRange then
							unitFrame:SetAlpha(1)
						else
							unitFrame:SetAlpha(.2)
						end

						unitFrame:Show()
					else
						unitFrame.unitID = nil
						unitFrame:UnregisterAllEvents()
						unitFrame:Hide()
					end
				end
			end
		end
		for i=(gMax+1),6 do
			for j=1,5 do
				local unitFrame = frame.units[(i-1)*5+j]
				if unitFrame then
					unitFrame.unitID = nil
					unitFrame:UnregisterAllEvents()
					unitFrame:Hide()
				end
			end
		end
	end
	
	Lock(frame.lock,1)
	
	local function UpdateFrames()
		for i=1,30 do
			local unitFrame = frame.units[i]
			if unitFrame.unitID then
				OnAuraEvent(unitFrame,nil,unitFrame.unitID)
			end
		end
	end
	
	local AutoRemoveFelBombTimer = nil
	local function AutoRemoveFelBomb()
		AutoRemoveFelBombTimer = nil
		IsFelBombActive = nil
		UpdateFrames()
	end
	local function AutoRemoveShadowRiposte()
		IsShadowRiposte = nil
		UpdateFrames()
	end
	
	frame:SetScript("OnEvent",function(self,event,...)
		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local _,cleu_event,_,_,_,_,_,_,_,_,_,spellID = ...
			if cleu_event == "SPELL_CAST_START" then
				if spellID == 179218 then	--Fel Bomb
					IsFelBombActive = true
					UpdateFrames()
					if AutoRemoveFelBombTimer then
						AutoRemoveFelBombTimer:Cancel()
					end
					AutoRemoveFelBombTimer = C_Timer.NewTimer(9, AutoRemoveFelBomb)
				elseif spellID == 185345 then	--Shadow Riposte
					local _,_,diff = GetInstanceInfo()
					if diff == 16 then
						IsShadowRiposte = true
						UpdateFrames()
						C_Timer.NewTimer(2, AutoRemoveShadowRiposte)
					end
					
				end
			elseif cleu_event == "SPELL_AURA_APPLIED" then
				if spellID == 181753 then
					IsFelBombActive = true
					UpdateFrames()
					if AutoRemoveFelBombTimer then
						AutoRemoveFelBombTimer:Cancel()
					end
					AutoRemoveFelBombTimer = C_Timer.NewTimer(6, AutoRemoveFelBomb)
				elseif spellID == 181824 then
					IsPhantasmalCorruption = true
					UpdateFrames()
				end
			elseif cleu_event == "SPELL_AURA_REMOVED" then
				if spellID == 181753 then
					IsFelBombActive = nil
					UpdateFrames()
					if AutoRemoveFelBombTimer then
						AutoRemoveFelBombTimer:Cancel()
						AutoRemoveFelBombTimer = nil
					end
				elseif spellID == 181824 then
					IsPhantasmalCorruption = nil
					UpdateFrames()
				end
			end
		elseif event == "GROUP_ROSTER_UPDATE" then
			RosterUpdate()
		elseif event == "ENCOUNTER_START" or event == "ENCOUNTER_END" then
			IsFelBombActive = nil
			IsShadowRiposte = nil
			IsPhantasmalCorruption = nil
			UpdateFrames()
		end
	end)
	frame:RegisterEvent('GROUP_ROSTER_UPDATE')
	if not VExRT.Bossmods.IskarDisableFelBomb then
		frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	end
	frame:RegisterEvent('ENCOUNTER_START')
	frame:RegisterEvent('ENCOUNTER_END')
	
	local bossFrames = {"boss1","boss2","boss3","boss4","boss5"}
	local frame_tmr = 0
	local exbf_shown = false
	frame:SetScript("OnUpdate",function(self,elapsed)
		frame_tmr = frame_tmr + elapsed
		if frame_tmr > 0.1 then
			frame_tmr = 0
			--DraenorZoneAbilityFrame	ExtraActionBarFrame
			local eyeOfAnzu = UnitAura("player",buffName_eyeOfAnzu)
			if eyeOfAnzu and not exbf_shown then
				exbf_shown = true
				if not VExRT.Bossmods.IskarDisableRedBackground then
					self.back:SetTexture(1,.1,.1,.4)
				end
			elseif not eyeOfAnzu and exbf_shown then
				exbf_shown = false
				if VExRT.Bossmods.IskarLock then
					self.back:SetTexture(0,0,0,0)
				else
					self.back:SetTexture(0,0,0,.6)
				end
			end
			
			for i=1,30 do
				local unitFrame = self.units[i]
				if unitFrame.unitID then
					local alpha = 1
					local inRange, checkedRange = UnitInRange(unitFrame.unitID)
					if not (inRange or not checkedRange) then
						alpha = 0.2
					end
					local isDead = UnitIsDeadOrGhost(unitFrame.unitID)
					if isDead then
						alpha = 0.2
					end
					unitFrame:SetAlpha(alpha)
				end
			end
			
			local lastFelConduit = IsFelConduit
			IsFelConduit = nil
			for i=1,5 do
				local unit = bossFrames[i]
				
				local name = UnitCastingInfo(unit)
				if name == castName_felConduit then
					IsFelConduit = true
					break
				elseif not name then
					name = UnitChannelInfo(unit)
					if name == castName_felChainLightning then
						IsFelConduit = true
						break
					end
				end
			end
			if IsFelConduit ~= lastFelConduit then
				UpdateFrames()
			end
		end
	end)
	
	RosterUpdate()
	
	frame.Close = function(self)
		for i=1,#self.units do
			self.units[i].unitID = nil
			self.units[i]:UnregisterAllEvents()
		end
	end
end

--C_Timer.NewTimer(1,Iskar.Load)

-----------------------------------------
-- Kormrok
-----------------------------------------
local Kormrok = {}

Kormrok.runes = {
	{-388.10,4209.00}, --1
	{-354.50,4208.60}, --2
	{-339.80,4210.80}, --3
	{-321.50,4210.20}, --4
	{-396.90,4227.70}, --5
	{-380.00,4223.90}, --6
	{-365.50,4224.90}, --7
	{-345.40,4223.80}, --8
	{-331.50,4220.00}, --9
	{-388.60,4241.30}, --10
	{-367.80,4241.80}, --11
	{-354.90,4238.60}, --12
	{-338.40,4243.40}, --13
	{-321.70,4243.10}, --14
	{-394.80,4258.40}, --15
	{-384.40,4253.80}, --16
	{-363.00,4258.30}, --17
	{-347.70,4253.60}, --18
	{-328.10,4252.60}, --19
	{-308.90,4253.00}, --20
	{-389.80,4269.90}, --21
	{-372.70,4271.60}, --22
	{-356.70,4270.40}, --23
	{-336.10,4270.40}, --24
	{-318.90,4271.40}, --25
	{-302.50,4271.00}, --26
	{-362.50,4283.60}, --27
	{-345.30,4283.00}, --28
	{-329.70,4287.20}, --29
	{-355.60,4301.30}, --30
	{-336.30,4299.70}, --31
	{-320.60,4303.30}, --32
	{-304.10,4301.50}, --33
	{-300.10,4240.10}, --34
	{-294.10,4255.20}, --35
	{-311.10,4281.70}, --36
	{-295.40,4285.90}, --37
	{-284.20,4270.00}, --38
	{-343.30,4316.10}, --39
	{-328.00,4318.30}, --40
	{-310.80,4318.40}, --41
	{-294.40,4316.50}, --42
	{-273.20,4315.90}, --43
	{-259.50,4317.70}, --44
	{-241.50,4315.60}, --45
	{-332.80,4329.70}, --46
	{-318.50,4332.70}, --47
	{-301.50,4333.20}, --48
	{-286.20,4329.10}, --49
	{-268.70,4329.80}, --50
	{-313.60,4344.40}, --51
	{-292.10,4344.00}, --52
	{-360.50,4318.30}, --53
	{-354.60,4329.70}, --54
	{-326.80,4343.50}, --55
	{-274.10,4345.40}, --56
	{-248.40,4329.20}, --57
	{-235.10,4332.30}, --58
	{-285.10,4299.00}, --59
	{-265.20,4299.00}, --60
	{-249.50,4303.40}, --61
	{-230.90,4297.20}, --62
	{-275.00,4288.40}, --63
	{-259.00,4283.00}, --64
	{-240.50,4284.10}, --65
	{-222.50,4286.70}, --66
	{-269.60,4272.00}, --67
	{-249.50,4269.60}, --68
	{-231.50,4267.30}, --69
	{-257.30,4253.20}, --70
	{-240.20,4253.80}, --71
	{-278.90,4255.20}, --72
}
Kormrok.map = {-217.50,4359.10,-415.90,4203.40}	--xT,yT,xB,yB
Kormrok.image = {0,0,1,1}	-- KormrokMap.tga 512х401
Kormrok.width = 1024
Kormrok.image_avg = 401 / 512

Kormrok.hidePlayers = true
function Kormrok:UpdateSelectRoster(phase)
	local setup = {}
	local fI = (phase - 1) * 100
	for i=fI+1,fI+100 do
		local name = VExRT.Bossmods.Kormrok[i]
		if name then
			setup[name] = true
		end
	end
	local raidData = {{},{},{},{}}
	for i=1,40 do
		local name,_,subgroup,_,_,class = GetRaidRosterInfo(i)
		if name and subgroup <= 4 then
			raidData[subgroup][ #raidData[subgroup]+1 ] = {name,class}
		end
	end
	for i=1,4 do
		for j=1,5 do
			local pos = (i-1)*5+j
			local data = raidData[i][j]
			if Kormrok.raidRoster.buttons[pos] and data then
				Kormrok.raidRoster.buttons[pos]._name = data[1]
				if Kormrok.hidePlayers then
					if setup[ data[1] ] then
						Kormrok.raidRoster.buttons[pos]:SetAlpha(.2)
					else
						Kormrok.raidRoster.buttons[pos]:SetAlpha(1)
					end
				else
					Kormrok.raidRoster.buttons[pos]:SetAlpha(1)
				end
				Kormrok.raidRoster.buttons[pos].name:SetText("|c"..ExRT.F.classColor(data[2])..data[1])
				Kormrok.raidRoster.buttons[pos]:Show()
			elseif Kormrok.raidRoster.buttons[pos] then
				Kormrok.raidRoster.buttons[pos]:Hide()
			end
		end
	end
end

function Kormrok:ReRoster(phase)
	local playerName = UnitName('player')
	phase = ((phase or 1) - 1) * 100
	for i=1,#Kormrok.runes do
		local name = VExRT.Bossmods.Kormrok[phase + i]
		if name then
			local shortName = ExRT.F.delUnitNameServer(name)
			local class = select(2,UnitClass(shortName))
			local desaturated = false
			if class then
				class = "|c"..ExRT.F.classColor(class)
			else
				class = ""
				desaturated = true
			end
			if shortName == playerName then
				Kormrok.setupFrame.pings[i].icon:SetVertexColor(1,0.3,0.3,1)
			else
				--Kormrok.setupFrame.pings[i].icon:SetVertexColor(1,1,1,1)
				Kormrok.setupFrame.pings[i].icon:SetVertexColor(.4,.2,1,1)
			end
			Kormrok.setupFrame.pings[i].name:SetText(class..name)
			Kormrok.setupFrame.pings[i].icon:SetDesaturated(desaturated)
			if desaturated then
				Kormrok.setupFrame.pings[i].icon:SetVertexColor(1,1,1,.7)
			end
		else
			Kormrok.setupFrame.pings[i].name:SetText("")
			Kormrok.setupFrame.pings[i].icon:SetVertexColor(.3,1,.3,1)
			Kormrok.setupFrame.pings[i].icon:SetDesaturated(false)
		end
	end
end

function Kormrok:Load()
	if Kormrok.setupFrame then
		--Kormrok:ReRoster(1)
		Kormrok.setupFrame.phaseOrange:Click()
		Kormrok.setupFrame:Show()
		Kormrok:RegisterEvents()
		if InterfaceOptionsFrame:IsShown() then
			InterfaceOptionsFrame:Hide()
		end
		if ExRT.Options.Frame:IsShown() then
			ExRT.Options.Frame:Hide()
		end
		Kormrok.setupFrame.isEnabled = true
		return
	end
	Kormrok.setupFrame = ExRT.lib.CreatePopupFrame(Kormrok.width,Kormrok.image_avg * Kormrok.width,"Kormrok",true)
	Kormrok.setupFrame.map = Kormrok.setupFrame:CreateTexture(nil,"BACKGROUND",nil,1)
	Kormrok.setupFrame.map:SetTexture("Interface\\AddOns\\ExRT\\media\\KormrokMap.tga")
	Kormrok.setupFrame.map:SetPoint("TOP",Kormrok.setupFrame,"TOP",0,0)
	Kormrok.setupFrame.map:SetSize(Kormrok.width,Kormrok.image_avg * Kormrok.width)
	Kormrok.setupFrame.map:SetTexCoord(0,1,0,401 / 512)
	Kormrok.setupFrame:SetFrameStrata("HIGH")
	
	if VExRT.Bossmods.KormrokScale and tonumber(VExRT.Bossmods.KormrokScale) then
		Kormrok.setupFrame:SetScale(VExRT.Bossmods.KormrokScale)
	end
	
	Kormrok.setupFrame.isEnabled = true
	local phaseNow = 1
	function Kormrok:GetCurrentPhase()
		return phaseNow
	end

	local function DisableSync()
		VExRT.Bossmods.Kormrok.sync = nil
		if VExRT.Bossmods.Kormrok.name and VExRT.Bossmods.Kormrok.time then
			Kormrok.setupFrame.lastUpdate:SetText(ExRT.L.BossmodsKromogLastUpdate..": "..VExRT.Bossmods.Kormrok.name.." ("..date("%H:%M:%S %d.%m.%Y",VExRT.Bossmods.Kormrok.time)..")"..(not VExRT.Bossmods.Kormrok.sync and " *" or ""))
		else
			Kormrok.setupFrame.lastUpdate:SetText("")
		end
	end

	local function KormrokFrameOnEvent(self,event,msg,spell,_,lineID,spellID)
		if event == "RAID_BOSS_EMOTE" then
			local fI,tI = nil
			if msg:find("spell:181293") and msg:find("INV_Bijou_Purple") then
				fI,tI = 201,300
			elseif msg:find("spell:181297") and msg:find("INV_Bijou_Orange") then
				fI,tI = 1,100
			elseif msg:find("spell:181300") and msg:find("INV_Bijou_Green") then
				fI,tI = 101,200
			end
			if fI and tI then
				local playerName = UnitName('player')
				for i=fI,tI do
					local name = VExRT.Bossmods.Kormrok[i]
					if name and ExRT.F.delUnitNameServer(name) == playerName then
						local pos = i % 100
						ExRT.F.Arrow:ShowRunTo(Kormrok.runes[pos][1],Kormrok.runes[pos][2],2,6,true,true)
						return
					end
				end
			end
		end
	end

	Kormrok.setupFrame.pings = {}
	local function SetupFramePingsOnEnter(self)
		self.colors = {self.icon:GetVertexColor()}
		self.icon:SetVertexColor(1,.3,1,1)
	end
	local function SetupFramePingsOnLeave(self)
	  	self.icon:SetVertexColor(unpack(self.colors))
	end
	local function SetupFramePingsOnClick(self,button)
		if button == "RightButton" then
			self.colors = {.3,1,.3,1}
			VExRT.Bossmods.Kormrok[ (phaseNow-1)*100 + self._i] = nil
			Kormrok:ReRoster(phaseNow)
			
			DisableSync()
			return
		end
		Kormrok.raidRoster.pos = self._i
		Kormrok.raidRoster.title:SetText(ExRT.L.BossmodsKromogSelectPlayer..self._i)
		Kormrok.raidRoster:Show()
	end
	for i=1,#Kormrok.runes do
		local x = (abs(Kormrok.runes[i][1]-Kormrok.map[1])) / (abs(Kormrok.map[3] - Kormrok.map[1]))
		local y = (abs(Kormrok.runes[i][2]-Kormrok.map[2])) / (abs(Kormrok.map[4] - Kormrok.map[2]))
		Kormrok.setupFrame.pings[i] = CreateFrame('Button',nil,Kormrok.setupFrame)
		Kormrok.setupFrame.pings[i]:SetSize(32,32)
		Kormrok.setupFrame.pings[i].icon = Kormrok.setupFrame.pings[i]:CreateTexture(nil,"ARTWORK")
		Kormrok.setupFrame.pings[i].icon:SetAllPoints()
		Kormrok.setupFrame.pings[i].icon:SetTexture("Interface\\AddOns\\ExRT\\media\\KormrokRune.tga")
		Kormrok.setupFrame.pings[i].num = ExRT.lib.CreateText(Kormrok.setupFrame.pings[i],30,15,nil,0,0,"LEFT","TOP",nil,12,i,nil,1,1,1,nil,1)
		ExRT.lib.SetPoint(Kormrok.setupFrame.pings[i].num,"TOPLEFT",Kormrok.setupFrame.pings[i],"TOPLEFT",0,0)
		Kormrok.setupFrame.pings[i].name = ExRT.lib.CreateText(Kormrok.setupFrame.pings[i],75,15,nil,0,0,"LEFT","TOP",nil,11,"Player"..i,nil,1,1,1,nil,1)
		ExRT.lib.SetPoint(Kormrok.setupFrame.pings[i].name,"TOPLEFT",Kormrok.setupFrame.pings[i],"TOPLEFT",0,-12)
		
		Kormrok.setupFrame.pings[i]:SetScript("OnEnter",SetupFramePingsOnEnter)
		Kormrok.setupFrame.pings[i]:SetScript("OnLeave",SetupFramePingsOnLeave)
		Kormrok.setupFrame.pings[i]:RegisterForClicks("RightButtonDown","LeftButtonDown")
		Kormrok.setupFrame.pings[i]._i = i
		Kormrok.setupFrame.pings[i]:SetScript("OnClick",SetupFramePingsOnClick)
		
		if x >= Kormrok.image[1] and x <= Kormrok.image[3] and y >= Kormrok.image[2] and y <= Kormrok.image[4] then
			Kormrok.setupFrame.pings[i]:SetPoint("CENTER",Kormrok.setupFrame.map,"TOPLEFT", (x - Kormrok.image[1])/(Kormrok.image[3]-Kormrok.image[1])*Kormrok.width,-(y - Kormrok.image[2])/(Kormrok.image[4]-Kormrok.image[2])*(Kormrok.image_avg * Kormrok.width))
		end
	end
	
	local function KormrokClearConfirm()
		for i=1,300 do
			VExRT.Bossmods.Kormrok[i] = nil
		end
		Kormrok:ReRoster(phaseNow)
		
		DisableSync()
	end
	
	Kormrok.setupFrame.clearButton = ExRT.lib.CreateButton(Kormrok.setupFrame,120,20,nil,0,0,ExRT.L.BossmodsKromogClear,nil,nil,"ExRTButtonModernTemplate")
	ExRT.lib.SetPoint(Kormrok.setupFrame.clearButton,"BOTTOMLEFT",Kormrok.setupFrame,7,22)
	Kormrok.setupFrame.clearButton:SetScript("OnClick",function (self)
		StaticPopupDialogs["EXRT_BOSSMODS_KORMROK_CLEAR"] = {
			text = ExRT.L.BossmodsKromogClear,
			button1 = YES,
			button2 = NO,
			OnAccept = KormrokClearConfirm,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("EXRT_BOSSMODS_KORMROK_CLEAR")
	end)
	
	Kormrok.setupFrame.testButton = ExRT.lib.CreateButton(Kormrok.setupFrame,120,20,nil,0,0,ExRT.L.BossmodsKromogTest,nil,nil,"ExRTButtonModernTemplate")
	ExRT.lib.SetPoint(Kormrok.setupFrame.testButton,"BOTTOMRIGHT",Kormrok.setupFrame.clearButton,"TOPRIGHT",0,2)
	Kormrok.setupFrame.testButton:SetScript("OnClick",function (self)
		KormrokFrameOnEvent(Kormrok.setupFrame,"RAID_BOSS_EMOTE",
			phaseNow == 1 and "INV_Bijou_Orange spell:181297" or
			phaseNow == 1 and "INV_Bijou_Green spell:181300" or
			"INV_Bijou_Purple spell:181293"	
		)
		Kormrok.setupFrame:Hide()
		C_Timer.NewTimer(6,function() Kormrok.setupFrame:Show() end)
	end)
	
	VExRT.Bossmods.KormrokSetups = VExRT.Bossmods.KormrokSetups or {}
	local function SetupsDropDown_Load(_,arg)
		for i=1,300 do
			VExRT.Bossmods.Kormrok[i] = VExRT.Bossmods.KormrokSetups[arg][i]
		end
		Kormrok:ReRoster(phaseNow)
		DisableSync()
		CloseDropDownMenus()
	end
	local function SetupsDropDown_Clear(_,arg)
		for i=1,300 do
			VExRT.Bossmods.KormrokSetups[arg][i] = nil
		end
		VExRT.Bossmods.KormrokSetups[arg].date = nil
		CloseDropDownMenus()
	end
	local function SetupsDropDown_Save(_,arg)
		for i=1,300 do
			VExRT.Bossmods.KormrokSetups[arg][i] = VExRT.Bossmods.Kormrok[i]
		end
		VExRT.Bossmods.KormrokSetups[arg].date = time()
		CloseDropDownMenus()
	end
	local function SetupsDropDown_Close()
		CloseDropDownMenus()
	end
	
	local setupsDropDown = CreateFrame("Frame", "ExRT_Kormrok_SetupsDropDown", nil, "UIDropDownMenuTemplate")
	Kormrok.setupFrame.setupsButton = ExRT.lib.CreateButton(Kormrok.setupFrame,120,20,nil,0,0,ExRT.L.BossmodsKromogSetups,nil,nil,"ExRTButtonModernTemplate")
	ExRT.lib.SetPoint(Kormrok.setupFrame.setupsButton,"BOTTOMRIGHT",Kormrok.setupFrame.testButton,"TOPRIGHT",0,2)
	Kormrok.setupFrame.setupsButton:SetScript("OnClick",function (self)
		VExRT.Bossmods.KormrokSetups = VExRT.Bossmods.KormrokSetups or {}
	
		local dropDown = {
			{ text = ExRT.L.BossmodsKromogSetups, isTitle = true, notCheckable = true, notClickable = true},
		}
		for i=1,5 do
			VExRT.Bossmods.KormrokSetups[i] = VExRT.Bossmods.KormrokSetups[i] or {}
		
			local subMenu = nil
			local saveMenu = { text = ExRT.L.BossmodsKromogSetupsSave, func = SetupsDropDown_Save, arg1 = i, notCheckable = true }
			local loadMenu = { text = ExRT.L.BossmodsKromogSetupsLoad, func = SetupsDropDown_Load, arg1 = i, notCheckable = true }
			local clearMenu = { text = ExRT.L.BossmodsKromogSetupsClear, func = SetupsDropDown_Clear, arg1 = i, notCheckable = true }
			
			local isExists = VExRT.Bossmods.KormrokSetups[i].date
			local dateText = ""
			if isExists then
				subMenu = {loadMenu,saveMenu,clearMenu}
				dateText = ". "..date("%H:%M:%S %d.%m.%Y",isExists)
			else
				subMenu = {saveMenu}
			end
			
			dropDown[i+1] = {
				text = i..dateText, hasArrow = true, menuList = subMenu, notCheckable = true
			}
		end
		dropDown[7] = { text = ExRT.L.BossmodsKromogSetupsClose, func = SetupsDropDown_Close, notCheckable = true }
		EasyMenu(dropDown, setupsDropDown, "cursor", 10 , -15, "MENU")
	end)
		
	Kormrok.setupFrame.sendButton = ExRT.lib.CreateButton(Kormrok.setupFrame,120,20,nil,0,0,ExRT.L.BossmodsKromogSend,nil,nil,"ExRTButtonModernTemplate")
	ExRT.lib.SetPoint(Kormrok.setupFrame.sendButton,"BOTTOMRIGHT",Kormrok.setupFrame.setupsButton,"TOPRIGHT",0,2)
	Kormrok.setupFrame.sendButton:SetScript("OnClick",function (self)
		local line = ""
		local counter = 0
		ExRT.F.SendExMsg("kormrok","clear")
		for i=1,300 do
			if VExRT.Bossmods.Kormrok[i] then
				line = line .. i.."\t"..VExRT.Bossmods.Kormrok[i].."\t"
				counter = counter + 1
				if counter > 2 then
					ExRT.F.SendExMsg("kormrok",line)
					counter = 0
					line = ""
				end
			end
		end
		if line ~= "" then
			ExRT.F.SendExMsg("kormrok",line)
		end
	end)
	
	--[[
	Kormrok.setupFrame.disableArrowChk = ExRT.lib.CreateCheckBox(Kormrok.setupFrame,nil,0,0,ExRT.L.BossmodsKormrokArrow,not VExRT.Bossmods.Kormrok.AlwaysArrow,nil,nil,"ExRTCheckButtonModernTemplate")
	ExRT.lib.SetPoint(Kormrok.setupFrame.disableArrowChk,"BOTTOMLEFT",Kormrok.setupFrame.sendButton,"TOPLEFT",0,2)
	Kormrok.setupFrame.disableArrowChk:SetScale(0.9)
	Kormrok.setupFrame.disableArrowChk:SetScript("OnClick",function (self)
		if self:GetChecked() then
			VExRT.Bossmods.Kormrok.AlwaysArrow = nil
		else
			VExRT.Bossmods.Kormrok.AlwaysArrow = true
		end
		Kormrok:RegisterEvents()
	end)
	]]
	
	Kormrok.setupFrame.onlyTrustedChk = ExRT.lib.CreateCheckBox(Kormrok.setupFrame,nil,0,0,ExRT.L.BossmodsKromogOnlyTrusted,not VExRT.Bossmods.Kormrok.UpdatesFromAll,ExRT.L.BossmodsKromogOnlyTrustedTooltip,nil,"ExRTCheckButtonModernTemplate")
	--ExRT.lib.SetPoint(Kormrok.setupFrame.onlyTrustedChk,"BOTTOMLEFT",Kormrok.setupFrame.disableArrowChk,"TOPLEFT",0,2)
	ExRT.lib.SetPoint(Kormrok.setupFrame.onlyTrustedChk,"BOTTOMLEFT",Kormrok.setupFrame.sendButton,"TOPLEFT",0,2)
	Kormrok.setupFrame.onlyTrustedChk:SetScale(0.9)
	Kormrok.setupFrame.onlyTrustedChk:SetScript("OnClick",function (self)
		if self:GetChecked() then
			VExRT.Bossmods.Kormrok.UpdatesFromAll = nil
		else
			VExRT.Bossmods.Kormrok.UpdatesFromAll = true
		end
	end)
	
	Kormrok.setupFrame.lastUpdate = ExRT.lib.CreateText(Kormrok.setupFrame,500,20,nil,0,0,"LEFT","BOTTOM",nil,12,"",nil,1,1,1,nil,1)
	ExRT.lib.SetPoint(Kormrok.setupFrame.lastUpdate,"BOTTOMLEFT",Kormrok.setupFrame,"BOTTOMLEFT",7,5)
	
	local phaseBackground = Kormrok.setupFrame:CreateTexture(nil, "BACKGROUND",nil,2)
	phaseBackground:SetPoint("TOPLEFT",0,0)
	phaseBackground:SetPoint("BOTTOMRIGHT",Kormrok.setupFrame,"TOPRIGHT",0,-50)
	phaseBackground:SetTexture( 1, 1, 1, 1)
	
	local phaseOrange = ExRT.lib.CreateIcon(Kormrok.setupFrame,72,"BOTTOMLEFT",200,70,"Interface\\Icons\\INV_Bijou_Orange.blp",true)
	ExRT.lib.SetPoint(phaseOrange,"CENTER",Kormrok.setupFrame,"BOTTOMLEFT",224,94)
	phaseOrange.phase = 1
	
	phaseOrange.copy = ExRT.lib.CreateButton(Kormrok.setupFrame,65,14,nil,0,0,ExRT.L.BossmodsKormrokCopy,nil,nil,"ExRTButtonModernTemplate")
	phaseOrange.copy:SetNewPoint("CENTER",phaseOrange,0,-50)
	phaseOrange.copy.phase = 1
	phaseOrange.copy.icon = "Interface\\Icons\\INV_Bijou_Orange.blp"
	
	phaseOrange.clear = ExRT.lib.CreateButton(Kormrok.setupFrame,65,14,nil,0,0,ExRT.L.BossmodsKromogSetupsClear,nil,nil,"ExRTButtonModernTemplate")
	phaseOrange.clear:SetNewPoint("CENTER",phaseOrange,0,-50)
	phaseOrange.clear.phase = 1

	local phaseGreen = ExRT.lib.CreateIcon(Kormrok.setupFrame,48,"BOTTOMLEFT",270,70,"Interface\\Icons\\INV_Bijou_Green.blp",true)
	ExRT.lib.SetPoint(phaseGreen,"CENTER",Kormrok.setupFrame,"BOTTOMLEFT",294,94)
	phaseGreen.phase = 2

	phaseGreen.copy = ExRT.lib.CreateButton(Kormrok.setupFrame,65,14,nil,0,0,ExRT.L.BossmodsKormrokCopy,nil,nil,"ExRTButtonModernTemplate")
	phaseGreen.copy:SetNewPoint("CENTER",phaseGreen,0,-50)
	phaseGreen.copy.phase = 2
	phaseGreen.copy.icon = "Interface\\Icons\\INV_Bijou_Green.blp"
	
	phaseGreen.clear = ExRT.lib.CreateButton(Kormrok.setupFrame,65,14,nil,0,0,ExRT.L.BossmodsKromogSetupsClear,nil,nil,"ExRTButtonModernTemplate")
	phaseGreen.clear:SetNewPoint("CENTER",phaseGreen,0,-50)
	phaseGreen.clear.phase = 2

	local phasePurple = ExRT.lib.CreateIcon(Kormrok.setupFrame,48,"BOTTOMLEFT",340,70,"Interface\\Icons\\INV_Bijou_Purple.blp",true)
	ExRT.lib.SetPoint(phasePurple,"CENTER",Kormrok.setupFrame,"BOTTOMLEFT",364,94)
	phasePurple.phase = 3

	phasePurple.copy = ExRT.lib.CreateButton(Kormrok.setupFrame,65,14,nil,0,0,ExRT.L.BossmodsKormrokCopy,nil,nil,"ExRTButtonModernTemplate")
	phasePurple.copy:SetNewPoint("CENTER",phasePurple,0,-50)
	phasePurple.copy.phase = 3
	phasePurple.copy.icon = "Interface\\Icons\\INV_Bijou_Purple.blp"
	
	phasePurple.clear = ExRT.lib.CreateButton(Kormrok.setupFrame,65,14,nil,0,0,ExRT.L.BossmodsKromogSetupsClear,nil,nil,"ExRTButtonModernTemplate")
	phasePurple.clear:SetNewPoint("CENTER",phasePurple,0,-50)
	phasePurple.clear.phase = 1
	
	local phaseBackgroundColors = {
		{r = 1, g = 190/255, b = 82/255},
		{r = 65/255, g = 239/255, b = 85/255},
		{r = 146/255, g = 6/255, b = 185/255},
	}
	local function SetPhaseButton(self)
		phaseNow = self.phase
		
		phaseOrange:SetSize(phaseNow == 1 and 72 or 48,phaseNow == 1 and 72 or 48)
		phaseGreen:SetSize(phaseNow == 2 and 72 or 48,phaseNow == 2 and 72 or 48)
		phasePurple:SetSize(phaseNow == 3 and 72 or 48,phaseNow == 3 and 72 or 48)
		
		phaseOrange.copy:SetShown(phaseNow ~= 1)
		phaseGreen.copy:SetShown(phaseNow ~= 2)
		phasePurple.copy:SetShown(phaseNow ~= 3)

		phaseOrange.clear:SetShown(phaseNow == 1)
		phaseGreen.clear:SetShown(phaseNow == 2)
		phasePurple.clear:SetShown(phaseNow == 3)
		
		phaseBackground:SetGradientAlpha("VERTICAL", 
			phaseBackgroundColors[phaseNow].r,phaseBackgroundColors[phaseNow].g,phaseBackgroundColors[phaseNow].b, 0,
			phaseBackgroundColors[phaseNow].r,phaseBackgroundColors[phaseNow].g,phaseBackgroundColors[phaseNow].b, 0.5
		)
		
		Kormrok:ReRoster(phaseNow)
	end
	local function SetPhaseCopyButton(self)
		StaticPopupDialogs["EXRT_BOSSMODS_KORMROK_COPY"] = {
			text = ExRT.L.BossmodsKormrokCopy .. " |T" ..self.icon..":24|t?",
			button1 = YES,
			button2 = NO,
			OnAccept = function()
				for i=1,100 do
					VExRT.Bossmods.Kormrok[ (phaseNow-1)*100 + i ] = VExRT.Bossmods.Kormrok[ (self.phase-1)*100 + i ]
				end
				Kormrok:ReRoster(phaseNow)
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("EXRT_BOSSMODS_KORMROK_COPY")
	end
	
	local function SetPhaseClearButton(self)
		StaticPopupDialogs["EXRT_BOSSMODS_KORMROK_CLEAR"] = {
			text = ExRT.L.BossmodsKromogClear,
			button1 = YES,
			button2 = NO,
			OnAccept = function()
				for i=1,100 do
					VExRT.Bossmods.Kormrok[ (phaseNow-1)*100 + i ] = nil
				end
				Kormrok:ReRoster(phaseNow)
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("EXRT_BOSSMODS_KORMROK_CLEAR")
	end
	
	phaseOrange:SetScript("OnClick",SetPhaseButton)
	phaseGreen:SetScript("OnClick",SetPhaseButton)
	phasePurple:SetScript("OnClick",SetPhaseButton)

	phaseOrange.copy:SetScript("OnClick",SetPhaseCopyButton)
	phaseGreen.copy:SetScript("OnClick",SetPhaseCopyButton)
	phasePurple.copy:SetScript("OnClick",SetPhaseCopyButton)
	
	phaseOrange.clear:SetScript("OnClick",SetPhaseClearButton)
	phaseGreen.clear:SetScript("OnClick",SetPhaseClearButton)
	phasePurple.clear:SetScript("OnClick",SetPhaseClearButton)

	
	phaseOrange:Click()
	Kormrok.setupFrame.phaseOrange = phaseOrange

	Kormrok.raidRoster = ExRT.lib.CreatePopupFrame(80*4+25,113+14,ExRT.L.BossmodsKromogSelectPlayer,true)
	Kormrok.raidRoster:SetScript("OnShow",function (self)
		Kormrok:UpdateSelectRoster(phaseNow)
	end)
	Kormrok.raidRoster.buttons = {}
	local function RaidRosterButtonOnEnter(self)
		self.hl:Show()
	end
	local function RaidRosterButtonOnLeave(self)
		self.hl:Hide()
	end
	local function RaidRosterButtonOnClick(self)
		local fI = (phaseNow - 1) * 100
		for i=fI+1,fI+100 do
			if VExRT.Bossmods.Kormrok[i] == self._name then
				VExRT.Bossmods.Kormrok[i] = nil
			end
		end
		VExRT.Bossmods.Kormrok[fI + Kormrok.raidRoster.pos] = self._name
		Kormrok:ReRoster(phaseNow)
		Kormrok.raidRoster:Hide()
		
		DisableSync()
	end
	for i=1,4 do
		for j=1,5 do
			local pos = (i-1)*5+j
			Kormrok.raidRoster.buttons[pos] = CreateFrame('Button',nil,Kormrok.raidRoster)
			Kormrok.raidRoster.buttons[pos]:SetPoint("TOPLEFT",15+(i-1)*80,-25-(j-1)*14)
			Kormrok.raidRoster.buttons[pos]:SetSize(80,14)
			ExRT.lib.CreateHoverHighlight(Kormrok.raidRoster.buttons[pos])
			Kormrok.raidRoster.buttons[pos]:SetScript("OnEnter",RaidRosterButtonOnEnter)
			Kormrok.raidRoster.buttons[pos]:SetScript("OnLeave",RaidRosterButtonOnLeave)
			Kormrok.raidRoster.buttons[pos].name = ExRT.lib.CreateText(Kormrok.raidRoster.buttons[pos],80,14,nil,0,0,"LEFT","MIDDLE",nil,12,"",nil,1,1,1,1)
			Kormrok.raidRoster.buttons[pos]._name = nil
			Kormrok.raidRoster.buttons[pos]:SetScript("OnClick",RaidRosterButtonOnClick)
		end
	end
	Kormrok.raidRoster.clearButton = CreateFrame('Button',nil,Kormrok.raidRoster)
	Kormrok.raidRoster.clearButton:SetPoint("BOTTOMRIGHT",Kormrok.raidRoster,"BOTTOMRIGHT",-11,12)
	Kormrok.raidRoster.clearButton:SetSize(80,14)
	ExRT.lib.CreateHoverHighlight(Kormrok.raidRoster.clearButton)
	Kormrok.raidRoster.clearButton:SetScript("OnEnter",function(self)
		self.hl:Show()
	end)
	Kormrok.raidRoster.clearButton:SetScript("OnLeave",function(self)
		self.hl:Hide()
	end)
	Kormrok.raidRoster.clearButton.name = ExRT.lib.CreateText(Kormrok.raidRoster.clearButton,80,14,nil,0,0,"RIGHT","MIDDLE",nil,12,ExRT.L.BossmodsKromogClear,nil,1,1,1,1)
	Kormrok.raidRoster.clearButton:SetScript("OnClick",function(self)
		VExRT.Bossmods.Kormrok[Kormrok.raidRoster.pos] = nil
		Kormrok:ReRoster(phaseNow)
		Kormrok.raidRoster:Hide()
		
		DisableSync()
	end)
	
	Kormrok.raidRoster.hideChk = ExRT.lib.CreateCheckBox(Kormrok.raidRoster,"BOTTOMLEFT",10,7,ExRT.L.BossmodsKromogHidePlayers,true,nil,nil,"ExRTCheckButtonModernTemplate")
	Kormrok.raidRoster.hideChk:SetScale(0.8)
	Kormrok.raidRoster.hideChk:SetScript("OnClick",function (self)
	  	Kormrok.hidePlayers = self:GetChecked()
	  	Kormrok:UpdateSelectRoster(phaseNow)
	end)
	
	function Kormrok:RegisterEvents()
		Kormrok.setupFrame:UnregisterAllEvents()
		Kormrok.setupFrame:RegisterEvent("RAID_BOSS_EMOTE")
		if not VExRT.Bossmods.Kormrok.AlwaysArrow then
			--Kormrok.setupFrame:RegisterEvent("ENCOUNTER_START")
			--Kormrok.setupFrame:RegisterEvent("ENCOUNTER_END")
		end
	end
	Kormrok:RegisterEvents()
	
	Kormrok.setupFrame:SetScript("OnEvent",KormrokFrameOnEvent)
	Kormrok.setupFrame:SetScript("OnShow",function (self)
		local isAlpha = false
		if IsInRaid() then
			if ExRT.F.IsPlayerRLorOfficer(UnitName('player')) then
				isAlpha = false
			else
				isAlpha = true
			end
		end
		if isAlpha then
			self.clearButton:SetAlpha(.2)
			self.sendButton:SetAlpha(.2)
			self.setupsButton:SetAlpha(.2)
		else
			self.clearButton:SetAlpha(1)
			self.sendButton:SetAlpha(1)
			self.setupsButton:SetAlpha(1)		
		end
	end)

	if not VExRT.Bossmods.Kormrok.name or not VExRT.Bossmods.Kormrok.time then
		Kormrok.setupFrame.lastUpdate:SetText("")
	else
		Kormrok.setupFrame.lastUpdate:SetText(ExRT.L.BossmodsKromogLastUpdate..": "..VExRT.Bossmods.Kormrok.name.." ("..date("%H:%M:%S %d.%m.%Y",VExRT.Bossmods.Kormrok.time)..")"..(not VExRT.Bossmods.Kormrok.sync and " *" or ""))
	end
	Kormrok:ReRoster(1)
	Kormrok.setupFrame:Show()
	if InterfaceOptionsFrame:IsShown() then
		InterfaceOptionsFrame:Hide()
	end
	if ExRT.Options.Frame:IsShown() then
		ExRT.Options.Frame:Hide()
	end
end

function Kormrok:addonMessage(sender, prefix, ...)
	if prefix == "kormrok" then
		if IsInRaid() and not VExRT.Bossmods.Kormrok.UpdatesFromAll and not ExRT.F.IsPlayerRLorOfficer(sender) then
			return
		end
	
		local pos1,name1,pos2,name2,pos3,name3 = ...
		VExRT.Bossmods.Kormrok.time = time()
		VExRT.Bossmods.Kormrok.name = sender
		VExRT.Bossmods.Kormrok.sync = true
		if pos1 == "clear" then
			for i=1,300 do
				VExRT.Bossmods.Kormrok[i] = nil
			end
			return
		end
		
		if pos1 and name1 then
			pos1 = tonumber(pos1)
			if name1 == "-" then
				name1 = nil
			end
			VExRT.Bossmods.Kormrok[pos1] = name1
		end
		if pos2 and name2 then
			pos2 = tonumber(pos2)
			if name2 == "-" then
				name2 = nil
			end
			VExRT.Bossmods.Kormrok[pos2] = name2
		end
		if pos3 and name3 then
			pos3 = tonumber(pos3)
			if name3 == "-" then
				name3 = nil
			end
			VExRT.Bossmods.Kormrok[pos3] = name3
		end
		
		if Kormrok.setupFrame then
			Kormrok.setupFrame.lastUpdate:SetText(ExRT.L.BossmodsKromogLastUpdate..": "..VExRT.Bossmods.Kormrok.name.." ("..date("%H:%M:%S %d.%m.%Y",VExRT.Bossmods.Kormrok.time)..")")
			Kormrok:ReRoster( Kormrok:GetCurrentPhase() )
		end
	end
end


-----------------------------------------
-- Options
-----------------------------------------

function module.options:Load()
	self:CreateTilte()

	local PI2 = PI * 2

	local model = CreateFrame("PlayerModel", nil, self)
	model:SetSize(280,220)
	model:SetPoint("BOTTOMRIGHT", 0, 67)
	model:SetFrameStrata("DIALOG")
	model:Hide()
	--EncounterJournal.ceatureDisplayID
	
	model.fac = 0
	model:SetScript("OnUpdate",function (self,elapsed)
		self.fac = self.fac + 0.5
		if self.fac >= 360 then
			self.fac = 0
		end
		self:SetFacing(PI2 / 360 * self.fac)
		
	end)
	model:SetScript("OnShow",function (self)
		self.fac = 0
	end)
	
	self.model = model
	
	local function buttonOnEnter(self)
		if self.modelID then
			model:Show() 
			model:SetDisplayInfo(self.modelID) 
		end
		ExRT.lib.OnEnterTooltip(self)
	end
	local function buttonOnLeave(self)
		model:Hide() 
		ExRT.lib.OnLeaveTooltip(self)
	end
		
	local positionNow = -25
	local function AddTitle(title)
		local this = ExRT.lib.CreateText(self,650,20,nil,5,positionNow,"CENTER",nil,nil,14,title,nil,1,1,1)
		positionNow = positionNow - 20
		return this
	end
	local function AddButton(title,tooltip,clickFunction,modelID,isChk,chkEnabled,chkTooltip)
		local this = ExRT.lib.CreateButton(self,isChk and 625 or 650,20,nil,5,positionNow,title,nil,tooltip,"ExRTButtonModernTemplate")
		this:SetScript("OnClick",clickFunction) 
		this:SetScript("OnEnter",buttonOnEnter) 
		this:SetScript("OnLeave",buttonOnLeave) 
		this.modelID = modelID
		if isChk then
			this.chk = ExRT.lib.CreateCheckBox(self,nil,635,positionNow,"",chkEnabled,chkTooltip,nil,"ExRTCheckButtonModernTemplate")
		end
		positionNow = positionNow - 25
		return this
	end
	
	AddTitle(ExRT.L.bossmodstot)
	AddButton(ExRT.L.bossmodsraden,'/rt raden',RaDen.Load,47739)
	AddTitle(ExRT.L.bossmodssoo)
	AddButton(ExRT.L.bossmodsshaofpride,'/rt shapride',ShaOfPride.Load,49098)
	
	local malkorok_loadbut = AddButton(ExRT.L.bossmodsmalkorok,'/rt malkorok\n/rt malkorok raid',Malkorok.Load,49070,true,not VExRT.Bossmods.MalkorokAutoload,ExRT.L.bossmodsAutoLoadTooltip)
	malkorok_loadbut.chk:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.Bossmods.MalkorokAutoload = nil
		else
			VExRT.Bossmods.MalkorokAutoload = true
		end
	end)
	
	local malkorokAI_loadbut = AddButton(ExRT.L.bossmodsmalkorokai,'/rt malkorokai',MalkorokAI.Load,49070,true,VExRT.Bossmods.MalkorokAIAutoload,ExRT.L.bossmodsAutoLoadTooltip)
	malkorokAI_loadbut.chk:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.Bossmods.MalkorokAIAutoload = true
		else
			VExRT.Bossmods.MalkorokAIAutoload = nil
		end
	end)

	local Spoils_of_Pandaria_loadbut = AddButton(ExRT.L.bossmodsSpoilsofPandaria,nil,SpoilsOfPandaria.Load,51173,true,VExRT.Bossmods.SpoilsOfPandariaAutoload,ExRT.L.bossmodsAutoLoadTooltip)
	Spoils_of_Pandaria_loadbut.chk:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.Bossmods.SpoilsOfPandariaAutoload = true
		else
			VExRT.Bossmods.SpoilsOfPandariaAutoload = nil
		end
	end)
	

	AddTitle(ExRT.L.RaidLootT17Highmaul)

	local Koragh_loadbut = AddButton(ExRT.L.BossmodsKoragh,ExRT.L.BossmodsKoraghHelp,Koragh.Load,54825,true,not VExRT.Bossmods.KoraghAutoload,ExRT.L.bossmodsAutoLoadTooltip)
	Koragh_loadbut.chk:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.Bossmods.KoraghAutoload = nil
		else
			VExRT.Bossmods.KoraghAutoload = true
		end
	end)

	AddButton(ExRT.L.BossmodsMargok,nil,Margok.Load,54329)

	AddTitle(ExRT.L.RaidLootT17BF)

	local Kromog_loadbut = AddButton(ExRT.L.BossmodsKromog,"/rt kromog",Kromog.Load,56214,true,not VExRT.Bossmods.KromogAutoload,ExRT.L.bossmodsAutoLoadTooltip)
	Kromog_loadbut.chk:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.Bossmods.KromogAutoload = nil
		else
			VExRT.Bossmods.KromogAutoload = true
		end
	end)
	
	AddButton(ExRT.L.BossmodsThogar,nil,Thogar.Load,53519)
	
	AddTitle(ExRT.L.RaidLootT18HC)
	
	local Kormrok_loadbut = AddButton(ExRT.L.RaidLootT18HCBoss3.." ["..ExRT.L.sencounterWODMythic.."]","/rt kormrok",Kormrok.Load,61990,true,not VExRT.Bossmods.KormrokAutoload,ExRT.L.bossmodsAutoLoadTooltip)
	Kormrok_loadbut.chk:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.Bossmods.KormrokAutoload = nil
		else
			VExRT.Bossmods.KormrokAutoload = true
		end
	end)	
	
	local Iskar_loadbut = AddButton(ExRT.L.RaidLootT18HCBoss7,"/rt iskar",Iskar.Load,61932)
	
	if Mannoroth then
		local Mannoroth_loadbut = AddButton(ExRT.L.RaidLootT18HCBoss12,"/rt mannoroth",Mannoroth.Load,62410,true,not VExRT.Bossmods.MannorothAutoload,ExRT.L.bossmodsAutoLoadTooltip)
		Mannoroth_loadbut.chk:SetScript("OnClick", function(self,event) 
			if self:GetChecked() then
				VExRT.Bossmods.MannorothAutoload = nil
			else
				VExRT.Bossmods.MannorothAutoload = true
			end
		end)	
	end
	
	local BossmodsSlider1 = ExRT.lib.CreateSlider(self,640,15,0,-550,0,100,ExRT.L.bossmodsalpha,VExRT.Bossmods.Alpha,"TOP",nil,true)
	BossmodsSlider1:SetScript("OnValueChanged", function(self,event) 
		event = event - event%1
		VExRT.Bossmods.Alpha = event	
		if RaDen.mainframe then
			RaDen.mainframe:SetAlpha(event/100)
		end
		if Malkorok.mainframe then
			Malkorok.mainframe:SetAlpha(event/100)
		end
		if ShaOfPride.mainframe then
			ShaOfPride.mainframe:SetAlpha(event/100)
		end
		if SpoilsOfPandaria.mainframe then
			SpoilsOfPandaria.mainframe:SetAlpha(event/100)
		end
		if Thogar.mainframe then
			Thogar.mainframe:SetAlpha(event/100)
		end
		if Margok.mainframe then
			Margok.mainframe:SetAlpha(event/100)
		end
		if Iskar.mainframe then
			Iskar.mainframe:SetAlpha(event/100)
		end
		
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	
	local BossmodsSlider2 = ExRT.lib.CreateSlider(self,640,15,0,-580,5,200,ExRT.L.bossmodsscale,VExRT.Bossmods.Scale or 100,"TOP",nil,true)
	BossmodsSlider2:SetScript("OnValueChanged", function(self,event) 
		event = event - event%1
		VExRT.Bossmods.Scale = event
		if RaDen.mainframe then
			ExRT.mds.SetScaleFix(RaDen.mainframe,event/100)
		end
		if Malkorok.mainframe then
			ExRT.mds.SetScaleFix(Malkorok.mainframe,event/100)
		end
		if ShaOfPride.mainframe then
			ExRT.mds.SetScaleFix(ShaOfPride.mainframe,event/100)
		end
		if SpoilsOfPandaria.mainframe then
			ExRT.mds.SetScaleFix(SpoilsOfPandaria.mainframe,event/100)
		end
		if Thogar.mainframe then
			ExRT.mds.SetScaleFix(Thogar.mainframe,event/100)
		end
		if Margok.mainframe then
			ExRT.mds.SetScaleFix(Margok.mainframe,event/100)
		end
		if Iskar.mainframe then
			ExRT.mds.SetScaleFix(Iskar.mainframe,event/100)
		end
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	
	local clearallbut = ExRT.lib.CreateButton(self,650,20,nil,5,-510,ExRT.L.bossmodsclose,nil,nil,"ExRTButtonModernTemplate")
	clearallbut:SetScript("OnClick",function()
		ExRT.mds:ExBossmodsCloseAll()
	end) 
	
	local ButtonToCenter = ExRT.lib.CreateButton(self,650,20,nil,5,-485,ExRT.L.BossmodsResetPos,nil,ExRT.L.BossmodsResetPosTooltip,"ExRTButtonModernTemplate")
	ButtonToCenter:SetScript("OnClick",function()
		VExRT.Bossmods.RaDenLeft = nil
		VExRT.Bossmods.RaDenTop = nil
		if RaDen.mainframe then
			RaDen.mainframe:ClearAllPoints()
			RaDen.mainframe:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
		end
		
		VExRT.Bossmods.ShaofprideLeft = nil
		VExRT.Bossmods.ShaofprideTop = nil
		if ShaOfPride.mainframe then
			ShaOfPride.mainframe:ClearAllPoints()
			ShaOfPride.mainframe:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
		end
		
		VExRT.Bossmods.MalkorokLeft = nil
		VExRT.Bossmods.MalkorokTop = nil
		if Malkorok.mainframe then
			Malkorok.mainframe:ClearAllPoints()
			Malkorok.mainframe:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
		end	
		
		VExRT.Bossmods.SpoilsofPandariaLeft = nil
		VExRT.Bossmods.SpoilsofPandariaTop = nil
		if SpoilsOfPandaria.mainframe then
			SpoilsOfPandaria.mainframe:ClearAllPoints()
			SpoilsOfPandaria.mainframe:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
		end
		
		VExRT.Bossmods.ThogarLeft = nil
		VExRT.Bossmods.ThogarTop = nil
		if Thogar.mainframe then
			Thogar.mainframe:ClearAllPoints()
			Thogar.mainframe:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
		end		
		
		VExRT.Bossmods.MargokLeft = nil
		VExRT.Bossmods.MargokTop = nil
		if Margok.mainframe then
			Margok.mainframe:ClearAllPoints()
			Margok.mainframe:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
		end
		
		VExRT.Bossmods.IskarLeft = nil
		VExRT.Bossmods.IskarTop = nil
		if Iskar.mainframe then
			Iskar.mainframe:ClearAllPoints()
			Iskar.mainframe:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
		end
	end) 
end

function ExRT.mds:ExBossmodsCloseAll()
	if RaDen.mainframe then
		RaDen.mainframe:Hide()
		RaDen.mainframe:SetScript("OnUpdate", nil)
		RaDen.mainframe:SetScript("OnEvent", nil)
		RaDen.mainframe:UnregisterAllEvents()
		RaDen.mainframe = nil
	end
	if MalkorokAI.mainframe then
		MalkorokAI.mainframe:Hide()
		MalkorokAI.mainframe:UnregisterAllEvents() 
		MalkorokAI.mainframe:SetScript("OnUpdate", nil)
		MalkorokAI.mainframe:SetScript("OnEvent", nil)
		if MalkorokAI.mainframe_2 then
			MalkorokAI.mainframe_2:SetScript("OnUpdate", nil)
			MalkorokAI.mainframe_2 = nil
		end
		MalkorokAI.mainframe = nil
	end
	if Malkorok.mainframe then
		Malkorok.mainframe:Hide()
		Malkorok.mainframe:UnregisterAllEvents()
		Malkorok.mainframe:SetScript("OnUpdate", nil)
		Malkorok.mainframe:SetScript("OnEvent", nil)
		Malkorok.mainframe = nil
	end
	if ShaOfPride.mainframe then
		ShaOfPride.mainframe:Hide()
		ShaOfPride.mainframe:UnregisterAllEvents()
		ShaOfPride.mainframe:SetScript("OnUpdate", nil)
		ShaOfPride.mainframe:SetScript("OnEvent", nil)
		ShaOfPride.mainframe = nil
	end
	if SpoilsOfPandaria.mainframe then
		SpoilsOfPandaria.mainframe:Hide()
		SpoilsOfPandaria.mainframe:SetScript("OnUpdate", nil)
		SpoilsOfPandaria.mainframe = nil
	end
	if Kromog.setupFrame then
		Kromog.setupFrame:UnregisterAllEvents()
		Kromog.setupFrame.isEnabled = nil
	end
	if Thogar.mainframe then
		Thogar.mainframe:Hide()
		Thogar.mainframe:UnregisterAllEvents()
		Thogar.mainframe:SetScript("OnUpdate", nil)
		Thogar.mainframe:SetScript("OnEvent", nil)
		Thogar.mainframe = nil
	end
	if Margok.mainframe then
		Margok.mainframe:Hide()
		Margok.mainframe:UnregisterAllEvents()
		Margok.mainframe:SetScript("OnUpdate", nil)
		Margok.mainframe:SetScript("OnEvent", nil)
		Margok.mainframe = nil
		Margok.rosterFrame:UnregisterAllEvents()
		Margok.rosterFrame:SetScript("OnEvent", nil)
		Margok.rosterFrame = nil
	end
	if Koragh.mainframe then
		Koragh.mainframe:UnregisterAllEvents()
		Koragh.mainframe:SetScript("OnEvent", nil)
		Koragh.mainframe = nil
	end
	if Iskar.mainframe then
		Iskar.mainframe:Hide()
		Iskar.mainframe:UnregisterAllEvents()
		Iskar.mainframe:SetScript("OnUpdate", nil)
		Iskar.mainframe:SetScript("OnEvent", nil)
		Iskar.mainframe:Close()
		if not Iskar.mainframe:IsShown() then
			Iskar.mainframe = nil
		end
	end
	if Kormrok.setupFrame then
		Kormrok.setupFrame:UnregisterAllEvents()
		Kormrok.setupFrame.isEnabled = nil
	end
	if Mannoroth and Mannoroth.setupFrame then
		Mannoroth.setupFrame:UnregisterAllEvents()
		Mannoroth.setupFrame.isEnabled = nil	
	end
end

function module:miniMapMenu()
	SetMapToCurrentZone()
	local cmap = GetCurrentMapAreaID()
	local clvl = GetCurrentMapDungeonLevel()

	if cmap==930 and clvl==8 then
		ExRT.F.MinimapMenuAdd("|cff00ff00"..ExRT.L.bossmodsraden, function() RaDen:Load() CloseDropDownMenus() end,3,"Bossmods_Raden")
	else
		ExRT.mds.MinimapMenuRemove("Bossmods_Raden")
	end

	if cmap==953 and clvl==8 then
		ExRT.mds.MinimapMenuAdd(ExRT.L.bossmodsmalkorok, function() Malkorok:Load() CloseDropDownMenus() end,3,"Bossmods_Malkorok")
	else
		ExRT.mds.MinimapMenuRemove("Bossmods_Malkorok")
	end

	if cmap==953 and clvl==8 then
		ExRT.mds.MinimapMenuAdd(ExRT.L.bossmodsmalkorokai, function() MalkorokAI:Load() CloseDropDownMenus() end,3,"Bossmods_MalkorokAI")
	else
		ExRT.mds.MinimapMenuRemove("Bossmods_MalkorokAI")
	end

	if cmap==953 and clvl==3 then
		ExRT.mds.MinimapMenuAdd(ExRT.L.bossmodsshaofpride, function() ShaOfPride:Load() CloseDropDownMenus() end,3,"Bossmods_Sha")
	else
		ExRT.mds.MinimapMenuRemove("Bossmods_Sha")
	end

	if cmap==953 and clvl==9 then
		ExRT.mds.MinimapMenuAdd(ExRT.L.bossmodsSpoilsofPandaria, function() SpoilsOfPandaria:Load() CloseDropDownMenus() end,3,"Bossmods_Spoils")
	else
		ExRT.mds.MinimapMenuRemove("Bossmods_Spoils")
	end
	
	if cmap==994 and clvl==4 then
		ExRT.mds.MinimapMenuAdd(ExRT.L.BossmodsKoragh, function() Koragh:Load() CloseDropDownMenus() end,3,"Bossmods_Koragh")
	else
		ExRT.mds.MinimapMenuRemove("Bossmods_Koragh")
	end
	
	if cmap==994 and clvl==6 then
		ExRT.mds.MinimapMenuAdd(ExRT.L.BossmodsMargok, function() Margok:Load() CloseDropDownMenus() end,3,"Bossmods_Margok")
	else
		ExRT.mds.MinimapMenuRemove("Bossmods_Margok")
	end
	
	if cmap==988 and clvl==1 then
		ExRT.mds.MinimapMenuAdd(ExRT.L.BossmodsKromog, function() Kromog:Load() CloseDropDownMenus() end,3,"Bossmods_Kromog")
	else
		ExRT.mds.MinimapMenuRemove("Bossmods_Kromog")
	end

	if cmap==988 and clvl==4 then
		ExRT.mds.MinimapMenuAdd(ExRT.L.BossmodsThogar, function() Thogar:Load() CloseDropDownMenus() end,3,"Bossmods_Thogar")
	else
		ExRT.mds.MinimapMenuRemove("Bossmods_Thogar")
	end
	
	if cmap==1026 and clvl==6 then
		ExRT.mds.MinimapMenuAdd(ExRT.L.RaidLootT18HCBoss7, function() Iskar:Load() CloseDropDownMenus() end,3,"Bossmods_Iskar")
	else
		ExRT.mds.MinimapMenuRemove("Bossmods_Iskar")
	end
	
	if cmap==1026 and clvl==4 then
		ExRT.mds.MinimapMenuAdd(ExRT.L.RaidLootT18HCBoss3, function() Kormrok:Load() CloseDropDownMenus() end,3,"Bossmods_Kormrok")
	else
		ExRT.mds.MinimapMenuRemove("Bossmods_Kormrok")
	end
	
	if cmap==1026 and clvl==9 and Mannoroth then
		ExRT.mds.MinimapMenuAdd(ExRT.L.RaidLootT18HCBoss12, function() Mannoroth:Load() CloseDropDownMenus() end,3,"Bossmods_Mannoroth")
	else
		ExRT.mds.MinimapMenuRemove("Bossmods_Mannoroth")
	end

	if RaDen.mainframe or Malkorok.mainframe or ShaOfPride.mainframe or SpoilsOfPandaria.mainframe or Thogar.mainframe or Margok.mainframe or (Kromog.setupFrame and Kromog.setupFrame.isEnabled) or Koragh.mainframe or Iskar.mainframe then
		ExRT.mds.MinimapMenuAdd("|cffff9999"..ExRT.L.bossmodsclose, function() ExRT.mds:ExBossmodsCloseAll() CloseDropDownMenus() end,4,"Bossmods_Close")
	else
		ExRT.mds.MinimapMenuRemove("Bossmods_Close")
	end
end


function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.Bossmods = VExRT.Bossmods or {}
	
	module:RegisterEvents('ENCOUNTER_START','ENCOUNTER_END')
	module:RegisterAddonMessage()
	module:RegisterMiniMapMenu()
	module:RegisterSlash()
	
	--Kromog
	VExRT.Bossmods.Kromog = VExRT.Bossmods.Kromog or {}
	--Kormrok
	VExRT.Bossmods.Kormrok = VExRT.Bossmods.Kormrok or {}
	--Mannoroth
	VExRT.Bossmods.Mannoroth = VExRT.Bossmods.Mannoroth or {}	
end


function module:addonMessage(sender, prefix, ...)
	Malkorok:addonMessage(sender, prefix, ...)
	Kromog:addonMessage(sender, prefix, ...)
	Kormrok:addonMessage(sender, prefix, ...)
	if Mannoroth then
		Mannoroth:addonMessage(sender, prefix, ...)
	end
end

function module.main:ENCOUNTER_START(encounterID,encounterName,difficultyID,groupSize,...)
	if encounterID == 1595 and not VExRT.Bossmods.MalkorokAutoload and not Malkorok.mainframe then
		Malkorok:Load()
		if VExRT.Bossmods.MalkorokAIAutoload then
			MalkorokAI:Load()
		end
	elseif encounterID == 1594 and VExRT.Bossmods.SpoilsOfPandariaAutoload and not SpoilsOfPandaria.mainframe then
		SpoilsOfPandaria:Load()
	elseif encounterID == 1692 and not Thogar.mainframe and 1==2 then
		Thogar:Load()
		local func = Thogar.mainframe:GetScript("OnEvent")
		func(Thogar.mainframe,encounterID,encounterName,difficultyID,groupSize,...)
	elseif encounterID == 1723 and not Koragh.mainframe and not VExRT.Bossmods.KoraghAutoload and difficultyID == 16 then		
		Koragh:Load()
	elseif encounterID == 1713 and not Kromog.setupFrame and not VExRT.Bossmods.KromogAutoload then
		Kromog:Load()
		Kromog.setupFrame:Hide()
	elseif encounterID == 1787 and (not Kormrok.setupFrame or not Kormrok.setupFrame.isEnabled) and not VExRT.Bossmods.KormrokAutoload then
		Kormrok:Load()
		Kormrok.setupFrame:Hide()
	elseif encounterID == 1795 and Mannoroth and (not Mannoroth.setupFrame or not Mannoroth.setupFrame.isEnabled) and not VExRT.Bossmods.MannorothAutoload then
		Mannoroth:Load()
		Mannoroth.setupFrame:Hide()
	end
end

function module.main:ENCOUNTER_END(encounterID,_,_,_,success)
	if not (success == 1) then
		return
	elseif encounterID == 1594 and SpoilsOfPandaria.mainframe then
		ExRT.mds:ExBossmodsCloseAll()
	elseif encounterID == 1604 and ShaOfPride.mainframe then
		ExRT.mds:ExBossmodsCloseAll()
	elseif encounterID == 1595 and Malkorok.mainframe then
		ExRT.mds:ExBossmodsCloseAll()
	elseif encounterID == 1692 and Thogar.mainframe then
		ExRT.mds:ExBossmodsCloseAll()
	elseif encounterID == 1723 and Koragh.mainframe then
		ExRT.mds:ExBossmodsCloseAll()
	elseif encounterID == 1788 and Iskar.mainframe then
		C_Timer.NewTimer(2.5, function() ExRT.mds:ExBossmodsCloseAll() end)
	elseif encounterID == 1787 and Kormrok.setupFrame and Kormrok.setupFrame.isEnabled then
		ExRT.mds:ExBossmodsCloseAll()
	elseif encounterID == 1795 and Mannoroth and Mannoroth.setupFrame and Mannoroth.setupFrame.isEnabled then
		ExRT.mds:ExBossmodsCloseAll()
	end
end

function module:slash(arg)
	if arg == "raden" then
		RaDen:Load()
	elseif arg == "malkorok raid" then
		Malkorok:PShow()
	elseif arg == "malkorok map" then
		Malkorok:MapNow()
	elseif arg == "malkorok" then
		Malkorok:Load()
	elseif arg == "malkorokai" then
		MalkorokAI:Load()
	elseif arg == "shapride" then
		ShaOfPride:Load()
	elseif arg == "kromog" then
		Kromog:Load()
	elseif arg == "iskar" then
		Iskar:Load()
	elseif arg == "kormrok" then
		Kormrok:Load()
	elseif arg == "mannoroth" then
		Mannoroth:Load()
	end
end