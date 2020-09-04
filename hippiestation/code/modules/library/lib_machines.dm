/obj/machinery/libraryscanner
	icon_hippie = 'hippiestation/icons/obj/library.dmi'

/obj/machinery/bookbinder
	icon_hippie = 'hippiestation/icons/obj/library.dmi'

/obj/item/inkcartridge
	name = "Spacestar-brand ink cartridge"
	desc = "Compatible with Spacestar Ordering Book Catalogs, like the one in the library!"
	icon = 'hippiestation/icons/obj/library.dmi'
	icon_state = "inkcartridge"
	w_class = WEIGHT_CLASS_TINY

//*************
//How to add books: Add the book to the appropriate booklist below and then
//scroll down to the proc "spawnbook()" and copy what every other book does. Make sure "Exit" is always the first item in the book lists.
//*************

/obj/machinery/computer/craftingbookcatalog
	name = "Spacestar Book Catalog"
	desc = "A console from the secretive Spacestar conglomerate. Allows users to print books from the Spacestar Knowledge Hub, which contains only the <i>most useful</i> information."
	icon = 'hippiestation/icons/obj/computer.dmi'
	icon_state = "hell"
	icon_screen = "satan"
	icon_keyboard = null
	use_power = IDLE_POWER_USE
	idle_power_usage = 2
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
	var/printing = FALSE
	var/ink = 0
	var/corpchoice
	var/book
	var/inkcost = 0
	var/corporations = list("Exit", "Nanotrasen Approved Books", "Syndicate nonsense books", "Wizard Federation drivel")
	//
	var/booklistNT = list("Exit", "0.25u - Grabar: A Slow Mindkill", "1u - UAW Environment", "0.75u - Squod Word's Astrological Journal", "2u - Exoplanet Exploration Vol. 13: Trapping", "1.5u - The Sound of Clown", "2u - Robert Lang's Origami Unveiled Vol. 1", "0.5u - The Mark of Cain")
	//
	var/booklistSyndicate = list("Exit", "2u - USSR-3 Public Disturbance Manual", "1.5u - Straight Outa' Compton", "2u - Anarchist's Compendium", "2.25u - CODEWORD Arabian")
	//
	var/booklistWizFed = list("Exit", "3.5u - M'`nt a'd B,`'e")

/obj/machinery/computer/craftingbookcatalog/attack_hand(mob/living/user)
	. = ..()
	if(stat & NOPOWER || stat & BROKEN)
		update_icon()
		return

	if(icon_screen == null)
		return

	if(printing)
		to_chat(user, "<span class='warning'>You must wait for the [src] to finish printing!")
		return
	var/cartridgedisplay = "Spacestar-brand ink level: [ink]" + "u"
	if(ishuman(user))
		playsound(src, 'sound/machines/terminal_on.ogg', 50, 1)
		corpchoice = input(user, "Print a book from Spacestar! Select a mega-corporation. " + cartridgedisplay) in corporations
	switch(corpchoice)
		if("Exit")
			playsound(src, 'sound/machines/terminal_off.ogg', 50, 1)
			return

		if("Nanotrasen Approved Books")
			playsound(src, 'sound/machines/terminal_button03.ogg', 50, 1)
			book = input(user, "Select a book. " + cartridgedisplay) in booklistNT
			spawnbook(user, 1)

		if("Syndicate nonsense books")
			playsound(src, 'sound/machines/terminal_button03.ogg', 50, 1)
			visible_message("<span class='robot'><b>[src]</b> beeps, 'We remind you that books belonging to this mega-corporation are contraband in Nanotrasen controlled space.'")
			book = input(user, "Select a book. WARNING: Syndicate books are contraband in all Nanotrasen controlled space. [cartridgedisplay]") in booklistSyndicate
			spawnbook(user, 2)

		if("Wizard Federation drivel")
			playsound(src, 'sound/machines/terminal_button03.ogg', 50, 1)
			visible_message("<span class='robot'><b>[src]</b> beeps, 'We remind you that books belonging to this mega-corporation are contraband in Nanotrasen controlled space.'")
			book = input(user, "Select a book. WARNING: Space Wizard Federation books are contraband in all Nanotrasen controlled space. [cartridgedisplay]") in booklistWizFed
			spawnbook(user, 3)

	if(thankyou == 1)
		visible_message("<span class='robot'><b>[src]</b> beeps, 'Thank you for using Spacestar Ordering.'")
		thankyou = 0

/obj/machinery/computer/craftingbookcatalog/proc/spawnbook(mob/user, listtype) //listtype is which megacorporation was picked

	if(book == "Exit")
		playsound(src, 'sound/machines/terminal_off.ogg', 50, 1)
		return

	else
		switch(listtype)

			if(1) //1 is Nanotrasen

				if(book == "2u - Exoplanet Exploration Vol. 13: Trapping")
					if(checkprice(user, 2) == 1)
						addtimer(CALLBACK(src, .proc/print, /obj/item/book/granter/crafting_recipe/trapping), 110)
					else
						return

				else if(book == "1.5u - The Sound of Clown")
					if(checkprice(user, 1.5) == 1)
						addtimer(CALLBACK(src, .proc/print, /obj/item/book/granter/crafting_recipe/clowninstruments), 110)
					else
						return

				else if(book == "2u - Robert Lang's Origami Unveiled Vol. 1")
					if(checkprice(user, 2) == 1)
						addtimer(CALLBACK(src, .proc/print, /obj/item/book/granter/crafting_recipe/origami1), 110)
					else
						return

				else if(book == "0.5u - The Mark of Cain")
					if(checkprice(user, 0.5) == 1)
						addtimer(CALLBACK(src, .proc/print, /obj/item/book/granter/crafting_recipe/vampire), 110)
					else
						return

				else if(book == "1u - UAW Environment")
					if(checkprice(user, 1) == 1)
						addtimer(CALLBACK(src, .proc/print, /obj/item/book/granter/crafting_recipe/workenvironment), 110)
					else
						return

				else if(book == "0.75u - Squod Word's Astrological Journal")
					if(checkprice(user, 0.75) == 1)
						addtimer(CALLBACK(src, .proc/print, /obj/item/book/granter/crafting_recipe/stargazing), 110)
					else
						return

				else if(book == "0.25u - Grabar: A Slow Mindkill")
					if(checkprice(user, 0.25) == 1)
						addtimer(CALLBACK(src, .proc/print, /obj/item/book/granter/crafting_recipe/audio), 110)
					else
						return

			//Syndicate
			if(2)
				if(book == "2u - USSR-3 Public Disturbance Manual")
					if(checkprice(user, 2) == 1)
						addtimer(CALLBACK(src, .proc/print, /obj/item/book/granter/crafting_recipe/USSR3), 110)
					else
						return

				else if(book == "1.5u - Straight Outa' Compton")
					if(checkprice(user, 1.5) == 1)
						addtimer(CALLBACK(src, .proc/print, /obj/item/book/granter/crafting_recipe/gang), 110)
					else
						return

				else if(book == "2u - Anarchist's Compendium")
					if(checkprice(user, 2) == 1)
						addtimer(CALLBACK(src, .proc/print, /obj/item/book/granter/crafting_recipe), 110)
					else
						return

				else if(book == "2.25u - CODEWORD Arabian")
					if(checkprice(user, 2.25) == 1)
						addtimer(CALLBACK(src, .proc/print, /obj/item/book/granter/crafting_recipe/illegalweapons), 110)
					else
						return

			//Space Wizard Federation
			if(3)
				if(book == "3.5u - M'`nt a'd B,`'e")
					if(checkprice(user, 3.5) == 1)
						addtimer(CALLBACK(src, .proc/print, /obj/item/book/granter/crafting_recipe/obelisk), 110)
					else
						return

	thankyou = 1

/obj/machinery/computer/craftingbookcatalog/proc/checkprice(mob/user, inkprice)
	if(ink < inkprice)
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 1)
		to_chat(user, "<span class ='warning'>The [src] lacks enough Spacestar-brand ink to print this book!")
		return
	else
		ink = ink - inkprice
		audible_message("[src] begins to hum as it warms up its printing drums.")
		printing = TRUE
		playsound(src, 'sound/machines/copier.ogg', 50, 1)
		return 1

/obj/machinery/computer/craftingbookcatalog/proc/print(book)
	new book(get_turf(src))
	printing = FALSE

/obj/machinery/computer/craftingbookcatalog/examine(mob/user)
	. = ..()
	if(ink > 0 && ink < 2)
		. += "<span class ='notice'>The [src] has <b>1</b> Spacestar-brand ink cartridge loaded."
	else
		. += "<span class ='notice'>The [src] has <b>[ink]</b> Spacestar-brand ink cartridges loaded."

/obj/machinery/computer/craftingbookcatalog/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/inkcartridge))
		if(printing)
			to_chat(user, "<span class='warning'>You must wait for the [src] to finish printing!")
			return

		qdel(I)
		visible_message("<span class ='notice'>[user] loads a Spacestar-brand ink cartridge into the [src]")
		ink++
		return
