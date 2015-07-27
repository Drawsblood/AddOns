local GlobalAddonName, ExRT = ...

local module = ExRT.mod:New("Coins",ExRT.L.Coins,nil,true)

local VExRT = nil

module.db.spellsCoins = {
	[188958] = ExRT.L.RaidLootT18HCBoss1,	-- T18x1
	[188959] = ExRT.L.RaidLootT18HCBoss2,	-- T18x2
	[188960] = ExRT.L.RaidLootT18HCBoss3,	-- T18x3
	[188961] = ExRT.L.RaidLootT18HCBoss4,	-- T18x4
	[188962] = ExRT.L.RaidLootT18HCBoss5,	-- T18x5
	[188963] = ExRT.L.RaidLootT18HCBoss6,	-- T18x6
	[188964] = ExRT.L.RaidLootT18HCBoss7,	-- T18x7
	[188965] = ExRT.L.RaidLootT18HCBoss8,	-- T18x8
	[188966] = ExRT.L.RaidLootT18HCBoss9,	-- T18x9
	[188967] = ExRT.L.RaidLootT18HCBoss10,	-- T18x10
	[188968] = ExRT.L.RaidLootT18HCBoss11,	-- T18x11
	[188969] = ExRT.L.RaidLootT18HCBoss12,	-- T18x12
	[188970] = ExRT.L.RaidLootT18HCBoss13,	-- T18x13

	[177510] = ExRT.L.RaidLootBFBoss1,	-- T17x2x1
	[177511] = ExRT.L.RaidLootBFBoss2,	-- T17x2x2
	[177517] = ExRT.L.RaidLootBFBoss3,	-- T17x2x3
	[177515] = ExRT.L.RaidLootBFBoss4,	-- T17x2x4
	[177513] = ExRT.L.RaidLootBFBoss5,	-- T17x2x5
	[177518] = ExRT.L.RaidLootBFBoss6,	-- T17x2x6
	[177512] = ExRT.L.RaidLootBFBoss7,	-- T17x2x7
	[177516] = ExRT.L.RaidLootBFBoss8,	-- T17x2x8
	[177519] = ExRT.L.RaidLootBFBoss9,	-- T17x2x9
	[177520] = ExRT.L.RaidLootBFBoss10,	-- T17x2x10

	[177503] = ExRT.L.RaidLootHighmaulBoss1,-- T17x1x1
	[177504] = ExRT.L.RaidLootHighmaulBoss2,-- T17x1x2
	[177505] = ExRT.L.RaidLootHighmaulBoss3,-- T17x1x3
	[177506] = ExRT.L.RaidLootHighmaulBoss4,-- T17x1x4
	[177507] = ExRT.L.RaidLootHighmaulBoss5,-- T17x1x5
	[177508] = ExRT.L.RaidLootHighmaulBoss6,-- T17x1x6
	[177509] = ExRT.L.RaidLootHighmaulBoss7,-- T17x1x7

	[163435] = ExRT.L.sooitemssooboss1,	-- T16x1
	[163533] = ExRT.L.sooitemssooboss2,	-- T16x2
	[165021] = ExRT.L.sooitemssooboss3,	-- T16x3
	[165037] = ExRT.L.sooitemssooboss4,	-- T16x4
	[165038] = ExRT.L.sooitemssooboss5,	-- T16x5
	[165041] = ExRT.L.sooitemssooboss6,	-- T16x6
	[165043] = ExRT.L.sooitemssooboss7,	-- T16x7
	[165044] = ExRT.L.sooitemssooboss8,	-- T16x8
	[165045] = ExRT.L.sooitemssooboss9,	-- T16x9
	[165048] = ExRT.L.sooitemssooboss12,	-- T16x10
	[165046] = ExRT.L.sooitemssooboss10,	-- T16x11
	[165047] = ExRT.L.sooitemssooboss11,	-- T16x12
	[165049] = ExRT.L.sooitemssooboss13,	-- T16x13
	[165050] = ExRT.L.sooitemssooboss14,	-- T16x14

	[145923] = ExRT.L.sooitemssooboss1,	-- T16x1
	[145924] = ExRT.L.sooitemssooboss2,	-- T16x2
	[145925] = ExRT.L.sooitemssooboss3,	-- T16x3
	[145926] = ExRT.L.sooitemssooboss4,	-- T16x4
	[145927] = ExRT.L.sooitemssooboss5,	-- T16x5
	[145928] = ExRT.L.sooitemssooboss6,	-- T16x6
	[145929] = ExRT.L.sooitemssooboss7,	-- T16x7
	[145930] = ExRT.L.sooitemssooboss8,	-- T16x8
	[145931] = ExRT.L.sooitemssooboss9,	-- T16x9
	[145932] = ExRT.L.sooitemssooboss12,	-- T16x10
	[145933] = ExRT.L.sooitemssooboss10,	-- T16x11
	[145934] = ExRT.L.sooitemssooboss11,	-- T16x12
	[145935] = ExRT.L.sooitemssooboss13,	-- T16x13
	[145936] = ExRT.L.sooitemssooboss14,	-- T16x14

	[139673] = ExRT.L.sooitemstotboss1,	-- T15x1
	[139659] = ExRT.L.sooitemstotboss2,	-- T15x2
	[139661] = ExRT.L.sooitemstotboss3,	-- T15x3
	[139662] = ExRT.L.sooitemstotboss4,	-- T15x4
	[139663] = ExRT.L.sooitemstotboss5,	-- T15x5
	[139664] = ExRT.L.sooitemstotboss6,	-- T15x6
	[139665] = ExRT.L.sooitemstotboss7,	-- T15x7
	[139666] = ExRT.L.sooitemstotboss8,	-- T15x8
	[139667] = ExRT.L.sooitemstotboss9,	-- T15x9
	[139669] = ExRT.L.sooitemstotboss10,	-- T15x10
	[139670] = ExRT.L.sooitemstotboss11,	-- T15x11
	[139671] = ExRT.L.sooitemstotboss12,	-- T15x12
	[139668] = ExRT.L.sooitemstotboss13,	-- T15x13

	[125145] = true,	-- T14x1x1
	[132171] = true,	-- T14x1x2
	[132172] = true,	-- T14x1x3
	[132173] = true,	-- T14x1x4
	[132174] = true,	-- T14x1x5
	[132175] = true,	-- T14x1x6

	[132176] = true,	-- T14x2x1
	[132177] = true,	-- T14x2x2
	[132178] = true,	-- T14x2x3
	[132179] = true,	-- T14x2x4
	[132180] = true,	-- T14x2x5
	[132181] = true,	-- T14x2x6

	[132182] = true,	-- T14x3x1x1
	[132186] = true,	-- T14x3x1x2
	[132183] = true,	-- T14x3x2
	[132184] = true,	-- T14x3x3
	[132185] = true,	-- T14x3x4
}
module.db.endCoinTimer = nil
module.db.bonusLootChat = nil
module.db.bonusLootChatSelf = nil
module.db.classNames = {"WARRIOR","PALADIN","HUNTER","ROGUE","PRIEST","DEATHKNIGHT","SHAMAN","MAGE","WARLOCK","MONK","DRUID"}

local function deformat(str)
	str = str:gsub("%.","%%.")
	str = str:gsub("%%s","(.+)")
	
	return str
end

function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.Coins = VExRT.Coins or {}
	VExRT.Coins.list = VExRT.Coins.list or {}
	
	module:RegisterEvents('ENCOUNTER_END','ENCOUNTER_START')
	
	module.db.bonusLootChat = deformat(LOOT_ITEM_BONUS_ROLL)
	module.db.bonusLootChatSelf = deformat(LOOT_ITEM_BONUS_ROLL_SELF)
end

do
	local function CoinsTimerEnd()
		module.db.endCoinTimer = nil
		module:UnregisterEvents('UNIT_SPELLCAST_SUCCEEDED','CHAT_MSG_LOOT')
	end
	function module.main:ENCOUNTER_END(encounterID,encounterName,difficultyID,groupSize,success)
		if success == 1 then
			module:RegisterEvents('CHAT_MSG_LOOT','UNIT_SPELLCAST_SUCCEEDED')
			module.db.endCoinTimer = ExRT.mds.ScheduleETimer(module.db.endCoinTimer, CoinsTimerEnd, 180)
		end
		if encounterID == 1594 then
			module:UnregisterEvents('CHAT_MSG_MONSTER_YELL')
		end	
	end
end

function module.main:CHAT_MSG_LOOT(msg, ...)
	if msg:find(module.db.bonusLootChatSelf) then
		local unitName = UnitName("player")
		local itemID = msg:match("|Hitem:(%d+)")
		local class = select(3,UnitClass("player"))
		local affixes = ""
		local affixesFind = msg:match("item:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+(:[^|]+)|")
		if ExRT.is61 then
			affixesFind = msg:match("item:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+(:[^|]+)|")
		end
		if affixesFind then
			affixes = affixesFind
		end
		if itemID then
			VExRT.Coins.list[#VExRT.Coins.list + 1] = "!"..ExRT.mds.tohex(class or 0,1)..itemID..unitName..time()..affixes
		end	
	elseif msg:find(module.db.bonusLootChat) then
		local unitName = msg:match(module.db.bonusLootChat)
		local itemID = msg:match("|Hitem:(%d+)")
		local class
		if unitName and itemID then
			if UnitName(unitName) then
				class = select(3,UnitClass(unitName))
			end
			local affixes = ""
			local affixesFind = msg:match("item:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+(:[^|]+)|")
			if ExRT.is61 then
				affixesFind = msg:match("item:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+(:[^|]+)|")
			end
			if affixesFind then
				affixes = affixesFind
			end
			VExRT.Coins.list[#VExRT.Coins.list + 1] = "!"..ExRT.mds.tohex(class or 0,1)..itemID..unitName..time()..affixes
		end
	end	
end

function module.main:ENCOUNTER_START(encounterID,encounterName,difficultyID,groupSize)
	if encounterID == 1594 then
		module:RegisterEvents('CHAT_MSG_MONSTER_YELL')
	end
end

function module.main:CHAT_MSG_MONSTER_YELL(msg, ...)
	if msg:find(ExRT.L.CoinsSpoilsOfPandariaWinTrigger) then
		module.main:ENCOUNTER_END(1594,nil,nil,nil,1)
	end	
end

do
	local module_db_spellsCoins = module.db.spellsCoins
	function module.main:UNIT_SPELLCAST_SUCCEEDED(unitID,_,_,_,spellID)
		if module_db_spellsCoins[spellID] and unitID:find("^raid%d+$") then
			local name = ExRT.mds.UnitCombatlogname(unitID)
			if name then
				local class = select(3,UnitClass(unitID))
				VExRT.Coins.list[#VExRT.Coins.list + 1] = ExRT.mds.tohex(class or 0,1)..spellID..name..time()
			end
		end
	end
end

function module.options:Load()
	local historyBoxUpdate = nil
	
	self:CreateTilte()
	
	self.shtml1 = ExRT.lib.CreateText(self,550,200,nil,5,-30,nil,"TOP",nil,11,ExRT.L.CoinsHelp)
	
	self.clearButton = ExRT.lib.CreateButton(self,100,20,"TOPRIGHT",-5,-30,ExRT.L.MarksClear,nil,ExRT.L.CoinsClear,"ExRTButtonModernTemplate")
	self.clearButton:SetScript("OnClick", function() 
		StaticPopupDialogs["EXRT_COINS_CLEAR"] = {
			text = ExRT.L.CoinsClearPopUp,
			button1 = ExRT.L.YesText,
			button2 = ExRT.L.NoText,
			OnAccept = function()
				table.wipe(VExRT.Coins.list)
				if module.options.ScrollBar:GetValue() == 1 then
					historyBoxUpdate(1)
				else
					module.options.ScrollBar:SetValue(1)
				end
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("EXRT_COINS_CLEAR")
	end) 
	
	local function OptionsScheduledItemInfoEventCancel()
		module.options.GET_ITEM_INFO_RECEIVED_cancel = nil
		module.options:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
	end

	local historyBoxUpdateTable = {}
	function historyBoxUpdate(val,isSecond)
		ExRT.mds.table_wipe(historyBoxUpdateTable)
		module.options:RegisterEvent("GET_ITEM_INFO_RECEIVED")
		module.options.GET_ITEM_INFO_RECEIVED_cancel = ExRT.mds.ScheduleETimer(module.options.GET_ITEM_INFO_RECEIVED_cancel, OptionsScheduledItemInfoEventCancel, 5)
		for i=(#VExRT.Coins.list-val+1),1,-1 do
			local unitClass,spellID,unitName,timestamp = string.match(VExRT.Coins.list[i],"^([^!])(%d+)([^0-9]+)(%d+)")
			if spellID and unitClass and unitName and timestamp then
				local spellName = module.db.spellsCoins[tonumber(spellID) or 0]
				if type(spellName) ~= "string" then
					spellName = GetSpellInfo(spellID)
				end
				local classColor = ExRT.mds.classColor( module.db.classNames[ tonumber(unitClass,16) ] or "?")
				historyBoxUpdateTable [#historyBoxUpdateTable + 1] = date("%d/%m/%y %H:%M:%S ",timestamp).."|c"..classColor..unitName.."|r: "..(spellName or "???")
			else
				local unitClass,itemID,unitName,timestamp,affixes = string.match(VExRT.Coins.list[i],"^!(.)(%d+)([^0-9]+)(%d+)(:?.*)")
				if itemID and unitClass and unitName and timestamp then
					itemID = tonumber(itemID)
					local itemName,_,itemQuality,_,itemReqLevel,_,_,_,_,itemTexture = GetItemInfo(itemID)
					local itemColor = select(4,GetItemQualityColor(itemQuality or 4))
					local link = format("|c%s|Hitem:%d:0:0:0:0:0:0:0:%d:%d:0:%d%s|h[%s]|h|r",itemColor,itemID,itemReqLevel or UnitLevel("player"),0,0,affixes or ":0",itemName or "ItemID: "..itemID)
					if ExRT.is61 then
						link = format("|c%s|Hitem:%d:0:0:0:0:0:0:0:%d:%d:%d%s|h[%s]|h|r",itemColor,itemID,itemReqLevel or UnitLevel("player"),0,0,affixes or ":0",itemName or "ItemID: "..itemID)
					end
					local classColor = ExRT.mds.classColor( module.db.classNames[ tonumber(unitClass,16) ] or "?")
					historyBoxUpdateTable [#historyBoxUpdateTable + 1] = date("%d/%m/%y %H:%M:%S ",timestamp).."|c"..classColor..unitName.."|r: "..link
				end
			end
			if #historyBoxUpdateTable >= 45 then
				break
			end
		end
		for i=1,#historyBoxUpdateTable do
			module.options.Lines[i]:SetText(historyBoxUpdateTable[i] or "")
		end
		for i=#historyBoxUpdateTable+1,45 do
			module.options.Lines[i]:SetText("")
		end
		if #historyBoxUpdateTable == 0 then
			module.options.Lines[1]:SetText(ExRT.L.CoinsEmpty)
			for i=2,45 do
				module.options.Lines[i]:SetText("")
			end
		end
		
		if not isSecond then
			historyBoxUpdate(val,true)
		end
	end
	
	local function OptionsScheduledItemInfoEventUpdate()
		self.GET_ITEM_INFO_RECEIVED = nil
		historyBoxUpdate( ExRT.mds.Round( module.options.ScrollBar:GetValue() ) ) 
	end
	self:SetScript("OnEvent",function ()
		if not self.GET_ITEM_INFO_RECEIVED then
			self.GET_ITEM_INFO_RECEIVED = ExRT.mds.ScheduleTimer(OptionsScheduledItemInfoEventUpdate, 0.1)
		end
	end)
	
	local function historyBoxShow(self)
		module.options.ScrollBar:SetMinMaxValues(1,max(#VExRT.Coins.list - 44 + 1,1))
		if module.options.ScrollBar:GetValue() == 1 then
			historyBoxUpdate(1)
		else
			module.options.ScrollBar:SetValue(1)
		end
		module.options.ScrollBar:ReButtonsState()
	end
	
	self.borderList = CreateFrame("Frame",nil,self)
	self.borderList:SetSize(655,548)
	self.borderList:SetPoint("TOP", 0, -60)
	self.borderList:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.mds.defBorder,tile = false,edgeSize = 8})
	self.borderList:SetBackdropColor(0,0,0,0.3)
	self.borderList:SetBackdropBorderColor(.24,.25,.30,1)
	
	self.ScrollBar = ExRT.lib.CreateScrollBarModern(self.borderList,16,self.borderList:GetHeight()-9,-4,-4,1,1,"TOPRIGHT")
	self.ScrollBar:SetScript("OnValueChanged",function (self,val)
		val = ExRT.mds.Round(val)
		self:ReButtonsState()
		historyBoxUpdate(val)
	end)
	self.ScrollBar:SetScript("OnShow",historyBoxShow)
	
	self:SetScript("OnMouseWheel",function (self,delta)
		local min,max = self.ScrollBar:GetMinMaxValues()
		local val = self.ScrollBar:GetValue()
		if (val - delta) < min then
			self.ScrollBar:SetValue(min)
		elseif (val - delta) > max then
			self.ScrollBar:SetValue(max)
		else
			self.ScrollBar:SetValue(val - delta)
		end
	end)
	
	self.Lines = {}
	for i=1,45 do
		self.Lines[i] = CreateFrame("SimpleHTML",nil,self.borderList)
		self.Lines[i]:SetPoint("TOPLEFT",4,-(i-1)*12-4)
		self.Lines[i]:SetSize(535,14)
		self.Lines[i]:SetFont(ExRT.mds.defFont,12)
		self.Lines[i]:SetText("")
		self.Lines[i]:SetHyperlinksEnabled(true)
		self.Lines[i]:SetScript("OnHyperlinkEnter",ExRT.lib.EditBoxOnEnterHyperLinkTooltip)
		self.Lines[i]:SetScript("OnHyperlinkLeave",ExRT.lib.EditBoxOnLeaveHyperLinkTooltip)
		self.Lines[i]:SetScript("OnHyperlinkClick",ExRT.lib.EditBoxOnClickHyperLinkTooltip)
	end
	
	historyBoxShow()
end