/obj/machinery/processor/slime/process_food(datum/food_processor_process/recipe, atom/movable/what)
	var/mob/living/simple_animal/slime/S = what
	var/mob/living/carbon/monkey/M = what
	if (istype(S))
		var/C = S.cores
		if(S.stat != DEAD)
			S.forceMove(drop_location())
			S.visible_message("<span class='notice'>[C] crawls free of the processor!</span>")
			return
		for(var/i in 1 to (C+rating_amount-1))
			var/atom/movable/item = new S.coretype(drop_location())
			adjust_item_drop_location(item)
			SSblackbox.record_feedback("tally", "slime_core_harvested", 1, S.colour)
	else if (istype(M))
		var/C = M
		if(M.stat != DEAD)
			M.forceMove(drop_location())
			M.visible_message("<span class='notice'>[C] crawls free of the processor!</span>")
			return
		var/obj/bucket = new /obj/item/reagent_containers/glass/bucket(loc)
		var/datum/reagent/blood/B = new()
		B.holder = bucket
		B.volume = 70
		//set reagent data
		B.data["donor"] = M
		if(M.has_dna())
			B.data["blood_DNA"] = M.dna.unique_enzymes
		bucket.reagents.reagent_list += B
		bucket.reagents.update_total()
		bucket.on_reagent_change()
		//bucket_of_blood.reagents.handle_reactions() //blood doesn't react
	..()
	
/obj/machinery/processor/slime/interact(mob/user)
	if(processing)
		to_chat(user, "<span class='warning'>[src] is in the process of processing!</span>")
		return TRUE
	if(user.a_intent == INTENT_GRAB && ismob(user.pulling) && select_recipe(user.pulling))
		if(user.grab_state < GRAB_AGGRESSIVE)
			to_chat(user, "<span class='warning'>You need a better grip to do that!</span>")
			return
		var/mob/living/pushed_mob = user.pulling
		user.visible_message("[user] put [pushed_mob] into [src].", \
			"You put [pushed_mob] into [src].")
		pushed_mob.forceMove(src)
		user.stop_pulling()
		return TRUE
	else if (ismob(user.pulling))
		if(user.a_intent != INTENT_HARM)
			to_chat(user, "<span class='warning'>That probably won't blend!</span>")
			return TRUE
		else
			return ..()
	if(contents.len == 0)
		to_chat(user, "<span class='warning'>[src] is empty!</span>")
		return TRUE
	processing = TRUE
	user.visible_message("[user] turns on [src].", \
		"<span class='notice'>You turn on [src].</span>", \
		"<span class='italics'>You hear a food processor.</span>")
	playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
	use_power(500)
	var/total_time = 0
	for(var/O in src.contents)
		var/datum/food_processor_process/P = select_recipe(O)
		if (!P)
			log_admin("DEBUG: [O] in processor doesn't have a suitable recipe. How did it get in there? Please report it immediately!!!")
			continue
		total_time += P.time
	var/offset = prob(50) ? -2 : 2
	animate(src, pixel_x = pixel_x + offset, time = 0.2, loop = (total_time / rating_speed)*5) //start shaking
	sleep(total_time / rating_speed)
	for(var/atom/movable/O in src.contents)
		var/datum/food_processor_process/P = select_recipe(O)
		if (!P)
			log_admin("DEBUG: [O] in processor doesn't have a suitable recipe. How do you put it in?")
			continue
		process_food(P, O)
	pixel_x = initial(pixel_x) //return to its spot after shaking
	processing = FALSE
	visible_message("\The [src] finishes processing.")
