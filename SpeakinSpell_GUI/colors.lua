﻿-- Author      : RisM
-- Create Date : 11/21/2009 5:58:56 PM

local SpeakinSpell = LibStub("AceAddon-3.0"):GetAddon("SpeakinSpell")
local L = LibStub("AceLocale-3.0"):GetLocale("SpeakinSpell", false)

SpeakinSpell:PrintLoading("gui/colors.lua")

-------------------------------------------------------------------------------
-- GUI LAYOUT - COLOR SETTINGS
-------------------------------------------------------------------------------


SpeakinSpell.OptionsGUI.args.Colors = {
	order = 21,
	type = "group",
	name = COLORS,
	desc = L["Colors used by SpeakinSpell"],
	args = {
		Caption = {
			order = 1,
			type = "header",
			name = COLORS
		},
		Instructions = {
			order = 2,
			type = "description",
			name = "\n" .. L["The options below allow you to change the colors used by SpeakinSpell."] .. "\n",
		},
		GUIGroup = {
			order = 3,
			type = "group",
			guiInline = true,
			name = L["SpeakinSpell Options GUI Colors"],
			args = {
				Caption = {
					order = 1,
					type = "description",
					name = L["Colors used in the SS options GUI"],
				},
				SearchMatch = {
					type = "color",
					order = 2,
					name = function() return SpeakinSpell:ColorsGUI_ColorizeLabel("SearchMatch", L["Search Match"]) end,
					desc = L["The color used to highlight search matches in the options GUI"],
					hasAlpha = true,
					get = function(info)			return SpeakinSpell:ColorsGUI_GetStringColor("SearchMatch") end,
					set = function(info, r, g, b, a)return SpeakinSpell:ColorsGUI_SetStringColor("SearchMatch", r,g,b,a) end,
				},
				SelectedItem = {
					type = "color",
					order = 3,
					name = function() return SpeakinSpell:ColorsGUI_ColorizeLabel("SelectedItem", L["Selected Item"]) end,
					desc = L["The color used to highlight the name of the selected item in the group headings for areas of the SS options GUI screens"],
					hasAlpha = true,
					get = function(info)			return SpeakinSpell:ColorsGUI_GetStringColor("SelectedItem") end,
					set = function(info, r, g, b, a)return SpeakinSpell:ColorsGUI_SetStringColor("SelectedItem", r,g,b,a) end,
				},
				Headings = {
					type = "color",
					order = 4,
					name = function() return SpeakinSpell:ColorsGUI_ColorizeLabel("Headings", L["Headings"]) end,
					desc = L["The color used for main section headings in the options GUI"],
					hasAlpha = true,
					get = function(info)			return SpeakinSpell:ColorsGUI_GetStringColor("Headings") end,
					set = function(info, r, g, b, a)return SpeakinSpell:ColorsGUI_SetStringColor("Headings", r,g,b,a) end,
				},
				ClickHere = {
					type = "color",
					order = 5,
					name = function() return SpeakinSpell:ColorsGUI_ColorizeLabel("ClickHere", L["[Click Here]"]) end,
					desc = L["The color used for [Click Here] links in SpeakinSpell chat frame messages"],
					hasAlpha = true,
					get = function(info)			return SpeakinSpell:ColorsGUI_GetStringColor("ClickHere") end,
					set = function(info, r, g, b, a)return SpeakinSpell:ColorsGUI_SetStringColor("ClickHere", r,g,b,a) end,
				},
			},
		},
		ChatChannelsGroup = {
			order = 4,
			type = "group",
			guiInline = true,
			name = L["Chat Channel Colors"],
			args = {
				Caption = {
					order = 1,
					type = "description",
					name = L["Colors of SpeakinSpell's special chat channels."],
				},
				SpeakinSpell = {
					type = "color",
					order = 2,
					name = function() return SpeakinSpell:ColorsGUI_ColorizeChannel("SPEAKINSPELL CHANNEL", L["Self-Chat"]) end,
					desc = function() 
						local subs = {
							colorcode = SpeakinSpell.Colors.Channels["SPEAKINSPELL CHANNEL"],
							normalcolor = "|r",
							defaultcolor = SpeakinSpell.Colors.SPEAKINSPELL,
						}
						return SpeakinSpell:FormatSubs( L[
[[The color of <colorcode>SpeakinSpell:<normalcolor> in the self-chat channel.

This applies only to speech event announcements.  Status and debugging messages will always use the <defaultcolor>SpeakinSpell<normalcolor> color]]
							], subs)
					end,
					hasAlpha = true,
					get = function(info)			return SpeakinSpell:ColorsGUI_GetChannel("SPEAKINSPELL CHANNEL") end,
					set = function(info, r, g, b, a)return SpeakinSpell:ColorsGUI_SetChannel("SPEAKINSPELL CHANNEL", r,g,b,a) end,
				},
				SelfRaidWarn = {
					type = "color",
					order = 3,
					name = function() return SpeakinSpell:ColorsGUI_ColorizeChannel("SELF RAID WARNING CHANNEL", L["Self Raid Warnings"]) end,
					desc = L["The color of self-only raid warnings generated by SpeakinSpell"],
					hasAlpha = true,
					get = function(info)			return SpeakinSpell:ColorsGUI_GetChannel("SELF RAID WARNING CHANNEL") end,
					set = function(info, r, g, b, a)return SpeakinSpell:ColorsGUI_SetChannel("SELF RAID WARNING CHANNEL", r,g,b,a) end,
				},
				MysteriousVoice = {
					type = "color",
					order = 4,
					name = function() return SpeakinSpell:ColorsGUI_ColorizeChannel("MYSTERIOUS VOICE", L["[Mysterious Voice] whispers:"]) end,
					desc = L["The color of SpeakinSpell's Mysterious Voice channel option"],
					hasAlpha = true,
					get = function(info)			return SpeakinSpell:ColorsGUI_GetChannel("MYSTERIOUS VOICE") end,
					set = function(info, r, g, b, a)return SpeakinSpell:ColorsGUI_SetChannel("MYSTERIOUS VOICE", r,g,b,a) end,
				},
				CommTrafficRx = {
					type = "color",
					order = 5,
					name = function() return SpeakinSpell:ColorsGUI_ColorizeChannel("COMM TRAFFIC RX", L["Comm Traffic Rx"]) end,
					desc = L["The color of the Comm Traffic channel used to show data sharing progress for Inbound (Rx) data received"],
					hasAlpha = true,
					get = function(info)			return SpeakinSpell:ColorsGUI_GetChannel("COMM TRAFFIC RX") end,
					set = function(info, r, g, b, a)return SpeakinSpell:ColorsGUI_SetChannel("COMM TRAFFIC RX", r,g,b,a) end,
				},
				CommTrafficTx = {
					type = "color",
					order = 5,
					name = function() return SpeakinSpell:ColorsGUI_ColorizeChannel("COMM TRAFFIC TX", L["Comm Traffic Tx"]) end,
					desc = L["The color of the Comm Traffic channel used to show data sharing progress for Outbound (Tx) data sent"],
					hasAlpha = true,
					get = function(info)			return SpeakinSpell:ColorsGUI_GetChannel("COMM TRAFFIC TX") end,
					set = function(info, r, g, b, a)return SpeakinSpell:ColorsGUI_SetChannel("COMM TRAFFIC TX", r,g,b,a) end,
				},
			},
		},		
	}
}


-------------------------------------------------------------------------------
-- OPTIONS GUI FUNCTIONS - COLORS PAGE
-------------------------------------------------------------------------------


function SpeakinSpell:ColorsGUI_GetChannel(ChannelName)
	local t = SpeakinSpellSavedData.Colors.Channels[ChannelName]
	return t.r, t.g, t.b, t.a
end


function SpeakinSpell:ColorsGUI_SetChannel(ChannelName, r,g,b,a)
	local t = SpeakinSpellSavedData.Colors.Channels[ChannelName]
	t.r, t.g, t.b, t.a = r, g, b, a
	
	-- update SpeakinSpell.Colors.Channels	
	if not SpeakinSpell.Colors.Channels then
		-- NOTE: LoadChatColorCodes can't be done during OnInitialize or OnVariablesLoaded because 
		--		default UI chat channel colors are loaded by the game engine after all addons
		--		so we might have to do it here
		self:LoadChatColorCodes() -- creates SpeakinSpell.Colors.Channels from SpeakinSpellSavedData and other options in the default UI
	else -- this is a line from LoadChatColorCodes for this specific color that we're changing
		SpeakinSpell.Colors.Channels[ChannelName] = string.format( "|c%02x%02x%02x%02x", 255*t.a, 255*t.r, 255*t.g, 255*t.b )
	end
end


function SpeakinSpell:ColorsGUI_GetStringColor(ColorName)
	-- SpeakinSpellSavedData.Colors[ColorName] is a string "|cff123456"
	local t = self:StringColorCodeToTable( SpeakinSpellSavedData.Colors[ColorName] )
	return t.r, t.g, t.b, t.a
end


function SpeakinSpell:ColorsGUI_SetStringColor(ColorName, r,g,b,a)
	SpeakinSpellSavedData.Colors[ColorName] =  string.format( "|c%02x%02x%02x%02x", a*255, r*255, g*255, b*255 )
end


function SpeakinSpell:ColorsGUI_ColorizeChannel(ChannelName, Label)
	-- NOTE: LoadChatColorCodes can't be done during OnInitialize or OnVariablesLoaded 
	--		because default UI chat channel colors that it also uses are loaded by the game engine after all addons
	--		so we must ensure we late-load the info here, to create the SpeakinSpell.Colors.Channels table
	-- HOWEVER: also note that /ss reset -> InitRuntimeData can not LoadChatColorCodes() either
	--		because that is used OnVariablesLoaded if this is a first-time run on a new install
	--		so in case a reset was just triggered, we must reload this information every time here
	--		it's a minor speed hit in theory, but completely unnoticeable in practice because computers are fast
	-- We also can't rely on the GUI module to have been loaded on demand yet
	self:LoadChatColorCodes() --creates/refreshes SpeakinSpell.Colors.Channels from SpeakinSpellSavedData
	local colorcode = SpeakinSpell.Colors.Channels[ChannelName]
	return colorcode..Label
end


function SpeakinSpell:ColorsGUI_ColorizeLabel(ColorName, Label)
	--NOTE: self:LoadChatColorCodes() is unnecessary here because 
	--	we're dealing exclusively with SpeakinSpellSavedData for this group of colors and don't need SpeakinSpell.Colors.Channels
	local colorcode = SpeakinSpellSavedData.Colors[ColorName]
	--local colorcode = string.format( "|c%02x%02x%02x%02x", 255*t.a, 255*t.r, 255*t.g, 255*t.b )
	return colorcode..Label
end

