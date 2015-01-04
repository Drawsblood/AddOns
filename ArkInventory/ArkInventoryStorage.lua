local _G = _G
local select = _G.select
local pairs = _G.pairs
local ipairs = _G.ipairs
local string = _G.string
local type = _G.type
local error = _G.error
local table = _G.table

local ArkInventoryScanCleanupList = { }

function ArkInventory.EraseSavedData( player_id, loc_id, silent )

	-- /run ArkInventory.EraseSavedData( )
	
	--ArkInventory.Output( "EraseSavedData( ", player_id, ", ", loc_id, ", ", silent, " )" )
	
	local rescan
	
	-- erase item/tooltip cache
	ArkInventory.Table.Clean( ArkInventory.Global.Cache.ItemCountTooltip, nil, true )
	ArkInventory.Table.Clean( ArkInventory.Global.Cache.ItemCountRaw, nil, true )
	ArkInventory.Table.Clean( ArkInventory.Global.Cache.ItemCount, nil, true )
	
	-- erase data
	for pk, pv in pairs( ArkInventory.db.global.player.data ) do
		
		if ( not player_id ) or ( pk == player_id ) then
			
			for lk, lv in pairs( pv.location ) do
				
				if ( loc_id == nil ) or ( lk == loc_id ) then
					
					ArkInventory.Frame_Main_Hide( lk )
					
					lv.slot_count = 0
					
					for bk, bv in pairs( lv.bag ) do
						ArkInventory.Table.Clean( bv )
						bv.status = ArkInventory.Const.Bag.Status.Unknown
						bv.type = ArkInventory.Const.Slot.Type.Unknown
						bv.count = 0
						bv.empty = 0
						table.wipe( bv.slot )
					end
					
					ArkInventory.Frame_Main_DrawStatus( lk, ArkInventory.Const.Window.Draw.Recalculate )
					if ArkInventory.Global.Location[lk] and not silent then
						ArkInventory.Output( "Saved ", string.lower( ArkInventory.Global.Location[lk].Name ), " data for ", pk, " has been erased" )
					end
					
				end
				
			end
			
			if pk == ArkInventory.Global.Me.info.player_id then
				rescan = true
			else
				if ( loc_id == nil ) or ( ( loc_id == ArkInventory.Const.Location.Vault ) and ( pv.info.class == "GUILD" ) ) then
					table.wipe( pv.info )
				end
			end
			
		end
		
	end
	
	if rescan then
		-- current player was wiped, need to rescan
		ArkInventory.PlayerInfoSet( )
		ArkInventory.ScanLocation( )
	end
	
end

function ArkInventory.Table.Sum( tbl, fcn )
	local r = 0
	for k, v in pairs( tbl ) do
		r = r + ( fcn( v ) or 0 )
	end
	return r
end

function ArkInventory.Table.Max( tbl, fcn )
	local r = nil
	for k, v in pairs( tbl ) do
		if not r then
			r = ( fcn( v ) or 0 )
		else
			if ( fcn( v ) or 0 ) > r then
				r = ( fcn( v ) or 0 )
			end
		end
	end
	return r
end

function ArkInventory.Table.Elements( tbl )
	-- #table only returns the number of elements where the table keys are numeric and does not take into account missing values
	if tbl and type( tbl ) == "table" then
		local r = 0
		for _ in pairs( tbl ) do
			r = r + 1
		end
		return r
	end
end

function ArkInventory.Table.IsEmpty( tbl )
	-- #table only returns the number of elements where the table keys are numeric and does not take into account missing values
	if tbl and type( tbl ) == "table" then
		for _ in pairs( tbl ) do
			return false
		end
		return true
	end
end

function ArkInventory.Table.Clean( tbl, key, nilsubtables )

	-- tbl = table to be cleaned

	-- key = a specific key you want cleaned (nil for all keys)

	-- nilsubtables (true) = if a value is a table then nil it as well
	-- nilsubtables (false) = if a value is a table then leave the skeleton there
	
	if type( tbl ) ~= "table" then
		return
	end
	
	for k, v in pairs( tbl ) do
		
		if key == nil or key == k then
		
			if type( v ) == "table" then
				
				ArkInventory.Table.Clean( v, nil, nilsubtables )
				
				if nilsubtables then
					--ArkInventory.Output( "erasing subtable ", k )
					tbl[k] = nil
				end
				
			else
				
				--ArkInventory.Output( "erasing value ", k )
				tbl[k] = nil

			end
			
		end
		
	end

end

local function spairs_iter( a )
	a.idx = a.idx + 1
	local k = a[a.idx]
	if k ~= nil then
		return k, a.tbl[k]
	end
	--table.wipe( a )
	a.tbl = nil
end

function ArkInventory.spairs( tbl, cf )
	
	if type( tbl ) ~= "table" then return end
	
	local a = { }
	local c = 0
	
	for k in pairs( tbl ) do
		c = c + 1
		a[c] = k
	end
	
	table.sort( a, cf )
	
	a.idx = 0
	a.tbl = tbl
	
	return spairs_iter, a
	
end

function ArkInventory.PlayerInfoSet( )
	
	-- /run ArkInventory.Output( ArkInventory.Global.Me.info )
	
	--ArkInventory.Output( "PlayerInfoSet" )
	
	local n = UnitName( "player" )
	local r = GetRealmName( )
	
	local id = string.format( "%s%s%s", n, ArkInventory.Const.PlayerIDTag, r )
	ArkInventory.Global.Me = ArkInventory.db.global.player.data[id]
	
	local p = ArkInventory.Global.Me.info
	
	p.name = n
	p.realm = r
	p.player_id = id
	p.faction, p.faction_local = UnitFactionGroup( "player" )
	
	if p.faction_local == "" then
		p.faction_local = FACTION_STANDING_LABEL4
	end
	
	-- WARNING, most of this stuff is not available upon first login, even when the mod gets to OnEnabled (ui reloads are fine), and some are not available on logout
	
	p.class_local, p.class = UnitClass( "player" )
	p.level = UnitLevel( "player" )
	p.race_local, p.race = UnitRace( "player" )
	p.gender = UnitSex( "player" )
	
	local m = GetMoney( )
	if m > 0 then  -- returns 0 on logout so dont wipe the current value
		p.money = m
	end
	
--[[
	if p.class == "WARLOCK" then
		ArkInventory.db.global.option.tracking.items[6265] = true
	end
]]--	
	
	-- ACCOUNT
	local id = ArkInventory.PlayerIDAccount( )
	local ac = ArkInventory.db.global.player.data[id].info
	
	ac.name = "Account"
	ac.realm = p.realm
	ac.player_id = id
	ac.faction = p.faction
	ac.faction_local = p.faction_local
	ac.class = "ACCOUNT"
	ac.class_local = "Account"
	ac.level = ac.level or 1
	
	-- VAULT
	if not ArkInventory.LocationIsMonitored( ArkInventory.Const.Location.Vault ) then
		
		p.guild_id = nil
		
	else
		
		local gn, _, _, grealm = GetGuildInfo( "player" )
		--ArkInventory.Output( "IsInGuild=[", IsInGuild( ), "], g=[", gn, "], r=[", grealm, "]" )
		
		if not gn then
			
			if IsInGuild( ) then
				--ArkInventory.OutputWarning( "you are in a guild but no guild name was found, using previous data" )
			else
				p.guild_id = nil
			end
			
		else
			
			p.guild_id = string.format( "%s%s%s%s", ArkInventory.Const.GuildTag, gn, ArkInventory.Const.PlayerIDTag, grealm or r )
			
		end
		
	end
	
	return p
	
end

function ArkInventory.VaultInfoSet( )
	
	local n, _, _, r = GetGuildInfo( "player" )
	local cp = ArkInventory.Global.Me.info
	
	if n then
		
		local id = string.format( "%s%s%s%s", ArkInventory.Const.GuildTag, n, ArkInventory.Const.PlayerIDTag, r or cp.realm )
		
		local g = ArkInventory.db.global.player.data[id].info
		
		g.name = n
		g.realm = r or cp.realm
		g.player_id = id
		g.faction = cp.faction
		g.faction_local = cp.faction_local
		g.class = "GUILD"
		g.class_local = GUILD
		
		g.guild_id = id
		g.level = 1 --GetGuildLevel( )
		g.money = GetGuildBankMoney( ) or 0
		
		cp.guild_id = id
		
	else
		
		cp.guild_id = nil
		
	end
	
end

function ArkInventory.PlayerInfoGet( id )
	
	if id == nil then
		return
	end
	
	return ArkInventory.db.global.player.data[id]
	
end

function ArkInventory.PlayerIDAccount( )
	local a = "!ACCOUNT"
	return string.format( "%s%s%s", a, ArkInventory.Const.PlayerIDTag, a )
end

function ArkInventory:LISTEN_STORAGE_EVENT( msg, arg1, arg2, arg3, arg4 )
	
	--ArkInventory.Output( "LISTEN_STORAGE_EVENT( ", arg1, ", ", arg2, ", ", arg3, ", ", arg4, " )" )
	
	if arg1 == ArkInventory.Const.Event.BagUpdate then
		
		--ArkInventory.Output( "BAG_UPDATE( ", arg2, ", [", arg4, "] )" )
		ArkInventory.Frame_Main_Generate( arg2, arg4 )
		
	else
		
		error( string.format( "code failure: unknown storage event [%s]", arg1 ) )
		
	end
	
end


function ArkInventory:LISTEN_PLAYER_ENTER( )

	--ArkInventory.Output( "LISTEN_PLAYER_ENTER" )
	
	ArkInventory.PlayerInfoSet( )
	
end

function ArkInventory:LISTEN_PLAYER_LEAVE( )

	--ArkInventory.Output( "LISTEN_PLAYER_LEAVE" )
	
	ArkInventory.Frame_Main_Hide( )
	
	ArkInventory.PlayerInfoSet( )
	
	ArkInventory.ScanAuctionExpire( )
	
	for loc_id in pairs( ArkInventory.Global.Location ) do
		if not ArkInventory.LocationIsSaved( loc_id ) then
			ArkInventory.EraseSavedData( ArkInventory.Global.Me.info.player_id, loc_id, true )
		end
	end
	
end

function ArkInventory:LISTEN_PLAYER_MONEY( )

	--ArkInventory.Output( "PLAYER_MONEY" )

	ArkInventory.PlayerInfoSet( )
	
	-- set saved money amount here as well
	ArkInventory.Global.Me.info.money = GetMoney( )
	
	ArkInventory.LDB.Money:Update( )
	
end

function ArkInventory:LISTEN_PLAYER_SKILLS( )

	--ArkInventory.Output( "SKILL_LINES_CHANGED" )
	
	ArkInventory.ScanProfessions( )
	ArkInventory.ScanTradeskill( )
	
end


function ArkInventory:LISTEN_COMBAT_ENTER( )
	
	--ArkInventory.Output( "LISTEN_COMBAT_ENTER" )
	
	ArkInventory.Global.Mode.Combat = true
	
	if ArkInventory.db.global.option.auto.close.combat then
		ArkInventory.Frame_Main_Hide( )
	end
	
end

function ArkInventory:LISTEN_COMBAT_LEAVE( )
	
	--ArkInventory.Output( "LISTEN_COMBAT_LEAVE" )
	
	ArkInventory.Global.Mode.Combat = false
	
	if ( ArkInventory.Global.LeaveCombatRun.PetJournal ) then
		ArkInventory.Global.LeaveCombatRun.PetJournal = false
		ArkInventory:SendMessage( "LISTEN_PETJOURNAL_RELOAD_BUCKET", "RESCAN" )
	end
	
	if ( ArkInventory.Global.LeaveCombatRun.MountJournal ) then
		ArkInventory.Global.LeaveCombatRun.MountJournal = false
		ArkInventory:SendMessage( "LISTEN_MOUNTJOURNAL_RELOAD_BUCKET", "RESCAN" )
	end
	
	if ( ArkInventory.Global.LeaveCombatRun.Toybox ) then
		ArkInventory.Global.LeaveCombatRun.Toybox = false
		ArkInventory:SendMessage( "LISTEN_TOYBOX_RELOAD_BUCKET", "RESCAN" )
	end
	
	for loc_id in pairs( ArkInventory.Global.Location ) do
		
		if ArkInventory.Global.Location[loc_id].tainted then
			
			ArkInventory.Frame_Main_Generate( loc_id, ArkInventory.Const.Window.Draw.Recalculate )
			
		else
			
			if ArkInventory.LocationOptionGet( loc_id, "slot", "cooldown", "show" ) and not ArkInventory.LocationOptionGet( loc_id, "slot", "cooldown", "combat" )  then
				ArkInventory.Frame_Main_Generate( loc_id, ArkInventory.Const.Window.Draw.Refresh )
			end
			
		end
		
	end
	
	ArkInventory.LDB.Mounts:Update( )
	
end


function ArkInventory:LISTEN_BAG_UPDATE_BUCKET( bagTable )
	
	--ArkInventory.Output( "LISTEN_BAG_UPDATE_BUCKET( ", bagTable, " )" )
	
	-- bagTable[bag_id] = true

	local bag_changed = false
	
	for blizzard_id in pairs( bagTable ) do
		ArkInventory.Scan( blizzard_id )
		if ArkInventory.BagID_Internal( blizzard_id ) == ArkInventory.Const.Location.Bag then
			bag_changed = true
		end
		ArkInventory.RestackResume( ArkInventory.BagID_Internal( blizzard_id ) )
	end

	-- re-scan empty bag slots to wipe their data - no events are triggered when you move a bag from one bag slot into an empty bag slot (for the empty slot, new slot is fine)
	if bag_changed then
		for _, bag_id in pairs( ArkInventory.Global.Location[ArkInventory.Const.Location.Bag].Bags ) do
			if GetContainerNumSlots( bag_id ) == 0 then
				ArkInventory.ScanBag( bag_id )
			end
		end
	end

	
 	-- instant sorting enabled
	for loc_id in pairs( ArkInventory.Global.Location ) do
		if ArkInventory.LocationOptionGet( loc_id, "sort", "instant" ) then
			ArkInventory.Frame_Main_Generate( loc_id, ArkInventory.Const.Window.Draw.Recalculate )
		end
	end
	
	ArkInventory.LDB.Bags:Update( )
	
end

function ArkInventory:LISTEN_BAG_UPDATE( event, blizzard_id )
	
	--ArkInventory.Output( "LISTEN_BAG_UPDATE( ", blizzard_id, " )" )
	
	ArkInventory:SendMessage( "LISTEN_BAG_UPDATE_BUCKET", blizzard_id )
	
end

function ArkInventory:LISTEN_BAG_LOCK( event, arg1, arg2 )

	--ArkInventory.Output( "LISTEN_BAG_LOCK( ", arg1, ",", arg2, " )" )

	if not arg2 then
	
		-- inventory lock
		
		for blizzard_id = 1, NUM_BAG_SLOTS do
			local slotName = string.format( "Bag%sSlot", blizzard_id - 1 )
			if arg1 == GetInventorySlotInfo( slotName ) then
				local loc_id, bag_id = ArkInventory.BagID_Internal( blizzard_id )
				ArkInventory.ObjectLockChanged( loc_id, bag_id, nil )
				ArkInventory.RestackResume( loc_id )
			end
		end
	
	else
	
		if arg1 == BANK_CONTAINER then
		
			local count = GetContainerNumSlots( BANK_CONTAINER )
	
			if arg2 <= count then
				-- item lock
				local loc_id, bag_id = ArkInventory.BagID_Internal( arg1 )
				ArkInventory.ObjectLockChanged( loc_id, bag_id, arg2 )
			else
				-- bag lock
				local loc_id, bag_id = ArkInventory.BagID_Internal( arg2 - count + NUM_BAG_SLOTS )
				ArkInventory.ObjectLockChanged( loc_id, bag_id, nil )
			end

		else
	
			-- item lock
			local loc_id, bag_id = ArkInventory.BagID_Internal( arg1 )
			ArkInventory.ObjectLockChanged( loc_id, bag_id, arg2 )
			ArkInventory.RestackResume( loc_id )
			
		end
	
	end

end

function ArkInventory:LISTEN_CHANGER_UPDATE_BUCKET( arg1 )

	--ArkInventory.Output( "LISTEN_CHANGER_UPDATE_BUCKET( ", arg1, " )" )
	
	-- arg1 = table in the format loc_id_id=true so we need to loop through them

	for k in pairs( arg1 ) do
		ArkInventory.Frame_Changer_Update( k )
	end
	
end


function ArkInventory:LISTEN_BANK_ENTER( )
	
	--ArkInventory.Output( "LISTEN_BANK_ENTER" )
	
	local loc_id = ArkInventory.Const.Location.Bank
	
	ArkInventory.Global.Mode.Bank = true
	ArkInventory.Global.Location[loc_id].isOffline = false
	
	ArkInventory.ScanLocation( loc_id )
	
	ArkInventory.Frame_Main_DrawStatus( loc_id, ArkInventory.Const.Window.Draw.Refresh )
	
	if ArkInventory.LocationIsControlled( loc_id ) then
		ArkInventory.Frame_Main_Show( loc_id )
	end
	
	if ArkInventory.db.global.option.auto.open.bank and ArkInventory.LocationIsControlled( ArkInventory.Const.Location.Bag ) then
		ArkInventory.Frame_Main_Show( ArkInventory.Const.Location.Bag )
	end
	
	ArkInventory.Frame_Main_Generate( loc_id )
	
end

function ArkInventory:LISTEN_BANK_LEAVE( )
	
	--ArkInventory.Output( "LISTEN_BANK_LEAVE" )
	
	ArkInventory:SendMessage( "LISTEN_BANK_LEAVE_BUCKET" )
	
end

function ArkInventory:LISTEN_BANK_LEAVE_BUCKET( )
	
	--ArkInventory.Output( "LISTEN_BANK_LEAVE_BUCKET" )
	
	local loc_id = ArkInventory.Const.Location.Bank
	
	ArkInventory.Global.Mode.Bank = false
	ArkInventory.Global.Location[loc_id].isOffline = true
	
	ArkInventory.Frame_Main_DrawStatus( loc_id, ArkInventory.Const.Window.Draw.Refresh )
	
	if ArkInventory.LocationIsControlled( loc_id ) then
		ArkInventory.Frame_Main_Hide( loc_id )
	end
	
	if ArkInventory.db.global.option.auto.close.bank and ArkInventory.LocationIsControlled( ArkInventory.Const.Location.Bag ) then
		ArkInventory.Frame_Main_Hide( ArkInventory.Const.Location.Bag )
	end
	
	if not ArkInventory.LocationIsSaved( loc_id ) then
		ArkInventory.EraseSavedData( ArkInventory.Global.Me.info.player_id, loc_id, not ArkInventory.db.profile.option.location[loc_id].notifyerase )
	end
	
end

function ArkInventory:LISTEN_BANK_UPDATE( event, arg1 )

	-- player changed a bank bag or item

	--ArkInventory.Output( "LISTEN_BANK_UPDATE( ", arg1, " ) " )

	local count = GetContainerNumSlots( BANK_CONTAINER )
	
	if arg1 <= count then
		-- item was changed
		ArkInventory:SendMessage( "LISTEN_BAG_UPDATE_BUCKET", BANK_CONTAINER )
	else
		-- bag was changed
		ArkInventory:SendMessage( "LISTEN_BAG_UPDATE_BUCKET", arg1 - count + NUM_BAG_SLOTS )
	end
	
end

function ArkInventory:LISTEN_BANK_SLOT( )

	--ArkInventory.Output( "LISTEN_BANK_SLOT" )
	
	-- player just purchased a bank bag slot, re-scan and force a reload
	
	ArkInventory.ScanLocation( ArkInventory.Const.Location.Bank )
	ArkInventory.Frame_Main_Generate( ArkInventory.Const.Location.Bank, ArkInventory.Const.Window.Draw.Refresh )
	
end

function ArkInventory:LISTEN_BANK_TAB( event )
	
	--ArkInventory.Output( "LISTEN_BANK_TAB" )
	
	-- player just purchased a bank tab, re-scan and force a reload
	
	if event == "REAGENTBANK_PURCHASED" then
		ArkInventory:UnregisterEvent( "REAGENTBANK_PURCHASED" )
		ArkInventory.ScanLocation( ArkInventory.Const.Location.Bank )
		ArkInventory.Frame_Main_Generate( ArkInventory.Const.Location.Bank, ArkInventory.Const.Window.Draw.Refresh )
	end
	
end

function ArkInventory:LISTEN_BANK_TAB_REAGENT_UPDATE( event, arg1 )

	--ArkInventory.Output( "LISTEN_BANK_TAB_REAGENT_UPDATE( ", arg1, " ) " )

	ArkInventory:SendMessage( "LISTEN_BAG_UPDATE_BUCKET", REAGENTBANK_CONTAINER )
	
end

function ArkInventory:LISTEN_VAULT_ENTER( )
	
	--ArkInventory.Output( "LISTEN_VAULT_ENTER" )
	
	local loc_id = ArkInventory.Const.Location.Vault
	
	ArkInventory.Global.Mode.Vault = true
	ArkInventory.Global.Location[loc_id].isOffline = false
	
	ArkInventory.VaultInfoSet( )
	
	ArkInventory.ScanVaultHeader( )
	
	QueryGuildBankTab( GetCurrentGuildBankTab( ) or 1 )
	
	local cp = ArkInventory.Global.Me
	
	ArkInventory.Frame_Main_DrawStatus( loc_id, ArkInventory.Const.Window.Draw.Refresh )
	
	if ArkInventory.LocationIsControlled( loc_id ) then
		ArkInventory.Frame_Main_Show( loc_id )
		ArkInventory.Frame_Main_DrawStatus( loc_id, ArkInventory.Const.Window.Draw.Recalculate )
	end
	
	if ArkInventory.db.global.option.auto.open.vault and ArkInventory.LocationIsControlled( ArkInventory.Const.Location.Bag ) then
		ArkInventory.Frame_Main_Show( ArkInventory.Const.Location.Bag )
	end
	
end

function ArkInventory:LISTEN_VAULT_LEAVE( )

	--ArkInventory.Output( "LISTEN_VAULT_LEAVE" )
	
	ArkInventory:SendMessage( "LISTEN_VAULT_LEAVE_BUCKET" )
	
end

function ArkInventory:LISTEN_VAULT_LEAVE_BUCKET( )

	--ArkInventory.Output( "LISTEN_VAULT_LEAVE_BUCKET" )
	
	local loc_id = ArkInventory.Const.Location.Vault

	ArkInventory.Global.Mode.Vault = false
	ArkInventory.Global.Location[loc_id].isOffline = true

	ArkInventory.Frame_Main_Generate( loc_id, ArkInventory.Const.Window.Draw.Refresh )
	
	if ArkInventory.LocationIsControlled( loc_id ) then
		ArkInventory.Frame_Main_Hide( loc_id )
	end
	
	if ArkInventory.db.global.option.auto.close.vault and ArkInventory.LocationIsControlled( ArkInventory.Const.Location.Bag ) then
		ArkInventory.Frame_Main_Hide( ArkInventory.Const.Location.Bag )
	end

	if not ArkInventory.LocationIsSaved( loc_id ) then
		ArkInventory.EraseSavedData( ArkInventory.Global.Me.info.player_id, loc_id, not ArkInventory.db.profile.option.location[loc_id].notifyerase )
	end
	
end

function ArkInventory:LISTEN_VAULT_UPDATE_BUCKET( )
	
	--ArkInventory.Output( "LISTEN_VAULT_UPDATE_BUCKET" )
	
	local loc_id = ArkInventory.Const.Location.Vault
	
	ArkInventory.ScanVault( )
	ArkInventory.ScanVaultHeader( )
	
	ArkInventory.RestackResume( ArkInventory.Const.Location.Vault )
	
 	-- instant sorting enabled
	if ArkInventory.LocationOptionGet( loc_id, "sort", "instant" ) then
		ArkInventory.Frame_Main_Generate( loc_id, ArkInventory.Const.Window.Draw.Recalculate )
	end
	
end

function ArkInventory:LISTEN_VAULT_UPDATE( event )
	
	--ArkInventory.Output( "LISTEN_VAULT_UPDATE" )
	
	ArkInventory:SendMessage( "LISTEN_VAULT_UPDATE_BUCKET" )
	
end

function ArkInventory:LISTEN_VAULT_LOCK( event )
	
	--ArkInventory.Output( "LISTEN_VAULT_LOCK" )
	
	local loc_id = ArkInventory.Const.Location.Vault
	local bag_id = GetCurrentGuildBankTab( )
	
	for slot_id = 1, ArkInventory.Global.Location[loc_id].maxSlot[bag_id] or 0 do
		ArkInventory.ObjectLockChanged( loc_id, bag_id, slot_id )
	end
	
	ArkInventory.RestackResume( ArkInventory.Const.Location.Vault )
	
end

function ArkInventory:LISTEN_VAULT_MONEY( )

	--ArkInventory.Output( "LISTEN_VAULT_MONEY" )

	local loc_id = ArkInventory.Const.Location.Vault
	
	ArkInventory.VaultInfoSet( )
	
end

function ArkInventory:LISTEN_VAULT_TABS( )
	
	--ArkInventory.Output( "LISTEN_VAULT_TABS" )
	
	local loc_id = ArkInventory.Const.Location.Vault
	if not ArkInventory.Global.Location[loc_id].isOffline then
		-- ignore pre vault entrance events
		ArkInventory.ScanVaultHeader( )
	end
	
end

function ArkInventory:LISTEN_VAULT_LOG( event )

	--ArkInventory.Output( "LISTEN_VAULT_LOG: ", tab )
	
	ArkInventory.Frame_Vault_Log_Update( )
	
end

function ArkInventory:LISTEN_VAULT_INFO( event )

	--ArkInventory.Output( "LISTEN_VAULT_INFO: ", tab )
	
	ArkInventory.Frame_Vault_Info_Update( )
	
end


function ArkInventory:LISTEN_VOID_UPDATE_BUCKET( )
	
	--ArkInventory.Output( "LISTEN_VOID_UPDATE_BUCKET" )
	
	local loc_id = ArkInventory.Const.Location.Void

	ArkInventory.ScanLocation( loc_id )
	
 	-- instant sorting enabled
	if ArkInventory.LocationOptionGet( loc_id, "sort", "instant" ) then
		ArkInventory.Frame_Main_Generate( loc_id, ArkInventory.Const.Window.Draw.Recalculate )
	end
	
end

function ArkInventory:LISTEN_VOID_UPDATE( event )
	
	--ArkInventory.Output( "LISTEN_VOID_UPDATE: ", arg1, ", ", arg2, ", ", arg3 )
	
	ArkInventory:SendMessage( "LISTEN_VOID_UPDATE_BUCKET" )
	
end


function ArkInventory:LISTEN_INVENTORY_CHANGE_BUCKET( )
	
	--ArkInventory.Output( "LISTEN_INVENTORY_CHANGE_BUCKET" )
	
	local loc_id = ArkInventory.Const.Location.Wearing
	
	ArkInventory.ScanLocation( loc_id )
	
end

function ArkInventory:LISTEN_INVENTORY_CHANGE( event, arg1, arg2 )
	
	--ArkInventory.Output( "LISTEN_INVENTORY_CHANGE( ", arg1, ", ", arg2, " ) " )

	if arg1 == "player" then
		ArkInventory:SendMessage( "LISTEN_INVENTORY_CHANGE_BUCKET" )
	end
	
end


function ArkInventory:LISTEN_MAIL_ENTER( event, ... )
	
	--ArkInventory.Output( "MAIL_SHOW" )
	
	ArkInventory.Global.Mode.Mail = true
	
	local BACKPACK_WAS_OPEN = ArkInventory.Frame_Main_Get( ArkInventory.Const.Location.Bag ):IsVisible( )
	
	MailFrame_OnEvent( MailFrame, event, ... )
	
	local loc_id = ArkInventory.Const.Location.Mail
	ArkInventory.ScanLocation( loc_id )
	ArkInventory.Frame_Main_DrawStatus( loc_id, ArkInventory.Const.Window.Draw.Refresh )
	
	if ArkInventory.LocationIsControlled( loc_id ) then
		ArkInventory.Frame_Main_Show( loc_id )
	end
	
	if ArkInventory.LocationIsControlled( ArkInventory.Const.Location.Bag ) then
		-- blizzard auto-opens the backpack when you open the mailbox
		if not ArkInventory.db.global.option.auto.open.mail and not BACKPACK_WAS_OPEN then
			-- so we need to close it if we didnt already have it open
			ArkInventory.Frame_Main_Hide( ArkInventory.Const.Location.Bag )
		end
	end
	
	ArkInventory.Frame_Main_Generate( loc_id )
	
end

function ArkInventory:LISTEN_MAIL_LEAVE( )
	
	--ArkInventory.Output( "MAIL_CLOSED" )
	
	ArkInventory:SendMessage( "LISTEN_MAIL_LEAVE_BUCKET" )
	
end

function ArkInventory:LISTEN_MAIL_LEAVE_BUCKET( )
	
	--ArkInventory.Output( "MAIL_CLOSED_BUCKET" )
	
	ArkInventory.Global.Mode.Mail = false
	
	local loc_id = ArkInventory.Const.Location.Mail
	
	ArkInventory.Frame_Main_Generate( loc_id, ArkInventory.Const.Window.Draw.Refresh )
	
	if ArkInventory.LocationIsControlled( loc_id ) then
		ArkInventory.Frame_Main_Hide( loc_id )
	end
	
	if ArkInventory.db.global.option.auto.close.mail and ArkInventory.LocationIsControlled( ArkInventory.Const.Location.Bag ) then
		ArkInventory.Frame_Main_Hide( ArkInventory.Const.Location.Bag )
	end
	
	if not ArkInventory.LocationIsSaved( loc_id ) then
		ArkInventory.EraseSavedData( ArkInventory.Global.Me.info.player_id, loc_id, not ArkInventory.db.profile.option.location[loc_id].notifyerase )
	end
	
end

function ArkInventory:LISTEN_MAIL_UPDATE_BUCKET( )
	
	--ArkInventory.Output( "LISTEN_MAIL_UPDATE_BUCKET" )
	
	ArkInventory.ScanMailInbox( )
	
end

function ArkInventory:LISTEN_MAIL_UPDATE_MASSIVE_BUCKET( )
	
	--ArkInventory.Output( "LISTEN_MAIL_UPDATE_BUCKET" )
	
	ArkInventory.ScanMailInbox( true )
	
end

function ArkInventory:LISTEN_MAIL_UPDATE( )

	--ArkInventory.Output( "MAIL_UPDATE" )
	
	ArkInventory:SendMessage( "LISTEN_MAIL_UPDATE_BUCKET" )
	
end


local smd = { } -- sent mail data

function ArkInventory:LISTEN_MAIL_SEND_SUCCESS( )
	
	--ArkInventory.Output( "MAIL_SEND_SUCCESS( ", smd, " )" )
	
	ArkInventory.ScanMailSentData( )
	
end

function ArkInventory.HookMailSend( ... )
	
	if not ArkInventory:IsEnabled( ) then return end
	
	--ArkInventory.Output( "HookMailSend( )" )
	
	table.wipe( smd )
	
	local recipient, subject, body = ...
	local n, r = strsplit( "-", recipient )
	r = r or GetRealmName( )
	
	local id = string.format( "%s%s%s", n, ArkInventory.Const.PlayerIDTag, r )
	local known = false
	for k in pairs( ArkInventory.db.global.player.data ) do
		if string.lower( k ) == string.lower( id ) then
			known = true
			id = k
			break
		end
	end
	
	if not known or not ArkInventory.db.global.player.data[id].info.name then
		return
	end
	
	-- known character, store sent mail data
	
	smd.id = id
	smd.sender = ArkInventory.Global.Me.info.id
	smd.age = ArkInventory.ItemAgeUpdate( )
	
	local name, texture, count
	for x = 1, ATTACHMENTS_MAX_SEND do
		
		name, texture, count = GetSendMailItem( x )
		
		if name then
			smd[x] = { n = name, c = count, h = GetSendMailItemLink( x ) }
		end
		
	end
	
end

function ArkInventory.HookMailReturn( index )
	
	if not ArkInventory:IsEnabled( ) then return end
	
	--ArkInventory.Output( "HookMailReturn( ", index, " )" )
	
	table.wipe( smd )
	
	local _, _, recipient = GetInboxHeaderInfo( index )
	
	local n, r = strsplit( "-", recipient )
	r = r or GetRealmName( )
	
	local id = string.format( "%s%s%s", n, ArkInventory.Const.PlayerIDTag, r )
	local known = false
	for k in pairs( ArkInventory.db.global.player.data ) do
		if string.lower( k ) == string.lower( id ) then
			known = true
			id = k
			break
		end
	end
	
	if not known or not ArkInventory.db.global.player.data[id].info.name then
		return
	end
	
	-- known character, store sent mail data
	
	smd.id = id
	smd.sender = ArkInventory.Global.Me.info.id
	smd.age = ArkInventory.ItemAgeUpdate( )
	
	local name, texture, count
	for x = 1, ATTACHMENTS_MAX_RECEIVE do
		
		name, texture, count = GetInboxItem( index, x )
		
		if name then
			smd[x] = { n = name, c = count, h = GetInboxItemLink( index, x ) }
		end
		
	end
	
	ArkInventory.ScanMailSentData( )
	
end

function ArkInventory:LISTEN_TRADE_ENTER( )

	--ArkInventory.Output( "LISTEN_TRADE_ENTER" )
	
	if ArkInventory.db.global.option.auto.open.trade and ArkInventory.LocationIsControlled( ArkInventory.Const.Location.Bag ) then
		ArkInventory.Frame_Main_Show( ArkInventory.Const.Location.Bag )
	end
	
end

function ArkInventory:LISTEN_TRADE_LEAVE( )

	--ArkInventory.Output( "LISTEN_TRADE_LEAVE" )
	
	if ArkInventory.db.global.option.auto.close.trade and ArkInventory.LocationIsControlled( ArkInventory.Const.Location.Bag ) then
		ArkInventory.Frame_Main_Hide( ArkInventory.Const.Location.Bag )
	end
	
end


function ArkInventory:LISTEN_AUCTION_ENTER( )
	
	--ArkInventory.Output( "LISTEN_AUCTION_ENTER" )
	
	ArkInventory.Global.Mode.Auction = true
	
	if ArkInventory.db.global.option.auto.open.auction and ArkInventory.LocationIsControlled( ArkInventory.Const.Location.Bag ) then
		ArkInventory.Frame_Main_Show( ArkInventory.Const.Location.Bag )
	end
	
end

function ArkInventory:LISTEN_AUCTION_LEAVE( )
	
	--ArkInventory.Output( "LISTEN_AUCTION_LEAVE" )
	
	ArkInventory:SendMessage( "LISTEN_AUCTION_LEAVE_BUCKET" )
	
end

function ArkInventory:LISTEN_AUCTION_LEAVE_BUCKET( )
	
	--ArkInventory.Output( "LISTEN_AUCTION_LEAVE_BUCKET" )
	
	if ArkInventory.db.global.option.auto.close.auction and ArkInventory.LocationIsControlled( ArkInventory.Const.Location.Bag ) then
		ArkInventory.Frame_Main_Hide( ArkInventory.Const.Location.Bag )
	end
	
	ArkInventory.Global.Mode.Auction = false
	
end

function ArkInventory:LISTEN_AUCTION_UPDATE( )
	
	--ArkInventory.Output( "LISTEN_AUCTION_UPDATE" )
	
	ArkInventory:SendMessage( "LISTEN_AUCTION_UPDATE_BUCKET" )
	
end

function ArkInventory:LISTEN_AUCTION_UPDATE_BUCKET( )
	
	--ArkInventory.Output( "LISTEN_AUCTION_UPDATE_BUCKET" )
	
	ArkInventory.ScanAuction( )
	
end

function ArkInventory:LISTEN_AUCTION_UPDATE_MASSIVE_BUCKET( )
	
	--ArkInventory.Output( "LISTEN_AUCTION_UPDATE_MASSIVE_BUCKET" )
	
	ArkInventory.ScanAuction( true )
	
end

function ArkInventory:LISTEN_MERCHANT_ENTER( event, ... )
	
	--ArkInventory.Output( "LISTEN_MERCHANT_ENTER( ", event, " )" )
	
	ArkInventory.Global.Mode.Merchant = true
	
	local BACKPACK_WAS_OPEN = ArkInventory.Frame_Main_Get( ArkInventory.Const.Location.Bag ):IsVisible( )
	
	if event == "MERCHANT_SHOW" then
		
		-- merchant / vendor
		
		MerchantFrame_OnEvent( MerchantFrame, event, ... )
		
		if ArkInventory.LocationIsControlled( ArkInventory.Const.Location.Bag ) then
			
			-- blizzard auto-opens the backpack when you talk to a merchant
			if not ArkInventory.db.global.option.auto.open.merchant and not BACKPACK_WAS_OPEN then
				-- so we need to close it if we didnt already have it open
				ArkInventory.Frame_Main_Hide( ArkInventory.Const.Location.Bag )
			end
		end
	
	else
		
		-- reforger / transmogrify
		
		if ArkInventory.LocationIsControlled( ArkInventory.Const.Location.Bag ) then
			if ArkInventory.db.global.option.auto.open.merchant and not BACKPACK_WAS_OPEN then
				ArkInventory.Frame_Main_Show( ArkInventory.Const.Location.Bag )
			end
		end
		
	end
	
	
end

function ArkInventory:LISTEN_MERCHANT_LEAVE( event )
	
	ArkInventory:SendMessage( "LISTEN_MERCHANT_LEAVE_BUCKET" )
	
end

function ArkInventory:LISTEN_MERCHANT_LEAVE_BUCKET( )
	
	--ArkInventory.Output( "LISTEN_MERCHANT_LEAVE_BUCKET" )
	
	ArkInventory.Global.Mode.Merchant = false
	
	if ArkInventory.db.global.option.auto.close.merchant and ArkInventory.LocationIsControlled( ArkInventory.Const.Location.Bag ) then
		ArkInventory.Frame_Main_Hide( ArkInventory.Const.Location.Bag )
	end
	
end

function ArkInventory:LISTEN_CURRENCY_UPDATE( )

	--ArkInventory.Output( "LISTEN_CURRENCY_UPDATE" )
	
	local loc_id = ArkInventory.Const.Location.Token
	
	ArkInventory.ScanLocation( loc_id )
	
	ArkInventory.Frame_Main_Generate( loc_id, ArkInventory.Const.Window.Draw.Recalculate )
	
	ArkInventory.Frame_Status_Update_Tracking( )
	
	ArkInventory.LDB.Tracking_Currency:Update( )
	
end

function ArkInventory:LISTEN_EQUIPMENT_SETS_CHANGED( )
	
	--ArkInventory.Output( "LISTEN_EQUIPMENT_SETS_CHANGED( )" )
	
	ArkInventory.ItemCacheClear( )
	ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
	
end

function ArkInventory:LISTEN_BAG_UPDATE_COOLDOWN_BUCKET( arg )
	
	for loc_id in pairs( arg ) do
		if ArkInventory.LocationOptionGet( loc_id, "slot", "cooldown", "show" ) then
			if not ArkInventory.Global.Mode.Combat or ArkInventory.LocationOptionGet( loc_id, "slot", "cooldown", "combat" ) then
				if not ArkInventory.LocationOptionGet( loc_id, "sort", "instant" ) then
					ArkInventory.Frame_Main_Generate( loc_id, ArkInventory.Const.Window.Draw.Refresh )
				end
			end
		end
	end
	
end

function ArkInventory:LISTEN_BAG_UPDATE_COOLDOWN( event, arg1 )
	
	--ArkInventory.Output( "LISTEN_BAG_UPDATE_COOLDOWN( ", arg1, " )" )
	
	if arg1 then
		local loc_id = ArkInventory.BagID_Internal( arg1 )
		ArkInventory:SendMessage( "LISTEN_BAG_UPDATE_COOLDOWN_BUCKET", loc_id )
	else
		for loc_id in pairs( ArkInventory.Global.Location ) do
			if ArkInventory.LocationOptionGet( loc_id, "slot", "cooldown", "global" ) then
				ArkInventory:SendMessage( "LISTEN_BAG_UPDATE_COOLDOWN_BUCKET", loc_id )
			end
		end
	end
end

function ArkInventory:LISTEN_QUEST_UPDATE_BUCKET( )
	ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Refresh )
end

function ArkInventory:LISTEN_QUEST_UPDATE( )
	ArkInventory:SendMessage( "LISTEN_QUEST_UPDATE_BUCKET" )
end

function ArkInventory:LISTEN_CVAR_UPDATE( event, cvar, value )
	
	--ArkInventory.Output( event, ": ", cvar, " = ", value )
	
	if cvar == "USE_COLORBLIND_MODE" then
		ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Refresh )
		ArkInventory.LDB.Money:Update( )
	end
	
end

function ArkInventory:LISTEN_ZONE_CHANGED_BUCKET( )
	--ArkInventory.LDB.Mounts:Update( )
	ArkInventory.ScanMountJournal( )
end

function ArkInventory:LISTEN_ZONE_CHANGED( )
	ArkInventory:SendMessage( "LISTEN_ZONE_CHANGED_BUCKET", 1 )
end

function ArkInventory:LISTEN_ACTIONBAR_UPDATE_USABLE_BUCKET( )
	if not ArkInventory.Global.Mode.Combat then
		ArkInventory.LDB.Mounts:Update( )
	end
end

function ArkInventory:LISTEN_ACTIONBAR_UPDATE_USABLE( event )
	ArkInventory:SendMessage( "LISTEN_ACTIONBAR_UPDATE_USABLE_BUCKET", 1 )
end

--[[
function ArkInventory:LISTEN_UNIT_POWER_BUCKET( )
	
	--ArkInventory.Output( "LISTEN_UNIT_POWER_BUCKET" )
	
	if ArkInventory.Global.Me.info.class == "WARLOCK" and ArkInventory.Global.Me.ldb.tracking.item.tracked[6265] then
		-- update count for lock shards
		ArkInventory.LDB.Tracking_Item:Update( )
	end
	
end

function ArkInventory:LISTEN_UNIT_POWER( )
	ArkInventory:SendMessage( "LISTEN_UNIT_POWER_BUCKET", 1 )
end
]]--

function ArkInventory:LISTEN_SPELLS_CHANGED_BUCKET( )
	
	--ArkInventory.Output( "LISTEN_SPELLS_CHANGED_BUCKET( )" )
	
	ArkInventory.ScanSpellbook( )
	
end

function ArkInventory:LISTEN_SPELLS_CHANGED( event )
	
	--ArkInventory.Output( "LISTEN_SPELLS_CHANGED( )" )
	
	ArkInventory:SendMessage( "LISTEN_SPELLS_CHANGED_BUCKET" )
	
end




function ArkInventory:LISTEN_RESCAN_LOCATION_BUCKET( arg1 )
	
	--ArkInventory.Output( "LISTEN_RESCAN_LOCATION_BUCKET( ", arg1, " )" )
	
	-- arg1 = table in the format loc_id=true so we need to loop through them
	
	for k in pairs( arg1 ) do
		ArkInventory.ScanLocation( k )
	end
	
end



function ArkInventory.BagID_Blizzard( loc_id, bag_id )
	
	-- converts internal location+bag codes into blizzzard bag ids
	
	assert( loc_id ~= nil, "code failure: loc_id is nil" )
	assert( bag_id ~= nil, "code failure: bag_id is nil" )
	
	local blizzard_id = ArkInventory.Global.Location[loc_id].Bags[bag_id]
	
	assert( blizzard_id ~= nil, string.format( "code failure: ArkInventory.Global.Location[%s].Bags[%s] is nil", loc_id, bag_id ) )
	
	return blizzard_id
	
end

function ArkInventory.BagID_Internal( blizzard_id )
	
	-- converts blizzard bag codes into storage location+bag ids
	
	assert( blizzard_id ~= nil, "code failure: blizard_id is nil" )
	
	for loc_id, loc in pairs( ArkInventory.Global.Location ) do
		for bag_id, v in pairs( loc.Bags ) do
			if blizzard_id == v then
				return loc_id, bag_id
			end
		end
	end
	
	error( string.format( "code failure: unknown blizzard id [%s]", blizzard_id ) )
	
	return
	
end

function ArkInventory.BagType( blizzard_id )
	
	assert( blizzard_id ~= nil, "code failure: blizzard_id is nil" )
	
	if blizzard_id == BACKPACK_CONTAINER then
		return ArkInventory.Const.Slot.Type.Bag
	elseif blizzard_id == BANK_CONTAINER then
		return ArkInventory.Const.Slot.Type.Bag
	elseif blizzard_id == REAGENTBANK_CONTAINER then
		return ArkInventory.Const.Slot.Type.ReagentBank
	end
	
	local loc_id, bag_id = ArkInventory.BagID_Internal( blizzard_id )
	
	if loc_id == nil then
		return ArkInventory.Const.Slot.Type.Unknown
	elseif loc_id == ArkInventory.Const.Location.Vault then
		return ArkInventory.Const.Slot.Type.Bag
	elseif loc_id == ArkInventory.Const.Location.Mail then
		return ArkInventory.Const.Slot.Type.Mail
	elseif loc_id == ArkInventory.Const.Location.Wearing then
		return ArkInventory.Const.Slot.Type.Wearing
	elseif loc_id == ArkInventory.Const.Location.Pet then
		return ArkInventory.Const.Slot.Type.Critter
	elseif loc_id == ArkInventory.Const.Location.Mount then
		return ArkInventory.Const.Slot.Type.Mount
	elseif loc_id == ArkInventory.Const.Location.Toybox then
		return ArkInventory.Const.Slot.Type.Toybox
	elseif loc_id == ArkInventory.Const.Location.Token then
		return ArkInventory.Const.Slot.Type.Currency
	elseif loc_id == ArkInventory.Const.Location.Auction then
		return ArkInventory.Const.Slot.Type.Auction
	elseif loc_id == ArkInventory.Const.Location.Spellbook then
		return ArkInventory.Const.Slot.Type.Spellbook
	elseif loc_id == ArkInventory.Const.Location.Tradeskill then
		return ArkInventory.Const.Slot.Type.Tradeskill
	elseif loc_id == ArkInventory.Const.Location.Void then
		return ArkInventory.Const.Slot.Type.Void
	end
	
	
	if ArkInventory.Global.Location[loc_id].isOffline then
		
		local cp = ArkInventory.LocationPlayerInfoGet( loc_id )
		return cp.location[loc_id].bag[bag_id].type
		
	else
		
		local h = GetInventoryItemLink( "player", ContainerIDToInventoryID( blizzard_id ) )
		
		if h and h ~= "" then
			
			local t, s = select( 8, ArkInventory.ObjectInfo( h ) )
			
			--ArkInventory.Output( "bag[", blizzard_id, "], type[", t, "], sub[", s, "], h=", h )
			
			if t == ArkInventory.Localise["WOW_AH_CONTAINER"] then
				
				if s == ArkInventory.Localise["WOW_AH_CONTAINER_BAG"] then
					return ArkInventory.Const.Slot.Type.Bag
				elseif s == ArkInventory.Localise["WOW_AH_CONTAINER_ENCHANTING"] then
					return ArkInventory.Const.Slot.Type.Enchanting
				elseif s == ArkInventory.Localise["WOW_AH_CONTAINER_ENGINEERING"] then
					return ArkInventory.Const.Slot.Type.Engineering
				elseif s == ArkInventory.Localise["WOW_AH_CONTAINER_GEM"] then
					return ArkInventory.Const.Slot.Type.Gem
				elseif s == ArkInventory.Localise["WOW_AH_CONTAINER_HERB"] then
					return ArkInventory.Const.Slot.Type.Herb
				elseif s == ArkInventory.Localise["WOW_AH_CONTAINER_INSCRIPTION"] then
					return ArkInventory.Const.Slot.Type.Inscription
				elseif s == ArkInventory.Localise["WOW_AH_CONTAINER_LEATHERWORKING"] then
					return ArkInventory.Const.Slot.Type.Leatherworking
				elseif s == ArkInventory.Localise["WOW_AH_CONTAINER_MINING"] then
					return ArkInventory.Const.Slot.Type.Mining
				elseif s == ArkInventory.Localise["WOW_AH_CONTAINER_TACKLE"] then
					return ArkInventory.Const.Slot.Type.Tackle
				elseif s == ArkInventory.Localise["WOW_AH_CONTAINER_COOKING"] then
					return ArkInventory.Const.Slot.Type.Cooking
				end
				
			end
			
			return ArkInventory.Const.Slot.Type.Unknown
			
		else
			
			-- empty bag slots
			return ArkInventory.Const.Slot.Type.Bag
			
		end
	
	end
	
	ArkInventory.OutputWarning( "Unknown Type: [", ArkInventory.Global.Location[loc_id].Name, "] id[", blizzard_id, "]=[empty]" )
	return ArkInventory.Const.Slot.Type.Unknown
	
end

function ArkInventory.ScanLocation( arg1 )
	
	--ArkInventory.Output( "ScanLocation( ", arg1, " )" )
	
	if not ArkInventory.Global.Enabled then
		--ArkInventory.Output( "ScanLocation( ", arg1, " ) - aborted, not ready" )
		return
	end
	
	for loc_id, loc in pairs( ArkInventory.Global.Location ) do
		if arg1 == nil or arg1 == loc_id then
			ArkInventory.Scan( loc.Bags )
		end
	end
	
end

function ArkInventory.Scan( bagTable )
	
	local bagTable = bagTable
	if type( bagTable ) ~= "table" then
		bagTable = { bagTable }
	end
	
	local processed = { }
	
	for _, blizzard_id in pairs( bagTable ) do
		
		--local t1 = GetTime( )
		
		local loc_id = ArkInventory.BagID_Internal( blizzard_id )
		
		if loc_id == nil then
			--ArkInventory.OutputWarning( "aborted scan of bag ", blizzard_id, ", not an ", ArkInventory.Const.Program.Name, " controlled bag" )
			return
		elseif loc_id == ArkInventory.Const.Location.Bag or loc_id == ArkInventory.Const.Location.Bank then
			ArkInventory.ScanBag( blizzard_id )
		elseif loc_id == ArkInventory.Const.Location.Vault then
			if not processed[loc_id] then
				ArkInventory.ScanVault( )
			end
		elseif loc_id == ArkInventory.Const.Location.Wearing then
			if not processed[loc_id] then
				ArkInventory.ScanWearing( )
			end
		elseif loc_id == ArkInventory.Const.Location.Mail then
			if not processed[loc_id] then
				ArkInventory.ScanMailInbox( )
			end
		elseif loc_id == ArkInventory.Const.Location.Pet then
			if not processed[loc_id] then
				ArkInventory.ScanPetJournal( )
			end
		elseif loc_id == ArkInventory.Const.Location.Mount then
			if not processed[loc_id] then
				ArkInventory.ScanMountJournal( )
			end
		elseif loc_id == ArkInventory.Const.Location.Toybox then
			if not processed[loc_id] then
				ArkInventory.ScanToybox( )
			end
		elseif loc_id == ArkInventory.Const.Location.Token then
			if not processed[loc_id] then
				ArkInventory.ScanCurrency( )
			end
		elseif loc_id == ArkInventory.Const.Location.Auction then
			if not processed[loc_id] then
				ArkInventory.ScanAuction( )
			end
		elseif loc_id == ArkInventory.Const.Location.Spellbook then
			if not processed[loc_id] then
				ArkInventory.ScanSpellbook( )
			end
		elseif loc_id == ArkInventory.Const.Location.Tradeskill then
			if not processed[loc_id] then
				ArkInventory.ScanTradeskill( )
			end
		elseif loc_id == ArkInventory.Const.Location.Void then
			ArkInventory.ScanVoidStorage( blizzard_id )
		else
			error( string.format( "code failure: uncoded location [%s] for bag [%s]", loc_id, blizzard_id ) )
		end
		
		--t1 = GetTime( ) - t1
		--ArkInventory.Output( "scan location[" , loc_id, ".", blizzard_id, "] in ", string.format( "%0.3f", t1 ) )
		
		processed[loc_id] = true
		
	end

end

function ArkInventory.ScanBag( blizzard_id )
	
	--ArkInventory.Output( "ScanBag( ", blizzard_id, " )" )
	
	local loc_id, bag_id = ArkInventory.BagID_Internal( blizzard_id )
	
	if not loc_id then
		ArkInventory.OutputWarning( "aborted scan of bag [", blizzard_id, "], unknown bag id" )
		return
	else
		--ArkInventory.OutputWarning( "found bag id [", blizzard_id, "] in location ", loc_id, " [", ArkInventory.Global.Location[loc_id].Name, "]" )
	end
	
	local cp = ArkInventory.Global.Me
	
	if not ArkInventory.LocationIsMonitored( loc_id ) then
		--ArkInventory.OutputWarning( "aborted scan of bag id [", blizzard_id, "], location ", loc_id, " [", ArkInventory.Global.Location[loc_id].Name, "] is not being monitored" )
		return
	end
	
	--ArkInventory.Output( "scaning: ", ArkInventory.Global.Location[loc_id].Name, " [", loc_id, ".", bag_id, "] - [", blizzard_id, "]" )
	
	
	local count = 0
	local empty = 0
	local bt = ArkInventory.BagType( blizzard_id )
	local texture = nil
	local status = ArkInventory.Const.Bag.Status.Unknown
	local h = nil
	local rarity = 0
	
	if ( loc_id == ArkInventory.Const.Location.Bag ) then
		
		count = GetContainerNumSlots( blizzard_id )
		
		if ( blizzard_id == BACKPACK_CONTAINER ) then
			
			if ( not count ) or ( count == 0 ) then
				if ArkInventory.db.global.option.bugfix.zerosizebag.alert then
					ArkInventory.OutputWarning( "Aborted scan of bag ", blizzard_id, ", location ", loc_id, " [", ArkInventory.Global.Location[loc_id].Name, "] size returned was ", count, ", rescan has been scheduled for 10 seconds.  This warning can be disabled in the config menu" )
				end
				ArkInventory:SendMessage( "LISTEN_RESCAN_LOCATION_BUCKET", loc_id )
				return
			end
			
			texture = ArkInventory.Global.Location[loc_id].Texture
			status = ArkInventory.Const.Bag.Status.Active
			
		else
			
			h = GetInventoryItemLink( "player", ContainerIDToInventoryID( blizzard_id ) )
			
			if not h then
				
				texture = ArkInventory.Const.Texture.Empty.Bag
				status = ArkInventory.Const.Bag.Status.Empty
				
			else
				
				if ( not count ) or ( count == 0 ) then
					if ArkInventory.db.global.option.bugfix.zerosizebag.alert then
						ArkInventory.OutputWarning( "Aborted scan of bag ", blizzard_id, ", location ", loc_id, " [", ArkInventory.Global.Location[loc_id].Name, "] size returned was ", count, ", rescan has been scheduled for 10 seconds.  This warning can be disabled in the config menu" )
					end
					ArkInventory:SendMessage( "LISTEN_RESCAN_LOCATION_BUCKET", loc_id )
					return
				end
				
				texture = ArkInventory.ObjectInfoTexture( h )
				status = ArkInventory.Const.Bag.Status.Active
				rarity = ArkInventory.ObjectInfoQuality( h )
				
			end
			
		end
		
	end

	
	if loc_id == ArkInventory.Const.Location.Bank then
		
		count = GetContainerNumSlots( blizzard_id )
		
		if blizzard_id == REAGENTBANK_CONTAINER then
			
			if not count or count == 0 then
				if ArkInventory.db.global.option.bugfix.zerosizebag.alert then
					ArkInventory.OutputWarning( "Aborted scan of bag ", blizzard_id, ", location ", loc_id, " [", ArkInventory.Global.Location[loc_id].Name, "] size returned was ", count, ", rescan has been scheduled for 10 seconds.  This warning can be disabled in the config menu" )
				end
				ArkInventory:SendMessage( "LISTEN_RESCAN_LOCATION_BUCKET", loc_id )
				return
			end
			
			if IsReagentBankUnlocked( ) then
				texture = ArkInventory.Global.Location[loc_id].Texture
				status = ArkInventory.Const.Bag.Status.Active
			else
				count = 0
				texture = ArkInventory.Const.Texture.Empty.Bag
				status = ArkInventory.Const.Bag.Status.Purchase
			end
			
		elseif ArkInventory.Global.Mode.Bank == true then
			
			if blizzard_id == BANK_CONTAINER then
				
				if not count or count == 0 then
					if ArkInventory.db.global.option.bugfix.zerosizebag.alert then
						ArkInventory.OutputWarning( "Aborted scan of bag ", blizzard_id, ", location ", loc_id, " [", ArkInventory.Global.Location[loc_id].Name, "] size returned was ", count, ", rescan has been scheduled for 10 seconds.  This warning can be disabled in the config menu" )
					end
					ArkInventory:SendMessage( "LISTEN_RESCAN_LOCATION_BUCKET", loc_id )
					return
				end
				
				texture = ArkInventory.Global.Location[loc_id].Texture
				status = ArkInventory.Const.Bag.Status.Active
				
			else
				
				if blizzard_id - NUM_BAG_SLOTS > GetNumBankSlots( ) then
				
					texture = ArkInventory.Const.Texture.Empty.Bag
					status = ArkInventory.Const.Bag.Status.Purchase
					
				else
					
					h = GetInventoryItemLink( "player", ContainerIDToInventoryID( blizzard_id ) )
					
					if not h then
						
						texture = ArkInventory.Const.Texture.Empty.Bag
						status = ArkInventory.Const.Bag.Status.Empty
						
					else
						
						if not count or count == 0 then
							if ArkInventory.db.global.option.bugfix.zerosizebag.alert then
								ArkInventory.OutputWarning( "Aborted scan of bag ", blizzard_id, ", location ", loc_id, " [", ArkInventory.Global.Location[loc_id].Name, "] size returned was ", count, ", rescan has been scheduled for 10 seconds.  This warning can be disabled in the config menu" )
							end
							ArkInventory:SendMessage( "LISTEN_RESCAN_LOCATION_BUCKET", loc_id )
							return
						end
						
						texture = ArkInventory.ObjectInfoTexture( h )
						status = ArkInventory.Const.Bag.Status.Active
						rarity = ArkInventory.ObjectInfoQuality( h )
						
					end
					
				end
	
			end
		
		else
			
			--ArkInventory.OutputWarning( "aborted scan of bag id [", blizzard_id, "], not at bank" )
			return
			
		end
		
	end
	
	local bag = cp.location[loc_id].bag[bag_id]
	
	local old_bag_count = bag.count
	local old_bag_link = bag.h
	local old_bag_status = bag.status
	
	bag.count = count
	bag.empty = empty
	bag.type = bt
	bag.texture = texture
	bag.status = status
	bag.h = h
	bag.q = rarity
	
	local changed_bag = false
	if old_bag_count ~= bag.count or old_bag_link ~= bag.h or old_bag_status ~= bag.status then
		changed_bag = true
	end
	
	if bt == ArkInventory.Const.Slot.Type.Unknown then
		
		if ArkInventory.TranslationsLoaded then
			-- print the warning only after the translations are loaded
			ArkInventory.OutputWarning( "aborted scan of bag [", bag_id, "] in location ", loc_id, " [", ArkInventory.Global.Location[loc_id].Name, "] type is unknown, queuing for rescan" )
		end
		ArkInventory:SendMessage( "LISTEN_BAG_UPDATE_BUCKET", blizzard_id )
		
	else
	
	for slot_id = 1, bag.count do
		
		if not bag.slot[slot_id] then
			bag.slot[slot_id] = {
				loc_id = loc_id,
				bag_id = bag_id,
				slot_id = slot_id,
			}
		end
		
		local i = bag.slot[slot_id]
		
		local texture, count, locked, rarity, readable, lootable, h, filtered = GetContainerItemInfo( blizzard_id, slot_id )
		local ab = nil
		local sb = nil
		
		if h then
			
			ArkInventory.TooltipSetItem( ArkInventory.Global.Tooltip.Scan, blizzard_id, slot_id )
			
			for _, v in pairs( ArkInventory.Const.Accountbound ) do
				if ( v and ArkInventory.TooltipContains( ArkInventory.Global.Tooltip.Scan, string.format( "^%s$", v ) ) ) then
					--ArkInventory.Output( loc_id, ".", bag_id, ".", slot_id, " = ", h, " - ", v )
					ab = 1
					sb = 1
					break
				end
			end
			
			if ( not ab ) then
				for _, v in pairs( ArkInventory.Const.Soulbound ) do
					if ( v and ArkInventory.TooltipContains( ArkInventory.Global.Tooltip.Scan, string.format( "^%s$", v ) ) ) then
						--ArkInventory.Output( loc_id, ".", bag_id, ".", slot_id, " = ", h, " - ", v )
						sb = 1
						break
					end
				end
			end
			
			i.q = ArkInventory.ObjectInfoQuality( h )
			
		else
			
			i.q = 0
			
			count = 1
			bag.empty = bag.empty + 1
			
		end
		
		local changed_item = ArkInventory.ScanChanged( i, h, sb, count )
		
		i.h = h
		i.ab = ab
		i.sb = sb
		i.r = ( not not readable ) or nil
		i.count = count
		
		if changed_item then
			
			i.age = ArkInventory.ItemAgeUpdate( )
			
			ArkInventory.ItemCategoryGet( i )
			
			if not changed_bag then
				ArkInventory.Frame_Item_Update( loc_id, bag_id, slot_id )
				ArkInventory:SendMessage( "LISTEN_CHANGER_UPDATE_BUCKET", loc_id )
			end
			
			ArkInventory.Frame_Main_DrawStatus( loc_id, ArkInventory.Const.Window.Draw.Refresh )
			
		end
		
	end
	
	end
	
	ArkInventory.ScanCleanup( cp, loc_id, bag_id, bag )
	
end

function ArkInventory.ScanVault( )
	
	--ArkInventory.Output( GREEN_FONT_COLOR_CODE, "ScanVault( )" )
	
	if ArkInventory.Global.Mode.Vault == false then
		--ArkInventory.Output( RED_FONT_COLOR_CODE, "aborted scan of vault, not at vault" )
		return
	end
	
	if not IsInGuild( ) or not ArkInventory.Global.Me.info.guild_id then
		--ArkInventory.Output( RED_FONT_COLOR_CODE, "aborted scan of vault, not in a guild" )
		return
	end
	
	if GetNumGuildBankTabs( ) == 0 then
		--ArkInventory.Output( RED_FONT_COLOR_CODE, "aborted scan of vault, no tabs purchased" )
		return
	end
	
	local loc_id = ArkInventory.Const.Location.Vault
	local bag_id = GetCurrentGuildBankTab( )

	if not ArkInventory.LocationIsMonitored( loc_id ) then
		--ArkInventory.Output( RED_FONT_COLOR_CODE, "aborted scan of bag id [", blizzard_id, "], location ", loc_id, " [", ArkInventory.Global.Location[loc_id].Name, "] is not being monitored" )
		return
	end
	
	local cp = ArkInventory.PlayerInfoGet( ArkInventory.Global.Me.info.guild_id )
	
	--ArkInventory.Output( GREEN_FONT_COLOR_CODE, "scaning: ", ArkInventory.Global.Location[loc_id].Name, " [", loc_id, ".", bag_id, "] - [", blizzard_id, "]" )
	
	local bag = cp.location[loc_id].bag[bag_id]
	
	local old_bag_count = bag.count
	local old_bag_status = bag.status
	
	bag.count = 0
	bag.empty = 0
	bag.type = ArkInventory.Const.Slot.Type.Bag
	
	local blizzard_container_width = NUM_SLOTS_PER_GUILDBANK_GROUP
	local blizzard_container_depth = NUM_GUILDBANK_COLUMNS
	
	if bag_id <= GetNumGuildBankTabs( ) then
		
		local name, icon, canView, canDeposit, numWithdrawals, remainingWithdrawals, filtered = GetGuildBankTabInfo( bag_id )
		bag.name = name
		bag.texture = icon
		bag.count = MAX_GUILDBANK_SLOTS_PER_TAB
		bag.status = ArkInventory.Const.Bag.Status.Active
		
	end
	
	local canView, canDeposit = select( 3, GetGuildBankTabInfo( bag_id ) )

	local changed_bag = false
	if old_bag_count ~= bag.count or old_bag_status ~= bag.status then
		changed_bag = true
	end
	
	for slot_id = 1, bag.count or 0 do
		
		if not bag.slot[slot_id] then
			bag.slot[slot_id] = {
				loc_id = loc_id,
				bag_id = bag_id,
				slot_id = slot_id,
			}
		end
		
		local i = bag.slot[slot_id]
		i.did = blizzard_container_width * ( ( slot_id - 1 ) % blizzard_container_depth ) + math.floor( ( slot_id - 1 ) / blizzard_container_depth ) + 1
		
		local texture, count = GetGuildBankItemInfo( bag_id, slot_id )
		local h = nil
		local sb = nil
		
		if texture then
			
			local speciesID, level, breedQuality, maxHealth, power, speed, name = ArkInventory.TooltipSetGuildBankItem( ArkInventory.Global.Tooltip.Scan, bag_id, slot_id )
			if speciesID then
				--ArkInventory.Output( "[", speciesID, " / ", level, " / ", breedQuality, " / ", maxHealth, " / ", power, " / ", speed, " / ", name, "]" )
				h = ArkInventory.BattlepetBaseHyperlink( speciesID, level, breedQuality, maxHealth, power, speed, name )
			else
				
				h = GetGuildBankItemLink( bag_id, slot_id )
				
				if not h then
					h = select( 2, ArkInventory.TooltipGetItem( ArkInventory.Global.Tooltip.Scan ) )
				end
				
			end
			
		else
			
			bag.empty = bag.empty + 1
			
		end
		
		
		local changed_item = ArkInventory.ScanChanged( i, h, sb, count )
		
		if changed_item then
			
			i.age = ArkInventory.ItemAgeUpdate( )
			
			i.h = h
			i.count = count
			i.sb = sb
			i.q = ArkInventory.ObjectInfoQuality( h )
			
			if not changed_bag then
				ArkInventory.Frame_Item_Update( loc_id, bag_id, slot_id )
				ArkInventory:SendMessage( "LISTEN_CHANGER_UPDATE_BUCKET", loc_id )
			end
			
			ArkInventory.Frame_Main_DrawStatus( loc_id, ArkInventory.Const.Window.Draw.Refresh )
			
		end
		
	end
	
	if changed_bag then
		ArkInventory:SendMessage( "LISTEN_STORAGE_EVENT", ArkInventory.Const.Event.BagUpdate, loc_id, bag_id, ArkInventory.Const.Window.Draw.Recalculate )
	else
		ArkInventory:SendMessage( "LISTEN_STORAGE_EVENT", ArkInventory.Const.Event.BagUpdate, loc_id, bag_id, ArkInventory.Const.Window.Draw.Refresh )
	end
	
	ArkInventory.ScanCleanup( cp, loc_id, bag_id, bag )
	
end

function ArkInventory.ScanVaultHeader( )
	
--	ArkInventory.Output( "ScanVaultHeader( ) start" )
	
	if ArkInventory.Global.Mode.Vault == false then
		--ArkInventory.Output( "aborted scan of tab headers, not at vault" )
		return
	end
	
	local cp = ArkInventory.PlayerInfoGet( ArkInventory.Global.Me.info.guild_id )
	
	local loc_id = ArkInventory.Const.Location.Vault
	
	for bag_id = 1, MAX_GUILDBANK_TABS do
		
		--ArkInventory.Output( "scaning tab header: ", bag_id )
		
		local bag = cp.location[loc_id].bag[bag_id]
	
		bag.type = ArkInventory.Const.Slot.Type.Bag
	
		if bag_id <= GetNumGuildBankTabs( ) then
			
			local name, icon, canView, canDeposit, numWithdrawals, remainingWithdrawals = GetGuildBankTabInfo( bag_id )
			
			--ArkInventory.Output( "tab = ", bag_id, ", icon = ", icon )
			
			bag.name = name
			bag.texture = icon
			bag.status = ArkInventory.Const.Bag.Status.Active
			
			-- from Blizzard_GuildBankUI.lua - GuildBankFrame_UpdateTabs( )
			local access = GUILDBANK_TAB_FULL_ACCESS
			if not canView then
				access = ArkInventory.Localise["VAULT_TAB_ACCESS_NONE"]
			elseif ( not canDeposit and numWithdrawals == 0 ) then
				access = GUILDBANK_TAB_LOCKED
			elseif ( not canDeposit ) then
				access = GUILDBANK_TAB_WITHDRAW_ONLY
			elseif ( numWithdrawals == 0 ) then
				access = GUILDBANK_TAB_DEPOSIT_ONLY
			end
			bag.access = access
			
			local stackString = nil
			if bag_id == GetCurrentGuildBankTab( ) then
				if remainingWithdrawals > 0 then
					stackString = string.format( "%s/%s", remainingWithdrawals, string.format( GetText( "STACKS", nil, numWithdrawals ), numWithdrawals ) )
				elseif remainingWithdrawals == 0 then
					stackString = NONE
				else
					stackString = UNLIMITED
				end
			end
			bag.withdraw = stackString
			
			if bag.access == ArkInventory.Localise["VAULT_TAB_ACCESS_NONE"] then
				bag.status = ArkInventory.Const.Bag.Status.NoAccess
				bag.withdraw = nil
			end
			
		else
			
			bag.name = string.format( GUILDBANK_TAB_NUMBER, bag_id )
			bag.texture = ArkInventory.Const.Texture.Empty.Bag
			bag.count = 0
			bag.empty = 0
			bag.access = ArkInventory.Localise["STATUS_PURCHASE"]
			bag.withdraw = nil
			bag.status = ArkInventory.Const.Bag.Status.Purchase
			
		end
		
	end
	
	ArkInventory.Frame_Changer_Update( loc_id, bag_id )
	
	--ArkInventory.Output( "ScanVaultHeader( ) end" )
	
end

function ArkInventory.ScanWearing( )

	--ArkInventory.Output( GREEN_FONT_COLOR_CODE, "ScanWearing( ) start" )
	
	local blizzard_id = ArkInventory.Const.Offset.Wearing + 1
	
	local loc_id, bag_id = ArkInventory.BagID_Internal( blizzard_id )
	
	if not ArkInventory.LocationIsMonitored( loc_id ) then
		--ArkInventory.Output( RED_FONT_COLOR_CODE, "aborted scan of bag id [", blizzard_id, "], location ", loc_id, " [", ArkInventory.Global.Location[loc_id].Name, "] is not being monitored" )
		return
	end

	--ArkInventory.Output( GREEN_FONT_COLOR_CODE, "scaning: ", ArkInventory.Global.Location[loc_id].Name, " [", loc_id, ".", bag_id, "] - [", blizzard_id, "]" )
	
	
	local cp = ArkInventory.Global.Me
	
	local bag = cp.location[loc_id].bag[bag_id]
	local old_bag_count = bag.count
	
	bag.count = 0
	bag.empty = 0
	bag.type = ArkInventory.Const.Slot.Type.Wearing
	bag.status = ArkInventory.Const.Bag.Status.Active

	
	for slot_id, v in ipairs( ArkInventory.Const.InventorySlotName ) do
	
		bag.count = bag.count + 1
		
		if not bag.slot[slot_id] then
			bag.slot[slot_id] = { }
		end
		
		local i = bag.slot[slot_id]
		
		local inv_id = GetInventorySlotInfo( v )
		local h = GetInventoryItemLink( "player", inv_id )
		local ab = nil
		local sb = nil
		local count = 1
		
		if h then
		
			ArkInventory.TooltipSetInventoryItem( ArkInventory.Global.Tooltip.Scan, inv_id )
			
			for _, v in pairs( ArkInventory.Const.Accountbound ) do
				if ( v and ArkInventory.TooltipContains( ArkInventory.Global.Tooltip.Scan, string.format( "^%s$", v ) ) ) then
					ab = 1
					sb = 1
					break
				end
			end
			
			if ( not sb ) then
				for _, v in pairs( ArkInventory.Const.Soulbound ) do
					if ( v and ArkInventory.TooltipContains( ArkInventory.Global.Tooltip.Scan, string.format( "^%s$", v ) ) ) then
						sb = 1
						break
					end
				end
			end
			
		else
		
			bag.empty = bag.empty + 1
			
		end

		
		local changed_item = ArkInventory.ScanChanged( i, h, sb, count )

		if changed_item or i.loc_id == nil then
		
			i.age = ArkInventory.ItemAgeUpdate( )

			i.loc_id = loc_id
			i.bag_id = bag_id
			i.slot_id = slot_id
			
			i.h = h
			i.count = count
			i.ab = ab
			i.sb = sb
			i.q = ArkInventory.ObjectInfoQuality( h )
		
			ArkInventory.Frame_Item_Update( loc_id, bag_id, slot_id )
			ArkInventory:SendMessage( "LISTEN_CHANGER_UPDATE_BUCKET", loc_id )
			
			ArkInventory.Frame_Main_DrawStatus( loc_id, ArkInventory.Const.Window.Draw.Refresh )
			
		end
		
		--ArkInventory.Output( "slot=[", slot_id, "], item=[", i.h, "]" )
	
	end
	
	ArkInventory.ScanCleanup( cp, loc_id, bag_id, bag )
	
end

function ArkInventory.ScanMailInbox( )
	
	local blizzard_id = ArkInventory.Const.Offset.Mail + 1
	
	local loc_id, bag_id = ArkInventory.BagID_Internal( blizzard_id )
	
	-- mailbox can be scanned from anywhere, just uses data from when it was last opened but dont bother unless its actually open
	if ArkInventory.Global.Mode.Mail == false then
		--ArkInventory.Output( RED_FONT_COLOR_CODE, "aborted scan of mailbox, not at mailbox" )
		return
	end
	
	if not ArkInventory.LocationIsMonitored( loc_id ) then
		--ArkInventory.Output( RED_FONT_COLOR_CODE, "aborted scan of bag id [", blizzard_id, "], location ", loc_id, " [", ArkInventory.Global.Location[loc_id].Name, "] is not being monitored" )
		return
	end

	
	--ArkInventory.Output( GREEN_FONT_COLOR_CODE, "scaning: ", ArkInventory.Global.Location[loc_id].Name, " [", loc_id, ".", bag_id, "] - [", blizzard_id, "]" )
	
	local cp = ArkInventory.Global.Me
	
	local bag = cp.location[loc_id].bag[bag_id]
	
	local old_bag_count = bag.count

	bag.count = 0
	bag.empty = 0
	bag.type = ArkInventory.Const.Slot.Type.Mail
	bag.status = ArkInventory.Const.Bag.Status.Active
	
	
	local slot_id = 0
	local name, texture, count
	
	for index = 1, GetInboxNumItems( ) do
	
		--ArkInventory.Output( "scanning message ", index )
		
		local _, _, _, _, _, _, daysLeft, hasItem, _, wasReturned, _, canReply, _ = GetInboxHeaderInfo( index )
		
		if hasItem then
		
			--if ( daysLeft >= 1 ) then
--			daysLeft = string.format( "%s%s%s%s", GREEN_FONT_COLOR_CODE, string.format( DAYS_ABBR, floor(daysLeft) ), " ", FONT_COLOR_CODE_CLOSE )
			--else
--			daysLeft = string.format( "%s%s%s", RED_FONT_COLOR_CODE, SecondsToTime( floor( daysLeft * 24 * 60 * 60 ) ), FONT_COLOR_CODE_CLOSE )
			--end
		
			--local expires_d = floor( daysLeft )
			--local expires_s = ( daysLeft - floor( daysLeft ) ) * 24 * 60* 60
			--local purge = not not ( wasReturned ) or ( not canReply )
		
			--ArkInventory.Output( "message ", index, " has item(s)" )
			
			for x = 1, ATTACHMENTS_MAX_RECEIVE do
				
				name, texture, count = GetInboxItem( index, x ) -- rarity is bugged, always returns -1
				
				if name then
					
					--ArkInventory.Output( "message ", index, ", attachment ", x, " = ", name, " x ", count, " / (", { GetInboxItemLink( index, x ) }, ")" )
					
					slot_id = slot_id + 1
					
					if not bag.slot[slot_id] then
						bag.slot[slot_id] = {
							loc_id = loc_id,
							bag_id = bag_id,
							slot_id = slot_id,
						}
					end
					
					local i = bag.slot[slot_id]
					
					local h = GetInboxItemLink( index, x )
					local hasCooldown, speciesID, level, breedQuality, maxHealth, power, speed, name = ArkInventory.Global.Tooltip.Scan:SetInboxItem( index, x )
					if speciesID then
						h = ArkInventory.BattlepetBaseHyperlink( speciesID, level, breedQuality, maxHealth, power, speed, name )
					end
					
					local sb = nil -- always false, might be boa but sort that out if its looted
					
					if h then
						bag.count = bag.count + 1
					end
					
					local changed_item = ArkInventory.ScanChanged( i, h, sb, count )
					
					i.h = h
					i.sb = sb
					
					if changed_item then
						
						i.age = ArkInventory.ItemAgeUpdate( )
						i.count = count
						i.q = ArkInventory.ObjectInfoQuality( h )
						
						ArkInventory.Frame_Main_DrawStatus( loc_id, ArkInventory.Const.Window.Draw.Refresh )
						
					end
					
				end
			
			end
		
		end
		
	end

	ArkInventory.ScanCleanup( cp, loc_id, bag_id, bag )
	
	
	-- clear cached mail sent from other known characters
	
	blizzard_id = ArkInventory.Const.Offset.Mail + 2
	
	loc_id, bag_id = ArkInventory.BagID_Internal( blizzard_id )
	
	bag = cp.location[loc_id].bag[bag_id]
	
	old_bag_count = bag.count
	bag.count = 0
	bag.empty = 0
	bag.type = ArkInventory.Const.Slot.Type.Mail
	bag.status = ArkInventory.Const.Bag.Status.Active
	
	ArkInventory.ScanCleanup( cp, loc_id, bag_id, bag )
	
end

function ArkInventory.ScanMailSentData( )
	
	local blizzard_id = ArkInventory.Const.Offset.Mail + 2
	
	local loc_id, bag_id = ArkInventory.BagID_Internal( blizzard_id )
	
	--ArkInventory.Output( GREEN_FONT_COLOR_CODE, "scaning: ", ArkInventory.Global.Location[loc_id].Name, " [", loc_id, ".", bag_id, "] - [", blizzard_id, "]" )
	
	local cp = ArkInventory.PlayerInfoGet( smd.id )
	if not cp then
		return
	end
	
	local bag = cp.location[loc_id].bag[bag_id]
	
	local old_bag_count = bag.count
	
	bag.empty = 0
	bag.type = ArkInventory.Const.Slot.Type.Mail
	bag.status = ArkInventory.Const.Bag.Status.Active
	
	local slot_id = bag.count
	
	local name, texture, count, quality
	for x = 1, ATTACHMENTS_MAX do
		
		if smd[x] then
		
			slot_id = slot_id + 1
			bag.count = slot_id
			
			if not bag.slot[slot_id] then
				bag.slot[slot_id] = {
					loc_id = loc_id,
					bag_id = bag_id,
					slot_id = slot_id,
				}
			end
			
			local i = bag.slot[slot_id]
			
			local h = smd[x].h
			local sb = nil -- always false, might be boa but sort that out if its looted
			local count = smd[x].c
			
			local changed_item = ArkInventory.ScanChanged( i, h, sb, count )
			
			i.h = h
			i.sb = sb
			i.age = smd[x].age
			i.count = count
			i.q = ArkInventory.ObjectInfoQuality( h )
			i.sdr = smd[x].sender
			
			ArkInventory.Frame_Main_DrawStatus( loc_id, ArkInventory.Const.Window.Draw.Refresh )
			
		end
		
	end
	
	ArkInventory.ScanCleanup( cp, loc_id, bag_id, bag )
	
end

function ArkInventory.ScanMountJournal( )
	
	--ArkInventory.Output( "ScanMountJournal( ) start" )
	
	if ( not ArkInventory.MountJournal.JournalIsReady( ) ) then
		--ArkInventory.Output( "mount journal not ready" )
		ArkInventory:SendMessage( "LISTEN_MOUNTJOURNAL_RELOAD_BUCKET", "RESCAN" )
		return
	end
	--ArkInventory.Output( "mount journal ready" )
	
	if ( ArkInventory.MountJournal.GetCount( ) == 0 ) then
		--ArkInventory.Output( "no mounts" )
		return
	end
	
	local blizzard_id = ArkInventory.Const.Offset.Mount + 1
	local loc_id, bag_id = ArkInventory.BagID_Internal( blizzard_id )
	
	if not ArkInventory.LocationIsMonitored( loc_id ) then
		--ArkInventory.Output( RED_FONT_COLOR_CODE, "aborted scan of bag id [", blizzard_id, "], location ", loc_id, " [", ArkInventory.Global.Location[loc_id].Name, "] is not being monitored" )
		return
	end
	
	--ArkInventory.Output( GREEN_FONT_COLOR_CODE, "scaning: ", ArkInventory.Global.Location[loc_id].Name, " [", loc_id, ".", bag_id, "] - [", blizzard_id, "]" )
	
	local player_id = ArkInventory.PlayerIDAccount( )
	local cp = ArkInventory.PlayerInfoGet( player_id )
	
	local bag = cp.location[loc_id].bag[bag_id]
	
	local old_bag_count = bag.count
	
	bag.count = 0
	bag.empty = 0
	bag.type = ArkInventory.BagType( blizzard_id )
	bag.status = ArkInventory.Const.Bag.Status.Active
	
	--ArkInventory.Output( "scanning mounts [", ArkInventory.MountJournal.data.owned, "]" )
	
	local slot_id = 0
	
	for _, md in ArkInventory.MountJournal.Iterate( ) do
		
		if md.owned then
			
			slot_id = slot_id + 1
			
			if not bag.slot[slot_id] then
				bag.slot[slot_id] = {
					loc_id = loc_id,
					bag_id = bag_id,
					slot_id = slot_id,
				}
			end
			
			local i = bag.slot[slot_id]
			local h = md.link
			local sb = 1
			local count = 1
			
			ArkInventory.ScanChanged( i, h, sb, count )
			
			i.h = h
			i.count = count
			i.ab = 1
			i.sb = sb
			i.q = 1
			
			i.index = md.index
			i.fav = md.fav
			
			if changed_item then
				
				i.texture = texture
				
				ArkInventory.Frame_Main_DrawStatus( loc_id, ArkInventory.Const.Window.Draw.Refresh )
				
			end
			
		end
		
	end
	
	ArkInventory.CompanionDataUpdate( )
	
	bag.count = slot_id
	
	ArkInventory.ScanCleanup( cp, loc_id, bag_id, bag )
	
	ArkInventory.LDB.Mounts.Cleanup( )
	
	--ArkInventory.Frame_Main_Generate( loc_id, ArkInventory.Const.Window.Draw.Refresh )
	
	--ArkInventory.Output( "ScanMountJournal( ) end" )
	
end

function ArkInventory.ScanPetJournal( )
	
	--ArkInventory.Output( "ScanPetJournal( ) start" )
	
	local blizzard_id = ArkInventory.Const.Offset.Pet + 1
	local loc_id, bag_id = ArkInventory.BagID_Internal( blizzard_id )
	
	local player_id = ArkInventory.PlayerIDAccount( )
	local cp = ArkInventory.PlayerInfoGet( player_id )
	
	local bag = cp.location[loc_id].bag[bag_id]
	
	bag.count = 0
	bag.empty = 0
	bag.type = ArkInventory.BagType( blizzard_id )
	bag.status = ArkInventory.Const.Bag.Status.Active
	
	
	if ( not ArkInventory.PetJournal.JournalIsReady( ) ) then
		--ArkInventory.Output( "pet journal not ready" )
		ArkInventory:SendMessage( "LISTEN_PETJOURNAL_RELOAD_BUCKET", "RESCAN" )
		return
	end
	--ArkInventory.Output( "pet journal ready" )
	
	if ( ArkInventory.PetJournal.GetCount( ) == 0 ) then
		--ArkInventory.Output( "no pets" )
		return
	end
	
	if not ArkInventory.LocationIsMonitored( loc_id ) then
		--ArkInventory.Output( RED_FONT_COLOR_CODE, "aborted scan of bag id [", blizzard_id, "], location ", loc_id, " [", ArkInventory.Global.Location[loc_id].Name, "] is not being monitored" )
		return
	end
	
	--ArkInventory.Output( GREEN_FONT_COLOR_CODE, "scaning: ", ArkInventory.Global.Location[loc_id].Name, " [", loc_id, ".", bag_id, "] - [", blizzard_id, "]" )
	
	
	--ArkInventory.Output( "scanning pets [", ArkInventory.PetJournal.data.owned, "]" )
	
	local slot_id = 0
	
	cp.info.level = 1
	
	for _, pd in ArkInventory.PetJournal.Iterate( ) do
		
		slot_id = slot_id + 1
		
		if not bag.slot[slot_id] then
			bag.slot[slot_id] = {
				loc_id = loc_id,
				bag_id = bag_id,
				slot_id = slot_id,
			}
		end
		
		local i = bag.slot[slot_id]
		
		local h = pd.link
		--ArkInventory.Output( gsub( h, "|", "*" ) )
		
		local level = pd.level or 1
		
		if cp.info.level < level then
			-- save highest pet level for tint unusable
			cp.info.level = level
		end
		
		local count = 1
		local sb = ( ( not pd.sd.tradable ) and 1 ) or nil
		
		ArkInventory.ScanChanged( i, h, sb, count )
		
		i.h = h
		i.ab = 1
		i.sb = sb
		i.q = pd.rarity
		i.count = count
		i.guid = pd.guid
		i.bp = ( pd.sd.canBattle and 1 ) or nil
		i.wp = ( pd.sd.isWild and 1 ) or nil
		i.cn = pd.cn
		i.index = pd.index
		i.fav = pd.fav
		
	end
	
	bag.count = slot_id
	
	ArkInventory.ScanCleanup( cp, loc_id, bag_id, bag )
	
	ArkInventory.CompanionDataUpdate( )
	
	--ArkInventory.Frame_Main_Generate( loc_id, ArkInventory.Const.Window.Draw.Refresh )
	
	--ArkInventory.Output( "ScanPetJournal( ) end" )
	
end

function ArkInventory.ScanToybox( )
	
	--ArkInventory.Output( "ScanToybox( ) start" )
	
	if ( not ArkInventory.Toybox.JournalIsReady( ) ) then
		--ArkInventory.Output( "toybox journal not ready" )
		ArkInventory:SendMessage( "LISTEN_TOYBOX_RELOAD_BUCKET", "RESCAN" )
		return
	end
	--ArkInventory.Output( "toybox journal ready" )
	
	if ( ArkInventory.Toybox.GetCount( ) == 0 ) then
		--ArkInventory.Output( "no toys" )
		return
	end
	
	local blizzard_id = ArkInventory.Const.Offset.Toybox + 1
	local loc_id, bag_id = ArkInventory.BagID_Internal( blizzard_id )
	
	if not ArkInventory.LocationIsMonitored( loc_id ) then
		--ArkInventory.Output( RED_FONT_COLOR_CODE, "aborted scan of bag id [", blizzard_id, "], location ", loc_id, " [", ArkInventory.Global.Location[loc_id].Name, "] is not being monitored" )
		return
	end
	
	--ArkInventory.Output( GREEN_FONT_COLOR_CODE, "scaning: ", ArkInventory.Global.Location[loc_id].Name, " [", loc_id, ".", bag_id, "] - [", blizzard_id, "]" )
	
	local player_id = ArkInventory.PlayerIDAccount( )
	local cp = ArkInventory.PlayerInfoGet( player_id )
	
	local bag = cp.location[loc_id].bag[bag_id]
	
	bag.count = 0
	bag.empty = 0
	bag.type = ArkInventory.BagType( blizzard_id )
	bag.status = ArkInventory.Const.Bag.Status.Active
	
	--ArkInventory.Output( "scanning toybox [", ArkInventory.Toybox.data.owned, "]" )
	
	local slot_id = 0
	
	for _, td in ArkInventory.Toybox.Iterate( ) do
		
		slot_id = slot_id + 1
		
		if not bag.slot[slot_id] then
			bag.slot[slot_id] = {
				loc_id = loc_id,
				bag_id = bag_id,
				slot_id = slot_id,
			}
		end
		
		local i = bag.slot[slot_id]
		
		local h = td.link
		local sb = 1
		local count = 1
		
		ArkInventory.ScanChanged( i, h, sb, count )
		
		i.h = h
		i.count = count
		i.ab = 1
		i.sb = sb
		i.q = 1
		
		i.index = td.index
		i.item = td.item
		i.fav = td.fav
		
	end
	
	bag.count = slot_id
	
	ArkInventory.ScanCleanup( cp, loc_id, bag_id, bag )
	
	--ArkInventory.Frame_Main_Generate( loc_id, ArkInventory.Const.Window.Draw.Refresh )
	
	--ArkInventory.Output( "ScanToybox( ) end" )
	
end

function ArkInventory.ScanCurrency( )

	--ArkInventory.Output( "ScanCurrency( ) start" )
	
	local blizzard_id = ArkInventory.Const.Offset.Token + 1
	
	local loc_id, bag_id = ArkInventory.BagID_Internal( blizzard_id )

	if not ArkInventory.LocationIsMonitored( loc_id ) then
		--ArkInventory.Output( RED_FONT_COLOR_CODE, "aborted scan of bag id [", blizzard_id, "], location ", loc_id, " [", ArkInventory.Global.Location[loc_id].Name, "] is not being monitored" )
		return
	end
	
	--ArkInventory.Output( GREEN_FONT_COLOR_CODE, "scaning: ", ArkInventory.Global.Location[loc_id].Name, " [", loc_id, ".", bag_id, "] - [", blizzard_id, "]" )
	
	local numTokenTypes = GetCurrencyListSize( )
	
	if numTokenTypes == 0 then return end
	
	-- expand all currency headers
	for j = numTokenTypes, 1, -1 do
		local name, isHeader, isExpanded = GetCurrencyListInfo( j )
		if isHeader and not isExpanded then
			ExpandCurrencyList( j, 1 )
		end
	end
	
	local cp = ArkInventory.Global.Me
	
	local bag = cp.location[loc_id].bag[bag_id]
	
	local old_bag_count = bag.count
	
	bag.count = 0
	bag.empty = 0
	bag.type = ArkInventory.Const.Slot.Type.Token
	bag.status = ArkInventory.Const.Bag.Status.Active
	
	local slot_id = 0
	
	numTokenTypes = GetCurrencyListSize( )
	
	for j = 1, numTokenTypes do
	
		local name, isHeader, isExpanded, isUnused, isWatched, count, icon = GetCurrencyListInfo( j )
  
		if not isHeader and name and count and count > 0 then
			
			slot_id = slot_id + 1
			
			if not bag.slot[slot_id] then
				bag.slot[slot_id] = {
					loc_id = loc_id,
					bag_id = bag_id,
					slot_id = slot_id,
				}
			end
			
			local i = bag.slot[slot_id]
			local sb = 1
			local h = GetCurrencyListLink( j )
			local changed_item = ArkInventory.ScanChanged( i, h, sb, count )
			
			i.h = h
			i.count = count
			i.sb = sb
			
			if changed_item or i.loc_id == nil then
				
				i.age = ArkInventory.ItemAgeUpdate( )
				i.q = ArkInventory.ObjectInfoQuality( h )
				
				ArkInventory.Frame_Main_DrawStatus( loc_id, ArkInventory.Const.Window.Draw.Refresh )
				
			end
			
		end
		
	end
	
	bag.count = slot_id

	ArkInventory.ScanCleanup( cp, loc_id, bag_id, bag )
	
	-- token "bag" blizzard is using (mapped to our second bag)
	bag_id = 2
	bag = cp.location[loc_id].bag[bag_id]
	bag.count = 0
	bag.empty = 0
	bag.type = ArkInventory.Const.Slot.Type.Token
	bag.status = ArkInventory.Const.Bag.Status.NoAccess
	
end

local CanUseVoidStorage = CanUseVoidStorage or ArkInventory.HookDoNothing

function ArkInventory.ScanVoidStorage( blizzard_id )
	
	--ArkInventory.Output( "ScanVoidStorage" )
	
	if not CanUseVoidStorage( ) then
		--ArkInventory.Output( RED_FONT_COLOR_CODE, "aborted scan of void storage, storage not active" )
		return
	end
	
	if ArkInventory.Global.Mode.Void == false then
		--ArkInventory.Output( RED_FONT_COLOR_CODE, "aborted scan of void storage, not at npc" )
		return
	end
	
	local loc_id, bag_id = ArkInventory.BagID_Internal( blizzard_id )
	
	if not ArkInventory.LocationIsMonitored( loc_id ) then
		--ArkInventory.Output( RED_FONT_COLOR_CODE, "aborted scan of bag id [", blizzard_id, "], location ", loc_id, " [", ArkInventory.Global.Location[loc_id].Name, "] is not being monitored" )
		return
	end

	--ArkInventory.Output( GREEN_FONT_COLOR_CODE, "scaning: ", ArkInventory.Global.Location[loc_id].Name, " [", loc_id, ".", bag_id, "] - [", blizzard_id, "]" )
	
	local cp = ArkInventory.Global.Me
	
	local bag = cp.location[loc_id].bag[bag_id]
	
	bag.count = ArkInventory.Const.VOID_STORAGE_MAX
	bag.empty = 0
	bag.type = ArkInventory.BagType( blizzard_id )
	bag.status = ArkInventory.Const.Bag.Status.Active
	
	local blizzard_container_width = 10
	local blizzard_container_depth = 8

	for slot_id = 1, bag.count do
		
		if not bag.slot[slot_id] then
			bag.slot[slot_id] = { }
		end
		
		local i = bag.slot[slot_id]
		i.did = blizzard_container_width * ( ( slot_id - 1 ) % blizzard_container_depth ) + math.floor( ( slot_id - 1 ) / blizzard_container_depth ) + 1
		
		local item_id, texture, locked, recentDeposit, isFiltered, q = GetVoidItemInfo( bag_id, slot_id )
		
		local h = nil
		
		if item_id then
			h = select( 2, ArkInventory.ObjectInfo( "item:" .. item_id ) )
		end
		
		
		local count = 1
		local sb = 1
		
		if h then
			
			
		else
			
			bag.empty = bag.empty + 1
			
		end
		
		
		local changed_item = ArkInventory.ScanChanged( i, h, sb, count )

		if changed_item or i.loc_id == nil then
			
			i.age = ArkInventory.ItemAgeUpdate( )
			
			i.loc_id = loc_id
			i.bag_id = bag_id
			i.slot_id = slot_id
			
			i.h = h
			i.count = count
			i.sb = sb
			i.q = q
			
			ArkInventory.Frame_Item_Update( loc_id, bag_id, slot_id )
			ArkInventory:SendMessage( "LISTEN_CHANGER_UPDATE_BUCKET", loc_id )
			
			ArkInventory.Frame_Main_DrawStatus( loc_id, ArkInventory.Const.Window.Draw.Refresh )
			
		end
		
	end
	
	ArkInventory.ScanCleanup( cp, loc_id, bag_id, bag )
	
end

function ArkInventory.ScanChanged( old, h, sb, count )
	
	-- check for slot changes
	
	-- return item has changed, new status
	
	-- item counts are now reset here if required
	
	-- do not use the full hyperlink, pull out the itemstring part and check against that, theres a bug where the name isnt always included in the hyperlink

	if not h then
		
		-- slot is empty
		
		if old.h then
			
			-- previous item was removed
			ArkInventory.ItemCacheClear( old.h )
			ArkInventory.ScanCleanupCount( old.h, old.loc_id )
			
			--ArkInventory.Output( "changed, bag=", bag_id, ", slot=", i.slot_id, ", item removed" )
			return true, ArkInventory.Const.Slot.New.No
			
		end
		
	else
		
		-- slot has an item
		
		if ( not old.h ) then
			
			-- item added to previously empty slot
			ArkInventory.ItemCacheClear( h )
			ArkInventory.ScanCleanupCount( h, old.loc_id )
			
			--ArkInventory.Output( "changed, bag=", bag_id, ", slot=", i.slot_id, ", item added" )
			return true, ArkInventory.Const.Slot.New.Yes
			
		end
		
		--if ( ArkInventory.ObjectIDInternal( h ) ~= ArkInventory.ObjectIDInternal( old.h ) ) then
		if ( ArkInventory.ObjectIDTooltip( h ) ~= ArkInventory.ObjectIDTooltip( old.h ) ) then
			
			-- different item
			ArkInventory.ItemCacheClear( h )
			ArkInventory.ItemCacheClear( old.h )
			ArkInventory.ScanCleanupCount( old.h, old.loc_id )
			ArkInventory.ScanCleanupCount( h, old.loc_id )
			
			--ArkInventory.Output( "changed, bag=", bag_id, ", slot=", i.slot_id, ", item swapped" )
			return true, ArkInventory.Const.Slot.New.Yes
			
		end
		
		if ( sb ~= old.sb ) then
			
			-- soulbound changed
			ArkInventory.ItemCacheClear( old.h )
			
			--ArkInventory.Output( "changed, bag=", bag_id, ", slot=", i.slot_id, ", soulbound changed" )
			return true, ArkInventory.Const.Slot.New.Yes
			
		end
		
		if ( count ) and ( old.count ) and ( count ~= old.count ) then
			
			-- same item, previously existed, count has changed
			ArkInventory.ScanCleanupCount( old.h, old.loc_id )
			
			if count > old.count then
				--ArkInventory.Output( "changed, bag=", bag_id, ", slot=", i.slot_id, ", increased" )
				return true, ArkInventory.Const.Slot.New.Inc
			else
				--ArkInventory.Output( "changed, bag=", bag_id, ", slot=", i.slot_id, ", decreased" )
				ArkInventory.ScanCleanupCount( old.h, old.loc_id )
				return true, ArkInventory.Const.Slot.New.Dec
			end
			
		end
		
	end
	
end

function ArkInventory.ScanCleanupCount( h, loc_id )
	
	if not h or not loc_id then return end
	
	local h = ArkInventory.ObjectIDInternal( h )
	if not ArkInventoryScanCleanupList[h] then
		ArkInventoryScanCleanupList[h] = { }
	end
	
	ArkInventoryScanCleanupList[h][loc_id] = true
	
end

function ArkInventory.ScanCleanup( cp, loc_id, bag_id, bag )
	
	local num_slots = #bag.slot
	--ArkInventory.Output( "cleanup: loc=", loc_id, ", bag=", bag_id, ", count=", num_slots, " / ", bag.count )
	
	-- remove unwanted slots
	if num_slots > bag.count then
		
		for slot_id = bag.count + 1, num_slots do
			
			if bag.slot[slot_id] and bag.slot[slot_id].h then
				ArkInventory.ScanCleanupCount( bag.slot[slot_id].h, loc_id )
			end
			
			--ArkInventory.Output( "wiped bag ", bag_id, " slot ", slot_id )
			table.wipe( bag.slot[slot_id] )
			bag.slot[slot_id] = nil
			
		end
	end
	
	-- cleanup changed item counts
	for h, loc in pairs( ArkInventoryScanCleanupList ) do
		for loc_id in pairs( loc ) do
			--ArkInventory.Output( "reset count for ", h, " at loc ", loc_id )
			ArkInventory.ObjectCountClear( h, cp.info.player_id, loc_id )
		end
	end
	
	table.wipe( ArkInventoryScanCleanupList )
	
	-- recalculate total slots
	cp.location[loc_id].slot_count = ArkInventory.Table.Sum( cp.location[loc_id].bag, function( a ) return a.count end )
	
	-- if bag size has changed, let the changer window know
	if num_slots ~= bag.count then
		ArkInventory:SendMessage( "LISTEN_STORAGE_EVENT", ArkInventory.Const.Event.BagUpdate, loc_id, bag_id, ArkInventory.Const.Window.Draw.Recalculate )
	end
	
	ArkInventory.LDB.Tracking_Item:Update( )
	
end

function ArkInventory.ObjectInfoName( h )
	return ( select( 3, ArkInventory.ObjectInfo( h ) ) ) or "!"
end

function ArkInventory.ScanAuction( massive )
	
	local blizzard_id = ArkInventory.Const.Offset.Auction + 1
	
	local loc_id, bag_id = ArkInventory.BagID_Internal( blizzard_id )
	
	if ArkInventory.Global.Mode.Auction == false then
		--ArkInventory.Output( RED_FONT_COLOR_CODE, "aborted scan of auction house, not at auction house" )
		return
	end
	
	if not ArkInventory.LocationIsMonitored( loc_id ) then
		--ArkInventory.Output( RED_FONT_COLOR_CODE, "aborted scan of bag id [", blizzard_id, "], location ", loc_id, " [", ArkInventory.Global.Location[loc_id].Name, "] is not being monitored" )
		return
	end
	
	
	--ArkInventory.Output( GREEN_FONT_COLOR_CODE, "scaning: ", ArkInventory.Global.Location[loc_id].Name, " [", loc_id, ".", bag_id, "] - [", blizzard_id, "]" )
	
	local cp = ArkInventory.Global.Me
	
	local bag = cp.location[loc_id].bag[bag_id]
	
	local old_bag_count = bag.count
	
	local auctions = select( 2, GetNumAuctionItems( "owner" ) )
	
	if auctions > 100 and not massive then
		ArkInventory:SendMessage( "LISTEN_AUCTION_UPDATE_MASSIVE_BUCKET" )
		return
	end
	
	bag.count = auctions
	bag.empty = 0
	bag.type = ArkInventory.Const.Slot.Type.Auction
	bag.status = ArkInventory.Const.Bag.Status.Active
	
	for slot_id = 1, bag.count do
		
		if not bag.slot[slot_id] then
			bag.slot[slot_id] = {
				loc_id = loc_id,
				bag_id = bag_id,
				slot_id = slot_id,
			}
		end
		
		local i = bag.slot[slot_id]
		
		--ArkInventory.Output( "scanning auction ", slot_id, " of ", bag.count )
		
		local h = GetAuctionItemLink( "owner", slot_id )
		local name, texture, count, rarity, canUse, level, minBid, minIncrement, buyoutPrice, bidAmount, highestBidder, owner, sold = GetAuctionItemInfo( "owner", slot_id )
		local duration = GetAuctionItemTimeLeft( "owner", slot_id )
		local sb = nil
		
		--ArkInventory.Output( "auction ", slot_id, " / ", h, " / ", sold )
		
		if not h or sold == 1 then
			count = 1
			bag.empty = bag.empty + 1
			h = nil
			duration = nil
		end
		
		--ArkInventory.Output( "auction ", slot_id, " = ", h, " x ", count )
		
		local changed_item = ArkInventory.ScanChanged( i, h, sb, count )
		
		if changed_item then
			
			i.age = ArkInventory.ItemAgeUpdate( )
			
			i.h = h
			i.count = count
			i.sb = sb
			i.q = ArkInventory.ObjectInfoQuality( h )
			
			if duration == 1 then
				-- Short (less than 30 minutes)
				i.expires = i.age + 30
			elseif duration == 2 then
				-- Medium (30 minutes to 2 hours)
				i.expires = i.age + 2 * 60
			elseif duration == 3 then
				-- Long (2 hours to 12 hours)
				i.expires = i.age + 12 * 60
			elseif duration == 4 then
				-- Very Long (more than 12 hours)
				i.expires = i.age + 48 * 60
			end
			
			ArkInventory.Frame_Main_DrawStatus( loc_id, ArkInventory.Const.Window.Draw.Refresh )
			
		end
		
	end
	
	ArkInventory.ScanCleanup( cp, loc_id, bag_id, bag )
	
end

function ArkInventory.ScanAuctionExpire( )
	
	local blizzard_id = ArkInventory.Const.Offset.Auction + 1
	
	local loc_id, bag_id = ArkInventory.BagID_Internal( blizzard_id )
	
	local current_time = ArkInventory.ItemAgeUpdate( )
	
	local cp = ArkInventory.Global.Me
	
	local bag = cp.location[loc_id].bag[bag_id]
	
	for slot_id = 1, bag.count do
		
		local i = bag.slot[slot_id]
		
		if i.h then
			
			if ( i.expires and ( i.expires < current_time ) ) or ( i.age and ( i.age + 48 * 60 < current_time ) ) then
				
				ArkInventory.ObjectCountClear( i.h )
				
				table.wipe( i )
				
				i.loc_id = loc_id
				i.bag_id = bag_id
				i.slot_id = slot_id
				
				i.count = 1
				bag.empty = bag.empty + 1
				
			end
			
		end
		
	end
	
	ArkInventory:SendMessage( "LISTEN_STORAGE_EVENT", ArkInventory.Const.Event.BagUpdate, loc_id, bag_id, ArkInventory.Const.Window.Draw.Refresh )
	
end

function ArkInventory.ScanSpellbook( )
	
	if true then return end -- not enabled yet
	
	local blizzard_id = ArkInventory.Const.Offset.Spellbook + 1
	
	local loc_id = ArkInventory.BagID_Internal( blizzard_id )
	
	if not ArkInventory.LocationIsMonitored( loc_id ) then
		--ArkInventory.Output( RED_FONT_COLOR_CODE, "aborted scan of bag id [", blizzard_id, "], location ", loc_id, " [", ArkInventory.Global.Location[loc_id].Name, "] is not being monitored" )
		return
	end
	
	
	--ArkInventory.Output( GREEN_FONT_COLOR_CODE, "scaning: ", ArkInventory.Global.Location[loc_id].Name, " [", loc_id, ".", bag_id, "] - [", blizzard_id, "]" )
	
	local cp = ArkInventory.Global.Me
	
	local numTabs = GetNumSpellTabs( )
	
	for bag_id = 1, numTabs do
		
		local bag = cp.location[loc_id].bag[bag_id]
		
		local old_bag_count = bag.count
		
		local name, texture, offset, numSpells = GetSpellTabInfo( bag_id )

		bag.count = numSpells
		bag.empty = 0
		bag.type = ArkInventory.Const.Slot.Type.Spellbook
		bag.status = ArkInventory.Const.Bag.Status.Active
		bag.texture = texture
		
		for slot_id = 1, bag.count do
			
			if not bag.slot[slot_id] then
				bag.slot[slot_id] = { }
			end
			
			local i = bag.slot[slot_id]
			
			--ArkInventory.Output( "scanning spellbook tab ", bag_id, ", slot ", slot_id + offset )
			
			local h = GetSpellLink( slot_id + offset, "spell")
			--local name, rank, icon, powerCost, isFunnel, powerType, castingTime, minRange, maxRange = GetSpellInfo( slot_id + offset, "spell")
			local rarity = 1
			local sb = 1
			local count = 1
			
			--ArkInventory.Output( "spellbook ", bag_id, " / ", slot_id, " / ", h )
			
			if not h then
				bag.empty = bag.empty + 1
				h = nil
			end
			
			local changed_item = ArkInventory.ScanChanged( i, h, sb, count )
			
			if changed_item or i.loc_id == nil then
				
				table.wipe( i )
				
				i.loc_id = loc_id
				i.bag_id = bag_id
				i.slot_id = slot_id
				
				i.h = h
				i.count = count
				i.sb = sb
				i.q = ArkInventory.ObjectInfoQuality( h )
				
				ArkInventory.Frame_Main_DrawStatus( loc_id, ArkInventory.Const.Window.Draw.Refresh )
				
			end
			
		end
		
		ArkInventory.ScanCleanup( cp, loc_id, bag_id, bag )
		
	end
	
end


function ArkInventory.ScanTradeskillWindow( )
	
	if IsTradeSkillLinked( ) then
		-- dont care about other players
		return
	end
	
	local restore_ShowSkillUps = TradeSkillFrame.filterTbl.hasSkillUp
	TradeSkillOnlyShowSkillUps( false )
	
	local restore_OnlyShowMakeable = TradeSkillFrame.filterTbl.hasMaterials
	TradeSkillOnlyShowMakeable( false )
	
	local restore_SubClassFilter = -1
	for _, index in pairs( { GetTradeSkillSubClasses( ) } ) do
		if GetTradeSkillSubClassFilter( index ) then
			restore_SubClassFilter = index
		end
	end
	SetTradeSkillSubClassFilter( -1, 1, 1 )
	
	
	local restore_InvSlotFilter = -1
	for _, index in pairs( { GetTradeSkillInvSlots( ) } ) do
		if GetTradeSkillInvSlotFilter( index ) then
			restore_InvSlotFilter = index
		end
	end
	SetTradeSkillInvSlotFilter( -1, 1, 1 )
	
	local restore_ItemLevelFilter_min, restore_ItemLevelFilter_max = GetTradeSkillItemLevelFilter( )
	SetTradeSkillItemLevelFilter( 0, 0 )
	
	local restore_ItemNameFilter = GetTradeSkillItemNameFilter( )
	SetTradeSkillItemNameFilter( nil )
	
	
	-- expand all categories
	local restore_header = { }
	local numSkills = GetNumTradeSkills( )
	local header = 0
	for index = numSkills, 1, -1 do
		local skillName, skillType, numAvailable, isExpanded, serviceType, numSkillUps = GetTradeSkillInfo( index )
		if skillType == "header" then
			header = header + 1
			restore_header[header] = isExpanded
			if not isExpanded then
				ExpandTradeSkillSubClass( index )
			end
		end
	end
	
	numSkills = GetNumTradeSkills( )
	ArkInventory.Output( "numSkills=", numSkills )
	for index = 1, numSkills do
		local skillName, skillType, numAvailable, isExpanded, serviceType, numSkillUps = GetTradeSkillInfo( index )
		if skillType ~= "header" then
			local h = GetTradeSkillRecipeLink( index )
			ArkInventory.Output( index, " = ", skillName, " / ", skillType, " / ", h )
		end
	end
	
	
	
	-- restore filters
	TradeSkillOnlyShowSkillUps( restore_ShowSkillUps )
	TradeSkillOnlyShowMakeable( restore_OnlyShowMakeable )
	SetTradeSkillSubClassFilter( restore_SubClassFilter, 1, 1 )
	SetTradeSkillInvSlotFilter( restore_InvSlotFilter, 1, 1 )
	SetTradeSkillItemLevelFilter( restore_ItemLevelFilter_min, restore_ItemLevelFilter_max )
	SetTradeSkillItemNameFilter( restore_ItemNameFilter )
	
	-- restore collapsed headers
	numSkills = GetNumTradeSkills( )
	header = 0
	for index = numSkills, 1, -1 do
		local skillName, skillType, numAvailable, isExpanded, serviceType, numSkillUps = GetTradeSkillInfo( index )
		if skillType == "header" then
			header = header + 1
			if not restore_header[header] then
				CollapseTradeSkillSubClass( index )
			end
		end
	end
	
end

function ArkInventory.ScanTradeskill( )
	
	if true then return end -- not enabled yet
	
	local blizzard_id = ArkInventory.Const.Offset.Tradeskill + 1
	
	local loc_id = ArkInventory.BagID_Internal( blizzard_id )
	
	if not ArkInventory.LocationIsMonitored( loc_id ) then
		--ArkInventory.Output( RED_FONT_COLOR_CODE, "aborted scan of bag id [", blizzard_id, "], location ", loc_id, " [", ArkInventory.Global.Location[loc_id].Name, "] is not being monitored" )
		return
	end
	
	
	--ArkInventory.Output( GREEN_FONT_COLOR_CODE, "scaning: ", ArkInventory.Global.Location[loc_id].Name, " [", loc_id, ".", bag_id, "] - [", blizzard_id, "]" )
	
	local cp = ArkInventory.Global.Me
	
	local prof = { GetProfessions( ) }
	
	for bag_id = 1, 6 do
		
		local bag = cp.location[loc_id].bag[bag_id]
		
		local old_bag_count = bag.count
		
		bag.count = 0
		bag.empty = 0
		bag.type = ArkInventory.Const.Slot.Type.Tradeskill
		bag.status = ArkInventory.Const.Bag.Status.Active
		bag.texture = [[Interface\\Icons\\INV_Scroll_04]]
		
		local index = prof[bag_id]
		
		if index then
			
			local name, texture, rank, maxRank, numSpells, spelloffset, skillLine, rankModifier = GetProfessionInfo( index )
			bag.texture = texture
			
			CastSpell( 1 + spelloffset, BOOKTYPE_PROFESSION )
			
			
			
			local numSkills = GetNumTradeSkills( )
			--ArkInventory.Output( "tradeskill ", bag_id, " = ", name, ", ", numSkills )
			
			
			
			local slot_id = 0
			
			for skillIndex = 1, bag.count do
				
				local skillName, skillType, numAvailable, isExpanded, altVerb, numSkillUps = GetTradeSkillInfo( skillIndex )
				
				
				if not bag.slot[slot_id] then
					bag.slot[slot_id] = { }
				end
				
				local i = bag.slot[slot_id]
				
				--ArkInventory.Output( "scanning tradeskill ", bag_id, ", slot ", slot_id + offset )
				
				local h --= GetSpellLink( slot_id + offset, "spell")
				
				local rarity = 1
				local sb = 1
				local count = 1
				
				
				if not h then
					bag.empty = bag.empty + 1
					h = nil
				end
				
				local changed_item, new = ArkInventory.ScanChanged( i, h, sb, count )
				
				if changed_item or i.loc_id == nil then
					
					table.wipe( i )
					
					i.loc_id = loc_id
					i.bag_id = bag_id
					i.slot_id = slot_id
					
					i.h = h
					i.count = count
					i.sb = sb
					i.q = ArkInventory.ObjectInfoQuality( h )
					
					ArkInventory.Frame_Main_DrawStatus( loc_id, ArkInventory.Const.Window.Draw.Refresh )
					
				end
				
			end
			
		end
		
		ArkInventory.ScanCleanup( cp, loc_id, bag_id, bag )
		
	end
	
end


function ArkInventory.ObjectInfoTexture( h )
	return ( select( 4, ArkInventory.ObjectInfo( h ) ) )
end

function ArkInventory.ObjectInfoQuality( h )
	return ( select( 5, ArkInventory.ObjectInfo( h ) ) ) or 1
end

function ArkInventory.ObjectInfo( h )
	
	if h == nil or type( h ) ~= "string" then
		return
	end
	
	local class, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10 = ArkInventory.ObjectStringDecode( h )
	
	if ( class == "item" ) then
		
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo( h )
		
		if itemTexture == nil then
			itemTexture = GetItemIcon( h )
		end
		
		if not itemName then
			itemName = string.match( h, "|h%[(.+)%]|h" )
		end
		
		if ( ( itemRarity or 0 ) > 2 ) and ( ( itemEquipLoc or "" ) ~= "" ) then
			
			-- check for upgraded items via tooltip: Upgrade Level: v1/v2
			ArkInventory.TooltipSetHyperlink( ArkInventory.Global.Tooltip.Scan, h )
			local _, _, u1, u2 = ArkInventory.TooltipFind( ArkInventory.Global.Tooltip.Scan, ArkInventory.Localise["WOW_TOOLTIP_ITEMUPGRADELEVEL"], false, true )
			
			if u1 and u2 then
				if ( itemRarity == 3 ) then
					itemLevel = ( itemLevel or 0 ) + u1 * 8
				elseif ( itemRarity == 4 ) then
					itemLevel = ( itemLevel or 0 ) + u1 * 4
				end
			end
			
		end
		
		return class, itemLink, itemName, itemTexture, itemRarity or 0, itemLevel or 0, itemMinLevel or 0, itemType or "", itemSubType or "", itemStackCount or 1, itemEquipLoc or "", itemSellPrice or 0
		
	elseif ( class == "spell" ) then
		
		local itemName, _, itemTexture = GetSpellInfo( v1 )
		local itemLink = GetSpellLink( v1 )
		local itemRarity = 1
		
		return class, itemLink, itemName, itemTexture, itemRarity
		
	elseif ( class == "battlepet" ) then
		
		local sd = ArkInventory.PetJournal.GetSpeciesInfo( v1 )
--		v1=speciesID, v2=level, v3=rarity, v4=maxHealth, v5=power, v6=speed, v7=GUID
		
		local name = ""
		local icon = ArkInventory.Const.Texture.Missing
		local petType = 0
		
		if sd then
			name = sd.name or name
			icon = sd.icon or icon
			petType = sd.petType or petType
		end
		
		return class, h, name, icon, v3, v2, 0, petType, "", 1, "", 0, v1, v2, v4, v5, v6, v7, v8, v9, v10
		
	elseif ( class == "currency" ) then
		
		-- v1=currencyID
		
		local itemLink = GetCurrencyLink( v1 )
		local itemName, amount, itemTexture = GetCurrencyInfo( v1 )
		if not string.find( itemTexture, "\\" ) then
			itemTexture = string.format( "Interface\\Icons\\%s", itemTexture )
		end
		
		return class, itemLink, itemName, itemTexture, 1, 0, 0, "", "", 0, "", 0, amount
		
	end
	
end

function ArkInventory.ObjectStringHyperlinkBase( h )
	return string.match( ( h or "" ), "|H(.-)|h" ) or string.match( ( h or "" ), "^([a-z]-:.+)" )
end

function ArkInventory.ObjectStringDecode( h )
	
	-- item:(1)itemID:(2)enchant:(3)gem1:(4)gem2:(5)gem3:(6)gem4:(7)suffix:(8)unique:(9)linklevel:(10)upgrade:(11)instanceDifficulty:(12)numBonusIDs:(13)bonusID1:(14)bonusID2:...
	-- battlepet:(1)speciesID:(2)level:(3)rarity:(4)health:(5)power:(6)speed:(7)guid(BattlePet-[unknown]-[creatureID])
	-- spell:spellID
	-- currency:currencyID
	
	local s = string.match( ( h or "" ), "|H(.-)|h" ) or string.match( ( h or "" ), "^([a-z]-:.+)" ) or ""
	local class, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12 = strsplit( ":", s )
	class = string.lower( class or "" )
	
	if class == "" then
		class = "empty"
	end
	
	v1 = tonumber( v1 ) or 0
	v2 = tonumber( v2 ) or 0
	v3 = tonumber( v3 ) or 0
	v4 = tonumber( v4 ) or 0
	v5 = tonumber( v5 ) or 0
	v6 = tonumber( v6 ) or 0
	if ( class ~= "battlepet" ) then
		v7 = tonumber( v7 ) or 0
	end
	v8 = tonumber( v8 ) or 0
	v9 = tonumber( v9 ) or 0
	v10 = tonumber( v10 ) or 0
	v11 = tonumber( v11 ) or 0
	v12 = tonumber( v12 ) or 0
	
	return class, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12
	
end

function ArkInventory.ObjectStringDecodeItem( h )
	
	local h = h
	if type( h ) == "number" then
		h = string.format( "item:%s", h )
	end
	
	local class, id, enchant, j1, j2, j3, j4, suffix, unique = ArkInventory.ObjectStringDecode( h )
	
	if class == "item" then
		return id, suffix, enchant, j1, j2, j3, j4
	end
	
end

function ArkInventory.GetItemQualityColor( rarity )
	
	local rarity = rarity or -1
	
	if ( rarity == -1 ) then
		return NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, string.sub( NORMAL_FONT_COLOR_CODE, 3 ), NORMAL_FONT_COLOR_CODE
	else
		local r, g, b, c = GetItemQualityColor( rarity )
		return r, g, b, c, string.format( "|c%s", c )
	end
	
end

function ArkInventory.ScanProfessions( )
	
	--ArkInventory.Output( "ScanProfessions" )
	
	local p = { GetProfessions( ) }
	--ArkInventory.Output( "skills = [", p, "]" )
	
	ArkInventory.Global.Me.info.skills = ArkInventory.Global.Me.info.skills or { }
	
	for index = 1, ArkInventory.Const.Skills.Primary + ArkInventory.Const.Skills.Secondary do
		
		if p[index] then
			--local name, texture, rank, maxRank, numSpells, spelloffset, skillLine, rankModifier = GetProfessionInfo( p[index] )
			--ArkInventory.Output( "skill [", index, "] = [", skillLine, "] [", name, "]" )
			local skillLine = select( 7, GetProfessionInfo( p[index] ) )
			ArkInventory.Global.Me.info.skills[index] = skillLine
		else
			ArkInventory.Global.Me.info.skills[index] = nil
			--ArkInventory.Output( "skill [", index, "] = [", skillLine, "] [", name, "]" )
		end
		
	end

	ArkInventory.Table.Clean( ArkInventory.Global.Cache.Default )
	ArkInventory.LocationSetValue( nil, "resort", true )
	
end

function ArkInventory.InventoryIDGet( loc_id, bag_id )
	
	local blizzard_id = ArkInventory.BagID_Blizzard( loc_id, bag_id )
	
	if blizzard_id == nil then
		return nil
	end
	
	if loc_id == ArkInventory.Const.Location.Bag and bag_id > 1 then
		
		return ContainerIDToInventoryID( blizzard_id )
		
	elseif loc_id == ArkInventory.Const.Location.Bank then
		
		if bag_id == ArkInventory.Global.Location[loc_id].tabReagent then
			
		elseif bag_id > 1 then
			
			return ContainerIDToInventoryID( blizzard_id )
			
		end
		
	end
	
end


function ArkInventory.ObjectIDInternal( h )

	local class, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10 = ArkInventory.ObjectStringDecode( h )
	
	if class == "item" then
		return string.format( "%s:%s:%s:%s:%s:%s:%s:%s:%s", class, v1, v2, v7, v3, v4, v5, v6, v10 )
	elseif class == "empty" then
		return string.format( "%s:%s", class, v1 )
	elseif class == "spell" then
		return string.format( "%s:%s", class, v1 )
	elseif class == "battlepet" then
		return string.format( "%s:%s:%s", class, v1, v2 )
	elseif class == "currency" then
		return string.format( "%s:%s", class, v1 )
	else
		error( string.format( "code failure: uncoded class [%s] for object %s", class, h ) )
	end
	
end

function ArkInventory.ObjectIDTooltip( h )
	
	local class, v1, v2 = ArkInventory.ObjectStringDecode( h )
	
	--ArkInventory.Output( "class[", class, "] : [", v1, "] : [", v2, "]" )
	
	if class == "item" then
		return string.format( "%s:%s", class, v1 )
	elseif class == "empty" then
		return string.format( "%s:%s", class, v1 )
	elseif class == "spell" then
		return string.format( "%s:%s", class, v1 )
	elseif class == "battlepet" then
		return string.format( "%s:%s", class, v1 )
	elseif class == "currency" then
		return string.format( "%s:%s", class, v1 )
	else
		error( string.format( "code failure: uncoded object class [%s]", class ) )
	end

end

function ArkInventory.ObjectIDCacheCategory( loc_id, bag_id, sb, h )
	
	local soulbound = ( sb and 1 ) or 0
	
	if not h then
		-- empty slots
		local blizzard_id = ArkInventory.BagID_Blizzard( loc_id, bag_id )
		soulbound = ArkInventory.BagType( blizzard_id ) -- allows for unique codes per bag type
	end
	
	local class, v1 = ArkInventory.ObjectStringDecode( h )
	
	if class == "item" then
		return string.format( "%s:%s:%s", class, v1, soulbound )
	elseif class == "empty" then
		return string.format( "%s:%s:%s", class, 0, soulbound )
	elseif class == "spell" then
		return string.format( "%s:%s", class, v1 )
	elseif class == "battlepet" then
		return string.format( "%s:%s:%s", class, v1, soulbound )
	elseif class == "currency" then
		return string.format( "%s:%s", class, v1 )
	else
		error( string.format( "code failure: unknown object class [%s]", class ) )
	end

end

function ArkInventory.ObjectIDCacheRule( loc_id, bag_id, sb, h )
	
	return string.format( "%i:%i:%i:%s", loc_id or 0, bag_id or 0, ( sb and 1 ) or 0, ArkInventory.ObjectIDInternal( h ) )
	
end

function ArkInventory.ObjectCountClear( search_id, player_id, loc_id )
	
	if search_id then
		search_id = ArkInventory.ObjectIDTooltip( search_id )
	end
	
	if (search_id ) and ( player_id ) and (loc_id ) then
		
		-- clear the current user, then move down and do the "shared" user
		
		if player_id == ArkInventory.PlayerIDAccount( ) or ( loc_id == ArkInventory.Const.Location.Vault ) or ( loc_id == ArkInventory.Const.Location.Pet ) or ( loc_id == ArkInventory.Const.Location.Mount ) or ( loc_id == ArkInventory.Const.Location.Toybox ) then
			ArkInventory.ObjectCountClear( search_id, ArkInventory.Global.Me.info.player_id )
		end
		
	end
	
	if ( search_id ) and ( player_id ) then
		
		-- reset count for a specific item for a specific player
		--ArkInventory.Output( "ObjectCountClear( ", search_id, ", ", player_id )
		
		if ArkInventory.Global.Cache.ItemCountTooltip[player_id] then
			ArkInventory.Global.Cache.ItemCountTooltip[player_id][search_id] = nil
		end
		
		if ArkInventory.Global.Cache.ItemCount[player_id] then
			ArkInventory.Global.Cache.ItemCount[player_id][search_id] = nil
		end
		
		if ArkInventory.Global.Cache.ItemCountRaw[search_id] then
			ArkInventory.Global.Cache.ItemCountRaw[search_id][player_id] = nil
		end
		
		if search_alt then
			
			for k in pairs( search_alt ) do
				
				if ArkInventory.Global.Cache.ItemCountTooltip[player_id] then
					ArkInventory.Global.Cache.ItemCountTooltip[player_id][k] = nil
				end
				
				if ArkInventory.Global.Cache.ItemCount[player_id] then
					ArkInventory.Global.Cache.ItemCount[player_id][k] = nil
				end
				
				if ArkInventory.Global.Cache.ItemCountRaw[k] then
					ArkInventory.Global.Cache.ItemCountRaw[k][player_id] = nil
				end
				
			end
			
		end
		
		return
		
	end
	
	if ( search_id ) and ( not player_id ) then
		
		-- reset count for a specific item for all players
		--ArkInventory.Output( "ObjectCountClear( ", search_id, " )" )
		
		for k, v in pairs( ArkInventory.Global.Cache.ItemCountTooltip ) do
			v[search_id] = nil
		end
		
		for k, v in pairs( ArkInventory.Global.Cache.ItemCount ) do
			v[search_id] = nil
		end
		
		ArkInventory.Global.Cache.ItemCountRaw[search_id] = nil
		
		-- erase item/tooltip cache
		ArkInventory.Table.Clean( ArkInventory.Global.Cache.ItemCountTooltip, nil, true )
		ArkInventory.Table.Clean( ArkInventory.Global.Cache.ItemCountRaw, nil, true )
		ArkInventory.Table.Clean( ArkInventory.Global.Cache.ItemCount, nil, true )

		return
		
	end
	
	if ( not search_id ) and ( not player_id ) then
		
		--ArkInventory.Output( "wipe all item counts" )
		ArkInventory.Output( "ObjectCountClear( )" )
		
		table.wipe( ArkInventory.Global.Cache.ItemCountTooltip )
		
		table.wipe( ArkInventory.Global.Cache.ItemCount )
		
		if ArkInventory.Global.Cache.ItemCountRaw[ArkInventory.Global.Me.info.player_id] then
			table.wipe( ArkInventory.Global.Cache.ItemCountRaw[ArkInventory.Global.Me.info.player_id] )
		end
		
		return
		
	end
	
end

function ArkInventory.ObjectCountGetRaw( search_id )
	
	local search_id = ArkInventory.ObjectIDTooltip( search_id )
--	ArkInventory.Output( "get raw count for [", search_id, "]" )
	
	if not ArkInventory.Global.Cache.ItemCountRaw[search_id] then
		ArkInventory.Global.Cache.ItemCountRaw[search_id] = { }
	end
	
	local d = ArkInventory.Global.Cache.ItemCountRaw[search_id]
	
	local search_alt = ArkInventory.Const.ItemCrossReference[search_id]
--	if search_alt then
--		ArkInventory.Output( "alt search: ", search_id, " = ", search_alt )
--	end
	
	local c, k, tabs
	
	for pid, pd in pairs( ArkInventory.db.global.player.data ) do
		
		if pd.info.name then
			
			if not d[pid] then
				d[pid] = { ["vault"] = false, ["location"] = { }, ["faction"] = pd.info.faction, ["realm"] = pd.info.realm }
			end
			
			--ArkInventory.Output( "rebuild ", search_id, " for ", pid )
			
			for l in pairs( ArkInventory.Global.Location ) do
				
				if not d[pid].location[l] then
					
					-- rebuild missing location data
					
					local ld = pd.location[l]
					
					--ArkInventory.Output( "scanning location [", l, "] for item [", search_id, "]" )
					c = 0
					k = false
					tabs = ""
					
					for b in pairs( ArkInventory.Global.Location[l].Bags ) do
						
						local bd = ld.bag[b]
						
						k = false
						
						if bd.h and search_id == ArkInventory.ObjectIDTooltip( bd.h ) then
							--ArkInventory.Output( "found bag [", b, "] equipped" )
							c = c + 1
							k = true
						end
						
						for sn, sd in pairs( bd.slot ) do
							
							if sd and sd.h then
								
								-- primary match
								local oit = ArkInventory.ObjectIDTooltip( sd.h )
								local matches = ( search_id == oit )
								
								-- secondary match
								if not matches and search_alt then
									for sa in pairs( search_alt ) do
										if sa == oit then
											matches = true
											break
										end
									end
								end
								
								if matches then
									--ArkInventory.Output( pid, " has ", sd.count, " x ", sd.h, " in loc[", l, "], bag [", b, "] slot [", sn, "]" )
									c = c + sd.count
									k = true
								end
								
							end
							
						end
						
						if k and l == ArkInventory.Const.Location.Vault then
							tabs = string.format( "%s%s, ", tabs, b )
						end
						
					end
					
					if c > 0 then
						
						if pd.info.class == "GUILD" and l == ArkInventory.Const.Location.Vault then
							d[pid].vault = true
							d[pid].tabs = string.sub( tabs, 1, string.len( tabs ) - 2 )
						end
						
						d[pid].location[l] = c
						
					end
					
				end
				
			end
			
		end
		
	end
	
end

function ArkInventory.ObjectCountGet( search_id, player_id, just_me, ignore_vaults, ignore_other_faction, my_realm, include_crossrealm )
	
	local search_id = ArkInventory.ObjectIDTooltip( search_id )
	--ArkInventory.Output( "ObjectCountGet [", search_id, "] [", player_id, "]" )
	
	ArkInventory.ObjectCountGetRaw( search_id )
	
	local player_id = player_id or ArkInventory.Global.Me.info.player_id
	
	if not ArkInventory.Global.Cache.ItemCount[player_id] then
		ArkInventory.Global.Cache.ItemCount[player_id] = { }
	end
	
	if ArkInventory.Global.Cache.ItemCount[player_id][search_id] then
		--ArkInventory.Output( "cached [", player_id, "] [", search_id, "]" )
		return ArkInventory.Global.Cache.ItemCount[player_id][search_id]
	else
		ArkInventory.Global.Cache.ItemCount[player_id][search_id] = {
--			["location"] = {
--				[loc_id] = number (count),
--			},
--			["total"] = number,
--			["vault"] = boolean,
--			["tabs"] = string ("1, 2, 3, 4, 5, 6, 7, 8")
--			["faction"] = string (system),
--			["realm"] = string (system),
--			["class"] = string (system),
		}
	end
	
	-- build return
	local cp = ArkInventory.PlayerInfoGet( player_id )
	
	--ArkInventory.Output( "reference [", cp.info.name, "] [", cp.info.realm, "] [", cp.info.faction, "]" )
	
	local d = ArkInventory.Global.Cache.ItemCount[player_id][search_id]
	
	for rcn, rcd in pairs( ArkInventory.Global.Cache.ItemCountRaw[search_id] ) do
		
		if ( rcn == ArkInventory.PlayerIDAccount( ) ) or ( not my_realm ) or ( ( my_realm and ( ( rcd.realm == cp.info.realm ) ) ) or ( my_realm and include_crossrealm and ArkInventory.IsConnectedRealm( rcd.realm, cp.info.realm ) ) ) then
		if ( rcn == ArkInventory.PlayerIDAccount( ) ) or ( not ignore_other_faction ) or ( ignore_other_faction and ( ( rcd.faction == cp.info.faction ) ) ) then
		if ( rcn == ArkInventory.PlayerIDAccount( ) ) or ( not just_me ) or ( just_me and ( ( rcn == cp.info.player_id ) ) ) then
				
				for l, c in pairs( rcd.location ) do
					
					local ok = true
					
					if ignore_vaults and rcd.vault then
						ok = false
					end
					
					if ok then
						
						if c > 0 then
							
							if not d[rcn] then
								d[rcn] = { ["vault"] = rcd.vault, ["tabs"] = rcd.tabs, ["location"] = { }, ["total"] = 0 } -- , ["realm"] = rcd.realm, ["faction"] = rcd.faction
							end
							
							d[rcn].location[l] = c
							d[rcn].total = d[rcn].total + c
							
						end
						
					end
					
				end
				
		end
		end
		end
		
	end
	
	table.sort( d )
	return d
	
end

function ArkInventory.BattlepetBaseHyperlink( ... )
	local v = { ... } -- species, level, rarity, maxHealth, power, speed, name (not used)
	--ArkInventory.Output( "[ ", v[1], " / ", v[2], " / ", v[3], " / ", v[4], " / ", v[5], " / ", v[6], " / ", v[7], " ]" )
	return string.format( "battlepet:%s:%s:%s:%s:%s:%s:0", v[1] or 0, v[2] or 0, v[3] or 0, v[4] or 0, v[5] or 0, v[6] or 0 )
end
