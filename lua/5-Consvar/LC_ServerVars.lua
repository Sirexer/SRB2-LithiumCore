local LC = LithiumCore

LC.consvars["LC_allowbanchars"] = CV_RegisterVar({
	name = "LC_allowbanchars",
	defaultvalue = 1,
	flags = CV_NETVAR|CV_SAVE,
	PossibleValue = {No = 0, OnlyServer = 1, ServerAdmin = 2, Yes = 3}}
)

LC.consvars["LC_dedicatedname"] = CV_RegisterVar({
	name = "LC_dedicatedname",
	defaultvalue = "LithCore Server",
	flags = CV_NETVAR|CV_SAVE,
	PossibleValue = nil}
)

LC.consvars["LC_servername"] = CV_RegisterVar({
	name = "LC_servername",
	defaultvalue = "LithCore Server",
	flags = CV_NETVAR|CV_SAVE,
	PossibleValue = nil}
)

LC.consvars["LC_tabmessage"] = CV_RegisterVar({
	name = "LC_tabmessage",
	defaultvalue = "",
	flags = CV_NETVAR|CV_SAVE,
	PossibleValue = nil}
)

-- Prevents unregistered people from communicating and moving
LC.consvars["LC_unregblock"] = CV_RegisterVar({
	name = "LC_unregblock",
	defaultvalue = 0,
	flags = CV_NETVAR|CV_SAVE,
	PossibleValue = CV_OnOff}
)

-- When to kick players if they are not registered yet
LC.consvars["LC_unregkick"] = CV_RegisterVar({
	name = "LC_unregkick",
	defaultvalue = 60,
	flags = CV_NETVAR|CV_SAVE,
	PossibleValue = {MIN = 0, MAX = 3600}}
)

-- Time in seconds when to give AFK status to a player during inactivity
LC.consvars["LC_afktimer"] = CV_RegisterVar({
	name = "LC_afktimer",
	defaultvalue = 60,
	flags = CV_NETVAR|CV_SAVE,
	PossibleValue = {MIN = 10, MAX = 3600}}
)

-- A player will not be able to take damage if they are in AFK
LC.consvars["LC_afkinvincible"] = CV_RegisterVar({
	name = "LC_afkinvincible",
	defaultvalue = 1,
	flags = CV_NETVAR|CV_SAVE,
	PossibleValue = CV_OnOff}
)

-- A player will not be able to take damage if he finishes
LC.consvars["LC_finishedinvincible"] = CV_RegisterVar({
	name = "LC_fininshedinvincible",
	defaultvalue = 1,
	flags = CV_NETVAR|CV_SAVE,
	PossibleValue = CV_OnOff}
)

LC.consvars.unregsilence = CV_RegisterVar({
	name = "LC_unregsilence",
	defaultvalue = "Off",
	flags = CV_NETVAR|CV_SAVE,
	PossibleValue = CV_OnOff}
)

LC.consvars.waitregtosay = CV_RegisterVar({
	name = "LC_waitregtosay",
	defaultvalue = 0,
	flags = CV_NETVAR|CV_SAVE,
	PossibleValue = {MIN = 0, MAX = 3600}}
)

LC.consvars.repeatmsg = CV_RegisterVar({
	name = "LC_repeatmsg",
	defaultvalue = 1,
	flags = CV_NETVAR|CV_SAVE,
	PossibleValue = CV_OnOff}
)

LC.consvars.autobackup = CV_RegisterVar({
	name = "LC_autobackup",
	defaultvalue = "Off",
	flags = CV_NETVAR|CV_SAVE,
	PossibleValue = CV_OnOff}
)

LC.consvars.autoreg = CV_RegisterVar({
	name = "do_autoreg",
	defaultvalue = "Off",
	flags = CV_NETVAR,
	PossibleValue = CV_OnOff}
)

LC.consvars.dologstuff = CV_RegisterVar({
	name = "do_stufflog",
	defaultvalue = "Off",
	flags = CV_NETVAR,
	PossibleValue = CV_OnOff}
)

LC.consvars.vote_calmdown = CV_RegisterVar({
	name = "LC_vote_calmdown",
	defaultvalue = "120",
	flags = CV_NETVAR|CV_SAVE,
	PossibleValue = {MIN = 0, MAX = 3600}}
)

LC.consvars.mutechat = CV_RegisterVar({
	name = "LC_mutechat",
	defaultvalue = "Off",
	flags = CV_NETVAR|CV_SAVE,
	PossibleValue = CV_OnOff}
)

LC.consvars.saveserverstate = CV_RegisterVar({
	name = "LC_saveserverstate",
	defaultvalue = "On",
	flags = CV_NETVAR|CV_SAVE,
	PossibleValue = {Off = 0, On = 1, OnlyMap = 2, OnlyEmeralds = 3}}
)

LC.consvars.banwordfilter = CV_RegisterVar({
	name = "LC_banwordfilter",
	defaultvalue = "Block",
	flags = CV_NETVAR|CV_SAVE,
	PossibleValue = {Off = 0, Block = 1, Censor = 2}}
)

LC.consvars.percomplet = CV_RegisterVar({
	name = "LC_percomplet",
	defaultvalue = 100,
	flags = CV_NETVAR|CV_SAVE,
	PossibleValue = {MIN = 1, MAX = 100}}
)

LC.consvars.countdown = CV_RegisterVar({
	name = "LC_countdown",
	defaultvalue = 60,
	flags = CV_NETVAR|CV_SAVE,
	PossibleValue = {MIN = 0, MAX = 3600}}
)

LC.consvars.timelimit = CV_RegisterVar({
	name = "LC_timelimit",
	defaultvalue = 10,
	flags = CV_NETVAR|CV_SAVE,
	PossibleValue = {MIN = 0, MAX = 300}}
)

LC.consvars.emotecountdown = CV_RegisterVar({
	name = "LC_emotecountdown",
	defaultvalue = 5,
	flags = CV_NETVAR|CV_SAVE,
	PossibleValue = {MIN = 0, MAX = 300}}
)

LC.functions.AddConsVarMenu({
	name = "LC_CV_FINISHEDINV",
	description = "LC_CV_FINISHEDINV_TIP",
	command = LC.consvars["LC_finishedinvincible"]
})

LC.functions.AddConsVarMenu({
	name = "LC_CV_AFKINV",
	description = "LC_CV_AFKINV_TIP",
	command = LC.consvars["LC_afkinvincible"]
})

LC.functions.AddConsVarMenu({
	name = "LC_CV_EMOTECD",
	description = "LC_CV_EMOTECD_TIP",
	command = LC.consvars["emotecountdown"]
})

LC.functions.AddConsVarMenu({
	name = "LC_CV_TIMELIMIT",
	description = "LC_CV_TIMELIMIT_TIP",
	command = LC.consvars["timelimit"]
})

LC.functions.AddConsVarMenu({
	name = "LC_CV_EXITCD",
	description = "LC_CV_EXITCD_TIP",
	command = LC.consvars["countdown"]
})

LC.functions.AddConsVarMenu({
	name = "LC_CV_PERCOMPLET",
	description = "LC_CV_PERCOMPLET_TIP",
	command = LC.consvars["percomplet"]
})

LC.functions.AddConsVarMenu({
	name = "LC_CV_AFKTIMER",
	description = "LC_CV_AFKTIMER_TIP",
	command = LC.consvars["LC_afktimer"]
})

LC.functions.AddConsVarMenu({
	name = "LC_CV_BANWORDS",
	description = "LC_CV_BANWORDS_TIP",
	command = LC.consvars["banwordfilter"]
})

LC.functions.AddConsVarMenu({
	name = "LC_CV_UNREGSILENCE",
	description = "LC_CV_UNREGSILENCE_TIP",
	command = LC.consvars["unregsilence"]
})

LC.functions.AddConsVarMenu({
	name = "LC_CV_REPEATMSG",
	description = "LC_CV_REPEATMSG_TIP",
	command = LC.consvars["repeatmsg"]
})

LC.functions.AddConsVarMenu({
	name = "LC_CV_AUTOBACKUP",
	description = "LC_CV_AUTOBACKUP_TIP",
	command = LC.consvars["autobackup"]
})

LC.functions.AddConsVarMenu({
	name = "LC_CV_NOCHAT",
	description = "LC_CV_NOCHAT_TIP",
	command = LC.consvars["mutechat"]
})

LC.functions.AddConsVarMenu({
	name = "LC_CV_SAVESERVERSTATE",
	description = "LC_CV_SAVESERVERSTATE_TIP",
	command = LC.consvars["saveserverstate"]
})
		
LC.functions.AddConsVarMenu({
	name = "LC_CV_AUTOREG",
	description = "LC_CV_AUTOREG_TIP",
	command = LC.consvars.autoreg
})
		
LC.functions.AddConsVarMenu({
	name = "LC_CV_UNREGBLOCK",
	description = "LC_CV_UNREGBLOCK_TIP",
	command = LC.consvars["LC_unregblock"]
})
		
LC.functions.AddConsVarMenu({
	name = "LC_CV_UNREGKICK",
	description = "LC_CV_UNREGKICK_TIP",
	command = LC.consvars["LC_unregkick"]
})
		
LC.functions.AddConsVarMenu({
	name = "LC_CV_VOTECD",
	description = "LC_CV_VOTECD_TIP",
	command = LC.consvars.vote_calmdown
})

return true
