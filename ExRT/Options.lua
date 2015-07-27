local GlobalAddonName, ExRT = ...

ExRT.Options = {}

------------------------------------------------------------
--------------- New Options --------------------------------
------------------------------------------------------------

local OptionsFrameName = "ExRTOptionsFrame"
local Options = CreateFrame("Frame",OptionsFrameName,UIParent,"ExRTBWInterfaceFrame")

ExRT.Options.Frame = Options

Options:Hide()
Options:SetPoint("CENTER",0,0)
Options:SetSize(863,650)
Options.HeaderText:SetText("Exorsus Raid Tools")
Options:SetMovable(true)
Options:RegisterForDrag("LeftButton")
Options:SetScript("OnDragStart", function(self) self:StartMoving() end)
Options:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
Options:SetDontSavePosition(true)
Options.border = ExRT.lib.CreateShadow(Options,20)

Options.bossButton:Hide()
Options.backToInterface:SetScript("OnClick",function ()
	ExRT.Options.Frame:Hide()
	InterfaceOptionsFrame:Show()
end)


Options.modulesList = ExRT.lib.CreateScrollList(Options,"TOPLEFT",10,-25,180,38,true)
for i=1,#Options.modulesList.List do
	Options.modulesList.List[i].text:SetFont(Options.modulesList.List[i].text:GetFont(),11)
end
Options.Frames = {}

Options:SetScript("OnShow",function(self)
	self.modulesList:Update()
	if Options.CurrentFrame and Options.CurrentFrame.AdditionalOnShow then
		Options.CurrentFrame:AdditionalOnShow()
	end
end)

function Options.modulesList:SetListValue(index)
	if Options.CurrentFrame then
		Options.CurrentFrame:Hide()
	end
	Options.CurrentFrame = Options.Frames[index]
	if Options.CurrentFrame.AdditionalOnShow then
		Options.CurrentFrame:AdditionalOnShow()
	end
	Options.CurrentFrame:Show()
end
function Options.modulesList:UpdateAdditional()
	if #self.L < #self.List then
		self.ScrollBar:Hide()
		for i=1,#self.List do
			self.List[i]:SetWidth(self.Width - 6)
			self.List[i].text:SetWidth(self.Width - 14)
		end
	else
		self.ScrollBar:Show()
		for i=1,#self.List do
			self.List[i]:SetWidth(self.Width - 22)
			self.List[i].text:SetWidth(self.Width - 30)
		end
	end
end

function ExRT.Options:Add(moduleName,frameName)
	local self = CreateFrame("Frame",OptionsFrameName..moduleName,Options)
	self:SetSize(660,615)
	self:SetPoint("TOPLEFT",195,-25)
	
	local pos = #Options.Frames + 1
	Options.modulesList.L[pos] = frameName or moduleName
	Options.Frames[pos] = self
	
	if Options:IsShown() then
		Options.modulesList:Update()
	end
	
	self:Hide()
	
	return self
end

local OptionsFrame = ExRT.Options:Add("Exorsus Raid Tools")
Options.modulesList:SetListValue(1)
Options.modulesList.selected = 1
Options.modulesList:Update()

------------------------------------------------------------

ExRT.Options.InBlizzardInterface = CreateFrame( "Frame", nil )
ExRT.Options.InBlizzardInterface.name = "Exorsus Raid Tools"
InterfaceOptions_AddCategory(ExRT.Options.InBlizzardInterface)
ExRT.Options.InBlizzardInterface:Hide()

ExRT.Options.InBlizzardInterface:SetScript("OnShow",function (self)
	if InterfaceOptionsFrame:IsShown() then
		InterfaceOptionsFrame:Hide()
	end
	ExRT.Options:Open()
	self:SetScript("OnShow",nil)
end)

ExRT.Options.InBlizzardInterface.button = ExRT.lib.CreateButton(ExRT.Options.InBlizzardInterface,400,25,"TOP",0,-100,"Exrsus Raid Tools")
ExRT.Options.InBlizzardInterface.button:SetScript("OnClick",function ()
	if InterfaceOptionsFrame:IsShown() then
		InterfaceOptionsFrame:Hide()
	end
	ExRT.Options:Open()
end)

----> Minimap Icon

local MiniMapIcon = CreateFrame("Button", "LibDBIcon10_ExorsusRaidTools", Minimap)
ExRT.MiniMapIcon = MiniMapIcon
MiniMapIcon:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight") 
MiniMapIcon:SetSize(32,32) 
MiniMapIcon:SetFrameStrata("MEDIUM")
MiniMapIcon:SetFrameLevel(8)
MiniMapIcon:SetPoint("CENTER", -12, -80)
MiniMapIcon:SetDontSavePosition(true)
MiniMapIcon:RegisterForDrag("LeftButton")
MiniMapIcon.icon = MiniMapIcon:CreateTexture(nil, "BACKGROUND")
MiniMapIcon.icon:SetTexture("Interface\\AddOns\\ExRT\\media\\MiniMap")
MiniMapIcon.icon:SetSize(32,32)
MiniMapIcon.icon:SetPoint("CENTER", 0, 0)
MiniMapIcon.border = MiniMapIcon:CreateTexture(nil, "ARTWORK")
MiniMapIcon.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
MiniMapIcon.border:SetTexCoord(0,0.6,0,0.6)
MiniMapIcon.border:SetAllPoints()
MiniMapIcon:RegisterForClicks("anyUp")
MiniMapIcon:SetScript("OnEnter",function(self) 
	GameTooltip:SetOwner(self, "ANCHOR_LEFT") 
	GameTooltip:AddLine("Exorsus Raid Tools") 
	GameTooltip:AddLine(ExRT.L.minimaptooltiplmp,1,1,1) 
	GameTooltip:AddLine(ExRT.L.minimaptooltiprmp,1,1,1) 
	GameTooltip:Show() 
end)
MiniMapIcon:SetScript("OnLeave", function(self)    
	GameTooltip:Hide()
end)

local minimapShapes = {
	["ROUND"] = {true, true, true, true},
	["SQUARE"] = {false, false, false, false},
	["CORNER-TOPLEFT"] = {false, false, false, true},
	["CORNER-TOPRIGHT"] = {false, false, true, false},
	["CORNER-BOTTOMLEFT"] = {false, true, false, false},
	["CORNER-BOTTOMRIGHT"] = {true, false, false, false},
	["SIDE-LEFT"] = {false, true, false, true},
	["SIDE-RIGHT"] = {true, false, true, false},
	["SIDE-TOP"] = {false, false, true, true},
	["SIDE-BOTTOM"] = {true, true, false, false},
	["TRICORNER-TOPLEFT"] = {false, true, true, true},
	["TRICORNER-TOPRIGHT"] = {true, false, true, true},
	["TRICORNER-BOTTOMLEFT"] = {true, true, false, true},
	["TRICORNER-BOTTOMRIGHT"] = {true, true, true, false},
}

local function IconMoveButton(self)
	if self.dragMode == "free" then
		local centerX, centerY = Minimap:GetCenter()
		local x, y = GetCursorPosition()
		x, y = x / self:GetEffectiveScale() - centerX, y / self:GetEffectiveScale() - centerY
		self:ClearAllPoints()
		self:SetPoint("CENTER", x, y)
		VExRT.Addon.IconMiniMapLeft = x
		VExRT.Addon.IconMiniMapTop = y
	else
		local mx, my = Minimap:GetCenter()
		local px, py = GetCursorPosition()
		local scale = Minimap:GetEffectiveScale()
		px, py = px / scale, py / scale
		
		local angle = math.atan2(py - my, px - mx)
		local x, y, q = math.cos(angle), math.sin(angle), 1
		if x < 0 then q = q + 1 end
		if y > 0 then q = q + 2 end
		local minimapShape = GetMinimapShape and GetMinimapShape() or "ROUND"
		local quadTable = minimapShapes[minimapShape]
		if quadTable[q] then
			x, y = x*80, y*80
		else
			local diagRadius = 103.13708498985 --math.sqrt(2*(80)^2)-10
			x = math.max(-80, math.min(x*diagRadius, 80))
			y = math.max(-80, math.min(y*diagRadius, 80))
		end
		self:ClearAllPoints()
		self:SetPoint("CENTER", Minimap, "CENTER", x, y)
		VExRT.Addon.IconMiniMapLeft = x
		VExRT.Addon.IconMiniMapTop = y
	end
end

MiniMapIcon:SetScript("OnDragStart", function(self)
	self:LockHighlight()
	self:SetScript("OnUpdate", IconMoveButton)
	self.isMoving = true
	GameTooltip:Hide()
end)
MiniMapIcon:SetScript("OnDragStop", function(self)
	self:UnlockHighlight()
	self:SetScript("OnUpdate", nil)
	self.isMoving = false
end)

local function MiniMapIconOnClick(self, button)
	if button == "RightButton" then
		for _,func in pairs(ExRT.MiniMapMenu) do
			func:miniMapMenu()
		end
		ExRT.Options:UpdateModulesList()
		EasyMenu(ExRT.F.menuTable, ExRT.Options.MiniMapDropdown, "cursor", 10 , -15, "MENU")
	elseif button == "LeftButton" then
		ExRT.Options:Open()
	end
end

MiniMapIcon:SetScript("OnMouseUp", MiniMapIconOnClick)

ExRT.Options.MiniMapDropdown = CreateFrame("Frame", "ExRTMiniMapMenuFrame", nil, "UIDropDownMenuTemplate")

local MinimapMenu_UIDs = {}
local MinimapMenu_UIDnumeric = 0
local MinimapMenu_Level = {3,4,5,5}

function ExRT.F.MinimapMenuAdd(text, func, level, uid, subMenu)
	level = level or 2
	if not uid then
		MinimapMenu_UIDnumeric = MinimapMenu_UIDnumeric + 1
		uid = MinimapMenu_UIDnumeric
	end
	if MinimapMenu_UIDs[uid] then
		return
	end
	local menuTable = { text = text, func = func, notCheckable = true, keepShownOnClick = true, }
	if subMenu then
		menuTable.hasArrow = true
		menuTable.menuList = subMenu
	end
	tinsert(ExRT.F.menuTable,MinimapMenu_Level[level],menuTable)
	for i=level,#MinimapMenu_Level do
		MinimapMenu_Level[i] = MinimapMenu_Level[i] + 1
	end
	MinimapMenu_UIDs[uid] = menuTable
end

function ExRT.F.MinimapMenuRemove(uid)
	for i=1,#ExRT.F.menuTable do
		if ExRT.F.menuTable[i] == MinimapMenu_UIDs[uid] then 
			for j=i,#ExRT.F.menuTable do
				ExRT.F.menuTable[j] = ExRT.F.menuTable[j+1]
			end
			for j=1,#MinimapMenu_Level do
				if i <= MinimapMenu_Level[j] then
					MinimapMenu_Level[j] = MinimapMenu_Level[j] - 1
				end
			end
			MinimapMenu_UIDs[uid] = nil
			return
		end
	end
end

function ExRT.Options:Open(PANEL)
	CloseDropDownMenus()
	Options:Show()
	
	if Options.CurrentFrame then
		Options.CurrentFrame:Hide()
	end
	Options.CurrentFrame = PANEL or Options.Frames[Options.modulesList.selected or 1]
	Options.CurrentFrame:Show()
	
	if PANEL then
		for i=1,#Options.Frames do
			if Options.Frames[i] == PANEL then
				Options.modulesList.selected = i
				Options.modulesList:Update()
				break
			end
		end
	end
end

ExRT.F.menuTable = {
{ text = ExRT.L.minimapmenu, isTitle = true, notCheckable = true, notClickable = true },
{ text = ExRT.L.minimapmenuset, func = ExRT.Options.Open, notCheckable = true, keepShownOnClick = true, },
{ text = " ", isTitle = true, notCheckable = true, notClickable = true },
{ text = " ", isTitle = true, notCheckable = true, notClickable = true },
{ text = ExRT.L.minimapmenuclose, func = function() CloseDropDownMenus() end, notCheckable = true },
}

local modulesActive = {}
function ExRT.Options:UpdateModulesList()
	for i=1,#ExRT.ModulesOptions do
		ExRT.F.MinimapMenuAdd(ExRT.ModulesOptions[i].name, function() 
			ExRT.Options:Open(ExRT.ModulesOptions[i]) 
		end, 2,ExRT.ModulesOptions[i].name)
	end
end

----> Options

OptionsFrame.title = ExRT.lib.CreateText(OptionsFrame,500,22,nil,160,-35,nil,nil,nil,22,"Exorsus Raid Tools",nil,1,1,1)

OptionsFrame.image = CreateFrame("FRAME",nil,OptionsFrame)
OptionsFrame.image:SetSize(256,256)
OptionsFrame.image:SetBackdrop({bgFile = "Interface\\AddOns\\ExRT\\media\\OptionLogo"})
OptionsFrame.image:SetPoint("TOPLEFT",-45,25)	
OptionsFrame.image:SetFrameLevel(5)

OptionsFrame.chkIconMiniMap = ExRT.lib.CreateCheckBox(OptionsFrame,nil,25,-140,ExRT.L.setminimap1,nil,nil,nil,"ExRTCheckButtonModernTemplate")
OptionsFrame.chkIconMiniMap:SetScript("OnClick", function(self,event) 
	if self:GetChecked() then
		VExRT.Addon.IconMiniMapHide = true
		ExRT.MiniMapIcon:Hide()
	else
		VExRT.Addon.IconMiniMapHide = nil
		ExRT.MiniMapIcon:Show()
	end
end)
OptionsFrame.chkIconMiniMap:SetScript("OnShow", function(self,event) 
	self:SetChecked(VExRT.Addon.IconMiniMapHide) 
end)

OptionsFrame.timerSlider = ExRT.lib.CreateSlider(OptionsFrame,550,15,0,-125,10,1000,ExRT.L.setEggTimerSlider,100,"TOP")
OptionsFrame.timerSlider:Hide()
OptionsFrame.timerSlider:SetScript("OnValueChanged", function(self,event) 
	event = event - event%1
	self.tooltipText = event
	self:tooltipReload(self)	
	event = event / 1000	
	VExRT.Addon.Timer = event
end)

OptionsFrame.eventsCountTextLeft = ExRT.lib.CreateText(OptionsFrame,590,300,"TOPLEFT",15,-300,"LEFT","TOP",nil,12,nil,nil,1,1,1,1)
OptionsFrame.eventsCountTextRight = ExRT.lib.CreateText(OptionsFrame,590,300,"TOPLEFT",85,-300,"LEFT","TOP",nil,12,nil,nil,1,1,1,1)
OptionsFrame.eventsCountTextFrame = CreateFrame("Frame",nil,OptionsFrame)
OptionsFrame.eventsCountTextFrame:SetSize(1,1)
OptionsFrame.eventsCountTextFrame:SetPoint("TOPLEFT")
OptionsFrame.eventsCountTextFrame:Hide()
OptionsFrame.eventsCountTextFrame:SetScript("OnShow",function()
	local tmp = {}
	for i=1,#ExRT.Modules do
		if ExRT.Modules[i].main.eventsCounter then
			for event,count in pairs(ExRT.Modules[i].main.eventsCounter) do
				if not tmp[event] then
					tmp[event] = count
				else
					tmp[event] = max(tmp[event],count)
				end
			end
		end
	end
	tmp["COMBAT_LOG_EVENT_UNFILTERED"] = ExRT.CLEUframe.eventsCounter or 0
	local tmp2 = {}
	local total = 0
	for event,count in pairs(tmp) do
		table.insert(tmp2,{event,count})
		total = total + count
	end
	table.sort(tmp2,function(a,b) return a[2] > b[2] end)
	local h = total.."\n"
	local n = "Total\n"
	for i=1,#tmp2 do
		h = h .. tmp2[i][2].."\n"
		n = n .. tmp2[i][1] .."\n"
	end
	OptionsFrame.eventsCountTextLeft:SetText(h)
	OptionsFrame.eventsCountTextRight:SetText(n)
end)

OptionsFrame.eggBut = CreateFrame("Button",nil,OptionsFrame)  
OptionsFrame.eggBut:SetSize(12,12) 
OptionsFrame.eggBut:SetPoint("TOPLEFT",75,-23)
OptionsFrame.eggBut:SetFrameLevel(8)
OptionsFrame.eggBut:SetScript("OnClick",function(s) 
	local superMode = nil
	OptionsFrame.timerSlider:SetValue(VExRT.Addon.Timer*1000 or 100)
	OptionsFrame.timerSlider:Show()
	OptionsFrame.eventsCountTextFrame:Show()
	if IsShiftKeyDown() then
		return
	end
	if IsAltKeyDown() then
		superMode = true
	end
	for i, val in pairs(ExRT.Eggs) do
		val:egg(superMode)
	end
end)

OptionsFrame.authorLeft = ExRT.lib.CreateText(OptionsFrame,150,25,nil,15,-195,"LEFT","TOP",nil,12,ExRT.L.setauthor,nil,nil,nil,nil,1)
OptionsFrame.authorRight = ExRT.lib.CreateText(OptionsFrame,520,25,nil,135,-195,"LEFT","TOP",nil,12,"Afiya (Афиа) @ EU-Howling Fjord",nil,1,1,1,1)

OptionsFrame.versionLeft = ExRT.lib.CreateText(OptionsFrame,150,25,nil,15,-215,"LEFT","TOP",nil,12,ExRT.L.setver,nil,nil,nil,nil,1)
OptionsFrame.versionRight = ExRT.lib.CreateText(OptionsFrame,520,25,nil,135,-215,"LEFT","TOP",nil,12,ExRT.V..(ExRT.T == "R" and "" or " "..ExRT.T),nil,1,1,1,1)

OptionsFrame.contactLeft = ExRT.lib.CreateText(OptionsFrame,150,25,nil,15,-235,"LEFT","TOP",nil,12,ExRT.L.setcontact,nil,nil,nil,nil,1)
OptionsFrame.contactRight = ExRT.lib.CreateText(OptionsFrame,520,25,nil,135,-235,"LEFT","TOP",nil,12,"e-mail: ykiigor@gmail.com",nil,1,1,1,1)

OptionsFrame.thanksLeft = ExRT.lib.CreateText(OptionsFrame,150,25,nil,15,-255,"LEFT","TOP",nil,12,ExRT.L.SetThanks,nil,nil,nil,nil,1)
OptionsFrame.thanksRight = ExRT.lib.CreateText(OptionsFrame,520,0,nil,135,-255,"LEFT","TOP",nil,12,"Phanx, funkydude, Shurshik, Kemayo, Guillotine, Rabbit, fookah, diesal2010",nil,1,1,1,1)

if ExRT.L.TranslateBy ~= "" then
	OptionsFrame.translateLeft = ExRT.lib.CreateText(OptionsFrame,150,25,nil,15,-255,"LEFT","TOP",nil,12,ExRT.L.SetTranslate,nil,nil,nil,nil,1)
	OptionsFrame.translateRight = ExRT.lib.CreateText(OptionsFrame,520,25,nil,135,-255,"LEFT","TOP",nil,12,ExRT.L.TranslateBy,nil,1,1,1,1)
	ExRT.lib.SetPoint(OptionsFrame.translateRight,"TOPLEFT",OptionsFrame.thanksRight,"BOTTOMLEFT",0,-10)
	ExRT.lib.SetPoint(OptionsFrame.translateLeft,"TOPLEFT",OptionsFrame.translateRight,"TOPLEFT",-120,0)
end

local function CreateDataBrokerPlugin()
	local dataObject = LibStub:GetLibrary('LibDataBroker-1.1'):NewDataObject(GlobalAddonName, {
		type = 'launcher',

		icon = "Interface\\AddOns\\ExRT\\media\\MiniMap",

		OnClick = MiniMapIconOnClick,
	})
end
CreateDataBrokerPlugin()
