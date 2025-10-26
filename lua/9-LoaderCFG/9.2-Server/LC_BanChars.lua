local LC = LithiumCore

local load_bw = function()
	-- Load server state
	local bccfg_data
	local bccfg_file = io.openlocal(LC.serverdata.folder.."/banchars.cfg", "r")
	if bccfg_file 
		print("Reading the banskins file...")
		local banskin_c = 0
		while true do
			local line = bccfg_file:read("*l")
			if line
				if line == "" or line == " " or line == "\n" then continue end
				table.insert(LC.serverdata.banchars, line)
				banskin_c = $ + 1
			else
				break
			end
		end
		bccfg_file:close()
		print("Added "..banskin_c.." skins to the ban list")
	else
		print("Creating the banskins file...")
		bccfg_file = io.openlocal(LC.serverdata.folder.."/banchars.cfg", "w")
		bccfg_file:close()
	end
end

table.insert(LC_LoaderCFG["server"], load_bw)

return true
