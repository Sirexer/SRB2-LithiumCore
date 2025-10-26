local LC = LithiumCore

local fade = 0
local firstplayer = 1
local firstaction = 1
local firstarg = 1
local firstletter = 1
local li = 1

local cv_servername = CV_FindVar("servername")
local cv_maxplayers = CV_FindVar("maxplayers")

local emeralds_t = {EMERALD1, EMERALD2, EMERALD3, EMERALD4, EMERALD5, EMERALD6, EMERALD7}
local animated_select = {128, 129, 130, 131, 132, 133, 134, 135, 136, 135, 134, 133, 132, 131, 130, 129}
local popupflags = {V_10TRANS, V_20TRANS, V_30TRANS, V_40TRANS, V_50TRANS, V_60TRANS, V_70TRANS, V_80TRANS, V_90TRANS}
local textcolors = {1, 182, 73, 96, 149, 32, 10, 53, 130, 192, 140, 188, 170, 224, 201, 26}
local token_anim = {}

local base64 = base64
local bmp = bmp

for frame = A, T do
	table.insert(token_anim, frame)
end

local toilet_b64 = [[
Qk02DAAAAAAAADYAAAAoAAAAIAAAACAAAAABABgAAAAAAAAAAADEDgAAxA4AAAAAAAAAAAAA/////v7+8vLy5ubm5ubm5ubm5ubm5ubm5ubm7Ozt8vLy+/v7////+/v71NPTpaaoiIiId3l8d3d4e3t7iIiIkZOTkZOTiIiId3l8sre6////////////////////////8fHxjpabd3l8f4WHlZWVoaGhoaGhlZWVhI6Ud3d4d3l8eH6Esre6paaoSVRyQ1l0lpaWs7O0vr+/w8TEzczJ0tLS2dra2drarK2uiIiI////////////////////////7Oztd3l8w8TEz8/P0tLS1tbV1tbV0tLSz8/Pko+nCiycLzuZUGKLUGKLCiycUFaS1tbV3dzc4uLi6Ojn7Ovr7+/w9/b29/b2vb6/ysvL////////////////////////////xsbG0dHR9/b29/b29/b29/b28/Pz9/b2jIzDAAC+Dg+tIyZ7GBmJAAC+QUDJ7+/w+/r6+/r6/v7+/v7+////////4uLiw8XG/f39////////////////////////////+/v7xMTE0NTW+/r6////////////4uHrNjbYBwf0AADjIyZ7Dw+UAADjBwf0rq7h////////////////8/Pzvb6/1NfY////////////////////////////////////////////3t7ezMzM0dHR1tbVvLjRTEyvDg+tDg+tDw+UT09vSVRyUFaSLzuZLzuZpKTP4uHr7Ovr0NTWub/Bzdbb/////////////////////////////////////////////////////v7+5ubmx8fIbW2Ld3eLoqKgubm5eHh3eHh3vr+/zczJ1tbVi4iRP0B2f4Gsw8XGz9zj+/v7////////////////////////////////////////////////////////////////////t7e1ubm56Ojn////ubm5lpaWs7O02dra////3dzcl5yf2d3f/////////////f3+9fn79fn7/v7+////////////////////////////////////////////////////tra2oqKga4mZbZKokZOTjYyLMGuES5G3o6msubm5laKp5+rr////9vv82fP5st/vpdPshcvuhcvuu97z/v7+////////////////////////////////+/v77Ozt8fHx5+rrur/CJ3ScLn+rur/CkKWuE4vEG4KwV2Bkl5yf1NfY////9vv8t+TwiNHp2Oz3+vz97fb6u97zcrzru97z/////////////////f39////////5ubmv7+/q62uq62usLCwra6tK4q+aJ65wtDXLn+rIZzZer7Xn9Liqdjlt+Twy+rzy+rzYb7iesTl2fP55fX59fn7////9fn74O/4/v7+////////////1NfY09PTzc3NwMDAycnJs7O02dras7O0e4GBFHq0VpOxP4qvDJbQMYasn9Lis+Xynt7xn9Lii8jdi8jdgMLbnt7xouT1e87ofsrmj87qv9fh9fn7////////////////mZmZw8TE0NTW6Ojn4uLirK2ubZKoH1+DV2BkiKOxo7/KlbTEP53DG4KwW5m1er7Xi8jdktPon9Lii8jdgMLbe8nkYb7iYb7ibsXlY7bYnbG8f6m84O/4////////////4+Pj1NfY5+rrzc3N8/Pzubm5YHF7H1+Do6ms9/b2/v7++/r61tbVNI6/d6K4gMLbdrfQdrfQgMLbktPoe8nkY7bYbsXlbsXlXqjGiKOxs7O0aKLCcrzr+Pr8////////////////////09PT7Ovr4uLizczJf4WHu7nA/v7+////////8/PzX5q8v9fh2/H3qdjli8jddrfQdrfQgMLbnt7xnt7xdrfQsbzD1tbVvr+/fJuplcjl7fb6////////////////////v7+/2dras7O0vr+/zs7Oub/B7+/w////////+/r6d6K4wtDX7vj7we33s+Xyi8jdcLDLe8nkouT1ktPodKC0ubm5ycnJw8TEa4mZv9fh////////////////////4+PjlZWVz8/PpaWlmZmZ3t7e4+PjwMDA7+/w////////wM3ThI6UXJexW5m1drfQi6q2W5m1FpjWIZzZYb7idKC0ycnJ1tbV1tbVq62u5Orv////////////////////8fHxu7u7q62u3t7e2d3fx8fI1NPTioqKrK2uw8TErLe62draubm5YHF7X4SSi6q2o6msQIClPou6CH/ID47OW5m1z8/P6Ojn4uLisba4+/v7/////////////////////////v7+4+Pj+Pj4+Pj4ra6tlaKpjYyLoqKgz8/P2draw8TEko+ni4iRw8TE7Ovr2drarK2uPou6EovUEovUNI6/lbTEr8XOwM3Tsba4+/v7////////////////////////////////+/v7xsbGsLCwoqKgrK2u7+/w////+/r64uLivLjRu7nA////////7Ovrubm5dKC0SZW/EovULJLTLJLTVqzZbsXlntDm/f3+////////////////////////////////////+Pj4xMTEkZOTV2Bkz8/P4uLi4uLizczJnpBxi6q2r8XOwM3T4uLis7O0SYejIZzZFJLcLJLTQpjbpdPsesTlntDm+vz9/////////////////////f39/f39////////8fHxra6tf4WHe4GBO3yYcLDL+/r6s6WKcVw2U6PBBKHcFJ3QP53DiKOxa4mZG4KwFJLcKpDYu97z////3+z03+z0////////////////////////8fHxsre6+/v7/////f398vLybZGkoqKgH5G8er7X/v7+wLOVnpBxQ6nOAK/yAKzvD6PnE4vEH5G8FpjWFIXYQpjb4O/4////////////////////////////////////+Pj4bZGkmbjJ////////2d3fLn+rrLe6FJ3QdrfQ////1tbVlKSdFqbfAK/yAK/yAKftEpjfH5G8EpjfFIXYcrzr/f3+////////////////////////////////8vLy7OztmbjJK4q+mbjJ+/v7sre6FHq0dKC0FqbfP53D3dzcwM3TP53DAKzvAK/yAK/yAKftD47OO3yYFHq0Qpjb2Oz3////////////////////////////////////8vLykKWui6m4aJ65OJC8VpOxQGuBFHq0EZHFD6PnBKHcMYasEZHFAKzvAK/yAK/yAK/yAKftU6PBz8/PYpWyxNbj////////////////////////////////////////////7OztepmpP4qvVpOxJ3ScF3OgF3OgD47OAK/yAK/yAK/yAK/yAKzvAKzvAKzvAKzvDJbQwM3T4uLiwM3TqrrD////////////////////////////////////////////////+Pj4ssTMVpOxQIClW5m1SYejG4KwFJ3QFqbfD6PnD6PnD6PnD6PnEpjfNpjHo7/K8/Pz1tbV7+/wlaKp8fHx////////////////////////////////////+Pj4ysvLur/CzdbbkKWubZKoiKOxSYejSYejH5G8XJexm77NmL/PmL/Pf6m8NI6/lbTE7Ovr7+/wycnJ+/r6lqm2zdbb/////////////////////////////////////v7+5ubmpbnCaJ65Ln+rMYasdKC0i6q2NI6/XJex2d3f////////////7OztjLLFLn+ra4mZubm52dra////nbG8ssTM////////////////////////////////////////////////+Pj4epmpiKOxlbTEYpWyjLLF7Ozt////////////////////+/v7wtDXeJ+zXIund6K4sbzDbZKossTM////////////////////////////////////////////////////jpabSHKHeJ+zzdbb////////////////////////////////////+/v72d3fpbnCepmpbZGkzdbb////////////////////////////////
]]

local toilet_bin = base64.decode(toilet_b64)
local toilet_img = bmp.decode(toilet_bin)


local hooktable = {
	name = "LC.AltScores",
	type = "HUD",
	typehud = {"game"},
	toggle = true,
	priority = 900,
	TimeMicros = 0,
	func = function(v, player, camera)
		local AltScores = LC.localdata.AltScores
		if LC.localdata.AltScores.enabled == false then firstplayer = 1 fade = 0 return end
		if fade != 5 then fade = $ + 1 end
		local playersandbots = LC.serverdata.countplayers + LC.serverdata.countbots
		v.fadeScreen(31, fade)
		
		if LC.consvars["LC_tabmessage"] and LC.consvars["LC_tabmessage"].string ~= "" then
			v.drawString(160, 0, LC.consvars["LC_tabmessage"].string, V_50TRANS, "center")
		end
		
		v.drawFill(1, 8, 318, 1, 74)
		v.drawFill(1, 176, 318, 1, 74)
		v.drawFill(1, 192, 318, 1, 74)
		v.drawFill(2, 9, 316, 32, 253)
		v.drawFill(2, 177, 316, 15, 253)
		local str_servername = LC.functions.getStringLanguage("LC_SERVERNAME").." - "..cv_servername.string
		LC.functions.drawString(v, 4, 10, str_servername, 0, "small")
		local centis = tostring(G_TicsToCentiseconds(LC.serverdata.servertime))
		if centis:len() == 1 then centis = "0"..centis end
		local seconds = tostring(G_TicsToSeconds(LC.serverdata.servertime))
		if seconds:len() == 1 then seconds = "0"..seconds end
		local minutes = tostring(G_TicsToMinutes(LC.serverdata.servertime, false))
		if minutes:len() == 1 then minutes = "0"..minutes end
		local hours = tostring(G_TicsToHours(LC.serverdata.servertime))
		local servertime = hours..":"..minutes..":"..seconds.."."..centis
		
		local str_servertime = LC.functions.getStringLanguage("LC_SERVERTIME")
		local step = LC.functions.drawString(v, 4, 14, str_servertime, 0, "small")
		v.drawString(step+4, 14, " - "..servertime, 0, "small")
		local c_tps = "\x88"..LC.serverdata.tps
		if LC.serverdata.tps <= 20 then
			c_tps = "\x85"..LC.serverdata.tps
		elseif LC.serverdata.tps <= 30 then
			c_tps = "\x82"..LC.serverdata.tps
		elseif LC.serverdata.tps <= 34 then
			c_tps = "\x83"..LC.serverdata.tps
		end
		
		local str_servertps = LC.functions.getStringLanguage("LC_SERVERTPS").." - "..c_tps
		LC.functions.drawString(v, 4, 18, str_servertps, 0, "small")
		
		local str_player = LC.functions.getStringLanguage("LC_PLAYERS").." - "..playersandbots.."/"..cv_maxplayers.value
		LC.functions.drawString(v, 4, 22, str_player, 0, "small")
		
		local gt_str = ""
		for k, v in pairs(getfenv(0))
			if k:sub(1,3) == "GT_"
			and v == gametype
				gt_str = k:sub(4)
				break
			end
		end
		
		local str_gt = LC.functions.getStringLanguage("LC_GAMETYPE").." - "..gt_str
		LC.functions.drawString(v, 4, 26, str_gt, 0, "small")
		
		for i = 0, #skins-1 do
			local patch = v.getSprite2Patch(i, SPR2_LIFE, false, 0, 0)
			local prefcolor = v.getColormap(TC_DEFAULT, skins[i].prefcolor)
			local highresscale = skins[i].highresscale
			if patch and prefcolor then v.drawScaled((1*FRACUNIT)+(((i+1)*6)*FRACUNIT), 38*FRACUNIT, highresscale/3, patch, 0, prefcolor) end
		end
		
		local mapdata = mapheaderinfo[gamemap]
		local patchname = LC.functions.BuildMapName(gamemap).."P"
		if not v.patchExists(patchname)
			patchname = "BLANKLVL"
		end
		v.drawScaled(276*FRACUNIT, 12*FRACUNIT, FRACUNIT/4, v.cachePatch(patchname), 0)
		v.drawFill(275, 11, 42, 1, 74)
		v.drawFill(275, 37, 42, 1, 74)
		
		local levelname = mapdata.lvlttl
		if mapdata.actnum != 0 then levelname = levelname.." "..mapdata.actnum end
		
		local nextlevel = "..."
		if mapdata.nextlevel
			if mapdata.nextlevel < 1036 and mapheaderinfo[mapdata.nextlevel]
				nextlevel = mapheaderinfo[mapdata.nextlevel].lvlttl
				if mapheaderinfo[mapdata.nextlevel].actnum != 0 then nextlevel = nextlevel.." "..mapheaderinfo[mapdata.nextlevel].actnum end
			elseif mapdata.nextlevel > 1035
				if mapdata.nextlevel == 1100
					nextlevel = "TITLE"
				elseif mapdata.nextlevel == 1101
					nextlevel = "EVALUATION"
				elseif mapdata.nextlevel == 1102
					nextlevel = "CREDITS"
				elseif mapdata.nextlevel == 1103
					nextlevel = "ENDING"
				end
			end
		end
		
		local str_level = LC.functions.getStringLanguage("LC_LEVEL")
		step = LC.functions.drawString(v, 272, 10, str_level, 0, "small-right")
		v.drawString(272-step, 10, levelname.." - ", 0, "small-right")
		
		local centis = tostring(G_TicsToCentiseconds(leveltime))
		if centis:len() == 1 then centis = "0"..centis end
		local seconds = tostring(G_TicsToSeconds(leveltime))
		if seconds:len() == 1 then seconds = "0"..seconds end
		local minutes = tostring(G_TicsToMinutes(leveltime, true))
		if minutes:len() == 1 then minutes = "0"..minutes end
		local leveltime_c = minutes..":"..seconds.."."..centis
		
		local str_leveltime = leveltime_c.." - "..LC.functions.getStringLanguage("LC_LEVELTIME")
		LC.functions.drawString(v, 272, 14, str_leveltime, 0, "small-right")
		
		local str_nextlevel = nextlevel.." - "..LC.functions.getStringLanguage("LC_NEXTLEVEL")
		LC.functions.drawString(v, 272, 18, str_nextlevel, 0, "small-right")
		
		local str_completed = LC.serverdata.completedlevel.."/"..LC.serverdata.countplayers-LC.serverdata.afkplayers_nc.." - "..LC.functions.getStringLanguage("LC_COMPLETEDLEVEL")
		LC.functions.drawString(v, 272, 22, str_completed, 0, "small-right")
		//v.drawString(272, 34, " - Emeralds", 0, "small-right")
		
		for i = 1, #emeralds_t do
			if (emeralds & emeralds_t[i])
				local patch = v.cachePatch("TEMER"..i)
				v.drawScaled((280*FRACUNIT)-(((i+1)*9)*FRACUNIT), 32*FRACUNIT, FRACUNIT, patch, 0)
			end
		end
		
		if shareEmblems != nil
			local emblem_patch = v.cachePatch("GOTITN")
			v.drawScaled(16*FRACUNIT, 179*FRACUNIT, FRACUNIT-(FU/3), emblem_patch, 0, v.getColormap(TC_DEFAULT, SKINCOLOR_BLUE))
			v.drawString(45, 180, shareEmblems, 0, "left")
			v.drawScaled(36*FRACUNIT, 182*FRACUNIT, FRACUNIT, v.cachePatch("STLIVEX"), 0)
		end
		
		if token
			local tokenpatch = v.getSpritePatch(SPR_TOKE, tf, 0)
			local t_flags = 0
			for frame_c = 1, #token_anim do
				if (leveltime % #token_anim+1) == frame_c
					tokenpatch = v.getSpritePatch(SPR_TOKE, token_anim[frame_c], 0)
					if token_anim[frame_c] >= 11 and token_anim[frame_c] <= 14
						t_flags = V_FLIP
					end
				end
			end
			v.drawScaled(96*FRACUNIT, 190*FRACUNIT, FRACUNIT/3, tokenpatch, t_flags)
			v.drawString(113, 180, token, 0, "left")
			v.drawScaled(104*FRACUNIT, 182*FRACUNIT, FRACUNIT, v.cachePatch("STLIVEX"), 0)
		end
		
		v.drawFill(1, 41, 318, 1, 74)
		v.drawFill(1, 54, 318, 1, 74)
		v.drawFill(2, 42, 316, 12, 253)
		local sort = LC.localdata.AltScores.sort
		local sort_t = LC.SortingPlayers[sort]
		if AltScores.nav.y == 0 and AltScores.nav.x == 0
			v.drawString(16, 46, "\x82Sort\x80: ", 0, "small")
		else
			v.drawString(16, 46, "Sort: ", 0, "small")
		end
		v.drawString(64, 46, sort_t.name, 0, "small-center")
		
		if AltScores.nav.y == 0 and AltScores.nav.x == 1
			v.drawString(96, 46, "\x82Reverse\x80: ", 0, "small")
		else
			v.drawString(96, 46, "Reverse: ", 0, "small")
		end
		v.drawString(136, 46, tostring(LC.localdata.AltScores.reverse), 0, "small-center")
		
		
		v.drawFill(192, 45, 96, 6, 158)
		local str_search = LC.functions.getStringLanguage("LC_SEARCH")
		if AltScores.nav.y == 0 and AltScores.nav.x == 2
			LC.functions.drawString(v, 164, 46, "\x82"..str_search.."\x80: ", 0, "small")
			if (leveltime % 8) == 4
				v.drawString(192, 46, AltScores.search.."_", V_ALLOWLOWERCASE, "small")
			else
				v.drawString(192, 46, AltScores.search, V_ALLOWLOWERCASE, "small")
			end
		else
			LC.functions.drawString(v, 164, 46, str_search..": ", 0, "small")
			v.drawString(192, 46, AltScores.search, V_ALLOWLOWERCASE, "small")
		end
		
		local y_arrow = 44
		
		if (leveltime % 16) > 8 then y_arrow = 45 end
		
		if AltScores.nav.y != 0
			v.drawString(4, y_arrow, "\x82"..string.char(26), V_ALLOWLOWERCASE, "thin")
		end
		if AltScores.nav.y != #AltScores.players
			v.drawString(4, y_arrow, "\x82"..string.char(27), V_ALLOWLOWERCASE, "thin")
		end
		v.drawFill(15, 55, 1, 121, 1)
		v.drawFill(33, 55, 1, 121, 1)
		v.drawFill(127, 55, 1, 121, 1)
		v.drawFill(178, 55, 1, 121, 1)
		v.drawFill(222, 55, 1, 121, 1)
		v.drawFill(268, 55, 1, 121, 1)
		v.drawFill(296, 55, 1, 121, 1)
		//v.drawString(2, 58, "Lives Skin          Name/\x84(username)\x80/[group]                                   Score                           Finished                 Time played              flags           ping/node", 0, "small-thin")
		if G_GametypeUsesLives()
			LC.functions.drawString(v, 2, 58, LC.functions.getStringLanguage("LC_LIVES"), 0, "small-thin")
		elseif G_GametypeHasTeams()
			LC.functions.drawString(v, 2, 58, LC.functions.getStringLanguage("LC_TEAM"), 0, "small-thin")
		elseif G_TagGametype()
			v.drawString(2, 58, "IT", 0, "small-thin")
		end
		LC.functions.drawString(v, 16, 58, LC.functions.getStringLanguage("LC_SKIN"), 0, "small-thin")
		LC.functions.drawString(v, 34, 58, LC.functions.getStringLanguage("LC_NAMEUSERGROUP"), 0, "small-thin")
		LC.functions.drawString(v, 128, 58, LC.functions.getStringLanguage("LC_SCORE"), 0, "small-thin")
		if G_PlatformGametype()
			LC.functions.drawString(v, 180, 58, LC.functions.getStringLanguage("LC_FINISHED"), 0, "small-thin")
		elseif G_RingSlingerGametype()
			LC.functions.drawString(v, 180, 58, LC.functions.getStringLanguage("LC_KILLS"), 0, "small-thin")
			v.drawFill(200, 55, 1, 121, 1)
			LC.functions.drawString(v, 202, 58, LC.functions.getStringLanguage("LC_DEATHS"), 0, "small-thin")
		end
		LC.functions.drawString(v, 224, 58, LC.functions.getStringLanguage("LC_TIMEPLAYED"), 0, "small-thin")
		LC.functions.drawString(v, 271, 58, LC.functions.getStringLanguage("LC_ALTGI_FLAGS"), 0, "small-thin")
		LC.functions.drawString(v, 298, 58, LC.functions.getStringLanguage("LC_ALTGI_PINGNODE"), 0, "small-thin")
		LC.localdata.AltScores.players = sort_t.func()
		if AltScores.search != "" and AltScores.search != " "
			local search_t = {}
			local search = AltScores.search:lower():gsub("%W","%%%0")
			for p = 1, #AltScores.players do
				if AltScores.players[p].name:lower():find(search)
				or AltScores.players[p].stuffname and AltScores.players[p].stuffname:lower():find(search)
					table.insert(search_t, AltScores.players[p])
				end
			end
			AltScores.players = search_t
		end
	
		v.drawString(288, 46, "("..#AltScores.players.."/"..playersandbots..")", V_ALLOWLOWERCASE, "small")
		
		local player_list = LC.localdata.AltScores.players
		local y = 0
		
		if AltScores.players[1]
		and AltScores.nav.y != 0
			if AltScores.nav.y < firstplayer
				firstplayer = $ - 1
			elseif AltScores.nav.y > firstplayer+6
				firstplayer = $ + 1
			end
		end
		
		for i = firstplayer, firstplayer+6 do
			if not player_list[i] then continue end
			local player = player_list[i]
			local patchskin
			local pcolor
			
			local Is_Super = false
			if player.powers[pw_super] then Is_Super = true end
			
			if player.mo and player.mo.valid
				patchskin = v.getSprite2Patch(player.mo.skin, SPR2_XTRA, Is_Super, 0, 0)
				pcolor = v.getColormap(nil, player.mo.color)
			else
				patchskin = v.getSprite2Patch(player.skin, SPR2_XTRA, Is_Super, 0, 0)
				pcolor = v.getColormap(TC_RAINBOW, SKINCOLOR_GREY)
			end
			if server == player
				LC.functions.drawString(v, 315, 70+y, LC.functions.getStringLanguage("LC_HOST"), V_ALLOWLOWERCASE, "small-right")
			elseif player.bot != 0
				LC.functions.drawString(v, 315, 70+y, LC.functions.getStringLanguage("LC_BOT"), V_ALLOWLOWERCASE, "small-right")
				v.drawString(315, 74+y, "#"..#player, V_ALLOWLOWERCASE, "small-right")
			elseif player.quittime != 0
				v.drawFill(306, 68+y, 2, 3, 31)
				v.drawFill(308, 67+y, 2, 4, 31)
				v.drawFill(310, 66+y, 2, 5, 31)
				v.drawFill(312, 65+y, 2, 6, 31)
				v.drawScaled(304*FRACUNIT, (66+y)*FRACUNIT, FRACUNIT/2, v.cachePatch("NOPINGICON"), 0, pcolor)
				v.drawString(315, 74+y, "#"..#player, V_ALLOWLOWERCASE, "small-right")
			elseif server != player
				if player.ping > 256
					v.drawFill(306, 68+y, 2, 3, 35)
					v.drawFill(308, 67+y, 2, 4, 31)
					v.drawFill(310, 66+y, 2, 5, 31)
					v.drawFill(312, 65+y, 2, 6, 31)
				elseif player.ping > 128
					v.drawFill(306, 68+y, 2, 3, 75)
					v.drawFill(308, 67+y, 2, 4, 73)
					v.drawFill(310, 66+y, 2, 5, 31)
					v.drawFill(312, 65+y, 2, 6, 31)
				elseif player.ping > 64
					v.drawFill(306, 68+y, 2, 3, 116)
					v.drawFill(308, 67+y, 2, 4, 114)
					v.drawFill(310, 66+y, 2, 5, 112)
					v.drawFill(312, 65+y, 2, 6, 31)
				elseif player.ping >= 0
					v.drawFill(306, 68+y, 2, 3, 138)
					v.drawFill(308, 67+y, 2, 4, 136)
					v.drawFill(310, 66+y, 2, 5, 134)
					v.drawFill(312, 65+y, 2, 6, 132)
				end
				LC.functions.drawString(v, 311, 70+y, player.ping..LC.functions.getStringLanguage("LC_MS"), V_ALLOWLOWERCASE, "small-thin-right")
				v.drawString(315, 74+y, "#"..#player, V_ALLOWLOWERCASE, "small-right")
			end
			v.drawScaled(16*FRACUNIT, (64+y)*FRACUNIT, FRACUNIT/2, patchskin, 0, pcolor)
			//LC.functions.drawScaledIMG(v, 16*FRACUNIT, (64+y)*FRACUNIT, toilet_img, FRACUNIT/2, 0)
			local playername = player.name
			local search = AltScores.search:lower():gsub("%W","%%%0")
			local f_start, f_end = playername:lower():find(search)
			if f_start then playername = playername:sub(1, f_start-1).."\x87"..playername:sub(f_start) end
			if consoleplayer == player
				if f_start then playername = playername:sub(1, f_end+1).."\x82"..playername:sub(f_end+2) end
				v.drawString(34, 66+y, "\x82"..playername, V_ALLOWLOWERCASE, "small")
			else
				if f_start then playername = playername:sub(1, f_end+1).."\x80"..playername:sub(f_end+2) end
				v.drawString(34, 66+y, playername, V_ALLOWLOWERCASE, "small")
			end
			if player.stuffname
				local username = player.stuffname
				local u_start, u_end = username:lower():find(search)
				if u_start
					username = username:sub(1, u_start-1).."\x88"..username:sub(u_start)
					username = username:sub(1, u_end+1).."\x84"..username:sub(u_end+2)
				end
				v.drawString(34, 70+y, "\x84("..username..")", V_ALLOWLOWERCASE, "small")
			end
			if player.group
				local group = "["..LC.serverdata.groups.list[player.group].color..LC.serverdata.groups.list[player.group].displayname.."\x80]"
				v.drawString(34, 74+y, group, V_ALLOWLOWERCASE, "small")
			end
			if player.LC_afk == nil or player.LC_afk.enabled == false
				if (player.pflags & PF_FINISHED)
					local x = 288*FRACUNIT
					local y = (68+y)*FRACUNIT
					local scale = FRACUNIT/2
					local patch = v.cachePatch("EXITICON")
					local flags = 0
					v.drawScaled(x, y, scale, patch, flags)
				end
			else
				v.drawString(288, 70+y, "AFK", 0, "small-thin")
			end
			if player == server
				v.drawString(280, 68+y, "\x82~", V_ALLOWLOWERCASE, "left")
			elseif IsPlayerAdmin(player)
				v.drawString(280, 68+y, "\x82@", V_ALLOWLOWERCASE, "left")
			end
			local patch = v.getSpritePatch(SPR_FLII, 3, 0)
			v.drawScaled(261*FRACUNIT, (99+y)*FRACUNIT, FRACUNIT/2, patch, 0)
			v.drawFill(272, 69+y, 4, 6, 0)
			v.drawString(272, 70+y, "\x8F...", 0, "small-thin")
			if player.cantspeak
				v.drawScaled(270*FRACUNIT, (68+y)*FRACUNIT, FRACUNIT/3, v.cachePatch("NONICON"), 0)
			end
			if G_GametypeUsesLives() == true
				v.drawString(8, 70+y, player.lives, V_ALLOWLOWERCASE, "thin-center")
			elseif G_GametypeHasTeams() == true
				local team = ""
				if player.ctfteam == 0
					team = "\x86".."spec"
				elseif player.ctfteam == 1
					team = "\x85".."red"
				elseif player.ctfteam == 2
					team = "\x84".."blue"
				end
				v.drawString(8, 70+y, team, 0, "small-center")
			elseif G_TagGametype() == true
				if (player.pflags & PF_TAGIT)
					v.drawScaled(3*FRACUNIT, (66+y)*FRACUNIT, FRACUNIT/3, v.cachePatch("TAGICO"), 0)
				end
			end
			v.drawString(128, 70+y, player.score, V_ALLOWLOWERCASE, "small")
			if G_PlatformGametype()
				if player.LC_timefinished == nil
					v.drawString(180, 70+y, "-:--.--", V_ALLOWLOWERCASE, "small")
				else
					local centis = tostring(G_TicsToCentiseconds(player.LC_timefinished))
					if centis:len() == 1 then centis = "0"..centis end
					local seconds = tostring(G_TicsToSeconds(player.LC_timefinished))
					if seconds:len() == 1 then seconds = "0"..seconds end
					local minutes = tostring(G_TicsToMinutes(player.LC_timefinished, true))
					if minutes:len() == 1 then minutes = "0"..minutes end
					local LC_timefinished = minutes..":"..seconds.."."..centis
					v.drawString(180, 70+y, LC_timefinished, V_ALLOWLOWERCASE, "small")
				end
			elseif G_RingSlingerGametype()
				v.drawString(182, 70+y, player.LC_kills, V_ALLOWLOWERCASE, "small")
				v.drawString(204, 70+y, player.LC_deaths, V_ALLOWLOWERCASE, "small")
			end
			local seconds = tostring(G_TicsToSeconds(player.jointime))
			if seconds:len() == 1 then seconds = "0"..seconds end
			local minutes = tostring(G_TicsToMinutes(player.jointime, false))
			if minutes:len() == 1 then minutes = "0"..minutes end
			local hours = tostring(G_TicsToHours(player.jointime))
			local jointime = hours..":"..minutes..":"..seconds
			v.drawString(224, 68+y, jointime, V_ALLOWLOWERCASE, "small")
			if player.LC_timeplayed
				local minutes = tostring(player.LC_timeplayed.minutes)
				if minutes:len() == 1 then minutes = "0"..minutes end
				local seconds = tostring(player.LC_timeplayed.seconds)
				if seconds:len() == 1 then seconds = "0"..seconds end
				local LC_timeplayed = player.LC_timeplayed.hours..":"..minutes..":"..seconds
				v.drawString(224, 72+y, LC_timeplayed, V_ALLOWLOWERCASE, "small")
			end
			if AltScores.nav.y == i
				for pal = 1, #animated_select do
					if (leveltime % #animated_select+1) == pal
						v.drawFill(1, 64+y, 318, 1, animated_select[pal])
						v.drawFill(1, 79+y, 318, 1, animated_select[pal])
						v.drawFill(1, 64+y, 1, 16, animated_select[pal])
						v.drawFill(318, 64+y, 1, 16, animated_select[pal])
					end
				end
			else
				v.drawFill(1, 64+y, 318, 1, 16)
				v.drawFill(1, 79+y, 318, 1, 24)
			end
			y = $ + 16
		end
		if not AltScores.selected
			firstaction = 1
			firstarg = 1
		elseif AltScores.selected
			local x = 112
			local y = 72+(16*(AltScores.nav.y-(firstplayer)))
			local w = 96
			local h = 48
			local pal = 158
			local shadpal = 254
			local action = AltScores.action
			if y+h > 200 then y = $ - h end
			v.drawFill(x+2, y+2, w, h, shadpal)
			v.drawFill(x, y, w, h, pal)
			v.drawFill(x, y, w, 4, 159)
			if (leveltime % 15) == 1
				firstletter = $ + 1
			end
			if action.index == 0
				if li != action.nav
					firstletter = 1
					li = action.nav
				end
				firstarg = 1
				local str_actions = LC.functions.getStringLanguage("LC_ALTGI_ACTIONS")
				LC.functions.drawString(v, x+w, y, "\x82"..str_actions, V_ALLOWLOWERCASE, "small-right")
				AltScores.action.table = {}
				local actions = AltScores.action.table
				for i = 1, #LC.GIT_Actions do
					if LC.GIT_Actions[i].conditions(AltScores.selected)
						table.insert(actions, LC.GIT_Actions[i])
					end
				end
				
				local y_arrow = 40
				if (leveltime % 8) > 4 then y_arrow = 41 end
				if action.nav != 1
					v.drawString(x+w, y+y_arrow, "\x82"..string.char(26), V_ALLOWLOWERCASE, "thin")
				end
				if action.nav != #actions
					v.drawString(x+w, y+y_arrow, "\x82"..string.char(27), V_ALLOWLOWERCASE, "thin")
				end
				
				if actions[1] and #actions > 10
					if action.nav < firstaction
						firstaction = $ - 1
					elseif action.nav > firstaction+8
						firstaction = $ + 1
					end
					if firstaction+9 > #actions then firstaction = $ - 1 end
					if action.nav == 2 then firstaction = 1 end
				end
				
				local y_actions = 4
				for i = firstaction, firstaction+9 do
					if not actions[i] break end
					local act = actions[i]
					if (i % 2) == 1
						v.drawFill(x, y+y_actions, w, 4, 139)
					else
						v.drawFill(x, y+y_actions, w, 4, 138)
					end
					local actname = LC.functions.getStringLanguage(act.name)
					if act.args and #act.args != 0
						actname = actname.."..."
					end
					/*
					local an_width = v.stringWidth(actname, V_ALLOWLOWERCASE, "small")
					if action.nav == i
						local an_cut = actname
						if an_width > w
							an_cut = an_cut:sub(firstletter)
							an_width = v.stringWidth(an_cut, V_ALLOWLOWERCASE, "small")
						end
						while an_width > w do
							an_cut = an_cut:sub(firstletter, an_cut:len()-1)
							an_width = v.stringWidth(an_cut, V_ALLOWLOWERCASE, "small")
						end
						if firstletter > actname:len()-24 then firstletter = 1 end
						v.drawString(x+2, y+y_actions, "\x82"..an_cut, V_ALLOWLOWERCASE, "small")
					else
						while an_width > w-8 do
							actname = actname:sub(1, actname:len()-1)
							an_width = v.stringWidth(actname, V_ALLOWLOWERCASE, "small")
						end
						if v.stringWidth(act.name, V_ALLOWLOWERCASE, "small") > w-8 then actname = actname.."..." end
						v.drawString(x+2, y+y_actions, actname, V_ALLOWLOWERCASE, "small")
					end
					*/
					if action.nav == i then actname = "\x82"..actname end
					LC.functions.drawString(v, x+2, y+y_actions, actname, V_ALLOWLOWERCASE, "small", w)
					y_actions = $ + 4
				end
				
				if action.nav > #actions then action.nav = #actions end
			else
				local act = action.table[action.index]
				LC.functions.drawString(v, x+w, y, "\x82"..LC.functions.getStringLanguage(act.name), V_ALLOWLOWERCASE, "small-right")
				local Ay = y+4
				local y_arrow = 40
				if (leveltime % 8) > 4 then y_arrow = 41 end
				if action.nav != 1
					v.drawString(x+w, y+y_arrow, "\x82"..string.char(26), V_ALLOWLOWERCASE, "thin")
				end
				if action.nav != #action.args+1
					v.drawString(x+w, y+y_arrow, "\x82"..string.char(27), V_ALLOWLOWERCASE, "thin")
				end
				
				
				if act.args[1] and #act.args > 4
					if action.nav < firstarg
						firstarg = $ - 1
					elseif action.nav > firstarg+3
						firstarg = $ + 1
					end
					if firstarg+3 > #act.args then firstarg = $ - 1 end
					if action.nav == 2 then firstarg = 1 end
				end
				
				local y_arg = 4
				for i = firstarg, firstarg+3 do
					if not act.args[i] then break end
					local arg = act.args[i]
					if arg.type == "text" or arg.type == "count" or arg.type == "float"
						v.drawFill(x+2, Ay+4, w-4, 6, 254)
						if action.args[i] == nil
							action.args[i] = ""
						end
						local header = arg.header
						if arg.optional != false then header = header.." (Optional)" end
						if action.nav == i
							v.drawString(x+2, Ay, "\x82"..header, V_ALLOWLOWERCASE, "small") 
							if arg.colored == true and arg.type == "text"
								v.drawFill(x+106, y+2, w, h-16, shadpal)
								v.drawFill(x+104, y, w, h-16, pal)
								v.drawFill(x+104, y, w, 4, 159)
								v.drawString(x+w+104, y, "\x82 Colored", V_ALLOWLOWERCASE, "small-right")
								
								v.drawFill(x+107+(5*action.textcolor), y+7, 6, 6, 83)
								for i = 1, #LC.colormaps do
									v.drawFill(x+108+(i*5), y+8, 4, 4, textcolors[i])
									v.drawString(x+110+(i*5), y+8, LC.colormaps[i].hex..LC.colormaps[i].name:sub(1,1), 0, "small-center")
								end
								if (leveltime % 8) > 3
									v.drawString(x+108+(w/2), y+20, "\x82"..string.char(28).." "..LC.colormaps[action.textcolor].name.." "..string.char(29), V_ALLOWLOWERCASE, "thin-center")
								else
									v.drawString(x+108+(w/2), y+20, "\x82"..string.char(28)..LC.colormaps[action.textcolor].name..string.char(29), V_ALLOWLOWERCASE, "thin-center")
								end
							end
						else
							v.drawString(x+2, Ay, header, V_ALLOWLOWERCASE, "small")
						end
						local text = action.args[i]
						local Width = v.stringWidth(text, V_ALLOWLOWERCASE, "small")
						while true do
							if Width > w-14
								text = text:sub(2)
								Width = v.stringWidth(text, V_ALLOWLOWERCASE, "small")
							else
								if action.args[i] != text
									text = "..."..text
								end
								break
							end
						end
							//text = "..."..text:sub(text:len()-(19+colors))
						if action.nav == i and (leveltime % 8) == 4
							v.drawString(x+2, Ay+5, text.."_", V_ALLOWLOWERCASE, "small")
						else
							v.drawString(x+2, Ay+5, text, V_ALLOWLOWERCASE, "small")
						end
						Ay = $ + 10
					elseif LC.GIT_ArgTypes[arg.type]
						local header = arg.header
						if arg.optional != false then header = header.." ("..LC.functions.getStringLanguage("LC_OPTIONAL")..")" end
						if action.nav == i
							LC.functions.drawString(v, x+2, Ay, "\x82"..header, V_ALLOWLOWERCASE, "small")
						else
							LC.functions.drawString(v, x+2, Ay, header, V_ALLOWLOWERCASE, "small")
						end
						
						local cfg = LC.GIT_ArgTypes[arg.type]
						if action.args[i] == nil then
							action.args[i] = cfg.setvalue(AltScores.selected)
						end
						
						local hud_table = {v = v, player = player, camera = camera}
						local args_table = {x = x, y = Ay, value = action.args[i], selected = (action.nav == i)}
						cfg.output(hud_table, args_table)
					end
					y_arg = $ + 8
				end
				local c_str = act.confirm
				if not c_str then c_str = LC.functions.getStringLanguage("LC_CONFIRM") end
				if action.errortext
					v.drawString(x, y+h-4, "\x85"..action.errortext, V_ALLOWLOWERCASE, "small-thin")
				end
				if action.nav == #act.args+1
					LC.functions.drawString(v, x+w, y+h-4, "\x82"..c_str, V_ALLOWLOWERCASE, "small-right")
				else
					LC.functions.drawString(v, x+w, y+h-4, c_str, V_ALLOWLOWERCASE, "small-right")
				end
				if not act.conditions(AltScores.selected)
					action.index = 0
				end
			end
		end
		if AltScores.popupmsg.str
			local Width = (v.nameTagWidth(AltScores.popupmsg.str)*AltScores.popupmsg.scale)/2
			v.drawScaledNameTag((160*FU)-Width, (100*FU)+AltScores.popupmsg.y, AltScores.popupmsg.str, AltScores.popupmsg.flags, AltScores.popupmsg.scale, SKINCOLOR_YELLOW, SKINCOLOR_BLACK)
			AltScores.popupmsg.y = $ - FU
			AltScores.popupmsg.scale = $ + (FU/128)
			if (leveltime % 10) == 4
			and AltScores.popupmsg.flags != 0
				for i = 1, #popupflags do
					if AltScores.popupmsg.flags == popupflags[i]
						if popupflags[i+1]
							AltScores.popupmsg.flags = popupflags[i+1]
							break
						else
							AltScores.popupmsg.str = nil
							AltScores.popupmsg.y = 0
							AltScores.popupmsg.flags = 0
							AltScores.popupmsg.scale = FU/4
							break
						end
					end
				end
			elseif AltScores.popupmsg.flags == 0
				AltScores.popupmsg.flags = popupflags[1]
			end
		end
	end
}


table.insert(LC_Loaderdata["hook"], hooktable)

return true
