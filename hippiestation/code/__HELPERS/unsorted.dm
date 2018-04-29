/atom/GetAllContents(var/T)
	. = ..()
	var/mob/living/carbon/human/H = src
	// Include items in the butt as part of "GetAllContents"
	if (H)
		var/obj/item/organ/butt/B = H.getorgan(/obj/item/organ/butt)

		if (B)
			. += B.contents