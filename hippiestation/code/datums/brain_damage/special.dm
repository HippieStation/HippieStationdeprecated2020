/datum/brain_trauma/special/cotard_delusion
	name = "Cotard Delusion"
	desc = "Patient thinks they are dead, causing them to aimlessly wander around and think they can speak with the dead."
	scan_desc = "cotard delusion"
	gain_text = "<span class='warning'>You feel incredibly cold and pale...</span>"
	lose_text = "<span class='notice'>You feel life coming back to your body!</span>"

/datum/brain_trauma/special/cotard_delusion/on_gain()
	..()
	var/mob/living/carbon/human/H = owner
	H.set_screwyhud(SCREWYHUD_DEAD)		//You're cactus, m8. Deceased. Not living. Kicked the bucket. Dead.
	H.add_client_colour(/datum/client_colour/greyscale)		//You're """dead""" so you're only seeing a discoloured version of the real world
	H.Unconscious(300)
	to_chat(H, "<span class='deadsay'>You suddenly feel all your life drain from you and you collapse!</span>")
	addtimer(CALLBACK(src, .proc/revival), 300)

/datum/brain_trauma/special/cotard_delusion/proc/revival()
	var/mob/living/carbon/human/H = owner
	to_chat(H, "<div style='font-size: 30px; font-weight: bold; font-style: italic; color: #5c00e6'> You feel yourself coming back, but something isn't right. You haven't been given release from your body, and are cursed to wander with it forever!</div>")
	playsound(H, 'sound/hallucinations/far_noise.ogg', 50, 1)
	H.toggle_ghostvision()	//As soon as we can see ghosts, you will be able to see their deadchat as well - UNLESS you don't have the medium trait
	H.add_trait(TRAIT_MEDIUM, TRAUMA_TRAIT)	//This will stop them from talking to people and instead talk to deadchat
	H.add_trait(TRAIT_DEAF, TRAUMA_TRAIT)	//Needed to mute the chat

/datum/brain_trauma/special/cotard_delusion/on_life()
	..()
	var/mob/living/carbon/human/H = owner
	if(prob(10))
		playsound(H, pick(CREEPY_SOUNDS), 50, 1)
	if(H.getStaminaLoss() < 1)	//Cursed with being eternally slow hehehe
		H.adjustStaminaLoss(50)
	else if(H.getStaminaLoss() < 50)
		H.adjustStaminaLoss(5)

/datum/brain_trauma/special/cotard_delusion/on_lose()
	..()
	var/mob/living/carbon/human/H = owner
	H.toggle_ghostvision()
	H.set_screwyhud(SCREWYHUD_NONE)
	H.remove_trait(TRAIT_MEDIUM, TRAUMA_TRAIT)
	H.remove_trait(TRAIT_DEAF, TRAUMA_TRAIT)
	H.remove_client_colour(/datum/client_colour/greyscale)