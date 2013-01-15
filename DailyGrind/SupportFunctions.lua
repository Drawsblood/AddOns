-- Author      : Deldinor of Elune
-- Create Date : 10/25/2012 9:54:38 PM

repeatableQuestColor = "FFB0B0E0";
repeatableQuestText = "|c"..repeatableQuestColor.."Repeatable Quest|r";

function DailyGrind:GetAvailableQuestTitleIndex(index)
	return self:GetAvailableQuestOffset() * (index - 1) + 1;
end

function DailyGrind:GetActiveQuestTitleIndex(index)
	return self:GetActiveQuestOffset() * (index - 1) + 1;
end

function DailyGrind:GetAvailableQuestOffset()
	return 6;
end

function DailyGrind:GetActiveQuestOffset()
	return 5;
end

function DailyGrind:GetAvailableQuestIsDailyIndex()
	return 3;
end

function DailyGrind:GetAvailableQuestIsRepeatableIndex()
	return 4;
end

function DailyGrind:GetActiveQuestIsCompleteIndex()
	return 3;
end

function DailyGrind:GetNumPlayerActiveQuests()
	local numEntries, numQuests = GetNumQuestLogEntries();
	return numQuests;
end

function DailyGrind:GetSanitizedAvailableQuestTitle(availableQuests, index)
	local titleIdx = self:GetAvailableQuestTitleIndex(index);
	return self:SanitizeQuestTitle(availableQuests[titleIdx]);
end

function DailyGrind:GetSanitizedActiveQuestTitle(activeQuests, index)
	local titleIdx = self:GetActiveQuestTitleIndex(index);
	return self:SanitizeQuestTitle(activeQuests[titleIdx]);
end

function DailyGrind:IsDailyAvailableQuest(availableQuests, index)
	local titleIdx = self:GetAvailableQuestTitleIndex(index);
	local isDailyIdx = titleIdx + self:GetAvailableQuestIsDailyIndex();
	return availableQuests[isDailyIdx] == 1;
end

function DailyGrind:IsRepeatableAvailableQuest(availableQuests, index)
	local titleIdx = self:GetAvailableQuestTitleIndex(index);
	local isRepeatableIdx = titleIdx + self:GetAvailableQuestIsRepeatableIndex();
	return availableQuests[isRepeatableIdx] == 1;
end

function DailyGrind:IsDailyActiveQuest(activeQuestTitle)
	local numEntries, numQuests = GetNumQuestLogEntries();
	for i = 1, numEntries, 1 do
		local questTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(i);
		if self:SanitizeQuestTitle(questTitle) == activeQuestTitle then
			return isDaily == 1;
		end
	end
end

function DailyGrind:IsCompleteActiveQuest(activeQuests, index)
	local titleIdx = self:GetActiveQuestTitleIndex(index)
	local isCompleteIdx = titleIdx + self:GetActiveQuestIsCompleteIndex();
	return activeQuests[isCompleteIdx] == 1;
end

function DailyGrind:IsCompleteActiveQuest_Greeting(activeQuestTitle)
	local numEntries, numQuests = GetNumQuestLogEntries();
	for i = 1, numEntries, 1 do
		local questTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(i);
		if self:SanitizeQuestTitle(questTitle) == activeQuestTitle then
			self:Debug("Found \""..activeQuestTitle.."\"");
			return isComplete ~= nil;
		end
	end
end

function DailyGrind:IsRepeatableQuest(availableQuests, availableQuestTitle)
	for i = 1, GetNumGossipAvailableQuests(), 1 do
		local titleIdx = self:GetAvailableQuestTitleIndex(i);
		local questTitle = availableQuests[titleIdx];
		if self:SanitizeQuestTitle(questTitle) == availableQuestTitle and self:IsRepeatableAvailableQuest(availableQuests, i) then
			return true;
		end
	end
	return false;
end

function DailyGrind:IsSuspendKeyDown()
	local suspendKey = DailyGrind:GetSuspendKey();
	local suspendKeyDown = false;
	
	if suspendKey == "ALT" and IsAltKeyDown() then 
		suspendKeyDown = true;
	elseif suspendKey == "CTRL" and IsControlKeyDown() then
		suspendKeyDown = true;
	elseif suspendKey == "SHIFT" and IsShiftKeyDown() then
		suspendKeyDown = true;
	end
	
	if suspendKeyDown then
		self:Debug("Suspend Key ("..suspendKey..") is being held down.");
	end
	
	return suspendKeyDown;
end

function DailyGrind:PrintRepeatable(text)
	self:PrintDG(repeatableQuestText..tostring(text));
end

function DailyGrind:Debug(text)
	if debugModeEnabled then
		self:PrintDG("|cFFFF0000"..dgDebugText.."|r: "..tostring(text));
	end
end

function DailyGrind:PrintDG(text)
	print(addonAbbr.." "..tostring(text));
end