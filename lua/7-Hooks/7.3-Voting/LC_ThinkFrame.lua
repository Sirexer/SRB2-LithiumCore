local LC = LithiumCore

local function vote_passed()
	if LC.client_consvars["LC_votesfx"].value ~= 0 then
		local vsfx_pass	= LC.VoteSFX[ LC.client_consvars["LC_votesfx"].string ].pass
		S_StartSound(nil, vsfx_pass, consoleplayer)
	end
	
	local voting = LC.serverdata.voting
	voting.time = 5*TICRATE
	voting.status = "passed"
	if LC.client_consvars["LC_votehud"].value == 0 or isdedicatedserver then
		print(
			"\x82".."The voting has ended.",
			"\x84"..voting.hud_data.str_vote.." ".."\x80".."in... "..voting.time/TICRATE.." seconds"
		)
	end
end

local function vote_failed()
	if LC.client_consvars["LC_votesfx"].value ~= 0 then
		local vsfx_fail	= LC.VoteSFX[ LC.client_consvars["LC_votesfx"].string ].fail
		S_StartSound(nil, vsfx_fail, consoleplayer)
	end
	
	local voting = LC.serverdata.voting
	voting.time = 5*TICRATE
	voting.status = "failed"
	if LC.client_consvars["LC_votehud"].value == 0 or isdedicatedserver then
		print(
			"\x82".."The voting has ended.",
			"\x80".."canceled"
		)
	end
end

local hooktable = {
	name = "LC.voting",
	type = "ThinkFrame",
	toggle = true,
	TimeMicros = 0,
	func = function()
		local voting = LC.serverdata.voting
		
		if not voting then
			if LC.serverdata.vote_cd > 0 then LC.serverdata.vote_cd = $ - 1 end
			return
		end
		
		if voting.status ~= "failed" then
			local stop, reason = LC.vote_types[voting.type].func_stop(voting.targets)
			if stop == true then
				if reason then
					print("Voting stopped for a reason: "..reason)
				end
				LC.serverdata.voting = nil
			end
		end
		
		if voting.status == "waiting" then
			local votes = voting.votes
			local allplayers = LC.functions.playerontheserver()
			local votes_max = (allplayers/2)+1
			
			if voting.time >= 1 then
				voting.time = $ - 1
				if votes.yes == votes_max then
					vote_passed()
				elseif votes.no == votes_max
				or (votes.no + votes.yes) == allplayers and votes.no >= votes.yes then
					vote_failed()
				end
			else
				if votes.yes > votes.no then
					vote_passed()
				else
					vote_failed()
				end
			end
		elseif voting.status == "passed" then
			if voting.time >= 1 then
				voting.time = $ - 1
			else
				LC.vote_types[voting.type].func_action(voting.targets)
				LC.serverdata.voting = nil
			end
		elseif voting.status == "failed" then
			if voting.time >= 1 then
				voting.time = $ - 1
			else
				LC.serverdata.voting = nil
			end
		end
		
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true
