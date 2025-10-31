local LC = LithiumCore

COM_AddCommand("LC_setcontol", function(player, control, key)
	if not control and not key then return end
	if player != consoleplayer then return end
	for i in ipairs(LC.localdata.controls) do
		local LC_Control = LC.localdata.controls[i]
		if LC_Control
			if LC_Control.name:lower() == control:lower() then
				LC_Control.key = key
				LC.functions.SaveControls("save")
			end
		end
	end
end)

return true
