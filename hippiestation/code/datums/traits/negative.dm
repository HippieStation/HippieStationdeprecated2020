/* Hippie Bad Traits */

/datum/trait/flatulence
	name = "Involuntary flatulence"
	desc = "A spasm in the patient's sphincter will cause them to uncontrollably fart at random intervals."
	value = -1
	gain_text = "<span class='danger'>Your butt starts to twitch!</span>"
	lose_text = "<span class='notice'>Your butt settles down.</span>"
	medical_record_text = "Patient has a muscular spasm in their rectal sphincter, gaseous discharge may occour."

/datum/trait/flatulence/on_process()
	if(prob(3))
		var/obj/item/organ/butt/B = trait_holder.getorgan(/obj/item/organ/butt)
		if(!B)
			to_chat(trait_holder, "<span class='warning'>The building pressure in your colon hurts!</span>")
			trait_holder.adjustBruteLoss(rand(2,6))
		else if(prob(1))
			trait_holder.emote("superfart")
		else
			trait_holder.emote("fart")


/datum/trait/smallbutt
	name = "Small anal cavity"
	desc = "Muscular contractions cause the patient's anal cavity to be undersized."
	value = -1
	gain_text = "<span class='danger'>Your butt tenses up!</span>"
	lose_text = "<span class='notice'>Your butt muscles relax.</span>"
	medical_record_text = "Tension in the patient's butt muscles has caused their anal cavity to become small."

/datum/trait/smallbutt/add()
	var/obj/item/organ/butt/B = trait_holder.getorgan(/obj/item/organ/butt)
	if(!B)
		to_chat(trait_holder, "<span class='warning'>You somehow gained this trait without a butt, contact an admin.</span>")
		qdel(src)
	else if(B.storage_slots > 0)
		B.inv.storage_slots = initial(B.inv.storage_slots) - 1
	else
		to_chat(trait_holder, "<span class='warning'>Dat booty can't get any smaller!</span>")
		qdel(src)

/datum/trait/smallbutt/remove()
	var/obj/item/organ/butt/B = trait_holder.getorgan(/obj/item/organ/butt)
	if(!B)
		return
	else
		B.inv.storage_slots = initial(B.inv.storage_slots)

/datum/trait/advancedautism
	name = "Advanced Autism"
	desc = "Your especially powerful autism causes you to take 2 brain damage every minute."
	value = -1
	gain_text = "<span class='danger'>You feel your autism suddenly becoming far more powerful than normal!</span>"
	lose_text = "<span class='notice'>You feel your autism returning to its normal levels.</span>"

/datum/trait/advancedautism/proc/braindamage(mob/living/carbon/M)
	var/mob/living/carbon/human/H = M
	H.adjustBrainLoss(2)
	addtimer(CALLBACK(src, .proc/braindamage, H), 600)

/datum/trait/advancedautism/add()
	var/mob/living/carbon/human/H = trait_holder
	addtimer(CALLBACK(src, .proc/braindamage, H), 600)

/datum/trait/advancedautism/remove()



