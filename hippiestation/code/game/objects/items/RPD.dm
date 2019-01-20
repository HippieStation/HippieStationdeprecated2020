GLOBAL_LIST_INIT(plumbing_recipes, list(
	"Plumbing" = list(
		new /datum/pipe_info/plumbing("Liquid Drain", /obj/structure/drain_assembly),
	)
))

/datum/pipe_info/plumbing/New(label, obj/path, dr = PIPE_ONEDIR)
	name = label
	id = path
	icon_state = initial(path.icon_state)
	dirtype = dr


/obj/item/pipe_dispenser
	var/static/datum/pipe_info/first_plumbing

/obj/item/pipe_dispenser/Initialize()
	. = ..()
	if(!first_plumbing)
		first_plumbing = GLOB.plumbing_recipes[GLOB.plumbing_recipes[1]][1]