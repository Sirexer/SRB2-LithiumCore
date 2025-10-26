local LC = LithiumCore

local base64 = base64

LC.masterKeys = {}

for i = 0, 32 do
	LC.masterKeys[i] = "0"
end

return true -- End of File