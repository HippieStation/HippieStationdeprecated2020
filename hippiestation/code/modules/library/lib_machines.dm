/obj/machinery/libraryscanner
	icon_hippie = 'hippiestation/icons/obj/library.dmi'

/obj/machinery/bookbinder
	icon_hippie = 'hippiestation/icons/obj/library.dmi'

/obj/item/inkcartridge
	name = "Spacestar-brand Ink cartridge"
	desc = "Compatible with Spacestar Ordering Book Catalogs, like the one in the library!"
	icon = 'hippiestation/icons/obj/library.dmi'
	icon_state = "inkcartridge"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/inkcartridge/Initialize()
	. = ..()
	pixel_y = rand(-8, 8)
	pixel_x = rand(-9, 9)

/obj/machinery/computer/craftingbookcatalog
	name = "Spacestar Ordering Book Catalog"
	desc = "A console from the secretive Spacestar conglomerate. Allows users to print books from the Spacestar Knowledge Hub, which contains only the <i>most useful</i> information."
	icon = 'hippiestation/icons/obj/computer.dmi'
	icon_state = "hell"
	icon_screen = "satan"
	icon_keyboard = null
	pixel_x = 3
	pixel_y = 10
	anchored = TRUE
	density = TRUE
	opacity = 0
	resistance_flags = FLAMMABLE
	max_integrity = 200
	armor = list("melee" = 20, "bullet" = 20, "laser" = 20, "energy" = 20, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 20)
	circuit = /obj/item/circuitboard/computer/craftingbookcatalog
	var/thankyou = 0
	var/isprinting = FALSE
	var/state = 1
	var/ink = 1
	var/corpchoice
	var/bookrank
	var/book
	var/inkcost = 0
	var/corporations = list("Nanotrasen Approved Books", "Syndicate nonsense books", "Wizard Federation drivel", "Exit")
	var/ranklist = list("Primary","Standard","Mini","Exit")
	//
	var/booklistNTprimary = list()
	var/booklistNTstandard = list()
	var/booklistNTmini = list()
	//
	var/booklistSynprimary = list()
	var/booklistSynstandard = list("2u - USSR-3 Public Disturbance Manual","2u - Anarchist's Compendium",)
	var/booklistSynmini = list()
	//
	var/booklistWizprimary = list("3.5u - M'`nt a'd B,`'e", "Exit")
	var/booklistWizstandard = list()
	var/booklistWizmini = list()

/obj/machinery/computer/craftingbookcatalog/attack_hand(mob/living/user)
	. = ..()
	if(obj_integrity < max_integrity/2)
		icon_screen = "satan_broken"
		return
	else
		icon_screen = "satan"

	if(icon_screen == null)
		return

	if(isprinting)
		to_chat(user, "<span class='warning'>You must wait for the [src] to finish printing!")
		return
	var/cartridgedisplay = "Spacestar-brand Ink level: [ink]" + "u"
	if(ishuman(user))
		playsound(src, 'sound/machines/terminal_on.ogg', 40, 1)
		corpchoice = input(user, "Order a book from Spacestar! Select a mega-corporation. " + cartridgedisplay) in corporations
	switch(corpchoice)
		if("Exit")
			playsound(src, 'sound/machines/terminal_off.ogg', 40, 1)
			return

		if("Nanotrasen Approved Books")
			playsound(src, 'sound/machines/terminal_button03.ogg', 50, 1)
			bookrank = input(user, "Select a book type. " + cartridgedisplay) in ranklist

		if("Syndicate nonsense books")
			playsound(src, 'sound/machines/terminal_button03.ogg', 50, 1)
			visible_message("<span class='robot'><b>[src]</b> beeps, 'We remind you that books belonging to this mega-corporation are contraband in Nanotrasen controlled space.'")
			bookrank = input(user, "Select a book type. WARNING: Syndicate books are contraband in all Nanotrasen controlled space. [cartridgedisplay]") in ranklist

		if("Wizard Federation drivel")
			playsound(src, 'sound/machines/terminal_button03.ogg', 50, 1)
			visible_message("<span class='robot'><b>[src]</b> beeps, 'We remind you that books belonging to this mega-corporation are contraband in Nanotrasen controlled space.'")
			bookrank = input(user, "Select a book type. WARNING: Space Wizard Federation books are contraband in all Nanotrasen controlled space. [cartridgedisplay]") in ranklist

	if(bookrank == "Exit")
		playsound(src, 'sound/machines/terminal_off.ogg', 40, 1)
		return

//Nanotrasen books (not contraband)
	else if(bookrank == "Primary" && corpchoice == "Nanotrasen Approved Books")
		playsound(src, 'sound/machines/terminal_button03.ogg', 50, 1)
		book = input(user, "Select a book to order. [cartridgedisplay]") in booklistNTprimary
		spawnbook(user, 1)

	else if(bookrank == "Standard" && corpchoice == "Nanotrasen Approved Books")
		playsound(src, 'sound/machines/terminal_button03.ogg', 50, 1)
		book = input(user, "Select a book to order. [cartridgedisplay]") in booklistNTstandard
		spawnbook(user, 2)

	else if(bookrank == "Mini" && corpchoice == "Nanotrasen Approved Books")
		playsound(src, 'sound/machines/terminal_button03.ogg', 50, 1)
		book = input(user, "Select a book to order. [cartridgedisplay]") in booklistNTmini
		spawnbook(user, 3)


//Syndicate books
	else if(bookrank == "Primary" && corpchoice == "Syndicate nonsense books")
		playsound(src, 'sound/machines/terminal_button03.ogg', 50, 1)
		book = input(user, "Select a book to order. [cartridgedisplay]") in booklistSynprimary
		spawnbook(user, 4)

	else if(bookrank == "Standard" && corpchoice == "Syndicate nonsense books")
		playsound(src, 'sound/machines/terminal_button03.ogg', 50, 1)
		book = input(user, "Select a book to order. [cartridgedisplay]") in booklistSynstandard
		spawnbook(user, 5)

	else if(bookrank == "Mini" && corpchoice == "Syndicate nonsense books")
		playsound(src, 'sound/machines/terminal_button03.ogg', 50, 1)
		book = input(user, "Select a book to order. [cartridgedisplay]") in booklistSynmini
		spawnbook(user, 6)


//Wizard Federation books
	else if(bookrank == "Primary" && corpchoice == "Wizard Federation drivel")
		playsound(src, 'sound/machines/terminal_button03.ogg', 50, 1)
		book = input(user, "Select a book to order. [cartridgedisplay]") in booklistWizprimary
		spawnbook(user, 7)

	else if(bookrank == "Standard" && corpchoice == "Wizard Federation drivel")
		playsound(src, 'sound/machines/terminal_button03.ogg', 50, 1)
		book = input(user, "Select a book to order. [cartridgedisplay]") in booklistWizstandard
		spawnbook(user, 8)

	else if(bookrank == "Mini" && corpchoice == "Wizard Federation drivel")
		playsound(src, 'sound/machines/terminal_button03.ogg', 50, 1)
		book = input(user, "Select a book to order. [cartridgedisplay]") in booklistWizmini
		spawnbook(user, 9)

	if(thankyou == 1)
		visible_message("<span class='robot'><b>[src]</b> beeps, 'Thank you for using Spacestar Ordering.'")
		thankyou = 0

/obj/machinery/computer/craftingbookcatalog/proc/spawnbook(mob/user, listtype)
	if(book == "Exit")
		return

	else
		switch(listtype)
			//Nanotrasen
			//Order from top to bottom: Primary, Standard, Mini

			if(1) //1 is Nanotrasen's primary, etc.
				if(book == "")
					return

			if(2)
				return
			if(3)
				return

			//Syndicate
			if(4)
				return
			if(5)
				if(book == "2u - USSR-3 Public Disturbance Manual")
					if(spawnbookproc(user, 2) == 1)
						new /obj/item/book/granter/crafting_recipe/USSR3(get_turf(src))
					else
						return

				else if(book == "2u - Anarchist's Compendium")
					if(spawnbookproc(user, 2) == 1)
						new /obj/item/book/granter/crafting_recipe/(get_turf(src))
					else
						return
			if(6)
				return

			//Space Wizard Federation
			if(7)
				if(book == "3.5u - M'`nt a'd B,`'e")
					if(spawnbookproc(user, 3.5) == 1)
						new /obj/item/book/granter/crafting_recipe/obelisk(get_turf(src))
					else
						return

			if(8)
				return
			if(9)
				return

	thankyou = 1

/obj/machinery/computer/craftingbookcatalog/proc/spawnbookproc(mob/user, inkprice)
	if(ink < inkprice)
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 1)
		to_chat(user, "<span class ='warning'>The [src] lacks enough Spacestar-brand ink to print this book!")
		return
	else
		ink = ink - inkprice
		audible_message("[src] begins to hum as it warms up its printing drums.")
		playsound(src, 'sound/machines/copier.ogg', 50, 1)
		isprinting = TRUE
		sleep(120)
		isprinting = FALSE
		return 1

/obj/machinery/computer/craftingbookcatalog/examine(mob/user)
	. = ..()
	if(!anchored)
		. += "<span class='notice'>The <i>bolts</i> on the bottom are unsecured.</span>"
	else
		. += "<span class='notice'>It's secured in place with <b>bolts</b>.</span>"
	if(ink > 0 && ink < 2)
		. += "<span class ='notice'>The [src] has <b>1</b> Spacestar-brand ink cartridge loaded."
	else
		. += "<span class ='notice'>The [src] has <b>[ink]</b> Spacestar-brand ink cartridges loaded."

/obj/machinery/computer/craftingbookcatalog/attackby(obj/item/I, mob/user, params)
	switch(state)
		if(0)
			if(I.tool_behaviour == TOOL_WRENCH)
				if(I.use_tool(src, user, 20, volume=50))
					to_chat(user, "<span class='notice'>You wrench the [src] into place.</span>")
					anchored = TRUE
					state = 1
		if(1)
			if(istype(I, /obj/item/inkcartridge))
				qdel(I)
				visible_message("<span class ='notice'>[user] loads a Spacestar-brand ink cartridge into the [src]")
				ink++
				return
			else if(I.tool_behaviour == TOOL_WRENCH)
				if(I.use_tool(src, user, 20, volume=50))
					to_chat(user, "<span class='notice'>You unwrench the [src].</span>")
					anchored = FALSE
					state = 0
