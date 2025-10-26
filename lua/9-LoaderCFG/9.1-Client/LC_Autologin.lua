local LC = LithiumCore

local json = json //LC_require "json.lua"

local load_autologin = function()
	-- Load logins and passwords where the player registered and add them to the table
	local autologin_file = io.openlocal(LC.serverdata.clientfolder.."/autologin.dat", "r")
	if autologin_file
		local autologin_data = autologin_file:read("*a")
		autologin_file:close()
		xpcall(
			function()
				LC.localdata.savedpass = json.decode(autologin_data)
			end,
			function()
				local ostime = os.time()
				print("\x82".."WARNING".."\x80"..": autologin.dat is damaged!")
				print("Damaged file will be saved as autologin"..ostime..".dead.dat")
				local copy_file = io.openlocal(LC.serverdata.clientfolder.."/autologin_"..ostime..".dead.dat", "w")
				copy_file:write(autologin_data)
				copy_file:close()
				local autologin_file = io.openlocal(LC.serverdata.clientfolder.."/autologin.dat", "w")
				autologin_file:write("{}")
				autologin_file:close()
			end
		)
	end
end

table.insert(LC_LoaderCFG["client"], load_autologin)

return true
