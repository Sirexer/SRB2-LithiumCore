local LC = LithiumCore

local Standard_Emotes = {
	{
		name = "vergilsmile",
		state = S_LCE_VERGILSMILE,
		scale = FU/3,
		sfx = {sfx_vswsym, sfx_dvscum, sfx_dvdgsc},
		colored = false,
		colorized = false
	},
	
	{
		name = "raildog",
		state = S_LCE_RAILDOG,
		scale = FU/2,
		sfx = {sfx_rail1, sfx_rail2},
		colored = false,
		colorized = false
	},
	
	{
		name = "bs_like",
		state = S_LCE_BWLIKE,
		scale = FU/2,
		sfx = {sfx_3db06},
		colored = false,
		colorized = false
	},
	
	{
		name = "bs_dislike",
		state = S_LCE_BWDISLIKE0,
		scale = FU,
		sfx = {sfx_kc34},
		colored = false,
		colorized = false
	},
	
	{
		name = "sonicwhy",
		state = S_LCE_SONICWHY,
		scale = FU/3,
		sfx = {},
		colored = true,
		colorized = false
	},
	
	{
		name = "stusonic",
		state = S_LCE_STUSONIC,
		scale = FU,
		sfx = {sfx_shello, sfx_slaugh},
		colored = true,
		colorized = false
	},
	
	{
		name = "sonicno",
		state = S_LCE_NOSONIC,
		scale = FU/3,
		sfx = {sfx_tf2eno},
		colored = true,
		colorized = false
	},
	
	{
		name = "bruhsonic",
		state = S_LCE_BRUHSONIC,
		scale = FU,
		sfx = {},
		colored = true,
		colorized = false
	}
	
}

for i = 1, #Standard_Emotes do
	table.insert(LC_Loaderdata["emote"], Standard_Emotes[i])
end

return true -- End Of File
