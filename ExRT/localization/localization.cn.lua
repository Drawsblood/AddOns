local GlobalAddonName, ExRT = ...

if ExRT.locale ~= "zhCN" then
	return
end

local L = ExRT.L
local PH = ExRT.L
local NEW = ExRT.L

L.message = "战术板"
L.marks = "标记"
L.bossmods = "首领模块"
L.timers = "计时器"
L.raidcheck = "团队检查"
L.marksbar = "标记助手"
L.invite = "组队助手"
L.help = "帮助"
L.cd2 = "团队技能"
L.sooitems = "副本掉落"
L.sallspells = "所有技能"
L.scspells = "职业技能"
PH.sencounter = "首领统计"
L.BossWatcher = "战斗日志"
L.InspectViewer = "成员检查"
L.Coins = "R币记录"
L.Arrow = "箭头"
L.Marks = "标记锁定"
L.Logging = "战斗日志"
PH.LootLink = "掉落通告"
L.BattleRes = "战斗复活"
L.Skada = "Skada模块"
L.Profiles = "配置"
L.LegendaryRing = "橙戒"

L.raidtargeticon1 = "{星星}"
L.raidtargeticon2 = "{大饼}"
L.raidtargeticon3 = "{菱形}"
L.raidtargeticon4 = "{三角}"
L.raidtargeticon5 = "{月亮}"
L.raidtargeticon6 = "{方形}"
L.raidtargeticon7 = "{大叉}"
L.raidtargeticon8 = "{骷髅}"

L.messagebutsend = "发送"
L.messagebutclear = "清除"
L.messageButCopy = "保存并发送"
L.messagebutfix = "锁定"
L.messagebutfixtooltip = "解锁战术板框架"
L.messagebutalpha = "透明度"
L.messagebutscale = "缩放"
L.messagebutsendtooltip = "保存并发送方案到所有成员"
L.messageOutline = "字体轮廓"
L.messageBackAlpha = "背景透明度"
L.messageTab1 = "当前方案"
L.messageTab2 = "草案"
L.NoteResetPos = "初始化"
PH.NoteResetPosTooltip = "移动笔记至屏幕中间"
L.NoteColor = "颜色"
PH.NoteColorTooltip1 = "命令 |cff00ff00||cXXXXXXXX|r ( XXXXXXXX是颜色)与 |cff00ff00||r|r 选取文字颜色被改变"
PH.NoteColorTooltip2 = "选取文字后使用下拉菜单改变文字颜色."
L.NoteColorRed = "红"
L.NoteColorGreen = "绿"
L.NoteColorBlue = "蓝"
L.NoteColorYellow = "黄"
L.NoteColorPurple = "紫"
L.NoteColorAzure = "天蓝"
L.NoteColorBlack = "黑"
L.NoteColorGrey = "灰"
L.NoteColorRedSoft = "浅红"
L.NoteColorGreenSoft = "浅绿"
L.NoteColorBlueSoft = "浅蓝"
L.NoteLastUpdate = "上次更新"
PH.NoteOnlyPromoted = "更新接受限制"
PH.NoteOnlyPromotedTooltip = "只接受团队领袖/助理战术更新"
PH.NoteTabCopyTooltip = "按住Shift复制当前的方案"
PH.NoteSelf = "个人方案"
PH.NoteSelfTooltip = "显示个人方案"
L.NoteAdd = "添加方案"
L.NoteRemove = "删除方案"
L.NoteDraftName = "方案名称"
L.NoteOtherIcons = "其他图标"
L.NoteFontOptions = "字体设置"
L.NoteFontOptionsBack = "<<< 返回"
L.NoteFontSize = "字体大小"
L.NoteHideInCombat = "战斗中隐藏"
L.NoteFrameStrata = "框架层级"
L.NoteShowOnlyPersonal = "只显示个人方案"
L.NoteShowOnlyInRaid = "只在团队中显示战术板"

L.setminimap1 = "隐藏小地图图标"
L.setauthor = "作者"
L.setver = "版本"
L.setcontact = "联系方式"
L.setEggTimerSlider = "每次更新, 毫秒."
L.SetThanks = "感谢"
L.YesText = "是"
L.NoText = "否"
L.SetErrorInCombat = "脱离战斗后载入"
L.SetAdditionalTabs = "额外选项"
L.SetTranslate = "汉化"

L.bossmodstot = "雷神王座"
PH.bossmodsradenhelp = "莱登，玩家分为两组(2、4队左侧, 3、5队右侧). 绿色高亮带有 \"不稳定的心能\" debuff的玩家, 红色高亮带有\"生命过敏 \" debuff的玩家, 无debuff的玩家为白色。"
L.bossmodsradenonly25 = "限25人团"
L.bossmodsraden ="莱登"
L.bossmodssoo = "决战奥格瑞玛"
L.bossmodsalpha = "透明度"
L.bossmodsscale = "尺寸"
L.bossmodsclose = "关闭所有首领模块"
L.bossmodsmalkorok ="马尔考罗克"
L.bossmodsmalkorokai ="马尔考罗克 AI"
PH.bossmodsmalkorokhelp ="马尔考罗克 首领模块. 点击 \"饼形\" 开启, 右击关闭。"
PH.bossmodsmalkorokaihelp ="马尔考罗克 AI 首领模块. 在AOE阶段自动选择最少数量玩家，黄色高亮5秒。只要有一个人在团队副本中协助就可以运行。"
L.bossmodsmalkorokdanger ="<<< 危险 >>>"
L.bossmodsshaofpride = "诺鲁什 / 傲之煞"
L.bossmodsSpoilsofPandaria = "潘达利亚战利品"
PH.bossmodsAutoLoadTooltip = "自动载入"
L.bossmodstok = "嗜血的索克"
L.BossmodsSpoilsofPandariaMogu = "魔古"
L.BossmodsSpoilsofPandariaKlaxxi = "卡拉克西英杰"
L.BossmodsSpoilsofPandariaOpensBox = "在侧面打开箱子:"
L.BossmodsResetPos = "重置位置"
PH.BossmodsResetPosTooltip = "移动所有首领模块至屏幕中央。"
L.BossmodsMalkorokSkada = " 马尔考罗克 Skada"
PH.BossmodsMalkorokSkadaTooltip = "Skada插件模块，显示有效治疗 (所有对绿盾 |TInterface\\Icons\\ability_malkorok_blightofyshaarj_green:0|t\|cff00ff00上古屏障|r 中的目标的治疗将被计为过量治疗。)"
L.BossmodsMalkorokSkadaError1 = "未发现Skada"
L.BossmodsMalkorokSkadaError2 = "模块已加载"
L.BossmodsMalkorokSkadaOnLoad1 = "\"马尔考罗克 Skada\" 模块已加载！"
PH.BossmodsMalkorokSkadaOnLoad2 = "注意！ 禁用 \"马尔考罗克 Skada\" 模块后，必须输入命令 \"/reload\" 重载界面。"
L.BossmodsKoragh = "克拉戈"
L.BossmodsMargok = "元首马尔高克"
L.BossmodsKromog = "克罗莫格"
L.BossmodsKromogLastUpdate = "最近更新"
L.BossmodsKromogHidePlayers = "隐藏已指定的玩家"
L.BossmodsKromogClear = "清除"
L.BossmodsKromogSelectPlayer = "选择玩家的位置 #"
L.BossmodsKromogDisableArrow = "禁用箭头"
L.BossmodsKromogSend = "发送"
L.BossmodsKromogSort = "排序"
L.BossmodsThogar = "主管索戈尔 [普通和英雄难度]"
L.BossmodsThogarIn = "进"
L.BossmodsThogarTransit = "过"
L.BossmodsThogarOut = "离"
PH.BossmodsKoraghHelp = "|TInterface\\Icons\\spell_fire_felfirenova:0|t 魔能散射：邪能 跑位箭头提示"
L.BossmodsKromogTest = "测试"
L.BossmodsKromogSetups = "设置"
L.BossmodsKromogSetupsSave = "保存"
L.BossmodsKromogSetupsLoad = "读取"
L.BossmodsKromogSetupsClear = "清除"
L.BossmodsKromogSetupsClose = "关闭"
PH.BossmodsKromogOnlyTrusted = "只接受信任排序"
PH.BossmodsKromogOnlyTrustedTooltip = "忽略非信任排序"
L.BossmodsIskarDisableClassColor = "禁用职业颜色"
L.BossmodsIskarHideStacks = "隐藏层数"
L.BossmodsIskarDisableRed = "禁用红色背景(安苏之眼debuff)"
L.BossmodsIskarShowNames = "显示玩家名字"
L.BossmodsKormrokCopy = "复制"
L.BossmodsKormrokArrow = "总是显示箭头"	
L.BossmodsArchimondeRadar = "精炼混乱雷达"
L.BossmodsArchimondeInfernals = "地狱火"
L.BossmodsArchimondeInfernalsTooltip = "地狱火血量"	
L.BossmodsArchimondeDisableShackled = "禁用\"枷锁酷刑\"圆圈"
PH.BossmodsArchimondeDistance = "视野半径"
L.BossmodsArchimondeDisableMarking = "禁用标记"
L.BossmodsArchimondeDisableText = "隐藏名字"
L.BossmodsGorefiendTargeting = "允许点击框架选中灵魂"

PH.timerstxt1 = "/rt pull\n/rt pull X\n/rt afk X\n/rt afk 0\n/rt timer S X\n|cFFFFFFFF |r\n\n\n/rt mytimer X"
PH.timerstxt2 = "- 战斗倒计时, 10 秒\n- 战斗倒计时, X 秒\n- 暂离 (休息) 时间, X 分钟\n- 取消暂离计时\n- 自定义计时器名称 \"S\" 在 X 秒\n\n\n\n- 设置战斗计时器时间, X 秒"
L.timerattack = "开始战斗"
L.timerattackcancel = "取消"
L.timerattackt = "战斗倒计时"
L.timerafk = "休息"
L.timerafkcancel = "休息取消"
L.timermin = "分."
L.timersec = "秒."
L.timerTimerFrame = "战斗计时器"
L.TimerTimeToKill = "击杀时间"
L.TimerResetPos = "复位设置"
PH.TimerResetPosTooltip = "移动战斗计时器到屏幕的中心"
PH.TimerTimeToKillHelp = "计算 \"击杀时间\" 在计时器"
L.TimerOnlyInCombat = "只在战斗中使用"

L.raidchecknofood = "无食物效果"
L.raidchecknoflask = "无合剂效果"
L.raidcheckfood = "检查食物效果"
PH.raidcheckfoodchat = "发送食物检查报告"
L.raidcheckflask = "检查合剂效果"
PH.raidcheckflaskchat = "发送合剂检查报告"
PH.raidcheckslak = "在就位确认时检查食物和合剂"
L.raidcheckPotion = "药水: "
L.raidcheckHS = "治疗石: "
PH.raidcheckPotionCheck = "启用药水和治疗石使用跟踪"
PH.raidcheckPotionLastPull = "上一次战斗药水使用报告"
PH.raidcheckPotionLastPullToChat = "发送药水使用报告"
PH.raidcheckHSLastPull = "上次战斗治疗石使用报告"
PH.raidcheckHSLastPullToChat = "发送治疗石使用报告"
L.raidcheckReadyCheck = "就位确认"
L.raidcheckReadyCheckScale = "规模"
L.raidcheckReadyCheckTest = "测试"
PH.raidcheckReadyCheckTimerTooltip = "就位确认后消失的时间(秒)"
L.raidcheckReadyCheckSec = "秒."
PH.RaidCheckReadyCheckHelp = "在确认后玩家的名字会从列表消失,红色标注没有合剂或食物的玩家名字"
PH.RaidCheckRunesEnable = "开启就位确认时检查符文"
L.RaidCheckRunesCheck = "检查符文效果"
L.RaidCheckRunesChat = "发送符文检查报告"
L.RaidCheckNoRunes = "没有符文"
PH.RaidCheckOnAttack = "在战斗倒计时检查食物、合剂、符文"
L.RaidCheckMinFoodLevel = "食物等级下限: "
L.RaidCheckMinFoodLevelAny = "全部"
PH.RaidCheckSendSelf = "只发送给自己"
L.RaidCheckNoBuffs = "没有状态"
L.RaidCheckBuffs = "检查状态"
PH.RaidCheckBuffsToChat = "发送状态报告"
L.RaidCheckBuffsEnable = "就位确定时检查状态"
L.RaidCheckMinFlaskExp = "显示快到期的合剂: "
L.RaidCheckMinFlaskExpNo = "无"
L.RaidCheckMinFlaskExpMin = "分钟."
L.RaidCheckDisableInLFR = "忽略随机难度"

L.marksbarstart = "取消标记"
L.marksbardel = "解除锁定"
L.marksbarrc = "就位确认"
L.marksbarpull = "战斗倒计时"
L.marksbarshowmarks = "显示标记按钮"
L.marksbarshowpermarks = "显示锁定标记按钮"
L.marksbarshowfloor = "显示世界标记按钮"
L.marksbarshowrcpull = "显示就位确认按钮和战斗倒计时按钮"
L.marksbaralpha = "透明度"
L.marksbarscale = "缩放"
L.marksbartmr = "战斗倒计时秒数:"
L.marksbarWMView = "标记助手模版:"
L.MarksBarResetPos = "重置设置"
PH.MarksBarResetPosTooltip = "移动框架到屏幕中间"
PH.MarksBarHelp = "右击按钮 \"锁定\" 目标标记。\n*只能作用于团队或队伍中的玩家。"
PH.MarksBarDisableInRaid = "不在队伍/团队中隐藏"
L.MarksBarVertical = "垂直排列"
L.MarksBarReverse = "反向排序"

L.inviterank = "会阶:"
L.inviteinv = "邀请"
PH.inviteguildonly = "只邀请公会成员"
PH.invitewords = "启用密语自动邀请"
PH.invitewordstooltip = "密语关键词"
PH.invitedis = "解散团队"
PH.inviteReInv = "解散并重组团队"
L.inviteaccept = "自动接受来自好友和公会的组队邀请"
PH.inviteAutoPromote = "自动提升团队权限"
PH.inviteAutoPromoteTooltip = "提升名单"
PH.inviteAutoPromoteDontUseGuild = "不选择,只通过下面设定名单"
PH.inviteHelpRaid = "设置邀请公会成员会阶下限。"
PH.inviteHelpAutoInv = "自动邀请对你密语关键词的玩家"
PH.inviteHelpAutoAccept = "自动接受所有邀请"
PH.inviteHelpAutoPromote = "自动提升所有在名单或会阶下限以上的玩家"
L.inviteRaidDemote = "移除所有成员权限"
L.InviteRaidDiffCheck = "自动切换难度和拾取分配方式"
L.InviteRaidDiff = "副本难度:"
L.InviteMasterlooters = "战利品分配权:"
PH.InviteMasterlootersTooltip = "战利品分配者(名字以空格分隔)"

L.cd2fix = "锁定"
L.cd2alpha = "透明度"
L.cd2scale = "缩放"
L.cd2lines = "行高"
L.cd2split = "拆分列表"
L.cd2splittooltip = "拆分列表至单独框架"
L.cd2width = "列宽"
PH.cd2graytooltip = "显示冷却中技能图标为灰色"
PH.cd2noraid = "非团队中显示"
L.cd2Spells = "技能"
L.cd2Appearance = "外观"
PH.cd2PriorityTooltip = "较低数值 = 高优先级"
PH.cd2ColNum = "分栏"
L.cd2Priority = "优先级"
L.cd2SpellID = "技能ID"
L.cd2EditBoxCDTooltip = "技能CD, 秒."
L.cd2EditBoxDurationTooltip = "持续时间, 秒."
L.cd2Class = "职业"
L.cd2Spec = "专精"
L.cd2RemoveButton = "移除"
L.cd2AddSpell = "添加技能"
PH.cd2AddSpellFromList = "从列表添加技能"
L.cd2AddSpellFrameName = "技能列表"
L.cd2AddSpellFrameCDText = "CD"
L.cd2AddSpellFrameDurationText = "持续时间"
L.cd2AddSpellFrameColumnText = "预设组"
L.cd2AddSpellFrameTalent = "天赋"
PH.cd2AddSpellFrameDuration = "持续时间变化："
PH.cd2AddSpellFrameCDChange = "冷却时间变化："
L.cd2AddSpellFrameCharge = "施放次数"
PH.cd2AddSpellFrameChargeChange = "获得使用次数"
PH.cd2AddSpellFrameCast = "显示施法时间"
PH.cd2AddSpellFrameDurationLost = "失去光环效果结束"
PH.cd2AddSpellFrameSharing = "共享冷却时间"
L.cd2AddSpellFrameDispel = "驱散"
PH.cd2AddSpellFrameReplace = "被天赋取代"
L.cd2AddSpellFrameRadiness = "SoO饰品降低CD时间"
PH.cd2ButtonModify = "配置 >>"
L.cd2TextSpell = "技能"
L.cd2TextAdd = "增加"
PH.cd2ColSet = "分栏设置"
PH.cd2ColSetBotToTop = "向上扩展"
PH.cd2ColSetGeneral = "使用通用设置"
PH.cd2ColSetResetPos = "恢复默认设置"
L.cd2ColSetTextRight = "右边文本"
L.cd2ColSetTextCenter = "中间文本"
L.cd2ColSetTextLeft = "左边文本"
PH.cd2ColSetTextReset = "恢复默认"
PH.cd2ColSetTextTooltip = "在上方输入命令:|n|cff00ff00%name%|r - 玩家名字|n|cff00ff00%time%|r - 冷却时间|n|cff00ff00%name_time%|r - 玩家名字,如果在CD显示时间|n|cff00ff00%spell%|r - 技能名称|n|cff00ff00%stime%|r - \"短CD时间显示\".|n|cff00ff00%name_stime%|r - 玩家名字,如果在CD显示 \"短CD时间显示\"|n|cff00ff00%status%|r - 如果玩家死亡/离线显示文本状态"
PH.cd2ColSetMethodCooldown = "技能图标冷却动画"
L.cd2ColSetTextIconName = "技能图标显示玩家姓名"
PH.cd2ColSetColsInCol = "每行数量"
PH.cd2GeneralSet = "通用设置"
L.cd2GeneralSetTestMode = "测试模式"
PH.cd2OtherSet = "其他设置"
L.cd2OtherSetTexture = "纹理"
L.cd2OtherSetColor = "设定颜色"
PH.cd2OtherSetColorFrameText = "就绪的颜色"
PH.cd2OtherSetColorFrameActive = "技能持续中的颜色"
PH.cd2OtherSetColorFrameCooldown = "不可用的颜色"
PH.cd2OtherSetColorFrameCast = "施放中的颜色"
PH.cd2OtherSetColorFrameAlpha = "背景透明度"
PH.cd2OtherSetColorFrameAlphaCD = "时间条透明度"
PH.cd2OtherSetColorFrameAlphaCooldown = "CD中透明度"
PH.cd2OtherSetColorFrameReset = "重置为默认"
PH.cd2OtherSetColorFrameSoften = "淡化颜色"
PH.cd2OtherSetColorFrameClass = "使用分类颜色"
PH.cd2OtherSetColorFrameTopText = "文字"
PH.cd2OtherSetColorFrameTopBack = "背景"
PH.cd2OtherSetColorFrameTopTimeLine = "条"
L.cd2OtherSetIconSize = "图标大小"
L.cd2OtherSetFontSize = "字体大小"
L.cd2OtherSetFont = "字体"
PH.cd2OtherSetOutline = "文字边框"
L.cd2OtherSetFontShadow = "文字阴影"
PH.cd2OtherSetAnimation = "启动动画效果"
L.cd2OtherSetReset = "复位"
PH.cd2OtherSetOnlyOnCD = "只显示CD中的技能"
PH.cd2OtherSetIconPosition = "图标位置"
PH.cd2OtherSetIconPositionLeft = "图标在左"
PH.cd2OtherSetIconPositionRight = "图标在右"
PH.cd2OtherSetIconPositionNo = "隐藏图标"
PH.cd2OtherSetStyleAnimation = "动画风格"
L.cd2OtherSetStyleAnimation1 = "开始为满"
L.cd2OtherSetStyleAnimation2 = "开始为空"
PH.cd2OtherSetTimeLineAnimation = "可用计时条"
PH.cd2OtherSetTimeLineAnimation1 = "不填充计时条"
PH.cd2OtherSetTimeLineAnimation2 = "填充计时条"
L.cd2OtherSetTabNameGeneral = "一般"
L.cd2OtherSetTabNameIcons = "图标"
L.cd2OtherSetTabNameColors = "纹理和颜色"
L.cd2OtherSetTabNameFont = "字体"
L.cd2OtherSetTabNameText = "名字和时间"
PH.cd2OtherSetTabNameOther = "其他设置"
L.cd2OtherSetTabNameTemplate = "模版"
PH.cd2OtherSetTemplateRestore = "还原"
PH.cd2fastSetupTitle = "快速设置"
L.cd2fastSetupTooltip = "技能列表"
PH.cd2fastSetupTitle1 = "团队技能CD"
PH.cd2fastSetupTitle2 = "单体技能CD"
L.cd2fastSetupTitle3 = "复活"
L.cd2fastSetupTitle4 = "打断"
L.cd2fastSetupTitle5 = "嘲讽"
L.cd2fastSetupTitle6 = "驱散"
PH.cd2History = "历史记录"
L.cd2HistoryClear = "清除"
PH.cd2HelpFastSetup = "快速教学!启用模块，移动冷却框架至合适的位置并锁定，使用\"快速设置\"按钮下拉菜单添加技能。"
PH.cd2HelpOnOff = "启用技能冷却监控"
PH.cd2HelpCol = "选择职业"
PH.cd2HelpPriority = "设置优先级，数值较低的技能会优先显示"
PH.cd2HelpTime = "设置冷却、持续时间和分组"
PH.cd2HelpColSetup = "各组的独立设置，别忘了\"开启\"。"
PH.cd2HelpTestButton = L.cd2GeneralSetTestMode
PH.cd2HelpButtonDefault = "重置选定分组所有设置"
PH.cd2HelpAddButton = "添加自定义技能。下翻并点击 \"".. L.cd2AddSpell .."\"。在编辑框中输入技能ID，选择职业，然后按下\"".. L.cd2ButtonModify .."\"按钮设置冷却、持续时间和分组。"
PH.cd2HelpHistory = "技能监控历史记录"
PH.cd2ColSetFontOtherAvailable = "设置每个文本样式"
L.cd2ColSetFontPosGeneral = "综合"
L.cd2ColSetFontPosLeft = "左边"
L.cd2ColSetFontPosRight = "右边"
L.cd2ColSetFontPosCenter = "中间"
L.cd2ColSetFontPosIcon = "图标"
PH.cd2ColSetBetweenLines = "行间距"
L.cd2BlackBack = "背景透明度"
L.cd2StatusOffline = "(离线)"
L.cd2StatusDead = "(死亡)"
L.cd2InspectHaste = "%+(%d+) 急速"
L.cd2InspectHasteGem = "当前位置无效"
L.cd2InspectMastery = "%+(%d+) 精通"
L.cd2InspectMasteryGem = "当前位置无效"
L.cd2InspectCrit = "%+(%d+) 暴击"
L.cd2InspectCritGem = "当前位置无效"
L.cd2InspectCritGemLegendary = "%+%]%](%d+) 暴击,"
L.cd2InspectSpirit = "%+(%d+) 精神"
L.cd2InspectInt = "%+(%d+) 智力"
L.cd2InspectIntGem = "当前位置无效" -- Legendary
L.cd2InspectStr = "%+(%d+) 力量"
L.cd2InspectStrGem = "当前位置无效"
L.cd2InspectAgi = "%+(%d+) 敏捷"
L.cd2InspectSpd = "%+(%d+) 法术强度"
L.cd2InspectAll = "%+(%d+) 所有属性"
L.cd2OtherSetBorder = "边框"
PH.cd2OtherSetIconToolip = "鼠标悬停在图标上显示技能提示"
PH.cd2OtherSetLineClick = "点击发送信息到聊天框"
L.cd2InspectLeech = "%+(%d+) 吸血"
L.cd2InspectMultistrike = "%+(%d+) 溅射"
L.cd2InspectMultistrikeGem = "当前位置无效"
L.cd2InspectVersatility = "%+(%d+) 全能"
L.cd2InspectVersatilityGem = "当前位置无效"
L.cd2InspectBonusArmor = "%+(%d+) 护甲加成"
L.cd2InspectAvoidance = "%+(%d+) 闪避"
L.cd2InspectSpeed = "%+(%d+) 加速"
L.cd2Resurrect = "战斗复活"
PH.cd2ResurrectTooltip = "在随机以上难度的团队副本中显示\n战斗复活线型冷却计时条。"
L.cd2Columns = "列表"
PH.cd2SortByAvailability = "智能排序可用与不可用技能"
PH.cd2NewSpellNewLine = "每组技能都在单独的一列显示"
PH.cd2NewSpellNewLineTooltip = "*只有当行数超过1才会启动"
L.cd2MethodsSortingRules = "排序优先级"
L.cd2MethodsSortingRules1 = "1.优先级 >技能ID > 玩家名字"
L.cd2MethodsSortingRules2 = "2. 优先级 >玩家名字> 技能ID"
L.cd2MethodsSortingRules3 = "3. 优先级 > 玩家职业 > 技能ID> 玩家名字"
L.cd2MethodsSortingRules4 = "4. 优先级 > 玩家职业 > 玩家名字 > 技能ID"
L.cd2MethodsSortingRules5 = "5. 玩家名字 > 优先级 > 技能ID"
L.cd2MethodsSortingRules6 = "6. 玩家职业 > 优先级 > 玩家名字 > 技能ID"
PH.cd2SortByAvailabilityActiveToTop = "置顶正在施放中的技能"
L.cd2SortByAvailabilityActiveToTopTooltip = "必须启用\"".. L.cd2SortByAvailability .."\"选项"
L.cd2MethodsDisableOwn = "隐藏自己的技能"
PH.cd2FilterWindowHelp = "按住Shift选择多个来源或目标"
L.cd2Racial = "种族"
L.cd2Items = "装备"
L.cd2OtherSetHideSpark = "隐藏 \"闪烁\""
PH.cd2MethodsAlphaNotInRange = "设置不在距离玩家的透明度"
L.cd2OtherSetTabNameBlackList = "黑名单"
PH.cd2ColSetBlacklistTooltip = "黑名单将隐藏玩家,命令\nEnter 玩家的名字. 你也可以使用|cff00ff00playername:技能ID|r 来隐藏某些技能"
PH.cd2ColSetWhitelistTooltip = "白名单如果不是空的,黑名单将停止工作。输入只显示该技能的玩家名字，每个名字单独一行。"
PH.cd2ColSetShowTitles = "显示技能名称"
PH.cd2ColSetDisableActive = "不显示施放中的时间"
L.cd2ColSetIconHideBlizzardEdges = "隐藏图标 \"边框\""
L.cd2ReverseSorting = "反向排序"

L.sallspellsEggClear = "清除"
L.sallspellsEgg = "战斗日志"
PH.sallspellsEggPlayers = "记录玩家"
L.sallspellsEggAutoLoad = "自动加载"

L.sooitemssooboss1 = "伊莫苏斯"
L.sooitemssooboss2 = "堕落的守护者"
L.sooitemssooboss3 = "诺鲁什"
L.sooitemssooboss4 = "傲之煞"
L.sooitemssooboss5 = "迦拉卡斯"
L.sooitemssooboss6 = "钢铁战蝎"
L.sooitemssooboss7 = "库卡隆黑暗萨满"
L.sooitemssooboss8 = "纳兹戈林将军"
L.sooitemssooboss9 = "马尔考罗克"
L.sooitemssooboss10 = "潘达利亚战利品"
L.sooitemssooboss11 = "嗜血的索克"
L.sooitemssooboss12 = "攻城匠师黑索"
L.sooitemssooboss13 = "卡拉克西英杰"
L.sooitemssooboss14 = "加鲁尔什·地狱咆哮"
L.sooitemstotboss1 = "击碎者金克罗"
L.sooitemstotboss2 = "郝丽东"
L.sooitemstotboss3 = "长者议会"
L.sooitemstotboss4 = "托多斯"
L.sooitemstotboss5 = "墨格瑞拉"
L.sooitemstotboss6 = "季鹍"
L.sooitemstotboss7 = "遗忘者杜鲁姆"
L.sooitemstotboss8 = "普利莫修斯"
L.sooitemstotboss9 = "黑暗意志"
L.sooitemstotboss10 = "铁穹"
L.sooitemstotboss11 = "魔古双后"
L.sooitemstotboss12 = "雷神"
L.sooitemstotboss13 = "莱登"
L.sooitemstrash = "小怪掉落"
L.sooitemssets = "套装"
L.sooitemst15 = "雷神王座"
L.sooitemst16 = "决战奥格瑞玛"
L.RaidLootHighmaulBoss1 = "卡加斯·刃拳"
L.RaidLootHighmaulBoss2 = "屠夫"
L.RaidLootHighmaulBoss3 = "泰克图斯"
L.RaidLootHighmaulBoss4 = "布兰肯斯波"
L.RaidLootHighmaulBoss5 = "独眼魔双子"
L.RaidLootHighmaulBoss6 = "克拉戈"
L.RaidLootHighmaulBoss7 = "元首马尔高克"
L.RaidLootBFBoss1 = "格鲁尔"
L.RaidLootBFBoss2 = "奥尔高格"
L.RaidLootBFBoss3 = "兽王达玛克"
L.RaidLootBFBoss4 = "缚火者卡格拉兹"
L.RaidLootBFBoss5 = "汉斯加尔与弗兰佐克"
L.RaidLootBFBoss6 = "主管索戈尔"
L.RaidLootBFBoss7 = "爆裂熔炉"
L.RaidLootBFBoss8 = "克罗莫格"
L.RaidLootBFBoss9 = "钢铁女武神"
L.RaidLootBFBoss10 = "黑手"
L.RaidLootT17Highmaul = "悬槌堡"
L.RaidLootT17BF = "黑石铸造厂"
L.RaidLootWOD5pplAuchindounBoss1 = "警戒者凯萨尔"
L.RaidLootWOD5pplAuchindounBoss2 = "缚魂者尼娅米"
L.RaidLootWOD5pplAuchindounBoss3 = "阿扎凯尔"
L.RaidLootWOD5pplAuchindounBoss4 = "塔隆戈尔"
L.RaidLootWOD5pplBloodmaulSlagMinesBoss1 = "玛格莫拉图斯"
L.RaidLootWOD5pplBloodmaulSlagMinesBoss2 = "守奴人库鲁斯托"
L.RaidLootWOD5pplBloodmaulSlagMinesBoss3 = "罗托尔"
L.RaidLootWOD5pplBloodmaulSlagMinesBoss4 = "戈洛克"
L.RaidLootWOD5pplGrimrailDepotBoss1 = "箭火与波尔卡"
L.RaidLootWOD5pplGrimrailDepotBoss2 = "尼托格 雷塔"
L.RaidLootWOD5pplGrimrailDepotBoss3 = "啸天者托瓦拉"
L.RaidLootWOD5pplIronDocksBoss1 = "血肉撕裂者诺格加尔"
L.RaidLootWOD5pplIronDocksBoss2 = "恐轨押运员"
L.RaidLootWOD5pplIronDocksBoss3 = "奥舍尔"
L.RaidLootWOD5pplIronDocksBoss4 = "斯古洛克"
L.RaidLootWOD5pplShadowmoonBurialGroundsBoss1 = "莎达娜·血怒"
L.RaidLootWOD5pplShadowmoonBurialGroundsBoss2 = "纳利什·食魂者"
L.RaidLootWOD5pplShadowmoonBurialGroundsBoss3 = "骨喉"
L.RaidLootWOD5pplShadowmoonBurialGroundsBoss4 = "耐奥祖"
L.RaidLootWOD5pplSkyreachBoss1 = "兰吉特"
L.RaidLootWOD5pplSkyreachBoss2 = "阿拉卡纳斯"
L.RaidLootWOD5pplSkyreachBoss3 = "鲁克兰"
L.RaidLootWOD5pplSkyreachBoss4 = "高阶贤者维里克斯"
L.RaidLootWOD5pplTheEverbloomBoss1 = "枯木"
L.RaidLootWOD5pplTheEverbloomBoss2 = "远古的保卫者"
L.RaidLootWOD5pplTheEverbloomBoss3 = "大法师索尔"
L.RaidLootWOD5pplTheEverbloomBoss4 = "艾里塔克"
L.RaidLootWOD5pplTheEverbloomBoss5 = "雅努"
L.RaidLootWOD5pplUpperBlackrockSpireBoss1 = "折铁者高尔山"
L.RaidLootWOD5pplUpperBlackrockSpireBoss2 = "奇拉克"
L.RaidLootWOD5pplUpperBlackrockSpireBoss3 = "指挥官萨贝克"
L.RaidLootWOD5pplUpperBlackrockSpireBoss4 = "怒翼"
L.RaidLootWOD5pplUpperBlackrockSpireBoss5 = "督军扎伊拉"
L.RaidLootWOD5pplAuchindoun = "奥金顿"
L.RaidLootWOD5pplBloodmaulSlagMines = "血槌炉渣矿井"
L.RaidLootWOD5pplGrimrailDepot = "恐轨车站"
L.RaidLootWOD5pplIronDocks = "钢铁码头"
L.RaidLootWOD5pplShadowmoonBurialGrounds = "影月墓地"
L.RaidLootWOD5pplSkyreach = "通天峰"
L.RaidLootWOD5pplTheEverbloom = "永茂林地"
L.RaidLootWOD5pplUpperBlackrockSpire = "黑石塔上层"
L.RaidLootSelect = "选择"
L.RaidLootTypeRaid = "[团队]"
L.RaidLootTypeParty = "[小队]"
L.RaidLootTypeSolo = "[个人]"
L.RaidLootWODCraftBlacksmithing = "锻造"
L.RaidLootWODCraftEngineering = "工程"
L.RaidLootWODCraftLeatherworking = "制皮"
L.RaidLootWODCraftTailoring = "裁缝"
L.RaidLootWODCraftJewelcrafting = "珠宝"
L.RaidLootWODCraftInscription = "铭文"
L.RaidLootT18HC = "地狱火堡垒"
L.RaidLootT18HCBoss1 = "奇袭地狱火"
L.RaidLootT18HCBoss2 = "钢铁掠夺者"
L.RaidLootT18HCBoss3 = "考莫克"
L.RaidLootT18HCBoss4 = "高阶地狱火议会"
L.RaidLootT18HCBoss5 = "基尔罗格·死眼"
L.RaidLootT18HCBoss6 = "血魔"
L.RaidLootT18HCBoss7 = "暗影领主艾斯卡"
L.RaidLootT18HCBoss8 = "永恒者索克雷萨"
L.RaidLootT18HCBoss9 = "邪能领主扎昆"
L.RaidLootT18HCBoss10 = "祖霍拉克"
L.RaidLootT18HCBoss11 = "暴君维哈里"
L.RaidLootT18HCBoss12 = "玛诺洛斯"
L.RaidLootT18HCBoss13 = "阿克蒙德"
L.RaidLootT18HCBoss13trink = "阿克蒙德(饰品)"
L.RaidLootTitleRaid = "团队副本/地下城:"
L.RaidLootTitleBoss = "首领:"

L.sencounterUnknown = "未知"
L.sencounter5ppl = "地下城"
L.sencounter5pplHC = "英雄地下城"
L.sencounter10ppl = "10人副本"
L.sencounter25ppl = "25人副本"
L.sencounter10pplHC = "10人英雄副本"
L.sencounter25pplHC = "25人英雄副本"
L.sencounterLfr = "随机团队"
L.sencounterChall = "挑战"
L.sencounter40ppl = "40人副本"
L.sencounter3pplHC = "英雄场景战役"
L.sencounter3ppl = "场景战役"
L.sencounterFlex = "弹性副本"
L.sencounterMystic = "史诗 *"
L.sencounterWODNormal = "普通模式"
L.sencounterWODHeroic = "英雄模式"
L.sencounterWODMythic = "史诗模式"
L.sencounterBossName = "首领名字"
L.sencounterFirstKill = "首次击杀"
L.sencounterWipes = "开怪"
L.sencounterKills = "击杀"
L.sencounterFirstBlood = "第1滴血"
L.sencounterWipeTime = "清除"
L.sencounterKillTime = "击杀时间"
L.sencounterOnlyThisChar = "仅当前角色"
L.EncounterClear = "清除数据"
L.EncounterClearPopUp = "确定清除所有数据?"
L.EncounterLegacy = "旧世"

L.BossWatcherFilterTaunts = "嘲讽"
L.BossWatcherFilterOnlyBuffs = "只限Buff"
L.BossWatcherFilterOnlyDebuffs = "只限Debuffs"
L.BossWatcherFilterBySpellID = "技能ID"
L.BossWatcherFilterTooltip = "技能列表"
L.BossWatcherFilterStun = "击晕"
PH.BossWatcherFilterPersonal = "伤害减免"
L.BossWatcherChkShowGUIDs = "单独显示NPC"
L.BossWatcherTabMobs = "伤害"
L.BossWatcherTabInterruptAndDispel = "打断和驱散"
L.BossWatcherTabBuffsAndDebuffs = "光环"
L.BossWatcherReportTotal = "总体"
L.BossWatcherReportCast = "技能来自"
L.BossWatcherReportSwitch = "技能目标"
L.BossWatcherDamageSwitchTabInfo = "信息"
L.BossWatcherDamageSwitchTabInfoNoInfo = "无信息"
L.BossWatcherDamageSwitchTabInfoRIP = "死亡"
L.BossWatcherInterrupts = "打断"
L.BossWatcherDispels = "驱散"
L.BossWatcherBuffsAndDebuffsTextOn = "于"
L.BossWatcherBuffsAndDebuffsTooltipTitle = "事件"
L.BossWatcherBuffsAndDebuffsFilterSource = "来源"
L.BossWatcherBuffsAndDebuffsFilterTarget = "目标"
L.BossWatcherBuffsAndDebuffsFilterAll = "所有"
L.BossWatcherBuffsAndDebuffsFilterFriendly = "友方"
L.BossWatcherBuffsAndDebuffsFilterHostile = "敌对"
L.BossWatcherBuffsAndDebuffsFilterSpecial = "特别"
L.BossWatcherBuffsAndDebuffsFilterClear = "清除筛选"
L.BossWatcherBuffsAndDebuffsFilterNone = "无"
L.BossWatcherBuffsAndDebuffsFilterFilter = "筛选"
L.BossWatcherBuffsAndDebuffsTooltipCountText = "统计"
L.BossWatcherBuffsAndDebuffsTooltipUptimeText = "运行时间"
L.BossWatcherUnknown = "环境"
L.BossWatcherLastFight = "上次战斗"
L.BossWatcherTimeLineTooltipTitle = "事件"
L.BossWatcherTimeLineCast = "施放"
L.BossWatcherTimeLineCastStart = "开始施放"
L.BossWatcherTimeLineDies = "死亡"
L.BossWatcherTimeLineOnText = "于"
L.BossWatcherInterruptText = "打断"
L.BossWatcherByText = "和"
L.BossWatcherDispelText = "驱散"
L.BossWatcherSegments = "分段"
PH.BossWatcherSegmentsTooltip = "在战斗中使用\"/rt seg\"开始新分段.\n\n你也可以设定条件自动分段."
PH.BossWatcherSegmentEventsUSS = "施放成功"
PH.BossWatcherSegmentEventsSAR = "光环消失"
PH.BossWatcherSegmentEventsSAA = "光环开启"
PH.BossWatcherSegmentEventsUD = "NPC死亡"
PH.BossWatcherSegmentEventsCMRBE = "首领技能聊天信息"
L.BossWatcherSegmentNamesUSS = "技能"
L.BossWatcherSegmentNamesSAA = "+ 光环"
L.BossWatcherSegmentNamesSAR = "- 光环"
L.BossWatcherSegmentNamesUD = "死亡"
L.BossWatcherSegmentNamesES = "战斗"
L.BossWatcherSegmentNamesSC = "聊天命令"
L.BossWatcherSegmentNamesCMRBE = "聊天信息"
L.BossWatcherSegmentsSpellTooltip = "技能ID或NPC ID"
L.BossWatcherSegmentSelectAll = "选择所有"
L.BossWatcherSegmentSelectNothing = "无选择"
L.BossWatcherFilterBySpellName = "技能名称"
L.BossWatcherSendToChat = "发送至聊天"
L.BossWatcherPetOwner = "%s的宠物"
L.BossWatcherPetText = "宠物"
PH.BossWatcherMarkOnDeath = "标记死亡"
L.BossWatcherSegmentClear = "清除"
PH.BossWatcherSegmentPreSet = "预设"
L.BossWatcherOptions = "其他设置"
L.BossWatcherOptionsFightsSave = "保存战斗:"
PH.BossWatcherOptionsFightsWarning = "* 保存次数越多,占用资源越多"
L.BossWatcherSelectFight = "选择战斗"
L.BossWatcherSelectFightClose = "关闭"
PH.BossWatcherChatSpellMsg = "发送技能信息到聊天"
L.BossWatcherFilterPotions = "药水"
PH.BossWatcherFilterRaidSaves = "团队技能"
L.BossWatcherFilterPandaria = "MOP传说物品"
L.BossWatcherFilterTier16 = "决战奥格瑞玛"
PH.BossWatcherOptionSpellID = "在时间线显示技能ID"
L.BossWatcherTabPlayersSpells = "玩家技能"
PH.BossWatcherSegmentNowTooltip = "当前技能:"
L.BossWatcherTabHeal = "治疗"
PH.BossWatcherErrorInCombat = "需脱战后更新数据."
PH.BossWatcherTabEnergy = "能量"
L.BossWatcherEnergyOnce1 = "时间"
L.BossWatcherEnergyOnce2 = "时间"
L.BossWatcherEnergyType0 = "法力值"
L.BossWatcherEnergyType1 = "怒气值"
L.BossWatcherEnergyType2 = "集中值"
L.BossWatcherEnergyType3 = "能量值"
L.BossWatcherEnergyType5 = "符文"
L.BossWatcherEnergyType6 = "符文能量"
L.BossWatcherEnergyType7 = "灵魂碎片"
L.BossWatcherEnergyType8 = "日蚀"
L.BossWatcherEnergyType9 = "神圣能量值"
L.BossWatcherEnergyType10 = "交替能量"
L.BossWatcherEnergyType12 = "真气"
L.BossWatcherEnergyType13 = "暗影宝珠"
L.BossWatcherEnergyType14 = "爆燃灰烬"
L.BossWatcherEnergyType15 = "恶魔怒气"
L.BossWatcherEnergyTypeUnknown = "能量ID: "
L.BossWatcherBuffsAndDebuffsSecondsText = "秒"
L.BossWatcherTabGraphics = "图像"
L.BossWatcherGraphicsDPS = "秒伤"
L.BossWatcherGraphicsHealth = "血量"
L.BossWatcherGraphicsPower = "能量"
L.BossWatcherGraphicsStep = "帧, 秒."
L.BossWatcherGraphicsTotal = "总秒伤"
L.BossWatcherGraphicsSelect = "选择玩家"
PH.BossWatcherBuffsAndDebuffsFilterEditBoxTooltip = "每行输入一个技能"
PH.BossWatcherOptionNoGraphic = "禁用图形"
PH.BossWatcherOptionNoBuffs = "禁用buffs & debuffs"
PH.BossWatcherOptionNoBuffsTooltip = "Buffs 和 debuffs(高内存占用)"
PH.BossWatcherBackToInterface = "返回界面"
L.BossWatcherButtonClose = "关闭"
L.BossWatcherCreateReport = "发送报告"
PH.BossWatcherCreateReportTooltip = "发送当前信息到聊天"
PH.BossWatcherCombatError = "脱离战斗或使用\"/rt bw end\"命令停止记录。"
L.BossWatcherTabEnemy = "敌对目标"
L.BossWatcherAllSources = "所有来源"
L.BossWatcherAllTargets = "所有目标"
L.BossWatcherDamageTooltipOverkill = "过量伤害"
L.BossWatcherDamageTooltipBlocked = "格挡"
L.BossWatcherDamageTooltipAbsorbed = "吸收"
L.BossWatcherDamageTooltipTotal = "总计"
L.BossWatcherDamageTooltipFromCrit = "暴击伤害"
L.BossWatcherDamageTooltipFromMs = "溅射伤害"
L.BossWatcherDamageTooltipCount = "次数(不计溅射)"
L.BossWatcherDamageTooltipMaxHit = "最大伤害"
L.BossWatcherDamageTooltipMidHit = "平均伤害"
L.BossWatcherDamageTooltiCritCount = "暴击次数"
L.BossWatcherDamageTooltiCritAmount = "暴击伤害总量"
L.BossWatcherDamageTooltiMaxCrit = "最大暴击伤害"
L.BossWatcherDamageTooltiMidCrit = "平均暴击伤害"
L.BossWatcherDamageTooltiMsCount = "溅射次数"
L.BossWatcherDamageTooltiMsAmount = "溅射伤害总量"
L.BossWatcherDamageTooltiMaxMs = "最大溅射伤害"
L.BossWatcherDamageTooltiMidMs = "平均溅射伤害"
L.BossWatcherDamageTooltipParry = "招架"
L.BossWatcherDamageTooltipDodge = "闪避"
L.BossWatcherDamageTooltipMiss = "未击中"
L.BossWatcherAll = "所有"
L.BossWatcherDamageDamageDone = "伤害"
L.BossWatcherDamageDamageTaken = "敌方造成的伤害"
L.BossWatcherDamageDamageTakenByEnemy = "敌方受到的伤害"
L.BossWatcherDamageDamageTakenByPlayers = "玩家受到的伤害"
L.BossWatcherDamageDamageDoneBySpell = "技能伤害"
L.BossWatcherDamageDamageTakenBySpell = "受到的技能伤害"
L.BossWatcherSource = "来自"
L.BossWatcherTarget = "目标"
L.BossWatcherType = "类型"
L.BossWatcherDamageShowOver = "显示过量、格挡、吸收伤害"
L.BossWatcherSwitchBySpell = "承受技能时间"
L.BossWatcherSwitchByTarget = "成为目标时间"
L.BossWatcherBeginCasting = "开始施放"
L.BossWatcherFriendly = "友方"
L.BossWatcherHostile = "敌方"
L.BossWatcherBySource = "检查来源"
L.BossWatcherByTarget = "检查目标"
L.BossWatcherBySpell = "检查技能"
L.BossWatcherHealTooltipOver = "过量治疗"
L.BossWatcherHealTooltipAbsorbed = "吸收"
L.BossWatcherHealTooltipTotal = "总计"
L.BossWatcherHealTooltipFromCrit = "暴击治疗"
L.BossWatcherHealTooltipFromMs = "溅射治疗"
L.BossWatcherHealTooltipCount = "次数 (不计溅射)"
L.BossWatcherHealTooltipHitMax = "最大治疗"
L.BossWatcherHealTooltipHitMid = "平均治疗"
L.BossWatcherHealTooltipCritCount = "暴击次数"
L.BossWatcherHealTooltipCritAmount = "暴击治疗总量"
L.BossWatcherHealTooltipCritMax = "最大暴击治疗"
L.BossWatcherHealTooltipCritMid = "平均暴击治疗"
L.BossWatcherHealTooltipMsCount = "溅射次数"
L.BossWatcherHealTooltipMsAmount = "总溅射治疗"
L.BossWatcherHealTooltipMsMax = "最大溅射治疗"
L.BossWatcherHealTooltipMsMid = "平均溅射治疗"
L.BossWatcherHealFriendly = "友方"
L.BossWatcherHealHostile = "敌方"
L.BossWatcherHealFriendlyByTarget = "友方目标"
L.BossWatcherHealHostileByTarget = "敌方目标"
L.BossWatcherHealFriendlyBySpell = "友方技能"
L.BossWatcherHealHostileBySpell = "敌方技能"
L.BossWatcherHealShowOver = "显示过量治疗"
L.BossWatcherStopRecord = "停止记录"
L.BossWatcherStopRecord2 = "or /rt bw end"
PH.BossWatcherRecordStart = "记录开始"
PH.BossWatcherRecordStop = "记录停止"
L.BossWatcherGoToBossWatcher = "查看战斗日志"
PH.BossWatcherOptionsHelp = "命令:\n|cff00ff00/rt bw|r - 打开战斗日志窗口\n|cff00ff00/rt seg|r - 开始录制新的分段 (只限战斗中)\n|cff00ff00/rt bw s|r - 开始记录全局\n|cff00ff00/rt bw e|r - 结束全局日志\n*默认记录所有战斗或首领战斗，全局记录包括所有状态。"
L.BossWatcherTabSettings = "设置"
PH.BossWatcherSpellsFilterTooltip = "输入需过滤的技能ID或名称。多个条件以\";\"分隔。"
L.BossWatcherShowDamageToTarget = "显示伤害到目标"
PH.BossWatcherSeveral = "Several"
L.BossWatcherSpellsCount = "次数"
PH.BossWatcherDisableDeath = "禁用死亡记录"
L.BossWatcherSelect = "选择"
L.BossWatcherDeathDeath = "死亡"
L.BossWatcherDeathOverKill = "过量"
L.BossWatcherDeathOverHeal = "过量"
L.BossWatcherDeathBlocked = "格挡"
L.BossWatcherDeathAbsorbed = "吸收"
L.BossWatcherDeathMultistrike = "溅射"
L.BossWatcherDeathDamage = "伤害"
L.BossWatcherDeathHeal = "治疗"
L.BossWatcherDeathAuraAdd = "+光环"
L.BossWatcherDeathAuraRemove = "-光环"
L.BossWatcherDeathBuffsShow = "显示 buffs"
L.BossWatcherDeathDebuffsShow = "显示 debuffs"
L.BossWatcherDeathOn = ">"
L.BossWatcherDeath = "死亡"
PH.BossWatcherTabInterruptAndDispelShort = "打断,驱散"
PH.BossWatcherDeathBlacklist = "隐藏团队buffs/debuffs"
L.BossWatcherSchoolPhysical = "物理"
L.BossWatcherSchoolHoly = "神圣"
L.BossWatcherSchoolFire = "火焰"
L.BossWatcherSchoolNature = "自然"
L.BossWatcherSchoolFrost = "冰霜"
L.BossWatcherSchoolShadow = "暗影"
L.BossWatcherSchoolArcane = "奥术"
L.BossWatcherSchoolElemental = "元素"
L.BossWatcherSchoolChromatic = "溅射"
L.BossWatcherSchoolMagic = "魔法"
L.BossWatcherSchoolChaos = "混乱"
L.BossWatcherSchoolUnknown = "未知"
L.BossWatcherSchool = "伤害类型"
L.BossWatcherHidePrismatic = "隐藏法师\"幻灵晶体\""
L.BossWatcherHidePrismaticTooltip = "法师100级天赋技能"
L.BossWatcherDisablePrismatic = "隐藏法师\"幻灵晶体\"伤害"
PH.BossWatcherDisablePrismaticTooltip = "默认设置统计\"幻灵晶体\"伤害为过量。\n*用于克拉戈战斗"
PH.BossWatcherDamageDamageSpellToFriendly = "友方受到的技能伤害"
PH.BossWatcherDamageDamageSpellToHostile = "敌方受到的技能伤害"
PH.BossWatcherAurasMoreInfoText = "详细信息"
L.BossWatcherReportDPS = "每秒伤害"
L.BossWatcherReportCount = "次数"
L.BossWatcherReportHPS = "每秒治疗"
L.BossWatcherBuffsAndDebuffsFilterPets = "宠物和主人"
L.BossWatcherBuffsAndDebuffsFilterPetsFilterText = "忽略宠物和守卫"
L.BossWatcherBuffsAndDebuffsFilterNothing = "无"
L.BossWatcherSaveVariables = "保存所有数据(在重载用户界面/登出/切换人物后)"
PH.BossWatcherSaveVariablesWarring = "|cffff0000Be careful!|r 如果数据过大,此选项可能导致ExRT设定被重置"
L.BossWatcherSelectPower = "能量: "
L.BossWatcherGraphZoom = "缩放"
L.BossWatcherGraphZoomOnlyGraph = "只限图表"
L.BossWatcherGraphZoomGlobal = "完整数据"
L.BossWatcherGraphZoomReset = "重置缩放"
L.BossWatcherOptionImproved = "|cff66ff66高级战斗日志"
PH.BossWatcherOptionImprovedTooltip = "自动开始新的分段,战斗结束后你可以选择任何时间框架内的数据分析.\n占用高内存"
L.BossWatcherGraphicsTotalHPS = "总HPS"
L.BossWatcherDamageTooltipTargets = "伤害目标:"
L.BossWatcherDamageTooltipSources = "伤害来自:"
L.BossWatcherHealTooltipTargets = "治疗目标:"
L.BossWatcherHealTooltipSources = "治疗来自:"
L.BossWatcherDamageTooltipCastsCount = "施放次数"
L.BossWatcherDisableSavePositions = "不保存玩家位置"
L.BossWatcherPositions = "位置"
L.BossWatcherPositionsSlider = "时间"
L.BossWatcherPositionsHideMap = "隐藏地图"
L.BossWatcherHealReduction = "减伤"
L.BossWatcherHealReductionSpells = "技能减伤"
L.BossWatcherHealReductionPlusHealing = "减伤+治疗"
L.BossWatcherHealReductionPlusHealingSpells = "减伤+治疗技能"
PH.BossWatcherReductionDisable = "禁用减伤计算"
PH.BossWatcherGraphicsHoldShift = "按住SHIFT添加一个图标"
PH.BossWatcherGraphicsHoldCtrl = "按住 CTRL查看完整的治疗包括过量"
L.BossWatcherGraphicsTargets = "目标"
L.BossWatcherDropdownsHoldShiftSource = "按住 SHIFT 查看所有相同的名称的来源"
L.BossWatcherDropdownsHoldShiftDest = "按住SHIFT 查看具有相同名字的目标"
L.BossWatcherHealReductionChkTooltip = "显示闪避/招架/未命中提供的减伤\n警告！该数据只以同类型伤害基础计算，不完全准确。"
L.BossWatcherFromSpells = "减伤技能"
L.BossWatcherHealingTabTyrantVelhari = "暴君维哈里\n改变吸收治疗的计算方式。将该战斗中无\"裂伤之触\"debuff的玩家获得的吸收治疗统计为过量治疗。"
PH.BossWatcherBrokeTooltip = "打断某些效果, 如控制"

L.InspectViewerTalents = "天赋和雕纹"
L.InspectViewerInfo = "其他信息"
L.InspectViewerItems = "装备"
L.InspectViewerNoData = "无数据"
PH.InspectViewerEnabledTooltip = "当\""..L.cd2.."\" 激活时无法禁用"
L.InspectViewerRadiness = "准备就绪"
L.InspectViewerRaidIlvl = "团队装等"
PH.InspectViewerRaidIlvlData = "玩家: %d"
L.InspectViewerHaste = "急速"
L.InspectViewerMastery = "精通"
L.InspectViewerCrit = "暴击."
L.InspectViewerSpirit = "精神"
L.InspectViewerInt = "智力"
L.InspectViewerStr = "力量"
L.InspectViewerAgi = "敏捷"
L.InspectViewerSpd = "法术强度"
L.InspectViewerMS = "溅射"
L.InspectViewerVer = "全能"
L.InspectViewerLeech = "吸血"
L.InspectViewerBonusArmor = "护甲加成"
L.InspectViewerAvoidance = "闪避"
L.InspectViewerSpeed = "加速"
L.InspectViewerFilter = "筛选"
L.InspectViewerType = "护甲类型"
L.InspectViewerClass = "职业"
L.InspectViewerTypeCloth = "布甲"
L.InspectViewerTypeLeather = "皮甲"
L.InspectViewerTypeMail = "锁甲"
L.InspectViewerTypePlate = "板甲"
L.InspectViewerClear = "复位"
L.InspectViewerFilterShort = "~:"
PH.InspectViewerColorizeNoEnch = "高亮缺少附魔的装备"
PH.InspectViewerColorizeLowIlvl = "高亮等级%d以下的装备"
PH.InspectViewerColorizeNoGems = "高亮未镶嵌宝石的装备"
L.InspectViewerMoreInfo = "更多信息"
L.InspectViewerMoreInfoRaidSetup = "团队组成"
L.InspectViewerMoreInfoRole = "职责"
L.InspectViewerMoreInfoRoleTank = "坦克"
L.InspectViewerMoreInfoRoleMDD = "近战"
L.InspectViewerMoreInfoRoleRDD = "远程"
L.InspectViewerMoreInfoRoleHealer = "治疗"
L.InspectViewerColorizeNoTopEnch = "高亮低等级附魔或宝石的装备"
L.InspectViewerForce = "强制查看"

L.CoinsSpoilsOfPandariaWinTrigger = "系统复位，请不要关闭电源。"
PH.CoinsEmpty = "暂无数据"
PH.CoinsHelp = "团队副本拾取、R币历史记录"
L.CoinsClear = "清除所有数据"
L.CoinsClearPopUp = "确定清除所有数据？"
PH.CoinsShowMessage = "当有人使用了R币时显示个人信息"
PH.CoinsMessage = "%s 使用了R币"

L.ChatwindowName = "团队助手报告"
L.ChatwindowChatSelf = "自己"
L.ChatwindowChatSay = "说"
L.ChatwindowChatParty = "小队"
L.ChatwindowChatInstance = "副本队伍"
L.ChatwindowChatRaid = "团队"
L.ChatwindowChatWhisper = "密语"
L.ChatwindowChatWhisperTarget = "密语的目标"
L.ChatwindowChatGuild = "公会"
L.ChatwindowChatOfficer = "官员频道"
L.ChatwindowChannel = "频道"
L.ChatwindowNameEB = "名字 (密语)"
L.ChatwindowSend = "发送"
PH.ChatwindowHelp = ""

PH.ArrowTextLeft = "/rt arrow X Y\n/rt range NAME\n/rt arrowbuff BUFF\n\n/rt arrowplayer NAME\n/rt arrowthis\n/rt arrowhide\n\n|cFFFFFFFF* 箭头只作用于公会或RAID成员身上|r"
PH.ArrowTextRight = "- 箭头坐标 X Y (由 0 到 100)\n- 显示你和某玩家的距离\n- 箭头指向中技能玩家\n*(随buff名称或技能ID运行)\n- 箭头指向某玩家\n- 箭头指向你的当前位置\n- 隐藏箭头"
L.ArrowSetPoint = "设定位置"
L.ArrowResetPos = "重置位置"
L.ArrowFixate = "锁定箭头位置"
L.ArrowScale = "缩放"
L.ArrowAlpha = "透明度"
PH.ArrowTextBottom = "附加功能:\nGExRT.F.ArrowTextPlayer(\"名字\",字号) |cffffffff- 设置\"字号\"(默认16)大小的箭头指向名为\"名字\"的玩家|r\nGExRT.F.ArrowTextCoord(X,Y,字号) |cffffffff- 设置\"字号\"(默认16) 大小的箭头指向X,Y 坐标|r|n|n例如:|n"

L.MarksDisable = "开启"
L.MarksClear = "清除"
PH.MarksTooltip = "\"锁定\"名单玩家标记\n只能作用于队伍/团队成员。"

PH.LoggingEnable = "开启在下列副本自动记录战斗日志:"
PH.LoggingHelp1 = "战斗日志记录保存于游戏文件夹'Logs\\WoWCombatLog.txt'中。"
PH.LoggingStart = "ExRT: 开始内置战斗记录"
PH.LoggingEnd = "ExRT: 停止内置战斗记录"

PH.LootLinkEnable = "开启战利品通告"
PH.LootLinkSlashHelp = "聊天命令:\n|cffffffff/rt loot|r - 发送当前首领掉落到聊天"

PH.BattleResFix = "锁定"
L.BattleResAlpha = "透明度"
L.BattleResScale = "缩放"
L.BattleResHideTime = "隐藏时间"
PH.BattleResHelp = "战斗复活图标将显示在RAID战斗中"
PH.BattleResHideTimeTooltip = "如果你使用omicc插件则图标隐藏数字"
L.BattleResHideCD = "隐藏CD动画"

L.SkadaDamageToCurrentTarget = "对当前目标的伤害"

L.LegendaryRingEnable = "发送|cffff7f00橙戒|r使用者名字到聊天"
L.LegendaryRingFrodo = "橙戒使用者"
L.LegendaryRingType = "显示戒指类型(治疗/坦克/输出)"

L.ProfilesIntro = "你可以通过选择配置方案,为每个角色设定不同的配置"
L.ProfilesDefault = "默认"
L.ProfilesChooseDesc = "你可以在框体内创建一个新的配置方案或选择一个配置方案"
L.ProfilesCurrent = "当前的配置方案:"
L.ProfilesNew = "新配置方案"
L.ProfilesAdd = "新建"
L.ProfilesSelect = "配置方案"
L.ProfilesCopy = "复制"
L.ProfilesDelete = "删除"
L.ProfilesDeleteAlert = "确定删除所选配置方案?"
L.ProfilesActivateAlert = "激活配置方案?"

L.senable = "开启"

L.minimaptooltiplmp = "左键-主窗口"
L.minimaptooltiprmp = "右键-菜单"
L.minimaptooltipfree = "Shift+Alt+Left Click - 自由移动"
L.minimapmenu = "ExRT菜单"
L.minimapmenuset = "设置"
L.minimapmenuclose = "关闭"

L.classLocalizate = {
	["WARRIOR"] = "战士",
	["PALADIN"] = "圣骑士",
	["HUNTER"] = "猎人",
	["ROGUE"] = "潜行者",
	["PRIEST"] = "牧师",
	["DEATHKNIGHT"] = "死亡骑士",
	["SHAMAN"] = "萨满",
	["MAGE"] = "法师",
	["WARLOCK"] = "术士",
	["MONK"] = "武僧",
	["DRUID"] = "德鲁伊",
	["PET"] = "宠物",
	["NO"] = "特殊",
	["ALL"] = "所有",
}

L.specLocalizate = {
	["MAGEDPS1"] = "奥术",
	["MAGEDPS2"] = "火焰",
	["MAGEDPS3"] = "冰霜",
	["PALADINHEAL"] = "神圣",
	["PALADINTANK"] = "防护",
	["PALADINDPS"] = "惩戒",
	["WARRIORDPS1"] = "武器",
	["WARRIORDPS2"] = "狂暴",
	["WARRIORTANK"] = "防御",
	["DRUIDDPS1"] = "平衡",
	["DRUIDDPS2"] = "野性",
	["DRUIDTANK"] = "守护",
	["DRUIDHEAL"] = "恢复",
	["DEATHKNIGHTTANK"] = "鲜血",
	["DEATHKNIGHTDPS1"] = "冰霜",
	["DEATHKNIGHTDPS2"] = "邪恶",
	["HUNTERDPS1"] = "兽王",
	["HUNTERDPS2"] = "射击",
	["HUNTERDPS3"] = "生存",
	["PRIESTHEAL1"] = "戒律",
	["PRIESTHEAL2"] = "神圣",
	["PRIESTDPS"] = "暗影",
	["ROGUEDPS1"] = "刺杀",
	["ROGUEDPS2"] = "战斗",
	["ROGUEDPS3"] = "敏锐",
	["SHAMANDPS1"] = "元素",
	["SHAMANDPS2"] = "增强",
	["SHAMANHEAL"] = "恢复",
	["WARLOCKDPS1"] = "痛苦",
	["WARLOCKDPS2"] = "恶魔",
	["WARLOCKDPS3"] = "毁灭",
	["MONKTANK"] = "酒仙",
	["MONKDPS"] = "风行",
	["MONKHEAL"] = "织雾",
	["NO"] = "所有天赋",
}

L.creatureNames = {	--> Used LibBabble-CreatureType and WowHead
	Aberration = "畸变怪",
	Abyssal = "深渊魔",
	Basilisk = "石化蜥蜴",
	Bat = "蝙蝠",
	Bear = "熊",
	Beast = "野兽",
	Beetle = "甲虫",
	["Bird of Prey"] = "猛禽",
	Boar = "野猪",
	["Carrion Bird"] = "食腐鸟",
	Cat = "豹",
	Chimaera = "奇美拉",
	Clefthoof = "裂蹄牛",
	["Core Hound"] = "熔岩犬",
	Crab = "螃蟹",
	Crane = "鹤",
	Critter = "小动物",
	Crocolisk = "鳄鱼",
	Demon = "恶魔",
	Devilsaur = "魔暴龙",
	Direhorn = "恐角龙",
	Dog = "狗",
	Doomguard = "末日守卫",
	Dragonhawk = "龙鹰",
	Dragonkin = "龙类",
	Elemental = "元素生物",
	Felguard = "恶魔卫士",
	Felhunter = "地狱猎犬",
	["Fel Imp"] = "邪能小鬼",
	Fox = "狐狸",
	["Gas Cloud"] = "气体云雾",
	Ghoul = "食尸鬼",
	Giant = "巨人",
	Goat = "山羊",
	Gorilla = "猩猩",
	Humanoid = "人型生物",
	Hydra = "多头蛇",
	Hyena = "土狼",
	Imp = "小鬼",
	Mechanical = "机械",
	Monkey = "猴子",
	Moth = "蛾子",
	["Nether Ray"] = "虚空鳐",
	["Non-combat Pet"] = "非战斗宠物",
	["Not specified"] = "未指定",
	Observer = "眼魔",
	Porcupine = "箭猪",
	Quilen = "魁麟",
	Raptor = "迅猛龙",
	Ravager = "掠食者",
	["Remote Control"] = "远程控制",
	Rhino = "犀牛",
	Riverbeast = "淡水兽",
	Rylak = "双头飞龙",
	Scorpid = "蝎子",
	Serpent = "蛇",
	["Shale Spider"] = "页岩蜘蛛",
	Shivarra = "破坏魔",
	Silithid = "异种虫",
	Spider = "蜘蛛",
	["Spirit Beast"] = "灵魂兽",
	Sporebat = "孢子蝠",
	Stag = "雄鹿",
	Succubus = "魅魔",
	Tallstrider = "陆行鸟",
	Terrorguard = "恐惧卫士",
	Totem = "图腾",
	Turtle = "海龟",
	Undead = "亡灵",
	Voidlord = "虚空领主",
	Voidwalker = "虚空行者",
	["Warp Stalker"] = "迁跃捕猎者",
	Wasp = "巨蜂",
	["Water Elemental"] = "水元素",
	["Water Strider"] = "水黾",
	["Wild Pet"] = "野生宠物",
	["Wind Serpent"] = "风蛇",
	Wolf = "狼",
	Worm = "蠕虫",
	Wrathguard = "愤怒卫士",
	[1] = "坚韧",
	[2] = "狡诈",
	[3] = "狂野",
}

L.TranslateBy = "御天缺-神罚之城"