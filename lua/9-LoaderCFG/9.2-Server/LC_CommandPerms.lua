local LC = LithiumCore

local json = json //LC_require "json.lua"

local load_cp = function()
	-- Load server state
	local cpcfg_data
	local cpcfg_file = io.openlocal(LC.serverdata.folder.."/commandperms.cfg", "r")
	if cpcfg_file 
		print("Reading the command perms file...")
		local cpcfg_data = cpcfg_file:read("*a")
		cpcfg_file:close()
		xpcall(
			function()
				local tabledate = json.decode(cpcfg_data)
				for k, v in pairs(tabledate)
					if type(tabledate[k]) == "table"
						if not LC.serverdata.commands[k] then LC.serverdata.commands[k] = {} end
						if tabledate[k].perm != nil
							LC.serverdata.commands[k].perm = tabledate[k].perm
						else
							LC.serverdata.commands[k].perm = ""
						end
						if tabledate[k].chat != nil
							LC.serverdata.commands[k].chat = tabledate[k].chat
						else
							LC.serverdata.commands[k].chat = nil
						end
						if tabledate[k].useonself != nil
							LC.serverdata.commands[k].useonself = tabledate[k].useonself
						else
							LC.serverdata.commands[k].useonself = true
						end
						if tabledate[k].useonhost != nil
							LC.serverdata.commands[k].useonhost = tabledate[k].useonhost
						else
							LC.serverdata.commands[k].useonhost = false
						end
						if tabledate[k].onlyhighpriority != nil
							LC.serverdata.commands[k].onlyhighpriority = tabledate[k].onlyhighpriority
						else
							LC.serverdata.commands[k].onlyhighpriority = false
						end
					end
				end
			end,
			function()
				local ostime = os.time()
				print("\x82".."WARNING".."\x80"..": commandperms.cfg is damaged, create a new commandperms.cfg...")
				print("Damaged file will be saved as commandperms_"..ostime..".dead.cfg")
				local copy_file = io.openlocal(LC.serverdata.folder.."/commandperms_"..ostime..".dead.cfg", "w")
				copy_file:write(cpcfg_data)
				copy_file:close()
				LC.functions.SaveCommandPerms()
			end
		)
	else
		print("Creating a command perms file...")
		LC.functions.SaveCommandPerms()
	end
end

table.insert(LC_LoaderCFG["server"], load_cp)

return true
