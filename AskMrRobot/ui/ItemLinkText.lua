local _, AskMrRobot = ...

AskMrRobot.ItemLinkText = AskMrRobot.inheritsFrom(AskMrRobot.ItemTooltipFrame)

function AskMrRobot.ItemLinkText:new(name, parent)
	local o = AskMrRobot.ItemTooltipFrame:new(name, parent)

	-- use the ItemLinkText class
	setmetatable(o, { __index = AskMrRobot.ItemLinkText })

	-- the item text
	o.itemText = AskMrRobot.FontString:new(o, nil, "ARTWORK", "GameFontWhite")
	o.itemText:SetPoint("TOPLEFT")
	o.itemText:SetPoint("BOTTOMRIGHT")
	o.itemText:SetJustifyH("LEFT")

	return o
end

function AskMrRobot.ItemLinkText:SetFormat(formatText)
	self.formatText = formatText
end

function AskMrRobot.ItemLinkText:SetItem(itemObj)
    -- blank/nil
    if itemObj == nil or itemObj.id == nil or itemObj.id == 0 then
        self.itemText:SetText("empty")
		self.itemText:SetTextColor(0.5,0.5,0.5)
		self:SetItemLink(nil)
        return
    end
    
    local itemName, itemLink = GetItemInfo(AskMrRobot.createItemLink(itemObj))
    self:SetItemLink(itemLink)
    if itemLink then
        self.itemName = itemName
        if self.formatText then
            self.itemText:SetFormattedText(self.formatText, itemLink:gsub("%[", ""):gsub("%]", ""))
        else
            self.itemText:SetText(itemLink:gsub("%[", ""):gsub("%]", ""))
        end
    else
        self.itemText:SetFormattedText("unknown (%d)", itemObj.id)
        self.itemText:SetTextColor(1,1,1)
        AskMrRobot.RegisterItemInfoCallback(itemObj.id, function(name, itemLink2)
            if self.formatText then
                self.itemText:SetFormattedText(self.formatText, itemLink2:gsub("%[", ""):gsub("%]", ""))
            else
                self.itemText:SetText(itemLink2:gsub("%[", ""):gsub("%]", ""))
            end
            self:SetItemLink(itemLink2)
            self.itemName = name
        end)
    end
end 

function AskMrRobot.ItemLinkText:SetItemId(itemId)

    self:SetItem({ 
        id = itemId,
        enchantId = 0,
        gemIds = {0,0,0,0},
        suffixId = 0,
        upgradeId = 0
    })
    
end

function AskMrRobot.ItemLinkText:SetFontSize(fontSize)
	self.itemText:SetFontSize(fontSize)
end