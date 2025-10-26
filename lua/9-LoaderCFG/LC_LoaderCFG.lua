local LC = LithiumCore

local json = json //LC_require "json.lua"

local vars = {}

for l = 1, #LC_LoaderCFG["client"] do
	local r = LC_LoaderCFG["client"][l]()
	if r
	and r.name
	and r.value != nil
		vars[r.name] = r.value
	end
end

local close_game = false
if not multiplayer  -- Avoiding closing the game for clients due to opening a file in luafiles
or isserver == true
	for s = 1, #LC_LoaderCFG["server"] do
		local r = LC_LoaderCFG["server"][s]()
		if r
		and r.name
		and r.value != nil
			vars[r.name] = r.value
		end
	end		
else
	close_game = 12*TICRATE
end

local commands_data = nil
local set_server_cvars = true
--local set_vote_cvars = true
local set_client_cvars = true
local modmessage = true
addHook("PreThinkFrame", do
	-- Saving and Loading ClientCvars
	if close_game != false and multiplayer and server == consoleplayer
		if close_game > 0
			if (leveltime % TICRATE) / 34
				chatprintf(server, "\x85".."ERROR\x80"..": The server was started after playing on another server. LithCore will not work and the game will close after "..close_game/TICRATE.." seconds.")
			end
			close_game = $ - 1
		else
			COM_BufInsertText(server, "quit")
		end
		return
	end
	if set_client_cvars == true -- set values ​​for console vars from file
		for k, v in pairs(vars.clientcfg_data) do
			if LC.client_consvars[k]
			and type(LC.client_consvars[k]) == "userdata"
			and userdataType(LC.client_consvars[k]) == "consvar_t"
				CV_StealthSet(LC.client_consvars[k], vars.clientcfg_data[k])
			end
		end
		set_client_cvars = false
	else -- Save Client console vars if they have been changed
		if (leveltime % TICRATE) / 34
			local save_conscvars = false
			for k, v in pairs(LC.client_consvars) do
				if vars.clientcfg_data[k] != nil
				and type(LC.client_consvars[k]) == "userdata"
				and userdataType(LC.client_consvars[k]) == "consvar_t"
				and (LC.client_consvars[k].flags & CV_SAVE)
					if vars.clientcfg_data[k] != LC.client_consvars[k].string
						vars.clientcfg_data[k] = LC.client_consvars[k].string
						save_conscvars = true
					end
				elseif vars.clientcfg_data[k] == nil
				and (LC.client_consvars[k].flags & CV_SAVE)
					vars.clientcfg_data[k] = LC.client_consvars[k].string
					save_conscvars = true
				end
			end
			if save_conscvars == true
				LC.functions.SaveCvars("client", vars.clientcfg_data)
			end
		end
	end
	-- Saving and Loading ServerCvars
	-- This will work locally for the server only
	if not isserver then return end
	if modmessage == true
		print(
".........................:;%SS@@@@@@SSSSS#%**:::,.........................",
".....................,;*S@@@@@@@@@@@@@@@@@@##S##SS*;:,....................",
"...................:*#@@@@@@@@@@@@@@@@@@@@@@@#S%%SS##S*::.................",
".................;%@@@@@@@@@@@@@@@@@@@@@@@@@@@@S?**??%S#S?;,..............",
"................*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@S*****?%S#S*:,...........",
".............,:%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#?******?%SS?,,.........",
".............*#@@@@@@@####SSSSS%%?????***+*@@@@@@@@@?,:;+***?%SS*,........",
"............+@@@@@*+;;;;;;;+++++*******+;+;+#@@@@@@@@?...,:+**?%#S;.......",
"...........;@@@@#+:;+++;;;;;;+++****??*;+%%+;S@@@@@@@@*.....:+**%S#*,.....",
"..........:#@@@#+:;++++++++++++;;;;;;;;;?%%%*;?@@@@@@@@+......;**?S@?.....",
".........:#@@@#+;;;+++++++++++++++;;::;;;+?%%?;+#@@@@@@#:......:**?S@*....",
".........+@@@S;+*;+++++++++++++;;::,,:;++;;+*?%++S@@@@@@%.......;**?S@*...",
"........,#@@S;+?;;++++++++++;;:,,,,,,:;+++++;;+?*;S@@@@@@:......,+**%##;..",
".......,?@@S;+?*;;+++++++;::,,,,,,,,,:;+++++++;;+;;#@@@@@?.......+**?S@*..",
"......;S@@%;+??+;+++++;::,,,,,,,,,,,,:;;+++++++++;:?@@@@@S......,+***%#@+.",
"....,%@@@%;+??*;;++;::,,,,,,,,,,,,,,,,:;++++++++++:*@@@@@#:....,;****%S@*.",
"...:S@@@?;+***+;;::,,,,,,,,,,,,,,,,,,,:;++++++++++:?@@@@@@+,,,:+*****%S@*.",
"..,S@@@%:;+++*;;;::,,,,,,,,,,,,,,,,,,,:;+++++++++;:%@@@@@@?+********?%S@*.",
"..%@@@@#*;?SSS?;*?*+;::,,,,,,,,,,,,,,,:;+++++++;;;+#@@@@@@%*********%%#@*.",
".+@@@@@@@?;*SSS+;%%%%?*+;::,,,,,,,,,,,:;+++++;;*+;S@@@@@@@%*******?%%S#@*.",
".*@@@@@@@@S++?S%;*%%%%%%%?*+;::,,,,,,,:;+++;;+?+;%@@@@@@@@?******?%%%S@@+.",
".;@@@@@@@@@@%++?*;?%%%%%%%%%%?*+;::,,,:;+;;+**+;S@@@@@@@@S**???%%%SSS#@%,.",
"..?@@@@@@@@@@@S+;:+??????%%%%%%%%?*+;::;;+*+++*S@@@@@@@#S%%%%%SSSS%S#@#+..",
"..*#@@@@@@@@@@@@S?****+++++++++*****+;::;++?S@@@@@@@@#SSSSSSSSSSS%S#@@S,..",
"...+@@@@@@@@@@@@@@@@@@@@@###SSS%%%??????%S@@@@@@@@#SS%SSSSSSSSS%SS#@@#;...",
"...,?@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##SS%%SSSSSSSSS%SS#@@@S:....",
".....?@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##SSS%SSSSSSSSSS%%SS##@@@S:.....",
".....,*@@@###@@@@@@@@@@@@@@@@@@@@@@###SSSS%%%SSSSSSSS%%%SSS##@@@@@%,......",
".......;#@@@###@@@@@@@@@@@@@@@@@#####SSSSSSSSSSSSSSSSSS###@@@@@@#+,.......",
"........,*#@@@###@@@@@@@@@@@@@@@@@@@@@################@@@@@@@@@?:.........",
".........,,%#@@@####@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%;...........",
"............,*#@@@@####@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@S?;.............",
"..............,;?#@@@@#####@@@@@@@@@@@@@@@@@@@@@@@@@@@@#S+,...............",
".................::*S@@@@@@@###############@@@@@@@@@%**:..................",
"....................,:;*SS#@@@@@@@@@@@@@@@@@@@SS%+;,......................",
"..........................:::;?%#SSSSSSSS?*;:;,...........................",
"===========================================================================",
"########################LithCore Version "..LC.functions.GetVersion().string.."########################",
"##=======================================================================##",
"##              Thank you for using LithCore on your server              ##",
"##                      Currently under development                      ##",
"##                   Please report bugs to my discord                    ##",
"##                           Discord: sirexer                            ##",
"##=======================================================================##",
"##########If you see this message, the mod has successfully loaded#########",
"==========================================================================="
)
		modmessage = false
	end
	if (leveltime % TICRATE*10) / TICRATE
		if not commands_data
			local commands_file = io.openlocal(LC.serverdata.folder.."/commandperms.cfg", "r")
			commands_data = json.decode( commands_file:read("*a") )
		elseif commands_data
			local scd = LC.serverdata.commands
			for k, v in pairs(scd) do
				if not commands_data[k]
					LC.functions.SaveCommandPerms()
					commands_data = nil
					break
				end
			end
		end
	end
	
	if set_server_cvars == true -- set values ​​for console vars from file
	and vars.servercfg_data
		for k, v in pairs(vars.servercfg_data) do
			if LC.consvars[k]
			and type(LC.consvars[k]) == "userdata"
			and userdataType(LC.consvars[k]) == "consvar_t"
				CV_StealthSet(LC.consvars[k], vars.servercfg_data[k])
			end
		end
		set_server_cvars = false
	elseif vars.servercfg_data -- Save Server console vars if they have been changed
		if (leveltime % TICRATE) / 34
			local save_conscvars = false
			for k, v in pairs(LC.consvars) do
				if vars.servercfg_data[k] != nil
				and type(LC.consvars[k]) == "userdata"
				and userdataType(LC.consvars[k]) == "consvar_t"
				and (LC.consvars[k].flags & CV_SAVE)
					if vars.servercfg_data[k] != LC.consvars[k].string
						vars.servercfg_data[k] = LC.consvars[k].string
						save_conscvars = true
					end
				elseif vars.servercfg_data[k] == nil
				and (LC.consvars[k].flags & CV_SAVE)
					vars.servercfg_data[k] = LC.consvars[k].string
					save_conscvars = true
				end
			end
			if save_conscvars == true
				LC.functions.SaveCvars("server", vars.servercfg_data)
			end
		end
	end
end)

return true
