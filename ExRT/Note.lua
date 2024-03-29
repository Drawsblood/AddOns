local GlobalAddonName, ExRT = ...

local VExRT = nil

local module = ExRT.mod:New("Note",ExRT.L.message,nil,true)
local ELib,L = ExRT.lib,ExRT.L

module.db.iconsList = {
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:0|t",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:0|t",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:0|t",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:0|t",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:0|t",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:0|t",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:0|t",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0|t",
}
module.db.otherIconsList = {
	{"{"..L.classLocalizate["WARRIOR"] .."}","|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:16:16:0:0:256:256:0:64:0:64|t","Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0,0.25,0,0.25},
	{"{"..L.classLocalizate["PALADIN"] .."}","|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:16:16:0:0:256:256:0:64:128:192|t","Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0,0.25,0.5,0.75},
	{"{"..L.classLocalizate["HUNTER"] .."}","|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:16:16:0:0:256:256:0:64:64:128|t","Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0,0.25,0.25,0.5},
	{"{"..L.classLocalizate["ROGUE"] .."}","|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:16:16:0:0:256:256:127:190:0:64|t","Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.49609375,0.7421875,0,0.25},
	{"{"..L.classLocalizate["PRIEST"] .."}","|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:16:16:0:0:256:256:127:190:64:128|t","Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.49609375,0.7421875,0.25,0.5},
	{"{"..L.classLocalizate["DEATHKNIGHT"] .."}","|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:16:16:0:0:256:256:64:128:128:192|t","Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.25,0.5,0.5,0.75},
	{"{"..L.classLocalizate["SHAMAN"] .."}","|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:16:16:0:0:256:256:64:127:64:128|t","Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.25,0.49609375,0.25,0.5},
	{"{"..L.classLocalizate["MAGE"] .."}","|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:16:16:0:0:256:256:64:127:0:64|t","Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.25,0.49609375,0,0.25},
	{"{"..L.classLocalizate["WARLOCK"] .."}","|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:16:16:0:0:256:256:190:253:64:128|t","Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.7421875,0.98828125,0.25,0.5},
	{"{"..L.classLocalizate["MONK"] .."}","|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:16:16:0:0:256:256:128:189:128:192|t","Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.5,0.73828125,0.5,0.75},
	{"{"..L.classLocalizate["DRUID"] .."}","|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:16:16:0:0:256:256:190:253:0:64|t","Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.7421875,0.98828125,0,0.25},
	{"{wow}","|TInterface\\FriendsFrame\\Battlenet-WoWicon:16|t","Interface\\FriendsFrame\\Battlenet-WoWicon"},
	{"{d3}","|TInterface\\FriendsFrame\\Battlenet-D3icon:16|t","Interface\\FriendsFrame\\Battlenet-D3icon"},
	{"{sc2}","|TInterface\\FriendsFrame\\Battlenet-Sc2icon:16|t","Interface\\FriendsFrame\\Battlenet-Sc2icon"},
	{"{bnet}","|TInterface\\FriendsFrame\\Battlenet-Portrait:16|t","Interface\\FriendsFrame\\Battlenet-Portrait"},
	{"{alliance}","|TInterface\\FriendsFrame\\PlusManz-Alliance:16|t","Interface\\FriendsFrame\\PlusManz-Alliance"},
	{"{horde}","|TInterface\\FriendsFrame\\PlusManz-Horde:16|t","Interface\\FriendsFrame\\PlusManz-Horde"},	
	{"{T}","|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:0:19:22:41|t","Interface\\LFGFrame\\UI-LFG-ICON-ROLES",0,0.26171875,0.26171875,0.5234375},
	{"{H}","|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:1:20|t","Interface\\LFGFrame\\UI-LFG-ICON-ROLES",0.26171875,0.5234375,0,0.26171875},
	{"{D}","|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:22:41|t","Interface\\LFGFrame\\UI-LFG-ICON-ROLES",0.26171875,0.5234375,0.26171875,0.5234375},
	{"{tank}","|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:0:19:22:41|t","Interface\\LFGFrame\\UI-LFG-ICON-ROLES",0,0.26171875,0.26171875,0.5234375},
	{"{healer}","|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:1:20|t","Interface\\LFGFrame\\UI-LFG-ICON-ROLES",0.26171875,0.5234375,0,0.26171875},
	{"{dps}","|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:22:41|t","Interface\\LFGFrame\\UI-LFG-ICON-ROLES",0.26171875,0.5234375,0.26171875,0.5234375},
	--[[
	{"{T}","|TInterface\\LFGFrame\\UI-LFG-ICON-ROLES:16:16:0:0:256:256:0:67:67:134|t","Interface\\LFGFrame\\UI-LFG-ICON-ROLES",0,0.26171875,0.26171875,0.5234375},
	{"{H}","|TInterface\\LFGFrame\\UI-LFG-ICON-ROLES:16:16:0:0:256:256:67:134:0:67|t","Interface\\LFGFrame\\UI-LFG-ICON-ROLES",0.26171875,0.5234375,0,0.26171875},
	{"{D}","|TInterface\\LFGFrame\\UI-LFG-ICON-ROLES:16:16:0:0:256:256:67:134:67:134|t","Interface\\LFGFrame\\UI-LFG-ICON-ROLES",0.26171875,0.5234375,0.26171875,0.5234375},
	]]

}
module.db.iconsLocalizatedNames = {
	L.raidtargeticon1,L.raidtargeticon2,L.raidtargeticon3,L.raidtargeticon4,L.raidtargeticon5,L.raidtargeticon6,L.raidtargeticon7,L.raidtargeticon8
}
local frameStrataList = {"BACKGROUND","LOW","MEDIUM","HIGH","DIALOG","FULLSCREEN","FULLSCREEN_DIALOG","TOOLTIP"}

module.db.msgindex = -1
module.db.lasttext = ""

local function txtWithIcons(t)
	t = t or ""
	t = string.gsub(t,"||T","|T")
	t = string.gsub(t,"||t","|t")
	for i=1,8 do
		t = string.gsub(t,module.db.iconsLocalizatedNames[i],module.db.iconsList[i])
		t = string.gsub(t,"{rt"..i.."}",module.db.iconsList[i])
	end
	t = string.gsub(t,"||c","|c")
	t = string.gsub(t,"||r","|r")
	for i=1,#module.db.otherIconsList do
		t = string.gsub(t,module.db.otherIconsList[i][1],module.db.otherIconsList[i][2])
	end
	
	local spellLastPos = t:find("{spell:[^}]+}")
	while spellLastPos do
		local template,spell = t:match("({spell:([^}]+)})")
		local _,spellTexture
		spell = tonumber(spell)
		if spell then
			_,_,spellTexture = GetSpellInfo( spell )
			spellTexture = "|T"..(spellTexture or "Interface\\Icons\\INV_MISC_QUESTIONMARK")..":16|t"
		end
		spellTexture = spellTexture or ""
		
		if template:find("%-") then
			template = template:gsub("%-","%%%-")
		end
		
		t = t:gsub(template,spellTexture)
		
		local spellNewPos = t:find("{spell:[^}]+}")
		if spellLastPos == spellNewPos then
			break
		end
		spellLastPos = spellNewPos
	end
	
	t = string.gsub(t,"{[^}]*}","")
	return t
end


function module.options:Load()
	self:CreateTilte()

	module.db.otherIconsAdditionalList = {
		31821,62618,97462,76577,51052,98008,115310,64843,740,108280,106898,0,
		47788,33206,6940,102342,114030,1022,116849,0,
		2825,32182,80353,0,
		0,
		183449,180080,181968,186737,185806,186016,0,
		182280,182001,185978,182003,182094,185282,179889,182055,182022,0,
		180246,181356,181297,181292,181092,181093,181300,181306,0,
		184355,184450,185065,185066,184674,184366,184652,183226,184360,184476,183885,184357,0,
		184067,184396,180718,180389,180199,180224,182428,0,
		182049,180148,180093,182170,181085,181973,179867,179864,0,
		182200,179219,181753,181956,181912,181827,181824,185345,185239,182325,179202,181873,0,
		182769,184239,182392,183329,180221,180418,188693,183331,190161,184124,184053,189540,0,
		180533,180600,180260,180300,180526,180608,181718,179986,179991,180040,185241,180000,185237,180604,0,
		188900,188998,189032,189031,189030,179407,179582,179709,181508,189009,179681,181498,0,
		190223,190224,186407,186333,189775,186453,186546,186532,186134,186135,185656,189781,0,
		181841,183377,183376,181134,181557,181597,181738,181099,181275,190482,186362,182031,181255,0,
		183864,190397,183828,183254,183598,188514,184931,184265,185590,190821,190686,189897,186662,190313,187244,186562,183963,190400,185014,190807,0,
		0,
		155078,155080,165298,155330,173192,0,
		173471,156297,156203,155900,0,
		155196,158246,155242,155240,155225,155192,176121,156934,0,
		157139,157853,156892,161570,0,
		154932,155074,155277,155314,0,
		156766,157059,156704,158217,173917,156852,0,
		162283,154960,154975,159045,155208,0,
		164380,155864,155921,159481,0,
		170395,170405,156631,158601,158315,164271,158010,156214,0,
		156772,156047,156096,175020,162498,157000,159142,177438,177487,156479,
	}

	local BlackNoteNow = nil
	local NoteIsSelfNow = nil
	self.IsMainNoteNow = true

	self.NotesList = ELib:ScrollList(self):Size(175,319):Point(5,-155)
	self.NotesList.selected = 1
	
	local function NotesListUpdateNames()
		self.NotesList.L = {}
		
		self.NotesList.L[1] = "|cff55ee55"..L.messageTab1
		self.NotesList.L[2] = L.NoteSelf
		for i=1,#VExRT.Note.Black do
			self.NotesList.L[i+2] = VExRT.Note.BlackNames[i] or i
		end
		self.NotesList.L[#self.NotesList.L + 1] = L.NoteAdd
		self.NotesList:Update()
	end
	NotesListUpdateNames()
	
	function self.NotesList:SetListValue(index)
		ExRT.lib.ShowOrHide(module.options.buttonsend,index == 1)
		ExRT.lib.ShowOrHide(module.options.buttonclear,index == 1)
		ExRT.lib.ShowOrHide(module.options.buttoncopy,index > 2)
		
		BlackNoteNow = nil
		NoteIsSelfNow = nil
		module.options.IsMainNoteNow = nil
		
		if index > 2 then
			module.options.DraftName:Enable()
			module.options.RemoveDraft:Enable()
		else
			module.options.DraftName:Disable()
			module.options.RemoveDraft:Disable()
		end
		
		if index == 1 then
			module.options.NoteEditBox.EditBox:SetText(VExRT.Note.Text1 or "")
			module.options.DraftName:SetText( L.messageTab1 )
			
			module.options.IsMainNoteNow = true
		elseif index == 2 then
			module.options.NoteEditBox.EditBox:SetText(VExRT.Note.SelfText or "")
			module.options.DraftName:SetText( L.NoteSelf )
			
			NoteIsSelfNow = true
		elseif index == #self.L then
			VExRT.Note.Black[#VExRT.Note.Black + 1] = ""
			tinsert(self.L,#self.L - 1,#VExRT.Note.Black)
			module.options.NoteEditBox.EditBox:SetText("")
			self:Update()
			
			BlackNoteNow = #VExRT.Note.Black
			module.options.DraftName:SetText( BlackNoteNow )
			
			NotesListUpdateNames()
		else
			index = index - 2
			if IsShiftKeyDown() then
				VExRT.Note.Black[index] = VExRT.Note.Text1
			end
			module.options.NoteEditBox.EditBox:SetText(VExRT.Note.Black[index] or "")
			
			BlackNoteNow = index
			module.options.DraftName:SetText( VExRT.Note.BlackNames[index] or index )
		end
	end
	
	function self.NotesList:HoverListValue(isHover,index)
		if not isHover then
			GameTooltip_Hide()
		else
			GameTooltip:SetOwner(self,"ANCHOR_CURSOR")
			GameTooltip:AddLine(self.L[index])
			if index == 2 then
				GameTooltip:AddLine(L.NoteSelfTooltip)
			elseif index ~= #self.L and index > 2 then
				GameTooltip:AddLine(L.NoteTabCopyTooltip)
			end
			GameTooltip:Show()
		end
	end
	
	self.RightTab = ELib:OneTab(self):Size(482,0):Point("TOPLEFT",self.NotesList,"TOPRIGHT",3,7):Point("BOTTOMLEFT",self.NotesList,"BOTTOMRIGHT",3,-7)
	self.RightTab:SetBackdropColor(0,0,0,0)
	self.RightTab:SetBackdropBorderColor(0,0,0,0)
	
	self.DraftName = ELib:Edit(self):Size(0,18):Tooltip(L.NoteDraftName):Text(L.messageTab1):Point("TOPLEFT",self.RightTab,8,-6):Point("TOPRIGHT",self.RightTab,-160,-6):OnChange(function(self,isUser)
		if not isUser then return end
		if BlackNoteNow then
			VExRT.Note.BlackNames[ BlackNoteNow ] = self:GetText()
			NotesListUpdateNames()
		end
	end)
	self.DraftName:Disable()
	
	self.RemoveDraft = ELib:Button(self.RightTab,L.NoteRemove):Size(150,20):Point("TOPRIGHT",-5,-5):Disable():OnClick(function (self)
		if not BlackNoteNow then
			return
		end
		local size = #VExRT.Note.Black
		for i=BlackNoteNow,size do
			if i < size then
				VExRT.Note.Black[i] = VExRT.Note.Black[i + 1]
				VExRT.Note.BlackNames[i] = VExRT.Note.BlackNames[i + 1]
			else
				VExRT.Note.Black[i] = nil
				VExRT.Note.BlackNames[i] = nil
			end
		end
		NotesListUpdateNames()
		if BlackNoteNow == (#module.options.NotesList.L - 2) then
			BlackNoteNow = BlackNoteNow - 1
		end
		module.options.NotesList:SetListValue(2+BlackNoteNow)
	end)
	
	self.NoteEditBox = ELib:MultiEdit(self.RightTab):Size(self.RightTab:GetWidth()-18,self.RightTab:GetHeight()-42):Point("TOP",0,-33)
	
	function self.NoteEditBox.EditBox:OnTextChanged()
		if NoteIsSelfNow then
			VExRT.Note.SelfText = self:GetText()
			module.frame:UpdateText()
		elseif BlackNoteNow then
			VExRT.Note.Black[ BlackNoteNow ] = self:GetText()
		end
	end
	
	self.buttonsend = ELib:Button(self,L.messagebutsend):Size(325,20):Point(5,-30):Tooltip(L.messagebutsendtooltip):OnClick(function (self)
		module.frame:Save() 
		
		if IsShiftKeyDown() then
			local text = VExRT.Note.Text1 or ""
			text = text:gsub("||c........","")
			text = text:gsub("||r","")
			text = text:gsub("||T.-:0||t ","")
			
			local lines = {strsplit("\n", text)}
			for i=1,#lines do
				if lines[i] ~= "" then
					SendChatMessage(lines[i],(IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT") or (IsInRaid() and "RAID") or "PARTY")
				end
			end
		end
	end) 

	self.buttonclear = ELib:Button(self,L.messagebutclear):Size(325,20):Point("TOPRIGHT",0,-30):OnClick(function (self)
		module.frame:Clear() 
		module.options.NoteEditBox.EditBox:SetText("")
	end) 

	self.buttoncopy = ELib:Button(self,L.messageButCopy):Size(655,20):Point("TOP",2,-30):OnClick(function (self)
		if not BlackNoteNow then
			return
		end
		VExRT.Note.Text1 = VExRT.Note.Black[BlackNoteNow] or ""
		module.frame:Save() 
		
		module.options.NotesList:SetListValue(1)
	end) 
	self.buttoncopy:Hide()
	
	local function AddTextToEditBox(self,text,mypos)
		local addedText = nil
		if not self then
			addedText = text
		else
			addedText = self.iconText
			if IsShiftKeyDown() then
				addedText = self.iconTextShift
			end
		end
		local txt = module.options.NoteEditBox.EditBox:GetText()
		local pos = module.options.NoteEditBox.EditBox:GetCursorPosition()
		if not self and mypos then
			pos = mypos
		end
		txt = string.sub (txt, 1 , pos) .. addedText .. string.sub (txt, pos+1)
		module.options.NoteEditBox.EditBox:SetText(txt)
		module.options.NoteEditBox.EditBox:SetCursorPosition(pos+string.len(addedText))
	end

	self.buttonicons = {}
	for i=1,8 do
		self.buttonicons[i] = CreateFrame("Button", nil,self)
		self.buttonicons[i]:SetSize(18,18)
		self.buttonicons[i]:SetPoint("TOPLEFT", 5+(i-1)*20,-55)
		self.buttonicons[i].back = self.buttonicons[i]:CreateTexture(nil, "BACKGROUND")
		self.buttonicons[i].back:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..i)
		self.buttonicons[i].back:SetAllPoints()
		self.buttonicons[i]:RegisterForClicks("LeftButtonDown")
		self.buttonicons[i].iconText = module.db.iconsLocalizatedNames[i]
		self.buttonicons[i]:SetScript("OnClick", AddTextToEditBox)
	end
	for i=1,11 do
		self.buttonicons[i] = CreateFrame("Button", nil,self)
		self.buttonicons[i]:SetSize(18,18)
		self.buttonicons[i]:SetPoint("TOPLEFT", 165+(i-1)*20,-55)
		self.buttonicons[i].back = self.buttonicons[i]:CreateTexture(nil, "BACKGROUND")
		self.buttonicons[i].back:SetTexture(module.db.otherIconsList[i][3])
		if module.db.otherIconsList[i][4] then
			self.buttonicons[i].back:SetTexCoord(unpack(module.db.otherIconsList[i],4,7))
		end
		self.buttonicons[i].back:SetAllPoints()
		self.buttonicons[i]:RegisterForClicks("LeftButtonDown")
		self.buttonicons[i].iconText = module.db.otherIconsList[i][1]
		self.buttonicons[i]:SetScript("OnClick", AddTextToEditBox)
	end
	
	self.OtherIconsButton = CreateFrame("Button", nil,self)
	self.OtherIconsButton:SetSize(120,18)
	self.OtherIconsButton:SetPoint("TOPLEFT",self.buttonicons[#self.buttonicons],"TOPRIGHT",5,0)
	self.OtherIconsButton:SetScript("OnClick",function (self)
		module.options.OtherIconsFrame:ShowClick()
	end)
	self.OtherIconsButton:SetScript("OnEnter",function (self)
		self.Text:SetShadowColor(0.2, 0.2, 0.2, 1)
	end)
	self.OtherIconsButton:SetScript("OnLeave",function (self)
		self.Text:SetShadowColor(0, 0, 0, 1)
	end)
	
	self.OtherIconsButton.Text = ELib:Text(self.OtherIconsButton,L.NoteOtherIcons,11):Size(self.OtherIconsButton:GetWidth(),18):Point(0,0):Color():Shadow()
	
	self.OtherIconsFrame = ELib:Popup(L.NoteOtherIcons):Size(250,225)
	self.OtherIconsFrame.ScrollFrame = ELib:ScrollFrame(self.OtherIconsFrame):Size(self.OtherIconsFrame:GetWidth()-10,self.OtherIconsFrame:GetHeight()-25):Point("TOP",0,-20):Height(500)
	self.OtherIconsFrame.ScrollFrame.backdrop:Hide()
	
	local function CreateOtherIcon(pointX,pointY,texture,iconText)
		local self = CreateFrame("Button", nil,self.OtherIconsFrame.ScrollFrame.C)
		self:SetSize(18,18)
		self:SetPoint("TOPLEFT",pointX,pointY)
		self.texture = self:CreateTexture(nil, "BACKGROUND")
		self.texture:SetTexture(texture)
		self.texture:SetAllPoints()
		self:RegisterForClicks("LeftButtonDown")
		self.iconText = iconText
		self:SetScript("OnClick", AddTextToEditBox)
		return self
	end
	
	for i=12,20 do
		local icon = CreateOtherIcon(5+(i-12)*20,-2,module.db.otherIconsList[i][3],module.db.otherIconsList[i][1])
		if module.db.otherIconsList[i][4] then
			icon.texture:SetTexCoord( unpack(module.db.otherIconsList[i],4,7) )
		end
	end
	do
		local line = 2
		local inLine = 0
		for i=1,#module.db.otherIconsAdditionalList do
			local spellID = module.db.otherIconsAdditionalList[i]
			if spellID == 0 then
				line = line + 1
				inLine = 0
			else
				local _,_,spellTexture = GetSpellInfo( spellID )
				
				CreateOtherIcon(5+inLine*20,-2-(line-1)*20,spellTexture,"{spell:"..spellID.."}")
				inLine = inLine + 1
				if inLine > 10 and (not module.db.otherIconsAdditionalList[i+1] or module.db.otherIconsAdditionalList[i+1]~=0) then
					line = line + 1
					inLine = 0
				end
			end
		end
		self.OtherIconsFrame.ScrollFrame:SetNewHeight( max(self.OtherIconsFrame:GetHeight()-40 , line * 20 + 4) )
	end
	
	self:SetScript("OnHide",function (self)
		self.OtherIconsFrame:Hide()
	end)
	
	self.dropDownColor = ELib:DropDown(self,170,10):Point(558,-55):Size(100):SetText(L.NoteColor)
	self.dropDownColor.list = {
		{L.NoteColorRed,"|cffff0000"},
		{L.NoteColorGreen,"|cff00ff00"},
		{L.NoteColorBlue,"|cff0000ff"},
		{L.NoteColorYellow,"|cffffff00"},
		{L.NoteColorPurple,"|cffff00ff"},
		{L.NoteColorAzure,"|cff00ffff"},
		{L.NoteColorBlack,"|cff000000"},
		{L.NoteColorGrey,"|cff808080"},
		{L.NoteColorRedSoft,"|cffee5555"},
		{L.NoteColorGreenSoft,"|cff55ee55"},
		{L.NoteColorBlueSoft,"|cff5555ee"},
	}
	local classNames = {"WARRIOR","PALADIN","HUNTER","ROGUE","PRIEST","DEATHKNIGHT","SHAMAN","MAGE","WARLOCK","MONK","DRUID"}
	for i,class in ipairs(classNames) do
		local colorTable = RAID_CLASS_COLORS[class]
		if colorTable then
			self.dropDownColor.list[#self.dropDownColor.list + 1] = {L.classLocalizate[class],"|c"..colorTable.colorStr}
		end
	end
	self.dropDownColor:SetScript("OnEnter",function (self)
		ELib.Tooltip.Show(self,"ANCHOR_LEFT",L.NoteColor,{L.NoteColorTooltip1,1,1,1,true},{L.NoteColorTooltip2,1,1,1,true})
	end)
	self.dropDownColor:SetScript("OnLeave",function ()
		ELib.Tooltip:Hide()
	end)
	function self.dropDownColor:SetValue(colorCode)
		ELib:DropDownClose()

		local selectedStart,selectedEnd = module.options.NoteEditBox.EditBox:GetTextHighlight()
		colorCode = string.gsub(colorCode,"|","||")
		if selectedStart == selectedEnd then
			AddTextToEditBox(nil,colorCode.."||r")
		else
			AddTextToEditBox(nil,"||r",selectedEnd)
			AddTextToEditBox(nil,colorCode,selectedStart)
		end
	end
	for i=1,#self.dropDownColor.list do
		local colorData = self.dropDownColor.list[i]
		self.dropDownColor.List[i] = {
			text = colorData[2]..colorData[1],
			func = self.dropDownColor.SetValue,
			justifyH = "CENTER",
			arg1 = colorData[2],
		}
	end
	self.dropDownColor.Lines = #self.dropDownColor.List

	local function RaidNamesOnEnter(self)
		self.html:SetShadowColor(0.2, 0.2, 0.2, 1)
	end
	local function RaidNamesOnLeave(self)
		self.html:SetShadowColor(0, 0, 0, 1)
	end
	self.raidnames = {}
	for i=1,30 do
		self.raidnames[i] = CreateFrame("Button", nil,self)
		self.raidnames[i]:SetSize(105,14)
		self.raidnames[i]:SetPoint("TOPLEFT", 5+math.floor((i-1)/5)*108,-80-14*((i-1)%5))

		self.raidnames[i].html = ELib:Text(self.raidnames[i],"",11):Color()
		self.raidnames[i].html:SetAllPoints()
		self.raidnames[i].txt = ""
		self.raidnames[i]:RegisterForClicks("LeftButtonDown")
		self.raidnames[i].iconText = ""
		self.raidnames[i]:SetScript("OnClick", AddTextToEditBox)

		self.raidnames[i]:SetScript("OnEnter", RaidNamesOnEnter)
		self.raidnames[i]:SetScript("OnLeave", RaidNamesOnLeave)
	end
	
	self.lastUpdate = ELib:Text(self,"",11):Size(600,20):Point("TOPLEFT",self.NotesList,"BOTTOMLEFT",3,-6):Top():Color()
	if VExRT.Note.LastUpdateName and VExRT.Note.LastUpdateTime then
		self.lastUpdate:SetText( L.NoteLastUpdate..": "..VExRT.Note.LastUpdateName.." ("..date("%H:%M:%S %d.%m.%Y",VExRT.Note.LastUpdateTime)..")" )
	end

	self.chkEnable = ELib:Check(self,L.senable,VExRT.Note.enabled):Point(5,-504):Tooltip('/rt note'):OnClick(function(self) 
		if self:GetChecked() then
			module:Enable()
		else
			module:Disable()
		end
	end)  
	
	self.chkFix = ELib:Check(self,L.messagebutfix,VExRT.Note.Fix):Point(225,-504):Tooltip(L.messagebutfixtooltip):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Note.Fix = true
			module.frame:SetMovable(false)
			module.frame:EnableMouse(false)
			module.frame.buttonResize:Hide()
			ExRT.lib.AddShadowComment(module.frame,1)
		else
			VExRT.Note.Fix = nil
			module.frame:SetMovable(true)
			module.frame:EnableMouse(true)
			module.frame.buttonResize:Show()
			ExRT.lib.AddShadowComment(module.frame,nil,L.message)
		end
	end) 
	
	self.ButtonToCenter = ELib:Button(self,L.MarksBarResetPos):Size(215,20):Point(445,-504):Tooltip(L.MarksBarResetPosTooltip):OnClick(function()
		VExRT.Note.Left = nil
		VExRT.Note.Top = nil

		module.frame:ClearAllPoints()
		module.frame:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
	end) 

	self.chkOnlyPromoted = ELib:Check(self,L.NoteOnlyPromoted,VExRT.Note.OnlyPromoted):Point(639,-480):Tooltip(L.NoteOnlyPromotedTooltip):Left():OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Note.OnlyPromoted = true
		else
			VExRT.Note.OnlyPromoted = nil
		end
	end)  
		
	self.chkOutline = ELib:Check(self,L.messageOutline,VExRT.Note.Outline):Point(445,-534):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Note.Outline = true
		else
			VExRT.Note.Outline = nil
		end
		module.frame:UpdateFont()
	end) 
	
	self.sliderFontSize = ELib:Slider(self,L.NoteFontSize):Size(210):Point(5,-539):Range(6,72):SetTo(VExRT.Note.FontSize or 12):OnChange(function(self,event) 
		event = event - event%1
		VExRT.Note.FontSize = event
		module.frame:UpdateFont()
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	
	local function DropDownFont_Click(_,arg)
		VExRT.Note.FontName = arg
		local FontNameForDropDown = arg:match("\\([^\\]*)$")
		module.options.dropDownFont:SetText(FontNameForDropDown or arg)
		ELib:DropDownClose()
		module.frame:UpdateFont()
	end

	self.dropDownFont = ELib:DropDown(self,350,10):Point(225,-534):Size(210)
	for i=1,#ExRT.F.fontList do
		self.dropDownFont.List[i] = {}
		local info = self.dropDownFont.List[i]
		info.text = ExRT.F.fontList[i]
		info.arg1 = ExRT.F.fontList[i]
		info.arg2 = i
		info.func = DropDownFont_Click
		info.font = ExRT.F.fontList[i]
		info.justifyH = "CENTER" 
	end
	if LibStub then
		local loaded,media = pcall(LibStub,"LibSharedMedia-3.0")
		if loaded and media then
			local fontList = media:HashTable("font")
			if fontList then
				local count = #self.dropDownFont.List
				for key,font in pairs(fontList) do
					count = count + 1
					self.dropDownFont.List[count] = {}
					local info = self.dropDownFont.List[count]
					
					info.text = font
					info.arg1 = font
					info.arg2 = count
					info.func = DropDownFont_Click
					info.font = font
					info.justifyH = "CENTER" 
				end
			end
		end
	end
	do
		local arg = VExRT.Note.FontName or ExRT.F.defFont
		local FontNameForDropDown = arg:match("\\([^\\]*)$")
		self.dropDownFont:SetText(FontNameForDropDown or arg)
	end
	
	self.slideralpha = ELib:Slider(self,L.messagebutalpha):Size(210):Point(5,-570):Range(0,100):SetTo(VExRT.Note.Alpha or 100):OnChange(function(self,event) 
		event = event - event%1
		VExRT.Note.Alpha = event
		module.frame:SetAlpha(event/100)
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	
	self.sliderscale = ELib:Slider(self,L.messagebutscale):Size(210):Point(225,-570):Range(5,200):SetTo(VExRT.Note.Scale or 100):OnChange(function(self,event) 
		event = event - event%1
		VExRT.Note.Scale = event
		ExRT.F.SetScaleFix(module.frame,event/100)
		self.tooltipText = event
		self:tooltipReload(self)
	end)

	self.slideralphaback = ELib:Slider(self,L.messageBackAlpha):Size(210):Point(445,-570):Range(0,100):SetTo(VExRT.Note.ScaleBack or 100):OnChange(function(self,event) 
		event = event - event%1
		VExRT.Note.ScaleBack = event
		module.frame.background:SetTexture(0, 0, 0, event/100)
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	
	self.chkOnlyInRaid = ELib:Check(self,L.MarksBarDisableInRaid,VExRT.Note.HideOutsideRaid):Point(5,-595):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Note.HideOutsideRaid = true
		else
			VExRT.Note.HideOutsideRaid = nil
		end
		module:Visibility()
	end) 
	
	self.chkHideInCombat = ELib:Check(self,L.NoteHideInCombat,VExRT.Note.HideInCombat):Point(225,-595):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Note.HideInCombat = true
			module:RegisterEvents('PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED')
		else
			VExRT.Note.HideInCombat = nil
			module:UnregisterEvents('PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED')
		end
		module:Visibility()
	end) 
	
	self.moreOptionsDropDown = ELib:DropDown(self,275,4):Point(445,-595):Size(215):SetText(LFG_LIST_MORE)
	
	local function moreOptionsDropDown_SetVaule(_,arg)
		VExRT.Note.Strata = arg
		ELib:DropDownClose()
		for i=1,#self.moreOptionsDropDown.List[1].subMenu do
			self.moreOptionsDropDown.List[1].subMenu[i].checkState = VExRT.Note.Strata == self.moreOptionsDropDown.List[1].subMenu[i].arg1
		end
		module.frame:SetFrameStrata(arg)
	end
	
	self.moreOptionsDropDown.List[1] = {text = L.NoteFrameStrata, subMenu = {}}
	for i=1,#frameStrataList do
		self.moreOptionsDropDown.List[1].subMenu[i] = {
			text = frameStrataList[i],
			checkState = VExRT.Note.Strata == frameStrataList[i],
			radio = true,
			arg1 = frameStrataList[i],
			func = moreOptionsDropDown_SetVaule,
		}
	end
	self.moreOptionsDropDown.List[2] = {
		text = L.NoteShowOnlyPersonal, 
		radio = true, 
		func = function()
			VExRT.Note.ShowOnlyPersonal = not VExRT.Note.ShowOnlyPersonal
			self.moreOptionsDropDown.List[2].checkState = VExRT.Note.ShowOnlyPersonal
			ELib:DropDownClose()
			module.frame:UpdateText()
		end,
		checkState = VExRT.Note.ShowOnlyPersonal,
	}
	self.moreOptionsDropDown.List[3] = {
		text = L.NoteShowOnlyInRaid, 
		radio = true, 
		func = function()
			VExRT.Note.ShowOnlyInRaid = not VExRT.Note.ShowOnlyInRaid
			self.moreOptionsDropDown.List[3].checkState = VExRT.Note.ShowOnlyInRaid
			ELib:DropDownClose()
			if VExRT.Note.ShowOnlyInRaid then
				module:RegisterEvents('ZONE_CHANGED_NEW_AREA')
			else
				module:UnregisterEvents('ZONE_CHANGED_NEW_AREA')
			end
			module:Visibility()
		end,
		checkState = VExRT.Note.ShowOnlyInRaid,
	}
	self.moreOptionsDropDown.List[4] = {text = L.minimapmenuclose, func = function()
		ELib:DropDownClose()
	end}
	
	if VExRT.Note.Text1 then 
		self.NoteEditBox.EditBox:SetText(VExRT.Note.Text1) 
	end

	module:RegisterEvents("GROUP_ROSTER_UPDATE")
	module.main:GROUP_ROSTER_UPDATE()
end


module.frame = CreateFrame("Frame",nil,UIParent)
module.frame:SetSize(200,100)
module.frame:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
module.frame:EnableMouse(true)
module.frame:SetMovable(true)
module.frame:RegisterForDrag("LeftButton")
module.frame:SetScript("OnDragStart", function(self)
	if self:IsMovable() then
		self:StartMoving()
	end
end)
module.frame:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
	VExRT.Note.Left = self:GetLeft()
	VExRT.Note.Top = self:GetTop()
end)
module.frame:SetFrameStrata("HIGH")
module.frame:SetResizable(true)
module.frame:SetMinResize(30, 30)
module.frame:SetScript("OnSizeChanged", function (self, width, height)
	local width_, height_ = self:GetSize()
	VExRT.Note.Width = width
	VExRT.Note.Height = height
	module.frame:UpdateText()
end)
module.frame:Hide() 

function module.frame:UpdateFont()
	local font = VExRT and VExRT.Note and VExRT.Note.FontName or ExRT.F.defFont
	local size = VExRT and VExRT.Note and VExRT.Note.FontSize or 12
	local outline = VExRT and VExRT.Note and VExRT.Note.Outline and "OUTLINE"
	self.text:SetFont(font,size,outline)
end

function module.frame:UpdateText()
	local selfText = VExRT.Note.SelfText or ""
	if VExRT.Note.ShowOnlyPersonal then
		self.text:SetText(txtWithIcons(selfText))
	else
		local text = VExRT.Note.Text1 or ""
		if text ~= "" and selfText ~= "" then 
			text = text .. "\n" 
		end
		self.text:SetText(txtWithIcons(text..selfText)) 
	end
end

module.frame.background = module.frame:CreateTexture(nil, "BACKGROUND")
module.frame.background:SetTexture(0, 0, 0, 1)
module.frame.background:SetAllPoints()

module.frame.text = module.frame:CreateFontString(nil,"ARTWORK")
module.frame.text:SetFont(ExRT.F.defFont, 12)
module.frame.text:SetPoint("TOPLEFT",5,-5)
module.frame.text:SetPoint("BOTTOMRIGHT",-5,5)
module.frame.text:SetJustifyH("LEFT")
module.frame.text:SetJustifyV("TOP")
module.frame.text:SetText(" ")

module.frame.buttonResize = CreateFrame("Frame",nil,module.frame)
module.frame.buttonResize:SetSize(15,15)
module.frame.buttonResize:SetPoint("BOTTOMRIGHT", 0, 0)
module.frame.buttonResize.back = module.frame.buttonResize:CreateTexture(nil, "BACKGROUND")
module.frame.buttonResize.back:SetTexture("Interface\\AddOns\\ExRT\\media\\Resize.tga")
module.frame.buttonResize.back:SetAllPoints()
module.frame.buttonResize:SetScript("OnMouseDown", function(self)
	module.frame:StartSizing()
end)
module.frame.buttonResize:SetScript("OnMouseUp", function(self)
	module.frame:StopMovingOrSizing()
end)


function module.frame:Save()
	VExRT.Note.Text1 = module.options.NoteEditBox.EditBox:GetText()
	if #VExRT.Note.Text1 == 0 then
		VExRT.Note.Text1 = " "
	end
	local txttosand = VExRT.Note.Text1
	local arrtosand = {}
	local j = 1
	local indextosnd = tostring(GetTime())..tostring(math.random(1000,9999))
	for i=1,#txttosand do
		if i%220 == 0 then
			arrtosand[j]=string.sub (txttosand, (j-1)*220+1, j*220)
			j = j + 1
		elseif i == #txttosand then
			arrtosand[j]=string.sub (txttosand, (j-1)*220+1)
			j = j + 1
		end
	end
	for i=1,#arrtosand do
		ExRT.F.SendExMsg("multiline",indextosnd.."\t"..arrtosand[i])
	end
end 

function module.frame:Clear() 
	module.options.NoteEditBox.EditBox:SetText("") 
end 

function module:addonMessage(sender, prefix, ...)
	if prefix == "multiline" then
		if VExRT.Note.OnlyPromoted and IsInRaid() and not ExRT.F.IsPlayerRLorOfficer(sender) then
			return
		end
	
		VExRT.Note.LastUpdateName = sender
		VExRT.Note.LastUpdateTime = time()
	
		local msgnowindex,lastnowtext = ...
		if tostring(msgnowindex) == tostring(module.db.msgindex) then
			module.db.lasttext = module.db.lasttext .. lastnowtext
		else
			module.db.lasttext = lastnowtext
		end
		module.db.msgindex = msgnowindex
		VExRT.Note.Text1 = module.db.lasttext
		module.frame:UpdateText()
		if module.options.NoteEditBox then
			if module.options.IsMainNoteNow then
				module.options.NoteEditBox.EditBox:SetText(VExRT.Note.Text1)
			end
			
			module.options.lastUpdate:SetText( L.NoteLastUpdate..": "..VExRT.Note.LastUpdateName.." ("..date("%H:%M:%S %d.%m.%Y",VExRT.Note.LastUpdateTime)..")" )
		end
	end 
end 

local gruevent = {}

function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.Note = VExRT.Note or {}
	VExRT.Note.Black = VExRT.Note.Black or {}

	if VExRT.Note.Left and VExRT.Note.Top then 
		module.frame:ClearAllPoints()
		module.frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.Note.Left,VExRT.Note.Top)
	end
	
	VExRT.Note.FontSize = VExRT.Note.FontSize or 12

	if VExRT.Note.Width then 
		module.frame:SetWidth(VExRT.Note.Width) 
	end
	if VExRT.Note.Height then 
		module.frame:SetHeight(VExRT.Note.Height) 
	end

	if VExRT.Note.enabled then 
		module:Enable()
	end

	if VExRT.Note.Text1 then 
		module.frame:UpdateText()
	end
	if VExRT.Note.Alpha then 
		module.frame:SetAlpha(VExRT.Note.Alpha/100) 
	end
	if VExRT.Note.Scale then 
		module.frame:SetScale(VExRT.Note.Scale/100) 
	end
	if VExRT.Note.ScaleBack then
		module.frame.background:SetTexture(0, 0, 0, VExRT.Note.ScaleBack/100)
	end
	if VExRT.Note.Outline then
		module.frame.text:SetFont(ExRT.F.defFont, 12,"OUTLINE")
	end
	if VExRT.Note.Fix then
		module.frame:SetMovable(false)
		module.frame:EnableMouse(false)
		module.frame.buttonResize:Hide()
	else
		ExRT.lib.AddShadowComment(module.frame,nil,L.message)
	end
	
	if VExRT.Addon.Version < 3225 then
		for i=1,12 do
			if not VExRT.Note.Black[i] then
				for j=i,12 do
					VExRT.Note.Black[j] = VExRT.Note.Black[j+1]
				end
			end
		end
	end
	VExRT.Note.BlackNames = VExRT.Note.BlackNames or {}
	
	for i=1,3 do
		VExRT.Note.Black[i] = VExRT.Note.Black[i] or ""
	end
	
	VExRT.Note.Strata = VExRT.Note.Strata or "HIGH"
	
	module:RegisterAddonMessage()
	module:RegisterSlash()
	
	module.frame:UpdateFont()
	module.frame:SetFrameStrata(VExRT.Note.Strata)
end


function module:Enable()
	VExRT.Note.enabled = true
	if module.options.chkEnable then
		module.options.chkEnable:SetChecked(true)
	end
	if VExRT.Note.HideOutsideRaid then
		module:RegisterEvents("GROUP_ROSTER_UPDATE")
	end
	if VExRT.Note.HideInCombat then
		module:RegisterEvents('PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED')
	end
	if VExRT.Note.ShowOnlyInRaid then
		module:RegisterEvents('ZONE_CHANGED_NEW_AREA')
	end
	module:Visibility()
end

function module:Disable()
	VExRT.Note.enabled = nil
	if module.options.chkEnable then
		module.options.chkEnable:SetChecked(false)
	end
	module:UnregisterEvents('PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED','ZONE_CHANGED_NEW_AREA')
	module:Visibility()
end

local Note_CombatState = false

function module:Visibility()
	local bool = true
	if not VExRT.Note.enabled then
		bool = bool and false
	end
	if bool and VExRT.Note.HideOutsideRaid then
		if GetNumGroupMembers() > 0 then
			bool = bool and true
		else
			bool = bool and false
		end
	end
	if bool and VExRT.Note.HideInCombat then
		if Note_CombatState then
			bool = bool and false
		else
			bool = bool and true
		end
	end
	if bool and VExRT.Note.ShowOnlyInRaid then
		local _,zoneType = IsInInstance()
		if zoneType == "raid" then
			bool = bool and true
		else
			bool = bool and false
		end
	end

	if bool then
		module.frame:Show()
	else
		module.frame:Hide()
	end
end

function module.main:GROUP_ROSTER_UPDATE()
	C_Timer.After(1, module.Visibility)
	if not module.options.raidnames then
		return
	end	
	local n = GetNumGroupMembers() or 0
	local gMax = ExRT.F.GetRaidDiffMaxGroup()
	for i=1,8 do gruevent[i] = 0 end
	for i=1,n do
		local name,_,subgroup,_,_,class = GetRaidRosterInfo(i)
		if name and subgroup <= gMax and gruevent[subgroup] then
			gruevent[subgroup] = gruevent[subgroup] + 1
			local cR,cG,cB = ExRT.F.classColorNum(class)

			local POS = gruevent[subgroup] + (subgroup - 1) * 5
			local obj = module.options.raidnames[POS]
			
			if obj then
				name = ExRT.F.delUnitNameServer(name)
				local colorCode = ExRT.F.classColor(class)
				obj.iconText = "||c"..colorCode..name.."||r "
				obj.iconTextShift = name
				obj.html:SetText(name)
				obj.html:SetTextColor(cR, cG, cB, 1)
			end
		end
	end
	for i=1,6 do
		for j=(gruevent[i]+1),5 do
			local frame = module.options.raidnames[(i-1)*5+j]
			frame.iconText = ""
			frame.iconTextShift = ""
			frame.html:SetText("")
		end
	end
end 
function module.main:PLAYER_REGEN_DISABLED()
	Note_CombatState = true
	module:Visibility()
end
function module.main:PLAYER_REGEN_ENABLED()
	Note_CombatState = false
	module:Visibility()
end

function module.main:ZONE_CHANGED_NEW_AREA()
	C_Timer.After(5, module.Visibility)
end

function module:slash(arg)
	if arg == "note" then
		if VExRT.Note.enabled then 
			module:Disable()
		else
			module:Enable()
		end
	elseif arg == "editnote" or arg == "edit note" then
		ExRT.Options:Open(module.options)
	end
end