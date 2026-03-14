local LC = LithiumCore

local hooktable = {
	name = "LC.AltScores",
	type = "KeyUp",
	toggle = true,
	priority = 800,
	TimeMicros = 0,
	func = function(key)
		local key_aGI = LC.functions.GetControlByName("Alt GameInfo")
		if LC.localdata.AltScores.enabled == false then return end
		if key.name == key_aGI
		and LC.localdata.AltScores.holded == true
			LC.localdata.AltScores.holded = false
			LC.localdata.AltScores.enabled = false
		end
		if key.name == "lshift" or key.name == "rshift"
			LC.localdata.AltScores.shift = false
		end
	end
}


table.insert(LC_Loaderdata["hook"], hooktable)

return true
