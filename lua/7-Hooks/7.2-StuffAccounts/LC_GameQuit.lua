local LC = LithiumCore

local json = json //LC_require "json.lua"

local hooktable = {
	name = "LC.StuffAccounts",
	type = "GameQuit",
	toggle = true,
	TimeMicros = 0,
	func = function(quitting)
		if isserver == true
			print("The server is closing, saving accounts...")
			for k, v in pairs(LC.accounts.loaded) do
				if LC.accounts.loaded[k]
					local path = LC.accounts.accountsfolder..k..".sav2"
					local data = json.encode(LC.accounts.loaded[k])
					local file_playerstate = io.openlocal(path, "w")
					file_playerstate:write(data)
					file_playerstate:close()
					print("Account with username "..k.." saved.")
				end
			end
		end
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true
