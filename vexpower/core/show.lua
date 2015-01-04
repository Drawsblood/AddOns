function vexpower.show.getCheck(frame)
	local returnvalue = true
	
	--check for enabled addon and enabled frame
	if vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"] and vexpower_SV_profiles[vexpower_SV_data["profile"]][frame]["show"]["show"] then
		--check for infight		
		if vexpower_SV_profiles[vexpower_SV_data["profile"]][frame]["show"]["hideOOC"] and not(vexpower.data.inFight.delayed) then
			returnvalue = false
		end
		
		--check for stealth (overwrites infight result!)
		if vexpower_SV_profiles[vexpower_SV_data["profile"]][frame]["show"]["inStealth"] and vexpower.data.inStealth then
			returnvalue = true
		end
		
		--check for targetSet (overwrites infight result!)
		if vexpower_SV_profiles[vexpower_SV_data["profile"]][frame]["show"]["whenTargeting"] and vexpower.data.isTargetSet then
			returnvalue = true
		end
			
		--check for vehicle
		if vexpower.data.inVehicle and vexpower_SV_profiles[vexpower_SV_data["profile"]][frame]["show"]["hideInVehicle"] then
			returnvalue = false
		end
			
		--check for petBattle
		if vexpower.data.inPetBattleFight and vexpower_SV_profiles[vexpower_SV_data["profile"]][frame]["show"]["hideInPetBattle"] then
			returnvalue = false
		end
		
		--check for show not with powertype
		if vexpower_SV_profiles[vexpower_SV_data["profile"]][frame]["show"]["powertypes"][vexpower.powerBar.powerType] ~= nil then
			if not(vexpower_SV_profiles[vexpower_SV_data["profile"]][frame]["show"]["powertypes"][vexpower.powerBar.powerType]) then
				returnvalue = false
			end
		end
		
		--check for class and spec
		if frame == "combo" then			
			if not(vexpower.show.getClasscheck()) then
				returnvalue = false
			end
		end
	else
		returnvalue = false
	end
	
	return returnvalue
end

function vexpower.show.getClasscheck()
	local returnvalue = true
	
	if vexpower.data.classString == "SHAMAN" and vexpower.data.specID == 263 then 		-- Shaman		Enhancer
		returnvalue = vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["shaman"]["enhancer"] 
		
	elseif vexpower.data.classString == "HUNTER" and vexpower.data.specID == 254 then		-- Hunter		Marksman
		returnvalue = vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["hunter"]["mm"] 
	elseif vexpower.data.classString == "HUNTER" and vexpower.data.specID == 253 then		-- Hunter		Beast Master
		returnvalue = vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["hunter"]["bm"] 
		
	elseif vexpower.data.classString == "WARRIOR" and vexpower.data.specID == 72 then		-- Warrior		Fury
		returnvalue = vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["warrior"]["fury"] 
		
	elseif vexpower.data.classString == "PRIEST" and vexpower.data.specID == 256 then		-- Priest		Discipline
		returnvalue = vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["priest"]["disci"] 
	elseif vexpower.data.classString == "PRIEST" and vexpower.data.specID == 258 then		-- Priest		Shadow
		returnvalue = vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["priest"]["shadow"] 
		
	elseif vexpower.data.classString == "MAGE" and vexpower.data.specID == 62 then		-- Mage			Arcane
		returnvalue = vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["mage"]["arcane"] 
	
	elseif vexpower.data.classString == "PALADIN" then									-- Paladin
		returnvalue = vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["paladin"]["cps"] 
		
	elseif vexpower.data.classString == "ROGUE" then									-- Rogues
		returnvalue = vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["rogue"]["cps"] 
		
	elseif vexpower.data.classString == "DRUID" then									-- Druid
		returnvalue = vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["druid"]["cps"] 
		
	elseif vexpower.data.classString == "MONK" then									-- Monk
		returnvalue = vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["monk"]["cps"] 
		
	elseif vexpower.data.classString == "WARLOCK" and vexpower.data.specID == 265 then	-- Warlock		Affliction
		returnvalue = vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["warlock"]["affli"] 
	elseif vexpower.data.classString == "WARLOCK" and vexpower.data.specID == 266 then	-- Warlock		Demonology
		returnvalue = vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["warlock"]["demo"] 
	elseif vexpower.data.classString == "WARLOCK" and vexpower.data.specID == 267 then	-- Warlock		Destruction
		returnvalue = vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["classSpec"]["warlock"]["destro"] 
	end
	
	return returnvalue
end


function vexpower.show.handler()
	local show_energy = vexpower.show.getCheck("powerbar")
	local show_cps = vexpower.show.getCheck("CPBar")
	
	--react to 'show'
	if show_energy then
		vexpower.powerBar.frames.barBG:Show()
		UIFrameFadeOut(vexpower.powerBar.frames.barBG, 0, 1, 1)
	elseif not(show_energy) and vexpower.powerBar.show then
		if vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["fadeoutEffect"] then	
			UIFrameFadeOut(vexpower.powerBar.frames.barBG, vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["fadeOutTime"], 1, 0)
		else
			vexpower.powerBar.frames.barBG:Hide()
		end
	elseif not(show_energy) then
		vexpower.powerBar.frames.barBG:Hide()
	end
	
	if show_cps then
		vexpower.CPBar.mainframe:Show()
		vexpower.CPBar.showHandler()
		UIFrameFadeOut(vexpower.CPBar.mainframe, 0, 1, 1)
	elseif not(show_cps) and vexpower.CPBar.show then
		if vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["fadeoutEffect"] then	
			UIFrameFadeOut(vexpower.CPBar.mainframe, vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["fadeOutTime"], 1, 0)
		else
			vexpower.CPBar.mainframe:Hide()
		end
	elseif not(show_cps) then
		vexpower.CPBar.mainframe:Hide()
	end
	
	vexpower.CPBar.show = show_cps
	vexpower.powerBar.show = show_energy
end