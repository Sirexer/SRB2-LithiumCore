local LC = LithiumCore

local json = json //LC_require "json.lua"

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
		
		local cv_color = CV_FindVar("color")
		
		if cv_color then
			CV_StealthSet(cv_color, SKINCOLOR_BLUE)
		end
		
		LC.localdata.sendcolor = false
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true
