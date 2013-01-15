-- Author      : Deldinor of Elune
-- Create Date : 10/20/2012 10:21:57 PM

npcBlacklistColor = "FFA9A9A9";
npcBlacklistText = "|c"..npcBlacklistColor.."NPC Blacklist|r";

function DailyGrind:HandleNpcBlacklist(args)
	if table.getn(args) == 1 then
		self:PrintNpcBlacklist(":");
		if self:GetNpcBlacklistCount() > 0 then
			for index, value in pairs(DailyGrindSettings.NpcBlacklist) do
				print("     "..index);
			end
		else
			print("     <empty>");
		end
	elseif args[2] ~= nil then
		local action = args[2]:trim():lower();
		local npcName = "";
		if args[3] ~= nil then
			npcName = args[3]:trim():gsub("\"", "");		-- get rid of double-quotes (people may assume they're necessary around the NPC name)
			npcName = npcName:gsub("<", ""):gsub(">", "")	-- and angle brackets, in case people take the documentation too literally...
		end
		if action == "add" then
			self:NpcBlacklist_Add(npcName);
		elseif action == "remove" or action == "rem" then
			self:NpcBlacklist_Remove(npcName);
		elseif action == "clear" then
			DailyGrindSettings.NpcBlacklist = {};
			self:PrintNpcBlacklist(" cleared.");
		elseif action == "help" then
			self:ShowNpcBlacklistHelp();
		end
	else
		self:ShowHelp();
	end
end

function DailyGrind:FindNpcBlacklistIndex(npcName)
	return self:FindIndex(DailyGrindSettings.NpcBlacklist, npcName);
end

function DailyGrind:IsBlacklistedNpc(npcName)
	return self:IsInList(DailyGrindSettings.NpcBlacklist, npcName);
end

function DailyGrind:GetNpcBlacklistCount()
	return self:TableCount(DailyGrindSettings.NpcBlacklist);
end

function DailyGrind:NpcBlacklist_Add(npcName)
	if npcName == "" then
		self:PrintNpcBlacklist(" needs an NPC name to add.");
		return;
	end
	if not self:IsBlacklistedNpc(npcName) then
		DailyGrindSettings.NpcBlacklist[npcName] = self:GetNpcBlacklistCount() + 1;
		self:PrintNpcBlacklist(": \""..npcName.."\" added.");
	else
		self:PrintNpcBlacklist(": \""..self:FindNpcBlacklistIndex(npcName).."\" already exists");
	end
end

function DailyGrind:NpcBlacklist_Remove(npcName)
	if npcName == "" then
		self:PrintNpcBlacklist(" needs an NPC name to remove.");
		return;
	end
	if self:IsBlacklistedNpc(npcName) then
		local index = self:FindNpcBlacklistIndex(npcName);
		DailyGrindSettings.NpcBlacklist[index] = nil;
		self:PrintNpcBlacklist(": \""..index.."\" removed.");
	else
		self:PrintNpcBlacklist(": \""..npcName.."\" not found.");
	end
end

function DailyGrind:NpcBlacklist_ToString()
	local npcblist = "";
	for index = 1, DailyGrind:GetNpcBlacklistCount() do
		local npcName = DailyGrind:FindIndexByValue(DailyGrindSettings.NpcBlacklist, index);
		if npcName ~= nil then
			npcblist = npcblist..npcName.."\n";
		end
	end
	return npcblist;
end

function DailyGrind:NpcBlacklist_Populate(npcNames)
	DailyGrindSettings.NpcBlacklist = {};
	for index, npcName in pairs(npcNames) do
		if npcName ~= "" then
			DailyGrindSettings.NpcBlacklist[npcName] = DailyGrind:GetNpcBlacklistCount() + 1;
		end
	end
	self:PrintNpcBlacklist(" updated.");
end

function DailyGrind:PrintNpcBlacklist(text)
	self:PrintDG(npcBlacklistText..tostring(text));
end

function DailyGrind:ShowNpcBlacklistHelp()
	print("==  "..addonTitle.." - "..npcBlacklistText.."  ==\n");
	print("Usage:");
	print("  Show List: |c"..commandColor.."/dg /npcblacklist (or simply /nbl)");
	print("  Add: |c"..commandColor.."/dg /nbl add <NPC name>");
	print("  Remove: |c"..commandColor.."/dg /nbl rem[ove] <NPC name>");
	print("  Clear: |c"..commandColor.."/dg /nbl clear");
	print(npcBlacklistText.." NPC names are NOT case-sensitive, but all punctuation is required. You may may also use |c"..commandColor.."*|r as a wildcard.\n");
end