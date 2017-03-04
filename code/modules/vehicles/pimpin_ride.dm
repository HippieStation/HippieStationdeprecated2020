//PIMP-CART
/obj/vehicle/janicart
	name = "janicart (pimpin' ride)"
	desc = "A brave janitor cyborg gave its life to produce such an amazing combination of speed and utility."
	icon_state = "pussywagon"

	var/obj/item/weapon/storage/bag/trash/mybag = null
	var/floorbuffer = 0

/obj/vehicle/janicart/Destroy()
	if(mybag)
		qdel(mybag)
		mybag = null
	return ..()

/obj/vehicle/janicart/buckle_mob(mob/living/buckled_mob, force = 0, check_loc = 0)
	. = ..()
	riding_datum = new/datum/riding/janicart



/obj/item/key/janitor
	desc = "A keyring with a small steel key, and a pink fob reading \"Pussy Wagon\"."
	icon_state = "keyjanitor"


/obj/item/janiupgrade
	name = "floor buffer upgrade"
	desc = "An upgrade for mobile janicarts."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "upgrade"
	origin_tech = "materials=3;engineering=4"


/obj/vehicle/janicart/Moved(atom/OldLoc, Dir)
	if(floorbuffer)
		var/turf/tile = loc
		if(isturf(tile))
			tile.clean_blood()
			for(var/A in tile)
				if(is_cleanable(A))
					qdel(A)
	. = ..()


/obj/vehicle/janicart/examine(mob/user)
	..()
	if(floorbuffer)
		user << "It has been upgraded with a floor buffer."


/obj/vehicle/janicart/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/storage/bag/trash))
		if(mybag)
			user << "<span class='warning'>[src] already has a trashbag hooked!</span>"
			return
		if(!user.drop_item())
			return
		user << "<span class='notice'>You hook the trashbag onto \the [name].</span>"
		I.loc = src
		mybag = I
		update_icon()
	else if(istype(I, /obj/item/janiupgrade))
		floorbuffer = 1
		qdel(I)
		user << "<span class='notice'>You upgrade \the [name] with the floor buffer.</span>"
		update_icon()
	else
		return ..()


/obj/vehicle/janicart/update_icon()
	cut_overlays()
	if(mybag)
		add_overlay("cart_garbage")
	if(floorbuffer)
		add_overlay("cart_buffer")

/obj/vehicle/janicart/attack_hand(mob/user)
	if(..())
		return 1
	else if(mybag)
		mybag.loc = get_turf(user)
		user.put_in_hands(mybag)
		mybag = null
		update_icon()

/obj/vehicle/lawnmower
	name = "lawn mower"
	desc = "Equipped with realiable safeties to prevent <i>accidents</i> in the workplace."
	icon = 'icons/hippie/obj/vehicles.dmi'
	icon_state = "lawnmower"
	var/emagged = FALSE
	var/list/drive_sounds = list('sound/effects/mowermove1.ogg', 'sound/effects/mowermove2.ogg')
	var/list/gib_sounds = list('sound/effects/mowermovesquish.ogg')
	var/driver

/obj/vehicle/lawnmower/emagged
	emagged = TRUE

/obj/vehicle/lawnmower/emag_act(mob/user)
	if(emagged)
		user << "<span class='warning'>The safety mechanisms on \the [src] are already disabled!</span>"
		return
	user << "<span class='warning'>You disable the safety mechanisms on \the [src].</span>"
	emagged = TRUE

/obj/vehicle/lawnmower/buckle_mob(mob/living/buckled_mob, force = 0, check_loc = 0)
	. = ..()
	riding_datum = new/datum/riding/lawnmower

/obj/vehicle/lawnmower/Bump(atom/A)
	if(emagged)
		if(isliving(A))
			var/mob/living/M = A
			M.adjustBruteLoss(25)
			var/atom/newLoc = get_edge_target_turf(M, get_dir(src, get_step_away(M, src)))
			M.throw_at(newLoc, 4, 1)

/obj/vehicle/lawnmower/Move()
	..()
	var/gibbed = FALSE
	var/mob/living/carbon/H

	if(has_buckled_mobs())
		H = buckled_mobs[1]

	if(emagged)
		for(var/mob/living/carbon/human/M in loc)
			if(M == H)
				continue
			if(M.lying)
				visible_message("<span class='danger'>\the [src] grinds [M.name] into a fine paste!</span>")
				M.gib()
				shake_camera(M, 20, 1)
				gibbed = TRUE

	if(gibbed)
		shake_camera(H, 10, 1)
		playsound(loc, pick(gib_sounds), 75, 1)
	else
		playsound(loc, pick(drive_sounds), 75, 1)