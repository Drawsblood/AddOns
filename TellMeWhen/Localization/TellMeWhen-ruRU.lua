﻿--[[ Credit for these translations goes to:
	StingerSoft
	Alphabot
	zuko3d
	Ivlin
	Ant1dotE
	KizEY
--]]
local L = LibStub("AceLocale-3.0"):NewLocale("TellMeWhen", "ruRU", false)
if not L then return end


L["ACTIVE"] = "% активно" -- Needs review
L["AIR"] = "Воздух" -- Needs review
L["ALLOWCOMM"] = "Разрешить импорт данных" -- Needs review
L["ALLOWVERSIONWARN"] = "Сообщать о новой версии" -- Needs review
L["ALPHA"] = "Альфа" -- Needs review
L["ANIM_COLOR"] = "Цвет/Прозрачность" -- Needs review
L["ANIM_PERIOD"] = "Период Вспышки" -- Needs review
L["ANN_CHANTOUSE"] = "Исп. канал" -- Needs review
L["ANN_EDITBOX"] = "Выводимый текст" -- Needs review
L["ANN_EDITBOX_DESC"] = "Введите текст, который будет выводиться при определенном событии. Могут быть использованы стандартные замещения: \"%t\" для вашей цели и \"%f\" для вашего фокуса." -- Needs review
L["ANN_EDITBOX_WARN"] = "Наберите текст для отображения в этом месте" -- Needs review
L["ANN_SHOWICON"] = "Показать текстуру значка" -- Needs review
L["ANN_SHOWICON_DESC"] = "Некоторые текстовые поля могут отображать помимо текста текстуры. Установите эту опцию для включения данной особенности." -- Needs review
L["ANN_STICKY"] = "Прилипание" -- Needs review
L["ANN_SUB_CHANNEL"] = "Подраздел" -- Needs review
L["ANN_TAB"] = "Извещения" -- Needs review
L["ANN_WHISPERTARGET"] = "Шепнуть цели" -- Needs review
L["ANN_WHISPERTARGET_DESC"] = "Введите имя игрока которому вы хотите шепнуть. Игрок должен быть с вашего сервера и одной фракции с вами." -- Needs review
L["ASCENDING"] = "Восходящий" -- Needs review
L["ASPECT"] = "Аспект" -- Needs review
L["AURA"] = "Аура" -- Needs review
L["BACK_IE"] = "назад" -- Needs review
L["BleedDamageTaken"] = "Получаемый урон от кровотечения"
L["Bleeding"] = "Кровотечение"
L["BonusAgiStr"] = "+ к ловкости / силе"
L["BonusArmor"] = "+ к броне"
L["BonusMana"] = "+ к запасу маны"
L["BonusStamina"] = "+ к выносливости"
L["BOTTOM"] = "Внизу"
L["BOTTOMLEFT"] = "Внизу слева"
L["BOTTOMRIGHT"] = "Внизу справа"
L["BUFFTOCHECK"] = "Бафф для проврки" -- Needs review
L["BurstManaRegen"] = "+ к резкому восполнению маны"
L["CASTERFORM"] = "Может произносить заклинания"
L["CENTER"] = "В центре"
L["CHAT_FRAME"] = "Область чата" -- Needs review
L["CHAT_MSG_CHANNEL"] = "Канал чата" -- Needs review
L["CHAT_MSG_CHANNEL_DESC"] = "Отображает в виде сообщения в канале чата (например Торговля или любой другой к которому вы присоединены)" -- Needs review
L["CHAT_MSG_SMART"] = "Умный чат" -- Needs review
L["CHAT_MSG_SMART_DESC"] = "Сообщение отображается в наиболее подходящем канале чата: Рейд, Группа, Поле сражения или Сказать." -- Needs review
L["CHECKORDER"] = "Порядок обновления" -- Needs review
L["CHOOSENAME_DIALOG"] = [=[Введите название или ID того, что хотите отслеживать на этой иконке. Можно добавить несколько названий (ID), разделяя их ';'.
Заклинания и предметы могут быть добавлены в данное поле ввода путем перетаскивания или нажатия на них Shift+ЛКМ.]=] -- Needs review
L["CHOOSENAME_DIALOG_DDDEFAULT"] = "Предопределенные наборы заклинаний"
L["CHOOSENAME_DIALOG_PETABILITIES"] = "|cFFFF5959Способности питомцев|r нужно указывать в виде идентификаторов (SpellID)." -- Needs review
L["CHOOSENAME_EQUIVS_TOOLTIP"] = "Вы можете выбрать заранее определенный набор баффов / дебаффов или типы снятия(Магии, Проклятия и т.д.) в этом меню для ввода в \"%s\"." -- Needs review
L["CLEU_"] = "Любое событие" -- Needs review
L["CLEU_CAT_AURA"] = "Бафф/Дебафф" -- Needs review
L["CLEU_CAT_CAST"] = "Каст" -- Needs review
L["CLEU_CAT_MISC"] = "Разное" -- Needs review
L["CLEU_CAT_SPELL"] = "Заклинание" -- Needs review
L["CLEU_CAT_SWING"] = "мили/рендж" -- Needs review
L["CLEU_DIED"] = "Смерть" -- Needs review
L["CLEU_EVENTS"] = "Событие для проверки" -- Needs review
L["CLEU_EVENTS_ALL"] = "Все" -- Needs review
L["CLEU_FLAGS_DEST"] = "Исключения" -- Needs review
L["CLEU_FLAGS_SOURCE"] = "Исключения" -- Needs review
L["CLEU_HEADER"] = "Фильтры событий боя" -- Needs review
L["CLEU_SPELL_AURA_REMOVED"] = "аура удалена" -- Needs review
L["CLEU_SPELL_DAMAGE"] = "заклинаний магии" -- Needs review
L["CLEU_SPELL_DISPEL"] = "диспел" -- Needs review
L["CLEU_SPELL_HEAL"] = "Лечение" -- Needs review
L["CLEU_SPELL_INSTAKILL"] = "Мгновенное убийство" -- Needs review
L["CLEU_SPELL_INTERRUPT"] = "Прерывание - Заклинание прервано" -- Needs review
L["CLEU_SPELL_MISSED"] = "Промах заклинания" -- Needs review
L["CLEU_SPELL_PERIODIC_DAMAGE"] = "Периодический урон" -- Needs review
L["CLEU_SPELL_REFLECT"] = "Отражение заклинания" -- Needs review
L["CMD_OPTIONS"] = "Параметры"
L["CNDTCAT_ATTRIBUTES_PLAYER"] = "Свойства игрока" -- Needs review
L["CNDTCAT_ATTRIBUTES_UNIT"] = "Свойства объекта" -- Needs review
L["CNDTCAT_BUFFSDEBUFFS"] = "Баффы/Дебаффы" -- Needs review
L["CNDTCAT_CURRENCIES"] = "Деньги" -- Needs review
L["CNDTCAT_FREQUENTLYUSED"] = "Часто используемый" -- Needs review
L["CNDTCAT_RESOURCES"] = "Ресурсы" -- Needs review
L["CNDTCAT_SPELLSABILITIES"] = "Заклинания/Предметы" -- Needs review
L["CNDTCAT_STATS"] = "Характеристики" -- Needs review
L["COLOR_COLOR"] = "Цвет" -- Needs review
L["COLOR_OVERRIDEDEFAULT"] = "Переопределить" -- Needs review
L["COMPARISON"] = "Сравнение" -- Needs review
L["CONDITIONALPHA"] = "Усл./треб. не соблюдено" -- Needs review
L["CONDITIONALPHA_DESC"] = "Эта установка будет использоваться когда условия или требования для значка не соблюдены. Эта установка игнорируется если значок уже скрыт другими установками прозрачности." -- Needs review
L["CONDITIONORMETA_CHECKINGINVALID_GROUP"] = "Внимание! В группе %d проверяется неправильный значок (группа %d, значок %d)" -- Needs review
L["CONDITIONPANEL_ADD"] = "Добавить условие" -- Needs review
L["CONDITIONPANEL_ALIVE"] = "Цель жива"
L["CONDITIONPANEL_ALIVE_DESC"] = "Это условие исполняется если указанная цель жива."
L["CONDITIONPANEL_ALTPOWER"] = "Альтернативный ресурс" -- Needs review
L["CONDITIONPANEL_AND"] = "и"
L["CONDITIONPANEL_ANDOR"] = "и/или"
L["CONDITIONPANEL_ANDOR_DESC"] = "Нажмите для переключения между операторами И/ИЛИ" -- Needs review
L["CONDITIONPANEL_CLASS"] = "Класс объекта" -- Needs review
L["CONDITIONPANEL_CLASSIFICATION"] = "Тип объекта" -- Needs review
L["CONDITIONPANEL_COMBAT"] = "Объект в бою"
L["CONDITIONPANEL_COMBO"] = "Длина серии приемов"
L["CONDITIONPANEL_DEFAULT"] = "Выберите тип ..." -- Needs review
L["CONDITIONPANEL_ECLIPSE_DESC"] = [=[Затмение друида имеет диапазон от -100 (лунное затмение) до 100 (солнечное затмение).
Введите -80 если вы хотите чтобы значок сработал  при значении лунной силы равной 80.]=]
L["CONDITIONPANEL_EQUALS"] = "равно"
L["CONDITIONPANEL_EXISTS"] = "Цель существует"
L["CONDITIONPANEL_GREATER"] = "Больше" -- Needs review
L["CONDITIONPANEL_GREATEREQUAL"] = "Больше или равно" -- Needs review
L["CONDITIONPANEL_GROUPTYPE"] = "Тип группы" -- Needs review
L["CONDITIONPANEL_ICON"] = "Показать значок"
L["CONDITIONPANEL_ICON_DESC"] = [=[Проверка условий работает только если прозрачность иконки больше 0. 
Если необходимо скрыть значок, но при этом вести проверку условий, установите параметр %q в настройках прозрачности значка.
Для проверки условий значка группа в которой он находится также должна отбражаться.]=] -- Needs review
L["CONDITIONPANEL_ICON_HIDDEN"] = "Скрыт" -- Needs review
L["CONDITIONPANEL_ICON_SHOWN"] = "Отображается" -- Needs review
L["CONDITIONPANEL_INSTANCETYPE"] = "Тип подземелья"
L["CONDITIONPANEL_INTERRUPTIBLE"] = "Можно прервать" -- Needs review
L["CONDITIONPANEL_LESS"] = "Меньше"
L["CONDITIONPANEL_LESSEQUAL"] = "Меньше или равно"
L["CONDITIONPANEL_LEVEL"] = "Уровень объекта"
L["CONDITIONPANEL_MOUNTED"] = "На транспорте"
L["CONDITIONPANEL_NAME"] = "Название объекта"
L["CONDITIONPANEL_NAMETOMATCH"] = "Имя равно" -- Needs review
L["CONDITIONPANEL_NAMETOOLTIP"] = "Вы можете указать несколько имен для проверки разделив их точкой с запятой (;). Условие считается выполненным если совпало хотя одно имя." -- Needs review
L["CONDITIONPANEL_NOTEQUAL"] = "Не равно"
L["CONDITIONPANEL_OPERATOR"] = "Оператор"
L["CONDITIONPANEL_OR"] = "Или" -- Needs review
L["CONDITIONPANEL_PETSPEC"] = "специализация питомца" -- Needs review
L["CONDITIONPANEL_PETTREE"] = "Дерево талантов питомца" -- Needs review
L["CONDITIONPANEL_POWER"] = "Основной ресурс"
L["CONDITIONPANEL_POWER_DESC"] = [=[Будет проверять энергию, если цель - друид в форме кошки, 
ярость - если цель воин, и т.д.]=]
L["CONDITIONPANEL_PVPFLAG"] = "Объект с меткой PvP"
L["CONDITIONPANEL_REMOVE"] = "Удалить это условие"
L["CONDITIONPANEL_RESTING"] = "Отдыхает" -- Needs review
L["CONDITIONPANEL_ROLE"] = "Роль игорка" -- Needs review
L["CONDITIONPANEL_SWIMMING"] = "Плавание"
L["CONDITIONPANEL_TYPE"] = "Тип"
L["CONDITIONPANEL_UNIT"] = "Цель"
L["CONDITIONPANEL_UNITISUNIT"] = "Объект равен" -- Needs review
L["CONDITIONPANEL_UNITISUNIT_DESC"] = "Это условие выполнено если объект в первом поле ввода совпадает с объектом во втором поле ввода." -- Needs review
L["CONDITIONPANEL_UNITISUNIT_EBDESC"] = "Введите объект для сравнения с объектом в первом поле ввода." -- Needs review
L["CONDITIONPANEL_VALUEN"] = "Значение"
L["CONDITIONPANEL_VEHICLE"] = "Объект на сред. передвижения" -- Needs review
L["CONDITIONS"] = "Условия" -- Needs review
L["CONDITION_TIMERS_HEADER"] = "Таймеры" -- Needs review
L["CONFIGMODE"] = "TellMeWhen в режиме настройки. Значки не будут работать до выхода из режим настройки. Наберите /tmw для включения/выключения режима настройки." -- Needs review
L["CONFIGMODE_EXIT"] = "Выйти из режима настройки" -- Needs review
L["CONFIGMODE_NEVERSHOW"] = "Больше не показывать" -- Needs review
L["CONFIGPANEL_CLEU_HEADER"] = "Боевые события" -- Needs review
L["COPYGROUP"] = "Копировать всю группу" -- Needs review
L["COPYPOSSCALE"] = "Копировать расположение/масштаб" -- Needs review
L["CREATURETYPE_1"] = "Животное"
L["CREATURETYPE_10"] = "Не указано"
L["CREATURETYPE_11"] = "Тотем"
L["CREATURETYPE_12"] = "Спутник"
L["CREATURETYPE_13"] = "Облако газа"
L["CREATURETYPE_14"] = "Дикий питомец"
L["CREATURETYPE_2"] = "Дракон"
L["CREATURETYPE_3"] = "Демон"
L["CREATURETYPE_4"] = "Элементаль"
L["CREATURETYPE_5"] = "Великан"
L["CREATURETYPE_6"] = "Нежить"
L["CREATURETYPE_7"] = "Гуманоид"
L["CREATURETYPE_8"] = "Существо"
L["CREATURETYPE_9"] = "Механизм"
L["CrowdControl"] = "Контроль" -- Needs review
L["Curse"] = "Проклятье"
L["DAMAGER"] = "Урон" -- Needs review
L["DEBUFFTOCHECK"] = "Дебафф для проверки" -- Needs review
L["DEFAULT"] = "По умолчанию" -- Needs review
L["DESCENDING"] = "Нисходящий" -- Needs review
L["DISABLED"] = "Отключено"
L["Disarmed"] = "Обезоружен"
L["Disease"] = "Болезнь"
L["Disoriented"] = "Дезориентация"
L["DR-Banish"] = "Изгнание" -- Needs review
L["DR-Cyclone"] = "Смерч" -- Needs review
L["DR-Disarm"] = "Обезоруживание" -- Needs review
L["DR-Disorient"] = "Ослепление" -- Needs review
L["DR-DragonsBreath"] = "Дыхание дракона" -- Needs review
L["DR-Entrapment"] = "На изготовку!" -- Needs review
L["DR-MindControl"] = "Контроль над разумом" -- Needs review
L["DT_DOC_Opacity"] = "Возвращает непрозрачность значка. Возвращаемое значение между 0 и 1." -- Needs review
L["DURATION"] = "Продолжительность" -- Needs review
L["EARTH"] = "Земля" -- Needs review
L["ECLIPSE_DIRECTION"] = "Направление затмения"
L["elite"] = "Элитный" -- Needs review
L["ENABLINGOPT"] = "Дополнение TellMeWhen_Options отключено. Включаю ..." -- Needs review
L["Enraged"] = "Энрейдж" -- Needs review
L["ERROR_MISSINGFILE"] = "Для использования TellMeWhen %s необходима перезагрузка WoW (%s не найден). Перезагрузить WoW сейчас?" -- Needs review
L["EVENTS_SETTINGS_HEADER"] = "Настройки события" -- Needs review
L["EVENTS_SETTINGS_ONLYSHOWN"] = "Обрабатывать только если значок отображается" -- Needs review
L["EXPORT_f"] = "Экспорт %s" -- Needs review
L["EXPORT_HEADING"] = "Экспорт" -- Needs review
L["EXPORT_TOCOMM"] = "Игроку" -- Needs review
L["EXPORT_TOCOMM_DESC"] = "Введите имя игрока и выберите эту опцию чтобы переслать ему настройки. Игрок должен быть доступен для команды /whisper (та же фракция и сервер что и вы, быть в онлайне) и обладать TellMeWhen версии 4.0.0 и выше " -- Needs review
L["EXPORT_TOGUILD"] = "в Гильдию" -- Needs review
L["EXPORT_TORAID"] = "в рейд" -- Needs review
L["EXPORT_TOSTRING"] = "В строку" -- Needs review
L["EXPORT_TOSTRING_DESC"] = "Строка содержащая настройки которые впоследствии можно будет импортировать в поле ввода. Чтобы скопировать ее нажмите Ctrl+C, после чего ее можно вставить в текстовый файл, e-mail и т.д. при помощи Ctrl+V." -- Needs review
L["FALSE"] = "Неверно"
L["Feared"] = "Страх"
L["fGROUP"] = "Группа: %s" -- Needs review
L["fICON"] = "Значок: %s" -- Needs review
L["FIRE"] = "Огонь" -- Needs review
L["FONTCOLOR"] = "Цвет шрифта" -- Needs review
L["FONTSIZE"] = "Размер шрифта" -- Needs review
L["FORWARDS_IE"] = "вперед" -- Needs review
L["fPROFILE"] = "Профиль: %s" -- Needs review
L["FROMNEWERVERSION"] = "Вы импортируете данные созданные в более новой версии TellMeWhen. Некоторые установки не будут работать пока вы не обновите TellMeWhen до последней версии." -- Needs review
L["fTEXTLAYOUT"] = "Расположение текста: %s" -- Needs review
L["GCD"] = "Глобальная перезарядка" -- Needs review
L["GCD_ACTIVE"] = "GCD активен" -- Needs review
L["GENERIC_NUMREQ_CHECK_DESC"] = "Установите эту опцию чтобы включить и настроить %s" -- Needs review
L["GENERICTOTEM"] = "тотем %d" -- Needs review
L["GROUPADDONSETTINGS"] = "Настройки группы/модификации"
L["GROUPCONDITIONS"] = "Усл. группы" -- Needs review
L["GROUPICON"] = "Группа: %s, значок: %d"
L["HEALER"] = "Лекарь" -- Needs review
L["Heals"] = "Исцеления игрока"
L["HELP_EXPORT_DOCOPY_MAC"] = "Нажми |cff7fffffCMD+C|r , чтобы скопировать" -- Needs review
L["HELP_EXPORT_DOCOPY_WIN"] = "Нажми |cff7fffffCTRL+C|r , чтобы скопировать" -- Needs review
L["HELP_NOUNIT"] = "Добавьте объект!" -- Needs review
L["HELP_NOUNITS"] = "Нужно добавить хотя бы один объект!" -- Needs review
L["HELP_POCKETWATCH"] = [=[|TInterface\Icons\INV_Misc_PocketWatch_01:20|t - Значок часов.
Этот значок отображается когда заклинание проверяемое по имени отсутствует в вашей книге заклинаний.
Для отображения правильного значка измените имя заклинания на Spell ID (нажмите ЛКМ на имени в поле ввода, выберите правильное заклинание в списке подсказок и нажмите на нем ПКМ)
]=] -- Needs review
L["ICON"] = "Значок" -- Needs review
L["ICONALPHAPANEL_FAKEHIDDEN"] = "Всегда скрывать"
L["ICONALPHAPANEL_FAKEHIDDEN_DESC"] = "Скрывает значок, оставляя его активным, что позволяет условиям других значков использовать его." -- Needs review
L["ICONGROUP"] = "Значок: %s (группа: %s)" -- Needs review
L["ICONMENU_ABSENT"] = "Отсутствует"
L["ICONMENU_ADDMETA"] = "Добавить к мета-значку" -- Needs review
L["ICONMENU_ALPHA"] = "Прозрачность"
L["ICONMENU_ALWAYS"] = "Всегда"
L["ICONMENU_BOTH"] = "Любой"
L["ICONMENU_BUFF"] = "Баф" -- Needs review
L["ICONMENU_BUFFDEBUFF"] = "Бафф / дебафф" -- Needs review
L["ICONMENU_BUFFDEBUFF_DESC"] = "Отслеживает баффы и/или дебаффы." -- Needs review
L["ICONMENU_BUFFTYPE"] = "Бафф или дебафф?" -- Needs review
L["ICONMENU_CAST"] = "Применение"
L["ICONMENU_CASTS"] = "Применение заклинаний"
L["ICONMENU_CHOOSENAME_ITEMSLOT_DESC"] = [=[Введите одно(или несколько, разделенных точкой с запятой) имён, ID или ячеек снаряжения которые будет отслеживать этот значок.
Ячейки снаряжения - это номера соответствующие предметам надетым на персонаже (голова, шея и т.д.). При изменении предмета в ячейке снаряжения соответствующее изменение произойдет и в значке.
Для добавления предмета/заклинания в это поле ввода можно нажать на нём  Shift + ЛКМ или просто перетащить его сюда мышью.]=] -- Needs review
L["ICONMENU_CHOOSENAME_MULTISTATE"] = "Выберите имя/ID для проверки" -- Needs review
L["ICONMENU_CHOOSENAME_ORBLANK"] = "или оставьте пустым чтобы отслеживать всё" -- Needs review
L["ICONMENU_CHOOSENAME_WPNENCH"] = "Выберите улучшение для проверки" -- Needs review
L["ICONMENU_CLEU"] = "Боевые события" -- Needs review
L["ICONMENU_CNDTIC"] = "Значок-условие" -- Needs review
L["ICONMENU_CNDTIC_DESC"] = "Отслеживает состояние условий." -- Needs review
L["ICONMENU_COMPONENTICONS"] = "Составные значки" -- Needs review
L["ICONMENU_COOLDOWNCHECK"] = "Проверять восстановление?"
L["ICONMENU_COOLDOWNCHECK_DESC"] = "Включить изменение цвета иконки, когда контратакующая способность на восстановлении"
L["ICONMENU_COPYHERE"] = "Копировать сюда"
L["ICONMENU_CUSTOMTEX"] = "Пользовательская текстура" -- Needs review
L["ICONMENU_DEBUFF"] = "Дебаф" -- Needs review
L["ICONMENU_DISPEL"] = "Тип развеивания"
L["ICONMENU_DONTREFRESH"] = "Не обновлять" -- Needs review
L["ICONMENU_DURATION_MAX_DESC"] = "Максимальный срок действия для отображения иконки"
L["ICONMENU_DURATION_MIN_DESC"] = "Минимальная срок действия для отображения иконки"
L["ICONMENU_ENABLE"] = "Включено" -- Needs review
L["ICONMENU_FOCUS"] = [=[Фокус
]=] -- Needs review
L["ICONMENU_FOCUSTARGET"] = "Цель фокуса"
L["ICONMENU_FRIEND"] = "Дружественный"
L["ICONMENU_GHOUL"] = "Не-ПВ вурдалак" -- Needs review
L["ICONMENU_GHOUL_DESC"] = "Отслеживает вашего вурдалака если у вас нет таланта %s." -- Needs review
L["ICONMENU_HIDEUNEQUIPPED"] = "Спрятать, когда слот свободен" -- Needs review
L["ICONMENU_HIDEUNEQUIPPED_DESC"] = "При установке этой опции значок будет скрыт если проверяемый слот оружия пуст" -- Needs review
L["ICONMENU_HOSTILE"] = "Враждебный"
L["ICONMENU_ICD"] = "Внутренний кулдаун"
L["ICONMENU_ICDBDE"] = "Бафф/Дебаф/Энергия" -- Needs review
L["ICONMENU_ICDTYPE"] = "Срабатывает от"
L["ICONMENU_IGNORENOMANA"] = "Игнорировать нехватку энергии" -- Needs review
L["ICONMENU_IGNORERUNES"] = "Игнорирование рун"
L["ICONMENU_IGNORERUNES_DESC_DISABLED"] = "Для включения опции \"Игнорировать руны\" необходимо включить опцию \"Проверять восстановление\"" -- Needs review
L["ICONMENU_INVERTBARS"] = "Заполнение полосок вверх"
L["ICONMENU_ITEMCOOLDOWN"] = "Восстановление предмета" -- Needs review
L["ICONMENU_ITEMCOOLDOWN_DESC"] = "Отслеживает восстановление предметов."
L["ICONMENU_MANACHECK"] = "Проверять энергию?"
L["ICONMENU_MANACHECK_DESC"] = "Включить изменение цвета иконки при недостатке маны/ярости/рунической силы/и т.д."
L["ICONMENU_META"] = "Мета-значок" -- Needs review
L["ICONMENU_META_DESC"] = [=[Объединяет несколько значков в один.
Значки у которых установлено %q будут отображаться в мета-значке так же, как если бы они отображались самостоятельно.]=] -- Needs review
L["ICONMENU_MOUSEOVER"] = "Курсор мыши над"
L["ICONMENU_MOUSEOVERTARGET"] = "Цель под курсором мыши"
L["ICONMENU_MOVEHERE"] = "Переместить сюда"
L["ICONMENU_MUSHROOMS_DESC"] = "Отслеживает %s." -- Needs review
L["ICONMENU_OFFS"] = "Отступ" -- Needs review
L["ICONMENU_ONLYBAGS"] = "Только если в сумках" -- Needs review
L["ICONMENU_ONLYEQPPD"] = "Только если одето"
L["ICONMENU_ONLYEQPPD_DESC"] = "Установите эту опцию для отображения значка только если предмет надет на персонаже."
L["ICONMENU_ONLYIFCOUNTING"] = "Показывать только если таймер активен" -- Needs review
L["ICONMENU_ONLYINTERRUPTIBLE"] = "Только прерываемое"
L["ICONMENU_ONLYINTERRUPTIBLE_DESC"] = "Установите эту опцию для показа только прерываемых заклинаний." -- Needs review
L["ICONMENU_ONLYMINE"] = "Показывать только если это мое заклинание" -- Needs review
L["ICONMENU_ONLYMINE_DESC"] = "При установке этой опции значок будет проверять только ваши собственные баффы/дебаффы" -- Needs review
L["ICONMENU_PETTARGET"] = "Цель питомца"
L["ICONMENU_PRESENT"] = "Присутствует"
L["ICONMENU_RANGECHECK"] = "Проверять расстояние до объекта?"
L["ICONMENU_RANGECHECK_DESC"] = "Включить изменение цвета иконки, когда вы вне зоны досягаемости"
L["ICONMENU_REACT"] = "Реакция цели"
L["ICONMENU_REACTIVE"] = "Контратакующие заклинания" -- Needs review
L["ICONMENU_RUNES"] = "Восстановление руны" -- Needs review
L["ICONMENU_RUNES_DESC"] = "Отслеживает восстановление рун." -- Needs review
L["ICONMENU_SHOWTIMER"] = "Показывать таймер"
L["ICONMENU_SHOWTIMER_DESC"] = "При установке этой опции на значке будет отображаться стандартная круговая анимация восстановления" -- Needs review
L["ICONMENU_SHOWTIMERTEXT"] = "Показывать значение таймера"
L["ICONMENU_SHOWTIMERTEXT_DESC"] = "Применимо только если выбран параметр 'Показывать таймер' и установлен OmniCC (или аналог)." -- Needs review
L["ICONMENU_SHOWTTTEXT"] = "Показать текст переменной" -- Needs review
L["ICONMENU_SHOWWHEN"] = "Показывать значок когда"
L["ICONMENU_SPELLCOOLDOWN"] = "Восстановление заклинания" -- Needs review
L["ICONMENU_SPELLCOOLDOWN_DESC"] = "Отслеживает восстановление заклинаний." -- Needs review
L["ICONMENU_STACKS_MAX_DESC"] = "Максимальное количество стаков, необходимое для отображения значка" -- Needs review
L["ICONMENU_STACKS_MIN_DESC"] = "Минимальное количество стаков, необходимое для отображения значка" -- Needs review
L["ICONMENU_SWAPWITH"] = "Обменять с" -- Needs review
L["ICONMENU_TARGETTARGET"] = "Цель цели"
L["ICONMENU_TOTEM"] = "Тотем/не-ПВ вурдалак"
L["ICONMENU_TOTEM_DESC"] = "Отслеживает ваши тотемы." -- Needs review
L["ICONMENU_TYPE"] = "Тип иконки"
L["ICONMENU_UNITCOOLDOWN"] = "Восстановление объекта"
L["ICONMENU_UNITCOOLDOWN_DESC"] = [=[Отслеживает время восстановления заклинания, предмета и т.д. у другого объекта.
%s можно отслеживать используя %q в качестве имени.]=] -- Needs review
L["ICONMENU_UNIT_DESC"] = [=[Введите название объекта для отслеживания. Объекты могут быть выбраны из выпадающего списка справа или добавлены вручную. Могут быть использованы стандартные имена (например, player) или имена дружественных объектов (например, %s). Множественные имена объектов должны быть разделены точкой с запятой (;).
Для большей информации о объектах посетите http://www.wowpedia.org/UnitId]=] -- Needs review
L["ICONMENU_UNITS"] = "Объекты"
L["ICONMENU_UNITSTOWATCH"] = "Наблюдаемый объект"
L["ICONMENU_UNUSABLE"] = "Недоступно"
L["ICONMENU_USABLE"] = "Доступно"
L["ICONMENU_VEHICLE"] = "Средство передвижения"
L["ICONMENU_WPNENCHANT"] = "Временные чары на оружии"
L["ICONMENU_WPNENCHANT_DESC"] = "Отслеживает временные улучшения на оружии" -- Needs review
L["ICONMENU_WPNENCHANTTYPE"] = "Слот оружия для слежения"
L["IconModule_Texture_ColoredTexture"] = "текстура" -- Needs review
L["ICONTOCHECK"] = "Значок для проверки"
L["ICON_TOOLTIP1"] = "TellMeWhen"
L["ICON_TOOLTIP2NEW"] = [=[|cff7fffffПКМ|r для свойств значка.
|cff7fffffПКМ и тащите|r на другой значок для перемещения/копирования.
|cff7fffffТащите|r заклинание или предмет на значок для быстрого назначения свойств.]=] -- Needs review
L["ImmuneToMagicCC"] = "Невосприимчивость к контролю"
L["ImmuneToStun"] = "Невосприимчивость к эффектам оглушения"
L["IMPORTERROR_FAILEDPARSE"] = "При обработке строки произошла ошибка. Убедитесь что вы полностью скопировали строку из источника." -- Needs review
L["IMPORT_EXPORT"] = "Импорт/экспорт" -- Needs review
L["IMPORT_EXPORT_BUTTON_DESC"] = "Нажмите на этот список для импорта/экспорта значков, групп и профилей." -- Needs review
L["IMPORT_EXPORT_DESC"] = "Нажмите на стрелку выпадающего меню справа от поля ввода чтобы импортировать/экспортировать значки, группы и профили." -- Needs review
L["IMPORT_EXPORT_DESC_INLINE"] = "Импорт/экспорт профилей, групп и значков из строк, сохранение настроек." -- Needs review
L["IMPORT_FROMBACKUP"] = "Из архива" -- Needs review
L["IMPORT_FROMBACKUP_DESC"] = "Настройки буду восстановлены из архива: %s" -- Needs review
L["IMPORT_FROMBACKUP_WARNING"] = "Архив настроек: %s" -- Needs review
L["IMPORT_FROMCOMM"] = "От игрока" -- Needs review
L["IMPORT_FROMCOMM_DESC"] = "Если другой пользователь поделится с вами своими настройками, вы сможете импортировать их в этом меню." -- Needs review
L["IMPORT_FROMLOCAL"] = "Из профиля" -- Needs review
L["IMPORT_FROMSTRING"] = "Из строки" -- Needs review
L["IMPORT_FROMSTRING_DESC"] = [=[Строки позволяют пользователям обмениваться настройками TellMeWhen.
Для импорта настроек из строки скопируйте ее в буфер обмена (Ctrl+C), нажмите Ctrl+V находясь в поле ввода, после чего вернитесь в это меню. ]=] -- Needs review
L["IMPORT_HEADING"] = "Импорт настроек" -- Needs review
L["IMPORT_PROFILE"] = "Копировать профиль" -- Needs review
L["IMPORT_PROFILE_NEW"] = "Создать новый профиль" -- Needs review
L["IMPORT_PROFILE_OVERWRITE"] = "Переписать %s" -- Needs review
L["Incapacitated"] = "Обездвижен"
L["IncreasedAP"] = "+ к сила атаки"
L["IncreasedCrit"] = "+ к вероятности нанесения критического урона"
L["IncreasedDamage"] = "+ к наносимому урону"
L["IncreasedPhysHaste"] = "+ к скорости ближнего и дальнего боя"
L["IncreasedSpellHaste"] = "+ к скорости произнесения заклинаний"
L["IncreasedSPsix"] = "+ к силе заклинаний (6%)"
L["IncreasedSPten"] = "+ к силе заклинаний (10%)"
L["IncreasedStats"] = "+ к характеристикам"
L["ITEMCOOLDOWN"] = "Восстановление предмета" -- Needs review
L["ITEMEQUIPPED"] = "Предмет надет" -- Needs review
L["ITEMTOCHECK"] = "Предмет для проверки" -- Needs review
L["LAYOUTDIRECTION_1"] = "Вправо потом вниз" -- Needs review
L["LAYOUTDIRECTION_2"] = "Влево потом вниз" -- Needs review
L["LAYOUTDIRECTION_3"] = "Влево потом вверх" -- Needs review
L["LAYOUTDIRECTION_4"] = "Вправо потом вверх" -- Needs review
L["LAYOUTDIRECTION_5"] = "Вниз потом вправо" -- Needs review
L["LAYOUTDIRECTION_6"] = "Вниз потом влево" -- Needs review
L["LAYOUTDIRECTION_7"] = "Вверх потом влево" -- Needs review
L["LAYOUTDIRECTION_8"] = "Вверх потом вправо" -- Needs review
L["LDB_TOOLTIP1"] = "|cff7fffffЩелкните мышью|r для переключения блокировки групп"
L["LDB_TOOLTIP2"] = "|cff7fffffЩелкните ПКМ|r для того чтобы показать/скрыть указанные группы"
L["LEFT"] = "Влево"
L["LOADERROR"] = "Дополнение TellMeWhen_Options не может быть загружено:" -- Needs review
L["LOCKED"] = "Закреплено"
L["Magic"] = "Магия"
L["MAIN"] = "Основное"
L["!!Main Addon Description"] = "Визуальные, звуковые и текстовые оповещения о готовности заклинаний, способностей, наличии баффов/дебаффов и многого другого." -- Needs review
L["MAINASSIST"] = "Главный помощник" -- Needs review
L["MAINTANK"] = "Осн. танк" -- Needs review
L["MAKENEWGROUP"] = "Создать новую группу" -- Needs review
L["ManaRegen"] = "+ к восполнению маны"
L["MESSAGERECIEVE"] = "%s прислал(а) вам строку данных TellMeWhen. Вы можете импортировать эти данные в TellMeWhen используя выпадающий список %q в редакторе значков." -- Needs review
L["MESSAGERECIEVE_SHORT"] = "%s прислал(а) вам строку данных TellMeWhen!" -- Needs review
L["META_ADDICON"] = "добавить иконку" -- Needs review
L["METAPANEL_DOWN"] = "Сместить вниз"
L["METAPANEL_REMOVE"] = "Удалить эту иконку"
L["METAPANEL_UP"] = "Сместить вверх"
L["MISCELLANEOUS"] = "Разное" -- Needs review
L["MOON"] = "Луна"
L["MP5"] = "%d MP5" -- Needs review
L["MUSHROOM"] = "Гриб %d" -- Needs review
L["MUSHROOMS"] = "Гриб для проверки" -- Needs review
L["NEWVERSION"] = "Доступна новая версия TellMeWhen: %s" -- Needs review
L["NONE"] = "Ничего из нижеперечисленного"
L["normal"] = "Обычный" -- Needs review
L["ONLYCHECKMINE"] = "Проверять только мои" -- Needs review
L["ONLYCHECKMINE_DESC"] = "Установите эту опцию для проверки только своих баффов/дебаффов" -- Needs review
L["OUTLINE_MONOCHORME"] = "Черно-белый" -- Needs review
L["OUTLINE_NO"] = "Без контура"
L["OUTLINE_THICK"] = "Толстый контур"
L["OUTLINE_THIN"] = "Тонкий контур"
L["OVERWRITEGROUP"] = "Перезаписать группу: %s" -- Needs review
L["PARENTHESIS_TYPE_("] = "открывающая" -- Needs review
L["PARENTHESIS_TYPE_)"] = "закрывающая" -- Needs review
L["PARENTHESIS_WARNING1"] = [=[Число открывающих и закрывающих скобок не совпадает.
Необходимо еще %d %s |4скобка:скобок;]=] -- Needs review
L["PARENTHESIS_WARNING2"] = [=[Недостаточно открывающих скобок!
Необходимо на %d больше открывающих скобок]=] -- Needs review
L["PET_TYPE_CUNNING"] = "Хитрость" -- Needs review
L["PET_TYPE_FEROCITY"] = "Свирепость" -- Needs review
L["PET_TYPE_TENACITY"] = "Упорство" -- Needs review
L["PhysicalDmgTaken"] = "Увеличивает получаемый физический урон"
L["PLAYER_DESC"] = "(Вы)" -- Needs review
L["Poison"] = "Яд"
L["PRESENCE"] = "Власть" -- Needs review
L["PushbackResistance"] = "+ к сокращению задержки при получении урона"
L["PvPSpells"] = "Контроль в PvP, и т.д."
L["rare"] = "Редкий" -- Needs review
L["rareelite"] = "Редкий Элитный" -- Needs review
L["REDO_ICON"] = "Повторить" -- Needs review
L["REDO_ICON_DESC"] = "Повторить изменения сделанные для этого значка. " -- Needs review
L["ReducedArmor"] = "Снижение показателя брони"
L["ReducedAttackSpeed"] = "Снижение скорости атаки"
L["ReducedCastingSpeed"] = "Снижение скорости произнесения заклинаний"
L["ReducedHealing"] = "Снижение эффективности исцеления"
L["ReducedPhysicalDone"] = "Снижение наносимого физического урона"
L["RESET_ICON"] = "Сброс" -- Needs review
L["Resistances"] = "+ к сопротивлению заклинаниям"
L["RESIZE"] = "Изменить размер"
L["RESIZE_TOOLTIP"] = "Чтобы изменить размер, нажмите и тащите " -- Needs review
L["RIGHT"] = "Вправа"
L["Rooted"] = "Корни"
L["RUNES"] = "Проверить руны" -- Needs review
L["RUNSPEED"] = "Скорость бега объекта" -- Needs review
L["SENDSUCCESSFUL"] = "Отправлено успешно" -- Needs review
L["SHAPESHIFT"] = "Изменение облика" -- Needs review
L["Shatterable"] = "Разбиваемо" -- Needs review
L["Silenced"] = "Немота"
L["Slowed"] = "Замедлен" -- Needs review
L["SOUND_CUSTOM"] = "Пользовательский звуковой файл" -- Needs review
L["SOUND_CUSTOM_DESC"] = [=[Укажите путь к пользовательскому звуковому файлу. Приведем несколько примеров (здесь "file' - это имя звукового файла, "ext" - его расширение (поддерживаются только ogg и mp3)):
- "CustomSounds\file.ext" - файл находится в папке CustomSounds которая размещена в корневой папке WoW (папке в которой находятся файл WoW.exe, папки WTF и Interface и т.д.)
- "Interface\AddOns\file.ext": - файл находится в папке AddOns
- "file.ext": - файл находится в в корневой папке WoW]=] -- Needs review
L["SOUNDERROR1"] = "Файл должен иметь расширение!" -- Needs review
L["SOUNDERROR2"] = "Файлы в формате WAV не поддерживаются WoW 4.0+" -- Needs review
L["SOUNDERROR3"] = "Поддерживаются только файлы в формате OGG и MP3." -- Needs review
L["SOUND_EVENT_DISABLEDFORTYPE"] = "Недоступно для %s" -- Needs review
L["SOUND_EVENT_ONFINISH"] = "При окончании" -- Needs review
L["SOUND_EVENT_ONFINISH_DESC"] = [=[Это событие будет запущено по окончании времени восстановления заклинания/предмета, спадении баффа и т.п.
Внимание: обработчик этого события не исполняется после событий "При отображении" или "При сокрытии"]=] -- Needs review
L["SOUND_EVENT_ONHIDE"] = "При скрытии" -- Needs review
L["SOUND_EVENT_ONHIDE_DESC"] = "Это событие происходит при скрытии значка (даже если установлена опция %q)" -- Needs review
L["SOUND_EVENT_ONSHOW"] = "При отображении" -- Needs review
L["SOUND_EVENT_ONSHOW_DESC"] = "Это событие происходит при отображении значка (даже если установлена опция %q)" -- Needs review
L["SOUND_EVENT_ONSPELL"] = "При изменении заклинания/передмета" -- Needs review
L["SOUND_EVENT_ONSPELL_DESC"] = "Это событие происходит при смене заклинания/предмета для которого отображается информация на этом значке." -- Needs review
L["SOUND_EVENT_ONUNIT"] = "При изменении объекта" -- Needs review
L["SOUND_EVENT_ONUNIT_DESC"] = "Это событие происходит при смене объекта для которого отображается информация на этом значке." -- Needs review
L["SOUND_SOUNDTOPLAY"] = "Звуки" -- Needs review
L["SOUND_TAB"] = "Звуки" -- Needs review
L["SPEED"] = "Скорость объекта" -- Needs review
L["SPELLCOOLDOWN"] = "Восстановление заклинания" -- Needs review
L["SpellCritTaken"] = "Повышена вероятность получить крит. удар заклинанием"
L["SpellDamageTaken"] = "Увеличение получаемого магического урона"
L["SPELLTOCHECK"] = "Заклинание для проверки" -- Needs review
L["STACKS"] = "Стаки" -- Needs review
L["STANCE"] = "Стойка" -- Needs review
L["STRATA_BACKGROUND"] = "Фон" -- Needs review
L["STRATA_DIALOG"] = "Окно настроек" -- Needs review
L["STRATA_FULLSCREEN"] = "Полный экран" -- Needs review
L["STRATA_FULLSCREEN_DIALOG"] = "Полноэкранное окно настроек" -- Needs review
L["STRATA_HIGH"] = "Высокая" -- Needs review
L["STRATA_LOW"] = "Низкая" -- Needs review
L["STRATA_MEDIUM"] = "Средняя" -- Needs review
L["STRATA_TOOLTIP"] = "Подсказка" -- Needs review
L["Stunned"] = "Оглушен"
L["SUGGESTIONS"] = "Предложения:" -- Needs review
L["SUG_INSERT_ANY"] = "|cff7fffffНажмите|r" -- Needs review
L["SUG_INSERTID"] = "%s чтобы добавить по ID" -- Needs review
L["SUG_INSERTITEMSLOT"] = "%s чтобы добавить как ID ячейки снаряжения" -- Needs review
L["SUG_INSERT_LEFT"] = "|cff7fffffНажмите ЛКМ|r" -- Needs review
L["SUG_INSERTNAME"] = "%s чтобы добавить по имени" -- Needs review
L["SUG_INSERT_RIGHT"] = "|cff7fffffНажмите ПКМ|r" -- Needs review
L["SUG_MATCH_WPNENCH_ENCH"] = "Оружие (........)" -- Needs review
L["SUG_PATTERNMATCH_FISHINGLURE"] = "Приманка %(рыбная ловля %+%d+%)"
L["SUG_PATTERNMATCH_SHARPENINGSTONE"] = "Оружие заточено %(%+%d+ к урону)"
L["SUG_PATTERNMATCH_WEIGHTSTONE"] = "Оружие утяжелено %(%+%d+ к урону)"
L["SUG_PLAYERSPELLS"] = "Ваши заклинания" -- Needs review
L["SUG_SUBSTITUTION_f"] = "Фокус Имя" -- Needs review
L["SUG_SUBSTITUTION_t"] = "Имя цели" -- Needs review
L["SUN"] = "Солнце"
L["TANK"] = "Танк" -- Needs review
L["TEXTLAYOUTS_fLAYOUT"] = "Расположение текста: %s" -- Needs review
L["TEXTLAYOUTS_SKINAS_NONE"] = "Нет" -- Needs review
L["TEXTLAYOUTS_STRING_COPYMENU"] = "Скопировать" -- Needs review
L["TEXTLAYOUTS_STRING_SETDEFAULT"] = "По умолчанию" -- Needs review
L["TEXTLAYOUTS_UNNAMED"] = "<без имени>" -- Needs review
L["TOP"] = "Вверху"
L["TOPLEFT"] = "Вверху слева"
L["TOPRIGHT"] = "Вверху справа"
L["TOTEMS"] = "Тотемы для проверки" -- Needs review
L["TRUE"] = "Верно"
L["UIPANEL_ADDGROUP"] = "Добавить другую группу"
L["UIPANEL_ADDGROUP_DESC"] = "Новой группе будет присвоен следующий доступный ID группы" -- Needs review
L["UIPANEL_ALLRESET"] = "Сбросить всё"
L["UIPANEL_BARIGNOREGCD"] = "Полосы не учитывают глобальную перезарядку"
L["UIPANEL_BARIGNOREGCD_DESC"] = "Если выбрана, полосы восстановления не изменяют свои значения если восстановление является глобальной"
L["UIPANEL_BARTEXTURE"] = "Текстура полосы"
L["UIPANEL_CLOCKIGNOREGCD"] = "Таймеры не учитывают глобальную перезарядку"
L["UIPANEL_CLOCKIGNOREGCD_DESC"] = "Если выбрана, таймеры и часы восстановления не учитывают глобальное восстановление"
L["UIPANEL_COLORS"] = "Цвета"
L["UIPANEL_COLUMNS"] = "Столбцы"
L["UIPANEL_DELGROUP"] = "Удалить эту группу"
L["UIPANEL_DELGROUP_DESC"] = "Любые группы после этой группы и их ID будут смещены вверх, также и любые иконки в группе, которые будут смещены обновят свои настройки автоматически." -- Needs review
L["UIPANEL_DRAWEDGE"] = "Подсвечивать рамку таймера"
L["UIPANEL_DRAWEDGE_DESC"] = "Подсвечивать рамку таймера восстановления для улучшения видимости"
L["UIPANEL_ENABLEGROUP"] = "Включить группу"
L["UIPANEL_FONT_CONSTRAINWIDTH"] = "Ограничить ширину" -- Needs review
L["UIPANEL_FONT_CONSTRAINWIDTH_DESC"] = [=[При установке этой опции ширина текста будет ограничена шириной значка. Если эта опция не выбрана текст может быть
шире чем значок.]=] -- Needs review
L["UIPANEL_FONT_DESC"] = "Шрифт для отображения значения суммирования эффекта на иконке."
L["UIPANEL_FONTFACE"] = "Шрифт" -- Needs review
L["UIPANEL_FONT_OUTLINE"] = "Контур шрифта"
L["UIPANEL_FONT_OUTLINE_DESC"] = "Вид контура шрифта используемого для отображения значения суммирования эффекта на иконке."
L["UIPANEL_FONT_SIZE"] = "Размер шрифта"
L["UIPANEL_FONT_SIZE_DESC"] = "Устанавливает размер шрифта для отображения числа эффектов на значке. Если установлен аддон ButtonFacade и для него используется собственный размер шрифта, это значение игнорируется." -- Needs review
L["UIPANEL_FONT_XOFFS"] = "Смещение по X"
L["UIPANEL_FONT_YOFFS"] = "Смещение по Y"
L["UIPANEL_GLYPH"] = "Символ" -- Needs review
L["UIPANEL_GROUPNAME"] = "Переименовать группу"
L["UIPANEL_GROUPRESET"] = "Сбросить расположение"
L["UIPANEL_GROUPS"] = "Группы"
L["UIPANEL_ICONS"] = "Значки" -- Needs review
L["UIPANEL_ICONSPACING_DESC"] = "Расстояние на котором значки расположены друг от друга в группе"
L["UIPANEL_LOCK"] = "Заблокировать группу" -- Needs review
L["UIPANEL_LOCK_DESC"] = "Заблокировать возможность перемещения или изменения размера группы."
L["UIPANEL_LOCKUNLOCK"] = "Заблокировать/разблокировать аддон"
L["UIPANEL_MAINOPT"] = "Основные параметры"
L["UIPANEL_ONLYINCOMBAT"] = "Показывать только в бою"
L["UIPANEL_POINT"] = "Очки"
L["UIPANEL_POSITION"] = "Расположение"
L["UIPANEL_PRIMARYSPEC"] = "Первый набор талантов"
L["UIPANEL_PTSINTAL"] = "Очков в таланте" -- Needs review
L["UIPANEL_RELATIVEPOINT"] = "Относительная точка" -- Needs review
L["UIPANEL_ROWS"] = "Строки"
L["UIPANEL_SCALE"] = "Масштаб"
L["UIPANEL_SECONDARYSPEC"] = "Второй набор талантов"
L["UIPANEL_SPEC"] = "Набор талантов"
L["UIPANEL_STRATA"] = "Экранная глубина" -- Needs review
L["UIPANEL_SUBTEXT2"] = "Значки работают когда они заблокированы. Когда разблокированы, вы можете перемещать группы значков и изменять их размер, а так же настраивать отдельные значки правым щелчком мыши. Для блокировки/разблокировки аддона наберите /tellmewhen or /tmw."
L["UIPANEL_TOOLTIP_ALLRESET"] = "Сброс данных и расположение всех иконок и групп, а также любые другие параметры."
L["UIPANEL_TOOLTIP_COLUMNS"] = "Установить число столбцов в этой группе"
L["UIPANEL_TOOLTIP_ENABLEGROUP"] = "Показать и включить эту группу значков"
L["UIPANEL_TOOLTIP_GROUPRESET"] = "Сбросить расположение и масштаб этой группы"
L["UIPANEL_TOOLTIP_ONLYINCOMBAT"] = "Показывать эту группу только в бою" -- Needs review
L["UIPANEL_TOOLTIP_PRIMARYSPEC"] = "Показывать эту группу только тогда, когда задействован ваш первый набор талантов"
L["UIPANEL_TOOLTIP_ROWS"] = "Установить число строк в этой группе"
L["UIPANEL_TOOLTIP_SECONDARYSPEC"] = "Показывать эту группу только тогда, когда задействован ваш второй набор талантов"
L["UIPANEL_TOOLTIP_UPDATEINTERVAL"] = "Частота (в секундах) проверки параметров и условий значков. Значение 0 означает максимально быструю проверку. Внимание: маленькие значения могут сильно снизить частоту кадров на слабых компьютерах." -- Needs review
L["UIPANEL_TREE"] = "Специализация" -- Needs review
L["UIPANEL_UPDATEINTERVAL"] = "Интервал обновления"
L["UIPANEL_WARNINVALIDS"] = "Предупреждать о недействительных иконках"
L["UNDO_ICON"] = "Отменить" -- Needs review
L["UNDO_ICON_DESC"] = "Отменить изменения сделанные для этого значка. " -- Needs review
L["UNNAMED"] = "((Без названия))" -- Needs review
L["WATER"] = "Вода" -- Needs review
L["worldboss"] = "Ворлд Босс" -- Needs review
