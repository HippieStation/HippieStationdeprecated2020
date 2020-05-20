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
//scroll down to the proc "spawnbook()" and copy what every other book does. Make sure "Exit" is always the first item in the list.
//*************

/obj/machinery/computer/craftingbookcatalog
	name = "Spacestar Ordering Book Catalog"
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
	var/isprinting = FALSE
	var/state = 1
	var/ink = 0
	var/corpchoice
	var/book
	var/inkcost = 0
	var/corporations = list("Exit", "Nanotrasen Approved Books", "Syndicate nonsense books", "Wizard Federation drivel",)
	//
	var/booklistNT = list("Exit", "0.5u - Grabar: A Slow Mindkill", "1u - UAW Environment", "0.75u - Squod Word's Astrological Journal", "2u - Exoplanet Exploration Vol. 13: Trapping", "1.5u - The Sound of Clown", "2u - Robert Lang's Origami Unveiled Vol. 1", "0.25u - The Mark of Cain")
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

	if(isprinting)
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
					if(spawnbookproc(user, 2) == 1)
						new /obj/item/book/granter/crafting_recipe/trapping(get_turf(src))
					else
						return

				else if(book == "1.5u - The Sound of Clown")
					if(spawnbookproc(user, 1.5) == 1)
						new /obj/item/book/granter/crafting_recipe/clowninstruments(get_turf(src))
					else
						return

				else if(book == "2u - Robert Lang's Origami Unveiled Vol. 1")
					if(spawnbookproc(user, 2) == 1)
						new /obj/item/book/granter/crafting_recipe/origami1(get_turf(src))
					else
						return

				else if(book == "0.25u - The Mark of Cain")
					if(spawnbookproc(user, 0.25) == 1)
						new /obj/item/book/granter/crafting_recipe/vampire(get_turf(src))
					else
						return

				else if(book == "1u - UAW Environment")
					if(spawnbookproc(user, 1) == 1)
						new /obj/item/book/granter/crafting_recipe/workenvironment(get_turf(src))
					else
						return

				else if(book == "0.75u - Squod Word's Astrological Journal")
					if(spawnbookproc(user, 0.75) == 1)
						new /obj/item/book/granter/crafting_recipe/stargazing(get_turf(src))
					else
						return

				else if(book == "0.5u - Grabar: A Slow Mindkill")
					if(spawnbookproc(user, 0.5) == 1)
						new /obj/item/book/granter/crafting_recipe/audio(get_turf(src))
					else
						return

			//Syndicate
			if(2)
				if(book == "2u - USSR-3 Public Disturbance Manual")
					if(spawnbookproc(user, 2) == 1)
						new /obj/item/book/granter/crafting_recipe/USSR3(get_turf(src))
					else
						return

				else if(book == "1.5u - Straight Outa' Compton")
					if(spawnbookproc(user, 1.5) == 1)
						new /obj/item/book/granter/crafting_recipe/gang(get_turf(src))
					else
						return

				else if(book == "2u - Anarchist's Compendium")
					if(spawnbookproc(user, 2) == 1)
						new /obj/item/book/granter/crafting_recipe(get_turf(src))
					else
						return

				else if(book == "2.25u - CODEWORD Arabian")
					if(spawnbookproc(user, 2.25) == 1)
						new /obj/item/book/granter/crafting_recipe/illegalweapons(get_turf(src))
					else
						return

			//Space Wizard Federation
			if(3)
				if(book == "3.5u - M'`nt a'd B,`'e")
					if(spawnbookproc(user, 3.5) == 1)
						new /obj/item/book/granter/crafting_recipe/obelisk(get_turf(src))
					else
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
		sleep(110)
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
