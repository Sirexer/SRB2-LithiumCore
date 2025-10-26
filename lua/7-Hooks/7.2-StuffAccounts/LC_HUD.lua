local LC = LithiumCore

local hooktables = {
	{
		name = "LC.StuffAccounts",
		type = "HUD",
		typehud = {"game"},
		TimeMicros = 0,
		priority = 1000,
		func = function(v, player, camera)
			local player = consoleplayer
			local hud_savestuff = nil
			local hud_countsave = 0
			local hus_transicon = V_SNAPTORIGHT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE
			if player.hud_st_count == 10
				hus_transicon = V_SNAPTORIGHT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_90TRANS
			elseif player.hud_st_count == 9 or player.hud_st_count == 11
				hus_transicon = V_SNAPTORIGHT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_80TRANS
			elseif player.hud_st_count == 8 or player.hud_st_count == 12
				hus_transicon = V_SNAPTORIGHT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_70TRANS
			elseif player.hud_st_count == 7 or player.hud_st_count == 13
				hus_transicon = V_SNAPTORIGHT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_60TRANS
			elseif player.hud_st_count == 6 or player.hud_st_count == 14
				hus_transicon = V_SNAPTORIGHT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_50TRANS
			elseif player.hud_st_count == 5 or player.hud_st_count == 15
				hus_transicon = V_SNAPTORIGHT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_40TRANS
			elseif player.hud_st_count == 4 or player.hud_st_count == 16
				hus_transicon = V_SNAPTORIGHT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_30TRANS
			elseif player.hud_st_count == 3 or player.hud_st_count == 17
				hus_transicon = V_SNAPTORIGHT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_20TRANS
			elseif player.hud_st_count == 2 or player.hud_st_count == 18
				hus_transicon = V_SNAPTORIGHT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_10TRANS
			elseif player.hud_st_count == 1
				hus_transicon = V_SNAPTORIGHT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE
			elseif player.hud_st_count == 0
				hus_transicon = V_SNAPTORIGHT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE
			end
			if player.stuffname == nil
				if player.delay_stuffload == 0
				and not LC.localdata.loginwindow
				and not LC.localdata.waiting_totd
					local text2 = "Use command LC_menu to open LithiumCore menu."
					if LC.localdata.controls["open menu"] and LC.localdata.controls["open menu"] != "..."
						text2 = "Press key \""..LC.localdata.controls["open menu"].."\" to open LithiumCore menu."
					end
					v.drawString(0, 194, (tostring("\x85".."Register or login to save your items! "..text2)), V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOBOTTOM, "small")
				else
					v.drawString(0, 194, (tostring("\x82".."Signing in...")), V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOBOTTOM, "small")
				end
			end
			if player.newuser != true
				if player.hud_countload != nil and player.hud_countload > 0
					v.drawString(0, 194, (tostring("\x83".."Your stuff have been given.")), V_30TRANS|V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOBOTTOM, "small")
				end
			end
			if player.hud_countsave != nil and player.hud_countsave > 0
				v.drawScaled(307*FRACUNIT, 150*FRACUNIT, 45056, v.cachePatch("M_FSAVE"), V_SNAPTORIGHT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_30TRANS)
				v.drawScaled(307*FRACUNIT, 150*FRACUNIT, 45056, v.cachePatch("M_FLOAD"), hus_transicon)
				//v.drawString(0, 194, (tostring("\x83".."Saving your stuff...")), V_30TRANS|V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOBOTTOM, "small")
			end
		end
	},

	{
		name = "LC.StuffAccounts",
		type = "HUD",
		typehud = {"scores"},
		priority = 100,
		TimeMicros = 0,
		func = function(v)
			local player = consoleplayer
			if consoleplayer.stuffname == nil
				v.drawString(16, 0, ("\x84Username:\x85 without an account."), V_ALLOWLOWERCASE, "thin")
			else
				v.drawString(16, 0, ("\x84Username:\x8b "..consoleplayer.stuffname), V_ALLOWLOWERCASE, "thin")
			end
		end
	},

	{
		name = "LC.StuffAccounts",
		type = "HUD",
		typehud = {"game", "scores"},
		priority = 750,
		TimeMicros = 0,
		func = function(v)
			local player = consoleplayer
			if LC.consvars["LC_unregblock"].value == 1 and not IsPlayerAdmin(player) and player != server and player.stuffname == nil
				v.fadeScreen(31, 10)
				v.drawString(160, 48, ("\x82WARNING"), 0, "center")
				LC.functions.drawString(v, 160, 56, LC.functions.getStringLanguage("LC_UNREG_MSG1"), V_ALLOWLOWERCASE, "center")
				LC.functions.drawString(v, 160, 64, LC.functions.getStringLanguage("LC_UNREG_MSG2"), V_ALLOWLOWERCASE, "center")
				LC.functions.drawString(v, 160, 72, LC.functions.getStringLanguage("LC_UNREG_MSG3"), V_ALLOWLOWERCASE, "thin-center")
				LC.functions.drawString(v, 160, 80, LC.functions.getStringLanguage("LC_UNREG_MSG4"), V_ALLOWLOWERCASE, "thin-center")
				local text = LC.functions.getStringLanguage("LC_UNREG_MSG5")
				local key_menu = LC.functions.GetControlByName("open menu")
				if key_menu and key_menu!= "..."
					text = LC.functions.getStringLanguage("LC_UNREG_MSG6"):format(key_menu)
				end
				LC.functions.drawString(v, 160, 88, text, V_ALLOWLOWERCASE, "thin-center")
				if player.lcgetkick
					LC.functions.drawString(v, 160, 104, LC.functions.getStringLanguage("LC_UNREG_MSG7"):format((player.lcgetkick/TICRATE)+1), V_ALLOWLOWERCASE, "center")
				end
			end
		end
	},
	
	{
		name = "LC.StuffAccounts",
		type = "HUD",
		typehud = {"game", "scores"},
		priority = 1000,
		TimeMicros = 0,
		func = function(v)
			local player = consoleplayer
			if type(LC.localdata.loginwindow) == "table"
			and LC.localdata.motd.open == false 
				v.fadeScreen(31, 5)
				v.drawFill(16, 40, 288, 96, 253)
				v.drawString(160, 48, "\x83NOTICE", 0, "center")
				LC.functions.drawString(v, 160, 64, LC.functions.getStringLanguage("LC_LOGINMSG1"), 0, "center")
				LC.functions.drawString(v, 160, 72, LC.functions.getStringLanguage("LC_LOGINMSG2"), 0, "center")
				LC.functions.drawString(v, 160, 80, LC.functions.getStringLanguage("LC_LOGINMSG3"):format(CV_FindVar("servername").string), 0, "center")
				LC.functions.drawString(v, 160, 88, LC.functions.getStringLanguage("LC_LOGINMSG4"):format(LC.serverdata.id), 0, "center")
				LC.functions.drawString(v, 160, 96, LC.functions.getStringLanguage("LC_LOGINMSG5"):format(LC.localdata.loginwindow.user), 0, "center")
				v.drawString(160, 120, "\x83 Space\x80 - Enter    \x85 Escape\x80 - Abort", 0, "center")
			end
			
			if LC.localdata.waiting_totd
				v.fadeScreen(31, 5)
				v.drawFill(16, 56, 288, 80, 253)
				v.drawString(160, 64, "\x83NOTICE", 0, "center")
				LC.functions.drawString(v, 160, 72, LC.functions.getStringLanguage("LC_TOTPMSG1"), 0, "center")
				LC.functions.drawString(v, 160, 80, LC.functions.getStringLanguage("LC_TOTPMSG2"), 0, "center")
				LC.functions.drawString(v, 160, 88, LC.localdata.waiting_totd.err, 0, "center")
				--[[
				v.drawString(160, 72, "Two-factor authentication.", 0, "center")
				v.drawString(160, 80, "Enter the authentication code", 0, "center")
				v.drawString(160, 88, LC.localdata.waiting_totd.err, 0, "center")
				]]
				v.drawFill(127, 107, 65, 10, 254)
				v.drawString(160, 108, "--------", V_90TRANS, "center")
				v.drawString(160, 108, LC.localdata.waiting_totd.code, 0, "center")
				v.drawString(160, 120, "\x83 Space\x80 - Enter    \x85 Escape\x80 - Abort", 0, "center")
				if player.stuffname	then
					LC.localdata.waiting_totd = nil
				end
			end
		end
	}
}

for i = 1, #hooktables do
	table.insert(LC_Loaderdata["hook"], hooktables[i])
end

return true

