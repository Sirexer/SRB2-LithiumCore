freeslot("sfx_zvnow", "sfx_zvpass", "sfx_zvfail")
freeslot("sfx_qvnow", "sfx_qvfail", "sfx_qvpass")

if not LithiumCore
	rawset (_G, "LithiumCore", {
		info = {version = 1, subversion = 0, provisional = "Alpha"},
		vote_types = {}, -- Callvote states
		commands = {}, -- Commands for console
		consvars = {}, -- Server Variable commands
		client_consvars = {}, -- Client Variable commands
		functions = {}, -- LithiumCore Functions
		replaced_functions = {},
		Emotes = {},  -- Emotes on the server
		CMD = {},
		loadconfig = true, -- The indicator shows if the script is loading the config
		
		cache = {
			["hud"] = {}
		},
		
		-- Place Holder
		CV_VoteSFX = {Off = 0, SRB2 = 1, Zandronum = 2, QuakeIII = 3},
		VoteSFX = {
			["SRB2"] = {
				now = sfx_flgcap,
				pass = sfx_lvpass,
				fail = sfx_lose,
			},
			
			["Zandronum"] = {
				now = sfx_zvnow,
				pass = sfx_zvpass,
				fail = sfx_zvfail,
			},
			
			["QuakeIII"] = {
				now = sfx_qvnow,
				pass = sfx_qvpass,
				fail = sfx_qvfail,
			}
		}
	})
end

if not CV_VoteSFX then
	local ro = setmetatable({}, {
			__index = LithiumCore.CV_VoteSFX,
			__newindex = function(_, k, v)
				error("attempt to modify read-only table (key = " .. tostring(k) .. ")", 2)
			end,
			__metatable = "locked"
		})
	rawset (_G, "CV_VoteSFX", ro)
end

if not LC_Loaderdata -- Loads the date when Lithcore is loaded
	rawset (_G, "LC_Loaderdata", {
		["hook"] = {},
		["vote"] = {},
		["consvar_menu"] = {},
		["commands_menu"] = {},
		["accountdata"] = {},
		["menu"] = {},
		["emote"] = {}
	})
end

if not LC_LoaderCFG -- Loads the CFG, after the server starts
	rawset (_G, "LC_LoaderCFG", {
		["client"] = {},
		["server"] = {}
	})
end

return true
