local AddonName = ...;
local L = LibStub("AceLocale-3.0"):NewLocale(AddonName, "koKR")

if not L then return end

L["Addon update available!"] = "\236\149\160\235\147\156\236\152\168 \236\151\133\235\141\176\236\157\180\237\138\184\235\165\188 \236\130\172\236\154\169\237\149\160 \236\136\152 \236\158\136\236\138\181\235\139\136\235\139\164."
L["Available columns"] = "\236\130\172\236\154\169 \234\176\128\235\138\165 \236\151\180"
L["By Achievement Points"] = "\236\151\133\236\160\129 \236\160\144\236\136\152"
L["By Class"] = "\236\167\129\236\151\133\236\136\156"
L["By Difficulty"] = "\235\130\156\236\156\132\235\143\132\236\136\156"
L["By Guildrank"] = "\234\184\184\235\147\156 \235\147\177\234\184\137\236\136\156"
L["By Level"] = "\235\160\136\235\178\168\236\136\156"
L["By Name"] = "\236\157\180\235\166\132\236\136\156"
L["By Threshold"] = "\234\176\146"
L["By Zone"] = "\236\167\128\236\151\173\236\136\156"
L["Center"] = "\234\176\128\236\154\180\235\141\176" -- Needs review
L["change"] = "\235\179\128\234\178\189"
L["Displays both public and officer notes of your guild mates in a single column."] = "\234\184\184\235\147\156\236\155\144\236\157\152 \236\170\189\236\167\128\236\153\128 \234\180\128\235\166\172\236\158\144 \236\170\189\236\167\128 \235\145\152\236\157\132 \237\149\152\235\130\152\236\157\152 \236\151\180\236\151\144 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Displays the achievement points of your guild mates."] = "\234\184\184\235\147\156\236\155\144\236\157\152 \236\151\133\236\160\129 \236\160\144\236\136\152\235\165\188 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Displays the class of your guild mates. Choose whether to show the class name or the class icon."] = "\234\184\184\235\147\156\236\155\144\236\157\152 \236\167\129\236\151\133\236\157\132 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164. \236\167\129\236\151\133 \236\157\180\235\166\132\236\157\180\235\130\152 \236\167\129\236\151\133 \236\149\132\236\157\180\236\189\152\236\157\132 \237\145\156\236\139\156\237\149\160 \236\167\128 \236\132\160\237\131\157\237\149\169\235\139\136\235\139\164."
L["Displays the following green icon when you are grouped with guild mates:"] = "\234\184\184\235\147\156\236\155\144\234\179\188 \237\140\140\237\139\176\236\139\156 \235\133\185\236\131\137 \236\149\132\236\157\180\236\189\152\236\156\188\235\161\156 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164:"
L["Displays the guild exp contributed by your guild mates. The displayed number is divided by 1000."] = "\234\184\184\235\147\156\236\155\144\236\157\180 \236\160\156\234\179\181\237\149\156 \234\184\184\235\147\156 \234\178\189\237\151\152\236\185\152\235\165\188 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164. \237\145\156\236\139\156 \236\136\171\236\158\144\235\138\148 1,000\236\156\188\235\161\156 \235\130\152\235\136\136 \234\176\146\236\158\133\235\139\136\235\139\164."
L["Displays the guild rank of your guild mates."] = "\234\184\184\235\147\156\236\155\144\236\157\152 \234\184\184\235\147\156 \235\147\177\234\184\137\236\157\132 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Displays the level of your guild mates."] = "\234\184\184\235\147\156\236\155\144\236\157\152 \235\160\136\235\178\168\236\157\132 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Displays the name of your guild mates. In addition, a short info is shown if they are AFK or DND."] = "\234\184\184\235\147\156\236\155\144 \236\157\180\235\166\132\236\157\132 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Displays the officer note of your guild mates, if you can see it. The whole column is not shown otherwise."] = "\235\139\185\236\139\160\236\157\180 \235\179\188\236\136\152 \236\158\136\235\139\164\235\169\180 \234\184\184\235\147\156\236\155\144\236\157\152 \234\180\128\235\166\172\236\158\144 \236\170\189\236\167\128\235\165\188 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Displays the public note of your guild mates."] = "\234\184\184\235\147\156\236\155\144\236\157\152 \236\170\189\236\167\128\235\165\188 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Displays the tradeskills of your guild mates as little icons. Be sure to activate the red option if you want to use it."] = "\236\158\145\236\157\128 \236\149\132\236\157\180\236\189\152\236\156\188\235\161\156 \234\184\184\235\147\156\236\155\144\236\157\152 \236\160\132\235\172\184 \234\184\176\236\136\160\236\157\132 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164. \235\139\185\236\139\160\236\157\180 \234\183\184\234\178\131\236\157\132 \236\130\172\236\154\169\237\149\152\235\160\164\235\169\180 \235\185\168\234\176\132\236\131\137 \236\152\181\236\133\152\236\157\132 \237\153\156\236\132\177\237\153\148\237\149\152\236\151\172\236\149\188 \237\149\169\235\139\136\235\139\164."
L["Displays the zone of your guild mates."] = "\234\184\184\235\147\156\236\155\144\236\157\152 \236\167\128\236\151\173\236\157\132 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Enable Script"] = "\236\138\164\237\129\172\235\166\189\237\138\184 \236\130\172\236\154\169"
L["Enable Tradeskills"] = "\236\160\132\235\172\184 \234\184\176\236\136\160 \236\130\172\236\154\169"
L["If activated, clicking on the given cell will result in something special."] = "If activated, clicking on the given cell will result in something special." -- Requires localization
L["iGuild provides some pre-layoutet columns for character names, zones, etc. In order to display them in the tooltip, write their names in the desired order into the beneath input."] = "iGuild\235\138\148 \236\186\144\235\166\173\237\132\176\236\157\152 \236\157\180\235\166\132, \236\167\128\236\151\173, \234\184\176\237\131\128\235\147\177 \235\176\176\236\185\152 \236\151\180\236\157\132 \236\160\156\234\179\181\237\149\169\235\139\136\235\139\164. \237\136\180\237\140\129\236\151\144 \237\145\156\236\139\156\237\149\152\234\184\176 \236\156\132\237\149\180 \236\149\132\235\158\152 \236\158\133\235\160\165\236\164\132\236\151\144 \236\155\144\237\149\152\235\138\148 \236\136\156\236\132\156\236\157\152 \236\157\180\235\166\132\236\157\132 \236\160\129\236\138\181\235\139\136\235\139\164."
L["Invalid column name!"] = "\236\158\152\235\170\187\235\144\156 \236\151\180 \236\157\180\235\166\132!"
L["Justification"] = "\237\143\137\237\140\144"
L["Left"] = "\236\153\188\236\170\189" -- Needs review
L["No guild"] = "\234\184\184\235\147\156 \236\151\134\236\157\140" -- Needs review
L["Note"] = "\236\170\189\236\167\128" -- Needs review
L["OfficerNote"] = "\234\184\184\235\147\156\234\180\128\235\166\172\236\158\144 \236\170\189\236\167\128"
L["Plugin Options"] = "\237\148\140\235\159\172\234\183\184\236\157\184 \236\152\181\236\133\152"
L["Points"] = "\236\160\144\236\136\152"
L["Querying tradeskills needs extra memory. This is why you explicitly have to enable that. Don't forget to reload your UI!"] = "\236\160\132\235\172\184 \234\184\176\236\136\160\236\151\144\235\138\148 \236\182\148\234\176\128 \235\169\148\235\170\168\235\166\172\234\176\128 \237\149\132\236\154\148\237\149\169\235\139\136\235\139\164. UI \236\158\172\236\139\156\236\158\145\236\157\180 \237\149\132\236\154\148\237\149\169\235\139\136\235\139\164."
L["Right"] = "\236\152\164\235\165\184\236\170\189" -- Needs review
L["Show Guild Level"] = "\234\184\184\235\147\156 \235\160\136\235\178\168 \235\179\180\234\184\176"
L["Show Guild Name"] = "\234\184\184\235\147\156 \236\157\180\235\166\132 \235\179\180\234\184\176"
L["Show Guild XP"] = "\234\184\184\235\147\156 \234\178\189\237\151\152\236\185\152 \235\179\180\234\184\176"
L["Show Label"] = "\236\160\156\235\170\169 \235\179\180\234\184\176"
L["Show Progress"] = "\236\167\132\236\178\153\235\143\132 \235\179\180\234\184\176"
L["Sorting"] = "\236\160\149\235\160\172" -- Needs review
L["Tooltip Options"] = "\237\136\180\237\140\129 \236\152\181\236\133\152"
L["Tradeskills"] = "\236\160\132\235\172\184 \234\184\176\236\136\160"
L["Use Icon"] = "\236\149\132\236\157\180\236\189\152 \236\130\172\236\154\169" -- Needs review
