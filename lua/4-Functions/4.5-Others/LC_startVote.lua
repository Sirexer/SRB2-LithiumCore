local LC = LithiumCore



function LC.functions.startVote(vote_type, source, hud_data, targets)
	if not vote_type then return end
	if not LC.vote_types[vote_type:lower()] then return end
	
	if LC.client_consvars["LC_votesfx"].value ~= 0 then
		local vsfx_now	= LC.VoteSFX[ LC.client_consvars["LC_votesfx"].string ].now
		S_StartSound(nil, vsfx_now, consoleplayer)
	end
	
	LC.serverdata.voting = {
		type = vote_type:lower(),
		hud_data = hud_data,
		hud_pos = {x = 0, y = 0},
		source = source,
		targets = targets,
		status = "waiting",
		time = 30*TICRATE,
		votes = {
			yes = 0,
			no = 0,
			actors = {}
		}
	}
	
end

return true-- End of File