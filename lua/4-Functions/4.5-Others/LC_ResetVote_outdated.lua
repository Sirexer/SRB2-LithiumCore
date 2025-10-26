local LC = LithiumCore

LC.functions.resetvote = function()
	for player in players.iterate do
		if player.LC_voted then player.LC_voted = nil end
	end
	LC.serverdata.callvote.playersforvote = 0
	LC.serverdata.callvote.allplayers = 0
	LC.serverdata.callvote.reason = nil
	LC.serverdata.callvote.type = nil
	LC.serverdata.callvote.passed = nil
	LC.serverdata.callvote.map = nil
	LC.serverdata.callvote.mapr = nil
	LC.serverdata.callvote.playernode = nil
	LC.serverdata.callvote.timeleft = 0
	LC.serverdata.callvote.timecd = 0
	LC.serverdata.callvote.for_yes = 0
	LC.serverdata.callvote.for_no = 0
end

return true
