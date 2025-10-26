-- Emotes states, sprites and SFX

freeslot("MT_LCEMOJI")

mobjinfo[MT_LCEMOJI] = {
	doomednum = -1,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1000,
	reactiontime = 5,
	speed = 0,
	radius = 32*FU,
	height = 32*FU,
	mass = 100,
	flags = MF_FLOAT|MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT
}

-- Stu sonic
freeslot(
	"S_LCE_STUSONIC",
	"SPR_STUS",
	"sfx_shello",
	"sfx_slaugh"
)

states[S_LCE_STUSONIC] = {
	sprite = SPR_STUS,
	frame = FF_FULLBRIGHT|A,
	tics = 115,
	nextstate = S_NULL
}

sfxinfo[sfx_shello] = {
	singular = false,
	flags = SF_NOINTERRUPT,
	caption = "hEllO!"
}

sfxinfo[sfx_slaugh] = {
	singular = false,
	flags = SF_NOINTERRUPT,
	caption = "HaHAHa"
}

-- bruh sonic
freeslot(
	"S_LCE_BRUHSONIC",
	"SPR_SHBH"
)

states[S_LCE_BRUHSONIC] = {
	sprite = SPR_SHBH,
	frame = FF_FULLBRIGHT|A,
	tics = 115,
	nextstate = S_NULL
}

-- bruh sonic
freeslot(
	"S_LCE_NOSONIC",
	"SPR_SHNO",
	"sfx_tf2eno"
)

states[S_LCE_NOSONIC] = {
	sprite = SPR_SHNO,
	frame = FF_FULLBRIGHT|A,
	tics = 115,
	nextstate = S_NULL
}


sfxinfo[sfx_tf2eno] = {
	singular = false,
	flags = SF_NOINTERRUPT,
	caption = "TF2 Engineer says NO!"
}

-- Vergil smiles
freeslot(
	"S_LCE_VERGILSMILE",
	"SPR_DMCV",
	"sfx_vswsym",
	"sfx_dvdgsc",
	"sfx_dvscum"
)

states[S_LCE_VERGILSMILE] = {
	sprite = SPR_DMCV,
	frame = FF_FULLBRIGHT|A,
	tics = 115,
	nextstate = S_NULL
}

sfxinfo[sfx_vswsym] = {
	singular = false,
	flags = SF_NOINTERRUPT,
	caption = "Where is your motivation?"
}

sfxinfo[sfx_dvdgsc] = {
	singular = false,
	flags = SF_NOINTERRUPT,
	caption = "Don't get so cocky"
}

sfxinfo[sfx_dvscum] = {
	singular = false,
	flags = SF_NOINTERRUPT,
	caption = "SCUM!"
}

-- Rail Dog
freeslot(
	"S_LCE_RAILDOG",
	"SPR_RLDG"
)

states[S_LCE_RAILDOG] = {
	sprite = SPR_RLDG,
	frame = FF_FULLBRIGHT|A,
	tics = 115,
	nextstate = S_NULL
}

states[S_LCE_RAILDOG] = {
	sprite = SPR_RLDG,
	frame = FF_FULLBRIGHT|A,
	tics = 115,
	nextstate = S_NULL
}

-- Dislike (Brawl Stars)
freeslot(
	"S_LCE_BWDISLIKE0",
	"S_LCE_BWDISLIKE1",
	"S_LCE_BWDISLIKE2",
	"S_LCE_BWDISLIKE3",
	"S_LCE_BWDISLIKE4",
	"S_LCE_BWDISLIKE5",
	"S_LCE_BWDISLIKE6",
	"S_LCE_BWDISLIKE7",
	"S_LCE_BWDISLIKE8",
	"SPR_BSDL"
)

states[S_LCE_BWDISLIKE0] = {
	sprite = SPR_BSDL,
	frame = FF_FULLBRIGHT|A,
	tics = 70,
	nextstate = S_LCE_BWDISLIKE1
}

states[S_LCE_BWDISLIKE1] = {
	sprite = SPR_BSDL,
	frame = FF_FULLBRIGHT|B,
	tics = 2,
	nextstate = S_LCE_BWDISLIKE2
}

states[S_LCE_BWDISLIKE2] = {
	sprite = SPR_BSDL,
	frame = FF_FULLBRIGHT|C,
	tics = 2,
	nextstate = S_LCE_BWDISLIKE3
}

states[S_LCE_BWDISLIKE3] = {
	sprite = SPR_BSDL,
	frame = FF_FULLBRIGHT|D,
	tics = 2,
	nextstate = S_LCE_BWDISLIKE4
}

states[S_LCE_BWDISLIKE4] = {
	sprite = SPR_BSDL,
	frame = FF_FULLBRIGHT|E,
	tics = 2,
	nextstate = S_LCE_BWDISLIKE5
}

states[S_LCE_BWDISLIKE5] = {
	sprite = SPR_BSDL,
	frame = FF_FULLBRIGHT|F,
	tics = 2,
	nextstate = S_LCE_BWDISLIKE6
}

states[S_LCE_BWDISLIKE6] = {
	sprite = SPR_BSDL,
	frame = FF_FULLBRIGHT|G,
	tics = 4,
	nextstate = S_LCE_BWDISLIKE7
}

states[S_LCE_BWDISLIKE7] = {
	sprite = SPR_BSDL,
	frame = FF_FULLBRIGHT|H,
	tics = 2,
	nextstate = S_LCE_BWDISLIKE8
}

states[S_LCE_BWDISLIKE8] = {
	sprite = SPR_BSDL,
	frame = FF_FULLBRIGHT|A,
	tics = 35,
	nextstate = S_NULL
}

-- Like (Brawl Stars)
freeslot(
	"S_LCE_BWLIKE",
	"SPR_BSUL"
)

states[S_LCE_BWLIKE] = {
	sprite = SPR_BSUL,
	frame = FF_FULLBRIGHT|A,
	tics = 115,
	nextstate = S_NULL
}

-- Sonic (why)
freeslot(
	"S_LCE_SONICWHY",
	"SPR_SRSW"
)

states[S_LCE_SONICWHY] = {
	sprite = SPR_SRSW,
	frame = FF_FULLBRIGHT|A,
	tics = 115,
	nextstate = S_NULL
}

return true -- End Of File
