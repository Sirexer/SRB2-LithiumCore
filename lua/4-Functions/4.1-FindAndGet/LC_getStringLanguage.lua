local LC = LithiumCore

function LC.functions.getStringLanguage(text, lang)
	lang = (LC.language[lang] and lang) or LC.client_consvars["LC_language"].string
	
	local language_t = LC.language[lang] or LC.language["en"]
	local str = language_t[text] or LC.language["en"][text]
	
	str = str or text
	return str
end

return true -- End of File