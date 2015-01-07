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
local twipe = table.wipe;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
local activePanels = {};
local StupidSkada = function() return end
--[[ 
########################################################## 
SKADA
##########################################################
]]--
local function skada_panel_loader(dock, window)
  local width,height = dock:GetSize()

  window.db.barspacing = 1;
  window.db.barwidth = width - 10;
  window.db.background.height = height - (window.db.enabletitle and window.db.title.height or 0) - 12;
  window.db.spark = false;
  window.db.barslocked = true;
  window.bargroup:ClearAllPoints()
  window.bargroup:SetAllPointsIn(dock, 3, 3)
  window.bargroup:SetFrameStrata('LOW')

  local bgroup = window.bargroup.backdrop;
  if bgroup then 
    bgroup:Show()
    bgroup:SetStylePanel("Fixed", 'Transparent', true) 
  end

  dock.FrameLink = window;
end

function PLUGIN:Docklet_Skada()
  if not Skada then return end

  local dock1,dock2,enabled1,enabled2 = PLUGIN:FetchDocklets();

  for index,window in pairs(Skada:GetWindows()) do
    if(window) then
      local wname = window.db.name or "Skada"
      local key = "SkadaBarWindow" .. wname

      if(enabled1 and dock1:find(key)) then
        skada_panel_loader(PLUGIN.Docklet.Dock1, window);
      elseif(enabled2 and dock2:find(key)) then
        skada_panel_loader(PLUGIN.Docklet.Dock2, window);
      else
        window.db.barslocked = false;
      end
    end
  end
end

local function Skada_ShowPopup(self)
  PLUGIN:LoadAlert('Do you want to reset Skada?', function(self) Skada:Reset() self:GetParent():Hide() end)
end

local function StyleSkada()
  assert(Skada, "AddOn Not Loaded")
  Skada.ShowPopup = Skada_ShowPopup
  
  local SkadaDisplayBar = Skada.displays['bar']

  hooksecurefunc(SkadaDisplayBar, 'AddDisplayOptions', function(self, window, options)
    options.baroptions.args.barspacing = nil
    options.titleoptions.args.texture = nil
    options.titleoptions.args.bordertexture = nil
    options.titleoptions.args.thickness = nil
    options.titleoptions.args.margin = nil
    options.titleoptions.args.color = nil
    options.windowoptions = nil
  end)

  hooksecurefunc(SkadaDisplayBar, 'ApplySettings', function(self, window)
    local skada = window.bargroup
    if not skada then return end
    local panelAnchor = skada
    skada:SetSpacing(1)
    skada:SetFrameLevel(5)
    skada:SetBackdrop(nil)

    if(window.db.enabletitle) then
      panelAnchor = skada.button
      skada.button:SetHeightToScale(22)
      skada.button:RemoveTextures()
      skada.button:SetStylePanel("Default", "Transparent")
      --skada.button:SetPanelColor("class")
      local titleFont = skada.button:GetFontString()
      titleFont:SetFont(SVUI.Media.font.dialog, 13, "NONE")
      titleFont:SetShadowColor(0, 0, 0, 1)
      titleFont:SetShadowOffset(1, -1)
    end

    skada:SetStylePanel("Default", "Transparent")
    skada.Panel:ClearAllPoints()
    skada.Panel:SetPoint('TOPLEFT', panelAnchor, 'TOPLEFT', -3, 3)
    skada.Panel:SetPoint('BOTTOMRIGHT', skada, 'BOTTOMRIGHT', 3, -3)
  end)

  hooksecurefunc(Skada, 'CreateWindow', function()
    if PLUGIN:ValidateDocklet("Skada") then
      PLUGIN:Docklet_Skada()
    end
  end)

  hooksecurefunc(Skada, 'DeleteWindow', function()
    if PLUGIN:ValidateDocklet("Skada") then
      PLUGIN:Docklet_Skada()
    end
  end)
end

PLUGIN:SaveAddonStyle("Skada", StyleSkada, nil, true)