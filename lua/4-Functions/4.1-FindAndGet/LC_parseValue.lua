local LC = LithiumCore

function LC.functions.parseValue(PossibleValue, input)
    -- if PossibleValue is missing
    if PossibleValue == nil and input ~= nil then
        return nil, tostring(input)
	elseif PossibleValue == nil and input == nil then
		return nil, nil
    end
	
	if type(PossibleValue) == "userdata" then
		if PossibleValue == CV_OnOff then
			PossibleValue = {Off = 0, On = 1}
		elseif PossibleValue == CV_YesNo then
			PossibleValue = {No = 0, Yes = 1}
		elseif PossibleValue == CV_Unsigned then
			PossibleValue = {MIN = 0, MAX = 999999999}
		elseif PossibleValue == CV_Natural then
			PossibleValue = {MIN = 1, MAX = 999999999}
		elseif PossibleValue == CV_TrueFalse then
			PossibleValue = {False = 0, True = 1}
		end
	end

    -- if the table contains MIN/MAX
    if PossibleValue.MIN ~= nil and PossibleValue.MAX ~= nil then
        local num = tonumber(input)
        if num == nil then return nil, nil end

        if num < PossibleValue.MIN then
            num = PossibleValue.MIN
        elseif num > PossibleValue.MAX then
            num = PossibleValue.MAX
        end
        return num, tostring(num)
    end

    -- if the table contains a list of pairs (Off=0, On=1)
    for k, val in pairs(PossibleValue) do
        -- row-by-row comparison
        if type(input) == "string" and string.lower(input) == string.lower(k) then
            return val, k
        end
        -- comparison by number
        local num = tonumber(input)
        if num ~= nil and num == val then
            return val, k
        end
    end

    -- if nothing matches
    return nil, nil
end

return true -- End of File
