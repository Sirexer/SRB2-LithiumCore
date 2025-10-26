local LC = LithiumCore

local CV_Forceskin = CV_FindVar("forceskin")

local hooktable = {
	name = "LC.BanChars",
	type = "ThinkFrame",
	toggle = true,
	TimeMicros = 0,
	func = function(player)
		if CV_Forceskin.string != "None"
		or not mapheaderinfo[gamemap].forcecharacter
		and mapheaderinfo[gamemap].forcecharacter != ""
			return
		end
		if LC.consvars["LC_allowbanchars"].value != 3
			local change_t = {}
			local ban_t = {}
			for s = 0, #skins-1 do
				for b = 1, #LC.serverdata.banchars
					if skins[s].name ==	LC.serverdata.banchars[b]
						table.insert(ban_t, s, true)
						break
					end
				end
				if not ban_t[s]
					table.insert(change_t, s) 
				end
			end
			if change_t[1] != nil
				for player in players.iterate do
					if LC.consvars["LC_allowbanchars"].value == 1
					and player == server
						continue
					elseif LC.consvars["LC_allowbanchars"].value == 2
						if player == server
						or IsPlayerAdmin(player)
							continue
						end
					end
					if player.bot != 0 then continue end
					if ban_t[player.skin] != nil
						local randomskin = P_RandomRange(1, #change_t)
						R_SetPlayerSkin(player, change_t[randomskin])
					end
				end
			end
		end
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true
