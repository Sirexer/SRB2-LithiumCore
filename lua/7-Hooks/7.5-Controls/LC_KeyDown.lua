local LC = LithiumCore

local hooktable = {
	name = "LC.Controls",
	type = "KeyDown",
	toggle = true,
	priority = 300,
	TimeMicros = 0,
	func = function(key)
		if chatactive == true then return end
		local LC_local = LC.localdata
		if LC_local.controls
			for i in ipairs(LC_local.controls) do
				local l_control = LC_local.controls[i]
				if string.lower(l_control.key) == key.name then
					local control_t
					for a in ipairs(LC.controls) do
						if LC.controls[a].name == l_control.name then
							control_t = LC.controls[a]
							break
						end
					end
					if control_t
						if control_t.type == "press"
						and key.repeated == false
							control_t.func()
							return control_t.block
						end
					end
				end
			end
		end
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

local holded_keys = {
	name = "LC.holdedkeys",
	type = "KeyDown",
	toggle = true,
	priority = 2000,
	TimeMicros = 0,
	func = function(key)
		local HKT = LC.localdata.pressed_keys
		
		for i in ipairs(HKT) do
			if key.num == HKT[i].num
				HKT[i].repeated = key.repeated
				return
			end
		end
		
		local key_table = {
			name = key.name,
			num = key.num,
			repeated = key.repeated,
			tics = 0
		}
		
		table.insert(HKT, key_table)
	end
}

table.insert(LC_Loaderdata["hook"], holded_keys)

return true
