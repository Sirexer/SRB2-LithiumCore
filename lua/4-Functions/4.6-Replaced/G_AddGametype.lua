
/*
local LC = LithiumCore

LC.replaced_functions.G_AddGametype = G_AddGametype

G_AddGametype = function(...)
	LC.replaced_functions.G_AddGametype(...)
	
	for k, v in pairs(...) do
		print(tostring(k).." - "..tostring(v))
	end
end

*/
return true -- End Of File
