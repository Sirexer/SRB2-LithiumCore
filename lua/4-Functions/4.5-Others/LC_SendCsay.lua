local LC = LithiumCore

LC.functions.sendcsay = function(header, msg, message)
	local is_Message = false
	if message then is_Message = true end
	local t = {
		header = header,
		msg = msg,
		text_over = false,
		time = 5*TICRATE,
		x = false,
		text_x = 0,
		sound_played = false,
		message_type = is_Message
	}
	table.insert(LC.localdata.csay, t)
end

return true
