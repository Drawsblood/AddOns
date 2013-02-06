local MogIt_Armorkinis,ak = ...;
local mog = MogIt;

local module = mog:GetModule("MogIt_Armorkinis") or mog:RegisterModule("MogIt_Armorkinis",{});
local sets = {
	{label = "Cloth",sets = {}},
	{label = "Leather",sets = {}},
	{label = "Mail",sets = {}},
	{label = "Plate",sets = {}},
};
local list = {};
local data = {
	name = {},
	items = {},
	extras = {},
	alts = {},
	favs = {},
};
local extra;

local num = 0;
function ak.AddSet(type,name,items,extras,alts)
	num = num + 1;
	tinsert(sets[type].sets,num);
	data.name[num] = name;
	data.items[num] = items;
	data.extras[num] = extras;
	data.alts[num] = alts;
end

function ak.AddFavs(tbl)
	for k,v in ipairs(tbl) do
		data.favs[v] = true;
	end
end

local function DropdownTier2(self)
	module.active = self.value;
	mog:SetModule(self.arg1,"Armorkinis - "..self.value.label);
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
		for k,v in ipairs(sets) do
			info = UIDropDownMenu_CreateInfo();
			info.text = v.label;
			info.value = v;
			info.notCheckable = true;
			info.func = DropdownTier2;
			info.arg1 = module;
			UIDropDownMenu_AddButton(info,tier);
		end
	end
end

function module.FrameUpdate(module,self,value)
	self.data.items = {};
	for k,v in ipairs(data.items[value]) do
		tinsert(self.data.items,v);
	end
	if extra and data.extras[value] then
		for k,v in ipairs(data.extras[value]) do
			tinsert(self.data.items,v);
		end
	end
	self.data.name = data.name[value];
	self.data.main = data.items[value];
	self.data.extras = data.extras[value];
	self.data.alts = data.alts[value];
	mog.Set_FrameUpdate(self,self.data);
end

function module.OnEnter(module,self,value)
	--mog.Set_OnEnter(self,self.data);
	if not (self and self.data and self.data.main) then return end;
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	
	GameTooltip:AddLine(self.data.name);
	for k,v in ipairs(self.data.main) do
		local name,link,_,_,_,_,_,_,_,texture = GetItemInfo(v);
		GameTooltip:AddDoubleLine((texture and "\124T"..texture..":18\124t " or "")..(link or name or ""),"ID: "..v,nil,nil,nil,1,1,1);
	end
	
	if self.data.extras then
		GameTooltip:AddLine(" ");
		GameTooltip:AddLine("Extra Items");
		for k,v in ipairs(self.data.extras) do
			local name,link,_,_,_,_,_,_,_,texture = GetItemInfo(v);
			GameTooltip:AddDoubleLine((texture and "\124T"..texture..":18\124t " or "")..(link or name or ""),"ID: "..v,nil,nil,nil,1,1,1);
		end
	end
	
	if self.data.alts then
		GameTooltip:AddLine(" ");
		GameTooltip:AddLine("Alternative Items");
		for k,v in ipairs(self.data.alts) do
			local name,link,_,_,_,_,_,_,_,texture = GetItemInfo(v);
			GameTooltip:AddDoubleLine((texture and "\124T"..texture..":18\124t " or "")..(link or name or ""),"ID: "..v,nil,nil,nil,1,1,1);
		end
	end
	
	if data.favs[self.data.name] then
		GameTooltip:AddLine(" ");
		GameTooltip:AddLine("\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:16\124t One of Lull's favourites!",1,1,1);
	end
	
	GameTooltip:Show();
end

function module.OnClick(module,self,btn,value)
	if btn == "RightButton" and IsShiftKeyDown() then
		mog:ShowURL(self.data.items,"compare");
		return;
	end
	mog.Set_OnClick(self,btn,self.data);
end

function module.Unlist(module)
	wipe(list);
end

function module.BuildList(module)
	wipe(list);
	for k,v in ipairs(module.active.sets) do
		tinsert(list,v);
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
	"ArmorkiniExtra",
};

do
	local f = mog:CreateFilter("ArmorkiniExtra");
	f:SetHeight(32);

	f.extra = CreateFrame("CheckButton","MogItFiltersArmorkiniExtra",f,"UICheckButtonTemplate");
	MogItFiltersArmorkiniExtraText:SetText("Show Extra Items");
	f.extra:SetPoint("TOPLEFT",f,"TOPLEFT",0,0);
	f.extra:SetScript("OnClick",function(self)
		extra = self:GetChecked();
		mog.scroll:update();
	end);

	function f.Filter()
		return extra;
	end

	function f.Default()
		extra = false;
		f.extra:SetChecked(extra);
	end
	f.Default();
end