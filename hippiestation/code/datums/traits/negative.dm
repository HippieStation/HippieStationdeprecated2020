/* Hippie Bad Traits */

/datum/quirk/flatulence
	name = "Involuntary flatulence"
	desc = "A spasm in the patient's sphincter will cause them to uncontrollably fart at random intervals."
	value = -1
	gain_text = "<span class='danger'>Your butt starts to twitch!</span>"
	lose_text = "<span class='notice'>Your butt settles down.</span>"
	medical_record_text = "Patient has a muscular spasm in their rectal sphincter, gaseous discharge may occour."

/datum/quirk/flatulence/on_process()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		if(prob(3))
			var/obj/item/organ/butt/B = quirk_holder.getorgan(/obj/item/organ/butt)
			if(!B)
				to_chat(quirk_holder, "<span class='warning'>The building pressure in your colon hurts!</span>")
				quirk_holder.adjustBruteLoss(rand(2,6))
			else if(prob(1))
				quirk_holder.emote("superfart")
			else
				quirk_holder.emote("fart")


/datum/quirk/smallbutt
	name = "Small anal cavity"
	desc = "Muscular contractions cause the patient's anal cavity to be undersized."
	value = -1
	gain_text = "<span class='danger'>Your butt tenses up!</span>"
	lose_text = "<span class='notice'>Your butt muscles relax.</span>"
	medical_record_text = "Tension in the patient's butt muscles has caused their anal cavity to become small."

/datum/quirk/smallbutt/add()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		var/obj/item/organ/butt/B = quirk_holder.getorgan(/obj/item/organ/butt)
		if(!B)
			to_chat(quirk_holder, "<span class='warning'>You somehow gained this trait without a butt, contact an admin.</span>")
			qdel(src)
			return

		GET_COMPONENT_FROM(STR, /datum/component/storage, B)
		if(STR.max_items > 0)
			STR.max_items = STR.max_items - 1
		else
			to_chat(quirk_holder, "<span class='warning'>Dat booty can't get any smaller!</span>")
			qdel(src)

/datum/quirk/smallbutt/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		var/obj/item/organ/butt/B = quirk_holder.getorgan(/obj/item/organ/butt)
		if(!B)
			return

		GET_COMPONENT_FROM(STR, /datum/component/storage, B)
		STR.max_items = STR.max_items + 1
