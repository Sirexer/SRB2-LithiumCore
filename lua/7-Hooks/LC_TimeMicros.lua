local LC = LithiumCore

local hooksintics = {
	["ThinkFrame"] = true,
	["PreThinkFrame"] = true,
	["PostThinkFrame"] = true,
	["BotAI"] = true,
	["BotTiccmd"] = true,
	["PlayerThink"] = true,
	["MobjThinker"] = true,
	["BossThinker"] = true,
	["HUD"] = true
}

-- safe sorting: copy of the table
local function sortHooksByTime(hooks)
	local copy = {}
	for i = 1, #hooks do copy[i] = hooks[i] end
	table.sort(copy, function(a, b)
		return (a.TimeMicros or 0) > (b.TimeMicros or 0)
	end)
	return copy
end

-- drawing of a single hook
local function drawHook(v, x, y, h)
	local h_name = h.name
	local h_tms = 0
	if LC.serverdata.HooksToggle[h.name] then
		h_name = "\x83"..h_name
		h_tms = h.TimeMicros or 0
	else
		h_name = "\x85"..h_name
	end

	v.drawString(2+x, 4+y, h_name, V_SNAPTOTOP|V_SNAPTOLEFT|V_ALLOWLOWERCASE, "small")
	v.drawString(88+x, 4+y, h_tms, V_SNAPTOTOP|V_SNAPTOLEFT|V_ALLOWLOWERCASE, "small-right")
	return h_tms
end

local hooktable = {
	name = "LC.TimeMicros",
	type = "HUD",
	typehud = {"game", "scores", "intermission", "titlecard", "title"},
	priority = 2000,
	toggle = true,
	TimeMicros = 0,
	func = function(v, player, camera)
		if not (consoleplayer and consoleplayer.LC_debughud) then return end

		local x, y, total = 0, 0, 0
		local real_height = v.height() / v.dupx()
		local hook = consoleplayer.LC_debughud.hook

		if hook ~= "all" then
			local hooklist = LC.Hooks[hook]
			if not hooklist then return end

			v.drawString(2+x, y, "\x82"..hook..":", V_SNAPTOTOP|V_SNAPTORIGHT|V_ALLOWLOWERCASE, "small")

			-- sorting hooks by TimeMicros
			hooklist = sortHooksByTime(hooklist)

			for _, h in ipairs(hooklist) do
				total = total + drawHook(v, x, y, h)
				y = y + 4
			end
		else
			for k, va in pairs(LC.Hooks) do
				if va[1] then
					y = y + 4
					if y+16 > real_height then
						y, x = 4, x + 104
					end
					local header_x, header_y, header_total = x, y, 0

					-- sorting within a group of hooks
					va = sortHooksByTime(va)

					for _, h in ipairs(va) do
						if y+4 > real_height then
							y, x = 4, x + 104
						end
						header_total = header_total + drawHook(v, x, y, h)
						if hooksintics[k] then
							total = total + (h.TimeMicros or 0)
						end
						y = y + 4
					end

					v.drawString(2+header_x, header_y, "\x82"..k..":", V_SNAPTOTOP|V_SNAPTOLEFT, "small")
					v.drawString(88+header_x, header_y, "\x82"..header_total, V_SNAPTOTOP|V_SNAPTOLEFT, "small-right")
					y = y + 2
				end
			end
		end

		v.drawString(2+x, 4+y, "\x82Total:", V_SNAPTOTOP|V_SNAPTOLEFT, "small")
		v.drawString(88+x, 4+y, "\x82"..total, V_SNAPTOTOP|V_SNAPTOLEFT, "small-right")
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)
return true
