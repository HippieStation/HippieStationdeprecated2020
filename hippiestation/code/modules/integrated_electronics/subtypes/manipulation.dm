/obj/item/integrated_circuit/manipulation/thrower/post_throw(obj/item/A)
	return // thrown damage to 0 was disabled


// - inserter circuit - //
/obj/item/integrated_circuit/manipulation/inserter
	name = "inserter"
	desc = "A nimble circuit that puts stuff inside a storage like a backpack and can take it out aswell."
	icon_state = "grabber"
	extended_desc = "This circuit accepts a reference to an object to be inserted or extracted depending on mode. If a storage is given for extraction, the extracted item will be put in the new storage. Modes: 1 insert, 0 to extract."
	w_class = WEIGHT_CLASS_SMALL
	size = 3
	cooldown_per_use = 5
	complexity = 10
	inputs = list("target object" = IC_PINTYPE_REF, "target container" = IC_PINTYPE_REF,"mode" = IC_PINTYPE_NUMBER)
	activators = list("pulse in" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_COMBAT
	power_draw_per_use = 20
	var/max_items = 10

/obj/item/integrated_circuit/manipulation/inserter/do_work()
	//There shouldn't be any target required to eject all contents
	var/obj/item/target_obj = get_pin_data_as_type(IC_INPUT, 1, /obj/item)
	if(!target_obj)
		return

	var/distance = get_dist(get_turf(src),get_turf(target_obj))
	if(distance > 1 || distance < 0)
		return

	var/obj/item/storage/container = get_pin_data_as_type(IC_INPUT, 2, /obj/item)
	var/mode = get_pin_data(IC_INPUT, 3)
	switch(mode)
		if(1)	//Not working
			if(!container || !istype(container,/obj/item/storage) || !Adjacent(container))
				return

			GET_COMPONENT_FROM(STR, /datum/component/storage, container)
			if(!STR)
				return

			STR.attackby(src, target_obj)

		else
			GET_COMPONENT_FROM(STR, /datum/component/storage, target_obj.loc)
			if(!STR)
				return

			if(!container || !istype(container,/obj/item/storage) || !Adjacent(container))
				STR.remove_from_storage(target_obj,drop_location())
			else
				STR.remove_from_storage(target_obj,container)
