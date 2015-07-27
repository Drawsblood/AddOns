local GlobalAddonName, ExRT = ...

local VExRT = nil

local parentModule = ExRT.A.Inspect
if not parentModule then
	return
end
local module = ExRT.mod:New("InspectViewer",ExRT.L.InspectViewer,nil,true)
module.db.inspectDB = parentModule.db.inspectDB
module.db.inspectQuery = parentModule.db.inspectQuery
module.db.specIcons = ExRT.A.ExCD2 and ExRT.A.ExCD2.db.specIcons
module.db.itemsSlotTable = parentModule.db.itemsSlotTable
module.db.classIDs = {WARRIOR=1,PALADIN=2,HUNTER=3,ROGUE=4,PRIEST=5,DEATHKNIGHT=6,SHAMAN=7,MAGE=8,WARLOCK=9,MONK=10,DRUID=11}
module.db.glyphsIDs = {9,11,13,10,8,12}

module.db.statsList = {'intellect','agility','strength','spirit','haste','mastery','crit','spellpower','multistrike','versatility','armor','leech','avoidance','speed'}
module.db.statsListName = {ExRT.L.InspectViewerInt,ExRT.L.InspectViewerAgi,ExRT.L.InspectViewerStr,ExRT.L.InspectViewerSpirit,ExRT.L.InspectViewerHaste,ExRT.L.InspectViewerMastery,ExRT.L.InspectViewerCrit,ExRT.L.InspectViewerSpd, ExRT.L.InspectViewerMS, ExRT.L.InspectViewerVer, ExRT.L.InspectViewerBonusArmor, ExRT.L.InspectViewerLeech, ExRT.L.InspectViewerAvoidance, ExRT.L.InspectViewerSpeed}

module.db.baseStats = { --By class IDs
	agility = {889,455,1284,1284,1067,1071,1284,889,985,1284,1284},
	strength = {1455,1455,886,1206,843,1455,626,647,551,626,626},
	spirit = {679,782,711,533,782,640,782,1155,1155,782,782},
	intellect = {711,1042,854,711,1042,569,1042,1042,1042,1042,1042},
}
module.db.raceList = {'Human','Dwarf','Night Elf','Orc','Tauren','Undead','Gnome','Troll','Blood Elf','Draenei','Goblin','Worgen','Pandaren'}
module.db.raceStatsDiffs = {
	agility={0,-4,4,-3,-4,-2,2,2,2,-3,2,2,-2},
	strength={0,5,-4,3,5,-1,-5,1,-3,1,-3,3,0},
	intellect={0,-1,0,-3,-4,-2,3,-4,3,0,3,-4,-1},
	spirit={0,-1,0,2,2,5,0,1,-2,2,-2,-1,2},
}

module.db.statsMultiplayBySpec = {
	[62] = 'mastery',
	[63] = 'crit',
	[64] = 'multistrike',
	[65] = 'crit',
	[66] = 'haste',
	[70] = 'mastery',
	[71] = 'mastery',
	[72] = 'crit',
	[73] = 'mastery',
	[102] = 'mastery',
	[103] = 'crit',
	[104] = 'mastery',
	[105] = 'haste',
	[250] = 'multistrike',
	[251] = 'haste',
	[252] = 'multistrike',
	[253] = 'mastery',
	[254] = 'crit',
	[255] = 'multistrike',
	[256] = 'crit',
	[257] = 'multistrike',
	[258] = 'haste',
	[259] = 'mastery',
	[260] = 'haste',
	[261] = 'multistrike',
	[262] = 'multistrike',
	[263] = 'haste',
	[264] = 'mastery',
	[265] = 'haste',
	[266] = 'mastery',
	[267] = 'crit',
	[268] = 'crit',
	[269] = 'multistrike',
	[270] = 'multistrike',
}

module.db.armorType = {
	WARRIOR="PLATE",PALADIN="PLATE",HUNTER="MAIL",ROGUE="LEATHER",PRIEST="CLOTH",DEATHKNIGHT="PLATE",SHAMAN="MAIL",MAGE="CLOTH",WARLOCK="CLOTH",MONK="LEATHER",DRUID="LEATHER"
}

module.db.roleBySpec = {
	[62] = 'RANGE',
	[63] = 'RANGE',
	[64] = 'RANGE',
	[65] = 'HEAL',
	[66] = 'TANK',
	[70] = 'MELEE',
	[71] = 'MELEE',
	[72] = 'MELEE',
	[73] = 'TANK',
	[102] = 'RANGE',
	[103] = 'MELEE',
	[104] = 'TANK',
	[105] = 'HEAL',
	[250] = 'TANK',
	[251] = 'MELEE',
	[252] = 'MELEE',
	[253] = 'RANGE',
	[254] = 'RANGE',
	[255] = 'RANGE',
	[256] = 'HEAL',
	[257] = 'HEAL',
	[258] = 'RANGE',
	[259] = 'MELEE',
	[260] = 'MELEE',
	[261] = 'MELEE',
	[262] = 'RANGE',
	[263] = 'MELEE',
	[264] = 'HEAL',
	[265] = 'RANGE',
	[266] = 'RANGE',
	[267] = 'RANGE',
	[268] = 'TANK',
	[269] = 'MELEE',
	[270] = 'HEAL',
}

module.db.specHasOffhand = {
	[71]=true,
	[72]=true,
	[251]=true,
	[252]=true,
	[259]=true,
	[260]=true,
	[261]=true,
	[263]=true,
	[268]=true,
	[269]=true,
}

module.db.socketsBonusIDs = {
	[563]=true,
	[564]=true,
	[565]=true,
	[572]=true,
}

module.db.topEnchGems = {
	[5306]="Ring:Vers",
	[5324]="Ring:Crit",
	[5325]="Ring:Haste",
	[5326]="Ring:Mastery",
	[5327]="Ring:MS",
	[5328]="Ring:Vers",
	
	[5310]="Cloak:Crit",
	[5311]="Cloak:Haste",
	[5312]="Cloak:Mastery",
	[5313]="Cloak:MS",
	[5314]="Cloak:Vers",
	
	[5317]="Neck:Crit",
	[5318]="Neck:Haste",
	[5319]="Neck:Mastery",
	[5320]="Neck:MS",
	[5321]="Neck:Vers",

	[5330]="Weapon:Crit",
	[5334]="Weapon:MS",
	[5335]="Weapon:Spirit",
	[5336]="Weapon:Armor",
	[5337]="Weapon:Haste",
	[5384]="Weapon:Mastery",
	[5383]="Gun:Mastery",
	[5276]="Gun:Crit",
	[5275]="Gun:MS",
	[3366]="Weapon:DK",
	[3367]="Weapon:DK",
	[3368]="Weapon:DK",
	[3370]="Weapon:DK",

	--[5346]="Gem:Crit",
	--[5347]="Gem:Haste",
	--[5348]="Gem:Mastery",
	--[5349]="Gem:MS",
	--[5350]="Gem:Vers",
	--[5351]="Gem:Stamina",
	
	[5413]="Gem:Crit",
	[5414]="Gem:Haste",
	[5415]="Gem:Mastery",
	[5416]="Gem:MS",
	[5417]="Gem:Vers",
	[5418]="Gem:Stamina",
}

module.db.perPage = 18
module.db.page = 1

module.db.filter = nil
module.db.filterType = nil

module.db.colorizeNoEnch = true
module.db.colorizeLowIlvl = true
module.db.colorizeNoGems = true
module.db.colorizeNoTopEnchGems = false
module.db.colorizeLowIlvl685 = false

function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.InspectViewer = VExRT.InspectViewer or {}
	--if VExRT.InspectViewer.enabled and (not VExRT.ExCD2 or not VExRT.ExCD2.enabled) then module:Enable() end
	
	module:RegisterSlash()
end

function module.main:INSPECT_READY()
	module.options.UpdatePage_InspectEvent()
end

function module:Enable()
	parentModule:RegisterTimer()
	parentModule:RegisterEvents('GROUP_ROSTER_UPDATE','INSPECT_READY','UNIT_INVENTORY_CHANGED','PLAYER_EQUIPMENT_CHANGED')
	parentModule.main:GROUP_ROSTER_UPDATE()
end

function module:Disable()
	if not VExRT or not VExRT.ExCD2 or not VExRT.ExCD2.enabled then
		parentModule:UnregisterTimer()
		parentModule:UnregisterEvents('GROUP_ROSTER_UPDATE','INSPECT_READY','UNIT_INVENTORY_CHANGED','PLAYER_EQUIPMENT_CHANGED')
	end
end

function module.options:Load()
	self:CreateTilte()

	--[[
	self.chkEnable = ExRT.lib.CreateCheckBox(self,nil,634,-25,ExRT.L.senable,nil,nil,true,"ExRTCheckButtonModernTemplate")
	self.chkEnable:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			module:Enable()
			VExRT.InspectViewer.enabled = true
		else
			module:Disable()
			VExRT.InspectViewer.enabled = nil
		end
	end)
	
	self.chkEnable:SetScript("OnUpdate", function (self)
		local x, y = GetCursorPosition()
		local s = self:GetEffectiveScale()
		x, y = x/s, y/s
		local t,l,b,r = self:GetTop(),self:GetLeft(),self:GetBottom(),self:GetRight()
		if x >= l and x <= r and y <= t and y >= b then
			self.tooltip = true
			ExRT.lib.TooltipShow(self,"ANCHOR_RIGHT",ExRT.L.InspectViewerEnabledTooltip)
		elseif self.tooltip then
			self.tooltip = nil
			GameTooltip_Hide()
		end
	end)
	
	local function chkEnableShow(self)
		if VExRT and VExRT.ExCD2 and VExRT.ExCD2.enabled then
			self:SetChecked(true)
			self:SetEnabled(false)
		else
			self:SetChecked(VExRT.InspectViewer.enabled)
			self:SetEnabled(true)
		end
	end
	self.chkEnable:SetScript("OnShow",chkEnableShow)
	chkEnableShow(self.chkEnable)
	]]
	
	local function reloadChks(self)
		local clickID = self.id
		self:SetChecked(true)
		if clickID == 1 then
			module.options.chkTalents:SetChecked(false)
			module.options.chkInfo:SetChecked(false)
		elseif clickID == 2 then
			module.options.chkItems:SetChecked(false)
			module.options.chkInfo:SetChecked(false)	
		elseif clickID == 3 then
			module.options.chkItems:SetChecked(false)
			module.options.chkTalents:SetChecked(false)	
		end
		module.db.page = clickID
		module.options.showPage()
	end
	
	self.chkItems = ExRT.lib.CreateRadioButton(self,"TOPLEFT", 10, -28,ExRT.L.InspectViewerItems,true,true)
	self.chkItems:SetScript("OnClick", reloadChks)
	self.chkItems.id = 1
	
	self.chkTalents = ExRT.lib.CreateRadioButton(self,"TOPLEFT", 135, -28,ExRT.L.InspectViewerTalents,nil,true)
	self.chkTalents:SetScript("OnClick", reloadChks)
	self.chkTalents.id = 2

	self.chkInfo = ExRT.lib.CreateRadioButton(self,"TOPLEFT", 260, -28,ExRT.L.InspectViewerInfo,nil,true)
	self.chkInfo:SetScript("OnClick", reloadChks)
	self.chkInfo.id = 3
	
	local function ItemsTrackDropDownClick(self)
		local f = self.checkButton:GetScript("OnClick")
		self.checkButton:SetChecked(not self.checkButton:GetChecked())
		f(self.checkButton)
	end
	
	self.chkItemsTrackDropDown = ExRT.lib.CreateScrollDropDown(self,"TOPLEFT",50,0,50,300,6,nil,nil,"ExRTDropDownMenuModernTemplate")
	--self.chkItemsTrackDropDown:SetAlpha(0)
	self.chkItemsTrackDropDown:Hide()
	self.chkItemsTrackDropDown.List = {
		{text = ExRT.L.InspectViewerColorizeNoEnch,checkable = true,checkState = module.db.colorizeNoEnch, checkFunc = function(self,checked) 
			module.db.colorizeNoEnch = checked
			module.options.ReloadPage()
		end,func = ItemsTrackDropDownClick},
		{text = ExRT.L.InspectViewerColorizeNoGems,checkable = true,checkState = true, checkFunc = function(self,checked) 
			module.db.colorizeNoGems = checked
			module.options.ReloadPage()
		end,func = ItemsTrackDropDownClick},
		{text = format(ExRT.L.InspectViewerColorizeLowIlvl,630),checkable = true,checkState = true, checkFunc = function(self,checked) 
			module.db.colorizeLowIlvl = checked
			module.options.ReloadPage()
		end,func = ItemsTrackDropDownClick},
		{text = ExRT.L.InspectViewerColorizeNoTopEnch,checkable = true,checkState = false, checkFunc = function(self,checked) 
			module.db.colorizeNoTopEnchGems = checked
			module.options.ReloadPage()
		end,func = ItemsTrackDropDownClick},
		{text = format(ExRT.L.InspectViewerColorizeLowIlvl,685),checkable = true,checkState = false, checkFunc = function(self,checked) 
			module.db.colorizeLowIlvl685 = checked
			module.options.ReloadPage()
		end,func = ItemsTrackDropDownClick},
		{text = ExRT.L.minimapmenuclose,checkable = false, padding = 16, func = function()
			ExRT.lib.ScrollDropDown.Close()
		end},
	}
	
	self.chkItemsTrack = CreateFrame("Frame",nil,self,"ExRTTrackingButtonModernTemplate")  
	self.chkItemsTrack:SetPoint("TOPLEFT", 130, -28)
	self.chkItemsTrack:SetScale(.8)
	self.chkItemsTrack.Button:SetScript("OnClick",function (this)
		if ExRT.lib.ScrollDropDown.DropDownList[1]:IsShown() then
			ExRT.lib.ScrollDropDown.Close()
		else
			ExRT.lib.ScrollDropDown.ToggleDropDownMenu(module.options.chkItemsTrackDropDown)
		end
	end)
	self.chkItemsTrackDropDown:ClearAllPoints()
	self.chkItemsTrackDropDown:SetPoint("CENTER",self.chkItemsTrack,0,0)
	self.chkItemsTrackDropDown.toggleX = -32
	
	self:SetScript("OnHide",function() ExRT.lib.ScrollDropDown.Close() end)
	
	local dropDownTable = {
		[1] = {
			{"WARRIOR","PALADIN","HUNTER","ROGUE","PRIEST","DEATHKNIGHT","SHAMAN","MAGE","WARLOCK","MONK","DRUID"},
		},
		[2] = {
			{"CLOTH","LEATHER","MAIL","PLATE"},
			{ExRT.L.InspectViewerTypeCloth,ExRT.L.InspectViewerTypeLeather,ExRT.L.InspectViewerTypeMail,ExRT.L.InspectViewerTypePlate},
		},
		[3] = {
			{"TANK","HEAL","MELEE-RANGE","MELEE","RANGE"},
			{TANK,HEALER,DAMAGER,MELEE,RANGED},
		},
	}
	
	self.filterDropDown = ExRT.lib.CreateScrollDropDown(self,"TOPLEFT",405,-25,150,150,4,ExRT.L.InspectViewerFilter,nil,"ExRTDropDownMenuModernTemplate")
	
	self.filterDropDown.List = {
		{text = ExRT.L.InspectViewerClass, subMenu = {}},
		{text = ExRT.L.InspectViewerType, subMenu = {}},
		{text = ROLE, subMenu = {}},
		{text = ExRT.L.InspectViewerClear,func = function (self)
			module.db.filter = nil
			module.db.filterType = nil
			module.options.ScrollBar:SetValue(1)
			module.options.ReloadPage()
			ExRT.lib.ScrollDropDown.Close()
			module.options.filterDropDown:SetText(ExRT.L.InspectViewerFilter)
		end},
	}
	for i=1,#dropDownTable[1][1] do
		self.filterDropDown.List[1].subMenu[i] = {text = ExRT.L.classLocalizate[ dropDownTable[1][1][i] ],func = function (self,arg1)
			module.db.filter = arg1
			module.db.filterType = 1
			module.options.ScrollBar:SetValue(1)
			module.options.ReloadPage()
			ExRT.lib.ScrollDropDown.Close()
			module.options.filterDropDown:SetText(ExRT.L.InspectViewerFilterShort.. ExRT.L.classLocalizate[ arg1 ] )
		end, arg1 = dropDownTable[1][1][i]}
	end
	for i=1,#dropDownTable[2][1] do
		self.filterDropDown.List[2].subMenu[i] = {text = dropDownTable[2][2][i],func = function (self,arg1,arg2)
			module.db.filter = arg1
			module.db.filterType = 2
			module.options.ScrollBar:SetValue(1)
			module.options.ReloadPage()
			ExRT.lib.ScrollDropDown.Close()
			module.options.filterDropDown:SetText(ExRT.L.InspectViewerFilterShort.. arg2 )
		end, arg1 = dropDownTable[2][1][i], arg2 = dropDownTable[2][2][i]}
	end
	for i=1,#dropDownTable[3][1] do
		self.filterDropDown.List[3].subMenu[i] = {text = dropDownTable[3][2][i],func = function (self,arg1,arg2)
			module.db.filter = arg1
			module.db.filterType = 3
			module.options.ScrollBar:SetValue(1)
			module.options.ReloadPage()
			ExRT.lib.ScrollDropDown.Close()
			module.options.filterDropDown:SetText(ExRT.L.InspectViewerFilterShort.. arg2 )
		end, arg1 = dropDownTable[3][1][i], arg2 = dropDownTable[3][2][i]}
	end
		
	self.borderList = CreateFrame("Frame",nil,self)
	self.borderList:SetSize(650,module.db.perPage*30+2)
	self.borderList:SetPoint("TOP", 0, -50)
	self.borderList:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.mds.defBorder,tile = false,edgeSize = 8})
	self.borderList:SetBackdropColor(0,0,0,0.3)
	self.borderList:SetBackdropBorderColor(.24,.25,.30,1)
	
	self.borderList:SetScript("OnMouseWheel",function (self,delta)
		if delta > 0 then
			module.options.ScrollBar.buttonUP:Click("LeftButton")
		else
			module.options.ScrollBar.buttonDown:Click("LeftButton")
		end
	end)
	
	self.ScrollBar = ExRT.lib.CreateScrollBarModern(self.borderList,16,module.db.perPage*30-7,-4,-4,1,20,"TOPRIGHT")
	self.ScrollBar:SetScript("OnUpdate",self.ScrollBar.ReButtonsState)
	
	local function IsItemHasNotGem(link)
		if link then
			local gem = link:match("item:%d+:%d+:(%d+):")
			if gem == "0" then
				return true
			end
		end
	end
	
	local function IsTopEnchAndGems(link)
		if link then
			local ench,gem = link:match("item:%d+:(%d+):(%d+):")
			if ench and gem then
				local isTop = true
				if ench ~= "0" then
					ench = tonumber(ench)
					if not module.db.topEnchGems[ench] then
						isTop = false
					end
				end
				if gem ~= "0" then
					gem = tonumber(gem)
					if not module.db.topEnchGems[gem] then
						isTop = false
					end
				end
				return isTop
			end
		end
	end

	function module.options.ReloadPage()
		local nowDB = {}
		for name,data in pairs(module.db.inspectDB) do
			table.insert(nowDB,{name,data})
		end
		for name,_ in pairs(module.db.inspectQuery) do
			if not module.db.inspectDB[name] then
				table.insert(nowDB,{name})
			end
		end
		table.sort(nowDB,function(a,b) return a[1] < b[1] end)

		local scrollNow = ExRT.mds.Round(module.options.ScrollBar:GetValue())
		local counter = 0
		for i=scrollNow,#nowDB do
			local data = nowDB[i][2]
			if not module.db.filter or (data and (
			  (module.db.filterType == 1 and module.db.filter == data.class) or 
			  (module.db.filterType == 2 and module.db.filter == module.db.armorType[ data.class or "?" ]) or 
			  (module.db.filterType == 3 and module.db.roleBySpec[ data.spec or 0 ] and module.db.filter:find( module.db.roleBySpec[ data.spec or 0 ] ))
			)) then
				counter = counter + 1
				
				local name = nowDB[i][1]
				local line = module.options.lines[counter]
				line.name:SetText(name)
				line.unit = name
				if data then
					local class = data.class
					local classIconCoords = CLASS_ICON_TCOORDS[class]
					if classIconCoords then
						line.class.texture:SetTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES")
						line.class.texture:SetTexCoord(unpack(classIconCoords))
					else
						line.class.texture:SetTexture("Interface\\Icons\\INV_MISC_QUESTIONMARK")
					end
					
					local spec = data.spec
					local specIcon = module.db.specIcons[spec]
					if not specIcon and VExRT and VExRT.ExCD2 and VExRT.ExCD2.gnGUIDs and VExRT.ExCD2.gnGUIDs[ name ] then
						spec = VExRT.ExCD2.gnGUIDs[ name ]
						specIcon = module.db.specIcons[spec]
					end
					
					if specIcon then
						line.spec.texture:SetTexture(specIcon)
						line.spec.id = spec
					else
						line.spec.texture:SetTexture("Interface\\Icons\\INV_MISC_QUESTIONMARK")
						line.spec.id = nil
					end
					
					line.ilvl:SetText(format("%.2f",data.ilvl or 0))
					
					line.linkSpecID = spec
					line.linkClassID = module.db.classIDs[class or "?"]
					
					if module.db.page == 1 then
						for j=1,16 do
							line.items[j]:Show()
							line.items[j].border:Hide()
						end
						line.time:Hide()
						line.otherInfo:Hide()
						line.otherInfoTooltipFrame:Hide()
					
						local items = data.items
						local items_ilvl = data.items_ilvl
						if items then
							for j=1,#module.db.itemsSlotTable do
								local slotID = module.db.itemsSlotTable[j]
								local item = items[slotID]
								if item then
									local itemID,enchantID = string.match(item,"item:(%d+):(%d+):")
									itemID = itemID and tonumber(itemID) or 0
									enchantID = enchantID and tonumber(enchantID) or 0
									--local itemTexture = GetItemIcon(itemID)
									local _,_,_,_,_,_,_,_,_,itemTexture = GetItemInfo(item)
									line.items[j].texture:SetTexture(itemTexture)
									line.items[j].link = item
									if (enchantID == 0 and (slotID == 2 or slotID == 15 or slotID == 11 or slotID == 12 or slotID == 16 or (module.db.specHasOffhand[spec or 0] and slotID == 17)) and module.db.colorizeNoEnch) or
										(items_ilvl[slotID] and items_ilvl[slotID] > 0 and items_ilvl[slotID] < 630 and module.db.colorizeLowIlvl) or
										(module.db.colorizeNoGems and ExRT.mds.IsBonusOnItem(item,module.db.socketsBonusIDs) and IsItemHasNotGem(item)) or 
										(module.db.colorizeNoTopEnchGems and not IsTopEnchAndGems(item)) or
										(items_ilvl[slotID] and items_ilvl[slotID] > 0 and items_ilvl[slotID] < 685 and module.db.colorizeLowIlvl685)
										then
										line.items[j].border:Show()
									end
									
									line.items[j]:Show()		
								else
									line.items[j]:Hide()
								end
							end
						else
							for j=1,16 do
								line.items[j]:Hide()
							end
						end
					elseif module.db.page == 2 then
						for j=1,16 do
							ExRT.lib.ShowOrHide(line.items[j],j<=14)
							line.items[j].border:Hide()
						end
						line.time:Hide()
						line.otherInfo:Hide()
						line.otherInfoTooltipFrame:Hide()
					
						for j=1,7 do
							local t = data[j]
							if t and t ~= 0 then
								t = (j-1)*3+t
								local spellTexture = select(3,GetTalentInfoByID( data.talentsIDs[j] ))
								line.items[j].texture:SetTexture(spellTexture)
								line.items[j].link = GetTalentLink( data.talentsIDs[j] )
								line.items[j].sid = nil
								line.items[j]:Show()
							else
								line.items[j]:Hide()
							end
						end
						line.items[8]:Hide()
						for j=9,14 do
							local t = data[module.db.glyphsIDs[j-8]]
							if t then
								local spellTexture = GetSpellTexture(t)
								line.items[j].texture:SetTexture(spellTexture)
								line.items[j].link = "|cffffffff|Hspell:"..t.."|h[name]|h|r"
								line.items[j].sid = t
								line.items[j]:Show()
							else
								line.items[j]:Hide()
							end
						end
					elseif module.db.page == 3 then
						for j=1,16 do
							line.items[j]:Hide()
							line.items[j].border:Hide()
						end
						line.time:Show()
						line.time:SetText(date("%H:%M:%S",data.time))
						
						local result = ""
						for k,statName in ipairs(module.db.statsList) do
							local statValue = data[statName]
							if statValue and statValue > 50 then
								if module.db.baseStats[statName] then
									local classCount = module.db.classIDs[class]
									if classCount then
										statValue = statValue + module.db.baseStats[statName][classCount]
										local raceCount = ExRT.mds.table_find(module.db.raceList,data.race)
										if raceCount then
											statValue = statValue + module.db.raceStatsDiffs[statName][raceCount]
										end
									end
								end
								if spec and module.db.statsMultiplayBySpec[spec] == statName then
									statValue = statValue * 1.05
								end
								if k <= 3 then
									statValue = statValue * 1.05
								elseif k <= 7 and data.amplify and data.amplify ~= 0 then
									statValue = statValue * (1 + data.amplify/100)
								end
								result = result .. module.db.statsListName[k] .. ": " ..floor(statValue)..", "
							end
						end
						if data.radiness and data.radiness ~= 0 then
							result = result..ExRT.L.InspectViewerRadiness..": "..format("%.2f%%",(data.radiness or 0) * 100)
						else
							if string.len(result) > 0 then
								result = string.sub(result,1,-3)
							end
						end
						line.otherInfo:SetText(result)
						line.otherInfo:Show()
						line.otherInfoTooltipFrame:Show()
					end
					
					local cR,cG,cB = ExRT.mds.classColorNum(class)
					if name and UnitName(name) then
						line.back:SetGradientAlpha("HORIZONTAL", cR,cG,cB, 0.5, cR,cG,cB, 0)
					else
						line.back:SetGradientAlpha("HORIZONTAL", cR,cG,cB, 0, cR,cG,cB, 0.5)
					end
				else
					for j=1,16 do
						line.items[j]:Hide()
					end
					line.time:Show()
					line.time:SetText(ExRT.L.InspectViewerNoData)
					
					line.otherInfo:Hide()
					line.otherInfoTooltipFrame:Hide()
					
					line.class.texture:SetTexture("Interface\\Icons\\INV_MISC_QUESTIONMARK")
					line.class.texture:SetTexCoord(0,1,0,1)
					line.spec.texture:SetTexture("Interface\\Icons\\INV_MISC_QUESTIONMARK")
					line.spec.id = nil
					line.ilvl:SetText("")
					
					line.back:SetGradientAlpha("HORIZONTAL", 0, 0, 0, 0.5, 0, 0, 0, 0)
				end
				
				if not parentModule.db.inspectQuery[ name ] and module.db.page < 3 then
					line.updateButton:Show()
				else
					line.updateButton:Hide()
				end
				
				line:Show()
				if counter >= module.db.perPage then
					break
				end
			end
		end
		for i=(counter+1),module.db.perPage do
			module.options.lines[i]:Hide()
		end
	end
	self.ScrollBar:SetScript("OnValueChanged", module.options.ReloadPage)
	
	local function NoIlvl()
		self.raidItemLevel:SetText("")
	end
	
	function module.options.RaidIlvl()
		local n = GetNumGroupMembers() or 0
		if GetNumGroupMembers() == 0 then
			NoIlvl()
			return
		end
		local isRaid = IsInRaid()
		local gMax = ExRT.mds.GetRaidDiffMaxGroup()
		local ilvl = 0
		local countPeople = 0
		if not isRaid then
			for i=1,n do
				local unit = "party"..i
				if i==n then unit = "player" end
				local name = UnitName(unit)
				if name then
					if module.db.inspectDB[name] and module.db.inspectDB[name].ilvl and module.db.inspectDB[name].ilvl >= 1 then
						countPeople = countPeople + 1
						ilvl = ilvl + module.db.inspectDB[name].ilvl
					end
				end
			end
		else
			for i=1,n do
				local name,_,subgroup = GetRaidRosterInfo(i)
				if name and subgroup <= gMax then
					if module.db.inspectDB[name] and module.db.inspectDB[name].ilvl and module.db.inspectDB[name].ilvl >= 1 then
						countPeople = countPeople + 1
						ilvl = ilvl + module.db.inspectDB[name].ilvl
					end
				end
			end
		end
		if countPeople == 0 then
			NoIlvl()
			return
		end
		ilvl = ilvl / countPeople
		self.raidItemLevel:SetText(ExRT.L.InspectViewerRaidIlvl..": "..format("%.02f",ilvl).." ("..format(ExRT.L.InspectViewerRaidIlvlData,countPeople)..")")
	end
	
	local function otherInfoHover(self)
		local parent = self:GetParent()
		if not parent.otherInfo:IsShown() then
			return
		end
		if parent.otherInfo:IsTruncated() then
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			GameTooltip:SetText(parent.otherInfo:GetText(),nil, nil, nil, nil,true)
			GameTooltip:Show()
		end
	end
	
	local function Lines_SpecIcon_OnEnter(self)
		if self.id then
			local _,name,descr = GetSpecializationInfoByID(self.id)
			ExRT.lib.TooltipShow(self,"ANCHOR_LEFT",name,{descr,1,1,1,true})
		end
	end
	local function Lines_ItemIcon_OnEnter(self)
		if self.link then
			local classID = self:GetParent().linkClassID
			local specID = self:GetParent().linkSpecID
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			GameTooltip:SetHyperlink(self.link,classID,specID)
			GameTooltip:Show()
		end
	end
	local function Lines_ItemIcon_OnClick(self)
		if self.link then
			if module.db.page == 1 then
				ExRT.mds.LinkItem(nil, self.link)
			elseif module.db.page == 2 then
				if self.sid then
					ExRT.mds.LinkSpell(self.sid)
				else
					ExRT.mds.LinkSpell(nil,self.link)
				end
			end
		end
	end
	local function Lines_UpdateButton_OnEnter(self)
		self.texture:SetVertexColor(0.9,0.75,0,1)
	end	
	local function Lines_UpdateButton_OnLeave(self)
		self.texture:SetVertexColor(1,1,1,0.7)
	end
	local function Lines_UpdateButton_OnClick(self)
		local unit = self:GetParent().unit
		if unit then
			parentModule:AddToQueue(unit)
			module.options:showPage()
		end
	end	
		
	local IconBackDrop = {bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 }}
	
	self.lines = {}
	for i=1,module.db.perPage do
		self.lines[i] = CreateFrame("Frame",nil,self.borderList)
		self.lines[i]:SetSize(625,30)
		self.lines[i]:SetPoint("TOPLEFT",0,-(i-1)*30-1)
		
		self.lines[i].name = ExRT.lib.CreateText(self.lines[i],94,30,nil,5,0,"LEFT",nil,nil,11,"Name",nil,1,1,1,1)
		
		self.lines[i].class = ExRT.lib.CreateIcon(self.lines[i],24,nil,100,-3)
		
		self.lines[i].spec = ExRT.lib.CreateIcon(self.lines[i],24,nil,130,-3)
		self.lines[i].spec:SetScript("OnEnter",Lines_SpecIcon_OnEnter)
		self.lines[i].spec:SetScript("OnLeave",GameTooltip_Hide)
		
		self.lines[i].ilvl = ExRT.lib.CreateText(self.lines[i],50,30,nil,160,0,"LEFT",nil,nil,11,"630.52",nil,1,1,1,1)
		
		self.lines[i].items = {}
		for j=1,16 do
			self.lines[i].items[j] = ExRT.lib.CreateIcon(self.lines[i],22,nil,210+(24*(j-1)),-4,nil,true)
			self.lines[i].items[j]:SetScript("OnEnter",Lines_ItemIcon_OnEnter)
			self.lines[i].items[j]:SetScript("OnLeave",GameTooltip_Hide)
			self.lines[i].items[j]:SetScript("OnClick",Lines_ItemIcon_OnClick)
			
			self.lines[i].items[j].border = CreateFrame("Frame",nil,self.lines[i].items[j])
			self.lines[i].items[j].border:SetPoint("CENTER",0,0)
			self.lines[i].items[j].border:SetSize(22+8,22+8)
			self.lines[i].items[j].border:SetBackdrop(IconBackDrop)
			self.lines[i].items[j].border:SetBackdropColor(1,0,0,.4)
			self.lines[i].items[j].border:SetBackdropBorderColor(1,0,0,1)
			
			self.lines[i].items[j].border:Hide()
		end
		
		self.lines[i].updateButton = ExRT.lib.CreateIcon(self.lines[i],18,nil,210+(24*16)+4,-8,[[Interface\AddOns\ExRT\media\DiesalGUIcons16x256x128]],true)
		self.lines[i].updateButton.texture:SetTexCoord(0.125,0.1875,0.5,0.625)
		self.lines[i].updateButton.texture:SetVertexColor(1,1,1,0.7)
		self.lines[i].updateButton:SetScript("OnEnter",Lines_UpdateButton_OnEnter)
		self.lines[i].updateButton:SetScript("OnLeave",Lines_UpdateButton_OnLeave)
		self.lines[i].updateButton:SetScript("OnClick",Lines_UpdateButton_OnClick)
		self.lines[i].updateButton:Hide()
		
		self.lines[i].time = ExRT.lib.CreateText(self.lines[i],80,30,nil,205,0,"CENTER",nil,nil,11,date("%H:%M:%S",time()),nil,1,1,1,1)
		self.lines[i].otherInfo = ExRT.lib.CreateText(self.lines[i],335,30,nil,285,0,"LEFT",nil,nil,10,"",nil,1,1,1,1)
		
		self.lines[i].otherInfoTooltipFrame = CreateFrame("Frame",nil,self.lines[i])
		self.lines[i].otherInfoTooltipFrame:SetAllPoints(self.lines[i].otherInfo)
		self.lines[i].otherInfoTooltipFrame:SetScript("OnEnter",otherInfoHover)
		self.lines[i].otherInfoTooltipFrame:SetScript("OnLeave",GameTooltip_Hide)
		
		self.lines[i].back = self.lines[i]:CreateTexture(nil, "BACKGROUND")
		self.lines[i].back:SetPoint("TOPLEFT",2,-1)
		self.lines[i].back:SetPoint("BOTTOMRIGHT",0,0)
		self.lines[i].back:SetTexture( 1, 1, 1, 1)
		self.lines[i].back:SetGradientAlpha("HORIZONTAL", 0, 0, 0, 1, 0, 0, 0, 0)
	end
	self.raidItemLevel = ExRT.lib.CreateText(self,500,20,nil,10,-549,nil,"MIDDLE",nil,12,"",nil,1,1,1,1)
	self.raidItemLevel:SetNewPoint("TOPLEFT",self.borderList,"BOTTOMLEFT",3,-2)
	
	local animationTimer = 0
	self:SetScript("OnUpdate",function (self, elapsed)
		animationTimer = animationTimer + elapsed
		local color = animationTimer
		if color > 1 then
			color = 2 - color
		end
		if color < 0 then
			color = 0
		end
		for i=1,module.db.perPage do
			for j=1,16 do
				local frame = self.lines[i].items[j].border
				if frame:IsVisible() then
					frame:SetBackdropBorderColor(1,color,color,1)
					frame:SetBackdropColor(1,color,color,1)
				end
			end
		end
		if animationTimer > 2 then
			animationTimer = animationTimer % 2
		end
	end)
	
	self.moreInfoButton = ExRT.lib.CreateButton(self,200,20,nil,0,0,ExRT.L.InspectViewerMoreInfo,nil,nil,"ExRTButtonModernTemplate")
	ExRT.lib.SetPoint(self.moreInfoButton,"TOPRIGHT",self.borderList,"BOTTOMRIGHT",0,-1)
	self.moreInfoButton:SetScript("OnClick",function() module.options.moreInfoWindow:Show() end)
	
	self.moreInfoWindow = ExRT.lib.CreatePopupFrame(250,170,ExRT.L.InspectViewerMoreInfo,true)
	self.moreInfoWindow:SetScript("OnShow",function (self)
		local armorCloth,armorLeather,armorMail,armorPlate = 0,0,0,0
		local roleTank,roleMDD,roleRDD,roleHealer = 0,0,0,0
	
		local n = GetNumGroupMembers() or 0
		local gMax = ExRT.mds.GetRaidDiffMaxGroup()
		local ilvl = 0
		local countPeople = 0
		for i=1,n do
			local name,_,subgroup = GetRaidRosterInfo(i)
			if name and subgroup <= gMax then
				local data = module.db.inspectDB[name]
				if data then
					countPeople = countPeople + 1
					if data.class then
						if module.db.armorType[data.class] == "CLOTH" then
							armorCloth = armorCloth + 1
						elseif module.db.armorType[data.class] == "LEATHER" then
							armorLeather = armorLeather + 1
						elseif module.db.armorType[data.class] == "MAIL" then
							armorMail = armorMail + 1
						elseif module.db.armorType[data.class] == "PLATE" then
							armorPlate = armorPlate + 1
						end
					end
					if data.spec then
						if module.db.roleBySpec[data.spec] == "TANK" then
							roleTank = roleTank + 1
						elseif module.db.roleBySpec[data.spec] == "MELEE" then
							roleMDD = roleMDD + 1
						elseif module.db.roleBySpec[data.spec] == "RANGE" then
							roleRDD = roleRDD + 1
						elseif module.db.roleBySpec[data.spec] == "HEAL" then
							roleHealer = roleHealer + 1
						end
					end
				end
			end
		end
	
		self.textData:SetText(
			ExRT.L.InspectViewerMoreInfoRaidSetup..format(" ("..ExRT.L.InspectViewerRaidIlvlData.."):",countPeople).."\n"..
			ExRT.L.InspectViewerType..":\n"..
			"   "..ExRT.L.InspectViewerTypeCloth..": "..armorCloth.."\n"..
			"   "..ExRT.L.InspectViewerTypeLeather..": "..armorLeather.."\n"..
			"   "..ExRT.L.InspectViewerTypeMail..": "..armorMail.."\n"..
			"   "..ExRT.L.InspectViewerTypePlate..": "..armorPlate.."\n"..
			ExRT.L.InspectViewerMoreInfoRole..":\n"..
			"   "..ExRT.L.InspectViewerMoreInfoRoleTank..": "..roleTank.."\n"..
			"   "..ExRT.L.InspectViewerMoreInfoRoleMDD..": "..roleMDD.."\n"..
			"   "..ExRT.L.InspectViewerMoreInfoRoleRDD..": "..roleRDD.."\n"..
			"   "..ExRT.L.InspectViewerMoreInfoRoleHealer..": "..roleHealer
		)
	end)
	self.moreInfoWindow.textData = ExRT.lib.CreateText(self.moreInfoWindow,225,180,"TOP",0,-32,"LEFT","TOP",nil,11,"",nil,1,1,1)
	
	self.buttonForce = ExRT.lib.CreateButton(self,90,20,nil,0,0,ExRT.L.InspectViewerForce,nil,nil,"ExRTButtonModernTemplate")
	ExRT.lib.SetPoint(self.buttonForce,"BOTTOMRIGHT",self.borderList,"TOPRIGHT",0,5)
	self.buttonForce:SetScript("OnClick",function(self) 
		parentModule:Force() 
		self:SetEnabled(false)
	end)
	
	function module.options.showPage()
		local count = 0
		for _ in pairs(module.db.inspectDB) do
			count = count + 1
		end
		for name,_ in pairs(module.db.inspectQuery) do
			if not module.db.inspectDB[name] then
				count = count + 1
			end
		end
		self.ScrollBar:SetMinMaxValues(1,max(count-module.db.perPage+1,1))
		module.options.ReloadPage()
		
		module.options.RaidIlvl()
	end
	function self.UpdatePage_InspectEvent()
		module.options:showPage()
		ExRT.mds.ScheduleTimer(module.options.showPage, 4)
	end
	
	self.borderList:SetScript("OnShow",module.options.showPage)
	module:RegisterEvents("INSPECT_READY")
	module.options:showPage()
end

function module:slash(arg)
	if arg == "raid" then
		ExRT.Options:Open(module.options)
	end
end