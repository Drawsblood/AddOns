local _, T = ...
if T.Mark ~= 50 then return end
local L, G, E, api = T.L, T.Garrison, T.Evie, T.MissionsUI

local ui, core, handle = CreateFrame("Frame", "MPLandingPageAlts", GarrisonLandingPage) do
	ui:Hide()
	ui:SetAllPoints()
	
	local t = ui:CreateFontString(nil, "ARTWORK", "QuestFont_Enormous")
	t:SetPoint("LEFT", ui:GetParent().HeaderBar, "LEFT", 26, 0)
	t:SetText(GARRISON_LANDING_PAGE_TITLE)
	ui.Title = t
	
	t = CreateFrame("Button", "GarrisonLandingPageTab4", GarrisonLandingPage, "GarrisonLandingPageTabTemplate", 4)
	t:SetPoint("LEFT", GarrisonLandingPageTab3, "RIGHT", -5, 0)
	t:SetText(L"Other Characters")
	ui.Tab = t
	core, ui.List = api.createScrollList(ui, 740, 380)
	ui.List:ClearAllPoints()
	ui.List:SetPoint("RIGHT", -40, -30)

	
	local _GarrisonLandingPageTab_SetTab = GarrisonLandingPageTab_SetTab
	function GarrisonLandingPageTab_SetTab(...)
		_GarrisonLandingPageTab_SetTab(...)
		if ... == ui.Tab then
			GarrisonLandingPage.ShipFollowerList:Hide();
			GarrisonLandingPage.ShipFollowerTab:Hide();
			ui:Show()
			PanelTemplates_SelectTab(ui.Tab)
		else
			ui:Hide()
			PanelTemplates_DeselectTab(ui.Tab)
		end
	end
	hooksecurefunc("GarrisonLandingPage_UpdateTabs", function(self)
		ui.Tab:SetPoint("LEFT", self.FleetTab:IsShown() and GarrisonLandingPageTab3 or GarrisonLandingPageTab2, "RIGHT", -5, 0)
	end)
	
	
	local function Timer_OnEnter(self)
		if self.itemID then
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			GameTooltip:SetItemByID(self.itemID)
			if type(self.lastOffer) == "number" then
				GameTooltip:AddLine("|n" .. (L"Last offered: %s ago"):format(
					HIGHLIGHT_FONT_COLOR_CODE .. G.GetTimeStringFromSeconds(G.stime() - self.lastOffer) .. "|r"))
				GameTooltip:Show()
			end
		elseif self.cacheSize then
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			T.SetCacheTooltip(GameTooltip, false, G.GetResourceCacheInfo(self.cacheTime, self.cacheSize))
		end
	end
	local function Timer_OnLeave(self)
		if GameTooltip:IsOwned(self) then
			GameTooltip:Hide()
		end
	end
	local function Timer_OnDone(self)
		self:GetParent().AltDone:Show()
	end
	local function Char_GetName(d)
		local name, sum, all = d[1] .. "-" .. d[2], d[3], d[4]
		if GetRealmName() == d[1] then
			name = d[2]
		end
		return "|c" .. (RAID_CLASS_COLORS[sum.class or all.class].colorStr or "ffffffff") .. name
	end
	local dmFrame, dm = CreateFrame("Frame", "MasterPlanLandingDrop", nil, "UIDropDownMenuTemplate"), {
		{notCheckable=true, isTitle=true},
		{text=REMOVE,
			func=function(_, r, a)
				MasterPlanAG[r][a] = nil
				E"MP_FORCE_LANDING_ALTS_REFRESH"
			end,
			notCheckable=true
		},
		{text=CANCEL, notCheckable=true}
	}
	local function Char_OnClick(self)
		local d = core:GetRowData(handle, self)
		dm[1].text, dm[2].arg1, dm[2].arg2 = Char_GetName(d), d[1], d[2]
		EasyMenu(dm, dmFrame, "cursor", 0, 0, "MENU", 4)
	end
	local function CreateCharEntry()
		local f = CreateFrame("Button")
		f:SetSize(700, 54)
		f:SetScript("OnClick", Char_OnClick)
		f:RegisterForClicks("RightButtonUp")
		
		local b, t = f, f:CreateTexture(nil, "BACKGROUND", nil, 0)
		t:SetAtlas("GarrMission_MissionParchment")
		t:SetHorizTile(true)
		t:SetVertTile(true)
		t:SetVertexColor(0.75, 0.52, 0.05)
		t:SetAllPoints()
		t = b:CreateTexture(nil, "BACKGROUND", nil, 1)
		t:SetAtlas("!GarrMission_Bg-Edge", true)
		t:SetVertTile(true)
		t:SetPoint("TOPLEFT", -10, 0)
		t:SetPoint("BOTTOMLEFT", -10, 0)
		t:SetVertexColor(0.75, 0.52, 0.05)
		t = b:CreateTexture(nil, "BACKGROUND", nil, 1)
		t:SetAtlas("!GarrMission_Bg-Edge", true)
		t:SetVertTile(true)
		t:SetPoint("TOPRIGHT", 10, 0)
		t:SetPoint("BOTTOMRIGHT", 10, 0)
		t:SetVertexColor(1, 0.8, 0.65)
		t:SetTexCoord(1,0, 0,1)
		t = b:CreateTexture(nil, "BORDER")
		t:SetAtlas("_GarrMission_TopBorder", true)
		t:SetPoint("TOPLEFT", 20, 4)
		t:SetPoint("TOPRIGHT", -20, 4)
		t = b:CreateTexture(nil, "BORDER")
		t:SetAtlas("_GarrMission_TopBorder", true)
		t:SetPoint("BOTTOMLEFT", 20, -4)
		t:SetPoint("BOTTOMRIGHT", -20, -4)
		t:SetTexCoord(0,1, 1,0)
		t = b:CreateTexture(nil, "BORDER", nil, 1)
		t:SetAtlas("GarrMission_TopBorderCorner", true)
		t:SetPoint("TOPLEFT", -5, 4)
		t = b:CreateTexture(nil, "BORDER", nil, 1)
		t:SetAtlas("GarrMission_TopBorderCorner", true)
		t:SetPoint("TOPRIGHT", 6, 4)
		t:SetTexCoord(1,0, 0,1)
		t = b:CreateTexture(nil, "BORDER", nil, 1)
		t:SetAtlas("GarrMission_TopBorderCorner", true)
		t:SetPoint("BOTTOMLEFT", -5, -4)
		t:SetTexCoord(0,1, 1,0)
		t = b:CreateTexture(nil, "BORDER", nil, 1)
		t:SetAtlas("GarrMission_TopBorderCorner", true)
		t:SetPoint("BOTTOMRIGHT", 6, -4)
		t:SetTexCoord(1,0, 1,0)
		t = b:CreateTexture(nil, "BACKGROUND", nil, 6)
		t:SetTexture(0,0,0,0.25)
		t:SetPoint("TOPLEFT", 2, -2)
		t:SetPoint("BOTTOMRIGHT", -2, 2)

		t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightHuge")
		t:SetPoint("LEFT", 14, 6)
		f.Name, f.Timers = t, {}
		t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		t:SetPoint("TOPLEFT", f.Name, "BOTTOMLEFT", 0, -1)
		f.Summary = t
		
		for i=1,#T.TrackedMissionSets+1 do
			t = CreateFrame("Frame", nil, f, "GarrisonLandingPageReportShipmentStatusTemplate")
			t:SetScale(42/64)
			t:SetPoint("RIGHT", (40 -55*i)/t:GetScale(), 0)
			t:SetScript("OnEnter", Timer_OnEnter)
			t:SetScript("OnLeave", Timer_OnLeave)
			t.Swipe:SetScript("OnCooldownDone", Timer_OnDone)
			t.Done:Hide()
			t.BG:Show()
			t.Border:Show()
			t.Border:SetDrawLayer("BORDER", -1)
			t.AltDone = t:CreateTexture(nil, "OVERLAY")
			t.AltDone:SetTexture("Interface/Garrison/Garr_TimerFill")
			t.AltDone:SetSize(90.5, 90.5)
			t.AltDone:SetPoint("CENTER")
			f.Timers[i] = t
		end
		return f
	end
	local function SetCharEntry(f, d)
		local nt, sum, all = 1, d[3], d[4]
		f.Name:SetText(Char_GetName(d))
		if all.lastCacheTime then
			local t = f.Timers[nt]
			nt, t.cacheTime, t.cacheSize, t.itemID, t.lastOffer = nt + 1, all.lastCacheTime, all.cacheSizeU or all.cacheSize or 500
			local cv, mv, st, md = G.GetResourceCacheInfo(t.cacheTime, t.cacheSize)
			SetPortraitToTexture(t.Icon, "Interface\\Icons\\INV_Garrison_Resource")
			t.Icon:SetDesaturated(true)
			if cv == mv then
				t.Swipe:SetCooldownUNIX(0, 0)
			else
				t.Swipe:SetCooldownUNIX(st, md)
			end
			t.AltDone:SetShown(cv == mv)
			t:Show()
		end
		
		local now = G.stime()
		for i=1,#T.TrackedMissionSets do
			local ls = sum["tt" .. i]
			if ls then
				local t = f.Timers[nt]
				nt, t.itemID, t.lastOffer, t.cacheTime, t.cacheSize = nt + 1, sum["ti" .. i], ls
				SetPortraitToTexture(t.Icon, GetItemIcon(t.itemID))
				t.Icon:SetDesaturated(ls ~= true)
				local endTime = ls ~= true and (ls + 1252800)
				if endTime and endTime > now then
					t.AltDone:Hide()
					t.Swipe:SetCooldownUNIX(ls, 1252800)
				else
					t.AltDone:Show()
					t.Swipe:SetCooldownUNIX(0,0)
				end
				t:Show()
			end
		end
		
		if not sum.inProgress then
			f.Summary:SetText(L"No active missions")
		else
			local total, complete, now = 0,0, time()
			for k,v in pairs(sum.inProgress) do
				total = total + 1
				if v <= now then
					complete = complete + 1
				end
			end
			f.Summary:SetText((L"%d/%d active missions complete"):format(complete, total))
		end
		
		for i=nt,#f.Timers do
			f.Timers[i]:Hide()
		end
	end
	
	local h, data = core:CreateHandle(CreateCharEntry, SetCharEntry, 58)
	handle = h
	local function initData()
		local d, cr, me = {}, GetRealmName(), UnitName("player")
		for r,c in pairs(MasterPlanAG) do
			for c,t in pairs(c) do
				if t.summary and (c ~= me or r ~= cr) then
					d[#d+1] = {r,c, t.summary, t}
				end
			end
		end
		table.sort(d, function(a, b)
			local ac, bc = a[1], b[1]
			if ac ~= bc then
				return ac == cr or (bc ~= cr and ac < bc)
			end
			return a[2] < b[2]
		end)
		data = d
		return data
	end
	ui:SetScript("OnShow", function()
		core:SetData(data or initData(), h)
	end)
	function E:MP_FORCE_LANDING_ALTS_REFRESH()
		core:SetData(initData(), h)
	end
end

local lastIP, lastAvail = C_Garrison.GetInProgressMissions(), {}
function E:PLAYER_LOGOUT()
	local t, now = {}, G.stime()
	MasterPlanA.data.summary = t
	
	for k=1,#T.TrackedMissionSets do
		local m = T.TrackedMissionSets[k]
		for i=1,#m do
			local last, lastID
			for j=2,#m[i] do
				local id = m[i][j]
				local _, _, _, lastSpawn = G.GetMissionSeen(id, lastAvail[id])
				if lastSpawn and (last == nil or last > lastSpawn) then
					last, lastID = lastSpawn, id
				end
			end
			if last then
				t["ti" .. k], t["tt" .. k] = m[i][1], lastAvail[lastID] and true or (now - last)
				break
			end
		end
	end
	local r, ip = {}, lastIP or C_Garrison.GetInProgressMissions()
	for k,v in pairs(ip) do
		r[v.missionID] = v.missionEndTime
	end
	if next(r) then t.inProgress = r end
	
	if not next(t) then
		MasterPlanA.data.summary = nil
	end
end
local function storeIP()
	lastIP = C_Garrison.GetInProgressMissions()
end
local function queueStoreIP()
	if lastIP then
		lastIP = nil
		T.After0(storeIP)
	end
end
local function syncAvailable()
	local mt = C_Garrison.GetAvailableMissions()
	G.ObserveMissions(mt, "*")
	queueStoreIP()
	wipe(lastAvail)
	for i=1,#mt do
		local m = mt[i]
		lastAvail[m.missionID] = m
	end
end
E.GARRISON_MISSION_COMPLETE_RESPONSE, E.GARRISON_MISSION_BONUS_ROLL_COMPLETE = queueStoreIP, queueStoreIP
E.GARRISON_SHOW_LANDING_PAGE, E.GARRISON_MISSION_STARTED, E.GARRISON_MISSION_NPC_OPENED, E.GARRISON_SHIPYARD_NPC_OPENED = syncAvailable, syncAvailable, syncAvailable, syncAvailable
C_Timer.After(2, syncAvailable)