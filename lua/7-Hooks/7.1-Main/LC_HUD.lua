local LC = LithiumCore

-- ============================================================================
-- Ban and Time Sync HUD
-- ============================================================================
local ban_hud = {
	name = "LC.Main",
	type = "HUD",
	typehud = {"title"},
	toggle = true,
	priority = 1000,
	TimeMicros = 0,
	func = function(v)
		-- Check for server/client time desync
		if LC.localdata.timedelayserver then
			local client_time = os.date("%c", LC.localdata.timedelayserver.client)
			local server_time = os.date("%c", LC.localdata.timedelayserver.server)
			v.drawFill(16, 64, 288, 88, 253)
			v.drawString(160, 72, "\x82".."Client time differs from server time!", V_ALLOWLOWERCASE, "center")
			v.drawString(160, 80, "Please check your system clock.", V_ALLOWLOWERCASE, "center")
			v.drawString(160, 96, "-Server time-", V_ALLOWLOWERCASE, "center")
			v.drawString(160, 104, tostring(server_time), V_ALLOWLOWERCASE, "center")
			v.drawString(160, 112, "-Client time-", V_ALLOWLOWERCASE, "center")
			v.drawString(160, 120, tostring(client_time), V_ALLOWLOWERCASE, "center")
			
			v.drawString(160, 136, "Press any key", V_ALLOWLOWERCASE, "center")
			if menuactive == true or gamestate ~= GS_TITLESCREEN then 
				LC.localdata.timedelayserver = nil 
			end
		end

		-- Check for active ban
		if LC.localdata.bannedfromserver then
			local b = LC.localdata.bannedfromserver
			v.drawFill(16, 32, 288, 136, 253)
			v.drawString(160, 40, "\x82YOU ARE BANNED!", V_ALLOWLOWERCASE, "center")
			v.drawString(160, 56, "Server: "..b.server, V_ALLOWLOWERCASE, "center")
			v.drawString(160, 64, "Moderator: "..b.moderator, V_ALLOWLOWERCASE, "center")
			
			local unban = "Permanent"
			if b.unban then 
				unban = os.date("%c", b.unban) 
			end
			
			v.drawString(160, 72, "Unban date: "..unban, V_ALLOWLOWERCASE, "center")
			v.drawString(160, 80, LC.functions.convertTimestamp("<t:"..b.unban..":R>", b.servertime), V_ALLOWLOWERCASE, "center")
			v.drawString(160, 96, "Reason:", V_ALLOWLOWERCASE, "center")
			
			local reason = b.reason
			local y = 0
			
			-- Wrap reason text if it exceeds boundaries
			while true do
				local width = v.stringWidth(reason, V_ALLOWLOWERCASE, "normal")
				local new_string = reason
				local new_width = v.stringWidth(new_string, V_ALLOWLOWERCASE, "normal")
				local l = reason:len()
				
				if width > 280 then
					while new_width > 280 do
						new_string = new_string:sub(1, l-1)
						l = $ - 1
						new_width = v.stringWidth(new_string, V_ALLOWLOWERCASE, "normal")
					end
					-- Break at the nearest space
					while new_string:sub(l) ~= " " and new_string:find(" ") do
						new_string = new_string:sub(1, l-1)
						l = $ - 1
						new_width = v.stringWidth(new_string, V_ALLOWLOWERCASE, "normal")
					end
					reason = reason:sub(l+1)
					v.drawString(160, 104+y, new_string, V_ALLOWLOWERCASE, "center")
					y = $ + 8
				else
					v.drawString(160, 104+y, reason, V_ALLOWLOWERCASE, "center")
					break
				end
			end
			
			v.drawString(160, 152, "Press any key", V_ALLOWLOWERCASE, "center")
			if menuactive == true or gamestate ~= GS_TITLESCREEN then 
				LC.localdata.bannedfromserver = nil 
			end
		end
	end
}

-- ============================================================================
-- Exit Level Timer HUD
-- ============================================================================
local elt_y = -32

local el_timer_hud = {
	name = "LC.Main",
	type = "HUD",
	typehud = {"game"},
	toggle = true,
	priority = 100,
	TimeMicros = 0,
	func = function(v)
		local LC_exitlevel = LC.serverdata.exitlevel
		
		if LC_exitlevel.countdown == true and (LC.serverdata.completedlevel + LC.serverdata.afkplayers_nc) ~= LC.serverdata.countplayers then
			if elt_y ~= 8 then 
				elt_y = $ + 8 
			end
			
			local str1 = "\x82".."EXITLEVEL IN"
			local str2 = LC_exitlevel.time/TICRATE.." SECONDS"
			
			-- Flashing effect
			if (leveltime % 16) >= 8 then 
				str1 = "\x85".."EXITLEVEL IN" 
			end
			
			if LC_exitlevel.time/TICRATE <= 1 then 
				str2 = LC_exitlevel.time/TICRATE.." SECOND" 
			end
			
			v.drawString(160, elt_y, str1, V_SNAPTOTOP, "center")
			v.drawString(160, elt_y+8, str2, V_SNAPTOTOP, "center")
			
		elseif LC_exitlevel.countdown == false then
			elt_y = -32
		end
	end
}

-- ============================================================================
-- MOTD (Message of the Day) HUD
-- ============================================================================
local aligns = {"left", "right", "center", "justify"}
local cache
local TextHeight = 0

-- Parses the MOTD text, handling BBCode formatting and generating the render cache
local function ParseMOTDText(v, text)
	local bb = {}
	local strs = {}
	local all_str = 1
	local width = 0
	local height = 0
	local size = FU
	local strike = false
	local underline = false
	local bold = false
	local italic = false
	local color = nil
	local bgcolor = nil
	local cur = 1
	local docur = 1
	local align = "left"
	local space = 0
	
	while true do
		if not strs[all_str] then
			strs[all_str] = {symbols={}, align=align, header=nil, width = 0, height = 0, spaces = 0, space_w = 0}
		end
		
		local t = {patch = nil, bb = {}, size = FU, strike = false, underline = false, color = nil, bgcolor = nil, bold = false, italic = false}
		local char = text:sub(cur, cur+4)
		local IsImage = false
		
		if cur > text:len() then
			strs[all_str].width = width
			strs[all_str].height = height
			break
		end
		
		local s
		if char then
			docur = cur
			if LC.Unicode[char] then
				cur = $ + 5
				s = char
			elseif LC.Unicode[string.sub(char, 1, 4)] then
				cur = $ + 4
				s = string.sub(char, 1, 4)
			elseif LC.Unicode[string.sub(char, 1, 3)] then
				cur = $ + 3
				s = string.sub(char, 1, 3)
			elseif LC.Unicode[string.sub(char, 1, 2)] then
				cur = $ + 2
				s = string.sub(char, 1, 2)
			else
				cur = $ + 1
				s = char:sub(1,1)
			end
		end
		
		-- BBCode parsing block
		if s == "[" then
			local end_b = text:find("]", cur)
			local end_s = text:find("\n", cur)
			local IsBB = false
			
			if end_b then IsBB = true end
			if end_s and end_b > end_s then IsBB = false end
			
			if IsBB == true then
				local code = text:sub(cur, end_b-1)
				local hidecode = false
				
				-- Handle alignments
				for _, set_align in ipairs(aligns) do
					if code:lower() == set_align then
						align = set_align
						if #strs[all_str].symbols == 0 then
							strs[all_str].align = set_align
						elseif #strs[all_str].symbols ~= 0 then
							strs[all_str].width = width
							strs[all_str].height = height
							width = 0
							height = 0
							all_str = $ + 1
						end
						table.insert(bb, set_align)
						hidecode = true
					elseif code:lower() == "/"..set_align then
						if bb[1] then
							local finded
							for i, val in ipairs(bb) do
								if val == set_align then finded = i end
							end
							if finded then
								table.remove(bb, finded)
								local prev_align = "left"
								for _, bb_val in ipairs(bb) do
									for _, align_val in ipairs(aligns) do
										if bb_val == align_val then
											prev_align = bb_val
											break
										end
									end
								end
								if end_s then
									local lefttext = text:sub(end_b+1, end_s-1)
									if lefttext ~= "" then
										strs[all_str].width = width
										strs[all_str].height = height
										width = 0
										height = 0
										all_str = $ + 1
									end
								end
								align = prev_align
								hidecode = true
							end
						end
					end
				end
				
				-- Handle size
				if code:lower():sub(1, 5) == "size=" then
					local bb_size = tonumber(code:lower():sub(6))
					if bb_size then
						local onepx = FU/16
						bb_size = $ * onepx
						size = bb_size
						table.insert(bb, code:lower())
						hidecode = true
					end
				elseif code:lower() == "/size" then
					if bb[1] then
						local finded
						for i, val in ipairs(bb) do
							if val:sub(1, 5) == "size=" then finded = i end
						end
						if finded then
							table.remove(bb, finded)
							local prev_size = FU
							for _, val in ipairs(bb) do
								if val:sub(1, 5) == "size=" then
									local onepx = FU/16
									local c = tonumber(val:sub(6))
									prev_size = c * onepx
								end
							end
							size = prev_size
							hidecode = true
						end
					end
				end
				
				-- Handle text color
				if code:lower():sub(1, 6) == "color=" then
					local bb_color
					local s_color = code:lower():sub(7)
					for c = 1, #LC.colormaps do
						local colormap = LC.colormaps[c]
						if colormap.name:lower() == s_color:lower() then
							bb_color = colormap
							break
						end
					end
					if bb_color then
						color = v.getStringColormap(bb_color.value)
						table.insert(bb, code)
						hidecode = true
					end
				elseif code:lower() == "/color" then
					if bb[1] then
						local finded
						for i, val in ipairs(bb) do
							if val:sub(1, 6) == "color=" then finded = i end
						end
						if finded then
							table.remove(bb, finded)
							local prev_color
							for _, val in ipairs(bb) do
								if val:sub(1, 6) == "color=" then
									local s_color = val:sub(7)
									local bb_color
									for c = 1, #LC.colormaps do
										local colormap = LC.colormaps[c]
										if colormap.name:lower() == s_color:lower() then
											bb_color = colormap
											break
										end
									end
									if bb_color then prev_color = v.getStringColormap(bb_color.value) end
								end
							end
							color = prev_color
							hidecode = true
						end
					end
				end
				
				-- Handle background color
				if code:lower():sub(1, 3) == "bg=" then
					local bg = tonumber(code:lower():sub(4))
					if bg and bg >= 0 and bg < 256 then
						bg = tostring(bg)
						while bg:len() < 3 do bg = "0"..bg end
						bgcolor = bg
						table.insert(bb, code)
						hidecode = true
					end
				elseif code:lower() == "/bg" then
					if bb[1] then
						local finded
						for i, val in ipairs(bb) do
							if val:sub(1, 3) == "bg=" then finded = i end
						end
						if finded then
							table.remove(bb, finded)
							local prev_bgcolor
							for _, val in ipairs(bb) do
								if val:sub(1, 3) == "bg=" then
									local c = val:sub(4)
									while c:len() < 3 do c = "0"..c end
									prev_bgcolor = c
								end
							end
							bgcolor = prev_bgcolor
							hidecode = true
						end
					end
				end
				
				-- Handle strike-through
				if code:lower() == "s" or code:lower() == "strike" then
					table.insert(bb, "strike")
					strike = true
					hidecode = true
				elseif code:lower() == "/s" or code:lower() == "/strike" then
					if bb[1] then
						local finded
						for i, val in ipairs(bb) do
							if val == "strike" then finded = i end
						end
						if finded then
							table.remove(bb, finded)
							local prev_strike = false
							for _, val in ipairs(bb) do
								if val == "strike" then prev_strike = true break end
							end
							strike = prev_strike
							hidecode = true
						end
					end
				end
				
				-- Handle underline
				if code:lower() == "u" then
					table.insert(bb, "u")
					underline = true
					hidecode = true
				elseif code:lower() == "/u" then
					if bb[1] then
						local finded
						for i, val in ipairs(bb) do
							if val == "u" then finded = i end
						end
						if finded then
							table.remove(bb, finded)
							local prev_underline = false
							for _, val in ipairs(bb) do
								if val == "u" then prev_underline = true break end
							end
							underline = prev_underline
							hidecode = true
						end
					end
				end
				
				-- Handle bold
				if code:lower() == "b" or code:lower() == "bold" then
					table.insert(bb, "bold")
					bold = true
					hidecode = true
				elseif code:lower() == "/b" or code:lower() == "/bold" then
					if bb[1] then
						local finded
						for i, val in ipairs(bb) do
							if val == "bold" then finded = i end
						end
						if finded then
							table.remove(bb, finded)
							local prev_bold = false
							for _, val in ipairs(bb) do
								if val == "bold" then prev_bold = true break end
							end
							bold = prev_bold
							hidecode = true
						end
					end
				end
				
				-- Handle italics
				if code:lower() == "i" or code:lower() == "italic" then
					table.insert(bb, "italic")
					italic = true
					hidecode = true
				elseif code:lower() == "/i" or code:lower() == "/italic" then
					if bb[1] then
						local finded
						for i, val in ipairs(bb) do
							if val == "italic" then finded = i end
						end
						if finded then
							table.remove(bb, finded)
							local prev_italic = false
							for _, val in ipairs(bb) do
								if val == "italic" then prev_italic = true break end
							end
							italic = prev_italic
							hidecode = true
						end
					end
				end
				
				-- Handle images
				if code:lower():sub(1, 3) == "img" then
					local img_end = text:lower():find(string.gsub("[/img]", "%W","%%%0"), end_b)
					if img_end then
						local str_image = text:sub(end_b+1, img_end-1)
						if v.patchExists(str_image) then
							t.patch = v.cachePatch(str_image)
						else
							t.patch = v.cachePatch("MISSING")
						end
						
						local size_i = FU
						local w_s, w_e = code:lower():find("width=\"", 5)
						if w_s then
							local w_n = code:find("\"", w_e+1)
							if w_n then
								local w_arg = code:sub(w_e+1, w_n-1)
								if w_arg:sub(w_arg:len()-1):lower() == "px" then
									local px = tonumber(w_arg:sub(1, w_arg:len()-2))
									if px > 300 then px = 300 elseif px < 1 then px = 1 end
									size_i = (FU/t.patch.width) * px
								elseif w_arg:sub(w_arg:len()):lower() == "%" then
									local percent = tonumber(w_arg:sub(1, w_arg:len()-1))
									if percent > 100 then percent = 100 elseif percent < 1 then percent = 1 end
									local px = ((300*FU)/100)*percent
									px = $ / FU
									if px > 300 then px = 300 elseif px < 1 then px = 1 end
									size_i = (FU/t.patch.width) * px
								end
							end
						end
						
						if t.patch.width*size_i > 300*FU then
							size_i = (FU/t.patch.width) * 300
						end
						
						end_b = img_end+5
						t.IsImage = true
						t.size = size_i
						IsImage = true
						hidecode = true
					end
				end
				
				if hidecode == true then
					cur = end_b+1
					if IsImage == false then continue end
				end
			end
		end
		
		local uni = tostring(LC.Unicode[s])
		
		if IsImage == false then
			--[[
			while byte:len() < 5 do
				byte = "0"..byte
			end
			]]
			if v.patchExists(uni) then
				t.patch = v.cachePatch(uni)
			elseif s == "\r" then
				continue
			elseif s ~= "\n" then
				t.patch = v.cachePatch("U+10000")
			end
			t.size = size
			t.strike = strike
			t.underline = underline
			t.color = color
			t.bgcolor = bgcolor
		end
		
		if s ~= "\n" then
			if s == " " then
				t.patch = "space"
				table.insert(strs[all_str].symbols, t)
				space = #strs[all_str].symbols
				strs[all_str].spaces = $ + 1
				strs[all_str].space_w = $ + 4*t.size
				width = $ + 4*t.size
			else
				if IsImage == false then
					t.bold = bold
					t.italic = italic
				end
				if t.patch.height*t.size > height then height = t.patch.height*t.size end
				table.insert(strs[all_str].symbols, t)
				if t.bold == false then
					width = $ + t.patch.width*t.size
				elseif t.bold == true then
					width = $ + (t.patch.width*t.size) + (t.size*2)
				end
			end
		end
		
		-- Handle word wrapping / line breaks
		if width > 300*FU or s == "\n" then
			local new_w = 0
			local new_h = 0
			if s ~= "\n" and #strs[all_str].symbols ~= 1 then
				if s == " " then
					width = $ - 4*strs[all_str].symbols[#strs[all_str].symbols].size
					table.remove(strs[all_str].symbols, #strs[all_str].symbols)
				elseif s ~= " " then
					if space == 0 or (space == 1 and strs[all_str].symbols[1].patch == "space") then
						local last = strs[all_str].symbols[#strs[all_str].symbols]
						local size_sym = last.size
						if t.bold == false then
							width = $ - last.patch.width*size_sym
							new_w = last.patch.width*size_sym
						elseif t.bold == true then
							width = $ - (last.patch.width*size_sym) - (size_sym*2)
							new_w = (last.patch.width*size_sym) + (size_sym*2)
						end
						strs[all_str+1] = {symbols={last}, align=align, header=nil, width = new_w, height = t.patch.height*size_sym, spaces = 0, space_w = 0}
						table.remove(strs[all_str].symbols, #strs[all_str].symbols)
					elseif space ~= 0 then
						strs[all_str+1] = {symbols={}, align=align, header=nil, width = 0, height = 0, spaces = 0, space_w = 0}
						while true do
							local last = strs[all_str].symbols[#strs[all_str].symbols]
							local size_sym = last.size
							table.remove(strs[all_str].symbols, #strs[all_str].symbols)
							if last.patch == "space" then
								strs[all_str].width = $ - 4*size_sym
								strs[all_str].spaces = $ - 1
								break
							elseif last.patch ~= "space" then
								if t.bold == false then
									width = $ - last.patch.width*size_sym
									new_w = $ + last.patch.width*size_sym
								elseif t.bold == true then
									width = $ - (last.patch.width*size_sym) - (size_sym*2)
									new_w = $ + (last.patch.width*size_sym) + (size_sym*2)
								end
								table.insert(strs[all_str+1].symbols, 1, last)
								if last.patch.height*size_sym > strs[all_str+1].height then 
									strs[all_str+1].height = last.patch.height*size_sym 
								end
								new_h = strs[all_str+1].height
							end
						end
					end
				end
			end
			strs[all_str].width = width
			strs[all_str].height = height
			width = new_w
			height = new_h
			space = 0
			all_str = $ + 1
			if s == "\n" and #strs[all_str-1].symbols == 0 then
				strs[all_str-1].height = 8*size
			end
		end
	end
	
	-- Calculate exact size of final strings
	local final_height = 0
	for _, str_d in ipairs(strs) do
		final_height = $ + str_d.height
		str_d.width = 0
		str_d.space_w = 0
		for _, sym in ipairs(str_d.symbols) do
			local patch = sym.patch
			local size_sym = sym.size
			if patch == "space" then
				str_d.width = $ + 4*size_sym
				str_d.space_w = $ + 4*size_sym
			elseif patch ~= "space" then
				if sym.bold == false then
					str_d.width = $ + patch.width*size_sym
				elseif sym.bold == true then
					str_d.width = $ + (patch.width*size_sym) + (size_sym*2)
				end
			end
		end
	end
	
	return strs, final_height
end

-- Renders the parsed MOTD contents (text and images)
local function DrawMOTDContent(v, content_cache, scroll_offset)
	v.drawFill(8, 8, 304, 184, 253)
	local y = 24*FRACUNIT
	
	for _, str_d in ipairs(content_cache) do
		local width = str_d.width
		local height = str_d.height
		local align = str_d.align
		local w = 0
		local width_nospace = width - str_d.space_w
		local freespace = (300*FU) - width_nospace
		
		for char_idx, sym in ipairs(str_d.symbols) do
			local patch = sym.patch
			local size_sym = sym.size
			local strike = sym.strike
			local underline = sym.underline
			local bold = sym.bold
			local italic = sym.italic
			local color = sym.color
			local IsImage = sym.IsImage
			local bgcolor = sym.bgcolor and v.cachePatch("~"..sym.bgcolor) or nil
			
			local x = 10*FU
			if align == "center" then
				x = (312*FU - width) / 2
			elseif align == "right" then
				x = (310*FU)-width
			end
			
			if patch == "space" then
				local abs_y = y - scroll_offset
				local s_h = height - (8*size_sym)
				local size_w = 4*size_sym
				local scale_w = size_sym
				abs_y = $ + s_h
				
				if align == "justify" and width >= 154 then
					-- size_w = freespace/str_d.spaces
					-- scale_w = (freespace/str_d.spaces)/2
					w = $ + freespace/str_d.spaces
				else
					w = $ + 4*size_sym
				end
				
				if bgcolor and abs_y >= 4*FU then
					if abs_y <= 192*FU and abs_y+8*size_sym >= 8*FU then
						local crop_u = 0
						local crop_l = 8*FU
						if abs_y+8*size_sym > 192*FU then
							crop_l = $ - ((abs_y+(8*FU))-192*FU)
						elseif abs_y < 8*FU then
							crop_u = 8*FU-abs_y
						end
						if crop_u < 0 then crop_u = 0 end
						if crop_l < 0 then crop_l = 0 end
						local crop_bg = crop_l
						if crop_u ~= 0 then crop_bg = crop_u end
						v.drawCropped(x+w-size_w, abs_y+crop_u, scale_w, size_sym, bgcolor, 0, nil, 0, crop_u, 8*FU, crop_bg)
					end
				end
				
				if strike and 188*FU > abs_y and abs_y > 2*FU then
					local crop_s = 4*FU
					if char_idx == #str_d.symbols then crop_s = 3*FU end
					v.drawCropped(x+w-size_w, abs_y, scale_w, size_sym, v.cachePatch("UNISTRIK"), 0, color, 0, 0, crop_s, 8*FU)
				end
				
				if underline and 186*FU > abs_y and abs_y > 4*FU then
					local crop_s = 4*FU
					if char_idx == #str_d.symbols then crop_s = 3*FU end
					v.drawCropped(x+w-size_w, abs_y, scale_w, size_sym, v.cachePatch("UNIUNDER"), 0, color, 0, 0, crop_s, 8*FU)
				end
				continue
			end
			
			local abs_y = y - scroll_offset
			local s_h = height - (patch.height*size_sym)
			abs_y = $ + s_h
			
			if abs_y > 184*FU or abs_y+(patch.height*size_sym) < 16*FU then 
				w = $ + patch.width*size_sym 
				continue 
			end
			
			local crop_u = 0
			local crop_l = patch.height*FU
			if abs_y < 16*FU then
				local offset_y = 16*FU-abs_y
				crop_u = (offset_y/size_sym)*FU
			end
			if abs_y+(patch.height*size_sym) > 184*FU then
				local offset_y = ((abs_y+(patch.height*size_sym))-184*FU)
				crop_l = patch.height*FU - (offset_y/size_sym)*FU
			end
			if crop_u < 0 then crop_u = 0 end
			if crop_l < 0 then crop_l = 0 end
			
			local add_ws = 0
			if bold == true then add_ws = (size_sym/patch.width)*2 end
			
			if bgcolor and abs_y >= 12*FU then
				local crop_bg = crop_l
				if crop_u ~= 0 then crop_bg = crop_u end
				v.drawCropped(x+w, abs_y+FixedMul(crop_u, size_sym), size_sym+add_ws, size_sym, bgcolor, 0, nil, 0, crop_u, patch.width*FU, crop_bg)
			end
			
			if italic == true then
				local crop_u1 = (patch.width*FU)/2
				if crop_u < (patch.width*FU)/2 then
					v.drawCropped(x+w+(size_sym), abs_y+FixedMul(crop_u, size_sym), size_sym+add_ws, size_sym, patch, 0, color, 0, crop_u, patch.width*FU, crop_l/2)
				end
				if crop_l > (patch.width*FU)/2 and crop_l > crop_u then
					v.drawCropped(x+w, abs_y+FixedMul(crop_u1, size_sym), size_sym+add_ws, size_sym, patch, 0, color, 0, crop_u+crop_u1, patch.width*FU, crop_l)
				end
			elseif italic == false and crop_l > crop_u then
				v.drawCropped(x+w+(patch.leftoffset*size_sym), abs_y+FixedMul(crop_u, size_sym)+(patch.topoffset*size_sym), size_sym+add_ws, size_sym, patch, 0, color, 0, crop_u, patch.width*FU, crop_l-crop_u)
			end
			
			if strike then
				local crop_s = patch.width*FU
				if char_idx == #str_d.symbols then crop_s = $-FU end
				v.drawCropped(x+w, abs_y+FixedMul(crop_u, size_sym), size_sym+add_ws, size_sym, v.cachePatch("UNISTRIK"), 0, color, 0, crop_u, crop_s, crop_l)
			end
			
			if underline then
				local crop_s = patch.width*FU
				if char_idx == #str_d.symbols then crop_s = $-FU end
				v.drawCropped(x+w, abs_y+FixedMul(crop_u, size_sym), size_sym+add_ws, size_sym, v.cachePatch("UNIUNDER"), 0, color, 0, crop_u, crop_s, crop_l)
			end
			
			if bold == false then
				w = $ + patch.width*size_sym
			elseif bold == true then
				w = $ + (patch.width*size_sym) + (size_sym*2)
			end
		end
		y = $ + height
	end
end

-- Renders the MOTD background, scrollbar, and text framing
local function DrawMOTDUI(v, total_height, current_scroll)
	v.drawFill(7, 8, 306, 16, 157)
	v.drawFill(7, 178, 306, 16, 157)
	v.drawString(160, 12, "\x82".."MOTD", 0, "center")
	v.drawString(160, 182, "Press enter to close", 0, "center")
	
	local scrollBarX = 312
	local scrollBarY = 24
	local scrollBarWidth = 8
	local scrollBarHeight = 154
	
	local scrollTrackX = 313
	local scrollTrackY = 25
	local scrollTrackWidth = 6
	local scrollTrackHeight = 152
	
	v.drawFill(scrollBarX, scrollBarY, scrollBarWidth, scrollBarHeight, 158)
	v.drawFill(scrollTrackX, scrollTrackY, scrollTrackWidth, scrollTrackHeight, 31)
	
	local textHeightNormal = total_height / FU
	local windowHeightNormal = 154  -- 154*FU / FU = 154
	
	if textHeightNormal <= windowHeightNormal then return end
	
	local scrollNormal = (current_scroll or 0) / FU
	local maxScroll = textHeightNormal - windowHeightNormal
	
	scrollNormal = max(0, min(scrollNormal, maxScroll))
	
	local thumbHeight = FixedMul(FixedDiv(windowHeightNormal, textHeightNormal), scrollTrackHeight)
	thumbHeight = max(4, thumbHeight)
	
	local thumbPosition
	if maxScroll == 0 then
		thumbPosition = 0
	else
		thumbPosition = (scrollNormal * (scrollTrackHeight - thumbHeight)) / maxScroll
	end
	thumbPosition = max(0, min(thumbPosition, scrollTrackHeight - thumbHeight))
	
	local thumbY = scrollTrackY + thumbPosition
	
	v.drawFill(scrollTrackX, thumbY, scrollTrackWidth, thumbHeight, 72)
	
	-- Animate Navigation Arrows
	local arrow_y = 0
	if (leveltime % 10) > 5 then
		arrow_y = 2
	end
	
	-- Arrow Up
	if current_scroll > 0 then
		v.drawString(313, 17+arrow_y, "\x82"..string.char(26), 0, "thin")
	end
	-- Arrow Down
	if current_scroll < total_height-(154*FU) then
		v.drawString(313, 177+arrow_y, "\x82"..string.char(27), 0, "thin")
	end
end

-- Main MOTD HUD Definition
local motd_hud = {
	name = "LC.MOTD",
	type = "HUD",
	typehud = {"game"},
	toggle = true,
	priority = 1100,
	TimeMicros = 0,
	func = function(v)
		if LC.localdata.motd.open == true then
			-- Handle smooth scrolling
			if LC.localdata.motd.scroll ~= LC.localdata.motd.nscroll then
				LC.localdata.motd.scroll = $ - ((LC.localdata.motd.scroll - LC.localdata.motd.nscroll)/8)
			end
			
			-- Handle window closing
			if LC.localdata.motd.closing == true then
				LC.localdata.motd.closing = false
				LC.localdata.motd.open = false
			end
			
			local text = LC.serverdata.motd
			
			-- Generate parse cache if it doesn't exist
			if not cache then
				cache, TextHeight = ParseMOTDText(v, text)
			end
			
			-- Bound scrolling so it does not go further than the text
			if LC.localdata.motd.scroll < 0 then 
				LC.localdata.motd.scroll = 0 
				LC.localdata.motd.nscroll = 0 
			end
			
			if TextHeight > 154*FU then
				if LC.localdata.motd.scroll > TextHeight-(154*FU) then 
					LC.localdata.motd.scroll = TextHeight-(154*FU) 
					LC.localdata.motd.nscroll = TextHeight-(154*FU) 
				end
			else
				LC.localdata.motd.scroll = 0
				LC.localdata.motd.nscroll = 0
			end
			
			-- Render the split components
			if cache then
				DrawMOTDContent(v, cache, LC.localdata.motd.scroll)
			end
			
			DrawMOTDUI(v, TextHeight, LC.localdata.motd.scroll)
		end
	end
}

table.insert(LC_Loaderdata["hook"], ban_hud)
table.insert(LC_Loaderdata["hook"], el_timer_hud)
table.insert(LC_Loaderdata["hook"], motd_hud)

return true
