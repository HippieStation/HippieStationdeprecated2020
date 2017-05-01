/**********************Ore Redemption Unit**************************/
//Turns all the various mining machines into a single unit to speed up mining and establish a point system

/obj/machinery/mineral/ore_redemption
	name = "ore redemption machine"
	desc = "A machine that accepts ore and instantly transforms it into workable material sheets. Points for ore are generated based on type and can be redeemed at a mining equipment vendor."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "ore_redemption"
	density = 1
	anchored = 1
	input_dir = NORTH
	output_dir = SOUTH
	req_access = list(GLOB.access_mineral_storeroom)
	var/req_access_reclaim = GLOB.access_mining_station
	var/obj/item/weapon/card/id/inserted_id
	var/points = 0
	var/ore_pickup_rate = 15
	var/sheet_per_ore = 1
	var/point_upgrade = 1
	var/list/ore_values = list("sand" = 1, "iron" = 1, "plasma" = 15, "silver" = 16, "gold" = 18, "titanium" = 30, "uranium" = 30, "diamond" = 50, "bluespace crystal" = 50, "bananium" = 60)
	speed_process = 1
	var/message_sent = FALSE
	var/list/ore_buffer = list()
	var/datum/material_container/materials
	var/datum/research/files

/obj/machinery/mineral/ore_redemption/Initialize()
	. = ..()
	var/obj/item/weapon/circuitboard/machine/ore_redemption/B = new
	B.apply_default_parts(src)
	materials = new(src, list(MAT_METAL, MAT_GLASS, MAT_SILVER, MAT_GOLD, MAT_DIAMOND, MAT_PLASMA, MAT_URANIUM, MAT_BANANIUM, MAT_TITANIUM, MAT_BLUESPACE),INFINITY)
	files = new /datum/research/smelter(src)

/obj/machinery/mineral/ore_redemption/Destroy()
	QDEL_NULL(materials)
	QDEL_NULL(files)
	return ..()

/obj/item/weapon/circuitboard/machine/ore_redemption
	name = "Ore Redemption (Machine Board)"
	build_path = /obj/machinery/mineral/ore_redemption
	origin_tech = "programming=1;engineering=2"
	req_components = list(
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/device/assembly/igniter = 1)

/obj/machinery/mineral/ore_redemption/RefreshParts()
	var/ore_pickup_rate_temp = 15
	var/point_upgrade_temp = 1
	var/sheet_per_ore_temp = 1
	for(var/obj/item/weapon/stock_parts/matter_bin/B in component_parts)
		sheet_per_ore_temp = 0.65 + (0.35 * B.rating)
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		ore_pickup_rate_temp = 15 * M.rating
	for(var/obj/item/weapon/stock_parts/micro_laser/L in component_parts)
		point_upgrade_temp = 0.65 + (0.35 * L.rating)
	ore_pickup_rate = ore_pickup_rate_temp
	point_upgrade = point_upgrade_temp
	sheet_per_ore = sheet_per_ore_temp

/obj/machinery/mineral/ore_redemption/proc/smelt_ore(obj/item/weapon/ore/O)

	ore_buffer -= O

	if(O && O.refined_type)
		points += O.points * point_upgrade

	var/material_amount = materials.get_item_material_amount(O)

	if(!material_amount)
		qdel(O) //no materials, incinerate it

	else if(!materials.has_space(material_amount)) //if there is no space, eject it
		unload_mineral(O)

	else
		materials.insert_item(O) //insert it
		qdel(O)

/obj/machinery/mineral/ore_redemption/proc/can_smelt_alloy(datum/design/D)
	if(D.make_reagents.len)
		return 0

	var/build_amount = 1

	for(var/mat_id in D.materials)
		var/M = D.materials[mat_id]
		var/datum/material/redemption_mat = materials.materials[mat_id]

		if(!M || !redemption_mat)
			return 0

		build_amount = min(build_amount, round(redemption_mat.amount / M))

	return build_amount

/obj/machinery/mineral/ore_redemption/proc/process_ores(list/ores_to_process)
	var/current_amount = 0
	for(var/ore in ores_to_process)
		if(current_amount >= ore_pickup_rate)
			break
		smelt_ore(ore)

/obj/machinery/mineral/ore_redemption/proc/send_console_message()
	if(z != ZLEVEL_STATION)
		return
	message_sent = TRUE
	var/area/A = get_area(src)
	var/msg = "Now available in [A]:<br>"

	var/has_minerals = FALSE

	for(var/mat_id in materials.materials)
		var/datum/material/M = materials.materials[mat_id]
		var/mineral_amount = M.amount / MINERAL_MATERIAL_AMOUNT
		if(mineral_amount)
			has_minerals = TRUE
		msg += "[capitalize(M.name)]: [mineral_amount] sheets<br>"

	if(!has_minerals)
		return

	for(var/obj/machinery/requests_console/D in GLOB.allConsoles)
		if(D.receive_ore_updates)
			D.createmessage("Ore Redemption Machine", "New minerals available!", msg, 1, 0)

/obj/machinery/mineral/ore_redemption/process()
	if(panel_open || !powered())
		return
	var/atom/input = get_step(src, input_dir)
	var/obj/structure/ore_box/OB = locate() in input
	if(OB)
		input = OB

	for(var/obj/item/weapon/ore/O in input)
		if(QDELETED(O))
			continue
		ore_buffer |= O
		O.forceMove(src)
		CHECK_TICK

	if(LAZYLEN(ore_buffer))
		message_sent = FALSE
		process_ores(ore_buffer)
	else if(!message_sent)
		send_console_message()

/obj/machinery/mineral/ore_redemption/attackby(obj/item/weapon/W, mob/user, params)
	if(exchange_parts(user, W))
		return
	if(default_pry_open(W))
		return
	if(default_unfasten_wrench(user, W))
		return
	if(default_deconstruction_screwdriver(user, "ore_redemption-open", "ore_redemption", W))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(W))
		return

	if(!powered())
		return
	if(istype(W,/obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/I = user.get_active_held_item()
		if(istype(I) && !istype(inserted_id))
			if(!user.drop_item())
				return
			I.forceMove(src)
			inserted_id = I
			interact(user)
		return

	if(istype(W, /obj/item/device/multitool) && panel_open)
		input_dir = turn(input_dir, -90)
		output_dir = turn(output_dir, -90)
		to_chat(user, "<span class='notice'>You change [src]'s I/O settings, setting the input to [dir2text(input_dir)] and the output to [dir2text(output_dir)].</span>")
		return

	return ..()

/obj/machinery/mineral/ore_redemption/on_deconstruction()
	materials.retrieve_all()
	..()

/obj/machinery/mineral/ore_redemption/attack_hand(mob/user)
	if(..())
		return
	interact(user)

/obj/machinery/mineral/ore_redemption/interact(mob/user)
	var/dat = "This machine only accepts ore. Gibtonite and Slag are not accepted.<br><br>"
	dat += "Current unclaimed points: [points]<br>"

	if(inserted_id)
		dat += "You have [inserted_id.mining_points] mining points collected. <A href='?src=\ref[src];eject_id=1'>Eject ID.</A><br>"
		dat += "<A href='?src=\ref[src];claim=1'>Claim points.</A><br><br>"
	else
		dat += "No ID inserted.  <A href='?src=\ref[src];insert_id=1'>Insert ID.</A><br><br>"

	for(var/mat_id in materials.materials)
		var/datum/material/M = materials.materials[mat_id]
		if(M.amount)
			var/sheet_amount = M.amount / MINERAL_MATERIAL_AMOUNT
			dat += "[capitalize(M.name)]: [sheet_amount] "
			if(sheet_amount >= 1)
				dat += "<A href='?src=\ref[src];release=[mat_id]'>Release</A><br>"
			else
				dat += "<span  class='linkOff'>Release</span><br>"

	for(var/v in files.known_designs)
		var/datum/design/D = files.known_designs[v]
		if(can_smelt_alloy(D))
			dat += "[D.name]: <A href='?src=\ref[src];alloy=[D.id]'>Smelt</A><br>"
		else
			dat += "[D.name]: <span class='linkOff'>Smelt</span><br>"

	dat += "<br><div class='statusDisplay'><b>Mineral Value List:</b><br>[get_ore_values()]</div>"

	var/datum/browser/popup = new(user, "ore_redemption_machine", "Ore Redemption Machine", 400, 500)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/mineral/ore_redemption/proc/get_ore_values()
	var/dat = "<table border='0' width='300'>"
	for(var/ore in ore_values)
		var/value = ore_values[ore]
		dat += "<tr><td>[capitalize(ore)]</td><td>[value * point_upgrade]</td></tr>"
	dat += "</table>"
	return dat

/obj/machinery/mineral/ore_redemption/Topic(href, href_list)
	if(..())
		return
	if(href_list["eject_id"])
		usr.put_in_hands(inserted_id)
		inserted_id = null
	if(href_list["claim"])
		if(inserted_id)
			if(req_access_reclaim in inserted_id.access)
				inserted_id.mining_points += points
				points = 0
			else
				to_chat(usr, "<span class='warning'>Required access not found.</span>")
	else if(href_list["insert_id"])
		var/obj/item/weapon/card/id/I = usr.get_active_held_item()
		if(istype(I))
			if(!usr.drop_item())
				return
			I.forceMove(src)
			inserted_id = I
		else
			to_chat(usr, "<span class='warning'>Not a valid ID!</span>")
	if(href_list["release"])
		if(check_access(inserted_id) || allowed(usr)) //Check the ID inside, otherwise check the user.
			if(!(text2path(href_list["release"]) in stack_list))
				return
			var/obj/item/stack/sheet/inp = stack_list[text2path(href_list["release"])]
			var/obj/item/stack/sheet/out = new inp.type(src, 0, FALSE)
			var/desired = input("How many sheets?", "How many sheets to eject?", 1) as null|num
			out.amount = round(min(desired,50,inp.amount))
			if(out.amount >= 1)
				inp.amount -= out.amount
				unload_mineral(out)
			if(inp.amount < 1)
				stack_list -= text2path(href_list["release"])
				qdel(inp)
		else
			to_chat(usr, "<span class='warning'>Required access not found.</span>")
	if(href_list["alloytype1"] && href_list["alloytype2"] && href_list["alloytypeout"])
		var/alloytype1 = text2path(href_list["alloytype1"])
		var/alloytype2 = text2path(href_list["alloytype2"])
		var/alloytypeout = text2path(href_list["alloytypeout"])
		if(check_access(inserted_id) || allowed(usr))
			if(!(alloytype1 in stack_list))
				return
			if(!(alloytype2 in stack_list))
				return
			var/obj/item/stack/sheet/stack1 = stack_list[alloytype1]
			var/obj/item/stack/sheet/stack2 = stack_list[alloytype2]
			var/desired = input("How many sheets?", "How many sheets would you like to smelt?", 1) as null|num
			var/obj/item/stack/sheet/alloyout = new alloytypeout
			alloyout.amount = round(min(desired,50,stack1.amount,stack2.amount))
			if(alloyout.amount >= 1)
				stack1.amount -= alloyout.amount
				stack2.amount -= alloyout.amount
				unload_mineral(alloyout)
			if(stack1.amount < 1)
				stack_list -= stack1
				qdel(stack1)
			if(stack2.amount < 1)
				stack_list -= stack2
				qdel(stack2)
		else
			to_chat(usr, "<span class='warning'>Required access not found.</span>")
	updateUsrDialog()
	return

/obj/machinery/mineral/ore_redemption/ex_act(severity, target)
	do_sparks(5, TRUE, src)
	..()

//empty the redemption machine by stacks of at most max_amount (50 at this time) size
/obj/machinery/mineral/ore_redemption/proc/empty_content()
	var/obj/item/stack/sheet/s

	for(var/O in stack_list)
		s = stack_list[O]
		while(s.amount > s.max_amount)
			new s.type(loc,s.max_amount)
			s.use(s.max_amount)
		s.forceMove(get_turf(src))
		s.layer = initial(s.layer)
		s.plane = initial(s.plane)

/obj/machinery/mineral/ore_redemption/power_change()
	..()
	update_icon()

/obj/machinery/mineral/ore_redemption/update_icon()
	if(powered())
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"
	return