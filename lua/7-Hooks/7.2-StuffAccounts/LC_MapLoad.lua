local LC = LithiumCore

local hooktable = {
	name = "LC.StuffAccounts",
	type = "MapLoad",
	toggle = true,
	TimeMicros = 0,
	func = function()
		for player in players.iterate do
			if G_IsSpecialStage(gamemap) then return end
			if (player.spectator) then return end
			if player.saveshield
				player.powers[pw_shield] = player.saveshield
				P_SpawnShieldOrb(player)
			end
			if player.delaychange
				player.delaychange = nil
			end
			if player.returnscore
				if player.score == 0
					player.score = player.returnscore
				end
			end
		end
		LC.accounts.OtherStuff = {}
		if isserver == true
			for k, v in pairs(LC.accounts.loaded) do
				if LC.accounts.loaded[k]
					local path = LC.accounts.accountsfolder..k..".sav2"
					local data = json.encode(LC.accounts.loaded[k])
					local file_playerstate = io.openlocal(path, "w")
					file_playerstate:write(data)
					file_playerstate:close()
					print("Account with username "..k.." saved.")
				end
			end
		end
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true
