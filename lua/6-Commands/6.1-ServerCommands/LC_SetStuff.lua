local LC = LithiumCore

COM_AddCommand("setstuff", function(player, pname, arg1, arg2, arg3, arg4)
	if player != server
		if server.isdedicated != true
			//CONS_Printf(player, "Remote admin can't use this command.")
			return
		end
	end
	if pname == nil
		return
	end
	local player2 = LC.functions.FindPlayer(pname)
	if player2 then
	
		if arg1 then
			player2.score = arg1
		end
		
		if arg2 then
			player2.lives = arg2
		end
		
		if arg3 then
			if not LC.functions.IsSpecialStage(gamemap)
				player2.powers[pw_shield] = arg3
				P_SpawnShieldOrb(player2)
			elseif LC.functions.IsSpecialStage(gamemap)
				player2.saveshield = arg3
			end
		end
		
		if arg4 then
			if arg4 != "none"
				local N = tonumber(arg4)
				if N ~= nil then
					player2.skipscrap = N
				end
			end
		end
		
	end
end, 1)

return true
