local LC = LithiumCore

local unicode = unicode

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

local dash

function LC.functions.drawString(v, x, y, cache_t, flags, alignment, max_width)
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
	
	if (flags & V_ALLOWLOWERCASE) then flags = $ - V_ALLOWLOWERCASE end
	
	x = x or 0
	y = y or 0
	flags = flags or 0
	alignment = alignment or "left"
	
	local fixed = ( alignment:find("fixed") and true) or false
	local small = ( alignment:find("small") and true) or false
	local thin  = alignment:find("thin")  and true or false
	
	local align = "left"
	align = ( alignment:find("right") and "right") or align
	align = ( alignment:find("center") and "center") or align
	
	x = (fixed == true and x) or x*FU
	y = (fixed == true and y) or y*FU
	
	local scale = (small == true and FU/2) or FU
	
	local base_scale = (small and FU/2) or FU
	local hscale = (thin == true and base_scale - (base_scale / 3)) or base_scale
	local vscale = base_scale
	
	local w = cache_t.width_text*hscale
	x = (align == "left" and x) or x
	x = (align == "right" and x-w) or x
	x = (align == "center" and x-(w/2)) or x
	
	local color = nil
	
	for _, c in ipairs(colors) do
		if (flags & c) then color = v.getStringColormap(c) break end
	end
	
	local width_text  = 0
	local height_text = 0
	
	for _, char in ipairs(cache_t.chars) do
		-- Skip spaces to improve performance
		if char.patch == "space" then width_text = $ + char.width*scale continue end
		
		if char.patch == "newline" then
			y = $ + height_text*FU
			height_text, width_text = 0, 0
			continue
		end
		
		local c_color = char.color or color
		
		--[[local scale_c = scale
		if char.height > 8 then
			scale_c = (scale/char.height) * 8
		end
		
		v.drawScaled(x+width_text, y, scale_c, char.patch, flags, color)]]
		local vscale_c = vscale
		local hscale_c = hscale
		
		if char.height > 8 then
			hscale_c = (hscale/char.width) * 8
			vscale_c = (vscale/char.height) * 8
		end
		
		if max_width and (max_width-9)*FU < width_text + char.width*hscale_c then
			for i = 1, 3 do
				if thin then
					v.drawStretched(x+width_text, y, hscale_c, vscale_c, v.cachePatch("TNYFN046"), flags, c_color)
				else
					v.drawScaled(x+width_text, y, vscale_c, v.cachePatch("TNYFN046"), flags, c_color)
				end
			end
			break
		end
		
		if thin then
			v.drawStretched(x+width_text, y, hscale_c, vscale_c, char.patch, flags, c_color)
		else
			v.drawScaled(x+width_text, y, vscale_c, char.patch, flags, c_color)
		end
		width_text = $ + char.width*hscale_c
		height_text = max(height_text, char.patch.height)
	end
	
	return (cache_t.width_text*hscale)/FU
end

return true -- End of File
