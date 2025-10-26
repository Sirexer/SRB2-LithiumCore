local LC = LithiumCore

-- ==========================
-- Comparison table
-- ==========================
local input_map = {
	-- Keyboard
	["left arrow"]  = LCMA_NAVLEFT,
	["right arrow"] = LCMA_NAVRIGHT,
	["up arrow"]    = LCMA_NAVUP,
	["down arrow"]  = LCMA_NAVDOWN,
	["enter"]       = LCMA_ACCEPT,
	["escape"]      = LCMA_BACK,

	-- Gamepad
	["hatleft"]     = LCMA_NAVLEFT,
	["hatright"]    = LCMA_NAVRIGHT,
	["hatup"]       = LCMA_NAVUP,
	["hatdown"]     = LCMA_NAVDOWN,
	["joy1"]        = LCMA_ACCEPT,
	["joy2"]        = LCMA_BACK,
}

-- ==========================
-- Function for returning an action
-- ==========================
function LC.functions.GetMenuAction(keyname)
	return input_map[keyname] or nil
end

return true -- End of File
