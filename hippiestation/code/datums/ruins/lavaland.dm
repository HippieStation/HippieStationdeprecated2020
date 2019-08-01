/datum/map_template/ruin/lavaland/stand_arrow
	name = "Nijimura's Attic"
	id = "stand-arrow"
	suffix = "lavaland_surface_stand.dmm"
	cost = 20
	allow_duplicates = FALSE

/datum/map_template/ruin/lavaland/stand_arrow/New()
	..()
	if(prob(1))
		allow_duplicates = TRUE
