local LC = LithiumCore

local first = 1
local Selected_group = nil
local CanRemove = true
local DoIHavePerm = false
local HUD_perms = false
local add_perms = false
local all_perms = {}
local new_data = {
	["displayname"] = "",
	["color"] = "\x80",
	["priority"] = 0,
	["admin"] = false,
	["perms"] = {}
}

LC.localdata.ComInsert = {}

local t = {
	name = "LC_MENU_GROUPS",
	description = "LC_MENU_GROUPS_TIP",
	type = "admin",
	funchud = function(v)
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		v.drawScaledNameTag(216*FRACUNIT, 8*FRACUNIT, "Server Groups", V_ALLOWLOWERCASE|V_SNAPTOTOP, FRACUNIT/2, SKINCOLOR_SKY, SKINCOLOR_BLACK)
		if Selected_group == nil
			local real_height = (v.height() / v.dupx())
			local maxslots = real_height/10 - 6
			if LC.serverdata.groups.num[1] and LC_menu.nav != 0
				if LC_menu.nav < first
					first = $ - 1
				elseif LC_menu.nav > first+maxslots-1
					first = $ + 1
				end
			end
			-- Animate Arrow
			local arrow_y = 0
			if (leveltime % 10) > 5
				arrow_y = 2
			end
			
			-- Arrow Up
			if LC_menu.nav+1 > 0 and first != 1
				v.drawString(318, 50+arrow_y, "\x82"..string.char(26), V_SNAPTOTOP, "right")
			end
			-- Arrow Down
			if LC_menu.nav+1 != LC_menu.lastnav and #LC.serverdata.groups.num > maxslots and first+maxslots-1 < #LC.serverdata.groups.num
				v.drawString(318, 180+arrow_y, "\x82"..string.char(27), V_SNAPTOBOTTOM, "right")
			end
			local y = 20
			for i = first, first+maxslots-1 do
				if not LC.serverdata.groups.num[i] then break end
				if LC_menu.nav == i
					v.drawString(136, 30+y, (tostring("\x82"..LC.serverdata.groups.list[LC.serverdata.groups.num[i]].displayname)), V_SNAPTOTOP, "left")
				else
					v.drawString(136, 30+y, (tostring(LC.serverdata.groups.list[LC.serverdata.groups.num[i]].displayname)), V_SNAPTOTOP, "left")
				end
				y = $ + 10
			end
			if DoIHavePerm == true
				local create_group = LC.functions.getStringLanguage("LC_GROUP_CREATE")
				if LC_menu.nav == 0
					LC.functions.drawString(v, 136, 30, "\x82"..create_group, V_SNAPTOTOP, "left")
				else
					LC.functions.drawString(v, 136, 30, create_group, V_SNAPTOTOP, "left")
				end
			elseif DoIHavePerm == false
				local onlyread = LC.functions.getStringLanguage("LC_READONLY")
				LC.functions.drawString(v, 136, 30, "\x85"..onlyread, V_SNAPTOTOP, "left")
			end
		else
			if HUD_perms == false
				local str_name = LC.functions.getStringLanguage("LC_GROUP_NAME")
				if LC_menu.nav == 0
					LC.functions.drawString(v, 136, 24, "\x82"..str_name, V_SNAPTOTOP, "left")
				else
					LC.functions.drawString(v, 136, 24, str_name, V_SNAPTOTOP, "left")
				end
				v.drawFill(136, 33, 180, 10, 253|V_SNAPTOTOP)
				if LC_menu.nav == 0 and (leveltime % 4) / 2
					v.drawString(138, 34, new_data.displayname.."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
				else
					v.drawString(138, 34, new_data.displayname, V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
				end
				
				local color = LC.colormaps[1]
				for i = 1, #LC.colormaps do
					if LC.colormaps[i].hex == new_data.color
						color = LC.colormaps[i]
						break
					end
				end
				local str_color = LC.functions.getStringLanguage("LC_GROUP_COLOR")
				if LC_menu.nav == 1
					LC.functions.drawString(v, 138, 44, "\x82"..str_color, V_SNAPTOTOP, "left")
					v.drawString(138, 54, "\x82".."< "..color.hex..color.name.."\x82 >", V_SNAPTOTOP, "left")
				else
					LC.functions.drawString(v, 138, 44, str_color, V_SNAPTOTOP, "left")
					v.drawString(138, 54, color.hex..color.name, V_SNAPTOTOP, "left")
				end
				
				local str_priotity = LC.functions.getStringLanguage("LC_GROUP_PRIORITY")
				if LC_menu.nav == 2 and HUD_perms == false
					LC.functions.drawString(v, 136, 64, "\x82"..str_priotity, V_SNAPTOTOP, "left")
				else
					LC.functions.drawString(v, 136, 64, str_priotity, V_SNAPTOTOP, "left")
				end
				v.drawFill(136, 73, 180, 10, 253|V_SNAPTOTOP)
				if LC_menu.nav == 2
					v.drawString(138, 74, new_data.priority.."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
				else
					v.drawString(138, 74, new_data.priority, V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
				end
				
				local str_admin = LC.functions.getStringLanguage("LC_GROUP_ADMIN")
				local IsAdmin = "No"
				if new_data.admin == true then IsAdmin = "Yes" end
				if LC_menu.nav == 3 and HUD_perms == false
					LC.functions.drawString(v, 138, 84, "\x82"..str_admin, V_SNAPTOTOP, "left")
					v.drawString(138, 94, (tostring("\x82".."< "..IsAdmin.."\x82 >")), V_SNAPTOTOP, "left")
				else
					LC.functions.drawString(v, 138, 84, str_admin, V_SNAPTOTOP, "left")
					v.drawString(138, 94, (tostring(IsAdmin)), V_SNAPTOTOP, "left")
				end
				local str_perms = LC.functions.getStringLanguage("LC_GROUP_CMDPERMS"):format(#new_data.perms)
				if LC_menu.nav == 4
					LC.functions.drawString(v, 138, 104, "\x82"..str_perms, V_SNAPTOTOP, "left")
				else
					LC.functions.drawString(v, 138, 104, str_perms, V_SNAPTOTOP, "left")
				end
				
				if LC.menu.player_state.lognotice
					v.drawString(138, 154, (tostring(LC.menu.player_state.lognotice)), V_SNAPTOTOP, "left")
				end
				
				local str_remove = LC.functions.getStringLanguage("LC_GROUP_REMOVE")
				if LC_menu.nav == 5
					if CanRemove == true
						LC.functions.drawString(v, 12, 174, "\x82"..str_remove, V_SNAPTOTOP, "right")
					else
						LC.functions.drawString(v, 312, 174, "\x85"..str_remove, V_SNAPTOTOP, "right")
					end
				else
					if CanRemove == true
						LC.functions.drawString(v, 312, 174, str_remove, V_SNAPTOTOP, "right")
					else
						LC.functions.drawString(v, 312, 174, "\x86"..str_remove, V_SNAPTOTOP, "right")
					end
				end
				
				local str_create = LC.functions.getStringLanguage("LC_GROUP_CREATE")
				local str_save = LC.functions.getStringLanguage("LC_SC_SAVE")
				if LC_menu.nav == 6
					if DoIHavePerm == true
						if Selected_group == 0
							LC.functions.drawString(v, 312, 184, "\x82"..str_create, V_SNAPTOTOP, "right")
						elseif Selected_group != 0
							LC.functions.drawString(v, 312, 184, "\x82"..str_save, V_SNAPTOTOP, "right")
						end
					elseif DoIHavePerm == false
						if Selected_group == 0
							LC.functions.drawString(v, 312, 184, "\x85"..str_create, V_SNAPTOTOP, "right")
						elseif Selected_group != 0
							LC.functions.drawString(v, 312, 184, "\x85"..str_save, V_SNAPTOTOP, "right")
						end
					end
				else
					if DoIHavePerm == true
						if Selected_group == 0
							LC.functions.drawString(v, 312, 184, str_create, V_SNAPTOTOP, "right")
						elseif Selected_group != 0
							LC.functions.drawString(v, 312, 184, str_save, V_SNAPTOTOP, "right")
						end
					elseif DoIHavePerm == false
						if Selected_group == 0
							LC.functions.drawString(v, 312, 184, "\x86"..str_create, V_SNAPTOTOP, "right")
						elseif Selected_group != 0
							LC.functions.drawString(v, 312, 184, "\x86"..str_save, V_SNAPTOTOP, "right")
						end
					end
				end
			elseif HUD_perms == true
				local real_height = (v.height() / v.dupx())
				local maxslots = real_height/10 - 6
				if new_data.perms[1] and LC_menu.nav != 0
					if LC_menu.nav < first
						first = $ - 1
					elseif LC_menu.nav > first+maxslots-1
						first = $ + 1
					end
				end
				-- Animate Arrow
				local arrow_y = 0
				if (leveltime % 10) > 5
					arrow_y = 2
				end
				
				-- Arrow Up
				if LC_menu.nav+1 > 0 and first != 1
					v.drawString(318, 50+arrow_y, "\x82"..string.char(26), V_SNAPTOTOP, "right")
				end
				-- Arrow Down
				if LC_menu.nav+1 != LC_menu.lastnav and #new_data.perms > maxslots and first+maxslots-1 < #new_data.perms
					v.drawString(318, 180+arrow_y, "\x82"..string.char(27), V_SNAPTOBOTTOM, "right")
				end
				local y = 20
				for i = first, first+maxslots-1 do
					if not new_data.perms[i] then break end
					if LC_menu.nav == i and add_perms == false
						v.drawString(136, 30+y, tostring("\x82"..new_data.perms[i]), V_SNAPTOTOP, "left")
					else
						v.drawString(136, 30+y, new_data.perms[i], V_SNAPTOTOP, "left")
					end
					y = $ + 10
				end
				local str_add_perm = LC.functions.getStringLanguage("LC_GROUP_ADDPERM")
				if LC_menu.nav == 0 or add_perms == true
					LC.functions.drawString(v, 136, 30, "\x82"..str_add_perm, V_SNAPTOTOP, "left")
				else
					LC.functions.drawString(v, 136, 30, str_add_perm, V_SNAPTOTOP, "left")
				end
				if add_perms == true
					v.drawFill(136, 43, 180, 160, 253|V_SNAPTOTOP)
					local count = #all_perms
					local page = 0
					local lastpage = 0
					local first = 0
					local last = 0
					local x = 20
					local c = 0
					while true do
						if c < count
							c = $ + 13
							if c < count
								lastpage = $ + 1
								if LC_menu.nav >= c-13 and LC_menu.nav < c
									page = lastpage
									last = c
								end
							else
								lastpage = $ + 1
								if LC_menu.nav >= c-13 and LC_menu.nav < c
									page = lastpage
									last = count
								end
								break
							end
						else
							break
						end
					end
					if page == 0 then page = 1 end
					if page == 1
						first = 1
						if count > 13
							last = 13
						else
							last = count
						end
					else
						first = ((page-1)*13)+1
						if count > first+13
							last = first+12
						else
							last = count
						end
					end
					for i = first, last do
						if LC_menu.nav+1 == i
							v.drawString(136, 30+x, (tostring("\x82"..all_perms[i])), V_SNAPTOTOP, "left")
						else
							v.drawString(136, 30+x, (tostring(all_perms[i])), V_SNAPTOTOP, "left")
						end
						x = $ + 10
					end
					v.drawString(136, 190, (tostring("\x82".."PAGE - "..page.."/"..lastpage)), V_SNAPTOTOP, "left")
				end
			end
		end
	end,
	
	funcenter = function()
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		first = 1
		Selected_group = nil
		CanRemove = true
		DoIHavePerm = false
		HUD_perms = false
		add_perms = false
		all_perms = {}
		DoIHavePerm = LC.functions.CheckPerms(player, LC.serverdata.commands["groupeditor"].perm)
		LC_menu.nav = 0
		LC_menu.lastnav = #LC.serverdata.groups.num
	end,
		
	funchook = function(key)
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		if Selected_group == nil
			if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
				if LC_menu.nav == 0 and DoIHavePerm == true
					new_data.displayname = ""
					new_data.color = 0
					new_data.priority = 0
					new_data.admin = 0
					new_data.perms = {}
					Selected_group = LC_menu.nav
					LC_menu.nav = 0
					LC_menu.lastnav = 6
					CanRemove = false
				elseif LC_menu.nav != 0 
					new_data.displayname = LC.serverdata.groups.list[LC.serverdata.groups.num[LC_menu.nav]].displayname
					new_data.color = LC.serverdata.groups.list[LC.serverdata.groups.num[LC_menu.nav]].color
					new_data.priority = LC.serverdata.groups.list[LC.serverdata.groups.num[LC_menu.nav]].priority
					new_data.admin = LC.serverdata.groups.list[LC.serverdata.groups.num[LC_menu.nav]].admin
					new_data.perms = {}
					for p = 1, #LC.serverdata.groups.list[LC.serverdata.groups.num[LC_menu.nav]].perms do
						table.insert(new_data.perms, LC.serverdata.groups.list[LC.serverdata.groups.num[LC_menu.nav]].perms[p])
					end
					Selected_group = LC_menu.nav
					LC_menu.nav = 0
					LC_menu.lastnav = 6
					CanRemove = true
					if LC.serverdata.groups.sets["bot"] == LC.serverdata.groups.num[Selected_group] then CanRemove = false end
					if LC.serverdata.groups.sets["superadmin"] == LC.serverdata.groups.num[Selected_group] then CanRemove = false end
					if LC.serverdata.groups.sets["player"] == LC.serverdata.groups.num[Selected_group] then CanRemove = false end
					if LC.serverdata.groups.sets["unregistered"] == LC.serverdata.groups.num[Selected_group] then CanRemove = false end
				end
			end
		else
			if HUD_perms == false
				if LC_menu.nav == 0
					new_data.displayname = LC.functions.InputText("text", new_data.displayname, key, LC_menu.capslock, LC_menu.shift, 21)
				elseif LC_menu.nav == 1 and DoIHavePerm == true
					local index = 1
					for i = 1, #LC.colormaps do
						if LC.colormaps[i].hex == new_data.color
							index = i
							break
						end
					end
					if LC.functions.GetMenuAction(key.name) == LCMA_NAVLEFT
						if index == 1
							new_data.color = LC.colormaps[#LC.colormaps].hex
						else
							new_data.color = LC.colormaps[index - 1].hex
						end
					elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVRIGHT
						if index == #LC.colormaps
							new_data.color = LC.colormaps[1].hex
						else
							new_data.color = LC.colormaps[index + 1].hex
						end
					end
				elseif LC_menu.nav == 2 and DoIHavePerm == true
					new_data.priority = LC.functions.InputText("count", new_data.priority, key, LC_menu.capslock, LC_menu.shift, 1000, 0)
				elseif LC_menu.nav == 3 and DoIHavePerm == true
					if LC.functions.GetMenuAction(key.name) == LCMA_NAVLEFT or LC.functions.GetMenuAction(key.name) == LCMA_NAVRIGHT
						if new_data.admin == true
							new_data.admin = false
						else
							new_data.admin = true
						end
					end
				elseif LC_menu.nav == 4
					if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
						LC_menu.nav = 0
						LC_menu.lastnav = #new_data.perms
						HUD_perms = true
					end
				elseif LC_menu.nav == 5 and DoIHavePerm == true
					if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
						if CanRemove == true
							local nameID = LC.serverdata.groups.num[Selected_group]
							COM_BufInsertText(consoleplayer, "LC_groupeditor -remove name="..nameID.." -force -silent")
							S_StartSound(nil, sfx_thok, consoleplayer)
							LC_menu.nav = 0
							LC_menu.lastnav = #LC.serverdata.groups.num-1
							Selected_group = nil
						elseif CanRemove == false
							LC.menu.player_state.lognotice = "\x85"..LC.functions.getStringLanguage("LC_ERR_SPGROUP")
							S_StartSound(nil, sfx_s3kb2, player)
						end
					end
				elseif LC_menu.nav == 6 and DoIHavePerm == true
					if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
						local nameID = ""
						if Selected_group == 0
							nameID = new_data.displayname
							nameID = string.gsub(nameID, " ", "")
						elseif Selected_group != 0
							nameID = LC.serverdata.groups.num[Selected_group]
						end
						local color = "white"
						for i = 1, #LC.colormaps do
							if new_data.color == LC.colormaps[i].hex
								color = LC.colormaps[i].name
								break
							end
						end
						local str_perms = ""
						for p = 1, #new_data.perms do
							if p != #new_data.perms
								str_perms = str_perms..new_data.perms[p]..", "
							elseif p == #new_data.perms
								str_perms = str_perms..new_data.perms[p]
							end
						end
						table.insert(LC.localdata.ComInsert, "LC_groupeditor name="..nameID.." \"displayname="..new_data.displayname.."\" color="..color.." priority="..new_data.priority.." admin="..tostring(new_data.admin).." -force -silent")
						if #new_data.perms == 0
							table.insert(LC.localdata.ComInsert, "LC_groupeditor name="..nameID.." \"perms=none\"".." -force -silent")
						elseif #new_data.perms != 0
							for np = 1, #new_data.perms do
								if np == 1
									table.insert(LC.localdata.ComInsert, "LC_groupeditor name="..nameID.." \"perms="..new_data.perms[np].."\"".." -force -silent")
								elseif np != 1
									table.insert(LC.localdata.ComInsert, "LC_groupeditor name="..nameID.." \"addperms="..new_data.perms[np].."\"".." -force -silent")
								end
							end
						end
						S_StartSound(nil, sfx_strpst, consoleplayer)
						if Selected_group == 0
							LC_menu.nav = #LC.serverdata.groups.num+1
							LC_menu.lastnav = #LC.serverdata.groups.num+1
							Selected_group = nil
						elseif Selected_group != 0
							LC_menu.nav = Selected_group
							LC_menu.lastnav = #LC.serverdata.groups.num
							Selected_group = nil
						end
					end
				end
			elseif HUD_perms == true
				if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT and DoIHavePerm == true
					if add_perms == false
						if LC_menu.nav == 0
							add_perms = true
							all_perms = {}
							for a in pairs(LC.serverdata.commands) do
								if LC.serverdata.commands[a].perm and type(LC.serverdata.commands[a].perm) == "string" and LC.serverdata.commands[a].perm != ""
									local IsSet = false
									for b = 1, #new_data.perms do
										if LC.serverdata.commands[a].perm == new_data.perms[b]
											IsSet = true
											break
										end
									end
									if IsSet == false
										table.insert(all_perms, LC.serverdata.commands[a].perm)
									end
								end
							end
							LC_menu.lastnav = #all_perms-1
						else
							table.remove(new_data.perms, LC_menu.nav)
							LC_menu.lastnav = #new_data.perms
							if LC_menu.nav > LC_menu.lastnav
								LC_menu.nav = LC_menu.lastnav
							end
						end
					elseif add_perms == true and all_perms[1] then
						table.insert(new_data.perms, all_perms[LC_menu.nav+1])
						table.remove(all_perms, LC_menu.nav+1)
						LC_menu.lastnav = #all_perms-1
						if LC_menu.nav > LC_menu.lastnav
							LC_menu.nav = LC_menu.lastnav
						end
					end
				end
			end
			if LC.functions.GetMenuAction(key.name) == LCMA_BACK
				LC.menu.player_state.lognotice = nil
				if HUD_perms == false
					LC_menu.nav = Selected_group
					Selected_group = nil
					LC_menu.lastnav = #LC.serverdata.groups.num
				elseif HUD_perms == true
					if add_perms == false
						LC_menu.nav = 4
						LC_menu.lastnav = 6
						HUD_perms = false
					elseif add_perms == true
						first = 1
						LC_menu.nav = 0
						LC_menu.lastnav = #new_data.perms
						add_perms = false
					end
				end
				return true
			end
		end
	end
}

table.insert(LC_Loaderdata["menu"], t)

return true
