---------------------------------------------------------------------------------
--
-- Prat - A framework for World of Warcraft chat mods
--
-- Copyright (C) 2006-2011  Prat Development Team
--
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License
-- as published by the Free Software Foundation; either version 2
-- of the License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to:
--
-- Free Software Foundation, Inc.,
-- 51 Franklin Street, Fifth Floor,
-- Boston, MA  02110-1301, USA.
--
--
-------------------------------------------------------------------------------

Prat:AddModuleToLoad(function()

  local PRAT_MODULE = Prat:RequestModuleName("Bubbles")

  if PRAT_MODULE == nil then
    return
  end

  local L = Prat:GetLocalizer({})

  --[===[@debug@
  L:AddLocale("enUS", {
    module_name = "Bubbles",
    module_desc = "Chat bubble related customizations",
    shorten_name = "Shorten Bubbles",
    shorten_desc = "Shorten the chat bubbles down to a single line each. Mouse over the bubble to expand the text.",
    color_name = "Color Bubbles",
    color_desc = "Color the chat bubble border the same as the chat type.",
    format_name = "Format Text",
    format_desc = "Apply Prat's formatting to the chat bubble text.",
    icons_name = "Show Raid Icons",
    icons_desc = "Show raid icons in the chat bubbles.",
    font_name = "Use Chat Font",
    font_desc = "Use the same font you are using on the chatframe",
    fontsize_name = "Font Size",
    fontsize_desc = "Set the chat bubble font size",
    transparent_name = "Transparent Bubbles",
    transparent_desc = "Hide background and border textures from chat bubbles. (/reload required to undo this option)",
  })
  --@end-debug@]===]

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/


  --@non-debug@
  L:AddLocale("enUS",
  {
	color_desc = "Color the chat bubble border the same as the chat type.",
	color_name = "Color Bubbles",
	font_desc = "Use the same font you are using on the chatframe",
	font_name = "Use Chat Font",
	fontsize_desc = "Set the chat bubble font size",
	fontsize_name = "Font Size",
	format_desc = "Apply Prat's formatting to the chat bubble text.",
	format_name = "Format Text",
	icons_desc = "Show raid icons in the chat bubbles.",
	icons_name = "Show Raid Icons",
	module_desc = "Chat bubble related customizations",
	module_name = "Bubbles",
	shorten_desc = "Shorten the chat bubbles down to a single line each. Mouse over the bubble to expand the text.",
	shorten_name = "Shorten Bubbles",
	transparent_desc = "Hide background and border textures from chat bubbles. (/reload required to undo this option)",
	transparent_name = "Transparent Bubbles",
}

  )
  L:AddLocale("frFR",
  {
	color_desc = "Colorie la bordure de la bulle en fonction du type de discussion.",
	color_name = "Colorier les bulles",
	font_desc = "Utiliser la même police que celle de la fenêtre de discussion.",
	font_name = "Police du chat",
	fontsize_desc = "Définit la taille du texte dans les bulles.",
	fontsize_name = "Taille du texte",
	format_desc = "Appliquer le formatage de Prat aux textes dans les bulles.",
	format_name = "Formater le texte",
	icons_desc = "Montrer les icônes de raid dans les bulles.",
	icons_name = "Montrer les icônes de raid",
	module_desc = "Options des bulles de chat .",
	module_name = "Bulles",
	shorten_desc = "Raccourci le texte des bulles à une seule ligne. Mettre la souris sur la bulle pour étendre la bulle et voir le texte en entier.",
	shorten_name = "Raccourcir les bulles",
	-- transparent_desc = "",
	-- transparent_name = "",
}

  )
  L:AddLocale("deDE",
  {
	color_desc = "Färbe den Sprechblasenrahmen, im selben Stil, wie den Chattyp ein.",
	color_name = "Sprechblasen färben",
	font_desc = "Die selbe Schriftart wie auch für das Chatfenster verwenden",
	font_name = "Chatschriftart verwenden",
	fontsize_desc = "Stellt die Schriftgröße der Sprechblasen ein",
	fontsize_name = "Schriftgröße",
	format_desc = "Benutze die Pratformatierung zum Einfärben des Sprechblasentextes",
	format_name = "Text formatieren",
	icons_desc = "Zielmarkierungssymbole in den Sprechblasen anzeigen.",
	icons_name = "Zielmarkierungssymbole anzeigen",
	module_desc = "Einstellung des Sprechblasenverhaltens",
	module_name = "Blasen",
	shorten_desc = "Verkürze die Sprechblasen zu einem Einzeiler. Fahre mit der Maus über die Sprachblase , um den Text zu erweitern",
	shorten_name = "Sprechblasen verkürzen",
	transparent_desc = "Ausblenden des Hintergrunds und den Randstrukturen von Sprechblasen. (/reload ist erforderlich, um diese Option rückgängig zu machen)",
	transparent_name = "Transparente Blasen",
}

  )
  L:AddLocale("koKR",
  {
	color_desc = "대화 형식과 같은 말풍선 테두리 색상",
	color_name = "말풍선 색상",
	font_desc = "대화창에서 사용중인 글꼴과 같은 글꼴 사용",
	font_name = "대화 글꼴 사용",
	fontsize_desc = "말풍선 글꼴 크기 설정",
	fontsize_name = "글꼴 크기",
	format_desc = "대화 말풍선 내용에 Prat 서식을 적용합니다.",
	format_name = "문자열 서식",
	icons_desc = "말풍선에 전술 아이콘 표시하기.",
	icons_name = "전술 아이콘 표시",
	module_desc = "대화 말풍선과 관련된 사용자 설정",
	module_name = "말풍선",
	shorten_desc = "말풍선을 한 줄로 줄입니다. 말풍선에 마우스 오버하면 내용을 확장합니다.",
	shorten_name = "말풍선 축소",
	transparent_desc = "대화 말풍선의 배경과 테두리 텍스쳐를 숨깁니다. (이 옵션을 취소하려면 /reload 필요)",
	transparent_name = "투명한 말풍선",
}

  )
  L:AddLocale("esMX",
  {
	-- color_desc = "",
	-- color_name = "",
	-- font_desc = "",
	-- font_name = "",
	-- fontsize_desc = "",
	-- fontsize_name = "",
	-- format_desc = "",
	-- format_name = "",
	-- icons_desc = "",
	-- icons_name = "",
	-- module_desc = "",
	-- module_name = "",
	-- shorten_desc = "",
	-- shorten_name = "",
	-- transparent_desc = "",
	-- transparent_name = "",
}

  )
  L:AddLocale("ruRU",
  {
	color_desc = "Окрашивать границу облачка чата в цвет канала чата.",
	color_name = "Окрашивать облачка",
	font_desc = "Использовать тот же шрифт, что и в окне чата",
	font_name = "Шрифт чата",
	fontsize_desc = "Размер шрифта чата",
	fontsize_name = "Размер шрифта",
	format_desc = "Применить форматирование чата к тексту в облачках чата.",
	format_name = "Формат Текста",
	icons_desc = "Показать иконки рейда в облачках чата.",
	icons_name = "Показать метки цели рейда",
	module_desc = "Настройки, относящиеся к облачкам чата",
	module_name = "Облачка",
	shorten_desc = "Уменьшать облачка чата до одной строки. Наведите курсор на облачко, чтобы открыть текст полностью.",
	shorten_name = "Уменьшать облачка",
	-- transparent_desc = "",
	-- transparent_name = "",
}

  )
  L:AddLocale("zhCN",
  {
	color_desc = "把聊天泡泡颜色设为与聊天类型一致",
	color_name = "泡泡颜色",
	font_desc = "使用与聊天框相同的字体",
	font_name = "使用聊天字体",
	fontsize_desc = "设置聊天泡泡字体大小",
	fontsize_name = "字体大小",
	format_desc = "聊天泡泡文字应用 Prat's 格式",
	format_name = "格式化文字",
	icons_desc = "在聊天泡泡里显示团队图标。",
	icons_name = "显示团队图标",
	module_desc = "聊天泡泡相关自定义",
	module_name = "泡泡",
	shorten_desc = [=[缩短每个聊天气泡至一行. 鼠标移过气泡时展开文本.
]=],
	shorten_name = "缩短气泡",
	-- transparent_desc = "",
	-- transparent_name = "",
}

  )
  L:AddLocale("esES",
  {
	-- color_desc = "",
	-- color_name = "",
	-- font_desc = "",
	-- font_name = "",
	-- fontsize_desc = "",
	-- fontsize_name = "",
	-- format_desc = "",
	-- format_name = "",
	-- icons_desc = "",
	-- icons_name = "",
	-- module_desc = "",
	-- module_name = "",
	-- shorten_desc = "",
	-- shorten_name = "",
	-- transparent_desc = "",
	-- transparent_name = "",
}

  )
  L:AddLocale("zhTW",
  {
	-- color_desc = "",
	color_name = "顏色氣泡",
	-- font_desc = "",
	font_name = "使用聊天字型",
	fontsize_desc = "設定聊天氣泡字型尺寸",
	fontsize_name = "字型尺寸",
	-- format_desc = "",
	format_name = "格式文字",
	icons_desc = "顯示在聊天氣泡團隊圖示。",
	icons_name = "顯示團隊圖示",
	module_desc = "自訂對話泡泡",
	module_name = "對話泡泡",
	-- shorten_desc = "",
	shorten_name = "縮短氣泡",
	-- transparent_desc = "",
	-- transparent_name = "",
}

  )
  --@end-non-debug@

  local module = Prat:NewModule(PRAT_MODULE)

  Prat:SetModuleDefaults(module.name, {
    profile = {
      on = true,
      shorten = false,
      color = true,
      format = true,
      icons = true,
      font = true,
      transparent = false,
      fontsize = 14,
    }
  })

  local toggleOption = {
    name = function(info) return L[info[#info] .. "_name"] end,
    desc = function(info) return L[info[#info] .. "_desc"] end,
    type = "toggle",
  }

  Prat:SetModuleOptions(module.name, {
    name = L["module_name"],
    desc = L["module_desc"],
    type = "group",
    args = {
      shorten = toggleOption,
      color = toggleOption,
      format = toggleOption,
      icons = toggleOption,
      font = toggleOption,
      transparent = toggleOption,
      fontsize = {
        name = function(info) return L[info[#info] .. "_name"] end,
        desc = function(info) return L[info[#info] .. "_desc"] end,
        type = "range",
        min = 8,
        max = 32,
        step = 1,
        order = 101
      }
    }
  })

  --[[------------------------------------------------
    Module Event Functions
  ------------------------------------------------]] --

  local BUBBLE_SCAN_THROTTLE = 0.1

  -- things to do when the module is enabled
  function module:OnModuleEnable()
    self.update = self.update or CreateFrame('Frame');
    self.throttle = BUBBLE_SCAN_THROTTLE

    self.update:SetScript("OnUpdate",
      function(frame, elapsed)
        self.throttle = self.throttle - elapsed
        if frame:IsShown() and self.throttle < 0 then
          self.throttle = BUBBLE_SCAN_THROTTLE
          self:FormatBubbles()
        end
      end)

    self:RestoreDefaults()
    self:ApplyOptions()
  end

  function module:ApplyOptions()
    self.shorten = self.db.profile.shorten
    self.color = self.db.profile.color
    self.format = self.db.profile.format
    self.icons = self.db.profile.icons
    self.font = self.db.profile.font
    self.fontsize = self.db.profile.fontsize
    self.transparent = self.db.profile.transparent

    if self.shorten or self.color or self.format or self.icons or self.font or self.transparent then
      self.update:Show()
    else
      self.update:Hide()
    end
  end

  function module:OnValueChanged(info, b)
    self:RestoreDefaults()

    self:ApplyOptions()
  end

  function module:OnModuleDisable()
    self:RestoreDefaults()
  end

  function module:FormatBubbles()
    self:IterateChatBubbles("FormatCallback")
  end

  function module:RestoreDefaults()
    self.update:Hide()

    self:IterateChatBubbles("RestoreDefaultsCallback")
  end

  local MAX_CHATBUBBLE_WIDTH = 300

  -- Called for each chatbubble, passed the bubble's frame and its fontstring
  function module:FormatCallback(frame, fontstring)
    if not frame:IsShown() then
      fontstring.lastText = nil
      return
    end

    if self.shorten then
      local wrap = fontstring:CanWordWrap() or 0

      -- If the mouse is over, then expand the bubble
      if frame:IsMouseOver() then
        fontstring:SetWordWrap(true)
      elseif wrap == 1 then
        fontstring:SetWordWrap(false)
      end
    end

    MAX_CHATBUBBLE_WIDTH = math.min(UIParent:GetWidth() /2, math.max(frame:GetWidth(), MAX_CHATBUBBLE_WIDTH))

    local text = fontstring:GetText() or ""

    if text == fontstring.lastText then
      if self.shorten then
        fontstring:SetWidth(fontstring:GetWidth())
      end
      return
    end

    if self.color then
      -- Color the bubble border the same as the chat
      frame:SetBackdropBorderColor(fontstring:GetTextColor())
    end


    if self.font then
      local a, b, c = fontstring:GetFont()

      fontstring:SetFont(ChatFrame1:GetFont(), self.fontsize, c)
    end

    if self.transparent then
       -- Hide the border and background textures of the chat bubble
       --FIXME: remove texture from bubble tail
       frame:SetBackdrop(nil) -- remove texture from bubble (borders and background)
    end

    if self.icons then
      local term;
      for tag in string.gmatch(text, "%b{}") do
        term = strlower(string.gsub(tag, "[{}]", ""));
        if (ICON_TAG_LIST[term] and ICON_LIST[ICON_TAG_LIST[term]]) then
          text = string.gsub(text, tag, ICON_LIST[ICON_TAG_LIST[term]] .. "0|t");
        end
      end
    end

    if self.format then
      text = Prat.MatchPatterns(text)
      text = Prat.ReplaceMatches(text)
    end

    fontstring:SetText(text)
    fontstring.lastText = text
    fontstring:SetWidth(math.min(fontstring:GetStringWidth(), MAX_CHATBUBBLE_WIDTH - 14))
  end

  -- Called for each chatbubble, passed the bubble's frame and its fontstring
  function module:RestoreDefaultsCallback(frame, fontstring)
    frame:SetBackdropBorderColor(1, 1, 1, 1)
    fontstring:SetWordWrap(1)
    fontstring:SetWidth(fontstring:GetWidth())
  end

  function module:IterateChatBubbles(funcToCall)
    for i = 1, WorldFrame:GetNumChildren() do
      local v = select(i, WorldFrame:GetChildren())
      local b = v:GetBackdrop()
      if b and b.bgFile == "Interface\\Tooltips\\ChatBubble-Background" then
        for i = 1, v:GetNumRegions() do
          local frame = v
          local v = select(i, v:GetRegions())
          if v:GetObjectType() == "FontString" then
            local fontstring = v
            if type(funcToCall) == "function" then
              funcToCall(frame, fontstring)
            else
              self[funcToCall](self, frame, fontstring)
            end
          end
        end
      end
    end
  end

  return
end) -- Prat:AddModuleToLoad