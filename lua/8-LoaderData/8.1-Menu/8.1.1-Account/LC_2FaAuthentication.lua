local LC = LithiumCore


local sha1 = sha1
local totp = totp
local qrencode = qrencode
local totp = totp
local RNG = RNG
local str_code = ""

local hmac_sha1 = sha1.hmac_sha1

local secret_key = nil

local t = {
	name = "LC_MENU_2FA",
	description = "LC_MENU_2FA_TIP",
	type = "account",
	funchud = function(v)
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		v.drawScaledNameTag(216*FRACUNIT, 8*FRACUNIT, "2FA authentication", V_ALLOWLOWERCASE|V_SNAPTOTOP, FRACUNIT/2, SKINCOLOR_SKY, SKINCOLOR_BLACK)
		LC.functions.drawString(v, 136, 30, LC.functions.getStringLanguage("LC_MENU_2FA_AUTH")..":", V_SNAPTOTOP, "thin-left")
		if LC.localdata.twofa_enabled == false
			LC.functions.drawString(v, 136, 40, "\x85"..LC.functions.getStringLanguage("LC_MENU_DISABLED"), V_SNAPTOTOP, "left")
			if LC_menu.nav == 0
				LC.functions.drawString(v, 136, 50, LC.functions.getStringLanguage("LC_MENU_2FA_ENABLE"), V_SNAPTOTOP|V_YELLOWMAP, "left")
			else
				LC.functions.drawString(v, 136, 50, LC.functions.getStringLanguage("LC_MENU_2FA_ENABLE"), V_SNAPTOTOP, "left")
			end
			
			if secret_key
				local size_qr = (FU/secret_key.qr.width) * 60
				LC.functions.drawScaledIMG(v, 136*FU, 60*FU,secret_key.qr, size_qr, V_SNAPTOTOP)
				local sk_formated = ""
				for i = 1, secret_key.str:len() do
					if i == 4 or i == 8 or i == 12
						sk_formated = sk_formated..secret_key.str:sub(i,i).." "
					else
						sk_formated = sk_formated..secret_key.str:sub(i,i)
					end
				end
				
				local step_y = LC.functions.drawStringBox(v, 200, 60, LC.functions.getStringLanguage("LC_MENU_2FA_STEP1"), V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin", 128)
				step_y = LC.functions.drawStringBox(v, 200, step_y, LC.functions.getStringLanguage("LC_MENU_2FA_STEP2"), V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin", 128)
				step_y = LC.functions.drawStringBox(v, 200, 104, LC.functions.getStringLanguage("LC_MENU_2FA_STEP3"), V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin", 128)
				--[[
				v.drawString(200, 60, "Install Authy or", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
				v.drawString(200, 68, "Google Authenticator", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
				v.drawString(200, 76, "on your smartphone.", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
				v.drawString(200, 86, "Open the authentication", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
				v.drawString(200, 94, "app and scan the image", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
				v.drawString(200, 104, "2fa code (manual entry)", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
				]]
				v.drawString(200, 112, sk_formated, V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
				
				LC.functions.drawString(v, 136, 122, LC.functions.getStringLanguage("LC_MENU_2FA_STEP4"), V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
				
				if LC_menu.nav == 1
					LC.functions.drawString(v, 136, 132, LC.functions.getStringLanguage("LC_MENU_CODE"), V_SNAPTOTOP|V_YELLOWMAP, "left")
				else
					LC.functions.drawString(v, 136, 132, LC.functions.getStringLanguage("LC_MENU_CODE"), V_SNAPTOTOP, "left")
				end
				v.drawFill(136, 141, 180, 10, 253|V_SNAPTOTOP)
				if LC_menu.nav == 1 and (leveltime % 4) / 2
					v.drawString(138, 142, secret_key.code.."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
				else
					v.drawString(138, 142, secret_key.code, V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
				end
				
				if LC_menu.nav == 2
					LC.functions.drawString(v, 312, 170, LC.functions.getStringLanguage("LC_MENU_ACTIVATE"), V_SNAPTOTOP|V_YELLOWMAP, "right")
				else
					LC.functions.drawString(v, 312, 170, LC.functions.getStringLanguage("LC_MENU_ACTIVATE"), V_SNAPTOTOP, "right")
				end
				
				
				if LC_menu.lognotice
					if type(LC_menu.lognotice) == "string"
						LC.functions.drawString(v, 136, 160, LC.functions.getStringLanguage(LC_menu.lognotice), V_SNAPTOTOP, "thin")
					end
				end
			end
			
		elseif LC.localdata.twofa_enabled == true
			LC.functions.drawString(v, 136, 40, "\x83"..LC.functions.getStringLanguage("LC_MENU_ENABLED"), V_SNAPTOTOP, "left")
			
			if LC_menu.nav == 0
				LC.functions.drawString(v, 136, 50, LC.functions.getStringLanguage("LC_MENU_CODE"), V_SNAPTOTOP|V_YELLOWMAP, "left")
			else
				LC.functions.drawString(v, 136, 50, LC.functions.getStringLanguage("LC_MENU_CODE"), V_SNAPTOTOP, "left")
			end
			v.drawFill(136, 59, 180, 10, 253|V_SNAPTOTOP)
			if LC_menu.nav == 0 and (leveltime % 4) / 2
				v.drawString(138, 60, str_code.."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
			else
				v.drawString(138, 60, str_code, V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
			end
			
			if LC_menu.nav == 1
				LC.functions.drawString(v, 136, 80, LC.functions.getStringLanguage("LC_MENU_2FA_DISABLE"), V_SNAPTOTOP|V_YELLOWMAP, "left")
			else
				LC.functions.drawString(v, 136, 80, LC.functions.getStringLanguage("LC_MENU_2FA_DISABLE"), V_SNAPTOTOP, "left")
			end
			
			if LC_menu.nav == 2
				LC.functions.drawString(v, 136, 90, LC.functions.getStringLanguage("LC_MENU_2FA_GENBACKCODES"), V_SNAPTOTOP|V_YELLOWMAP, "left")
			else
				LC.functions.drawString(v, 136, 90, LC.functions.getStringLanguage("LC_MENU_2FA_GENBACKCODES"), V_SNAPTOTOP, "left")
			end
			
			if LC.localdata.twofa_bc
				LC.functions.drawString(v, 136, 100, LC.functions.getStringLanguage("LC_MENU_2FA_BACKUPCODES"), V_SNAPTOTOP, "left")
				local step_y = LC.functions.drawStringBox(v, 136, 110, LC.functions.getStringLanguage("LC_MENU_2FA_BC_MSG1"), V_SNAPTOTOP, "thin", 192)
				step_y = LC.functions.drawStringBox(v, 136, step_y, LC.functions.getStringLanguage("LC_MENU_2FA_BC_MSG2"), V_SNAPTOTOP, "thin", 192)
				step_y = LC.functions.drawStringBox(v, 136, step_y, LC.functions.getStringLanguage("LC_MENU_2FA_BC_MSG3"), V_SNAPTOTOP, "thin", 192)
				--[[
				v.drawString(136, 120, "You can use these codes to log ", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
				v.drawString(136, 128, "in to your account if you lose", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
				v.drawString(136, 136, "access to the authentication app.", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
				v.drawString(136, 144, "Keep them in a safe place.", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
				v.drawString(136, 152, "Each code can only be used once.", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
				]]
				local codes = LC.localdata.twofa_bc
				local c_y = 0
				for i = 1, #codes, 4 do
					v.drawString(136, step_y+10+c_y, codes[i].."  "..codes[i+1].."  "..codes[i+2].."  "..codes[i+3], V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
					c_y = $ + 8
				end

			end
			
			if LC_menu.lognotice
				if type(LC_menu.lognotice) == "string"
					LC.functions.drawString(v, 136, 186, LC.functions.getStringLanguage(LC_menu.lognotice), V_SNAPTOTOP, "thin")
				end
			end
			
		end
	end,
	
	funcenter = function()
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		LC_menu.nav = 0
		if LC.localdata.twofa_enabled == false
			LC_menu.lastnav = 0
		elseif LC.localdata.twofa_enabled == true
			LC_menu.lastnav = 2
		end
		str_code = ""
		secret_key = nil
	end,
		
	funchook = function(key)
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		if LC_menu.nav == 0
			if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
				if LC.localdata.twofa_enabled == false
					RNG.RandomSeed()
					local str = totp.gen_totp_secret(16)
					local serv_name = CV_FindVar("servername").string
					serv_name = LC.functions.filterPrintable(serv_name)
					local link = totp.make_otpauth_uri(str, consoleplayer.stuffname, "[SRB2-LC]"..serv_name)
					local a, qr = qrencode.qrcode(link)
					qr = LC.functions.QRtoIMG(qr, 3)
					secret_key = {
						qr = qr,
						link = link,
						str = str,
						code = ""
					}
					LC_menu.lastnav = 2
					LC_menu.nav = 1
				end
			else
				if LC.localdata.twofa_enabled == true
					str_code = LC.functions.InputText(
						"password",
						str_code,
						key,
						LC_menu.capslock,
						LC_menu.shift,
						8
					)
				end
			end
		elseif LC_menu.nav == 1
			if LC.localdata.twofa_enabled == false and secret_key
				secret_key.code = LC.functions.InputText(
					"password",
					secret_key.code,
					key,
					LC_menu.capslock,
					LC_menu.shift,
					6
				)
				if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
					LC_menu.nav = 2
				end
			elseif LC.localdata.twofa_enabled == true
				if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
					if not str_code or str_code == ""
						LC_menu.lognotice = "\x82"..LC.functions.getStringLanguage("LC_ERR_NOCODE")
					else
						COM_BufInsertText(consoleplayer, "LC_totp remove "..str_code)
					end
					--COM_BufInsertText(consoleplayer, "LC_totp remove")
					--LC_menu.lognotice = "\x83".."2FA deactivated!"
				end
			end
		elseif LC_menu.nav == 2
			if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
				if LC.localdata.twofa_enabled == false
				and secret_key
					local verify = totp.verify_totp(secret_key.str, secret_key.code, os.time(), 30, 2, hmac_sha1)
					if not verify
						LC_menu.lognotice = "\x82"..LC.functions.getStringLanguage("LC_ERR_WRONGTOTP")
						LC_menu.nav = 1
						secret_key.code = ""
					else
						COM_BufInsertText(consoleplayer, "LC_totp set "..secret_key.str.." "..secret_key.code)
						LC_menu.lognotice = "\x83"..LC.functions.getStringLanguage("LC_ERR_NOPASSWORD")
						LC_menu.nav = 0
						LC_menu.lastnav = 2
						secret_key = nil
					end
				elseif LC.localdata.twofa_enabled == true
					if not str_code or str_code == ""
						LC_menu.lognotice = "\x82"..LC.functions.getStringLanguage("LC_ERR_NOCODE")
					else
						COM_BufInsertText(consoleplayer, "LC_totp backup_codes "..str_code)
					end
				end
			end
		end
	end
}

table.insert(LC_Loaderdata["menu"], t)

return true
