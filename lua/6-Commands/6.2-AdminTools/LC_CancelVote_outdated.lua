local LC = LithiumCore

COM_AddCommand("LC_cancelvote", function(player) 
	if LC.serverdata.callvote.type
		if player == server
			if server.isdedicated == true
				print("Voting canceled by the server.")
				LC.serverdata.callvote.passed = false
				return
			end
		end
		print("Voting canceled by "..player.name.." ")
		LC.serverdata.callvote.passed = false
		local text = "Voting canceled by "..player.name.."\n"
	end
end, 1)

return true
