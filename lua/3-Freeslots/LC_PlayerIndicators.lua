freeslot(
	"MT_LCPI", -- PI Object
	"SPR_LCPI", -- PI Sprites
	
	-- Empty State
	"S_LCPI_EMPTY",
	
	-- Chat States
	"S_LCPI_CHAT01",
	"S_LCPI_CHAT02",
	"S_LCPI_CHAT03",
	"S_LCPI_CHAT04",
	
	-- Menu States
	"S_LCPI_MENU01",
	"S_LCPI_MENU02",
	
	-- AFK States
	"S_LCPI_AFK01",
	"S_LCPI_AFK02",
	
	-- No ping States
	"S_LCPI_NOPING01",
	"S_LCPI_NOPING02"
)

mobjinfo[MT_LCPI] = {
	doomednum = -1,
	spawnstate = S_LCPI_EMPTY,
	spawnhealth = 1000,
	reactiontime = 5,
	speed = 0,
	radius = 32*FU,
	height = 32*FU,
	mass = 100,
	flags = MF_FLOAT|MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT
}

-- Empty State

states[S_LCPI_EMPTY] = {
	sprite = SPR_LCPI,
	frame = FF_FULLBRIGHT|FF_TRANS20|A,
	tics = -1,
	nextstate = S_LCPI_EMPTY
}

-- Chat States

states[S_LCPI_CHAT01] = {
	sprite = SPR_LCPI,
	frame = FF_FULLBRIGHT|FF_TRANS20|B,
	tics = 5,
	nextstate = S_LCPI_CHAT02
}

states[S_LCPI_CHAT02] = {
	sprite = SPR_LCPI,
	frame = FF_FULLBRIGHT|FF_TRANS20|C,
	tics = 5,
	nextstate = S_LCPI_CHAT03
}

states[S_LCPI_CHAT03] = {
	sprite = SPR_LCPI,
	frame = FF_FULLBRIGHT|FF_TRANS20|D,
	tics = 5,
	nextstate = S_LCPI_CHAT04
}

states[S_LCPI_CHAT04] = {
	sprite = SPR_LCPI,
	frame = FF_FULLBRIGHT|FF_TRANS20|E,
	tics = 5,
	nextstate = S_LCPI_CHAT01
}

-- Menu States

states[S_LCPI_MENU01] = {
	sprite = SPR_LCPI,
	frame = FF_FULLBRIGHT|FF_TRANS20|F,
	tics = 15,
	nextstate = S_LCPI_MENU02
}

states[S_LCPI_MENU02] = {
	sprite = SPR_LCPI,
	frame = FF_FULLBRIGHT|FF_TRANS20|G,
	tics = 15,
	nextstate = S_LCPI_MENU01
}

-- AFK States

states[S_LCPI_AFK01] = {
	sprite = SPR_LCPI,
	frame = FF_FULLBRIGHT|FF_TRANS20|H,
	tics = 15,
	nextstate = S_LCPI_AFK02
}

states[S_LCPI_AFK02] = {
	sprite = SPR_LCPI,
	frame = FF_FULLBRIGHT|FF_TRANS20|I,
	tics = 15,
	nextstate = S_LCPI_AFK01
}

-- No ping States

states[S_LCPI_NOPING01] = {
	sprite = SPR_LCPI,
	frame = FF_FULLBRIGHT|FF_TRANS20|J,
	tics = 15,
	nextstate = S_LCPI_NOPING01
}

states[S_LCPI_NOPING02] = {
	sprite = SPR_LCPI,
	frame = FF_FULLBRIGHT|FF_TRANS20|K,
	tics = 15,
	nextstate = S_LCPI_NOPING01
}

return true -- End Of File
