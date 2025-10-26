local LC = LithiumCore

local json = json //LC_require "json.lua"

local load_bl = function()
	local banlist_file = io.openlocal(LC.serverdata.folder.."/banlist.cfg", "r")
	if banlist_file
		local banlist_data = banlist_file:read("*a")
		xpcall(
			function()
				print("Reading the banlist file...")
				if banlist_data != ""
					LC.serverdata.banlist = json.decode(banlist_data)
				end
			end,
			function()
				local ostime = os.time()
				print("\x82".."WARNING".."\x80"..":Banlist.cfg is damaged, create a new Banlist.cfg...")
				print("Damaged file will be saved as Banlist_"..ostime..".dead.cfg")
				local copy_file = io.openlocal(LC.serverdata.folder.."/Banlist_"..ostime..".dead.cfg", "w")
				copy_file:write(banlist_data)
				copy_file:close()
				local banlist_file = io.openlocal(LC.serverdata.folder.."/banlist.cfg", "w")
				banlist_file:write("")
				banlist_file:close()
			end
		)
	else
		local banlist_file = io.openlocal(LC.serverdata.folder.."/banlist.cfg", "w")
		banlist_file:write("")
		banlist_file:close()
	end
end

table.insert(LC_LoaderCFG["server"], load_bl)

return true
