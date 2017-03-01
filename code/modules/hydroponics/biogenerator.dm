#define BIOGENERATOR_MAIN_MENU       1
#define BIOGENERATOR_CATEGORY_MENU   2
#define BIOGENERATOR_SEARCH_MENU     3

/obj/machinery/biogenerator
	name = "biogenerator"
	desc = "Converts plants into biomass, which can be used to construct useful items."
	icon = 'icons/obj/biogenerator.dmi'
	icon_state = "biogen-empty"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 40
	var/processing = FALSE
	var/obj/item/weapon/reagent_containers/glass/beaker = null
	var/points = 0
	var/menustat = "menu"
	var/efficiency = 0
	var/productivity = 0
	var/max_items = 40
	var/datum/research/files
	var/list/datum/design/matching_designs
	var/selected_category
	var/screen = 1
	var/list/categories = list(
							"Food",
							"Botany Chemicals",
							"Botany Chemical Bottles",
							"Leather and Cloth"
							)

/obj/machinery/biogenerator/New()
	..()
	files = new /datum/research/biogenerator(src)
	create_reagents(1000)
	var/obj/item/weapon/circuitboard/machine/B = new /obj/item/weapon/circuitboard/machine/biogenerator(null)
	B.apply_default_parts(src)
	matching_designs = list()

/obj/machinery/biogenerator/Destroy()
	if(beaker)
		qdel(beaker)
		beaker = null
	return ..()

/obj/machinery/biogenerator/contents_explosion(severity, target)
	..()
	if(beaker)
		beaker.ex_act(severity, target)

/obj/machinery/biogenerator/handle_atom_del(atom/A)
	..()
	if(A == beaker)
		beaker = null
		update_icon()
		updateUsrDialog()

/obj/item/weapon/circuitboard/machine/biogenerator
	name = "Biogenerator (Machine Board)"
	build_path = /obj/machinery/biogenerator
	origin_tech = "programming=2;biotech=3;materials=3"
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/stack/cable_coil = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/machinery/biogenerator/RefreshParts()
	var/E = 0
	var/P = 0
	var/max_storage = 40
	for(var/obj/item/weapon/stock_parts/matter_bin/B in component_parts)
		P += B.rating
		max_storage = 40 * B.rating
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		E += M.rating
	efficiency = E
	productivity = P
	max_items = max_storage

/obj/machinery/biogenerator/on_reagent_change()			//When the reagents change, change the icon as well.
	update_icon()

/obj/machinery/biogenerator/update_icon()
	if(panel_open)
		icon_state = "biogen-empty-o"
	else if(!src.beaker)
		icon_state = "biogen-empty"
	else if(!src.processing)
		icon_state = "biogen-stand"
	else
		icon_state = "biogen-work"
	return

/obj/machinery/biogenerator/attackby(obj/item/O, mob/user, params)
	if(user.a_intent == INTENT_HARM)
		return ..()

	if(istype(O, /obj/item/weapon/reagent_containers/glass))
		. = 1 //no afterattack
		if(!panel_open)
			if(beaker)
				user << "<span class='warning'>A container is already loaded into the machine.</span>"
			else
				if(!user.drop_item())
					return
				O.loc = src
				beaker = O
				user << "<span class='notice'>You add the container to the machine.</span>"
				update_icon()
				updateUsrDialog()
		else
			user << "<span class='warning'>Close the maintenance panel first.</span>"
		return

	if(processing)
		user << "<span class='warning'>The biogenerator is currently processing.</span>"
		return

	if(default_deconstruction_screwdriver(user, "biogen-empty-o", "biogen-empty", O))
		if(beaker)
			var/obj/item/weapon/reagent_containers/glass/B = beaker
			B.loc = loc
			beaker = null
		update_icon()
		return

	if(exchange_parts(user, O))
		return

	if(default_deconstruction_crowbar(O))
		return

	if(istype(O, /obj/item/weapon/storage/bag/plants))
		var/obj/item/weapon/storage/bag/plants/PB = O
		var/i = 0
		for(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in contents)
			i++
		if(i >= max_items)
			user << "<span class='warning'>The biogenerator is already full! Activate it.</span>"
		else
			for(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in PB.contents)
				if(i >= max_items)
					break
				PB.remove_from_storage(G, src)
				i++
			if(i<max_items)
				user << "<span class='info'>You empty the plant bag into the biogenerator.</span>"
			else if(PB.contents.len == 0)
				user << "<span class='info'>You empty the plant bag into the biogenerator, filling it to its capacity.</span>"
			else
				user << "<span class='info'>You fill the biogenerator to its capacity.</span>"
		update_icon()
		updateUsrDialog()
		return 1 //no afterattack

	else if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/grown))
		var/i = 0
		for(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in contents)
			i++
		if(i >= max_items)
			user << "<span class='warning'>The biogenerator is full! Activate it.</span>"
		else
			if(user.transferItemToLoc(O, src))
				user << "<span class='info'>You put [O.name] in [src.name]</span>"
		update_icon()
		updateUsrDialog()
		return 1 //no afterattack
	else if (istype(O, /obj/item/weapon/disk/design_disk))
		user.visible_message("[user] begins to load \the [O] in \the [src]...",
			"You begin to load a design from \the [O]...",
			"You hear the chatter of a floppy drive.")
		processing = 1
		var/obj/item/weapon/disk/design_disk/D = O
		if(do_after(user, 10, target = src))
			for(var/B in D.blueprints)
				if(B)
					files.AddDesign2Known(B)
		processing = 0
		update_icon()
		updateUsrDialog()
		return 1
	else
		user << "<span class='warning'>You cannot put this in [src.name]!</span>"

/obj/machinery/biogenerator/interact(mob/user)
	if(stat & BROKEN || panel_open)
		return

	var/dat

	switch(screen)
		if(BIOGENERATOR_MAIN_MENU)
			dat = main_win(user)
		if(BIOGENERATOR_CATEGORY_MENU)
			dat = category_win(user,selected_category)
		if(BIOGENERATOR_SEARCH_MENU)
			dat = search_win(user)

	var/datum/browser/popup = new(user, "biogen", name, 400, 500)
	popup.set_content(dat)
	popup.open()

/obj/machinery/biogenerator/proc/main_win(mob/user)
	var/dat = "<div class='statusDisplay'><h3>Biogenerator Menu:</h3><br>"
	dat += materials_printout()

	dat += menu_status()

	dat += "<form name='search' action='?src=\ref[src]'>\
	<input type='hidden' name='src' value='\ref[src]'>\
	<input type='hidden' name='search' value='to_search'>\
	<input type='hidden' name='menu' value='[BIOGENERATOR_SEARCH_MENU]'>\
	<input type='text' name='to_search'>\
	<input type='submit' value='Search'>\
	</form><hr>"

	var/line_length = 1
	dat += "<table style='width:100%' align='center'><tr>"

	for(var/C in categories)
		if(line_length > 2)
			dat += "</tr><tr>"
			line_length = 1

		dat += "<td><A href='?src=\ref[src];category=[C];menu=[BIOGENERATOR_CATEGORY_MENU]'>[C]</A></td>"
		line_length++

	dat += "</tr></table></div>"
	return dat

/obj/machinery/biogenerator/proc/category_win(mob/user,selected_category)
	var/dat = "<A href='?src=\ref[src];menu=[BIOGENERATOR_MAIN_MENU]'>Return to main menu</A>"
	dat += "<div class='statusDisplay'><h3>Browsing [selected_category]:</h3><br>"
	dat += materials_printout()

	dat += menu_status()

	for(var/v in files.known_designs)
		var/datum/design/D = files.known_designs[v]
		if(!(selected_category in D.category))
			continue
		dat += build_data(D)
	dat += "</div>"

	return dat

/obj/machinery/biogenerator/proc/search_win(mob/user)
	var/dat = "<A href='?src=\ref[src];menu=[BIOGENERATOR_MAIN_MENU]'>Return to main menu</A>"
	dat += "<div class='statusDisplay'><h3>Search results:</h3><br>"
	dat += materials_printout()

	dat += menu_status()

	for(var/v in matching_designs)
		var/datum/design/D = v
		dat += build_data(D)
	dat += "</div>"

	return dat

/obj/machinery/biogenerator/proc/materials_printout()
	var/dat = "<div class='statusDisplay'>Biomass: [points] units."
	if(processing)
		dat += " Biogenerator is processing!"
	dat += "</div>"
	if(!processing && can_activate())
		dat += "<a href='?src=\ref[src];activate=1'>Activate</a>"
	if(beaker)
		dat += "<a href='?src=\ref[src];detach=1'>Detach Container</a>"
	return dat

/obj/machinery/biogenerator/proc/can_build(datum/design/D, amount = 1)
	if(D.materials.len != 1 || D.materials[1] != MAT_BIOMASS)
		return FALSE
	if (D.materials[MAT_BIOMASS]*amount/efficiency > points)
		return FALSE
	return TRUE

/obj/machinery/biogenerator/proc/get_design_cost(datum/design/D)
	var/dat = "[D.materials[MAT_BIOMASS]/efficiency] biomass"
	return dat

/obj/machinery/biogenerator/proc/build_data(datum/design/D)
	var/dat
	if(!can_build(D))
		dat += "<span class='linkOff'>[D.name]</span>"
	else
		dat += "<a href='?src=\ref[src];create=\ref[D];amount=1'>[D.name]</a>"
		if(can_build(D, 5))
			dat += " <a href='?src=\ref[src];create=\ref[D];amount=5'>x5</a>"
			if(can_build(D, 10))
				dat += " <a href='?src=\ref[src];create=\ref[D];amount=10'>x10</a>"
	dat += "[get_design_cost(D)]<br>"
	return dat

/obj/machinery/biogenerator/proc/menu_status()
	var/dat
	switch(menustat)
		if("nopoints")
			dat += "<div class='statusDisplay'>You do not have enough biomass to create this products.</div>"
		if("complete")
			dat += "<div class='statusDisplay'>Operation complete.</div>"
		if("void")
			dat += "<div class='statusDisplay'>No growns inside.</div>"
		if("nobeakerspace")
			dat += "<div class='statusDisplay'>Not enough space left in container.</div>"
		if("nobeaker")
			dat += "<div class='statusDisplay'>No beaker loaded.</div>"
	return dat

/obj/machinery/biogenerator/proc/can_activate()
	for(var/obj/item/weapon/reagent_containers/food/snacks/grown/I in contents)
		return TRUE
	return FALSE

/obj/machinery/biogenerator/proc/blend(obj/item/weapon/reagent_containers/food/snacks/grown/I)
	if(I.reagents.get_reagent_amount("nutriment") < 0.1)
		points += 1*productivity
	else
		points += I.reagents.get_reagent_amount("nutriment")*10*productivity
	use_power(30)
	update_icon()
	updateUsrDialog()
	qdel(I)

/obj/machinery/biogenerator/proc/activate_end()
	processing = 0
	update_icon()

/obj/machinery/biogenerator/proc/activate()
	if (usr.stat != 0)
		return
	if (src.stat != 0) //NOPOWER etc
		return
	if(processing)
		usr << "<span class='warning'>The biogenerator is in the process of working.</span>"
		return
	if(can_activate())
		processing = TRUE
		playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
		var/S = 0
		for(var/obj/item/weapon/reagent_containers/food/snacks/grown/I in contents)
			S += 4
			addtimer(CALLBACK(src, /obj/machinery/biogenerator/proc/blend, I), S/productivity)
		addtimer(CALLBACK(src, /obj/machinery/biogenerator/proc/activate_end), S/productivity)
	else
		menustat = "void"
	return

/obj/machinery/biogenerator/proc/check_cost(list/materials, multiplier = 1, remove_points = 1)
	if(materials.len != 1 || materials[1] != MAT_BIOMASS)
		return 0
	if (materials[MAT_BIOMASS]*multiplier/efficiency > points)
		menustat = "nopoints"
		return 0
	else
		if(remove_points)
			points -= materials[MAT_BIOMASS]*multiplier/efficiency
		update_icon()
		updateUsrDialog()
		return 1

/obj/machinery/biogenerator/proc/check_container_volume(list/reagents, multiplier = 1)
	if(!beaker)
		menustat = "nobeaker"
		return 0
	var/sum_reagents = 0
	for(var/R in reagents)
		sum_reagents += reagents[R]
	sum_reagents *= multiplier

	if(beaker.reagents.total_volume + sum_reagents > beaker.reagents.maximum_volume)
		menustat = "nobeakerspace"
		return 0

	return 1

/obj/machinery/biogenerator/proc/create_product(datum/design/D, amount)
	if(!loc)
		return 0
	else
		var/i = amount
		while(i > 0)
			if(D.build_path && check_cost(D.materials))
				new D.build_path(loc)
			else if(D.make_reagents.len > 0 && check_container_volume(D.make_reagents) && check_cost(D.materials))
				for(var/R in D.make_reagents)
					beaker.reagents.add_reagent(R, D.make_reagents[R])
			else
				return
			. = 1
			--i

	menustat = "complete"
	update_icon()
	return .

/obj/machinery/biogenerator/proc/detach()
	if(beaker)
		beaker.loc = src.loc
		beaker = null
		update_icon()

/obj/machinery/biogenerator/Topic(href, href_list)
	if(..() || panel_open)
		return

	menustat = "menu"

	if(href_list["menu"])
		screen = text2num(href_list["menu"])

	if(href_list["category"])
		selected_category = href_list["category"]

	if(href_list["search"])
		matching_designs.Cut()

		for(var/v in files.known_designs)
			var/datum/design/D = files.known_designs[v]
			if(findtext(D.name,href_list["to_search"]))
				matching_designs.Add(D)

	if(href_list["activate"])
		activate()

	if(href_list["detach"])
		detach()

	if(href_list["create"])
		var/amount = (text2num(href_list["amount"]))
		var/datum/design/D = locate(href_list["create"])
		create_product(D, amount)

	updateUsrDialog()

	return