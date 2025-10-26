LithiumCore.accounts = {
	-- Folder where accounts will be saved.
	accountsfolder = LithiumCore.serverdata.clientfolder.."/Accounts/",
	passwords = LithiumCore.serverdata.folder.."/Accounts/",
	
	-- The folder in which the player saves the username and password for SELF.
	client_accountdata = LithiumCore.serverdata.clientfolder.."/autologin.dat",
	
	-- Player's stuff (rings, time, checkpoint, ringslinger weapons)
	OtherStuff = {},
	-- Table of accounts that have already been downloaded from the file
	loaded = {}
}

LithiumCore.accountsData = {} -- Player progress load table

return true
