/datum/reagents
	var/chem_pressure = 0
	var/chem_radioactivity = 0
	var/chem_bluespaced = FALSE
	var/chem_centrifuged = FALSE

/proc/get_random_toxin_reagent_id()	// Returns a random toxin reagent ID minus blacklisted reagents
	var/static/list/random_reagents = list()
	if(!random_reagents.len)
		for(var/thing  in subtypesof(/datum/reagent/toxin))
			var/datum/reagent/RT = thing
			if(initial(RT.can_synth))
				random_reagents += initial(RT.id)
	var/picked_reagent = pick(random_reagents)
	return picked_reagent

/datum/reagents/proc/handle_reactions()
	var/list/cached_reagents = reagent_list
	var/list/cached_reactions = GLOB.chemical_reactions_list
	var/datum/cached_my_atom = my_atom
	if(flags & REAGENT_NOREACT)
		return //Yup, no reactions here. No siree.

	var/reaction_occurred = 0
	do
		reaction_occurred = 0
		for(var/reagent in cached_reagents)
			var/datum/reagent/R = reagent
			for(var/reaction in cached_reactions[R.id]) // Was a big list but now it should be smaller since we filtered it with our reagent id
				if(!reaction)
					continue

				var/datum/chemical_reaction/C = reaction
				var/list/cached_required_reagents = C.required_reagents
				var/total_required_reagents = cached_required_reagents.len
				var/total_matching_reagents = 0
				var/list/cached_required_catalysts = C.required_catalysts
				var/total_required_catalysts = cached_required_catalysts.len
				var/total_matching_catalysts= 0
				var/matching_container = 0
				var/matching_other = 0
				var/list/multipliers = new/list()
				var/required_temp = C.required_temp
				var/is_cold_recipe = C.is_cold_recipe
				var/meets_temp_requirement = 0
				var/centrifuge_recipe = C.centrifuge_recipe
				var/pressure_required = C.pressure_required
				var/radioactivity_required = C.radioactivity_required
				var/bluespace_recipe = C.bluespace_recipe
				var/list/cached_results = C.results

				var/list/cachetype = typecacheof(list(/obj/item/slime_extract, C.required_container))

				for(var/B in cached_required_reagents)
					if(!has_reagent(B, cached_required_reagents[B]))
						break
					total_matching_reagents++
					multipliers += round(get_reagent_amount(B) / cached_required_reagents[B])
				for(var/B in cached_required_catalysts)
					if(!has_reagent(B, cached_required_catalysts[B]))
						break
					total_matching_catalysts++
				if(cached_my_atom)
					if(!C.required_container)
						matching_container = 1

					else
						if(is_type_in_typecache(cached_my_atom, cachetype))
							matching_container = 1
					if (isliving(cached_my_atom)) //Makes it so certain chemical reactions don't occur in mobs
						if (C.mob_react)
							return
					if(!C.required_other)
						matching_other = 1

					else if(istype(cached_my_atom, /obj/item/slime_extract))
						var/obj/item/slime_extract/M = cached_my_atom

						if(M.Uses > 0) // added a limit to slime cores -- Muskets requested this
							matching_other = 1
				else
					if(!C.required_container)
						matching_container = 1
					if(!C.required_other)
						matching_other = 1

				if(required_temp == 0 || (is_cold_recipe && chem_temp <= required_temp) || (!is_cold_recipe && chem_temp >= required_temp))
					meets_temp_requirement = 1

				if(centrifuge_recipe == TRUE)
					if(!chem_centrifuged)
						continue

				if(bluespace_recipe == TRUE)
					if(!chem_bluespaced)
						continue

				if(total_matching_reagents == total_required_reagents && total_matching_catalysts == total_required_catalysts && matching_container && matching_other && meets_temp_requirement && chem_pressure >= pressure_required && chem_radioactivity >= radioactivity_required)
					var/multiplier = min(multipliers)
					for(var/B in cached_required_reagents)
						remove_reagent(B, (multiplier * cached_required_reagents[B]), safety = 1)

					for(var/P in C.results)
						SSblackbox.add_details("chemical_reaction", "[P]|[cached_results[P]*multiplier]")
						multiplier = max(multiplier, 1) //this shouldnt happen ...
						add_reagent(P, cached_results[P]*multiplier, null, chem_temp)

					var/list/seen = viewers(4, get_turf(my_atom))
					var/iconhtml = icon2html(cached_my_atom, seen)
					if(cached_my_atom)
						if(!ismob(cached_my_atom)) // No bubbling mobs
							if(C.mix_sound)
								playsound(get_turf(cached_my_atom), C.mix_sound, 80, 1)
							for(var/mob/M in seen)
								to_chat(M, "<span class='notice'>[iconhtml] [C.mix_message]</span>")

						if(istype(cached_my_atom, /obj/item/slime_extract))
							var/obj/item/slime_extract/ME2 = my_atom
							ME2.Uses--
							if(ME2.Uses <= 0) // give the notification that the slime core is dead
								for(var/mob/M in seen)
									to_chat(M, "<span class='notice'>[iconhtml] \The [my_atom]'s power is consumed in the reaction.</span>")
									ME2.name = "used slime extract"
									ME2.desc = "This extract has been used up."

					C.on_reaction(src, multiplier)
					reaction_occurred = 1
					break

	while(reaction_occurred)
	update_total()
	return 0
