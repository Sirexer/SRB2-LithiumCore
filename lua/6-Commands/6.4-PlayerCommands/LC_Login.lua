local LC = LithiumCore

local json = json
local elcipher = elcipher
local base64 = base64

COM_AddCommand("LC_login", function(player, username, password, code)
	if player == server
		if server.isdedicated == true
			CONS_Printf(player, "Join to the game to use this command.")
			return
		end
	end
	
	if player ~= consoleplayer then return end
	
	if player.stuffname ~= nil then
		CONS_Printf(player, "You are already logged in to the server.")
		return
	end
	if player.stuffname == nil then
		if username == nil or password == nil then
			CONS_Printf(player, "ac_login <username> <password>")
			return
		end
		if username ~= LC.functions.getname(username) then
			CONS_Printf(player, "Do not use symbols such as / \ | < > * : ? ^ . \"")
			return
		end
		if username ~= string.gsub(username, " ", "") then
			CONS_Printf(player, "Don't use spaces in username!")
			return
		end
		if password ~= string.gsub(password, " ", "") then
			CONS_Printf(player, "Don't use spaces in password!")
			return
		end
		if string.len(username) > 21 then
			CONS_Printf(player, "Maximum of 21 characters in username!")
			return
		end
		if string.len(password) > 32 then
			CONS_Printf(player, "Maximum of 32 characters in password!")
			return
		end
		if code then
			if code:len() ~= 6 then
				CONS_Printf(player, "Maximum of 6 characters in code!")
				return
			end
		end

		local t = {
			"login",
			username,
			password,
			code
		}
		
		local str = json.encode(t)
		
		local blob = str
		blob = elcipher(blob, LC.masterKeys[#player])
		
		local b64 = base64.encode(blob)
		
		COM_BufInsertText(player, "@LC_decryptData_to_server "..b64)
	end
end, COM_LOCAL)

--[[
COM_AddCommand("LC_login", function(player, username, password, code)
	if player == server
		if server.isdedicated == true
			CONS_Printf(player, "Join to the game to use this command.")
			return
		end
	end
	if player.stuffname != nil
		CONS_Printf(player, "You are already logged in to the server.")
		return
	end
	if player.stuffname == nil
		if username == nil or password == nil
			CONS_Printf(player, "ac_login <username> <password>")
			return
		end
		if username != LC.functions.getname(username)
			CONS_Printf(player, "Do not use symbols such as / \ | < > * : ? ^ . \"")
			return
		end
		if username != string.gsub(username, " ", "")
			CONS_Printf(player, "Don't use spaces in username!")
			return
		end
		if password != string.gsub(password, " ", "")
			CONS_Printf(player, "Don't use spaces in password!")
			return
		end
		if string.len(username) > 21
			CONS_Printf(player, "Maximum of 21 characters in username!")
			return
		end
		if string.len(password) > 32
			CONS_Printf(player, "Maximum of 32 characters in password!")
			return
		end
		if code
			if code:len() ~= 6
				CONS_Printf(player, "Maximum of 6 characters in code!")
				return
			end
		end
		player.username = username
		LC.functions.SaveLoadNameStuff(#player, password, "load", code)
		//COM_BufInsertText(server, "saveloadnamestuff "..)
	end
end)
]]

return true
