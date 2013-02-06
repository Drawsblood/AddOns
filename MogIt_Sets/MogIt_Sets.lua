local MogIt_Sets,s = ...;
local mog = MogIt;

local module = mog:GetModule("MogIt_Sets") or mog:RegisterModule("MogIt_Sets",{});
local sets = {
	Cloth = {},
	Leather = {},
	Mail = {},
	Plate = {},
};
local armor = {
	"Cloth",
	"Leather",
	"Mail",
	"Plate",
};
local list = {};
local data = {
	name = {},
	items = {},
	class = {},
	faction = {},
};

local function AddData(id,name,items,class,faction)
	data.name[id] = name;
	data.items[id] = items;
	data.class[id] = class;
	data.faction[id] = faction;
end

function s.AddCloth(id,...)
	tinsert(sets.Cloth,id);
	AddData(id,...);
end

function s.AddLeather(id,...)
	tinsert(sets.Leather,id);
	AddData(id,...);
end

function s.AddMail(id,...)
	tinsert(sets.Mail,id);
	AddData(id,...);
end

function s.AddPlate(id,...)
	tinsert(sets.Plate,id);
	AddData(id,...);
end

local function DropdownTier2(self)
	module.active = self.value
	mog:SetModule(self.arg1,"Sets - "..self.value);
	CloseDropDownMenus();
end

function module.Dropdown(module,tier)
	local info;
	if tier == 1 then
		info = UIDropDownMenu_CreateInfo();
		info.text = module.label;
		info.value = module;
		info.colorCode = "\124cFF00FF00";
		info.hasArrow = true;
		info.keepShownOnClick = true;
		info.notCheckable = true;
		UIDropDownMenu_AddButton(info,tier);
	elseif tier == 2 then
		for k,v in ipairs(armor) do
			info = UIDropDownMenu_CreateInfo();
			info.text = v;
			-- info.value = v; -- value equals text if omitted!
			info.notCheckable = true;
			info.func = DropdownTier2;
			info.arg1 = module;
			UIDropDownMenu_AddButton(info,tier);
		end
	end
end

function module.FrameUpdate(module,self,value)
	self.data.set = value;
	self.data.items = data.items[value];
	self.data.name = data.name[value];
	mog.Set_FrameUpdate(self,self.data);
end

function module:OnEnter(frame, value)
	mog.ShowSetTooltip(frame, data.items[value], data.name[value])
end

function module.OnClick(module,self,btn,value)
	mog.Set_OnClick(self,btn,self.data);
end

function module.Unlist(module)
	wipe(list);
end

function module.BuildList(module)
	wipe(list);
	for k,v in ipairs(sets[module.active]) do
		if mog:GetFilter("class").Filter(data.class[v]) and mog:GetFilter("faction").Filter(data.faction[v]) then
			tinsert(list,v);
		end
	end
	return list;
end

function module.Help(module)
	GameTooltip:AddDoubleLine("Chat link","Shift + Left click",0,1,0,1,1,1);
	GameTooltip:AddDoubleLine("Try on","Ctrl + Left click",0,1,0,1,1,1);
	GameTooltip:AddDoubleLine("Wishlist menu","Right click",0,1,0,1,1,1);
	GameTooltip:AddDoubleLine("Set URL","Shift + Right click",0,1,0,1,1,1);
	GameTooltip:AddDoubleLine("Add to preview","Ctrl + Right click",0,1,0,1,1,1);
end

module.filters = {
	"class",
	"faction",
};