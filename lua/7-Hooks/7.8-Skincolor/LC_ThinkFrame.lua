local LC = LithiumCore

local hooktable = {
	name = "LC.Skincolor",
	type = "ThinkFrame",
	toggle = true,
	TimeMicros = 0,
	func = function()
		if consoleplayer
			if LC.client_consvars["loadskincolor"].value == 1
				if LC.localdata.sendcolor == false
				and consoleplayer.jointime >= 15
					LC.functions.Skincolor(consoleplayer, "load")
					LC.localdata.sendcolor = true
				end
			end
		end
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true
