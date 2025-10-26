local LC = LithiumCore

local allowed = {}
for i = 32, 126 do
    allowed[string.char(i)] = true
end

function LC.functions.filterPrintable(str)
    local result = {}
    for i = 1, #str do
        local c = str:sub(i,i)
        if allowed[c] then
            table.insert(result, c)
        end
    end
    return table.concat(result)
end

return true -- End Of File
