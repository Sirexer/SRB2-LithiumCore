LithiumCore.functions.RegisterCommand = function(name, sets)
	local IsError = false
	if type(name) != "string"
		print("\x82".."WARNING".."\x80"..": arg #1 is "..type(name).." should be \"string\"")
		return
	end
	if type(sets) != "table"
		sets = {}
	end
	
	if type(sets) == "table"
		if type(sets.name) != "string"
			sets.name = "LC_"..name
		end
	end
	
	local SetCopy = {}
	for k, v in pairs(sets)
		SetCopy[k] = v
	end
	LithiumCore.serverdata.commands[name] = SetCopy
end

return true -- End Of File