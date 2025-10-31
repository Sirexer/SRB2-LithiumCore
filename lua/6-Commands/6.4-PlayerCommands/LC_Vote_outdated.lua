local LC = LithiumCore

LC.commands["LC_vote"] = {
	name = "vote",
	chat = "vote"
}

LC.functions.RegisterCommand("LC_vote", LC.commands["LC_vote"])

COM_AddCommand(LC.commands["LC_vote"].name, function(player, arg1)
	if LC.serverdata.callvote.type == nil
		return
	end
	if player.LC_voted == true
		CONS_Printf(player, "You already voted!")
		return
	end
	if not arg1
		CONS_Printf(player, "To vote yes, use \"vote yes\", if you want to vote no, use \"vote no\"")
		return
	end
	local vote = string.upper(arg1)
	if vote == "YES"
		if player.LC_voted != true
			LC.serverdata.callvote.for_yes = $ + 1
			player.LC_voted = true
			print("\x82"..player.name.." votes \"".."\x83".."YES".."\x82".."\".")
			return
		end
	elseif vote == "NO"
		if player.LC_voted != true
			LC.serverdata.callvote.for_no = $ + 1
			player.LC_voted = true
			print("\x82"..player.name.." votes \"".."\x85".."NO".."\x82".."\".")
			return
		end
	end
	CONS_Printf(player, "To vote yes, use \"vote yes\", if you want to vote no, use \"vote no\"")
end)

return true
