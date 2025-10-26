local LC = LithiumCore

local json = json //LC_require "json.lua"

LC.functions.SaveCommandPerms = function()
	if isserver != true then return end
	local str = "{\n"
	local ids = 0
	for k, v in pairs(LC.serverdata.commands) do
		if type(LC.serverdata.commands[k]) == "table"
			local cons = "\""..k.."\": {\n"
			if LC.serverdata.commands[k].perm
				cons = cons.."   \"perm\": \""..LC.serverdata.commands[k].perm.."\",\n"  
			else
				cons = cons.."   \"perm\": \"\",\n"  
			end
			cons = cons.."   \"chat\": "..json.encode(LC.serverdata.commands[k].chat)..",\n"   
			cons = cons.."   \"useonself\": "..json.encode(LC.serverdata.commands[k].useonself)..",\n"   
			cons = cons.."   \"useonhost\": "..json.encode(LC.serverdata.commands[k].useonhost)..",\n"   
			cons = cons.."   \"onlyhighpriority\": "..json.encode(LC.serverdata.commands[k].onlyhighpriority).."\n}"   
			if ids == 0
				str = str..cons
			else
				str = str..",\n"..cons
			end
			ids = $ + 1
		end
	end
	str = str.."\n}"
	local cpcfg_file = io.openlocal(LC.serverdata.folder.."/commandperms.cfg", "w")
	cpcfg_file:write(str)
	cpcfg_file:close()
	return str
end

return true
