local LC = LithiumCore

LC.functions.saveVotingSettings = function()
	if not isserver then return end
	local str = "{\n"
	local setted_cvars = {}
	local ids = 0
	
	local vs_c = LC.serverdata.vote_cvars
	for k_t, v_t in pairs(vs_c) do
		local cons = "\""..k_t.."\": {\n"
		
		local str_cvar = ""
		for k_c, v_c in pairs(v_t) do
			str_cvar = str_cvar + "  \""..k_c.."\": \""..v_c.string.."\",\n"
		end
		
		str_cvar = str_cvar:sub(1, #str_cvar-2)
		
		cons = cons + str_cvar.."\n},\n"
		str = str + cons
	end
	
	str = str:sub(1, #str-2)
	
	str = str.."\n}"
	local servercfg_file = io.openlocal(LC.serverdata.folder.."/voting_cvars.cfg", "w")
	servercfg_file:write(str)
	servercfg_file:close()
	return str
end

return true
