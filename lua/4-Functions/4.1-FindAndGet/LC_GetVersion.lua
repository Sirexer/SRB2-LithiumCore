local LC = LithiumCore

LC.functions.GetVersion = function()
	local v = LC.info
	local t = {
		string = v.version.."."..v.subversion,
		version = v.version,
		subversion = v.subversion,
		provisional = v.provisional
	}
	if v.provisional then t.string = t.string.." "..v.provisional end
	return t
end

return true
