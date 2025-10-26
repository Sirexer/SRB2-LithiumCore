local LC = LithiumCore

local P_SpawnMobj = P_SpawnMobj
local P_RemoveMobj = P_RemoveMobj
local P_SetMobjStateNF = P_SetMobjStateNF
local P_MoveOrigin = P_MoveOrigin
local P_MobjFlip = P_MobjFlip
local FU = FU
local MFE_VERTICALFLIP = MFE_VERTICALFLIP

local TICK_INTERVAL = 1  -- Update heavy operations after one tick.

local hooktable = {
	name = "LC.PlayerIndicators",
	type = "PlayerThink",
	toggle = true,
	TimeMicros = 0,
	func = function(player)
		-- init
		if not player.LC_indicators then
			player.LC_indicators = { chat = false, menu = false, _active = false, _tick = 0, _last_state = nil }
		end
		local LC_pi = player.LC_indicators

		local pmo = player.mo
		-- If the player does not have pmo, we will ensure that the indicator is removed and exit.
		if not pmo or not pmo.valid then
			if LC_pi.mo and LC_pi.mo.valid then
				P_RemoveMobj(LC_pi.mo)
				LC_pi.mo = nil
				LC_pi._active = false
			end
			return
		end

		-- calculations once
		local isAFK = player.LC_afk and player.LC_afk.enabled
		local shouldShow = LC_pi.chat or LC_pi.menu or player.quittime > 0 or isAFK

		-- spawn/remove only when state changes
		if shouldShow and not LC_pi._active then
			-- spawn
			local flip = P_MobjFlip(pmo) == -1
			local x, y, z = pmo.x, pmo.y, pmo.z + pmo.height + 16 * pmo.scale
			if flip then z = pmo.z - pmo.height end

			local mo = P_SpawnMobj(x, y, z, MT_LCPI)
			mo.target = pmo
			LC_pi.mo = mo
			LC_pi._active = true
			LC_pi._last_state = nil -- force state set on spawn
		elseif (not shouldShow) and LC_pi._active then
			if LC_pi.mo and LC_pi.mo.valid then
				P_RemoveMobj(LC_pi.mo)
			end
			LC_pi.mo = nil
			LC_pi._active = false
			return
		end

		-- if the indicator is not active — return
		if not LC_pi._active then return end
		local imo = LC_pi.mo
		if not imo or not imo.valid then LC_pi._active = false; return end

		-- heavy operation throttling
		LC_pi._tick = (LC_pi._tick or 0) + 1
		if LC_pi._tick < TICK_INTERVAL then
			-- can still update fuse sometimes:
			if imo.fuse < 5 then imo.fuse = 5 end
			return
		end
		LC_pi._tick = 0

		-- define the desired state
		local desired = nil
		if player.quittime > 0 then desired = "noping"
		elseif LC_pi.menu then desired = "menu"
		elseif LC_pi.chat then desired = "chat"
		elseif isAFK then desired = "afk"
		end

		-- change of state only when changed
		if desired ~= LC_pi._last_state then
			if desired == "noping" then
				P_SetMobjStateNF(imo, S_LCPI_NOPING01)
			elseif desired == "menu" then
				P_SetMobjStateNF(imo, S_LCPI_MENU01)
			elseif desired == "chat" then
				P_SetMobjStateNF(imo, S_LCPI_CHAT01)
			elseif desired == "afk" then
				P_SetMobjStateNF(imo, S_LCPI_AFK01)
			end
			LC_pi._last_state = desired
		end

		-- Keep fuse, scale only when necessary
		if imo.fuse < 5 then imo.fuse = 5 end
		if imo.scale ~= pmo.scale then imo.scale = pmo.scale end

		-- update flip once
		local flip_now = P_MobjFlip(pmo) == -1
		if flip_now then
			if not (imo.eflags & MFE_VERTICALFLIP) then imo.eflags = imo.eflags | MFE_VERTICALFLIP end
		else
			if (imo.eflags & MFE_VERTICALFLIP) then imo.eflags = imo.eflags & (~MFE_VERTICALFLIP) end
		end

		-- position
		local tx, ty, tz = pmo.x, pmo.y, pmo.z + pmo.height + 16 * pmo.scale
		if flip_now then tz = pmo.z - pmo.height end
		P_MoveOrigin(imo, tx, ty, tz)
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true
