local LC = LithiumCore

function LC.functions.normalizePossibleValue(userdata)
	if type(userdata) == "userdata" then
		if userdata == CV_OnOff then
			return {Off = 0, On = 1}
		elseif userdata == CV_YesNo then
			return {No = 0, Yes = 1}
		elseif userdata == CV_Unsigned then
			return {MIN = 0, MAX = 999999999}
		elseif userdata == CV_Natural then
			return {MIN = 1, MAX = 999999999}
		elseif userdata == CV_TrueFalse then
			return {False = 0, True = 1}
		end
	elseif type(userdata) == "table" then
		return userdata
	end
end

return true -- End of File
