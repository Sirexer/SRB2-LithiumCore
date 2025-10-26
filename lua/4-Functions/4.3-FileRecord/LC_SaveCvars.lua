local LC = LithiumCore

LC.functions.SaveCvars = function(arg, old_data)
	local str = "{\n"
	local setted_cvars = {}
	if string.lower(arg) == "server"
		//local consvar_table = {}
		local ids = 0
		for k, v in pairs(LC.consvars) do
			if type(LC.consvars[k]) == "userdata"
			and userdataType(LC.consvars[k]) == "consvar_t"
			and (LC.consvars[k].flags & CV_SAVE)
				local cons = "\""..k.."\": \""..LC.consvars[k].string.."\""
				if ids == 0
					str = str..cons
				else
					str = str..",\n"..cons
				end
				setted_cvars[k] = true
				ids = $ + 1
			end
		end
		if type(old_data) == "table"
			for k, v in pairs(old_data) do
				if type(old_data[k]) == "string"
				and not setted_cvars[k]
					local cons = "\""..k.."\": \""..old_data[k].."\""
					if ids == 0
						str = str..cons
					else
						str = str..",\n"..cons
					end
					ids = $ + 1
				end
			end
		end
		str = str.."\n}"
		local servercfg_file = io.openlocal(LC.serverdata.folder.."/consvars.cfg", "w")
		servercfg_file:write(str)
		servercfg_file:close()
	elseif string.lower(arg) == "client"
		local ids = 0
		for k, v in pairs(LC.client_consvars) do
			if type(LC.client_consvars[k]) == "userdata"
			and userdataType(LC.client_consvars[k]) == "consvar_t"
			and (LC.client_consvars[k].flags & CV_SAVE)
				local cons = "\""..k.."\": \""..LC.client_consvars[k].string.."\""
				if ids == 0
					str = str..cons
				else
					str = str..",\n"..cons
				end
				setted_cvars[k] = true
				ids = $ + 1
			end
		end
		if type(old_data) == "table"
			for k, v in pairs(old_data) do
				if type(old_data[k]) == "string"
				and not setted_cvars[k]
					local cons = "\""..k.."\": \""..old_data[k].."\""
					if ids == 0
						str = str..cons
					else
						str = str..",\n"..cons
					end
					ids = $ + 1
				end
			end
		end
		str = str.."\n}"
		local clientcfg_file = io.openlocal(LC.serverdata.clientfolder.."/client_consvars.cfg", "w")
		clientcfg_file:write(str)
		clientcfg_file:close()
	end
	return str
end

return true
