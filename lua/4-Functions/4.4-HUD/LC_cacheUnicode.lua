local LC = LithiumCore

local cache = {}

--[[
	Function: LC.functions.cacheUnicode
	-----------------------------------
	Converts a UTF-8 string into a cached rendering table for optimized drawing.
	This function parses each Unicode character, determines its corresponding patch,
	and stores all rendering data (width, height, and color) in a structured table.

	Arguments:
		v (video functions)
			- Video rendering context required for patch caching and validation.

		str (string)
			- UTF-8 string to be parsed and converted into cached patches.

	Returns:
		caching (table)
			- A structured table containing rendering cache data:
				• caching.width_text  — total horizontal width of the text in pixels.
				• caching.height_text — maximum character height in pixels.
				• caching.chars       — array of cached character tables:
					{
						patch  = patch reference (or "space"/"newline"),
						color  = colormap data (if active),
						width  = patch width,
						height = patch height
					}

	Description:
		This function is designed for Unicode and multi-byte character strings.
		It automatically handles:
			- UTF-8 multi-length character parsing (1–5 bytes)
			- Spaces and newlines
			- In-text color codes from LC.colormaps
			- Missing or unsupported symbols (skipped)
			- Efficient patch caching via v.cachePatch()
		
		Use this function when drawing text that contains multilingual or special Unicode symbols.
		It should be called only once per string to avoid redundant cache generation every frame.
]]

function LC.functions.cacheUnicode(v, str)
	-- Video context and string are required
	if not v or not str then return end

	local caching = {
		width_text  = 0,
		height_text = 0,
		chars       = {}
	}

	local colormap = nil
	local cur = 1
	local strlen = #str

	while cur <= strlen do
		local s
		local docur = cur

		-- Try to match UTF-8 character length
		if LC.Unicode[str:sub(cur, cur + 4)] then
			s = str:sub(cur, cur + 4)
			cur = $ + 5
		elseif LC.Unicode[str:sub(cur, cur + 3)] then
			s = str:sub(cur, cur + 3)
			cur = $ + 4
		elseif LC.Unicode[str:sub(cur, cur + 2)] then
			s = str:sub(cur, cur + 2)
			cur = $ + 3
		elseif LC.Unicode[str:sub(cur, cur + 1)] then
			s = str:sub(cur, cur + 1)
			cur = $ + 2
		else
			-- Fallback: treat as single byte (ASCII)
			s = str:sub(cur, cur)
			cur = $ + 1
		end

		-- Skip spaces
		if s == " " then
			caching.width_text = $ + 4
			table.insert(caching.chars, {
				patch  = "space",
				color  = nil,
				width  = 4,
				height = 0
			})
			continue
		elseif s == "\n" then
			table.insert(caching.chars, {
				patch  = "newline",
				color  = nil,
				width  = 0,
				height = 0
			})
			continue
		end
		
		-- Handle color codes
		local IsColor = false
		for color in ipairs(LC.colormaps) do
			if LC.colormaps[color].hex == s then
				colormap = v.getStringColormap(LC.colormaps[color].value)
				IsColor = true
				break
			end
		end
		
		-- Skip colors
		if IsColor == true then continue end

		-- Lookup Unicode ID
		local unicode = LC.Unicode and LC.Unicode[s]
		if not unicode then
			-- Unsupported symbol, skip
			continue
		end

		-- Create patch name "U+XXXX"
		local patchname = unicode

		-- Skip if patch missing
		if not v.patchExists(patchname) then
			patchname = "U+10000"
		end

		-- Cache patch
		cache[patchname] = $ or v.cachePatch(patchname)
		local patch = cache[patchname]
		if not patch then continue end

		-- Save patch info
		table.insert(caching.chars, {
			patch  = patch,
			color  = colormap,
			width  = patch.width,
			height = patch.height
		})

		caching.width_text  = $ + patch.width
		caching.height_text = (caching.height_text < patch.height and patch.height) or $
	end

	return caching
end

return true -- End of File
