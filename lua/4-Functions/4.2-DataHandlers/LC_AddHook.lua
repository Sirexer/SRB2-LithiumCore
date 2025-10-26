local LC = LithiumCore

LC.functions.AddHook = function(tabledata)
	if type(tabledata) != "table"
		print("\x82".."WARNING".."\x80"..": Expacted table got "..type(tabledata))
	else
		local IsError = false
		if type(tabledata.name) != "string"
			print("\x82".."WARNING".."\x80"..": value \"tabledata.name\" is "..type(tabledata.name).." should be \"string\"")
			IsError = true
		end 
		if type(tabledata.type) != "string"
			print("\x82".."WARNING".."\x80"..": value \"tabledata.type\" is "..type(tabledata.type).." should be \"string\"")
			IsError = true
		else
			local found = false
			for k, v in pairs(LC.Hooks) do
				if k == tabledata.type 
					found = true
					break
				end
			end
			if found == false
				print("\x82".."WARNING".."\x80"..": value \"tabledata.type\" has invalid "..type(tabledata.type).." hook")
				IsError = true
			end
		end  
		if type(tabledata.priority) != "number"
			tabledata.priority = 50
		end
		if type(tabledata.toggle) != "boolean"
			tabledata.toggle = true
		end
		if type(tabledata.func) != "function"
			print("\x82".."WARNING".."\x80"..": value \"tabledata.func\" is "..type(tabledata.func).." should be \"function\"")
			IsError = true
		end
		if IsError == false
			table.insert(LC.Hooks[tabledata.type], tabledata)
			print("\x83".."NOTICE".."\x80"..": Added "..tabledata.name.." "..tabledata.type.." Hook")
			if LC.serverdata.HooksToggle[tabledata.name] == nil
				LC.serverdata.HooksToggle[tabledata.name] = true
			end
			
			if tabledata.type == "HUD" then
				table.sort(
					LC.Hooks[tabledata.type],
					function(a,b)
						return b.priority > a.priority
					end
				)
			elseif tabledata.type == "KeyDown" or tabledata.type == "KeyUp" then
				table.sort(
					LC.Hooks[tabledata.type],
					function(a,b)
						return b.priority < a.priority
					end
				)
			end
			
		end
	end
end

return true
