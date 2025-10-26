local LC = LithiumCore

local hooktable = {
	name = "LC.StuffAccounts",
	type = "PlayerQuit",
	toggle = true,
	TimeMicros = 0,
	func = function(player, reason)
		-- A bot cannot have an account, so skip it
		local bot_suffix = string.gsub("\x84".."[BOT]", "%W","%%%0")
		if player.name:find(bot_suffix) then return end
		
		local key = player.stuffname or player.name..".unreg"
		LC.functions.SaveLoadOtherStuff(LC.accounts.OtherStuff[key], player, "save")
		if isserver == true
			if player.stuffname != nil
				LC.functions.SaveLoadNameStuff(#player, 0, "save")
			end
		end
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true