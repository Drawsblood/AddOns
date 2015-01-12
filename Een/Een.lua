local Een = CreateFrame("FRAME"); -- Need a frame to respond to events
Een:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded
Een:RegisterEvent("PLAYER_LOGIN"); -- Fired when logging in
Een:RegisterEvent("UPDATE_CHAT_WINDOWS"); -- Fired when updating the chat windows
Een:RegisterEvent("UPDATE_CHAT_COLOR"); -- Fired when the colour for a chat channel is changed
Een_AutoLoad = true;
Een_Msg = true;
Een_ToonChatFrame = { };
Een_ToonSettings = false;
Een_tmpChannelColours = { };

function Een_Save_Chat()
	for i=1,10 do
		local f = _G["ChatFrame"..i];
		local point, relativeTo, relativePoint, xOfs, yOfs = f:GetPoint();
		local name, fontSize, r, g, b, alpha, shown, locked, docked, uninteractable = GetChatWindowInfo(i);
		local DefaultMessages = { GetChatWindowMessages(f:GetID())};
		local DefaultChannels = { GetChatWindowChannels(f:GetID())};
		Een_ChatFrame[i] = {f:GetWidth(), f:GetHeight(), point, relativePoint, xOfs, yOfs, name, fontSize, r, g, b, alpha, shown, locked, docked, uninteractable, DefaultMessages, DefaultChannels};
		Een_ToonChatFrame[i] = Een_ChatFrame[i];
	end
	Een_ChannelColours = Een_tmpChannelColours;
end

function Een_Assimilate_Chat(args)
	for i=1,10 do
		local f = _G["ChatFrame"..i];
		local tmp_ChatFrame = args[i];
		if not Een_ToonSettings then Een_ToonChatFrame[i] = args[i] end;
		
-- Remove old chat message cfg and replace with new one		
		local tmp_OldChatMsgType = { GetChatWindowMessages(f:GetID())};
		for k=1,#tmp_OldChatMsgType do
			RemoveChatWindowMessages(i, tmp_OldChatMsgType[k]);
		end
		local tmp_ChatMsgType = tmp_ChatFrame[17];
		for j=1,#tmp_ChatFrame[17] do
			AddChatWindowMessages(i, tmp_ChatMsgType[j]);
		end
		
-- Remove old chat channel cfg and replace with new one	
		if tmp_ChatFrame[18] then
			local tmp_OldChatChannelType = { GetChatWindowChannels(f:GetID())};
			for k=1,#tmp_OldChatChannelType do
				RemoveChatWindowChannel(i, tmp_OldChatChannelType[k]);
			end
			local tmp_ChatChannelType = tmp_ChatFrame[18];
			for j=1,#tmp_ChatFrame[18] do
				AddChatWindowChannel(i, tmp_ChatChannelType[j]);
			end
		end
		
		SetChatWindowName(i,tmp_ChatFrame[7]);
		SetChatWindowSize(i,tmp_ChatFrame[8]);
		SetChatWindowColor(i,tmp_ChatFrame[9],tmp_ChatFrame[10],tmp_ChatFrame[11]);
		SetChatWindowAlpha(i,tmp_ChatFrame[12]);
		SetChatWindowShown(i,tmp_ChatFrame[13]);
		SetChatWindowLocked(i,tmp_ChatFrame[14]);
		SetChatWindowDocked(i,tmp_ChatFrame[15]);
		SetChatWindowUninteractable(i,tmp_ChatFrame[16]);
		if f:IsMovable() then
			f:ClearAllPoints();
			f:SetWidth(tmp_ChatFrame[1]);
			f:SetHeight(tmp_ChatFrame[2]);
			f:SetPoint(tmp_ChatFrame[3], UIParent, tmp_ChatFrame[4], tmp_ChatFrame[5], tmp_ChatFrame[6]);
			f:SetUserPlaced(true);
		end
	end
	for i,line in pairs(Een_ChannelColours) do
		ChangeChatColor(line[1], line[2], line[3], line[4]);
	end
	if not Een_Msg then message("Chat windows have been set\nplease enter /reload to ensure changes take effect.") end;
end

function Een:OnEvent(event, arg1, arg2, arg3, arg4)
	if event == "ADDON_LOADED" and arg1 == "Een" then
		if Een_ChatFrame == nil then
			Een_ChatFrame = { };
			printInstructions();
		elseif Een_ChatFrame[1] ~= nil then
			print("Een's addon loaded.");
		else
			printInstructions();
		end
		if Een_ChannelColours == nil then
			Een_ChannelColours = { } ;
		end
	elseif event == "PLAYER_LOGIN" or event == "UPDATE_CHAT_WINDOWS" then
		if Een_ToonChatFrame[1] ~= nil then
			Een_ToonSettings = true;
			Een_Assimilate_Chat(Een_ToonChatFrame);
		elseif Een_ChatFrame[1] ~= nil and Een_AutoLoad then
			Een_Assimilate_Chat(Een_ChatFrame);
		end
	elseif event == "UPDATE_CHAT_COLOR" then
		local channelColours = { };
		channelColours[1] = arg1;
		channelColours[2] = arg2;
		channelColours[3] = arg3;
		channelColours[4] = arg4;
		Een_tmpChannelColours[arg1] = channelColours;
	end
end

function printInstructions()
	print("Welcome to Een's Chat Window backup");
	print("Usage:");
	print("/een save - Save the current character's chat windows");
	print("/een load - Load the backup");
	print("/een autoload - toggles the auto-magic loading of the settings for new characters(default is on)");
	print("/een msg - togles the msg box telling you to reloadui(default shows the message)");
end

Een:SetScript("OnEvent", Een.OnEvent);

SLASH_EEN1 = "/een";
SlashCmdList["EEN"] = function(msg)
	if msg == 'save' then
		Een_Save_Chat();
	elseif msg == 'load' and Een_ChatFrame[1] ~= nil then
		Een_Assimilate_Chat(Een_ChatFrame);
	elseif msg == 'autoload' then
		Een_AutoLoad = not Een_AutoLoad;
		local tmpBoolStr = "now";
		if not Een_AutoLoad then tmpBoolStr = "not" end;
		print("Een's Chat Window backup", tmpBoolStr, "set to autoload.");
	elseif msg == 'msg' then
		Een_Msg = not Een_Msg;
		local tmpBoolStr = "now";
		if not Een_Msg then tmpBoolStr = "not" end;
		print("Een's Chat Window backup is set to", tmpBoolStr, "show the message.");
	else
		printInstructions();
	end
end