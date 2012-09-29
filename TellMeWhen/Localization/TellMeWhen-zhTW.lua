--[[ Credit for these translations goes to:
	lsjyzjl
	szp1222
--]]
local L = LibStub("AceLocale-3.0"):NewLocale("TellMeWhen", "zhTW", false)
if not L then return end


L["ACTIVE"] = "%d 作用中"
L["AIR"] = "風之圖騰"
L["ALLOWCOMM"] = "允許圖示匯入"
L["ALLOWVERSIONWARN"] = "新版本通知"
L["ALPHA"] = "透明度"
L["ALWAYSSUBLINKS"] = "總是替換為連結"
L["ALWAYSSUBLINKS_DESC"] = "預設情況下,法術/物品只會在文字輸出事件時被替換為連結,勾選此設定將使所有的法術/物品被替換成連結,包括圖示的綁定/標籤文字."
L["ANIM_ACTVTNGLOW"] = "圖示:激活邊框"
L["ANIM_ACTVTNGLOW_DESC"] = "在圖示上顯示暴雪的法術激活邊框."
L["ANIM_ANIMSETTINGS"] = "設定"
L["ANIM_ANIMTOUSE"] = "使用的動畫"
L["ANIM_COLOR"] = "顏色/不透明度"
L["ANIM_COLOR_DESC"] = "設定閃光的顏色和不透明度."
L["ANIM_DURATION"] = "動畫持續時間"
L["ANIM_DURATION_DESC"] = "設定動畫觸發後持續顯示多久."
L["ANIM_FADE"] = "淡入淡出閃光"
L["ANIM_FADE_DESC"] = [=[勾選此項使每個閃光之間平滑的淡入淡出.不勾選則直接閃光.

(注:具體的差別請自行進行區分,我測試的效果除了第一次閃光之外,後面的閃光區別並不明顯.)]=]
L["ANIM_ICONALPHAFLASH"] = "圖示:透明度閃爍"
L["ANIM_ICONALPHAFLASH_DESC"] = "通過改變圖示的不透明度達到閃爍提示的效果."
L["ANIM_ICONBORDER"] = "圖示:邊框"
L["ANIM_ICONBORDER_DESC"] = "在圖示上生成一個有顏色的邊框."
L["ANIM_ICONCLEAR"] = "圖示:停止動畫"
L["ANIM_ICONCLEAR_DESC"] = "停止當前圖示正在播放的所有動畫效果."
L["ANIM_ICONFADE"] = "圖示:淡入/淡出"
L["ANIM_ICONFADE_DESC"] = "在選定的事件發生時圖示透明度將會漸變."
L["ANIM_ICONFLASH"] = "圖示:顏色閃爍"
L["ANIM_ICONFLASH_DESC"] = "利用顏色重疊在整個圖示上閃爍,達到提示的效果."
L["ANIM_ICONOVERLAYIMG"] = "圖示:覆蓋圖像"
L["ANIM_ICONOVERLAYIMG_DESC"] = "在圖示上覆蓋自訂圖像."
L["ANIM_ICONSHAKE"] = "圖示:震動"
L["ANIM_ICONSHAKE_DESC"] = "在事件觸發時震動圖示."
L["ANIM_INFINITE"] = "無限重複播放"
L["ANIM_INFINITE_DESC"] = [=[勾選此項將會重複播放動畫直到同個圖示上另一相同類型的動畫開始播放,或是在'%q'觸發之後才會停止.

說明:比如在事件'開始'中設定了'圖示:顏色閃爍',並且勾選了'無限重複播放',在事件'結束'設定了'圖示:顏色閃爍'(持續時間3秒),事件'開始'中的'無限重複播放'就會在事件'結束'的動畫播放結束後停止. 假如在同個圖示中沒有設定相同類型的動畫那就只能在'圖示:停止動畫'觸發之後才會停止播放.如果還是不明白,就這樣理解,同個圖示中相同類型的動畫只會存在一個,後面觸發的會覆寫掉前面觸發的.]=]
L["ANIM_MAGNITUDE"] = "震動幅度"
L["ANIM_MAGNITUDE_DESC"] = "設定震動的幅度需要多猛烈."
L["ANIM_PERIOD"] = "閃光週期"
L["ANIM_PERIOD_DESC"] = [=[設定每次閃爍應當持續多久 - 閃爍的顯示時間或消退時間.

如果設定為0則不閃爍或淡出.]=]
L["ANIM_PIXELS"] = "%s 像素"
L["ANIM_SCREENFLASH"] = "螢幕:閃爍"
L["ANIM_SCREENFLASH_DESC"] = "利用顏色重疊在整個遊戲螢幕上閃爍,達到提示的效果."
L["ANIM_SCREENSHAKE"] = "螢幕:震動"
L["ANIM_SCREENSHAKE_DESC"] = [=[在事件觸發時震動整個遊戲螢幕.

注意:螢幕震動只能在離開戰鬥後使用,或者在你登入之後沒有啟用名條的情況下使用.

(第一點囉嗦的解釋:如果你在登入之後按下顯示名條的快捷鍵或者名條原本就已經啟用了,就無法在戰鬥中使用螢幕震動如果你需要在戰鬥中使用請繼續往下看.

第二點囉嗦的解釋:如果一定要在戰鬥中使用螢幕震動請先關閉在'ESC->介面->名稱'中有關顯示單位名條的選項,然後重登,登入之後切記不可以按到任何顯示名條的快捷鍵.）]=]
L["ANIM_SECONDS"] = "%s秒"
L["ANIM_SIZE_ANIM"] = "邊框尺寸"
L["ANIM_SIZE_ANIM_DESC"] = "設定邊框的尺寸大小為多少."
L["ANIM_SIZEX"] = "圖像寬度"
L["ANIM_SIZEX_DESC"] = "設定圖像的寬度為多少."
L["ANIM_SIZEY"] = "圖像高度"
L["ANIM_SIZEY_DESC"] = "設定圖像的高度為多少."
L["ANIM_TAB"] = "動畫"
L["ANIM_TEX"] = "材質"
L["ANIM_TEX_DESC"] = [=[選擇你要用於覆蓋圖示的材質.

你可以輸入一個材質路徑,例如'Interface/Icons/spell_nature_healingtouch', 假如材質路徑為'Interface/Icons'可以只輸入'spell_nature_healingtouch'.

你也能使用放在WoW資料夾中的自訂材質(請在該欄位輸入材質的相對路徑,如:'tmw/ccc.tga'),僅支持尺寸為2的N次方(32, 64, 128,等)並且類型為.tga和.blp的材質檔案.]=]
L["ANIM_THICKNESS"] = "邊框粗細"
L["ANIM_THICKNESS_DESC"] = "設定邊框的粗細為多少.(一個圖示的預設尺寸為30.)"
L["ANN_CHANTOUSE"] = "使用頻道"
L["ANN_EDITBOX"] = "要輸出的文字內容"
L["ANN_EDITBOX_DESC"] = "輸入事件觸發時你想輸出的文字內容."
L["ANN_EDITBOX_WARN"] = "在此輸入你想要輸出的文字內容"
L["ANN_EVENT_GLOBALDESC"] = "在此列表中的事件是按照從上到下的順序來檢查.如果一個事件觸發並且輸出了文字內容,在它之後的事件將不再輸出任何文字內容."
L["ANN_FCT_DESC"] = "使用暴雪的浮動戰鬥文字功能輸出.必須先啟用介面選項中的文字輸出."
L["ANN_SHOWICON"] = "顯示圖示材質"
L["ANN_SHOWICON_DESC"] = "一些文字目標能連同文字內容一起顯示一個材質.勾選此項啟用該功能."
L["ANN_STICKY"] = "靜態訊息"
L["ANN_SUB_CHANNEL"] = "輸出位置"
L["ANN_TAB"] = "文字"
L["ANN_WHISPERTARGET"] = "悄悄話目標"
L["ANN_WHISPERTARGET_DESC"] = "輸入你想要密語的玩家名字, 僅可密語同伺服器/同陣營的玩家."
L["ASCENDING"] = "升序"
L["ASPECT"] = "守護"
L["AURA"] = "光環"
L["BACK_IE"] = "轉到上一個"
L["BACK_IE_DESC"] = "載入上一個編輯過的圖示(%s |T%s:0|t)."
L["BleedDamageTaken"] = "受到的流血效果傷害提高"
L["Bleeding"] = "流血效果"
L["BonusAgiStr"] = "敏捷/力量提高"
L["BonusArmor"] = "護甲值提高"
L["BonusMana"] = "法力值上限提高"
L["BonusStamina"] = "耐力提高"
L["BOTTOM"] = "下"
L["BOTTOMLEFT"] = "左下"
L["BOTTOMRIGHT"] = "右下"
L["BUFFCNDT_DESC"] = "只有第一個法術會被檢查,其他的將全部被忽略."
L["BUFFTOCHECK"] = "要檢查的增益"
L["BUFFTOCOMP1"] = "進行比較的第一個增益"
L["BUFFTOCOMP2"] = "進行比較的第二個增益"
L["BurstHaste"] = "英勇/嗜血"
L["BurstManaRegen"] = "突發性法力恢復"
L["CACHING"] = "TellMeWhen正在快取和篩選遊戲中的所有法術.這只需要在每次魔獸世界補丁升級之後完成一次.您可以使用下方的滑桿加快或減慢過程."
L["CACHINGSPEED"] = "法術快取速度(每幀法術):"
L["CASTERFORM"] = "施法者形態"
L["CENTER"] = "中間"
L["CHAT_FRAME"] = "聊天/訊息框體"
L["CHAT_MSG_CHANNEL"] = "聊天頻道"
L["CHAT_MSG_CHANNEL_DESC"] = "將輸出到一個聊天頻道,例如交易頻道或是你加入的某個自訂頻道."
L["CHAT_MSG_SMART"] = "智能頻道"
L["CHAT_MSG_SMART_DESC"] = "此頻道會自行選擇最合適的輸出頻道.(僅限於:戰場,團隊,隊伍,或者說)"
L["CHECKORDER"] = "更新排序"
L["CHECKORDER_GROUPDESC"] = "變更此項將會按照設定來更新此群組的排序.只會在你需要使用檢查 整合圖示 的子元時用到.(子元指添加到整合圖示列表中的整合圖示)"
L["CHECKORDER_ICONDESC"] = "勾選此項將會按照設定來更新此群組中的圖示的排序.只會在你需要使用檢查 整合圖示 的子元時用到.(子元指添加到整合圖示列表中的整合圖示)"
L["CHOOSEICON"] = "選擇一個用於檢查的圖示"
L["CHOOSENAME_DIALOG"] = [=[輸入你想讓此圖示監視的名稱或者ID,你可以利用分號';'輸入多個條目(名稱/ID/同類型的任意組合).

你可以|cff7fffff按住Shift再按滑鼠左鍵點選|r法術/物品/聊天連結或者拖曳法術/物品添加到此編輯框中.]=]
L["CHOOSENAME_DIALOG_CNDTIC"] = "輸入你要使用的法術材質名稱或ID.你也可以輸入一個材質路徑,例如'Interface/Icons/spell_nature_healingtouch', 假如材質路徑為'Interface/Icons'可以只輸入'spell_nature_healingtouch'."
L["CHOOSENAME_DIALOG_DDDEFAULT"] = "預設法術/驱散类型"
L["CHOOSENAME_DIALOG_MSCD"] = "輸入你要此圖示監視的名稱或者ID,僅第一個法術/物品會被檢查,使用分號分隔的列表不適用此圖示類型."
L["CHOOSENAME_DIALOG_PETABILITIES"] = "|cFFFF5959寵物技能|r必須使用法術ID."
L["CHOOSENAME_EQUIVS_TOOLTIP"] = "你可以在此選單中選擇預設的增益/減益,法術施放,遞減,或者驅散類型(魔法,詛咒等.)插入到\"%s\"編輯框中."
L["CLEU_"] = "任意事件"
L["CLEU_CAT_AURA"] = "增益/減益"
L["CLEU_CAT_CAST"] = "施法"
L["CLEU_CAT_MISC"] = "其他"
L["CLEU_CAT_SPELL"] = "法術"
L["CLEU_CAT_SWING"] = "近戰/遠程"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MASK"] = "操控者關係"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MINE"] = "操控者關係:玩家(你)"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MINE_DESC"] = "勾選以排除那些你控制的單位."
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_OUTSIDER"] = "操控者關係:外人"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_OUTSIDER_DESC"] = "勾選以排除那些與你同組的某人控制的單位."
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_PARTY"] = "操控者關係:隊伍成員"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_PARTY_DESC"] = "勾選以排除那些你隊伍中的玩家控制的單位."
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_RAID"] = "操控者關係:團隊成員"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_RAID_DESC"] = "勾選以排除那些你團隊中的玩家控制的單位."
L["CLEU_COMBATLOG_OBJECT_CONTROL_MASK"] = "操控者"
L["CLEU_COMBATLOG_OBJECT_CONTROL_NPC"] = "操控者:伺服器"
L["CLEU_COMBATLOG_OBJECT_CONTROL_NPC_DESC"] = "勾選以排除那些伺服器控制的單位(包括它們的寵物跟守護者)."
L["CLEU_COMBATLOG_OBJECT_CONTROL_PLAYER"] = "操控者:人類"
L["CLEU_COMBATLOG_OBJECT_CONTROL_PLAYER_DESC"] = "勾選以排除那些人類控制的單位(包括他們的寵物跟守護者),這裡是指真正的人類,不是遊戲中的人類種族,如果你教會了猴子/猩猩玩魔獸世界的話,可以算上它們."
L["CLEU_COMBATLOG_OBJECT_FOCUS"] = "其他:你的專注目標"
L["CLEU_COMBATLOG_OBJECT_FOCUS_DESC"] = "勾選以排除那個你設定為專注目標的單位."
L["CLEU_COMBATLOG_OBJECT_MAINASSIST"] = "其他:主助攻"
L["CLEU_COMBATLOG_OBJECT_MAINASSIST_DESC"] = "勾選以排除團隊中被標記為主助攻的單位."
L["CLEU_COMBATLOG_OBJECT_MAINTANK"] = "其他:主坦克"
L["CLEU_COMBATLOG_OBJECT_MAINTANK_DESC"] = "勾選以排除團隊中被標記為主坦克的單位."
L["CLEU_COMBATLOG_OBJECT_NONE"] = "其他:未知單位"
L["CLEU_COMBATLOG_OBJECT_NONE_DESC"] = "勾選以排除WoW客戶端完全未知的單位.此情況很少出現,通常可以不勾選."
L["CLEU_COMBATLOG_OBJECT_REACTION_FRIENDLY"] = "單位反應:友好"
L["CLEU_COMBATLOG_OBJECT_REACTION_FRIENDLY_DESC"] = "勾選以排除那些對你反應是友好的單位."
L["CLEU_COMBATLOG_OBJECT_REACTION_HOSTILE"] = "單位反應:敵對"
L["CLEU_COMBATLOG_OBJECT_REACTION_HOSTILE_DESC"] = "勾選以排除那些對你反應是敵對的單位."
L["CLEU_COMBATLOG_OBJECT_REACTION_MASK"] = "單位反應"
L["CLEU_COMBATLOG_OBJECT_REACTION_NEUTRAL"] = "單位反應:中立"
L["CLEU_COMBATLOG_OBJECT_REACTION_NEUTRAL_DESC"] = "勾選以排除那些對你反應是中立的單位."
L["CLEU_COMBATLOG_OBJECT_TARGET"] = "其他:你的目標"
L["CLEU_COMBATLOG_OBJECT_TARGET_DESC"] = "勾選以排除你當前的目標單位."
L["CLEU_COMBATLOG_OBJECT_TYPE_GUARDIAN"] = "單位類型:守護者"
L["CLEU_COMBATLOG_OBJECT_TYPE_GUARDIAN_DESC"] = "勾選以排除守護者. 守護者指那些會保護操控者但是不能直接被控制的單位."
L["CLEU_COMBATLOG_OBJECT_TYPE_MASK"] = "單位類型"
L["CLEU_COMBATLOG_OBJECT_TYPE_NPC"] = "單位類型:NPC"
L["CLEU_COMBATLOG_OBJECT_TYPE_NPC_DESC"] = "勾選以排除非玩家角色."
L["CLEU_COMBATLOG_OBJECT_TYPE_OBJECT"] = "單位類型:對象"
L["CLEU_COMBATLOG_OBJECT_TYPE_OBJECT_DESC"] = "勾選以排除像是陷阱,魚點等其他沒有被劃分到\"單位類型\"中的其他任何東西."
L["CLEU_COMBATLOG_OBJECT_TYPE_PET"] = "單位類型:寵物"
L["CLEU_COMBATLOG_OBJECT_TYPE_PET_DESC"] = "勾選以排除寵物. 寵物指那些會保護操控者並且可以直接被控制的單位."
L["CLEU_COMBATLOG_OBJECT_TYPE_PLAYER"] = "單位類型:玩家角色"
L["CLEU_COMBATLOG_OBJECT_TYPE_PLAYER_DESC"] = "勾選以排除玩家角色."
L["CLEU_DAMAGE_SHIELD"] = "傷害護盾"
L["CLEU_DAMAGE_SHIELD_DESC"] = "此事件在傷害護盾對一個單位造成傷害時發生. (%s,%s,等等,但是不包括%s)"
L["CLEU_DAMAGE_SHIELD_MISSED"] = "傷害護盾未命中"
L["CLEU_DAMAGE_SHIELD_MISSED_DESC"] = "此事件在傷害護盾對一個單位造成傷害失敗時發生. (%s,%s,等等,但是不包括%s)"
L["CLEU_DAMAGE_SPLIT"] = "傷害分擔"
L["CLEU_DAMAGE_SPLIT_DESC"] = "此事件在傷害被兩個或更多個單位分擔時發生."
L["CLEU_DESTUNITS"] = "用於檢查的目標單位"
L["CLEU_DESTUNITS_DESC"] = "選擇你想要圖示檢查的事件目標單位,可以保留空白讓圖示檢查任意的事件目標單位."
L["CLEU_DIED"] = "死亡"
L["CLEU_ENCHANT_APPLIED"] = "附魔應用"
L["CLEU_ENCHANT_APPLIED_DESC"] = "此事件所指為暫時性武器附魔,像是盜賊的毒藥和薩滿的武器強化."
L["CLEU_ENCHANT_REMOVED"] = "附魔移除"
L["CLEU_ENCHANT_REMOVED_DESC"] = "此事件所指為暫時性武器附魔,像是盜賊的毒藥和薩滿的武器強化."
L["CLEU_ENVIRONMENTAL_DAMAGE"] = "環境傷害"
L["CLEU_ENVIRONMENTAL_DAMAGE_DESC"] = "包括來自熔岩,掉落,溺水以及疲勞的傷害."
L["CLEU_EVENTS"] = "用於檢查的事件"
L["CLEU_EVENTS_ALL"] = "全部事件"
L["CLEU_EVENTS_DESC"] = "選擇那些你想要圖示檢查的戰鬥事件."
L["CLEU_FLAGS_DESC"] = "可以排除列表中包含的某種屬性的單位使其無法觸發圖示.如果勾選排除某種屬性的單位,圖示將不會處理那個單位相關的事件."
L["CLEU_HEADER"] = "戰鬥事件篩選"
L["CLEU_NOFILTERS"] = "%s圖示在%s沒有定義任何篩選條件.你需要定義至少一個篩選條件,否則無法正常使用."
L["CLEU_PARTY_KILL"] = "隊伍擊殺"
L["CLEU_RANGE_DAMAGE"] = "遠程攻擊傷害"
L["CLEU_RANGE_MISSED"] = "遠程攻擊未命中"
L["CLEU_SOURCEUNITS"] = "用於檢查的來源單位"
L["CLEU_SOURCEUNITS_DESC"] = "選擇你想要圖示檢查的事件來源單位,可以保留空白讓圖示檢查任意的事件來源單位."
L["CLEU_SPELL_AURA_APPLIED"] = "效果獲得(指目標單位獲得某增益/減益,來源單位為施放者)"
L["CLEU_SPELL_AURA_APPLIED_DOSE"] = "效果堆疊"
L["CLEU_SPELL_AURA_BROKEN"] = "效果被打破(物理)"
L["CLEU_SPELL_AURA_BROKEN_SPELL"] = "效果被打破(法術)"
L["CLEU_SPELL_AURA_BROKEN_SPELL_DESC"] = [=[此事件在一個效果被法術傷害打破時發生(通常是指某種控場技能).

圖示會篩選出被打破的效果;在文字輸出中你可以使用變數'%x'替代這個效果.]=]
L["CLEU_SPELL_AURA_REFRESH"] = "效果刷新"
L["CLEU_SPELL_AURA_REMOVED"] = "效果移除"
L["CLEU_SPELL_AURA_REMOVED_DOSE"] = "效果堆疊移除"
L["CLEU_SPELL_CAST_FAILED"] = "施法失敗"
L["CLEU_SPELL_CAST_START"] = "開始施法"
L["CLEU_SPELL_CAST_START_DESC"] = [=[此事件在開始施放一個法術時發生.

注意:為了防止可能出現的遊戲框架濫用,暴雪禁用了此事件的目標單位,所以你不能篩選它們.]=]
L["CLEU_SPELL_CAST_SUCCESS"] = "瞬發法術施放完成" -- Needs review
L["CLEU_SPELL_CAST_SUCCESS_DESC"] = [=[此事件在瞬發法術施法完成時發生.

注意:在潘達利亞之謎前,此功能支持任意法術的成功施放. 現在僅支持瞬發法術.

注意:為了防止可能出現的遊戲框架濫用,暴雪禁用了此事件的目標單位,所以你不能篩選它們.]=] -- Needs review
L["CLEU_SPELL_CREATE"] = "法術製造"
L["CLEU_SPELL_CREATE_DESC"] = "此事件在一個對像被製造時發生,例如獵人的陷阱跟法師的傳送門."
L["CLEU_SPELL_DAMAGE"] = "法術傷害"
L["CLEU_SPELL_DAMAGE_CRIT"] = "法術致命一擊"
L["CLEU_SPELL_DAMAGE_CRIT_DESC"] = "此事件在任意法術造成致命一擊時發生(可能會在同一時間觸發%q事件)."
L["CLEU_SPELL_DAMAGE_DESC"] = "此事件在任意法術造成傷害時發生."
L["CLEU_SPELL_DISPEL"] = "驅散"
L["CLEU_SPELL_DISPEL_DESC"] = [=[此事件在一個效果被驅散時發生.

圖示會篩選出被驅散的效果;在文字輸出中你可以使用變數'%x'替代這個效果.]=]
L["CLEU_SPELL_DISPEL_FAILED"] = "驅散失敗"
L["CLEU_SPELL_DISPEL_FAILED_DESC"] = [=[此事件在驅散某一效果失敗時發生.

圖示會篩選出這個驅散失敗的效果;在文字輸出中你可以使用變數'%x'替代這個效果.]=]
L["CLEU_SPELL_DRAIN"] = "抽取資源"
L["CLEU_SPELL_DRAIN_DESC"] = "此事件在資源從一個單位移除時發生(資源指生命值/法力值/怒氣/能量等)."
L["CLEU_SPELL_ENERGIZE"] = "獲得資源"
L["CLEU_SPELL_ENERGIZE_DESC"] = "此事件在一個單位獲得資源時發生(資源指生命值/法力值/怒氣/能量等)."
L["CLEU_SPELL_EXTRA_ATTACKS"] = "獲得額外攻擊"
L["CLEU_SPELL_EXTRA_ATTACKS_DESC"] = "此事件在你獲得額外的近戰攻擊時發生."
L["CLEU_SPELL_HEAL"] = "治療"
L["CLEU_SPELL_INSTAKILL"] = "秒殺"
L["CLEU_SPELL_INTERRUPT"] = "中斷 - 被中斷的法術"
L["CLEU_SPELL_INTERRUPT_DESC"] = [=[此事件在施法被中斷時發生.

圖示會篩選出被中斷施法的法術;在文字輸出中你可以使用變數'%x'替代這個法術.

請注意兩個中斷事件的區別- 當一個法術被中斷時兩個事件都會發生,但是篩選出的法術會有所不同.]=]
L["CLEU_SPELL_INTERRUPT_SPELL"] = "中斷 - 造成中斷的法術"
L["CLEU_SPELL_INTERRUPT_SPELL_DESC"] = [=[此事件在施法被中斷時發生.

圖示會篩選出造成中斷施法的法術;在文字輸出中你可以使用變數'%x'替代這個法術.

請注意兩個中斷事件的區別- 當一個法術被中斷時兩個事件都會發生,但是篩選出的法術會有所不同.]=]
L["CLEU_SPELL_LEECH"] = "資源吸取"
L["CLEU_SPELL_LEECH_DESC"] = "此事件在從一個單位移除資源給另一單位時發生(資源指生命值/法力值/怒氣/能量等)."
L["CLEU_SPELL_MISSED"] = "法術未命中"
L["CLEU_SPELL_PERIODIC_DAMAGE"] = "傷害(週期)"
L["CLEU_SPELL_PERIODIC_DRAIN"] = "抽取資源(週期)"
L["CLEU_SPELL_PERIODIC_ENERGIZE"] = "獲得資源(週期)"
L["CLEU_SPELL_PERIODIC_HEAL"] = "治療(週期)"
L["CLEU_SPELL_PERIODIC_LEECH"] = "資源吸取(週期)"
L["CLEU_SPELL_PERIODIC_MISSED"] = "傷害(週期)未命中"
L["CLEU_SPELL_REFLECT"] = "法術反射"
L["CLEU_SPELL_REFLECT_DESC"] = [=[此事件在你反射一個對你施放的法術時發生.

來源單位是反射法術者,目標單位是法術被反射的施法者.]=]
L["CLEU_SPELL_RESURRECT"] = "復活"
L["CLEU_SPELL_RESURRECT_DESC"] = "此事件在某個單位從死亡中被復活時發生."
L["CLEU_SPELL_STOLEN"] = "效果被竊取"
L["CLEU_SPELL_STOLEN_DESC"] = [=[此事件在增益被竊取時發生,很可能來自%s.

圖示會篩選出那個被竊取的法術.]=]
L["CLEU_SPELL_SUMMON"] = "法術召喚"
L["CLEU_SPELL_SUMMON_DESC"] = "此事件在一個NPC被召喚或者生成時發生."
L["CLEU_SWING_DAMAGE"] = "近戰攻擊傷害"
L["CLEU_SWING_MISSED"] = "近戰攻擊未命中"
L["CLEU_TIMER"] = "設定事件的計時器"
L["CLEU_TIMER_DESC"] = [=[設定圖示計時器在事件發生時的持續時間.

你也可以在%q編輯框中使用"法術:持續時間"語法指定一個持續時間,在事件處理你篩選出的那些法術時使用.

如果法術沒有指定持續時間,或者你沒有篩選任何法術(編輯框為空白),那將使用這個持續時間.]=]
L["CLEU_UNIT_DESTROYED"] = "單位被摧毀"
L["CLEU_UNIT_DESTROYED_DESC"] = "此事件在一個單位被摧毀時發生(例如薩滿的圖騰)."
L["CLEU_UNIT_DIED"] = "單位死亡"
L["CLEU_WHOLECATEGORYEXCLUDED"] = [=[你排除了%q分類中的所有條目,這將導致圖示不再處理任何事件.

取消勾選至少一個條目使圖示可以正常運作.]=]
L["CMD_DISABLE"] = "停用"
L["CMD_ENABLE"] = "啟用"
L["CMD_OPTIONS"] = "選項"
L["CMD_TOGGLE"] = "切換"
L["CNDTCAT_ATTRIBUTES_PLAYER"] = "玩家屬性/狀態"
L["CNDTCAT_ATTRIBUTES_UNIT"] = "單位屬性/狀態"
L["CNDTCAT_BUFFSDEBUFFS"] = "增益/減益"
L["CNDTCAT_CURRENCIES"] = "通貨"
L["CNDTCAT_FREQUENTLYUSED"] = "常用條件"
L["CNDTCAT_RESOURCES"] = "能量類型"
L["CNDTCAT_SPELLSABILITIES"] = "法術/物品"
L["CNDTCAT_STATS"] = "戰鬥統計(人物屬性)"
L["CNDT_ONLYFIRST"] = "僅檢查第一個法術/物品,使用分號分隔的列表不適用此條件類型."
L["CODETOEXE"] = "要執行的代碼"
L["COLOR_CBC"] = "冷卻條 - 完成"
L["COLOR_CBC_DESC"] = "冷卻/持續時間計量條在冷卻/持續時間已完成後的顏色"
L["COLOR_CBS"] = "冷卻條 - 開始"
L["COLOR_CBS_DESC"] = "冷卻/持續時間計量條在冷卻/持續時間剛開始的顏色"
L["COLOR_COA"] = "倒數中,計時器隱藏,一直顯示"
L["COLOR_COA_DESC"] = [=[圖示在何時著色:

計時器激活(不可用/存在時),
%q已停用
同時%q已勾選]=] -- Needs review
L["COLOR_COLOR"] = "顏色"
L["COLOR_COS"] = "倒數中,計時器隱藏,有時顯示"
L["COLOR_COS_DESC"] = [=[圖示在何時著色:

計時器激活(不可用/存在時),
%q已停用
同時%q沒有勾選]=] -- Needs review
L["COLOR_CTA"] = "倒數中,計時器顯示,一直顯示"
L["COLOR_CTA_DESC"] = [=[圖示在何時著色:

計時器激活(不可用/存在時),
%q已啟用
同時%q已勾選]=] -- Needs review
L["COLOR_CTS"] = "倒數中,計時器顯示,有時顯示"
L["COLOR_CTS_DESC"] = [=[圖示在何時著色:

計時器激活(不可用/存在時),
%q已啟用
同時%q沒有勾選]=] -- Needs review
L["COLOR_DEFAULT"] = "*全局顏色*"
L["COLOR_DESATURATE"] = "灰色調"
L["COLOR_DESATURATE_DESC"] = "勾選此項圖示中相關的顏色將使用灰色調.(注意:需要先勾選顏色類型的'使用'選項)"
L["COLOR_HEADER"] = [=[下列這些顏色設定將使用在所有%s 的圖示上,在它們的選項%q 已勾選的情況下.

純白色不會對材質造成任何改變. 純黑色會使材質完全變黑.所有介於黑白兩者之間的灰色調及其他顏色全部都會對圖示進行著色.]=]
L["COLOR_HEADER_DEFAULT"] = [=[在圖示類型沒有單獨使用顏色設定的時候將使用這些顏色設定.

純白色不會對材質造成任何改變. 純黑色會使材質完全變黑.所有介於黑白兩者之間的灰色調及其他顏色全部都會對圖示進行著色.]=]
L["COLOR_MSQ_COLOR"] = "使用Masque邊框顏色(整個圖示)"
L["COLOR_MSQ_COLOR_DESC"] = "勾選此項將使用Masque皮膚中設定的邊框顏色對圖示著色(假如你在皮膚設定中有使用邊框的話)."
L["COLOR_MSQ_ONLY"] = "使用Masque邊框顏色(僅邊框)"
L["COLOR_MSQ_ONLY_DESC"] = "勾選此項將僅對圖示邊框使用Masque皮膚中設定的邊框顏色進行著色(假如你在皮膚設定中有使用邊框的話).圖示不會被著色."
L["COLOR_NA"] = "已結束,一直顯示"
L["COLOR_NA_DESC"] = [=[圖示在何時著色:

計時器已結束(可用/缺少時),
同時%q已勾選]=] -- Needs review
L["COLORNAMES"] = "名字使用職業顏色"
L["COLORNAMES_DESC"] = "檢查並嘗試給文字中顯示的單位名字著色(綁定/標籤文字和文字輸出事件)."
L["COLOR_NS"] = "已結束,有時顯示"
L["COLOR_NS_DESC"] = [=[圖示在何時著色:

計時器已結束(可用/缺少時)
同時%q沒有勾選]=] -- Needs review
L["COLOR_OOM"] = "法力值不足"
L["COLOR_OOM_DESC"] = "當你施放法術能量不足時圖示的顏色."
L["COLOR_OOR"] = "超出距離"
L["COLOR_OOR_DESC"] = "當你不在技能範圍內時圖示的顏色."
L["COLOR_OORM"] = "超出距離&法力值不足"
L["COLOR_OORM_DESC"] = "當你施放法術能量不足 同時 不在技能範圍內時圖示的顏色"
L["COLOR_OVERRIDEDEFAULT"] = "使用"
L["COLOR_OVERRIDEDEFAULT_DESC"] = "勾選此項將使用該設定覆寫*全局顏色*."
L["COLOR_RESET_DESC"] = "點擊將此設定重設為預設值"
L["COMPARISON"] = "比較"
L["CONDITIONALPHA"] = "持續時間/堆疊/條件未通過時"
L["CONDITIONALPHA_CONDITIONICON"] = "持續時間未通過時"
L["CONDITIONALPHA_CONDITIONICON_DESC"] = "此透明度設定用於持續時間的要求無法得到滿足時.如果在另外兩個透明度的設定下圖示已經隱藏,此選項將被忽略."
L["CONDITIONALPHA_DESC"] = "此透明度設定用於條件未通過或者持續時間/堆疊數量的要求無法得到滿足時.如果在另外兩個透明度的設定下圖示已經隱藏,此選項將被忽略."
L["CONDITIONALPHA_METAICON"] = "條件未通過時"
L["CONDITIONALPHA_METAICON_DESC"] = "此透明度設定用於條件未通過時."
L["CONDITIONORMETA_CHECKINGINVALID"] = "警告!群組 %d,圖示 %d 正在檢查一個無效的圖示(群組 %d , 圖示 %d)"
L["CONDITIONORMETA_CHECKINGINVALID_GROUP"] = "警告! 群組 %d 正在檢查一個無效的圖示 (群組 %d, 圖示 %d)"
L["CONDITIONPANEL_ABSOLUTE"] = "(非百分比)絕對"
L["CONDITIONPANEL_ADD"] = "新增條件"
L["CONDITIONPANEL_ALIVE"] = "單位存活"
L["CONDITIONPANEL_ALIVE_DESC"] = "此條件會在單位還活著時通過"
L["CONDITIONPANEL_ALTPOWER"] = "特殊能量"
L["CONDITIONPANEL_ALTPOWER_DESC"] = "這是浩劫與重生某些首領戰遇到的特殊能量,像是丘加利的腐化值跟亞特拉米德的音波值."
L["CONDITIONPANEL_AND"] = "同時"
L["CONDITIONPANEL_ANDOR"] = "同時/或者"
L["CONDITIONPANEL_ANDOR_DESC"] = "|cff7fffff點擊|r切換邏輯運算符 同時/或者(And/Or)"
L["CONDITIONPANEL_AUTOCAST"] = "寵物自動施法"
L["CONDITIONPANEL_CASTTOMATCH"] = "用於匹配的法術"
L["CONDITIONPANEL_CASTTOMATCH_DESC"] = [=[在此輸入一個法術名稱使該條件只在施放的法術名稱跟輸入的法術名稱完全匹配時才可通過.

你可以保留空白來檢查任意的法術施放/引導法術(不包括瞬發法術).]=]
L["CONDITIONPANEL_CLASS"] = "單位職業"
L["CONDITIONPANEL_CLASSIFICATION"] = "單位分類"
L["CONDITIONPANEL_COMBAT"] = "單位在戰鬥中"
L["CONDITIONPANEL_COMBO"] = "連擊點數"
L["CONDITIONPANEL_DEFAULT"] = "選擇條件類型..."
L["CONDITIONPANEL_ECLIPSE_DESC"] = [=[蝕星蔽月有一個範圍在-100(月蝕) 到100(日蝕). 
如果你想讓圖示在有80月蝕的時候顯示請輸入-80]=]
L["CONDITIONPANEL_EQUALS"] = "等於"
L["CONDITIONPANEL_EXISTS"] = "單位存在"
L["CONDITIONPANEL_GREATER"] = "大於"
L["CONDITIONPANEL_GREATEREQUAL"] = "大於或者等於"
L["CONDITIONPANEL_GROUPTYPE"] = "隊伍類型"
L["CONDITIONPANEL_ICON"] = "圖示顯示"
L["CONDITIONPANEL_ICON_DESC"] = [=[此條件檢查指定圖示的顯示狀態或隱藏狀態.

如果你不想顯示那個被檢查的圖示,請在被檢查圖示的圖示編輯器勾選 %q.

即使條件設定為否,同樣會強制檢查圖示的顯示情況.]=]
L["CONDITIONPANEL_ICON_HIDDEN"] = "隱藏"
L["CONDITIONPANEL_ICON_SHOWN"] = "顯示"
L["CONDITIONPANEL_INSTANCETYPE"] = "副本類型"
L["CONDITIONPANEL_INTERRUPTIBLE"] = "可斷法"
L["CONDITIONPANEL_ITEMRANGE"] = "單位在物品範圍內"
L["CONDITIONPANEL_LESS"] = "小於"
L["CONDITIONPANEL_LESSEQUAL"] = "小於或者等於"
L["CONDITIONPANEL_LEVEL"] = "單位等級"
L["CONDITIONPANEL_MANAUSABLE"] = "法術可用(法力值/能量/等是否夠用)"
L["CONDITIONPANEL_MAX"] = "最大"
L["CONDITIONPANEL_MOUNTED"] = "在坐騎上"
L["CONDITIONPANEL_NAME"] = "單位名字"
L["CONDITIONPANEL_NAMETOMATCH"] = "用於匹配的名字"
L["CONDITIONPANEL_NAMETOOLTIP"] = "你可以在每個名字後面加上分號(;)以便輸入多個需要匹配的名字. 其中任何一個名字匹配時此條件都會通過."
L["CONDITIONPANEL_NOTEQUAL"] = "不等於"
L["CONDITIONPANEL_OPERATOR"] = "運算符"
L["CONDITIONPANEL_OR"] = "或者"
L["CONDITIONPANEL_PETMODE"] = "寵物攻擊模式"
L["CONDITIONPANEL_PETTREE"] = "寵物天賦樹"
L["CONDITIONPANEL_POWER"] = "基本資源"
L["CONDITIONPANEL_POWER_DESC"] = "檢查單位為德魯伊時在貓形態的能量,或者單位為戰士時的怒氣等等."
L["CONDITIONPANEL_PVPFLAG"] = "開啟PVP的單位"
L["CONDITIONPANEL_RAIDICON"] = "單位團隊標記"
L["CONDITIONPANEL_REMOVE"] = "移除此條件"
L["CONDITIONPANEL_RESTING"] = "休息狀態"
L["CONDITIONPANEL_ROLE"] = "單位角色類型"
L["CONDITIONPANEL_RUNES_DESC"] = [=[使用此條件類型只在選擇的符文條件通過時顯示圖示.

每個符文都可以被標記.'V'打勾時條件需要在符文可用的情況下才能通過,'X'打叉時則條件需要在符文不可用的情況下才能通過,沒有標記的符文不會被檢查.

第二行符文為上面每個符文所對應的死亡符文.

說明:不要局限於只用一個符文條件,你可以添加多個符文條件靈活的設定符文的可用不可用情況來達到自己想要的效果.]=]
L["CONDITIONPANEL_SPELLRANGE"] = "單位在法術範圍內"
L["CONDITIONPANEL_SWIMMING"] = "游泳狀態"
L["CONDITIONPANEL_THREAT_RAW"] = "單位威脅值 - 原始"
L["CONDITIONPANEL_THREAT_RAW_DESC"] = [=[此條件用來檢查你對一個單位的原始威脅值百分比.

近戰玩家仇恨失控(OT)的威脅值為110%
遠程玩家仇恨失控(OT)的威脅值為130%]=]
L["CONDITIONPANEL_THREAT_SCALED"] = "單位威脅值 - 比例"
L["CONDITIONPANEL_THREAT_SCALED_DESC"] = [=[此條件用來檢查你對一個單位的威脅值百分比比例.

100%表示你正在坦這個單位.]=]
L["CONDITIONPANEL_TRACKING"] = "追蹤"
L["CONDITIONPANEL_TYPE"] = "類型"
L["CONDITIONPANEL_UNIT"] = "單位"
L["CONDITIONPANEL_UNIT_DESC"] = [=[在此輸入需要監視的單位.此單位能從下拉列表插入到右邊,或者你是一位高端玩家可以自行輸入需要監視的單位.
可使用標準單位(例如:player,target,mouseover,等) 或者友好玩家的名字(例如: %s, Cybeloras,小兔是豬,阿光是豬,等.)
PS:上面的標準單位不是沒有翻譯,巨集中可以使用的單位都可以使用.]=]
L["CONDITIONPANEL_UNITDROPDOWN_DESC"] = [=[您可以從此選單中選擇單位插入到編輯框中.
單位的結尾'|cFFFF0000#|r'需要替換為單位相對應的數字.
例如變更'raid|cFFFF0000#|r'為'raid25'檢查第25個團隊成員.

注意:所有條件只允許檢查一個單位.]=]
L["CONDITIONPANEL_UNITISUNIT"] = "單位比較"
L["CONDITIONPANEL_UNITISUNIT_DESC"] = "此條件在兩個編輯框輸入的單位為同一角色時通過.(例子:編輯框1為'targettarget',編輯框2為'player',當'目標的目標'為'玩家'時此條件通過.)"
L["CONDITIONPANEL_UNITISUNIT_EBDESC"] = "在此編輯框輸入需要與所指定的第一單位進行比較的第二單位."
L["CONDITIONPANEL_VALUEN"] = "值"
L["CONDITIONPANEL_VEHICLE"] = "單位控制載具"
L["CONDITIONS"] = "條件"
L["CONDITION_TIMERS_FAIL_DESC"] = [=[設定條件無法通過以後圖示計時器的持續時間

(譯者註:圖示在條件每次通過/無法通過後都會重新計時,另外在預設的情況下圖示的顯示只會根據條件通過情況來改變,設定的持續時間不會影響到圖示的顯示情況,不會在設定的持續時間倒數結束後隱藏圖示,如果想要圖示在計時結束後隱藏,需要勾選'僅在計時器作用時顯示',這是4.5.3版本新加入的功能.)]=]
L["CONDITION_TIMERS_HEADER"] = "計時器"
L["CONDITION_TIMERS_SUCCEED_DESC"] = [=[設定條件成功通過以後圖示計時器的持續時間

(譯者註:圖示在條件每次通過/無法通過後都會重新計時,另外在預設的情況下圖示的顯示只會根據條件通過情況來改變,設定的持續時間不會影響到圖示的顯示情況,不會在設定的持續時間倒數結束後隱藏圖示,如果想要圖示在計時結束後隱藏,需要勾選'僅在計時器作用時顯示',這是4.5.3版本新加入的功能.)]=]
L["CONFIGMODE"] = "TellMeWhen正處於設定模式. 在離開設定模式之前,圖示無法正常使用. 輸入'/tellmewhen'或'/tmw'可以開啟或關閉設定模式."
L["CONFIGMODE_EXIT"] = "退出設定模式"
L["CONFIGMODE_NEVERSHOW"] = "不再顯示此訊息"
L["COPYGROUP"] = "複製群組"
L["COPYPOSSCALE"] = "複製位置/比例"
L["CREATURETYPE_1"] = "野獸"
L["CREATURETYPE_10"] = "不明"
L["CREATURETYPE_11"] = "圖騰"
L["CREATURETYPE_12"] = "非戰鬥寵物"
L["CREATURETYPE_13"] = "氣體雲"
L["CREATURETYPE_14"] = "野生寵物"
L["CREATURETYPE_2"] = "龍類"
L["CREATURETYPE_3"] = "惡魔"
L["CREATURETYPE_4"] = "元素生物"
L["CREATURETYPE_5"] = "巨人"
L["CREATURETYPE_6"] = "不死族"
L["CREATURETYPE_7"] = "人形生物"
L["CREATURETYPE_8"] = "小動物"
L["CREATURETYPE_9"] = "機械"
L["CrowdControl"] = "控場技能"
L["Curse"] = "詛咒"
L["DamageBuffs"] = "傷害爆發增益"
L["DAMAGER"] = "傷害輸出"
L["DEBUFFTOCHECK"] = "要檢查的減益"
L["DEBUFFTOCOMP1"] = "進行比較的第一個減益"
L["DEBUFFTOCOMP2"] = "進行比較的第二個減益"
L["DEFAULT"] = "預設值"
L["DefensiveBuffs"] = "防禦性增益"
L["DESCENDING"] = "降序"
L["DISABLED"] = "已停用"
L["Disarmed"] = "繳械"
L["Disease"] = "疾病"
L["Disoriented"] = "困惑"
L["DR-Banish"] = "放逐術"
L["DR-ControlledRoot"] = "控制定身"
L["DR-ControlledStun"] = "控制擊暈"
L["DR-Cyclone"] = "颶風術"
L["DR-Disarm"] = "繳械"
L["DR-Disorient"] = "迷惑/其他"
L["DR-DragonsBreath"] = "龍之吐息"
L["DR-Entrapment"] = "誘捕"
L["DR-Fear"] = "恐懼"
L["DR-Horrify"] = "恐慌"
L["DR-MindControl"] = "精神控制"
L["DROPDOWN_UNIT_DESC"] = [=[您可以從這個選單中選擇單位插入到編輯框中.
單位結尾'|cFFFF0000#|r'需要替換為單位相對應的數字,或者輸入某個範圍的數字,像是1-10.
例如變更'raid|cFFFF0000#|r'為'raid25' 檢查第25個團隊成員,或者把它改成'raid1-25'檢查前25個團隊成員.

需要更多關於單位的資訊,請訪問http://www.wowpedia.org/UnitId]=]
L["DR-RandomRoot"] = "隨機定身"
L["DR-RandomStun"] = "隨機擊暈"
L["DR-Scatter"] = "驅散射擊"
L["DR-Silence"] = "沉默"
L["DR-Taunt"] = "嘲諷"
L["DURATION"] = "持續時間"
L["EARTH"] = "大地圖騰"
L["ECLIPSE_DIRECTION"] = "蝕星蔽月方向"
L["elite"] = "精英"
L["ENABLINGOPT"] = "TellMeWhen選項已停用.正在重新啟用中..."
L["Enraged"] = "狂暴"
L["ERROR_ANCHORSELF"] = "%s嘗試依附於它自己,所以TellMeWhen會重設它的依附位置到螢幕中間以防止出現嚴重的錯誤."
L["ERROR_MISSINGFILE"] = "TellMeWhen需要在重開魔獸世界之後才能正常使用 %s (原因:無法找到%s). 你要馬上重開魔獸世界嗎?"
L["ERROR_MISSINGFILE_NOREQ"] = "TellMeWhen需要在重開魔獸世界之後才能完全正常使用 %s (原因:無法找到%s). 你要馬上重開魔獸世界嗎?"
L["EVENTS_HANDLERS_ADD"] = "新增事件處理器..."
L["EVENTS_HANDLERS_ADD_DESC"] = "|cff7fffff點擊|r選擇一個事件處理器新增到此圖示."
L["EVENTS_HANDLERS_GLOBAL_DESC"] = [=[|cff7fffff點擊|r開啟事件處理器設定選項.
|cff7fffff點擊並拖曳|r來變更排序.]=]
L["EVENTS_HANDLERS_HEADER"] = "圖示事件處理器"
L["EVENTS_HANDLERS_PLAY"] = "測試事件"
L["EVENTS_HANDLERS_PLAY_DESC"] = "|cff7fffff點擊|r測試事件處理器"
L["EVENTS_SETTINGS_CNDTJUSTPASSED"] = "僅在條件剛通過時"
L["EVENTS_SETTINGS_CNDTJUSTPASSED_DESC"] = "除非上面設定的條件剛剛成功通過,否則阻止事件的觸發."
L["EVENTS_SETTINGS_HEADER"] = "事件設定"
L["EVENTS_SETTINGS_ONLYSHOWN"] = "僅在圖示顯示時觸發"
L["EVENTS_SETTINGS_ONLYSHOWN_DESC"] = "勾選此項防止圖示在沒有顯示時觸發相關事件."
L["EVENTS_SETTINGS_PASSINGCNDT"] = "僅在條件通過時觸發:"
L["EVENTS_SETTINGS_PASSINGCNDT_DESC"] = "除非下面設定的條件成功通過,否則阻止事件的觸發."
L["EVENTS_SETTINGS_PASSTHROUGH"] = "允許觸發其他事件"
L["EVENTS_SETTINGS_PASSTHROUGH_DESC"] = [=[勾選允許在觸發該事件後去觸發另一個事件,如果不勾選,則在該事件觸發並輸出了文字/音效之後,圖示將不再處理同時觸發的其他任何事件.

可以有例外,詳情請參閱個別事件的描述.]=]
L["EVENTS_TAB"] = "事件"
L["EXPORT_f"] = "匯出 %s"
L["EXPORT_HEADING"] = "匯出"
L["EXPORT_TOCOMM"] = "到玩家"
L["EXPORT_TOCOMM_DESC"] = [=[輸入一個玩家的名字到編輯框同時選擇此選項來發送數據給他們.他們必須是你能密語的某人(同陣營,同伺服器,在線),同時他們必須已經安裝版本為4.0.0+的TellMeWhen.

你還可以輸入"GUILD"或"RAID"發送到整個公會或整個團隊(輸入時請注意區分大小寫,'GUILD'跟'RAID'中的英文字母全部都是大寫).]=]
L["EXPORT_TOGUILD"] = "到公會"
L["EXPORT_TORAID"] = "到團隊"
L["EXPORT_TOSTRING"] = "到字串"
L["EXPORT_TOSTRING_DESC"] = "包含必要數據的字串將匯出到編輯框裡,按下CTRL+C複製它,然後到任何你想分享的地方貼上它."
L["FALSE"] = "否"
L["Feared"] = "恐懼"
L["fGROUP"] = "群組: %s"
L["fICON"] = "圖示: %s"
L["FIRE"] = "火焰圖騰"
L["FONTCOLOR"] = "文字顏色"
L["FONTSIZE"] = "字體大小"
L["FORWARDS_IE"] = "轉到下一個"
L["FORWARDS_IE_DESC"] = "載入下一個編輯過的圖示(%s |T%s:0|t)."
L["fPROFILE"] = "設定檔: %s"
L["FROMNEWERVERSION"] = "你匯入的數據為版本較新的TellMeWhen所創建,某些設定在更新至最新版本之前可能無法正常使用."
L["GCD"] = "公共冷卻"
L["GCD_ACTIVE"] = "公共冷卻作用中"
L["GENERIC_NUMREQ_CHECK_DESC"] = "勾選以啟用並設定%s"
L["GROUPADDONSETTINGS"] = "群組設定"
L["GROUPCONDITIONS"] = "群組條件"
L["GROUPICON"] = "群組: %s, 圖示: %s"
L["HEALER"] = "治療"
L["Heals"] = "玩家治疗法术"
L["HELP_EXPORT_DOCOPY_MAC"] = "按下|cff7fffffCMD+C|r複製"
L["HELP_EXPORT_DOCOPY_WIN"] = "按下|cff7fffffCTRL+C|r複製"
L["HELP_FIRSTUCD"] = [=[這是你第一次使用一個採取特定時間語法的圖示類型!
在添加法術到某些圖示類型的 %q 編輯框時,必須使用下列語法在法術後面指定它們的冷卻時間/持續時間:

法術:時間

例如:

"%s: 120"
"%s: 10; %s: 24"
"%s: 180"
"%s: 3:00"
"62618: 3:00"

用建議列表插入條目時會自動添加在滑鼠提示資訊中顯示的時間(注:自動添加時間功能支持提示資訊中有顯示冷卻時間的法術以及提示資訊中有註明持續時間的大部分法術,如果一個法術同時存在上述兩種時間,會優先選擇添加冷卻時間,假如自動添加的時間不正確,請自行手動變更).]=]
L["HELP_ICD_NATURESGRACE"] = [=[嘗試檢查 %s 的內置冷卻嗎? 

建議您將圖示類型變更為%q , 可以在日蝕或月蝕觸發之後正確重置自然之賜的冷卻時間. ]=]
L["HELP_IMPORT_CURRENTPROFILE"] = [=[嘗試在這個設定檔中移動或複制一個圖示到另外一個圖示欄位嗎?

你可以輕鬆的做到這一點,使用|cff7fffff滑鼠右鍵點擊圖示並拖曳|r它到另外一個圖示欄位(這個過程需要按下滑鼠右鍵不放開). 當你放開滑鼠右鍵時,會出現一個有很多選項的選單.

嘗試拖曳一個圖示到整合圖示,其他群組,或在你螢幕上的其他框體以獲取其他相應的選項.]=]
L["HELP_MISSINGDURS"] = [=[以下法術缺少持續時間/冷卻時間:

%s

請使用下列語法添加時間:

法術:時間

例如 "%s: 10"

用建議列表插入條目時會自動添加在滑鼠提示資訊中顯示的時間(注:自動添加時間功能支持提示資訊中有顯示冷卻時間的法術以及提示資訊中有註明持續時間的大部分法術,如果一個法術同時存在上述兩種時間,會優先選擇添加冷卻時間,假如自動添加的時間不正確,請自行手動變更).]=]
L["HELP_MS_NOFOUND"] = [=[無法在動作條上找到技能 %q. 

請確保那個技能在你的動作條上,並且它是處於初始狀態,必須要注意的是出現在動作條上的技能不能是一個巨集,而是應該直接把技能放到你的動作條上.否則此圖示可能無法正常使用. 

上述初始狀態指沒有施放該技能使其出現第二個狀態.]=]
L["HELP_NOUNIT"] = "你必須輸入一個單位!"
L["HELP_NOUNITS"] = "你至少需要輸入一個單位!"
L["HELP_POCKETWATCH"] = [=[|TInterface\Icons\INV_Misc_PocketWatch_01:20|t -- 關於懷錶材質

此材質用於第一個檢測到的有效法術在你的法術書中不存在時.

正確的材質將會在你施放過一次或者見到過一次該法術之後使用.

若要顯示正確的材質,請把第一個被檢查的法術名稱變更為法術ID.你可以輕鬆的做到這一點,你只需要點擊名稱編輯框中的法術,再根據之後出現的建議列表中顯示的正確的以及相對應的法術上點擊滑鼠右鍵即可.

(這裡的法術指排在首位的法術,當你的滑鼠移動到建議列表的某個法術上時,在提示資訊中可以看到更為具體的 滑鼠左右鍵插入法術ID或法術名稱的方法.)]=]
L["ICON"] = "圖示"
L["ICONALPHAPANEL_FAKEHIDDEN"] = "總是隱藏"
L["ICONALPHAPANEL_FAKEHIDDEN_DESC"] = "使該圖示一直被隱藏,但圖示依然會處理並執行音效跟文字輸出,而且仍然可以讓包含此圖示的條件或整合圖示來檢查它."
L["ICONGROUP"] = "圖示: %s (群組: %s)"
L["ICONMENU_ABSENT"] = "缺少時"
L["ICONMENU_ADDMETA"] = "添加到'整合圖示'"
L["ICONMENU_ALPHA"] = "透明度"
L["ICONMENU_ALWAYS"] = "一直顯示"
L["ICONMENU_ANCHORTO"] = "依附於 %s"
L["ICONMENU_ANCHORTO_DESC"] = [=[依附%s於%s,無論%s如何移動,%s都會跟隨它一起移動.

群組選項中有進階依附設定.]=]
L["ICONMENU_ANCHORTO_UIPARENT"] = "重設依附"
L["ICONMENU_ANCHORTO_UIPARENT_DESC"] = [=[讓%s重新依附於你的螢幕(UIParent). 它目前依附於%s.

群組選項中有進階依附設定.]=]
L["ICONMENU_APPENDCONDT"] = "添加到'圖示顯示'條件"
L["ICONMENU_BAROFFS"] = [=[此數值將會添加到計量條以便用來調整它的位移值.

一些有用的例子:
當你開始施法時防止一個增益消失的自訂指示器,或者用來指示某個法術施放所需能量的同時還剩多少時間可以中斷施法.]=]
L["ICONMENU_BINDTEXT_DESC"] = "在此編輯框中的任意文字將以動作條上顯示的按鍵綁定文字的方式顯示在圖示上.這並非設定TellMeWhen圖示的按鍵綁定!它只是一個顯示在圖示上的文字提示的視覺效果.在本群組的'群組設定'中可以變更此文字的設定."
L["ICONMENU_BOTH"] = "任意一種"
L["ICONMENU_BUFF"] = "增益"
L["ICONMENU_BUFFDEBUFF"] = "增益/減益"
L["ICONMENU_BUFFDEBUFF_DESC"] = "檢查增益或減益."
L["ICONMENU_BUFFTYPE"] = "增益或減益"
L["ICONMENU_CAST"] = "法術施放"
L["ICONMENU_CAST_DESC"] = "檢查非瞬發施法和引導法術."
L["ICONMENU_CASTS"] = "法術施放"
L["ICONMENU_CASTSHOWWHEN"] = "何時顯示法術施放"
L["ICONMENU_CHECKNEXT"] = "檢查子元(用於列表中包含整合圖示)"
L["ICONMENU_CHECKNEXT_DESC"] = [=[選中此框該圖示將檢查添加在列表中的任意整合圖示所包含的全部圖示,它可能是任何級別的檢查.

此外,該圖示不會顯示已經在另一個整合圖示顯示的任何群組/圖示ID接近1的圖示.在主選項或群組設定中可以變更更新排序.]=]
L["ICONMENU_CHECKREFRESH"] = "法術刷新偵測"
L["ICONMENU_CHECKREFRESH_DESC"] = [=[暴雪的戰鬥記錄在涉及法術刷新和恐懼(或者某些在造成一定傷害量後才會中斷的法術)存在嚴重缺陷,戰鬥記錄會認為法術在造成傷害時已經刷新,儘管事實上並非如此.

取消此選項以便停用法術刷新偵測,注意:正常的刷新也將被忽略. 

如果你檢查的遞減在造成一定傷害量後不會中斷的話建議保留此選項.]=]
L["ICONMENU_CHOOSENAME_ITEMSLOT_DESC"] = [=[輸入你想要此圖示監視的名稱/ID/裝備欄位編號. 你可以利用分號添加多個條目(名稱/ID/裝備欄位編號的任意組合).

裝備欄位編號是已裝備物品所在欄位的編號索引.即使你更換了那個裝備欄位的已裝備物品,也不會影響圖示的正常使用.

你可以|cff7fffff按住Shift再按滑鼠左鍵點選|r物品/聊天連結或者拖曳物品添加到此編輯框中.]=]
L["ICONMENU_CHOOSENAME_MULTISTATE"] = "選擇用於檢查的 名稱/ID"
L["ICONMENU_CHOOSENAME_ORBLANK"] = "或者保留空白檢查所有"
L["ICONMENU_CHOOSENAME_WPNENCH"] = "用於檢查的附魔"
L["ICONMENU_CHOOSENAME_WPNENCH_DESC"] = [=[輸入你想要此圖示監視的暫時性武器附魔的名稱. 你可以利用分號(;)添加多個條目.

|cFFFF5959重要提示|r: 附魔名稱必須使用在暫時性武器附魔激活時出現在武器的提示資訊中的那個名稱(例如:'磨利(+6傷害)', 而不是'堅固的磨刀石' ).]=]
L["ICONMENU_CLEU"] = "戰鬥事件"
L["ICONMENU_CLEU_DESC"] = [=[檢查戰鬥事件.

例如:法術被反射,未命中,瞬發施法以及死亡等等.
實際上此圖示類型可以檢查所有的戰鬥事件(包括上述的例子以及其他沒有提到的戰鬥事件).]=]
L["ICONMENU_CNDTIC"] = "條件圖示"
L["ICONMENU_CNDTIC_DESC"] = "檢查條件的狀態."
L["ICONMENU_CNDTIC_ICONMENUTOOLTIP"] = "(%d個條件)"
L["ICONMENU_CNDTSHOWWHEN"] = "當條件怎樣時顯示"
L["ICONMENU_COMPONENTICONS"] = "元件圖示&群組"
L["ICONMENU_COOLDOWNCHECK"] = "冷卻檢查"
L["ICONMENU_COOLDOWNCHECK_DESC"] = "勾選此項啟用當可用技能在冷卻中時視為不可用."
L["ICONMENU_COPYHERE"] = "複製到此"
L["ICONMENU_COUNTING"] = "倒數中"
L["ICONMENU_COUNTING_DESC"] = "當圖示的計時器在倒數時顯示圖示."
L["ICONMENU_CUSTOMTEX"] = "自訂圖示材質"
L["ICONMENU_CUSTOMTEX_DESC"] = [=[如果你要變更此圖示顯示的材質, 輸入你想使用的某個材質的法術名稱或ID. 

你可以輸入一個材質路徑,例如'Interface/Icons/spell_nature_healingtouch', 假如材質路徑為'Interface/Icons'可以只輸入'spell_nature_healingtouch'.

你也能使用放在WoW資料夾中的自訂材質(請在該欄位輸入材質的相對路徑,如:'tmw/ccc.tga'),僅支持尺寸為2的N次方(32, 64, 128,等)並且類型為.tga和.blp的材質檔案.]=]
L["ICONMENU_DEBUFF"] = "減益"
L["ICONMENU_DISPEL"] = "驅散類型"
L["ICONMENU_DONTREFRESH"] = "不刷新"
L["ICONMENU_DONTREFRESH_DESC"] = "勾選此項當效果觸發時它仍然在倒計時則不重置冷卻時間.這個功能僅適用於某些天賦,像是法師的%s."
L["ICONMENU_DR"] = "遞減"
L["ICONMENU_DRABSENT"] = "未遞減"
L["ICONMENU_DR_DESC"] = "檢查遞減程度跟遞減時間."
L["ICONMENU_DRPRESENT"] = "已遞減"
L["ICONMENU_DRS"] = "遞減"
L["ICONMENU_DURATION_MAX_DESC"] = "允許圖示顯示的最大持續時間,高於此數值圖示將被隱藏."
L["ICONMENU_DURATION_MIN_DESC"] = "顯示圖示所需的最小持續時間,低於此數值圖示將被隱藏."
L["ICONMENU_ENABLE"] = "啟用圖示"
L["ICONMENU_FOCUS"] = "專注目標"
L["ICONMENU_FOCUSTARGET"] = "專注目標的目標"
L["ICONMENU_FRIEND"] = "友好"
L["ICONMENU_GHOUL"] = "非永久食尸鬼"
L["ICONMENU_GHOUL_DESC"] = "僅用於在你沒有加 %s 這個天賦時,檢查你的食屍鬼持續時間."
L["ICONMENU_HIDEUNEQUIPPED"] = "當裝備欄缺少武器時隱藏"
L["ICONMENU_HIDEUNEQUIPPED_DESC"] = "勾選此項在檢查的武器欄沒有裝備武器時強制隱藏圖示"
L["ICONMENU_HOSTILE"] = "敵對"
L["ICONMENU_ICD"] = "內置冷卻/法術持續時間"
L["ICONMENU_ICDAURA_DESC"] = [=[如果你在以下情況開始內置冷卻請選擇此項:在你應用某個減益或者獲得某個增益以後(包括觸發),或是在某個效果造成傷害以後,或是在充能效果使你恢復法力值/怒氣/等情況以後.

你需要在 %q 編輯框中輸入那些讓你觸發內置冷卻的增益/減益的名稱/ID,或是造成傷害的法術/技能的名稱/ID,以及充能效果的名稱/ID

(請檢查你的戰鬥記錄或者利用插件來確認法術名稱/ID)]=]
L["ICONMENU_ICDBDE"] = "增益/減益/傷害/充能/召喚"
L["ICONMENU_ICD_DESC"] = [=[檢查一個觸發效果或與其類似效果的冷卻.

|cFFFF5959重要提示|r:關於如何檢查每種類型的內置冷卻請參閱在 %q 下方選項的提示資訊.]=]
L["ICONMENU_ICDTYPE"] = "何時觸發"
L["ICONMENU_ICONUNIT"] = "<圖示單位>"
L["ICONMENU_ICONUNIT_DESC"] = "插入單位變數\"%u\",它將檢查當前圖示中顯示資訊的單位."
L["ICONMENU_IGNORENOMANA"] = "忽略能量不足"
L["ICONMENU_IGNORENOMANA_DESC"] = [=[勾選此項當一個技能僅僅是因為能量不足而不可用時視該技能為可用.  

對於像是%s 或者 %s這類技能很實用.]=]
L["ICONMENU_IGNORERUNES"] = "忽略符文"
L["ICONMENU_IGNORERUNES_DESC"] = [=[勾選此項,在技能冷卻已結束,僅僅因為符文冷卻(或公共冷卻)導致技能無法施放,則視該技能為可用.

注:舉例說明一下,比如死亡騎士的符文轉化冷卻時間為30秒,但是30秒冷卻結束之後,在沒有可用的血魄符文或死亡符文的情況下會繼續顯示冷卻倒數計時,如果有勾選這個選項,則圖示不會出現繼續倒數,直接顯示為符文轉化可用.]=]
L["ICONMENU_IGNORERUNES_DESC_DISABLED"] = "\"忽略符文\"必須在\"冷卻檢查\"已勾選後才可使用."
L["ICONMENU_INVERTBARS"] = "反轉計量條"
L["ICONMENU_ITEMCOOLDOWN"] = "物品冷卻"
L["ICONMENU_ITEMCOOLDOWN_DESC"] = "檢查可使用物品的冷卻."
L["ICONMENU_LIGHTWELL"] = "光束泉"
L["ICONMENU_LIGHTWELL_DESC"] = "檢查你施放的光束泉的持續時間跟可用次數."
L["ICONMENU_MANACHECK"] = "能量檢查"
L["ICONMENU_MANACHECK_DESC"] = [=[勾選此項啟用當你法力/怒氣/符能等等不足時改變圖示顏色(或視為不可用).

注:除非特別說明,本插件中的能量一般是指法術施放所需的法力/怒氣/符能/集中值等等,並非盜賊/野德的能量值.]=]
L["ICONMENU_META"] = "整合圖示"
L["ICONMENU_META_DESC"] = [=[組合多個圖示到一個圖示.

在整合圖示中被檢查的那些圖示即使設定為%q,在可以顯示時同樣會顯示.]=]
L["ICONMENU_META_ICONMENUTOOLTIP"] = "(%d個圖示)"
L["ICONMENU_MOUSEOVER"] = "滑鼠游標目標"
L["ICONMENU_MOUSEOVERTARGET"] = "滑鼠游標目標的目標"
L["ICONMENU_MOVEHERE"] = "移動到此"
L["ICONMENU_MULTISTATECD"] = "多重狀態技能"
L["ICONMENU_MULTISTATECD_DESC"] = [=[檢查一個有多重狀態的技能.

此圖示類型應當在你要檢查像是 %s 或 %s 這些多重狀態/材質的冷卻時間時使用.]=]
L["ICONMENU_MUSHROOMS"] = "%s"
L["ICONMENU_MUSHROOMS_DESC"] = "檢查%s."
L["ICONMENU_NOTCOUNTING"] = "未倒數"
L["ICONMENU_NOTCOUNTING_DESC"] = "當圖示計時器沒在倒數時顯示圖示."
L["ICONMENU_OFFS"] = "位移"
L["ICONMENU_ONLYBAGS"] = "只在背包中存在時"
L["ICONMENU_ONLYBAGS_DESC"] = "勾選此項當物品在背包中(或者已裝備)時顯示圖示.如果啟用'已裝備的物品',此選項會被強制啟用."
L["ICONMENU_ONLYEQPPD"] = "只在已裝備時"
L["ICONMENU_ONLYEQPPD_DESC"] = "勾選這個來使圖示只在物品已裝備時顯示."
L["ICONMENU_ONLYIFCOUNTING"] = "僅在計時器作用時顯示"
L["ICONMENU_ONLYIFCOUNTING_DESC"] = "勾選此項使圖示僅在當前有一個作用中的計時器正在運行並且它的持續時間大於0時顯示."
L["ICONMENU_ONLYINTERRUPTIBLE"] = "僅可中斷"
L["ICONMENU_ONLYINTERRUPTIBLE_DESC"] = "選中此框僅顯示可中斷的施法"
L["ICONMENU_ONLYMINE"] = "僅檢查自己施放的"
L["ICONMENU_ONLYMINE_DESC"] = "勾選此項讓該圖示只顯示你施放的增益或減益"
L["ICONMENU_ONLYSEEN"] = "僅顯示施放過的法術"
L["ICONMENU_ONLYSEEN_DESC"] = "選擇此項可以讓圖示只顯示某單位至少施放過一次的法術冷卻.如果你想在同一個圖示中檢查來自不同職業的法術那麼應該勾上它."
L["ICONMENU_PETTARGET"] = "寵物的目標"
L["ICONMENU_PRESENT"] = "存在時"
L["ICONMENU_RANGECHECK"] = "距離檢查"
L["ICONMENU_RANGECHECK_DESC"] = "勾選此項啟用當你超出範圍時改變圖示顏色(或視為不可用)."
L["ICONMENU_REACT"] = "單位反映"
L["ICONMENU_REACTIVE"] = "觸發性技能"
L["ICONMENU_REACTIVE_DESC"] = [=[檢查觸發性技能的可用情況.

觸發性的技能指類似%s, %s 和 %s 這些只能在某種特定條件下使用的技能.]=]
L["ICONMENU_RUNES"] = "符文冷卻"
L["ICONMENU_RUNES_DESC"] = "檢查符文冷卻."
L["ICONMENU_SHOWCBAR_DESC"] = "將會在跟圖示重疊的下半部份顯示剩餘的冷卻/持續時間的計量條(或是在'反轉計量條'啟用的情況下顯示已用的時間)"
L["ICONMENU_SHOWPBAR_DESC"] = [=[將會在跟圖示重疊的上半部份方顯示你施放此法術還需多少能量的能量條(或是在'反轉計量條'啟用的情況下顯示當前的能量).

註:這個能量可以是盜賊的能量,戰士的怒氣,獵人的集中值,其他職業的法力值等等.]=]
L["ICONMENU_SHOWSTACKS"] = "顯示堆疊數量"
L["ICONMENU_SHOWSTACKS_DESC"] = "勾選此項顯示物品的堆疊數量並啟用堆疊數量條件."
L["ICONMENU_SHOWTIMER"] = "顯示計時器"
L["ICONMENU_SHOWTIMER_DESC"] = "勾選此項讓該圖示的冷卻時鐘動畫在可用時顯示.(注:此選項僅影響圖示的時鐘動畫,就是技能冷卻時的那個轉圈效果,不包括數字在內哦.)"
L["ICONMENU_SHOWTIMERTEXT"] = "顯示計時器數字"
L["ICONMENU_SHOWTIMERTEXT_DESC"] = [=[勾選此項在圖示上顯示剩餘冷卻時間或持續時間的數字.

需要已安裝OmniCC或者其他冷卻計時插件才可使用.(注:某些冷卻計時插件可能不支持此選項)]=]
L["ICONMENU_SHOWTTTEXT"] = "顯示變數文字"
L["ICONMENU_SHOWTTTEXT_DESC"] = [=[勾選此項在堆疊數量文字的位置上顯示從法術效果的提示資訊中找到的第一個變數(數字).比如用此監視傷害護盾的剩餘吸收量等等.

數字是由暴雪API所提供,跟你在法術效果的提示資訊中看到的數字可能會不同(像是伺服器已經在線修正,客戶端依然顯示錯誤的數字這種情況),在大多數情況下都能顯示正確的數字.]=]
L["ICONMENU_SHOWWHEN"] = "何時顯示圖示"
L["ICONMENU_SORTASC"] = "持續時間升序"
L["ICONMENU_SORTASC_DESC"] = "勾選此項優先顯示持續時間最低的法術."
L["ICONMENU_SORTASC_META_DESC"] = "勾選此項優先顯示持續時間最低的圖示."
L["ICONMENU_SORTDESC"] = "持續時間降序"
L["ICONMENU_SORTDESC_DESC"] = "勾選此項優先顯示持續時間最高的法術."
L["ICONMENU_SORTDESC_META_DESC"] = "勾選此項優先顯示持續時間最高的圖示."
L["ICONMENU_SPELLCAST_COMPLETE"] = "施法結束/瞬發"
L["ICONMENU_SPELLCAST_COMPLETE_DESC"] = [=[選擇此項如果內置冷卻需要在你施法結束後才開始,或是在你施放一個瞬發法術後開始.

你需要在 %q 編輯框中輸入那個觸發內置冷卻的法術名稱或ID.]=]
L["ICONMENU_SPELLCAST_START"] = "施法開始"
L["ICONMENU_SPELLCAST_START_DESC"] = [=[選擇此項如果內置冷卻是在開始施法後就觸發.

你需要在 %q 編輯框中輸入那個觸發內置冷卻的法術名稱或ID.]=]
L["ICONMENU_SPELLCOOLDOWN"] = "法術冷卻"
L["ICONMENU_SPELLCOOLDOWN_DESC"] = "檢查在你法術書中那些法術的冷卻."
L["ICONMENU_SPLIT"] = "拆分成新的群組"
L["ICONMENU_SPLIT_DESC"] = "創建一個新的群組並將這個圖示移動到上面. 原群組中的許多設定會保留到新的群組."
L["ICONMENU_STACKS_MAX_DESC"] = "允許圖示顯示的最大堆疊數量,高於此數值圖示將被隱藏."
L["ICONMENU_STACKS_MIN_DESC"] = "顯示圖示所需的最低堆疊數量,低於此數值圖示將被隱藏."
L["ICONMENU_STEALABLE"] = "僅可法術竊取"
L["ICONMENU_STEALABLE_DESC"] = "勾選此項僅顯示能被\"法術竊取\"的增益,非常適合跟驅散類型中的魔法搭配使用."
L["ICONMENU_SWAPWITH"] = "交換位置"
L["ICONMENU_TARGETTARGET"] = "目標的目標"
L["ICONMENU_TOTEM"] = "圖騰"
L["ICONMENU_TOTEM_DESC"] = "檢查你的圖騰."
L["ICONMENU_TYPE"] = "圖示類型"
L["ICONMENU_UNITCOOLDOWN"] = "單位冷卻"
L["ICONMENU_UNITCOOLDOWN_DESC"] = [=[檢查其他單位的冷卻.

檢查 %s 可以使用 %q 作為名稱.

注:玩家也可以作為被檢查的單位.]=]
L["ICONMENU_UNIT_DESC"] = [=[在此框輸入需要監視的單位.此單位能從下拉列表插入到右邊,或者你是一位高端玩家可以自行輸入需要監視的單位.
多個單位請用分號分隔開(;)
可使用標準單位(像是player,target,mouseover等等可用於巨集的單位),或者是友好玩家的名字(像是%s,Cybeloras,小兔是豬,阿光是豬等.)

需要更多關於單位的資訊,請訪問http://www.wowpedia.org/UnitId]=]
L["ICONMENU_UNITS"] = "單位"
L["ICONMENU_UNITSTOWATCH"] = "監視的單位"
L["ICONMENU_UNUSABLE"] = "不可用"
L["ICONMENU_USABLE"] = "可用"
L["ICONMENU_USEACTIVATIONOVERLAY"] = "檢查技能激活邊框"
L["ICONMENU_USEACTIVATIONOVERLAY_DESC"] = "檢查系統預設提示技能可用時的黃色發光邊框."
L["ICONMENU_VEHICLE"] = "載具"
L["ICONMENU_WPNENCHANT"] = "暫時性武器附魔"
L["ICONMENU_WPNENCHANT_DESC"] = "檢查暫時性的武器附魔"
L["ICONMENU_WPNENCHANTTYPE"] = "監視的武器欄"
L["ICONTOCHECK"] = "要檢查的圖示"
L["ICON_TOOLTIP1"] = "TellMeWhen"
L["ICON_TOOLTIP2NEW"] = [=[|cff7fffff點擊滑鼠右鍵|r進入圖示設定.
|cff7fffff點擊滑鼠右鍵並拖曳|r 複製/移動 到另一個圖示.
|cff7fffff拖曳|r法術或物品到圖示來快速設定.]=]
L["ICON_TOOLTIP2NEWSHORT"] = "|cff7fffff點擊滑鼠右鍵|r進入圖示設定."
L["ImmuneToMagicCC"] = "免疫法術控制"
L["ImmuneToStun"] = "免疫擊暈"
L["IMPORTERROR_FAILEDPARSE"] = "處理字串時發生錯誤.請確保你複製的字串是完整的."
L["IMPORT_EXPORT"] = "匯入/匯出/還原"
L["IMPORT_EXPORT_BUTTON_DESC"] = "點擊此下拉式選單來匯出或匯入圖示/群組/設定檔."
L["IMPORT_EXPORT_DESC"] = [=[點擊這個編輯框右側的下拉式選單的箭頭來匯出圖示,群組或設定檔.

匯出/匯入字串或發送給其他玩家需要使用這個編輯框. 具體的使用方法請看下拉式選單上的提示資訊.]=]
L["IMPORT_EXPORT_DESC_INLINE"] = "匯出設定檔/群組/圖示到字串/其他玩家/其他設定檔/個人設定備份. 或從字串/其他玩家/其他設定檔/個人設定備份匯入到設定檔/群組/圖示."
L["IMPORT_FROMBACKUP"] = "來自備份"
L["IMPORT_FROMBACKUP_DESC"] = "用此選單可以還原設定到: %s "
L["IMPORT_FROMBACKUP_WARNING"] = "備份設定: %s"
L["IMPORT_FROMCOMM"] = "來自玩家"
L["IMPORT_FROMCOMM_DESC"] = "如果另一個TellMeWhen使用者給你發送了組態數據,可以從這個子選單匯入那些數據."
L["IMPORT_FROMLOCAL"] = "來自設定檔"
L["IMPORT_FROMSTRING"] = "來自字串"
L["IMPORT_FROMSTRING_DESC"] = [=[字串允許你在遊戲以外的地方轉存TellMeWhen組態數據.(包括用來給其他人分享自己的設定,或者匯入其他人分享的設定,也可用來備份你自己的設定.)

從字串匯入的方法: 當複製TMW字串到你的剪貼簿後,在'匯出/匯入'編輯框中按下CTRL+V貼上字串,然後返回瀏覽這個子選單.]=]
L["IMPORT_HEADING"] = "匯入"
L["IMPORT_PROFILE"] = "複製設定檔"
L["IMPORT_PROFILE_NEW"] = "|cff59ff59創建|r新的設定檔"
L["IMPORT_PROFILE_OVERWRITE"] = "|cFFFF5959覆寫|r %s"
L["Incapacitated"] = "癱瘓"
L["IncreasedAP"] = "攻擊強度提高"
L["IncreasedCrit"] = "致命等級提高"
L["IncreasedDamage"] = "造成的傷害提高"
L["IncreasedPhysHaste"] = "攻擊加速提高"
L["IncreasedSpellHaste"] = "施法加速提高"
L["IncreasedSPsix"] = "法術能量提高 (6%)"
L["IncreasedSPten"] = "法術能量提高 (10%)"
L["IncreasedStats"] = "屬性提高"
L["INRANGE"] = "在範圍內"
L["ITEMCOOLDOWN"] = "物品冷卻"
L["ITEMEQUIPPED"] = "已裝備的物品"
L["ITEMINBAGS"] = "物品計數(包含使用次數)"
L["ITEMTOCHECK"] = "要檢查的物品"
L["ITEMTOCOMP1"] = "進行比較的第一個物品"
L["ITEMTOCOMP2"] = "進行比較的第二個物品"
L["LDB_TOOLTIP1"] = "|cff7fffff左鍵點擊|r 鎖定圖示組"
L["LDB_TOOLTIP2"] = "|cff7fffff右鍵點擊|r 顯示TWM選項"
L["LEFT"] = "左"
L["LOADERROR"] = "TellMeWhen設定插件無法載入:"
L["LOADINGOPT"] = "正在載入TellMeWhen設定插件."
L["LOCKED"] = "已鎖定"
L["LUACONDITION"] = "Lua(進階)"
L["LUACONDITION_DESC"] = [=[此條件類型允許你使用Lua語言來評估一個條件的狀態.

輸入不能為'if..then'敘述,也不能為function closure.它可以是一個普通的敘述評估,例如:'a and b or c'.如果需要複雜功能,可使用函數調用,例如:'CheckStuff()',這是一個外部函數.

如果需要更多的幫助(但不是關於如何去寫Lua代碼),到CurseForge提交一份回報單.關於如何編寫Lua语言,請自行去互聯網搜尋資料.

PS:Lua語言部份就不翻譯了,翻譯了反而覺得怪怪的.]=]
L["MACROCONDITION"] = "巨集條件式"
L["MACROCONDITION_DESC"] = [=[此條件將會評估巨集的條件式,在巨集條件式成立時則此條件通過.
所有的巨集條件式都能在前面加上"no"進行逆向檢查.
例子:
"[nomodifier:alt]" - 沒有按住ALT鍵
"[@target, help][mod:ctrl]" - 目標是友好的或者按住CTRL鍵
"[@focus, harm, nomod:shift]" - 專注目標是敵對的同時沒有按住SHIFT鍵

需要更多的幫助,請訪問http://www.wowpedia.org/Making_a_macro]=]
L["MACROCONDITION_EB_DESC"] = "使用單一條件時方括弧是可選的,使用多個條件式時方括弧是必須的.(說明:方括弧->'[ ]')"
L["MACROTOEVAL"] = "輸入需要評估的巨集條件式(允許多個)"
L["Magic"] = "魔法"
L["MAIN"] = "主頁面"
L["!!Main Addon Description"] = "為冷卻、增益/減益及其他各個方面提供視覺、聽覺以及文字上的通知。"
L["MAINASSIST"] = "主助攻"
L["MAINTANK"] = "主坦克"
L["MAKENEWGROUP"] = "|cff59ff59創建|r新的群組"
L["ManaRegen"] = "法力回復提高"
L["MELEECRIT"] = "近戰致命"
L["MELEEHASTE"] = "近戰加速"
L["MESSAGERECIEVE"] = "%s給你發送了一些TellMeWhen的數據! 你可以利用圖示編輯器中的 %q 下拉式選單匯入這些數據到TellMeWhen."
L["MESSAGERECIEVE_SHORT"] = "%s給你發送了一些TellMeWhen數據!"
L["METAPANEL_DOWN"] = "向下移動"
L["METAPANEL_REMOVE"] = "移除此圖示"
L["METAPANEL_UP"] = "向上移動"
L["MiscHelpfulBuffs"] = "雜項-其他增益"
L["MOON"] = "月蝕"
L["MOUSEOVER_TOKEN_NOT_FOUND"] = "無滑鼠游標目標"
L["MP5"] = "%d 5秒回藍"
L["MUSHROOM"] = "蘑菇%d"
L["MUSHROOMS"] = "檢查蘑菇"
L["NEWVERSION"] = "TellMeWhen可升級新版本(%s)"
L["NONE"] = "不包含任何一個"
L["normal"] = "普通"
L["NOTINRANGE"] = "不在範圍內"
L["NUMAURAS"] = "數量"
L["NUMAURAS_DESC"] = [=[此條件僅檢查一個作用中的法術效果的數量 - 不要與法術效果的堆疊數量混淆.
像是你的兩個相同的武器附魔特效同時觸發並且在作用中.
請有節制的使用它,此過程需要消耗不少CPU運算來計算數量.]=]
L["ONLYCHECKMINE"] = "僅檢查自己施放的"
L["ONLYCHECKMINE_DESC"] = "勾選此項讓此條件只檢查自己施放的增益/減益."
L["OUTLINE_MONOCHORME"] = "單色"
L["OUTLINE_NO"] = "無描邊"
L["OUTLINE_THICK"] = "粗描邊"
L["OUTLINE_THIN"] = "細描邊"
L["OVERWRITEGROUP"] = "|cFFFF5959覆寫|r群組:%s"
L["PARENTHESIS_TYPE_("] = "左括弧'('"
L["PARENTHESIS_TYPE_)"] = "右括弧')'"
L["PARENTHESIS_WARNING1"] = [=[左右括弧的数量不相等!

缺少%d個%s.]=]
L["PARENTHESIS_WARNING2"] = [=[一些右括弧缺少左括弧.

缺少%d個左括弧'('.]=]
L["PET_TYPE_CUNNING"] = "靈巧"
L["PET_TYPE_FEROCITY"] = "兇暴"
L["PET_TYPE_TENACITY"] = "堅毅"
L["PhysicalDmgTaken"] = "受到的物理傷害提高"
L["PLAYER_DESC"] = "(你)"
L["Poison"] = "毒"
L["PRESENCE"] = "領域"
L["PushbackResistance"] = "施法打退抵抗提高"
L["PvPSpells"] = "PVP控制技能以及其他"
L["RaidWarningFrame"] = "團隊警告框體"
L["RANGEDCRIT"] = "物理遠程致命"
L["RANGEDHASTE"] = "物理遠程加速"
L["rare"] = "稀有"
L["rareelite"] = "稀有精英"
L["REACTIVECNDT_DESC"] = "此條件僅檢查技能的觸發/可用情況.並非它的冷卻."
L["REDO_ICON"] = "重作"
L["REDO_ICON_DESC"] = "重作最近一次圖示設定的復原動作."
L["ReducedArmor"] = "護甲值降低"
L["ReducedAttackSpeed"] = "攻擊速度降低"
L["ReducedCastingSpeed"] = "施法速度降低"
L["ReducedHealing"] = "治療效果降低"
L["ReducedPhysicalDone"] = "造成的物理傷害降低"
L["RESET_ICON"] = "重設"
L["Resistances"] = "法術抗性提高"
L["RESIZE"] = "改變大小"
L["RESIZE_TOOLTIP"] = "|cff7fffff點擊並拖曳|r以改變大小"
L["RIGHT"] = "右"
L["Rooted"] = "纏繞"
L["RUNES"] = "要檢查的符文"
L["RUNSPEED"] = "單位奔跑速度"
L["SENDSUCCESSFUL"] = "發送完成"
L["SHAPESHIFT"] = "變身"
L["Shatterable"] = "冰凍"
L["Silenced"] = "沉默"
L["Slowed"] = "緩速"
L["SORTBY"] = "排序方式"
L["SORTBYNONE"] = "正常排序"
L["SORTBYNONE_DESC"] = [=[如果選中,法術將按照"%s"編輯框中的輸入順序來檢查並排序.
如果是一個增益/減益圖示,只要出現在單位框體上的法術效果數字沒有超出效率閥值設定的界限,就會被檢查並排序.

(P.S.如果看不懂請無視這段說明,只要知道它是按照你輸入的順序來排序就好.)]=]
L["SORTBYNONE_META_DESC"] = "如果勾選,被檢查的圖示將使用上面的列表所設定的順序來排序."
L["SOUND_CUSTOM"] = "自訂音效檔案"
L["SOUND_CUSTOM_DESC"] = [=[輸入需要用來播放的自訂音效檔案的路徑.
下面是一些例子,其中"File"是你的音效檔案名,"ext"是副檔名(只能用ogg或者mp3格式)

-"CustomSounds\File.ext": 一個檔案放在WOW根目錄一個命名為"CustomSound"的新建资料夾中(此資料夾同WOW.exe,Interface和WTF在同一個位置)
-"Interface\AddOns\file.ext": 插件资料夾中的某一檔案
-"file.ext":  WOW主目錄的某個檔案

注意:魔獸世界必須重開才能正常使用那些在它啟動時還不存在的檔案.]=]
L["SOUNDERROR1"] = "檔案必須有一個副檔名!"
L["SOUNDERROR2"] = "魔獸世界4.0+不支援自訂WAV檔案"
L["SOUNDERROR3"] = "只支援OGG和MP3檔案!"
L["SOUND_EVENT_DISABLEDFORTYPE"] = "不可用"
L["SOUND_EVENT_DISABLEDFORTYPE_DESC"] = "此事件不可用於圖示類型 %s"
L["SOUND_EVENT_GLOBALDESC"] = "在此列表中的事件是按照從上到下的順序來檢查.如果一個事件觸發並且播放了音效,在它之後的事件不會再播放任何音效."
L["SOUND_EVENT_ONALPHADEC"] = "在透明度百分比減少時"
L["SOUND_EVENT_ONALPHADEC_DESC"] = [=[當圖示的不透明度降低時觸發此事件.

注意:不透明度在降低後如果為0%不會觸發此事件(如果有需要請使用"在隱藏時").]=]
L["SOUND_EVENT_ONALPHAINC"] = "在透明度百分比增加時"
L["SOUND_EVENT_ONALPHAINC_DESC"] = [=[當圖示的不透明度提高時觸發此事件.

注意:不透明度在提高前如果為0%不會觸發此事件(如果有需要請使用"在顯示時").]=]
L["SOUND_EVENT_ONCLEU"] = "在戰鬥事件發生時"
L["SOUND_EVENT_ONCLEU_DESC"] = "此事件在需要圖示處理的戰鬥事件發生時觸發."
L["SOUND_EVENT_ONDURATION"] = "在持續時間改變時"
L["SOUND_EVENT_ONDURATION_DESC"] = [=[此事件在圖示計時器的持續時間改變時觸發.

因為在計時器運行時每次圖示更新都會觸發該事件,你必須設定一個條件,使事件僅在條件的狀態改變時觸發.]=]
L["SOUND_EVENT_ONFINISH"] = "在結束時"
L["SOUND_EVENT_ONFINISH_DESC"] = "當冷卻完成,增益/減益消失,等類似的情況下觸發此事件. "
L["SOUND_EVENT_ONHIDE"] = "在隱藏時"
L["SOUND_EVENT_ONHIDE_DESC"] = "當圖示隱藏時觸發此事件(即使 %q 已勾選)."
L["SOUND_EVENT_ONICONHIDE"] = "在其他圖示隱藏時"
L["SOUND_EVENT_ONICONHIDE_DESC"] = [=[此事件會在另一個圖示隱藏時觸發(不是當前你在設定的這個圖示哦,是另一個).

使用下面的事件設定選項來配置那個被檢查的圖示.]=]
L["SOUND_EVENT_ONICONSHOW"] = "在其他圖示顯示時"
L["SOUND_EVENT_ONICONSHOW_DESC"] = [=[此事件會在另一個圖示顯示時觸發(不是當前你在設定的這個圖示哦,是另一個).

使用下面的事件設定選項來配置那個被檢查的圖示.]=]
L["SOUND_EVENT_ONSHOW"] = "在顯示時"
L["SOUND_EVENT_ONSHOW_DESC"] = "當圖示顯示時觸發此事件(即使 %q 已勾選)."
L["SOUND_EVENT_ONSPELL"] = "在法術改變時"
L["SOUND_EVENT_ONSPELL_DESC"] = "當圖示顯示資訊中的法術/物品/等改變時觸發此事件."
L["SOUND_EVENT_ONSTACK"] = "在堆疊數量改變時"
L["SOUND_EVENT_ONSTACK_DESC"] = [=[此事件在圖示所檢查的法術/物品等的堆疊數量發生改變時觸發.

包括逐漸降低的%s圖示.]=]
L["SOUND_EVENT_ONSTART"] = "在開始時"
L["SOUND_EVENT_ONSTART_DESC"] = "當冷卻開始,增益/減益開始作用,等類似的情況下觸發此事件."
L["SOUND_EVENT_ONUNIT"] = "在單位改變時"
L["SOUND_EVENT_ONUNIT_DESC"] = "當圖示顯示資訊中的單位改變時觸發此事件."
L["SOUND_SOUNDTOPLAY"] = "要播放的音效"
L["SOUND_TAB"] = "音效"
L["SPEED"] = "單位速度"
L["SPEED_DESC"] = [=[這是指單位當前的移動速度,如果單位不移動則為0.
如果您要檢查單位的最高奔跑速度,可以使用'單位奔跑速度'條件來代替.]=]
L["SPELLCOOLDOWN"] = "法術冷卻"
L["SPELLCRIT"] = "法術致命"
L["SpellCritTaken"] = "受到法術致命一擊幾率提高"
L["SpellDamageTaken"] = "受到的法術傷害提高"
L["SPELLHASTE"] = "施法加速"
L["SPELLREACTIVITY"] = "法術反應(激活/觸發/可用)"
L["SPELLTOCHECK"] = "要檢查的法術"
L["SPELLTOCOMP1"] = "進行比較的第一個法術"
L["SPELLTOCOMP2"] = "進行比較的第二個法術"
L["STACKS"] = "堆疊數量"
L["STANCE"] = "姿態"
L["STRATA_BACKGROUND"] = "背景(最低)"
L["STRATA_DIALOG"] = "對話框"
L["STRATA_FULLSCREEN"] = "全螢幕"
L["STRATA_FULLSCREEN_DIALOG"] = "全螢幕對話框"
L["STRATA_HIGH"] = "高"
L["STRATA_LOW"] = "低"
L["STRATA_MEDIUM"] = "中"
L["STRATA_TOOLTIP"] = "提示資訊(最高)"
L["Stunned"] = "擊暈"
L["SUG_ATBEGINING"] = "提示與建議:匹配開頭"
L["SUG_ATBEGINING_DESC"] = [=[如果勾選,提示與建議列表將只顯示名稱開頭位置與正在輸入的文字完全相同的法術,否則將顯示那些在任意位置含有正在輸入文字的法術.

舉例說明:比如你輸入了一個'言'字,在勾選的情況下,提示與建議列表只會顯示'言'字開頭的法術,如果沒有勾選,它會顯示像是'暗言術:痛','真言術:盾'這樣的法術.]=]
L["SUG_BUFFEQUIVS"] = "同類型增益"
L["SUG_CLASSSPELLS"] = "已知的玩家/寵物法術"
L["SUG_DEBUFFEQUIVS"] = "同類型減益"
L["SUG_DISPELTYPES"] = "驅散類型"
L["SUG_FINISHHIM"] = "馬上結束快取"
L["SUG_FINISHHIM_DESC"] = "|cff7fffff點擊|r快速完成該快取/篩選過程.友情提示:您的電腦可能會因此停格幾秒鐘的時間."
L["SUGGESTIONS"] = "提示與建議:"
L["SUG_INSERT_ANY"] = "|cff7fffff點擊滑鼠|r"
L["SUG_INSERTEQUIV"] = "%s插入同類型條目"
L["SUG_INSERTID"] = "%s插入編號(ID)"
L["SUG_INSERTITEMSLOT"] = "%s插入物品對應的裝備欄位編號"
L["SUG_INSERT_LEFT"] = "|cff7fffff點擊滑鼠左鍵|r"
L["SUG_INSERTNAME"] = "%s插入名稱"
L["SUG_INSERT_RIGHT"] = "|cff7fffff點擊滑鼠右鍵|r"
L["SUG_INSERT_TAB"] = "或著按|cff7fffffTab|r鍵"
L["SUG_INSERTTEXTSUB"] = "%s插入單位變數"
L["SUG_MATCH_WPNENCH_ENCH"] = "(.*)"
L["SUG_MISC"] = "雜項"
L["SUG_MSCDONBARS"] = "有效的多重狀態冷卻"
L["SUG_NPCAURAS"] = "已知NPC的增益/減益"
L["SUG_OTHEREQUIVS"] = "其他同類型"
L["SUG_PATTERNMATCH_FISHINGLURE"] = "魚餌%(%+%d+釣魚技能%)"
L["SUG_PATTERNMATCH_SHARPENINGSTONE"] = "磨利%(%+%d+傷害%)"
L["SUG_PATTERNMATCH_WEIGHTSTONE"] = "增重%(%+%d+傷害%)"
L["SUG_PLAYERAURAS"] = "已知玩家/寵物的增益/減益"
L["SUG_PLAYERSPELLS"] = "你的法術"
L["SUG_SUBSTITUTION_d"] = "剩餘持續時間"
L["SUG_SUBSTITUTION_d_DESC"] = "圖示計時器剩餘的持續時間"
L["SUG_SUBSTITUTION_e"] = "事件目標單位"
L["SUG_SUBSTITUTION_e_DESC"] = "在圖示最近一次處理的戰鬥事件中有接收行為的單位."
L["SUG_SUBSTITUTION_f"] = "專注目標的名字"
L["SUG_SUBSTITUTION_f_DESC"] = "你當前的專注目標的名字"
L["SUG_SUBSTITUTION_k"] = "當前堆疊數量文字"
L["SUG_SUBSTITUTION_k_DESC"] = "圖示堆疊數量文字當前所顯示的任何內容"
L["SUG_SUBSTITUTION_m"] = "滑鼠游標目標的名字"
L["SUG_SUBSTITUTION_m_DESC"] = "你當前滑鼠游標指向的單位的名字"
L["SUG_SUBSTITUTION_o"] = "事件來源單位"
L["SUG_SUBSTITUTION_o_DESC"] = "在圖示最近一次處理的戰鬥事件中有發起行為的單位."
L["SUG_SUBSTITUTION_p"] = "上一個單位"
L["SUG_SUBSTITUTION_p_DESC"] = "上一個被檢查的單位的名字"
L["SUG_SUBSTITUTION_s"] = "當前法術/物品/等"
L["SUG_SUBSTITUTION_s_DESC"] = "當前被檢查的法術/物品/等的名字"
L["SUG_SUBSTITUTION_t"] = "目標的名字"
L["SUG_SUBSTITUTION_t_DESC"] = "你當前所選的目標的名字"
L["SUG_SUBSTITUTION_u"] = "當前單位"
L["SUG_SUBSTITUTION_u_DESC"] = "圖示當前所檢查的單位的名字"
L["SUG_SUBSTITUTION_x"] = "額外法術"
L["SUG_SUBSTITUTION_x_DESC"] = "在戰鬥事件中像是驅散,中斷以及效果被破壞時,會記錄造成此事件的那些法術的額外數據. 此變數可以用來代替戰鬥事件中的那些法術."
L["SUG_TOOLTIPTITLE"] = [=[當你輸入時,TellMeWhen將會在快取中查找並提示你最有可能輸入的法術.

法術按照以下列表分類跟著色.
注意:在記錄到相應的數據之前或是在你沒有登入过其他職業的情況下不會把那些法術放入"已知"開頭的分類中.

點擊一個條目將其插入到編輯框.

]=]
L["SUG_TOOLTIPTITLE_TEXTSUBS"] = [=[下列的單位變數可以使用在輸出顯示的文字內容中.變數將會被替換成與其相應的內容後再輸出顯示.

點擊一個條目將其插入到編輯框中.]=]
L["SUN"] = "日蝕"
L["TANK"] = "坦克"
L["TEXTLAYOUTS_BLANK"] = "(空白)" -- Needs review
L["TEXTLAYOUTS_DEFAULTS_STACKS"] = "堆疊數量" -- Needs review
L["TEXTLAYOUTS_STRING_COPYMENU"] = "複製"
L["Tier11Interrupts"] = "T11副本可中斷的施法"
L["Tier12Interrupts"] = "T12副本可中斷法術"
L["TOOLTIPSCAN"] = "法術效果變數"
L["TOOLTIPSCAN_DESC"] = "此條件類型允許你檢查某一單位的某個法術效果提示資訊上的第一個變數(數字). 數字是由暴雪API所提供,跟你在法術效果的提示資訊中看到的數字可能會不同(像是伺服器已經在線修正,客戶端依然顯示錯誤的數字這種情況),同時也不保證一定能夠從法術效果取得一個數字,不過在大多數實際情況下都能檢查到正確的數字."
L["TOP"] = "上"
L["TOPLEFT"] = "左上"
L["TOPRIGHT"] = "右上"
L["TOTEMS"] = "檢查圖騰"
L["TRUE"] = "是"
L["UIPANEL_ADDGROUP"] = "+ 新增群組 +"
L["UIPANEL_ADDGROUP_DESC"] = "新群組將指定下一個可用的群組ID"
L["UIPANEL_ALLRESET"] = "全部重設"
L["UIPANEL_BARIGNOREGCD"] = "計量條忽略公共冷卻"
L["UIPANEL_BARIGNOREGCD_DESC"] = "如果選中,冷卻條在公共冷卻時不改變值."
L["UIPANEL_BARTEXTURE"] = "計量條材質"
L["UIPANEL_CLOCKIGNOREGCD"] = "計時器忽略公共冷卻"
L["UIPANEL_CLOCKIGNOREGCD_DESC"] = "如果選中,計時器和冷卻時鐘不會從公共冷卻觸發."
L["UIPANEL_COLORS"] = "顏色"
L["UIPANEL_COLORS_DESC"] = "基於圖示的屬性來控制如何著色以及使用的顏色的相關設定."
L["UIPANEL_COLUMNS"] = "列"
L["UIPANEL_DELGROUP"] = "刪除此群組"
L["UIPANEL_DELGROUP_DESC"] = [=[在此群組之後的群組ID將會上升1.
同時對ID上升群組的圖示有檢查行為的所有圖示的設定也將自動更新.

按住|cff7fffffCtrl|r繞過確認.]=]
L["UIPANEL_DRAWEDGE"] = "高亮計時器指針"
L["UIPANEL_DRAWEDGE_DESC"] = "高亮冷卻計時器指針(時鐘動畫)來突出顯示效果"
L["UIPANEL_EFFTHRESHOLD"] = "增益效率閥值"
L["UIPANEL_EFFTHRESHOLD_DESC"] = [=[輸入增益/減益的最小時間以便在它們有很高的數值時切換到更有效的檢查模式. 注意:一旦效果的數值超出所選擇的數字的限定,數值較大的效果會優先顯示,而不是按照設定的優先級順序.
]=]
L["UIPANEL_ENABLEGROUP"] = "啟用此群組"
L["UIPANEL_FONT_Bind"] = "綁定/標籤文字"
L["UIPANEL_FONT_Bind_DESC"] = "在圖示中顯示的綁定/標籤文字的相關設定."
L["UIPANEL_FONT_CONSTRAINWIDTH"] = "限制寬度"
L["UIPANEL_FONT_CONSTRAINWIDTH_DESC"] = [=[勾選此項在位置恰當的情況下文字寬度會強制跟圖示寬度進行匹配.
取消勾選將允許文字延升寬度大於圖示.]=]
L["UIPANEL_FONT_Count"] = "堆疊數量文字"
L["UIPANEL_FONT_Count_DESC"] = "在圖示中顯示的堆疊文字的相關設定."
L["UIPANEL_FONT_DESC"] = "選擇圖示堆疊數量文字的字型"
L["UIPANEL_FONTFACE"] = "字型"
L["UIPANEL_FONT_OUTLINE"] = "文字描邊"
L["UIPANEL_FONT_OUTLINE_DESC"] = "設定圖示堆疊數量文字的描邊樣式."
L["UIPANEL_FONT_SIZE"] = "字體大小"
L["UIPANEL_FONT_SIZE_DESC"] = "變更圖示堆疊數量文字的字體大小.如果已使用Masque並且所設定的皮膚的字體大小已定義將忽略此設定值."
L["UIPANEL_FONT_XOFFS"] = "X位移"
L["UIPANEL_FONT_YOFFS"] = "Y位移"
L["UIPANEL_GLYPH"] = "雕紋" -- Needs review
L["UIPANEL_GROUPNAME"] = "重命名群組"
L["UIPANEL_GROUPRESET"] = "重設位置"
L["UIPANEL_GROUPS"] = "群組"
L["UIPANEL_GROUPS_DESC"] = "在此設定檔中的各個群組的相關設定."
L["UIPANEL_GROUPSORT"] = "圖示排列"
L["UIPANEL_GROUPSORT_alpha"] = "不透明度(無視%s)"
L["UIPANEL_GROUPSORT_alpha_DESC"] = "群組將根據圖示的不透明度來排序,無論圖示是否被 %s 設定所隱藏."
L["UIPANEL_GROUPSORT_DESC"] = [=[基於群組所有圖示的屬性並對它們的位置進行排序的相關設定.

譯者注:因為是新功能,稍微講解一下.
比如在某個群組中有3個圖示[圖示1(DOT-1),圖示2(DOT-2),圖示3(DOT-3)],你可以設定一個優先級使整個群組的圖示按照剩餘持續時間從低到高排序,假如3個DOT的持續時間情況為

|cff7fffffDOT-3<DOT-1<DOT-2|r,則DOT-3會顯示到圖示1的位置,DOT-1顯示到圖示2的位置,DOT-2顯示到圖示3的位置.

更具體的情況請自行設定並測試,遇到Bug請去Curse提交,謝謝.]=]
L["UIPANEL_GROUPSORT_duration"] = "持續時間"
L["UIPANEL_GROUPSORT_duration_DESC"] = "群組將根據圖示剩餘的持續時間來排序."
L["UIPANEL_GROUPSORT_id"] = "圖示ID"
L["UIPANEL_GROUPSORT_id_DESC"] = "群組將根據圖示ID數字來排序."
L["UIPANEL_GROUPSORT_METHODDISABLED_DESC"] = "這個排序方法已經被停用,因為上面使用的是根據圖示ID進行排序,所選方法永遠不會被執行和排序."
L["UIPANEL_GROUPSORT_METHODNAME"] = "圖示排序優先級%d"
L["UIPANEL_GROUPSORT_METHODNAME_DESC"] = "在一個群組的圖示位置進行排序時,這個將作為優先級%d來使用."
L["UIPANEL_GROUPSORT_shown"] = "顯示(無視%s)"
L["UIPANEL_GROUPSORT_shown_DESC"] = "群組將根據圖示是否顯示來排序,無論圖示是否被 %s 設定所隱藏."
L["UIPANEL_GROUPSORT_SORTASCENDING"] = "低"
L["UIPANEL_GROUPSORT_SORTASCENDING_DESC"] = "勾選此項將根據所選屬性的數值從低到高來排序."
L["UIPANEL_GROUPSORT_SORTDESCENDING"] = "高"
L["UIPANEL_GROUPSORT_SORTDESCENDING_DESC"] = "勾選此項將根據所選屬性的數值從高到低來排序."
L["UIPANEL_GROUPSORT_stacks"] = "堆疊數量"
L["UIPANEL_GROUPSORT_stacks_DESC"] = "群組將根據每個圖示的堆疊數量來排序."
L["UIPANEL_GROUPSORT_visiblealpha"] = "不透明度(遵循%s)"
L["UIPANEL_GROUPSORT_visiblealpha_DESC"] = "群組將使用任何實際上可見的圖示,根據圖示的不透明度來排序."
L["UIPANEL_GROUPSORT_visibleshown"] = "顯示(遵循%s)"
L["UIPANEL_GROUPSORT_visibleshown_DESC"] = "群組將根據圖示對你是否可見來排序."
L["UIPANEL_ICONS"] = "圖示"
L["UIPANEL_ICONSPACING_DESC"] = "同組圖示彼此之間的間隔距離"
L["UIPANEL_LEVEL"] = "框體優先級"
L["UIPANEL_LOCK"] = "鎖定位置"
L["UIPANEL_LOCK_DESC"] = "鎖定此群組,防止移動或改變比例大小"
L["UIPANEL_LOCKUNLOCK"] = "鎖定/解鎖插件"
L["UIPANEL_MAIN_DESC"] = "此群組的主要設定選項."
L["UIPANEL_MAINOPT"] = "主選項"
L["UIPANEL_ONLYINCOMBAT"] = "只在戰鬥中顯示"
L["UIPANEL_POINT"] = "依附錨點"
L["UIPANEL_POSITION"] = "位置"
L["UIPANEL_POSITION_DESC"] = "控制此群組的螢幕位置的相關設定."
L["UIPANEL_PRIMARYSPEC"] = "主要天賦"
L["UIPANEL_PTSINTAL"] = "天賦使用點數(非天賦樹)"
L["UIPANEL_RELATIVEPOINT"] = "依附位置"
L["UIPANEL_RELATIVETO"] = "依附框體"
L["UIPANEL_RELATIVETO_DESC"] = [=[輸入'/framestack'來觀察當前滑鼠游標所在框體的提示資訊,以便尋找需要輸入編輯框的框體名稱.

需要更多幫助,請訪問http://www.wowpedia.org/API_Region_SetPoint]=]
L["UIPANEL_ROWS"] = "行"
L["UIPANEL_SCALE"] = "比例"
L["UIPANEL_SECONDARYSPEC"] = "第二天賦"
L["UIPANEL_SPEC"] = "雙天賦"
L["UIPANEL_STRATA"] = "框體層級"
L["UIPANEL_SUBTEXT2"] = [=[當圖示鎖定後TMW開始工作.
在未鎖定時,你可以移動圖示群組(或變更大小),右鍵點擊圖示開啟設定頁面.

你可以輸入/tellmewhen或/tmw來鎖定/解除鎖定.]=]
L["UIPANEL_TOOLTIP_ALLRESET"] = "重設所有圖示的數據和位置及其他設定"
L["UIPANEL_TOOLTIP_COLUMNS"] = "設定此群組的列數"
L["UIPANEL_TOOLTIP_ENABLEGROUP"] = "顯示並啟用此群組"
L["UIPANEL_TOOLTIP_GROUPRESET"] = "重設此群組位置跟比例"
L["UIPANEL_TOOLTIP_ONLYINCOMBAT"] = "勾選此項讓該群組只在戰鬥中顯示"
L["UIPANEL_TOOLTIP_PRIMARYSPEC"] = "勾選後此群組圖示在主要天賦時可見"
L["UIPANEL_TOOLTIP_ROWS"] = "設定此群組的行數"
L["UIPANEL_TOOLTIP_SECONDARYSPEC"] = "勾選後此群組圖示在第二天賦時可見"
L["UIPANEL_TOOLTIP_UPDATEINTERVAL"] = "設定圖示顯示/隱藏,透明度,條件等的檢查頻率(秒).0為最快.低階電腦設定數值過低會使幀數明顯降低."
L["UIPANEL_TREE"] = "天賦樹"
L["UIPANEL_TREE_DESC"] = "勾選來允許該組在某個天賦樹激活時顯示,或者不勾選讓它在天賦樹沒激活時隱藏."
L["UIPANEL_UPDATEINTERVAL"] = "更新頻率"
L["UIPANEL_WARNINVALIDS"] = "提示無效圖示"
L["UNDO_ICON"] = "復原"
L["UNDO_ICON_DESC"] = "復原最近一次圖示設定的變更動作."
L["UNITTWO"] = "第二單位"
L["UNNAMED"] = "((未命名))"
L["WARN_DRMISMATCH"] = [=[警告!你正在檢查遞減的法術來自兩個不同的已知分類.

在同一個遞減圖示中,用於檢查的所有法術應當使用同一遞減分類才能使圖示正常運作.

檢測到下列你所使用的法術及其分類:]=]
L["WATER"] = "水之圖騰"
L["worldboss"] = "首領"


