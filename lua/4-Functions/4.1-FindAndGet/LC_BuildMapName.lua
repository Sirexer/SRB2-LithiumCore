local LC = LithiumCore

-- Converts a map number to its SRB2 extended map name (MAP01..MAPZZ)
-- Always returns a 5-character string: "MAP" + two chars (digits or letters)
-- Example: 1 -> MAP01, 99 -> MAP99, 100 -> MAPA0, 200 -> MAPCS

function LC.functions.BuildMapName(num)
	local tm1 = getTimeMicros()
    if type(num) ~= "number" or num < 1 then
        error("BuildMapName: argument must be a positive integer")
    end

    -- Digits 0–9 + letters A–Z (36 symbols)
    local chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    if num <= 99 then
        return string.format("MAP%02d", num)
    end

    -- For 100 and above, use SRB2 extended logic:
    -- 100 = MAPA0, 101 = MAPA1, ..., 109 = MAPA9, 110 = MAPAA, 111 = MAPAB, etc.
    -- Equivalent to base-36 numbering starting from 100 -> "A0"
    local n = num - 100
    local high = n / #chars
    local low  = n % #chars

    local c1 = chars:sub(high + 11, high + 11) -- start at A for 100
    local c2 = chars:sub(low + 1, low + 1)
    return string.format("MAP%s%s", c1, c2)
end

return true -- End of File
