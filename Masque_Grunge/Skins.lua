local MSQ = LibStub("Masque", true)
if not MSQ then return end

-- Grunge
MSQ:AddSkin("Grunge", {
	Author = "Firebunny",
	Version = "1",
	Shape = "Square",
	Masque_Version = 40200,
	Backdrop = {
		Width = 32,
		Height = 32,
		Texture = [[Interface\AddOns\Masque_Grunge\Textures\Backdrop]],
	},
	Icon = {
		Width = 32,
		Height = 32,
		TexCoords = {0.07,0.93,0.07,0.93},
	},
	Flash = {
		Width = 40,
		Height = 40,
		Color = {1, 0, 0, 1},
		Texture = [[Interface\AddOns\Masque_Grunge\Textures\Overlay]],
	},
	Cooldown = {
		Width = 32,
		Height = 32,
	},
	Pushed = {
		Width = 40,
		Height = 40,
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque_Grunge\Textures\Overlay]],
	},
	Normal = {
		Width = 40,
		Height = 40,
		Texture = [[Interface\AddOns\Masque_Grunge\Textures\Normal]],
	},
	Disabled = {
		Hide = true,
	},
	Checked = {
		Width = 40,
		Height = 40,
		BlendMode = "ADD",
		Color = {1, 1, 1, 0.2},
		Texture = [[Interface\AddOns\Masque_Grunge\Textures\Highlight]],
	},
	Border = {
		Width = 40,
		Height = 40,
		BlendMode = "ADD",
		Texture = [[Interface\AddOns\Masque_Grunge\Textures\Border]],
	},
	Gloss = {
		Width = 40,
		Height = 40,
		Texture = [[Interface\AddOns\Masque_Grunge\Textures\Gloss]],
	},
	AutoCastable = {
		Width = 40,
		Height = 40,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 40,
		Height = 40,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque_Grunge\Textures\Highlight]],
	},
	Name = {
		Width = 40,
		Height = 10,
		OffsetY = -8,
	},
	Count = {
		Width = 40,
		Height = 10,
		OffsetX = -1,
		OffsetY = 3,
	},
	HotKey = {
		Width = 40,
		Height = 10,
		OffsetX = -1,
		OffsetY = -5,
	},
	Duration = {
		Width = 40,
		Height = 10,
		OffsetY = -2,
	},
	AutoCast = {
		Width = 36,
		Height = 36,
		OffsetX = 1,
		OffsetY = -1,
	},
}, true)
