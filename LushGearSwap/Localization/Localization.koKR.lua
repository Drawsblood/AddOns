if not LGS_LocalizationLoaded and GetLocale() == "koKR" then
	
	LGS_DAILIES_OPTION = "일일: "
	
	LushGearSwap_ZoneSwapLocaitons = {
		["투기장"] = {
			["달라란 투기장"] 		= { 1, },
			["나그란드 투기장"] 		= { 1, },
			["용맹의 투기장"] 		= { 1, },
			["로데론의 폐허"]		= { 1, },
			["칼날 투기장"] 		= { 1, },
		},

		["도시"] = {
			["스톰윈드"] 			= { 1, },
			["아이언포지"] 			= { 1, },
			["달라란"] 			= { 1, },
			["엑소다르"] 			= { 1, },
			["다르나서스"] 			= { 1, },
			["샤트라스"] 			= { 1, },
			["오그리마"] 			= { 1, },
			["썬더 블러프"] 		= { 1, },
			["언더시티"] 			= { 1, },
			["실버문"] 			= { 1, },
		},

		[LGS_DAILIES_OPTION .. "은빛십자군 마상시합"] = {
			["은빛십자군 마상시합 광장"]		= { 1, },
			["얼라이언스 용맹전사의 투기장"] 	= { 1, },
			["호드 용맹전사의 투기장"]		= { 1, },
			["용사의 투기장"]				= { 1, },
			["은빛십자군 용맹전사의 투기장"]	= { 1, },
			["지원자의 투기장"]				= { 1, },
			["해골 광장"] 				= { 13852, 13854, 13855, 13857, 13851, 13856, 13858, 13859, 13860, 	-- "적의 관문에서
											13863, 13862, 13861, 13864, }, 									-- 성채를 향한 전투
			["얼음왕관 성채"] 				= { 13852, 13854, 13855, 13857, 13851, 13856, 13858, 13859, 13860, 	-- "적의 관문에서
											13863, 13862, 13861, 13864, }, 									-- 성채를 향한 전투
		},

		[LGS_DAILIES_OPTION .. "낚시"] = {
			-- 달라란 80레벨 낚시 일일퀘스트
			["마법과 까마귀 여관"] 			= { 13832, }, 			-- 하수도의 보석
			["겨울손아귀 호수"] 			= { 13834, }, 			-- 위험하지만 맛있는
			["북풍의 땅"] 				= { 13833, }, 			-- 피는 진하다
			["죽음의 언덕"] 				= { 13833, }, 			-- 피는 진하다
			["우누페"] 					= { 13833, },			-- 피는 진하다
			["카스칼라"] 					= { 13833, }, 			-- 피는 진하다
			["얼어붙은 바다"] 				= { 13836, }, 			-- 뚱뚱보물고기의 식욕
			["강의 심장부"]				= { 13830, }, 			-- 유령 물고기

			-- 아웃랜드 70레벨 낚시 일일 퀘스트
			["테로카로 숲"]				= { 11666, }, 			-- 미끼 도둑
			["아고나르의 웅덩이"]			= { 11669, }, 			-- 지옥피통돔 분비선
			["장가르 슾지대"]				= { 11668, }, 			-- 새우잡이
			["스톰윈드"]					= { 11665, }, 			-- 도시에 나타난 악어
			["태양여울 호수"]				= { 11410, 11667, }, 	-- 놓친 물고기
		},
	};
	
	LGS_DUALSPEC_OPTION						= "듀얼 전문화"
	LGS_PRIMSPEC_OPTION						= "1특성"
	LGS_ALTSPEC_OPTION						= "2특성"
	LGS_DONTSWAP_OPTION						= "특성변경시 적용하지 않음"
	LGS_BANK_OPTION							= "은행 옵션"
	LGS_DEPOSITBANK_OPTION					= "은행으로"
	LGS_DEPOSITBANKUNIQUE_OPTION			= "고유아이템 은행으로"
	LGS_DEPOSITBALLALLOTHER_OPTION			= "이 세트를 제외한 모든 세트 은행으로"
	LGS_WITHDRAWBANK_OPTION					= "은행에서 꺼내기"
	LGS_NEVERDEPOSIT_OPTION					= "은행에 넣지 않도록 설정"
	LGS_GENERAL_OPTION						= "일반 옵션"
	LGS_UPDATECURRENT_OPTION				= "현재 착용한 장비로 갱신"
	LGS_SET_OPTION							= "기타 옵션"
	
	LGS_SHOWHELM_OPTION						= "투구 보이기"
	LGS_HIDEHELM_OPTION						= "투구 숨기기"
	
	LGS_SHOWCLOAK_OPTION					= "망토 보이기"
	LGS_HIDECLOAK_OPTION					= "망토 숨기기"
	
	LGS_DONTCHANGE_OPTION					= "바꾸지 않음"
	
	LGS_HELMOPTION_HEADER					= "투구 설정"
	LGS_CLOAKOPTION_HEADER					= "칭호 설정"
	LGS_SWAPONZONE_HEADER					= "지역 진입시 세트 자동 번경"
	LGS_MINIMAPHELP_HEADER					= "^ 미니맵의 지역이름 ^"
	LGS_NEWZONE_HEADER						= "'위치 지정'"
	
	LGS_KEYBINDMODE_BUTTON					= "단축키 설정 모드"
	LGS_KEYBINDMODE_HEADER					= "-:단축키 설정 모드:-\n지정하려는 세트위에 마우스를 올린 후, 원하는 단축키를 눌러주세요.; 단축키를 삭제하려면 세트에 마우스를 올린 후 Esc키를 누르세요."
	
	LGS_LocalizationLoaded 					= true
end