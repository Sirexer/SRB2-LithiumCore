-- 
-- bmp.lua - Library by Sirexer
--
-- Converts from bmp file to table and back. Works in srb2.
--

local bmp = { _version = "0.1" }

local function read_u16_le(str, pos)
    local b1, b2 = string.byte(str, pos, pos+1)
    return b1 + b2 * 256
end

local function read_u32_le(str, pos)
    local b1, b2, b3, b4 = string.byte(str, pos, pos+3)
    return b1 + b2*256 + b3*65536 + b4*16777216
end

bmp.encode = function(img)
    local width, height = img.width, img.height
    local pixels = img.pixels
    local bpp = 24
    local rowSize = (((bpp * width + 31) / 32)) * 4
    local padding = rowSize - width * 3

    local data = {}

    -- BMP header (14 bytes)
    table.insert(data, "BM")  -- signature
    local fileSize = 14 + 40 + rowSize * height
    table.insert(data, string.char(
        fileSize & 0xFF,
        (fileSize >> 8) & 0xFF,
        (fileSize >> 16) & 0xFF,
        (fileSize >> 24) & 0xFF
    ))
    table.insert(data, string.char(0,0,0,0)) -- reserved
    table.insert(data, string.char(54,0,0,0)) -- offset to pixels (14+40)

    -- DIB header (BITMAPINFOHEADER, 40 bytes)
    table.insert(data, string.char(40,0,0,0)) -- header size
    -- width
    table.insert(data, string.char(
        width & 0xFF,
        (width >> 8) & 0xFF,
        (width >> 16) & 0xFF,
        (width >> 24) & 0xFF
    ))
    -- height
    table.insert(data, string.char(
        height & 0xFF,
        (height >> 8) & 0xFF,
        (height >> 16) & 0xFF,
        (height >> 24) & 0xFF
    ))
    table.insert(data, string.char(1,0)) -- planes
    table.insert(data, string.char(bpp,0)) -- bpp
    table.insert(data, string.char(0,0,0,0)) -- compression
    local imageSize = rowSize * height
    table.insert(data, string.char(
        imageSize & 0xFF,
        (imageSize >> 8) & 0xFF,
        (imageSize >> 16) & 0xFF,
        (imageSize >> 24) & 0xFF
    ))
    table.insert(data, string.char(0,0,0,0)) -- XpixelsPerM
    table.insert(data, string.char(0,0,0,0)) -- YpixelsPerM
    table.insert(data, string.char(0,0,0,0)) -- colorsUsed
    table.insert(data, string.char(0,0,0,0)) -- importantColors

    -- Pixels (rows from bottom to top)
    for y = height, 1, -1 do
        for x = 1, width do
            local r, g, b = color.paletteToRgb(pixels[y][x])
            table.insert(data, string.char(b, g, r))
        end
        -- add padding
        for p = 1, padding do
            table.insert(data, string.char(0))
        end
    end

    return table.concat(data)
end


-- small "reader" for string
local function make_reader(data)
    local pos = 1
    local reader = {}

    function reader:read(n)
        local chunk = data:sub(pos, pos + n - 1)
        pos = pos + n
        return chunk
    end

    function reader:seek(whence, offset)
        offset = offset or 0
        if whence == "set" then
            pos = offset + 1
        elseif whence == "cur" then
            pos = pos + offset
        elseif whence == "end" then
            pos = #data + offset + 1
        else
            error("invalid seek mode: " .. tostring(whence))
        end
    end

    function reader:tell()
        return pos - 1
    end

    return reader
end

bmp.decode = function(bin_data)
    local f = make_reader(bin_data)

    -- BMP Header
    local signature = f:read(2)
    if signature ~= "BM" then
        error("Not a BMP file")
    end

    f:read(8) -- skip file size and reserve
    local dataOffset = read_u32_le(f:read(4), 1)

    -- DIB Header
    local headerSize = read_u32_le(f:read(4), 1)
    local width      = read_u32_le(f:read(4), 1)
    local height     = read_u32_le(f:read(4), 1)
    local planes     = read_u16_le(f:read(2), 1)
    local bpp        = read_u16_le(f:read(2), 1)

    if bpp ~= 24 and bpp ~= 32 then
        error("Only 24-bit or 32-bit BMP supported")
    end

    local compression = read_u32_le(f:read(4), 1)
    if compression ~= 0 then
        error("Compressed BMP not supported")
    end

    f:seek("set", dataOffset)

    -- Reading Pixels
    local rowSize = (((bpp * width + 31) / 32)) * 4
    local pixels = {}

    for y = height, 1, -1 do  -- BMP stores lines from bottom to top
        local row = f:read(rowSize)
        pixels[y] = {}
        for x = 1, width do
            local offset = (x - 1) * (bpp / 8)
            local b, g, r, a
            if bpp == 24 then
                b, g, r = string.byte(row, offset + 1, offset + 3)
                a = 255
            else -- 32-bit
                b, g, r, a = string.byte(row, offset + 1, offset + 4)
            end
            pixels[y][x] = color.rgbToPalette(r, g, b)
        end
    end

    return {
        width = width,
        height = height,
        pixels = pixels
    }
end

return bmp
