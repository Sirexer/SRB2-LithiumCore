local decode_ramp_to_string = function(self)
	if type(self) != "table"
		print("\x82".."WARNING\x80"..": ramp should be table.")
		return false
	end
	
	return
end

local CheckName = function(self, silent)
	if self
		if self == ""
			if silent == nil
				print("\x82".."WARNING\x80"..": Name should not be an empty string.")
			end
			return false, "empty text"
		end
		if self:sub(1,1) == " "
			if silent == nil
				print("\x82".."WARNING\x80"..": There should not be a space at start of name.")
			end
			return false, "space at start"
		end
		
		local letter = false
		for i = 0, #LC.symbols[0]
			if self:sub(1,1) == LC.symbols[0][i]
				letter = true
				break
			end
		end
		if letter == false
			if silent == nil
				print("\x82".."WARNING\x80"..": Special characters and numbers must not start with them.")
			end
			return false, "incorrect"
		end
		
		if self:len() > 32
			if silent == nil
				print("\x82".."WARNING\x80"..": There should be no more than 32 characters in name.")
			end
			return false, "out of character"
		end
		return self
	end
end

local CheckRamp = function(self)
	if self
		local ramp
		if type(self) == "string"
			self = self:gsub(" ", ",")
			xpcall(
				function()
					ramp = json.decode("["..self.."]")
				end,
				function()
					print("\x82".."WARNING\x80"..": Invalid argument in Ramp, make sure there are no parentheses and extra commas.")
					return false, "syntax error"
				end
			)
		elseif type(self) == "table"
			ramp = self
		end
		if type(ramp) == "table"
			for i = 1, 16 do
				if ramp[i]
					local int = tonumber(ramp[i])
					if int
						if int > 255 then ramp[i] = 255 end
						if int < 0 then ramp[i] = 0 end
					else
						ramp[i] = 0
					end
				end
			end
			return ramp
		end
	end
	return {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}, "not found"
end

local CheckInvcolor = function(self)
	if self
		local int = tonumber(self)
		local invcolor
		if int
			if int > 0 and int < #skincolors-1
				return int
			else
				return SKINCOLOR_WHITE
			end
		end
		for i = 1, #skincolors-1 do
			if skincolors[i].name:lower() == self:lower()
				return i
			end
		end
		local v = self:upper()
		v = string.gsub(v, " ", "")
		if v:sub(1, 10) != "SKINCOLOR_"
			v = _G["SKINCOLOR_"..v]
		end
		local r = 1
		xpcall(
			function()
				if _G[v] != nil then r = _G[v] end
			end,
			function()
				r = SKINCOLOR_WHITE
			end
		)
		return r
	end
	return 0, "not found"
end

local CheckInvshade = function(self)
	if self
		local int = tonumber(self)
		if int
			if int > 15 then return 15, "edited" end
			if int < 0 then return 0, "edited" end
			return int
		else
			return 0
		end
	end
	return 0, "not found"
end

local CheckChatcolor = function(self)
	if self
		local v = tonumber(self)
		local IsCorrect = false
		if type(self) == "string"
			if self:sub(1, 2) == "V_"
			and _G[self]
				v = _G[self]
			elseif _G["V_"..self]
				v = _G["V_"..self]
			end
		end
		if v != nil
			for i = 1, #LC.colormaps do
				if v == LC.colormaps[i].value
					return v
				end
			end
		elseif v == nil
			for i = 1, #LC.colormaps do
				if value == LC.colormaps[i].name
					return LC.colormaps[i].value
				end
			end
		end
		return 0, "not found"
	end
	return 0, "not found"
end

