local LC = LithiumCore

local max = max
local FixedMul = FixedMul
local unicode = unicode

local alignment_types = {
	"left",
	"right",
	"center",
	"fixed",
	"fixed-center",
	"fixed-right",
	"small",
	"small-center",
	"small-right",
	"small-fixed",
	"small-fixed-center",
	"small-fixed-right"
}

local colors = {
	V_MAGENTAMAP,
	V_YELLOWMAP,
	V_GREENMAP,
	V_BLUEMAP,
	V_REDMAP,
	V_GRAYMAP,
	V_ORANGEMAP,
	V_SKYMAP,
	V_PURPLEMAP,
	V_AQUAMAP,
	V_PERIDOTMAP,
	V_AZUREMAP,
	V_BROWNMAP,
	V_ROSYMAP,
	V_INVERTMAP
}

--[[
	Function: LC.functions.drawStringBox
	------------------------------------
	Draws a block of text (Unicode-capable) with automatic word wrapping.
	This function splits a cached Unicode string into lines that fit inside a given width,
	applies alignment, scaling, and renders them line by line.

	Arguments:
		v (video functions)
			- Video rendering context used to draw text patches.

		x (fixed_t)
			- X coordinate of the text block on screen.

		y (fixed_t)
			- Y coordinate of the text block on screen.

		cache_t (table|string)
			- Cached Unicode table (from LC.functions.cacheUnicode)
			  or a string that will be cached automatically.

		flags (integer)
			- Drawing flags (V_*) that control rendering and colors.
			  If V_ALLOWLOWERCASE is present, lowercase letters are preserved.

		alignment (string)
			- Determines text alignment and style keywords:
				• "left" / "right" / "center"
				• "fixed" / "fixed-center" / "fixed-right" — disables FU scaling
				• "small" / "small-center" / "small-right" — half-size text
				• "small-fixed" variants — combination of both
				• "thin" — thinner horizontal scaling

		max_width (integer)
			- Maximum line width in pixels before text wraps.
			  Words are always wrapped as a whole (never broken in the middle).

	Returns:
		draw_y (integer)
			- Final Y position (bottom of the drawn text block), in pixels.

	Description:
		This function handles multi-line text rendering with proper word wrapping.
		It automatically:
			- Splits text into tokens (words, spaces, newlines)
			- Wraps words across lines without splitting them
			- Applies per-line alignment ("left", "center", "right")
			- Draws using scaling modes (small, thin, fixed)
			- Applies color via LC.colormaps or V_* flags
			- Calculates proper vertical spacing between lines

		Ideal for chat messages, dialog boxes, tooltips, or UI panels
		where multi-line and width-constrained text is required.
]]


function LC.functions.drawStringBox(v, x, y, cache_t, flags, alignment, max_width)
	-- Video context and string are required
	if not v or not cache_t then return end

	if type(cache_t) == "string" then
		local cached = LC.cache["hud"] --or {}
		local cachename = cache_t
		if not (flags & V_ALLOWLOWERCASE) then cachename = cache_t.."|UPPER" end

		if not cached[cachename] then
			if not (flags & V_ALLOWLOWERCASE) then cache_t = unicode.upper(cache_t) end
			cached[cachename] = LC.functions.cacheUnicode(v, cache_t)
		end
		cache_t = cached[cachename]
	end

	if (flags & V_ALLOWLOWERCASE) then flags = flags - V_ALLOWLOWERCASE end

	x = x or 0
	y = y or 0
	flags = flags or 0
	alignment = alignment or "left"
	max_width = max_width or 0

	local fixed = alignment:find("fixed") and true or false
	local small = alignment:find("small") and true or false
	local thin  = alignment:find("thin")  and true or false

	local align = "left"
	align = (alignment:find("right") and "right") or align
	align = (alignment:find("center") and "center") or align

	x = (fixed and x) or x * FU
	y = (fixed and y) or y * FU

	local base_scale = (small and FU/2) or FU
	local hscale = (thin == true and base_scale - (base_scale / 3)) or base_scale
	local vscale = base_scale

	max_width = max_width * FU

	local color = nil
	for _, c in ipairs(colors) do
		if (flags & c) then
			color = v.getStringColormap(c)
			break
		end
	end

	local space_width = 4 * hscale

	-- 1) First, let's break down the characters into tokens: word / space / newline
	local tokens = {}
	local current_word = {}

	local function push_current_word()
		if #current_word > 0 then
			-- compute width and height for the word
			local w = 0
			local h = 0
			for _, ch in ipairs(current_word) do
				w = w + (ch.width * hscale)
				if ch.patch and ch.patch.height then
					h = max(h, ch.patch.height)
				end
			end
			table.insert(tokens, { type = "word", chars = current_word, width = w, height = h })
			current_word = {}
		end
	end

	for _, ch in ipairs(cache_t.chars) do
		if ch.patch == "newline" then
			-- push pending word and explicit newline token
			push_current_word()
			table.insert(tokens, { type = "newline" })
		elseif ch.patch == "space" then
			-- push pending word then a space token
			push_current_word()
			table.insert(tokens, { type = "space", width = space_width })
		else
			-- part of a word
			table.insert(current_word, ch)
		end
	end
	-- push any trailing word
	push_current_word()

	-- 2) Place the tokens in rows, taking into account the requirement: the word is transferred in its entirety.
	local lines = {}
	local current_line = { chars = {}, width = 0, height = 0 }

	local function push_line()
		table.insert(lines, current_line)
		current_line = { chars = {}, width = 0, height = 0 }
	end

	for _, tok in ipairs(tokens) do
		if tok.type == "newline" then
			-- forced line break: push the current line (even if empty) and start a new one
			push_line()
		elseif tok.type == "space" then
			-- skip leading spaces
			if #current_line.chars == 0 then
				-- skip
			else
				-- if the space does not fit — line break (and the space is not transferred)
				if max_width > 0 and current_line.width + tok.width > max_width then
					push_line()
				else
					-- add a space as a fictitious character
					table.insert(current_line.chars, { __space = true, width = tok.width })
					current_line.width = current_line.width + tok.width
				end
			end
		elseif tok.type == "word" then
			-- if the word does not fit in the current line
			if max_width > 0 and current_line.width + tok.width > max_width then
				-- if the current string is empty, add the word anyway (it will exceed max_width)
				if #current_line.chars == 0 then
					-- insert a word into an empty line
					for _, ch in ipairs(tok.chars) do
						table.insert(current_line.chars, ch)
						current_line.width = current_line.width + ch.width * hscale
						if ch.patch and ch.patch.height then
							current_line.height = max(current_line.height, ch.patch.height)
						end
					end
				else
					-- move the entire word to a new line
					push_line()
					for _, ch in ipairs(tok.chars) do
						table.insert(current_line.chars, ch)
						current_line.width = current_line.width + ch.width * hscale
						if ch.patch and ch.patch.height then
							current_line.height = max(current_line.height, ch.patch.height)
						end
					end
				end
			else
				-- the word fits in the current line — add
				for _, ch in ipairs(tok.chars) do
					table.insert(current_line.chars, ch)
					current_line.width = current_line.width + ch.width * hscale
					if ch.patch and ch.patch.height then
						current_line.height = max(current_line.height, ch.patch.height)
					end
				end
			end
		end
	end

	-- push last line
	push_line()

	-- 3) Drawing lines with individual alignment
	local draw_y = y
	for _, line in ipairs(lines) do
		local line_h = line.height
		if line_h == 0 then
			-- spare height (approximate) so that the lines have a pitch
			line_h = 8
		end

		local line_w = line.width

		local start_x = x
		if align == "right" then
			start_x = x - line_w
		elseif align == "center" then
			start_x = x - (line_w / 2)
		end

		local cursor_x = start_x
		for _, ch in ipairs(line.chars) do
			if ch.__space then
				cursor_x = cursor_x + ch.width
			else
				local color_word = ch.color or color
				
				local vscale_c = vscale
				local hscale_c = hscale
				
				if ch.height > 8 then
					hscale_c = (hscale/ch.width) * 8
					vscale_c = (vscale/ch.height) * 8
				end
				
				if thin then
					v.drawStretched(cursor_x, draw_y, hscale_c, vscale_c, ch.patch, flags, color_word)
				else
					v.drawScaled(cursor_x, draw_y, vscale_c, ch.patch, flags, color_word)
				end
				cursor_x = cursor_x + ch.width * hscale_c
			end
		end

		draw_y = draw_y + (line_h * vscale)
	end
	
	return draw_y/FU
end

return true -- End of File
