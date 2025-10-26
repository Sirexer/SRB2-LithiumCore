LithiumCore.functions.MakeDeepCopy = function(original, seen)
    seen = seen or {}
    if seen[original] then return seen[original] end
    
    local t = type(original)
    if t ~= "table" then return original end
    
    if t == "userdata" then return original end
    
    local copy = {}
    seen[original] = copy
    
    for key, value in pairs(original) do
        copy[key] = LithiumCore.functions.MakeDeepCopy(value, seen)
    end
	
	for i in ipairs(original) do
		copy[i] = LithiumCore.functions.MakeDeepCopy(copy[i], seen)
	end
    return copy
end

return true -- End Of File
