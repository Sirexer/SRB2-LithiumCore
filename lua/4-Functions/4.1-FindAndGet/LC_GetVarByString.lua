local LC = LithiumCore

-- Checking a player's permissions
LC.functions.GetVarByString = function(t, str, path)
	if type(t) != "table" then
		error("Bad arg1. Expected table, got type " .. type(t), 1)
	end
	if type(str) != "string" then
		error("Bad arg2. Expected string, got type " .. type(t), 1)
	end
	
	local str_var = str
	local finddot = str:find("%.")
	
	if not finddot then
		return t[str_var], t, str_var
	elseif finddot then
		local key = str:sub(1, finddot-1)
		
		if not t[key] then
			if not path then path = "..." end
			error(string.format("%s key in %s is not valid", key, path))
		end
		
		local newstr = str:sub(finddot+1)
		if not path then path = key.."." end
		return LC.functions.GetVarByString(t[key], newstr, path)
	end
end

return true -- End of File
