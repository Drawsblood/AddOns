--[[
 /$$$$$$$                      /$$            /$$                        
| $$__  $$                    |__/           | $$                        
| $$  \ $$  /$$$$$$   /$$$$$$  /$$  /$$$$$$$/$$$$$$    /$$$$$$  /$$   /$$
| $$$$$$$/ /$$__  $$ /$$__  $$| $$ /$$_____/_  $$_/   /$$__  $$| $$  | $$
| $$__  $$| $$$$$$$$| $$  \ $$| $$|  $$$$$$  | $$    | $$  \__/| $$  | $$
| $$  \ $$| $$_____/| $$  | $$| $$ \____  $$ | $$ /$$| $$      | $$  | $$
| $$  | $$|  $$$$$$$|  $$$$$$$| $$ /$$$$$$$/ |  $$$$/| $$      |  $$$$$$$
|__/  |__/ \_______/ \____  $$|__/|_______/   \___/  |__/       \____  $$
                     /$$  \ $$                                  /$$  | $$
                    |  $$$$$$/                                 |  $$$$$$/
                     \______/                                   \______/ 

Registry is a component used to manage packages and scripts embedded
into the SVUI core addon.

It's main purpose is to keep all methods and logic needed to properly keep
core add-ins functioning outside of the core object.
--]]

--[[ LOCALIZED GLOBALS ]]--
--GLOBAL NAMESPACE
local _G = getfenv(0);
--LUA
local unpack        = _G.unpack;
local select        = _G.select;
local assert        = _G.assert;
local type          = _G.type;
local error         = _G.error;
local pcall         = _G.pcall;
local print         = _G.print;
local ipairs        = _G.ipairs;
local pairs         = _G.pairs;
local next          = _G.next;
local rawset        = _G.rawset;
local rawget        = _G.rawget;
local tostring      = _G.tostring;
local tonumber      = _G.tonumber;
local getmetatable  = _G.getmetatable;
local setmetatable  = _G.setmetatable;
--STRING
local string        = _G.string;
local upper         = string.upper;
local format        = string.format;
local find          = string.find;
local match         = string.match;
local gsub          = string.gsub;
--MATH
local math          = _G.math;
local floor         = math.floor
--TABLE
local table         = _G.table;
local tsort         = table.sort;
local tconcat       = table.concat;
local tinsert       = _G.tinsert;
local tremove       = _G.tremove;
local twipe         = _G.wipe;
--BLIZZARD API
local ReloadUI              = _G.ReloadUI;
local GetLocale             = _G.GetLocale;
local CreateFrame           = _G.CreateFrame;
local IsAddOnLoaded         = _G.IsAddOnLoaded;
local GetNumAddOns          = _G.GetNumAddOns;
local GetAddOnInfo          = _G.GetAddOnInfo;
local LoadAddOn             = _G.LoadAddOn;
local EnableAddOn           = _G.EnableAddOn;
local GetSpecialization     = _G.GetSpecialization;
local GetAddOnMetadata      = _G.GetAddOnMetadata;
local IsAddOnLoadOnDemand   = _G.IsAddOnLoadOnDemand;


--[[ LIB CONSTRUCT ]]--

local lib = LibSuperVillain:NewLibrary("Registry")

if not lib then return end -- No upgrade needed

--[[ ADDON DATA ]]--

local CoreName, CoreObject  = ...
local AddonVersion          = GetAddOnMetadata(..., "Version");
local SchemaFromMeta        = "X-SVUISchema";
local HeaderFromMeta        = "X-SVUIName";
local InterfaceVersion      = select(4, GetBuildInfo());

--[[ COMMON LOCAL VARS ]]--

local GLOBAL_FILENAME       = CoreName.."_Global";
local ERROR_FILENAME        = CoreName.."_Errors";
local PROFILE_FILENAME      = CoreName.."_Profile";
local CACHE_FILENAME        = CoreName.."_Cache";
local FILTERS_FILENAME      = CoreName.."_Filters";
local LAYOUTS_FILENAME      = CoreName.."_Layouts";
local SOURCE_KEY            = 1;
local GLOBAL_SV, PROFILE_SV, CACHE_SV, FILTER_SV, LAYOUT_SV, ERROR_CACHE, PLUGINS, MODULES;
local PluginString = ""
local AllowedIndexes, LoadOnDemand, ScriptQueue = {},{},{};

local playerClass = select(2,UnitClass("player"));

local INFO_FORMAT = "|cffFFFF00%s|r\n        |cff33FF00Version: %s|r |cff0099FFby %s|r";

if GetLocale() == "ruRU" then
    INFO_FORMAT = "|cffFFFF00%s|r\n        |cff33FF00Версия: %s|r |cff0099FFот %s|r";
end

--[[ LIB EVENT LISTENER ]]--

lib.EventManager = CreateFrame("Frame", nil)

--[[ COMMON META METHODS ]]--

local rootstring = function(self) return self.NameID end

--[[ CUSTOM LUA METHODS ]]--

--LOCAL HELPERS
local function formatValueString(text)
    if "string" == type(text) then 
        text = gsub(text,"\n","\\n")
        if match(gsub(text,"[^'\"]",""),'^"+$') then 
            return "'"..text.."'"; 
        else 
            return '"'..gsub(text,'"','\\"')..'"';
        end 
    else 
        return tostring(text);
    end
end

local function formatKeyString(text)
    if("string" == type(text) and match(text,"^[_%a][_%a%d]*$")) then 
        return text;
    else 
        return "["..formatValueString(text).."]";
    end
end

--APPENDED METHODS
function table.dump(targetTable)
    local dumpTable = {};
    local dumpCheck = {};
    for key,value in ipairs(targetTable) do 
        tinsert(dumpTable, formatValueString(value));
        dumpCheck[key] = true; 
    end 
    for key,value in pairs(targetTable) do 
        if not dumpCheck[key] then 
            tinsert(dumpTable, "\n    "..formatKeyString(key).." = "..formatValueString(value));
        end 
    end 
    local output = tconcat(dumpTable, ", ");
    return "{ "..output.." }";
end

function math.parsefloat(value, decimal)
    if(decimal and decimal > 0) then 
        local calc1 = 10 ^ decimal;
        local calc2 = (value * calc1) + 0.5;
        return floor(calc2) / calc1
    end 
    return floor(value + 0.5)
end

function table.copy(targetTable,deepCopy,mergeTable)
    mergeTable = mergeTable or {};
    if(targetTable == nil) then return nil end 
    if(mergeTable[targetTable]) then return mergeTable[targetTable] end 
    local replacementTable = {}
    for key,value in pairs(targetTable)do 
        if deepCopy and type(value) == "table" then 
            replacementTable[key] = table.copy(value, deepCopy, mergeTable)
        else 
            replacementTable[key] = value 
        end 
    end 
    setmetatable(replacementTable, table.copy(getmetatable(targetTable), deepCopy, mergeTable))
    mergeTable[targetTable] = replacementTable;
    return replacementTable 
end

function string.trim(this)
    return find(this, '^%s*$') and '' or match(this, '^%s*(.*%S)')
end

function string.color(this, color)
    return format("|cff%s%s|r", color, this)
end

function string.link(this, prefix, text, color)
    text = tostring(text)
    local colorstring = tostring(this):color(color or "ffffff")
    return format("|H%s:%s|h%s|h", prefix, text, colorstring)
end

function string.explode(this, delim)
    local pattern = format("([^%s]+)", delim)
    local res = {}
    for line in this:gmatch(pattern) do
        tinsert(res, line)
    end
    return res
end

--DATABASE LOCAL HELPERS

local function copydefaults(d, s)
    if(type(s) ~= "table") then return end
    if(type(d) ~= "table") then return end
    for k, v in pairs(s) do
        local saved = rawget(d, k)
        if type(v) == "table" then
            if not saved then rawset(d, k, {}) end
            copydefaults(d[k], v)
        else
            rawset(d, k, v)
        end
    end
end

local function tablecopy(d, s, debug)
    if(debug) then
        print(debug)
        assert(type(s) == "table", "tablecopy ERROR: source (" .. debug .. ") is not a table")
        assert(type(d) == "table", "tablecopy ERROR: destination (" .. debug .. ") is not a table")
    end
    if(type(s) ~= "table") then return end
    if(type(d) ~= "table") then return end
    for k, v in pairs(s) do
        local saved = rawget(d, k)
        if type(v) == "table" then
            if not saved then rawset(d, k, {}) end
            tablecopy(d[k], v)
        elseif(saved == nil or (saved and type(saved) ~= type(v))) then
            rawset(d, k, v)
        end
    end
end

local function tablesplice(mergeTable, targetTable)
    if type(targetTable) ~= "table" then targetTable = {} end

    if type(mergeTable) == 'table' then 
        for key,val in pairs(mergeTable) do 
            if type(val) == "table" then 
                targetTable[key] = tablesplice(val, targetTable[key])
            else
                targetTable[key] = val
            end  
        end 
    end 
    return targetTable 
end

local function importdata(s, d)
    if type(d) ~= "table" then d = {} end
    if type(s) == "table" then
        for k,v in pairs(s) do
            if type(v) == "table" then
                v = importdata(v, d[k])
            end
            d[k] = v
        end
    end
    return d
end

local function removedefaults(db, src, nometa)
    if(type(src) ~= "table") then
        if(db == src) then db = nil end 
        return 
    end
    if(not nometa) then
        setmetatable(db, nil)
    end
    for k,v in pairs(src) do
        if type(v) == "table" and type(db[k]) == "table" then
            removedefaults(db[k], v, nometa)
            if next(db[k]) == nil then
                db[k] = nil
            end
        else
            if db[k] == v then
                db[k] = nil
            end
        end
    end
end

local function sanitizeType1(db, src, output)
    if((type(src) == "table")) then
        if(type(db) == "table") then
            for k,v in pairs(db) do
                if(not src[k]) then
                    db[k] = nil
                else
                    if(src[k] ~= nil) then 
                        removedefaults(db[k], src[k])
                    end
                end
            end
        else
            db = {}
        end
    end
    if(output) then
        return db
    end
end

local function sanitizeType2(db, src)
    if((type(db) ~= "table") or (type(src) ~= "table")) then return end
    for k,v in pairs(db) do
        if(not src[k]) then
            db[k] = nil
        else
            if(src[k] ~= nil) then 
                if(not LoadOnDemand[k]) then
                    removedefaults(db[k], src[k])
                end
            end
        end
    end
end

local function CleanupData(data, checkLOD)
    local sv = rawget(data, "data")
    local src = rawget(data, "defaults")
    if(checkLOD) then
        sanitizeType2(sv, src)
    else
        sanitizeType1(sv, src)
    end
end

local function SanitizeStorage(data)
    for k,v in pairs(data) do
        if(k == "STORED" or k == "SAFEDATA" or k == "LAYOUT") then
            data[k] = nil
        end
    end
end

--DATABASE META METHODS
local meta_transdata = { 
    __index = function(t, k)
        if(not k or k == "") then return end
        local sv = rawget(t, "data")
        local dv = rawget(t, "defaults")
        local src = dv and dv[k]

        if(src ~= nil) then
            if(type(src) == "table") then 
                if(sv[k] == nil or (sv[k] ~= nil and type(sv[k]) ~= "table")) then sv[k] = {} end
                tablecopy(sv[k], src)
            else
                if(sv[k] == nil or (sv[k] ~= nil and type(sv[k]) ~= type(src))) then sv[k] = src end
            end
        end

        rawset(t, k, sv[k])
        return rawget(t, k)  
    end,
}

local meta_database = { 
    __index = function(t, k)
        if(not k or k == "") then return end
        local sv = rawget(t, "data")
        if(not sv[k]) then sv[k] = {} end
        rawset(t, k, sv[k])
        return rawget(t, k)  
    end,
}

local function LiveProfileChange()
    local LastKey = SOURCE_KEY
    if(PROFILE_SV.SAFEDATA and PROFILE_SV.SAFEDATA.dualSpecEnabled) then 
        SOURCE_KEY = GetSpecialization()
        lib.EventManager:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")

        if(not SOURCE_KEY) then
            SOURCE_KEY = 1
        end

        if(LastKey ~= SOURCE_KEY) then
            --construct core dataset
            local db           = setmetatable({}, meta_transdata)
            db.data            = PROFILE_SV.STORED[SOURCE_KEY]
            db.defaults        = CoreObject.defaults
            wipe(CoreObject.db)
            CoreObject.db      = db

            local cache        = setmetatable({}, meta_database)
            cache.data         = CACHE_SV.STORED[SOURCE_KEY]
            wipe(CoreObject.cache)
            CoreObject.cache   = cache

            if(CoreObject.ReLoad) then
                CoreObject:ReLoad()
            end

            lib:RefreshAll()
        end
    else
        SOURCE_KEY = 1
        lib.EventManager:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
    end
end

--DATABASE PUBLIC METHODS
function lib:Remove(key)
    if(GLOBAL_SV.profiles[key]) then GLOBAL_SV.profiles[key] = nil end
    if(GLOBAL_SV.cache[key]) then GLOBAL_SV.cache[key] = nil end
    twipe(GLOBAL_SV.profileKeys)
    for k,v in pairs(GLOBAL_SV.profiles) do
        GLOBAL_SV.profileKeys[k] = k
    end
    for k,v in pairs(GLOBAL_SV.cache) do
        GLOBAL_SV.profileKeys[k] = k
    end
end

function lib:GetProfiles()
    local list = GLOBAL_SV.profileKeys or {}
    return list
end

function lib:CheckProfiles()
    local hasProfile = false
    local list = GLOBAL_SV.profileKeys or {}
    for key,_ in pairs(list) do
        hasProfile = true
    end
    return hasProfile
end

function lib:CurrentProfile()
    return PROFILE_SV.SAFEDATA.GlobalKey
end

function lib:UnsetProfile()
    PROFILE_SV.SAFEDATA.GlobalKey = nil;
end

function lib:ImportDatabase(key, noreload)
    if(not key) then return end

    if(not GLOBAL_SV.profiles[key]) then GLOBAL_SV.profiles[key] = {} end;
    PROFILE_SV.STORED[SOURCE_KEY] = GLOBAL_SV.profiles[key]

    if(not GLOBAL_SV.cache[key]) then GLOBAL_SV.cache[key] = {} end;
    CACHE_SV.STORED[SOURCE_KEY] = GLOBAL_SV.cache[key]

    PROFILE_SV.SAFEDATA.GlobalKey = key;
    if(not noreload) then
        ReloadUI()
    end
end

function lib:ExportDatabase(key)
    if(not key) then return end

    local export, saved

    if(not GLOBAL_SV.profiles[key]) then GLOBAL_SV.profiles[key] = {} end;
    export = rawget(CoreObject.db, "data");
    saved = GLOBAL_SV.profiles[key];
    tablecopy(saved, export);

    if not GLOBAL_SV.cache[key] then GLOBAL_SV.cache[key] = {} end
    export = rawget(CoreObject.cache, "data")
    saved = GLOBAL_SV.cache[key]
    tablecopy(saved, export);


    twipe(GLOBAL_SV.profileKeys)
    for k,v in pairs(GLOBAL_SV.profiles) do
        GLOBAL_SV.profileKeys[k] = k
    end
    for k,v in pairs(GLOBAL_SV.cache) do
        GLOBAL_SV.profileKeys[k] = k
    end
end

function lib:SaveLayoutData(key, schema)
    if(not key) then return end
    if(not LAYOUT_SV[key]) then LAYOUT_SV[key] = {} end;

    local sv = rawget(data, "data");
    local src = rawget(data, "defaults");
    local copy_db = tablesplice(sv[schema], {})
    local copy_src = tablesplice(src[schema], {})

    LAYOUT_SV[key][schema] = sanitizeType1(copy_db, copy_src, true);
end

function lib:GetLayoutList()
    local list = {}
    for k,v in pairs(LAYOUT_SV) do
        list[k] = k
    end
    return list
end

function lib:GetLayoutData(key)
    if((not key) or (not LAYOUT_SV[key])) then return end
    return LAYOUT_SV[key]
end

function lib:CheckLayoutData()
    local hasData = false
    local list = LAYOUT_SV or {}
    for key,_ in pairs(list) do
        hasData = true
    end
    return hasData
end

function lib:RemoveLayout(key)
    if(LAYOUT_SV[key]) then LAYOUT_SV[key] = nil end
end

function lib:WipeDatabase()
    for k,v in pairs(PROFILE_SV.STORED[SOURCE_KEY]) do
        PROFILE_SV.STORED[SOURCE_KEY][k] = nil
    end
end

function lib:WipeCache(index)
    if(index) then
        CACHE_SV.STORED[SOURCE_KEY][index] = nil
    else
        for k,v in pairs(CACHE_SV.STORED[SOURCE_KEY]) do
            CACHE_SV.STORED[SOURCE_KEY][k] = nil
        end
    end
end

function lib:WipeGlobal()
    for k,v in pairs(GLOBAL_SV) do
        GLOBAL_SV[k] = nil
    end
end

function lib:GetSafeData(index)
    if(index) then
        return PROFILE_SV.SAFEDATA[index]
    else
        return PROFILE_SV.SAFEDATA
    end
end

function lib:SaveSafeData(index, value)
    PROFILE_SV.SAFEDATA[index] = value
end

function lib:CheckData(schema, key)
    local file = PROFILE_SV.STORED[SOURCE_KEY][schema]
    print("______" .. schema .. ".db[" .. key .. "]_____")
    print(file[key])
    print("______SAVED_____")
end

function lib:NewGlobal(index)
    index = index or CoreObject.Schema
    if(not GLOBAL_SV[index]) then
        GLOBAL_SV[index] = {}
    end
    return GLOBAL_SV[index]
end

--REGISTRY LOCAL HELPERS

local function HandleErrors(schema, action, catch)
    schema = schema or "LibSuperVillain:Registry"
    action = action or "Unknown Function"
    local timestamp = date("%m/%d/%y %H:%M:%S")
    local err_message = ("%s [%s] - (%s) %s"):format(schema, action, timestamp, catch)
    tinsert(ERROR_CACHE.FOUND, err_message)
    if(CoreObject.DebugMode == true) then
        --ScriptErrorsFrame_OnError(catch, false, true)
        CoreObject:Debugger(err_message)
    end
end

local function LoadingProxy(schema, obj)
    if(not obj) then return end
    if(not obj.initialized) then
        if(obj.Load and type(obj.Load) == "function") then
            local _, catch = pcall(obj.Load, obj)
            if(catch) then
                HandleErrors(schema, "Load", catch)
            else
                obj.initialized = true
            end
        end
    else
        if(obj.ReLoad and type(obj.ReLoad) == "function") then
            local _, catch = pcall(obj.ReLoad, obj)
            if(catch) then
                HandleErrors(schema, "ReLoad", catch)
            end
        end
    end
end

--OBJECT INTERNALS

local changeDBVar = function(self, value, key, sub1, sub2, sub3)
    local db = CoreObject.db[self.Schema]
    if((sub1 and sub2 and sub3) and (db[sub1] and db[sub1][sub2] and db[sub1][sub2][sub3])) then
        db[sub1][sub2][sub3][key] = value
    elseif((sub1 and sub2) and (db[sub1] and db[sub1][sub2])) then
        db[sub1][sub2][key] = value
    elseif(sub1 and db[sub1]) then
        db[sub1][key] = value
    else
        db[key] = value
    end

    if(self.UpdateLocals) then
        self:UpdateLocals()
    end
end

local changePluginDBVar = function(self, value, key, sub1, sub2, sub3)
    local db = self.db
    if((sub1 and sub2 and sub3) and (db[sub1] and db[sub1][sub2] and db[sub1][sub2][sub3])) then
        db[sub1][sub2][sub3][key] = value
    elseif((sub1 and sub2) and (db[sub1] and db[sub1][sub2])) then
        db[sub1][sub2][key] = value
    elseif(sub1 and db[sub1]) then
        db[sub1][key] = value
    else
        db[key] = value
    end

    if(self.UpdateLocals) then
        self:UpdateLocals()
    end
end

local innerOnEvent = function(self, event, ...)
    local obj = self.___owner
    local fn = self[event]
    if(fn and type(fn) == "function" and obj.initialized) then
        local _, catch = pcall(fn, obj, event, ...)
        if(catch) then
            local schema = obj.Schema
            HandleErrors(schema, event, catch)
        end
    end
end

local registerEvent = function(self, eventname, eventfunc)
    if not self.___eventframe then
        self.___eventframe = CreateFrame("Frame", nil)
        self.___eventframe.___owner = self
        self.___eventframe:SetScript("OnEvent", innerOnEvent)
    end
    
    if(not self.___eventframe[eventname]) then
        local fn = eventfunc
        if(type(eventfunc) == "string") then
            fn = self[eventfunc]
        elseif(not fn and self[eventname]) then
            fn = self[eventname]
        end
        self.___eventframe[eventname] = fn
    end
    
    self.___eventframe:RegisterEvent(eventname)
end

local unregisterEvent = function(self, event, ...)
    if(self.___eventframe) then
        self.___eventframe:UnregisterEvent(event)
    end
end

local innerOnUpdate = function(self, elapsed)
    if self.elapsed and self.elapsed > (self.throttle) then
        local obj = self.___owner
        local callbacks = self.callbacks

        for name, fn in pairs(callbacks) do
            local _, catch = pcall(fn, obj)
            if(catch and CoreObject.Debugging) then
                local schema = obj.Schema
                HandleErrors(schema, "OnUpdate", catch)
            end
        end

        self.elapsed = 0
    else
        self.elapsed = (self.elapsed or 0) + elapsed
    end
end

local registerUpdate = function(self, updatefunc, throttle)
    if not self.___updateframe then
        self.___updateframe = CreateFrame("Frame", nil);
        self.___updateframe.___owner = self;
        self.___updateframe.callbacks = {};
        self.___updateframe.elapsed = 0;
        self.___updateframe.throttle = throttle or 0.2;
    end

    if(updatefunc and type(updatefunc) == "string" and self[updatefunc]) then
        self.___updateframe.callbacks[updatefunc] = self[updatefunc]
    end

    self.___updateframe:SetScript("OnUpdate", innerOnUpdate)
end

local unregisterUpdate = function(self, updatefunc)
    if(updatefunc and type(updatefunc) == "string" and self.___updateframe.callbacks[updatefunc]) then
        self.___updateframe.callbacks[updatefunc] = nil
        if(#self.___updateframe.callbacks == 0) then
            self.___updateframe:SetScript("OnUpdate", nil)
        end
    else
        self.___updateframe:SetScript("OnUpdate", nil)
    end
end

local function SetPluginString(addonName)
    local author = GetAddOnMetadata(addonName, "Author") or "Unknown"
    local name = GetAddOnMetadata(addonName, "Title") or addonName
    local version = GetAddOnMetadata(addonName, "Version") or "???"
    return INFO_FORMAT:format(name, version, author)
end

--REGISTRY PUBLIC METHODS

function lib:RefreshModule(schema)
    local obj = CoreObject[schema]
    LoadingProxy(schema, obj)
end

function lib:RefreshPlugin(schema)
    local obj = _G[schema]
    LoadingProxy(schema, obj)
end

function lib:RefreshAll()
    for _,schema in pairs(MODULES) do
        local obj = CoreObject[schema]
        LoadingProxy(schema, obj)
    end

    for schema,_ in pairs(PLUGINS) do
        local obj = _G[schema]
        LoadingProxy(schema, obj)
    end
end

function lib:LiveUpdate(override)
    if((PROFILE_SV.SAFEDATA.NEEDSLIVEUPDATE or override) and not C_PetBattles.IsInBattle()) then
        self:RefreshAll()
        PROFILE_SV.SAFEDATA.NEEDSLIVEUPDATE = false
    end
end

function lib:GetModuletable()
    return MODULES
end

function lib:GetPlugins()
    return PluginString
end

function lib:CheckDualProfile()
    return PROFILE_SV.SAFEDATA.dualSpecEnabled
end

function lib:ToggleDualProfile(enabled)
    PROFILE_SV.SAFEDATA.dualSpecEnabled = enabled
    if(enabled) then
        self.EventManager:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
        LiveProfileChange()
    else
        self.EventManager:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
    end
end

function lib:LoadQueuedModules()
    if MODULES then
        for i=1,#MODULES do 
            local schema = MODULES[i]
            local obj = CoreObject[schema]
            local data = CoreObject.db[schema]
            if(obj and data and data.enable and (not obj.initialized)) then
                local halt = false
                if(data.incompatible) then
                    for addon,_ in pairs(data.incompatible) do
                        if IsAddOnLoaded(addon) then halt = true end
                    end
                end
                if(not halt) then
                    LoadingProxy(schema, obj)
                end
            end
        end
    end
end

function lib:LoadQueuedPlugins()
    if PLUGINS then
        for schema,files in pairs(PLUGINS) do
            if(not PROFILE_SV.SAFEDATA[schema]) then
                PROFILE_SV.SAFEDATA[schema] = {["enable"] = true}
            end

            local obj = _G[schema]
            local enabled = PROFILE_SV.SAFEDATA[schema].enable
            if(obj and enabled and (not obj.initialized)) then
                local halt = false

                if(files.PROFILE) then
                    if not _G[files.PROFILE] then _G[files.PROFILE] = {} end
                    local db = setmetatable({}, meta_transdata)
                    db.data = _G[files.PROFILE]
                    db.defaults = obj.defaults
                    obj.db = db
                end

                if(files.CACHE) then
                    if not _G[files.CACHE] then _G[files.CACHE] = {} end
                    local cache = setmetatable({}, meta_database)
                    cache.data = _G[files.CACHE]
                    obj.cache = cache
                end

                if(files.GLOBAL) then
                    if not _G[files.GLOBAL] then _G[files.GLOBAL] = {} end
                    local public = setmetatable({}, meta_database)
                    public.data = _G[files.GLOBAL]
                    obj.public = public
                end

                if(obj.db and obj.db.incompatible) then
                    for addon,_ in pairs(obj.db.incompatible) do
                        if IsAddOnLoaded(addon) then halt = true end
                    end
                end

                if(not halt) then
                    LoadingProxy(schema, obj)
                end
            end 
        end
    end
end

--[[ CONSTRUCTORS ]]--

function lib:NewPlugin(addonName, addonObject, pfile, gfile, cfile)
    local version   = GetAddOnMetadata(addonName, "Version")
    local header    = GetAddOnMetadata(addonName, HeaderFromMeta)
    local schema    = GetAddOnMetadata(addonName, SchemaFromMeta)
    local lod       = IsAddOnLoadOnDemand(addonName)
    local addonmeta = {}
    local oldmeta   = getmetatable(addonObject)

    if oldmeta then
        for k, v in pairs(oldmeta) do addonmeta[k] = v end
    end

    addonmeta.__tostring = rootstring
    setmetatable( addonObject, addonmeta )

    addonObject.Version             = version
    addonObject.NameID              = addonName
    addonObject.TitleID             = header
    addonObject.Schema              = schema
    addonObject.LoD                 = lod
    addonObject.initialized         = false
    addonObject.CombatLocked        = false
    addonObject.ChangeDBVar         = changePluginDBVar
    addonObject.RegisterEvent       = registerEvent
    addonObject.UnregisterEvent     = unregisterEvent
    addonObject.RegisterUpdate      = registerUpdate
    addonObject.UnregisterUpdate    = unregisterUpdate

    addonObject.public              = addonObject.public or {}
    addonObject.defaults            = addonObject.defaults or {}
    addonObject.cache               = addonObject.cache or {}
    addonObject.db                  = tablesplice(addonObject.defaults, {})

    if(IsAddOnLoaded(addonName) and not lod) then
        CoreObject.Options.args.plugins.args.pluginOptions.args[schema] = {
            type = "group", 
            name = header, 
            childGroups = "tree", 
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = "Enable",
                    get = function() 
                        return PROFILE_SV.SAFEDATA[schema].enable 
                    end,
                    set = function(key, value) 
                        PROFILE_SV.SAFEDATA[schema].enable = value; 
                        CoreObject:StaticPopup_Show("RL_CLIENT") 
                    end,
                }
            }
        }
    end

    _G[schema] = addonObject

    if(not PLUGINS) then PLUGINS = {} end

    PLUGINS[schema] = {
        ["GLOBAL"] = gfile,
        ["PROFILE"] = pfile,
        ["CACHE"] = cfile,
    };

    local infoString = SetPluginString(addonName)
    local oldString = PluginString
    PluginString = ("%s%s\n"):format(oldString, infoString)

    return addonObject
end

local function NewLoadOnDemand(addonName, schema, header)
    LoadOnDemand[schema] = addonName;
    CoreObject.Options.args.plugins.args.pluginOptions.args[schema] = {
        type = "group", 
        name = header, 
        childGroups = "tree", 
        args = {
            enable = {
                order = 1,
                type = "execute",
                width = "full",
                name = function() 
                    local nameString = "Disable"
                    if(not IsAddOnLoaded(addonName)) then 
                        nameString = "Enable" 
                    end
                    return nameString
                end,
                func = function()
                    if(not IsAddOnLoaded(addonName)) then 
                        local loaded, reason = LoadAddOn(addonName)
                        PROFILE_SV.SAFEDATA[schema].enable = true
                        EnableAddOn(addonName)
                        CoreObject:StaticPopup_Show("RL_CLIENT")
                    else
                        PROFILE_SV.SAFEDATA[schema].enable = false
                        DisableAddOn(addonName)
                        CoreObject:StaticPopup_Show("RL_CLIENT")
                    end
                end,
            }
        }
    }
end

--LIBRARY EVENT HANDLING

local Library_OnEvent = function(self, event, arg, ...)
    if(event == "PLAYER_LOGOUT") then
        local key = PROFILE_SV.SAFEDATA.GlobalKey
        if(key) then
            local export, saved
            if(not GLOBAL_SV.profiles[key]) then GLOBAL_SV.profiles[key] = {} end;
            export = rawget(CoreObject.db, "data");
            saved = GLOBAL_SV.profiles[key];
            tablecopy(saved, export);
            if not GLOBAL_SV.cache[key] then GLOBAL_SV.cache[key] = {} end
            export = rawget(CoreObject.cache, "data")
            saved = GLOBAL_SV.cache[key]
            tablecopy(saved, export);
        end
        CleanupData(CoreObject.db, true)
        CleanupData(CoreObject.filters)
    elseif(event == "ADDON_LOADED") then
        if(arg == CoreName) then
            if(not CoreObject.___loaded and CoreObject.PreLoad) then
                CoreObject:PreLoad()
                CoreObject.___loaded = true
                self:UnregisterEvent("ADDON_LOADED")
            end
        end
    elseif(event == "PLAYER_LOGIN") then
        if(not CoreObject.___initialized and CoreObject.Initialize and IsLoggedIn()) then
            CoreObject:Initialize()
            CoreObject.___initialized = true
            self:UnregisterEvent("PLAYER_LOGIN")
        end
    elseif(event == "ACTIVE_TALENT_GROUP_CHANGED") then
        LiveProfileChange()
    end
end

-- CORE OBJECT CONSTRUCT

local addNewSubClass = function(self, schema)
    if(self[schema]) then return end

    local obj = {
        parent              = self,
        Schema              = schema,
        RegisterEvent       = registerEvent,
        UnregisterEvent     = unregisterEvent,
        RegisterUpdate      = registerUpdate,
        UnregisterUpdate    = unregisterUpdate
    }

    local addonmeta = {}
    local oldmeta = getmetatable(obj)
    if oldmeta then
        for k, v in pairs(oldmeta) do addonmeta[k] = v end
    end
    addonmeta.__tostring = rootstring
    setmetatable( obj, addonmeta )

    self[schema] = obj
    
    return self[schema]
end

local Core_NewClass = function(self, schema, header)
    if(self[schema]) then return end

    AllowedIndexes[schema] = schema

    local addonName = ("SVUI [%s]"):format(schema)

    local obj = {
        NameID              = addonName,
        TitleID             = header,
        Schema              = schema,
        initialized         = false,
        CombatLocked        = false,
        ChangeDBVar         = changeDBVar,
        RegisterEvent       = registerEvent,
        UnregisterEvent     = unregisterEvent,
        RegisterUpdate      = registerUpdate,
        UnregisterUpdate    = unregisterUpdate,
        NewSubClass         = addNewSubClass
    }

    local addonmeta = {}
    local oldmeta = getmetatable(obj)
    if oldmeta then
        for k, v in pairs(oldmeta) do addonmeta[k] = v end
    end
    addonmeta.__tostring = rootstring
    setmetatable( obj, addonmeta )

    self[schema] = obj
    
    return self[schema]
end

local Core_NewScript = function(self, fn)
    if(fn and type(fn) == "function") then
        ScriptQueue[#ScriptQueue+1] = fn
    end 
end

local Core_NewPackage = function(self, schema, header)
    if(self[schema]) then return end

    if(not MODULES) then MODULES = {} end
    MODULES[#MODULES+1] = schema

    AllowedIndexes[schema] = schema

    local addonName = ("SVUI [%s]"):format(schema)

    local obj = {
        NameID              = addonName,
        TitleID             = header,
        Schema              = schema,
        initialized         = false,
        CombatLocked        = false,
        ChangeDBVar         = changeDBVar,
        RegisterEvent       = registerEvent,
        UnregisterEvent     = unregisterEvent,
        RegisterUpdate      = registerUpdate,
        UnregisterUpdate    = unregisterUpdate
    }

    local addonmeta = {}
    local oldmeta = getmetatable(obj)
    if oldmeta then
        for k, v in pairs(oldmeta) do addonmeta[k] = v end
    end
    addonmeta.__tostring = rootstring
    setmetatable( obj, addonmeta )

    self[schema] = obj
    
    return self[schema]
end

local Core_ResetData = function(self, sub, sub2, sub3)
    local data = self.db
    local sv = rawget(data, "data")
    local src = rawget(data, "defaults")
    local targetData
    if(sub3 and sub2 and sv and sv[sub] and sv[sub][sub2]) then
        targetData = sv[sub][sub2][sub3]
    elseif(sub2 and sv and sv[sub]) then
        targetData = sv[sub][sub2]
    elseif(sub and sv) then
        targetData = sv[sub]
    else
        targetData = sv
    end
    if(targetData) then
        if(type(targetData) == 'table') then
            for k,v in pairs(targetData) do
                targetData[k] = nil
            end
        else
            targetData = nil
        end
    else
        sv = {}
    end
    tablecopy(sv, src)
end

local Core_ResetFilter = function(self, key)
    local data = self.filters
    local sv = rawget(data, "data")
    local src = rawget(data, "defaults")
    local targetData
    if(key and sv[key]) then
        targetData = sv[key]
    else
        targetData = sv
    end
    if(targetData) then
        if(type(targetData) == 'table') then
            for k,v in pairs(targetData) do
                targetData[k] = nil
            end
        else
            targetData = nil
        end
    else
        sv = {}
    end
    tablecopy(sv, src)
end

function lib:NewCore(gfile, efile, pfile, cfile, ffile, lfile)
    --meta assurance
    local mt = {};
    local old = getmetatable(CoreObject);
    if old then
        for k, v in pairs(old) do mt[k] = v end
    end
    mt.__tostring = rootstring;
    setmetatable(CoreObject, mt);

    --database
    GLOBAL_FILENAME = gfile or GLOBAL_FILENAME
    ERROR_FILENAME = efile or ERROR_FILENAME
    PROFILE_FILENAME = pfile or PROFILE_FILENAME
    CACHE_FILENAME  = cfile or CACHE_FILENAME
    FILTERS_FILENAME = ffile or FILTERS_FILENAME
    LAYOUTS_FILENAME = lfile or LAYOUTS_FILENAME

    --events
    if(not self.EventManager.Initialized) then
        self.EventManager:RegisterEvent("ADDON_LOADED")
        self.EventManager:RegisterEvent("PLAYER_LOGIN")
        self.EventManager:RegisterEvent("PLAYER_LOGOUT")
        self.EventManager:SetScript("OnEvent", Library_OnEvent)
        self.EventManager.Initialized = true
    end

    --internals
    CoreObject.___errors            = {};

    CoreObject.NameID               = CoreName;
    CoreObject.Version              = AddonVersion;
    CoreObject.GameVersion          = tonumber(InterfaceVersion);
    CoreObject.DebugMode            = true;
    CoreObject.Schema               = GetAddOnMetadata(CoreName, SchemaFromMeta);
    CoreObject.TitleID              = GetAddOnMetadata(CoreName, HeaderFromMeta);

    CoreObject.RegisterEvent        = registerEvent
    CoreObject.UnregisterEvent      = unregisterEvent
    CoreObject.RegisterUpdate       = registerUpdate
    CoreObject.UnregisterUpdate     = unregisterUpdate

    CoreObject.NewScript            = Core_NewScript
    CoreObject.NewPackage           = Core_NewPackage
    CoreObject.NewClass             = Core_NewClass
    CoreObject.ResetData            = Core_ResetData
    CoreObject.ResetFilter          = Core_ResetFilter

    if(not CoreObject.defaults) then 
        CoreObject.defaults = {} 
    end
    CoreObject.db                   = tablesplice(CoreObject.defaults, {})

    if(not CoreObject.filterdefaults) then 
        CoreObject.filterdefaults = {} 
    end
    CoreObject.filters              = tablesplice(CoreObject.filterdefaults, {})

    if(not CoreObject.customlayouts) then 
        CoreObject.customlayouts = {} 
    end

    --set global
    _G[CoreName] = CoreObject;

    return _G[CoreName]
end

-- INITIALIZE AND LAUNCH

function lib:Initialize()
    local coreSchema = CoreObject.Schema
    --GLOBAL SAVED VARIABLES
    if not _G[GLOBAL_FILENAME] then _G[GLOBAL_FILENAME] = {} end
    GLOBAL_SV = _G[GLOBAL_FILENAME]

    if(GLOBAL_SV.profileKeys) then 
      twipe(GLOBAL_SV.profileKeys) 
    else
      GLOBAL_SV.profileKeys = {}
    end

    GLOBAL_SV.profiles = GLOBAL_SV.profiles or {}
    for k,v in pairs(GLOBAL_SV.profiles) do
        GLOBAL_SV.profileKeys[k] = k
    end

    GLOBAL_SV.cache = GLOBAL_SV.cache or {}
    for k,v in pairs(GLOBAL_SV.cache) do
        GLOBAL_SV.profileKeys[k] = k
    end

    --SAVED ERRORS
    if not _G[ERROR_FILENAME] then _G[ERROR_FILENAME] = {} end
    ERROR_CACHE = _G[ERROR_FILENAME]

    local datestamp = date("%m_%d_%y")

    if(ERROR_CACHE.TODAY and ERROR_CACHE.TODAY ~= datestamp) then 
        ERROR_CACHE.FOUND = {} 
    end

    if(not ERROR_CACHE.FOUND) then 
        ERROR_CACHE.FOUND = {}
    end

    ERROR_CACHE.TODAY = datestamp

    --CUSTOM LAYOUTS
    if not _G[LAYOUTS_FILENAME] then _G[LAYOUTS_FILENAME] = {} end
    LAYOUT_SV = _G[LAYOUTS_FILENAME]

    if(self:CheckLayoutData()) then
        CoreObject.CustomLayouts = true
    end

    --CACHE SAVED VARIABLES
    if not _G[CACHE_FILENAME] then _G[CACHE_FILENAME] = {} end
    CACHE_SV = _G[CACHE_FILENAME]
    if(not CACHE_SV.STORED) then
        CACHE_SV.STORED = {}
        CACHE_SV.STORED[1] = {}
        CACHE_SV.STORED[2] = {}
        CACHE_SV.STORED[3] = {}
        if playerClass == "DRUID" then
            CACHE_SV.STORED[4] = {}
        end
        for k,v in pairs(CACHE_SV) do
            if(k ~= "STORED") then
                CACHE_SV.STORED[1][k] = v
            end
        end
    end

    --PROFILE SAVED VARIABLES
    if not _G[PROFILE_FILENAME] then _G[PROFILE_FILENAME] = {} end

    PROFILE_SV = _G[PROFILE_FILENAME]

    if not PROFILE_SV.SAFEDATA then PROFILE_SV.SAFEDATA = {dualSpecEnabled = false} end
    if not PROFILE_SV.SAFEDATA.NEEDSLIVEUPDATE then PROFILE_SV.SAFEDATA.NEEDSLIVEUPDATE = false end

    if(PROFILE_SV.SAFEDATA and PROFILE_SV.SAFEDATA.dualSpecEnabled) then 
        SOURCE_KEY = GetSpecialization() or 1
        self.EventManager:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
    else
        SOURCE_KEY = 1
        self.EventManager:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
    end

    if(not PROFILE_SV.STORED) then
        PROFILE_SV.STORED = {}
        PROFILE_SV.STORED[1] = {}
        PROFILE_SV.STORED[1][coreSchema] = {}
        PROFILE_SV.STORED[2] = {}
        PROFILE_SV.STORED[2][coreSchema] = {}
        PROFILE_SV.STORED[3] = {}
        PROFILE_SV.STORED[3][coreSchema] = {}
        if playerClass == "DRUID" then
            PROFILE_SV.STORED[4] = {}
            PROFILE_SV.STORED[4][coreSchema] = {}
        end

        --Attempt to copy any prior variables, even outdated
        if(PROFILE_SV.system or (MODULES[1] and PROFILE_SV[MODULES[1]])) then
            for k,v in pairs(PROFILE_SV) do
                if(k == "system") then
                    tablecopy(v, PROFILE_SV.STORED[1][coreSchema])
                elseif(k == "media" or k == "filter") then
                    PROFILE_SV.STORED[1][coreSchema][k] = v
                elseif(AllowedIndexes[k]) then
                    PROFILE_SV.STORED[1][k] = v
                end
            end
        end
    else
        PROFILE_SV.STORED[1] = PROFILE_SV.STORED[1] or {}
        PROFILE_SV.STORED[1][coreSchema] = PROFILE_SV.STORED[1][coreSchema] or {}
        SanitizeStorage(PROFILE_SV.STORED[1])

        PROFILE_SV.STORED[2] = PROFILE_SV.STORED[2] or {}
        PROFILE_SV.STORED[2][coreSchema] = PROFILE_SV.STORED[2][coreSchema] or {}
        SanitizeStorage(PROFILE_SV.STORED[2])

        PROFILE_SV.STORED[3] = PROFILE_SV.STORED[3] or {}
        PROFILE_SV.STORED[3][coreSchema] = PROFILE_SV.STORED[3][coreSchema] or {}
        SanitizeStorage(PROFILE_SV.STORED[3])

        if playerClass == "DRUID" then
            PROFILE_SV.STORED[4] = PROFILE_SV.STORED[4] or {}
            PROFILE_SV.STORED[4][coreSchema] = PROFILE_SV.STORED[4][coreSchema] or {}
            SanitizeStorage(PROFILE_SV.STORED[4])
        elseif PROFILE_SV.STORED[4] then
            PROFILE_SV.STORED[4] = nil
        end

    end

    for k,v in pairs(PROFILE_SV) do
        if(k ~= "STORED" and k ~= "SAFEDATA") then
            PROFILE_SV[k] = nil
        end
    end

    local key = PROFILE_SV.SAFEDATA.GlobalKey
    if(key) then
        if(not GLOBAL_SV.profiles[key]) then GLOBAL_SV.profiles[key] = {} end;
        PROFILE_SV.STORED[SOURCE_KEY] = GLOBAL_SV.profiles[key];

        if(not GLOBAL_SV.cache[key]) then GLOBAL_SV.cache[key] = {} end;
        CACHE_SV.STORED[SOURCE_KEY] = GLOBAL_SV.cache[key];
    end

    --FILTER SAVED VARIABLES
    if not _G[FILTERS_FILENAME] then _G[FILTERS_FILENAME] = {} end

    FILTER_SV = _G[FILTERS_FILENAME]

    --construct core dataset
    local db           = setmetatable({}, meta_transdata)
    db.data            = PROFILE_SV.STORED[SOURCE_KEY]
    db.defaults        = CoreObject.defaults
    CoreObject.db      = db

    local filters      = setmetatable({}, meta_transdata)
    filters.data       = FILTER_SV
    filters.defaults   = CoreObject.filterdefaults
    CoreObject.filters = filters

    local cache        = setmetatable({}, meta_database)
    cache.data         = CACHE_SV.STORED[SOURCE_KEY]
    CoreObject.cache   = cache

    --check for LOD plugins
    local addonCount = GetNumAddOns()

    for i = 1, addonCount do
        local addonName, _, _, _, _, reason = GetAddOnInfo(i)

        if(IsAddOnLoadOnDemand(i)) then
            local header = GetAddOnMetadata(i, HeaderFromMeta)
            local schema = GetAddOnMetadata(i, SchemaFromMeta)

            if(header and schema) then
                NewLoadOnDemand(addonName, schema, header)
            end
        end
    end

    CoreObject.initialized = true
end

function lib:Launch()
    if LoadOnDemand then
        for schema,name in pairs(LoadOnDemand) do

            if(not PROFILE_SV.SAFEDATA[schema]) then
                PROFILE_SV.SAFEDATA[schema] = {["enable"] = false}
            end

            local db = PROFILE_SV.SAFEDATA[schema]

            if(db and (db.enable or db.enable ~= false)) then
                if(not IsAddOnLoaded(name)) then
                    local loaded, reason = LoadAddOn(name)
                end
                EnableAddOn(name)
            else
                DisableAddOn(name)
            end
        end
    end

    self:LoadQueuedModules()
    self:LoadQueuedPlugins()

    if ScriptQueue then
        for i=1, #ScriptQueue do 
            local fn = ScriptQueue[i]
            if(fn and type(fn) == "function") then
                fn()
            end 
        end

        ScriptQueue = nil
    end

    PROFILE_SV.SAFEDATA.NEEDSLIVEUPDATE = C_PetBattles.IsInBattle()
end