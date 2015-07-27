local GlobalAddonName, ExRT = ...

local module = ExRT.mod:New("Profiles",ExRT.L.Profiles,nil,true)

local MAJOR_KEYS = {
	["Addon"]=true,
	["Profiles"]=true,
	["Profile"]=true,
	["ProfileKeys"]=true,
}

function module:ReselectProfileOnLoad()
	if VExRT.ProfileKeys and not VExRT.ProfileKeys[ ExRT.SDB.charKey ] then
		VExRT.ProfileKeys[ ExRT.SDB.charKey ] = "default"
	end
	if not VExRT.ProfileKeys or not VExRT.ProfileKeys[ ExRT.SDB.charKey ] or not VExRT.Profile or not VExRT.Profiles then
		return
	end
	local charProfile = VExRT.ProfileKeys[ ExRT.SDB.charKey ]
	if charProfile == VExRT.Profile then
		return
	end
	if not VExRT.Profiles[ charProfile ] then
		VExRT.ProfileKeys[ ExRT.SDB.charKey ] = VExRT.Profile
		return
	end
	local saveDB = {}
	VExRT.Profiles[ VExRT.Profile ] = saveDB
	
	for key,val in pairs(VExRT) do
		if not MAJOR_KEYS[key] then
			saveDB[key] = val
		end
	end
	
	for key,val in pairs(VExRT) do
		if not MAJOR_KEYS[key] then
			VExRT[key] = nil
		end
	end
	
	for key,val in pairs( VExRT.Profiles[ charProfile ] ) do
		if not MAJOR_KEYS[key] then
			VExRT[key] = val
		end
	end
	VExRT.Profiles[ charProfile ] = {}
	VExRT.Profile = charProfile
end

function module.options:Load()
	local function GetCurrentProfileName()
		return VExRT.Profile=="default" and ExRT.L.ProfilesDefault or VExRT.Profile
	end
	local function GetCurrentProfilesList(func)
		local list = {
			{ text = ExRT.L.ProfilesDefault, func = func, arg1 = "default", _sort = "0" },
		}
		for name,_ in pairs(VExRT.Profiles) do
			if name ~= "default" then
				list[#list + 1] = { text = name, func = func, arg1 = name, _sort = "1"..name }
			end
		end
		sort(list,function(a,b) return a._sort < b._sort end)
		return list
	end
	local function SaveCurrentProfiletoDB()
		local profileName = VExRT.Profile or "default"
		local saveDB = {}
		VExRT.Profiles[ profileName ] = saveDB
		
		for key,val in pairs(VExRT) do
			if not MAJOR_KEYS[key] then
				saveDB[key] = val
			end
		end
	end
	local function LoadProfileFromDB(profileName,isCopy)
		local loadDB = VExRT.Profiles[ profileName ]
		if not loadDB then
			print("Error")
			return
		end
		
		for key,val in pairs(VExRT) do
			if not MAJOR_KEYS[key] then
				VExRT[key] = nil
			end
		end
		for key,val in pairs(loadDB) do
			if not MAJOR_KEYS[key] then
				VExRT[key] = val
			end
		end
		
		if not isCopy then
			VExRT.Profiles[ profileName ] = {}
		end
		
		ReloadUI()
	end

	self:CreateTilte()

	self.introText = ExRT.lib.CreateText(self,650,200,nil,5,-45,nil,"TOP",nil,11,ExRT.L.ProfilesIntro,nil,1,1,1)
	
	self.currentText = ExRT.lib.CreateText(self,650,200,nil,5,-90,nil,"TOP",nil,11,ExRT.L.ProfilesCurrent,nil,1,1,1)
	self.currentName = ExRT.lib.CreateText(self,650,200,nil,200,-90,nil,"TOP",nil,11,GetCurrentProfileName())

	self.choseText = ExRT.lib.CreateText(self,650,200,nil,5,-130,nil,"TOP",nil,11,ExRT.L.ProfilesChooseDesc,nil,1,1,1)
	
	self.choseNewText = ExRT.lib.CreateText(self,650,200,nil,15,-158,nil,"TOP",nil,11,ExRT.L.ProfilesNew)
	self.choseNew = ExRT.lib.CreateEditBox(self,170,20,"TOPLEFT",10,-170,nil,nil,nil,"ExRTInputBoxModernTemplate")
	
	self.choseNewButton = ExRT.lib.CreateButton(self,70,20,nil,0,0,ExRT.L.ProfilesAdd,nil,nil,"ExRTButtonModernTemplate")
	self.choseNewButton:SetNewPoint("LEFT",self.choseNew,"RIGHT",0,0)
	self.choseNewButton:SetScript("OnClick",function (self)
		local text = module.options.choseNew:GetText()
		module.options.choseNew:SetText("")
		if text == "" or text == "default" or VExRT.Profiles[text] then
			return
		end
		VExRT.Profiles[text] = {}
		
		StaticPopupDialogs["EXRT_PROFILES_ACTIVATE"] = {
			text = ExRT.L.ProfilesActivateAlert,
			button1 = ExRT.L.YesText,
			button2 = ExRT.L.NoText,
			OnAccept = function()
				SaveCurrentProfiletoDB()
				VExRT.Profile = text
				VExRT.ProfileKeys[ ExRT.SDB.charKey ] = text
				LoadProfileFromDB(text)
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("EXRT_PROFILES_ACTIVATE")
	end)
	
	self.choseSelectText = ExRT.lib.CreateText(self,605,200,nil,325,-158,nil,"TOP",nil,11,ExRT.L.ProfilesSelect)
	self.choseSelectDropDown = ExRT.lib.CreateScrollDropDown(self,"TOPLEFT",320,-170,235,220,10,GetCurrentProfileName(),nil,"ExRTDropDownMenuModernTemplate")
	
	local function SelectProfile(_,name)
		ExRT.lib.ScrollDropDown.Close()
		if name == VExRT.Profile then
			return
		end
		SaveCurrentProfiletoDB()
		VExRT.Profile = name
		VExRT.ProfileKeys[ ExRT.SDB.charKey ] = name
		LoadProfileFromDB(name)
	end
	function self.choseSelectDropDown:ToggleUpadte()
		self.List = GetCurrentProfilesList(SelectProfile)
	end
	
	local function CopyProfile(_,name)
		ExRT.lib.ScrollDropDown.Close()
		LoadProfileFromDB(name,true)
	end
	self.copyText = ExRT.lib.CreateText(self,605,200,nil,15,-208,nil,"TOP",nil,11,ExRT.L.ProfilesCopy)
	self.copyDropDown = ExRT.lib.CreateScrollDropDown(self,"TOPLEFT",10,-220,235,220,10,"",nil,"ExRTDropDownMenuModernTemplate")
	function self.copyDropDown:ToggleUpadte()
		self.List = GetCurrentProfilesList(CopyProfile)
		for i=1,#self.List do
			if self.List[i].arg1 == VExRT.Profile then
				for j=i,#self.List do
					self.List[j] = self.List[j+1]
				end
				break
			end
		end
	end
	
	local function DeleteProfile(_,name)
		ExRT.lib.ScrollDropDown.Close()
		StaticPopupDialogs["EXRT_PROFILES_REMOVE"] = {
			text = ExRT.L.ProfilesDeleteAlert,
			button1 = ExRT.L.YesText,
			button2 = ExRT.L.NoText,
			OnAccept = function()
				VExRT.Profiles[name] = nil
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("EXRT_PROFILES_REMOVE")
	end
	self.deleteText = ExRT.lib.CreateText(self,605,200,nil,15,-258,nil,"TOP",nil,11,ExRT.L.ProfilesDelete)
	self.deleteDropDown = ExRT.lib.CreateScrollDropDown(self,"TOPLEFT",10,-270,235,220,10,"",nil,"ExRTDropDownMenuModernTemplate")
	function self.deleteDropDown:ToggleUpadte()
		self.List = GetCurrentProfilesList(DeleteProfile)
		for i=1,#self.List do
			if self.List[i].arg1 == VExRT.Profile then
				for j=i,#self.List do
					self.List[j] = self.List[j+1]
				end
				break
			end
		end
		for i=1,#self.List do
			if self.List[i].arg1 == "default" then
				for j=i,#self.List do
					self.List[j] = self.List[j+1]
				end
				break
			end
		end
	end

end

function module.main:ADDON_LOADED()
	if not VExRT then
		return
	end
	VExRT.ProfileKeys = VExRT.ProfileKeys or {}
	VExRT.Profiles = VExRT.Profiles or {}
	VExRT.Profile = VExRT.Profile or "default"
	
	VExRT.ProfileKeys[ ExRT.SDB.charKey ] = VExRT.Profile
end