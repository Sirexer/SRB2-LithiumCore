local LC = LithiumCore

LC.functions.AddAccountData = function(func)
	if func
		if type(func) == "function"
			table.insert(LC.accountsData, func)
			print("\x83".."NOTICE".."\x80"..": Added "..#LC.accountsData.." to datasave")
		else
			print("\x82WARNING\x80: Expected function, got "..type(func))
		end
	end
end

return true
