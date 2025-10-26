local LC = LithiumCore

local json = json //LC_require "json.lua"

LC.commands["groupeditor"] = {
	name = "LC_groupeditor"
}

LC.functions.RegisterCommand("groupeditor", LC.commands["groupeditor"])

local ConfirmChanges = function(player, silent)
	if player.LC_groupeditor
		local ge = player.LC_groupeditor
		if ge.action == "edit"
			if LC.serverdata.groups.list[ge.name]
				if silent != true
					CONS_Printf(player, "\x83".."NOTICE\x80"..": Group \""..ge.group.color..ge.name.."\"\x80 has been successfully modified.")
				end
			else
				if silent != true
					CONS_Printf(player, "\x83".."NOTICE\x80"..": Group \""..ge.group.color..ge.name.."\"\x80 has been successfully created.")
				end
				table.insert(LC.serverdata.groups.num, ge.name)
			end
			LC.serverdata.groups.list[ge.name] = ge.group
			LC.functions.SaveGroups("save")
		elseif ge.action == "remove"
			if LC.serverdata.groups.list[ge.name]
				if silent != true
					CONS_Printf(player, "\x83".."NOTICE\x80"..": Group \""..ge.group.color..ge.name.."\"\x80 has been successfully removed.")
				end
				for i = 1, #LC.serverdata.groups.num do
					if LC.serverdata.groups.num[i] == ge.name
						table.remove(LC.serverdata.groups.num, i)
						break
					end
				end
				local p_count = 0
				for player in players.iterate do
					if player and player.valid
						if player.group == ge.name
							p_count = $ + 1
							player.group = LC.serverdata.groups.sets["player"] or nil
						end
					end
				end
				if p_count == 0
					if silent != true
						CONS_Printf(player, "No players from this group.")
					end
				else
					if silent != true
						if LC.serverdata.groups.sets["player"]
							local group = LC.serverdata.groups.list[LC.serverdata.groups.sets["player"]]
							CONS_Printf(player, p_count.." players had this group, now their group is \""..group.color..group.displayname.."\x80".."\".")
						else
							CONS_Printf(player, p_count.." players had this group.")
						end
					end
				end
				LC.serverdata.groups.list[ge.name] = nil
				LC.functions.SaveGroups("save")
			end
		end
	end
end

COM_AddCommand(LC.commands["groupeditor"].name, function(player, ...)
	local DoIHavePerm = false
	local sets = LC.commands["groupeditor"]
	DoIHavePerm = LC.functions.CheckPerms(player, sets.perm)
	if DoIHavePerm != true
		CONS_Printf(player, LC.shrases.noperm)
		return
	end
	if not ... then return end
	if tostring(...):lower() == "confirm"
		ConfirmChanges(player)
		return
	end
	local group
	local groupname
	local flags = {}
	local IsNewGroup = false
	local edited = false
	for k, v in ipairs({...}) do
		if v:find("=")
			local equal = v:find("=")-1
			local key = v:sub(1, equal) key = key:gsub(" ", "") key = key:lower()
			local value = v:sub(equal+2)
			//CONS_Printf(player, "Key: "..tostring(key).." Value: "..tostring(value))
			if key == "name"
				if LC.serverdata.groups.list[value]
					local target = LC.serverdata.groups.list[value]
					if player != server and sets.onlyhighpriority == true
						if target.priority >= LC.serverdata.groups.list[player.group].priority
							CONS_Printf(player, LC.shrases.highpriority)
							return
						end
					end
					group = {
						displayname = target.displayname,
						color = target.color,
						priority = target.priority,
						admin = target.admin,
						perms = target.perms
					}
					IsNewGroup = false
				else
					group = {
						displayname = value,
						color = "\x80",
						priority = 0,
						admin = 0,
						perms = {}
					}
					IsNewGroup = true
				end
				groupname = value
				break
			end
		end
	end
	if not group or not groupname
		CONS_Printf(player, "\x82".."WARNING\x80"..": Name value is required to edit the group!")
		return
	end
	for k, v in ipairs({...}) do
		if v:lower() == "-force" or v:lower() == "-f" or v:lower() == "-skipconfirm"
			flags.skipconfirm = true
		elseif v:lower() == "-delete" or v:lower() == "-remove" or v:lower() == "-r"
			flags.delete = true
		elseif v:lower() == "-silent" or v:lower() == "-s"
			flags.silent = true
		end
	end
	if flags.delete == true
		if LC.serverdata.groups.list[groupname]
			local group = LC.serverdata.groups.list[groupname]
			if LC.serverdata.groups.sets["superadmin"] == groupname
				CONS_Printf(player, "\x82".."WARNING\x80"..": You can't delete this group, it's a specialized group for super admin.")
				return
			elseif LC.serverdata.groups.sets["bot"] == groupname
				CONS_Printf(player, "\x82".."WARNING\x80"..": You can't delete this group, it's a specialized group for player bots.")
				return
			elseif LC.serverdata.groups.sets["unregistered"] == groupname
				CONS_Printf(player, "\x82".."WARNING\x80"..": You can't delete this group, it's a specialized group for players without an account.")
				return
			elseif LC.serverdata.groups.sets["player"] == groupname
				CONS_Printf(player, "\x82".."WARNING\x80"..": You can't delete this group, it's a specialized group for players.")
				return
			end
			player.LC_groupeditor = {name = groupname, group = group, action = "remove"}
			if flags.skipconfirm != true
				CONS_Printf(player, "\x83".."NOTICE\x80"..": Type \""..sets.name.." confirm\" in the console to remove the group.")
				CONS_Printf(player, "Make sure you delete the group you want to delete. Here is the configuration of the group:")
				local colorname
				for i = 1, #LC.macrolist do
					if group.color == LC.macrolist[i].color
						colorname = LC.macrolist[i].name
						break
					end
				end
				CONS_Printf(player, "Group name: \""..groupname.."\"")
				CONS_Printf(player, "Displayname: \""..group.displayname.."\"")
				CONS_Printf(player, "Color: \""..colorname.."\"")
				CONS_Printf(player, "Priority: \""..group.priority.."\"")
				CONS_Printf(player, "Admin: \""..group.admin.."\"")
				CONS_Printf(player, "Perms: \""..json.encode(group.perms).."\"")
			else
				ConfirmChanges(player, flags.silent)
				//COM_BufInsertText(player, sets.name.." confirm")
			end
		else
			CONS_Printf(player, "\x82".."WARNING\x80"..": Group "..groupname.." doesn't exist.")
		end
		return
	end
	for k, v in ipairs({...}) do
		if v:find("=")
			local equal = v:find("=")-1
			local key = v:sub(1, equal) key = key:gsub(" ", "") key = key:lower()
			local value = v:sub(equal+2)
			if key == "displayname"
				edited = true
				group.displayname = value:sub(1, 32)
			elseif key == "color"
				edited = true
				for i = 1, #LC.macrolist do
					if tonumber(value) == i
					or tonumber(value) == LC.colormaps[i].value
					or value:lower() == LC.colormaps[i].name:lower()
						group.color = LC.colormaps[i].hex
						break
					end
				end
			elseif key == "priority"
				edited = true
				if tonumber(value)
					group.priority = tonumber(value)
				else
					group.priority = 0
				end
			elseif key == "admin"
				edited = true
				if value == "1" or value:lower() == "yes" or value:lower() == "on" or value:lower() == "true"
					group.admin = true
				else
					group.admin = false
				end
			elseif key == "perms" or key == "addperms"
				edited = true
				local source = value
				local t = {}
				local pk = {}
				if value == "none"
					group.perms = {}
					continue
				end
				if key == "addperms" and IsNewGroup != true
					if not groupname then continue end
					for g = 1, #LC.serverdata.groups.list[groupname].perms do
						table.insert(t, LC.serverdata.groups.list[groupname].perms[g])
						pk[LC.serverdata.groups.list[groupname].perms[g]] = true
					end
				end
				while true do
					if source == "" or source == " " or source == ","
						break
					end
					while true do
						if source:find(",") == 1
						or source:find(" ") == 1
							source = source:sub(2)
						else
							break
						end
					end
					local comma = source:find(",")
					if comma
						local arg = source:sub(1, comma-1)
						if pk[arg] then continue end
						table.insert(t, arg)
						source = source:sub(comma+1)
					else
						local arg = source:sub(1)
						if pk[arg] then continue end
						table.insert(t, arg)
						break
					end
				end
				group.perms = t
			end
		end
	end
	if group
		if edited == true
			player.LC_groupeditor = {name = groupname, group = group, action = "edit"} 
		else
			if not LC.serverdata.groups.list[groupname]
				CONS_Printf(player, "\x82".."WARNING\x80"..": Group "..groupname.." doesn't exist.")
				return
			end
		end
		if flags.skipconfirm != true 
		or edited == false
			if edited == true
				if IsNewGroup == true
					CONS_Printf(player, "\x83".."NOTICE\x80"..": Type \""..sets.name.." confirm\" in the console to create a new group.")
					CONS_Printf(player, "Here is the configuration of the new group:")
				elseif IsNewGroup == false
					CONS_Printf(player, "Type \""..sets.name .."confirm\" in the console to save the group changes.")
					CONS_Printf(player, "Here is the modified configuration of the existing group:")
				end
			else
				CONS_Printf(player, "Information about group:")
			end
			local colorname
			for i = 1, #LC.macrolist do
				if group.color == LC.macrolist[i].color
					colorname = LC.macrolist[i].name
					break
				end
			end
			CONS_Printf(player, "Group name: \""..groupname.."\"")
			CONS_Printf(player, "Displayname: \""..group.displayname.."\"")
			CONS_Printf(player, "Color: \""..colorname.."\"")
			CONS_Printf(player, "Priority: \""..group.priority.."\"")
			CONS_Printf(player, "Admin: \""..tostring(group.admin).."\"")
			CONS_Printf(player, "Perms: \""..json.encode(group.perms).."\"")
		else
			ConfirmChanges(player, flags.silent)
			//COM_BufInsertText(player, sets.name.." confirm")
		end
	end
end)

return true
