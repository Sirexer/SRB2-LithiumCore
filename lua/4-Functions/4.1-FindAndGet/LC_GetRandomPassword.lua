local LC = LithiumCore
local RNG = RNG

-- Issues a random password to register or change passwords.
	-- arg1 - answers what characters should be in passwords
		-- arg "L" will return the password with letters only
		-- arg "N" will return the password with numbers only
		-- arg "S" will return the password with special symbols only
		--  The letters will be able to be combined
	-- arg2 - length of the password
LC.functions.GetRandomPassword = function(arg1, arg2)
	local length = 8
	local password = ""
	local stype = nil
	local symbol = nil
	local allowsymbols = nil
	if arg2 then length = tonumber(arg2) end
	if length > 32 then length = 32 end
	if arg1 == nil then allowsymbols = "ALL" end
	if arg1 != nil
		if string.upper(arg1) == "L" then allowsymbols = "L"
		elseif string.upper(arg1) == "N" then allowsymbols = "N"
		elseif string.upper(arg1) == "S" then allowsymbols = "S" end
		if string.len(arg1) > 1
			local finds = ""
			if string.find(string.upper(arg1), "L") then finds = finds.."L" end
			if string.find(string.upper(arg1), "N") then finds = finds.."N" end
			if string.find(string.upper(arg1), "S") then finds = finds.."S" end
			if finds == "" then finds = "ALL" end
			allowsymbols = finds
		end
	end
	if tostring(allowsymbols) == "" then allowsymbols = "ALL" end
	if allowsymbols == "ALL" or allowsymbols == "LNS"
		for a=0,(length-1) do
			stype = RNG.RandomRange(0, #LC.symbols)
			symbol = RNG.RandomRange(0, #LC.symbols[stype])
			password = password..LC.symbols[stype][symbol]
		end
	end
	if allowsymbols == "L"
		for a=0,(length-1) do
			symbol = RNG.RandomRange(0, #LC.symbols[0])
			password = password..LC.symbols[0][symbol]
		end
	end
	if allowsymbols == "N"
		for a=0,(length-1) do
			symbol = RNG.RandomRange(0, #LC.symbols[1])
			password = password..LC.symbols[1][symbol]
		end
	end
	if allowsymbols == "S"
		for a=0,(length-1) do
			symbol = RNG.RandomRange(0, #LC.symbols[2])
			password = password..LC.symbols[2][symbol]
		end
	end
	if allowsymbols == "LN"
		for a=0,(length-1) do
			stype = RNG.RandomRange(0, #LC.symbols)
			if stype == 2
				local b = nil
				b = RNG.RandomRange(0, 1)
				if b == 1
					stype = 1
				else
					stype = 0
				end
			end
			symbol = RNG.RandomRange(0, #LC.symbols[stype])
			password = password..LC.symbols[stype][symbol]
		end
	end
	if allowsymbols == "LS"
		for a=0,(length-1) do
			stype = RNG.RandomRange(0, #LC.symbols)
			if stype == 1
				local b = nil
				b = RNG.RandomRange(0, 1)
				if b == 1
					stype = 2
				else
					stype = 0 
				end
			end
			symbol = RNG.RandomRange(0, #LC.symbols[stype])
			password = password..LC.symbols[stype][symbol]
		end
	end
	if allowsymbols == "NS"
		for a=0,(length-1) do
			stype = RNG.RandomRange(0, #LC.symbols)
			if stype == 0
				local b = nil
				b = RNG.RandomRange(0, 1)
				if b == 1
					stype = 1
				else 
					stype = 2
				end
			end
			symbol = RNG.RandomRange(0, #LC.symbols[stype])
			password = password..LC.symbols[stype][symbol]
		end
	end
	if password
		return password
	end
end

return true
