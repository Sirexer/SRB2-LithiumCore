local LC = LithiumCore

local json = json
local elcipher = elcipher
local base64 = base64

COM_AddCommand("LC_register", function(player, username, password)
	if player == server then
		if server.isdedicated == true then
			CONS_Printf(player, "Join to the game to use this command.")
			return
		end
	end
	
	if player ~= consoleplayer then return end
	
	if player.stuffname == nil then
		if username == nil or password == nil then
			CONS_Printf(player, "ac_register <username> <password>")
			if not player.getwarn then
				CONS_Printf(player, "\x82Warning:\x80 Do not use passwords that are compatible with your account passwords (steam, twitter, facebook adn etc). The server host has access to your password")
				player.getwarn = true
			end
			return
		end
		if username ~= LC.functions.getname(username) then
			CONS_Printf(player, "Do not use symbols such as / \ | < > * : ? ^ . \"")
			if not player.getwarn then
				CONS_Printf(player, "\x82Warning:\x80 Do not use passwords that are compatible with your account passwords (steam, twitter, facebook adn etc). The server host has access to your password")
				player.getwarn = true
			end
			return
		end
		if username ~= string.gsub(username, " ", "") then
			CONS_Printf(player, "Don't use spaces in username!")
			if not player.getwarn then
				CONS_Printf(player, "\x82Warning:\x80 Do not use passwords that are compatible with your account passwords (steam, twitter, facebook adn etc). The server host has access to your password")
				player.getwarn = true
			end
			return
		end
		if password ~= string.gsub(password, " ", "") then
			CONS_Printf(player, "Don't use spaces in passwords!")
			if not player.getwarn then
				CONS_Printf(player, "\x82Warning:\x80 Do not use passwords that are compatible with your account passwords (steam, twitter, facebook adn etc). The server host has access to your password")
				player.getwarn = true
			end
			return
		end
		if password == "random" then
			password = LC.functions.GetRandomPassword()
		end
		
		//player.username = username
		//LC.functions.SaveLoadNameStuff(#player, password, "save")
		//COM_BufInsertText(server, "saveloadnamestuff "..#player.." "..password.." save")
		local t = {
			"register",
			username,
			password
		}
		
		local str = json.encode(t)
		
		local blob = str
		blob = elcipher(blob, LC.masterKeys[#player])
		
		local b64 = base64.encode(blob)
		COM_BufInsertText(player, "@LC_decryptData_to_server "..b64)
	else
		CONS_Printf(player, "You are already logged in to the server.")
	end
end, COM_LOCAL)

--[[
COM_AddCommand("LC_register", function(player, username, password)
	if player == server
		if server.isdedicated == true
			CONS_Printf(player, "Join to the game to use this command.")
			return
		end
	end
	if player.stuffname == nil
		if username == nil or password == nil
			CONS_Printf(player, "ac_register <username> <password>")
			if not player.getwarn
				CONS_Printf(player, "\x82Warning:\x80 Do not use passwords that are compatible with your account passwords (steam, twitter, facebook adn etc). The server host has access to your password")
				player.getwarn = true
			end
			return
		end
		if username != LC.functions.getname(username)
			CONS_Printf(player, "Do not use symbols such as / \ | < > * : ? ^ . \"")
			if not player.getwarn
				CONS_Printf(player, "\x82Warning:\x80 Do not use passwords that are compatible with your account passwords (steam, twitter, facebook adn etc). The server host has access to your password")
				player.getwarn = true
			end
			return
		end
		if username != string.gsub(username, " ", "")
			CONS_Printf(player, "Don't use spaces in username!")
			if not player.getwarn
				CONS_Printf(player, "\x82Warning:\x80 Do not use passwords that are compatible with your account passwords (steam, twitter, facebook adn etc). The server host has access to your password")
				player.getwarn = true
			end
			return
		end
		if password != string.gsub(password, " ", "")
			CONS_Printf(player, "Don't use spaces in passwords!")
			if not player.getwarn
				CONS_Printf(player, "\x82Warning:\x80 Do not use passwords that are compatible with your account passwords (steam, twitter, facebook adn etc). The server host has access to your password")
				player.getwarn = true
			end
			return
		end
		if password == "random"
			password = LC.functions.GetRandomPassword()
		end
		player.username = username
		LC.functions.SaveLoadNameStuff(#player, password, "save")
		//COM_BufInsertText(server, "saveloadnamestuff "..#player.." "..password.." save")
	else
		CONS_Printf(player, "You are already logged in to the server.")
	end
end)
]]

return true
