local LC = LithiumCore

LC.functions.SaveTLM = function()
	local str = "{\n"
	local ids = 0
	local tlm = LC.serverdata.exitlevel.maps
	for k, v in pairs(tlm) do
		if tlm[k] != nil
			local cons = "\""..k.."\": "..tlm[k]
			if ids == 0
				str = str..cons
			else
				str = str..",\n"..cons
			end
			ids = $ + 1
		end
	end
	str = str.."\n}"
	local control_file = io.openlocal(LC.serverdata.folder.."/timelimitmaps.cfg", "w")
	control_file:write(str)
	control_file:close()
	return str
end

return true
