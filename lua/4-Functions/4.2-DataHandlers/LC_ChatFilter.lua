local LC = LithiumCore

-- escape Lua pattern magic characters inside user words
local function escape_magic(s)
    return (s:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1"))
end

-- table of possible replacements
local charmap = {
    a = "[aA@4]",
    b = "[bB8]",
    e = "[eE3]",
    g = "[gG9]",
    i = "[iIl1!|]",
    o = "[oO0]",
    s = "[sS$5]",
    t = "[tT7+]",
}

-- build a pattern for a word, taking into account replacements and spaces
local function build_spaced_pattern(word_lower)
    local out = ""
    for i = 1, #word_lower do
        local c = word_lower:sub(i,i)
        local patt = charmap[c] or ("[" .. c:upper() .. c:lower() .. "]") -- if not in the table, then a regular letter
        if i > 1 then
            out = out .. "%s*"
        end
        out = out .. patt
    end
    return out
end

-- replace case-insensitively, matching whole words (with word boundaries),
-- and allowing spaces between letters. Replacement must keep the same length.
local function replace_whole_word_ci(msg, word, make_replacement)
    local low = msg:lower()
    local wlow = escape_magic(word:lower())

    -- word boundaries by "word chars": letters/digits/underscore
    -- (so we don't hit 'night', because 'h' is a word char after 'g')
    local core = build_spaced_pattern(wlow)
    local pattern = "%f[%w]" .. core .. "%f[%W]"

    local i = 1
    local found_any = false
    while true do
        local s, e = low:find(pattern, i)
        if not s then break end

        local orig = msg:sub(s, e)                -- original case + spaces as typed
        local repl = make_replacement(orig, word) -- must be same length as orig
        -- apply replacement both to msg and to low (keep indices aligned)
        msg = msg:sub(1, s-1) .. repl .. msg:sub(e+1)
        low = low:sub(1, s-1) .. string.rep("*", #orig) .. low:sub(e+1)

        i = s + #repl
        found_any = true
    end
    return msg, found_any
end

LC.functions.ChatFilter = function(self, type)
    local msg
	local changed
    local finded = false
    local list = {}
    if self then
        msg = self

        -- BAN WORDS (complete masking *)
        if type == "ban" then
            local banwords = LC.serverdata.banwords
            for w = 1, #banwords do
                local added = false
                msg, changed = replace_whole_word_ci(msg, banwords[w], function(orig)
                    return string.rep("*", #orig)
                end)
                if changed then
                    if not added then
                        table.insert(list, banwords[w])
                        added = true
                    end
                    finded = true
                end
            end
        end

        -- SWEAR WORDS (show the first and last letters)
        if type == "swear" then
            local swearwords = LC.localdata.swearwords
            for s = 1, #swearwords do
                msg, changed = replace_whole_word_ci(msg, swearwords[s], function(orig)
                    local len = #orig
                    if len <= 2 then
                        -- For 1–2 characters, just leave the first/last as is.
                        return orig
                    end
                    -- leave the first and last characters,
                    -- replace everything between them with '*'
                    local first = orig:sub(1,1)
                    local last  = orig:sub(len,len)
                    return first .. string.rep("*", len - 2) .. last
                end)
                if changed then
                    finded = true
                end
            end
        end
    end
    return msg, finded, list
end

return true
