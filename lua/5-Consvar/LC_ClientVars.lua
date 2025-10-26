local LC = LithiumCore

LC.client_consvars["LC_language"] = CV_RegisterVar({
	name = "LC_language",
	defaultvalue = 0,
	flags = CV_SAVE,
	PossibleValue = {en = 0, ru = 1, tr = 2, es = 3}}
)

LC.client_consvars["LC_optimisebuffercmd"] = CV_RegisterVar({
	name = "LC_optimisebuffercmd",
	defaultvalue = 0,
	flags = CV_SAVE,
	PossibleValue = CV_OnOff}
)

LC.client_consvars["LC_cmdprefix"] = CV_RegisterVar({
	name = "LC_cmdprefix",
	defaultvalue = "/",
	flags = CV_SAVE,
	PossibleValue = nil}
)

LC.client_consvars["LC_votehud"] = CV_RegisterVar({
	name = "LC_votehud",
	defaultvalue = 1,
	flags = CV_SAVE,
	PossibleValue = {console = 0, classic = 1, spacious = 2}}
)

LC.client_consvars["LC_votesfx"] = CV_RegisterVar({
	name = "LC_votesfx",
	defaultvalue = 1,
	flags = CV_SAVE,
	PossibleValue = LC.CV_VoteSFX}
)

LC.client_consvars["autologin"] = CV_RegisterVar({
	name = "LC_autologin",
	defaultvalue = 2,
	flags = CV_SAVE,
	PossibleValue = {Off = 0, On = 1, Ask = 2}}
)

LC.client_consvars["seechat"] = CV_RegisterVar({
	name = "LC_seechat",
	defaultvalue = 1,
	flags = CV_SAVE,
	PossibleValue = CV_OnOff}
)

LC.client_consvars["loadskincolor"] = CV_RegisterVar({
	name = "LC_loadskincolor",
	defaultvalue = 1,
	flags = CV_SAVE,
	PossibleValue = CV_OnOff}
)

LC.client_consvars["censorswear"] = CV_RegisterVar({
	name = "LC_censorswear",
	defaultvalue = "Censor",
	flags = CV_SAVE,
	PossibleValue = {Off = 0, Block = 1, Censor = 2}}
)

LC.functions.AddConsVarMenu({
	name = "LC_CV_LANGUAGE",
	description = "LC_CV_LANGUAGE_TIP",
	command = LC.client_consvars["LC_language"]
})

LC.functions.AddConsVarMenu({
	name = "LC_CV_NETBUFFER",
	description = "LC_CV_NETBUFFER_TIP",
	command = LC.client_consvars["LC_optimisebuffercmd"]
})

LC.functions.AddConsVarMenu({
	name = "LC_CV_SWEARS",
	description = "LC_CV_SWEARS_TIP",
	command = LC.client_consvars["censorswear"]
})

LC.functions.AddConsVarMenu({
	name = "LC_CV_LOADCOLORS",
	description = "LC_CV_LOADCOLORS_TIP",
	command = LC.client_consvars["loadskincolor"]
})

LC.functions.AddConsVarMenu({
	name = "LC_CV_AUTOLOGIN",
	description = "LC_CV_AUTOLOGIN_TIP",
	command = LC.client_consvars["autologin"]
})

LC.functions.AddConsVarMenu({
	name = "LC_CV_SEECHAT",
	description = "LC_CV_SEECHAT_TIP",
	command = LC.client_consvars["seechat"]
})

LC.functions.AddConsVarMenu({
	name = "LC_CV_VOTEHUD",
	description = "LC_CV_VOTEHUD_TIP",
	command = LC.client_consvars["LC_votehud"]
})

LC.functions.AddConsVarMenu({
	name = "LC_CV_VOTESFX",
	description = "LC_CV_VOTESFX_TIP",
	command = LC.client_consvars["LC_votesfx"]
})

return true
