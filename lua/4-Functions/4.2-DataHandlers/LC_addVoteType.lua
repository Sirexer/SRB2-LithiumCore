local LC = LithiumCore

LC.functions.addVoteType = function(tabledata)
	if type(tabledata) != "table"
		print("\x82".."WARNING".."\x80"..": Expacted table got "..type(tabledata))
		return
	end
	local IsError = false
	if type(tabledata.name) != "string"
		print("\x82".."WARNING".."\x80"..": value \"tabledata.name\" is "..type(tabledata.name).." should be \"string\"")
		IsError = true
	end 
	if type(tabledata.help_str) != "string"
		print("\x82".."WARNING".."\x80"..": value \"tabledata.help_str\" is "..type(tabledata.help_str).." should be \"string\"")
		IsError = true
	end
	if not tabledata.cvars then tabledata.cvars = {} end
	if type(tabledata.cvars) != "table"
		print("\x82".."WARNING".."\x80"..": value \"tabledata.cvars\" is "..type(tabledata.cvars).." should be \"table\"")
		IsError = true
	end
	if type(tabledata.func_start) != "function"
		print("\x82".."WARNING".."\x80"..": value \"tabledata.func_start\" is "..type(tabledata.func_start).." should be \"function\"")
		IsError = true
	end
	if type(tabledata.func_action) != "function"
		print("\x82".."WARNING".."\x80"..": value \"tabledata.func_action\" is "..type(tabledata.func_action).." should be \"function\"")
		IsError = true
	end
	if not tabledata.func_stop then
		function tabledata.func_stop() end
	end
	if type(tabledata.func_stop) != "function"
		print("\x82".."WARNING".."\x80"..": value \"tabledata.func_stop\" is "..type(tabledata.func_stop).." should be \"function\"")
		IsError = true
	end
	if type(tabledata.menu) != "table" and tabledata.menu
		print("\x82".."WARNING".."\x80"..": value \"tabledata.func_stop\" is "..type(tabledata.menu).." should be \"function\"")
		IsError = true
	end
	
	if IsError == true then return nil end
	
	tabledata.name = tabledata.name:lower():gsub(" ", "")
	local cvars = {}
	local serverdata_cvars = {}
	for _, v in ipairs(tabledata.cvars) do
		if type(v.name) ~= "string" then
			print("\x82".."WARNING".."\x80"..": value \"cvars[".._.."].name\" is "..type(v.name).." should be \"string\"")
			return
		end
		if v.PossibleValue ~= nil and type(v.PossibleValue) ~= "table" and type(v.PossibleValue) ~= "userdata" then
			print("\x82".."WARNING".."\x80"..": value \"cvars[".._.."].PossibleValue\" is "..type(v.PossibleValue).." should be \"nil\", \"table\" or \"userdata\"")
			return
		end
		if type(v.defaultvalue) ~= "string" and type(v.defaultvalue) ~= "number" then
			print("\x82".."WARNING".."\x80"..": value \"cvars[".._.."].defaultvalue\" is "..type(v.defaultvalue).." should be \"string\" or \"number\"")
			return
		end
		
		local name = v.name
		local defaultvalue = v.defaultvalue
		local PossibleValue = v.PossibleValue
		local description = v.description or "No description"
		
		local value, str = LC.functions.parseValue(v.PossibleValue, v.defaultvalue)
		if value == nil and str == nil then
			print("\x82".."WARNING".."\x80"..": defaultvalue \""..tostring(v.defaultvalue).."\" not valid for option \""..v.name.."\"")
			return
		end
		
		local sd_t = {
			name = name,
			defaultvalue = defaultvalue,
			value = value,
			string = str,
			change = false
		}
		
		local t = {
			name = name,
			defaultvalue = defaultvalue,
			PossibleValue = PossibleValue,
			description = description
		}
		
		
		local cvar = t.name:gsub(" ", ""):lower()
		-- serverdata
		--table.insert(serverdata_cvars, sd_t)
		if LC.serverdata.vote_cvars[tabledata.name] and LC.serverdata.vote_cvars[tabledata.name][cvar] then
			local sd_value = LC.serverdata.vote_cvars[tabledata.name][cvar].string
			local value, str = LC.functions.parseValue(v.PossibleValue, sd_value)
			if value ~= nil or str ~= nil then sd_t.value = value; sd_t.string = str; end
		end
		serverdata_cvars[cvar] = sd_t
		
		-- static data
		--table.insert(cvars, t)
		cvars[cvar] = t
	end
	
	if not cvars["enabled"] 
	or cvars["enabled"].PossibleValue ~= CV_OnOff
	or cvars["enabled"].defaultvalue ~= 0 and cvars["enabled"].defaultvalue ~= 1 then
		local sd_t = {
			name = "Enabled",
			defaultvalue = 1,
			value = 1,
			string = "1",
			changed = false
		}
		
		local t = {
			name = "Enabled",
			defaultvalue = 1,
			PossibleValue = CV_OnOff,
			serverdata = sd_t
		}
		local cvar = t.name:gsub(" ", ""):lower()
		-- serverdata
		--table.insert(serverdata_cvars, 1, sd_t)
		serverdata_cvars[cvar] = sd_t
		
		-- static data
		--table.insert(cvars, 1, t)
		cvars[cvar] = t
	end
	
	LC.vote_types[tabledata.name] = {
		name = tabledata.name,
		help_str = tabledata.help_str,
		cvars = cvars,
		serverdata_cvars = serverdata_cvars,
		func_start = tabledata.func_start,
		func_action = tabledata.func_action,
		func_stop = tabledata.func_stop,
		menu = tabledata.menu
	}
	
	LC.serverdata.vote_cvars[tabledata.name] = serverdata_cvars
	
	
	print("\x83".."NOTICE".."\x80"..": Added Vote Type "..tabledata.name.."")
end

return true
