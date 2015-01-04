if not ItemRack or (ItemRack.Version < 2.8) then return end

local BFIR = CreateFrame("Frame")
local self = BFIR
BFIR:SetScript("OnEvent", function(this, event, ...)
	this[event](this, ...)
end)

local LBF = LibStub("LibButtonFacade")
if not LBF then return end

local IR = "ItemRack"
local db = {}


BFIR:RegisterEvent("PLAYER_ENTERING_WORLD")
function BFIR:PLAYER_ENTERING_WORLD()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	BFIRSettingsDB = BFIRSettingsDB or {}
	db = BFIRSettingsDB

	if db.dbinit ~= 1 then
		local defaults = {
			groups = {
				["Set Buttons"] = {
					skin = "Blizzard",
					gloss = false,
					backdrop = false,
					colors = {},
				},
				["Menu Buttons"] = {
					skin = "Blizzard",
					gloss = false,
					backdrop = false,
					colors = {},
				},
			},
			dbinit = 1,
		}
		db = defaults
		BFIRSettingsDB = db
	end
	self.db = db

	for _, v in pairs({"Set Buttons", "Menu Buttons",}) do
		local lbfgroup = LBF:Group(IR, v)
		lbfgroup:Skin(self.db.groups[v].skin, self.db.groups[v].gloss, self.db.groups[v].backdrop, self.db.groups[v].colors)
	end

	for i = 0, 20 do
		local button = _G["ItemRackButton"..i]
		if button then
			local Group = "Set Buttons"
			local lbfgroup = LBF:Group(IR, Group)
			lbfgroup:AddButton(button)
		end
	end

	if ItemRack.CreateMenuButton then
		hooksecurefunc(ItemRack, "CreateMenuButton", function(idx, itemID, ...)
			if idx then
				local button = _G["ItemRackMenu"..idx]
				if button then
					local Group = "Menu Buttons"
					local lbfgroup = LBF:Group(IR, Group)
					lbfgroup:AddButton(button)
				end
			end
		end)
	end

	LBF:RegisterSkinCallback(IR, function(_, SkinID, Gloss, Backdrop, Group, Button, Colors)
		if not Group then return end
		self.db.groups[Group].skin = SkinID
		self.db.groups[Group].gloss = Gloss
		self.db.groups[Group].backdrop = Backdrop
		self.db.groups[Group].colors = Colors
	end, self)
end
