local function strip_ff(hex)
    if #hex == 40 then return hex end
    local cleaned = hex:gsub("ffffffff", "")
    if #cleaned == 40 then return cleaned end
    return hex
end

-- SHA-1
local function sha1(message)
    local mask32 = 0xffffffff

    local function leftrotate(x, n)
        return ((x << n) | (x >> (32 - n))) & mask32
    end

    local length = #message
    local bitlen = length * 8

    -- padding
    message = message .. string.char(0x80)
    while (#message % 64) ~= 56 do
        message = message .. "\0"
    end

    local high = (bitlen / 4294967296)
    local low  = bitlen & mask32
    message = message
        .. string.char((high >> 24) & 0xff, (high >> 16) & 0xff, (high >>  8) & 0xff, high & 0xff,
                       (low  >> 24) & 0xff, (low  >> 16) & 0xff, (low  >>  8) & 0xff, low & 0xff)

    local h0,h1,h2,h3,h4 = 0x67452301,0xEFCDAB89,0x98BADCFE,0x10325476,0xC3D2E1F0

    for chunkStart = 1, #message, 64 do
        local chunk = message:sub(chunkStart, chunkStart+63)
        local w = {}

        for i = 0, 15 do
            local j = i*4 + 1
            local b1,b2,b3,b4 = string.byte(chunk, j, j+3)
            w[i] = ((b1 << 24) | (b2 << 16) | (b3 << 8) | b4) & mask32
        end

        for i = 16, 79 do
            w[i] = leftrotate((w[i-3] ^^ w[i-8] ^^ w[i-14] ^^ w[i-16]) & mask32, 1)
        end

        local a,b,c,d,e = h0,h1,h2,h3,h4

        for i = 0, 79 do
            local f,k
            if i <= 19 then
                f = (b & c) | ((~b) & d)
                k = 0x5A827999
            elseif i <= 39 then
                f = b ^^ c ^^ d
                k = 0x6ED9EBA1
            elseif i <= 59 then
                f = (b & c) | (b & d) | (c & d)
                k = 0x8F1BBCDC
            else
                f = b ^^ c ^^ d
                k = 0xCA62C1D6
            end

            local temp = (leftrotate(a,5) + f + e + k + w[i]) & mask32
            e = d
            d = c
            c = leftrotate(b,30)
            b = a
            a = temp
        end

        h0 = (h0 + a) & mask32
        h1 = (h1 + b) & mask32
        h2 = (h2 + c) & mask32
        h3 = (h3 + d) & mask32
        h4 = (h4 + e) & mask32
    end
	local r = string.format("%08x%08x%08x%08x%08x", h0,h1,h2,h3,h4)
    return strip_ff(r)
end

-- HMAC-SHA1
local function hmac_sha1(key, message)
    local blocksize = 64

    if #key > blocksize then
        key = sha1(key)
        -- sha1 returns a hex string, which needs to be converted back to bytes
        local bin = {}
        for i=1,#key,2 do
            bin[#bin+1] = string.char(tonumber(key:sub(i,i+1),16))
        end
        key = table.concat(bin)
    end

    if #key < blocksize then
        key = key .. string.rep("\0", blocksize - #key)
    end

    local ipad, opad = {}, {}
    for i=1,blocksize do
        local k = key:byte(i)
        ipad[i] = string.char(k ^^ 0x36)
        opad[i] = string.char(k ^^ 0x5c)
    end
    ipad = table.concat(ipad)
    opad = table.concat(opad)

    -- inner = sha1((key ⊕ ipad) .. message) → returns hex, needs to be converted to bytes
    local inner_hex = sha1(ipad .. message)
    local inner_bin = {}
    for i=1,#inner_hex,2 do
        inner_bin[#inner_bin+1] = string.char(tonumber(inner_hex:sub(i,i+1),16))
    end
    inner_bin = table.concat(inner_bin)

    -- outer = sha1((key ⊕ opad) .. inner_bin)
    local result = sha1(opad .. inner_bin)
    return strip_ff(result) -- hex string
end

--[[
-- Tests for SHA-1
local tests = {
    { input = "",       expect = "da39a3ee5e6b4b0d3255bfef95601890afd80709" },
    { input = "a",      expect = "86f7e437faa5a7fce15d1ddcb9eaeaea377667b8" },
    { input = "abc",    expect = "a9993e364706816aba3e25717850c26c9cd0d89d" },
    { input = "message digest",
      expect = "c12252ceda8be8994d5fa0290a47231c1d16aae3" },
    { input = "abcdefghijklmnopqrstuvwxyz",
      expect = "32d10c7b8cf96570ca04ce37f2a19d84240d3a89" },
    { input = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
      expect = "761c457bf73b14d27e9e9265c46f4b4dda11f940" },
    { input = string.rep("a", 1000000), --  "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa..."
      expect = "34aa973cd4c4daa4f61eeb2bdbad27316534016f" }
}

for i, t in ipairs(tests) do
    local got = sha1(t.input)
    if got == t.expect then
        print("Test "..i.." OK")
    else
        print("Test "..i.." FAIL")
        print(" input:  "..t.input:sub(1,50)..( (#t.input > 50) and "..." or "" ))
        print(" expect: "..t.expect)
        print(" got:    "..got)
    end
end

-- Tests for HMAC_SHA1
local tests = {
    {
        key = string.char(0x0b):rep(20),
        msg = "Hi There",
        expect = "b617318655057264e28bc0b6fb378c8ef146be00"
    },
    {
        key = "Jefe",
        msg = "what do ya want for nothing?",
        expect = "effcdf6ae5eb2fa2d27416d5f184df9c259a7c79"
    },
    {
        key = string.char(0xaa):rep(20),
        msg = string.char(0xdd):rep(50),
        expect = "125d7342b9ac11cd91a39af48aa17b4f63f175d3"
    },
    {
        key = string.char(0x0c):rep(20),
        msg = "Test With Truncation",
        expect = "4c1a03424b55e07fe7f27be1d58bb9324a9a5a04"
    },
    {
        key = string.char(0xaa):rep(80),
        msg = "Test Using Larger Than Block-Size Key - Hash Key First",
        expect = "aa4ae5e15272d00e95705637ce8a3b55ed402112"
    },
    {
        key = string.char(0xaa):rep(80),
        msg = "Test Using Larger Than Block-Size Key and Larger Than One Block-Size Data",
        expect = "e8e99d0f45237d786d6bbaa7965c7808bbff1a91"
    }
}

for i, t in ipairs(tests) do
    local got = hmac_sha1(t.key, t.msg)
    if got == t.expect then
        print("HMAC Test "..i.." OK")
    else
        print("HMAC Test "..i.." FAIL")
        print(" expect: "..t.expect)
        print(" got:    "..got)
    end
end
]]--

local M = {
	__VERSION = "0.2",
	sha1 = sha1,
	hmac_sha1 = hmac_sha1
}
return M
