local LC = LithiumCore

local anim_ico = {
	{name = "LITHIUMCORE_ICONHD_01", tics = 4},
	{name = "LITHIUMCORE_ICONHD_02", tics = 4},
	{name = "LITHIUMCORE_ICONHD_03", tics = 4},
	{name = "LITHIUMCORE_ICONHD_04", tics = 4},
	{name = "LITHIUMCORE_ICONHD_05", tics = 4},
	{name = "LITHIUMCORE_ICONHD_06", tics = 75},
}

local borders = {
	top = 0,
	bottom = 0
}

local nav_cat = {
	options = 1,
	admin = 1,
	players = 1,
	playerscom = 1,
	misc = 1
}

local particles = {}
local glitchs = {}
local glitchs_fade = 0
local muslag = 0

local g_states = {
	{gray = V_90TRANS, neg = false, time = 3},
	
	{gray = V_80TRANS, neg = false, time = 3},
	
	{gray = V_70TRANS, neg = false, time = 3},
	
	{gray = V_60TRANS, neg = false, time = 3},
	
	{gray = V_50TRANS, neg = false, time = 3},
	
	{gray = V_40TRANS, neg = false, time = 3},
	
	{gray = V_30TRANS, neg = false, time = 3},
	
	{gray = V_20TRANS, neg = false, time = 3},
	
	{gray = V_10TRANS, neg = false, time = 3},
	
	{gray = 0, neg = false, time = 15},
	
	{gray = V_10TRANS, neg = true, time = 3},
	
	{gray = V_20TRANS, neg = true, time = 3},
	
	{gray = V_30TRANS, neg = true, time = 3},
	
	{gray = V_40TRANS, neg = true, time = 3},
	
	{gray = V_50TRANS, neg = true, time = 3},
	
	{gray = V_60TRANS, neg = true, time = 3},
	
	{gray = V_70TRANS, neg = true, time = 3},
	
	{gray = V_80TRANS, neg = true, time = 3},
	
	{gray = V_90TRANS, neg = true, time = 3},
	
	{gray = false, neg = true, time = 3}
}

local g_state = {
	enabled = false,
	time = 0,
	state = 1,
	change = 3,
	color = 0
}

//local negflag = {change = 0, flag = 0}

local CV_Showhud = CV_FindVar("showhud")

local ai_state = {state = 1, tics = 30}

local hud_itally = true
local hud_imsg = true
local hud_iemeralds = true
local hud_textspectator = true

local GetPlavSpeed = function()
	local panelx = LC.menu.animation.panelx
	local speed = 8
	if panelx < -152 or panelx > -16
		speed = 2
	elseif panelx < -136 or panelx > -32
		speed = 4
	elseif panelx < -120 or panelx > -48
		speed = 6
	elseif panelx < -104 or panelx > -64
		speed = 8
	end
	return speed
end

local Fade_change = 0

local evil_lithiumcore = nil

local hooktable = {
	name = "LC.Menu",
	type = "HUD",
	typehud = {"game", "intermission"},
	toggle = true,
	priority = 800,
	TimeMicros = 0,
	func = function(v, player, camera)
		local player = consoleplayer
		if LC.menu.player_state
			if evil_lithiumcore == nil
				evil_lithiumcore = v.RandomChance(500)
			end
			
			if hud.enabled("intermissiontally")
				hud_itally = true
				hud.disable("intermissiontally")
			end
			if hud.enabled("intermissionmessages")
				hud_imsg = true
				hud.disable("intermissionmessages")
			end
			if hud.enabled("intermissionemeralds")
				hud_iemeralds = true
				hud.disable("intermissionemeralds")
			end
			if hud.enabled("textspectator")
				hud_textspectator = true
				hud.disable("textspectator")
			end
			
			local LC_menu = LC.menu.player_state
			local anim = LC.menu.animation
			if anim.opening == true
				if Fade_change == 1
					if anim.fade != 16
						anim.fade = $ + 1
					end
					Fade_change = 0
				elseif Fade_change != 1
					Fade_change = $ + 1
				end
				if anim.panelx != 0
					anim.panelx = $ + GetPlavSpeed()
				else
					anim.opening = false
				end
			end
			if anim.closing == true
				if Fade_change == 1
					if anim.fade != 0
						anim.fade = $ - 1
					end
					Fade_change = 0
				elseif Fade_change != 1
					Fade_change = $ + 1
				end
				if anim.panelx != -168
					anim.panelx = $ - GetPlavSpeed()
				else
					anim = nil
					evil_lithiumcore = nil
					LC.menu.player_state = nil
					particles = {}
					
					if LC.menu.HUD_enaled == false
						CV_Set(CV_Showhud, 0)
					end
					
					if not hud.enabled("intermissiontally")
					and hud_itally == true
						hud.enable("intermissiontally")
					end
					if not hud.enabled("intermissionmessages")
					and hud_imsg == true
						hud.enable("intermissionmessages")
					end
					if not hud.enabled("intermissionemeralds")
					and hud_iemeralds == true
						hud.enable("intermissionemeralds")
					end
					if not hud.enabled("textspectator")
					and hud_textspectator == true
						hud.enable("textspectator")
					end
					
					return
				end
			end
			
			local HKT = LC.localdata.pressed_keys
			local shift = false
			for i in ipairs(HKT) do
				if HKT[i].name == "lshift" or HKT[i].name == "rshift"
					shift = true
					break
				end
			end
			LC.menu.player_state.shift = shift
			
			local real_height = (v.height() / v.dupx())
			local real_width = (v.width() / v.dupy())
			
			v.fadeScreen(0xFF00, anim.fade)
			
			-- Special events
			
			local time = os.date("!*t")
			
			if time.month == 1 or time.month == 2 or time.month == 12
				local CreateParticle = v.RandomChance(FU/8)
				
				if CreateParticle == true
				
					local RandomFrame = v.RandomRange(A, C)
					local Random_X = v.RandomRange(0, 120)
					local Random_Speed = v.RandomRange(FU/2, FU)
					local Random_scale = v.RandomRange(FU/4, FU/2)
					
					local New_Particle = {
						patch = v.getSpritePatch(SPR_SNO1, RandomFrame, 0),
						x = Random_X*FU,
						y = -64,
						speed = Random_Speed,
						scale = Random_scale,
						transflag = 0,
						changeflag = 0
					}
					
					table.insert(particles, New_Particle)
					
				end
			elseif time.month == 3 or time.month == 4 or time.month == 5
				local CreateParticle = v.RandomChance(FU)
				
				if CreateParticle == true
				
					local Random_X = v.RandomRange(0, 120)
					local Random_Speed = v.RandomRange(FU*16, FU*32)
					
					local New_Particle = {
						patch = v.getSpritePatch(SPR_RAIN, A, 0),
						x = Random_X*FU,
						y = -64,
						speed = Random_Speed,
						scale = FU/3,
						transflag = V_70TRANS,
						changeflag = 0
					}
					
					table.insert(particles, New_Particle)
					
				end
			elseif time.month == 9 or time.month == 10 or time.month == 11
				local CreateParticle = v.RandomChance(FU/8)
				
				if CreateParticle == true
				
					local RandomFrame = v.RandomRange(A, C)
					local Random_X = v.RandomRange(0, 120)
					local Random_Speed = v.RandomRange(FU/4, FU/2)
					local Random_scale = v.RandomRange(FU/4, FU/2)
					
					local New_Particle = {
						patch = v.getSpritePatch(SPR_LEA2, RandomFrame, 0),
						x = Random_X*FU,
						y = -64,
						speed = Random_Speed,
						scale = Random_scale,
						transflag = 0,
						changeflag = 0
					}
					
					table.insert(particles, New_Particle)
					
				end
			end
			
			
			for i = #particles, 1, -1 do
			
				local ps = particles[i]
				
				v.drawScaled(anim.panelx*FU + ps.x, ps.y, ps.scale, ps.patch, V_SNAPTOTOP|V_SNAPTOLEFT|ps.transflag)
				
				ps.y = $ + ps.speed
				ps.speed = $ + 64
				
				if ps.y/FU > real_height-16
					if ps.changeflag == 1
						ps.changeflag = 0
						if ps.transflag == 0
							ps.transflag = V_10TRANS
						elseif ps.transflag == V_10TRANS
							ps.transflag = V_20TRANS
						elseif ps.transflag == V_20TRANS
							ps.transflag = V_30TRANS
						elseif ps.transflag == V_30TRANS
							ps.transflag = V_40TRANS
						elseif ps.transflag == V_40TRANS
							ps.transflag = V_50TRANS
						elseif ps.transflag == V_50TRANS
							ps.transflag = V_60TRANS
						elseif ps.transflag == V_60TRANS
							ps.transflag = V_70TRANS
						elseif ps.transflag == V_70TRANS
							ps.transflag = V_80TRANS
						elseif ps.transflag == V_80TRANS
							ps.transflag = V_90TRANS
						elseif ps.transflag == V_90TRANS
							table.remove(particles, i)
						end
					elseif ps.changeflag != 1
						ps.changeflag = 1
					end
				end
				
			end
			
			if LC.menu.lastkeys:find("evil") then evil_lithiumcore = true LC.menu.lastkeys = "" end
			
			local colors
			if evil_lithiumcore == false
				colors = {
					fill = 253,
					text = SKINCOLOR_SKY,
					colorpatch = nil,
					sel_map = V_YELLOWMAP,
					tips_fill = 157
				}
			elseif evil_lithiumcore == true
				colors = {
					fill = 47,
					text = SKINCOLOR_CRIMSON,
					colorpatch = v.getColormap(TC_RAINBOW, SKINCOLOR_RED),
					sel_map = V_INVERTMAP,
					tips_fill = 40
				}
			end
			
			if SUBVERSION > 13
				v.drawFill(anim.panelx, 0, 128, 2048, colors.fill|V_SNAPTOTOP|V_SNAPTOLEFT|V_20TRANS)
			else
				local bg_patch = v.cachePatch("~253")
				local bg_x = anim.panelx*FU
				
				local scale_x = (FU/bg_patch.width) * 128
				local scale_y = (FU/bg_patch.height) * (real_height+64)
				
				v.drawCropped(bg_x ,-12*FU, scale_x, scale_y, bg_patch, V_SNAPTOTOP|V_SNAPTOLEFT|V_20TRANS, nil, 0, 0, (bg_patch.width*FU), bg_patch.height*FU)
			end
			
			-- Top Border
			local top_x = (anim.panelx -32)*FRACUNIT + borders.top
			local top_patch = v.cachePatch("NTSATKT2")
			v.drawCropped(top_x,-12*FU, FU/2, FU/2, top_patch, V_SNAPTOTOP|V_SNAPTOLEFT, colors.colorpatch, 0, 0, (top_patch.width*FU)-(borders.top*2), top_patch.height*FU)
			if borders.top >= (32*FU)/2
				borders.top = 0
			else
				borders.top = $ + FU/4
			end
			-- Bottom Border
			local bottom_x = (anim.panelx)*FRACUNIT - borders.bottom
			local bottom_patch = v.cachePatch("NTSATKB2")
			v.drawCropped(bottom_x, 190*FU, FU/2, FU/2, bottom_patch, V_SNAPTOBOTTOM|V_SNAPTOLEFT, colors.colorpatch, 0, 0, bottom_patch.width*FU - (64*FU-(borders.bottom*2)), bottom_patch.height*FU)
			if borders.bottom >= (32*FU)/2
				borders.bottom = 0
			else
				borders.bottom = $ + FU/4
			end
			
			local patchicon = v.cachePatch(anim_ico[ai_state.state].name)
			if ai_state.tics != 0
				ai_state.tics = $ - 1
			elseif ai_state.tics == 0
				if ai_state.state != #anim_ico
					ai_state.state = $ + 1
				elseif ai_state.state == #anim_ico
					ai_state.state = 1
				end
				ai_state.tics = anim_ico[ai_state.state].tics
			end
			v.drawScaled( (anim.panelx + 4)*FRACUNIT, 4*FU, FU/4, patchicon, V_SNAPTOTOP|V_SNAPTOLEFT, colors.colorpatch)
			v.drawScaledNameTag((anim.panelx*FRACUNIT)+76*FRACUNIT, 16*FRACUNIT, "Lithium Core", V_ALLOWLOWERCASE|V_SNAPTOTOP|V_SNAPTOLEFT, 35000, colors.text, SKINCOLOR_BLACK)
			v.drawString(anim.panelx+124, 26, "V"..LC.functions.GetVersion().string, V_MODULATE|V_SNAPTOLEFT|V_SNAPTOTOP, "small-right")
			if anim.closing == false and anim.opening == false
				if LC_menu.category == "account" or (LC_menu.category == "main" and LC_menu.nav == 0)
					if not player.stuffname and not LC_menu.subcategory 
						v.drawScaledNameTag(216*FRACUNIT, 8*FRACUNIT, "ACCOUNT", V_ALLOWLOWERCASE|V_SNAPTOTOP, FRACUNIT/2, SKINCOLOR_SKY, SKINCOLOR_BLACK)
						local signin = LC.functions.getStringLanguage("LC_MENU_SIGNIN")
						local signup = LC.functions.getStringLanguage("LC_MENU_SIGNUP")
						if LC_menu.category == "account" and LC_menu.nav == 0
							LC.functions.drawString(v, 136, 30, signin, V_SNAPTOTOP|colors.sel_map, "left", 178)
							--v.drawString(136, 30, "LOGIN", V_SNAPTOTOP|colors.sel_map, "left")
						else
							LC.functions.drawString(v, 136, 30, signin, V_SNAPTOTOP, "left", 178)
							--v.drawString(136, 30, "LOGIN", V_SNAPTOTOP, "left")
						end
						if LC_menu.category == "account" and LC_menu.nav == 1
							LC.functions.drawString(v, 136, 40, signup, V_SNAPTOTOP|colors.sel_map, "left", 178)
							--v.drawString(136, 40, "CREATE ACCOUNT", V_SNAPTOTOP|colors.sel_map, "left")
						else
							LC.functions.drawString(v, 136, 40, signup, V_SNAPTOTOP, "left", 178)
							--v.drawString(136, 40, "CREATE ACCOUNT", V_SNAPTOTOP, "left")
						end
					end
				end
				if LC_menu.category == "account" and LC_menu.subcategory == "login"
					v.drawScaledNameTag(216*FRACUNIT, 8*FRACUNIT, "LOGIN", V_ALLOWLOWERCASE|V_SNAPTOTOP, FRACUNIT/2, SKINCOLOR_SKY, SKINCOLOR_BLACK)
					local username = LC.functions.getStringLanguage("LC_MENU_USERNAME")
					local password = LC.functions.getStringLanguage("LC_MENU_PASSWORD")
					if LC_menu.nav == 0
						LC.functions.drawString(v, 136, 30, username, V_SNAPTOTOP|colors.sel_map, "left")
					else
						LC.functions.drawString(v, 136, 30, username, V_SNAPTOTOP, "left")
					end
					v.drawFill(136, 39, 180, 10, 253|V_SNAPTOTOP)
					if LC_menu.nav == 0 and (leveltime % 4) / 2
						if string.len(LC_menu.user) <= 32
							v.drawString(138, 40, LC_menu.user.."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
						else
							v.drawString(138, 40, "..."..string.sub(LC_menu.user, string.len(LC_menu.user)-32, string.len(LC_menu.user)).."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
						end
					else
						if string.len(LC_menu.user) <= 32
							v.drawString(138, 40, LC_menu.user, V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
						else
							v.drawString(138, 40, "..."..string.sub(LC_menu.user, string.len(LC_menu.user)-32, string.len(LC_menu.user)), V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
						end	
					end
					if LC_menu.nav == 1
						LC.functions.drawString(v, 136, 50, password, V_SNAPTOTOP|colors.sel_map, "left")
					else
						LC.functions.drawString(v, 136, 50, password, V_SNAPTOTOP, "left")
					end
					v.drawFill(136, 59, 180, 10, 253|V_SNAPTOTOP)
					local viewpass
					if LC_menu.showpass == true
						viewpass = LC_menu.pass
					else
						viewpass = string.gsub(LC_menu.pass, ".", "*")
					end
					if LC_menu.nav == 1 and (leveltime % 4) / 2
						if string.len(viewpass) <= 32
							v.drawString(138, 60, viewpass.."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
						else
							v.drawString(138, 60, "..."..string.sub(viewpass, string.len(viewpass)-32, string.len(viewpass)).."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
						end
					else
						if string.len(viewpass) <= 32
							v.drawString(138, 60, viewpass, V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
						else
							v.drawString(138, 60, "..."..string.sub(viewpass, string.len(viewpass)-32, string.len(viewpass)), V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
						end	
					end
					local showpass = LC.functions.getStringLanguage("LC_MENU_SHOWPASS")
					if LC_menu.showpass == true
						LC.functions.drawString(v, 136, 80, showpass..": ON", V_SNAPTOTOP, "thin")
					else
						LC.functions.drawString(v, 136, 80, showpass..": OFF", V_SNAPTOTOP, "thin")
					end
					local capslock = LC.functions.getStringLanguage("LC_MENU_CAPSLOCK")
					if LC_menu.capslock == true
						LC.functions.drawString(v, 136, 88, capslock..": ON", V_SNAPTOTOP, "thin")
					else
						LC.functions.drawString(v, 136, 88, capslock..": OFF", V_SNAPTOTOP, "thin")
					end
					local signin = LC.functions.getStringLanguage("LC_MENU_SIGNIN")
					if LC_menu.nav == 2
						LC.functions.drawString(v, 312, 120, signin, V_SNAPTOTOP|colors.sel_map, "right")
					else
						LC.functions.drawString(v, 312, 120, signin, V_SNAPTOTOP, "right")
					end
					if LC_menu.lognotice
						if type(LC_menu.lognotice) == "string"
							LC.functions.drawString(v, 136, 72, LC_menu.lognotice, V_SNAPTOTOP, "thin")
						end
					end
				elseif LC_menu.category == "account" and LC_menu.subcategory == "register"
					local username = LC.functions.getStringLanguage("LC_MENU_USERNAME")
					local password = LC.functions.getStringLanguage("LC_MENU_PASSWORD")
					v.drawScaledNameTag(216*FRACUNIT, 8*FRACUNIT, "CREATE ACCOUNT", V_ALLOWLOWERCASE|V_SNAPTOTOP, FRACUNIT/2, SKINCOLOR_SKY, SKINCOLOR_BLACK)
					if LC_menu.nav == 0
						LC.functions.drawString(v, 136, 30, username, V_SNAPTOTOP|colors.sel_map, "left")
					else
						LC.functions.drawString(v, 136, 30, username, V_SNAPTOTOP, "left")
					end
					v.drawFill(136, 39, 180, 10, 253|V_SNAPTOTOP)
					if LC_menu.nav == 0 and (leveltime % 4) / 2
						if string.len(LC_menu.user) <= 32
							v.drawString(138, 40, LC_menu.user.."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
						else
							v.drawString(138, 40, "..."..string.sub(LC_menu.user, string.len(LC_menu.user)-32, string.len(LC_menu.user)).."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
						end
					else
						if string.len(LC_menu.user) <= 32
							v.drawString(138, 40, LC_menu.user, V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
						else
							v.drawString(138, 40, "..."..string.sub(LC_menu.user, string.len(LC_menu.user)-32, string.len(LC_menu.user)), V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
						end	
					end
					if LC_menu.nav == 1
						LC.functions.drawString(v, 136, 50, password, V_SNAPTOTOP|colors.sel_map, "left")
					else
						LC.functions.drawString(v, 136, 50, password, V_SNAPTOTOP, "left")
					end
					v.drawFill(136, 59, 180, 10, 253|V_SNAPTOTOP)
					local viewpass
					if LC_menu.showpass == true
						viewpass = LC_menu.pass
					else
						viewpass = string.gsub(LC_menu.pass, ".", "*")
					end
					if LC_menu.nav == 1 and (leveltime % 4) / 2
						if string.len(viewpass) <= 32
							v.drawString(138, 60, viewpass.."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
						else
							v.drawString(138, 60, "..."..string.sub(viewpass, string.len(viewpass)-32, string.len(viewpass)).."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
						end
					else
						if string.len(viewpass) <= 32
							v.drawString(138, 60, viewpass, V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
						else
							v.drawString(138, 60, "..."..string.sub(viewpass, string.len(viewpass)-32, string.len(viewpass)), V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
						end	
					end
					local showpass = LC.functions.getStringLanguage("LC_MENU_SHOWPASS")
					if LC_menu.showpass == true
						LC.functions.drawString(v, 136, 90, showpass..": ON", V_SNAPTOTOP, "thin")
					else
						LC.functions.drawString(v, 136, 90, showpass..":OFF", V_SNAPTOTOP, "thin")
					end
					local capslock = LC.functions.getStringLanguage("LC_MENU_CAPSLOCK")
					if LC_menu.capslock == true
						LC.functions.drawString(v, 136, 98, capslock..": ON", V_SNAPTOTOP, "thin")
					else
						LC.functions.drawString(v, 136, 98, capslock..": OFF", V_SNAPTOTOP, "thin")
					end
					local generate = LC.functions.getStringLanguage("LC_MENU_GENEPASS")
					if LC_menu.nav == 2
						LC.functions.drawString(v, 136, 70, generate, V_SNAPTOTOP|colors.sel_map, "left")
					else
						LC.functions.drawString(v, 136, 70, generate, V_SNAPTOTOP, "left")
					end
					
					local signup = LC.functions.getStringLanguage("LC_MENU_SIGNUP")
					if LC_menu.nav == 3
						LC.functions.drawString(v, 312, 120, signup, V_SNAPTOTOP|colors.sel_map, "right")
					else
						LC.functions.drawString(v, 312, 120, signup, V_SNAPTOTOP, "right")
					end
					if LC_menu.lognotice
						if type(LC_menu.lognotice) == "string"
							LC.functions.drawString(v, 136, 82, LC_menu.lognotice, V_SNAPTOTOP, "thin")
						end
					end
				end
				if LC_menu.category == "account" or (LC_menu.category == "main" and LC_menu.nav == 0)
					if LC_menu.subcategory == nil
					and consoleplayer.stuffname
						v.drawScaledNameTag(216*FRACUNIT, 8*FRACUNIT, "Account", V_ALLOWLOWERCASE|V_SNAPTOTOP, FRACUNIT/2, SKINCOLOR_SKY, SKINCOLOR_BLACK)
						local real_height = (v.height() / v.dupx())
						local maxslots = real_height/10 - 4
						if LC.menu.subcat.account[1]
							if LC_menu.nav+1 < nav_cat.options
								nav_cat.options = $ - 1
							elseif LC_menu.nav+1 > nav_cat.options+maxslots-1
								nav_cat.options = $ + 1
							end
						end
						-- Animate Arrow
						local arrow_y = 0
						if (leveltime % 10) > 5
							arrow_y = 2
						end
						
						-- Arrow Up
						if LC_menu.nav+1 > 0 and nav_cat.options != 1
							v.drawString(318, 32+arrow_y, string.char(26), V_SNAPTOTOP|colors.sel_map, "right")
						end
						-- Arrow Down
						if LC_menu.nav+1 != LC_menu.lastnav and #LC.menu.subcat.account > maxslots and nav_cat.options+maxslots-1 < #LC.menu.subcat.account
							v.drawString(318, 180+arrow_y, string.char(27), V_SNAPTOBOTTOM|colors.sel_map, "right")
						end
						local y = 0
						for i = nav_cat.options, nav_cat.options+maxslots-1 do
							if LC.menu.subcat.account and LC.menu.subcat.account[i] and LC.menu.subcat.account[i].name
								local LANG_NAME = LC.functions.getStringLanguage(LC.menu.subcat.account[i].name)
								if LC_menu.nav == i-1 and LC_menu.category != "main"
									LC.functions.drawString(v, 136, 30+y, LANG_NAME, V_SNAPTOTOP|colors.sel_map, "left", 178)
									if LC.menu.subcat.account[i].description
										local LANG_DESC = LC.functions.getStringLanguage(LC.menu.subcat.account[i].description)
										LC_menu.tip = LANG_DESC
									else
										LC_menu.tip = ""
									end
								else
									LC.functions.drawString(v, 136, 30+y, LANG_NAME, V_SNAPTOTOP, "left", 178)
								end
								y = $ + 10
							end
						end
					else
						for m = 1, #LC.menu.subcat.account do
							if LC.menu.subcat.account[m].name == LC_menu.subcategory
								LC.menu.subcat.account[m].funchud(v)
							end
						end
					end
				elseif LC_menu.category == "options" or (LC_menu.category == "main" and LC_menu.nav == 1)
					if LC_menu.subcategory == nil
						v.drawScaledNameTag(216*FRACUNIT, 8*FRACUNIT, "Options", V_ALLOWLOWERCASE|V_SNAPTOTOP, FRACUNIT/2, SKINCOLOR_SKY, SKINCOLOR_BLACK)
						local real_height = (v.height() / v.dupx())
						local maxslots = real_height/10 - 4
						if LC.menu.subcat.player[1]
							if LC_menu.nav+1 < nav_cat.options
								nav_cat.options = $ - 1
							elseif LC_menu.nav+1 > nav_cat.options+maxslots-1
								nav_cat.options = $ + 1
							end
						end
						-- Animate Arrow
						local arrow_y = 0
						if (leveltime % 10) > 5
							arrow_y = 2
						end
						
						-- Arrow Up
						if LC_menu.nav+1 > 0 and nav_cat.options != 1
							v.drawString(318, 32+arrow_y, string.char(26), V_SNAPTOTOP|colors.sel_map, "right")
						end
						-- Arrow Down
						if LC_menu.nav+1 != LC_menu.lastnav and #LC.menu.subcat.player > maxslots and nav_cat.options+maxslots-1 < #LC.menu.subcat.player
							v.drawString(318, 180+arrow_y, string.char(27), V_SNAPTOBOTTOM|colors.sel_map, "right")
						end
						local y = 0
						for i = nav_cat.options, nav_cat.options+maxslots-1 do
							if LC.menu.subcat.player and LC.menu.subcat.player[i] and LC.menu.subcat.player[i].name
								local LANG_NAME = LC.functions.getStringLanguage(LC.menu.subcat.player[i].name)
								if LC_menu.nav == i-1 and LC_menu.category != "main"
									LC.functions.drawString(v, 136, 30+y, LANG_NAME, V_SNAPTOTOP|colors.sel_map, "left", 178)
									if LC.menu.subcat.player[i].description
										local LANG_DESC = LC.functions.getStringLanguage(LC.menu.subcat.player[i].description)
										LC_menu.tip = LANG_DESC
									else
										LC_menu.tip = ""
									end
								else
									LC.functions.drawString(v, 136, 30+y, LANG_NAME, V_SNAPTOTOP, "left", 178)
								end
								y = $ + 10
							end
						end
					else
						for m = 1, #LC.menu.subcat.player do
							if LC.menu.subcat.player[m].name == LC_menu.subcategory
								LC.menu.subcat.player[m].funchud(v)
							end
						end
					end
				elseif LC_menu.category == "panel" or (LC_menu.category == "main" and LC_menu.nav == 2)
					if LC_menu.subcategory == nil
						v.drawScaledNameTag(216*FRACUNIT, 8*FRACUNIT, "Admin Panel", V_ALLOWLOWERCASE|V_SNAPTOTOP, FRACUNIT/2, SKINCOLOR_SKY, SKINCOLOR_BLACK)
						local real_height = (v.height() / v.dupx())
						local maxslots = real_height/10 - 4
						if LC.menu.subcat.player[1]
							if LC_menu.nav+1 < nav_cat.admin
								nav_cat.admin = $ - 1
							elseif LC_menu.nav+1 > nav_cat.admin+maxslots-1
								nav_cat.admin = $ + 1
							end
						end
						-- Animate Arrow
						local arrow_y = 0
						if (leveltime % 10) > 5
							arrow_y = 2
						end
						
						-- Arrow Up
						if LC_menu.nav+1 > 0 and nav_cat.admin != 1
							v.drawString(318, 32+arrow_y, string.char(26), V_SNAPTOTOP|colors.sel_map, "right")
						end
						-- Arrow Down
						if LC_menu.nav+1 != LC_menu.lastnav and #LC.menu.subcat.admin > maxslots and nav_cat.admin+maxslots-1 < #LC.menu.subcat.admin
							v.drawString(318, 180+arrow_y, string.char(27), V_SNAPTOBOTTOM|colors.sel_map, "right")
						end
						local y = 0
						for i = nav_cat.admin, nav_cat.admin+maxslots-1 do
							if LC.menu.subcat.admin and LC.menu.subcat.admin[i] and LC.menu.subcat.admin[i].name
								local LANG_NAME = LC.functions.getStringLanguage(LC.menu.subcat.admin[i].name)
								if LC_menu.nav == i-1 and LC_menu.category != "main"
									LC.functions.drawString(v, 136, 30+y, LANG_NAME, V_SNAPTOTOP|colors.sel_map, "left", 178)
									if LC.menu.subcat.admin[i].description
										local LANG_DESC = LC.functions.getStringLanguage(LC.menu.subcat.admin[i].description)
										LC_menu.tip = LANG_DESC
									else
										LC_menu.tip = ""
									end
								else
									LC.functions.drawString(v, 136, 30+y, LANG_NAME, V_SNAPTOTOP, "left", 178)
								end
								y = $ + 10
							end
						end
					else
						for m = 1, #LC.menu.subcat.admin do
							if LC.menu.subcat.admin[m].name == LC_menu.subcategory
								LC.menu.subcat.admin[m].funchud(v)
							end
						end
					end
					if LC_menu.category != "main"
						if not LC.serverdata.groups.list[consoleplayer.group].perms[1] and consoleplayer != server
							LC_menu.category = "main"
							LC_menu.subcategory = nil
							LC_menu.nav = 0
							LC_menu.lastnav = 4
						end
					end
				elseif LC_menu.category == "misc" or (LC_menu.category == "main" and LC_menu.nav == 3)
					if LC_menu.subcategory == nil
						v.drawScaledNameTag(216*FRACUNIT, 8*FRACUNIT, "Miscellaneous", V_ALLOWLOWERCASE|V_SNAPTOTOP, FRACUNIT/2, SKINCOLOR_SKY, SKINCOLOR_BLACK)
						local real_height = (v.height() / v.dupx())
						local maxslots = real_height/10 - 4
						if LC.menu.subcat.player[1]
							if LC_menu.nav+1 < nav_cat.misc
								nav_cat.misc = $ - 1
							elseif LC_menu.nav+1 > nav_cat.misc+maxslots-1
								nav_cat.misc = $ + 1
							end
						end
						-- Animate Arrow
						local arrow_y = 0
						if (leveltime % 10) > 5
							arrow_y = 2
						end
						
						-- Arrow Up
						if LC_menu.nav+1 > 0 and nav_cat.misc != 1
							v.drawString(318, 32+arrow_y, string.char(26), V_SNAPTOTOP|colors.sel_map, "right")
						end
						-- Arrow Down
						if LC_menu.nav+1 != LC_menu.lastnav and #LC.menu.subcat.misc > maxslots and nav_cat.misc+maxslots-1 < #LC.menu.subcat.misc
							v.drawString(318, 180+arrow_y, string.char(27), V_SNAPTOBOTTOM|colors.sel_map, "right")
						end
						local y = 0
						for i = nav_cat.misc, nav_cat.misc+maxslots-1 do
							if LC.menu.subcat.misc and LC.menu.subcat.misc[i] and LC.menu.subcat.misc[i].name
								local LANG_NAME = LC.functions.getStringLanguage(LC.menu.subcat.misc[i].name)
								if LC_menu.nav == i-1 and LC_menu.category != "main"
									LC.functions.drawString(v, 136, 30+y, LANG_NAME, V_SNAPTOTOP|colors.sel_map, "left", 178)
									if LC.menu.subcat.misc[i].description
										local LANG_DESC = LC.functions.getStringLanguage(LC.menu.subcat.misc[i].description)
										LC_menu.tip = LANG_DESC
									else
										LC_menu.tip = ""
									end
								else
									LC.functions.drawString(v, 136, 30+y, LANG_NAME, V_SNAPTOTOP, "left", 178)
								end
								y = $ + 10
							end
						end
					else
						for m = 1, #LC.menu.subcat.misc do
							if LC.menu.subcat.misc[m].name == LC_menu.subcategory
								LC.menu.subcat.misc[m].funchud(v)
							end
						end
					end
				elseif LC_menu.category == "main" and LC_menu.nav == 4
					local source = LC.functions.getStringLanguage("LC_MENU_ABOUT"):format(LC.functions.GetVersion().string)
					LC.functions.drawStringBox(v, 224, 8, source, V_ALLOWLOWERCASE, "thin-center", 176)
					/*
					source = source.."\x88".."Lithium Core\n"
					source = source.."Version "..LC.functions.GetVersion().string.."\n"
					source = source.."All content created by Sirexer can be freely edited and distributed.\n"
					source = source.."\n"
					source = source.."\x85".."WARNING".."\x80".."! This addon is in beta development. I do not recommend hosting on your servers, for the safety of your server is responsible for yourself.\n"
					source = source.."\n"
					source = source.."Found a bug or have a suggestion? Contact me via\x89 Discord (sirexer)\x80, More likely you will find me on Discord Servers related to the thematic SRB2.\n"
					source = source.."\n"
					source = source.."Special thanks to\n"
					source = source.."ChetTJ - for LithiumCore icon\n"
					source = source.."Ors - for unicode fonts\n"
					source = source.."\n"
					source = source.."Third party content:\n"
					source = source.."JSON lua by rxi\n"
					local y = 0
					local cur = 1
					local str = ""
					local space = 0
					local space_line = 0
					while true do
						if source:sub(cur, cur) == "" then break end
					
						if source:sub(cur, cur) == "\n"
						or v.stringWidth(str..source:sub(cur, cur), V_ALLOWLOWERCASE, "thin") > 160
							if space == 0 or source:sub(cur, cur) == "\n"
								v.drawString(232, 8+y, str, V_ALLOWLOWERCASE, "thin-center")
								y = $ + 8
								space = 0
								space_line = 0
								str = ""
								cur = $ + 1
								continue
							elseif space != 0
								v.drawString(232, 8+y, str:sub(1, space_line), V_ALLOWLOWERCASE, "thin-center")
								y = $ + 8
								cur = space+1
								space = 0
								space_line = 0
								str = ""
								continue
							end
						end
						
						if source:sub(cur, cur) == " " then space = cur space_line = str:len()+1 end
						
						str = str..source:sub(cur, cur)
						
						cur = $ + 1
					end
					
					*/
				end
			end
			local catx = -16
			
			-- Get localized menu strings
			local LC_MENU_ACCOUNT = LC.functions.getStringLanguage("LC_MENU_ACCOUNT") 
			local LC_MENU_OPTIONS = LC.functions.getStringLanguage("LC_MENU_OPTIONS")
			local LC_MENU_ADMIN   = LC.functions.getStringLanguage("LC_MENU_ADMIN")
			local LC_MENU_MISC    = LC.functions.getStringLanguage("LC_MENU_MISC")
			local LC_MENU_EXIT    = LC.functions.getStringLanguage("LC_MENU_EXIT")

			local drawString = LC.functions.drawString

			-- Account
			if LC_menu.nav == 0 and LC_menu.category == "main"
				drawString(v, anim.panelx+8, catx+64, LC_MENU_ACCOUNT, V_SNAPTOTOP|V_SNAPTOLEFT|colors.sel_map, "left")
				LC_menu.tip = LC.functions.getStringLanguage("LC_MENU_ACCOUNT_TIP")
			elseif (LC_menu.category == "main" and LC_menu.nav ~= 0) or LC_menu.category ~= "account"
				drawString(v, anim.panelx+8, catx+64, LC_MENU_ACCOUNT, V_SNAPTOTOP|V_SNAPTOLEFT, "left")
			elseif LC_menu.category == "account"
				drawString(v, anim.panelx+8, catx+64, LC_MENU_ACCOUNT.." >", V_SNAPTOTOP|V_SNAPTOLEFT|colors.sel_map, "left")
			end

			-- Options
			if LC_menu.nav == 1 and LC_menu.category == "main"
				drawString(v, anim.panelx+8, catx+74, LC_MENU_OPTIONS, V_SNAPTOTOP|V_SNAPTOLEFT|colors.sel_map, "left")
				LC_menu.tip = LC.functions.getStringLanguage("LC_MENU_OPTIONS_TIP")
			elseif (LC_menu.category == "main" and LC_menu.nav ~= 1) or LC_menu.category ~= "options"
				drawString(v, anim.panelx+8, catx+74, LC_MENU_OPTIONS, V_SNAPTOTOP|V_SNAPTOLEFT, "left")
			elseif LC_menu.category == "options"
				drawString(v, anim.panelx+8, catx+74, LC_MENU_OPTIONS.." >", V_SNAPTOTOP|V_SNAPTOLEFT|colors.sel_map, "left")
			end

			-- Admin panel (only if player has permissions)
			if LC.serverdata.groups.list[player.group].perms[1] or player == server
				if LC_menu.nav == 2 and LC_menu.category == "main"
					drawString(v, anim.panelx+8, catx+84, LC_MENU_ADMIN, V_SNAPTOTOP|V_SNAPTOLEFT|colors.sel_map, "left")
					LC_menu.tip = LC.functions.getStringLanguage("LC_MENU_ADMIN_TIP")
				elseif (LC_menu.category == "main" and LC_menu.nav ~= 2) or LC_menu.category ~= "panel"
					drawString(v, anim.panelx+8, catx+84, LC_MENU_ADMIN, V_SNAPTOTOP|V_SNAPTOLEFT, "left")
				elseif LC_menu.category == "panel"
					drawString(v, anim.panelx+8, catx+84, LC_MENU_ADMIN.." >", V_SNAPTOTOP|V_SNAPTOLEFT|colors.sel_map, "left")
				end
			else
				-- Grayed-out admin option
				drawString(v, anim.panelx+8, catx+84, "\x86"..LC_MENU_ADMIN, V_SNAPTOTOP|V_SNAPTOLEFT, "left")
			end

			-- Miscellaneous
			if LC_menu.nav == 3 and LC_menu.category == "main"
				drawString(v, anim.panelx+8, catx+94, LC_MENU_MISC, V_SNAPTOTOP|V_SNAPTOLEFT|colors.sel_map, "left")
				LC_menu.tip = LC.functions.getStringLanguage("LC_MENU_MISC_TIP")
			elseif LC_menu.category == "misc"
				drawString(v, anim.panelx+8, catx+94, LC_MENU_MISC.." >", V_SNAPTOTOP|V_SNAPTOLEFT|colors.sel_map, "left")
			else
				drawString(v, anim.panelx+8, catx+94, LC_MENU_MISC, V_SNAPTOTOP|V_SNAPTOLEFT, "left")
			end

			-- Exit
			if LC_menu.nav == 4 and LC_menu.category == "main"
				drawString(v, anim.panelx+8, catx+114, LC_MENU_EXIT, V_SNAPTOTOP|V_SNAPTOLEFT|colors.sel_map, "left")
				LC_menu.tip = LC.functions.getStringLanguage("LC_MENU_EXIT_TIP")  --"Close the Lithium Core menu."
			else
				drawString(v, anim.panelx+8, catx+114, LC_MENU_EXIT, V_SNAPTOTOP|V_SNAPTOLEFT, "left")
			end

			v.drawFill(anim.panelx+8, catx+138, 112, 56, colors.tips_fill|V_SNAPTOTOP|V_SNAPTOLEFT)
			
			v.drawFill(anim.panelx+8, catx+138, 112, 1, 73|V_SNAPTOTOP|V_SNAPTOLEFT)
			v.drawFill(anim.panelx+8, catx+138+56, 112, 1, 73|V_SNAPTOTOP|V_SNAPTOLEFT)
			
			v.drawFill(anim.panelx+8, catx+138, 1, 57, 73|V_SNAPTOTOP|V_SNAPTOLEFT)
			v.drawFill(anim.panelx+8+112, catx+138, 1, 57, 73|V_SNAPTOTOP|V_SNAPTOLEFT)
			if LC_menu.tip
				LC.functions.drawStringBox(v, anim.panelx+10, catx+140, LC_menu.tip, V_SNAPTOTOP|V_SNAPTOLEFT|V_ALLOWLOWERCASE, "small", 112)
			end
			
			if evil_lithiumcore
				
				if g_state.enabled == true //glitchs_fade != 0
					local createGlitch = v.RandomRange(0,16)
					
					for i = 1, createGlitch do
						local t = {
							type = v.RandomRange(0, 1),
							x = 0,//v.RandomRange(0, real_width)*FU,
							y = v.RandomRange(0, real_height)*FU,
							x_scale = real_width,//v.RandomRange(2, 4),
							y_scale = v.RandomRange(1, 1),
							fade = v.RandomRange(5, 10)
						}
						
						table.insert(glitchs, t)
					end
					
					if #glitchs != 0
					and g_states[g_state.state].neg != false
						for i = #glitchs, 1, -1 do
							local flag = 0
							local patch
							if glitchs[i].type == 0
								flag = V_SUBTRACT
								patch = v.cachePatch("~090")
							elseif glitchs[i].type == 1
								flag = V_SUBTRACT
								patch = v.cachePatch("~178")
							end
							
							local ngscale_x = (FU/patch.width) * glitchs[i].x_scale
							local ngscale_y = (FU/patch.height) * glitchs[i].y_scale
							
							v.drawCropped(glitchs[i].x ,glitchs[i].y , ngscale_x, ngscale_y, patch, flag|V_SNAPTOTOP|V_SNAPTOLEFT, nil, 0, 0, (patch.width*FU), patch.height*FU)
							
							if glitchs[i].fade != 0
								glitchs[i].fade = $ - 1
							else
								table.remove(glitchs, i)
							end
						end
					end
					
					local g_negcolor = tostring(g_state.color)
					while g_negcolor:len() < 3 do
						g_negcolor = "0"..g_negcolor
					end
					
					local ng_patch = v.cachePatch("~"..g_negcolor)
					
					if g_state.change == 0
						if g_state.color != 255
							g_state.color = $ + 1
						else
							g_state.color = 0
						end
					end
						
					local ngscale_x = (FU/ng_patch.width) * (real_width+64)
					local ngscale_y = (FU/ng_patch.height) * (real_height+64)
					if g_states[g_state.state].neg != false
						v.drawCropped(0 ,0, ngscale_x, ngscale_y, ng_patch, V_SUBTRACT|V_SNAPTOTOP|V_SNAPTOLEFT, nil, 0, 0, (ng_patch.width*FU), ng_patch.height*FU)
					end
					if g_states[g_state.state].gray != false
						v.drawCropped(0 ,0, ngscale_x, ngscale_y, v.cachePatch("~010"), V_SNAPTOTOP|V_SNAPTOLEFT|g_states[g_state.state].gray, nil, 0, 0, (ng_patch.width*FU), ng_patch.height*FU)
					end
					
					if g_state.time > 0
					and g_state.state != #g_states
						if g_state.change == 0
							g_state.state = $ + 1
							g_state.change = g_states[g_state.state].time
						else
							g_state.change = $ - 1
						end
					elseif g_state.time == 0
					and g_state.state != 1
						if g_state.change == 0
							g_state.state = $ - 1
							g_state.change = g_states[g_state.state].time
						else
							g_state.change = $ - 1
						end
					elseif g_state.time == 0
					and g_state.state == 1
						g_state.enabled = false
					end
					
					if g_state.time != 0
						g_state.time = $ - 1
					end
				elseif g_state.enabled == false
					if v.RandomChance(FU/320)
						g_state.enabled = true
						g_state.state = 1
						g_state.change = 3
						g_state.time = v.RandomRange(TICRATE*5, TICRATE*20)
					end
				end
				if muslag == 0
					if v.RandomChance(FU/96)
						muslag = v.RandomRange(5, TICRATE)
					end
				else
					S_SetMusicPosition(S_GetMusicPosition()-28)
					muslag = $ - 1
				end
			end
		end
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true
