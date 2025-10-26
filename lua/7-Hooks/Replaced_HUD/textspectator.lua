local LC = LithiumCore

local function textspectator(v, player, camera)
	local player = consoleplayer or player
	if not player then return end
	if hud.enabled("textspectator") then hud.disable("textspectator") end
	local x, y = 16, 56
	if (G_GametypeHasTeams() and player.ctfteam == 0) or player.spectator == true
		v.drawString(x, y, "\x86".."SPECTATOR MODE:", V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS, "thin")
		v.drawString(x, y+8, "\x82".."VIEWPOINT:\x80 SWITCH VIEW", V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS, "thin")
		v.drawString(x, y+16, "\x82".."JUMP:\x80 RISE", V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS, "thin")
		v.drawString(x, y+24, "\x82".."SPIN:\x80 LOWER", V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS, "thin")
		v.drawString(x, y+32, "\x82".."FIRE:\x80 ENTER GAME", V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS, "thin")
	end
	if (player.pflags & PF_FINISHED) and not player.afk
	or player.afk and player.afk.finished == true
		local remaining = LC.serverdata.countplayers - (LC.serverdata.completedlevel+LC.serverdata.afkplayers_nc)
		local text_p = "player"
		if remaining > 1 then text_p = "players" end
		
		if remaining
			v.drawString(x, y, "\x82".."VIEWPOINT:\x80 SWITCH VIEW", V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS, "thin")
			v.drawString(x, y+8, remaining.." "..text_p.." REMAINING", V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS, "thin")
		end
	end
end

hud.add(textspectator, "game")

return true
