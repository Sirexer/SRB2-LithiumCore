local LC = LithiumCore

function LC.functions.parseTime(str)
    local now = os.time()
	
	if not str then return end
	
	local int = tonumber(str)
	if int then return int end

    -- Format “DD.MM.YY HH:MM”
    local d, M, y, h, m = str:match("^(%d%d)%.(%d%d)%.(%d%d)%s*(%d?%d?):?(%d?%d?)$")
    if d and M and y then
        local year = tonumber(y)
        if year < 100 then
            year = 2000 + year -- YY → 20YY
        end
        return os.time({
            year  = year,
            month = tonumber(M),
            day   = tonumber(d),
            hour  = tonumber(h) or 0,
            min   = tonumber(m) or 0,
            sec   = 0,
        })
    end

   -- Interval format: number + unit
    local total_seconds = 0
    for num, unit in str:gmatch("(%d+)([a-z]+)") do
        num = tonumber(num)
        if unit == "h" then
            total_seconds = total_seconds + num * 3600
        elseif unit == "d" then
            total_seconds = total_seconds + num * 86400
        elseif unit == "min" then
            total_seconds = total_seconds + num * 60
        elseif unit == "m" then
            total_seconds = total_seconds + num * 2592000 -- month = 30 days
        elseif unit == "y" then
            total_seconds = total_seconds + num * 31536000 -- year = 365 days
        else
            return nil -- unknown unit
        end
    end

    if total_seconds > 0 then
        return now + total_seconds
    end

    return nil -- incorrect format
end

--[[
	local parseTime = LC.functions.parseTime
	print( os.date("%c",parseTime("24.09.25" )) )			-- 24.09.2025 00:00
	print( os.date("%c",parseTime("24.09.25 14:30" )) )		-- 24.09.2025 14:30
	print( os.date("%c",parseTime("15min" )) )				-- now + 15 minutes
	print( os.date("%c",parseTime("1d 2h 30min" )) )		-- now + 1 day 2 hours 30 minutes
	print( os.date("%c",parseTime("1y 6m 10d" )) )			-- now + 1 year 6 months 10 days
]]

return true -- End of File
