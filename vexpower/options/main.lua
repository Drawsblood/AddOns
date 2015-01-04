function vexpower.options.main.panel()
	return {
		type = "group",
		args = {
			title={name="|CFFFF7D0AVersion: |r"..GetAddOnMetadata("vexpower", "Version").."\n", type="description", order=1, fontSize="large"},
			author={name="|CFFFF7D0AAuthor: |rVexar Aegwynn-EU\n", type="description", order=2, fontSize="large"},
			slashcmds={name="\n\nSlash Cmds:\n/vexpower\n/vexp", type="description", order=3, fontSize="large"},
			space={name="\n\n", type="description", order=4, fontSize="large"},
			
			activate = {
				name = "Enable Addon",
				order=5, type = "toggle", width="double",
				set = function(self,key) vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"]=key vexpower.initialize.core(true) end,
				get = function() return vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"] end,
				},
			defaults = {
				name = "Reset to defaults",
				order=6, type = "execute",
				func = function(info,val) vexpower.initialize.loadSV(true) end,
				},
			
			support_space ={name="\n", type="description", order=100},
			support_info =	{type="description", order=101, fontSize="medium", name="The ComboPoints currently support the following classes and specs:"},
			supportpala =	{type="description", order=110, fontSize="medium", name="  |CFF"..vexpower.data.lib.getColor.classHex("PALADIN").."Paladin|r: Holy Power"},
			supportdruid =	{type="description", order=120, fontSize="medium", name="  |CFF"..vexpower.data.lib.getColor.classHex("DRUID").."Druid|r: ComboPoints"},
			supportrogue =	{type="description", order=130, fontSize="medium", name="  |CFF"..vexpower.data.lib.getColor.classHex("ROGUE").."Rogue|r: ComboPoints"},
			supportmonk =	{type="description", order=140, fontSize="medium", name="  |CFF"..vexpower.data.lib.getColor.classHex("MONK").."Monk|r: Chi"},
		--	supporthunter =	{type="description", order=150, fontSize="medium", name="  |CFF"..vexpower.data.lib.getColor.classHex("HUNTER").."Hunter|r (Marksman): 'Ready, Set, Aim...'-Stacks and 'Fire!'-Buff"},
			supporthunter2 ={type="description", order=151, fontSize="medium", name="  |CFF"..vexpower.data.lib.getColor.classHex("HUNTER").."Hunter|r (Beast Master): 'Frenzy'-Stacks"},
		--	supportwarrior1={type="description", order=170, fontSize="medium", name="  |CFF"..vexpower.data.lib.getColor.classHex("WARRIOR").."Warrior|r (Arms): 'Taste for Blood'-Stacks"},
			supportwarrior2={type="description", order=171, fontSize="medium", name="  |CFF"..vexpower.data.lib.getColor.classHex("WARRIOR").."Warrior|r (Fury): 'Raging Blow'-Stacks"},
			supportshaman1 ={type="description", order=180, fontSize="medium", name="  |CFF"..vexpower.data.lib.getColor.classHex("SHAMAN").."Shaman|r (Enhancer): 'Maelstrom Weapon'-Stacks"},
			supportpriest1 ={type="description", order=190, fontSize="medium", name="  |CFF"..vexpower.data.lib.getColor.classHex("PRIEST").."Priest|r (Shadow): Shadow Orbs"},
			supportpriest2 ={type="description", order=191, fontSize="medium", name="  |CFF"..vexpower.data.lib.getColor.classHex("PRIEST").."Priest|r (Discipline): 'Evangelism'-Stacks"},
			supportlock1 =	{type="description", order=200, fontSize="medium", name="  |CFF"..vexpower.data.lib.getColor.classHex("WARLOCK").."Warlock|r (Affliction): Soul Shards"},
			supportlock2 =	{type="description", order=201, fontSize="medium", name="  |CFF"..vexpower.data.lib.getColor.classHex("WARLOCK").."Warlock|r (Demonology): Demonic Fury and text support with 'PowerAltCurrent'/etc"},
			supportlock3 =	{type="description", order=202, fontSize="medium", name="  |CFF"..vexpower.data.lib.getColor.classHex("WARLOCK").."Warlock|r (Destruction): Burning Embers and text support with 'PowerAltCurrent'/etc"},
			supportmage1 =	{type="description", order=210, fontSize="medium", name="  |CFF"..vexpower.data.lib.getColor.classHex("MAGE").."Mage|r (Arcane): 'Arcane Charge'-Stacks"},
			}
		}
end