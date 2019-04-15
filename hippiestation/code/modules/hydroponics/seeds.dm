/obj/item/seeds/proc/get_random_reagent_id_seeds()
	var/static/list/random_reagents = list()
	if(!random_reagents.len)
		for(var/thing  in subtypesof(/datum/reagent))
			var/datum/reagent/R = thing
			if(initial(R.can_synth) && initial(R.can_synth_seeds))
				random_reagents += initial(R.id)
	var/picked_reagent = pick(random_reagents)
	return picked_reagent
