local LC = LithiumCore

local hooktable = {
	name = "LC.Emotes",
	type = "PlayerThink",
	toggle = true,
	TimeMicros = 0,
	func = function(player)
		if not player or not player.valid then return end
		
		if not player.LC_emotes
			player.LC_emotes = {}
			for i = 1, 9 do
				local index = false
				if LC.Emotes[i] then index = i end
				table.insert(player.LC_emotes, index)
			end
		end
		
		if not player.mo or not player.mo.valid then return end
		if not player.mo.LC_emote then return end

		local pmo = player.mo
		local LC_emote = pmo.LC_emote
		
		if not LC_emote.mo or not LC_emote.mo.valid
			if LC_emote.countdown != 0 then LC_emote.countdown = $ - 1 end
		end
		
		if LC_emote.mo and LC_emote.mo.valid
			LC_emote.mo.scale = FixedMul(pmo.scale, LC_emote.scale)
			local x, y, z = pmo.x, pmo.y, pmo.z + pmo.height + 24*pmo.scale
			if P_MobjFlip(pmo) == -1
				z = pmo.z - pmo.height
				if not (LC_emote.mo.eflags & MFE_VERTICALFLIP)
					LC_emote.mo.eflags = $|MFE_VERTICALFLIP
				end
			else
				if (LC_emote.mo.eflags & MFE_VERTICALFLIP)
					LC_emote.mo.eflags = $ - MFE_VERTICALFLIP
				end
			end
			P_MoveOrigin(LC_emote.mo, x, y, z)
		end
		
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true -- End Of File
