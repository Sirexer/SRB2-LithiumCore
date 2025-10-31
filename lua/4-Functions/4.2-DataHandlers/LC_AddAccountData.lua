local LC = LithiumCore

--[[
	Function: LC.functions.AddAccountData
	-------------------------------------
	Registers a callback function used to handle player account data
	when saving or loading persistent information (such as scores, lives, etc.).

	Arguments:
		func (function)
			- A function reference that will be called automatically during
			  account data load/save events.  
			  The function must follow the structure:
				`func(action, datatable, player)`

			Parameters of the registered function:
				• action (string) — either "load" or "save"
				• datatable (table) — table where the data is stored or read
				• player (player_t) — target player object for saving/loading

	Returns:
		nil

	Description:
		This function adds a data handler to the LithiumCore account system.
		It is mainly used by add-ons or modules that wish to store player-related
		data (such as score, lives, powers, or custom variables) across sessions.

		When an account is saved, all registered handlers receive the call:
			func("save", datatable, player)
		When an account is loaded, all handlers receive:
			func("load", datatable, player)

		Handlers must be responsible for reading/writing only their own keys
		inside the provided datatable.

	Example:
		local function data(action, datatable, player)
			if not (action and datatable and player) then return end
			if not G_CoopGametype() then return end

			if string.lower(action) == "load" then
				if datatable.score then player.score = datatable.score end
				if datatable.lives then player.lives = datatable.lives end
				if datatable.shield ~= nil then
					player.powers[pw_shield] = datatable.shield
					P_SpawnShieldOrb(player)
				end
			elseif string.lower(action) == "save" then
				datatable.score  = player.score
				datatable.lives  = player.lives
				datatable.shield = player.powers[pw_shield]
			end
		end

		LC.functions.AddAccountData(data)

	Notes:
		- The handler must be a valid function; otherwise, a warning will be printed.
		- Handlers are stored in LC.accountsData and executed sequentially.
]]

LC.functions.AddAccountData = function(func)
	if func
		if type(func) == "function"
			table.insert(LC.accountsData, func)
			print("\x83".."NOTICE".."\x80"..": Added "..#LC.accountsData.." to datasave")
		else
			print("\x82WARNING\x80: Expected function, got "..type(func))
		end
	end
end

return true
