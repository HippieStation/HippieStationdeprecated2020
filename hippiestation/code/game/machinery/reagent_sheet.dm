/obj/machinery/reagent_sheet
	name = "Reagent Refinery"
	desc = "Smelts and refines solid reagents into ingots- useable by the forge."
	icon_state = "furnace"
	icon = 'icons/obj/machines/mining_machines.dmi'
	density = TRUE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	light_power = 0.5
	light_range = 2
	light_color = LIGHT_COLOR_FLARE
	var/working = FALSE
	var/work_time = 300
	var/end_volume = 100
	circuit = /obj/item/circuitboard/machine/reagent_sheet

/obj/machinery/reagent_sheet/RefreshParts()
	for(var/obj/item/stock_parts/micro_laser/ML in component_parts)
		work_time = (initial(work_time)/ML.rating)
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		end_volume = initial(end_volume) * MB.rating
		
/obj/machinery/reagent_sheet/examine(mob/user)
	..()
	if(in_range(user, src) || isobserver(user))
		to_chat(user, "<span class='notice'>The status display reads: Outputting <b>[end_volume/20]</b> ingot(s) after <b>[work_time*0.1]</b> seconds of processing.<span>")

/obj/machinery/reagent_sheet/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/solid_reagent))
		var/obj/item/reagent_containers/food/snacks/solid_reagent/S = I

		if(working)
			to_chat(user, "<span class='warning'>[src] is busy!</span>")
			return

		if(panel_open)
			to_chat(user, "<span class='warning'>You can't load the [I] while it's opened!</span>")
			return

		if(!in_range(src, S) || !user.Adjacent(src))
			return

		if(S.reagents)
			var/chem_material = S.reagents.total_volume * end_volume
			use_power = S.reagents.total_volume
			updateUsrDialog()
			addtimer(CALLBACK(src, /obj/machinery/reagent_sheet/proc/create_sheets, chem_material, S.reagent_type), work_time)
			working = TRUE
			to_chat(user, "<span class='notice'>You add [S] to [src]</span>")
			visible_message("<span class='notice'>[src] activates!</span>")
			qdel(S)
		else
			to_chat(user, "<span class='alert'>[src] rejects the [S]</span>")
	else
		..()

/obj/machinery/reagent_sheet/proc/create_sheets(amount, R)
	visible_message("<span class='notice'>[src] finishes processing</span>")
	playsound(src, 'sound/machines/ping.ogg', 50, 0)
	working = FALSE
	var/sheet_amount = max(round(amount / MINERAL_MATERIAL_AMOUNT), 1)
	var/obj/item/stack/sheet/mineral/reagent/RS = new(get_turf(src))
	RS.amount = sheet_amount
	var/paths = subtypesof(/datum/reagent)//one reference per stack
	for(var/path in paths)
		var/datum/reagent/RR = new path
		if(RR.id == R)
			RS.reagent_type = RR
			RS.name = "[RR.name] ingots"
			RS.singular_name = "[RR.name] ingot"
			RS.add_atom_colour(RR.color, FIXED_COLOUR_PRIORITY)
			break
		else
			qdel(RR)

	return

/obj/item/circuitboard/machine/reagent_sheet
	name = "Reagent Refinery (Machine Board)"
	build_path = /obj/machinery/reagent_sheet
	req_components = list(
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stack/cable_coil = 3)
