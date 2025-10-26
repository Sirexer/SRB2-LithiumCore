local LC = LithiumCore

LC.functions.AddSubcatMenu = function(tabledata)
	if type(tabledata) != "table"
		print("\x82".."WARNING".."\x80"..": Expected table got "..type(tabledata))
		return
	else
		local IsError = false
		if type(tabledata.name) != "string"
			print("\x82".."WARNING".."\x80"..": value \"tabledata.name\" is "..type(tabledata.name).." should be \"string\"")
			IsError = true
		end
		if type(tabledata.description) != "string"
			tabledata.description = "No description"
		end
		if tabledata.type:lower() != "admin" and tabledata.type:lower() != "player" and tabledata.type:lower() != "misc" and tabledata.type:lower() != "account"
			print("\x82".."WARNING".."\x80"..": value \"tabledata.type\". Expected \"account\", \"admin\", \"player\" or \"misc\" got "..tostring(tabledata.type))
			return
		end
		if type(tabledata.funchud) != "function"
			print("\x82".."WARNING".."\x80"..": value \"tabledata.funchud\" is "..type(tabledata.funchud).." should be \"function\"")
			IsError = true
		end
		if type(tabledata.funcenter) != "function"
			print("\x82".."WARNING".."\x80"..": value \"tabledata.funcenter\" is "..type(tabledata.funcenter).." should be \"function\"")
			IsError = true
		end
		if type(tabledata.funchook) != "function"
			print("\x82".."WARNING".."\x80"..": value \"tabledata.funchook\" is "..type(tabledata.funchook).." should be \"function\"")
			IsError = true
		end
		if IsError == false
			local t = {
				name = tabledata.name,
				description = tabledata.description,
				funchud = tabledata.funchud,
				funcenter = tabledata.funcenter,
				funchook = tabledata.funchook
			}
			if tabledata.type:lower() == "player"
				table.insert(LC.menu.subcat.player, t)
				print("\x83".."NOTICE".."\x80"..": Added Subcategory "..tabledata.name.." to menu category player options")
			elseif tabledata.type:lower() == "admin"
				table.insert(LC.menu.subcat.admin, t)
				print("\x83".."NOTICE".."\x80"..": Added Subcategory "..tabledata.name.." to menu category admin panel")
			elseif tabledata.type:lower() == "misc"
				table.insert(LC.menu.subcat.misc, t)
				print("\x83".."NOTICE".."\x80"..": Added Subcategory "..tabledata.name.." to menu category miscellaneous")
			elseif tabledata.type:lower() == "account"
				table.insert(LC.menu.subcat.account, t)
				print("\x83".."NOTICE".."\x80"..": Added Subcategory "..tabledata.name.." to menu category account")
			end
		end
	end
end

return true
