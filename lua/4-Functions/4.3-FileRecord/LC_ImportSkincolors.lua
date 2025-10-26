local LC = LithiumCore

local json = json //LC_require "json.lua"

LC.functions.ImportSkincolors = function(filename, filetype)
	local format = "all"
	if filename
		if filetype
			if filetype:lower() == "lua"
				format = "lua"
			elseif filetype:lower() == "soc"
				format = "soc"
			elseif filetype:lower() == "json"
				format = "json"
			elseif filetype:lower() == "all"
				format = "all"
			else
				print("\x82".."WARNING\x80"..": Format "..filetype:lower().." is not available, available formats: lua, soc, json..")
				return
			end
		end
		if format == "all" or format == "json"
			local dir = LC.serverdata.clientfolder.."/Skincolors/JSON/"..filename
			local file_sc = io.openlocal(dir, "r")
			if file_sc
				local data_sc = json.decode(file_sc:read("*a"))
				if data_sc.name == nil
					print("\x82".."WARNING\x80"..": Name value not found.")
					return
				end
				if data_sc.ramp == nil
					print("\x82".."WARNING\x80"..": Ramp value not found.")
					return
				end
				if data_sc.invcolor == nil
					print("\x82".."WARNING\x80"..": Invcolor value not found.")
					return
				end
				if data_sc.invshade == nil
					print("\x82".."WARNING\x80"..": Invshade value not found.")
					return
				end
				if data_sc.chatcolor == nil
					print("\x82".."WARNING\x80"..": Chatcolor value not found.")
					return
				end
				local skincolor_data = {}
				skincolor_data.name = data_sc.name
				if type(data_sc.ramp) == "table"
					for i = 1, #data_sc.ramp do
						local ramp = tonumber(data_sc.ramp[i])
						if ramp == nil
						or ramp > 255 or ramp < 0
							ramp = 0
						end
					end
					skincolor_data.ramp = data_sc.ramp
				else
					skincolor_data.ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
				end
				skincolor_data.invcolor = LC.functions.CheckInvcolor(data_sc.invcolor)
				if skincolor_data.invcolor == nil
					skincolor_data.invcolor = SKINCOLOR_WHITE
				end
				skincolor_data.invshade = LC.functions.CheckInvshade(data_sc.invshade)
				if skincolor_data.invshade == nil
					skincolor_data.invshade = 0
				end
				skincolor_data.chatcolor = LC.functions.CheckChatcolor(data_sc.chatcolor)
				if skincolor_data.chatcolor == nil
					skincolor_data.chatcolor = 0
				end
				skincolor_data.accessible = true
				return {[1] = skincolor_data}
			end
		end
		if format == "all" or format == "soc"
			local dir = LC.serverdata.clientfolder.."/Skincolors/SOC/"..filename
			local file_sc = io.openlocal(dir, "r")
			if file_sc
				local sk_t = {}
				local readsk = 0
				while true do
					local line = file_sc:read("*l")
					if not line
						local skincolor_table = {}
						for i = 1, readsk do
							if sk_t[i].name == nil
								print("\x82".."WARNING\x80"..": Name value not found.")
								continue
							elseif sk_t[i].ramp == nil
								print("\x82".."WARNING\x80"..": Ramp value not found.")
								continue
							elseif sk_t[i].invcolor == nil
								print("\x82".."WARNING\x80"..": Invcolor value not found.")
								continue
							elseif sk_t[i].invshade == nil
								print("\x82".."WARNING\x80"..": Invshade value not found.")
								continue
							elseif sk_t[i].chatcolor == nil
								print("\x82".."WARNING\x80"..": Chatcolor value not found.")
								continue
							end
							table.insert(skincolor_table, sk_t[i])
						end
						return skincolor_table
					end
					local str_up = line:upper()
					if str_up:find("SKINCOLOR SKINCOLOR")
						readsk = $ + 1
						local t = {
							name = nil,
							ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
							invcolor = SKINCOLOR_WHITE,
							invshade = 0,
							chatcolor = 0,
							accessible = true 
						}
						table.insert(sk_t, readsk, t)
						continue
					end
					if readsk != 0
						if line:gsub(" ", "") == "" or line:gsub(" ", "") == "\n"
							continue
						else
							local e = line:find("=")
							if e
								local key = str_up:sub(1, e-1) key = key:gsub(" ", "")
								local value = str_up:sub(e+1)
								value = value:gsub("\n", "")
								while true do
									if value:sub(1,1) == " "
										value = value:sub(2)
									else
										break
									end
								end
								while true do
									if value:sub(value:len(),value:len()) == " "
										value = value:sub(1, value:len()-1)
									else
										break
									end
								end
								if key:find("NAME")
									sk_t[readsk].name = value
								elseif key:find("RAMP")
									local ramp = json.decode("["..value.."]")
									for i = 1, 16 do
										if tonumber(ramp[i]) == nil then ramp = nil end
									end
									sk_t[readsk].ramp = ramp
								elseif key:find("INVCOLOR")
									local invcolor = LC.functions.CheckInvcolor(value)
									if invcolor == nil
										invcolor = SKINCOLOR_WHITE
									end
									sk_t[readsk].invcolor = invcolor
								elseif key:find("INVSHADE")
									local invshade = LC.functions.CheckInvshade(value)
									if invshade == nil
										invshade = 0
									end
									sk_t[readsk].invshade = invshade
								elseif key:find("CHATCOLOR")
									local chatcolor = LC.functions.CheckChatcolor(value)
									if chatcolor == nil
										chatcolor = 0
									end
									sk_t[readsk].chatcolor = chatcolor
								end
							end
						end
					end
				end
			elseif format != "all"
				print("\x82".."WARNING\x80"..": File not found in directory "..dir)
				return
			end
		end
		if format == "all" or format == "lua"
			local dir = LC.serverdata.clientfolder.."/Skincolors/Lua/"..filename
			local file_sc = io.openlocal(dir, "r")
			if file_sc
				local data_sc = file_sc:read("*a")
				data_sc:gsub("\n", "")
				local set = 1
				local skincolor_table = {}
				while true do
					local skincolor_data = {}
					local sk = data_sc:find("skincolors", set)
					if not sk then break end
					if sk
						local s1 = data_sc:find("%[", sk)
						local s2 = data_sc:find("%]", sk)
						local s3 = data_sc:find("=", sk)
						local s4 = data_sc:find("%{", sk)
						local s5 = data_sc:find("%}", sk)
						if s1 > s2
						or s2 > s3
						or s3 > s4
							print("\x82".."WARNING\x80"..": Invalid lua script.")
							return
						end
						local n1 = data_sc:find("name", s4)
						local n2 = data_sc:find("=", n1)
						local n3 = data_sc:find("\"", n1)
						local n4 = data_sc:find("\"", n3+1)
						if n1
							if n1 > n2
							or n2 > n3
							or n3 > n4
								print("\x82".."WARNING\x80"..": Invalid lua script.")
								return
							end
							local name = data_sc:sub(n3+1, n4-1)
							name = LC.functions.CheckName(name)
							if not name then return end
							skincolor_data.name = name
						end
						if not n1 or n1 > s5
							print("\x82".."WARNING\x80"..": Name value not found.")
							return
						end
						local r1 = data_sc:find("ramp", s4)
						local r2 = data_sc:find("=", r1)
						local r3 = data_sc:find("\{", r1)
						local r4 = data_sc:find("\}", r3+1)
						if r4 and r4 == s5 then s5 = data_sc:find("\}", s5+1) end
						if r1
							if r1 > r2
							or r2 > r3
							or r3 > r4
								print("\x82".."WARNING\x80"..": Invalid lua script.")
								return
							end
							local ramp = json.decode("["..data_sc:sub(r3+1, r4-1).."]")
							ramp = LC.functions.CheckRamp(ramp)
							if not ramp then return end
							skincolor_data.ramp = ramp
						end
						if not r1 or r1 > s5
							print("\x82".."WARNING\x80"..": Ramp value not found.")
							return
						end
						local i1 = data_sc:find("invcolor", s4)
						local i2 = data_sc:find("=", i1)
						local i3 = data_sc:find(",", i1)
						if i1
							if i1 > i2
							or i2 > i3
								print("\x82".."WARNING\x80"..": Invalid lua script.")
								return
							end
							local invcolor = data_sc:sub(i2+1, i3-1)
							invcolor = LC.functions.CheckInvcolor(invcolor)
							if not invcolor then return end
							skincolor_data.invcolor = invcolor
						end
						if not i1 or i1 > s5
							print("\x82".."WARNING\x80"..": Invcolor value not found.")
							return
						end
						local h1 = data_sc:find("invshade", s4)
						local h2 = data_sc:find("=", h1)
						local h3 = data_sc:find(",", h1)
						if h1
							if h1 > h2
							or h2 > h3
								print("\x82".."WARNING\x80"..": Invalid lua script.")
								return
							end
							local invshade = data_sc:sub(h2+1, h3-1)
							invshade = LC.functions.CheckInvshade(invshade)
							if not invshade then return end
							skincolor_data.invshade = invshade
						end
						if not h1 or h1 > s5
							print("\x82".."WARNING\x80"..": Invshade value not found.")
							return
						end
						local c1 = data_sc:find("chatcolor", s4)
						local c2 = data_sc:find("=", c1)
						local c3 = data_sc:find(",", c1)
						if c1 and c1 or c1 > s5
							if c1 > c2
							or c2 > c3
								print("\x82".."WARNING\x80"..": Invalid lua script.")
								return
							end
							local chatcolor = data_sc:sub(c2+2, c3-1)
							chatcolor = LC.functions.CheckChatcolor(chatcolor)
							skincolor_data.chatcolor = chatcolor
						else
							skincolor_data.chatcolor = 0
						end
						skincolor_data.accessible = true
						table.insert(skincolor_table, skincolor_data)
						set = s5
					end
				end
				return skincolor_table
			elseif format != "all"
				print("\x82".."WARNING\x80"..": File not found in directory "..dir)
				return
			end
		end
	end
	print("\x82".."WARNING\x80"..": File not found")
end

return true -- End of File
