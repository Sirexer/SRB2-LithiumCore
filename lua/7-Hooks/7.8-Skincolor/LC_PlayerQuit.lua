local LC = LithiumCore

local hooktable = {
	name = "LC.Skincolor",
	type = "PlayerQuit",
	toggle = true,
	TimeMicros = 0,
	func = function(player, reason)
		local node = tostring(#player)
		if node:len() == 1
			node = "0"..node
		end
		for p in players.iterate do
			local rcs = skincolors[P_RandomRange(SKINCOLOR_WHITE, SKINCOLOR_ROSY)]
			if p.realmo and p.realmo.valid then rcs = skincolors[skins[p.realmo.skin].prefcolor] end
			if p.skincolor == skincolors[ _G["SKINCOLOR_LCSEND"..node] ]
				p.skincolor = R_GetColorByName(rcs.name)
			end
			if p.realmo and p.realmo.valid and p.realmo.color == _G["SKINCOLOR_LCSEND"..node]
				p.realmo.color = R_GetColorByName(rcs.name)
			end
			if player == consoleplayer then CV_StealthSet(cv_color, rcs.name) end
		end
		skincolors[_G["SKINCOLOR_LCSEND"..node]] = {
		name = "SKINCOLOR_LCSEND"..node,
		ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		invcolor = SKINCOLOR_WHITE,
		invshade = 1,
		chatcolor = V_WHITEMAP,
		accessible = false 
		}
		LC.serverdata.skincolors["SKINCOLOR_LCSEND"..node] = {
			name = "SKINCOLOR_LCSEND"..node,
			ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			invcolor = SKINCOLOR_WHITE,
			invshade = 1,
			chatcolor = V_WHITEMAP,
			accessible = false 
		}
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true
