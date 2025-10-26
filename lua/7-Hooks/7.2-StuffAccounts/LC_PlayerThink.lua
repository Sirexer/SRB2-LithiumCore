local LC = LithiumCore
local json = json //LC_require "json.lua"

-- ======================
-- Utilities
-- ======================

-- decreases the timer (but not below 0)
local function countdown(val)
	if val and val > 0 then return val - 1 end
	return 0
end

-- updates game time
local function updatePlaytime(tp)
	tp.tics = $ + 1
	if tp.tics >= TICRATE then
		tp.tics = 0
		tp.seconds = ($ + 1) % 60
		if tp.seconds == 0 then
			tp.minutes = ($ + 1) % 60
			if tp.minutes == 0 then
				tp.hours = $ + 1
			end
		end
	end
end

-- handling “OtherStuff”
local function processOtherStuff(key, player, flagName)
	local stuff = LC.accounts.OtherStuff[key]
	if not stuff then
		stuff = {}
		LC.accounts.OtherStuff[key] = stuff
		LC.functions.SaveLoadOtherStuff(stuff, player, "save")
		player[flagName] = true
		return
	end

	if not player[flagName] and (leveltime % 4) == 2 then
		LC.functions.SaveLoadOtherStuff(stuff, player, "load")
		player[flagName] = true
	end
end

-- ======================
-- Hook
-- ======================

local hooktable = {
	name = "LC.StuffAccounts",
	type = "PlayerThink",
	toggle = true,
	TimeMicros = 0,
	func = function(player)
		-- A bot cannot have an account, so skip it
		if player.is_bot then return end
	
		-- time initialization
		if not player.LC_timeplayed then
			player.LC_timeplayed = {tics = 0, seconds = 0, minutes = 0, hours = 0}
		end
		updatePlaytime(player.LC_timeplayed)

		-- basic checks
		if leveltime > TICRATE then
			if not G_IsSpecialStage(gamemap) and not player.exiting and not player.spectator then
				player.saveshield = player.powers[pw_shield] or 0
			end
			if player.score > 100000 then
				player.returnscore = player.score - 100000
			end
		end
		player.saveshield = player.saveshield or 0

		-- unregistered players
		if not player.stuffname then
			if LC.consvars["LC_unregblock"].value == 1 and not IsPlayerAdmin(player) and server ~= player then
				if LC.consvars["LC_unregkick"].value ~= 0 then
					player.lcgetkick = player.lcgetkick or (LC.consvars["LC_unregkick"].value*TICRATE)
					if player.lcgetkick > 0 then
						player.lcgetkick = $ - 1
					else
						COM_BufInsertText(server, "kick "..#player.." \"\x85Time to log in is up\x80\"")
					end
				end
				player.powers[pw_nocontrol] = 1
			end

			-- loading delay
			player.delay_stuffload = countdown(player.delay_stuffload == nil and (TICRATE) or player.delay_stuffload)
			if player.delay_stuffload == 0 and LC.consvars.autoreg.value == 1 and not player.getautoacc then
				if player.speed > 5 then
					local getusername = LC.functions.getname(player.name)
					COM_BufInsertText(player,
						"ac_register "..(string.gsub(getusername, " ", "")).."_"..LC.functions.GetRandomNumber().." random")
					player.getautoacc = true
				end
			end

			-- auto-login when ready
			if not player.stuffloaded and player.delay_stuffload <= 1 then
				LC.functions.Autologin(player, "read")
				player.stuffloaded = true
			end

			-- loading data from save.dat of unregistered players
			processOtherStuff(player.name..".unreg", player, "keepstuffed")

		else
			-- Loading account from server/file
			if player.loadfromserver then
				if not LC.accounts.loaded[player.stuffname] then
					local path = LC.accounts.accountsfolder..player.stuffname..".sav2"
					if isserver and LC.consvars.autobackup.value == 1 then
						local f_s = io.openlocal(path, "r")
						if f_s then
							local f_s_data = f_s:read("*a")
							f_s:close()
							local bak_path = LC.accounts.accountsfolder.."backups/"..player.stuffname.."/"..player.stuffname..os.time()..".sav2"
							local fb = io.openlocal(bak_path, "w")
							fb:write(f_s_data)
							fb:close()
						end
					end
					io.open(path, "r", function(f)
						if f then
							local data = f:read("*a")
							LC.accounts.loaded[player.stuffname] = json.decode(data)
							for i = 1, #LC.accountsData do
								LC.accountsData[i]("load", LC.accounts.loaded[player.stuffname], player)
							end
						else
							LC.accounts.loaded[player.stuffname] = {}
						end
					end)
				else
					for i = 1, #LC.accountsData do
						LC.accountsData[i]("load", LC.accounts.loaded[player.stuffname], player)
					end
				end
				player.loadfromserver = nil
			end

			-- loading save.dat data of registered players
			processOtherStuff(player.stuffname, player, "stuffed")

			-- HUD timers
			player.hud_countload = countdown(player.hud_countload)
			if player.hud_countsave and player.hud_countsave > 0 then
				player.hud_countsave = $ - 1
				if player.hud_st_count > 0 then
					player.hud_st_count = $ - 1
				else
					player.hud_st_count = 18
				end
			end

			-- auto save
			if not player.stuffsave then
				player.stuffsave = 60*TICRATE
				player.hud_st_count = 10
			elseif player.stuffsave == 0 then
				LC.functions.SaveLoadNameStuff(#player, 0, "save")
				player.hud_countsave = 2*TICRATE
				player.stuffsave = 60*TICRATE
			else
				player.stuffsave = $ - 1
				if (leveltime % TICRATE) == (TICRATE-1) and LC.accounts.loaded[player.stuffname] then
					for i = 1, #LC.accountsData do
						LC.accountsData[i]("save", LC.accounts.loaded[player.stuffname], player)
					end
				end
			end
		end
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)
return true
