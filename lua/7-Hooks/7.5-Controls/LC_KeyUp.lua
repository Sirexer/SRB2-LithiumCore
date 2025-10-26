local LC = LithiumCore

local holded_keys = {
	name = "LC.holdedkeys",
	type = "KeyUp",
	toggle = true,
	priority = 300,
	TimeMicros = 0,
	func = function(key)
		local HKT = LC.localdata.pressed_keys
		
		for i in ipairs(HKT) do
			if key.num == HKT[i].num
				table.remove(HKT, i)
			end
		end
	end
}

table.insert(LC_Loaderdata["hook"], holded_keys)

return true
