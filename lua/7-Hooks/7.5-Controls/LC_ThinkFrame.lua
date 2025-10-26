local LC = LithiumCore

local holded_keys = {
	name = "LC.holdedkeys",
	type = "PreThinkFrame",
	toggle = true,
	TimeMicros = 0,
	func = function()
		local HKT = LC.localdata.pressed_keys
		
		for i in ipairs(HKT) do
			HKT[i].tics = $ + 1
		end
	end
}

table.insert(LC_Loaderdata["hook"], holded_keys)

return true
