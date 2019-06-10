/obj/item/seeds/berry/glow/Initialize()
	. = ..()
	var/datum/plant_gene/trait/noreact/T = new
	if(prob(10))
		genes += T
	else
		qdel(T)