local LC = LithiumCore

local tables = nil

local loadFile = function(arg)
	local file
	local loaded = false
	xpcall(
		function()
			file = dofile(arg)
			loaded = true
		end,
		function()
			file = nil
			loaded = false
		end
	)
	return file, loaded
end

LC.functions.AddonLoader = function(...)
	if type(tables) == "table" then
		return tables
	end
	
	local Addon = {}
	
	Addon.info = loadFile("info.lua")
	
	if not Addon.info then
		print("\x82".."WARNING\x80"..": The file info.lua was not found.")
		return
	elseif type(Addon.info) != "table"
		print("\x82".."WARNING\x80"..": Info.lua should return a table with the keys: name, description, author, version(major, minor, sub)")
		return
	elseif type(Addon.info.name) != "string"
		print("\x82".."WARNING\x80"..": The table from info.lua, does not contain the addon name, must be string!")
		return
	end
	
	local fullNameAddon = Addon.info.name
	
	if Addon.info.version then
		if type(Addon.info.version) == "string" then
			fullNameAddon = fullNameAddon.." "..Addon.info.version
		elseif type(Addon.info.version) == "table" then
			local _version = Addon.info.version
			if _version.major != nil then fullNameAddon = fullNameAddon.." ".._version.major end
			if _version.minor != nil then fullNameAddon = fullNameAddon..".".._version.minor end
			if _version.sub != nil then fullNameAddon = fullNameAddon..".".._version.sub end
		end
	end
	
	if type(Addon.info.author) == "string" then
		fullNameAddon = fullNameAddon.." ("..Addon.info.author..")"
	end
	
	print("\x88".."LithiumCore\x80"..": Loading "..fullNameAddon.."...")
	
	local tablename = Addon.info.name:gsub(" ", "_")
	
	-- Create Data
	LC.serverdata[tablename] = {}
	LC.localdata[tablename] = {}
	tables = {
		serverdata = LC.serverdata[tablename],
		localdata = LC.localdata[tablename],
		clientfolder = LC_serverdata.clientfolder,
		serverfolder = LC_serverdata.serverfolder,
		functions = {}
	}
	
	-- Load Freeslots if there are any
	Addon.freeslots = loadFile("freeslots.lua")
	
	-- Load Functions
	Addon.functions = loadFile("functions.lua")
	local funcs = {count = 0}

	for k,v in pairs(Addon.functions) do
		if type(v) != "function" then
			Addon.functions[k] = nil
			print("\x82".."WARNING\x80"..": "..k.." is not a function!")
			continue
		end
		funcs.count = $ + 1
		tables.functions[k] = v
		if funcs.list then funcs.list = funcs.list..", "..k end
		if not funcs.list then funcs.list = k end
	end
	
	if funcs.count == 1 then
		print("\x88".."LithiumCore\x80"..": "..funcs.list.." functions is loaded.")
	elseif funcs.count > 1 then
		print("\x88".."LithiumCore\x80"..": "..funcs.list.." functions are loaded.")
	else
		print("\x88".."LithiumCore\x80"..": There are no functions!")
	end
	
	-- Load Consvars
	Addon.functions = loadFile("consvars.lua")
	
	-- Load Commands
	Addon.functions = loadFile("commands.lua")
	
	-- Load Hooks
	Addon.functions = loadFile("Hooks.lua")
	
	-- Load Menu
	Addon.functions = loadFile("Menu.lua")
	
	-- Load CFG
	Addon.functions = loadFile("Config.lua")
	
	tables = nil
end

return true
