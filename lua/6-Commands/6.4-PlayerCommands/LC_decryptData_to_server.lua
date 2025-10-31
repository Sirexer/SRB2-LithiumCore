local LC = LithiumCore

local json 		=	json
local sha1_lib 	=	sha1
local sha1		=	sha1_lib.sha1
local hmac_sha1 =	sha1_lib.hmac_sha1
local totp 		=	totp
local base64 	=	base64
local elcipher 	=	elcipher
local RNG = RNG

local DontSpamBC = {}


local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"

local func_data = {
	["register"] = function(t)
		local node = t[0]
		local username = t[2]
		local password = t[3]
		LC.functions.SaveLoadNameStuff(node, username, password, "save")
	end,
	
	["login"] = function(t)
		local node = t[0]
		local username = t[2]
		local password = t[3]
		local code = t[4]
		LC.functions.SaveLoadNameStuff(node, username, password, "load", code)
	end,
	
	["changepass"] = function(t)
		local node = t[0]
		local username = players[node].stuffname
		local password = t[2]
		LC.functions.SaveLoadNameStuff(node, username, password, "save")
	end,
	
	["totp"] = function(t)
		local node = t[0]
		local action = t[2]
		local secret = t[3]
		local c_otp =  t[4]
		-- local username = t.user
		-- local password = t.pass
		local player = players[node]
		
		
		if action:lower() == "set" then
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
			
			local verify = totp.verify_totp(secret, c_otp, os.time(), 30, 2, hmac_sha1)
			if c_otp == nil
				CONS_Printf(player, "TOTP code is required.")
				return 
			elseif not verify
				CONS_Printf(player, "Incorrect TOTP code.")
				return
			end
			
			-- Generating backup_codes
			local seed = RNG.seedFromString(secret..c_otp)
			RNG.RandomSeed(seed)
			local codes = totp.gen_backup_codes(8, 8)
			RNG.RandomSeed()
			
			if isserver
				-- Password and Secret
				local file = io.openlocal(LC.accounts.passwords.."/"..player.stuffname..".dat", "r")
				local pass = file:read("*l")
				file:close()
				
				local file = io.openlocal(LC.accounts.passwords.."/"..player.stuffname..".dat", "w")
				file:write(pass.."\n"..secret)
				file:close()
				
				-- Backup codes
				local file = io.openlocal(LC.accounts.passwords.."/backupcodes/"..player.stuffname..".dat", "w")
				file:write(json.encode(codes))
				file:close()
				if server ~= consoleplayer then
					CONS_Printf(server, player.stuffname.." has enabled 2FA authentication.")
				end
			end
			CONS_Printf(player, "Two-factor authentication enabled.")
			if consoleplayer == player then
				LC.localdata.twofa_enabled = true
				LC.localdata.twofa_bc = codes
				print("===BACKUP_CODES===")
				for i = 1, #codes, 2 do
					print(codes[i].."  "..codes[i+1])
				end
			end
		elseif action:lower() == "remove" then
			if not secret then
				if consoleplayer == player then
					if LC.menu.player_state then
						LC.menu.player_state.lognotice = "\x82"..LC.functions.getStringLanguage("LC_ERR_NOCODE")
					else
						CONS_Printf(player, "\x82".."Need totp code or buckup code!")
					end
				end
				return
			end
			
			
			if isserver
				local verify = LC.functions.verifyCode(player.stuffname, nil, secret)
				
				local t
				if verify == false then
					t = {
						"totp",
						"remove",
						false,
						"LC_ERR_WRONGCODE"
					}
				elseif verify == true then
					t = {
						"totp",
						"remove",
						true
					}
				end
				
				local str = json.encode(t)
			
				local blob = str
				blob = elcipher(blob, LC.masterKeys[#player])
				
				local b64 = base64.encode(blob)
				
				COM_BufInsertText(server, "@LC_decryptData_to_client "..#player.." "..b64)
			end
		elseif action:lower() == "backup_codes" then
			if not secret then
				if consoleplayer == player then
					if LC.menu.player_state then
						LC.menu.player_state.lognotice = "\x82"..LC.functions.getStringLanguage("LC_ERR_NOCODE")
					else
						CONS_Printf(player, "\x82".."Need totp code or buckup code!")
					end
				end
				return
			end
			
			
			if isserver
				if DontSpamBC[player] and DontSpamBC[player] > os.time() then
					local t = {
						"totp",
						"backup_codes",
						false,
						"LC_ERR_BCRECENT"
					}
					
					local str = json.encode(t)
				
					local blob = str
					blob = elcipher(blob, LC.masterKeys[#player])
					
					local b64 = base64.encode(blob)
					
					COM_BufInsertText(server, "@LC_decryptData_to_client "..#player.." "..b64)
					return
				end
			
				local verify = LC.functions.verifyCode(player.stuffname, nil, secret)
				
				local t
				if verify == false then
					t = {
						"totp",
						"backup_codes",
						false,
						"LC_ERR_WRONGCODE"
					}
				elseif verify == true then
					t = {
						"totp",
						"backup_codes",
						true,
						LC.functions.GetRandomPassword("ALL", 16)
					}
					DontSpamBC[player] = os.time() + 120
				end
				
				local str = json.encode(t)
			
				local blob = str
				blob = elcipher(blob, LC.masterKeys[#player])
				
				local b64 = base64.encode(blob)
				
				COM_BufInsertText(server, "@LC_decryptData_to_client "..#player.." "..b64)
			end
		elseif action:lower() == "send" then
			if player.stuffname ~= nil then return end
			LC.functions.SaveLoadNameStuff(node, nil, nil, "load", secret)
		end
		
	end
}

COM_AddCommand("@LC_decryptData_to_server", function(player, b64)
	local server_client = false
	
	//if not isserver then return end
	if isserver then server_client = true end
	if player == consoleplayer then server_client = true end
	if server_client == false then return end
	if not b64 then return end
	-- Base64 to encrypt binary
	local blob = base64.decode(b64)
	-- Encrypt binary to decrypt string
	local plain = blob
	plain = elcipher(blob, LC.masterKeys[#player])
	-- String to table
	local data = nil
	xpcall(
		function()
			data = json.decode(plain)
		end,
		function()
			-- Error gandon with name Sonic1983 send govno!
		end
	)
	
	-- Check datatable
	if data == nil or type(data) ~= "table" then return end
	
	-- Check datatype
	if data[1] == nil then return end
	
	local d_type = data[1]
	if not func_data[d_type] then return end
	
	data[0] = #player
	func_data[d_type](data) -- Call function
	
	-- Update key
	/*
	local get_key = LC.functions.GetRandomPassword("ALL", 16)
	get_key = sha1(get_key)
	LC.masterKeys[#player] = get_key
	*/
end)


return true -- End of File