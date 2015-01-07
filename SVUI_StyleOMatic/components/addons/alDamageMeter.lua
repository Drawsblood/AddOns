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
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack 	= _G.unpack;
local select 	= _G.select;
local pairs 	= _G.pairs;
local string 	= _G.string;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = _G.SVUI;
local L = SV.L;
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
--[[ 
########################################################## 
ALDAMAGEMETER
##########################################################
]]--
local function StyleALDamageMeter()
  assert(_G['alDamagerMeterFrame'], "AddOn Not Loaded")
  
  alDamageMeterFrame.bg:Die()
  PLUGIN:ApplyFrameStyle(alDamageMeterFrame)
  alDamageMeterFrame:HookScript('OnShow', function()
    if InCombatLockdown() then return end 
    if PLUGIN:ValidateDocklet("alDamageMeter") then
      PLUGIN.Docklet:Show()
    end
  end)
end
PLUGIN:SaveAddonStyle("alDamageMeter", StyleALDamageMeter)

function PLUGIN:Docklet_alDamageMeter(parent)
  if not _G['alDamagerMeterFrame'] then return end 
  local parentFrame=_G['alDamagerMeterFrame']:GetParent();
  dmconf.barheight=floor(parentFrame:GetHeight()/dmconf.maxbars-dmconf.spacing)
  dmconf.width=parentFrame:GetWidth()
  alDamageMeterFrame:ClearAllPoints()
  alDamageMeterFrame:SetAllPoints(parent)
  alDamageMeterFrame.backdrop:SetStylePanel("Fixed", 'Transparent',true)
  alDamageMeterFrame.bg:Die()
  alDamageMeterFrame:SetFrameStrata('LOW')

  parent.Framelink = alDamageMeterFrame
end 