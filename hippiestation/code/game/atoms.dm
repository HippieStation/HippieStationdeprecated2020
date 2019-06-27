/atom
	var/icon_hippie
	var/next_spam_shot = 0

/atom/proc/wake_liquids()
	for(var/obj/effect/liquid/L in orange(1, src))
		L.activate()

/atom/Destroy()
	if(alternate_appearances)
		for(var/K in alternate_appearances)
			var/datum/atom_hud/alternate_appearance/AA = alternate_appearances[K]
			AA.remove_from_hud(src)

	if(reagents)
		qdel(reagents)

	orbiters = null // The component is attached to us normaly and will be deleted elsewhere

	LAZYCLEARLIST(overlays)
	LAZYCLEARLIST(priority_overlays)

	QDEL_NULL(light)

	if(density)
		wake_liquids()

	return ..()

/atom/proc/check_hippie_icon()
	if (!icon || !icon_state || !icon_hippie)
		return
	if (length(icon_hippie) <= 0)
		return
	if (!is_string_in_list(icon_state, icon_states(icon_hippie)))
		return
	icon = icon_hippie

/atom/Initialize()
	. = ..()
	check_hippie_icon()
