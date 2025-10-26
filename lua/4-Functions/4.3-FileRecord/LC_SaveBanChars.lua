local LC = LithiumCore

local json = json //LC_require "json.lua"

LC.functions.SaveBanChars = function()
	if isserver != true then return end
	/*
	local str = "[\n"
	local ids = 0
	for i = 1, #LC.serverdata.banchars do
		if type(LC.serverdata.banchars[i]) == "string"
			local cons = "\""..LC.serverdata.banchars[i].."\""
			if ids == 0
				str = str..cons
			else
				str = str..",\n"..cons
			end
			ids = $ + 1
		end
	end
	str = str.."\n]"
	*/
	local str = ""
	for i = 1, #LC.serverdata.banchars do
		if i != #LC.serverdata.banchars
			str = str..LC.serverdata.banchars[i].."\n"
		elseif i == #LC.serverdata.banchars
			str = str..LC.serverdata.banchars[i]
		end
	end
	local cpcfg_file = io.openlocal(LC.serverdata.folder.."/banchars.cfg", "w")
	cpcfg_file:write(str)
	cpcfg_file:close()
	return str
end

return true
