local LC = LithiumCore

local hooktable = {
	name = "LC.Emotes",
	type = "KeyDown",
	toggle = true,
	priority = 500,
	TimeMicros = 0,
	func = function(key)
		if not consoleplayer then return end
		if LC.localdata.selectemoji == true
			for i = 1, 9 do
				local str = tostring(i)
				if key.name == str
					if consoleplayer.LC_emotes[i]
						local index = consoleplayer.LC_emotes[i]
						if LC.serverdata.emotes[index]
							COM_BufInsertText(consoleplayer, "LC_emotes play "..index)
							LC.localdata.selectemoji = false
							break
						end
					end
				end
			end
			if key.num >= 49 and key.num <= 57
				return true
			end
		end
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true
