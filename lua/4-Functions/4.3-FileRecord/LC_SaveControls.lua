local LC = LithiumCore

LC.functions.SaveControls = function(arg)
	local str = "[\n"
	local ids = 0
	if arg == "new"
		for i = 1, #LC.controls do
			if type(LC.controls[i]) == "table"
				/*
				local cons = "\""..LC.controls[i].name.."\": \""..LC.controls[i].defaultkey.."\""
				if ids == 0
					str = str..cons
				else
					str = str..",\n"..cons
				end
				ids = $ + 1
				*/
				local cons = "    {\"name\": \""..LC.controls[i].name.."\", \"key\": \""..LC.controls[i].defaultkey.."\"}"
				if ids == 0
					str = str..cons
				else
					str = str..",\n"..cons
				end
				ids = $ + 1
			end
		end
	elseif arg == "save"
		local LC_Controls = LC.localdata.controls
		/*
		for k, v in pairs(LC_Controls) do
			if LC_Controls[k]
				local cons = "\""..k.."\": \""..LC_Controls[k].."\""
				if ids == 0
					str = str..cons
				else
					str = str..",\n"..cons
				end
				ids = $ + 1
			end
		end
		*/
		for i in ipairs(LC_Controls) do
			if LC_Controls[i]
				local cons = "    {\"name\": \""..LC_Controls[i].name.."\", \"key\": \""..LC_Controls[i].key.."\"}"
				if ids == 0
					str = str..cons
				else
					str = str..",\n"..cons
				end
				ids = $ + 1
			end
		end
	end
	str = str.."\n]"
	local control_file = io.openlocal(LC.serverdata.clientfolder.."/controls.cfg", "w")
	control_file:write(str)
	control_file:close()
	return str
end

return true
