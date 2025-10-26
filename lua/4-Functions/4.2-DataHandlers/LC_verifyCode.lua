local LC = LithiumCore

local json		=	json
local sha1_lib 	=	sha1
local sha1		=	sha1_lib.sha1
local hmac_sha1 =	sha1_lib.hmac_sha1

function LC.functions.verifyCode(username, secret, code)
	if isserver
		if not code then return false end
	
		if not secret then
			local file_pass = io.openlocal(LC.accounts.passwords.."/"..username..".dat", "r")
			file_pass:read("*l") -- skip password
			secret = file_pass:read("*l")
		end
		
		local verify = totp.verify_totp(secret, code, os.time(), 30, 2, hmac_sha1)
		if not verify then
			local file_backup = io.openlocal(LC.accounts.passwords.."/backupcodes/"..username..".dat", "r")
			if file_backup then
				local data_backup = file_backup:read("*a")
				data_backup = json.decode(data_backup)
				file_backup:close()
				
				for _, v in ipairs(data_backup) do
					if v:upper() == code:upper() then
						table.remove(data_backup, _)
						verify = true
						
						local file_backup = io.openlocal(LC.accounts.passwords.."/backupcodes/"..username..".dat", "w")
						local str_bc = json.encode(data_backup)
						file_backup:write(str_bc)
						file_backup:close()
						
						break
					end
				end
			end
		end
		return verify
	end
end

return true -- End of File