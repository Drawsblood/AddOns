local addonName, vars = ...
local L = vars.L
GarajalAnnounce = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceTimer-3.0")
local addon = GarajalAnnounce 
vars.svnrev = {}
vars.svnrev["core.lua"] = tonumber(("$Revision: 38 $"):match("%d+"))

local defaults = {
  profile = {
    debug = false,
    enable = true,
    enablelfr = false,
    raidwarning = true,
    raidicons = true,
    whisper = true,
    self = false,
    healermana = true,
    hybrid = true,
    healerdelay = 3,
    dpsdelay = 3,
    minimap = {
        hide = false,
    },
    players = {},
    maxorder = 1,
    reportbuff = true,
    sendcount = {
      [10] = {
        normal = { healers=1, dps=2 },
        heroic = { healers=1, dps=2 },
      },
      [25] = {
        normal = { healers=1, dps=4 },
        heroic = { healers=1, dps=4 },
        lfr    = { healers=1, dps=2 },
      },
    }
  }
}

local players
local defaultpriority = 2

local spellids = {
  voodoo = 122151,  -- voodoo doll, ineligble for totem
  --voodoo  =  57723,  -- Exhaustion, for testing only
  crossed = 116161,  -- Crossed Over, in spirit realm up to 30 sec (116160 in lfr)
  buffed  = 117549,  -- Spiritual innervation, 30 sec dps/mana buff (also 117543 for healers)
  frail   = 117723,  -- Frail Soul (heroic) cannot enter for 30 sec
  totem   = 116174,  -- boss summoned a new totem
  banish  = 116272,  -- boss banished the tank
}
local spellnames = {}
function addon:InitNames()
  for key, id in pairs(spellids) do
    if not spellnames[key] then
      spellnames[key] = GetSpellInfo(id)
    end
  end
end
local totemInterval = 35 -- seconds between summon totem

local settings = defaults.profile
local optionsFrame
local charName
local minimapIcon = LibStub("LibDBIcon-1.0")
local LDB, LDBo

local function chatMsg(msg)
     DEFAULT_CHAT_FRAME:AddMessage(addonName..": "..msg)
end
local function debug(msg)
  if addon.db.profile.debug then
     chatMsg("Debug: "..msg)
  end
end

local function UnitToName(unit)
  return GetUnitName(unit, true)
end

function addon:GetDiff()
  local instname, insttype, diff, diffname, maxPlayers, playerDifficulty, isDynamicInstance = GetInstanceInfo()
  if maxPlayers ~= 10 and maxPlayers ~= 25 then -- might never happen, just in case
     maxPlayers = 25
  end
  addon.raidsize = maxPlayers
  if HasLFGRestrictions() or IsInLFGDungeon() then
     addon.raiddiff = "lfr"
  elseif diff == 5 or diff == 6 then
     addon.raiddiff = "heroic"
  else
     addon.raiddiff = "normal"
  end
  if addon.dryrun then -- for testing
    addon.raidsize = 10
    addon.raiddiff = "heroic"
  end
  if addon.raiddiff == "lfr" then
    totemInterval = 30
  elseif addon.raidsize == 25 then
    totemInterval = 20
  else -- 10 man
    totemInterval = 35
  end
end

function addon:EnabledDiff()
  if not settings.enable then 
    return false
  end
  addon:GetDiff()
  if addon.raiddiff == "lfr" then
    return settings.enablelfr
  else
    return true
  end
end

function addon:canAnnounce()
  return UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")
end

function addon:shouldAnnounce()
  return addon:canAnnounce() and (addon:EnabledDiff() or addon.dryrun) and not addon.suppress
end

function addon:ClearIcons()
  for i=1,40 do
    local unit = "raid"..i
    if UnitExists(unit) then
      SetRaidTarget(unit, 0)
    end
  end
end

function addon:InZone()
  local oldmap = GetCurrentMapAreaID()
  local oldlvl = GetCurrentMapDungeonLevel()
  SetMapToCurrentZone()
  local map = GetCurrentMapAreaID()
  local lvl = GetCurrentMapDungeonLevel()
  local inzone = (map == 896 and lvl == 2)
  local unitX, unitY = GetPlayerMapPosition("player")
  if not unitX then unitX,unitY = 0,0 end
  unitX, unitY = unitX*100, unitY*100
  SetMapByID(oldmap)
  if lvl and lvl > 0 then
    SetDungeonMapLevel(oldlvl)
  end
  if unitX < 60 then
    return false
  else
    return inzone
  end
end

local combat_events = {
 "UNIT_SPELLCAST_SUCCEEDED",
 "PLAYER_REGEN_DISABLED",
 "UNIT_AURA",
 "UNIT_PHASE",
 -- "COMBAT_LOG_EVENT_UNFILTERED"
}

function addon:CheckEnable()
  if not addon.init then return end
  --debug("CheckEnable")
  if addon:InZone() and addon:EnabledDiff() and not addon:canAnnounce() and not addon.offwarn then
    chatMsg(L["You must have raid lead or assist to make annoucements."])
    addon.offwarn = true
  end
  if addon:InZone() and (addon:shouldAnnounce() or addon.db.profile.debug) then
    addon:InitNames()
    addon:ScanRaid()
    if addon.enabled then return end
    addon.enabled = true
    addon.offwarn = false
    addon:ScanRaid(nil,true) -- clean players not present
    chatMsg(L["Version"].." "..addon.version)
    chatMsg(L["Addon enabled. Type '/ga config' for options."])
    for _,evt in pairs(combat_events) do 
      addon:RegisterEvent(evt)
    end
    if addon.missingroles and addon.missingroles > 0 then
      StaticPopup_Show("GARAJALANNOUNCE_ROLEPOLL")
    end
  else -- wrong zone
    if not addon.enabled then return end
    chatMsg(L["Addon disabled."])
    addon.enabled = false
    for _,evt in pairs(combat_events) do 
      addon:UnregisterEvent(evt)
    end
  end

end

function addon:ScanRaid(reset, cleanold)
  if InCombatLockdown() then return end
  addon:GetDiff()
  local cnt = 0
  if reset then
    settings.maxorder = 0
    wipe(players)
  end
  for _,info in pairs(players) do
    info.unit = nil
  end
  addon.missingroles = 0
  for i=1,40 do
    local unit = "raid"..i
    if UnitExists(unit) then
      cnt = cnt + 1
      local name = UnitToName(unit)
      local class = select(2,UnitClass(unit))
      local info = players[name] or {}
      players[name] = info
      info.unit = unit
      info.name = name
      info.role = UnitGroupRolesAssigned(unit)
      if info.role == "NONE" then
        addon.missingroles = addon.missingroles + 1
      end
      info.priority = (reset and defaultpriority) or info.priority or defaultpriority
      if info.priority < 1 or info.priority > 3 then
         info.priority = defaultpriority
      end
      if class == "PALADIN" or class == "SHAMAN" or class == "DRUID" or class == "PRIEST" then
        info.hybrid_default = true
      else
        info.hybrid_default = false
      end
      if reset or info.hybrid == nil then
        info.hybrid = info.hybrid_default
      end
      if not info.order then -- reset or new player
        info.order = settings.maxorder
        settings.maxorder = settings.maxorder + 1
      end
      info.lastaction = 0
      --debug(name..":"..info.role..":"..info.priority..":"..info.order)
    end
  end
  if addon.missingroles > 0 then
    chatMsg(string.format(L["WARNING: %d players do not have roles assigned and will be ignored."],addon.missingroles))
  end
  if cleanold then -- remove stored players with default settings not in current raid, to prevent SV bloat
    for name,info in pairs(players) do
      if not info.unit and 
         (info.priority == defaultpriority) and 
         (info.hybrid == info.hybrid_default) and 
         (not info.text or #info.text == 0) then
        debug("Cleaning old player: "..name)
        players[name] = nil
      end
    end
  end
  debug("Processed "..cnt.." players, "..addon.missingroles.." unassigned roles")
  addon.scanned = true
end

local function playerSort(i1, i2)
  if (i1.delay ~= i2.delay) then 
    return i1.delay < i2.delay
  elseif (settings.healermana and i1.role == "HEALER" and i1.mana ~= i2.mana) then
    return i1.mana < i2.mana
  elseif (i1.priority ~= i2.priority) then
    return i1.priority < i2.priority
  elseif (i1.lastaction ~= i2.lastaction) then
    return i1.lastaction < i2.lastaction
  else
    return i1.order <= i2.order
  end
end

local function timerTotem() -- scheduled totem arrival
  debug("timerTotem activation")
  if UnitDebuff("player", spellnames.crossed) then
    -- if we are in the spirit phase, we may have missed the totem cast
    -- duplicates are automatically removed
    addon:handleTotem()
  end
end

local function delayedTotem() 
   addon.delaytotem = nil
   addon:handleTotem()
end

local healerElig = {}
local dpsElig = {}
function addon:handleTotem(predict)
  local now = GetTime()
  if predict then
    debug("handleTotem(predict)");
  else
    addon.lasttotem = addon.lasttotem or 0
    if now < addon.lasttotem + 5 or addon.delaytotem then
      --debug("Ignoring duplicate handleTotem")
      return
    end
    local gotvoodoo = 0
    for i=1,40 do -- ticket 4: handle case where totem is summoned between voodoo fade and re-application
      local unit = "raid"..i
      if UnitExists(unit) and UnitDebuff(unit, spellnames.voodoo) then
        gotvoodoo = gotvoodoo + 1
      end
    end
    if gotvoodoo < 2 and not addon.dryrun then
      debug("Delaying totem assignment for voodoo doll change")
      addon:ScheduleTimer(delayedTotem, 0.5)
      addon.delaytotem = true
      return
    end
    addon.lasttotem = now
    addon.totemcount = (addon.totemcount or 0) + 1
    debug("handleTotem() "..addon.totemcount);
  end
  --debug(GetRealZoneText()..":"..GetSubZoneText()..":"..GetZoneText()..":"..GetMinimapZoneText())
  wipe(healerElig)
  wipe(dpsElig)
  for i=1,40 do
    local unit = "raid"..i
    local zone, online, isDead = select(7,GetRaidRosterInfo(i))
    if UnitExists(unit) and (addon.dryrun or 
       (online and not isDead and zone == addon.zone and
        not UnitIsDeadOrGhost(unit) and UnitIsConnected(unit))) then
       local name = UnitToName(unit)
       local info = players[name]
       local list = nil
       if info and info.role == "DAMAGER" then 
         list = dpsElig
       elseif info and info.role == "HEALER" then 
         list = healerElig
         info.mana = UnitPower(unit, SPELL_POWER_MANA)/UnitPowerMax(unit, SPELL_POWER_MANA)
       end
       local elig = list
       while elig do -- fake loop to simulate continue
         local expires
         if UnitDebuff(unit, spellnames.voodoo) then
	   debug(name.." HAS VOODOO")
	   elig = false; break;
	 end
         info.delay = 0
	 expires = select(7,UnitDebuff(unit, spellnames.crossed))
	 if expires then
	   debug(name.." IS CROSSED")
	   if addon.raiddiff == "heroic" then
             elig = false; break; -- 30 sec lockout once they leave
	   else
	     info.delay = math.max(info.delay, (expires - now), 0.5)    
	   end
	 end
	 expires = select(7,UnitBuff(unit, spellnames.buffed))
	 if expires and info.role == "DAMAGER" then
	   debug(name.." HAS BUFF")
	   info.delay = math.max(info.delay, (expires - now), 0)    
	 end
	 if addon.raiddiff == "heroic" then
	   expires = select(7,UnitDebuff(unit, spellnames.frail))
	   if expires then
	     local fraildelay = expires - now
	     if fraildelay < 0 then -- got a bogus expiration, assume the worst
	        fraildelay = 30
	     end
	     debug(name.." IS FRAIL "..fraildelay)
	     info.delay = math.max(info.delay, fraildelay)    
	     if (info.role == "HEALER"  and fraildelay > settings.healerdelay) or
	        (info.role == "DAMAGER" and fraildelay > settings.dpsdelay) then
		elig = false; break;
             end
	   end
	 end
         debug("Elig "..(info.role or "nil")..": "..(name or "nil").."  delay="..(info.delay or "nil").." lastaction="..(info.lastaction or 0))
         table.insert(list,info)
	 break;
       end -- fake loop
    end -- unit alive
  end  -- raid members
  table.sort(healerElig, playerSort)
  table.sort(dpsElig, playerSort)
  local sendcount = settings.sendcount[addon.raidsize][addon.raiddiff]
  local healercnt = sendcount.healers
  local dpscnt = sendcount.dps
  local rtmod = 6
  if addon.raidsize > 10 then
    rtmod = 8
  end
  local playersChosen = predict or {}
  for i=1,healercnt do
    local info = healerElig[i]
    if info then
      info.tempheal = nil
      table.insert(playersChosen, info)
    elseif not predict then
      if addon:shouldAnnounce() or settings.debug then
        chatMsg(L["WARNING: Not enough eligible healers!"])
      end
      if settings.hybrid then
        local maxmana = 0
	local maxidx
        for idx, info in ipairs(dpsElig) do
	  local unit = info.unit
	  local mana = UnitPower(unit, SPELL_POWER_MANA) or 0
	  if info.hybrid and mana > maxmana 
	     and not select(7,UnitDebuff(unit, spellnames.crossed)) 
	     and not select(7,UnitDebuff(unit, spellnames.frail)) then
	    maxidx = idx
	    maxmana = mana
	  end
	end
	if maxidx then
	  local info = dpsElig[maxidx]
          info.tempheal = true
          table.insert(playersChosen, info)
	  table.remove(dpsElig, maxidx)
	end
      end
    end
  end
  for i=1,dpscnt do
    local info = dpsElig[i]
    if info then
      info.tempheal = nil
      table.insert(playersChosen, info)
    elseif not predict then
      if addon:shouldAnnounce() or settings.debug then
        chatMsg(L["WARNING: Not enough eligible dps!"])
      end
    end
  end
  if predict then return end
  addon:ScheduleTimer(timerTotem, totemInterval+2)
  addon.lastChosen = playersChosen
  local msg = L["Spirit Totem"].." " .. addon.totemcount..":"
  local delay = 0
  addon.rt = addon.rt or 0
  for idx,info in ipairs(playersChosen) do
    delay = math.max(delay, info.delay)
    info.lastaction = now
    local rt = addon.rt + 1
    addon.rt = (addon.rt + 1) % rtmod
    msg = msg .. " "
    if settings.raidicons then
      if addon:shouldAnnounce() then
        SetRaidTarget(info.unit, rt)
      end
      msg = msg .. "{rt"..rt.."}"     
    else
      local rtcurr = GetRaidTargetIndex(info.unit)
      if rtcurr and rtcurr > 0 then -- announce existing icon
        msg = msg .. "{rt"..rtcurr.."}"
      end
    end
    msg = msg .. info.name
    if info.text and #info.text > 0 then
      msg = msg .. "("..info.text..")"
    end
    local hybridmsg = ""
    if info.tempheal then
      msg = msg .. " ("..L["BACKUP HEAL"]..") "
      hybridmsg = " "..L["BACKUP HEAL"].."!!!"
    end
    if addon:shouldAnnounce() and settings.whisper then
      SendChatMessage(info.name .. " ".. L["Run to the totem!!!"]..hybridmsg, "WHISPER", nil, info.name)
    end
  end
  if delay > 1 then
    msg = msg .. " ("..L["DELAY"].." "..string.format("%.1f",delay)..")"
  end
  debug(msg)
  if addon:shouldAnnounce() and settings.raidwarning then
    SendChatMessage(msg, "RAID_WARNING")
  end
  if addon:shouldAnnounce() and settings.self then
    chatMsg(msg)
  end
end

function addon:PLAYER_REGEN_DISABLED() -- entering combat
  addon:CheckEnable() -- should be unnecessary, safety check to ensure we're not enabled out of zone
  addon.totemcount = 0
  addon.lasttotem = 0
  addon.welcome = false
  addon.suppress = false
  addon.delaytotem = nil
  addon.zone = GetRealZoneText()
  addon:CancelAllTimers()
end

function addon:CHAT_MSG_ADDON(event, prefix, message, channel, sender)
  if prefix == "D4" and message and channel == "RAID" then -- DBM message
    --debug("CHAT_MSG_ADDON: (D4) "..message)
    local mtype, mod, rev, evt, arg = strsplit("\t", message)
    if mtype == "M" and mod == "682" and evt == "SummonTotem" then -- from Gara'jal mod
      --debug("Snooped a DBM SummonTotem event")
      addon:handleTotem()
    end
    return
  elseif prefix ~= addonName then return end
  debug("CHAT_MSG_ADDON: "..prefix..":"..message..":"..channel..":"..sender)
  if UnitIsUnit(sender, "player") then return end
  local srev = message:match("^ENGAGE %[(%d+)%]")
  srev = tonumber(srev or 0) or 0
  debug("Got engage message v"..srev)
  if UnitIsGroupLeader(sender) or (not UnitIsGroupLeader("player") and
     (srev > addon.revision or (srev == addon.revision and sender < UnitName("player")))) then -- prefer the leader or newest version
    chatMsg(L["Addon temporarily disabled in favor of"].." "..sender)
    addon.suppress = true
  end
end

function addon:UNIT_AURA(event, unit) -- detect actual cross-overs
  if (addon.lasttotem == 0) and (not addon.welcome) and UnitDebuff(unit, spellnames.voodoo) then
    addon.welcome = true
    debug("Detected boss pull")
    if addon:shouldAnnounce() then
      SendAddonMessage(addonName, "ENGAGE ["..addon.revision.."]", "RAID")
      addon:ScheduleTimer(function()
        if not addon.suppress then
          SendChatMessage("<"..addonName.."> "..L["Boss engaged: Addon activated. Good luck!"], "RAID")
          if settings.raidicons and addon:shouldAnnounce() then
            addon:ClearIcons()
          end
        end
      end, 2)
    end
  end
  local expires = select(7,UnitDebuff(unit, spellnames.crossed))
  if expires then -- has crossed aura
    local now = GetTime()
    if expires > now + 25 then -- just crossed
       addon.lastcrossed = now
       local name = UnitToName(unit)
       local info = players[name]
       if info then
          info.crossed = true
          info.lastaction = now
       end
    end
  end
  local buffed, _,_,_,_,_,_, val1,val2,val3 = select(7,UnitBuff(unit, spellnames.buffed))
  -- val1 is the MPS buff for heals
  -- val3 is the dmg percent for the dps buff
  if buffed then -- has the buff
     if settings.raidicons and GetRaidTargetIndex(unit) and addon:shouldAnnounce() then
       SetRaidTarget(unit, 0) -- got buffed, remove icon
     end
     if not expires then -- in normal phase
       local name = UnitToName(unit)
       local info = players[name]
       if info and info.crossed then -- just returned
         info.crossed = nil
	 debug(name.." buff vals: "..tostring(val1)..":"..tostring(val2)..":"..tostring(val3))
	 if settings.reportbuff and (addon:shouldAnnounce() or settings.debug) then
	   local buffidx 
	   for i=1,40 do -- searching on name here because there are multiple spellids (at least dps and heals)
	     local spellname = UnitBuff(unit, i)
	     if not spellname then
	       break
	     elseif spellname == spellnames.buffed then
	       buffidx = i
	       break
	     end
	   end
	   if not buffidx then
	     debug("Failed to find buffidx!!!")
	   else
	     local pct,mps
	     addon.scantt:ClearLines()
	     addon.scantt:SetOwner(UIParent, "ANCHOR_NONE")
	     addon.scantt:SetUnitBuff(unit,buffidx)
	     for i=1,addon.scantt:NumLines() do
	       local line = getglobal(addon.scantt:GetName() .. "TextLeft"..i)
	       local text = (line and line:GetText()) or ""
	       local p = text:match("%s(%d+)%%")
	       if p and p ~= "0" then pct = p end -- deliberately take the last to avoid fixed size %
	       p = text:match("%s(%d+)%s"..MANA)
	       if p and p ~= "0" then mps = p end
	     end
	     if pct or mps then
	       local val = (mps and mps.." "..L["Mana per second"]) or (pct and pct.."%") or "?"
	       local duration = ""
	       if buffed > 0 then -- sometimes expiration time is missing
	          duration = " ".. AUCTION_DURATION..": "..string.format("%.1f",(buffed - GetTime())).." "..L["Sec"]
	       end
	       local msg = spellnames.buffed..": "..name.." "..val..duration
	       debug(msg)
	       if addon:shouldAnnounce() then
	         SendChatMessage(msg, "RAID")
	       end
	     else
	       debug("Failed to scan buff tt!!")
	     end
	   end
	 end
       end
     end
  end
end

function addon:UNIT_PHASE(event, unit) 
  --debug("UNIT_PHASE: "..strjoin(",",...))
  if unit and UnitExists(unit) then
    addon:UNIT_AURA(event, unit)
  end
end

function addon:COMBAT_LOG_EVENT_UNFILTERED(...)
  local event,_,_,_,_,_,_,_,_,_,id = ...
  if event == "SPELL_CAST_SUCCESS" and id == spellids.totem then
    addon:handleTotem()
  end
end

function addon:UNIT_SPELLCAST_SUCCEEDED(event, unitid, spellName, _, _, spellID)
  if spellID == spellids.totem then
    addon:handleTotem()
  elseif spellID == spellids.banish then -- tank is banished, voodoo change imminent
    debug("Banishment")
    local now = GetTime()
    if now < ((addon.lasttotem or 0) + 10) and -- recently announced a totem
       (addon.lastcrossed or 0) < (addon.lasttotem or 0) then -- haven't killed totem yet
       local msg = L["WARNING: Voodoo Doll about to change! Totem assignment might be invalidated!"]
       debug(msg)
       if addon:shouldAnnounce() and settings.raidwarning then
         SendChatMessage(msg, "RAID_WARNING")
       end
       if addon:shouldAnnounce() and settings.self then
         chatMsg(msg)
       end
    end
  end 
end

addon.scantt = CreateFrame("GameTooltip", addonName.."_ScanTooltip", UIParent, "GameTooltipTemplate")
addon.scantt:SetOwner(UIParent, "ANCHOR_NONE");

function addon:BuildOptions() 
addon.options = {
  type = "group",
  set = function(info,val)
          local s = settings ; for i = 2,#info-1 do s = s[info[i]] end
          s[info[#info]] = val; debug(info[#info].." set to: "..tostring(val))
          addon:Update()
        end,
  get = function(info)
          local s = settings ; for i = 2,#info-1 do s = s[info[i]] end
          return s[info[#info]] end,
  args = {
   general = {
    type = "group",
    inline = true,
    name = L["General"],
    args = {
      debug = {
        name = L["Debug"],
        desc = L["Toggle debugging output"],
        type = "toggle",
        guiHidden = true,
      },
      test = {
        name = "Test",
        desc = "Totem test",
        type = "execute",
        guiHidden = true,
        cmdHidden = true,
        func = function() 
	  addon.dryrun = true
	  if not addon.scanned then addon:ScanRaid(); end; 
	  addon:handleTotem() 
	  addon.dryrun = false
	end,
      },
      clear = {
        name = "Clear",
        desc = "Clear test",
        type = "execute",
        guiHidden = true,
        cmdHidden = true,
        func = function() addon:ClearIcons(); addon:ScanRaid(); end,
      },
      config = {
        name = L["Config"],
        desc = L["Open the configuration GUI"],
        type = "execute",
        guiHidden = true,
        func = function() addon:Config() end,
      },
      -- -----------------------------------------------------------------------------------------------
      version = {
        order = 1,
	type = "description",
        fontSize = "medium",
	name = L["Version"].." "..addon.version.."\n",
      },
        
      minimap = {
        order = 15,
        name = L["Minimap Icon"],
        desc = L["Display minimap icon"],
        type = "toggle",
        set = function(info,val)
          settings.minimap.hide = not val
          addon:Update()
	end,
        get = function() return not settings.minimap.hide end,
      },
      enable = {
        order = 50,
	name = L["Enable"],
	desc = L["Enable the addon"],
        type = "toggle",
      },
      enablelfr = {
        order = 50,
	name = L["Enable in LFR"],
	desc = L["Enable the addon in Looking For Raid difficulty"],
        type = "toggle",
	disabled = function() return not settings.enable end,
      },
      -- -----------------------------------------------------------------------------------------------
      aheader = {
        name = L["Announcement Options"],
        type = "header",
        cmdHidden = true,
        order = 99,
      },
      announcewarn = {
        order = 99.9,
	type = "description",
        fontSize = "medium",
	name = function() 
	  if addon:canAnnounce() then
	    return ""
	  else
	    return "\124cffff0000".. L["You must have raid lead or assist to make annoucements."].."\124r"
	  end
	end,
      },
      raidwarning = {
        order = 100,
        name = L["Raid Warning"],
        desc = L["Send a raid warning listing selected players"],
        type = "toggle",
	disabled = function() return not addon:EnabledDiff() end,
      },
      whisper = {
        order = 110,
        name = L["Whisper"],
        desc = L["Whisper selected players"],
        type = "toggle",
	disabled = function() return not addon:EnabledDiff() end,
      },
      raidicons = {
        order = 120,
        name = L["Raid Icons"],
        desc = L["Set raid icons on selected players"],
        type = "toggle",
	disabled = function() return not addon:EnabledDiff() end,
      },
      self = {
        order = 130,
        name = L["Self"],
        desc = L["Output to self listing selected players"],
        type = "toggle",
	disabled = function() return not addon:EnabledDiff() end,
      },
      reportbuff = {
        order = 140,
	name = L["Report Buff"],
	desc = L["Report magnitude of Spiritual Innervation buff for each player returning from spirit phase"],
	type = "toggle",
	disabled = function() return not addon:EnabledDiff() end,
      },
      -- -----------------------------------------------------------------------------------------------
      rheader = {
        name = L["Raid"],
        type = "header",
        cmdHidden = true,
        order = 199,
      },
      rolecheck = {
        order = 200,
        name = L["Role Check"],
        desc = L["Start a Raid Role Check"],
        type = "execute",
	disabled = function() return not addon:canAnnounce() end,
        func = function() InitiateRolePoll() end,
      },
      refresh = {
        order = 205,
        name = L["Refresh"],
        desc = L["Refresh this display"],
        type = "execute",
        func = function() addon:RefreshConfigPanel() end,
        cmdHidden = true,
      },
      reset = {
        order = 209,
        name = L["Reset"],
        desc = L["Reset player settings"],
        type = "execute",
        func = function() addon:ScanRaid(true); addon:RefreshConfigPanel() end,
      },
      rolecheckwarn = {
        order = 210,
	type = "description",
        fontSize = "medium",
	name = function() 
	  if addon.missingroles and addon.missingroles > 0 then 
	    return string.format("\124cffff0000"..L["WARNING: %d players do not have roles assigned and will be ignored."].."\124r",addon.missingroles)
	  else
	    return ""
	  end
	end,
      },
      -- -----------------------------------------------------------------------------------------------
      healer = {
        order = 300,
        name = function() -- this filthy hack is brought to you by the overly restrictive AceConfig group API
          addon.options.args.general.args.healer.args = addon:playerconfig(true)
          return L["Healers"] 
        end,
        --inline = true,
        type = "group",
        args = {},
      },
      -- -----------------------------------------------------------------------------------------------
      dps = {
        order = 310,
        name = function() -- this filthy hack is brought to you by the overly restrictive AceConfig group API
          addon.options.args.general.args.dps.args = addon:playerconfig(false)
          return L["DPS"] 
        end,
        --inline = true,
        type = "group",
        args = {},
      },
      -- -----------------------------------------------------------------------------------------------
      sendcount = {
        order = 400,
	type = "group",
	name = L["Assignment Mix"],
	args = {
	  ["10normal"] = addon:sendcountconfig(10, "normal", RAID_DIFFICULTY1),
	  ["10heroic"] = addon:sendcountconfig(10, "heroic", RAID_DIFFICULTY3),
	  ["25normal"] = addon:sendcountconfig(25, "normal", RAID_DIFFICULTY2),
	  ["25heroic"] = addon:sendcountconfig(25, "heroic", RAID_DIFFICULTY4),
	  ["25lfr"]    = addon:sendcountconfig(25, "lfr",    L["Looking for Raid"]),
	},
      },
      -- -----------------------------------------------------------------------------------------------
    },
  }
 }
} 
end

function addon:sendcountconfig(size, diff, label) 
  local ret = {
    type = "group",
    name = label,
    args = {
      healers = addon:roleconfig(L["Healers per totem"], "healers", "dps", size, diff),
      dps =     addon:roleconfig(L["Dps per totem"], "dps", "healers", size, diff),
    },
  }
  return ret
end

function addon:roleconfig(label, role, orole, size, diff)
  local entry = size..diff
  local max = 5
  if size == 10 then
    max = 3
  elseif diff == "lfr" then
    max = 20
  end
  local ret = {
    type = "range",
    name = label,
    order = (role == "dps" and 10 or 20),
    min = 0,
    max = max,
    step = 1,
    bigStep = 1,
    get = function(info) return settings.sendcount[size][diff][role] end,
    set = function(info,val) 
      settings.sendcount[size][diff][role] = val
      local oval = settings.sendcount[size][diff][orole]
      oval = math.min(oval, max-val)
      settings.sendcount[size][diff][orole] = oval
      addon:RefreshConfigPanel()
    end,
  }
  return ret
end

function addon:playerconfig(healer)
  local ret = {
  --[[
      list = {
            order = 100,
            type = "group",
	    inline = false,
	    childGroups = "tree",
            name = PLAYER,
            args = { },
      },
      --]]
  }
  if healer then
    ret.mana = {
       	order = 50,
	name = L["Prioritize by mana"],
	desc = L["Prioritize eligible healers with lowest mana"],
        type = "toggle",
	width = "full",
  	set = function(info,val)
	  settings.healermana = val
          debug("healermana set to: "..tostring(val))
          addon:Update()
        end,
        get = function(info) return settings.healermana end,
    }
    ret.hybrid = {
       	order = 100,
	name = L["Use Hybrid Healers"],
	desc = L["Assign a hybrid dps to backup heal in the spirit realm when all dedicated healers are unavailable (Crossed Over or Frail Soul)."].."\n"..
	       L["Hybrid healers are assigned from the eligible dps and prioritized by highest current mana (value not percent)."],
        type = "toggle",
	width = "full",
  	set = function(info,val)
	  settings.hybrid = val
          debug("hybrid set to: "..tostring(val))
          addon:Update()
        end,
        get = function(info) return settings.hybrid end,
    }
    ret.healerdelay = {
    	order = 150,
    	type = "range",
    	name = L["Max Healer Delay"],
	desc = L["Max seconds on Frail Soul debuff before considering player unavailable for current totem"],
    	min = 0,
    	max = 15,
    	step = 0.25,
    	bigStep = 1,
    	get = function(info) return settings.healerdelay end,
    	set = function(info,val) settings.healerdelay = val end,
    }
  else
    ret.healerdelay = {
    	order = 150,
    	type = "range",
    	name = L["Max Dps Delay"],
	desc = L["Max seconds on Frail Soul debuff before considering player unavailable for current totem"],
    	min = 0,
    	max = 15,
    	step = 0.25,
    	bigStep = 1,
    	get = function(info) return settings.dpsdelay end,
    	set = function(info,val) settings.dpsdelay = val end,
    }
  end
  for name,info in pairs(players) do
    if info.unit and 
       ((healer and (info.role == "HEALER")) or 
        (not healer and (info.role == "DAMAGER"))) then
      local order = info.order + 10000
      local suffix = ""
      if healer and settings.healermana then
          -- nothing
      elseif info.priority == 1 then
          order = order - 10000;
          suffix = " ("..L["High Priority"]..")"
      elseif info.priority == 3 then
          order = order + 10000;
          suffix = " ("..L["Backup"]..")"
      end
      local cname = name
      local class = select(2,UnitClass(info.unit))
      local cstr = class and RAID_CLASS_COLORS[class] and RAID_CLASS_COLORS[class].colorStr
      if cstr then
        cname = "\124c"..cstr..name.."\124r"
      end
      ret[name] = {
          order = order,
          type = "group",
          name = cname..suffix,
	  args = {
            priority = {
	      order = 100,
	      name = L["Priority Group"]..": "..name,
	      type = "select",
	      values = { [1] = L["High Priority"], [2] = L["Default"], [3] = L["Backup"] },
	      set = function(i,val) info.priority = val; addon:RefreshConfigPanel() end,
	      get = function(i) return info.priority end,
	      disabled = healer and settings.healermana,
            },
	    prioritydesc = {
	      order = 110,
	      type = "description",
              fontSize = "medium",
	      name = L["High priority players are assigned to the totem whenever possible. Backup players are only sent when no others are available."],
	    },
	    orderheader = {
	      order = 200,
	      name = L["Initial order within priority"],
	      type = "header",
	    },
	    orderdesc = {
	      order = 205,
	      type = "description",
              fontSize = "medium",
	      name = L["Ordering within a priority group defines the approximate rotation in which players are considered for totem assignment, subject to debuff constraints."],
	    },
	    orderup = {
	      order = 210,
	      type = "execute",
	      name = L["Up"],
	      disabled = (healer and settings.healermana) or not addon:orderpeer(info,true),
	      func = function() addon:orderswap(info,true); addon:RefreshConfigPanel() end,
	    },
	    orderdown = {
	      order = 220,
	      type = "execute",
	      name = L["Down"],
	      disabled = (healer and settings.healermana) or not addon:orderpeer(info,false),
	      func = function() addon:orderswap(info,false); addon:RefreshConfigPanel() end,
	    },
	    mheader = {
	      order = 299,
	      name = L["Misc Settings"],
	      type = "header",
	    },
	    text = {
	      order = 350,
	      type = "input",
	      name = L["Player Text"],
              desc = L["Optional text to announce with this player when he is assigned to a totem, eg healing assignment"],
	      get = function(i) return info.text end,
	      set = function(i,val) info.text = val; addon:RefreshConfigPanel() end,
	    },
          },
      }
      if not healer then
        ret[name].args.hybrid = {
	  order = 310,
	  type = "toggle",
	  width = "full",
	  name = L["Hybrid Healer"],
	  desc = L["Allow this player to be assigned as a backup healer when no dedicated healer is available"],
	  get = function(i) return info.hybrid end,
	  set = function(i,val) info.hybrid = not not val; addon:RefreshConfigPanel() end,
	  disabled = not info.hybrid_default,
        } 
      end
    end
  end
  return ret
end

function addon:orderpeer(info, up) -- return the closest ordered peer in raid in the given direction within same priority group
  local peer = nil
  for _,pi in pairs(players) do
    if pi ~= info and pi.unit and pi.priority == info.priority and pi.role == info.role then
      if (up     and pi.order < info.order and (not peer or pi.order > peer.order)) or 
         (not up and pi.order > info.order and (not peer or pi.order < peer.order)) then
	   peer = pi
      end
    end
  end
  return peer
end

function addon:orderswap(info, up) -- swap order with the closest peer in raid in the given direction
  local peer = addon:orderpeer(info, up)
  if not peer then return end
  local tmp = peer.order
  peer.order = info.order
  info.order = tmp
end

local function table_clone(t)
  if not t then return nil
  elseif type(t) == "table" then
    local res = {}
    for k,v in pairs(t) do
      res[table_clone(k)] = table_clone(v)
    end
    return res
  else
    return t
  end
end

function addon:RefreshConfig()
  -- things to do after load or settings are reset
  debug("RefreshConfig")
  settings = addon.db.profile
  addon.settings = settings
  charName = UnitName("player")
  for k,v in pairs(defaults.profile) do
     if settings[k] == nil then
       settings[k] = table_clone(v)
     end
  end
  players = settings.players
  addon.players = players
  settings.loaded = true
  addon:Update()
end

function addon:Update()
  -- things to do when settings change
  if LDBo then
    if settings.minimap.hide then
      minimapIcon:Hide(addonName)
    else
      minimapIcon:Show(addonName)
    end
  end
  addon:CheckEnable()
end

function addon:SetupVersion()
   local svnrev = 0
   local files = vars.svnrev
   files["X-Build"] = tonumber((GetAddOnMetadata(addonName, "X-Build") or ""):match("%d+"))
   files["X-Revision"] = tonumber((GetAddOnMetadata(addonName, "X-Revision") or ""):match("%d+"))
   for _,v in pairs(files) do -- determine highest file revision
     if v and v > svnrev then
       svnrev = v
     end
   end
   addon.revision = svnrev

   files["X-Curse-Packaged-Version"] = GetAddOnMetadata(addonName, "X-Curse-Packaged-Version")
   files["Version"] = GetAddOnMetadata(addonName, "Version")
   addon.version = files["X-Curse-Packaged-Version"] or files["Version"] or "@"
   if string.find(addon.version, "@") then -- dev copy uses "@.project-version.@"
      addon.version = "r"..svnrev
   end
end


function addon:OnInitialize()
  addon:SetupVersion()
  addon.db = LibStub("AceDB-3.0"):New("GarajalAnnounceDB", defaults)
  addon:RefreshConfig()
  addon:BuildOptions()
  LibStub("AceEvent-3.0"):Embed(addon)
  LibStub("AceConfigRegistry-3.0"):ValidateOptionsTable(addon.options, addonName)
  LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, addon.options, {"garajalannounce", "ga"})
  optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName, addonName, nil, "general")
  optionsFrame.default = function()
       for k,v in pairs(defaults.profile) do settings[k] = table_clone(v) end
       addon:RefreshConfig()
       if InterfaceOptionsFrame:IsShown() then
         addon:Config(); addon:Config()
       end
  end
  addon.options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(addon.db)
  LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName, L["Profiles"], addonName, "profiles")

  debug("OnInitialize")

  self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
  self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
  self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
  self.db.RegisterCallback(self, "OnDatabaseReset", "RefreshConfig")
  addon:InitNames()
  addon.init = true
end

function addon:Config()
  addon:ScanRaid()
  if optionsFrame then
    if ( InterfaceOptionsFrame:IsShown() ) then
      InterfaceOptionsFrame:Hide();
    else
      InterfaceOptionsFrame_OpenToCategory(optionsFrame)
    end
  end
end

function addon:RefreshConfigPanel()
  addon:ScanRaid()
  if optionsFrame then
    if ( InterfaceOptionsFrame:IsShown() ) then
      InterfaceOptionsFrame:Hide();
      InterfaceOptionsFrame_OpenToCategory(optionsFrame)
    end
  end
end

function addon:OnEnable()
  debug("OnEnable")
  self:RegisterEvent("GROUP_ROSTER_UPDATE", "CheckEnable")
  self:RegisterEvent("ZONE_CHANGED","CheckEnable")
  self:RegisterEvent("ZONE_CHANGED_INDOORS","CheckEnable")
  self:RegisterEvent("ZONE_CHANGED_NEW_AREA","CheckEnable")
  self:RegisterEvent("CHAT_MSG_ADDON")
  RegisterAddonMessagePrefix(addonName)
  RegisterAddonMessagePrefix("D4") -- snoop DBM messages
 
  if LDB then
    return
  end
  if AceLibrary and AceLibrary:HasInstance("LibDataBroker-1.1") then
    LDB = AceLibrary("LibDataBroker-1.1")
  elseif LibStub then
    LDB = LibStub:GetLibrary("LibDataBroker-1.1",true)
  end
  if LDB then
    LDBo = LDB:NewDataObject(addonName, {
        type = "launcher",
        label = addonName,
        icon = "Interface\\Icons\\spell_nature_agitatingtotem",
        OnClick = function(self, button)
                if button == "RightButton" then
                        addon:Config()
                else
                        addon:Config()
                end
        end,
        OnTooltipShow = function(tooltip)
                if tooltip and tooltip.AddLine then
                        tooltip:SetText(addonName)
                        --tooltip:AddLine("|cffff8040"..L["Left Click"].."|r "..L["to toggle status window"])
                        tooltip:AddLine("|cffff8040"..L["Right Click"].."|r "..L["for options"])
                        tooltip:Show()
                end
        end,
     })
  end 

  if LDBo then
    minimapIcon:Register(addonName, LDBo, settings.minimap)
  end
  addon:Update()
end

StaticPopupDialogs["GARAJALANNOUNCE_ROLEPOLL"] = {
  preferredIndex = 3, -- reduce the chance of UI taint
  text = string.format(L["%s requires raid members to have roles assigned. Would you like to run a Role Check now?"],addonName),
  button1 = YES,
  button2 = NO,
  OnAccept = function () InitiateRolePoll() end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  showAlert = true,
  enterClicksFirstButton = true,
}

