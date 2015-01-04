local _, AskMrRobot = ...
AskMrRobot.L = {};
local L = AskMrRobot.L;

function AskMrRobot.format(fmt, ...)
    local args, order = {...}, {}

    local f = fmt:gsub('%%(%d+)%$', function(i)
        tinsert(order, args[tonumber(i)])
        return '%'
    end)

    return f:format(unpack(order))
end

-- stat strings for e.g. displaying gem/enchant abbreviations
L.AMR_STAT_SHORT_STRINGS = {
    ["Strength"] = "Str",
    ["Agility"] = "Agi",
    ["Intellect"] = "Int",
    ["CriticalStrike"] = "Crit",
    ["Haste"] = "Haste",
    ["Mastery"] = "Mastery",
    ["Multistrike"] = "Multi",
    ["Versatility"] = "Vers",
    ["BonusArmor"] = "Armor",
    ["Spirit"] = "Spirit",
    ["Dodge"] = "Dodge",
    ["Parry"] = "Parry",
    ["MovementSpeed"] = "Speed",
    ["Avoidance"] = "Avoid",
    ["Stamina"] = "Stam",
    ["Armor"] = "Armor",
    ["AttackPower"] = "AP",
    ["SpellPower"] = "SP",
    ["PvpResilience"] = "PvP Res",
    ["PvpPower"] = "PvP Pow",
}

-- AskMrRobot.lua
L.AMR_IMPORT_ERROR_EMPTY = "The data string is empty."
L.AMR_IMPORT_ERROR_FORMAT = "The data string is not in the correct format."
L.AMR_IMPORT_ERROR_VERSION = "The data string is from an old version of the addon.  Please go to the website and generate a new one."
L.AMR_IMPORT_ERROR_CHAR = "The data string is for %s, but you are %s!"
L.AMR_IMPORT_ERROR_RACE = "It looks your race may have changed.  Please go the website and re-optimize."
L.AMR_IMPORT_ERROR_FACTION = "It looks your faction may have changed.  Please go the website and re-optimize."
L.AMR_IMPORT_ERROR_LEVEL = "It looks your level may have changed.  Please go the website and re-optimize."
L.AMR_IMPORT_ERROR_SPEC = "Please change your spec to %s to view this optimization."
L.AMR_IMPORT_ERROR_TALENT = "It looks like your talents may have changed.  Please go the website and re-optimize."
L.AMR_IMPORT_ERROR_GLYPH = "It looks like your glyphs may have changed.  Please go the website and re-optimize."
--SlashCmdList.AMR
L.AMR_SLASH_COMMAND_TEXT_1 = 'Available AskMrRobot slash commands:\n'
L.AMR_SLASH_COMMAND_TEXT_2 = '  /amr show   -- show the main window\n'
L.AMR_SLASH_COMMAND_TEXT_3 = '  /amr hide   -- hide the main window\n'
L.AMR_SLASH_COMMAND_TEXT_4 = '  /amr toggle -- toggle the main window\n'
L.AMR_SLASH_COMMAND_TEXT_5 = '  /amr wipe   -- logs a raid wipe.  Used to ignore events in the fight after this point\n'
L.AMR_SLASH_COMMAND_TEXT_6 = '  /amr unwipe -- undo the last wipe command\n'
L.AMR_SLASH_COMMAND_TEXT_7 = '  /amr export -- export character, bag, and bank data (opens the export copy/paste window)'

--AskMrRobotUi.lua

--createMainMenu
L.AMR_UI_MENU_EXPORT = "Export"
L.AMR_UI_MENU_GEAR = "Load a Gear Set"
L.AMR_UI_MENU_SETTINGS = "Settings"
L.AMR_UI_MENU_COMBAT_LOG = "Combat Log"
L.AMR_UI_MENU_HELP = "Help"

L.AMR_UI_BUTTON_IMPORT = "Load"
L.AMR_UI_BUTTON_SUMMARY = "Summary"
L.AMR_UI_BUTTON_GEMS = "Gems"
L.AMR_UI_BUTTON_ENCHANTS = "Enchants"
L.AMR_UI_BUTTON_SHOPPING_LIST = "Shopping List"

--AskMrRobot.lua
L.AMR_ON_EVENT_TOOLTIP = "Left Click to open the Ask Mr. Robot window.\n\nShift + Left Click to export your bag and bank data.\n\nCtrl + Left Click to mark a fight as a wipe."

--config.lua
--frame:SetScript
L.AMR_CONFIG_EXIMPORT = "Mr. Robot's addon can export your item information to his website, and import your optimizations into the game."
L.AMR_CONFIG_CHECKBOX_MINIMAP_LABEL = "Show minimap icon"
L.AMR_CONFIG_CHECKBOX_MINIMAP_TOOLTIP_TITLE = "Minimap Icon"
L.AMR_CONFIG_CHECKBOX_MINIMAP_DESCRIPTION =  "Show the Ask Mr. Robot minimap icon."
L.AMR_CONFIG_CHECKBOX_AUTOAH_LABEL = "Automatically show Mr. Robot's shopping list at the auction house"
L.AMR_CONFIG_CHECKBOX_AUTOAH_TOOLTIP_TITLE = "Auto-Show Shopping List"
L.AMR_CONFIG_CHECKBOX_AUTOAH_DESCRIPTION = "When your shopping list still has things left to buy, automatically show Mr. Robot's shopping list when you visit the auction house."

--wait.lua
--wait
L.AMR_WAIT_BAD_ARGUMENTS = "Bad Arguments to amr__wait"

--dir ui
--ui/CombatLogTab.lua
L.AMR_SETTINGSTAB_SETTINGS = "Settings"
L.AMR_COMBATLOGTAB_COMBAT_LOGGING = "Combat Logging"
L.AMR_COMBATLOGTAB_START_LOGGING = "Start Logging"
L.AMR_COMBATLOGTAB_CURRENTLY_LOGGING = "|c0000ff00Currently Logging|r"
L.AMR_COMBATLOGTAB_STOP_LOGGING = "Stop Logging"
L.AMR_COMBATLOGTAB_CHECKBOX_AUTOLOG_HM_LABEL = "Always log Highmaul"
L.AMR_COMBATLOGTAB_CHECKBOX_AUTOLOG_HM_TOOLTIP_TITLE = "Auto-Log Highmaul"
L.AMR_COMBATLOGTAB_CHECKBOX_AUTOLOG_HM_DESCRIPTION =  "Automatically start logging when you enter Highmaul and stop when you leave Highmaul.\n\nNote that you should disable similar features in other addons to avoid conflicts."
L.AMR_COMBATLOGTAB_CHECKBOX_AUTOLOG_BRF_LABEL = "Always log Blackrock Foundry"
L.AMR_COMBATLOGTAB_CHECKBOX_AUTOLOG_BRF_TOOLTIP_TITLE = "Auto-Log Blackrock Foundry"
L.AMR_COMBATLOGTAB_CHECKBOX_AUTOLOG_BRF_DESCRIPTION =  "Automatically start logging when you enter Blackrock Foundry and stop when you leave Blackrock Foundry.\n\nNote that you should disable similar features in other addons to avoid conflicts."
L.AMR_COMBATLOGTAB_HEADLINE_OVER_BUTTON = "Save Characters"
L.AMR_COMBATLOGTAB_SAVE_CHARACTER = "Save Character Data"
L.AMR_COMBATLOGTAB_INSTRUCTIONS = "INSTRUCTIONS"
L.AMR_COMBATLOGTAB_INSTRUCTIONS_1 = "1. Use the Start/Stop buttons or check 'Always log Siege of Orgrimmar'."
L.AMR_COMBATLOGTAB_INSTRUCTIONS_2 = "2. When you are ready to upload, press 'Save Character Data'. *"
L.AMR_COMBATLOGTAB_INSTRUCTIONS_3 = "3. Exit World of Warcraft. **"
L.AMR_COMBATLOGTAB_INSTRUCTIONS_4 = "4. Launch the Ask Mr. Robot client and follow the instructions. ***"
L.AMR_COMBATLOGTAB_INSTRUCTIONS_5 = "|c00999999* This will reload your UI to ensure that all collected data is saved to disk.  This step is not necessary if you log out of the game before uploading.|r"
L.AMR_COMBATLOGTAB_INSTRUCTIONS_6 = "|c00999999** Exiting WoW before uploading your combat log is optional, but highly recommended.  This prevents your log file from getting ridiculously large and slowing down your uploads.|r"
L.AMR_COMBATLOGTAB_INSTRUCTIONS_7 = "|c00999999*** You can download the client program at|r |c003333ffhttp://www.askmrrobot.com/wow/combatlog/upload|r|c00999999.|r"
L.AMR_COMBATLOGTAB_IS_LOGGING = "You are now logging combat, and Mr. Robot is logging character data for your raid."
L.AMR_COMBATLOGTAB_STOPPED_LOGGING = "Combat logging has been stopped."
L.AMR_COMBATLOGTAB_INFIGHT = "In-Fight Options"
L.AMR_COMBATLOGTAB_WIPE_1 = "|c00aaaaaaDeclare a wipe |r|c00ffffffbefore|r|c00aaaaaa you die on purpose.|r"
L.AMR_COMBATLOGTAB_WIPE_2 = "|c00aaaaaaThis will ignore intentional deaths & damage.|r"
L.AMR_COMBATLOGTAB_WIPE_3 = "|c00999999This feature must be used by the person logging combat.|r"
L.AMR_COMBATLOGTAB_SAVE_CHARACTER_INFO = "While you are logging combat, character & gear data is collected for everyone in the raid who has this mod installed.  At the end of the raid, the person logging needs to click the button to save the data so it can be uploaded."
L.AMR_COMBATLOGTAB_LASTWIPE = '|c00ff0000Last wipe called on %s at %s.|r'
L.AMR_COMBATLOGTAB_WIPE_CHAT = "It's a wipe, everybody die!"
L.AMR_COMBATLOGTAB_WIPE_MSG = "[AskMrRobot] Manual wipe called at %s"
L.AMR_COMBATLOGTAB_NOWIPES = '[AskMrRobot] There is no recent manual wipe to remove'
L.AMR_COMBATLOGTAB_UNWIPE_MSG = "[AskMrRobot] Manual wipe at %s was removed"
--ui/EnchantTab.lua
L.AMR_ENCHANTTAB_ENCHANTS = "Enchants"
L.AMR_ENCHANTTAB_100_OPTIMAL = "Your enchants are 100% optimal!"
L.AMR_ENCHANTTAB_SLOT = "Slot"
L.AMR_ENCHANTTAB_CURRENT = "Current"
L.AMR_ENCHANTTAB_OPTIMIZED = "Optimized"
L.AMR_ENCHANTTAB_TESTSLOT = "TestSlot"
--ui/ExportTab.lua
L.AMR_EXPORTTAB_EXPORT_TITLE = "Export your character to AskMrRobot.com"
L.AMR_EXPORTTAB_COPY_PASTE_EXPORT_1 = "1. Open your bank"
L.AMR_EXPORTTAB_COPY_PASTE_EXPORT_2 = "2. Copy the text below by pressing Ctrl+C (or Cmd+C on a Mac)"
L.AMR_EXPORTTAB_COPY_PASTE_EXPORT_3 = "3. Go to |c00ffd100AskMrRobot.com|r and click the green '|c0000ff00Import from Addon|r' button found just above your character name.  Paste the text into the window that pops up."
L.AMR_EXPORTTAB_COPY_PASTE_EXPORT_NOTE = "NOTE: If you change something while this window is open, press the Update button below to generate a new export string."
L.AMR_EXPORTTAB_UPDATE = "Update"

--ui/GemTab.lua
--popup autogem finished
L.AMR_GEMTAB_FINISHED = "Mr. Robot finished auto-gemming. \rIf some items aren't gemmed, you may need to acquire more gems. \rIf your belt isn't gemmed, you may still need to buy a belt buckle."
L.AMR_GEMTAB_BUTTON_OK = "Ok"
--popup autogem once
L.AMR_GEMTAB_AUTOGEMMING_IN_PROGRESS = "Autogemming already in progress."
--constructor
L.AMR_GEMTAB_GEMS = "Gems"
L.AMR_GEMTAB_OPTIMAL = "Your gems are 100% optimal! You are truly, truly outrageous."
L.AMR_GEMTAB_X_OPTIMIZE = "You have X gems to optimize"
L.AMR_GEMTAB_AUTOGEM_BUTTON = "Auto Gem! (BETA)"
L.AMR_GEMTAB_PREFER_PERFECT = "Prefer Perfect"
L.AMR_GEMTAB_SLOT = "Slot"
L.AMR_GEMTAB_CURRENT = "Current"
L.AMR_GEMTAB_OPTIMIZED = "Optimized"
--Update
L.AMR_GEMTAB_TO_OPTIMIZE = "You have %d \1244gem:gems; to optimize"
--ui/HelpTab.lua
L.AMR_HELPTAB_TITLE = "Help"
L.AMR_HELPTAB_LINK = "Visit |c003333ffhttp://blog.askmrrobot.com/addon/|r  for a full tutorial and to ask questions.\r"
L.AMR_HELPTAB_Q1 = "|c00999999Q:|r The armory won’t update my character on your website. Is there a workaround?"
L.AMR_HELPTAB_A1 = "|c0066dd66A:|r Yes. Go to the |c00ffd100Export|r section of this addon. Copy the text in the box.  Then go to our |c00ffd100website|r, load your character, and click the green '|c0000ff00Import (from addon)|r' button, found just above your character name.  Paste the text there. That process takes a snapshot of your current in-game character and imports it to the website!"
L.AMR_HELPTAB_Q2 = "|c00999999Q:|r Do I have to get a new text-string every time I need to optimize?"
L.AMR_HELPTAB_A2 = "|c0066dd66A:|r Yes. Go to the |c00ffd100website|r and click the green '|c0000ff00Update from Armory|r' button found just above your character name, to make sure you have updated gear. Optimize your gear and then click the blue '|c0018C0F7Export to Addon|r' button found to the right of your gear, in the purple '|c00BF28D6Now What?|r section.  Return to this |c00ffd100addon|r, go to the '|c00ffd100Load a Gear Set|r' tab and paste the text in the box."
L.AMR_HELPTAB_Q3 = "|c00999999Q:|r Can I send my shopping list to an alt?"
L.AMR_HELPTAB_A3 = '|c0066dd66A:|r Yes, go to the shopping list tab and select the "mail" option in the drop down. You can mail the list to your alt.'
L.AMR_HELPTAB_Q4 = "|c00999999Q:|r I am in the middle of a raid and just won a piece of loot. Can I optimize really quickly?"
L.AMR_HELPTAB_A4 = "|c0066dd66A:|r Yes! You'll want to read the tutorial on that here: \r|c003333ffhttp://blog.askmrrobot.com/addon#raid"
L.AMR_HELPTAB_Q5 = "|c00999999Q:|r Where is auto gemming?"
L.AMR_HELPTAB_A5 = "|c0066dd66A:|r We have temporarily removed it.  We plan to bring it back for WoD"
L.AMR_HELPTAB_Q6 = "|c00999999Q:|r Is Mr. Robot updated?"
L.AMR_HELPTAB_A6 = "|c0066dd66A:|r Yes! For more info, go to \r|c003333ffhttp://blog.askmrrobot.com/2014/10/what-to-do-for-6-0-2/"
--ui/ImportTab.lua
--new
L.AMR_IMPORTTAB_BUTTON = "Load Gear"
L.AMR_IMPORTTAB_TITLE = "Load a gear set from the website"
L.AMR_IMPORTTAB_INSTRUCTIONS_1 = "1. Click the blue '|c0018C0F7Send to Addon|r' button on our |c00BF28D6website|r.  It's found on the right side in the '|c33ffffffNow What?|r' section.  Copy the text in the box that pops up.|n|c00999999To copy, press ctrl + c (or cmd + c on a mac)|r"
L.AMR_IMPORTTAB_INSTRUCTIONS_2 = "2. Then return to this window in the |c00ffd100addon|r.  Paste the text in the box below, then click the 'Load Gear' button.|n|c00999999To paste, press ctrl + v in the window (or cmd + v on a mac)|r"

--ui/ShoppingListTab
--popup mail
L.AMR_SHOPPINGLISTTAB_OPEN_MAIL = "You need to open the mail window for this to work"
L.AMR_SHOPPINGLISTTAB_BUTTON_OK = "Ok"
--new
L.AMR_SHOPPINGLISTTAB_TITLE = "Shopping List"
L.AMR_SHOPPINGLISTTAB_BUTTON_SEND = "send it!"
L.AMR_SHOPPINGLISTTAB_ENCHANT_MATERIALS = "Enchant Materials"
L.AMR_SHOPPINGLISTTAB_ENCHANTS = "Enchants"
L.AMR_SHOPPINGLISTTAB_GEMS = "Gems"
L.AMR_SHOPPINGLISTTAB_INCLUDE = "Include:"
L.AMR_SHOPPINGLISTTAB_SEND_LIST_TO = "Send list to"
L.AMR_SHOPPINGLISTTAB_WHISPER_CHANNEL = "Whisper to a friend or send to a channel, like /raid or /guild."
L.AMR_SHOPPINGLISTTAB_SEND_JEWELCRAFT_ENCHANTER = "Send to a Jewelcraft or Enchanter friend :)"
L.AMR_SHOPPINGLISTTAB_TOTAL = "Total"
L.AMR_SHOPPINGLISTTAB_DONE = "YOUR SHOPPING IS ALL DONE!"
L.AMR_SHOPPINGLISTTAB_A_ROBOTS_WISHLIST = "Unless you want to buy me a birthday present! I like titanium bolts and robot dogs... Or was it titanium dogs and robot bolts..."
L.AMR_SHOPPINGLISTTAB_DROPDOWN_FRIEND = "a friend"
L.AMR_SHOPPINGLISTTAB_DROPDOWN_PARTY = "party"
L.AMR_SHOPPINGLISTTAB_DROPDOWN_RAID = "raid"
L.AMR_SHOPPINGLISTTAB_DROPDOWN_GUILD = "guild"
L.AMR_SHOPPINGLISTTAB_DROPDOWN_CHANNEL = "channel"
L.AMR_SHOPPINGLISTTAB_DROPDOWN_MAIL = "mail"
L.AMR_SHOPPINGLISTTAB_MAIL_ROBOT_MESSAGE = "Mr. Robot says I need the following to optimize my gear:\n"
L.AMR_SHOPPINGLISTTAB_MAIL_SUBJECT_GE = 'Request for gems and enchants'
L.AMR_SHOPPINGLISTTAB_MAIL_SUBJECT_G = 'Request for gems'
L.AMR_SHOPPINGLISTTAB_MAIL_SUBJECT_E = 'Request for enchants'
L.AMR_SHOPPINGLISTTAB_CHAT_ROBOT_MESSAGE = "Mr. Robot says I need"
--ui/SummaryTab.lua
L.AMR_SUMMARYTAB_TITLE = "Summary"
L.AMR_SUMMARYTAB_NO_IMPORT = "You have no optimizations imported."
L.AMR_SUMMARYTAB_GET_STARTED = 'Click the |c00ffd100Load|r tab to get started.'
L.AMR_SUMMARYTAB_GO_UPGRADE = "Please upgrade the following items:"
L.AMR_SUMMARYTAB_SLOT = "Slot"
L.AMR_SUMMARYTAB_ITEM_NAME = "Item Name"
L.AMR_SUMMARYTAB_OPTIMAL = "Congratulations! You are 100% optimal"
L.AMR_SUMMARYTAB_LAST_IMPORT = "Last import: ?\rThese optimizations are for ?"
L.AMR_SUMMARYTAB_OPTIMIZATIONS_TO_GO = "You have ? optimizations to make:"
L.AMR_SUMMARYTAB_GEMS_TO_GO = "? gems"
L.AMR_SUMMARYTAB_ENCHANTS_TO_GO = "? enchants"
L.AMR_SUMMARYTAB_VIEW_TABS = "View the Gem and Enchant tabs for suggested optimizations."
L.AMR_SUMMARYTAB_GEMCOUNT = "%d \1244gem:gems;"
L.AMR_SUMMARYTAB_ENCHANTCOUNT = "%d \1244enchant:enchants;"
L.AMR_SUMMARYTAB_OPTIMIZATIONCOUNT = "You have %d \1244optimization:optimizations; to make:"
L.AMR_SUMMARYTAB_LAST_IMPORT_1 = "Last import: %s\rThese optimizations are for %s"
L.AMR_SUMMARYTAB_LAST_IMPORT_2 = "Last import: %s\rThese optimizations are for %s's..."
L.AMR_SUMMARYTAB_LAST_IMPORT_PSPEC = "Primary Spec - %s"
L.AMR_SUMMARYTAB_LAST_IMPORT_SSPEC = "Secondary Spec - %s"
L.AMR_SUMMARYTAB_DIFF_REALM = "a different realm: %s"
L.AMR_SUMMARYTAB_DIFF_TALENT = "different talents"
L.AMR_SUMMARYTAB_DIFF_GLYPHS = "different glyphs"
L.AMR_SUMMARYTAB_DIFF_GEAR = "Mr. Robot optimized a different set of gear"
L.AMR_SUMMARYTAB_DIFF_AND = "and"
L.AMR_SUMMARYTAB_DIFF_PLEASE_EQ = ". Please equip the following items before proceeding with the optimizations."
L.AMR_SUMMARYTAB_DIFF_CHECK_CHAR = "WARNING: Please check your character before proceeding:"
L.AMR_SUMMARYTAB_DIFF_OPTIMIZED_FOR = "Mr. Robot optimized for "
--showImportError
L.AMR_SUMMARYTAB_IMPORT_NOT_WORK = 'Error! Your import did not work:|n|n%s'
--ui/RobotStamp.lua
L.AMR_ROBOTSTAMP_TEXT = "ROBOT STAMP OF APPROVAL"
L.AMR_ROBOTSTAMP_GEMS = "Your gems are 100% optimal! You are truly, truly outrageous."