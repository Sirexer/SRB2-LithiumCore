-- Table of standard Gametypes

LithiumCore.Gametypes = {
	["all"] = {
		["name"] = {
			[GT_COOP] = "coop",
			[GT_COMPETITION] = "competition",
			[GT_RACE] = "race",
			[GT_MATCH] = "match",
			[GT_TEAMMATCH] = "teammatch",
			[GT_TAG] = "tag",
			[GT_HIDEANDSEEK] = "hideandseek",
			[GT_CTF] = "ctf"
		},
		["tol"] = {
			[GT_COOP] = TOL_COOP,
			[GT_COMPETITION] = TOL_COMPETITION,
			[GT_RACE] = TOL_RACE,
			[GT_MATCH] = TOL_MATCH,
			[GT_TEAMMATCH] = TOL_MATCH,
			[GT_TAG] = TOL_TAG,
			[GT_HIDEANDSEEK] = TOL_TAG,
			[GT_CTF] = TOL_CTF
		}
	}
}

return true
