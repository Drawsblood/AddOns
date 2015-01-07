--[[
##############################################################################
_____/\\\\\\\\\\\____/\\\________/\\\__/\\\________/\\\__/\\\\\\\\\\\_       #
 ___/\\\/////////\\\_\/\\\_______\/\\\_\/\\\_______\/\\\_\/////\\\///__      #
  __\//\\\______\///__\//\\\______/\\\__\/\\\_______\/\\\_____\/\\\_____     #
   ___\////\\\__________\//\\\____/\\\___\/\\\_______\/\\\_____\/\\\_____    #
    ______\////\\\________\//\\\__/\\\____\/\\\_______\/\\\_____\/\\\_____   #
     _________\////\\\______\//\\\/\\\_____\/\\\_______\/\\\_____\/\\\_____  #
      __/\\\______\//\\\______\//\\\\\______\//\\\______/\\\______\/\\\_____ #
       _\///\\\\\\\\\\\/________\//\\\________\///\\\\\\\\\/____/\\\\\\\\\\\_#
        ___\///////////___________\///___________\/////////_____\///////////_#
##############################################################################
S U P E R - V I L L A I N - U I   By: Munglunch                              #
##############################################################################
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack 	 =  _G.unpack;
local pairs 	 =  _G.pairs;
local tinsert 	 =  _G.tinsert;
local table 	 =  _G.table;
--[[ TABLE METHODS ]]--
local tsort = table.sort;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = _G["SVUI"];
local L = SV.L;
local MOD = SV.SVChat;
--[[ 
########################################################## 
SET PACKAGE OPTIONS
##########################################################
]]--
SV.Options.args.SVChat={
	type = "group", 
	name = MOD.TitleID, 
	get = function(a)return SV.db.SVChat[a[#a]]end, 
	set = function(a,b)MOD:ChangeDBVar(b,a[#a]); end, 
	args = {
		intro = {
			order = 1, 
			type = "description", 
			name = L["CHAT_DESC"]
		},
		enable = {
			order = 2, 
			type = "toggle", 
			name = L["Enable"], 
			get = function(a)return SV.db.SVChat.enable end, 
			set = function(a,b)SV.db.SVChat.enable = b;SV:StaticPopup_Show("RL_CLIENT")end
		},
		common = {
			order = 3, 
			type = "group", 
			name = L["General"], 
			guiInline = true, 
			args = {
				sticky = {
					order = 1, 
					type = "toggle", 
					name = L["Sticky Chat"], 
					desc = L["When opening the Chat Editbox to type a message having this option set means it will retain the last channel you spoke in. If this option is turned off opening the Chat Editbox should always default to the SAY channel."]
				},
				url = {
					order = 2, 
					type = "toggle", 
					name = L["URL Links"], 
					desc = L["Attempt to create URL links inside the chat."],
					set = function(a,b) MOD:ChangeDBVar(b,a[#a]) end
				},
				hyperlinkHover = {
					order = 3, 
					type = "toggle", 
					name = L["Hyperlink Hover"], 
					desc = L["Display the hyperlink tooltip while hovering over a hyperlink."], 
					set = function(a,b) MOD:ChangeDBVar(b,a[#a]); MOD:ToggleHyperlinks(b); end
				},
				smileys = {
					order = 4, 
					type = "toggle", 
					name = L["Emotion Icons"], 
					desc = L["Display emotion icons in chat."]
				},
				tabStyled = {
					order = 5, 
					type = "toggle", 
					name = L["Custom Tab Style"],
					set = function(a,b) MOD:ChangeDBVar(b,a[#a]);SV:StaticPopup_Show("RL_CLIENT") end, 
				},
				timeStampFormat = {
					order = 6, 
					type = "select", 
					name = TIMESTAMPS_LABEL, 
					desc = OPTION_TOOLTIP_TIMESTAMPS, 
					values = {
						["NONE"] = NONE, 
						["%I:%M "] = "03:27", 
						["%I:%M:%S "] = "03:27:32", 
						["%I:%M %p "] = "03:27 PM", 
						["%I:%M:%S %p "] = "03:27:32 PM", 
						["%H:%M "] = "15:27", 
						["%H:%M:%S "] = "15:27:32"
					}
				},
				psst = {
					order = 7, 
					type = "select", 
					dialogControl = "LSM30_Sound", 
					name = L["Whisper Alert"], 
					disabled = function()return not SV.db.SVChat.psst end, 
					values = AceGUIWidgetLSMlists.sound,
					set = function(a,b) MOD:ChangeDBVar(b,a[#a]) end
				},
				spacer2 = {
					order = 8, 
					type = "description", 
					name = ""
				},
				throttleInterval = {
					order = 9, 
					type = "range", 
					name = L["Spam Interval"], 
					desc = L["Prevent the same messages from displaying in chat more than once within this set amount of seconds, set to zero to disable."], 
					min = 0, 
					max = 120, 
					step = 1,
					width = "full",
					set = function(a,b) MOD:ChangeDBVar(b,a[#a]) end
				},
			}
		},
	}
}