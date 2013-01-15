-- Author      : Deldinor of Elune
-- Create Date : 2/12/2011 3:01:46 PM
-- Notes       : Much of this logic duplicates the Reward List.
--               Will attempt to refactor and merge the functionality at a later date.

blacklistColor = "FF808080";
blacklistText = "|c"..blacklistColor.."Blacklist|r";

function DailyGrind:HandleBlacklist(args)
	if table.getn(args) == 1 then
		self:PrintBlacklist(":");
		if self:GetBlacklistCount() > 0 then
			for index, value in pairs(DailyGrindSettings.Blacklist) do
				print("     "..index);
			end
		else
			print("     <empty>");
		end
	elseif args[2] ~= nil then
		local action = args[2]:trim():lower();
		local questTitle = "";
		if args[3] ~= nil then
			questTitle = args[3]:trim():gsub("\"", "");			-- get rid of double-quotes (people may assume they're necessary around the quest name)
			questTitle = questTitle:gsub("<", ""):gsub(">", "")	-- and angle brackets, in case people take the documentation too literally...
		end
		if action == "add" then
			self:Blacklist_Add(questTitle);
		elseif action == "remove" or action == "rem" then
			self:Blacklist_Remove(questTitle);
		elseif action == "clear" then
			DailyGrindSettings.Blacklist = {};
			self:PrintBlacklist(" cleared.");
		elseif action == "help" then
			self:ShowBlacklistHelp();
		end
	else
		self:ShowHelp();
	end
end

function DailyGrind:FindBlacklistIndex(questTitle)
	return self:FindIndex(DailyGrindSettings.Blacklist, questTitle);
end

function DailyGrind:IsBlacklisted(questTitle)
	return self:IsInList(DailyGrindSettings.Blacklist, questTitle);
end

function DailyGrind:GetBlacklistCount()
	return self:TableCount(DailyGrindSettings.Blacklist);
end

function DailyGrind:Blacklist_Add(questTitle)
	if questTitle == "" then
		self:PrintBlacklist(" needs a quest title to add.");
		return;
	end
	if not self:IsBlacklisted(questTitle) then
		DailyGrindSettings.Blacklist[questTitle] = self:GetBlacklistCount() + 1;
		self:PrintBlacklist(": \""..questTitle.."\" added.");
	else
		self:PrintBlacklist(": \""..self:FindBlacklistIndex(questTitle).."\" already exists");
	end
end

function DailyGrind:Blacklist_Remove(questTitle)
	if questTitle == "" then
		self:PrintBlacklist(" needs a quest title to remove.");
		return;
	end
	if self:IsBlacklisted(questTitle) then
		local index = self:FindBlacklistIndex(questTitle);
		DailyGrindSettings.Blacklist[index] = nil;
		self:PrintBlacklist(": \""..index.."\" removed.");
	else
		self:PrintBlacklist(": \""..questTitle.."\" not found.");
	end
end

function DailyGrind:Blacklist_ToString()
	local blist = "";
	for index = 1, DailyGrind:GetBlacklistCount() do
		local questTitle = DailyGrind:FindIndexByValue(DailyGrindSettings.Blacklist, index);
		if questTitle ~= nil then
			blist = blist..questTitle.."\n";
		end
	end
	return blist;
end

function DailyGrind:Blacklist_Populate(quests)
	DailyGrindSettings.Blacklist = {};
	for index, questTitle in pairs(quests) do
		if questTitle ~= "" then
			DailyGrindSettings.Blacklist[self:SanitizeQuestTitle(questTitle)] = DailyGrind:GetBlacklistCount() + 1;
		end
	end
	self:PrintBlacklist(" updated.");
end

function DailyGrind:PrintBlacklist(text)
	self:PrintDG(blacklistText..tostring(text));
end

function DailyGrind:ShowBlacklistHelp()
	print("==  "..addonTitle.." - "..blacklistText.."  ==\n");
	print("Usage:");
	print("  Show List: |c"..commandColor.."/dg /blacklist (or simply /bl)");
	print("  Add: |c"..commandColor.."/dg /bl add <quest title>");
	print("  Remove: |c"..commandColor.."/dg /bl rem[ove] <quest title>");
	print("  Clear: |c"..commandColor.."/dg /bl clear");
	print(blacklistText.." quest titles are NOT case-sensitive, but all punctuation is required. You may may also use |c"..commandColor.."*|r as a wildcard.\n");
end