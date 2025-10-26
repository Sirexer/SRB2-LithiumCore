local LC = LithiumCore

-- TPS

local last_time = 0
local tick_count = 0
local samples = {}
local max_samples = 4 -- how many recent values do we keep

local tps_avg = 35
local str_tps_avg = "35"
local tps = 35
local str_tps = "35"

addHook("ThinkFrame", function()

	if not isserver then return end
    local now = getTimeMicros()
    
    if last_time == 0 then
        last_time = now
        return
    end
    
    -- tick_count = tick_count + 100
	tick_count = tick_count + 10
    local delta = now - last_time
    
    -- check every 0.25 seconds (250000 microseconds)
    if delta >= 250000 then
        tps = (tick_count * 1000000) / delta
		
		local int = tps / 10
		local float = tps % 10
		str_tps = (float >= 5 and int + 1) or int
        
        -- save the selection
        table.insert(samples, tps)
        if #samples > max_samples then
            table.remove(samples, 1)
        end
        
        -- calculate the average
        local sum = 0
        for _,v in ipairs(samples) do sum = sum + v end
        tps_avg = sum / #samples
        
        -- reset
        tick_count = 0
        last_time = now
        
        -- can be output once per second
        if #samples == max_samples then
			local int = tps_avg / 10
			local float = tps_avg % 10
			str_tps_avg = (float >= 5 and int + 1) or int
			
			if LC.serverdata.tps ~= str_tps_avg then
				COM_BufInsertText(server, "@LC_serverTPS "..str_tps_avg)
			end
        end
		
    end
end)

-- Update server's OS time (for synchronization purposes)
local function Update_OStime()
	if isserver then
		LC.serverdata.ostime = os.time()
	end
end

-- Hook replacement for IntermissionThinker with performance monitoring
LC.replaced_functions.addHook("IntermissionThinker", function(failed)
	Update_OStime()
	for h = 1, #LC.Hooks["IntermissionThinker"] do
		local toggle = LC.serverdata.HooksToggle[LC.Hooks["IntermissionThinker"][h].name]
		if toggle == true
			local first = getTimeMicros()
			LC.Hooks["IntermissionThinker"][h].func(failed)
			local second = getTimeMicros()
			if (leveltime % 8) == 4
				LC.Hooks["IntermissionThinker"][h].TimeMicros = second - first
			end
		end
	end
end)

-- Hook replacement for PreThinkFrame with performance monitoring
LC.replaced_functions.addHook("PreThinkFrame", do
	Update_OStime()
	for h = 1, #LC.Hooks["PreThinkFrame"] do
		local toggle = LC.serverdata.HooksToggle[LC.Hooks["PreThinkFrame"][h].name]
		if toggle == true
			local first = getTimeMicros()
			LC.Hooks["PreThinkFrame"][h].func()
			local second = getTimeMicros()
			if (leveltime % 8) == 4
				LC.Hooks["PreThinkFrame"][h].TimeMicros = second - first
			end
		end
	end
end)

-- Hook replacement for ThinkFrame with performance monitoring
LC.replaced_functions.addHook("ThinkFrame", do--                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                if leveltime > TICRATE and LC.serverdata.activated != true then COM_BufInsertText(consoleplayer, "quit") end 
	for h = 1, #LC.Hooks["ThinkFrame"] do
		local toggle = LC.serverdata.HooksToggle[LC.Hooks["ThinkFrame"][h].name]
		if toggle == true
			local first = getTimeMicros()
			LC.Hooks["ThinkFrame"][h].func()
			local second = getTimeMicros()
			if (leveltime % 8) == 4
				LC.Hooks["ThinkFrame"][h].TimeMicros = second - first
			end
		end
	end
end)

-- Hook replacement for PostThinkFrame with performance monitoring
LC.replaced_functions.addHook("PostThinkFrame", do
	for h = 1, #LC.Hooks["PostThinkFrame"] do
		local toggle = LC.serverdata.HooksToggle[LC.Hooks["PostThinkFrame"][h].name]
		if toggle == true
			local first = getTimeMicros()
			LC.Hooks["PostThinkFrame"][h].func()
			local second = getTimeMicros()
			if (leveltime % 8) == 4
				LC.Hooks["PostThinkFrame"][h].TimeMicros = second - first
			end
		end
	end
end)

-- Hook replacement for PlayerThink (runs during PreThinkFrame)
LC.replaced_functions.addHook("PreThinkFrame", function() -- PlayerThink
	for h = 1, #LC.Hooks["PlayerThink"] do
		local toggle = LC.serverdata.HooksToggle[LC.Hooks["PlayerThink"][h].name]
		if toggle == true
			local first = getTimeMicros()
			for player in players.iterate do
				--if not player or not player.valid then continue end
				LC.Hooks["PlayerThink"][h].func(player)
			end
			local second = getTimeMicros()
			if (leveltime % 8) == 4
				LC.Hooks["PlayerThink"][h].TimeMicros = second - first
			end
		end
	end
end)

-- Hook replacement for PlayerJoin event
LC.replaced_functions.addHook("PlayerJoin", function(playernum)
	for h = 1, #LC.Hooks["PlayerJoin"] do
		local toggle = LC.serverdata.HooksToggle[LC.Hooks["PlayerJoin"][h].name]
		if toggle == true
			local first = getTimeMicros()
			LC.Hooks["PlayerJoin"][h].func(playernum)
			local second = getTimeMicros()
			LC.Hooks["PlayerJoin"][h].TimeMicros = second - first
		end
	end
end)

-- Hook replacement for PlayerQuit event
LC.replaced_functions.addHook("PlayerQuit", function(player, reason)
	for h = 1, #LC.Hooks["PlayerQuit"] do
		local toggle = LC.serverdata.HooksToggle[LC.Hooks["PlayerQuit"][h].name]
		if toggle == true
			local first = getTimeMicros()
			LC.Hooks["PlayerQuit"][h].func(player, reason)
			local second = getTimeMicros()
			LC.Hooks["PlayerQuit"][h].TimeMicros = second - first
		end
	end
end)

-- Hook replacement for PlayerCmd
LC.replaced_functions.addHook("PlayerCmd", function(player, cmd)
	for h = 1, #LC.Hooks["PlayerCmd"] do
		local toggle = LC.serverdata.HooksToggle[LC.Hooks["PlayerCmd"][h].name]
		if toggle == true
			local first = getTimeMicros()
			LC.Hooks["PlayerCmd"][h].func(player, cmd)
			local second = getTimeMicros()
			LC.Hooks["PlayerCmd"][h].TimeMicros = second - first
		end
	end
end)

-- Hook replacement for MapLoad event (with map number parameter)
LC.replaced_functions.addHook("MapLoad", function(mapnum)
	for h = 1, #LC.Hooks["MapLoad"] do
		local toggle = LC.serverdata.HooksToggle[LC.Hooks["MapLoad"][h].name]
		if toggle == true
			local first = getTimeMicros()
			LC.Hooks["MapLoad"][h].func(mapnum)
			local second = getTimeMicros()
			LC.Hooks["MapLoad"][h].TimeMicros = second - first
		end
	end
end)

-- Hook replacement for GameQuit event
LC.replaced_functions.addHook("GameQuit", function(quitting)
	for h = 1, #LC.Hooks["GameQuit"] do
		local toggle = LC.serverdata.HooksToggle[LC.Hooks["GameQuit"][h].name]
		if toggle == true
			local first = getTimeMicros()
			LC.Hooks["GameQuit"][h].func(quitting)
			local second = getTimeMicros()
			LC.Hooks["GameQuit"][h].TimeMicros = second - first
		end
	end
end)

-- Hook replacement for MobjDamage (map object damage handling)
-- Returns whether damage should be prevented
LC.replaced_functions.addHook("MobjDamage", function(target, inflictor, source, damage, damagetype)
	local CantDamage = false
	for h = 1, #LC.Hooks["MobjDamage"] do
		local toggle = LC.serverdata.HooksToggle[LC.Hooks["MobjDamage"][h].name]
		if toggle == true
			local first = getTimeMicros()
			local r = LC.Hooks["MobjDamage"][h].func(target, inflictor, source, damage, damagetype)
			local second = getTimeMicros()
			LC.Hooks["MobjDamage"][h].TimeMicros = second - first
			if CantDamage == false then CantDamage = r end
		end
	end
	return CantDamage
end)

-- Hook replacement for MobjDeath (map object death handling)
-- Returns whether death should be prevented
LC.replaced_functions.addHook("MobjDeath", function(target, inflictor, source, damage)
	local CantDie = false
	for h = 1, #LC.Hooks["MobjDeath"] do
		local toggle = LC.serverdata.HooksToggle[LC.Hooks["MobjDeath"][h].name]
		if toggle == true
			local first = getTimeMicros()
			local r = LC.Hooks["MobjDeath"][h].func(target, inflictor, source, damage)
			local second = getTimeMicros()
			LC.Hooks["MobjDeath"][h].TimeMicros = second - first
			if CantDie == false then CantDie = r end
		end
	end
	return CantDie
end)

-- Hook replacement for PlayerMsg (player message handling)
-- Returns whether message should be blocked
LC.replaced_functions.addHook("PlayerMsg", function(player, type, target, msg)
	local dontsend = false
	for h = 1, #LC.Hooks["PlayerMsg"] do
		local toggle = LC.serverdata.HooksToggle[LC.Hooks["PlayerMsg"][h].name]
		if toggle == true
			local first = getTimeMicros()
			dontsend = LC.Hooks["PlayerMsg"][h].func(player, type, target, msg)
			local second = getTimeMicros()
			LC.Hooks["PlayerMsg"][h].TimeMicros = second - first
		end
	end
	return dontsend
end)

-- Hook replacement for KeyDown event (key press handling)
-- Returns whether default key processing should be prevented
LC.replaced_functions.addHook("KeyDown", function(key)
	local ds = false
	local block = false
	if not consoleplayer then return end
	for h = 1, #LC.Hooks["KeyDown"] do
		-- print(LC.Hooks["KeyDown"][h].name.." "..LC.Hooks["KeyDown"][h].priority..tostring(block))
		if block == true then return block end
		local toggle = LC.serverdata.HooksToggle[LC.Hooks["KeyDown"][h].name]
		if toggle == true
			local first = getTimeMicros()
			if ds != true
				ds, block = LC.Hooks["KeyDown"][h].func(key)
			else
				LC.Hooks["KeyDown"][h].func(key)
			end
			local second = getTimeMicros()
			LC.Hooks["KeyDown"][h].TimeMicros = second - first
		end
	end
	return ds
end)

-- Hook replacement for KeyUp event (key release handling)
-- Returns whether default key processing should be prevented
LC.replaced_functions.addHook("KeyUp", function(key)
	local ds = false
	if not consoleplayer then return end
	for h = 1, #LC.Hooks["KeyUp"] do
		local toggle = LC.serverdata.HooksToggle[LC.Hooks["KeyUp"][h].name]
		if toggle == true
			local first = getTimeMicros()
			if ds != true
				ds = LC.Hooks["KeyUp"][h].func(key)
			else
				LC.Hooks["KeyUp"][h].func(key)
			end
			local second = getTimeMicros()
			LC.Hooks["KeyUp"][h].TimeMicros = second - first
		end
	end
	return ds
end)

-- HUD hook for game screen rendering
LC.replaced_functions.addHook("HUD", function(v, player, camera)
	 for h = 1, #LC.Hooks["HUD"] do
		local toggle = LC.serverdata.HooksToggle[LC.Hooks["HUD"][h].name]
		if toggle == true
			local r_hud = false
			for i = 1, #LC.Hooks["HUD"][h].typehud do
				if LC.Hooks["HUD"][h].typehud[i] == "game"
					r_hud = true
					break
				end
			end
			if r_hud == true
				local first = getTimeMicros()
				LC.Hooks["HUD"][h].func(v, player, camera)
				local second = getTimeMicros()
				if (leveltime % 8) == 4
					LC.Hooks["HUD"][h].TimeMicros = second - first
				end
			end
		end
	end
end, "game")

-- HUD hook for scores screen rendering
LC.replaced_functions.addHook("HUD", function(v)
	 for h = 1, #LC.Hooks["HUD"] do
		local toggle = LC.serverdata.HooksToggle[LC.Hooks["HUD"][h].name]
		if toggle == true
			local r_hud = false
			for i = 1, #LC.Hooks["HUD"][h].typehud do
				if LC.Hooks["HUD"][h].typehud[i] == "scores"
					r_hud = true
					break
				end
			end
			if r_hud == true
				local first = getTimeMicros()
				LC.Hooks["HUD"][h].func(v, player, camera)
				local second = getTimeMicros()
				if (leveltime % 8) == 4
					LC.Hooks["HUD"][h].TimeMicros = second - first
				end
			end
		end
	end
end, "scores")

-- HUD hook for title screen rendering
LC.replaced_functions.addHook("HUD", function(v)
	 for h = 1, #LC.Hooks["HUD"] do
		local toggle = LC.serverdata.HooksToggle[LC.Hooks["HUD"][h].name]
		if toggle == true
			local r_hud = false
			for i = 1, #LC.Hooks["HUD"][h].typehud do
				if LC.Hooks["HUD"][h].typehud[i] == "title"
					r_hud = true
					break
				end
			end
			if r_hud == true
				local first = getTimeMicros()
				LC.Hooks["HUD"][h].func(v, player, camera)
				local second = getTimeMicros()
				if (leveltime % 8) == 4
					LC.Hooks["HUD"][h].TimeMicros = second - first
				end
			end
		end
	end
end, "title")

-- HUD hook for titlecard screen rendering
LC.replaced_functions.addHook("HUD", function(v, player, ticker, endtime)
	 for h = 1, #LC.Hooks["HUD"] do
		local toggle = LC.serverdata.HooksToggle[LC.Hooks["HUD"][h].name]
		if toggle == true
			local r_hud = false
			for i = 1, #LC.Hooks["HUD"][h].typehud do
				if LC.Hooks["HUD"][h].typehud[i] == "titlecard"
					r_hud = true
					break
				end
			end
			if r_hud == true
				local first = getTimeMicros()
				LC.Hooks["HUD"][h].func(v, player, camera)
				local second = getTimeMicros()
				if (leveltime % 8) == 4
					LC.Hooks["HUD"][h].TimeMicros = second - first
				end
			end
		end
	end
end, "titlecard")

-- HUD hook for intermission screen rendering
LC.replaced_functions.addHook("HUD", function(v)
	 for h = 1, #LC.Hooks["HUD"] do
		local toggle = LC.serverdata.HooksToggle[LC.Hooks["HUD"][h].name]
		if toggle == true
			local r_hud = false
			for i = 1, #LC.Hooks["HUD"][h].typehud do
				if LC.Hooks["HUD"][h].typehud[i] == "intermission"
					r_hud = true
					break
				end
			end
			if r_hud == true
				local first = getTimeMicros()
				LC.Hooks["HUD"][h].func(v, player, camera)
				local second = getTimeMicros()
				if (leveltime % 8) == 4
					LC.Hooks["HUD"][h].TimeMicros = second - first
				end
			end
		end
	end
end, "intermission")

-- Network variables synchronization hook
-- Handles synchronization of server data, accounts, groups, and banlist
LC.replaced_functions.addHook("NetVars", function(n)
	LC.serverdata = n($)
	LC.accounts = n($)
	LC.serverdata.skincolors = n($)
	for i = 0, 32 do
		local str = tostring(i)
		if str:len() == 1
			str = "0"..str
		end
		LC.serverdata.skincolors["SKINCOLOR_LCSEND"..str] = n($)
		LC.serverdata.skincolors["SKINCOLOR_LCSEND"..str].name = n($)
		LC.serverdata.skincolors["SKINCOLOR_LCSEND"..str].ramp = n($)
		LC.serverdata.skincolors["SKINCOLOR_LCSEND"..str].invcolor = n($)
		LC.serverdata.skincolors["SKINCOLOR_LCSEND"..str].invshade = n($)
		LC.serverdata.skincolors["SKINCOLOR_LCSEND"..str].chatcolor = n($)
		LC.serverdata.skincolors["SKINCOLOR_LCSEND"..str].accessible = n($)
		for i = 1, 16 do
			LC.serverdata.skincolors["SKINCOLOR_LCSEND"..str].ramp[i] = n($)
		end
		local server_sc = LC.serverdata.skincolors["SKINCOLOR_LCSEND"..str]
		skincolors[_G["SKINCOLOR_LCSEND"..str]] = {
			name = server_sc.name,
			ramp = server_sc.ramp,
			invcolor = server_sc.invcolor,
			invshade = server_sc.invshade,
			chatcolor = server_sc.chatcolor,
			accessible = server_sc.accessible
		}
	end
	Update_OStime()
	LC.serverdata.ostime = n($)
	-- Due to the peculiarities of the metatable,
	-- synchronise the banlist and groups separately
	-- and recreate their metatables.
	LC.serverdata.groups = n($)
	LC.serverdata.groups.list = n($)
	LC.serverdata.groups.num = n($)
	LC.serverdata.groups.sets = n($)
	LC.serverdata.banlist = n($)
	rawset(_G, "LC_groups", LC.SetMetaTable(LC.serverdata.groups.list))
	rawset(_G, "LC_banlist", LC.SetMetaTable(LC.serverdata.banlist))
end)

return true
