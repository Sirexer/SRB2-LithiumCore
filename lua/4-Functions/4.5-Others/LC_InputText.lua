local LC = LithiumCore

LC.functions.InputText = function(it_type, arg, key, capslock, shift, maximum, minimum)
	if arg == nil or it_type == nil or key == nil then return end
	if it_type == "text" or it_type == "username" or it_type == "password"
		local maxs
		if maximum
			if maximum >= 1
				maxs = maximum
				if maximum > 96
					maxs = 96
				end
			else
				maxs = 1
			end
		else
			maxs = 96
		end
		if key.name == "backspace"
			S_StartSound(nil, sfx_tink, consoleplayer)
			if arg != ""
				arg = string.sub(arg, 0, string.len(arg)-1)
			end
		elseif key.name == "space" and it_type == "text"
			S_StartSound(nil, sfx_menu1, consoleplayer)
			arg = arg.." "
		else
			if key.num >= 97 and key.num <= 122
				if capslock == true and shift == false
				or capslock == false and shift == true
					arg = arg..string.upper(key.name)
				else
					arg = arg..key.name
				end
			elseif key.num >= 39 and key.num <= 96
				if shift == true
					xpcall(
						function()
							arg = arg..string.char(input.shiftKeyNum(key.num))
						end,
						function() end
					)
				elseif shift == false
					if key.num == 96
						arg = arg.."`"
					elseif key.num != 96
						arg = arg..key.name
					end
				end
			end
		end
		if it_type == "username" or it_type == "password"
			arg = LC.functions.getname(arg)
		end
		
		if it_type == "username"
			arg = string.lower(arg)
		end
		arg = string.sub(arg, 0, maxs)
	elseif it_type == "count"
		local str = tostring(arg)
		if key.name == "backspace"
			S_StartSound(nil, sfx_tink, consoleplayer)
			str = string.sub(str, 0, string.len(str)-1)
		elseif key.name == "-"
			if str == "" or str == "0"
				if minimum != nil
					if minimum < 0
						str = "-"
					end
				else
					str = "-"
				end
			end
		elseif key.num >= 48 and key.num <= 57
			S_StartSound(nil, sfx_menu1, consoleplayer)
			str = str..key.name
		end
		if str == "" or str == " " then str = "0" end
		if str != "-"
			local num = tonumber(str)
			if num > 0
				arg = num
				local maxs
				if maximum != nil
					maxs = maximum
					if arg > maxs then arg = maxs end
				end
			elseif num < 0
				arg = num
				local mins
				if minimum != nil
					mins = minimum
					if arg < mins then arg = mins end
				end
			else
				arg = 0
			end
		else
			arg = "-"
		end
	elseif it_type == "float"
		local negative = false
		local float = arg
		local maxs = maximum
		local mins = minimum
		local dot
		local int
		local fcl
		if string.find(float, "%.")
			dot = string.find(float, "%.")
			int = tonumber(string.sub(float, 1, dot-1))
			fcl = (string.sub(float, dot+1))
		else
			int = tonumber(float)
		end
		if string.find(arg, "-")
			negative = true
		else
			negative = false
		end
		if maxs == nil or maxs > FRACUNIT then maxs = FRACUNIT end
		if mins == nil or mins < -FRACUNIT then mins = -FRACUNIT end
		if key.name == "backspace"
			S_StartSound(nil, sfx_tink, consoleplayer)
			if float == "-"
				negative = false
				float = string.sub(float, 0, string.len(float)-1)
			elseif float != ""
				float = string.sub(float, 0, string.len(float)-1)
			end
		elseif key.num >= 48 and key.num <= 57
			S_StartSound(nil, sfx_menu1, consoleplayer)
			if float == "0"
				float = key.name
			else
				float = float..key.name
			end
		elseif key.name == "." or key.name == ","
			if not string.find(float, "%.")
				local setdot = 0
				if maxs >= 0 and maxs != int
				or maxs < 0
					setdot = $ + 1 
				end
				if mins < 0 and mins != int
				or mins >= 0
					setdot = $ + 1
				end
				if setdot >= 2
					if float == ""
						float = "0."
					else
						float = float.."."
					end
				end
			end
		elseif key.name == "-"
			if float == "0" and negative == false
				if mins == nil
				or mins != nil
				and mins < 0
					negative = true
				end
			end
		end
		if float == "" then float = "0" end
			if string.find(float, "%.")
				dot = string.find(float, "%.")
				int = tonumber(string.sub(float, 1, dot-1))
				fcl = (string.sub(float, dot+1))
				if negative == true
					if not string.find(float, "-") then float = "-"..float end
					if int and int > 0 then int = $ *-1 end
				else
					float = string.gsub(float, "-", "")
					if int and int and int < 0 then int = $ *-1 end
				end
			else
				int = tonumber(float)
				if negative == true
					if not string.find(float, "-") then float = "-"..float end
					if int and int > 0 then int = $ *-1 end
				else
					float = string.gsub(float, "-", "")
					if int and int < 0 then int = $ *-1 end
				end
			end
			if int != nil
				if string.find(float, "%.")
					if fcl == nil then fcl = "" end
					if string.len(fcl) > 4 then fcl = string.sub(fcl, 0, 4) end
					if int >= 0
						if maxs != nil and int > maxs then float = maxs
					else float = int.."."..fcl end
				elseif int < 0
					if mins != nil and int < mins then float = mins..fcl
					else float = int.."."..fcl end
				end
			else
				if int >= 0
					if maxs != nil and int > maxs then float = maxs
					else float = int end
				elseif int < 0
					if mins != nil and int < mins then float = mins
					else float = int end
				end
				if negative == true
					if not string.find(float, "-") then float = "-"..float end
				end
			end
		end
		arg = tostring(float)
	end
	return arg
end

return true
