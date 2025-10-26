-- These RNG functions are safe for local calls (not synchronized with the server).

local t = {__VERSION = "0.1"}

-- local random seed value
local rr_seed = 123456789

-- Set random seed (uses provided seed or current microsecond time)
function t.RandomSeed(seed)
    rr_seed = (seed and (seed & 0x7FFFFFFF)) or getTimeMicros() or 1
end

-- Generate next random number using linear congruential generator
function t.RandomNext()
    rr_seed = (166451 * rr_seed + 54354354) % INT16_MAX
    return rr_seed
end

function t.seedFromString(str)
    local num = 0
    for c in str:gmatch(".") do
        num = (num * 31 + string.byte(c)) % 2^32
    end
    return num
end

-- Generate random number within specified range [min, max]
function t.RandomRange(min, max)
    if min > max then
        min, max = max, min
    end
    local range = max - min + 1

    -- Update seed
    local r = t.RandomNext() % range
    if r < 0 then
        r = r + range
    end
    return min + r
end

-- Generate random fixed-point number (0 to FRACUNIT-1)
function t.RandomFixed()
    local r = rr_seed % FRACUNIT
    if r < 0 then
        r = r + FRACUNIT
    end
	t.RandomNext()
    return r
end

-- Generate random byte value (0-255)
function t.RandomByte()
    local r = rr_seed % 256
    if r < 0 then
        r = r + 256
    end
	t.RandomNext()
    return r
end

-- Generate random num within range [0, a-1]
function t.RandomKey(a)
    if a <= 0 then
        return 0
    end

    local r = rr_seed % a
    if r < 0 then
        r = r + a
    end
	t.RandomNext()
    return r
end

-- Generate signed random byte value (-128 to 127)
function t.SignedRandom()
    local r = rr_seed % 256
    if r < 0 then
        r = r + 256
    end
	t.RandomNext()
    return r - 128
end

-- Random chance check with probability p (0 to FRACUNIT)
function t.RandomChance(p)
    if p <= 0 then
        return false
    elseif p >= FRACUNIT then
        return true
    end

	 -- Compare random value against probability threshold
    local r = rr_seed % FRACUNIT
    if r < 0 then
        r = r + FRACUNIT
    end
	t.RandomNext()
    return r < p
end

-- Initialize random seed with random value
t.RandomSeed()

return t
