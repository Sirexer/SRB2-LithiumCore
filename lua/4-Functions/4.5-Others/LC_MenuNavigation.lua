local LC = LithiumCore

-- Menu control functions
LC.functions.getMenuNav = function()
	if LC.menu.player_state
		return LC.menu.player_state.nav
	end
end

LC.functions.setMenuNav = function(arg)
	local int = tonumber(arg)
	if LC.menu.player_state and int
		LC.menu.player_state.nav = int
	end
end

LC.functions.getMenuLastNav = function()
	if LC.menu.player_state
		return LC.menu.player_state.lastnav
	end
end

LC.functions.setMenuLastNav = function(arg)
	local int = tonumber(arg)
	if LC.menu.player_state and int
		LC.menu.player_state.lastnav = int
	end
end

LC.functions.InMenu = function()
	if LC.menu.player_state
		return true
	elseif not LC.menu.player_state
		return false
	end
end

LC.functions.InMotd = function()
	if LC.localdata.motd.open
		return true
	elseif not LC.localdata.motd.open
		return false
	end
end


LC.functions.InGameInfo = function()
	if LC.localdata.AltScores.enabled
		return true
	elseif not LC.localdata.AltScores.enabled
		return false
	end
end

LC.functions.InLogin = function()
	if LC.localdata.loginwindow
		return true
	elseif not LC.localdata.loginwindow
		return false
	end
end

return true -- End Of File
