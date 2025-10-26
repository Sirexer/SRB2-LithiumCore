-- Timestamp converter for SRB2 Lua
-- Supports formats: t, T, d, D, f, F, R
-- Example: <t:1755694440:F> → "Wednesday, 20 August 2025 at 15:54"
local LC = LithiumCore

LC.functions.convertTimestamp = function(tag, nowOverride)
	if not tag then return end
	
    -- Extract timestamp and optional format
    local ts, fmt = tag:match("<t:(%d+):?(%a?)>")
    if not ts then return nil end
    ts = tonumber(ts)
    fmt = fmt ~= "" and fmt or "f" -- default = short date/time

    local t = os.date("*t", ts)

    -- Day names (Lua os.date wday: 1 = Sunday, ... 7 = Saturday)
    local weekdays = {
        [1] = "Sunday",
        [2] = "Monday",
        [3] = "Tuesday",
        [4] = "Wednesday",
        [5] = "Thursday",
        [6] = "Friday",
        [7] = "Saturday"
    }

    -- Month names
    local months = {
        "January","February","March","April","May","June",
        "July","August","September","October","November","December"
    }

    -- Helper for relative time ("5 minutes ago", "in 2 hours", etc.)
    local function relativeTime(ts, now)
        //local now = os.time()
        local diff = ts - now
        local absdiff = abs(diff)

        local function plural(n, word)
            if n == 1 then return word end
            return word .. "s"
        end

         if absdiff < 60 then
            return (diff > 0) and ("in "..absdiff.." "..plural(absdiff,"second"))
                             or (absdiff == 0 and "just now" or (absdiff.." "..plural(absdiff,"second").." ago"))
        elseif absdiff < 3600 then
            local m = absdiff/60
            return (diff > 0) and ("in "..m.." "..plural(m,"minute"))
                             or (m.." "..plural(m,"minute").." ago")
        elseif absdiff < 86400 then
            local h = absdiff/3600
            return (diff > 0) and ("in "..h.." "..plural(h,"hour"))
                             or (h.." "..plural(h,"hour").." ago")
        elseif absdiff < 31536000 then -- less than 365 days
            local d = absdiff/86400
            return (diff > 0) and ("in "..d.." "..plural(d,"day"))
                             or (d.." "..plural(d,"day").." ago")
        else -- years
            local y = absdiff/31536000
            return (diff > 0) and ("in "..y.." "..plural(y,"year"))
                             or (y.." "..plural(y,"year").." ago")
        end
    end

    -- Apply Discord format
    if fmt == "t" then
        return string.format("%02d:%02d", t.hour, t.min) -- Short Time
    elseif fmt == "T" then
        return string.format("%02d:%02d:%02d", t.hour, t.min, t.sec) -- Long Time
    elseif fmt == "d" then
        return string.format("%02d/%02d/%d", t.day, t.month, t.year) -- Short Date
    elseif fmt == "D" then
        return string.format("%d %s %d", t.day, months[t.month], t.year) -- Long Date
    elseif fmt == "f" then
        return string.format("%d %s %d at %02d:%02d", t.day, months[t.month], t.year, t.hour, t.min) -- Short Date/Time
    elseif fmt == "F" then
        return string.format("%s, %d %s %d at %02d:%02d", weekdays[t.wday], t.day, months[t.month], t.year, t.hour, t.min) -- Long Date/Time
    elseif fmt == "R" then
        local now = nowOverride or os.time()
        return relativeTime(ts, now) -- Relative
    else
        return os.date("%c", ts) -- fallback
    end
end

return true -- End of File