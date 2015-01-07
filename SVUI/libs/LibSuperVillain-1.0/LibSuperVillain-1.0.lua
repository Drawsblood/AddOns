--[[
  /$$$$$$  /$$   /$$ /$$$$$$$  /$$$$$$$$ /$$$$$$$                  
 /$$__  $$| $$  | $$| $$__  $$| $$_____/| $$__  $$                 
| $$  \__/| $$  | $$| $$  \ $$| $$      | $$  \ $$                 
|  $$$$$$ | $$  | $$| $$$$$$$/| $$$$$   | $$$$$$$/                 
 \____  $$| $$  | $$| $$____/ | $$__/   | $$__  $$                 
 /$$  \ $$| $$  | $$| $$      | $$      | $$  \ $$                 
|  $$$$$$/|  $$$$$$/| $$      | $$$$$$$$| $$  | $$                 
 \______/  \______/ |__/      |________/|__/  |__/                 
 /$$    /$$ /$$$$$$ /$$       /$$        /$$$$$$  /$$$$$$ /$$   /$$
| $$   | $$|_  $$_/| $$      | $$       /$$__  $$|_  $$_/| $$$ | $$
| $$   | $$  | $$  | $$      | $$      | $$  \ $$  | $$  | $$$$| $$
|  $$ / $$/  | $$  | $$      | $$      | $$$$$$$$  | $$  | $$ $$ $$
 \  $$ $$/   | $$  | $$      | $$      | $$__  $$  | $$  | $$  $$$$
  \  $$$/    | $$  | $$      | $$      | $$  | $$  | $$  | $$\  $$$
   \  $/    /$$$$$$| $$$$$$$$| $$$$$$$$| $$  | $$ /$$$$$$| $$ \  $$
    \_/    |______/|________/|________/|__/  |__/|______/|__/  \__/
                                                                   

LibSuperVillain is a library used to manage localization, packages, scripts, animations and data embedded
into the SVUI core addon.

It's main purpose is to keep all methods and logic needed to properly keep
core add-ins functioning outside of the core object and away from other libraries like LibStub.                                                                     
--]]
local _G = getfenv(0)

local LibSuperVillain = _G["LibSuperVillain"]

if not LibSuperVillain then
    LibSuperVillain = LibSuperVillain or {libs = {}}
    _G["LibSuperVillain"] = LibSuperVillain
    
    function LibSuperVillain:NewLibrary(libName)
        assert(type(libName) == "string", "Missing Library Name")
        self.libs[libName] = self.libs[libName] or {}
        return self.libs[libName]
    end
    
    function LibSuperVillain:Fetch(libName, silent)
        if not self.libs[libName] and not silent then
            error(("Cannot find a library instance of %q."):format(tostring(libName)), 2)
        end
        return self.libs[libName]
    end

    setmetatable(LibSuperVillain, { __call = LibSuperVillain.Fetch })
end
