local function eLC_xorCipher(eLC_text, eLC_key)
    local eLC_result = {}
    local eLC_keylen = #eLC_key

    for eLC_i = 1, #eLC_text do
        local eLC_byte = string.byte(eLC_text, eLC_i)
        local eLC_keybyte = string.byte(eLC_key, ((eLC_i - 1) % eLC_keylen) + 1)
        table.insert(eLC_result, string.char(eLC_byte ^^ eLC_keybyte))
    end

    return table.concat(eLC_result)
end

return eLC_xorCipher -- End of File
