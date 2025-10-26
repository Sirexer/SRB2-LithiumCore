local LC = LithiumCore

local json = json //LC_require "json.lua"
local sha1 = sha1
local totp = totp
local elcipher = elcipher

local hmac_sha1 = sha1.hmac_sha1

local totd_waiting = {}

LC.functions.SaveLoadNameStuff = function(node, username, password, sl, c_otp)
	if isserver != true then return end
	
	if sl == "load"
		if node ~= nil
			if totd_waiting[tostring(node)] then
				local t = totd_waiting[tostring(node)]
				if t.endtime >= os.time() and t.player == players[tostring(node)] then
					username = username or t.username
					password = password or t.password
				elseif t.player == players[tostring(node)] then
					COM_BufInsertText(server, "lcln_print "..node.." error \"Time has run out\"")
					totd_waiting[tostring(node)] = nil
				else
					totd_waiting[tostring(node)] = nil
				end
			end
		end
		
		local en_pass = password
		if en_pass
			en_pass = elcipher(en_pass, LC.masterKeys[node])
			en_pass = base64.encode(en_pass)
		end
		
		if not password and node == nil then return end
		
		local playerstuff = nil
		playerstuff = LC.functions.FindPlayer(node)
		-- locals variable.
		local ps_password = "none"
		local ps_secret
		local check_user = LC.functions.IsUsernameLogged(username)
			
		if password // log in account
			local loginpassword = io.openlocal(LC.accounts.passwords.."/"..username..".dat", "r")
			if loginpassword
				ps_password = loginpassword:read("*l") or $
				ps_secret = loginpassword:read("*l") or $
				if ps_secret == "" then ps_secret = nil end
				loginpassword:close()
				local e_pass = LC.functions.Encrypt(password)
				local verify = false
				if ps_secret
					-- verify = totp.verify_totp(ps_secret, c_otp, os.time(), 30, 2, hmac_sha1)
					verify = LC.functions.verifyCode(username, ps_secret, c_otp)
				else
					verify = true
				end
			
				if ps_password == e_pass
				and verify == true
					if check_user == nil
						local twofa = "0"
						if ps_secret then twofa = "1" end
						playerstuff.stuffname = username
						totd_waiting[tostring(node)] = nil
						COM_BufInsertText(server, "setusername "..node.." \""..username.."\" 0 "..en_pass.." "..twofa)
					else
						COM_BufInsertText(server, "setusername "..node.." non 4")
					end
				elseif ps_password != e_pass
					COM_BufInsertText(server, "setusername "..node.." non 3")
				elseif verify == false
					if not totd_waiting[tostring(node)] then
						local t = {
							player = players[tostring(node)],
							endtime = os.time()+60,
							username = username,
							password = password
						}
						totd_waiting[tostring(node)] = t
						COM_BufInsertText(server, "setusername "..node.." non 5")
					elseif totd_waiting[tostring(node)] then
						local t = totd_waiting[tostring(node)]
						t.endtime = os.time()+60
						COM_BufInsertText(server, "setusername "..node.." non 6")
					end
				end
			elseif not loginpassword
				COM_BufInsertText(server, "setusername "..node.." non 2")
			end
		end
	elseif sl == "save"
		if not password and node == nil then return end
		local playerstuff = nil
		playerstuff = LC.functions.FindPlayer(node)
		
		if password and password != "0"
			if playerstuff.stuffname == nil -- Registers account
				local check_loginpassword = io.openlocal(LC.accounts.passwords.."/"..username..".dat", "r")
				if check_loginpassword
					check_loginpassword:close()
					COM_BufInsertText(server, "setusername "..node.." non 1")
				end
				if not check_loginpassword
					local loginpassword = io.openlocal(LC.accounts.passwords.."/"..username..".dat", "w")
					CONS_Printf(server, "Created account for "..username)
					local e_pass = LC.functions.Encrypt(password)
					loginpassword:write(e_pass)
					loginpassword:close()
					
					local en_pass = password
					if en_pass
						en_pass = elcipher(en_pass, LC.masterKeys[node])
						en_pass = base64.encode(en_pass)
					end
					
					COM_BufInsertText(server, "setusername "..node.." \""..username.."\" newuser "..en_pass)
				end
			end
			if playerstuff.stuffname != nil -- Changes password
				local file = io.openlocal(LC.accounts.passwords.."/"..username..".dat", "r")
				local oldpass = file:read("*l")
				local secret_key = file:read("*l")
				file:close()
				
				local e_pass = LC.functions.Encrypt(password)
				local changepass = io.openlocal(LC.accounts.passwords.."/"..username..".dat", "w")
				changepass:write(e_pass)
				if secret_key and secret_key != ""
					changepass:write("\n"..secret_key)
				end
				changepass:close()
				CONS_Printf(server, "Changed password for "..username)
			end
		end
		-- This save stuff of the player.
		if playerstuff.stuffname
			if not LC.accounts.loaded[playerstuff.stuffname] then LC.accounts.loaded[playerstuff.stuffname] = {} end
			if not LC.accounts.loaded[playerstuff.stuffname].saved
				LC.accounts.loaded[playerstuff.stuffname].saved = 1
			else
				LC.accounts.loaded[playerstuff.stuffname].saved = $ + 1
			end
			if isserver == true
				local path = LC.accounts.accountsfolder..playerstuff.stuffname..".sav2"
				local data = json.encode(LC.accounts.loaded[playerstuff.stuffname])
				local file_playerstate = io.openlocal(path, "w")
				file_playerstate:write(data)
				file_playerstate:close()
				local file_check = io.openlocal(path, "r")
				local datacheck = file_check:read("*a")
				if datacheck == "" then print("FILE IS EMPTY!") end
			end
		end
	end
end

return true
