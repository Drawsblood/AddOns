local GlobalAddonName, ExRT = ...

local UnitInGuild, IsInRaid = ExRT.mds.UnitInGuild, IsInRaid

local VExRT = nil

local module = ExRT.mod:New("InviteTool",ExRT.L.invite,nil,true)
module.db.converttoraid = false
module.db.massinv = false
module.db.invWordsArray = {}
module.db.promoteWordsArray = {}
module.db.masterlootersArray = {}
module.db.reInvite = {}
module.db.reInviteR = nil
module.db.reInviteFrame = nil

module.db.demotedPlayers = {}

module.db.sessionInRaid = nil

hooksecurefunc("DemoteAssistant", function (unit)
	if not unit then
		return
	end
	local name = UnitName(unit)
	if name then
		name = ExRT.mds.delUnitNameServer(name)
		module.db.demotedPlayers[ name ] = true
	end
end)

local _InviteUnit = InviteUnit
local function InviteUnit(name)
	if name and name:len() >= 45 then
		local shortName = ExRT.mds.delUnitNameServer(name)
		_InviteUnit(shortName)
	else
		_InviteUnit(name)
	end
end

local function CheckUnitInRaid(name,shortName)
	if not shortName then
		shortName = ExRT.mds.delUnitNameServer(name)
	end
	if UnitName(name) or UnitName(shortName) then
		return true
	end
	return false
end

local function InviteBut()
	local gplayers = GetNumGuildMembers() or 0
	local nowinvnum = 1
	local inRaid = IsInRaid()
	module.db.converttoraid = true
	for i=1,gplayers do
		local name,_,rankIndex,level,_,_,_,_,online,_,_,_,_,isMobile = GetGuildRosterInfo(i)
		local sName = ExRT.mds.delUnitNameServer(name)
		if name and rankIndex < VExRT.InviteTool.Rank and online and level == 100 and not isMobile and not CheckUnitInRaid(name,sName) and sName ~= module.db.playerFullName then
			if inRaid then
				InviteUnit(name)
			elseif nowinvnum < 5 then
				nowinvnum = nowinvnum + 1
				InviteUnit(name)
			else
				module.db.massinv = true
				return
			end
		end
	end
end

local function DisbandBut()
	local n = GetNumGroupMembers() or 0
	local myname = UnitName("player")
	for j=n,1,-1 do
		local nown = GetNumGroupMembers() or 0
		if nown > 0 then
			local name, rank = GetRaidRosterInfo(j)
			if name and myname ~= name then
				UninviteUnit(name)
			end
		end
	end
end

local function ReinviteHelpFunc()
	local inRaid = IsInRaid()
	local nowinvnum = 0
	for i=1,#module.db.reInvite do
		if not UnitInRaid(module.db.reInvite[i]) then
			if inRaid then
				InviteUnit(module.db.reInvite[i])
			elseif nowinvnum < 5 then
				nowinvnum = nowinvnum + 1
				InviteUnit(module.db.reInvite[i])
			end
		end
	end
end

local function ReinviteBut()
	local inRaid = IsInRaid()
	if not inRaid then
		return
	end
	table.wipe(module.db.reInvite)
	local n = GetNumGroupMembers() or 0
	for j=1,n do
		local name = GetRaidRosterInfo(j)
		table.insert(module.db.reInvite,name)
	end
	DisbandBut()
	
	if not module.db.reInviteFrame then
		module.db.reInviteFrame = CreateFrame("Frame")
	end
	
	module.db.reInviteFrame.t = 0
	module.db.reInviteFrame:SetScript("OnUpdate",function(self,e)
		self.t = self.t + e
		if self.t > 5 then
			module.db.converttoraid = true
			module.db.reInviteR = true
			ReinviteHelpFunc()
			self:SetScript("OnUpdate",nil)
		end
	end)
end

local function createInvWordsArray()
	if VExRT.InviteTool.Words then
		table.wipe(module.db.invWordsArray)
		local tmpCount = 1
		local tmpStr = strsplit(" ",VExRT.InviteTool.Words)
		while tmpStr do
			if tmpStr ~= "" and tmpStr ~= " " then
				module.db.invWordsArray[tmpStr] = 1
			end
			tmpCount = tmpCount + 1
			tmpStr = select(tmpCount,strsplit(" ",VExRT.InviteTool.Words))
		end
	end
end

local function createPromoteArray()
	if VExRT.InviteTool.PromoteNames then
		table.wipe(module.db.promoteWordsArray)
		local tmpCount = 1
		local tmpStr = strsplit(" ",VExRT.InviteTool.PromoteNames)
		while tmpStr do
			if tmpStr ~= "" and tmpStr ~= " " then
				module.db.promoteWordsArray[tmpStr] = 1
			end
			tmpCount = tmpCount + 1
			tmpStr = select(tmpCount,strsplit(" ",VExRT.InviteTool.PromoteNames))
		end
	end
end

local function demoteRaid()
	for i = 1, GetNumGroupMembers() do
		local name, rank = GetRaidRosterInfo(i)
		if name and rank == 1 then
			DemoteAssistant(name)
		end
	end
end

local function createMastelootersArray()
	if VExRT.InviteTool.MasterLooters then
		table.wipe(module.db.masterlootersArray)
		local tmpCount = 1
		local tmpStr = strsplit(" ",strtrim(VExRT.InviteTool.MasterLooters))
		while tmpStr do
			if tmpStr ~= "" and tmpStr ~= " " then
				module.db.masterlootersArray[#module.db.masterlootersArray + 1] = tmpStr
			end
			tmpCount = tmpCount + 1
			tmpStr = select(tmpCount,strsplit(" ",strtrim(VExRT.InviteTool.MasterLooters)))
		end
	end
end

function module.options:Load()
	self:CreateTilte()

	self.dropDown = ExRT.lib.CreateScrollDropDown(self,"TOPLEFT",5,-30,220,205,10,"",nil,"ExRTDropDownMenuModernTemplate")
	
	function self.dropDown:SetValue(newValue)
		VExRT.InviteTool.Rank = newValue
		module.options.dropDown:SetText( ExRT.L.inviterank.." " .. GuildControlGetRankName(newValue) or "")
		ExRT.lib.ScrollDropDown.Close()
		for i=1,#module.options.dropDown.List do
			module.options.dropDown.List[i].checkState = VExRT.InviteTool.Rank == module.options.dropDown.List[i].arg1
		end
	end

	if IsInGuild() then
		local granks = GuildControlGetNumRanks()
		for i=granks,1,-1 do
			self.dropDown.List[#self.dropDown.List + 1] = {
				text = GuildControlGetRankName(i) or "",
				checkState = VExRT.InviteTool.Rank == i,
				radio = true,
				func = self.dropDown.SetValue,
				arg1 = i,
			}
		end
		self.dropDown.Lines = #self.dropDown.List
	end
	
	
	self.butInv = ExRT.lib.CreateButton(self,200,20,nil,235,-30,ExRT.L.inviteinv,nil,nil,"ExRTButtonModernTemplate")
	self.butInv:SetScript("OnClick",function()
		InviteBut()
	end)  
	self.butInv.txt = ExRT.lib.CreateText(self,100,20,nil,445,-32,nil,nil,nil,11,"/rt inv")
	self.butInv.txt:SetNewPoint("LEFT",self.butInv,"RIGHT",5,0)
	
	self.butDisband = ExRT.lib.CreateButton(self,430,20,nil,5,-55,ExRT.L.invitedis,nil,nil,"ExRTButtonModernTemplate")
	self.butDisband:SetScript("OnClick",function()
		DisbandBut()
	end)  
	self.butDisband.txt = ExRT.lib.CreateText(self,100,20,nil,445,-60,nil,nil,nil,11,"/rt dis")
	self.butDisband.txt:SetNewPoint("LEFT",self.butDisband,"RIGHT",5,0)
	
	self.butReinvite = ExRT.lib.CreateButton(self,430,20,nil,5,-80,ExRT.L.inviteReInv,nil,nil,"ExRTButtonModernTemplate")
	self.butReinvite:SetScript("OnClick",function()
		ReinviteBut()
	end) 
	self.butReinvite.txt = ExRT.lib.CreateText(self,100,20,nil,445,-85,nil,nil,nil,11,"/rt reinv")
	self.butReinvite.txt:SetNewPoint("LEFT",self.butReinvite,"RIGHT",5,0)

	self.chkInvByChat = ExRT.lib.CreateCheckBox(self,nil,5,-115,ExRT.L.invitewords,VExRT.InviteTool.InvByChat,nil,nil,"ExRTCheckButtonModernTemplate")
	self.chkInvByChat:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.InviteTool.InvByChat = true
			module:RegisterEvents('CHAT_MSG_WHISPER','CHAT_MSG_BN_WHISPER')
		else
			VExRT.InviteTool.InvByChat = nil
			module:UnregisterEvents('CHAT_MSG_WHISPER','CHAT_MSG_BN_WHISPER')
		end
	end)

	self.chkOnlyGuild = ExRT.lib.CreateCheckBox(self,nil,5,-140,ExRT.L.inviteguildonly,VExRT.InviteTool.OnlyGuild,nil,nil,"ExRTCheckButtonModernTemplate")
	self.chkOnlyGuild:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.InviteTool.OnlyGuild = true
		else
			VExRT.InviteTool.OnlyGuild = nil
		end
	end)
	
	self.wordsInput = ExRT.lib.CreateEditBox(self,650,20,"TOPLEFT",5,-165,ExRT.L.invitewordstooltip,nil,nil,"ExRTInputBoxModernTemplate",VExRT.InviteTool.Words)
	self.wordsInput:SetScript("OnTextChanged",function(self)
		VExRT.InviteTool.Words = self:GetText()
		createInvWordsArray()
	end) 	
	
	self.chkAutoInvAccept = ExRT.lib.CreateCheckBox(self,nil,5,-200,ExRT.L.inviteaccept,VExRT.InviteTool.AutoInvAccept,nil,nil,"ExRTCheckButtonModernTemplate")
	self.chkAutoInvAccept:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.InviteTool.AutoInvAccept = true
			module:RegisterEvents('PARTY_INVITE_REQUEST')
		else
			VExRT.InviteTool.AutoInvAccept = nil
			module:UnregisterEvents('PARTY_INVITE_REQUEST')
		end
	end)
	
	self.chkAutoPromote = ExRT.lib.CreateCheckBox(self,nil,5,-235,ExRT.L.inviteAutoPromote,VExRT.InviteTool.AutoPromote,nil,nil,"ExRTCheckButtonModernTemplate")
	self.chkAutoPromote:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.InviteTool.AutoPromote = true
		else
			VExRT.InviteTool.AutoPromote = nil
		end
	end)
	
	self.dropDownAutoPromote = ExRT.lib.CreateScrollDropDown(self,"TOPLEFT",5,-260,430,205,10,"",nil,"ExRTDropDownMenuModernTemplate")
	function self.dropDownAutoPromote:SetValue(newValue)
		VExRT.InviteTool.PromoteRank = newValue
		module.options.dropDownAutoPromote:SetText( ExRT.L.inviterank.." " .. (newValue == 0 and ExRT.L.inviteAutoPromoteDontUseGuild or GuildControlGetRankName(newValue) or ""))
		ExRT.lib.ScrollDropDown.Close()
		for i=1,#module.options.dropDownAutoPromote.List do
			module.options.dropDownAutoPromote.List[i].checkState = VExRT.InviteTool.PromoteRank == module.options.dropDownAutoPromote.List[i].arg1
		end
	end
	if IsInGuild() then
		local granks = GuildControlGetNumRanks()
		for i=granks,1,-1 do
			self.dropDownAutoPromote.List[#self.dropDownAutoPromote.List + 1] = {
				text = GuildControlGetRankName(i) or "",
				checkState = VExRT.InviteTool.PromoteRank == i,
				radio = true,
				func = self.dropDownAutoPromote.SetValue,
				arg1 = i,
			}
		end
	end
	self.dropDownAutoPromote.List[#self.dropDownAutoPromote.List + 1] = {
		text = ExRT.L.inviteAutoPromoteDontUseGuild,
		checkState = VExRT.InviteTool.PromoteRank == 0,
		radio = true,
		func = self.dropDownAutoPromote.SetValue,
		arg1 = 0,
	}
	self.dropDownAutoPromote.Lines = #self.dropDownAutoPromote.List	

	
	self.autoPromoteInput = ExRT.lib.CreateEditBox(self,650,20,"TOPLEFT",5,-285,ExRT.L.inviteAutoPromoteTooltip,nil,nil,"ExRTInputBoxModernTemplate",VExRT.InviteTool.PromoteNames)
	self.autoPromoteInput:SetScript("OnTextChanged",function(self)
		VExRT.InviteTool.PromoteNames = self:GetText()
		createPromoteArray()
	end) 
	
	self.butRaidDemote = ExRT.lib.CreateButton(self,430,20,nil,5,-310,ExRT.L.inviteRaidDemote,nil,nil,"ExRTButtonModernTemplate")
	self.butRaidDemote:SetScript("OnClick",function()
		demoteRaid()
	end)
	
	self.chkRaidDiff = ExRT.lib.CreateCheckBox(self,nil,5,-345,ExRT.L.InviteRaidDiffCheck,VExRT.InviteTool.AutoRaidDiff,nil,nil,"ExRTCheckButtonModernTemplate")
	self.chkRaidDiff:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.InviteTool.AutoRaidDiff = true
		else
			VExRT.InviteTool.AutoRaidDiff = nil
		end
	end)
	
	local RaidDiffsDropDown = {
		{14,PLAYER_DIFFICULTY1},
		{15,PLAYER_DIFFICULTY2},
		{16,PLAYER_DIFFICULTY6},
	}
	self.dropDownRaidDiff = ExRT.lib.CreateScrollDropDown(self,"TOPLEFT",185,-370,250,235,10,"",nil,"ExRTDropDownMenuModernTemplate")
	function self.dropDownRaidDiff:SetValue(newValue)
		VExRT.InviteTool.RaidDiff = RaidDiffsDropDown[newValue][1]
		module.options.dropDownRaidDiff:SetText( RaidDiffsDropDown[newValue][2] )
		ExRT.lib.ScrollDropDown.Close()
		for i=1,#module.options.dropDownRaidDiff.List do
			module.options.dropDownRaidDiff.List[i].checkState = VExRT.InviteTool.RaidDiff == RaidDiffsDropDown[ module.options.dropDownRaidDiff.List[i].arg1 ][1]
		end
	end
	for i=1,#RaidDiffsDropDown do
		self.dropDownRaidDiff.List[i] = {
			text = RaidDiffsDropDown[i][2],
			checkState = VExRT.InviteTool.RaidDiff == RaidDiffsDropDown[i][1],
			radio = true,
			arg1 = i,
			func = self.dropDownRaidDiff.SetValue,
		}
	end
	self.dropDownRaidDiff.Lines = #self.dropDownRaidDiff.List
	do
		local diffName = ""
		for i=1,#RaidDiffsDropDown do
			if RaidDiffsDropDown[i][1] == VExRT.InviteTool.RaidDiff then
				diffName = RaidDiffsDropDown[i][2]
				break
			end
		end
		self.dropDownRaidDiff:SetText( diffName or "" )
	end
	self.dropDownRaidDiffText = ExRT.lib.CreateText(self,150,20,nil,0,0,"LEFT","MIDDLE",nil,11,ExRT.L.InviteRaidDiff)
	ExRT.lib.SetPoint(self.dropDownRaidDiffText,"TOPLEFT",self.dropDownRaidDiff,-180,0)
	
	
	local LootMethodDropDown = {
		{"freeforall",LOOT_FREE_FOR_ALL},
		{"group",LOOT_GROUP_LOOT},
		{"master",LOOT_MASTER_LOOTER},
		{"needbeforegreed",LOOT_NEED_BEFORE_GREED},
		{"personalloot",LOOT_PERSONAL_LOOT},
		{"roundrobin",LOOT_ROUND_ROBIN},
	}
	self.dropDownLootMethod = ExRT.lib.CreateScrollDropDown(self,"TOPLEFT",185,-395,250,235,10,"",nil,"ExRTDropDownMenuModernTemplate")
	function self.dropDownLootMethod:SetValue(newValue)
		VExRT.InviteTool.LootMethod = LootMethodDropDown[newValue][1]
		module.options.dropDownLootMethod:SetText( LootMethodDropDown[newValue][2] )
		ExRT.lib.ScrollDropDown.Close()
		for i=1,#module.options.dropDownLootMethod.List do
			module.options.dropDownLootMethod.List[i].checkState = VExRT.InviteTool.LootMethod == LootMethodDropDown[ module.options.dropDownLootMethod.List[i].arg1 ][1]
		end
	end
	for i=1,#LootMethodDropDown do
		self.dropDownLootMethod.List[i] = {
			text = LootMethodDropDown[i][2],
			checkState = VExRT.InviteTool.LootMethod == LootMethodDropDown[i][1],
			radio = true,
			arg1 = i,
			func = self.dropDownLootMethod.SetValue,
		}
	end
	self.dropDownLootMethod.Lines = #self.dropDownLootMethod.List
	do
		local methodName = ""
		for i=1,#LootMethodDropDown do
			if LootMethodDropDown[i][1] == VExRT.InviteTool.LootMethod then
				methodName = LootMethodDropDown[i][2]
				break
			end
		end
		self.dropDownLootMethod:SetText( methodName or "" )
	end
	self.dropDownLootMethodText = ExRT.lib.CreateText(self,150,20,nil,0,0,"LEFT","MIDDLE",nil,11,LOOT_METHOD..":")
	ExRT.lib.SetPoint(self.dropDownLootMethodText,"TOPLEFT",self.dropDownLootMethod,-180,0)
	
	
	self.masterlotersInput = ExRT.lib.CreateEditBox(self,250,20,"TOPLEFT",185,-420,ExRT.L.InviteMasterlootersTooltip,nil,nil,"ExRTInputBoxModernTemplate",VExRT.InviteTool.MasterLooters)
	self.masterlotersInput:SetScript("OnTextChanged",function(self)
		VExRT.InviteTool.MasterLooters = self:GetText()
		createMastelootersArray()
	end) 
	self.masterlotersInputText = ExRT.lib.CreateText(self,180,20,nil,0,0,"LEFT","MIDDLE",nil,11,ExRT.L.InviteMasterlooters)
	ExRT.lib.SetPoint(self.masterlotersInputText,"TOPLEFT",self.masterlotersInput,-180,0)
	
	
	local LootThresholdDropDown = {
		{2,"|c"..select(4,GetItemQualityColor(2))..ITEM_QUALITY2_DESC},
		{3,"|c"..select(4,GetItemQualityColor(3))..ITEM_QUALITY3_DESC},
		{4,"|c"..select(4,GetItemQualityColor(4))..ITEM_QUALITY4_DESC},
	}
	self.dropDownLootThreshold = ExRT.lib.CreateScrollDropDown(self,"TOPLEFT",185,-445,250,235,10,"",nil,"ExRTDropDownMenuModernTemplate")
	function self.dropDownLootThreshold:SetValue(newValue)
		VExRT.InviteTool.LootThreshold = LootThresholdDropDown[newValue][1]
		module.options.dropDownLootThreshold:SetText( LootThresholdDropDown[newValue][2] )
		ExRT.lib.ScrollDropDown.Close()
		for i=1,#module.options.dropDownLootThreshold.List do
			module.options.dropDownLootThreshold.List[i].checkState = VExRT.InviteTool.LootThreshold == LootThresholdDropDown[ module.options.dropDownLootThreshold.List[i].arg1 ][1]
		end

	end
	for i=1,#LootThresholdDropDown do
		self.dropDownLootThreshold.List[i] = {
			text = LootThresholdDropDown[i][2],
			checkState = VExRT.InviteTool.LootThreshold == LootThresholdDropDown[i][1],
			radio = true,
			arg1 = i,
			func = self.dropDownLootThreshold.SetValue,
		}
	end
	self.dropDownLootThreshold.Lines = #self.dropDownLootThreshold.List
	do
		local diffName = ""
		for i=1,#LootThresholdDropDown do
			if LootThresholdDropDown[i][1] == VExRT.InviteTool.LootThreshold then
				diffName = LootThresholdDropDown[i][2]
				break
			end
		end
		self.dropDownLootThreshold:SetText( diffName or "" )
	end
	self.dropDownLootThresholdText = ExRT.lib.CreateText(self,150,20,nil,0,0,"LEFT","MIDDLE",nil,11,LOOT_THRESHOLD..":")
	ExRT.lib.SetPoint(self.dropDownLootThresholdText,"TOPLEFT",self.dropDownLootThreshold,-180,0)


	
	self.HelpPlate = {
		FramePos = { x = 0, y = 0 },FrameSize = { width = 660, height = 615 },
		[1] = { ButtonPos = { x = 50,	y = -42 },  	HighLightBox = { x = 0, y = -25, width = 660, height = 80 },		ToolTipDir = "RIGHT",	ToolTipText = ExRT.L.inviteHelpRaid },
		[2] = { ButtonPos = { x = 50,  y = -128 }, 	HighLightBox = { x = 0, y = -110, width = 660, height = 80 },		ToolTipDir = "RIGHT",	ToolTipText = ExRT.L.inviteHelpAutoInv },
		[3] = { ButtonPos = { x = 50,  y = -187 }, 	HighLightBox = { x = 0, y = -195, width = 660, height = 30 },		ToolTipDir = "RIGHT",	ToolTipText = ExRT.L.inviteHelpAutoAccept },
		[4] = { ButtonPos = { x = 50,  y = -255},  	HighLightBox = { x = 0, y = -230, width = 660, height = 105 },		ToolTipDir = "RIGHT",	ToolTipText = ExRT.L.inviteHelpAutoPromote },
	}
	self.HELPButton = ExRT.lib.CreateHelpButton(self,self.HelpPlate)
	self.HELPButton:SetPoint("CENTER",self,"TOPLEFT",0,15)

	self.dropDown:SetText( ExRT.L.inviterank.." " .. GuildControlGetRankName(VExRT.InviteTool.Rank) or "")
	self.dropDownAutoPromote:SetText( ExRT.L.inviterank.." " .. (VExRT.InviteTool.PromoteRank == 0 and ExRT.L.inviteAutoPromoteDontUseGuild or GuildControlGetRankName(VExRT.InviteTool.PromoteRank) or ""))
end


local promoteRosterUpdate
do
	local promotes,scheduledPromotes={},nil
	local guildmembers = nil
	
	local function GuildReview()
		guildmembers = {}
		for j=1,GetNumGuildMembers() do
			local guild_name,_,rankIndex = GetGuildRosterInfo(j)
			if guild_name then
				guildmembers[ExRT.mds.delUnitNameServer(guild_name)] = rankIndex
			end
		end		
	end
	
	function promoteRosterUpdate()
		for i = 1, GetNumGroupMembers() do
			local name, rank = GetRaidRosterInfo(i)
			if name and rank == 0 then
				local sName = ExRT.mds.delUnitNameServer(name)
				if module.db.promoteWordsArray[sName] then
					promotes[name] = true
				elseif IsInGuild() and UnitInGuild(sName) then
					if not guildmembers then
						GuildReview()
					end
					if (guildmembers[sName] or 99) < VExRT.InviteTool.PromoteRank then
						promotes[name] = true
					end
				end
			end
		end
		if not scheduledPromotes then
			scheduledPromotes = ExRT.mds.ScheduleTimer(function ()
				scheduledPromotes = nil
				for name,v in pairs(promotes) do
					if not module.db.demotedPlayers[ ExRT.mds.delUnitNameServer(name) ] then
						PromoteToAssistant(name)
					end
					promotes[name] = nil
				end
			end, 2)
		end
	end
end

function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.InviteTool = VExRT.InviteTool or {OnlyGuild=true,InvByChat=true}
	VExRT.InviteTool.Rank = VExRT.InviteTool.Rank or 1
	
	VExRT.InviteTool.Words = VExRT.InviteTool.Words or "инв inv byd штм 123"
	createInvWordsArray()
	
	VExRT.InviteTool.PromoteNames = VExRT.InviteTool.PromoteNames or ""
	VExRT.InviteTool.PromoteRank = VExRT.InviteTool.PromoteRank or 3
	createPromoteArray()
	
	VExRT.InviteTool.RaidDiff = VExRT.InviteTool.RaidDiff or 16
	VExRT.InviteTool.LootMethod = VExRT.InviteTool.LootMethod or "group"
	VExRT.InviteTool.MasterLooters = VExRT.InviteTool.MasterLooters or ""
	VExRT.InviteTool.LootThreshold = VExRT.InviteTool.LootThreshold or 2
	createMastelootersArray()
	
	module:RegisterEvents('GROUP_ROSTER_UPDATE')
	if VExRT.InviteTool.InvByChat then
		module:RegisterEvents('CHAT_MSG_WHISPER','CHAT_MSG_BN_WHISPER')
	end
	if VExRT.InviteTool.AutoInvAccept then
		module:RegisterEvents('PARTY_INVITE_REQUEST')
	end
	
	module:RegisterSlash()
	
	module.db.playerFullName = ExRT.mds.UnitCombatlogname("player")
end

function module.main:CHAT_MSG_WHISPER(msg, user)
	msg = string.lower(msg)
	if (msg and module.db.invWordsArray[msg]) and (not VExRT.InviteTool.OnlyGuild or UnitInGuild(user)) then
		if not IsInRaid() and GetNumGroupMembers() == 5 then 
			ConvertToRaid()
		end
		InviteUnit(user)
	end
end

function module.main:CHAT_MSG_BN_WHISPER(msg,sender,_,_,_,_,_,_,_,_,_,_,userID)
	msg = string.lower(msg)
	if not (msg and module.db.invWordsArray[msg]) then
		return
	end
	if not IsInRaid() and GetNumGroupMembers() == 5 then 
		ConvertToRaid()
	end
	local _,BNcount=BNGetNumFriends() 
	for i=1,BNcount do 
		local bID,_,_,_,_,bToon = BNGetFriendInfo(i)
		if bID==userID and bToon then
			local _,toonName = BNGetToonInfo(bToon)
			if (not VExRT.InviteTool.OnlyGuild or (toonName and UnitInGuild(toonName))) then
				BNInviteFriend(bToon)
			end
		end 
	end
end

local function IsRaidLeader()
	for i = 1, GetNumGroupMembers() do
		local name, rank = GetRaidRosterInfo(i)
		if name and rank == 2 and name == UnitName("player") then
			return i
		end
	end
end

local scheludedRaidUpdate = nil
local function AutoRaidSetup()
	scheludedRaidUpdate = nil

	local inRaid = IsInRaid()
	local RaidLeader = inRaid and IsRaidLeader()
	local _,zoneType = IsInInstance()
	
	if zoneType ~= "raid" then
		if inRaid and not module.db.sessionInRaid then
			module.db.sessionInRaid = true
			if RaidLeader then
				SetRaidDifficultyID(VExRT.InviteTool.RaidDiff)
				SetLootMethod(VExRT.InviteTool.LootMethod,UnitName("player"),nil)
				--SetLootThreshold(VExRT.InviteTool.LootThreshold)	--http://us.battle.net/wow/en/forum/topic/14610481537
				ExRT.mds.ScheduleTimer(SetLootThreshold, 2, VExRT.InviteTool.LootThreshold)
			end
		elseif not inRaid and module.db.sessionInRaid then
			module.db.sessionInRaid = nil
		end
	end
	
	if inRaid and RaidLeader and VExRT.InviteTool.LootMethod == "master" then
		local lootMethod,_,masterlooterRaidID = GetLootMethod()
		if lootMethod == "master" then
			local masterlooterName = UnitName("raid"..masterlooterRaidID)
			for i=1,#module.db.masterlootersArray do
				local name = module.db.masterlootersArray[i]
				local nameNow = UnitName(name)
				if nameNow then
					if masterlooterName ~= nameNow then
						SetLootMethod("master",name)
					end
					break
				end
			end
		end
	end
end

function module.main:GROUP_ROSTER_UPDATE()
	if module.db.converttoraid then
		module.db.converttoraid = false
		ConvertToRaid()
	end
	local inRaid = IsInRaid()
	if module.db.reInviteR and inRaid then
		module.db.reInviteR = nil
		ReinviteHelpFunc()
		return
	end
	if module.db.massinv and inRaid then
		module.db.massinv = false
		InviteBut()
	end
	if inRaid and UnitIsGroupLeader("player") then
		promoteRosterUpdate()
	end
	
	if VExRT.InviteTool.AutoRaidDiff then
		if not scheludedRaidUpdate then
			scheludedRaidUpdate = ExRT.mds.ScheduleTimer(AutoRaidSetup, .5)
		end
	end
end

do
	local function IsFriend(name)
		for i=1,GetNumFriends() do if(GetFriendInfo(i)==name) then return true end end
		if(IsInGuild()) then for i=1, GetNumGuildMembers() do if(ExRT.mds.delUnitNameServer(GetGuildRosterInfo(i) or "?")==name) then return true end end end
		local b,a=BNGetNumFriends() for i=1,a do local bName=select(5,BNGetFriendInfo(i)) if bName==name then return true end end
	end
	function module.main:PARTY_INVITE_REQUEST(nameinv)
		-- PhoenixStyle
		nameinv = nameinv and ExRT.mds.delUnitNameServer(nameinv)
		if nameinv and (IsFriend(nameinv)) then
			AcceptGroup()
			for i = 1, 4 do
				local frame = _G["StaticPopup"..i]
				if(frame:IsVisible() and frame.which=="PARTY_INVITE") then
					frame.inviteAccepted = 1
					StaticPopup_Hide("PARTY_INVITE")
					return
				end
			end
		end
	end
end

function module:slash(arg)
	if arg == "inv" then
		InviteBut()
	elseif arg == "dis" then
		DisbandBut()
	elseif arg == "reinv" then
		ReinviteBut()
	end
end
