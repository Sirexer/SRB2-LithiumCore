local LC = LithiumCore

local sha1 = sha1.sha1
local RNG = RNG

local hooktable = {
	name = "LC.Main",
	type = "PlayerJoin",
	toggle = true,
	TimeMicros = 0,
	func = function(playernum)
	
		local g_rng = P_RandomFixed()
		if isserver or
		consoleplayer and playernum == #consoleplayer
			RNG.RandomSeed(g_rng)
			local get_key = LC.functions.GetRandomPassword("ALL", 16)
			get_key = sha1(get_key)
			LC.masterKeys[playernum] = get_key
			RNG.RandomSeed()
		end
		
		local new_table = {}
		for i = 1, #LC.serverdata.banlist do
			local b = LC.serverdata.banlist[i]
			if b.timestamp_unban == nil or b.timestamp_unban > LC.serverdata.ostime
				table.insert(new_table, b)
			end
		end
		LC.serverdata.banlist = new_table
		if isserver
			LC.functions.SaveBanlist()
		end
		if not isserver
			if consoleplayer.LC_id != true
				COM_BufInsertText(consoleplayer, "@LC_send_id "..LC.localdata.id)
			end
			local client_time = os.time()
			local server_time = LC.serverdata.ostime
			if consoleplayer.jointime < 3600*TICRATE
				if client_time == nil then
					print("Incorrect date, please check your system clock.")
					COM_BufInsertText(consoleplayer, "quit")
				end
				local differ_time =	abs(server_time - client_time)
				if differ_time > 86400 -- 1 day
					COM_BufInsertText(consoleplayer, "exitgame")
					LC.localdata.timedelayserver = {
						server = server_time,
						client = client_time
					}
				end
			end
			if not LC.serverdata.banlist[1] then return end
			local banlist = LC.serverdata.banlist
			local server_id = LC.serverdata.id
			local account = LC.localdata.savedpass[server_id]
			for i = 1, #LC.serverdata.banlist do
				local id = banlist[i].id
				local name = banlist[i].name
				local username = banlist[i].username
				local unban = banlist[i].timestamp_unban
				local reason = banlist[i].reason
				local moderator = banlist[i].moderator
				if LC.localdata.id == id
				or account and username == account.username
					LC.functions.ban(reason, unban, moderator, LC.consvars["LC_servername"].string, server_time)
				end
			end
		end
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true
