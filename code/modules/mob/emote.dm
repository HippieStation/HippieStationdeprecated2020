//The code execution of the emote datum is located at code/datums/emotes.dm
/mob/proc/emote(act, m_type = null, message = null)
	act = lowertext(act)
	var/param = message
	var/custom_param = findchar(act, " ")
	if(custom_param)
		param = copytext(act, custom_param + 1, length(act) + 1)
		act = copytext(act, 1, custom_param)

	var/datum/emote/E
	E = E.emote_list[act]
	if(!E)
		to_chat(src, "<span class='notice'>Unusable emote '[act]'. Say *help for a list.</span>")
		return
	E.run_emote(src, param, m_type)

/datum/emote/flip
	key = "flip"
	key_third_person = "flips"
	restraint_check = TRUE
	mob_type_allowed_typecache = list(/mob/living, /mob/dead/observer)
	mob_type_ignore_stat_typecache = list(/mob/dead/observer)

/datum/emote/flip/run_emote(mob/user, params)
	. = ..()
	if(.)
		user.SpinAnimation(7,1)

		// Hippie Start - Throw some hats
		if (istype(user, /mob/living/carbon/))
			var/mob/living/carbon/C = user
			var/obj/item/clothing/head/H = C.head

			if (H && istype(H))
				if (prob(33) && LAZYLEN(H.stacked_hats) > 0)
					var/remove_hats = 1 + rand(1, 3)

					while (remove_hats >= 1)
						remove_hats -= 1

						var/obj/item/clothing/head/J = pop(H.stacked_hats)

						if (istype(J))
							J.forceMove(C.loc)

							var/turf/target = get_turf(C.loc)
							var/range = rand(2, J.throw_range)

							for (var/i = 1; i < range; i++)
								var/turf/new_turf = get_step(target, pick(GLOB.cardinals))
								target = new_turf
								if (new_turf.density)
									break

							J.throw_at(target, J.throw_range, J.throw_speed)
					H.update_overlays()
					H.update_name()
					C.update_inv_head()
		// Hippie End

/datum/emote/spin
	key = "spin"
	key_third_person = "spins"
	restraint_check = TRUE
	mob_type_allowed_typecache = list(/mob/living, /mob/dead/observer)
	mob_type_ignore_stat_typecache = list(/mob/dead/observer)

/datum/emote/spin/run_emote(mob/user)
	. = ..()
	if(.)
		user.spin(20, 1)

		if(iscyborg(user) && user.has_buckled_mobs())
			var/mob/living/silicon/robot/R = user
			GET_COMPONENT_FROM(riding_datum, /datum/component/riding, R)
			if(riding_datum)
				for(var/mob/M in R.buckled_mobs)
					riding_datum.force_dismount(M)
			else
				R.unbuckle_all_mobs()

		// Hippie Start - Throw some hats
		if (istype(user, /mob/living/carbon/))
			var/mob/living/carbon/C = user
			var/obj/item/clothing/head/H = C.head

			if (H && istype(H))
				if (prob(33) && LAZYLEN(H.stacked_hats) > 0)
					var/remove_hats = 1 + rand(1, 3)

					while (remove_hats >= 1)
						remove_hats -= 1

						var/obj/item/clothing/head/J = pop(H.stacked_hats)

						if (istype(J))
							J.forceMove(C.loc)

							var/turf/target = get_turf(C.loc)
							var/range = rand(2, J.throw_range)

							for (var/i = 1; i < range; i++)
								var/turf/new_turf = get_step(target, pick(GLOB.cardinals))
								target = new_turf
								if (new_turf.density)
									break

							J.throw_at(target, J.throw_range, J.throw_speed)
					H.update_overlays()
					H.update_name()
					C.update_inv_head()
		// Hippie End