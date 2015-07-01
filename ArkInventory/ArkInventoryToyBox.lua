local _G = _G
local select = _G.select
local pairs = _G.pairs
local ipairs = _G.ipairs
local string = _G.string
local type = _G.type
local error = _G.error
local table = _G.table
local C_ToyBox = _G.C_ToyBox

local filter = {
	ignore = false,
--	searchBox = nil,
--	collected = true,
--	notcollected = true,
--	source = { },
}

ArkInventory.Toybox = {
	data = {
		loaded = false,
		total = 0, -- number of total mounts
		owned = 0, -- number of owned mounts
		collection = { },	-- [ID] = { } - owned mounts only
	},
}

function ArkInventory.Toybox.OnHide( )
	filter.ignore = false
	ArkInventory:SendMessage( "LISTEN_TOYBOX_RELOAD_BUCKET", "RESCAN" )
end

function ArkInventory.Toybox.FilterClear( )
	
	filter.ignore = true
	
	ToyBox.searchString = ""
	
	C_ToyBox.SetFilterCollected( true )
	
	C_ToyBox.SetFilterUncollected( true )
	
	for i = 1, ArkInventory.PetJournal.FilterGetSourceTypes( ) do
		C_ToyBox.SetFilterSourceType( i, true )
	end
	
end

function ArkInventory.Toybox.FilterSave( )
	
	if filter.ignore then
		--ArkInventory.Output( "FilterSave - ignore" )
		return
	end
	
	filter.search = ToyBox.searchBox:GetText( )
	--ArkInventory.Output( "SEARCH = ", filter.search )
	
	filter.collected = C_ToyBox.GetFilterCollected( )
	--ArkInventory.Output( "COLLECTED = ", filter.collected )
	
	filter.notcollected = C_ToyBox.GetFilterUncollected()
	--ArkInventory.Output( "NOT COLLECTED = ", filter.notcollected )
	
	for i = 1, ArkInventory.PetJournal.FilterGetSourceTypes( ) do
		filter.source[i] = not C_ToyBox.IsSourceTypeFiltered( i )
		--ArkInventory.Output( "SOURCE[", i, "] = ", filter.source[i], " (", _G["BATTLE_PET_SOURCE_"..i], ")" )
	end
	
end

function ArkInventory.Toybox.FilterRestore( )
	
	filter.ignore = true
	
	ToyBox.searchBox:SetText( filter.search )
	
	C_ToyBox.SetFilterCollected( filter.collected )
	
	C_ToyBox.SetFilterUncollected( filter.notcollected )
	
	for i = 1, ArkInventory.PetJournal.FilterGetSourceTypes( ) do
		C_ToyBox.SetFilterSourceType( i, filter.source[i] )
	end
	
end



function ArkInventory.Toybox.JournalIsReady( )
	return ArkInventory.Toybox.data.loaded
end

function ArkInventory.Toybox.GetCount( )
	return ArkInventory.Toybox.data.owned, ArkInventory.Toybox.data.total
end

function ArkInventory.Toybox.GetToy( value )
	
	if type( value ) == "number" then
		return ArkInventory.Toybox.data.collection[value]
	end
	
end

function ArkInventory.Toybox.Iterate( )
	local t = ArkInventory.Toybox.data.collection
	return ArkInventory.spairs( t, function( a, b ) return ( t[a].fullname or "" ) < ( t[b].fullname or "" ) end )
end

function ArkInventory.Toybox.Summon( index )
	local td = ArkInventory.Toybox.GetToy( index )
	UseToy( td.item )
end

function ArkInventory.Toybox.GetFavorite( index )
	-- index = item id
	local td = ArkInventory.Toybox.GetToy( index )
	return C_ToyBox.GetIsFavorite( td.item )
end

function ArkInventory.Toybox.SetFavorite( index, value )
	-- value = true | false
	local td = ArkInventory.Toybox.GetToy( index )
	C_ToyBox.SetIsFavorite( td.item, value )
end

function ArkInventory.Toybox.Scan( )
	
	--ArkInventory.Output( "ArkInventory.Toybox.Scan( )" )
	
	if ( ArkInventory.Global.Mode.Combat ) then
		-- set to scan when leaving combat
		ArkInventory.Global.LeaveCombatRun.Toybox = true
		return
	end
	
	local tb = ArkInventory.Toybox.data
	
	--ArkInventory.Toybox.FilterSave( )
	--ArkInventory.Toybox.FilterClear( )
	
	local total = C_ToyBox.GetNumTotalDisplayedToys( )
	local owned = C_ToyBox.GetNumLearnedDisplayedToys( )
	--ArkInventory.Output( "toys: ", owned, " of ", total )
	
	if ( total == 0 ) and ( owned == 0 ) then
		--ArkInventory.Toybox.FilterRestore( )
		return
	end
	
	local update = false
	
	if ( tb.total ~= total ) or ( not tb.loaded ) then
		tb.total = total
		update = true
	end
		
	if ( tb.owned ~= owned ) or ( not tb.loaded ) then
		
		tb.loaded = true
		
		tb.owned = owned
		update = true
		
		wipe( tb.collection )
		
	end
	
	local td = ArkInventory.Toybox.data.collection
	
   for i = 1, total do
		
		local item = C_ToyBox.GetToyFromIndex( i )
		local owned = PlayerHasToy( item )
		
		if owned then
			
			local item, name, icon = C_ToyBox.GetToyInfo( item )
			--ArkInventory.Output( item, " / ", name )
			local fav = C_ToyBox.GetIsFavorite( item )
			
			if ( not update ) and ( ( not td[i] ) or ( td[i].name ~= name ) or ( td[i].fav ~= fav ) ) then
				update = true
			end
			
			td[i] = {
				link = C_ToyBox.GetToyLink( item ),
				item = item,
				index = i,
				name = name,
				texture = icon,
				fav = fav,
			}
			
		end
		
	end
	
	--ArkInventory.Toybox.FilterRestore( )
	
	if update then
		ArkInventory.ScanToybox( )
	end
	
	return true
	
end



function ArkInventory:LISTEN_TOYBOX_RELOAD( event, item, new )
	
	--ArkInventory.Output( "LISTEN_TOYBOX_RELOAD( ", event, " )" )
	
	if new then
		filter.ignore = false
	end
	
	ArkInventory:SendMessage( "LISTEN_TOYBOX_RELOAD_BUCKET", event )
	
end

function ArkInventory:LISTEN_TOYBOX_RELOAD_BUCKET( events )
	
	--ArkInventory.Output( "LISTEN_TOYBOX_RELOAD_BUCKET( ", events, " )" )
	
	if ToyBox:IsVisible( ) then
		--ArkInventory.Output( "IGNORED (COLLECTION OPEN)" )
		return
	end
	
	if filter.ignore then
		--ArkInventory.Output( "IGNORED (FILTER CHANGED BY ME)" )
		filter.ignore = false
		return
	end
	
	ArkInventory.Toybox.Scan( )
	
end




-- runtime
ToyBox:HookScript( "OnHide", ArkInventory.Toybox.OnHide )
--ArkInventory.Toybox.FilterSave( )
