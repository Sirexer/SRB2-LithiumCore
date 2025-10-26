local LC = LithiumCore

local OtherHUD = LC.HooksOtherHUD

LC.replaced_functions.addHook("HUD", function(v, player, camera)
	for h in ipairs(OtherHUD.game) do
		OtherHUD.game[h](v, player, camera)
	end
end, "game")

LC.replaced_functions.addHook("HUD", function(v)
	for h in ipairs(OtherHUD.scores) do
		OtherHUD.scores[h](v)
	end
end, "scores")

LC.replaced_functions.addHook("HUD", function(v)
	for h in ipairs(OtherHUD.title) do
		OtherHUD.title[h](v)
	end
end, "title")

LC.replaced_functions.addHook("HUD", function(v, player, ticker, endtime)
	for h in ipairs(OtherHUD.titlecard) do
		OtherHUD.titlecard[h](v, player, ticker, endtime)
	end
end, "titlecard")

LC.replaced_functions.addHook("HUD", function(v)
	for h in ipairs(OtherHUD.intermission) do
		OtherHUD.intermission[h](v)
	end
end, "intermission")

LC.replaced_functions.addHook("HUD", function(v, player, x, y, scale, skin, sprite, frame, rotation, color, ticker, continuing)
	for h in ipairs(OtherHUD.cont) do
		OtherHUD.cont[h](v, player, x, y, scale, skin, sprite, frame, rotation, color, ticker, continuing)
	end
end, "continue")

LC.replaced_functions.addHook("HUD", function(v, player, x, y, scale, skin, sprite, frame, rotation, color, ticker, paused)
	for h in ipairs(OtherHUD.playersetup) do
		OtherHUD.playersetup[h](v, player, x, y, scale, skin, sprite, frame, rotation, color, ticker, paused)
	end
end, "playersetup")

return true
