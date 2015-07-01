local _G = _G
local select = _G.select
local pairs = _G.pairs
local ipairs = _G.ipairs
local string = _G.string
local type = _G.type
local error = _G.error
local table = _G.table



function ArkInventory.RestackString( )
	if ArkInventory.db.global.option.restack.blizzard then
		return ArkInventory.Localise["CLEANUP"]
	else
		return ArkInventory.Localise["RESTACK"]
	end
end

local function RestackAbort( loc_id )
	ArkInventory.OutputError( ArkInventory.RestackString( ), ": ", ArkInventory.Global.Location[loc_id].Name, " " , ArkInventory.Localise["ABORTED"] )
	exit( )
end

local function RestackBagCheck( loc_id, bag_id )
	
	local count = GetContainerNumSlots( bag_id )
	
	if count == 0 then
		return nil, 0
	end
	
	local _, bt = GetContainerNumFreeSlots( bag_id )
	
	if bt == nil then
		-- no longer at location, abort
		RestackAbort( loc_id )
	end
	
	return bt, count
	
end


local function FindStack( loc_id, cl, cb, bp, cs, id )
	
	--ArkInventory.Output( "FindStack( ", loc_id, ", ", cl, ".", cb, ".", cs, ", ", id, " )" )
	
	local recheck = false
	local cl = cl or loc_id
	local cb = cb or 9999
	local bp = bp or -1
	local cs = cs or -1
	
	for _, bag_id in ipairs( ArkInventory.Global.Location[loc_id].Bags ) do
		
		if not ArkInventory.Global.Me.bagoptions[loc_id][bag_id].restack.ignore then
			
			for slot_id = GetContainerNumSlots( bag_id ), 1, -1 do
				
				RestackBagCheck( loc_id, bag_id )
				
				if cl == ArkInventory.Const.Location.Bank and not ArkInventory.Global.Mode.Bank then
					-- no longer at bank, abort
					RestackAbort( loc_id )
				end
				
				if cl == ArkInventory.Const.Location.Vault and not ArkInventory.Global.Mode.Vault then
					-- no longer at vault, abort
					RestackAbort( loc_id )
				end
				
				if select( 3, GetContainerItemInfo( bag_id, slot_id ) ) then
				
					-- this slot is locked, move on and check it again next time
					--ArkInventory.Output( "locked> ", loc_id, ".", bag_id, ".", slot_id )
					recheck = true
					
				else
					
					if ( loc_id ~= cl ) or ( loc_id == cl and zz > bp ) or ( loc_id == cl and zz == bp and slot_id > cs )then
					-- ( different location ) or (same location and higher bag) or (same location and same bag and higher slot)
						
						local h = GetContainerItemLink( bag_id, slot_id )
						
						if h then
							
							local osd = ArkInventory.ObjectStringDecode( h )
							local item_id = osd[2]
							
							if item_id == id then
								
								--ArkInventory.Output( "found> ", loc_id, ".", bag_id, ".", slot_id )
								return true, bag_id, slot_id, recheck
								
							end
							
						end
						
					end
					
				end
				
			end
		
		end
		
	end
	
	if recheck then
		coroutine.yield( )
		return FindStack( loc_id, cl, cb, bp, cs, id )
	end
	
	--ArkInventory.Output( "no stacks found" )
	return false, nil, nil, recheck
	
end

local function FindPartialStack( loc_id, cl, cb, bp, cs, id )
	
	--ArkInventory.OutputDebug( "FindPartialStack( ", cl, ".", cb, ".", cs, ", ", id, " )" )
	
	local recheck = false
	local cl = cl or loc_id
	local cb = cb or 9999
	local bp = bp or -1
	local cs = cs or -1
	
	
	if cl == ArkInventory.Const.Location.Vault then
		
		local bag_id = cb
		
		for slot_id = MAX_GUILDBANK_SLOTS_PER_TAB, 1, -1 do
			
			if not ArkInventory.Global.Mode.Vault or bag_id ~= GetCurrentGuildBankTab( ) then
				-- no longer at the vault or changed tabs, abort
				RestackAbort( loc_id )
			end
			
			if select( 3, GetGuildBankItemInfo( bag_id, slot_id ) ) then
				
				-- this slot is locked, move on and check it again next time
				--ArkInventory.Output( "locked> ", loc_id, ".", bag_id, ".", slot_id )
				recheck = true
				
			else
				
				if slot_id > cs then
					
					local h = GetGuildBankItemLink( bag_id, slot_id )
					
					if h then
						
						local osd = ArkInventory.ObjectStringDecode( h )
						local item_id = osd[2]
						
						if item_id == id then
							
							local stack = select( 10, ArkInventory.ObjectInfo( h ) )
							local count = select( 2, GetGuildBankItemInfo( bag_id, slot_id ) )
							
							if count < stack then
								--ArkInventory.OutputDebug( "found > ", bag_id, ".", slot_id )
								return true, bag_id, slot_id, count
							end
							
						end
						
					end
					
				end
				
			end
			
		end
		
		if recheck then
			coroutine.yield( )
			return FindPartialStack( loc_id, cl, cb, bp, cs, id )
		end
		
		return false, nil, nil, recheck
		
	end
	
	if cl == ArkInventory.Const.Location.Bag or cl == ArkInventory.Const.Location.Bank then
		
		for zz, bag_id in ipairs( ArkInventory.Global.Location[loc_id].Bags ) do
			
			if not ArkInventory.Global.Me.bagoptions[loc_id][bag_id].restack.ignore then
				
				for slot_id = GetContainerNumSlots( bag_id ), 1, -1 do
					
					RestackBagCheck( loc_id, bag_id )
					
					if cl == ArkInventory.Const.Location.Bank and not ArkInventory.Global.Mode.Bank then
						-- no longer at bank, abort
						RestackAbort( cl )
					end
					
					if cl == ArkInventory.Const.Location.Vault and not ArkInventory.Global.Mode.Vault then
						-- no longer at vault, abort
						RestackAbort( cl )
					end
					
					if select( 3, GetContainerItemInfo( bag_id, slot_id ) ) then
					
						-- this slot is locked, move on and check it again next time
						--ArkInventory.Output( "locked> ", loc_id, ".", bag_id, ".", slot_id )
						recheck = true
						
					else
						
						if ( loc_id ~= cl ) or ( loc_id == cl and zz > bp ) or ( loc_id == cl and zz == bp and slot_id > cs )then
						-- ( different location ) or (same location and higher bag) or (same location and same bag and higher slot)
						
							local h = GetContainerItemLink( bag_id, slot_id )
							
							if h then
								
								local osd = ArkInventory.ObjectStringDecode( h )
								local item_id = osd[2]
								
								if item_id == id then
									
									local stack = select( 10, ArkInventory.ObjectInfo( h ) )
									local count = select( 2, GetContainerItemInfo( bag_id, slot_id ) )
									
									if count < stack then
										--ArkInventory.Output( "found > ", bag_id, ".", slot_id )
										return true, bag_id, slot_id, recheck
									end
									
								end
								
							end
							
						end
						
					end
					
				end
				
			end
			
		end
		
		if recheck then
			coroutine.yield( )
			return FindPartialStack( loc_id, cl, cb, bp, cs, id )
		end
		
		if loc_id == ArkInventory.Const.Location.Bank and ArkInventory.db.global.option.restack.topup then
			return FindStack( ArkInventory.Const.Location.Bag, cl, cb, bp, cs, id )
		end
		
		return false, nil, nil, recheck
		
	end
	
end

local function FindProfessionItem( loc_id, cl, cb, bp, cs, ct )
	
	local recheck = false
	local cl = cl or loc_id
	local cb = cb or 9999
	local bp = bp or -1
	local cs = cs or -1
	local ct = ct or 0
	
	--ArkInventory.Output( "find prof ", loc_id, ", ", cl, ".", cb, ".", cs, " ", ct )
	
	if ct == 0 then
		ArkInvetory.OutputError( "code failure: checking for profession item of type 0" )
		RestackAbort( loc_id )
	end
	
	for zz, bag_id in ipairs( ArkInventory.Global.Location[loc_id].Bags ) do
		
		local bt, count = RestackBagCheck( loc_id, bag_id )
		
		if not ArkInventory.Global.Me.bagoptions[loc_id][bag_id].restack.ignore then
			
			if bt == 0 then
				
				for slot_id = count, 1, -1 do
					
					RestackBagCheck( loc_id, bag_id )
					
					if loc_id == ArkInventory.Const.Location.Bank and not ArkInventory.Global.Mode.Bank then
						-- no longer at bank, abort
						RestackAbort( loc_id )
					end
					
					if select( 3, GetContainerItemInfo( bag_id, slot_id ) ) then
						
						-- this slot is locked, move on and check it again next time
						--ArkInventory.Output( "locked> ", loc_id, ".", bag_id, ".", slot_id )
						recheck = true
						
					else
						
						if ( loc_id ~= cl ) or ( loc_id == cl and zz > bp ) or ( loc_id == cl and zz == bp and slot_id > cs )then
						-- ( different location ) or (same location and higher bag) or (same location and same bag and higher slot)
							
							local h = GetContainerItemLink( bag_id, slot_id )
							
							if h then
								
								-- ignore bags
								if select( 11, ArkInventory.ObjectInfo( h ) ) ~= "INVTYPE_BAG" then
									
									local check_item = true
									if loc_id ~= cl then
										-- only allow crafting reagents to be selected from bags when depositing to the bank (dont steal the pick/hammer/army knife/etc)
										ArkInventory.TooltipSetHyperlink( ArkInventory.Global.Tooltip.Scan, h )
										if not ArkInventory.TooltipContains( ArkInventory.Global.Tooltip.Scan, ArkInventory.Localise["CRAFTING_REAGENT"] ) then
											check_item = false
										end
									end
									
									local it = GetItemFamily( h )
									
									if check_item and bit.band( it, ct ) > 0 then
										--ArkInventory.Output( "prof> ", loc_id, ".", bag_id, ".", slot_id )
										return true, bag_id, slot_id, recheck
									end
									
								end
								
							end
							
						end
						
					end
					
				end
				
			end
			
		end
		
	end
	
	if loc_id == ArkInventory.Const.Location.Bank and ArkInventory.db.global.option.restack.bank then
		local ok, sb, ss, rc = FindProfessionItem( ArkInventory.Const.Location.Bag, loc_id, nil, nil, nil, ct )
		if rc then
			recheck = true
		end
		return ok, sb, ss, recheck
	end
	
	--ArkInventory.Output( "no profession items found in ", loc_id )
	return false, nil, nil, recheck
	
end

local function FindCraftingItem( loc_id, cl, cb, bp, cs )
	
	local recheck = false
	local cl = cl or loc_id
	local cb = cb or 9999
	local bp = bp or -999
	local cs = cs or -999
	
	for zz, bag_id in ipairs( ArkInventory.Global.Location[loc_id].Bags ) do
		
		local bt, count = RestackBagCheck( loc_id, bag_id )
		
		if not ArkInventory.Global.Me.bagoptions[loc_id][bag_id].restack.ignore then
			
			if bt == 0 and bag_id ~= REAGENTBANK_CONTAINER then
				-- do not steal from profession bags or the reagent bank
				
				--ArkInventory.Output( "find craft ", cl, ".", cb, "(", bp, ").", cs, " / ", loc_id, ".", bag_id, " (", zz, ")" )
				
				for slot_id = count, 1, -1 do
					
					RestackBagCheck( loc_id, bag_id )
					
					if loc_id == ArkInventory.Const.Location.Bank and not ArkInventory.Global.Mode.Bank then
						-- no longer at bank, abort
						RestackAbort( loc_id )
					end
					
					if select( 3, GetContainerItemInfo( bag_id, slot_id ) ) then
						
						-- this slot is locked, move on and check it again next time
						--ArkInventory.Output( "locked> ", loc_id, ".", bag_id, ".", slot_id )
						recheck = true
						
					else
						
						if ( cb == REAGENTBANK_CONTAINER ) or ( loc_id ~= cl ) or ( loc_id == cl and zz > bp ) or ( loc_id == cl and zz == bp and slot_id > cs )then
							-- ( different location ) or (same location and higher bag) or (same location and same bag and higher slot)
						
							--ArkInventory.Output( "check> ", loc_id, ".", bag_id, ".", slot_id )
					
							ArkInventory.TooltipSetItem( ArkInventory.Global.Tooltip.Scan, bag_id, slot_id )
							if ArkInventory.TooltipContains( ArkInventory.Global.Tooltip.Scan, ArkInventory.Localise["CRAFTING_REAGENT"] ) then
								--ArkInventory.Output( "craft> ", loc_id, ".", bag_id, ".", slot_id )
								return true, bag_id, slot_id, recheck
							end
							
						end
						
					end
					
				end
				
			end
			
		end
		
	end
	
	if loc_id == ArkInventory.Const.Location.Bank and ArkInventory.db.global.option.restack.deposit then
		local ok, sb, ss, rc = FindCraftingItem( ArkInventory.Const.Location.Bag, loc_id )
		if rc then
			recheck = true
		end
		return ok, sb, ss, recheck
	end
	
	--ArkInventory.Output( "no crafting items found in ", loc_id )
	return false, nil, nil, recheck
	
end

local function CompactBags( loc_id )
	
	local recheck = false
	
	for zz, bag_id in ipairs( ArkInventory.Global.Location[loc_id].Bags ) do
		
		if not ArkInventory.Global.Me.bagoptions[loc_id][bag_id].restack.ignore then
			
			for slot_id = GetContainerNumSlots( bag_id ), 1, -1 do
				
				RestackBagCheck( loc_id, bag_id )
				
				if loc_id == ArkInventory.Const.Location.Bank and not ArkInventory.Global.Mode.Bank then
					-- no longer at bank, abort
					RestackAbort( loc_id )
				end
				
				--ArkInventory.Output( "checking ", loc_id, ".", bag_id, ".", slot_id )
				
				if select( 3, GetContainerItemInfo( bag_id, slot_id ) ) then
					
					-- this slot is locked, move on and check it again next time
					--ArkInventory.Output( "locked> ", loc_id, ".", bag_id, ".", slot_id )
					recheck = true
					
				else
					
					local h = GetContainerItemLink( bag_id, slot_id )
					
					if h then
						
						local osd = ArkInventory.ObjectStringDecode( h )
						local item_id = osd[2]
						local stack = select( 10, ArkInventory.ObjectInfo( h ) )
						local count = select( 2, GetContainerItemInfo( bag_id, slot_id ) )
						
						if count < stack then
							
							--ArkInventory.Output( "partial stack of ", count, "x", h, " found at ", bag_id, ".", slot_id )
							
							local ok, pb, ps, rc = FindPartialStack( loc_id, loc_id, bag_id, zz, slot_id, item_id )
							
							if rc then
								recheck = true
							end
							
							if ok then
								
								--ArkInventory.Output( "merge> ", bag_id, ".", slot_id, " + ", pb, ".", ps )
								
								ClearCursor( )
								PickupContainerItem( pb, ps )
								PickupContainerItem( bag_id, slot_id )
								ClearCursor( )
								
								recheck = true
								
							end
						
						end
						
					end
					
				end
				
			end
			
		end
		
	end
	
	return recheck
	
end

local function CompactVault( )
	
	local loc_id = ArkInventory.Const.Location.Vault
	local bag_id = GetCurrentGuildBankTab( )
	
	local _, _, canView, canDeposit = GetGuildBankTabInfo( bag_id )
	
	if not ( IsGuildLeader( ) or ( canView and canDeposit ) ) then
		ArkInventory.Output( string.format( ArkInventory.Localise["RESTACK_FAIL_ACCESS"], ArkInventory.Localise["LOCATION_VAULT"], bag_id ) )
		return
	end
	
	local recheck = false
	
	for slot_id = MAX_GUILDBANK_SLOTS_PER_TAB, 1, -1 do
		
		if not ArkInventory.Global.Mode.Vault or bag_id ~= GetCurrentGuildBankTab( ) then
			-- no longer at the vault or changed tabs, abort
			RestackAbort( loc_id )
		end
		
		--ArkInventory.OutputDebug( "checking vault ", bag_id, ".", slot_id )
		
		if select( 3, GetGuildBankItemInfo( bag_id, slot_id ) ) then
			
			-- this slot is locked, move on and check it again next time
			--ArkInventory.Output( "locked> ", loc_id, ".", bag_id, ".", slot_id )
			recheck = true
			
		else
			
			local h = GetGuildBankItemLink( bag_id, slot_id )
			
			--ArkInventory.OutputDebug( "tab=[", bag_id, "], slot=[", slot_id, "] count=[", count, "] locked=[", locked, "] item=", h )
			
			if h then
				
				local osd = ArkInventory.ObjectStringDecode( h )
				local item_id = osd[2]
				local stack = select( 10, ArkInventory.ObjectInfo( h ) )
				local count = select( 2, GetGuildBankItemInfo( bag_id, slot_id ) )
				
				if count < stack then
					
					--ArkInventory.OutputDebug( "partial > ", bag_id, ".", slot_id )
					
					local ok, pb, ps, rc = FindPartialStack( loc_id, loc_id, bag_id, nil, slot_id, item_id )
					
					if rc then
						recheck = true
					end
					
					if ok then
						
						--ArkInventory.OutputDebug( "merge > ", bag_id, ".", slot_id, " + ", pb, ".", ps )
						
						ClearCursor( )
						PickupGuildBankItem( pb, ps )
						PickupGuildBankItem( bag_id, slot_id )
						ClearCursor( )
						
						--ArkInventory.Output( "yielding - pending vault update" )
						coroutine.yield( )
						--ArkInventory.Output( "resumed" )
						
						recheck = true
						
					end
					
				end
			
			end
			
		end
		
	end
	
	if recheck then
		coroutine.yield( )
		return CompactVault( )
	end
	
end

local function ConsolidateBag( loc_id, bag_id, bag_pos )
	
	local recheck = false
	
	if not ArkInventory.Global.Me.bagoptions[loc_id][bag_id].restack.ignore then
		
		local bt, count = RestackBagCheck( loc_id, bag_id )
		
		--ArkInventory.Output( "bag> ", loc_id, ".", bag_id, "(", bag_pos, ") ", bt, " / ", count )
		
		for slot_id = count, 1, -1 do
			
			if loc_id == ArkInventory.Const.Location.Bank and not ArkInventory.Global.Mode.Bank then
				-- no longer at bank, abort
				RestackAbort( )
			end
			
			--ArkInventory.Output( "chk> ", loc_id, ".", bag_id, ".", slot_id )
			
			if select( 3, GetContainerItemInfo( bag_id, slot_id ) ) then
				
				-- this slot is locked, move on and check it again next time
				recheck = true
				--ArkInventory.Output( "locked> ", loc_id, ".", bag_id, ".", slot_id )
				
			else
				
				local h = GetContainerItemLink( bag_id, slot_id )
				
				if not h then
					
					--ArkInventory.Output( "empty> ", loc_id, ".", bag_id, ".", slot_id )
					
					local ok, sb, ss, rc
					if bt == 0 then
						ok, sb, ss, rc = FindCraftingItem( loc_id, loc_id, bag_id, bag_pos, slot_id )
					else
						ok, sb, ss, rc = FindProfessionItem( loc_id, loc_id, bag_id, bag_pos, slot_id, bt )
					end
					
					if rc then
						recheck = true
					end
					
					if ok then
						
						--ArkInventory.Output( "moving> ", sb, ".", ss, " to ", bag_id, ".", slot_id )
						
						ClearCursor( )
						PickupContainerItem( sb, ss )
						PickupContainerItem( bag_id, slot_id )
						ClearCursor( )
						
						recheck = true
						
					end
					
				else
					--ArkInventory.Output( "item> ", loc_id, ".", bag_id, ".", slot_id, " ", h )
				end
				
			end
			
		end
		
	end
	
	return recheck
	
end

local function Consolidate( loc_id )
	
	--ArkInventory.Output( "Consolidate ", loc_id )
	
	local recheck = false
	
	-- fill up profession bags with profession items
	for zz, bag_id in ipairs( ArkInventory.Global.Location[loc_id].Bags ) do
		
		local bt, count = RestackBagCheck( loc_id, bag_id )
		
		if not ArkInventory.Global.Me.bagoptions[loc_id][bag_id].restack.ignore then
			
			if count > 0 and bt ~= 0 then
				--ArkInventory.Output( "Consolidate ", loc_id, ".", bag_id, " ", bt )
				
				if ConsolidateBag( loc_id, bag_id, zz ) then
					recheck = true
				end
			end
			
		end
		
	end
	
	if loc_id == ArkInventory.Const.Location.Bank then
		
		if  ArkInventory.db.global.option.restack.deposit and IsReagentBankUnlocked( ) then
			
			-- fill up reagent bank with crafting items
			
			local bag_id = REAGENTBANK_CONTAINER
			local bt = RestackBagCheck( loc_id, bag_id )
			
			if not ArkInventory.Global.Me.bagoptions[loc_id][bag_id].restack.ignore then
				
				if ConsolidateBag( loc_id, bag_id ) then
					recheck = true
				end
				
			end
			
		end
		
		if ArkInventory.db.global.option.restack.bank then
			
			-- fill up normal bags with crafting items
			
			for zz, bag_id in ipairs( ArkInventory.Global.Location[loc_id].Bags ) do
				
				local bt = RestackBagCheck( loc_id, bag_id )
				
				if not ArkInventory.Global.Me.bagoptions[loc_id][bag_id].restack.ignore then
					
					if bt == 0 and bag_id ~= REAGENTBANK_CONTAINER then
						if ConsolidateBag( loc_id, bag_id, zz ) then
							recheck = true
						end
					end
					
				end
				
			end
			
		end
		
	end
	
	return recheck
	
end

local function RestackRun( loc_id )
	
	-- DO NOT USE CACHED DATA FOR RESTACKING, PULL THE DATA DIRECTLY FROM WOW AGAIN, THE UI WILL CATCH UP
	
	if loc_id == ArkInventory.Const.Location.Bag then
		
		if ArkInventory.db.global.option.message.restack[loc_id] then
			ArkInventory.Output( ArkInventory.RestackString( ), ": ", ArkInventory.Global.Location[loc_id].Name, " " , ArkInventory.Localise["START"] )
		end
		
		if ArkInventory.db.global.option.restack.blizzard then
			
			SortBags( )
			coroutine.yield( )
			
		else
			
			local recheck
			
			repeat
				
				recheck = false
				
				if CompactBags( loc_id ) then
					recheck = true
					coroutine.yield( )
				end
				
				if Consolidate( loc_id ) then
					recheck = true
					coroutine.yield( )
				end
				
			until not recheck
			
		end
		
		if ArkInventory.db.global.option.message.restack[loc_id] then
			ArkInventory.Output( ArkInventory.RestackString( ), ": ", ArkInventory.Global.Location[loc_id].Name, " " , ArkInventory.Localise["COMPLETE"] )
		end
		
	end
	
	
	if loc_id == ArkInventory.Const.Location.Bank then
		
		if ArkInventory.Global.Mode.Bank then
			
			if ArkInventory.db.global.option.message.restack[loc_id] then
				ArkInventory.Output( ArkInventory.RestackString( ), ": ", ArkInventory.Global.Location[loc_id].Name, " " , ArkInventory.Localise["START"] )
			end
			
			if ArkInventory.db.global.option.restack.blizzard then
				
				SortBankBags( )
				coroutine.yield( )
				
				if IsReagentBankUnlocked( ) then
					
					if ArkInventory.db.global.option.restack.deposit then
						ArkInventory.Output( ArkInventory.RestackString( ), ": ", REAGENTBANK_DEPOSIT, " " , ArkInventory.Localise["ENABLED"] )
						DepositReagentBank( )
						coroutine.yield( )
					else
						ArkInventory.Output( ArkInventory.RestackString( ), ": ", REAGENTBANK_DEPOSIT, " " , ArkInventory.Localise["DISABLED"] )
					end
					
					local bag_id = ArkInventory.Global.Location[loc_id].tabReagent
					if not ArkInventory.Global.Me.bagoptions[loc_id][bag_id].restack.ignore then
						SortReagentBankBags( )
						coroutine.yield( )
					end
					
				end
				
			else
				
				local recheck
				
				repeat
					
					recheck = false
					
					if CompactBags( loc_id ) then
						recheck = true
						coroutine.yield( )
					end
					
					if Consolidate( loc_id ) then
						recheck = true
						coroutine.yield( )
					end
					
				until not recheck
				
			end
			
			
			if ArkInventory.db.global.option.message.restack[loc_id] then
				ArkInventory.Output( ArkInventory.RestackString( ), ": ", ArkInventory.Global.Location[loc_id].Name, " " , ArkInventory.Localise["COMPLETE"] )
			end
			
		end
		
	end
	
	
	if loc_id == ArkInventory.Const.Location.Vault then
		
		if ArkInventory.Global.Mode.Vault then
			
			if ArkInventory.db.global.option.message.restack[loc_id] then
				ArkInventory.Output( ArkInventory.RestackString( ), ": ", ArkInventory.Global.Location[loc_id].Name, " " , ArkInventory.Localise["START"] )
			end
			
			CompactVault( )
			
			if ArkInventory.db.global.option.message.restack[loc_id] then
				ArkInventory.Output( ArkInventory.RestackString( ), ": ", ArkInventory.Global.Location[loc_id].Name, " " , ArkInventory.Localise["COMPLETE"] )
			end
			
		end
		
	end
	
	
end

function ArkInventory.RestackResume( loc_id )
	
	--ArkInventory.Output( "ResumeThreads ", loc_id )
	
	if type( ArkInventory.Global.Thread.Restack[loc_id] ) == "thread" and coroutine.status( ArkInventory.Global.Thread.Restack[loc_id] ) == "suspended" then
		-- resume current thread
		local ok, errmsg = coroutine.resume( ArkInventory.Global.Thread.Restack[loc_id] )
		if not ok then
			error( errmsg )
		end
	end
	
end

local function RestackLocation( loc_id )
	
	if ArkInventory.Global.Mode.Combat then
		--ArkInventory.Output( "restack location ", loc_id, " aborted - in combat" )
		return
	end
	
	if type( ArkInventory.Global.Thread.Restack[loc_id] ) ~= "thread" or coroutine.status( ArkInventory.Global.Thread.Restack[loc_id] ) == "dead" then
		
		-- thread not active, create a new one
		ArkInventory.Global.Thread.Restack[loc_id] = coroutine.create(
			function ( )
				RestackRun( loc_id )
			end
		)
		
		-- run it
		local ok, errmsg = coroutine.resume( ArkInventory.Global.Thread.Restack[loc_id] )
		if not ok then
			error( errmsg )
		end
		
	else
		
		-- restack already in progress
		ArkInventory.OutputError( ArkInventory.RestackString( ), ": ", ArkInventory.Global.Location[loc_id].Name, " " , ArkInventory.Localise["RESTACK_FAIL_WAIT"] )
		
		-- give it a push, just in case
		local ok, errmsg = coroutine.resume( ArkInventory.Global.Thread.Restack[loc_id] )
		if not ok then
			error( errmsg )
		end
		
	end
	
end

function ArkInventory.Restack( loc_id )
	RestackLocation( loc_id )
end

function ArkInventory.EmptyBag( loc_id, cbag )
	
	local cbag = ArkInventory.BagID_Blizzard( loc_id, cbag )
	
	if not ( loc_id == ArkInventory.Const.Location.Bag or loc_id == ArkInventory.Const.Location.Bank ) then
		return
	end
	
	local _, ct = GetContainerNumFreeSlots( cbag )
	local cslot = 0
	
	--ArkInventory.Output( "empty ", cbag, " [", ct, "]" )
	
	for _, bag_id in ipairs( ArkInventory.Global.Location[loc_id].Bags ) do
		
		local _, bt = GetContainerNumFreeSlots( bag_id )
		
		if bag_id ~= cbag and ( bt == 0 or bt == ct ) then
			
			for slot_id = GetContainerNumSlots( bag_id ), 1, -1 do
				
				if ( loc_id == ArkInventory.Const.Location.Bank ) and ( not ArkInventory.Global.Mode.Bank ) then
					-- no longer at bank, abort
					return
				end
				
				local h = GetContainerItemLink( bag_id, slot_id )
				
				if not h then
					
					repeat
						cslot = cslot + 1
						h = GetContainerItemLink( cbag, cslot )
					until h or cslot > GetContainerNumSlots( cbag )
					
					if h then
						ClearCursor( )
						PickupContainerItem( cbag, cslot )
						PickupContainerItem( bag_id, slot_id )
						ClearCursor( )
					end
				
				end
				
			end
			
		end
		
	end
	
end
