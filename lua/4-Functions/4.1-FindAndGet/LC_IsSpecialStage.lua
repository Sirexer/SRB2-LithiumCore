local LC = LithiumCore

LC.functions.IsSpecialStage = function(mapnum)
	if not mapnum then mapnum = gamemap end
	if type(mapnum) != "number"
		return
	end
	if mapnum >= sstage_start and mapnum <= sstage_end
	or mapnum >= smpstage_start and mapnum <= smpstage_end
		return true
	else
		return false
	end
end

return true
