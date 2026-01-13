local LC = LithiumCore

LC.functions.addActionsTab = function(t)
	if not t or type(t) ~= "table" then
		print("\x82".."WARNING".."\x80"..": get "..type(t)..". It should be a \"table\" containing: name(string), conditions(function), args(table), func_comfirm(function), confirm(string), popup_msg(string)")
		return
	end
	
	local IsError = false
	
	if type(t.name) ~= "string" then 
		print("\x82".."WARNING".."\x80"..": arg \"name\" is "..type(t.name).." should be \"string\"")
		IsError = true
	end
	
	if type(t.conditions) ~= "function" then 
		print("\x82".."WARNING".."\x80"..": arg \"conditions\" is "..type(t.conditions).." should be \"function\"")
		IsError = true
	end
	
	
	if type(t.args) ~= "table" and t.args ~= nil then 
		print("\x82".."WARNING".."\x80"..": arg \"args\" is "..type(t.args).." should be \"table\"")
		IsError = true
	elseif type(t.args) == "table" then
		for _, v in ipairs(t.args) do
			if type(v.type) ~= "string" then
				print("\x82".."WARNING".."\x80"..":args[".._.."] arg \"type\" is "..type(v.type).." should be \"string\"")
				IsError = true
			elseif not LC.GIT_ArgTypes[v.type] and v.type ~= "text" and v.type ~= "count" and v.type ~= "float" then
				print("\x82".."WARNING".."\x80"..":args[".._.."]  Invalid argument type \"v.type\"")
				IsError = true
			end
			
			if type(v.header) ~= "string" then
				print("\x82".."WARNING".."\x80"..":args[".._.."]  arg \"header\" is "..type(v.header).." should be \"string\"")
				IsError = true
			end
			
			if v.min ~= nil and type(v.min) ~= "number" then
				print("\x82".."WARNING".."\x80"..":args[".._.."]  arg \"min\" is "..type(v.min).." should be \"number\"")
				IsError = true
			end
			
			if v.max ~= nil and type(v.max) ~= "number" then
				print("\x82".."WARNING".."\x80"..":args[".._.."]  arg \"max\" is "..type(v.max).." should be \"number\"")
				IsError = true
			elseif type(v.max) == "number" and v.max < v.min then
				print("\x82".."WARNING".."\x80"..":args[".._.."]  max cannot be less than min!")
				IsError = true
			end
			
			if v.optional == nil then v.optional = false end
			if type(v.optional) ~= "boolean" then
				print("\x82".."WARNING".."\x80"..":args[".._.."]  arg \"optional\" is "..type(v.optional).." should be \"boolean\"")
				IsError = true
			end
			
			if v.colored == nil then v.colored = false end
			if type(v.colored) ~= "boolean" then
				print("\x82".."WARNING".."\x80"..":args[".._.."]  arg \"colored\" is "..type(v.colored).." should be \"boolean\"")
				IsError = true
			end
		end
	end
	
	if type(t.func_comfirm) ~= "function" then 
		print("\x82".."WARNING".."\x80"..": arg \"func_comfirm\" is "..type(t.func_comfirm).." should be \"function\"")
		IsError = true
	end
	
	if type(t.confirm) ~= "string" then t.confirm = "Confirm" end
	if type(t.popup_msg) ~= "string" then t.popup_msg = "Success!" end
	
	
	if IsError then return end
	
	table.insert(LC.GIT_Actions, t)
	print("\x82NOTICE".."\x80"..":Action "..t.name.." Added!")
end

LC.functions.addActionsTab(
{
		name = "Test", -- Name action
		conditions = function(player) -- The condition under which an action must work
			local r = true
			if consoleplayer.cantspeak then return false end
			return r
		end,
		args = { -- Arguments to Action
			{type = "text", header = "Message", min = 5, max = 220, colored = true, optional = false}
		},
		func_comfirm = function(player, ...) -- When an action is taken, this function is triggered
			local args = {...}
			local text = "\""..args[1].."\""
			for i = 1, #LC.macrolist do
				local m = LC.macrolist[i]
				text = text:gsub(m.color, m.text[1])
			end
			COM_BufInsertText(consoleplayer, "sayto "..#player.." "..text)
		end,
		confirm = "SEND!", -- Custom name for the Confirm button
		popup_msg = "SENDED!" -- Pop-up text if the action is completed
	}
)

return true -- End of File
