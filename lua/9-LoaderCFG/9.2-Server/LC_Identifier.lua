local LC = LithiumCore

local load_id = function()
	-- Set the server ID, this is needed for autologin	
	local id_file = io.openlocal(LC.serverdata.folder.."/identifier.dat", "r")
	print("Setting the ID from the file...")
	if id_file 
		local id_data = id_file:read()
		id_file:close()
		if id_data != nil and id_data != ""
			LC.serverdata.id = id_data
		end
	end
	if LC.serverdata.id == nil
		print("ID not found, create a new ID...")
		LC.serverdata.id = LC.functions.GetRandomPassword("N", 16)
		local id_file = io.openlocal(LC.serverdata.folder.."/identifier.dat", "w")
		id_file:write(LC.serverdata.id)
		id_file:close()
	end
	print("LithiumCore Server ID set: "..LC.serverdata.id)
end

table.insert(LC_LoaderCFG["server"], load_id)

return true
