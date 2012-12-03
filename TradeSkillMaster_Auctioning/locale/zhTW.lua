-- TradeSkillMaster_Auctioning Locale - zhTW
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_Auctioning/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Auctioning", "zhTW")
if not L then return end

L["12 hours"] = "12小時"
L["24 hours"] = "24小時"
L["48 hours"] = "48小時"
L["A category contains groups with similar settings and acts like an organizational folder. You may override default settings by category (and then override category settings by group)."] = "一個類別包含一些設置和功能都類似的群組, 就像一個組織目錄. 你可以自定義類別選項從而覆蓋掉默認選項(同樣的, 自定義群組選項會覆蓋掉父類中的自定義選項)."
L["Add a new player to your blacklist."] = "新增玩家到你的黑名單。"
L["Add a new player to your whitelist."] = "新增玩家到你的白名單。"
L["Add category"] = "新增分類"
-- L["Added %s items to %s automatically because they contained the group name in their name. You can turn this off in the options."] = ""
-- L["Added the following items to %s automatically because they contained the group name in their name. You can turn this off in the options."] = ""
L["Add group"] = "新增群組"
-- L["Add Item to New Group"] = ""
-- L["Add Item to Selected Group"] = ""
-- L["Add Item to TSM_Auctioning"] = ""
L["Add player"] = "新增玩家"
L["Add/Remove"] = "新增/移除"
L["Add/Remove Groups"] = "新增/移除群組"
L["Add/Remove Items"] = "新增/移除物品"
L["Advanced"] = "高級"
-- L["Advanced Price Settings (Reset Method)"] = ""
L["A group contains items that you wish to sell with similar conditions (stack size, fallback price, etc).  Default settings may be overridden by a group's individual settings."] = "一個群組包含一些你想出售的設置類似的物品(堆疊大小、回檔價等等), 默認選項會被群組中的自義定選項覆蓋."
-- L["All auctions of this duration and below will be canceled when you press the \"Cancel Low Duration Auctions\" button"] = ""
-- L["All Items Scanned"] = ""
L["ALT"] = "ALT"
L["Any auctions at or below the selected duration will be ignored. Selecting \"<none>\" will cause no auctions to be ignored based on duration."] = "處于或低于所選擇持續時間內的拍賣品將會被忽略. 選擇\\\"<空>\\\"將不會使拍賣品基於其持續時間而被忽略."
-- L["Are you SURE you want to delete all the groups in this category?"] = ""
L["Are you sure you want to delete the selected profile?"] = "!!你確定要刪除選定的配置文件?"
L["Are you SURE you want to delete this category?"] = "!!你確定要刪除這個分類嗎?"
L["Are you SURE you want to delete this group?"] = "!!你確定要刪除這個群組嗎?"
-- L["At fallback price and not undercut."] = ""
-- L["Auction Buyout"] = ""
-- L["Auction Buyout (Stack Price):"] = ""
L["Auction Defaults"] = "拍賣默認"
-- L["Auction has been bid on."] = ""
L["Auctioning Group:"] = "拍卖群組:"
L["Auctioning Groups/Options"] = "Auctioning 群組/選項"
-- L["Auctioning has found %s group(s) with an invalid threshold/fallback. Check your chat log for more info. Would you like Auctioning to fix these groups for you?"] = ""
L["Auctioning will follow the 'Advanced Price Settings' when the market goes below %s."] = "Auctioning 將按照'高級價格選項'中的設定定價(當市場低于%s)."
L["Auctioning will never post your auctions for below %s."] = "當市場價格低于 %s, Auctioning 不會上架你的拍賣品."
L["Auctioning will post at %s when you are the only one posting below %s."] = "拍賣品將被以%s上架, 當你是該物品唯一的低于%s的出售者."
-- L["Auctioning will reset items where you can make a profit of at least %s per item by buying at most %s items for a maximum of %s, paying no more than %s for any single item."] = ""
L["Auctioning will undercut your competition by %s. When posting, the bid of your auctions will be set to %s percent of the buyout."] = "Auctioning將會以%s的幅度進行壓價,上架時,競標價將被設置為一口價的百分之%s."
-- L["Auction not found. Skipped."] = ""
-- L["Auctions"] = ""
L["Auctions will be posted at %s when the market goes below your threshold."] = "當市場價格低于你的閥值時物品將以 %s 上架。"
L["Auctions will be posted at your fallback price of %s when the market goes below your threshold."] = "當市場價格低于你的閥值時物品將以回檔價 %s 上架。"
L["Auctions will be posted at your threshold price of %s when the market goes below your threshold."] = "當市場價格低于你的閥值時物品將以閥值 %s 上架。"
L["Auctions will be posted for %s hours in stacks of %s. A maximum of %s auctions will be posted."] = "拍賣品將被上架 %s 小時，每疊 %s 個，最大上架 %s 疊。"
L["Auctions will be posted for %s hours in stacks of up to %s. A maximum of %s auctions will be posted."] = "拍賣品將被上架 %s 小時，每疊最多 %s 個，最大上架 %s 疊。"
L["Auctions will not be posted when the market goes below your threshold."] = "當市場價格低于你的閥值時物品將不會被上架。"
L["Beginner"] = "初學者"
-- L["Bid:"] = ""
L["Bid percent"] = "競標百分比"
L["Blacklist"] = "黑名單"
-- L["(blacklisted)"] = ""
L["Blacklists allows you to undercut a competitor no matter how low their threshold may be. If the lowest auction of an item is owned by somebody on your blacklist, your threshold will be ignored for that item and you will undercut them regardless of whether they are above or below your threshold."] = "黑名單允許你無視已設定的的閥值, 不顧一切的壓低在你黑名單中的玩家所上架的拍賣品."
L["Block Auctioneer while scanning"] = "掃描時鎖定 Auctioneer "
-- L["Buyout"] = ""
-- L["Buyout:"] = ""
L["Cancel"] = "撤銷"
-- L["Cancel ALL Current Auctions"] = ""
-- L["Cancel Auctions"] = ""
-- L["Cancel Auctions Matching Filter"] = ""
L["Cancel auctions with bids"] = "撤銷已被競拍的物品"
-- L["Cancel Filter"] = ""
L["Canceling"] = "撤銷"
-- L["Canceling all auctions."] = ""
-- L["Canceling auction which you've undercut."] = ""
-- L["Canceling %s / %s"] = ""
-- L["Canceling to repost at higher price."] = ""
-- L["Canceling to repost at reset price."] = ""
-- L["Cancel Low Duration Auctions"] = ""
-- L["Cancels auctions you've been undercut on according to the rules setup in Auctioning."] = ""
-- L["Cancel Scan Finished"] = ""
L["Cancel to repost higher"] = "撤銷再擺更高價(市場保護選項)"
L["Categories / Groups"] = "類別/群組"
L["Category name"] = "類別名稱"
L["Category Overrides"] = "類別自定義"
-- L["Cheapest auction below threshold."] = ""
-- L["Check this box to include this group in the scan."] = ""
-- L["Click on the \"Fix\" button to have Auctioning turn this group into a category and create appropriate groups inside the category to fix this issue. This is recommended unless you'd like to fix the group yourself. You will only be prompted with this popup once per session."] = ""
--[==[ L[ [=[
Click to reset this item to this target price.]=] ] = "" ]==]
-- L["Click to reset this item to this target price."] = ""
--[==[ L[ [=[
Click to show auctions for this item.]=] ] = "" ]==]
-- L["Click to show auctions for this item."] = ""
-- L["Common Search Term"] = ""
L["Completely disables this group. This group will not be scanned for and will be effectively invisible to Auctioning."] = "完全禁用這個群組. 這個群組不會被掃描，且在拍賣時完全隱藏。"
L["Copy From"] = "複製自"
L["Copy the settings from one existing profile into the currently active profile."] = "將一個已存在的配置文件複製到當前配置文件."
-- L["Could not find item's group."] = ""
-- L["Could not resolve search filters for item %s"] = ""
L["Create a new empty profile."] = "創建新配置文件"
L["Create Category / Group"] = "創建分類/群組"
-- L["Created new shopping list: "] = ""
L["Create Macro and Bind ScrollWheel (with selected options)"] = "創建巨集并綁定鼠標滾輪(根據設定選項)"
-- L["Creates a shopping list that contains all the items which are in this category. There is no confirmation or popup window for this."] = ""
-- L["Creates a shopping list that contains all the items which are in this group. There is no confirmation or popup window for this."] = ""
-- L["Create Shopping List from Category"] = ""
-- L["Create Shopping List from Group"] = ""
L["CTRL"] = "CTRL"
-- L["Currently Owned:"] = ""
L["Current Profile:"] = "當前配置文件:"
L["Custom market reset price. If the market goes below your threshold, items will be posted at this price."] = "自定義市場價格, 當市場價格低于你的閥值時, 物品將以此價格上架."
-- L["Custom percentage change of market price. If the market price changes by this percentage, your items will be reposted at the fallback value."] = ""
-- L["Custom percentage change of market price. If the market price changes by this percentage, your items will be reposted at the %s value."] = ""
-- L["Custom percentage change of market price. If the market price changes by this percentage, your items will be reposted at the threshold value."] = ""
L["Custom Reset Price (gold)"] = "自定義歸位價格(金)"
L["Custom Value"] = "自定義價格"
L["Data Imported to Group: %s"] = "數據已匯入群組: %s"
L["Default"] = "默認"
L["Delete"] = "刪除"
-- L["Delete All Groups In Category"] = ""
-- L["Delete all groups inside this category. This cannot be undone!"] = ""
L["Delete a Profile"] = "刪除一個配置文件"
-- L["Delete category"] = ""
L["Delete existing and unused profiles from the database to save space, and cleanup the SavedVariables file."] = "從資料庫中刪除已存在的無用的配置文件釋放存儲空間,清理SavedVariables文件。"
L["Delete group"] = "刪除群組"
L["Delete this category, this cannot be undone!"] = "刪除這個分類, 這個操作不可恢復"
L["Delete this group, this cannot be undone!"] = "刪除這個群組, 這個操作不可恢復"
L["Determines which order the group / category settings tabs will appear in."] = "設定類別/群組選項頁面的標籤顯示順序."
L["Did not post %s because your fallback (%s) is invalid. Check your settings."] = "未能上架 %s 因為你的回檔價(%s)無效, 請檢查設置"
L["Did not post %s because your fallback (%s) is lower than your threshold (%s). Check your settings."] = "未能上架 %s 因為你的回檔價(%s)低於你的閥值(%s), 請檢查設置"
L["Did not post %s because your threshold (%s) is invalid. Check your settings."] = "未能上架 %s 因為你的閥值(%s)無效, 請檢查設置"
-- L["Disable All"] = ""
L["Disable auto cancelling"] = "禁用自動撤銷"
L["Disable automatically cancelling of items in this group if undercut."] = "壓價時禁止自動撤銷這個群組中的物品."
L["Disable posting and canceling"] = "停用上架和撤銷"
L["Disables canceling of auctions which can not be reposted (ie the market price is below your threshold)."] = "禁止撤銷已無法再上架的商品(再上架價格已低於閥值)"
L["Done Canceling"] = "撤銷完成"
--[==[ L[ [=[Done Posting

Total value of your auctions: %s
Incoming Gold: %s]=] ] = "" ]==]
--[==[ L[ [=[Done Scanning!

Could potentially reset %d items for %s profit.]=] ] = "" ]==]
L["Don't Import Already Grouped Items"] = "不要匯入已經被分組的物品"
L["Don't Post Items"] = "不要上架物品"
L["Down"] = "下"
-- L["Duration"] = ""
-- L["Edit Post Price"] = ""
-- L["Enable All"] = ""
L["Enable sounds"] = "啟用音效"
-- L["Enter a filter into this box and click the button below it to cancel all of your auctions that contain that filter (without scanning)."] = ""
-- L["Error with scan. Scanned item multiple times unexpectedly. You can try restarting the scan. Item:"] = ""
L["Existing Profiles"] = "已有配置文件"
L["Export"] = "匯出"
L["Export Group Data"] = "匯出群組數據"
L["Exports the data for this group. This allows you to share your group data with other TradeSkillMaster_Auctioning users."] = "匯出該群組數據。允許你請你的群組數據共享給其他的 TradeSkillMaster_Auctioning 使用者。"
-- L["Failed to create shopping list."] = ""
-- L["Fallback:"] = ""
L["Fallback price"] = "回檔價"
L["First Tab in Group / Category Settings"] = "類別/群組選項頁面的首標籤"
L["Fixed Gold Amount"] = "固定金額"
-- L["Fixed invalid groups."] = ""
-- L["Fix (Recommended)"] = ""
L["General"] = "一般"
L["General Price Settings (Undercut / Bid)"] = "一般價格選項(壓價/競標)"
L["General Settings"] = "一般選項"
-- L["Group:"] = ""
L["Group/Category named \"%s\" already exists!"] = "群組/類別名稱 \"%s\" 已存在!"
L["Group Data"] = "群組數據"
L["Group name"] = "群組名稱"
L["Group named \"%s\" already exists! Item not added."] = "群組名稱 \"%s\" 已存在. 物品未能添加."
L["Group named \"%s\" does not exist! Item not added."] = "群組名稱 \"%s\" 不存在. 物品未能添加."
L["Group Overrides"] = "群組自定義"
L["Groups in this Category:"] = "這個分類中的群組:"
L["Help"] = "幫助"
L["Hide advanced options"] = "隱藏高級選項"
L["Hide help text"] = "隱藏幫助文本"
L["Hide poor quality items"] = "隱藏低品質物品"
L["Hides advanced auction settings. Provides for an easier learning curve for new users."] = "隱藏高級拍賣選項,改為新手模式."
L["Hides all poor (gray) quality items from the 'Add items' pages."] = "在'添加物品'頁中隱藏所有低品質(灰色)物品"
L["Hides auction setting help text throughout the options."] = "勾選該選項以隱藏拍賣設置中的幫助文字."
-- L["How long auctions should be up for."] = ""
-- L["How low the market can go before an item should no longer be posted. The minimum price you want to post an item for."] = ""
-- L["How many auctions at the lowest price tier can be up at any one time."] = ""
-- L["How many items should be in a single auction, 20 will mean they are posted in stacks of 20."] = ""
-- L["How much to undercut other auctions by, format is in \"#g#s#c\" but can be in any order, \"50g30s\" means 50 gold, 30 silver and so on."] = ""
-- L["If all items in this group have the same phrase in their name, use this phrase instead to speed up searches. For example, if this group contains only glyphs, you could put \"glyph of\" and Auctioning will search for that instead of each glyph name individually. Leave empty for default behavior."] = ""
--[==[ L[ [=[If checked, any items in this group with random enchantments will have their random enchantments ignore by Auctioning.

Note: Any common search term will be ignored for groups with this box checked.]=] ] = "" ]==]
-- L["If checked, the items in this group will be included when running a reset scan and the reset scan options will be shown."] = ""
L["If checked, will cancel auctions that can be reposted for a higher amount (ie you haven't been undercut and the auction you originally undercut has expired)."] = "若勾選,將為更高的賣價而撤銷拍賣(即使你沒有被壓價,但是起初被你壓價的物品已經消失)"
L["If enabled, when the lowest auction is by somebody on your whitelist, it will post your auction at the same price. If disabled, it won't post the item at all."] = "若激活,當拍賣品最低價的出價者位於你的白名單中,則以同樣的價格上架.若禁用該選項,則物品不會上架."
L["If enabled, when you create a new group, your bags will be scanned for items with names that include the name of the new group. If such items are found, they will be automatically added to the new group."] = "若激活,當你創建一個新的群組時,將會自動將背包中含有該新創建群組名字的物品添加至新群組中"
--[==[ L[ [=[If the market price is above fallback price * maximum price, items will be posted at the fallback * maximum price instead.

Effective for posting prices in a sane price range when someone is posting an item at 5000g when it only goes for 100g.]=] ] = "" ]==]
-- L["If you are using a % of something for threshold / fallback, every item in a group must evalute to the exact same amount. For example, if you are using % of crafting cost, every item in the group must have the same mats. If you are using % of auctiondb value, no items will ever have the same market price or min buyout. So, these items must be split into separate groups."] = ""
-- L["If you don't have enough items for a full post, it will post with what you have."] = ""
-- L["Ignore"] = ""
-- L["Ignore low duration auctions"] = ""
-- L["Ignore Random Enchants"] = ""
-- L["Ignore stacks over"] = ""
-- L["Ignore stacks under"] = ""
-- L["Import Auctioning Group"] = ""
-- L["Import Group Data"] = ""
-- L["Include in reset scan"] = ""
-- L["Info"] = ""
-- L["Invalid category name."] = ""
-- L["Invalid group name."] = ""
-- L["Invalid money format entered, should be \"#g#s#c\", \"25g4s50c\" is 25 gold, 4 silver, 50 copper."] = ""
-- L["Invalid percent format entered, should be \"#%\", \"105%\" is 105 percent."] = ""
-- L["Invalid scan data for item %s. Skipping this item."] = ""
-- L["Invalid search term for group %s. Searching for items individually instead."] = ""
-- L["Invalid seller data returned by server."] = ""
-- L["Item"] = ""
-- L["Item failed to add to group."] = ""
-- L["Item/Group is invalid."] = ""
-- L["Items in this group:"] = ""
-- L["Items in this group will not be posted or canceled automatically."] = ""
-- L["Items not in any group:"] = ""
-- L["Items that are stacked beyond the set amount are ignored when calculating the lowest market price."] = ""
-- L["Items to be added:"] = ""
-- L["Log Info:"] = ""
-- L["Long (12 hours)"] = ""
-- L["long (less than 12 hours)"] = ""
-- L["Lowest auction by whitelisted player."] = ""
-- L["Lowest Buyout"] = ""
-- L["Lowest Buyout:"] = ""
-- L["Macro created and keybinding set!"] = ""
L["Macro Help"] = "巨集幫助"
-- L["Make another after this one."] = ""
-- L["Management"] = ""
-- L["% Market Value"] = ""
L["Match whitelist prices"] = "匹配白名單價格"
-- L["Max Cost:"] = ""
-- L["Maximum amount already posted."] = ""
-- L["Maximum price"] = ""
-- L["Maximum Price Settings (Fallback)"] = ""
-- L["Max Price Per:"] = ""
-- L["Max price per item"] = ""
-- L["Max Quantity:"] = ""
-- L["Max quantity to buy"] = ""
-- L["Max reset cost"] = ""
L["Max Scan Retries (Advanced)"] = "最大掃描嘗試次數(高級)"
-- L["Medium (2 hours)"] = ""
-- L["medium (less than 2 hours)"] = ""
-- L["Minimum Price Settings (Threshold)"] = ""
-- L["Min Profit:"] = ""
-- L["Min reset profit"] = ""
L["Modifiers:"] = "功能鍵:"
-- L["Must wait for scan to finish before starting to reset."] = ""
-- L["Name of New Group to Add Item to:"] = ""
-- L["Name of the new category, this can be whatever you want and has no relation to how the category itself functions."] = ""
-- L["Name of the new group, this can be whatever you want and has no relation to how the group itself functions."] = ""
-- L["New"] = ""
-- L["New category name"] = ""
-- L["New group name"] = ""
-- L["No Items to Reset"] = ""
-- L["No name entered."] = ""
-- L["<none>"] = ""
-- L["Not canceling auction at reset price."] = ""
-- L["Not canceling auction below threshold."] = ""
-- L["Not enough items in bags."] = ""
-- L["%% of %s"] = ""
L["Options"] = "選項"
L["Overrides"] = "自定義"
-- L["Per auction"] = ""
-- L["Percentage of the buyout as bid, if you set this to 90% then a 100g buyout will have a 90g bid."] = ""
L["Player name"] = "玩家名稱"
L["Plays the ready check sound when a post / cancel scan is complete and items are ready to be posting / canceled (the gray bar is all the way across)."] = "當上架或下架掃描完成后, 物品已準備好被上架或下架(灰色進度條滿)時播放聲音."
-- L["Please don't move items around in your bags while a post scan is running! The item was skipped to avoid an incorrect item being posted."] = ""
-- L["Post"] = ""
-- L["Post at Fallback"] = ""
-- L["Post at Threshold"] = ""
-- L["Post Auctions"] = ""
-- L["Post cap"] = ""
-- L["Posting at fallback."] = ""
-- L["Posting at reset price."] = ""
-- L["Posting at whitelisted player's price."] = ""
-- L["Posting at your current price."] = ""
-- L["Posting %s / %s"] = ""
-- L["Posting this item."] = ""
-- L["Post Scan Finished"] = ""
-- L["Post Settings (Quantity / Duration)"] = ""
-- L["Posts items on the auction house according to the rules setup in Auctioning."] = ""
-- L["Post time"] = ""
-- L["Price Per Item"] = ""
-- L["Price Per Stack"] = ""
-- L["Price resolution"] = ""
-- L["Price resolution for fallback"] = ""
-- L["Price resolution for %s"] = ""
-- L["Price resolution for threshold"] = ""
-- L["Price threshold"] = ""
-- L["Price to fallback too if there are no other auctions up, the lowest market price is too high."] = ""
-- L["Processing Items..."] = ""
L["Profiles"] = "配置文件"
-- L["Profit:"] = ""
-- L["Profit Per Item"] = ""
-- L["Quantity (Yours)"] = ""
-- L["Quick Group Creation"] = ""
-- L["Rename"] = ""
-- L["Rename this category to something else!"] = ""
-- L["Rename this group to something else!"] = ""
-- L["Reset Auctions"] = ""
-- L["Reset Method"] = ""
-- L["Reset Profile"] = ""
-- L["Reset Scan Finished"] = ""
-- L["Reset Scan Settings"] = ""
-- L["Resets the price of items according to the rules setup in Auctioning by buying other's auctions and canceling your own as necessary."] = ""
-- L["Reset the current profile back to its default values, in case your configuration is broken, or you simply want to start over."] = ""
-- L["Return to Summary"] = ""
-- L["Right-Click to add %s to your friends list."] = ""
-- L["Right click to do a custom cancel scan."] = ""
-- L["Right click to do a custom post scan."] = ""
-- L["Right click to do a custom reset scan."] = ""
-- L["Right click to override this setting."] = ""
-- L["Right click to remove the override of this setting."] = ""
-- L["Running Scan..."] = ""
-- L["Save New Price"] = ""
-- L["Scanning"] = ""
-- L["Scanning Item %s / %s"] = ""
L["ScrollWheel Direction (both recommended):"] = "滾輪方向(推薦全選):"
-- L["Select Matches:"] = ""
-- L["Selects all items in either list matching the entered filter. Entering \"Glyph of\" will select any item with \"Glyph of\" in the name."] = ""
-- L["Seller"] = ""
-- L["Seller name of lowest auction for item %s was not returned from server. Skipping this item."] = ""
-- L["Set fallback as a"] = ""
-- L["Set max reset cost as a"] = ""
-- L["Set min reset price as a"] = ""
-- L["Set threshold as a"] = ""
-- L["SHIFT"] = ""
-- L["Shift-Right-Click to show the options for this item's Auctioning group."] = ""
-- L["Short (30 minutes)"] = ""
L["short (less than 30 minutes)"] = "短(30分鐘以內)"
-- L["Show All Auctions"] = ""
L["Show group name in tooltip"] = "在鼠標提示中顯示物品所屬群組名稱"
-- L["Show Item Auctions"] = ""
-- L["Show Log"] = ""
L["Shows the name of the group an item belongs to in that item's tooltip."] = "在物品的滑鼠提示中顯示其所屬的群組名稱"
-- L["%s item(s) to buy/cancel"] = ""
-- L["Skip"] = ""
-- L["Skip Item"] = ""
L["Smart canceling"] = "智能撤銷"
L["Smart group creation"] = "智能群組創建"
-- L["%s removed from '%s' as a result of setting the current group to ignore random enchants."] = ""
-- L["Stack Size"] = ""
-- L["Start Scan of Selected Groups"] = ""
-- L["Stop Scan"] = ""
-- L["Target Price"] = ""
-- L["Target Price:"] = ""
--[==[ L[ [=[The below are fallback settings for groups, if you do not override a setting in a group then it will use the settings below.

Warning! All auction prices are per item, not overall. If you set it to post at a fallback of 1g and you post in stacks of 20 that means the fallback will be 20g.]=] ] = "" ]==]
L["The data you are trying to import is invalid."] = "你試著要匯入的資料不正確"
-- L["The maximum amount that you want to spend in order to reset a particular item. This is the total amount, not a per-item amount."] = ""
-- L["The minimum profit you would want to make from doing a reset. This is a per-item price where profit is the price you reset to minus the average price you spent per item."] = ""
L["The player \"%s\" is already on your blacklist."] = "玩家「%s」已經在你的黑名單。"
-- L["The player \"%s\" is already on your whitelist."] = ""
L["There are two ways of making clicking the Post / Cancel Auction button easier. You can put %s and %s in a macro (on separate lines), or use the utility below to have a macro automatically made and bound to scrollwheel for you."] = "這里有兩種方法可以使得點擊拍賣或撤銷按紐變得更簡單。你可以在一個巨集的不同行中輸入%s和%s或者使用以下提供的功能自動獲得一個巨集并綁定到鼠標滾輪上。"
L["This controls how many times Auctioning will retry a query before giving up and moving on. Each retry takes about 2-3 seconds."] = "放棄之前提出詢問的次數,每次提問花費2-3秒"
-- L["This determines what size range of prices should be considered a single price point for the reset scan. For example, if this is set to 1s, an auction at 20g50s20c and an auction at 20g49s45c will both be considered to be the same price level."] = ""
-- L["This dropdown determines what Auctioning will do when the market for an item goes below your threshold value. You can either not post the items or post at your fallback/threshold/a custom value."] = ""
-- L["This feature can be used to import groups from outside of the game. For example, if somebody exported their group onto a blog, you could use this feature to import that group and Auctioning would create a group with the same settings / items."] = ""
-- L["This is the maximum amount you want to pay for a single item when reseting."] = ""
-- L["This is the maximum number of items you're willing to buy in order to perform a reset."] = ""
-- L["This item does not have any seller data."] = ""
-- L["This item is already in the \"%s\" Auctioning group."] = ""
-- L["This item will not be included in the reset scan."] = ""
-- L["Threshold:"] = ""
-- L["Threshold/Fallback:"] = ""
-- L["Time Left"] = ""
-- L["Toggle this box to enable / disable all groups in this category."] = ""
-- L["Total Cost"] = ""
-- L["TSM_Auctioning Group to Add Item to:"] = ""
L["<Uncategorized Groups>"] = "未分類群組"
-- L["Uncategorized Groups:"] = ""
-- L["Undercut by"] = ""
-- L["Undercut by whitelisted player."] = ""
-- L["Undercutting competition."] = ""
L["Up"] = "上"
-- L["Use per auction as cap"] = ""
-- L["Use the checkboxes to the left to select which groups you'd like to include in this scan."] = ""
-- L["When posting and canceling, ignore auctions with more than %s item(s) or less than %s item(s) in them."] = ""
-- L["When posting, ignore auctions with more than %s items or less than %s items in them. Items in this group will not be canceled automatically."] = ""
-- L["Which group in TSM_Auctioning to add this item to."] = ""
L["Whitelist"] = "白名單"
-- L["(whitelisted)"] = ""
L["Whitelists allow you to set other players besides you and your alts that you do not want to undercut; however, if somebody on your whitelist matches your buyout but lists a lower bid it will still consider them undercutting."] = "白名單允許你設置其他除了你和分身之外的你不想壓價的玩家. 但是, 如果你的白名單中的玩家所上架的物品與你的一口價相同但競拍價低于你, 系統也會認為他們需要被壓價."
-- L["Will bind ScrollWheelDown (plus modifiers below) to the macro created."] = ""
-- L["Will bind ScrollWheelUp (plus modifiers below) to the macro created."] = ""
L["Will cancel auctions even if they have a bid on them, you will take an additional gold cost if you cancel an auction with bid."] = "將會下架已有人競標的物品,下架已競標物品你將會向拍賣行額外支出一些費用."
-- L["Would you like to load these options in beginner or advanced mode? If you have not used APM, QA3, or ZA before, beginner is recommended. Your selection can always be changed using the \"Hide advanced options\" checkbox in the \"Options\" page."] = ""
-- L["You can change the active database profile, so you can have different settings for every character."] = ""
-- L["You can either create a new profile by entering a name in the editbox, or choose one of the already exisiting profiles."] = ""
L["You can not blacklist characters whom are on your whitelist."] = "你不能把已經在白名單中的角色列入黑名單。"
L["You can not blacklist yourself."] = "你不能黑了你自己"
L["You can not whitelist characters whom are on your blacklist."] = "你不能把已經在黑名單中的角色列入白名單。"
-- L["You can set a fixed fallback price for this group, or have the fallback price be automatically calculated to a percentage of a value. If you have multiple different items in this group and use a percentage, the highest value will be used for the entire group."] = ""
-- L["You can set a fixed max reset cost, or have it be a percentage of some other value."] = ""
-- L["You can set a fixed min reset price, or have it be a percentage of some other value."] = ""
-- L["You can set a fixed threshold, or have it be a percentage of some other value."] = ""
L["You do not have any players on your blacklist yet."] = "目前你的黑名單中還沒添加任何人."
L["You do not have any players on your whitelist yet."] = "目前你的白名單中還沒添加任何人."
L["You do not need to add \"%s\", alts are whitelisted automatically."] = "你不需要添加\"%s\",分身角色會被自動視為位於你的白名單中。"
-- L["You don't any groups set to be included in a reset scan."] = ""
-- L["You don't any groups set up."] = ""
-- L["Your auction has not been undercut."] = ""
-- L["You've been undercut."] = ""
