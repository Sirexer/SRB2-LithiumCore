local LC = LithiumCore

local calmdown_execute = 5

local servernameload = true

local servername = CV_FindVar("servername")

local LC_pi = {
	name = "LC.PlayerIndicators",
	type = "ThinkFrame",
	toggle = true,
	TimeMicros = 0,
	func = function()
		if consoleplayer
			if leveltime > 5 and (leveltime % 2) == 1
				-- Player Indicators
				if not consoleplayer.LC_indicators then return end
				local LC_pi = consoleplayer.LC_indicators
				
				if calmdown_execute != 0 then calmdown_execute = $ - 1 return end
				
				-- Chat
				if chatactive == true and LC_pi.chat == false
					COM_BufInsertText(consoleplayer, "___lcpi chat true")
					calmdown_execute = 5
				elseif chatactive == false and LC_pi.chat == true
					COM_BufInsertText(consoleplayer, "___lcpi chat false")
					calmdown_execute = 5
				end
				
				-- Menu
				local Is_InMenu = false
				if menuactive == true or LC.menu.player_state
					Is_InMenu = true
				end
				
				if Is_InMenu == true and LC_pi.menu == false
					COM_BufInsertText(consoleplayer, "___lcpi menu true")
					calmdown_execute = 5
				elseif Is_InMenu == false and LC_pi.menu == true
					COM_BufInsertText(consoleplayer, "___lcpi menu false")
					calmdown_execute = 5
				end
				
			end
		end
	end
}

table.insert(LC_Loaderdata["hook"], LC_pi)

return true
