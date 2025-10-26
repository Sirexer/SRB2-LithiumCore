local LC = LithiumCore

--[[
    Function: LC.functions.scrolledString
    -------------------------------------
    Draws a horizontally scrollable string of text with optional repetition (looping).
    Handles cropping of characters that move outside the visible window area.

    Arguments:
        v (video functions)
            - Video rendering functions used for drawing.

        fixed_x (fixed_t)
            - The X position of the top-left corner of the text window.

        fixed_y (fixed_t)
            - The Y position of the top-left corner of the text window.

        hscale (fixed_t)
            - Horizontal scaling factor (use FU for normal size).

        vscale (fixed_t)
            - Vertical scaling factor (use FU for normal size).

        cache_t (table)
            - A precomputed text cache table that contains:
                - cache_t.chars[]: list of characters with width, height, patch, and color.
                - cache_t.width_text: total width of the string.
                - cache_t.height_text: base height offset for the text.
				- cache_t.font: font type (not used).
			  To get a cached string, use LC.functions.cacheString.

        flags (integer)
            - Drawing flags (e.g., V_ALLOWLOWERCASE, V_FLIP, etc.)

        distance (fixed_t)
            - The spacing between the original text and its repeated copy.
              Set to 0 to disable text repetition.

        scroll_x (fixed_t)
            - The current horizontal scroll offset of the text (can be positive or negative).

        scroll_y (fixed_t)
            - The vertical offset of the text (rarely used, typically 0).

        max_width (integer)
            - The width of the visible window area where text can appear.
              If omitted, it defaults to the screen width divided by the pixel-to-FU ratio.

        max_height (integer)
            - The height of the visible window area.
              Defaults to the screen height divided by the pixel-to-FU ratio.

    Returns:
        scroll_x (fixed_t)
            - The adjusted scroll position after applying looping normalization.
]]

function LC.functions.scrolledString(v, fixed_x, fixed_y, hscale, vscale, cache_t, flags, distance, scroll_x, scroll_y, max_width, max_height)
	if not v or not cache_t then return end
	
	fixed_x 	= fixed_x	 or 0
	fixed_y 	= fixed_y	 or 0
	hscale		= hscale	 or FU
	vscale		= vscale	 or FU
	flags		= flags		 or 0
	distance	= distance   or 0
	max_width	= max_width	 or (v.width() / v.dupy())
	max_height	= max_height or (v.height() / v.dupx())
	
	-- Move text so that it always stays within a valid visible range.
	local total_width = cache_t.width_text * hscale
	local cycle = total_width + distance   -- One full cycle (text + gap)
	local repeated = 0

	if distance > 0 then
		-- Prevent division by zero or invalid cycles
		if cycle > 0 and scroll_x ~= 0 then
			-- Case 1: Text completely moved out to the left
			if scroll_x + total_width <= 0 then
				-- Compute how many full cycles have passed and shift right
				repeated = (( -scroll_x - total_width ) / cycle) + 1
				scroll_x = scroll_x + repeated * cycle

			-- Case 2: Text completely moved out to the right
			elseif scroll_x >= (max_width * FU) then
				local max_right = max_width * FU
				repeated = (( scroll_x - max_right ) / cycle) + 1
				scroll_x = scroll_x - repeated * cycle
			end
		end
	end
	
	local width_text  = 0
	local height_text = cache_t.height_text
	
	-- Loop through every character in the text cache
	for _, char in ipairs(cache_t.chars) do
		-- Skip spaces to improve performance
		if char.patch == "space" then width_text = $ + char.width*hscale continue end
		
		-- Calculate absolute position of the character
		local abs_x = fixed_x + width_text + scroll_x
		local abs_y = fixed_y + height_text + scroll_y
		
		-- Default cropping rectangle (full patch)
		local crop_up, crop_low = 0, char.height*FU
		local crop_left, crop_right = 0, char.width*FU
		
		-- Handle characters that are scrolled off-screen to the left
		if abs_x < fixed_x then
			local visible_x = (fixed_x - abs_x)
			crop_left = (visible_x / hscale) * FU
		end
		
		-- Handle characters that are scrolled off-screen to the right
		if abs_x+(char.width*hscale) > fixed_x + max_width*FU then
			local visible_width = (fixed_x + max_width*FU) - abs_x
			crop_right = (visible_width/hscale) * FU
		end
		
		-- Handle characters that go off the top edge
		if abs_y < fixed_y then
			local visible_y = (fixed_y - abs_y)
			crop_up = (visible_y / vscale) * FU
		end
		
		-- Handle characters that go off the bottom edge
		if abs_y+(char.height*vscale) > fixed_y + max_height*FU then
			local visible_height = (fixed_y + max_height*FU) - abs_y
			crop_low = (visible_height/vscale) * FU
		end
		
		-- Clamp cropping to valid bounds
		crop_up	   = (crop_up > 0 and crop_up)	     or 0
		crop_low   = (crop_low > 0 and crop_low)     or 0
		crop_left  = (crop_left > 0 and crop_left)   or 0
		crop_right = (crop_right > 0 and crop_right) or 0
		
		width_text = $ + char.width*hscale
		
		-- Skip fully cropped characters
		if crop_left >= char.width*FU then continue end
		if crop_right == 0 then break end
		
		-- Draw repeated text if distance > 0 (looping mode)
		local char_x = abs_x + FixedMul(crop_left, hscale)
		local char_y = abs_y + FixedMul(crop_up, vscale)
		v.drawCropped(char_x, char_y, hscale, vscale, char.patch, flags, char.color, crop_left, crop_up, crop_right, crop_low)
	end
	
	if distance > 0 then
		local dup_x1 = scroll_x + total_width + distance
		local dup_x2 = total_width
		LC.functions.scrolledString(v, fixed_x, fixed_y, hscale, vscale,
			cache_t, flags, 0, dup_x1, scroll_y, max_width, max_height)
	end
	
	return scroll_x
end

return true -- End of File
