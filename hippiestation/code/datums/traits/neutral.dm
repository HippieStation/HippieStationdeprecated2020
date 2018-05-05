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
	lose_text = "<span class='notice'>You no longer feel as if you're getting dumber...</span>"

/datum/trait/chronicbrainrot/on_process()
	var/mob/living/carbon/human/H = trait_holder
	if(prob(50))
		H.adjustBrainLoss(rand(0.25, 1))

/datum/trait/chronicbrainrot/add()
	var/mob/living/carbon/human/H = trait_holder
	if(istype(H))
		H.gain_trauma(/datum/brain_trauma/mild/dumbness, TRAUMA_RESILIENCE_ABSOLUTE)
		H.gain_trauma(/datum/brain_trauma/special/imaginary_friend, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/trait/chronicbrainrot/remove()
	var/mob/living/carbon/human/H = trait_holder
	H.cure_trauma_type(brain_trauma_type = /datum/brain_trauma/mild/dumbness, TRAUMA_RESILIENCE_ABSOLUTE)
	H.cure_trauma_type(brain_trauma_type = /datum/brain_trauma/special/imaginary_friend, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/trait/split_personality	//For testing in live, remove this once testing is complete
	name = "Split Personality"
	desc = "This trait gives you a split personality, simple as that. *THIS IS A TEMPORARY TRAIT FOR TESTING PURPOSES* bugs and/or crashes may occur from split personalities so pick this at your own risk!!"
	value = 0
	gain_text = "<span class='notice'>You now have a split personality via trait.</span>"
	lose_text = "<span class='notice'>You no longer have a split personality via trait.</span>"

/datum/trait/split_personality/add()
	var/mob/living/carbon/human/H = trait_holder
	if(istype(H))
		H.gain_trauma(/datum/brain_trauma/severe/split_personality, TRAUMA_RESILIENCE_SEVERE)

/datum/trait/split_personality/remove()
	var/mob/living/carbon/human/H = trait_holder
	H.cure_trauma_type(brain_trauma_type = /datum/brain_trauma/severe/split_personality, TRAUMA_RESILIENCE_SEVERE)