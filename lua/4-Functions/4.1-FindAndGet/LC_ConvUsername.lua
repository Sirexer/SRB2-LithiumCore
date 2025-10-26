-- This is needed to create a folder
local LC = LithiumCore

LC.functions.getname = function(cmd_string)
	local string_1 = string.gsub(cmd_string, "/", "")
	local string_2 = string.gsub(string_1, "\\", "")
	local string_3 = string.gsub(string_2, "*", "")
	local string_4 = string.gsub(string_3, ":", "")
	local string_5 = string.gsub(string_4, "\"", "")
	local string_6 = string.gsub(string_5, "?", "")
	local string_7 = string.gsub(string_6, "|", "")
	local string_8 = string.gsub(string_7, "<", "")
	local string_9 = string.gsub(string_8, ">", "")
	local stuffname = string.gsub(string_9, "%.", "")
	return stuffname
end

return true
