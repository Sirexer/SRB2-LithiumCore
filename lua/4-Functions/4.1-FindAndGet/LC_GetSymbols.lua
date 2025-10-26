local LC = LithiumCore

-- Returns characters when the shifter is held down
LC.functions.getsymbols = function(key)
	if key.num == 39 then return '\"' end
	if key.num == 44 then return "<" end
	if key.num == 45 then return "_" end
	if key.num == 46 then return ">" end
	if key.num == 47 then return "?" end
	if key.num == 48 then return ")" end
	if key.num == 49 then return "!" end
	if key.num == 50 then return "@" end
	if key.num == 51 then return "#" end
	if key.num == 52 then return "$" end
	if key.num == 53 then return "%" end
	if key.num == 54 then return "^" end
	if key.num == 55 then return "&" end
	if key.num == 56 then return "*" end
	if key.num == 57 then return "(" end
	if key.num == 59 then return ":" end
	if key.num == 61 then return "+" end
	if key.num == 91 then return "{" end
	if key.num == 92 then return "|" end
	if key.num == 93 then return "}" end
end

return true
