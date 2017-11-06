/obj/machinery/reagent_forge
	name = "material forge"
	desc = "A bulky machine that can smelt practically any material in existence"
	icon = 'icons/obj/3x3.dmi'
	icon_state = "huge_engine"
	bound_width = 96
	bound_height = 96
	anchored = TRUE
	max_integrity = 1000
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 10
	active_power_usage = 3000
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	circuit = null
	var/datum/reagent/currently_forging//forge one mat at a time
	var/list/show_categories = list("Weaponry")
	var/processing = FALSE
	var/efficiency = 1
	var/datum/research/files
	var/menustat = "menu"


/obj/machinery/reagent_forge/Initialize()
	. = ..()
	AddComponent(/datum/component/material_container, list(MAT_REAGENT), 200000)
	files = new /datum/research/reagent_forge(src)
	dir = NORTH


/obj/machinery/reagent_forge/attackby(obj/item/I, mob/user)
	if(user.a_intent == INTENT_HARM)
		return ..()

	check_cost()
	if(istype(I, /obj/item/stack/sheet/mineral/reagent))
		var/obj/item/stack/sheet/mineral/reagent/R = I


		if(panel_open)
			to_chat(user, "<span class='warning'>You can't load the [src.name] while it's opened!</span>")
			return

		if(!in_range(src, R) || !user.Adjacent(src))
			return

		if(R.reagent_type)
			if(!currently_forging || !currently_forging.id)
				updateUsrDialog()
				GET_COMPONENT(materials, /datum/component/material_container)
				materials.insert_stack(R, R.amount)
				to_chat(user, "<span class='notice'>You add [R] to [src]</span>")
				updateUsrDialog()
				currently_forging = new R.reagent_type.type
				return

			if(currently_forging && currently_forging.id && R.reagent_type.id == currently_forging.id)//preventing unnecessary references from being made
				updateUsrDialog()
				GET_COMPONENT(materials, /datum/component/material_container)
				materials.insert_stack(R, R.amount)
				to_chat(user, "<span class='notice'>You add [R] to [src]</span>")
				return
			else
				to_chat(user, "<span class='notice'>[currently_forging] is currently being forged, either remove or use it before adding a different material</span>")//if null is currently being forged comes up i'm gonna scree
				return

	else
		to_chat(user, "<span class='alert'>[src] rejects the [I]</span>")


/obj/machinery/reagent_forge/proc/check_cost(materials)
	GET_COMPONENT(ourmaterials, /datum/component/material_container)

	if(ourmaterials.amount(MAT_REAGENT) <= 0)
		qdel(currently_forging)
		currently_forging = null
		return FALSE

	if(!materials)
		return FALSE

	if(materials*efficiency > ourmaterials.amount(MAT_REAGENT))
		menustat = "nomats"
		return FALSE
	else
		var/list/materials_used = list(MAT_REAGENT=materials*efficiency)
		ourmaterials.use_amount(materials_used)
		updateUsrDialog()
		return TRUE


/obj/machinery/reagent_forge/proc/create_product(datum/design/D, amount, mob/living/user)
	if(!loc)
		return FALSE

	for(var/i in 1 to amount)
		if(!check_cost(D.materials[MAT_REAGENT]))
			return .

		if(D.build_path)
			var/atom/A = new D.build_path(user.loc)
			if(currently_forging)
				if(istype(D, /datum/design/forge))
					var/obj/item/forged/F = A
					var/paths = subtypesof(/datum/reagent)
					for(var/path in paths)
						var/datum/reagent/RR = new path
						if(RR.id == currently_forging.id)
							F.reagent_type = RR
							F.assign_properties()
							break
						else
							qdel(RR)
		. = 1

	menustat = "complete"
	update_icon()
	return .


/obj/machinery/reagent_forge/interact(mob/user)
	if(stat & BROKEN || panel_open)
		return
	GET_COMPONENT(materials, /datum/component/material_container)
	check_cost()
	user.set_machine(src)
	var/dat
	if(processing)
		dat += "<div class='statusDisplay'>Reagent Forge is processing! Please wait...</div><BR>"
	else
		switch(menustat)
			if("nomats")
				dat += "<div class='statusDisplay'>You do not have enough material to create this.<BR>Please insert more [currently_forging] into the forge.</div>"
				menustat = "menu"

			if("complete")
				dat += "<div class='statusDisplay'>Operation complete.</div>"
				menustat = "menu"

		var/categories = show_categories.Copy()
		for(var/V in categories)
			categories[V] = list()
		for(var/V in files.known_designs)
			var/datum/design/D = files.known_designs[V]
			for(var/C in categories)
				if(C in D.category)
					categories[C] += D

		dat += "<div class='statusDisplay'>[currently_forging]: [materials.amount(MAT_REAGENT)] cm3.<BR>"
		dat += "<A href='?src=\ref[src];dump=1'>Dump</A></div>"
		for(var/cat in categories)
			dat += "<h3>[cat]:</h3>"
			dat += "<div class='statusDisplay'>"
			for(var/V in categories[cat])
				var/datum/design/D = V
				dat += "[D.name]: <A href='?src=\ref[src];create=\ref[D];amount=1'>Make</A>"
				dat += "([D.materials[MAT_REAGENT]*efficiency])<br>"
			dat += "</div>"

	var/datum/browser/popup = new(user, "reagent_forge", name, 400, 570)
	popup.set_content(dat)
	popup.open()
	return


/obj/machinery/reagent_forge/Topic(href, href_list)
	if(..() || panel_open)
		return

	usr.set_machine(src)

	if(href_list["create"])
		var/amount = (text2num(href_list["amount"]))
		var/datum/design/D = locate(href_list["create"])
		if(isliving(usr))
			create_product(D, amount, usr)
		updateUsrDialog()

	else if(href_list["menu"])
		menustat = "menu"
		updateUsrDialog()

	else if(href_list["dump"])
		if(currently_forging)
			GET_COMPONENT(materials, /datum/component/material_container)
			var/amount = materials.amount(MAT_REAGENT)
			if(amount > 0)
				var/list/materials_used = list(MAT_REAGENT=amount)
				materials.use_amount(materials_used)
				var/obj/item/stack/sheet/mineral/reagent/RS = new(get_turf(usr))
				RS.amount = materials.amount2sheet(amount)
				var/paths = subtypesof(/datum/reagent)//one reference per stack

				for(var/path in paths)
					var/datum/reagent/RR = new path
					if(RR.id == currently_forging.id)
						RS.reagent_type = RR
						RS.name = "[RR.name] ingots"
						RS.singular_name = "[RR.name] ingot"
						RS.add_atom_colour(RR.color, FIXED_COLOUR_PRIORITY)
						to_chat(usr, "<span class='notice'>You remove the [RS.name] from [src]</span>")
						break
					else
						qdel(RR)

		qdel(currently_forging)
		currently_forging = null
		updateUsrDialog()