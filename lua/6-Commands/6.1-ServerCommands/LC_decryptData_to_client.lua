local LC = LithiumCore

local json 		=	json
local sha1_lib 	=	sha1
local sha1		=	sha1_lib.sha1
local hmac_sha1 =	sha1_lib.hmac_sha1
local totp 		=	totp
local base64 	=	base64
local elcipher 	=	elcipher
local RNG = RNG

local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"

local func_data = {
	["totp"] = function(data)
		local node = data[0]
		local action = data[2]
		local arg1 = data[3]
		local arg2 = data[4]
		local client = players[node]
		
		if action == "backup_codes" then
			if arg1 == true then
				-- Generating backup_codes
				local seed = RNG.seedFromString(arg2)
				RNG.RandomSeed(seed)
				local codes = totp.gen_backup_codes(8, 8)
				RNG.RandomSeed()
				
				if isserver
					-- Backup codes
					local file = io.openlocal(LC.accounts.passwords.."/backupcodes/"..client.stuffname..".dat", "w")
					file:write(json.encode(codes))
					file:close()
				end
				if consoleplayer == client then
					LC.localdata.twofa_enabled = true
					LC.localdata.twofa_bc = codes
					print("===BACKUP_CODES===")
					for i = 1, #codes, 2 do
						print(codes[i].."  "..codes[i+1])
					end
					if LC.menu.player_state then
						LC.menu.player_state.lognotice = "\x83"..LC.functions.getStringLanguage("LC_SUCCESS")
					end
				end
			elseif arg1 == false then
				if consoleplayer == client then
					if LC.menu.player_state then
						LC.menu.player_state.lognotice = "\x82"..LC.functions.getStringLanguage(arg2)
					else
						CONS_Printf(client, "\x82"..LC.functions.getStringLanguage(arg2, "en"))
					end
				end
			end
		elseif action == "remove" then
			if arg1 == true then
				if isserver
					local file = io.openlocal(LC.accounts.passwords.."/"..client.stuffname..".dat", "r")
					local pass = file:read("*l")
					file:close()
					
					local file = io.openlocal(LC.accounts.passwords.."/"..client.stuffname..".dat", "w")
					file:write(pass)
					file:close()
					if server ~= consoleplayer then
						CONS_Printf(server, client.stuffname.." has disabled 2FA authentication.")
					end
				end
				if consoleplayer == client then
					LC.localdata.twofa_enabled = false 
					LC.menu.player_state.lognotice = "\x83"..LC.functions.getStringLanguage("LC_MENU_2FA_DEACTIVATED")
				end
				CONS_Printf(client, "Two-factor authentication disabled.")
			elseif arg1 == false then
				if consoleplayer == client then
					if LC.menu.player_state then
						LC.menu.player_state.lognotice = "\x82"..LC.functions.getStringLanguage(arg2)
					else
						CONS_Printf(client, "\x82"..LC.functions.getStringLanguage(arg2, "en"))
					end
				end
			end
		end
	end
}

COM_AddCommand("@LC_decryptData_to_client", function(sender, receiver, b64)
	if sender ~= server then return end
	receiver = players[tonumber(receiver)]
	
	if not sender or not sender.valid then return end
	if not receiver or not receiver.valid then return end
	
	local sender_receiver = false
	
	if isserver then sender_receiver = true end
	if receiver == consoleplayer then sender_receiver = true end
	if sender_receiver == false then return end
	
	if not b64 then return end
	-- Base64 to encrypt binary
	local blob = base64.decode(b64)
	-- Encrypt binary to decrypt string
	local plain = blob
	plain = elcipher(blob, LC.masterKeys[#receiver])
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
	
	data[0] = #receiver
	func_data[d_type](data) -- Call function
	
	-- Update key
	/*
	local get_key = LC.functions.GetRandomPassword("ALL", 16)
	get_key = sha1(get_key)
	LC.masterKeys[#player] = get_key
	*/
end)

return true --End of File
