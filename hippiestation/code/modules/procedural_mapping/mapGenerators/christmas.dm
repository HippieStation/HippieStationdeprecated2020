/datum/mapGenerator/nature
	modules = list(/datum/mapGeneratorModule/bottomLayer/snowPlating, \
	/datum/mapGeneratorModule/christmas = 1, \
	/datum/mapGeneratorModule/christmasGift = 1)
	buildmode_name = "Pattern: Winter"

/datum/mapGeneratorModule/bottomLayer/snowPlating
	spawnableTurfs = list(/turf/open/floor/plating/snowed/smoothed/christmas = 80)

/datum/mapGeneratorModule/bottomLayer/snowPlating/place(turf/T)
	if(isclosedturf(T) || isspaceturf(T) || istype(T, /turf/open/pool) || istype(T, /turf/open/floor/engine) || istype(T, /turf/open/floor/holofloor) || istype(T, /turf/open/floor/plasteel/airless))
		return FALSE
	return ..()

/turf/open/floor/plating/snowed/smoothed/christmas
	intact = TRUE
	planetary_atmos = FALSE
	temperature = 293.15

/datum/mapGeneratorModule/christmas
	spawnableAtoms = list(/obj/structure/flora/tree/pine/xmas = 20, \
							/obj/structure/flora/tree/pine = 15, \
								/obj/structure/flora/tree/dead = 10)

/datum/mapGeneratorModule/christmas/place(turf/T)
	if(isplatingturf(T) || istype(T, /turf/open/pool) || istype(T, /turf/open/floor/engine) || istype(T, /turf/open/floor/holofloor) || istype(T, /turf/open/floor/plasteel/airless))
		return FALSE
	for(var/obj/structure/O in orange(1,T))
		if(get_dist(O, T) <= 1)
			return FALSE
	for(var/turf/closed/M in orange(1,T))
		if(get_dist(M, T) <= 1)
			return FALSE
	for(var/obj/machinery/light/L in GLOB.machines)
		if(prob(60) && is_station_level(L.z))
			L.add_atom_colour(pick(COLOR_RED, COLOR_GREEN, COLOR_ORANGE, COLOR_BLUE, COLOR_PINK), FIXED_COLOUR_PRIORITY)
	return ..()

/datum/mapGeneratorModule/christmasGift
	spawnableAtoms = list(/obj/item/a_gift = 3)