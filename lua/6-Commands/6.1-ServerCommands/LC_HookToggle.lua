local LC = LithiumCore

/*
COM_AddCommand("LC_hooktoggle", function(player, func_hook, toggle)
	if player and player == server
		if func_hook and LC.serverdata.HooksToggle[func_hook] != nil
			if toggle
				if string.lower(toggle) == "off"
				or string.lower(toggle) == "disable"
				or string.lower(toggle) == "no"
				or string.lower(toggle) == "0"
					 LC.serverdata.HooksToggle[func_hook] = false
					 print(func_hook.." ".."\x85".."Disabled")
				elseif string.lower(toggle) == "on"
				or string.lower(toggle) == "enable"
				or string.lower(toggle) == "yes"
				or string.lower(toggle) == "1"
					LC.serverdata.HooksToggle[func_hook] = true
					print(func_hook.." ".."\x83".."Enabled")
				end
				return
			else
				local enabled = "\x85".."Disabled"
				if LC.serverdata.HooksToggle[func_hook] == true
					enabled = "\x83".."Enabled"
				end
				print(func_hook.." "..enabled)
				return
			end
		end
		local allfh = ""
		for k,v in pairs(LC.serverdata.HooksToggle) do
			local enabled = "\x85".."No"
			if v == true
				enabled = "\x83".."Yes"
			end
			allfh = allfh.."Name: "..k.." Enabled: "..enabled.."\x80".."\n"
		end
		print("\x82".."Available ToggleHooks".."\x80"..":\n"..allfh)
	end
end, COM_LOCAL)
*/
return true
