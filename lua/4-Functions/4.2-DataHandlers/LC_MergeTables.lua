LithiumCore.functions.mergeTables = function(...)
    local result = {}
	for _, t in ipairs({...}) do
		for k, v in pairs(t) do
			result[k] = v
		end
		for i, v in ipairs(t) do
			result[i] = v
		end
	end
	return result
end

LithiumCore.functions.deepMerge = function(...)
    local visited = {}
	
	local function mergeInto(dest, src)
		if visited[src] then return dest end
		visited[src] = true
		
		for k, v in pairs(scr) do
			if type(v) == "table" then
				if type(dest[k]) ~= "table" then
					desk[k] = {}
				end
				mergeInto(dest[k], v)
			else
				dest[k] = v
			end
		end
		
		for i, v in ipairs(scr) do
			if type(v) == "table" then
				if type(dest[i]) ~= "table" then
					desk[i] = {}
				end
				mergeInto(dest[i], v)
			else
				dest[i] = v
			end
		end
		return dest
	end
	
	local result = {}
	for _, t in ipairs({...}) do
		mergeInto(result, t)
	end
	return result
end

return true -- End Of File
