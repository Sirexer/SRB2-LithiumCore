local LC = LithiumCore

LC.functions.AddCommandMenu = function(tabledata)
	local IsError = false
	if type(tabledata.name) != "string"
		print("\x82".."WARNING".."\x80"..": arg \"name\" is "..type(tabledata.name).." should be \"string\"")
		IsError = true
	end
	if type(tabledata.description) != "string"
		tabledata.description = "No description"
	end
	if type(tabledata.command) != "string"
		print("\x82".."WARNING".."\x80"..": arg \"command\" is "..type(tabledata.command).." should be \"string\"")
		IsError = true
	elseif LC.serverdata.commands[tabledata.command] == nil
		print("\x82".."WARNING".."\x80"..": Not found \""..tabledata.command.."\" in parameters, register RegisterCommand(\""..tabledata.command.."\")")
		IsError = true
	end
	if type(tabledata.confirm) != "string"
		confirm = "Confirm"
	end
	if type(tabledata.playermenu) != "table"
		tabledata.playermenu = {
			enable = false,
			select = nil,
			fastexec = false
		}
	end
	if type(tabledata.args) != "table"
		print("\x82".."WARNING".."\x80"..": arg \"args\" is "..type(args).." should be \"table\"")
		IsError = true
	else
		local cv_t = {}
		for i = 1, #tabledata.args do
			if type(tabledata.args[i]) != "table"
				print("\x82".."WARNING".."\x80"..": arg \"args["..i.."]\" is "..type(tabledata.args[i]).." should be \"table\"")
				IsError = true
			else
				if type(tabledata.args[i].header) != "string"
					print("\x82".."WARNING".."\x80"..": arg \"args["..i.."].header\" is "..type(tabledata.args[i].header).." should be \"string\"")
					IsError = true
				end
				if type(tabledata.args[i].type) != "string"
					print("\x82".."WARNING".."\x80"..": arg \"args["..i.."].type\" is "..type(tabledata.args[i].type).." should be \"string\"")
					IsError = true
				elseif tabledata.args[i].type != "username"
				and tabledata.args[i].type != "password"
				and tabledata.args[i].type != "text" 
				and tabledata.args[i].type != "count"
				and tabledata.args[i].type != "float"
				and tabledata.args[i].type != "player" 
				and tabledata.args[i].type != "skin" 
				and tabledata.args[i].type != "skincolor"
				and not string.find(tabledata.args[i].type, "custom_value")
					print("\x82".."WARNING".."\x80"..": arg \"args["..i.."].type\", invalid "..type(args[i].type).." value, available values: username, password, text, count, float, player, skin, skincolor, custom_value1, custom_value2, custom_value3...")
					IsError = true
				else
					if string.find(tabledata.args[i].type, "custom_value")
						table.insert(cv_t, tonumber(string.sub(tabledata.args[i].type, 13)))
					end
					if cv_t[1] != nil
						if type(tabledata.custom_values) != "table"
							print("\x82".."WARNING".."\x80"..": arg \"custom_values\" is "..type(tabledata.custom_values).." should be \"table\"")
							IsError = true
						else
							for b = 1, #cv_t do
								if type(tabledata.custom_values[cv_t[b]]) != "table"
									print("\x82".."WARNING".."\x80"..": arg \"custom_values"..cv_t[b].."\" is "..type(tabledata.custom_values[cv_t[b]]).." should be \"table\"")
									IsError = true
								else
									for a = 1, #tabledata.custom_values[cv_t[b]] do
										if type(tabledata.custom_values[cv_t[b]][a]) != "table"
											print("\x82".."WARNING".."\x80"..": arg \"custom_values"..cv_t[b].."["..a.."]".."\" is "..type(tabledata.custom_values[cv_t[b]][a]).." should be \"table\"")
											IsError = true
										else
											if type(tabledata.custom_values[cv_t[b]][a].name) != "string"
												print("\x82".."WARNING".."\x80"..": arg \"custom_values"..cv_t[b].."["..a.."].name".."\" is "..type(tabledata.custom_values[cv_t[b]][a].name).." should be \"string\"")
												IsError = true
											end
											if type(tabledata.custom_values[cv_t[b]][a].value) != "string"
												print("\x82".."WARNING".."\x80"..": arg \"custom_values"..cv_t[b].."["..a.."].value".."\" is "..type(tabledata.custom_values[cv_t[b]][a].value).." should be \"string\"")
												IsError = true
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	if IsError == false
		if LC.menu.commands[0] == nil
			LC.menu.commands[0] = tabledata
		else
			table.insert(LC.menu.commands, tabledata)
		end
	end
end

return true
