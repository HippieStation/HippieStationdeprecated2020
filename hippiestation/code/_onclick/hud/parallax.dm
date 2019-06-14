/obj/screen/parallax_layer/Initialize(mapload, view)
	. = ..()
	if(GLOB.space_reagent)
		var/datum/reagent/R = GLOB.chemical_reagents_list[GLOB.space_reagent]
		if(R && R.color)
			color = R.color
