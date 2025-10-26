local LC = LithiumCore

local json = json //LC_require "json.lua"

local load_skincolors = function()
	-- Load Client console vars
	local skincolors_data
	local skincolors_file = io.openlocal(LC.serverdata.clientfolder.."/skincolors.dat", "r")
	if skincolors_file
		skincolors_data = skincolors_file:read("*a")
		skincolors_file:close()
		xpcall(
			function()
				LC.localdata.skincolors = json.decode(skincolors_data)
			end,
			function()
				local ostime = os.time()
				print("\x82".."WARNING".."\x80"..": skincolors.dat is damaged, create a new skincolors.dat...")
				print("Damaged file will be saved as client_consvars_"..ostime..".dead.cfg")
				local copy_file = io.openlocal(LC.serverdata.clientfolder.."/skincolors_"..ostime..".dead.dat", "w")
				copy_file:write(skincolors_data)
				copy_file:close()
				LC.localdata.skincolors = {default = 1, slots = {}}
			end
		)
	end
end

table.insert(LC_LoaderCFG["client"], load_skincolors)

return true
