-- LC_SetMetatable.lua
--
-- This file provides a protected proxy wrapper around parts of the
-- LithiumCore (LC) data structure. It controls and validates reads/writes
-- to sensitive tables, provides safe iterators, and normalizes some user-facing
-- operations (like inserting into perms/sfx).
--
-- The file implements:
--  - a small set of validators (op table) that consistently return
--    either `true` or `false, "error message"`;
--  - a factory to wrap nested tables with the same proxy behavior;
--  - controlled write rules for LC.serverdata and LC.localdata;
--  - special handling for LC.serverdata.groups and LC.serverdata.emotes
--    including normalized insertion/deletion into group.perms and
--    emote.sfx arrays;
--  - safe __len and __index behavior for the exposed proxies;
--
-- Comments are intentionally verbose to explain reasoning and flow.

local LC = LithiumCore

--[[
  Helper factory: expect_type
  Returns a validator function checking if `type(value) == tp`.
  Returns `true` on success, or `false, error_message` on failure.
]]
local function expect_type(tp, name)
    return function(a)
        if type(a) == tp then
            return true
        else
            return false, "Expected " .. name .. ": got type " .. type(a)
        end
    end
end

-- Short alias for numeric type check.
local function is_number(a)
    return type(a) == "number"
end

-- Validates that a value is a number in range [min, max].
-- Returns `true` on success or `false, message` on failure.
local function is_number_in_range(a, min, max, name)
    if type(a) ~= "number" then
        return false, string.format("Expected %s: got %s (type %s)", name, tostring(a), type(a))
    end
    if a < min or a > max then
        return false, string.format("%s must be in range [%d, %d], got %s", name, min, max, tostring(a))
    end
    return true
end

--[[
  `op` contains standard validators for multiple data types.
  These are used throughout to enforce strict value constraints.
  Some depend on SRB2 environment globals like `states`, `sfxinfo`, `skincolors`.

  Note about `state` and `sfx` validators:
    - They expect global arrays `states` and `sfxinfo` to exist in the
      environment. These globals are part of the SRB2 environment and
      are used here as the authoritative source for valid indices.

  Aliases INT and UNIT are provided for compatibility with older naming.
]]
local op = {
    INT32 = expect_type("number", "INT32"),
    INT16 = function(a) return is_number_in_range(a, -32768, 32767, "INT16") end,
    INT8  = function(a) return is_number_in_range(a, -128, 127, "INT8") end,

    -- UINT32 is allowed to be any non-negative number. It still checks the type.
    UINT32 = function(a)
        if type(a) ~= "number" then
            return false, "Expected UINT32: got type " .. type(a)
        elseif a < 0 then
            return false, "UINT32 must be >= 0, got " .. tostring(a)
        else
            return true
        end
    end,

    UINT16 = function(a) return is_number_in_range(a, 0, 65535, "UINT16") end,
    UINT8  = function(a) return is_number_in_range(a, 0, 255, "UINT8") end,

    table   = expect_type("table", "table"),
    boolean = expect_type("boolean", "boolean"),
    string  = expect_type("string", "string"),
    func    = expect_type("function", "function"),
    thread  = expect_type("thread", "thread"),

    -- `state` must be a valid index into the `states` table (0-based range check).
    state = function(a)
        if not is_number(a) then
            return false, "Expected INT32: got type " .. type(a)
        end
        if a >= #states or a < 0 then
            return false, "states[] index " .. a .. " out of range (0 - " .. (#states-1) .. ")"
        end
        return true
    end,

    -- `sfx` must be a valid index into the `sfxinfo` table (0-based range check).
    sfx = function(a)
        if not is_number(a) then
            return false, "Expected INT32: got type " .. type(a)
        end
        if a >= #sfxinfo or a < 0 then
            return false, "sfxinfo[] index " .. a .. " out of range (0 - " .. (#sfxinfo-1) .. ")"
        end
        return true
    end,

    -- `skincolor` must be a valid index into the `skincolors` table (1-based range check).
    skincolor = function(a)
        if not is_number(a) then
            return false, "Expected INT32: got type " .. type(a)
        end
        if a >= #skincolors or a < 1 then
            return false, "skincolors[] index " .. a .. " out of range (1 - " .. (#skincolors-1) .. ")"
        end
        return true
    end,
	
	-- Validate V_MAP values using LC.functions.GetColormap; rely on the API to verify validity.
	V_MAP = function(a)
		/*
        if not is_number(a) then
            return false, "Expected INT32: got type " .. type(a)
        end
		*/
		local valid = LC.functions.GetColormap(a)
		if valid == false then
			return false, "Expected V_*MAP: got invalid color"
		end
		return true
	end,

    any = function(a) return true end,

    -- Compatibility aliases: keep exposed names similar to older code.
    INT = function(a) return op.INT32(a) end,
    UNIT = function(a) return op.UINT32(a) end
}

-- Two tables used to remember keys that were explicitly created in
-- LC.serverdata and LC.localdata. These tables allow the first-time
-- creation of a key, and then mark it as allowed for future writes.
local sd_exceptions = {}
local ld_exceptions = {}

-- A list of variable names (string identifiers) that must not be readable
-- via the proxy. Each __index call compares the runtime value returned by
-- LC.functions.GetVarByString to the requested table entry and throws an
-- error if they match. The exact semantics depend on GetVarByString.
local ban_read = {
    "localdata.savedpass",
	"SetMetaTable"
}

-- `as_write` is a list of per-table write rules. Each entry specifies a
-- concrete table reference and a map of allowed keys -> validator functions.
-- When a write is attempted on one of these tables, the key is validated
-- using the provided validator and only then assigned.
local as_write = {
    {
        table = LC.localdata.motd,
        keys = {
            ["open"] = op.boolean,
            ["closing"] = op.boolean,
            ["scroll"] = op.UINT32,
            ["nscroll"] = op.UINT32
        }
    },
    {
        table = LC.menu.player_state,
        keys = {
            ["nav"] = op.UINT32,
            ["lastnav"] = op.UINT32,
            ["category"] = op.string,
            ["subcategory"] = op.any
        }
    }
}

-- Allowed writable fields for specific user-constructed entity types.
local as_userdata = {
    ["LC_groups"] = {
        ["displayname"] = op.string,
        ["color"] = op.V_MAP,
        ["priority"] = op.INT16,
        ["admin"] = op.boolean
    },
    ["LC_emotes"] = {
        ["name"] = op.string,
        ["state"] = op.state,
        ["scale"] = op.UINT32,
        ["colored"] = op.boolean,
        ["colorized"] = op.boolean
    },
    ["LC_skincolors"] = {
        ["name"] = op.string,
        ["ramp"] = op.table,
        ["invcolor"] = op.skincolor,
        ["invshade"] = function(a) return is_number_in_range(a, 0, 15, "UINT8") end,
        ["chatcolor"] = op.V_MAP
    },
    ["LC_banlist"] = {
		["id"] = op.string,
        ["name"] = op.string,
        ["username"] = op.string,
        ["timestamp_unban"] = op.UINT32,
        ["reason"] = op.string,
        ["moderator"] = op.string
    },
    ["LC_csay"] = {
		["header"] = op.string,
        ["msg"] = op.string,
        ["text_over"] = op.boolean,
        ["time"] = op.UINT32,
        ["x"] = op.UINT32,
        ["text_x"] = op.UINT32,
		["sound_played"] = op.boolean,
		["message_type"] = op.boolean
    }
}

-- Iterator factories for specific proxied lists.
local iterates = {
    ["LC_groups"] = function()
        local i = 0
        return function()
            i = i + 1
            local name = LC.serverdata.groups.num[i]
            local group = groups[name]
            return group
        end
    end,
    ["LC_emotes"] = function()
        local i = 0
        return function()
            i = i + 1
			local emote
			if LC.serverdata.emotes[i] then emote = emotes[i] end
            return emote
        end
    end,
	["LC_skincolors"] = function()
		local i = 0
		return function()
			i = i + 1
			local skincolor
			if LC.localdata.skincolors.slots[i] then skincolor = LC_skincolors[i] end
			return skincolor
		end
	end,
	["LC_controls"] = function()
		local i = 0
		return function()
			i = i + 1
			local control
			if LC.localdata.controls[i] then control = LC_controls[i] end
			return control
		end
	end,
	["LC_banlist"] = function()
		local i = 0
		return function()
			i = i + 1
			local baninfo
			if LC.serverdata.banlist[i] then baninfo = LC_banlist[i] end
			return baninfo
		end
	end,
	["LC_banwords"] = function()
		local i = 0
		return function()
			i = i + 1
			local banword
			if LC.serverdata.banwords[i] then banword = LC_banwords[i] end
			return banword
		end
	end,
	["LC_swearwords"] = function()
		local i = 0
		return function()
			i = i + 1
			local swearword
			if LC.localdata.swearwords[i] then swearword = LC_swearwords[i] end
			return swearword
		end
	end,
	["LC_csay"] = function()
		local i = 0
		return function()
			i = i + 1
			local csay
			if LC.localdata.csay[i] then csay = LC_csay[i] end
			return csay
		end
	end
}

--[[
  handle_userdata
  Validates and writes fields for a single entity object (group/emote/etc).
  Handles both regular keys and array-like subfields (perms, sfx, ramp).
  This ensures that nested structures inside a user object
  also get validated before being assigned.

  Parameters:
    - t: the target table (group / emote)
    - userdata_type: "LC_groups" or "LC_emotes" (selects as_userdata map)
    - key, value: the incoming key/value being written
    - array_key: name of the key that represents a sub-array ("perms" or "sfx")
    - op_func: validator to use for elements of the array_key

  Behavior:
    - If key != array_key: look up the validator in as_userdata and apply it.
      If validation passes, assign `t[key] = value` and return true.
    - If key == array_key: accept either a single value or a table of values.
      Normalize to a table and validate each element using op_func. Assign
      the normalized table to t[array_key] and return true.
    - Return false if the function did not handle the key.
]]
local function handle_userdata(t, userdata_type, key, value, array_key, op_func)
    if key ~= array_key then
        local asw = as_userdata[userdata_type][key]
		if userdata_type == "LC_groups" and key == "color" then value = LC.functions.GetColormap(value, "hex") end
        if asw then
            local access, err = asw(value)
            if access == true then
                t[key] = value
                return true
            elseif access == false then
                error(err)
            end
        end
	elseif array_key == "ramp"
        -- Special handling for "ramp": expect a table with exactly 16 entries validated by op_func.
        if type(value) ~= "table" then
            -- Ramp must be provided as a table of 16 numeric entries.
            error("Expected table, got type " .. type(value))
        end
		local new_value = {}
		for i = 1, 16 do
			if value[i] == nil then
				error("Field 'ramp' must be 16 entries long; got "..(i-1)..".")
			end
			local access, err = op_func(value[i])
            if access == false then
                error(err)
            end
			new_value[i] = value[i]
		end
		t[key] = new_value
		return true
    else
        -- Normalize single value -> table and validate each element.
        if type(value) ~= "number" and type(value) ~= "table" and type(value) ~= "string" then
            -- For groups.perms the value may be string, for emote.sfx it is number.
            error("Expected " .. (userdata_type == "LC_groups" and "string" or "number") .. " or table, got type " .. type(value))
        end
		-- Removes keys and unnecessary indexes
		-- Example: A table with indexes 1, 2, 3, 6 and key ‘key1’, 6 and key1 will not be added.
        local new_value = type(value) == "table" and value or { value }
		local new_table = {}
        for i = 1, #new_value do
            local access, err = op_func(new_value[i])
            if access == false then
                error(err)
            end
			new_table[i] = new_value[i]
        end
        t[key] = new_table
        return true
    end
    return false
end

--[[
  handle_array_modification
  Handles modifications to an array field (e.g., perms, sfx, ramp)
  where the table `t` itself is the array. Supports insertion, deletion, and
  duplicate prevention.

  Parameters:
    - t: target array table
    - key: numeric index where the modification is intended
    - value: new value or nil (nil means deletion)
    - array: reference to the parent array for duplicate checks and insert
    - op_func: validator to check new inserted values

  Behavior:
    - If key is not a number, throw an error.
    - If value == nil: remove the element at index `key`.
    - Else validate `value` with op_func. If the value already exists in the
      array, do nothing (avoid duplicates). Otherwise insert value at `key`
      position or append if `key` is out of range.
]]
local function handle_array_modification(t, key, value, array, op_func)
    if type(key) ~= "number" then
        error("Expected index, got key")
    else
        local access, err = op_func(value)
        if not access and value ~= nil then error(err) end

        if value == nil then
            table.remove(t, key)
        else
            for i = 1, #array do
                if array[i] == value then return end
            end
            if key > #array or key < 1 then
                table.insert(array, value)
            else
                table.insert(array, key, value)
            end
        end
        return true
    end
end

-- Table of functions to add new entries to certain proxied lists.
-- Each function handles default values, validation,
-- naming conflicts, and insertion into the original LC storage.
local addToMetaTable = {
	["LC_groups"] = function(t) -- Create a new group object with default fields, validate incoming keys, and insert it into groups list
		local new_group = {
			["displayname"] = "group"..#groups,
			["color"] = "white",
			["priority"] = 0,
			["admin"] = true,
			["perms"] = {}
		}
		for k, v in pairs(t) do
			handle_userdata(new_group, "LC_groups", k, v, "perms", op.string)
		end
		//new_group = LC.functions.mergeTables(new_group, t)
		local name = new_group.displayname
		local i = 1
		while LC.serverdata.groups.list[name] != nil do
			name = name..i
			i = $ + 1
		end
		LC.serverdata.groups.list[name] = new_group
		table.insert(LC.serverdata.groups.num, new_group.displayname)
		return #groups[name]
	end,
	["LC_skincolors"] = function(t)  -- Create a new custom skincolor entry, validate its fields, and add it to local skincolors slots
		local new_color = {
			["name"] = "LC_skincolor"..#LC_skincolors,
			["ramp"] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16},
			["invcolor"] = SKINCOLOR_WHITE,
			["invshade"] = 1,
			["chatcolor"] = 0
		}
		for k, v in pairs(t) do
			handle_userdata(new_color, "LC_skincolors", k, v, "ramp", op.UINT8)
		end
		table.insert(LC.localdata.skincolors.slots, new_color)
		return #LC_skincolors
	end,
	["LC_banlist"] = function(t)  -- Add a new banlist entry with required ID/username, validate and append to server banlist
		local new_bl = {
			["id"] = nil,
			["name"] = nil,
			["username"] = nil,
			["unban"] = nil,
			["reason"] = "(reason is not given)",
			["moderator"] = ""
		}
		if not t.id and not t.username then
			error("The \'id\' or \'username\' key must be present.")
		end
		for k, v in pairs(t)
			handle_userdata(new_bl, "LC_banlist", k, v)
		end
		table.insert(LC.serverdata.banlist, new_bl)
		return #LC_banlist
	end,
	["LC_banwords"] = function(str)  -- Insert a new banned word into the server's banwords list if it doesn't already exist
		local access, err = op.string(str)
		if access == false then error(err) end
		for _, v in ipairs(LC.serverdata.banwords) do
			if v:lower() == str:lower() then
				return _
			end
		end
		table.insert(LC.serverdata.banwords, str:lower())
		return #LC.serverdata.banwords
	end,
	["LC_swearwords"] = function(str)  -- Insert a new swear word into the local swearwords list if it doesn't already exist
		local access, err = op.string(str)
		if access == false then error(err) end
		for _, v in ipairs(LC.localdata.swearwords) do
			if v:lower() == str:lower() then
				return _
			end
		end
		table.insert(LC.localdata.swearwords, str:lower())
		return #LC.localdata.swearwords
	end,
	["LC_csay"] = function(t)  -- Add a new csay message with validated fields to localdata.csay
		local new_csay = {
			["header"] = "",
			["msg"] = "",
			["text_over"] = false,
			["time"] = 5*TICRATE,
			["x"] = false,
			["text_x"] = 0,
			["sound_played"] = false,
			["message_type"] = false
		}
		for k, v in pairs(t)
			handle_userdata(new_csay, "LC_csay", k, v)
		end
		table.insert(LC.localdata.csay, new_csay)
		return #LC_csay
	end
}

-- Table of functions to remove entries from proxied lists.
-- Removal checks existence, special-case protections,
-- and updates related LC structures.
local removeFromMetaTable = {
	["LC_groups"] = function(group)
		if not groups[group] then error("This group does not exist.") end
		
		local name, index
		if type(group) == "number" then
			index = #groups[group]
			name = LC.serverdata.groups.num[index]
		elseif type(group) == "string" then
			index = #groups[group]
			name = group
		end
		
		for _, v in ipairs(LC.serverdata.groups.sets) do
			if v == name then
				error("This group cannot be deleted, as it is a special group.")
			end
		end
		
		LC.serverdata.groups.list[name] = nil
		table.remove(LC.serverdata.groups.num, index)
	end,
	["LC_skincolors"] = function(sc)
		if not LC_skincolors[sc] then error("This skincolor does not exist.") end
		
		if LC.localdata.skincolors.default == sc then LC.localdata.skincolors.default = 1 end
		table.remove(LC.localdata.skincolors.slots, sc)
	end,
	["LC_banlist"] = function(b)
		if not LC_banlist[b] then error("This player is not on the ban list.") end
		
		table.remove(LC.serverdata.banlist, b)
	end,
	["LC_banwords"] = function(b)
		local index = b
		if type(b) == "string" then
			for _, v in ipairs(LC.serverdata.banwords) do
				if b:lower() == v:lower() then
					index = _
				end
			end
		end
		if LC.serverdata.banwords[index] then
			table.remove(LC.serverdata.banwords, index)
		end
	end,
	["LC_swearwords"] = function(b)
		local index = b
		if type(b) == "string" then
			for _, v in ipairs(LC.localdata.swearwords) do
				if b:lower() == v:lower() then
					index = _
				end
			end
		end
		if LC.localdata.swearwords[index] then
			table.remove(LC.localdata.swearwords, index)
		end
	end,
	["LC_csay"] = function(index)
		if LC.localdata.csay[index] then
			table.remove(LC.localdata.csay, index)
		end
	end
}

-- Table of functions to save changes to certain data lists back to storage.
local saveMetaData = {
	["LC_groups"] = function()
		LC.functions.SaveGroups("save")
	end,
	["LC_skincolors"] = function()
		LC.functions.Skincolor(consoleplayer, "save")
	end,
	["LC_controls"] = function()
		LC.functions.SaveControls("save")
	end,
	["LC_banlist"] = function()
		LC.functions.SaveBanlist()
	end,
	["LC_banwords"] = function(player)
		if not consoleplayer or player ~= consoleplayer then return end
		local str_list = ""
		for i = 1, #tbw do
			if i != #tbw
				str_list = str_list..tbw[i].."\n"
			elseif i == #tbw
				str_list = str_list..tbw[i]
			end
		end
		local bwcfg_file = io.openlocal(LC.serverdata.folder.."/banwords.cfg", "w")
		bwcfg_file:write(str_list)
		bwcfg_file:close()
	end,
	["LC_swearwords"] = function(player)
		if not consoleplayer or player ~= consoleplayer then return end
		local str_list = ""
		for i = 1, #tbw do
			if i != #tbw
				str_list = str_list..tbw[i].."\n"
			elseif i == #tbw
				str_list = str_list..tbw[i]
			end
		end
		local bwcfg_file = io.openlocal(LC.serverdata.clientfolder.."/swearwords.cfg", "w")
		bwcfg_file:write(str_list)
		bwcfg_file:close()
	end
}

--[[
  LC.SetMetaTable
  Wraps a table with a proxy enforcing:
    - Controlled read access (ban_read, bounds checking, iterators)
    - Controlled writes (per-table key validation, entity field validation)
    - Safe recursive wrapping of nested tables
    - Custom __len behavior for proxied lists
    - Prevents external metatable modification
]]
LC.SetMetaTable = function(t)
    if type(t) ~= "table" then return t end

    local proxy = {}
    local mt = {
        __index = function(_, k)
            -- First, block reads of banned keys by comparing actual stored values.
            -- If LC.functions.GetVarByString returns the same as t[k], throw an error.
            for i in ipairs(ban_read) do
                if LC.functions.GetVarByString(LC, ban_read[i]) == t[k] then error("Access denied!", 1) end
            end

            -- Special-case handling for various LC tables follows — each case may return
            -- custom iterators, helper functions (__add, __remove, __save), or validate numeric indexes.
            if t == LC.serverdata.groups.list then
                if k == "iterate" then
                    return iterates["LC_groups"]
				elseif k == "__add" then
					return addToMetaTable["LC_groups"]
				elseif k == "__remove" then
					return removeFromMetaTable["LC_groups"]
				elseif k == "__save" then
					return saveMetaData["LC_groups"]
                elseif type(k) == "number" then
                    local max = #LC.serverdata.groups.num
                    if k >= 1 and k <= max then
                        local name = LC.serverdata.groups.num[k]
                        local group = groups[name]
                        return group
                    else
                        error("groups[] index " .. k .. " out of range (1 - " .. max .. ")")
                    end
                end
            end

            -- Special handling for emotes array proxy: provide iterator and
            -- numeric bounds checking.
            if t == LC.serverdata.emotes then
                if k == "iterate" then
                    return iterates["LC_emotes"]
                elseif type(k) == "number" then
                    local max = #LC.serverdata.emotes
                    if k < 1 or k > max then
                        error("emotes[] index " .. k .. " out of range (1 - " .. max .. ")")
                    end
                end
            end
			
			-- Local skincolors
			if t == LC.localdata.skincolors.slots then
                if k == "iterate" then
                    return iterates["LC_skincolors"]
				elseif k == "__add" then
					return addToMetaTable["LC_skincolors"]
				elseif k == "__remove" then
					return removeFromMetaTable["LC_skincolors"]
				elseif k == "__save" then
					return saveMetaData["LC_skincolors"]
                elseif type(k) == "number" then
                    local max = #LC.localdata.skincolors.slots
                    if k < 1 or k > max then
                        error("LC_skincolors[] index " .. k .. " out of range (1 - " .. max .. ")")
                    end
                end
            end
			
			-- controls
			if t == LC.localdata.controls then
                if k == "iterate" then
                    return iterates["LC_controls"]
				elseif k == "__save" then
					return saveMetaData["LC_controls"]
                elseif type(k) == "number" then
                    local max = #LC.localdata.controls
                    if k < 1 or k > max then
                        error("LC_controls[] index " .. k .. " out of range (1 - " .. max .. ")")
                    end
                end
            end
			
			-- ban list
			if t == LC.serverdata.banlist then
                if k == "iterate" then
                    return iterates["LC_banlist"]
				elseif k == "__add" then
					return addToMetaTable["LC_banlist"]
				elseif k == "__remove" then
					return removeFromMetaTable["LC_banlist"]
				elseif k == "__save" then
					return saveMetaData["LC_banlist"]
                elseif type(k) == "number" then
                    local max = #LC.serverdata.banlist
                    if k < 1 or k > max then
                        error("LC_banlist[] index " .. k .. " out of range (1 - " .. max .. ")")
                    end
                end
            end
			
			-- ban words
			if t == LC.serverdata.banwords then
                if k == "iterate" then
                    return iterates["LC_banwords"]
				elseif k == "__add" then
					return addToMetaTable["LC_banwords"]
				elseif k == "__remove" then
					return removeFromMetaTable["LC_banwords"]
				elseif k == "__save" then
					return saveMetaData["LC_banwords"]
                elseif type(k) == "number" then
                    local max = #LC.serverdata.banwords
                    if k < 1 or k > max then
                        error("LC_banwords[] index " .. k .. " out of range (1 - " .. max .. ")")
                    end
                end
            end

			-- swear words
			if t == LC.serverdata.swearwords then
                if k == "iterate" then
                    return iterates["LC_swearwords"]
				elseif k == "__add" then
					return addToMetaTable["LC_swearwords"]
				elseif k == "__remove" then
					return removeFromMetaTable["LC_swearwords"]
				elseif k == "__save" then
					return saveMetaData["LC_swearwords"]
                elseif type(k) == "number" then
                    local max = #LC.serverdata.swearwords
                    if k < 1 or k > max then
                        error("LC_swearwords[] index " .. k .. " out of range (1 - " .. max .. ")")
                    end
                end
            end
			
			-- Csay messages
			if t == LC.localdata.csay then
                if k == "iterate" then
                    return iterates["LC_csay"]
				elseif k == "__add" then
					return addToMetaTable["LC_csay"]
				elseif k == "__remove" then
					return removeFromMetaTable["LC_csay"]
                elseif type(k) == "number" then
                    local max = #LC.localdata.csay
                    if k < 1 or k > max then
                        error("LC_csay[] index " .. k .. " out of range (1 - " .. max .. ")")
                    end
                end
            end

            -- Fallback: recursively wrap nested tables so deeper structures inherit protections.
            return LC.SetMetaTable(t[k])
        end,

        __newindex = function(_, key, value)
            -- Write handler applies multiple layers of rules:
            --   1. Allow dynamic creation in LC.serverdata / LC.localdata once per key
            --   2. Apply specific as_write rules
            --   3. Special-case logic for groups, emotes, skincolors, banlist, csay, etc.
            --   4. Reject modification if no rules matched (read-only)
            if LC.serverdata == t then
                if LC.serverdata[key] == nil or sd_exceptions[key] == true then
                    LC.serverdata[key] = value
                    sd_exceptions[key] = true
                    return
                end
            end

            -- Same creation rule applies to LC.localdata using ld_exceptions.
            if LC.localdata == t then
                if LC.localdata[key] == nil or ld_exceptions[key] == true then
                    LC.localdata[key] = value
                    ld_exceptions[key] = true
                    return
                end
            end

            -- Check `as_write` table rules: if the target table matches a
            -- configured `as_write` entry and the key is explicitly allowed,
            -- validate and assign.
            for i = 1, #as_write do
                local asw = as_write[i]
                if asw.table == t then
                    if asw.keys[key] then
                        local access, err = asw.keys[key](value)
                        if access == true then
                            t[key] = value
                            return
                        elseif access == false then
                            error(err)
                        end
                    end
                end
            end

            -- Groups handling: loop all groups and detect if `t` is either the
            -- group object itself or the group's perms array. Use helper
            -- functions to manage the write and validate values.
			-- Handle case when writing directly to LC.serverdata.groups.list (global "LC_groups" proxy)
			if t == LC.serverdata.groups.list then
				-- Check if the group with given key exists in the global proxy
				if groups[key] then
					local access, err = op.table(value)
					if access == false then error(err) end
					if type(key) == "number" then key = LC.serverdata.groups.num[key] end
					
					-- Temporary table to hold validated fields before merging
					local new_table = {}
					
					-- Validate and normalize each field of the assigned table
					-- "LC_groups" defines which keys are allowed, "perms" is treated as an array of strings
					for k, v in pairs(value) do
						handle_userdata(new_table, "LC_groups", k, v, "perms", op.string)
					end
					
					-- Merge validated new fields into the existing group table
					LC.serverdata.groups.list[key] = LC.functions.mergeTables(LC.serverdata.groups.list[key], new_table)
				else
					-- If no such group exists, throw index out-of-range error
					error("groups[] index out of range (1 - " .. #groups .. ")")
				end
				return
			end
            local groups_count = #LC.serverdata.groups.num
            for i = 1, groups_count do
                local name = LC.serverdata.groups.num[i]
                local group = LC.serverdata.groups.list[name]
                if t == group then
                    if handle_userdata(t, "LC_groups", key, value, "perms", op.string) then return end
                elseif t == group.perms then
                    if handle_array_modification(t, key, value, group.perms, op.string) then return end
                end
            end

            -- Emotes handling: analogous to groups; look for emote object or
            -- its sfx array.
			if t == LC.serverdata.emotes then
				if emotes[key] then
					local access, err = op.table(value)
					if access == false then error(err) end
					
					local new_table = {}
					
					for k, v in pairs(value) do
						handle_userdata(new_table, "LC_emotes", k, v, "sfx", op.sfx)
					end
					
					LC.serverdata.emotes[key] = LC.functions.mergeTables(LC.serverdata.emotes[key], new_table)
				else
					error("emotes[] index out of range (1 - " .. #emotes .. ")")
				end
				return
			end
            local emotes_count = #LC.serverdata.emotes
            for i = 1, emotes_count do
                local emote = LC.serverdata.emotes[i]
                if t == emote then
                    if handle_userdata(t, "LC_emotes", key, value, "sfx", op.sfx) then return end
                elseif t == emote.sfx then
                    if handle_array_modification(t, key, value, emote.sfx, op.sfx) then return end
                end
            end
			
			
			-- Local skincolors: handle writes to individual skincolor entries or their ramps.
			if t == LC.localdata.skincolors.slots then
				if LC_skincolors[key] then
					local access, err = op.table(value)
					if access == false then error(err) end
					
					local new_table = {}
					
					for k, v in pairs(value) do
						handle_userdata(new_table, "LC_skincolors", k, v, "ramp", op.UINT8)
					end
					
					LC.localdata.skincolors.slots[key] = LC.functions.mergeTables(LC.localdata.skincolors.slots[key], new_table)
				else
					error("LC_skincolors[] index out of range (1 - " .. #LC_skincolors .. ")")
				end
				return
			end
			local lcs_count = #LC.localdata.skincolors.slots
            for i = 1, lcs_count do
                local lcs = LC.localdata.skincolors.slots[i]
                if t == lcs then
                    if handle_userdata(t, "LC_skincolors", key, value, "ramp", op.UINT8) then return end
                elseif t == lcs.ramp then
                    if handle_array_modification(t, key, value, lcs.ramp, op.UINT8) then return end
                end
            end
			
			-- Banlist handling: allow controlled writes to banlist entries and their fields.
			if t == LC.serverdata.banlist then
				if LC_banlist[key] then
					local access, err = op.table(value)
					if access == false then error(err) end
					
					local new_table = {}
					
					for k, v in pairs(value) do
						handle_userdata(new_table, "LC_banlist", k, v)
					end
					
					LC.serverdata.banlist[key] = LC.functions.mergeTables(LC.serverdata.banlist[key], new_table)
				else
					error("LC_banlist[] index out of range (1 - " .. #LC_banlist .. ")")
				end
				return
			end
			local ban_count = #LC.serverdata.banlist
            for i = 1, ban_count do
                local ban = LC.serverdata.banlist[i]
                if t == ban then
                    if handle_userdata(t, "LC_banlist", key, value) then return end
                    break
				end
            end
			
			-- 
			if t == LC.localdata.csay then
				if LC_csay[key] then
					local access, err = op.table(value)
					if access == false then error(err) end
					
					local new_table = {}
					
					for k, v in pairs(value) do
						handle_userdata(new_table, "LC_csay", k, v)
					end
					
					LC.localdata.csay[key] = LC.functions.mergeTables(LC.localdata.csay[key], new_table)
				else
					error("LC_csay[] index out of range (1 - " .. #LC_csay .. ")")
				end
				return
			end
			local csay_count = #LC.localdata.csay
            for i = 1, csay_count do
                local csay = LC.localdata.csay[i]
                if t == csay then
                    if handle_userdata(t, "LC_csay", key, value) then return end
                    break
				end
            end

            -- If none of the rules allowed the write, treat this table as
            -- read-only and reject attempts to modify it.
            error("Attempt to modify read-only table.", 1)
        end,

        -- Custom __len handler returns the correct length for proxied global lists
        -- or entity sub-arrays by comparing metatables.
        __len = function(tbl)
            if tbl == groups then
                return #LC.serverdata.groups.num
            elseif tbl == emotes then
                return #LC.serverdata.emotes
			elseif tbl == LC_skincolors then
				return #LC.localdata.skincolors.slots
			elseif tbl == LC_controls then
				return #LC.localdata.controls
			elseif tbl == LC_banlist then
				return #LC.serverdata.banlist
			elseif tbl == LC_banwords then
				return #LC.serverdata.banwords
			elseif tbl == LC_swearwords then
				return #LC.localdata.swearwords
			elseif tbl == LC_csay then
				return #LC.localdata.csay
            end
			
			for i = 1, #groups do
				if tostring(getmetatable(tbl)) == tostring(getmetatable(groups[i])) then
					return i
				end
			end
			
            local groups_count = #LC.serverdata.groups.num
            for i = 1, groups_count do
                local name = LC.serverdata.groups.num[i]
                local group = LC.serverdata.groups.list[name]
                if tostring(getmetatable(tbl)) == tostring(group.perms) then
                    return #group.perms
                end
            end
            return 0
        end,

        -- Lock metatable access to prevent tampering.
        __metatable = tostring(t)
    }

    setmetatable(proxy, mt)
    return proxy
end

-- Create a proxied view of LC and expose convenience globals.
local metatable = LC.SetMetaTable(LC)

-- These globals provide easy access to key LC tables
-- with enforced validation and controlled read/write behavior.
rawset(_G, "LC_groups", LC.SetMetaTable(LC.serverdata.groups.list))
rawset(_G, "LC_emotes", LC.SetMetaTable(LC.serverdata.emotes))
rawset(_G, "LC_skincolors", LC.SetMetaTable(LC.localdata.skincolors.slots))
rawset(_G, "LC_controls", LC.SetMetaTable(LC.localdata.controls))
rawset(_G, "LC_banlist", LC.SetMetaTable(LC.serverdata.banlist))
rawset(_G, "LC_csay", LC.SetMetaTable(LC.localdata.csay))
rawset(_G, "LC_banwords", LC.SetMetaTable(LC.serverdata.banwords))
rawset(_G, "LC_swearwords", LC.SetMetaTable(LC.localdata.swearwords))

return metatable

-- End Of File
