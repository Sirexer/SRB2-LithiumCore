local LC = LithiumCore

-- create a Skincolor slot for each node.
for i = 0, 32 do
	local str = tostring(i)
	if str:len() == 1
		str = "0"..str
	end
	freeslot("SKINCOLOR_LCSEND"..str)
	skincolors[_G["SKINCOLOR_LCSEND"..str]] = {
		name = "SKINCOLOR_LCSEND"..str,
		ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		invcolor = SKINCOLOR_WHITE,
		invshade = 1,
		chatcolor = V_WHITEMAP,
		accessible = false 
	}
	-- Create and in serverdata for synchronization. 
	LC.serverdata.skincolors["SKINCOLOR_LCSEND"..str] = {
		name = "SKINCOLOR_LCSEND"..str,
		ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		invcolor = SKINCOLOR_WHITE,
		invshade = 1,
		chatcolor = V_WHITEMAP,
		accessible = false 
	}
end

-- Skincolor slot to be displayed in the menu
for i = 0, 3 do
	local str = tostring(i)
	if i == 0
		str = "EDIT"
	end
	freeslot("SKINCOLOR_LCPV"..str)
	skincolors[_G["SKINCOLOR_LCPV"..str]] = {
		name = "SKINCOLOR_LCPV"..str,
		ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		invcolor = SKINCOLOR_WHITE,
		invshade = 1,
		chatcolor = V_WHITEMAP,
		accessible = false 
	}
end

-- The skincolor slot that is imported from the files
freeslot("SKINCOLOR_LCPVIMPORT")
skincolors[SKINCOLOR_LCPVIMPORT] = {
	name = "SKINCOLOR_LCPVIMPORT",
	ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	invcolor = SKINCOLOR_WHITE,
	invshade = 1,
	chatcolor = V_WHITEMAP,
	accessible = false 
}

freeslot("SKINCOLOR_FIRECOPPER")
skincolors[SKINCOLOR_FIRECOPPER] = {
    name = "Firecopper",
    ramp = {187,186,186,44,44,43,42,61,60,58,56,53,52,64,84,88},
    invcolor = 44,
    invshade = 6,
    chatcolor = 8192,
    accessible = true
}

return true
