local LC = LithiumCore

COM_AddCommand("lcln_print", function(player, pname, type, str)
	if server != player
		//CONS_Printf(player, "This command is used only for the server")
		return
	end
	local player2 = LC.functions.FindPlayer(pname)
	if player2
		if type == "error"
			str = "\x82"..str
			if player2.LC_menu
				player2.LC_menu.lognotice = str
				S_StartSound(nil, sfx_s3kb2, player)
			end
		elseif type == "success"
			str = "\x83"..str
			if player2.LC_menu
				player2.LC_menu.lognotice = str
				S_StartSound(nil, sfx_strpst, player2)
			end
		end
	end
end)

return true
