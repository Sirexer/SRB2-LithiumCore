-- Load and Save Server States
local LC = LithiumCore

local json = json //LC_require "json.lua"
	
LC.functions.SaveState = function()
	if isserver == false then return end
	local sssv = LC.consvars.saveserverstate.value
	if sssv == 1 or sssv == 3
		LC.serverdata.serverstate["emeralds"] = emeralds
	end
	if sssv == 1 or sssv == 2
		local savemap = true
		if titlemap == gamemap
			savemap = false
		end
		if gamemap < smpstage_start and gamemap > smpstage_end
			savemap = false
		end
		if gamemap < sstage_start and gamemap > sstage_end
			savemap = false
		end
		if savemap == true
			LC.serverdata.serverstate["map"] = gamemap
		end
	end
	local data_serverstate = json.encode(LC.serverdata.serverstate)
	local file_serverstate = io.openlocal(LC.serverdata.folder.."/serverstate.sav2", "w")
	file_serverstate:write(data_serverstate)
	file_serverstate:close()
end

return true
