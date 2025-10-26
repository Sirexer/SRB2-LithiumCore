local LC = LithiumCore

LC.functions.GetFileSize = function(self)
	if io.type(self) == nil then return end
	
	local bytes = self:seek("end")
	
	local kb_int = bytes / 1024

	local remainder = bytes % 1024
	
	local fractional = (remainder * 100 + 511) / 1024
	
	local size_str
	if fractional >= 100 then
		kb_int = kb_int + 1
		size_str = kb_int .. ".00 KB"
	else
	
		size_str = string.format("%d.%02d KB", kb_int, fractional)
	end
    return size_str
end

return true -- End Of File
