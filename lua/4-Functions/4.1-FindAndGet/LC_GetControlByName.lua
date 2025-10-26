local LC = LithiumCore

-- Returns the key to which the control is bound
LC.functions.GetControlByName = function(name)
	if name
		local LC_local = LC.localdata
		if LC_local.controls
			for k, v in pairs(LC_local.controls) do
				if v.name == name
					return LC_local.controls[k].key
				end
			end
		end
	end
end

return true
