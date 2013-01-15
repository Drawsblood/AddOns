-- Author      : Deldinor of Elune
-- Create Date : 10/25/2012 9:58:54 PM

function DailyGrind:ChatCommand(input)
	local args = { strsplit(" ", input:trim(), 3) };
	local command = args[1]:lower();
	 
	if command == "" then
		self:ShowOptions();
	
	elseif command == "import" then
		self:Import();
		
	elseif command == "reset" then
		-- TODO: Implement confirmation.
		self:Reset();
		
  	elseif command == "enable" or command == "on" then
		self:SetEnabled(true);
		print(addonAbbr.." "..self:GetStatus());
		
	elseif command == "disable" or command == "off" then
		self:SetEnabled(false);
		print(addonAbbr.." "..self:GetStatus());
		
	elseif command == "toggle" or command == "tog" then
		self:Toggle();
		print(addonAbbr.." "..self:GetStatus());
		
	elseif command == "all" then
		self:ToggleAutoAcceptAll();
		print(addonAbbr.." "..self:GetAutoAcceptAllStatus());
		
	elseif command == "blacklist" or command == "bl" then
		self:HandleBlacklist(args);
	
	elseif command == "npcblacklist" or command == "nbl" then
		self:HandleNpcBlacklist(args);
		
	elseif command == "rewardlist" or command == "rl" then
		self:HandleRewardList(args);
	
	elseif command == "trim" then
		self:TrimList();

	else
		self:ShowHelp();
		
    end
end

function DailyGrind:Import()
	print(addonAbbr.." Import feature has been deprecated. Use the new Auto-Accept All feature (/dg all).");
end

function DailyGrind:Reset()
	DailyGrindQuests = {};
	print(addonAbbr.." Quest history reset.");
end

function DailyGrind:Toggle()
	self:SetEnabled(not self:GetEnabled());
end

function DailyGrind:SetEnabled(state)
	DailyGrindSettings.Enabled = state;
end

function DailyGrind:GetEnabled()
	return DailyGrindSettings.Enabled;
end

function DailyGrind:ToggleAutoAcceptAll()
	self:SetAutoAcceptAllEnabled(not self:GetAutoAcceptAllEnabled());
end

function DailyGrind:SetAutoAcceptAllEnabled(state)
	DailyGrindSettings.AutoAcceptAllEnabled = state;
end

function DailyGrind:GetAutoAcceptAllEnabled()
	return DailyGrindSettings.AutoAcceptAllEnabled;
end

function DailyGrind:GetStatus()
	if self:GetEnabled() then
		return addonTitle.." - "..enabledText;
	else
		return addonTitle.." - "..disabledText;
	end
end

function DailyGrind:GetAutoAcceptAllStatus()
	local all = "Auto-accept all quests option is ";
	if self:GetAutoAcceptAllEnabled() then
		return all..enabledText;
	else
		return all..disabledText;
	end
end

function DailyGrind:SetSuspendKey(key)
	DailyGrindSettings.SuspendKey = key;
end

function DailyGrind:GetSuspendKey()
	return DailyGrindSettings.SuspendKey;
end

function DailyGrind:ShowHelp()
	print("==]  "..self:GetStatus().."  [==\n");
	print("Dailies that you complete are added to a database. Whenever you see that daily again, you will auto-accept/complete it.");
	print("You may also set "..addonTitle.." to auto-accept ALL daily quests, whether or not you have seen them before, by using |c"..commandColor.."/dg all|r. Dailies that you complete with this option enabled will continue to be added to your database, so turning this option off later will not set you back.");
	print("Usage:  |c"..commandColor.."/dg <enable|on> <disable|off> <tog[gle]> <all> <reset>|r\n");
	print(rewardListText..": Set automatic reward preferences (|c"..commandColor.."/dg rl help|r for more info)");
	print(blacklistText..": Ignore specific quests (|c"..commandColor.."/dg bl help|r for more info)");
	print(npcBlacklistText..": Ignore quests from specific NPCs (|c"..commandColor.."/dg nbl help|r for more info)");
	print("Hold "..self:GetSuspendKey().." while speaking to an NPC to suspend automation.");
end