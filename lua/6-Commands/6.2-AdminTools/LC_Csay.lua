local LC = LithiumCore

LC.commands["csay"] = {
	name = "LC_csay",
	perm = "LC_csay",
	useonself = false,
	useonhost = true,
	onlyhighpriority = false
}

LC.functions.RegisterCommand("csay", LC.commands["csay"])

LC.functions.AddCommandMenu({
	name = "LC_CMD_CSAY",
	description = "LC_CMD_CSAY_TIP",
	command = "csay",
	confirm = "Send",
	args = {
		{header = "Message", type = "text", optional = true}
	}
})

COM_AddCommand(LC.serverdata.commands["csay"].name, function(player, ...)
	local sets = LC.serverdata.commands["csay"]
	local DoIHavePerm = false
	if not player.group and server != player
		CONS_Printf(player, LC.shrases.noperm)
		return
	end
	DoIHavePerm = LC.functions.CheckPerms(player, sets.perm)
	if DoIHavePerm != true
		CONS_Printf(player, LC.shrases.noperm)
		return
	end
    if not ...
        CONS_Printf(player, sets.name.." <msg>: displays the message separately from the message box.")
        return
    end
	
	local pname = ""
	if player.mo and player.mo.valid
		local chatcolor = 0
		for i in ipairs(LC.colormaps) do
			if LC.colormaps[i].value == skincolors[player.skincolor].chatcolor
				chatcolor = LC.colormaps[i].hex
			end
		end
		pname = chatcolor..player.name.."\x80"
	else
		pname = "\x86"..player.name.."\x80"
	end
	local text = ""
	for _, v in ipairs({...}) do
		text = text..v.." "
	end
	text = text:sub(1, text:len()-1)
	for mc=1, #LC.macrolist do 
		for t = 1, #LC.macrolist[mc].text do
			text = string.gsub(text, LC.macrolist[mc].text[t], LC.macrolist[mc].color)
		end
	end
	if DiscordBot and DiscordBot.Data and DiscordBot.Data.msgsrb2
		local msgdiscord = "CSAY Message from "..pname..": "..text
		local formated = ""
		for i = 1, msgdiscord:len() do
			if msgdiscord:sub(i,i):byte() > 32 and msgdiscord:sub(i,i):byte() < 127 or msgdiscord:sub(i,i) == " "
				formated = formated..msgdiscord:sub(i,i)
			end
		end
		DiscordBot.Data.msgsrb2 = DiscordBot.Data.msgsrb2..formated.."\n"
	end
	LC.functions.sendcsay(pname, text, true)
	return true
end)

return true
