local LC = LithiumCore

local json = json //LC_require "json.lua"

LC.functions.SaveGroups = function(arg)
	if isserver != true then return end
	local str = "{\n"
	local ids = 0
	if arg == "new"
		LC.serverdata.groups = {
			num = LC.group_default.num,
			list = LC.group_default.list,
			sets = LC.group_default.sets
		}
		local grouporder = json.encode(LC.group_default.num)
		str = str.."\"groupset\": {\n"
		for k, v in pairs(LC.group_default.sets) do
			if type(LC.group_default.sets[k]) == "string"
				local cons = "    \""..k.."\": \""..LC.group_default.sets[k].."\""
				if ids == 0
					str = str..cons
				else
					str = str..",\n"..cons
				end
				ids = $ + 1
			end
		end
		ids = 0
		str = str.."\n},\n"
		str = str.."\"grouporder\": "..grouporder..",\n"
		str = str.."\"groups\": {\n"
		for i = 1, #LC.group_default.num do
			local group = ""
			if LC.group_default.num[i]
				group = ""
				local t = LC.group_default.list[LC.group_default.num[i]]
				group = "    \""..LC.group_default.num[i].."\": {\n"
				//group = group.."        \"name\": \""..t.name.."\",\n"
				group = group.."        \"displayname\": \""..t.displayname.."\",\n"
				group = group.."        \"color\": \""..t.color.."\",\n"
				group = group.."        \"priority\": "..t.priority..",\n"
				group = group.."        \"admin\": "..tostring(t.admin)..",\n"
				group = group.."        \"perms\": "..json.encode(t.perms).."\n    }" or group.."        \"name\": ".."[]\n    }"
			end
			if ids == 0
				str = str..group
			else
				str = str..",\n"..group
			end
			ids = $ + 1
		end
		str = str.."\n}"
	elseif arg == "save"
		local grouporder = json.encode(LC.serverdata.groups.num)
		str = str.."\"groupset\": {\n"
		for k, v in pairs(LC.serverdata.groups.sets) do
			if type(LC.serverdata.groups.sets[k]) == "string"
				local cons = "    \""..k.."\": \""..LC.serverdata.groups.sets[k].."\""
				if ids == 0
					str = str..cons
				else
					str = str..",\n"..cons
				end
				ids = $ + 1
			end
		end
		ids = 0
		str = str.."\n},\n"
		str = str.."\"grouporder\": "..grouporder..",\n"
		str = str.."\"groups\": {\n"
		for i = 1, #LC.serverdata.groups.num do
			local group = ""
			if LC.serverdata.groups.num[i]
				group = ""
				local t = LC.serverdata.groups.list[LC.serverdata.groups.num[i]]
				group = "    \""..LC.serverdata.groups.num[i].."\": {\n"
				//group = group.."        \"name\": \""..t.name.."\",\n"
				group = group.."        \"displayname\": \""..t.displayname.."\",\n"
				group = group.."        \"color\": \""..t.color.."\",\n"
				group = group.."        \"priority\": "..t.priority..",\n"
				group = group.."        \"admin\": "..tostring(t.admin)..",\n"
				group = group.."        \"perms\": "..json.encode(t.perms).."\n    }" or group.."        \"name\": ".."[]\n    }"
			end
			if ids == 0
				str = str..group
			else
				str = str..",\n"..group
			end
			ids = $ + 1
		end
		str = str.."\n}"
	end
	str = str.."\n}"
	local groupcfg_file = io.openlocal(LC.serverdata.folder.."/groups.cfg", "w")
	groupcfg_file:write(str)
	groupcfg_file:close()
	return str
end

return true
