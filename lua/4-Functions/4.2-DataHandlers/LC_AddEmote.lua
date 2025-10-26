local LC = LithiumCore

LC.functions.AddEmote = function(tabledata)
	if type(tabledata) != "table"
		print("\x82".."WARNING".."\x80"..": Expacted table got "..type(tabledata))
	else
		local IsError = false
		if type(tabledata.name) != "string"
			print("\x82".."WARNING".."\x80"..": value \"tabledata.name\" is "..type(tabledata.name).." should be \"string\"")
			IsError = true
		end 
		if type(tabledata.state) != "number"
			print("\x82".."WARNING".."\x80"..": value \"tabledata.state\" is "..type(tabledata.state).." should be \"number\"")
			IsError = true
		else
			xpcall(
				function()
					if not states[tabledata.state]
						print("\x82".."WARNING".."\x80"..": State for Emoji \""..tabledata.name.."\" doesn't exist")
						IsError = true
					end
				end,
				function()
					print("\x82".."WARNING".."\x80"..": State for Emoji \""..tabledata.name.."\" doesn't exist")
					IsError = true
				end
			)
		end
		if type(tabledata.scale) != "number"
			print("\x82".."WARNING".."\x80"..": value \"tabledata.scale\" is "..type(tabledata.scake).." should be \"number\"")
			IsError = true
		end
		if tabledata.sfx == nil or type(tabledata.sfx) == "table" and tabledata.sfx[1] == nil
			-- pass
		elseif type(tabledata.sfx) != "table" and type(tabledata.sfx) != "number"
			print("\x82".."WARNING".."\x80"..": value \"tabledata.sfx\" is "..type(tabledata.sfx).." should be \"table\" or \"number\"")
			IsError = true
		elseif type(tabledata.sfx) == "table"
			for i in ipairs(tabledata.sfx) do
				if type(tabledata.sfx[i]) != "number"
					print("\x82".."WARNING".."\x80"..": value \"tabledata.sfx["..i.."]\" is "..type(tabledata.sfx[i]).." should be \"number\"")
				else
					xpcall(
						function()
							if not sfxinfo[tabledata.sfx[i]]
								print("\x82".."WARNING".."\x80"..": SFX["..i.."] for Emoji \""..tabledata.name.."\" doesn't exist")
								IsError = true
							end
						end,
						function()
							print("\x82".."WARNING".."\x80"..": SFX["..i.."] for Emoji \""..tabledata.name.."\" doesn't exist")
							IsError = true
						end
					)
				end
			end
		elseif type(tabledata.sfx) == "number"
			xpcall(
				function()
					if not sfxinfo[tabledata.sfx]
						print("\x82".."WARNING".."\x80"..": SFX for Emoji \""..tabledata.name.."\" doesn't exist")
						IsError = true
					end
				end,
				function()
					print("\x82".."WARNING".."\x80"..": SFX for Emoji \""..tabledata.name.."\" doesn't exist")
					IsError = true
				end
			)
		end
		if type(tabledata.colored) != "boolean"
			print("\x82".."WARNING".."\x80"..": value \"tabledata.colored\" is "..type(tabledata.colored).." should be \"boolean\"")
			IsError = true
		end
		if type(tabledata.colorized) != "boolean"
			print("\x82".."WARNING".."\x80"..": value \"tabledata.colorized\" is "..type(tabledata.colorized).." should be \"boolean\"")
			IsError = true
		end
		if IsError == false
			local t = {
				name = tabledata.name,
				state = tabledata.state,
				scale = tabledata.scale,
				sfx = tabledata.sfx,
				colored = tabledata.colored,
				colorized = tabledata.colorized
			}
			if type(t.sfx) == "number" then t.sfx = {t.sfx} end
			table.insert(LC.serverdata.emotes, t)
			print("\x83".."NOTICE".."\x80"..": Added Emote "..tabledata.name)
		end
	end
end

return true
