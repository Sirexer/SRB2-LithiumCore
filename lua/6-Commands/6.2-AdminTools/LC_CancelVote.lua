local LC = LithiumCore

local function vote_failed()
	if LC.client_consvars["LC_votesfx"].value ~= 0 then
		local vsfx_fail	= LC.VoteSFX[ LC.client_consvars["LC_votesfx"].string ].fail
		S_StartSound(nil, vsfx_fail, consoleplayer)
	end
	
	local voting = LC.serverdata.voting
	voting.time = 5*TICRATE
	voting.status = "failed"
end

LC.commands["cancelvote"] = {
	name = "LC_cancelvote",
	perm = "LC_cancelvote"
}

LC.functions.RegisterCommand("cancelvote", LC.commands["cancelvote"])


COM_AddCommand(LC.serverdata.commands["cancelvote"].name, function(player, pname)
	local sets = LC.serverdata.commands["cancelvote"]
	local DoIHavePerm = false
	if not player.group and server != player
		CONS_Printf(player, LC.shrases.noperm)
		return
	end
	DoIHavePerm = LC.functions.CheckPerms(player, sets.perm)
	if DoIHavePerm != true
		CONS_Printf(player, LC.shrases.noperm)
		return
	end
	
	if LC.serverdata.voting
		vote_failed()
		if player == server
			if server.isdedicated == true
				print("Voting canceled by the server.")
				return
			end
		end
		print("Voting canceled by "..player.name.." ")
	end
end)

return true
