-- Author      : Deldinor of Elune
-- Create Date : 2/13/2011 9:32:19 AM

function DailyGrind:TableCount(theTable)
	local count = 0;
	for index, value in pairs(theTable) do
		count = count + 1;
	end
	return count;
end

function DailyGrind:FindIndex(theTable, theIndexToFind)
   	for index, value in pairs(theTable) do
		indexLowered = index:gsub("%*", "%.%*"):lower();
		theIndexToFindLowered = theIndexToFind:lower();
   		if indexLowered == theIndexToFindLowered or theIndexToFindLowered:find("^"..indexLowered.."$") then
			return index;
		end
	end
end

function DailyGrind:FindIndexByValue(theTable, theValueToFind)
   	for index, value in pairs(theTable) do
		if value == theValueToFind then
			return index;
		end
	end
end

function DailyGrind:IsInList(theTable, theIndexToFind)
	return self:FindIndex(theTable, theIndexToFind) ~= nil;
end

-- Remove quest levels added by some addons
function DailyGrind:SanitizeQuestTitle(questTitle)
	return questTitle:gsub("%[%-?%d+%] (.+)", "%1", 1);
end