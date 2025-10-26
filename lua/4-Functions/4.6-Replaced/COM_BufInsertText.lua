-- LithiumCore-friendly buffered COM_BufInsertText
-- Splits multiple commands in a buffer, queues network commands and executes them safely across ticks.
local LC = LithiumCore

-- Save original COM_BufInsertText to avoid recursion when calling the real implementation.
-- rawget(_G, "COM_BufInsertText") ensures we fetch the global function as it existed
-- before we replace it in this file.
local original_COM_BufInsertText = rawget(_G, "COM_BufInsertText")
LC.replaced_functions.COM_BufInsertText = original_COM_BufInsertText

-- Internal command queue for network-capable commands
local cmd_buffer = {}

-- Tick tracking and buffer length accounting
-- last_tick: last tick value used to detect tick changes
-- cmd_length: accumulated length of commands executed in the current tick
local last_tick = 0
local cmd_length = 0

-- Maximum number of characters to process per tick (to avoid very long single-frame buffers)
local CMD_MAX_BUFFER_SIZE = 220
local key = LC.functions.GetRandomPassword("L", 4)

local cmd_tick_enabled = false

-- Helper: split input buffer into individual command lines, respecting quoted strings.
-- Example: 'cmd1 arg1; cmd2 "quoted ; arg"; cmd3' -> { "cmd1 arg1", "cmd2 \"quoted ; arg\"", "cmd3" }
-- Important: semicolons inside double quotes are ignored as separators.
local function split_commands(buffer)
	local cmds = {}
	local current = ""
	local in_quotes = false

	for i = 1, #buffer do
		local c = buffer:sub(i, i)
		if c == '"' then
			in_quotes = not in_quotes
		elseif c == ";" and not in_quotes then
			if #current > 0 then
				table.insert(cmds, current:match("^%s*(.-)%s*$"))
				current = ""
			end
		else
			current = current .. c
		end
	end
	if #current > 0 then
		table.insert(cmds, current:match("^%s*(.-)%s*$"))
	end
	return cmds
end

-- Helper: parse a single command line into name and args.
-- Returns table { cmd = <name>, args = <rest> } (args may be empty string).
-- This parser does not split args into tokens — it preserves quoted arguments as part of args.
local function parse_command(cmd_line)
	local cmd, args = cmd_line:match("^(%S+)%s*(.*)$")
	return {
		cmd = cmd or "",
		args = args or ""
	}
end

-- Override COM_BufInsertText to buffer network commands and allow immediate execution of local commands.
-- This function:
--  - respects the LC_optimisebuffercmd console var (if "Off", calls original)
--  - avoids buffering on dedicated servers
--  - splits incoming buffer into commands and either executes local commands immediately,
--    or queues network-capable commands for ticked execution
COM_BufInsertText = function(player, buffer)
	-- If optimisation disabled or console is dedicated server -> fall back to original behavior.
	if LC.client_consvars["LC_optimisebuffercmd"].value == 0 or isdedicatedserver or not multiplayer or not player then
		return original_COM_BufInsertText(player, buffer)
	end
	
	-- Validate buffer type
	if type(buffer) ~= "string" or buffer == "" then return end
	
	local cmds = {}
	
	-- Split input into individual commands
	local lines = split_commands(buffer)
	for _, line in ipairs(lines) do
		local parsed = parse_command(line)
		if parsed.cmd ~= "" then
			table.insert(cmds,
				{
					cmd = parsed.cmd,
					args = parsed.args
				}
			)
		end
	end
	
	local current_tick = player.jointime or 0
	if current_tick ~= last_tick then
		cmd_length = 0
		last_tick = current_tick
	end
	
	local execute = true
	for _, v in ipairs(cmds) do
		local cmd = v.cmd
		local args = v.args
		local parsed = (v.args and v.cmd.." "..v.args) or v.cmd
		
		-- Skip if this command is not transmitted over the network; it will never cause NetXCMD error
		-- LC.CMD table holds command flags — COM_LOCAL flag means command is local-only.
		if LC.CMD[cmd] == nil or (LC.CMD[cmd] & COM_LOCAL) then
			original_COM_BufInsertText(player, parsed)
			continue
		end
		
		-- If the command is longer than CMD_MAX_BUFFER_SIZE, skip it and issue a warning.
		-- This protects against single commands that are absurdly long and would never be safe
		-- to send in one frame.
		if #parsed > CMD_MAX_BUFFER_SIZE then
			CONS_Printf(player,
				"\x82".."WARNING\x80"..": Command length too long, can't be executed")
			continue
		end
		
		--[[
		print("Buffer length: "..cmd_length)
		print("CMD: "..parsed)
		print("Length: "..#parsed)
		]]
		-- Buffer network commands for processing on ticks to avoid NetXCMD errors.
		-- If the accumulated command length would exceed the per-tick cap, defer to queue.
		if cmd_length > 0 and cmd_length + #parsed >= CMD_MAX_BUFFER_SIZE or execute == false then
			execute = false
			table.insert(cmd_buffer, parsed)
			--print("Sending to buffer...")
			continue
		end
		--[[
		print("Executing...")
		]]
		
		-- Append the command text into the command buffer for execution.
		-- Here we use COM_BufAddText to append the text to the console buffer so the engine
		-- will process it in the normal command dispatch flow. This preserves expected engine behavior.
		cmd_length = $ + #parsed
		COM_BufAddText(player, parsed)
	end
	
	-- Start the command handler if it was stopped
	if not cmd_tick_enabled and cmd_buffer[1] then
		key = LC.functions.GetRandomPassword("L", 4)
		COM_BufAddText(player, "CMD_THINKER "..key)
		cmd_tick_enabled = true
	end
end

-- CMD_RUN is a small hack: a command that runs every tick (even during pause) to process the buffered commands.
COM_AddCommand("CMD_RUN", function(player, arg)
	-- This command should run only on the local client.
	if player ~= consoleplayer then return end
	-- Exit if there is nothing to process.
	if not cmd_buffer[1] then return end
	-- Respect the optimization cvar.
	if LC.client_consvars["LC_optimisebuffercmd"].value == 0 then return end
	
	-- Reset accumulated command length only when a new game tick is detected.
	-- player.jointime is used here as a tick-like counter; if your environment provides
	-- a global 'leveltime' or similar, that can be used instead. The goal is to reset
	-- cmd_length once per engine tick so multiple CMD_RUN invocations inside the same
	-- tick don't reset the accounting prematurely.
	local current_tick = player.jointime or 0
	if current_tick ~= last_tick then
		cmd_length = 0
		last_tick = current_tick
	end

	while cmd_buffer[1] do
		local cmdstr = cmd_buffer[1]
		
		-- Check accumulated buffer length and avoid exceeding CMD_MAX_BUFFER_SIZE in a single tick.
		if cmd_length > 0 and cmd_length + #cmdstr >= CMD_MAX_BUFFER_SIZE then
			break
		end

		-- Append the command text into the command buffer for execution.
		-- COM_BufAddText adds text to the engine's command buffer; the engine will then
		-- invoke COM_BufInsertText (our override) with that text. Using COM_BufAddText
		-- means this function will not directly call COM_BufInsertText, but the engine
		-- will call it in the normal processing flow.
		cmd_length = $ + #cmdstr
		COM_BufAddText(player, cmdstr)

		-- Remove the processed command from the queue.
		table.remove(cmd_buffer, 1)
	end
end, COM_LOCAL)

-- Secondary thinker that ensures CMD_RUN keeps being scheduled across ticks.
-- This thinker runs locally on the client and re-schedules CMD_RUN if buffer is not empty.
COM_AddCommand("CMD_THINKER", function(player, arg)
	cmd_tick_enabled = false
	if player ~= consoleplayer then return end
	if not player or not player.valid then return end
	if arg ~= key then return true end
	if isdedicatedserver then return end
	if not cmd_buffer[1] then return end
	-- Escape freeze in Singleplayer and titlcard
	if not multiplayer or not netgame or LC.client_consvars["LC_optimisebuffercmd"].value == 0 then
		return
	end
	
	cmd_tick_enabled = true
	
	-- If there are pending buffered commands, schedule CMD_RUN to continue processing next tick.
	COM_BufAddText(player, "CMD_RUN")
	
	-- Re-schedule this thinker so it runs every tick as well.
	key = LC.functions.GetRandomPassword("L", 4)
	COM_BufAddText(player, "CMD_THINKER "..key)
	LC.localdata.cmd_buffer = cmd_length
end)

return true -- End Of File
