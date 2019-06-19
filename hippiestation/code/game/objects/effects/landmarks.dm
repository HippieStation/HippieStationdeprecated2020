/obj/effect/landmark/start/infiltrator
	name = "infiltrator"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "snukeop_spawn"

/obj/effect/landmark/start/infiltrator/Initialize()
	..()
	GLOB.infiltrator_start += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/start/infiltrator_objective
	name = "infiltrator objective items"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "random_loot"

/obj/effect/landmark/start/infiltrator_objective/Initialize()
	..()
	GLOB.infiltrator_objective_items += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/start/thanos
	name = "thanos start"

/obj/effect/landmark/start/thanos/Initialize()
	..()
	GLOB.thanos_start += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/start/thanos_portal
	name = "thanos portal"

/obj/effect/landmark/start/thanos_portal/Initialize()
	..()
	GLOB.thanos_portal += loc
	return INITIALIZE_HINT_QDEL
