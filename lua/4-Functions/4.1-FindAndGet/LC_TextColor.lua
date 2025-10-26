local LC = LithiumCore

LC.functions.GetLastColor = function(text)
	local reversed = string.reverse(text)
	local fc = 1
	local l = string.len(text)+1
	for i = 1, #LC.colormaps do
		if reversed:find(LC.colormaps[i].hex)
			if reversed:find(LC.colormaps[i].hex) < l
				l = reversed:find(LC.colormaps[i].hex)
				fc = i
			end
		end
	end
	return fc
end

LC.functions.SetNewColor = function(text, color)
	local str = text
	local len = text:len()
	local ls = text:sub(len)
	if not color then return text end
	if str == ""
		return LC.colormaps[color].hex
	end
	for i = 1, #LC.colormaps do
		if ls == LC.colormaps[i].hex
			str = str:sub(1, len-1)
			break
		end
	end
	local reversed = string.reverse(str)
	local fc = 1
	local l = string.len(str)+1
	local IsColorsExists = false
	for i = 1, #LC.colormaps do
		if reversed:find(LC.colormaps[i].hex)
			if reversed:find(LC.colormaps[i].hex) == l
				l = reversed:find(LC.colormaps[i].hex)
				fc = i
				IsColorsExists = true
			end
		end
	end
	if fc != color and IsColorsExists == true
		str = str
	else
		str = str..LC.colormaps[color].hex
	end
	return str
end

return true
