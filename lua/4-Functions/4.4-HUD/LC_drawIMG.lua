local LC = LithiumCore

LC.functions.drawIMG = function(v, x_pos, y_pos, img, flags)
    if not img then return end

    local pixel_size = 1  -- pixel scale
    local pixels_drawn = 0

    for y = 1, img.height do
        local row = img.pixels[y]
        local x_start = 1
        local current_color = row[1]

        for x = 2, img.width + 1 do
            local color = row[x]
            if color ~= current_color then
                -- draw a horizontal line of one colour
                local line_width = (x - x_start)
                v.drawFill(
                    x_pos + (x_start - 1) * pixel_size,
                    y_pos + (y - 1) * pixel_size,
                    line_width * pixel_size,
                    pixel_size,
                    current_color|flags
                )
                pixels_drawn = pixels_drawn + line_width

                -- new line
                current_color = color
                x_start = x
            end
        end
    end

    -- return the number of pixels drawn, if necessary
    return pixels_drawn
end

return true -- End of File
