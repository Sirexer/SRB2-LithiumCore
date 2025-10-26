local LC = LithiumCore

local background_x = 0

-- Define a HUD hook table for chat messages
local hooktable = {
    name = "LC.ChatMSG",
    type = "HUD",
    typehud = {"game"},
    toggle = true,
	priority = 400,
    TimeMicros = 0,
    func = function(v, player, camera)
        -- Return if no messages exist
        if LC.localdata.csay[1] == nil then return end
        -- Remove invalid messages (non-table)
        if type(LC.localdata.csay[1]) != "table" then table.remove(LC.localdata.csay, 1) return end
        
        -- Play sound effect if not already played for this message
        if LC.localdata.csay[1].sound_played == false
            S_StartSound(nil, sfx_s3k68, consoleplayer)
            LC.localdata.csay[1].sound_played = true
        end
        
        -- Calculate screen dimensions
        local real_height = (v.height() / v.dupx())
        local real_width = (v.width() / v.dupy())
        local max_width = real_width/2 - 4  -- Maximum width for message box
        
        -- Handle message box sliding in animation
        if LC.localdata.csay[1].text_over == false
            if LC.localdata.csay[1].x == false
                LC.localdata.csay[1].x = max_width  -- Initialize position if not set
            elseif LC.localdata.csay[1].x != 0
                local speed = (LC.localdata.csay[1].x/8)
                if speed != 0
                    LC.localdata.csay[1].x = $ - speed  -- Smooth sliding animation
                else 
                    LC.localdata.csay[1].x = $ - 1  -- Fallback movement
                end
            end
        end
    
        -- Handle message box sliding out animation
        if LC.localdata.csay[1].text_over == true
            if LC.localdata.csay[1].x < max_width
                local speed = (LC.localdata.csay[1].x/8)
                if speed != 0
                    LC.localdata.csay[1].x = $ + speed  -- Smooth sliding animation
                else 
                    LC.localdata.csay[1].x = $ + 1  -- Fallback movement
                end
            else
                -- Remove message when animation completes
                table.remove(LC.localdata.csay, 1)
                return
            end
        end   
        
        -- Draw message box background
        v.drawFill(320-max_width+LC.localdata.csay[1].x, 19, max_width, 21, 156|V_SNAPTOTOP|V_SNAPTORIGHT)
        
        -- Draw top border with animated texture
        local bg_x = (320-max_width+LC.localdata.csay[1].x)*FRACUNIT
        local bg_patch = v.cachePatch("NTSATKT2")
        v.drawCropped(bg_x,19*FU, FU-(FU/4), FU-(FU/4), bg_patch, V_SNAPTOTOP|V_SNAPTORIGHT|V_20TRANS, nil, (background_x*2), FU*6, bg_patch.width*FU, (bg_patch.height-88)*FU)
        -- Animate background texture
        if background_x == 0
            background_x = (32*FU)/2
        else
            background_x = $ - FU/4
        end
        
        -- Draw top and bottom borders
        v.drawFill(320-max_width+LC.localdata.csay[1].x, 19, max_width, 1, 73|V_SNAPTOTOP|V_SNAPTORIGHT)
        v.drawFill(320-max_width+LC.localdata.csay[1].x, 40, max_width, 1, 31|V_SNAPTOTOP|V_SNAPTORIGHT)
        
        -- Process and draw message header (sender name)
        local hud_header = LC.localdata.csay[1].header
        -- Handle long names with ellipsis
		if LC.localdata.csay[1].message_type == true
			if v.stringWidth(hud_header.." says:", V_ALLOWLOWERCASE, "normal") > max_width-2
				while v.stringWidth(hud_header.."... says:", V_ALLOWLOWERCASE, "normal") > max_width-2 do
					hud_header = hud_header:sub(1, hud_header:len()-1)
				end
				hud_header = hud_header.."...\x80 says:"
			else
				hud_header = hud_header.." \x80 says:"
			end
		elseif LC.localdata.csay[1].message_type == false
			if v.stringWidth(hud_header, V_ALLOWLOWERCASE, "normal") > max_width-2
				while v.stringWidth(hud_header.."...", V_ALLOWLOWERCASE, "normal") > max_width-2 do
					hud_header = hud_header:sub(1, hud_header:len()-1)
				end
				hud_header = hud_header.."..."
			end
		end
		
        v.drawString(320-max_width+LC.localdata.csay[1].x+2, 20, (tostring(hud_header)), V_SNAPTOTOP|V_SNAPTORIGHT|V_ALLOWLOWERCASE, "left")
        
        -- Check if message text is too long
        local long_text = false
        if v.stringWidth(LC.localdata.csay[1].msg, V_ALLOWLOWERCASE, "thin") > max_width-2 then long_text = true end    
        
        -- Handle short messages (single line)
        if long_text == false
            v.drawString(320-max_width+LC.localdata.csay[1].x+2, 30, (tostring(LC.localdata.csay[1].msg)), V_SNAPTOTOP|V_SNAPTORIGHT|V_ALLOWLOWERCASE, "thin")
            -- Count down display timer
            if LC.localdata.csay[1].time != 0
                LC.localdata.csay[1].time = $ - 1
            else
                LC.localdata.csay[1].text_over = true  -- Start slide-out animation when time expires
            end
        -- Handle long messages (scrolling text)
        elseif long_text == true
            local fixed_x = (320-max_width+LC.localdata.csay[1].x+2)*FU
            local fixed_y = 30*FU
            local width_text = 0
            
			-- Caching text
			if not LC.localdata.csay[1].cache then
				LC.localdata.csay[1].cache = LC.functions.cacheString(v, LC.localdata.csay[1].msg, "thin")
			end
			
			LC.localdata.csay[1].text_x = LC.functions.scrolledString(v, fixed_x, fixed_y, FU, FU, LC.localdata.csay[1].cache, V_SNAPTOTOP|V_SNAPTORIGHT, 0, LC.localdata.csay[1].text_x, 0, max_width-4, 10)
			
			local total_width = LC.localdata.csay[1].cache.width_text * FU
			if total_width < abs(LC.localdata.csay[1].text_x) then
				LC.localdata.csay[1].text_over = true
			end
			
			-- Scroll text left when message box is fully visible
            if LC.localdata.csay[1].x == 0
                LC.localdata.csay[1].text_x = $ - FU
            end
			
        end
    end
}

-- Register the HUD hook
table.insert(LC_Loaderdata["hook"], hooktable)

return true -- End Of File
