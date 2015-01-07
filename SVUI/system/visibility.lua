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
local unpack    = _G.unpack;
local select    = _G.select;
local pairs     = _G.pairs;
local tinsert       = _G.tinsert;
local tremove       = _G.tremove;
local twipe         = _G.wipe;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L;
--[[ 
########################################################## 
LOCALS
##########################################################
]]--
local DisplayFrames = {};
--[[ 
########################################################## 
FRAME VISIBILITY MANAGEMENT
##########################################################
]]--
function SV:AddToDisplayAudit(frame)
    if(frame.GetParent) then
        DisplayFrames[frame] = frame:GetParent()
    end 
end 

function SV:FlushDisplayAudit()
    self.NeedsFrameAudit = true 
    if(InCombatLockdown()) then return end 
    for frame, _ in pairs(DisplayFrames)do 
        frame:SetParent(self.Hidden) 
    end
end 

function SV:PushDisplayAudit()
    if(InCombatLockdown()) then return end
    for frame, parent in pairs(DisplayFrames) do
        frame:SetParent(parent or UIParent) 
    end
    self.NeedsFrameAudit = false
end