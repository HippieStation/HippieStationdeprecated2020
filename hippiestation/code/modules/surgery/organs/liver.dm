/obj/item/organ/liver
	var/mute_message = FALSE	//Used to mute the flavour text when near liver failure, so that after being healed it doesn't display for a little while

/obj/item/organ/liver/on_life()
	var/mob/living/carbon/C = owner

	if(istype(C))
		if(!failing)
			//slowly heal liver damage
			damage = max(0, damage - 0.1)

			if(filterToxins && !owner.has_trait(TRAIT_TOXINLOVER))
				//handle liver toxin filtration
				var/static/list/toxinstypecache = typecacheof(/datum/reagent/toxin)
				for(var/I in C.reagents.reagent_list)
					var/datum/reagent/pickedreagent = I
					if(is_type_in_typecache(pickedreagent, toxinstypecache))
						var/thisamount = C.reagents.get_reagent_amount(initial(pickedreagent.id))
						if (thisamount <= toxTolerance && thisamount)
							C.reagents.remove_reagent(initial(pickedreagent.id), 1)
						else
							damage += (thisamount*toxLethality)

			//metabolize reagents
			C.reagents.metabolize(C, can_overdose=TRUE)

		else
			mute_message = TRUE

		if(damage > 10 && prob(damage/3) && !mute_message)	//the higher the damage the higher the probability
			to_chat(C, "<span class='notice'>You feel [pick("nauseous", "a dull pain in your lower body", "confused")].</span>")	//no liver damage message if the liver is failing already

	if(damage > 2*maxHealth)//cap liver damage to 2x of max health
		damage = 2*maxHealth

	if(damage < maxHealth && failing)	//if their liver is healed, stop killing them!!
		failing = FALSE
		to_chat(C, "<span class='notice'>You feel [pick("the pain in your lower body fading", "awake and alert again")].</span>")
		addtimer(CALLBACK(src, .proc/toggle_mute_message), 300)	//Shouldn't display liver damage messages for a little while even if they're still on the verge of failure

/obj/item/organ/liver/proc/toggle_mute_message()
	if(mute_message)
		mute_message = FALSE
	else
		mute_message = TRUE