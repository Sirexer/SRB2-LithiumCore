local LC = LithiumCore

LC.replaced_functions.addHook = addHook
LC.replaced_functions.addHUD = hud.add

local AddHUD = function(func, hook)
	
	if type(func) != "function" then return end
	--if type(hook) != "string" then return end
	
	local OtherHUD = LC.HooksOtherHUD
	
	if type(hook) != "string" or hook:lower() == "game"
		table.insert(OtherHUD.game, func)
	elseif hook:lower() == "scores"
		table.insert(OtherHUD.scores, func)
	elseif hook:lower() == "title"
		table.insert(OtherHUD.title, func)
	elseif hook:lower() == "titlecard"
		table.insert(OtherHUD.titlecard, func)
	elseif hook:lower() == "intermission"
		table.insert(OtherHUD.intermission, func)
	elseif hook:lower() == "continue"
		table.insert(OtherHUD.cont, func)
	elseif hook:lower() == "playersetup"
		table.insert(OtherHUD.playersetup, func)
	end
end

addHook = function(...)
	local args = {...}
	if args[1] == "PlayerMsg" then return end
	if args[1] == "HUD"
		AddHUD(args[2], args[3])
	end
	LC.replaced_functions.addHook(...)
end

hud.add = function(func, hook)
	AddHUD(func, hook)
end

return true -- End Of File
