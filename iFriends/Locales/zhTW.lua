local AddonName = ...;
local L = LibStub("AceLocale-3.0"):NewLocale(AddonName, "zhTW")

if not L then return end

L["Addon update available!"] = "\230\156\137\229\143\175\231\148\168\231\154\132\230\155\180\230\150\176\239\188\129"
L["Available columns"] = "\229\143\175\231\148\168\231\154\132\230\172\132"
L["Broadcast"] = "\229\187\163\230\146\173"
L["By Class"] = "\230\160\185\230\147\154\231\173\137\231\180\154"
L["By Difficulty"] = "\230\160\185\230\147\154\233\155\163\229\186\166"
L["By Faction"] = "\230\160\185\230\147\154\232\129\178\230\156\155"
L["By Hostility"] = "\230\160\185\230\147\154\230\149\181\229\143\139\229\136\134\229\136\165"
L["By Threshold"] = "\230\160\185\230\147\154\230\149\184\229\128\188"
L["Center"] = "\228\184\173\229\164\174"
L["Column"] = "\230\172\132"
L["Displays the BattleTag of your Battle.net friends."] = "Displays the BattleTag of your Battle.net friends." -- Requires localization
L["Displays the class of your friends. Choose whether to show the class name or the class icon."] = "\233\161\175\231\164\186\229\165\189\229\143\139\231\154\132\232\129\183\230\165\173\239\188\140\229\143\175\228\187\165\233\129\184\230\147\135\233\161\175\231\164\186\232\129\183\230\165\173\229\144\141\231\168\177\230\136\150\229\156\150\231\164\186."
L["Displays the individual note of your friends."] = "\233\161\175\231\164\186\228\189\160\229\165\189\229\143\139\231\154\132\229\128\139\228\186\186\232\168\187\232\168\152."
L["Displays the last broadcast message of your Battle.net friends."] = "\233\161\175\231\164\186\228\189\160\231\154\132\230\136\176\231\182\178\229\165\189\229\143\139\230\156\128\229\190\140\231\154\132\229\187\163\230\146\173\232\168\138\230\129\175."
L["Displays the level of your friends."] = "\233\161\175\231\164\186\228\189\160\229\165\189\229\143\139\231\154\132\231\173\137\231\180\154."
L["Displays the logged on realm of your Battle.net friends."] = "\233\161\175\231\164\186\228\189\160\230\136\176\231\182\178\229\165\189\229\143\139\231\154\132\233\153\163\231\135\159."
L["Displays the name of your friends. In addition, a short info is shown if they are AFK or DND."] = "\233\161\175\231\164\186\228\189\160\229\165\189\229\143\139\231\154\132\229\144\141\231\168\177\227\128\130\230\173\164\229\164\150\239\188\140\229\166\130\230\158\156\228\187\150\229\128\145\230\154\171\233\155\162\230\136\150\229\191\153\231\162\140\228\184\173\233\161\175\231\164\186\231\176\161\231\159\173\231\154\132\232\168\138\230\129\175\227\128\130"
L["Displays the race of your Battle.net friends."] = "\233\161\175\231\164\186\228\189\160\230\136\176\231\182\178\229\165\189\229\143\139\231\154\132\231\168\174\230\151\143."
L["Displays the RealID of your Battle.net friends."] = "\233\161\175\231\164\186\230\136\176\231\182\178\229\165\189\229\143\139\231\154\132\231\156\159\229\175\166ID."
L["Displays the zone of your friends."] = "\233\161\175\231\164\186\228\189\160\229\165\189\229\143\139\231\154\132\229\141\128\229\159\159"
L["Display the number of your Battle.net friends on the plugin"] = "\229\156\168\230\173\164\230\142\155\232\188\137\233\161\175\231\164\186\230\136\176\231\182\178\229\165\189\229\143\139\231\154\132\230\149\184\231\155\174"
L["Display WoW Friends in another Tooltip"] = "\229\156\168\229\143\166\229\164\150\231\154\132\229\183\165\229\133\183\230\143\144\231\164\186\233\161\175\231\164\186\233\173\148\231\141\184\228\184\150\231\149\140\229\165\189\229\143\139"
L["Enable Script"] = "Enable Script" -- Requires localization
L["Game/Realm"] = "\233\129\138\230\136\178/\228\188\186\230\156\141"
L["General Options"] = "\228\184\128\232\136\172\232\168\173\229\174\154"
L["If activated, clicking on the given cell will result in something special."] = "If activated, clicking on the given cell will result in something special." -- Requires localization
L["iFriends provides some pre-layoutet columns for character names, zones, etc. In order to display them in the tooltip, write their names in the desired order into the beneath input."] = "iFriends\230\143\144\228\190\155\230\159\144\228\186\155\233\160\144\232\168\173\231\154\132\230\172\132\231\155\174\229\166\130\232\167\146\232\137\178\229\144\141\231\168\177\227\128\129\229\141\128\229\159\159\227\128\129\231\173\137\231\173\137\227\128\130\231\130\186\228\186\134\233\161\175\231\164\186\233\128\153\228\186\155\232\179\135\232\168\138\229\156\168\229\183\165\229\133\183\230\143\144\231\164\186\228\184\138\239\188\140\232\171\139\229\156\168\228\184\139\230\150\185\232\188\184\229\133\165\230\137\128\233\156\128\231\154\132\233\160\134\229\186\143\227\128\130"
L["Invalid column name!"] = "\231\132\161\230\149\136\231\154\132\230\172\132\229\144\141\231\168\177\239\188\129"
L["Justification"] = "\229\176\141\233\189\138"
L["Left"] = "\229\183\166"
L["Note"] = "\232\168\187\232\168\152"
L["RealID"] = "\231\156\159\229\175\166ID"
L["Right"] = "\229\143\179"
L["Show Label"] = "\233\161\175\231\164\186\230\168\153\231\177\164"
L["Tooltip Options"] = "\229\183\165\229\133\183\230\143\144\231\164\186\232\168\173\229\174\154"
L["Use Icon"] = "\228\189\191\231\148\168\229\156\150\231\164\186"
