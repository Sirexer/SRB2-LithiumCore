local LC = LithiumCore

local hooktable = {
	name = "LC.PilotPlayer",
	type = "PlayerThink",
	toggle = true,
	TimeMicros = 0,
	func = function(player)
		if player.LC_pilot
		and player.LC_pilot.player.valid
			local cmd_pilot = player.LC_pilot.player.cmd
			local cmd_player = player.cmd
			cmd_pilot.forwardmove = cmd_player.forwardmove
			cmd_pilot.sidemove = cmd_player.sidemove
			cmd_pilot.angleturn = cmd_player.angleturn
			cmd_pilot.aiming = cmd_player.aiming
			cmd_pilot.buttons = cmd_player.buttons
			player.charability = 0
			player.charability2 = 0
			player.jumpfactor = 0
			player.normalspeed = 0
			player.actionspd = 0
			player.runspeed = 0
			player.acceleration = 0
			if player.powers[pw_carry] == 0
				player.drawangle = player.LC_pilot.angle
			else
				player.LC_pilot.angle = player.drawangle
			end
			if consoleplayer == player then displayplayer = player.LC_pilot.player end
			//player.powers[pw_nocontrol] = 2
			/*P_SetOrigin(player.realmo, player.LC_pilot.x, player.LC_pilot.y, player.LC_pilot.z)
			player.realmo.momx = 0
			player.realmo.momy = 0
			player.realmo.momz = 0
			cmd_player.forwardmove = 0
			cmd_player.sidemove = 0
			cmd_player.angleturn = 0
			cmd_player.aiming = 0
			cmd_player.buttons = 0
			*/
		elseif player.LC_pilot
			if not player.LC_pilot.player.valid
			or not player.LC_pilot.player.mo
			or not player.LC_pilot.player.mo.valid
				player.charability = skins[player.mo.skin].ability
				player.charability2 = skins[player.mo.skin].ability2
				player.jumpfactor = skins[player.mo.skin].jumpfactor
				player.normalspeed = skins[player.mo.skin].normalspeed
				player.actionspd = skins[player.mo.skin].actionspd
				player.runspeed = skins[player.mo.skin].runspeed
				player.acceleration = skins[player.mo.skin].acceleration
				player.LC_pilotplayer = nil
			end
		end
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true
