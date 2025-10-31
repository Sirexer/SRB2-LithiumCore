local LC = LithiumCore

COM_AddCommand("LC_voting", function(player, vote_type, ...)
	if not multiplayer then
		CONS_Printf(player, "It's only for netgames!")
		return
	end
	
	if LC.serverdata.voting then
		CONS_Printf(player, "Voting is already in progress")
		return
	end
	
	if LC.serverdata.vote_cd and not IsPlayerAdmin(player) and server ~= consoleplayer then
		CONS_Printf(player, "Wait another "..((LC.serverdata.vote_cd/TICRATE) + 1).." seconds to start voting.")
		return
	end
	
	if not vote_type or not LC.vote_types[vote_type:lower()] then
		if vote_type and not LC.vote_types[vote_type:lower()] then
			CONS_Printf(player, vote_type.." is not exist!")
		end
	
		CONS_Printf(player, "Available vote types:")
		
		local str_votes = ""
		for k, v in pairs(LC.vote_types) do
			str_votes = str_votes.."LC_voting "..k.." "..v.help_str.."\n"
		end
		
		if str_votes ~= ""
			str_votes = str_votes:sub(1, str_votes:len() - 1 )
		else
			str_votes = "No available vote types"
		end
			
		CONS_Printf(player, str_votes)
		return
	end
	
	vote_type = vote_type:lower()
	
	local vote_t = LC.vote_types[vote_type]
	local vote_enabled = LC.serverdata.vote_cvars[vote_type]["enabled"].value
	
	if vote_enabled == 0 then
		CONS_Printf(player, "This type of voting is disabled on the server")
		return
	end
	
	local tab, t = vote_t.func_start(player, ...)
	
	if tab ~= true and t then
		CONS_Printf(player, t)
	end
	
	if type(t) ~= "table" then return end
	
	LC.functions.startVote(vote_type, player, t.hud_data, t.targets)
	
	LC.serverdata.vote_cd = LC.consvars.vote_calmdown.value * TICRATE
	
	if LC.client_consvars["LC_votehud"].value == 0 or isdedicatedserver then
		print(
			"\x82"..player.name.."\x80 is starting the vote.",
			"\x84"..t.hud_data.str_vote,
			"Reason: "..t.hud_data.reason,
			"\x8e".."Voting will be ended in 30 seconds."
		)
	end
end)

return true
