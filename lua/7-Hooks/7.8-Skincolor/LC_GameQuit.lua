local LC = LithiumCore

local json = json //LC_require "json.lua"

local cv_color = CV_FindVar("color")

local hooktable = {
	name = "LC.Skincolor",
	type = "GameQuit",
	toggle = true,
	TimeMicros = 0,
	func = function(quitting)
		-- Reset All color
		for i = 0, 32 do
			local str = tostring(i)
			if str:len() == 1
				str = "0"..str
			end
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
		
		CV_StealthSet(cv_color, SKINCOLOR_BLUE)
		
		LC.localdata.sendcolor = false
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true
