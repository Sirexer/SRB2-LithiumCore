-- tea.lua
-- TEA (64-bit block, 128-bit key) + Encrypt-then-MAC (HMAC-SHA1)
-- Optimized for SRB2 Lua bitwise operators: << >> ^^ & | ~
-- Requires: hmac_sha1(key, data) available in the environment (returns raw 20-byte binary).
-- If hmac_sha1 returns hex, use hex_to_raw helper (provided).

local sha1 = sha1
local hmac_sha1 = hmac_sha1 or sha1.hmac_sha1

local M = {}

local MASK32 = 0xFFFFFFFF
local DELTA = 0x9E3779B9

-- ---------- utils ----------
local function to_u32(n)
  -- mask to 32 bits
  return n & MASK32
end

local function bytes_to_u32_be(s, pos)
  pos = pos or 1
  local a = string.byte(s, pos) or 0
  local b = string.byte(s, pos+1) or 0
  local c = string.byte(s, pos+2) or 0
  local d = string.byte(s, pos+3) or 0
  return to_u32(((a * 256 + b) * 256 + c) * 256 + d)
end

local function u32_to_bytes_be(x)
  x = to_u32(x)
  local a = (x >> 24) & 0xFF
  local b = (x >> 16) & 0xFF
  local c = (x >> 8)  & 0xFF
  local d = x & 0xFF
  return string.char(a,b,c,d)
end

-- hex -> raw (helper)
local function hex_to_raw(hex)
  if not hex then return nil end
  hex = hex:gsub("%s+","")
  if (#hex % 2) ~= 0 then return nil, "bad hex len" end
  return (hex:gsub("..", function(cc) return string.char(tonumber(cc,16)) end))
end

-- constant-time equals
local function const_eq(a,b)
  if #a ~= #b then return false end
  local r = 0
  for i=1,#a do r = r | (string.byte(a,i) ^^ string.byte(b,i)) end
  return r == 0
end

-- ---------- TEA block encrypt/decrypt (32 rounds) ----------
local function tea_encrypt_block(v0, v1, k) -- v0,v1 numbers; k = {k1..k4} u32
  local sum = 0
  for i=1,32 do
    sum = to_u32(sum + DELTA)
    local part = to_u32(((v1 << 4) ^^ (v1 >> 5)) + v1)
    local idx = (sum & 3) + 1
    v0 = to_u32(v0 + (part ^^ to_u32(sum + k[idx])))
    part = to_u32(((v0 << 4) ^^ (v0 >> 5)) + v0)
    local idx2 = ((sum >> 11) & 3) + 1
    v1 = to_u32(v1 + (part ^^ to_u32(sum + k[idx2])))
  end
  return v0, v1
end

local function tea_decrypt_block(v0, v1, k)
  local sum = to_u32(DELTA * 32)
  for i=1,32 do
    local part = to_u32(((v0 << 4) ^^ (v0 >> 5)) + v0)
    local idx2 = ((sum >> 11) & 3) + 1
    v1 = to_u32(v1 - (part ^^ to_u32(sum + k[idx2])))
    part = to_u32(((v1 << 4) ^^ (v1 >> 5)) + v1)
    local idx = (sum & 3) + 1
    v0 = to_u32(v0 - (part ^^ to_u32(sum + k[idx])))
    sum = to_u32(sum - DELTA)
  end
  return v0, v1
end

-- ---------- KDF (simple HMAC-based) ----------
-- uses hmac_sha1(master, info) to derive material.
local function hkdf_like(master, info)
  -- if hmac_sha1 returns hex (40 chars) convert to raw
  local ok, raw = pcall(hmac_sha1, master, info)
  if not ok then error("hmac_sha1 not found or errored") end
  if type(raw) ~= "string" then error("hmac_sha1 must return string") end
  if #raw == 40 and raw:match("^%x+$") then
    local r, e = hex_to_raw(raw)
    if not r then error("bad hex from hmac_sha1: "..(e or ""))
    else raw = r end
  end
  return raw -- 20 bytes
end

local function derive_keys(master_key)
  local enc_mat = hkdf_like(master_key, "TEA-enc-key") -- 20 bytes
  local mac_mat = hkdf_like(master_key, "TEA-mac-key") -- 20 bytes
  local kb = enc_mat:sub(1,16) -- 128-bit key
  local k = {}
  for i=1,4 do k[i] = bytes_to_u32_be(kb, (i-1)*4 + 1) end
  return k, mac_mat
end

-- ---------- padding PKCS#7 for 8-byte blocks ----------
local function pkcs7_pad(s, block)
  block = block or 8
  local padlen = block - (#s % block)
  if padlen == 0 then padlen = block end
  return s .. string.rep(string.char(padlen), padlen)
end

local function pkcs7_unpad(s)
  if #s == 0 then return nil, "empty" end
  local last = string.byte(s, #s)
  if last < 1 or last > 8 then return nil, "bad pad" end
  for i = #s - last + 1, #s do
    if string.byte(s, i) ~= last then return nil, "bad pad bytes" end
  end
  return s:sub(1, #s - last)
end

-- ---------- CBC mode (8-byte IV) ----------
-- XOR two equal-length strings
local function xor_bytes(a,b)
  local L = min(#a, #b)
  local t = {}
  for i=1,L do t[i] = string.char( string.byte(a,i) ^^ string.byte(b,i) ) end
  return table.concat(t)
end

-- random_bytes provider (default math.random; user can override)
local _rand_fn = nil
function M.set_random_func(fn) _rand_fn = fn end

local function random_bytes(n)
  if _rand_fn then return _rand_fn(n) end
  local t = {}
  for i=1,n do t[i] = string.char(44) end
  return table.concat(t)
end

local function tea_encrypt_cbc(plaintext, k, iv)
  iv = iv or random_bytes(8)
  local padded = pkcs7_pad(plaintext, 8)
  local out = { iv }
  local prev = iv
  for pos = 1, #padded, 8 do
    local block = padded:sub(pos, pos+7)
    local x = xor_bytes(block, prev)
    local v0 = bytes_to_u32_be(x,1)
    local v1 = bytes_to_u32_be(x,5)
    local c0,c1 = tea_encrypt_block(v0, v1, k)
    local cblock = u32_to_bytes_be(c0) .. u32_to_bytes_be(c1)
    table.insert(out, cblock)
    prev = cblock
  end
  return table.concat(out)
end

local function tea_decrypt_cbc(blob, k)
  if #blob < 8 then return nil, "blob too small" end
  local iv = blob:sub(1,8)
  local out = {}
  local prev = iv
  for pos = 9, #blob, 8 do
    local cblock = blob:sub(pos, pos+7)
    if #cblock < 8 then return nil, "bad length" end
    local c0 = bytes_to_u32_be(cblock,1)
    local c1 = bytes_to_u32_be(cblock,5)
    local v0,v1 = tea_decrypt_block(c0, c1, k)
    local pblock = u32_to_bytes_be(v0) .. u32_to_bytes_be(v1)
    table.insert(out, xor_bytes(pblock, prev))
    prev = cblock
  end
  local plaintext = table.concat(out)
  local ok, res = pcall(pkcs7_unpad, plaintext)
  if not ok then return nil, res end
  return res
end

-- ---------- high level: encrypt-then-mac ----------
function M.encrypt_then_mac(plaintext, master_key)
  if type(plaintext) ~= "string" then error("plaintext must be string") end
  local k_enc, k_mac = derive_keys(master_key)
  local cipher_blob = tea_encrypt_cbc(plaintext, k_enc) -- includes iv
  local tag = hmac_sha1(k_mac, cipher_blob)
  -- support hex output from hmac_sha1 (convert if needed)
  if #tag == 40 and tag:match("^%x+$") then
    local r,e = hex_to_raw(tag)
    if r then tag = r end
  end
  return cipher_blob .. tag
end

function M.verify_and_decrypt(blob_with_tag, master_key)
  if type(blob_with_tag) ~= "string" then error("blob must be string") end
  if #blob_with_tag < 20 + 8 then return nil, "blob too short" end
  local k_enc, k_mac = derive_keys(master_key)
  local tag = blob_with_tag:sub(-20)
  local cipher_blob = blob_with_tag:sub(1, -21)
  local expected = hmac_sha1(k_mac, cipher_blob)
  if #expected == 40 and expected:match("^%x+$") then
    local r,e = hex_to_raw(expected)
    if r then expected = r end
  end
  if not const_eq(expected, tag) then return nil, "MAC mismatch" end
  return tea_decrypt_cbc(cipher_blob, k_enc)
end

-- expose helpers (useful for testing)
M._tea_encrypt_block = tea_encrypt_block
M._tea_decrypt_block = tea_decrypt_block
M._derive_keys = derive_keys
M._hex_to_raw = hex_to_raw

return M
