local LC = LithiumCore

local json = json //LC_require "json.lua"

local load_control = function()
	-- Load Control Settings
	local control_file = io.openlocal(LC.serverdata.clientfolder.."/controls.cfg", "r")
	local control_data
	if control_file 
		control_data = control_file:read("*a")
		control_file:close()
		xpcall(
			function()
				control_data = json.decode(control_data)
				for d in ipairs(LC.controls) do
					local def_control = LC.controls[d]
					local Is_Exist = false
					for c in ipairs(control_data) do
						local cfg_control = control_data[c]
						if def_control.name == cfg_control.name then
							Is_Exist = true
							if cfg_control.key == nil then cfg_control.key = def_control.defaultkey end
							break
						end
					end
					
					if Is_Exist == false then
						table.insert(control_data, {name = def_control.name, key = def_control.defaultkey})
					end
				end
			end,
			function()
				local ostime = os.time()
				print("\x82".."WARNING".."\x80"..": controls.cfg is damaged, create a new controls.cfg...")
				print("Damaged file will be saved as controls_"..ostime..".dead.cfg")
				local copy_file = io.openlocal(LC.serverdata.clientfolder.."/controls_"..ostime..".dead.cfg", "w")
				copy_file:write(control_data)
				copy_file:close()
				control_data = LC.functions.SaveControls("new")
				if control_data and control_data != ""
					control_data = json.decode(control_data)
				else
					control_data = {}
				end
			end
		)
	else
		control_data = json.decode(LC.functions.SaveControls("new"))
	end
	LC.localdata.controls = control_data
end

table.insert(LC_LoaderCFG["client"], load_control)

return true
