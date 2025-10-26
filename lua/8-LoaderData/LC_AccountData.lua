local LC = LithiumCore

local SaveTable = {
	function(action, datatable, player) -- srb2data(lives, scores, shield)
		if not action and not datatable and not player then return end
		if not G_CoopGametype() then return end
		if string.lower(action) == "load"
			if datatable.score then player.score = datatable.score end
			if datatable.lives then player.lives = datatable.lives end
			if datatable.shield != nil then player.powers[pw_shield] = datatable.shield end
			P_SpawnShieldOrb(player)
		elseif string.lower(action) == "save"
			datatable.score = player.score
			datatable.lives = player.lives
			datatable.shield = player.powers[pw_shield]
		end
	end,
	
	function(action, datatable, player) -- LCdata(group)
		if not action and not datatable and not player then return end
		if string.lower(action) == "load"
			if datatable.group != nil
				if LC.serverdata.groups.list[datatable.group]
					player.group = datatable.group
					if LC.serverdata.groups.list[datatable.group].admin == true
						COM_BufInsertText(server, "promote "..#player)
					end
				end
			end
			if datatable.silence
				player.cantspeak = silence + TICRATE*60
			end
			if datatable.timeplayed != nil
				player.LC_timeplayed = {}
				local LC_timeplayed = datatable.timeplayed
				local sp = 1
				local d = 1
				sp = string.find(LC_timeplayed, ":")
				player.LC_timeplayed.hours = tonumber(string.sub(LC_timeplayed, 1, sp-1))
				d = sp+1
				sp = string.find(LC_timeplayed, ":", d+1)
				player.LC_timeplayed.minutes = tonumber(string.sub(LC_timeplayed, d, sp-1))
				d = sp+1
				sp = string.find(LC_timeplayed, ":", d+1)
				player.LC_timeplayed.seconds = tonumber(string.sub(LC_timeplayed, d, sp-1))
				d = sp+1
				player.LC_timeplayed.tics = tonumber(string.sub(LC_timeplayed, d))
			end
			if datatable.LC_ignorelist != nil
				if not player.LC_ignorelist then player.LC_ignorelist = {} end
				player.LC_ignorelist.accounts = datatable.LC_ignorelist
			end
			if datatable.LC_hideadmin != nil then player.LC_hideadmin = datatable.LC_hideadmin end
			if datatable.LC_hidegroup != nil then player.LC_hidegroup = datatable.LC_hidegroup end
			if datatable.LC_emotes != nil then player.LC_emotes = datatable.LC_emotes end
		elseif string.lower(action) == "save"
			if player.group != nil
				datatable.group = player.group
			end
			if player.cantspeak
				datatable.silence = player.cantspeak
			else
				datatable.silence = 0
			end
			if player.LC_timeplayed
				datatable.timeplayed = player.LC_timeplayed.hours..":"..player.LC_timeplayed.minutes..":"..player.LC_timeplayed.seconds..":"..player.LC_timeplayed.tics
			else
				datatable.timeplayed = "0:0:0:0"
			end
			if player.LC_ignorelist and player.LC_ignorelist.accounts
				datatable.LC_ignorelist = player.LC_ignorelist.accounts
			end
			if player.LC_hideadmin then datatable.LC_hideadmin = true
			else datatable.LC_hideadmin = false end
			if player.LC_hidegroup then datatable.LC_hidegroup = true
			else datatable.LC_hidegroup = false end
			if player.LC_emotes != nil
				local t = {}
				for i = 1, 9 do
					table.insert(t, player.LC_emotes[i])
				end
				datatable.LC_emotes = t
			end
		end
	end
}

for i = 1, #SaveTable do
	table.insert(LC_Loaderdata["accountdata"], SaveTable[i])
end


local function skipscrap(action, datatable, player) -- skip's craps
	if not action and not datatable and not player then return end
	if not G_CoopGametype() then return end
	if string.lower(action) == "load"
		if datatable.skipscrap != nil then player.skipscrap = datatable.skipscrap end
	elseif string.lower(action) == "save"
		datatable.skipscrap = player.skipscrap
	end
end

if SkipBadnikScrap
	LC.functions.AddAccountData(skipscrap)
end

return true
