local LC = LithiumCore

-- Support for floating numbers, this feature is not mine.
LC.functions.floatnumber = function(str)
	if str == nil then return nil end
	if not str:find("^-?%d+%.%d+$") then
		if tonumber(str) then
			return tonumber(str)*FRACUNIT
		else
			return nil
		end
	end
	local decPlace = str:find("%.")
	local whole = tonumber(str:sub(1, decPlace-1))*FRACUNIT
	local dec = str:sub(decPlace+1)
	local decNumber = tonumber(dec)*FRACUNIT
	for i=1,dec:len() do
		decNumber = $1/10
	end
	if str:find("^-") then
		return whole-decNumber
	else
		return whole+decNumber
	end
end

return true
