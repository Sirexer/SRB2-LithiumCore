local LC = LithiumCore

-- Map number verification
LC.functions.FindMap = function(map)
	local mapnum = nil
	local maptable = {}
	if M_MapNumber(map) != 0
		mapnum = M_MapNumber(map)
	else
		if tonumber(map)
			if tonumber(map) >= 1 or  tonumber(map) <= 1035
				mapnum = tonumber(map)
			end
		end
	end
	if mapnum != nil
		if mapnum
			return mapnum
		end
	end
	return nil
end

return true
