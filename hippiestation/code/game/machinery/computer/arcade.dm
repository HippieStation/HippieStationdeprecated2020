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
	var/mine_limit
	var/mine_percent
	var/mine_placed
	var/mine_remaining
	var/safe_squares_revealed
	var/win_condition
	var/x1	//Using x and y are already variables assigned to where the item is placed. Changing them changes where the machines is... lul
	var/y1
	var/rows = 1
	var/columns = 1

/obj/machinery/computer/arcade/minesweeper/interact(mob/user)
	var/web_difficulty_menu = "<font size='2'> Reveal all the squares without hitting a mine!<br>What difficulty do you want to play?<br><br><br><b><a href='byond://?src=[REF(src)];Easy=1'>Easy (9x9 board, 10 mines)</a><br><a href='byond://?src=[REF(src)];Intermediate=1'>Intermediate (16x16 board, 40 mines)</a><br><a href='byond://?src=[REF(src)];Hard=1'>Hard (16x30 board, 99 mines)</a><br><a href='byond://?src=[REF(src)];Custom=1'>Custom</a></b><br>"
	var/web = "<head><title>Minesweeper</title></head><body><div align='center'><b>Minesweeper</b><br>"
	var/static_web = "<head><title>Minesweeper</title></head><body><div align='center'><b>Minesweeper</b><br>"	//When we need to revert to the main menu we set web as this

	if(game_status == MINESWEEPER_GAME_MAIN_MENU)
		user << browse(static_web+web_difficulty_menu,"window=minesweeper,size=400x500")
		web = static_web
	else
		user << browse(web,"window=minesweeper,size=400x500")

	..()

/obj/machinery/computer/arcade/minesweeper/Topic(href, href_list)
	if(..())
		return

	var/mob/living/user = usr	//To identify who the hell is using this window, this should also make things like aliens and monkeys able to use the machine!!
	var/web_difficulty_menu = "<font size='2'> Reveal all the squares without hitting a mine!<br>What difficulty do you want to play?<br><br><br><b><a href='byond://?src=[REF(src)];Easy=1'>Easy (9x9 board, 10 mines)</a><br><a href='byond://?src=[REF(src)];Intermediate=1'>Intermediate (16x16 board, 40 mines)</a><br><a href='byond://?src=[REF(src)];Hard=1'>Hard (16x30 board, 99 mines)</a><br><a href='byond://?src=[REF(src)];Custom=1'>Custom</a></b><br>"
	var/web = "<head><title>Minesweeper</title></head><body><div align='center'><b>Minesweeper</b><br>"
	var/static_web = "<head><title>Minesweeper</title></head><body><div align='center'><b>Minesweeper</b><br>"	//When we need to revert to the main menu we set web as this
	area = rows*columns
	mine_remaining = mine_limit
	mine_percent = mine_limit/(area*100)
	mine_placed = 0
	safe_squares_revealed = 0
	web = static_web
	win_condition = area-mine_remaining

	if(href_list["Main_Menu"])
		game_status = MINESWEEPER_GAME_MAIN_MENU
		mine_limit = 0
		rows = 0
		columns = 0
	if(href_list["Easy"])
		game_status = MINESWEEPER_GAME_PLAYING
		difficulty = "Easy"
		rows = 9
		columns = 9
		mine_limit = 10
	if(href_list["Intermediate"])
		game_status = MINESWEEPER_GAME_PLAYING
		difficulty = "Intermediate"
		rows = 16
		columns = 16
		mine_limit = 40
	if(href_list["Hard"])
		game_status = MINESWEEPER_GAME_PLAYING
		difficulty = "Hard"
		rows = 16
		columns = 30
		mine_limit = 99
	if(href_list["Custom"])
		game_status = MINESWEEPER_GAME_PLAYING
		difficulty = "Custom"
		rows = text2num(input(usr, "How many rows do you want?", "Minesweeper Rows"))
		columns = text2num(input(usr, "How many columns do you want?", "Minesweeper Squares"))
		mine_limit = text2num(input(usr, "How many mines do you want?", "Minesweeper Mines"))

	if(game_status == MINESWEEPER_GAME_MAIN_MENU)
		web += web_difficulty_menu

	var/table[rows][columns]	//Make the board boys
	var/cell_list[2]	//To track square value and use booleans
	cell_list[2] = 0

	if(!href_list["same_board"])	//Don't build mines if we want the same board
		for(var/y1=1;y1<=rows;y1++)	//Build mines
			for(var/x1=1;x1<=columns;x1++)
				if(prob(mine_percent) && mine_placed <= mine_limit)
					if((cell_list[1] in table[y1][x1]) < 0)	//If square is already initialised
						cell_list[2] -= 1	//Replace square with mine and continue id generation as normal
						table[y1][x1] = cell_list
						cell_list[2] += 1
					else
						cell_list[1] = 0
						cell_list[2] += 1
						mine_placed += 1
						table[y1][x1] = cell_list
				else if(cell_list[1] < 0)	//If not initialised, set value
					cell_list[1] = 1	//If not mine, assume empty square, for now
					cell_list[2] += 1
					table[y1][x1] = cell_list

	for(var/y1=1;y1<=rows;y1++)
		for(var/x1=1;x1<=columns;x1++)
			var/coordinates
			coordinates = cell_list[2] in table[y1][x1]
			if(href_list["[coordinates]"])	//Create unique hrefs for every square
				if((cell_list[1] in table[y1][x1]) <= 10)	//Check that it's not already revealed
					cell_list[1] in table[y1][x1] += 10

	for(var/y1=1;y1<=rows;y1++)	//Build square values and work revealed empty squares
		for(var/x1=1;x1<=columns;x1++)
			if((cell_list[1] in table[y1][x1]) == 1)	//If empty, look for mines around
				var/square_value = 1
				for(var/y2=y1-1;y2<=y1+2;y2++)
					if(y2 > rows || y2 < 0)
						continue
					for(var/x2=x1-1;x2<=x1+2;x2++)
						if(x2 > columns || x2 < 0)
							continue
						if((cell_list[1] in table[y2][x2]) == 0)
							square_value += 1
				cell_list[1] in table[y1][x1] = square_value
			else if((cell_list[1] in table[y1][x1]) == 11)	//If this is an empty revealed square, check everything around it
				for(var/y2=y1-1;y2<=y1+2;y2++)
					if(y2 > rows || y2 < 0)
						continue
					for(var/x2=x1-1;x2<=x1+2;x2++)
						if(x2 > columns || x2 < 0)
							continue
						if((cell_list[1] in table[y2][x2]) >= 1 && (cell_list[1] in table[y2][x2]) <= 10)	//Don't hit the mine when you're on an empty square ffs
							cell_list[1] in table[y2][x2] += 10	//Reveal this adjacent square pls

	if(href_list["same_board"])
		game_status = MINESWEEPER_GAME_PLAYING
		for(var/y1=1;y1<=rows;y1++)	//Hide all squares since we want the same board
			for(var/x1=1;x1<=columns;x1++)
				if((cell_list[1] in table[y1][x1]) <= 10)	//If revealed, become unrevealed!
					cell_list[1] in table[y1][x1] -= 10

	if(game_status == MINESWEEPER_GAME_PLAYING)
		web += "<table>"	//Start setting up the html table
		web += "<tbody>"
		for(var/y1=1;y1<=rows;y1++)	//Read the table and get the value of the selected square
			web += "<tr>"
			for(x1=1;x1<=columns;x1++)
				switch((cell_list[1] in table[y1][x1]))
					if(10)	//This goes first as we want to check if game is lost before generating hrefs
						if(game_status != MINESWEEPER_GAME_LOST)	//U lost m8
							game_status = MINESWEEPER_GAME_LOST
						web += "<td>MINE</td>"
					if(0 to 9)
						if(game_status != MINESWEEPER_GAME_LOST)	//Can't click a tile if you lost m9
							var/coordinates
							coordinates = cell_list[2] in table[y1][x1]
							web += "<td><a href='byond://?src=[REF(src)];[coordinates]=1'>?</a></td>"	//Make unique hrefs for every square
						else
							web += "<td>?</td>"
					if(11 to 18)
						safe_squares_revealed += 1
						web += "<td>num2text([cell_list[1] in table[y1][x1]])</td>"
			web += "</tr>"
		web += "</table>"
		web += "</tbody>"
		web += "<a href='byond://?src=[REF(src)];Main_Menu=1'>Return to Main Menu</a>"

	if(game_status == MINESWEEPER_GAME_LOST)
		web += "<font size='6'>You have lost!<br><font size='3'>Try again?<br><b><a href='byond://?src=[REF(src)];Easy=1'>Easy (9x9 board, 10 mines)</a><br><a href='byond://?src=[REF(src)];Intermediate=1'>Intermediate (16x16 board, 40 mines)</a><br><a href='byond://?src=[REF(src)];Hard=1'>Hard (16x30 board, 99 mines)</a><br><a href='byond://?src=[REF(src)];Custom=1'>Custom</a><br><a href='byond://?src=[REF(src)];same_board=1'>Play on the same board</a><br><a href='byond://?src=[REF(src)];Main_Menu=1'>Return to Main Menu</a></b><br>"
	if(safe_squares_revealed == win_condition)
		game_status = MINESWEEPER_GAME_WON
		if(game_status == MINESWEEPER_GAME_WON)
			web += "<font size='6'>Congratulations, you have won!<br><font size='3'>Want to play again?<br><b><a href='byond://?src=[REF(src)];Easy=1'>Easy (9x9 board, 10 mines)</a><br><a href='byond://?src=[REF(src)];Intermediate=1'>Intermediate (16x16 board, 40 mines)</a><br><a href='byond://?src=[REF(src)];Hard=1'>Hard (16x30 board, 99 mines)</a><br><a href='byond://?src=[REF(src)];Custom=1'>Custom</a></b><br><a href='byond://?src=[REF(src)];same_board=1'>Play on the same board</a><br><a href='byond://?src=[REF(src)];Main_Menu=1'>Return to Main Menu</a></b><br>"
	web += "</div>"
	if(game_status == MINESWEEPER_GAME_PLAYING)
		web += "<div align='right'>Difficulty: [difficulty]<br>Mines left: [mine_remaining]<br>Rows: [rows]<br>Columns: [columns]</div>"

	add_fingerprint(user)
	user << browse(web,"window=minesweeper,size=400x500")
	return