function vexpower.options.specProfiles.getSpecDesc(spec)
	local returnvalue = ""
	local specActive = tostring(GetActiveSpecGroup(false, false))
	if spec == "A" then
		if specActive == "1" then
			returnvalue = 'You have set Spec A to: "'..select(2 ,GetSpecializationInfo("1"))..'". This spec is currently active.'
		else
			returnvalue = 'You have set Spec A to: "'..select(2 ,GetSpecializationInfo("1"))..'". This spec is currently inactive.'
		end
	else
		if specActive == "2" then
			returnvalue = 'You have set Spec B to: "'..select(2 ,GetSpecializationInfo("2"))..'". This spec is currently active.'
		else
			returnvalue = 'You have set Spec B to: "'..select(2 ,GetSpecializationInfo("2"))..'". This spec is currently inactive.'
		end
	end
	return returnvalue
end