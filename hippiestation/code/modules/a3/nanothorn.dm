/obj/item/melee/nanothorn
	name = "nanothorn blade"
	desc = "An experimental blade, capable of easily severing molecular bonds and achieving maximum damage."
	icon_state = "nanothorn"
	icon = 'hippiestation/icons/obj/items_and_weapons.dmi'
	hitsound = 'sound/weapons/etherealhit.ogg'
	force = 35
	w_class = WEIGHT_CLASS_BULKY
	armour_penetration = 100
	sharpness = IS_SHARP_ACCURATE
	hitsound = 'sound/weapons/rapierhit.ogg'
	materials = list(MAT_METAL = 10000)
	interact_sound_cooldown = 100
	light_color = "#40ceff"
	var/slicing = FALSE

/obj/item/melee/nanothorn/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(slicing)
		return
	if(istype(target, /turf/closed/wall))
		slicing = TRUE
		if(do_after(user, 4, FALSE, target))
			var/turf/closed/wall/W = target
			user.visible_message("<span class='danger'>[user] slices through [W] with [src]!</span>")
			var/turf/T = W.ScrapeAway()
			if(T)
				new /obj/effect/decal/cleanable/molten_object/large(T)
		slicing = FALSE
	else if(isobj(target) && !isitem(target))
		var/obj/O = target
		if(O.resistance_flags & INDESTRUCTIBLE)
			return
		slicing = TRUE
		if(do_after(user, 4, FALSE, O))
			user.visible_message("<span class='danger'>[user] slices through [O] with [src]!</span>")
			new /obj/effect/decal/cleanable/molten_object(get_turf(O))
			O.take_damage(INFINITY)
		slicing = FALSE
