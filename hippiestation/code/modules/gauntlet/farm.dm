GLOBAL_LIST_EMPTY(thanos_start)
GLOBAL_LIST_EMPTY(thanos_portal)

/obj/effect/thanos_portal
	name = "bluespace rip"
	desc = "A mysterious rip, that seems to span time, reality, bluespace, and beyond."
	icon = 'icons/obj/objects.dmi'
	icon_state = "anom"
	resistance_flags = INDESTRUCTIBLE
	density = TRUE
	light_range = 2
	light_power = 3

/obj/effect/thanos_portal/singularity_act()
	return

/obj/effect/thanos_portal/singularity_pull()
	return

/obj/effect/thanos_portal/Bumped(atom/movable/AM)
	if(!QDELETED(AM))
		if(isliving(AM))
			var/mob/living/L = AM
			if(L.client && !L.incapacitated())
				L.visible_message("<span class='notice'>[L] starts climbing through [src]...</span>", \
				"<span class='notice'>You begin climbing through [src]...</span>")
				if(!do_after(L, 30, target = L))
					return
		if(!istype(AM, /obj/effect/))
			teleportify(AM)

/obj/effect/thanos_portal/proc/teleportify(atom/movable/AM)
	if(LAZYLEN(GLOB.thanos_portal))
		var/turf/T = get_turf(pick(GLOB.thanos_portal))
		AM.visible_message("<span class='danger'>[AM] passes through [src]!</span>", null, null, null, AM)
		AM.forceMove(T)
		AM.visible_message("<span class='danger'>[AM] materializes from the air!</span>", \
		"<span class='boldannounce'>You pass through [src] and appear somewhere unfamiliar.</span>")
		do_sparks(5, TRUE, src)
		do_sparks(5, TRUE, AM)
		if(isliving(AM))
			var/mob/living/L = AM
			L.overlay_fullscreen("flash", /obj/screen/fullscreen/flash/static)
			L.clear_fullscreen("flash", 5)
