local LC = LithiumCore

local hooktable = {
	name = "LC.ChatMSG",
	type = "PlayerThink",
	toggle = true,
	TimeMicros = 0,
	func = function(player)
		if player.cantspeak
			if player.cantspeak != 0 then player.cantspeak = $ - 1 end
		end
		if player.LC_ignorelist
			if player.LC_ignorelist.players and player.LC_ignorelist.players[1]
				for i = 1, #player.LC_ignorelist.players do
					if player.LC_ignorelist.players[i].stuffname != nil
						if not player.LC_ignorelist.accounts then player.LC_ignorelist.accounts = {} end
						table.insert(player.LC_ignorelist.accounts, player.LC_ignorelist.players[i].stuffname)
						table.remove(player.LC_ignorelist.players, i)
					end
				end
			end
		end
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true
