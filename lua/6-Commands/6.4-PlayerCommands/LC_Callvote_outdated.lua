local LC = LithiumCore

COM_AddCommand("LC_callvote", function(player, arg1, arg2, arg3)
	if not multiplayer
		CONS_Printf(player, "It's only for netgames!")
		return
	end
	if not arg1
		CONS_Printf(player, "LC_callvote exitlevel/changemap/kick/ban")
		return
	else
		if LC.serverdata.callvote.type
			CONS_Printf(player, "Voting is already in progress")
			return
		end
		if player.LC_vote_calmdown == nil then player.LC_vote_calmdown = 0 end
		if player.LC_vote_calmdown == 0 or IsPlayerAdmin(player) or player == server
			local started = false
			if string.lower(arg1) == "exitlevel"
				if LC.consvars.al_exitlevel.value == 0
					if player != server
						if not IsPlayerAdmin(player) 
							CONS_Printf(player, "Exitlevel is disabled for players!")
							return
						end
					end
				end
				LC.serverdata.callvote.mapr = gamemap
				if arg2 then LC.serverdata.callvote.reason = arg2 end
				started = true
			elseif string.lower(arg1) == "changemap"
				if LC.consvars.al_changemap.value == 0
					if player != server
						if not IsPlayerAdmin(player) 
							CONS_Printf(player, "Changemap is disabled for players!")
							return
						end
					end
				end
				if arg2
					local mapnum = LC.functions.FindMap(arg2)
					if mapnum != nil
						if G_IsSpecialStage(mapnum) == true
							CONS_Printf(player, "This is Special Stage level!")
							return
						end
						if not (mapheaderinfo[mapnum].typeoflevel & LC.Gametypes["all"]["tol"][gametype])
							CONS_Printf(player, "This is not a "..LC.Gametypes["all"]["name"][gametype].." level.!")
							return 
						end
						if arg3 then LC.serverdata.callvote.reason = arg3 end
						LC.serverdata.callvote.map = mapnum
						started = true
					else
						CONS_Printf(player, "No such map exists")
						return
					end
				end
			elseif string.lower(arg1) == "kick" or string.lower(arg1) == "ban"
				if LC.consvars.al_kick.value == 0 and string.lower(arg1) == "kick"
					if player != server
						if not IsPlayerAdmin(player) 
							CONS_Printf(player, "Kick is disabled for players!")
							return
						end
					end
				elseif LC.consvars.al_ban.value == 0 and string.lower(arg1) == "ban"
					if player != server
						if not IsPlayerAdmin(player) 
							CONS_Printf(player, "Ban is disabled for players!")
							return
						end
					end
				end
				if not arg2
					CONS_Printf(player, "LC_callvote "..string.lower(arg1).."player \"node/name \" \"reason\"")
					return
				end
				if arg2
					local player2 = LC.functions.FindPlayer(arg2)
					if player2 == tonumber("00") or tonumber("0")
						CONS_Printf(player, "You can't kick the host!")
						return
					end
					if not player2
						CONS_Printf(player, "No one here has that name.")
						return
					end
					LC.serverdata.callvote.playernode = player2
					if arg3 then LC.serverdata.callvote.reason = arg3 end
				end
				started = true
			end
			if started == true
				LC.serverdata.callvote.type = string.lower(arg1)
				local allplayers = LC.functions.playerontheserver()
				LC.serverdata.callvote.timeleft = 30*TICRATE
				LC.serverdata.callvote.timecd = 5*TICRATE
				LC.serverdata.callvote.playersforvote = (allplayers/2)+1
				LC.serverdata.callvote.allplayers = allplayers
				local SetX = P_RandomChance(FRACUNIT/2)
				if SetX == false
					LC.serverdata.callvote.y = 128
					LC.serverdata.callvote.x = 0
				else
					LC.serverdata.callvote.y = 0
					LC.serverdata.callvote.x = 128
				end
				S_StartSound(nil, sfx_token, consoleplayer)
				player.LC_vote_calmdown = LC.consvars.calmdown.value*TICRATE
			end
		else
			CONS_Printf(player, "You've run a vote recently, wait "..player.LC_vote_calmdown/TICRATE.." seconds!")
		end
	end
end)

return true
