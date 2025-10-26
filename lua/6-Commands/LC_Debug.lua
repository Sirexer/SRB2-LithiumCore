local LC = LithiumCore

COM_AddCommand("LC_debughud", function(player, hook, page)
	if player
		if hook
			if string.lower(hook) == "all"
				player.LC_debughud = {hook = "all"}
			else
				for k, v in pairs(LC.Hooks) do
					if string.lower(k) == string.lower(hook)
						player.LC_debughud = {hook = k}
						return
					end
				end
				player.LC_debughud = nil
			end
		end
	end
end, COM_LOCAL)

return true
