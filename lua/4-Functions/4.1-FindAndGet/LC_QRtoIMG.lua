local LC = LithiumCore

function LC.functions.QRtoIMG(qr, border)
    border = border or 1
    local size = #qr
    local t = {}
    t.height = size + border * 2
    t.width  = size + border * 2
    t.pixels = {}

    for y = 1, t.height do
        t.pixels[y] = {}
        for x = 1, t.width do
            if x <= border or y <= border or x > size + border or y > size + border then
                t.pixels[y][x] = 1
            else
                local b = qr[y - border][x - border]
                t.pixels[y][x] = (b > 0 and 31) or 0
            end
        end
    end

    return t
end

return true
