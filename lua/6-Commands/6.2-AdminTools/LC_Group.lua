local LC = LithiumCore

LC.commands["group"] = {
	name = "LC_group",
	perm = "LC_group",
	useonself = true,
	useonhost = false,
	onlyhighpriority = true
}

LC.functions.RegisterCommand("group", LC.commands["group"])

COM_AddCommand(LC.serverdata.commands["group"].name, function(player, pname, group, silince)
	local DoIHavePerm = false
	local sets = LC.serverdata.commands["group"]
	if not player.group and server != player
		CONS_Printf(player, LC.shrases.noperm)
		return
	end
	DoIHavePerm = LC.functions.CheckPerms(player, LC.serverdata.commands["group"].perm)
	if DoIHavePerm != true
		CONS_Printf(player, LC.shrases.noperm)
		return
	end
	if not pname then
		CONS_Printf(player, LC.serverdata.commands["group"].name.." <player> <group> <silince: true/false>")
		return
	end

	
	local player2 = LC.functions.FindPlayer(pname)
	if player2 then
		if sets.useonself == false
			if player == player2
				CONS_Printf(player, "You can't use it on yourself")
				return
			end
		end
		if sets.useonhost == false
			if player2 == server
				if player != server
					CONS_Printf(player, "You can't use it on host")
					return
				end
			end
		end
		if player != server and sets.onlyhighpriority == true
			if LC.serverdata.groups.list[player2.group].priority >= LC.serverdata.groups.list[player.group].priority
				CONS_Printf(player, LC.shrases.highpriority)
				return
			end
		end
		if not group
			if player2.group
				print(player2.name.." in \""..LC.serverdata.groups.list[player2.group].displayname.."\" group")
			end
			return
		end
		if group
			local argn = tonumber(group)
			if argn != nil
				if LC.serverdata.groups.num[argn]
					group = tostring(LC.serverdata.groups.num[argn])
				end
			end
			if not LC.serverdata.groups.list[group]
				CONS_Printf(player, LC.shrases.nogroup)
				return
			end
			if player == server or LC.serverdata.groups.list[player.group].priority > LC.serverdata.groups.list[group].priority 
				player2.group = group
			else
				CONS_Printf(player, "This group cannot be issued because it has higher priority than yours")
				return
			end
			if silince != "true" or silince != "1" or silince != "yes"
				CONS_Printf(player2, "You're in \""..LC.serverdata.groups.list[group].displayname.."\" now.")
			end
			if LC.serverdata.groups.list[group].admin == true
			and not IsPlayerAdmin(player2)
				COM_BufInsertText(server, "promote "..#player2)
			elseif LC.serverdata.groups.list[group].admin == false
			and IsPlayerAdmin(player2)
				COM_BufInsertText(server, "demote "..#player2)
			end
		end
	end
end)

return true
