local first = getTimeMicros() -- Counting addon load time

local LUA_FILES = { -- List of all LithCore lua files
	{
		dir = "1-Tables/",
		files = {
			{name = "LC_Rawset.lua", loaded = nil},
			{name = "LC_Serverdata.lua", loaded = nil},
			{name = "LC_localdata.lua", loaded = nil},
			{name = "LC_Symbols.lua", loaded = nil},
			{name = "LC_Accounts.lua", loaded = nil},
			{name = "LC_Group.lua", loaded = nil},
			{name = "LC_Controls.lua", loaded = nil},
			{name = "LC_Gametypes.lua", loaded = nil},
			{name = "LC_Phrases.lua", loaded = nil},
			{name = "LC_Macrolist.lua", loaded = nil},
			{name = "LC_Hooks.lua", loaded = nil},
			{name = "LC_Menu.lua", loaded = nil},
			{name = "LC_Colormaps.lua", loaded = nil},
			{name = "LC_ChatFilter.lua", loaded = nil},
			{name = "LC_GameInfoTab.lua", loaded = nil},
			{name = "LC_Unicode.lua", loaded = nil},
			{name = "LC_MasterKeys.lua", loaded = nil},
			{name = "LC_Language.lua", loaded = nil}
		}
	},
	
	{
		dir = "2-Constants/",
		files = {
			{name = "LC_MenuAction.lua", loaded = nil}
		}
	},
	
	{
		dir = "3-Freeslots/",
		files = {
			{name = "LC_SendColor.lua", loaded = nil},
			{name = "LC_Emotes.lua", loaded = nil},
			{name = "LC_PlayerIndicators.lua", loaded = nil},
			{name = "LC_Particles.lua", loaded = nil}
		}
	},
	
	{
		dir = "4-Functions/4.1-FindAndGet/",
		files = {
			{name = "LC_FindPlayer.lua", loaded = nil},
			{name = "LC_FindMap.lua", loaded = nil},
			{name = "LC_GetControlByName.lua", loaded = nil},
			{name = "LC_PlayersOnServer.lua", loaded = nil},
			{name = "LC_IsUserLogged.lua", loaded = nil},
			{name = "LC_CheckPerms.lua", loaded = nil},
			{name = "LC_ConvUsername.lua", loaded = nil},
			{name = "LC_EncryptText.lua", loaded = nil},
			{name = "LC_GetRandomNumber.lua", loaded = nil},
			{name = "LC_GetRandomPassword.lua", loaded = nil},
			{name = "LC_GetFloat.lua", loaded = nil},
			{name = "LC_GetSymbols.lua", loaded = nil},
			{name = "LC_GetVersion.lua", loaded = nil},
			{name = "LC_Skincolors.lua", loaded = nil},
			{name = "LC_TextColor.lua", loaded = nil},
			{name = "LC_IsSpecialStage.lua", loaded = nil},
			{name = "LC_GetFileSize.lua", loaded = nil},
			{name = "LC_GetVarByString.lua", loaded = nil},
			{name = "LC_GetColormap.lua", loaded = nil},
			{name = "LC_convertTimestamp.lua", loaded = nil},
			{name = "LC_QRtoIMG.lua", loaded = nil},
			{name = "LC_filterPrintable.lua", loaded = nil},
			{name = "LC_parseTime.lua", loaded = nil},
			{name = "LC_parseValue.lua", loaded = nil},
			{name = "LC_normalizePossibleValue.lua", loaded = nil},
			{name = "LC_GetMenuAction.lua", loaded = nil},
			{name = "LC_BuildMapName.lua", loaded = nil},
			{name = "LC_getStringLanguage.lua", loaded = nil}
		}
	},
	
	{
		dir = "4-Functions/4.2-DataHandlers/",
		files = {
			{name = "LC_AddAccountData.lua", loaded = nil},
			{name = "LC_AddCommandMenu.lua", loaded = nil},
			{name = "LC_AddConsVarMenu.lua", loaded = nil},
			{name = "LC_AddSubcatMenu.lua", loaded = nil},
			{name = "LC_AddHook.lua", loaded = nil},
			{name = "LC_AddVoteMenu.lua", loaded = nil},
			{name = "LC_AddEmote.lua", loaded = nil},
			{name = "LC_SaveLoadOtherStuff.lua", loaded = nil},
			{name = "LC_ChatFilter.lua", loaded = nil},
			{name = "LC_AddonLoader.lua", loaded = nil},
			{name = "LC_MakeDeepCopy.lua", loaded = nil},
			{name = "LC_RegisterCommand.lua", loaded = nil},
			{name = "LC_MergeTables.lua", loaded = nil},
			{name = "LC_decryptData.lua", loaded = nil},
			{name = "LC_verifyCode.lua", loaded = nil},
			{name = "LC_addVoteType.lua", loaded = nil}
		}
	},
	
	{
		dir = "4-Functions/4.3-FileRecord/",
		files = {
			{name = "LC_Autologin.lua", loaded = nil},
			{name = "LC_Skincolor.lua", loaded = nil},
			{name = "LC_SaveState.lua", loaded = nil},
			{name = "LC_SaveCvars.lua", loaded = nil},
			{name = "LC_SaveGroups.lua", loaded = nil},
			{name = "LC_SaveControls.lua", loaded = nil},
			{name = "LC_SaveLoadNameStuff.lua", loaded = nil},
			{name = "LC_SaveCommandPerms.lua", loaded = nil},
			{name = "LC_SaveBanChars.lua", loaded = nil},
			{name = "LC_ImportSkincolors.lua", loaded = nil},
			{name = "LC_ExportSkincolors.lua", loaded = nil},
			{name = "LC_SaveBanlist.lua", loaded = nil},
			{name = "LC_TimelimitMaps.lua", loaded = nil},
			{name = "LC_saveVotingSettings.lua", loaded = nil}
		}
	},
	
	{
		dir = "4-Functions/4.4-HUD/",
		files = {
			{name = "LC_drawIMG.lua", loaded = nil},
			{name = "LC_drawScaledIMG.lua", loaded = nil},
			{name = "LC_cacheString.lua", loaded = nil},
			{name = "LC_cacheUnicode.lua", loaded = nil},
			{name = "LC_scrolledString.lua", loaded = nil},
			{name = "LC_drawString.lua", loaded = nil},
			{name = "LC_drawStringBox.lua", loaded = nil}
		}
	},
	
	{
		dir = "4-Functions/4.5-Others/",
		files = {
			{name = "LC_SendCsay.lua", loaded = nil},
			{name = "LC_SaveLoadMenuState.lua", loaded = nil},
			{name = "LC_InputText.lua", loaded = nil},
			{name = "LC_Ban.lua", loaded = nil},
			{name = "LC_MenuNavigation.lua", loaded = nil},
			{name = "LC_Menu.lua", loaded = nil},
			{name = "LC_startVote.lua", loaded = nil}
			
		}
	},
	
	{
		dir = "4-Functions/4.6-Replaced/",
		files = {
			{name = "addHook.lua", loaded = nil},
			{name = "COM_AddCommand.lua", loaded = nil},
			{name = "G_AddGametype.lua", loaded = nil},
			{name = "COM_BufInsertText.lua", loaded = nil}
		}
	},
	
	{
		dir = "5-Consvar/",
		files = {
			{name = "LC_ServerVars.lua", loaded = nil}, 
			{name = "LC_ClientVars.lua", loaded = nil}
		}
	},
	
	{
		dir = "6-Commands/6.1-ServerCommands/",
		files = {
			{name = "LC_ListResetEmeralds.lua", loaded = nil}, 
			{name = "LC_SetUserName.lua", loaded = nil}, 
			{name = "LC_SetStuff.lua", loaded = nil}, 
			{name = "LC_SPrint.lua", loaded = nil}, 
			{name = "LC_SChangePassUser.lua", loaded = nil}, 
			{name = "LC_HookToggle.lua", loaded = nil}, 
			{name = "LC_GroupEditor.lua", loaded = nil}, 
			{name = "LC_PermsEditor.lua", loaded = nil},
			{name = "LC_decryptData_to_client.lua", loaded = nil},
			{name = "LC_ServerTPS.lua", loaded = nil}
		}
	},
	
	{
		dir = "6-Commands/6.2-AdminTools/",
		files = {
			{name = "LC_CancelVote.lua", loaded = nil},
			{name = "LC_ChangePassUser.lua", loaded = nil}, 
			{name = "LC_Silence.lua", loaded = nil}, 
			{name = "LC_Kick.lua", loaded = nil}, 
			{name = "LC_Ban.lua", loaded = nil}, 
			{name = "LC_BanList.lua", loaded = nil}, 
			{name = "LC_Goto.lua", loaded = nil}, 
			{name = "LC_Here.lua", loaded = nil}, 
			{name = "LC_DoFor.lua", loaded = nil}, 
			{name = "LC_Print.lua", loaded = nil},
			{name = "LC_Group.lua", loaded = nil},
			{name = "LC_PilotPlayer.lua", loaded = nil},
			{name = "LC_BanChars.lua", loaded = nil},
			{name = "LC_BanWords.lua", loaded = nil},
			{name = "LC_Hide.lua", loaded = nil},
			{name = "LC_TimelimitMaps.lua", loaded = nil},
			{name = "LC_Csay.lua", loaded = nil},
			{name = "LC_VotingSettings.lua", loaded = nil}
		}
	},
	
	{
		dir = "6-Commands/6.3-Cheats/",
		files = {
			{name = "LC_Flip.lua", loaded = nil}, 
			{name = "LC_Kill.lua", loaded = nil}, 
			{name = "LC_Scale.lua", loaded = nil}, 
			{name = "LC_SetPlayerScore.lua", loaded = nil}, 
			{name = "LC_SetPlayerRings.lua", loaded = nil}, 
			{name = "LC_SetPlayerLives.lua", loaded = nil}, 
			{name = "LC_SetPlayerColor.lua", loaded = nil}, 
			{name = "LC_SetPlayerSkin.lua", loaded = nil}
		}
	},
	
	{
		dir = "6-Commands/6.4-PlayerCommands/",
		files = {
			{name = "LC_Login.lua", loaded = nil}, 
			{name = "LC_Register.lua", loaded = nil}, 
			{name = "LC_Changepass.lua", loaded = nil}, 
			{name = "LC_Vote.lua", loaded = nil},
			{name = "LC_Voting.lua", loaded = nil}, 
			{name = "LC_Ignore.lua", loaded = nil}, 
			{name = "LC_Menu.lua", loaded = nil}, 
			{name = "LC_SetControl.lua", loaded = nil},
			{name = "LC_SwearWords.lua", loaded = nil},
			{name = "LC_Skincolor.lua", loaded = nil},
			{name = "LC_SendID.lua", loaded = nil},
			{name = "LC_MOTD.lua", loaded = nil},
			{name = "LC_Emotes.lua", loaded = nil},
			{name = "LC_PlayerIndicators.lua", loaded = nil},
			{name = "LC_Corrupt.lua", loaded = nil},
			{name = "LC_AFK.lua", loaded = nil},
			{name = "LC_TOTP.lua", loaded = nil},
			{name = "LC_decryptData_to_server.lua", loaded = nil}
		}
	},
	
	{
		dir = "6-Commands/",
		files = {
			{name = "LC_Debug.lua", loaded = nil},
		}
	},
	
	{
		dir = "7-Hooks/Replaced_HUD/",
		files = {
			{name = "textspectator.lua", loaded = nil}
		}
	},
	
	
	{
		dir = "7-Hooks/7.1-Main/",
		files = {
			{name = "LC_ThinkFrame.lua", loaded = nil},
			{name = "LC_PlayerJoin.lua", loaded = nil},
			{name = "LC_HUD.lua", loaded = nil},
			{name = "LC_KeyDown.lua", loaded = nil},
			{name = "LC_PlayerCmd.lua", loaded = nil},
			{name = "LC_MobjDamage.lua", loaded = nil},
			{name = "LC_MobjDeath.lua", loaded = nil},
			{name = "LC_MapLoad.lua", loaded = nil}
		}
	},
	
	{
		dir = "7-Hooks/7.13-Menu/",
		files = {
			{name = "LC_GameQuit.lua", loaded = nil},
			{name = "LC_KeyDown.lua", loaded = nil},
			{name = "LC_HUD.lua", loaded = nil}
		}
	},
	
	{
		dir = "7-Hooks/7.2-StuffAccounts/",
		files = {	
			{name = "LC_PlayerThink.lua", loaded = nil},
			{name = "LC_PlayerQuit.lua", loaded = nil},
			{name = "LC_GameQuit.lua", loaded = nil},
			{name = "LC_KeyDown.lua", loaded = nil},
			{name = "LC_MapLoad.lua", loaded = nil},
			{name = "LC_HUD.lua", loaded = nil}
		}
	},
	
	{
		dir = "7-Hooks/7.3-Voting/",
		files = {
			{name = "LC_ThinkFrame.lua", loaded = nil},
			{name = "LC_HUD.lua", loaded = nil}
		}
	},
	
	{
		dir = "7-Hooks/7.4-ChatMSG/",
		files = {
			{name = "LC_PlayerThink.lua", loaded = nil},
			{name = "LC_PlayerMsg.lua", loaded = nil},
			{name = "LC_HUD.lua", loaded = nil}
		}
	},
	
	{
		dir = "7-Hooks/7.5-Controls/",
		files = {
			{name = "LC_ThinkFrame.lua", loaded = nil},
			{name = "LC_KeyUp.lua", loaded = nil},
			{name = "LC_KeyDown.lua", loaded = nil}
		}
	},
	
	{
		dir = "7-Hooks/7.6-PilotPlayer/",
		files = {
			{name = "LC_PlayerThink.lua", loaded = nil}
		}
	},
	
	{
		dir = "7-Hooks/7.7-BanChars/",
		files = {
			{name = "LC_ThinkFrame.lua", loaded = nil}
		}
	},
	
	{
		dir = "7-Hooks/7.8-Skincolor/",
		files = {
			{name = "LC_ThinkFrame.lua", loaded = nil},
			{name = "LC_PlayerQuit.lua", loaded = nil},
			{name = "LC_GameQuit.lua", loaded = nil}
		}
	},
	
	{
		dir = "7-Hooks/7.9-AlternativeScores/",
		files = {
			{name = "LC_KeyDown.lua", loaded = nil},
			{name = "LC_KeyUp.lua", loaded = nil},
			{name = "LC_HUD.lua", loaded = nil}
		}
	},
	
	
	{
		dir = "7-Hooks/7.10-AFK/",
		files = {
			{name = "LC_PlayerThink.lua", loaded = nil}
		}
	},
	
	
	{
		dir = "7-Hooks/7.11-Emotes/",
		files = {
			{name = "LC_PlayerThink.lua", loaded = nil},
			{name = "LC_HUD.lua", loaded = nil},
			{name = "LC_KeyDown.lua", loaded = nil}
		}
	},
	
	{
		dir = "7-Hooks/7.12-PlayerIndicators/",
		files = {
			{name = "LC_ThinkFrame.lua", loaded = nil},
			{name = "LC_PlayerThink.lua", loaded = nil}
		}
	},
	
	{
		dir = "7-Hooks/",
		files = {
			{name = "LC_TimeMicros.lua", loaded = nil},
			{name = "LC_AnotherHooks.lua", loaded = nil},
			{name = "LC_Hooks.lua", loaded = nil}
		}
	},
	
	{
		dir = "8-LoaderData/8.1-Menu/8.1.1-Account/",
		files = {
			{name = "LC_Info.lua", loaded = nil},
			{name = "LC_ChangePass.lua", loaded = nil},
			{name = "LC_2FaAuthentication.lua", loaded = nil}
		}
	},
	
	{
		dir = "8-LoaderData/8.1-Menu/8.1.2-AdminPanel/",
		files = {
			{name = "LC_Commands.lua", loaded = nil},
			{name = "LC_Variables.lua", loaded = nil},
			{name = "LC_Groups.lua", loaded = nil},
			{name = "LC_Servername.lua", loaded = nil},
			{name = "LC_VotingSettings.lua", loaded = nil}
		}
	},
	
	{
		dir = "8-LoaderData/8.1-Menu/8.1.3-PlayerOptions/",
		files = {
			{name = "LC_Controls.lua", loaded = nil},
			{name = "LC_Variables.lua", loaded = nil},
			{name = "LC_Ignore.lua", loaded = nil},
			{name = "LC_Skincolors.lua", loaded = nil},
			{name = "LC_Emotes.lua", loaded = nil}
		}
	},
	
	{
		dir = "8-LoaderData/8.1-Menu/8.1.4-Miscellaneous/",
		files = {
			{name = "LC_Voting.lua", loaded = nil},
			{name = "LC_MoTD.lua", loaded = nil},
			{name = "LC_GameInfo.lua", loaded = nil}
		}
	},
	
	{
		dir = "8-LoaderData/",
		files = {
			{name = "LC_AccountData.lua", loaded = nil},
			{name = "LC_VoteData.lua", loaded = nil},
			{name = "LC_EmotesData.lua", loaded = nil},
			{name = "LC_LoaderData.lua", loaded = nil}
		}
	},
	
	{
		dir = "9-LoaderCFG/9.1-Client/",
		files = {
			{name = "LC_Control.lua", loaded = nil},
			{name = "LC_Identifier.lua", loaded = nil},
			{name = "LC_Autologin.lua", loaded = nil},
			{name = "LC_Consvars.lua", loaded = nil},
			{name = "LC_Skincolor.lua", loaded = nil},
			{name = "LC_SwearWords.lua", loaded = nil}
		}
	},
	
	{
		dir = "9-LoaderCFG/9.2-Server/",
		files = {
			{name = "LC_ServerState.lua", loaded = nil},
			{name = "LC_Identifier.lua", loaded = nil},
			{name = "LC_Consvars.lua", loaded = nil},
			{name = "LC_Groups.lua", loaded = nil},
			{name = "LC_CommandPerms.lua", loaded = nil},
			{name = "LC_BanChars.lua", loaded = nil},
			{name = "LC_BanWords.lua", loaded = nil},
			{name = "LC_Banlist.lua", loaded = nil},
			{name = "LC_MoTD.lua", loaded = nil},
			{name = "LC_TimelimitMaps.lua", loaded = nil},
			{name = "LC_VotingSettings.lua", loaded = nil}
		}
	},
	
	{
		dir = "9-LoaderCFG/",
		files = {
			{name = "LC_LoaderCFG.lua", loaded = nil}
		}
	}
}

local libs = {
	["base64"]		=		{file = "base64.lua",	module = nil},
	["bmp"]			=		{file = "bmp.lua",		module = nil},
	["json"]		=		{file = "json.lua",		module = nil},
	["qrencode"]	=		{file = "qrencode.lua",	module = nil},
	["sha1"]		=		{file = "sha1.lua",		module = nil},
	["totp"]		=		{file = "totp.lua",		module = nil},
	["elcipher"]	=		{file = "elcipher.lua",	module = nil},
	["RNG"]			=		{file = "rng.lua",		module = nil},
	["unicode"]		=		{file = "unicode.lua",	module = nil}
	-- ["tea"]		=		{file = "tea.lua",		module = nil}
}

local LC = {}

if (VERSION == 202) and (SUBVERSION < 13) -- In older versions, the mod should not work
	print("\x82".."WARNING".."\x80"..": Your version of the game is outdated, please update the game on srb2.org!", 0)
elseif (VERSION > 202) -- It shouldn't work in 2.3 either
	print("\x82".."WARNING".."\x80"..": This mod is outdated, for "..VERSIONSTRING, 0)
else
	if LithiumCore -- Repeated mod, should not run
		return
	else
		-- Lua library function
		rawset(_G, "LC_require", function(libname) -- get library function
			libs[libname].module = libs[libname].module or dofile("Libraries/"..libs[libname].file)
			return libs[libname].module
		end)
		
		print("Loading libraries...")
		local lib_msg = ""
		for k, v in pairs(libs) do
			xpcall(
				function()
					local module = dofile("Libraries/"..libs[k].file)
					if module
						lib_msg = lib_msg..k.." library has been loaded\n"
						libs[k].module = module
						rawset(_G, k, module) 
					else
						libs[k].module = nil
						lib_msg = lib_msg.."\x82".."WARNING".."\x80"..": Libraly "..k.." return nil\n"
					end
				end,
				function() lib_msg = lib_msg.."\x82".."WARNING".."\x80"..": Libraly "..k.." not found\n" end
			)
		end
		print(lib_msg:sub(1, lib_msg:len()-1) )
		-- Loading all scripts from the lua folder
		LUA_FILES.alldir = 0
		LUA_FILES.allfiles = 0
		for d = 1, #LUA_FILES do -- lua loader
			LUA_FILES.alldir = $ + 1
			for f = 1, #LUA_FILES[d].files do
				xpcall(
					function()
						local TM_LUA_S = getTimeMicros()
						local loaded = dofile(LUA_FILES[d].dir..LUA_FILES[d].files[f].name)
						local TM_LUA_E = getTimeMicros()
						if loaded == true
							LUA_FILES[d].files[f].loaded  = true
							LUA_FILES.allfiles = $ + 1
						else
							LUA_FILES[d].files[f].loaded = false
						end
						LUA_FILES[d].files[f].tm = TM_LUA_E - TM_LUA_S
					end,
					function() print("\x82".."WARNING".."\x80"..": lua script "..LUA_FILES[d].dir..LUA_FILES[d].files[f].name.." not found") end
				)
			end
		end
		print("Loaded "..LUA_FILES.alldir.." Directories, "..LUA_FILES.allfiles.." Files")
	
		LC = LithiumCore
	
		print("Installing LithiumCore Metatables...")
		local proxy_table = dofile "LC_SetMetatable"
		LithiumCore = proxy_table
	
		-- Get the time for how long the mod has been loaded for
		local second = getTimeMicros()
		local result = tostring(second-first)
		if string.len(result) > 3
			local dot = string.len(result)-3
			local milli = string.sub(result, 1, dot)
			local micro = string.sub(result, dot+1)
			result = milli.."."..micro
		else
			result = "0."..result
		end
		print("Loading LithCore takes "..result.."ms")
		
		addHook("ThinkFrame", do
			if LithiumCore != proxy_table then LithiumCore = proxy_table end
		end)
		
	end
end

-- The command shows Lua scripts operability and loading time
COM_AddCommand("LC_luafiles", function(player)
	local d_count = 0
	for d = 1, #LUA_FILES do
		local f_count = 0
		d_count = $ + 1
		print("["..d_count.."]"..LUA_FILES[d].dir)
		for f = 1, #LUA_FILES[d].files do
			local f_status
			if LUA_FILES[d].files[f].loaded == true
				f_status = ": \x83".."running"
			elseif LUA_FILES[d].files[f].loaded == false
				f_status = ": \x85".."error"
			else
				f_status = ": \x82".."not found"
			end
			local tm = LUA_FILES[d].files[f].tm
			if tm == nil then tm = "0" end
			if string.len(tm) > 3
				local dot = string.len(tm)-3
				local milli = string.sub(tm, 1, dot)
				local micro = string.sub(tm, dot+1)
				tm = milli.."."..micro
			else
				tm = "0."..tm
			end
			print("    ["..f_count.."] "..LUA_FILES[d].files[f].name..f_status.."\x80 - "..tm.."ms")
			if LUA_FILES[d].files[f].loaded == true
				f_count = $ + 1
			end
		end
	end
	print("Loaded "..LUA_FILES.alldir.." Directories, "..LUA_FILES.allfiles.." Files")
end, COM_LOCAL)

local function getByPath(root, path)
	local prev = root
	local keys = {}
    for key in string.gmatch(path, "[^%.]+") do
        local num = tonumber(key)
        if num then
            key = num
        end
		
		table.insert(keys, key)
        if type(root) == "table" then
			prev = root
            root = root[key]
        else
            return nil
        end
    end
    return root, prev, keys[#keys]
end


COM_AddCommand("LC_test", function(player, path, arg)
	if not path then return end
	local object, t, key = getByPath(_G, path)
	
	if arg then
		print(key)
		t[key] = arg
		return
	end
	
	if type(object) == "table"
		print(object)
		local str = ""
		for k, v in pairs(object) do
			print(k)
			if type(object[k]) != "string" and type(object[k]) != "number"
				print("[\""..k.."\"] - "..type(object[k]))
			else
				print("[\""..k.."\"] - "..object[k])
			end
		end
		for i in ipairs(object) do
			print(i)
			if type(object[i]) != "string" and type(object[i]) != "number"
				print("["..i.."] - "..type(object[i]))
			else
				print("["..i.."] - "..object[i])
			end
		end
	elseif type(object) != "table"
		print(object)
	end
end, 1)

-- Just Test Commands

COM_AddCommand("LC_addbot", function(player, name, skin, color)
	local n = LC.functions.GetRandomPassword()
	local s = P_RandomRange(0, #skins-1)
	local c = P_RandomRange(1, #skincolors-1)
	if name then n = name end
	if tonumber(skin) != nil and tonumber(skin) < #skins then s = tonumber(skin) end
	if tonumber(color) and tonumber(color) < #skincolors then c = tonumber(color) end
	local bot = G_AddPlayer(skins[s].name, c, n, 0)
	//bot.botleader = player
end, 1)

COM_AddCommand("LC_kickall", function(player)
	for p in players.iterate do
		if player == p then continue end
		COM_BufInsertText(player, "kick "..#p)
	end
end, 1)
