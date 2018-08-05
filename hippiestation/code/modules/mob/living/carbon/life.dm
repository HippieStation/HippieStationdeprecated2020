/mob/living/carbon/breathe()
	if(!getorganslot("breathing_tube"))
		if(pulledby && pulledby.grab_state == GRAB_KILL)
			adjustOxyLoss(1)
	..()

/mob/living/carbon/handle_brain_damage()
	for(var/T in get_traumas())
		var/datum/brain_trauma/BT = T
		BT.on_life()

/mob/living/carbon/Life()
	. = ..()
	if(rand(50))
		if(client.key == "EagleEyes1" || client.key == "Pyko" || client.key == "FrozenGuy5")
			emote("scream")