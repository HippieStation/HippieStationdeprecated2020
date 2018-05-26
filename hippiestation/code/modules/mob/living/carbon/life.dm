/mob/living/carbon/breathe()
	if(!getorganslot("breathing_tube"))
		if(pulledby && pulledby.grab_state == GRAB_KILL)
			adjustOxyLoss(1)
	..()

/mob/living/carbon/handle_brain_damage()
	for(var/T in get_traumas())
		var/datum/brain_trauma/BT = T
		BT.on_life()

/mob/living/carbon/liver_failure()
	reagents.metabolize(src, can_overdose=FALSE, liverless = TRUE)
	if(has_trait(TRAIT_STABLEHEART))
		return
	adjustToxLoss(rand(1,8), TRUE,  TRUE)	//Made liver damage change from a range of 1-8 per tick, otherwise liver failure = instant death
	if(prob(30))
		to_chat(src, "<span class='notice'>You feel confused and nauseous...</span>")//actual symptoms of liver failure
