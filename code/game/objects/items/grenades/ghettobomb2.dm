//improvised explosives//

/obj/item/grenade/iedcasing2
	name = "improvised firebomb"
	desc = "A weak, improvised incendiary device."
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/grenade.dmi'
	icon_state = "improvised_grenade"
	item_state = "flashbang"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	throw_speed = 3
	throw_range = 7
	flags_1 = CONDUCT_1
	slot_flags = SLOT_BELT
	active = 0
	det_time = 50
	display_timer = 0
	var/range = 3
	var/list/times

/obj/item/grenade/iedcasing2/Initialize()
	. = ..()
	add_overlay("improvised_grenade_filled")
	add_overlay("improvised_grenade_wired")
	times = list("5" = 10, "-1" = 20, "[rand(30,80)]" = 50, "[rand(65,180)]" = 20)// "Premature, Dud, Short Fuse, Long Fuse"=[weighting value]
	det_time = text2num(pickweight(times))
	if(det_time < 0) //checking for 'duds'
		range = 1
		det_time = rand(30,80)
	else
		range = pick(2,2,2,3,3,3,4)

/obj/item/grenade/iedcasing2/CheckParts(list/parts_list)
	..()
	var/obj/item/reagent_containers/food/drinks/soda_cans/can = locate() in contents
	if(can)
		can.pixel_x = 0 //Reset the sprite's position to make it consistent with the rest of the IED
		can.pixel_y = 0
		var/mutable_appearance/can_underlay = new(can)
		can_underlay.layer = FLOAT_LAYER
		can_underlay.plane = FLOAT_PLANE
		underlays += can_underlay


/obj/item/grenade/iedcasing2/attack_self(mob/user) //
	if(!active)
		if(clown_check(user))
			to_chat(user, "<span class='warning'>You light the [name]!</span>")
			cut_overlay("improvised_grenade_filled")
			preprime(user, null, FALSE)

/obj/item/grenade/iedcasing2/proc/vortex(turf/T, setting_type, range)
	for(var/atom/movable/X in orange(range, T))
		if(istype(X, /obj/effect))
			continue
		if(!X.anchored)
			var/distance = get_dist(X, T)
			var/moving_power = max(range - distance, 1)
			if(moving_power > 2) //if the vortex is powerful and we're close, we get thrown
				if(setting_type)
					var/atom/throw_target = get_edge_target_turf(X, get_dir(X, get_step_away(X, T)))
					X.throw_at(throw_target, moving_power, 1)
				else
					X.throw_at(T, moving_power, 1)
			else
				spawn(0) //so everything moves at the same time.
					if(setting_type)
						for(var/i = 0, i < moving_power, i++)
							sleep(2)
							if(!step_away(X, T))
								break
					else
						for(var/i = 0, i < moving_power, i++)
							sleep(2)
							if(!step_towards(X, T))
								break

/obj/item/grenade/iedcasing2/prime() //Blowing that can up
	update_mob()
	explosion(src.loc,-1,0,4, flame_range = 6, flash_range = 2)	// small explosion, plus a very large fireball and flash
	var/turf/T = get_turf(src)
	vortex(T, 1, 6) // knockback
	qdel(src)

/obj/item/grenade/iedcasing2/examine(mob/user)
	..()
	to_chat(user, "You can't tell when it will explode!")
