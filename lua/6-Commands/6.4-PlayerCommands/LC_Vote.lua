local LC = LithiumCore

LC.commands["LC_vote"] = {
	name = "vote",
	chat = "vote"
}

LC.functions.RegisterCommand("LC_vote", LC.commands["LC_vote"])

COM_AddCommand(LC.commands["LC_vote"].name, function(player, arg)
	local voting = LC.serverdata.voting
	
	if not voting then return end
	if not arg then arg = "" end
	
	local votes = voting.votes
	local actor = votes.actors[#player]
	local vote
	if arg:lower() == "yes" then
		vote = true
	elseif arg:lower() == "no" then
		vote = false
	end
	
	if vote == nil then
		CONS_Printf(player, "To vote yes, use \""..LC.commands["LC_vote"].name.." yes\", if you want to vote no, use \""..LC.commands["LC_vote"].name.." no\"")
		return
	end
	
	if not actor then
		votes.actors[#player] = {userdata = player, vote = vote}
		if vote == true then
			votes.yes = $ + 1
		elseif vote == false then
			votes.no = $ + 1
		end
	elseif not actor.userdata or not actor.userdata.valid then
		if actor.vote == true and vote ~= true then
			votes.yes = $ - 1
			votes.no = $ + 1
		elseif actor.vote == false and vote ~= false then
			votes.yes = $ + 1
			votes.no = $ - 1
		end
		votes.actors[#player] = {userdata = player, vote = vote}
	else
		CONS_Printf(player, "You already voted!")
		return
	end
	
	if vote == true then
		print("\x82"..player.name.." votes \"".."\x83".."YES".."\x82".."\".")
	elseif vote == false
		print("\x82"..player.name.." votes \"".."\x85".."NO".."\x82".."\".")
	end
end)

return true
