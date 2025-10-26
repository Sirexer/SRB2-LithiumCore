local LC = LithiumCore

LC.functions.AddVote = function(tabledata)
	if type(tabledata) != "table"
		print("\x82".."WARNING".."\x80"..": Expacted table got "..type(tabledata))
	else
		local IsError = false
		if type(tabledata.name) != "string"
			print("\x82".."WARNING".."\x80"..": value \"tabledata.name\" is "..type(tabledata.name).." should be \"string\"")
			IsError = true
		end 
		if type(tabledata.command) != "string"
			print("\x82".."WARNING".."\x80"..": value \"tabledata.command\" is "..type(tabledata.command).." should be \"string\"")
			IsError = true
		end
		if type(tabledata.cvartype) != "table"
			print("\x82".."WARNING".."\x80"..": value \"tabledata.cvartype\" is "..type(tabledata.cvartype).." should be \"table\"")
			IsError = true
		else
			for i = 1, #tabledata.cvartype do
				local found = false
				for a = 1, #LC.serverdata.callvote.availableargs do
					if string.lower(tabledata.cvartype[i]) == string.lower(LC.serverdata.callvote.availableargs[a])
						found = true
						break
					end
				end
				if found == false
					print("\x82".."WARNING".."\x80"..": invalid "..string.lower(tabledata.cvartype[i]).." in tabledata.cvartype["..i.."]")
					IsError = true
				end
			end
		end
		if type(tabledata.enable) != "userdata"
			print("\x82".."WARNING".."\x80"..": value \"tabledata.enable\" is "..type(tabledata.enable).." should be \"userdata consvar_t\"")
			IsError = true
		elseif userdataType(tabledata.enable) != "consvar_t"
			print("\x82".."WARNING".."\x80"..": value \"tabledata.enable\" is "..userdataType(tabledata.enable).." should be \"userdata consvar_t\"")
			IsError = true
		end
		if IsError == false
			local t = {
				name = tabledata.name,
				command = tabledata.command,
				cvartype = tabledata.cvartype,
				enable = tabledata.enable
			}
			if LC.menu.vote[0] == nil
				LC.menu.vote[0] = t
			else
				table.insert(LC.menu.vote, t)
			end
			print("\x83".."NOTICE".."\x80"..": Added Vote "..tabledata.name.." to menu")
		end
	end
end

return true
