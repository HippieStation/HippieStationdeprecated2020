//For miscellaneous Facepunch-specific floors.

/turf/open/floor/plasteel/facepunch		//Parent, subtypes to follow
	icon = 'face/icons/turfs/open/floors.dmi'
	icon_state = "floor"

/turf/open/floor/plasteel/facepunch/dark
	icon_state = "dark"

/turf/open/floor/plasteel/facepunch/white
	icon_state = "white"

/turf/open/floor/plasteel/facepunch/green
	icon_state = "green"

/turf/open/floor/plasteel/facepunch/green/full
	icon_state = "greenfull"

/turf/open/floor/plasteel/facepunch/blue
	icon_state = "blue"

/turf/open/floor/plasteel/facepunch/blue/full
	icon_state = "bluefull"

/turf/open/floor/plasteel/facepunch/purple
	icon_state = "pr"

/turf/open/floor/plasteel/facepunch/purple/full
	icon_state = "prfull"

/turf/open/floor/plasteel/facepunch/cargo
	icon_state = "cargo"

/turf/open/floor/plasteel/facepunch/cargo/full
	icon_state = "cargofull"

/turf/open/floor/plasteel/facepunch/security
	icon_state = "sec"

/turf/open/floor/plasteel/facepunch/security/full
	icon_state = "secfull"

//facepunch-specific mineral turfs

/turf/closed/mineral/random/low_chance/volcanic
	environment_type = "basalt"
	turf_type = /turf/open/floor/plating/asteroid/basalt/lava_land_surface
	baseturfs = /turf/open/floor/plating/asteroid/basalt/lava_land_surface
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	defer_change = 1