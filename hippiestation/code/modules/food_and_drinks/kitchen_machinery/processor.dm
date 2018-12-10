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
		for(var/datum/disease/D in M.viruses)
			if(!(D.spread_flags & SPECIAL))
				B.data["viruses"] += D.Copy()
		if(M.has_dna())
			B.data["blood_DNA"] = M.dna.unique_enzymes
		if(M.resistances&&M.resistances.len)
			B.data["resistances"] = M.resistances.Copy()
		bucket.reagents.reagent_list += B
		bucket.reagents.update_total()
		bucket.on_reagent_change()
		//bucket_of_blood.reagents.handle_reactions() //blood doesn't react
	..()
