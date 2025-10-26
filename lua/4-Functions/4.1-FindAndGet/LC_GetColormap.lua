local LC = LithiumCore 


LC.functions.GetColormap = function(value, key)
	if value then
		local index
		for i in ipairs(LC.colormaps) do
			local lcc = LC.colormaps[i]
			if lcc.value == tonumber(value)
			or lcc.hex == value
			or type(value) == "string" and lcc.name:lower() == value:lower() then
				index = i
			end
		end
		
		if index ~= nil then
			if type(key) == "string" and LC.colormaps[index][key] then
				return LC.colormaps[index][key]
			elseif not key
				return true
			end
		end
	end
	
	return false
end

return true
