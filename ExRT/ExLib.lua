-- ExRT.lib.AddShadowComment(self,hide,moduleName,userComment,userFontSize,userOutline)
-- ExRT.lib.AdditionalTooltip(link)
-- ExRT.lib.CreateBackTextureForDebug(parent)
-- ExRT.lib.CreateShadow(parent,size,edgeSize)
-- ExRT.lib.EditBoxOnEnterHyperLinkTooltip(self,linkData,link)
-- ExRT.lib.EditBoxOnLeaveHyperLinkTooltip(self)
-- ExRT.lib.HideAdditionalTooltips()
-- ExRT.lib.CreateHoverHighlight(parent)
-- ExRT.lib.OnEnterHyperLinkTooltip(self,data)
-- ExRT.lib.OnEnterTooltip(self,anchorUser)
-- ExRT.lib.OnLeaveHyperLinkTooltip(self)
-- ExRT.lib.OnLeaveTooltip(self)
-- ExRT.lib.SetAlphas(alpha,...)
-- ExRT.lib.SetPoint(self,...)
-- ExRT.lib.ShowOrHide(self,bool)
-- ExRT.lib.TooltipShow(self,anchorUser,title,...)
-- ExRT.lib.TooltipHide()
--
-- ExRT.lib.CreateButton(parent,width,height,relativePoint,x,y,text,isDisabled,tooltip,template)						"ExRTButtonModernTemplate"
-- ExRT.lib.CreateCheckBox(parent,relativePoint,x,y,text,checked,tooltip,textLeft,template)							"ExRTCheckButtonModernTemplate"
-- ExRT.lib.CreateColorPickButton(parent,width,height,relativePoint,x,y,cR,cG,cB,cA)
-- ExRT.lib.CreateDropDown(parent,relativePoint,x,y,width,defText)
-- ExRT.lib.CreateEditBox(parent,width,height,relativePoint,x,y,tooltip,maxLetters,onlyNum,doNotUseTemplate,defText)				"ExRTInputBoxModernTemplate"
-- ExRT.lib.CreateGraph(parent,width,height,relativePoint,x,y)
-- ExRT.lib.CreateHelpButton(parent,helpPlateArray,isTab)
-- ExRT.lib.CreateHiddenFrame(parent,relativePoint,x,y,width,height)
-- ExRT.lib.CreateIcon(parent,size,relativePoint,x,y,textureIcon,isButton)
-- ExRT.lib.CreateListFrame(parent,width,buttonsNum,buttonPos,relativePoint,x,y,buttonText,listClickFunc,isModern)
-- ExRT.lib.CreateMultiEditBox(parent,width,height,relativePoint,x,y)
-- ExRT.lib.CreateMultilineEditBox(parent,width,height,relativePoint,x,y,isModern)
-- ExRT.lib.CreateOneTab(parent,width,height,relativePoint,x,y,text,isModern)
-- ExRT.lib.CreatePopupFrame(width,height,title,isModern)
-- ExRT.lib.CreateRadioButton(parent,relativePoint,x,y,text,checked,isModern)
-- ExRT.lib.CreateScrollBar(parent,width,height,x,y,minVal,maxVal,relativePoint)
-- ExRT.lib.CreateScrollBarModern(parent,width,height,x,y,minVal,maxVal,relativePoint)
-- ExRT.lib.CreateScrollCheckList(parent,relativePoint,x,y,width,linesNum,isModern)
-- ExRT.lib.CreateScrollDropDown(parent,relativePoint,x,y,width,dropDownWidth,lines,defText,tooltip)						"ExRTDropDownMenuModernTemplate"
-- ExRT.lib.CreateScrollFrame(parent,width,height,relativePoint,x,y,verticalHeight,isModern)
-- ExRT.lib.CreateScrollList(parent,relativePoint,x,y,width,linesNum,isModern)
-- ExRT.lib.CreateScrollTabsFrame(parent,relativePoint,x,y,width,height,noSelfBorder,isModern,...)
-- ExRT.lib.CreateSlider(parent,width,height,x,y,minVal,maxVal,text,defVal,relativePoint,isVertical,isModern)
-- ExRT.lib.CreateSliderBox(parent,width,height,x,y,list,selected)
-- ExRT.lib.CreateTabFrame(parent,width,height,x,y,tabNum,activeTabNum,...)
-- ExRT.lib.CreateTabFrameTemplate(parent,width,height,x,y,template,tabNum,activeTabNum,...)
-- ExRT.lib.CreateText(parent,width,height,relativePoint,x,y,hor,ver,font,fontSize,text,tem,colR,colG,colB,shadow,outline,doNotUseTemplate)

local GlobalAddonName, ExRT = ...

ExRT.lib = {}

local GlobalIndexNow = 0
local function GetNextGlobalName()
	GlobalIndexNow = GlobalIndexNow + 1
	return "GExRTUIGlobal"..tostring(GlobalIndexNow)
end

function ExRT.lib.AddShadowComment(self,hide,moduleName,userComment,userFontSize,userOutline)
	if self.moduleNameString then
		if hide then
			self.moduleNameString:Hide()
		else
			local selfWidth = self:GetWidth()
			local selfHeight = self:GetHeight()
			self.moduleNameString:SetSize(selfWidth,selfHeight)
			self.moduleNameString:Show()
		end
	elseif not hide and moduleName then
		local selfWidth = self:GetWidth()
		local selfHeight = self:GetHeight()
		self.moduleNameString = ExRT.lib.CreateText(self,selfWidth,selfHeight,"BOTTOMRIGHT", -5, 4,"RIGHT","BOTTOM",ExRT.mds.defFont, 18,moduleName or "",nil)
		self.moduleNameString:SetTextColor(1, 1, 1, 0.8)
	end

	if self.userCommentString then
		if hide then
			self.userCommentString:Hide()
		else
			local selfWidth = self:GetWidth()
			local selfHeight = self:GetHeight()
			self.userCommentString:SetSize(selfWidth,selfHeight)
			self.userCommentString:Show()
		end
	elseif not hide and userComment then
		local selfWidth = self:GetWidth()
		local selfHeight = self:GetHeight()
		self.userCommentString = ExRT.lib.CreateText(self,selfWidth,selfHeight,"BOTTOMRIGHT", -5, 20,"RIGHT","BOTTOM",ExRT.mds.defFont, userFontSize or 18,userComment or "",nil,0,0,0,nil,userOutline)
		self.userCommentString:SetTextColor(0, 0, 0, 0.7)
	end
end

function ExRT.lib.CreateShadow(parent,size,edgeSize)
	local self = CreateFrame("Frame",nil,parent)
	self:SetPoint("LEFT",-size,0)
	self:SetPoint("RIGHT",size,0)
	self:SetPoint("TOP",0,size)
	self:SetPoint("BOTTOM",0,-size)
	self:SetBackdrop({edgeFile="Interface/AddOns/ExRT/media/shadow.tga",edgeSize=edgeSize or 28,insets={left=size,right=size,top=size,bottom=size}})
	self:SetBackdropBorderColor(0,0,0,.45)

	return self
end

do
	local function SliderOnMouseWheel(self,delta)
		if tonumber(self:GetValue()) == nil then 
			return 
		end
		if self.isVertical then
			delta = -delta
		end
		self:SetValue(tonumber(self:GetValue())+delta)
	end
	local function SliderTooltipShow(self)
		local text = self.text:GetText()
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self.tooltipText or "")
		GameTooltip:AddLine(text or "",1,1,1)
		GameTooltip:Show()
	end
	local function SliderTooltipReload(self)
		if GameTooltip:IsVisible() then
			self:tooltipHide()
			self:tooltipShow()
		end
	end
	function ExRT.lib.CreateSlider(parent,width,height,x,y,minVal,maxVal,text,defVal,relativePoint,isVertical,isModern)
		defVal = defVal or maxVal
	
		local self = CreateFrame("Slider",nil,parent,isModern and (isVertical and "ExRTSliderModernVerticalTemplate" or "ExRTSliderModernTemplate")or "ExRTSliderTemplate")
		self:SetWidth(width)
		if not isModern then
			self:SetHeight(height)
		end
		self:SetPoint(relativePoint or "TOPLEFT",parent, x, y)
		self.textLow = self.Low
		self.textHigh = self.High
		self.text = self.Text
		if isVertical then
			self.textLow:Hide()
			self.textHigh:Hide()
			self.text:Hide()
			
			self.isVertical = true
		end
		self:SetOrientation(isVertical and "VERTICAL" or "HORIZONTAL")
		self:SetMinMaxValues(minVal, maxVal)
		self.minValue, self.maxValue = self:GetMinMaxValues() 
		self.textLow:SetText(self.minValue)
		self.textHigh:SetText(self.maxValue)
		self.text:SetText(text)
		if isModern then
			self.text:SetFont(self.text:GetFont(),10)
			self.textLow:SetFont(self.textLow:GetFont(),10)
			self.textHigh:SetFont(self.textHigh:GetFont(),10)
		end
		self.tooltipText = defVal
		self:SetValueStep(1)
		self:SetValue(defVal)
	
		self:SetScript("OnMouseWheel", SliderOnMouseWheel)

		self.tooltipShow = SliderTooltipShow
		self.tooltipHide = GameTooltip_Hide
		self.tooltipReload = SliderTooltipReload
		self:SetScript("OnEnter", self.tooltipShow)
		self:SetScript("OnLeave", self.tooltipHide)
		
		self.SetNewPoint = ExRT.lib.SetPoint
		
		--sliderFrame:SetObeyStepOnDrag(true)
	
		return self
	end
end

do
	local function ScrollBarButtonUpClick(self)
		local scrollBar = self:GetParent()
		local min,max = scrollBar:GetMinMaxValues()
		local val = scrollBar:GetValue()
		if (val - scrollBar.clickRange) < min then
			scrollBar:SetValue(min)
		else
			scrollBar:SetValue(val - scrollBar.clickRange)
		end
	end
	local function ScrollBarButtonDownClick(self)
		local scrollBar = self:GetParent()
		local min,max = scrollBar:GetMinMaxValues()
		local val = scrollBar:GetValue()
		if (val + scrollBar.clickRange) > max then
			scrollBar:SetValue(max)
		else
			scrollBar:SetValue(val + scrollBar.clickRange)
		end
	end
	local function ScrollBarButtonsState(self,UP,DOWN)
		self.buttonUP:SetEnabled(UP)
		self.buttonDown:SetEnabled(DOWN)
	end
	local function ScrollBarButtonsReState(self)
		local value = ExRT.mds.Round(self:GetValue())
		local min,max = self:GetMinMaxValues()
		if max == min then
			self:buttonsState(nil,nil)
		elseif value == min then
			self:buttonsState(nil,true)
		elseif value == max then
			self:buttonsState(true,nil)
		else
			self:buttonsState(true,true)
		end
	end
	function ExRT.lib.CreateScrollBar(parent,width,height,x,y,minVal,maxVal,relativePoint,clickRange)
		local self = CreateFrame("Slider", nil, parent)
		self.bg = self:CreateTexture(nil, "BACKGROUND")
		self.bg:SetAllPoints(true)
		self.bg:SetTexture(0, 0, 0, 0.5)
		self.thumb = self:CreateTexture(nil, "OVERLAY")
		self.thumb:SetTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
		self.thumb:SetSize(25, 25)
		self:SetThumbTexture(self.thumb)
		self:SetOrientation("VERTICAL")
		self:SetSize(width, height - 32)
		self:SetPoint(relativePoint or "TOPLEFT", parent, x, y - 16)
		self:SetMinMaxValues(minVal, maxVal)
		self:SetValue(minVal)
		
		self.buttonUP = CreateFrame("Button",nil,self,"UIPanelScrollUPButtonTemplate")
		self.buttonUP:SetSize(16,16)
		self.buttonUP:SetPoint("BOTTOM",self,"TOP",0,0) 
		self.buttonUP:SetScript("OnClick",ScrollBarButtonUpClick)
	
		self.buttonDown = CreateFrame("Button",nil,self,"UIPanelScrollDownButtonTemplate")
		self.buttonDown:SetPoint("TOP",self,"BOTTOM",0,0) 
		self.buttonDown:SetSize(16,16)
		self.buttonDown:SetScript("OnClick",ScrollBarButtonDownClick)
		
		self.clickRange = clickRange or 1
		
		self.buttonsState = ScrollBarButtonsState
		self.ReButtonsState = ScrollBarButtonsReState
		
		return self
	end
	
	function ExRT.lib.CreateScrollBarModern(parent,width,height,x,y,minVal,maxVal,relativePoint,clickRange)
		local self = CreateFrame("Slider", nil, parent)
		self.bg = self:CreateTexture(nil, "BACKGROUND")
		self.bg:SetAllPoints(true)
		self.bg:SetTexture(0, 0, 0, 0.3)
		self.thumb = self:CreateTexture(nil, "OVERLAY")
		self.thumb:SetTexture(0.44,0.45,0.50,.7)
		self.thumb:SetSize(14,30)
		self:SetThumbTexture(self.thumb)
		self:SetOrientation("VERTICAL")
		self:SetSize(width, height - 32 - 4)
		self:SetPoint(relativePoint or "TOPLEFT", parent, x, y - 16 - 2)
		self:SetMinMaxValues(minVal, maxVal)
		self:SetValue(minVal)
		
		self.borderLeft = self:CreateTexture(nil, "BACKGROUND")
		self.borderLeft:SetPoint("TOPLEFT",-1,2)
		self.borderLeft:SetSize(1,height - 32)
		self.borderLeft:SetTexture(0.24,0.25,0.30,1)
		
		self.borderRight = self:CreateTexture(nil, "BACKGROUND")
		self.borderRight:SetPoint("TOPRIGHT",1,2)
		self.borderRight:SetSize(1,height - 32)
		self.borderRight:SetTexture(0.24,0.25,0.30,1)
		
		self.buttonUP = CreateFrame("Button",nil,self,"ExRTButtonUpModernTemplate")
		self.buttonUP:SetSize(16,16)
		self.buttonUP:SetPoint("BOTTOM",self,"TOP",0,2) 
		self.buttonUP:SetScript("OnClick",ScrollBarButtonUpClick)
	
		self.buttonDown = CreateFrame("Button",nil,self,"ExRTButtonDownModernTemplate")
		self.buttonDown:SetPoint("TOP",self,"BOTTOM",0,-2) 
		self.buttonDown:SetSize(16,16)
		self.buttonDown:SetScript("OnClick",ScrollBarButtonDownClick)
		
		self.clickRange = clickRange or 1
		
		self.buttonsState = ScrollBarButtonsState
		self.ReButtonsState = ScrollBarButtonsReState
		
		return self
	end
end

function ExRT.lib.OnEnterTooltip(self,anchorUser)
	GameTooltip:SetOwner(self,anchorUser or "ANCHOR_RIGHT")
	GameTooltip:SetText(self.tooltipText or "", nil, nil, nil, nil, true)
	GameTooltip:Show()
end

function ExRT.lib.OnLeaveTooltip(self)
	GameTooltip_Hide()
end

function ExRT.lib.TooltipShow(self,anchorUser,title,...)
	if title then
		local x,y=0,0
		if type(anchorUser) == "table" then
			x = anchorUser[2]
			y = anchorUser[3]
			anchorUser = anchorUser[1] or "ANCHOR_RIGHT"
		elseif not anchorUser then
			anchorUser = "ANCHOR_RIGHT"
		end
		GameTooltip:SetOwner(self,anchorUser or "ANCHOR_RIGHT",x,y)
		GameTooltip:SetText(title)
		for i=1,select("#", ...) do
			local line = select(i, ...)
			if type(line) == "table" then
				if not line.right then
					if line[1] then
						GameTooltip:AddLine(unpack(line))
					end
				else
					GameTooltip:AddDoubleLine(line[1], line.right, line[2],line[3],line[4], line[2],line[3],line[4])
				end
			else
				GameTooltip:AddLine(line)
			end
		end
		GameTooltip:Show()
	end
end

function ExRT.lib.TooltipHide()
	GameTooltip_Hide()
end

function ExRT.lib.OnEnterHyperLinkTooltip(self,data,...)
	if not data then 
		return 
	end
	local x = self:GetRight()
	if x >= ( GetScreenWidth() / 2 ) then
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	else
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	end
	GameTooltip:SetHyperlink(data,...)
	GameTooltip:Show()
end

function ExRT.lib.OnLeaveHyperLinkTooltip(self)
	GameTooltip_Hide()
end

function ExRT.lib.EditBoxOnEnterHyperLinkTooltip(self,linkData,link)
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	GameTooltip:SetHyperlink(linkData)
	GameTooltip:Show()
end

function ExRT.lib.EditBoxOnLeaveHyperLinkTooltip(self)
	GameTooltip_Hide()
end

function ExRT.lib.EditBoxOnClickHyperLinkTooltip(self,linkData,link,button)
	ExRT.mds.LinkItem(nil,link)
end

do
	local additionalTooltips = {}
	local additionalTooltipBackdrop = {bgFile="Interface/Buttons/WHITE8X8",edgeFile="Interface/Tooltips/UI-Tooltip-Border",tile=false,edgeSize=14,insets={left=2.5,right=2.5,top=2.5,bottom=2.5}}
	local function CreateAdditionalTooltip()
		local new = #additionalTooltips + 1
		local tip = CreateFrame("GameTooltip", "ExRTlibAdditionalTooltip"..new, UIParent, "GameTooltipTemplate")
		additionalTooltips[new] = tip
		
		tip:SetScript("OnLoad",nil)
		tip:SetScript("OnHide",nil)
	
		tip:SetBackdrop(additionalTooltipBackdrop)
		tip:SetBackdropColor(0,0,0,1)
		tip:SetBackdropBorderColor(0.3,0.3,0.4,1)
		
		tip.gradientTexture = tip:CreateTexture()
		tip.gradientTexture:SetTexture(1,1,1,1)
		tip.gradientTexture:SetGradientAlpha("VERTICAL",0,0,0,0,.8,.8,.8,.2)
		tip.gradientTexture:SetPoint("TOPLEFT",2.5,-2.5)
		tip.gradientTexture:SetPoint("BOTTOMRIGHT",-2.5,2.5)
		
		tip:Hide()
		
		return new
	end
	function ExRT.lib.AdditionalTooltip(link,data,enableMultiline)
		local tooltipID = nil
		for i=1,#additionalTooltips do
			if not additionalTooltips[i]:IsShown() then
				tooltipID = i
				break
			end
		end
		if not tooltipID then
			tooltipID = CreateAdditionalTooltip()
		end
		local tooltip = additionalTooltips[tooltipID]
		local owner = nil
		if tooltipID == 1 then
			owner = GameTooltip
		else
			owner = additionalTooltips[tooltipID - 1]
		end
		tooltip:SetOwner(owner, "ANCHOR_NONE")
		if link then
			tooltip:SetHyperlink(link)
		else
			for i=1,#data do
				tooltip:AddLine(data[i], nil, nil, nil, enableMultiline and true)
			end
		end
		tooltip:ClearAllPoints()
		local isTop = false
		if tooltipID > 1 then
			local ownerPoint = owner:GetPoint()
			if ownerPoint == "BOTTOMRIGHT" then
				isTop = true
			end
		end
		if not isTop then
			tooltip:SetPoint("TOPRIGHT",owner,"BOTTOMRIGHT",0,0)
		else
			tooltip:SetPoint("BOTTOMRIGHT",owner,"TOPRIGHT",0,0)
		end
		tooltip:Show()
		if not isTop and tooltip:GetBottom() < 1 then
			owner = nil
			for i=1,(tooltipID-1) do
				local point = additionalTooltips[i]:GetPoint()
				if point ~= "TOPRIGHT" then
					owner = additionalTooltips[i]
				end
			end
			owner = owner or GameTooltip
			tooltip:ClearAllPoints()
			tooltip:SetPoint("BOTTOMRIGHT",owner,"TOPRIGHT",0,0)
		end
	end
	function ExRT.lib.HideAdditionalTooltips()
		for i=1,#additionalTooltips do
			additionalTooltips[i]:Hide()
			additionalTooltips[i]:ClearLines()
		end
	end
end

function ExRT.lib.ShowOrHide(self,bool)
	if not self then return end
	if bool then
		self:Show()
	else
		self:Hide()
	end
end

function ExRT.lib.SetAlphas(alpha,...)
	for i=1,select("#", ...) do
		local self = select(i, ...)
		self:SetAlpha(alpha)
	end
end

do
	local function TabFrame_DeselectTab(self)
		self.Left:Show()
		self.Middle:Show()
		self.Right:Show()

		self:Enable()
		local offsetX = self.Icon and 8 or 0
		self.Text:SetPoint("CENTER", self, "CENTER", offsetX, -3)
		
		self.LeftDisabled:Hide()
		self.MiddleDisabled:Hide()
		self.RightDisabled:Hide()
		
		self.ButtonState = false
	end
	--PanelTemplates_SelectTab
	local function TabFrame_SelectTab(self)
		self.Left:Hide()
		self.Middle:Hide()
		self.Right:Hide()

		self:Disable()
		local offsetX = self.Icon and 8 or 0
		--self:SetDisabledFontObject(GameFontHighlightSmall)
		self.Text:SetPoint("CENTER", self, "CENTER", offsetX, -2)
		
		self.LeftDisabled:Show()
		self.MiddleDisabled:Show()
		self.RightDisabled:Show()
		
		self.ButtonState = true
	end
	--PanelTemplates_DeselectTab
	local function TabFrame_ResizeTab(self, padding, absoluteSize, minWidth, maxWidth, absoluteTextSize)	
		local buttonMiddle = self.Middle
		local buttonMiddleDisabled = self.MiddleDisabled
		
		if self.Icon then
			if maxWidth then
				maxWidth = maxWidth + 18
			end
			if absoluteTextSize then
				absoluteTextSize = absoluteTextSize + 18
			end
		end
		
		local sideWidths = 2 * self.Left:GetWidth()
		local tabText = self.Text
		local width, tabWidth
		local textWidth
		if ( absoluteTextSize ) then
			textWidth = absoluteTextSize
		else
			tabText:SetWidth(0)
			textWidth = tabText:GetWidth()
		end
		-- If there's an absolute size specified then use it
		if ( absoluteSize ) then
			if ( absoluteSize < sideWidths) then
				width = 1
				tabWidth = sideWidths
			else
				width = absoluteSize - sideWidths
				tabWidth = absoluteSize
			end
			tabText:SetWidth(width)
		else
			-- Otherwise try to use padding
			if ( padding ) then
				width = textWidth + padding
			else
				width = textWidth + 24
			end
			-- If greater than the maxWidth then cap it
			if ( maxWidth and width > maxWidth ) then
				if ( padding ) then
					width = maxWidth + padding
				else
					width = maxWidth + 24
				end
				tabText:SetWidth(width)
			else
				tabText:SetWidth(0)
			end
			if (minWidth and width < minWidth) then
				width = minWidth
			end
			tabWidth = width + sideWidths
		end
		
		do
			local offsetX = self.Icon and 18 or 0
			local offsetY = self.ButtonState and -2 or -3
			self.Text:SetPoint("CENTER", self, "CENTER", offsetX, offsetY)
		end
		
		if ( buttonMiddle ) then
			buttonMiddle:SetWidth(width)
		end
		if ( buttonMiddleDisabled ) then
			buttonMiddleDisabled:SetWidth(width)
		end
		
		self:SetWidth(tabWidth)
		local highlightTexture = self.HighlightTexture
		if ( highlightTexture ) then
			highlightTexture:SetWidth(tabWidth)
		end
	end
	--PanelTemplates_TabResize
	local function TabFrame_SetTabIcon(self,icon)
		if not icon then
			self.Icon = nil
			if self.icon then
				self.icon:Hide()
			end
			self:Resize(0, nil, nil, self:GetFontString():GetStringWidth(), self:GetFontString():GetStringWidth())
			return
		end
		if not self.icon then
			self.icon = self:CreateTexture(nil,"BACKGROUND")
			self.icon:SetSize(16,16)
			self.icon:SetPoint("LEFT",12,-3)
		end
		self.Icon = icon
		self.icon:SetTexture(icon)
		self.icon:Show()
		self:Resize(0, nil, nil, self:GetFontString():GetStringWidth(), self:GetFontString():GetStringWidth())
	end
	local function TabFrameUpdateTabs(self)
		for i=1,self.tabCount do
			if i == self.selected then
				TabFrame_SelectTab(self.tabs[i].button)
			else
				TabFrame_DeselectTab(self.tabs[i].button)
			end
			self.tabs[i]:Hide()
			
			if self.tabs[i].disabled then
				PanelTemplates_SetDisabledTabState(self.tabs[i].button)
			end
		end
		if self.selected and self.tabs[self.selected] then
			self.tabs[self.selected]:Show()
		end
		if self.navigation then
			if self.disabled then
				self.navigation:SetEnabled(nil)
			else
				self.navigation:SetEnabled(true)
			end
		end
	end
	local function TabFrameButtonClick(self)
		local tabFrame = self.mainFrame
		tabFrame.selected = self.id
		tabFrame.UpdateTabs(tabFrame)
		
		if tabFrame.buttonAdditionalFunc then
			tabFrame:buttonAdditionalFunc()
		end
		if self.additionalFunc then
			self:additionalFunc()
		end
	end
	local function TabFrameSelectTab(self,ID)
		self.selected = ID
		self:UpdateTabs()
	end
	local function TabFrameButtonOnEnter(self)
		if self.tooltip and self.tooltip ~= "" then
			ExRT.lib.TooltipShow(self,nil,self:GetText(),{self.tooltip,1,1,1})
		end
	end
	local function TabFrameButtonOnLeave(self)
		GameTooltip_Hide()
	end
	local function TabFrameToggleNavigation(self)
		local parent = self.parent
		local dropDownList = {}
		for i=self.max + 1,#parent.tabs do
			dropDownList[#dropDownList+1] = {
				text = parent.tabs[i].button:GetText(),
				notCheckable = true,
				func = function ()
					TabFrameButtonClick(parent.tabs[i].button)
				end
			}
		end
		dropDownList[#dropDownList + 1] = {
			text = ExRT.L.BossWatcherSelectFightClose,
			notCheckable = true,
			func = function() 
				CloseDropDownMenus() 
			end,
		}
		EasyMenu(dropDownList, self.dropDown, "cursor", 10 , -15, "MENU")
	end	
	local function TabFrameCreateNavigation(self,maxButtons)
		if self.navigation then
			return
		end
		self.navigation = CreateFrame("Button", nil, self, "ExRTUIChatDownButtonTemplate")
		self.navigation:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -15, -3)
		self.navigation:SetScript("OnClick",TabFrameToggleNavigation)
		self.navigation:SetScript("OnEnter",function (self)
			ExRT.lib.TooltipShow(self,nil,ExRT.L.SetAdditionalTabs)
		end)
		self.navigation:SetScript("OnLeave",GameTooltip_Hide)
		self.navigation.parent = self
		self.navigation.max = maxButtons
		self.navigation.dropDown = CreateFrame("Frame", GetNextGlobalName(), nil, "UIDropDownMenuTemplate")
	end
	function ExRT.lib.CreateTabFrameTemplate(parent,width,height,x,y,template,tabNum,activeTabNum,...)
		local self = CreateFrame("Frame",nil,parent)
		self:SetSize(width,height)
		self:SetBackdrop({bgFile = "Interface/DialogFrame/UI-DialogBox-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border",tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }})
		self:SetBackdropColor(0,0,0,0.5)
		self:SetPoint("TOPLEFT",x,y)
		
		self.resizeFunc = TabFrame_ResizeTab
		self.selectFunc = TabFrame_SelectTab
		self.deselectFunc = TabFrame_DeselectTab
		
		self.tabs = {}
		for i=1,tabNum do
			self.tabs[i] = CreateFrame("Frame",nil,self)
			self.tabs[i]:SetSize(width,height)
			self.tabs[i]:SetPoint("TOPLEFT", 0,0)
	
			self.tabs[i].button = CreateFrame("Button", nil, self, template or "ExRTTabButtonTemplate")
			self.tabs[i].button:SetText(select(i, ...) or i)
			TabFrame_ResizeTab(self.tabs[i].button, 0, nil, nil, self.tabs[i].button:GetFontString():GetStringWidth(), self.tabs[i].button:GetFontString():GetStringWidth())
			
			self.tabs[i].button.id = i
			self.tabs[i].button.mainFrame = self
			self.tabs[i].button:SetScript("OnClick", TabFrameButtonClick)
			
			self.tabs[i].button:SetScript("OnEnter", TabFrameButtonOnEnter)
			self.tabs[i].button:SetScript("OnLeave", TabFrameButtonOnLeave)
	
			if i == 1 then
				self.tabs[i].button:SetPoint("TOPLEFT", 10, 24)
			else
				self.tabs[i].button:SetPoint("LEFT", self.tabs[i-1].button, "RIGHT", template and 0 or -16, 0)
				self.tabs[i]:Hide()
			end
			TabFrame_DeselectTab(self.tabs[i].button)
			
			--[[
			if self:GetLeft()+self:GetWidth()-(i==tabNum and 0 or 24) < self.tabs[i].button:GetRight() then
				self.tabs[i].button:Hide()
				TabFrameCreateNavigation(self,i-1)
			end
			]]
			
			self.tabs[i].button.Resize = TabFrame_ResizeTab
			self.tabs[i].button.SetIcon = TabFrame_SetTabIcon
			self.tabs[i].button.Select = TabFrame_SelectTab
			self.tabs[i].button.Deselect = TabFrame_DeselectTab
		end
		TabFrame_SelectTab(self.tabs[activeTabNum or 1].button)
	
		self.tabCount = tabNum
		self.selected = activeTabNum or 1
		self.UpdateTabs = TabFrameUpdateTabs
		self.SelectTab = TabFrameSelectTab
	
		return self
	end
	function ExRT.lib.CreateTabFrame(parent,width,height,x,y,tabNum,activeTabNum,...)
		return ExRT.lib.CreateTabFrameTemplate(parent,width,height,x,y,nil,tabNum,activeTabNum,...)
	end
end

do
	local BlizzardDefFont = nil
	function ExRT.lib.CreateText(parent,width,height,relativePoint,x,y,hor,ver,font,fontSize,text,tem,colR,colG,colB,shadow,outline,doNotUseTemplate)
		if not tem and not font and not doNotUseTemplate then 
			tem = "ExRTFontNormal" 
		end
		if outline then 
			outline = "OUTLINE" 
		end
		if font == 0 then
			BlizzardDefFont = BlizzardDefFont or GameFontNormal:GetFont()
			font = BlizzardDefFont
		end
		local self = parent:CreateFontString(nil,"ARTWORK",tem)
		if not doNotUseTemplate then
			if not tem then
				self:SetFont(font, fontSize, outline)
			elseif fontSize then
				local filename = self:GetFont()
				self:SetFont(filename,fontSize, outline)
			end
		end
		self:SetSize(width,height)
		self:SetPoint(relativePoint or "TOPLEFT", x,y)
		self:SetJustifyH(hor or "LEFT")
		self:SetJustifyV(ver or "MIDDLE")
		if colR and colG and colB then
			self:SetTextColor(colR,colG,colB,1)
		end
		if shadow then
			self:SetShadowColor(0,0,0,1)
			self:SetShadowOffset(1,-1)
		end
		if text and not doNotUseTemplate then
			self:SetText(text)
		end
		
		self.SetNewPoint = ExRT.lib.SetPoint
		
		return self
	end
end

do
	local function EditBoxEscapePressed(self)
		self:ClearFocus()
	end
	function ExRT.lib.CreateEditBox(parent,width,height,relativePoint,x,y,tooltip,maxLetters,onlyNum,doNotUseTemplate,defText)
		local template = "ExRTInputBoxTemplate"
		if type(doNotUseTemplate) == "string" then
			template = doNotUseTemplate
			doNotUseTemplate = nil
		elseif doNotUseTemplate then
			template = nil
		end
		local self = CreateFrame("EditBox",nil,parent,template)
		self:SetSize(width,height)
		self:SetPoint(relativePoint or "TOPLEFT",x,y)
		if doNotUseTemplate then
			local GameFontNormal_Font = GameFontNormal:GetFont()
			self:SetFont(GameFontNormal_Font,12)
			self:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8X8",edgeFile = ExRT.mds.defBorder,edgeSize = 8,tileSize = 0,insets = {left = 2.5,right = 2.5,top = 2.5,bottom = 2.5}})
			self:SetBackdropColor(0, 0, 0, 0.8) 
			self:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
			self:SetTextInsets(10,10,0,0)
		end
		if defText then
			self:SetText(defText)
			self:SetCursorPosition(0)
		end
		self:SetAutoFocus( false )
		if tooltip then
			self:SetScript("OnEnter",ExRT.lib.OnEnterTooltip)
			self:SetScript("OnLeave",ExRT.lib.OnLeaveTooltip)
			self.tooltipText = tooltip
		end
		if maxLetters then
			self:SetMaxLetters(maxLetters)
		end
		if onlyNum then
			self:SetNumeric(true)
		end
		self:SetScript("OnEscapePressed",EditBoxEscapePressed)
		
		self.SetNewPoint = ExRT.lib.SetPoint
		
		return self
	end
end

do
	local function ScrollFrameMouseWheel(self,delta)
		delta = delta * 20
		local min,max = self.ScrollBar:GetMinMaxValues()
		local val = self.ScrollBar:GetValue()
		if (val - delta) < min then
			self.ScrollBar:SetValue(min)
		elseif (val - delta) > max then
			self.ScrollBar:SetValue(max)
		else
			self.ScrollBar:SetValue(val - delta)
		end
	end
	local function ScrollFrameScrollBarValueChanged(self,value)
		local parent = self:GetParent()
		parent:SetVerticalScroll(value) 
		self:ReButtonsState()
	end
	local function ScrollFrameChangeHeight(self,newHeight)
		self.content:SetHeight(newHeight)
		self.ScrollBar:SetMinMaxValues(0,max(newHeight-self:GetHeight(),0))
		self.ScrollBar:ReButtonsState()
	end
	local ScrollFrameBackdrop = {bgFile = "Interface/DialogFrame/UI-DialogBox-Background", edgeFile = "",tile = true, tileSize = 0, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 }}
	local ScrollFrameBackdropBorder = {bgFile = "Interface/DialogFrame/UI-DialogBox-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border",tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }}
	local ScrollFrameBackdropBorderModern = {edgeFile = "Interface/AddOns/ExRT/media/border.tga", edgeSize = 16}
	function ExRT.lib.CreateScrollFrame(parent,width,height,relativePoint,x,y,verticalHeight,isModern)
		local self = CreateFrame("ScrollFrame", nil, parent)
		self:SetSize(width,height)
		self:SetPoint(relativePoint or "TOPLEFT",x,y)
		
		self:SetBackdrop(ScrollFrameBackdrop)
		self:SetBackdropColor(0,0,0,0)
		self:SetBackdropBorderColor(0,0,0,0)
		
		self.backdrop = CreateFrame("Frame", nil, self)
		self.backdrop:SetPoint("TOPLEFT",self,-5,5)
		self.backdrop:SetSize(width+10,height+10)
		if isModern then
			self.backdrop:SetBackdrop(ScrollFrameBackdropBorderModern)
			self.backdrop:SetBackdropBorderColor(.24,.25,.30,1)
		else
			self.backdrop:SetBackdrop(ScrollFrameBackdropBorder)
			self.backdrop:SetBackdropColor(0,0,0,0)
		end
		
		self.content = CreateFrame("Frame", nil, self) 
		self.content:SetSize(width-16-(isModern and 4 or 0), verticalHeight)
		self:SetScrollChild(self.content)
		
		self.C = self.content
		
		if isModern then
			self.ScrollBar = ExRT.lib.CreateScrollBarModern(self,16,height,0,0,0,max(verticalHeight-height,0),"TOPRIGHT")
		else
			self.ScrollBar = ExRT.lib.CreateScrollBar(self,16,height,0,0,0,max(verticalHeight-height,0),"TOPRIGHT")
		end
		self.ScrollBar:SetScript("OnValueChanged", ScrollFrameScrollBarValueChanged)
		self.ScrollBar:ReButtonsState()
		
		self:SetScript("OnMouseWheel", ScrollFrameMouseWheel)
		
		self.SetNewHeight = ScrollFrameChangeHeight
		
		return self
	end
end

do
	local function MultiEditBoxGetTextHighlight(self)
		local text,cursor = self:GetText(),self:GetCursorPosition()
		self:Insert("")
		local textNew, cursorNew = self:GetText(), self:GetCursorPosition()
		self:SetText( text )
		self:SetCursorPosition( cursor )
		local Start, End = cursorNew, #text - ( #textNew - cursorNew )
		self:HighlightText( Start, End )
		return Start, End
	end
	local function MultiEditBoxUpdateFrameStrata(self,parent)
		parent = parent or self:GetParent()
		local parentStrata = parent:GetFrameStrata()
		local parentLevel = parent:GetFrameLevel()
		
		self:SetFrameStrata(parentStrata)
		self:SetToplevel(true)
		self.FocusButton:SetFrameLevel(parentLevel + 101)
		self.EditBox:SetFrameLevel(parentLevel + 102)
		self.ScrollBar:SetFrameLevel(parentLevel + 103)	
		
		--self.EditBox.Instructions:SetFrameLevel(parentLevel + 104)
		
	end
	function ExRT.lib.CreateMultiEditBox(parent,width,height,relativePoint,x,y)
		local name = GetNextGlobalName()
		local self=CreateFrame("ScrollFrame", name, parent, "InputScrollFrameTemplate")
		self:SetSize(width,height)
		self:SetPoint(relativePoint or "TOPLEFT",x,y)
		self.EditBox:SetFontObject("ChatFontNormal")
		self.EditBox:SetMaxLetters(0)
		self.CharCount:Hide()
		self.EditBox:SetWidth(width - 30)
		
		MultiEditBoxUpdateFrameStrata(self,parent)
		
		self.EditBox.GetTextHighlight = MultiEditBoxGetTextHighlight
		self.SetNewPoint = ExRT.lib.SetPoint
		self.UpdateFrameStrata = MultiEditBoxUpdateFrameStrata
	
		_G[name] = nil
		
		return self
	end
end

do
	local SliderBackdropTable = {bgFile = "Interface\\Buttons\\WHITE8X8",edgeFile = ExRT.mds.defBorder,edgeSize = 8,tileSize = 0,insets = {left = 2.5,right = 2.5,top = 2.5,bottom = 2.5}}
	local function SliderButtonClick(self)
		local parent = self:GetParent()
		parent.selected = parent.selected + self.diff
		local list = parent.List
		if parent.selected > #list then
			parent.selected = 1
		end
		if parent.selected < 1 then
			parent.selected = #list
		end
		if type(list[parent.selected]) == "table" then
			parent.text:SetText(list[parent.selected][1] or "")
			parent.tooltipText = list[parent.selected][2]
		else
			parent.text:SetText(list[parent.selected] or "")
			parent.tooltipText = nil
		end
		
		if parent.func then
			parent.func(parent)
		end
	end
	local function SliderBoxCreateButton(parent,size)
		local self = CreateFrame("Button",nil,parent)
		self:SetSize(size,size)
		self:SetBackdrop(SliderBackdropTable)
		self:SetBackdropColor(0, 0, 0, 0.8) 
		self:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
		self.text = self:CreateFontString(nil,"ARTWORK","GameFontNormal")
		self.text:SetAllPoints()
		self.text:SetJustifyH("CENTER")
		self.text:SetJustifyV("MIDDLE")
		self.text:SetTextColor(1,1,1,1)
		self.text:SetText("<")
		self:SetScript("OnClick",SliderButtonClick)
		
		return self
	end
	function ExRT.lib.CreateSliderBox(parent,width,height,x,y,list,selected)
		local self = CreateFrame("Frame",nil,parent)
		self:SetSize(width-height*2,height)
		self:SetPoint("TOPLEFT",x+height,y)
		self:SetBackdrop(SliderBackdropTable)
		self:SetBackdropColor(0, 0, 0, 0.8) 
		self:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
	
		self:SetScript("OnEnter",ExRT.lib.OnEnterTooltip)
		self:SetScript("OnLeave",ExRT.lib.OnLeaveTooltip)
	
		list = list or {}
		selected = selected or 1
		self.selected = selected
		self.List = list
	
		self.text = self:CreateFontString(nil,"ARTWORK","GameFontNormal")
		self.text:SetAllPoints()
		self.text:SetJustifyH("CENTER")
		self.text:SetJustifyV("MIDDLE")
		self.text:SetTextColor(1,1,1,1)		
		if type(list[selected]) == "table" then
			self.text:SetText(list[selected][1] or "")
			self.tooltipText = list[selected][2]
		else
			self.text:SetText(list[selected] or "")
		end
	
		self.left = SliderBoxCreateButton(self,height)
		self.left.text:SetText("<")
		self.left:SetPoint("RIGHT",self,"LEFT",0,0)
		self.left.diff = -1
		
		self.right = SliderBoxCreateButton(self,height)
		self.right.text:SetText(">")
		self.right:SetPoint("LEFT",self,"RIGHT",0,0)
		self.right.diff = 1
			
		return self
	end
end

do
	local function ButtonOnEnter(self)
		ExRT.lib.TooltipShow(self,"ANCHOR_TOP",self.tooltip,{self.tooltipText,1,1,1,true}) 
	end
	function ExRT.lib.CreateButton(parent,width,height,relativePoint,x,y,text,isDisabled,tooltip,template)
		local self = CreateFrame("Button",nil,parent,template or "UIPanelButtonTemplate")
		self:SetSize(width,height)
		if x and y then
			self:SetPoint(relativePoint or "TOPLEFT",x,y) 
		end
		self:SetText(text) 
		if isDisabled then
			self:Disable()
		end
		if tooltip then
			self.tooltip = text
			if text == "" then
				self.tooltip = " "
			end
			self.tooltipText = tooltip
			self:SetScript("OnEnter",ButtonOnEnter)
			self:SetScript("OnLeave",ExRT.lib.TooltipHide)
		end
		
		self.SetNewPoint = ExRT.lib.SetPoint
		
		return self
	end
end

function ExRT.lib.CreateIcon(parent,size,relativePoint,x,y,textureIcon,isButton)
	local self = CreateFrame(isButton and "Button" or "FRAME",nil,parent)
	self:SetSize(size,size)
	self:SetPoint(relativePoint or "TOPLEFT", x,y)
	self.texture = self:CreateTexture(nil, "BACKGROUND")
	self.texture:SetTexture(textureIcon or "Interface\\Icons\\INV_MISC_QUESTIONMARK")
	self.texture:SetAllPoints()
	if isButton then
 		self:EnableMouse(true)
		self:RegisterForClicks("LeftButtonDown")
	end
	return self
end

do
	local function CheckBoxOnEnter(self)
		local tooltipTitle = self.text:GetText()
		local tooltipText = self.tooltipText
		if tooltipTitle == "" or not tooltipTitle then
			tooltipTitle = tooltipText
			tooltipText = nil
		end
		ExRT.lib.TooltipShow(self,"ANCHOR_TOP",tooltipTitle,{tooltipText,1,1,1,true})
	end
	local function CheckBoxClick(self)
		if self:GetChecked() then
			self:On()
		else
			self:Off()
		end
	end
	function ExRT.lib.CreateCheckBox(parent,relativePoint,x,y,text,checked,tooltip,textLeft,template)
		local self = CreateFrame("CheckButton",nil,parent,template or "UICheckButtonTemplate")  
		if x and y then
			self:SetPoint(relativePoint or "TOPLEFT",x,y)
		end
		self.text:SetText(text)
		if checked then
			checked = true
		end
		self:SetChecked(checked)
		if tooltip then
			self.tooltipText = tooltip
		end
		self:SetScript("OnEnter",CheckBoxOnEnter)
		self:SetScript("OnLeave",ExRT.lib.TooltipHide)
		self:SetScript("OnClick", CheckBoxClick)
		if textLeft then
			self.text:ClearAllPoints()
			self.text:SetPoint("RIGHT",self,"LEFT",-2,0)
		end
		
		self.SetNewPoint = ExRT.lib.SetPoint
		
		return self
	end
end

function ExRT.lib.CreateRadioButton(parent,relativePoint,x,y,text,checked,isModern)
	local self = CreateFrame("CheckButton",nil,parent,isModern and "ExRTRadioButtonModernTemplate" or "UIRadioButtonTemplate")  
	if x and y then
		self:SetPoint(relativePoint or "TOPLEFT",x,y)
	end
	self.text:SetText(text)
	if checked then
		checked = true
	end
	self:SetChecked(checked)
	
	self.SetNewPoint = ExRT.lib.SetPoint
	
	return self
end

function ExRT.lib.CreateHoverHighlight(parent)
	parent.hl = parent:CreateTexture(nil, "BACKGROUND")
	parent.hl:SetPoint("TOPLEFT", 0, 0)
	parent.hl:SetPoint("BOTTOMRIGHT", 0, 0)
	parent.hl:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
	parent.hl:SetBlendMode("ADD")
	parent.hl:Hide()
end

function ExRT.lib.CreateBackTextureForDebug(parent)
	local frame = parent.CreateTexture and parent or parent:GetParent()
	local self = frame:CreateTexture(nil, "OVERLAY")
	self:SetAllPoints(parent)
	self:SetTexture(1, 0, 0, 0.3)
	
	return self
end

do
	local HELPstratas = {}
	local HELPlevels = {}
	local HelpPlateTooltipStrata = nil
	local HelpPlateTooltipLevel = nil
	local function HideFunc(self,isUser)
		HelpPlate_Hide(isUser)
		self:SetFrameStrata(self.strata)
		self:SetFrameLevel(self.level)
		
		if self.shitInterface then
			for i=1,#HELP_PLATE_BUTTONS do
				if HELPstratas[i] then
					HELP_PLATE_BUTTONS[i]:SetFrameStrata(HELPstratas[i])
					HELP_PLATE_BUTTONS[i]:SetFrameLevel(HELPlevels[i])
				end
			end
			if HelpPlateTooltipStrata then
				HelpPlateTooltip:SetFrameStrata(HelpPlateTooltipStrata)
				HelpPlateTooltip:SetFrameLevel(HelpPlateTooltipLevel)
			end
			self:SetFrameStrata( self.shitStrata )
			self:SetFrameLevel( 119 )
		end
	end
	local function HelpButtonOnClick(self)
		local helpPlate = nil
		if self.isTab then
			helpPlate = self.helpPlateArray[self.isTab.selected]
		else
			helpPlate = self.helpPlateArray
		end
		if helpPlate and not HelpPlate_IsShowing(helpPlate) then
			HelpPlate_Show(helpPlate, self.parent, self, true)
			self:SetFrameStrata( HelpPlate:GetFrameStrata() )
			self:SetFrameLevel( HelpPlate:GetFrameLevel() + 1 )
			
			if self.shitInterface then
				for i=1,#HELP_PLATE_BUTTONS do
					HELPstratas[i] = HELP_PLATE_BUTTONS[i]:GetFrameStrata()
					HELPlevels[i] = HELP_PLATE_BUTTONS[i]:GetFrameLevel()
					HELP_PLATE_BUTTONS[i]:SetFrameStrata(self.shitStrata)
					HELP_PLATE_BUTTONS[i].box:SetFrameStrata(self.shitStrata)
					HELP_PLATE_BUTTONS[i].boxHighlight:SetFrameStrata(self.shitStrata)
					HELP_PLATE_BUTTONS[i]:SetFrameLevel(120)
					HELP_PLATE_BUTTONS[i].box:SetFrameLevel(120)
					HELP_PLATE_BUTTONS[i].boxHighlight:SetFrameLevel(120)
				end
				HelpPlateTooltipStrata = HelpPlateTooltip:GetFrameStrata()
				HelpPlateTooltipLevel = HelpPlateTooltip:GetFrameLevel()
				HelpPlateTooltip:SetFrameStrata(self.shitStrata)
				HelpPlateTooltip:SetFrameLevel(122)
				self:SetFrameStrata( self.shitStrata )
				self:SetFrameLevel( 121 )
			end
		else
			HideFunc(self,true)
		end
		if self.Click2 then
			self:Click2()
		end

	end
	local function HelpButtonOnHide(self)
		HideFunc(self,false)
	end
	function ExRT.lib.CreateHelpButton(parent,helpPlateArray,isTab)
		local self = CreateFrame("Button",nil,parent,"MainHelpPlateButton")	-- После использования кнопки не дает юзать спелл дизенчант. лень искать решение, не юзайте кнопку часто [5.4]
		self:SetPoint("CENTER",parent,"TOPLEFT",0,0) 
		self:SetScale(0.8)
		local interfaceStrata = InterfaceOptionsFrame:GetFrameStrata()
		interfaceStrata = "FULLSCREEN_DIALOG"
		self:SetFrameStrata(interfaceStrata)
		if interfaceStrata == "FULLSCREEN" or interfaceStrata == "FULLSCREEN_DIALOG" or interfaceStrata == "TOOLTIP" then
			self.shitInterface = true
			self.shitStrata = interfaceStrata
		end
		
		self.helpPlateArray = helpPlateArray
		self.isTab = isTab
		self.parent = parent
		
		self:SetScript("OnClick",HelpButtonOnClick)
		self:SetScript("OnHide",HelpButtonOnHide)
		self.strata = self:GetFrameStrata()
		self.level = self:GetFrameLevel()
		
		return self
	end
end

do
	local ScrollListFrameUpdate = nil
	local function ScrollListUpdate()
		local self = ScrollListFrameUpdate
		local val = ExRT.mds.Round(self.ScrollBar:GetValue())
		local j = 0
		for i=val,#self.L do
			j = j + 1
			self.List[j]:SetText(self.L[i])
			if not self.dontDisable then
				if i ~= self.selected then
					self.List[j]:SetEnabled(true)
				else
					self.List[j]:SetEnabled(nil)
				end
			end
			self.List[j]:Show()
			self.List[j].index = i
			if j >= self.linesNum then
				break
			end
		end
		for i=(j+1),self.linesNum do
			self.List[i]:Hide()
		end
		self.ScrollBar:SetMinMaxValues(1,max(#self.L-self.linesNum+1,1))
		self.ScrollBar:ReButtonsState()
		
		if self.UpdateAdditional then
			self.UpdateAdditional(self,val)
		end
	end
	local function ScrollListMouseWheel(self,delta)
		if delta > 0 then
			self.ScrollBar.buttonUP:Click("LeftButton")
		else
			self.ScrollBar.buttonDown:Click("LeftButton")
		end
	end
	local function ScrollListListClick(self)
		local parent = self.mainFrame
		if not parent.dontDisable then
			for j=1,parent.linesNum do
				if j ~= self.id then
					parent.List[j]:SetEnabled(true)
				else
					parent.List[j]:SetEnabled(nil)
				end
			end
		end
		parent.selected = self.index
		parent:SetListValue(self.index)
	end
	local function ScrollListListEnter(self)
		if self.mainFrame.HoverListValue then
			self.mainFrame:HoverListValue(true,self.index)
		end
	end
	local function ScrollListListLeave(self)
		if self.mainFrame.HoverListValue then
			self.mainFrame:HoverListValue(false,self.index)
		end
	end
	local ScrollListBackdrop = {bgFile = "", edgeFile = "Interface/Tooltips/UI-Tooltip-Border",tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }}
	local ScrollListBackdropModern = {edgeFile = "Interface/AddOns/ExRT/media/border.tga", edgeSize = 16}
	function ExRT.lib.CreateScrollList(parent,relativePoint,x,y,width,linesNum,isModern)
		local self = CreateFrame("Frame",nil,parent)
		local height = linesNum * 16 + 8
		self:SetSize(width,height)
		self:SetPoint(relativePoint or "TOPLEFT",x,y)
		if isModern then
			self:SetBackdrop(ScrollListBackdropModern)
			self:SetBackdropBorderColor(.24,.25,.30,1)
			self.ScrollBar = ExRT.lib.CreateScrollBarModern(self,16,height-8,-3,-4,1,10,"TOPRIGHT")
		else
			self:SetBackdrop(ScrollListBackdrop)
			self.ScrollBar = ExRT.lib.CreateScrollBar(self,16,height-8,-3,-4,1,10,"TOPRIGHT")
		end
		
		self.linesNum = linesNum
		self.Width = width
		
		self.List = {}
		for i=1,linesNum do
			self.List[i] = CreateFrame("Button",nil,self)
			self.List[i]:SetSize(width - 22,16)
			self.List[i]:SetPoint("TOPLEFT",3,-(i-1)*16-4)
			
			self.List[i]:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight","ADD")
			
			self.List[i].text = ExRT.lib.CreateText(self.List[i],width - 30,16,nil,4,0,"LEFT","MIDDLE",nil,12,"List"..tostring(i),nil,1,1,1,1)
			
			self.List[i].PushedTexture = self.List[i]:CreateTexture()
			self.List[i].PushedTexture:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
			self.List[i].PushedTexture:SetBlendMode("ADD")
			self.List[i].PushedTexture:SetAllPoints()
			self.List[i].PushedTexture:SetVertexColor(1,1,0,1)
			
			self.List[i]:SetDisabledTexture(self.List[i].PushedTexture)
			
			self.List[i]:SetFontString(self.List[i].text)
			self.List[i]:SetPushedTextOffset(2, -1)
			
			self.List[i].mainFrame = self
			self.List[i].id = i
			self.List[i]:SetScript("OnClick",ScrollListListClick)
			
			self.List[i]:SetScript("OnEnter",ScrollListListEnter)
			self.List[i]:SetScript("OnLeave",ScrollListListLeave)		
		end
		
		self.L = {}
		function self.Update()
			ScrollListFrameUpdate = self
			ScrollListUpdate()
		end
		
		self:SetScript("OnMouseWheel",ScrollListMouseWheel)
		
		self:SetScript("OnShow",self.Update)
		self.ScrollBar:SetScript("OnValueChanged",self.Update)
		
		return self
	end
end

do
	local function ScrollCheckListUpdate(self)
		local val = ExRT.mds.Round(self.ScrollBar:GetValue())
		local j = 0
		for i=val,#self.L do
			j = j + 1
			self.List[j]:SetText(self.L[i])
			self.List[j].chk:SetChecked(self.C[i])
			self.List[j]:Show()
			self.List[j].index = i
			if j >= self.linesNum then
				break
			end
		end
		for i=(j+1),self.linesNum do
			self.List[i]:Hide()
		end
		self.ScrollBar:SetMinMaxValues(1,max(#self.L-self.linesNum+1,1))
		self.ScrollBar:ReButtonsState()
	end
	local function ScrollCheckListScrollBarOnValueChanged(self)
		local parent = self:GetParent()
		parent:Update()
	end
	local function ScrollCheckListMouseWheel(self, delta)
		if delta > 0 then
			self.ScrollBar.buttonUP:Click("LeftButton")
		else
			self.ScrollBar.buttonDown:Click("LeftButton")
		end
	end
	local function ScrollCheckListListCheckClick(self)
		local listParent = self:GetParent()
		local parent = listParent.mainFrame
		if self:GetChecked() then
			parent.C[listParent.index] = true
		else
			parent.C[listParent.index] = nil
		end
		parent.ValueChanged(parent)
	end
	local function ScrollCheckListListClick(self)
		local parent = self.mainFrame
		parent.C[self.index] = not parent.C[self.index]
		parent.List[self.id].chk:SetChecked(parent.C[self.index])
		
		parent.ValueChanged(parent)
	end	
	local function ScrollCheckListListEnter(self)
		if self.mainFrame.HoverListValue then
			self.mainFrame:HoverListValue(true,self.index)
		end
	end
	local function ScrollCheckListListLeave(self)
		if self.mainFrame.HoverListValue then
			self.mainFrame:HoverListValue(false,self.index)
		end
	end
	local ScrollCheckListBackdrop = {bgFile = "", edgeFile = "Interface/Tooltips/UI-Tooltip-Border",tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }}
	local ScrollCheckListBackdropModern = {edgeFile = "Interface/AddOns/ExRT/media/border.tga", edgeSize = 16}
	function ExRT.lib.CreateScrollCheckList(parent,relativePoint,x,y,width,linesNum,isModern)
		local self = CreateFrame("Frame",nil,parent)
		local height = linesNum * 16 + 8
		self:SetSize(width,height)
		self:SetPoint(relativePoint or "TOPLEFT",x,y)
		if isModern then
			self:SetBackdrop(ScrollCheckListBackdropModern)
			self:SetBackdropBorderColor(.24,.25,.30,1)
			self.ScrollBar = ExRT.lib.CreateScrollBarModern(self,16,height-8,-3,-4,1,10,"TOPRIGHT")
		else
			self:SetBackdrop(ScrollCheckListBackdrop)
			self.ScrollBar = ExRT.lib.CreateScrollBar(self,16,height-8,-3,-4,1,10,"TOPRIGHT")
		end
		
		
		self.linesNum = linesNum
		
		self.List = {}
		for i=1,linesNum do
			self.List[i] = CreateFrame("Button",nil,self)
			self.List[i]:SetSize(width - 22,16)
			self.List[i]:SetPoint("TOPLEFT",3,-(i-1)*16-4)
			
			self.List[i]:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight","ADD")
			
			self.List[i].text = ExRT.lib.CreateText(self.List[i],width - 50,16,nil,24,0,"LEFT","MIDDLE",nil,12,"List"..tostring(i),nil,1,1,1,1)
			
			self.List[i].mainFrame = self
			self.List[i].id = i
			
			if isModern then
				self.List[i].chk = CreateFrame("CheckButton",nil,self.List[i],"ExRTCheckButtonModernTemplate")  
				self.List[i].chk:SetSize(14,14)
				self.List[i].chk:SetPoint("LEFT",4,0)
			else
				self.List[i].chk = CreateFrame("CheckButton",nil,self.List[i],"UICheckButtonTemplate")  
				self.List[i].chk:SetScale(0.75)
				self.List[i].chk:SetPoint("TOPLEFT",0,5)
			end
			self.List[i].chk:SetScript("OnClick", ScrollCheckListListCheckClick)
			
			self.List[i].PushedTexture = self.List[i]:CreateTexture()
			self.List[i].PushedTexture:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
			self.List[i].PushedTexture:SetBlendMode("ADD")
			self.List[i].PushedTexture:SetAllPoints()
			self.List[i].PushedTexture:SetVertexColor(1,1,0,1)
			
			self.List[i]:SetDisabledTexture(self.List[i].PushedTexture)
			
			self.List[i]:SetFontString(self.List[i].text)
			self.List[i]:SetPushedTextOffset(2, -1)
			
 			self.List[i]:SetScript("OnClick", ScrollCheckListListClick)
			
			self.List[i]:SetScript("OnEnter", ScrollCheckListListEnter)
			self.List[i]:SetScript("OnLeave", ScrollCheckListListLeave)		
		end
		
		self.L = {}
		self.C = {}
		self.Update = ScrollCheckListUpdate
		
		self:SetScript("OnMouseWheel", ScrollCheckListMouseWheel)
		
		self:SetScript("OnShow",self.Update)
		self.ScrollBar:SetScript("OnValueChanged",ScrollCheckListScrollBarOnValueChanged)
		
		return self
	end
end

do
	local function PopupFrameShow(self,anchor,notResetPosIfShown)
		if self:IsShown() and notResetPosIfShown then
			return
		end
		local x, y = GetCursorPosition()
		local Es = self:GetEffectiveScale()
		x, y = x/Es, y/Es
		self:ClearAllPoints()
		self:SetPoint(anchor or self.anchor or "BOTTOMLEFT",UIParent,"BOTTOMLEFT",x,y)
		self:Show()
	end
	local function PopupFrameOnShow(self)
		local interfaceStrata = InterfaceOptionsFrame:GetFrameStrata()
		if interfaceStrata == "FULLSCREEN" or interfaceStrata == "FULLSCREEN_DIALOG" or interfaceStrata == "TOOLTIP" then
			self:SetFrameStrata(interfaceStrata)
		end
		self:SetFrameLevel(120)
		if self.OnShow then
			self:OnShow()
		end
	end
	function ExRT.lib.CreatePopupFrame(width,height,title,isModern)
		local self = CreateFrame("Frame",nil,UIParent,isModern and "ExRTDialogModernTemplate" or "ExRTDialogTemplate")
		self:SetSize(width,height)
		self:SetPoint("CENTER")
		self:SetFrameStrata("DIALOG")
		self:SetClampedToScreen(true)
		self:EnableMouse(true)
		self:SetMovable(true)
		self:RegisterForDrag("LeftButton")
		self:SetDontSavePosition(true)
		self:SetScript("OnDragStart", function(self) 
			self:StartMoving() 
		end)
		self:SetScript("OnDragStop", function(self) 
			self:StopMovingOrSizing() 
		end)
		self:Hide()
		self:SetScript("OnShow", PopupFrameOnShow) 
		
		if isModern then
			self.border = ExRT.lib.CreateShadow(self,20)
		end
		
		self.ShowClick = PopupFrameShow
		
		if not isModern then
			self.title:SetTextColor(1,1,1,1)
		end
		if title then
			self.title:SetText(title)
		end
		
		return self
	end
end

function ExRT.lib.CreateOneTab(parent,width,height,relativePoint,x,y,text,isModern)
	local self = CreateFrame("Frame",nil,parent)
	self:SetSize(width,height)
	if not isModern then
		self:SetBackdrop({bgFile = "Interface/DialogFrame/UI-DialogBox-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border",tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }})
		self:SetBackdropColor(0,0,0,0.5)
	else
		self:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.mds.defBorder,tile = false,edgeSize = 8})
		self:SetBackdropColor(0,0,0,0.3)
		self:SetBackdropBorderColor(.24,.25,.30,1)
	end
	self:SetPoint(relativePoint or "TOPLEFT",x,y)
	if text then
		self.name = ExRT.lib.CreateText(self,width-20,20,"TOP",0,17,nil,nil,nil,nil,text,"GameFontNormal")
	end
	
	self.SetNewPoint = ExRT.lib.SetPoint
	
	return self
end

function ExRT.lib.CreateColorPickButton(parent,width,height,relativePoint,x,y,cR,cG,cB,cA)
	local self = CreateFrame("Button",nil,parent)
	self:SetPoint(relativePoint or "TOPLEFT",x,y)
	self:SetSize(width,height)
	self:SetBackdrop({edgeFile = ExRT.mds.defBorder, edgeSize = 8})
	
	self:SetScript("OnEnter",function ()
		self:SetBackdropBorderColor(0.5,1,0,5,1)
	end)
	self:SetScript("OnLeave",function ()
	  	self:SetBackdropBorderColor(1,1,1,1)
	end)
	
	self.color = self:CreateTexture(nil, "BACKGROUND")
	self.color:SetTexture(cR or 0, cG or 0, cB or 0, cA or 1)
	self.color:SetAllPoints()
	
	return self
end

function ExRT.lib.CreateScrollTabsFrame(parent,relativePoint,x,y,width,height,noSelfBorder,isModern,...)
	local linesNum = floor((height - 8)/16)
	height = height - ((height-8)%16) + (noSelfBorder and 0 or 10)
	relativePoint = relativePoint or "TOPLEFT"
	
	local self = nil
	if noSelfBorder then
		self = CreateFrame("Frame",nil,parent)
		self:SetSize(width,height)
		self:SetPoint(relativePoint,x,y)
	else
		self = ExRT.lib.CreateOneTab(parent,width,height,relativePoint,x,y)
	end
	self.list = ExRT.lib.CreateScrollList(self,"TOPLEFT",noSelfBorder and 0 or 5,noSelfBorder and 0 or -5,200,linesNum,isModern)
	self.tab = {}
	self.listCount = select("#", ...)
	for i=1,self.listCount do
		self.list.L[i] = select(i, ...)
		self.tab[i] = ExRT.lib.CreateOneTab(self,width-205-(noSelfBorder and 0 or 10),height-(noSelfBorder and 0 or 10),"TOPLEFT",205+(noSelfBorder and 0 or 5),noSelfBorder and 0 or -5,nil,isModern)
	end
	self.list:Update()
	
	local this = self
	function self.list:SetListValue(index)
		for i=1,this.listCount do
			ExRT.lib.ShowOrHide(this.tab[i],i == index)
		end
	end
	self.list.selected = 1
	self.list:SetListValue(1)
	
	self.newTabWidth = width-205-(noSelfBorder and 0 or 10)
	self.newTabHeight = height-(noSelfBorder and 0 or 10)
	self.newTabBorder = noSelfBorder

	return self
end

function ExRT.lib.CreateHiddenFrame(parent,relativePoint,x,y,width,height)
	local self = CreateFrame("Frame",nil,parent)
	if not x then
		self:SetAllPoints(parent)
	else
		self:SetSize(width,height)
		self:SetPoint(relativePoint or "TOPLEFT",x,y)
	end
		
	return self
end

do
	local function DropDown_SetWidth(self, width)
		if self.Middle then
			self.Middle:SetWidth(width)
			local defaultPadding = 25
			self:_SetWidth(width + defaultPadding + defaultPadding)
			self.Text:SetWidth(width - defaultPadding)
		else
			self:_SetWidth(width)
		end
		
		self.noResize = true
	end
	local function DropDown_SetText(self, text)
		self.Text:SetText(text)
	end
	local function DropDown_OnEnter(self)
		if self.tooltip then
			ExRT.lib.TooltipShow(self,nil,self.tooltip,self.Text:IsTruncated() and self.Text:GetText())
		elseif self.Text:IsTruncated() then
			ExRT.lib.TooltipShow(self,nil,self.Text:GetText())
		end
	end
	local function DropDown_OnLeave(self)
		GameTooltip_Hide()
	end
	function ExRT.lib.CreateDropDown(parent,relativePoint,x,y,width,defText,template,tooltip)
		local self = CreateFrame("Frame", nil, parent, template or "ExRTDropDownMenuTemplate")
		self:SetPoint(relativePoint or "TOPLEFT",x,y)

		self._SetWidth = self.SetWidth		
		self.SetWidth = DropDown_SetWidth
		self.SetText = DropDown_SetText
		
		self:SetWidth(width)
		if defText then
			self:SetText(defText)
		end
		
		self.tooltip = tooltip
		self:SetScript("OnEnter",DropDown_OnEnter)
		self:SetScript("OnLeave",DropDown_OnLeave)
		
		self.relativeTo = self.Left
		self.SetNewPoint = ExRT.lib.SetPoint
		
		return self
	end
end

---> Scroll Drop Down
do
	local function ScrollDropDownOnHide(self)
		ExRT.lib.ScrollDropDown.Close()
	end
	function ExRT.lib.CreateScrollDropDown(parent,relativePoint,x,y,width,dropDownWidth,lines,defText,tooltip,template)
		local self = ExRT.lib.CreateDropDown(parent,relativePoint,x,y,width,defText,template,tooltip)
		
		dropDownWidth = dropDownWidth or width
		
		self.Button:SetScript("OnClick",ExRT.lib.ScrollDropDown.ClickButton)
		self:SetScript("OnHide",ScrollDropDownOnHide)
		
		self.List = {}
		self.Width = dropDownWidth
		self.Lines = lines or 10
		
		if template == "ExRTDropDownMenuModernTemplate" then
			self.isModern = true
		end
	
		return self
	end
	function ExRT.lib.CreateScrollDropDownButton(parent,relativePoint,x,y,width,height,dropDownWidth,lines,defText,tooltip,template)
		local self = ExRT.lib.CreateButton(parent,width,height,relativePoint,x,y,defText,nil,tooltip,template)
		
		self:SetScript("OnClick",ExRT.lib.ScrollDropDown.ClickButton)
		self:SetScript("OnHide",ScrollDropDownOnHide)
		
		self.List = {}
		self.Width = dropDownWidth
		self.Lines = lines or 10
		
		self.isButton = true
	
		return self
	end
end

ExRT.lib.ScrollDropDown = {}
ExRT.lib.ScrollDropDown.List = {}
local ScrollDropDown_Blizzard,ScrollDropDown_Modern = {},{}

for i=1,2 do
	ScrollDropDown_Modern[i] = CreateFrame("Frame","ExRTDropDownListModern",UIParent,"ExRTDropDownListModernTemplate")
	ScrollDropDown_Modern[i]:SetClampedToScreen(true)
	ScrollDropDown_Modern[i].border = ExRT.lib.CreateShadow(ScrollDropDown_Modern[i],20)
	ScrollDropDown_Modern[i].Buttons = {}
	ScrollDropDown_Modern[i].MaxLines = 0
	ScrollDropDown_Modern[i].isModern = true
	do
		ScrollDropDown_Modern[i].Animation = ScrollDropDown_Modern[i]:CreateAnimationGroup()
		ScrollDropDown_Modern[i].Animation:SetScript("OnFinished", function(self) 
			self:GetParent().border:SetBackdropBorderColor(0,0,0,.45)
			self:Play()
		end)
		local fade1 = ScrollDropDown_Modern[i].Animation:CreateAnimation("Alpha")
		fade1:SetDuration(1)
		fade1:SetOrder(1)
		fade1.parent = ScrollDropDown_Modern[i]
		fade1:SetScript("OnUpdate",function (self)
			local color =  self:GetProgress() / 2
			self.parent.BorderTop:SetTexture(color,color,color,1)
			self.parent.BorderLeft:SetTexture(color,color,color,1)
			self.parent.BorderBottom:SetTexture(color,color,color,1)
			self.parent.BorderRight:SetTexture(color,color,color,1)
		end)
		local pause = ScrollDropDown_Modern[i].Animation:CreateAnimation("Alpha")
		pause:SetDuration(.5)
		pause:SetOrder(2)
		pause:SetScript("OnUpdate",function (self)
		
		end)
		local fade2 = ScrollDropDown_Modern[i].Animation:CreateAnimation("Alpha")
		fade2:SetDuration(1)
		fade2:SetOrder(3)
		fade2.parent = ScrollDropDown_Modern[i]
		fade2:SetScript("OnUpdate",function (self)
			local color = (1 - self:GetProgress()) / 2
			self.parent.BorderTop:SetTexture(color,color,color,1)
			self.parent.BorderLeft:SetTexture(color,color,color,1)
			self.parent.BorderBottom:SetTexture(color,color,color,1)
			self.parent.BorderRight:SetTexture(color,color,color,1)
		end)
		local ScrollDropDown_Modern_i = ScrollDropDown_Modern[i]
		function ScrollDropDown_Modern_i:OnShow()
			self.Animation:Play()
		end
	end
	
	ScrollDropDown_Modern[i].Slider = ExRT.lib.CreateSlider(ScrollDropDown_Modern[i],10,170,-8,-8,1,10,"Text",1,"TOPRIGHT",true,true)
	ScrollDropDown_Modern[i].Slider:SetScript("OnValueChanged",function (self,value)
		value = ExRT.mds.Round(value)
		self:GetParent().Position = value
		ExRT.lib.ScrollDropDown:Reload()
	end)
	ScrollDropDown_Modern[i].Slider:SetScript("OnEnter",function(self) UIDropDownMenu_StopCounting(self:GetParent()) end)
	ScrollDropDown_Modern[i].Slider:SetScript("OnLeave",function(self) UIDropDownMenu_StartCounting(self:GetParent()) end)
	
	ScrollDropDown_Modern[i]:SetScript("OnMouseWheel",function (self,delta)
		local min,max = self.Slider:GetMinMaxValues()
		local val = self.Slider:GetValue()
		if (val - delta) < min then
			self.Slider:SetValue(min)
		elseif (val - delta) > max then
			self.Slider:SetValue(max)
		else
			self.Slider:SetValue(val - delta)
		end
	end)
end

for i=1,2 do
	ScrollDropDown_Blizzard[i] = CreateFrame("Frame","ExRTDropDownList",UIParent,"ExRTDropDownListTemplate")
	ScrollDropDown_Blizzard[i].Buttons = {}
	ScrollDropDown_Blizzard[i].MaxLines = 0
	
	ScrollDropDown_Blizzard[i].Slider = ExRT.lib.CreateSlider(ScrollDropDown_Blizzard[i],10,170,-15,-11,1,10,"Text",1,"TOPRIGHT",true)
	ScrollDropDown_Blizzard[i].Slider:SetScript("OnValueChanged",function (self,value)
		value = ExRT.mds.Round(value)
		self:GetParent().Position = value
		ExRT.lib.ScrollDropDown:Reload()
	end)
	ScrollDropDown_Blizzard[i].Slider:SetScript("OnEnter",function(self) UIDropDownMenu_StopCounting(self:GetParent()) end)
	ScrollDropDown_Blizzard[i].Slider:SetScript("OnLeave",function(self) UIDropDownMenu_StartCounting(self:GetParent()) end)
	
	ScrollDropDown_Blizzard[i]:SetScript("OnMouseWheel",function (self,delta)
		local min,max = self.Slider:GetMinMaxValues()
		local val = self.Slider:GetValue()
		if (val - delta) < min then
			self.Slider:SetValue(min)
		elseif (val - delta) > max then
			self.Slider:SetValue(max)
		else
			self.Slider:SetValue(val - delta)
		end
	end)
end

ExRT.lib.ScrollDropDown.DropDownList = ScrollDropDown_Blizzard

do
	local function CheckButtonClick(self)
		local parent = self:GetParent()
		self:GetParent():GetParent().List[parent.id].checkState = self:GetChecked()
		if parent.checkFunc then
			parent.checkFunc(parent,self:GetChecked())
		end
	end
	local function CheckButtonOnEnter(self)
		UIDropDownMenu_StopCounting(self:GetParent():GetParent())
	end
	local function CheckButtonOnLeave(self)
		UIDropDownMenu_StartCounting(self:GetParent():GetParent())
	end
	function ExRT.lib.ScrollDropDown.CreateButton(i,level)
		level = level or 1
		local dropDown = ExRT.lib.ScrollDropDown.DropDownList[level]
		if dropDown.Buttons[i] then
			return
		end
		dropDown.Buttons[i] = CreateFrame("Button",nil,dropDown,"ExRTDropDownMenuButtonTemplate")
		if dropDown.isModern then
			dropDown.Buttons[i]:SetPoint("TOPLEFT",8,-8 - (i-1) * 16)
		else
			dropDown.Buttons[i]:SetPoint("TOPLEFT",18,-16 - (i-1) * 16)
		end
		dropDown.Buttons[i].NormalText:SetMaxLines(1) 
		
		if dropDown.isModern then
			dropDown.Buttons[i].checkButton = CreateFrame("CheckButton",nil,dropDown.Buttons[i],"ExRTCheckButtonModernTemplate")
			dropDown.Buttons[i].checkButton:SetPoint("LEFT",1,0)
			dropDown.Buttons[i].checkButton:SetSize(12,12)
			
			dropDown.Buttons[i].radioButton = CreateFrame("CheckButton",nil,dropDown.Buttons[i],"ExRTRadioButtonModernTemplate")
			dropDown.Buttons[i].radioButton:SetPoint("LEFT",1,0)
			dropDown.Buttons[i].radioButton:SetSize(12,12)
			dropDown.Buttons[i].radioButton:EnableMouse(false)
		else
			dropDown.Buttons[i].checkButton = CreateFrame("CheckButton",nil,dropDown.Buttons[i],"UICheckButtonTemplate")
			dropDown.Buttons[i].checkButton:SetPoint("LEFT",-7,0)
			dropDown.Buttons[i].checkButton:SetScale(.6)
			
			dropDown.Buttons[i].radioButton = CreateFrame("CheckButton",nil,dropDown.Buttons[i])	-- Do not used in blizzard style
		end
		dropDown.Buttons[i].checkButton:SetScript("OnClick",CheckButtonClick)
		dropDown.Buttons[i].checkButton:SetScript("OnEnter",CheckButtonOnEnter)
		dropDown.Buttons[i].checkButton:SetScript("OnLeave",CheckButtonOnLeave)
		dropDown.Buttons[i].checkButton:Hide()
		dropDown.Buttons[i].radioButton:Hide()
		
		dropDown.Buttons[i].Level = level
	end
end

function ExRT.lib.ScrollDropDown.ClickButton(self)
	if ExRT.lib.ScrollDropDown.DropDownList[1]:IsShown() then
		ExRT.lib.ScrollDropDown.Close()
		return
	end
	local dropDown = nil
	if self.isButton then
		dropDown = self
	else
		dropDown = self:GetParent()
	end
	ExRT.lib.ScrollDropDown.ToggleDropDownMenu(dropDown)
	PlaySound("igMainMenuOptionCheckBoxOn")
end

function ExRT.lib.ScrollDropDown:Reload(level)
	for j=1,#ExRT.lib.ScrollDropDown.DropDownList do
		if ExRT.lib.ScrollDropDown.DropDownList[j]:IsShown() or level == j then
			local val = ExRT.lib.ScrollDropDown.DropDownList[j].Position
			local count = #ExRT.lib.ScrollDropDown.DropDownList[j].List
			local now = 0
			for i=val,count do
				local data = ExRT.lib.ScrollDropDown.DropDownList[j].List[i]
				
				if not data.isHidden then
					now = now + 1
					local button = ExRT.lib.ScrollDropDown.DropDownList[j].Buttons[now]
					local text = button.NormalText
					local icon = button.Icon
					local paddingLeft = data.padding or 0
					
					if data.icon then
						icon:SetTexture(data.icon)
						paddingLeft = paddingLeft + 18
						icon:Show()
					else
						icon:Hide()
					end
					
					if data.font and now <= 10 then
						local fontObject = _G["ExRTDropDownListFont"..now]
						fontObject:SetFont(data.font,12)
						fontObject:SetShadowOffset(1,-1)
						button:SetNormalFontObject(fontObject)
						button:SetHighlightFontObject(fontObject)
					else
						button:SetNormalFontObject(GameFontHighlightSmallLeft)
						button:SetHighlightFontObject(GameFontHighlightSmallLeft)
					end
					
					if data.colorCode then
						text:SetText( data.colorCode .. (data.text or "") .. "|r" )
					else
						text:SetText( data.text or "" )
					end
					
					text:ClearAllPoints()
					if data.checkable or data.radio then
						text:SetPoint("LEFT", paddingLeft + 16, 0)
					else
						text:SetPoint("LEFT", paddingLeft, 0)
					end
					text:SetPoint("RIGHT", button, "RIGHT", 0, 0)
					text:SetJustifyH(data.justifyH or "LEFT")
					
					if data.checkable then
						button.checkButton:SetChecked(data.checkState)
						button.checkButton:Show()
					else
						button.checkButton:Hide()
					end
					if data.radio then
						button.radioButton:SetChecked(data.checkState)
						button.radioButton:Show()
					else
						button.radioButton:Hide()
					end
					
					local texture = button.Texture
					if data.texture then
						texture:SetTexture(data.texture)
						texture:Show()
					else
						texture:Hide()
					end
					
					if data.subMenu then
						button.Arrow:Show()
					else
						button.Arrow:Hide()
					end
					
					if data.isTitle then
						button:SetEnabled(false)
					else
						button:SetEnabled(true)
					end
					
					button.id = i
					button.arg1 = data.arg1
					button.arg2 = data.arg2
					button.arg3 = data.arg3
					button.arg4 = data.arg4
					button.func = data.func
					button.hoverFunc = data.hoverFunc
					button.leaveFunc = data.leaveFunc
					button.hoverArg = data.hoverArg
					button.checkFunc = data.checkFunc
					
					button.subMenu = data.subMenu
					button.Lines = data.Lines --Max lines for second level
				
					button:Show()
					
					if now >= ExRT.lib.ScrollDropDown.DropDownList[j].LinesNow then
						break
					end
				end
			end
			for i=(now+1),ExRT.lib.ScrollDropDown.DropDownList[j].MaxLines do
				ExRT.lib.ScrollDropDown.DropDownList[j].Buttons[i]:Hide()
			end
		end
	end
end


function ExRT.lib.ScrollDropDown.Update(self, elapsed)
	if ( not self.showTimer or not self.isCounting ) then
		return
	elseif ( self.showTimer < 0 ) then
		self:Hide()
		self.showTimer = nil
		self.isCounting = nil
	else
		self.showTimer = self.showTimer - elapsed
	end
end

function ExRT.lib.ScrollDropDown.OnClick(self, button, down)
	local func = self.func
	if func then
		func(self, self.arg1, self.arg2, self.arg3, self.arg4)
	end
end
function ExRT.lib.ScrollDropDown.OnButtonEnter(self)
	local func = self.hoverFunc
	if func then
		func(self,self.hoverArg)
	end
	ExRT.lib.ScrollDropDown:CloseSecondLevel(self.Level)
	if self.subMenu then
		ExRT.lib.ScrollDropDown.ToggleDropDownMenu(self,2)
	end
end
function ExRT.lib.ScrollDropDown.OnButtonLeave(self)
	local func = self.leaveFunc
	if func then
		func(self)
	end
end

function ExRT.lib.ScrollDropDown.ToggleDropDownMenu(self,level)
	level = level or 1
	if self.ToggleUpadte then
		self:ToggleUpadte()
	end
	
	if level == 1 then
		if self.isModern then
			ExRT.lib.ScrollDropDown.DropDownList = ScrollDropDown_Modern
		else
			ExRT.lib.ScrollDropDown.DropDownList = ScrollDropDown_Blizzard
		end
	end
	for i=level+1,#ExRT.lib.ScrollDropDown.DropDownList do
		ExRT.lib.ScrollDropDown.DropDownList[i]:Hide()
	end
	local dropDown = ExRT.lib.ScrollDropDown.DropDownList[level]

	local dropDownWidth = self.Width
	local isModern = self.isModern
	if level > 1 then
		local parent = ExRT.lib.ScrollDropDown.DropDownList[1].parent
		dropDownWidth = parent.Width
		isModern = parent.isModern
	end


	dropDown.List = self.subMenu or self.List
	
	local count = #dropDown.List
	
	local maxLinesNow = self.Lines or count
	
	for i=(dropDown.MaxLines+1),maxLinesNow do
		ExRT.lib.ScrollDropDown.CreateButton(i,level)
	end
	dropDown.MaxLines = max(dropDown.MaxLines,maxLinesNow)
	
	local isSliderHidden = max(count-maxLinesNow+1,1) == 1
	if isModern then 
		for i=1,maxLinesNow do
			dropDown.Buttons[i]:SetSize(dropDownWidth - 16 - (isSliderHidden and 0 or 12),16)
		end
	else
		for i=1,maxLinesNow do
			dropDown.Buttons[i]:SetSize(dropDownWidth - 22 + (isSliderHidden and 16 or 0),16)
		end
	end
	dropDown.Position = 1
	dropDown.LinesNow = maxLinesNow
	dropDown.Slider:SetValue(1)
	if self.additionalToggle then
		self.additionalToggle(self)
	end
	dropDown:SetPoint("TOPRIGHT",self,"BOTTOMRIGHT",-16,0)
	dropDown.Slider:SetMinMaxValues(1,max(count-maxLinesNow+1,1))
	if isModern then 
		dropDown:SetSize(dropDownWidth,16 + 16 * maxLinesNow)
		dropDown.Slider:SetHeight(maxLinesNow * 16)
	else
		dropDown:SetSize(dropDownWidth + 32,32 + 16 * maxLinesNow)
		dropDown.Slider:SetHeight(maxLinesNow * 16 + 10)	
	end
	if isSliderHidden then
		dropDown.Slider:Hide()
	else
		dropDown.Slider:Show()
	end
	dropDown:ClearAllPoints()
	if level > 1 then
		dropDown:SetPoint("TOPLEFT",self,"TOPRIGHT",level > 1 and ExRT.lib.ScrollDropDown.DropDownList[level-1].Slider:IsShown() and 24 or 12,isModern and 8 or 16)
	else
		local toggleX = self.toggleX or -16
		local toggleY = self.toggleY or 0
		dropDown:SetPoint("TOPRIGHT",self,"BOTTOMRIGHT",toggleX,toggleY)
	end
	
	dropDown.parent = self
	
	dropDown:Show()
	dropDown:SetFrameLevel(0)
	
	ExRT.lib.ScrollDropDown:Reload()
end

function ExRT.lib.ScrollDropDown.CreateInfo(self,info)
	if info then
		self.List[#self.List + 1] = info
	end
	self.List[#self.List + 1] = {}
	return self.List[#self.List]
end

function ExRT.lib.ScrollDropDown.ClearData(self)
	table.wipe(self.List)
	return self.List
end

function ExRT.lib.ScrollDropDown.Close()
	ExRT.lib.ScrollDropDown.DropDownList[1]:Hide()
	ExRT.lib.ScrollDropDown:CloseSecondLevel()
end
function ExRT.lib.ScrollDropDown:CloseSecondLevel(level)
	level = level or 1
	for i=(level+1),#ExRT.lib.ScrollDropDown.DropDownList do
		ExRT.lib.ScrollDropDown.DropDownList[i]:Hide()
	end
end

---> End Scroll Drop Down


do
	local function ListFrameToggleButton(self)
		if self.OnClick then
			self:OnClick()
		end
		ExRT.lib.ScrollDropDown.ClickButton(self)
	end
	local function ListFrameOnHide(self)
		ExRT.lib.ScrollDropDown.Close()
	end	
	function ExRT.lib.CreateListFrame(parent,width,buttonsNum,buttonPos,relativePoint,x,y,buttonText,listClickFunc,isModern)
		local self = CreateFrame("Button",nil,parent,isModern and "ExRTUIChatDownButtonModernTemplate" or "ExRTUIChatDownButtonTemplate")
		self.isButton = true
		if buttonPos == "RIGHT" then
			self:SetPoint("TOPRIGHT",parent,relativePoint or "TOPLEFT",x,y)
			self.buttonToggleText = ExRT.lib.CreateText(self,0,18,"TOPRIGHT",-24,-3,"RIGHT",nil,nil,12,buttonText,nil,1,1,1,1)
		else
			self:SetPoint("TOPLEFT",parent,relativePoint or "TOPLEFT",x,y)
			self.buttonToggleText = ExRT.lib.CreateText(self,0,18,"TOPLEFT",24,-3,"LEFT",nil,nil,12,buttonText,nil,1,1,1,1)
		end
		self:SetScript("OnClick",ListFrameToggleButton)
		self:SetScript("OnHide",ListFrameOnHide)
		self.List = {}
		self.Lines = buttonsNum
		self.Width = width
		self.OnClick = listClickFunc
		self.isModern = isModern
				
		return self
	end
end

function ExRT.lib.SetPoint(self,...)
	self:ClearAllPoints()
	self:SetPoint(...)
end


--- Graph
do
	local Graph_DefColors = {
		{r = .6, g = 1, b = .6, a = 1},
		{r = 1, g = 1, b = 1, a = 1},
		{r = .82, g = .2, b = .2, a = 1},
		{r = .50, g = .20, b = .82, a = 1},
		{r = .38, g = .39, b = .82, a = 1},
		{r = .82, g = .60, b = .28, a = 1},
		{r = .41, g = .82, b = .77, a = 1},
		{r = 1, g = 1, b = 1, a = 1},
		{r = .82, g = .25, b = .51, a = 1},
		{r = .10, g = .58, b = 0, a = 1},
		{r = .58, g = 0, b = 0, a = 1},
		{r = 0, g = .22, b = .40, a = 1},
	}
	local function GraphGetNode(self,i)
		if not self.graph[i] then
			self.graph[i] = self:CreateTexture(nil, "BACKGROUND")
			self.graph[i]:SetTexture(0.6, 1, 0.6, 1)
		end
		return self.graph[i]
	end
	local function GraphSetDot(self,i,x,y)
		if not self.dots[i] then
			self.dots[i] = self:CreateTexture(nil, "BACKGROUND")
			self.dots[i]:SetTexture("Interface\\AddOns\\ExRT\\media\\blip")
			self.dots[i]:SetSize(2,2)
			self.dots[i]:SetTexture(0.6, 1, 0.6, 1)
		end
		self.dots[i]:SetPoint("TOPLEFT", x, y - self.height)
		self.dots[i]:Show()
	end
	local GraphSetLine = nil
	do
		local cos, sin = math.cos, math.sin
		local function RotateCoordPair(x,y,ox,oy,a,asp)
			y=y/asp
			oy=oy/asp
			return ox + (x-ox)*cos(a) - (y-oy)*sin(a),(oy + (y-oy)*cos(a) + (x-ox)*sin(a))*asp
		end
		local function RotateTexture(self,angle,xT,yT,xB,yB,xC,yC,userAspect)
			local aspect = userAspect or (xT-xB)/(yT-yB)
			local g1,g2 = RotateCoordPair(xT,yT,xC,yC,angle,aspect)
			local g3,g4 = RotateCoordPair(xT,yB,xC,yC,angle,aspect)
			local g5,g6 = RotateCoordPair(xB,yT,xC,yC,angle,aspect)
			local g7,g8 = RotateCoordPair(xB,yB,xC,yC,angle,aspect)
		
			self:SetTexCoord(g1,g2,g3,g4,g5,g6,g7,g8)
		end
		function GraphSetLine(self,i,fX,fY,tX,tY)
			if not self.lines[i] then
				self.lines[i] = self:CreateTexture(nil, "BACKGROUND")
				self.lines[i]:SetTexture("Interface\\AddOns\\ExRT\\media\\line2px")
				self.lines[i]:SetSize(256,256)
				self.lines[i]:SetVertexColor(0.6, 1, 0.6, 1)
			end
			local toDown = tY < fY
			if toDown then
				tY,fY = fY,tY
			end
			local size = max(tX-fX,tY-fY)
			local changeSize = (1 - (size / 256)) / 2
			local min,max = changeSize,1 - changeSize
			local angle
			if tX-fX == 0 then
				angle = 90
			else
				angle = atan( (tY-fY)/(tX-fX) )
			end
			if toDown then
				angle = -angle
			end
			self.lines[i]:SetSize(size,size)
			RotateTexture(self.lines[i],(PI/180)*angle,min,min,max,max,.5,.5)
			
			self.lines[i]:SetPoint("CENTER",self,"BOTTOMLEFT",fX + (tX - fX)/2, fY + (tY - fY)/2)
			self.lines[i]:Show()
		end
	end
	local function GraphSetColor(self,i,r,g,b,a)
		if self.isDots then
			self.dots[i]:SetTexture(r,g,b,a)
		elseif self.isLines then
			self.lines[i]:SetVertexColor(r,g,b,a)
		else
			self.graph[i]:SetTexture(r,g,b,a)
		end
	end
	
	local function GraphReload_BuildNodes(self,minX,minY,maxX,maxY,axixXstep,enableNodes)
		local nodeNow,Xnow,Ynow = 0,minX,minY
		self.tooltipsData = {}
		for i=1,#self.graph do
			self.graph[i]:Hide()
			self.graph[i]:ClearAllPoints()
		end
		for i=1,#self.dots do
			self.dots[i]:Hide()
		end
		for i=1,#self.lines do
			self.lines[i]:Hide()
		end
		for k=1,#self.data do
			Xnow,Ynow = minX,minY
			local colorR,colorG,colorB,colorA = self.data[k].r,self.data[k].g,self.data[k].b,self.data[k].a or 1
			if not colorR or not colorG or not colorB then
				local def = Graph_DefColors[k]
				if def then
					colorR,colorG,colorB,colorA = def.r,def.g,def.b,def.a
				else
					colorR,colorG,colorB,colorA = 1,1,1,.3
				end
			end
			self.tooltipsData[k] = {}
			for i=1,#self.data[k],self.step do
				local x = self.data[k][i][1]
				local steps = 1
				for j=1,(self.step-1) do
					if self.data[k][i+j] then
						x=x+self.data[k][i+j][1]
						steps = steps + 1
					end
				end
				x = x / steps
				if x >= minX and x <= maxX then
					if (not self.isDots and not self.isLines) or enableNodes then
						if x ~= Xnow then
							nodeNow = nodeNow + 1
							local node = GraphGetNode(self,nodeNow)
							node:SetPoint("BOTTOMLEFT",self,"BOTTOMLEFT",(Xnow - minX)/(maxX - minX)*self.width,(Ynow - minY)/(maxY - minY)*self.height)
							node:SetSize( (x - Xnow)/(maxX - minX)*self.width , 2 )
							node:Show()
							
							Xnow = x
						end
					end
					
					local y = self.data[k][i][2]
					steps = 1
					for j=1,(self.step-1) do
						if self.data[k][i+j] then
							y=y+self.data[k][i+j][2]
							steps = steps + 1
						end
					end
					y = y / steps
					if (not self.isDots and not self.isLines) or enableNodes then
						if y ~= Ynow then
							nodeNow = nodeNow + 1
							local node = GraphGetNode(self,nodeNow)
							local relativePoint = (Ynow > y) and "TOPLEFT" or "BOTTOMLEFT"
							local heightFix = (Ynow > y) and 2 or 0
							node:SetPoint(relativePoint,self,"BOTTOMLEFT",(Xnow - minX)/(maxX - minX)*self.width,(Ynow - minY)/(maxY - minY)*self.height + heightFix)
							node:SetSize( 2, abs(y - Ynow)/(maxY - minY)*self.height )
							node:Show()
							
							Ynow = y
						end
					end
					if self.isDots and not enableNodes then
						local fX,fY = (Xnow - minX)/(maxX - minX)*self.width,(Ynow - minY)/(maxY - minY)*self.height
						local tX,tY = (x - minX)/(maxX - minX)*self.width,(y - minY)/(maxY - minY)*self.height
						local a = (tY - fY) / (tX - fX)
						nodeNow = nodeNow + 1
						GraphSetDot(self,nodeNow,fX,fY > self.height and self.height or fY)
						local lastX,lastY = fX,fY
						for X=fX,tX,axixXstep do
							local Y = (X-fX)*a + fY
							if Y > self.height then	Y = self.height	end
							if abs(X-lastX) > 1.5 or abs(Y-lastY) > 1.5 then
								nodeNow = nodeNow + 1
								GraphSetDot(self,nodeNow,X,Y)
								lastX = X
								lastY = Y
								
								if nodeNow > 10000 then
									ExRT.F.dprint("Graph: Error: Too much nodes")
									return
								end
							end
						end
						nodeNow = nodeNow + 1
						GraphSetDot(self,nodeNow,tX,tY > self.height and self.height or tY)
						
						Xnow = x
						Ynow = y
					end
					if self.isLines and not enableNodes then
						if x ~= Xnow or y ~= Ynow then
							local fX,fY = (Xnow - minX)/(maxX - minX)*self.width,(Ynow - minY)/(maxY - minY)*self.height
							local tX,tY = (x - minX)/(maxX - minX)*self.width,(y - minY)/(maxY - minY)*self.height
							
							tY = tY > self.height and self.height or tY
							fY = fY > self.height and self.height or fY
							
							nodeNow = nodeNow + 1
							GraphSetLine(self,nodeNow,fX,fY,tX,tY)
							GraphSetColor(self,nodeNow,colorR,colorG,colorB,colorA)
							Xnow = x
							Ynow = y
						end
					end
					self.tooltipsData[k][#self.tooltipsData[k] + 1] = {(Xnow - minX)/(maxX - minX)*self.width,Ynow,i,(maxY - Ynow)/(maxY - minY)*self.height,self.data[k][i][3],self.data[k][i][4],self.data[k][i][5]}
				end
			end
		end
		ExRT.F.dprint("Graph: Nodes count:",nodeNow)
		return true
	end
	local function GraphReload(self)
		local minX,maxX,minY,maxY = nil
		local isZoom = self.ZoomMinX and self.ZoomMaxX
		for k=1,#self.data do
			for i=1,#self.data[k],self.step do
				local x = self.data[k][i][1]
				local steps = 1
				for j=1,(self.step-1) do
					if self.data[k][i+j] then
						x=x+self.data[k][i+j][1]
						steps = steps + 1
					end
				end
				x = x / steps
				if not minX then
					minX = x
					maxX = x
				else
					minX = min(minX,x)
					maxX = max(maxX,x)
				end
				local y = self.data[k][i][2]
				steps = 1
				for j=1,(self.step-1) do
					if self.data[k][i+j] then
						y=y+self.data[k][i+j][2]
						steps = steps + 1
					end
				end
				y = y / steps
				if not isZoom or (x >= self.ZoomMinX and x <= self.ZoomMaxX) then
					if not minY then
						minY = y
						maxY = y
					else
						minY = min(minY,y)
						maxY = max(maxY,y)
					end
				end
			end
		end
		
		if self.isZeroMin then
			minX = min(minX or 0,0)
			minY = min(minY or 0,0)
		end
		
		if minY == maxY then
			maxY = minY + 1
		end
		if minX == maxX then
			maxX = minX + 1
		end
		if self.ZoomMinX and self.ZoomMaxX and maxX then
			minX = max(minX,self.ZoomMinX)
			maxX = min(maxX,self.ZoomMaxX)
		end
		
		if self.ZoomMaxY and maxY then
			maxY = self.ZoomMaxY
		end
		
		self.range = {
			minX = minX,
			maxX = maxX,
			minY = minY,
			maxY = maxY,		
		}
		ExRT.F.dprint("Graph: minX,maxX,minY,maxY:",minX,maxX,minY,maxY)
		
		if maxY then
			self.MaxTextY:SetText(maxY < 1000 and (maxY % 1 == 0 and tostring(maxY) or format("%.1f",maxY)) or ExRT.F.shortNumber(maxY))
			self.MaxTextYButton:SetWidth(self.MaxTextY:GetStringWidth())
			self.MaxTextYButton:Show()
		else
			self.MaxTextY:SetText("")
			self.MaxTextYButton:Hide()
		end
		
		local result = GraphReload_BuildNodes(self,minX,minY,maxX,maxY,0.02)
		if not result then
			result = GraphReload_BuildNodes(self,minX,minY,maxX,maxY,0.04)			--Lower x step
		end
		if not result then
			result = GraphReload_BuildNodes(self,minX,minY,maxX,maxY,0.08,true)		--Stop using dots
		end
		if not result then
			print("|cffff0000Exorsus Raid Tools:|r Graph probably shows incorrect")
		end
		
		if self.ZoomMinX and self.ZoomMaxX then
			self.ResetZoom:Show()
		else
			self.ResetZoom:Hide()
		end
		self.ZoomMaxY = nil
	end
	local function GraphOnUpdate(self,elapsed)
		local x,y = ExRT.F.GetCursorPos(self)
		if ExRT.F.IsInFocus(self,x,y) then
			if #self.tooltipsData == 1 then
				local Y,X,_posY,xText,yText,comment = nil
				for k=1,#self.tooltipsData do
					for i=#self.tooltipsData[k],1,-1 do
						if self.tooltipsData[k][i][1] < x then
							Y = self.tooltipsData[k][i][2]
							X = self.tooltipsData[k][i][3]
							_posY = self.tooltipsData[k][i][4]
							xText = self.tooltipsData[k][i][5]
							yText = self.tooltipsData[k][i][6]
							comment = self.tooltipsData[k][i][7]
							break
						end
					end
				end
				if Y then
					_posY = -_posY
					if _posY > 0 then
						_posY = 0
					end
					GameTooltip:SetOwner(self, "ANCHOR_LEFT",x,_posY)
					GameTooltip:SetText(xText or ExRT.mds.Round(X))
					GameTooltip:AddLine((self.data[1].name and self.data[1].name..": " or "")..(yText or ExRT.mds.Round(Y)))
					if comment then
						GameTooltip:AddLine(comment)
					end
					GameTooltip:Show()
					if self.OnUpdateTooltip then
						self:OnUpdateTooltip(true,X,Y)
					end
				else
					GameTooltip_Hide()
					if self.OnUpdateTooltip then
						self:OnUpdateTooltip(false,X,Y)
					end
				end
			else
				GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
				local lines = false
				local isXadded = false
				for k=1,#self.tooltipsData do
					for i=#self.tooltipsData[k],1,-1 do
						if self.tooltipsData[k][i][1] < x then
							local y = self.tooltipsData[k][i][2]
							local x = self.tooltipsData[k][i][3]
							local xText = self.tooltipsData[k][i][5]
							local yText = self.tooltipsData[k][i][6]
							local comment = self.tooltipsData[k][i][7]
							if not isXadded then
								GameTooltip:AddLine(xText or ExRT.mds.Round(x))
								isXadded = true
							end
							
							GameTooltip:AddLine((self.data[k].name and self.data[k].name..": " or "")..(yText or ExRT.mds.Round(y))..(comment and " ("..comment..")" or ""),self.data[k].r or Graph_DefColors[k] and Graph_DefColors[k].r,self.data[k].g or Graph_DefColors[k] and Graph_DefColors[k].g,self.data[k].b or Graph_DefColors[k] and Graph_DefColors[k].b)
							
							lines = true
							break
						end
					end
				end
				
				if lines then
					GameTooltip:Show()
				else
					GameTooltip_Hide()
				end
			end
		end
		if self.mouseDowned then
			local width = x - self.mouseDowned
			if width > 0 then
				width = min(width,self:GetWidth()-self.mouseDowned)
				self.selectingTexture:SetWidth(width)
				self.selectingTexture:SetPoint("TOPLEFT",self,"TOPLEFT", self.mouseDowned ,0)
			elseif width < 0 then
				width = -width
				width = min(width,self.mouseDowned)
				self.selectingTexture:SetWidth(width)
				self.selectingTexture:SetPoint("TOPLEFT",self,"TOPLEFT", self.mouseDowned-width,0)
			else
				self.selectingTexture:SetWidth(1)
			end
		end
	end
	local function GraphOnMouseDown(self)
		if not self.range or not self.range.maxX then
			return
		end
		self.mouseDowned = ExRT.F.GetCursorPos(self)
		self.selectingTexture:SetPoint("TOPLEFT",self,"TOPLEFT", self.mouseDowned ,0)
		self.selectingTexture:SetWidth(1)
		self.selectingTexture:Show()
	end
	local function GraphOnMouseUp(self,isLeave)
		if isLeave == "LEAVE" then
			self.selectingTexture:Hide()
			self.mouseDowned = nil
			return
		end
		if not self.mouseDowned then
			return
		end
		local x = ExRT.F.GetCursorPos(self)
		if x < self.mouseDowned then
			x , self.mouseDowned = self.mouseDowned , x
		end
		
		local xLen = self.range.maxX - self.range.minX
		local width = self:GetWidth()
		local start = ExRT.F.Round(self.mouseDowned / width * xLen + self.range.minX)
		local ending = ExRT.F.Round(x / width * xLen + self.range.minX)
		
		self.selectingTexture:Hide()
		self.mouseDowned = nil
		
		if self.Zoom then
			self:Zoom(start,ending)
		end
	end
	local function GraphResetZoom(self)
		local parent = self:GetParent()
		parent.ZoomMinX = nil
		parent.ZoomMaxX = nil
		parent:Reload()
	end	
	local function GraphCreateZoom(self)
		self.selectingTexture = self:CreateTexture(nil, "BACKGROUND",nil,2)
		self.selectingTexture:SetTexture(0, 0.65, 0.9, .7)
		self.selectingTexture:SetHeight(self:GetHeight())
		self.selectingTexture:Hide()
		
		self.ResetZoom = ExRT.lib.CreateButton(self,170,20,"TOPRIGHT",-2,-2,ExRT.L.BossWatcherGraphZoomReset,nil,nil,"ExRTButtonModernTemplate")
		self.ResetZoom:SetScript("OnClick",GraphResetZoom)
		self.ResetZoom:Hide()
		
		self:SetScript("OnMouseDown",GraphOnMouseDown)
		self:SetScript("OnMouseUp",GraphOnMouseUp)
	end
	local function GraphOnLeave(self)
		GameTooltip_Hide()
		GraphOnMouseUp(self,"LEAVE")
		self:SetScript("OnUpdate",nil)
	end
	local function GraphOnEnter(self)
		self:SetScript("OnUpdate",GraphOnUpdate)
	end
	local function GraphSetMaxY(self,y)
		self.ZoomMaxY = nil
		if y then
			self.ZoomMaxY = tonumber(y)
			if self.ZoomMaxY == 0 then
				self.ZoomMaxY = nil
			end
		end
		self:Reload()
	end
	local function GraphTextYButtonOnClick(self)
		local parent = self:GetParent()
		ExRT.F.ShowInput("Set Max Y",GraphSetMaxY,parent,true)
	end
	local function GraphTextYButtonOnEnter(self)
		local parent = self:GetParent()
	  	parent.MaxTextY:SetTextColor(1,.5,.5,1)
	end
	local function GraphTextYButtonOnLeave(self)
	  	local parent = self:GetParent()
	  	parent.MaxTextY:SetTextColor(1,1,1,1)
	end
	function ExRT.lib.CreateGraph(parent,width,height,relativePoint,x,y,enableZoom)
		local self = CreateFrame(enableZoom and "Button" or "Frame",nil,parent)
		self:SetPoint(relativePoint or "TOPLEFT",parent, x, y)
		self:SetSize(width,height)
		
		self.width = width
		self.height = height
		self.step = 1
		self.isZeroMin = true
		
		self.axisX = self:CreateTexture(nil, "BACKGROUND")
		self.axisX:SetSize(width,2)
		self.axisX:SetPoint("TOPLEFT",self,"BOTTOMLEFT",0,0)
		self.axisX:SetTexture(0.6, 0.6, 1, 1)
		
		self.axisY = self:CreateTexture(nil, "BACKGROUND")
		self.axisY:SetSize(2,height)
		self.axisY:SetPoint("BOTTOMLEFT",self,"BOTTOMLEFT",0,0)
		self.axisY:SetTexture(0.6, 0.6, 1, 1)
		
		self.MaxTextY = ExRT.lib.CreateText(self,0,0,nil,0,0,"RIGHT","TOP",nil,10,"",nil,1,1,1)
		self.MaxTextY:SetNewPoint("TOPRIGHT",self.axisY,"TOPLEFT",-2,-2)
		
		self.MaxTextYButton = CreateFrame("Button",nil,self)
		self.MaxTextYButton:SetPoint("TOPRIGHT",self.axisY,"TOPLEFT",-2,-2)
		self.MaxTextYButton:SetHeight(10)
		self.MaxTextYButton:SetScript("OnClick",GraphTextYButtonOnClick)
		self.MaxTextYButton:SetScript("OnEnter",GraphTextYButtonOnEnter)
		self.MaxTextYButton:SetScript("OnLeave",GraphTextYButtonOnLeave)
		self.MaxTextYButton:Hide()
		
		self.graph = {}
		self.dots = {}
		self.lines = {}
		self.isDots = false
		self.isLines = true
		self.tooltipsData = {}
		self.Reload = GraphReload
		--self:SetScript("OnUpdate",GraphOnUpdate)
		self:SetScript("OnEnter",GraphOnEnter)
		self:SetScript("OnLeave",GraphOnLeave)
		
		if enableZoom then
			GraphCreateZoom(self)
		end
			
		return self
	end
end

do
	local function MultilineEditBoxOnTextChanged(self,...)
		local parent = self.Parent
		local height = self:GetHeight()
		parent:SetNewHeight( max( height,parent:GetHeight() ) )
		if not self.LastHeight or self.LastHeight ~= height then
			local _,max = parent.ScrollBar:GetMinMaxValues()
			parent.ScrollBar:SetValue(max)
		end
		self.LastHeight = height
		if parent.OnTextChanged then
			parent.OnTextChanged(self,...)
		elseif self.OnTextChanged then
			self:OnTextChanged(...)
		end
	end
	local function MultilineEditBoxGetTextHighlight(self)
		local text,cursor = self:GetText(),self:GetCursorPosition()
		self:Insert("")
		local textNew, cursorNew = self:GetText(), self:GetCursorPosition()
		self:SetText( text )
		self:SetCursorPosition( cursor )
		local Start, End = cursorNew, #text - ( #textNew - cursorNew )
		self:HighlightText( Start, End )
		return Start, End
	end
	local function MultilineEditBoxOnFrameClick(self)
		self:GetParent().EditBox:SetFocus()
	end
	function ExRT.lib.CreateMultilineEditBox(parent,width,height,relativePoint,x,y,isModern)
		local self = ExRT.lib.CreateScrollFrame(parent,width,height,relativePoint,x,y,height,isModern)
		self:SetBackdropColor(0,0,0,.8)
		
		self.EditBox = ExRT.lib.CreateEditBox(self.C,0,0,nil,0,0,nil,nil,nil,true)
		self.EditBox:ClearAllPoints()
		self.EditBox:SetPoint("TOPLEFT",self.C,0,0)
		self.EditBox:SetPoint("TOPRIGHT",self.C,0,0)
		
		self.EditBox.Parent = self
		self.EditBox:SetMultiLine(true) 
		
		self.EditBox:SetBackdropColor(0, 0, 0, 0)
		self.EditBox:SetBackdropBorderColor(0, 0, 0, 0)
		self.EditBox:SetTextInsets(5,5,2,2)
		
		
		self.EditBox:SetScript("OnTextChanged",MultilineEditBoxOnTextChanged)
		
		self.C:SetScript("OnMouseDown",MultilineEditBoxOnFrameClick)
		
		self.SetNewPoint = ExRT.lib.SetPoint
		self.EditBox.GetTextHighlight = MultilineEditBoxGetTextHighlight
		
		return self
	end
end


--Q = ExRT.lib.CreateText(UIParent,0,0,"CENTER",0,0,nil,nil,nil,12,"Tøff",nil,1,1,1,1)

--/run Q.texture:SetTexCoord(0.1,0.9,0.1,0.9)