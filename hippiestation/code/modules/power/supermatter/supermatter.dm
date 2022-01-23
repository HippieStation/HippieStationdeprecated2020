/obj/machinery/power/supermatter_crystal/proc/hippie_sm_virgin_sacrifice(mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.has_dna() && istype(H.dna.species, /datum/species/human/felinid/tarajan))
			visible_message("<span class='notice'>\The [src] visibly calms down as [H] is consumed...</span>")
			power *= 0.75
			matter_power *= 0.75
			return TRUE
	return FALSE