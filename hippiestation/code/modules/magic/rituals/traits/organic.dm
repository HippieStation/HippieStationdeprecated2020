/datum/magic_trait/organic
	name = "Organic"
	typecache = list(
		/obj/item/reagent_containers/food/snacks/grown,
		/obj/item/reagent_containers/food/snacks/meat
	)

/datum/magic_trait/organic/has_trait(atom/thing)
	if(isliving(thing))
		var/mob/living/L = thing
		return L.stat == DEAD
	return ..()
