local LC = LithiumCore

local RNG = RNG

-- Used for auto-registration of accounts
LC.functions.GetRandomNumber = function()
	local pass_part01 = 1234
	local pass_part02 = 5678
	local pass_full = "12345678"
	pass_part01 = RNG.RandomRange(1000, 9999)
	pass_part02 = RNG.RandomRange(1000, 9999)
	pass_full = (tostring(pass_part01..pass_part02))
	if pass_full
		return pass_full
	end
end

return true
