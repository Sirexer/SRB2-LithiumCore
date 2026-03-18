local LC = LithiumCore

local function warn(msg)
	print("\x82".."WARNING".."\x80"..". "..msg)
end

LC.functions.addTextLanguage = function(t)
	if not t then
		warn("[addTextLanguage] Input table is nil")
		return
	end
	
	if type(t) ~= "table" then
		warn("[addTextLanguage] Expected table, got " .. type(t))
		return
	end
	
	for lang, texts_t in pairs(t) do
		if not LC.language[lang] then
			warn("Language '" .. tostring(lang) .. "' does not exist")
			continue
		end
		
		if type(texts_t) ~= "table" then
			warn("Language '" .. tostring(lang) .. "' is not a table (got " .. type(texts_t) .. ")")
			continue
		end
		
		for ID, text in pairs(texts_t) do
			if type(ID) ~= "string" then
				warn("Invalid ID type in '" .. lang .. "': expected string, got " .. type(ID))
				continue
			end
			
			if type(text) ~= "string" then
				warn("Invalid text for ID '" .. tostring(ID) .. "' in '" .. lang .. "': expected string, got " .. type(text))
				continue
			end
			
			LC.language[lang][ID] = text
		end
	end
end

return true -- End of File
