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
  /$$$$$$   /$$$$$$  /$$   /$$ /$$$$$$$$/$$$$$$  /$$$$$$   /$$$$$$           #
 /$$__  $$ /$$__  $$| $$$ | $$| $$_____/_  $$_/ /$$__  $$ /$$__  $$          #
| $$  \__/| $$  \ $$| $$$$| $$| $$       | $$  | $$  \__/| $$  \__/          #
| $$      | $$  | $$| $$ $$ $$| $$$$$    | $$  | $$ /$$$$|  $$$$$$           #
| $$      | $$  | $$| $$  $$$$| $$__/    | $$  | $$|_  $$ \____  $$          #
| $$    $$| $$  | $$| $$\  $$$| $$       | $$  | $$  \ $$ /$$  \ $$          #
|  $$$$$$/|  $$$$$$/| $$ \  $$| $$      /$$$$$$|  $$$$$$/|  $$$$$$/          #
 \______/  \______/ |__/  \__/|__/     |______/ \______/  \______/           #
##############################################################################                                                     
]]--

--[[

    The "configs" property is the default (also the backup) of ALL usable database entries.
    When the addon core is initialized, a "db" property is created using a copy of "configs".

    When configs are set under their own index (ie.. SV.defaults["Shiznit"]) AND a module (package, plugin ...etc) 
    has a schema (see NOTE) of the same name, then that index is used to set 
    the module's own "db" property using a pointer reference linking to the core database location.

    Package configs should be set in the primary config file (configs/configs.lua) since they are 
    treated and loaded as internal entities.

    For new packages (not already defined in my default configs) you will need to know the
    associated schema name specific to that package.

    Just add the new package configs to the BOTTOM of the config file like this:

]]--

-- SV and SV.defaults will have already been defined
local Schema = "SumFukinPackage"
SV.defaults[Schema] = { SumFukinValue = true }

--[[

    When adding plugins to the collective, be sure to set respective entries BEFORE loading,
    as the same process takes place for externally connected addons.

    Plugin configs can be set like this:

]]--

local SV = _G["SVUI"]
local Schema = _G["SumFukinPlugin"].Schema -- Get the already assigned schema name
SV.defaults[Schema] = { SumFukinValue = true }

--[[

    NOTE: Schema and Modules are explained in their respective documents

]]--