-- Author      : Deldinor of Elune
-- Create Date : 2/20/2011 3:01:53 PM

function DailyGrind:ShowOptions()
	InterfaceOptionsFrame_OpenToCategory(addonName)
end

DailyGrind.defaultSettings = {
	Enabled = true,
	Blacklist = {},
	NpcBlacklist = {},
	Rewards = {},
	AutoAcceptAllEnabled = false,
	SuspendKey = "CTRL"
}

DailyGrind.Options = {
	type = "group",
	name = addonFullName,
	get = function(info) return DailyGrindSettings[ info[#info] ] end,
	set = function(info, value) DailyGrindSettings[ info[#info] ] = value end,
	args = {
		General = {
			order = 1,
			type = "group",
			name = "General Settings",
			desc = "General Settings",
			args = {
				Enabled = {
					type = "toggle",
					name = "Enabled",
					desc = "Enables or disables "..addonTitle.."'s automation functions, though your completed quests will still be recorded.",
					order = 1,
					set = function(info, value)
						DailyGrind:SetEnabled(value);
					end,
				},
				AutoAcceptAllEnabled = {
					type = "toggle",
					name = "Accept ALL dailies",
					desc = "Optionally allows you to accept ALL daily quests you encounter, even if you've never encountered them before. Your completed quests will still be recorded into your history while this option is enabled.",
					order = 2,
					set = function(info, value)
						DailyGrind:SetAutoAcceptAllEnabled(value);
					end,
				},
				intro = {
					order = 3,
					type = "description",
					name = "\n"..addonTitle.." auto-accepts and auto-completes daily and repeatable quests as you encounter them.\n\nDaily quests that you complete are added to your quest history. Whenever you see that daily again, you will automatically accept and complete it. This approach is taken so that players may read through quests that they have not yet encountered.\n"
				},
				Blacklist = {
					type = "input",
					multiline = true,
					name = "Blacklist",
					desc = "Add any quests that you don't want "..addonTitle.." to auto-accept or auto-complete, |c"..commandColor.."one quest per line|r. Proper capitalization is not required, but all other characters in the quest name must be accurate. You may may also use |c"..commandColor.."*|r as a wildcard.",
					order = 5,
					get = function(info)
						return DailyGrind:Blacklist_ToString();
					end,
					set = function(info, value)
						local questList = { strsplit("\n", value:trim()) };
						DailyGrind:Blacklist_Populate(questList);
					end,
				},
				NpcBlacklist = {
					type = "input",
					multiline = true,
					name = "NPC Blacklist",
					desc = "Add any NPCs that you don't want "..addonTitle.." to auto-accept or auto-complete quests from, |c"..commandColor.."one NPC per line|r. Proper capitalization is not required, but all other characters in the NPC name must be accurate. You may may also use |c"..commandColor.."*|r as a wildcard.",
					order = 6,
					get = function(info)
						return DailyGrind:NpcBlacklist_ToString();
					end,
					set = function(info, value)
						local npcList = { strsplit("\n", value:trim()) };
						DailyGrind:NpcBlacklist_Populate(npcList);
					end,
				},
				Rewards = {
					type = "input",
					multiline = true,
					name = "Reward List",
					desc = "Add any quest rewards that you want "..addonTitle.." to automatically select, |c"..commandColor.."one reward per line|r. Proper capitalization is not required, but all other characters in the reward name must be accurate. You may may also use |c"..commandColor.."*|r as a wildcard.",
					order = 7,
					get = function(info)
						return DailyGrind:RewardList_ToString();
					end,
					set = function(info, value)
						local itemList = { strsplit("\n", value:trim()) };
						DailyGrind:RewardList_Populate(itemList);
					end,
				},
				SuspendKey = {
					type = "select",
					name = "Suspend Key",
					desc = "Suspend all automation by holding down the specified key while talking to an NPC.",
					order = 8,
					values = {
								["ALT"] = "ALT",
								["CTRL"] = "CTRL (Default)",
								["SHIFT"] = "SHIFT"
							 },
					set = function(info, value)
						DailyGrind:SetSuspendKey(value);
					end,
				},
				questHistoryGroup = {
					type = "group",
					name = "Quest History",
					guiInline = true,
					order = 9,
					args = {
						importIntro = {
							order = 1,
							type = "description",
							name = "You may start over by clicking the |c"..commandColor.."Clear Quest History|r button. This applies to all characters on your account.\n"
						},
						clear = {
							type = "execute",
							order = 2,
							name = "Clear Quest History",
							desc = "Reset your quest history. This applies to all characters on your account.",
							func = function()
								DailyGrind:Reset();
							end,
						},
					},
				},
			},
		},
	},
}
