local LC = LithiumCore

local json = json //LC_require "json.lua"

local load_consvars = function()
	-- Load Server console vars
	local servercfg_data
	local servercfg_file = io.openlocal(LC.serverdata.folder.."/consvars.cfg", "r")
	if servercfg_file
		servercfg_data = servercfg_file:read("*a")
		servercfg_file:close()
		xpcall(
			function()
				servercfg_data = json.decode(servercfg_data)
			end,
			function()
				local ostime = os.time()
				print("\x82".."WARNING".."\x80"..": consvars.cfg is damaged, create a new consvars.cfg...")
				print("Damaged file will be saved as consvars_"..ostime..".dead.cfg")
				local copy_file = io.openlocal(LC.serverdata.folder.."/consvars_"..ostime..".dead.cfg", "w")
				copy_file:write(servercfg_data)
				copy_file:close()
				servercfg_data = LC.functions.SaveCvars("server")
				if servercfg_data and servercfg_data != ""
					servercfg_data = json.decode(servercfg_data)
				else
					servercfg_data = {}
				end
			end
		)
	else
		servercfg_data = LC.functions.SaveCvars("server")
		if servercfg_data and servercfg_data != ""
			servercfg_data = json.decode(servercfg_data)
		else
			servercfg_data = {}
		end
	end
	return {name = "servercfg_data", value = servercfg_data}
end

table.insert(LC_LoaderCFG["server"], load_consvars)

return true
