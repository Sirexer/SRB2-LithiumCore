local LC = LithiumCore

local t = {at = nil, am = nil, fm = nil, sm = nil, bt = nil}

local hooktable = {
	name = "LC.Main",
	type = "PlayerCmd",
	toggle = true,
	TimeMicros = 0,
	func = function(player, cmd)
		if LC.localdata.motd.open == true
		or LC.localdata.loginwindow
		or LC.menu.player_state
		or LC.localdata.AltScores.enabled == true and LC.localdata.AltScores.holded == false
			if leveltime < 1 or player.jointime < 1 then t = {} return end
			t.at = t.at or cmd.angleturn
			t.am = t.am or cmd.aiming
			t.fm = t.fm or cmd.forwardmove
			t.sm = t.sm or cmd.sidemove
			t.bt = t.bt or cmd.buttons
			cmd.forwardmove = t.fm
			cmd.sidemove = t.sm
			cmd.buttons = t.bt
			cmd.angleturn = t.at
			cmd.aiming = t.am
		else
			t.at = cmd.angleturn
			t.am = cmd.aiming
			t.fm = cmd.forwardmove
			t.sm = cmd.sidemove
			t.bt = cmd.buttons
		end
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true
