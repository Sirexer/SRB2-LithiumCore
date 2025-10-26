local LC = LithiumCore

local json = json //LC_require "json.lua"

local load_state = function()
	-- Load server state
	local servercfg_data
	local state_file = io.openlocal(LC.serverdata.folder.."/serverstate.sav2", "r")
	if state_file 
		local state_data = state_file:read()
		state_file:close()
		xpcall(
			function()
				LC.serverdata.serverstate = json.decode(state_data)
			end,
			function()
				local ostime = os.time()
				print("\x82".."WARNING".."\x80"..": serverstate.sav2 is damaged, create a new serverstate.sav2...")
				print("Damaged file will be saved as serverstate_"..ostime..".dead.sav2")
				local copy_file = io.openlocal(LC.serverdata.folder.."/serverstate_"..ostime..".dead.sav2", "w")
				copy_file:write(state_data)
				copy_file:close()
			end
		)
	end
end

table.insert(LC_LoaderCFG["server"], load_state)

return true
