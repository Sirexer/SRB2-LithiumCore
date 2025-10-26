local LC = LithiumCore

local patch_cache = nil

-- initialisation of patch_cache for all 256 colours
local function init_patch_cache(v)
    patch_cache = {}
    for i = 0, 255 do
        local patch_name = string.format("`%03d", i)
        local patch_color = v.cachePatch(patch_name)
        if patch_color then
            patch_cache[i] = { patch = patch_color }
        end
    end
end

-- universal function for HUD
LC.functions.drawScaledIMG = function(v, x_pos, y_pos, img, scale, flags)
    if not img then return end

    local pixel_size = scale or FU
    local pixels_drawn = 0

    -- initialise patch_cache once
    if not patch_cache then
        init_patch_cache(v)
    end

    local gm1 = getTimeMicros()

    for y = 1, img.height do
        local row = img.pixels[y]
        local x_start = 1
        local current_color = row[1]
        local cache = patch_cache[current_color]

        for x = 2, img.width + 1 do
            local color = row[x]
            if color ~= current_color then
                if cache then
                    local run_len = (x - x_start)
                    -- draw a horizontal line of one colour
                    v.drawCropped(
                        x_pos + (x_start - 1) * pixel_size,
                        y_pos + (y - 1) * pixel_size,
                        run_len * pixel_size,
                        pixel_size,
                        cache.patch,
                        flags or 0, nil, -- flags, colormap
                        0, 0, 1*FU, 1*FU
                    )
                    pixels_drawn = pixels_drawn + run_len
                end

                current_color = color
                x_start = x
                cache = patch_cache[current_color]
            end
        end
    end
	
    -- return the number of pixels drawn, if necessary
    return pixels_drawn
end

return true -- End of File
