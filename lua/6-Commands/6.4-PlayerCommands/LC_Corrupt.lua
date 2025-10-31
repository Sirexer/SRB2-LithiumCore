local LC = LithiumCore

local rc = FU/16

COM_AddCommand("LC_corrupt", function(player, arg)
	//if player == server then return end
	if player != consoleplayer then return end
	
	for side in sides.iterate do
		
		if side.toptexture != "-" and side.toptexture != ""
		and side.toptexture and P_RandomChance(rc)
			side.toptexture = R_TextureNumForName("SMISSTXE")
		end
		
		if side.midtexture != "-" and side.midtexture != ""
		and side.midtexture and P_RandomChance(rc)
			side.midtexture = R_TextureNumForName("SMISSTXE")
		end
		
		if side.bottomtexture != "-" and side.bottomtexture != ""
		and side.bottomtexture and P_RandomChance(rc)
			side.bottomtexture = R_TextureNumForName("SMISSTXE")
		end
		
	end
	
	for sector in sectors.iterate do
		if sector.floorpic != "-" and sector.floorpic != "" //and sector.floorpic != "F_SKY1"
		and sector.floorpic and P_RandomChance(rc)
			sector.floorpic = "SMISSTXE"
		end
		
		if sector.ceilingpic != "-" and sector.ceilingpic != "" //and sector.ceilingpic != "F_SKY1"
		and sector.ceilingpic and P_RandomChance(rc)
			sector.ceilingpic = "SMISSTXE"
		end
	end
	
	for mo in mobjs.iterate() do
		if mo and mo.valid and P_RandomChance(rc)
			mo.state = S_UNKNOWN
		end
	end
	
end, COM_LOCAL)

return true
