local LC = LithiumCore

local emote_hud = {
	name = "LC.Main",
	type = "HUD",
	typehud = {"game"},
	toggle = true,
	priority = 500,
	TimeMicros = 0,
	func = function(v)
		if not consoleplayer then return end
		if LC.localdata.selectemoji == true
			v.drawFill(160, 64, 160, 80, 31|V_SNAPTORIGHT|V_50TRANS)
			v.drawString(160, 64, "\x82".."Hot key of emotes...", V_SNAPTORIGHT, "left")
			local y = 72
			for i = 1, 9 do
				if (i % 2) == 1
					v.drawFill(160, y, 160, 8, 16|V_SNAPTORIGHT|V_50TRANS)
				end
				local emojiname = "\x85".."Not setted"
				if consoleplayer.LC_emotes[i]
					local index = consoleplayer.LC_emotes[i]
					if LC.serverdata.emotes[index]
						emojiname = LC.serverdata.emotes[index].name
						local width = v.stringWidth(emojiname, 0, "normal")
						local state = LC.serverdata.emotes[index].state
						local sprite = states[state].sprite
						local frame = states[state].frame
						local patch = v.getSpritePatch(sprite, frame)
						local scale = (FU/patch.width) * 8
						local x_e = (160*FU + width*FU) + (patch.leftoffset*scale)
						local y_e = (y*FU) + (patch.topoffset*scale)
						v.drawScaled(x_e, y_e, scale, patch, V_SNAPTORIGHT, nil)
					end
				end
				v.drawString(160, y, emojiname, V_SNAPTORIGHT, "left")
				v.drawString(320, y, i, V_SNAPTORIGHT, "right")
				y = $ + 8
			end
		end
	end
}

table.insert(LC_Loaderdata["hook"], emote_hud)

return true -- End Of File
