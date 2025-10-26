local LC = LithiumCore

local json 		=	json
local sha1_lib 	=	sha1
local sha1		=	sha1_lib.sha1
local hmac_sha1 =	sha1_lib.hmac_sha1
local totp 		=	totp
local base64 	=	base64
local elcipher 	=	elcipher
local RNG = RNG

function LC.functions.decryptData(sender, receiver, data)
	if not sender or not receiver or not data then return end
	
	if type(data) ~= "table" then return end
	
	if not data.type then return true end
	
	local str = json.encode(data)
		
	local blob = str
	blob = elcipher(blob, LC.masterKeys[#player])
		
	local b64 = base64.encode(blob)
		
	COM_BufInsertText(sender, "@LC_decryptData_to_client "..#receiver.." "..b64)
	
end

return true -- End of File