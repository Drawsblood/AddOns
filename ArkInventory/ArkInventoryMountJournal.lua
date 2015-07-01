local _G = _G
local select = _G.select
local pairs = _G.pairs
local ipairs = _G.ipairs
local string = _G.string
local type = _G.type
local error = _G.error
local table = _G.table
local C_MountJournal = _G.C_MountJournal

local PLAYER_MOUNT_LEVEL = 20

local filter = {
	ignore = false,
--	searchBox = nil,
--	collected = true,
--	uncollected = true,
--	source = { },
}

local journal = {
	total = 0, -- number of total mounts
	owned = 0, -- number of owned mounts
	cache = { }, -- [index] = { }
	types = { }, -- [spell] = value
}

ArkInventory.MountJournal = { }

-- map the basic filter functions, blizzard change them around so this way you just change this and youre done
function ArkInventory.MountJournal.FilterGetSearch( )
	return MountJournal.searchBox:GetText( )
end

function ArkInventory.MountJournal.FilterSetSearch( s )
	MountJournal.searchBox:SetText( s )
end

function ArkInventory.MountJournal.FilterGetCollected( )
	return C_MountJournal.GetCollectedFilterSetting( LE_MOUNT_JOURNAL_FILTER_COLLECTED )
end

function ArkInventory.MountJournal.FilterSetCollected( value )
	C_MountJournal.SetCollectedFilterSetting( LE_MOUNT_JOURNAL_FILTER_COLLECTED, value )
end

function ArkInventory.MountJournal.FilterGetUncollected( )
	return C_MountJournal.GetCollectedFilterSetting( LE_MOUNT_JOURNAL_FILTER_NOT_COLLECTED )
end

function ArkInventory.MountJournal.FilterSetUncollected( value )
	C_MountJournal.SetCollectedFilterSetting( LE_MOUNT_JOURNAL_FILTER_NOT_COLLECTED, value )
end

function ArkInventory.MountJournal.FilterGetSource( t )
	assert( type( t ) == "table", "parameter is not a table" )
	for i = 1, ArkInventory.PetJournal.FilterGetSourceTypes( ) do
		t[i] = MountJournal.filterTypes[i]
	end
end

function ArkInventory.MountJournal.FilterSetSource( t )
	if type( t ) == "table" then
		for i = 1, ArkInventory.PetJournal.FilterGetSourceTypes( ) do
			MountJournal.filterTypes[i] = t[i]
		end
	elseif type( t ) == "boolean" then
		for i = 1, ArkInventory.PetJournal.FilterGetSourceTypes( ) do
			MountJournal.filterTypes[i] = t
		end
	else
		assert( false, "parameter is not a table or boolean" )
	end
end


function ArkInventory.MountJournal.FilterActionClear( )
	
	filter.ignore = true
	
	ArkInventory.MountJournal.FilterSetSearch( "" )
	ArkInventory.MountJournal.FilterSetCollected( true )
	ArkInventory.MountJournal.FilterSetUncollected( true )
	ArkInventory.MountJournal.FilterSetSource( true )
	
end
	
function ArkInventory.MountJournal.FilterActionBackup( )
	
	if filter.ignore then
		--ArkInventory.Output( "FilterActionBackup - ignore" )
		return
	end
	
	filter.search = ArkInventory.MountJournal.FilterGetSearch( )
	filter.collected = ArkInventory.MountJournal.FilterGetCollected( )
	filter.uncollected = ArkInventory.MountJournal.FilterGetUncollected( )
	ArkInventory.MountJournal.FilterGetSource( filter.source )
	
end

function ArkInventory.MountJournal.FilterActionRestore( )
	
	filter.ignore = true
	
	ArkInventory.MountJournal.FilterSetSearch( filter.search )
	ArkInventory.MountJournal.FilterSetCollected( filter.collected )
	ArkInventory.MountJournal.FilterSetUncollected( filter.uncollected )
	ArkInventory.MountJournal.FilterSetSource( filter.source )
	
end


function ArkInventory.MountJournal.OnHide( )
	filter.ignore = false
	ArkInventory:SendMessage( "LISTEN_MOUNTJOURNAL_RELOAD_BUCKET", "RESCAN" )
end




function ArkInventory.MountJournal.JournalIsReady( )
	return ( journal.total > 0 )
end

function ArkInventory.MountJournal.GetCount( )
	return journal.owned, journal.total
end

function ArkInventory.MountJournal.GetMount( index )
	if type( index ) == "number" then
		return journal.cache[index]
	end
end

function ArkInventory.MountJournal.GetMountBySpell( spell )
	for _, v in pairs( journal.cache ) do
		if v.spell == spell then
			return v
		end
	end
end



function ArkInventory.MountJournal.Iterate( )
	return ArkInventory.spairs( journal.cache, function( a, b ) return ( journal.cache[a].name or "" ) < ( journal.cache[b].name or "" ) end )
end

function ArkInventory.MountJournal.Dismiss( )
	C_MountJournal.Dismiss( )
end

function ArkInventory.MountJournal.Summon( id )
	local obj = ArkInventory.MountJournal.GetMount( id )
	C_MountJournal.Summon( obj.index )
end

function ArkInventory.MountJournal.GetFavorite( id )
	local obj = ArkInventory.MountJournal.GetMount( id )
	return C_MountJournal.GetIsFavorite( obj.index )
end

function ArkInventory.MountJournal.SetFavorite( id, value )
	-- value = true|false
	local obj = ArkInventory.MountJournal.GetMount( id )
	--ArkInventory.Output( id, " / ", value, " (", type(value), ") / ", obj )
	C_MountJournal.SetIsFavorite( obj.index, value )
end

function ArkInventory.MountJournal.IsUsable( id )
	local obj = ArkInventory.MountJournal.GetMount( id )
	-- and yes its still buggy and returning true when you cant actually use the mount
	return ( select( 5, C_MountJournal.GetMountInfo( obj.index ) ) )
end

function ArkInventory.MountJournal.SkillLevel( )
	
	local skill = 0
	
	if UnitLevel( "player" ) < PLAYER_MOUNT_LEVEL then
		
		--ArkInventory.Output( "player level is too low" )
		skill = 1
		
	else
		
		if GetSpellInfo( ( GetSpellInfo( 90265 ) ) ) then -- master
			skill = 300
--			ArkInventory.Output( "riding skill = ", skill, " / master" )
		elseif GetSpellInfo( ( GetSpellInfo( 34091 ) ) ) then -- artisan
			skill = 300
--			ArkInventory.Output( "riding skill = ", skill, " / artisan" )
		elseif GetSpellInfo( ( GetSpellInfo( 34090 ) ) ) then -- expert
			skill = 225
--			ArkInventory.Output( "riding skill = ", skill, " / expert" )
		elseif GetSpellInfo( ( GetSpellInfo( 33391 ) ) ) then -- journeyman
			skill = 150
--			ArkInventory.Output( "riding skill = ", skill, " / journeyman" )
		elseif GetSpellInfo( ( GetSpellInfo( 33388 ) ) ) then -- apprentice
			skill = 75
--			ArkInventory.Output( "riding skill = ", skill, " / apprentice" )
		end
		
	end
	
	return skill
	
end



function ArkInventory.MountJournal.Scan( )
	
	if ( ArkInventory.Global.Mode.Combat ) then
		-- set to scan when leaving combat
		ArkInventory.Global.LeaveCombatRun.MountJournal = true
		return
	end
	
	--ArkInventory.MountJournal.FilterActionBackup( )
	--ArkInventory.MountJournal.FilterActionClear( )
	
	local total = C_MountJournal.GetNumMounts( )
	
	if total == 0 then
		--ArkInventory.MountJournal.FilterActionRestore( )
		return
	end
	
	local update = false
	
	if journal.total == 0 then
		journal.total = total
		update = true
	end
		
	journal.owned = 0
	
	local c = journal.cache
	
	for i = 1, total do
		
		local name, spell, icon, active, cansummon, source, fav, factionSpecific, faction, hide, owned = C_MountJournal.GetMountInfo( i )
		
		if not hide then
			
			-- only look at the spells for this toon, not any variants that are hidden
			
			if owned then
				journal.owned = journal.owned + 1
			end
			
			if ( not update ) and ( not c[i] or c[i].owned ~= owned or c[i].fav ~= fav or c[i].cansummon ~= cansummon or c[i].active ~= active )then
				update = true
			end
		
			if not c[i] then
				
				local display, description, source, self, mt = C_MountJournal.GetMountInfoExtra( i )
				
				c[i] = {
					index = i,
					name = name,
					spell = spell,
					link = GetSpellLink( spell ),
					icon = icon,
					desc = description,
					src = source,
					did = display,
				}
				
				if mt == 230 or mt == 231 or mt == 241 then
					-- land
					mt = ArkInventory.Const.MountTypes["l"]
				elseif mt == 242 or mt == 247 or mt == 248 then
					-- flying
					mt = ArkInventory.Const.MountTypes["a"]
				elseif mt == 231 or mt == 232 then
					--underwater
					mt = ArkInventory.Const.MountTypes["u"]
				elseif mt == 269 then
					-- surface
					mt = ArkInventory.Const.MountTypes["s"]
				else
					-- unknown
					mt = nil
				end
					
				--ArkInventory.Output( i, " = ", spell, " / ", string.format("%.12f",spell) )
				
				c[i].mt = journal.types[spell] or mt or ArkInventory.Const.MountTypes["x"]
				c[i].mto = c[i].mt -- save original mount type (user corrections can override the other value)
				
			end
			
			c[i].owned = owned
			c[i].fav = fav
			c[i].usable = cansummon
			c[i].active = active
			
		else
			--ArkInventory.Output( "hidden = ", spell, " / ", name )
		end
		
	end
	
	--ArkInventory.MountJournal.FilterActionRestore( )
	
	--ArkInventory.MountJournal.ApplyUserCorrections( )
	
	if update then
		ArkInventory.ScanMountJournal( )
	end
	
	return true
	
end

function ArkInventory.MountJournal.StoreMountType( spell, mt )
	journal.types[spell] = mt
end

function ArkInventory.MountJournal.ApplyUserCorrections( )
	
	-- apply user corrections (these are global settings so the mount may not exist for this character)
	
	for _, md in ArkInventory.MountJournal.Iterate( ) do
		
		local correction = ArkInventory.db.global.option.mount.correction[md.spell]
		
		if correction ~= nil then -- check for nil as we use both true and false
			if correction == md.mto then
				-- code has been updated, clear correction
				--ArkInventory.Output( "clearing mount correction ", md.spell, ": system=", md.mt, ", correction=", correction )
				ArkInventory.db.global.option.mount.correction[md.spell] = nil
				md.mt = md.mto
			else
				-- apply correction
				--ArkInventory.Output( "correcting mount ", md.spell, ": system=", md.mt, ", correction=", correction )
				md.mt = correction
			end
		end
		
	end
	
end


function ArkInventory:LISTEN_MOUNTJOURNAL_RELOAD( event )
	
	if ( event ~= "COMPANION_UPDATE" ) then
		ArkInventory:SendMessage( "LISTEN_MOUNTJOURNAL_RELOAD_BUCKET", event )
	end
	
end

function ArkInventory:LISTEN_MOUNTJOURNAL_RELOAD_BUCKET( events )
	
	--ArkInventory.Output( "LISTEN_MOUNTJOURNAL_RELOAD_BUCKET( ", events, " )" )
	
	if MountJournal:IsVisible( ) then
		--ArkInventory.Output( "IGNORED (cache OPEN)" )
		return
	end
	
	if filter.ignore then
		--ArkInventory.Output( "IGNORED (FILTER CHANGED BY ME)" )
		filter.ignore = false
		return
	end
	
	ArkInventory.MountJournal.Scan( )
	
end




-- runtime
MountJournal:HookScript( "OnHide", ArkInventory.MountJournal.OnHide )
--CollectionsJournal:HookScript( "OnHide", ArkInventory.MountJournal.OnHide )
--ArkInventory.MountJournal.FilterActionBackup( )
