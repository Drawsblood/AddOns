-- Author      : Deldinor of Elune
-- Create Date : 2/12/2011 3:01:53 PM
-- Notes       : Much of this logic duplicates the Rewards.
--               Will attempt to refactor and merge the functionality at a later date.

rewardListColor = "FFC1FFC5";
rewardListText = "|c"..rewardListColor.."Reward List|r";

function DailyGrind:HandleRewardList(args)
	if table.getn(args) == 1 then
		self:PrintRewardList(":");
		if self:GetRewardListCount() > 0 then
			for index, value in pairs(DailyGrindSettings.Rewards) do
				print("     "..index);
			end
		else
			print("     <empty>");
		end
	elseif args[2] ~= nil then
		local action = args[2]:trim():lower();
		local itemName = "";
		if args[3] ~= nil then
			itemName = args[3]:trim():gsub("\"", "");		-- get rid of double-quotes (people may assume they're necessary around the quest name)
			itemName = itemName:gsub("<", ""):gsub(">", "")	-- and angle brackets, in case people take the documentation too literally...
		end
		if action == "add" then
			self:RewardList_Add(itemName);
		elseif action == "remove" or action == "rem" then
			self:RewardList_Remove(itemName);
		elseif action == "clear" then
			DailyGrindSettings.Rewards = {};
			self:PrintRewardList(" cleared.");
		elseif action == "help" then
			self:ShowRewardListHelp();
		end
	else
		self:ShowHelp();
	end
end

function DailyGrind:GetMatchingQuestRewards()
	local choices = {};
	for i = 1, GetNumQuestChoices(), 1 do
		local name, texture, numItems, quality, isUsable = GetQuestItemInfo("choice", i);
		for index, value in pairs(DailyGrindSettings.Rewards) do
			if name:trim():lower() == index:trim():lower() then
				choices[i] = name;
			end
		end
	end
	return choices;
end

function DailyGrind:FindRewardListIndex(itemName)
	return self:FindIndex(DailyGrindSettings.Rewards, itemName);
end

function DailyGrind:IsInRewardList(itemName)
	return self:IsInList(DailyGrindSettings.Rewards, itemName);
end

function DailyGrind:GetRewardListCount()
	return self:TableCount(DailyGrindSettings.Rewards);
end

function DailyGrind:RewardList_Add(itemName)
	if itemName == "" then
		self:PrintRewardList(" needs an item name to add.");
		return;
	end
	if not self:IsInRewardList(itemName) then
		DailyGrindSettings.Rewards[itemName] = self:GetRewardListCount() + 1;
		self:PrintRewardList(": \""..itemName.."\" added.");
	else
		self:PrintRewardList(": \""..self:FindRewardListIndex(itemName).."\" already exists.");
	end
end

function DailyGrind:RewardList_Remove(itemName)
	if itemName == "" then
		self:PrintRewardList(" needs a item name to remove.");
		return;
	end
	if self:IsInRewardList(itemName) then
		local index = self:FindRewardListIndex(itemName);
		DailyGrindSettings.Rewards[index] = nil;
		self:PrintRewardList(": \""..index.."\" removed.");
	else
		self:PrintRewardList(": \""..itemName.."\" not found.");
	end
end

function DailyGrind:RewardList_ToString()
	local rlist = "";
	for index = 1, DailyGrind:GetRewardListCount() do
		local itemName = DailyGrind:FindIndexByValue(DailyGrindSettings.Rewards, index);
		if itemName ~= nil then
			rlist = rlist..itemName.."\n";
		end
	end
	return rlist;
end

function DailyGrind:RewardList_Populate(rewards)
	DailyGrindSettings.Rewards = {};
	DailyGrindSettings.RewardList = nil;
	for index, itemName in pairs(rewards) do
		if itemName ~= "" then
			DailyGrindSettings.Rewards[itemName] = DailyGrind:GetRewardListCount() + 1;
		end
	end
	self:PrintRewardList(" updated.");
end

function DailyGrind:PrintRewardList(text)
	self:PrintDG(rewardListText..tostring(text));
end

function DailyGrind:ShowRewardListHelp()
	print("==  "..addonTitle.." - "..rewardListText.."  ==\n");
	print("Usage:");
	print("  Show List: |c"..commandColor.."/dg /rewardlist (or simply /rl)");
	print("  Add: |c"..commandColor.."/dg /rl add <item name>");
	print("  Remove: |c"..commandColor.."/dg /rl rem[ove] <item name>");
	print("  Clear: |c"..commandColor.."/dg /rl clear");
	print(rewardListText.." reward names are NOT case-sensitive, but all punctuation is required. You may may also use |c"..commandColor.."*|r as a wildcard.\n");
end