/obj/item/projectile/rod
	name = "metal rod"
	icon = 'hippiestation/icons/obj/guns/crossbow.dmi'
	icon_state = "rod_proj"
	suppressed = TRUE
	damage = 10 // multiply by how drawn the bow string is
	range = 10 // also multiply by the bow string
	damage_type = BRUTE
	flag = "bullet"
	hitsound = null // We use our own for different circumstances
<<<<<<< HEAD
	var/impale_sound = "hippiestation/sound/weapons/rodgun_pierce.ogg"
	var/hitsound_override = "bullet_impact_flesh"
=======
	var/impale_sound = 'hippiestation/sound/weapons/rodgun_pierce.ogg'
	var/hitsound_override = 'sound/weapons/pierce.ogg'
>>>>>>> 9d6960d59236aeb316c5f290b1c9757e3fe90dac
	var/charge = 0 // How much power is in the bolt, transferred from the crossbow

/obj/item/projectile/rod/on_range()
	// we didn't hit anything, place a rod here
	new /obj/item/stack/rods(get_turf(src))
	..()

obj/item/projectile/rod/proc/Impale(mob/living/carbon/human/H)
	if (H)
		var/hit_zone = H.check_limb_hit(def_zone)
		var/obj/item/bodypart/BP = H.get_bodypart(hit_zone)
		var/obj/item/stack/rods/R = new(H.loc, 1, FALSE) // Don't merge

		if (istype(BP))
			R.add_blood_DNA(H.return_blood_DNA())
			R.forceMove(H)
			BP.embedded_objects += R
			H.update_damage_overlays()
			visible_message("<span class='warning'>The [R] has embedded into [H]'s [BP]!</span>",
							"<span class='userdanger'>You feel [R] lodge into your [BP]!</span>")
			playsound(H, impale_sound, 50, 1)
			H.emote("scream")
			var/turf/T = get_step(H, dir)
			if (istype(T) && T.density && !H.pinned_to) // Can only pin someone once
				H.pinned_to = T
				T.pinned = H
				H.anchored = TRUE
				H.update_mobility()
				H.do_pindown(T, 1)
				R.pinned = T

			log_combat(firer, H, "shot", src, addition="[H.pinned_to ? " PINNED" : ""]")

/obj/item/projectile/rod/on_hit(atom/target, blocked = FALSE)
	..()
	var/volume = vol_by_damage()
	if (istype(target, /mob))
		playsound(target, impale_sound, volume, 1, -1)
		if (ishuman(target) && charge > 2) // Only fully charged shots can impale
			var/mob/living/carbon/human/H = target
			Impale(H)
		else
			new /obj/item/stack/rods(get_turf(src))
	else
		playsound(target, hitsound_override, volume, 1, -1)
		new /obj/item/stack/rods(get_turf(src))
	qdel(src)

/obj/item/projectile/plasma/watcher
	name = "freezing blast"
	icon_state = "ice_2"
	damage = 10
	flag = "energy"
	damage_type = BURN
	range = 4
	mine_range = 0
	var/temperature = -100
	dismemberment = FALSE

/obj/item/projectile/plasma/watcher/on_hit(atom/target, blocked = 0)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		L.adjust_bodytemperature(((100-blocked)/100)*(temperature - L.bodytemperature)) // the new body temperature is adjusted by 100-blocked % of the delta between body temperature and the bullet's effect temperature
