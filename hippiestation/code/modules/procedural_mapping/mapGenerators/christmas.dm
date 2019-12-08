/datum/mapGenerator/nature
	modules = list(/datum/mapGeneratorModule/bottomLayer/snowPlating, \
	/datum/mapGeneratorModule/christmas = 1, \
	/datum/mapGeneratorModule/christmasGift = 1)
	buildmode_name = "Pattern: Winter"

/datum/mapGeneratorModule/bottomLayer/snowPlating
	spawnableTurfs = list(/turf/open/floor/plasteel/christmas = 80)

/datum/mapGeneratorModule/bottomLayer/snowPlating/place(turf/T)
	if(isclosedturf(T) || isspaceturf(T) || istype(T, /turf/open/pool) || istype(T, /turf/open/floor/engine) || istype(T, /turf/open/floor/holofloor) || istype(T, /turf/open/floor/plasteel/airless))
		return FALSE
	return ..()

/turf/open/floor/plasteel/christmas
	smooth = SMOOTH_MORE | SMOOTH_BORDER
	canSmoothWith = list(/turf/open/floor/plasteel/christmas)
	floor_tile = /obj/item/stack/tile/plasteel/christmas
	icon = 'icons/turf/floors/snow_turf.dmi'
	icon_state = "smooth"

/obj/item/stack/tile/plasteel/christmas
	name = "snowed floor tile"
	singular_name = "snowed floor tile"
	icon_state = "tile_snow"
	item_state = "tile-silver"
	turf_type = /turf/open/floor/plasteel/christmas

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

/datum/mapGeneratorModule/christmas/generate()
	for(var/obj/machinery/light/L in GLOB.machines)
		if(!is_station_level(L.z))
			continue
		if(prob(55))
			continue
		L.add_atom_colour(pick(COLOR_RED, COLOR_GREEN, COLOR_ORANGE, COLOR_BLUE, COLOR_PINK), FIXED_COLOUR_PRIORITY) //christmas colours
	return ..()

/datum/mapGeneratorModule/christmasGift
	spawnableAtoms = list(/obj/item/a_gift = 3)