/mob/living/carbon/breathe()
	if(!getorganslot("breathing_tube"))
		if(pulledby && pulledby.grab_state == GRAB_KILL)
			adjustOxyLoss(1)
	..()

/mob/living/carbon/handle_brain_damage()
	for(var/T in get_traumas())
		var/datum/brain_trauma/BT = T
		BT.on_life()

/mob/living/carbon/handle_status_effects()
	. = ..()

	if (drunkenness > 20)
		var/mob/living/carbon/human/H = src

		if (istype(H))
			var/datum/component/waddling/W = H.GetComponent(/datum/component/waddling)

			if (!W)
				H.AddComponent(/datum/component/waddling)
				to_chat(src, "<span class='warning'>Walking straight feels very hard...</span>")
				W = H.GetComponent(/datum/component/waddling)

			// minimum of 1, max of 4
			var/waddle_multi = min(max(1, drunkenness / 25), 4)

			W.waddle_min = -12 * waddle_multi
			W.waddle_max = 12 * waddle_multi
			W.z_change = 4 * waddle_multi / 2
	else
		var/has_waddle = FALSE
		for(var/datum/quirk/Q in roundstart_quirks)
			if (istype(Q, /datum/quirk/waddle))
				has_waddle = TRUE
				break

		if (!has_waddle)
			var/mob/living/carbon/human/H = src

			if (istype(H))
				var/datum/component/waddling/W = H.GetComponent(/datum/component/waddling)

				if (W)
					W.RemoveComponent()
					to_chat(src, "<span class='warning'>Walking doesn't seen so hard as you sober up</span>")