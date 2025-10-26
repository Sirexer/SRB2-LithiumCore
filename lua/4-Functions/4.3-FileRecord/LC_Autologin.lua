local LC = LithiumCore

local json = json //LC_require "json.lua"

LC.functions.Autologin = function(player, arg, user, pass)
	if not consoleplayer or player != consoleplayer then return end
	if LC.serverdata.id
	and LC.client_consvars.autologin.value != 0
		local autologin = LC.localdata.savedpass
		if arg == "read"
		and type(autologin[LC.serverdata.id]) == "table" 
			local username = autologin[LC.serverdata.id].username
			local password = autologin[LC.serverdata.id].password
			if autologin[LC.serverdata.id]
				if LC.client_consvars.autologin.value == 1
					COM_BufInsertText(player, "LC_login \""..username.."\" \""..password.."\"")
				elseif LC.client_consvars.autologin.value == 2
				and LC.localdata.loginwindow == false
					LC.localdata.loginwindow = {user = username, pass = password}
				end
			end
		elseif arg == "save"
			if pass
				autologin[LC.serverdata.id] = {username = user, password = pass}
			end
			local str = "{\n"
			local ids = 0
			for k, v in pairs(autologin) do
				if type(autologin[k]) != "table" then continue end
				if not autologin[k].username or not autologin[k].password then continue end
				local id = "\""..k.."\": {"
				local username = "\"username\": \""..autologin[k].username.."\", "
				local password = "\"password\": \""..autologin[k].password.."\"}"
				if ids == 0
					str = str..id..username..password
				else
					str = str..",\n"..id..username..password
				end
				ids = $ + 1
			end
			str = str.."\n}"
			if type(str) == "string"
				local autologin_file = io.openlocal(LC.accounts.client_accountdata, "w")
				autologin_file:write(str)
				autologin_file:close()
			end
		end
	end
end

return true
