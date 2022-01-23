/mob/living/carbon
	var/fist_casted = FALSE

/mob/living/carbon/proc/reset_fist_casted()
	if(fist_casted)
		fist_casted = FALSE

/mob/living/carbon/update_sight()
	. = ..()
	if(mind)
		var/datum/antagonist/vampire/V = mind.has_antag_datum(/datum/antagonist/vampire)
		if(V)
			if(V.get_ability(/datum/vampire_passive/full))
				sight |= (SEE_TURFS|SEE_MOBS|SEE_OBJS)
				see_in_dark = max(see_in_dark, 8)
			else if(V.get_ability(/datum/vampire_passive/vision))
				sight |= (SEE_MOBS)

/mob/living/carbon/proc/throw_hats(var/how_many, var/list/throw_directions)
	// Using a list so random directions are possible for all the hats we're trying to throw
	if (how_many <= 0 || LAZYLEN(throw_directions) <= 0 || !head)
		return

	var/obj/item/clothing/head/Hat = head

	if (!istype(Hat))
		return

	if (LAZYLEN(Hat.stacked_hats) <= 0)
		return

	if (how_many > LAZYLEN(Hat.stacked_hats))
		how_many = LAZYLEN(Hat.stacked_hats)

	while (how_many > 0)
		how_many -= 1
		var/obj/item/clothing/head/J = pop(Hat.stacked_hats)

		if (istype(J))
			J.forceMove(loc)

			// Taken from the knock_out_teeth() proc because we want similar behaviour
			var/turf/target = get_turf(loc)
			var/range = rand(2, J.throw_range)

			for (var/i = 1; i < range; i++)
				var/turf/new_turf = get_step(target, pick(throw_directions))
				target = new_turf
				if (new_turf.density)
					break

			J.throw_at(target, J.throw_range, J.throw_speed)

	Hat.update_overlays()
	Hat.update_name()
	update_inv_head()

/mob/living/carbon/fall(forced)
	if(loc)
		..()

/mob/living/carbon/human/prevent_content_explosion()
	if(status_flags & GODMODE)
		return TRUE
	..()
