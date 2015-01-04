function vexpower.options.strata.getStrataValue(frame)
	if frame == "textfields" then
		return {
			[1] = "BACKGROUND (lowest)",
			[2] = "LOW",
			[3] = "MEDIUM",
			[4] = "HIGH (Default)",
			[5] = "DIALOG",
			[6] = "FULLSCREEN",
			[7] = "FULLSCREEN_DIALOG",
			[8] = "TOOLTIP (highest)",
			}
	else
		return {
			[1] = "BACKGROUND (lowest)",
			[2] = "LOW",
			[3] = "MEDIUM (Default)",
			[4] = "HIGH",
			[5] = "DIALOG",
			[6] = "FULLSCREEN",
			[7] = "FULLSCREEN_DIALOG",
			[8] = "TOOLTIP (highest)",
			}
	end
end

function vexpower.options.strata.getTextfieldValue()
	local returnvalue = vexpower_SV_profiles[vexpower_SV_data["profile"]]["data"]["strata"]["text"]+1
	if returnvalue > 8 then
		returnvalue = 8
	end
	return returnvalue		
end

function vexpower.options.strata.convertValues(val)
	local values = {
		[1] = "BACKGROUND",
		[2] = "LOW",
		[3] = "MEDIUM",
		[4] = "HIGH",
		[5] = "DIALOG",
		[6] = "FULLSCREEN",
		[7] = "FULLSCREEN_DIALOG",
		[8] = "TOOLTIP",
		}
		
	if values[val] == nil then
		return "MEDIUM"
	else
		return values[val]
	end
end