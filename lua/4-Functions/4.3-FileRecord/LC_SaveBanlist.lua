local LC = LithiumCore

local json = json //LC_require "json.lua"

LC.functions.SaveBanlist = function()
	if not isserver then return end
	local ids = 0
	local str = "[\n"
	if LC.serverdata.banlist[1]
		for i = 1, #LC.serverdata.banlist do
			local player = ""
			if LC.serverdata.banlist[i]
				local t = LC.serverdata.banlist[i]
				local id = "null"
				if t.id then id = "\""..t.id.."\"" end
				local name = "null"
				if t.name then name = "\""..t.name.."\"" end
				local username = "null"
				if t.username then username = "\""..t.username.."\"" end
				local unban = "null"
				if t.timestamp_unban then unban = t.timestamp_unban end
				player = ""
				player = "    {\n"
				player = player.."        \"id\": "..tostring(id)..",\n"
				player = player.."        \"name\": "..tostring(name)..",\n"
				player = player.."        \"username\": "..tostring(username)..",\n"
				player = player.."        \"timestamp_unban\": "..unban..",\n"
				player = player.."        \"reason\": \""..t.reason.."\",\n"
				player = player.."        \"moderator\": \""..t.moderator.."\"\n    }" 
			end
			if ids == 0
				str = str..player
			else
				str = str..",\n"..player
			end
			ids = $ + 1
		end
		str = str.."\n]"
	else
		str = ""
	end
	local banlist_file = io.openlocal(LC.serverdata.folder.."/banlist.cfg", "w")
	banlist_file:write(str)
	banlist_file:close()
	return str
end

return true
