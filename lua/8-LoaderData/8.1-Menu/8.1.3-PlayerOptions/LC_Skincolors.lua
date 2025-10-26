local LC = LithiumCore

local selected_slot = 1

local editor = false
local rotation = 0
local rampindex = 0
local rampselect = false
local rampselx = 1
local rampsely = 1
local cantset = nil

local import = false
local select_imp = 0
local filename = ""
local typelist = {"all", "json", "lua", "soc"}
local filetype = 1
local sc_table = nil

local removesyb = {
	"/",
	"\\",
	"*",
	":",
	"\"",
	"?",
	"|",
	"<",
	">"
}

local skincolor_t = {}

for i = 1, 3 do
	local t = {
		name = "New",
		ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		invcolor = SKINCOLOR_WHITE,
		invshade = 1,
		chatcolor = 0,
		exist = false 
	}
	table.insert(skincolor_t, t)
end

local edit_t = {
	name = "",
	ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	invcolor = SKINCOLOR_WHITE,
	invshade = 1,
	chatcolor = 0
}

local importpv_t = {
	name = "",
	ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	invcolor = SKINCOLOR_WHITE,
	invshade = 1,
	chatcolor = 0
}
	
local t = {
	name = "LC_MENU_SKINCOLORS",
	description = "LC_MENU_SKINCOLORS_TIP",
	type = "player",
	funchud = function(v)
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		v.drawScaledNameTag(216*FRACUNIT, 8*FRACUNIT, "Skincolors", V_ALLOWLOWERCASE|V_SNAPTOTOP, FRACUNIT/2, SKINCOLOR_SKY, SKINCOLOR_BLACK)
		if editor == false
			v.drawFill(188, 32, 56, 82, 253|V_SNAPTOTOP)
			local sc_ramp_center = skincolors[SKINCOLOR_LCPV2].ramp
			local scrc_y = 0
			for r = 0, 15 do
				v.drawFill(189, 33+scrc_y, 54, 5, sc_ramp_center[r]|V_SNAPTOTOP)
				scrc_y = $ + 5
			end
			
			v.drawFill(136, 40, 40, 66, 253|V_SNAPTOTOP)
			local sc_ramp_left = skincolors[SKINCOLOR_LCPV1].ramp
			local scrl_y = 0
			for r = 0, 15 do
				v.drawFill(137, 41+scrl_y, 38, 4, sc_ramp_left[r]|V_SNAPTOTOP)
				scrl_y = $ + 4
			end
			
			v.drawFill(256, 40, 40, 66, 253|V_SNAPTOTOP)
			local sc_ramp_right = skincolors[SKINCOLOR_LCPV3].ramp
			local scrr_y = 0
			for r = 0, 15 do
				v.drawFill(257, 41+scrr_y, 38, 4, sc_ramp_right[r]|V_SNAPTOTOP)
				scrr_y = $ + 4
			end
			
			local scalesp = 0
			if skins[player.skin].highresscale != FRACUNIT
				scalesp = (-(FRACUNIT - skins[player.skin].highresscale)/5)*6
			end
			local patch_center = v.getSprite2Patch(player.skin, SPR2_STND, false, 0, 1)
			local scale_center = (FU/patch_center.height) * 64
			
			local patch_side = v.getSprite2Patch(player.skin, SPR2_STND, false, 0, 2)
			local scale_side = (FU/patch_center.height) * 48
			-- left
			v.drawScaled(160*FRACUNIT, (88*FRACUNIT)+70000, scale_side+(scale_center/16), patch_side, V_FLIP|V_SNAPTOTOP, v.getColormap(TC_BLINK, SKINCOLOR_BLACK))
			v.drawScaled(160*FRACUNIT, (88)*FRACUNIT, scale_side, patch_side, V_FLIP|V_SNAPTOTOP, v.getColormap(nil, SKINCOLOR_LCPV1))
			-- center
			v.drawScaled(216*FRACUNIT, (96*FRACUNIT)+80000, scale_center+(scale_center/16), patch_center, V_SNAPTOTOP|V_SUBTRACT, v.getColormap(TC_BLINK, SKINCOLOR_BLACK))
			v.drawScaled(216*FRACUNIT, (96)*FRACUNIT, scale_center, patch_center, V_SNAPTOTOP, v.getColormap(nil, SKINCOLOR_LCPV2))
			-- right
			v.drawScaled(272*FRACUNIT, (88*FRACUNIT)+70000, scale_side+(scale_center/16), patch_side, V_SNAPTOTOP|V_SUBTRACT, v.getColormap(TC_BLINK, SKINCOLOR_BLACK))
			v.drawScaled(272*FRACUNIT, (88)*FRACUNIT, scale_side, patch_side, V_SNAPTOTOP, v.getColormap(nil, SKINCOLOR_LCPV3))
			if LC_menu.nav == 0
				v.drawString(216, 120, "\x82".."< "..skincolor_t[2].name.." >", V_ALLOWLOWERCASE|V_SNAPTOTOP, "center")
			else
				v.drawString(216, 120, skincolor_t[2].name, V_ALLOWLOWERCASE|V_SNAPTOTOP, "center")
			end
			if cantset == true
				LC.functions.drawStringBox(v, 216, 130, LC.functions.getStringLanguage("LC_SC_ERR_TAKEN"), V_SNAPTOTOP, "thin-center", 176)
			--[[
				v.drawString(216, 130, (tostring("\x82".."WARNING\x80: ".."Skincolor exists")), V_SNAPTOTOP, "thin-center")
				v.drawString(216, 138, (tostring("on the server with that name.")), V_SNAPTOTOP, "thin-center")]]
			end
			local str_edit = LC.functions.getStringLanguage("LC_SC_EDIT")
			local str_create = LC.functions.getStringLanguage("LC_SC_NEW")
			local str_export = LC.functions.getStringLanguage("LC_SC_EXPORT")
			local str_delete = LC.functions.getStringLanguage("LC_SC_DELETE")
			if skincolor_t[2].exist == true
				if LC_menu.nav == 1
					LC.functions.drawString(v, 136, 146, "\x82"..str_edit, V_SNAPTOTOP, "left")
				else
					LC.functions.drawString(v, 136, 146, str_edit, V_SNAPTOTOP, "left")
				end
			else
				if LC_menu.nav == 1
					LC.functions.drawString(v, 136, 146, "\x82"..str_create, V_SNAPTOTOP, "left")
				else
					LC.functions.drawString(v, 136, 146, str_create, V_SNAPTOTOP, "left")
				end
			end
			if LC_menu.nav == 2
				if skincolor_t[2].exist == true
					LC.functions.drawString(v, 136, 166, "\x82"..str_export, V_SNAPTOTOP, "left")
				else
					LC.functions.drawString(v, 136, 166, "\x85"..str_export, V_SNAPTOTOP, "left")
				end
			else
				if skincolor_t[2].exist == true
					LC.functions.drawString(v, 136, 166, str_export, V_SNAPTOTOP, "left")
				else
					LC.functions.drawString(v, 136, 166, "\x86"..str_export, V_SNAPTOTOP, "left")
				end
			end
			if LC_menu.nav == 3
				if skincolor_t[2].exist == true
					LC.functions.drawString(v, 136, 176, "\x82"..str_delete, V_SNAPTOTOP, "left")
				else
					LC.functions.drawString(v, 136, 176, "\x85"..str_delete, V_SNAPTOTOP, "left")
				end
			else
				if skincolor_t[2].exist == true
					LC.functions.drawString(v, 136, 176, str_delete, V_SNAPTOTOP, "left")
				else
					LC.functions.drawString(v, 136, 176, "\x86"..str_delete, V_SNAPTOTOP, "left")
				end
			end
		end
		if editor == true
			local scalesp = 0
			if skins[player.skin].highresscale != FRACUNIT
				scalesp = (-(FRACUNIT - skins[player.skin].highresscale)/5)*6
			end
			if (leveltime % 10) == 1
				if rotation == 8
					rotation = 1
				else
					rotation = $ + 1
				end
			end
			local invshade = 17-skincolors[SKINCOLOR_LCPVEDIT].invshade
			local sigh_patch = v.getSprite2Patch(player.skin, SPR2_SIGN, false, 0, 0)
			local sigh_scale = (FU/sigh_patch.width) * 34
			v.drawScaled(160*FRACUNIT, (56)*FRACUNIT, FRACUNIT/2, (v.getSpritePatch(SPR_SIGN, 0, 0)), V_FLIP|V_SNAPTOTOP, v.getColormap(nil, SKINCOLOR_LCPVEDIT))
			v.drawScaled(160*FRACUNIT, (56)*FRACUNIT, FRACUNIT/2, (v.getSpritePatch(SPR_SIGN, (invshade), 0)), V_FLIP|V_SNAPTOTOP, v.getColormap(nil, skincolors[SKINCOLOR_LCPVEDIT].invcolor))
			v.drawScaled(160*FRACUNIT, (42*FRACUNIT)+(sigh_scale/16), sigh_scale, sigh_patch, V_FLIP|V_SNAPTOTOP, v.getColormap(nil, SKINCOLOR_LCPVEDIT))
			if rotation > 5
				v.drawScaled(160*FRACUNIT, (104)*FRACUNIT, (((FRACUNIT+scalesp)*8)/9), (v.getSprite2Patch(player.skin, SPR2_STND, false, 0, rotation)), V_SNAPTOTOP, v.getColormap(nil, SKINCOLOR_LCPVEDIT))
			else
				v.drawScaled(160*FRACUNIT, (104)*FRACUNIT, (((FRACUNIT+scalesp)*8)/9), (v.getSprite2Patch(player.skin, SPR2_STND, false, 0, rotation)), V_FLIP|V_SNAPTOTOP, v.getColormap(nil, SKINCOLOR_LCPVEDIT))
			end
			
			local str_name = LC.functions.getStringLanguage("LC_SC_NAME")
			local str_ramp = LC.functions.getStringLanguage("LC_SC_RAMP")
			local str_invcolor = LC.functions.getStringLanguage("LC_SC_INVCOLOR")
			local str_invshade = LC.functions.getStringLanguage("LC_SC_INVSHADE")
			local str_chatcolor = LC.functions.getStringLanguage("LC_SC_CHATCOLOR")
			local str_import = LC.functions.getStringLanguage("LC_SC_IMPORTFROMFILE")
			local str_save = LC.functions.getStringLanguage("LC_SC_SAVE")
			if LC_menu.nav == 0
				LC.functions.drawString(v, 184, 24, "\x82"..str_name, V_SNAPTOTOP, "left")
			else
				LC.functions.drawString(v, 184, 24, str_name, V_SNAPTOTOP, "left")
			end
			v.drawFill(184, 33, 132, 10, 253|V_SNAPTOTOP)
			if LC_menu.nav == 0 and (leveltime % 4) / 2
				v.drawString(186, 34, edit_t.name.."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
			else
				v.drawString(186, 34, edit_t.name, V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
			end
			
			if LC_menu.nav == 1
				LC.functions.drawString(v, 184, 44, "\x82"..str_ramp, V_SNAPTOTOP, "left")
			else
				LC.functions.drawString(v, 184, 44, str_ramp, V_SNAPTOTOP, "left")
			end
			local y = 0
			v.drawFill(183, 53, 129, 9, 31|V_SNAPTOTOP)
			if LC_menu.nav == 1
				v.drawFill(183-8+(8*rampindex), 53, 9, 9, 72|V_SNAPTOTOP)
			end
			for i = 1, 16 do
				v.drawFill(184+y, 54, 7, 7, edit_t.ramp[i]|V_SNAPTOTOP)
				v.drawString(184+y+4, 56, (tostring(edit_t.ramp[i])), V_SNAPTOTOP, "small-thin-center")
				y = $ + 8
			end
			if LC_menu.nav == 2
				LC.functions.drawString(v, 184, 64, "\x82"..str_invcolor, V_SNAPTOTOP, "left")
				v.drawString(184, 74, (tostring("\x82".."< "..skincolors[edit_t.invcolor].name.." >")), V_SNAPTOTOP, "left")
			else
				LC.functions.drawString(v, 184, 64, str_invcolor, V_SNAPTOTOP, "left")
				v.drawString(184, 74, (tostring(skincolors[edit_t.invcolor].name)), V_SNAPTOTOP, "left")
			end
			
			if LC_menu.nav == 3
				LC.functions.drawString(v, 184, 84, "\x82"..str_invshade, V_SNAPTOTOP, "left")
				v.drawString(184, 94, (tostring("\x82".."< "..edit_t.invshade.." >")), V_SNAPTOTOP, "left")
			else
				LC.functions.drawString(v, 184, 84, str_invshade, V_SNAPTOTOP, "left")
				v.drawString(184, 94, (tostring(edit_t.invshade)), V_SNAPTOTOP, "left")
			end
			local chatcolor = LC.colormaps[1]
			for i = 1, #LC.colormaps do
				if LC.colormaps[i].value == edit_t.chatcolor
					chatcolor = LC.colormaps[i]
					break
				end
			end
			if LC_menu.nav == 4
				LC.functions.drawString(v, 184, 104, "\x82"..str_chatcolor, V_SNAPTOTOP, "left")
				v.drawString(184, 114, (tostring("\x82".."< "..chatcolor.hex..chatcolor.name.."\x82 >")), V_SNAPTOTOP, "left")
			else
				LC.functions.drawString(v, 184, 104, str_chatcolor, V_SNAPTOTOP, "left")
				v.drawString(184, 114, (tostring(chatcolor.hex..chatcolor.name)), V_SNAPTOTOP, "left")
			end
			if LC_menu.nav == 5
				LC.functions.drawString(v, 184, 134, "\x82"..str_import, V_SNAPTOTOP, "left")
			else
				LC.functions.drawString(v, 184, 134, str_import, V_SNAPTOTOP, "left")
			end
			
			local name, reason = LC.functions.CheckName(edit_t.name, true)
			
			if reason
				if reason == "empty text"
					LC.functions.drawStringBox(v, 184, 164, LC.functions.getStringLanguage("LC_SC_ERR_EMPTY"), V_SNAPTOTOP, "thin", 136)
				elseif reason == "space at start"
					LC.functions.drawStringBox(v, 184, 164, LC.functions.getStringLanguage("LC_SC_ERR_SPACE"), V_SNAPTOTOP, "thin", 136)
				elseif reason == "incorrect"
					LC.functions.drawStringBox(v, 184, 164, LC.functions.getStringLanguage("LC_SC_ERR_CHAR"), V_SNAPTOTOP, "thin", 136)
				elseif reason == "out of character"
					LC.functions.drawStringBox(v, 184, 164, LC.functions.getStringLanguage("LC_SC_ERR_MORE32"), V_SNAPTOTOP, "thin", 136)
				end
			elseif cantset == true
				LC.functions.drawStringBox(v, 184, 164, LC.functions.getStringLanguage("LC_SC_ERR_TAKEN"), V_SNAPTOTOP, "thin", 136)
			end
			--[[
			if reason
				if reason == "empty text"
					v.drawString(184, 164, (tostring("\x82".."WARNING\x80: ".."Name should not be")), V_SNAPTOTOP, "thin")
					v.drawString(184, 174, (tostring("an empty string.")), V_SNAPTOTOP, "thin")
				elseif reason == "space at start"
					v.drawString(184, 164, (tostring("\x82".."WARNING\x80: ".."There should not be")), V_SNAPTOTOP, "thin")
					v.drawString(184, 174, (tostring("a space at start of name.")), V_SNAPTOTOP, "thin")
				elseif reason == "incorrect"
					v.drawString(184, 164, (tostring("\x82".."WARNING\x80: ".."Special characters and")), V_SNAPTOTOP, "thin")
					v.drawString(184, 174, (tostring("numbers must not start with them.")), V_SNAPTOTOP, "thin")
				elseif reason == "out of character"
					v.drawString(184, 164, (tostring("\x82".."WARNING\x80: ".."There should be no more")), V_SNAPTOTOP, "thin")
					v.drawString(184, 174, (tostring("than 32 characters in name")), V_SNAPTOTOP, "thin")
				end
			elseif cantset == true
				v.drawString(184, 164, (tostring("\x82".."WARNING\x80: ".."Skincolor exists")), V_SNAPTOTOP, "thin")
				v.drawString(184, 174, (tostring("on the server with that name.")), V_SNAPTOTOP, "thin")
			end
			]]
			
			local exist = false
			for i = 1, #LC.localdata.skincolors.slots do
				if i == selected_slot then continue end
				if LC.localdata.skincolors.slots[i].name:lower() == edit_t.name:lower()
					exist = true
				end
			end
			if not reason and exist == true
				LC.functions.drawStringBox(v, 184, 164, LC.functions.getStringLanguage("LC_SC_ERR_EXIST"), V_SNAPTOTOP, "thin", 136)
				--v.drawString(184, 164, (tostring("\x82".."WARNING\x80: ".."A skincolor with that")), V_SNAPTOTOP, "thin")
				--v.drawString(184, 174, (tostring("name exists on your list.")), V_SNAPTOTOP, "thin")
			end
			
			if LC_menu.nav == 6
				if not reason and exist == false
					LC.functions.drawString(v, 312, 184, "\x82"..str_save, V_SNAPTOTOP, "right")
				else
					LC.functions.drawString(v, 312, 184, "\x85"..str_save, V_SNAPTOTOP, "right")
				end
			else
				if not reason and exist == false
					LC.functions.drawString(v, 312, 184, str_save, V_SNAPTOTOP, "right")
				else
					LC.functions.drawString(v, 312, 184, "\x86"..str_save, V_SNAPTOTOP, "right")
				end
			end
			if rampselect != false
				v.drawFill(183, 62, 129, 129, 31|V_SNAPTOTOP)
				v.drawFill(183+(8*rampselx), 62+(8*rampsely), 9, 9, 72|V_SNAPTOTOP)
				local i = 0
				for y = 1, 16 do
					for x = 1,16 do
						if i == rampselect
							v.drawFill(183-8+(8*x), 62-8+(8*y), 9, 9, 112|V_SNAPTOTOP)
						end
						v.drawFill(184-8+(8*x), 63-8+(8*y), 7, 7, i|V_SNAPTOTOP)
						v.drawString(184-4+(8*x), 63-6+(8*y), (tostring(i)), V_SNAPTOTOP, "small-thin-center")
						i = $ + 1
					end
				end
			end
			if import == true
				v.drawFill(184, 124, 132, 64, 253|V_SNAPTOTOP)
				LC.functions.drawString(v, 185, 126, str_import, V_SNAPTOTOP, "thin")
				if sc_table == nil
					if select_imp == 0
						LC.functions.drawString(v, 185, 134, "\x82"..str_name, V_SNAPTOTOP, "left")
					else
						LC.functions.drawString(v, 185, 134, str_name, V_SNAPTOTOP, "left")
					end
					v.drawFill(185, 143, 130, 10, 31|V_SNAPTOTOP)
					if select_imp == 0 and (leveltime % 4) / 2
						if string.len(filename) > 20
							v.drawString(187, 144, "..."..string.sub(filename, string.len(filename)-20, string.len(filename)).."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
						else
							v.drawString(187, 144, filename.."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
						end
					else
						if string.len(filename) > 20
							v.drawString(187, 144, "..."..string.sub(filename, string.len(filename)-20, string.len(filename)), V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
						else
							v.drawString(187, 144, filename, V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
						end
					end
					
					local str_type = LC.functions.getStringLanguage("LC_SC_TYPE")
					if select_imp == 1
						LC.functions.drawString(v, 187, 154, "\x82"..str_type, V_SNAPTOTOP, "left")
						v.drawString(187, 164, (tostring("\x82".."< "..typelist[filetype].."\x82 >")), V_SNAPTOTOP, "left")
					else
						LC.functions.drawString(v, 187, 154, str_type, V_SNAPTOTOP, "left")
						v.drawString(187, 164, (tostring(typelist[filetype])), V_SNAPTOTOP, "left")
					end
					
					
					local str_ok = LC.functions.getStringLanguage("LC_SC_OK")
					if select_imp == 2
						LC.functions.drawString(v, 312, 174,"\x82"..str_ok, V_SNAPTOTOP, "right")
					else
						LC.functions.drawString(v, 312, 174, str_ok, V_SNAPTOTOP, "right")
					end
				else
					LC.functions.drawString(v, 185, 136, LC.functions.getStringLanguage("LC_SC_SELECTIMPORT"), V_SNAPTOTOP, "thin")
					v.drawString(312, 136, "\x82<\x80 "..(tostring(select_imp).."/"..#sc_table).." \x82>", V_SNAPTOTOP, "thin-right")
					v.drawFill(185, 143, 130, 1, 72|V_SNAPTOTOP)
					v.drawScaled(208*FRACUNIT, (184)*FRACUNIT, FRACUNIT/2, (v.getSpritePatch(SPR_SIGN, (skincolors[SKINCOLOR_LCPVIMPORT].invshade)+2, 0)), V_FLIP|V_SNAPTOTOP, v.getColormap(nil, skincolors[SKINCOLOR_LCPVIMPORT].invcolor))
					v.drawScaled(208*FRACUNIT, FRACUNIT/2+(169)*FRACUNIT, FRACUNIT/2, (v.getSprite2Patch(player.skin, SPR2_SIGN, false, 0, 0)), V_FLIP|V_SNAPTOTOP, v.getColormap(nil, SKINCOLOR_LCPVIMPORT))
					v.drawString(230, 152, (tostring(importpv_t.name)), V_SNAPTOTOP, "thin")
					local chatcolor = LC.colormaps[1]
					for i = 1, #LC.colormaps do
						if LC.colormaps[i].value == importpv_t.chatcolor
							chatcolor = LC.colormaps[i]
							break
						end
					end
					LC.functions.drawString(v, 230, 162, LC.functions.getStringLanguage("LC_SC_CHATCOLOR")..": "..(tostring(chatcolor.hex..chatcolor.name)), V_SNAPTOTOP, "thin")
					local y = 0
					v.drawFill(186, 175, 129, 9, 31|V_SNAPTOTOP)
					for i = 1, 16 do
						v.drawFill(187+y, 176, 7, 7, importpv_t.ramp[i]|V_SNAPTOTOP)
						v.drawString(187+y+4, 178, (tostring(importpv_t.ramp[i])), V_SNAPTOTOP, "small-thin-center")
						y = $ + 8
					end
				end
			end
		end
	end,
	
	funcenter = function()
		local LC_menu = LC.menu.player_state
		local LC_colors = LC.localdata.skincolors.slots
		LC_menu.lastnav = 3
		selected_slot = 1
		editor = false
		rotation = 0
		rampindex = 0
		rampselect = false
		rampselx = 1
		rampsely = 1
		cantset = nil
		skincolor_t[1] = {
			name = "New",
			ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			invcolor = SKINCOLOR_WHITE,
			invshade = 1,
			chatcolor = 0,
			exist = false 
		}
		for i = 1, 2 do
			if LC_colors[i]
				skincolor_t[1+i] = {
					name = LC_colors[i].name,
					ramp = LC.functions.CheckRamp(LC_colors[i].ramp),
					invcolor = LC.functions.CheckInvcolor(LC_colors[i].invcolor),
					invshade = LC.functions.CheckInvshade(LC_colors[i].invshade),
					chatcolor = LC.functions.CheckChatcolor(LC_colors[i].chatcolor),
					exist = true 
				}
			else
				skincolor_t[1+i] = {
					name = "New",
					ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
					invcolor = SKINCOLOR_WHITE,
					invshade = 1,
					chatcolor = 0,
					exist = false 
				}
			end
		end
		
		for i = 1,3 do
			local str = tonumber(i)
			skincolors[_G["SKINCOLOR_LCPV"..str]].ramp = skincolor_t[i].ramp
			skincolors[_G["SKINCOLOR_LCPV"..str]].invcolor = skincolor_t[i].invcolor
			skincolors[_G["SKINCOLOR_LCPV"..str]].invshade = skincolor_t[i].invshade
			skincolors[_G["SKINCOLOR_LCPV"..str]].chatcolor = skincolor_t[i].chatcolor
			skincolors[_G["SKINCOLOR_LCPV"..str]].accessible = false
		end
		
		local cs = false
		local str = tostring(#consoleplayer)
		if string.len(str) == 1
			str = "0"..str
		end
		for i = 1, #skincolors-1 do
			if skincolors[i] == skincolors[_G["SKINCOLOR_LCSEND"..str]]
				continue
			end
			if string.lower(skincolor_t[2].name) == string.lower(skincolors[i].name)
				cs = true
				break
			end
		end
		cantset = cs
	end,
	
	funchook = function(key)
		local LC_menu = LC.menu.player_state
		local LC_colors = LC.localdata.skincolors.slots
		if editor == true
			if rampselect != false
				if LC.functions.GetMenuAction(key.name) == LCMA_NAVLEFT
					if rampselx == 0
						rampselx = 15
					else
						rampselx = $ - 1
					end
				elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVRIGHT
					if rampselx == 15
						rampselx = 0
					else
						rampselx = $ + 1
					end
				elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVUP
					LC_menu.nav = $ + 1
					if rampsely == 0
						rampsely = 15
					else
						rampsely = $ - 1
					end
				elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVDOWN
					LC_menu.nav = $ - 1
					if rampsely == 15
						rampsely = 0
					else
						rampsely = $ + 1
					end
				elseif LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
					rampselect = false
				elseif LC.functions.GetMenuAction(key.name) == LCMA_BACK
					edit_t.ramp[rampindex] = rampselect
					skincolors[SKINCOLOR_LCPVEDIT].ramp[rampindex-1] = rampselect
					rampselect = false
					return true
				end
				edit_t.ramp[rampindex] = rampselx+(16*rampsely)
				skincolors[SKINCOLOR_LCPVEDIT].ramp[rampindex-1] = edit_t.ramp[rampindex]
				return
			end
			if import == true
				if sc_table != nil and #sc_table > 1
					if LC.functions.GetMenuAction(key.name) == LCMA_NAVUP
					or LC.functions.GetMenuAction(key.name) == LCMA_NAVLEFT
						if select_imp == 1
							select_imp = #sc_table
						else
							select_imp = $ - 1
						end
					elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVDOWN
					or LC.functions.GetMenuAction(key.name) == LCMA_NAVRIGHT
						if select_imp == #sc_table
							select_imp = 1
						else
							select_imp = $ + 1
						end
					elseif LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
						edit_t = {
							name = importpv_t.name,
							ramp = importpv_t.ramp,
							invcolor = importpv_t.invcolor,
							invshade = importpv_t.invshade,
							chatcolor = importpv_t.chatcolor
						}
						sc_table = nil
						import = false
						cantset = nil
						skincolors[SKINCOLOR_LCPVEDIT].ramp = edit_t.ramp
						skincolors[SKINCOLOR_LCPVEDIT].invcolor = edit_t.invcolor
						skincolors[SKINCOLOR_LCPVEDIT].invshade = edit_t.invshade
						skincolors[SKINCOLOR_LCPVEDIT].chatcolor = edit_t.chatcolor
						return true
					end
					importpv_t = {
						name = sc_table[select_imp].name,
						ramp = sc_table[select_imp].ramp,
						invcolor = sc_table[select_imp].invcolor,
						invshade = sc_table[select_imp].invshade,
						chatcolor = sc_table[select_imp].chatcolor
					}
					skincolors[SKINCOLOR_LCPVIMPORT].ramp = importpv_t.ramp
					skincolors[SKINCOLOR_LCPVIMPORT].invcolor = importpv_t.invcolor
					skincolors[SKINCOLOR_LCPVIMPORT].invshade = importpv_t.invshade
					skincolors[SKINCOLOR_LCPVIMPORT].chatcolor = importpv_t.chatcolor
				else
					if LC.functions.GetMenuAction(key.name) == LCMA_NAVUP
						if select_imp == 0
							select_imp = 2
						else
							select_imp = $ - 1
						end
					elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVDOWN
						if select_imp == 2
							select_imp = 0
						else
							select_imp = $ + 1
						end
					end
					if select_imp == 0
						filename = LC.functions.InputText("text", filename, key, LC_menu.capslock, LC_menu.shift, 255)
						for i = 1, #removesyb do
							filename = string.gsub(filename, removesyb[i], "")
						end
					elseif select_imp == 1
						if LC.functions.GetMenuAction(key.name) == LCMA_NAVLEFT
							if filetype == 1
								filetype = 4
							else
								filetype = $ - 1
							end
						elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVRIGHT
							if filetype == 4
								filetype = 1
							else
								filetype = $ + 1
							end
						end
					elseif select_imp == 2
						if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
							if filename != ""
								sc_table = LC.functions.ImportSkincolors(filename, typelist[filetype])
								if sc_table and #sc_table == 1
									edit_t.name = sc_table[1].name
									edit_t.ramp = sc_table[1].ramp
									edit_t.invcolor = sc_table[1].invcolor
									edit_t.invshade = sc_table[1].invshade
									edit_t.chatcolor = sc_table[1].chatcolor
									skincolors[SKINCOLOR_LCPVEDIT].ramp = edit_t.ramp
									skincolors[SKINCOLOR_LCPVEDIT].invcolor = edit_t.invcolor
									skincolors[SKINCOLOR_LCPVEDIT].invshade = edit_t.invshade
									skincolors[SKINCOLOR_LCPVEDIT].chatcolor = edit_t.chatcolor
									select_imp = 1
									filetype = 1
									sc_table = nil
									import = false
									cantset = nil
								elseif sc_table and #sc_table > 1
									select_imp = 1
									importpv_t = {
										name = sc_table[select_imp].name,
										ramp = sc_table[select_imp].ramp,
										invcolor = sc_table[select_imp].invcolor,
										invshade = sc_table[select_imp].invshade,
										chatcolor = sc_table[select_imp].chatcolor
									}
									skincolors[SKINCOLOR_LCPVIMPORT].ramp = importpv_t.ramp
									skincolors[SKINCOLOR_LCPVIMPORT].invcolor = importpv_t.invcolor
									skincolors[SKINCOLOR_LCPVIMPORT].invshade = importpv_t.invshade
									skincolors[SKINCOLOR_LCPVIMPORT].chatcolor = importpv_t.chatcolor
								end
							end
						end
					end
				end
				if LC.functions.GetMenuAction(key.name) == LCMA_BACK
					import = false
				end
				return true
			end
			if rampselect == false
			and import == false
				if LC_menu.nav == 0
					edit_t.name = LC.functions.InputText("text", edit_t.name, key, LC_menu.capslock, LC_menu.shift, 21)
					edit_t.name = string.gsub(edit_t.name, " ", "")
				elseif LC_menu.nav == 1
					if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
						rampselect = edit_t.ramp[rampindex]
					elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVLEFT
						if rampindex == 1
							rampindex = 16
						else
							rampindex = $ - 1
						end
					elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVRIGHT
						if rampindex == 16
							rampindex = 1
						else
							rampindex = $ + 1
						end
					end
				elseif LC_menu.nav == 2
					if LC.functions.GetMenuAction(key.name) == LCMA_NAVLEFT
						if edit_t.invcolor == 1
							edit_t.invcolor = 112
						else
							edit_t.invcolor = $ - 1
						end
					elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVRIGHT
						if edit_t.invcolor == 112
							edit_t.invcolor = 1
						else
							edit_t.invcolor = $ + 1
						end
					end
				elseif LC_menu.nav == 3
					if LC.functions.GetMenuAction(key.name) == LCMA_NAVLEFT
						if edit_t.invshade == 0
							edit_t.invshade = 15
						else
							edit_t.invshade = $ - 1
						end
					elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVRIGHT
						if edit_t.invshade == 15
							edit_t.invshade = 0
						else
							edit_t.invshade = $ + 1
						end
					end
				elseif LC_menu.nav == 4
					local index = 1
					for i = 1, #LC.colormaps do
						if LC.colormaps[i].value == edit_t.chatcolor
							index = i
							break
						end
					end
					if LC.functions.GetMenuAction(key.name) == LCMA_NAVLEFT
						if index == 1
							edit_t.chatcolor = LC.colormaps[#LC.colormaps].value
						else
							edit_t.chatcolor = LC.colormaps[index - 1].value
						end
					elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVRIGHT
						if index == #LC.colormaps
							edit_t.chatcolor = LC.colormaps[1].value
						else
							edit_t.chatcolor = LC.colormaps[index + 1].value
						end
					end
				elseif LC_menu.nav == 5
					if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
						select_imp = 0
						filename = ""
						filetype = 1
						sc_table = nil
						import = true
					end
				elseif LC_menu.nav == 6
					if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
					or key.name == "space"
						local name, reason = LC.functions.CheckName(edit_t.name, true)
						local exist = false
						for i = 1, #LC.localdata.skincolors.slots do
							if i == selected_slot then continue end
							if LC.localdata.skincolors.slots[i].name:lower() == edit_t.name:lower()
								exist = true
							end
						end
						if not reason and exist == false
							if skincolor_t[2].exist == true
								LC.localdata.skincolors.slots[selected_slot].name = edit_t.name
								local ramp = {}
								for i = 1, 16 do
									ramp[i] = edit_t.ramp[i]
								end
								LC.localdata.skincolors.slots[selected_slot].ramp = ramp
								LC.localdata.skincolors.slots[selected_slot].invcolor = edit_t.invcolor
								LC.localdata.skincolors.slots[selected_slot].invshade = edit_t.invshade
								LC.localdata.skincolors.slots[selected_slot].chatcolor = edit_t.chatcolor
								print("\x83".."NOTICE\x80"..": Skincolor "..edit_t.name.." has been successfully edited.")
							else
								local new_color = {}
								new_color.name = edit_t.name
								local ramp = {}
								for i = 1, 16 do
									ramp[i] = edit_t.ramp[i]
								end
								new_color.ramp = ramp
								new_color.invcolor = edit_t.invcolor
								new_color.invshade = edit_t.invshade
								new_color.chatcolor = edit_t.chatcolor
								table.insert(LC.localdata.skincolors.slots, new_color)
								print("\x83".."NOTICE\x80"..": Skincolor "..edit_t.name.." has been successfully added.")
							end
							LC_menu.lastnav = 3
							LC_menu.nav = 0
							editor = false
							skincolor_t[2].name = edit_t.name
							skincolor_t[2].exists = true
							skincolors[_G["SKINCOLOR_LCPV2"]].ramp = skincolor_t[2].ramp
							skincolors[_G["SKINCOLOR_LCPV2"]].invcolor = skincolor_t[2].invcolor
							skincolors[_G["SKINCOLOR_LCPV2"]].invshade = skincolor_t[2].invshade
							skincolors[_G["SKINCOLOR_LCPV2"]].chatcolor = skincolor_t[2].chatcolor
							LC.functions.Skincolor(consoleplayer, "save")
							S_StartSound(nil, sfx_strpst, consoleplayer)
						else
							S_StartSound(nil, sfx_s3kb2, consoleplayer)
						end
						key = {
							name = "Dont Set, Bitch!",
							value = 1984,
							repeated = false
						}
					end
				end
				local cs = false
				local str = tostring(#consoleplayer)
				if string.len(str) == 1
					str = "0"..str
				end
				for i = 1, #skincolors-1 do
					if skincolors[i] == skincolors[_G["SKINCOLOR_LCSEND"..str]]
						continue
					end
					if string.lower(edit_t.name) == string.lower(skincolors[i].name)
						cs = true
						break
					end
				end
				cantset = cs
			end
			skincolors[SKINCOLOR_LCPVEDIT].ramp = edit_t.ramp
			skincolors[SKINCOLOR_LCPVEDIT].invcolor = edit_t.invcolor
			skincolors[SKINCOLOR_LCPVEDIT].invshade = edit_t.invshade
			skincolors[SKINCOLOR_LCPVEDIT].chatcolor = edit_t.chatcolor
			if LC.functions.GetMenuAction(key.name) == LCMA_BACK
				editor = false
				LC_menu.lastnav = 3
				LC_menu.nav = 0
				return true
			end
		end
		if editor == false
			if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
				if LC_menu.nav == 0
					if skincolor_t[2].exist == true
						if cantset == false
							COM_BufInsertText(player, "LC_sendcolor load "..selected_slot)
							S_StartSound(nil, sfx_strpst, consoleplayer)
						else
							S_StartSound(nil, sfx_s3kb2, player)
						end
					end
				elseif LC_menu.nav == 1
					if skincolor_t[2].exist == true
						edit_t.name = skincolor_t[2].name
					else
						edit_t.name = ""
					end
					local ramp = {}
					for i = 1, 16 do
						ramp[i] = skincolor_t[2].ramp[i]
					end
					edit_t.ramp = ramp
					edit_t.invcolor = skincolor_t[2].invcolor
					edit_t.invshade = skincolor_t[2].invshade
					edit_t.chatcolor = skincolor_t[2].chatcolor
					skincolors[SKINCOLOR_LCPVEDIT].ramp = edit_t.ramp
					skincolors[SKINCOLOR_LCPVEDIT].invcolor = edit_t.invcolor
					skincolors[SKINCOLOR_LCPVEDIT].invshade = edit_t.invshade
					skincolors[SKINCOLOR_LCPVEDIT].chatcolor = edit_t.chatcolor
					rotation = 0
					rampindex = 1
					LC_menu.lastnav = 6
					LC_menu.nav = 0
					editor = true
					return
				elseif LC_menu.nav == 2
					if skincolor_t[2].exist == true
						COM_BufInsertText(player, "LC_sendcolor export "..selected_slot)
					end
				elseif LC_menu.nav == 3
					if skincolor_t[2].exist == true
						print("\x83".."NOTICE\x80"..": Skincolor "..LC.localdata.skincolors.slots[selected_slot].name.." has been successfully removed.")
						table.remove(LC_colors, selected_slot)
						LC.functions.Skincolor(consoleplayer, "save")
						LC_menu.nav = 0
						selected_slot = #LC_colors+1
						S_StartSound(nil, sfx_thok, consoleplayer)
					end
				end
			end
			if LC.functions.GetMenuAction(key.name) == LCMA_NAVLEFT
				if selected_slot == 1
					selected_slot = #LC_colors+1
				else
					selected_slot = $ - 1
				end
			elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVRIGHT
				if selected_slot == #LC_colors+1
					selected_slot = 1
				else
					selected_slot = $ + 1
				end
			end
			if selected_slot == 1
				skincolor_t[1] = {
					name = "New",
					ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
					invcolor = SKINCOLOR_WHITE,
					invshade = 1,
					chatcolor = 0,
					exist = false 
				}
				for i = 1, 2 do
					if LC_colors[i]
						skincolor_t[1+i] = {
							name = LC_colors[i].name,
							ramp = LC.functions.CheckRamp(LC_colors[i].ramp),
							invcolor = LC.functions.CheckInvcolor(LC_colors[i].invcolor),
							invshade = LC.functions.CheckInvshade(LC_colors[i].invshade),
							chatcolor = LC.functions.CheckChatcolor(LC_colors[i].chatcolor),
						exist = true 
						}
					else
						skincolor_t[1+i] = {
							name = "New",
							ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
							invcolor = SKINCOLOR_WHITE,
							invshade = 1,
							chatcolor = 0,
							exist = false 
						}
					end
				end
			elseif selected_slot == #LC_colors
				skincolor_t[3] = {
					name = "New",
					ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
					invcolor = SKINCOLOR_WHITE,
					invshade = 1,
					chatcolor = 0,
					exist = false 
				}
				for i = 1, 2 do
					if LC_colors[i]
						skincolor_t[i] = {
							name = LC_colors[#LC_colors-2+i].name,
							ramp = LC.functions.CheckRamp(LC_colors[#LC_colors-2+i].ramp),
							invcolor = LC.functions.CheckInvcolor(LC_colors[#LC_colors-2+i].invcolor),
							invshade = LC.functions.CheckInvshade(LC_colors[#LC_colors-2+i].invshade),
							chatcolor = LC.functions.CheckChatcolor(LC_colors[#LC_colors-2+i].chatcolor),
							exist = true 
						}
					else
						skincolor_t[i] = {
							name = "New",
							ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
							invcolor = SKINCOLOR_WHITE,
							invshade = 1,
							chatcolor = 0,
							exist = false 
						}
					end
				end
			elseif selected_slot == #LC_colors+1
				skincolor_t[2] = {
					name = "New",
					ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
					invcolor = SKINCOLOR_WHITE,
					invshade = 1,
					chatcolor = 0,
					exist = false 
				}
				if LC_colors[1]
					skincolor_t[3] = {
						name = LC_colors[1].name,
						ramp = LC.functions.CheckRamp(LC_colors[1].ramp),
						invcolor = LC.functions.CheckInvcolor(LC_colors[1].invcolor),
						invshade = LC.functions.CheckInvshade(LC_colors[1].invshade),
						chatcolor = LC.functions.CheckChatcolor(LC_colors[1].chatcolor),
						exist = true 
					}
				else
					skincolor_t[3] = {
						name = "New",
						ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
						invcolor = SKINCOLOR_WHITE,
						invshade = 1,
						chatcolor = 0,
						exist = false 
					}
				end
				if LC_colors[#LC_colors]
					skincolor_t[1] = {
						name = LC_colors[#LC_colors].name,
						ramp = LC.functions.CheckRamp(LC_colors[#LC_colors].ramp),
						invcolor = LC.functions.CheckInvcolor(LC_colors[#LC_colors].invcolor),
						invshade = LC.functions.CheckInvshade(LC_colors[#LC_colors].invshade),
						chatcolor = LC.functions.CheckChatcolor(LC_colors[#LC_colors].chatcolor),
						exist = true 
					}
				else
					skincolor_t[1] = {
						name = "New",
						ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
						invcolor = SKINCOLOR_WHITE,
						invshade = 1,
						chatcolor = 0,
						exist = false 
					}
				end
			else
				for i = 1,3 do
					local sc = selected_slot-2+i
					if LC_colors[sc]
						skincolor_t[i] = {
							name = LC_colors[sc].name,
							ramp = LC.functions.CheckRamp(LC_colors[sc].ramp),
							invcolor = LC.functions.CheckInvcolor(LC_colors[sc].invcolor),
							invshade = LC.functions.CheckInvshade(LC_colors[sc].invshade),
							chatcolor = LC.functions.CheckChatcolor(LC_colors[sc].chatcolor),
							exist = true 
						}
					else
						skincolor_t[i] = {
							name = "New",
							ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
							invcolor = SKINCOLOR_WHITE,
							invshade = 1,
							chatcolor = 0,
							exist = false 
						}
					end
				end
			end
			local cs = false
			local str = tostring(#consoleplayer)
			if string.len(str) == 1
				str = "0"..str
			end
			for i = 1, #skincolors-1 do
				if skincolors[i] == skincolors[_G["SKINCOLOR_LCSEND"..str]]
					continue
				end
				if string.lower(skincolor_t[2].name) == string.lower(skincolors[i].name)
					cs = true
					break
				end
			end
			cantset = cs
		end
		for i = 1,3 do
			local str = tonumber(i)
			skincolors[_G["SKINCOLOR_LCPV"..str]].ramp = skincolor_t[i].ramp
			skincolors[_G["SKINCOLOR_LCPV"..str]].invcolor = skincolor_t[i].invcolor
			skincolors[_G["SKINCOLOR_LCPV"..str]].invshade = skincolor_t[i].invshade
			skincolors[_G["SKINCOLOR_LCPV"..str]].chatcolor = skincolor_t[i].chatcolor
		end
	end
}

table.insert(LC_Loaderdata["menu"], t)

return true
