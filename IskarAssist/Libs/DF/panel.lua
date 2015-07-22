
local DF = _G ["DetailsFramework"]
local _

if (not DF) then -- or not DetailsFrameWorkLoadValid
	return 
end

--> lua locals
local _rawset = rawset --> lua local
local _rawget = rawget --> lua local
local _setmetatable = setmetatable --> lua local
local _unpack = unpack --> lua local
local _type = type --> lua local
local _math_floor = math.floor --> lua local
local loadstring = loadstring --> lua local

local cleanfunction = function() end
local PanelMetaFunctions = {}
local APIFrameFunctions

local simple_panel_counter = 1

------------------------------------------------------------------------------------------------------------
--> metatables

	PanelMetaFunctions.__call = function (_table, value)
		--> nothing to do
		return true
	end

------------------------------------------------------------------------------------------------------------
--> members

	--> tooltip
	local gmember_tooltip = function (_object)
		return _object:GetTooltip()
	end
	--> shown
	local gmember_shown = function (_object)
		return _object:IsShown()
	end
	--> backdrop color
	local gmember_color = function (_object)
		return _object.frame:GetBackdropColor()
	end
	--> backdrop table
	local gmember_backdrop = function (_object)
		return _object.frame:GetBackdrop()
	end
	--> frame width
	local gmember_width = function (_object)
		return _object.frame:GetWidth()
	end
	--> frame height
	local gmember_height = function (_object)
		return _object.frame:GetHeight()
	end
	--> locked
	local gmember_locked = function (_object)
		return _rawget (_object, "is_locked")
	end

	local get_members_function_index = {
		["tooltip"] = gmember_tooltip,
		["shown"] = gmember_shown,
		["color"] = gmember_color,
		["backdrop"] = gmember_backdrop,
		["width"] = gmember_width,
		["height"] = gmember_height,
		["locked"] = gmember_locked,
	}
	
	PanelMetaFunctions.__index = function (_table, _member_requested)

		local func = get_members_function_index [_member_requested]
		if (func) then
			return func (_table, _member_requested)
		end
		
		local fromMe = _rawget (_table, _member_requested)
		if (fromMe) then
			return fromMe
		end
		
		return PanelMetaFunctions [_member_requested]
	end
	

	--> tooltip
	local smember_tooltip = function (_object, _value)
		return _object:SetTooltip (_value)
	end
	--> show
	local smember_show = function (_object, _value)
		if (_value) then
			return _object:Show()
		else
			return _object:Hide()
		end
	end
	--> hide
	local smember_hide = function (_object, _value)
		if (not _value) then
			return _object:Show()
		else
			return _object:Hide()
		end
	end
	--> backdrop color
	local smember_color = function (_object, _value)
		local _value1, _value2, _value3, _value4 = DF:ParseColors (_value)
		return _object:SetBackdropColor (_value1, _value2, _value3, _value4)
	end
	--> frame width
	local smember_width = function (_object, _value)
		return _object.frame:SetWidth (_value)
	end
	--> frame height
	local smember_height = function (_object, _value)
		return _object.frame:SetHeight (_value)
	end

	--> locked
	local smember_locked = function (_object, _value)
		if (_value) then
			_object.frame:SetMovable (false)
			return _rawset (_object, "is_locked", true)
		else
			_object.frame:SetMovable (true)
			_rawset (_object, "is_locked", false)
			return
		end
	end	
	
	--> backdrop
	local smember_backdrop = function (_object, _value)
		return _object.frame:SetBackdrop (_value)
	end
	
	--> close with right button
	local smember_right_close = function (_object, _value)
		return _rawset (_object, "rightButtonClose", _value)
	end
	
	local set_members_function_index = {
		["tooltip"] = smember_tooltip,
		["show"] = smember_show,
		["hide"] = smember_hide,
		["color"] = smember_color,
		["backdrop"] = smember_backdrop,
		["width"] = smember_width,
		["height"] = smember_height,
		["locked"] = smember_locked,
		["close_with_right"] = smember_right_close,
	}
	
	PanelMetaFunctions.__newindex = function (_table, _key, _value)
		local func = set_members_function_index [_key]
		if (func) then
			return func (_table, _value)
		else
			return _rawset (_table, _key, _value)
		end
	end

------------------------------------------------------------------------------------------------------------
--> methods

--> right click to close
	function PanelMetaFunctions:CreateRightClickLabel (textType, w, h, close_text)
		local text
		w = w or 20
		h = h or 20
		
		if (close_text) then
			text = close_text
		else
			if (textType) then
				textType = string.lower (textType)
				if (textType == "short") then
					text = "close window"
				elseif (textType == "medium") then
					text = "close window"
				elseif (textType == "large") then
					text = "close window"
				end
			else
				text = "close window"
			end
		end
		
		return DF:NewLabel (self, _, "$parentRightMouseToClose", nil, "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:"..w..":"..h..":0:1:512:512:8:70:328:409|t " .. text)
	end

--> show & hide
	function PanelMetaFunctions:Show()
		self.frame:Show()
		
	end
	function PanelMetaFunctions:Hide()
		self.frame:Hide()
		
	end

-- setpoint
	function PanelMetaFunctions:SetPoint (v1, v2, v3, v4, v5)
		v1, v2, v3, v4, v5 = DF:CheckPoints (v1, v2, v3, v4, v5, self)
		if (not v1) then
			print ("Invalid parameter for SetPoint")
			return
		end
		return self.widget:SetPoint (v1, v2, v3, v4, v5)
	end
	
-- sizes 
	function PanelMetaFunctions:SetSize (w, h)
		if (w) then
			self.frame:SetWidth (w)
		end
		if (h) then
			self.frame:SetHeight (h)
		end
	end
	
-- clear
	function PanelMetaFunctions:HideWidgets()
		for widgetName, widgetSelf in pairs (self) do 
			if (type (widgetSelf) == "table" and widgetSelf.dframework) then
				widgetSelf:Hide()
			end
		end
	end

-- backdrop
	function PanelMetaFunctions:SetBackdrop (background, edge, tilesize, edgesize, tile, left, right, top, bottom)
	
		if (_type (background) == "boolean" and not background) then
			return self.frame:SetBackdrop (nil)
			
		elseif (_type (background) == "table") then
			self.frame:SetBackdrop (background)
			
		else
			local currentBackdrop = self.frame:GetBackdrop() or {edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", tile=true, tileSize=16, edgeSize=16, insets={left=1, right=0, top=0, bottom=0}}
			currentBackdrop.bgFile = background or currentBackdrop.bgFile
			currentBackdrop.edgeFile = edgeFile or currentBackdrop.edgeFile
			currentBackdrop.tileSize = tilesize or currentBackdrop.tileSize
			currentBackdrop.edgeSize = edgesize or currentBackdrop.edgeSize
			currentBackdrop.tile = tile or currentBackdrop.tile
			currentBackdrop.insets.left = left or currentBackdrop.insets.left
			currentBackdrop.insets.right = left or currentBackdrop.insets.right
			currentBackdrop.insets.top = left or currentBackdrop.insets.top
			currentBackdrop.insets.bottom = left or currentBackdrop.insets.bottom
			self.frame:SetBackdrop (currentBackdrop)
		end
	end
	
-- backdropcolor
	function PanelMetaFunctions:SetBackdropColor (color, arg2, arg3, arg4)
		if (arg2) then
			self.frame:SetBackdropColor (color, arg2, arg3, arg4 or 1)
			self.frame.Gradient.OnLeave = {color, arg2, arg3, arg4 or 1}
		else
			local _value1, _value2, _value3, _value4 = DF:ParseColors (color)
			self.frame:SetBackdropColor (_value1, _value2, _value3, _value4)
			self.frame.Gradient.OnLeave = {_value1, _value2, _value3, _value4}
		end
	end
	
-- border color	
	function PanelMetaFunctions:SetBackdropBorderColor (color, arg2, arg3, arg4)
		if (arg2) then
			return self.frame:SetBackdropBorderColor (color, arg2, arg3, arg4)
		end
		local _value1, _value2, _value3, _value4 = DF:ParseColors (color)
		self.frame:SetBackdropBorderColor (_value1, _value2, _value3, _value4)
	end
	
-- gradient colors
	function PanelMetaFunctions:SetGradient (FadeType, color)
		local _value1, _value2, _value3, _value4 = DF:ParseColors (color)
		if (FadeType == "OnEnter") then
			self.frame.Gradient.OnEnter = {_value1, _value2, _value3, _value4}
		elseif (FadeType == "OnLeave") then
			self.frame.Gradient.OnLeave = {_value1, _value2, _value3, _value4}
		end
	end
	
-- tooltip
	function PanelMetaFunctions:SetTooltip (tooltip)
		if (tooltip) then
			return _rawset (self, "have_tooltip", tooltip)
		else
			return _rawset (self, "have_tooltip", nil)
		end
	end
	function PanelMetaFunctions:GetTooltip()
		return _rawget (self, "have_tooltip")
	end

-- frame levels
	function PanelMetaFunctions:GetFrameLevel()
		return self.widget:GetFrameLevel()
	end
	function PanelMetaFunctions:SetFrameLevel (level, frame)
		if (not frame) then
			return self.widget:SetFrameLevel (level)
		else
			local framelevel = frame:GetFrameLevel (frame) + level
			return self.widget:SetFrameLevel (framelevel)
		end
	end

-- frame stratas
	function PanelMetaFunctions:SetFrameStrata()
		return self.widget:GetFrameStrata()
	end
	function PanelMetaFunctions:SetFrameStrata (strata)
		if (_type (strata) == "table") then
			self.widget:SetFrameStrata (strata:GetFrameStrata())
		else
			self.widget:SetFrameStrata (strata)
		end
	end
	
-- enable and disable gradients
	function PanelMetaFunctions:DisableGradient()
		self.GradientEnabled = false
	end
	function PanelMetaFunctions:EnableGradient()
		self.GradientEnabled = true
	end

--> hooks
	function PanelMetaFunctions:SetHook (hookType, func)
		if (func) then
			_rawset (self, hookType.."Hook", func)
		else
			_rawset (self, hookType.."Hook", nil)
		end
	end

------------------------------------------------------------------------------------------------------------
--> scripts
	
	local OnEnter = function (frame)
		if (frame.MyObject.OnEnterHook) then
			local interrupt = frame.MyObject.OnEnterHook (frame, frame.MyObject)
			if (interrupt) then
				return
			end
		end
		
		if (frame.MyObject.have_tooltip) then 
			GameCooltip2:Reset()
			GameCooltip2:SetType ("tooltip")
			GameCooltip2:SetColor ("main", "transparent")
			GameCooltip2:AddLine (frame.MyObject.have_tooltip)
			GameCooltip2:SetOwner (frame)
			GameCooltip2:ShowCooltip()
		end
	end

	local OnLeave = function (frame)
		if (frame.MyObject.OnLeaveHook) then
			local interrupt = frame.MyObject.OnLeaveHook (frame, frame.MyObject)
			if (interrupt) then
				return
			end
		end
		
		if (frame.MyObject.have_tooltip) then 
			GameCooltip2:ShowMe (false)
		end
		
	end
	
	local OnHide = function (frame)
		if (frame.MyObject.OnHideHook) then
			local interrupt = frame.MyObject.OnHideHook (frame, frame.MyObject)
			if (interrupt) then
				return
			end
		end
	end
	
	local OnShow = function (frame)
		if (frame.MyObject.OnShowHook) then
			local interrupt = frame.MyObject.OnShowHook (frame, frame.MyObject)
			if (interrupt) then
				return
			end
		end
	end
	
	local OnMouseDown = function (frame, button)
		if (frame.MyObject.OnMouseDownHook) then
			local interrupt = frame.MyObject.OnMouseDownHook (frame, button, frame.MyObject)
			if (interrupt) then
				return
			end
		end
		
		if (frame.MyObject.container == UIParent) then
			if (not frame.isLocked and frame:IsMovable()) then
				frame.isMoving = true
				frame:StartMoving()
			end
		
		elseif (not frame.MyObject.container.isLocked and frame.MyObject.container:IsMovable()) then
			if (not frame.isLocked and frame:IsMovable()) then
				frame.MyObject.container.isMoving = true
				frame.MyObject.container:StartMoving()
			end
		end
		

	end
	
	local OnMouseUp = function (frame, button)
		if (frame.MyObject.OnMouseUpHook) then
			local interrupt = frame.MyObject.OnMouseUpHook (frame, button, frame.MyObject)
			if (interrupt) then
				return
			end
		end
		
		if (button == "RightButton" and frame.MyObject.rightButtonClose) then
			frame.MyObject:Hide()
		end
		
		if (frame.MyObject.container == UIParent) then
			if (frame.isMoving) then
				frame:StopMovingOrSizing()
				frame.isMoving = false
			end
		else
			if (frame.MyObject.container.isMoving) then
				frame.MyObject.container:StopMovingOrSizing()
				frame.MyObject.container.isMoving = false
			end
		end
	end
	
------------------------------------------------------------------------------------------------------------
--> object constructor
function DF:CreatePanel (parent, w, h, backdrop, backdropcolor, bordercolor, member, name)
	return DF:NewPanel (parent, parent, name, member, w, h, backdrop, backdropcolor, bordercolor)
end

function DF:NewPanel (parent, container, name, member, w, h, backdrop, backdropcolor, bordercolor)

	if (not name) then
		name = "DetailsFrameworkPanelNumber" .. DF.PanelCounter
		DF.PanelCounter = DF.PanelCounter + 1

	elseif (not parent) then
		parent = UIParent
	end
	if (not container) then
		container = parent
	end
	
	if (name:find ("$parent")) then
		name = name:gsub ("$parent", parent:GetName())
	end
	
	local PanelObject = {type = "panel", dframework = true}
	
	if (member) then
		parent [member] = PanelObject
	end
	
	if (parent.dframework) then
		parent = parent.widget
	end
	if (container.dframework) then
		container = container.widget
	end

	
	--> default members:
		--> hooks
		PanelObject.OnEnterHook = nil
		PanelObject.OnLeaveHook = nil
		PanelObject.OnHideHook = nil
		PanelObject.OnShowHook = nil
		PanelObject.OnMouseDownHook = nil
		PanelObject.OnMouseUpHook = nil
		--> misc
		PanelObject.is_locked = true
		PanelObject.GradientEnabled = true
		PanelObject.container = container
		PanelObject.rightButtonClose = false
	
	PanelObject.frame = CreateFrame ("frame", name, parent, "DetailsFrameworkPanelTemplate")
	PanelObject.widget = PanelObject.frame
	
	if (not APIFrameFunctions) then
		APIFrameFunctions = {}
		local idx = getmetatable (PanelObject.frame).__index
		for funcName, funcAddress in pairs (idx) do 
			if (not PanelMetaFunctions [funcName]) then
				PanelMetaFunctions [funcName] = function (object, ...)
					local x = loadstring ( "return _G."..object.frame:GetName()..":"..funcName.."(...)")
					return x (...)
				end
			end
		end
	end
	
	PanelObject.frame:SetWidth (w or 100)
	PanelObject.frame:SetHeight (h or 100)
	
	PanelObject.frame.MyObject = PanelObject
	
	--> hooks
		PanelObject.frame:SetScript ("OnEnter", OnEnter)
		PanelObject.frame:SetScript ("OnLeave", OnLeave)
		PanelObject.frame:SetScript ("OnHide", OnHide)
		PanelObject.frame:SetScript ("OnShow", OnShow)
		PanelObject.frame:SetScript ("OnMouseDown", OnMouseDown)
		PanelObject.frame:SetScript ("OnMouseUp", OnMouseUp)
		
	_setmetatable (PanelObject, PanelMetaFunctions)

	if (backdrop) then
		PanelObject:SetBackdrop (backdrop)
	elseif (_type (backdrop) == "boolean") then
		PanelObject.frame:SetBackdrop (nil)
	end
	
	if (backdropcolor) then
		PanelObject:SetBackdropColor (backdropcolor)
	end
	
	if (bordercolor) then
		PanelObject:SetBackdropBorderColor (bordercolor)
	end

	return PanelObject
end

------------fill panel

local button_on_enter = function (self)
	self.MyObject._icon:SetBlendMode ("ADD")
end
local button_on_leave = function (self)
	self.MyObject._icon:SetBlendMode ("BLEND")
end

function DF:CreateFillPanel (parent, rows, name, member, w, h, total_lines, fill_row, autowidth, options)
	return DF:NewFillPanel (parent, rows, name, member, w, h, total_lines, fill_row, autowidth, options)
end

function DF:NewFillPanel (parent, rows, name, member, w, h, total_lines, fill_row, autowidth, options)
	
	local panel = DF:NewPanel (parent, parent, name, member, w, h)
	panel.backdrop = nil
	
	options = options or {rowheight = 20}
	panel.rows = {}

	for index, t in ipairs (rows) do 
		local thisrow = DF:NewPanel (panel, panel, "$parentHeader_" .. name .. index, nil, 1, 20)
		thisrow.backdrop = {bgFile = [[Interface\DialogFrame\UI-DialogBox-Gold-Background]]}
		thisrow.color = "silver"
		thisrow.type = t.type
		thisrow.func = t.func
		thisrow.name = t.name
		thisrow.notext = t.notext
		thisrow.icon = t.icon
		thisrow.iconalign = t.iconalign
		
		local text = DF:NewLabel (thisrow, nil, name .. "$parentLabel", "text")
		text:SetPoint ("left", thisrow, "left", 2, 0)
		text:SetText (t.name)

		tinsert (panel.rows, thisrow)
	end

	local cur_width = 0
	local row_width = w / #rows
	
	local anchors = {}
	
	for index, row in ipairs (panel.rows) do
		if (autowidth) then
			row:SetWidth (row_width)
			row:SetPoint ("topleft", panel, "topleft", cur_width, 0)
			tinsert (anchors, cur_width)
			cur_width = cur_width + row_width + 1
		else
			row:SetPoint ("topleft", panel, "topleft", cur_width, 0)
			row.width = rows [index].width
			tinsert (anchors, cur_width)
			cur_width = cur_width + rows [index].width + 1
		end
	end
	
	if (autowidth) then
		panel.rows [#panel.rows]:SetWidth (row_width - #rows + 1)
	else
		panel.rows [#panel.rows]:SetWidth (rows [#rows].width - #rows + 1)
	end
	
	local refresh_fillbox = function (self)
		local offset = FauxScrollFrame_GetOffset (self)
		local filled_lines = total_lines()
		
		for index = 1, #self.lines do
		
			local row = self.lines [index]
			if (index <= filled_lines) then
			
				local real_index = index + offset
			
				local results = fill_row (real_index)
				
				if (results [1]) then
				
					row:Show()
					
					for i = 1, #row.row_widgets do
					
						row.row_widgets [i].index = real_index
						
						if (panel.rows [i].type == "icon") then

							local result = results [i]:gsub (".-%\\", "")
							row.row_widgets [i]._icon.texture = results [i]
						
						elseif (panel.rows [i].type == "button") then
						
							if (type (results [i]) == "table") then
							
								if (results [i].text) then
									row.row_widgets [i]:SetText (results [i].text)
								end
								
								if (results [i].icon) then
									row.row_widgets [i]._icon:SetTexture (results [i].icon)
								end
								
								if (results [i].func) then
									row.row_widgets [i]:SetClickFunction (results [i].func, real_index, results [i].value)
								end

							else
								row.row_widgets [i]:SetText (results [i])
							end
							
						else
							--> text
							row.row_widgets [i]:SetText (results [i])
							if (panel.rows [i].type == "entry") then
								row.row_widgets [i]:SetCursorPosition (0)
							end
							
						end
					end
					
				else
					row:Hide()
					for i = 1, #row.row_widgets do
						row.row_widgets [i]:SetText ("")
						if (panel.rows [i].type == "icon") then
							row.row_widgets [i]._icon.texture = ""
						end
					end
				end
			else
				row:Hide()
				for i = 1, #row.row_widgets do
					row.row_widgets [i]:SetText ("")
					if (panel.rows [i].type == "icon") then
						row.row_widgets [i]._icon.texture = ""
					end
				end
			end
		end
	end
	
	function panel:Refresh()
		local filled_lines = total_lines()
		local scroll_total_lines = #panel.scrollframe.lines
		local line_height = options.rowheight
		
		FauxScrollFrame_Update (panel.scrollframe, filled_lines, scroll_total_lines, line_height)
		refresh_fillbox (panel.scrollframe)
	end
	
	local scrollframe = CreateFrame ("scrollframe", name .. "Scroll", panel.widget, "FauxScrollFrameTemplate")
	scrollframe:SetScript ("OnVerticalScroll", function (self, offset) FauxScrollFrame_OnVerticalScroll (self, offset, 20, panel.Refresh) end)
	scrollframe:SetPoint ("topleft", panel.widget, "topleft", 0, -21)
	scrollframe:SetPoint ("topright", panel.widget, "topright", -23, -21)
	scrollframe:SetPoint ("bottomleft", panel.widget, "bottomleft")
	scrollframe:SetPoint ("bottomright", panel.widget, "bottomright", -23, 0)
	scrollframe:SetSize (w, h)
	panel.scrollframe = scrollframe
	scrollframe.lines = {}
	
	--create lines
	local size = options.rowheight
	local amount = math.floor (((h-21) / size))
	
	
	for i = 1, amount do
	
		local row = DF:NewPanel (panel, nil, "$parentRow_" .. i, nil, 1, size)
		row.backdrop = {bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]]}
		row.color = {1, 1, 1, .2}
		row:SetPoint ("topleft", scrollframe, "topleft", 0, (i-1) * size * -1)
		row:SetPoint ("topright", scrollframe, "topright", 0, (i-1) * size * -1)
		tinsert (scrollframe.lines, row)
		
		row.row_widgets = {}
		
		for o = 1, #rows do
		
			local _type = panel.rows [o].type

			if (_type == "text") then
			
				--> create text
				local text = DF:NewLabel (row, nil, name .. "$parentLabel" .. o, "text" .. o)
				text:SetPoint ("left", row, "left", anchors [o], 0)
				
				--> insert in the table
				tinsert (row.row_widgets, text)
			
			elseif (_type == "entry") then
			
				--> create editbox
				local editbox = DF:NewTextEntry (row, nil, "$parentEntry" .. o, "entry", panel.rows [o].width, 20, panel.rows [o].func, i, o)
				editbox.align = "left"
				editbox:SetHook ("OnEnterPressed", function()
					editbox.widget.focuslost = true
					editbox:ClearFocus()
					editbox.func (editbox.index, editbox.text)
					return true
				end) 
				editbox:SetPoint ("left", row, "left", anchors [o], 0)
				editbox:SetBackdrop ({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]], edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeSize = 1})
				editbox:SetBackdropColor (1, 1, 1, 0.1)
				editbox:SetBackdropBorderColor (1, 1, 1, 0.1)
				editbox.editbox.current_bordercolor = {1, 1, 1, 0.1}
				
				--> insert in the table
				tinsert (row.row_widgets, editbox)
			
			elseif (_type == "button") then
			
				--> create button
				local button = DF:NewButton (row, nil, "$parentButton" .. o, "button", panel.rows [o].width, 20)
				
				local func = function()
					panel.rows [o].func (button.index, o)
					panel:Refresh()
				end
				button:SetClickFunction (func)
				
				button:SetPoint ("left", row, "left", anchors [o], 0)
				
				--> create icon and the text
				local icon = DF:NewImage (button, nil, 20, 20)
				local text = DF:NewLabel (button)
				
				button._icon = icon
				button._text = text

				button:SetHook ("OnEnter", button_on_enter)
				button:SetHook ("OnLeave", button_on_leave)

				if (panel.rows [o].icon) then
					icon.texture = panel.rows [o].icon
					if (panel.rows [o].iconalign) then
						if (panel.rows [o].iconalign == "center") then
							icon:SetPoint ("center", button, "center")
						elseif (panel.rows [o].iconalign == "right") then
							icon:SetPoint ("right", button, "right")
						end
					else
						icon:SetPoint ("left", button, "left")
					end
				end
				
				if (panel.rows [o].name and not panel.rows [o].notext) then
					text:SetPoint ("left", icon, "right", 2, 0)
					text.text = panel.rows [o].name
				end

				--> inser in the table
				tinsert (row.row_widgets, button)
			
			elseif (_type == "icon") then
			
				--> create button and icon
				local iconbutton = DF:NewButton (row, nil, "$parentIconButton" .. o, "iconbutton", 22, 20)
				iconbutton:InstallCustomTexture()
				
				iconbutton:SetHook ("OnEnter", button_on_enter)
				iconbutton:SetHook ("OnLeave", button_on_leave)
				
				--iconbutton:InstallCustomTexture()
				local icon = DF:NewImage (iconbutton, nil, 20, 20, "artwork", nil, "_icon", "$parentIcon" .. o)
				iconbutton._icon = icon
				
				iconbutton:SetPoint ("left", row, "left", anchors [o] + ( (panel.rows [o].width - 22) / 2), 0)
				icon:SetPoint ("center", iconbutton, "center", 0, 0)
				
				--> set functions
				local function iconcallback (texture)
					iconbutton._icon.texture = texture
					panel.rows [o].func (iconbutton.index, texture)
				end
				
				iconbutton:SetClickFunction (function()
					DF:IconPick (iconcallback, true)
					return true
				end)
				
				--> insert in the table
				tinsert (row.row_widgets, iconbutton)
				
			end

		end
	end
	
	return panel
end


------------color pick
local color_pick_func = function()
	local r, g, b = ColorPickerFrame:GetColorRGB()
	local a = OpacitySliderFrame:GetValue()
	ColorPickerFrame:dcallback (r, g, b, a, ColorPickerFrame.dframe)
end
local color_pick_func_cancel = function()
	ColorPickerFrame:SetColorRGB (unpack (ColorPickerFrame.previousValues))
	local r, g, b = ColorPickerFrame:GetColorRGB()
	local a = OpacitySliderFrame:GetValue()
	ColorPickerFrame:dcallback (r, g, b, a, ColorPickerFrame.dframe)
end

function DF:ColorPick (frame, r, g, b, alpha, callback)

	ColorPickerFrame:ClearAllPoints()
	ColorPickerFrame:SetPoint ("bottomleft", frame, "topright", 0, 0)
	
	ColorPickerFrame.dcallback = callback
	ColorPickerFrame.dframe = frame
	
	ColorPickerFrame.func = color_pick_func
	ColorPickerFrame.opacityFunc = color_pick_func
	ColorPickerFrame.cancelFunc = color_pick_func_cancel
	
	ColorPickerFrame.opacity = alpha
	ColorPickerFrame.hasOpacity = alpha and true
	
	ColorPickerFrame.previousValues = {r, g, b}
	ColorPickerFrame:SetParent (UIParent)
	ColorPickerFrame:SetFrameStrata ("tooltip")
	ColorPickerFrame:SetColorRGB (r, g, b)
	ColorPickerFrame:Show()

end

------------icon pick
function DF:IconPick (callback, close_when_select)

	if (not DF.IconPickFrame) then 
	
		local string_lower = string.lower
	
		DF.IconPickFrame = CreateFrame ("frame", "DetailsFrameworkIconPickFrame", UIParent)
		tinsert (UISpecialFrames, "DetailsFrameworkIconPickFrame")
		DF.IconPickFrame:SetFrameStrata ("DIALOG")
		
		DF.IconPickFrame:SetPoint ("center", UIParent, "center")
		DF.IconPickFrame:SetWidth (350)
		DF.IconPickFrame:SetHeight (227)
		DF.IconPickFrame:EnableMouse (true)
		DF.IconPickFrame:SetMovable (true)
		DF.IconPickFrame:SetBackdrop ({bgFile = DF.folder .. "background", edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", 
		tile = true, tileSize = 32, edgeSize = 32, insets = {left = 5, right = 5, top = 5, bottom = 5}})
		
		DF.IconPickFrame:SetBackdropBorderColor (170/255, 170/255, 170/255)
		DF.IconPickFrame:SetBackdropColor (24/255, 24/255, 24/255, .8)
		DF.IconPickFrame:SetFrameLevel (1)
		
		DF.IconPickFrame.emptyFunction = function() end
		DF.IconPickFrame.callback = DF.IconPickFrame.emptyFunction
		
		DF.IconPickFrame.preview =  CreateFrame ("frame", nil, UIParent)
		DF.IconPickFrame.preview:SetFrameStrata ("tooltip")
		DF.IconPickFrame.preview:SetSize (76, 76)
		local preview_image = DF:NewImage (DF.IconPickFrame.preview, nil, 76, 76)
		preview_image:SetAllPoints (DF.IconPickFrame.preview)
		DF.IconPickFrame.preview.icon = preview_image
		DF.IconPickFrame.preview:Hide()
		
		DF.IconPickFrame.searchLabel =  DF:NewLabel (DF.IconPickFrame, nil, "$parentSearchBoxLabel", nil, "search:", font, size, color)
		DF.IconPickFrame.searchLabel:SetPoint ("topleft", DF.IconPickFrame, "topleft", 12, -20)
		DF.IconPickFrame.search = DF:NewTextEntry (DF.IconPickFrame, nil, "$parentSearchBox", nil, 140, 20)
		DF.IconPickFrame.search:SetPoint ("left", DF.IconPickFrame.searchLabel, "right", 2, 0)
		DF.IconPickFrame.search:SetHook ("OnTextChanged", function() 
			DF.IconPickFrame.searching = DF.IconPickFrame.search:GetText()
			if (DF.IconPickFrame.searching == "") then
				DF.IconPickFrameScroll:Show()
				DF.IconPickFrame.searching = nil
				DF.IconPickFrame.updateFunc()
			else
				DF.IconPickFrameScroll:Hide()
				FauxScrollFrame_SetOffset (DF.IconPickFrame, 1)
				DF.IconPickFrame.last_filter_index = 1
				DF.IconPickFrame.updateFunc()
			end
		end)
		
		--> close button
		local close_button = CreateFrame ("button", nil, DF.IconPickFrame, "UIPanelCloseButton")
		close_button:SetWidth (32)
		close_button:SetHeight (32)
		close_button:SetPoint ("TOPRIGHT", DF.IconPickFrame, "TOPRIGHT", -8, -7)
		close_button:SetFrameLevel (close_button:GetFrameLevel()+2)
		
		local MACRO_ICON_FILENAMES = {}
		DF.IconPickFrame:SetScript ("OnShow", function()
		
			MACRO_ICON_FILENAMES = {};
			MACRO_ICON_FILENAMES[1] = "INV_MISC_QUESTIONMARK";
			local index = 2;
		
			for i = 1, GetNumSpellTabs() do
				local tab, tabTex, offset, numSpells, _ = GetSpellTabInfo(i);
				offset = offset + 1;
				local tabEnd = offset + numSpells;
				for j = offset, tabEnd - 1 do
					--to get spell info by slot, you have to pass in a pet argument
					local spellType, ID = GetSpellBookItemInfo(j, "player"); 
					if (spellType ~= "FUTURESPELL") then
						local spellTexture = strupper(GetSpellBookItemTexture(j, "player"));
						if ( not string.match( spellTexture, "INTERFACE\\BUTTONS\\") ) then
							MACRO_ICON_FILENAMES[index] = gsub( spellTexture, "INTERFACE\\ICONS\\", "");
							index = index + 1;
						end
					end
					if (spellType == "FLYOUT") then
						local _, _, numSlots, isKnown = GetFlyoutInfo(ID);
						if (isKnown and numSlots > 0) then
							for k = 1, numSlots do 
								local spellID, overrideSpellID, isKnown = GetFlyoutSlotInfo(ID, k)
								if (isKnown) then
									MACRO_ICON_FILENAMES[index] = gsub( strupper(GetSpellTexture(spellID)), "INTERFACE\\ICONS\\", ""); 
									index = index + 1;
								end
							end
						end
					end
				end
			end
			
			GetLooseMacroItemIcons (MACRO_ICON_FILENAMES)
			GetLooseMacroIcons (MACRO_ICON_FILENAMES)
			GetMacroIcons (MACRO_ICON_FILENAMES)
			GetMacroItemIcons (MACRO_ICON_FILENAMES )
			
		end)
		
		DF.IconPickFrame:SetScript ("OnHide", function()
			MACRO_ICON_FILENAMES = nil;
			collectgarbage()
		end)
		
		DF.IconPickFrame.buttons = {}
		
		local OnClickFunction = function (self) 
			DF.IconPickFrame.callback (self.icon:GetTexture())
			if (DF.IconPickFrame.click_close) then
				close_button:Click()
			end
		end
		
		local onenter = function (self)
			DF.IconPickFrame.preview:SetPoint ("bottom", self, "top", 0, 2)
			DF.IconPickFrame.preview.icon:SetTexture (self.icon:GetTexture())
			DF.IconPickFrame.preview:Show()
			self.icon:SetBlendMode ("ADD")
		end
		local onleave = function (self)
			DF.IconPickFrame.preview:Hide()
			self.icon:SetBlendMode ("BLEND")
		end
		
		local backdrop = {bgFile = DF.folder .. "background", tile = true, tileSize = 16,
		insets = {left = 0, right = 0, top = 0, bottom = 0}, edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]], edgeSize = 10}
		
		for i = 0, 9 do 
			local newcheck = CreateFrame ("Button", "DetailsFrameworkIconPickFrameButton"..(i+1), DF.IconPickFrame)
			local image = newcheck:CreateTexture ("DetailsFrameworkIconPickFrameButton"..(i+1).."Icon", "overlay")
			newcheck.icon = image
			image:SetPoint ("topleft", newcheck, "topleft", 2, -2); image:SetPoint ("bottomright", newcheck, "bottomright", -2, 2)
			newcheck:SetSize (30, 28)
			newcheck:SetBackdrop (backdrop)
			
			newcheck:SetScript ("OnClick", OnClickFunction)
			newcheck.param1 = i+1
			
			newcheck:SetPoint ("topleft", DF.IconPickFrame, "topleft", 12 + (i*30), -40)
			newcheck:SetID (i+1)
			DF.IconPickFrame.buttons [#DF.IconPickFrame.buttons+1] = newcheck
			newcheck:SetScript ("OnEnter", onenter)
			newcheck:SetScript ("OnLeave", onleave)
		end
		for i = 11, 20 do
			local newcheck = CreateFrame ("Button", "DetailsFrameworkIconPickFrameButton"..i, DF.IconPickFrame)
			local image = newcheck:CreateTexture ("DetailsFrameworkIconPickFrameButton"..i.."Icon", "overlay")
			newcheck.icon = image
			image:SetPoint ("topleft", newcheck, "topleft", 2, -2); image:SetPoint ("bottomright", newcheck, "bottomright", -2, 2)
			newcheck:SetSize (30, 28)
			newcheck:SetBackdrop (backdrop)
			
			newcheck:SetScript ("OnClick", OnClickFunction)
			newcheck.param1 = i
			
			newcheck:SetPoint ("topleft", "DetailsFrameworkIconPickFrameButton"..(i-10), "bottomleft", 0, -1)
			newcheck:SetID (i)
			DF.IconPickFrame.buttons [#DF.IconPickFrame.buttons+1] = newcheck
			newcheck:SetScript ("OnEnter", onenter)
			newcheck:SetScript ("OnLeave", onleave)
		end
		for i = 21, 30 do 
			local newcheck = CreateFrame ("Button", "DetailsFrameworkIconPickFrameButton"..i, DF.IconPickFrame)
			local image = newcheck:CreateTexture ("DetailsFrameworkIconPickFrameButton"..i.."Icon", "overlay")
			newcheck.icon = image
			image:SetPoint ("topleft", newcheck, "topleft", 2, -2); image:SetPoint ("bottomright", newcheck, "bottomright", -2, 2)
			newcheck:SetSize (30, 28)
			newcheck:SetBackdrop (backdrop)
			
			newcheck:SetScript ("OnClick", OnClickFunction)
			newcheck.param1 = i
			
			newcheck:SetPoint ("topleft", "DetailsFrameworkIconPickFrameButton"..(i-10), "bottomleft", 0, -1)
			newcheck:SetID (i)
			DF.IconPickFrame.buttons [#DF.IconPickFrame.buttons+1] = newcheck
			newcheck:SetScript ("OnEnter", onenter)
			newcheck:SetScript ("OnLeave", onleave)
		end
		for i = 31, 40 do 
			local newcheck = CreateFrame ("Button", "DetailsFrameworkIconPickFrameButton"..i, DF.IconPickFrame)
			local image = newcheck:CreateTexture ("DetailsFrameworkIconPickFrameButton"..i.."Icon", "overlay")
			newcheck.icon = image
			image:SetPoint ("topleft", newcheck, "topleft", 2, -2); image:SetPoint ("bottomright", newcheck, "bottomright", -2, 2)
			newcheck:SetSize (30, 28)
			newcheck:SetBackdrop (backdrop)
			
			newcheck:SetScript ("OnClick", OnClickFunction)
			newcheck.param1 = i
			
			newcheck:SetPoint ("topleft", "DetailsFrameworkIconPickFrameButton"..(i-10), "bottomleft", 0, -1)
			newcheck:SetID (i)
			DF.IconPickFrame.buttons [#DF.IconPickFrame.buttons+1] = newcheck
			newcheck:SetScript ("OnEnter", onenter)
			newcheck:SetScript ("OnLeave", onleave)
		end
		for i = 41, 50 do 
			local newcheck = CreateFrame ("Button", "DetailsFrameworkIconPickFrameButton"..i, DF.IconPickFrame)
			local image = newcheck:CreateTexture ("DetailsFrameworkIconPickFrameButton"..i.."Icon", "overlay")
			newcheck.icon = image
			image:SetPoint ("topleft", newcheck, "topleft", 2, -2); image:SetPoint ("bottomright", newcheck, "bottomright", -2, 2)
			newcheck:SetSize (30, 28)
			newcheck:SetBackdrop (backdrop)
			
			newcheck:SetScript ("OnClick", OnClickFunction)
			newcheck.param1 = i
			
			newcheck:SetPoint ("topleft", "DetailsFrameworkIconPickFrameButton"..(i-10), "bottomleft", 0, -1)
			newcheck:SetID (i)
			DF.IconPickFrame.buttons [#DF.IconPickFrame.buttons+1] = newcheck
			newcheck:SetScript ("OnEnter", onenter)
			newcheck:SetScript ("OnLeave", onleave)
		end
		for i = 51, 60 do 
			local newcheck = CreateFrame ("Button", "DetailsFrameworkIconPickFrameButton"..i, DF.IconPickFrame)
			local image = newcheck:CreateTexture ("DetailsFrameworkIconPickFrameButton"..i.."Icon", "overlay")
			newcheck.icon = image
			image:SetPoint ("topleft", newcheck, "topleft", 2, -2); image:SetPoint ("bottomright", newcheck, "bottomright", -2, 2)
			newcheck:SetSize (30, 28)
			newcheck:SetBackdrop (backdrop)
			
			newcheck:SetScript ("OnClick", OnClickFunction)
			newcheck.param1 = i
			
			newcheck:SetPoint ("topleft", "DetailsFrameworkIconPickFrameButton"..(i-10), "bottomleft", 0, -1)
			newcheck:SetID (i)
			DF.IconPickFrame.buttons [#DF.IconPickFrame.buttons+1] = newcheck
			newcheck:SetScript ("OnEnter", onenter)
			newcheck:SetScript ("OnLeave", onleave)
		end
		
		local scroll = CreateFrame ("ScrollFrame", "DetailsFrameworkIconPickFrameScroll", DF.IconPickFrame, "ListScrollFrameTemplate")

		local ChecksFrame_Update = function (self)

			local numMacroIcons = #MACRO_ICON_FILENAMES
			local macroPopupIcon, macroPopupButton
			local macroPopupOffset = FauxScrollFrame_GetOffset (scroll)
			local index

			local texture
			local filter
			if (DF.IconPickFrame.searching) then
				filter = string_lower (DF.IconPickFrame.searching)
			end
			
			if (filter and filter ~= "") then
				
				local ignored = 0
				local tryed = 0
				local found = 0
				local type = type
				local buttons = DF.IconPickFrame.buttons
				index = 1
				
				for i = 1, 60 do
					
					macroPopupIcon = buttons[i].icon
					macroPopupButton = buttons[i]

					for o = index, numMacroIcons do
					
						tryed = tryed + 1
					
						texture = MACRO_ICON_FILENAMES [o]
						if (type (texture) == "number") then
							macroPopupIcon:SetToFileData (texture)
							texture = macroPopupIcon:GetTexture()
							macroPopupIcon:SetTexture (nil)
						else
							texture = "INTERFACE\\ICONS\\" .. texture
						end
						
						if (texture and texture:find (filter)) then
							macroPopupIcon:SetTexture (texture)
							macroPopupButton:Show()
							found = found + 1
							DF.IconPickFrame.last_filter_index = o
							index = o+1
							break
						else
							ignored = ignored + 1
						end
						
					end
				end
			
				for o = found+1, 60 do
					macroPopupButton = _G ["DetailsFrameworkIconPickFrameButton"..o]
					macroPopupButton:Hide()
				end
			else
				for i = 1, 60 do
					macroPopupIcon = _G ["DetailsFrameworkIconPickFrameButton"..i.."Icon"]
					macroPopupButton = _G ["DetailsFrameworkIconPickFrameButton"..i]
					index = (macroPopupOffset * 10) + i
					texture = MACRO_ICON_FILENAMES [index]
					if ( index <= numMacroIcons and texture ) then

						if (type (texture) == "number") then
							macroPopupIcon:SetToFileData (texture)
						else
							macroPopupIcon:SetTexture ("INTERFACE\\ICONS\\" .. texture)
						end

						macroPopupIcon:SetTexCoord (4/64, 60/64, 4/64, 60/64)
						macroPopupButton.IconID = index
						macroPopupButton:Show()
					else
						macroPopupButton:Hide()
					end
				end
			end
			
			-- Scrollbar stuff
			FauxScrollFrame_Update (scroll, ceil (numMacroIcons / 10) , 5, 20 )
		end

		DF.IconPickFrame.updateFunc = ChecksFrame_Update
		
		scroll:SetPoint ("topleft", DF.IconPickFrame, "topleft", -18, -37)
		scroll:SetWidth (330)
		scroll:SetHeight (178)
		scroll:SetScript ("OnVerticalScroll", function (self, offset) FauxScrollFrame_OnVerticalScroll (scroll, offset, 20, ChecksFrame_Update) end)
		scroll.update = ChecksFrame_Update
		DF.IconPickFrameScroll = scroll
		DF.IconPickFrame:Hide()
		
	end
	
	DF.IconPickFrame:Show()
	DF.IconPickFrameScroll.update (DF.IconPickFrameScroll)
	DF.IconPickFrame.callback = callback or DF.IconPickFrame.emptyFunction
	DF.IconPickFrame.click_close = close_when_select
	
end	

local simple_panel_counter = 1
local simple_panel_mouse_down = function (self, button)
	if (button == "RightButton") then
		if (self.IsMoving) then
			self.IsMoving = false
			self:StopMovingOrSizing()
			if (self.db and self.db.position) then
				DF:SavePositionOnScreen (self)
			end
		end
		if (not self.DontRightClickClose) then
			self:Hide()
		end
		return
	end
	if (not self.IsMoving and not self.IsLocked) then
		self.IsMoving = true
		self:StartMoving()
	end
end
local simple_panel_mouse_up = function (self, button)
	if (self.IsMoving) then
		self.IsMoving = false
		self:StopMovingOrSizing()
		if (self.db and self.db.position) then
			DF:SavePositionOnScreen (self)
		end
	end
end
local simple_panel_settitle = function (self, title)
	self.title:SetText (title)
end

function DF:CreateSimplePanel (parent, w, h, title, name)
	
	if (not name) then
		name = "DetailsFrameworkSimplePanel" .. simple_panel_counter
		simple_panel_counter = simple_panel_counter + 1
	end
	if (not parent) then
		parent = UIParent
	end

	local f = CreateFrame ("frame", name, UIParent)
	f:SetSize (w or 400, h or 250)
	f:SetPoint ("center", UIParent, "center", 0, 0)
	f:SetFrameStrata ("FULLSCREEN")
	f:EnableMouse()
	f:SetMovable (true)
	tinsert (UISpecialFrames, name)

	f:SetScript ("OnMouseDown", simple_panel_mouse_down)
	f:SetScript ("OnMouseUp", simple_panel_mouse_up)
	
	local bg = f:CreateTexture (nil, "background")
	bg:SetAllPoints (f)
	bg:SetTexture (DF.folder .. "background")
	
	local close = CreateFrame ("button", name .. "Close", f, "UIPanelCloseButton")
	close:SetSize (32, 32)
	close:SetPoint ("topright", f, "topright", 0, -12)

	f.title = DF:CreateLabel (f, title or "", 12, nil, "GameFontNormal")
	f.title:SetPoint ("top", f, "top", 0, -22)
	
	f.SetTitle = simple_panel_settitle
	
	simple_panel_counter = simple_panel_counter + 1
	
	return f
end

local Panel1PxBackdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 64,
edgeFile = DF.folder .. "border_3", edgeSize = 9, insets = {left = 2, right = 2, top = 3, bottom = 3}}

local Panel1PxOnClickClose = function (self)
	self:GetParent():Hide()
end
local Panel1PxOnToggleLock = function (self)
	if (self.IsLocked) then
		self.IsLocked = false
		self:SetMovable (true)
		self:EnableMouse (true)
		self.Lock:GetNormalTexture():SetTexCoord (32/128, 48/128, 0, 1)
		self.Lock:GetHighlightTexture():SetTexCoord (32/128, 48/128, 0, 1)
		self.Lock:GetPushedTexture():SetTexCoord (32/128, 48/128, 0, 1)
		if (self.OnUnlock) then
			self:OnUnlock()
		end
		if (self.db) then
			self.db.IsLocked = self.IsLocked
		end
	else
		self.IsLocked = true
		self:SetMovable (false)
		self:EnableMouse (false)
		self.Lock:GetNormalTexture():SetTexCoord (16/128, 32/128, 0, 1)
		self.Lock:GetHighlightTexture():SetTexCoord (16/128, 32/128, 0, 1)
		self.Lock:GetPushedTexture():SetTexCoord (16/128, 32/128, 0, 1)
		if (self.OnLock) then
			self:OnLock()
		end
		if (self.db) then
			self.db.IsLocked = self.IsLocked
		end
	end
end
local Panel1PxOnClickLock = function (self)
	local f = self:GetParent()
	Panel1PxOnToggleLock (f)
end
local Panel1PxSetTitle = function (self, text)
	self.Title:SetText (text or "")
end

local Panel1PxReadConfig = function (self)
	local db = self.db
	if (db) then
		db.IsLocked = db.IsLocked or false
		self.IsLocked = db.IsLocked
		db.position = db.position or {x = 0, y = 0}
		db.position.x = db.position.x or 0
		db.position.y = db.position.y or 0
		DF:RestoreFramePosition (self)
	end
end

function DF:SavePositionOnScreen (frame)
	if (frame.db and frame.db.position) then
		local x, y = DF:GetPositionOnScreen (frame)
		--print ("saving...", x, y, frame:GetName())
		if (x and y) then
			frame.db.position.x, frame.db.position.y = x, y
		end
	end
end

function DF:GetPositionOnScreen (frame)
	local xOfs, yOfs = frame:GetCenter()
	if (not xOfs) then
		return
	end
	local scale = frame:GetEffectiveScale()
	local UIscale = UIParent:GetScale()
	xOfs = xOfs*scale - GetScreenWidth()*UIscale/2
	yOfs = yOfs*scale - GetScreenHeight()*UIscale/2
	return xOfs/UIscale, yOfs/UIscale
end

function DF:RestoreFramePosition (frame)
	if (frame.db and frame.db.position) then
		local scale, UIscale = frame:GetEffectiveScale(), UIParent:GetScale()
		frame:ClearAllPoints()
		frame.db.position.x = frame.db.position.x or 0
		frame.db.position.y = frame.db.position.y or 0
		frame:SetPoint ("center", UIParent, "center", frame.db.position.x * UIscale / scale, frame.db.position.y * UIscale / scale)
	end
end

local Panel1PxHasPosition = function (self)
	local db = self.db
	if (db) then
		if (db.position and db.position.x and (db.position.x ~= 0 or db.position.y ~= 0)) then
			return true
		end
	end
end

function DF:Create1PxPanel (parent, w, h, title, name, config, title_anchor, no_special_frame)
	local f = CreateFrame ("frame", name, parent or UIParent)
	f:SetSize (w or 100, h or 75)
	f:SetPoint ("center", UIParent, "center")
	
	if (name and not no_special_frame) then
		tinsert (UISpecialFrames, name)
	end
	
	f:SetScript ("OnMouseDown", simple_panel_mouse_down)
	f:SetScript ("OnMouseUp", simple_panel_mouse_up)
	
	f:SetBackdrop (Panel1PxBackdrop)
	f:SetBackdropColor (0, 0, 0, 0.5)
	
	f.IsLocked = (config and config.IsLocked ~= nil and config.IsLocked) or false
	f:SetMovable (true)
	f:EnableMouse (true)
	f:SetUserPlaced (true)
	
	f.db = config
	--print (config.position.x, config.position.x)
	Panel1PxReadConfig (f)
	
	local close = CreateFrame ("button", name and name .. "CloseButton", f)
	close:SetSize (16, 16)
	close:SetNormalTexture (DF.folder .. "icons")
	close:SetHighlightTexture (DF.folder .. "icons")
	close:SetPushedTexture (DF.folder .. "icons")
	close:GetNormalTexture():SetTexCoord (0, 16/128, 0, 1)
	close:GetHighlightTexture():SetTexCoord (0, 16/128, 0, 1)
	close:GetPushedTexture():SetTexCoord (0, 16/128, 0, 1)
	close:SetAlpha (0.7)
	
	local lock = CreateFrame ("button", name and name .. "LockButton", f)
	lock:SetSize (16, 16)
	lock:SetNormalTexture (DF.folder .. "icons")
	lock:SetHighlightTexture (DF.folder .. "icons")
	lock:SetPushedTexture (DF.folder .. "icons")
	lock:GetNormalTexture():SetTexCoord (32/128, 48/128, 0, 1)
	lock:GetHighlightTexture():SetTexCoord (32/128, 48/128, 0, 1)
	lock:GetPushedTexture():SetTexCoord (32/128, 48/128, 0, 1)
	lock:SetAlpha (0.7)
	
	close:SetPoint ("topright", f, "topright", -3, -3)
	lock:SetPoint ("right", close, "left", 3, 0)
	
	close:SetScript ("OnClick", Panel1PxOnClickClose)
	lock:SetScript ("OnClick", Panel1PxOnClickLock)
	
	local title_string = f:CreateFontString (name and name .. "Title", "overlay", "GameFontNormal")
	title_string:SetPoint ("topleft", f, "topleft", 5, -5)
	title_string:SetText (title or "")
	
	if (title_anchor) then
		if (title_anchor == "top") then
			title_string:ClearAllPoints()
			title_string:SetPoint ("bottomleft", f, "topleft", 0, 0)
			close:ClearAllPoints()
			close:SetPoint ("bottomright", f, "topright", 0, 0)
		end
		f.title_anchor = title_anchor
	end
	
	f.SetTitle = Panel1PxSetTitle
	f.Title = title_string
	f.Lock = lock
	f.Close = close
	f.HasPosition = Panel1PxHasPosition
	
	f.IsLocked = not f.IsLocked
	Panel1PxOnToggleLock (f)
	
	return f
end

------------------------------------------------------------------------------------------------------------------------------------------------
--> options button -- ~options
function DF:CreateOptionsButton (parent, callback, name)
	
	local b = CreateFrame ("button", name, parent)
	b:SetSize (14, 14)
	b:SetNormalTexture (DF.folder .. "icons")
	b:SetHighlightTexture (DF.folder .. "icons")
	b:SetPushedTexture (DF.folder .. "icons")
	b:GetNormalTexture():SetTexCoord (48/128, 64/128, 0, 1)
	b:GetHighlightTexture():SetTexCoord (48/128, 64/128, 0, 1)
	b:GetPushedTexture():SetTexCoord (48/128, 64/128, 0, 1)
	b:SetAlpha (0.7)
	
	b:SetScript ("OnClick", callback)
	b:SetScript ("OnEnter", function (self) 
		GameCooltip2:Reset()
		GameCooltip2:AddLine ("Options")
		GameCooltip2:ShowCooltip (self, "tooltip")
	end)
	b:SetScript ("OnLeave", function (self) 
		GameCooltip2:Hide()
	end)
	
	return b

end

------------------------------------------------------------------------------------------------------------------------------------------------
--> feedback panel -- ~feedback

function DF:CreateFeedbackButton (parent, callback, name)
	local b = CreateFrame ("button", name, parent)
	b:SetSize (12, 13)
	b:SetNormalTexture (DF.folder .. "mail")
	b:SetPushedTexture (DF.folder .. "mail")
	b:SetHighlightTexture (DF.folder .. "mail")
	
	b:SetScript ("OnClick", callback)
	b:SetScript ("OnEnter", function (self) 
		GameCooltip2:Reset()
		GameCooltip2:AddLine ("Send Feedback")
		GameCooltip2:ShowCooltip (self, "tooltip")
	end)
	b:SetScript ("OnLeave", function (self) 
		GameCooltip2:Hide()
	end)
	
	return b
end

local backdrop_fb_line = {bgFile = DF.folder .. "background", edgeFile = DF.folder .. "border_3", 
tile = true, tileSize = 64, edgeSize = 8, insets = {left = 2, right = 2, top = 2, bottom = 2}}

local on_enter_feedback = function (self)
	self:SetBackdropColor (1, 1, 0, 0.5)
end
local on_leave_feedback = function (self)
	self:SetBackdropColor (0, 0, 0, 0.3)
end

local on_click_feedback = function (self)

	local feedback_link_textbox = DF.feedback_link_textbox
	
	if (not feedback_link_textbox) then
		local editbox = DF:CreateTextEntry (AddonFeedbackPanel, _, 275, 34)
		editbox:SetAutoFocus (false)
		editbox:SetHook ("OnEditFocusGained", function() 
			editbox.text = editbox.link
			editbox:HighlightText()
		end)
		editbox:SetHook ("OnEditFocusLost", function() 
			editbox:Hide()
		end)
		editbox:SetHook ("OnChar", function() 
			editbox.text = editbox.link
			editbox:HighlightText()
		end)
		editbox.text = ""
		
		DF.feedback_link_textbox = editbox
		feedback_link_textbox = editbox
	end
	
	feedback_link_textbox.link = self.link
	feedback_link_textbox.text = self.link
	feedback_link_textbox:Show()
	
	feedback_link_textbox:SetPoint ("topleft", self.icon, "topright", 3, 0)
	
	feedback_link_textbox:HighlightText()
	
	feedback_link_textbox:SetFocus()
	feedback_link_textbox:SetFrameLevel (self:GetFrameLevel()+2)
end

local feedback_get_fb_line = function (self)

	local line = self.feedback_lines [self.next_feedback]
	if (not line) then
		line = CreateFrame ("frame", "AddonFeedbackPanelFB" .. self.next_feedback, self)
		line:SetBackdrop (backdrop_fb_line)
		line:SetBackdropColor (0, 0, 0, 0.3)
		line:SetSize (390, 42)
		line:SetPoint ("topleft", self.feedback_anchor, "bottomleft", 0, -5 + ((self.next_feedback-1) * 46 * -1))
		line:SetScript ("OnEnter", on_enter_feedback)
		line:SetScript ("OnLeave", on_leave_feedback)
		line:SetScript ("OnMouseUp", on_click_feedback)
		
		line.icon = line:CreateTexture (nil, "overlay")
		line.icon:SetSize (90, 36)
		
		line.desc = line:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
		
		line.icon:SetPoint ("left", line, "left", 5, 0)
		line.desc:SetPoint ("left", line.icon, "right", 5, 0)
		
		local arrow = line:CreateTexture (nil, "overlay")
		arrow:SetTexture ([[Interface\Buttons\JumpUpArrow]])
		arrow:SetRotation (-1.55)
		arrow:SetPoint ("right", line, "right", -5, 0)
		
		self.feedback_lines [self.next_feedback] = line
	end
	
	self.next_feedback = self.next_feedback + 1
	
	return line
end

local on_click_feedback = function (self)

	local feedback_link_textbox = DF.feedback_link_textbox
	
	if (not feedback_link_textbox) then
		local editbox = DF:CreateTextEntry (AddonFeedbackPanel, _, 275, 34)
		editbox:SetAutoFocus (false)
		editbox:SetHook ("OnEditFocusGained", function() 
			editbox.text = editbox.link
			editbox:HighlightText()
		end)
		editbox:SetHook ("OnEditFocusLost", function() 
			editbox:Hide()
		end)
		editbox:SetHook ("OnChar", function() 
			editbox.text = editbox.link
			editbox:HighlightText()
		end)
		editbox.text = ""
		
		DF.feedback_link_textbox = editbox
		feedback_link_textbox = editbox
	end
	
	feedback_link_textbox.link = self.link
	feedback_link_textbox.text = self.link
	feedback_link_textbox:Show()
	
	feedback_link_textbox:SetPoint ("topleft", self.icon, "topright", 3, 0)
	
	feedback_link_textbox:HighlightText()
	
	feedback_link_textbox:SetFocus()
	feedback_link_textbox:SetFrameLevel (self:GetFrameLevel()+2)
end

local on_enter_addon = function (self)
	if (self.tooltip) then
		GameCooltip2:Preset (2)
		GameCooltip2:AddLine ("|cFFFFFF00" .. self.name .. "|r")
		GameCooltip2:AddLine ("")
		GameCooltip2:AddLine (self.tooltip)
		GameCooltip2:ShowCooltip (self, "tooltip")
	end
	self.icon:SetBlendMode ("ADD")
end
local on_leave_addon = function (self)
	if (self.tooltip) then
		GameCooltip2:Hide()
	end
	self.icon:SetBlendMode ("BLEND")
end
local on_click_addon = function (self)
	local addon_link_textbox = DF.addon_link_textbox
	
	if (not addon_link_textbox) then
		local editbox = DF:CreateTextEntry (AddonFeedbackPanel, _, 128, 64)
		editbox:SetAutoFocus (false)
		editbox:SetHook ("OnEditFocusGained", function() 
			editbox.text = editbox.link
			editbox:HighlightText()
		end)
		editbox:SetHook ("OnEditFocusLost", function() 
			editbox:Hide()
		end)
		editbox:SetHook ("OnChar", function() 
			editbox.text = editbox.link
			editbox:HighlightText()
		end)
		editbox.text = ""
		
		DF.addon_link_textbox = editbox
		addon_link_textbox = editbox
	end
	
	addon_link_textbox.link = self.link
	addon_link_textbox.text = self.link
	addon_link_textbox:Show()
	
	addon_link_textbox:SetPoint ("topleft", self.icon, "topleft", 0, 0)
	
	addon_link_textbox:HighlightText()
	
	addon_link_textbox:SetFocus()
	addon_link_textbox:SetFrameLevel (self:GetFrameLevel()+2)
end

local feedback_get_addons_line = function (self)
	local line = self.addons_lines [self.next_addons]
	if (not line) then
	
		line = CreateFrame ("frame", "AddonFeedbackPanelSA" .. self.next_addons, self)
		line:SetSize (128, 64)

		if (self.next_addons == 1) then
			line:SetPoint ("topleft", self.addons_anchor, "bottomleft", 0, -5)
		elseif (self.next_addons_line_break == self.next_addons) then
			line:SetPoint ("topleft", self.addons_anchor, "bottomleft", 0, -5 + floor (self.next_addons_line_break/3) * 66 * -1)
			self.next_addons_line_break = self.next_addons_line_break + 3
		else
			local previous = self.addons_lines [self.next_addons - 1]
			line:SetPoint ("topleft", previous, "topright", 2, 0)
		end

		line:SetScript ("OnEnter", on_enter_addon)
		line:SetScript ("OnLeave", on_leave_addon)
		line:SetScript ("OnMouseUp", on_click_addon)
		
		line.icon = line:CreateTexture (nil, "overlay")
		line.icon:SetSize (128, 64)

		line.icon:SetPoint ("topleft", line, "topleft", 0, 0)
		
		self.addons_lines [self.next_addons] = line
	end
	
	self.next_addons = self.next_addons + 1
	
	return line
end

local default_coords = {0, 1, 0, 1}
local feedback_add_fb = function (self, table)
	local line = self:GetFeedbackLine()
	line.icon:SetTexture (table.icon)
	line.icon:SetTexCoord (unpack (table.coords or default_coords))
	line.desc:SetText (table.desc)
	line.link = table.link
	line:Show()
end

local feedback_add_addon = function (self, table)
	local block = self:GetAddonsLine()
	block.icon:SetTexture (table.icon)
	block.icon:SetTexCoord (unpack (table.coords or default_coords))
	block.link = table.link
	block.tooltip = table.desc
	block.name = table.name
	block:Show()
end

local feedback_hide_all = function (self)
	self.next_feedback = 1
	self.next_addons = 1
	
	for index, line in ipairs (self.feedback_lines) do
		line:Hide()
	end
	
	for index, line in ipairs (self.addons_lines) do
		line:Hide()
	end
end

-- feedback_methods = { { icon = icon path, desc = description, link = url}}
function DF:ShowFeedbackPanel (addon_name, version, feedback_methods, more_addons)

	local f = _G.AddonFeedbackPanel

	if (not f) then
		f = DF:Create1PxPanel (UIParent, 400, 100, addon_name .. " Feedback", "AddonFeedbackPanel", nil)
		f:SetFrameStrata ("FULLSCREEN")
		f:SetPoint ("center", UIParent, "center")
		f:SetBackdropColor (0, 0, 0, 0.8)
		f.feedback_lines = {}
		f.addons_lines = {}
		f.next_feedback = 1
		f.next_addons = 1
		f.next_addons_line_break = 4
		
		local feedback_anchor = f:CreateFontString (nil, "overlay", "GameFontNormal")
		feedback_anchor:SetText ("Feedback:")
		feedback_anchor:SetPoint ("topleft", f, "topleft", 5, -30)
		f.feedback_anchor = feedback_anchor
		local excla_text = f:CreateFontString (nil, "overlay", "GameFontNormal")
		excla_text:SetText ("click and copy the link")
		excla_text:SetPoint ("topright", f, "topright", -5, -30)
		excla_text:SetTextColor (1, 0.8, 0.2, 0.6)
		
		local addons_anchor = f:CreateFontString (nil, "overlay", "GameFontNormal")
		addons_anchor:SetText ("AddOns From the Same Author:")
		f.addons_anchor = addons_anchor
		local excla_text2 = f:CreateFontString (nil, "overlay", "GameFontNormal")
		excla_text2:SetText ("click and copy the link")
		excla_text2:SetTextColor (1, 0.8, 0.2, 0.6)
		f.excla_text2 = excla_text2
		
		f.GetFeedbackLine = feedback_get_fb_line
		f.GetAddonsLine = feedback_get_addons_line
		f.AddFeedbackMethod = feedback_add_fb
		f.AddOtherAddon = feedback_add_addon
		f.HideAll = feedback_hide_all

		DF:SetFontSize (f.Title, 14)
		
	end
	
	f:HideAll()
	f:SetTitle (addon_name)
	
	for index, feedback in ipairs (feedback_methods) do
		f:AddFeedbackMethod (feedback)
	end
	
	f.addons_anchor:SetPoint ("topleft", f, "topleft", 5, f.next_feedback * 50 * -1)
	f.excla_text2:SetPoint ("topright", f, "topright", -5, f.next_feedback * 50 * -1)
	
	for index, addon in ipairs (more_addons) do
		f:AddOtherAddon (addon)
	end
	
	f:SetHeight (80 + ((f.next_feedback-1) * 50) + (ceil ((f.next_addons-1)/3) * 66))
	
	f:Show()
	
	return true
end


------------------------------------------------------------------------------------------------------------------------------------------------
--> chart panel -- ~chart

local chart_panel_backdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 32, insets = {left = 5, right = 5, top = 5, bottom = 5}}

local chart_panel_align_timelabels = function (self, elapsed_time)

	self.TimeScale = elapsed_time

	local linha = self.TimeLabels [17]
	local minutos, segundos = math.floor (elapsed_time / 60), math.floor (elapsed_time % 60)
	if (segundos < 10) then
		segundos = "0" .. segundos
	end
	
	if (minutos > 0) then
		if (minutos < 10) then
			minutos = "0" .. minutos
		end
		linha:SetText (minutos .. ":" .. segundos)
	else
		linha:SetText ("00:" .. segundos)
	end
	
	local time_div = elapsed_time / 16 --786 -- 49.125
	
	for i = 2, 16 do
	
		local linha = self.TimeLabels [i]
		
		local this_time = time_div * (i-1)
		local minutos, segundos = math.floor (this_time / 60), math.floor (this_time % 60)
		
		if (segundos < 10) then
			segundos = "0" .. segundos
		end
		
		if (minutos > 0) then
			if (minutos < 10) then
				minutos = "0" .. minutos
			end
			linha:SetText (minutos .. ":" .. segundos)
		else
			linha:SetText ("00:" .. segundos)
		end
		
	end
	
end

local chart_panel_set_scale = function (self, amt, func, text)
	if (type (amt) ~= "number") then
		return
	end
	
	local piece = amt / 1000 / 8
	
	for i = 1, 8 do
		if (func) then
			self ["dpsamt" .. math.abs (i-9)]:SetText ( func (piece*i) .. (text or ""))
		else
			if (piece*i > 1) then
				self ["dpsamt" .. math.abs (i-9)]:SetText ( floor (piece*i) .. (text or ""))
			else
				self ["dpsamt" .. math.abs (i-9)]:SetText ( format ("%.3f", piece*i) .. (text or ""))
			end
		end
	end
end

local chart_panel_can_move = function (self, can)
	self.can_move = can
end

local chart_panel_overlay_reset = function (self)
	self.OverlaysAmount = 1
	for index, pack in ipairs (self.Overlays) do
		for index2, texture in ipairs (pack) do
			texture:Hide()
		end
	end
end

local chart_panel_reset = function (self)

	self.Graphic:ResetData()
	self.Graphic.max_value = 0
	
	self.TimeScale = nil
	self.BoxLabelsAmount = 1
	table.wipe (self.GData)
	table.wipe (self.OData)
	
	for index, box in ipairs (self.BoxLabels) do
		box.check:Hide()
		box.button:Hide()
		box.box:Hide()
		box.text:Hide()
		box.border:Hide()
		box.showing = false
	end
	
	chart_panel_overlay_reset (self)
end

local chart_panel_enable_line = function (f, thisbox)

	local index = thisbox.index
	local type = thisbox.type
	
	if (thisbox.enabled) then
		--disable
		thisbox.check:Hide()
		thisbox.enabled = false
	else
		--enable
		thisbox.check:Show()
		thisbox.enabled = true
	end
	
	if (type == "graphic") then
	
		f.Graphic:ResetData()
		f.Graphic.max_value = 0
		
		local max = 0
		local max_time = 0
		
		for index, box in ipairs (f.BoxLabels) do
			if (box.type == type and box.showing and box.enabled) then
				local data = f.GData [index]
				
				f.Graphic:AddDataSeries (data[1], data[2], nil, data[3])
				
				if (data[4] > max) then
					max = data[4]
				end
				if (data [5] > max_time) then
					max_time = data [5]
				end
			end
		end
		
		f:SetScale (max)
		f:SetTime (max_time)
		
	elseif (type == "overlay") then

		chart_panel_overlay_reset (f)
		
		for index, box in ipairs (f.BoxLabels) do
			if (box.type == type and box.showing and box.enabled) then
				
				f:AddOverlay (box.index)
				
			end
		end
	
	end
end

local create_box = function (self, next_box)

	local thisbox = {}
	self.BoxLabels [next_box] = thisbox
	
	local box = DF:NewImage (self.Graphic, nil, 16, 16, "border")
	
	local text = DF:NewLabel (self.Graphic)
	
	local border = DF:NewImage (self.Graphic, [[Interface\DialogFrame\UI-DialogBox-Gold-Corner]], 30, 30, "artwork")
	border:SetPoint ("center", box, "center", -3, -4)
	border:SetTexture ([[Interface\DialogFrame\UI-DialogBox-Gold-Corner]])
	
	local checktexture = DF:NewImage (self.Graphic, [[Interface\Buttons\UI-CheckBox-Check]], 18, 18, "overlay")
	checktexture:SetPoint ("center", box, "center", -1, -1)
	checktexture:SetTexture ([[Interface\Buttons\UI-CheckBox-Check]])
	
	thisbox.box = box
	thisbox.text = text
	thisbox.border = border
	thisbox.check = checktexture
	thisbox.enabled = true

	local button = CreateFrame ("button", nil, self.Graphic)
	button:SetSize (20, 20)
	button:SetScript ("OnClick", function()
		chart_panel_enable_line (self, thisbox)
	end)
	button:SetPoint ("center", box, "center")
	
	thisbox.button = button
	
	thisbox.box:SetPoint ("right", text, "left", -4, 0)
	
	if (next_box == 1) then
		thisbox.text:SetPoint ("topright", self, "topright", -35, -16)
	else
		thisbox.text:SetPoint ("right", self.BoxLabels [next_box-1].box, "left", -7, 0)
	end

	return thisbox
	
end

local realign_labels = function (self)
	
	local width = self:GetWidth() - 108
	
	local first_box = self.BoxLabels [1]
	first_box.text:SetPoint ("topright", self, "topright", -35, -16)
	
	local line_width = first_box.text:GetStringWidth() + 26
	
	for i = 2, #self.BoxLabels do
	
		local box = self.BoxLabels [i]
		
		if (box.box:IsShown()) then
		
			line_width = line_width + box.text:GetStringWidth() + 26
			
			if (line_width > width) then
				line_width = box.text:GetStringWidth() + 26
				box.text:SetPoint ("topright", self, "topright", -35, -40)
			else
				box.text:SetPoint ("right", self.BoxLabels [i-1].box, "left", -7, 0)
			end
		else
			break
		end
	end
	
end

local chart_panel_add_label = function (self, color, name, type, number)

	local next_box = self.BoxLabelsAmount
	local thisbox = self.BoxLabels [next_box]
	
	if (not thisbox) then
		thisbox = create_box (self, next_box)
	end
	
	self.BoxLabelsAmount = self.BoxLabelsAmount + 1

	thisbox.type = type
	thisbox.index = number

	thisbox.box:SetTexture (unpack (color))
	thisbox.text:SetText (name)
	
	thisbox.check:Show()
	thisbox.button:Show()
	thisbox.border:Show()
	thisbox.box:Show()
	thisbox.text:Show()

	thisbox.showing = true
	thisbox.enabled = true
	
	realign_labels (self)
	
end

local line_default_color = {1, 1, 1}
local draw_overlay = function (self, this_overlay, overlayData, color)

	local pixel = self.Graphic:GetWidth() / self.TimeScale
	local index = 1
	local r, g, b = unpack (color)
	
	for i = 1, #overlayData, 2 do
		local aura_start = overlayData [i]
		local aura_end = overlayData [i+1]
		
		local this_block = this_overlay [index]
		if (not this_block) then
			this_block = self.Graphic:CreateTexture (nil, "border")
			tinsert (this_overlay, this_block)
		end
		this_block:SetHeight (self.Graphic:GetHeight())
		
		this_block:SetPoint ("left", self.Graphic, "left", pixel * aura_start, 0)
		if (aura_end) then
			this_block:SetWidth ((aura_end-aura_start)*pixel)
		else
			--malformed table
			this_block:SetWidth (pixel*5)
		end
		
		this_block:SetTexture (r, g, b, 0.25)
		this_block:Show()
		
		index = index + 1
	end

end

local chart_panel_add_overlay = function (self, overlayData, color, name, icon)

	if (not self.TimeScale) then
		error ("Use SetTime (time) before adding an overlay.")
	end

	if (type (overlayData) == "number") then
		local overlay_index = overlayData
		draw_overlay (self, self.Overlays [self.OverlaysAmount], self.OData [overlay_index][1], self.OData [overlay_index][2])
	else
		local this_overlay = self.Overlays [self.OverlaysAmount]
		if (not this_overlay) then
			this_overlay = {}
			tinsert (self.Overlays, this_overlay)
		end

		draw_overlay (self, this_overlay, overlayData, color)

		tinsert (self.OData, {overlayData, color or line_default_color})
		if (name) then
			self:AddLabel (color or line_default_color, name, "overlay", #self.OData)
		end
	end

	self.OverlaysAmount = self.OverlaysAmount + 1
end

local SMA_table = {}
local SMA_max = 0
local reset_SMA = function()
	table.wipe (SMA_table)
	SMA_max = 0
end

local calc_SMA
calc_SMA = function (a, b, ...)
	if (b) then 
		return calc_SMA (a + b, ...) 
	else 
		return a
	end 
end

local do_SMA = function (value, max_value)

	if (#SMA_table == 10) then 
		tremove (SMA_table, 1)
	end
	
	SMA_table [#SMA_table + 1] = value
	
	local new_value = calc_SMA (unpack (SMA_table)) / #SMA_table
	
	if (new_value > SMA_max) then
		SMA_max = new_value
		return new_value, SMA_max
	else
		return new_value
	end
	
end

local chart_panel_add_data = function (self, graphicData, color, name, elapsed_time, lineTexture, smoothLevel, firstIndex)

	local f = self
	self = self.Graphic
	
	local _data = {}
	local max_value = graphicData.max_value
	local amount = #graphicData
	
	local scaleW = 1/self:GetWidth()

	local content = graphicData
	tinsert (content, 1, 0)
	tinsert (content, 1, 0)
	tinsert (content, #content+1, 0)
	tinsert (content, #content+1, 0)
	
	local _i = 3
	
	local graphMaxDps = math.max (self.max_value, max_value)
	
	if (not smoothLevel) then
		while (_i <= #content-2) do 
			local v = (content[_i-2]+content[_i-1]+content[_i]+content[_i+1]+content[_i+2])/5 --> normalize
			_data [#_data+1] = {scaleW*(_i-2), v/graphMaxDps} --> x and y coords
			_i = _i + 1
		end
	
	elseif (smoothLevel == "SHORT") then
		while (_i <= #content-2) do 
			local value = (content[_i] + content[_i+1]) / 2
			_data [#_data+1] = {scaleW*(_i-2), value}
			_data [#_data+1] = {scaleW*(_i-2), value}
			_i = _i + 2
		end
	
	elseif (smoothLevel == "SMA") then
		reset_SMA()
		while (_i <= #content-2) do 
			local value, is_new_max_value = do_SMA (content[_i], max_value)
			if (is_new_max_value) then
				max_value = is_new_max_value
			end
			_data [#_data+1] = {scaleW*(_i-2), value} --> x and y coords
			_i = _i + 1
		end
	
	elseif (smoothLevel == -1) then
		while (_i <= #content-2) do
			local current = content[_i]
			
			local minus_2 = content[_i-2] * 0.6
			local minus_1 = content[_i-1] * 0.8
			local plus_1 = content[_i+1] * 0.8
			local plus_2 = content[_i+2] * 0.6
			
			local v = (current + minus_2 + minus_1 + plus_1 + plus_2)/5 --> normalize
			_data [#_data+1] = {scaleW*(_i-2), v/graphMaxDps} --> x and y coords
			_i = _i + 1
		end
	
	elseif (smoothLevel == 1) then
		_i = 2
		while (_i <= #content-1) do 
			local v = (content[_i-1]+content[_i]+content[_i+1])/3 --> normalize
			_data [#_data+1] = {scaleW*(_i-1), v/graphMaxDps} --> x and y coords
			_i = _i + 1
		end
		
	elseif (smoothLevel == 2) then
		_i = 1
		while (_i <= #content) do 
			local v = content[_i] --> do not normalize
			_data [#_data+1] = {scaleW*(_i), v/graphMaxDps} --> x and y coords
			_i = _i + 1
		end
		
	end
	
	tremove (content, 1)
	tremove (content, 1)
	tremove (content, #graphicData)
	tremove (content, #graphicData)

	if (max_value > self.max_value) then 
		--> normalize previous data
		if (self.max_value > 0) then
			local normalizePercent = self.max_value / max_value
			for dataIndex, Data in ipairs (self.Data) do 
				local Points = Data.Points
				for i = 1, #Points do 
					Points[i][2] = Points[i][2]*normalizePercent
				end
			end
		end
	
		self.max_value = max_value
		f:SetScale (max_value)

	end
	
	tinsert (f.GData, {_data, color or line_default_color, lineTexture, max_value, elapsed_time})
	if (name) then
		f:AddLabel (color or line_default_color, name, "graphic", #f.GData)
	end
	
	if (firstIndex) then
		if (lineTexture) then
			if (not lineTexture:find ("\\") and not lineTexture:find ("//")) then 
				local path = string.match (debugstack (1, 1, 0), "AddOns\\(.+)LibGraph%-2%.0%.lua")
				if path then
					lineTexture = "Interface\\AddOns\\" .. path .. lineTexture
				else
					lineTexture = nil
				end
			end
		end
		
		table.insert (self.Data, 1, {Points = _data, Color = color or line_default_color, lineTexture = lineTexture, ElapsedTime = elapsed_time})
		self.NeedsUpdate = true
	else
		self:AddDataSeries (_data, color or line_default_color, nil, lineTexture)
		self.Data [#self.Data].ElapsedTime = elapsed_time
	end
	
	local max_time = 0
	for _, data in ipairs (self.Data) do
		if (data.ElapsedTime > max_time) then
			max_time = data.ElapsedTime
		end
	end
	
	f:SetTime (max_time)
	
end

local chart_panel_onresize = function (self)
	local width, height = self:GetSize()
	local spacement = width - 78 - 60
	spacement = spacement / 16
	
	for i = 1, 17 do
		local label = self.TimeLabels [i]
		label:SetPoint ("bottomleft", self, "bottomleft", 78 + ((i-1)*spacement), 13)
		label.line:SetHeight (height - 45)
	end
	
	local spacement = (self.Graphic:GetHeight()) / 8
	for i = 1, 8 do
		self ["dpsamt"..i]:SetPoint ("TOPLEFT", self, "TOPLEFT", 27, -25 + (-(spacement* (i-1))) )
		self ["dpsamt"..i].line:SetWidth (width-20)
	end
	
	self.Graphic:SetSize (width - 135, height - 67)
	self.Graphic:SetPoint ("topleft", self, "topleft", 108, -35)
end

local chart_panel_vlines_on = function (self)
	for i = 1, 17 do
		local label = self.TimeLabels [i]
		label.line:Show()
	end
end

local chart_panel_vlines_off = function (self)
	for i = 1, 17 do
		local label = self.TimeLabels [i]
		label.line:Hide()
	end
end

local chart_panel_set_title = function (self, title)
	self.chart_title.text = title
end

local chart_panel_mousedown = function (self, button)
	if (button == "LeftButton" and self.can_move) then
		if (not self.isMoving) then
			self:StartMoving()
			self.isMoving = true
		end
	elseif (button == "RightButton" and not self.no_right_click_close) then
		if (not self.isMoving) then
			self:Hide()
		end
	end
end
local chart_panel_mouseup = function (self, button)
	if (button == "LeftButton" and self.isMoving) then
		self:StopMovingOrSizing()
		self.isMoving = nil
	end
end

local chart_panel_hide_close_button = function (self)
	self.CloseButton:Hide()
end

local chart_panel_right_click_close = function (self, value)
	if (type (value) == "boolean") then
		if (value) then
			self.no_right_click_close = nil
		else
			self.no_right_click_close = true
		end
	end
end

function DF:CreateChartPanel (parent, w, h, name)

	if (not name) then
		name = "DFPanel" .. DF.PanelCounter
		DF.PanelCounter = DF.PanelCounter + 1
	end
	
	parent = parent or UIParent
	w = w or 800
	h = h or 500

	local f = CreateFrame ("frame", name, parent)
	f:SetSize (w or 500, h or 400)
	f:EnableMouse (true)
	f:SetMovable (true)
	
	f:SetScript ("OnMouseDown", chart_panel_mousedown)
	f:SetScript ("OnMouseUp", chart_panel_mouseup)

	f:SetBackdrop (chart_panel_backdrop)
	f:SetBackdropColor (.3, .3, .3, .3)

	local c = CreateFrame ("Button", nil, f, "UIPanelCloseButton")
	c:SetWidth (32)
	c:SetHeight (32)
	c:SetPoint ("TOPRIGHT",  f, "TOPRIGHT", -3, -7)
	c:SetFrameLevel (f:GetFrameLevel()+1)
	c:SetAlpha (0.9)
	f.CloseButton = c
	
	local title = DF:NewLabel (f, nil, "$parentTitle", "chart_title", "Chart!", nil, 20, {1, 1, 0})
	title:SetPoint ("topleft", f, "topleft", 110, -13)

	local bottom_texture = DF:NewImage (f, nil, 702, 25, "background", nil, nil, "$parentBottomTexture")
	bottom_texture:SetTexture (0, 0, 0, .6)
	bottom_texture:SetPoint ("bottomleft", f, "bottomleft", 8, 7)
	bottom_texture:SetPoint ("bottomright", f, "bottomright", -8, 7)

	f.Overlays = {}
	f.OverlaysAmount = 1
	
	f.BoxLabels = {}
	f.BoxLabelsAmount = 1
	
	f.TimeLabels = {}
	for i = 1, 17 do 
		local time = f:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
		time:SetText ("00:00")
		time:SetPoint ("bottomleft", f, "bottomleft", 78 + ((i-1)*36), 13)
		f.TimeLabels [i] = time
		
		local line = f:CreateTexture (nil, "border")
		line:SetSize (1, h-45)
		line:SetTexture (1, 1, 1, .1)
		line:SetPoint ("bottomleft", time, "topright", 0, -10)
		line:Hide()
		time.line = line
	end
	
	--graphic
		local g = LibStub:GetLibrary("LibGraph-2.0"):CreateGraphLine (name .. "Graphic", f, "topleft","topleft", 108, -35, w - 120, h - 67)
		g:SetXAxis (-1,1)
		g:SetYAxis (-1,1)
		g:SetGridSpacing (false, false)
		g:SetGridColor ({0.5,0.5,0.5,0.3})
		g:SetAxisDrawing (false,false)
		g:SetAxisColor({1.0,1.0,1.0,1.0})
		g:SetAutoScale (true)
		g:SetLineTexture ("smallline")
		g:SetBorderSize ("right", 0.001)
		g:SetBorderSize ("left", 0.000)
		g:SetBorderSize ("top", 0.002)
		g:SetBorderSize ("bottom", 0.001)
		g.VerticalLines = {}
		g.max_value = 0
		
		g:SetLineTexture ("line")
		
		f.Graphic = g
		f.GData = {}
		f.OData = {}
	
	--div lines
		for i = 1, 8, 1 do
			local line = g:CreateTexture (nil, "overlay")
			line:SetTexture (1, 1, 1, .2)
			line:SetWidth (670)
			line:SetHeight (1.1)
		
			local s = f:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			f ["dpsamt"..i] = s
			s:SetText ("100k")
			s:SetPoint ("topleft", f, "topleft", 27, -61 + (-(24.6*i)))
		
			line:SetPoint ("topleft", s, "bottom", -27, 0)
			s.line = line
		end
	
	f.SetTime = chart_panel_align_timelabels
	f.EnableVerticalLines = chart_panel_vlines_on
	f.DisableVerticalLines = chart_panel_vlines_off
	f.SetTitle = chart_panel_set_title
	f.SetScale = chart_panel_set_scale
	f.Reset = chart_panel_reset
	f.AddLine = chart_panel_add_data
	f.CanMove = chart_panel_can_move
	f.AddLabel = chart_panel_add_label
	f.AddOverlay = chart_panel_add_overlay
	f.HideCloseButton = chart_panel_hide_close_button
	f.RightClickClose = chart_panel_right_click_close
	
	f:SetScript ("OnSizeChanged", chart_panel_onresize)
	chart_panel_onresize (f)
	
	return f
end