local LC = LithiumCore

local LC_hud_set = {
	x = nil,
	text_x = 0,
	reason_x = 0
}

local background_x = 0
local bottom_background_x = 0
local cache_text = {
	vote = nil,
	reason = nil
}

local hooktable = {
	name = "LC.voting",
	type = "HUD",
	typehud = {"game"},
	TimeMicros = 0,
	priority = 400,
	func = function(v, player, camera)
		local voting = LC.serverdata.voting
		
		if not voting then 
			LC_hud_set = {
				x = nil,
				text_x = 0,
				reason_x = 0
			}
			
			cache_text = {
				vote = nil,
				reason = nil
			}
			return
		end
		
		local hud_data = voting.hud_data
		
		if LC.client_consvars["LC_votehud"].value == 1 then
			local x, y = voting.hud_pos.x, voting.hud_pos.y
			local offset_x, offset_y = 260, 100
			
			if hud_data and hud_data.patchname then
				local patchname = hud_data.patchname
				if not v.patchExists(patchname)
					patchname = "BLANKLVL"
				end
				v.drawScaled((x+offset_x-20)*FRACUNIT, (y+offset_y-28)*FRACUNIT, FRACUNIT/4, v.cachePatch(patchname), V_SNAPTORIGHT)
			end
			
			if voting.status == "waiting" then
				LC.functions.drawString(v, x+offset_x, y+offset_y, "\x82"..LC.functions.getStringLanguage("LC_VOTING_VOTENOW"), V_SNAPTORIGHT, "small-center")
			elseif voting.status == "passed" then
				LC.functions.drawString(v, x+offset_x, y+offset_y, "\x83"..LC.functions.getStringLanguage("LC_VOTING_VOTEPASS"), V_SNAPTORIGHT, "small-center")
			elseif voting.status == "failed" then
				LC.functions.drawString(v, x+offset_x, y+offset_y, "\x85"..LC.functions.getStringLanguage("LC_VOTING_VOTEFAIL"), V_SNAPTORIGHT, "small-center")
			end
			
			if hud_data and hud_data.str_vote then
				offset_y = $ + 4
				local str_vote = hud_data.str_vote
				while true do
					local width = v.stringWidth(str_vote, 0, "small")
					local new_string = str_vote
					local new_width = v.stringWidth(new_string, 0, "small")
					local l = str_vote:len()
					if width > 96 then
						while new_width > 96 do
							new_string = new_string:sub(1, l-1)
							l = $ - 1
							new_width = v.stringWidth(new_string, 0, "small")
						end
						while new_string:sub(l) != " " and new_string:find(" ") do
							new_string = new_string:sub(1, l-1)
							l = $ - 1
							new_width = v.stringWidth(new_string, 0, "small")
						end
						str_vote = str_vote:sub(l+1)
						v.drawString(x+offset_x, y+offset_y, "\x84"..new_string, V_SNAPTORIGHT, "small-center")
						offset_y = $ + 4
					else
						v.drawString(x+offset_x, y+offset_y, "\x84"..str_vote, V_SNAPTORIGHT, "small-center")
						break
					end
				end
			end
			
			if hud_data and hud_data.reason and hud_data.reason ~= "" and voting.status == "waiting" then
				offset_y = $ + 4
				local reason = LC.functions.getStringLanguage("LC_VOTING_REASON")..": "..hud_data.reason
				while true do
					local width = v.stringWidth(reason, 0, "small")
					local new_string = reason
					local new_width = v.stringWidth(new_string, 0, "small")
					local l = reason:len()
					if width > 96 then
						while new_width > 96 do
							new_string = new_string:sub(1, l-1)
							l = $ - 1
							new_width = v.stringWidth(new_string, 0, "small")
						end
						while new_string:sub(l) != " " and new_string:find(" ") do
							new_string = new_string:sub(1, l-1)
							l = $ - 1
							new_width = v.stringWidth(new_string, 0, "small")
						end
						reason = reason:sub(l+1)
						LC.functions.drawString(v, x+offset_x, y+offset_y, new_string, V_SNAPTORIGHT, "small-center")
						offset_y = $ + 4
					else
						LC.functions.drawString(v, x+offset_x, y+offset_y, reason, V_SNAPTORIGHT, "small-center")
						break
					end
				end
			end
			
			offset_y = $ + 4
			if voting.status == "waiting" then
				local str_timeleft = LC.functions.getStringLanguage("LC_VOTING_TIMELEFT"):format(voting.time/TICRATE)
				LC.functions.drawString(v, x+offset_x, y+offset_y, "\x8e"..str_timeleft, V_SNAPTORIGHT, "small-center")
				
				local votes = voting.votes
				offset_y = $ + 4
				local str_yes = LC.functions.getStringLanguage("LC_VOTING_YES")
				local str_no = LC.functions.getStringLanguage("LC_VOTING_NO")
				LC.functions.drawString(v, x+offset_x, y+offset_y, str_yes.."\x80: "..votes.yes.." - "..str_no.."\x80: "..votes.no, V_SNAPTORIGHT, "small-center")
				local key_yes = LC.functions.GetControlByName("vote yes")
				local key_no = LC.functions.GetControlByName("vote no")
				if key_yes == nil then key_yes = "" end
				if key_no == nil then key_no = "" end
				offset_y = $ + 4
				local str_press = LC.functions.getStringLanguage("LC_PRESS")
				LC.functions.drawString(v, x+offset_x, y+offset_y, "\x83 "..str_press..key_yes:upper().."     ".."\x85 "..str_press..key_no:upper(), V_ALLOWLOWERCASE|V_SNAPTORIGHT, "small-center")
			elseif voting.status == "passed" then
				local str_passed = LC.functions.getStringLanguage("LC_VOTING_PASSTIME"):format(voting.time/TICRATE)
				LC.functions.drawString(v, x+offset_x, y+offset_y, str_passed, V_SNAPTORIGHT, "small-center")
			elseif voting.status == "failed" then
				local str_canceled = LC.functions.getStringLanguage("LC_CANCELED")
				LC.functions.drawString(v, x+offset_x, y+offset_y, str_canceled, V_SNAPTORIGHT, "small-center")
			end
			
			
		elseif LC.client_consvars["LC_votehud"].value == 2 then
			-- Calculate screen dimensions
			local real_height = (v.height() / v.dupx())
			local real_width = (v.width() / v.dupy())
			local max_width = real_width/3  -- Maximum width for message box
			local y = 0
			
			local speed = (LC_hud_set.x and LC_hud_set.x/8) or 1
			speed = (speed > 0 and speed) or 1
			if LC_hud_set.x == nil
				LC_hud_set.x = max_width  -- Initialize position if not set
			elseif voting.status ~= "waiting" and voting.time <= TICRATE then
				LC_hud_set.x = $ + speed
			elseif LC_hud_set.x != 0
				LC_hud_set.x = $ - speed
			end
			
			-- Draw message box background
			v.drawFill(320-max_width+LC_hud_set.x, 41+y, max_width, 21, 156|V_SNAPTOTOP|V_SNAPTORIGHT|V_30TRANS)
			
			-- Draw top border with animated texture
			local bg_x = (320-max_width+LC_hud_set.x)*FRACUNIT
			local bg_patch = v.cachePatch("NTSATKT2")
			
			v.drawCropped(bg_x,(41+y)*FU, FU-(FU/4), FU-(FU/4), bg_patch, V_SNAPTOTOP|V_SNAPTORIGHT|V_50TRANS, nil, (background_x*2), FU*6, bg_patch.width*FU, (bg_patch.height-88)*FU)
			
			-- Animate background texture
			if background_x == 0
				background_x = (32*FU)/2
			else
				background_x = $ - FU/4
			end
			
			-- Draw top and bottom borders
			v.drawFill(320-max_width+LC_hud_set.x, 41+y, max_width, 1, 73|V_SNAPTOTOP|V_SNAPTORIGHT|V_30TRANS)
			v.drawFill(320-max_width+LC_hud_set.x, 62+y, max_width, 1, 31|V_SNAPTOTOP|V_SNAPTORIGHT|V_30TRANS)
			
			-- Process and draw message header
			local header_center = 320 + (max_width/2)
			
			if voting.status == "waiting" then
				LC.functions.drawString(v, header_center-max_width+LC_hud_set.x, 44+y, "\x82"..LC.functions.getStringLanguage("LC_VOTING_VOTENOW"), V_SNAPTOTOP|V_SNAPTORIGHT|V_30TRANS, "center")
			elseif voting.status == "passed" then
				LC.functions.drawString(v, header_center-max_width+LC_hud_set.x, 44+y, "\x83"..LC.functions.getStringLanguage("LC_VOTING_VOTEPASS"), V_SNAPTOTOP|V_SNAPTORIGHT|V_30TRANS, "center")
			elseif voting.status == "failed" then
				LC.functions.drawString(v, header_center-max_width+LC_hud_set.x, 44+y, "\x85"..LC.functions.getStringLanguage("LC_VOTING_VOTEFAIL"), V_SNAPTOTOP|V_SNAPTORIGHT|V_30TRANS, "center")
			end
			
			-- Check if message text is too long
			local long_text = false
			local hud_vote = "\x84"..hud_data.str_vote
			if v.stringWidth(hud_vote, V_ALLOWLOWERCASE, "thin") > max_width-2 then long_text = true end    
			
			
			if long_text == false -- Handle short string (single line)
				v.drawString(header_center-max_width+LC_hud_set.x, 54+y, hud_vote, V_SNAPTOTOP|V_SNAPTORIGHT|V_ALLOWLOWERCASE|V_30TRANS, "thin-center")
			elseif long_text == true -- Handle long string (scrolling text)
				local fixed_x = (320-max_width+LC_hud_set.x+2)*FU
				local fixed_y = (54+y)*FU
				
				-- Caching text
				if not cache_text.vote then
					cache_text.vote = LC.functions.cacheString(v, hud_vote, "thin")
				end
				
				LC_hud_set.text_x = LC.functions.scrolledString(v, fixed_x, fixed_y, FU, FU, cache_text.vote, V_SNAPTOTOP|V_SNAPTORIGHT|V_30TRANS, 32*FU, LC_hud_set.text_x, 0, max_width-4, 10)
				
				-- Scroll text left when message box is fully visible
				if LC_hud_set.x == 0
					LC_hud_set.text_x = $ - FU
				end
			end
			
			y = $ + 22
			
			-- image
			
			if hud_data and hud_data.patchname then
			
				local patchname = hud_data.patchname
				if not v.patchExists(patchname)
					patchname = "BLANKLVL"
				end
				
				local patch = v.cachePatch(patchname)
				local scale = (FU/patch.width) * max_width
				local height = (patch.height * scale)
				
				local x_fixed = (320-max_width+LC_hud_set.x)*FU
				local y_fixed = (41+y)*FU
				
				v.drawScaled(x_fixed, y_fixed, scale, patch, V_SNAPTOTOP|V_SNAPTORIGHT|V_30TRANS)
				
				y = $ + height/FU
			end
			
			-- Reason
		
			if hud_data.reason and hud_data.reason ~= "" and voting.status == "waiting" then
				v.drawFill(320-max_width+LC_hud_set.x, 41+y, max_width, 22, 156|V_SNAPTOTOP|V_SNAPTORIGHT|V_30TRANS)
				--v.drawFill(320-max_width+LC_hud_set.x, 61+y, max_width, 1, 72|V_SNAPTOTOP|V_SNAPTORIGHT)
				LC.functions.drawString(v, header_center-max_width+LC_hud_set.x, 44+y, "\x82"..LC.functions.getStringLanguage("LC_VOTING_REASON"), V_SNAPTOTOP|V_SNAPTORIGHT|V_30TRANS, "center")
				
				-- Handle message box sliding out animation
				if LC_hud_set.reason_over == true
					if LC_hud_set.x < max_width
						LC_hud_set.reason_x = max_width * FU
					end
				end
				
				-- Check if message text is too long
				local long_text = false
				local hud_reason = "\x80"..hud_data.reason
				if v.stringWidth(hud_reason, V_ALLOWLOWERCASE, "thin") > max_width-2 then long_text = true end    
				
				if long_text == false -- Handle short messages (single line)
					v.drawString(header_center-max_width+LC_hud_set.x, 54+y, hud_reason, V_SNAPTOTOP|V_SNAPTORIGHT|V_ALLOWLOWERCASE|V_30TRANS, "thin-center")
				elseif long_text == true -- Handle long messages (scrolling text)
					local fixed_x = (320-max_width+LC_hud_set.x+2)*FU
					local fixed_y = (54+y)*FU
					
					-- Caching text
					if not cache_text.reason then
						cache_text.reason = LC.functions.cacheString(v, hud_reason, "thin")
					end
					
					LC_hud_set.reason_x = LC.functions.scrolledString(v, fixed_x, fixed_y, FU, FU, cache_text.reason, V_SNAPTOTOP|V_SNAPTORIGHT|V_30TRANS, 32*FU, LC_hud_set.reason_x, 0, max_width-4, 10)
				end
				
				-- Scroll text left when message box is fully visible
				if LC_hud_set.x == 0
					LC_hud_set.reason_x = $ - FU
				end
				
				y = $ + 22
			end
			
			local bot_bg_x = (320-max_width+LC_hud_set.x)*FRACUNIT
			local bot_bg_patch = v.cachePatch("NTSATKT2")
			
			if voting.status == "waiting" then
				v.drawFill(320-max_width+LC_hud_set.x, 41+y, max_width, 34, 156|V_SNAPTOTOP|V_SNAPTORIGHT|V_30TRANS)
				v.drawCropped(bot_bg_x,(41+y)*FU, FU-(FU/4), FU-(FU/4), bot_bg_patch, V_SNAPTOTOP|V_SNAPTORIGHT|V_50TRANS, nil, (bottom_background_x), FU*6, bg_patch.width*FU, (bg_patch.height-72)*FU)
				
				v.drawFill(320-max_width+LC_hud_set.x, 41+y, max_width, 1, 72|V_SNAPTOTOP|V_SNAPTORIGHT|V_30TRANS)
				LC.functions.drawString(v, header_center-max_width+LC_hud_set.x, 44+y, "\x8e"..LC.functions.getStringLanguage("LC_VOTING_TIMELEFT"):format(voting.time/TICRATE), V_SNAPTOTOP|V_SNAPTORIGHT|V_30TRANS, "center")
				local key_yes = LC.functions.GetControlByName("vote yes")
				local key_no = LC.functions.GetControlByName("vote no")
				if key_yes == nil then key_yes = "" end
				if key_no == nil then key_no = "" end
				y = $ + 10
				local str_press = LC.functions.getStringLanguage("LC_PRESS")
				LC.functions.drawString(v, header_center-max_width+LC_hud_set.x, 44+y, "\x83"..str_press.." "..key_yes:upper().."     ".."\x85"..str_press.." "..key_no:upper(), V_SNAPTOTOP|V_ALLOWLOWERCASE|V_SNAPTORIGHT|V_30TRANS, "thin-center")
				y = $ + 10
				local votes = voting.votes
				local str_yes = LC.functions.getStringLanguage("LC_VOTING_YES")
				local str_no = LC.functions.getStringLanguage("LC_VOTING_NO")
				LC.functions.drawString(v, header_center-max_width+LC_hud_set.x, 44+y, str_yes.."\x80: "..votes.yes.." - "..str_no.."\x80: "..votes.no, V_SNAPTOTOP|V_SNAPTORIGHT|V_30TRANS, "center")
				v.drawFill(320-max_width+LC_hud_set.x, 54+y, max_width, 1, 31|V_SNAPTOTOP|V_SNAPTORIGHT|V_30TRANS)
			elseif voting.status == "passed" then
				v.drawFill(320-max_width+LC_hud_set.x, 41+y, max_width, 13, 156|V_SNAPTOTOP|V_SNAPTORIGHT)
				v.drawCropped(bot_bg_x,(41+y)*FU, FU-(FU/4), FU-(FU/4), bot_bg_patch, V_SNAPTOTOP|V_SNAPTORIGHT|V_50TRANS, nil, (bottom_background_x), FU*6, bg_patch.width*FU, (bg_patch.height-99)*FU)
				local str_passed = LC.functions.getStringLanguage("LC_VOTING_PASSTIME"):format(voting.time/TICRATE)
				LC.functions.drawString(v, header_center-max_width+LC_hud_set.x, 44+y, "\x80"..str_passed, V_SNAPTOTOP|V_SNAPTORIGHT|V_30TRANS, "center")
				v.drawFill(320-max_width+LC_hud_set.x, 54+y, max_width, 1, 31|V_SNAPTOTOP|V_SNAPTORIGHT|V_30TRANS)
			elseif voting.status == "failed" then
				v.drawFill(320-max_width+LC_hud_set.x, 41+y, max_width, 13, 156|V_SNAPTOTOP|V_SNAPTORIGHT|V_30TRANS)
				v.drawCropped(bot_bg_x,(41+y)*FU, FU-(FU/4), FU-(FU/4), bot_bg_patch, V_SNAPTOTOP|V_SNAPTORIGHT|V_50TRANS, nil, (bottom_background_x), FU*6, bg_patch.width*FU, (bg_patch.height-99)*FU)
				local str_canceled = LC.functions.getStringLanguage("LC_CANCELED")
				LC.functions.drawString(v, header_center-max_width+LC_hud_set.x, 44+y, "\x80"..str_canceled, V_SNAPTOTOP|V_SNAPTORIGHT|V_30TRANS, "center")
				v.drawFill(320-max_width+LC_hud_set.x, 54+y, max_width, 1, 31|V_SNAPTOTOP|V_SNAPTORIGHT|V_30TRANS)
			end
			
			-- Animate background texture
			if bottom_background_x >= (32*FU)
				bottom_background_x = 0
			else
				bottom_background_x = $ + FU/2
			end
			
		end
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true
