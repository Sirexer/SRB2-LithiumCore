local LC = LithiumCore

local motd = {
	name = "LC.MOTD",
	type = "KeyDown",
	toggle = true,
	priority = 1100,
	TimeMicros = 0,
	func = function(key)
		if LC.localdata.motd.open == true
			if LC.functions.GetMenuAction(key.name) == LCMA_NAVUP
				LC.localdata.motd.nscroll = $ - 8*FU
			elseif key.name == "wheel 1 up"
				LC.localdata.motd.nscroll = $ - 16*FU
			elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVDOWN
				LC.localdata.motd.nscroll = $ + 8*FU
			elseif key.name == "wheel 1 down"
				LC.localdata.motd.nscroll = $ + 16*FU
			elseif LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT or LC.functions.GetMenuAction(key.name) == LCMA_BACK
				if not LC.localdata.loginwindow
					LC.localdata.motd.open = false
				else
					LC.localdata.motd.closing = true
				end
			end
			return true, true
		end
	end
}

table.insert(LC_Loaderdata["hook"], motd)

return true
