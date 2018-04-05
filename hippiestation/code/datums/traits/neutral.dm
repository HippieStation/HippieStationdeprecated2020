/* Hippie Neutral Traits */
/datum/trait/monochromatic
	name = "Monochromacy"
	desc = "You suffer from full colorblindness, and perceive nearly the entire world in blacks and whites."
	value = 0
	medical_record_text = "Patient is afflicted with almost complete color blindness."

/datum/trait/monochromatic/add()
	trait_holder.add_client_colour(/datum/client_colour/monochrome)

/datum/trait/monochromatic/post_add()
	if(trait_holder.mind.assigned_role == "Detective")
		to_chat(trait_holder, "<span class='boldannounce'>Mmm. Nothing's ever clear on this station. It's all shades of gray...</span>")
		trait_holder.playsound_local(trait_holder, 'sound/ambience/ambidet1.ogg', 50, FALSE)

/datum/trait/monochromatic/remove()
	trait_holder.remove_client_colour(/datum/client_colour/monochrome)

/datum/trait/super_lungs
	name = "Super Lungs"
	desc = "Your extra powerful lungs allow you to scream much louder than normal, at the cost of losing more oxygen whenever you scream."
	value = 0
	gain_text = "<span class='notice'>You feel like you can scream louder than normal.</span>"
	lose_text = "<span class='notice'>You feel your ability to scream returning to normal.</span>"

/datum/trait/super_lungs/add()
	var/mob/living/carbon/human/H = trait_holder
	H.scream_vol = 100
	H.scream_oxyloss = 10

/datum/trait/super_lungs/remove()
	var/mob/living/carbon/human/H = trait_holder
	H.scream_vol = initial(H.scream_vol)
	H.scream_oxyloss = initial(H.scream_oxyloss)

/datum/trait/chronicbrainrot
	name = "Chronic Brainrot"
	desc = "You have a permanent, non-infectious version of brainrot that has rendered you permanently retarded and progressively gives you brain damage. However, the incredible amounts of retardation you have gained allow you to have an imaginary friend."
	value = 0
	gain_text = "<span class='danger'>You feel like you're slowly becoming dumber.</span>"
	lose_text = "<span class='notice'>You no longer feel as if you're getting dumber..</span>"
	var/has_friend = FALSE
	var/searching = FALSE

/datum/trait/chronicbrainrot/on_process()
	var/mob/living/carbon/human/H = trait_holder
	if(prob(50))
		H.adjustBrainLoss(rand(0.25, 1))
	if(!H.has_trauma_type(/datum/brain_trauma/special/imaginary_friend) && !searching)
		has_friend = FALSE
		searching = TRUE	//holy crap boolean flags are AWESOME
		addtimer(CALLBACK(src, .proc/get_trauma, H), 1200)

/datum/trait/chronicbrainrot/proc/get_trauma()
	var/mob/living/carbon/human/H = trait_holder
	if(istype(H))
		if(!H.has_trauma_type(/datum/brain_trauma/special/imaginary_friend))
			H.gain_trauma(/datum/brain_trauma/special/imaginary_friend, TRAUMA_RESILIENCE_ABSOLUTE)
			has_friend = TRUE
			searching = FALSE

/datum/trait/chronicbrainrot/add()
	var/mob/living/carbon/human/H = trait_holder
	if(istype(H) && !has_friend)
		H.gain_trauma(/datum/brain_trauma/mild/dumbness, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/trait/chronicbrainrot/remove()
	var/mob/living/carbon/human/H = trait_holder
	H.cure_trauma_type(brain_trauma_type = /datum/brain_trauma/mild/dumbness, TRAUMA_RESILIENCE_ABSOLUTE)
	H.cure_trauma_type(brain_trauma_type = /datum/brain_trauma/special/imaginary_friend, TRAUMA_RESILIENCE_ABSOLUTE)