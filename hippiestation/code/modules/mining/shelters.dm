/datum/map_template/shelter/dwarf
	name = "Dwarf Fortress"
	shelter_id = "dwarfort-tier0"
	description = "A basic, portable, and shitty dwarf fortress. You can't live in this for long, you'll need to expand."
	mappath = "_maps/templates/dwarf/dwarf-fort-tier0.dmm"

/datum/map_template/shelter/dwarf/New()
	. = ..()
	whitelisted_turfs = typecacheof(/turf/closed/mineral)
	banned_objects = typecacheof(/obj/structure/stone_tile)