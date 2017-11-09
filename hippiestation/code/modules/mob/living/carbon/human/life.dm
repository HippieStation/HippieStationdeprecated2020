
//After notransform is checked!
/mob/living/carbon/human/proc/OnHippieLifeAfterNoTransform()
	if(client)
		if(jobban_isbanned(src, CATBAN) && src.dna.species.name != "Catbeast") //Jobban checks here
			set_species(/datum/species/tarajan, icon_update=1)
		if(jobban_isbanned(src, CLUWNEBAN) && !dna.check_mutation(CLUWNEMUT))
			dna.add_mutation(CLUWNEMUT)
		if(hud_used)
			if(hud_used.staminas)
				hud_used.staminas.icon_state = staminahudamount()
			if(mind && hud_used.combo_object && hud_used.combo_object.cooldown < world.time)
				hud_used.combo_object.update_icon()
				mind.martial_art.streak = ""

/mob/living/carbon/human/handle_embedded_objects()
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		for(var/obj/item/I in BP.embedded_objects)
			if(prob(I.embedded_pain_chance))
				BP.receive_damage(I.w_class*I.embedded_pain_multiplier)
				to_chat(src, "<span class='userdanger'>[I] embedded in your [BP.name] hurts!</span>")

			if(prob(I.embedded_fall_chance))
				BP.receive_damage(I.w_class*I.embedded_fall_pain_multiplier)
				BP.embedded_objects -= I
				I.loc = get_turf(src)
				visible_message("<span class='danger'>[I] falls out of [name]'s [BP.name]!</span>","<span class='userdanger'>[I] falls out of your [BP.name]!</span>")
				if(!has_embedded_objects())
					clear_alert("embeddedobject")

			if (I.loc != src)
				BP.embedded_objects -= I

				if (I.pinned)
					do_pindown(pinned_to, 0)
					pinned_to = null
					anchored = 0
					update_canmove()
					I.pinned = null