local LC = LithiumCore

local json = json //LC_require "json.lua"

local load_consvars = function()
	-- Load Client console vars
	local clientcfg_data
	local clientcfg_file = io.openlocal(LC.serverdata.clientfolder.."/client_consvars.cfg", "r")
	if clientcfg_file
		clientcfg_data = clientcfg_file:read("*a")
		clientcfg_file:close()
		xpcall(
			function()
				clientcfg_data = json.decode(clientcfg_data)
			end,
			function()
				local ostime = os.time()
				print("\x82".."WARNING".."\x80"..": client_consvars.cfg is damaged, create a new client_consvars.cfg...")
				print("Damaged file will be saved as client_consvars_"..ostime..".dead.cfg")
				local copy_file = io.openlocal(LC.serverdata.clientfolder.."/client_consvars_"..ostime..".dead.cfg", "w")
				copy_file:write(clientcfg_data)
				copy_file:close()
				clientcfg_data = LC.functions.SaveCvars("client")
				if clientcfg_data and clientcfg_data != ""
					clientcfg_data = json.decode(clientcfg_data)
				else
					clientcfg_data = {}
				end
			end
		)
	else
		clientcfg_data = LC.functions.SaveCvars("client")
		if clientcfg_data and clientcfg_data != ""
			clientcfg_data = json.decode(clientcfg_data)
		else
			clientcfg_data = {}
		end
	end
	return {name = "clientcfg_data", value = clientcfg_data}
end

table.insert(LC_LoaderCFG["client"], load_consvars)

return true
