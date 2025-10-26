local LC = LithiumCore

local json = json //LC_require "json.lua"

local load_tlm = function()
	-- Load Control Settings
	local tlm_file = io.openlocal(LC.serverdata.folder.."/timelimitmaps.cfg", "r")
	local tlm_data
	if tlm_file 
		tlm_data = tlm_file:read("*a")
		tlm_file:close()
		xpcall(
			function()
				LC.serverdata.exitlevel.maps = json.decode(tlm_data)
			end,
			function()
				local ostime = os.time()
				print("\x82".."WARNING".."\x80"..": timelimitmaps.cfg is damaged, create a new timelimitmaps.cfg...")
				print("Damaged file will be saved as timelimitmaps_"..ostime..".dead.cfg")
				local copy_file = io.openlocal(LC.serverdata.folder.."/timelimitmaps_"..ostime..".dead.cfg", "w")
				copy_file:write(tlm_data)
				copy_file:close()
				local tlm_file = io.openlocal(LC.serverdata.folder.."/timelimitmaps.cfg", "w")
				tlm_file:write("{}")
				tlm_file:close()
			end
		)
	else
		local tlm_file = io.openlocal(LC.serverdata.folder.."/timelimitmaps.cfg", "w")
		tlm_file:write("{}")
		tlm_file:close()
	end
end

table.insert(LC_LoaderCFG["server"], load_tlm)

return true
