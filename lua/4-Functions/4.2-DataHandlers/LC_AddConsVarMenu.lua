local LC = LithiumCore

LC.functions.AddConsVarMenu = function(tabledata)
	if type(tabledata) != "table"
		print("\x82".."WARNING".."\x80"..": Expacted table got "..type(tabledata))
	else
		local IsError = false
		if type(tabledata.name) != "string"
			print("\x82".."WARNING".."\x80"..": arg \"tabledata.name\" is "..type(tabledata.name).." should be \"string\"")
			IsError = true
		end
		if type(tabledata.description) != "string"
			tabledata.description = "No description"
		end
		if type(tabledata.command) != "userdata"
			print("\x82".."WARNING".."\x80"..": arg \"tabledata.command\" is "..type(tabledata.command).." should be \"userdata consvar_t\"")
			IsError = true
		elseif userdataType(tabledata.command) != "consvar_t"
			print("\x82".."WARNING".."\x80"..": arg \"tabledata.command\" is "..type(tabledata.command).." should be \"userdata consvar_t\"")
			IsError = true
		end
		if IsError == false
			local t = {
				name = tabledata.name,
				description = tabledata.description,
				command = tabledata.command
			}
			if (tabledata.command.flags & CV_NETVAR)
				//if tabledata.command.PossibleValue
				table.insert(LC.menu.vars, t)
			else
				table.insert(LC.menu.client_vars, t)
			end
		end
	end
end

return true
