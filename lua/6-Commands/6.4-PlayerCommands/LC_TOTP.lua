local LC = LithiumCore

local json = json //LC_require "json.lua"
local sha1 = sha1
local totp = totp
local base64 = base64
local elcipher = elcipher

local hmac_sha1 = sha1.hmac_sha1

local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"

COM_AddCommand("LC_totp", function(player, action, secret, c_otp)
	if player != consoleplayer then return end
	
	if action == "send"
		if not secret then return end
		local t = {
			"totp",
			"send",
			secret
		}
		
		local str = json.encode(t)
		
		local blob = str
		blob = elcipher(blob, LC.masterKeys[#player])
		
		local b64 = base64.encode(blob)
		COM_BufInsertText(player, "@LC_decryptData_to_server "..b64)
		return
	end
	
	if player.stuffname == nil
		CONS_Printf(player, "You need to log in to your account.")
		return
	end
	
	if action == "set"
		if LC.localdata.twofa_enabled == false
			local t = {
				"totp",
				"set",
				secret,
				c_otp
			}
			
			local str = json.encode(t)
			
			local blob = str
			blob = elcipher(blob, LC.masterKeys[#player])
			
			local b64 = base64.encode(blob)
			COM_BufInsertText(player, "@LC_decryptData_to_server "..b64)
		elseif LC.localdata.twofa_enabled == true
			CONS_Printf(player, "Two-factor authentication is already existing.")
		end
	elseif action == "backup_codes"
			local t = {
				"totp",
				"backup_codes",
				secret
			}
			
			local str = json.encode(t)
			
			local blob = str
			blob = elcipher(blob, LC.masterKeys[#player])
			
			local b64 = base64.encode(blob)
			COM_BufInsertText(player, "@LC_decryptData_to_server "..b64)
	elseif action == "remove"
		if LC.localdata.twofa_enabled == true
			local t = {
				"totp",
				"remove",
				secret
			}
			
			local str = json.encode(t)
			
			local blob = str
			blob = elcipher(blob, LC.masterKeys[#player])
			
			local b64 = base64.encode(blob)
			COM_BufInsertText(player, "@LC_decryptData_to_server "..b64)
		elseif LC.localdata.twofa_enabled == false
			CONS_Printf(player, "Two-factor authentication is not enabled.")
		end
	else
		CONS_Printf(player,
			"LC_totp set <secret_key> <totp_code> - sets the secret key for generating one-time codes\n"..
			"LC_totp remove - removes secret key\n"..
			"Allowed characters for secret key: A-Z 2-7."
		)
	end

end, COM_LOCAL)

--[[
COM_AddCommand("LC_totp", function(player, action, secret, c_otp)
	if player.stuffname == nil
		CONS_Printf(player, "You need to log in to your account.")
		return
	end
	
	if action == "set"
		if player.twofa_enabled == false
			if not secret
				CONS_Printf(player, "Secret key is required.")
				return
			end
			for i = 1, secret:len() do
				if not alphabet:find( secret:sub(i,i) )
					CONS_Printf(player, "Allowed characters for secret key: A-Z 2-7.")
					return
				end
			end
			if secret:len() < 16
				CONS_Printf(player, "minimum characters for secret key is 8.")
				return
			end
			local s_otp = tostring(totp.generate(secret, os.time(), 30, hmac_sha1))
			if c_otp == nil
				CONS_Printf(player, "TOTP code is required.")
				return 
			elseif s_otp != c_otp
				CONS_Printf(player, "Incorrect TOTP code.")
				return
			end
			if isserver
				local file = io.openlocal(LC.accounts.passwords.."/"..player.stuffname..".dat", "r")
				local pass = file:read("*l")
				file:close()
				
				local file = io.openlocal(LC.accounts.passwords.."/"..player.stuffname..".dat", "w")
				file:write(pass.."\n"..secret)
				file:close()
			end
			player.twofa_enabled = true
			CONS_Printf(player, "Two-factor authentication enabled.")
		elseif player.twofa_enabled == true
			CONS_Printf(player, "Two-factor authentication is already existing.")
		end
	elseif action == "remove"
		if player.twofa_enabled == true
			if isserver
				local file = io.openlocal(LC.accounts.passwords.."/"..player.stuffname..".dat", "r")
				local pass = file:read("*l")
				file:close()
				
				local file = io.openlocal(LC.accounts.passwords.."/"..player.stuffname..".dat", "w")
				file:write(pass)
				file:close()
			end
			player.twofa_enabled = false
			CONS_Printf(player, "Two-factor authentication disabled.")
		elseif player.twofa_enabled == false
			CONS_Printf(player, "Two-factor authentication is not enabled.")
		end
	else
		CONS_Printf(player,
			"LC_totp set <secret_key> <totp_code> - sets the secret key for generating one-time codes\n"..
			"LC_totp remove - removes secret key\n"..
			"Allowed characters for secret key: A-Z 2-7."
		)
	end

end)
]]

return true
