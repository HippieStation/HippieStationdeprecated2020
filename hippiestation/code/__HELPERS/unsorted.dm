/atom/GetAllContents(var/T)
	. = ..()
	// Include items in the butt as part of "GetAllContents"
	if (istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		var/obj/item/organ/butt/B = H.getorgan(/obj/item/organ/butt)

		if (B)
			. += B.contents

/proc/list_avg(list/L)
	. = 0
	for(var/num in L)
		. += num
	. /= length(L)
	LAZYCLEARLIST(L)
