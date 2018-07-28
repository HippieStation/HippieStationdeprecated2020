/obj/effect/decal/cleanable/crayon/gang
	icon = 'hippiestation/icons/effects/crayondecal.dmi'
	layer = ABOVE_NORMAL_TURF_LAYER //Harder to hide
	plane = GAME_PLANE
	do_icon_rotate = FALSE //These are designed to always face south, so no rotation please.
	var/datum/team/gang/gang

/obj/effect/decal/cleanable/crayon/gang/Initialize(mapload, datum/team/gang/G, e_name = "gang tag", rotation = 0,  mob/user)
	if(!G)
		qdel(src)
		return
	gang = G
	var/newcolor = G.color
	var/area/territory = get_area(src)
	icon_state = G.name
	G.new_territories |= list(territory.type = territory.name)
	//If this isn't tagged by a specific gangster there's no bonus income.
	..(mapload, newcolor, icon_state, e_name, rotation)

/obj/effect/decal/cleanable/crayon/gang/Destroy()
	if(gang)
		var/area/territory = get_area(src)
		gang.territories -= territory.type
		gang.new_territories -= territory.type
		gang.lost_territories |= list(territory.type = territory.name)
	return ..()