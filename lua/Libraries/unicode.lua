-- Tables for converting Unicode characters to upper and lower case
local UnicodeUpperMap = {
	-- Latin basic
	["a"]="A", ["b"]="B", ["c"]="C", ["d"]="D", ["e"]="E", ["f"]="F", ["g"]="G",
	["h"]="H", ["i"]="I", ["j"]="J", ["k"]="K", ["l"]="L", ["m"]="M", ["n"]="N",
	["o"]="O", ["p"]="P", ["q"]="Q", ["r"]="R", ["s"]="S", ["t"]="T", ["u"]="U",
	["v"]="V", ["w"]="W", ["x"]="X", ["y"]="Y", ["z"]="Z",

	-- Cyrillic
	["а"]="А", ["б"]="Б", ["в"]="В", ["г"]="Г", ["д"]="Д", ["е"]="Е", ["ё"]="Ё",
	["ж"]="Ж", ["з"]="З", ["и"]="И", ["й"]="Й", ["к"]="К", ["л"]="Л", ["м"]="М",
	["н"]="Н", ["о"]="О", ["п"]="П", ["р"]="Р", ["с"]="С", ["т"]="Т", ["у"]="У",
	["ф"]="Ф", ["х"]="Х", ["ц"]="Ц", ["ч"]="Ч", ["ш"]="Ш", ["щ"]="Щ", ["ъ"]="Ъ",
	["ы"]="Ы", ["ь"]="Ь", ["э"]="Э", ["ю"]="Ю", ["я"]="Я",

	-- Ukrainian / Belarusian
	["ґ"]="Ґ", ["ї"]="Ї", ["і"]="І", ["є"]="Є", ["ў"]="Ў",

	-- Polish / Czech / Slovak / Hungarian
	["ą"]="Ą", ["ć"]="Ć", ["ę"]="Ę", ["ł"]="Ł", ["ń"]="Ń",
	["ś"]="Ś", ["ź"]="Ź", ["ż"]="Ż", ["ó"]="Ó",
	["ř"]="Ř", ["š"]="Š", ["ť"]="Ť", ["ž"]="Ž", ["ý"]="Ý", ["ů"]="Ů",

	-- Portuguese / Spanish / French / German
	["á"]="Á", ["à"]="À", ["ã"]="Ã", ["â"]="Â", ["ä"]="Ä", ["å"]="Å",
	["æ"]="Æ", ["ç"]="Ç", ["é"]="É", ["è"]="È", ["ê"]="Ê", ["ë"]="Ë",
	["í"]="Í", ["ì"]="Ì", ["î"]="Î", ["ï"]="Ï", ["ñ"]="Ñ",
	["ó"]="Ó", ["ò"]="Ò", ["õ"]="Õ", ["ô"]="Ô", ["ö"]="Ö", ["ø"]="Ø", ["œ"]="Œ",
	["ú"]="Ú", ["ù"]="Ù", ["û"]="Û", ["ü"]="Ü", ["ß"]="SS",

	-- Turkish
	["ç"]="Ç", ["ğ"]="Ğ", ["ı"]="I", ["i"]="I", ["ö"]="Ö", ["ş"]="Ş", ["ü"]="Ü",

	-- Greek (basic uppercase)
	["α"]="Α", ["β"]="Β", ["γ"]="Γ", ["δ"]="Δ", ["ε"]="Ε", ["ζ"]="Ζ", ["η"]="Η",
	["θ"]="Θ", ["ι"]="Ι", ["κ"]="Κ", ["λ"]="Λ", ["μ"]="Μ", ["ν"]="Ν", ["ξ"]="Ξ",
	["ο"]="Ο", ["π"]="Π", ["ρ"]="Ρ", ["σ"]="Σ", ["ς"]="Σ", ["τ"]="Τ", ["υ"]="Υ",
	["φ"]="Φ", ["χ"]="Χ", ["ψ"]="Ψ", ["ω"]="Ω"
}

-- Lowercase map
local UnicodeLowerMap = {}
for lower, upper in pairs(UnicodeUpperMap) do
	if upper ~= "SS" then
		UnicodeLowerMap[upper] = lower
	end
end

-- Unicode upper
local function unicode_upper(str)
	local result = {}
    local i = 1
    while i <= #str do
        local byte = string.byte(str, i)
        local len = 1

        if byte >= 0xF0 then len = 4
        elseif byte >= 0xE0 then len = 3
        elseif byte >= 0xC0 then len = 2 end

        local char = string.sub(str, i, i + len - 1)
        local upper = UnicodeUpperMap[char] or char
        table.insert(result, upper)
        i = i + len
    end
    return table.concat(result)
end

-- Unicode lower
local function unicode_lower(str)
	local result = {}
    local i = 1
    while i <= #str do
        local byte = string.byte(str, i)
        local len = 1

        if byte >= 0xF0 then len = 4
        elseif byte >= 0xE0 then len = 3
        elseif byte >= 0xC0 then len = 2 end

        local char = string.sub(str, i, i + len - 1)
        local lower = UnicodeLowerMap[char] or char
        table.insert(result, lower)
        i = i + len
    end
    return table.concat(result)
end

return {upper = unicode_upper, lower = unicode_lower}
