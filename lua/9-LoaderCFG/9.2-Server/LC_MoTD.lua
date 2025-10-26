local LC = LithiumCore

local load_motd = function()
	local motd_file = io.openlocal(LC.serverdata.folder.."/motd.txt", "r")
	if motd_file 
		local motd_data = motd_file:read("*a")
		LC.serverdata.motd = motd_data
		print("MOTD loaded with a size of "..LC.functions.GetFileSize(motd_file))
		motd_file:close()
	else
		local motd_file = io.openlocal(LC.serverdata.folder.."/motd.txt", "w")
		local text = ""
		text = text.."[img width=\"100%\"]NTSATKT1[/img]\n"
		text = text.."\n"
		text = text.."[center][img width=\"32px\"]CREDIT12[/img][size=24]Welcome![/size][img width=\"32px\"]CREDIT02[/img][/center]\n"
		text = text.."\n"
		text = text.."This server uses the [color=sky]LithCore[/color] addon, every time you join the server you will see this [u]message box[/u].\n"
		text = text.."If you are a [color=yellow]~[/color]host, you can edit this message any way you want with any text editor, the text itself is in the [u][i]$SRB2_FOLDER$/luafiles/LithCore/motd.txt[/i][/u] directory.\n"
		text = text.."\n"
		text = text.."[right]You will also be able to use BB code. Don't know what that is?[/right]\n"
		text = text.."\n"
		text = text.."Well it allows you to [size=20][color=green][b][u][s][i]change[/color][/b][/u][/s][/i][/size] the [size=20]s[/size][size=12]i[/size][size=20]z[/size][size=12]e[/size], [color=orange]color[/color], [bg=165]background[/bg] of the text, also make the text [i]italicized[/i], [b]bold[/b], [s]strikethrough[/s] and [u]underlined[/u]. You can add images[img width=\"20px\"]CREDIT05[/img], but only those uploaded to the game. Also you can align the text on the left or right side or center it.\n"
		text = text.."\n"
		for i = 1, 50 do
			if i != 50
				text = text.."[img width=\"2%\"]DL_SNAKEBODY_R[/img]"
			else
				text = text.."[img width=\"2%\"]DL_SNAKEHEAD_R[/img]\n"
			end
		end
		text = text.."\n"
		text = text.."[center][img width=\"256px\"]SGRASS1[/img][/center]\n"
		text = text.."\n"
		text = text.."[left][img width=\"64px\"]SONICDO1[/img][img width=\"64px\"]SONICDO2[/img][/left]\n"
		text = text.."\n"
		text = text.."[right][img width=\"64px\"]TAILSSAD[/img][img width=\"64px\"]INTRO6[/img][/right]\n"
		text = text.."\n"
		for i = 1, 50 do
			if i == 1 
				text = text.."[img width=\"2%\"]DL_SNAKEHEAD_L[/img]"
			elseif i != 50
				text = text.."[img width=\"2%\"]DL_SNAKEBODY_L[/img]"
			else
				text = text.."[img width=\"2%\"]DL_SNAKEBODY_L[/img]\n"
			end
		end
		text = text.."\n"
		text = text.."[right]What is this message box for?[/right]\n"
		text = text.."\n"
		text = text.."For example, if you want to post [color=red]rules[/color] in this box, leave your contacts or a link to the [color=magenta]Discord server[/color].\n"
		text = text.."\n"
		text = text.."By the way, you can use UTF-8 encoding. For example, написать текст с кириллицей (write something in Cyrillic). [color=yellow]Thanks to Ors for unicode fonts[/color].\n"
		text = text.."\n"
		text = text.."[img width=\"100%\"]NTSATKB1[/img]\n"
		motd_file:write(text)
		motd_file:close()
		LC.serverdata.motd = text
	end
end

table.insert(LC_LoaderCFG["server"], load_motd)

return true
