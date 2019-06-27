#define SPACE_REAGENTS_PER_TICK 20.75 // SSprocessing only does one tick per second.
GLOBAL_VAR_INIT(space_reagent, null)
GLOBAL_LIST_INIT(space_reagents_blacklist, typecacheof(list(/turf/open/floor/plasteel/airless/solarpanel)))
GLOBAL_LIST_INIT(space_reagents_can_pass_anyways, typecacheof(list(/obj/structure/grille, /obj/structure/barricade/security)))
GLOBAL_LIST_INIT(space_reagents_blacklist_areas, typecacheof(list(/area/hippie/singularity_gen)))

/turf/open/space/proc/is_actually_next_to_something()
	if(!is_station_level(z))
		return FALSE
	for(var/turf/T in range(1, src))
		if(!isspaceturf(T))
			return TRUE
	return FALSE

/turf/open/space/Initialize()
	. = ..()
	if(is_station_level(z))
		START_PROCESSING(SSprocessing, src)

/turf/open/space/examine(mob/user)
	. = ..()
	if(is_station_level(z) && GLOB.space_reagent)
		var/datum/reagent/R = GLOB.chemical_reagents_list[GLOB.space_reagent]
		to_chat(user, "<span class='notice'>It appears to be made of [R.name].</span>")

/turf/open/space/process()
	if(!is_actually_next_to_something())
		return
	if(GLOB.space_reagent)
		for(var/turf/open/T in range(1, src))
			var/area/AR = get_area(T)
			if(isspaceturf(T) || is_type_in_typecache(AR, GLOB.space_reagents_blacklist_areas))
				continue
			var/moist = FALSE
			var/can_spawn_liquid = TRUE
			T.elevation = ELEVATION_HIGH+3 // you cannot escape the SPACE FLOOD that easily! (a hack to ensure space floods don't get stuck on plating)
			for(var/A in T.contents)
				if(is_type_in_typecache(A, GLOB.space_reagents_blacklist))
					can_spawn_liquid = FALSE
					break
				if(istype(A, /obj))
					var/obj/O = A
					if(!O.CanPass() && !is_type_in_typecache(O, GLOB.space_reagents_can_pass_anyways))
						can_spawn_liquid = FALSE
						break
				if(istype(A, /obj/effect/liquid) && can_spawn_liquid)
					var/obj/effect/liquid/L = A
					moist = TRUE
					if(L.reagents)
						L.reagents.add_reagent(GLOB.space_reagent, SPACE_REAGENTS_PER_TICK)
						L.depth = CLAMP(L.depth + (SPACE_REAGENTS_PER_TICK / REAGENT_TO_DEPTH), 0, MAX_INITIAL_DEPTH)
						L.update_depth()
					INVOKE_ASYNC(L, /obj/effect/liquid.proc/equilibrate)
			if(!moist && can_spawn_liquid)
				var/obj/effect/liquid/W = new /obj/effect/liquid(T)
				W.reagents.add_reagent(GLOB.space_reagent, SPACE_REAGENTS_PER_TICK)
				W.depth = max(SPACE_REAGENTS_PER_TICK / REAGENT_TO_DEPTH, 0)
				if(W.depth <= 0)
					return
				W.update_depth()
				INVOKE_ASYNC(W, /obj/effect/liquid.proc/equilibrate)
