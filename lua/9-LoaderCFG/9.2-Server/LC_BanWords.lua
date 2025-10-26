local LC = LithiumCore

local load_bc = function()
	local bwcfg_data
	local bwcfg_file = io.openlocal(LC.serverdata.folder.."/banwords.cfg", "r")
	if bwcfg_file 
		print("Reading the banwords file...")
		//local bccfg_data = bccfg_file:read("*a")
		local badword_c = 0
		local tab = {}
		for i = 1, 64 do table.insert(tab, {}) end
		while true do
			local line = bwcfg_file:read("*l")
			if line
				if line == "" or line == " " or line == "\n" then continue end
				local l = line:len()
				table.insert(tab[l], line)
				badword_c = $ + 1
			else
				break
			end
		end
		bwcfg_file:close()
		local i = 64
		while true do
			if i == 0 then break end
			for w = 1, #tab[i] do
				table.insert(LithiumCore.serverdata.banwords, tab[i][w])
			end
			i = $ - 1
		end
		print("Added "..badword_c.." words to the swear list")
	else
		print("Creating the banwords file...")
		bwcfg_file = io.openlocal(LC.serverdata.folder.."/banwords.cfg", "w")
		local dbw = LithiumCore.ChatFilter.defaultbanword
		local tab = {}
		for i = 1, 64 do table.insert(tab, {}) end
		for w = 1, #dbw do
			local l = dbw[w]:len()
			table.insert(tab[l], dbw[w])
		end
		local i = 64
		while true do
			if i == 0 then break end
			for w = 1, #tab[i] do
				bwcfg_file:write(tab[i][w].."\n")
				table.insert(LithiumCore.serverdata.banwords, tab[i][w])
			end
			i = $ - 1
		end
		bwcfg_file:close()
	end
end

table.insert(LC_LoaderCFG["server"], load_bc)

return true
