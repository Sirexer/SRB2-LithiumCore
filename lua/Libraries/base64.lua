-- 
-- base64.lua - Library by Sirexer
--
-- Encodes a binary file to base64 format and back.
--

local base64 = {}
local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

-- Tables for optimization
local byte_to_bits = {}
for i=0,255 do
    local s = ''
    for j=7,0,-1 do
        s = s .. (i % 2^(j+1) - i % 2^j > 0 and '1' or '0')
    end
    byte_to_bits[i] = s
end

local bits_to_char = {}
for i=0,63 do
    local s = ''
    for j=6,1,-1 do
        s = s .. (i % 2^j - i % 2^(j-1) > 0 and '1' or '0')
    end
    bits_to_char[s] = b:sub(i+1,i+1)
end

-- Binary string to Base64
function base64.encode(data)
    local bits = {}
    for i=1,#data do
        bits[#bits+1] = byte_to_bits[data:byte(i)]
    end
    local bitstr = table.concat(bits)
    local res = {}
    for i=1,#bitstr,6 do
        local chunk = bitstr:sub(i,i+5)
        if #chunk < 6 then
            chunk = chunk .. string.rep('0', 6-#chunk)
        end
        res[#res+1] = bits_to_char[chunk]
    end
    local pad = ({ '', '==', '=' })[#data % 3 + 1]
    return table.concat(res) .. pad
end

-- Base64 to binary string
function base64.decode(data)
    data = data:gsub('[^'..b..'=]', '')
    local bits = {}
    for i=1,#data do
        local c = data:sub(i,i)
        if c ~= '=' then
            local index = b:find(c)-1
            local s = ''
            for j=6,1,-1 do
                s = s .. (index % 2^j - index % 2^(j-1) > 0 and '1' or '0')
            end
            bits[#bits+1] = s
        end
    end
    local bitstr = table.concat(bits)
    local res = {}
    for i=1,#bitstr,8 do
        local byte = bitstr:sub(i,i+7)
        if #byte == 8 then
            local val = 0
            for j=1,8 do
                if byte:sub(j,j) == '1' then
                    val = val + 2^(8-j)
                end
            end
            res[#res+1] = string.char(val)
        end
    end
    return table.concat(res)
end

return base64
