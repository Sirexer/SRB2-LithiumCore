local LC = LithiumCore

LC.commands["LC_menu"] = {
	name = "LC_menu",
	chat = "LC_menu"
}

LC.functions.RegisterCommand("LC_menu", LC.commands["LC_menu"])

COM_AddCommand(LC.commands["LC_menu"].name, function(player)
	LC.functions.menuactive(player)
end, COM_LOCAL)
   
return true
