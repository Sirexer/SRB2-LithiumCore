local LC = LithiumCore

local json = json
local elcipher = elcipher
local base64 = base64

COM_AddCommand("LC_changepass", function(player, password)
	if player == server then
		if server.isdedicated == true then
			CONS_Printf(player, "Join to the game to use this command.")
			return
		end
	end
	
	if player ~= consoleplayer then return end
	
	if player.stuffname == nil then
		CONS_Printf(player, "To change your password, you must first log in to your account.")
		return
	end
	if not password then
		CONS_Printf(player, "LC_changepass <new_password>")
		return
	end
	if password ~= string.gsub(password, " ", "") then
		CONS_Printf(player, "Don't use spaces in passwords!")
		return
	end
	if password ~= LC.functions.getname(password) then
		CONS_Printf(player, "Do not use symbols such as / \ | < > * : ? ^ . \"")
		return
	end
	if player.delaychange ~= true then
		player.delaychange = true
		
		LC.functions.Autologin(player, "save", player.stuffname, password)
		//CONS_Printf(player, "Password changed successfully!")
		//LC.functions.SaveLoadNameStuff(#player, password, "save")
		local t = {
			"changepass",
			password
		}
		
		local str = json.encode(t)
		
		local blob = str
		blob = elcipher(blob, LC.masterKeys[#player])
		
		local b64 = base64.encode(blob)
		COM_BufInsertText(player, "@LC_decryptData_to_server "..b64)
	else
		CONS_Printf(player, "Don't change your password so often. Wait a few minutes.")
	end
end, COM_LOCAL)

--[[
COM_AddCommand("LC_changepass", function(player, password)
	if player == server
		if server.isdedicated == true
			CONS_Printf(player, "Join to the game to use this command.")
			return
		end
	end
	if player.stuffname == nil
		CONS_Printf(player, "To change your password, you must first log in to your account.")
		return
	end
	if not password
		CONS_Printf(player, "LC_changepass <new_password>")
		return
	end
	if password != string.gsub(password, " ", "")
		CONS_Printf(player, "Don't use spaces in passwords!")
		return
	end
	if password != LC.functions.getname(password)
		CONS_Printf(player, "Do not use symbols such as / \ | < > * : ? ^ . \"")
		return
	end
	if player.delaychange != true
		player.delaychange = true
		//COM_BufInsertText(player2, "io_loginpass write "..password)
		LC.functions.Autologin(player, "save", player.stuffname, password)
		CONS_Printf(player, "Password changed successfully!")
		LC.functions.SaveLoadNameStuff(#player, password, "save")
		//COM_BufInsertText(server, "saveloadnamestuff "..#player.." "..password.." save")
	else
		CONS_Printf(player, "Don't change your password so often. Wait a few minutes.")
	end
end)
]]

return true
