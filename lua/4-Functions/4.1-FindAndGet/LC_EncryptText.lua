-- Encrypt password system for accounts
local LC = LithiumCore

LC.functions.Encrypt = function(var)
	local len = string.len(var)
	local len_c = 1
	local e_var = ""
	local g_var = ""
	local var = var
	local b_var = 0
	for i = 1, len do
		b_var = $ + string.byte(string.sub(var, i, i))
	end
	if len < 4 then
		var = var.."thok!"
		len = string.len(var)
	elseif len > 32 then
		var = string.sub(var, 1, 32)
		len = string.len(var)
	end
	while len_c <= len do
		local int = string.byte(var, len_c)
		int = $ - len*2
		e_var = e_var..int
		len_c = $ + 1
	end
	local e_len = string.len(e_var)
	local sub_c = 1
	e_var = string.gsub(e_var, "-", "0")
	if e_len > 7
		sub_c = 1
		while true do
			if sub_c+5 < e_len
				g_var = g_var..(tonumber(string.sub(e_var, sub_c, sub_c+5)))/(len*4)
				sub_c = $ +6
			else
				g_var = g_var..(tonumber(string.sub(e_var, sub_c, e_len)))/(len*4)
				//e_var = g_var
				break
			end
		end
	end
	if string.len(g_var) > 64 then g_var = string.sub(g_var, 1, 64)
	elseif string.len(g_var) < 64 then
		local sym = 63 - string.len(g_var)
		while sym != 0 do
			local as = string.sub(tostring(b_var/sym), string.len(tostring(b_var/sym)), string.len(tostring(b_var/sym)))
			g_var = as..g_var
			sym = $ - 1
		end
	end
	e_var = "SRB2_"..g_var
	return e_var
end

return true
