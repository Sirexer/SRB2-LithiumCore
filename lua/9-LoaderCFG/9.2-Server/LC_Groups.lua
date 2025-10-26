local LC = LithiumCore

local json = json //LC_require "json.lua"

local load_groups = function()
	-- Load server state
	local groupcfg_data
	local groupcfg_file = io.openlocal(LC.serverdata.folder.."/groups.cfg", "r")
	if groupcfg_file 
		print("Reading the group file...")
		local groupcfg_data = groupcfg_file:read("*a")
		groupcfg_file:close()
		xpcall(
			function()
				local tabledate = json.decode(groupcfg_data)
				LC.serverdata.groups = {
					list = tabledate.groups,
					sets = tabledate.groupset,
					num = tabledate.grouporder
				}
				local DoSave = false
				if not LC.serverdata.groups.sets
					LC.serverdata.groups.sets = LC.group_default.sets
					print("\x82".."WARNING".."\x80"..": Special groups linking table not found, return default values.") 
					DoSave = true
				else
					for k, v in pairs(LC.group_default.sets) do
						if not LC.serverdata.groups.sets[k]
							
							print("\x82".."WARNING".."\x80"..": No "..k.." linking found, return default value.") 
							DoSave = true
						end
					end
				end
				for k, v in pairs(LC.group_default.sets)
					if not LC.serverdata.groups.list[LC.serverdata.groups.sets[k]]
						LC.serverdata.groups.sets[k] = v
						LC.serverdata.groups.list[v] = LC.group_default.list[v]
						print("\x82".."WARNING".."\x80"..": Group for "..k.." is not found, create default group..") 
						DoSave = true
					end
				end
				if DoSave == true
					print("Overwriting the group file...")
					LC.functions.SaveGroups("save")
				end
			end,
			function()
				local ostime = os.time()
				print("\x82".."WARNING".."\x80"..": Group_config.cfg is damaged, create a new groups.cfg...")
				print("Damaged file will be saved as Groups_"..ostime..".dead.cfg")
				local copy_file = io.openlocal(LC.serverdata.folder.."/groups_"..ostime..".dead.cfg", "w")
				copy_file:write(groupcfg_data)
				copy_file:close()
				LC.functions.SaveGroups("new")
			end
		)
	else
		print("Creating a group file...")
		LC.functions.SaveGroups("new")
	end
end

table.insert(LC_LoaderCFG["server"], load_groups)

return true