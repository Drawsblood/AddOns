SLASH_vexpower1 = "/vexpower"
SLASH_vexpower2 = "/vexp"
SLASH_vexpower3 = "/vexpowa"
function SlashCmdList.vexpower(msg, editbox)
	if 	msg == "" or msg == "options" or msg == "option" or msg == "config" or msg == "configs" then
		InterfaceOptionsFrame_OpenToCategory(vexpower.options.main.optionpanel)
	elseif msg == "defaults" then
		print("|CFFFF7D0AVex Power|r - defaults loaded")
		vexpower.initialize.loadSV(true)
	elseif msg == "test" then
	
	
		-- vexdebugs.print("vexpower.CPBar.currentCP[1]",vexpower.CPBar.currentCP[1])
			
		-- for i=1,10 do
			-- vexdebugs.print('UnitPower("player", '..i..')',UnitPower("player", i))
		-- end
		-- vexdebugs.print({select(1, UnitBuff("player", 1)),select(11, UnitBuff("player", 1))},"1")
		-- vexdebugs.print({select(1, UnitBuff("player", 2)),select(11, UnitBuff("player", 2))},"2")
		-- vexdebugs.print({select(1, UnitBuff("player", 3)),select(11, UnitBuff("player", 3))},"3")
		-- vexdebugs.print({select(1, UnitBuff("player", 5)),select(11, UnitBuff("player", 5))},"5")
		-- vexdebugs.print({select(1, UnitBuff("player", 6)),select(11, UnitBuff("player", 6))},"6")
		
		-- for i=1,100 do
			-- if UnitPower("player", i) ~= nil and UnitPower("player", i) ~= 0 then
				-- vexdebugs.print(UnitPower("player", i),'UnitPower '..i)
			-- end
		-- end		
	elseif msg == "lock" then
		vexpower.mainframe.setMovable()
	elseif msg == "testmode" then
		vexpower.testmode.activated = not(vexpower.testmode.activated)
		vexpower.testmode.handler()
		if vexpower.testmode.activated then
			print("|CFFFF7D0AVex Power|r - Testmode activated")
		else
			print("|CFFFF7D0AVex Power|r - Testmode deactivated")
		end
	elseif msg == "enable" then
		if vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"] then
			vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"]=false
			vexpower.show.handler()
			print("|CFFFF7D0AVex Power|r - Addon disabled")
		else
			vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["show"]["enableAddon"]=true
			vexpower.show.handler()
			print("|CFFFF7D0AVex Power|r - Addon enabled")
		end
	else
		print ("|CFFFF7D0A Vex Power|r cmd list")
		print ("|CFFFF7D0A/vexpower|r and |CFFFF7D0A/vexp|r can be used")
		print ("|CFFFF7D0A/vexpower|r option/options/config/configs - opens the option frame")
		print ("|CFFFF7D0A/vexpower|r enable - to enable/disable the addon")
		print ("|CFFFF7D0A/vexpower|r defaults - resets the addon to defaults")
		print ("|CFFFF7D0A/vexpower|r lock - to make the frame movable")
		print ("|CFFFF7D0A/vexpower|r testmode - to toggle the testmode")
	end
end
