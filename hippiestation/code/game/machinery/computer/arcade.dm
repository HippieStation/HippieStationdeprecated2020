/obj/machinery/computer/arcade
	prize_override = list(
		/obj/item/storage/box/snappops					= 2,
		/obj/item/toy/talking/AI								= 2,
		/obj/item/toy/talking/codex_gigas						= 2,
		/obj/item/clothing/under/syndicate/tacticool			= 2,
		/obj/item/toy/sword										= 2,
		/obj/item/toy/gun										= 2,
		/obj/item/gun/ballistic/shotgun/toy/crossbow	= 2,
		/obj/item/storage/box/fakesyndiesuit				= 2,
		/obj/item/storage/crayons						= 2,
		/obj/item/toy/spinningtoy								= 2,
		/obj/item/toy/prize/ripley								= 1,
		/obj/item/toy/prize/fireripley							= 1,
		/obj/item/toy/prize/deathripley							= 1,
		/obj/item/toy/prize/gygax								= 1,
		/obj/item/toy/prize/durand								= 1,
		/obj/item/toy/prize/honk								= 1,
		/obj/item/toy/prize/marauder							= 1,
		/obj/item/toy/prize/seraph								= 1,
		/obj/item/toy/prize/mauler								= 1,
		/obj/item/toy/prize/odysseus							= 1,
		/obj/item/toy/prize/phazon								= 1,
		/obj/item/toy/prize/reticence							= 1,
		/obj/item/toy/cards/deck								= 2,
		/obj/item/toy/nuke										= 2,
		/obj/item/toy/minimeteor								= 2,
		/obj/item/toy/redbutton									= 2,
		/obj/item/toy/talking/owl								= 2,
		/obj/item/toy/talking/griffin							= 2,
		/obj/item/coin/antagtoken						= 2,
		/obj/item/stack/tile/fakespace/loaded					= 2,
		/obj/item/stack/tile/fakepit/loaded						= 2,
		/obj/item/toy/toy_xeno									= 2,
		/obj/item/storage/box/actionfigure				= 1,
		/obj/item/restraints/handcuffs/fake              = 2,
		/obj/item/grenade/chem_grenade/glitter/pink		= 1,
		/obj/item/grenade/chem_grenade/glitter/blue		= 1,
		/obj/item/grenade/chem_grenade/glitter/white		= 1,
		/obj/item/toy/eightball									= 2,
		/obj/item/toy/windupToolbox								= 2,
		/obj/item/toy/clockwork_watch							= 2,
		/obj/item/toy/toy_dagger								= 2,
		/obj/item/extendohand/acme								= 1,
		/obj/item/hot_potato/harmless/toy						= 1,
		/obj/item/card/emagfake									= 1,
		/obj/item/clothing/shoes/wheelys				= 2,
		/obj/item/clothing/shoes/kindleKicks				= 2,
		/obj/item/storage/belt/military/snack					= 2,
		/obj/item/toy/plush/goatplushie/angry = 2
		)

#define MINESWEEPER_GAME_MAIN_MENU	0
#define MINESWEEPER_GAME_PLAYING	1
#define MINESWEEPER_GAME_LOST		2
#define MINESWEEPER_GAME_WON		3

/obj/machinery/computer/arcade/minesweeper
	name = "Minesweeper"
	desc = "An arcade machine that generates grids. It seems that the machine sparks and screeches when a grid is generated, as if it cannot cope with the intensity of generating the grid."
	icon_state = "arcade"
	circuit = /obj/item/circuitboard/computer/arcade/minesweeper
	var/area
	var/difficulty = ""	//To show what difficulty you are playing
	var/game_status = MINESWEEPER_GAME_MAIN_MENU
	var/mine_limit = 0
	var/mine_placed = 0
	var/mine_remaining = 0
	var/mine_flagged = 0
	var/mine_sound = TRUE	//So it doesn't get repeated when multiple mines are exposed
	var/randomnumber = 1	//Random emagged game iteration number to be displayed, put here so it is persistent across one individual arcade machine
	var/safe_squares_revealed
	var/saved_web = ""	//To display the web if you click on the arcade
	var/win_condition
	var/rows = 1
	var/columns = 1
	var/table[31][51]	//Make the board boys, 30x50 board


/obj/machinery/computer/arcade/minesweeper/interact(mob/user)
	var/web_difficulty_menu = "<font size='2'> Reveal all the squares without hitting a mine!<br>What difficulty do you want to play?<br><br><br><b><a href='byond://?src=[REF(src)];Easy=1'>Easy (9x9 board, 10 mines)</a><br><a href='byond://?src=[REF(src)];Intermediate=1'>Intermediate (16x16 board, 40 mines)</a><br><a href='byond://?src=[REF(src)];Hard=1'>Hard (16x30 board, 99 mines)</a><br><a href='byond://?src=[REF(src)];Custom=1'>Custom</a></b><br>"
	var/static_web = "<head><title>Minesweeper</title></head><body><div align='center'><b>Minesweeper</b><br>"	//When we need to revert to the main menu we set web as this
	var/static_emagged_web = "<head><title>Minesweeper</title></head><body><div align='center'><b>Minesweeper <span class='warning'>EXTREME EDITION</span>: Iteration #[randomnumber]</b><br>"
	var/emagged_web_difficulty_menu = "<font size='2'>Explode in the game, explode in real life!<br>What difficulty do you want to play?<br><br><br><b><a href='byond://?src=[REF(src)];Easy=1'>Easy (9x9 board, 10 mines)</a><br><a href='byond://?src=[REF(src)];Intermediate=1'>Intermediate (16x16 board, 40 mines)</a><br><a href='byond://?src=[REF(src)];Hard=1'>Hard (16x30 board, 99 mines)</a><br><a href='byond://?src=[REF(src)];Custom=1'>Custom</a></b><br>"

	if(game_status == MINESWEEPER_GAME_MAIN_MENU)
		if(obj_flags & EMAGGED)
			playsound(loc, 'hippiestation/sound/arcade/minesweeper_emag2.ogg', 50, 0, extrarange = -3, falloff = 10)
			user << browse(static_emagged_web+emagged_web_difficulty_menu,"window=minesweeper,size=400x500")
		else
			playsound(loc, 'hippiestation/sound/arcade/minesweeper_startup.ogg', 50, 0, extrarange = -3, falloff = 10)
			user << browse(static_web+web_difficulty_menu,"window=minesweeper,size=400x500")
	else
		playsound(loc, 'hippiestation/sound/arcade/minesweeper_boardpress.ogg', 50, 0, extrarange = -3, falloff = 10)
		user << browse(saved_web,"window=minesweeper,size=400x500")
	if(obj_flags & EMAGGED)
		do_sparks(5, 1, src)

	..()

/obj/machinery/computer/arcade/minesweeper/Topic(href, href_list)
	if(..())
		return

	var/exploding_hell = FALSE	//For emagged failures
	var/reset_board = FALSE
	var/mob/living/user = usr	//To identify who the hell is using this window, this should also make things like aliens and monkeys able to use the machine!!
	var/web_difficulty_menu = "<font size='2'> Reveal all the squares without hitting a mine!<br>What difficulty do you want to play?<br><br><br><b><a href='byond://?src=[REF(src)];Easy=1'>Easy (9x9 board, 10 mines)</a><br><a href='byond://?src=[REF(src)];Intermediate=1'>Intermediate (16x16 board, 40 mines)</a><br><a href='byond://?src=[REF(src)];Hard=1'>Hard (16x30 board, 99 mines)</a><br><a href='byond://?src=[REF(src)];Custom=1'>Custom</a></b><br>"
	var/web = "<head><title>Minesweeper</title></head><body><div align='center'><b>Minesweeper</b><br>"
	var/static_web = "<head><title>Minesweeper</title></head><body><div align='center'><b>Minesweeper</b><br>"	//When we need to revert to the main menu we set web as this
	web = static_web

	if(obj_flags & EMAGGED)
		web = "<head><title>Minesweeper</title></head><body><div align='center'><b>Minesweeper <span class='warning'>EXTREME EDITION</span>: Iteration #[randomnumber]</b><br>"
		do_sparks(5, 1, src)

	if(href_list["Main_Menu"])
		game_status = MINESWEEPER_GAME_MAIN_MENU
		mine_limit = 0
		rows = 0
		columns = 0
		mine_placed = 0
	if(href_list["Easy"])
		playsound(loc, 'hippiestation/sound/arcade/minesweeper_menuselect.ogg', 50, 0, extrarange = -3, falloff = 10)
		game_status = MINESWEEPER_GAME_PLAYING
		reset_board = TRUE
		difficulty = "Easy"
		rows = 10	//9x9 board
		columns = 10
		mine_limit = 10
	if(href_list["Intermediate"])
		playsound(loc, 'hippiestation/sound/arcade/minesweeper_menuselect.ogg', 50, 0, extrarange = -3, falloff = 10)
		game_status = MINESWEEPER_GAME_PLAYING
		reset_board = TRUE
		difficulty = "Intermediate"
		rows = 17	//16x16 board
		columns = 17
		mine_limit = 40
	if(href_list["Hard"])
		playsound(loc, 'hippiestation/sound/arcade/minesweeper_menuselect.ogg', 50, 0, extrarange = -3, falloff = 10)
		game_status = MINESWEEPER_GAME_PLAYING
		reset_board = TRUE
		difficulty = "Hard"
		rows = 17	//16x30 board
		columns = 31
		mine_limit = 99
	if(href_list["Custom"])
		playsound(loc, 'hippiestation/sound/arcade/minesweeper_menuselect.ogg', 50, 0, extrarange = -3, falloff = 10)
		game_status = MINESWEEPER_GAME_PLAYING
		reset_board = TRUE
		difficulty = "Custom"
		rows = text2num(input(usr, "How many rows do you want? (Maximum of 30 allowed)", "Minesweeper Rows"))+1	//+1 as dm arrays start at 1
		columns = text2num(input(usr, "How many columns do you want? (Maximum of 50 allowed)", "Minesweeper Squares"))+1	//+1 as dm arrays start at 1
		var/grid_area = (rows-1)*(columns-1)
		mine_limit = text2num(input(usr, "How many mines do you want? (Maximum of [round(grid_area*0.9)] allowed)", "Minesweeper Mines"))
		playsound(loc, 'hippiestation/sound/arcade/minesweeper_menuselect.ogg', 50, 0, extrarange = -3, falloff = 10)
		custom_generation()

	if(game_status == MINESWEEPER_GAME_MAIN_MENU)
		if(obj_flags & EMAGGED)
			playsound(loc, 'hippiestation/sound/arcade/minesweeper_emag2.ogg', 50, 0, extrarange = -3, falloff = 10)
			web += "<font size='2'>Explode in the game, explode in real life!<br>What difficulty do you want to play?<br><br><br><b><a href='byond://?src=[REF(src)];Easy=1'>Easy (9x9 board, 10 mines)</a><br><a href='byond://?src=[REF(src)];Intermediate=1'>Intermediate (16x16 board, 40 mines)</a><br><a href='byond://?src=[REF(src)];Hard=1'>Hard (16x30 board, 99 mines)</a><br><a href='byond://?src=[REF(src)];Custom=1'>Custom</a></b><br>"
		else
			playsound(loc, 'hippiestation/sound/arcade/minesweeper_startup.ogg', 50, 0, extrarange = -3, falloff = 10)
			web += web_difficulty_menu

	area = (rows-1)*(columns-1)
	safe_squares_revealed = 0

	for(var/y1=1;y1<rows;y1++)	//Board resetting and mine building
		for(var/x1=1;x1<columns;x1++)
			if(reset_board)
				table[y1][x1] = null	//Uninitialise everything
				mine_placed = 0
			if(table[y1][x1] == null)	//If not initialised yet
				table[y1][x1] = 1	//If not mine, assume empty square, for now
	reset_board = FALSE
	make_mines()	//Multiple passes until we reach the mine limit

	for(var/y1=1;y1<rows;y1++)	//Board resetting and href checking
		for(var/x1=1;x1<columns;x1++)
			var/coordinates
			coordinates = (y1*100)+x1
			if(href_list["[coordinates]"])	//Create unique hrefs for every square
				playsound(loc, 'hippiestation/sound/arcade/minesweeper_boardpress.ogg', 50, 0, extrarange = -3, falloff = 10)
				if(table[y1][x1] < 10)	//Check that it's not already revealed
					table[y1][x1] += 10
			if(href_list["same_board"])	//Reset the board... kinda
				game_status = MINESWEEPER_GAME_PLAYING
				if(table[y1][x1] >= 10)	//If revealed, become unrevealed!
					table[y1][x1] -= 10
			if(table[y1][x1] == 10)	//Mine check, done here so no hrefs are made again
				if(game_status != MINESWEEPER_GAME_LOST && game_status != MINESWEEPER_GAME_WON)
					game_status = MINESWEEPER_GAME_LOST
					if(obj_flags & EMAGGED)
						exploding_hell  = TRUE
					if(mine_sound)
						switch(rand(1,3))	//Play every time a mine is hit
							if(1)
								playsound(loc, 'hippiestation/sound/arcade/minesweeper_explosion1.ogg', 50, 0, extrarange = -3, falloff = 10)
							if(2)
								playsound(loc, 'hippiestation/sound/arcade/minesweeper_explosion2.ogg', 50, 0, extrarange = -3, falloff = 10)
							if(3)
								playsound(loc, 'hippiestation/sound/arcade/minesweeper_explosion3.ogg', 50, 0, extrarange = -3, falloff = 10)
						mine_sound = FALSE
					if(exploding_hell)
						to_chat(user, "<span class='warning'><font size='3'><b>You feel a great sense of dread wash over you. You feel as if you just unleashed armageddon upon yourself!</b></span>")
						var/row_limit = rows
						var/column_limit = columns
						var/mine_limit_v2 = mine_limit
						if(rows > 10)
							row_limit = 10
						if(columns > 10)
							column_limit = 10
						if(mine_limit > (rows*columns)/3.4)
							mine_limit_v2 = 33
						message_admins("[key_name_admin(user)] failed Minesweeper and has unleashed an explosion armageddon of size [row_limit],[column_limit] around [user.loc]!")
						explosion(src.loc,1,rand(1,2),rand(1,5),rand(1,10), adminlog = FALSE)
						for(var/y69=y-row_limit;y69<y+row_limit;y69++)	//Create a shitton of explosions in irl turfs if we lose, it will probably kill us
							for(var/x69=x-column_limit;x69<x+column_limit;x69++)
								if(prob(mine_limit_v2))	//Probability of explosion happening, according to how many mines were on the board... up to a limit
									var/explosionloc
									explosionloc = locate(y69,x69,z)
									explosion(explosionloc, ,rand(1,2),rand(1,5),rand(1,10), adminlog = FALSE)
			var/y2 = y1
			var/x2 = x1
			work_squares(y2, x2)	//Work squares while in this loop so there's less load
			if(table[y1][x1] >= 11)	//Score tracking
				safe_squares_revealed += 1

	mine_sound = TRUE
	mine_remaining = mine_placed-mine_flagged
	win_condition = area-mine_remaining

	if(safe_squares_revealed == win_condition && game_status == MINESWEEPER_GAME_PLAYING)
		game_status = MINESWEEPER_GAME_WON

	if(!game_status == MINESWEEPER_GAME_MAIN_MENU)
		web += "<table>"	//Start setting up the html table
		web += "<tbody>"
		for(var/y1=1;y1<rows;y1++)	//Read the table and get the value of the selected square
			web += "<tr>"
			for(var/x1=1;x1<columns;x1++)
				var/coordinates
				coordinates = (y1*100)+x1
				switch(table[y1][x1])
					if(0)
						if(game_status == MINESWEEPER_GAME_LOST)
							web += "<td>M</td>"
						else
							web += "<td><a href='byond://?src=[REF(src)];[coordinates]=1'>?</a></td>"	//Make unique hrefs for every square
					if(1 to 9)
						if(game_status == MINESWEEPER_GAME_PLAYING)	//Can't click a tile if you lost or won m9
							web += "<td><a href='byond://?src=[REF(src)];[coordinates]=1'>?</a></td>"	//Make unique hrefs for every square
						else
							web += "<td>?</td>"
					if(10)
						web += "<td>M</td>"
					if(11)
						web += "<td>0</td>"
					if(12 to 18)
						var/square_value
						square_value = table[y1][x1]
						web += "<td>[square_value-11]</td>"
			web += "</tr>"
		web += "</table>"
		web += "</tbody>"
	web += "<br>"

	if(game_status == MINESWEEPER_GAME_LOST)
		web += "<font size='6'>You have lost!<br><font size='3'>Try again?<br><b><a href='byond://?src=[REF(src)];Easy=1'>Easy (9x9 board, 10 mines)</a><br><a href='byond://?src=[REF(src)];Intermediate=1'>Intermediate (16x16 board, 40 mines)</a><br><a href='byond://?src=[REF(src)];Hard=1'>Hard (16x30 board, 99 mines)</a><br><a href='byond://?src=[REF(src)];Custom=1'>Custom</a><br><a href='byond://?src=[REF(src)];same_board=1'>Play on the same board</a><br><a href='byond://?src=[REF(src)];Main_Menu=1'>Return to Main Menu</a></b><br>"

	if(game_status == MINESWEEPER_GAME_WON)
		if(rows < 10 && columns < 10)	//If less than easy difficulty
			playsound(loc, 'hippiestation/sound/arcade/minesweeper_winfail.ogg', 50, 0, extrarange = -3, falloff = 10)
			say("You cleared the board of all mines, but you picked too small of a board! Try again with at least a 9x9 board!")
			web += "<font size='4'>You won, but your board was too small! Pick a bigger board next time!<br><font size='3'>Want to play again?<br><b><a href='byond://?src=[REF(src)];Easy=1'>Easy (9x9 board, 10 mines)</a><br><a href='byond://?src=[REF(src)];Intermediate=1'>Intermediate (16x16 board, 40 mines)</a><br><a href='byond://?src=[REF(src)];Hard=1'>Hard (16x30 board, 99 mines)</a><br><a href='byond://?src=[REF(src)];Custom=1'>Custom</a></b><br><a href='byond://?src=[REF(src)];same_board=1'>Play on the same board</a><br><a href='byond://?src=[REF(src)];Main_Menu=1'>Return to Main Menu</a></b><br>"
		else
			playsound(loc, 'hippiestation/sound/arcade/minesweeper_win.ogg', 50, 0, extrarange = -3, falloff = 10)
			say("You cleared the board of all mines! Congratulations!")
			if(obj_flags & EMAGGED)
				switch(rand(1,3))
					if(1)
						new /obj/item/sbeacondrop/bomb(loc)
						log_game("[key_name(usr)] won Minesweeper and got a syndicate bomb!")
					if(2)
						new /obj/item/gun/ballistic/rocketlauncher
						new /obj/item/ammo_box/magazine/rocket/hedp
						log_game("[key_name(usr)] won Minesweeper and got a rocket launcher!")
					if(3)
						new /obj/item/storage/backpack/duffelbag/syndie/c4
						new /obj/item/storage/backpack/duffelbag/syndie/x4
						log_game("[key_name(usr)] won Minesweeper and got a ton of C4!")
			else
				prizevend(user)
			web += "<font size='6'>Congratulations, you have won!<br><font size='3'>Want to play again?<br><b><a href='byond://?src=[REF(src)];Easy=1'>Easy (9x9 board, 10 mines)</a><br><a href='byond://?src=[REF(src)];Intermediate=1'>Intermediate (16x16 board, 40 mines)</a><br><a href='byond://?src=[REF(src)];Hard=1'>Hard (16x30 board, 99 mines)</a><br><a href='byond://?src=[REF(src)];Custom=1'>Custom</a></b><br><a href='byond://?src=[REF(src)];same_board=1'>Play on the same board</a><br><a href='byond://?src=[REF(src)];Main_Menu=1'>Return to Main Menu</a></b><br>"

	if(game_status == MINESWEEPER_GAME_PLAYING)
		web += "<a href='byond://?src=[REF(src)];Main_Menu=1'>Return to Main Menu</a>"
		web += "<div align='right'>Difficulty: [difficulty]<br>Mines left: [mine_remaining]<br>Rows: [rows-1]<br>Columns: [columns-1]</div>"

	web += "</div>"

	saved_web = web

	add_fingerprint(user)
	user << browse(web,"window=minesweeper,size=400x500")
	return

/obj/machinery/computer/arcade/minesweeper/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	to_chat(user, "<span class='warning'>An ominous tune plays from the arcade's speakers!</span>")
	desc = "An arcade machine that generates grids. It's clunking and sparking everywhere, almost as if threatening to explode at any moment!"
	playsound(user, 'hippiestation/sound/arcade/minesweeper_emag1.ogg', 100, 0, extrarange = -3, falloff = 10)
	do_sparks(5, 1, src)
	randomnumber = rand(1,269)
	obj_flags |= EMAGGED

/obj/machinery/computer/arcade/minesweeper/proc/custom_generation()
	if(rows < 4)
		rows = text2num(input(usr, "You must put at least 4 rows! Pick a higher amount of rows", "Minesweeper Rows"))+1	//+1 as dm arrays start at 1
		playsound(loc, 'hippiestation/sound/arcade/minesweeper_menuselect.ogg', 50, 0, extrarange = -3, falloff = 10)
		custom_generation()
	if(columns < 4)
		columns = text2num(input(usr, "You must put at least 4 columns! Pick a higher amount of columns", "Minesweeper Columns"))+1	//+1 as dm arrays start at 1
		playsound(loc, 'hippiestation/sound/arcade/minesweeper_menuselect.ogg', 50, 0, extrarange = -3, falloff = 10)
		custom_generation()
	if(rows > 31)
		rows = text2num(input(usr, "A maximum of 30 rows are allowed! Pick a lower amount of rows", "Minesweeper Rows"))+1	//+1 as dm arrays start at 1
		playsound(loc, 'hippiestation/sound/arcade/minesweeper_menuselect.ogg', 50, 0, extrarange = -3, falloff = 10)
		custom_generation()
	if(columns > 51)
		columns = text2num(input(usr, "A maximum of 50 columns are allowed! Pick a lower amount of columns", "Minesweeper Columns"))+1//+1 as dm arrays start at 1
		playsound(loc, 'hippiestation/sound/arcade/minesweeper_menuselect.ogg', 50, 0, extrarange = -3, falloff = 10)
		custom_generation()
	var/grid_area = (rows-1)*(columns-1)	//Need a live update of this, won't update if we use the area var in topic
	if(mine_limit > round(grid_area*0.9))
		mine_limit = text2num(input(usr, "You can only put in [round(grid_area*0.9)] mines on this board! Pick a lower amount of mines to insert", "Minesweeper Mines"))
		playsound(loc, 'hippiestation/sound/arcade/minesweeper_menuselect.ogg', 50, 0, extrarange = -3, falloff = 10)
		custom_generation()
	if(mine_limit < round(grid_area/6.4))	//Same mine density as intermediate difficulty
		mine_limit = text2num(input(usr, "You must at least put [round(grid_area/6.4)] mines on this board! Pick a higher amount of mines to insert", "Minesweeper Mines"))
		playsound(loc, 'hippiestation/sound/arcade/minesweeper_menuselect.ogg', 50, 0, extrarange = -3, falloff = 10)
		custom_generation()

/obj/machinery/computer/arcade/minesweeper/proc/make_mines()
	if(mine_placed < mine_limit)
		for(var/y1=1;y1<rows;y1++)	//Board resetting and mine building
			for(var/x1=1;x1<columns;x1++)
				if(prob(area/mine_limit) && mine_placed < mine_limit)
					table[y1][x1] = 0
					mine_placed += 1
		make_mines()	//In case the first pass doesn't generate enough mines

/obj/machinery/computer/arcade/minesweeper/proc/work_squares(var/y2, var/x2, var/y3, var/x3)
	if(y3 > 0 && x3 > 0)
		y2 = y3
		x2 = x3
	if(table[y2][x2] == 1)
		for(y3=y2-1;y3<y2+2;y3++)
			if(y3 > rows || y3 < 1)
				continue
			for(x3=x2-1;x3<x2+2;x3++)
				if(x3 > columns || x3 < 1)
					continue
				if(table[y3][x3] == 0)
					table[y2][x2] += 1
	if(table[y2][x2] == 11)
		for(y3=y2-1;y3<y2+2;y3++)
			if(y3 > rows || y3 < 1)
				continue
			for(x3=x2-1;x3<x2+2;x3++)
				if(x3 > columns || x3 < 1)
					continue
				if(table[y3][x3] > 0 && table[y3][x3] < 10)
					table[y3][x3] += 10
					work_squares(y3, x3)	//Refresh so we check everything we might be missing