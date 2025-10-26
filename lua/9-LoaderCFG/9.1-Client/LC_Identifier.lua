local LC = LithiumCore

local load_id = function()
	-- Set the client ID
	local id_file = io.openlocal(LC.serverdata.clientfolder.."/identifier.dat", "r")
	print("Setting the ID from the file...")
	if id_file 
		local id_data = id_file:read()
		id_file:close()
		if id_data != nil and id_data != ""
			LC.localdata.id = id_data
		end
	end
	if LC.localdata.id == nil
		print("ID not found, create a new ID...")
		LC.localdata.id = LC.functions.GetRandomPassword("N", 16)
		local id_file = io.openlocal(LC.serverdata.clientfolder.."/identifier.dat", "w")
		id_file:write(LC.localdata.id)
		id_file:close()
	end
	print("LithiumCore Client ID set: "..LC.localdata.id)
end

table.insert(LC_LoaderCFG["client"], load_id)

return true
