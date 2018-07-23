/obj/item/toy/crayon
	var/gang = FALSE //For marking territory

/obj/item/toy/crayon/proc/hippie_gang_check(mob/user, atom/target) // hooked into afterattack
		// If a gang member is using a gang spraycan, it'll behave differently
	var/gang_mode = FALSE
	if(gang && user.mind && user.mind.has_antag_datum(/datum/antagonist/gang))
		gang_mode = TRUE

	// discontinue if the area isn't valid for tagging because gang "honour"
	if(gang_mode && (!can_claim_for_gang(user, target)))
		return TRUE

/obj/item/toy/crayon/proc/gang_final(mob/user, atom/target) // hooked into afterattack
	// Double check it wasn't tagged in the meanwhile
	if(!can_claim_for_gang(user, target))
		return TRUE
	tag_for_gang(user, target)
	affected_turfs += target

/obj/item/toy/crayon/proc/can_claim_for_gang(mob/user, atom/target)
	// Check area validity.
	// Reject space, player-created areas, and non-station z-levels.
	var/area/A = get_area(target)
	if(!A || (!is_station_level(A.z)) || !A.valid_territory)
		to_chat(user, "<span class='warning'>[A] is unsuitable for tagging.</span>")
		return FALSE

	var/spraying_over = FALSE
	for(var/obj/effect/decal/cleanable/crayon/gang/G in target)
		spraying_over = TRUE

	for(var/obj/machinery/power/apc in target)
		to_chat(user, "<span class='warning'>You can't tag an APC.</span>")
		return FALSE

	var/occupying_gang = territory_claimed(A, user)
	if(occupying_gang && !spraying_over)
		to_chat(user, "<span class='danger'>[A] has already been tagged by the [occupying_gang] gang! You must get rid of or spray over the old tag first!</span>")
		return FALSE

	// If you pass the gaunlet of checks, you're good to proceed
	return TRUE

/obj/item/toy/crayon/proc/territory_claimed(area/territory, mob/user)
	for(var/datum/team/gang/G in GLOB.gangs)
		if(territory.type in (G.territories|G.new_territories))
			. = G.name
			break

/obj/item/toy/crayon/proc/tag_for_gang(mob/user, atom/target)
	//Delete any old markings on this tile, including other gang tags
	for(var/obj/effect/decal/cleanable/crayon/old_marking in target)
		qdel(old_marking)

	var/gangID = user.mind.has_antag_datum(/datum/antagonist/gang)
	var/area/territory = get_area(target)

	new /obj/effect/decal/cleanable/crayon/gang(target,gangID,"graffiti",0,user)
	to_chat(user, "<span class='notice'>You tagged [territory] for your gang!</span>")

/obj/item/toy/crayon/spraycan/gang
	//desc = "A modified container containing suspicious paint."
	charges = 20
	gang = TRUE

	pre_noise = FALSE
	post_noise = TRUE

/obj/item/toy/crayon/spraycan/gang/Initialize(loc, datum/team/gang/G)
	..()
	if(G)
		paint_color = G.color
		update_icon()

/obj/item/toy/crayon/spraycan/gang/examine(mob/user)
	. = ..()
	if(user.mind && user.mind.has_antag_datum(/datum/antagonist/gang) || isobserver(user))
		to_chat(user, "This spraycan has been specially modified for tagging territory.")