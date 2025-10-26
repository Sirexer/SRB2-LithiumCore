local LC = LithiumCore

COM_AddCommand("changepassuser", function(player, user, pass, callplayer)
	if server != player
		//CONS_Printf(player, "This command is used only for the server")
		return
	end
	if not user and not pass then return end
	if server == player
		if user and pass
			local check_loginpassword = io.openlocal(LC.accounts.passwords.."/"..user..".dat", "r")
			if check_loginpassword
				check_loginpassword:close()
				local canchange = true
				local dir = LC.accounts.accountsfolder.."/"..user
				if callplayer != 0 and callplayer
					local ps_g
					local file_playerstate = io.openlocal(dir.."/lcdata.sav2", "r")
					if file_playerstate
						file_playerstate:read("*l") -- Skip the line
						ps_g = file_playerstate:read("*l") or $
					end
					if LC.groups[ps_g] 
						local player2 = LC.functions.FindPlayer(callplayer)
						if LC.groups[player2.group].priority <= LC.groups[ps_g].priority
							COM_BufInsertText(server, "LC_print w \"This account has priority over yours\" "..callplayer)
							COM_BufInsertText(player, "lcln_print "..callplayer.." ".."error ".."\"This account has priority over yours.\"")
							return
						end
					end
				end
				if canchange == true
					local changepass = io.openlocal(LC.accounts.passwords.."/"..user..".dat", "w")
					local e_pass = LC.functions.Encrypt(pass)
					changepass:write(e_pass)
					changepass:close()
					if callplayer and callplayer != 0
						local node = tostring(callplayer)
						if string.len(node) == 1 then node = "0"..node end
						COM_BufInsertText(server, "LC_print n \"Password for "..user.." has been changed\" "..callplayer)
						COM_BufInsertText(player, "lcln_print "..callplayer.." ".."success ".."\"Password has been changed.\"")
					end
					CONS_Printf(server, "Password for "..user.." has been changed")
					for player in players.iterate do
						if player.stuffname == user
							COM_BufInsertText(server, "kick "..#player.." \"\x85\Password has been changed\x80\"")
						end
					end
				end
			else
				if callplayer and callplayer != 0
					local node = tostring(callplayer)
					if string.len(node) == 1 then node = "0"..node end
					COM_BufInsertText(server, "LC_print e \"This account does not exist\" "..callplayer)
					COM_BufInsertText(player, "lcln_print "..callplayer.." ".."error ".."\"This account does not exist.\"")
				else
					CONS_Printf(server, "This account does not exist")
					if server.LC_menu
						server.LC_menu.lognotice = "\x82"..LC.functions.getStringLanguage("LC_ERR_DONTEXIST")
						S_StartSound(nil, sfx_s3kb2, player)
					end
				end
			end
			pass = nil
		end
	end
end, COM_LOCAL)

return true
