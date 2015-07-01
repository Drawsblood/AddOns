Wardrobe - An Equipment Management AddOn for World of Warcraft
----------------------------------------------------


DESCRIPTION
-----------
Wardrobe allows you define up to 20 distinct equipment profiles 
(called "outfits") and lets you switch among them on the fly.  
For example, you can define a Normal Outfit that consists of 
your regular equipment, an Around Town Outfit that consists of 
what you'd like to wear when inside a city or roleplaying, a 
Stamina Outfit that consists of all your best +stam gear, etc.  
You can then switch amongst these outfits using a simple slash chat 
command (/wardrobe wear Around Town Outfit), or using a small 
interactive button docked beneath your radar.

CHAT COMMANDS
-------------
/wd - help
/wd list - List your outfits
/wd wear <name> - wear <name> outfit
/wd reset - erase all outfits
/wd lock/unlock - For moving Button/Menu.
/wd click/mouseover - For method of displaying menu.
/wd scale [0.5-1.0] - For scaling the DropDown Menu.
/wd auto 1/0 - Toggle auto-swapping

OPTIONAL REQUIREMENTS
---------------------
Titan - A Bar and Menu framework for WoW mods.
http://ui.worldofwar.net/ui.php?id=1442http://www.wowinterface.com/downloads/fileinfo.php?id=4559

FuBar 3 - A Bar and Menu framework for WoW mods.
http://www.wowinterface.com/downloads/fileinfo.php?id=4571

Khaos (For GUI options) - A configuration framework for WoW mods (new gui).
http://www.cosmosui.org/

MobileMinimapButtons - Shift-drag buttons around the minimap at a constant radius.
http://www.wowinterface.com/downloads/fileinfo.php?s=&id=4269


INSTALLATION 
------------
1. Unzip Wardrobe.zip into your WoW addon folder. 
   (World of Warcraft\Interface\Addons)
2. Answer YES to the prompt about replacing any duplicate files. 


CREDITS
-------
Wardrobe 2.60-AL and greater are maintained by Swizstera
Wardrobe 1.4-AL and greater are written by AnduinLothar
Wardrobe 1.21-lix -> 1.3.1-lix was written by Miravlix
Wardrobe 1.21 and lower was written by Cragganmore


AUTHOR INFORMATON
-----------------
AnduinLothar - karlkfi@yahoo.com
Swizstera - curse.com

DOWNLOAD LINK 
-------------
http://wow.curse.com/downloads/wow-addons/details/wardrobe-al.aspx
http://www.wowinterface.com/downloads/info4471-Wardrobe-AL.html

UPDATES
-------
Version 3.42-AL
o Fix for new gear items that have more than one of the new variables in the itemstring.  
  The upgrade bonuses are stored here I believe.  Added logic to handle up to 6 of them.
  These aren't in the itemstrings that are stored within wardrobe, so if the same item has only a difference in the upgrade, this may have to be revisited.  

Version 3.41-AL
o Fix dual weapon equipping, failed under certain circumstances
o Fix parsing of new itemlinks.  The item name was getting lost.
o Add logic to repair the data that got mangled by version 3.39/3.40 to add the item names back in.
o Fix display of equipped outfits. 

Version 3.40-AL
o Fix toggle button in wardrobe update paperdoll
o Fix helm/cloak hiding and display
o Fix dynamic stat variable in item links.

Version 3.39-AL
o Update for WoW 6.0.2
o Rev embedded LibBabble-Inventory
o Rev embedded Ace3

Version 3.38-AL
o Update for WoW 5.4
o Fix for caged battlepet in bags causing nil error
o Rev embedded Ace3
o Rev embedded LibBabble
o Rev embedded LibGratuity

Version 3.37-AL
o Add local _ variable declaration since it is used in other addons/places in the game.  

Version 3.36-AL
o Update Baggins plugin for Ace3 version of Baggins

Version 3.35-AL
o Update for WoW 5.0.5
o Update itemlink to include reforged items.
o Filter link level field from itemlink since it appears ahead of reforge field.
o Rev embedded Ace3
o Rev embedded LibBabble
o If class is MAGE, WARLOCK, HUNTER, or PRIEST: if old ranged slot has an item, move it to main hand slot in outfit.

Version 3.34-AL
o Update for WoW 4.3

Version 3.33-AL
o Fix nil error when renaming outfit.
o Fix outfit icon synchronization.
o Add Tol Barad detection for autoswapping outfits.
o Add Twin Peaks and The Battle for Gilneas as battleground zones for autoswapping.
o Fix bug in Titan's Grip detection.
o Fix WearMe to work better with Equipment Manager defined outfits.  Equipment Manager
  does not store the extra information like gems and enchants in it's gearsets.

Version 3.32-AL
o Fix nil error when not playing a warrior. 

Version 3.31-AL
o Fix nil error for new characters.
o Fix Titan's Grip detection for warriors.
o Rev AceGUI-3.0, AceTab-3.0
o Rev LibBabble-Inventory to r137
o Rev LibBabble-Zone to r328
o Update for Wow 4.2

Version 3.30-AL
o Remove dependency on Chronos.  Using AceTimer now.
o Add synchronization with Equipment Manager.
o Rev Ace-3.0
o Rev LibBabble-Inventory-3.0
o Rev LibBabble-Zone-3.0
o Update for Wow 4.1

Version 3.29-AL
o Add AceLibrary back.
o Rev LibGratuity to r42
o Fix nil on 'this' when dragging wardrobe button.
o Fix nil on 'this' when resetting wardrobe button position.
o Right clicking minimap button was not opening main menu/settings menu.

Version 3.28-AL
o Update DataBroker support to work properly with ChocolateBar. 

Version 3.27-AL
o Fix Wardrobe.xml OnUpdate elapsed bug.  Thank you Quil for pointing this out.
o Removed native support for FuBar.  FuBar appears to be dead as of WoW 4.0.

Version 3.26-AL
o Fixes for Cataclysm 4.0.1
o Rev embedded Ace 3.0 to r975
o Rev embedded LibBabble-Zone to 4.0-release2
o Rev embedded LibBabble-Inventory to 4.0-release1
o Rev embedded LibTipHooker to 1.1 r14.
o Rev embedded LibGratuity to r42
o Note that this auto-hides the Equipment Manager icon in the character panel now since the 
  equipment manager cannot be disabled anymore from within settings.

Version 3.25-AL
o Add Nat's Lucky Fishing Pole to list of fishing items.
o Add Isle of Conquest to list of battleground zones.
o Add button to reset minimap icon to default location on map.
o Only allow changing of outfits when not in combat.  
  This is a workaround to stop items from getting picked up to cursor when in combat.
  Blizzard changed the way equipping items works in 3.3 making this not work anymore.  
  I have it working somewhat on my pre-alpha release but since that is so far out, I will
  search for another way to make it work.
o Rev embedded Ace3 to Release-r907
o Rev embedded LibBabble-Zone to 3.3-release13
o Rev embedded LibBabble-Inventory to 3.3-release5

Version 3.24-AL
o Rev for WoW 3.3

Version 3.23-AL
o Fix checkbox hi-lighting of shirt and ring slot 2 so the whole box is selectable.
o Add ability to set the default display state for helm and cloak when the per-outfit display 
  feature is turned on.   When the display box for the helm or cloak is unselected, it will use the
  default setting.  It defaults to Show.

Version 3.22-AL
o Fix problem when a special outfit is being worn and then you delete that special outfit.  It does not remove the virtual outfit to wear when the
  unequipping of the special outfit is triggered.  This would cause bizarre behaviour when unmounting, leaving plaguezones, etc.

Version 3.21-AL
o Fix equiping on Lance from Argent Tournament if you are dual wielding 2H weapons.
o Add option to not auto-swap while in Wintergrasp.
o Removed logic to remember a default display state for helm and cloak.
  I.e: Let's say you select not to display your helm or cloak on one outfit,  and leave all the others unchecked (empty box, not the crossed-out eye icon). 
       If you had your helm shown and wear that outfit, when you switch back to another outfit your helm/cloak 
       will remain unshown.  Leaving an item unchecked means it is ignored and whatever the current display state is will remain.  
       I think it works more intuitively this way.
o Update for WoW 3.2.0

Version 3.20-AL
o Fix leak of a global db variable.
o Fix issue with auto-swapping in WSG when auto-swap is off.
o Rev LibBabble-Zone
o Rev LibBabble-Inventory

Version 3.19-AL
o Cloak/Helm visibility feature toggle added to config settings and default is off.    

Version 3.18-AL
o WearMe v3.2 - Fix so it unequips the offhand if you try to equip a staff even if you can equip 2H weapons in both hands.  Staffs aren't included in that.
o Fix issue of crashes for first time installs.
o Fix problem of UI dropdown backdrops getting set to Wardrobe's backdrop.

Version 3.17-AL
o Add support for LibDataBroker.  This replaces the Titan Panel plugin as Titan Panel supports LDB natively.  FuBar plugin is still available as is.
o Add ability to hide cloak/helm per outfit.  New buttons are located on the cloak/helm slots for you to enable/disabling the visual for them.  
  patch provided by zmnspencer.
o Add Baggins filter to allow filtering of items that don't belong to an outfit. If you have Baggins addon, the filter should show as Wardrobe-AL.
o Change background texture of outfit DropDown menu so that setting opacity to 100% will make it fully opaque.  Reworked use of UIDropDownMenu to make this possible.

Version 3.16-AL
o Remove Naxxramas from being a Plaguelands zone.
o Fix dropdownlist scale slider.
o Fix where nil/empty outfit names were allowed to be saved causing nil errors in other parts of addon.  Any nil named outfit already stored 
  will be removed during startup.  If outfit name is left empty when creating new outfit, it will not be stored anymore.
o Update embedded Ace3 library to latest revision (777)
o Add opacity settings for drop down frames.  1.0 isn't fully opaque though since it's a UIDropDownMenu frame.

Version 3.15-AL
o Update embedded Chronos addon to 2.12
o Update embedded LibBabble-Zone to rev 204
o WearMe update v3.1 - Fix bug swiching from two weapons to one 2H weapon when secondary slot is specified but empty.

Version 3.14-AL
o Fix bug where hitting the delete button in the main menu after deleting the last outfit would throw an exception.
o Fix issues when equipping identical items in the dual-equip slots (rings,trinkets,weapons).  Better support dual wielding 2H weapons.

Version 3.13-AL
o Update for patch 3.1.0
o Add Dalaran Arena to Battleground/PVP filter

Version 3.12-AL
o WearMe: v2.9 - Add better support for Unique-Equipped items as well as gems.  
o              - Add support for LibBabble-Inventory-3.0 to provide translations for bag and container strings

Version 3.11c-AL
o WearMe: v2.8 - Fix bug in itemsplit hook

Version 3.11b-AL
o WearMe: v2.7 - Fixes to weapons, trinkets, and ring swapping

Version 3.11a-AL
o WearMe: v2.6 - Fix to work with dual wield 2H weapons

Version 3.11-AL
o Add support for vehicle mounts like the magic carpet.
o Adjust layout of options dialog.
o Move most config settings to use ACEDB.  Outfit items are still stored in the previous config.
o Fix several config related bugs.
o Word wrap outfit tooltip so it's not all on one line.  It's broken up by full outfit names.
o Fix vertical scroll bar in Edit Outfits menu.
o If FuBar or Titan text is greater than 20 characters, shorten it followed by "..."

Version 3.10c-AL
o WearMe: Use localization strings for bags.  deDE uses Tasche for the backpack, but Behälter for the other bags.

Version 3.10b-AL
o WearMe: Change "Bag" references to INVTYPE_BAG to try to resolve some locale issues.

Version 3.10a-AL
o Rev WearMe to v2.4
  - First swap any unique-equipped items with an item that doesn't have any unique-equipped gems before swapping the rest.

Version 3.10-AL
o Minimap toggle on Titan Panel would get out of sync with the master toggle.
o Text on Titan Panel would not get updated when an outfit was updated.
o Add Addon Settings option to Titan Panel
o Tooltips no longer show in bag container or ammo tooltips
o Cache last outfit list looked up for tooltip since tooltip text is updated every tick.

Version 3.09-AL
o Update LibBabble-Zone-3.0 to Revision 162
o Add a local AceLocale-3.0 LibStub to WardrobeFu.lua.  Sometimes the global L variable would not be locatable from that lua.
o Tweak wearme to fix problem when bags were moved around, the bagtype cache could get out of sync.
o Enable wardrobe toggle in settings now works.
o Wardrobe Debug toggle enables wearme debugging.

Version 3.08-AL
o Fixed bug where dragging outfit in Main Menu would cause an error to throw.  
o Fixed a few variable initialization problems causing nil errors on occasion.
o Added Settings button on Main Menu
o Added translations for new deDE and frFR localization text.  I used online translation so it may not be accurate.

Version 3.07-AL
o Autoswap mount special outfits in shapeshift travel forms now.  Travel Form, Flight Form, and Swift Flight Form are supported.
  I was unable to adequately test localization of shapeshifting so it may not work in other locales.

Version 3.06-AL
o Tweaks to autoswap of mounted gear while in battlegrounds and arena
o Autoswap setting is persistent as of 3.05, and default was false.  Changed to true. 

Version 3.05-AL
o OnUpdate frequency also broke the autoswap when casting long spells when mounted.  Fix provided by Quil.
o AutoSwap can be disabled for Arena and Battlegrounds.  Checkbox is available in Addon Settings and FuBar dewdrop menu.

Version 3.04-AL
o OnUpdate is called much more frequently in 3.0.2.  This broke the autoswap when unmounting due to going into combat.  Fix provided by Quil. 

Version 3.03-AL
o AceLibrary left out of libs path, added it back in.

Version 3.02-AL
o Dewdrop fubar config menu is back, you can select for it to display on right click by going into the addon settings under fubar.
o Characters with no Wardrobe profile set up have a few default outfits created.  A default on for whatever they are currently wearing, 
  a Birthday Suit one, and a fishing one that will set it to use any fishing pole or fishing hat that happens to be in inventory/bags.
  There is a button in the Addon settings to add the default outfits as well.
o There is a Right Click setting in Addon Settings now for both the Minimap button and Fubar.  You can now set them separately.
o More configuration settings are available in the addons settings.

Version 3.01-AL
o Add variable sanity checking for tooltip and rightclick variables
o Update FuBar text when an Outfit is updated, added, deleted, cleared, etc.

Version 3.00-AL
o Update to use ACE3 for GUI configuration, look in Blizzards Addons Interface!
o Add tooltip support to show which outfits an item belongs
o Fix items not being found in inventory due to stale cache.
o character level was being included in stored item causing outfits not to show items in dropdown.
o Known issue: DropDown scale setting does not work.

Version 2.60-AL
o Update for WoW 3.0
o Now maintained by Swizstera

Version 2.55-AL
o Updated WearMe to fix swapping and caching bugs
o No Longer Requires SeaHooks

Version 2.54-AL
o Updated WearMe to fix taint and swapping bugs

Version 2.53-AL
o Re-Fixed Wardrobe.Print
o You can no longer move outfits above or bellow the top or bottom of the list

Version 2.52-AL
o Fixed Wardrobe.Print

Version 2.51-AL
o TOC to 20003
o Fixed issue with SetDropDownScale and Khaos on first load

Version 2.5-ALo Fixed a bug where moved outfits would be put in the virtual list (those outfits will be restored, tho the order may have changed)o Fixed a bug where outfits were being marked as virtual when swapping backo Fixed a bug where virtual outfits weren't being deletedo Cleaned up the SV by removing the sort numbers and using only the list ordero You can now store an unlimited number of outfits (but you might want to stop when your drop down list is larger than the screen ;)o Fixed a bug with the colored outfit chat printouto Fixed "/wd list items" 

Version 2.41-AL
o Fixed Main Menu entries not showing if you had less that 10 outfits
o Fixed reference to separator image
o Fixed Main Menu separator to only show when the mouse is over a legitimate drop zone for the entry on the mouse (Dropping immediately above or bellow the original entry does nothing)
o Fixed Main Menu entry highlight to only show when there is an outfit associated with that entry

Version 2.4-AL
o Fully compatible with WoW 2.0
o Main Menu now closes on escape
o Main Menu now uses a highlight bar instead of color changing text (more visible)
o Main Menu entries are now draggable to reorder
o Repositioned the Main Menu little (10 outfits are now visible, instead of 9)
o Right-click on the Minimap Icon now opens the Main Menu
o Virtual outfits are now stored in their own table (so they wont show up in the normal outfit list)
o Added Swimming auto-swap (shark fin icon)
o Because IsSwimming() and IsMounted() are now asynchronous, they are now handled by a timed OnUpdate
o Colorized "/wd list" and made it print all the outfits on the same line so as not to spam the chat frame
o No longer uses ColorCycle

Version 2.3-AL
o Updated FuBar plugin (Alex Courtis)
o Removed erroneous debug print

Version 2.2-AL
o Updated to use IsMounted()
o Updated UnitBuff syntax use

Version 2.1-AL
o Updated for Lua 5.1
o Updated to WearMe v1.6 (with SeaHooks v1.0)
o Titan Panel and FuBar Plugins added and updated for Lua 5.1


Version 2.0-AL
o Titan Panel and FuBar Plugins Have been temporarily removedo Updated for Lua 5.1o Using hooksecurefunc for HideUIPanel hooko Updated to WearMe v1.3 (with SeaHooks v0.81)o Updated to Chronos v2.10o Updated to IsMounted v1.8

Version 1.94-AL
o Updated WearMe to fix bank error

Version 1.93-AL
o Fixed order of outfit dropdown menu

Version 1.92-AL
o Updated WearMe to v1.1.
- Should fix a problem with duplicate items not equipping correctly
- No longer breaks when encountering special bag types

Version 1.91-AL
o Added FuBar 2.0 support with similar functionality to Titan Panel support
o Restructured Titan plugin files
o Neither bar plugin code will execute if their respective dependancy is not loaded

Version 1.9-AL
o Now uses the WearMe Lib for item swaps (abstracted lib for equipment swapping)
o Upped Max Outfits to 30 (abstracted the button creation code, but limited now by WoW's max dropdown menu size)
o Fixed bug with menu not scrolling the first time you open it
o Fixed bug with Titan tooltip, text and dropdown not working
o Rewrote swap automation code:
- Undead zone swap now occurs when you dismount, zone in unmounted or swap outfit when in the plaguelands
- Wont swap immediately when mounted
- Swaps back to gear you had on before you mounted before swapping into undead outfit when dismounting after zoning
o Added slash command, binding and khaos option to temporarily toggle/dissable/enable auto-swapping (only stored across sessions if you have Khaos)
o Added an "Update" button and drop down menu to the character window for updating or creating outfits __without swapping to that outfit first__.
o Removed required Localization Lib usage
o Embedded WearMe, IsMounted and Chronos. If you have multiple copies the newest one will be in effect.
o Sky enhanced slash commands updated to use the Satellite lib instead

Version 1.87-AL
o Fixed bug that was causing Titan Button text to not show up. (Silly Titan doesn't take direct functions, only global function names)

Version 1.86-AL
o Titan text typo fix

Version 1.85-AL
o Fixed some frame errors due to the recent xml changes
o Updated embedded Localization to v0.07

Version 1.84-AL
o Added Naxx to the plaguezones
o Updated Outfit Swapping to correctly identify 1-way swaps between items in a similar inventory slot
o Enabled soft matching to find items in bags with a different enchant if an exact match is not found
	(these outfits will still show grey until you update them with the correctly enchanted items, 
	but it will swap the newly enchanted items regardless)
o Removed experimental tabularization of XML frames, fixes a bug with some tooltip hooking addons
o Made DragLock save accross sessions. (MustClickUIButton already saves)

Version 1.83-AL
o Fixed nil 'color' error
o Readded '<no outfit>'

Version 1.82-AL
o Fixed nil error
o Duplicate virtual outfits now delete themselves
o Virtual outfits no longer show up on the list

Version 1.81-AL
o Fixed Sea error

Version 1.8-AL
o Implemented Localization to allow for locale switching and assist future translation.
o Warlock summonable/equipable items are no longer remembered specific to id suffix.
o Removed outdated Cosmos support
o Added options to the Khaos config
o Rewrote the DropDown code to use the built-in DropDowns, reduced a lot of code.
o Updated Titan config to be more colorful
o Fixed Titan minimap button hiding
o Added option to rescale the global dropdown menu (0.5-1.0) ('/wardrobe scale #')
o Removed Titan small menu option (incompatible with DropDown format)
o DropDown no longer uses ColorCycle
o Made the help text easily localizable
o Added MyRolePlay support for outfit swap events


Version 1.71-AL
o Added option to move swapped offhand to the rear bag if swapping to a 2h, requires Chronos.

Version 1.7-AL
o Saved Variables now auto-clean extra unused item tables and old temp outfits
o Now correctly handles swapping of a 2h weapon on top of 2 1h items regardless 
  of offhand check
o Fixed OnLoad error when titan isn't installed
o Fixed a few unintentionally global variables
o Moved swap status variables into the saved vars so that mount swaps now 
  correctly occur on log in after logging off mounted.

Version 1.61-AL
o All files converted to unix standard LF line breaks for uniformity
  Also fixes a localization.de.lua loading error.

Version 1.6-AL
o Added German Localization: Thanks Gillion!
o Fixed duel slot swapping (offhand, 2nd trinket, 2nd ring) for all possible
  swaps that I could think of.

Version 1.5-AL
o Equipment saving now uses ItemID's (perm enchants, but not 
  temp enchants)
  Old outfits will still use names until editted.
o Fixed offhand swapping out with two-handers
o Fixed forced empty slots and outfit detection
o Fixed item swapping for two inventory items (rings, trinkets, 
  weapons)
 -Note: When equipping a bag item to an inventory slot currently 
  occupied by another item used in the same outfit,
  the item currently equipped will be bagged instead. 
 -The only solution I can think of is to scan the rings, trinkets, 
  and weapons again after a delay.
 -Of course, equipping the outfit a second time will equip any 
  skipped items, but is a little excessive.
o Added click/mouseover to the help print out
o Added optional Khaos enable/disable
o Added optional Sky slash command help
o Added optional Chronos dep to eliminate redundant aura and 
  equipment scans. More efficient, but optional.
o Mount/Plague/Chow special status is no longer removed when updating an outfit.
o Fixed Button Graphics

Version 1.43-AL
o Added click/mouseover to help printout.

Version 1.42-AL
o Added click/mouseover option for the menu. Default menu shows on
  mouseover of minimap button or titan button. Use "/wd click" to
  require click for menu.
	
Version 1.41-AL
o Equiping now uses AutoEquipCursorItem except for rings, trinkets
  and weapons which now use EquipCursorItem
o Minimap hiding option now correctly remembers if you are using
  Titan without the TitanWardrobe option and is stored per player
  in the Wardrobe_Config.

Version 1.4-AL
o Removed Sea dep
o Removed Chronos dep
o Added IsMounted dep for efficiency:
 -Fixes Aspect of the Cheetah and Aspect of the Pack incorrect
  mount detection,
 -Required for mount auto swap (Wardrobe will still work w/o it,
  you can still assign mount sets, but it wont swap)
o Removed tooltip scanning
o Added Delay to DropDownMenu hiding
o Minimap button uses MobileMinimapButton when availible
o Included Titan Support, thanks to Nemes for TitanWardrobe
o Converted code to more object oriented style. Most everything
  is within the Wardrobe table, even the XML frames

Version 1.3-lix
o Stopped using playerName as a global variable name.

Version 1.3-lix
o Fixed the bug that prevented equiping two identical items.

Version 1.21-lix
o Updated configuration to save based on realm and char name, so you can
  have chars with the same name on multiple realms.
o Removed some unessesary chat messages.
o Fixed Tigers Fury being detected as a mount.

Version 1.2:

o Increased the maximum number of outfits per character from 10
  to 20.
o Rewrote much of the outfit manipulation code to make it more
  efficient and to remove the slow-down that the previous
  version was causing.
o Added entirely new UI system for managing your outfits: allows
  you to easily reorder, rename, edit, delete, update, or change 
  the color of the outfit name.
o Outfits may now consist of intentionally blank item slots.
o Outfits can now consist of only certain item slots, ignoring
  those slots that you don't want to mess with.  For example,
  you could have an outfit that consists of only your "Carrot
  on a Stick" trinket.  Equipping this outfit wouldn't interfere
  with anything worn in any other item slot except that one
  trinket slot.
o You may now specify outfits to auto-equip and un-equip on certain
  conditions: whenever you mount (useful for automatically wearing
  the "Carrot on a Stick" and Mithril Spurs), whenever you enter 
  the Plaguelands (so you don't forget to equip the Argent Dawn
  Commission), and whenever you're eating/drinking (useful if you
  have certain items that affect regeneration or spirit).
o Added keybindings for all 20 outfits.

TO DO LIST
----------
o More Automatic equiping triggers, entering a zone, being PvP 
  flagged, not being PvP flagged and stance/form triggers.
o Supporting StanceSet/WeaponSwitch or building the feature into
  Wardrobe.
o Add support for weapons with two forms.
