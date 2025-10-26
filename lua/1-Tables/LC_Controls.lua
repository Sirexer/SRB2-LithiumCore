local LC = LithiumCore

LithiumCore.controls = { -- Table controls
	{
		name = "open menu", -- Control name
		displayname = "LC_CONTROL_OPENMENU", 
		defaultkey = "m", -- Default key if the key has not yet been assigned
		type = "press", -- Not currently in use
		block = false, -- Should block other controls if necessary
		func = function() -- This function is run if the key is pressed
			LC.functions.menuactive(consoleplayer)
		end
		//command = "LC_menu"
	},
		
	{
		name = "vote yes",
		displayname = "LC_CONTROL_VOTEYES",
		defaultkey = "[",
		type = "press",
		block = false,
		func = function()
			COM_BufInsertText(consoleplayer, "vote yes")
		end
		//command = "LC_vote yes"
	},
	
	{
		name = "vote no",
		displayname = "LC_CONTROL_VOTENO",
		defaultkey = "]",
		type = "press",
		block = false,
		func = function()
			COM_BufInsertText(consoleplayer, "vote no")
		end
		//command = "LC_vote no"
	},
	
	{
		name = "Alt GameInfo",
		displayname = "LC_CONTROL_ALTGI",
		defaultkey = "tab",
		type = "press",
		block = true,
		func = function()
			if LC.localdata.AltScores.enabled == false
				LC.localdata.AltScores.holded = false
				LC.localdata.AltScores.enabled = true
				LC.localdata.AltScores.selected = nil
				LC.localdata.AltScores.nav = {x = 0, y = 0}
				LC.localdata.AltScores.first = 1
				LC.localdata.AltScores.action = {
					nav = 1,
					index = 0,
					first = 1,
					args = {},
					table = {}
				}
				LC.localdata.AltScores.popupmsg = {
					str = nil,
					y = 0,
					flags = 0
				}
			elseif LC.localdata.AltScores.enabled == true
			and LC.localdata.AltScores.holded == false
				LC.localdata.AltScores.enabled = false
			end
		end
	},
	
	{
		name = "Play Emotes",
		displayname = "LC_CONTROL_PLAYEMOTES",
		defaultkey = "p",
		type = "press",
		block = true,
		func = function()
			if LC.localdata.selectemoji == false
				LC.localdata.selectemoji = true
			elseif LC.localdata.selectemoji == true
				LC.localdata.selectemoji = false
			end
		end
	}
}

return true
