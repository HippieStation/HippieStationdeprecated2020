/mob/living/simple_animal/hostile/CanAttack(atom/the_target)
	if(search_objects < 2)
		if(istype(the_target, /obj/item/electronic_assembly))
			var/obj/item/electronic_assembly/O = the_target
			if(O.combat_circuits)
				return TRUE
	return ..()

/mob/living/simple_animal/hostile/proc/ListTargets()//Step 1, find out what we can see
	if(!search_objects)
		. = hearers(vision_range, targets_from) - src //Remove self, so we don't suicide

		var/static/hostile_machines = typecacheof(list(/obj/machinery/porta_turret, /obj/mecha, /obj/structure/destructible/clockwork/ocular_warden,/obj/item/electronic_assembly))

		for(var/HM in typecache_filter_list(range(vision_range, targets_from), hostile_machines))
			if(can_see(targets_from, HM, vision_range))
				. += HM
	else
		. = oview(vision_range, targets_from)
