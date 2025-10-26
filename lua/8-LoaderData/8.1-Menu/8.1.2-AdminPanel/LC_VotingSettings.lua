local LC = LithiumCore

local first = 1

local voting_t = {}
local vote_t = nil

local function clampNav(LC_menu, step)
    LC_menu.nav = $ + step

    if LC_menu.nav < 0 then LC_menu.nav = LC_menu.lastnav end
    if LC_menu.nav > LC_menu.lastnav then LC_menu.nav = 1 end

    -- skip header
    while voting_t[LC_menu.nav+1] and voting_t[LC_menu.nav+1].type == "header" do
        LC_menu.nav = LC_menu.nav + step
        if LC_menu.nav < 0 then LC_menu.nav = LC_menu.lastnav break end
        if LC_menu.nav > LC_menu.lastnav then LC_menu.nav = 1 break end
    end
end

local function stepCvar(entry, step)
    local possible = LC.functions.normalizePossibleValue(entry.PossibleValue)

    -- if PossibleValue is absent → string input, nothing to switch
    if not possible then
        return entry.value, entry.string
    end

    -- if the range is MIN/MAX
    if possible.MIN ~= nil and possible.MAX ~= nil then
        local num = tonumber(entry.value) or entry.defaultvalue or possible.MIN
        num = num + step
        if num < possible.MIN then num = possible.MAX end
        if num > possible.MAX then num = possible.MIN end

        return num, tostring(num)
    end

    -- if enumerations (e.g., CV_OnOff, CV_YesNo)
    local sorted = {}
    for k,v in pairs(possible) do
        table.insert(sorted, {key=k, val=v})
    end
    table.sort(sorted, function(a,b) return a.val < b.val end)

    local curval = entry.value or entry.defaultvalue or sorted[1].val
    local nextval = nil

    for i, el in ipairs(sorted) do
        if el.val == curval then
            local newi = i + step
            if newi < 1 then newi = #sorted end
            if newi > #sorted then newi = 1 end
            nextval = sorted[newi]
            break
        end
    end

    if nextval then
        return nextval.val, nextval.key
    end

    return entry.value, entry.string
end

local t = {
	name = "LC_MENU_VOTESETTINGS",
	type = "admin",
	description = "LC_MENU_VOTESETTINGS_TIP",
	funchud = function(v)
		local LC_menu = LC.menu.player_state
		v.drawScaledNameTag(216*FRACUNIT, 8*FRACUNIT,
			"Voting Settings",
			V_ALLOWLOWERCASE|V_SNAPTOTOP,
			FRACUNIT/2,
			SKINCOLOR_SKY, SKINCOLOR_BLACK
		)

		local real_height = (v.height() / v.dupx())
		local maxslots = real_height/10 - 4
		
		if LC_menu.nav == 1 and first == 2 then first = 1 end
		
		if LC_menu.nav+1 < first then
			first = LC_menu.nav+1
		elseif LC_menu.nav+1 > first + maxslots - 1 then
			first = LC_menu.nav+1 - maxslots + 1
		end

		local y = 0
		for i = first, first+maxslots-1 do
			local entry = voting_t[i]
			if entry then
				local highlight = (LC_menu.nav+1 == i) and "\x82" or ""

				if entry.type == "header" then
					v.drawString(136, 30+y, "\x82"..entry.name, V_SNAPTOTOP, "left")
					v.drawFill(136, 38+y, 177, 2, 24|V_SNAPTOTOP)
					v.drawFill(136, 38+y, 176, 1, 74|V_SNAPTOTOP)
				elseif entry.type == "cvar" and entry.PossibleValue then
					v.drawString(144, 30+y, highlight..entry.name, V_SNAPTOTOP, "thin")
					if LC_menu.nav+1 == i
						v.drawString(308, 30+y, "\x82"..string.char(28)..entry.string..string.char(29), V_SNAPTOTOP, "thin-right")
					else
						v.drawString(308, 30+y, "\x82"..entry.string, V_SNAPTOTOP, "thin-right")
					end
				elseif entry.type == "cvar" and not entry.PossibleValue then
					local cv_str = highlight..entry.name.." "
					local w_cv = v.stringWidth(cv_str, 0, "thin")
					local w_fill = 312 - (144+w_cv)
					v.drawString(144, 30+y, highlight..entry.name, V_SNAPTOTOP, "thin")
					v.drawFill(144+w_cv, 29+y, w_fill, 9, 253|V_SNAPTOTOP)
					
					local str_value = (leveltime % 4) / 2 and LC_menu.nav+1 == i and entry.string.."_" or entry.string
					v.drawString(145+w_cv, 30+y, str_value, V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
				end
				y = y + 10
			end
		end
	end,
	
	funcenter = function()
		local LC_menu = LC.menu.player_state
		voting_t = {}
		
		for vote_name, vote_type in pairs(LC.vote_types) do
			
			table.insert(voting_t, {
				type = "header",
				name = vote_type.name,
				vote_name = vote_name
			})

			-- Cvars
			for _, c in pairs(vote_type.cvars) do
				local cvar_id = c.name:gsub(" ", ""):lower()
				local dyn = LC.serverdata.vote_cvars[vote_name][cvar_id]

				table.insert(voting_t, {
					type   = "cvar",
					name   = c.name,
					vote_name = vote_name,
					cvar_name = cvar_id,
					description = c.description,
					PossibleValue = c.PossibleValue,
					value  = dyn.value,
					string = dyn.string
				})
			end
		end
		
		LC_menu.lastnav = #voting_t-1
		LC_menu.nav = 1
		LC_menu.tip = LC.functions.getStringLanguage(voting_t[LC_menu.nav+1].description)
	end,
		
	funchook = function(key)
		local player = consoleplayer
		local LC_menu = LC.menu.player_state

		if voting_t[LC_menu.nav+1].type == "cvar" then
			local entry = voting_t[LC_menu.nav+1]
			if entry.PossibleValue then
				local step = (LC_menu.shift and 10) or 1
				if LC.functions.GetMenuAction(key.name) == LCMA_NAVRIGHT then
					entry.value, entry.string = stepCvar(entry, step)
					entry.changed = true
				elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVLEFT then
					entry.value, entry.string = stepCvar(entry, -step)
					entry.changed = true
				end
			else
				local new_str = entry.string
				new_str = LC.functions.InputText(
					"text",
					new_str,
					key,
					LC_menu.capslock,
					LC_menu.shift,
					16
				)
				entry.changed = new_str ~= entry.string and true or entry.changed
				entry.string = new_str
			end
		end
		
		if LC.functions.GetMenuAction(key.name) == LCMA_NAVDOWN or LC.functions.GetMenuAction(key.name) == LCMA_NAVUP or LC.functions.GetMenuAction(key.name) == LCMA_BACK then
			if voting_t[LC_menu.nav+1].type == "cvar" and voting_t[LC_menu.nav+1].changed then
				local entry = voting_t[LC_menu.nav+1]
				COM_BufInsertText(consoleplayer, "LC_votingsettings "..entry.vote_name.." "..entry.cvar_name.." \""..entry.string.."\"")
			end
		end
		
		if LC.functions.GetMenuAction(key.name) == LCMA_NAVDOWN then
			clampNav(LC_menu, 1)
			LC_menu.tip = LC.functions.getStringLanguage(voting_t[LC_menu.nav+1].description)
			return true
		elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVUP then
			clampNav(LC_menu, -1)
			LC_menu.tip = LC.functions.getStringLanguage(voting_t[LC_menu.nav+1].description)
			return true
		end
		
	end
}

table.insert(LC_Loaderdata["menu"], t)

return true
