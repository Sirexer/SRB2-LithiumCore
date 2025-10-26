local LC = LithiumCore

local BOT_SUFFIX = "\x84".."[BOT]"
local BOT_PATTERN = string.gsub(BOT_SUFFIX, "%W", "%%%0")
local CV_SERVERNAME = CV_FindVar("servername")

-- ======================
-- Utilities
-- ======================

local function resetServerStats()
    local stats = LC.serverdata
    stats.countplayers, stats.countbots = 0, 0
    stats.completedlevel, stats.afkplayers = 0, 0
    stats.afkplayers_c, stats.afkplayers_nc = 0, 0
end

local function processCommandQueue(queue, target)
	if #queue > 0 then
		local batch = table.remove(queue, 1)
		if batch and batch ~= "" then
			COM_BufInsertText(target or consoleplayer, batch)
		end
	end
end

local function updatePlayerStats(player)
	if player.name:find(BOT_PATTERN) then
		player.is_bot = true
	else
		player.is_bot = false
	end
	player.LC_kills = player.LC_kills or 0
	player.LC_deaths = player.LC_deaths or 0
	if player.quittime > TICRATE*2 and player.jointime < TICRATE*10 then
		COM_BufInsertText(server, "kick "..#player)
	end
end

local function updatePlayerGroup(player)
	if not player.group then
		player.group = "unregistered"
		if server == player then
			player.group = LC.serverdata.groups.sets["superadmin"]
		end
	end
	
	if player.group == "unregistered" and player.stuffname then
		player.group = LC.serverdata.groups.sets["player"]
	end
	
	if player.is_bot then
		player.group = LC.serverdata.groups.sets["bot"]
	end
end

local function updatePlayerAFK(player)
	if not player.is_bot then
		LC.serverdata.countplayers = $ + 1
		if player.LC_afk and player.LC_afk.enabled then
			LC.serverdata.afkplayers = $ + 1
			if player.LC_afk.finished then
				LC.serverdata.afkplayers_c = $ + 1
			else
				LC.serverdata.afkplayers_nc = $ + 1
			end
		end
	else
		LC.serverdata.countbots = $ + 1
	end
end

local function updatePlayerCompletion(player)
	if player.is_bot then return end
	
	local LC_afk = player.LC_afk
	local finished = (player.pflags & PF_FINISHED) ~= 0
	local shouldSet = false

	if finished then
		if not LC_afk or (LC_afk.enabled == false or (LC_afk.enabled and LC_afk.finished)) then
			shouldSet = true
		end
	end

	if shouldSet then
		LC.serverdata.completedlevel = $ + 1
		player.LC_timefinished = player.LC_timefinished or leveltime
		player.realtime = player.LC_timefinished
	else
		player.realtime = leveltime
		--player.LC_timefinished = nil
	end
end

local function processCoopExit()
	if not G_CoopGametype() then return end

	local finished = (LC.serverdata.completedlevel+LC.serverdata.afkplayers_nc)*FU
	local finished_per = 0
	if finished ~= 0 and LC.serverdata.countplayers ~= 0 then
		finished_per = (FixedDiv(finished, LC.serverdata.countplayers*FU) * 100) / FU
	end

	local LC_exitlevel = LC.serverdata.exitlevel
	local LC_timelimit = LC.consvars.timelimit.value*60*TICRATE
	local mapcfg = LC_exitlevel.maps[tostring(gamemap)]
	if mapcfg then
		local time = tonumber(mapcfg)
		if time then LC_timelimit = time*60*TICRATE end
	end

	-- start countdown
	if not LC_exitlevel.countdown then
		if finished_per >= LC.consvars.percomplet.value and LC.serverdata.completedlevel ~= 0 then
			LC_exitlevel.countdown = true
			LC_exitlevel.time = LC.consvars.countdown.value*TICRATE
		elseif LC_timelimit ~= 0 and leveltime+(30*TICRATE) >= LC_timelimit then
			LC_exitlevel.countdown = true
			LC_exitlevel.time = 30*TICRATE
		end
	else
		if (finished_per >= LC.consvars.percomplet.value and LC.serverdata.completedlevel ~= 0)
		or (LC_timelimit ~= 0 and leveltime+(30*TICRATE) >= LC_timelimit) then
			if LC_exitlevel.time > 0 then
				LC_exitlevel.time = $ - 1
			elseif LC.serverdata.completedlevel+LC.serverdata.afkplayers_nc ~= LC.serverdata.countplayers then
				LC_exitlevel.countdown = false
				G_ExitLevel()
			end
		else
			LC_exitlevel.countdown = false
		end
	end

	-- auto exitlevel
	if LC.serverdata.completedlevel >= LC.serverdata.countplayers-LC.serverdata.afkplayers_nc
	and LC.serverdata.completedlevel ~= 0 then
		for player in players.iterate do
			if not (player.pflags & PF_FINISHED) then
				player.pflags = $|PF_FINISHED
			end
		end
	end
end

-- ======================
-- Hook
-- ======================

local hooktable = {
	name = "LC.Main",
	type = "ThinkFrame",
	toggle = true,
	TimeMicros = 0,
	func = function()
		if isserver and CV_SERVERNAME.string ~= LC.consvars["LC_servername"].string then
			CV_Set(CV_SERVERNAME, LC.consvars["LC_servername"].string)
		end

		resetServerStats()

		if consoleplayer and consoleplayer.jointime <= 2 then
			LC.localdata.motd.open = true
		end

		-- processCommandQueue(LC.localdata.cmd_buffer, nil)

		for player in players.iterate do
			if player and player.valid then
				updatePlayerStats(player)
				updatePlayerAFK(player)
				updatePlayerCompletion(player)
				updatePlayerGroup(player)
			end
		end

		processCoopExit()

		if G_IsSpecialStage(gamemap) and LC.functions.playerontheserver == 0 and leveltime > 0 then
			print("Skip the Special Stage because there are no players.")
			G_ExitLevel()
		end

		LC.serverdata.servertime = $ + 1

		if not G_IsSpecialStage(gamemap) and gamestate == GS_LEVEL and multiplayer then
			if LC.serverdata.serverstate["emeralds"] ~= emeralds or LC.serverdata.serverstate["map"] ~= gamemap then
				LC.serverdata.savestate = true
			end
		end

		processCommandQueue(LC.localdata.ComInsert, consoleplayer)

		if leveltime > 1 then
			if LC.serverdata.loadstate then
				local sssv = LC.consvars.saveserverstate.value
				if (sssv == 1 or sssv == 3) and type(LC.serverdata.serverstate["emeralds"]) == "number" then
					emeralds = LC.serverdata.serverstate["emeralds"]
				end
				if (sssv == 1 or sssv == 2)
				and type(LC.serverdata.serverstate["map"]) == "number"
				and LC.serverdata.serverstate["map"] ~= gamemap
				and spstage_start == gamemap then
					G_SetCustomExitVars(LC.serverdata.serverstate["map"], 2)
					G_ExitLevel()
				end
				LC.serverdata.loadstate = false
			elseif LC.serverdata.savestate then
				LC.functions.SaveState()
				LC.serverdata.savestate = false
			end

			if leveltime == 2 and LC.serverdata.serverstate.emeraldsresetmaps then
				for _, mapid in ipairs(LC.serverdata.serverstate.emeraldsresetmaps) do
					if gamemap == mapid then
						emeralds = 0
						print("Emeralds has been reset.")
					end
				end
			end
		end
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)
return true
