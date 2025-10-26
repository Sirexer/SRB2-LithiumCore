local LC = LithiumCore

local t = {
	{name = "hook", func = LC.functions.AddHook},
	{name = "vote", func = LC.functions.addVoteType},
	{name = "consvar_menu", func = LC.functions.AddConsVarMenu},
	{name = "commands_menu", func = LC.functions.AddCommandMenu},
	{name = "accountdata", func = LC.functions.AddAccountData},
	{name = "menu", func = LC.functions.AddSubcatMenu},
	{name = "emote", func = LC.functions.AddEmote}
}

if LC_Loaderdata
	local first = getTimeMicros()
	for ld = 1, #t do
		if LC_Loaderdata[t[ld].name]
			while LC_Loaderdata[t[ld].name][1] != nil do
				t[ld].func(LC_Loaderdata[t[ld].name][1])
				table.remove(LC_Loaderdata[t[ld].name], 1)
			end
		end
	end
	local second = getTimeMicros()
	local result = tostring(second-first)
	if string.len(result) > 3
		local dot = string.len(result)-3
		local milli = string.sub(result, 1, dot)
		local micro = string.sub(result, dot+1)
		result = milli.."."..micro
	end
	print("Loading the date takes "..result.."ms")
end

return true
