-- totp.lua
-- TOTP module for SRB2 / Lua environments
-- Depends on sha1.lua providing hmac_sha1(keyBytesString, messageBytesString)
-- Usage: local totp = dofile('totp.lua')
--        local code = totp.generate("lithiumcore", 1757666113)        -- autodetects key format
--        local code = totp.generate_with_format("infostart", "ascii", 1757666113)

local RNG = RNG

local _M = {}

-- Helper: 8-byte big-endian counter
local function counter_be64(n)
    local t = {}
    for i = 7, 0, -1 do
        local denom = 256 ^ i
        local b = (n / denom) % 256
        t[#t+1] = string.char(b)
    end
    return table.concat(t)
end

local function u32_from_bytes(b1,b2,b3,b4)
    return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4
end

-- hex string (even length) -> array of byte numbers
local function hex_to_bytes(hexstr)
    if not hexstr or (#hexstr % 2 ~= 0) then return nil end
    local out = {}
    for i = 1, #hexstr, 2 do
        local byte = tonumber(hexstr:sub(i,i+1), 16)
        if byte == nil then return nil end
        out[#out+1] = byte
    end
    return out
end

-- base32 (RFC4648) decoder (accepts upper/lower, ignores '=')
local function base32_decode(s)
    if not s then return nil end
    s = s:gsub('%s+', ''):gsub('=', '')
    local alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567'
    local map = {}
    for i=1,#alphabet do map[alphabet:sub(i,i)] = i-1 end
    for k,v in pairs(map) do map[k:lower()] = v end

    local bits = 0
    local val = 0
    local out = {}
    for i = 1, #s do
        local ch = s:sub(i,i)
        local v = map[ch]
        if v == nil then return nil end
        val = val * 32 + v
        bits = bits + 5
        while bits >= 8 do
            bits = bits - 8
            local byte = (val / (2^bits)) % 256
            table.insert(out, byte)
            val = val % (2^bits)
        end
    end
    return out
end

local function bytes_to_str(tbl)
    local t = {}
    for i=1,#tbl do t[#t+1] = string.char(tbl[i]) end
    return table.concat(t)
end

-- Normalize HMAC output to array of bytes
local function normalize_hash_to_bytes(raw)
    if not raw then return nil, "nil hmac" end
    -- Case: binary 20-byte digest
    if #raw == 20 then
        local out = {}
        for i=1,20 do out[i] = raw:byte(i) end
        return out
    end
    -- Case: hex 40-char digest
    if #raw == 40 and raw:match('^%x+$') then
        return hex_to_bytes(raw)
    end
    -- Fallback: try to hex-encode arbitrary binary raw and parse
    if #raw > 0 then
        local hex = {}
        for i=1,#raw do hex[#hex+1] = string.format('%02x', raw:byte(i)) end
        local hb = hex_to_bytes(table.concat(hex))
        if hb then return hb end
    end
    -- Also accept if raw itself looks like hex without exact length
    if raw:match('^%x+$') then
        local hb = hex_to_bytes(raw)
        if hb then return hb end
    end
    return nil, "unsupported hmac format len=" .. tostring(#raw)
end

-- Key normalization: returns Lua string of raw bytes and a format name
local function normalize_key_to_bytes(secret)
    if type(secret) ~= 'string' then return nil, nil end
    -- try base32 (characters A-Z2-7 and '=' allowed)
    if secret:match('^[A-Za-z2-7=]+$') and #secret >= 8 then
        local bs = base32_decode(secret)
        if bs then return bytes_to_str(bs), 'base32' end
    end
    -- try hex
    if secret:match('^[0-9a-fA-F]+$') and (#secret % 2 == 0) and #secret >= 2 then
        local hb = hex_to_bytes(secret)
        if hb then return bytes_to_str(hb), 'hex' end
    end
    -- fallback: raw ASCII bytes
    return secret, 'ascii'
end

-- Compute OTP from keybytes (Lua string of bytes)
local function compute_otp_from_keybytes(hmac_fn, keybytes, timestamp, period)
    local counter = (timestamp / period)
    local msg = counter_be64(counter)
    -- secure hmac call (to avoid crashing when an error occurs inside hmac)
    local ok, raw_or_err = pcall(hmac_fn, keybytes, msg)
    if not ok then
        return nil, "hmac function error: " .. tostring(raw_or_err)
    end
    local raw = raw_or_err
    local hb, err = normalize_hash_to_bytes(raw)
    if not hb then
        return nil, err
    end
    if #hb < 20 then return nil, "hmac bytes too short" end
    local offset = hb[20] % 16
    local i = offset + 1
    local p1,p2,p3,p4 = hb[i], hb[i+1], hb[i+2], hb[i+3]
    if (p1 and p2 and p3 and p4) == nil then return nil, "insufficient hash bytes" end
    local p1m = p1 % 128 -- clear top bit
    local full32 = u32_from_bytes(p1m,p2,p3,p4)
    local otp = full32 % 1000000
    return string.format('%06d', otp), {offset=offset, part=string.format('%02X %02X %02X %02X', p1,p2,p3,p4), full32=full32, raw=raw}
end

-- Public: generate OTP (autodetect key format)
-- hmac_module: table or function, if nil uses dofile('sha1.lua').hmac_sha1
function _M.generate(secret_input, timestamp, period, hmac_module)
    period = period or 30
    timestamp = timestamp or os.time()
    local hmac_fn
    if type(hmac_module) == 'function' then hmac_fn = hmac_module
    elseif type(hmac_module) == 'table' and type(hmac_module.hmac_sha1) == 'function' then hmac_fn = hmac_module.hmac_sha1
    else
        local ok, sha = pcall(dofile, 'sha1.lua')
        if not ok or not sha or type(sha.hmac_sha1) ~= 'function' then return nil, 'no hmac_sha1 available' end
        hmac_fn = sha.hmac_sha1
    end

    local keybytes, kind = normalize_key_to_bytes(secret_input)
    if not keybytes then return nil, 'failed to normalize key' end
    local otp, info = compute_otp_from_keybytes(hmac_fn, keybytes, timestamp, period)
    return otp, info, kind
end

-- Public: generate forcing a known key format ("ascii", "hex", "base32")
function _M.generate_with_format(secret_input, format, timestamp, period, hmac_module)
    local keybytes
    if format == 'ascii' then keybytes = secret_input
    elseif format == 'hex' then local hb = hex_to_bytes(secret_input); if not hb then return nil, 'invalid hex'; end; keybytes = bytes_to_str(hb)
    elseif format == 'base32' then local bb = base32_decode(secret_input); if not bb then return nil, 'invalid base32'; end; keybytes = bytes_to_str(bb)
    else return nil, 'unknown format' end
    period = period or 30
    timestamp = timestamp or os.time()
    local ok, sha = pcall(dofile, 'sha1.lua')
    local hmac_fn
    if type(hmac_module) == 'function' then hmac_fn = hmac_module
    elseif type(hmac_module) == 'table' and type(hmac_module.hmac_sha1) == 'function' then hmac_fn = hmac_module.hmac_sha1
    else
        if not ok or not sha or type(sha.hmac_sha1) ~= 'function' then return nil, 'no hmac_sha1 available' end
        hmac_fn = sha.hmac_sha1
    end
    return compute_otp_from_keybytes(hmac_fn, keybytes, timestamp, period)
end

function _M.time_remaining(period, timestamp)
    period = period or 30
    timestamp = timestamp or os.time()
    local elapsed = timestamp % period
    return period - elapsed
end

-- Generates a secret of length `len` (default is 16)
function _M.gen_totp_secret(len)
    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
    len = len or 16
    if len < 16 then len = 16 end -- minimum 8 characters for security
    local parts = {}
    for i = 1, len do
        local idx = RNG.RandomRange(1, #alphabet)
        parts[i] = alphabet:sub(idx, idx)
    end
    return table.concat(parts)
end

function _M.make_otpauth_uri(secret, account, issuer)
    account = account or "user"
    if issuer and issuer ~= "" then
        -- Encode spaces/characters securely (simple URL encoding)
        local function urlencode(str)
            str = tostring(str)
            str = str:gsub("([^%w%-_%.~])", function(c) return string.format("%%%02X", string.byte(c)) end)
            return str
        end
        local label = urlencode(issuer) .. ":" .. urlencode(account)
        local params = "secret=" .. tostring(secret) .. "&issuer=" .. urlencode(issuer)
        return "otpauth://totp/" .. label .. "?" .. params
    else
        return "otpauth://totp/" .. account .. "?secret=" .. tostring(secret)
    end
end

function _M.verify_totp(secret, code, timestep, period, skew, hmac_sha1)
	if not secret or not code then return false end
	
	timestep = timestep or os.time()
    skew = skew or 1 -- 1 = check [-1,0,+1], 2 is possible for a minute
	period = period or 30
	
    for i = -skew, skew do
		local time = timestep + (period * i)
        local test_code = _M.generate(secret, time, period, hmac_sha1)
        if test_code == code then
            return true
        end
    end
    return false
end

function _M.gen_backup_codes(count, length)
    count = count or 10       -- 10 codes by default
    length = length or 8      -- default length 8
    local charset = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
    local chars_len = #charset
    local codes = {}

    for i = 1, count do
        local t = {}
        for j = 1, length do
            local idx = RNG.RandomRange(1, chars_len)
            t[j] = charset:sub(idx, idx)
        end
        codes[i] = table.concat(t)
    end
    return codes
end

_M.__VERSION = "0.2"

-- Expose helpers optionally
_M._helpers = {
    normalize_key_to_bytes = normalize_key_to_bytes,
    base32_decode = base32_decode,
    hex_to_bytes = hex_to_bytes,
    counter_be64 = counter_be64,
}

return _M
