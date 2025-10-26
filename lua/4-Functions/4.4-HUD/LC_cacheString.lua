local LC = LithiumCore

-- Table of available fonts
local fonts = {
	["normal"] = "STCFN",
	["thin"] = "TNYFN",
	["credits"] = "CRFNT"
}

--[[
	Function: LC.functions.cacheString
	----------------------------------
	Prepares a cached text table from a string to optimize rendering.
	This function converts each character into a patch entry (including width, height, and color data)
	and stores them in a structured table that can later be drawn efficiently using LC.functions.scrolledString.

	Arguments:
		v (video functions)
            - Video rendering functions used for drawing.

		str (string)
			- The text string that will be converted into a cache table.

		font_type (string)
			- The font style used for caching.
			  Available options:
			  	"normal"  → Standard SRB2 font ("STCFN")
			  	"thin"    → Thin font ("TNYFN")
			  	"credits" → Credits font ("CRFNT", uppercase only)
			  Defaults to "normal" if an invalid font name is passed.

	Returns:
		caching (table)
			- A table containing cached data for later rendering:
				• caching.font — name of the font used
				• caching.width_text — total width of the rendered string (in pixels)
				• caching.height_text — maximum character height (in pixels)
				• caching.chars — list of cached character data tables:
					{
						patch  = patch reference (or "space" for spaces),
						color  = colormap data (if any),
						width  = patch width,
						height = patch height
					}

	Description:
		This function should be called once per string to avoid expensive per-tick cache operations.
		It handles:
			- Font selection and validation
			- Uppercasing for the "credits" font
			- Color code parsing through LC.colormaps
			- Automatic space width handling
			- Skipping missing or invalid patches
]]

function LC.functions.cacheString(v, str, font_type)
	-- Video functions and the string itself are required.
	if not v and not str then return end
	
	-- Check if the font is available; if not, set the default to ‘normal’.
	font_type = ( fonts[font_type] and font_type ) or "normal"
	local font = fonts[font_type]
	
	-- Preparing a table for caching
	local caching = { font = font_type, width_text = 0, height_text = 0, chars = {} }
	local colormap = nil
	
	-- The ‘credits’ font only supports uppercase
	str = (font_type ~= "credits" and str) or str:upper()
	
	for i = 1, str:len() do
		local patch
		local char = str:sub(i,i)
		
		-- Skip spaces
		if char == " " then caching.width_text = $ + 4; table.insert( caching.chars, {patch = "space", color = nil, width = 4, height = 0} ); continue end
		
		-- Handle color codes
		local IsColor = false
		for color in ipairs(LC.colormaps) do
			if LC.colormaps[color].hex == char then
				colormap = v.getStringColormap(LC.colormaps[color].value)
				IsColor = true
				break
			end
		end
		
		-- Skip colors
		if IsColor == true then continue end
		
		-- Get patchname from byte
		local patchname = ( char:byte() < 100 and font.."0"..char:byte() ) or font..char:byte()
		if not v.patchExists(patchname) then continue end
		patch = v.cachePatch(patchname)
		
		-- Save the font patch to the table
		table.insert( caching.chars, {patch = patch, color = colormap, width = patch.width, height = patch.height} )
		caching.width_text  = $ + patch.width
		caching.height_text = (caching.height_text < patch.height and patch.height) or $
	end
	
	-- Return the cached table
	return caching
end

return true -- End of File
