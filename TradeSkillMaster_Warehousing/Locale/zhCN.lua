-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Warehousing - AddOn by Geemoney							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_warehousing.aspx   --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --

-- TradeSkillMaster_Warehousing Locale - zhCN
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_Warehousing/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Warehousing", "zhCN")
if not L then return end
L["   1.1) You can delete a group by typing in its name and hitting okay."] = "   1.1) 输入队列名称并点确定键，可以删除这个队列" -- Needs review
L["   1) Open up a bank (either the gbank or personal bank)"] = "   1) 打开银行（公会银行或者个人银行）" -- Needs review
L["   1) Type a name in the textbox labeled \"Create New Group\", hit okay"] = "   1) 在标记为“创建新队列”的文本框里键入一个新名字，点确定键" -- Needs review
L["   2) Select that group using the table on the left, you should then see a list of all the items currently in your bags with a quantity"] = "   2) 从左边的表格里选择该队列, 几秒后会显示出目前背包里该物品的数量" -- Needs review
L["   2) You should see a window on your right with a list of groups"] = "   2) 你应该会在右边看到一个队列清单窗口" -- Needs review
L["   3) Right click to increase, left click to decrease by the current increment"] = "   3) 右键单击以添加数量, 左键单击以减少数量" -- Needs review
L["   3) Select a group and hit either"] = "   3) 选择一个队列并点击任一" -- Needs review
L["   Again warehousing will try to fill out the order, but if it is short, it will remember how much it is short by and adjust its counts. So then you can go to another bank or another character and warehousing will grab the difference. Once the order has been completely filled out, warehousing will reset the count back to the original total. You cannot move a Crafting Queue bags->bank, only bank->bags."] = "再次声明，仓储管理只会尝试创建指令，但如果它很短，它会记住它是短暂的和调整计数。那么你可以尝试去别的银行或者登录别的人物，让仓储管理抓住差异。一旦指令创建完毕，仓储管理会重置计数回到原来的总和。不能将制作队列从背包移动到银行，只能从银行移动到背包。" -- Needs review
L["Auctioning"] = "拍卖" -- Needs review
L["Crafting"] = "制作" -- Needs review
L["Create New Group"] = "创建新队列" -- Needs review
L["Delete Group"] = "删除队列" -- Needs review
L["Empty Bags"] = "清空背包" -- Needs review
L["Empty Bags/Restore Bags"] = "清空/恢复背包" -- Needs review
L["Group Behaviors"] = "队列状态" -- Needs review
L["Groups"] = "队列" -- Needs review
L["How To"] = "如何" -- Needs review
L["Inventory Manager"] = "库存管理" -- Needs review
L["Item"] = "物品" -- Needs review
L["Move Group to Bags"] = "将队列移动至背包" -- Needs review
L["Move Group To Bags"] = "将队列移动到背包" -- Needs review
L["Move Group to Bank"] = "将队列移动至银行" -- Needs review
L["Move Group To Bank"] = "将队列移动至银行" -- Needs review
L["New Group"] = "新队列" -- Needs review
L["or"] = "或" -- Needs review
L["Quantity"] = "数量" -- Needs review
L["Reset Crafting Queue"] = "重置制作队列" -- Needs review
L["Restore Bags"] = "恢复背包" -- Needs review
L["Set Increment"] = "设置增量" -- Needs review
L["   Simply hit empty bags, warehousing will remember what you had so that when you hit restore, it will grab all those items again. If you hit empty bags while your bags are empty it will overwrite the previous bag state, so you will not be able to use restore."] = "点击清空背包，存储管理会记住你在点击恢复指令的时候背包里装的物品，它会再次抓取所有物品。当背包已经清空的时候再点击清空背包，之前有物品的背包状态会被空的背包状态覆盖并导致背包内的物品无法被恢复，因此你不能再次使用恢复指令。" -- Needs review
L["To create a Warehousing Group"] = "创建一个Warehousing（存储系统）队列" -- Needs review
L["To move a Group:"] = "移动队列:" -- Needs review
L["TradeSkillMaster_InventoryManager"] = "TradeSkillMaster_库存管理" -- Needs review
L["Warehousing"] = "仓储管理" -- Needs review
L["Warehousing will only keep track of items that you have moved out of you bank and into your bags via the Inventory_Manager.  Finaly if you ever feel the need to reset the counts for a queue simply use the dropdown menu below."] = "仓储管理只能追踪通过库存管理从银行移动到背包的物品。如需要重置队列数量，请使用上面的下拉菜单" -- Needs review
L["   Warehousing will simply move all of each of the items in the group from the source to the destination."] = "Warehousing（存储系统）会把队列中的每个物品搬运到目标背包或者银行" -- Needs review
L["   Warehousing will try to get the right number of items, if there are not enough in the bank to fill out order, it will grab all that there is."] = "Warehousing（存储系统）会尝试获得物品的数量，在银行库存量不足的情况下将取出所有该物品" -- Needs review
