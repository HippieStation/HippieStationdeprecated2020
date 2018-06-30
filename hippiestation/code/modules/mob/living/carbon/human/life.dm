
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

/mob/living/carbon/human/handle_status_effects()
	..()


	if(drunkenness)
		drunkenness = max(drunkenness - (drunkenness * 0.04), 0)
		if(drunkenness >= 6)
			if(prob(25))
				slurring += 2
			jitteriness = max(jitteriness - 3, 0)

		if(drunkenness >= 11 && slurring < 5)
			slurring += 1.2
		if(mind && (mind.assigned_role == "Scientist" || mind.assigned_role == "Research Director"))
			if(SSresearch.science_tech)
				if(drunkenness >= 12.9 && drunkenness <= 13.8)
					drunkenness = round(drunkenness, 0.01)
					var/ballmer_percent = 0
					if(drunkenness == 13.35) // why run math if I dont have to
						ballmer_percent = 1
					else
						ballmer_percent = (-abs(drunkenness - 13.35) / 0.9) + 1
					if(prob(5))
						say(pick(GLOB.ballmer_good_msg))
					SSresearch.science_tech.research_points += (BALLMER_POINTS * ballmer_percent)
				if(drunkenness > 26) // by this point you're into windows ME territory
					if(prob(5))
						SSresearch.science_tech.research_points -= BALLMER_POINTS
						say(pick(GLOB.ballmer_windows_me_msg))
		if(drunkenness >= 41)
			if(prob(25))
				confused += 2
			Dizzy(10)

		if(drunkenness >= 51)
			if(prob(5))
				confused += 10
				vomit()
			Dizzy(25)

		if(drunkenness >= 61)
			if(prob(50))
				blur_eyes(5)

		if(drunkenness >= 71)
			blur_eyes(5)

		if(drunkenness >= 81)
			adjustToxLoss(0.2)
			if(prob(5) && !stat)
				to_chat(src, "<span class='warning'>Maybe you should lie down for a bit...</span>")

		if(drunkenness >= 91)
			adjustBrainLoss(0.4, 60)
			if(prob(20) && !stat)
				if(SSshuttle.emergency.mode == SHUTTLE_DOCKED && is_station_level(z)) //QoL mainly
					to_chat(src, "<span class='warning'>You're so tired... but you can't miss that shuttle...</span>")
				else
					to_chat(src, "<span class='warning'>Just a quick nap...</span>")
					Sleeping(100)	//Reduced from 900 to 100, waiting around for a minute and a half isn't fun

		if(drunkenness >= 101)
			adjustToxLoss(4) //Let's be honest you shouldn't be alive by now
