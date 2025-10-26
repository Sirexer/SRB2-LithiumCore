local LC = LithiumCore

local hooktable = {
	name = "LC.StuffAccounts",
	type = "KeyDown",
	toggle = true,
	priority = 1000,
	TimeMicros = 0,
	func = function(key)
		if type(LC.localdata.loginwindow) == "table"
		and LC.localdata.motd.open == false
			if key.name == "space" or LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
				local username = LC.localdata.loginwindow.user
				local password = LC.localdata.loginwindow.pass
				COM_BufInsertText(player, "LC_login \""..username.."\" \""..password.."\"")
				LC.localdata.loginwindow = false
			elseif LC.functions.GetMenuAction(key.name) == LCMA_BACK
				LC.localdata.loginwindow = false
			end
			return true, true
		end
		if LC.localdata.waiting_totd
			if key.name == "space" or LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
				COM_BufInsertText(player, "LC_totp send "..LC.localdata.waiting_totd.code)
			elseif LC.functions.GetMenuAction(key.name) == LCMA_BACK
				LC.localdata.waiting_totd = nil
			else
				LC.localdata.waiting_totd.code = LC.functions.InputText(
					"password",
					LC.localdata.waiting_totd.code,
					key,
					true,
					false,
					8
				)
			end
			return true, true
		end
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true
