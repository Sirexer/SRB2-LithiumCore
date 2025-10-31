local LC = LithiumCore

COM_AddCommand("___lcpi", function(player, arg1, arg2)
	if not player and not player.valid then return end
	
	if not player.LC_indicators then player.LC_indicators = {chat = false, menu = false} end
	
	if arg1 == "chat"
		if arg2 == "true"
			player.LC_indicators.chat = true
		elseif arg2 == "false"
			player.LC_indicators.chat = false
		end
	end
	
	if arg1 == "menu"
		if arg2 == "true"
			player.LC_indicators.menu = true
		elseif arg2 == "false"
			player.LC_indicators.menu = false
		end
	end
	
end)

return true -- End Of File
