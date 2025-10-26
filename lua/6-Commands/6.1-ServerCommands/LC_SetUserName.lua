local LC = LithiumCore

local base64 = base64
local tea = tea

COM_AddCommand("setusername", function(player, pname, username, usererror, password, twofa)
	if player != server
		if server.isdedicated != true
			//CONS_Printf(player, "Remote admin can't use this command.")
			return
		end
	end
	if not pname
		return
	end
	
	if password
		password = base64.decode(password)
		password = elcipher(password, LC.masterKeys[tonumber(pname)])
	end
	
	local player2 = LC.functions.FindPlayer(pname)
	if player2 then
		if usererror == "0"
			player2.stuffname = string.lower(username)
			if consoleplayer == player2
				LC.localdata.twofa_enabled = false
				if twofa == "1" then LC.localdata.twofa_enabled = true end
			end
			player2.hud_countload = 5*TICRATE
			player2.loadfromserver = true
			LC.functions.Autologin(player2, "save", player2.stuffname, password)
			//CONS_Printf(player2, "You are logged in as "..username..".")
			chatprintf(player2, "[\x88LC\x80]<\x82~\x80"..LC.consvars["LC_dedicatedname"].string.."\x80>\x82 ".."Welcome back,\x80 "..username.."!\x82 Your stuff is returned.")
			CONS_Printf(server, player2.name.." logged in as "..username..".")
			if LC.menu.player_state
			and player2 == consoleplayer
				LC.menu.player_state.lognotice = "\x83"..LC.functions.getStringLanguage("LC_LOGGED"):format(username)
				S_StartSound(nil, sfx_strpst, player2)
				if LC.menu.player_state.category == "account" and (LC.menu.player_state.subcategory == "login" or LC.menu.player_state.subcategory == "register")
					LC.menu.player_state.subcategory = nil
					LC.menu.player_state.nav = 0
					LC.menu.player_state.lastnav = #LC.menu.subcat.account-1
				end
			end
		elseif usererror == "newuser"
			player2.newuser = true
			player2.stuffname = string.lower(username)
			
			LC.functions.Autologin(player2, "save", player2.stuffname, password)
			//CONS_Printf(player2, "You are logged in as "..username..".")
			chatprintf(player2, "\x88".."LithCore:\x80 Welcome "..username.."!")
			CONS_Printf(server, player2.name.." registed as "..username..".")
			if LC.menu.player_state
			and player2 == consoleplayer
				LC.menu.player_state.lognotice = "\x83"..LC.functions.getStringLanguage("LC_LOGGED"):format(username)
				S_StartSound(nil, sfx_strpst, player2)
				if LC.menu.player_state.category == "account" and (LC.menu.player_state.subcategory == "login" or LC.menu.player_state.subcategory == "register")
					LC.menu.player_state.subcategory = nil
					LC.menu.player_state.nav = 0
					LC.menu.player_state.lastnav = #LC.menu.subcat.account-1
				end
			end
		elseif usererror == "1"
			CONS_Printf(player2, "Account with this username is already taken.")
			if LC.menu.player_state
			and player2 == consoleplayer
				LC.menu.player_state.lognotice = "\x82"..LC.functions.getStringLanguage("LC_ERR_USEREXIST")
				S_StartSound(nil, sfx_s3kb2, player2)
			end
		elseif usererror == "2"
			CONS_Printf(player2, "This account does not exist!")
			if LC.menu.player_state
				LC.menu.player_state.lognotice = "\x82"..LC.functions.getStringLanguage("LC_ERR_DONTEXIST")
				S_StartSound(nil, sfx_s3kb2, player2)
			end
		elseif usererror == "3"
			CONS_Printf(player2, "Invalid login or password.")
			if LC.menu.player_state
			and player2 == consoleplayer
				LC.menu.player_state.lognotice = "\x82"..LC.functions.getStringLanguage("LC_ERR_USERPASS")
				S_StartSound(nil, sfx_s3kb2, player2)
			end
		elseif usererror == "4"
			CONS_Printf(player2, "This username is currently being used by another player.")
			if LC.menu.player_state
			and player2 == consoleplayer
				LC.menu.player_state.lognotice = "\x82"..LC.functions.getStringLanguage("LC_ERR_TAKENUN")
				S_StartSound(nil, sfx_s3kb2, player2)
			end
		elseif usererror == "5"
			CONS_Printf(player2, "Correct TOTP code required!")
			if player2 == consoleplayer
				LC.localdata.waiting_totd = {code = "", err = ""}
				if LC.menu.player_state
					LC.menu.player_state.lognotice = "\x82"..LC.functions.getStringLanguage("LC_ERR_NEEDTOTP")
					S_StartSound(nil, sfx_s3kb2, player2)
				end
			end
		elseif usererror == "6"
			CONS_Printf(player2, "Incorrect TOTP code!")
			if player2 == consoleplayer
				LC.localdata.waiting_totd = {code = "", err = "\x82".."Incorrect TOTP code!"}
				if LC.menu.player_state
					LC.menu.player_state.lognotice = "\x82"..LC.functions.getStringLanguage("LC_ERR_WRONGTOTP")
					S_StartSound(nil, sfx_s3kb2, player2)
				end
			end
		end
	end
end, 1)

return true
