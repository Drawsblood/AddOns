--[[
##############################################################################
_____/\\\\\\\\\\\____/\\\________/\\\__/\\\________/\\\__/\\\\\\\\\\\_       #
 ___/\\\/////////\\\_\/\\\_______\/\\\_\/\\\_______\/\\\_\/////\\\///__      #
  __\//\\\______\///__\//\\\______/\\\__\/\\\_______\/\\\_____\/\\\_____     #
   ___\////\\\__________\//\\\____/\\\___\/\\\_______\/\\\_____\/\\\_____    #
    ______\////\\\________\//\\\__/\\\____\/\\\_______\/\\\_____\/\\\_____   #
     _________\////\\\______\//\\\/\\\_____\/\\\_______\/\\\_____\/\\\_____  #
      __/\\\______\//\\\______\//\\\\\______\//\\\______/\\\______\/\\\_____ #
       _\///\\\\\\\\\\\/________\//\\\________\///\\\\\\\\\/____/\\\\\\\\\\\_#
        ___\///////////___________\///___________\/////////_____\///////////_#
##############################################################################
S U P E R - V I L L A I N - U I   By: Munglunch                              #
##############################################################################
  /$$$$$$   /$$$$$$  /$$   /$$ /$$$$$$$$ /$$      /$$  /$$$$$$               #
 /$$__  $$ /$$__  $$| $$  | $$| $$_____/| $$$    /$$$ /$$__  $$              #
| $$  \__/| $$  \__/| $$  | $$| $$      | $$$$  /$$$$| $$  \ $$              #
|  $$$$$$ | $$      | $$$$$$$$| $$$$$   | $$ $$/$$ $$| $$$$$$$$              #
 \____  $$| $$      | $$__  $$| $$__/   | $$  $$$| $$| $$__  $$              #
 /$$  \ $$| $$    $$| $$  | $$| $$      | $$\  $ | $$| $$  | $$              #
|  $$$$$$/|  $$$$$$/| $$  | $$| $$$$$$$$| $$ \/  | $$| $$  | $$              #
 \______/  \______/ |__/  |__/|________/|__/     |__/|__/  |__/              #
##############################################################################                                                     
]]--

--[[

    Schema is a property and concept used to help dynamically define database indexes.
    The main purpose for its creation was to provide a way to generate useable config 
    variables for any plugin, including those that are LoadOnDemand!

    To the best of my knowledge, this has never been done before (/flex)!

    The schema convention is utilized by the "LibSuperVillain" library to ensure 
    proper organization of our various addon configs (see NOTE)

    For Packages:
    
    You have to define the modules schema when you send its object to the library

    Here is an example:

]]--

local lib = LibSuperVillain("Registry")
local PKG = {};

--Here you would build your package object, then...

lib:NewPackage(PKG, "SumFukinPackage")

--So now you can get the schema name like this:

local Schema = PKG.Schema

--[[

    For Plugins:

    You will set the schema in the plugins .toc file using meta-data fields
    prefixed with "X" to indicate its a custom entry, the SuperVillain indicator "SVUI",
    and finally the type of entry it is

    (there are two possibilities at the time of this writing. "Header" and "Schema") 

    so it will end up looking like this:
    X-SVUIName

    or this:
    X-SVUISchema

    Your toc should end up looking something like this:

    ~(SumFukinPlugin.toc)

    ## Interface: 60000
    ## Author: SumFukinDude
    ## Version: 1.0
    ## X-SVUIName: Some Fukin Addon
    ## X-SVUISchema: SumFukinSchema


    Having defined and initialized all requirements at this point, your database will now
    have named references linking to this object by schema.
]]--

--[[

    LoadOnDemand:

    When schema is defined for plugins that are NOT loaded by default, the library will
    be able to parse all toc files that contain an "X-SVUISchema" property and generate
    a database entry as well as a config option so that we can manipulate that plugin and
    save our changes.

    The benefit here is this:

    Let's use SVUI_CraftOMatic for example. If by default this LOD addon is Disabled, we can't read
    on any lua code inside the addon. This prevents the ability to set config variables and therefore
    build config options. Before we would have had to add a button to allow the player to click and "Enable" it.
    This is fine but what if we also want to make the choice to keep it enabled every time we log in?
    That would not have worked since your options would not be loaded UNTIL you clicked the enable button!
    Using schema however, we can still create our configs 
    AND set the data entry from saved variables (if they exist in the file)
    which allows our core to not only detect its existence but also see if it was previously enabled
    and if so then go ahead and load/enable the addon.

    BOOM!! 

]]--

--[[

    NOTE: Configs and Modules are explained in their respective documents

]]--