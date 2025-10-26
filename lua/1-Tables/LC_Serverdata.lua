LithiumCore.serverdata = { -- table of serverdata
	//name = "SRB2 Server", -- Server name, it is set once
	//serverfolder = "client/LC/ServerHost/SRB2 Server/", -- Server configuration folder
	id = nil,
	clientfolder = "client/LithiumCore", -- Addon Folder
	folder = "LithiumCore",
	servername = "Dedicated Server",
	loadstate = true, -- Return the map and emeralds, after starting the server
	savestate = false, -- Save the map and emeralds
	servertime = 0, -- How long does the server run
	ostime = os.time(),
	tps = 35,
	countplayers = 0, -- How many players are there on the server
	countbots = 0,
	completedlevel = 0,
	afkplayer = 0,
	serverstate = {}, -- Which maps will reset emeralds
	banwords = {}, -- TwitchUser ON
	HooksToggle = {},
	skincolors = {},
	commands = {},
	banchars = {},
	banlist = {},
	emotes = {},
	groups = {list = {}, sets = {}, num = {}},
	vote_cd = 0,
	vote_cvars = {},
	exitlevel = { -- Countdown to level exit
		countdown = false,
		time = 0,
		maps = {} -- Maps with their own limit
	},
	motd = "" -- A message box when a player joins the server
}

return true
