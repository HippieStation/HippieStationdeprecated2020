/obj/item/organ/liver/on_life()
	var/mob/living/carbon/C = owner

	if(istype(C))
		if(!failing || C.reagents.has_reagent("iecure"))	//can't process reagents with a failing liver - however process everything if we have the one that heals the liver
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

		if(damage > 10 && prob(damage/3) && !C.reagents.has_reagent("iecure"))	//the higher the damage the higher the probability
			to_chat(C, "<span class='notice'>You feel [pick("nauseous", "a dull pain in your lower body", "confused")].</span>")	//no liver damage message if they have the liver fixing chemical

	if(damage > maxHealth)//cap liver damage
		damage = maxHealth

	if(damage < maxHealth && failing)	//if their liver is healed, stop killing them!!
		failing = FALSE
		to_chat(C, "<span class='notice'>You feel [pick("the pain in your lower body fading", "awake and alert again")].</span>")