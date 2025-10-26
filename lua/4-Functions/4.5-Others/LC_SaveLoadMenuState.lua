local LC = LithiumCore

LC.functions.saveloadmenustate = function(sl)
	if sl == "save"
		if LC.menu.LC_ms != nil and LC.menu.player_state != nil
			local LC_menu = LC.menu.player_state
			local t = {
				nav = LC_menu.nav,
				lastnav = LC_menu.lastnav,
				category = LC_menu.category,
				subcategory = LC_menu.subcategory,
				fade = LC_menu.fade,
				panelx = LC_menu.panelx,
				closing = LC_menu.closing,
				opening = LC_menu.opening,
				capslock = LC_menu.capslock,
				shift = LC_menu.shift,
				select_player = LC_menu.select_player,
				LC_allowcommands = LC_menu.LC_allowcommands,
				com_vars = LC_menu.com_vars
			}
			table.insert(LC.menu.LC_ms, t)
		end
	elseif sl == "load"
		local LC_menu = LC.menu.player_state
		local old_sm = LC.menu.LC_ms[#LC.menu.LC_ms]
		LC_menu.nav = old_sm.nav
		LC_menu.lastnav = old_sm.lastnav
		LC_menu.category = old_sm.category
		LC_menu.subcategory = old_sm.subcategory
		LC_menu.fade = old_sm.fade
		LC_menu.panelx = old_sm.panelx
		LC_menu.closing = old_sm.closing
		LC_menu.opening = old_sm.opening
		LC_menu.capslock = old_sm.capslock
		LC_menu.shift = old_sm.shift
		LC_menu.select_player = old_sm.select_player
		LC_menu.LC_allowcommands = old_sm.LC_allowcommands
		LC_menu.com_vars = old_sm.com_vars
		table.remove(LC.menu.LC_ms, #LC.menu.LC_ms)
	end
end

return true
