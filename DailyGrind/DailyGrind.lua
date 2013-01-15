-- Author      : Deldinor of Elune
-- Create Date : 2/1/2011 7:31:49 AM

addonName = "DailyGrind";
addonFullName = "Daily Grind";

dgDebugText = "DEBUG";
debugModeEnabled = false;
disableTurnIn = false;

DailyGrind = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0", "AceEvent-3.0");
DailyGrind.version = GetAddOnMetadata(addonName, "Version");

BINDING_HEADER_DAILYGRIND = addonFullName;

local titleColor = "FF70B7FF";
addonTitle = "|c"..titleColor..addonFullName.."|r";
addonAbbr = "|c"..titleColor.."[DG]|r";
commandColor = "FFFFC654";
disabledText = "|cFFFF0000DISABLED|r";
enabledText = "|cFF00FF00ENABLED|r";
maxQuests = 25;

function DailyGrind:OnInitialize()
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(addonName, self.Options)
	local configDialog = LibStub("AceConfigDialog-3.0")
	self.optionsFrames = {}
	self.optionsFrames.DailyGrind = configDialog:AddToBlizOptions(addonName, addonName, nil, "General")
	
    self:RegisterChatCommand("dailygrind", "ChatCommand");
    self:RegisterChatCommand("dg", "ChatCommand");
    self:InitializeSettings();
end

function DailyGrind:InitializeSettings()
	if DailyGrindSettings == nil then
		DailyGrindSettings = self.defaultSettings;
	end
	DailyGrindSettings.Version = nil;
	if DailyGrindQuests == nil then
		DailyGrindQuests = {};
	end
	if DailyGrindSettings.NpcBlacklist == nil then
		DailyGrindSettings.NpcBlacklist = {};
	end
	if DailyGrindSettings.SuspendKey == nil then
		DailyGrindSettings.SuspendKey = "CTRL";
	end
end

function DailyGrind:OnEnable()
    self:RegisterEvent("GOSSIP_SHOW");
    self:RegisterEvent("QUEST_GREETING");
    self:RegisterEvent("QUEST_DETAIL");
    self:RegisterEvent("QUEST_PROGRESS");
    self:RegisterEvent("QUEST_COMPLETE");
end

function DailyGrind:GOSSIP_SHOW()
	self:Debug("GOSSIP_SHOW");
	
	if not DailyGrindSettings.Enabled or self:IsSuspendKeyDown() then
		return;
	end	
	
	local numAvailableQuests = GetNumGossipAvailableQuests();
	local numActiveQuests = GetNumGossipActiveQuests();

	self:Debug(tostring(numActiveQuests).." active quest(s) detected.");
	
	local npcName, realm = UnitName("npc");
	if self:IsBlacklistedNpc(npcName) and (numAvailableQuests > 0 or numActiveQuests > 0) then
		self:PrintNpcBlacklist(": \""..npcName.."\" ignored.");
		return;
	end
	
	-- Turn in known completed quests.
	if numActiveQuests > 0 then
		local activeQuests = {GetGossipActiveQuests()};
		for i = 1, numActiveQuests, 1 do
			local questTitle = self:GetSanitizedActiveQuestTitle(activeQuests, i);
			local isComplete = self:IsCompleteActiveQuest(activeQuests, i)
			local isDaily = self:IsDailyActiveQuest(questTitle);
			local isInHistory = self:IsInList(DailyGrindQuests, questTitle);
			
			if (isInHistory or self:GetAutoAcceptAllEnabled()) and isDaily and isComplete then
				if self:IsBlacklisted(questTitle) then
					self:PrintBlacklist(": \""..questTitle.."\" ignored.");
				else
					SelectGossipActiveQuest(i);
				end
			end
		end
	end
	
	-- Accept known available quests.
	if numAvailableQuests > 0 then
		local availableQuests = {GetGossipAvailableQuests()};
		for i = 1, numAvailableQuests, 1 do
			local questTitle = self:SanitizeQuestTitle(availableQuests[self:GetAvailableQuestTitleIndex(i)]);
			local isDaily = self:IsDailyAvailableQuest(availableQuests, i);
			local isRepeatable = self:IsRepeatableAvailableQuest(availableQuests, i);
			local isInHistory = self:IsInList(DailyGrindQuests, questTitle);
			
			if isRepeatable then
				self:PrintRepeatable(": \""..questTitle.."\" ignored. Select to turn in.");
			elseif (isInHistory or self:GetAutoAcceptAllEnabled()) and isDaily then
				if self:IsBlacklisted(questTitle) then
					self:PrintBlacklist(": \""..questTitle.."\" ignored.");
				else
					if self:GetNumPlayerActiveQuests() < maxQuests then
						SelectGossipAvailableQuest(i);
					else
						self:PrintDG("Cannot auto-accept \""..questTitle.."\": Quest log is full.");
					end
				end
			end
		end
	end
	
end

function DailyGrind:QUEST_GREETING()
	self:Debug("QUEST_GREETING");
	
	if not DailyGrindSettings.Enabled or self:IsSuspendKeyDown() then 
		return; 
	end	
	
	local numAvailableQuests = GetNumAvailableQuests(); 
	local numActiveQuests = GetNumActiveQuests();

	self:Debug(tostring(numActiveQuests).." active quest(s) detected.");

	local npcName, realm = UnitName("npc");
	if self:IsBlacklistedNpc(npcName) and (numAvailableQuests > 0 or numActiveQuests > 0) then
		self:PrintNpcBlacklist(": \""..npcName.."\" ignored.");
		return;
	end
	
	-- Turn in known completed quests. 
	if numActiveQuests > 0 then 
		for i = 1, numActiveQuests, 1 do
			local questTitle = self:SanitizeQuestTitle(GetActiveTitle(i));
			local isComplete = self:IsCompleteActiveQuest_Greeting(questTitle)
			local isDaily = self:IsDailyActiveQuest(questTitle);
			local isInHistory = self:IsInList(DailyGrindQuests, questTitle);
			
			self:Debug(questTitle.." isComplete = "..tostring(isComplete));
			
			if (isInHistory or self:GetAutoAcceptAllEnabled()) and isDaily and isComplete then 
				if self:IsBlacklisted(questTitle) then 
					self:PrintBlacklist(": \""..questTitle.."\" ignored.");
				else
					self:Debug("Selecting \""..questTitle.."\"");
					SelectActiveQuest(i); 
				end 
			end 
		end 
	end

	-- Accept known available quests.
	if numAvailableQuests > 0 then 
		for i = 1, numAvailableQuests, 1 do
			local questTitle = self:SanitizeQuestTitle(GetAvailableTitle(i));
			local isTrivial, isDaily, isRepeatable = GetAvailableQuestInfo(i)
			local isInHistory = self:IsInList(DailyGrindQuests, questTitle);
						
			if isRepeatable then
				self:PrintRepeatable(": \""..questTitle.."\" ignored. Select to turn in.");
			elseif (isInHistory or self:GetAutoAcceptAllEnabled()) and isDaily then
				if self:IsBlacklisted(questTitle) then 
					self:PrintBlacklist(": \""..questTitle.."\" ignored.");
				else 
					if self:GetNumPlayerActiveQuests() < maxQuests then 
						SelectAvailableQuest(i); 
					else 
						self:PrintDG("Cannot auto-accept \""..questTitle.."\": Quest log is full."); 
					end 
				end
			end
		end
	end
	
end

function DailyGrind:QUEST_DETAIL()
	self:Debug("QUEST_DETAIL");
	
	local questTitle = self:SanitizeQuestTitle(GetTitleText());
	local npcName, realm = UnitName("npc");
	
	if not DailyGrindSettings.Enabled or self:IsSuspendKeyDown() or self:IsBlacklisted(questTitle) or self:IsBlacklistedNpc(npcName) then
		return;
	end
	
	local isDailyOrWeekly = QuestIsDaily() == 1 or QuestIsWeekly() == 1;
	local isRepeatable = self:IsRepeatableQuest({GetGossipAvailableQuests()}, questTitle);
	local isInHistory = self:IsInList(DailyGrindQuests, questTitle);
		
	if (isInHistory or self:GetAutoAcceptAllEnabled()) and (isDailyOrWeekly or isRepeatable) then
		if self:GetNumPlayerActiveQuests() < maxQuests then
			AcceptQuest();
		else
			self:PrintDG("Cannot auto-accept \""..questTitle.."\": Quest log is full.");
		end
	end
end

function DailyGrind:QUEST_PROGRESS()
	self:Debug("QUEST_PROGRESS");
	
	local questTitle = self:SanitizeQuestTitle(GetTitleText());
	local npcName, realm = UnitName("npc");
	
	if not DailyGrindSettings.Enabled or self:IsSuspendKeyDown() or self:IsBlacklisted(questTitle) or self:IsBlacklistedNpc(npcName) then
		return;
	end
	
	local isCompletable = IsQuestCompletable() == 1;
	local isDailyOrWeekly = QuestIsDaily() == 1 or QuestIsWeekly() == 1;
	local isRepeatable = self:IsRepeatableQuest({GetGossipAvailableQuests()}, questTitle);
	local isInHistory = self:IsInList(DailyGrindQuests, questTitle);
		
	if (isInHistory or self:GetAutoAcceptAllEnabled()) and (isDailyOrWeekly or isRepeatable) and isCompletable then
		CompleteQuest();
	end
end

function DailyGrind:QUEST_COMPLETE()
	self:Debug("QUEST_COMPLETE");
	
	local questTitle = self:SanitizeQuestTitle(GetTitleText());
	local npcName, realm = UnitName("npc");
	local isDailyOrWeekly = QuestIsDaily() == 1 or QuestIsWeekly() == 1;
	local isRepeatable = self:IsRepeatableQuest({GetGossipAvailableQuests()}, questTitle);
	local isInHistory = self:IsInList(DailyGrindQuests, questTitle);

	--Attempt to turn in and record.
	if DailyGrindSettings.Enabled and not self:IsSuspendKeyDown() and not self:IsBlacklisted(questTitle) and not self:IsBlacklistedNpc(npcName) then
		if (isInHistory or self:GetAutoAcceptAllEnabled()) and (isDailyOrWeekly or isRepeatable) then
			local numQuestChoices = GetNumQuestChoices();
			if numQuestChoices <= 1 then
				self:Debug(questTitle.." reward: Single item.");
				if not disableTurnIn then
					GetQuestReward(numQuestChoices);
				end
			else
				self:Debug(questTitle.." reward: Multiple items available.");
				if not disableTurnIn then
					self:SelectReward(questTitle);
				end
			end
		end
	end
	
	if (isDailyOrWeekly or isRepeatable) and not isInHistory then
		DailyGrindQuests[questTitle] = 1;	-- always record, even when disabled
	end
end

function DailyGrind:SelectReward(questTitle)
	local myChoices = self:GetMatchingQuestRewards();
	local numMyChoices = self:TableCount(myChoices);
	if numMyChoices == 1 then	-- Exactly one matching item. Happy path.
		local choiceIndex, itemName;
		for index, value in pairs(myChoices) do
			choiceIndex = index;
			itemName = value;
		end
		self:PrintRewardList(": \""..questTitle.."\" => \""..itemName.."\" automatically selected.");
		GetQuestReward(choiceIndex);
	elseif numMyChoices > 1 then	-- 2+ matching items. Not so happy.
		self:PrintRewardList(": \""..questTitle.."\" => Multiple matches found:\n");
		for index, value in pairs(myChoices) do	-- Build a string that displays all the conflicting rewards.
			print(" - "..value);
		end
		print("  Please choose your reward manually and then review your "..rewardListText..".\n");
	else	-- No matching items. Sad.
		self:PrintRewardList(": \""..questTitle.."\" => No matching rewards found; please choose manually.");
	end
end